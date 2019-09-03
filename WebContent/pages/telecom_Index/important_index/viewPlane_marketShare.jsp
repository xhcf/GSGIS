<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '1'
</e:q4o>
<e:q4o var="beforeYesterday">
	select to_char((to_date(min(const_value), 'yyyymmdd') - 1),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '1'
</e:q4o>
<e:q4o var="months_x">
	SELECT
		TO_CHAR(ADD_MONTHS(to_date(min(const_value), 'yyyymm'), -3), 'mm'||'""') A,
		TO_CHAR(ADD_MONTHS(to_date(min(const_value), 'yyyymm'), -2), 'mm'||'""') B,
		TO_CHAR(ADD_MONTHS(to_date(min(const_value), 'yyyymm'), -1), 'mm'||'""') C,
		TO_CHAR(to_date(min(const_value), 'yyyymm'), 'mm'||'""') D
	FROM SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '1'
</e:q4o>
<e:q4o var="months_ym">
	SELECT
	TO_CHAR(ADD_MONTHS(to_date(min(const_value), 'yyyymm'), -3), 'yyyymm'||'""') A,
	TO_CHAR(ADD_MONTHS(to_date(min(const_value), 'yyyymm'), -2), 'yyyymm'||'""') B,
	TO_CHAR(ADD_MONTHS(to_date(min(const_value), 'yyyymm'), -1), 'yyyymm'||'""') C,
	TO_CHAR(to_date(min(const_value), 'yyyymm'), 'yyyymm'||'""') D
	FROM SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '1'
</e:q4o>
<%--<e:q4o var="days_x">
	SELECT
		TO_CHAR(SYSDATE-7,'dd') A,
		TO_CHAR(SYSDATE-6,'dd') B,
		TO_CHAR(SYSDATE-5,'dd') C,
		TO_CHAR(SYSDATE-4,'dd') D,
		TO_CHAR(SYSDATE-3,'dd') E,
		TO_CHAR(SYSDATE-2,'dd') F,
		TO_CHAR(SYSDATE-1,'dd') G
	FROM DUAL
</e:q4o>--%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>市场份额</title>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>

	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
	<!-- echarts 3.2.3 -->
	<script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
	<script src='<e:url value="/resources/component/echarts_new/theme/dark.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/printWord.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/layerShow.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
</head>
<body style="margin:0px;padding:0px;">
  <div class="" style="height:100%;width:99.6%;margin:0px auto;padding:0px;">
	<div style="width:70%;height:100%;float:left" data-options="region:'west'" class="marketContainer">
		<div class="market_share_total">
			<div class="title">
				<span class="title_name">市场份额<em>— <font id="local_name">全省</font></em></span>
			</div>
			<div class="data_display">
				累计份额 <span>- -</span>
			</div>
			<div class="data_display" style="border-right:none;">
				新增份额 <span>- -</span>
			</div>
		</div>
		<div class="market_figure_layout">
		  <div class="alpha_bg"></div>
		  <div class="alpha_cont">
			<div class="title">累计份额</div>
			<div class="accumulate_wrap">
				<div class="accumulate lj_one">
					<p>月累计份额</p>
					<div id="bar1" style="height:100%; width:100%;">
					</div>
				</div>
					<div class="accumulate" style="left: -5px;">
					<p style="left:20px;">月增幅</p>
					<div id="line1" style="height:100%; width:100%;">
					</div>
				</div>
			</div>
		  </div>
		</div>
		<div class="market_figure_layout">
		  <div class="alpha_bg"></div>
		  <div class="alpha_cont">
			<div class="title">新增份额</div>
			<div class="accumulate_wrap">
				<div class="accumulate lj_one">
					<p>日新增份额</p>
					<div id="bar2" style="height:100%; width:100%;">
					</div>
				</div>
				<div class="accumulate">
					<p style="left:20px;">日增幅</p>
					<div id="line2" style="height:100%; width:100%;">
					</div>
			   </div>
			</div>
		  </div>
        </div>
	</div>
	<div style="width:30%;height:99.2%;float:right" data-options="region:'east'" class="realTimebottom_content">
	  <div class="market_tab_layout">
	    <div class="alpha_bg"></div>
		<div class="alpha_cont">
			<table cellspacing="0" cellpadding="0" border="0" class="content_tab" >
				<thead valign="top">
				<th>序号</th>
				<th>分公司</th>
				<th>累计份额</th>
				<th>净增</th>
				<th>新增用户数</th>
				<th>新增份额</th>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	  </div>
	</div>
  </div>
</body>
</html>
<script>
	var url_query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp" />?eaction=';
	//var url4marketTotal = url_query+'market_total';//份额、数量
	var url4marketTotal = '<e:url value="market_total_a.e"/>';//份额、数量
	//var url4monthAcc = url_query+'month_acc';//月累计
	var url4monthAcc = '<e:url value="month_acc_a.e"/>';//月累计
	//var url4dayAdd = url_query+'day_add';//日新增
	var url4dayAdd = '<e:url value="day_add_a.e"/>';//日新增

	var url4subCrops = url_query+'sub_crops';//分公司列表

	var params = new Object();
	params.date = '${yesterday.VAL}';
	params.region_id = '999';

	//最近6个月 只有月份的格式 ‘06’‘07’
	var nearly_months = new Array();
	nearly_months.push('${months_x.A}');
	nearly_months.push('${months_x.B}');
	nearly_months.push('${months_x.C}');
	nearly_months.push('${months_x.D}');

	//有年月的格式 ‘201704’‘201705’
	var months_ym = new Array();
	months_ym.push('${months_ym.A}'.substr(0,4)+"年"+'${months_ym.A}'.substr(4,2));
	months_ym.push('${months_ym.B}'.substr(0,4)+"年"+'${months_ym.B}'.substr(4,2));
	months_ym.push('${months_ym.C}'.substr(0,4)+"年"+'${months_ym.C}'.substr(4,2));
	months_ym.push('${months_ym.D}'.substr(0,4)+"年"+'${months_ym.D}'.substr(4,2));

	params.month_begin = '${months_ym.A}';
	params.month_end = '${months_ym.D}';

	//最近7天
	/*var days_x_add = new Array();
	days_x_add.push('${days_x.A}');
	days_x_add.push('${days_x.B}');
	days_x_add.push('${days_x.C}');
	days_x_add.push('${days_x.D}');
	days_x_add.push('${days_x.E}');
	days_x_add.push('${days_x.F}');
	days_x_add.push('${days_x.G}');*/

	var data_displays = $(".market_share_total").find(".data_display");

	var chart_line1 = "";
	var chart_line2 = "";
	var chart_bar1 = "";
	var chart_bar2 = "";

	//整体刷新时间
	var interval_time = 6*1000;
	var chart_animation_time_bar = 2*1000;//表格生成动画过渡时间
	var chart_animation_time_line = 1*1000;
	var tab_can_continue_time = 10*1000;

	$(function(){
		if(isIE()){
			var pageMapHeight = $(window).height()*0.95;
			if(pageMapHeight==0)
				pageMapHeight = parent.document.documentElement.clientHeight*0.95;
			$(".marketContainer").height(pageMapHeight);
			$(".realTimebottom_content").height(pageMapHeight);

			$("#line1").height($("#line1").parent().height());
			$("#line2").height($("#line2").parent().height());
			$("#bar1").height($("#bar1").parent().height());
			$("#bar2").height($("#bar2").parent().height());
		}
		chart_line1 = echarts.init(document.getElementById('line1'));
		chart_line2 = echarts.init(document.getElementById('line2'));
		chart_bar1 = echarts.init(document.getElementById('bar1'));
		chart_bar2 = echarts.init(document.getElementById('bar2'));

		freshAll(params);
		//右侧地市分公司
		//params.date = '${yesterday.VAL}';
		var latn_ids = new Array();
		$.post(url4subCrops,params,function(data){
			data = $.parseJSON(data);
			if(data.length==0)
				return;
			var subTab = $(".realTimebottom_content").find(".content_tab tbody");
			for(var i = 0,l = data.length;i<l;i++){
				var data_tr = data[i];
				$(subTab).append("<tr style=\"cursor:pointer\"><td>"+(parseInt(data_tr.POS)+1)+"</td><td>"
					+data_tr.REGION_NAME+"</td><td>"
					+data_tr.ACC_RATE_TELECOM+"%</td><td>"
					+data_tr.ACCMON_RATE_TEL+"%</td><td>"
					+data_tr.ADD_CNT_TELECOM+"</td><td>"
					+data_tr.ADD_RATE_TELECOM+"%</td></tr>");
				latn_ids.push(data_tr.REGION_ID);
			}
			var tr_doms = subTab.children("tr");
			var tr_nums = $(tr_doms).length;
			var i = 0;//当前到地市表中的某个位置

			$(tr_doms[0]).addClass("latn_back");
			//随右侧刷新
			var can_continu_flag = true;


			var click_after_wait_timeout = "";
			$(tr_doms).each(function(){
				$(this).on("click",function(){
					if(click_after_wait_timeout!='')
						clearTimeout(click_after_wait_timeout);

					var index = $(this).children(":eq(0)").html();
					index = parseInt(index)-1;
					i = index;
					var click_index = index;
					can_continu_flag = false;

					$(tr_doms).each(function(){
						$(this).removeClass("latn_back");
					});
					$(tr_doms[click_index]).addClass("latn_back");
					$("#local_name").html("");
					printWord($(tr_doms[click_index]).children().eq(1).html(),$("#local_name"));

					params.region_id = latn_ids[index];

					rebuildEchartObj();

					freshAll(params);

					click_after_wait_timeout = setTimeout(function(){
						can_continu_flag = true;
						clearTimeout(click_after_wait_timeout);
					},tab_can_continue_time);
				});

			});
			setInterval(function(){
				if(can_continu_flag){
					i++;
					if(i==0)
						$(tr_doms[tr_nums-1]).removeClass("latn_back");
					else
						$(tr_doms[i-1]).removeClass("latn_back");

					$(tr_doms[i]).addClass("latn_back");

					//右侧滚动时，此处刷新左边各种图表
					params.region_id = latn_ids[i];

					printWord($(tr_doms[i]).children().eq(1).html(),$("#local_name"));

					rebuildEchartObj();

					freshAll(params);

					if(i==tr_nums-1)
						i=-1;
				}
			},interval_time);
		});
	});

	//销毁所有echart对象，重新建立，生成刷新整体的动态效果
	function rebuildEchartObj(){
		chart_bar1.dispose();
		chart_bar2.dispose();
		chart_line1.dispose();
		chart_line2.dispose();

		chart_bar1 = echarts.init(document.getElementById('bar1'));
		chart_bar2 = echarts.init(document.getElementById('bar2'));
		chart_line1 = echarts.init(document.getElementById('line1'));
		chart_line2 = echarts.init(document.getElementById('line2'));
	}
	function freshAll(params){
		//市场份额 总览（两个大数字）
		freshMarketTotal(params);

		//月累计份额
		freshMonthAccPercent(params);

		//月累计增幅
		freshMonthAccRateChange(params);

		//日新增份额
		freshDayAddPercent(params);

		//日新增增幅
		freshDayAddRateChange(params);
	}

	//累计份额、新增份额大数字
	params.flag1='1';
	function freshMarketTotal(params){
		$.post(url4marketTotal,params,function(data){
			params.flag1='2';
			data = $.parseJSON(data);
			if(data=='' || data==null || data==undefined || data.ACC_RATE_TELECOM==undefined || data.ADD_RATE_TELECOM==undefined){
				return;
			}else {
				var c1 = $($(data_displays[0]).children());
				c1.html("");
				printWord1(data.ACC_RATE_TELECOM+"%",c1);
	
				var c2 = $($(data_displays[1]).children());
				c2.html("");
				printWord2(data.ADD_RATE_TELECOM+"%",c2);
			}
		});
	}

	//月累计份额（上面的柱图）
	params.flag2='1';
	function freshMonthAccPercent(params){
		$.post(url4monthAcc,params,function(data){
			params.flag2='2';
			data = $.parseJSON(data);

			var acc_mob = new Array();
			var acc_tel = new Array();
			var acc_uni = new Array();

			for(var i = 0,l = data.length;i<l;i++){
				var d = data[i];
				acc_mob.push(d.RATE_MOBLIE);
				acc_tel.push(d.RATE_TELECOM);
				acc_uni.push(d.RATE_UNION);
			}

			month_acc_percent(acc_tel,acc_mob,acc_uni);
		});
	}

	//月累计份额（被freshMonthAccPercent调用）
	function month_acc_percent(acc_tel_data,acc_mob_data,acc_uni_data){
		// 指定图表的配置项和数据
		var option = {
			animationDuration: chart_animation_time_bar,//表格生成动画过渡时间
			tooltip : {
				trigger: 'axis',
				backgroundColor:'rgba(0,0,50,0.7)',
				axisPointer : {            // 坐标轴指示器，坐标轴触发有效
					type : 'none'        // 默认为直线，可选为：'line' | 'shadow'
				},
				show:true,
				formatter: function(params, ticket){
					//'{b0}新增份额<br/>{a0}:{c0}%<br/>{a1}:{c1}%<br/>{a2}:{c2}%'
					var date = params[0].name;
					var content = date+"月<br/>";
					for(var i = 0,l = params.length;i<l;i++){
						content += params[i].seriesName+":"+params[i].data+"%";
						if(i < l-1){
							content += "<br/>";
						}
					}
					return content;
				}
			},
			legend: {
				
				y: '10',
				right:'14',
				textStyle: {color: '#fff',fontSize:12},
				itemWidth:10,
				itemHeight:4,
				data:['移动','电信','联通']
			},
			
			grid: {
				left: '-1%',
				right: '-1%',
				bottom: '5%',
				top:'0%',
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
					data : months_ym
				}
			],
			yAxis : [
				{
					type : 'value',
					show : false,
					max : 100,
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
					max : 100,
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
					max : 100,
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
					name:'移动',
					type:'bar',
					barGap:'100%',
					barWidth:'10%',
					itemStyle:{
						normal:{
							color:'#1dbbb5'
						}
					},
					label:{
						normal:{
							show:false,
							position:'top',
							formatter:'{c}'
						}
					},
					data:acc_mob_data
				},
				{
					name:'电信',
					type:'bar',
					barGap:'100%',
					yAxisIndex: 1,
					barWidth:'10%',
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
					data:acc_tel_data
				},
				{
					name:'联通',
					type:'bar',
					barGap:'100%',
					yAxisIndex: 1,
					barWidth:'10%',
					itemStyle:{
						normal:{
							color:'#b5ef8e'
						}
					},
					label:{
						normal:{
							show:false,
							position:'top',
							formatter:'{c}'
						}
					},
					data:acc_uni_data
				}
			]
		};

		// 使用刚指定的配置项和数据显示图表
		chart_bar1.setOption(option);
	}

	//月累计增幅（上面的曲线图）
	function freshMonthAccRateChange(params){
		$.post(url4monthAcc,params,function(data){
			params.flag2='2';
			data = $.parseJSON(data);
			var acc_mob = new Array();
			var acc_tel = new Array();
			var acc_uni = new Array();
			var data_temp = new Array();

			for(var i = 0,l = data.length;i<l;i++){
				var d = data[i];
				acc_mob.push(d.MON_RATE_MOBLIE);
				acc_tel.push(d.MON_RATE_TELECOM);
				acc_uni.push(d.MON_RATE_UNION);
				data_temp.push(d.MON_RATE_MOBLIE);
				data_temp.push(d.MON_RATE_TELECOM);
				data_temp.push(d.MON_RATE_UNION);
			}
			var max = Math.max.apply(Math,data_temp);
			var min = Math.min.apply(Math,data_temp);
			//if(max-min>1){
				max = (max*2).toFixed(2);
				min = (min*2).toFixed(2);
			//}
			month_acc_rate_change(acc_mob,acc_tel,acc_uni,max,min);
		});
	}

	//月累计增幅（被freshMonthAccRateChange调用）
	function month_acc_rate_change(acc_mob,acc_tel,acc_uni,max,min){
		var option = {
			animationDuration: chart_animation_time_line,
			legend: {
				x: 'right',
				y: '10',
				textStyle: {color: '#fff',fontSize:12},
				itemWidth:10,
				itemHeight:6,
				data:['移动','电信','联通']
			},
			tooltip : {
				trigger: 'axis',
				formatter:function(params, ticket){
					//'{b0}新增份额<br/>{a0}:{c0}%<br/>{a1}:{c1}%<br/>{a2}:{c2}%'
					var date = params[0].name;
					var content = date+"月<br/>";
					for(var i = 0,l = params.length;i<l;i++){
						content += params[i].seriesName+":"+params[i].data+"%";
						if(i < l-1){
							content += "<br/>";
						}
					}
					return content;
				},
				show:true,
				backgroundColor:'rgba(0,0,50,0.7)',
				position: function (point, params, dom, rect, size) {
					// 固定在顶部
					var left = 0;
					// 鼠标在左侧时 tooltip 显示到右侧，鼠标在右侧时 tooltip 显示到左侧。
					if(point[0] < $("#line1").width() / 2)//在左侧
						left = point[0]+20;
					else//在右侧
						left = point[0]-120;
					return [left, '10%'];
				}
			},
			grid: {
				left: '0%',
				right: '7%',
				bottom: '1.5%',
				top: '26%',
				containLabel: true
			},
			xAxis : [
				{
					type : 'category',
					boundaryGap : false,
					data : months_ym,
					axisLabel:{
						show:true,
						interval:0  ,
						inside:true,
						textStyle:{
							color:"#fff",
							fontSize: "12",
							fontWeight:"normal"
						}
					},
					//坐标轴颜色，线宽
					axisLine:{
						lineStyle:{
							color:'#73729f',
							width:1//这里是为了突出显示加上的，可以去掉
						}
					}
				}
			],
			yAxis : [
				{
					type : 'value',
					max:max,
					min:min,
					//网格线
					splitLine: {
						show:false
					},
					axisTick: {
						show: false
					},
					axisLine:{
						lineStyle:{
							color:'#22befd',
							width:0//这里是为了突出显示加上的，可以去掉
						}
					},
					axisLabel: {show:false}
				},
			],
			series : [
				{
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle : {
						normal : {
                            label : {show: true},
							color:'#fa8513'
						}
					},
					name:'电信',
					type:'line',
					smooth: true,
					symbol:'circle',
					stack: '电信新增份额',
					areaStyle: {
						normal: {
							color:'none'
						}
					},
					data:acc_tel
				},
				{
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle : {
						normal : {
							color:'#4d94e3'
						}
					},
					name:'移动',
					type:'line',
					smooth: true,
					symbol:'circle',
					stack: '移动新增份额',
					label: {
						normal: {
							show: false,
							position: 'top'
						}
					},
					areaStyle: {
						normal: {
							color:'none'
						}
					},
					data:acc_mob
				},
				{
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle : {
						normal : {
							color:'#b5ef8e'
						}
					},
					name:'联通',
					type:'line',
					smooth: true,
					symbol:'circle',
					stack: '联通新增份额',
					label: {
						normal: {
							show: false,
							position: 'top'
						}
					},
					areaStyle: {normal: {
						color:'none'
					}
					},
					data:acc_uni
				}
			]
		};
		// 使用刚指定的配置项和数据显示图表
		chart_line1.setOption(option);
	}

	//日新增份额（下面的柱图）
	params.flag3='1';
	function freshDayAddPercent(params){
		//$.post('',param,function(data){
		//	data = $.parseJSON(data);
		$.post(url4dayAdd,params,function(data){
			params.flag3='2';
			data = $.parseJSON(data);
			if(data=='' || data==null || data==undefined)
				return;

			var day_array = new Array();
			var add_tel_data = new Array();
			var add_mob_data = new Array();
			var add_uni_data = new Array();

			for(var i = 0,l = data.length;i<l;i++){
				var d = data[i];
				day_array.push(d.DAY_ID+"日");
				add_tel_data.push(d.ADD_RATE_TELECOM);
				add_mob_data.push(d.ADD_RATE_MOBLIE);
				add_uni_data.push(d.ADD_RATE_UNION);
			}

			day_add_percent(day_array,add_tel_data,add_mob_data,add_uni_data);
		});

		//});
	}
	//日新增份额（被freshDayAddPercent调用）
	function day_add_percent(day_array,add_tel_data,add_mob_data,add_uni_data){

		// 指定图表的配置项和数据
		var option = {
			animationDuration: chart_animation_time_bar,//表格生成动画过渡时间
			tooltip : {
				trigger: 'axis',
				backgroundColor:'rgba(0,0,50,0.7)',
				axisPointer : {            // 坐标轴指示器，坐标轴触发有效
					type : 'none'        // 默认为直线，可选为：'line' | 'shadow'
				},
				show:true,
				formatter:function(params, ticket){
					//'{b0}新增份额<br/>{a0}:{c0}%<br/>{a1}:{c1}%<br/>{a2}:{c2}%'
					var date = params[0].name;
					var content = date+"<br/>";
					for(var i = 0,l = params.length;i<l;i++){
						content += params[i].seriesName+":"+params[i].data+"%";
						if(i < l-1){
							content += "<br/>";
						}
					}
					return content;
				}
			},
			legend: {
				right:'14',
				y: '10',
				textStyle: {color: '#fff',fontSize:12},
				itemWidth:10,
				itemHeight:4,
				data:['移动','电信','联通']
			},
			grid: {
				left: '0%',
				right: '0%',
				bottom: '5%',
				top:'0%',
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
					data : day_array
				}
			],
			yAxis : [
				{
					type : 'value',
					show : false,
					max : 100,
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
					max : 100,
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
					max : 100,
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
					name:'移动',
					type:'bar',
					barGap:'66%',
					barWidth:'12%',
					itemStyle:{
						normal:{
							color:'#1dbbb5'
						}
					},
					label:{
						normal:{
							show:false,
							position:'top',
							formatter:'{c}'
						}
					},
					data:add_mob_data
				},
				{
					name:'电信',
					type:'bar',
					barGap:'66%',
					yAxisIndex: 1,
					barWidth:'12%',
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
					data:add_tel_data
				},
				{
					name:'联通',
					type:'bar',
					barGap:'66%',
					yAxisIndex: 1,
					barWidth:'12%',
					itemStyle:{
						normal:{
							color:'#b5ef8e'
						}
					},
					label:{
						normal:{
							show:false,
							position:'top',
							formatter:'{c}'
						}
					},
					data:add_uni_data
				}
			]
		};

		// 使用刚指定的配置项和数据显示图表
		chart_bar2.setOption(option);
	}

	//日新增增幅（下面的曲线图）
	function freshDayAddRateChange(params){
		$.post(url4dayAdd,params,function(data){
			params.flag3='2';
			data = $.parseJSON(data);
			if(data=='' || data==null || data==undefined)
				return;

			var day_array = new Array();
			var add_tel_data = new Array();
			var add_mob_data = new Array();
			var add_uni_data = new Array();
			var data_temp = new Array();

			for(var i = 0,l = data.length;i<l;i++){
				var d = data[i];
				day_array.push(d.DAY_ID+"日");
				add_tel_data.push(d.ADD_RATE_DX);
				add_mob_data.push(d.ADD_RATE_YD);
				add_uni_data.push(d.ADD_RATE_LT);
				data_temp.push(d.ADD_RATE_DX);
				data_temp.push(d.ADD_RATE_YD);
				data_temp.push(d.ADD_RATE_LT);
			}
			var max = Math.max.apply(Math,data_temp);
			var min = Math.min.apply(Math,data_temp);
			//if(max-min>1){
				max = (max*2).toFixed(2);
				min = (min*2).toFixed(2);
			//}
			day_add_rate_change(day_array,add_tel_data,add_mob_data,add_uni_data,max,min);
		});
	}
	//日新增增幅（被freshDayAddRateChange调用）
	function day_add_rate_change(day_array,add_tel_data,add_mob_data,add_uni_data,max,min){
		// 指定图表的配置项和数据
		var option = {
			animationDuration: chart_animation_time_line,
			legend: {
				x: 'right',
				y: '10',
				textStyle: {color: '#fff',fontSize:12},
				itemWidth:10,
				itemHeight:6,
				data:['移动','电信','联通']
			},
			tooltip : {
				trigger: 'axis',
				formatter:function(params, ticket){
					//'{b0}新增份额<br/>{a0}:{c0}%<br/>{a1}:{c1}%<br/>{a2}:{c2}%'
					var date = params[0].name;
					var content = date+"<br/>";
					for(var i = 0,l = params.length;i<l;i++){
						content += params[i].seriesName+":"+params[i].data+"%";
						if(i < l-1){
							content += "<br/>";
						}
					}
					return content;
				},
				show:true,
				backgroundColor:'rgba(0,0,50,0.7)',
				position: function (point, params, dom, rect, size) {
					// 固定在顶部
					var left = 0;
					// 鼠标在左侧时 tooltip 显示到右侧，鼠标在右侧时 tooltip 显示到左侧。
					if(point[0] < $("#line1").width() / 2)//在左侧
						left = point[0]+20;
					else//在右侧
						left = point[0]-120;
					return [left, '10%'];
				}
			},
			grid: {
				left: '0%',
				right: '5%',
				bottom: '5%',
				top: '26%',
				containLabel: true
			},
			xAxis : [
				{
					type : 'category',
					boundaryGap : false,
					data : day_array,
					axisLabel:{
						show:true,
						interval:0  ,
						textStyle:{
							color:"#fff",
							fontSize: "12",
							fontWeight:"normal"
						}
					},
					//坐标轴颜色，线宽
					axisLine:{
						lineStyle:{
							color:'#73729f',
							width:1//这里是为了突出显示加上的，可以去掉
						}
					}
				}
			],
			yAxis : [
				{
					type : 'value',
					max:max,
					min:min,
					//网格线
					splitLine: {
						show:false
					},
					axisTick: {
						show: false
					},
					axisLine:{
						lineStyle:{
							color:'#22befd',
							width:0//这里是为了突出显示加上的，可以去掉
						}
					},
					axisLabel: {show:false}
				},
			],
			series : [
				{
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle : {
						normal : {
                            label : {show: true},
							color:'#fa8513'
						}
					},
					name:'电信',
					type:'line',
					smooth: true,
					symbol:'circle',
					stack: '电信新增份额',
					label : {
						show : true,
						textStyle : {
							fontWeight : '500',
							fontSize : '0'
						}
					},
					areaStyle: {
						normal: {
							color:'none'
						}
					},
					data:add_tel_data
				},
				{
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle : {
						normal : {
							color:'#4d94e3'
						}
					},
					name:'移动',
					type:'line',
					smooth: true,
					symbol:'circle',
					stack: '移动新增份额',
					label: {
						normal: {
							show: false,
							position: 'top'
						}
					},
					areaStyle: {
						normal: {
							color:'none'
						}
					},
					data:add_mob_data
				},
				{
					//折线的颜色、圆点的颜色、这线上文字的颜色
					itemStyle : {
						normal : {
							color:'#b5ef8e'
						}
					},
					name:'联通',
					type:'line',
					smooth: true,
					symbol:'circle',
					stack: '联通新增份额',
					label: {
						normal: {
							show: false,
							position: 'top'
						}
					},
					areaStyle: {
						normal: {
							color:'none'
						}
					},
					data:add_uni_data
				}
			]
		};
		// 使用刚指定的配置项和数据显示图表
		chart_line2.setOption(option);
	}

</script>