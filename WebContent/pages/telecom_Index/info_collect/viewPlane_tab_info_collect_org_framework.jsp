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
  $(function(){
    initMenuDiv();
    initListDiv();
  });
  function initMenuDiv(){
    $("#tools_scroll").load("<e:url value='/pages/telecom_Index/common/jsp/sub_grid_menu1.jsp' />?active=info_collect");
  }
  function initListDiv(){
    $("#list_div").css({"width":$("body").width()-44});

    var user_level = '${sessionScope.UserInfo.LEVEL}';
    if(user_level=="" || user_level==undefined)
      return;
    if(user_level==1)
      $("#list_div").load("<e:url value='pages/telecom_Index/info_collect/viewPlane_tab_info_collect_province.jsp' />");
    else if(user_level==2)
      $("#list_div").load("<e:url value='pages/telecom_Index/info_collect/viewPlane_tab_info_collect_grid.jsp' />?city_id="+'${sessionScope.UserInfo.AREA_NO}'+"&bureau_id=999");
    else if(user_level==4)
      $("#list_div").load("<e:url value='pages/telecom_Index/info_collect/viewPlane_tab_info_collect_grid.jsp' />?city_id="+'${sessionScope.UserInfo.AREA_NO}'+"&bureau_id="+'${sessionScope.UserInfo.CITY_NO}'+"&branch_id="+'${sessionScope.UserInfo.TOWN_NO}'+"&grid_id=999");
    else if(user_level==5){
      $.post(url4Query, {"eaction": "getGridIdByGridUnionOrgCode", "grid_id": '${sessionScope.UserInfo.GRID_NO}'}, function (data) {
        data = $.parseJSON(data);
        $("#list_div").load("<e:url value='pages/telecom_Index/info_collect/viewPlane_tab_info_collect_grid.jsp' />?city_id="+'${sessionScope.UserInfo.AREA_NO}'+"&bureau_id="+'${sessionScope.UserInfo.CITY_NO}'+"&branch_id="+'${sessionScope.UserInfo.TOWN_NO}'+"&grid_id="+data.GRID_ID);
      });
    }
  }
  function cityToGrid(city_id,branch_type_temp){
    $("#list_div").load("<e:url value='/pages/telecom_Index/info_collect/viewPlane_tab_info_collect_grid.jsp' />?city_id="+city_id+"&bureau_id=999&branch_type="+branch_type_temp);
  }
  function backToProvince(){
    $("#list_div").load("<e:url value='/pages/telecom_Index/info_collect/viewPlane_tab_info_collect_province.jsp' />");
  }

</script>