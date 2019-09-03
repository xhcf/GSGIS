<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:set var="datagrid_url">
	<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp?eaction=city&city_id=${param.city_id}" />
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
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_tab_village.css?version=1.0"/>' rel="stylesheet" type="text/css" />
	<style>
		#tools{height:95%;}
		#query_div{width:120px;height:47px;background:#0f2c92;padding:0;position:absolute;display:none;}
		#query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
		.ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
		#query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
		.datagrid-pager.pagination table tbody tr td span{color:#264f75;}
		.pagination .pagination-num {color:#264f75;}
		.backup {position:absolute;right:15px;top:25px;}

		/*弹窗*/
		#gridDetailHasNoVillageDiv{width:100%;min-height:100%;max-height:500px;display:none;position:absolute;}
		#dg{width:590px;height:98%;}
		.layui-layer{background-color:rgb(237, 248, 255);}

		#village_tab_city_level{height:auto;}
		@media screen and (max-height: 1080px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.backup{right:1.4%;top:2.5%;}
			.tab_box{margin-top:18px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.tab_box{margin-top:13px;}
		}
		/*.sub_box h4{margin:0 auto;position:relative;}*/
		.tab_box{margin-top:0px;}
	</style>
	<script type="text/javascript">
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp"/>';
		var city_id_temp = '${param.city_id}';
		if(city_id_temp=="")
			city_id_temp = city_id_for_village_tab_view;
		else
			city_id_for_village_tab_view = city_id_temp;
		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var layer_win_size = [610,300];

		$(function(){
			//if(user_level==1) {
			//	$(".area_select a").click(function () {
			//		$(this).addClass("selected");
			//		$(this).siblings().removeClass("selected")
			//	});
			//}

			//$(".area_select a[onclick='city("+city_id_temp+")']").addClass("selected");
			//$(".area_select a[onclick='city("+city_id_temp+")']").siblings().removeClass("selected");
			$("#model_to_rank").click(function(){
				if($("#query_div").is(":hidden")){
					var top_px = $(this).offset().top;
					$("#query_div").css({"left":$(this).offset().left+35,"top":top_px+4,"height":$(this).height()+6});
					$("#query_div").show();
				}else{
					$("#query_div").hide();
				}
			});
			
			citySelectCss(city_id_temp);

			//返回地图模式
			$("#nav_hidetiled").click(function(){
				load_map_view();
				//parent.load_map_view();
			});

			var table_row_size = getTableRows();

			$("#village_tab_city_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});
		});
		function citySelectCss(city_id_temp){
			$(".area_select a[onclick='citySwitch("+city_id_temp+")']").addClass("selected");
			$(".area_select a[onclick='citySwitch("+city_id_temp+")']").siblings().removeClass("selected");
		}

		function tabLoaded(){
			//$(".datagrid-view").css({"height":$(".sub_box").height()-90});
			//$("#village_tab_city_level").datagrid("resize");
		}
		function font_important_formatter(value,rowData){
			return "<span style=\"color:#FE7A23;\">"+value+"</span>";
		}
		function font_clickable_formatter1(value,rowData){
			if(window.screen.height<=768){
				if(value.length>7)
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:bureauToGrid('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"');\">"+value.substr(0,7)+"...</a>";
			}else{
				if(value.length>14)
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:bureauToGrid('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"');\">"+value.substr(0,13)+"...</a>";
			}

			return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:bureauToGrid('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"');\">"+value+"</a>";
		}
		function font_clickable_formatter2(value,rowData){
			if(value>0)
				return "<a id=\"showGrid"+rowData.BUREAU_NO+"\" style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showGridHasNoVillage('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"');\">"+value+"</a>";
			return value;
		}
		function bureauToGrid(city_id,bureau_id){
			load_list_village(2,city_id,bureau_id);
		}
		function backup(level){
			load_list_village(level);
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
				load_list_village(1);
				return;
			}
			citySelectCss(city_id);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id;
			console.log("city_id1:"+city_id);
			$('#village_tab_city_level').datagrid('load',params);
		}
		function hideDivWin(){
			$("#gridDetailHasNoVillageDiv").hide();
		}
	</script>
</head>
<body>
	<div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;">
		<ul id="tools">
			<li id="nav_hidetiled" ><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
			<li id="model_to_rank" class="active" style="cursor:hand"><span></span><a href="javascript:void(0)" id="" style="cursor:hand">统计</a></li>
			<li id="nav_zoomin" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="zoomin" style="cursor:not-allowed;">放大</a></li>
			<li id="nav_zoomout" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="zoomout" style="cursor:not-allowed;">缩小</a></li>
			<li id="nav_hidepoint" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="hidepoint" style="cursor:not-allowed;">网点</a></li>
			<%--<li id="nav_query"><span></span><a href="javascript:void(0)" id="query">查找</a></li>--%>
			<li id="nav_list"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="list" style="cursor:not-allowed;">支局</a></li>
			<li id="nav_grid"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="grid" style="cursor:not-allowed;">网格</a></li>
			<li id="nav_village"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="village" style="cursor:not-allowed;">小区</a></li>
			<li id="nav_standard"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="standard" style="cursor:not-allowed;">楼宇</a></li>
			<li id="nav_marketing"  style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="marketing" style="cursor:not-allowed;">营销</a></li>
			<!-- <li id="nav_earse"><span></span><a href="javascript:void(0)" id="earseTool">擦除</a></li>-->
			<!--<li id="nav_chart" style="cursor: hand"><span></span><a href="javascript:void(0)" id="hidechart">市场</a></li>-->
			<!--<li id="nav_heatmap" style="cursor: hand"><span></span><a href="javascript:void(0)" id="heatmap">热力图</a></li>-->
			<!--<li id="nav_tianyi"><span></span><a href="javascript:void(0)">天翼</a></li>
	         <li id="nav_kuandai"><span></span><a href="javascript:void(0)">宽带</a></li>
	         <li id="nav_itv"><span></span><a href="javascript:void(0)">ITV</a></li>
	         <li id="nav_reli"><span></span><a href="javascript:void(0)">热力</a></li>
	         <li id="nav_guanbi"><span></span><a href="javascript:void(0)">关闭</a></li>-->
			<!--  li id="nav_fanhui"><span></span><a href="javascript:backToEchart()" id="backtop">返回</a></li-->
			<!--  li id="nav_fanhui_qx" style="display:none;"><span></span><a href="javascript:backToQx()" id="backtop_qx">返回</a></li-->
		</ul>
	</div>
	<div class="sub_box" style="height:99%;margin:0.3% auto;position: absolute;left: 40px;border: 2px solid #2070dc;">
		<div style="height:98%;width:100%;margin:0.3% auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:50px;inline-height:50px;text-align:center;"><h4>城&nbsp;市&nbsp;支&nbsp;局&nbsp;小&nbsp;区&nbsp;信&nbsp;息&nbsp;统&nbsp;计</h4></div>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1'}">
				<!--<a href="javascript:void(0)" onclick="javascript:backup(1)" class="backup">返回上级</a>-->
			</e:if>
			<div class="tab_box">
				<div class="sub_">
					<table cellspacing="0" cellpadding="0" class="search">
						<tr>
							<td width="50"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp公&nbsp司&nbsp:</div></td>
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
					</table>
					<!--<div class="huizong">
						<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div><div style="display: inline-block;margin-left: 28px">汇总：</div><span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span><span>个</span>
					</div>-->
					<div class="sub_b" style="border:0px;width:97.5%;margin:15px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_市级概况-->
						<c:datagrid
								url="${datagrid_url}"
								id="village_tab_city_level" download='' nowrap="true"
								border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;"  data-options="scrollbarSize:0"
								onLoadSuccess="tabLoaded" mergerFields="LATN_NAME,BUREAU_NAME"
								>
							<thead>
								<tr>
									<th field="LATN_NAME" width="10%" align="center">分公司</th>
									<th field="BUREAU_NAME" width="15%" align="center" formatter="font_clickable_formatter1">区县/分局</th>
									<th field="BRANCH_NUM" width="15%" align="center">支局数</th>
									<th field="GRID_NUM" width="15%" align="center">网格数</th>
									<th field="VILLAGE_NUM" width="15%" align="center" formatter="font_important_formatter">小区数</th>
									<th field="BRANCH_V" width="15%" align="center">未上小区支局数</th>
									<th field="GRID_V" width="15%" align="center" formatter="font_clickable_formatter2">未上小区网格数</th>
								</tr>
							</thead>
						</c:datagrid>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="query_div">
		<div style="width:60px;border-right:1px solid #ccc;padding-left:0px;padding-top:3px;padding-bottom:7px;" onclick="javascript:viewRank();">
			<div style="width:100%;height:15px;"><img src="<e:url value='/pages/telecom_Index/sub_grid/image/paiming1.png' />" class="ico" style="margin-left:20px;margin-top:0px;" /></div>
			<div style="width:100%;height:15px;font-size:12px;text-align:center;">划小排名</div>
		</div>
		<div style="width:60px;padding-left:0px;padding-top:3px;padding-bottom:3px;" class="mapico" onclick="javascript:viewVillageDraw();">
			<div style="width:100%;height:15px;"><img src="<e:url value='/pages/telecom_Index/sub_grid/image/shangtu1.png' />" class="ico" style="margin-left:20px;margin-top:0px;" /></div>
			<div style="width:100%;height:15px;font-size:12px;text-align:center;">小区统计</div>
		</div>
	</div>

	<!-- 未建小区的网格明细列表 -->
	<div id="gridDetailHasNoVillageDiv">
		<table id="dg"></table>
	</div>
</body>
</html>
