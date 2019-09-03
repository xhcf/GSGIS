<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:q4o var="time">
  select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') now from dual
</e:q4o>
<html>
<head>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <script type="text/javascript" src="<e:url value="/resources/themes/common/js/watermarker.js?version=1.1" />"></script>
  <title>明细表跳转页</title>
  <style>
    #list_div{
      height: 99%;
      width: 100%;
      position: absolute;
      left: 0;
      border: 2px solid #2070dc;
      -webkit-border-radius:5px;
      -moz-border-radius:5px;
      border-radius:5px;
      -webkit-box-shadow: 3px 2px 3px #0c4bda;
      -moz-box-shadow: 3px 2px 3px #0c4bda;
      box-shadow: 3px 2px 3px #0c4bda;
      overflow: hidden;
      margin-top: 5px;
    }
    .search{border-color:#1851a9;}
  </style>
</head>
<body>
  <div id="list_div">
  </div>
</body>
</html>
<script>
  var flag = '${param.flag}';
  var region_id = '${param.region_id}';
  var index_type = "${param.index_type}";
  $(function(){
    initListDiv();
    $("#nav_index_back").on("click",function(){
      load_map_view();
    });
  });
  function initListDiv(){
	  if (index_type == '0') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/tab_enterprise/viewPlane_tab_enterprise.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  }
  }
  //watermark({ watermark_txt:'${sessionScope.UserInfo.USER_NAME}|${sessionScope.UserInfo.LOGIN_ID}|${time.now}'});
</script>