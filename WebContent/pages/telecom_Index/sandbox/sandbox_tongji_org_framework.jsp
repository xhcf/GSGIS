<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<html>
<head>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
</head>
<body>
  <div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;">
  </div>
  <div id="list_div" style="height:99%;margin:0.3% auto;position: absolute;left: 40px;border: 2px solid #2070dc;overflow-y:auto;">
  </div>
</body>
</html>
<script>
  var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
  //var user_level = '${sessionScope.UserInfo.LEVEL}';
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
    $("#tools_scroll").load("<e:url value='/pages/telecom_Index/common/jsp/sand_sub_grid_menu1.jsp' />?active=summary");
  }
  function initListDiv(level,city_id,bureau_id,branch_id,grid_id){
    $("#list_div").css({"width":$("body").width()-44});
    if(level==1)
      $("#list_div").load('<e:url value="/pages/telecom_Index/sandbox/sandbox_tongji_grid.jsp"/>');
    //else if(level==2)
    //  $("#list_div").load('<e:url value="/pages/telecom_Index/sandbox/sandbox_tongji_grid.jsp"/>?city_id='+city_id);
    else if(level==2)
      $("#list_div").load('<e:url value="/pages/telecom_Index/sandbox/sandbox_tongji_grid.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id);
    else if(level==4)
      $("#list_div").load('<e:url value="/pages/telecom_Index/sandbox/sandbox_tongji_grid.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id);
      //window.open('<e:url value="/pages/telecom_Index/sandbox/sandbox_tongjiDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id,"","");
    else if(level==5)
      $("#list_div").load('<e:url value="/pages/telecom_Index/sandbox/viewPlane_tab_village_grid.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id);
      //window.open('<e:url value="/pages/telecom_Index/sandbox/sandbox_tongjiDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id,"","");
  }

</script>