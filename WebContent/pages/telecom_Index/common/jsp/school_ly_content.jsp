<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<html>
<head>
	<title>楼宇清单</title>
	<style type="text/css">
		.tab_header tr th:first-child {width:5%!important;}
		.tab_header tr th:nth-child(2) {width:35%!important;}
		.tab_header tr th:nth-child(3) {width:8%!important;}
		.tab_header tr th:nth-child(4) {width:8%!important;}
		.tab_header tr th:nth-child(5) {width:8%!important;}
		.tab_header tr th:nth-child(6) {width:8%!important;}
		.tab_header tr th:nth-child(7) {width:8%!important;}
		.tab_header tr th:nth-child(8) {width:8%!important;}
		.tab_header tr th:nth-child(9) {width:12%!important;}

		#village_view_build_list tr td:first-child {width:5%!important;}
		#village_view_build_list tr td:nth-child(2) {width:35%!important;}
		#village_view_build_list tr td:nth-child(3) {width:8%!important;}
		#village_view_build_list tr td:nth-child(4) {width:8%!important;}
		#village_view_build_list tr td:nth-child(5) {width:8%!important;}
		#village_view_build_list tr td:nth-child(6) {width:8%!important;}
		#village_view_build_list tr td:nth-child(7) {width:8%!important;}
		#village_view_build_list tr td:nth-child(8) {width:8%!important;}
		#village_view_build_list tr td:nth-child(9) {width:12%!important;}

		.tab_header1 tr th:first-child {width:5%!important;}
		.tab_header1 tr th:nth-child(2) {width:35%!important;}
		.tab_header1 tr th:nth-child(3) {width:12%!important;}
		.tab_header1 tr th:nth-child(4) {width:12%!important;}
		.tab_header1 tr th:nth-child(5) {width:12%!important;}
		.tab_header1 tr th:nth-child(6) {width:12%!important;}
		.tab_header1 tr th:nth-child(7) {width:12%!important;}
		.tab_header1 tr th:nth-child(8) {width:12%!important;}
		.tab_header1 tr th:nth-child(9) {width:12%!important;}

		#village_view_build_list1 tr td:first-child {width:5%!important;}
		#village_view_build_list1 tr td:nth-child(2) {width:35%!important;}
		#village_view_build_list1 tr td:nth-child(3) {width:12%!important;}
		#village_view_build_list1 tr td:nth-child(4) {width:12%!important;}
		#village_view_build_list1 tr td:nth-child(5) {width:12%!important;}
		#village_view_build_list1 tr td:nth-child(6) {width:12%!important;}
		#village_view_build_list1 tr td:nth-child(7) {width:12%!important;}
		#village_view_build_list1 tr td:nth-child(8) {width:12%!important;}
		#village_view_build_list1 tr td:nth-child(9) {width:12%!important;}

		.inside_data_orange {
			text-align: center!important;
		}

		/*控件样式*/
		#ly_comp_div1,#ly_comp_div2,#ly_comp_div3 {width:75%;display:inline-block;float:left;}
		#ly_comp_02,#ly_comp_03 {width:15%;display:inline-block;float:left;}
		#ly_comp_04 {width:40%;display:inline-block;float:left;}
		#ly_comp_05,#ly_comp_06 {width:85%;display:inline-block;float:left;}
		#ly_comp_div2,#ly_comp_div3,#ly_tab_head2,#village_view_build_list1 {display: none;float:left;}
		#ly_comp_div1 select,#ly_comp_div1 div,#ly_comp_div2 select,#ly_comp_div2 div,#ly_comp_div3 select,#ly_comp_div3 div {float:left;}
		#ly_comp_div1 div,#ly_comp_div2 div,#ly_comp_div3 div {width:10%;text-align:center;}
	</style>
	<link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/school_workspench.css?version=New Date()"/>'
		  rel="stylesheet" type="text/css" media="all"/>
