<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="yhzt_list">
	select dd.segm_id CODE,dd.stand_name TEXT
	from gis_data.TB_GIS_VILLAGE_ADDR4 ff,
		 sde.TB_GIS_MAP_SEGM_LATN_MON dd
	where ff.segm_id = dd.segm_id
	and ff.village_id='${param.village_id}'
	order by TEXT
</e:q4l>
<e:q4o var="last_month">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>
<head>
	<title>异常用户 流失用户</title>
	<link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/school_workspench.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" />
	<style>
		.tip {
			margin-left:18px;
			margin-top:5px;
			display:none;
		}
		.center {text-align:center!important;padding-left:0px!important;color:#328ECE;}
		.important {color:#2E40E7;}
		.bold_blue a{font-weight: normal;text-decoration: underline;}
		.layui-layer-title {text-align: center;padding:0px;}
		.yhzt_exec_tab_body{height:56%;}
		.toViewWin span {
			text-decoration: underline;
			cursor:pointer;
			color:blue;
		}
		.radio span{padding:0 8px;}

		.layui-layer-setwin{top:5px;}
		.layui-layer-setwin .layui-layer-close1{background-position:0px -38px;}
		#sum_record {cursor:default;color:#f00;}
		#sum_record:hover {color:#f00;}

		/*表头 表体*/
		.tab_header tr th:first-child {width:5%!important;}
		.tab_header tr th:nth-child(2) {width:33%!important;}
		.tab_header tr th:nth-child(3) {width:8%!important;}
		.tab_header tr th:nth-child(4) {width:13%!important;}
		.tab_header tr th:nth-child(5) {width:13%!important;}
		.tab_header tr th:nth-child(6) {width:10%!important;}
		.tab_header tr th:nth-child(7) {width:12%!important;}
		.tab_header tr th:nth-child(8) {width:10%!important;}

		#village_view_build_listByYhzt {width:100%;}

		#village_view_build_listByYhzt tr td:first-child {width:5%!important;}
		#village_view_build_listByYhzt tr td:nth-child(2) {width:33%!important;text-align:left!important;}
		#village_view_build_listByYhzt tr td:nth-child(3) {width:8%!important;text-align:center!important;}
		#village_view_build_listByYhzt tr td:nth-child(4) {width:13%!important;}
		#village_view_build_listByYhzt tr td:nth-child(5) {width:13%!important;}
		#village_view_build_listByYhzt tr td:nth-child(6) {width:10%!important;}
		#village_view_build_listByYhzt tr td:nth-child(7) {width:12%!important;}
		#village_view_build_listByYhzt tr td:nth-child(8) {width:10%!important;}

		.inside_data_orange {
			text-align: center!important;
		}

		span .deny_span {
			color:#aaa;
			cursor:not-allowed;
		}
		b {font-size:12px;font-weight: normal;color:#666;}
	</style>
	<link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/school_workspench.css?version=1.5"/>'
		  rel="stylesheet" type="text/css" media="all"/>
</head>
<body>
    <a href="#" id="lsyh_win" style="display: none;position: absolute;right:28px;top:80px;">流失用户</a>
	<!----------------------------用户质态----------20180414------------- 开始---------------------->
	<div class="village_new_searchbar">
		<table style="width:100%">
			<tr>
				<td>
					<div class="count_num desk_orange_bar inside_data inside_data_orange">
						<%--营销场景：<span id="head_scene_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        目标用户：<span id="head_target_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        执行用户：<span id="head_exec_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        成功用户：<span id="head_succ_num" style="color:#FF0000">0</span>--%>
						流失数：<span id="lost_sum_01" style="color:#FF0000"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						其中&emsp;不出账<span id="lost_sum_02" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						欠费：<span id="lost_sum_03" style="color:#FF0000">0</span>
						沉默：<span id="lost_sum_04" style="color:#FF0000"></span>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
						<div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
							<div style="width:8%;">新生公寓：</div><select id="lost_comp_01" style="width:16%;"></select>
							<div style="width:8%;text-align: center;">男女公寓：</div><select id="lost_comp_02" style="width:16%;"></select>
							<div style="width:8%;text-align: center;">楼宇：</div><select id="lost_comp_03" style="width:43%;"></select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
						<div class="collect_contain_choice cnt_div" style="margin:0px auto;width: 95%;float:none;">
							流失状态：<b>全部(<span id="lost_cnt_01" type=""></span>)</b>&nbsp;|&nbsp;
							<b>不出账(<span id="lost_cnt_02" type="1"></span>)</b>&nbsp;|&nbsp;
							<b>欠费(<span id="lost_cnt_03" type="2"></span>)</b>&nbsp;|&nbsp;
							<b>沉默(<span id="lost_cnt_04" type="3"></span>)</b>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>

	<div style="width: 96%;margin:0 auto;">
		<div class="head_table_wrapper">
			<table class="head_table tab_header" cellspacing="0" cellpadding="0">
				<tr>
					<th>序号</th>
					<th>详细地址</th>
					<th>床位</th>
					<th>院系</th>
					<th>年级</th>
					<th>联系人</th>
					<th>流失日期</th>
					<th>状态</th>
				</tr>
			</table>
		</div>
		<!--表体-->
		<div class="yhzt_exec_tab_body t_table" style="padding-right:0px;">
			<table cellspacing="0" cellpadding="0" class="content_table tab_body" id="village_view_build_listByYhzt">
			</table>
		</div>
	</div>

	<%--<div class="tip">
		<span style="font-weight: bold;">拆机：</span>指本年的光宽拆机用户数；<span style="font-weight: bold;">停机：</span>指本年该用户为计费用户，但状态为停机的光宽用户数；<br/>
		<span style="font-weight: bold;">沉默：</span>指本年该用户为计费用户，但近三个月连续沉默的非欠费未停机光宽用户数；
	</div>--%>
	<div id="lsyh_div" style="display:none;">-----</div>
	<!------------------------------用户质态----------20180414------------- 结束---------------------->
</body>
<script type="text/javascript">
	var url4sql = "<e:url value='/pages/telecom_Index/common/sql/tabData_enterprise.jsp' />";
	var type1 = 1;//营销场景
	var type2 = "";//楼宇
	var type3 = "";//场景
	var type4 = "";//流失状态
	var begin = 0,end = 0,seq_num = 0,page = 0;

	var sum01 = "#lost_sum_01";
	var sum02 = "#lost_sum_02";
	var sum03 = "#lost_sum_03";
	var sum04 = "#lost_sum_04";

	var cnt_div = ".cnt_div";
	var cnt01 = "#lost_cnt_01";
	var cnt02 = "#lost_cnt_02";
	var cnt03 = "#lost_cnt_03";
	var cnt04 = "#lost_cnt_04";

	var comp01 = "#lost_comp_01";
	var comp02 = "#lost_comp_02";
	var comp03 = "#lost_comp_03";

	var tab_head = "";
	var tab_body = "#village_view_build_listByYhzt";

	$(function(){
		get_summary();
		init_comp();
		fresh_cnt();
		get_list(true);
	});
	function get_summary(){
		$(sum01).text();
		$(sum02).text();
		$(sum03).text();
		$(sum04).text();
	}
	function init_comp(){
		/*是否新生公寓*/
		$(comp01).append("<option value=\"\">全部</option>");
		$(comp01).append("<option value=\"1\">是</option>");
		$(comp01).append("<option value=\"0\">否</option>");

		$(comp01).on("change",function(){
			type1 = $(comp01+" option:selected").val();
			fresh_cnt();
			fresh();
		});

		/*男女公寓*/
		$(comp02).append("<option value=\"\">全部</option>");
		$(comp02).append("<option value=\"2\">女生公寓</option>");
		$(comp02).append("<option value=\"1\">男生公寓</option>");
		$(comp02).append("<option value=\"3\">其他</option>");

		$(comp02).on("change",function(){
			type2 = $(comp02+" option:selected").val();
			fresh_cnt();
			fresh();
		});

		/*楼宇*/
		addBuild("","",comp03);

		$(comp03).on("change",function(){
			type3 = $(comp03+" option:selected").val();
			clear();
			fresh_cnt();
			get_list(true);
		});

		$(cnt_div+" b").eq(0).addClass("active");
		$(cnt_div+" b").click(function(){
			$(this).addClass("active").siblings().removeClass("active");
			type4 = $(this).children("span").attr("type");
			clear();
			get_list(true);
		});

		$(".tab_scroll").scroll(function () {
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - begin > 500) {
					get_list(false);
				}
				begin = new Date().getTime();
			}
		});
	}

	function freshBuild(){
		$(comp03).empty();
		addBuild(type1,type2,comp03);
	}

	var default_option = "<option value=\"\">全部</option>";
	function addBuild(type1,type2,target){
		$(target).append(default_option);
		$.post(url4sql,{"eaction":"getBuildInsideSchoolOrEnterprise","village_id":business_id,"area_type":2,"is_new":type1,"sex":type2},function(data){
			var data = $.parseJSON(data);
			$.each(data,function(index,item){
				$(target).append("<option value=\""+item.SEGM_ID+"\">"+item.STAND_NAME+"</option>");
			});
		});
	}

	function fresh_cnt(){
		$(cnt01).text("0");
		$(cnt02).text("0");
		$(cnt03).text("0");
		$(cnt04).text("0");
	}

	function getParams(){
		return {
			"eaction":"getLostInfo",
			"business_id":business_id,
			"is_new":type1,
			"sex":type2,
			"resid":type3,
			"status":type4,
			"page":page
		};
	}

	var fill_empty = true;
	function get_list(flag){
		var params = getParams();
		var target = tab_body;
		$.post(url4sql,params,function(data){
			var data = $.parseJSON(data);
			if(page==0){
				if(data.length){
					$("#recode_cnt").text(data[0].C_NUM);
				}else{
					$("#recode_cnt").text("0");
				}
			}
			if(!data.length && flag){
				if(fill_empty){
					for(var i = 0,l=8;i<l;i++){
						$(target).append("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
					}
				}else{
					$(target).append("<tr><td colspan='9'>未查询到结果</td></tr>");
				}
			}
			$.each(data,function(index,item){
				$(target).append("<tr><td>"+(++seq_num)+"</td>"+
				"<td>"+item.ADDRESS+"</td>"+
				"<td>"+item.BED_NO+"</td>"+
				"<td>"+item.COLLEGE_NAME+"</td>"+
				"<td>"+item.GRADE_NAME+"</td>"+
				"<td>"+item.USER_NAME+"<br/>"+item.TEL+"</td>"+
				"<td>"+item.LOST_DATE+"</td>"+
				"<td>"+item.STATUS+"</td>"+
				"</tr>");
			});
		});
	}

	function fresh(){
		clear();
		freshBuild();
		get_list(true);
	}
	function clear(){
		begin = 0,end = 0,seq_num = 0,page = 0;
		$(tab_body).empty();
	}
</script>