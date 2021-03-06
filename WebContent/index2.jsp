<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" pageEncoding="UTF-8"	contentType="text/html;charset=UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="https://js.arcgis.com/3.19/esri/css/esri.css" />
      <style type="text/css">  
        @import "http://js.arcgis.com/3.19/dojo/resources/dojo.css";  
        @import "http://js.arcgis.com/3.19/dijit/themes/dijit.css";  
        @import "http://js.arcgis.com/3.19/dijit/themes/tundra/tundra.css";  
    </style>
    <script type="text/javascript" src="http://js.arcgis.com/3.19/init.js"></script>
    <script src="http://js.arcgis.com/3.19/"></script>  
 	<script src="<%=path%>/pages/js/jquery.js"></script>
 	<script>
	 	var map, bldgResults, parcelResults, symbol;
	
	    require([
	      "esri/map",
	      "esri/layers/ArcGISDynamicMapServiceLayer",
	      "esri/symbols/SimpleFillSymbol",
	      "esri/symbols/SimpleLineSymbol",
	      "esri/tasks/IdentifyTask",
	      "esri/tasks/IdentifyParameters",
	      "dojo/on",
	      "dojo/parser",
	      "esri/Color",
	      "dijit/registry",
	      "dijit/form/Button",
	      "dijit/layout/ContentPane",
	      "dijit/layout/TabContainer",
	      "dojo/domReady!"
	    ],
	      function (
	        Map, ArcGISDynamicMapServiceLayer, SimpleFillSymbol, SimpleLineSymbol,
	        IdentifyTask, IdentifyParameters, on, parser, Color, registry
	      ) {
	
	        parser.parse();
	
	        var identifyTask, identifyParams;
	
	          map = new Map("mapDiv", {
	            basemap: "streets",
	            center: [-83.275, 42.573],
	            zoom: 18
	          });
	          map.on("load", initFunctionality);
	
	          var landBaseLayer = new ArcGISDynamicMapServiceLayer("http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/BloomfieldHillsMichigan/Parcels/MapServer", {
	            opacity: 0.2
	          });
	          map.infoWindow.on("show", function () {
	            registry.byId("tabs").resize();
	          });
	          map.addLayer(landBaseLayer);
	
	        function initFunctionality () {
	          map.on("click", doIdentify);
	
	          identifyTask = new IdentifyTask("http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/BloomfieldHillsMichigan/Parcels/MapServer");
	
	          identifyParams = new IdentifyParameters();
	          identifyParams.tolerance = 3;
	          identifyParams.returnGeometry = true;
	          identifyParams.layerIds = [0, 2];
	          identifyParams.layerOption = IdentifyParameters.LAYER_OPTION_ALL;
	          identifyParams.width = map.width;
	          identifyParams.height = map.height;
	
	          map.infoWindow.resize(415, 200);
	          map.infoWindow.setContent(registry.byId("tabs").domNode);
	          map.infoWindow.setTitle("Identify Results");
	
	          symbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID,
	            new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
	              new Color([255, 0, 0]), 2),
	            new Color([255, 255, 0, 0.25]));
	        }
	
	        function doIdentify (event) {
	          map.graphics.clear();
	          identifyParams.geometry = event.mapPoint;
	          identifyParams.mapExtent = map.extent;
	          identifyTask.execute(identifyParams, function (idResults) {
	            addToMap(idResults, event);
	          });
	        }
	
	        function addToMap (idResults, event) {
	          bldgResults = { displayFieldName: null, features: [] };
	          parcelResults = { displayFieldName: null, features: [] };
	
	          for (var i = 0, il = idResults.length; i < il; i++) {
	            var idResult = idResults[i];
	            if (idResult.layerId === 0) {
	              if (!bldgResults.displayFieldName) { bldgResults.displayFieldName = idResult.displayFieldName; }
	              bldgResults.features.push(idResult.feature);
	            }
	            else if (idResult.layerId === 2) {
	              if (!parcelResults.displayFieldName) { parcelResults.displayFieldName = idResult.displayFieldName; }
	              parcelResults.features.push(idResult.feature);
	            }
	          }
	          registry.byId("bldgTab").set("content", buildingResultTabContent(bldgResults));
	          registry.byId("parcelTab").set("content", parcelResultTabContent(parcelResults));
	
	          map.infoWindow.show(event.screenPoint,
	            map.getInfoWindowAnchor(event.screenPoint));
	        }
	
	        function buildingResultTabContent (results) {
	          var template = "";
	          var features = results.features;
	
	              template += "<i>Total features returned: " + features.length + "</i>";
	              template += "<table border='1'>";
	              template += "<tr><th>ID</th><th>Address</th></tr>";
	
	              var parcelId;
	              var fullSiteAddress;
	              for (var i = 0, il = features.length; i < il; i++) {
	                parcelId = features[i].attributes['PARCELID'];
	                fullSiteAddress = features[i].attributes['Full Site Address'];
	
	                template += "<tr>";
	                template += "<td>" + parcelId + " <a href='#' onclick='showFeature(bldgResults.features[" + i + "]); return false;'>(show)</a></td>";
	                template += "<td>" + fullSiteAddress + "</td>";
	                template += "</tr>";
	              }
	
	              template += "</table>";
	
	          return template;
	        }
	
	        function parcelResultTabContent (results) {
	          var template = "";
	          var features = results.features;
	
	          template = "<i>Total features returned: " + features.length + "</i>";
	          template += "<table border='1'>";
	          template += "<tr><th>ID</th><th>Year Built</th><th>School District</th><th>Description</th></tr>";
	
	          var parcelIdNumber;
	          var residentialYearBuilt;
	          var schoolDistrictDescription;
	          var propertyDescription;
	          for (var i = 0, il = features.length; i < il; i++) {
	            parcelIdNumber = features[i].attributes['Parcel Identification Number'];
	            residentialYearBuilt = features[i].attributes['Residential Year Built'];
	            schoolDistrictDescription = features[i].attributes['School District Description'];
	            propertyDescription = features[i].attributes['Property Description'];
	
	            template += "<tr>";
	            template += "<td>" + parcelIdNumber + " <a href='#' onclick='showFeature(parcelResults.features[" + i + "]); return false;'>(show)</a></td>";
	            template += "<td>" + residentialYearBuilt + "</td>";
	            template += "<td>" + schoolDistrictDescription + "</td>";
	            template += "<td>" + propertyDescription + "</td>";
	            template += "</tr>";
	          }
	
	          template += "</table>";
	
	          return template;
	        }
	      });
	
	    function showFeature (feature) {
	      map.graphics.clear();
	      feature.setSymbol(symbol);
	      map.graphics.add(feature);
	    }
 	</script>
</head>
<body class="claro">
    Click the map to identify building and tax information.
    <div id="mapDiv" style="width:800px; height:600px; border:1px solid #000;"></div>
    <!-- info window tabs -->
    <div id="tabs" dojoType="dijit/layout/TabContainer" style="width:385px; height:150px;">
      <div id="bldgTab" dojoType="dijit/layout/ContentPane" title="Buildings"></div>
      <div id="parcelTab" dojoType="dijit/layout/ContentPane" title="Tax Parcels"></div>
    </div>
  </body>
</html>