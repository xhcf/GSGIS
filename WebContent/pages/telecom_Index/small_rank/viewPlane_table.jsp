<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today_ymd">
	select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'YYYY'||'"年"'||'MM'||'"月"'||'DD'|| '"日"') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '1'
</e:q4o>
<e:q4o var="today_time">
	select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'YYYY'||'"年"'||'MM'||'"月"'||'DD'|| '"日"') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '1'
</e:q4o>
<e:q4o var="now">
	select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="lastMonth">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '3'
</e:q4o>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>划小排名</title>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
	<!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css"/>' rel="stylesheet" type="text/css"
		  media="all"/>
	<style>
	.tab_menu{margin-top:-20px;}
	.tab_box{margin-top:92px;}
	</style>
</head>
<body>
<div class="sub_box" style="height:auto;width:100%;margin:0 auto;position: absolute;">

	<div style="height:98%;width:100%;margin:0.3% auto;position: absolute;" id="tab_div">
		<div style="width:100%;height:36px;inline-height:36px;text-align:center;"><h4>划&nbsp小&nbsp承&nbsp包&nbsp单&nbsp元&nbsp排&nbsp名</h4></div>

		<div class="tab_menu">
			<ul>
				<li id="sel" class="selected" onclick="sub()"><a href="javascript:void(0)">支局排名</a> &nbsp;&nbsp;|</li>
				<li><a href="javascript:void(0)" onclick="wg()">网格排名</a></li>
			</ul>
		</div>
		<div class="tab_box">
			<div class="sub_">
				<table cellspacing="0" cellpadding="0" class="search">
					<tr>
						<td width="50">
							<div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp公&nbsp司&nbsp:</div>
						</td>
						<td colspan="5" class="area_select">
							<a href="javascript:void(0)" onclick="city(999)">全省</a>
							<a href="javascript:void(0)" onclick="city(931)">兰州</a>
							<a href="javascript:void(0)" onclick="city(938)">天水</a>
							<a href="javascript:void(0)" onclick="city(943)">白银</a>
							<a href="javascript:void(0)" onclick="city(937)">酒泉</a>
							<a href="javascript:void(0)" onclick="city(936)">张掖</a>
							<a href="javascript:void(0)" onclick="city(935)">武威</a>
							<a href="javascript:void(0)" onclick="city(945)">金昌</a>
							<a href="javascript:void(0)" onclick="city(947)">嘉峪关</a>
							<a href="javascript:void(0)" onclick="city(932)">定西</a>
							<a href="javascript:void(0)" onclick="city(933)">平凉</a>
							<a href="javascript:void(0)" onclick="city(934)">庆阳</a>
							<a href="javascript:void(0)" onclick="city(939)">陇南</a>
							<a href="javascript:void(0)" onclick="city(941)">甘南</a>
							<a href="javascript:void(0)" onclick="city(930)">临夏</a>
						</td>
					</tr>
					<tr>
						<td width="100">&nbsp;&nbsp;&nbsp;&nbsp;单元类型：</td>
						<td width="400"><input type="radio" name="unionType" checked value=""
											   onclick="union(this.value)" style="margin-left: 10px"/>&nbsp;&nbsp;全部
							&nbsp;&nbsp;&nbsp;&nbsp;

							<input type="radio" name="unionType" value="a1" onclick="union(this.value)"/>&nbsp;城市&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="unionType" value="b1" onclick="union(this.value)"/>&nbsp;农村
						</td>
						<%--<td>&nbsp;
                        <input type="text" class="text1" id="sub_name" placeholder="请输入支局名称"/><button id="sub_click" onclick="sub_queryname()">查询&nbsp;&nbsp;</button></td>
                        <td></td>--%>
						<td width="100">&nbsp;&nbsp;&nbsp;&nbsp;支局名称&nbsp：</td>
						<td colspan="3">&nbsp;
							<input type="text" class="text1" id="sub_name" style="width: 280px;height:24px!important; "
								   placeholder=""/>
							<button id="sub_click" class="btn_cx" style="width: 70px;margin-left: 10px"
									onclick="sub_queryname()">查&nbsp;询
							</button>
						</td>

					</tr>
				</table>
				<div class="huizong">
					<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div>
					<div style="display: inline-block;margin-left: 28px">汇总：</div>
					<span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span
						id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span>
				</div>
				<div class="sub_b" style="border:0px;width:97.5%;margin:2px auto;">
					<table cellspacing="0" cellpadding="0" class="table1" id="table_head">
						<thead>
						<tr>
							<th rowspan="3" style="border-bottom: 1px solid #a7d1f3">
								<div class="th1">序号</div>
							</th>
							<th rowspan="3" align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th2">本地网</div>
							</th>
							<th rowspan="3" align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th3">区县</div>
							</th>
							<th rowspan="3" align="center" halign="center" formatter="formatterper2"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="th4">支局名称</div>
							</th>
							<th rowspan="3" align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th5">类型</div>
							</th>
							<!-- <th field="" colspan="4"  style="border-right: 1px solid #adadad;">支局基本信息</th> -->
							<th field="AAA" colspan="8">市场</th>
							<th field="BBB" colspan="4" rowspan="2">收入</th>
							<th field="CCC" colspan="2" rowspan="2">利润</th>
							<th field="DDD" colspan="6">发展</th>

						</tr>
						<tr>
							<th align="center" halign="center" colspan="5">宽带</th>
							<th align="center" halign="center" colspan="3">竞争</th>
							<th align="center" halign="center" colspan="2">移动</th>
							<th align="center" halign="center" colspan="2">宽带</th>
							<th align="center" halign="center" colspan="2">ITV</th>
						</tr>
						<tr>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th6">住户数</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th7">宽带数</div>
							</th>
							<th align="center" halign="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="th8" onclick="sortAble()">市场占有率</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th9">端口数</div>
							</th>
							<!-- 					<th field="FTTH_PORT_ZY_NUM" align="right" halign="center">端口占用数</th>
                             -->
							<th align="center" halign="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="th10">端口占有率</div>
							</th>


							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th11">移动渗透率</div>
							</th>
							<th align="center" halign="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="th12">宽带入户率</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th13">电视入户率</div>
							</th>

							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th14">预算目标(万元)</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th15">本年累计(万元)</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th16">进度</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th17">当月收入(万元)</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th18">本年利润(万元)</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="th19">当月利润(万元)</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th20">本月</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th21">当日</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th22">本月</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th23">当日</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th24">本月</div>
							</th>
							<th align="center" halign="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="th25">当日</div>
							</th>

						</tr>
						</thead>
					</table>
					<div class="t_body" id="scroll_target">
						<table cellspacing="0" cellpadding="0" class="table1">
							<tbody id="zhiju_rank_table">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="grid_" style="display:none;">
				<table cellspacing="0" cellpadding="0" class="search">
					<tr>
						<td>
							<div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp;公&nbsp;司&nbsp;:</div>
						</td>
						<td colspan="5" class="area_select">
							<a href="javascript:void(0)" onclick="grid(999)">全省</a>
							<a href="javascript:void(0)" onclick="grid(931)">兰州</a>
							<a href="javascript:void(0)" onclick="grid(938)">天水</a>
							<a href="javascript:void(0)" onclick="grid(943)">白银</a>
							<a href="javascript:void(0)" onclick="grid(937)">酒泉</a>
							<a href="javascript:void(0)" onclick="grid(936)">张掖</a>
							<a href="javascript:void(0)" onclick="grid(935)">武威</a>
							<a href="javascript:void(0)" onclick="grid(945)">金昌</a>
							<a href="javascript:void(0)" onclick="grid(947)">嘉峪关</a>
							<a href="javascript:void(0)" onclick="grid(932)">定西</a>
							<a href="javascript:void(0)" onclick="grid(933)">平凉</a>
							<a href="javascript:void(0)" onclick="grid(934)">庆阳</a>
							<a href="javascript:void(0)" onclick="grid(939)">陇南</a>
							<a href="javascript:void(0)" onclick="grid(941)">甘南</a>
							<a href="javascript:void(0)" onclick="grid(930)">临夏</a>
						</td>
					</tr>
					<tr>
						<td width="100">&nbsp;&nbsp;&nbsp;&nbsp;单元类型：</td>
						<td width="400"><input type="radio" name="wg_grid" checked value=""
											   onclick="union_wg(this.value)" style="margin-left: 10px"/>&nbsp;&nbsp;全部
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="wg_grid" value="a1" onclick="union_wg(this.value)"/>&nbsp;城市&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="wg_grid" value="b1" onclick="union_wg(this.value)"/>&nbsp;农村
						</td>
						<td width="100">&nbsp;&nbsp;&nbsp;&nbsp;网格名称&nbsp：</td>
						<td colspan="3">&nbsp;<input type="text" class="text1"
													 style="width: 280px;height:24px!important;margin-left: 5px "
													 id="grid_name" placeholder=""/>
							<button id="grid_click" class="btn_cx" style="width: 70px;margin-left: 10px"
									onclick="grid_click()">查&nbsp;询
							</button>
						</td>
					</tr>
				</table>
				<div class="huizong">
					<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left:20px"></div>
					<div style="display: inline-block;margin-left: 28px">汇总：</div>
					<span>网格</span><span id="total_wg"
										 style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="wg_city"
																											style="color:#ff8a00 "></span><span>个, </span><span>农村</span><span
						id="wg_notcity" style="color:#ff8a00 "></span><span>个</span>
				</div>
				<div class="grid_b" style="border:0px;width:97.5%;margin:2px auto;">
					<table cellspacing="0" cellpadding="0" class="table2" id="table_head2">

						<thead>
						<tr>
							<th rowspan="3" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh1">序号</div>
							</th>
							<!-- <th colspan="4" style="border-right: 1px solid #adadad;">网格基本信息</th> -->
							<th rowspan="3" align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh2">本地网</div>
							</th>
							<th rowspan="3" align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh3">区县</div>
							</th>
							<th rowspan="3" align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh4">支局名称</div>
							</th>
							<th rowspan="3" align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh5">网格名称</div>
							</th>
							<th rowspan="3" align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh6">类&nbsp型</div>
							</th>
							<th colspan="8">市场</th>
							<th colspan="4" rowspan="2">收入</th>
							<th colspan="6">发展</th>
						</tr>
						<tr>
							<th colspan="5">宽带</th>
							<th colspan="3">竞争</th>
							<th colspan="2">移动</th>
							<th colspan="2">宽带</th>
							<th colspan="2">ITV</th>
						</tr>
						<tr>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh7">住户数</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh8">宽带数</div>
							</th>
							<th align="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh9" onclick="sortAble_grid()">市场占有率</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh10">端口数</div>
							</th>
							<!-- 				<th field="FTTH_PORT_ZY_NUM" align="right" halign="center">端口占用数</th>
	 -->
							<th align="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh11">端口占有率</div>
							</th>
							<th align="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh12">移动渗透率</div>
							</th>
							<th align="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh13">宽带入户率</div>
							</th>
							<th align="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh14">电视入户率</div>
							</th>

							<th align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh15">预算目标(万元)</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh16">本年累计(万元)</div>
							</th>
							<th align="center" sortable="true" formatter="formatterper"
								style="border-bottom: 1px solid #a7d1f3">
								<div class="thh17">进度</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3">
								<div class="thh18">本月</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh19">当日</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh20">本月</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh21">当日</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh22">本月</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh23">当日</div>
							</th>
							<th align="center" style="border-bottom: 1px solid #a7d1f3;">
								<div class="thh24">本月</div>
							</th>
						</tr>
						</thead>
					</table>
					<div class="t_body" id="tbody2" id="scroll_target_wg">
						<table cellspacing="0" cellpadding="0" class="table2" style="height:380px;overflow:scroll;">
							<tbody id="wangge_rank_table">

							</tbody>
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
	var city_union = '';
	var city_id_temp = global_current_city_id;
	var user_level = '${sessionScope.UserInfo.LEVEL}';
	var begin = 0;
	var end = 30;
	var sub__name = '';
	var grid__name = '';
	var seq_um = 0;
	var globle_sort_world = '';
	$(function(){
		$(".t_body").height($(window).height()-240);

		sub_count();
		sub_rank();

		var $div_li =$("div.tab_menu ul li");
		$div_li.click(function(){
			$(this).addClass("selected")            //当前<li>元素高亮
					.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
			var index =  $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
			$("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
					.eq(index).show()   //显示 <li>元素对应的<div>元素
					.siblings().hide(); //隐藏其它几个同辈的<div>元素
		});

		$(".table1>tbody>tr").on("click", function () {
			$(this).parent().find("tr.focus").toggleClass("focus");//取消原先选中行
			$(this).toggleClass("focus");//设定当前行为选中行
		});

		if(user_level==1) {
			$(".area_select a").click(function () {

				$(this).addClass("selected");
				$(this).siblings().removeClass("selected")

			});
		}

		$(".area_select a[onclick='city("+city_id_temp+")']").addClass("selected");
		$(".area_select a[onclick='city("+city_id_temp+")']").siblings().removeClass("selected");

		$(".area_select a[onclick='grid("+city_id_temp+")']").addClass("selected");
		$(".area_select a[onclick='grid("+city_id_temp+")']").siblings().removeClass("selected");

		var begin = new Date().getTime();
		//支局
		$("#scroll_target").scroll(function(){
			var viewH =$(this).height();
			var contentH =$(this).get(0).scrollHeight;
			var scrollTop =$(this).scrollTop();
			//alert(scrollTop / (contentH - viewH));

			if(scrollTop / (contentH - viewH)>=0.95){
				if(new Date().getTime() - begin>500){
					if(globle_sort_world==''){
						sub_rank();
					}else{
						sub_sort(globle_sort_world);
					}
					begin = new Date().getTime();
				}
			}
		});

		//网格
		$("#tbody2").scroll(function(){
			var viewH =$(this).height();
			var contentH =$(this).get(0).scrollHeight;
			var scrollTop =$(this).scrollTop();
			//alert(scrollTop / (contentH - viewH));

			if(scrollTop / (contentH - viewH)>=0.95){
				if(new Date().getTime() - begin>500){
					if(globle_sort_world==''){
						wg_rank();
					}else{
						sub_sort_grid(globle_sort_world);
					}
					begin = new Date().getTime();
				}
			}
		});

		$(".tab_btn").click(function(){
			var query_sub_name = $.trim($(".tab_ipt").val());
			$('#table1').datagrid('load',{
				branch_name:query_sub_name
			});
		});

		var table_rows_array_small_screen = [15,25,35];
		var table_rows_array_big_screen = [20,30,40];
		var table_rows_array = "";
		if(window.screen.height<=768){
			table_rows_array = table_rows_array_small_screen;
		}else{
			table_rows_array = table_rows_array_big_screen;
		}

		var click_union_org_code = "";//记录上次点击过的支局id

		///$(".panel-header").css({visibility:'hidden'})

		//当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
		$('.t_body').scroll(function () {
			//alert($(this).scrollLeft());
			$('#table_head').css('margin-left', -($('.t_body').scrollLeft()));
			$('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
		});
		$('#tbody2').scroll(function () {

			$('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
		});
		$("#nav_hidetiled").click(function () {
			load_map_view();
			//parent.load_map_view();
		});
	});
	/* 点击某一个列进行排序 */
	function sortAble(sort_world) {
		begin = 0;
		end = 30;
		seq_um = 0;
		if(globle_sort_world == ''||globle_sort_world == '1'){
			globle_sort_world = '2';
		}else {
			globle_sort_world = '1';
		}
		sub_sort();
	}
	function sortAble_grid(sort_world){
		begin = 0;
		end = 30;
		seq_um = 0;
		if(globle_sort_world == ''||globle_sort_world == '1'){
			globle_sort_world = '2';
		}else {
			globle_sort_world = '1';
		}
		sub_sort_grid();
	}

	function sub_sort_grid(sort_world){

		var url_wangge = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=wg_list_detail&region_id='+city_id_temp+'&date='+'${yesterday.VAL}&mon='+'${lastMonth.VAL}&union_code_gw='+city_union+'&sort_world='+globle_sort_world;

		$.post(url_wangge,{grid_name:grid__name,begin:begin,end:end},function(data){
			data = $.trim(data);
			//console.log(data);
			data = $.parseJSON(data);
			if(begin==0){
				$("#wangge_rank_table").empty();
			}
			for(var i=0;i<data.length;i++){
				$("#wangge_rank_table").append("<tr>" +
				"<td><div>"+(++seq_um)+"</div></td>" +
				"<td><div>"+data[i].LATN_NAME+"</div></td>" +
				"<td><div>"+data[i].BUREAU_NAME+"</div></td>" +
				"<td><div>"+data[i].BRANCH_NAME+"</div></td>" +
				"<td><div>"+data[i].GRID_NAME+"</div></td>" +
				"<td><div>"+data[i].BRANCH_TYPE+"</div></td>" +
					//
				"<td><div>"+data[i].ADDR_NUM+"</div></td>" +
				"<td><div>"+data[i].KD_NUM+"</div></td>"+
				"<td><div>"+data[i].USE_RATE+"</div></td>"+
				"<td><div>"+data[i].FTTH_PORT_NUM+"</div></td>"+
				"<td><div>"+data[i].PORT_RATE+"</div></td>"+
					//
				"<td><div>"+data[i].CDMA_NUM_REATE+"</div></td>"+
				"<td><div>"+data[i].BRD_NUM_RATE+"</div></td>"+
				"<td><div>"+data[i].HOME_NUM_RATE+"</div></td>"+
					//

				"<td><div>--</div></td>"+
				"<td><div>"+data[i].Y_CUM_INCOME+"</div></td>"+
				"<td><div>"+data[i].INCOME_BUDGET_FINISH_RATE+"</div></td>"+
				"<td><div>"+data[i].FIN_INCOME+"</div></td>"+
					//
					/*    "<td><div>"+data[i].OPERATE_PROFIT_MON_YEAR+"</div></td>"+
					 "<td><div>"+data[i].OPERATE_PROFIT+"</div></td>"+*/
					//
				"<td><div>"+data[i].MOBILE_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].MOBILE_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_CUR_MON_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_DAY_NEW+"</div></td>"+
				"</tr>");

			}
			begin += 30;
			end += 30;
		});
	}

	function sub_sort() {
		var url_zhiju = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=sub_list_detail&region_id='+city_id_temp+'&mon='+'${lastMonth.VAL}&date='+'${yesterday.VAL}&union_code='+city_union+'&sort_world='+globle_sort_world;
		$.post(url_zhiju,{branch_name:sub__name,begin:begin,end:end},function(data){
			data = $.trim(data);
			//console.log(data);
			data = $.parseJSON(data);
			if(begin==0){
				$("#zhiju_rank_table").empty();
			}
			for(var i=0;i<data.length;i++){
				$("#zhiju_rank_table").append("<tr>" +
				"<td><div>"+(++seq_um)+"</div></td>" +
				"<td><div>"+data[i].LATN_NAME+"</div></td>" +
				"<td><div>"+data[i].BUREAU_NAME+"</div></td>" +
				"<td><div>"+data[i].BRANCH_NAME+"</div></td>" +
				"<td><div>"+data[i].BRANCH_TYPE+"</div></td>" +
					//
				"<td><div>"+data[i].ADDR_NUM+"</div></td>" +
				"<td><div>"+data[i].KD_NUM+"</div></td>"+
				"<td><div>"+data[i].USE_RATE+"</div></td>"+
				"<td><div>"+data[i].FTTH_PORT_NUM+"</div></td>"+
				"<td><div>"+data[i].PORT_RATE+"</div></td>"+
					//
				"<td><div>"+data[i].CDMA_NUM_REATE+"</div></td>"+
				"<td><div>"+data[i].BRD_NUM_RATE+"</div></td>"+
				"<td><div>"+data[i].HOME_NUM_RATE+"</div></td>"+
					//
				"<td><div>"+data[i].ALL_YS+"</div></td>"+
				"<td><div>"+data[i].Y_CUM_INCOME+"</div></td>"+
				"<td><div>"+data[i].INCOME_BUDGET_FINISH_RATE+"</div></td>"+
				"<td><div>"+data[i].FIN_INCOME+"</div></td>"+
					//
				"<td><div>"+data[i].OPERATE_PROFIT_MON_YEAR+"</div></td>"+
				"<td><div>"+data[i].OPERATE_PROFIT+"</div></td>"+
					//
				"<td><div>"+data[i].MOBILE_SERV_CUR_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].MOBILE_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_SERV_CUR_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_CUR_MON_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_DAY_NEW+"</div></td>"+
				"</tr>");
			}
			begin += 30;
			end += 30;
		});
	}

	function sub() {
		seq_um = 0;
		sub__name='';
		begin = 0;
		end = 30;
		$("#sub_name").val("");
		sub_count();
		sub_rank();
	}

	function sub_count() {

		var url_zhiju = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=sub_list_count&region_id='+city_id_temp+'&date='+'${yesterday.VAL}&mon='+'${lastMonth.VAL}&union_code='+city_union;
		$.post(url_zhiju,{branch_name:sub__name},function(data){
			data = $.trim(data);
			//console.log(data);
			data = $.parseJSON(data);
			var typenocity = 0;
			var typecity = 0;
			for(var i=0;i<data.length;i++){
				if(data[i].BRANCH_TYPE=='城市'){
					typecity++;
				}else{
					typenocity++;
				}
			}
			$("#total").html(data.length);
			$("#city").html(typecity);
			$("#notcity").html(typenocity);
		});
	}

	function sub_rank() {
		var url_zhiju = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=sub_list_detail&region_id='+city_id_temp+'&date='+'${yesterday.VAL}&mon='+'${lastMonth.VAL}&union_code='+city_union;
		$.post(url_zhiju,{branch_name:sub__name,begin:begin,end:end},function(data){
			data = $.trim(data);
			//console.log(data);
			data = $.parseJSON(data);
			if(begin==0){
				$("#zhiju_rank_table").empty();
				if(data.length==0){
					layer.msg("没有查询到数据")
				}
			}
			for(var i=0;i<data.length;i++){
				$("#zhiju_rank_table").append("<tr>" +
				"<td><div>"+(++seq_um)+"</div></td>" +
				"<td><div>"+data[i].LATN_NAME+"</div></td>" +
				"<td><div>"+data[i].BUREAU_NAME+"</div></td>" +
				"<td><div style=\"cursor:pointer;text-decoration:underline;\" onclick=\"javascript:subItemInGIS('"+data[i].UNION_ORG_CODE+"','"+data[i].BRANCH_NAME+"','"+data[i].ZOOM+"','"+data[i].LATN_NAME+"','"+data[i].LATN_ID+"')\">"+data[i].BRANCH_NAME+"</div></td>" +
				"<td><div>"+data[i].BRANCH_TYPE+"</div></td>" +
					//
				"<td><div>"+data[i].ADDR_NUM+"</div></td>" +
				"<td><div>"+data[i].KD_NUM+"</div></td>"+
				"<td><div>"+data[i].USE_RATE+"</div></td>"+
				"<td><div>"+data[i].FTTH_PORT_NUM+"</div></td>"+
				"<td><div>"+data[i].PORT_RATE+"</div></td>"+
					//
				"<td><div>"+data[i].CDMA_NUM_REATE+"</div></td>"+
				"<td><div>"+data[i].BRD_NUM_RATE+"</div></td>"+
				"<td><div>"+data[i].HOME_NUM_RATE+"</div></td>"+
					//
				"<td><div>"+data[i].ALL_YS+"</div></td>"+
				"<td><div>"+data[i].Y_CUM_INCOME+"</div></td>"+
				"<td><div>"+data[i].INCOME_BUDGET_FINISH_RATE+"</div></td>"+
				"<td><div>"+data[i].FIN_INCOME+"</div></td>"+
					//
				"<td><div>"+data[i].OPERATE_PROFIT_MON_YEAR+"</div></td>"+
				"<td><div>"+data[i].OPERATE_PROFIT+"</div></td>"+
					//
				"<td><div>"+data[i].MOBILE_SERV_CUR_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].MOBILE_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_SERV_CUR_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_CUR_MON_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_DAY_NEW+"</div></td>"+
				"</tr>");
			}
			begin += 30;
			end += 30;
		});
	}

	function wg() {
		$("#grid_name").val("");
		globle_sort_world='';
		seq_um = 0;
		grid__name = '';
		begin = 0;
		end = 30;
		wg_count();
		wg_rank();
	}
	function wg_count(){
		/* 网格清单 */
		var url_wangge = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=wg_list_count&region_id='+city_id_temp+'&date='+'${yesterday.VAL}&mon='+'${lastMonth.VAL}&union_code_gw='+city_union;

		$.post(url_wangge,{grid_name:grid__name},function(data){
			data = $.trim(data);
			//console.log(data);
			data = $.parseJSON(data);
			var typenocity = 0;
			var typecity = 0;
			for(var i=0;i<data.length;i++){
				if(data[i].BRANCH_TYPE=='城市'){
					typecity++;
				}else{
					typenocity++;
				}
			}
			$("#total_wg").html(data.length);
			$("#wg_city").html(typecity);
			$("#wg_notcity").html(typenocity);
		});
	}

	function wg_rank(){
		/* 网格清单 */
		var url_wangge = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=wg_list_detail&region_id='+city_id_temp+'&date='+'${yesterday.VAL}&mon='+'${lastMonth.VAL}&union_code_gw='+city_union;

		$.post(url_wangge,{grid_name:grid__name,begin:begin,end:end},function(data){
			data = $.trim(data);
			//console.log(data);
			data = $.parseJSON(data);
			if(begin==0){
				$("#wangge_rank_table").empty();
				if(data.length==0){
					layer.msg("没有查询到数据")
				}
			}
			for(var i=0;i<data.length;i++){
				$("#wangge_rank_table").append("<tr>" +
				"<td><div>"+(++seq_um)+"</div></td>" +
				"<td><div>"+data[i].LATN_NAME+"</div></td>" +
				"<td><div>"+data[i].BUREAU_NAME+"</div></td>" +
				"<td><div>"+data[i].BRANCH_NAME+"</div></td>" +
				"<td><div>"+data[i].GRID_NAME+"</div></td>" +
				"<td><div>"+data[i].BRANCH_TYPE+"</div></td>" +
					//
				"<td><div>"+data[i].ADDR_NUM+"</div></td>" +
				"<td><div>"+data[i].KD_NUM+"</div></td>"+
				"<td><div>"+data[i].USE_RATE+"</div></td>"+
				"<td><div>"+data[i].FTTH_PORT_NUM+"</div></td>"+
				"<td><div>"+data[i].PORT_RATE+"</div></td>"+
					//
				"<td><div>"+data[i].CDMA_NUM_REATE+"</div></td>"+
				"<td><div>"+data[i].BRD_NUM_RATE+"</div></td>"+
				"<td><div>"+data[i].HOME_NUM_RATE+"</div></td>"+
					//

				"<td><div>--</div></td>"+
				"<td><div>"+data[i].Y_CUM_INCOME+"</div></td>"+
				"<td><div>"+data[i].INCOME_BUDGET_FINISH_RATE+"</div></td>"+
				"<td><div>"+data[i].FIN_INCOME+"</div></td>"+
					//
					/*	"<td><div>"+data[i].OPERATE_PROFIT_MON_YEAR+"</div></td>"+
					 "<td><div>"+data[i].OPERATE_PROFIT+"</div></td>"+*/
					//
				"<td><div>"+data[i].MOBILE_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].MOBILE_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_MON_CUM_NEW+"</div></td>"+
				"<td><div>"+data[i].BRD_SERV_DAY_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_CUR_MON_NEW+"</div></td>"+
				"<td><div>"+data[i].ITV_SERV_DAY_NEW+"</div></td>"+
				"</tr>");
			}
			begin += 30;
			end += 30;
		});
	}
	function city(latn_id){
		if(user_level==1){
			city_id_temp = latn_id;
			$(".area_select a[onclick='grid("+latn_id+")']").addClass("selected");
			$(".area_select a[onclick='grid("+latn_id+")']").siblings().removeClass("selected")
			/* 支局清单 */
			sub__name = '';
			seq_um = 0;
			begin = 0;
			end = 30;
			$("#sub_name").val("");
			sub_count();
			sub_rank();
		}
	}


	function grid(latn_id){
		if(user_level==1){
			city_id_temp = latn_id;
			$(".area_select a[onclick='city("+latn_id+")']").addClass("selected");
			$(".area_select a[onclick='city("+latn_id+")']").siblings().removeClass("selected");
			/* 选择网格分公司*/
			grid__name = '';
			begin = 0;
			end = 30;
			seq_um = 0;
			globle_sort_world='';
			$("#grid_name").val("");
			wg_count();
			wg_rank();
		}
	}

	function union(union_code){
		/* 支局清单 */
		$(":radio[value='"+union_code+"']").attr("checked",true);
		city_union = union_code;
		sub__name='';
		seq_um = 0;
		begin = 0;
		end = 30;
		globle_sort_world='';
		$("#sub_name").val("");
		sub_count();
		sub_rank();
	}

	function sub_queryname(){
		/* 支局清单 */
		sub__name = $("#sub_name").val();
		seq_um = 0;
		begin = 0;
		end = 30;
		globle_sort_world='';
		sub_count();
		sub_rank();
	}

	function union_wg(union_code_wg){
		/* 选择网格单元 */
		$(":radio[value='"+union_code_wg+"']").attr("checked",true);
		city_union = union_code_wg;
		grid__name = '';
		begin = 0;
		end = 30;
		seq_um = 0;
		globle_sort_world='';
		$("#grid_name").val("");
		wg_count();
		wg_rank();
	}

	function grid_click(){
		grid__name = $("#grid_name").val();
		begin = 0;
		end = 30;
		seq_um = 0;
		globle_sort_world='';
		wg_count();
		wg_rank();
	}

	function formatterper(value,rowData){
		if(value!=null && value!='--'){
			value = Number(value);
			return "<font color='#ff8a00' style='font-weight:bold' >"+value.toFixed(2)+"%</font>";
		}else{
			return "<font color='#ff8a00' style='font-weight:bold' >"+value+"</font>";
		}
	}
	function formatterper2(value,rowData){
		return "<font color='#f7d700' style='font-weight:bold' >"+value+"</font>";
	}

	function subItemInGIS(union_org_code,branch_name,zoom,city_name_var,latn_id){
		console.log(union_org_code,branch_name,zoom,city_name_var,latn_id);
		global_current_flag = 4;
		var full_name=city_name_var+"市";
		cityForLayer=cityNames[city_name_var+"市"];
		if(cityForLayer==null||cityForLayer==undefined){
			cityForLayer=cityNames[city_name_var+"州"];
			full_name=city_name_var+"州";
		}
		global_position[1]=full_name;
		global_position[2]='';
		if(zxs[latn_id]!=undefined)
			global_position[2]=full_name;
		global_position[3]=branch_name;
		global_position[4]="";
		global_current_full_area_name=branch_name;
		global_current_area_name=branch_name;
		global_substation = union_org_code;
		zoom_from_province = zoom;
		left_list_item_selected = "sub";
		global_current_city_id = latn_id;

		var url4mapToWhere = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_area_dev_colorflow.jsp"/>';
		var user_level = '${sessionScope.UserInfo.LEVEL}';//用户的划小层级
		if(user_level=="" || user_level==undefined){
			layer.msg("与服务器连接断开，请重新登录");
			return;
		}

		if(user_level==2)
			url4mapToWhere = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_area_dev_colorflow_city_level.jsp"/>';

		freshMapContainer(url4mapToWhere);
		var indexContainer_url = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_sub_new.jsp" />';
		freshIndexContainer(indexContainer_url);

		load_map_view();
	}

	function viewRank(){
		load_list_view();
	}
	function viewVillageDraw(){
		if(city_id_for_village_tab_view!="")
			load_list_village(2,city_id_for_village_tab_view);
		else
			load_list_village(user_level);
	}
</script>