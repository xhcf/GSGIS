<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>

<e:q4o var="quryDate">
	select const_value yMonth from ${easy_user}.sys_const_table where const_type = 'var.dss31' AND data_type = 'day' AND model_id = '16'
</e:q4o>
<e:set var="initMonth">${quryDate.YMONTH}</e:set>
<e:q4o var="quryMonth">
	select const_value yMonth,CASE WHEN SUBSTR(CONST_VALUE, 5)<10 THEN SUBSTR(CONST_VALUE, 6) ELSE SUBSTR(CONST_VALUE, 5) END || '月积分' ymonth_text from ${easy_user}.sys_const_table where const_type = 'var.dss32' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="maxMonth">${quryMonth.YMONTH}</e:set>
<e:set var="maxMonth_text">${quryMonth.YMONTH_TEXT}</e:set>
<e:set var="initXnMonth">${quryMonth.YMONTH}</e:set>
<e:set var="initDay">${quryDate.YMONTH}</e:set>
<e:q4o var="acc_month_tab1">
		select const_value acct_month from ${easy_user}.sys_const_table where const_type = 'var.dss34' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="initMonth1">${acc_month_tab1.ACCT_MONTH}</e:set>
<e:q4o var="minDate">
	select min(ACCT_MONTH) minMonth from ${channel_user}.TB_QDSP_STAT_VIEW_M t
</e:q4o>
<e:set var="initMinMonth">${minDate.MINMONTH}</e:set>
<e:q4o var="day_tab2">
		select const_value val from ${easy_user}.sys_const_table where const_type = 'var.dss33' AND data_type = 'day' AND model_id = '16'
