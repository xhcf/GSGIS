<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="bureau_list">
	SELECT DISTINCT bureau_no,bureau_name,region_order_Num,'区县列表' a FROM gis_data.db_cde_grid WHERE latn_id = '${param.city_id}' AND branch_type = 'a1' order by REGION_ORDER_NUM
</e:q4l>
<e:q4l var="branch_list">
	SELECT DISTINCT T.UNION_ORG_CODE,T.BRANCH_NO,T.BRANCH_NAME,'支局列表' b
	FROM GIS_DATA.DB_CDE_GRID T
	WHERE T.BUREAU_NO = '${param.bureau_id}' AND branch_type = 'a1'
</e:q4l>
<e:q4l var="grid_list">
	select DISTINCT grid_id,grid_name,'网格列表' c from GIS_DATA.DB_CDE_GRID t WHERE branch_no = '${param.branch_id}' AND branch_type = 'a1' AND grid_status = 1
</e:q4l>
<e:q4o var="getBranchTypeBySubId">
	SELECT distinct branch_type,union_org_code FROM gis_data.db_cde_grid WHERE branch_no	= '${param.branch_id}'
</e:q4o>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <title>城市支局小区信息统计</title>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
  
  	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js?version=1.3"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.3"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_tab_village.css?version=1.5"/>' rel="stylesheet" type="text/css" />
	<style>
		#tools{height:95%;}
		#query_div{width:120px;height:47px;background:#0f2c92;padding:0;position:absolute;display:none;}
		#query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
		.ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
		#query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
		.datagrid-pager.pagination table tbody tr td span{color:#264f75;}
		.pagination .pagination-num {color:#264f75;}
		#query_text {width:63.41%;background-color:#fff;}
		.backup {position:absolute;right:15px;top:25px;}
		.bureau_select,.branch_select,.grid_select{width:28%;display:inline-block;}
		.datagrid-body{overflow-x:hidden;overflow-y:auto;}
		.sub_b{border:0px;}
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
		.sub_box{width:100%;background:#EDF8FF;}
	</style>
	<script type="text/javascript">
		var city_id_temp = '${param.city_id}';
		var bureau_id_temp = '${param.bureau_id}';
		var branch_id_temp = '${param.branch_id}';
		var union_org_code_temp = "";
		var grid_id_temp = '${param.grid_id}';
		var text_str_temp = "";
		var user_level = '${sessionScope.UserInfo.LEVEL}';
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
				params.branch_id1 = union_org_code_temp;
				params.grid_id1 = grid_id_temp;
				params.text = text_str_temp;
				$('#village_tab_village_level').datagrid('load',params);
			});

			//下拉菜单响应事件
			$(".bureau_select").change(function(){bureauSwitch();});
			$(".branch_select").change(function(){branchSwitch();});
			$(".grid_select").change(function(){gridSwitch();});

			var table_row_size = getTableRows1();
			console.log(table_row_size);

			$("#village_tab_village_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});
		});
		function initCitySelect(user_level){
			if(user_level>1){
				$(".area_select").children().css({"cursor":"default"});
			}
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
				$(".branch_select").append("<option value='"+branch_item.BRANCH_NO+"' value1='"+branch_item.UNION_ORG_CODE+"'>"+branch_item.BRANCH_NAME+"</option>");
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
			$.post("<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp' />",{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
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
			$.post("<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp' />",{"eaction":"getBranchByBureauId","bureau_id":bureau_id_temp},function(data){
				var branch_json = $.parseJSON(data);
				$(".branch_select").empty();
				$(".branch_select").append("<option value='999' selected=\"selected\">全部</option>");
				for(var i = 0,l = branch_json.length;i<l;i++){
					var branch_item = branch_json[i];
					$(".branch_select").append("<option value='"+branch_item.BRANCH_NO+"' value1='"+branch_item.UNION_ORG_CODE+"'>"+branch_item.BRANCH_NAME+"</option>");
				}
			});
		}
		function changeGridSelect(){
			$.post("<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp' />",{"eaction":"getGridByBranchId","branch_id":branch_id_temp},function(data){
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
		
		function tabLoaded(){
			//$("#village_tab_village_level").datagrid("resize");
		}
		function name_shorter1(value,rowData){
			if(window.screen.height<=768){
				if(value.length>7)
					return "<span title=\""+value+"\">"+value.substr(0,7)+"...</span>";
			}else{
				if(value.length>13)
					return "<span title=\""+value+"\">"+value.substr(0,13)+"...</span>";
			}
			return value;
		}
		function name_shorter2(value,rowData){
			if(value==null)
				return;
			if(window.screen.height<=768){
				if(value.length>8)
					return "<span title=\""+value+"\">"+value.substr(0,7)+"...</span>";
			}else{
				if(value.length>16)
					return "<span title=\""+value+"\">"+value.substr(0,15)+"...</span>";
			}
			return value;
		}
		function name_shorter3(value,rowData){
			if(window.screen.height<=768){
				if(value.length>13)
					return "<span title=\""+value+"\">"+value.substr(0,13)+"...</span>";
			}else{
				if(value.length>25)
					return "<span title=\""+value+"\">"+value.substr(0,24)+"...</span>";
			}
			return value;
		}
		function font_important_formatter(value,rowData){
			return "<span style=\"color:#FE7A23;\">"+value+"</span>";
		}
		/*function backup(level){
			if('${sessionScope.UserInfo.LEVEL}'==4)//支局长
				load_list_village_for_sub_grid_user(4,city_id_temp,bureau_id_temp,branch_id_temp);
			else if('${sessionScope.UserInfo.LEVEL}'==5){//网格经理
				load_list_village_for_sub_grid_user(5,city_id_temp,bureau_id_temp,branch_id_temp,grid_id_temp);
			}else//省级、市级
				load_list_village(level,city_id_temp,bureau_id_temp);
		}*/
		function citySwitch(city_id){
			if(user_level>1)
				return;
			if(city_id=='999'){
				load_list_village(1);
				return;
			}
			city_id_temp = city_id;
			citySelectCss(city_id_temp);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = '999';
			params.branch_id1 = '999';
			params.grid_id1 = '999';
			params.text = text_str_temp;
			$('#village_tab_village_level').datagrid('load',params);
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
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = '999';
			params.grid_id1 = '999';
			params.text = text_str_temp;
			$('#village_tab_village_level').datagrid('load',params);

			changeBranchSelect();
			emptyGridSelect();
		}
		function branchSwitch(){
			if(user_level>2)
				return;
			branch_id_temp = $(".branch_select option:selected").val();
			union_org_code_temp = $(".branch_select option:selected").attr("value1");
			branchSelectCss(branch_id_temp);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = union_org_code_temp;
			params.grid_id1 = '999';
			params.text = text_str_temp;
			$('#village_tab_village_level').datagrid('load',params);

			changeGridSelect();
		}
		function gridSwitch(){
			if(user_level>4)
				return;
			var grid_id = $(".grid_select option:selected").val();
			grid_id_temp = grid_id;
			gridSelectCss(grid_id_temp);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = union_org_code_temp;
			params.grid_id1 = grid_id_temp;
			params.text = text_str_temp;
			$('#village_tab_village_level').datagrid('load',params);
		}
	</script>
</head>
<body>
	<div class="sub_box" style="height:100%;width:100%;margin:0 auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0 auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:50px;inline-height:50px;text-align:center;"><h4>城&nbsp;市&nbsp;支&nbsp;局&nbsp;小&nbsp;区&nbsp;信&nbsp;息&nbsp;统&nbsp;计</h4></div>
			<!--<a href="javascript:void(0)" onclick="javascript:backup(3)" class="backup">返回上级</a>-->
			<div class="tab_box">
				<div class="sub_">
					<table cellspacing="0" cellpadding="0" class="search">
						<tr>
							<td width="100"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp;&nbsp;公&nbsp;&nbsp;司&nbsp:</div></td>
							<td class="area_select" colspan="5">
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
								<input type="text" id="query_text" placeholder="输入支局名、网格名、小区名"/>
								<button id="query_btn">查询</button>
							</td>
						</tr>
					</table>
					<!--<div class="huizong">
						<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div><div style="display: inline-block;margin-left: 28px">汇总：</div><span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span><span>个</span>
					</div>-->
					<div class="sub_b" style="border:0px;width:97.5%;margin:15px auto;display:none;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_市级概况-->
							<c:datagrid
									url="pages/telecom_Index/common/sql/viewPlane_tab_village_action.jsp?eaction=village&city_id=${param.city_id}&bureau_id=${param.bureau_id}&branch_id=${getBranchTypeBySubId.UNION_ORG_CODE}&grid_id=${param.grid_id}"
									id="village_tab_village_level" download='' nowrap="true"
									border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;" data-options="scrollbarSize:0"
									mergerFields="LATN_NAME,BRANCH_NAME,GRID_NAME"
									>
								<thead>
								<tr>
									<th field="LATN_NAME" width="6%" align="center">分公司</th>
									<!--<th field="BUREAU_NAME" width="13%" align="center">区县/分局</th>-->
									<th field="BRANCH_NAME" width="10%" halign="center" align="left" formatter="name_shorter1">支局名称</th>
									<th field="GRID_NAME" width="10%" halign="center" align="left" formatter="name_shorter2">网格名称</th>
									<th field="VILLAGE_NAME" width="18%" halign="center" align="left" formatter="name_shorter3">小区名称</th>
									<th field="ZHU_HU_SUM" width="8%" align="center">住户数</th>
									<th field="PEOPLE_NUM" width="8%" align="center">人口数</th>
									<th field="PORT_SUM" width="8%" align="center">端口数</th>
									<th field="PORT_USED_SUM" width="8%" align="center">占用端口数</th>
									<th field="MARKET_LV" width="12%" align="center" formatter="font_important_formatter">市场占有率</th>
									<th field="PORT_LV" width="12%" align="center" formatter="font_important_formatter">端口占有率</th>
								</tr>
								</thead>
							</c:datagrid>
						<!--</div>-->
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>