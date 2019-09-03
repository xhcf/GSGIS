<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>区县地图</title>
    <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.3"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <!--<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>-->
    	<script type="text/javascript" src='<e:url value="/resources/component/echarts_new/3.8.5/echarts.js"/>'></script>
    <!-- echarts 3.2.3 -->
    <script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js?version=4.1"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/scripts/admin.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/esri.symbol.MultiLineTextSymbol.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <%--<script src='<e:url value="/pages/telecom_Index/common/js/Marquee.js?version=1.2"/>' charset="utf-8"></script>--%>
    <script src='<e:url value="/pages/telecom_Index/common/js/left_menu_control.js?version=1.1"/>'
            charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/sub_grid/js/mapTran.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/sub_grid/js/WKTUtil.js"/>' charset="utf-8"></script>

    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=1.3"/>'
          rel="stylesheet" type="text/css" media="all"/>

    <script src='<e:url value="/pages/telecom_Index/common/js/bureau_geo_center.js?version=1.4"/>'
            charset="utf-8"></script>
		<link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_org_frame.css?version=1.1.15"/>' rel="stylesheet" type="text/css" media="all" />
	  <link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.8"/>' rel="stylesheet" type="text/css" media="all" />
	  <!--<link href='<e:url value="/pages/telecom_Index/common/css/build_view_new.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all" />-->