</e:q4o>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=10,chrome=1">
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_org_frame.css?version=1.1.1"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_bureau_index.css?version=1.2.11"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/leader_condition_init.js?version=1.5"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.colors.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/sp_channel.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
		<link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
		<script src='<e:url value="/pages/telecom_Index/channel_sandtable/js/dataFormat.js?version=New Date()"/>' charset="utf-8"></script>
    <title>效能概览</title>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <style type="text/css">
    .tab_label{
    	margin:8px;
    	border-bottom: 1px solid #fff;
    }
    .tab_label span{
    	font-size:17px;
    	margin: 5px;
    }
    .qd_score{
	    margin: 20px;
    }

    .qd_content{
    	padding: 5px;
    	float:left;
    	list-style: disc;
    }

    .datagrid-row-selected{
    	background:transparent;
    }

    .datagrid-cell, .datagrid-cell-group, .datagrid-header-rownumber, .datagrid-cell-rownumber{
    	color: #fff;
    }
    #sub4{width: 94%;margin:2% auto 0; height:32%;}
		#sub4 thead td{padding:8px 0}
		#sub4 td{color: #E9EAEE;font-size: 12px;border: 1px solid #014A94;padding:3px 2px; text-align: center;}
		#sub4 td:nth-child(1){border-left: none;}
		#sub4 td:nth-child(4){border-right: none;}
		#sub4 tbody td:nth-child(3){color: #FF6600;}

		.datagrid-sort-icon{cursor:pointer;}
		i {
			margin-left:10px;
		    display: inline-block;
		    width: 4px;
		    height: 14px;
		    background: #FFD000;
		    margin-right: 8px;
		    vertical-align: middle;
		}
		.jfqs_btn,.xnqs_btn,.fzztbar_btn {border:1px solid #073b8a;background:transparent;color:#fff;cursor:pointer;}
		.p_showxn{background:#073b8a;color:#fff;}
		.xn_fz{
			display: inline-block;
		    /*margin-top: 5%;*/
		}
		/*.xy_fz{
			display: block;
		    margin-top: 5%;*/
		}
		.xy_cb{
			display: block;
		    /* margin-top: 5%; */
		}
	 	.c_energy_table thead td{line-height:calc(4vh);padding:0px;}
	 	#energy_trend_data td{line-height:calc(4vh);}
	 	.c_fzzt_table thead td{line-height:calc(4vh);padding:0px;}
	 	#fzzt_type_data td{line-height:calc(4vh);}

	 	/* NBS Add new EchartsMap message */
		.tips_table_wrapper1 .area_msg{
			/* display: block; */
			padding:3%;
		}

		orange {color:#f89406;width: 100%;display: inline-block;text-align: center;font-size: 16px;}
		yell {color:#fcff02;;display: inline-block;text-align: center;font-size: 16px;}
		.yell {color:#fcff02;}

		/*渠道效能表格*/
		/*.tab1_thead tr td:first-child{width:15%;}
		.tab1_thead tr td:nth-child(2){width:17%;}
		.tab1_thead tr td:nth-child(3){width:19%;}
		.tab1_thead tr td:nth-child(4){width:16%;}
		.tab1_thead tr td:nth-child(5){width:16%;}
		.tab1_tbody tr td:first-child{width:15%;}
		.tab1_tbody tr td:nth-child(2){width:17%;}
		.tab1_tbody tr td:nth-child(3){width:19%;}
		.tab1_tbody tr td:nth-child(4){width:16%;}
		.tab1_tbody tr td:nth-child(5){width:16%;}*/

		.tab1_thead td{
			text-align: center;
			font-size: 12px;
			color: white;
			height: 30px;
			border-bottom: 1px solid #014A94;
			border-right:1px solid #014A94;
			border-top:1px solid #014A94;
		}
		.tab1_tbody td{
			text-align: center;
			font-size: 12px;
			color: white;
			height: 24px;
			border-bottom: 1px solid #014A94;
			border-right:1px solid #014A94 ;
		}

		.tab1_thead td:nth-child(1){width: 15%;}
		.tab1_thead td:nth-child(2){width: 17%;}
		.tab1_thead td:nth-child(3){width: 17%;}
		.tab1_thead td:nth-child(4){width: 17%;}
		.tab1_thead td:nth-child(5){width: 17%;}
		.tab1_thead td:nth-child(6){border-right: none;}

		.c_qdxn_table-body {
			overflow-y:scroll;
		}
		.tab1_tbody td:nth-child(1){width: 15%;}
		.tab1_tbody td:nth-child(2){width: 17%;}
		.tab1_tbody td:nth-child(3){width: 17%;}
		.tab1_tbody td:nth-child(4){width: 17%;}
		.tab1_tbody td:nth-child(5){width: 17%;}
		.tab1_tbody td:nth-child(6){border-right: none;}

		/*渠道份额表格*/
		.tab2_thead td{
			text-align: center;
			font-size: 12px;
			color: white;
			height: 30px;
			border-bottom: 1px solid #014A94;
			border-right:1px solid #014A94;
			border-top:1px solid #014A94;
		}
		.tab2_tbody td{
			text-align: center;
			font-size: 12px;
			color: white;
			height: 24px;
			border-bottom: 1px solid #014A94;
			border-right:1px solid #014A94 ;
		}

		.tab2_thead tr td:first-child{width:15%;}
		.tab2_thead tr td:nth-child(2){width:17%;}
		.tab2_thead tr td:nth-child(3){width:17%;}
		.tab2_thead tr td:nth-child(4){width:17%;}
		.tab2_thead tr td:nth-child(5){width:17%;}
		.tab2_thead tr td:nth-child(6){border-right: none;}

		.tab2_tbody tr td:first-child{width:15%;}
		.tab2_tbody tr td:nth-child(2){width:17%;}
		.tab2_tbody tr td:nth-child(3){width:17%;}
		.tab2_tbody tr td:nth-child(4){width:17%;}
		.tab2_tbody tr td:nth-child(5){width:17%;}
		.tab2_tbody tr td:nth-child(6){border-right:none;}

		/*发展效益*/
		.tab6_table1 {
			width: 100%;height:70%;font-size:12px;
			border:none;
			/*border-top:1px solid #014A94;*/
		}
		.tab6_table1 tr{
			height:
		}
		.tab6_table1 tr td{text-align:center;border:none;}/*border-right:1px solid #014A94;border-bottom:1px solid #014A94;*/
		.tab6_table1 tr td:first-child {width:16%}
		.tab6_table1 tr td:nth-child(2) {width:31%;}
		.tab6_table1 tr td:nth-child(3) {width:27%;}
		.tab6_table1 tr td:nth-child(4) {width:26%;border-right:none;}

		#xyfxword {width:100%;}
		.index_desc{font-size:15px;}
		.index_num {color:#fcff02;font-size:24px;font-weight:bold;}
		.split_right {border-right:1px solid #0D3B57;}/*#00fff0;*/
		.index_name {font-size:16px;}

		.tab5_t_tab{width:100%;height:100%;font-size:12px;border-top:1px solid #014a94;text-align:center;}
		.tab5_t_tab td{border-right:1px solid #014a94;border-bottom:1px solid #014a94;}
		.tab5_t_tab tr td:last-child{border-right:none;}
		.font_bold {font-weight:bold;}

		.pie_desc1{font-size:14px;font-weight:bold;}
		.pie_desc2{font-size:12px;}
	</style>
    <script type="text/javascript">
    function msg(){
    	var res = "<div class='tips_table_wrapper1'>NAME";
        res += "<div style='background:red;'>";
        res += "<div><span class='area_msg'>市场份额：<span>3300</span></span></div><br/>"+
    	"<div><span  class='area_msg'>门&nbsp;店&nbsp;数&nbsp;：<span>3300</span></span><span class='area_msg'>有销门店数：<span>3300</span></span><span class='area_msg'>单店销量：<span>3300</span></span></div><br/>"+
    	"<div><span class='area_msg'>高销门店：<span>3300</span></span><span class='area_msg'>低销门店：<span>3300</span></span><span class='area_msg'>零销门店：<span>3300</span></span></div><br/>"+
    	"<div><span class='area_msg'>活&nbsp;跃&nbsp;率&nbsp;：<span>3300</span></span><span class='area_msg'>出&nbsp;账&nbsp;率&nbsp;：<span>3300</span></span><span class='area_msg'>离&nbsp;网&nbsp;率&nbsp;：<span>3300</span></span></div><br/>"+
    	"<div><span class='area_msg'>收&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;入：<span>3300</span></span><span class='area_msg'>毛&nbsp;利&nbsp;率&nbsp;：<span>3300</span></span><span class='area_msg'>成&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本：<span>3300</span></span>";
    res += "</div></div>";
    	layer.open({
    	    type: 1,
    	    title: 'layer mobile页',
    	    shadeClose: true,
    	    shade: 0.8,
    	    area: ['380px', '90%'],
    	    content: res //iframe的url
    	});
    }
    </script>
</head>
<body style="width:100%;border:0px;" class="g_target">
<div style="width:100%;height:100%;">
	<div class="c_title"><h2 id="title_name">甘肃省</h2></div>
	<div style="width:98%;margin-left:1%;overflow:hidden;">
		<ul class="c_view_list" style="white-space:nowrap;min-width:100%;max-width:auto;position:absolute;">
			<li class="current">渠道效能</li>
			<li>渠道份额</li>
			<li>营销积分</li>
			<li>发展规模</li>
			<li>发展质态</li>
			<li style="border-right:none;">发展效益</li>
		</ul>
	</div>

	<div class="c_cont_wrap">
		<!--渠道效能-->
		<div class="c_view">
			<div class="c_view_top clearfix" id="">
				<h4 class="c_title_com"><i></i>渠道效能</h4>
				<!--<dl class="fl split_right" style="padding-top:0;">
					<dt style="">渠道效能</dt>
					<dd style="" id="tab1_t_d1" class="index_num">90</dd>
					<dt style="display:none;">(分)</dt>
				</dl>-->
				<div style="height:72%;float:left;width:25%;padding:3% 0;">
					<table class="" style="height:100%;width:100%;text-align:center;font-size:12px;">
						<tr>
							<td class="index_desc">渠道效能</td>
						</tr>
						<tr>
							<td id="tab1_t_d1" class="index_num"></td>
						</tr>
					</table>
				</div>
				<div class="split_right" style="width:1px;height:65%;margin-top:2%;float:left;"></div>
				<div style="width:65%;margin-left:5%;float:left;">
					<table style="font-size:12px;height:72%;width:100%;" class="tab1_t_r">
						<tr>
							<td style="width:50%;"><span>• 渠道布局：</span><span id="tab1_t_d2">--</span></td><td style="width:50%;"><span>• 用户规模：</span><span id="tab1_t_d3">--</span></td>
						</tr>
						<tr>
							<td style="width:50%;"><span>• 渠道效益：</span><span id="tab1_t_d4">--</span></td><td style="width:50%;"><span>• 用户质态：</span><span id="tab1_t_d5">--</span></td>
						</tr>
					</table>
				</div>
				<%--<ul class="fl" style="width:70%;">
					<li>• 发展总量:<span id="tab1_t_d2">--</span></li>
					<li>• 本月积分:<span id="tab1_t_d3">--</span></li>
					<li>• 户均积分:<span id="tab1_t_d4">--</span></li>
					<li>• 用户DNA:<span id="tab1_t_d5">--</span></li>
					<li>• 移动离网率:<span id="tab1_t_d6">--</span></li>
					<li>• 本月活跃率:<span id="tab1_t_d7">--</span></li>

					<li style="text-align:center;">• 渠道布局：<span id="tab1_t_d2">--</span></li>
					<li>• 用户规模：<span id="tab1_t_d3">--</span></li>
					<li style="text-align:center;">• 渠道效益：<span id="tab1_t_d4">--</span></li>
					<li>• 用户质态：<span id="tab1_t_d5">--</span></li>
				</ul>--%>
				<%--<div class="fl" id="market_share" style="width:100%;height:100%;margin-left:27%;margin-top:calc(-41vh);position:absolute;"></div>--%>
			</div>
			<div class="c_view_center">
				<h4 class="c_title_com"><i></i>分类效能</h4>
				<div class="c_view_bar" id="c_view_bar">
					<div style="margin:0% auto 0% auto;padding-top:3%;width: 92%;">
						<span class="xn_fz"><div class="pie_desc1">核心厅店</div><br/><div class="pie_desc2" id="tab1_m_d1">--</div></span>
						<span class="xn_fz"><div class="pie_desc1">城市商圈</div><br/><div class="pie_desc2"  id="tab1_m_d2">--</div></span>
						<span class="xn_fz"><div class="pie_desc1">城市社区</div><br/><div class="pie_desc2"  id="tab1_m_d3">--</div></span>
						<span class="xn_fz"><div class="pie_desc1">农村乡镇</div><br/><div class="pie_desc2"  id="tab1_m_d4">--</div></span>
					</div>
					<div class="fl" id="tab1_pie" style="width:100%;/*margin-left:10%;margin-top:-5%;*/"></div>
					<div class="tab1_pie_label_div">
						<span id="tab1_m_d1_1"></span>
						<span id="tab1_m_d1_2"></span>
						<span id="tab1_m_d1_3"></span>
						<span id="tab1_m_d1_4"></span>
					</div>
				</div>
			</div>
			<div class="c_view_bottom">
				<h4 class="c_title_com"><i></i>区域效能</h4>
				<div class="c_qdxn_table-head">
					<table style="width: 100%;padding-right:6px;" class="tab1_thead">
						<tr>
							<%--<td>城市</td>
							<td>渠道效能</td>
							<td>发展总量</td>
							<td>本月积分</td>
							<td>户均积分</td>
							<td>用户DNA</td>--%>
							<td class="region_name">区域</td>
							<td>渠道效能</td>
							<td>渠道布局</td>
							<td>用户规模</td>
							<td>渠道效益</td>
							<td>用户质态</td>
						</tr>
					</table>
				</div>
				<div class="c_qdxn_table-body">
					<table style="width: 100%;" class="tab1_tbody">
						<tbody id="tab1_table">

						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!--渠道份额-->
		<div class="c_view">
			<div class="c_view_top c_view_top1 clearfix" id="">
				<h4 class="c_title_com"><i></i>渠道份额</h4>
				<div style="height:72%;float:left;width:30%;padding:3% 0;">
					<table class="split_right" style="height:100%;width:100%;text-align:center;font-size:12px;">
						<tr>
							<td class="index_desc">渠道份额</td>
						</tr>
						<tr>
							<td id="tab2_t_d1" class="index_num"></td>
						</tr>
					</table>
				</div>
				<div style="height:72%;float:left;width:70%;padding:3% 0;">
					<table style="height:100%;width:100%;text-align:center;font-size:12px;">
						<tr>
							<td class="index_desc" style="width:33%;">电信门店</td><td class="index_desc" style="width:33%;">移动门店</td><td class="index_desc" style="width:33%;">联通门店</td>
						</tr>
						<tr>
							<td class="index_num" id="tab2_t_d2"></td><td class="index_num" id="tab2_t_d3"></td><td class="index_num" id="tab2_t_d4"></td>
						</tr>
					</table>
					<!--<div style="display:inline-block;width:30%;text-align:center;font-size:12px;">
						<span class="index_desc">电信</span>
						<br/>
						<br/>
						<span class="index_num" id="tab2_t_d2">--</span>
					</div>
					<div style="display:inline-block;width:30%;text-align:center;font-size:12px;">
						<span class="index_desc">移动</span>
						<br/>
						<br/>
						<span class="index_num" id="tab2_t_d3">--</span>
					</div>
					<div style="display:inline-block;width:30%;text-align:center;font-size:12px;">
						<span class="index_desc">联通</span>
						<br/>
						<br/>
						<span class="index_num" id="tab2_t_d4">--</span>
					</div>-->
				</div>
				<%--<div class="fl"  style="display:none;width:100%;height:100%;margin-left:27%;margin-top:calc(-41vh);position:absolute;"></div>--%><!--id="market_share"-->
			</div>
			<div class="c_view_center">
				<h4 class="c_title_com"><i></i>分类分析</h4>
				<div class="c_view_bar" id="c_view_bar1">
					<div style="margin:3% auto 0% auto; width: 92%;">
						<span class="xn_fz"><div class="pie_desc1">核心厅店</div><br/><div class="pie_desc2" id="tab2_m_d1">--</div></span>
						<span class="xn_fz"><div class="pie_desc1">城市商圈</div><br/><div class="pie_desc2" id="tab2_m_d2">--</div></span>
						<span class="xn_fz"><div class="pie_desc1">城市社区</div><br/><div class="pie_desc2" id="tab2_m_d3">--</div></span>
						<span class="xn_fz"><div class="pie_desc1">农村乡镇</div><br/><div class="pie_desc2" id="tab2_m_d4">--</div></span>
					</div>
					<div class="fl" id="tab2_pie" style="width:100%;/*margin-left:10%;margin-top:-5%;*/"></div>
					<div class="tab2_pie_label_div">
						<span id="tab2_m_d1_1"></span>
						<span id="tab2_m_d1_2"></span>
						<span id="tab2_m_d1_3"></span>
						<span id="tab2_m_d1_4"></span>
					</div>
					<%--<div class="energy_analysis-word">
						<span >高销门店</span>
						<span >低销门店</span>
						<span >零销门店</span>
					</div>--%>
				</div>
			</div>
			<div class="c_view_bottom">
				<h4 class="c_title_com"><i></i>区域份额</h4>
				<div class="c_qdfe_table-head">
					<table style="width: 100%" class="tab2_thead">
						<tr>
							<td class="region_name">区域</td>
							<td>整体份额</td>
							<td>核心厅店</td>
							<td>城市商圈</td>
							<td>城市社区</td>
							<td>农村乡镇</td>
						</tr>
					</table>
				</div>
				<div class="c_qdfe_table-body">
					<table style="width: 100%" class="tab2_tbody">
						<tbody id="tab2_table">
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!-- 营销积分 -->
		<div class="c_view" id="c_view">
			<div class="c_view_yxjf clearfix" id="yxjf_score" style="padding-top:0px;">
			<h4 class="c_title_com"><i></i>积分概览</h4>
					<div style="width: 100%;height: 83%;" class="fzjf_top_div">
						<div style="display:inline-block;width:50%;height:74%;float:left;margin-top:5%;" class="split_right"><!--li width 44-->
							<table style="height:100%;text-align:center;font-size:12px;float:left;" class="tab3_t_left">
								<tr><td class="index_desc">当日积分</td></tr>
								<tr><td><span id="day_score" class="index_num"></span><br/><span id="tab3_t_name1"></span></td></tr>
							</table>
							<table style="height:100%;text-align:left;font-size:12px;float:left;margin-top:1%;" class="tab3_t_right">
								<tr><td>发展：<span id="day_fz_score">--</span></td></tr>
								<tr><td>存量：<span id="day_cl_score">--</span></td></tr>
								<tr><td>户均：<span id="day_hj_score">--</span></td></tr>
							</table>
						</div>
						<!--<div class="split_right" style="width:1px;height:60%;margin-top:7%;float:left;"></div>-->
						<div style="display:inline-block;width:50%;height:74%;float:left;margin-top:5%;" class=""><!--li width 55-->
							<table style="height:100%;text-align:center;font-size:12px;float:left;" class="tab3_t_left">
								<tr><td id="tab3_t_n1" class="index_desc">x月积分</td></tr>
								<tr><td><span id="mon_score" class="index_num"></span><br/><span id="tab3_t_name2">万分</span></td></tr>
							</table>
							<table style="height:100%;text-align:left;font-size:12px;float:left;margin-top:1%;" class="tab3_t_right">
								<tr><td>发展：<span id="mon_fz_score">--</span></td></tr>
								<tr><td>存量：<span id="mon_cl_score">--</span></td></tr>
								<tr><td>追溯：<span id="mon_zs_score">--</span></td></tr>
							</table>
						</div>
					</div>
					<div class="fl" id="yxjf_pie" style="width:100%;height:100%;display:none;/*margin-left:33%;margin-top:-28%;*/"></div>
				</div>
				<div class="c_view_center">
					<h4 class="c_title_com"><i></i>积分趋势</h4>
					<button class="jfqs_btn p_showxn tab3_m_btn" onclick="yxjf_trendLine(1)">整体积分</button>
					<button class="jfqs_btn" onclick="yxjf_trendLine(2)">发展积分</button>
					<button class="jfqs_btn" onclick="yxjf_trendLine(3)">存量积分</button>
					<div class="c_view_bar" id="c_view_yxjf"></div>
				</div>
				<div class="c_view_bottom">
					<h4 class="c_title_com"><i></i>区域积分</h4>
					<ul class="c_view_list1">
						<li class="current">日积分</li>
						<li style="border-right:none;">月积分</li>
					</ul>
					<div class="sw_tab">
						<div class="c_yxjf_table">
							<div class="c_yxjf_table-head">
								<table style="width: 100%">
									<tr>
										<!--<td>序号</td>-->
										<td class="region_name">区域</td>
										<td>本月累计(<span class="yxjf_name_d"></span>)</td>
										<td>当日积分(<span class="yxjf_name_d_1"></span>)</td>
										<td>当日户均(分)</td>
										<!-- <td>月发展环比</td> -->
									</tr>
								</table>
							</div>
							<div class="c_yxjf_table-body">
								<table style="width: 100%" id="sw_tab4">

								</table>
							</div>
						</div>
						<div class="c_yxjf_table" style="display:none;">
							<div class="c_yxjf_table-head">
								<table style="width: 100%">
									<tr>
										<!--<td>序号</td>-->
										<td class="region_name">区域</td>
										<td>当年累计(<span class="yxjf_name_m"></span>)</td>
										<td>当月积分(<span class="yxjf_name_m_1"></span>)</td>
										<td>当月户均(分)</td>
										<!-- <td>月发展环比</td> -->
									</tr>
								</table>
							</div>
							<div class="c_yxjf_table-body">
								<table style="width: 100%" id="sw_tab5">

								</table>
							</div>
						</div>
					</div>
				</div>
		</div>
		<!-- 发展效能 -->
		<div class="c_view" id="c_xn">
			<div class="c_view_yxjf clearfix" id="yxjf_score" style="padding-top:0px;">
			<h4 class="c_title_com"><i></i>发展概况</h4>
					<div style="margin: 0% auto 0%  auto;width: 96%;display:none;">
						<span class="xn_fz2">门店总数：<span id="channel_total">1223</span></span>
						<span class="xn_fz2">有销门店：<span id="channel_sell">256</span></span>
						<span class="xn_fz2">单店销量：<span id="channel_alone">212</span></span>
					</div>
					<div class="fl" id="energy_analysis_pie" style="width:100%;height:100%;display:none;"></div>
					<div class="energy_analysis-word" style="display:none;">
						<span >高销门店</span>
						<span >低销门店</span>
						<span >零销门店</span>
					</div>
					<div style="width: 98%;height: 84%;padding-left:3%;padding-bottom:3%;" class="tab4_t_table">
						<div style="display:inline-block;width:32%;height:100%;">
							<table style="height:40%;width:100%;text-align:center;">
								<tr><td class="index_desc font_bold">移动</td></tr>
							</table>
							<table style="width:100%;height:60%;text-align:center;font-size:12px;" class="split_right">
								<tr><td>本月累计</td></tr>
								<tr><td class="index_num" id="tab4_t_d1" >2345</td></tr>
								<tr><td id="tab4_t_d4">当日：234</td></tr>
							</table>
						</div>
						<div style="display:inline-block;width:32%;height:100%;">
							<table style="height:40%;width:100%;text-align:center;">
								<tr><td class="index_desc font_bold">宽带</td></tr>
							</table>
							<table style="width:100%;height:60%;text-align:center;font-size:12px;" class="split_right">
								<tr><td>本月累计</td></tr>
								<tr><td class="index_num" id="tab4_t_d2" >2345</td></tr>
								<tr><td id="tab4_t_d5">当日：234</td></tr>
							</table>
						</div>
						<div style="display:inline-block;width:32%;height:100%;">
							<table style="height:40%;width:100%;text-align:center;">
								<tr><td class="index_desc font_bold">电视</td></tr>
							</table>
							<table style="width:100%;height:60%;text-align:center;font-size:12px;">
								<tr><td>本月累计</td></tr>
								<tr><td class="index_num" id="tab4_t_d3" >2345</td></tr>
								<tr><td id="tab4_t_d6">当日：234</td></tr>
							</table>
						</div>
					</div>
				</div>
				<div class="c_view_center">
					<h4 class="c_title_com"><i></i>发展趋势</h4>
					<button class="xnqs_btn p_showxn tab4_m_btn" onclick="xnqs_trendLine(1)">移动</button>
					<button class="xnqs_btn" onclick="xnqs_trendLine(2)">宽带</button>
					<button class="xnqs_btn" onclick="xnqs_trendLine(3)">电视</button>
					<!-- <button class="xnqs_btn" onclick="xnqs_org()">橙分期</button>
					<button class="xnqs_btn" onclick="xnqs_org()">终端</button> -->
					<div class="c_view_bar" id="c_view_xnqs" style="height:70%;"></div>
				</div>
				<div class="c_view_bottom">
					<h4 class="c_title_com"><i></i>区域发展</h4>
						<ul class="c_view_list1">
							<li class="current">移动发展</li>
							<li class="">宽带发展</li>
							<li style="border-right:none;">电视发展</li>
						</ul>
						<!-- 移动发展 -->
						<div class="sw_tab">
							<div class="c_energy_table">
								<div class="c_energy_table-head">
									<table  style="width: 100%;">
										<tr>
											<td class="region_name">区域</td>
											<td>本月累计</td>
											<td style="color:#fff;">当日发展</td>
											<td>昨日发展</td>
											<td>环比</td>
										</tr>
									</table>
								</div>
								<div class="c_energy_table-body">
									<table id="tab4_sw_tab1" style="width: 100%;">

									</table>
								</div>
							</div>
							<!-- 宽带发展 -->
							<div class="c_energy_table">
								<div class="c_energy_table-head">
									<table  style="width: 100%;">
										<tr>
											<td class="region_name">区域</td>
											<td>本月累计</td>
											<td style="color:#fff;">当日发展</td>
											<td>昨日发展</td>
											<td>环比</td>
										</tr>
									</table>
								</div>
								<div class="c_energy_table-body">
									<table id="tab4_sw_tab2" style="width: 100%;">

									</table>
								</div>
							</div>
							<!-- 电视发展 -->
							<div class="c_energy_table">
								<div class="c_energy_table-head">
									<table  style="width: 100%;">
										<tr>
											<td class="region_name">区域</td>
											<td>本月累计</td>
											<td style="color:#fff;">当日发展</td>
											<td>昨日发展</td>
											<td>环比</td>
										</tr>
									</table>
								</div>
								<div class="c_energy_table-body">
									<table id="tab4_sw_tab3" style="width: 100%;">

									</table>
								</div>
							</div>
						</div>
				</div>
		</div>
		<!-- 发展质态 -->
		<div class="c_zt" id="c_zt">
				<div class="c_view_fzzt clearfix" id="fzzt_area" style="padding-top:0px;">
					<h4 class="c_title_com"><i></i>质态概览</h4>
					<div style="height:75%;" class="tab5_t_tab_div">
						<!--<ul class="fl fzzt_top_div" style="width:80%;float:left;margin-top:0;">
							<li>• 移动活跃率：<span id="active_rate">--</span></li>
							<li>• 移动出账率：<span id="account_rate">--</span></li>
							<li>• 移动离网率：<span id="leave_rate">--</span></li>
							<li>• 移动DNA户均：<span id="dna_score">--</span></li>
							<li>• 宽带活跃率：<span id="kd_active_rate">--</span></li>
							<li>• 宽带离网率：<span id="kd_leave_rate">--</span></li>
						</ul>-->
						<table class="tab5_t_tab">
							<tr>
								<td style="width:30%">移动新增活跃率</td><td id="active_rate" style="width:20%;" class="yell"></td><td style="width:30%;">移动新增出账率</td><td id="account_rate" style="width:20%;" class="yell"></td>
							</tr>
							<tr>
								<td>移动新增离网率</td><td id="leave_rate" class="yell"></td><td>移动新增DNA户均</td><td id="dna_score" class="yell"></td>
							</tr>
							<tr>
								<td>宽带新增活跃率</td><td id="kd_active_rate" class="yell"></td><td>宽带新增离网率</td><td id="kd_leave_rate" class="yell"></td>
							</tr>
						</table>
						<div style="margin-top: 5%;display:none;"><span class="ztglword" >移动活跃率：<span id="active_rate">25.22%</span></span><span class="ztglword" >移动出账率：<span id="account_rate">25.22%</span></span></div><br/>
						<div style="margin-top: 5%;display:none;"><span class="ztglword" >移动离网率：<span id="leave_rate">25.22%</span></span><span class="ztglword" >移动DNA户均：<span id="dna_score">88</span></span></div>
					</div>
				</div>
				<div class="c_view_center">
					<h4 class="c_title_com"><i></i>质态趋势</h4>
						<div style="z-index:777;">
							<button class="fzztbar_btn p_showxn tab5_m_btn" style="" onclick="fzzt_trendBarReload(1)">移动新增活跃率</button>
							<button class="fzztbar_btn" onclick="fzzt_trendBarReload(2)">移动新增出账率</button>
							<button class="fzztbar_btn" onclick="fzzt_trendBarReload(3)">移动新增离网率</button>
							<!-- <button class="fzztbar_btn" onclick="fzzt_trendBarReload(4)">DNA户均</button> -->
						</div>
					<div class="c_view_bar" id="fzzt_bar"></div>
				</div>
				<div class="c_view_bottom">
					<h4 class="c_title_com"><i></i>区域质态</h4>
					<ul class="c_view_list1">
							<li class="current">移动质态</li>
							<li style="border-right:none;" class="">宽带质态</li>
							<li style="border-right:none;display:none;">电视质态</li>
					</ul>
					<div class="sw_tab">
						<div class="c_fzztqy_table">
							<div class="c_fzztqy_table-head">
								<table style="width: 100%">
									<tr>
										<td class="region_name">区域</td>
										<td>新增活跃率</td>
										<td>新增出账率</td>
										<td>新增离网率</td>
										<td style="color:#fff;">新增DNA户均</td>
									</tr>
								</table>
							</div>
							<div class="c_fzztqy_table-body">
								<table id="tab5_sw_tab1" style="width: 100%;">

								</table>
							</div>
						</div>
						<div class="c_fzztqy_table">
							<div class="c_fzztqy_table-head">
								<table style="width: 100%">
									<tr>
										<td class="region_name">区域</td>
										<td>新增活跃率</td>
										<td>新增离网率</td>
									</tr>
								</table>
							</div>
							<div class="c_fzztqy_table-body">
								<table id="tab5_sw_tab2" style="width: 100%;">

								</table>
							</div>
						</div>
						<div class="c_fzztqy_table">
							<div class="c_fzztqy_table-head">
								<table style="width: 100%">
									<tr>
										<td class="region_name">区域</td>
										<td>新增活跃率</td>
										<td>新增离网率</td>
									</tr>
								</table>
							</div>
							<div class="c_fzztqy_table-body">
								<table id="tab5_sw_tab3" style="width: 100%;">

								</table>
							</div>
						</div>
					</div>
				</div>
		</div>
		<!-- 发展效益 -->
		<div class="c_xy" id="c_xy">
			<div class="c_view_yxjf clearfix" id="fzxy_score" style="padding-top:0px;">
			<h4 class="c_title_com"><i></i>效益概览</h4>
					<div class="fl"  id="xyfxword" >
						<!--
						<span class="xy_fz">毛利率：<span id="ml_rate">1223</span></span>
						<span class="xy_fz">毛&nbsp;&nbsp;&nbsp;利：<span id="ml_num">256</span></span>
						<span class="xy_fz">收&nbsp;&nbsp;&nbsp;入：<span id="sr_num">212</span></span>
						-->
						<div style="width: 98%;height: 84%;padding-top:0%;padding-left:3%;padding-bottom:3%;" class="fzxy_top_div">
							<div style="display:inline-block;width:32%;height:100%;" class="">
								<table style="height:40%;width:100%;text-align:center;">
									<tr><td class="index_desc font_bold">毛利率</td></tr>
								</table>
								<table style="width:100%;height:60%;text-align:center;font-size:12px;" class="split_right">
									<tr><td class="index_num" id="ml_rate" >2345</td></tr>
									<tr><td>毛利</td></tr>
									<tr><td id="tab6_t_d4">当日：234</td></tr>
								</table>
							</div>
							<div style="display:inline-block;width:32%;height:100%;" class="">
								<table style="height:40%;width:100%;text-align:center;">
									<tr><td class="index_desc font_bold">百元拉新收入</td></tr>
								</table>
								<table style="width:100%;height:60%;text-align:center;font-size:12px;" class="split_right">
									<tr><td class="index_num" id="100new_income_num" >2345</td></tr>
									<tr><td>新增收入</td></tr>
									<tr><td id="tab6_t_d5">当日：234</td></tr>
								</table>
							</div>
							<div style="display:inline-block;width:32%;height:100%;">
								<table style="height:40%;width:100%;text-align:center;">
									<tr><td class="index_desc font_bold">百元拉新用户</td></tr>
								</table>
								<table style="width:100%;height:60%;text-align:center;font-size:12px;">
									<tr><td class="index_num" id="100new_num" >2345</td></tr>
									<tr><td>新增用户</td></tr>
									<tr><td id="tab6_t_d6">当日：234</td></tr>
								</table>
							</div>
						</div>

					</div>
					<!--<div class="fl"  id="xyfxword" >
						<span class="xy_fz">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;成&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本：<span id="cb_num">1223</span></span>
						<span class="xy_fz">百元拉新收入：<span id="100new_num">256</span></span>
						<span class="xy_fz">百元拉新用户：<span id="100new_income_num">212</span></span>
					</div>-->
					<!-- <div class="fl" id="energy_analysis_pie" style="width:100%;height:100%;margin-left:35%;margin-top:-26%;"></div> -->
				</div>
				<div class="c_view_center">
					<!-- <h4 class="c_title_com"><i></i>成本构成</h4>
					<div class="fl" id="fzxy_pie" style="width:100%;height:100%;margin-left:-20%;margin-top:-5%;"></div>
					<div class="fl" style="margin-left:60%;margin-top:-3px;position:absolute;">
						<span class="xy_cb">总&nbsp;成&nbsp;本&nbsp;：<span id="cb_total">1223</span></span><br/>
						<span class="xy_cb">收入分成：<span id="cb_fc">256</span></span><br/>
						<span class="xy_cb">渠道奖励：<span id="cb_jl">212</span></span><br/>
						<span class="xy_cb">基础佣金：<span id="cb_yj">212</span></span><br/>
						<span class="xy_cb">渠道支撑：<span id="cb_zc">212</span></span>
					</div> -->
					<h4 class="c_title_com"><i></i>毛利趋势</h4>
					<div class="c_view_bar" id="mltrend_bar"></div>
				</div>
				<div class="c_view_bottom">
					<h4 class="c_title_com"><i></i>区域效益</h4>
					<div class="c_fzxyqy_table">
						<div class="c_fzxyqy_table-head" >
							<table style="width: 100%;">
								<tr>
									<td class="region_name">区域</td>
									<td>毛利率</td>
									<td>毛利</td>
									<td>零销门店</td>
									<td>低销门店</td>
									<td>高销门店</td>
									<!--<td>收入</td>
									<td>成本</td>-->
								</tr>
							</table>
						</div>
						<div class="c_fzxyqy_table-body">
							<table id="fzxyqy_table_data" style="width: 100%;">

							</table>
						</div>
					</div>
				</div>
		</div>
	</div>
</div>
</body>
<script>
	var sql_url = '<e:url value="/pages/telecom_Index/channel_sandtable/channel_action/channel_qdspAction.jsp" />';
	var sql_index = '<e:url value="/pages/telecom_Index/channel_sandtable/channel_action/channel_indexAction.jsp" />';
	var seq_num = 0, begin_scroll = 0, page = 0, query_sort = '0',
			acct_month='${initMonth}',acct_month1='${initMonth1}',acct_day='${initDay}',flag = 1,
			acct_xnmonth = '${initXnMonth}',acct_minmonth = '${initMinMonth}',max_month = '${maxMonth}';
		var region_type = parent.global_current_flag;//'${param.region_type}';
	var tab2_day = '${day_tab2.VAL}';
  var region_id = '${param.region_id}';
  if(region_id==''||region_id=="undefined")
  	region_id = parent.global_current_city_id;
  if(region_id=='999')
  	region_id = "";
  	//region_id = '000';

	//var bureau_no = parent.global_bureau_id;
	var bureau_no = parent.bureau_no;
	var branch_no = parent.global_substation;
	if(region_type!=4){
		parent.global_substation = "";
		branch_no = "";
	}


	var table_rows_array = "";
	var table_rows_array_small_screen = [5,25,35];
	var table_rows_array_big_screen = [10,40,50];

	if(window.screen.height<=768){
		table_rows_array = table_rows_array_small_screen;
	}else{
		table_rows_array = table_rows_array_big_screen;
	}

	var space = "&nbsp;";
	var big_size = "14";
	var small_size = "12";
	var percent = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">%</span>";
	var yuan = space+"<span style=\"font-size:"+small_size+"px;color:#fff;\">元</span>";
	var big_yuan = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">元</span>";
	var wan_yuan = space+"<span style=\"font-size:"+small_size+"px;color:#fff;\">万元</span>";
	var big_wan_yuan = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">万元</span>";
	var fen = space+"<span style=\"font-size:"+small_size+"px;color:#fff;\">分</span>";
	var big_fen = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">分</span>";
	var wan_fen = space+"<span style=\"font-size:"+small_size+"px;color:#fff;\">万分</span>";
	var big_wan_fen = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">万分</span>";
	var hu = space+"<span style=\"font-size:"+small_size+"px;color:#fff;\">户</span>";
	var big_hu = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">户</span>";
	var wan_hu = space+"<span style=\"font-size:"+small_size+"px;color:#fff;\">万户</span>";
	var big_wan_hu = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">万户</span>";

	var tab_group_size = $(".c_view_list").width();
	var div_size = $(".c_view_list").parent().width();
	$(function(){
		if(region_type==3)
			$(".region_name").text("厅店");
		else
			$(".region_name").text("区域");

		if(document.body.clientWidth>=540){
			$("#tab1_pie").css({"height":"120"});
		}
		//var c_view_bottom_height = document.body.offsetHeight*0.4;//document.body.offsetHeight-$(".c_title").height()-$(".c_view_top").height()-$(".c_view_center").height();
		//$(".c_view_bottom").height(c_view_bottom_height);
		//$(".c_view_center").height(document.body.offsetHeight*0.30);
		//$(".c_view_bottom").height(document.body.offsetHeight*0.8);

		//$(".c_qdxn_table-body").height($(".c_view_bottom").height()*0.96);
		//$(".c_qdfe_table-body").height($(".c_view_bottom").height()*0.96);
		$('.c_view_list li').click(function(){
			$(this).addClass('current').siblings().removeClass('current');
			$('.c_cont_wrap>div:eq('+$(this).index()+')').show().siblings().hide();
			var center = parseInt($('.c_view_list li').length/3);
			if(div_size<tab_group_size){
				if($(this).index()>center){
					$(".c_view_list").animate({"right":0,"left":div_size-tab_group_size});
				}else if($(this).index()<center+2){
					$(".c_view_list").animate({"left":0});
				}
			}
		});

		//$(".c_yxjf_table").height($(".c_view_bottom").height()*0.6);
		//$(".c_energy_table").height($(".c_view_bottom").height()*0.6);
		//小页签切换
		$('.c_energy_table').hide().eq(0).show();
		$(".c_fzztqy_table").hide().eq(0).show();
		$('.c_view_list1 li').click(function(){
			$(this).addClass('current').siblings().removeClass('current');
			var tab = $(this).parent().next('.sw_tab').children();
			$(tab).eq($(this).index()).show().siblings().hide();
		})

		if(region_id == 'undefined'){
			region_id = '';
		}
	    //if(bureau_no != ''){
			//region_type =parent.rank_region_type;
	  	//}
		/* 门店类型统计数 */
		//效能评分
        /*$.post(sql_url,
			{
				"eaction" : "xn_score",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_month
			},
    		function(obj){
	        	var data = $.parseJSON(obj);
	        	var score_html = '';
		    	 //为空判断
		        if(data != '' && data != null ){
		        	//拼接html
					score_html+='<dl class="fl">'+
							'	<dt>渠道效能</dt>'+
							'	<dd>'+data.QDXN_CUR_MONTH_SCORE+'</dd>'+
							'</dl>'+
							'<ul class="fl">'+
							'	<li>• 渠道布局：<span>'+data.BJL+'</span></li>'+
							'	<li>• 用户规模：<span>'+data.YHGML+'</span></li>'+
							'	<li>• 渠道效益：<span>'+data.QDXYL+'</span></li>'+
							'	<li>• 用户质态：<span>'+data.YHZTL+'</span></li>'+
							//'	<li>• 上月得分：<span>'+data.QDXN_LAST_MONTH_SCORE+'</span></li>'+
							//'	<li>• 差&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;值：<span>'+data.CZ+'</span></li>'+
							'</ul>';
				}else{
					 score_html+='<dl class="fl">'+
						'	<dt>渠道效能</dt>'+
						'	<dd>0</dd>'+
						'</dl>'+
						'<ul class="fl">'+
						'	<li>• 渠道布局:<span>0.00</span></li>'+
						'	<li>• 用户规模:<span>0.00</span></li>'+
						'	<li>• 渠道效益:<span>0.00</span></li>'+
						'	<li>• 用户质态:<span>0.00</span></li>'+
						//'	<li>• 上月得分:<span>0.00</span></li>'+
						//'	<li>• 差&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;值:<span>0.00</span></li>'+
						'</ul>';
				}
			$("#xn_score").html(score_html);
		});*/

		initTab1();
		initTab2();

		//效能趋势 柱状图
    $.post(sql_url,
			{
				"eaction"   : "xn_trend",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				"branch_no" : branch_no,
				'region_type' : region_type-1,
				'acct_month': acct_month1
			},
    		function(obj){
	        	var data = $.parseJSON(obj);
	        	var xMonth = [],
	        		yData = [];
		    	 //为空判断
		        if(data != '' && data != null ){
		        	$.each(data, function (index, value) {
		        		xMonth.push(value.MONTH_CODE);
						yData.push(nullToEmpty(value.QDXN_CUR_MONTH_SCORE));//filterNull
		        	});
		        }else{
		        	xMonth.push(acct_month);
					yData.push('0.00');
		        }
	        //xn_trendBar(xMonth,yData);
		});
		//门店类型统计查询
        /*$.post(sql_url,
			{
				"eaction"   : "share_list",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_xnmonth
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				var type_html='';
				if(data != '' && data != null ){
					$.each(data, function (index, value) {
						type_html+='<tr>'+
									'<td>'+value.LATN_NAME+'</td>    '+
									'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>    '+
									'		<td>'+value.QDXN_LAST_MONTH_SCORE+'</td>      '+
									'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>     '+
									'		<td>'+value.QDXN_LAST_MONTH_SCORE+'</td>     '+
									'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>     '+
									//'		<td>'+value.LARGE_AVG_CHANNEL_NUM+'</td>     '+
									//'		<td>'+value.LOW_AVG_CHANNEL_NUM+'</td>     '+
									'</tr> ';
				});
			}else{
				 type_html +='<tr>暂无数据!</tr>'
			}
			$("#store_type_data").html(type_html);
		});*/
		//发展质态-毛利率趋势
		//发展质态 柱状图
        /*$.post(sql_url,
			{
				"eaction"   : "ml_trend",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_minmonth
			},
    		function(obj){
	        	var data = $.parseJSON(obj);
	        	var xMonth = [],
	        		yData = [];
		    	 //为空判断
		        if(data != '' && data != null ){
		        	$.each(data, function (index, value) {
		        		xMonth.push(value.MONTH_CODE);
						yData.push(value.CUR_MON_BENEFIT_RATE);//filterNull
		        	});
		        }else{
		        	xMonth.push(acct_month);
					yData.push('0.00');
		        }
	        fzzt_trendBar(xMonth,yData);
		});*/
		//发展效益 毛利趋势柱状图
    $.post(sql_url,
			{
				"eaction"   : "mlqs_trend",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				"branch_no" : branch_no,
				'region_type' : region_type-1,
				'acct_month': acct_minmonth
			},
    		function(obj){
	        	var data = $.parseJSON(obj);
	        	var xMonth = [],
	        		yData = [];
		    	 //为空判断
		        if(data != '' && data != null ){
		        	$.each(data, function (index,item) {
		        		xMonth.push(item.MONTH_CODE);
								yData.push(item.CUR_MON_BENEFIT_RATE);
		        	});
		        }else{
		        	xMonth.push(acct_month);
							yData.push('0.00');
		        }
	        ml_trendBar(xMonth,yData);
		});

		$.post(sql_url,
		{
			"eaction" : "zt_org",
			'region_id' : region_id,
			'bureau_no' : bureau_no,
			"branch_no" : branch_no,
			'region_type' : region_type-1,
			'acct_month': max_month
		},
		function(obj){
    	var data = $.parseJSON(obj);
    	var score_html = '';
  	  //为空判断
      if(data != '' && data != null ){
      	$("#active_rate").html(data.CUR_MON_ACTIVE_RATE);
      	$("#account_rate").html(data.CUR_MON_BILLING_RATE);
      	$("#leave_rate").html(data.CUR_MON_REMOVE_RATE);
      	$("#dna_score").html(data.CUR_MON_DNA_RATE);
      	$("#kd_leave_rate").text(data.KD_LEAVE);
      	$("#kd_active_rate").text(data.KD_ACTIVE_RATE);
			}else{
				$("#active_rate").html('0.00%');
      	$("#account_rate").html('0.00%');
      	$("#leave_rate").html('0.00%');
      	$("#dna_score").html('0.00');
      	$("#kd_leave_rate").html('0.00%');
      	$("#kd_active_rate").html('0.00%');
			}
		});

    function toDecimal(x){
			var num = Number(x);
			num = num.toFixed(2);
			return num;
		}
		//地图右边显示排名
		var width=$(parent.parent.parent.window).width();
		var sub_width = $("#c_rank").width();
		var scoreWidth = 0;
		var area_width = 0;
		var jf_width = 0;
		var alin = '';
		//显示到渠道的时候宽度调整
		if(region_type == '3'){
			area_width = sub_width*0.35;
			scoreWidth = sub_width*0.25;
			jf_width = sub_width*0.3;
			alin = 'left';
		}else if(region_type == '2'){
			area_width = sub_width*0.35;
			scoreWidth = sub_width*0.25;
			jf_width = sub_width*0.3;
			alin = 'left';
		}else{
			area_width = sub_width*0.3;
			scoreWidth = sub_width*0.3;
			jf_width = sub_width*0.3;
			alin = 'center';
		}
		var areaDescription = '';
		if(region_type == '1'){
			areaDescription = 'AREA_DESCRIPTION';
		}else if(region_type == '2'){
			areaDescription = 'BUREAU_NAME';
		}else if(region_type == '3'){
			areaDescription = 'BRANCH_NAME';
		}else if(region_type == '4'){
			areaDescription = 'GRID_NAME';
		}
		//$("#c_rank").height(window.screen.height-$(".c_title").height()-$(".c_view_list").height()-14);
		if(region_type == '1'){
			$(".c_rank").height('104%')
		}
		if(region_type == '3'){
			$("#sub4").datagrid({
				fit: true,
				url: sql_url,
				queryParams: {
					"eaction" : "xn_rank_bureau",
					"acct_month" : acct_month,
					"region_id" : region_id,
					"region_type" : region_type,
					"bureau_no" : bureau_no
				},
				pagination:false,
				pageSize: 500,//每页显示的记录条数，默认为10
				pageList: [500,1000,2000],//可以设置每页记录条数的列表
				//pageSize: [5],//table_rows_array[0],
				fitColumns:false,
				columns:[
					[
					{field:'RN',title:'序号',align:'center',halign:'center',width:sub_width*0.1,
						formatter:function(value,rowData,index){
							return index+1;
						}
					},
					{field:'CHANNEL_NAME',title:'区域',align:alin,halign:'center',width:area_width,
						formatter:function(value,rowData){
							var length_standard =10;
							if (width>=1360)length_standard=10
							if(width>=1520)length_standard=12

							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"parent.inside_channel_model('"+rowData.CHANNEL_NBR+"','"+value+"','"+region_type+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"parent.inside_channel_model('"+rowData.CHANNEL_NBR+"','"+value+"','"+region_type+"')\">"+value+"</u>";
							}
						}
					},
					{field:'CHANNEL_SCORE_NUM',title:'渠道效能',align:'center',halign:'center',width:scoreWidth,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.CHANNEL_SCORE;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1){
								return num_str;
							}
							else
								return "--";
						}
					},
					{field:'QDJF_CUR_MONTH_NUM',title:'渠道积分',align:'center',halign:'center',width:jf_width,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDJF_CUR_MONTH;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1)
								return num_str;
							else
								return "--";
						}
					}
				]],
				scrollbarSize:"8",
				onLoadSuccess:function (data) {
					$("._num").text(data.rows.length);
					if (data.rows.length == 0) {

					}
					 /*  if(region_type == '3'){
						$('#sub4').datagrid('hideColumn','CZ');
					}   */

				},onClickRow: function (index,row){
					//global_substation_sub = "";
					//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
				}
			});
		}else if(region_type == '4'){
			$("#sub4").datagrid({
				fit: true,
				url: sql_url,
				queryParams: {
					"eaction" : "xn_rank_branch",
					"acct_month": acct_month,
					"region_id" : region_id,
					"region_type" : region_type,
					"bureau_no" : bureau_no,
					"branch_no" : branch_no
				},
				pagination:false,
				pageSize: 500,//每页显示的记录条数，默认为10
				pageList: [500,1000,2000],//可以设置每页记录条数的列表
				//pageSize: [5],//table_rows_array[0],
				fitColumns:false,
				columns:[
					[
					{field:'RN',title:'序号',align:'center',halign:'center',width:sub_width*0.1,
						formatter:function(value,rowData,index){
							return index+1;
						}
					},
					{field:areaDescription,title:'区域',align:alin,halign:'center',width:area_width,
						formatter:function(value,rowData){
							var length_standard =10;
							if (width>=1360)length_standard=10
							if(width>=1520)length_standard=12

							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"javascript:parent.inside_channel_model('"+rowData.LATN_ID+"','"+value+"','"+region_type+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"javascript:parent.inside_channel_model('"+rowData.LATN_ID+"','"+value+"','"+region_type+"')\">"+value+"</u>";
							}
						}
					},
					{field:'QDXN_CUR_MONTH_SCORE_NUM',title:'渠道效能',align:'center',halign:'center',width:scoreWidth,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDXN_CUR_MONTH_SCORE;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1){
								return num_str;
							}
							else
								return "--";
						}
					},
					{field:'QDJF_CUR_MONTH_NUM',title:'渠道积分',align:'center',halign:'center',width:jf_width,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDJF_CUR_MONTH;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1)
								return num_str;
							else
								return "--";
						}
					}
				]],
				scrollbarSize:"8",
				onLoadSuccess:function (data) {
					$("._num").text(data.rows.length);
					if (data.rows.length == 0) {

					}
					 /* if(region_type == '3'){
						$('#sub4').datagrid('hideColumn','CZ');
					} */

				},onClickRow: function (index,row){
					//global_substation_sub = "";
					//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
				}
			});
		}else{
			 $("#sub4").datagrid({
				fit: true,
				url: sql_url,
				queryParams: {
					"eaction" : "xn_rank",
					"acct_month": acct_month,
					"region_id" : region_id,
					"region_type" : region_type,
					"bureau_no" : bureau_no
				},
				pagination:false,
				pageSize: 500,//每页显示的记录条数，默认为10
				pageList: [500,1000,2000],//可以设置每页记录条数的列表
				//pageSize: [5],//table_rows_array[0],
				fitColumns:false,
				columns:[
					[
					{field:'RN',title:'序号',align:'center',halign:'center',width:sub_width*0.1,
						formatter:function(value,rowData,index){
							return index+1;
						}
					},
					{field:areaDescription,title:'区域',align:alin,halign:'center',width:area_width,
						formatter:function(value,rowData){
							var length_standard =10;
							if (width>=1360)length_standard=10
							if(width>=1520)length_standard=12

							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"javascript:parent.inside_channel_model('"+rowData.LATN_ID+"','"+value+"','"+region_type+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"javascript:parent.inside_channel_model('"+rowData.LATN_ID+"','"+value+"','"+region_type+"')\">"+value+"</u>";
							}
						}
					},
					{field:'QDXN_CUR_MONTH_SCORE_NUM',title:'渠道效能',align:'center',halign:'center',width:scoreWidth,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDXN_CUR_MONTH_SCORE;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1){
								return num_str;
							}
							else
								return "--";
						}
					},
					{field:'QDJF_CUR_MONTH_NUM',title:'渠道积分',align:'center',halign:'center',width:jf_width,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDJF_CUR_MONTH;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1)
								return num_str;
							else
								return "--";
						}
					}
				]],
				scrollbarSize:"8",
				onLoadSuccess:function (data) {
					$("._num").text(data.rows.length);
					if (data.rows.length == 0) {

					}
					 /* if(region_type == '3'){
						$('#sub4').datagrid('hideColumn','CZ');
					} */

				},onClickRow: function (index,row){
					//global_substation_sub = "";
					//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
				}
			});

		}
		//parent.bureau_no = '';

		try{
			//parent.refresh_range_cnt(level_num);
			parent.show_range_cnt();
		}catch(e){
		}
		//按层级定义绑定的事件
		if(region_type==1){
			$("#title_name").text("甘肃省");
		}else if(region_type==2){
			$("#title_name").text(parent.global_position[1]);
		}else if(region_type==3){
			$("#title_name").text(parent.global_position[2]);
		}else if(region_type==4){
			$("#title_name").text(parent.global_position[3]);
		}

		//滚动加载 暂不用
		/*$('.c_rank').scroll(function () {
			//alert($(this).scrollLeft());
			$('#table_head').css('margin-left', -($('.t_body').scrollLeft()));

			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();

			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - begin_scroll > 500) {
					++page;
					listScroll(true);
				}
				begin_scroll = new Date().getTime();
			}
		});*/
	});

	/*效能趋势 柱状图*/
	/*var c_view_bar = echarts.init(document.getElementById('c_view_bar'));
	function xn_trendBar(xMonth,yData){
		var option = {
			color: ['#00fff0'],
			grid:{
				bottom: '16%',
				right: '4%',
				top:'14%',
				left:'4%'
			},
			xAxis: {
				type: 'category',
				data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
				axisTick: {
					show: false},
				axisLine: {lineStyle: {color: '#e4e4e4'}},
				axisLabel: {textStyle: {fontSize:12}}
			},
			yAxis: {
				show:false,
				type: 'value',
				splitLine:{show:false},
				axisLine: {
					lineStyle: {color:'#555'}
				}
			},

			series: [{
				data: yData,//[820, 932, 901, 820, 932, 932],
				type: 'bar',
				barWidth: '16',
				itemStyle: {
					normal: {
						label: {
							show: true,
							position: 'top' ,
							textStyle: {color:'#ffffff',fontSize: '13'}
						}
					}
				}
			}]
		};
		c_view_bar.setOption(option);
	}*/

  function num_formatter(value){
      var value_str = value+"";
      if(value_str.indexOf(".")==-1)
          return "<span style='color: #fa8513'>" + value + ".00%</span>";
      if(value_str.substr(value_str.indexOf(".")+1).length==1)
          return "<span style='color: #fa8513'>" + (value+"0") + "%</span>";
      else
          return "<span style='color: #fa8513'>" + value + "%</span>";
  }

	/*渠道效能初始化*/
	function initTab1(){
		//top
		$.post(sql_index,{"eaction":"tab1_index_top","region_type":region_type,"acct_day":acct_day,"acct_month":acct_month1,"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){
			var d = $.parseJSON(data);
			if(d!='' && d!=null){
				$("#tab1_t_d1").text(d.D1);
				$("#tab1_t_d2").html("<yell>"+d.D2+"</yell>"+fen);
				$("#tab1_t_d3").html("<yell>"+d.D3+"</yell>"+fen);
				$("#tab1_t_d4").html("<yell>"+d.D4+"</yell>"+fen);
				$("#tab1_t_d5").html("<yell>"+d.D5+"</yell>"+fen);
				//$("#tab1_t_d6").text(d.D6);
				//$("#tab1_t_d7").text(d.D7);
			}else{
				$("#tab1_t_d1").text("0.0");
				$("#tab1_t_d2").html("<yell>0.0</yell>"+fen);
				$("#tab1_t_d3").html("<yell>0.0</yell>"+fen);
				$("#tab1_t_d4").html("<yell>0.0</yell>"+fen);
				$("#tab1_t_d5").html("<yell>0.0</yell>"+fen);
			}
		});
		//渠道效能--饼图
		tab1_pie();
		//bottom
		tab1_table();
	}
	function initTab2(){
		//top
		$.post(sql_index,{"eaction":"tab2_index_top","region_type":region_type,"acct_day":tab2_day,"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){
			var d = $.parseJSON(data);
			if(d!='' && d!=null){
				$("#tab2_t_d1").html(d.D1.replace('%','')+percent);
				$("#tab2_t_d2").text(d.D2);
				$("#tab2_t_d3").text(d.D3);
				$("#tab2_t_d4").text(d.D4);
			}else{
				$("#tab2_t_d1").html('0.00'+percent);
				$("#tab2_t_d2").text('0');
				$("#tab2_t_d3").text('0');
				$("#tab2_t_d4").text('0');
			}
		});
		/*$.post(sql_index,{"eaction":"tab2_index_top_1","region_type":region_type,"acct_day":acct_month,"region_id":region_id,"bureau_no":bureau_no,"branch_no":branch_no},function(data){
			var d = $.parseJSON(data);
			if(d!="" && d!=null){
				$("#tab2_t_d2").text(d.CHANNEL_NUM);
			}else{
				$("#tab2_t_d2").text('0');
			}
		});*/
		//渠道份额--饼图
		tab2_pie();
		//bottom
		tab2_table();
	}

    /*function query(){
        clear_data();
		listScroll(true);
    }*/
	/*function getParams(){
		return {
			"eaction": "xn_rank",
			"acct_month":acct_month,
			"region_type": region_type,
			"page": page,
			"pageSize": table_rows_array[0],
			"query_flag": 5,
			"query_sort": query_sort,
			"region_id": region_id,
			"bureau_no":bureau_no
		};
	}*/
    /*排名鼠标滚动加载数据*/
    /*function listScroll(flag) {
        listCollectScroll(flag);
    }*/
	/*function toDecimal(x){
		var num = Number(x);
		num = num.toFixed(2);
		return num;
	}*/
    //var total_num = 0;
    /*function listCollectScroll(flag) {
		var params = getParams();
        var $list = $("#sub4");

		$.post(sql_url, params, function (data) {
			data = $.parseJSON(data);
			 var newRow = "";
			 var type_html = "";
			$.each(data, function (index, value) {
				if(region_type == '1'){
					type_html+='<tr>'+
					'<td>'+value.RN+'</td>    '+
					'		<td>'+value.AREA_DESCRIPTION+'</td>    '+
					'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>      '+
					'		<td>'+value.CZ+'</td>     '+
					'</tr> ';
				}else if(region_type == '2'){
					type_html+='<tr>'+
					'<td>'+value.RN+'</td>    '+
					'		<td>'+value.BUREAU_NAME+'</td>    '+
					'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>      '+
					'		<td>'+value.CZ+'</td>     '+
					'</tr> ';
				}else if(region_type == '3'){
					type_html+='<tr>'+
					'<td>'+value.RN+'</td>    '+
					'		<td>'+value.BRANCH_NAME+'</td>    '+
					'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>      '+
					'</tr> ';
				}
				newRow += type_html;
			});
			$("#store_rank_data").html(newRow);
			//只有第一次加载没有数据的时候显示如下内容
			if (data.length == 0 && flag) {
				$list.empty();
				$list.append("<tr><td style='text-align:center' colspan=10 >没有查询到数据</td></tr>")
			}
		});
    }*/
    //清空数据
    /*function clear_data() {
        begin = 0, end = 0, seq_num = 0, begin_scroll = 0, page = 0,flag = '1', query_sort = '0',
        $("#sub4").empty();
        $("#download_div").hide();
    }*/
    /* NBS Add 20190715 */
    $(function(){
    	//tab切换
			$('.jfqs_btn').click(function(){
				$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
				//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
			})
	    	//tab切换
			$('.xnqs_btn').click(function(){
				$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
				//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
			})
	    	//tab切换
			$('.fzztbar_btn').click(function(){
				$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
				//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
			})
    	//市场份额 圆环
    	//market_rate();
    	//营销积分积分构成
    	//门店类型统计查询
      $.post(sql_url,
			{
				"eaction"   : "yxjf_pie_data",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				"branch_no" : branch_no,
				'region_type' : region_type-1,
				'acct_day': acct_day,
				'acct_month': max_month
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				var type_html='';
				if(data != '' && data != null ){
					//$("#total_jf_day").html(data.CUR_MONTH_SUM_JF);
					//$("#total_jf_day").html(parseFloat(data.FZ_OF_CUR_MONTH_SUM_JF)+parseFloat(data.CL_OF_CUR_MONTH_SUM_JF));
					//$("#day_score").html(data.CUR_DAY_JF);
						$("#day_score").html(data.CUR_DAY_JF);
					if(data.CDJ_FLAG=="xiao")
						$("#tab3_t_name1").text("分");
					else
						$("#tab3_t_name1").text("万分");

					$("#day_score").html(data.CUR_DAY_JF);

					if(data.FOCDJ_FLAG=="xiao")
						$("#day_fz_score").html(data.FZ_OF_CUR_DAY_JF+fen);
					else
						$("#day_fz_score").html(data.FZ_OF_CUR_DAY_JF+wan_fen);

					if(data.COCDJ_FLAG=="xiao")
						$("#day_cl_score").html(data.CL_OF_CUR_DAY_JF+fen);
					else
						$("#day_cl_score").html(data.CL_OF_CUR_DAY_JF+wan_fen);

					$("#day_hj_score").html(data.HJ_JF+fen);

					$("#tab3_t_n1").text('${maxMonth_text}');
					$("#mon_score").html(data.CUR_MON_JF);

					if(data.CMJ_FLAG=="xiao")
						$("#tab3_t_name2").text("分");
					else
						$("#tab3_t_name2").text("万分");

					if(data.FOCMJ_FLAG=="xiao")
						$("#mon_fz_score").html(data.FZ_OF_CUR_MON_JF+fen);
					else
						$("#mon_fz_score").html(data.FZ_OF_CUR_MON_JF+wan_fen);

					if(data.COCMJ_FLAG=="xiao")
						$("#mon_cl_score").html(data.CL_OF_CUR_MON_JF+fen);
					else
						$("#mon_cl_score").html(data.CL_OF_CUR_MON_JF+wan_fen);

					if(data.zocmj_flag=="xiao")
						$("#mon_zs_score").html(data.ZS_OF_CUR_MON_JF+fen);
					else
						$("#mon_zs_score").html(data.ZS_OF_CUR_MON_JF+wan_fen);
				}else{
					//$("#total_jf_day").html('0.00');
					$("#tab3_t_n1").text("");
					$("#day_score").html('0');
					$("#day_fz_score").html('0.00'+fen);
					$("#day_cl_score").html('0.00'+fen);
					$("#day_hj_score").html('0.00'+fen);

					$("#mon_score").html('0.00');
					$("#mon_fz_score").html('0.00'+fen);
					$("#mon_cl_score").html('0.00'+fen);
					$("#mon_zs_score").html('0.00'+fen);
				}
	    	//score_comp(data.FZ_OF_CUR_DAY_JF,data.CL_OF_CUR_DAY_JF);
			});
    	//营销积分积分趋势
    	yxjf_trendLine(1);
    	//营销积分积分构成
    	yxjf_org();
    	//发展规模区域构成
    	fzgm_org();
    	//发展效能-效能分析
    	$.post(sql_url,
				{
					"eaction"   : "qdxn_pie_data",
					'region_id' : region_id,
					'bureau_no' : bureau_no,
					"branch_no" : branch_no,
					'region_type' : region_type-1,
					'acct_day': acct_day
					//'acct_month': acct_xnmonth
				 },
				function(obj){
					var data = $.parseJSON(obj);
					 //为空判断
					var type_html='';
					if(data != '' && data != null ){
						$("#channel_total").html(data.CHANNEL_NUM);
						$("#channel_sell").html(data.SALE_CHANNEL_NUM);
						$("#channel_alone").html(data.SINGLE_CHANNEL_NUM.toFixed(0));
				}else{
					$("#channel_total").html("0");
					$("#channel_sell").html("0");
					$("#channel_alone").html("0");
				}
	    	//energy_analysis(data.CHANNEL_NUM,data.HIGH_CHANNEL_RATE,data.LOW_SALE_CHANNEL_RATE,data.ZERO_SALE_CHANNEL_RATE);
			});
    	//发展效能-发展量分析
        /*$.post(sql_url,
			{
				"eaction"   : "qdxn_dev_data",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_day': acct_day
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				var type_html='';
				if(data != '' && data != null ){
						type_html+='<tr>                '+
									'	<td>总销量</td>  '+
									'	<td>'+data.TOTAL_DEV_NUM+'</td>    '+
									'	<td>100.00%</td>  '+
									'</tr>               '+
									'<tr>                '+
									'	<td>移动销量</td>'+
									'	<td>'+data.YD_DEV_NUM+'</td>     '+
									'	<td>'+data.YD_DEV_RATE+'</td>  '+
									'</tr>               '+
									'<tr>                '+
									'	<td>宽带销量</td>'+
									'	<td>'+data.KD_DEV_NUM+'</td>     '+
									'	<td>'+data.KD_DEV_RATE+'</td>  '+
									'</tr>               '+
									'<tr>                '+
									'	<td>电视销量</td>'+
									'	<td>'+data.ITV_DEV_NUM+'</td>     '+
									'	<td>'+data.ITV_DEV_RATE+'</td>  '+
									'</tr>               ';
			}else{
				 type_html +='<tr>暂无数据!</tr>'
			}
			$("#energy_trend_data").html(type_html);
		});*/
    	//发展效能-趋势效能分析
    	xnqs_trendLine(1);
    	//发展质态-毛利率趋势
    	fzzt_trendBarReload(1);
    	//发展质态-类型分析
    	fzzt_type();
    	//发展质态-区域效益
    	fzzt_area();
    	//发展效益-效益分析
    	fzxy_xy_analize();
    	//发展效益-饼状图
    	//costPie();
    	//发展效益-区域效益
    	fzxy_area();

    });

    function resizeMainContainer(ele,parent_container,cut_part){
    	if(cut_part!=""){
    		ele.style.width = $(parent_container).width()-$(cut_part).width()+'px';
    		ele.style.height = $(parent_container).height()-$(cut_part).height()+'px';
    	}else{
    		ele.style.width = $(parent_container).width()+'px';
    		ele.style.height = $(parent_container).height()+'px';
    	}
    }

	//渠道效能4个环形图
	var pie_color = ['#2c3465','#3685e6'];
	var pie_size = ['75%', '90%'];//饼图大小
	var pie_position = [['15%', '55%'],['38%', '55%'],['61%', '55%'],['84%', '55%']];//饼图中心点位置
	var labelTop = {
			normal : {
				label : {
					show : false,
					position : 'center',
					formatter : '{b}',
					textStyle: {
						baseline : 'bottom',
						color: '#fff'
					}
				},
				labelLine : {
					show : false
				}
			}
		};

		var labelBottom = {
			normal : {
				label : {
					show : false,
					position : 'center'
				},
				labelLine : {
					show : false
				}
			}
		};

		var item_color =
		{normal:{
	      color: function(params) {
	        //首先定义一个数组
	        var colorList = pie_color;
	        return colorList[params.dataIndex]
	      }
			}
		};
	function tab1_pie(){
		//resizeMainContainer(document.getElementById('tab1_pie'),"#c_view_bar","");
		//$("#tab1_pie").height($("#c_view_bar").height()*0.5);
		//$("#tab1_pie").width($("#c_view_bar").width());
		//$("#tab1_pie").width($("#c_view_bar").width()*0.25);
		//$("#tab1_pie").height($("#c_view_bar").height()*0.5);
		//$("#tab1_pie").width($("#c_view_bar").width());
		var tab1_pie = echarts.init(document.getElementById('tab1_pie'));
		tab1_pie.resize();

		var radius = pie_size;
		var legend = ['核心厅店','城市商圈','城市社区','农村乡镇'];
		$.post(sql_index,{"eaction":"tab1_index_middle1","region_type":region_type,"acct_month":'${acc_month_tab1.ACCT_MONTH}',"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){
			var d = $.parseJSON(data);
			if(!d.length){
				$("#tab1_m_d1").text("网点0个");
				$("#tab1_m_d2").text("网点0个");
				$("#tab1_m_d3").text("网点0个");
				$("#tab1_m_d4").text("网点0个");
			}
			/*$.each(d,function(index,item){
				if(item.NAME==legend[0])
					$("#tab1_m_d1").text("网点"+item.VALUE+"个");
				else if(item.NAME==legend[1])
					$("#tab1_m_d2").text("网点"+item.VALUE+"个");
				else if(item.NAME==legend[2])
					$("#tab1_m_d3").text("网点"+item.VALUE+"个");
				else if(item.NAME==legend[3])
					$("#tab1_m_d4").text("网点"+item.VALUE+"个");
			});*/
		});
		$.post(sql_index,{"eaction":"tab1_index_middle","region_type":region_type,"acct_month":'${acc_month_tab1.ACCT_MONTH}',"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){
			var d = $.parseJSON(data);
			var d1 = 0;
			var d2 = 0;
			var d3 = 0;
			var d4 = 0;
			var sum = 0;
			$.each(d,function(index,item){
				if(item.NAME==legend[0]){
					d1 = (item.VALUE);//parseFloat(item.VALUE).toFixed(2);
				}
				else if(item.NAME==legend[1]){
					d2 = (item.VALUE);//parseFloat(item.VALUE).toFixed(2);
				}
				else if(item.NAME==legend[2]){
					d3 = (item.VALUE);//parseFloat(item.VALUE).toFixed(2);
				}
				else if(item.NAME==legend[3]){
					d4 = (item.VALUE);//parseFloat(item.VALUE).toFixed(2);
				}
			});
			$("#tab1_m_d1_1").text(d1);
			$("#tab1_m_d1_2").text(d2);
			$("#tab1_m_d1_3").text(d3);
			$("#tab1_m_d1_4").text(d4);

			sum = parseFloat(100);//parseFloat(d1+d2+d3+d4);

			var labelFromatter = {
				normal : {
					label : {
						formatter : function (params){
							return parseFloat(sum-params.value).toFixed(1);//parseFloat(100 - params.value).toFixed(2) + '%'
						},
						textStyle: {
							baseline : 'top',
							color: '#ee7008',
							fontSize:14
						}
					}
				}
			}
			var energy_option = {
					legend: {
						show:false,
						x : 'center',
						y : '70%',
						data:legend
					},
					series : [
						{
							type : 'pie',
							clockwise:false,
							animation:false,
							center : pie_position[0],
							radius : radius,
							//color:pie_color,
							hoverAnimation :false,//去掉鼠标悬浮放大效果
							x:'0', // for funnel
							//itemStyle : labelFromatter,
							data : [
								{name:'other', value:(sum-d1).toFixed(2), itemStyle : labelBottom},
								{name:legend[0], value:d1,itemStyle : labelTop}
							],
							itemStyle: item_color
						},
						{
							type : 'pie',
							clockwise:false,
							animation:false,
							center : pie_position[1],
							radius : radius,
							//color:pie_color,
							hoverAnimation :false,//去掉鼠标悬浮放大效果
							x:'20%', // for funnel
							//itemStyle : labelFromatter,
							data : [
								{name:'other', value:(sum-d2).toFixed(2), itemStyle : labelBottom},
								{name:legend[1], value:d2,itemStyle : labelTop}
							],
							itemStyle: item_color
						},
						{
							type : 'pie',
							clockwise:false,
							animation:false,
							center : pie_position[2],
							radius : radius,
							//color:pie_color,
							hoverAnimation :false,//去掉鼠标悬浮放大效果
							x:'40%', // for funnel
							//itemStyle : labelFromatter,
							data : [
								{name:'other', value:(sum-d3).toFixed(2), itemStyle : labelBottom},
								{name:legend[2], value:d3,itemStyle : labelTop}
							],
							itemStyle: item_color
						},
						{
							type : 'pie',
							clockwise:false,
							animation:false,
							center : pie_position[3],
							radius : radius,
							//color:pie_color,
							hoverAnimation :false,//去掉鼠标悬浮放大效果
							x:'40%', // for funnel
							//itemStyle : labelFromatter,
							data : [
								{name:'other', value:(sum-d4).toFixed(2), itemStyle : labelBottom},
								{name:legend[3], value:d4,itemStyle : labelTop}
							],
							itemStyle: item_color
						}
					]
			};
			tab1_pie.setOption(energy_option);
		});

	}

	function name_short(name,size){
		if(name.length>size)
			return name.substr(0,size-1)+"...";
		return name;
	}
	//渠道效能表格
	function tab1_table(){
		$("#tab1_table").empty();
		/*for(var i = 0,l = 15;i<l;i++){
			$("#tab1_table").append("<tr><td class=\"text-important-a\"></td><td></td><td></td><td></td><td></td></tr>");
		}*/
		$.post(sql_index,{"eaction":"tab1_index_bottom","region_type":region_type,"acct_month":'${acc_month_tab1.ACCT_MONTH}',"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){

			var d = $.parseJSON(data);
			if(!d.length){
				var num = $(".tab1_thead tr").children().length;
				$("#tab1_table").append("<tr><td colspan='"+num+"'>暂无数据</td></tr>");
			}
			$.each(d,function(index,item){
				if(region_type==3){
					if(index==0)
						$("#tab1_table").append("<tr><td class=\"text-important-a\">合计</td><td class=\"text-important-b\">"+item.D1+"</td><td>"+item.D2+"</td><td>"+item.D3+"</td><td>"+item.D4+"</td><td>"+item.D5+"</td></tr>");
					else
						$("#tab1_table").append("<tr><td class=\"text-important-a\" title=\""+item.REGION_NAME+"\">"+name_short(item.REGION_NAME,8)+"</td><td class=\"text-important-b\">"+item.D1+"</td><td>"+item.D2+"</td><td>"+item.D3+"</td><td>"+item.D4+"</td><td>"+item.D5+"</td></tr>");
				}
				else
					$("#tab1_table").append("<tr><td class=\"text-important-a\">"+item.REGION_NAME+"</td><td class=\"text-important-b\">"+item.D1+"</td><td>"+item.D2+"</td><td>"+item.D3+"</td><td>"+item.D4+"</td><td>"+item.D5+"</td></tr>");
			});
		});
	}

	function tab2_table(){
		$("#tab2_table").empty();
		$.post(sql_index,{"eaction":"tab2_index_bottom","region_type":region_type,"acct_day":tab2_day,"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){
			var d = $.parseJSON(data);
			if(!d.length){
				var num = $(".tab2_thead tr").children().length;
				$("#tab2_table").append("<tr><td colspan='"+num+"'>暂无数据</td></tr>");
			}
			$.each(d,function(index,item){
				if(region_type==3){
					if(index==0)
						$("#tab2_table").append("<tr><td class=\"text-important-a\">合计</td><td class=\"text-important-b\">"+item.D1+"</td><td>"+item.D2+"</td><td>"+item.D3+"</td><td>"+item.D4+"</td><td>"+item.D5+"</td></tr>");
					else
						$("#tab2_table").append("<tr><td class=\"text-important-a\" title=\""+item.REGION_NAME+"\">"+name_short(item.REGION_NAME,8)+"</td><td class=\"text-important-b\">"+item.D1+"</td><td>"+item.D2+"</td><td>"+item.D3+"</td><td>"+item.D4+"</td><td>"+item.D5+"</td></tr>");
				}else
					$("#tab2_table").append("<tr><td class=\"text-important-a\">"+item.REGION_NAME+"</td><td class=\"text-important-b\">"+item.D1+"</td><td>"+item.D2+"</td><td>"+item.D3+"</td><td>"+item.D4+"</td><td>"+item.D5+"</td></tr>");
			});
		});
	}

	//渠道份额4个环形图
	function tab2_pie(d1,d2,d3,d4){
		//resizeMainContainer(document.getElementById('tab2_pie'),"#c_view_bar1","");
		//$("#c_view_bar1").height($("#c_view_bar1").parent().height()*0.5);
		//$("#tab2_pie").height($("#c_view_bar1").height()*0.65);
		var tab2_pie = echarts.init(document.getElementById('tab2_pie'));
		tab2_pie.resize();

		var radius = pie_size;
		var legend = ['核心厅店','城市商圈','城市社区','农村乡镇'];
		$.post(sql_index,{"eaction":"tab2_index_middle1","region_type":region_type,"acct_day":tab2_day,"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){
			var d = $.parseJSON(data);
			if(d!="" && d!=null){
				$("#tab2_m_d1").text("网点"+d.VALUE1+"个");
				$("#tab2_m_d2").text("网点"+d.VALUE2+"个");
				$("#tab2_m_d3").text("网点"+d.VALUE3+"个");
				$("#tab2_m_d4").text("网点"+d.VALUE4+"个");

				$("#tab1_m_d1").text("网点"+d.VALUE1+"个");
				$("#tab1_m_d2").text("网点"+d.VALUE2+"个");
				$("#tab1_m_d3").text("网点"+d.VALUE3+"个");
				$("#tab1_m_d4").text("网点"+d.VALUE4+"个");
			}else{
				$("#tab2_m_d1").text("网点0个");
				$("#tab2_m_d2").text("网点0个");
				$("#tab2_m_d3").text("网点0个");
				$("#tab2_m_d4").text("网点0个");

				$("#tab1_m_d1").text("网点0个");
				$("#tab1_m_d2").text("网点0个");
				$("#tab1_m_d3").text("网点0个");
				$("#tab1_m_d4").text("网点0个");
			}
		});
		$.post(sql_index,{"eaction":"tab2_index_middle","region_type":region_type,"acct_day":tab2_day,"region_id":region_id,"bureau_no":bureau_no,"branch_no" : branch_no},function(data){
			var d = $.parseJSON(data);
			var d1 = 0;
			var d2 = 0;
			var d3 = 0;
			var d4 = 0;
			if(d!="" && d!=null){
				d1 = d.VALUE1;
				d2 = d.VALUE2;
				d3 = d.VALUE3;
				d4 = d.VALUE4;
			}
			var sum = parseFloat(100);

			$("#tab2_m_d1_1").text(d1+"%");
			$("#tab2_m_d1_2").text(d2+"%");
			$("#tab2_m_d1_3").text(d3+"%");
			$("#tab2_m_d1_4").text(d4+"%");

			var labelFromatter = {
				normal : {
					label : {
						formatter : function (params){
							return parseFloat(sum-params.value).toFixed(1);//parseFloat(100 - params.value).toFixed(2) + '%'
						},
						textStyle: {
							baseline : 'top',
							color: pie_color,
							fontSize:14
						}
					}
				}
			}
			var energy_option = {
						legend: {
							show:false,
							x : 'center',
							y : '70%',
							data:legend
						},
						series : [
							{
								type : 'pie',
								clockwise:false,
								animation:false,
								center : pie_position[0],
								radius : radius,
								//color: pie_color,
								hoverAnimation :false,//去掉鼠标悬浮放大效果
								x:'0', // for funnel
								//itemStyle : labelFromatter,
								data : [
									{name:'other', value:(sum-d1).toFixed(2), itemStyle : labelBottom},
									{name:legend[0], value:d1,itemStyle : labelTop}
								],
								itemStyle: item_color
							},
							{
								type : 'pie',
								clockwise:false,
								animation:false,
								center : pie_position[1],
								radius : radius,
								//color: pie_color,
								hoverAnimation :false,//去掉鼠标悬浮放大效果
								x:'20%', // for funnel
								//itemStyle : labelFromatter,
								data : [
									{name:'other', value:(sum-d2).toFixed(2), itemStyle : labelBottom},
									{name:legend[1], value:d2,itemStyle : labelTop}
								],
								itemStyle: item_color
							},
							{
								type : 'pie',
								clockwise:false,
								animation:false,
								center : pie_position[2],
								radius : radius,
								//color: pie_color,
								hoverAnimation :false,//去掉鼠标悬浮放大效果
								x:'40%', // for funnel
								//itemStyle : labelFromatter,
								data : [
									{name:'other', value:(sum-d3).toFixed(2), itemStyle : labelBottom},
									{name:legend[2], value:d3,itemStyle : labelTop}
								],
								itemStyle: item_color
							},
							{
								type : 'pie',
								clockwise:false,
								animation:false,
								center : pie_position[3],
								radius : radius,
								//color: pie_color,
								hoverAnimation :false,//去掉鼠标悬浮放大效果
								x:'40%', // for funnel
								//itemStyle : labelFromatter,
								data : [
									{name:'other', value:(sum-d4).toFixed(2), itemStyle : labelBottom},
									{name:legend[3], value:d4,itemStyle : labelTop}
								],
								itemStyle: item_color
							}
						]
			};
			tab2_pie.setOption(energy_option);
		});
	}

    //营销积分-积分构成饼状图

    function score_comp(fzjf,cljf){
    	resizeMainContainer(document.getElementById('yxjf_pie'),"#yxjf_score",score_pie);
    	var score_pie = echarts.init(document.getElementById('yxjf_pie'));
    	score_pie.resize();

    	var score_option = {
    		    title : {
    		    	show:false,
    		        text: '某站点用户访问来源',
    		        subtext: '纯属虚构',
    		        x:'center'
    		    },
    		    tooltip : {
    		    	show:false,
    		        trigger: 'item',
    		        formatter: function(params){
    		        	var htmlStr='',a=params.seriesName,b=params.data.name,c=params.data.value;
			        	htmlStr += a +':'+ '<br/>'+b+' : '+c
			        	return '<div style="width:120px;height:120px;">'+htmlStr+'万</div>';
    		        	},
    		        position:function(p){ //其中p为当前鼠标的位置
			        	return [p[0] - 40, p[1] - 40];
			        },
			        extraCssText:'width:85px;height:60px;background:#013c83;'
    		    },
    		    legend: {
    		    	show:false,
    		        orient : 'vertical',
    		        x : 'left',
    		        data:['发展','存量']
    		    },
    		    toolbox: {
    		        show : false,
    		        feature : {
    		            mark : {show: true},
    		            dataView : {show: true, readOnly: false},
    		            magicType : {
    		                show: true,
    		                type: ['pie', 'funnel'],
    		                option: {
    		                    funnel: {
    		                        x: '25%',
    		                        width: '50%',
    		                        funnelAlign: 'left',
    		                        max: 1548
    		                    }
    		                }
    		            },
    		            restore : {show: true},
    		            saveAsImage : {show: true}
    		        }
    		    },
    		    calculable : true,
    		    series : [
    		        {
    		            name:'积分分布',
    		            type:'pie',
    		            radius : '75%',
                        color:['#00b7ff', '#ee5091',],
                        center: ['50%', '50%'],
    		            data:[
    		                {value:fzjf, name:'发展'},
    		                {value:cljf, name:'存量'}
    		            ],
    		         	// 设置值域的标签
    		              label: {
    		                normal: {
    		                  position: 'inner',  // 设置标签位置，默认在饼状图外 可选值：'outer' ¦ 'inner（饼状图上）'
    		                  // formatter: '{a} {b} : {c}个 ({d}%)'   设置标签显示内容 ，默认显示{b}
    		                  // {a}指series.name  {b}指series.data的name
    		                  // {c}指series.data的value  {d}%指这一部分占总数的百分比 '\n\r'的意思是换行,使显示的内容更加紧凑
    		                  formatter: '{b}'+'\n\r'+'{d}%'
    		                }
    		              }
    		        }
    		    ]
    		};
    	score_pie.setOption(score_option);
    }

    //营销积分-日积分趋势

	//积分趋势
  function yxjf_trendLine(yxjf_type){
  	//resizeMainContainer(document.getElementById('c_view_yxjf'),"#c_view_bar",".c_title_com");
  	$("#c_view_yxjf").height($("#c_view_yxjf").parent().height()*0.72);
  	$("#c_view_yxjf").width($("#c_view_yxjf").parent().width()*0.96);
  	var yxjf_trend = echarts.init(document.getElementById('c_view_yxjf'));
  	yxjf_trend.resize();
    yxjf_trend.clear();
		var cur_month = '${initDay}'.substring(0,6);//getNowFormatDate();
		var last_month = getPreMonth(cur_month);
		var sep = "-";
		var legend_curMonth = cur_month.substring(0,4)+sep+cur_month.substring(4,6);
		var legend_lastMonth = last_month.substring(0,4)+sep+last_month.substring(4,6);
		var is_div = 1;
		$.post(sql_url,{"eaction":"yxjf_trendList",
						'region_id' : region_id,
						'bureau_no' : bureau_no,
						"branch_no" : branch_no,
						'region_type' : region_type-1,
						'acct_month':cur_month
						},
		  function(resultmonth){
			$.post(sql_url,{"eaction":"yxjf_lasttrendList",
							'region_id' : region_id,
							'bureau_no' : bureau_no,
							"branch_no" : branch_no,
							'region_type' : region_type-1,
							'last_month':last_month
							},
			  function(resultMonthLast){
				var json1= $.parseJSON(resultmonth);
				var json2= $.parseJSON(resultMonthLast);
				var byjfDay = [];//本月积分
				var syjfDay = [];//上月积分
				$.each(json1, function(i, n){
					if(yxjf_type == '1'){
						byjfDay.push(filterNull(n.CUR_DAY_JF));
					}
					if(yxjf_type == '2'){
						byjfDay.push(filterNull(n.FZ_OF_CUR_DAY_JF));
					}
					if(yxjf_type == '3'){
						byjfDay.push(filterNull(n.CL_OF_CUR_DAY_JF));
					}
				})
				$.each(json2, function(j, k){
					if(yxjf_type == '1'){
						syjfDay.push(filterNull(k.CUR_DAY_JF));
					}
					if(yxjf_type == '2'){
						syjfDay.push(filterNull(k.FZ_OF_CUR_DAY_JF));
					}
					if(yxjf_type == '3'){
						syjfDay.push(filterNull(k.CL_OF_CUR_DAY_JF));
					}
				})
				var yxjf_trendoption = {
					tooltip : {
						trigger: 'axis',
						formatter: function(params){
							var str = "";
							$.each(params,function(index,ele){
								if(index==0)
									str += ele.name+"<br/>";
								str += ele.seriesName+":"+ele.value+(region_type<3?'万':'');
								if(index<params.length-1)
									str += "<br/>";
							});
							return str;
			        //return '<div style="width:120px;height:120px;">'+htmlStr+'万</div>';
						}
					},
					grid: {
						right: '2%',
						left: '-5%',
						top:'14%',
						bottom:'4%',
						containLabel: true
					},
					legend: {
						show:true,
						top:'2%',
						right: '6%',
						//data:[legend_curMonth,legend_lastMonth],
						data:['本月','上月'],
						textStyle:{//图例文字的样式
				            color:'#ccc',
				            fontSize:13
				        }
					},
					calculable : true,
					xAxis : [
						{
							axisTick: {
								show: false
							},
							axisLine: {
								show: true,
								lineStyle: {color: '#666'}
							},
							type : 'category',
							boundaryGap : false,
							data : ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
							,axisLabel: {
	                            show: true,
	                            textStyle: {
	                                color: '#fff'
	                            }
	                        }
						}
					],
					yAxis : {
						show:false,
						type : 'value'
					},
					series : [
						{
							//name:legend_curMonth,
							animation:false,
							name:'本月',
							type:'line',
							areaStyle: {
								normal: {
									color:'transparent'
									/*color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
										offset: 0,
										color: 'rgba(255, 180, 0,0.5)'
									}, {
										offset: 1,
										color: 'rgba(255, 180, 0,0.2)'
									}], false)*/
								}
							},
							smooth:true,
							showSymbol: true,
							symbol:'circle',
							itemStyle: {
								normal: {
									color: '#ffb400'
								}
							},
							lineStyle: {
								normal: {
									width: 1.5
								}
							},
							data:byjfDay
						},
						{
							name:'上月',
							type:'line',
							animation:false,
							areaStyle: {
								normal: {
									color:'transparent'
									/*color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
										offset: 0,
										color: 'rgba(216, 244, 247,0.8)'
									}, {
										offset: 1,
										color: 'rgba(216, 244, 247,0.2)'
									}], false)*/
								}
							},
							smooth:true,
							showSymbol: true,
							symbol:'circle',
							itemStyle: {
								normal: {
									color: '#58c8da'
								}
							},
							lineStyle: {
								normal: {
									width: 1.5
								}
							},
							data:syjfDay
						}
					]
				};
				yxjf_trend.setOption(yxjf_trendoption);
			});
		});
	}

    //日积分分布
    function yxjf_org(){
    	//日积分分布
    	var type_html1='';
    	var type_html2='';
    	var params = "";

    	if(region_type=="3"){
    		params = {
					"eaction"   : "yxjf_area_bureau",
					'region_id' : region_id,
					'bureau_no' : bureau_no,
					'region_type' : region_type-1,
					'acct_day': acct_day,
					'acct_month':max_month,
					'div_10000':0,
					'div_10000_1':0,
				}
    	}else if(region_type=="4"){
    		params = {
					"eaction"   : "yxjf_area_branch",
					'region_id' : region_id,
					'bureau_no' : bureau_no,
					"branch_no" : branch_no,
					'region_type' : region_type-1,
					'acct_day': acct_day,
					'acct_month':max_month,
					'div_10000':1,
					'div_10000_1':1,
				 }
    	}else{
    		params = 	{
					"eaction"   : "yxjf_area",
					'region_id' : region_id,
					'region_type' : region_type-1,
					'acct_day': acct_day,
					'acct_month':max_month,
					'div_10000':1,
					'div_10000_1':1,
				}
    	}

    	//日积分
    	if(region_type==3){
    			params.div_10000 = 0;
    			params.div_10000_1 = 0;
    			$(".yxjf_name_d").text("分");
    			$(".yxjf_name_d_1").text("分");
    	}else{
    			params.div_10000 = 1;
    			params.div_10000_1 = 1;
    			$(".yxjf_name_d").text("万分");
    			$(".yxjf_name_d_1").text("万分");
    	}

    	$.post(sql_url,params,function(obj){
    			var data = $.parseJSON(obj);

    			if(data != '' && data != null ){
    				$.each(data, function (index, value) {
    							var rn = value.RN =='0'?'':value.RN;
    							var area = "";
    							if(region_type=="3"){
    								if(index==0)
    									area = "合计";
    								else
    									area = name_short(value.BRANCH_NAME,14);
    							}
    							else if(region_type=="4")
    								area = value.GRID_NAME;
    							else if(region_type=='2')
										area = value.BUREAU_NAME;
									else
										area = value.LATN_NAME;

    							type_html1+='<tr>'+
    											//'<td>'+rn+'</td>    '+
    											'<td class=\"text-important-a\" title=\"'+area+'\">'+area+'</td>    '+
    											'<td>'+value.CUR_MONTH_SUM_JF+'</td>      '+
    											'<td>'+value.CUR_DAY_JF+'</td>      '+
    											'<td>'+value.HJ_JF+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';
    				});
  				}else{
						type_html1 +='<tr>暂无数据!</tr>'
  				}
  				$("#sw_tab4").html(type_html1);
    	});

    	var params1 = {
    		"eaction":"tab3_index_bottom",
    		"region_type" : region_type-1,
    		'latn_id' : region_id,
				'bureau_no' : bureau_no,
				"branch_no" : branch_no,
				'acct_day': acct_day,
				'acct_month':max_month
    	}
    	//月积分
    	if(region_type==3){
    			params1.div_10000 = 0;
    			params1.div_10000_1 = 0;
    			$(".yxjf_name_m").text("分");
    			$(".yxjf_name_m_1").text("分");
    	}else{
    			params1.div_10000 = 1;
    			params1.div_10000_1 = 1;
    			$(".yxjf_name_m").text("万分");
    			$(".yxjf_name_m_1").text("万分");
    	}

    	$.post(sql_url,params1,function(data){
    		var data = $.parseJSON(data);
    		if(data != '' && data != null ){
    			$.each(data, function (index, value) {
							var rn = value.RN =='0'?'':value.RN;
							var area = "";
							if(region_type=="3"){
								if(index==0)
									area = "合计";
								else
									area = name_short(value.REGION_NAME,14);
							}else
								area = value.REGION_NAME;

							type_html2+='<tr>'+
											//'<td>'+rn+'</td>    '+
											'<td class=\"text-important-a\" title=\"'+area+'\">'+area+'</td>    '+
											'<td>'+value.CUR_YEAR_JF+'</td>      '+
											'<td>'+value.CUR_MON_JF+'</td>      '+
											'<td>'+value.CUR_MON_HJ+'</td>     '+
											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
										'</tr> ';
  				});
    		}else{
    			type_html2 +='<tr>暂无数据!</tr>'
    		}
    		$("#sw_tab5").html(type_html2);
    	});

    }
  	//发展效能3个 环形图
    function energy_analysis(total,high,low,zero){
    	var energy_pie = echarts.init(document.getElementById('energy_analysis_pie'));
    	high = parseFloat(high).toFixed(2);
    	low = parseFloat(low).toFixed(2);
    	zero = parseFloat(zero).toFixed(2);
    	var labelTop = {
    		    normal : {
    		        label : {
    		            show : false,
    		            position : 'center',
    		            formatter : '{b}',
    		            textStyle: {
    		                baseline : 'bottom',
    		                color: '#fff'
    		            }
    		        },
    		        labelLine : {
    		            show : false
    		        }
    		    }
    		};
    		var labelFromatter = {
    		    normal : {
    		        label : {
    		            formatter : function (params){
    		                return parseFloat(100 - params.value).toFixed(2) + '%'
    		            },
    		            textStyle: {
    		                baseline : 'top',
    		                color: '#fff',
//    		                fontSize: 20
    		            },
    		            position : 'center'
    		        }
    		    },
    		}
    		var labelBottom = {
    		    normal : {
    		        color: '#fff',
    		        label : {
    		            show : true,
    		            position : 'center'
    		        },
    		        labelLine : {
    		            show : false
    		        }
    		    },
    		    emphasis: {
    		        color: 'rgba(255,255,255,1)'
    		    }
    		};


        var radius = ['30%', '40%'];
    		var energy_option = {
    		    legend: {
    		    	show:false,
    		        x : 'center',
    		        y : '70%',
    		        data:[
    		            '高销门店','低销门店','零销门店'
    		        ]
    		    },
    		    series : [
    		        {
    		            type : 'pie',
    		            center : ['13%', '47%'],
    		            radius : radius,
                        color:pie_color,
                        hoverAnimation :false,//去掉鼠标悬浮放大效果
    		            x:'0%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:100-high, itemStyle : labelBottom},
    		                {name:'高销门店', value:high,itemStyle : labelTop}
    		            ]
    		        },
    		        {
    		            type : 'pie',
    		            center : ['44%', '47%'],
    		            radius : radius,
                        color:pie_color,
                        hoverAnimation :false,//去掉鼠标悬浮放大效果
    		            x:'20%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:100-low, itemStyle : labelBottom},
    		                {name:'低销门店', value:low,itemStyle : labelTop}
    		            ]
    		        },
    		        {
    		            type : 'pie',
    		            center : ['73%', '47%'],
    		            radius : radius,
                        color:pie_color,
                        hoverAnimation :false,//去掉鼠标悬浮放大效果
    		            x:'40%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:100-zero, itemStyle : labelBottom},
    		                {name:'零销门店', value:zero,itemStyle : labelTop}
    		            ]
    		        }
    		    ]
    		};
    		energy_pie.setOption(energy_option);
    }
	  //营销积分-日积分趋势


		//发展规模 规模趋势
	  function xnqs_trendLine(yxjf_type){
	  	$("#c_view_xnqs").height($("#c_view_xnqs").parent().height()*0.72);
	  	$("#c_view_xnqs").width($("#c_view_xnqs").parent().width()*0.96);
	  	//$("#fzzt_bar").height($("#fzzt_bar").parent().height()*0.74);
	  	//$("#fzzt_bar").width($("#fzzt_bar").parent().width()*0.96);
	    var xnqs_trend = echarts.init(document.getElementById('c_view_xnqs'));
	    xnqs_trend.clear();
			var cur_month = '${initDay}'.substring(0,6);//getNowFormatDate();
			var last_month = getPreMonth(cur_month);
			var sep = "-";
			var legend_curMonth = cur_month.substring(0,4)+sep+cur_month.substring(4,6);
			var legend_lastMonth = last_month.substring(0,4)+sep+last_month.substring(4,6);
			$.post(sql_url,{"eaction":"fzxn_trendList",
							'region_id' : region_id,
							'bureau_no' : bureau_no,
							"branch_no" : branch_no,
							'region_type' : region_type-1,
							'acct_month':cur_month},
					function(resultmonth){
				$.post(sql_url,{"eaction":"fzxn_lasttrendList",
								'region_id' : region_id,
								'bureau_no' : bureau_no,
								"branch_no" : branch_no,
								'region_type' : region_type-1,
								'last_month':last_month},
						function(resultMonthLast){
					var json1= $.parseJSON(resultmonth);
					var json2= $.parseJSON(resultMonthLast);
					var byjfDay = [];//本月积分
					var syjfDay = [];//上月积分
					$.each(json1, function(i, n){
						if(yxjf_type == '1'){
							byjfDay.push(filterNull(n.CUR_DAY_FZ_YD));
						}
						if(yxjf_type == '2'){
							byjfDay.push(filterNull(n.CUR_DAY_FZ_KD));
						}
						if(yxjf_type == '3'){
							byjfDay.push(filterNull(n.CUR_DAY_FZ_ITV));
						}
					})
					$.each(json2, function(j, k){
						if(yxjf_type == '1'){
							syjfDay.push(filterNull(k.CUR_DAY_FZ_YD));
						}
						if(yxjf_type == '2'){
							syjfDay.push(filterNull(k.CUR_DAY_FZ_KD));
						}
						if(yxjf_type == '3'){
							syjfDay.push(filterNull(k.CUR_DAY_FZ_ITV));
						}
					})
					var xnqs_trendoption = {
						tooltip : {
							trigger: 'axis',
							formatter: function(params){
								var str = "";
								$.each(params,function(index,ele){
									if(index==0)
										str += ele.name+"<br/>";
									str += ele.seriesName+":"+ele.value+(region_type<2?'万':'');
									if(index<params.length-1)
										str += "<br/>";
								});
								return str;
				        //return '<div style="width:120px;height:120px;">'+htmlStr+'万</div>';
							}
						},
						grid: {
							right: '2%',
							left: '-5%',
							top:'14%',
							bottom:'4%',
							containLabel: true
						},
						legend: {
							show:true,
							top:'2%',
							right: '6%',
							//data:[legend_curMonth,legend_lastMonth],
							data:['本月','上月'],
							textStyle:{//图例文字的样式
					            color:'#ccc',
					            fontSize:13
					        }
						},
						calculable : true,
						xAxis : [
							{
								axisTick: {
									show: false
								},
								axisLine: {
									show: true,
									lineStyle: {color: '#666'}
								},
								type : 'category',
								boundaryGap : false,
								data : ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
								,axisLabel: {
		                            show: true,
		                            textStyle: {
		                                color: '#fff'
		                            }
		                        }
							}
						],
						yAxis : {
							show:false,
							type : 'value'
						},
						series : [
							{
								name:'本月',
								type:'line',
								animation:false,
								areaStyle: {
									normal: {
										/* color: '#feef02',
			                            opacity: 0.2 */
										/*color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
											offset: 0,
											color: 'rgba(255, 180, 0,0.5)'
										}, {
											offset: 1,
											color: 'rgba(255, 180, 0,0.2)'
										}], false)*/
										color:'transparent'
									}
								},
								smooth:true,
								showSymbol: true,
								symbol:'circle',
								itemStyle: {
									normal: {
										color: '#feef02'
									}
								},
								lineStyle: {
									normal: {
										width: 1.5
									}
								},
								data:byjfDay
							},
							{
								name:'上月',
								type:'line',
								animation:false,
								areaStyle: {
									normal: {
										/* color: '#03d2e3',
			                            opacity: 0.2 */
										/*color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
											offset: 0,
											color: 'rgba(216, 244, 247,0.8)'
										}, {
											offset: 1,
											color: 'rgba(216, 244, 247,0.2)'
										}], false)*/
										color:'transparent'
									}
								},
								smooth:true,
								showSymbol: true,
								symbol:'circle',
								itemStyle: {
									normal: {
										color: '#03d2e3'
									}
								},
								lineStyle: {
									normal: {
										width: 1.5
									}
								},
								data:syjfDay
							}
						]
					};
					xnqs_trend.setOption(xnqs_trendoption);
				});
			});
		}
	  //发展规模 区域效益

    function fzgm_org(){
    	//日积分分布
    	var type_html1='';
    	var type_html2='';
    	var type_html3='';
    	if(region_type == '3'){
    		$.post(sql_url,
    				{
    					"eaction"   : "fzgm_area_bureau",
    					'region_id' : region_id,
    					'bureau_no' : bureau_no,
    					'region_type' : region_type-1,
    					'acct_day': acct_day
    				 },
    				function(obj){
    					var data = $.parseJSON(obj);
    					 //为空判断
    					if(data != '' && data != null ){
    						$.each(data, function (index, value) {
    							var rn = value.RN =='0'?'':value.RN;
    							var area = value.BRANCH_NAME;
    							if(index==0)
    									area = "合计";
    							type_html1+='<tr>'+
    											'<td class=\"text-important-a\" title=\"'+area+'\">'+name_short(area,10)+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_YD+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_YD+'</td>     '+
    											'<td>'+value.LAST_D_YD+'</td>     '+
    											'<td>'+value.D_YD_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							type_html2+='<tr>'+
    											'<td class=\"text-important-a\" title=\"'+area+'\">'+name_short(area,10)+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_KD+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_KD+'</td>     '+
    											'<td>'+value.LAST_D_KD+'</td>     '+
    											'<td>'+value.D_KD_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							type_html3+='<tr>'+
    											'<td class=\"text-important-a\" title=\"'+area+'\">'+name_short(area,10)+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_ITV+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_ITV+'</td>     '+
    											'<td>'+value.LAST_D_ITV+'</td>     '+
    											'<td>'+value.D_ITV_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							if(index==0){
    								///发展概况
    								$("#tab4_t_d1").text(value.CUR_MONTH_FZ_YD);
    								$("#tab4_t_d2").text(value.CUR_MONTH_FZ_KD);
    								$("#tab4_t_d3").text(value.CUR_MONTH_FZ_ITV);
    								$("#tab4_t_d4").text("当日："+value.CUR_DAY_FZ_YD);
    								$("#tab4_t_d5").text("当日："+value.CUR_DAY_FZ_KD);
    								$("#tab4_t_d6").text("当日："+value.CUR_DAY_FZ_ITV);
    							}
    					});
    				}else{
    					 type_html1 +='<tr><td colspan="5">暂无数据</td></tr>';
    					 type_html2 +='<tr><td colspan="5">暂无数据</td></tr>';
    					 type_html3 +='<tr><td colspan="5">暂无数据</td></tr>';
    				}
    				$("#tab4_sw_tab1").html(type_html1);
    				$("#tab4_sw_tab2").html(type_html2);
    				$("#tab4_sw_tab3").html(type_html3);
    			});
    	}else if(region_type == '4'){
    		$.post(sql_url,
    				{
    					"eaction"   : "fzgm_area_branch",
    					'region_id' : region_id,
    					'bureau_no' : bureau_no,
    					"branch_no" : branch_no,
    					'region_type' : region_type-1,
    					'acct_day': acct_day
    				 },
    				function(obj){
    					var data = $.parseJSON(obj);
    					 //为空判断
    					if(data != '' && data != null ){
    						$.each(data, function (index, value) {
    							var rn = value.RN =='0'?'':value.RN;
    							var area = value.GRID_NAME;
    							type_html1+='<tr>'+
    											'<td class=\"text-important-a\">'+area+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_YD+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_YD+'</td>     '+
    											'<td>'+value.LAST_D_YD+'</td>     '+
    											'<td>'+value.D_YD_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							type_html2+='<tr>'+
    											'<td class=\"text-important-a\">'+area+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_KD+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_KD+'</td>     '+
    											'<td>'+value.LAST_D_KD+'</td>     '+
    											'<td>'+value.D_KD_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							type_html3+='<tr>'+
    											'<td class=\"text-important-a\">'+area+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_ITV+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_ITV+'</td>     '+
    											'<td>'+value.LAST_D_ITV+'</td>     '+
    											'<td>'+value.D_ITV_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							if(index==0){
    								///发展概况
    								$("#tab4_t_d1").text(value.CUR_MONTH_FZ_YD);
    								$("#tab4_t_d2").text(value.CUR_MONTH_FZ_KD);
    								$("#tab4_t_d3").text(value.CUR_MONTH_FZ_ITV);
    								$("#tab4_t_d4").text("当日："+value.CUR_DAY_FZ_YD);
    								$("#tab4_t_d5").text("当日："+value.CUR_DAY_FZ_KD);
    								$("#tab4_t_d6").text("当日："+value.CUR_DAY_FZ_ITV);
    							}
    					});
    				}else{
    					 type_html1 +='<tr><td colspan="5">暂无数据</td></tr>';
    					 type_html2 +='<tr><td colspan="5">暂无数据</td></tr>';
    					 type_html3 +='<tr><td colspan="5">暂无数据</td></tr>';
    				}
    				$("#tab4_sw_tab1").html(type_html1);
    				$("#tab4_sw_tab2").html(type_html2);
    				$("#tab4_sw_tab3").html(type_html3);
    			});
    	}
    	else{
        $.post(sql_url,
			{
				"eaction"   : "fzgm_area",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_day': acct_day
			 },
			function(obj){
    					var data = $.parseJSON(obj);
    					 //为空判断
    					if(data != '' && data != null ){
    						$.each(data, function (index, value) {
    							var rn = value.RN =='0'?'':value.RN;
    							var area = value.LATN_NAME;
									if(region_id != '' && bureau_no == ''){
										area = value.BUREAU_NAME;
									}
									if(region_id != '' && bureau_no != ''){
										area = value.BUREAU_NAME;
									}
    							type_html1+='<tr>'+
    											'<td class=\"text-important-a\">'+area+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_YD+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_YD+'</td>     '+
    											'<td>'+value.LAST_D_YD+'</td>     '+
    											'<td>'+value.D_YD_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							type_html2+='<tr>'+
    											'<td class=\"text-important-a\">'+area+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_KD+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_KD+'</td>     '+
    											'<td>'+value.LAST_D_KD+'</td>     '+
    											'<td>'+value.D_KD_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							type_html3+='<tr>'+
    											'<td class=\"text-important-a\">'+area+'</td>    '+
    											//'<td>'+value.CUR_MONTH_FZ+'</td>      '+
    											'<td>'+value.CUR_MONTH_FZ_ITV+'</td>     '+
    											'<td>'+value.CUR_DAY_FZ_ITV+'</td>     '+
    											'<td>'+value.LAST_D_ITV+'</td>     '+
    											'<td>'+value.D_ITV_HUAN+'</td>     '+
    											//'<td>'+value.MONTH_FZ_RATE+'</td>     '+
    										'</tr> ';

    							if(index==0){
    								///发展概况
    								$("#tab4_t_d1").text(value.CUR_MONTH_FZ_YD);
    								$("#tab4_t_d2").text(value.CUR_MONTH_FZ_KD);
    								$("#tab4_t_d3").text(value.CUR_MONTH_FZ_ITV);
    								$("#tab4_t_d4").text("当日："+value.CUR_DAY_FZ_YD);
    								$("#tab4_t_d5").text("当日："+value.CUR_DAY_FZ_KD);
    								$("#tab4_t_d6").text("当日："+value.CUR_DAY_FZ_ITV);
    							}
    					});
    				}else{
    					 type_html1 +='<tr><td colspan="5">暂无数据</td></tr>';
    					 type_html2 +='<tr><td colspan="5">暂无数据</td></tr>';
    					 type_html3 +='<tr><td colspan="5">暂无数据</td></tr>';
    				}
    				$("#tab4_sw_tab1").html(type_html1);
    				$("#tab4_sw_tab2").html(type_html2);
    				$("#tab4_sw_tab3").html(type_html3);
    			});
    	}
    }
    /*发展质态 柱状图*/
    function fzzt_trendBarReload(type){
    	//发展质态 柱状图
      $.post(sql_url,
			{
				"eaction"   : "ml_trend",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				"branch_no" : branch_no,
				'region_type' : region_type-1,
				'acct_month': acct_minmonth
			},
  		function(obj){
      	var data = $.parseJSON(obj);
      	var xMonth = [],yData = [];
    	 //为空判断
        if(data != '' && data != null ){
        	$.each(data, function (index, value) {
        		xMonth.push(value.MONTH_CODE);
        		if(type == 1){
							yData.push(parseFloat(value.CUR_MON_ACTIVE_RATE));
        		}
        		if(type == 2){
        			yData.push(parseFloat(value.CUR_MON_BILLING_RATE));
        		}
        		if(type == 3){
        			yData.push(parseFloat(value.CUR_MON_REMOVE_RATE));
        		}
        		if(type == 4){
        			yData.push(parseFloat(value.CUR_MON_DNA_RATE));
        		}
        	});
        }else{
        	$.each(data, function (index, value) {
        		xMonth.push(value.MONTH_CODE);
						yData.push(0.00);
        	});
        }
        fzzt_trendBar(xMonth,yData,type);
			});
    }
	//质态趋势
	function fzzt_trendBar(xMonth,yData,type){
		$("#fzzt_bar").height($("#fzzt_bar").parent().height*0.72);
		$("#fzzt_bar").width($("#fzzt_bar").parent().width*0.96);
		var c_fzzt_bar = echarts.init(document.getElementById('fzzt_bar'));
		c_fzzt_bar.clear();
		var option = {
			color: ['#00fff0'],
			grid:{
				bottom: '20%',
				right: '4%',
				top:'13%',
				left:'4%'
			},
			xAxis: {
				type: 'category',
				data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
				axisTick: {
					show: false},
				axisLine: {lineStyle: {color: '#e4e4e4'}},
				axisLabel: {textStyle: {fontSize:12}}
			},
			yAxis: {
				show:false,
				type: 'value',
				splitLine:{show:false},
				axisLine: {
					lineStyle: {color:'#555'}
				}
			},

			series: [{
				data: yData,//[820, 932, 901, 820, 932, 932],
				type: 'bar',
				animation:false,
				barWidth: '16',
				itemStyle: {
					normal: {
						label: {
							show: true,
							position: 'top' ,
							formatter:function(obj,a,b){
								if(type == 4){
									return obj.value;
								}else{
									if(obj.value==0){
										if(obj.name <= '${maxMonth}')
											return "0.0%";
										else
											return "";
									}
									return obj.value+"%";
								}
							},
							textStyle: {color:'#ffffff',fontSize: '13'}
						}
					}
				}
			}]
		};
		c_fzzt_bar.setOption(option);
	}
  //发展质态分类分布
    function fzzt_type(){
    	//日积分分布
        $.post(sql_url,
			{
				"eaction"   : "fzzt_type_list",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				"branch_no" : branch_no,
				'region_type' : region_type-1,
				'acct_month': acct_xnmonth
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				var type_all='',type_html='',account_html='',leave_html='';
				if(data != '' && data != null ){
						type_html+='<tr><td>移动活跃率：</td>';
					$.each(data, function (index, value) {
								type_html+='<td>'+value.CUR_MON_ACTIVE_RATE+'</td>';
							});
						type_html+='</tr>';
						account_html+='<tr><td>移动出账率：</td>';
					$.each(data, function (index, value) {
						account_html+='<td>'+value.CUR_MON_BILLING_RATE+'</td>';
							});
						account_html+='</tr>';
						leave_html+='<tr><td>移动离网率：</td>';
					$.each(data, function (index, value) {
						leave_html+='<td>'+value.CUR_MON_REMOVE_RATE+'</td>';
							});
						leave_html+='</tr>';
				  type_all = type_html+account_html+leave_html+
					 ' <tr>             '+
					'	<td>移动DNA户均：</td>'+
					'	<td>23.14%</td>    '+
					'	<td>22.58%</td> '+
					'	<td>22.58%</td> '+
					'	<td>22.58%</td> '+
					 '</tr>             ';
			}else{
				type_all +='<tr><td colspan="5">暂无数据</td></tr>'
			}
			$("#fzzt_type_data").html(type_all);
		});
    }
  //发展质态区域分布
    function fzzt_area(){
    	//日积分分布
    	var params = "";
    	if(region_type == '3'){
  			params = {
  				"eaction"   : "fzzt_area_bureau",
					'region_id' : region_id,
					'bureau_no' : bureau_no,
					'region_type' : region_type-1,
					'acct_month': acct_xnmonth
  			};
    	}else if(region_type == '4'){
    		params = {
					"eaction"   : "fzzt_area_branch",
					'region_id' : region_id,
					'bureau_no' : bureau_no,
					"branch_no" : branch_no,
					'region_type' : region_type-1,
					'acct_month': acct_xnmonth
			  }
    	}else{
    		params = {
					"eaction"   : "fzzt_area",
					'region_id' : region_id,
					'bureau_no' : bureau_no,
					'region_type' : region_type-1,
					'acct_month': acct_xnmonth
			  }
    	}

    	$.post(sql_url,params,function(obj){
    		var data = $.parseJSON(obj);
				 //为空判断
				var type_html1='';
				var type_html2='';
				var type_html3='';
				if(data != '' && data != null ){
					$.each(data, function (index, value) {
						var rn = value.RN =='0'?'':value.RN;
						var area = "";
						var area1 = "";
						if(region_type=="3"){
							if(index==0){
								area1 = "合计";
								area = "合计";
							}
							else{
								area1 = value.BRANCH_NAME;
								area = name_short(value.BRANCH_NAME,10);
							}
						}
						else if(region_type=='4'){
							area = value.GRID_NAME;
							area1 = value.GRID_NAME;
						}
						else if(region_type=='2'){
							area = value.BUREAU_NAME;
							area1 = value.BUREAU_NAME;
						}
						else{
							area1 = value.LATN_NAME;
							area = value.LATN_NAME;
						}
						type_html1+='<tr>'+
										'<td class=\"text-important-a\" title=\"'+area1+'\">'+area+'</td>    '+
										'<td class=\"text-important-b\">'+value.CUR_MON_ACTIVE_RATE+'</td>      '+
										'<td>'+value.CUR_MON_BILLING_RATE+'</td>     '+
										'<td>'+value.CUR_MON_REMOVE_RATE+'</td>     '+
										'<td>'+value.CUR_MON_DNA_RATE+'</td>     '+
									'</tr> ';

						type_html2+='<tr>'+
										'<td class=\"text-important-a\" title=\"'+area1+'\">'+area+'</td>    '+
										'<td class=\"text-important-b\">'+value.CUR_MON_KD_ACTIVE_RATE+'</td>      '+
										'<td>'+value.CUR_MON_KD_REMOVE_RATE+'</td>     '+
									'</tr> ';

						type_html3+='<tr>'+
										'<td class=\"text-important-a\" title=\"'+area1+'\">'+area+'</td>    '+
										'<td class=\"text-important-b\">'+value.CUR_MON_ITV_ACTIVE_RATE+'</td>      '+
										'<td>'+value.CUR_MON_ITV_REMOVE_RATE+'</td>     '+
									'</tr> ';
					});
    		}else{
				 type_html1 +='<tr><td colspan="3">暂无数据</td></tr>'
				 type_html2 +='<tr><td colspan="3">暂无数据</td></tr>'
				 type_html3 +='<tr><td colspan="3">暂无数据</td></tr>'
    		}
    		$("#tab5_sw_tab1").html(type_html1);
    		$("#tab5_sw_tab2").html(type_html2);
    		$("#tab5_sw_tab3").html(type_html3);
    	});
    }
  //发展质态区域分布
    function fzxy_area(){
    	if(region_type==3){
    		$(".c_fzxyqy_table-head table").empty();
    		$(".c_fzxyqy_table-head table").append(
    			"<tr><td class=\"region_name\" style=\"width:25%;\">区域</td><td style=\"width:25%;\">销售标签</td><td style=\"width:25%;\">毛利率</td><td style=\"width:25%;\">毛利</td></tr>"
    		);
    	}
    	//日积分分布
    	$.post(sql_url,
    		{
    			"eaction":"fzxy_area",
    			"region_type":region_type-1,
    			"acct_month":acct_xnmonth,
    			"region_id":region_id,
    			"bureau_no":bureau_no
    		},
    		function(list){
    			var str = "";
    			var data = $.parseJSON(list);
    			if(data.length){
    				$.each(data,function(index,item){
							area = item.REGION_NAME;
							if(index==0 && region_type==3)
									area = "合计";

							if(region_type==3){//区县显示厅店一级，列内容中更改为销量标签
								var sale_flag = item.ZERO_SALE_CHANNEL==1?'零销门店':(item.LOW_SALE_CHANNEL==1?'低销门店':(item.HIGH_CHANNEL==1?'高销门店':''));
								str += "<tr>"+
											 "<td class=\"text-important-a\" title=\""+area+"\" style=\"width:25%;\">"+name_short(area,13)+"</td>"+
											 "<td style=\"width:25%;\">"+sale_flag+"</td>"+
											"<td class=\"text-important-b\" style=\"width:25%;\">"+item.CUR_MON_BENEFIT_RATE+"</td>"+
											"<td style=\"width:25%;\">"+item.CUR_MON_AMOUNT+"</td>"+
											"</tr>";
							}else{
								str+='<tr>'+
											'<td class=\"text-important-a\" title=\"'+area+'\">'+name_short(area,10)+'</td>    '+
											'<td class=\"text-important-b\">'+item.CUR_MON_BENEFIT_RATE+'</td>      '+
											'<td>'+item.CUR_MON_AMOUNT+'</td>     '+
											//'<td>'+item.CUR_MON_INCOME+'</td>     '+
											//'<td>'+item.CUR_MON_CB+'</td>     '+
											"<td>"+item.ZERO_SALE_CHANNEL+"</td>"+
											"<td>"+item.LOW_SALE_CHANNEL+"</td>"+
											"<td>"+item.HIGH_CHANNEL+"</td>"+
										'</tr> ';
							}
    				});
    			}else{
    				if(region_type==3)
    					str ='<tr><td colspan="4">暂无数据</td></tr>';
    				else
    					str ='<tr><td colspan="6">暂无数据</td></tr>';
    			}
    			$("#fzxyqy_table_data").html(str);
    		});
    }
  function fzxy_xy_analize(){
	//发展效益-效益分析
      $.post(sql_url,
			{
				"eaction"   : "qdxy_analyze_data",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				"branch_no" : branch_no,
				'region_type' : region_type-1,
				'acct_month': acct_xnmonth
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				if(data != '' && data != null ){
						//效益分析

						$("#ml_rate").html(data.CUR_MON_BENEFIT_RATE.replace('%','')+percent);

						//$("#ml_num").html(data.CUR_MON_AMOUNT+yuan);
						//$("#sr_num").html(data.CUR_MON_INCOME+yuan);
						//$("#cb_num").html(data.CUR_MON_CB+yuan);

						if(data.CMI_FLAG=='xiao')
							$("#100new_income_num").html(data.CUR_MON_100_INCOME+big_yuan);
						else if(data.CMI_FLAG=='da')
							$("#100new_income_num").html(data.CUR_MON_100_INCOME+big_wan_yuan);

						if(data.CM_FLAG=='xiao')
							$("#100new_num").html(data.CUR_MON_100_USER+big_hu);
						else if(data.CM_FLAG=='da')
							$("#100new_num").html(data.CUR_MON_100_USER+big_wan_hu);

						if(data.ML_FLAG=='xiao')
							$("#tab6_t_d4").html(data.CUR_MON_AMOUNT+yuan);
						else if(data.ML_FLAG=='da')
							$("#tab6_t_d4").html(data.CUR_MON_AMOUNT+wan_yuan);

						if(data.SHOURU_FLAG=='xiao')
							$("#tab6_t_d5").html(data.CUR_MON_JF_INCOME+yuan);
						else if(data.SHOURU_FLAG=='da')
							$("#tab6_t_d5").html(data.CUR_MON_JF_INCOME+wan_yuan);

						if(data.XZYH_FLAG=='xiao')
							$("#tab6_t_d6").html(data.YD_KD_ITV_XZ_YEAR+hu);
						else if(data.XZYH_FLAG=='da')
							$("#tab6_t_d6").html(data.YD_KD_ITV_XZ_YEAR+wan_hu);

						//成本构成
						$("#cb_total").html(data.CUR_MON_AMOUNT+"万");
						$("#cb_fc").html(data.CUR_MONTH_ALL_FC+"万");
						$("#cb_jl").html(data.CUR_MONTH_ALL_JL+"万");
						$("#cb_yj").html(data.CUR_MONTH_ALL_YJ+"万");
						$("#cb_zc").html(data.CUR_MONTH_ALL_ZC+"万");
						//costPie(data.CUR_MONTH_ALL_FC,data.CUR_MONTH_ALL_JL,data.CUR_MONTH_ALL_YJ,data.CUR_MONTH_ALL_ZC);

			}else{
						$("#ml_rate").html('0.00%');
						$("#ml_num").html('0.00');
						$("#sr_num").html('0.00');
						$("#cb_num").html('0.00');
						$("#100new_num").html('0.00');
						$("#100new_income_num").html('0');
						//成本构成
						$("#cb_total").html('0.00');
						$("#cb_fc").html('0.00');
						$("#cb_jl").html('0.00');
						$("#cb_yj").html('0.00');
						$("#cb_zc").html('0.00');
						//costPie(0,0,0,0);
			}
		});
  }
  //发展效益-成本构成pie
	/*var cost_pie = echarts.init(document.getElementById('fzxy_pie'));
	function costPie(sr,jl,yj,zc){
		var cost_option = {
			    title : {
			    	show:false,
			        text: '某站点用户访问来源',
			        subtext: '纯属虚构',
			        x:'center'
			    },
			    tooltip : {
			        trigger: 'item',
			        formatter: "{a} <br/>{b} : {c} ({d}%)"
			    },
			    legend: {
			    	show:false,
			        orient : 'vertical',
			        x : 'left',
			        data:['收入分成','渠道奖励','基础佣金','渠道支撑']
			    },
			    calculable : true,
			    series : [
			        {
			            name:'成本构成',
			            type:'pie',
			            radius: [0, '85%'],
			            center: ['50%', '52%'],
			          label:{
			              normal:{
								show:true,
			                	position:'inner',
			                	formatter:'{b}'+'\n\r'+'{d}%'
			              }
			          },
			            data:[
			                {value:sr, name:'收入分成'},
			                {value:jl, name:'渠道奖励'},
			                {value:yj, name:'基础佣金'},
			                {value:zc, name:'渠道支撑'}
			            ]
			        }
			    ]
			};
		cost_pie.setOption(cost_option);
	}*/
	/*发展质态 柱状图*/

	function ml_trendBar(xMonth,yData){
		//resizeMainContainer(document.getElementById('mltrend_bar'),".c_view_center",c_mltrend_bar,".c_title_com");
		$("#mltrend_bar").height($("#mltrend_bar").parent().height()*0.85);
		//$("#mltrend_bar").width($("#mltrend_bar").parent().width()*0.96);
		var c_mltrend_bar = echarts.init(document.getElementById('mltrend_bar'));
		var option = {
			color: ['#00fff0'],
			grid:{
				bottom: '18%',
				right: '4%',
				top:'15%',
				left:'4%'
			},
			xAxis: {
				type: 'category',
				data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
				axisTick: {
					show: false},
				axisLine: {lineStyle: {color: '#e4e4e4'}},
				axisLabel: {textStyle: {fontSize:12}}
			},
			yAxis: {
				show:false,
				type: 'value',
				splitLine:{show:false},
				axisLine: {
					lineStyle: {color:'#555'}
				}
			},

			series: [{
				data: yData,//[820, 932, 901, 820, 932, 932],
				type: 'bar',
				animation:false,
				barWidth: '16',
				itemStyle: {
					normal: {
						label: {
							show: true,
							position: 'top' ,
							textStyle: {color:'#ffffff',fontSize: '13'},
							formatter:function(obj){
								if(obj.value==0){
									if(obj.name <= '${maxMonth}')
										return "0.0%";
									else
										return "";
								}
								return obj.value+"%";
							}
						}
					}
				}
			}]
		};
		c_mltrend_bar.setOption(option);
	}
    //工具方法
  //获取当前时间，格式YYYY-MM-DD
    function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + month; //+ strDate;
        return currentdate;
    }
	//获取上月
	function getPreMonth(date) {
        //var arr = date.split('-');
        var year = date.substring(0, 4);    //获取当前日期的年份
        var month = date.substring(4, 6);    //获取当前日期的月份

        var year2 = year;
        var month2 = parseInt(month) - 1;
        if (month2 == 0) {
            year2 = parseInt(year2) - 1;
            month2 = 12;
        }
        if (month2 < 10) {
            month2 = '0' + month2;
        }
        var t2 = year2 +""+ month2 ;
        //alert(t2);
        //$("#preMonth").val(t2);
        return t2;
    }
</script>