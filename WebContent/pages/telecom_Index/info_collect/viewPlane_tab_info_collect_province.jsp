<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="yesterday">
	select to_char(sysdate-1,'yyyymmdd') val,to_char(sysdate-1,'yyyy-mm-dd') val1 from dual
</e:q4o>
<e:set var="initTime">${yesterday.VAL1}</e:set>
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
	<c:resources type="easyui,app" style="b"/>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/datagrid_mergeCell.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_tab_village.css?version=1.0"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/pages/telecom_Index/common/css/datagid_reset.css?version=1.3"/>' rel="stylesheet" type="text/css" />
	<style>
		#tools{height:95%;}
		#query_div{width:120px;height:47px;background:#0f2c92;padding:0;position:absolute;display:none;}
		#query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
		.ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
		#query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
		.datagrid-pager.pagination table tbody tr td span{color:#264f75;}
		.pagination .pagination-num {color:#264f75;}
		@media screen and (max-height: 1080px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.backup{right:1.4%;top:2.5%;}
			.tab_box{margin-top:5px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.tab_box{margin-top:3px;}
		}
		body{background:rgb(237, 248, 255);}
		.layui-layer{background-color:rgb(237, 248, 255);}
		.sub_box h4{top:10px;}
		.collect_btn {
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
			position:absolute;right:17px;top:9px;
		}
		.collect_info .layui-layer-setwin{
			top: 10px;
		}
	</style>
	<script type="text/javascript">
		//var city_id_temp = global_current_city_id;
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
		var url4Query1 = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_info_collect_action.jsp"/>';
		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var branch_type_temp = '';

		var layer_win_size = [850,370];

		$(function(){
			var table_row_size = getTableRows();
			console.log(table_row_size);

			$("#tab_info_collect_province_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});

			initBranchTypeSelect();
			branchTypeSelectCss(branch_type_temp);
		});

		function initBranchTypeSelect(){
			$("input[name='branch_type']").click(function(){
				var params = {};
				params.branch_type = $(this).val();
				branch_type_temp = $(this).val();
				$('#tab_info_collect_province_level').datagrid('load',params);
			});
		}
		function branchTypeSelectCss(branch_type_temp){
			if(branch_type_temp=="")
			$("input[name='branch_type']").eq(0).attr("checked","checked");
		}

		function tabLoaded(){
			//$("#tab_info_collect_province_level").datagrid("resize");
			//$(".datagrid-view").css({"height":$(".sub_box").height()-123});
		}

		function tabStyle(index,row){
			if (index==0){
				return 'background-color:#FFE799;'; // return inline style
				// the function can return predefined css class and inline style
				// return {class:'r1', style:{'color:#fff'}};
			}
		}
		function font_important_formatter(value,rowData){
			return "<span style=\"color:#FE7A23;\">"+value+"</span>";
		}
		function font_clickable_formatter(value,rowData){
			if(value==0)
				return value;
			if(rowData.LATN_NAME=="全省")
				return value;
			return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showSubNoCollect("+rowData.LATN_ID+");\">"+value+"</a>";
		}
		function cityToBureau(city_id){
			cityToGrid(city_id,branch_type_temp);
		}
		function newInfoEdit(user_level){
			if(user_level==1)
				openWinInfoCollectEdit("", "", "", "", "null");
		}
		function openWinInfoCollectEdit(add6_id, city_id, area_id, substation, grid_id){
			$("#info_collect_edit_div > iframe").attr("src", "<e:url value='/pages/telecom_Index/sub_grid/viewPlane_info_collect_edit.jsp' />?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
			//$("#info_collect_edit_div").show();
			collect_edit_handler = layer.open({
				title: ['竞争收集', 'line-height:32px;text-size:30px;height:32px;'],
				//title:false,
				type: 1,
				shade: 0,
				area: ['710px', '485px'],
				skin: 'collect_info',
				//offset: ['1px', '38px'],
				content: $("#info_collect_edit_div"),
				cancel: function (index) {
					layer.close(collect_edit_handler);
					$("#nav_marketing2").removeClass("active");
					return tmpx = '1';
				}
			});
		}
		function closeWinInfoCollectionEdit(){
			layer.closeAll();
		}
		function showSubNoCollect(latn_id){
			layer.open({
				type: 1,
				title: '无信息收集的支局',
				area: layer_win_size,
				shade: 0,
				//offset: [50,pos.left-layer_win_size[0]],
				content: $("#sub_no_collect_list"),
				success: function(){
					$('#dg').datagrid({
						url:url4Query1,
						pagination:true,
						rownumbers:true,
						fitColumns:true,
						queryParams: {
							"eaction": "showSubNoCollect",
							"city_id":latn_id,
							"branch_type":branch_type_temp
						},
						columns:[[
							{field:'LATN_NAME',title:'分公司',halign:"center",align:'center',width:"22%"},
							{field:'BUREAU_NAME',title:'区县',halign:"center",align:'center',width:"25%"},
							{field:'BRANCH_NAME',title:'支局名称',halign:"center",align:'left',width:"55%"}
						]],
						onLoadSuccess: function(data){
							$('#dg').datagrid("resize");
							$("#dg").datagrid("autoMergeCells", ['LATN_NAME', 'BUREAU_NAME']);
						}
					});
				}
			});
		}
	</script>
</head>
<body>
	<div class="sub_box" style="height:auto;width:100%;margin:0 auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0 auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:36px;inline-height:36px;text-align:center;"><h4>竞&nbsp;争&nbsp;信&nbsp;息&nbsp;收&nbsp;集&nbsp;统&nbsp;计</h4></div>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1'}">
				<button onclick="javascript:newInfoEdit(1);" class="collect_btn">收集</button>
			</e:if>
			<div class="tab_box">
				<div class="sub_">
					<div class="search" style="height:auto;">
						<!--<div style="padding-left:18px;">
							开始时间：<input id="beginDate" type="text" style="color:#ffffff; width:150px" />&nbsp;&nbsp;&nbsp;
							结束时间：<input id="endDate" type="text" style="color:#ffffff; width:150px" />
						</div>-->
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td width="50"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp;公&nbsp;司&nbsp;&nbsp;:</div></td>
								<td class="area_select">
									<a href="javascript:void(0)" class="selected">全省</a>
									<a href="javascript:void(0)" onclick="cityToBureau(931)">兰州</a>
									<a href="javascript:void(0)" onclick="cityToBureau(938)">天水</a>
									<a href="javascript:void(0)" onclick="cityToBureau(943)">白银</a>
									<a href="javascript:void(0)" onclick="cityToBureau(937)">酒泉</a>
									<a href="javascript:void(0)" onclick="cityToBureau(936)">张掖</a>
									<a href="javascript:void(0)" onclick="cityToBureau(935)">武威</a>
									<a href="javascript:void(0)" onclick="cityToBureau(945)">金昌</a>
									<a href="javascript:void(0)" onclick="cityToBureau(947)">嘉峪关</a>
									<a href="javascript:void(0)" onclick="cityToBureau(932)">定西</a>
									<a href="javascript:void(0)" onclick="cityToBureau(933)">平凉</a>
									<a href="javascript:void(0)" onclick="cityToBureau(934)">庆阳</a>
									<a href="javascript:void(0)" onclick="cityToBureau(939)">陇南</a>
									<a href="javascript:void(0)" onclick="cityToBureau(941)">甘南</a>
									<a href="javascript:void(0)" onclick="cityToBureau(930)">临夏</a>
								</td>
							</tr>
							<tr>
								<td width="50"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;支局类型:</div></td>
								<td style="padding-left:8px;">
									<input type="radio" name="branch_type" value="" />全部&nbsp;&nbsp;
									<input type="radio" name="branch_type" value="a1" />城市&nbsp;&nbsp;
									<input type="radio" name="branch_type" value="b1" />农村
								</td>
							</tr>
						</table>
					</div>
					<!--<div class="huizong">
						<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div><div style="display: inline-block;margin-left: 28px">汇总：</div><span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span><span>个</span>
					</div>-->
					<div class="sub_b" style="border:0px;width:97.5%;margin:2px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_省级概况-->
							<c:datagrid
									url="pages/telecom_Index/common/sql/viewPlane_tab_info_collect_action.jsp?eaction=province&acct_day=${initTime}"
									id="tab_info_collect_province_level" download='' nowrap="true" pagination="false"
									border="true" fitColumns="true" rownumbers="false" style="width:100%;"  data-options="scrollbarSize:0"
									onLoadSuccess="tabLoaded" rowStyler="tabStyle" mergerFields="LATN_NAME"
									>
								<thead>
								<tr>
									<th field="LATN_NAME" width="10%" align="center">分公司</th>
									<th field="COLLECT_NUM" width="15%" align="center">收集住户数</th>
									<th field="ZHU_HU_COUNT" width="15%" align="center">住户数</th>
									<th field="COLLECT_V" width="15%" align="center">收集占比</th>
									<th field="DQ_1_COUNT" width="15%" align="center">近一月到期</th>
									<th field="DQ_2_COUNT" width="15%" align="center">近两月到期</th>
									<th field="NO_BRANCH_NUM" width="15%" align="center" formatter="font_clickable_formatter">无收集支局数</th>
								</tr>
								</thead>
							</c:datagrid>
						<!--</div>-->
					</div>
					<div style="border:0px;width:97.5%;margin:13px auto;">说明：
						收集用户数，指收集了异网信息的住户数;
						近一月到期，指收集产品的到期时间是截至当月月底的到期信息；
						近二月到期，指收集产品的到期时间是截至下月月底的到期信息。
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 无信息收集的支局列表 -->
	<div id="sub_no_collect_list">
		<table id="dg"></table>
	</div>
	</body>

	<!-- 竞争收集 收集编辑 -->
	<div class="info_collect_win" id="info_collect_edit_div" style="display:none;">
		<!--<div class="titlea">
			<div id="info_collect_edit_draggable" style='text-align:left;width:90%;display: inline-block'>竞争收集</div>
			<div class="titlec" id="info_collect_edit_div_close"></div>
		</div>-->
		<iframe width="100%" height="100%"></iframe>
	</div>
</html>
