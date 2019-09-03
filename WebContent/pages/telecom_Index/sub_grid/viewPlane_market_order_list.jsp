<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4l var="scene_list">
	select t.scenes_type_cd id,t.scenes_type_desc text from gis_data.TB_DIC_GIS_SCENES_TYPE t where t.scenes_type_cd in('04','21','10','11')	order by t.priority asc
</e:q4l>
<html>
<head>
	<title>营销清单</title>
	<meta charset="utf-8">
	<meta name="author" content="jasmine"><!-- 定义作者-->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.5"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.6"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
	<style type="text/css">
		body{background-color:#fff;}
		#yx_detail_list_bigdata em{
			float: left;
	    padding-left: 3px;
	    width: 12px;
	    height: 12px;
	    line-height: 12px;
	    color: #fff;
	    position: relative;
	    top: 4px;
	    font-family: "Arial";
	    font-weight: normal;
	    font-style: normal;
	    font-size: 10px;
	    background: url('<e:url value="/pages/telecom_Index/sub_grid/image/bg_or.png"/>') no-repeat;
	    margin-right: 5px;	
		}
		#yx_detail_list_bigdata li {
			list-style-type:none;
		}  
		#yx_detail_list_bigdata td a{
			color: #0681d8;
	    text-decoration: underline;
	    font-size:12px;
  	}
  	#yx_detail_list_bigdata td{font-size:12px;}
	</style>
