<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="bureau_list">
	SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM gis_data.db_cde_grid WHERE latn_id = '${param.city_id}' and branch_type = 'a1' order by REGION_ORDER_NUM
</e:q4l>
<e:set var="datagrid_url">
	<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_summary_action.jsp?eaction=city&city_id=${param.city_id}" />
</e:set>
<html>
<head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  	<meta http-equiv="pragma" content="no-cache">
  	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  	<meta http-equiv="expires" content="0">
  	<title>城市支局小区信息统计</title>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<c:resources type="easyui,app" style="b"/>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_broadband_business.css?version=1.0"/>' rel="stylesheet" type="text/css" />
	<style>
		#tools{height:95%;}
		#query_div{width:120px;height:47px;background:#0f2c92;padding:0;position:absolute;display:none;}
		#query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
		.ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
		#query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
		.datagrid-pager.pagination table tbody tr td span{color:#264f75;}
		.pagination .pagination-num {color:#264f75;}
		@media screen and (max-height: 1080px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.backup{right:1.4%;top:2.5%;}
			.tab_box{margin-top:18px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.tab_box{margin-top:13px;}
		}
		body{background:rgb(237, 248, 255);}
		.datagrid-header {height:auto;line-height:auto;}
		.bureau_select a {    display: block;
			float: left;
			margin-right: 20px;width:auto;}
		.bureau_select a.selected {background-color: #ff8a00;
			width: auto;
			height: auto;
			text-align: center;
			border-radius: 4px;
			color: #fff;}
	</style>
</head>
<body>
	<div class="sub_box" style="height:auto;width:100%;margin:0 auto;position: absolute;">
	<div style="height:98%;width:100%;margin:0 auto;position: absolute;" id="tab_div">
		<div style="width:100%;height:36px;inline-height:36px;text-align:center;"><h4>城&nbsp;市&nbsp;支&nbsp;局&nbsp;小&nbsp;区&nbsp;信&nbsp;息&nbsp;统&nbsp;计</h4></div>
		<div class="tab_box table_cont_wrapper">
			<div class="sub_">
				<table cellspacing="0" cellpadding="0" class="search">
					<tr>
						<td width="100"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp;&nbsp;公&nbsp;&nbsp;司&nbsp:</div></td>
						<td class="area_select">
							<a href="javascript:void(0)" onclick="citySwitch(999)">全省</a>
							<a href="javascript:void(0)" onclick="citySwitch(931)">兰州</a>
							<a href="javascript:void(0)" onclick="citySwitch(938)">天水</a>
							<a href="javascript:void(0)" onclick="citySwitch(943)">白银</a>
							<a href="javascript:void(0)" onclick="citySwitch(937)">酒泉</a>
							<a href="javascript:void(0)" onclick="citySwitch(936)">张掖</a>
							<a href="javascript:void(0)" onclick="citySwitch(935)">武威</a>
							<a href="javascript:void(0)" onclick="citySwitch(945)">金昌</a>
							<a href="javascript:void(0)" onclick="citySwitch(947)">嘉峪关</a>
							<a href="javascript:void(0)" onclick="citySwitch(932)">定西</a>
							<a href="javascript:void(0)" onclick="citySwitch(933)">平凉</a>
							<a href="javascript:void(0)" onclick="citySwitch(934)">庆阳</a>
							<a href="javascript:void(0)" onclick="citySwitch(939)">陇南</a>
							<a href="javascript:void(0)" onclick="citySwitch(941)">甘南</a>
							<a href="javascript:void(0)" onclick="citySwitch(930)">临夏</a>
						</td>
					</tr>
					<tr>
						<td width="100"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分局/区县:</div></td>
						<td>
							<div class="bureau_select"></div>
						</td>
					</tr>
				</table>
				<div class="sub_b">
					<div class="all_count">总记录数：<span id="all_count"></span></div>
					<div style="margin-right: 14px;">
						<table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
							<thead>
							<tr>
								<th width="9%">序号</th>
								<th width="10%">县局</th>
								<th width="9%">城市网格数</th>
								<th width="9%">城市小区数</th>
								<th width="9%">光宽用户数</th>
								<th width="9%">沉默用户</th>
								<th width="9%">沉默率</th>
								<th width="9%">拆机用户</th>
								<th width="9%">拆机率</th>
								<th width="9%">欠费用户</th>
								<th width="9%">欠费率</th>
							</tr>
							</thead>
						</table>
					</div>
					<div class="t_body" id="big_table_info_div" style="height:200px;">
						<table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list" style="width: 100%">
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<script type="text/javascript">
	var url4data = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_summary_action.jsp" />';
	var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "city",acct_mon='201803';
	var city_id_temp = '${param.city_id}';
	var bureau_id_temp = '${param.bureau_id}';
	//var branch_id_temp = '${param.branch_id}';
	//var grid_id_temp = '${param.grid_id}';
	var user_level = '${sessionScope.UserInfo.LEVEL}';
	if(city_id_temp=="")
		city_id_temp = city_id_for_village_tab_view;
	else
		city_id_for_village_tab_view = city_id_temp;
	//如果已经没有数据, 则不再次发起请求.
	var hasMore = true;
	$(function(){
		initCitySelect(user_level);
		citySelectCss(city_id_temp);

		initBureauSelect(user_level);
		bureauSelectCss(bureau_id_temp);
		$("#model_to_rank").click(function(){
			if($("#query_div").is(":hidden")){
				var top_px = $(this).offset().top;
				$("#query_div").css({"left":$(this).offset().left+35,"top":top_px+4,"height":$(this).height()+6});
				$("#query_div").show();
			}else{
				$("#query_div").hide();
			}
		});

		//返回地图模式
		$("#nav_hidetiled").click(function(){
			load_map_view();
			//parent.load_map_view();
		});

		$(".t_body").css("max-height", document.body.offsetHeight*0.94 - 118 - $("#big_table_change").height() - $("#big_table_content").height());
		$(".t_body>table").width($(".table1:eq(0)").width()+2);

		//当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
		$('.t_body').scroll(function () {
			//alert($(this).scrollLeft());
			$('#table_head').css('margin-left', -($('.t_body').scrollLeft()));
			$('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
		});
		$('#tbody2').scroll(function () {
			$('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
		});
		$("#closeTab").on("click",function(){
			load_map_view();
		});

		$("#big_table_collect_type > span").each(function (index) {
			$(this).on("click", function () {
				$(this).addClass("active").siblings().removeClass("active");
				var $show_div = $("#big_table_content_" + index);
				$show_div.show();
				$("#big_table_content").children().not($show_div).hide();
				var temp = flag;
				clear_data();
				flag = temp;
				load_list(index);
			});
		});
		$("#big_table_collect_type span").eq(0).click();
		$(".t_body").css("max-height", document.body.offsetHeight*0.94 - 106 - $("#big_table_change").height() - $("#big_table_content").height());

		load_list();
	});
	function cityToBureau(city_id){
		initListDiv(2,city_id,'999');
	}

	function query_list_sort() {
		var temp = query_flag;
		var temp2 = (query_sort == '0'  ? '1' : '0');
		clear_data();
		query_sort = temp2;
		query_flag = temp;
		load_list();
	}

	function load_list() {
		var params = {
			eaction: eaction,
			page: 0,
			city_id: city_id_temp,
			bureau_id: bureau_id_temp,
			acct_mon:acct_mon,
			flag:query_flag
		}
		listScroll(params, true, eaction);
	}

	$("#big_table_info_div").scroll(function () {
		var viewH = $(this).height();
		var contentH = $(this).get(0).scrollHeight;
		var scrollTop = $(this).scrollTop();
		if (scrollTop / (contentH - viewH) >= 0.95) {
			if (new Date().getTime() - begin_scroll > 500) {
				var params = {
					eaction: eaction,
					page: ++page_list,
					city_id: city_id_temp,
					bureau_id: bureau_id_temp,
					acct_mon:acct_mon,
					flag: query_flag
				}
				listScroll(params, false, eaction);
			}
			begin_scroll = new Date().getTime();
		}
	});

	function listScroll(params, flag, action) {
		listCollectScroll(params, flag);
	}

	function listCollectScroll(params, flag) {
		var $list = $("#big_tab_info_list");
		if (hasMore) {
			$.post(url4data, params, function (data) {
				data = $.parseJSON(data);
				if (data.length == 0 && flag) {
					$("#all_count").html('0');
				} else {
					$("#all_count").html(data[0].C_NUM);
				}
				for (var i = 0, l = data.length; i < l; i++) {
					var d = data[i];
					var newRow = "<tr><td style='width: 9%'>" + (++seq_num) + "</td>";
					newRow += "<td style='width: 10%;text-align:center;'>" + d.BUREAU_NAME + "</td>"
					newRow += "<td style='width: 9%'>" + d.CITY_GRID_CNT +
					"</td><td style='width: 9%'>" + d.VILLAGE_CNT +
					"</td><td style='width: 9%'>" + d.ARRIVE_CNT +
					"</td><td style='width: 9%'>" + d.CM_CNT +
					"</td><td style='width: 9%'>" + d.CM_LV +
					"</td><td style='width: 9%'>" + d.REMOVE_CNT +
					"</td><td style='width: 9%'>" + d.REMOVE_LV +
					"</td><td style='width: 9%'>" + d.OWE_CNT +
					"</td><td style='width: 9%'>" + d.OWE_LV +
					"</td></tr>";
					$list.append(newRow);
				}
				//只有第一次加载没有数据的时候显示如下内容
				if (data.length == 0) {
					hasMore = false;
					if (flag) {
						$list.empty();
						$list.append("<tr><td style='text-align:center' colspan=6 >没有查询到数据</td></tr>")
					}
				}
			});
		}
	}

	$("#collect_tabs_change > div").each(function (index) {
		$(this).on("click", function () {
			$(this).addClass("active").siblings().removeClass("active");
		});
	})

	function clear_data() {
		begin = 0, end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0
		flag = '1', query_sort = '0';
		$("#big_tab_info_list").empty();
		$("#all_count").empty();
	}

	function change_region(type) {
		$(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
		clear_data();
		query_flag = type;
		$("#big_table_collect_type > span").eq(0).click();
	}

	function initCitySelect(user_level){
		if(user_level>1){
			$(".area_select").children().css({"cursor":"default"});
			$(".area_select").children().attr("disabled","disabled");
		}
	}
	function citySelectCss(city_id_temp){
		$(".area_select a[onclick='citySwitch("+city_id_temp+")']").addClass("selected");
		$(".area_select a[onclick='citySwitch("+city_id_temp+")']").siblings().removeClass("selected");
	}
	function bureauSelectCss(bureau_id){
		bureau_id_temp = bureau_id;
		$(".bureau"+bureau_id_temp).addClass("selected");
		$(".bureau"+bureau_id_temp).siblings().removeClass("selected");
	}
	function initBureauSelect(user_level){
		$(".bureau_select").append("<a href=\"javascript:void(0)\" class=\"bureau999\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('999')\">全部</a>");
		var bureau_json = '${e:java2json(bureau_list.list)}';
		bureau_json = $.parseJSON(bureau_json);
		for(var i = 0,l = bureau_json.length;i<l;i++){
			var bureau_item = bureau_json[i];
			$(".bureau_select").append("<a href=\"javascript:void(0)\" class=\"bureau"+bureau_item.BUREAU_NO+"\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('"+bureau_item.BUREAU_NO+"')\">"+bureau_item.BUREAU_NAME+"</a>");
		}
		if(user_level>2){
			$(".bureau_select").children().css({"cursor":"default"});
		}
	}
	function changeBureauSelect(){
		$.post(url4Query,{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
			var bureau_json = $.parseJSON(data);
			$(".bureau_select").empty();
			$(".bureau_select").append("<a href=\"javascript:void(0)\" class=\"bureau999 selected\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('999')\">全部</a>");
			for(var i = 0,l = bureau_json.length;i<l;i++){
				var bureau_item = bureau_json[i];
				$(".bureau_select").append("<a href=\"javascript:void(0)\" class=\"bureau"+bureau_item.BUREAU_NO+"\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('"+bureau_item.BUREAU_NO+"')\">"+bureau_item.BUREAU_NAME+"</a>");
			}
		});
	}

	function font_important_formatter(value,rowData){
		return "<span style=\"color:#FE7A23;\">"+value+"</span>";
	}
	function font_clickable_formatter1(value,rowData){
		if(window.screen.height<=768){
			if(value.length>7)
				return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:bureauToSub('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"');\">"+value.substr(0,7)+"...</a>";
		}else{
			if(value.length>14)
				return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:bureauToSub('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"');\">"+value.substr(0,13)+"...</a>";
		}

		return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:bureauToSub('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"');\">"+value+"</a>";
	}
	function font_clickable_formatter2(value,rowData){
		if(value>0)
			return "<a id=\"showGrid"+rowData.BUREAU_NO+"\" style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showGridHasNoVillage('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"');\">"+value+"</a>";
		return value;
	}
	function bureauToSub(city_id,bureau_id,union_org_code){
		initListDiv(4,city_id,bureau_id,union_org_code);
	}

	function backup(level){
		initListDiv(1);
	}
	function showGridHasNoVillage(city_id,bureau_id){
		var pos = $('#showGrid'+bureau_id).offset();
		layer.open({
			type: 1,
			title: '未上小区网格列表',
			area: layer_win_size,
			shade: 0,
			offset: [pos.top,pos.left-layer_win_size[0]],
			content: $("#gridDetailHasNoVillageDiv"),
			success: function(){
				$('#dg').datagrid({
					url:url4Query,
					pagination:true,
					rownumbers:true,
					fitColumns:true,
					queryParams: {
						"eaction": "getGridDetailHasNoVillage",
						"bureau_id":bureau_id
					},
					columns:[[
						{field:'LATN_NAME',title:'分公司',width:"20%"},
						{field:'BUREAU_NAME',title:'区县/分局',width:"20%"},
						{field:'BRANCH_NAME',title:'支局名称',halign:"center",align:'left',width:"31%"},
						{field:'GRID_NAME',title:'网格名称',halign:"center",align:'left',width:"31%"}
					]],
					onLoadSuccess: function(){
						//$('#dg').datagrid("resize");
						//$("#gridDetailHasNoVillageDiv").find(".datagrid-view").css({"height":$("#gridDetailHasNoVillageDiv").height()-$(".pagination").height()-15});
					}
				});

			}
		});
	}
	function citySwitch(city_id){
		if(user_level>1)
			return;
		if(city_id =='999'){
			backup(1);
			return;
		}
		citySelectCss(city_id);
		city_id_temp = city_id;
		clear_data();
		load_list();
	}
	function bureauSwitch(bureau_id){
		if(user_level>2)
			return;
		if(bureau_id=='999')
			bureau_id = "";
		bureau_id_temp = bureau_id;
		bureauSelectCss(bureau_id_temp);
		clear_data();
		load_list();
	}
	function hideDivWin(){
		$("#gridDetailHasNoVillageDiv").hide();
	}
</script>