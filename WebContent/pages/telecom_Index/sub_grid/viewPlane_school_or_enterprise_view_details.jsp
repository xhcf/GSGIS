<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
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

<html>
<head>
	<title>校园工作台</title>
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
	<link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_desk.css?version=2.2"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.4" />' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_village_view_details.css?version=1.2.2"/>' rel="stylesheet" type="text/css" media="all"/>
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
		#village_view_latn,#village_view_bureau,#village_view_sub,#village_view_grid{font-size:12px;}
		.sub_summary_tabs_title{cursor:default;}
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

		/*校园工作台 单宽数列表*/
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

		#vill_dkd_list_scroll,#vill_rh_list_scroll{
			height:80%;
			overflow-y: scroll;
		}
		#vill_dkd_count,#vill_rh_count {color:red;}

		/*#deleteBuildInVillage_btn {display:none;}*//*//20190305删除临时开放*/
		#collect_new_build_list4{
			height:24px!important;
			line-height:24px!important;
		}

		.village_view_win .tab_box div .desk_orange_bar {
			text-align: left;
		}

		#add4_order_pop_win {display:none;}

		.layui-layer-setwin {top:8px;}

		/*地址修正按钮样式修改*/
		#add4_repair {
			position: absolute;
			right: 0;
			top: 38px;
			background: #aaa;
			border-color: #aaa;
			display:none;
		}
	</style>
