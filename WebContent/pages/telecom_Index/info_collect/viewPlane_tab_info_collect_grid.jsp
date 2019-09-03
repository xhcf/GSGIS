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
		/*弹窗*/
		.layui-layer{background-color:rgb(237, 248, 255);}

		@media screen and (max-height: 1080px){
			.search{width:98%;margin:0px auto;left:0px;position:relative;top:0px;display:block;height:74px;}
			.tab_box{margin-top:5px;}
			.sub{width:100%;margin:0px auto;margin-top:10px;}
		}
		@media screen and (max-height: 768px){
			.search{width:98%;margin:0px auto;left:0px;position:relative;top:0px;display:block;height:74px;}
			.tab_box{margin-top:3px;}
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
	</style>
	<script type="text/javascript">
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
		var url4Query1 = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_info_collect_action.jsp"/>';
		var city_id_temp = '${param.city_id}';
		var bureau_id_temp = '${param.bureau_id}';
		var branch_type_temp = '${param.branch_type}';
		var user_level = '${sessionScope.UserInfo.LEVEL}';

		var layer_win_size = [850,380];

		$(function(){
			initCitySelect(user_level);
			citySelectCss(city_id_temp);

			initBureauSelect(user_level);
			bureauSelectCss(bureau_id_temp);

			var table_row_size = getTableRows();

			$("#tab_info_collect_grid_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});

			initBranchTypeSelect();
			branchTypeSelectCss(branch_type_temp);
			//initDateSelect();
		});
		function initBranchTypeSelect(){
			$("input[name='branch_type']").click(function(){
				var params = {};
				params.city_id1 = city_id_temp;
				params.bureau_id1 = bureau_id_temp;
				params.branch_type = $(this).val();
				branch_type_temp = $(this).val();
				$('#tab_info_collect_grid_level').datagrid('load',params);
			});
		}
		function branchTypeSelectCss(branch_type_temp){
			if(branch_type_temp=="")
				$("input[name='branch_type']").eq(0).attr("checked","checked");
			else
				$("input[name='branch_type'][value='"+branch_type_temp+"']").attr("checked","checked");
		}
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
						$('#tab_info_collect_grid_level').datagrid('resize');
						$('#tab_info_collect_grid_level').datagrid('options').queryParams = params;
						$('#tab_info_collect_grid_level').datagrid('reload');
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
						$('#tab_info_collect_grid_level').datagrid('resize');
						$('#tab_info_collect_grid_level').datagrid('options').queryParams = params;
						$('#tab_info_collect_grid_level').datagrid('reload');
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
			$.post(url4Query1,{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
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
			params.bureau_id = bureau_id_temp;
			params.branch_type = branch_type_temp;
			console.log(params);
		}

		function tabLoaded(){
			//$(".datagrid-view").css({"height":$(".sub_box").height()-90});
			//$("#tab_info_collect_grid_level").datagrid("resize");
		}
		function citySwitch(city_id){
			if(user_level>1)
				return;
			if(city_id =='999'){
				backToProvince();
				//window.parent.href = "<e:url value='/pages/telecom_Index/info_collect/viewPlane_tab_info_collect_province.jsp' />?branch_type=";
				return;
			}
			city_id_temp = city_id;
			citySelectCss(city_id);
			var params = {};
			params.city_id1 = city_id;
			params.bureau_id2 = '999';
			$('#tab_info_collect_grid_level').datagrid('load',params);
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
			$('#tab_info_collect_grid_level').datagrid('load',params);
		}

		//收集住户数
		function font_clickable_formatter1(value,rowData){
			if(value==0){
				return value;
			}
			if($.trim(rowData.GRID_NAME)=="小计"){
				return value;
			}else{
				if(rowData.GRID_ID==null)
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showDetail('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"','999');\">"+value+"</a>";
				else
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showDetail('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"','"+rowData.GRID_ID+"');\">"+value+"</a>";
			}
		}
		function showDetail(latn_id,bureau_no,branch_no,grid_id){
			if(grid_id=='')
				grid_id = '999';
			window.open("<e:url value='pages/telecom_Index/info_collect/viewPlane_tab_info_collect_detail.jsp' />?city_id="+latn_id+"&bureau_id="+bureau_no+"&branch_id="+branch_no+"&grid_id="+grid_id+"&branch_type="+branch_type_temp, "", "");
		}
		function font_clickable_formatter2(value,rowData){
			if(value>0 && $.trim(rowData.GRID_NAME)!='小计'){
				if(rowData.GRID_ID==null)
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showOneMonth('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"','');\">"+value+"</a>";
				else
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showOneMonth('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"','"+rowData.GRID_ID+"');\">"+value+"</a>";
			}
			return value;
		}
		//近一月到期
		function showOneMonth(city_id,bureau_no,branch_no,grid_id){
			window.open("<e:url value='pages/telecom_Index/info_collect/viewPlane_tab_info_collect_detail.jsp' />?city_id="+city_id+"&bureau_id="+bureau_no+"&branch_id="+branch_no+"&grid_id="+grid_id+"&month_flag=1", "", "");
			/*layer.open({
				type: 1,
				title: '近一月到期',
				area: layer_win_size,
				shade: 0,
				//offset: [50,pos.left-layer_win_size[0]],
				content: $("#month_list"),
				success: function(){
					$('#dg').datagrid({
						url:url4Query,
						pagination:true,
						rownumbers:true,
						fitColumns:true,
						queryParams: {
							 "eaction": "showOneMonth",
							 "city_id":city_id,
							 "bureau_no":bureau_no,
							 "branch_no":branch_no,
							 "grid_id":grid_id
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
							}}
						]],
						onLoadSuccess: function(){
							$('#dg').datagrid("resize");
						}
					});
				}
			});*/
		}
		function font_clickable_formatter3(value,rowData){
			if(value>0 && $.trim(rowData.GRID_NAME)!='小计'){
				if(rowData.GRID_ID==null)
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showThreeMonth('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"');\">"+value+"</a>";
				else
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:showThreeMonth('"+rowData.LATN_ID+"','"+rowData.BUREAU_NO+"','"+rowData.UNION_ORG_CODE+"','"+rowData.GRID_ID+"');\">"+value+"</a>";
			}
			return value;
		}
		function cellStyler(value,rowData){
			if($.trim(rowData.GRID_NAME)=='小计'){
				return 'background-color:#f1f2f2;color:#264f75;';
			}
		}
		//近两月到期
		function showThreeMonth(city_id,bureau_no,branch_no,grid_id){
			window.open("<e:url value='pages/telecom_Index/info_collect/viewPlane_tab_info_collect_detail.jsp' />?city_id="+city_id+"&bureau_id="+bureau_no+"&branch_id="+branch_no+"&grid_id="+grid_id+"&month_flag=2", "", "");
			/*layer.open({
				type: 1,
				title: '近两月到期',
				area: layer_win_size,
				shade: 0,
				//offset: [50,pos.left-layer_win_size[0]],
				content: $("#month_list"),
				success: function(){
					$('#dg').datagrid({
						url:url4Query,
						pagination:true,
						rownumbers:true,
						fitColumns:true,
						queryParams: {
							"eaction": "showTwoMonth",
							"city_id":city_id,
							"bureau_no":bureau_no,
							"branch_no":branch_no,
							"grid_id":grid_id
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
							}}
						]],
						onLoadSuccess: function(){
							$('#dg').datagrid("resize");
						}
					});
				}
			});*/
		}
		function name_shorter1(value,rowData){
			console.log(value.length);
			if(window.screen.height<=768){
				if(value.length>6)
					return "<span title=\""+value+"\">"+value.substr(0,6)+"...</span>";
			}else{
				if(value.length>15)
					return "<span title=\""+value+"\">"+value.substr(0,15)+"...</span>";
			}
			return value;
		}
		function name_shorter2(value,rowData){
			if(window.screen.height<=768){
				if(value.length>8)
					return "<span title=\""+value+"\">"+value.substr(0,8)+"...</span>";
			}else{
				if(value.length>15)
					return "<span title=\""+value+"\">"+value.substr(0,15)+"...</span>";
			}
			return value;
		}
		function name_shorter3(value,rowData){
			if(value==null){
				return '';
			}
			if(window.screen.height<=768){
				if(value.length>9)
					return "<span title=\""+value+"\">"+value.substr(0,9)+"...</span>";
			}else{
				if(value.length>15)
					return "<span title=\""+value+"\">"+value.substr(0,15)+"...</span>";
			}
			return value;

		}
		function newInfoEdit(user_level) {
			if(user_level==1){
				openWinInfoCollectEdit("", "", "", "", "null");
			}else if(user_level==2){
				openWinInfoCollectEdit("", "${param.city_id}", "null", "null", "null");
			}else if(user_level==4){
				//openWinInfoCollectEdit("", "${param.city_id}", "${param.bureau_id}", "${param.branch_id}", "null");
				openWinInfoCollectEditDiy("", "${param.city_id}", "${param.bureau_id}", "${param.branch_id}", "null");
			}else if(user_level==5){
				//openWinInfoCollectEdit("", "${param.city_id}", "${param.bureau_id}", "${param.branch_id}", "${param.grid_id}");
				openWinInfoCollectEditDiy("", "${param.city_id}", "${param.bureau_id}", "${param.branch_id}", "${param.grid_id}");
			}
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
				//offset: ['1px', '38px'],
				content: $("#info_collect_edit_div"),
				cancel: function (index) {
					layer.close(collect_edit_handler);
					$("#nav_marketing2").removeClass("active");
					return tmpx = '1';
				}
			});
		}
		function openWinInfoCollectEditDiy(add6_id, city_id, area_id, substation, grid_id){
			$("#info_collect_edit_div > iframe").attr("src", "<e:url value='/pages/telecom_Index/sub_grid/viewPlane_info_collect_edit_diy.jsp' />?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
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
					$("#nav_marketing2").removeClass("active");
					return tmpx = '1';
				}
			});
		}
		function closeWinInfoCollectionEdit(){
			layer.closeAll();
		}
	</script>
