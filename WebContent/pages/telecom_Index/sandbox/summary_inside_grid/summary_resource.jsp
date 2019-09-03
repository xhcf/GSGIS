<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="query_table_name">
    SELECT DISTINCT LATN_ID FROM ${gis_user}.db_cde_grid where GRID_ID = '${param.grid_id_short }'
</e:q4o>
<e:q4l var="village_list">
	SELECT '-1' CODE, '全部' TEXT FROM DUAL UNION ALL
	SELECT VILLAGE_ID CODE,VILLAGE_NAME TEXT FROM ${gis_user}.tb_gis_village_edit_info
	WHERE grid_id_2 = (SELECT DISTINCT grid_id FROM ${gis_user}.db_cde_grid WHERE grid_union_org_code = '${sessionScope.UserInfo.GRID_NO}')
</e:q4l>
<html>
<head>
    <title>资源标签</title>
	<link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_level.css?version=New Date()"/>' rel="stylesheet" type="text/css"
		  media="all"/>
	<style>
		.div_show{display:block;}
		.div_hide{display:none;}
		.grid_odb_count_title,.village_obd_count_title,.build_obd_count_title{margin-left:15px;}
		#resource_obd_grid_count,#resource_obd_village_count,#resource_obd_build_count{
			padding-left: 10px;
			color: #ee7008;
			font-weight: bold;
		}
		.obd_contain_choice{height: 41px;}
		.obd_contain_choice>span{padding-left: 15px;display:block;margin-top:5px;height:36px;
			line-height: 36px;}
		#collect_new_build_name{height:30px!important;line-height: 30px!important}
		.collect_contain_choice input, .collect_contain_choice select, .collect_contain_choice ul{
			left:55px;
		}
		.collect_contain_choice ul{top: 30px;left: 55px;
			z-index: 8;width: 85%}
		@media screen and (min-height: 800px){
			.obd_contain_choice>span{padding-left: 20px}
			.collect_contain_choice input, .collect_contain_choice select, .collect_contain_choice ul{
				left:70px;
			}
		}
	</style>
</head>
<body>
<div id="resource_sub_name" class="sub_name"></div>

<div class="tab_head" id="resource_tab_head">
  <span class="active">小区</span> <span>楼宇</span> <span>OBD</span>
</div>

