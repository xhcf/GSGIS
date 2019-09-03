<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="ly_list">
select dd.segm_id CODE,dd.stand_name TEXT
from gis_data.TB_GIS_VILLAGE_ADDR4 ff,
     sde.TB_GIS_MAP_SEGM_LATN_MON dd
where ff.segm_id = dd.segm_id
and ff.village_id='${param.village_id}'
	order by ff.segm_id ASC,ff.segm_name ASC
</e:q4l>
<html>
<head>
	<title>楼宇清单</title>
	<style type="text/css">
		.tab_header tr th:first-child {width:5%!important;}
		.tab_header tr th:nth-child(2) {width:50%!important;}
		.tab_header tr th:nth-child(3) {width:5%!important;}
		.tab_header tr th:nth-child(4) {width:10%!important;}
		.tab_header tr th:nth-child(5) {width:10%!important;}
		.tab_header tr th:nth-child(6) {width:10%!important;}
		.tab_header tr th:nth-child(7) {width:10%!important;}

		#village_view_build_list tr td:first-child {width:5%!important;}
		#village_view_build_list tr td:nth-child(2) {width:50%!important;}
		#village_view_build_list tr td:nth-child(3) {width:5%!important;}
		#village_view_build_list tr td:nth-child(4) {width:10%!important;}
		#village_view_build_list tr td:nth-child(5) {width:10%!important;}
		#village_view_build_list tr td:nth-child(6) {width:10%!important;}
		#village_view_build_list tr td:nth-child(7) {width:10%!important;}

		.inside_data_orange {
			text-align: center!important;
		}
	</style>
</head>
<body>
	<!--楼宇清单----------20180413------------- 开始---------------------------------------------->
	<div class="village_new_searchbar">
		<table style = "width:100%">
		   <tr>
				<td>
					<div class="count_num desk_orange_bar inside_data inside_data_orange">
					楼宇数：<span id="village_view_build_record_total_count" style ="color:#FF0000">0</span>&nbsp;&nbsp;
					资源已达楼宇：<span id="village_view_build_record_exist" style ="color:#FF0000">0</span>&nbsp;&nbsp;
					资源未达楼宇：<span id="village_view_build_record_noexist" style ="color:#FF0000">0</span>
					</div>
				</td>
			</tr>
			<tr>
				 <td>
					 <div class="collect_new_choice" style ="position:relative;padding-top:2px;color:black;width:100%;">
					 <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
						楼宇:&nbsp;
						<select id="ly_collect_new_build_list" onchange="ly_load_build_info(0)" style="width:92%;padding-left:0px;"></select>
						<input type="text" id="ly_collect_new_build_name" oninput="ly_load_build_name_list()" style="margin-left:0;padding-left:0px;border:none;display: none;">
						<ul id="ly_collect_new_build_name_list" style="width:100%;margin-left:0;padding-left:85px;">
						</ul>
					</div>
					</div>
				  </td>
			</tr>
			<tr>
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
			</tr>
		</table>
	</div>

	<div style="width: 96%;margin:0 auto;">
		<div class="village_m_tab blue_thead tab_head_lock" style="width:100%;padding-right:17px;height:auto;">
			<table class="content_table tab_header" style="width:100%;" cellspacing="0" cellpadding="0">
				<tr>
					<th>序号</th>
					<th>楼宇</th>
					<th>住户数</th>
					<th>光宽用户数</th>
					<th>宽带渗透率</th>
					<th>端口数</th>
					<th>端口占用率</th>
				</tr>
			</table>
		</div>
		<div class="exec_tab_body desk_tab tab_scroll" style="overflow-y:scroll;width:100%;height:56%!important;">
			<table class="content_table tab_body" id="village_view_build_list" style="width:100%;" cellspacing="0" cellpadding="0">
			</table>
		</div>
	</div>
	<!--楼宇清单----------20180413------------- 结束------------------------------------------------------->
