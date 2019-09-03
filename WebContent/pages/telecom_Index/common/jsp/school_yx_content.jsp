<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="scene_list">
	select mkt_id CODE,mkt_name TEXT from ${gis_user}.tb_hdz_dic_market_info order by mkt_name
</e:q4l>
<e:q4l var="yx_list">
	select dd.segm_id CODE,dd.stand_name TEXT
	from ${gis_user}.TB_GIS_VILLAGE_ADDR4 ff,
		 sde.TB_GIS_MAP_SEGM_LATN_MON dd
	where ff.segm_id = dd.segm_id
	and ff.village_id='${param.village_id}'
	order by TEXT
</e:q4l>
<head>
	<title>营销清单</title>
	<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/school_workspench.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" />
    <style>
        #select_tab2,#content2{
            display:none;
        }
        .yx_tab_switch{width:100%;border-bottom: 1px solid #aaa;padding-bottom:3px;padding-left:5px;margin-top:5px;}
        .yx_tab_switch span {margin-right:5px;width:10%;border-top:1px solid #aaa;border-right:1px solid #aaa;border-left:1px solid #aaa;border-radius: 5px 5px 0px 0px;display:inline-block;text-align:center;cursor:pointer;}
        #select_tab1,#select_tab2{
            width:96%;
            margin:0px auto;
        }
		span.active {background: #003299!important;color:#fff!important;}
		#yx_list_div{display:none;}
		.head_table_gray {width:100%;padding-right:17px;}
		.head_table_gray tr{
			background: #d9d9d9;
		}
		.head_table_gray tr th{
			border: 1px solid #fff;
		}
		.content_table_gray{
			width:100%;
			border-spacing: 2px;
			border-color: grey;
		}

		/*场景营销*/
		.tab_header tr th:first-child {width:5%!important;}
		.tab_header tr th:nth-child(2) {width:15%!important;}
		.tab_header tr th:nth-child(3) {width:35%!important;}
		.tab_header tr th:nth-child(4) {width:10%!important;}
		.tab_header tr th:nth-child(5) {width:27%!important;}
		.tab_header tr th:nth-child(6) {width:8%!important;}

		#collect_new_bulid_info_list_sj tr td:first-child {width:5%!important;}
		#collect_new_bulid_info_list_sj tr td:nth-child(2) {width:15%!important;}
		#collect_new_bulid_info_list_sj tr td:nth-child(3) {width:35%!important;text-align:left!important;}
		#collect_new_bulid_info_list_sj tr td:nth-child(4) {width:10%!important;}
		#collect_new_bulid_info_list_sj tr td:nth-child(5) {width:27%!important;text-align:left!important;}
		#collect_new_bulid_info_list_sj tr td:nth-child(6) {width:8%!important;}

		.sum_div{
			height:25px;
			line-height: 25px;
			vertical-align: middle;
			padding-left:15px;
		}
		.sum_div span {color:red;}
		.link {text-decoration: underline!important;}

		.inside_data_orange {
			text-align: center!important;
		}

		/*控件样式*/
		.collect_contain_choice div {width:12%;} .collect_contain_choice select {width:30%;}
    </style>
	<link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/school_workspench.css?version=1.5"/>'
		  rel="stylesheet" type="text/css" media="all"/>
</head>
<body>
    <!--营销清单----------20180412------------- 开始---------------------->
    <div class="village_new_searchbar">
        <table style="width:100%">
            <tr>
                <td>
                    <div class="count_num desk_orange_bar inside_data inside_data_orange">
                        <%--营销场景：<span id="head_scene_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        目标用户：<span id="head_target_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        执行用户：<span id="head_exec_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        成功用户：<span id="head_succ_num" style="color:#FF0000">0</span>--%>
						营销目标数：<span id="yx_sum_01" style="color:#FF0000"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						执行数：<span id="yx_sum_02" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						执行率：<span id="yx_sum_03" style="color:#FF0000">0</span>
						成功数：<span id="yx_sum_04" style="color:#FF0000"></span>
						成功率：<span id="yx_sum_05" style="color:#FF0000"></span>
                    </div>
                </td>
            </tr>
			<tr>
				<td>
					<div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
						<div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
							<div style="width:8%;">营销场景：</div><select id="yx_comp_01" style="width:16%;"></select>
							<div style="text-align: center;width:8%;">楼宇：</div><select id="yx_comp_02" style="width:65%;"></select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
						<div class="collect_contain_choice cnt_div" style="margin:0px auto;width: 95%;float:none;">
							状态：<b>全部(<span id="yx_cnt_01" type=""></span>)</b>&nbsp;|&nbsp;
							<b>未执行(<span id="yx_cnt_02" type="1"></span>)</b>&nbsp;|&nbsp;
							<b>已执行(<span id="yx_cnt_03" type="2"></span>)</b>&nbsp;|&nbsp;
							<b>已成功(<span id="yx_cnt_04" type="3"></span>)</b>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<span>
						<div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" id="res_tb">
							记录数：
							<span id="recode_cnt"></span>
						</div>
					</span>
				</td>
			</tr>
        </table>
	</div>
	<div style="width:96%;margin:0px auto;">
		<div class="head_table_wrapper">
			<table class="head_table tab_header" cellspacing="0" cellpadding="0">
				<tr>
					<th>序号</th>
					<th>用户</th>
					<th>联系地址</th>
					<th>营销场景</th>
					<th>营销术语</th>
					<th>执行状态</th>
				</tr>
			</table>
		</div>
		<div id="collect_new_table_content" class="t_table">
			<table cellspacing="0" cellpadding="0" class="content_table tab_body" id="collect_new_bulid_info_list_sj" style="width: 100%"></table>
		</div>
	</div>
</body>

<script type="text/javascript">
	var url4sql = "<e:url value='/pages/telecom_Index/common/sql/tabData_enterprise.jsp' />";
	var type1 = 1;//营销场景
	var type2 = "";//楼宇
	var type3 = "";//场景
	var begin = 0,end = 0,seq_num = 0,page = 0;

	var sum01 = "#yx_sum_01";
	var sum02 = "#yx_sum_02";
	var sum03 = "#yx_sum_03";
	var sum04 = "#yx_sum_04";
	var sum05 = "#yx_sum_05";

	var cnt_div = ".cnt_div";
	var cnt01 = "#yx_cnt_01";
	var cnt02 = "#yx_cnt_02";
	var cnt03 = "#yx_cnt_03";
	var cnt04 = "#yx_cnt_04";

	var comp01 = "#yx_comp_01";
	var comp02 = "#yx_comp_02";

	var tab_head = "";
	var tab_body = "#collect_new_bulid_info_list_sj";

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
		$(sum05).text();
	}
	function init_comp(){
		/*场景*/
		$(comp01).append("<option value=\"1\">全部</option>");
		$(comp01).append("<option value=\"2\">场景1</option>");
		$(comp01).append("<option value=\"3\">场景2</option>");

		$(comp01).on("change",function(){
			type1 = $(comp01+" option:selected").val();
			clear();
			fresh_cnt();
			get_list(true);
		});

		/*楼宇*/
		addBuild(comp02);

		$(comp02).on("change",function(){
			type2 = $(comp02+" option:selected").val();
			clear();
			fresh_cnt();
			get_list(true);
		});

		$(cnt_div+" b").eq(0).addClass("active");
		$(cnt_div+" b").click(function(){
			$(this).addClass("active").siblings().removeClass("active");
			type3 = $(this).children("span").attr("type");
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

	/*function freshBuild(){
		$(comp02).empty();
	}*/

	var default_option = "<option value=\"\">全部</option>";
	function addBuild(target){
		$(target).append(default_option);
		$.post(url4sql,{"eaction":"getBuildInsideSchoolOrEnterprise","village_id":business_id,"area_type":2},function(data){
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
			"eaction":"getYxInfo",
			"business_id":business_id,
			"scene":type1,
			"resid":type2,
			"status":type3,
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
				"<td><a href=\"javascript:void(0);\" onclick=\"parent.openNewWinInfoCollectEdit('000102140000000017157466')\">"+item.USER_NAME+"</a></td>"+
				"<td>"+item.ADDRESS+"</td>"+
				"<td>"+item.SCENE+"</td>"+
				"<td>"+item.SCRIPT+"</td>"+
				"<td>"+item.STATUS+"</td>"+
				"</tr>");
			});
		});
	}

	function fresh(){
		clear();
		//freshBuild();
		get_list(true);
	}
	function clear(){
		begin = 0,end = 0,seq_num = 0,page = 0;
		$(tab_body).empty();
	}
</script>