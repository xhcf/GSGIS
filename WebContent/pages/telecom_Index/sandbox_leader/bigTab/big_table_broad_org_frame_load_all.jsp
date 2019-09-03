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
		  $("#list_div").load("<e:url value='pages/telecom_Index/sandbox_leader/bigTab/big_table_broad_home_market.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '1') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/sandbox_leader/bigTab/big_table_fb_cover.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '2') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/sandbox_leader/bigTab/big_table_fb_real_percent_use.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '3') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/sandbox_leader/bigTab/big_table_dispatch_yx.jsp' />?flag=" + flag + "&region_id=" + region_id);
	  } else if (index_type == '4') {
		  $("#list_div").load("<e:url value='pages/telecom_Index/sandbox_leader/bigTab/big_table_collect.jsp' />?flag=" + flag + "&region_id=" + region_id);
      } else if (index_type == '5') {
    	  $("#list_div").load("<e:url value='pages/telecom_Index/sandbox_leader/bigTab/big_table_protection.jsp' />?flag=" + flag + "&region_id=" + region_id);
      } else if (index_type == '6') {
          $("#list_div").load("<e:url value='pages/telecom_Index/tab_village_summary/viewPlane_tab_village.jsp' />?flag=" + flag + "&city_id=" + region_id + "&from_menu="+"${param.from_menu}");
      } else if (index_type == '7') {
          $("#list_div").load("<e:url value='pages/telecom_Index/data_four_type_region_detail/four_type_region_detail.jsp' />?city_id=" + "${param.city_id}" + "&village_type="+"${param.village_type}"+"&beginDate="+"${param.beginDate}"+"&village_degree="+village_degree+"&frome_page=1");
      } else if (index_type == '8') {
          $("#list_div").load("<e:url value='pages/telecom_Index/data_four_type_region/four_type_region_index.jsp' />?acctDate="+region_id);
      } else if (index_type == '9') {
          $("#list_div").load("<e:url value='pages/telecom_Index/data_monitor_alarm_new/data_monitor_alarm_tab.jsp' />?from_page=1");
      } else if (index_type =='10') {
          $("#list_div").load("<e:url value='pages/telecom_Index/tab_village_cell_summary/viewPlane_tab_village_cell.jsp' />?flag=" + flag + "&city_id=" + region_id);
      }
  }
  //watermark({ watermark_txt:'${sessionScope.UserInfo.USER_NAME}|${sessionScope.UserInfo.LOGIN_ID}|${time.now}'});
</script>