</body>
</html>
<script type="text/javascript">
	var ly_build_list = [];
	var ly_select_count = 0;

	//楼宇ID
	var ly_build_id = "";
	//资源到达
	var res_type  = "";

	var urllyQuery = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp" />';
	//楼宇列表
	function freshVillageViewBuildList(res_type) {
		var cit = $("#village_view_build_list");
		cit.empty();
		$.post(urllyQuery, {
			eaction: "getBuildInVillageList",
			village_id: village_id,
			build_id: ly_build_id,
			res_type:res_type
		}, function (data) {
			data = $.parseJSON(data);
			if (data == null || data.length == 0) {
				$("#village_view_build_list").append("<tr><td colspan='8'>暂无楼宇信息</td></tr>");
				return;
			}

			$("#village_view_build_record_count").text(data.length - 1);

			for (var j = 0; j < data.length; j++) {
				var newRow = "";
				var obj = data[j];
				if (obj.SEGM_ID != 0)
					newRow += "<tr><td>" + (j+1);
				else
					newRow += "<tr class=\"heji\"><td>";
				newRow += "</td>";
				if (obj.SEGM_ID != 0)
					newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:parent.showBuildDetail('" + obj.SEGM_ID + "','" + obj.STAND_NAME + "','all',0,this," + village_id + ")\">" + obj.STAND_NAME + "</a></td>";
				else
					newRow += "<td class=\"heji_text_center\" >" + obj.STAND_NAME + "</td>";
				if (obj.ZHU_HU_COUNT > 0) {
					if (obj.SEGM_ID != 0)
						newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:parent.showBuildDetail('" + obj.SEGM_ID + "','" + obj.STAND_NAME + "','all',0,this," + village_id + ")\">" + obj.ZHU_HU_COUNT + "</a></td>";
					else
						newRow += "<td>" + obj.ZHU_HU_COUNT + "</td>";
				}
				else if (obj.ZHU_HU_COUNT == -1)
					newRow += "<td>--</td>";
				else
					newRow += "<td>0</td>";

				newRow += "<td>" + (obj.GZ_H_USE_CNT) + "</td>";
				newRow += "<td>" + (obj.USE_LV) + "</td>";


				newRow += "<td>" + (obj.PORT_ID_CNT) + "</td>";
				newRow += "<td>" + (obj.PORT_LV) + "</td>";
				newRow += "</tr>";

				$("#village_view_build_list").append(newRow);
			}
            fix();
		});
	}

	//楼宇汇总
	function freshVillageViewBuild_num() {
		$.post(urllyQuery, {
			eaction: "getBuildInVillageTotal",
			village_id: village_id,
			build_id: ly_build_id
		}, function (data) {
			data = $.parseJSON(data);
			//楼宇数
			$("#village_view_build_resource_all").text(data.LY_CNT);
			//资源已达楼宇
			$("#village_view_build_resource_exist").text(data.RES_ARRIVE_CNT);
			//资源未达楼宇
			$("#village_view_build_resource_noexist").text(data.NO_RES_ARRIVE_CNT);
			if(ly_build_id == '-1' || ly_build_id == ''){
				//楼宇数
				$("#village_view_build_record_total_count").text(data.LY_CNT);
				//资源已达楼宇
				$("#village_view_build_record_exist").text(data.RES_ARRIVE_CNT);
				//资源未达楼宇
				$("#village_view_build_record_noexist").text(data.NO_RES_ARRIVE_CNT);
			}
		});
	}

	$(function(){
		//第二个标签页，楼宇基本信息
		//统计显示
		freshVillageViewBuild_num();
		//列表显示
		freshVillageViewBuildList("");
		//初始化comb
		ly_initComb();
		//营销清单-营销派单tab(单转融、协议到期、沉默唤)切换
		var res_tb_id='';
		$("#res_tb >span ").each(function (index) {

			$(this).unbind();
			$(this).on("click", function () {
				$(this).addClass("active").siblings().removeClass("active");
				res_tb_id='';
				//显示当前表格，隐藏其他表格
				if(index==0){
					res_type='';
				}else if(index==1){
					res_type='1';
				}else if(index==2){
					res_type='0';
				}

				//var village_view_build_search_add4 = $("#village_view_build_search_add4").val();
				//var selLY = $("#yhzt_collect_new_build_list").find("option:selected").val();

				//freshVillageViewBuild_num();
				freshVillageViewBuildList(res_type);
			})
		})
	});

	//楼宇combonchage事件
	var ly_load_build_info = function (flag) {
		//父页面切换过来的
		/*if(flag==1){
			$("#ly_collect_new_build_list option[value=" + common_bulid_id + "]").attr('selected','selected');
		}*/

		//默认选中第一个span
		$("#res_select").addClass("active").siblings().removeClass("active");

		var text = $("#ly_collect_new_build_list").find("option:selected").text();
		$("#ly_collect_new_build_name").val(text);
		$("#ly_collect_new_select_build").html(text);
		ly_build_id = $("#ly_collect_new_build_list").val();

		//共同楼宇ID,标签联动切换使用,需要子页面去秀给他的编号
		//common_bulid_id  = ly_build_id;
		//统计显示
		freshVillageViewBuild_num();
		//类表信息
		freshVillageViewBuildList("");
	};

	//楼宇comb初始化
	function ly_initComb() {
		//预警区域信息编辑
		var data = ${e:java2json(ly_list.list)};
		var d, newRow = "<option value='-1' select='selected'>全部</option>";
		for (var i = 0, length = data.length; i < length; i++) {
			d = data[i];
			newRow += "<option value='" + d.CODE + "' >" + d.TEXT + "</option>";
			ly_build_list.push(d);
		}
		$("#ly_collect_new_build_list").append(newRow);
		//初始化选中
		var text = $("#ly_collect_new_build_list").find("option:selected").text();
		$("#ly_collect_new_build_name").val(text);
		$("#ly_collect_new_select_build").html(text);
	}

	//楼宇comb输入事件
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
				//共同楼宇ID,标签联动切换使用,需要子页面去赋值
				//common_bulid_id  = ly_build_id;
				//统计显示
				freshVillageViewBuild_num();
				//列表信息
				freshVillageViewBuildList("");

			}

			//联动改变 select框, 只要不做点击, 都会将select改回全部.
			$("#ly_collect_new_build_list option:eq(0)").attr('selected','selected');
			ly_select_count++;
		}, 800)
	}

	//楼宇comb显示
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