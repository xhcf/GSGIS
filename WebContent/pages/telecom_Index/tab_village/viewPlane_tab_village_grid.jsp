<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="bureau_list">
	SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM gis_data.db_cde_grid WHERE latn_id = '${param.city_id}' and branch_type = 'a1' order by REGION_ORDER_NUM
</e:q4l>
<e:set var="datagrid_url">
	<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp?eaction=grid&city_id=${param.city_id}&bureau_id=${param.bureau_id}&branch_id=${param.branch_id}&grid_id=${param.grid_id}" />
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
		.datagrid-body{overflow-x:hidden;overflow-y:auto;}
		.layui-layer{background-color:rgb(237, 248, 255);}
		@media screen and (max-height: 1080px){
			.search{width:94.5%;}
			.backup{right:1.4%;top:2.5%;}
		}
		@media screen and (max-height: 768px){
			.sub_{width: 98%;margin:0px auto;}
			.sub_b{}
		}
		.bureau_select a {    display: block;
			float: left;
			margin-right: 20px;width:auto;}
		.bureau_select a.selected {background-color: #ff8a00;
			width: auto;
			height: auto;
			text-align: center;
			border-radius: 4px;
			color: #fff;}
		@media screen and (max-height: 1080px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.backup{right:2.4%;top:2.5%;}
			.tab_box{margin-top:0px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.tab_box{margin-top:0px;}
			.backup{right:2.4%;top:2.5%;}
			.datagrid-row{height:22px;}
		}
		a:link, a:visited, a:hover{text-decoration:none;}
	</style>
	<script type="text/javascript">
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp"/>';
		var city_id_temp = '${param.city_id}';
		var bureau_id_temp = '${param.bureau_id}';
		//var branch_id_temp = '${param.branch_id}';
		//var grid_id_temp = '${param.grid_id}';
		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var layer_win_size = [850,380];
		$(function(){
			initCitySelect(user_level);
			citySelectCss(city_id_temp);
			
			initBureauSelect(user_level);
			bureauSelectCss(bureau_id_temp);
			//$(".sub_b").height($("body").height()-120);

			var table_row_size = getTableRows1();

			$("#village_tab_grid_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});
		});
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
					//if(i!=0)
						$(".bureau_select").append("<a href=\"javascript:void(0)\" class=\"bureau"+bureau_item.BUREAU_NO+"\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('"+bureau_item.BUREAU_NO+"')\">"+bureau_item.BUREAU_NAME+"</a>");
					//else
					//	$(".bureau_select").append("<a href=\"javascript:void(0)\" class=\"bureau"+bureau_item.BUREAU_NO+" selected\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('"+bureau_item.BUREAU_NO+"')\">"+bureau_item.BUREAU_NAME+"</a>");
				}
			});
		}
		
		function tabLoaded(){
			//$("#village_tab_grid_level").datagrid("resize");
		}
		function xiaoji_formatter(value,rowData){
			if($.trim(rowData.GRID_NAME)=='小计')
				return 'background-color:#f1f2f2;color:#000;';
		}
		function font_important_formatter(value,rowData){
			return "<span style=\"color:#FE7A23;\">"+value+"</span>";
		}

		function name_shorter1(value,rowData){
			if(window.screen.height<=768){
				if(value.length>7)
					return "<span title=\""+value+"\">"+value.substr(0,7)+"...</span>";
			}else{
				if(value.length>14)
					return "<span title=\""+value+"\">"+value.substr(0,13)+"...</span>";
			}
			return value;
		}
		function name_shorter2(value,rowData){
			if(window.screen.height<=768){
				if(value.length>15)
					return "<span title=\""+value+"\">"+value.substr(0,15)+"...</span>";
			}else{
				if(value.length>30)
					return "<span title=\""+value+"\">"+value.substr(0,29)+"...</span>";
			}
			return value;
		}
		function name_shorter3(value,rowData){
			if(value==null){
				return '';
			}
			if(window.screen.height<=768){
				if(value.length>15)
					return "<span title=\""+value+"\">"+value.substr(0,15)+"...</span>";
			}else{
				if(value.length>30)
					return "<span title=\""+value+"\">"+value.substr(0,29)+"...</span>";
			}
			return value;

		}
		function font_clickable_formatter1(value,rowData){
			if(value==0){
				if(rowData.GRID_ID!=null)
					return "<span style=\"color:#f00;\">"+value+"</span>";
				else
					return value;
			}

			if(rowData.GRID_ID==null)
				return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:subToVillage('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.BRANCH_NO+"');\">"+value+"</a>";
			else{
				console.log(rowData.GRID_NAME+"  "+value);
				if($.trim(rowData.GRID_NAME)=="小计"){
					return value;
				}else{
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:gridToVillage('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.BRANCH_NO+"','"+rowData.GRID_ID+"');\">"+value+"</a>";
				}
			}

		}
		function font_clickable_formatter2(value,rowData){
			if(value==0)
				return value;
			if(rowData.GRID_ID==null)
				return "<a id=\"showBuild"+rowData.BRANCH_NO+"\" style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showBuildHasNoInVillage('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.BRANCH_NO+"','',1);\">"+value+"</a>";
			else{
				if($.trim(rowData.GRID_NAME)=="小计") {
					return value;
				}else{
					return "<a id=\"showBuild"+rowData.GRID_ID+"\" style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showBuildHasNoInVillage('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.BRANCH_NO+"','"+rowData.GRID_ID+"',2);\">"+value+"</a>";
				}
			}
		}
		function cellStyler(value,rowData){
			if($.trim(rowData.GRID_NAME)=='小计'){
				return 'background-color:#f1f2f2;color:#000;';
			}
		}
		function subToVillage(city_id,bureau_id,branch_id){
			//load_list_village(3,city_id,bureau_id);
			///load_list_village(4,city_id,bureau_id,branch_id);
			//initListDiv(4,city_id,bureau_id,branch_id);
			window.open('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_villageDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id,"","");
		}
		function gridToVillage(city_id,bureau_id,branch_id,grid_id){
			//load_list_village(3,city_id,bureau_id);
			///load_list_village_new_page(5,city_id,bureau_id,branch_id,grid_id);
			//initListDiv(5,city_id,bureau_id,branch_id,grid_id);
			window.open('<e:url value="/pages/telecom_Index/tab_village/viewPlane_tab_village_villageDetail.jsp"/>?city_id='+city_id+"&bureau_id="+bureau_id+"&branch_id="+branch_id+"&grid_id="+grid_id,"","");
		}
		/*function backup(level){
			load_list_village(level,city_id_temp);
		}*/
		function showBuildHasNoInVillage(city_id,bureau_id,branch_no,grid_id,flag){
			var pos = "";
			if(flag==1)
				pos = $('#showBuild'+branch_no).offset();
			else if(flag==2)
				pos = $('#showBuild'+grid_id).offset();
			layer.open({
				type: 1,
				title: '未上小区地址列表',
				area: layer_win_size,
				shade: 0,
				//offset: [50,pos.left-layer_win_size[0]],
				content: $("#buildDetailHasNoVillageDiv"),
				success: function(){
					$('#dg').datagrid({
						url:url4Query,
						pagination:true,
						rownumbers:true,
						fitColumns:true,
						queryParams: {
							"eaction": "getBuildNoInVillageBySubOrGridId",
							"branch_no":branch_no,
							"grid_id":grid_id,
							"flag":flag
						},
						columns:[[
							{field:'LATN_NAME',title:'分公司',width:"8%"},
							{field:'BRANCH_NAME',title:'支局名称',halign:"center",align:'left',halign:"center",width:"12%",
								formatter:function(value,rowData){
								if(value==null)
									return;
								if(value.length>6)
									return "<span title=\""+value+"\">"+value.substr(0,5)+"...</span>";
								return value;
							}},
							{field:'GRID_NAME',title:'网格名称',halign:"center",align:'left',halign:"center",width:"22%",formatter:function(value,rowData){
								if(value==null)
									return;
								if(value.length>10)
									return "<span title=\""+value+"\">"+value.substr(0,9)+"...</span>";
								return value;
							}},
							{field:'SEGM_ID',title:'四级地址编码',align:'left',halign:"center",width:"20%",hidden:true},
							{field:'STAND_NAME',title:'四级地址名称',align:'left',halign:"center",width:"64%",formatter:function(value,rowData){
								if(value==null)
									return;
								if(value.length>38)
									return "<span title=\""+value+"\">"+value.substr(0,37)+"...</span>";
								return value;
							}}
						]],
						onLoadSuccess: function(){
							$('#dg').datagrid("resize");
						}
					});
				}
			});
		}
		function citySwitch(city_id){
			if(user_level>1)
				return;
			if(city_id=='999'){
				///load_list_village(1);
				initListDiv(1);
				return;
			}
			city_id_temp = city_id;
			citySelectCss(city_id_temp);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id2 = '999';
			console.log("city_id1:"+city_id_temp);
			$('#village_tab_grid_level').datagrid('load',params);
			changeBureauSelect();
		}
		function bureauSwitch(bureau_id){
			if(user_level>2)
				return;
			bureau_id_temp = bureau_id;
			bureauSelectCss(bureau_id_temp);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			$('#village_tab_grid_level').datagrid('load',params);
		}
	</script>
</head>
<body>
	<div class="sub_box" style="height:auto;width:100%;margin:0 auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0 auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:50px;inline-height:50px;text-align:center;"><h4>城&nbsp;市&nbsp;支&nbsp;局&nbsp;小&nbsp;区&nbsp;信&nbsp;息&nbsp;统&nbsp;计</h4></div>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1' || sessionScope.UserInfo.LEVEL eq '2'}">
				<!--<a href="javascript:void(0)" onclick="javascript:backup(2)" class="backup">返回上级</a>-->
			</e:if>
			<div class="tab_box">
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
					<!--<div class="huizong">
						<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div><div style="display: inline-block;margin-left: 28px">汇总：</div><span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span><span>个</span>
					</div>-->
					<div class="sub_b" style="border:0px;width:97.5%;margin:15px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_市级概况-->
							<c:datagrid
									url="${datagrid_url}"
									id="village_tab_grid_level" download='' nowrap="true"
									border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;" data-options="scrollbarSize:0"
									mergerFields="LATN_NAME,BUREAU_NAME,BRANCH_NAME" frozenRows="0"
									>
								<thead>
								<tr>
									<th field="LATN_NAME" width="10%" align="center">分公司</th>
									<th field="BUREAU_NAME" width="12%" align="center" formatter="name_shorter1">区县/分局</th>
									<th field="BRANCH_NAME" width="16%" halign="center" align="left" formatter="name_shorter2">支局名称</th>
									<th field="GRID_NAME" width="17%" halign="center" align="left" formatter="name_shorter3" styler="cellStyler">网格名称</th>
									<th field="VILLAGE_NUM" width="15%" align="center" formatter="font_clickable_formatter1" styler="cellStyler">小区数</th>
									<th field="BUILD_NUM" width="15%" align="center" styler="cellStyler">楼宇数</th>
									<th field="BUILD_NUM_V" width="15%" align="center" formatter="font_clickable_formatter2" styler="cellStyler">未划配楼宇数</th>
								</tr>
								</thead>
							</c:datagrid>
						<!--</div>-->
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 未建小区的网格明细列表 -->
	<div id="buildDetailHasNoVillageDiv">
		<table id="dg"></table>
	</div>
</body>
</html>