<div class="tab_body" id="resource_tab_body">
  <div class="div_show div_0">
    <!--小区标签页内容 -->
    <div id="resource_village_query" class="resident_wrapper" style="padding-top: 5px;padding-bottom: 5px;">
      小区: <input type="text" id="resource_village_name" />
      <button class="button_click" onclick="village_query()" >查询</button>
      <div class="tab_accuracy_head follow_head" id="collect_village_state" style="padding-left: 0;font-weight: bold">
        资源状态：
        <span class="active" onclick="select_collect_state_v('')">全部<span id="res_village_all_count" ></span></span>
        <span onclick="select_collect_state_v(1)">资源到达<span id="res_village_count"></span></span>
        <span onclick="select_collect_state_v(0)">资源未达<span id="res_village_no_count" ></span></span>
      </div>
    </div>
    <div class="grid_count_title">记录数:<span id="resource_village_count"></span></div>
    <div class="village_datagrid">
      <div class="head_table_wrapper">
        <table class="head_table">
          <tr>
            <th style="width: 40px;">序号</th>
            <th style="width: 200px;">小区名称</th>
            <th style="width: 70px;">OBD数</th>
            <th style="width: 70px;">0-1OBD数</th>
            <th style="width: 80px;">高占用OBD数</th>
            <th style="width: 70px;" class="head_table_sort">端口占用率<i></i></th>
            <th style="width: 60px;">端口数</th>
            <th style="width: 60px;">占用端口数</th>
            <th style="width: 60px;">空闲端口数</th>
          </tr>
        </table>
      </div>
      <div class="t_table village_m_tab2" style="margin:0px auto;">
        <table class="content_table village_detail_in" id="resource_village_info_list" style="width:100%;">
        </table>
      </div>
    </div>
  </div>
  <div class="div_hide div_1">
    <!--楼宇标签页内容 -->
    <div id="resource_build_query" class="resident_wrapper" style="padding-top: 5px;padding-bottom: 5px;">
      楼宇: <input type="text" id="resource_build_build" />
      <button class="button_click" onclick="build_query()" >查询</button>
      <div class="tab_accuracy_head follow_head" style="padding-left: 0;font-weight: bold;" id="collect_build_state">
        资源状态：
        <span class="active" onclick="select_collect_state_b('');">全部<span id="res_build_all_count" ></span></span>
        <span onclick="select_collect_state_b(1);">资源到达<span id="res_build_count"></span></span>
        <span onclick="select_collect_state_b(0);">资源未达<span id="res_build_no_count" ></span></span>
      </div>
    </div>
    <div class="grid_count_title" style="display:none;">记录数:<span id="resource_build_count"></span></div>
    <div class="build_datagrid">
      <div class="head_table_wrapper">
        <table class="head_table">
          <tr>
            <th style="width: 40px;">序号</th>
            <th style="width: 200px;">楼宇</th>
            <th style="width: 70px;">OBD数</th>
            <th style="width: 70px;">0-1OBD数</th>
            <th style="width: 80px;">高占用OBD数</th>
            <th style="width: 70px;" class="head_table_sort" id="buliding_sort">端口占用率<i></i></th>
            <th style="width: 60px;">端口数</th>
            <th style="width: 60px;">占用端口数</th>
            <th style="width: 60px;">空闲端口数</th>
          </tr>
        </table>
      </div>
      <div class="t_table build_m_tab2" style="margin:0px auto;">
        <table class="content_table build_detail_in" id="resource_build_info_list" style="width:100%;">
        </table>
      </div>
    </div>
  </div>

  <div class="div_hide div_2">
	<!--OBD标签页内容 -->
	<div class="resident_wrapper" style="padding-top:5px;padding-bottom:5px;">
		<!-- 支局、网格、小区 标签切换 -->
		<div class="tab_accuracy_head follow_head" id="obd_tab_head2" style="padding-left:0;">
			<span class="active" style="padding-left:0">小区</span> <span>楼宇</span>
		</div>
	</div>
	  <!-- 下拉选项 -->
	<div class="obd_contain_choice">
		<div class="tab_accuracy_head follow_head" style="font-weight: bold;padding-left:0;float:right;line-height: 36px;
    height: 36px;margin-right:15px;" id="collect_obd_state">
			使用状态：
			<span class="active" onclick="select_obd_state_b(this,'');">全部<span id="res_obd_all_count" ></span></span>
			<span onclick="select_obd_state_b(this,1);">0-1OBD<span id="res_0obd_count"></span></span>
			<%--<span onclick="select_obd_state_b(this,2);">1OBD<span id="res_1obd_count" ></span></span>--%>
			<span onclick="select_obd_state_b(this,3);">高占用OBD<span id="res_hobd_count" ></span></span>
		</div>
		<span id="obd_new1_village_span">
			小区：
			<e:select items="${village_list.list}" label="TEXT"
					  value="CODE" id="obd_new1_village_list" name="obd_new1_village_list" onchange="load_obd_list_by_village()"/>
		</span>
		<span class="collect_contain_choice" style="margin-left:0;width: 38%;margin-right:0" id="obd_new1_build_span">
			楼宇:
			<select id="collect_new_build_list" name="collect_new_build_list" onchange="load_build_info(0)" style="width:85%;"></select>
			<input type="text" id="collect_new_build_name" name="collect_new_build_name" oninput="load_build_name_list()" style="width:75%">
			<ul id="collect_new_build_name_list">
			</ul>
		</span>
	</div>
	<div class="tab_body" id="obd_tab_body2">

		<div class="div_show div_obd_0">
			<div class="grid_count_title">记录数:<span id="resource_obd_village_count"></span></div>
			<div class="village_datagrid">
				<div class="head_table_wrapper">
					<table class="head_table">
						<tr>
							<th style="width: 40px;">序号</th>
							<th style="width: 150px;">小区名称</th>
							<th style="width: 150px;">设备编号</th>
							<th style="width: 60px;">使用率</th>
							<th style="width: 50px;">端口数</th>
							<th style="width: 70px;">占用端口数</th>
							<!--<th style="width: 50px;">0OBD</th>
							<th style="width: 50px;">1OBD</th>-->
						</tr>
					</table>
				</div>
				<div class="t_table grid_obd_m_tab" id="village_obd_m_tab2">
					<table class="content_table village_detail_in" id="obd_village_info_list" style="width:100%;">
					</table>
				</div>
			</div>
		</div>
		<div class="div_hide div_obd_1">
			<div class="grid_count_title">记录数:<span id="resource_obd_build_count"></span></div>
			<div class="build_datagrid">
				<div class="head_table_wrapper">
					<table class="head_table">
						<tr>
							<th style="width: 40px;">序号</th>
							<th style="width: 150px;">楼宇</th>
							<th style="width: 150px;">设备编号</th>
							<th style="width: 60px;">使用率</th>
							<th style="width: 50px;">端口数</th>
							<th style="width: 70px;">占用端口数</th>
							<!--<th style="width: 50px;">0OBD</th>
							<th style="width: 50px;">1OBD</th>-->
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
  </div>
