<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="yesterday">
  select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="last_month">
  select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>
<e:q4o var="acct_dayDate">
	select const_value ACCT_DAY from ${easy_user}.sys_const_table where const_type = 'var.dss31' AND data_type = 'day' AND model_id = '16'
</e:q4o>
<e:set var="initDay">${acct_dayDate.ACCT_DAY}</e:set>
<e:q4o var="acc_month_tab1">
		select const_value acct_month from ${easy_user}.sys_const_table where const_type = 'var.dss34' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="initMonth">${acc_month_tab1.ACCT_MONTH}</e:set>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" content="ie=edge"/>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <title>市级</title>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
  <link href='<e:url value="/resources/themes/common/css/reset1.css"/>' rel="stylesheet" type="text/css" media="all"/>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <e:script value="/resources/layer/layer.js"/>
  <c:resources type="easyui,app" style="b"/>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
  <!-- echarts 3.2.3 -->
  <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/channel_sandtable/js/channel_geo_center.js?version=New Date()"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/kpi_index.js?version=new Date()"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/channel_sandtable/js/xnglToEchartMap_channel_leader_inside_province.js?version=1.3"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap_sandbox_leader_inside_province2.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap_sandbox_leader_inside_province3.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap_sandbox_leader_inside_province4.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap_sandbox_leader_inside_province5.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap_sandbox_leader_inside_province6.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/convertData.js?version=0.7"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/chartClickAcion.js?version=0.4"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/bureau_geo_center.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/sub_geo_center.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/grid_geo_center.js?version=0.1"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/village_geo_center.js?version=0.1"/>'
          charset="utf-8"></script>
  <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.0"/>'
        rel="stylesheet" type="text/css" media="all"/>
  <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_org_frame.css?version=1.1" />' rel="stylesheet" type="text/css" media="all"/>
  <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_org_frame_reset.css?version=New Date()" />' rel="stylesheet" type="text/css" media="all"/>
  <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_org_frame_colorflow.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all" />
  <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_bureau_index.css?version=1.2.0"/>' rel="stylesheet" type="text/css" media="all" />
  <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/visual_map_range_reset.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />

  <style>
    #pagemap {
      height: 100%;
      width:100%;
    }

    #pagemap div {
      text-align: center;
      margin: auto;
    }
    /*#pagemap div:nth-child(2) {
      background-color: rgba(30, 122, 190, 0.95)!important;
      padding: 0 15px 5px 0 !important;
      border: 1px solid #005a9a !important;
    }*/

    #pagemap canvas {
      text-align: center;
      margin: auto;
      width: 100%;
    }

    /*#pagemap div:nth-child(2){
      text-align: center!important;
      background: rgba(0,0,0,.7)!important;
      padding: 0 20px 10px!important;
    }*/
    #pagemap {
      background: none !important;
    }

    #tools {
      height: 95%;
    }

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
    #left_bottom_float_window{
      left:5px;
    }
    #min_max{
      left:5px;
    }
    .region_switch_group{
      z-index:99;
    }
    #choices_title{
      float:left;
      text-align:left;
      color:#fff;
      font-size:14px;
      height:25px;
      line-height:25px;
    }
    #choices{
      width:200px;
      float:none;
    }
    #choices li{
      color:#fff;
      width:100%;
      padding-left:25px;
    }
    #choices_title{
      float:none;
      width:100px;
    }
    .searches ul li{
      height:25px;
      line-height:25px;
    }
    .searches li:nth-child(1).active:before{
      background: #42c877;
    }
    .searches li:nth-child(2).active:before{
      background: #8ae9b0;
    }
    .searches li:nth-child(3).active:before{
      background: #ff9c2b;
    }
    .searches li:nth-child(4).active:before{
      background: #fcb666;
    }

    #nav_index_view_video {
      background-image:url('<e:url value="pages/telecom_Index/common/images/view_video/view_video_h.gif" />');
      height: 31px;
      width: 147px;
      background-size: 136px 31px;
      background-repeat: no-repeat;
      background-position-x: right;
    }

    /*交换地址条和层级切换*/
    /*.region_switch_group{
      position: absolute;
      right: '-';
      top: 10px;
      left: 200px;
    }*/
    #nav_sub_menu {display:none;position:absolute;z-index:998;width:100px;}

    #nav_sub_menu ul {
    	background-color: #000a7c;
			border-color: #2f4050 transparent transparent #367fa9;
    }
    #nav_sub_menu ul li {
    	border-bottom: 1px #999 solid;
    	color: #fff !important;
    	cursor:pointer;
    	height:27px;
    	text-align:center;
    }
  </style>
