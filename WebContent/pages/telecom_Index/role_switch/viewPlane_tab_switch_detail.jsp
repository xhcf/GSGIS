<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
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
<e:q4l var="bureau_list">
	SELECT DISTINCT bureau_no,bureau_name,region_order_Num,'区县列表' a FROM gis_data.db_cde_grid WHERE latn_id = '${param.city_id}' and branch_type in ('a1','b1') order by REGION_ORDER_NUM
</e:q4l>
<e:q4l var="branch_list">
	SELECT DISTINCT T.UNION_ORG_CODE,T.BRANCH_NO,T.BRANCH_NAME,'支局列表' b
	FROM GIS_DATA.DB_CDE_GRID T
	WHERE T.BUREAU_NO = '${param.bureau_id}'
</e:q4l>
<e:q4l var="grid_list">
	select DISTINCT grid_union_org_code grid_id,grid_name,'网格列表' c from GIS_DATA.DB_CDE_GRID t WHERE UNION_ORG_CODE = '${param.branch_id}' AND grid_status = 1
</e:q4l>
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
		#query_text {width:63.41%;background-color:#fff;}
		.bureau_select,.branch_select,.grid_select{width:28%;display:inline-block;}
		#query_btn{
			height: 26px;
			width: 70px;
			background-color: #eeeeee;
			-moz-border-radius: 2px;
			-webkit-border-radius: 2px;
			border-radius: 2px;
			border: 1px solid #ddd;
			color: #000;
			cursor: pointer;
			display: inline-block;
		}
		@media screen and (max-height: 1080px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;display:block;height:104px;}
			.backup{right:1.4%;top:2.5%;}
			.tab_box{margin-top:15px;}
			.datagrid-row{height:23px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;display:block;height:104px;}
			.tab_box{margin-top:15px;}
			.datagrid-row{height:21px;}
		}
		a:link, a:visited, a:hover{text-decoration:none;}
		.sub_box{width:100%;height:100%;background:#EDF8FF;}
	</style>
	<script type="text/javascript">
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_role_switch_action.jsp"/>';
		var city_id_temp = '${param.city_id}';
		var bureau_id_temp = '${param.bureau_id}';
		var branch_id_temp = '${param.branch_id}';
		var grid_id_temp = '${param.grid_id}';
		var text_str_temp = "";

		var begin = '${param.begin}';
		if(begin=="" || begin==undefined)
			begin = "${initTime}";
		var end = '${param.end}';
		if(end=="" || end==undefined)
			end = "${initTime}";
		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var layer_win_size = [610,300];

		$(function(){
			$("#query_text").css({"width":($("#query_text").parent().width()-$("#query_btn").width()-10)});

			if(user_level>=4){
				$(".bureau_select").attr("disabled","disabled");
				$(".branch_select").attr("disabled","disabled");
			}
			if(user_level==5) {
				$(".grid_select").attr("disabled","disabled");
			}

			initCitySelect(user_level);
			citySelectCss(city_id_temp);

			initBureauSelect();
			bureauSelectCss(bureau_id_temp);

			initBranchSelect();
			branchSelectCss(branch_id_temp);

			initGridSelect();
			gridSelectCss(grid_id_temp);

			$("#query_btn").click(function(){
				text_str_temp = $.trim($("#query_text").val());

				var params = {};
				params.city_id1 = city_id_temp;
				params.bureau_id1 = bureau_id_temp;
				params.branch_id1 = branch_id_temp;
				params.grid_id1 = grid_id_temp;
				params.text = text_str_temp;
				$('#tab_login_detail_level').datagrid('load',params);
			});

			//下拉菜单响应事件
			$(".bureau_select").change(function(){bureauSwitch();});
			$(".branch_select").change(function(){branchSwitch();});
			$(".grid_select").change(function(){gridSwitch();});

			var table_row_size = getTableRows3();

			$("#tab_login_detail_level").datagrid({
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
		function bureauSelectCss(bureau_id){
			bureau_id_temp = bureau_id;
			$(".bureau_select").val(bureau_id_temp);
		}
		function branchSelectCss(branch_id){
			branch_id_temp = branch_id;
			$(".branch_select").val($(".branch_select option[value='"+branch_id+"']").val());
		}
		function gridSelectCss(grid_id){
			grid_id_temp = grid_id;
			$(".grid_select").val(grid_id_temp);
		}
		function initBureauSelect(){
			$(".bureau_select").append("<option value='999'>全部</option>");
			var bureau_json = '${e:java2json(bureau_list.list)}';
			bureau_json = $.parseJSON(bureau_json);
			for(var i = 0,l = bureau_json.length;i<l;i++){
				var bureau_item = bureau_json[i];
				$(".bureau_select").append("<option value='"+bureau_item.BUREAU_NO+"'>"+bureau_item.BUREAU_NAME+"</option>");
			}
		}
		function initBranchSelect(){
			$(".branch_select").append("<option value='999' value1='999'>全部</option>");
			var branch_json = '${e:java2json(branch_list.list)}';
			branch_json = $.parseJSON(branch_json);
			for(var i = 0,l = branch_json.length;i<l;i++){
				var branch_item = branch_json[i];
				$(".branch_select").append("<option value='"+branch_item.UNION_ORG_CODE+"'>"+branch_item.BRANCH_NAME+"</option>");
			}
		}
		function initGridSelect(){
			$(".grid_select").append("<option value='999'>全部</option>");
			var grid_json = '${e:java2json(grid_list.list)}';
			grid_json = $.parseJSON(grid_json);
			for(var i = 0,l = grid_json.length;i<l;i++){
				var grid_item = grid_json[i];
				$(".grid_select").append("<option value='"+grid_item.GRID_ID+"'>"+grid_item.GRID_NAME+"</option>");
			}
		}
		function changeBureauSelect(){
			$.post(url4Query,{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
				var bureau_json = $.parseJSON(data);
				$(".bureau_select").empty();
				$(".bureau_select").append("<option value='999' selected=\"selected\">全部</option>");
				for(var i = 0,l = bureau_json.length;i<l;i++){
					var bureau_item = bureau_json[i];
					$(".bureau_select").append("<option value='"+bureau_item.BUREAU_NO+"'>"+bureau_item.BUREAU_NAME+"</option>");
				}
			});
		}
		function changeBranchSelect(){
			$.post(url4Query,{"eaction":"getBranchByBureauId","bureau_id":bureau_id_temp},function(data){
				var branch_json = $.parseJSON(data);
				$(".branch_select").empty();
				$(".branch_select").append("<option value='999' selected=\"selected\">全部</option>");
				for(var i = 0,l = branch_json.length;i<l;i++){
					var branch_item = branch_json[i];
					$(".branch_select").append("<option value='"+branch_item.UNION_ORG_CODE+"'>"+branch_item.BRANCH_NAME+"</option>");
				}
			});
		}
		function changeGridSelect(){
			$.post(url4Query,{"eaction":"getGridByBranchId","branch_id":branch_id_temp},function(data){
				var grid_json = $.parseJSON(data);
				$(".grid_select").empty();
				$(".grid_select").append("<option value='999' selected=\"selected\">全部</option>");
				for(var i = 0,l = grid_json.length;i<l;i++){
					var grid_item = grid_json[i];
					$(".grid_select").append("<option value='"+grid_item.GRID_ID+"'>"+grid_item.GRID_NAME+"</option>");
				}
			});
		}

		function emptyBureauSelect(){
			$(".bureau_select").empty();
			$(".bureau_select").append("<option value='999' selected=\"selected\">全部</option>");
			bureau_id_temp = "999";
		}
		function emptyBranchSelect(){
			$(".branch_select").empty();
			$(".branch_select").append("<option value='999' selected=\"selected\">全部</option>");
			branch_id_temp = "999";
		}
		function emptyGridSelect(){
			$(".grid_select").empty();
			$(".grid_select").append("<option value='999' selected=\"selected\">全部</option>");
			grid_id_temp = "999";
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
						$('#tab_login_detail_level').datagrid('resize');
						$('#tab_login_detail_level').datagrid('options').queryParams = params;
						$('#tab_login_detail_level').datagrid('reload');
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
						$('#tab_login_detail_level').datagrid('resize');
						$('#tab_login_detail_level').datagrid('options').queryParams = params;
						$('#tab_login_detail_level').datagrid('reload');
					}
				}
			});
			$("#endDate").datebox("setValue",end);
		}

		function tabParam(params){
			console.log(params);
			params.dateBegin = begin;
			params.dateEnd = end;
			params.bureau_id = bureau_id_temp;
			if(grid_id_temp==""){
				params.branch_id = branch_id_temp;
				params.grid_id = "999";
			}else{
				params.branch_id = branch_id_temp;
				params.grid_id = grid_id_temp;
			}
			console.log(params);
		}

		function tabLoaded(){
			//$(".datagrid-view").css({"height":$(".sub_box").height()-90});
			//$("#tab_login_detail_level").datagrid("resize");
		}
		function setQueryKeywords(){
			text_str_temp = $.trim($("#query_text").val());
		}
		function citySwitch(city_id){
			if(user_level>1)
				return;
			if(city_id =='999'){
				window.location.href = "<e:url value='/pages/telecom_Index/login_summary/viewPlane_tab_login_province.jsp' />?begin="+begin+"&end="+end;
				return;
			}
			city_id_temp = city_id;
			citySelectCss(city_id);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id;
			params.bureau_id1 = '999';
			params.branch_id1 = '999';
			params.grid_id1 = '999';
			params.begin = begin;
			params.end = end;
			console.log("city_id1:"+city_id);
			$('#tab_login_detail_level').datagrid('load',params);
			changeBureauSelect();
			emptyBranchSelect();
			emptyGridSelect();
		}
		function bureauSwitch(){
			if(user_level>2)
				return;
			var bureau_id = $(".bureau_select option:selected").val();
			bureau_id_temp = bureau_id;
			bureauSelectCss(bureau_id_temp);
			setQueryKeywords();
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = '999';
			params.grid_id1 = '999';
			params.begin = begin;
			params.end = end;
			params.text = text_str_temp;
			$('#tab_login_detail_level').datagrid('load',params);

			changeBranchSelect();
			emptyGridSelect();
		}
		function branchSwitch(){
			if(user_level>2)
				return;
			branch_id_temp = $(".branch_select option:selected").val();
			branchSelectCss(branch_id_temp);
			setQueryKeywords();
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = branch_id_temp;
			params.grid_id1 = '999';
			params.begin = begin;
			params.end = end;
			params.text = text_str_temp;
			$('#tab_login_detail_level').datagrid('load',params);

			changeGridSelect();
		}
		function gridSwitch(){
			if(user_level>4)
				return;
			var grid_id = $(".grid_select option:selected").val();
			grid_id_temp = grid_id;
			gridSelectCss(grid_id_temp);
			setQueryKeywords();
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = branch_id_temp;
			params.grid_id1 = grid_id_temp;
			params.begin = begin;
			params.end = end;
			params.text = text_str_temp;
			$('#tab_login_detail_level').datagrid('load',params);
		}
	</script>
</head>
<body>
	<div class="sub_box" style="margin:0 auto;position: absolute;height:100%;">
		<div style="height:98%;width:100%;margin:0.3% auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:50px;inline-height:50px;text-align:center;"><h4>系&nbsp;统&nbsp;使&nbsp;用&nbsp;日&nbsp;志&nbsp;清&nbsp;单</h4></div>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1'}">
				<!--<a href="javascript:void(0)" onclick="javascript:backup(1)" class="backup">返回上级</a>-->
			</e:if>
			<div class="tab_box">
				<div class="sub_">
					<div class="search" style="height:auto; margin-bottom:3px;">
						<div style="padding-left:18px;margin-top:5px;">
							开始时间：<input id="beginDate" type="text" style="color:#ffffff; width:150px" />&nbsp;&nbsp;&nbsp;
							结束时间：<input id="endDate" type="text" style="color:#ffffff; width:150px" />
						</div>
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td width="50"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp公&nbsp司&nbsp:</div></td>
								<td class="area_select">
									<!--<a href="javascript:void(0)" onclick="citySwitch(999)">全省</a>-->
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
								<td style="">
									<select class="bureau_select"></select>

									<span>&nbsp;&nbsp;&nbsp;&nbsp;支局:</span>
									<select class="branch_select"></select>

									<span>&nbsp;&nbsp;&nbsp;&nbsp;网格:</span>
									<select class="grid_select"></select>
								</td>
							</tr>
							<tr>
								<td width="100"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;查询条件&nbsp:</div></td>
								<td>
									<input type="text" id="query_text" placeholder="输入分局名、支局名、网格名"/>
									<button id="query_btn">查询</button>
								</td>
							</tr>
						</table>
					</div>
					<!--<div class="huizong">
						<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div><div style="display: inline-block;margin-left: 28px">汇总：</div><span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span><span>个</span>
					</div>-->
					<div class="sub_b" style="border:0px;width:97.5%;margin:0px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_市级概况-->
						<c:datagrid
								url="pages/telecom_Index/common/sql/viewPlane_tab_login_action.jsp?eaction=login_detail&city_id=${param.city_id}"
								id="tab_login_detail_level" download='' nowrap="true"
								border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;"  data-options="scrollbarSize:0"
								onLoadSuccess="tabLoaded" mergerFields="EXT6,EXT7" onBeforeLoad="tabParam"
								>
							<thead>
								<tr>
									<th field="EXT6" width="10%" align="center">分公司</th>
									<th field="EXT7" width="20%" align="left" halign="center">分局</th>
									<th field="EXT8" width="25%" align="left" halign="center">支局</th>
									<th field="EXT9" width="25%" align="left" halign="center">网格</th>
									<th field="LOGIN_ID" width="15%" align="left" halign="center" hidden="true">登录工号</th>
									<th field="USER_NAME" width="10%" align="left" halign="center">姓名</th>
									<th field="LOGIN_NUM" width="10%" align="left" halign="center">登录次数</th>
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