</head>
<body class="village_view_win">
    <div class="info_collect_win_new" id="info_collect_edit_div" style="display:none;height: 200px;">
        <!--<div class="titlea">
            <div id="info_collect_edit_draggable" style='text-align:left;width:90%;display: inline-block'>竞争收集</div>
            <div class="titlec" id="info_collect_edit_div_close"></div>
        </div>-->
        <iframe width="100%" height="100%"></iframe>
    </div>
	<h3 class="wrap_a tab_menu desk_menu" style="border-left:none;padding-left:11px;">
		<span style="cursor:pointer;" class="selected">校园概况</span>
		<span style="cursor:pointer;">楼宇清单</span>
		<span style="cursor:pointer;">学生清单</span>
		<span style="cursor:pointer;display:none;">OBD清单</span>
		<span style="cursor:pointer;">营销清单</span>
		<span style="cursor:pointer;">流失用户</span>
		<span style="cursor:pointer;display:none;">收集清单</span>

		<!--<div class="bulid_village_btn village_edit" style="top:-10px;width:auto;margin-right:17px;">
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
				<button id="add4_repair">地址修正</button>
			</e:if>
			<button id="village_paint">画像</button>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
			<button id="editBuildInVillage_btn" onclick="javascript:parent.editBuildInVillage();">编辑</button>
			<button id="deleteBuildInVillage_btn" onclick="javascript:parent.deleteBuildInVillage();">删除</button>
			</e:if>
		</div>-->
	</h3>

	<div class="tab_box">
		<!--概况-->
        <div style="width:100%;">
			<span class="village_name_new desk_orange_bar" style="display: block!important;">
				<span id="village_view_title" class="cate2"></span>
				(<span id="village_view_latn"></span>-<span id="village_view_bureau"></span>)
			</span>
		    <!--<div class="desk_tag">
			    <span id="tag_market"></span> <span id="tag_compete"></span><span id="tag_mode"></span>
		    </div>-->
		    <div class="sub_summary_tabs tabs_suvery">
				<div style="clear:both;float:none;">
					<div class="sub_summary_tabs_title">市场</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="sc_i_01" class="village_summary_percent_num"></div>
							<div class="index_desc">移动渗透率</div>
						</div>
						<ul class="li_first_important">
							<li>移动用户：<span id="sc_i_01_01"></span></li>
							<li>学生数：<span id="sc_i_01_02"></span></li>
						</ul>
						<ul class="li_first_important">
							<li>宽带数：<span id="sc_i_01_03"></span></li>
						</ul>
						<ul class="li_first_important">
							<li>楼宇数：<span id="sc_i_01_04"></span></li>
							<li>房间数：<span id="sc_i_01_05"></span></li>
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">价值</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="sc_i_02" class="village_summary_percent_num">--</div><!--village_view_resource_percent-->
							<div class="index_desc">户均ARPU</div><!---->
						</div>
						<ul class="li_first_important">
							<li>户均ARPU：<span id="sc_i_02_01"></span></li>
							<!--<li>未达楼宇：<span id="village_view_build_num_unreach"></span></li>-->
						</ul>
						<ul class="li_first_important">
							<li>总收入：<span id="sc_i_02_02"></span></li><!--月收入-->
							<li>移动收入：<span id="sc_i_02_03"></span></li><!--月收入-->
							<li>宽带收入：<span id="sc_i_02_04"></span></li><!--月收入-->
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">发展</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="sc_i_03" class="village_summary_percent_num"></div>
							<div class="index_desc">新增用户</div>
						</div>
						<ul class="li_first_important">
							<li>移动新增：<span id="sc_i_03_01"></span></li>
							<li>单&ensp;产&ensp;品：<span id="sc_i_03_02"></span></li>
							<li>融&emsp;&emsp;合：<span id="sc_i_03_03"></span></li>
							<!--<li>空闲端口：<span id="village_view_free_port"></span></li>-->
						</ul>
						<ul class="li_first_important">
							<li>宽带新增：<span id="sc_i_03_04"></span></li>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">流失</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="sc_i_04" class="village_summary_percent_num"></div>
							<div class="index_desc">流失用户</div>
						</div>
						<ul class="li_first_important">
							<li>流失用户：<span id="sc_i_04_01"></span></li>
							<li>不&ensp;出&ensp;账：<span id="sc_i_04_02"></span></li>
							<li>欠&emsp;&emsp;费：<span id="sc_i_04_03"></span></li>
							<li>沉&emsp;&emsp;默：<span id="sc_i_04_04"></span></li>
							<!--<li>非计费用户：<span id="village_view_fei_cnt"></span></li>-->
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">竞争</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="sc_i_05" class="village_summary_percent_num"></div>
							<div class="index_desc">异网用户</div>
						</div>
						<ul class="li_first_important">
							<!--<li>学生数：<span id="village_view_zhu_hu1">--</span></li>-->
							<li>异网用户：<span id="sc_i_05_01">--</span></li>
							<li>移&emsp;&emsp;动：<span id="sc_i_05_02">--</span></li>
							<li>联&emsp;&emsp;通：<span id="sc_i_05_03">--</span></li>
							<li>其&emsp;&emsp;它：<span id="sc_i_05_04">--</span></li>
						</ul>
					</div>
				</div>
				<span></span>
				<!--<div>
					<div class="sub_summary_tabs_title">营销</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_exec_rate" class="village_summary_percent_num"></div>
							<div class="index_desc">营销数</div>
						</div>
						<ul class="li_first_important">
							<li>营销数：<span id="village_view_dispatch_cnt">--</span></li>
							<li>执行数：<span id="village_view_exec_cnt">--</span></li>
							<li>成功数：<span id="village_view_succ_cnt">--</span></li>
						</ul>
						<ul class="li_first_important">
							<li>收集率：<span id="village_view_collect_lv">--</span></li>
							<li>应收集：<span id="village_view_should_collect">--</span></li>
							<li>已收集：<span id="village_view_already_collect">--</span></li>
						</ul>
					</div>
				</div>-->
			</div>
	    </div>
		<!--楼宇基本信息清单-->
		<div id="ly_content"  style="display:none;"></div>
		<!--学生清单 -->
		<div id="zhuhuqingdan" style="display: none"></div>

		<!--OBD清单-->
		<div id="obd_content" style="display:none;"></div>
		<!--营销清单-->
		<div id="yx_content" style="display:none;"></div>
        <!--竞争收集 -->
        <%--<div id="info_content" style="display:none;">
        </div>--%>
		<!--流失用户-->
		<div id="yhzt_content"  style="display:none;"></div>
		<!-- 收集清单 -->
		<div id="collect_content"  style="display:none;"></div>
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

	<!-- 地址修正 工单 -->
	<div id="add4_order_pop_win"></div>
