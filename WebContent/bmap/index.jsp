<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<html>
<head>
    <title></title>
  <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js?version=1.1"/>' charset="utf-8"></script>
</head>
<body>
<div id="gismap" name="gismap"
     style="text-align: left;background-repeat: no-repeat;background-size:100% 100%;-moz-background-size:100% 100%;z-index:5;"></div>
</body>
</html>
<script>
  var pageMapHeight = $(window).height();
  if (pageMapHeight == 0)
    pageMapHeight = parent.document.documentElement.clientHeight - 6;
  $("#gismap").height(pageMapHeight);
  $("#gismap").show();

  var map = "";
  var tiled = "";
  var featureLayer = "";

  var city_id = '931';

  require([
            "esri/map",
            "esri/layers/ArcGISTiledMapServiceLayer",
            "esri/layers/FeatureLayer"
          ],
    function(
            Map,
            ArcGISTiledMapServiceLayer,
            FeatureLayer
    ){
      var cityForLayer = cityNames[city_id];
      if (cityForLayer == undefined)
        return;
      var layer_ds = tiled_address_pre + cityForLayer + tiled_address_suf;
      var cenAndZoom = city_center_zoom_gis[city_id];
      if (cenAndZoom != undefined) {
        var mapInitOption = new Object();
        mapInitOption.center = [cenAndZoom['lng'], cenAndZoom['lat']];
        if (window.screen.height <= 768) {
          mapInitOption.zoom = cenAndZoom['zoom'] + 1;
        } else {
          mapInitOption.zoom = cenAndZoom['zoom'] + 1;
        }
        map = new Map("gismap", mapInitOption);
      } else {
        map = new Map("gismap");
      }

      tiled = new ArcGISTiledMapServiceLayer(layer_ds);
      map.addLayer(tiled);
    }
  );
</script>
