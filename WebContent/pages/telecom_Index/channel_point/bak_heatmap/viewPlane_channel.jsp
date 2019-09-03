<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today">
	select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '4'
</e:q4o>
<e:q4o var="date_in_month">
	SELECT TO_CHAR(TO_DATE(MON_A, 'yyyymmdd'), 'yyyymmdd') AS CURRENT_FIRST,
	TO_CHAR(LAST_DAY(TO_DATE(MON_A, 'yyyymmdd')),'yyyymmdd') AS CURRENT_LAST,
	TO_CHAR(TO_DATE(MON_B, 'yyyymmdd'), 'yyyymmdd') AS LAST_FIRST,
	TO_CHAR(LAST_DAY(TO_DATE(MON_B, 'yyyymmdd')), 'yyyymmdd') AS LAST_LAST
	FROM (SELECT TO_CHAR(TO_DATE('${today.val}', 'yyyymmdd'), 'yyyymm') || '01' MON_A,
	TO_CHAR(ADD_MONTHS(TO_DATE('${today.val}', 'yyyymmdd'), -1),
	'yyyymm') || '01' MON_B
	FROM DUAL)
</e:q4o>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>指标看板</title>
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/pages/telecom_Index/channel_point/bak_heatmap/viewPlane_channel.css"/>' rel="stylesheet" type="text/css" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->

	<script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/resources/scripts/admin.js"/>'></script>
	<style>
		html,body {margin:0; padding:0;height:100%;width:100%;border:none;background:none; }
		.main{width:100%;height:100%;text-align:left;background:none!important;}

		.main_left {width:27.5%;float:right;display:block;}
		.main_right {
			height:100%;
			float:left;
			text-align:center;
		}
		.picBox {
			width:9px;
			background:url('../common/images/right.gif') no-repeat center center;
		}
		.main_left,.picBox {float:left;height:100%; _margin-right:-3px; }
		#pagemap div {text-align:center;margin:auto;}
		#pagemap canvas {text-align:center;margin:auto;width:100%;}
		#pagemap {background:none!important;}
		#nav_fanhui {display:none;top:0px;right:0px;}
		.tools_n{display:none;}
	</style>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#hide").click(function(){
				$("#tools").hide();
				$(".tools_n").height(28);
				$("#hide").hide();
				$("#show").show();
			});
			$("#show").click(function(){
				$("#tools").show();
				$(".tools_n").height("98%");
				$("#show").hide();
				$("#hide").show();
			});
		});
	</script>
</head>
<body>
<input type="hidden" id="city_id" />
<div class="g_wrap clearfix main easyui-layout">
	<div class="new_map" id="mainright">
		<div id="pagemap" name="pagemap" width="100%"></div>
		<div id="gismap" name="gismap" width="800px" style="text-align: left;"></div>
		<a href="javascript:backToEchart()" id="nav_fanhui" class="add_backcolor"></a>
		<div class="tools_n" style="position:absolute;top:-12px;left:0px;text-align:center;">
			<a href="javascript:void(0)" id="show">显示</a>
			<a href="javascript:void(0)" id="hide">隐藏</a>
			<ul id="tools">
				<li id="nav_zoomin"><span></span><a href="javascript:void(0)">放大</a></li>
				<li id="nav_zoomout"><span></span><a href="javascript:void(0)">缩小</a></li>
				<li id="nav_hidetiled"><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
				<li id="nav_hidepoint"><span></span><a href="javascript:void(0)" id="hidepoint">网点</a></li>
			</ul>
		</div>
	</div>
	<div class="picBox" onclick="switchSysBar()" id="switchPoint" ></div>
	<div class="channel_rightcont" id="frmTitle" name="fmTitle" >

		<div class="target_wrap" style="margin-top:10px;">
			<h3>重点指标</h3>
			<ul class="target_list clearfix">
				<li>
					<p class="channel_title">移动发展</p>
					<dl>
						<dt>1578</dt>
						<dd>月累计：7580</dd>
						<dd>
							环比：+3.2
							<b class="b1"></b>
						</dd>
					</dl>
				</li>
				<li>
					<p class="channel_title">宽带发展</p>
					<dl>
						<dt>1578</dt>
						<dd>月累计：1380</dd>
						<dd>
							环比：-3.2
							<b class="b2"></b>
						</dd>
					</dl>
				</li>
				<li class="b_none">
					<p class="channel_title">ITV发展</p>
					<dl>
						<dt>1578</dt>
						<dd>月累计：7580</dd>
						<dd>
							环比：+3.2
							<b class="b1"></b>
						</dd>
					</dl>
				</li>
			</ul>
		</div>

		<div class="target_wrap">
			<h3>本月与上月发展量对比</h3>
			<div class="tab">
				<div class="tab_menu">
					<a class="selected">移动</a><a>宽带</a><a>ITV</a>
				</div>
				<div class="tab_box">
					<div class="target_map" id="target_map"></div>
					<div class="target_map hide" id="target_map2"></div>
					<div class="target_map hide" id="target_map3"></div>
				</div>
			</div>
		</div>

		<div class="target_wrap" style="border:none;">
			<h3>发展排名</h3>
			<ul class="target_list clearfix" id="rank_list">
				<li>
					<p class="channel_title">移动发展</p>
					<div class="target_rank">
						<em>1.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>2.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>3.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>4.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>5.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
				</li>
				<li>
					<p class="channel_title">宽带发展</p>
					<div class="target_rank">
						<em>1.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>2.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>3.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>4.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>5.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
				</li>
				<li class="b_none">
					<p class="channel_title">ITV发展</p>
					<div class="target_rank">
						<em>1.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>2.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>3.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>4.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
					<div class="target_rank">
						<em>5.</em>
						<span>兰州</span>
						<font>578</font>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
