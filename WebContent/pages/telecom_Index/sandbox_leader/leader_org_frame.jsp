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
<e:q4l var="index_range_list">
  SELECT
    KPI_CODE,
    RANGE_NAME,
    RANGE_NAME_SHORT,
    RANGE_SIGNL,
    RANGE_MIN,
    RANGE_SIGNR,
    RANGE_MAX,
    nvl(RANGE_MIN,RANGE_MAX) RANGE_COUNT
  FROM ${gis_user}.TB_GIS_KPI_RANGE
    WHERE IS_VALID = 1
  ORDER BY KPI_CODE ASC, RANGE_INDEX ASC
</e:q4l>
<html>
<head>
  <title>领导视窗</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <c:resources type="easyui,app" style="b"/>
  <e:script value="/resources/layer/layer.js" />
  <!--<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>-->
  <link href='<e:url value="/resources/themes/common/css/reset_sandbox_leader.css?version=1.2"/>' rel="stylesheet" type="text/css" />
  <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
  <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_org_frame_colorflow.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all" />
  <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/leader_org_frame.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" />
  <link href='<e:url value="pages/telecom_Index/common/css/layer_win.css?version=1.6" />' />
  <style>
    .entrance_btn_group{
      position: absolute;
      left:10px;
      bottom:10px;
    }
    .entrance_btn_group button{
      display:block;
    }

    .entrance_select{
      width:235px;
    }
    .entrance_select_input{
      width:215px;
    }
    .entrance_select,.entrance_select_input{
      position:absolute;
      left:0px;
      top:0px;
    }
    .entrance_select_temp_list{
      position:absolute;
      left:0px;
      top:30px;
      height:200px;
      width:235px;
      overflow-y:auto;
    }

    .obd_contain_choice{height: 41px;}
    .obd_contain_choice>span{padding-left: 15px;display:block;margin-top:5px;height:36px;line-height: 36px;}
    #collect_new_build_name{height:30px!important;line-height: 30px!important}
    .collect_contain_choice input, .collect_contain_choice select, .collect_contain_choice ul{
      left:55px;
    }
    .collect_contain_choice ul{top: 30px;left: 55px;
      z-index: 8;width: 85%}
    @media screen and (min-height: 800px){
      .obd_contain_choice>span{padding-left: 20px}
      .collect_contain_choice input, .collect_contain_choice select, .collect_contain_choice ul{
        left:70px;
      }
    }
    .sub_summary_div{
      background-color:#fff;
    }
    #click_path {left:200px;right:auto;}
    #func_fanhui {
      position: absolute;
      float: right;
      top: 0px;
      width: 38px;
      height: 32px;
      color: #fff;
      font-weight: normal;
      padding: 1px 8px;
      font-size:12px;
      background: url('<e:url value="/resources/themes/common/css/icons/back_icon1.png" />') no-repeat center left #1479c0;
    }
    #obd_new1_sub_span,#obd_new1_grid_span,#obd_new1_village_span{
      display:none;
    }
    .entrance_btn_group{display:none;}
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
    #include_map {background-color:transparent!important;}
  </style>
</head>
<body class="body_padding">
<input type="hidden" id="city_id" />
<div class="g_wrap clearfix main easyui-layout" id="map_mode_view" style="position:absolute;top:0;left:0;">
  <div data-options="region:'west'" style="height:100%;" class="panes" id="include_map">
    <div id="tab_content" style="height:99.6%;padding-top:5px;width:99.8%; margin:0 auto">
      <div class="new_map" style="width: 100%">
        <div id="mainleft" class="mainleft">
          <h2 id="click_path"></h2>
          <a href="javascript:void(0);" id="func_fanhui" class="add_backcolor" style="display:none;"></a>
          <iframe id="mapContainer"></iframe>
          <div class="entrance_btn_group">
            <button id="entrance_btn_sub">找支局</button>
            <button id="entrance_btn_grid">查网格</button>
            <button id="entrance_btn_village">搜小区</button>
          </div>
        </div>
        <div id="frmTitle" class="frmTitle" name="fmTitle">
          <iframe id="indexContainer"></iframe>
        </div>
        <div class="switch_right_index" id="switchPoint"></div>
      </div>
    </div>
  </div>
</div>

<div id="list_mode_view"></div>

<div id="custom_view" style="width:100%;height:100%;display:none;">
	<iframe></iframe>
</div>

<!-- 快速入口列表弹窗 -->
<div style="display:none;" id="entrance_win">
  <span id="obd_new1_sub_span">
    <select id="collect_new_sub_list" name="collect_new_sub_list" onchange="select_change('sub')" class="entrance_select"></select>
  </span>
  <span id="obd_new1_grid_span">
    <select id="collect_new_grid_list" name="collect_new_grid_list" onchange="select_change('grid')" class="entrance_select"></select>
  </span>
  <span id="obd_new1_village_span">
    <select id="collect_new_village_list" name="collect_new_village_list" onchange="select_change('village')" class="entrance_select"></select>
  </span>
  <input type="text" id="collect_new_build_name" name="collect_new_build_name" class="entrance_select_input" oninput="load_option_name_list()">
  <ul id="collect_new_build_name_list" class="entrance_select_temp_list">
  </ul>
</div>

<form id="myForm" method="post" style="display:none;">
  <input type="hidden" name="content" id="content" />
  <input type="hidden" name="token" id="token" />
