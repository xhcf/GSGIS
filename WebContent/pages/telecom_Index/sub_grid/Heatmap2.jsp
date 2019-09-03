<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
 
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>区县地图</title>
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/Heatmap2.css"/>' rel="stylesheet" type="text/css" media="all" />

	

   <script>
   require(["esri/map", "esri/layers/FeatureLayer", "esri/layers/ArcGISTiledMapServiceLayer","esri/symbols/SimpleMarkerSymbol", "esri/symbols/SimpleLineSymbol", "esri/symbols/SimpleFillSymbol",
            "esri/renderers/SimpleRenderer", "esri/Color", "esri/graphic","esri/tasks/FeatureSet",  "esri/geometry/Point", "esri/SpatialReference", 
            "CustomModules/ChartInfoWindow", "CustomModules/CustomTheme", "CustomModules/geometryUtils",
            "dojo/_base/array", "dojo/dom-construct", "dojo/_base/window",
            "dojox/charting/Chart", "dojox/charting/action2d/Highlight", "dojox/charting/action2d/Tooltip", "dojox/charting/plot2d/ClusteredColumns",
            "dojo/domReady!"
        ], function (
          Map, FeatureLayer, ArcGISTiledMapServiceLayer,SimpleMarkerSymbol,
          SimpleLineSymbol, SimpleFillSymbol,
          SimpleRenderer, Color,Graphic,FeatureSet, Point,SpatialReference, ChartInfoWindow, CustomTheme, geometryUtils,
          array, domConstruct, win,
          Chart, Highlight, Tooltip
        ) {

	   var map = new Map("map", {
           center: [-95.625, 39.243],
           zoom: 4,
           slider: false
       });
       var agoServiceURL = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer";
       var agoLayer = new ArcGISTiledMapServiceLayer(agoServiceURL);
       map.addLayer(agoLayer);
 
    var featureLayer = new FeatureLayer("http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Specialty/ESRI_StateCityHighway_USA/MapServer/1", {
        mode: FeatureLayer.MODE_SNAPSHOT,
        outFields: ["WHITE",  "ASIAN_PI", "OTHER"]
    });
    var defaultSymbol = new SimpleFillSymbol().setStyle(SimpleFillSymbol.STYLE_NULL);
    var renderer = new SimpleRenderer(defaultSymbol);
    featureLayer.setRenderer(renderer);
    featureLayer.on("update-end", function (evt) {
        var showFields = ["WHITE",  "ASIAN_PI", "OTHER"];
        createChartInfoWindow(featureLayer, showFields);
    });
    map.addLayer(featureLayer);
    
    map.on('load', function (theMap) {
    	try{
    	   var markerSymbol = new SimpleMarkerSymbol();
    	    markerSymbol.setPath("M16,4.938c-7.732,0-14,4.701-14,10.5c0,1.981,0.741,3.833,2.016,5.414L2,25.272l5.613-1.44c2.339,1.316,5.237,2.106,8.387,2.106c7.732,0,14-4.701,14-10.5S23.732,4.938,16,4.938zM16.868,21.375h-1.969v-1.889h1.969V21.375zM16.772,18.094h-1.777l-0.176-8.083h2.113L16.772,18.094z");
    	    markerSymbol.setColor(new Color("#00FFFF"));
    	var a2=new esri.geometry.Point(103.58804,36.20618,map.spatialReference);
        var attr2 = {"count":2};
	    var g2=new Graphic(a2, markerSymbol,attr2);
	    map.graphics.add(g2);}catch(ex){alert(ex);}
    });

    function createChartInfoWindow(layer, showFields) {
        var layerId = layer.id;
        //showFields 修订 需要统计的字段
        var max = maxAttribute(layer.graphics, showFields);//修订 获取最大值
        var featureSums = [];//修订   实际指标数组值 
        array.forEach(layer.graphics, function (graphic) {
            var sum = 0;
            for (var i = 0, j = showFields.length; i < j; i++) {
                sum += graphic.attributes[showFields[i]];
            }

            featureSums.push(sum);
        });
        var sumMax = -10000;
        array.forEach(featureSums, function (featureSum) {
            if (sumMax < featureSum) sumMax = featureSum;
        });

        var optinalChart = null;
        array.forEach(layer.graphics, function (graphic, index) {
            var infoWindow = new ChartInfoWindow({
                domNode: domConstruct.create('div', null, document.getElementById('map'))
            });
            infoWindow.setMap(map);

            var nodeChart = null;
            //layer.graphics[index].attributes 修订 数据集合中的所有字段
            nodeChart = domConstruct.create("div", { id: 'nodeTest' + index, style: "width:40px;height:80px" }, win.body());
            var chart = makeChart(nodeChart, layer.graphics[index].attributes, showFields, max);
            optinalChart = chart;
            infoWindow.resize(50, 101);

            var labelPt = geometryUtils.getPolygonCenterPoint(graphic.geometry);//修订 面状重心点
            infoWindow.setContent(nodeChart);
            infoWindow.__mcoords = labelPt;
            infoWindow.show(map.toScreen(labelPt));
        });
    }

    function maxAttribute(graphics, showFields) {
        var max = -100000;
        array.forEach(graphics, function (graphic) {
            var attributes = graphic.attributes;
            for (var i = 0, j = showFields.length; i < j; i++) {
                if (max < attributes[showFields[i]]) {
                    max = attributes[showFields[i]];
                }
            }
        });

        return max;
    }

    function makeChart(node, attributes, showFields, max) {
        var chart = new Chart(node, { margins: { l: 0, r: 0, t: 0, b: 0 } }).
                        setTheme(CustomTheme).
                        addPlot("default", { type: "Columns", gap: 0 });
        var serieValues = [];
        var length = showFields.length;
        for (var i = 0; i < length; i++) {
            serieValues = [];
            for (var m = 0; m < i; m++) {
                serieValues.push(0);
            }
            serieValues.push(attributes[showFields[i]]);
            chart.addSeries(showFields[i], serieValues, { stroke: { color: "black" } });
        }

        serieValues = [];
        for (var k = 0; k < length; k++) {
            serieValues.push(0);
        }
        serieValues.push(max);
        chart.addSeries("隐藏", serieValues, { stroke: { color: new Color([0x3b, 0x44, 0x4b, 0]) }, fill: "transparent" });

        var anim1 = new Highlight(chart, "default", {
            highlight: function (e) {
                if (e.a == 0 && e.r == 0 && e.g == 0 && e.b == 0) {
                }
                else {
                    return "lightskyblue";
                }
            }
        });
        var anim2 = new Tooltip(chart, "default", {
            text: function (o) {
                var fieldName = o.chart.series[o.index].name;
                if (fieldName == "隐藏") return "";
                return (fieldName + "：" + o.y);
            }
        });
        chart.render();

        return chart;
    }
    
    
  });
</script>

</head>
<body class="claro">
    <div id="map"></div>
</body>
</html>
 