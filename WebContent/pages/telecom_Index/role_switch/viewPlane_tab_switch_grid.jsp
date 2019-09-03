<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="bureau_list">
	SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM gis_data.db_cde_grid WHERE latn_id = '${param.city_id}' and branch_type in ('a1','b1') order by REGION_ORDER_NUM
</e:q4l>
<e:q4o var="yesterday">
	select to_char(sysdate-1,'yyyymmdd') val,to_char(sysdate-1,'yyyy-mm-dd') val1 from dual
</e:q4o>
<e:set var="initTime">${yesterday.VAL1}</e:set>
<e:if condition="${empty param.begin}">
	<e:set var="begin" value="${initTime}" />
</e:if>
<e:if condition="${empty param.end}">
	<e:set var="end" value="${initTime}" />
</e:if>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <title>GIS营销系统使用情况统计</title>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />

  	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js?version=1.1"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/datagrid_mergeCell.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_tab_village.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/pages/telecom_Index/common/css/datagid_reset.css?version=1.0"/>' rel="stylesheet" type="text/css" />
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
		.layui-layer{background-color:rgb(237, 248, 255);}

		@media screen and (max-height: 1080px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;display:block;height:74px;}
			.backup{right:1.4%;top:2.5%;}
			.tab_box{margin-top:12px;}
			.sub{width:100%;margin:0px auto;margin-top:10px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;display:block;height:74px;}
			.tab_box{margin-top:6px;}
			.sub{width:100%;margin:0px auto;}
		}
		.bureau_select a {display: block;
			float: left;
			margin-right: 20px;width:auto;}
		.bureau_select a.selected {background-color: #ff8a00;
			width: auto;
			height: auto;
			text-align: center;
			border-radius: 4px;
			color: #fff;}
		/*.sub_box h4{margin:0 auto;position:relative;}*/
		body{background:rgb(237, 248, 255);}
	</style>
	<script type="text/javascript">
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_role_switch_action.jsp"/>';
		var city_id_temp = '${param.city_id}';
		var bureau_id_temp = '${param.bureau_id}';
		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var layer_win_size = [610,300];

		var begin = '${param.begin}';
		if(begin=="" || begin==undefined)
			begin = "${initTime}";
		var end = '${param.end}';
		if(end=="" || end==undefined)
			end = "${initTime}";

		$(function(){
			initCitySelect(user_level);
			citySelectCss(city_id_temp);

			initBureauSelect(user_level);
			bureauSelectCss(bureau_id_temp);

			var table_row_size = getTableRows3();

			$("#tab_login_grid_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});

			initDateSelect();
		});
		function initCitySelect(user_level) {
			if(user_level>1)
				$(".area_select a").css({"cursor":"default"});
		}
		function citySelectCss(city_id_temp){
			$(".area_select a[onclick='citySwitch("+city_id_temp+")']").addClass("selected");
			$(".area_select a[onclick='citySwitch("+city_id_temp+")']").siblings().removeClass("selected");
		}
		function initDateSelect(){
			$("#beginDate").datebox({
				onSelect : function(date){
					var begin_tmp = $('#beginDate').datebox('getValue').replace(/-/g, "");
					var end_tmp = $('#endDate').datebox('getValue').replace(/-/g, "");
					if(begin_tmp>end_tmp)
						layer.msg("开始日期不能大于结束日期");
					else{
						var params = new Object();
						params.dateBegin = $('#beginDate').datebox('getValue');
						begin = $('#beginDate').datebox('getValue');
						params.dateEnd = $('#endDate').datebox('getValue');
						end = $('#endDate').datebox('getValue');
						$('#tab_login_grid_level').datagrid('resize');
						$('#tab_login_grid_level').datagrid('options').queryParams = params;
						$('#tab_login_grid_level').datagrid('reload');
					}
				}
			});
			$("#beginDate").datebox("setValue",begin);

			$("#endDate").datebox({
				onSelect : function(date){
					var begin_tmp = $('#beginDate').datebox('getValue').replace(/-/g, "");
					var end_tmp = $('#endDate').datebox('getValue').replace(/-/g, "");
					if(begin_tmp>end_tmp)
						layer.msg("结束日期不能小于开始日期");
					else{
						var params = new Object();
						params.dateBegin = $('#beginDate').datebox('getValue');
						begin = $('#beginDate').datebox('getValue');
						params.dateEnd = $('#endDate').datebox('getValue');
						end = $('#endDate').datebox('getValue');
						$('#tab_login_grid_level').datagrid('resize');
						$('#tab_login_grid_level').datagrid('options').queryParams = params;
						$('#tab_login_grid_level').datagrid('reload');
					}
				}
			});
			$("#endDate").datebox("setValue",end);
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
		function bureauSelectCss(bureau_id){
			bureau_id_temp = bureau_id;
			$(".bureau"+bureau_id_temp).addClass("selected");
			$(".bureau"+bureau_id_temp).siblings().removeClass("selected");
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
		function tabParam(params){
			console.log(params);
			params.dateBegin = begin;
			params.dateEnd = end;
			params.bureau_id = bureau_id_temp;
			console.log(params);
		}

		function tabLoaded(){
			//$(".datagrid-view").css({"height":$(".sub_box").height()-90});
			//$("#tab_login_grid_level").datagrid("resize");
		}
		function font_clickable_formatter2(value,rowData){
			if(value>0){
				if(rowData.EXT4==null)
					return "<a id=\"showDetail"+rowData.UNION_ORG_CODE+"\" style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showDetail('"+rowData.EXT1+"','"+rowData.EXT2+"','"+rowData.EXT3+"','');\">"+value+"</a>";
				else
					return "<a id=\"showDetail"+rowData.GRID_ID+"\" style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showDetail('"+rowData.EXT1+"','"+rowData.EXT2+"','"+rowData.EXT3+"','"+rowData.EXT4+"');\">"+value+"</a>";
			}
			return value;
		}
		function citySwitch(city_id){
			if(user_level>1)
				return;
			if(city_id =='999'){
				window.location.href = "<e:url value='/pages/telecom_Index/role_switch/viewPlane_tab_switch_province.jsp' />";
				return;
			}
			city_id_temp = city_id;
			citySelectCss(city_id);
			var params = {};
			params.city_id1 = city_id;
			params.bureau_id2 = '999';
			params.begin = begin;
			params.end = end;
			$('#tab_login_grid_level').datagrid('load',params);
			changeBureauSelect();
		}
		function bureauSwitch(bureau_id){
			if(user_level>2)
				return;
			bureau_id_temp = bureau_id;
			bureauSelectCss(bureau_id_temp);
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			$('#tab_login_grid_level').datagrid('load',params);
		}
		function showDetail(latn_id,bureau_no,branch_no,grid_id){
			if(grid_id=='')
				grid_id = '999';
			window.open("<e:url value='pages/telecom_Index/role_switch/viewPlane_tab_switch_detail.jsp' />?city_id="+latn_id+"&bureau_id="+bureau_no+"&branch_id="+branch_no+"&grid_id="+grid_id+"&begin="+begin+"&end="+end, "", "");
		}
		function clickUser(value,rowData){
			return "<a href=\"javascript:openToUser('"+rowData.LOGIN_ID+"','"+rowData.PASSWORD+"');\" >"+value+"</a>";
		}
		function openToUser(id,pwd){
			window.open("<e:url value='/login.e?' />user="+id+"&pwd="+pwd,"","");
		}
	</script>
</head>
<body>
	<div class="sub_box" style="height:auto;width:100%;margin:0.3% auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0.3% auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:50px;inline-height:50px;text-align:center;"><h4>系统用户</h4></div>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1'}">
				<!--<a href="javascript:void(0)" onclick="javascript:backup(1)" class="backup">返回上级</a>-->
			</e:if>
			<div class="tab_box">
				<div class="sub_">
					<div class="search" style="height:auto; margin-bottom:3px;">
						<table cellspacing="0" cellpadding="0">
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
							<tr>
								<td width="100"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分局/区县:</div></td>
								<td>
									<div class="bureau_select"></div>
								</td>
							</tr>
						</table>
					</div>
					<!--<div class="huizong">
						<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div><div style="display: inline-block;margin-left: 28px">汇总：</div><span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span><span>个</span>
					</div>-->
					<div class="sub_b" style="border:0px;width:97.5%;margin:0px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_市级概况-->
						<!-- url="pages/telecom_Index/common/sql/viewPlane_tab_role_switch_action.jsp?eaction=org_summary&" -->
						<c:datagrid
								url="pages/telecom_Index/common/sql/viewPlane_tab_role_switch_action.jsp?eaction=sub&city_id=${param.city_id}"
								id="tab_login_grid_level" download='' nowrap="true"
								border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;"  data-options="scrollbarSize:0"
								onLoadSuccess="tabLoaded" mergerFields="EXT7,EXT8" onBeforeLoad="tabParam"
								>
							<thead>
								<tr>
									<th field="EXT7" width="14%" align="left" halign="center">分局</th>
									<th field="EXT8" width="20%" align="left" halign="center">支局</th>
									<th field="USER_NAME" width="20%" align="left" halign="center" formatter="clickUser">用户名</th>
									<th field="TELEPHONE" width="20%" align="left" halign="center">电话</th>
								</tr>
							</thead>
						</c:datagrid>
					</div>
					<div style="border:0px;width:97.5%;margin:15px auto;display:none;">说明：仅统计支局和网格用户的使用情况。</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>