</div>
</body>
</html>
<script>
var begin_scroll = "", seq_num = 0, list_page = 0, label='0', collect_state = null;
var select_count = 0;
var url = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary_grid.jsp' />";
var query_table_name = "sde.map_addr_segm_" + ${query_table_name.LATN_ID};
var condition = '${param.condition}';
var grid_id_short = '${param.grid_id_short}';
var build_list = [];

var region_type = 2;
var zy_type = "";
//obd状态切换
function select_obd_state_b(element,type){
	$(element).addClass("active").siblings().removeClass();
	zy_type = type;
	if(region_type=="2"){
		clear_data();
		load_obd_village();
		load_obd_village_sum_cnt();
		load_obd_village_type_cnt();
	}else if(region_type=="3"){
		clear_data();
		load_obd_build();
		load_odb_build_sum_cnt();
		load_obd_build_type_cnt();
	}
}

$(function(){
	//支局名赋值
	$("#resource_sub_name").text(grid_name);
	//标签页切换事件
    $("#resource_tab_head > span").each(function (index) {
		$(this).on("click", function () {
			$(this).addClass("active").siblings().removeClass("active");
			var $show_div = $(".div_" + index);
			$show_div.show();
			$("#resource_tab_body").children().not($show_div).hide();
			clear_data();
			if(index==0){
				label = '0';
				$("#collect_village_state > span").eq(0).click();
			}else if(index==1){
				label = '0';
				$("#collect_build_state > span").eq(0).click();
			}else if(index==2){
				label = '0';
				$("#collect_obd_state > span").eq(0).click();
				$("#obd_new1_village_span").show();
				$("#obd_new1_build_span").hide();
			}
		});
	});
	//默认先加载第一个标签的数据
	var tab_index = "${param.tab_index}";
	if(tab_index==0){
		$("#resource_tab_head span").eq(0).click();
	}else if(tab_index==1){
		$("#resource_tab_head span").eq(1).click();
	}else if(tab_index==2){
		$("#resource_tab_head span").eq(2).click();
	}else{
		$("#resource_tab_head span").eq(0).click();
	}

	$("#collect_village_state > span, #collect_build_state >span").each(function() {
		$(this).on('click', function() {
			$(this).addClass("active").siblings().removeClass("active")
		})
	})

	//obd标签内 支局、网格、小区 切换
	$("#obd_tab_head2 > span").each(function (index) {
		$(this).on("click", function () {
			$(this).addClass("active").siblings().removeClass("active");
			var $show_div = $(".div_obd_" + index);
			$show_div.show();
			$("#obd_tab_body2").children().not($show_div).hide();

			clear_data();
			if(index==0){
				$(".grid_odb_count_title").hide();
				$(".village_obd_count_title").show();
				$(".build_obd_count_title").hide();
				region_type = 2;
				console.log("加载小区");
				//load_village_list();//加载小区选项
				$("#collect_new_build_list").empty();
				$("#collect_new_build_list").val("");
				//load_obd_village();//加载小区数据
				//load_obd_village_type_cnt();//加载小区页签的obd分类数量
				//load_obd_village_sum_cnt();//加载小区页签的记录数
				$("#obd_new1_village_span").show();
				$("#obd_new1_build_span").hide();
				load_obd_list_by_village();
			}else if(index==1){
				$(".grid_odb_count_title").hide();
				$(".village_obd_count_title").hide();
				$(".build_obd_count_title").show();
				region_type = 3;
				console.log("加载楼宇");
				//load_build_list();//加载楼宇选项
				//load_obd_build();//加载楼宇数据
				//load_obd_build_type_cnt();//加载楼宇页签的obd分类数量
				//load_odb_build_sum_cnt();//加载楼宇页签的记录数
				$("#obd_new1_village_span").hide();
				$("#obd_new1_build_span").show();
				load_obd_list_by_build();
			}
		});
	});

	//绑定楼宇排序
	$('#buliding_sort').click(function(){
	    sort();
	});

	//加载楼宇列表
	$.post(url,{"eaction":"getBuildListByGridId","city_id":'${query_table_name.LATN_ID}',"grid_id_short": grid_id_short},function(data){
		var $build_list =  $("#collect_new_build_list");
		data = $.parseJSON(data);
		if (data.length != 0) {
			var d, newRow = "<option value='-1' select='selected'></option>";
			for (var i = 0, length = data.length; i < length; i++) {
				d = data[i];
				newRow += "<option value='" + d.CODE + "' select='selected'>" + d.TEXT + "</option>";
				build_list.push(d);
			}
			$build_list.append(newRow);
		}
	});

	if(condition=="1"){
		$("#collect_obd_state > span").eq(1).trigger("click");
	}else if(condition=="3"){
		$("#collect_obd_state > span").eq(2).trigger("click");
	}
});