</head>
<body>
<div style="position:relative;">
  <div class="leader_tools" id="tools_scroll">
    <ul class="nav_index_group">
      <li id="nav_index_broad_home_percent"><span></span><a href="javascript:void(0)" id="">渠道概览</a></li>
      <li id="nav_index_fb_cover"><span></span><a href="javascript:void(0)" id="">网点清单</a></li>
      <li id="nav_index_channel_count_summary"><span></span><a href="javascript:void(0)">统计报表</a></li>
      <li id="nav_index_channel_add"><span></span><a href="javascript:void(0)">信息归集</a></li>
      <li id="nav_index_channel_source"><span></span><a href="javascript:void(0)">指标口径</a></li>
    </ul>
  </div>
  <!-- <div class="region_switch_group">
    <ul>
      <li region_type = 'city' style="display:none;">市</li>
      <li region_type = 'bureau'>县</li>
      <li region_type = 'sub'>支</li>
      <li region_type = 'grid'>网</li>
      <li region_type = 'village'>小区</li>
    </ul>
  </div> -->
  <div id="nav_sub_menu">
  	<ul>
  		<li>份额统计</li>
  		<li>销售统计</li>
  	</ul>
  </div>
  <div id="pagemap" name="pagemap"></div>

  <div class="searches" style="position:absolute;left:10px;bottom:10px;border:0px;">
    <div id="choices_title"><!-- 地图左下角图例指标名称 --></div>
    <ul id="choices">

    </ul>
    <section class="clear"></section>
  </div>

</div>

<%--yinming 2017年7月26日19:36:19--%>
<%--列表--%>