</form>

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
  var global_current_index_type = 0;//左侧指标按钮默认类型，宽带家庭渗透率

  var global_current_index_is_village_cell = 0;
  var global_other_mode = "";
  var global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
  var global_current_city_id = "";

  var global_bureau_id = "";
  var global_bureau_name = "";
  var global_substation = "";
  var global_sub_name = "";
  var global_grid_id = "";
  var global_grid_name = "";

  var global_search_text = "";

  var global_city_id_for_vp_table = 0;

  var global_left_menu_flag = "";

  var global_report_to_id="";
  var global_village_id="";
  var global_village_map="";

  var global_entrance_type = "";

  var global_region_type = "city";
  var global_region_id = "";

  var global_village_cell_id = "";

  var mapContainer_url = "";
  var indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev.jsp" />';

  var indexContainer_village_cell_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_village_page.jsp" />';

  var global_fromProvince = 0;

  var global_position = new Array(5);
  var global_position_param = new Array(5);
  var global_position_url = new Array();

  global_position[0] = province_name;
  global_position_param[0] = province_id[province_name];
  global_position_url[0] = '<e:url value="/pages/telecom_Index/sandbox_leader/leader_province_level.jsp" />';

  var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';

  var change_echarts_range = "";

  var map_url_province = '<e:url value="/pages/telecom_Index/sandbox_leader/leader_province_level.jsp" />';
  var map_url_city = '<e:url value="/pages/telecom_Index/sandbox_leader/leader_city_level.jsp" />';
  var map_url_bureau = '<e:url value="/pages/telecom_Index/sandbox_leader/leader_bureau_level.jsp" />';
  var map_url_bureau_user = '<e:url value="/pages/telecom_Index/sandbox_leader/leader_bureau_user_level.jsp" />';

  var map_url_bureau_school = '<e:url value="/pages/telecom_Index/sandbox_leader/enterprise_bureau_level.jsp" />';

  var map_url_sch_ent = '<e:url value="/pages/telecom_Index/sandbox_leader/enterprise_bureau_level.jsp" />';

  var map_url_village_page = '<e:url value="/pages/telecom_Index/village_cell/leader_bureau_village_cell_level.jsp" />';

  var refresh_map = "";

  var call_execute_new_cust_view = "";
  var fresh_village_yx = "";

  var resize_vill_win = "";
  var resize_she_dui_view_win = "";
  var resize_building_view_win = "";

  if(user_level=="" || user_level==undefined){
    layer.msg("与服务器连接断开，请重新登录");
  }else{
    //省级用户
    if(user_level==1){
      global_parent_area_name = province_name;
      global_current_area_name = province_name;//这里将按权限改动： 从sessionScope里取得用户级别，省名或市名或区县等级别
      global_current_full_area_name = province_name;
      //global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
      global_current_flag = default_flag;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1，为
      global_current_city_id = province_id[province_name];
      global_city_id_for_vp_table = 0;
      global_region_type = "city";

      mapContainer_url = map_url_province;
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

      //global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
      global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
      global_current_city_id = '${sessionScope.UserInfo.AREA_NO}';
      global_city_id_for_vp_table = 0;
      global_region_type = "bureau";

      mapContainer_url = map_url_city;
    }
  }

  //分局、支局、网格用户要把区县名称查询出来
  if(user_level>=3){
  	var area_name_short = '${sessionScope.UserInfo.AREA_NAME}';
  	if(city_name_speical.indexOf(area_name_short)>-1)
	  global_parent_area_name = area_name_short + "州";
	else
	  global_parent_area_name = area_name_short + "市";

    global_current_full_area_name = '${sessionScope.UserInfo.CITY_NAME}';

    global_position[2] = '${sessionScope.UserInfo.CITY_NAME}';
    global_position[1] = global_parent_area_name;

	global_current_area_name = '${sessionScope.UserInfo.CITY_NAME}';
    global_current_flag = user_level;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
    global_current_city_id = '${sessionScope.UserInfo.AREA_NO}';

    if(user_level==3)
      mapContainer_url = map_url_bureau_user+'?city_id='+user_city_id+'&bureau_no='+user_bureau_no;

    /*$.post(url4Query,{eaction:"getQXNameByBureauNo",bureau_no:'${sessionScope.UserInfo.CITY_NO}'},function(data){
      data = $.parseJSON(data);
      //if(zxs['${sessionScope.UserInfo.AREA_NO}']==undefined)
      //  global_position[2] = data.BUREAU_NAME;
      if(user_level==3){
        global_current_full_area_name = data.BUREAU_NAME;
        global_current_area_name = data.BUREAU_NAME;
        mapContainer_url = '<e:url value="/pages/telecom_Index/sandbox_leader/leader_bureau_level.jsp" />';
      }
      if(user_level==4){
        global_parent_area_name = data.BUREAU_NAME;
      }
    });*/
    global_region_type = "sub";
  }

  var from_tab_list = 0;// 从支局列表双击进入支局

  var last_month_first = '${date_in_month.LAST_FIRST}';
  var last_month_last = '${date_in_month.LAST_LAST}';
  var current_month_first = '${date_in_month.CURRENT_FIRST}';
  var current_month_last = '${date_in_month.CURRENT_LAST}';

  var global_param_temp_for_subgridlist = new Array();
  //查询地图的数据3

  var backToEchart = "";

  var backToSub = "";

  var backToQx = "";

  var backToCity = "";

  var clickToGrid = "";

  var villageToMap = "";
  var villageObjectEdited = "";

  var freshVillageDatagrid = "";

  var clickToGridFromSub= "";

  var left_list_type_selected = "";
  var left_list_item_selected = "";

  var zoom_from_province = "";
  var grid_id_from_province = "";
  var village_id_selected_from_province = "";
  var standard_id_from_province = "";

  var city_id_for_village_tab_view = "";

  var st_broad_home = '<e:url value="/pages/telecom_Index/sandbox_leader/smallTab/small_table_broad_home_market.jsp" />';
  var st_fb_cover = '<e:url value="/pages/telecom_Index/sandbox_leader/smallTab/small_table_fb_cover.jsp" />';
  var st_collect = '<e:url value="/pages/telecom_Index/sandbox_leader/smallTab/small_table_collect.jsp" />';
  var st_dispatch_yx = '<e:url value="/pages/telecom_Index/sandbox_leader/smallTab/small_table_dispatch_yx.jsp" />';
  var st_fb_real_percent = '<e:url value="/pages/telecom_Index/sandbox_leader/smallTab/small_table_fb_real_percent.jsp" />';
  var st_protection = '<e:url value="/pages/telecom_Index/sandbox_leader/smallTab/small_table_protection.jsp" />';

  var load_tab = "";
  var get_range_cnt = "";
  var refresh_range_cnt = "";
  var hide_range_cnt = "";
  var show_range_cnt = "";

  var global_is_inside = false;

  var global_location = "";

  var global_func_searchVillage = "";
  var global_func_operateVillage = "";
  var global_func_closeAllLayerWin = "";

  var global_func_showSummaryWindow = "";
  var global_res_id = "";

  var index_range_str_temp = ${e:java2json(index_range_list.list)};
  var index_range_map = new Array();

  var global_add4_position_flag = "";

  for(var i = 0,l = index_range_str_temp.length;i<l;i++){
    var index_item = index_range_str_temp[i];
    var index_map = index_range_map[index_item['KPI_CODE']];
    if(index_map!=undefined)
      index_map.push(index_item);
    else{
      index_map = new Array();
      index_map.push(index_item);
    }
    index_range_map[index_item['KPI_CODE']] = index_map;
  }

  //校园商客  校园政企  跳转
  function switchToCity_inside_page(region_id,cityFull,fromProvince,flag){
    global_other_mode = flag;
    if(region_id=="999"){
      global_current_full_area_name = province_name;
      global_current_flag = 1;
      global_current_city_id = province_id[province_name];
      global_current_area_name = province_name;
      global_position.splice(1,1,'');
      global_position.splice(2,1,'');
      if('${param.to_sch_ent}'!='1')//从营销沙盘左侧菜单进入校园商客
        freshMapContainer(map_url_province);
      else{//从系统菜单校园沙盘进入
        map_url = map_url_sch_ent;
        index_url = indexContainer_url;
        freshMapContainer(map_url);
      }
    }else{
      global_current_full_area_name = cityFull;
      global_current_flag = 2;
      var city = "";
      if(city_name_speical.indexOf(cityFull)>-1)
        city = cityFull.replace(/州/gi,'');
      else
        city = cityFull.replace(/市/gi,'');
      global_current_city_id = city_ids[city];
      global_current_area_name = city;//城关区
      global_position.splice(1,1,cityFull);
      if(zxs[cityFull]!=undefined){
        global_position.splice(2,1,cityFull);
      }
      global_fromProvince = fromProvince;

      var map_url = "";
      var index_url = "";

      if(flag=="sch_ent"){
        map_url = map_url_sch_ent;
        index_url = indexContainer_url;
      }else if(flag=="village_cell_page"){
        map_url = map_url_village_page;
        index_url = indexContainer_village_cell_url;
      }
      freshMapContainer(map_url);
    }
    if(flag=="village_cell_page"){
      loadSmallTab_village_cell(2,global_current_city_id);
      index_url = "";
    }else if(flag=="sch_ent"){
      freshIndexContainer(index_url);
    }
    //freshIndexContainer(index_url);
    //loadSmallTab(global_region_type,global_current_index_type,region_id);
  }

  $(function() {
    if (isIE()) {
      var pageMapHeight = $(window).height();
      if (pageMapHeight == 0)
        pageMapHeight = parent.document.documentElement.clientHeight;
      $("#mapContainer").height(pageMapHeight);
    }

    if('${param.to_sch_ent}'=='1'){
      //switchToCity_inside_page(global_current_city_id,global_position[1],'',"sch_ent");
      if(global_current_city_id=='999')
        switchToCity_inside_page('931','兰州市',1,"sch_ent");
      else
        switchToCity_inside_page(global_current_city_id,global_position[1],'',"sch_ent");
      return;
    }
    $("#mapContainer").attr("src", mapContainer_url);

    if (user_level == 5) {
      $.post(url4Query, {eaction: 'getResidByStationNo', grid_id: global_grid_id}, function (data) {
        data = $.parseJSON(data);
        if (data == null)
          global_report_to_id = "";
        else
          global_report_to_id = data.STATION_ID;
        console.log("global_report_to_id:" + global_report_to_id);
        console.log("loading index page");
        //$("#indexContainer").attr("src", indexContainer_url);
      });
    } else {
      //$("#indexContainer").attr("src", indexContainer_url);
    }

    updateTabPosition();
    global_add4_position_flag = '${param.global_add4_position_flag}';
    if(global_add4_position_flag==1){
      load_list_tab_add4();
    }

    $(".switch_right_index").on("click", function () {
      $("#frmTitle").slideToggle(0);
    });

    //load_option_list(true);
    //init_entrance("");

    if('${param.from_menu}'!=""){
      $("#click_path").hide();
      load_list_view(6,'','','${param.from_menu}');
      //$("#map_mode_view").hide();
      $("#closeTab").hide();
    }else if('${param.from_menu_four_village}'!=""){
      $("#click_path").hide();
      load_list_view(7,'','','${param.from_menu_four_village}');
      //$("#map_mode_view").hide();
      $("#closeTab").hide();
    }else if('${param.from_menu_four_total_village}'!=""){
      $("#click_path").hide();
      load_list_view(8,'','','${param.from_menu_four_total_village}');
      //$("#map_mode_view").hide();
      $("#closeTab").hide();
    }else if('${param.from_menu_important_index_anlysis}'!=""){
      $("#click_path").hide();
      load_list_view(9,'','','${param.from_menu_important_index_anlysis}');
      //$("#map_mode_view").hide();
      $("#closeTab").hide();
    }
  });

  function hide_layer(){
    layer.closeAll();
  }

  var entrance_win_size = [400,300];
  function init_entrance(city_id){
    //快速入口
    $("#entrance_btn_sub").click(function(){
      layer.closeAll();
      global_entrance_type = "sub";
      $("#collect_new_sub_list").show();
      $("#collect_new_grid_list").hide();
      $("#collect_new_village_list").hide();
      $("#collect_new_build_name").val("");
      $("#collect_new_build_name_list").hide();
      layer.open({
        title: '找支局',
        //title:false,
        type: 1,
        shade: 0,
        area: entrance_win_size,
        content: $("#entrance_win"),
        skin: 'sub_summary_div',
        cancel: function (index) {
        }
      });
    });
    $("#entrance_btn_grid").click(function(){
      layer.closeAll();
      global_entrance_type = "grid";
      $("#collect_new_sub_list").hide();
      $("#collect_new_grid_list").show();
      $("#collect_new_village_list").hide();
      $("#collect_new_build_name").val("");
      $("#collect_new_build_name_list").hide();
      layer.open({
        title: '查网格',
        //title:false,
        type: 1,
        shade: 0,
        area: entrance_win_size,
        content: $("#entrance_win"),
        skin: 'sub_summary_div',
        cancel: function (index) {
        }
      });
    });
    $("#entrance_btn_village").click(function(){
      layer.closeAll();
      global_entrance_type = "village";
      $("#collect_new_sub_list").hide();
      $("#collect_new_grid_list").hide();
      $("#collect_new_village_list").show();
      $("#collect_new_build_name").val("");
      $("#collect_new_build_name_list").hide();
      layer.open({
        title: '搜小区',
        //title:false,
        type: 1,
        shade: 0,
        area: entrance_win_size,
        content: $("#entrance_win"),
        skin: 'sub_summary_div',
        cancel: function (index) {
        }
      });
    });
  }

  function hideMapPosition(){
    $("#click_path").hide();
  }
  function showMapPosition(){
    $("#click_path").show();
  }
  function hideFuncFanhui(){
    $("#func_fanhui").hide();
  }
  function showFuncFanhui(){//省市用户显示返回按钮，根据入口来源绑定不同的事件 20181207
    //$("#func_fanhui").show();
    $("#func_fanhui").unbind();
    if(jump_flag_of_parent=="province"){
      $("#func_fanhui").bind("click",function(){
        parent.global_parent_area_name = parent.global_position[0];
        parent.global_current_area_name = parent.global_position[0];
        parent.global_current_full_area_name = parent.global_position[0];
        parent.global_current_city_id = province_id[parent.global_position[0]];
        parent.global_current_flag = 1;
        var url4mapBackTop = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_province_dev_colorflow.jsp"/>';
        parent.freshMapContainer(url4mapBackTop);
        parent.freshIndexContainer(indexContainer_url);
      });
    }else if(jump_flag_of_parent=="city"){
      $("#func_fanhui").bind("click",function(){
        parent.global_parent_area_name = parent.global_position[0];
        parent.global_current_area_name = parent.global_position[1];
        parent.global_current_full_area_name = parent.global_position[1];
        parent.global_current_city_id = global_current_city_id;//以前返回二级地市页面的时候用这个
        parent.global_current_flag = 2;
        var url4mapBackTop = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_city_dev_colorflow.jsp"/>';
        parent.freshMapContainer(url4mapBackTop);
        parent.freshIndexContainer(indexContainer_url);
      });
    }
  }
  function reposMapPosition(){
  	return;
    if(user_level<3){//省市级需要再减去返回按钮宽度
      $("#click_path").css({"left":$("#mainleft").width()-$("#click_path").width()-25-$("#func_fanhui").width()-16});
      $("#func_fanhui").css({"left":$("#mainleft").width()-$("#func_fanhui").width()-16});

      /*
      地址条和层级按钮互换，打开时，层级按钮靠右，地址条靠左
      $("#click_path").css({"right":window.outerWidth-$("#mainleft").width()-6});
      $("#func_fanhui").css({"right":window.outerWidth-$("#mainleft").width()-6});*/
    }else//分局用户没有返回按钮
      $("#click_path").css({"right":window.outerWidth-$("#mainleft").width()-6});
  }
  function resetMapPosition(){
    $("#click_path").css({"left":200});
  }
  function leftMapPosition(){
  	$("#click_path").css({"left":0});
  }
  function hideIndex(){
  	$(".switch_right_index").click();
  }

  function updatePosition(level){
    //$("#click_path").hide();
    /*if(user_level==level)
      $("#click_path").css({"right":"0px"});
    else{
      $("#click_path").css({"right":"37px"});
    }*/
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
          if(i==0){
          	if(global_current_index_is_village_cell=="1")
          		temp += "<a href=\"javascript:void(0);\" onclick=\"javascript:backToEchart("+(i+1)+",'"+global_position_url[i]+"')\" >";
          	else
          		temp += "<a href=\"javascript:void(0);\" onclick=\"javascript:backToPosition("+(i+1)+",'"+global_position_url[i]+"')\" >";
          }
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
    showMapPosition();
  }

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
    if(text==undefined){
      if(global_current_flag==4)
        text = global_position[3];
      else if(global_current_flag==5)
        text = global_position[4];
    }

    if(global_current_flag>=4)
      $(tab_path).html("<div>"+text+"</div>"+"<a id=\"branch_view_open\" style=\"display:none;float:right;margin-right:5px;color:#fff;\" href=\"javascript:void(0);\">视图</a>");
    else
      $(tab_path).html("<div>"+text+"</div>");

    if(global_current_flag==4){
      $.post(url4Query,{"eaction":"getBranchType","union_org_code":global_substation},function(data){
        var data = $.parseJSON(data);
        $(tab_path).append("<div class='a1'>"+data.BRANCH_TYPE+"</div>");
      });
    }else if(global_current_flag==5){
      $.post(url4Query,{"eaction":"getBranchType","grid_union_org_code":global_grid_id},function(data){
        var data = $.parseJSON(data);
        $(tab_path).append("<div class='a2'>"+data.BRANCH_TYPE+"</div>");
      });
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
    //freshIndexContainer(indexContainer_url);
  }

  var jump_flag_of_parent = "";//省市级页面跳转到gis层赋值该变量，当返回echarts层，用此变量确定是省还是市时用到的参数
  function inside(region_id){
    if(global_region_type=="sub"){
      $.post(url4Query_leader,{"eaction":"sub_list","sub_id":region_id},function(data){
        data = $.parseJSON(data);
        data = data[0];
        select_option(global_region_type, data.BUREAU_NAME , data.BUREAU_NO , data.BRANCH_NAME , data.UNION_ORG_CODE ,0, data.LATN_ID , data.LATN_NAME );
      });
    }else if(global_region_type=="grid"){
      $.post(url4Query_leader,{"eaction":"grid_list","grid_id":region_id},function(data){
        data = $.parseJSON(data);
        data = data[0];
        select_option(global_region_type, data.BUREAU_NAME , data.BUREAU_NO , data.BRANCH_NAME , data.UNION_ORG_CODE ,0, data.LATN_ID , data.LATN_NAME , data.GRID_NAME , data.STATION_ID , data.GRID_UNION_ORG_CODE );
      });
    }else if(global_region_type=="village"){
      $.post(url4Query_leader,{"eaction":"village_list","village_id":region_id},function(data){
        data = $.parseJSON(data);
        data = data[0];
        select_option(global_region_type, data.BUREAU_NAME , data.BUREAU_NO , data.BRANCH_NAME , data.UNION_ORG_CODE ,0, data.LATN_ID , data.LATN_NAME , data.GRID_NAME , data.STATION_ID , data.GRID_UNION_ORG_CODE , data.VILLAGE_ID )
      });
    }else if(global_region_type=="village_cell"){
      $.post(url4Query_leader,{"eaction":"grid_list_for_village_cell","village_cell_id":region_id},function(data){
        data = $.parseJSON(data);
        data = data[0];
        select_option(global_region_type,data.BUREAU_NAME , data.BUREAU_NO , data.BRANCH_NAME , data.UNION_ORG_CODE ,0, data.LATN_ID , data.LATN_NAME , data.GRID_NAME , data.STATION_ID , data.GRID_UNION_ORG_CODE );
      });
    }
  }

  function insideToVillage(region_id){
    global_region_type = "village";
    global_entrance_type="village";
    $("#list_mode_view").empty();
    load_map_view();
    inside(region_id);
  }

  function insideToVillageCell(region_id){
    global_village_cell_id = region_id;

    global_region_type = "village_cell";
    global_entrance_type="village_cell";
    $("#list_mode_view").empty();
    load_map_view();
    inside(region_id);
  }

  function loadSmallTab(region_type,index_type,region_id){
    var url = "";
    if (index_type == 0){//家庭宽带渗透率
        url = st_broad_home;
    } else if (index_type == 1){//光网覆盖
        url = st_fb_cover;
    } else if (index_type == 2){//光网实占
        url = st_fb_real_percent;
	} else if (index_type == 3){//精准营销
        url = st_dispatch_yx;
    } else if (index_type == 4){//竞争收集
        url = st_collect;
    } else if (index_type == 5){//存量维系
        url = st_protection;
    }
    freshIndexContainer(url+"?region_id="+region_id+"&region_type="+region_type);
  }
  function loadSmallTab_village_cell(region_type,region_id){
    var url = '<e:url value="/pages/telecom_Index/village_cell/smallTab/small_table_village_cell.jsp" />';
    freshIndexContainer(url+"?region_id="+region_id+"&region_type="+region_type);
  }
  function freshMapContainer(new_url){
    document.getElementById('mapContainer').src=new_url;
  }
  function freshIndexContainer(new_url){
    document.getElementById('indexContainer').src=new_url;
  }
  //右侧开合 右侧收放
  $("#switchPoint").click(function(){
    $(this).toggleClass("showList");
    if($(this).hasClass("showList")){
      $("#frmTitle").css("width","0");
      $("#mainleft").css("width", "99%");
      try{
        resize_vill_win("close");
      }catch(e){
        console.log("子页面未实现"+e);
      }
      try{
        resize_she_dui_view_win("close");
      }catch(e){
        console.log("子页面未实现"+e);
      }
      try{
        resize_building_view_win("close");
      }catch(e){
        console.log("子页面未实现"+e);
      }
    } else {
      $("#frmTitle").css("width","29%");
      $("#mainleft").css("width", "70%");
      try{
        resize_vill_win("open");
      }catch(e){
        console.log("子页面未实现"+e);
      }
      try{
        resize_she_dui_view_win("open");
      }catch(e){
        console.log("子页面未实现"+e);
      }
      try{
        resize_building_view_win("open");
      }catch(e){
        console.log("子页面未实现"+e);
      }
      freshIndexContainer(document.getElementById('indexContainer').src);
    }
    reposMapPosition();
  })

  function showRightDiv(){
    if($("#switchPoint").hasClass("showList")){
      $("#switchPoint").click();
      setTimeout(function(){reposMapPosition()},1000);
      //resize_vill_win("close");
    }
  }
  function hideRightDiv(){
  	if(!$("#switchPoint").hasClass("showList")){
  	  $("#switchPoint").click();
      reposMapPosition();
      //resize_vill_win("open");
  	}
  }

  function load_map_view(){
    //$("#map_mode_view").show();
   /* $("#list_mode_view").slideUp(function(){
        $("#list_mode_view").empty();
    });*/
    $("#list_mode_view").empty();
    $("#list_mode_view").animate({"left":"100%"}, "400", function(){
      $("#map_mode_view").show();
    })
    freshIndexContainer(document.getElementById('indexContainer').src);
  }
  function toCity(){
    var url = "";
    if(user_level<3)
      url = map_url_bureau;
    else if(user_level == 3)
      url = map_url_bureau_user+'?city_id='+user_city_id+'&bureau_no='+user_bureau_no;
    freshMapContainer(url4mapInsideWhere);
  }
  function load_list_view(index_type,flag,region_id,from_menu){
    //2018.10.19 校园政企新模块
    $("#list_mode_view").empty();
    /*$("#list_mode_view").slideDown(function(){
     $("#list_mode_view").load(tab_url);
     });*/

    var tab_url = '<e:url value="/pages/telecom_Index/sandbox_leader/bigTab/"/>';
    tab_url += "big_table_broad_org_frame_load_all.jsp?flag="+flag+"&region_id="+region_id + "&index_type=" + index_type+"&from_menu="+from_menu;

    $("#list_mode_view").animate({"left":0}, "400", function(){
      //$("#map_mode_view").hide();
      $("#list_mode_view").load(tab_url);
    })
  }

  function load_list_view2(city_id,village_type,beginDate,village_degree){
      $("#click_path").hide();
      $("#list_mode_view").empty();
    /*$("#list_mode_view").slideDown(function(){
     $("#list_mode_view").load(tab_url);
     });*/
      // $("#load_list_view2").css({"width":$("body").width()});

    var tab_url = '<e:url value="/pages/telecom_Index/sandbox_leader/bigTab/"/>';
    tab_url += "big_table_broad_org_frame_load_all.jsp?index_type=7"+
    "&city_id="+city_id+"&village_type="+village_type + "&beginDate=" + beginDate + "&village_degree=" + village_degree;

    $("#list_mode_view").animate({"left":0}, "400", function(){
        //$("#map_mode_view").hide();
        $("#closeTab").hide();
      $("#list_mode_view").load(tab_url);
    })
    <%--var tab_url = '<e:url value="/pages/telecom_Index/data_four_type_region_detail/"/>';--%>
    // tab_url += "four_type_region_detail.jsp?flag="+flag+"&region_id="+region_id + "&index_type=" + index_type+"&from_menu="+from_menu;
    // tab_url += "four_type_region_detail.jsp?city_id="+city_id+"&village_type="+village_type + "&beginDate=" + beginDate;
  }

  function load_list_tab_add4(){
    $("#map_mode_view").hide();
    $("#list_mode_view").empty();
    $("#list_mode_view").show();
    $("#list_mode_view").css({"left":"0%"});
    //var user_level = '${sessionScope.UserInfo.LEVEL}';
    //var user_level = '${param.level}';
    //var city_id = '${sessionScope.UserInfo.AREA_NO}';
    //var bureau_id = '${sessionScope.UserInfo.CITY_NO}';
    $("#list_mode_view").load('<e:url value="/pages/telecom_Index/tab_add4_school/tab_add4_org_framework.jsp"/>');
  }

  function switchToCity(region_id,cityFull){
    if(user_level>1)
      return;
    if(region_id=="999"){
      global_current_full_area_name = province_name;
      global_current_flag = 1;
      global_current_city_id = province_id[province_name];
      global_current_area_name = province_name;
      global_position.splice(1,1,'');
      global_position.splice(2,1,'');
      freshMapContainer(map_url_province);
    }else{
      global_current_full_area_name = cityFull;
      global_current_flag = 2;
      var city = "";
      if(city_name_speical.indexOf(cityFull)>-1)
        city = cityFull.replace(/州/gi,'');
      else
        city = cityFull.replace(/市/gi,'');
      global_current_city_id = city_ids[city];
      global_current_area_name = city;//城关区
      global_position.splice(1,1,cityFull);
      if(zxs[cityFull]!=undefined){
        global_position.splice(2,1,cityFull);
      }
      freshMapContainer(map_url_city);
    }
    loadSmallTab(global_region_type,global_current_index_type,region_id);
  }

  var layer_index= "";
  function view_video(){
    try{
      layer_index = layer.load(1, {
        shade: [0.1,'#fff'] //0.1透明度的白色背景
      });
      $.post("<e:url value='videoDecode.e' />",{"enData":"eB9kYacTeowMWCHDu9RUHMFvpaKHPtfTp7O65sguNXyMUBc7xulG2u1RixYQq4ayDG9GzP3g3qEQL02fayBPkLIOBVtFrgOxuefLB3Jwu5nkF5PS9Zqhwn1DpHP9430lZvAyGNX+b7YnWJXwPvTTUNiJ7R2T9fQQK6j3ZpHRf3E=&&&&3dwOkz3g9peg0v5mKIUxTplNlDMZEz63Tupjr9JkOUiAI6noiOcBkEO+QYwH1L5ywjJTB059pQhOBtBi3t5jd7HFJKhImVXzwRROI+R7A3F4mGmIrRy8VkJJ4jNgw0ip5OxAcLGLEmSv9nmBQ/l2vfqRH0YGzQeox1MMvziySlgyZWVwhb97/065VXONdRRBSxbOOVlvNy53P4C1yLBzpEbqbASMrKpfsevRt2BV8SpEb3c65hFnYRq2aAtNvjDu+pEfRgbNB6jHUwy/OLJKWGtMEZoItf3r2qwhMp28Ob6JxhklU03j8OSzKH1CKBjRV8u5zpP7Ov63w/VelYdKkPhtoQENp3mliijRp4bCZATgviYBSaQlNs5J/C/xuzlIpQunINHBfLm1I9NkR+9y6/baIzHu20kNr7y2ebQ+j9mWqvPhgOP8L5PT6/XLFuzDeMl3uhZRaqCPwO2FLrObp9X82ElTTKsH5mokq2+hSjH/Lk3g6R2Ixf9l8BktsFN5/pg97L5KEHBOxtTxgQlGMPI2lokRnJWNaYPSB1ncr9E="},function(data){
        layer.close(layer_index);
        data = $.parseJSON(data);
        if(data.code == 1) {
          $("#myForm").attr("target","_blank");
          $("#content").val(data.msg);
          $("#token").val(data.token);
          //135.149.96.135:9201
          $("#myForm").attr("action", "http://135.149.81.9:9010/videoMiddleware/videoServ/toVideoUrl.action");
          $("#myForm").submit();
        }else{
          layer.msg("无法播放，代码"+data.code+"，描述"+data.msg);
        }
      });
    }catch(e){
      layer.close(layer_index);
      console.log(e);
      alert("服务端解密失败或参数缺失！！！~~~");
    }
  }

  //支局快速筛选
  var sub_list = new Array();
  var grid_list = new Array();
  var village_list = new Array();

  var sub_list_map = new Array();
  var grid_list_map = new Array();
  var village_list_map = new Array();

  var url4Query_leader = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_leader.jsp" />';
  function load_option_list(selected) {
    //var $sub_list =  $("#collect_new_sub_list");
    //var $grid_list =  $("#collect_new_grid_list");
    //var $village_list =  $("#collect_new_village_list");
    //如果是通过 select选择的话,select_count重新开始计数.
    if (selected) {
      select_count = 0;
    }
    //只有当第一次改变input的时候将值置位1;
    if (select_count <= 1) {
      //$sub_list.empty();
      //回写,且只有在手动选中的时候才进行回写.
      if (select_count == 0) {
        $("#collect_new_village_name").val($("#collect_new_village_list").find("option:selected").text());
      }
      //加载支局
      var params = {
        "city_id":global_current_city_id=="999"?'':global_current_city_id,
        "eaction":"sub_list"
      };
      $.post(url4Query_leader, params, function(data) {
        data = $.parseJSON(data);
        if (data.length != 0) {
          var d, newRow = "<option value='-1' select='selected'></option>";
          for (var i = 0, length = data.length; i < length; i++) {
            d = data[i];
            newRow += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME +"</option>";
            //"onchange='select_option(\"sub\",\""+ d.BUREAU_NAME + "\",\"" + d.BUREAU_NO + "\",\"" + d.BRANCH_NAME + "\",\"" + d.UNION_ORG_CODE + "\"," + i + ",\"" + d.LATN_ID + "\",\"" + d.LATN_NAME + "\")'>" + d.BRANCH_NAME + "</option>";
            sub_list.push(d);
            sub_list_map[d.UNION_ORG_CODE] = d;
          }
          //$sub_list.append(newRow);
        }
        /*if (is_first_time_load) {
         $("#collect_new_sub_list option[value=${param.res_id}]").attr("selected", "selected");
         $("#collect_new_sub_list").change();
         is_first_time_load = false;
         }*/
      });
      //加载网格
      var params1 = {
        "city_id":global_current_city_id=="999"?'':global_current_city_id,
        "eaction":"grid_list"
      };
      $.post(url4Query_leader, params1, function(data) {
        data = $.parseJSON(data);
        if (data.length != 0) {
          var d, newRow = "<option value='-1' select='selected'></option>";
          for (var i = 0, length = data.length; i < length; i++) {
            d = data[i];
            newRow += "<option value='" + d.STATION_ID + "'>" + d.GRID_NAME + "</option>";
            //"onchange='select_option(\"grid\",\""+ d.BUREAU_NAME + "\",\"" + d.BUREAU_NO + "\",\"" + d.BRANCH_NAME + "\",\"" + d.UNION_ORG_CODE + "\"," + i + ",\"" + d.LATN_ID + "\",\"" + d.LATN_NAME + "\",\""+ d.GRID_NAME + "\",\"" + d.STATION_ID + "\")'>" + d.GRID_NAME + "</option>";
            grid_list.push(d);
            grid_list_map[d.STATION_ID] = d;
          }
          //$grid_list.append(newRow);
        }
        /*if (is_first_time_load) {
         $("#collect_new_sub_list option[value=${param.res_id}]").attr("selected", "selected");
         $("#collect_new_sub_list").change();
         is_first_time_load = false;
         }*/
      });
      //加载小区
      var params2 = {
        "city_id":global_current_city_id=="999"?'':global_current_city_id,
        "eaction":"village_list"
      };
      $.post(url4Query_leader, params2, function(data) {
        data = $.parseJSON(data);
        if (data.length != 0) {
          var d, newRow = "<option value='-1' select='selected'></option>";
          for (var i = 0, length = data.length; i < length; i++) {
            d = data[i];
            newRow += "<option value='" + d.VILLAGE_ID + "'>" + d.VILLAGE_NAME + "</option>";
            //"onchange='select_option(\"village\",\""+ d.BUREAU_NAME + "\",\"" + d.BUREAU_NO + "\",\"" + d.BRANCH_NAME + "\",\"" + d.UNION_ORG_CODE + "\"," + i + ",\"" + d.LATN_ID + "\",\"" + d.LATN_NAME + "\",\""+ d.GRID_NAME + "\",\"" + d.STATION_ID + "\",\""+ d.VILLAGE_ID +")'>" + d.VILLAGE_NAME + "</option>";
            village_list.push(d);
            village_list_map[d.VILLAGE_ID] = d;
          }
          //$village_list.append(newRow);
        }
        /*if (is_first_time_load) {
         $("#collect_new_sub_list option[value=${param.res_id}]").attr("selected", "selected");
         $("#collect_new_sub_list").change();
         is_first_time_load = false;
         }*/
      });
    }
  }
  //下拉选框选择
  function select_change(entrance_type){
    if(entrance_type=="sub"){
      var sub_id = $("#collect_new_sub_list").val();
      var d = sub_list_map[sub_id];
      select_option(entrance_type, d.BUREAU_NAME, d.BUREAU_NO, d.BRANCH_NAME, d.UNION_ORG_CODE, 0, d.LATN_ID, d.LATN_NAME, '','','')
    }else if(entrance_type=="grid"){
      var grid_id = $("#collect_new_grid_list").val();
      var d = grid_list_map[grid_id];
      select_option(entrance_type, d.BUREAU_NAME, d.BUREAU_NO, d.BRANCH_NAME, d.UNION_ORG_CODE, 0, d.LATN_ID, d.LATN_NAME, d.GRID_NAME, d.STATION_ID,d.GRID_UNION_ORG_CODE,'')
    }else if(entrance_type=="village"){
      var village_id = $("#collect_new_village_list").val();
      var d = village_list_map[village_id];
      select_option(entrance_type, d.BUREAU_NAME, d.BUREAU_NO, d.BRANCH_NAME, d.UNION_ORG_CODE, 0, d.LATN_ID, d.LATN_NAME, d.GRID_NAME, d.STATION_ID,d.GRID_UNION_ORG_CODE, d.VILLAGE_ID)
    }
  }
  //快速筛选
  function load_option_name_list() {
    setTimeout(function() {
      //下拉列表显示
      var $build_list =  $("#collect_new_build_name_list");
      $build_list.empty();
      if (select_count <= 1) {
      }

      var build_name = $("#collect_new_build_name").val().trim();
      if (build_name != '') {
        var temp;
        var newRow = "";
        if(entrance_type=="sub"){
          for (var i = 0, length = sub_list.length, count = 0; i < length; i++) {
            if ((temp = sub_list[i].BRANCH_NAME).indexOf(build_name) != -1) {
              newRow += "<li title='" + temp
              + "' onclick=\"select_option('sub','"+ sub_list[i].BUREAU_NAME + "','" + sub_list[i].BUREAU_NO + "','" + temp + "','" + sub_list[i].UNION_ORG_CODE + "'," + i + ",'" + sub_list[i].LATN_ID + "','" + sub_list[i].LATN_NAME + "')\">" + sub_list[i].LATN_NAME + "      <span style=\"cursor:pointer;\">" + temp + "</span></li>";
              count++;
            }
            /*if (count >= 15) {
              break;
            }*/
          }
        }else if(entrance_type=="grid"){
          for (var i = 0, length = grid_list.length, count = 0; i < length; i++) {
            if ((temp = grid_list[i].GRID_NAME).indexOf(build_name) != -1) {
              newRow += "<li title='" + temp
              + "' onclick=\"select_option('grid','"+ grid_list[i].BUREAU_NAME + "','" + grid_list[i].BUREAU_NO + "','" + grid_list[i].BRANCH_NAME + "','" + grid_list[i].UNION_ORG_CODE + "'," + i + ",'" + grid_list[i].LATN_ID + "','" + grid_list[i].LATN_NAME + "','"+ grid_list[i].GRID_NAME + "','" + grid_list[i].STATION_ID + "','" + grid_list[i].GRID_UNION_ORG_CODE + "')\">" + grid_list[i].LATN_NAME + "      <span style=\"cursor:pointer;\">" + temp + "</span></li>";
              count++;
            }
            /*if (count >= 15) {
              break;
            }*/
          }
        }else if(entrance_type=="village"){
          for (var i = 0, length = village_list.length, count = 0; i < length; i++) {
            if ((temp = village_list[i].VILLAGE_NAME).indexOf(build_name) != -1) {
              newRow += "<li title='" + temp
              + "' onclick=\"select_option('village','"+ village_list[i].BUREAU_NAME + "','" + village_list[i].BUREAU_NO + "','" + village_list[i].BRANCH_NAME + "','" + village_list[i].UNION_ORG_CODE + "'," + i + ",'" + village_list[i].LATN_ID + "','" + village_list[i].LATN_NAME + "','"+ village_list[i].GRID_NAME + "','" + village_list[i].STATION_ID + "','" + village_list[i].GRID_UNION_ORG_CODE + "','" + village_list[i].VILLAGE_ID + "')\">" + village_list[i].LATN_NAME + "      <span style=\"cursor:pointer;\">" + temp + "</span></li>";
              count++;
            }
            /*if (count >= 15) {
              break;
            }*/
          }
        }

        $build_list.append(newRow);
        $("#collect_new_build_name_list").show();
      } else {
        $("#collect_new_build_name_list").hide();
      }

      //联动改变 select框, 只要不做点击, 都会将select改回全部.
      if(entrance_type=="sub")
        $("#collect_new_sub_list option:eq(0)").attr('selected','selected');
      else if(entrance_type=="grid")
        $("#collect_new_grid_list option:eq(0)").attr('selected','selected');
      else if(entrance_type=="grid")
        $("#collect_new_village_list option:eq(0)").attr('selected','selected');

      select_count++;
    }, 300)
  }
  var global_entrance_region_id = "";
  function select_option(entrance_type,bureau_name,bureau_no,branch_name, union_org_code, index, city_id, city_name, grid_name,station_id,grid_union_org_code,village_id) {
    global_current_full_area_name = city_name;
    if(city_name_speical.indexOf(city_name)>-1)
      global_current_area_name = city_name.replace(/州/gi,'');
    else
      global_current_area_name = city_name.replace(/市/gi,'');
    global_entrance_type = entrance_type;

    global_current_city_id = city_id;
    global_position[1] = global_current_area_name;
    global_position_param[1] = city_id;

    global_bureau_id = bureau_no;
    global_position[2] = bureau_name;
    global_position_param[2] = bureau_no;

    global_substation = union_org_code;
    global_position[3] = branch_name;
    global_position_param[3] = union_org_code;

    if(global_entrance_type=="sub"){
      //$("#collect_new_sub_list option[value=" + union_org_code + "]").attr('selected','selected');
      global_entrance_region_id = union_org_code;
      global_current_flag = 4;
      global_current_full_area_name = branch_name;
    }else if(global_entrance_type=="grid"){
      //$("#collect_new_grid_list option[value=" + station_id + "]").attr('selected','selected');
      global_entrance_region_id = station_id;
      global_report_to_id = station_id;
      global_grid_id = grid_union_org_code;
      global_position[4] = grid_name;
      global_position_param[4] = station_id;
      global_current_flag = 5;
      global_current_full_area_name = grid_name;
    }else if(global_entrance_type=="village"){
      //$("#collect_new_village_list option[value=" + village_id + "]").attr('selected','selected');
      global_entrance_region_id = village_id;
      global_village_id = village_id;
      global_report_to_id = station_id;
      global_grid_id = grid_union_org_code;
      global_position[4] = grid_name;
      global_position_param[4] = station_id;
      global_current_flag = 5;
    }else if(global_entrance_type=="village_cell"){
      global_entrance_region_id = station_id;
      global_report_to_id = station_id;
      global_grid_id = grid_union_org_code;
      global_position[4] = grid_name;
      global_position_param[4] = station_id;
      global_current_flag = 5;
      global_current_full_area_name = grid_name;
    }
    $("#collect_new_build_name").val("");
    $("#collect_new_build_name_list").hide();
    //console.log(1);
    layer.closeAll();
    if(global_is_inside){
      global_location();
    }else
      toGIS();
  }
  function toGIS(){
    if(global_current_index_is_village_cell=="0"){
      freshMapContainer(map_url_bureau);
    }else if(global_current_index_is_village_cell=="1"){
      freshMapContainer(map_url_village_page);
    }
    //freshIndexContainer();
  }
  function showEntrance(){
    //$(".entrance_btn_group").show();
  }
  function hideEntrance(){
    $(".entrance_btn_group").hide();
  }
</script>