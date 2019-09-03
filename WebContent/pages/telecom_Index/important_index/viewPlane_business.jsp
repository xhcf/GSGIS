<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="last_month">
	select min(const_value) VAL from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '2'
</e:q4o>
<e:q4o var="yesterday">
	select min(const_value) VAL from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '2'
</e:q4o>
<e:q4o var="nearly_months">
	SELECT
	TO_CHAR(add_months(to_date(min(const_value), 'yyyymm'),-4),'MM')||'月' A,
	TO_CHAR(add_months(to_date(min(const_value), 'yyyymm'),-3),'MM')||'月' B,
	TO_CHAR(add_months(to_date(min(const_value), 'yyyymm'),-2),'MM')||'月' C,
	TO_CHAR(add_months(to_date(min(const_value), 'yyyymm'),-1),'MM')||'月' D,
	TO_CHAR(to_date(min(const_value), 'yyyymm'),'MM')||'月' E
	from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '2'
</e:q4o>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>实时发展量</title>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap_treeBusi.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
	<style>
		.bus_list{cursor:pointer;}
	</style>
</head>
<body>
<div style="height:99.6%;width:99.6%;margin:0px auto;overflow:hidden;">
	<div data-options="region:'west'" class="business_left">
		<div class="bus_box">
			<div class="op_bg"></div>

			<div class="bus_cont tabPanel">
				<h2><em></em>三大业务</h2>

				<div class="bus_nav">
					<div class="bus_list bus_list_current clearfix">
						<div class="bus_lf">
							<em class="bus_icon2"></em>
							<p>移动</p>
						</div>
						<div class="bus_rg">
							<p>- -</p>
							<span>当日发展量</span>
						</div>
					</div>
					<div class="bus_list clearfix">
						<div class="bus_lf">
							<em class="bus_icon3"></em>
							<p>宽带</p>
						</div>
						<div class="bus_rg">
							<p>- -</p>
							<span>当日发展量</span>
						</div>
					</div>
					<div class="bus_list clearfix">
						<div class="bus_lf">
							<em class="bus_icon5"></em>
							<p>ITV</p>
						</div>
						<div class="bus_rg">
							<p>- -</p>
							<span>当日发展量</span>
						</div>
					</div>
					<%--<div class="bus_list clearfix">
						<div class="bus_lf">
							<em class="bus_icon7"></em>
							<p>红包卡</p>
						</div>
						<div class="bus_rg">
							<p>- -</p>
							<span>当日发展量</span>
						</div>
					</div>--%>
				</div>
			</div>
			<div class="bus_lf_bottom"></div>
		</div>
	</div>
	<div data-options="region:'center'" class="business_right">
		<div class="mobile_wrap">
			<!-- 趋势图 -->
			<div class="bus_chart bus_chart_one" style="margin-right:0.4%;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">月发展趋势</div>
					<div class="figure" id="month_fz" style="width:95%;height:100%;">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 日发展趋势图 -->
			<div class="bus_chart bus_chart_two" >
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">日发展趋势</div>
					<div class="figure" id="day_fz" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!--  日发展趋势图end -->
	
			<!-- 出账构成图 -->
			<div class="bus_chart bus_chart_two" style="margin-right:0.4%;margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico3">出账构成</div>
					<div class="figure" id="czgc" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 新增用户活跃率 -->
			<div class="bus_chart bus_chart_two" style="margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico4">新增用户活跃率</div>
					<div class="figure" id="active_rate" style="width:95%;height:100%; margin-left:1%;">
					</div>
				</div>
			</div>
			<!-- 新增用户活跃率end -->
		</div>
		
		<div class="broadband_wrap" style="display:none;">
			<!-- 趋势图 -->
			<div class="bus_chart bus_chart_one" style="margin-right:0.4%;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">月发展趋势2</div>
					<div class="figure" id="month_fz" style="width:95%;height:100%;">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 日发展趋势图 -->
			<div class="bus_chart bus_chart_two" >
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">日发展趋势2</div>
					<div class="figure" id="day_fz" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!--  日发展趋势图end -->
	
			<!-- 出账构成图 -->
			<div class="bus_chart bus_chart_two" style="margin-right:0.4%;margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico3">出账构成2</div>
					<div class="figure" id="czgc" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 新增用户活跃率 -->
			<div class="bus_chart bus_chart_two" style="margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico4">新增用户活跃率2</div>
					<div class="figure" id="active_rate" style="width:95%;height:100%; margin-left:1%;">
					</div>
				</div>
			</div>
			<!-- 新增用户活跃率end -->
		</div>
		
		<div class="itv_wrap" style="display:none;">
			<!-- 趋势图 -->
			<div class="bus_chart bus_chart_one" style="margin-right:0.4%;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">月发展趋势3</div>
					<div class="figure" id="month_fz" style="width:95%;height:100%;">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 日发展趋势图 -->
			<div class="bus_chart bus_chart_two" >
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">日发展趋势3</div>
					<div class="figure" id="day_fz" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!--  日发展趋势图end -->
	
			<!-- 出账构成图 -->
			<div class="bus_chart bus_chart_two" style="margin-right:0.4%;margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico3">出账构成3</div>
					<div class="figure" id="czgc" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 新增用户活跃率 -->
			<div class="bus_chart bus_chart_two" style="margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico4">新增用户活跃率3</div>
					<div class="figure" id="active_rate" style="width:95%;height:100%; margin-left:1%;">
					</div>
				</div>
			</div>
			<!-- 新增用户活跃率end -->
		</div>
		
		<%--<div class="packet_wrap">
			<!-- 趋势图 -->
			<div class="bus_chart bus_chart_one" style="margin-right:0.4%;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">月发展趋势4</div>
					<div class="figure" id="month_fz" style="width:95%;height:100%;">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 日发展趋势图 -->
			<div class="bus_chart bus_chart_two" >
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos">日发展趋势4</div>
					<div class="figure" id="day_fz" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!--  日发展趋势图end -->
	
			<!-- 出账构成图 -->
			<div class="bus_chart bus_chart_two" style="margin-right:0.4%;margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico3">出账构成4</div>
					<div class="figure" id="czgc" style="width:95%;height:100%; ">
					</div>
				</div>
			</div>
			<!-- 趋势图end -->
	
			<!-- 新增用户活跃率 -->
			<div class="bus_chart bus_chart_two" style="margin-bottom:0;">
				<div class="opacity_bg"></div>
				<div class="alpha_content">
					<div class="title_pos ico4">新增用户活跃率4</div>
					<div class="figure" id="active_rate" style="width:95%;height:100%; margin-left:1%;">
					</div>
				</div>
			</div>
			<!-- 新增用户活跃率end -->
		</div>--%>
		
	</div>
