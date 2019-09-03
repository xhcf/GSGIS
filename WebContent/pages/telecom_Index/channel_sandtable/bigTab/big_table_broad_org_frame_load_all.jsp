<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:q4o var="time">
  select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') now from dual
</e:q4o>
<html>
<head>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
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
		  $("#list_div").load("<e:url value='pages/telecom_Index/channel_sandtable/bigTab/big_table_broad_home_market.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '1') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/channel_sandtable/bigTab/big_table_business_locations.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '2') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/channel_sandtable/bigTab/tab_channel_count_tab.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '2.1'){
	  	$("#list_div").load("<e:url value='pages/telecom_Index/channel_sandtable/bigTab/tab_channel_count_tab.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '2.2'){
	  	$("#list_div").load("<e:url value='pages/telecom_Index/channel_sandtable/bigTab/big_table_channel_sale_analyse.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '3') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/other_internet_manager/viewPlane_tab_village_grab_day_org_framework.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '4') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/channel_sandtable/bigTab/big_table_channel_sale_analyse_org_framework.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  }
  }
  //watermark({ watermark_txt:'${sessionScope.UserInfo.USER_NAME}|${sessionScope.UserInfo.LOGIN_ID}|${time.now}'});
</script>