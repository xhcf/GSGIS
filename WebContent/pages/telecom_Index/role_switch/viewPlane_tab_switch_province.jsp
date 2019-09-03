<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="yesterday">
	select to_char(sysdate-1,'yyyymmdd') val,to_char(sysdate-1,'yyyy-mm-dd') val1 from dual
</e:q4o>
<e:set var="initTime">${yesterday.VAL1}</e:set>
<e:q4l var="city_list">
	SELECT 'city_' || area_no city_element FROM cmcode_area ORDER BY ord ASC
</e:q4l>
<e:q4l var="bureau_list">
	SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM gis_data.db_cde_grid
	WHERE 1=1
	<e:if condition="${!empty param.city_id}">
		and latn_id = '${param.city_id}'
	</e:if>
	and branch_type in ('a1','b1') order by REGION_ORDER_NUM
</e:q4l>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />

 	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js?version=1.2"/>' charset="utf-8"></script>
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
		.sub_box h4{top:5px;}
		.search tr td:last-child{border:0px;}
		bureau_select a {display: block;
			float: left;
			margin-right: 20px;width:auto;}
		.bureau_select a.selected {background-color: #ff8a00;
			width: auto;
			height: auto;
			text-align: center;
			border-radius: 4px;
			color: #fff;}
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
		var city_id_temp = "999";
		var bureau_id_temp = "999";

		var citys = new Array();

		$(function(){
			var table_row_size = [10,20,30];

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


			if('${param.city_id}'!=''){
				initBureauSelect(user_level);
				bureauSelectCss(bureau_id_temp);
				$(".bureau_select").parent().parent().show();
			}else{
				$(".bureau_select").parent().parent().hide();
			}

			var citys_json = ${e:java2json(city_list.list)};
			for(var i = 0,l = citys_json.length;i<l;i++){
				var city_obj = citys_json[i];
				citys[i] = city_obj['city_element'];
			}

			if(user_level>1){
				$("#area_tabs_change a[id^='city_']").removeClass("selected");
				$("#city_"+'${sessionScope.UserInfo.AREA_NO}').addClass("selected");
				$("#area_tabs_change a[id^='city_']").css({"cursor":"default"});
				city_id_temp = '${sessionScope.UserInfo.AREA_NO}';
			}

			if(user_level>2){
				var params = {};
				params.latn_id =$("#city_id").val();
				params.bureau_id = '${sessionScope.UserInfo.CITY_NO}';
				bureau_id_temp = params.bureau_id;
				$('#tab_login_province_level').datagrid('resize');
				$('#tab_login_province_level').datagrid('options').queryParams = params;
				$('#tab_login_province_level').datagrid('reload');
			}
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
		//分公司切换
		function cityToBureau(city_id){
			if(user_level>1)
				return;
			//window.location.href = "<e:url value='/pages/telecom_Index/role_switch/viewPlane_tab_switch_grid.jsp' />?city_id="+city_id+"&bureau_id=999"+"&begin="+begin+"&end="+end;
			//保存分公司编码
			$("#city_id").val(city_id);
			city_id_temp = city_id;
			var params = new Object();
			params.latn_id =city_id;
			$('#tab_login_province_level').datagrid('resize');
			$('#tab_login_province_level').datagrid('options').queryParams = params;
			$('#tab_login_province_level').datagrid('reload');

			$("#name_mask").val("");

			$("#area_tabs_change a[id^='city_']").removeClass("selected");
			$("#city_"+city_id).addClass("selected");

			 if(city_id_temp=='999'){
				$(".bureau_select").empty();
				$(".bureau_select").parent().parent().hide();
			 }else{
				changeBureauSelect();
				$(".bureau_select").parent().parent().show();
			 }

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
				bureauSelectCss(${sessionScope.UserInfo.CITY_NO});
			}
		}
		function bureauSelectCss(bureau_id){
			bureau_id_temp = bureau_id;
			$(".bureau"+bureau_id_temp).addClass("selected");
			$(".bureau"+bureau_id_temp).siblings().removeClass("selected");
		}
		function changeBureauSelect(){
			var url4Query = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_login_action.jsp"/>';
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
		function bureauSwitch(bureau_id){
			if(user_level>2)
				return;
			bureau_id_temp = bureau_id;
			bureauSelectCss(bureau_id_temp);
			var params = {};
			params.latn_id =$("#city_id").val();
			params.bureau_id = bureau_id_temp;
			$('#tab_login_province_level').datagrid('resize');
			$('#tab_login_province_level').datagrid('options').queryParams = params;
			$('#tab_login_province_level').datagrid('reload');
		}

		//查询按钮按下事件
		function doSearch(){
			var params = new Object();
			//分公司编码
			params.latn_id =$("#city_id").val();
			params.bureau_id = bureau_id_temp;
			//名称查询
			params.name_mask =$("#name_mask").val();

			$('#tab_login_province_level').datagrid('resize');
			$('#tab_login_province_level').datagrid('options').queryParams = params;
			$('#tab_login_province_level').datagrid('reload');
		}

		//支局名称 连接
		function font_branch_clickable_formatter(value,rowData){
			if(rowData.LATN_ID!='999'){
					if(rowData.SUB_COUNT>0)
						return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:moveToUser(0,'"+rowData.UNION_ORG_CODE+"');\">"+value+"</a>";
					else
						return "<span title='该组织机构下没有用户' style='font-size:12px;'>"+value+"</span>";
			}
			return value;
		}

		//网格名称 连接
		function font_grid_clickable_formatter(value,rowData){
			if(value==null ||value == 'null' || value =='--'){
				return "";
			}
			if(rowData.LATN_ID!='999'){
				if(rowData.GRID_COUNT>0)
					return "<a style=\"text-decoration: underline;color: #00f;cursor: pointer;\" href=\"javascript:moveToUser(1,'"+rowData.GRID_UNION_ORG_CODE+"');\">"+value+"</a>";
				else
					return "<span title='该组织机构下没有用户' style='font-size:12px;'>"+value+"</span>";
			}
			return value;
		}

		//跳转验证用户
		function moveToUser(type,id){
			var info = {};
			info.type = type;
			info.id = id;

		 	var postUrl="<e:url value='pages/telecom_Index/common/sql/viewPlane_tab_role_switch_action.jsp'/>?eaction=getUserInfo";
			$.post(postUrl,info,function(data){
				if(data!=null && data !=''){
					if(data.LOGIN_ID !=null || data.LOGIN_ID != '' || data.LOGIN_ID !='null' ){
						 window.parent.location.href = "<e:url value='/login.e?'/>user="+data.LOGIN_ID+"&pwd="+encodeURIComponent(data.PASSWORD)+"";
						 //window.open("<e:url value='/login.e?'/>user="+data.LOGIN_ID+"&pwd="+data.PASSWORD+"&flag=1","","");

// 						 var index =layer.open({
// 				                type: 2,
// 				                title:'甘肃电信GIS沙盘平台',
// 				                area: ['100%', '100%'],//设置弹出框大小(宽，高)
// 				                closeBtn: 1,
// 								skin:'layui-layer-lan',
// 								maxmin:true,
// 				                anim: 4,//动画效果
// 				                shadeClose: true, //开启遮罩关闭
// 				                content:"<e:url value='/login.e?'/>user="+data.LOGIN_ID+"&pwd="+data.PASSWORD
// 				            });
// 				            layer.full(index);
					}
				}else{
					if(type=='0'){
						layer.msg("该支局下没有可登录的用户");
					}else if(type=='1'){
						layer.msg("该网格下没有可登录的用户");
					}
				}
			},"json");
		}
	</script>
</head>
<body>
    <input type= "hidden" id = "city_id"  name = "city_id" value = "">
	<div class="sub_box" style="height:auto;width:100%;margin:0.3% auto;position: absolute;">
		<div style="height:98%;width:100%;margin:0.3% auto;position: absolute;" id="tab_div">
			<div style="width:100%;height:17px;inline-height:17px;text-align:center;"><h4>角色切换</h4></div>
			<div class="tab_box">
				<div class="sub_">
					<div class="search" style="height:auto;">
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td width="50"><div style="margin-left: 1px">&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp公&nbsp司&nbsp:</div></td>
								<td class="area_select">
									<div id= "area_tabs_change">
										<a href="javascript:void(0)" onclick="cityToBureau('999')" class="selected" id ="city_999">全省</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(931)" id ="city_931">兰州</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(938)" id ="city_938">天水</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(943)" id ="city_943">白银</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(937)" id ="city_937">酒泉</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(936)" id ="city_936">张掖</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(935)" id ="city_935">武威</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(945)" id ="city_945">金昌</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(947)" id ="city_947">嘉峪关</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(932)" id ="city_932">定西</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(933)" id ="city_933">平凉</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(934)" id ="city_934">庆阳</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(939)" id ="city_939">陇南</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(941)" id ="city_941">甘南</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" onclick="cityToBureau(930)" id ="city_930">临夏</a>&nbsp;&nbsp;
									</div>
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

					<div style="width: 95%;height: 30px;display: inline-block;position: relative;top: 7px;left: 30px;">
						查询条件：<input id="name_mask" name="name_mask" type="text" style="width:78%;align:left;background-color: #FFFFFF;" value="" placeholder="请输入支局或网格名称查询"/>&nbsp;&nbsp;
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSearch()"> <i class="fa fa-search"></i>查询</a>
					</div>

					<div class="sub_b" style="border:0px;width:97.5%;margin:15px auto;position: relative;top: 0px;">
						<!--<div class="t_body" id="scroll_target"> download 城市支局小区信息统计_省级概况-->
							<c:datagrid
									url="pages/telecom_Index/common/sql/viewPlane_tab_role_switch_action.jsp?eaction=data_list"
									id="tab_login_province_level" download='' nowrap="true" pagination="true"
									border="true" fitColumns="true" rownumbers="false" style="width:100%;"
									>

								<thead>
								<tr>
 									<!--<th field="LATN_ID" width="25%" align="center">分公司编码</th> -->
									<th field="LATN_NAME" width="11%" align="center">分公司名称</th>
									<!--<th field="BUREAU_NO" width="25%" align="center">县局编码</th> -->
									<th field="BUREAU_NAME" width="20%" align="center">县局名称</th>
 									<!--<th field="UNION_ORG_CODE" width="25%" align="center">支局编码</th> -->
									<th field="BRANCH_NAME" width="30%" align="center" formatter="font_branch_clickable_formatter" >支局名称</th>
									<!--<th field="GRID_UNION_ORG_CODE" width="25%" align="center">网格编码</th>-->
									<th field="GRID_NAME" width="40%" align="center" formatter="font_grid_clickable_formatter">网格名称</th>
								</tr>
								</thead>

							</c:datagrid>
						<!--</div>-->
					</div>

					<div style="border:0px;width:97.5%;margin:15px auto;display:none;">说明：仅统计支局和网格用户的使用情况。</div>
				</div>
			</div>
		</div>
	</div>

	</body>
</html>
