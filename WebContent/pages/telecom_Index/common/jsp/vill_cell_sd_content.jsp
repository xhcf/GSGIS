<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="ly_list">
	SELECT brigade_id
	FROM ${gis_user}.TB_GIS_BRIGADE_DAY WHERE
	village_id = '${param.village_id}'
	AND acct_day = (
	SELECT const_value FROM sys_const_table WHERE const_type = 'var.dss25' AND data_type = 'day'
	)
</e:q4l>
<html>
<head>
	<title>社队清单</title>
	<style type="text/css">
		#sd_head tr th:first-child {width:5%!important;}
		#sd_head tr th:nth-child(2) {width:19%!important;}
		#sd_head tr th:nth-child(3) {width:19%!important;}
		#sd_head tr th:nth-child(4) {width:19%!important;}
		#sd_head tr th:nth-child(5) {width:19%!important;}
		#sd_head tr th:nth-child(6) {width:19%!important;}

		#village_view_build_list tr td:first-child {width:5%!important;}
		#village_view_build_list tr td:nth-child(2) {width:19%!important;}
		#village_view_build_list tr td:nth-child(3) {width:19%!important;}
		#village_view_build_list tr td:nth-child(4) {width:19%!important;}
		#village_view_build_list tr td:nth-child(5) {width:19%!important;}
		#village_view_build_list tr td:nth-child(6) {width:19%!important;color:#ffa22e;font-weight:bolder;}

		.village_view_win .tab_box div .desk_orange_bar {
			text-align: center;
		}
		.blue_thead th {background: #007BA9;}

		.exec_tab_body {
			border-bottom:1px solid #efefef;

		}
	</style>
</head>
<body>
	<!--社队清单----------20180413------------- 开始---------------------------------------------->
	<div class="village_new_searchbar">
		<table style = "width:100%">
		   <tr>
				<td>
					<div class="count_num desk_orange_bar inside_data">
					社队数：<span id="village_view_shedui_cnt1" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					住户数：<span id="zhu_hu_shu" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					光宽数：<span id="gk_shu" style ="color:#FF0000">0</span>
					</div>
				</td>
		   </tr>
		</table>

		<div class="collect_new_choice" style ="position:relative;padding-top:5px;color:black;width:100%;margin-left:20px;">
			 <div class="collect_contain_choice" style="margin:0px auto;width: 100%;float:none;">
				<span style='font-weight:bold;'>社队:</span>
				<select id="ly_collect_new_build_list" onchange="ly_load_build_info(0)" style="width:90%;padding-left:0px;"></select>
				<input type="text" id="ly_collect_new_build_name" oninput="ly_load_build_name_list()" style="margin-left:0;padding-left:0px;border:none;display: none;">
				<ul id="ly_collect_new_build_name_list" style="width:100%;margin-left:0;padding-left:85px;">
				</ul>
			</div>
		</div>

		<%--<tr>
			<td>
				<span>
					<div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" id="res_tb">
						资源到达：
						<span class="active" value="1" id ="res_select">全部 (<span id="village_view_build_resource_all" style ="color:#FF0000">0</span> )</span>
						<span  value="2">已达楼宇 (<span id="village_view_build_resource_exist" style ="color:#FF0000">0</span> )</span>
						<span  value="3">未达楼宇 (<span id="village_view_build_resource_noexist" style ="color:#FF0000">0</span> )</span>
					</div>
				 </span>
			</td>
		</tr>--%>

	</div>

	<div class="count_num2">
		记录数：<span id="record_num_sd"></span>
	</div>

	<div style="width: 96%;margin:0 auto;">
		<div class="village_m_tab blue_thead tab_head_lock" style="width:100%;padding-right:17px;height:auto;">
			<table class="content_table tab_header" style="width:100%;" cellspacing="0" cellpadding="0" id="sd_head">
				<tr>
					<th>序号</th>
					<th>社队名称</th>
					<th>人口数</th>
					<th>住户数</th>
					<th>光宽用户数</th>
					<th>光宽渗透率</th>
				</tr>
			</table>
		</div>
		<div class="exec_tab_body desk_tab tab_scroll" style="overflow-y:scroll;width:100%;">
			<table class="content_table tab_body" id="village_view_build_list" style="width:100%;" cellspacing="0" cellpadding="0">
			</table>
		</div>
	</div>
	<!--社队清单----------20180413------------- 结束------------------------------------------------------->
</body>
</html>
<script type="text/javascript">
	var ly_build_list = [];
	var ly_select_count = 0;

	//社队ID
	var ly_build_id = "";
	//资源到达
	var page_sd = 0;
	var seq_sd = 0;

	var urllyQuery = '<e:url value="/pages/telecom_Index/common/sql/tabData_village_cell.jsp" />';

	function clear_data(){
		page_sd = 0;seq_sd = 0;
		var cit = $("#village_view_build_list");
		cit.empty();
	}
	//社队列表
	function freshVillageViewBuildList(flag) {

		$.post(urllyQuery, {
			eaction: "villageCell_shedui_list",
			village_id: village_id,
			build_id: ly_build_id,
			page:page_sd
		}, function (data) {
			data = $.parseJSON(data);
			if(data.length && page_sd==0)
				$("#record_num_sd").text(data[0].C_NUM);

			for (var j = 0; j < data.length; j++) {
				var newRow = "";
				var obj = data[j];
				newRow += "<tr><td>" + (++seq_sd) +"</td>";
				newRow += "<td class=\"heji_text_center\" ><a href=\"javascript:parent.showBuildDetail('"+obj.BRIGADE_ID+"','"+obj.BRIGADE_NAME+"','"+obj.VILLAGE_ID+"')\">" + obj.BRIGADE_NAME + "</a></td>";
				newRow += "<td>"+ obj.POPULATION_NUM +"</td>";

				newRow += "<td>" + obj.ZHU_HU_COUNT + "</td>";

				newRow += "<td>" + (obj.H_USE_CNT) + "</td>";
				newRow += "<td>" + (obj.GKST_LV) + "</td>";

				newRow += "</tr>";

				$("#village_view_build_list").append(newRow);
			}
			if ((data == null || data.length == 0)&&flag) {
				$("#record_num_sd").text("0");
				$("#village_view_build_list").append("<tr><td colspan='8'>暂无社队信息</td></tr>");
				return;
			}
            fix();
		});
	}

	//社队汇总
	function freshVillageViewBuild_num() {
		$.post(urllyQuery, {
			eaction: "getSheDuiSummaryByVillage",
			village_id: village_id,
			build_id: ly_build_id
		}, function (data) {
			var d = $.parseJSON(data);
			//住户数
			$("#zhu_hu_shu").text(d.ZHU_HU_NUM);
			//光宽数
			$("#gk_shu").text(d.KD_NUM);
			//资源未达社队
			/*$("#village_view_build_resource_noexist").text(data.NO_RES_ARRIVE_CNT);
			if(ly_build_id == '-1' || ly_build_id == ''){
				//社队数
				$("#village_view_build_record_total_count").text(data.LY_CNT);
				//资源已达社队
				$("#village_view_build_record_exist").text(data.RES_ARRIVE_CNT);
				//资源未达社队
				$("#village_view_build_record_noexist").text(data.NO_RES_ARRIVE_CNT);
			}*/
		});

		$.post(urllyQuery,{
			eaction:"getSheDuiCnt",
			village_id: village_id
		},function(data){
			var d = $.parseJSON(data);
			$("#village_view_shedui_cnt1").text(d.BRIGADE_ID_CNT);
		});
	}

	$(function(){
		//第二个标签页，社队基本信息
		//统计显示
		freshVillageViewBuild_num();
		//列表显示
		clear_data();
		freshVillageViewBuildList(1);
		//初始化comb
		ly_initComb();

		var yx_begin_scroll = 0;
		$(".desk_tab").scroll(function () {
			console.log(111);
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - yx_begin_scroll > 500) {
					++page_sd;
					freshVillageViewBuildList(0);
				}
				yx_begin_scroll = new Date().getTime();
			}
		});
	});

	//社队combonchage事件
	var ly_load_build_info = function (flag) {
		//父页面切换过来的
		/*if(flag==1){
			$("#ly_collect_new_build_list option[value=" + common_bulid_id + "]").attr('selected','selected');
		}*/
		clear_data();
		//默认选中第一个span
		$("#res_select").addClass("active").siblings().removeClass("active");

		var text = $("#ly_collect_new_build_list").find("option:selected").text();
		$("#ly_collect_new_build_name").val(text);
		$("#ly_collect_new_select_build").html(text);
		ly_build_id = $("#ly_collect_new_build_list").val();

		//共同社队ID,标签联动切换使用,需要子页面去秀给他的编号
		//common_bulid_id  = ly_build_id;
		//统计显示
		//freshVillageViewBuild_num();
		//类表信息
		freshVillageViewBuildList(1);
	};

	//社队comb初始化
	function ly_initComb() {
		var newRow = "<option value='-1' select='selected'>全部</option>";
		$.post(urllyQuery,{
			"eaction":"getSheDuiSelectOption",
			"village_id":village_id
		},function(data){
			var ds = $.parseJSON(data);
			for(var i = 0,l = ds.length;i<l;i++){
				var d = ds[i];
				newRow += "<option value='" + d.BRIGADE_ID + "' >" + d.BRIGADE_NAME + "</option>";
				ly_build_list.push(d);
			}
			$("#ly_collect_new_build_list").append(newRow);
			//初始化选中
			var text = $("#ly_collect_new_build_list").find("option:selected").text();
			$("#ly_collect_new_build_name").val(text);
			$("#ly_collect_new_select_build").html(text);
		});
	}

	//社队comb输入事件
	function ly_load_build_name_list() {
		setTimeout(function() {
			//下拉列表显示
			var $build_list =  $("#ly_collect_new_build_name_list");
			$build_list.empty();
			if (ly_select_count <= 1) {
				//before_load_build_list();
			}

			var build_name = $("#ly_collect_new_build_name").val().trim();
			if (build_name != '') {
				var temp;
				var newRow = "";
				for (var i = 0, length = yhzt_build_list.length, count = 0; i < length; i++) {
					if ((temp = yhzt_build_list[i].TEXT).indexOf(build_name) != -1) {
						newRow += "<li title='" + temp + "' onclick='ly_select_build(\""+ temp + "\",\"" +
						yhzt_build_list[i].CODE + "\"," + i + ")'>" + temp + "</li>";
						count++;
					}
				}
				$build_list.append(newRow);
				$("#ly_collect_new_build_name_list").show();
			} else {
				$("#ly_collect_new_build_name_list").hide();
				//[全部]选中
				var text = $("#ly_collect_new_build_list").find("option:selected").text();
				$("#ly_collect_new_build_name").val(text);
				$("#ly_collect_new_select_build").html(text);

				ly_build_id = $("#ly_collect_new_build_list").val();
				//共同社队ID,标签联动切换使用,需要子页面去赋值
				//common_bulid_id  = ly_build_id;
				//统计显示
				freshVillageViewBuild_num();
				//列表信息
				freshVillageViewBuildList(1);

			}

			//联动改变 select框, 只要不做点击, 都会将select改回全部.
			$("#ly_collect_new_build_list option:eq(0)").attr('selected','selected');
			ly_select_count++;
		}, 800)
	}

	//社队comb显示
	function ly_select_build(name, id, index) {
		$("#ly_collect_new_build_list option[value=" + id + "]").attr('selected','selected');
		$("#ly_collect_new_build_name_list").hide();
		$("#ly_collect_new_build_list").change();
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