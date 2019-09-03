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
	<script type="text/javascript" src='<e:url value="/pages/telecom_Index/sub_grid/js/heatmap.js"/>'></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/Heatmap.css"/>' rel="stylesheet" type="text/css" media="all" />
	

     <script type="text/javascript">
     
      
      
      
      
        $(document).ready(function(e) {
        	 
     
         
        });
    </script>
     <script type="text/javascript">
        var map;
        var heatLayer;
        var featureLayer;

        require(["esri/map", "esri/geometry/Extent","esri/symbols/SimpleMarkerSymbol",
                 "esri/symbols/SimpleLineSymbol", "esri/symbols/SimpleFillSymbol", "esri/graphic","esri/tasks/FeatureSet",  "esri/geometry/Point", "esri/SpatialReference",  "esri/layers/ArcGISTiledMapServiceLayer", "esri/layers/FeatureLayer","esri/layers/GraphicsLayer", "esri/tasks/query",
                     "bism/HeatmapLayer", "dojo/dom", "dojo/on", "dojo/domReady!"],
                     function (Map, Extent,SimpleMarkerSymbol,SimpleLineSymbol,SimpleFillSymbol,Graphic,FeatureSet, Point,SpatialReference,ArcGISTiledMapServiceLayer, FeatureLayer,GraphicsLayer, Query, HeatmapLayer, dom, on) {
         
                    var circleSymb = new SimpleFillSymbol(
        	          SimpleFillSymbol.STYLE_NULL,
        	          new SimpleLineSymbol(
        	            SimpleLineSymbol.STYLE_SHORTDASHDOTDOT,
        	            new esri.Color([105, 105, 105]),
        	            2
        	          ), new esri.Color([255, 255, 0, 0.25])
        	        );  
             
                map = new esri.Map("map", {
                   
                    sliderStyle: "small" 
                });
                var basemap = new ArcGISTiledMapServiceLayer("http://135.149.48.47:6080/arcgis/rest/services/NewMap/dingxi/MapServer");
                map.addLayer(basemap);
                map.on('load', function (theMap) {
                	map.setZoom(2);
                	try{
                    heatLayer = new HeatmapLayer({
                        config: {
                            "useLocalMaximum": true,
                            "radius": 40,
                            "gradient": {
                                0.45: "rgb(0,184,236)",
                                0.55: "rgb(255,201,0)",
                                0.65: "rgb(108,179,252)",
                                0.95: "rgb(255,255,000)",
                                1.00: "rgb(249,135,101)"
                            }
                        },
                        "map": map,
                        "domNodeId": "heatLayer",
                        "opacity": 0.85
                    });
                	}catch(ex){alert(ex);}
                 
                    // 在地图中将热度图图层
                    map.addLayer(heatLayer);
                    map.resize();
                    /* var a2=new esri.geometry.Point(103.58804, 36.20618, map.spatialReference);
                    var attr2 = {"count":2};
				    var g2=new Graphic(a2, circleSymb,attr2); 
				   
				    featureLayer = new FeatureLayer("http://135.149.48.47:6080/arcgis/rest/services/grid/new_sub_grid_netpoint2/MapServer/0", {
                        mode: FeatureLayer.MODE_ONDEMAND,
                      visible: true
                     }); */
                //  map.addLayer(featureLayer);
                  //featureLayer.applyEdits([g2], null, null);
              
                  getFeatures();
                
                    // 处理地图显示范围改变事件
               
                  map.on("extent-change", getFeatures);
                  
                  
                });
                function getHeadDataList(){
                	 var featureSet = new FeatureSet(); var features= [];
                	 var query4url = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=';
                	 
                	    $.ajax({
							type : "post",
							url:'<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>',
							data : {
								 
								"eaction" : "heatData"
							},
							async : false,
							dataType : "json",
							success : function(data) {
							    
								 $.each(data,function(index,obj) {  
									   try{
									       var a1=new esri.geometry.Point(obj.LONGITUDE, obj.LATITUDE, map.spatialReference);
									      
									       var attr1 = {"count":obj.numval};
									       var g1=new Graphic(a1, circleSymb,attr1); 
									    
									       features.push(g1);
									       
									   }catch(ex){
										   alert(ex);
									   }
					             });
							}
					   });
                  
                   
                     featureSet.features = features;
                   
                     heatLayer.setData(featureSet.features);
                }
           
                // 从要素图层中的得到当前显示范围中的所有要素
                function getFeatures() {
                	getHeadDataList();
                	
                }
                function removeg(){
                	 // 创建查询
                    var query = new Query();
                    // 只查询当前显示范围内的要素
                    query.geometry = map.extent;
                    query.where = "1=1";
                    query.outSpatialReference = map.spatialReference;
                    
                    featureLayer.queryFeatures(query, function (featureSet) {
                        var data = [];
                        if (featureSet && featureSet.features && featureSet.features.length > 0) {
                            data = featureSet.features;
                            for(var i=0;i<data.length;i++){
                            	 
                            	featureLayer.remove(data[i]);
                            }
                        }
                        
                    });
                    featureLayer.redraw();
                }

            });
    </script>
</head>
<body>
 
  <div id="main">
        <div id="heatmapArea">
            <div id="heatLayer"></div>
            <div id="map"></div>
        
        </div>
        
       
    </div>
</body>
</html>
 