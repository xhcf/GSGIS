<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>省级地图</title>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
	<script src='<e:url value="/resources/component/echarts_new/theme/dark.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap1.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/real_time_dev/css/viewPlane_province_realTime.css"/>' rel="stylesheet" type="text/css" media="all" />
</head>
<body>
	<div style="position:relative;">
		<div class="title_pos ico1">地图</div>
		<div id="pagemap" name="pagemap" style=""></div>
	</div>
</body>
</html>
<script type="text/javascript">
	var parent_name = parent.global_parent_area_name;
	var city_full_name = parent.global_current_full_area_name;
	var city_name = parent.global_current_area_name;
	var province_py = parent.global_province_py;
	var index_type = parent.global_current_index_type;
	var flag = parent.global_current_flag+1;

	var realTime_subList_data = parent.realTime_subList_data;

	parent.global_position.splice(0,1,province_name);
	parent.updatePosition(flag-1);

	var chart = "";
	$(function(){
		var size = parent.getEchartsMapSize();
		$("#pagemap").height(size.height);
		$("#pagemap").width(size.width);
		chart = echarts.init(document.getElementById('pagemap'),"dark");
		var params = new Object();
		params.parent_name = parent_name;
		params.province_py = province_py;
		params.city_name = city_name;
		params.city_full_name = city_full_name;
		params.index_type = index_type;
		params.flag = flag;
		//查询地图的数据
		var url4echartmap = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=realTimeSubList';
		//echart地图下钻要加载的页面
		var url4mapToWhere = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_city_dev_colorflow.jsp"/>';
		setDataToEchartMap(params,url4echartmap,url4mapToWhere);
		setInterval(function(){
			//chart.clear();
			//chart = echarts.init(document.getElementById('pagemap'),"dark");
			//realTime_subList_data = new Array();
			setDataToEchartMap(params,url4echartmap,url4mapToWhere);
		},parent.interval_time);
	});
</script>