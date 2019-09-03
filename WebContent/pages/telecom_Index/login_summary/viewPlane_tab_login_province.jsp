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
  <title>GIS营销系统使用情况统计</title>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
 	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_tab_village.css?version=1.0"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/pages/telecom_Index/common/css/datagid_reset.css?version=1.0"/>' rel="stylesheet" type="text/css" />
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
			.tab_box{margin-top:18px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.tab_box{margin-top:13px;}
		}
		.sub_b{width:100%;}
		body{background:rgb(237, 248, 255);}
	</style>
	<script type="text/javascript">
		//var city_id_temp = global_current_city_id;

		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var begin = '${param.begin}';
		console.log("prov:"+begin);
		if(begin=="")
			begin = '${initTime}';
		var end = '${param.end}';
		console.log("prov:"+end);
		if(end=="")
			end = '${initTime}';
		var user_level = '${sessionScope.UserInfo.LEVEL}';
		var user_level = '${sessionScope.UserInfo.LEVEL}';
		$(function(){
			var table_row_size = getTableRows();
			console.log(table_row_size);

			$("#tab_login_province_level").datagrid({
				pageSize : table_row_size[0],
				pageList : table_row_size
			});

			$("#beginDate").datebox({
				onSelect : function(date){
					var begin_tmp = $('#beginDate').datebox('getValue').replace(/-/g, "");
					var end_tmp = $('#endDate').datebox('getValue').replace(/-/g, "");
					if(begin_tmp>end_tmp){
						layer.msg("开始日期不能大于结束日期");
						return false;
					}
					else{
						var params = new Object();
						params.dateBegin = $('#beginDate').datebox('getValue');
						begin = $('#beginDate').datebox('getValue');
						params.dateEnd = $('#endDate').datebox('getValue');
						end = $('#endDate').datebox('getValue');
						$('#tab_login_province_level').datagrid('resize');
						$('#tab_login_province_level').datagrid('options').queryParams = params;
						$('#tab_login_province_level').datagrid('reload');
					}
				}
			});
			$("#beginDate").datebox("setValue",begin);
			$("#endDate").datebox({
				onSelect : function(date){
					var begin_tmp = $('#beginDate').datebox('getValue').replace(/-/g, "");
					var end_tmp = $('#endDate').datebox('getValue').replace(/-/g, "");
					if(begin_tmp>end_tmp){
						layer.msg("结束日期不能小于开始日期");
						return false;
					}
					else{
						var params = new Object();
						params.dateBegin = $('#beginDate').datebox('getValue');
						begin = $('#beginDate').datebox('getValue');
						params.dateEnd = $('#endDate').datebox('getValue');
						end = $('#endDate').datebox('getValue');
						$('#tab_login_province_level').datagrid('resize');
						$('#tab_login_province_level').datagrid('options').queryParams = params;
						$('#tab_login_province_level').datagrid('reload');
					}
				}
			});
			$("#endDate").datebox("setValue",end);
		});
		function viewRank(){
			load_list_view();
		}
		function viewVillageDraw(){
			load_list_village(user_level);
		}
		function tabLoaded(){
			//$("#tab_login_province_level").datagrid("resize");
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
			if(rowData.LATN_ID!='999')
				return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:cityToBureau("+rowData.LATN_ID+");\">"+value+"</a>";
			return value;
		}
		function cityToBureau(city_id){
			window.location.href = "<e:url value='/pages/telecom_Index/login_summary/viewPlane_tab_login_grid.jsp' />?city_id="+city_id+"&bureau_id=999"+"&begin="+begin+"&end="+end;
		}
	</script>
</head>
<body>
	<div class="sub_box" style="height:auto;width:100%;margin:0.3% auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0.3% auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:36px;inline-height:36px;text-align:center;"><h4>G&nbsp;I&nbsp;S&nbsp;营&nbsp;销&nbsp;系&nbsp;统&nbsp;使&nbsp;用&nbsp;情&nbsp;况&nbsp;统&nbsp;计</h4></div>
			<div class="tab_box">
				<div class="sub_">
					<div class="search" style="height:auto;">
						<div style="padding-left:18px;">
							开始时间：<input id="beginDate" type="text" style="color:#ffffff; width:150px" />&nbsp;&nbsp;&nbsp;
							结束时间：<input id="endDate" type="text" style="color:#ffffff; width:150px" />
						</div>
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td width="50"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp公&nbsp司&nbsp:</div></td>
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
						</table>
					</div>
					<!--<div class="huizong">
						<div style="width: 4px;height: 20px;background-color: #109afb;display: inline-block;position: absolute;top: 15px;left: 20px;"></div><div style="display: inline-block;margin-left: 28px">汇总：</div><span>支局</span><span id="total" style="color:#ff8a00 "></span><span>个, </span><span>城市</span><span id="city" style="color:#ff8a00 "></span><span>个, </span><span> 农村</span><span id="notcity" style="color:#ff8a00 "></span><span>个</span>
					</div>-->
					<div class="sub_b" style="border:0px;width:97.5%;margin:15px auto;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_省级概况-->
							<c:datagrid
									url="pages/telecom_Index/common/sql/viewPlane_tab_login_action.jsp?eaction=used_summary&acct_day=${initTime}"
									id="tab_login_province_level" download='' nowrap="true" pagination="false"
									border="true" fitColumns="true" rownumbers="false" style="width:100%;"  data-options="scrollbarSize:0"
									onLoadSuccess="tabLoaded" mergerFields="LATN_NAME"
									>
								<thead>
								<tr>
									<th field="LATN_NAME" width="20%" align="center">分公司</th>
									<th field="LOGIN_NUM" width="20%" align="center">使用人次</th>
									<th field="LOGIN_USER_NUM" width="20%" align="center">使用用户数</th>
									<th field="USER_ALL" width="20%" align="center">用户数</th>
									<th field="USED_PERCENT" width="20%" align="center">使用用户占比</th>
								</tr>
								</thead>
							</c:datagrid>
						<!--</div>-->
					</div>
					<div style="border:0px;width:97.5%;margin:15px auto;">说明：仅统计支局和网格用户的使用情况。</div>
				</div>
			</div>
		</div>
	</div>
	</body>
</html>
