<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today">
	select to_char(sysdate, 'yyyymmdd') val from dual
</e:q4o>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '4'
</e:q4o>
<e:q4o var="today_ymd">
	SELECT TO_CHAR(SYSDATE,'YYYY'||'"年"'||'MM'||'"月"'||'DD'|| '"日"') val FROM DUAL
</e:q4o>
<e:q4o var="today_time">
	SELECT TO_CHAR(SYSDATE,'hh24'||'":"'||'mi'||'":"'||'ss') val FROM DUAL
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
	<meta http-equiv="X-UA-Compatible" content="IE=7" />
	<title>指标看板</title>
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/pages/telecom_Index/common/js/printWord.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/channel_point/css/viewPlane_channel.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/dz.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/left_menu_control.js?version=1.1"/>' charset="utf-8"></script>
	<script src='<e:url value="/resources/scripts/admin.js"/>'></script>

</head>
<body>
<div id="channel_info_win" style="display:none;background-color: #fff;position: fixed;top: 40%;left: 26%;z-index: 99999999999;width: 300px;height: 180px;border: 2px solid #2070dc;border-radius: 4px">
	<span style="font-weight: bold;color: red;padding-top: 20px">店名：</span><em style="color: red;"></em>
	<br>
	<span style="font-weight: bold;margin-top: 20px">地址：</span><em></em>
	<br>
	<span style="font-weight: bold;margin-top: 20px">类型：</span><em></em>
	<table style="width: 98%;font-size: 14px;text-align: center";>
		<tr>
			<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf  "></td>
			<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">当月</td>
			<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;">当日</td>
		</tr>
		<tr>
			<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">移动</td>
			<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf" ><em></em></td>
			<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;"><em></em></td>
		</tr>
		<tr>
			<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">宽带</td>
			<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
			<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
		</tr>
		<tr>
			<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">itv</td>
			<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
			<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
		</tr>
	</table>
</div>
<input type="hidden" id="city_id" />
<div class="g_wrap clearfix main easyui-layout">
	<div class="new_map" id="mainright">
		<!-- 地图收缩 左上角echarts缩略图 鹰眼-->
		<div class="point_map_box">
			<div class="point_zk">
				<div class="point_bg"></div>
		        <div class="shrink_btn1"></div>
				<div class="point_map" id="point_map"></div>
			</div>
		</div>

		<div class="shrink_btn2"></div>
		<!-- 时间表 -->
		<div class="date_container">
			<div class="date">-年-月-日 <span>-:-:-</span></div>
		</div>
		<!-- 网点弹框 图例-->
		<div class="popup_type">
			<span>渠道类型:</span>
			<input type="checkbox" name="point_type" id="point_type1" value="2001000,2001100,2001200,2001300,2001400" checked="checked" /><label for="point_type1">全部</label>
			<input type="checkbox" name="point_type" id="point_type2" value="2001000" /><label for="point_type2">自有</label>
			<input type="checkbox" name="point_type" id="point_type3" value="2001100" /><label for="point_type3">专营</label>
			<input type="checkbox" name="point_type" id="point_type4" value="2001200" /><label for="point_type4">连锁</label>
			<input type="checkbox" name="point_type" id="point_type5" value="2001300" /><label for="point_type5">独立</label>
			<input type="checkbox" name="point_type" id="point_type6" value="2001400" /><label for="point_type6">便利</label>
			<span>|&nbsp;<em>渠道名称:</em></span>
			<input type="text" id="location_name" width="auto"/>
			<input class="button" id="location_find" readonly="readonly" value="搜索" style="width:32px;" />

		</div>
		<span class="tab_right" id="expanded" style="z-index:1099;"></span>
		<div id="res_in_view"></div>

		<div id="clear_draw_menu" style="padding: 10px 10px 0px 10px;background-color: rgba(0,0,0,0.8);color: #fff;">清除绘制</div>
		<div id="pop_res_win_layer" style="padding: 10px;background-color: rgba(0,0,0,0.8);color: #fff;margin-top: 10px">结果窗口</div>

		<!-- gis地图 -->
		<div id="gismap" name="gismap" style="text-align: left;width:100%;height:100%;"></div>

		<div id="draw_result_container" >
			<div id="draw_result" style="z-index:99999">
				<table style="color: #fff;text-align: center;width: 100%;margin-top: 34px;">
				</table>
			</div>
			<div id="draw_result_total"></div>
		</div>

		<!-- 工具栏 -->
		<div class="tools_n" style="position:absolute;top:-12px;left:0px;text-align:center;z-index:99999">
			<a href="javascript:void(0)" id="show">显示</a>
			<a href="javascript:void(0)" id="hide">隐藏</a>
			<ul id="tools">
				<li id="nav_zoomin"><span></span><a href="javascript:void(0)">放大</a></li>
				<li id="nav_zoomout"><span></span><a href="javascript:void(0)">缩小</a></li>
				<li id="nav_hidetiled" class="active"><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
				<li id="nav_hidepoint_btn" class="active"><span></span><a href="javascript:void(0)" id="hidepoint">选择</a></li>
				<li id="nav_query"><span></span><a href="javascript:void(0)" id="query">查找</a></li>
				<li id="nav_draw"><span></span><a href="javascript:void(0)" id="drawTool">框选</a></li>
				<li id="nav_earse"><span></span><a href="javascript:void(0)" id="earseTool">擦除</a></li>
				<li id="nav_sub"><span></span><a href="javascript:void(0)" id="navSub">支局</a></li>
			</ul>
		</div>
	</div>
	<div id="query_div">
		<select id="location_type">
			<option value="0">渠道</option>
		</select>
		<input type="text" id="location_name1" class="location_name1"/>
		<input class="button1" id="location_find1" readonly="readonly" value="搜索" />
	</div>
	<div class="picBox" onclick="switchSysBar()" id="switchPoint" ></div>
	<div class="channel_rightcont" id="frmTitle" name="fmTitle" >
		<div class="target_wrap" >
			<h3>重点指标</h3>
			<ul class="target_list clearfix">
				<li>
					<p class="channel_title">移动发展</p>
					<dl>
						<dt>- -</dt>
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
						<dt>- -</dt>
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
						<dt>- -</dt>
						<dd>月累计：7580</dd>
						<dd>
							环比：+3.2
							<b class="b1"></b>
						</dd>
					</dl>
				</li>
			</ul>
		</div>

		<div class="target_wrap" style="cursor: hand">
			<h3>发展排名</h3>
			<table id="channel_rank" class="easyui-datagrid" style="width:100%;height:auto;cursor:hand;" scrollbarSize="0" sortOrder="desc"
				   rownumbers="false" fitColumns="true" autoRowHeight="false">
				<thead>
				<tr>
					<th field="XH" width="10%" height="30" align="center" formatter="xh_formatter">序号</th>
					<th field="LATN_NAME" width="12%" height="30" align="left">分公司</th>
					<th field="CHANNEL_NAME" width="33%" height="30" align="left" halign="center" title="CHANNEL_NAME" formatter="channel_name_formatter">网点</th>
					<th field="YD_CURRENT_MON_DEV" width="15%"  height="30" align="center" sortable="true">移动</th>
					<th field="KD_CURRENT_MON_DEV" width="15%" height="30" align="center" sortable="true">宽带</th>
					<th field="ITV_CURRENT_MON_DEV" width="15%"  height="30" align="center" sortable="true">ITV</th>
				</tr>
				</thead>
			</table>
		</div>

		<div class="target_wrap" style="border:none;">
			<h3>实时发展</h3>

			<table class="point_rank_tab" id="scrollDiv">
				<thead>
				<tr>
					<th width="10%">序号</th>
					<th width="13%">分公司</th>
					<th width="40%">网点</th>
					<th width="10%">接入号</th>
					<th width="10%">产品</th>
					<th width="17%">时间</th>
				</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