//排序之前需要保存已选择变量.
function sort(){
   label = label == '0' ? '1' : '0';
   var temp = collect_state;
   clear_data();
   collect_state = temp;
   load_build();
}

function village_sort() {
    label = label == '0' ? '1' : '0';
    var temp = collect_state;
    clear_data();
    collect_state = temp;
    load_village(1);
}

function clear_data() {
    begin_scroll = "", seq_num = 0, list_page = 0, collect_state = null;
    $("#resource_village_info_list").empty();
    $("#resource_build_info_list").empty();
    $("#resource_grid_info_list").empty();
	$("#obd_village_info_list").empty();
	$("#obd_build_info_list").empty();
}

//下面是标签对应的加载事件
function load_village(is_first){
	var params = {
		eaction: "resource_village",
		village_name: $("#resource_village_name").val().trim(),
		page: list_page,
		label: label,
		collect_state: collect_state,
		"grid_id_short":grid_id_short
	}
    villageListScroll(params, is_first);
    /*params.eaction = "resource_village_count";
    $.post(url, params, function (data) {
    	if (data != null && data.trim() != 'null') {
            data = $.parseJSON(data);
            $("#resource_village_count").html(data.C_NUM);
            $("#res_village_all_count").html("(" + data.C_NUM + ")");
            $("#res_village_count").html("(" + data.RES_VILLAGE + ")");
            $("#res_village_no_count").html("(" + data.NO_RES_VILLAGE + ")");
        } else {
            $("#resource_village_count").html(0);
            $("#res_village_all_count").html("(" + 0 + ")");
            $("#res_village_count").html("(" + 0 + ")");
            $("#res_village_no_count").html("(" + 0 + ")");
        }
    })*/
}

function village_query() {
	clear_data();
	load_village(1);
}

function build_query() {
	clear_data();
	load_build();
}

//滚动加载
$(".village_m_tab2").scroll(function () {
	var viewH = $(this).height();
	var contentH = $(this).get(0).scrollHeight;
	var scrollTop = $(this).scrollTop();
	if (scrollTop / (contentH - viewH) >= 0.95) {
		if (new Date().getTime() - begin_scroll > 500) {
			++list_page;
			load_village(0);
		}
		begin_scroll = new Date().getTime();
	}
});

function villageListScroll(params, flag) {
	var $village_list = $("#resource_village_info_list");
	$.post(url,params, function (data) {
		data = $.parseJSON(data);
		for (var i = 0, l = data.length; i < l; i++) {
		    var d = data[i];
            var newRow = "<tr><td style='width:40px'>" + (++seq_num) + "</td>";
		    //newRow += "<td style='width:200px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.VILLAGE_ID + "',this)\" >" + d.VILLAGE_NAME + "</a></td>";
		    //newRow += "<td style='width:200px'><a href=\"javascript:void(0);\" onclick=\"javascript:clickToGridAndVillage('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this,9,'" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "',1);\" >" + d.VILLAGE_NAME + "</a></td>";
		   newRow += "<td style='width:200px'><a href=\"javascript:void(0);\" onclick=\"javascript:village_position('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "','" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "');\" >" + d.VILLAGE_NAME + "</a></td>";
		    newRow += "<td style='width:70px'>" + d.OBD_CNT + "</td><td style='width:70px'>" + d.ZERO_OBD_CNT +
		        "</td><td style='width:80px'>" + d.HIGH_USE_OBD_CNT + "</td><td style='width:70px' class='head_table_color'>" + d.PORT_PERCENT +
		        "</td><td style='width:60px'>" + d.PORT_ID_CNT + "</td><td style='width:60px'>" + d.USE_PORT_CNT +
		        "</td><td style='width:60px'>" + d.KONG_PORT_CNT + "</td></tr>";
		    $village_list.append(newRow);
		}
		if (data.length == 0 && flag) {
		    $village_list.empty();
		    $village_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
		    return;
		}
        if (data.length == 0 && flag == 0 && !is_list_load_end){
            getEmptyVillage();
        }
	});
}