</head>
<body>
	<!--楼宇清单----------20180413------------- 开始---------------------------------------------->
	<div class="village_new_searchbar">
		<table style = "width:100%">
			<tr>
				<td>
					<div class="count_num desk_orange_bar inside_data inside_data_orange">
					楼宇数：<span id="ly_sum_01" style ="color:#FF0000">0</span>&nbsp;&nbsp;
					新生公寓：<span id="ly_sum_02" style ="color:#FF0000">0</span>&nbsp;&nbsp;
					男生公寓：<span id="ly_sum_03" style ="color:#FF0000">0</span>
					女生公寓：<span id="ly_sum_04" style ="color:#FF0000">0</span>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					 <div class="collect_new_choice" style ="position:relative;padding-top:2px;color:black;width:100%;">
						 <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
							 <div style="width:8%;">楼宇分区：</div>
							 <select id="ly_comp_01" style="width:15%;padding-left:0px;"></select>
							 <div id="ly_comp_div1">
								 <div>新生公寓：</div>
								 <select id="ly_comp_02"></select>
								 <div>男女公寓：</div>
								 <select id="ly_comp_03"></select>
								 <div>楼宇：</div>
								 <select id="ly_comp_04"></select>
							 </div>
							 <div id="ly_comp_div2">
								 <div>楼宇：</div>
								 <select id="ly_comp_05"></select>
							 </div>
							 <div id="ly_comp_div3">
								 <div>楼宇：</div>
								 <select id="ly_comp_06"></select>
							 </div>
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

	<div style="width: 96%;margin:0 auto;">
		<div class="village_m_tab blue_thead tab_head_lock" style="width:100%;padding-right:17px;height:auto;">
			<table class="content_table tab_header" id="ly_tab_head1" style="width:100%;" cellspacing="0" cellpadding="0">
				<tr>
					<th>序号</th>
					<th>楼宇名称</th>
					<th>新生公寓</th>
					<th>男女公寓</th>
					<th>房间数</th>
					<th>床位数</th>
					<th>学生数</th>
					<th>移动用户</th>
					<th>移动渗透率</th>
				</tr>
			</table>
			<table class="content_table tab_header1" id="ly_tab_head2" style="width:100%;" cellspacing="0" cellpadding="0">
				<tr>
					<th>序号</th>
					<th>楼宇名称</th>
					<th>功能区</th>
					<th>房间数</th>
					<th>OBD数</th>
					<th>端口数</th>
					<th>端口占用率</th>
				</tr>
			</table>
		</div>
		<div class="exec_tab_body desk_tab tab_scroll" style="overflow-y:scroll;width:100%;height:56%!important;">
			<table class="content_table tab_body" id="village_view_build_list" style="width:100%;" cellspacing="0" cellpadding="0">
			</table>
			<table class="content_table tab_body" id="village_view_build_list1" style="width:100%;" cellspacing="0" cellpadding="0">
			</table>
		</div>
	</div>
	<!--楼宇清单----------20180413------------- 结束------------------------------------------------------->
