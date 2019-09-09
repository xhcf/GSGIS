<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<!--获取系统时间 -->
<e:q4o var="sys_date">
	SELECT TO_CHAR(SYSDATE,'YYYYMMDD') DAY_VAL,TO_CHAR(SYSDATE,'YYYY"年"MM"月"') MONTH_VAL FROM DUAL
</e:q4o>
<e:set var="ACCT_DAY">
	${sys_date.DAY_VAL}
</e:set>
<e:set var="ACCT_MONTH">
	${sys_date.MONTH_VAL}
</e:set>
<e:q4l var="mkt_list">
	select ' ' mkt_id,'全部' mkt_name,0 ord from dual
	union all
	SELECT mkt_id,mkt_name,ord FROM
	<e:description>
		edw.tb_dim_send_market@gsedw
	</e:description>
	${gis_user}.tb_dic_gis_market_type
	where mkt_id <> '999'
	order by ord
</e:q4l>
<html>
<head>
	<title>营销标签</title>
	<style>
		.div_show {
			display: block;
		}

		.div_hide {
			display: none;
		}

		.combo-p {
			z-index: 99110001!important;
		}
		#bound_ready_jump{display:none;}
		#follow_info_list a {color:blue;cursor: pointer;}
		.datagrid {height:100%!important;}
		.t_table.summary_day_m_tab {height:52%;}
		.win_full_screen .t_table.summary_day_m_tab {height:69%;}

		#pd_3 tr th:first-child {width:5%;}
		#pd_3 tr th:nth-child(2) {width:27%;}
		#pd_3 tr th:nth-child(3) {width:13%;}
		#pd_3 tr th:nth-child(4) {width:27%;}
		#pd_3 tr th:nth-child(5) {width:13%;}
		#pd_3 tr th:nth-child(6) {width:15%;}

		#follow_info_list tr td:first-child {width:5%;}
		#follow_info_list tr td:nth-child(2) {width:27%;}
		#follow_info_list tr td:nth-child(3) {width:13%;}
		#follow_info_list tr td:nth-child(4) {width:27%;}
		#follow_info_list tr td:nth-child(5) {width:13%;}
		#follow_info_list tr td:nth-child(6) {width:15%;}

		#pd_5 tr th:first-child {width:5%;}
		#pd_5 tr th:nth-child(2) {width:13%;}
		#pd_5 tr th:nth-child(3) {width:12%;}
		#pd_5 tr th:nth-child(4) {width:38%;}
		#pd_5 tr th:nth-child(5) {width:20%;}
		#pd_5 tr th:nth-child(6) {width:12%;}

		#succ_info_list tr td:first-child {width:5%;}
		#succ_info_list tr td:nth-child(2) {width:13%;}
		#succ_info_list tr td:nth-child(3) {width:12%;}
		#succ_info_list tr td:nth-child(4) {width:38%;}
		#succ_info_list tr td:nth-child(5) {width:20%;}
		#succ_info_list tr td:nth-child(6) {width:12%;}

		/*当日派单表头样式*/
		.intraday_head tr th:first-child {width:25%}
		.intraday_head tr th:nth-child(2) {width:15%}
		.intraday_head tr th:nth-child(3) {width:15%}
		.intraday_head tr th:nth-child(4) {width:15%}
		.intraday_head tr th:nth-child(5) {width:15%}
		.intraday_head tr th:nth-child(6) {width:15%}
		/*当日派单表体样式*/
		#wg_summary_month_info_list tr td:first-child {width:25%}
		#wg_summary_month_info_list tr td:nth-child(2) {width:15%}
		#wg_summary_month_info_list tr td:nth-child(3) {width:15%}
		#wg_summary_month_info_list tr td:nth-child(4) {width:15%}
		#wg_summary_month_info_list tr td:nth-child(5) {width:15%}
		#wg_summary_month_info_list tr td:nth-child(6) {width:15%}

		.cond_track {display:none;}
		.tab_accuracy_head span:last-child:after{width:0}
		.WdateDiv .MTitle{background-color:#bdd3ee!important;}
	</style>
	<link href='<e:url value="/pages/telecom_Index/common/css/button.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/pages/telecom_Index/common/js/order_exec.js?version=New Date()"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/tuomin.js?version=New Date()"/>' charset="utf-8"></script>
</head>
<script>
	var begin_scroll = "", seq_num = 0, list_page = 0;
	var tab_index2 = '${param.tab_index2}';
	var grid_id_short = '${param.grid_id_short}';
	var grid_id = '${param.grid_id}';
	var url_yx_grid = "<e:url value='pages/telecom_Index/common/sql/tabData_sandbox_summary_grid_yx.jsp'/>";
	var url_sum_grid = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary_grid.jsp'/>";

	function tabSelectedReset(){
		$("#third_tab > span").eq(0).addClass("active").siblings().removeClass("active");
		$("#intraday_tb > span").eq(0).addClass("active").siblings().removeClass("active");
		$("#track_tb > span").eq(0).addClass("active").siblings().removeClass("active");
		$("#summary_day_left_0 > span").eq(0).addClass("active").siblings().removeClass("active");
		$("#summary_day_left_1 > span").eq(0).addClass("active").siblings().removeClass("active");
		$("#summary_day_left_2 > span").eq(0).addClass("active").siblings().removeClass("active");
	}
	function selectReset(){
		$("#intraday_tb").val("");
		//$("#intraday_tb option:first").attr("selected","selected");
		$("#summary_day_left_0").val("");
		$("#summary_day_left_1").val("");
		$("#summary_day_left_2").val("");
	}
	//下面是标签对应的加载事件
	/* 	function load_jz(){

	 }  */
	function clear_data() {
		begin_scroll = "", seq_num = 0, list_page = 0;
		//趋势日
		$("#qs_summary_day_info_list").empty();
		//网格月
		$("#wg_summary_month_info_list").empty();
		//网格日
		$("#wg_summary_day_info_list").empty();
		$("#dispatch_info_list").empty();
		$("#zhuanpai_info_list").empty();
		$("#yx3_info_list").empty();
		$("#follow_info_list").empty();
		$("#succ_info_list").empty();
	}

	/*-考核统计 start-*/
	//日表单转融
	var flag=0;
	var sence_id='';
	//日表沉默唤醒
	function load_cmhx(){
		flag='3';
		load_tb_d(flag);
	}
	function load_dzr(){
		flag='1';
		load_tb_d(flag);
		// load_tb2(flag);
	}
	//日表协议到期
	function load_hydq(){
		flag=-1;
		load_tb_d(flag);
		//load_tb2(flag);
	}
	//日表全部
	function day_sence_all(){
		flag=0;
		load_tb_d(flag);
	}

	//月表单转融
	var flag=0;
	var sence_id='';
	//月表沉默唤醒
	//月表协议到期

	//执行考核统计日、月表格加载
	function load_tb_d(flag){
		if(flag==1){
			sence_id='10';
		}else if(flag==-1){
			sence_id='11';
		}else if(flag==0){
			sence_id='';
		}else if(flag==3){
			sence_id='12';
		}
		load_day_data(sence_id);
	}

	//时间控件
	function initDateSelect(){
		//检索日
		/*$("#selectDay_intraday").datebox({
			onSelect : function(date){
				var selectDay = $('#selectDay_intraday').datebox('getValue').replace(/-/g, "");
				//加载考核统计-网格日数据
				//load_wgd_data("");
				$("#summary_day_left_1 span").eq(0).click();
			}
		});

		//检索日
		$("#selectDay_intraday").datebox("setValue",'${ACCT_DAY}');*/

		//检索月
		//$("#selectMonth_yx").val('${ACCT_MONTH}');
	}
	//加载考核统计趋势日数据
	function load_day_data(sence_id){
		//record_num();
		var params = {};
		params.flag=sence_id;
		params.grid_id=grid_id;
		params.eaction="marketing_dzr_day";
		var $grid_list = $("#qs_summary_day_info_list");
		$grid_list.empty();
		$.post(url_yx_grid,params, function (data) {
			data = $.parseJSON(data);
			if (data.length == 0 ) {
				$grid_list.append("<tr><td style='text-align:center' colspan=5 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr>";
				if(d.ORDER_DATE=='99')
					newRow += "<td style='width:65px'>累计</td>";
				else
					newRow += "<td style='width:65px'>" + d.ORDER_DATE + "日</td>";
				if(d.TOTAL_COUNT==null || d.TOTAL_COUNT == 'undefined'){
					newRow += "<td style='width:50px'></td>";
				}else{
					newRow += "<td style='width:50px'>" + d.TOTAL_COUNT + "</td>";
				}
				if(d.NUM_1==null || d.NUM_1 == 'undefined'){
					newRow += "<td style='width:65px'></td>";
				}else{
					newRow += "<td style='width:65px'>" + d.NUM_1 + "</td>";
				}
				if(d.RATE_1=="%"){
					newRow += "<td style='width:65px'></td>";
				}else{
					newRow += "<td style='width:65px'><font color='red'>" + d.RATE_1 + "</font></td>";
				}
				if(d.NUM_2==null || d.NUM_2 == 'undefined'){
					newRow += "<td style='width:65px'></td>";
				}else{
					newRow += "<td style='width:65px'>" + d.NUM_2 + "</td>";
				}

				if(d.RATE_2=="%"){
					newRow += "<td style='width:95px'></td>";
				}else{
					newRow += "<td style='width:95px'>" + d.RATE_2 + "</td>";
				}
				newRow +="</tr>";
				$grid_list.append(newRow);
			}
		});
	}

	//趋势(日)加载日、月数据记录条数
	function record_num(){
		var params = {};
		params.grid_id=grid_id;
		params.eaction="marketing_sence_num";
		$.post(url_yx_grid,params, function (data) {
			data = $.parseJSON(data);
			if(data.length>0){
				//全部
				$("#qs_sence_all_day").html("("+((data[0].SUM_NUM==null)?0:data[0].SUM_NUM)+")");
				//单转融
				$("#qs_dzr_day").html("("+((data[0].DR_NUM==null)?0:data[0].DR_NUM)+")");
				//协议到期
				$("#qs_xydq_day").html("("+((data[0].XY_NUM==null)?0:data[0].XY_NUM)+")");
				//沉默唤醒
				$("#qs_cmhx_day").html("("+((data[0].CMHX_NUM==null)?0:data[0].CMHX_NUM)+")");
			}
		})
	}

	//加载考核统计-网格月数据
	function load_wgm_data(sence_id){
		//record_num_wgmonth();
		var params = {};
		params.flag=sence_id;
		params.grid_id=grid_id;
		//账期
		var selectMonth = $('#selectMonth_yx').val().replace("年","").replace("月","");
		params.acct_month=selectMonth;
		params.eaction="marketing_dzr_month";
		var $mon_list = $("#wg_summary_month_info_list");
		$mon_list.empty();

		$.post(url_yx_grid,params, function (data) {
			data = $.parseJSON(data);
			if (data.length == 0 ) {
				$mon_list.append("<tr><td style='text-align:center' colspan=4 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr>";
				newRow += "<td>" +  d.QUYUNAME + "</td>"+
				"<td>" + d.PD_NUM + "</td>"+
				"<td>" + d.ZX_NUM + "</td>"+
				"<td>" + d.ZX_RATE + "</td>"+
				"<td>" + d.CG_NUM + "</td>"+
				"<td>" + d.CG_RATE + "</td></tr>";
				$mon_list.append(newRow);
			}
		});
	}

	//考核统计-网格月
	function record_num_wgmonth(){
		var params = {};
		params.grid_id=grid_id;
		//账期
		var selectMonth = $('#selectMonth_yx').val().replace("年","").replace("月","");
		params.acct_month=selectMonth;
		params.ation = "marketing_sence_month_num";
		$.post(url_yx_grid,params, function (data) {
			data = $.parseJSON(data);
			if(data.length>0){
				//全部
				$("#wg_sence_all_month").html("("+((data[0].SUM_NUM==null)?0:data[0].SUM_NUM)+")");
				//单转融
				$("#wg_dzr_month").html("("+((data[0].DR_NUM==null)?0:data[0].DR_NUM)+")");
				//协议到期
				$("#wg_xydq_month").html("("+((data[0].XY_NUM==null)?0:data[0].XY_NUM)+")");
				//沉默唤醒
				$("#wg_cmhx_month").html("("+((data[0].CMHX_NUM==null)?0:data[0].CMHX_NUM)+")");
			}
		})
	}

	//加载考核统计-网格日数据
	function load_wgd_data(sence_id){
		//record_num_wgday();
		//账期
		var selectDay = $('#selectDay').datebox('getValue').replace(/-/g, "");
		var params = {};
		params.flag=sence_id;
		params.grid_id=grid_id;
		params.acct_day=selectDay;
		params.eaction = "marketing_dzr_wgday";
		var $day_list = $("#wg_summary_day_info_list");
		$day_list.empty();
		$.post(url_yx_grid,params, function (data) {
			data = $.parseJSON(data);
			if (data.length == 0 ) {
				$day_list.append("<tr><td style='text-align:center' colspan=4 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr>";
				newRow += "<td style='width:100px;'>" +  d.QUYUNAME + "</td>"+
				"<td style='width:50px;'>" +  d.PD_NUM + "</td>"+
				"<td style='width:50px;'>" + d.ZX_RATE+
				"<td style='width:50px;'>" + d.CG_RATE + "</td></tr>";
				$day_list.append(newRow);
			}
		});
	}

	//考核统计-网格月
	function record_num_wgday(){
		//账期
		var selectDay = $('#selectDay').datebox('getValue').replace(/-/g, "");
		var params = {};
		params.grid_id=grid_id;
		params.acct_day=selectDay;
		params.eaction = "marketing_sence_wgday_num";
		$.post(url_yx_grid,params, function (data) {
			data = $.parseJSON(data);
			if(data.length>0){
				//全部
				$("#wg_sence_all_day").html("("+((data[0].SUM_NUM==null)?0:data[0].SUM_NUM)+")");
				//单转融
				$("#wg_dzr_day").html("("+((data[0].DR_NUM==null)?0:data[0].DR_NUM)+")");
				//协议到期
				$("#wg_xydq_day").html("("+((data[0].XY_NUM==null)?0:data[0].XY_NUM)+")");
				//沉默唤醒
				$("#wg_cmhx_day").html("("+((data[0].CMHX_NUM==null)?0:data[0].CMHX_NUM)+")");
			}
		})
	}

	/*-考核统计 end-*/

	//网格统计页签
	function showGridSummary(){
		$("#khtj_qsr").hide();
		$("#khtj_wgr").hide();
		$("#khtj_wgy").show();
		load_wgm_data("");
	}

	function initSceneComponent(){
		var mkt_list = ${e:java2json(mkt_list.list)};
		if(mkt_list.length){
			for(var i = 0,l = mkt_list.length;i<l;i++){
				var mkt = mkt_list[i];

				//每日派单
				var span = "";
				span = "<option value='"+mkt.MKT_ID+"'>";
				span += mkt.MKT_NAME;
				//span += "<span id='intraday_cnt_"+mkt.MKT_ID+"'>";
				span += "</option>";
				//span += "</span>";

				$("#intraday_tb").append(span);

				var split_line = "|";
				//趋势日
				var span1 = "";
				if(i > 0)
					span1 += split_line;
				else
					span1 = "场景:";
				span1 = "<option value='"+mkt.MKT_ID+"'>";
				span1 += mkt.MKT_NAME;
				//span1 += "<span id='qs_cnt_"+mkt.MKT_ID+"'>";
				span1 += "</option>";
				//span1 += "</span>";

				$("#summary_day_left_0").append(span1);

				//网格日
				var span2 = "";
				if(i > 0)
					span2 += split_line;
				else
					span2 = "场景:";
				span2 = "<option value='"+mkt.MKT_ID+"'>";
				span2 += mkt.MKT_NAME;
				//span2 += "<span id='wg_day_cnt_"+mkt.MKT_ID+"'>";
				span2 += "</option>";
				//span2 += "</span>";

				$("#summary_day_left_1").append(span2);

				//网格月
				var span3 = "";
				if(i > 0)
					span3 += split_line;
				else
					span3 = "场景:";
				span3 = "<option value='"+mkt.MKT_ID+"'>";
				span3 += mkt.MKT_NAME;
				//span3 += "<span id='wg_mon_cnt_"+mkt.MKT_ID+"'>";
				span3 += "</option>";
				//span3 += "</span>";

				$("#summary_day_left_2").append(span3);
			}
		}else{
			layer.msg("请先添加营销场景");
			return;
		}
	}

	function firstTabSwitch(){
		$("#jz_yw > span").each(function (index) {
			$(this).on("click", function () {
				tabSelectedReset();
				selectReset();
				$(this).addClass("active").siblings().removeClass("active");
				$("#jz_marketing").children().not($(".div_" + index)).hide();
				$(".div_" + index).show();
				if (index == 0) {
					//load_day_data("");
					$("#tab > span").eq(0).click();
				} else if (index == 1) {
					load_yw();
				}
			});
		});
	}

	function secondTabSwitch(){
		$("#tab > span").each(function (index) {
			$(this).on("click", function () {
				tabSelectedReset();
				selectReset();
				$(this).addClass("active").siblings().removeClass("active");
				$("#content1 > div").hide();
				$(".div_0_" + index).show();
				if (index == 0) {
					//模拟点击考勤统计-趋势日
					//$("#third_tab > span").eq(0).click();
					//点考核统计默认打开 网格统计页签
					showGridSummary();
					//数据加载
					//load_day_data("");
				} else if (index == 1) {
					is_zhuanpai = 0;
					load_intraday_data();
				} else if (index == 2) {
					//load_track_data();
					is_zhuanpai = 1;
					load_intraday_data();
				} else if (index == 3) {
					is_zhuanpai = 2;
					load_intraday_data();
					//var succ_flag = 1;
					//load_succ_data(succ_flag);
				} else if(index == 4){
					//is_zhuanpai = 1;
					//load_intraday_data();
				}
			})
		})
	}

	/*-当日派单 start-*/
	//滚动加载 当日派单
	// 绑定事件
	var intraday_sence_id='';
	var intraday_query_text = '';
	var is_zhuanpai = '';
	$(function(){
		//支局名赋值
		$("#sub_name").text(grid_name);
		//时间控件初始化
		initDateSelect();
		showGridSummary();
		//场景控件初始化
		initSceneComponent();
		//第一级页签切换
		firstTabSwitch();
		//第二级页签切换
		secondTabSwitch();
	});

	//场景切换
	function intra_change(){
		if(is_zhuanpai==1){
			load_intraday_data();
		}else if(is_zhuanpai==0){
			if(intradayStatus==0){
				is_zhuanpai = 0;
				load_intraday_data();
			}
			else if(intradayStatus==1)
				load_track_data();
			else if(intradayStatus==2)
				load_succ_data();
		}else if(is_zhuanpai==2){
			load_intraday_data();
		}
	}

	function getParams_intraday(){
		intraday_sence_id = $.trim($("#intraday_tb option:selected").val());
		intraday_query_text = "";
		if(is_zhuanpai==0)
			intraday_query_text = $.trim($("input[name='intraday_yx_query_text']").val());
		else if(is_zhuanpai==1)
			intraday_query_text = $.trim($("input[name='intraday_zhuanpai_query_text']").val());
		else if(is_zhuanpai==2)
			intraday_query_text = $.trim($("input[name='intraday_yx3_query_text']").val());
		return {
			eaction: "marketing_intraday",
			page: list_page,
			"grid_id_short":grid_id_short,
			intraday_sence_id:intraday_sence_id,
			intraday_query_text:intraday_query_text,
			is_zhuanpai:is_zhuanpai
		}
	}

	var load_intraday_data = function (){
		clear_data();
		intradayListScroll(true);
	};
	yx_load_intraday_data_view = load_intraday_data;

	$("#intraday_list_div").scroll(function () {
		var viewH = $(this).height();
		var contentH = $(this).get(0).scrollHeight;
		var scrollTop = $(this).scrollTop();

		if (scrollTop / (contentH - viewH) >= 0.95) {
			if (new Date().getTime() - begin_scroll > 500) {
				++list_page;
				intradayListScroll(false);
			}
			begin_scroll = new Date().getTime();
		}
	});
	$("#zhuanpai_list_div").scroll(function () {
		var viewH = $(this).height();
		var contentH = $(this).get(0).scrollHeight;
		var scrollTop = $(this).scrollTop();

		if (scrollTop / (contentH - viewH) >= 0.95) {
			if (new Date().getTime() - begin_scroll > 500) {
				++list_page;
				intradayListScroll(false);
			}
			begin_scroll = new Date().getTime();
		}
	});

	//加载表格数据
	function intradayListScroll(flag) {
		var $grid_list = "";
		if(is_zhuanpai==0){//营销清单
			$grid_list = $("#dispatch_info_list");
		}else if(is_zhuanpai==1){//转派清单
			$grid_list = $("#zhuanpai_info_list");
		}else if(is_zhuanpai==2){//营销单
			$grid_list = $("#yx3_info_list");
		}
		var count_element = "";
		if(is_zhuanpai==0){
			count_element = $("#intraday_all");
		}else if(is_zhuanpai==1){
			count_element = $("#zhuanpai_all");
		}else if(is_zhuanpai==2){
			count_element = $("#yx3_all");
		}
		var params = getParams_intraday();
		$.post(url_sum_grid, params, function (data) {
			data = $.parseJSON(data);
			if(list_page==0){
				if(data.length)
					count_element.text(data[0].C_NUM);
				else
					count_element.text("0");
			}
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr><td style='width:35'>" + (++seq_num) + "</td>";
				newRow += "<td style='width:210'>" + addr(d.CONTACT_ADDS) + "</td><td style='width:90'><span>"+phoneHide(d.CONTACT_TEL) +"</span></br>"+ d.SERV_NAME + "</td><td style='width:90'><a onclick=\"exec_agent('" + d.PROD_INST_ID + "','" + d.ORDER_ID + "','"+d.ADDRESS_ID+"','',0,1,'"+ d.SCENE_ID_NUM+"','','1','','','"+ d.ACCEPT_TYPE +"')\">" + phoneHide(d.ACC_NBR)
				+ "</a></td><td style='width:210;text-align: left;'><span>【" + d.SCENE_NAME+"】</span></br>"+d.MKT_REASON+"</td><td style='width:35'><a href='javascript:void(0);' onclick=\"exec_agent('" + d.PROD_INST_ID + "','" + d.ORDER_ID + "','"+d.ADDRESS_ID+"','',2,1,'"+ d.SCENE_ID_NUM+"','','1','','','"+ d.ACCEPT_TYPE +"')\">执行</a>";
				if(d.SCENE_ID_NUM=='10' || d.SCENE_ID_NUM=='11' || d.SCENE_ID_NUM=='1491' || d.SCENE_ID_NUM=='999')//20181204装逼用
					newRow += "<a style='display:none;' id=\"crm_"+d.PROD_INST_ID+"\" onclick=\"execute_crm('${sessionScope.UserInfo.EXT30}','"+d.SERV_NAME+"','"+ d.CONTACT_ADDS+"','"+ d.CONTACT_TEL +"','"+ d.ACC_NBR +"','"+ d.SCENE_ID_NUM+"','"+ d.PROD_INST_ID+"','"+ d.MKT_CARCATE_ID+"','"+ d.ACCEPT_TYPE+"','"+ d.CONTACT_CHL_ID +"','"+ d.PROD_OFFER_ID+"','"+d.PROD_OFFER_NAME +"')\">受理</a>";//原本倒数第二个参数 SCENE_ID_CRM
				newRow += "</td></tr>";
				$grid_list.append(newRow);
			}
			if (data.length == 0 && flag) {
				$grid_list.empty();
				$grid_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
		});
	}

	//执行，调用父页面的客户视图
	///1

	/*-当日派单 end-*/

	//执行状态切换
	var intradayStatus = 0;
	function intradayStatusSwitch(){
		intradayStatus = $("#intraday_status_switch option:selected").val();
		$("#unexeced").hide();
		$("#execed").hide();
		$("#succed").hide();
		$(".cond_track").hide();
		if(intradayStatus==0){//未执行
			$("#unexeced").show();
			intraday_sence_id = '';
			load_intraday_data();
		}else if(intradayStatus==1){//已执行（跟踪用户）
			$(".cond_track").show();
			$("#execed").show();
			load_track_data();
		}else if(intradayStatus==2){//成功用户
			$("#succed").show();
			load_succ_data();
		}
	}

	var track_p3 = "";

	/*-跟踪用户 start- 执行结果切换 */
	function getParams_track(){
		intraday_sence_id = $.trim($("#intraday_tb option:selected").val());
		intraday_query_text = $.trim($("input[name='intraday_yx_query_text']").val());
		track_p3 = $.trim($("#track_tb option:selected").val());
		return {
			"page": list_page,
			"grid_id_short":grid_id_short,
			"scene_id":intraday_sence_id,
			"query_text":intraday_query_text,
			"exec_stat":track_p3
		}
	}

	function load_track_data(){
		//track_mun();
		clear_data();
		trackListScroll(true);
	};

	$("#trace_list_div").scroll(function () {
		var viewH = $(this).height();
		var contentH = $(this).get(0).scrollHeight;
		var scrollTop = $(this).scrollTop();

		if (scrollTop / (contentH - viewH) >= 0.95) {
			if (new Date().getTime() - begin_scroll > 500) {
				++list_page;
				trackListScroll(false);
			}
			begin_scroll = new Date().getTime();
		}
	});

	//加载表格数据
	function trackListScroll(flag) {
		var params = getParams_track();
		params.eaction = "marketing_track";
		var $grid_list = $("#follow_info_list");
		$.post(url_sum_grid,params, function (data) {
			data = $.parseJSON(data);
			if(list_page==0){
				if(data.length)
					$("#intraday_all").text(data[0].C_NUM);
				else
					$("#intraday_all").text("0");
			}
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr><td>" + (++seq_num) + "</td>";
				//newRow += "<td style='width:120px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.GRID_NAME + "',this)\" >" + d.GRID_NAME + "</a></td>";
				newRow += "<td style='text-align:left'>" + d.CONTACT_ADDS + "</td><td><span>"
				+"<a onclick=\"exec_agent('" + d.PROD_INST_ID + "','" + d.ORDER_ID + "','"+d.ADDRESS_ID+"','',0,1,'"+ d.SCENE_ID+"','','1','1')\">"+ d.ACC_NBR+"</a>";
				if(d.SCENE_ID_NUM=='10' || d.SCENE_ID_NUM=='11' || d.SCENE_ID_NUM=='1491' || d.SCENE_ID_NUM=='999')////20181204装逼用
					newRow += "<a style='display:none;' id=\"crm_"+d.PROD_INST_ID+"\" onclick=\"execute_crm('${sessionScope.UserInfo.EXT30}','"+d.SERV_NAME+"','"+ d.CONTACT_ADDS+"','"+ d.CONTACT_TEL +"','"+ d.ACC_NBR +"','"+ d.SCENE_ID_NUM+"','"+ d.PROD_INST_ID+"','"+ d.MKT_CARCATE_ID+"','"+ d.ACCEPT_TYPE+"','"+ d.CONTACT_CHL_ID +"','"+ d.PROD_OFFER_ID+"','"+d.PROD_OFFER_NAME +"')\">受理</a>";//原本倒数第二个参数 SCENE_ID_CRM
				newRow += "</span></br>"+d.SERV_NAME+
				"</td><td style='text-align:left'><span>【" +d.MKT_CONTENT + "】</span></br>"+d.MKT_REASON +   "</td><td >"
				+ d.EXEC_TIME + "</td><td >"
				+ d.EXEC_DESC + "</td></tr>";
				$grid_list.append(newRow);
			}
			if (data.length == 0 && flag) {
				$grid_list.empty();
				$grid_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
		});
	}

	//获取根据用户—>有意向、同意办理等记录条数
	function track_mun(){
		var params = getParams_track();
		params.eaction = "track_mun";
		$.post(url_sum_grid,params, function (data) {
			data = $.parseJSON(data);
			if(data.length>0){
				$("#track_mybe").html("("+data[0].EXEC1+")");
				$("#track_agree").html("("+data[0].EXEC2+")");
				$("#track_refuse").html("("+data[0].EXEC3+")");
				$("#track_uncontact").html("("+data[0].EXEC4+")");
			}
		})
	}
	/*-跟踪用户 end-*/
	/*-成功用户 start-*/
	function load_succ_data(){
		clear_data();
		succListScroll(true);
	};

	function getParams_succ(){
		intraday_sence_id = $.trim($("#intraday_tb option:selected").val());
		intraday_query_text = $.trim($("input[name='intraday_yx_query_text']").val());
		return {
			eaction: "marketing_succ",
			page: list_page,
			"grid_id_short":grid_id_short,
			"scene_id":intraday_sence_id,
			"query_text":intraday_query_text,
			succ_flag: 1
		}
	}

	$("#succ_list_div").scroll(function () {
		var viewH = $(this).height();
		var contentH = $(this).get(0).scrollHeight;
		var scrollTop = $(this).scrollTop();

		if (scrollTop / (contentH - viewH) >= 0.95) {
			if (new Date().getTime() - begin_scroll > 500) {
				++list_page;
				succListScroll(false);
			}
			begin_scroll = new Date().getTime();
		}
	});

	//加载表格数据
	function succListScroll(flag) {
		var params = getParams_succ();
		var $grid_list = $("#succ_info_list");
		$.post(url_sum_grid, params, function (data) {
			data = $.parseJSON(data);
			if(list_page==0){
				if(data.length)
					$("#intraday_all").text(data[0].C_NUM);
				else
					$("#intraday_all").text("0");
			}
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr><td>" + (++seq_num) + "</td>";
				//newRow += "<td style='width:120px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.GRID_NAME + "',this)\" >" + d.GRID_NAME + "</a></td>";
				newRow += "<td>" +  d.ACC_NBR +
					//"</td><td>" + d.CONTACT_CONTPERSON +
				"</td><td>" + d.SERV_NAME +
				"</td><td style='text-align:left'><span>【" + d.MKT_CONTENT +"】</span></br>"+d.MKT_REASON+
				"</td><td>" + d.SUCC_BUSINESS  +
				"</td><td>" + d.SUCC_TIME +
				"</td></tr>";
				$grid_list.append(newRow);
			}
			if (data.length == 0 && flag) {
				$grid_list.empty();
				$grid_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
		});
	}

	//获取成功用户数
	/*-成功用户 end-*/

	//异网营销 异网预警
	function load_yw() {
		$("#marketing_warning_info_list").empty();
		var params = {
			eaction: "marketing_warning",
			page: 0
		}
		clear_data();
		warningListScroll(params, 1);
		params.eaction = "marketing_warning_count";
		$.post(url_sum_grid, params, function (data) {
			if (data != null && data.trim() != 'null') {
				data = $.parseJSON(data);
				$("#marketing_warning_count").html( data[0].C_NUM );
			} else {
				$("#marketing_warning_count").html("(0)");
			}
		})
	}

	function warningListScroll(params, flag) {
		var $grid_list = $("#marketing_warning_info_list");
		$.post(url_sum_grid, params, function (data) {
			data = $.parseJSON(data);
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
				newRow += "<td style='width: 50px'>" + d.CONTACT_PERSON + "</td><td style='width: 200px;text-align:left;'>" + d.STAND_NAME_2 +
				"</td><td style='width: 50px'>" + d.KD_BUSINESS +"</td><td style='width:100px'>" + d.CONTACT_NBR + "</td><td style='width:80px'>"+ d.KD_DQ_DATE + "</td>";
				//newRow += "<td style='width: 50px'><a href='javascript:void(0);' onclick='execute(" + d.SEGM_ID_2 + ")'>执行</a></td></tr>"
				newRow += "<td style='width: 50px'><a href='javascript:void(0);' onclick='execute(" + d.SEGM_ID_2 + ")'></a></td></tr>"
				$grid_list.append(newRow);
			}
			if (data.length == 0 && flag) {
				$grid_list.empty();
				$grid_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
		});
	}

	var UTFTranslate = {
		Change:function(pValue){
			return pValue.replace(/[^\u0000-\u00FF]/g,function($0){return escape($0).replace(/(%u)(\w{4})/gi,"&#x$2;")});
		},
		ReChange:function(pValue){
			return unescape(pValue.replace(/&#x/g,'%u').replace(/\\u/g,'%u').replace(/;/g,''));
		}
	};

	//var url1 = 'http://135.149.64.146:9004/gsch-api/mkt/getBindAccount';
	var url_prefix = "http://135.149.64.144:9000/gsch-api";
	var url1 = "/mkt/getBindAccount";
	var cust_name = "";
	var cust_addr = "";
	var contact_num = "";
	var acc_nbr = "";
	var prod_inst_id = "";
	var mktCamCateId = "";
	var isSupportAccept = "";
	var contact_chl_id = "";
	var contact_chl_name = "";
	var prod_offer_id = "";
	var prod_offer_name = "";
	var scene_id = "";
	var crm_bind_win = "";
	var crm_id = "";
	var bound_ready_jump_win = "";

	var exec_view_exe_small_interface = "";//20190311 营销逻辑修改 先跳转后执行
	var yx_exec_params = "";//20190311 营销逻辑修改 先跳转后执行

	function call_execute(element_id){
		$("#crm_"+element_id).click();//方法 execute_crm
	}
	parent.call_execute_new_cust_view = call_execute;
	//crm跳转 需要传所有用到的参数（甩单接口中的参数），给crm_jump_page使用
	///3

	function closeCrmBindWin(){
		layer.close(crm_bind_win);
	}
	function closeCrmJumpWin(){
		layer.close(bound_ready_jump_win);
	}

	function day0(){
		console.log("day0");
		var sence_id = $.trim($("#summary_day_left_0 option:selected").val());
		load_day_data(sence_id);
	}

	function day1(){
		console.log("day1");
		var sence_id = $.trim($("#summary_day_left_1 option:selected").val());
		load_wgd_data(sence_id);
	}

	function day2(){
		console.log("day2");
		var sence_id = $.trim($("#summary_day_left_2 option:selected").val());
		load_wgm_data(sence_id);
	}
</script>
<body>
<div id="sub_name" class="sub_summary_div_name"></div>

<div class="tab_head" id="jz_yw">
	<span class="active">精准营销</span> <span>异网预警</span>
</div>

<div class="tab_body" id="jz_marketing">
	<div class="div_show div_0">
		<!--精准营销标签页内容 -->
		<div class="tab_accuracy_head tab_accuracy_other yx_submenu" id="tab" style="padding-left:14px;">
			<span class="active">考核统计</span>  <span> 营销清单 </span> &nbsp;<span> 转派清单 </span>&nbsp;<span> 营销单 </span>
		</div>
		<div id="content1">
			<div class="div_show div_0_0" >
				<!--考核统计标签页内容--网格(月)-->
				<div class="summary_day_data" id ="khtj_wgy" style ="display:none">
					<div class="summary_day_head summary_day_head_other">
						<span style="float:left;">场景:</span>
						<select class="summary_day_left" id="summary_day_left_2" onchange="day2()"><!--场景:
		             <span class="active">全部<span id="wg_sence_all_month"></span></span>
			         | <span >单转融<span id="wg_dzr_month">(0)</span></span>
			         |<span>协议到期<span id="wg_xydq_month">(0)</span></span>
			         |<span>沉默唤醒<span id="wg_cmhx_month">(0)</span></span>-->
						</select><!-- p -->
						<input id="selectMonth_yx" type="text" value="${ACCT_MONTH}" style="width:150px;float:right;" onclick="WdatePicker({dateFmt:'yyyy年MM月',onpicked:function(){showGridSummary()}})" class="Wdate" />
					</div>

					<div class="datagrid">
						<div class="head_table_wrapper">
							<table class="head_table intraday_head">
								<tr>
									<th>区域</th>
									<th>派单数</th>
									<th>执行数</th>
									<th>执行率</th>
									<th>成功数</th>
									<th>成功率</th>
								</tr>
							</table>
						</div>
						<div class="t_table summary_day_m_tab" style="margin:0 auto;">
							<table class="content_table summary_yx_tab" id="wg_summary_month_info_list" style="width:100%;margin:0px auto;">
							</table>
						</div>
					</div>
				</div>

			</div>
			<div class="div_hide div_0_1">
				<!--当日派单标签页内容 -->
				<div class="dispatch_head">
                <span style="padding-left:10px;">
					<!--账期：<input id="selectDay_intraday" type="text" style="color:#ffffff; width:150px;" />&nbsp;&nbsp;-->
					<span class="cond_no_zhuanpai">场景:&nbsp;&nbsp;</span><select class="radio tab_accuracy_other yx_submenu cond_no_zhuanpai" id="intraday_tb" style="padding-left:0px;" onchange="intra_change()"></select>&nbsp;&nbsp;
					<span>状态:&nbsp;&nbsp;</span><select id="intraday_status_switch" onchange="intradayStatusSwitch()"><option value="0">未执行</option><option value="1">已执行</option><option value="2">成功</option></select>&nbsp;&nbsp;
					<span class="cond_track">结果:&nbsp;&nbsp;</span><select id="track_tb" onchange="load_track_data()" class="cond_track"><option value="">全部</option><option value="1">有意向</option><option value="2">同意办理</option><option value="3">不需要</option><option value="4">无法联系</option></select>&nbsp;&nbsp;
					<span class="">查询:&nbsp;&nbsp;</span><input style="background-color: #fff;" placeholder="请输入用户名或号码" type="text" name="intraday_yx_query_text" /><input class="btn blue_btn" type="button" value="查询" onclick="javascript:intra_change()" />
                </span>
				<span style="text-align:right;margin-right:4%;float:right;margin-top:5px;" id="intraday_all_div">记录数：<span id="intraday_all"></span></span>
				</div>
				<!-- 未执行 -->
				<div class="datagrid" id="unexeced">
					<div class="head_table_wrapper">
						<table class="head_table">
							<tr>
								<th width="35">序号</th>
								<th width="210">详细地址</th>
								<th width="90">联系人</th>
								<th width="90">接入号码</th>
								<th width="210">营销场景</th>
								<th width="35">操作</th>
							</tr>
						</table>
					</div>
					<div class="t_table dispatch_m_tab" style="margin:0px auto;" id="intraday_list_div">
						<table class="content_table dispatch_detail_in" id="dispatch_info_list" style="width:100%;">
						</table>
					</div>
				</div>
				<!-- 已执行 -->
				<div id="execed">
					<!--跟踪用户标签页内容 -->
					<div class="datagrid">
						<div class="head_table_wrapper">
							<table class="head_table" id="pd_3">
								<tr>
									<th>序号</th>
									<th>详细地址</th>
									<th>联系人</th>
									<th>派单内容</th>
									<th>执行时间</th>
									<th>备注</th>
								</tr>
							</table>
						</div>
						<div class="t_table follow_m_tab" style="margin:0 auto;" id="trace_list_div">
							<table class="content_table follow_detail_in" id="follow_info_list" style="width:100%;">
							</table>
						</div>
					</div>
				</div>

				<div id="succed">
					<!-- 成功 -->
					<!-- 成功用户标签页 -->
					<div class="datagrid">
						<div class="head_table_wrapper">
							<table class="head_table" id="pd_5">
								<tr>
									<th>序号</th>
									<th>号码</th>
									<th>姓名</th>
									<th>派单内容</th>
									<th>订购业务</th>
									<th>订购时间</th>
								</tr>
							</table>
						</div>
						<div class="t_table succ_m_tab" style="margin:0px auto;" id="succ_list_div">
							<table class="content_table succ_detail_in" id="succ_info_list" style="width:100%;">
							</table>
						</div>
					</div>
				</div>

			</div>
			<!-- 转派清单 -->
			<div class="div_hide div_0_2">
				<div class="dispatch_head">
                	<span style="padding-left:10px;">
						<!--账期：<input id="selectDay_intraday" type="text" style="color:#ffffff; width:150px;" />&nbsp;&nbsp;-->
						<span>查询:&nbsp;&nbsp;</span><input style="background-color: #fff;" placeholder="请输入用户名或号码" type="text" name="intraday_zhuanpai_query_text" /><input class="btn blue_btn" type="button" value="查询" onclick="javascript:intra_change()" />
                	</span>
					<span style="text-align:right;margin-right:4%;float:right;margin-top:5px;" id="zhuanpai_all_div">记录数：<span id="zhuanpai_all"></span></span>
				</div>
				<div class="datagrid">
					<div class="head_table_wrapper">
						<table class="head_table">
							<tr>
								<th width="35">序号</th>
								<th width="210">详细地址</th>
								<th width="90">联系人</th>
								<th width="90">接入号码</th>
								<th width="210">营销场景</th>
								<th width="35">操作</th>
							</tr>
						</table>
					</div>
					<div class="t_table dispatch_m_tab" style="margin:0px auto;" id="zhuanpai_list_div">
						<table class="content_table dispatch_detail_in" id="zhuanpai_info_list" style="width:100%;">
						</table>
					</div>
				</div>
			</div>
			<div class="div_hide div_0_3">
				<div class="dispatch_head">
                	<span style="padding-left:10px;">
						<!--账期：<input id="selectDay_intraday" type="text" style="color:#ffffff; width:150px;" />&nbsp;&nbsp;-->
						<span>查询:&nbsp;&nbsp;</span><input style="background-color: #fff;" placeholder="请输入用户名或号码" type="text" name="intraday_yx3_query_text" /><input class="btn blue_btn" type="button" value="查询" onclick="javascript:intra_change()" />
                	</span>
					<span style="text-align:right;margin-right:4%;float:right;margin-top:5px;" id="_all_div">记录数：<span id="yx3_all"></span></span>
				</div>
				<div class="datagrid">
					<div class="head_table_wrapper">
						<table class="head_table">
							<tr>
								<th width="35">序号</th>
								<th width="210">详细地址</th>
								<th width="90">联系人</th>
								<th width="90">接入号码</th>
								<th width="210">营销场景</th>
								<th width="35">操作</th>
							</tr>
						</table>
					</div>
					<div class="t_table dispatch_m_tab" style="margin:0px auto;" id="yx3_list_div">
						<table class="content_table dispatch_detail_in" id="yx3_info_list" style="width:100%;">
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="div_hide div_1">
		<p class="grid_count_title">记录数:<span id="marketing_warning_count">(0)</span></p>
		<div class="datagrid">
			<div class="head_table_wrapper">
				<table class="head_table">
					<tr>
						<th width="40">序号</th>
						<th width="50">客户名称</th>
						<th width="200">详细地址</th>
						<th width="50">运营商</th>
						<th width="100">联系方式</th>
						<th width="80">到期时间</th>
						<th width="50">操作</th>
					</tr>
				</table>
			</div>
			<div class="t_table warning_m_tab" style="margin:0px auto;height:291px;">
				<table class="content_table warning_detail_in" id="marketing_warning_info_list" style="width:100%;">
				</table>
			</div>
		</div>
	</div>
</div>