var is_list_load_end = false;
function getEmptyVillage(){
    var params = {};
    params.grid_id_short = grid_id_short;
    params.flag = 4;
    params.eaction = "resource_village_empty";
    $.post(url,params,function(data){
        var d = $.parseJSON(data);
        var newRow = "<tr><td style='width:40px'></td>";
        //newRow += "<td style='width:200px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.VILLAGE_ID + "',this)\" >" + d.VILLAGE_NAME + "</a></td>";
        //带地图跟随跳转的
        //newRow += "<td style='width:200px'><a href=\"javascript:void(0);\" onclick=\"javascript:clickToGridAndVillage('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this,9,'" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "',1);\" >" + d.VILLAGE_NAME + "</a></td>";
        newRow += "<td style='width:200px'>未建小区</td>";
        newRow += "<td style='width:70px'>" + d.WJ_OBD_CNT + "</td><td style='width:70px'>" + d.WJ_ZERO_OBD_CNT +
        "</td><td style='width:80px'>" + d.WJ_HIGH_USE_OBD_CNT + "</td><td style='width:70px' class='head_table_color'>" + d.PORT_PERCENT +
        "</td><td style='width:60px'>" + d.WJ_PORT_ID_CNT + "</td><td style='width:60px'>" + d.WJ_USE_PORT_CNT +
        "</td><td style='width:60px'>" + d.WJ_KONG_PORT_CNT + "</td></tr>";
        $("#resource_village_info_list").append(newRow);
    });
    is_list_load_end = true;
}
function village_position(union_org_code,branch_name,grid_name,station_id,village_id){
    clickToGridAndVillage(union_org_code,branch_name ,'',9,grid_name,station_id,village_id,1);
    closeLayerAll();
}

function load_build(){
    var params = {
		eaction: "resource_build",
		build_name: $("#resource_build_build").val().trim(),
		page: 0,
		table_name: query_table_name,
		label:label,
		collect_state: collect_state,
		"grid_id_short":grid_id_short
	}

     buildListScroll(params, 1);
     params.eaction = "resource_build_count";
     $.post(url, params, function (data) {
    	 if (data != null && data.trim() != 'null') {
             data = $.parseJSON(data);
             $("#resource_build_count").html(data.C_NUM);
             $("#res_build_all_count").html("(" + data.C_NUM + ")");
             $("#res_build_count").html("(" + data.RES_BUILD + ")");
             $("#res_build_no_count").html("(" + data.NO_RES_BUILD + ")");
         } else {
             $("#resource_build_count").html(0);
             $("#res_build_all_count").html("(" + 0 + ")");
             $("#res_build_count").html("(" + 0 + ")");
             $("#res_build_no_count").html("(" + 0 + ")");
         }
     })
  }
  $(".build_m_tab2").scroll(function () {
    var viewH = $(this).height();
    var contentH = $(this).get(0).scrollHeight;
    var scrollTop = $(this).scrollTop();
    if (scrollTop / (contentH - viewH) >= 0.95) {
      if (new Date().getTime() - begin_scroll > 500) {
        var params = {
			eaction: "resource_build",
			build_name: $("#resource_build_build").val().trim(),
			page: ++list_page,
			table_name: query_table_name,
			label:label,
			collect_state: collect_state,
			"grid_id_short":grid_id_short
        }
        buildListScroll(params, 0);
      }
      begin_scroll = new Date().getTime();
    }
});

 function buildListScroll(params, flag) {
    var $build_list = $("#resource_build_info_list");
    $.post(url,params, function (data) {
      data = $.parseJSON(data);
      for (var i = 0, l = data.length; i < l; i++) {
          var d = data[i];
          var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
          //newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.SEGM_ID + "',this)\" >" + d.STAND_NAME + "</a></td>";
          //newRow += "<td style='width: 200px'><a href=\"javascript:standard_position_load('" + d.SEGM_ID + "','" + parent.city_name + "','" + parent.city_id + "',this);\" >" + d.STAND_NAME + "</a></td>";
          newRow += "<td style='width:200px'><a href=\"javascript:showBuildDetail('"+ d.SEGM_ID +"', '"+ d.STAND_NAME +"', 'all',0,0)\" > " + d.STAND_NAME + "</a></td>";
          newRow += "<td style='width: 70px'>" + d.OBD_COUNT + "</td><td style='width: 70px'>" + d.LOW_OBD_COUNT +
              "</td><td style='width: 80px'>" + d.HIGH_OBD_COUNT + "</td><td style='width: 70px' class='head_table_color'>" + d.PORT_PERCENT +
              "</td><td style='width: 60px'>" + d.PORT_SUM + "</td><td style='width: 60px'>" + d.PORT_USED_SUM +
              "</td><td style='width: 60px'>" + d.PORT_FREE_SUM + "</td></tr>";
          $build_list.append(newRow);
      }
      if (data.length == 0 && flag) {
          $build_list.empty();
          $build_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
          return;
      }
    });
}

