<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:set var="datagrid_url">
	<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_summary_action.jsp?eaction=province" />
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
	</style>
</head>
<body>
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
	</style>
	<div class="sub_box" style="height:auto;width:100%;margin:0 auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0 auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:36px;inline-height:36px;text-align:center;"><h4>城&nbsp;市&nbsp;支&nbsp;局&nbsp;小&nbsp;区&nbsp;信&nbsp;息&nbsp;统&nbsp;计</h4></div>
			<div class="tab_box table_cont_wrapper">
				<div class="sub_">
					<table cellspacing="0" cellpadding="0" class="search">
						<tr>
							<td width="50"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp公&nbsp司&nbsp:</div></td>
							<td class="area_select">
								<a href="javascript:void(0)" class="selected">全省</a>
								<a href="javascript:void(0)" onclick="cityToBureau(931)">兰州</a>
								<a href="javascript:void(0)" onclick="cityToBureau(938)">天水</a>
								<a href="javascript:void(0)" onclick="cityToBureau(943)">白银</a>
								<a href="javascript:void(0)" onclick="cityToBureau(937)">酒泉</a>
								<a href="javascript:void(0)" onclick="cityToBureau(936)">张掖</a>
								<a href="javascript:void(0)" onclick="cityToBureau(935)">武威</a>
								<a href="javascript:void(0)" onclick="cityToBureau(945)">金昌</a>
								<a href="javascript:void(0)" onclick="cityToBureau(947)">嘉峪关</a>
								<a href="javascript:void(0)" onclick="cityToBureau(932)">定西</a>
								<a href="javascript:void(0)" onclick="cityToBureau(933)">平凉</a>
								<a href="javascript:void(0)" onclick="cityToBureau(934)">庆阳</a>
								<a href="javascript:void(0)" onclick="cityToBureau(939)">陇南</a>
								<a href="javascript:void(0)" onclick="cityToBureau(941)">甘南</a>
								<a href="javascript:void(0)" onclick="cityToBureau(930)">临夏</a>
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
									<th width="10%">分公司</th>
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
						<div class="t_body" id="big_table_info_div">
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
	var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=1, query_sort = '0', eaction = "province",acct_mon='201803';
	//如果已经没有数据, 则不再次发起请求.
	var hasMore = true;
	$(function(){
		var user_level = '${sessionScope.UserInfo.LEVEL}';

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
			flag: query_flag,
			acct_mon:acct_mon
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
					flag: query_flag,
					acct_mon:acct_mon
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
					$("#all_count").html(data[1].C_NUM);
				}
				for (var i = 0, l = data.length; i < l; i++) {
					var d = data[i];
					var newRow = "<tr><td style='width: 9%'>" + (++seq_num) + "</td>";
					newRow += "<td style='width: 10%;text-align:center;'><a href='javascript:cityToBureau("+ d.LATN_ID+");'>" + d.LATN_NAME + "</td>"
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
						$list.append("<tr><td style='text-align:center' colspan=8 >没有查询到数据</td></tr>")
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
	}

	function change_region(type) {
		$(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
		clear_data();
		query_flag = type;
		$("#big_table_collect_type > span").eq(0).click();
	}
</script>