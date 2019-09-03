<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<html>
<head>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
</head>
<body>
</body>
</html>
<script>
  $(function(){
    var user_level = '${sessionScope.UserInfo.LEVEL}';
    if(user_level=="" || user_level==undefined)
      return;
    if(user_level==1)
      window.location.href = ("<e:url value='pages/telecom_Index/tab_broadband_business/viewPlane_broadband_business_province.jsp' />");
    else if(user_level==2)
      window.location.href = ("<e:url value='pages/telecom_Index/tab_broadband_business/viewPlane_broadband_business_grid.jsp' />?city_id="+'${sessionScope.UserInfo.AREA_NO}'+"&bureau_id=999");
    else if(user_level==4)
      window.location.href = ("<e:url value='pages/telecom_Index/tab_broadband_business/viewPlane_broadband_business_grid.jsp' />?city_id="+'${sessionScope.UserInfo.AREA_NO}'+"&branch_no="+'${sessionScope.UserInfo.TOWN_NO}'+"&grid_id=999");
    else if(user_level==5)
      window.location.href = ("<e:url value='pages/telecom_Index/tab_broadband_business/viewPlane_broadband_business_grid.jsp' />?city_id="+'${sessionScope.UserInfo.AREA_NO}'+"&branch_no="+'${sessionScope.UserInfo.TOWN_NO}'+"&grid_id="+'${sessionScope.UserInfo.GRID_NO}');
  });
</script>