function select_collect_state_b(type) {
    console.log("TYPE" + type);
    clear_data();
    collect_state = type;
    load_build();
}

function select_collect_state_v(type) {
    console.log("TYPE" + type);
    clear_data();
    collect_state = type;
    load_village(1);
}

//obd 网格 小区 楼宇 选择联动
var village_list = [];

//做名字查询时使用, 数据库太慢
var collect_state = 0, collect_bselect = -1;
//flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.

var load_build_info = function (flag) {
	//选中文本回写进 input
	//var text = $("#collect_new_build_list").find("option:selected").text();
	//$("#obd_new1_build_name").val(text);
	//$("#obd_new1_select_build").html(text);

	//var build_id = $("#collect_new_build_list").val()==null?'':$("#collect_new_build_list").val();
	//var $build_list = $("#obd_new1_bulid_info_list");
	clear_data();
	load_obd_build();
	load_obd_build_type_cnt();
	load_odb_build_sum_cnt();
}

function before_load_build_list() {
	clear_data();
	$("#obd_build_info_list").empty();
}
function load_obd_list_by_village(){
	clear_data();
	load_obd_village();
	load_obd_village_type_cnt();
	load_obd_village_sum_cnt();
}
function load_obd_list_by_build(){
	clear_data();
	load_obd_build();
	load_obd_build_type_cnt();
	load_odb_build_sum_cnt();
}

//OBD标签的数据

//obd小区
function load_obd_village(is_first){
	var params = {
		eaction: "obd_village",
		page: list_page,
		grid_id_short: grid_id_short,
		substation: substation,
		village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val(),
		zy:zy_type
	}
	villageOBDListScroll(params, 1);
	/*params.eaction = "obd_village_count";
	$.post(url, params, function (data) {
		if (data != null && data.trim() != 'null') {
			data = $.parseJSON(data);
			$("#obd_village_count").html(data.C_NUM);
		} else {
			$("#obd_village_count").html(0);
		}
	})*/
}

$("#village_obd_m_tab2").scroll(function () {
	var viewH = $(this).height();
	var contentH = $(this).get(0).scrollHeight;
	var scrollTop = $(this).scrollTop();
	if (scrollTop / (contentH - viewH) >= 0.95) {
		if (new Date().getTime() - begin_scroll > 500) {
			++list_page;
			load_obd_village(0);
		}
		begin_scroll = new Date().getTime();
	}
});

function villageOBDListScroll(params,flag){
	var $village_list = $("#obd_village_info_list");
	$.post(url,params, function (data) {
		data = $.parseJSON(data);
		for (var i = 0, l = data.length; i < l; i++) {
			var d = data[i];
			var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
			//newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.GRID_ID + "',this)\" >" + d.GRID_NAME + "</a></td>";
			newRow += "<td style='width: 150px'><a href=\"javascript:void(0);\">" + d.VILLAGE_NAME + "</a></td>";
			newRow += "<td style='width: 150px'>" + d.EQP_ID + "</td><td style='width: 60px'>" + d.USER_PORT_RATE +
			"%</td><td style='width: 50px'>" + d.PORT_ID_CNT + "</td><td style='width: 70px'>" + d.USE_PORT_CNT + "</td></tr>";
			//"</td><td style='width: 50px'>" + d.ZE_TEXT + "</td><td style='width: 50px'>" + d.FI_TEXT + "</td></tr>";
			$village_list.append(newRow);
		}
		if (data.length == 0 && flag) {
			$village_list.empty();
			$village_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
			return;
		}
		if (data.length == 0 && flag == 0 && !is_list_load_end){
			getEmptyVillage();
		}
	});
}