</div>
</body>
</html>
<script type="text/javascript">
	var global_parent_area_name = province_name;
	var global_current_area_name = province_name;//这里将按权限改动： 从sessionScope里取得用户级别，省名或市名或区县等级别
	var global_current_full_area_name = province_name;
	var global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
	var global_current_flag = default_flag;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
	var global_current_city_id = 0;

	var last_month_first = '${date_in_month.LAST_FIRST}';
	var last_month_last = '${date_in_month.LAST_LAST}';
	var current_month_first = '${date_in_month.CURRENT_FIRST}';
	var current_month_last = '${date_in_month.CURRENT_LAST}';
	var global_position = new Array(5);//化小五层结构

	var url4query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=';
	//重点业务左侧大数字
	var url4import_busi_today_dev_num = url4query+'import_busi_today_dev_num';
	//查询地图的数据
	var url4echartmap = url4query+'import_index_echarts_map';

	//月发展趋势图
	var url4dev_figure_month = url4query+'dev_figure_month';
	//日发展趋势图
	var url4dev_figure_day = url4query+'dev_figure_day';
	//出账个构成
	var url4czgc = url4query+'czgc';
	//新增用户活跃率
	var url4activeRate = url4query+'activeRate';

	var params = new Object();
	params.date = '${last_month.VAL}';

	$(function(){
		if(isIE()){
			var pageMapHeight = $(window).height()*0.95;
			if(pageMapHeight==0)
				pageMapHeight = parent.document.documentElement.clientHeight*0.95;
			$(".business_left").height(pageMapHeight);
			$(".business_right").height(pageMapHeight);
			$(".bus_chart").height(pageMapHeight*0.49);
		}

		import_busi_today_dev_num();
		var nearly_months = new Array();
		nearly_months.push('${nearly_months.A}');
		nearly_months.push('${nearly_months.B}');
		nearly_months.push('${nearly_months.C}');
		nearly_months.push('${nearly_months.D}');
		nearly_months.push('${nearly_months.E}');
		chart_dev_month(nearly_months);
		chart_dev_day("mob");
		chart_czgc();
		active_rate();
		$(".bus_list").click(function(){
			$(".bus_lf").addClass('hit').siblings().removeClass('hit');
			$(this).addClass('bus_list_current').siblings().removeClass('bus_list_current');
			//$('.business_right>div:eq('+$(this).index()+')').show().siblings().hide();
		});
		
		/*var tr_doms=$(".bus_nav").children();
		var tr_nums = tr_doms.length;
		var i = 0;
		var interval_time = 10*1000;
		var can_continu_flag= true;
		setInterval(function(){
			if(can_continu_flag){
				i++;
				if(i==0)
					$(tr_doms[tr_nums-1]).removeClass("bus_list_current");
				else
					$(tr_doms[i-1]).removeClass("bus_list_current");

				$(tr_doms[i]).addClass("bus_list_current");

				//右侧滚动时，此处刷新左边各种图表
				$(".business_right").children().hide();
				$(".business_right").children().eq(i).show();

				if(i==tr_nums-1)
					i=-1;
			}
		},interval_time);*/
	});

	function import_busi_today_dev_num(){
		$.post(url4import_busi_today_dev_num,{date:'${yesterday.VAL}'},function(data){
			if(data==null)
				return;
			data = $.parseJSON(data);
			var num_divs = $(".bus_rg");
			$($(num_divs[0]).children().eq(0)).html(data.DEV_MOB);
			$($(num_divs[1]).children().eq(0)).html(data.DEV_ADSL);
			$($(num_divs[2]).children().eq(0)).html(data.DEV_ITV);
			$($(num_divs[3]).children().eq(0)).html(data.DEV_REDBAG);
		});
	}

	function chart_dev_month(nearly_months){
		/* -----------------------------月发展趋势----------------------------------------*/
		// 基于准备好的dom，初始化echarts实例
		var myChart = echarts.init(document.getElementById('month_fz'));

		var bill = new Array();//出账
		var pure_add = new Array();//新增
		var option = {
			tooltip : {
				trigger: 'axis',
				axisPointer : {            // 坐标轴指示器，坐标轴触发有效
					type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
				},
				show:false
			},
			legend: {
				x: 'right',
				y: '6',
				textStyle: {color: '#fff',fontSize:12},
				itemWidth:16,
				itemHeight:8,
				data:['出账(万)','新增(万)']
			},
			grid: {
				left: '0%',
				right: '2%',
				bottom: '4%',
				top:'35%',
				containLabel: true
			},
			xAxis : [
				{
					type : 'category',
					//坐标轴颜色，线宽
					axisLine:{
						lineStyle:{
							color:'#fff',
							width:1//这里是为了突出显示加上的，可以去掉
						}
					},
					data : nearly_months
				}
			],
			yAxis : [
				{
					type : 'value',
					show : false,
					max : 0,
					splitLine:{show: false},//去除网格线
					axisLine:{
						lineStyle:{
							color:'#22befd',
							width:0//这里是为了突出显示加上的，可以去掉
						}
					}
				},
				{
					type : 'value',
					show : false,
					max : 0,
					splitLine:{show: false},//去除网格线
					axisLine:{
						lineStyle:{
							color:'#22befd',
							width:0//这里是为了突出显示加上的，可以去掉
						}
					}
				}
			],
			series : [
				{
					name:'出账(万)',
					type:'bar',
					barGap:'100%',
					barWidth:14,
					itemStyle:{
						normal:{
							color:'#1dbbb5'
						}
					},
					label:{
						normal:{
							show:true,
							position:'top',
							formatter:'{c}'
						}
					},
					data:bill
				},
				{
					name:'新增(万)',
					type:'bar',
					barGap:'100%',
					yAxisIndex: 1,
					barWidth:14,
					itemStyle:{
						normal:{
							color:'#fa8513'
						}
					},
					label:{
						normal:{
							show:true,
							position:'top',
							formatter:'{c}'
						}
					},
					data:pure_add
				}
			]
		};

		$.ajax({
			type:"POST",
			url:url4dev_figure_month,
			data:params,
			success:function(data){
				var data = $.parseJSON(data);
				if(data==null){
					//layer.msg('暂无数据');
					for(var i = 0,l = 5;i<l;i++){
						bill.push(0);
						pure_add.push(0);
					}
				}else{
					bill.push(data.CURR_MON_BILL4);
					bill.push(data.CURR_MON_BILL3);
					bill.push(data.CURR_MON_BILL2);
					bill.push(data.CURR_MON_BILL1);
					bill.push(data.CURR_MON_BILL);

					pure_add.push(data.CURR_MON_NEW4<0?0:data.CURR_MON_NEW4);
					pure_add.push(data.CURR_MON_NEW3<0?0:data.CURR_MON_NEW3);
					pure_add.push(data.CURR_MON_NEW2<0?0:data.CURR_MON_NEW2);
					pure_add.push(data.CURR_MON_NEW1<0?0:data.CURR_MON_NEW1);
					pure_add.push(data.CURR_MON_NEW<0?0:data.CURR_MON_NEW);
				}
			},
			error:function(){
				layer.msg('查询出错');
			},
			complete:function(){
				var bill_max = Math.ceil(Math.max.apply(null, bill));
				//var pure_add_max = Math.ceil(Math.max.apply(null, pure_add));
				option.yAxis[0].max = bill_max;
				option.yAxis[1].max = bill_max/10;//pure_add_max;
				myChart.setOption(option);
			}
		});
	}

	function chart_dev_day(index_type){
		/* -----------------------------日发展趋势----------------------------------------*/
		// 基于准备好的dom，初始化echarts实例
		var myChart = echarts.init(document.getElementById('day_fz'));

		var data_current_month = new Array();
		var data_last_month = new Array();
		var day_array = new Array();
		// 指定图表的配置项和数据
		var option = {
			title: {
				textAlign: 'center',
				x: 'center',
				y: 'top',
				textStyle: {
					color: "#f6e32f",
					fontSize: "18",
					fontWeight: "normal",
					x: 'center',
					y: 'top',
					textAlign: 'center'
				}
			},
			tooltip: {
				trigger: 'axis',
				formatter:function(params, ticket){
					var content = "";
					for(var i = 0,l = params.length;i<l;i++){
						content += params[i].seriesName+params[0].name+"号："+(params[i].data==undefined?"- -":params[i].data);
						if(i < l-1){
							content += "<br/>";
						}
					}
					return content;
				},//'{a0}{b}日:{c0}<br/>{a1}{b}日:{c1}',
				show:true
			},
			legend: {
				x: 'right',
				y: '6',
				textStyle: {color: '#fff', fontSize: 12,},
				itemWidth: 16,
				itemHeight: 8,
				data: ['上月','本月']
			},
			grid: {
				left: '0%',
				right: '2%',
				bottom: '4%',
				top: '20%',
				containLabel: true
			},
			xAxis: [
				{
					type: 'category',
					boundaryGap: false,
					data: day_array,//['1', '3', '6', '9', '12', '15', '18', '21', '24', '27', '30'],
					axisLabel: {
						textStyle: {
							color: "#fff",
							fontSize: "12",
							fontWeight: "normal"
						}
					},
					//坐标轴颜色，线宽
					axisLine: {
						lineStyle: {
							color: '#fff',
							width: 1//这里是为了突出显示加上的，可以去掉
						}
					}
				}
			],
			yAxis: [
				{
					type: 'value',
					show: false,
					splitLine: {show: false},//去除网格线
					axisLine: {
						lineStyle: {
							color: '#22befd',
							width: 0//这里是为了突出显示加上的，可以去掉
						}
					}
				}
			],
			series: [
				{
					name: '上月',
					type: 'line',
					symbol:'circle',
					smooth: true,
					stack: '总量',
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle: {
						normal: {
							color: '#03d2e3',
							label: {
								show: false,
								textStyle: {
									fontWeight: '700',
									fontSize: '0'
								}
							},
							lineStyle: {
								color: '#03d2e3',
								width:1
							}
						}
					},
					label: {
						normal: {
							show: true,
							position: 'top'
						}
					},
					areaStyle: {
						normal: {
							color: '#03d2e3',
							opacity: 0.2
						}
					},
					data: data_last_month
				},
				{
					name: '本月',
					type: 'line',
					symbol:'circle',
					smooth: true,
					stack: '总量',
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle: {
						normal: {
							color: '#feef02',
							label: {
								show: false,
								textStyle: {
									fontWeight: '700',
									fontSize: '0'
								}
							},
							lineStyle: {
								color: '#feef02',
								width:1
							}
						}
					},
					label: {
						normal: {
							show: true,
							position: 'top'
						}
					},
					areaStyle: {
						normal: {
							color: '#feef02',
							opacity: 0.2
						}
					},
					data: data_current_month
				}

			]
		};

		var params = new Object();
		params.date = '${yesterday.VAL}';
		params.index_type = index_type;
		$.ajax({
			type:"POST",
			url:url4dev_figure_day,
			data:params,
			success:function(data){
				var data = $.parseJSON(data);
				if(data==null)
					layer.msg('暂无数据');
				else {
					var today = params.date;
					today = today.substr(6);
					data_current_month.push(data['C_DEV']);
					for(var i = 0,l=(parseInt(today)-1);i<l;i++){
						data_current_month.push(data['C_DEV'+(i+1)]);
					}
					data_last_month.push(data['L_DEV']);
					var ymd = ${yesterday.val};
					var ym = parseInt(ymd/100)-1;
					if (ym/100==parseInt(ym/100)) {
						ym = ym-88;
					}
					var y = parseInt(ym/100);
					var m = ym%100;
					var d = mhaved(y,m-1);
					for(var i = 0,l=d-1;i<l;i++){
						data_last_month.push(data['L_DEV'+(i+1)]);
						day_array.push(i+1);
					}
					day_array.push(d);
				}
			},
			error:function(){
				layer.msg('查询出错');
			},
			complete:function(){
				var data_current_month_max = Math.ceil(Math.max.apply(null, data_current_month));
				var data_last_month_max = Math.ceil(Math.max.apply(null, data_last_month));
				option.yAxis.max = (data_current_month_max>data_last_month_max?data_current_month_max:data_last_month_max);
				myChart.setOption(option);
			}
		});

		// 使用刚指定的配置项和数据显示图表。
		myChart.setOption(option);
	}

	function mhaved(year, month) {
	    if (month == 1) {
	        if (year % 4 == 0 && year % 100 != 0)
	            return 29;
	        else
	            return 28;
	    } else if ((month <= 6 && month % 2 == 0) || (month > 6 && month % 2 == 1))
	        return 31;
	    else
	        return 30;
	};

	function chart_czgc(){
		/* -----------------------------出账构成----------------------------------------*/
		// 基于准备好的dom，初始化echarts实例
		var myChart = echarts.init(document.getElementById('czgc'));
		var dataArray = new Array();//'流失用户','本月激活','新增出账','上月出账'
		var max = 0;
		// 指定图表的配置项和数据
		var option = {
			tooltip: {
				trigger: 'axis',
				axisPointer: {
					type: 'shadow'
				},
				show:false
			},
			grid: {
				left: '3%',
				right: '2%',
				bottom: '4%',
				top:'30%',
				containLabel: true
			},
			xAxis: {
				type: 'value',
				show:false,
				boundaryGap: [0, 0.01],
				max:max
			},
			yAxis: {
				type: 'category',
				//坐标轴颜色，线宽
				axisLine:{
					lineStyle:{
						color:'#fff',
						width:0//这里是为了突出显示加上的，可以去掉
					}
				}  ,
				axisTick :{show:false},
				data: ['流失用户','本月激活','新增出账','上月出账']
			},
			series: [
				{
					name: '用户',
					type: 'bar',
					barWidth:14,
					itemStyle: {
						normal: {
							color: function (params) {
								var colorList = [
									'#fa8513', '#1dbbb5', '#1dbbb5', '#1dbbb5',
								];
								return colorList[params.dataIndex]
							}
						}
					},
					data: dataArray,
					barGap:'1%',
					label :{
						normal:{
							show: true,
							position: 'right',
							formatter:"{c}万",
							textStyle:{
								fontSize: "14",
								fontWeight:"bold"
							}
						}
					}
				}
			]
		};
		$.ajax({
			type:"POST",
			url:url4czgc,
			data:params,
			success:function(data){
				var data= $.parseJSON(data);
				if(data==null){
					//layer.msg('暂无数据');
					dataArray.push(0);
					dataArray.push(0);
					dataArray.push(0);
					dataArray.push(0);
				}else{
					dataArray.push(data.CURR_MON_LOST);
					dataArray.push(data.CURR_MON_LIVE);
					dataArray.push(data.CURR_MON_NEW);
					dataArray.push(data.CURR_MON_BILL);
				}
			},
			error:function(){
				layer.msg('查询出错');
			},
			complete:function(){
				if(dataArray.length>0)
					max = dataArray[dataArray.length-1]*1.2;
				option.xAxis.max = max;
				myChart.setOption(option);
			}
		});
	}
	function active_rate(){
		// 基于准备好的dom，初始化echarts实例
		var myChart = echarts.init(document.getElementById('active_rate'));
		var dataArray_rate = new Array();//发展率
		var dataArray_num = new Array();//发展量
		// 指定图表的配置项和数据
		var option = {
			color: ['#50e4ff'],
			legend: {
				x: 'right',
				y: '6',
				textStyle: {color: '#fff',fontSize:12},
				itemWidth:16,
				itemHeight:8,
				data:['新增用户数(万)','新增活跃率']
			},
			tooltip : {
				trigger: 'axis',
				axisPointer : {            // 坐标轴指示器，坐标轴触发有效
					type : 'line'        // 默认为直线，可选为：'line' | 'shadow'
				},
				show:true,
				backgroundColor:'rgba(50,50,50,0.9)'
			},
			grid: {
				left: '0%',
				right: '0%',
				bottom: '4%',
				top:'30%',
				containLabel: true
			},
			xAxis : [
				{
					type : 'category',
					data : ['兰州', '天水','白银','酒泉','张掖','武威','金昌', '嘉峪关','定西','平凉','庆阳','陇南','临夏','甘南'],
					//设置字体倾斜
					axisLabel:{
						interval:0,
						rotate:0,//倾斜度 -90 至 90 默认为0
						textStyle:{
							color:"#fff",
							fontSize: "12",
							fontWeight:"normal"
						}
					},
					axisLine:{
						lineStyle:{
							color:'#fff',
							width:1//这里是为了突出显示加上的，可以去掉
						}
					}  ,

					axisTick: {
						alignWithLabel: true
					}
				},
			],
			yAxis : [
				{
					type : 'value',
					show: false,//隐藏y轴
					//max:1,
					splitLine:{show: false},//去除网格线
					axisLabel:{
						textStyle:{
							color:"#fff",
							fontSize: "12",
							fontWeight:"normal"
						}
					},
					axisLine:{
						lineStyle:{
							color:'#50e4ff',
							width:0//这里是为了突出显示加上的，可以去掉
						}
					}
				},
				{
					type : 'value',
					show: false,//隐藏y轴
					//max:1,
					yAxisIndex: 1,
					splitLine:{show: false},//去除网格线
					axisLabel:{
						textStyle:{
							color:"#fff",
							fontSize: "12",
							fontWeight:"normal"
						}
					},
					axisLine:{
						lineStyle:{
							color:'#50e4ff',
							width:0//这里是为了突出显示加上的，可以去掉
						}
					}
				}
			],
			series : [
				{
					name:'新增用户数(万)',
					type:'bar',
					barWidth: '40%',
					stack: '新增用户数',
					label:{
						normal:{
							show:true,
							position: 'top',
							textStyle: {
								fontWeight: '500',
								color:'#58FAFF',
								fontSize: '12'
							}
						}
					},
					data: dataArray_num//[10,20, 30, 40, 20, 56, 50,35,29,33,10,20, 30, 40]
				},
				{
					name: '新增活跃率',
					type: 'line',
					symbol:'circle',
					smooth: true,
					stack: '新增活跃率',
					yAxisIndex: 1,
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle: {
						normal: {
							color: '#feef02',
							label: {
//								show: true,
								position: 'top'//,
								/*textStyle: {
								 //fontWeight: '700',
								 fontSize: '12'
								 }*/
							},
							lineStyle: {
								color: '#feef02',
								width:1
							}
						}
					},

					areaStyle: {
						normal: {
							color: '#feef02',
							opacity: 0.0
						}
					},
					data: dataArray_rate
				}
			]
		};

		$.ajax({
			type:"POST",
			url:url4activeRate,
			data:params,
			success:function(data){
				var data= $.parseJSON(data);
				if(data.length==0){
					//layer.msg('暂无数据');
					for(var i = 0,l = Object.keys(city_ids).length;i<l;i++ ){
						dataArray_rate.push(0);
						dataArray_num.push(0);
					}
				}else {
					for(var i = 0,l = data.length;i<l;i++){
						var d = data[i];
						dataArray_rate.push(d.NEW_ACT_RATE);
						dataArray_num.push(d.CURR_MON_NEW);
					}
				}
			},
			error:function(){
				layer.msg('查询出错');
			},
			complete:function(){
				var num_max = Math.ceil(Math.max.apply(null, dataArray_num));
				//var rate_max = Math.ceil(Math.max.apply(null, dataArray_rate));
				option.yAxis[0].max = num_max;
				option.yAxis[1].max = 1;
				myChart.setOption(option);
			}
		});
	}

	function getEchartsMapSize(){
		var size = {};
		size.width = $("#mapContainer").width();
		size.height = $("#mapContainer").height();
		return size;
	}

	function updatePosition(level){
		//var click_path = $(window.frames["mapContainer"].contentWindow.document).find("#click_path");
		var click_path = $("#click_path");
		var temp = "";
		for(var i =0;i<level;i++){
			var str = global_position[i];
			if(str == undefined)
				return;
			temp += global_position[i];
			if(i!=level-1)
				temp += ">";
		}
		click_path.html("当前路径："+temp);
	}
</script>