<script type="text/javascript">
	$(document).ready(function(){
		$(".g_target").height($(window).height()-2);
		$(".g_map").height($(window).height());
		$("#pagemap").height($(window).height()-10);
	})
</script>
<script>
	var chart = "";
	var mapGeoData = "";
	var cityMap = {
		"兰州市": "620100",
		"嘉峪关市": "620200",
		"金昌市": "620300",
		"白银市": "620400",
		"天水市": "620500",
		"武威市": "620600",
		"张掖市": "620700",
		"平凉市": "620800",
		"酒泉市": "620900",
		"庆阳市": "621000",
		"定西市": "621100",
		"陇南市": "621200",
		"临夏州": "622900",
		"甘南州": "623000"
	};

	var city_ids = {
		'酒泉':		'937',
		'定西':		'932',
		'武威':		'935',
		'平凉':		'933',
		'张掖':		'936',
		'嘉峪关':	'947',
		'陇南':		'939',
		'白银':		'943',
		'金昌':		'945',
		'天水':		'938',
		'庆阳':		'934',
		'临夏':		'930',
		'兰州':		'931',
		'甘南':		'941'
	};

	var province_name = "甘肃省";
	var global_current_area_name = province_name;//为满足数据查询，名称去“市”、“州”
	var global_current_full_area_name = province_name;
	var global_parent_area_name = "";
	var global_current_index_type = "移动";
	var global_current_flag = "2";
	var global_current_map = "echarts";

	var url4query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';

	$(function(){
		doShowAll(global_current_area_name,false);

		var $div_li =$("div.tab_menu a");
		$div_li.click(function(){
			$(this).addClass("selected")            //当前<li>元素高亮
					.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
			var index =  $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
			$("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
					.eq(index).show()   //显示 <li>元素对应的<div>元素
					.siblings().hide(); //隐藏其它几个同辈的<div>元素
			global_current_index_type = $.trim($(this).html());

			//当前地图类型是echarts，改变地图显示
			/*if(global_current_map=="echarts"){
			 var params = {};
			 params.flag = global_current_flag;//市级
			 params.index_type = global_current_index_type;
			 params.city_name = global_current_full_area_name;
			 doQuery(params);
			 }*/

			var city = "";
			if(global_current_area_name=='临夏州' || global_current_area_name=='甘南州')
				city = global_current_area_name.replace(/州/gi,'');
			else
				city = global_current_area_name.replace(/市/gi,'');
			freshChart(city,global_current_index_type ,index);
		});
	});

	var backToEchart = function(){
		doShowAll(province_name,true);
		$("#nav_fanhui").hide();
		$(".tools_n").hide();
	}

	function doShowAll(city_name,toEcharts){
		global_current_area_name = city_name;

		if(toEcharts){//从gis地图返回echarts地图的时候
			global_current_full_area_name = global_current_area_name;
			global_current_flag = 2;
			map.removeAllLayers();
			map.destroy();
			$("#gismap").hide();
			$("#pagemap").show();
			global_current_map = "echarts";
			if(city_name=='临夏州' || city_name=='甘南州')
				global_current_area_name = city_name.replace(/州/gi,'');
			else
				global_current_area_name = city_name.replace(/市/gi,'');
		}
		//echarts地图中 市级返回省级
		chart = echarts.init(document.getElementById('pagemap'));
		$("#tables_title").html("当前路径：全省");

		var params = {};

		params.flag = global_current_flag;//市级
		params.index_type = global_current_index_type;
		params.city_name = global_current_area_name;
		global_parent_area_name = global_current_area_name;
		doQuery(params);

		//var chart_index = 0;//默认是移动业务，曲线图切换tab，第1个div索引0

		//右侧 重点指标、发展量曲线图、发展排名
		freshTab(global_current_area_name);
		freshChart(global_current_area_name,global_current_index_type,getChartDivIndex(global_current_index_type),false);
		freshRank(global_current_area_name);
	}

	function getChartDivIndex(global_current_index_type){
		if(global_current_index_type=="宽带")
			return 1;
		else if(global_current_index_type=="ITV")
			return 2;
		return 0;
	}
	function chart_reset(min_num,max_num,city_name,series_name,color,data){
		if(city_name.indexOf("省")>-1)
			city_name = city_name.replace(/省/gi,'');

		try{
			min_num = parseInt(min_num);
		}catch(e){
			min_num = 0;
		}
		try{
			max_num = parseInt(max_num);
		}catch(e){
			max_num = 0;
		}

		if(max_num==0)
			color = ['#A8A8A8'];
		chart.setOption({
			tooltip: {
				trigger: 'item'
			},
			/* visualMap: {
			 min: min_num,
			 max: max_num,
			 left: 'left',
			 top: 'bottom',
			 text: [max_num,min_num],           // 文本，默认为数值文本
			 textStyle:{
			 color:"#fff"
			 },
			 calculable: true,
			 color:color,
			 bottom:'10%'
			 }, */
			dataRange: {
				show:false,
				min: min_num,
				max: max_num,
				x: 'left',
				y: 'bottom',
				selectedMode: false,
				text: [max_num,min_num], // 文本，默认为数值文本
				calculable: true,
				color:color,
				textStyle:{
					color:"#fff"
				}
			},
			toolbox: {
				show: false,
				orient: 'vertical',
				left: 'right',
				top: 'bottom',
				feature: {
					dataView: {readOnly: false},
					restore: {},
					saveAsImage: {}
				}
			},
			series: [{
				layoutCenter: ['50%', '50%'],
				layoutSize: '120%',
				type: 'map',
				//map: city_name,
				mapType: city_name,
				name:series_name,
				roam:true,
				zoom:1,
				selectedMode:'single',
				/* label:{
				 normal:{
				 show:true
				 },
				 emphasis:{
				 show:true,
				 textStyle:{
				 color:'#000',
				 fontSize:16,
				 fontWeight:"bolder"
				 }
				 }
				 }, */
				itemStyle:{
					normal : {
						//borderWidth:0.5,
						//borderColor:'#FFFFFF',
						label : {
							show : true
						}
					},
					emphasis : {
						label : {
							show : true
						}
					}
				},
				scaleLimit:{
					min:1,
					max:3
				},
				data:data
			}]
		},true);
		//chartClickAction(silent);
	}

	function doQuery(params){
		chart.showLoading();
		var fullCityName = params.city_name;
		if(params.flag == 3){
			if(fullCityName=='临夏州' || fullCityName=='甘南州')
				params.city_name = fullCityName.replace(/州/gi,'');
			else
				params.city_name = fullCityName.replace(/市/gi,'');
		}

		wait();
		var series_name = "";
		//表格数据

		//var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
		var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
		//地图数据展示用,最大值最小值
		var datas = new Array();

		var min = 0;
		var max = 0;

		$.ajax({
			type:"POST",
			url:url4query+'?eaction=echarts_map',
			data:params,
			success:function(data){
				var d = $.parseJSON(data);
				if(d.length==0)
					layer.msg('暂无数据');
				else {
					var itemStyle = {};
					var emphasis = {color: "red"};
					itemStyle.emphasis = emphasis;
					//地图数据展示用
					var vals = new Array();

					for (var i = 0; i < d.length; i++) {
						var obj = {};
						var org_name = d[i].ORG_NAME;
						if(params.flag==2)//市级的名称处理(数据库里市级名称和地图不对应)
							if(org_name =='临夏' || org_name == '甘南')
								org_name += '州';
							else
								org_name += '市';
						obj.name = org_name;
						obj.value = d[i].CURRENT_MON_DEV;
						vals.push(obj.value);
						datas.push(obj);
					}

					//if(city_name.indexOf("甘肃")>-1){
					if (vals.length > 0) {
						max = Math.ceil(Math.max.apply(null, vals));
						min = Math.floor(Math.min.apply(null, vals));
						if (min == max)
							min = 0;
					}
				}//else{
				//}
				done();
			},
			error:function(){
				layer.msg('查询出错');
				alert('查询出错');
			},
			complete:function(){
				chart_reset(min,max,fullCityName,series_name,color,datas);
				chartClickAction(fullCityName);
				/*if(fullCityName.indexOf("省")==-1){
				 $("#back").remove();
				 $("#back").css("background-image",'url(<e:url value="/resources/component/echarts_new/images/map_03.png" />)');
				 }*/

				chart.hideLoading();
			}
		});
	}
	function wait(){
		layer.msg('正在处理，请稍后', {icon: 16,time: 0,shade:0.5,shadeClose:false});
	}
	function done(){
		layer.closeAll();
	}
	var global_action = "";//地图中区域选择事件

	function chartClickAction(parent_name){
		chart.on('click', function (params){
			//$("#back").remove();
			var cityFull = params.name;

			//var jsonNo = cityMap[cityFull];

			/*if(jsonNo!=undefined){//从省级点，会获取到地市名称
			 $.get('<e:url value="resources/component/echarts_new/geoJson/gansu/"/>'+jsonNo+'.json', function (cityJson) {
			 echarts.registerMap(cityFull, cityJson);
			 var params = {};
			 params.city_name = cityFull;
			 params.flag = 3;
			 params.index_type = global_current_index_type;
			 global_parent_area_name = parent_name;
			 global_current_full_area_name = cityFull;
			 global_current_flag = 3;
			 doQuery(params);
			 });
			 }else{*///地图已到下钻一层到区县，加载gis地图
			toGis(cityFull,parent_name);
			global_current_flag = 3;

			$("#nav_fanhui").show();
			//}
			/*if(jsonNo!=undefined){
			 global_current_area_name = city;
			 freshTab(global_current_area_name);
			 freshChart(global_current_area_name,global_current_index_type,getChartDivIndex(global_current_index_type));
			 freshRank(global_current_area_name);
			 }else{*/
			var city = "";
			if(cityFull=='临夏州' || cityFull=='甘南州')
				city = cityFull.replace(/州/gi,'');
			else
				city = cityFull.replace(/市/gi,'');

			freshTab(city);
			freshChart(city,global_current_index_type,getChartDivIndex(global_current_index_type));
			freshRank(city);
			//}
		});
	}

	function freshTab(name){
		var divs = $(".target_wrap").children(":eq(1)").children();
		/*var name_temp;
		if(name!=province_name && global_current_flag<3){
			if(name =='临夏' || name == '甘南')
				name_temp = city_name_temp + '州';
			else
				name_temp = city_name_temp + '市';
		}*/
		var city_id = city_ids[name];
		if(city_id!=undefined)
			$("#city_id").val(city_id);

		$.post(url4query,{eaction:"index_get",city_name:name,flag:global_current_flag,city_id:$("#city_id").val()},function(data){
			data = $.trim(data);
			data = $.parseJSON(data);
			if(data.length==0){
				for(var i = 0,l = divs.length;i<l;i++){
					var current_parent_div = divs[i];
					$(current_parent_div).children(":eq(1)").children(":eq(0)").html("- -");
					$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+("- -"));
					$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+("- -")+"<b class='b'></b>");
				}
				return;
			}
			for(var i = 0,l = data.length;i<l;i++){
				var index = data[i];
				var current_parent_div = "";
				if(index.PRODUCT_DESC == '宽带'){
					current_parent_div = divs[1];
				}else if(index.PRODUCT_DESC == 'ITV'){
					current_parent_div = divs[2];
				}else if(index.PRODUCT_DESC == '移动'){
					current_parent_div = divs[0];
				}
				$(current_parent_div).children(":eq(1)").children(":eq(0)").html(index.CURRENT_DAY_DEV);
				$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+(index.CURRENT_MON_DEV));
				var up_down_arrow = "1";
				if(index.CURRENT_DAY_HUAN<0)
					up_down_arrow = "2";
				$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+(index.CURRENT_DAY_HUAN)+"%<b class='b"+up_down_arrow+"'></b>");
			}
		});
	}
	function random(){
		return parseInt(Math.random()*100);
	}
	function freshTabRandom(){
		var divs = $(".target_wrap").children(":eq(1)").children();
		for(var i = 0,l = divs.length;i<l;i++){
			var current_parent_div = divs[i];
			$(current_parent_div).children(":eq(1)").children(":eq(0)").html(random());
			$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+(random()));
			var up_down_arrow = "1";
			if(random()<50)
				up_down_arrow = "2";
			$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+(random()/10)+"%<b class='b"+up_down_arrow+"'></b>");
		}
	}

	function freshChart(city_name,index_type,chart_index){
		var current_month_data = new Array(31);
		var last_month_data = new Array(31);
		//${date_in_month.CURRENT_FIRST}  ${date_in_month.CURRENT_LAST}   ${date_in_month.LAST_FIRST} ${date_in_month.LAST_LAST}
		$.post(url4query,{city_id:$("#city_id").val(),flag:global_current_flag,eaction:"index_month_diff",city_name:city_name,index_type:index_type,date_start:'20170201',date_end:'20170228'},function(data){
			data = $.parseJSON(data);
			for(var i = 0,l = data.length;i<l;i++){
				var index = parseInt(data[i].ACCT_DAY.substring(6));
				//current_month_data.push(data[i].CURRENT_DAY_DEV);
				current_month_data.splice(index,1,data[i].CURRENT_DAY_DEV);
			}
			$.post(url4query,{city_id:$("#city_id").val(),flag:global_current_flag,eaction:"index_month_diff",city_name:city_name,index_type:index_type,date_start:'20170301',date_end:'20170304'},function(data){
				data = $.parseJSON(data);
				for(var i = 0,l = data.length;i<l;i++){
					//last_month_data.push(data[i].CURRENT_DAY_DEV);
					var index = parseInt(data[i].ACCT_DAY.substring(6));
					//current_month_data.push(data[i].CURRENT_DAY_DEV);
					last_month_data.splice(index,1,data[i].CURRENT_DAY_DEV);
				}

				//var days = 31;
				/*var days = current_month_data>=last_month_data?current_month_data.length:last_month_data.length;
				 console.log("数据天数："+days);
				 var days_array = new Array();
				 for(var i = 1,l = days.length;i<=l;i++){
				 days_array.push(i);
				 }*/

				var chart_div_id = "target_map";
				$("."+chart_div_id).hide();
				if(chart_index>0)
					chart_div_id += chart_index+1;

				$("#"+chart_div_id).show();
				var myChart = echarts.init(document.getElementById(chart_div_id));

				var option = {
					title: {
						text: ''
					},
					tooltip : {
						trigger: 'axis',
						position:"top",
						formatter:function(params){
							var last = params[0];
							var thiz = params[1];
							return thiz.seriesName+thiz.name+"号:"+(thiz.value==undefined?"-":thiz.value)+"<br/>"+last.seriesName+last.name+"号:"+(last.value==undefined?"-":last.value);
							//"{a0}{b0}号:{c0}<br/>{a1}{b1}号:{c1}"
						},
						show:false
					},
					legend: {
						data:['本月','上月'],
						orient: 'vertical',
						left:'right',
						right:60,
						top:22,
						inactiveColor:'#999',
						textStyle:{
							color:'#eee'
						}
					},
					color:['#517693','#61a0a8'],//517693 //2f4554
					toolbox: {
						show:false
					},
					grid: {
						/*left: '3%',
						 right: '4%',
						 bottom: '3%',*/
						top: 10,
						left:0,
						right:60,
						bottom:0,
						//containLabel: true,
						align:"right"
					},
					xAxis : [
						{
							min:1,
							max:31,
							scale:0,
							splitNumber:1,
							minInterval:1,
							interval:1,
							type : 'category',
							boundaryGap : false,
							connectNulls : true,
							data : ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
							//data : days_array
						}
					],
					yAxis : [
						{
							silent: true,
							splitLine: {
								show: false
							},
							connectNulls : true,
							type : 'value'
						}
					],
					series : [
						{
							name:'上月',
							type:'line',
							symbol:'none',
							smooth:true,
							//stack: '总量',
							areaStyle: {normal: {}},
							data:last_month_data,
							showAllSymbol:true
						},
						{
							name:'本月',
							type:'line',
							symbol:'none',
							smooth:true,
							//stack: '总量',
							areaStyle: {normal: {}},
							data:current_month_data,
							showAllSymbol:true
						}
					]
				};
				myChart.setOption(option);
			});
		});

	}

	function freshRank(city_name){
		$.post(url4query,{eaction:"proc_get",city_name:city_name},function(data){
			data = $.trim(data);
			data = $.parseJSON(data);
			if(data.length==0)
				return;
			var lis = $("#rank_list").children();
			for(var i = 0,l=lis.length;i<l;i++){
				var ps = $(lis[i]).children();
				for(var o = 0,p =ps.length;o<p-1;o++){
					var obj = data[5*i+o];
					$(ps[o+1]).find("em").html(obj.PROC_RANK+".");
					$(ps[o+1]).find("span").html(obj.CITY_NAME);
					$(ps[o+1]).find("font").html(obj.PROC_NUM);
				}
			}
		});
	}

	//获取min到max范围内的一个随机数
	function RandomNum(Min, Max) {
		var Range = Max - Min;
		var Rand = Math.random();
		var num = Min + Math.floor(Rand * Range); //舍去
		return num;
	}

	var cityNames = {
		"兰州市": "lanzhou",
		"嘉峪关市": "jiayuguan",
		"金昌市": "jinchangshi",
		"白银市": "baiyin",
		"天水市": "tianshui",
		"武威市": "wuwei",
		"张掖市": "zhangyeshi",
		"平凉市": "pingliang",
		"酒泉市": "jiuquan",
		"庆阳市": "qinyang",
		"定西市": "dingxi",
		"陇南市": "longnan",
		"临夏州": "linxiashi",
		"甘南州": "gannan"
	};

	//不同区县下的支局群所使用配色方案
	var city_colors = [
		/*[137,225,116,0.6],
		 [250,215,121,0.6],
		 [180,169,238,0.6],
		 [241,183,169,0.6],
		 [216,243,164,0.6],
		 [176,190,240,0.6],
		 [235,230,144,0.6],
		 [233,195,204,0.6],
		 [159,229,215,0.6]*/
		[32,90,167,0.7],
		[81,31,114,0.7],
		[115,136,193,0.7],
		[130,115,176,0.7],
		[81,31,144,0.7],
		[121,55,139,0.7],
		[176,190,240,0.7],
		[180,169,238,0.7],
		[93,12,123,0.7]
	];

	//GIS地图
	var map = "";//在toGis中创建，在doShowAll中销毁

	//渲染 某个区县 下的支局群板块，填充颜色
	function toGis(city_name,parent_name) {
		var city_name_temp = "";
		if(city_name=='临夏州' || city_name=='甘南州')
			city_name_temp = city_name.replace(/州/gi,'');
		else
			city_name_temp = city_name.replace(/市/gi,'');

		global_current_area_name = city_name;
		global_current_flag = 3;
		//右侧联动刷新
		freshTab(city_name_temp);

		var chart_index = 0;//默认是移动业务，曲线图切换tab，第1个div索引0
		if (global_current_index_type == "宽带")
			chart_index = 1;
		else if (global_current_index_type == "ITV")
			chart_index = 2;

		freshChart(city_name_temp, global_current_index_type, getChartDivIndex(global_current_index_type));
		freshRank(city_name_temp);

		global_current_map = "gis";
		chart.dispose();
		//var cityForLayer = cityNames[parent_name];
		var cityForLayer = cityNames[city_name];
		/*if (cityForLayer == undefined)
		 return;*/

		$("#pagemap").hide();
		$("#gismap").show();
		$("#gismap").height($(window).height());

		require(["esri/map",
					"esri/layers/ArcGISTiledMapServiceLayer",
					"esri/layers/GraphicsLayer",
					"esri/tasks/query",
					"esri/tasks/QueryTask",
					"esri/symbols/PictureMarkerSymbol",
					"esri/graphic",
					"esri/tasks/IdentifyTask",
					"esri/tasks/IdentifyParameters",
					"esri/geometry/Extent",
					"esri/InfoTemplate",
					"esri/toolbars/navigation",
					"dojo/query",
					"dojo/domReady!"],
				function(Map,
						 ArcGISTiledMapServiceLayer,
						 GraphicsLayer,
						 Query,
						 QueryTask,
						 PictureMarkerSymbol,
						 graphic,
						 IdentifyTask,
						 IdentifyParameters,
						 Extent,
						 InfoTemplate,
						 Navigation,
						 query){
					map = new Map("gismap");

					map.on("load", function () {
						map.hideZoomSlider();
						$(".tools_n").show();
					});

					var navToolbar = new Navigation(map);

					function navEvent(id) {
						switch (id) {
							case 'nav_zoomprev':
								navToolbar.zoomToPrevExtent();
								break;
							case 'nav_zoomnext':
								navToolbar.zoomToNextExtent();
								break;
							case 'nav_extent':
								navToolbar.zoomToFullExtent();
								break;
							case 'nav_zoomin':
								//navToolbar.activate(Navigation.ZOOM_IN);
								map.setLevel(map.getLevel()+1);
								/*if (navOption) {
								 fx.anim(document.getElementById(navOption), {
								 backgroundColor: '#FFFFFF'
								 });
								 }
								 navOption = id;*/
								break;
							case 'nav_zoomout':
								//navToolbar.activate(Navigation.ZOOM_OUT);
								map.setLevel(map.getLevel()-1);
								/*if (navOption) {
								 fx.anim(document.getElementById(navOption), {
								 backgroundColor: '#FFFFFF'
								 });
								 }
								 navOption = id;*/
								break;
							case 'nav_hidetiled':
								if(tiled.visible)
									tiled.hide();
								else
									tiled.show();
								break;
							case 'nav_hidepoint':
								if(graLayer_qx_wd.visible)
									graLayer_qx_wd.hide();
								else
									graLayer_qx_wd.show();
								break;
						}
					}
					query("#tools li").onclick(function (evt) {
						navEvent(evt.target.parentNode.id);
					});

					//本地网地图url
					//var layer_ds = "http://135.149.48.47:6080/arcgis/rest/services/NewMap/" + cityForLayer + "/MapServer";
					//var layer_ds = "http://135.149.48.47:6080/arcgis/rest/services/map/gansumap/MapServer";
					//var new_url = "http://135.149.48.47:6080/arcgis/rest/services/grid/chenepoint/MapServer";
					var new_url = "http://135.149.48.47:6080/arcgis/rest/services/grid/new_sub_grid_netpoint2/MapServer";
					var channel_point_density = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/channel_point_density/MapServer";

					//支局 id 字典
					var js_map = new Array();

					//实体渠道 子分类
					var color_map = new Array();
					/*color_map['2001000'] = '自有厅';
					 color_map['2001100'] = '专营店';
					 color_map['2001200'] = '连锁店';
					 color_map['2001300'] = '独立店';
					 color_map['2001400'] = '便利点';*/
					color_map['2001000'] = [164,0, 233,1];
					color_map['2001100'] = [255,229,0,1];
					color_map['2001200'] = [254,84, 0,1];
					color_map['2001300'] = [106,226,0,1];
					color_map['2001400'] = [9,0, 183,1];

					var channel_ico = new Array();
					/*channel_ico['2001000'] = "images/channel_ico/bz.png";
					 channel_ico['2001100'] = "images/channel_ico/hq.png";
					 channel_ico['2001200'] = "images/channel_ico/sd.png";
					 channel_ico['2001300'] = "images/channel_ico/wj.png";
					 channel_ico['2001400'] = "images/channel_ico/wx.png";*/
					channel_ico['2001000'] = "../common/images/channel_ico_new/channel_point1.png";
					channel_ico['2001100'] = "../common/images/channel_ico_new/channel_point2.png";
					channel_ico['2001200'] = "../common/images/channel_ico_new/channel_point3.png";
					channel_ico['2001300'] = "../common/images/channel_ico_new/channel_point4.png";
					channel_ico['2001400'] = "../common/images/channel_ico_new/channel_point5.png";

					var color_point_line = [255,0,0];

					/*var tiled = new ArcGISTiledMapServiceLayer(layer_ds);
					tiled.setOpacity(1);
					map.addLayer(tiled);*/
					var tiled = new esri.layers.ArcGISDynamicMapServiceLayer("http://135.149.48.47:6080/arcgis/rest/services/map/gansumap/MapServer");
					map.addLayer(tiled);

					var dmslayer = new esri.layers.ArcGISDynamicMapServiceLayer(channel_point_density);
					map.addLayer(dmslayer);
					dmslayer.setOpacity(0.3);

					//网点展示
					var graLayer_qx_wd = new GraphicsLayer();
					map.addLayer(graLayer_qx_wd);
					var graLayer_zj_wd = new GraphicsLayer();
					map.addLayer(graLayer_zj_wd);
					var graLayer_wg_wd = new GraphicsLayer();
					map.addLayer(graLayer_wg_wd);
					var graLayer_wg_child_wd = new GraphicsLayer();
					map.addLayer(graLayer_wg_child_wd);

					//鼠标悬浮到支局，突出显示鼠标下的支局
					var graLayer_sub_mouseover = new GraphicsLayer();
					map.addLayer(graLayer_sub_mouseover);
					//突出显示行政区县的层，包含区县轮廓，所有支局填充
					var graLayer_qx = new GraphicsLayer();
					//map.addLayer(graLayer_qx);
					//支局名字的层，包含所有支局名称
					var graLayer_zjname = new GraphicsLayer();
					//graLayer_zjname.setScaleRange(25000, 50000);
					//graLayer_zjname.setMinScale(5);
					map.addLayer(graLayer_zjname);
					//下钻时突出显示支局范围的层,包含网格填充、网格名称、支局轮廓
					var graLayer_wg = new GraphicsLayer();
					map.addLayer(graLayer_wg);
					var graLayer_wg_child = new GraphicsLayer();
					map.addLayer(graLayer_wg_child);

					map.setZoom(2);

					var latn_id = "";
					//查询开始
					$.post(url4query,{eaction:"getLatnIdByCityName",city_name: city_name_temp}, function (data) {
						data = $.parseJSON(data);

						var queryTask = new QueryTask(new_url + "/0");
						var query = new Query();
						latn_id = data.LATN_ID;
						query.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +"";
						query.outFields = ['CLASS3_ID'];
						query.returnGeometry = true;
						var city_geometry = "";//所展示市级范围的图形对象
						queryTask.execute(query, function (results) {
							if(results.features.length==0)
								return;
							for(var i = 0,l = results.features.length;i<l;i++){
								var feature = results.features[i];
								var geo = feature.geometry;
								var class3_id = feature.attributes.CLASS3_ID;

								var pointAttributes = {address:'101',city:'Portland',state:'Oregon'};
								var img = new PictureMarkerSymbol(channel_ico[class3_id], 12, 12);
								var graphic = new esri.Graphic(geo,img,pointAttributes);
								graLayer_qx_wd.add(graphic);
								/*var pointTemplate = new InfoTemplate("Geocoding Results");
								 var graphic = new esri.Graphic(geo,img,pointAttributes).setInfoTemplate(pointTemplate);*/
							}
						});
					});
					graLayer_qx_wd.setOpacity(0);
					graLayer_qx_wd.on("click",function(evt){
						global_current_flag = 7;
						var identifyTask = new esri.tasks.IdentifyTask(new_url);
						var identifyParams = new IdentifyParameters();//查询参数
						identifyParams.tolerance = 5;//容差范围
						identifyParams.returnGeometry = true;//是否返回图形
						identifyParams.layerIds = [0];//查询图层
						identifyParams.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +"";
						identifyParams.layerOption = IdentifyParameters.LAYER_OPTION_VISIBLE;//设置查询的图层
						identifyParams.geometry = evt.mapPoint;
						identifyParams.mapExtent = map.extent;
						identifyTask.execute(identifyParams, function (results) {
							if(results.length==0){
								map.infoWindow.hide();
								return;
							}

							var feature = results[0].feature;
							var channel_name = feature.attributes.CHANNEL_NA;
							global_current_area_name = channel_name;
							freshTab(channel_name);
							freshChart(channel_name, global_current_index_type, getChartDivIndex(global_current_index_type));
							freshRank(channel_name);
						});
					});
					dojo.connect(graLayer_qx_wd, "onMouseOut", function showCoordinates(evt){
						map.setMapCursor("default");
						map.infoWindow.hide();
					});
					dojo.connect(graLayer_qx_wd, "onMouseOver", function showCoordinates(evt){
						map.setMapCursor("pointer");
						var identifyTask = new esri.tasks.IdentifyTask(new_url);
						var identifyParams = new IdentifyParameters();//查询参数
						identifyParams.tolerance = 5;//容差范围
						identifyParams.returnGeometry = true;//是否返回图形
						identifyParams.layerIds = [0];//查询图层
						identifyParams.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +"";
						identifyParams.layerOption = IdentifyParameters.LAYER_OPTION_VISIBLE;//设置查询的图层
						identifyParams.geometry = evt.mapPoint;
						identifyParams.mapExtent = map.extent;
						identifyTask.execute(identifyParams, function (results) {
							if(results.length==0){
								map.infoWindow.hide();
								return;
							}

							var feature = results[0].feature;

							map.infoWindow.setTitle("网点信息");
							map.infoWindow.resize(200,80);
							map.infoWindow.setContent("<span>店名:</span>"
							+ feature.attributes.CHANNEL_NA
							+ "<br>"
							+ "<span>地址:</span>"
							+ feature.attributes.CHANNEL_AD);
							map.infoWindow.show(evt.screenPoint);
						});
					});

					//var ext_temp = tiled.initialExtent;
					//var ext = new Extent(102.52098204406515,35.60142651026425,104.7648137725631,37.02910311376242, new SpatialReference(4326));
					//map.setExtent(ext,true);

					map.on("extent-change", function(){
						var mapZoom = map.getZoom();
						channel_point_symbol_change(mapZoom);
					});
					var channel_point_symbol_change = function(current_zoom){
						var size = 0
						if(current_zoom>6){
							size = 20;
						}else if(current_zoom==6){
							size = 19;
						}else if(current_zoom==4 || current_zoom==5){
							size = 18;
						}else if(current_zoom==3){
							size = 17;
						}else if(current_zoom==2){
							size = 15;
						}else if(current_zoom==1){
							size = 12;
						}
						var gs = graLayer_qx_wd.graphics;
						if(gs.length==0)
							return;
						var gs_new = new Array();
						var geo_new = new Array();
						for(var i = 0,l = gs.length;i<l;i++){
							var sym = gs[i].symbol;
							sym.width = size;
							sym.height = size;
							gs_new.push(sym);
							geo_new.push(gs[i].geometry);
						}
						graLayer_qx_wd.clear();
						for(var i = 0,l = gs_new.length;i<l;i++){
							var pointAttributes = {address:'101',city:'Portland',state:'Oregon'};
							var img = new PictureMarkerSymbol(gs_new[i].url, gs_new[i].width, gs_new[i].height);
							var graphic = new esri.Graphic(geo_new[i],img,pointAttributes);
							graLayer_qx_wd.add(graphic);
						}
					}

					map.on("zoom-end",function(){
						var s = "";

						s = "XMin: "+ map.extent.xmin

						+" YMin: " + map.extent.ymin

						+" XMax: " + map.extent.xmax

						+" YMax: " + map.extent.ymax;

						console.log(s);
					});
				}
		);
	}
</script>