function load_obd_village_sum_cnt(){
	var params = {
		eaction: "obd_type_cnt_village",
		substation: substation,
		grid_id_short: grid_id_short,
		village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val(),
		zy:zy_type
	}
	$.post(url,params,function(data){
		data = $.parseJSON(data);
		$("#resource_obd_village_count").text(data.SUM_CNT);
	});
}

function load_obd_village_type_cnt(){
	var params = {
		eaction: "obd_type_cnt_village",
		grid_id_short: grid_id_short,
		substation:substation,
		village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val()
	}
	$.post(url,params,function(data){
		if(data!=null && data!="null"){
			var data1 = $.parseJSON(data);
			$("#res_obd_all_count").text("("+data1.SUM_CNT+")");
			//$("#res_0obd_count").text("("+data1.OBD0_CNT+")");
			$("#res_0obd_count").text("("+data1.OBD01_CNT+")");
			$("#res_1obd_count").text("("+data1.OBD1_CNT+")");
			$("#res_hobd_count").text("("+data1.HOBD_CNT+")");
		}
	});
}

//obd楼宇
function load_obd_build(){
	var params = {
		eaction: "obd_build",
		page: 0,
		resid: $("select[name='collect_new_build_list']").val() == '-1' ? '':$("select[name='collect_new_build_list']").val(),
		grid_id_short: grid_id_short,
		substation:substation,
		village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val(),
		city_id:parent.global_current_city_id,
		zy:zy_type
	}

	buildOBDListScroll(params, 1);
	params.eaction = "obd_build_count";
	$.post(url, params, function (data) {
		if (data != null && data.trim() != 'null') {
			data = $.parseJSON(data);
			$("#obd_build_count").html(data.C_NUM);
			$("#res_build_all_count").html("(" + data.C_NUM + ")");
			$("#res_build_count").html("(" + data.RES_BUILD + ")");
			$("#res_build_no_count").html("(" + data.NO_RES_BUILD + ")");
		} else {
			$("#obd_build_count").html(0);
			$("#res_build_all_count").html("(" + 0 + ")");
			$("#res_build_count").html("(" + 0 + ")");
			$("#res_build_no_count").html("(" + 0 + ")");
		}
	})
}

$("#build_obd_m_tab2").scroll(function () {
	var viewH = $(this).height();
	var contentH = $(this).get(0).scrollHeight;
	var scrollTop = $(this).scrollTop();
	if (scrollTop / (contentH - viewH) >= 0.95) {
		if (new Date().getTime() - begin_scroll > 500) {
			var params = {
				eaction: "obd_build",
				page: ++list_page,
				resid: $("#collect_new_build_list").val() == '-1' ? '':$("#collect_new_build_list").val(),
				grid_id_short: grid_id_short,
				substation:substation,
				village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val(),
				city_id:parent.global_current_city_id,
				zy:zy_type
			}
			buildOBDListScroll(params, 0);
		}
		begin_scroll = new Date().getTime();
	}
});

function buildOBDListScroll(params,flag){
	var $build_list = $("#obd_build_info_list");
	$.post(url,params, function (data) {
		data = $.parseJSON(data);
		for (var i = 0, l = data.length; i < l; i++) {
			var d = data[i];
			var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
			//newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.GRID_ID + "',this)\" >" + d.GRID_NAME + "</a></td>";
			newRow += "<td style='width: 150px;text-align:left;padding-left:5px;'><a href=\"javascript:void(0);\">" + d.RESFULLNAME + "</a></td>";
			newRow += "<td style='width: 150px;text-align:center;'>" + d.EQP_ID + "</td><td style='width: 60px'>" + d.USER_PORT_RATE +
			"%</td><td style='width: 50px'>" + d.PORT_ID_CNT + "</td><td style='width: 70px'>" + d.USE_PORT_CNT + "</td></tr>";
			//"</td><td style='width: 50px'>" + d.ZE_TEXT + "</td><td style='width: 50px'>" + d.FI_TEXT + "</td></tr>";
			$build_list.append(newRow);
		}
		if (data.length == 0 && flag) {
			$build_list.empty();
			$build_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
			return;
		}
	});
}

function load_odb_build_sum_cnt(){
	var params = {
		eaction: "obd_type_cnt_build",
		resid: $("#collect_new_build_list").val() == '-1' ? '':$("#collect_new_build_list").val(),
		substation: substation,
		grid_id_short: grid_id_short,
		city_id:parent.global_current_city_id,
		village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val(),
		zy:zy_type
	}
	$.post(url,params,function(data){
		data = $.parseJSON(data);
		$("#resource_obd_build_count").text(data.SUM_CNT);
	});
}

