<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="yesterday">
	select to_char(sysdate-1,'yyyymmdd') val,to_char(sysdate-1,'yyyy-mm-dd') val1 from dual
</e:q4o>
<e:set var="initTime">${yesterday.VAL1}</e:set>
<e:q4l var="bureau_list">
	SELECT DISTINCT bureau_no,bureau_name,region_order_Num,'区县列表' a FROM gis_data.db_cde_grid WHERE latn_id = '${param.city_id}' and branch_type in ('a1','b1') order by REGION_ORDER_NUM
</e:q4l>
<e:q4l var="branch_list">
	SELECT DISTINCT T.UNION_ORG_CODE,T.BRANCH_NO,T.BRANCH_NAME,'支局列表' b
	FROM GIS_DATA.DB_CDE_GRID T
	WHERE T.BUREAU_NO = '${param.bureau_id}'
	and T.BRANCH_TYPE IN ('a1','b1')
</e:q4l>
<e:q4l var="grid_list">
	select DISTINCT grid_id,grid_name,'网格列表' c from GIS_DATA.DB_CDE_GRID t WHERE UNION_ORG_CODE = '${param.branch_id}' AND grid_status = 1
</e:q4l>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <title>竞争信息收集统计</title>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />

  	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
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
		.pagination-info{margin-right:2%;}
		#query_text {background-color:#fff;}
		/*.bureau_select.branch_select,.grid_select{width:28%;display:inline-block;}*/
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
		.bureau_select,.branch_select,.grid_select{width:100%;}
	</style>
	<script type="text/javascript">
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
		var url4Query1 = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_info_collect_action.jsp"/>';
		var city_id_temp = '${param.city_id}';
		var bureau_id_temp = '${param.bureau_id}';
		var branch_id_temp = '${param.branch_id}';
		var grid_id_temp = '${param.grid_id}';
		var month_flag_temp = '${param.month_flag}';

		var text_str_temp = "";

		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var layer_win_size = [610,300];

		$(function(){

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

			initDqsjSelect();
			dqsjSelectCss(month_flag_temp);

			initQueryText();

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

			var table_row_size = getTableRows();

			$("#tab_login_detail_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});

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
		function initDqsjSelect(){
			$("input[name='dqsj']").click(function(){
				var params = {};
				params.city_id1 = city_id_temp;
				params.bureau_id1 = bureau_id_temp;
				params.branch_id1 = branch_id_temp;
				params.grid_id1 = grid_id_temp;
				params.month_flag1 = $(this).val();
				$('#tab_login_detail_level').datagrid('load',params);
			});
		}
		function dqsjSelectCss(month_flag){
			if(month_flag==""){
				$("input[name='dqsj'] :eq(0)").attr("checked","checked");
			}else{
				$("input[name='dqsj'][value="+month_flag+"]").attr("checked","checked");
			}
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

		function initQueryText(){
			$("#query_text").css({"width":($("#query_text").parent().width()-$("#query_btn").width())});
		}

		function changeBureauSelect(){
			$.post(url4Query1,{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
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
			$.post(url4Query1,{"eaction":"getBranchByBureauId","bureau_id":bureau_id_temp},function(data){
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
			$.post(url4Query1,{"eaction":"getGridByBranchId","branch_id":branch_id_temp},function(data){
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

		function tabParam(params){
			params.bureau_id = bureau_id_temp;
			if(grid_id_temp==""){
				params.branch_id = branch_id_temp;
				params.grid_id = "999";
			}else{
				params.branch_id = branch_id_temp;
				params.grid_id = grid_id_temp;
			}
			if(month_flag_temp!="")
				params.month_flag = month_flag_temp;
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
				backToProvince();
				return;
			}
			city_id_temp = city_id;
			citySelectCss(city_id);
			setQueryKeywords();
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id;
			params.bureau_id1 = '999';
			params.branch_id1 = '999';
			params.grid_id1 = '999';
			params.text = text_str_temp;
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
			branch_id_temp = "";
			grid_id_temp = "";
			bureauSelectCss(bureau_id_temp);
			setQueryKeywords();
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = '999';
			params.grid_id1 = '999';
			params.text = text_str_temp;
			$('#tab_login_detail_level').datagrid('load',params);

			changeBranchSelect();
			emptyGridSelect();
		}
		function branchSwitch(){
			if(user_level>2)
				return;
			branch_id_temp = $(".branch_select option:selected").val();
			grid_id_temp = "";
			branchSelectCss(branch_id_temp);
			setQueryKeywords();
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = bureau_id_temp;
			params.branch_id1 = branch_id_temp;
			params.grid_id1 = '999';
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
			params.text = text_str_temp;
			$('#tab_login_detail_level').datagrid('load',params);
		}
		function font_clickable_formatter1(value,rowData){
			return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:toInfoCollectView('"+rowData.SEGM_ID_2+"','"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"','"+rowData.GRID_ID+"');\">"+value+"</a>";
		}
		function toInfoCollectView(add6_id, city_id, area_id, substation, grid_id) {//TB_GIS_ADDR_other_ALL
			$("#info_collect_view_div > iframe").attr("src", "<e:url value='/pages/telecom_Index/sub_grid/viewPlane_info_collect_view.jsp' />"+"?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
			//$("#info_collect_view_div").show();
			collect_view_handler = layer.open({
				title: ['收集详情', 'line-height:32px;text-size:30px;height:32px;'],
				//title:false,
				type: 1,
				shade: 0,
				area: ['710px', '485px'],
				//offset: ['1px', '38px'],
				content: $("#info_collect_view_div"),
				cancel: function (index) {
					layer.close(collect_view_handler);
				}
			});
		}
		function openWinInfoCollectEdit(add6_id, city_id, area_id, substation, grid_id){
			$("#info_collect_edit_div > iframe").attr("src", "<e:url value='/pages/telecom_Index/sub_grid/viewPlane_info_collect_edit.jsp' />"+"?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
			//$("#info_collect_edit_div").show();
			collect_edit_handler = layer.open({
				title: ['竞争收集', 'line-height:32px;text-size:30px;height:32px;'],
				//title:false,
				type: 1,
				shade: 0,
				area: ['710px', '485px'],
				//offset: ['1px', '38px'],
				content: $("#info_collect_edit_div"),
				cancel: function (index) {
					layer.close(collect_edit_handler);
				}
			});
		}
	</script>
</head>
<body>
	<div class="sub_box" style="margin:0 auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0 auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:50px;inline-height:50px;text-align:center;"><h4>竞&nbsp;争&nbsp;信&nbsp;息&nbsp;收&nbsp;集&nbsp;统&nbsp;计</h4></div>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1'}">
				<!--<a href="javascript:void(0)" onclick="javascript:backup(1)" class="backup">返回上级</a>-->
			</e:if>
			<div class="tab_box">
				<div class="sub_">
					<div class="search" style="height:auto; margin-bottom:3px;">
						<div style="padding-left:18px;display:none;">
							开始时间：<input id="beginDate" type="text" style="color:#ffffff; width:150px" />&nbsp;&nbsp;&nbsp;
							结束时间：<input id="endDate" type="text" style="color:#ffffff; width:150px" />
						</div>
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td width="100"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp;公&nbsp;司&nbsp;&nbsp;:</div></td>
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
								<td>
									<select class="bureau_select"></select>
								</td>
								<td width="80">&nbsp;&nbsp;支&nbsp;&nbsp;&nbsp;&nbsp;局:</td>
								<td>
									<select class="branch_select"></select>
								</td>
								<td width="80">&nbsp;&nbsp;网&nbsp;&nbsp;&nbsp;&nbsp;格:</td>
								<td>
									<select class="grid_select"></select>
								</td>
							</tr>
							<tr>
								<td width="100"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;到期时间&nbsp:</div></td>
								<td>
									<div style="width:26%;display:inline-block;"><input type="radio" name="dqsj" value="" style="margin-left: 1px;display:inline-block;" />全&nbsp;部</div>
									<div style="width:30%;display:inline-block;"><input type="radio" name="dqsj" value="1" style="margin-left: 1px;display:inline-block;" />近一月</div>
									<div style="width:30%;display:inline-block;"><input type="radio" name="dqsj" value="2" style="margin-left: 1px;display:inline-block;" />近两月</div>
								</td>
								<td>
									&nbsp;&nbsp;查询条件:
								</td>
								<td colspan="3">
									<input type="text" id="query_text" placeholder="输入小区名称、客户名称、联系电话、详细地址" style="margin-left: 1px;display:inline-block;" />
									<button id="query_btn" style="margin-left: 1px;display:inline-block;" >查询</button>
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
								url="pages/telecom_Index/common/sql/viewPlane_tab_info_collect_action.jsp?eaction=detail&city_id=${param.city_id}"
								id="tab_login_detail_level" download='' nowrap="true"
								border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;"  data-options="scrollbarSize:0"
								onLoadSuccess="tabLoaded" mergerFields="VILLAGE_NAME" onBeforeLoad="tabParam"
								>
							<thead>
								<tr>
									<th field="VILLAGE_NAME" width="20%" align="center">小区名称</th>
									<th field="CONTACT_PERSON" width="10%" align="center" halign="center" formatter="font_clickable_formatter1">客户名称</th>
									<th field="CONTACT_NBR" width="10%" align="left" halign="center">联系电话</th>
									<th field="STAND_NAME_2" width="42%" align="left" halign="center">详细地址</th>
									<th field="BUSINESS_TEXT" width="8%" align="left" halign="center">运营商</th>
									<th field="DQ_DATE" width="10%" align="left" halign="center">到期时间</th>
								</tr>
							</thead>
						</c:datagrid>
					</div>
					<div style="border:0px;width:97.5%;margin:15px auto;">说明：
						收集用户数，指收集了异网信息的住户数;
						近一月到期，指收集产品的到期时间是截至当月月底的到期信息；
						近二月到期，指收集产品的到期时间是截至下月月底的到期信息。
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 收集详情 -->
	<div class="info_collect_win" id="info_collect_view_div" style="display:none;">
		<!--<div class="titlea">
            <div id="info_collect_view_draggable" style='text-align:left;width:90%;display: inline-block'>收集详情</div>
            <div class="titlec" id="info_collect_view_div_close"></div>
        </div>-->
		<iframe width="100%" height="100%"></iframe>
	</div>
	<!-- 竞争收集 收集编辑 -->
	<div class="info_collect_win" id="info_collect_edit_div" style="display:none;">
		<!--<div class="titlea">
            <div id="info_collect_edit_draggable" style='text-align:left;width:90%;display: inline-block'>竞争收集</div>
            <div class="titlec" id="info_collect_edit_div_close"></div>
        </div>-->
		<iframe width="100%" height="100%"></iframe>
	</div>
</body>
</html>
