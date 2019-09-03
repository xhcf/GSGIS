<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="yesterday">
  select const_value VAL from ${easy_user}.sys_const_table where const_type = 'var.dss35' AND data_type = 'day' AND model_id = '17'
</e:q4o>
<e:q4o var="last_month">
  select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" content="ie=edge"/>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <title>省级</title>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
  <link href='<e:url value="/resources/themes/common/css/reset1.css"/>' rel="stylesheet" type="text/css" media="all"/>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <e:script value="/resources/layer/layer.js"/>
  <c:resources type="easyui,app" style="b"/>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
  <!-- echarts 3.2.3 -->
  <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/kpi_index.js?version=new Date()"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/enterprise_leader/js/setDataToEchartMap_enterprise_leader.js?version=new Date()"/>'
          charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/convertData.js?version=0.6"/>'
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
  <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/leader_org_frame.css?version=1.1" />' rel="stylesheet" type="text/css" media="all"/>
  <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_org_frame_colorflow.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all" />
  <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/leader_bureau_index.css?version=1.2.0"/>' rel="stylesheet" type="text/css" media="all" />
  <link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/enterprise_leader_reset.css?version=new Date()"/>' rel="stylesheet" type="text/css" media="all" />

  <style>
    #pagemap {
      height: 100%;
      width:100%;
    }

    #pagemap div {
      text-align: center;
      margin: auto;
    }

    #pagemap canvas {
      text-align: center;
      margin: auto;
      width: 100%;
    }

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
    /*.searches ul li span{
      color:red;
    }*/
    .searches li:nth-child(1).active:before{
      background: #fff;
    }
    .searches li:nth-child(2).active:before{
      background: #42c877;
    }
    .searches li:nth-child(3).active:before{
      background: #8ae9b0;
    }
    .searches li:nth-child(4).active:before{
      background: #ff9c2b;
    }
    .searches li:nth-child(5).active:before{
      background: #fcb666;
    }
    .searches li:nth-child(6).active:before{
      background: #f67d7f;
    }
    .searches li:nth-child(7).active:before{
      background: #f04144;
    }
    .searches li:nth-child(8).active:before{
      background: #fff;
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
    }打开则地址栏靠右，层级切换靠左*/

  	.tab_body td {border:1px solid #1D427A;width:25%;text-align: center;}
  </style>
</head>
<body>
<div style="position:relative;">
  <div class="leader_tools" id="tools_scroll">
    <ul class="nav_index_group">
      <li id="nav_index_enterprise_summary"><span></span><a href="javascript:void(0)">校园概况</a></li>
      <li id="nav_index_enterprise_detail"><span></span><a href="javascript:void(0)">校园清单</a></li>
    </ul>
  </div>
  <%--<div class="region_switch_group">
    <ul>
      <li region_type = 'city'>市</li>
      <li region_type = 'bureau'>县</li>
      <li region_type = 'sub'>支</li>
      <li region_type = 'grid'>网</li>
      <li region_type = 'village'>小区</li>
    </ul>
  </div>--%>
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
  parent.global_position.splice(0, 1, province_name);
  parent.updatePosition(flag);
  parent.global_city_id_for_vp_table = province_id[province_name];
  parent.global_region_id = "";
  parent.jump_flag_of_parent = "province";

  var map = "";
  var city_id = "";
  var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData_enterprise_leader.jsp"/>';

  var url4echartmap = url4Query+'?eaction=index_map&level=1&acct_day='+'${yesterday.VAL}';
  //echart地图要加载的页面
  var url4mapToWhere = '<e:url value="/pages/telecom_Index/enterprise_leader/leader_province_level.jsp"/>';

  var url4mapInsideWhere = '<e:url value="/pages/telecom_Index/enterprise_leader/leader_city_level.jsp"/>';

  var url4devTabToWhere = "";

  var url4mapToJson = "";

  var chart_map = "";

  var province_name_short = province_name.replace("省","");
  var region_type = "";

  //宽带家庭渗透率
  var pieces0 = "";//echarts中使用 {value:xxx,color:xxx}
  var value_range0 = "";//convertData.js中使用的参数 [60,45,30,0]
  var choices_str0 = "";//自定义左下角图例，选项（字符串格式）

  $(function () {
    var kpi_list = new Array();
    kpi_list.push({"RANGE_NAME":"渗透率","RANGE_NAME_SHORT":">=65%","RANGE_SIGNL":">=","RANGE_MIN":65,"RANGE_SIGNER":"","RANGE_MAX":"","RANGE_COUNT":65});
    kpi_list.push({"RANGE_NAME":"渗透率","RANGE_NAME_SHORT":"40-65%","RANGE_SIGNL":">=","RANGE_MIN":40,"RANGE_SIGNER":"<","RANGE_MAX":65,"RANGE_COUNT":40});
    kpi_list.push({"RANGE_NAME":"渗透率","RANGE_NAME_SHORT":"30-40%","RANGE_SIGNL":">=","RANGE_MIN":30,"RANGE_SIGNER":"<","RANGE_MAX":40,"RANGE_COUNT":30});
    kpi_list.push({"RANGE_NAME":"渗透率","RANGE_NAME_SHORT":"<30%","RANGE_SIGNL":"","RANGE_MIN":"","RANGE_SIGNER":"<","RANGE_MAX":30,"RANGE_COUNT":30});
    var res0 = generic_kpi_index(kpi_list);
    pieces0 = res0[0];
    value_range0 = res0[1];
    choices_str0 = res0[2].replace(/：/g,"");

    parent.reposMapPosition();
    parent.showEntrance();
    parent.showRightDiv();

    if(region_type==undefined || region_type=="")
      region_type = "city";

    switch_region(region_type);

    if(parent.global_current_index_is_village_cell=="1")
      $("#nav_index_village_page").addClass("active");
    else
      $(".nav_index_group").children().eq(index_type).addClass("active");
    //左侧指标按钮切换
    $(".nav_index_group").children().each(function(){
      $(this).on("click",function(){
    	//获取被点击按钮的索引
        parent.global_search_text = "";
        $(".region_switch_group").show();
        var index_type_temp = $(".nav_index_group").children().index($(this));
        var index_name = $(this).attr("id");
        if(index_name=="nav_index_enterprise_detail"){//城市小区清单
          parent.load_list_view(0,'','');
        }else{//前6个指标
          index_type = index_type_temp;
          parent.global_current_index_type = index_type_temp;
          parent.global_current_index_is_village_cell = "0";
          $(this).addClass("active").siblings().removeClass("active");
          switch_region(region_type);
        }
      });
    });
    $("input[name='percent_check_all']").css({"visibility":"visible"});
    $("input[name='percent_check_none']").css({"visibility":"visible"});
  });

  function switch_region(region_type){
    parent.global_search_text = "";
    $(".region_switch_group").show();
    $(".region_switch_group li").removeClass("active");
    if(region_type=="city"){
      $(".region_switch_group li:eq(0)").addClass("active");
      load_map("city");
      load_index(1,index_type);
    }
    visualMap_init(index_type,region_type);
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
    params.acct_month = '${last_month.VAL}';
    params.series_name = '';
    params.region_type = region_type;
    params.url4mapInsideWhere = url4mapInsideWhere;

    if(region_type=="city"){
      url4mapToJson = '<e:url value="/pages/telecom_Index/sandbox_leader/js/gan_su_geo.json" />';
      $.get(url4mapToJson, function (cityJson) {
        echarts.registerMap(province_name_short, cityJson);
        //chart_map = echarts.init(document.getElementById('pagemap'),"dark");
        if(index_type== 0){
        	url4echartmap = url4Query+'?eaction=index_map&level=1&acct_day='+'${yesterday.VAL}';
        	setDataToEchartMap(params, url4echartmap, url4mapToWhere);
        }
        return;
      });
    }
  }
  parent.refresh_map = load_map;

  function load_index(region_type,index_type){
    parent.loadSmallTab(region_type,index_type);
  }

  parent.change_echarts_range = function(check_array_for_option){
    chart_map.dispatchAction({
      type: 'selectDataRange',
      selected: check_array_for_option
    })
  }
  //图例初始化
  function visualMap_init(index_type,region_type){
    $("#choices_title").empty();
    $("#choices").empty();
    if(index_type==0){//指标1 移动渗透率
      $("#choices_title").text("移动渗透率");
      $("#choices").append(
              "<li class=\"active\" style=\"display:none;\"><input type=\"checkbox\" name=\"percent_check_all\" checked=\"checked\" value=\"all\"/>全选</li>"+
              choices_str0 +
                //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-40\"/> 高+ (40-100%)：<span></span></li>"+
                //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-65\"/> 高&nbsp;&nbsp;  (65-100%)：<span></span></li>"+
                //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"35-30\"/> 中+ (30-35%)：<span></span></li>"+
                //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"65-40\"/> 中&nbsp;&nbsp;  (40-65%)：<span></span></li>"+
                //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"40-30\"/> 中低&nbsp;&nbsp;  (30-40%)：<span></span></li>"+
                //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"25-20\"/> 低+ (20-25%)：<span></span></li>"+
                //"<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"30-0\"/> 低&nbsp;&nbsp;  (0-30%)：<span></span></li>"+
              "<li class=\"active\" style=\"display:none;\"><input type=\"checkbox\" name=\"percent_check_none\" value=\"none\"/>取消</li>"
      );
    }
    $("input[name='percent_check_all']").css({"visibility":"visible"});
    $("input[name='percent_check_none']").css({"visibility":"visible"});

    //图例点击事件
    $("#choices li").unbind();
    $("#choices li").bind("click",function(){
      if($(this).children("input").attr("name")=="percent_check_all"){//点击全选
        $("input[name='percent_check_none']").removeAttr("checked");//取消
        $("#choices li").slice(1,value_range0.length+1).children("input").attr("checked","checked");//选择几个指标
        $("#choices li").slice(1,value_range0.length+1).addClass("active");
        $("#choices li:first").addClass("active");
      }else if($(this).children("input").attr("name")=="percent_check_none"){//点击取消
        $("input[name='percent_check_all']").removeAttr("checked");//取消全选
        $("#choices li").slice(1,value_range0.length+1).children("input").removeAttr("checked");//选择全部
        $("#choices li").slice(1,value_range0.length+1).removeClass("active");
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
      var index_name = "index_val1";
      var check_array_for_option = objDiy(value_range0.length);

      var checks = $("input[name='percent_check']:checked");
      if(checks.length==value_range0.length){//选项都选择了，勾选全选
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
        condition_str += index_name+"<="+index_value_arry[0]+" and "+index_name+">="+index_value_arry[1];
        if(i!=l-1)
          condition_str += " or ";

        check_array_for_option[$("input[name='percent_check']").index($(c))] = true;
      }
      if(checks.length==0){
        condition_str = "1>2";
      }
      var params = new Object();
      if(index_type=="0"){//指标1 宽带家庭渗透率
        if(region_type=="city"){
          params.eaction="index_map";
          params.level=1;
          params.acct_day='${yesterday.VAL}';
        }

        params.condition_str = condition_str;
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

  parent.hide_range_cnt = function(){
    $(".searches").hide();
  }

  parent.show_range_cnt = function(){
    $(".searches").show();
  }
</script>