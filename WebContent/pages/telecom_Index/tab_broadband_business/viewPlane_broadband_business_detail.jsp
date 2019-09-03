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
	select DISTINCT grid_id,grid_name,'网格列表' c from GIS_DATA.DB_CDE_GRID t WHERE UNION_ORG_CODE = '${param.branch_id}' AND branch_type = 'a1' AND grid_status = 1
</e:q4l>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <title>百户小区宽带营销清单</title>
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
		.bureau_select,.branch_select,.grid_select{width:28%;display:inline-block;}
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
		.sub_box{width:100%;height:100%;background:#EDF8FF;}
	</style>
	<script type="text/javascript">
		var city_id_temp = '${param.city_id}';
		var bureau_id_temp = '${param.bureau_id}';
		var branch_id_temp = '${param.branch_id}';
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
				params.branch_id1 = branch_id_temp;
				params.grid_id1 = grid_id_temp;
				params.text = text_str_temp;
				$('#broadbank_business_village_level').datagrid('load',params);
			});

			//下拉菜单响应事件
			$(".bureau_select").change(function(){bureauSwitch();});
			$(".branch_select").change(function(){branchSwitch();});
			$(".grid_select").change(function(){gridSwitch();});

			//返回地图模式
			/*$("#nav_hidetiled").click(function(){
				load_map_view();
			});*/
			var table_row_size = getTableRows1();
			console.log(table_row_size);

			$("#broadbank_business_village_level").datagrid({
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
					$(".branch_select").append("<option value='"+branch_item.UNION_ORG_CODE+"'>"+branch_item.BRANCH_NAME+"</option>");
				}
			});
		}
		function changeGridSelect(){
			$.post("<e:url value='/pages/telecom_Index/common/sql/viewPlane_broadband_business_action.jsp' />",{"eaction":"getGridByBranchId","branch_id":branch_id_temp},function(data){
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
			//$("#broadbank_business_village_level").datagrid("resize");
		}
		function name_shorter1(value,rowData){
			if(window.screen.height<=768){
				if(value.length>8)
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
			if(value==null)
				return;
			if(window.screen.height<=768){
				if(value.length>16)
					return "<span title=\""+value+"\">"+value.substr(0,16)+"...</span>";
			}else{
				if(value.length>28)
					return "<span title=\""+value+"\">"+value.substr(0,28)+"...</span>";
			}
			return value;
		}
		function name_hide(value,rowData){
			if(value==null)
				return;
			if(value.length<11){
				var acc_nbr = "";
				for(var i= 0,l=value.length;i<l;i++){
					acc_nbr += "*";
				}
				return acc_nbr;
			}
			return value.substr(0,4)+"*****"+value.substr(-2);
		}

		//2018.10.22 号码脱敏
		function phoneHide(value,rowData){
			if(value==null)
				return;
			var acc_nbr = value.substr(0,3);
			for(var i= 0,l=value.length-5;i<l;i++){
				acc_nbr += "*";
			}
			return acc_nbr+value.substr(-2);
		}
		function font_important_formatter(value,rowData){
			return "<span style=\"color:#FE7A23;\">"+value+"</span>";
		}
		function setQueryKeywords(){
			text_str_temp = $.trim($("#query_text").val());
		}
		function citySwitch(city_id){
			if(user_level>1)
				return;
			if(city_id =='999'){
				window.location.href = "<e:url value='/pages/telecom_Index/tab_broadband_business/viewPlane_broadband_business_province.jsp' />";
				return;
			}
			setQueryKeywords();
			city_id_temp = city_id;
			citySelectCss(city_id_temp);
			//load_list_village(2,city_id);//取消页面跳转，表格数据变化即可
			var params = {};
			params.city_id1 = city_id_temp;
			params.bureau_id1 = '999';
			params.branch_id1 = '999';
			params.grid_id1 = '999';
			params.text = text_str_temp;
			$('#broadbank_business_village_level').datagrid('load',params);
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
			params.text = text_str_temp;
			$('#broadbank_business_village_level').datagrid('load',params);

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
			params.text = text_str_temp;
			$('#broadbank_business_village_level').datagrid('load',params);

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
			$('#broadbank_business_village_level').datagrid('load',params);
		}
	</script>
</head>
<body>
	<div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;display:none;">
		<ul id="tools">
			<li id="nav_hidetiled" ><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1' || sessionScope.UserInfo.LEVEL eq '2'}">
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
			</e:if>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
				<li id="nav_village2" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="village" style="cursor:not-allowed;">小区</a></li>
				<li id="nav_standard2" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="standard" style="cursor:not-allowed;">楼宇</a></li>
				<li id="nav_marketing2" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="marketing" style="cursor:not-allowed;">营销</a></li>
				<li id="nav_info_collect" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="info_collect" style="cursor:not-allowed;">收集</a></li>
			</e:if>
		</ul>
	</div>
	<div class="sub_box" style="margin:0 auto;position: absolute;height:100%;">
		<div style="height:98%;width:100%;margin:0 auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:36px;inline-height:36px;text-align:center;"><h4>百&nbsp;户&nbsp;小&nbsp;区&nbsp;宽&nbsp;带&nbsp;营&nbsp;销&nbsp;清&nbsp;单</h4></div>
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
					<div class="sub_b" style="border:0px;width:97.5%;margin:15px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_市级概况-->
							<c:datagrid
									url="pages/telecom_Index/common/sql/viewPlane_broadband_business_action.jsp?eaction=ying_xiao&city_id=${param.city_id}&bureau_id=${param.bureau_id}&branch_id=${param.branch_id}&grid_id=${param.grid_id}"
									id="broadbank_business_village_level" download='' nowrap="true"
									border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;" data-options="scrollbarSize:0"
									mergerFields="LATN_NAME,BUREAU_NAME,BRANCH_NAME,GRID_NAME,VILLAGE_NAME"
									>
								<thead>
								<tr>
									<th field="LATN_NAME" width="6%" align="center">分公司</th>
									<th field="BUREAU_NAME" width="13%" align="center">区县/分局</th>
									<th field="BRANCH_NAME" width="10%" halign="center" align="center" formatter="name_shorter1">支局名称</th>
									<th field="GRID_NAME" width="10%" halign="center" align="center" formatter="name_shorter2">网格名称</th>
									<th field="VILLAGE_NAME" width="18%" halign="center" align="left" formatter="name_shorter3">小区名称</th>
									<th field="JR_NBR" width="8%" align="center" formatter="name_hide">接入号</th>
									<th field="USER_CONTACT_NBR" width="8%" align="center" formatter="phoneHide">联系电话</th>
									<th field="COMP_FLAG" width="8%" align="center">是否融合</th>
									<th field="ACC_NBR" width="8%" align="center">主卡号码</th>
									<th field="EXP_DATE" width="11%" align="center" formatter="font_important_formatter">到期时间</th>
								</tr>
								</thead>
							</c:datagrid>
						<!--</div>-->
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
</body>
</html>