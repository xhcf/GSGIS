<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today">
  select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="date_in_month">
  SELECT
  TO_CHAR(TO_DATE(MON_A, 'yyyymmdd'), 'yyyymmdd') AS CURRENT_FIRST,
  TO_CHAR(LAST_DAY(TO_DATE(MON_A, 'yyyymmdd')),'yyyymmdd') AS CURRENT_LAST,
  TO_CHAR(TO_DATE(MON_B, 'yyyymmdd'), 'yyyymmdd') AS LAST_FIRST,
  TO_CHAR(LAST_DAY(TO_DATE(MON_B, 'yyyymmdd')), 'yyyymmdd') AS LAST_LAST
  FROM (SELECT TO_CHAR(TO_DATE('${today.val}', 'yyyymmdd'), 'yyyymm') || '01' MON_A,
  TO_CHAR(ADD_MONTHS(TO_DATE('${today.val}', 'yyyymmdd'), -1),
  'yyyymm') || '01' MON_B
  FROM DUAL)
</e:q4o>
<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
  <e:q4o var="getCityVillageType">
    SELECT branch_type FROM gis_data.db_cde_grid WHERE union_org_code = '${sessionScope.UserInfo.TOWN_NO}'
  </e:q4o>
</e:if>
<html>
<head>
  <title>沙盘平台</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <e:script value="/resources/layer/layer.js" />
  <!--<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>-->
  <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css" />
  <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all" />
  <script src='<e:url value="/resources/scripts/sandbox_switch_right_area.js?version=1.2"/>'></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
  <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_org_frame_colorflow.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all" />
  <link href='<e:url value="pages/telecom_Index/common/css/layer_win.css?version=1.6" />' />
  <style>
    /*.picBox{background:url('<e:url value="/pages/telecom_Index/common/images/right.gif" />') no-repeat center center}
    .new_rightcont{display:none;}
    #mainleft{width:99%;}*/
    #custom_view > iframe {width:100%;height:100%;border:0;}

    /*新版客户视图*/
    .exec_new2 .layui-layer-title{
      background: none;
      position: absolute;
      z-index: 19901018;
      width: 90%;
      border-bottom:0;
    }
    .exec_new2 .layui-layer-content{
      height:100%;
    }
    #list_mode_view {background:#011157;}
    #include_map {background-color:transparent!important;}/*白屏bug修复*/
  </style>
</head>
<body class="body_padding">
<input type="hidden" id="city_id" />
<div class="g_wrap clearfix main easyui-layout" id="map_mode_view" style="position:absolute;top:0;left:0;">
  <div data-options="region:'west'" style="height:100%;" class="panes" id="include_map">
    <div id="tab_content" style="height:99.6%;padding-top:1%;width:99.8%; margin:0 auto">
      <div class="new_map" id="mainleft">
        <h2 id="click_path"></h2>
        <iframe id="mapContainer"></iframe>

        <%--<div class="switch_model switch_pos">
          <span id="model_to_map" class="pressed">地图</span>
          <span id="model_to_rank" class="unpress">排名</span>
        </div>--%>

        <!--<div id="tops_list_tab">
          <table class="map_tab">
            <%--<thead><th>序号</th><th>名称</th><th>支局</th></thead>--%>
            <tbody>
            <tr><td><div style="width:10px;height:10px;background-color:#042ab5"></div></td><td>高</td></tr>
            <tr><td><div style="width:10px;height:10px;background-color:#006cfe"></div></td><td>中</td></tr>
            <tr><td><div style="width:10px;height:10px;background-color:#1ea5f4"></div></td><td>低</td></tr>
            </tbody>
          </table>
        </div>-->
      </div>
      <div class="picBox" onclick="switchSysBar()" id="switchPoint"></div>
      <div class="new_rightcont" id="frmTitle" name="fmTitle">
        <iframe id="indexContainer"></iframe>
      </div>
    </div>
  </div>
</div>

<div id="list_mode_view" style="display:none;position:absolute;width:100%;height:100%;top:0;left:0;overflow: hidden;"></div>