</head>
<body>
	<div style="margin-left:16px;display:none;">查询条件</div>
	<div id="yx_div_org_name" class="village_name_new"></div>
	<!--<h3 class="wrap_a tab_menu" style="border-left:none;padding-left:11px;">
		<span style="cursor:pointer;" class="selected">大数据营销</span> |
		<span style="cursor:pointer;">加装营销</span> | 
		<span style="cursor:pointer;">竞争营销</span>
	</h3>-->
	<div class="tab_box" style="margin-left:0px;height:100%;overflow:auto;"><!--margin-left:15px-->
		
		<!-- 大数据营销↓ -->
		<div style="overflow: hidden">
			<!-- 大数据营销条件 -->
			<div class="build_bar sub_level" id="bigdata_condition">
				<div id="scene_type_radios_bigdata" style="display:block;margin-left:5px;">
					营销场景：<c></c>
					<div id="did_flag_radios_bigdata" style="display:inline-block;margin-right:80px;float:right;">
				  	执行状态：
				  	<input type="radio" name="did_flag_bigdata" value="" checked="checked" style="margin-left:8px;">全部
				  	<input type="radio" name="did_flag_bigdata" value="1" style="margin-left:8px;">已执行
				  	<input type="radio" name="did_flag_bigdata" value="0" style="margin-left:8px;">未执行
				  </div>	
				</div>
		    <div class="list_text">网&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;格：</div><select id="yx_grid_bigdata"  class="list_select" style="width: 210px;margin-left: 13px"><option value="">全部</option></select>
				<div class="list_text" style="margin-left:123px;">小&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;区：</div><select id="yx_village_bigdata"  class="list_select" style="width: 180px;margin-left: 13px"><option value="">全部</option></select>
				<div style="display:none;">楼宇地址：<select><option value="">全部</option></select></div>
				<div style="display: inline-block;margin-left:5px;">查询条件：<input type="text" id="keyword_bigdata" style="width:516px;background:#fff;margin-left:11px;line-height:18px;height:18px;" placeholder="输入房号、联系人姓名、联系电话、接入号码" /></div>
				<button id="yx_village_query_bigdata" class="btn_uc" style="margin-top:2px;font-size: 12px">查&nbsp;&nbsp;询</button>
			</div>
			<!--大数据营销数量-->
			<div class="count_num count_sub_level">记录数：<span id="yx_villagecount_bigdata"></span></div>
			
			<!--大数据营销表格-->
			<div style="padding-right:14px;width:96%;margin:2px auto 0px auto;" class="village_m_tab">
				<table class="build_detail_in" style="width:100%;">
					<tr>
						<th width="40">序号</th>
						<th width="120">联系人</th>
						<th width="250">详细地址</th>
						<th width="250">营销场景</th>
						<th width="">执行</th>
					</tr>
				</table>
			</div>
			<div class="t_table village_m_tab15" style="margin:0px auto;height:229px;" id="yx_detail_list_bigdata_div"><!-- height:284; -->
				<table class="build_detail_in" id="yx_detail_list_bigdata" style="width:100%;">
					<tr>
						<td width="40">1</td><td width="120">张三</td><td width="250">某地址</td><td width="250">营销场景</td><td width="">查看</td>
					</tr>
					<tr>
						<td width="40">2</td><td width="120">李四</td><td width="250">某地址</td><td width="250">营销场景</td><td width="">执行</td>
					</tr>
				</table>
			</div>
		</div>
		<!-- 大数据营销↑ -->
		
		<!-- 加装营销↓ -->
		<div style="overflow: hidden;display:none;">
			<!-- 加装营销条件 -->
			<div class="build_bar sub_level" id="addion_condition">
				<div id="scene_type_radios_addion" style="display:block;margin-left:5px;">
					营销场景：
					<input type="radio" name="scene_type_addion" value="0" checked="checked" style="margin-left:8px;">全部
					<input type="radio" name="scene_type_addion" value="1" style="margin-left:5px;">宽带+移动
					<input type="radio" name="scene_type_addion" value="1" style="margin-left:5px;">宽带+ITV
					<input type="radio" name="scene_type_addion" value="1" style="margin-left:5px;">ITV+宽带
					<input type="radio" name="scene_type_addion" value="1" style="margin-left:5px;">ITV+移动
					
					<div id="did_flag_radios_addion" style="display:inline-block;margin-right:60px;float:right;">
				  	执行状态：
				  	<input type="radio" name="did_flag_addion" value="" checked="checked" style="margin-left:8px;">全部
				  	<input type="radio" name="did_flag_addion" value="1" style="margin-left:8px;">已执行
				  	<input type="radio" name="did_flag_addion" value="0" style="margin-left:8px;">未执行
				</div>
			</div>
		    <div class="list_text">网&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;格：</div><select id="yx_v_grid_addion"  class="list_select" style="width: 210px;margin-left: 13px"><option value="">全部</option></select>
				<div class="list_text" style="margin-left:143px;">小&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;区：</div><select id="yx_v_grid_addion"  class="list_select" style="width: 180px;margin-left: 13px"><option value="">全部</option></select>
				<div style="display:none;">楼宇地址:<select><option value="">全部</option></select></div>
				<div style="display: inline-block;margin-left:5px;">查询条件：<input type="text" id="keyword_addion"  style="width:536px;background:#fff;margin-left:11px;line-height:18px;height:18px;" placeholder="输入房号或联系人姓名或联系电话或接入号码进行模糊查询" /></div>
				<button id="yx_village_query_addion" class="btn_uc" style="margin-top:2px;font-size: 12px">查&nbsp;&nbsp;询</button>
			</div>
			<!--加装营销↓数量-->
			<div class="count_num count_sub_level">记录数：<span id="yx_villagecount_addion"></span></div>
			
			<!--加装营销↓表格-->
			<div style="padding-right:14px;width:96%;margin:2px auto 0px auto;" class="village_m_tab">
				<table class="build_detail_in" style="width:100%;">
					<tr>
						<th width="40">序号</th>
						<th width="120">联系人</th>
						<th width="250">详细地址</th>
						<th width="250">营销场景</th>
						<th width="">执行</th>
					</tr>
				</table>
			</div>
		    <div class="t_table village_m_tab15" style="margin:0px auto;height:240px;">
				<table class="build_detail_in" id="yx_detail_list_addion" style="width:100%;">
					<tr>
						<td width="40">1</td><td width="120">张三</td><td width="250">某地址</td><td width="250">营销场景</td><td width="">查看</td>
					</tr>
					<tr>
						<td width="40">2</td><td width="120">李四</td><td width="250">某地址</td><td width="250">营销场景</td><td width="">执行</td>	
					</tr>
				</table>
	    	</div>
		</div>
		<!-- 加装营销↑ -->
		
		<!-- 竞争营销↓ -->
		<div style="overflow: hidden;display:none;">
				竞争营销
		</div>
		<!-- 竞争营销↑ -->
		
	</div>
	
	<!-- 跳到执行、执行历史、资料维护的页面-->
	<div class="build_info_win info_edit_win" id="cell_view_container" style="display:none;">
		<div class="titlea"><div id="detail_more_draggable" style='text-align:left;width:90%;display: inline-block'>营销执行</div><div  class="titlec" onclick="javascript:closeCellViewIFrame(0);"></div></div>
		<iframe width="100%" height="100%"></iframe>
	</div>
