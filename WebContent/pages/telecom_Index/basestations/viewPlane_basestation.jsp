<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today">
	SELECT TO_CHAR(SYSDATE,'YYYYMMDD') val FROM DUAL
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
	<link href='<e:url value="/pages/telecom_Index/basestations/viewPlane_basestation.css"/>' rel="stylesheet" type="text/css" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->

	<script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
	<script src='<e:url value="/resources/component/echarts_new/theme/dark.js"/>'></script>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/resources/component/Highcharts-5.0.7/code/highcharts.js"/>'></script>
	<script src='<e:url value="/resources/component/Highcharts-5.0.7/code/themes/dark-unica.js"/>'></script>
	<script src='<e:url value="/resources/scripts/admin.js"/>'></script>
	<style>
		html,body {margin:0; padding:0;height:100%;width:100%;border:none; }
		.main{width:100%;height:100%;text-align:left;}

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

		#navDiv1{
			position:absolute;
			top:0px;
			left:0px;
			display:none;
		}
		.navItem{
			height: 32px;
			width: 32px;
			border: 1px solid #DADADA;
			padding: 0px;
			margin-bottom: 3px;
			vertical-align : middle;
			overflow: hidden;
			cursor:pointer;
			background-color: #fff;
		}
		.target_wrap{
			color:#fff;
		}
		#rank_list li {
			padding-top:5px;
		}
	</style>
