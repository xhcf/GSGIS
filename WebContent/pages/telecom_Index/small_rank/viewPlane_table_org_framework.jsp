<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<html>
<head>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <title>划小排名</title>
</head>
<body>
  <div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;">
  </div>
  <div id="list_div" style="height:99%;margin:0.3% auto;position: absolute;left: 40px;border: 2px solid #2070dc;overflow-y:auto;">
  </div>
</body>
</html>
<script>
  $(function(){
    initMenuDiv();
    initListDiv();
  });
  function initMenuDiv(){
    $("#tools_scroll").load("<e:url value='/pages/telecom_Index/common/jsp/sub_grid_menu1.jsp' />?active=summary");
  }
  function initListDiv(){
    $("#list_div").css({"width":$("body").width()-44});

    var user_level = '${sessionScope.UserInfo.LEVEL}';
    if(user_level=="" || user_level==undefined)
      return;
    if(user_level==1)
      $("#list_div").load("<e:url value='pages/telecom_Index/small_rank/viewPlane_table.jsp' />");
    else if(user_level==2)
      $("#list_div").load("<e:url value='pages/telecom_Index/small_rank/viewPlane_table.jsp' />");
  }
</script>