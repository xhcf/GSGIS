<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<html>
<head>
  <title>支局网格页面左侧菜单</title>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <style>
    #query_div {
      width: 120px;
      height: 47px;
      background: #0f2c92;
      padding: 0;
      position: absolute;
      display: none;
    }

    #query_div div {
      float: left;
      line-height: 29px;
      color: #fff;
      cursor: pointer;
      padding-left: 0px;
    }

    .ico {
      width: 17px;
      height: 17px;
      margin-right: 7px;
      margin-top: -20px;
    }

    #query_div span {
      height: 18px;
      line-height: 18px;
      width: 30px;
      font-size: 12px;
      display: inline-block;
      margin-top: 2px;
    }
  </style>
</head>
<body>
  <ul id="tools">
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '1' || sessionScope.UserInfo.LEVEL eq '2'}">
      <li id="nav_hidetiled" onclick="javascript:load_map_view();"><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
      <li id="model_to_rank" style="cursor:hand"><span></span><a href="javascript:void(0)" id="" style="cursor:hand">统计</a></li>
      <li id="nav_zoomin" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="zoomin" style="cursor:not-allowed;">放大</a></li>
      <li id="nav_zoomout" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="zoomout" style="cursor:not-allowed;">缩小</a></li>
      <li id="nav_hidepoint" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="hidepoint" style="cursor:not-allowed;">网点</a></li>
      <%--<li id="nav_query"><span></span><a href="javascript:void(0)" id="query">查找</a></li>--%>
      <li id="nav_list"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="list" style="cursor:not-allowed;">支局</a></li>
      <li id="nav_grid"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="grid" style="cursor:not-allowed;">网格</a></li>
      <li id="nav_village"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="village" style="cursor:not-allowed;">小区</a></li>
      <li id="nav_standard"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="standard" style="cursor:not-allowed;">楼宇</a></li>
      <li id="nav_marketing"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="marketing" style="cursor:not-allowed;">营销</a></li>
      <li id="nav_info_collect" onclick="javascript:viewInfoCollect();"><span></span><a href="javascript:void(0)" id="info_collect">收集</a></li>
      <!-- <li id="nav_earse"><span></span><a href="javascript:void(0)" id="earseTool">擦除</a></li>-->
      <!--<li id="nav_chart" style="cursor: hand"><span></span><a href="javascript:void(0)" id="hidechart">市场</a></li>-->
      <!--<li id="nav_heatmap" style="cursor: hand"><span></span><a href="javascript:void(0)" id="heatmap">热力图</a></li>-->
      <!--<li id="nav_tianyi"><span></span><a href="javascript:void(0)">天翼</a></li>
      <li id="nav_kuandai"><span></span><a href="javascript:void(0)">宽带</a></li>
      <li id="nav_itv"><span></span><a href="javascript:void(0)">ITV</a></li>
      <li id="nav_reli"><span></span><a href="javascript:void(0)">热力</a></li>
      <li id="nav_guanbi"><span></span><a href="javascript:void(0)">关闭</a></li>-->
      <!--  li id="nav_fanhui"><span></span><a href="javascript:backToEchart()" id="backtop">返回</a></li-->
      <!--  li id="nav_fanhui_qx" style="display:none;"><span></span><a href="javascript:backToQx()" id="backtop_qx">返回</a></li-->
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
      <li id="nav_hidetiled" onclick="javascript:load_map_view();"><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
      <li id="nav_village2" style="cursor: not-allowed;"><span></span><a href="javascript:void(0)" id="village" style="cursor:not-allowed;">小区</a>
      </li>
      <li id="nav_standard2" style="cursor: not-allowed"><span></span><a href="javascript:void(0)" id="standard" style="cursor:not-allowed;">楼宇</a>
      </li>
      <li id="nav_marketing2" style="cursor: not-allowed"><span></span><a href="javascript:void(0)" id="marketing" style="cursor:not-allowed;">营销</a>
      </li>
      <li id="nav_info_collect" onclick="javascript:viewInfoCollect();"><span></span><a href="javascript:void(0)" id="info_collect">收集</a>
      </li>
    </e:if>
  </ul>
  <div id="query_div">
    <div style="width:60px;border-right:1px solid #ccc;padding-left:0px;padding-top:3px;padding-bottom:7px;"
         onclick="javascript:viewRank();">
      <div style="width:100%;height:15px;"><img
              src="<e:url value='/pages/telecom_Index/sub_grid/image/paiming1.png' />" class="ico"
              style="margin-left:10px;margin-top:0px;"/></div>
      <div style="width:100%;height:15px;font-size:12px;text-align:center;">划小排名</div>
    </div>
    <div style="width:60px;padding-left:0px;padding-top:3px;padding-bottom:3px;" class="mapico"
         onclick="javascript:viewVillageDraw();">
      <div style="width:100%;height:15px;"><img
              src="<e:url value='/pages/telecom_Index/sub_grid/image/shangtu1.png' />" class="ico"
              style="margin-left:10px;margin-top:0px;"/></div>
      <div style="width:100%;height:15px;font-size:12px;text-align:center;">小区统计</div>
    </div>
  </div>
</body>
</html>
<script>
  $(function(){
    var active = '${param.active}';
    if(active=="info_collect"){
      $("#nav_info_collect").addClass("active");
      $("#nav_info_collect").addClass("active");
      $("#nav_info_collect").css({"cursor": "not-allowed"});
    }else if(active=="summary"){
      $("#model_to_rank").addClass("active");
      $("#nav_info_collect").css({"cursor": "hand"});
    }
    $("#model_to_rank").click(function(){
      if($("#query_div").is(":hidden")){
        var top_px = $(this).offset().top;
        $("#query_div").css({"left":$(this).offset().left+35,"top":top_px+4,"height":$(this).height()+6});
        $("#query_div").show();
        console.log("show");
      }else{
        $("#query_div").hide();
        console.log("hide");
      }
      //
    });
  });
  function viewRank() {
    load_list_view();
    $("#query_div").hide();
    $("#model_to_rank").removeClass("active");
  }
  function viewVillageDraw() {
    load_list_village(1);
    $("#query_div").hide();
    $("#model_to_rank").removeClass("active");
  }
  function viewInfoCollect(){
    load_list_info_collect();
  }
</script>