</body>
</html>
<script type="text/javascript">
	var business_id = '${param.village_id}';
  var build_list = [];
	var url4sql = '<e:url value="/pages/telecom_Index/common/sql/tabData_enterprise.jsp" />';
	var url4Query2 = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action1.jsp' />";
  //共同楼宇ID,标签联动切换使用,需要子页面去秀给他的编号
  /*var obd_head_all=0,obd_head_0=0,obd_head_1=0,obd_head_g=0;*/

	function getBaseInfo(){
		$.post(url4sql, {eaction: "getSchoolOrEnterpriseBaseInfo", business_id: business_id}, function (data) {
			var obj = $.parseJSON(data);

			if(obj==null){
				layer.msg("该校园已被删除");
				setTimeout(function(){parent.closeOtherLayerWin();},2000);
				return;
			}

			//隐藏域
			$("#village_view_title").text(obj.BUSINESS_NAME);
			parent.village_paint_name = obj.BUSINESS_NAME;

			//第一个标签页
			//基础
			$("#village_view_latn").text(obj.LATN_NAME);
			$("#village_view_bureau").text(obj.BUREAU_NAME);
			
			$("#sc_i_01").text(obj.YD_LV);
			$("#sc_i_01_01").text(obj.YD_CNT);
			$("#sc_i_01_02").text(obj.RESIDE_COUNT);
			$("#sc_i_01_03").text(obj.KD_CNT);
			$("#sc_i_01_04").text(obj.BUILDINGS_COUNT);
			$("#sc_i_01_05").text(obj.HOUSE_CNT);
			
			$("#sc_i_02").text(obj.ARPU);
			$("#sc_i_02_01").text(obj.ARPU);
			$("#sc_i_02_02").text(obj.INCOMING_MONTH);
			$("#sc_i_02_03").text(obj.YD_INCOMING);
			$("#sc_i_02_04").text(obj.KD_INCOMING);
			
			$("#sc_i_03").text(obj.USER_ADD);
			$("#sc_i_03_01").text(obj.YD_ADD);
			$("#sc_i_03_02").text(obj.DCP_CNT);
			$("#sc_i_03_03").text(obj.RH_CNT);
			$("#sc_i_03_04").text(obj.KD_ADD);
			
			$("#sc_i_04").text(obj.LOST_USER);
			$("#sc_i_04_01").text(obj.LOST_USER);
			$("#sc_i_04_02").text(obj.BU_CHU_ZHANG);
			$("#sc_i_04_03").text(obj.QIAN_FEI);
			$("#sc_i_04_04").text(obj.CHEN_MO);
			
			$("#sc_i_05").text(obj.YW_CNT);
			$("#sc_i_05_01").text(obj.YW_CNT);
			$("#sc_i_05_02").text(obj.YW_YD_CNT);
			$("#sc_i_05_03").text(obj.YW_LT_CNT);
			$("#sc_i_05_04").text(obj.YW_OTHER_CNT);
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

	$(function(){
		//第一个标签页，校园汇总信息
		getBaseInfo();
		//融移用户
		//$("#village_view_rh_yd").text('${rh_yd.YD_COUNT}');

		//第四个标签页，OBD清单
          //initOBDComobo(village_id);

		//标签切换
		var $div_li = $(".tab_menu span");
		$div_li.click(function () {
			$("#add4_repair").hide();
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
			emptyAllDiv();
      if(index==1){//第二个标签页，楼宇清单
				$("#ly_content").load('<e:url value="/pages/telecom_Index/common/jsp/school_ly_content.jsp"/>?business_id=' + business_id);
      }else if(index==2){//第三个标签页，学生清单
				$("#add4_repair").show();
        $("#zhuhuqingdan").load("<e:url value='/pages/telecom_Index/common/jsp/school_student_content.jsp' />?business_id=" + business_id);
      }else if(index==3){//第四个标签页，OBD清单
				$("#obd_content").load("<e:url value='/pages/telecom_Index/common/jsp/school_obd_content.jsp' />?business_id=" + business_id);
      }else if(index==4){//第五个标签页，营销清单
        //修改子页面的楼宇id
				$("#yx_content").load('<e:url value="/pages/telecom_Index/common/jsp/school_yx_content.jsp"/>?business_id=' + business_id);
        ///yx_build_id = common_bulid_id;
        //调用子页面楼宇onchange事件
        //yx_load_build_info(1);
      }else if(index==5){//第六个标签页，流失用户
        $("#yhzt_content").load('<e:url value="/pages/telecom_Index/common/jsp/school_lost_content.jsp"/>?business_id='+business_id);
      }else if(index==6){
				$("#collect_content").load('<e:url value="/pages/telecom_Index/common/jsp/vill_collect_content.jsp"/>?business_id='+business_id);
			}
		})

	});

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

  function emptyAllDiv(){
		$("#ly_content").empty();
		$("#zhuhuqingdan").empty();
		$("#obd_content").empty();
		$("#yx_content").empty();
		$("#yhzt_content").empty();
		$("#collect_content").empty();
	}
</script>