</head>
<body>
	<div class="sub_box" style="height:auto;width:100%;margin:0.3% auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0.3% auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:42px;inline-height:50px;text-align:center;"><h4>竞&nbsp;争&nbsp;信&nbsp;息&nbsp;收&nbsp;集&nbsp;统&nbsp;计</h4></div>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '1'}">
				<button onclick="javascript:newInfoEdit(1);" class="collect_btn">收集</button>
			</e:if>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '2'}">
				<button onclick="javascript:newInfoEdit(2);" class="collect_btn">收集</button>
			</e:if>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '4'}">
				<button onclick="javascript:newInfoEdit(4);" class="collect_btn">收集</button>
			</e:if>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '5'}">
				<button onclick="javascript:newInfoEdit(5);" class="collect_btn">收集</button>
			</e:if>
			<div class="tab_box">
				<div class="sub_">
					<div class="search" style="height:auto; margin-bottom:3px;">
						<!--<div style="padding-left:18px;">
							开始时间：<input id="beginDate" type="text" style="color:#ffffff; width:150px" />&nbsp;&nbsp;&nbsp;
							结束时间：<input id="endDate" type="text" style="color:#ffffff; width:150px" />
						</div>-->
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
					<div class="sub_b" style="border:0px;width:98%;margin:0px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_市级概况-->
						<c:datagrid
								url="pages/telecom_Index/common/sql/viewPlane_tab_info_collect_action.jsp?eaction=grid&city_id=${param.city_id}&bureau_id=${param.bureau_id}&branch_id=${param.branch_id}&grid_id=${param.grid_id}"
								id="tab_info_collect_grid_level" download='' nowrap="true"
								border="true" fitColumns="true" rownumbers="true" style="width:100%;height:auto;"  data-options="scrollbarSize:0"
								onLoadSuccess="tabLoaded" mergerFields="BUREAU_NAME,BRANCH_NAME" onBeforeLoad="tabParam"
								>
							<thead>
								<tr>
									<th field="BUREAU_NAME" width="8%" align="center" halign="center" formatter="name_shorter1">区县/分局</th>
									<th field="BRANCH_NAME" width="10%" align="center" halign="center" formatter="name_shorter2">支局</th>
									<th field="GRID_NAME" width="12%" align="center" halign="center" formatter="name_shorter3" styler="cellStyler">网格</th>
									<th field="COLLECT_NUM" width="14%" align="center" halign="center" formatter="font_clickable_formatter1" styler="cellStyler">收集住户数</th>
									<th field="ZHU_HU_COUNT" width="14%" align="center" halign="center"  styler="cellStyler">住户数</th>
									<th field="COLLECT_V" width="14%" align="center" halign="center"  styler="cellStyler">收集占比</th>
									<th field="DQ_1_COUNT" width="14%" align="center" halign="center" formatter="font_clickable_formatter2" styler="cellStyler">近一月到期</th>
									<th field="DQ_2_COUNT" width="14%" align="center" halign="center" formatter="font_clickable_formatter3" styler="cellStyler">近两月到期</th>
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

	<!-- 近一月到期、近两月到期列表 -->
	<div id="month_list">
		<table id="dg"></table>
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