<div id="custom_view" style="width:100%;height:100%;display:none;">
	<iframe></iframe>
</div>
</body>
</html>
<script type="text/javascript">
  var user_city_id = '${sessionScope.UserInfo.AREA_NO}';//用户的地市编码
  var user_bureau_no = '${sessionScope.UserInfo.CITY_NO}';//用户的分局编码
  var user_uion_org_code = '${sessionScope.UserInfo.TOWN_NO}';//用户的支局编码
  var user_grid_union_org_code = '${sessionScope.UserInfo.GRID_NO}';//用户的网格编码
  var user_level = '${sessionScope.UserInfo.LEVEL}';//用户的划小层级

  var global_parent_area_name = "";
  var global_current_area_name = "";//这里将按权限改动： 从sessionScope里取得用户级别，省名或市名或区县等级别
  var global_current_full_area_name = "";
  var global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
  var global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
  var global_current_city_id = "";

  var global_bureau_id = "";
  var global_bureau_name = "";
  var global_substation = "";
  var global_sub_name = "";
  var global_grid_id = "";
  var global_grid_name = "";
  var global_grid_id_short = "";

  var global_res_id = "";

  var global_city_id_for_vp_table = 0;

  var global_left_menu_flag = "";

  var click_dele="";
  var global_report_to_id="";
  var global_village_id="";
  var global_village_map="";

  var mapContainer_url = "";
  var indexContainer_url = "";

  var global_position = new Array(5);
  var global_position_param = new Array(5);
  var global_position_url = new Array();

  global_position[0] = province_name;
  global_position_param[0] = province_id[province_name];
  global_position_url[0] = '<e:url value="/pages/telecom_Index/sandbox_compete/compete_province_level.jsp" />';

  var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
  var url4Query_leader = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_leader.jsp" />';

  if(user_level=="" || user_level==undefined){
    layer.msg("与服务器连接断开，请重新登录");
  }else{
    //省级用户
    if(user_level==1){
      global_parent_area_name = province_name;
      global_current_area_name = province_name;//这里将按权限改动： 从sessionScope里取得用户级别，省名或市名或区县等级别
      global_current_full_area_name = province_name;
      global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
      global_current_flag = default_flag;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1，为
      global_current_city_id = province_id[province_name];
      global_city_id_for_vp_table = 0;

      mapContainer_url = '<e:url value="/pages/telecom_Index/sandbox_compete/compete_province_level.jsp" />';
      indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev.jsp" />';
    }
    //市级用户
    else if(user_level==2){
      global_parent_area_name = province_name;
      global_current_area_name = '${sessionScope.UserInfo.AREA_NAME}';
      if(city_name_speical.indexOf(global_current_area_name)>-1)
          global_current_full_area_name = global_current_area_name + "州";
      else
          global_current_full_area_name = global_current_area_name + "市";

      global_position[1] = global_current_full_area_name;

      global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
      global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
      global_current_city_id = '${sessionScope.UserInfo.AREA_NO}';
      global_city_id_for_vp_table = 0;

      mapContainer_url = '<e:url value="/pages/telecom_Index/sandbox_compete/compete_city_level.jsp" />';
      indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev.jsp" />';
    }
    //分局用户
    else if(user_level==3){
    	var area_name_short = '${sessionScope.UserInfo.AREA_NAME}';
    	if(city_name_speical.indexOf(area_name_short)>-1)
            global_parent_area_name = area_name_short + "州";
        else
            global_parent_area_name = area_name_short + "市";

      global_current_full_area_name = '${sessionScope.UserInfo.CITY_NAME}';

      global_position[2] = global_current_full_area_name;
      global_position[1] = global_parent_area_name;

      global_current_area_name = '${sessionScope.UserInfo.CITY_NAME}';
      global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
      global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
      global_current_city_id = '${sessionScope.UserInfo.AREA_NO}';
      global_bureau_id = '${sessionScope.UserInfo.CITY_NO}';
      global_bureau_name = '${sessionScope.UserInfo.CITY_NAME}';
      global_city_id_for_vp_table = 0;

      mapContainer_url = '<e:url value="/pages/telecom_Index/sandbox_compete/compete_bureau_level.jsp" />';
      indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev.jsp" />';
    }
    //支局用户
    else if(user_level==4){
      global_parent_area_name = '${sessionScope.UserInfo.CITY_NAME}';
      global_current_full_area_name = '${sessionScope.UserInfo.SUB_NAME}';
      global_position[3] = global_current_full_area_name;

      var area_name_short = '${sessionScope.UserInfo.AREA_NAME}';
      var area_name_full = "";
    	if(city_name_speical.indexOf(area_name_short)>-1)
            area_name_full = area_name_short + "州";
        else
            area_name_full = area_name_short + "市";

      if(zxs['${sessionScope.UserInfo.AREA_NO}']!=undefined)
        global_position[2] = area_name_full;
      else
        global_position[2] = '${sessionScope.UserInfo.CITY_NAME}';
      global_position[1] = area_name_full;

      global_current_area_name = '${sessionScope.UserInfo.SUB_NAME}';
      global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
      global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
      global_current_city_id = '${sessionScope.UserInfo.AREA_NO}';
      global_bureau_id = '${sessionScope.UserInfo.CITY_NO}';
      global_bureau_name = '${sessionScope.UserInfo.CITY_NAME}';
      global_substation = '${sessionScope.UserInfo.TOWN_NO}';
      global_sub_name = '${sessionScope.UserInfo.SUB_NAME}';

      global_city_id_for_vp_table = 0;
      if('${getCityVillageType.BRANCH_TYPE}' == 'a1'){
        mapContainer_url = '<e:url value="/pages/telecom_Index/sandbox/sandbox_sub_new_level.jsp" />';
        indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_sub_new.jsp" />';
      }else if('${getCityVillageType.BRANCH_TYPE}' == 'b1'){
        mapContainer_url = '<e:url value="/pages/telecom_Index/village_cell/sandbox_sub_village_cell_new_level.jsp" />';
        indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_sub_vc_new.jsp" />';
      }
    }
    //网格用户
    else if(user_level==5){
      global_parent_area_name = '${sessionScope.UserInfo.SUB_NAME}';
      //这里将按权限改动： 从sessionScope里取得用户级别，省名或市名或区县等级别
      global_current_full_area_name = '${sessionScope.UserInfo.GRID_NAME}';
      global_position[4] = global_current_full_area_name;
      global_position[3] = '${sessionScope.UserInfo.SUB_NAME}';

      var area_name_short = '${sessionScope.UserInfo.AREA_NAME}';
      var area_name_full = "";
    	if(city_name_speical.indexOf(area_name_short)>-1)
            area_name_full = area_name_short + "州";
        else
            area_name_full = area_name_short + "市";

      if(zxs['${sessionScope.UserInfo.AREA_NO}']!=undefined)
        global_position[2] = area_name_full;
      else
        global_position[2] = '${sessionScope.UserInfo.CITY_NAME}';
      global_position[1] = area_name_full;

      global_current_area_name = '${sessionScope.UserInfo.GRID_NAME}';
      global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
      global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
      global_current_city_id = '${sessionScope.UserInfo.AREA_NO}';
      global_bureau_id = '${sessionScope.UserInfo.CITY_NO}';
      global_bureau_name = '${sessionScope.UserInfo.CITY_NAME}';
      global_substation = '${sessionScope.UserInfo.TOWN_NO}';
      global_sub_name = '${sessionScope.UserInfo.SUB_NAME}';
      global_grid_id = '${sessionScope.UserInfo.GRID_NO}';
      global_grid_name = '${sessionScope.UserInfo.GRID_NAME}';

      global_city_id_for_vp_table = 0;
      if('${getCityVillageType.BRANCH_TYPE}' == 'a1'){
        mapContainer_url = '<e:url value="/pages/telecom_Index/sandbox/sandbox_grid_new_level.jsp" />';
        indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_grid_new.jsp" />';
      }else if('${getCityVillageType.BRANCH_TYPE}' == 'b1'){
        mapContainer_url = '<e:url value="/pages/telecom_Index/village_cell/sandbox_grid_village_cell_new_level.jsp" />';
        indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_grid_vc_new.jsp" />';
      }
    }
  }

  if(user_level>=3)//分局、支局、网格用户要把区县名称查询出来
    $.post(url4Query,{eaction:"getQXNameByBureauNo",bureau_no:'${sessionScope.UserInfo.CITY_NO}'},function(data){
      data = $.parseJSON(data);
      if(zxs['${sessionScope.UserInfo.AREA_NO}']==undefined)
        global_position[2] = data.BUREAU_NAME;
      if(user_level==3){
        global_current_full_area_name = data.BUREAU_NAME;
        global_current_area_name = data.BUREAU_NAME;
      }
      if(user_level==4){
        global_parent_area_name = data.BUREAU_NAME;
      }

    });

  var from_tab_list = 0;// 从支局列表双击进入支局

  var last_month_first = '${date_in_month.LAST_FIRST}';
  var last_month_last = '${date_in_month.LAST_LAST}';
  var current_month_first = '${date_in_month.CURRENT_FIRST}';
  var current_month_last = '${date_in_month.CURRENT_LAST}';

  var global_param_temp_for_subgridlist = new Array();
  //查询地图的数据

  var backToSub = "";

  var backToQx = "";

  var backToCity = "";

  var clickToGrid = "";

  var villageToMap = "";
  var villageObjectEdited = "";

  var freshVillageDatagrid = "";

  var clickToGridFromSub= "";

  var click_dele="";

  var left_list_type_selected = "";
  var left_list_item_selected = "";

  var zoom_from_province = "";
  var grid_id_from_province = "";
  var village_id_selected_from_province = "";
  var standard_id_from_province = "";

  var city_id_for_village_tab_view = "";

  var navSummaryToggle = "";

  var clickNavTarget = "";
  var clickNavFunction = "";

  var call_execute_new_cust_view = "";
  var fresh_village_yx = "";

  var global_add4_position_flag = "";
  var global_entrance_type = "";
  var global_village_position_vid = "";

  $(function(){
    if(isIE()){
      var pageMapHeight = $(window).height();
      if(pageMapHeight==0)
        pageMapHeight = parent.document.documentElement.clientHeight;
      $("#mapContainer").height(pageMapHeight);
    }

    $("#mapContainer").attr("src",mapContainer_url);
    if(user_level==5){
      $.post(url4Query,{eaction:'getResidByStationNo',grid_id:global_grid_id},function(data){
        data = $.parseJSON(data);
        if(data==null)
          global_report_to_id = "";
        else
          global_report_to_id = data.STATION_ID;
        console.log("global_report_to_id:"+global_report_to_id);
        console.log("loading index page");
        $("#indexContainer").attr("src",indexContainer_url);
      });
      $.post(url4Query, {"eaction": "getGridIdByGridUnionOrgCode", "grid_id": global_grid_id}, function (data) {
        data = $.parseJSON(data);
        global_grid_id_short = data.GRID_ID;
      });
    }else{
      $("#indexContainer").attr("src",indexContainer_url);
    }

    updateTabPosition();

    global_add4_position_flag = '${param.global_add4_position_flag}';
    global_village_position_vid = "";

    if(global_add4_position_flag==1){
      load_list_tab_add4();
    }else if('${param.from_menu}'!=""){
      load_list_village_summary();
    }

    /*$("#include_map").show();
     $("#include_tab").hide();*/

    /*$("#model_to_map").addClass("pressed");
     $("#model_to_rank").removeClass("pressed");*/

    /*$("div .unpress").live("click",function(){
     toggleClass();
     var id = $(this).attr("id");
     load_sub_list_tab();
     });*/
  });

  function toggleClass(){
    /*$("#model_to_map").toggleClass("pressed");
     $("#model_to_map").toggleClass("unpress");
     $("#model_to_rank").toggleClass("pressed");
     $("#model_to_rank").toggleClass("unpress");*/
  }

  function toggleModelButton(){
    //$("#model_to_map").toggle();
    //$("#model_to_rank").toggle();
  }

  function insideToVillage(region_id){
    global_village_position_vid = region_id;
    global_entrance_type="village";
    load_map_view2();
  }

  function load_list_view(){
    /*layer.open({
     title: false,
     type: 2,
     shadeClose: true,
     shade: 0.8,
     area: ['100%', '100%'],
     closeBtn: 0,
     content: ['<e:url value="/pages/telecom_Index/viewPlane_table.jsp"/>','no'], //iframe的url
     cancel: function(){//右上角关闭回调
     //return false 开启该代码可禁止点击该按钮关闭
     }
     });*/
    $("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    $("#list_mode_view").load('<e:url value="/pages/telecom_Index/small_rank/viewPlane_table_org_framework.jsp"/>');
  }
  function load_map_view(){
    $("#map_mode_view").show();
    $("#list_mode_view").hide();
    $("#list_mode_view").empty();
    freshIndexContainer(document.getElementById('indexContainer').src);
  }
  function load_map_view2(){
    $("#map_mode_view").show();
    $("#list_mode_view").hide();
    $("#list_mode_view").empty();
    freshMapContainer(document.getElementById('mapContainer').src);
  }
  /*function load_list_village(level){
   $("#map_mode_view").hide();
   $("#list_mode_view").empty();
   $("#list_mode_view").show();
   $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_org_framework.jsp"/>?level='+level);
   }*/
  function load_list_village(level,city_id,bureau_id,branch_id,grid_id){
    $("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_org_framework.jsp"/>?level='+level+'&city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id);
    /*if(level==1)
     $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_province.jsp"/>');
     else if(level==2)
     $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_city.jsp"/>?city_id='+city_id);
     else if(level==3)
     $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_grid.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id);
     else if(level==4)
     $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_villageDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id);
     else if(level==5)
     $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_villageDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id);*/
  }

  function load_list_tongji(level,city_id,bureau_id,branch_id,grid_id){
  	$("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    $("#list_mode_view").load('<e:url value="/pages/telecom_Index/sandbox/sandbox_tongji_org_framework.jsp"/>?level='+level+'&city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id);
  }

  function load_list_info_collect(){
    $("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    $("#list_mode_view").load('<e:url value="/pages/telecom_Index/info_collect/viewPlane_tab_info_collect_org_framework.jsp"/>');
  }
  function load_list_village_new_page(level,city_id,bureau_id,branch_id,grid_id){
    if(level==5)
      window.open('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_villageDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id, "", "");
    //$("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_villageDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id);
  }
  function load_list_village_for_sub_grid_user(level,city_id,bureau_id,branch_id,grid_id){
    $("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    if(level==4)
      $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_grid.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id);
    else if(level==5)
      $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_grid.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id);
  }
  function load_list_village_summary(){
    $("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    $("#list_mode_view").animate({"left":0}, "1500", function(){
      //$("#map_mode_view").hide();
      $("#closeTab").hide();
      $("#list_mode_view").load("<e:url value='pages/telecom_Index/tab_village_summary/viewPlane_tab_village.jsp' />?" + "city_id=" + '${sessionScope.UserInfo.AREA_NO}' + "&from_menu=1");
    })
  }
  function load_list_tab_add4(){
    $("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    var city_id = '${sessionScope.UserInfo.AREA_NO}';
    var bureau_id = '${sessionScope.UserInfo.CITY_NO}';
    var branch_id = '${sessionScope.UserInfo.TOWN_NO}';
    var grid_id = '${sessionScope.UserInfo.GRID_NO}';
    $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_add4/tab_add4_tab.jsp"/>?city_id='+city_id+'&bureau_id='+bureau_id+'&branch_id='+branch_id+'&grid_id='+grid_id);
  }

  function hide_layer(){
    layer.closeAll();
  }
  /*function tab_map_switch(){
   $("#include_map").toggle();
   $("#include_tab").toggle();
   }*/

  /*function load_sub_list_tab(){
   $("#include_tab_div").load('<e:url value="/pages/telecom_Index/viewPlane_table.jsp" />'); // 添加Html内容，不能用Text 或 Val
   }*/

  function hideMapPosition(){
    $("#click_path").hide();
  }
  function showMapPosition(){
    $("#click_path").show();
  }

  function updatePosition(level){
    //$("#click_path").hide();
    if(user_level==level)
      $("#click_path").css({"right":"0px"});
    else{
      $("#click_path").css({"right":"37px"});
    }
    //var click_path = $(window.frames["mapContainer"].contentWindow.document).find("#click_path");
    var temp = "";
    for(var i =0;i<level;i++){
      var str = global_position[i];
      if(str == undefined){
        $("#click_path").show();
        return;
      }

      //嘉峪关的特殊处理，当点击嘉峪关下某个支局的时候，地图右上角不增加多余的“嘉峪关市”
      if(i==2 && zxs[global_position[2]]==1){
      }else{
        if(/*i<2 && */user_level<=level && i+1!=level && i+1>=user_level){
          if(i==0)
            temp += "<a href=\"javascript:void(0);\" onclick=\"javascript:backToPosition("+(i+1)+",'"+global_position_url[i]+"')\" >";
          else if(i==1)
            temp += "<a href=\"javascript:void(0);\" onclick=\"javascript:backToCity()\" >";
          else if(i==2)
            temp += "<a href=\"javascript:void(0);\" onclick=\"javascript:backToQx()\" >";
          else if(i==3)
            temp += "<a href=\"javascript:void(0);\" onclick=\"javascript:backToSub()\" >";

          temp += global_position[i]+"</a>";
        }
        else
          temp += global_position[i];

        if(i!=level-1)
          temp += ">";
      }
    }
    if(temp.substr(temp.length-2)==">>")
      temp = temp.substr(0,temp.length-1);
    if(temp.substr(temp.length-1)==">")
      temp = temp.substr(0,temp.length-1);
    $("#click_path").html(""+temp);
    //$("#click_path").show();
  }
  function openSubView(){
    window.open('<e:url value="/pages/telecom_Index/sandbox_compete/viewPlane_branch_view.jsp"/>?substation='+global_substation,"支局视图",'',true);
    /*layer.open({
     title: false,
     type: 2,
     shadeClose: true,
     shade: 0.8,
     area: ['100%', '100%'],
     closeBtn: 0,
     content: [,'no'], //iframe的url
     cancel: function(){//右上角关闭回调
     //return false 开启该代码可禁止点击该按钮关闭
     }
     });*/
  }
  function openBuildView(resid) {
    window.open('<e:url value="/pages/telecom_Index/sandbox_compete/viewPlane_build_view.jsp"/>?res_id='+resid,"楼宇信息",'',true);
  }
  //打开新版客户视图
  var new_cust_view = "";
  function openCustomView(param){
  	//$("#map_mode_view").hide();
  	//$("#custom_view").show();
  	var segment_id      =param.segment_id  ;
    var prod_inst_id    =param.prod_inst_id;
    var order_id        =param.order_id    ;
    var add6            =param.add6        ;
    var tab_id          =param.tab_id      ;
    var exec_able       =param.exec_able   ;
    var scene_id        =param.scene_id    ;
    var mkt_campaign_id =param.mkt_campaign_id;
    var pa_date			=param.pa_date		 ;
    var is_lost         =param.is_lost     ;
    var is_yx           =param.is_yx       ;
    var is_village		=param.is_village   ;
    $("#custom_view > iframe").attr("src",'<e:url value="/pages/telecom_Index/sub_grid/viewPlane_info_collect_edit_diy_new2.jsp" />?prod_inst_id='+prod_inst_id+"&add6="+add6+"&order_id="+order_id+"&mkt_campaign_id="+mkt_campaign_id+"&pa_date="+pa_date+"&segment_id="+segment_id+"&exec_able="+exec_able+"&scene_id="+scene_id+"&is_lost="+is_lost+"&is_yx="+is_yx+"&is_village="+is_village);
    new_cust_view = layer.open({
    	type:1,
    	area: ['85%'],
        offset: '0px',
        title:' ',
        skin: 'exec_new2',
    	maxmin:false,
    	content:$('#custom_view')
    });
  }
  function closeCustomView(){
    layer.close(new_cust_view);
  	//$("#custom_view").hide();
  	//$("#map_mode_view").show();
  }
  var exec_new2_handler = "";
  function openExecuteShow(params){
    exec_new2_handler = layer.open({
      type: 2,
      area: ['850px', '520px'],
      //fixed: true, //不固定
      maxmin: false,
      content: '<e:url value="pages/telecom_Index/sub_grid/viewPlane_exec_view2.jsp" />?segment_id='+params.segment_id+"&add6="+params.add6+"&prod_inst_id="+params.prod_inst_id+"&order_id="+params.order_id+"&scene_id="+params.scene_id+"&is_yx="+params.is_yx+"&is_village="+params.is_village+"&mkt_campaign_id="+params.mkt_campaign_id+"&pa_date="+params.pa_date
    });
  }
  function closeWinInfoCollectionEdit(){
    layer.close(exec_new2_handler);
  }
  function updateTabPosition(){
    var tab_path = "";
    var contentWindow = window.frames["indexContainer"].contentWindow;
    if(contentWindow==undefined)
      tab_path = $(window.frames["indexContainer"].document).find("h1");
    else
      tab_path = $(contentWindow.document).find("h1");

    var text = global_current_full_area_name;
    if(global_current_flag>=4)
      $(tab_path).html("<div>"+text+"</div>"+"<a id=\"branch_view_open\" style=\"display:none;float:right;margin-right:5px;color:#fff;\" href=\"javascript:void(0);\">视图</a>");
    else
      $(tab_path).html("<div>"+text+"</div>");

    if(global_current_flag==4){
      if('${getCityVillageType.BRANCH_TYPE}' == 'a1') {
        $(tab_path).append("<div class='a1'>城市</div>");
      }else if('${getCityVillageType.BRANCH_TYPE}' == 'b1') {
        $(tab_path).append("<div class='a1'>农村</div>");
      }
    }else if(global_current_flag==5){
      if('${getCityVillageType.BRANCH_TYPE}' == 'a1') {
        $(tab_path).append("<div class='a2'>城市</div>");
      }else if('${getCityVillageType.BRANCH_TYPE}' == 'b1') {
        $(tab_path).append("<div class='a2'>农村</div>");
      }
    }
  }

  function backToPosition(level,url4mapBackTop){
    //level就是flag
    var params = new Object();
    var current_full_area_name = global_position[level-1];
    if(level == 1)
      global_parent_area_name = province_name;
    else
      global_parent_area_name = global_position[level-2];

    var current_area_name = current_full_area_name;
    if(level==2){
      if(city_name_speical.indexOf(current_full_area_name)>-1)
        current_area_name = current_full_area_name.replace(/州/gi,'');
      else
        current_area_name = current_full_area_name.replace(/市/gi,'');
    }

    global_current_area_name = current_area_name;
    global_current_full_area_name = current_full_area_name;
    global_current_flag = level;
    global_current_city_id = global_position_param[level-1];
    if(level < 3){
      freshMapContainer(url4mapBackTop);
      //$("#model_to_map").show();
      //$("#model_to_rank").show();
    }else{
      backToQx();
      //$("#model_to_map").hide();
      //$("#model_to_rank").hide();
    }
    freshIndexContainer(indexContainer_url);
  }

  function freshMapContainer(new_url){
    document.getElementById('mapContainer').src=new_url;
  }
  function freshIndexContainer(new_url){
    if(new_url)
      document.getElementById('indexContainer').src=new_url;
    else
      document.getElementById('indexContainer').src=new_url;
  }

  function showRightDiv(){
    if($("#switchPoint").hasClass("showList")){
      $("#switchPoint").click();
      //setTimeout(function(){reposMapPosition()},1000);
      //resize_vill_win("close");
    }
  }
  function hideRightDiv(){
    if(!$("#switchPoint").hasClass("showList")){
      $("#switchPoint").click();
      //reposMapPosition();
      //resize_vill_win("open");
    }
  }
</script>