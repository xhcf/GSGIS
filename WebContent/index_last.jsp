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
    <link rel="stylesheet" type="text/css" href="https://js.arcgis.com/3.19/esri/css/esri.css" />
      <style type="text/css">  
        @import "http://js.arcgis.com/3.19/dojo/resources/dojo.css";  
        @import "http://js.arcgis.com/3.19/dijit/themes/dijit.css";  
        @import "http://js.arcgis.com/3.19/dijit/themes/tundra/tundra.css";  
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
    <script type="text/javascript" src="http://js.arcgis.com/3.19/init.js"></script>
    <script src="http://js.arcgis.com/3.19/"></script>  
 	<script src="<%=path%>/pages/js/jquery.js"></script>
    <script>
  	  var map;
  	  var graLayer;
  	  var visible=[], setLayerVisibility;
  	  require(["esri/map", "esri/geometry/Polygon", "esri/layers/GraphicsLayer","esri/layers/ArcGISDynamicMapServiceLayer","esri/layers/ArcGISTiledMapServiceLayer","esri/tasks/IdentifyTask","esri/tasks/IdentifyParameters","esri/graphic","dojo/domReady!"],
      function(Map, Polygon,GraphicsLayer,Dynamic,Tiled,IdentifyTask,IdentifyParameters,Graphic) 
      {
  		  //map = new Map("mymap");
  		  map = new Map("map", {logo:false,slider: true});  
          //var tiled = new Tiled("http://135.149.48.47:6080/arcgis/rest/services/NewMap/lanzhou/MapServer");
          // map.addLayer(tiled);
          var dyn = new Dynamic("http://135.149.48.47:6080/arcgis/rest/services/map/gansu_basemap/MapServer");
          map.addLayer(dyn);
          var dyn1 = new Dynamic("http://135.149.48.48:6080/arcgis/rest/services/GXgrid/grid/MapServer");
          map.addLayer(dyn1);
          graLayer = new GraphicsLayer();
		  map.addLayer(graLayer);
          /* map.on("load", addGraphics);
		  function addGraphics() {

				  var fillsymbol = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.5]));
				  var polygon = new Polygon(map.spatialReference);
				  polygon.addRing([[101.632,33.877],[101.606,33.711],[101.796,33.544],[101.932,33.685],[101.888,33.774],[101.632,33.877]]);
				  var graphic = new Graphic(polygon,fillsymbol);
				  graLayer.add(graphic);  
		        
		  }*/
          dojo.connect(dyn2,"onLoad",loadLayerList);  
          function loadLayerList(layers){  
              var html=""  
              var infos=layers.layerInfos;  
              for(var i= 0,length=infos.length;i<length;i++){  
                  var info = infos[i];  
                  //图层默认显示的话就把图层id添加到visible  
                 if(info.defaultVisibility)  
                  { 
                      visible.push(info.id);  
                  }  
                  //输出图层列表的html  
                  html=html+"<div><input id='"+info.id+"' name='layerList' class='listCss' type='checkbox' value='checkbox' onclick='setLayerVisibility()' "+(info.defaultVisibility ? "checked":"")+" />"+info.name+"</div>";  
              }  
              //设置可视图层  
              dyn2.setVisibleLayers(visible);  
              //在右边显示图层名列表  
              dojo.byId("toc").innerHTML=html;  
          }  
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
              dyn2.setVisibleLayers(visible);
          }

          /*dojo.connect(map, "onMouseMove", function showCoordinates(evt)
          {
        	  var pt =evt.mapPoint;
              dojo.byId("info").innerHTML = pt.x.toFixed(3) + ", " + pt.y.toFixed(3);
              var identifyTask, identifyParams;
              identifyTask = new IdentifyTask("http://135.149.48.48:6080/arcgis/rest/services/GXgrid/grid/MapServer"); 
     	      identifyParams = new IdentifyParameters();//查询参数  
     	      identifyParams.tolerance = 2;//容差范围  
     	      identifyParams.returnGeometry = true;//是否返回图形  
     	      identifyParams.layerIds = [1];//查询图层   
     	      identifyParams.layerOption = IdentifyParameters.LAYER_OPTION_VISIBLE;//设置查询的图层  
     	      identifyParams.geometry = evt.mapPoint;
              identifyParams.mapExtent = map.extent;
              identifyTask.execute(identifyParams, function (results) {
            	  	 map.graphics.clear();
            	  	 var feature = results[0].feature;
                     map.infoWindow.setTitle("当前属性");
                     map.infoWindow.resize(200,80);
                     map.infoWindow.setContent("<span>地区:</span>"  
                             + feature.attributes.RESNO  
                             + "<br>"  
                             + "<span>名称:</span>"  
                             + feature.attributes.RESNAME);  
                     var fillsymbol = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.5]));
                     var graphic = new esri.Graphic(feature.geometry, fillsymbol);
                     map.graphics.add(graphic);
                     map.infoWindow.show(evt.screenPoint);
            });
          });*/
          
          var mapCenter = new esri.geometry.Point(103.847, 36.0473, map.spatialReference);
          map.centerAndZoom(mapCenter,2);
        }
      ); 

  	 dojo.connect(map, "ondblclick", clearGraphics);
  	 function clearGraphics() 
 	 {
  		 graLayer.clear();
 	 }

    </script> 
  </head>
  <body>
    <div id="map" style="width:900px; height:600px; border:1px solid #000;">
    	<div id="toc" style="position: absolute; left: 5px; bottom: 50px; border: 1px solid #9c9c9c; background: #fff; width: 100px; height: 150px; z-index: 99;padding: 10px;"></div>  
    </div>
  </body>
</html>