</html>
<script>
	var sub_name_text_color = [0,0,0];
	var sub_name_label_symbol1 = new Array();
	var sub_name_label_symbol2 = new Array();
	var sub_name_label_symbol3 = new Array();
	var sub_name_label_symbol4 = new Array();
	var sub_name_label_symbol5 = new Array();

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

	var city_ids_revers = {
		'937': '酒泉市'	,
		'932': '定西市'	,
		'935': '武威市'	,
		'933': '平凉市'	,
		'936': '张掖市'	,
		'947': '嘉峪关市',
		'939': '陇南市'  ,
		'943': '白银市'  ,
		'945': '金昌市'  ,
		'938': '天水市'  ,
		'934': '庆阳市'  ,
		'930': '临夏州'  ,
		'931': '兰州市'  ,
		'941': '甘南州'
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

	var channel_type_array = {
		"2001100": "专营店",
		"2001000": "自有厅",
		"2001200": "连锁店",
		"2001300": "独立店",
		"2001400": "便利点"
	};

	var city_center_zoom = {
		'兰州市':{lng:103.81464488523005,lat:36.06453850686261,zoom:5},//
		'天水市':{lng:105.79644070962411,lat:34.749631494944,zoom:3},//
		'白银市':{lng:104.63114430560627,lat:36.70113888545103,zoom:2},//
		'酒泉市':{lng:96.49607749152115,lat:40.055780435920425,zoom:1},//
		'张掖市':{lng:100.2556198885648,lat:38.90265857976021,zoom:2},//
		'武威市':{lng:102.96454075478259,lat:37.76236022542323,zoom:2},//
		'金昌市':{lng:102.03549646603634,lat:38.40776306467084,zoom:3},//
		'嘉峪关市':{lng:98.28700964379297,lat:39.7848151118973,zoom:6},//
		'定西市':{lng:104.54285122255448,lat:35.236092651893514,zoom:2},//
		'平凉市':{lng:107.05477532978537,lat:35.29665760991574,zoom:3},//
		'庆阳市':{lng:107.63756868802444,lat:35.853636046084304,zoom:3},//
		'陇南市':{lng:105.24142185427272,lat:33.564268523965886,zoom:3},//
		'临夏州':{lng:103.25646791739254,lat:35.57436660380768,zoom:3},//
		'甘南州':{lng:102.9080918854151,lat:34.983031870031574,zoom:6}//
	};

	var name_short_array_reverse = {
		"张家川回族自治县":"甘肃省张家川回族自治县",//天水
		"肃北蒙古族自治县":"甘肃省肃北蒙古族自治县",//酒泉
		"阿克塞哈萨克族自治县":"甘肃省阿克塞哈萨克族自治县",//酒泉
		"肃南裕固族自治县":"甘肃省肃南裕固族自治县",//张掖
		"天祝藏族自治县":"甘肃省天祝藏族自治县",//武威,两个凉州区
		"东乡族自治县":"甘肃省东乡族自治县",//临夏
		"合作市":"合作区"//甘南
	};

	var sub_name_speical = {
		"947":{
			"昌盛支局":1,
			"东安支局":1,
			"四零四支局":1,
			"永乐支局":1,
			"新华支局":1
		},
		"932":{
			"通渭西城支局":1,
			"陇西北城支局":1,
			"陇西东城支局":1
		}
	};

	var use_auth = false;
	var user_level = '${sessionScope.UserInfo.LEVEL}';//用户的划小层级
	var global_current_area_name = "";//为满足数据查询，名称去“市”、“州”
	var global_current_full_area_name = "";
	if(user_level=="" || user_level==undefined){
		layer.msg("与服务器连接断开，请重新登录");
	}else{
		if(user_level=="1"){
			global_current_area_name = "兰州";
			global_current_full_area_name = "兰州市";
			use_auth = true;
		}else if(user_level=="2"){
			global_current_full_area_name = '${sessionScope.UserInfo.AREA_NAME}';
			if(city_name_speical.indexOf(global_current_full_area_name)>-1)
				global_current_area_name = global_current_full_area_name.replace(/州/gi,'');
			else
				global_current_area_name = global_current_full_area_name.replace(/市/gi,'');
			use_auth = true;
		}else{
			layer.msg("省、市级别用户可使用该模块");
		}
	}
	var global_parent_area_name = province_name;
	var global_current_index_type = default_show_index;
	var global_current_flag = default_flag+1;

	var city_id = city_ids[global_current_area_name];

	var map_id = map_id_in_gis[city_id];

	var url4query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';

	var checkbox_length = 0;
	var checkNum = 0;
	var interval_time= 5*1000;

	var sub_fill_color = [0, 255, 255, 0.25];
	var sub_line_color = [0,165,163];
	var sub_line_width = 1;
	var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];//echart配色

	var draw_line_color = [234,0,61];//绘制工具 划线 线条配色 rgb
	var draw_line_width = 2;//绘制工具 划线 线条粗细 越大越粗
	var draw_fill_color = [10,10,10,0.3];//绘制工具 封闭多边形填充色 rgba

	var divs = $(".target_wrap").children(":eq(1)").children();

	//用于网点排名 datagrid 网点名和序号的方法
	//序号的方法
	function xh_formatter(value,row,index){
		return index+1;
	}
	//网点名
	function channel_name_formatter(value){
		if(value.length>9)
			return "<span title='"+value+"'>"+value.substr(0,9)+"..</span>";
		else
			return "<span title='"+value+"'>"+value+"</span>";
	}

	//用于时间表
	var time = '${today_time.VAL}';
	var time_arry = time.split(":");
	var date = '${today_ymd.VAL}';
	var year = date.substr(0,date.indexOf("年"));
	var month = date.substring(date.indexOf("年")+1,date.indexOf("月"));
	var day = date.substring(date.indexOf("月")+1,date.indexOf("日"));
	var dt = new Date();//秒表
	dt.setFullYear(parseInt(year));
	dt.setMonth(parseInt(month)-1);
	dt.setDate(parseInt(day));
	dt.setHours(parseInt(time_arry[0]));
	dt.setMinutes(parseInt(time_arry[1]));
	dt.setSeconds(parseInt(time_arry[2]));

	$(function(){
		$("#point_map").height($(".point_zk").height());
		$("#point_map").width($(".point_zk").width());

		//时间表
		setInterval(
			function(){
				dt.setTime(dt.getTime()+1000);
				$(".date").html(dt.getFullYear()+"年"+("0"+(dt.getMonth()+1)).slice(-2)+"月"+("0"+(dt.getDate()+1)).slice(-2)+"日"+"<span>"+("0"+dt.getHours()).slice(-2)+":"+("0"+dt.getMinutes()).slice(-2)+":"+("0"+dt.getSeconds()).slice(-2));
			},1000
		);

		checkbox_length = $(".popup_type").children("input:gt(0):lt(5)").length;
		checkNum = checkbox_length;

		//工具栏调用图例
		var expanded1 = false;
        var ex = $('#expanded')
		$('#nav_hidepoint_btn').click(function(){
			if(expanded1){
				ex.removeClass("tab_left")
                ex.addClass("tab_right")
                $('.popup_type').animate({right:'0'},500);
				$('#nav_hidepoint_btn').addClass("active");
			}else{
                ex.removeClass("tab_right")
                ex.addClass("tab_left")
				$('.popup_type').animate({right:'-67%'},500);
				$('#nav_hidepoint_btn').removeClass("active");
			}
			expanded1 = !expanded1;
		});

		$('#expanded').click(function(){
			if(expanded1){
				ex.removeClass("tab_left")
                ex.addClass("tab_right")
				$('.popup_type').animate({right:'0'},500);
				$('#nav_hidepoint_btn').addClass("active");
			}else{
                ex.removeClass("tab_right")
				ex.addClass("tab_left")
				$('.popup_type').animate({right:'-67%'},500);
				$('#nav_hidepoint_btn').removeClass("active");
			}
			expanded1 = !expanded1;
		});

		//左侧工具栏搜索
		$("#nav_query").click(
			function(){
				$("#query_div").css({"top":$(this).offset().top});
				$("#query_div").css({"left":"32px"});
				$("#query_div").toggle();
				$("#nav_query").toggleClass("active");
			}
		);

		var back_to_ext = "";

		//左上角echarts地图 缩略图 鹰眼 的位置
		$('.point_zk').css({"left":"0px","top":"0px"});

		var expanded2 = true;
		$('.shrink_btn1,.shrink_btn2').click(function(){//左上角地图
			if(expanded2){
				$(".point_map_box").animate({height:'0',width:'0'},500);
				$('.point_zk').animate({height:'0',width:'0'},500,function(){
					$(".shrink_btn1").hide();
					$(".shrink_btn2").show();
					$(".point_map_box").hide()
				});

				$(".date_container").css({background:'#1c3cb0'});
			}else{
				$(".point_map_box").show()
				$(".point_map_box").animate({height:'42%',width:'31%'},300);
				$('.point_zk').animate({height:'100%',width:'100%'},300,function(){
					$(".shrink_btn1").show();
					$(".shrink_btn2").hide();
				});
				$(".date_container").css({background:''});
			}
			expanded2 = !expanded2;
		});

		//图例勾选初始化--begin--
		$("#point_type1").attr("checked",true);
		$(".popup_type").children("input:gt(0)").each(function(){
			this.checked = true;
		});
		//图例勾选初始化--end--

		if(use_auth)
			doShowAll(global_parent_area_name);

		/*setInterval(function(){
		 freshTab();
		 },interval_time);*/
	});

	//实时发展滚动效果
	function AutoScroll(obj,new_item,timeout_index){
		setTimeout(function(){
			var trs = $(obj).find("tbody>tr");
			if(trs.length==0)
				$(obj).prepend(new_item);
			else{
				$(obj).find("tbody>tr:first").animate({
					marginTop:"-25px"
				},1000,function(){
					if(trs.length>=5)
						$(obj).find("tbody>tr:last").remove();
					$(obj).prepend(new_item);
				});
			}
		},timeout_index*500);
	}

	function doShowAll(city_name){
		global_current_flag = 2;
		//echarts地图中 市级返回省级
		chart = echarts.init(document.getElementById('point_map'));
		$("#tables_title").html("当前路径：全省");

		var params = {};

		params.flag = global_current_flag;//市级
		params.index_type = global_current_index_type;
		params.city_name = city_name;
		params.index_type = default_show_index;
		doQuery(params);

		//var chart_index = 0;//默认是移动业务，曲线图切换tab，第1个div索引0

		//右侧 重点指标、发展量曲线图、发展排名

		freshRank();

		toGis(global_current_area_name,global_parent_area_name);//session权限将替换 city_name 变量
	}

	function getChartDivIndex(global_current_index_type){
		if(global_current_index_type=="宽带")
			return 1;
		else if(global_current_index_type=="ITV")
			return 2;
		return 0;
	}

	var geoCoordMap = {
		'兰州市':[103.558405, 36.396717],
		'天水市': [105.683293, 34.644548],
		'白银市': [104.653045, 36.552735],
		'酒泉市': [96.438652, 40.236275],
		'张掖市': [99.943337, 38.725094],
		'武威市': [103.208857, 38.175313],
		'金昌市': [102.049827, 38.486893],
		'嘉峪关市': [98.213991, 39.833223],
		'定西市': [104.41388, 35.091873],
		'平凉市': [106.731939, 35.310843],
		'庆阳市': [107.605811, 36.188202],
		'陇南市': [105.324546, 33.642599],
		'临夏州': [103.291645, 35.656951],
		'甘南州': [102.822514, 34.21006]
	};

	function convertData(data) {
		var res = [];
		if(data==null || data==undefined)
			data = new Array();
		for (var i = 0; i < data.length; i++) {
			var geoCoord = geoCoordMap[data[i].name];
			if (geoCoord) {
				res.push({
					name: data[i].name,
					value: geoCoord.concat(data[i].value)
				});
			}
		}
		return res;
	};

	var zoom = 1.2;
	var center = [[101.295538,37.283966]];
	var nameMap = {
		'兰州市': '兰',
		'天水市': '天',
		'白银市': '白',
		'酒泉市': '酒',
		'张掖市': '张',
		'武威市': '武',
		'金昌市': '金',
		'嘉峪关市': '嘉',
		'定西市': '定',
		'平凉市': '平',
		'庆阳市': '庆',
		'陇南市': '陇',
		'临夏州': '临',
		'甘南州': '甘'
	}
	var nameMapRevers = {
		'兰' :'兰州市',
		'天' :'天水市',
		'白' :'白银市',
		'酒' :'酒泉市',
		'张' :'张掖市',
		'武' :'武威市',
		'金' :'金昌市',
		'嘉':'嘉峪关市',
		'定' :'定西市',
		'平' :'平凉市',
		'庆' :'庆阳市',
		'陇' :'陇南市',
		'临' :'临夏州',
		'甘' :'甘南州'
	}
	function chart_reset(min_num,max_num,city_name,series_name,color,selected_city,data_dev,data_default,zoom,center){
		if(center==undefined)
			center = latn_center_point[city_name];
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

		if(zoom==undefined)
			zoom = 1.2;
		/*var regions = new Array();
		 if(city_name_except)
		 for(var j = 0,k = city_name_except.length;j<k;j++){
		 var obj = new Object();
		 obj.name = city_name_except[j].substr(0,1);
		 obj.label = {normal:{show:false},emphasis:{show:false}};
		 regions.push(obj);
		 }
		 regions.push({name:global_current_full_area_name.substr(0,1),selected:true});*/
		chart.setOption({
			tooltip: {
				show:false,
				trigger: 'item',
				formatter:'{a}{b}{c}'
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
			geo: {
				map: city_name,
				nameMap:nameMap,
				zoom:zoom,
				center:center,
				roam: true,
				selectedMode: false,
				regions:[
					selected_city
				],
				label: {
					normal: {
						show: false,
						position: 'center',
						textStyle: {
							color: '#fff',
							fontFamily:'微软雅黑',
							fontSize:10
						}
					},
					emphasis:{
						show:true
					}
				},
				itemStyle: {
					normal:{
						borderColor: '#fff',
						borderWidth:1.3,
						color:'transparent'
					},
					emphasis:{
						areaColor: null,
						shadowOffsetX: 0,
						shadowOffsetY: 0,
						shadowBlur: 20,
						borderWidth: 0,
						shadowColor: 'rgba(255, 255, 255, 0.6)'
					}
				},
			},
			series : [
				{
					type: 'scatter',
					coordinateSystem: 'geo',
					geoIndex:0,
					data: convertData(data_default),
					symbolSize: 8,
					label: {
						normal: {
							formatter: function(params){
								return params.name;
							},
							position: 'right',
							show: false
						},
						emphasis: {
							show: true
						}
					},
					itemStyle: {
						normal: {
							color: 'rgba(0,0,0,0)',
						}
					}
				},
				{
					type: 'effectScatter',
					coordinateSystem: 'geo',
					geoIndex:0,
					data: convertData(data_dev),
					symbolSize: 15,
					symbolRotate: 0,
					showEffectOn: 'render',
					rippleEffect: {
						brushType: 'fill'
					},
					label: {
						normal: {
							formatter: function(params){
								return params.name.substr(0,1);
							},
							position: 'right',
							show: false
						},
						emphasis: {
							show: true,
							formatter: function(params){
								return params.name;
							}
						}
					},
					itemStyle: {
						normal: {
							color: new echarts.graphic.RadialGradient(0.5, 0.5, 0.5, [{
								offset: 0,
								color: '#EA003D'
							}, {
								offset: 1,
								color: '#ffc900'
							},
							]),
						}
					}
				}
			]
		},true);
	}

	function randomRange(m,a){
		var Range = a - m;
		var Rand = Math.random();
		return(m + Math.round(Rand * Range));
	}

	var selected_city = {'name':global_current_full_area_name.substr(0,1),'selected':true};

	var city_a_words = Object.keys(nameMap);
	var datas = new Array();
	for(var i = 0,l = city_a_words.length;i<l;i++){
		var obj = new Object();
		obj.name = city_a_words[i];
		obj.value = 1;
		datas.push(obj);
	}

	var data_dev = new Array();

	//左上角地图生成
	function doQuery(params){
		//chart.showLoading();
		var fullCityName = params.city_name;

		var series_name = params.index_type;
		//表格数据

		//var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
		//地图数据展示用,最大值最小值

		var min = 0;
		var max = 0;
		var data_default = datas;
		chart_reset(min,max,fullCityName,series_name,color,selected_city,data_dev,data_default,zoom);
		chartClickAction(fullCityName);
		chart.hideLoading();
	}
	function wait(){
		layer.msg('正在处理，请稍后', {icon: 16,time: 0,shade:0.5,shadeClose:false});
	}
	function done(){
		layer.closeAll();
	}

	var count=0;
  var flag=null;
  function done_1(){
    if(count==0){
      clearInterval(flag);
    }
    else{
      count=count-1;
    }
  }

	var global_action = "";//地图中区域选择事件

	var freshTabInterval = "";//右上角刷新的间隔
	var startInterval = "";//打字效果的刷新间隔
	function chartClickAction(parent_name){
		chart.on('click', function (params){
			if(user_level>1){
				layer.msg("您无权查看其它地市的数据");
				return;
			}
			$("#nav_sub").removeClass("active");
			if(count==0){
				for(var i = 0,l = divs.length;i<l;i++){//清空右上角重点指标
					var current_parent_div = divs[i];
					$(current_parent_div).children(":eq(1)").children(":eq(0)").html("- -");
					$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计：- -");
					$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比：- -<b></b>");
				}

				if(freshTabInterval!=""){//停止之前的计时循环js
					clearInterval(freshTabInterval);
					freshTabInterval = "";
				}

				$("#scrollDiv").find("tbody").empty();//清空右下角实时发展表格

				$("#point_type1").attr("checked",true);//还原全选状态
				$(".popup_type").children("input:gt(0):lt(5)").each(function(){
					this.checked = true;
				});

				var cityFull = nameMapRevers[params.name.substr(0,1)];
				global_current_full_area_name = cityFull;
				var city_name = "";
				if(city_name_speical.indexOf(cityFull)>-1)
					city_name = cityFull.replace(/州/gi,'');
				else
					city_name = cityFull.replace(/市/gi,'');
				global_current_area_name = city_name;
				var fullCityName = params.city_name;
				var series_name = params.index_type;
				var min_num = 0;
				var max_num = 0;
				selected_city = {'name':params.name,'selected':true};
				var data_default = datas;
				var zoom = chart.getOption().geo[0].zoom;
				var center = chart.getOption().geo[0].center;
				chart_reset(min_num,max_num,province_name,series_name,color,selected_city,data_dev,data_default,zoom,center);

				//selected_city = {params.name};

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
				toGis(city_name,parent_name);
				global_current_flag = 3;

				$("#nav_fanhui").show();
				//}
				/*if(jsonNo!=undefined){
				 global_current_area_name = city;
				 freshTab(global_current_area_name);
				 freshRank(global_current_area_name);
				 }else{*/
				var city = "";
				if(cityFull=='临夏州' || cityFull=='甘南州')
					city = cityFull.replace(/州/gi,'');
				else
					city = cityFull.replace(/市/gi,'');
				freshRank();
			//设置两次点击的时间间隔
			count=1;
      		flag=setInterval(done_1,1000);
			}else{
		      //layer.msg('还需要'+(count)+'秒才能点击');
		    }
		});
	}

	var id_array_for_update = "";//重点指标 凡在此中不为零的数为最新序号
	var id_array_last = new Array();//重点指标 用来和下次比较序号

	//var chart_city_id_temp = new Array();//echart地图各个地市的汇总数据 最近一次的地市数据

	var channel_name_array = new Array();//要在gis上闪动的渠道点的名称

	function freshRank(){
		$("#channel_rank").datagrid({
			url:url4query,
			queryParams:{
				eaction:'proc_get',
				date:'${yesterday.VAL}',
				city_name:global_current_area_name
			},
			autoRowHeight:false,
			fitColumns:true,
			singleSelect:false,
			rownumbers:false,
			sortName: 'yd_current_mon_dev',
			sortOrder: 'desc',
			pagination:true,
			pageSize:5,
			pageList:[5],
			onLoadSuccess:function(){
				$(".pagination").hide();
			}/*,
			 onDblClickRow:function(index,row){//双击某支局，定位到该支局

			 },
			 resize:function(){
			 console.log("resize");
			 },
			 load:function(){
			 console.log("load");
			 },
			 reload:function(){
			 console.log("reload");
			 },
			 appendRow:function(){
			 console.log("appendRow");
			 }*/
		});
	}

	//初始右下角加入指定条数的交易信息
	var initScrollTab = "";

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
		if(map!=""){
			map.removeAllLayers();
			map.destroy();
		}
		var city_name_temp = "";
		if(city_name_speical.indexOf(city_name)>-1)
			city_name_temp = city_name + '州';
		else
			city_name_temp = city_name + '市';

		global_current_area_name = city_name;
		global_current_full_area_name = city_name_temp;
		global_current_flag = 3;

		city_id = city_ids[global_current_area_name];

		var chart_index = 0;//默认是移动业务，曲线图切换tab，第1个div索引0
		if (global_current_index_type == "宽带")
			chart_index = 1;
		else if (global_current_index_type == "ITV")
			chart_index = 2;

		var cityForLayer = cityNames[city_name_temp];

		$("#pagemap").hide();
		$("#gismap").show();
		$("#gismap").height($(window).height());

		require(["esri/map",
					"esri/config",
					"esri/layers/ArcGISTiledMapServiceLayer",
					"esri/layers/GraphicsLayer",
					"esri/tasks/query",
					"esri/tasks/QueryTask",
					"esri/symbols/SimpleFillSymbol",
					"esri/symbols/PictureMarkerSymbol",
					"esri/graphic",
					"esri/graphicsUtils",
					"esri/symbols/SimpleMarkerSymbol",
					"esri/symbols/SimpleLineSymbol",
					"esri/symbols/Font",
					"esri/symbols/TextSymbol",
					"esri/Color",
					"esri/tasks/IdentifyTask",
					"esri/tasks/IdentifyParameters",
					"esri/geometry/Extent",
					"esri/InfoTemplate",
					"esri/toolbars/navigation",
					"esri/toolbars/draw",
					"esri/geometry/Point",
					"esri/geometry/Polygon",
					"esri/SpatialReference",
					"dojo/mouse",
					"dojo/query",
					"dojo/domReady!"],
				function(Map,
						 Config,
						 ArcGISTiledMapServiceLayer,
						 GraphicsLayer,
						 Query,
						 QueryTask,
						 SimpleFillSymbol,
						 PictureMarkerSymbol,
						 Graphic,
						 graphicsUtils,
						 SimpleMarkerSymbol,
						 SimpleLineSymbol,
						 Font,
						 TextSymbol,
						 Color,
						 IdentifyTask,
						 IdentifyParameters,
						 Extent,
						 InfoTemplate,
						 Navigation,
						 Draw,
						 Point,
						 Polygon,
						 SpatialReference,
						 mouse,
						 query){
					Config.defaults.io.proxyUrl = "http://135.149.64.140:8888/proxy/proxy.jsp";
					Config.defaults.io.alwaysUseProxy = false;

					map = new Map("gismap");

					map.on("load", function () {
						map.hideZoomSlider();
						$(".tools_n").show();
					});

					map.on("mouse-drag",function(evt){

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
								if (tiled.visible){
									tiled.hide();
									$("#nav_hidetiled").removeClass("active");
								}else{
									tiled.show();
									$("#nav_hidetiled").addClass("active");
								}
								break;
							case 'nav_sub':
								if(graLayer_qx.visible){
									$("#nav_sub").removeClass("active");
									graLayer_qx.hide();
									graLayer_zjname.hide();
								}else{
									$("#nav_sub").addClass("active");
									graLayer_qx.show();
									graLayer_zjname.clear();
									zj_name_show_hide(map.getZoom());
									graLayer_zjname.show();
								}
								break;
							/*case 'nav_hidepoint':
							 if(graLayer_qx_wd.visible)
							 graLayer_qx_wd.hide();
							 else
							 graLayer_qx_wd.show();
							 break;*/
						}
					}
					query("#tools li").onclick(function (evt) {
						navEvent(evt.target.parentNode.id);
					});

					//支局、网格服务地址
					var sub_layer_index = "/2";
					var grid_layer_index = "/1";

					var new_url_sub_vaild = new_url_sub_pre + cityForLayer + new_url_sub_suf;
					var new_url_grid_vaild = new_url_grid_pre + cityForLayer + new_url_grid_suf;

					/*if(city_id == "932"){
						new_url_sub_vaild = new_url_sub_dx;
						new_url_grid_vaild = new_url_grid_dx;
						sub_layer_index = "/0";
					}else if(city_id == "947"){
						new_url_sub_vaild = new_url_sub_jyg;
						new_url_grid_vaild = new_url_grid_jyg;
						sub_layer_index = "/0";
					}*/

					//本地网地图url
					var layer_ds = tiled_address_pre + cityForLayer + tiled_address_suf;
					var new_url_point = "http://135.149.48.83:8030/arcgis/rest/services/BONC_gansu/channel_point_new_20170609/MapServer";

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

					var channel_type = ['自有厅','专营店','连锁店','独立店','便利点'];
					var channel_ico = new Array();
					/*channel_ico['2001000'] = "images/channel_ico/bz.png";
					 channel_ico['2001100'] = "images/channel_ico/hq.png";
					 channel_ico['2001200'] = "images/channel_ico/sd.png";
					 channel_ico['2001300'] = "images/channel_ico/wj.png";
					 channel_ico['2001400'] = "images/channel_ico/wx.png";*/
					channel_ico['2001000'] = "../common/images/channel_ico_new/channel_point1.png";
					channel_ico['2001100'] = "../common/images/channel_ico_new/channel_point2.png";
					channel_ico['2001200'] = "../common/images/channel_ico_new/channel_point4.png";
					channel_ico['2001300'] = "../common/images/channel_ico_new/channel_point5.png";
					channel_ico['2001400'] = "../common/images/channel_ico_new/channel_point3.png";

					var channel_ico_small = new Array();
					channel_ico_small['2001000'] = "../common/images/channel_ico_new/channel_point11.png";
					channel_ico_small['2001100'] = "../common/images/channel_ico_new/channel_point22.png";
					channel_ico_small['2001200'] = "../common/images/channel_ico_new/channel_point44.png";
					channel_ico_small['2001300'] = "../common/images/channel_ico_new/channel_point55.png";
					channel_ico_small['2001400'] = "../common/images/channel_ico_new/channel_point33.png";

					channel_ico_active_effect = "../common/images/channel_ico_new/channel_point13.gif";

					var color_point_line = [255,0,0];

					var tiled = new ArcGISTiledMapServiceLayer(layer_ds);
					tiled.setOpacity(1);
					map.addLayer(tiled);

					//多边形绘制层
					var draw_layer = new GraphicsLayer();
					map.addLayer(draw_layer);
					draw_layer.hide();

					var drawAddToMap = function(evt){
						var class3_str = "";
						if($("#point_type1").is(":checked"))
							class3_str = $("#point_type1").val();
						else{
							var types_cks = $(".popup_type").children("input:gt(0):lt(5)");
							for(var i = 0,l = types_cks.length;i<l;i++){
								if($(types_cks[i]).is(":checked")){
									class3_str += $(types_cks[i]).val()+",";
									checkNum += 1;
								}
							}
							class3_str = class3_str.substr(0,class3_str.length-1);
						}
						if($.trim(class3_str)==""){
							layer.msg("请在上方勾选渠道网点的类型后再框选查询");
							return;
						}

						var symbol;
						toolbar.deactivate();
						//map.showZoomSlider();
						switch (evt.geometry.type) {
							case "point":
								//console.log("暂无结果");
								break;
							case "multipoint":
								//console.log("暂无结果");
								symbol = new SimpleMarkerSymbol();
								break;
							case "polyline":
								//console.log("暂无结果");
								symbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,new Color(draw_line_color), 1);
								break;
							default://封闭多边形
								map.setMapCursor("default");//绘制结束，还原鼠标
								$("#nav_draw").removeClass("active");
								symbol = new SimpleFillSymbol().setColor(new dojo.Color(draw_fill_color));
								symbol.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(draw_line_color), draw_line_width));
								var queryTask = new QueryTask(new_url_point + "/0");
								var query = new Query();
								query.where = "LATN_ID = "+ city_id + " AND CLASS3_ID IN ("+ class3_str +")";
								query.geometry = evt.geometry;
								query.outFields = ["*"];
								query.returnGeometry = true;
								queryTask.execute(query, function (results) {
									var features = results.features;
									if(features.length==0){
										layer.msg("暂无查询结果");
										return;
									}
									$("#draw_result_total").html("共搜索到"+features.length+"个结果");
									$("#draw_result").children("table").empty();
									$("#draw_result").children("table").append("<div style='position: absolute;top: 0px;font-size:1.2em;background-color: #02004f;color: #00deff;height: 34px;line-height: 34px;width: 97%'><div style='width: 10%;display: inline-block'>序号</div><div style='text-align: left;width: 25%;display: inline-block'>网点名称</div><div style='text-align: left;width: 25%;display: inline-block'>网点类型</div><div style='text-align: center;width: 15%;display: inline-block'>移动发展</div><div style='text-align: center;width: 15%;display: inline-block'>宽带发展</div><div style='text-align: center;width: 10%;display: inline-block'>ITV发展</div></div>");
									$("#draw_result_container").show();
									layer.open({
										title: ['查询结果','line-height:36px;height:36px;font-size:1.2em;'],
										type: 1,
										shade:0,
										area: ['45%','50%'],
										left:'45%',
										content: $("#draw_result_container"),
										cancel: function(){//右上角关闭回调
											$("#draw_result_container").hide();
										},
									});
									$("#layui-layer1").css({left:'340px'})
									var result_li = "";
									var result_size = features.length;
									var channel_name_str = "";
									var channel_dev_array = new Array();
									for(var i = 0;i<result_size;i++){
										var attrs = features[i].attributes;
										channel_name_str += "'"+attrs.CHANNEL_NA+"'";
										if(i<result_size-1)
											channel_name_str += ",";
										channel_dev_array[attrs.CHANNEL_NA] = {"CHANNEL_NAME":attrs.CHANNEL_NA,"CLASS1_FIN":attrs.CHANNEL__1,"YD_CURRENT_DAY_DEV":"- -","KD_CURRENT_DAY_DEV":"- -","ITV_CURRENT_DAY_DEV":"- -","YD_CURRENT_MON_DEV":"- -","KD_CURRENT_MON_DEV":"- -","ITV_CURRENT_MON_DEV":"- -"};
									}

									$.post(url4query,{eaction:"index_get_by_channel_names",channel_names:channel_name_str,date:'${yesterday.VAL}',city_name:global_current_area_name},function(data) {
										data = $.parseJSON(data);
										for(var i = 0,l = data.length;i<l;i++){
											var d = data[i];
											var type = channel_dev_array[d.CHANNEL_NAME]["CLASS1_FIN"];
											d["CLASS1_FIN"] = type;
											channel_dev_array[d.CHANNEL_NAME] = d;
										}
										var keys = Object.keys(channel_dev_array);
										for(var i = 0,l = keys.length;i<l;i++){
											var d = channel_dev_array[keys[i]];
											$("#draw_result").children("table").append("<tr style='border-bottom: 1px solid #120f4b;font-size:1.3em;padding-left: 20px;height: 28px;line-height: 28px;'><td style='width: 10%'>"+(i+1)+"</td><td style=\"text-align:left;width: 25% \">"+ d.CHANNEL_NAME+"</td><td style=\"text-align:left;width: 25%\">"+ d.CLASS1_FIN+"</td><td style='width: 15%;'>"+(d.YD_CURRENT_DAY_DEV)+"</td><td style='width: 15%;'>"+d.KD_CURRENT_DAY_DEV+"</td><td style='width: 10%;'>"+d.ITV_CURRENT_DAY_DEV+"</td></tr>");
										}
									});
								});
								var graphic = new Graphic(evt.geometry, symbol);
								draw_layer.add(graphic);
						}
					};

					var toolbar;//工具栏，放置绘图工具

					//突出显示行政区县的层，包含区县轮廓，所有支局填充
					var graLayer_qx = new GraphicsLayer();
					map.addLayer(graLayer_qx);
					graLayer_qx.hide();

					//网点查询结果后，给结果的点附绿色圈注
					var queryResultLayer = new GraphicsLayer();
					map.addLayer(queryResultLayer);

					//网点展示
					var graLayer_qx_wd = new GraphicsLayer();
					map.addLayer(graLayer_qx_wd);

					//有发展变化的网点展示
					var graLayer_qx_wd_dev = new GraphicsLayer();
					map.addLayer(graLayer_qx_wd_dev);

					var graLayer_zj_wd = new GraphicsLayer();
					map.addLayer(graLayer_zj_wd);
					var graLayer_wg_wd = new GraphicsLayer();
					map.addLayer(graLayer_wg_wd);
					var graLayer_wg_child_wd = new GraphicsLayer();
					map.addLayer(graLayer_wg_child_wd);

					//鼠标悬浮到支局，突出显示鼠标下的支局
					var graLayer_sub_mouseover = new GraphicsLayer();
					map.addLayer(graLayer_sub_mouseover);

					//支局名字的层，包含所有支局名称
					var graLayer_zjname = new GraphicsLayer();
					//graLayer_zjname.setScaleRange(25000, 50000);
					//graLayer_zjname.setMinScale(5);

					//下钻时突出显示支局范围的层,包含网格填充、网格名称、支局轮廓
					var graLayer_wg = new GraphicsLayer();
					map.addLayer(graLayer_wg);
					var graLayer_wg_child = new GraphicsLayer();
					map.addLayer(graLayer_wg_child);

					//var graphic_array = new Array();

					//var url4query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
					var latn_id = "";
					//查询开始
					$.post(url4query,{eaction:"getLatnIdByCityName",city_name: city_name}, function (data) {
						data = $.parseJSON(data);

						var queryTask = new QueryTask(new_url_point + "/0");
						var query = new Query();
						latn_id = data.LATN_ID;
						query.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +"";
						query.outFields = ['CLASS3_ID','CHANNEL_NA','CHANNEL_AD'];
						query.returnGeometry = true;
						var city_geometry = "";//所展示市级范围的图形对象

						queryTask.execute(query, function (results) {
							if(results.features.length==0)
								return;
							for(var i = 0,l = results.features.length;i<l;i++){
								var feature = results.features[i];
								var geo = feature.geometry;
								var class3_id = feature.attributes.CLASS3_ID;
								var channel_na = feature.attributes.CHANNEL_NA;
								var channel_ad = feature.attributes.CHANNEL_AD;
								var pointAttributes = {'CLASS3_ID' :class3_id,'CHANNEL_NA':channel_na,'CHANNEL_AD':channel_ad};
								var img = new PictureMarkerSymbol(channel_ico[class3_id], 15,15);
								var graphic = new esri.Graphic(geo,img,pointAttributes);

								//graphic_array[feature.attributes.CHANNEL_NA] = graphic;
								graLayer_qx_wd.add(graphic);
								/*var pointTemplate = new InfoTemplate("Geocoding Results");
								 var graphic = new esri.Graphic(geo,img,pointAttributes).setInfoTemplate(pointTemplate);*/
							}
						});
					});

					//gis上跳动点
					var freshJumpPoint = function(channel_name_array){//东升电力科技街专营店
						graLayer_qx_wd_dev.clear();
						//channel_name_array.push("农民巷专营店");
						/*for(var j = 0,k = channel_name_array.length;j<k;j++){
						 //console.log("渠道数据(db)："+channel_name_array[j]);
						 var gra_in_cache = graphic_array[channel_name_array[j]];
						 if(gra_in_cache)
						 console.log("渠道数据(map)匹配:true");
						 else
						 console.log("渠道数据(map)匹配:false");
						 }*/
						var sql_names = ""
						for(var i = 0,l = channel_name_array.length;i<l;i++){
							var cn = channel_name_array[i];
							sql_names += ("'"+cn+"'");
							if(i<l-1)
								sql_names += ",";
						}
						var current_zoom = map.getZoom();
						var size = 0
						if(current_zoom>6){
							size = 20;
						}else if(current_zoom==6){
							size = 17;
						}else if(current_zoom==4 || current_zoom==5){
							size = 15;
						}else if(current_zoom==3){
							size = 12;
						}else if(current_zoom==2){
							size = 12;
						}else if(current_zoom==1){
							size = 10;
						}

						//只显示当前勾选的类型的网点
						var types_cks = $(".popup_type").children("input:gt(0):lt(5)");
						var cks_item_vals = "";
						var checkNum = 0;
						for(var i = 0,l = types_cks.length;i<l;i++){
							if($(types_cks[i]).is(":checked")){
								cks_item_vals += $(types_cks[i]).val()+",";
								checkNum += 1;
							}
						}
						if(checkNum>0){
							cks_item_vals = cks_item_vals.substr(0,cks_item_vals.length-1);

							var location_type = $("#location_type").val();
							if(!location_type)
								location_type = 0;
							var queryTask = new QueryTask(new_url_point + "/"+location_type);

							var query = new Query();

							query.where = "CHANNEL_NA IN ("+sql_names+") AND CLASS4 = '实体渠道' AND LATN_ID = "+ city_id +" AND CLASS3_ID IN ("+cks_item_vals+")";
							query.outFields = ["CHANNEL_NA","CHANNEL_AD","CLASS3_ID"];
							query.returnGeometry = true;

							queryTask.execute(query, function(results) {
								var fs = results.features;
								if(fs.length==0){//没有从gis地图中匹配出可以闪动的点
									return;
								}
								for(var i = 0,l = fs.length;i<l;i++){
									var feature = fs[i];
									var geo = feature.geometry;
									var class3_id = feature.attributes.CLASS3_ID;
									var channel_na = feature.attributes.CHANNEL_NA;
									var channel_ad = feature.attributes.CHANNEL_AD;
									var pointAttributes = {'CLASS3_ID' :class3_id,'CHANNEL_NA':channel_na,'CHANNEL_AD':channel_ad};
									var img = new PictureMarkerSymbol(channel_ico_active_effect,size*3,size*3);
									var graphic = new esri.Graphic(geo,img,pointAttributes);
									graLayer_qx_wd_dev.add(graphic);
								}
							});
						}
					}
					//初始化给右下角滚动表格5条数据
					initScrollTab = function(num){
						$.post(url4query,{eaction:"index_get_channel",city_id:city_id},function(data){
							data = $.parseJSON(data);
							var max_num = 0;
							for(var i = 0,l = data.length;i<l;i++){
								var d = data[i];
								try{
									max_num += parseInt(d.CNT);
								}catch(e){
									max_num += 0;
								}
							}

							$.post(url4query,{eaction:"getDevItemInit",city_id:city_id,date:${today.VAL},num:num,max_num:max_num},function(data){
								data = $.parseJSON(data);
								channel_name_array = new Array();
								for(var i= 0,l = data.length;i<l;i++){
									var d = data[i];
									var new_item = "<tr>";
									if(d.PRO_LATN_CNT==0){
										continue;
									}

									var channel_name_temp = (d.CHANNEL_NAME1==undefined?'':(d.CHANNEL_NAME1.length>10?d.CHANNEL_NAME1.substr(0,10)+"..":d.CHANNEL_NAME1));
									var channel_name_add_to_array = (d.CHANNEL_NAME1==undefined?"":d.CHANNEL_NAME1);
									new_item += "<td>"+ d.PRO_LATN_CNT+"</td><td>"+d.LATN_NAME+"</td><td style=\"text-align:left\" title=\""+d.CHANNEL_NAME1+"\">"+channel_name_temp+"</td><td style=\"text-align:left\">"+d.ACC_NBR+"</td><td>"+d.PRODUCE+"</td><td>"+d.UP_TIME+"</td>";
									new_item += "</tr>";
									//AutoScroll("#scrollDiv",new_item,i);
									var obj = $("#scrollDiv");
									var trs = obj.find("tbody>tr");
									if(trs.length==0)
										obj.prepend(new_item);
									else{
										if(trs.length>=5)
											obj.find("tbody>tr:last").remove();
										obj.prepend(new_item);
									}
									channel_name_array.push(channel_name_add_to_array);
									freshJumpPoint(channel_name_array);
								}
							});
						});
					}

					var freshTab = function(){
						var data_array = new Array();
						//根据上面三个数字，作为序号查询echart地图上要闪动的点（全省范围）

						$.post(url4query,{eaction:"index_get_channel_province"},function(data){
							data = $.parseJSON(data);
							if(data.length==0){
								//console.log("全省无数据");
								chart_reset(1,1, province_name,global_current_index_type,color,selected_city,[],data_default,1,center);
								return;
							}
							var chart_city_id = new Array();//echart地图各个地市的汇总数据 需要闪动的点
							for(var i = 0,l = data.length;i<l;i++){
									var d = data[i];
									var latn_id= d.LATN_ID;
									var cnt = d.CNT;
									chart_city_id.push({name:city_ids_revers[latn_id],value:cnt});
							}
							var zoom = chart.getOption().geo[0].zoom;
							var center = chart.getOption().geo[0].center;
							//此处在地图上跳动
							/*此段在数据合适时候将被替换 begin*/
							/*var city_name_except = new Array();
							 var cityName = Object.keys(cityMap);
							 for(var i = 0,l = 3;i<l;i++){
							 var obj = new Object();
							 obj.name = cityName[randomRange(0,13)];
							 obj.value = 1;
							 city_name_except.push(obj);
							 }
							 var data_dev = city_name_except;*/
							/*此段在数据合适时候将被替换 end*/
							var data_default = datas;
							chart_reset(1,1, province_name,global_current_index_type,color,selected_city,[],data_default,zoom,center);
							chart_reset(1,1, province_name,global_current_index_type,color,selected_city,chart_city_id,data_default,zoom,center);
						});

						//更新当前地市的展现
						id_array_for_update = new Array();

						//月累计
						$.post(url4query,{eaction:"index_get_channel_month_add_hb",city_id:city_id,date:'${yesterday.VAL}'},function(data){
							data = $.parseJSON(data);
							if(data==null)
								return;
							for(var i = 0,l = divs.length;i<l;i++){
								var current_parent_div = divs[i];
								//$(current_parent_div).children(":eq(1)").children(":eq(0)").html("- -");
								if(i==0){//移动
									$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+data.YD_MON_ADD_CNT);
									$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+data.HB_YD+"%<b class='"+(data.HB_YD>0?'b1':'b2')+"'></b>");
								}else if(i==1){//宽带
									$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+data.KD_MON_ADD_CNT);
									$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+data.HB_KD+"%<b class='"+(data.HB_KD>0?'b1':'b2')+"'></b>");
								}else if(i==2){//itv
									$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+data.ITV_MON_ADD_CNT);
									$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+data.HB_ITV+"%<b class='"+(data.HB_ITV>0?'b1':'b2')+"'></b>");
								}
							}
						});
						//三个黄色数字
						$.post(url4query,{eaction:"index_get_channel",city_id:city_id},function(data){
							data = $.parseJSON(data);
							if(data.length==0){
								for(var i = 0,l = divs.length;i<l;i++){
									var current_parent_div = divs[i];
									$(current_parent_div).children(":eq(1)").children(":eq(0)").html("- -");
									//$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+("- -"));
									//$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+("- -")+"<b class='b'></b>");
								}
								return;
							}
							for(var i = 0,l = data.length;i<l;i++){
								var index = data[i];
								var current_parent_div = "";
								if(index.PROD_TYPE == '1'){//移动
									current_parent_div = divs[0];
									start_obj($(current_parent_div).children(":eq(1)").children(":eq(0)"),index.CNT+"");
								}else if(index.PROD_TYPE == '2'){//宽带
									current_parent_div = divs[1];
									start_obj1($(current_parent_div).children(":eq(1)").children(":eq(0)"),index.CNT+"");
								}else if(index.PROD_TYPE == '3'){//itv
									current_parent_div = divs[2];
									start_obj2($(current_parent_div).children(":eq(1)").children(":eq(0)"),index.CNT+"");
								}
								//start_obj($(current_parent_div).children(":eq(1)").children(":eq(0)"),index.CNT+"");

								//$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计：- -");
								var up_down_arrow = "1";
								if(index.CURRENT_DAY_HUAN<0)
									up_down_arrow = "2";
								//$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比：- -"+"%<b class='b"+up_down_arrow+"'></b>");

								var type = parseInt(index.PROD_TYPE);
								if(id_array_last[type-1] == index.CNT){//和上次没有变化
									id_array_for_update[type-1] = 0;
								}else{
									id_array_for_update[type-1] = index.CNT;
								}
								id_array_last[type-1] = index.CNT;
							}
							var temp = 0;
							for(var i = 0,l = id_array_for_update.length;i<l;i++){
								if(id_array_for_update[i]==0)
									temp ++;
							}
							//清除gis中闪动的点
							graLayer_qx_wd_dev.clear();
							//id_array_for_update里的id都是0，没有要更新的数据
							if(firstInit){//第一次初始化的时候，返回不刷新下面的滚动列表
								firstInit = false;
								return;
							}

							if(temp==id_array_for_update.length)
								return;
							//右下角滚动
							//id_array_for_update是gis里需要跳动的点的cnt（需根据cnt从交易明细表里查询T_REL_PRD_PROD_INST_LATN@DW_GSCLAS）
							$.post(url4query,{eaction:"getDevItemById",city_id:city_id,pro_type0:1,pro_type1:2,pro_type2:3,id0:id_array_for_update[0],id1:id_array_for_update[1],id2:id_array_for_update[2],date:${today.VAL}},function(data){
								data = $.parseJSON(data);
								channel_name_array = new Array();
								for(var i= 0,l = data.length;i<l;i++){
									var d = data[i];
									var new_item = "<tr>";
									if(d.PRO_LATN_CNT==0){
										continue;
									}

									var channel_name_temp = (d.CHANNEL_NAME1==undefined?'':(d.CHANNEL_NAME1.length>10?d.CHANNEL_NAME1.substr(0,10)+"..":d.CHANNEL_NAME1));
									var channel_name_add_to_array = (d.CHANNEL_NAME1==undefined?"":d.CHANNEL_NAME1);
									new_item += "<td>"+ d.PRO_LATN_CNT+"</td><td>"+d.LATN_NAME+"</td><td style=\"text-align:left\" title=\""+d.CHANNEL_NAME1+"\">"+channel_name_temp+"</td><td style=\"text-align:left\">"+d.ACC_NBR+"</td><td>"+d.PRODUCE+"</td><td>"+d.UP_TIME+"</td>";
									new_item += "</tr>";
									AutoScroll("#scrollDiv",new_item,i);
									channel_name_array.push(channel_name_add_to_array);
									freshJumpPoint(channel_name_array);
								}
							});

						});
					}

					var firstInit = true;
					freshTab();
					//初始化给右下角滚动表格5条数据
					initScrollTab(5);
					//初始化之后再刷新数据
					setTimeout(function(){
						freshTabInterval = setInterval(function(){
							freshTab();
						},interval_time);
					},3000);

					//graLayer_qx_wd4.setRefreshInterval(0.1);

					//graLayer_qx_wd4.on("refresh-interval-change",function(){
					/*if(wd_flag)
					 graLayer_qx_wd4.show();
					 else
					 graLayer_qx_wd4.hide();*/
					//});

					//图例的点击事件
					//图例全选
					$("#point_type1").click(function(){
						map.infoWindow.hide();
						if($(this).is(":checked")){
							$(".popup_type").children("input").each(function(index,dom){
								this.checked = true;
							});
							checkNum=checkbox_length;
						}else{
							$(".popup_type").children("input").each(function(index,dom){
								this.checked = false;
							});
							checkNum=0;
						}
						graLayer_qx_wd.clear();
						if(checkNum>0){
							var current_zoom = map.getZoom();
							var size = 0
							if(current_zoom>6){
								size = 20;
							}else if(current_zoom==6){
								size = 17;
							}else if(current_zoom==4 || current_zoom==5){
								size = 15;
							}else if(current_zoom==3){
								size = 12;
							}else if(current_zoom==2){
								size = 12;
							}else if(current_zoom==1){
								size = 10;
							}

							var query = new Query();
							query.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +" AND CLASS3_ID IN ("+$("#point_type1").val()+")";
							query.outFields = ['CLASS3_ID','CHANNEL_NA','CHANNEL_AD'];
							query.returnGeometry = true;
							var city_geometry = "";//所展示市级范围的图形对象
							var	location_type = 0;
							var queryTask = new QueryTask(new_url_point + "/"+location_type);
							queryTask.execute(query, function (results) {
								if(results.features.length==0)
									return;
								for(var i = 0,l = results.features.length;i<l;i++){
									var feature = results.features[i];
									var geo = feature.geometry;
									var class3_id = feature.attributes.CLASS3_ID;
									var channel_na = feature.attributes.CHANNEL_NA;
									var pointAttributes = {'CLASS3_ID':class3_id,'CHANNEL_NA':channel_na};
									var img = new PictureMarkerSymbol(channel_ico[class3_id], size,size);
									var graphic = new esri.Graphic(geo,img,pointAttributes);

									//graphic_array[feature.attributes.CHANNEL_NA] = graphic;
									graLayer_qx_wd.add(graphic);
									/*var pointTemplate = new InfoTemplate("Geocoding Results");
									 var graphic = new esri.Graphic(geo,img,pointAttributes).setInfoTemplate(pointTemplate);*/
								}
							});
							graLayer_qx_wd.show();

							/*var array = new Array();//统计分类网点时使用
							var ext = map.extent;
							var query = new Query();
							var channel_type_map = new Array();

							query.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +" AND CLASS3_ID IN ("+$("#point_type1").val()+")";
							query.geometry = ext;
							query.outFields = ['CLASS3_ID','CLASS3','CHANNEL_NA','CHANNEL_AD'];
							query.returnGeometry = true;
							var city_geometry = "";//所展示市级范围的图形对象
							var	location_type = 0;
							var queryTask = new QueryTask(new_url_point + "/"+location_type);
							queryTask.execute(query, function (results) {
								var fs = results.features;
								if(fs.length==0){
									return;
								}
								for(var i = 0,l=fs.length;i<l;i++){
									var attr = fs[i].attributes;
									var class3 = attr.CLASS3;
									/!*if(class3=="公众直销经理" || class3=="公众直销代理")
									 class3 = "公众直销";*!/
									if(array[class3]==undefined){
										array[class3] = 1;
									}else{
										array[class3] += 1;
									}
									channel_type_map[class3] = attr.CLASS3_ID;
								}
								var res_by_type = "当前视野范围内共"+fs.length+"个网点，其中";
								for(var i = 0,l = channel_type.length;i<l;i++){
									var data = array[channel_type[i]];
									if(data!=undefined){
										res_by_type += "<div style=\"background-image:url("+channel_ico_small[channel_type_map[channel_type[i]]]+");\"></div>"+channel_type[i]+":"+array[channel_type[i]]+"个  ";
									}
								}
								$("#res_in_view").html(res_by_type);
							});*/
						}else{
							//$("#res_in_view").html("当前视野范围内共0个网点");
						}
					});
					//图例 中单独的选项 勾选
					$(".popup_type").children("input:gt(0):lt(5)").each(function(index,element){
						map.infoWindow.hide();
						$(this).click(function(){
							var checkNum = 0;
							graLayer_qx_wd.clear();

							var types_cks = $(".popup_type").children("input:gt(0):lt(5)");
							var cks_item_vals = "";
							for(var i = 0,l = types_cks.length;i<l;i++){
								if($(types_cks[i]).is(":checked")){
									cks_item_vals += $(types_cks[i]).val()+",";
									checkNum += 1;
								}
							}
							cks_item_vals = cks_item_vals.substr(0,cks_item_vals.length-1);

							if(checkNum==checkbox_length){
								$("#point_type1")[0].checked = true;
							}else{
								$("#point_type1")[0].checked = false;
							}
							if(checkNum!=0){
								var current_zoom = map.getZoom();
								var size = 0
								if(current_zoom>6){
									size = 20;
								}else if(current_zoom==6){
									size = 17;
								}else if(current_zoom==4 || current_zoom==5){
									size = 15;
								}else if(current_zoom==3){
									size = 12;
								}else if(current_zoom==2){
									size = 12;
								}else if(current_zoom==1){
									size = 10;
								}

								var query = new Query();
								query.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +" AND CLASS3_ID IN ("+cks_item_vals+")";
								query.outFields = ['CLASS3_ID','CLASS3','CHANNEL_NA','CHANNEL_AD'];
								query.returnGeometry = true;

								var channel_type_map = new Array();

								var city_geometry = "";//所展示市级范围的图形对象
								var	location_type = 0;
								var queryTask = new QueryTask(new_url_point + "/"+location_type);
								queryTask.execute(query, function (results) {
									if(results.features.length==0)
										return;
									for(var i = 0,l = results.features.length;i<l;i++){
										var feature = results.features[i];
										var geo = feature.geometry;
										var class3_id = feature.attributes.CLASS3_ID;
										var channel_na = feature.attributes.CHANNEL_NA;
										var pointAttributes = {'CLASS3_ID':class3_id,'CHANNEL_NA':channel_na};
										var img = new PictureMarkerSymbol(channel_ico[class3_id], size,size);
										var graphic = new esri.Graphic(geo,img,pointAttributes);

										//graphic_array[feature.attributes.CHANNEL_NA] = graphic;
										graLayer_qx_wd.add(graphic);
										/*var pointTemplate = new InfoTemplate("Geocoding Results");
										 var graphic = new esri.Graphic(geo,img,pointAttributes).setInfoTemplate(pointTemplate);*/
									}
								});
								graLayer_qx_wd.show();
								freshJumpPoint(channel_name_array);

								//可视范围内网点数据计算
								/*var array = new Array();//统计分类网点时使用
								var channel_type_map = new Array();
								var ext = map.extent;
								var query = new Query();
								query.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ latn_id +" AND CLASS3_ID IN ("+cks_item_vals+")";
								query.geometry = ext;
								query.outFields = ['CLASS3_ID','CLASS3','CHANNEL_NA','CHANNEL_AD'];
								query.returnGeometry = true;
								var city_geometry = "";//所展示市级范围的图形对象
								var	location_type = 0;
								var queryTask = new QueryTask(new_url_point + "/"+location_type);
								queryTask.execute(query, function (results) {
									var fs = results.features;
									if(fs.length==0){
										return;
									}
									for(var i = 0,l=fs.length;i<l;i++){
										var attr = fs[i].attributes;
										var class3 = attr.CLASS3;
										/!*if(class3=="公众直销经理" || class3=="公众直销代理")
										 class3 = "公众直销";*!/
										if(array[class3]==undefined){
											array[class3] = 1;
										}else{
											array[class3] += 1;
										}
										channel_type_map[class3] = attr.CLASS3_ID;
									}
									var res_by_type = "当前视野范围内共"+fs.length+"个网点，其中";
									for(var i = 0,l = channel_type.length;i<l;i++){
										var data = array[channel_type[i]];
										if(data!=undefined){
											res_by_type += "<div style=\"background-image:url("+channel_ico_small[channel_type_map[channel_type[i]]]+");\"></div>"+channel_type[i]+":"+array[channel_type[i]]+"个  ";
										}
									}
									$("#res_in_view").html(res_by_type);
								});*/
							}else{
								//$("#res_in_view").html("当前视野范围内共0个网点");
							}

						});
					});
					// //去掉默认的contextmenu事件，否则会和右键事件同时出现。
					document.oncontextmenu = function(e){
						e.preventDefault();
					};
					document.onmousedown = function(e){
						e.stopPropagation();
						if(e.button==2){//绘制成功后，鼠标右键事件
							if($("#clear_draw_menu").is(":hidden")){
								if(draw_layer.visible){//如果可见，则可以清理
									$("#nav_draw").removeClass("active");
									map.setMapCursor("default");//绘制结束，还原鼠标
									$("#clear_draw_menu").show();
									$("#pop_res_win_layer").show();
									$("#clear_draw_menu").css({left:e.x,top:e.y});
									$("#pop_res_win_layer").css({left:e.x,top:e.y+$("#clear_draw_menu").height()});
									$("#clear_draw_menu").click(function(){
										if(draw_layer.visible){
											draw_layer.clear();
											draw_layer.hide();
											point_mouse_click_handler = dojo.connect(graLayer_qx_wd,"onClick",function(evt){point_click(evt)});
											point_dev_mouse_click_handler = dojo.connect(graLayer_qx_wd_dev,"onClick",function(evt){point_click(evt)});
											point_mouseout_click_handler = dojo.connect(graLayer_qx_wd,"onMouseOut", function(){point_mouseout()});
											point_mouseover_click_handler = dojo.connect(graLayer_qx_wd,"onMouseOver", function(evt){point_mouseover(evt)});
										}
										$("#clear_draw_menu").hide();
										$("#pop_res_win_layer").hide();
									});
									$("#pop_res_win_layer").click(function(){
										$("#clear_draw_menu").hide();
										$("#pop_res_win_layer").hide();
										layer.open({
											title: ['查询结果','line-height:30px;text-size:30px;height:30px;'],
											type: 1,
											shade: 0,
											area: ['45%','50%'],
											content: $("#draw_result_container"),
											cancel: function(){//右上角关闭回调
												$("#draw_result_container").hide();
											}
										});
									});
								}
							}
							else{
								$("#clear_draw_menu").hide();
								$("#pop_res_win_layer").hide();
							}
						}
					}

					var point_mouse_click_handler = dojo.connect(graLayer_qx_wd,"onClick",function(evt){point_click(evt)});
					var point_dev_mouse_click_handler = dojo.connect(graLayer_qx_wd_dev,"onClick",function(evt){point_click(evt)});

					dojo.query("#nav_draw").onclick(function(evt){
						if(!draw_layer.visible){
							$("#nav_draw").addClass("active");
							map.setMapCursor("crosshair");
							map.infoWindow.hide();
							draw_layer.clear();
							draw_layer.show();
							dojo.disconnect(point_mouse_click_handler);
							dojo.disconnect(point_dev_mouse_click_handler);
							dojo.disconnect(point_mouseout_click_handler);
							dojo.disconnect(point_mouseover_click_handler);
							toolbar.activate(Draw.POLYGON);
							map.hideZoomSlider();
						}
					});
					dojo.query("#nav_earse").onclick(function(evt){
						if(draw_layer.visible){
							$("#nav_draw").removeClass("active");
							map.setMapCursor("default");//绘制结束，还原鼠标
							if(draw_layer.visible){
								draw_layer.clear();
								draw_layer.hide();
								point_mouse_click_handler = dojo.connect(graLayer_qx_wd,"onClick",function(evt){point_click(evt)});
								point_dev_mouse_click_handler = dojo.connect(graLayer_qx_wd_dev,"onClick",function(evt){point_click(evt)});
								point_mouseout_click_handler = dojo.connect(graLayer_qx_wd,"onMouseOut", function(){point_mouseout()});
								point_mouseover_click_handler = dojo.connect(graLayer_qx_wd,"onMouseOver", function(evt){point_mouseover(evt)});
							}
						}
					});

					//点击渠道网点触发表格
					var click_time = "";
					var point_click = function(evt){
						evt.stopPropagation();
						if(click_time=="")//第一次点击
							click_time = new Date().getTime();
						else{
							if(new Date().getTime()-click_time<100)//两次操作小于半秒，可能是冒泡引起的
								return;
							click_time = new Date().getTime();
						}

						var attrs = evt.graphic.attributes;
						var channel_name = attrs.CHANNEL_NA;
						$(".contentPane").empty();
						global_current_flag = 7;
						map.infoWindow.setTitle("网点信息");
						map.infoWindow.resize(300,200);
						var ems = $("#channel_info_win").find("em");
						$(ems[0]).html(channel_name);
						$(ems[1]).html(attrs.CHANNEL_AD);
						$(ems[2]).html(channel_type_array[attrs.CLASS3_ID]);

						map.infoWindow.show(evt.screenPoint);
						$.post(url4query,{eaction:"index_get_by_channel_name",channel_name:attrs.CHANNEL_NA,date:'${yesterday.VAL}',city_name:global_current_area_name},function(data) {
							data = $.parseJSON(data);
							if(data=='' || data ==null){
								$(ems[3]).html("- -");
								$(ems[4]).html("- -");
								$(ems[5]).html("- -");
								$(ems[6]).html("- -");
								$(ems[7]).html("- -");
								$(ems[8]).html("- -");
							}else{
								$(ems[3]).html(data.YD_CURRENT_MON_DEV);
								$(ems[4]).html(data.YD_CURRENT_DAY_DEV);
								$(ems[5]).html(data.KD_CURRENT_MON_DEV);
								$(ems[6]).html(data.KD_CURRENT_DAY_DEV);
								$(ems[7]).html(data.ITV_CURRENT_MON_DEV);
								$(ems[8]).html(data.ITV_CURRENT_DAY_DEV);
							}
							$(".contentPane").append($("#channel_info_win").html());
							//$(".contentPane").append("&nbsp;&nbsp;&nbsp;&nbsp;<span style='margin-left: 30px;'><font style='font-weight: bold'>移动发展:</font>"+data.YD_CURRENT_DAY_DEV+"</span>");
							//$(".contentPane").append("<br/><span><font style='font-weight: bold'>宽带发展:</font>"+data.KD_CURRENT_DAY_DEV+"</span>");
							//$(".contentPane").append("&nbsp;&nbsp;&nbsp;&nbsp;<span style='margin-left: 30px;'><font style='font-weight: bold'>ITV发展:</font>"+data.ITV_CURRENT_DAY_DEV+"</span>");
							/*$(divs[0]).children(":eq(1)").children(":eq(0)").html(data.YD_CURRENT_DAY_DEV);
							 $(divs[1]).children(":eq(1)").children(":eq(0)").html(data.KD_CURRENT_DAY_DEV);
							 $(divs[2]).children(":eq(1)").children(":eq(0)").html(data.ITV_CURRENT_DAY_DEV);*/
						});
					}
					var point_mouseover = function(evt){
						map.setMapCursor("pointer");
					}
					var point_mouseout = function(){
						map.setMapCursor("default");
						//map.infoWindow.hide();
					}

					//graLayer_qx_wd.on("click",function(evt){point_click(evt)});
					var point_mouseout_click_handler = dojo.connect(graLayer_qx_wd, "onMouseOut", function(){point_mouseout()});
					var point_mouseover_click_handler = dojo.connect(graLayer_qx_wd, "onMouseOver", function(evt){point_mouseover(evt)});

					//var ext_temp = tiled.initialExtent;
					//var ext = new Extent(102.52098204406515,35.60142651026425,104.7648137725631,37.02910311376242, new SpatialReference(4326));
					//map.setExtent(ext,true);
					//加入支局显示隐藏功能
					var city_name_temp = name_short_array_reverse[city_name];
					if(city_name_temp==undefined)
						city_name_temp = city_name;
					var full_name = "";
					if(city_name_speical.indexOf(city_name_temp)>-1)
						full_name = city_name_temp + '州';
					else
						full_name = city_name_temp + '市';

					var caz = city_center_zoom[full_name];
					map.centerAndZoom(new esri.geometry.Point(caz.lng,caz.lat, new esri.SpatialReference(4326)), caz.zoom);

					map.on("load", function () {
						toolbar = new Draw(map);
						toolbar.on("draw-end", drawAddToMap);
					});

					map.on("extent-change", function(evt){
						/*var mapZoom = map.getZoom();
						channel_point_symbol_change(mapZoom);
						///query_count_in_view();
						graLayer_zjname.clear();
						zj_name_show_hide(mapZoom);*/
					});
					map.on("click",function(evt){
						//console.log(evt.mapPoint.x+","+evt.mapPoint.y);
					});
					var zj_name_show_hide = function(current_zoom){
						if(current_zoom>6){
							addSubLabel("12px",sub_name_label_symbol1);
							addSubLabel("12px",sub_name_label_symbol2);
							addSubLabel("12px",sub_name_label_symbol3);
							addSubLabel("12px",sub_name_label_symbol4);
							addSubLabel("12px",sub_name_label_symbol5);
						}else if(current_zoom==6){
							addSubLabel("12px",sub_name_label_symbol2);
							addSubLabel("12px",sub_name_label_symbol3);
							addSubLabel("12px",sub_name_label_symbol4);
							addSubLabel("12px",sub_name_label_symbol5);
						}else if(current_zoom==4 || current_zoom==5){
							addSubLabel("11.5px",sub_name_label_symbol3);
							addSubLabel("11.5px",sub_name_label_symbol4);
							addSubLabel("11.5px",sub_name_label_symbol5);
						}else if(current_zoom==3){
							addSubLabel("11px",sub_name_label_symbol4);
							addSubLabel("11px",sub_name_label_symbol5);
						}else if(current_zoom==2){
							addSubLabel("10px",sub_name_label_symbol5);
						}else if(current_zoom==1){
							addSubLabel("10px",sub_name_label_symbol5);
						}

					}

					var addSubLabel = function(font_size,label_symbols){
						for(var i = 0,l = label_symbols.length;i<l;i++){
							var graphics = label_symbols[i];
							var text = graphics.symbol.text;
							var geometry = graphics.geometry;
							var font = new Font(font_size, Font.STYLE_NORMAL, Font.VARIANT_NORMAL);

							var textSymbol = new TextSymbol(text,font, new Color(sub_name_text_color));
							var labelGraphic = new esri.Graphic(geometry, textSymbol);
							graLayer_zjname.add(labelGraphic);
						}
					}
					var channel_point_symbol_change = function(current_zoom){
						var size = 0
						if(current_zoom>6){
							size = 20;
						}else if(current_zoom==6){
							size = 17;
						}else if(current_zoom==4 || current_zoom==5){
							size = 15;
						}else if(current_zoom==3){
							size = 12;
						}else if(current_zoom==2){
							size = 12;
						}else if(current_zoom==1){
							size = 10;
						}
						var gs = graLayer_qx_wd.graphics;
						if(gs.length==0)
							return;
						var gs_new = new Array();
						var geo_new = new Array();
						var attr_new = new Array();
						for(var i = 0,l = gs.length;i<l;i++){
							var sym = gs[i].symbol;
							sym.width = size;
							sym.height = size;
							gs_new.push(sym);
							geo_new.push(gs[i].geometry);
							attr_new.push(gs[i].attributes);
						}
						graLayer_qx_wd.clear();
						for(var i = 0,l = gs_new.length;i<l;i++){
							var pointAttributes = attr_new[i];//{address:'101',city:'Portland',state:'Oregon'};
							var img = new PictureMarkerSymbol(gs_new[i].url, gs_new[i].width, gs_new[i].height);
							var graphic = new esri.Graphic(geo_new[i],img,pointAttributes);
							graLayer_qx_wd.add(graphic);
						}

						freshJumpPoint(channel_name_array);
					}

					//获取图形重心（中心点），用来添加名称到合适的位置
					var getGravityCenter = function(polygon,temp){
						var ext=polygon.getExtent();
						var p0=new Point(ext.xmin, ext.ymin, new SpatialReference({ wkid: 4326 }));
						var momentX=0;
						var momentY=0;
						var weight=0;
						for(var j=0;j<temp.length;j++){
							var pts=temp[j];
							for(var m=0;m<pts.length;m++){
								var p1=polygon.getPoint(j,m);
								var p2;
								if(m==pts.length-1){
									p2 = polygon.getPoint(j, 0);
								}else{
									p2 = polygon.getPoint(j, m+1);
								}
								var dWeight=(p1.x-p0.x)*(p2.y-p1.y)-(p1.x-p0.x)*(p0.y-p1.y)/2- (p2.x-p0.x)*(p2.y-p0.y)/2-(p1.x-p2.x)*(p2.y-p1.y)/2;
								weight += dWeight;
								var pTmp=new Point((p1.x+p2.x)/2, (p1.y+p2.y)/2, new SpatialReference({ wkid: 4326 }));
								var gravityX=p0.x + (pTmp.x-p0.x)*2/3;
								var gravityY=p0.y + (pTmp.y-p0.y)*2/3;
								momentX += gravityX*dWeight;
								momentY += gravityY*dWeight;
							}
						}
						var bbb=new Point(momentX/weight, momentY/weight, new SpatialReference({ wkid: 4326 }));
						return bbb;
					}

					var query_count_in_view = function(){
						var types_cks = $(".popup_type").children("input:gt(0):lt(5)");
						var cks_item_vals = "";
						var checkNum = 0;
						for(var i = 0,l = types_cks.length;i<l;i++){
							if($(types_cks[i]).is(":checked")){
								cks_item_vals += $(types_cks[i]).val()+",";
								checkNum += 1;
							}
						}

						if(checkNum>0){
							cks_item_vals = cks_item_vals.substr(0,cks_item_vals.length-1);
							var array = new Array();
							var channel_type_map = new Array();
							var ext = map.extent;
							var queryTask = new QueryTask(new_url_point + "/0");
							var query = new Query();

							query.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ city_ids[global_current_area_name] +" AND CLASS3_ID IN ("+cks_item_vals+")";
							//query.geometry = ext;
							query.outFields = ['CLASS3_ID','CLASS3','CHANNEL_NA','CHANNEL_AD'];
							query.returnGeometry = true;

							queryTask.execute(query, function(results) {
								var fs = results.features;
								if(fs.length==0){
									return;
								}
								for(var i = 0,l=fs.length;i<l;i++){
									var attr = fs[i].attributes;
									var class3 = attr.CLASS3;
									/*if(class3=="公众直销经理" || class3=="公众直销代理")
									 class3 = "公众直销";*/
									if(array[class3]==undefined){
										array[class3] = 1;
									}else{
										array[class3] += 1;
									}
									channel_type_map[class3] = attr.CLASS3_ID;
								}
								///var res_by_type = "当前视野范围内共"+fs.length+"个网点，其中";
								var res_by_type = global_current_full_area_name+"共"+fs.length+"个网点，其中";
								for(var i = 0,l = channel_type.length;i<l;i++){
									var data = array[channel_type[i]];
									if(data!=undefined){
										res_by_type += "<div style=\"background-image:url("+channel_ico_small[channel_type_map[channel_type[i]]]+");\"></div>"+channel_type[i]+":"+array[channel_type[i]]+"个  ";
									}
								}
								$("#res_in_view").html(res_by_type);
							});
						}else{
							///$("#res_in_view").html("当前视野范围内共0个网点");
							$("#res_in_view").html(global_current_full_area_name+"共0个网点");
						}
					}

					query_count_in_view();

					/*map.on("zoom-end",function(){
						var s = "";

						s = "XMin: "+ map.extent.xmin

						+" YMin: " + map.extent.ymin

						+" XMax: " + map.extent.xmax

						+" YMax: " + map.extent.ymax;

					});*/

					var doChannelQuery = function(location_name){
						map.infoWindow.hide();
						queryResultLayer.clear();
						location_name = $.trim(location_name);
						if(location_name==""){
							layer.msg("请输入名称");
							return;
						}
						back_to_ext = map.extent;
						$("#query_div").hide();

						var location_type = $("#location_type").val();
						if(!location_type)
							location_type = 0;
						console.log(new_url_point + "/"+location_type)
						var queryTask = new QueryTask(new_url_point + "/"+location_type);
						var query = new Query();

						query.where = "CHANNEL_NA LIKE '%"+location_name+"%' AND CLASS4 = '实体渠道' AND LATN_ID = "+ city_ids[global_current_area_name];
						query.outFields = ["CHANNEL_NA","CHANNEL_AD"];
						query.returnGeometry = true;

						queryTask.execute(query, function(results) {

							var fs = results.features;
							var l = fs.length;
							if(l==0){
								layer.msg("当前地市暂无查询结果！");
								return;
							}
							layer.msg(l+"个查询结果",{time:1000});
							for(var i = 0;i<l;i++){
								var f = fs[i];
								var geo = f.geometry;
								var mark = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 30,
										new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
												new Color([0,255,0]), 1),
										new Color([0,255,0,0.25]));
								var graphic = new esri.Graphic(geo,mark);
								queryResultLayer.add(graphic);
							}
							if(l==1)//只有一个结果的时候，把该点定位到地图中心
								map.centerAndZoom(new esri.geometry.Point(geo.x,geo.y,new esri.SpatialReference(4326)), 8);
							else{
								var ext = graphicsUtils.graphicsExtent(fs);
								map.setExtent(ext.expand(1.5));
							}
						});
					}
					$("#location_name").focusin(function(){
						$("#query_div").hide();
						$("#nav_query").removeClass("active");
					});
					$("#location_find1").click(
						function(evt){
							dojo.stopEvent(evt);
							evt.stopPropagation();
							$("#nav_query").removeClass("active");
							var location_name = $("#location_name1").val();
							doChannelQuery(location_name);
						}
					);

					$("#location_find").click(
						function(evt){
							dojo.stopEvent(evt);
							evt.stopPropagation();
							$("#nav_query").removeClass("active");
							var location_name = $("#location_name").val();
							doChannelQuery(location_name);
						}
					);

					//市级范围的支局名称查询
					var sub_data = new Array();
					$.post(url4query,{"eaction":"getSubListByLatnId","city_id":city_id,flag:3},function(data){
						data = $.parseJSON(data);
						if(data.length==0)
							return;

						var where_temp = "SUBSTATION_NO IN (";
						for(var i = 0,l = data.length;i<l;i++){
							sub_data[data[i].UNION_ORG_CODE] = data[i].BRANCH_NAME;
							var union_org_code = data[i].UNION_ORG_CODE;
							where_temp += "'"+union_org_code+"'";
							if(i<l-1)
								where_temp += ",";
						}
						where_temp += ")";

						var queryTask1 = new QueryTask(new_url_sub_vaild + sub_layer_index);
						var query1 = new Query();
						query1.where = where_temp;
						query1.outFields = ['SHAPE.AREA','RESNAME','RESNO','SUBSTATION_NO','REPORTTO'];
						query1.returnGeometry = true;
						queryTask1.execute(query1, function (results){
							if(results.features.length==0)
								return;
							for(var j = 0,k = results.features.length;j<k;j++){
								var geo = results.features[j].geometry;
								var attr = results.features[j].attributes;

								var fillsymbol = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color(sub_fill_color));//36, 170, 219, 0.6  |  21, 136, 216, 0.8  |  231, 147, 106, 0.8
								fillsymbol.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color(sub_line_color), sub_line_width));//255, 255, 255 | 26, 26, 26 | 0, 16, 166
								var graphic = new esri.Graphic(geo, fillsymbol);
								graLayer_qx.add(graphic);

								var area = attr["SHAPE.AREA"];
								var substation = attr["SUBSTATION_NO"];
								var sub_name = sub_data[substation];
								var name_point = "";
								if(sub_name_speical[city_id]==undefined){//按latn_id，获取要特殊处理的支局
									var temp=geo.rings;
									name_point = getGravityCenter(geo,temp);
								}else{
									if(sub_name_speical[city_id][sub_name]==undefined){
										var temp=geo.rings;
										name_point = getGravityCenter(geo,temp);
									}else{
										name_point = geo;
									}
								}
								var font = new Font("12px", Font.WEIGHT_BOLD, Font.WEIGHT_BOLD,Font.WEIGHT_BOLD,"Microsoft Yahei");
								var textSymbol = new TextSymbol(sub_name,font, new Color(sub_name_text_color));
								var labelGraphic = new esri.Graphic(name_point, textSymbol);
								area = area*10000000000;
								if(area>500000000){//zoom=3 地图收到很小
									sub_name_label_symbol5.push(labelGraphic);
								}else if(area>70000000){ //zoom=4
									sub_name_label_symbol4.push(labelGraphic);
								}else if(area>8000000){ //zoom=5
									sub_name_label_symbol3.push(labelGraphic);
								}else if(area>300000){ //zoom=6
									sub_name_label_symbol2.push(labelGraphic);
								}else{ //zoom>=7 地图放到最大，看最清晰的支局
									sub_name_label_symbol1.push(labelGraphic);
								}
							}
							map.addLayer(graLayer_zjname);
							graLayer_zjname.clear();
							zj_name_show_hide(map.getZoom());
							graLayer_zjname.hide();
							graLayer_qx.redraw();
						});
						///默认展示的支局名称
						setTimeout(
							function(){
								for(var i = 0,l = sub_name_label_symbol2.length;i<l;i++){
									graLayer_zjname.add(sub_name_label_symbol2[i]);
								}
								for(var i = 0,l = sub_name_label_symbol3.length;i<l;i++){
									graLayer_zjname.add(sub_name_label_symbol3[i]);
								}
								for(var i = 0,l = sub_name_label_symbol4.length;i<l;i++){
									graLayer_zjname.add(sub_name_label_symbol4[i]);
								}
								for(var i = 0,l = sub_name_label_symbol5.length;i<l;i++){
									graLayer_zjname.add(sub_name_label_symbol5[i]);
								}
							},3000
						);

					});
				}
		);
	}
</script>