</body>
</html>
<script>
	var seq_um = 0;
    var begin_scroll = "";
	
	var city_id = parent.city_id;
	var baseFullOptions = "<option  value=''>全部</option>";
	
	var area_id = "${sessionScope.UserInfo.CITY_NO}";	
	var substation = "${sessionScope.UserInfo.TOWN_NO}";
	var grid_id = "${sessionScope.UserInfo.GRID_NO}";
	
	var user_level = '${sessionScope.UserInfo.LEVEL}';
	
	//查询选项
	var scene_type_bigdata = "";
	var did_flag_bigdata = "";
	var village_id_bigdata = "";
	var keyword_bigdata = "";
	var yxlist_page_bigdata = 0;

	$(function () {
		if(user_level==4)
			$("#yx_div_org_name").text(parent.sub_name);
		else if(user_level==5)
			$("#yx_div_org_name").text(parent.grid_name);
		$('#cell_view_container').draggable({handle: $('#detail_more_draggable')});
		initTab();
		initSceneType();
		initGridOption();
		initVillageOption();

		initConditionBigData();

		if (user_level == 5) {
			var queryParam = new Object();
			queryParam.eaction = "getResidByStationNo";
			queryParam.grid_id = grid_id;
			$.post(parent.url4Query, queryParam, function (data) {
				data = $.parseJSON(data);
				$("#yx_grid_bigdata").append("<option value=\"" + data.STATION_ID + "\">" + '${sessionScope.UserInfo.GRID_NAME}' + "</option>");
				grid_id = data.STATION_ID;

				queryYXCountBigData();
				queryYXListBigData();
			});
		} else {
			queryYXCountBigData();
			queryYXListBigData();
		}

		$("#yx_detail_list_bigdata_div").scroll(function () {
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			//alert(scrollTop / (contentH - viewH));

			if (scrollTop / (contentH - viewH) >= 0.95) {

				if (new Date().getTime() - begin_scroll > 500) {
					yxlist_page_bigdata++;
					queryYXListBigDataByPage(yxlist_page_bigdata);
				}
				begin_scroll = new Date().getTime();
			}
		});
	});

	//初始化标签切换功能
	function initTab() {
		var $div_li = $(".tab_menu span");
		$div_li.click(function () {
			$(this).addClass("selected")            //当前<li>元素高亮
					.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
			var index = $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
			$("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
					.eq(index).show()   //显示 <li>元素对应的<div>元素
					.siblings().hide(); //隐藏其它几个同辈的<div>元素

			//加装营销
			if (index == 1) {
				queryYXCountAddon();
				queryYXListAddon();
			} else if (index == 2) {//竞争营销
				queryYXCountCompare();
				queryYXListCompare();
			}
		});
	}
	
	// 初始化场景选项
	function initSceneType(){
		var scene_list = '${e:java2json(scene_list.list)}';
		var scene_container = $("#scene_type_radios_bigdata > c");
		scene_container.empty();
		scene_container.append("<input type=\"radio\" name=\"scene_type_bigdata\" value=\"0\" checked=\"checked\" style=\"margin-left:11px;\" >全部");
		if(scene_list!=null && scene_list!="")
			scene_list = $.parseJSON(scene_list);
		for(var i = 0,l = scene_list.length;i<l;i++){
			var scene_item = scene_list[i];
			var item_str = "<input type=\"radio\" name=\"scene_type_bigdata\" value=\""+scene_item.ID+"\" style=\"margin-left:8px;\" />"+scene_item.TEXT;
			scene_container.append(item_str);
		}
	}
	// 初始化网格下拉菜单
	function initGridOption(){
		var queryParam = new Object();
		queryParam.latn_id = city_id;
		queryParam.bureau_no = area_id;
		queryParam.grid_name = "";
		if(user_level==4){
			queryParam.eaction = "grid_list";
			queryParam.union_org_code = substation;
			$.post(parent.url4Query,queryParam,function(data){
				data = $.parseJSON(data);
				for(var i = 0,l = data.length;i<l;i++){
					var d = data[i];
					$("#yx_grid_bigdata").append("<option value=\""+d.STATION_ID+"\">"+d.GRID_NAME+"</option>");
				}
			});
		}else if(user_level==5){
			$("#yx_grid_bigdata").empty();
			$("#yx_grid_bigdata").attr("disabled","disabled");
			queryParam.eaction = "getResidByStationNo";
			queryParam.union_org_code = substation;
			queryParam.grid_id = grid_id;
			$.post(parent.url4Query,queryParam,function(data){
				data = $.parseJSON(data);
				$("#yx_grid_bigdata").append("<option value=\""+data.STATION_ID+"\">"+'${sessionScope.UserInfo.GRID_NAME}'+"</option>");
				grid_id = data.STATION_ID;
			});
		}
	}
	//初始化小区下拉菜单
	function initVillageOption(){
		var queryParam = new Object();
		
		if(user_level==4)	{
			queryParam.eaction = "getVillagesBySubId";
			queryParam.substation = substation;
			
			$.post(parent.url4Query,queryParam,function(data){
				data = $.parseJSON(data);
				for(var i = 0,l = data.length;i<l;i++){
					var d = data[i];
					$("#yx_village_bigdata").append("<option value=\""+d.VILLAGE_ID+"\">"+d.VILLAGE_NAME+"</option>");
				}
			});
		}else if(user_level==5){
			queryParam.eaction = "getResidByStationNo";
			queryParam.grid_id = grid_id;
			$.post(parent.url4Query,queryParam,function(data1){
				data1 = $.parseJSON(data1);
				queryParam.grid_id = data1.STATION_ID;
				grid_id = data1.STATION_ID;
				queryParam.eaction = "getVillages";
				$.post(parent.url4Query,queryParam,function(data){
					data = $.parseJSON(data);
					for(var i = 0,l = data.length;i<l;i++){
						var d = data[i];
						$("#yx_village_bigdata").append("<option value=\""+d.VILLAGE_ID+"\">"+d.VILLAGE_NAME+"</option>");
					}
				});
			});
		}
	}
	
	function getConditionBigData(){
		scene_type_bigdata = $("input[name='scene_type_bigdata']:checked").val();
		did_flag_bigdata = $("input[name='did_flag_bigdata']:checked").val();
		grid_id = $("#yx_grid_bigdata option:selected").val();
		village_id_bigdata = $("#yx_village_bigdata option:selected").val();
		keyword_bigdata = $("#keyword_bigdata").val();
	}
	
	function getConditionAddon(){
		scene_type = $("input[name='scene_type_addon']:checked").val();
		did_flag = $("input[name='did_flag_addon']:checked").val();
		grid_id = $("#yx_grid_addon option:selected").val();
		village_id = $("#yx_village_addon option:selected").val();
		keyword_bigdata = $("#keyword_addon").val();
	}
	
	//大数据营销里响应查询条件
	function initConditionBigData(){
		//场景选择
		$("input[name='scene_type_bigdata']").live("click",(function(){
			getConditionBigData();
			queryYXCountBigData();
			queryYXListBigData();
		}));
		//执行状态选项
		$("input[name='did_flag_bigdata']").click(function(){
			getConditionBigData();
			queryYXCountBigData();
			queryYXListBigData();
		});	
		//网格选择
		$("#yx_grid_bigdata").on("change",function(){
			getConditionBigData();
			if(grid_id!=""){
				$("#yx_village_bigdata").empty();
				$("#yx_village_bigdata").append(baseFullOptions);
				$.post(parent.url4Query,{"eaction":"getVillages","grid_id":grid_id},function(data){
					data = $.parseJSON(data);
					for(var i = 0,l = data.length;i<l;i++){
						var d = data[i];
						$("#yx_village_bigdata").append("<option value=\""+d.VILLAGE_ID+"\">"+d.VILLAGE_NAME+"</option>");
					}
				});
				queryYXCountBigData();
				queryYXListBigData();
			}else{
				initVillageOption();
			}
		});
		$("#yx_village_bigdata").on("change",function(){
			getConditionBigData();
			queryYXCountBigData();
			queryYXListBigData();
		});
		$("#yx_village_query_bigdata").on("click",function(){
			getConditionBigData();
			queryYXCountBigData();
			queryYXListBigData();
		});
	}
	
	function queryYXListBigData(){
		$("#yx_detail_list_bigdata").empty();
		seq_num_bigData = 0;
		yxlist_page_bigdata = 0;
		queryYXListBigDataByPage(seq_num_bigData);
	}
	function queryYXCountBigData(){
		//因为有合并项目，所以数量应根据表格计算
		$.post(parent.url4Query,{"eaction":"yx_detail_query_count_six","segmid":0,"substation":substation,"grid_id":grid_id,"v_id":village_id_bigdata,"type":scene_type_bigdata,"did_flag":did_flag_bigdata,"keyword":keyword_bigdata,"user_level":'${sessionScope.UserInfo.LEVEL}'},function(data){
			data = $.parseJSON(data);
			$("#yx_villagecount_bigdata").text(data.COUNT);
		});
	}
	//加装营销
	function queryYXListAddon(){
	}
	function queryYXCountAddon(){
	}
	//竞争营销
	function queryYXListCompare(){
	}
	function queryYXCountCompare(){
	}
	
	var seq_num_bigData = 0;
	function queryYXListBigDataByPage(page){
		$.post(parent.url4Query,{"eaction":"yx_detail_query_list_six","page":page,"segmid":0,"substation":substation,"grid_id":grid_id,"v_id":village_id_bigdata,"type":scene_type_bigdata,"did_flag":did_flag_bigdata,"keyword":keyword_bigdata,"user_level":'${sessionScope.UserInfo.LEVEL}'},function(data){
			data = $.parseJSON(data);
			if(data.length==0 && seq_num_bigData==0){
				for(var i = 0,l = 8;i<l;i++){
					$("#yx_detail_list_bigdata").append("<tr><td width=\"40\"></td><td width=\"120\"></td><td width=\"250\"></td><td width=\"250\"></td><td width=\"\"></td></tr>");
				}
			}
			
			//此处合并相同房号的营销信息
			var data_merge = new Array();
			for (var j = 0,k = data.length;j<k;j++){
				var d = data[j];
				var add6 = d.ADDRESS_ID;
				var item = data_merge[add6];
				if(item==undefined){//合并数组中没有该房号
					var item_arr = new Array();
					
					//需要合并的接入号
					var acc_nbr_arr = new Array();
					acc_nbr_arr.push(d.ACC_NBR);
					item_arr.ACC_NBR = acc_nbr_arr;
					//需要合并的营销推荐
					var yx_suggest = new Array();
					yx_suggest.push(d.CONN_STR);
					item_arr.CONN_STR = yx_suggest;
					//obj.CONTRACT_IPHONE+"<br/>"+obj.CONTACT_PERSON
					item_arr.ADDRESS_ID = d.ADDRESS_ID;
					item_arr.CONTACT_PERSON = d.CONTACT_PERSON;
					item_arr.CONTACT_IPHONE = d.CONTACT_IPHONE;
					
					item_arr.DID_FLAG= d.DID_FLAG;
					
					var prod_inst_id_arr = new Array();
					prod_inst_id_arr.push(d.PROD_INST_ID);
					item_arr.PROD_INST_ID = prod_inst_id_arr;
					
					item_arr.SEGM_ID = d.SEGM_ID;
					item_arr.SEGM_NAME_2 = d.SEGM_NAME_2;
					item_arr.STAND_NAME_2 = d.STAND_NAME_2;
					
					data_merge[add6] = item_arr;
				}else{
					item.ACC_NBR.push(d.ACC_NBR);
					item.CONN_STR.push(d.CONN_STR);
					item.PROD_INST_ID.push(d.PROD_INST_ID);
					
					data_merge[add6] = item;
				}
				
			}
			
			//营销清单表格生成
			var keys = Object.keys(data_merge);
			$("#yx_num span").text(keys.length);
			for(var j = 0,k = keys.length;j<k;j++){
				var key = keys[j];
				
				var rowspan = data_merge[key].ACC_NBR.length;
				var obj = data_merge[key];
				var temp = "";
				temp += "<tr>";
				temp += "<td width=\"40\" style=\"text-align:center;\">"+(++seq_num_bigData)+"</td>";
				
				temp += "<td width=\"120\" rowspan=\"\" style=\"text-align:center;\">";
				temp += obj.CONTACT_PERSON+"<div style='color:#0681d8;font-weight: bold;font-size: 14px'>"+obj.CONTACT_IPHONE+"</div>";
				temp += "</td>";
				
				temp += "<td rowspan=\"\" width=\"250\" style='text-align:left'>"+obj.STAND_NAME_2+"</td>";
				temp += "<td rowspan=\"\" width=\"250\" style='text-align:left'>";
				var conn_str = obj.CONN_STR;
				var tr_temp1 = "<table style='width: 100%' class='yingxiaochangjing_table'>";
				for(var m = 0,n = conn_str.length;m<n;m++){
					var yx_suggest = conn_str[m];
					tr_temp1 += "<tr><td style='border: none'>"+loadSuggest(yx_suggest,j,m)+"</td></tr>";
				}
				tr_temp1 += "</table>";
				temp += tr_temp1+"</td>";

				//执行、查看
				var did_flag = obj.DID_FLAG;
				if(did_flag==null)
					temp += "<td id='" + obj.PROD_INST_ID + "'><a href=\"javascript:void(0)\" class=\"execution\" onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','exe')\">执行</a></td>";
				else
					temp += "<td id='" + obj.PROD_INST_ID + "'><a href=\"javascript:void(0)\" class=\"execution\" onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','history')\">查看</a></td>";
					
				temp += "</tr>";
				
				$("#yx_detail_list_bigdata").append(temp);
			}
		});
	}
	
	var to_cell_view = function(add6,flag){
		//信息收集被竞争收集代替的修改
		if(flag=="info"){
			$.post(parent.url4Query,{"eaction":"hasSavedInfoCollect","add6":add6},function(data){
				data = $.parseJSON(data);
				if(data<0){//信息被编辑过，则打开查看窗口，否则打开编辑窗口
					viewInfoCollectWin(add6);
				}else{
					editInfoCollectWin(add6);
				}
			});
		}else{
			$("#cell_view_container").show();
			$("#cell_view_container > iframe").attr("src","viewPlane_cell_view_details.jsp?add6="+add6+"&flag="+flag);
		}
	}
	var closeCellViewIFrame = function(flag){
		$("#cell_view_container").hide();
		$("#cell_view_container > iframe").empty();
		//大数据营销
		if(flag==0){
			getConditionBigData();
			queryYXCountBigData();
			queryYXListBigData();
		}else if(flag==1){//加装营销
			
		}
	}
	function loadSuggest(sug,id1,indez) {
		//sug的结果最多有三个值 ，可能是：0个值=空；1个值=aa<C>aa1111<A>；2个值=aa<C>aa1111<A>bb<C>bb2222<A>；3个值=aa<C>aa1111<A>bb<C>bb2222<A><cc><C>cc3333<A>
		
		//sug = '价值提升营销加副卡策略<C>目标用户： 单产品无主副卡存量用户、无协议、终端在网时长>24个月、ARPU值50~80元。营销策略：预存790元=890元分摊话费(24个月实际消费的42%返还)+赠送市场价890元的华为8813Q手机一部，但需加开副卡，两卡共享89元。<A>适合套餐提档乐享3G上网版V4.0-89元<C>bbbbb<A>适合推荐手机报<C>ccccccccccccc<A>系统-推荐终端升级营销<C>目标用户：用户终端使用一年以上且当前无有效合约；<A>';
		var arry = sug.split("<a>");
		var n = arry.length;
		$('#view_suggest_number').html(n-1);//给营销推荐个数赋值
		var html = '';
		//<li><em>2</em> <strong><a href="#this">适合套餐提档乐享3G上网版V4.0-89元</a></strong>目标用户：单产品无主副卡存量用户、无协议。终端在网时长>24个月、ARPU值50~80元</li>
		for(var i=0;i<n-1;i++){
			var sub = arry[i].split("<c>");
			var idx = i+1;
			if(i==0){
				html += '<li style="text-align: left"><em>'+idx+'</em><a style="font-weight:bold;cursor:pointer;" onclick="javascript:suggestDetail('+idx+','+n+','+id1+',this);">'+sub[0]+'</a><p id="view_suggest_p_'+id1+idx+'" style="display:block;margin-top:-10px;">&nbsp;&nbsp;&nbsp;&nbsp;'+sub[1]+'</p>';
			}else{
				html += '<li style="text-align: left"><em>'+idx+'</em><a style="font-weight:bold;cursor:pointer;" onclick="javascript:suggestDetail('+idx+','+n+','+id1+',this);">'+sub[0]+'</a><p id="view_suggest_p_'+id1+idx+'" style="display:none;margin-top:-10px;">&nbsp;&nbsp;&nbsp;&nbsp;'+sub[1]+'</p>';
			}
		}
		return html;
	}
	function suggestDetail(v,n,id1,thiz) {
		$(thiz).next().toggle();
		/*$('#view_suggest_p_'+id1+v).toggle();
		for(var i=1;i<n;i++){
			if(i!=v){
				$('#view_suggest_p_'+id1+i).hide();
			}
		}*/
	}
</script>