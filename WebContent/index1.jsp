<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" pageEncoding="UTF-8"	contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
  <head>
    <title>Simple Map</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/GSgis/arcgis_js/esri/css/esri.css" />
      <style type="text/css">  
        @import "http://localhost:8080/GSgis/arcgis_js/dojo/resources/dojo.css";
        @import "http://localhost:8080/GSgis/arcgis_js/dijit/themes/dijit.css";  
        @import "http://localhost:8080/GSgis/arcgis_js/dijit/themes/tundra/tundra.css";  
    </style>  
    <style>  
        html, body, #map {  
            height: 100%;  
            margin: 0;  
            padding: 0;  
        }  
        body {  
            background-color: #FFF;  
            overflow: hidden;  
            font-family: "Trebuchet MS";  
        }  
    </style> 
    <script type="text/javascript" src="http://localhost:8080/GSgis/arcgis_js/init.js"></script>
    <!-- <script src="http://localhost:8080/GSgis/arcgis_js/"></script> -->  
 	<script src="<%=path%>/pages/js/jquery.js"></script>
    <script>
  	  var map;
  	  //var graLayer;
  	  var visible=[], setLayerVisibility;
  	  require(["esri/map", 
  	           "esri/geometry/Polygon", 
  	           "esri/layers/GraphicsLayer",
               "esri/layers/FeatureLayer",
  	           "esri/layers/ArcGISDynamicMapServiceLayer",
  	           "esri/layers/ArcGISTiledMapServiceLayer",
  	           "esri/tasks/IdentifyTask",
  	           "esri/tasks/IdentifyParameters",
  	           "esri/tasks/FindTask",
  	           "esri/tasks/FindParameters",
  	           "esri/tasks/FindResult",
  	           "esri/symbols/SimpleFillSymbol",
  	           "esri/symbols/SimpleMarkerSymbol",
  	           "esri/symbols/SimpleLineSymbol",
  	           "esri/graphic",
  	           "dojo/domReady!"],
      function(Map, Polygon,GraphicsLayer,FeatureLayer,Dynamic,Tiled,IdentifyTask,IdentifyParameters,FindTask,FindParameters,FindResult,SimpleFillSymbol,SimpleMarkerSymbol,SimpleLineSymbol,Graphic)
      {
  		 //map = new Map("mymap");
  		 map = new Map("map", {logo:false,slider: true});
         //map.setBasemap("gray");
  		 //兰州
		 var tiled = new Tiled("http://135.149.48.47:6080/arcgis/rest/services/NewMap/lanzhou/MapServer");
  		 //白银
		 //var tiled = new Tiled("http://135.149.48.47:6080/arcgis/rest/services/NewMap/baiyin/MapServer");
  		 //定西
		 //var tiled = new Tiled("http://135.149.48.47:6080/arcgis/rest/services/NewMap/jiayuguan/MapServer");
  		 map.addLayer(tiled);
  		  
  		 //var dyn = new Dynamic("http://135.149.48.47:6080/arcgis/rest/services/NewMap/lanzhou/MapServer");
         //map.addLayer(dyn);
         var dyn1 = new Dynamic("http://135.149.48.48:6080/arcgis/rest/services/GXgrid/grid/MapServer");
         //var dyn1 = new Dynamic("http://135.149.48.47:6080/arcgis/rest/services/grid/gs_grid/MapServer");
         map.addLayer(dyn1);
         /* graLayer = new GraphicsLayer();
		 map.addLayer(graLayer);
		 map.on("load", addGraphics);
		 function addGraphics() {
			  var fillsymbol = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.5]));
			  var polygon = new Polygon(map.spatialReference);
			  polygon.addRing([[101.632,33.877],[101.606,33.711],[101.796,33.544],[101.932,33.685],[101.888,33.774],[101.632,33.877]]);
			  var graphic = new Graphic(polygon,fillsymbol);
			  graLayer.add(graphic);
		 } */
          dojo.connect(dyn1,"onLoad",loadLayerList);
          function loadLayerList(layers){
              var html="";
              var infos=layers.layerInfos;
              for(var i= 0,length=infos.length;i<length;i++){
                  var info = infos[i];
                  //图层默认显示的话就把图层id添加到visible  
                 if(info.defaultVisibility && info.id == '2')
                  { 
                      visible.push(info.id);
                  }  
                  //输出图层列表的html  
                  html=html+"<div><input id='"+info.id+"' name='layerList' class='listCss' type='checkbox' value='checkbox' onclick='setLayerVisibility()' "+(info.defaultVisibility ? "checked":"")+" />"+info.name+"</div>";  
              }
              //设置可视图层  
              //visible = [];
              dyn1.setVisibleLayers(visible);
              //在右边显示图层名列表 
              dojo.byId("toc").innerHTML=html;
              
              var input1 = dojo.byId("0");
              var input2 = dojo.byId("1");
              input1.checked = false;
              input2.checked = false;
          }
          var lay_valid = 1;
          setLayerVisibility = function()
          {  
              //用dojo.query获取css为listCss的元素数组  
              var inputs = dojo.query(".listCss");  
              visible = [];   
              for(var i=0;i<inputs.length;i++)  
              {  
                  if(inputs[i].checked)  
                  {  
                      visible.push(inputs[i].id);
                  }  
              }  
              if(visible.length === 0)
              {  
                  visible.push(-1);  
              } 
              dyn1.setVisibleLayers(visible);
              lay_valid = visible[visible.length-1];
          }

          query4mark = function(resid){
              console.log(resid);
              var graphicsLayer = new GraphicsLayer();
              var myPoint = {"geometry":{"x":103.797,"y":32.266}};
              var pointGra = new Graphic(myPoint);
              graphicsLayer.add(pointGra);
          }

          dojo.connect(map, "onMouseMove", function showCoordinates(evt)
          {
        	  console.log("lay_valid:"+lay_valid);
              var gra = map.graphics;
              if(gra)
         	    map.graphics.clear();
              else
                return;
        	  if(lay_valid<0)
        		  return;
        	  
        	  var pt =evt.mapPoint;
              dojo.byId("info").innerHTML = pt.x.toFixed(3) + ", " + pt.y.toFixed(3);
              var identifyTask, identifyParams;
              identifyTask = new IdentifyTask("http://135.149.48.48:6080/arcgis/rest/services/GXgrid/grid/MapServer"); 
     	      identifyParams = new IdentifyParameters();//查询参数  
     	      identifyParams.tolerance = 2;//容差范围  
     	      identifyParams.returnGeometry = true;//是否返回图形  
     	      identifyParams.layerIds = [lay_valid];//查询图层   
     	      identifyParams.layerOption = IdentifyParameters.LAYER_OPTION_VISIBLE;//设置查询的图层
     	      identifyParams.geometry = evt.mapPoint;
              identifyParams.mapExtent = map.extent;
              identifyTask.execute(identifyParams, function (results) {
           	  	 	if(results.length==0)
           	  			return;
           	  	 	var feature = results[0].feature;
                    map.infoWindow.setTitle("当前属性");
                    map.infoWindow.resize(200,80);
                    if(lay_valid>0){
	                    map.infoWindow.setContent("<span>地区:</span>"  
	                            + feature.attributes.RESNO  
	                            + "<br>"  
	                            + "<span>名称:</span>"  
	                            + feature.attributes.RESNAME);
                    }else{
                    	map.infoWindow.setContent("<span>店名:</span>"  
	                            + feature.attributes.CHANNEL_NA  
	                            + "<br>"  
	                            + "<span>地址:</span>"  
	                            + feature.attributes.CHANNEL_AD);
                    }
                    var graphic = "";
                    
                    if(lay_valid>0){
                   	 	var fillsymbol = new SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.5]));
                     	graphic = new esri.Graphic(feature.geometry, fillsymbol);
                    }else{
                   	 	var markersymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE,5,new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
                   			    new dojo.Color([255,0,0,1]),
                   			    new dojo.Color([0,255,0,0.25])));
                     	graphic = new esri.Graphic(feature.geometry, markersymbol);
                    }
                    map.graphics.add(graphic);
                    map.infoWindow.show(evt.screenPoint);
              });
          });
          
          var mapCenter = new esri.geometry.Point(103.847, 36.0473, map.spatialReference);
          map.centerAndZoom(mapCenter,2);
          
          $("#btn4query").click(function(){
                $("#queryRes").empty();
                var key = $("#key4query").val();
                //FindTask,FindParameters,FindResult
                var findTask, findParams;
                findTask = new FindTask("http://135.149.48.48:6080/arcgis/rest/services/GXgrid/grid/MapServer");
                findParams = new FindParameters();//查询参数
                findParams.layerIds = [lay_valid];
                if(lay_valid==0)
                    findParams.searchFields = ["CLASS4"];
                else {
                    findParams.searchFields = ["RESNAME"];
                }
                findParams.contains = true;
                findParams.searchText = key;
                findTask.execute(findParams, function (results) {
                    console.log(results);
                    if(results.length<=0)
                        return;

                    var queryRes = "";
                    for(var i = 0,l = results.length;i<l;i++){
                            var res = results[i];
                            var feature = res.feature;
                            var attrs = feature.attributes;
                            queryRes += "<button class=\"queryBtn\" onclick=\"query4mark('"+attrs.RESID+"')\" >"+attrs.RESNAME+"</button>"+"&nbsp;";
                            var x = attrs.X;
                            var y = attrs.Y;

                            //var pointGra=new esri.Graphic(feature,symbol,attrs,infoTemplate);

                            //graphicLayer.add(pointGra);
                          /*var markersymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE,5,new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
                                  new dojo.Color([255,0,0,1]),
                                  new dojo.Color([0,255,0,0.25])));
                          graphic = new esri.Graphic(feature.geometry, markersymbol);*/

                          /*switch (attrs.Shape)
                          {
                              case "Point":
                                  var symbol = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_SQUARE, 10, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0,255,0]), 1), new dojo.Color([0,255,0,0.25]));
                                  break;
                              case "Polyline":
                                  var symbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_DASH, new dojo.Color([0,255,0]), 1);
                                  break;
                              case "Polygon":
                                  var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_NONE, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_DASHDOT, new dojo.Color([0,255,0]), 2), new dojo.Color([255,255,0,0.25]));
                                  break;
                          }
                          //设置显示样式
                          res.feature.setSymbol(symbol);
                          //添加到graphics进行高亮显示
                          map.graphics.add(res.feature);*/
                    }
                    $("#queryRes").append(queryRes);
                });
              });

              $("input[name='area']").eq(0).attr("checked",true);
              $("input[name='area']").click(function(){
                  var area = $(this).val();
                  console.log(area);
                  map.removeLayer(tiled);
                  if(area==1){//兰州
                      tiled = new Tiled("http://135.149.48.47:6080/arcgis/rest/services/NewMap/lanzhou/MapServer");
                  }
                  if(area==2){//白银
                      tiled = new Tiled("http://135.149.48.47:6080/arcgis/rest/services/NewMap/baiyin/MapServer");
                  }
                  map.addLayer(tiled);
              });

                var feature1 = "";
                //$("input[name='showRound']").attr("checked",true);
                $("input[name='showRound']").click(function(){
                  if($(this).is(":checked")){
                      //map.setBasemap("gray");
                     // feature1 = new FeatureLayer("http://135.149.48.48:6080/arcgis/rest/services/grid/gs_grid/MapServer");
                     // map.addLayer(feature1,0);
                  }else{
                      //map.setBasemap("dark-gray");
                      //map.removeLayer(feature1);
                  }
              });
          }
      ); 
  	 
  	 //dojo.connect(map, "ondblclick", clearGraphics);
  	 /*function clearGraphics()
 	 {
  		 graLayer.clear();
 	 }*/

    </script> 
  </head>
  <body>
    <div id="map" style="width:100%; height:100%; border:1px solid #000; background-color:#181818;">
    	<div id="toc" style="position: absolute; left: 5px; bottom: 50px; border: 1px solid #9c9c9c; background: #fff; width: 100px; height: 150px; z-index: 99;padding: 10px;"></div>  
    	<div id = "info" style="color:#fff;"></div>
    	<div id="queryForm"><input id="key4query"/><button id="btn4query">查询</button></div>
        <div id="queryRes" style="color:#fff;"></div>
        <div style="color:#fff;"><input type="radio" name="area" value="1">兰州<input type="radio" name="area" value="2">白银</div>
        <div style="color:#fff;"><input type="checkbox" name="showRound">显示周边地图</div>
    </div>
  </body>
</html>