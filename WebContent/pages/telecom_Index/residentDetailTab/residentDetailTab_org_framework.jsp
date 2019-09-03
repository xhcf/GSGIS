<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<html>
<head>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
  <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js?version=1.0"/>' charset="utf-8"></script>
  <style>
    #list_div {background: #030C57;}
  </style>
</head>
<body>
  <!--<div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;">
  </div>-->
  <div id="list_div" style="height:98%;margin:0.3% auto;position: absolute;left: 00px;border: 2px solid #2070dc;overflow-y:auto;">
  </div>
</body>
</html>
<script>
  var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
  //var user_level = '${sessionScope.UserInfo.LEVEL}';
  var global_current_flag = 1;
  var global_region_id = 999;
  var global_current_city_id = 999;
  var level = '${param.level}';
  var city_id = '${param.city_id}';
  var bureau_id = '${param.bureau_id}';
  var branch_id = '${param.branch_id}';
  var grid_id = '${param.grid_id}';
  $(function(){
    initMenuDiv();
    if(level=="" || level==undefined || level=="undefined")
      level = '${sessionScope.UserInfo.LEVEL}';
    if(city_id=="" || city_id==undefined || city_id=="undefined")
      city_id = '${sessionScope.UserInfo.AREA_NO}';
    if(bureau_id=="" || bureau_id==undefined || bureau_id=="undefined")
      bureau_id = '${sessionScope.UserInfo.CITY_NO}';
    if(branch_id=="" || branch_id==undefined || branch_id=="undefined")
      branch_id = '${sessionScope.UserInfo.TOWN_NO}';
    if(grid_id=="" || grid_id==undefined || grid_id=="undefined")
      grid_id = '${sessionScope.UserInfo.GRID_NO}';
    initListDiv(level,city_id,bureau_id,branch_id,grid_id);
  });
  function initMenuDiv(){
    $("#tools_scroll").load("<e:url value='/pages/telecom_Index/common/jsp/sub_grid_menu1.jsp' />?active=summary");
  }
  function initListDiv(level,city_id,bureau_id,branch_id,grid_id){
    $("#list_div").css({"width":$("body").width()});
    if(level==1)
      $("#list_div").load('<e:url value="/pages/telecom_Index/residentDetailTab/residentDetailTab_tab.jsp"/>');
    else if(level==2)
      $("#list_div").load('<e:url value="/pages/telecom_Index/residentDetailTab/residentDetailTab_tab.jsp"/>?city_id='+city_id);
    else if(level==3)
      $("#list_div").load('<e:url value="/pages/telecom_Index/residentDetailTab/residentDetailTab_tab.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id);
    else if(level==4)
      $("#list_div").load('<e:url value="/pages/telecom_Index/residentDetailTab/residentDetailTab_tab.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id);
    else if(level==5)
      $("#list_div").load('<e:url value="/pages/telecom_Index/residentDetailTab/residentDetailTab_tab.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id);
  }

</script>