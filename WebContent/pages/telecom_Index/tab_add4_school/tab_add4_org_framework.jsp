<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="org_info">
  <e:if condition="${empty param.flag || param.flag eq '1'}" var="isProvince">
    select '' latn_id,'' bureau_no,'' union_org_code,'' grid_id from dual
  </e:if>
  <e:else condition="${isProvince}">
    select
      distinct
    <e:if condition="${param.flag eq '2'}">
      latn_id
    </e:if>
    <e:if condition="${param.flag eq '3'}">
      latn_id,
      bureau_no
    </e:if>
    <e:if condition="${param.flag eq '4'}">
      latn_id,
      bureau_no,
      union_org_code
    </e:if>
    <e:if condition="${param.flag eq '5'}">
      latn_id,
      bureau_no,
      union_org_code,
      grid_id
    </e:if>
    from ${gis_user}.db_cde_grid where
    <e:if condition="${param.flag eq '2'}">
      latn_id = '${param.org_id}'
    </e:if>
    <e:if condition="${param.flag eq '3'}">
      bureau_no = '${param.org_id}'
    </e:if>
    <e:if condition="${param.flag eq '4'}">
      union_org_code = '${param.org_id}'
    </e:if>
    <e:if condition="${param.flag eq '5'}">
      grid_id = '${param.org_id}'
    </e:if>
  </e:else>
</e:q4o>
<html>
<head>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
  <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js?version=1.0"/>' charset="utf-8"></script>
  <style>
    #list_div1 {background: #030C57;}
  </style>
</head>
<body>
  <!--<div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;">
  </div>-->
  <div id="list_div1" style="height:98%;margin:0.3% auto;position: absolute;left: 00px;border: 2px solid #2070dc;overflow-y:auto;">
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
  var city_id = '${org_info.LATN_ID}';
  var bureau_id = '${org_info.BUREAU_NO}';
  var branch_id = '${org_info.UNION_ORG_CODE}';
  var grid_id = '${org_info.GRID_ID}';
  $(function(){
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
  function initListDiv(level,city_id,bureau_id,branch_id,grid_id){
    $("#list_div1").css({"width":$("body").width()});
    /*if(level==1)
      $("#list_div").load('<e:url value="/pages/telecom_Index/tab_add4_school/tab_add4_tab.jsp"/>');
    else if(level==2)
      $("#list_div").load('<e:url value="/pages/telecom_Index/tab_add4_school/tab_add4_tab.jsp"/>?city_id='+city_id);
    else if(level==3)
      $("#list_div").load('<e:url value="/pages/telecom_Index/tab_add4_school/tab_add4_tab.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id);
    else if(level==4)
      $("#list_div").load('<e:url value="/pages/telecom_Index/tab_add4_school/tab_add4_tab.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id);
    else if(level==5)*/
      $("#list_div1").load('<e:url value="/pages/telecom_Index/tab_add4_school/tab_add4_tab.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id+"&query_type="+"${param.query_type}"+"&flag="+"${param.flag}");
  }

</script>