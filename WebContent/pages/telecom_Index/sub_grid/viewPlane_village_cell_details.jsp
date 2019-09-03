<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="village_info">
	select village_name from ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO t where village_id = '${param.village_id}'
</e:q4o>
<e:q4o var="last_month">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>

<e:description>融移用户</e:description>
<e:q4o var="rh_yd">
	SELECT COUNT(PROD_INST_YD) YD_COUNT FROM ${gis_user}.TB_GIS_VILLAGE_YD_INFO_D WHERE VILLAGE_ID = '${param.village_id}'
</e:q4o>

<e:description></e:description>

<e:q4l var="index_range_list">
	SELECT
	KPI_CODE,
	RANGE_NAME,
	RANGE_NAME_SHORT,
	RANGE_SIGNL,
	RANGE_MIN,
	RANGE_SIGNR,
	RANGE_MAX
	FROM ${gis_user}.TB_GIS_KPI_RANGE
	WHERE IS_VALID = 1
	ORDER BY KPI_CODE ASC, RANGE_INDEX ASC
</e:q4l>
<e:q4o var="yx_last_month">
	SELECT max(const_value) val FROM ${easy_user}.sys_const_table where model_id=10 AND data_type='mon'
</e:q4o>
<html>
<head>
	<title>行政村工作台</title>
	<meta charset="utf-8">
	<meta name="author" content="jasmine">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css?version=2.5"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.4"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.0"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
	<link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_desk.css?version=1.0"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.5" />' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_village_page_view.css?version=1.6"/>' rel="stylesheet" type="text/css" media="all"/>
	<style>
		#village_view_bussiness_count{
			color:red;
		}
		input {
			border-radius: 3px;
			border: 1px solid #ddd;
			padding: 0 4px;
			outline: none;
			color: #777;
		}
		#collect_new_build_name4{background-color:#none;}
		#village_view_latn,#village_view_bureau,#village_view_sub,#village_view_grid{font-size:12px;}
		.sub_summary_tabs_title{cursor:default;background:#007BA9;}
		.sub_summary_index_content{border-color:#007BA9;}
		.li_first_important{width:100%!important;}
		.li_first_important li:first-child {
			font-weight: bold;
		}
		.li_first_important li:first-child span{
			font-weight: normal;
		}
		.li_first_important li:first-child:before {
			position: absolute;
			content: '';
			top: 50%;
			left: 0;
			display: block;
			width: 4px;
			height: 4px;
			margin-top: -2px;
			background: #000;
			-webkit-border-radius: 50%;
			-moz-border-radius: 50%;
			border-radius: 50%;
		}
		.index_desc{line-height:20px;text-align: center;}

		/*小区工作台 单宽数列表*/
		#vill_dkd_div {display:none;padding:0 10px;}
		#vill_dkd_head tr th:first-child{width:8%;}
		#vill_dkd_head tr th:nth-child(2){width:17%;}
		#vill_dkd_head tr th:nth-child(3){width:12%;}
		#vill_dkd_head tr th:nth-child(4){width:18%;}
		#vill_dkd_head tr th:nth-child(5){width:45%;}

		#vill_dkd_list tr td:first-child{width:8%;text-align:center;}
		#vill_dkd_list tr td:nth-child(2){width:17%;text-align:center;}
		#vill_dkd_list tr td:nth-child(3){width:12%;text-align:center;}
		#vill_dkd_list tr td:nth-child(4){width:18%;text-align:center;}
		#vill_dkd_list tr td:nth-child(5){width:45%;text-align:left;}

		#vill_rh_div {display:none;padding:0 10px;}
		#vill_rh_head tr th:first-child{width:8%;}
		#vill_rh_head tr th:nth-child(2){width:17%;}
		#vill_rh_head tr th:nth-child(3){width:12%;}
		#vill_rh_head tr th:nth-child(4){width:18%;}
		#vill_rh_head tr th:nth-child(5){width:45%;}

		#vill_rh_list tr td:first-child{width:8%;text-align:center;}
		#vill_rh_list tr td:nth-child(2){width:17%;text-align:center;}
		#vill_rh_list tr td:nth-child(3){width:12%;text-align:center;}
		#vill_rh_list tr td:nth-child(4){width:18%;text-align:center;}
		#vill_rh_list tr td:nth-child(5){width:45%;text-align:left;}

		#vill_obd_user_div {display:none;padding:0 10px;}
		#vill_obd_user_head tr th:first-child{width:6%;}
		#vill_obd_user_head tr th:nth-child(2){width:12%;}
		#vill_obd_user_head tr th:nth-child(3){width:15%;}
		#vill_obd_user_head tr th:nth-child(4){width:15%;}
		/*#vill_obd_user_head tr th:nth-child(5){width:12%;}*/
		#vill_obd_user_head tr th:nth-child(5){width:8%;}
		#vill_obd_user_head tr th:nth-child(6){width:15%;}
		#vill_obd_user_head tr th:nth-child(7){width:29%;}/*17*/

		#vill_obd_user_list tr td:first-child{width:6%;text-align:center;}
		#vill_obd_user_list tr td:nth-child(2){width:12%;text-align:center;}
		#vill_obd_user_list tr td:nth-child(3){width:15%;text-align:center;}
		#vill_obd_user_list tr td:nth-child(4){width:15%;text-align:center;}
		/*#vill_obd_user_list tr td:nth-child(5){width:12%;text-align:left;}*/
		#vill_obd_user_list tr td:nth-child(5){width:8%;text-align:center;}
		#vill_obd_user_list tr td:nth-child(6){width:15%;text-align:center;}
		#vill_obd_user_list tr td:nth-child(7){width:29%;text-align:center;}/*17*/

		#vill_dkd_list_scroll,#vill_rh_list_scroll,#vill_obd_user_list_scroll{
			height:55%;
			overflow-y: scroll;
		}
		#vill_dkd_count,#vill_rh_count {color:red;}
		.div_hide.div_obd_2 .head_table tr th:first-child {width:5%;}
		.div_hide.div_obd_2 .head_table tr th:nth-child(2) {width:18%;}
		.div_hide.div_obd_2 .head_table tr th:nth-child(3) {width:30%;}
		.div_hide.div_obd_2 .head_table tr th:nth-child(4) {width:12%;}
		.div_hide.div_obd_2 .head_table tr th:nth-child(5) {width:12%;}
		.div_hide.div_obd_2 .head_table tr th:nth-child(6) {width:12%;}

		#obd_build_info_list tr td:first-child {width:5%;}
		#obd_build_info_list tr td:nth-child(2) {width:18%;}
		#obd_build_info_list tr td:nth-child(3) {width:30%;}
		#obd_build_info_list tr td:nth-child(4) {width:12%;}
		#obd_build_info_list tr td:nth-child(5) {width:12%;}
		#obd_build_info_list tr td:nth-child(6) {width:12%;color:#ffa22e;font-weight:bolder;}

		.head_table tr{background: #007BA9;}
		.btn {
			background: #007ba9;
			color: #fff;
			width: 55px;
			height: 25px;
		}
		#build_obd_m_tab2{height:60%;border-bottom:1px solid #efefef;}

		/*行政村工作台 单宽用户清单弹窗*/
		.vill_obd_user_div {border:1px solid #039ac0;}
		.vill_obd_user_div .layui-layer-title {background-color:#039ac0!important;}
		.vill_obd_user_div .layui-layer-setwin {top:6px;}

		.clickable {text-decoration:underline!important;color:#01469d!important;}

		#vill_obd_user_head tr {background:#039ac0!important;}
		.collect_contain_choice input, .collect_contain_choice select, .collect_contain_choice ul {position:relative;left:0;}

		.andSoOn{
			width:50%;
			white-space: nowrap;
			text-overflow: ellipsis;
			overflow:hidden;
		}
	</style>
	<script type="text/javascript">
		var village_id = '${param.village_id}';
        var build_list = [];
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData_village_cell.jsp" />';
        //共同社队ID,标签联动切换使用,需要子页面去秀给他的编号
        var common_bulid_id  = "-1";
        var obd_head_all=0,obd_head_0=0,obd_head_1=0,obd_head_g=0;

		var index_range_str_temp = ${e:java2json(index_range_list.list)};
		var index_range_map = new Array();
		for(var i = 0,l = index_range_str_temp.length;i<l;i++){
			var index_item = index_range_str_temp[i];
			var index_map = index_range_map[index_item['KPI_CODE']];
			if(index_map!=undefined)
				index_map.push(index_item);
			else{
				index_map = new Array();
				index_map.push(index_item);
			}
			index_range_map[index_item['KPI_CODE']] = index_map;
		}

		function getVillageBaseInfo(village_id){
			$.post(url4Query, {eaction: "getVillageBaseInfo", village_id: village_id}, function (data) {
				var objs = $.parseJSON(data);
				if(objs.length){
					var obj = objs[0];
					//隐藏域
					$("#village_view_title").text(obj.LATN_NAME);
					parent.village_paint_name = obj.LATN_NAME;
					//第一个标签页
					//基础
					/*$.post(url4Query,{eaction:"getLatnNameBureauNameByUnionOrgCode","union_org_code":obj.V_SUB_ID},function(data){
					 var obj_temp = $.parseJSON(data);
					 $("#village_view_latn").text(obj_temp.LATN_NAME);
					 $("#village_view_bureau").text(obj_temp.BUREAU_NAME);
					 });
					 $("#village_view_sub").text(obj.V_SUB_NAME);
					 $("#village_view_grid").text(obj.V_GRID_NAME);
					 $("#village_view_creator").text(obj.CREATOR_NAME);
					 $("#village_view_create_time").text(obj.CREATE_TIME);
					 $("#village_view_gua_ce_time").text(obj.GUA_CE_TIME);//挂测时间*/

					//市场
					$("#village_view_market_lv").text(obj.MARKT_LV);

					//marketFlag(obj.MARKET_RATE1);

					$("#village_view_zhu_hu").text(obj.HOUSEHOLD_NUM);
					//$("#village_view_zhu_hu1").text(obj.GZ_ZHU_HU_SHU);
					//$("#village_view_zhu_hu2").text(obj.GZ_ZHU_HU_SHU);

					$("#village_view_gz_h_use").text(obj.POPULATION_NUM);//人口数
					$("#village_view_kd_h_use").text(obj.H_USE_CNT);//宽带数
					$("#village_view_itv_use").text(obj.ITV_USE_CNT);//高清数
					$("#village_view_dkd_use_cnt").text(obj.D_USE_CNT);//单宽数
					$("#village_view_rh_use_cnt").text(obj.R_USE_CNT);//融合数

					$("#village_view_shedui_cnt").text(obj.BRIGADE_ID_CNT);//社队数

					$("#village_view_arpu_hu").text(obj.ARPU);//户均
					$("#village_view_arpu_hu1").text(obj.ARPU);//户均

					$("#village_view_arpu_dk").text(obj.D_ARPU);//单宽ARPU
					$("#village_view_arpu_rh").text(obj.R_ARPU);//融合ARPU
					$("#village_view_arpu_month").text(obj.CHARGE);//行政村收入

					//$("#village_view_gov_zhu_hu").text(obj.GOV_ZHU_HU_COUNT);
					//$("#village_view_gov_h_use").text(obj.GOV_H_USE_CNT);

					//资源
					$("#village_view_port_lv").text(obj.PORT_LV);
					$("#village_view_port_num").text(obj.CAPACITY);
					$("#village_view_port_used").text(obj.ACTUALCAPACITY);
					//$("#village_view_free_port").text(obj.KONG_PORT_CNT);

					//覆盖率
					$("#village_view_build_count").text(obj.LY_CNT);
					$("#village_view_reached_build").text(obj.RES_ARRIVED_CNT);
					//$("#village_view_unreach_build").text(obj.NO_RES_ARRIVE_CNT);

					$("#village_view_obd").text(obj.EQP_CNT);
					$("#village_view_hobd").text(obj.HIGH_USE_CNT);
					$("#village_view_obd01").text(obj.ZERO_USE_CNT);

					$("#village_view_resource_percent").text(obj.FG_LV);//资源覆盖率
					$("#village_view_resource_shequ").text(obj.ZY_CNT);//资源已达社队

					$("#village_view_compete_percent").text(obj.COLLECT_LV);
					$("#village_view_should_collect_cnt").text(obj.Y_COLLECT_CNT);
					$("#village_view_collected_cnt").text(obj.COLLECT_CNT);
					$("#village_view_yw_cnt").text(obj.YW_COLLECT_CNT);
					$("#village_view_zx_cnt").text(obj.ZX_COLLECT_CNT);

					//$("#village_view_exec_rate").text();///执行率

					//竞争 新口径在village_compete_info方法中
					//$("#village_view_compete_percent").text(obj.COMPETE_PERCENT);

					//obd_head_all=obj.OBD_CNT,obd_head_0=obj.ZERO_OBD_CNT,obd_head_1=obj.FIRST_OBD_CNT,obd_head_g=obj.HIGH_USE_OBD_CNT;
					//竞争其他指标在village_compete_info方法中

					//规模
					//$("#village_view_ru_zhu_lv").text(obj.VILLAGE_RU_RATE);

					//modeFlag(obj.GZ_ZHU_HU_SHU);

					/*$("#village_view_village_mode").text(obj.VILLAGE_GM);

					 console.log("obj.VILLAGE_GM:"+"'"+obj.VILLAGE_GM+"");
					 if($.trim(obj.VILLAGE_GM)!="")
					 $("#tag_mode").text(obj.VILLAGE_GM);//规模标签 tag
					 else
					 $("#tag_mode").html("&nbsp;");

					 $("#village_view_village_attr").text(obj.VILLAGE_VALUE);*/
					/*$("#village_view_village_xf").text(obj.VILLAGE_XF);

					 //营销
					 $("#village_view_collect_lv").text(obj.COLLECT_LV);
					 $("#village_view_should_collect").text(obj.SHOULD_COLLECT_CNT);
					 $("#village_view_already_collect").text(obj.ALREADY_COLLECT_CNT);

					 var bussiness_count = 0;
					 var bussiness_text = "";
					 if(obj.WIDEBAND_IN==1){
					 bussiness_count += 1;
					 bussiness_text += "电信";
					 }
					 if(obj.CM_OPTICAL_FIBER==1){
					 bussiness_count += 1;
					 if(bussiness_text!="")
					 bussiness_text += "/";
					 bussiness_text += "移动";
					 }
					 if(obj.CU_OPTICAL_FIBER==1){
					 bussiness_count += 1;
					 if(bussiness_text!="")
					 bussiness_text += "/";
					 bussiness_text += "联通";
					 }
					 if(obj.SARFT_OPTICAL_FIBER==1){
					 bussiness_count += 1;
					 if(bussiness_text!="")
					 bussiness_text += "/";
					 bussiness_text += "广电";
					 }
					 if(obj.OTHER_OPTICAL_FIBER==1){
					 bussiness_count += 1;
					 if(bussiness_text!="")
					 bussiness_text += "/";
					 bussiness_text += "其他";
					 }
					 $("#village_view_bussiness_count").text(bussiness_count);
					 $("#village_view_bussiness_text").text(bussiness_text);*/
				}

			});

			villageCellYXSummary();
			getVillagePath();
			//village_compete_info();
			//intraday_num();
		}

		function villageCellYXSummary(){
			$.post(url4Query, {eaction: "villageCell_yx_summary", village_id: village_id}, function (data) {
				var objs = $.parseJSON(data);
				if(objs.length){
					var d = objs[0];
					$("#village_view_exec_rate").text(d.YX_COUNT);//目标数
					$("#village_view_exec_cnt").text(d.ZX_COUNT);//执行数
					$("#village_view_exec_lv").text(d.ZX_LV);//执行率
					$("#village_view_succ_cnt").text(d.SUC_COUNT);//成功数
					$("#village_view_succ_lv").text(d.SUC_LV);//成功率
				}else{
					$("#village_view_exec_rate").text("0");//目标数
					$("#village_view_exec_cnt").text("0");//执行数
					$("#village_view_exec_lv").text("--");//执行率
					$("#village_view_succ_cnt").text("0");//成功数
					$("#village_view_succ_lv").text("--");//成功率
				}
			});
		}
		function getVillagePath(){
			$.post(url4Query, {eaction: "villageCellPath", village_id: village_id}, function (data) {
				var objs = $.parseJSON(data);
				if(objs.length){
					var d = objs[0];
					$("#village_cell_path_hx").text(d.HX_FRM);
					$("#village_cell_path_xz").text(d.XZ_FRM);
				}
			});
		}

		function marketFlag(market_rate){
			var tag_market_str = "";
			var market_range = index_range_map["KPI_D_001"];
			for(var i = 0,l = market_range.length;i<l;i++){
				var item = market_range[i];
				if(item.RANGE_MAX==null){//最大值
					if(item.RANGE_SIGNL=='>='){
						if(market_rate >= item.RANGE_MIN){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='>'){
						if(market_rate > item.RANGE_MIN){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
				}else if(item.RANGE_MIN==null){//最小值
					if(item.RANGE_SIGNR=='<='){
						if(market_rate <= item.RANGE_MAX){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='<'){
						if(market_rate < item.RANGE_MAX){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
				}else{
					if(item.RANGE_SIGNL=='>='){
						if(market_rate >= item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(market_rate < item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(market_rate <= item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}else if(item.RANGE_SIGNL=='>'){
						if(market_rate > item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(market_rate < item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(market_rate <= item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}
				}
			}
			if(tag_market_str!="")
				tag_market_str += "渗透";

			$("#tag_market").text(tag_market_str);//渗透标签 tag
		}

		function modeFlag(gz_zhs){
			var village_gm_str = "";
			var village_gm_range = index_range_map["KPI_D_002"];
			for(var i = 0,l = village_gm_range.length;i<l;i++){
				var item = village_gm_range[i];
				if(item.RANGE_MAX==null){//最大值
					if(item.RANGE_SIGNL=='>='){
						if(gz_zhs >= item.RANGE_MIN){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='>'){
						if(gz_zhs > item.RANGE_MIN){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
				}else if(item.RANGE_MIN==null){//最小值
					if(item.RANGE_SIGNR=='<='){
						if(gz_zhs <= item.RANGE_MAX){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='<'){
						if(gz_zhs < item.RANGE_MAX){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
				}else{
					if(item.RANGE_SIGNL=='>='){
						if(gz_zhs >= item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(gz_zhs < item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(gz_zhs <= item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}else if(item.RANGE_SIGNL=='>'){
						if(gz_zhs > item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(gz_zhs < item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(gz_zhs <= item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}
				}
			}

			$("#village_view_village_mode").text(village_gm_str+"规模");
			$("#tag_mode").text(village_gm_str+"规模");
		}

		var vill_dkd_div_size = ["75%","80%"];//620 360
		var vill_obd_user_div_size = ["90%","85%"];//620 360
		var vill_dkd_div_handle = "";
		var vill_rh_div_handle = "";

		$(function(){
			//第一个标签页，小区汇总信息
			getVillageBaseInfo(village_id);

			//融移用户
			//$("#village_view_rh_yd").text('${rh_yd.YD_COUNT}');

			//单宽数
			/*$.post(url4Query,{"eaction":"get_dkd_count","village_id":village_id},function(data){
				var d = $.parseJSON(data);
				$("#village_view_dkd_use_cnt").text(d.COUNT);
				if(d.COUNT>0){
					$("#village_view_dkd_use_cnt").addClass("summary_index_clickable");
					$("#village_view_dkd_use_cnt").unbind();
					$("#village_view_dkd_use_cnt").on("click",function(){
						clearVillDkdList();
						villDkdList();
						vill_dkd_div_handle = layer.open({
							title: ['单宽用户清单', 'font-size:18px;text-align:center;'],
							type: 1,
							shade: 0,
							maxmin: false, //开启最大化最小化按钮
							area: vill_dkd_div_size,
							content: $("#vill_dkd_div"),
							skin: 'vill_dkd_div',
							cancel: function (index) {
								layer.close(vill_dkd_div_handle);
							},
							full: function() { //点击最大化后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
							},
							restore: function() { //点击还原后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css("top",'6px');
							}
						});
					});
				}
			});*/

			//融合数
			/*$.post(url4Query,{"eaction":"get_rh_count","village_id":village_id},function(data){
				var d = $.parseJSON(data);
				$("#village_view_rh_use_cnt").text(d.COUNT);
				if(d.COUNT>0){
					$("#village_view_rh_use_cnt").addClass("summary_index_clickable");
					$("#village_view_rh_use_cnt").unbind();
					$("#village_view_rh_use_cnt").on("click",function(){
						clearVillRhList();
						villRhList();
						vill_rh_div_handle = layer.open({
							title: ['融合用户清单', 'font-size:18px;text-align:center;'],
							type: 1,
							shade: 0,
							maxmin: false, //开启最大化最小化按钮
							area: vill_dkd_div_size,
							content: $("#vill_rh_div"),
							skin: 'vill_dkd_div',
							cancel: function (index) {
								layer.close(vill_rh_div_handle);
							},
							full: function() { //点击最大化后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
							},
							restore: function() { //点击还原后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css("top",'6px');
							}
						});
					});
				}
			});*/

			//第四个标签页，OBD清单
            //initOBDComobo(village_id);

			$("#query_btn_obd").unbind();
			$("#query_btn_obd").bind("click",function(){
				console.log("query_btn_obd click");
				clear_data_OBD();
				load_obd_build();
			});

			//标签切换
			var $div_li = $(".tab_menu span");
			$div_li.click(function () {
				$(this).addClass("selected")            //当前<li>元素高亮
						.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
				var index = $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
				$("div.tab_box > div")      //选取子节点。不选取子节点的话，会引起错误。如果里面还有div
						.eq(index).show()   //显示 <li>元素对应的<div>元素
						.siblings().hide(); //隐藏其它几个同辈的<div>元素
				if(index!=0){
					$("#village_view_title").parent().hide();
				}else{
					$("#village_view_title").parent().show();
				}
                if(index==1){//第二个标签页，社队清单
					emptyAllDiv();
					$("#vill_cell_sd_content").load('<e:url value="/pages/telecom_Index/common/jsp/vill_cell_sd_content.jsp"/>?village_id=' + village_id);
                }else if(index==2){//第三个标签页，用户清单
					emptyAllDiv();
                    $("#zhuhuqingdan").load("<e:url value='/pages/telecom_Index/common/jsp/vill_cell_info_tab.jsp' />?village_id=" + village_id);
                }else if(index==3){//第四个标签页，OBD清单 obd页签
					emptyAllDiv();
					$("#collect_new_build_list_sj_obd_id").width($("#collect_new_build_list_sj_obd_id").parent().width()-$("#collect_new_build_list_sj_obd_id").prev().width()-$("#query_btn_obd").width()*3);
					$("#collect_new_build_list4 option").eq(0).attr("selected","selected");
					var text = $("#collect_new_build_list4").find("option:selected").text();
					$("#collect_new_build_name4").val(text);
					initOBDOption();
					clear_data_OBD();
					load_obd_build();
					load_odb_build_sum_cnt();
					load_obd_build_type_cnt();
                }else if(index==4){//第五个标签页，营销清单
					//修改子页面的社队id
					emptyAllDiv();
					$("#vill_cell_yx_content").load('<e:url value="/pages/telecom_Index/common/jsp/vill_cell_yx_content.jsp"/>?village_id=' + village_id);
                }else if(index==5){//第六个标签页，流失用户
					emptyAllDiv();
					$("#vill_cell_yhzt_content").load('<e:url value="/pages/telecom_Index/common/jsp/vill_cell_yhzt_content.jsp"/>?village_id='+village_id);
                }else if(index==6){//第七个标签页，收集清单
					emptyAllDiv();
					$("#info_content").load('<e:url value="/pages/telecom_Index/common/jsp/vill_cell_add6_tab.jsp"/>?village_id='+village_id);
                }
				//console.log("common_bulid_id:"+common_bulid_id);
			})

			$("#village_paint").unbind();
			$("#village_paint").bind("click",function(){
				parent.villagePaintTrigger();
			});

			//单宽用户清单滚动加载
			var begin_scroll_village = "";
			$("#vill_dkd_list_scroll").scroll(function () {
				var viewH = $(this).height();
				var contentH = $(this).get(0).scrollHeight;
				var scrollTop = $(this).scrollTop();
				//alert(scrollTop / (contentH - viewH));

				if (scrollTop / (contentH - viewH) >= 0.95) {
					if (new Date().getTime() - begin_scroll_village > 500) {
						villDkdPage++;
						villDkdList();
					}
					begin_scroll_village = new Date().getTime();
				}
			});
			$("#vill_rh_list_scroll").scroll(function () {
				var viewH = $(this).height();
				var contentH = $(this).get(0).scrollHeight;
				var scrollTop = $(this).scrollTop();
				//alert(scrollTop / (contentH - viewH));

				if (scrollTop / (contentH - viewH) >= 0.95) {
					if (new Date().getTime() - begin_scroll_village > 500) {
						villRhPage++;
						villRhList();
					}
					begin_scroll_village = new Date().getTime();
				}
			});
			$("#vill_obd_user_list_scroll").scroll(function () {
				var viewH = $(this).height();
				var contentH = $(this).get(0).scrollHeight;
				var scrollTop = $(this).scrollTop();
				//alert(scrollTop / (contentH - viewH));

				if (scrollTop / (contentH - viewH) >= 0.95) {
					if (new Date().getTime() - begin_scroll_village > 500) {
						villObdUserPage++;
						villObdUserList();
					}
					begin_scroll_village = new Date().getTime();
				}
			});
		});

		var eqp_no = "";
		var villDkdPage = 0;
		var vill_dkd_order = 1;

		function villDkdList(){
			$.post(url4Query,{"eaction":"get_dkd_list","village_id":village_id,"page":villDkdPage},function(data){
				var list = $.parseJSON(data);
				if(list.length){
					for(var i = 0,l = list.length;i<l;i++){
						var d = list[i];
						if(i==0 && villDkdPage==0)
							$("#vill_dkd_count").text(d.C_NUM);
						var row = "<tr><td>"+(vill_dkd_order++)+"</td><td>"+ (d.TELE_NO)+"</td><td>"+ nameHide(d.USER_CONTACT_PERSON) +"</td><td>"+ (d.USER_CONTACT_NBR)+"</td><td>"+ d.STAND_NAME_2+"</td></tr>";
						$("#vill_dkd_list").append(row);
					}
				}else{
					if(villDkdPage==0)
						$("#vill_dkd_count").text("0");
				}
			});
		}

		var villRhPage = 0;
		var vill_rh_order = 1;

		function villRhList(){
			$.post(url4Query,{"eaction":"get_rh_list","village_id":village_id,"page":villRhPage},function(data){
				var list = $.parseJSON(data);
				if(list.length){
					for(var i = 0,l = list.length;i<l;i++){
						var d = list[i];
						if(i==0 && villRhPage==0)
							$("#vill_rh_count").text(d.C_NUM);
						var row = "<tr>";
						row += "<td>"+(vill_rh_order++)+"</td>";
						row += "<td><a href='javascript:void(0);' onclick='cust_agent(\"\",\""+ d.PROD_INST_ID+"\",\""+ d.SEGM_ID_2+"\",\"\",\"\")'>"+ (d.TELE_NO)+"</a></td>";
						row += "<td>"+ nameHide(d.USER_CONTACT_PERSON) +"</td>";
						row += "<td>"+ (d.USER_CONTACT_NBR)+"</td>";
						row += "<td>"+ d.STAND_NAME_2+"</td>";
						row += "</tr>";
						$("#vill_rh_list").append(row);
					}
				}else{
					if(villRhPage==0)
						$("#vill_rh_count").text("0");
				}
			});
		}

		var villObdUserPage = 0;
		var vill_ObdUser_order = 1;

		function villObdUserList(){
			$.post(url4Query,{"eaction":"get_obd_user_list","eqp_no":eqp_no,"village_id":village_id,"page":villObdUserPage},function(data){
				var list = $.parseJSON(data);
				if(list.length){
					for(var i = 0,l = list.length;i<l;i++){
						var d = list[i];
						if(i==0 && villObdUserPage==0)
							$("#vill_obd_user_count").text(d.C_NUM);
						var row = "<tr>";
						row += "<td>"+(vill_ObdUser_order++)+"</td>";
						row += "<td><a class='clickable' href='javascript:void(0);' onclick='javascript:cust_agent(\""+d.BRIGADE_ID+"\",\""+ d.PROD_INST_ID+"\",\"\",\"\",\"\",0)'>"+ nameHide(d.SERV_NAME)+"</td>";
						row += "<td>"+ d.ACC_NBR+"</td>";
						row += "<td>"+ d.FINISH_DATE+"</td>";
						//row += "<td>"+ d.INET_MONTH+"</td>";
						row += "<td>"+ d.STOP_TYPE_NAME+"</td>";
						row += "<td>"+ d.USER_CONTACT_NBR+"</td>";
						row += "<td>"+ d.PORT_ID+"</td>";
						row += "</tr>";
						$("#vill_obd_user_list").append(row);
					}
				}else{
					if(villObdUserPage==0)
						$("#vill_obd_user_count").text("0");
				}
			});
		}

		function villObdUserSummary(){
			$.post(url4Query,{"eaction":"get_obd_user_summary","eqp_no":eqp_no},function(data){
				var d = $.parseJSON(data);
				if(d.length){
					var obj = d[0];
					$("#obd_no").text(""+obj.EQP_NO);
					$("#obd_install_address").text(""+obj.ADDRESS);
					$("#obd_install_address").attr("title",obj.ADDRESS);
					$("#port_cnt").text(obj.CAPACITY);
					$("#port_used_cnt").text(obj.ACTUALCAPACITY);
					$("#port_lv").text(obj.RATE);
				}
			});
		}

		function clear_data_obd_user_list(){
			eqp_no = "";villObdUserPage = 0;vill_ObdUser_order = 1;
			$("#vill_obd_user_list").empty();
			$("#vill_obd_user_count").text("0");
		}

		function cust_agent(brigade_id,prod_inst_id,add6,mkt_campaign_id,pa_date,tab_id){
			var param = {};
			param.brigade_id = brigade_id;
			param.prod_inst_id = prod_inst_id;
			param.add6 = add6;
			param.mkt_campaign_id = mkt_campaign_id;
			param.pa_date = pa_date;
			param.tab_id = tab_id;
			param.village_id = village_id;
			param.is_village = 1;
			parent.openCustViewByProdInstId(param);
		}

		function phoneHide(phone){
			if(phone.length>5){
				var d = phone.substr(0,3);
				for(var i = 0,l = phone.length-5;i<l;i++){
					d += "*";
				}
				return d+phone.substr(-2);
			}else
				return phone;

		}
		function nameHide(name){
			var name = $.trim(name);
			if(name.length>1){
				var d = name.substr(0,1);
				/*for(var i = 0,l = name.length-1;i<l;i++){
					d += "*";
				}
				return d;*/
				return d+"**";
			}
			return name;
		}

		function clearVillDkdList(){
			$("#vill_dkd_list").empty();
			villDkdPage = 0;
			vill_dkd_order = 1;
		}

		function clearVillRhList(){
			$("#vill_rh_list").empty();
			villRhPage = 0;
			vill_rh_order = 1;
		}

		function clearVillObdUserList(){
			$("#vill_obd_user_list").empty();
			villObdUserPage = 0;
			vill_ObdUser_order = 1;
		}
	</script>
</head>
<body class="village_cell_win">
    <div class="info_collect_win_new" id="info_collect_edit_div" style="display:none;height: 200px;">
        <!--<div class="titlea">
            <div id="info_collect_edit_draggable" style='text-align:left;width:90%;display: inline-block'>竞争收集</div>
            <div class="titlec" id="info_collect_edit_div_close"></div>
        </div>-->
        <iframe width="100%" height="100%"></iframe>
    </div>
	<h3 class="wrap_a tab_menu desk_menu" style="border-left:none;padding-left:11px;background:#007BA9;">
		<span style="cursor:pointer;" class="selected">基本概况</span>
		<span style="cursor:pointer;">社队清单</span>
		<span style="cursor:pointer;">用户清单</span>
		<span style="cursor:pointer;">OBD清单</span>
		<span style="cursor:pointer;">营销清单</span>
		<span style="cursor:pointer;">流失用户</span>
		<span style="cursor:pointer;">收集清单</span>

		<!--<span style="cursor:pointer;">营销清单</span> |
		<span style="cursor:pointer;">竞争收集</span> -->

		<!--<div class="bulid_village_btn village_edit" style="top:-10px;width:auto;margin-right:17px;">
			<button id="village_paint">画像</button>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
			<button id="editBuildInVillage_btn" onclick="javascript:parent.editBuildInVillage();">编辑</button>
			<button id="deleteBuildInVillage_btn" onclick="javascript:parent.deleteBuildInVillage();">删除</button>
			</e:if>
		</div>-->
	</h3>

	<div class="tab_box">
		<!--概况-->
       <div style="width:100%;padding:0 1 0 0;">
		   <span class="village_name_new desk_orange_bar" style="display: block!important;">
			<span id="village_view_title" class="cate2"></span>
			<!--(<span id="village_view_latn"></span>-<span id="village_view_bureau"></span>-<span id="village_view_sub"></span>-<span id="village_view_grid"></span>)-->
			(<span style="font-weight:bold;font-size:14px;">划小：</span><span id="village_cell_path_hx" style="font-weight:normal;font-size:13px;"></span><span style="font-weight:bold;font-size:14px;margin-left:10px;">行政：</span><span id="village_cell_path_xz" style="font-weight:normal;font-size:13px;"></span>)
			</span>
		   <div class="desk_tag" style="display:none;">
			   <span id="tag_market"></span> <span id="tag_compete"></span><span id="tag_mode"></span>
		   </div>
		   <div class="sub_summary_tabs tabs_suvery">

				<div style="clear:both;float:none;">
					<div id="" class="sub_summary_tabs_title" style="background:#007BA9;">市场</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_market_lv" class="village_summary_percent_num"></div>
							<div class="index_desc">宽带渗透率</div>
						</div>
						<ul class="li_first_important">
							<li>住户数：<span id="village_view_zhu_hu"></span></li>
							<li>人口数：<span id="village_view_gz_h_use"></span></li>
							<li>宽带数：<span id="village_view_kd_h_use"></span></li>
							<li>高清数：<span id="village_view_itv_use"></span></li>
							<li>单宽数：<span id="village_view_dkd_use_cnt"></span></li>
							<li>融合数：<span id="village_view_rh_use_cnt"></span></li>
						</ul>
						<ul class="li_first_important">
							<li>社队数：<span id="village_view_shedui_cnt"></span></li>
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div id="" class="sub_summary_tabs_title" style="background:#007BA9;">价值</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_arpu_hu" class="village_summary_percent_num">--</div><!--village_view_resource_percent-->
							<div class="index_desc">户均ARPU</div><!---->
						</div>
						<ul class="li_first_important">
							<li>户均ARPU：<span id="village_view_arpu_hu1"></span></li>
							<li>单宽ARPU：<span id="village_view_arpu_dk"></span></li>
							<li>融合ARPU：<span id="village_view_arpu_rh"></span></li>
							<!--<li>未达社队：<span id="village_view_build_num_unreach"></span></li>-->
						</ul>
						<ul class="li_first_important">
							<li>行政村收入：<span id="village_view_arpu_month"></span></li><!--月收入-->
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div id="" class="sub_summary_tabs_title" style="background:#007BA9;">资源</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_port_lv" class="village_summary_percent_num"></div>
							<div class="index_desc">端口占用率</div>
						</div>
						<ul class="li_first_important">
							<li>端口数：<span id="village_view_port_num"></span></li>
							<li>占用端口：<span id="village_view_port_used"></span></li>
							<!--<li>空闲端口：<span id="village_view_free_port"></span></li>-->
						</ul>
						<ul class="li_first_important">
							<li>OBD数：<span id="village_view_obd"></span></li>
							<li>高占：<span id="village_view_hobd"></span></li>
							<li>零低：<span id="village_view_obd01"></span></li>
						</ul>
						<ul class="li_first_important">
							<li>覆盖率：<span id="village_view_resource_percent"></span></li>
							<li>资源已达社队：<span class="" id="village_view_resource_shequ"></span></li>
						</ul>
					</div>
				</div>
				<span></span>
			    <div>
				   <div id="" class="sub_summary_tabs_title" style="background:#007BA9;">营销</div>
				   <div class="sub_summary_index_content">
					   <div class="village_summary_percent">
						   <div id="village_view_exec_rate" class="village_summary_percent_num"></div>
						   <div class="index_desc">目标数</div>
					   </div>
					   <ul class="li_first_important">
						   <li>执行数：<span id="village_view_exec_cnt">--</span></li>
						   <li>执行率：<span id="village_view_exec_lv">--</span></li>
					   </ul>
					   <ul class="li_first_important">
						   <li>成功数：<span id="village_view_succ_cnt">--</span></li>
						   <li>成功率：<span id="village_view_succ_lv">--</span></li>
					   </ul>
				   </div>
			    </div>
			    <span></span>
				<div>
					<div id="" class="sub_summary_tabs_title" style="background:#007BA9;">收集</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_compete_percent" class="village_summary_percent_num"></div>
							<div class="index_desc">收集率</div>
						</div>
						<ul class="li_first_important">
							<li>应收集：<span id="village_view_should_collect_cnt"></span></li>
							<li>已收集：<span id="village_view_collected_cnt"></span></li>
							<li>异网资料：<span id="village_view_yw_cnt"></span></li>
							<li>占线入户：<span id="village_view_zx_cnt"></span></li>
						</ul>
					</div>
				</div>
				<span></span>
			</div>
	     </div>
		<!--社队清单-->
		<div id="vill_cell_sd_content"  style="display:none;"></div>
		<!--用户清单 -->
		<div id="zhuhuqingdan" style="display: none">
		</div>
		<!--OBD清单-->
		<div style="display:none;">
			<table style = "width:100%">
				<tr>
					<td>
						<div class="count_num desk_orange_bar inside_data">
							OBD设备数：<span id="head_obd_all" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							端口数：<span id="head_obd_0" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							占用端口：<span id="head_obd_1" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							占用率：<span id="head_obd_g" style ="color:#FF0000">0</span>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="collect_new_choice">
							<div class="collect_contain_choice" style="width:40%;display: inline-block;">
								<span style='font-weight:bold;'>社队:</span>
								<select id="collect_new_build_list_sj_obd_brigade"
										style="width: 85%;padding-left:0px;"></select>
								<%--<input type="text" id="collect_new_build_name_sj"
									   style="width: 80%;border:none;height:22px!important;line-height:22px!important;margin:1px;"
									   oninput="load_build_name_list_sj()">
								<ul id="collect_new_build_name_sj_list">
								</ul>--%>
							</div>
							<div class="collect_contain_choice" style="width:50%;display: inline-block;">
								<span style='font-weight:bold;'>查询条件:</span>
								<%--<select id="collect_new_build_list_sj_obd_id"
										style="width: 80%;padding-left:0px;margin-top:-3px;height:24px!important;line-height:24px!important;"></select>--%>
								<%--<input type="text" id="collect_new_build_name_sj"
									   style="width: 29%;border:none;height:22px!important;line-height:22px!important;margin:1px;position:absolute;left:48%;margin-top:3px;"
									   oninput="load_build_name_list_sj()">
								<ul id="collect_new_build_name_sj_list">
								</ul>--%>
								<input type="text" id="collect_new_build_list_sj_obd_id" placeholder="请输入设备编号或安装地址" />
								<input type="button" value="查询" class="btn" id="query_btn_obd" style="position:relative;" />
							</div>
							<%--<div class="collect_contain_choice" style="width:8%;display:inline-block;">
							</div>--%>
						</div>
					</td>
				</tr>
				<!--<tr>
					<td>
						<div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" style="width:95%;" id="collect_obd_state">状态:
							<span class="active" onclick="select_obd_state_b(this,'');" id="obd_quanbu">全部<span id="res_obd_all_count" ></span></span>
							<span onclick="select_obd_state_b(this,1);">0OBD<span id="res_0obd_count"></span></span>
							<span onclick="select_obd_state_b(this,2);">1OBD<span id="res_1obd_count"></span></span>
							<span onclick="select_obd_state_b(this,3);">高占用OBD<span id="res_hobd_count" ></span></span>
						</div>
					</td>
				</tr>-->
			</table>

			<div class="div_hide div_obd_2">
				<div class="count_num2">
					记录数：<span id="record_num_obd"></span>
				</div>
				<div class="build_datagrid" style="width:96%;margin:0px auto;">
					<div class="head_table_wrapper">
						<table class="head_table">
							<tr>
                                <th >序号</th>
                                <th >OBD设备</th>
                                <th >安装地址</th>
                                <th >端口数</th>
                                <th >占用数</th>
                                <th >占用率</th>
							</tr>
						</table>
					</div>
					<div class="t_table grid_obd_m_tab" id="build_obd_m_tab2">
						<table class="content_table build_detail_in" id="obd_build_info_list" style="width:100%;">
						</table>
					</div>
				</div>
			</div>
		</div>
		<!--营销清单-->
		<div id="vill_cell_yx_content" style="display:none;"></div>
		<!--流失用户-->
		<div id="vill_cell_yhzt_content" style="display:none;"></div>
        <!--收集清单 -->
        <div id="info_content" style="display:none;"></div>
	</div>


	<div id="vill_dkd_div">
		<!-- 此处将加载“单宽数”的列表 -->
		<div class="head_table_wrapper" style="padding-left:1px;height:5%;">记录数：<span id="vill_dkd_count"></span></div>
		<div class="head_table_wrapper" style="height:10%">
			<table class="head_table" id="vill_dkd_head">
				<tr>
					<th>序号</th>
					<th>接入号</th>
					<th>联系人</th>
					<th>联系电话</th>
					<th>安装地址</th>
				</tr>
			</table>
		</div>
		<div class="" id="vill_dkd_list_scroll">
			<table class="content_table build_detail_in" id="vill_dkd_list" style="width:100%;">
			</table>
		</div>
	</div>

	<div id="vill_rh_div">
		<!-- 此处将加载“融合数”的列表 -->
		<div class="head_table_wrapper" style="padding-left:1px;height:5%;">记录数：<span id="vill_rh_count"></span></div>
		<div class="head_table_wrapper" style="height:10%">
			<table class="head_table" id="vill_rh_head">
				<tr>
					<th>序号</th>
					<th>接入号</th>
					<th>联系人</th>
					<th>联系电话</th>
					<th>安装地址</th>
				</tr>
			</table>
		</div>
		<div class="" id="vill_rh_list_scroll">
			<table class="content_table build_detail_in" id="vill_rh_list" style="width:100%;">
			</table>
		</div>
	</div>

	<div id="vill_obd_user_div">
		<!-- 此处将加载“obd用户”的列表 -->
		<div class="OBD_detail_info">
			<span style="font-weight:bold;">OBD编号：</span><span id="obd_no" style="font-weight: normal;"></span>
			<span style="font-weight:bold;">安装地址：</span><span id="obd_install_address" class="andSoOn" style="font-weight: normal;"></span>
		</div>
		<div class="OBD_orange_line">
			<span>端口数 <i id="port_cnt"></i></span><span>占用端口数 <i id="port_used_cnt"></i></span><span>占用率 <i id="port_lv"></i></span>
		</div>

		<div style="margin:10px;">
			<div class="head_table_wrapper" style="padding-left:1px;height:5%;">记录数：<span id="vill_obd_user_count"></span></div>
			<div class="head_table_wrapper">
				<table class="head_table" id="vill_obd_user_head">
					<tr>
						<th>序号</th>
						<th>用户名称</th>
						<th>接入号码</th>
						<th>入网日期</th>
						<!--<th>在网时长</th>-->
						<th>状态</th>
						<th>联系电话</th>
						<th>端口编号</th>
					</tr>
				</table>
			</div>
			<div class="" id="vill_obd_user_list_scroll">
				<table class="content_table build_detail_in" id="vill_obd_user_list" style="width:100%;">
				</table>
			</div>
		</div>
	</div>

</body>
</html>
<script type="text/javascript">
    var begin_scroll = "", seq_num = 0, list_page = 0,select_count = 0, label=0, collect_state = null;
    var url2 = "<e:url value='/pages/telecom_Index/common/sql/tabData_village_cell.jsp' />";
    var zy_type = "";

    function select_obd_state_b(element,type){
        $(element).addClass("active").siblings().removeClass();
        zy_type = type;
        clear_data_OBD();
		load_obd_build();
        //load_obd_build_type_cnt();
    }
    var load_build_info4 = function (flag) {
        //选中文本回写进 input
        var text = $("#collect_new_build_list4").find("option:selected").text();
        $("#collect_new_build_name4").val(text);
        //$("#obd_new1_select_build").html(text);

        //var build_id = $("#obd_build_build").val()==null?'':$("#obd_build_build").val();
        //var $build_list = $("#obd_new1_bulid_info_list");
        clear_data_OBD();
        load_obd_build();
        load_obd_build_type_cnt();
        load_odb_build_sum_cnt();
    }
    function load_obd_build_type_cnt(){
        var params = {
            eaction: "getOBDSummary",
            resid: $("#collect_new_build_list_sj_obd_brigade option:selected").val(),
			obd_id: $("#collect_new_build_list_sj_obd_id").val(),
            village_id:village_id//,
            //city_id:parent.city_id
        }
        $.post(url2,params,function(data){
			var objs = $.parseJSON(data);
            if(objs.length){
                var data1 = objs[0];
                $("#head_obd_all").text(""+data1.EQP_CNT+"");
                $("#head_obd_0").text(""+data1.CAP_CNT+"");
                $("#head_obd_1").text(""+data1.ACT_CAP_CNT+"");
                $("#head_obd_g").text(""+data1.ACT_LV+"");
            }
        });
    }
    function load_odb_build_sum_cnt(){
		/*$("#head_obd_all").text(obd_head_all);
		$("#head_obd_0").text(obd_head_0);
		$("#head_obd_1").text(obd_head_1);
		$("#head_obd_g").text(obd_head_g);*/
        /*var params = {
            eaction: "obd_type_cnt_build",
            resid: $("select[name='collect_new_build_list4']").val() == '-1' ? '':$("select[name='collect_new_build_list4']").val(),
            village_id: village_id,
            //grid_id_short: $("select[name='obd_new1_grid_list']").val() == '-1' ? '' : $("select[name='obd_new1_grid_list']").val(),
            city_id:parent.city_id,
            //village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val(),
            zy:zy_type
        }
        $.post(url2,params,function(data){
            data = $.parseJSON(data);
        });*/
    }
    function load_build_name_list4() {
        setTimeout(function() {
            //下拉列表显示
            var $build_list =  $("#collect_new_build_name4_list");
            $build_list.empty();
			if (select_count <= 1) {
				//before_load_build_list();
			}

            var build_name = $("#collect_new_build_name4").val().trim();
            if (build_name != '') {
                var temp;
                var newRow = "";
                for (var i = 0, length = build_list.length, count = 0; i < length; i++) {
                    if ((temp = build_list[i].STAND_NAME).indexOf(build_name) != -1) {
                        newRow += "<li title='" + temp + "' onclick='select_build(\""+ temp + "\",\"" +
                            build_list[i].SEGM_ID + "\"," + i + ")'>" + temp + "</li>";
                        count++;
                    }
                    if (count >= 15) {
                        break;
                    }
                }
                $build_list.append(newRow);
                $("#collect_new_build_name4_list").show();
            } else {
                $("#collect_new_build_name4_list").hide();

				//[全部]选中
				var text = $("#collect_new_build_list4").find("option:selected").text();
				$("#collect_new_build_name4").val(text);
				$("#collect_new_build_name4_list").html(text);

				yhzt_build_id = $("#collect_new_build_list4").val();
            }

            //联动改变 select框, 只要不做点击, 都会将select改回全部.
            //$("#collect_new_build_list4 option:eq(0)").attr('selected','selected');
            select_count++;
        }, 800)
    }
	function initOBDOption(){
		$("#collect_new_build_list_sj_obd_brigade").empty();
		var newRow = "<option value='-1' select='selected'>全部</option>";
		$.post(url2,{
			"eaction":"getSheDuiSelectOption",
			"village_id":village_id
		},function(data){
			var ds = $.parseJSON(data);
			for(var i = 0,l = ds.length;i<l;i++){
				var d = ds[i];
				newRow += "<option value='" + d.BRIGADE_ID + "' >" + d.BRIGADE_NAME + "</option>";
				//ly_build_list.push(d);
			}
			$("#collect_new_build_list_sj_obd_brigade").append(newRow);
			//初始化选中
			/*var text = $("#ly_collect_new_build_list").find("option:selected").text();
			 $("#ly_collect_new_build_name").val(text);
			 $("#ly_collect_new_select_build").html(text);*/
		});

		var newRow1 = "<option value=''>全部</option>";
		$.post(url2,{
			"eaction":"getSceneSelectOption"
		},function(data){
			var ds = $.parseJSON(data);
			for(var i = 0,l = ds.length;i<l;i++){
				var d = ds[i];
				newRow1 += "<option value='" + d.MKT_CAMPAIGN_ID + "' >" + d.MKT_CAMPAIGN_NAME + "</option>";
			}
			$("#collect_new_build_list_sj_obd_scene").append(newRow1);
		});
	}

    function clear_data_OBD() {
        begin_scroll = "", seq_num = 0, list_page = 0, collect_state = null;
        $("#obd_build_info_list").empty();
    }
    //obd社队
    function load_obd_build(){
        var params = {
            eaction: "getOBDList",
            page: 0,
            res_id: $("#collect_new_build_list_sj_obd_brigade option:selected").val(),
            //grid_id_short: $("select[name='obd_new1_grid_list']").val() == '-1' ? '' : $("select[name='obd_new1_grid_list']").val(),
            //substation:substation,
			obd_id: $("#collect_new_build_list_sj_obd_id").val(),
            village_id: village_id//,
            //city_id:parent.city_id,
            //zy:zy_type
        }
        buildOBDListScroll(params, 1);
    }

    function buildOBDListScroll(params,flag){
        //$("#obd_build_info_list").empty();
        var $build_list = $("#obd_build_info_list");
        //var build_id_ld = $("#collect_new_build_list4").val();
        //common_bulid_id=build_id_ld;
        $.post(url2,params, function (data) {
            data = $.parseJSON(data);
            //seq_num = 0;
			if(data.length && list_page==0){
				$("#record_num_obd").text(data[0].C_NUM);
			}
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td >" + (++seq_num) + "</td>";
                //newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.GRID_ID + "',this)\" >" + d.GRID_NAME + "</a></td>";
                //newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" style=\"text-align:left;\">" + d.RESFULLNAME + "</a></td>";
                newRow += "<td>" + d.EQP_NO + "<td>" + d.ADDRESS + "</td><td>" + d.CAPACITY + "</td>";
				if(d.ACTUALCAPACITY>0)
					newRow += "<td><a class='clickable' href=\"javascript:showObdUserList('"+d.EQP_NO+"');\">" + d.ACTUALCAPACITY + "</a></td>";
				else
					newRow += "<td>" + d.ACTUALCAPACITY + "</td>";
				newRow += "<td>" + d.RATE + "</td></tr>";
                //"</td><td style='width: 50px'>" + d.ZE_TEXT + "</td><td style='width: 50px'>" + d.FI_TEXT + "</td></tr>";
                $build_list.append(newRow);
            }
            if (data.length == 0 && flag) {
				$("#record_num_obd").text("0");
                $build_list.empty();
                $build_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                return;
            }
        });
    }

	var vill_obd_user_div_handle = "";
	function showObdUserList(eqp_no_temp){
		clear_data_obd_user_list();
		eqp_no = eqp_no_temp;
		villObdUserList();
		villObdUserSummary();
		vill_obd_user_div_handle = layer.open({
			title: ['业务信息', 'font-size:18px;text-align:center;'],
			type: 1,
			shade: 0,
			maxmin: false, //开启最大化最小化按钮
			area: vill_obd_user_div_size,
			content: $("#vill_obd_user_div"),
			skin: 'vill_obd_user_div',
			cancel: function (index) {
				layer.close(vill_obd_user_div_handle);
			},
			full: function() { //点击最大化后的回调函数
				$(".vill_obd_user_div .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
			},
			restore: function() { //点击还原后的回调函数
				$(".vill_obd_user_div .layui-layer-setwin").css("top",'6px');
			}
		});
	}
    $("#build_obd_m_tab2").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                var params = {
                    eaction: "getOBDList",
                    page: ++list_page,
                    res_id: $("#collect_new_build_list_sj_obd_brigade option:selected").val(),
                    //grid_id_short: $("select[name='obd_new1_grid_list']").val() == '-1' ? '' : $("select[name='obd_new1_grid_list']").val(),
                    //substation:substation,
                    village_id:village_id//,
                    //city_id:parent.city_id,
                    //zy:zy_type
                }
                buildOBDListScroll(params, 0);
            }
            begin_scroll = new Date().getTime();
        }
    });
    function select_build(name, id, index) {
		$("#collect_new_build_list4 option").removeAttr("selected");
        $("#collect_new_build_list4 option[value=" + id + "]").attr('selected','selected');
        $("#collect_new_build_name4_list").hide();
        $("#collect_new_build_list4").change();
		$("#collect_new_build_name4").val(name);
    }

	function competeFlag(compete_percent){
		//竞争标签
		var tag_compete_str = "";
		var compete_range = index_range_map["KPI_D_003"];
		for(var i = 0,l = compete_range.length;i<l;i++){
			var item = compete_range[i];
			if(item.RANGE_MAX==null){//最大值
				if(item.RANGE_SIGNL=='>='){
					if(compete_percent >= item.RANGE_MIN){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
				if(item.RANGE_SIGNR=='>'){
					if(compete_percent > item.RANGE_MIN){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
			}else if(item.RANGE_MIN==null){//最小值
				if(item.RANGE_SIGNR=='<='){
					if(compete_percent <= item.RANGE_MAX){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
				if(item.RANGE_SIGNR=='<'){
					if(compete_percent < item.RANGE_MAX){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
			}else{
				if(item.RANGE_SIGNL=='>='){
					if(compete_percent >= item.RANGE_MIN){
						if(item.RANGE_SIGNR=='<'){
							if(compete_percent < item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}else if(item.RANGE_SIGNR=='<='){
							if(compete_percent <= item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}
					}
				}else if(item.RANGE_SIGNL=='>'){
					if(compete_percent > item.RANGE_MIN){
						if(item.RANGE_SIGNR=='<'){
							if(compete_percent < item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}else if(item.RANGE_SIGNR=='<='){
							if(compete_percent <= item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}
					}
				}
			}
		}
		if(tag_compete_str!="")
			tag_compete_str += "竞争";

		$("#tag_compete").text(tag_compete_str);//竞争标签 tag
	}

	function emptyAllDiv(){
		$("#vill_cell_sd_content").empty();
		$("#zhuhuqingdan").empty();
		$("#vill_cell_yx_content").empty();
		$("#info_content").empty();
		$("#vill_cell_yhzt_content").empty();
	}
</script>