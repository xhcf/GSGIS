<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<html>
<head>
  <title>所有角色引导页</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
</head>
<body>
</body>
</html>
<script type="text/javascript">
  var user_level = '${sessionScope.UserInfo.LEVEL}';//用户的划小层级
  var params = "";

  if('${param.global_add4_position_flag}'!="")
    params = "?global_add4_position_flag="+'${param.global_add4_position_flag}';

  if(user_level=="" || user_level==undefined){
    layer.msg("与服务器连接断开，请重新登录");
  }else {
    //省级用户
    if (user_level < 4) {
      debugger;
      //window.location.href = '<e:url value="pages/telecom_Index/sandbox_leader/leader_org_frame.jsp" />'+params;
      if('${sessionScope.UserInfo.SCHOOL_PERMISSIONS}'!=""){
        window.location.href = '<e:url value="pages/telecom_Index/sandbox_leader/leader_org_frame.jsp" />'+params;
      }else{
        window.location.href = '<e:url value="pages/telecom_Index/tab_add4/tab_add4_org_framework.jsp" />'+params;
      }
    } else {
      window.location.href = '<e:url value="pages/telecom_Index/sandbox/sandbox_org_frame.jsp" />'+params;
    }
  }
</script>