</head>
<body>
	<script>
	var featureLayer = "";
	var featureLayer1 = "";
    var map = "";
    var village_where = "zy_grid_id in (";
    require(["esri/config",
                "esri/Color",
                "esri/graphic",
                "esri/graphicsUtils",
                "esri/map",
                "esri/dijit/OverviewMap",
                "esri/dijit/Scalebar",
                "esri/geometry/Polygon",
                "esri/geometry/Point",
                "esri/geometry/Polyline",
                "esri/geometry/Multipoint",
                "esri/geometry/Circle",
                "esri/layers/ArcGISDynamicMapServiceLayer",
                "esri/layers/ArcGISTiledMapServiceLayer",
                "esri/layers/FeatureLayer",
                "esri/layers/GraphicsLayer",
                "esri/layers/LabelLayer",
                "esri/layers/ImageParameters",
                "esri/renderers/ClassBreaksRenderer",
                "esri/renderers/SimpleRenderer",
                "esri/renderers/UniqueValueRenderer",
                "esri/symbols/SimpleFillSymbol",
                "esri/symbols/SimpleLineSymbol",
                "esri/symbols/SimpleMarkerSymbol",
                "esri/symbols/Font",
                "esri/symbols/TextSymbol",
                "esri/symbols/PictureMarkerSymbol",
                "esri/SpatialReference",
                "esri/tasks/FeatureSet",
                "esri/tasks/IdentifyTask",
                "esri/tasks/IdentifyParameters",
                "esri/tasks/query",
                "esri/tasks/QueryTask",
                "esri/tasks/Geoprocessor",
                "esri/tasks/GeometryService",
                "esri/toolbars/draw",
                "esri/toolbars/navigation",
                "esri/units",
                "CustomModules/ChartInfoWindow",
                "CustomModules/CustomTheme",
                "CustomModules/geometryUtils",
                "dijit/registry",
                "dijit/form/Button",
                "dojo/_base/connect",
                "dojo/_base/array",
                "dojo/_base/window",
                "dojo/dom-construct",
                "dojo/parser",
                "dojo/query",
                "dojox/charting/Chart",
                "dojox/charting/action2d/Highlight",
                "dojox/charting/action2d/Tooltip",
                "dojox/charting/plot2d/ClusteredColumns",
                "dojo/domReady!"],
                function (Config,
                          Color,
                          Graphic,
                          graphicsUtils,
                          Map,
                          OverviewMap,
                          Scalebar,
                          Polygon,
                          Point,
                          Polyline,
                          Multipoint,
                          Circle,
                          Dynamic,
                          ArcGISTiledMapServiceLayer,
                          FeatureLayer,
                          GraphicsLayer,
                          LabelLayer,
                          ImageParameters,
                          ClassBreaksRenderer,
                          SimpleRenderer,
                          UniqueValueRenderer,
                          SimpleFillSymbol,
                          SimpleLineSymbol,
                          SimpleMarkerSymbol,
                          Font,
                          TextSymbol,
                          PictureMarkerSymbol,
                          SpatialReference,
                          FeatureSet,
                          IdentifyTask,
                          IdentifyParameters,
                          Query,
                          QueryTask,
                          Geoprocessor,
                          GeometryService,
                          Draw,
                          Navigation,
                          Units,
                          ChartInfoWindow,
                          CustomTheme,
                          geometryUtils,
                          registry,
                          connect,
                          array,
                          win,
                          domConstruct,
                          parser,
                          query,
                          Chart,
                          Highlight,
                          Tooltip,
                          ClusteredColumns
                      ) {


                    var getGravityCenter = function (polygon, temp) {
                        var ext = polygon.getExtent();
                        var p0 = new Point(ext.xmin, ext.ymin, new SpatialReference({wkid: 4326}));
                        var momentX = 0;
                        var momentY = 0;
                        var weight = 0;
                        for (var j = 0; j < temp.length; j++) {
                            var pts = temp[j];
                            for (var m = 0; m < pts.length; m++) {
                                var p1 = polygon.getPoint(j, m);
                                var p2;
                                if (m == pts.length - 1) {
                                    p2 = polygon.getPoint(j, 0);
                                } else {
                                    p2 = polygon.getPoint(j, m + 1);
                                }
                                var dWeight = (p1.x - p0.x) * (p2.y - p1.y) - (p1.x - p0.x) * (p0.y - p1.y) / 2 - (p2.x - p0.x) * (p2.y - p0.y) / 2 - (p1.x - p2.x) * (p2.y - p1.y) / 2;
                                weight += dWeight;
                                var pTmp = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2, new SpatialReference({wkid: 4326}));
                                var gravityX = p0.x + (pTmp.x - p0.x) * 2 / 3;
                                var gravityY = p0.y + (pTmp.y - p0.y) * 2 / 3;
                                momentX += gravityX * dWeight;
                                momentY += gravityY * dWeight;
                            }
                        }
                        var bbb = new Point(momentX / weight, momentY / weight, new SpatialReference({wkid: 4326}));
                        return bbb;
                    }

                    Config.defaults.io.proxyUrl = "http://135.149.64.140:8888/proxy/proxy.jsp";
                    Config.defaults.io.alwaysUseProxy = false;

                    map = new Map("gismap");

                    //下面一行的括号里写服务的路径，最后的数字是对应的图层，例如支局6，营销网格5，资源网格4
                    featureLayer = new FeatureLayer("http://135.192.71.205:6080/arcgis/rest/services/yxpbdbqh/yxpbdbqh_971/MapServer/5", {
                        //definitionExpression: "",
                        mode: FeatureLayer.MODE_SNAPSHOT,
                        //mode: FeatureLayer.MODE_ONDEMAND,
                        outFields: ["*"],
                        visible: true,
                        opacity: 1
                    });

                    featureLayer1 = new FeatureLayer("http://135.192.71.205:6080/arcgis/rest/services/yxpbdbqh/yxpbdbqh_971/MapServer/2", {
                        //definitionExpression: "",
                        mode: FeatureLayer.MODE_SNAPSHOT,
                        //mode: FeatureLayer.MODE_ONDEMAND,
                        outFields: ["*"],
                        visible: true,
                        opacity: 1
                    });
                    //featureLayer.setDefinitionExpression(substation_str);

                    featureLayer.on("update-end", function () {
                        return;
                        var graphicses = featureLayer.graphics;
                        for (var i = 0, l = graphicses.length; i < l; i++) {
                            var gra = graphicses[i];
                            var geo = gra.geometry;
                            var temp = geo.rings;
                            var name_point = getGravityCenter(geo, temp);
                            console.log("'" + gra.attributes.GRID_NO + "':[" + name_point.x + "," + name_point.y + "]");
                            //这里将打印 "  id:坐标  "  注意根据服务里的字段做修改，例如服务里的网格id是GRID_NO， xy分别是纬度，经度
                        }
                    });

                    map.addLayer(featureLayer);
                    featureLayer1.hide();
                    map.addLayer(featureLayer1);

                    featureLayer.on("click",function(evt){
                        var grid_no = evt.graphic.attributes.GRID_NO;
                        featureLayer.hide();

                        featureLayer1.show();
                    });
                }
    )
	</script>
    <div id="gismap" name="gismap"
         style="text-align: left;background-image: url('bgg.jpg');background-repeat: no-repeat;background-size:100% 100%;-moz-background-size:100% 100%;z-index:5;"></div>
    </div>
</body>
</html>