</body>
</html>
<script type="text/javascript">
  //parent.reposMapPosition();//交换地址条和层级切换
  parent.resetMapPosition();
  parent.global_is_inside = false;
  var parent_name = parent.global_parent_area_name;
  var city_full_name = parent.global_current_full_area_name;
  var city_name = parent.global_current_area_name;
  var index_type = parent.global_current_index_type;
  var flag = parent.global_current_flag;
  var region_type = parent.global_region_type;
  var city_id = parent.global_current_city_id;
  parent.global_position.splice(0, 1, province_name);
  parent.updatePosition(flag);
  parent.global_city_id_for_vp_table = province_id[province_name];
  parent.global_region_id = city_id;
  parent.jump_flag_of_parent = "city";

  var map = "";
  //var city_id = "";
  /* var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_leader.jsp"/>'; */
  var url4Query = '<e:url value="/pages/telecom_Index/channel_sandtable/echartsMapData_channel_leader.jsp"/>';
	var sql_index = '<e:url value="pages/telecom_Index/channel_sandtable/channel_action/channel_indexAction.jsp"/>';
  var sql_url = '<e:url value="/pages/telecom_Index/channel_sandtable/channel_action/channel_leaderAction.jsp" />?eaction=getBureauDataEcharts&flg=2&acct_month='+${initMonth}+'&acct_day='+${initDay};
  var sql_urlxn = '<e:url value="/pages/telecom_Index/channel_sandtable/channel_action/channel_leaderAction.jsp" />?eaction=getBureauDataEcharts_xn&flg=2&acct_month='+${initMonth}+'&acct_day='+${initDay};
  var sql_url1 = '<e:url value="/pages/telecom_Index/channel_sandtable/channel_action/channel_leaderAction.jsp" />?eaction=xn_rank&region_type=2&acct_month='+${initMonth}+"&region_id="+city_id;
  var url4echartmap = "";
  //echart地图要加载的页面
  var url4mapToWhere = '<e:url value="/pages/telecom_Index/channel_sandtable/leader_city_level.jsp"/>';
  var url4devTabToWhere = "";

  var url4mapToJson = "";

  var chart_map = "";

  var province_name_short = province_name.replace("省","");
  var url4mapInsideWhere = '<e:url value="/pages/telecom_Index/channel_sandtable/leader_bureau_level.jsp"/>';
  var url4mapInsideWhere_village_cell = '<e:url value="/pages/telecom_Index/village_cell/leader_bureau_village_cell_level.jsp"/>';
  $(function () {
  	generic_kpi_index0(parent.index_range_map["KPI_D_010"]);
    parent.reposMapPosition();
    parent.showEntrance();
    parent.showRightDiv();
    $(".region_switch_group > ul >li").on("click",function(){
        switch_region($(this).attr("region_type"));
        region_type = $(this).attr("region_type");
        parent.global_region_type = region_type;
    });
    if(region_type=="" || region_type==undefined || region_type=="city")
        region_type = "bureau";
    //parent.global_region_type = "city";//解决地市返回全省变化
        //region_type = "city";
	    switch_region(region_type);

    //$("#pagemap").css({"width":document.body.clientWidth*0.7});
    $(".nav_index_group").children().eq(index_type).addClass("active");
    //左侧指标按钮切换
    $(".nav_index_group").children().each(function(){
      $(this).on("click",function(){
    	//获取被点击按钮的索引
        parent.global_search_text = "";
        $(".region_switch_group").show();
        var index_type_temp = $(".nav_index_group").children().index($(this));
        var index_name = $(this).attr("id");
        if(index_type_temp==1){
          parent.load_list_view(1,'','');//网点清单
        }else if(index_type_temp==2){
          //parent.load_list_view(2,'','');//统计报表
          $("#nav_sub_menu").css({left:$("#nav_index_channel_count_summary").offset().left+$("#nav_index_channel_count_summary").width(),top:$("#nav_index_channel_count_summary").offset().top}).toggle();
        }else if(index_type_temp==3){
          parent.load_list_view(3,'','');//信息归集
        }else if(index_type_temp==4){
          parent.load_list_view(4,'','');//指标口径
        }
      });
    });
    /*子菜单点击事件*/
    $("#nav_sub_menu ul li").each(function(){
    	$(this).on("click",function(){
    		var index = $("#nav_sub_menu ul li").index($(this));
    		if(index==0){
    			parent.load_list_view(2.1,'','');
    		}
    		else if(index==1){
    			parent.load_list_view(2.2,'','');
    		}
    		$("#nav_sub_menu").hide();
    	});
    });
    $("#nav_sub_menu ul").on("mouseleave",function(event){
    		$("#nav_sub_menu").hide();
    });
    $("input[name='percent_check_all']").css({"visibility":"visible"});
    $("input[name='percent_check_none']").css({"visibility":"visible"});
  });

  function switch_region(region_type){
    parent.global_search_text = "";
    $(".region_switch_group li").removeClass("active");
    if(region_type=="city"){
      //这里将返回市级地图
      backToPrevLevel();
    }else if(region_type=="bureau"){
      $(".region_switch_group li:eq(1)").addClass("active");
      url4devTabToWhere = '<e:url value="/pages/telecom_Index/channel_sandtable/smallTab/small_table_broad_home_market_city.jsp" />';
      load_map("bureau");
      load_index(2,index_type,city_id,region_type);
    }else if(region_type=="sub"){
      $(".region_switch_group li:eq(2)").addClass("active");
      url4devTabToWhere = '<e:url value="/pages/telecom_Index/channel_sandtable/smallTab/small_table_broad_home_market_sub.jsp" />';
      load_map("sub");
      load_index(3,index_type,city_id,region_type);
    }else if(region_type=="grid"){
      $(".region_switch_group li:eq(3)").addClass("active");
      url4devTabToWhere = '<e:url value="/pages/telecom_Index/channel_sandtable/smallTab/small_table_broad_home_market_grid.jsp" />';
      load_map("grid");
      load_index(4,index_type,city_id,region_type);
    }else if(region_type=="village"){
      $(".region_switch_group li:eq(4)").addClass("active");
      url4devTabToWhere = '<e:url value="/pages/telecom_Index/channel_sandtable/smallTab/small_table_broad_home_market_village.jsp" />';
      load_map("village");
      load_index(5,index_type,city_id,region_type);
    }
    visualMap_init(index_type,region_type);
  }

  function switch_region_village_cell(){
    load_map_village_cell("city");
    load_index_village_cell(2,city_id);
  }

  function load_map(region_type){
    var params = new Object();
    params.parent_name = parent_name;
    params.city_name = city_name;
    params.region_id = city_ids[city_name];
    params.city_full_name = city_full_name;
    params.index_type = index_type;
    params.flag = flag;
    params.busi_type = "dev";
    params.date = '${yesterday.VAL}';
    params.acct_month = '${initMonth}';//'${last_month.VAL}';
    params.series_name = '';
    params.region_type = region_type;
    params.url4mapInsideWhere = url4mapInsideWhere;

    url4mapToJson = '<e:url value="/pages/telecom_Index/channel_sandtable/js/geoJson/gansu/" />';

    if(region_type=="bureau"){
      //url4echartmap = url4Query+'?eaction=index_bureau';
      var city_name_full = "";
      if(city_name_speical.indexOf(city_name)>-1)
        city_name_full = city_name+"州";
      else
        city_name_full = city_name+"市";
      var map_json = cityMap[city_name_full];
      url4mapToJson += map_json+".json?version=New Date()";
      $.get(url4mapToJson, function (cityJson) {
        echarts.registerMap(city_name, cityJson);
        //chart_map = echarts.init(document.getElementById('pagemap'),"dark");
        //setDataToEchartMap(params, url4echartmap, url4mapToWhere);
        if(index_type== 0){
        	url4echartmap1 = sql_index+'?eaction=tab1_index_bottom&region_type='+(index_type+2)+"&acct_month="+'${acc_month_tab1.ACCT_MONTH}'+"&region_id="+city_id;//"region_type":region_type,"acct_month":'${acc_month_tab1.ACCT_MONTH}'
        	//setDataToEchartMap(params, url4echartmap, url4mapToWhere);
        	url4echartmap = url4Query+'?eaction=index_sub';
          setDataToEchartMap_bar_sub(params, url4echartmap,url4echartmap1, url4mapToWhere,sql_url+'&region_id='+city_id,sql_url1,sql_urlxn);
        }else if(index_type== 1){
        	url4echartmap = url4Query+'?eaction=index_fb_cover_bureau';
        	setDataToEchartMap2(params, url4echartmap, url4mapToWhere);
        }else if(index_type== 2){
        	url4echartmap = url4Query+'?eaction=index_fb_real_percent_bureau';
        	setDataToEchartMap3(params, url4echartmap, url4mapToWhere);
        }else if(index_type== 3){
        	url4echartmap = url4Query+'?eaction=index_dispatch_bureau';
        	setDataToEchartMap4(params, url4echartmap, url4mapToWhere);
        }else if(index_type== 4){
        	url4echartmap = url4Query+'?eaction=index_collect_bureau';
        	setDataToEchartMap5(params, url4echartmap, url4mapToWhere);
        }else if(index_type== 5){
        	url4echartmap = url4Query+'?eaction=index_protection_bureau';
        	setDataToEchartMap6(params, url4echartmap, url4mapToWhere);
        }
        return;
      });
    }

    if(region_type=="sub"){
        url4echartmap = url4Query+'?eaction=index_sub';
        var city_name_full = "";
        if(city_name_speical.indexOf(city_name)>-1)
          city_name_full = city_name+"州";
        else
          city_name_full = city_name+"市";
        var map_json = cityMap[city_name_full];
        url4mapToJson += map_json+".json";
        $.get(url4mapToJson, function (cityJson) {
          echarts.registerMap(city_name, cityJson);
          //chart_map = echarts.init(document.getElementById('pagemap'),"dark");
          params.name = parent.global_search_text;
          if(index_type== 0){
              url4echartmap = url4Query+'?eaction=index_sub';
              setDataToEchartMap_bar_sub(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 1){
              url4echartmap = url4Query+'?eaction=index_fb_cover_sub';
              setDataToEchartMap_bar_sub2(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 2){
        	  url4echartmap = url4Query+'?eaction=index_fb_real_percent_sub';
        	  setDataToEchartMap_bar_sub3(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 3){
        	  url4echartmap = url4Query+'?eaction=index_dispatch_sub';
        	  setDataToEchartMap_bar_sub4(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 4){
        	  url4echartmap = url4Query+'?eaction=index_collect_sub';
        	  setDataToEchartMap_bar_sub5(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 5){
        	  url4echartmap = url4Query+'?eaction=index_protection_sub';
        	  setDataToEchartMap_bar_sub6(params, url4echartmap, url4mapToWhere);
          }
          return;
        });
     }

    if(region_type=="grid"){
        url4echartmap = url4Query+'?eaction=index_grid';
        var city_name_full = "";
        if(city_name_speical.indexOf(city_name)>-1)
          city_name_full = city_name+"州";
        else
          city_name_full = city_name+"市";
        var map_json = cityMap[city_name_full];
        url4mapToJson += map_json+".json";
        $.get(url4mapToJson, function (cityJson) {
          echarts.registerMap(city_name, cityJson);
          params.name = parent.global_search_text;
          //chart_map = echarts.init(document.getElementById('pagemap'),"dark");
          if(index_type== 0){
            	url4echartmap = url4Query+'?eaction=index_grid';
            	setDataToEchartMap_bar_grid(params, url4echartmap, url4mapToWhere);
            }else if(index_type== 1){
            	url4echartmap = url4Query+'?eaction=index_fb_cover_grid';
            	setDataToEchartMap_bar_grid2(params, url4echartmap, url4mapToWhere);
            }else if(index_type== 2){
            	url4echartmap = url4Query+'?eaction=index_fb_real_percent_grid';
          	  	setDataToEchartMap_bar_grid3(params, url4echartmap, url4mapToWhere);
            }else if(index_type== 3){
            	url4echartmap = url4Query+'?eaction=index_dispatch_grid';
          	  	setDataToEchartMap_bar_grid4(params, url4echartmap, url4mapToWhere);
            }else if(index_type== 4){
            	url4echartmap = url4Query+'?eaction=index_collect_grid';
          	  	setDataToEchartMap_bar_grid5(params, url4echartmap, url4mapToWhere);
            }else if(index_type== 5){
            	url4echartmap = url4Query+'?eaction=index_protection_grid';
          	  	setDataToEchartMap_bar_grid6(params, url4echartmap, url4mapToWhere);
            }
          return;
        });
     }

    if(region_type=="village"){
        url4echartmap = url4Query+'?eaction=index_village';
        var city_name_full = "";
        if(city_name_speical.indexOf(city_name)>-1)
          city_name_full = city_name+"州";
        else
          city_name_full = city_name+"市";
        var map_json = cityMap[city_name_full];
        url4mapToJson += map_json+".json";
        $.get(url4mapToJson, function (cityJson) {
          echarts.registerMap(city_name, cityJson);
          params.name = parent.global_search_text;
          //chart_map = echarts.init(document.getElementById('pagemap'),"dark");
          //setDataToEchartMap_bar_village(params, url4echartmap, url4mapToWhere);
          if(index_type== 0){
          	url4echartmap = url4Query+'?eaction=index_village';
          	setDataToEchartMap_bar_village(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 1){
          	url4echartmap = url4Query+'?eaction=index_fb_cover_village';
          	setDataToEchartMap_bar_village2(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 2){
          	url4echartmap = url4Query+'?eaction=index_fb_real_percent_village';
        	  setDataToEchartMap_bar_village3(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 3){
        	  url4echartmap = url4Query+'?eaction=index_dispatch_village';
        	  setDataToEchartMap_bar_village4(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 4){
        	  url4echartmap = url4Query+'?eaction=index_collect_village';
        	  setDataToEchartMap_bar_village5(params, url4echartmap, url4mapToWhere);
          }else if(index_type== 5){
        	  url4echartmap = url4Query+'?eaction=index_protection_village';
        	  setDataToEchartMap_bar_village6(params, url4echartmap, url4mapToWhere);
          }
          return;
        });
     }
  }
  parent.refresh_map = load_map;

  function load_map_village_cell(region_type){
    console.log(city_id,city_full_name,0,"village_page");
    parent.switchToCity_inside_page(city_id,city_full_name,0,"village_page");
  }

  function load_index(region_type,index_type,region_id){
    parent.loadSmallTab(region_type,index_type,region_id);
  }
  function load_index_village_cell(region_type,city_id){
    parent.loadSmallTab_village_cell(region_type,region_id);
  }

  function backToPrevLevel(){
    parent.global_current_flag = parseInt(flag)-1;
    parent.global_current_city_id = '999';
    parent.global_current_area_name = parent_name;
    parent.freshMapContainer('<e:url value="/pages/telecom_Index/channel_sandtable/leader_province_level.jsp"/>');
    parent.loadSmallTab(parseInt(flag)-1,index_type);
  }
  parent.change_echarts_range = function(check_array_for_option){
    chart_map.dispatchAction({
      type: 'selectDataRange',
      selected: check_array_for_option
    })
  }

  function visualMap_init(index_type,region_type){
    $("#choices_title").empty();
    $("#choices").empty();
    $("#choices_title").hide();
    if(index_type==0){//指标1 宽带家庭渗透率
			$("#choices_title").text("渠道类型");
      if(region_type=="bureau" || region_type=="sub" || region_type=="grid" || region_type=="village"){
        $("#choices").append(
          //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_all\" checked=\"checked\" value=\"all\"/>全选</li>"+
           choices_str0.replace(/：/g,"") //+
          // "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_none\" value=\"none\"/>取消</li>"
        );
      }
    }else if(index_type==1){//指标2 光网覆盖
			$("#choices_title").text("光网覆盖率");
      	if(region_type=="bureau" || region_type=="sub" || region_type=="grid" || region_type=="village"){
        	$("#choices").append(
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_all\" checked=\"checked\" value=\"all\"/>全选</li>"+
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-80\"/> 高+ (80-100%)： <span></span></li>"+
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"80-70\"/> 高&nbsp;&nbsp; (70-80%)： <span></span></li>"+
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"70-60\"/> 中+ (60-70%)： <span></span></li>"+
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"60-50\"/> 中&nbsp;&nbsp; (50-60%)： <span></span></li>"+
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"50-40\"/> 低+ (40-50%)： <span></span></li>"+
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"40-0\"/> 低&nbsp;&nbsp; (0-40%)： <span></span></li>"+
            "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_none\" value=\"none\"/>取消</li>"
        	);
      	}/*else if(region_type=="bureau"){

       }else if(region_type=="sub"){

       }else if(region_type=="grid"){

       }else if(region_type=="village"){

       }*/
    }else if(index_type==2){//指标3 光网实占
	$("#choices_title").text("端口占用率");
      if(region_type=="bureau" || region_type=="sub" || region_type=="grid" || region_type=="village"){
        $("#choices").append(
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_all\" checked=\"checked\" value=\"all\"/>全选</li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-60\"/> 高+ (60-100%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"60-50\"/> 高&nbsp;&nbsp; (50-60%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"50-40\"/> 中+ (40-50%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"40-30\"/> 中&nbsp;&nbsp; (30-40%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"30-20\"/> 低+ (20-30%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"20-0\"/> 低&nbsp;&nbsp; (0-20%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_none\" value=\"none\"/>取消</li>"
        );
      }
    }else if(index_type==3){//指标4 精准营销派单
	$("#choices_title").text("执行率");
      if(region_type=="bureau" || region_type=="sub" || region_type=="grid" || region_type=="village"){
        $("#choices").append(
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_all\" checked=\"checked\" value=\"all\"/>全选</li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-60\"/> 高+ (60-100%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"60-50\"/> 高&nbsp;&nbsp; (50-60%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"50-40\"/> 中+ (40-50%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"40-30\"/> 中&nbsp;&nbsp; (30-40%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"30-20\"/> 低+ (20-30%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"20-0\"/> 低&nbsp;&nbsp; (0-20%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_none\" value=\"none\"/>取消</li>"
        );
      }
    }else if(index_type==4){//指标5 竞争信息收集
	$("#choices_title").text("收集率");
      if(region_type=="bureau" || region_type=="sub" || region_type=="grid" || region_type=="village"){
        $("#choices").append(
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_all\" checked=\"checked\" value=\"all\"/>全选</li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-60\"/> 高+ (60-100%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"60-50\"/> 高&nbsp;&nbsp; (50-60%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"50-40\"/> 中+ (40-50%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"40-30\"/> 中&nbsp;&nbsp; (30-40%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"30-20\"/> 低+ (20-30%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"20-0\"/> 低&nbsp;&nbsp; (0-20%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_none\" value=\"none\"/>取消</li>"
        );
      }
    }else if(index_type==5){//指标6 宽带存量保有
	$("#choices_title").text("保有率");
      if(region_type=="bureau" || region_type=="sub" || region_type=="grid" || region_type=="village"){
        $("#choices").append(
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_all\" checked=\"checked\" value=\"all\"/>全选</li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-98\"/> 高+ (98-100%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"98-97\"/> 高&nbsp;&nbsp; (97-98%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"97-96\"/> 中+ (96-97%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"96-95\"/> 中&nbsp;&nbsp; (95-96%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"95-94\"/> 低+ (94-95%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"94-0\"/> 低&nbsp;&nbsp; (0-94%)： <span></span></li>"+
                "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check_none\" value=\"none\"/>取消</li>"
        );
      }
    }
    $("input[name='percent_check_all']").css({"visibility":"visible"});
    $("input[name='percent_check_none']").css({"visibility":"visible"});

    //图例点击事件
    $("#choices li").unbind();
    $("#choices li").bind("click",function(){
      return;
      if($(this).children("input").attr("name")=="percent_check_all"){//点击全选
        $("input[name='percent_check_none']").removeAttr("checked");//取消
        $("#choices li").slice(1,7).children("input").attr("checked","checked");//选择几个指标
        $("#choices li").slice(1,7).addClass("active");
        $("#choices li:first").addClass("active");
      }else if($(this).children("input").attr("name")=="percent_check_none"){//点击取消
        $("input[name='percent_check_all']").removeAttr("checked");//取消全选
        $("#choices li").slice(1,7).children("input").removeAttr("checked");//选择全部
        $("#choices li").slice(1,7).removeClass("active");
        $("#choices li:last").addClass("active");
      }else{
        $(this).toggleClass("active");
      }
      if($(this).hasClass("active")){
        $(this).children("input").attr("checked","checked");
      }else {
        $(this).children("input").removeAttr("checked");
      }

      var condition_str = "";
      var check_array_for_option = {0:false,1:false,2:false,3:false,4:false,5:false};

      var checks = $("input[name='percent_check']:checked");
      if(checks.length==6){//选项都选择了，勾选全选
        $("#choices li:first").children("input").attr("checked","checked");//选择全部
      }else if(checks.length==0){
        $("#choices li:last").children("input").attr("checked","checked");//选择全不部
      }else{
        $("#choices li:first").children("input").removeAttr("checked");
        $("#choices li:last").children("input").removeAttr("checked");
      }
      for(var i = 0,l = checks.length;i<l;i++){
        var c = checks[i];
        var index_str = c.value;
        var index_value_arry = index_str.split("-");
        condition_str += "use_rate1<="+index_value_arry[0]+" and "+"use_rate1>="+index_value_arry[1];
        if(i!=l-1)
          condition_str += " or ";

        check_array_for_option[$("input[name='percent_check']").index($(c))] = true;
      }
      if(checks.length==0){
        condition_str = "1>2";
      }
      var params = new Object();
      if(index_type=="0"){//指标1 宽带家庭渗透率
        if(region_type=="bureau"){
          params.eaction="index_bureau";
          params.region_id = parent.global_current_city_id;
          params.flag = parent.global_current_flag;
        }else if(region_type=="sub"){
          params.eaction="index_sub";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="grid"){
          params.eaction="index_grid";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="village"){
          params.eaction="index_village_count_limited";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }
        params.condition_str = condition_str;
        parent.load_tab(params);
        if(region_type=="village"){
          params.eaction="index_village_cnt";
          parent.get_range_cnt(params);
        }
      }else if(index_type=="1"){//指标2 光网覆盖
        if(region_type=="bureau"){
          params.eaction="index_fb_cover_bureau";
          params.region_id = parent.global_current_city_id;
          params.flag = parent.global_current_flag;
        }else if(region_type=="sub"){
          params.eaction="index_fb_cover_sub";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="grid"){
          params.eaction="index_fb_cover_grid";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="village"){
          params.eaction="index_village_count_fb_cover_limited";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }
        params.condition_str = condition_str;
        parent.load_tab(params);
        if(region_type=="village"){
          params.eaction="index_village_fb_cover_cnt";
          parent.get_range_cnt(params);
        }
      }else if(index_type=="2"){//指标3 光网实占
        if(region_type=="bureau"){
          params.eaction="index_fb_real_percent_bureau";
          params.region_id = parent.global_current_city_id;
          params.flag = parent.global_current_flag;
        }else if(region_type=="sub"){
          params.eaction="index_fb_real_percent_sub";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="grid"){
          params.eaction="index_fb_real_percent_grid";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="village"){
          params.eaction="index_fb_real_percent_village_limited";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }
        params.condition_str = condition_str;
        parent.load_tab(params);
        if(region_type=="village"){
          params.eaction="index_village_real_percent_cnt";
          parent.get_range_cnt(params);
        }
      }else if(index_type=="3"){//指标4 精准派单营销
        if(region_type=="bureau"){
          params.eaction="index_dispatch_bureau";
          params.region_id = parent.global_current_city_id;
          params.flag = parent.global_current_flag;
        }else if(region_type=="sub"){
          params.eaction="index_dispatch_sub";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="grid"){
          params.eaction="index_dispatch_grid";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="village"){
          params.eaction="index_dispatch_village_limited";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }
        params.condition_str = condition_str;
        parent.load_tab(params);
        if(region_type=="village"){
          params.eaction="index_dispatch_village_cnt";
          parent.get_range_cnt(params);
        }
      }else if(index_type=="4"){//指标5 竞争信息收集
        if(region_type=="bureau"){
          params.eaction="index_collect_bureau";
          params.region_id = parent.global_current_city_id;
          params.flag = parent.global_current_flag;
        }else if(region_type=="sub"){
          params.eaction="index_collect_sub";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="grid"){
          params.eaction="index_collect_grid";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="village"){
          params.eaction="index_collect_village_limited";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }
        params.condition_str = condition_str;
        parent.load_tab(params);
        if(region_type=="village"){
          params.eaction="index_collect_village_cnt";
          parent.get_range_cnt(params);
        }
      }else if(index_type=="5"){//指标6 宽带存量保有
        if(region_type=="bureau"){
          params.eaction="index_protection_bureau";
          params.region_id = parent.global_current_city_id;
          params.flag = parent.global_current_flag;
        }else if(region_type=="sub"){
          params.eaction="index_protection_sub";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="grid"){
          params.eaction="index_protection_grid";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }else if(region_type=="village"){
          params.eaction="index_protection_village_limited";
          var region_id = '${param.region_id}';
          if(region_id==undefined || region_id==""){
            params.region_id = parent.global_position[2];
          }else{
            params.region_id = region_id;
          }
          params.flag = parent.global_current_flag;
          if(params.flag=="2")
            params.region_id = parent.global_current_city_id;
          params.city_id = parent.global_current_city_id;
        }
        params.condition_str = condition_str;
        parent.load_tab(params);
        if(region_type=="village"){
          params.eaction="index_protection_village_cnt";
          parent.get_range_cnt(params);
        }
      }
      parent.change_echarts_range(check_array_for_option);
    });
  }

  parent.refresh_range_cnt = function(datas){
    var sub_elements = $("#choices li span");
    for(var i = 0,l = sub_elements.length;i<l;i++){
      $(sub_elements[i]).text(datas[i]);
    }
  }
</script>