</body>
</html>
<script type="text/javascript">
	var business_id = '${param.business_id}';
	var url4sql = "<e:url value='/pages/telecom_Index/common/sql/tabData_enterprise.jsp' />";
	var type1 = 2;//楼宇分区
	var type2 = "";//新生公寓
	var type3 = "";//男女公寓
	var type4 = "";//宿舍 楼宇
	var type5 = "";//教学 楼宇
	var type6 = "";//生活 楼宇
	var begin = 0,end = 0,seq_num = 0,page = 0;

	var sum01 = "#ly_sum_01";
	var sum02 = "#ly_sum_02";
	var sum03 = "#ly_sum_03";
	var sum04 = "#ly_sum_04";

	var comp01 = "#ly_comp_01";
	var comp02 = "#ly_comp_02";
	var comp03 = "#ly_comp_03";
	var comp04 = "#ly_comp_04";
	var comp05 = "#ly_comp_05";
	var comp06 = "#ly_comp_06";

	var tab_head = "";
	var tab_body = "#collect_new_bulid_info_list_sj";

	$(function(){
		get_summary();
		init_comp();
		get_list(true);
	});
	function get_summary(){
		$.post(url4sql,{"eaction":"getBuildSummary","business_id":business_id},function(data){
			var d = $.parseJSON(data);
			if(d!=null){
				$(sum01).text(d.BUILD_CNT);
				$(sum02).text(d.NEW_CNT);
				$(sum03).text(d.MALE_CNT);
				$(sum04).text(d.FEMALE_CNT);
			}else{
				$(sum01).text(0);
				$(sum02).text(0);
				$(sum03).text(0);
				$(sum04).text(0);
			}
		});
	}
	function init_comp(){
		$(comp01).append("<option value=\"2\">宿舍区</option>");
		$(comp01).append("<option value=\"1\">教学区</option>");
		$(comp01).append("<option value=\"3\">生活区</option>");

		$(comp01).on("change",function(){
			type1 = $("#ly_comp_01 option:selected").val();
			if(type1==1){
				$("#ly_comp_div1").hide();
				$("#ly_comp_div2").show();
				$("#ly_comp_div3").hide();
				$("#ly_tab_head").show();

				$("#ly_tab_head1").hide();
				$("#village_view_build_list").hide();
				$("#ly_tab_head2").show();
				$("#village_view_build_list1").show();
			}else if(type1==2){
				$("#ly_comp_div1").show();
				$("#ly_comp_div2").hide();
				$("#ly_comp_div3").hide();
				$("#ly_tab_head").show();

				$("#ly_tab_head1").show();
				$("#village_view_build_list").show();
				$("#ly_tab_head2").hide();
				$("#village_view_build_list1").hide();
			}else if(type1==3){
				$("#ly_comp_div1").hide();
				$("#ly_comp_div2").hide();
				$("#ly_comp_div3").show();
				$("#ly_tab_head").show();

				$("#ly_tab_head1").hide();
				$("#village_view_build_list").hide();
				$("#ly_tab_head2").show();
				$("#village_view_build_list1").show();
			}
			fresh();
		});

		/*是否新生公寓*/
		$(comp02).append("<option value=\"\">全部</option>");
		$(comp02).append("<option value=\"1\">是</option>");
		$(comp02).append("<option value=\"0\">否</option>");

		$(comp02).on("change",function(){
			type2 = $(comp02+" option:selected").val();
			fresh();
		});

		/*男女公寓*/
		$(comp03).append("<option value=\"\">全部</option>");
		$(comp03).append("<option value=\"2\">女生公寓</option>");
		$(comp03).append("<option value=\"1\">男生公寓</option>");
		$(comp03).append("<option value=\"3\">其他</option>");

		$(comp03).on("change",function(){
			type3 = $(comp03+" option:selected").val();
			fresh();
		});

		/*宿舍区 楼*/
		addBuild(2,"","",comp04);

		$(comp04).on("change",function(){
			type4 = $(comp04+" option:selected").val();
			clear();
			get_list(true);
		});

		/*教学区 楼*/
		addBuild(1,"","",comp05);

		$(comp05).on("change",function(){
			type5 = $(comp05+" option:selected").val();
			clear();
			get_list(true);
		});

		/*生活区 楼*/
		addBuild(3,"","",comp06);

		$(comp06).on("change",function(){
			type6 = $(comp06+" option:selected").val();
			clear();
			get_list(true);
		});

		$(".tab_scroll").scroll(function () {
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - begin > 500) {
					++page;
					get_list(false);
				}
				begin = new Date().getTime();
			}
		});
	}

	function freshBuild(){
		var target = "";
		if(type1==1){
			target = comp05;
		}else if(type1==2){
			target = comp04;
		}else if(type1==3){
			target = comp06;
		}
		$(target).empty();
		addBuild(type1,type2,type3,target);
	}

	var default_option = "<option value=\"\">全部</option>";
	function addBuild(type1,type2,type3,target){
		$(target).append(default_option);
		$.post(url4sql,{"eaction":"getBuildInsideSchoolOrEnterprise","village_id":business_id,"area_type":type1,"is_new":type2,"sex":type3},function(data){
			var data = $.parseJSON(data);
			$.each(data,function(index,item){
				$(target).append("<option value=\""+item.SEGM_ID+"\">"+item.STAND_NAME+"</option>");
			});
		});
	}

	function fresh(){
		clear();
		freshBuild();
		get_list(true);
	}

	function getParams(){
		return {
			"eaction":"getBuildInfo",
			"business_id":business_id,
			"area_type":type1,
			"is_new":type2,
			"sex":type3,
			"page":page
		};
	}

	var fill_empty = true;
	function get_list(flag){
		var params = getParams();
		var target = "";
		if(type1==2){
			target = "#village_view_build_list";
			params.resid = type4;
		}else if(type1==1){
			target = "#village_view_build_list1";
			params.resid = type5;
		}else if(type1==3){
			target = "#village_view_build_list1";
			params.resid = type6;
		}

		$.post(url4sql,params,function(data){
			var data = $.parseJSON(data);
			if(page==0){
				if(data.length){
					$("#recode_cnt").text(data[0].C_NUM);
				}else{
					$("#recode_cnt").text("0");
				}
			}
			if(type1==2){
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
					"<td>"+item.STAND_NAME+"</td>"+
					"<td>"+item.IS_NEW+"</td>"+
					"<td>"+item.SEX+"</td>"+
					"<td>"+item.CELL_NUM+"</td>"+
					"<td>"+item.BED_NUM+"</td>"+
					"<td>"+item.ZHU_HU_COUNT+"</td>"+
					"<td>"+item.YD_NUM+"</td>"+
					"<td>"+item.YD_LV+"</td>"+
					"</tr>");
				});
			}else if(type1==1 || type1==3){
				if(!data.length && flag){
					if(fill_empty){
						for(var i = 0,l=8;i<l;i++){
							$(target).append("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
						}
					}else{
						$(target).append("<tr><td colspan='7'>未查询到结果</td></tr>");
					}
				}
				$.each(data,function(index,item){
					$(target).append("<tr><td>"+(++seq_num)+"</td>"+
					"<td>"+item.STAND_NAME+"</td>"+
					"<td>"+item.AREA_TYPE_TEXT+"</td>"+
					"<td>"+item.CELL_NUM+"</td>"+
					"<td>"+item.OBD_NUM+"</td>"+
					"<td>"+item.PORT+"</td>"+
					"<td>"+item.PORT_LV+"</td>"+
					"</tr>");
				});
			}
		});
	}
	function clear(){
		begin = 0,end = 0,seq_num = 0,page = 0;
		$("#village_view_build_list").empty();
		$("#village_view_build_list1").empty();
	}
</script>
<script>
    //利用js让头部与内容对应列宽度一致。

    function fix(){
        for(var i=0;i<=$(".tab_header tr").find("th").index();i++){
            $(".tab_body tr td").eq(i).css("width",$(".tab_header tr").find("th").eq(i).width());
        }
    }
    //window.load=fix();
	$(function(){
	    //fix();
	});
    $(window).resize(function(){
        return fix();
    });

    //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
    $('.t_table').scroll(function(){
        $('#table_head').css('margin-left',-($('.t_table').scrollLeft()));
    });
</script>