function load_obd_build_type_cnt(){
	var params = {
		eaction: "obd_type_cnt_build",
		resid: $("#collect_new_build_list").val() == '-1' ? '':$("#collect_new_build_list").val(),
		grid_id_short: grid_id_short,
		substation:substation,
		city_id:parent.global_current_city_id,
		village_id: $("#obd_new1_village_list").val() == '-1' ? '' : $("#obd_new1_village_list").val()
	}
	$.post(url,params,function(data){
		if(data!=null && data!="null"){
			var data1 = $.parseJSON(data);
			$("#res_obd_all_count").text("("+data1.SUM_CNT+")");
			//$("#res_0obd_count").text("("+data1.OBD0_CNT+")");
			$("#res_0obd_count").text("("+data1.OBD01_CNT+")");
			$("#res_1obd_count").text("("+data1.OBD1_CNT+")");
			$("#res_hobd_count").text("("+data1.HOBD_CNT+")");
		}
	});
}

//做名字查询时使用, 数据库太慢
var collect_state = 0, collect_bselect = -1;
//flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.
function load_build_list(selected) {
	if('${sessionScope.UserInfo.LEVEL}'==1 || '${sessionScope.UserInfo.LEVEL}'==2 || '${sessionScope.UserInfo.LEVEL}'==3)
		return;
	var $build_list =  $("#collect_new_build_list");
	before_load_build_list();
	//如果是通过 select选择的话,select_count重新开始计数.
	if (selected) {
		select_count = 0;
	}
	//只有当第一次改变input的时候将值置位1;
	if (select_count <= 1) {
		$build_list.empty();
		build_list = [];
		//回写,且只有在手动选中的时候才进行回写.
		if (select_count == 0) {
			$("#collect_new_village_name").val($("#collect_new_village_list").find("option:selected").text());
		}
		var params = {
			eaction: "collect_new_build_list",
			grid_id: $("select[name=collect_new_grid_list]").val() == '-1' ? '' : $("select[name=collect_new_grid_list]").val(),
			village_id: $("#collect_new_village_list").val() == '-1' ? '' : $("#collect_new_village_list").val(),
			substation: parent.substation,
			"grid_id_short":grid_id_short
		};
		$.post(url, params, function(data) {
			data = $.parseJSON(data);
			if (data.length != 0) {
				var d, newRow = "<option value='-1' select='selected'></option>";
				for (var i = 0, length = data.length; i < length; i++) {
					d = data[i];
					newRow += "<option value='" + d.SEGM_ID + "' select='selected'>" + d.STAND_NAME + "</option>";
					build_list.push(d);
				}
				$build_list.append(newRow);
			}
			if (is_first_time_load) {
				$("#collect_new_build_list option[value=${param.res_id}]").attr("selected", "selected");
				$("#collect_new_build_list").change();
				is_first_time_load = false;
			}
		})
	}
}

function load_build_name_list() {
	console.log(1);
	setTimeout(function() {
		//下拉列表显示
		var $build_list =  $("#collect_new_build_name_list");
		$build_list.empty();
		if (select_count <= 1) {
			before_load_build_list();
		}

		var build_name = $("#collect_new_build_name").val().trim();
		if (build_name != '') {
			var temp;
			var newRow = "";
			for (var i = 0, length = build_list.length, count = 0; i < length; i++) {
				if ((temp = build_list[i].TEXT).indexOf(build_name) != -1) {
					newRow += "<li title='" + temp + "' onclick='select_build(\""+ temp + "\",\"" +
					build_list[i].CODE + "\"," + i + ")'>" + temp + "</li>";
					count++;
				}
				if (count >= 15) {
					break;
				}
			}
			$build_list.append(newRow);
			$("#collect_new_build_name_list").show();
		} else {
			$("#collect_new_build_name_list").hide();
		}

		//联动改变 select框, 只要不做点击, 都会将select改回全部.
		$("#collect_new_build_list option:eq(0)").attr('selected','selected');
		select_count++;
	}, 300)
}
function select_build(name, id, index) {
	$("#collect_new_build_list option[value=" + id + "]").attr('selected','selected');
	$("#collect_new_build_name").val("");
	$("#collect_new_build_name_list").hide();
	$("#collect_new_build_list").change();
}
</script>