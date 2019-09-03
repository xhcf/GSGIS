<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" content="ie=edge"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>市级地图</title>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap.js?version=1.1.7"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_city_dev_colorflow.css"/>' rel="stylesheet" type="text/css" media="all" />
</head>
<body class="body_padding" style="position:relative;">
	<div>
		<div id="pagemap" name="pagemap"></div>
        <a href="javascript:void(0)" id="nav_fanhui" ></a>
	</div>
</body>
</html>
<script type="text/javascript">
	//绘制板块，个别区县需绘制所有分块
	var city_draw_speical = {
		"靖远县":1,//白银
		"肃北蒙古族自治县":1,//酒泉
		"肃南裕固族自治县":1//张掖
	};

	parent.global_parent_area_name = parent.global_position[0];
	var parent_name = parent.global_parent_area_name;
	var city_full_name = parent.global_current_full_area_name;
	var city_name = parent.global_current_area_name;
	var index_type = parent.global_current_index_type;
	var url4echartmap = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=echarts_map';
	var url4mapBackTop = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_province_dev_colorflow.jsp"/>';
	var flag = parent.global_current_flag;
	var user_level = '${sessionScope.UserInfo.LEVEL}';//用户的划小层级
	parent.global_position.splice(1,1,city_full_name);
	parent.global_position_param[1] = city_ids[city_name];
	parent.updatePosition(flag);
	parent.global_city_id_for_vp_table = city_ids[city_name];
	parent.global_position_url[1] = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_city_dev_colorflow.jsp"/>';

	//echart地图从市下钻到gis地图

	$(function(){
		if(user_level==1)//省级用户可以点返回
			$("#nav_fanhui").show();
		else
			$("#nav_fanhui").remove();

		var params = new Object();
		params.parent_name = parent_name;
		params.city_name = city_name;
		params.region_id = city_ids[city_name];
		params.city_full_name = city_full_name;
		params.index_type = index_type;
		params.flag = flag;
		params.busi_type = "dev";
		params.date = '${yesterday.VAL}';
		params.series_name = '移动当月发展量';
		//查询地图的数据
		var url4echartmap = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=echarts_map';
		//echart地图下钻要加载的页面
		var url4mapToWhere = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_area_dev_colorflow.jsp"/>';
		var url4devTabToWhere = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev.jsp" />';

		var jsonNo = cityMap[city_full_name];
		$.get('<e:url value="resources/component/echarts_new/geoJson/gansu/"/>'+jsonNo+'.json', function (cityJson) {
			echarts.registerMap(city_name, cityJson);
			setDataToEchartMap(params,url4echartmap,url4mapToWhere,url4devTabToWhere);
		});

		$("#nav_fanhui").click(function(){
			parent.global_parent_area_name = parent.province_name;
			parent.global_current_area_name = parent.province_name;
			parent.global_current_full_area_name = parent.province_name;
			parent.global_current_flag = flag-1;
			parent.global_current_city_id = province_id[province_name];
			parent.freshMapContainer(url4mapBackTop);
			parent.freshIndexContainer(url4devTabToWhere);
		});
	});
</script>