</head>
<body class="body_padding">
<input type="hidden" id="city_id" />
<div class="g_wrap clearfix main">
	<div class="g_map main_right" id="mainright">
		<div id="pagemap" name="pagemap" width="100%"></div>
		<div id="gismap" name="gismap" width="800px" style="text-align: left;"></div>
	</div>
	<div id="navDiv1" data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'left', splitter:'false'" style="width: 44px; overflow: hidden; padding: 0px; border: 0px; ">
		<div id="zoomin" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
			<img class="navItem" src="../common/images/option_ico/zoomin.png" title="放大" />
		</div>
		<div id="zoomout" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
			<img class="navItem" src="../common/images/option_ico/zoomout.png" title="缩小" />
		</div>
		<div id="extent" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
			<img class="navItem" src="../common/images/option_ico/max_extent.png" title="最大视野" />
		</div>
		<!--<div id="zoomprev" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
            <img class="navItem" src="images/left_previous.gif" title="前一视图" />
        </div>
        <div id="zoomnext" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
            <img class="navItem" src="images/right_next.gif" title="后一视图" />
        </div>
        <div id="pan" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
            <img class="navItem" src="images/hand.gif" title="漫游"/>
        </div>-->
		<div id="hidetiled" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
			<img class="navItem" src="../common/images/option_ico/sh_basemap.png" title="隐藏底图"/>
		</div>
		<div id="hidepoint" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
			<img class="navItem" src="../common/images/option_ico/sh_point.png" title="隐藏基站"/>
		</div>
		<div id="draw_tool" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
			<img class="navItem" src="../common/images/option_ico/polygon.png" title="多边形绘制" />
		</div>
		<div id="earse_tool" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" >
			<img class="navItem" src="../common/images/option_ico/clear.png" title="擦除绘制" />
		</div>
		<div id="query" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'">
			<img class="navItem" src="../common/images/option_ico/query.png" title="模糊查找" />
		</div>
		<div id="back" data-dojo-type="dijit/layout/ContentPane" class="navItem" data-dojo-props="splitter:'false'" onclick="doShowAll(province_name,true)">
			<img class="navItem" src="../common/images/option_ico/back_to_top.png" title="返回上级"/>
		</div>
	</div>

	<div style="display:none;width:150px;height:32px;" id="query_div">
		<input type="text" id="location_name" style="float:left;width:80%;"/>
		<input class="button" id="location_find" value="找" style="float:right;width:20%;"/>
	</div>

	<div class="g_target main_left" id="frmTitle" name="fmTitle" style="overflow:scroll;">
		<h2>基站统计</h2>
		<div class="target_wrap">
			<h3>基站统计</h3>
			<ul class="clearfix">
				<li>
					<p class="target_title">基站总数</p>
					<dl>
						<dt id="total_num">1578</dt>
					</dl>
				</li>
			</ul>
		</div>

		<div class="target_wrap">
			<h3>基站厂家</h3>
			<div id="basestation_factory">
				<table>
				</table>
			</div>
		</div>

		<div class="target_wrap">
			<h3>覆盖地区</h3>
			<div id="basestation_cover_area">
				<table>
				</table>
			</div>
		</div>

		<div class="target_wrap">
			<h3>圈定结果</h3>
			<ul class="clearfix" id="rank_list">
				<li>暂无结果</li>
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

	function doShowAll(city_name,toEcharts){
		global_current_area_name = city_name;

		if(toEcharts){//从gis地图返回echarts地图的时候
			global_current_full_area_name = global_current_area_name;
			global_current_flag = 2;
			map.removeAllLayers();
			map.destroy();
			$("#gismap").hide();
			$("#pagemap").show();
			$("#navDiv1").hide();
			$("#rank_list").html("<li>暂无结果</li>");
			global_current_map = "echarts";
			if(city_name=='临夏州' || city_name=='甘南州')
				global_current_area_name = city_name.replace(/州/gi,'');
			else
				global_current_area_name = city_name.replace(/市/gi,'');
		}
		//echarts地图中 市级返回省级
		chart = echarts.init(document.getElementById('pagemap'),"dark");
		//$("#back").remove();
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
		freshChart(global_current_area_name,false);
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
				if(fullCityName.indexOf("省")==-1){
					//$("#back").remove();
					$("#pagemap").append("<div id=\"back\" style=\"cursor:pointer;left:15px;top:18px;width:53px;height:64px;color:white;position:absolute;\" onclick=\"doShowAll(province_name,true)\"></div>");
					$("#back").css("background-image",'url(<e:url value="/resources/component/echarts_new/images/map_03.png" />)');
				}

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
			//}
			/*if(jsonNo!=undefined){
			 global_current_area_name = city;
			 freshTab(global_current_area_name);
			 freshChart(global_current_area_name,global_current_index_type,getChartDivIndex(global_current_index_type));
			 }else{*/
			var city = "";
			if(cityFull=='临夏州' || cityFull=='甘南州')
				city = cityFull.replace(/州/gi,'');
			else
				city = cityFull.replace(/市/gi,'');

			freshTab(city);
			freshChart(city,global_current_index_type,getChartDivIndex(global_current_index_type));
			//}
		});
	}

	function freshTab(name){
		var name_temp;
		if(name!=province_name && global_current_flag<3){
			if(name =='临夏' || name == '甘南')
				name_temp = name + '州';
			else
				name_temp = name + '市';
		}
		var city_id = city_ids[name];
		if(city_id!=undefined)
			$("#city_id").val(city_id);

		$.post(url4query,{eaction:"basestation_factory",city_name:name,flag:global_current_flag,city_id:$("#city_id").val()},function(data){
			data = $.parseJSON(data);
			if(data.length==0){
				$("#total_num").html("- -");
				$("#basestation_factory").html("<tr><td>暂无记录</td></tr>");
			}else{
				var total = 0;
				var factory_list = "";
				for(var i = 0,l=data.length;i<l;i++){
					factory_list += "<tr><td>"+data[i].FACTORY+"</td><td>"+data[i].COUNT+"</td></tr>";
					total += parseInt(data[i].COUNT);
				}
				$("#basestation_factory").html(factory_list);
				$("#total_num").html(total);
			}
		});
	}

	function freshChart(city_name){
		$.post(url4query,{eaction:"basestation_cover_area",city_name:city_name},function(data){
			data = $.parseJSON(data);
			if(data.length==0){
				$("#basestation_cover_area").html("<tr><td>暂无记录</td></tr>");
			}else{
				var cover_area_list = "";
				for(var i = 0,l = data.length;i<l;i++){
					cover_area_list += "<tr><td>"+data[i].COVER_AREA+"</td><td>"+data[i].COUNT+"</td></tr>";
				}
				$("#basestation_cover_area").html(cover_area_list);
			}
		});
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
				"esri/symbols/SimpleFillSymbol",
				"esri/symbols/SimpleMarkerSymbol",
				"esri/symbols/SimpleLineSymbol",
				"esri/Color",
				"esri/graphic",
				"esri/toolbars/draw",
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
					 SimpleFillSymbol,
					 SimpleMarkerSymbol,
					 SimpleLineSymbol,
					 Color,
					 Graphic,
					 Draw,
					 IdentifyTask,
					 IdentifyParameters,
					 Extent,
					 InfoTemplate,
					 Navigation,
					 query){
				map = new Map("gismap");
				//map.showZoomSlider();

				//本地网地图url
				var layer_ds = "http://135.149.48.47:6080/arcgis/rest/services/NewMap/" + cityForLayer + "/MapServer";
				//var new_url = "http://135.149.48.47:6080/arcgis/rest/services/grid/chenepoint/MapServer";
				var new_url = "http://135.149.48.47:6080/arcgis/rest/services/grid/basestation/MapServer";//基站位置

				var tiled = new ArcGISTiledMapServiceLayer(layer_ds);
				tiled.setOpacity(1);
				map.addLayer(tiled);

				//鼠标悬浮到支局，突出显示鼠标下的支局
				var graLayer_basestation_mouseover = new GraphicsLayer();
				map.addLayer(graLayer_basestation_mouseover);

				var draw_layer = new GraphicsLayer();
				map.addLayer(draw_layer);

				var query_layer = new GraphicsLayer();
				map.addLayer(query_layer,8);

				//基站展示
				var graLayer_qx_basestation = new GraphicsLayer();
				map.addLayer(graLayer_qx_basestation,10);

				var drawAddToMap = function(evt){
					var symbol;
					toolbar.deactivate();
					//map.showZoomSlider();
					var draw_result = $(".target_wrap").eq(3).children().eq(1);
					switch (evt.geometry.type) {
						case "point":
							$(draw_result).html("<li>暂无结果</li>");
							break;
						case "multipoint":
							$(draw_result).html("<li>暂无结果</li>");
							symbol = new SimpleMarkerSymbol();
							break;
						case "polyline":
							$(draw_result).html("<li>暂无结果</li>");
							symbol = new SimpleLineSymbol();
							break;
						default://封闭多边形
							symbol = new SimpleFillSymbol();
							var queryTask = new QueryTask(new_url + "/0");
							var query = new Query();
							query.where = "AREA LIKE '"+ city_name_temp +"%'";
							query.geometry = evt.geometry;
							query.outFields = ["*"];
							query.returnGeometry = true;
							queryTask.execute(query, function (results) {
								var features = results.features;
								if(features.length==0)
									return;
								var result_li = "<li>共搜索到"+features.length+"个结果</li>";
								for(var i = 0,l = features.length;i<l;i++){
									result_li += "<li>ID："+features[i].attributes.CODE+"<br/>名称："+features[i].attributes.CELL_NAME+"</li>";
								}
								$(draw_result).html(result_li);
							});
							break;
					}
					var graphic = new Graphic(evt.geometry, symbol);
					draw_layer.add(graphic);
				}
				var toolbar;//工具栏，放置绘图工具
				map.on("load", function () {
					//$("#back").remove();
					//$("#gismap").append("<div id=\"back\" style=\"cursor:pointer;left:55px;top:18px;width:53px;height:64px;color:white;position:absolute;\" onclick=\"doShowAll('" + parent_name + "',true)\"></div>");
					//$("#back").css("background-image", 'url(<e:url value="/resources/component/echarts_new/images/map_03.png" />)');
					$("#navDiv1").show();
					map.hideZoomSlider();
					//绘画工具
					toolbar = new Draw(map);
					toolbar.on("draw-end", drawAddToMap);
				});

				var navToolbar = new Navigation(map);

				function navEvent(id) {
					switch (id) {
						case 'zoomprev':
							navToolbar.zoomToPrevExtent();
							break;
						case 'zoomnext':
							navToolbar.zoomToNextExtent();
							break;
						case 'extent':
							navToolbar.zoomToFullExtent();
							break;
						case 'zoomin':
							//navToolbar.activate(Navigation.ZOOM_IN);
							map.setLevel(map.getLevel()+1);
							/*if (navOption) {
							 fx.anim(document.getElementById(navOption), {
							 backgroundColor: '#FFFFFF'
							 });
							 }
							 navOption = id;*/
							break;
						case 'zoomout':
							//navToolbar.activate(Navigation.ZOOM_OUT);
							map.setLevel(map.getLevel()-1);
							/*if (navOption) {
							 fx.anim(document.getElementById(navOption), {
							 backgroundColor: '#FFFFFF'
							 });
							 }
							 navOption = id;*/
							break;
						case 'hidetiled':
							if(tiled.visible)
								tiled.hide();
							else
								tiled.show();
							break;
						case 'hidepoint':
							if(graLayer_qx_basestation.visible)
								graLayer_qx_basestation.hide();
							else
								graLayer_qx_basestation.show();
							break;
						case 'query':
							$("#query_div").css({"top":$("#query").offset().top});
							$("#query_div").css({"left":"32px"});
							$("#query_div").toggle();
							break;
					}
				}
				query(".navItem img").onclick(function (evt) {
					navEvent(evt.target.parentNode.id);
				});

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

				var basestation_ico = new Array();
				basestation_ico[0] = '<e:url value="/pages/telecom_Index/common/images/basestation_ico/basestation0.png"/>';//室内
				basestation_ico[1] = '<e:url value="/pages/telecom_Index/common/images/basestation_ico/basestation1.png"/>';//室外

				map.setZoom(2);

				//查询开始
				var queryTask = new QueryTask(new_url + "/0");
				var query = new Query();
				query.where = "AREA LIKE '"+ city_name_temp +"%'";
				//query.where = "AREA LIKE '兰州-金昌路%'";
				//query.outFields = ['CODE','AREA','FACTORY','CELL_NAME','COVER_AREA','COVER_TARGET','CELL_ADDRESS'];
				query.outFields = ["*"];
				query.returnGeometry = true;
				queryTask.execute(query, function (results) {
					if(results.features.length==0)
						return;
					for(var i = 0,l = results.features.length;i<l;i++){
						var feature = results.features[i];
						var geo = feature.geometry;

						//var pointAttributes = {address:'101',city:'Portland',state:'Oregon'};
						var ico = "";
						if(feature.attributes.COVER_TARG.indexOf('室内')>-1)
							ico = basestation_ico[0];
						else
							ico = basestation_ico[1];
						var img = new PictureMarkerSymbol(ico, 6, 6);
						//var graphic = new esri.Graphic(geo,img,pointAttributes);
						/*var mark = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 10,
								new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
										new Color([255,0,0]), 1),
								new Color([0,255,0,0.25]));*/
						var graphic = new esri.Graphic(geo,img);
						graLayer_qx_basestation.add(graphic);
					}
				});

				dojo.connect(graLayer_qx_basestation, "onMouseOut", function(evt){
					map.setMapCursor("default");
					map.infoWindow.hide();
				});

				dojo.query("#draw_tool").onclick(function(evt){
					draw_layer.clear();
					dojo.disconnect(point_mouse_over_handler);
					toolbar.activate(Draw.POLYGON);
					map.hideZoomSlider();
				});
				dojo.query("#earse_tool").onclick(function(evt){
					draw_layer.clear();
					query_layer.clear();
					point_mouse_over_handler = dojo.connect(graLayer_qx_basestation, "onMouseOver",point_mouse_over_function);
					$(".target_wrap").eq(3).children().eq(1).html("<li>暂无结果</li>");
				});
				//
				dojo.query("#zoomin").onclick(function(evt){
					map.setLevel(map.getLevel()+1);
				});
				dojo.query("#zoomout").onclick(function(evt){
					map.setLevel(map.getLevel()-1);
				});

				dojo.query("#location_find").onclick(function(){
					query_layer.clear();
					$("#query_div").hide();
					var location_name = $("#location_name").val();
					var queryTask = new QueryTask(new_url + "/0");
					var query = new Query();
					query.where = "CELL_ADDRE LIKE '"+ location_name +"%'";
					//query.where = "AREA LIKE '兰州-金昌路%'";
					//query.outFields = ['CODE','AREA','FACTORY','CELL_NAME','COVER_AREA','COVER_TARGET','CELL_ADDRESS'];
					query.returnGeometry = true;
					queryTask.execute(query, function (results) {
						var length = results.features.length;
						if(length==0){
							layer.alert("没有结果",{icon:5});
							return;
						}
						for(var i = 0;i<length;i++){
							var geo = results.features[i].geometry;
							var mark = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 30,
									new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
											new Color([0,255,0]), 1),
									new Color([0,255,0,0.25]));
							var graphic = new esri.Graphic(geo,mark);
							query_layer.add(graphic);
						}
					});
				});

				var point_mouse_over_function = function(evt){
					map.setMapCursor("pointer");
					var identifyTask = new esri.tasks.IdentifyTask(new_url);
					var identifyParams = new IdentifyParameters();//查询参数
					identifyParams.tolerance = 3;//容差范围
					identifyParams.returnGeometry = true;//是否返回图形
					identifyParams.layerIds = [0];//查询图层
					identifyParams.where = "AREA LIKE '"+city_name_temp+"%'";
					identifyParams.layerOption = IdentifyParameters.LAYER_OPTION_VISIBLE;//设置查询的图层
					identifyParams.geometry = evt.mapPoint;
					identifyParams.mapExtent = map.extent;
					identifyTask.execute(identifyParams, function (results) {
						if(results.length==0){
							map.infoWindow.hide();
							return;
						}

						map.infoWindow.setTitle("基站信息");
						map.infoWindow.resize(300,200);
						var content = "";
						for(var i = 0,l = results.length;i<l;i++){
							var feature = results[i].feature;
							if(results.length>1)
								content += i+1+".";
							content += "<span>编号:</span>"
								+ feature.attributes.CODE
								+ "<br>"
								+ "<span>名称:</span>"
								+ feature.attributes.CELL_NAME
								+ "<br>"
								+ "<span>地市:</span>"
								+ feature.attributes.AREA + feature.attributes.CELL_ADDRE
								+ "<br>"
								+ "<span>覆盖:</span>"
								+ feature.attributes.COVER_AREA
								+ "&nbsp;&nbsp;"
								+ "<span>生产:</span>"
								+ feature.attributes.FACTORY;
							if(results.length>1)
								content += "<br/>";

						}
						//'CODE','AREA','FACTORY','CELL_NAME','COVER_AREA','CELL_ADDRESS'
						map.infoWindow.setContent(content);
						map.infoWindow.show(evt.screenPoint);
					});
				};
				var point_mouse_over_handler = dojo.connect(graLayer_qx_basestation, "onMouseOver",point_mouse_over_function);

				//var ext_temp = tiled.initialExtent;
				//var ext = new Extent(102.52098204406515,35.60142651026425,104.7648137725631,37.02910311376242, new SpatialReference(4326));
				//map.setExtent(ext,true);

				map.on("zoom-end",function(){
					var s = "";

					s = "XMin: "+ map.extent.xmin

					+" YMin: " + map.extent.ymin

					+" XMax: " + map.extent.xmax

					+" YMax: " + map.extent.ymax;

				});
			}
		);
	}
</script>