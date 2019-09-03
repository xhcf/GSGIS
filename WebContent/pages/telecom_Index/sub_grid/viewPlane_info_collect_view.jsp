<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<html>
<head>
	<title>收集详情</title>
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
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.3"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/common/css/info_collect.css?version=0.1"/>' rel="stylesheet" type="text/css" media="all" />
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
	</style>

</head>
<body>
<div class="tab_box" style="margin-left:15px;height:100%;overflow:auto;">
	<div class="devep village_new_base">
		<h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;padding-left:5px;">
			基础信息
		</h3>

		<div class="bulid_village_btn village_edit" style="position:absolute;right:35px;top:5px;width:60px;">
			<button id="toInfoCollectEdit_btn">编辑</button>
		</div>
		<div style="margin:10px 16px 15px 0px;border-bottom:1px dashed #999;padding-bottom:12px;padding-left:8px;">
			<table style="width:95%;">
				<tr>
					<td style="width:33%;"><span style="color:#3F48CC;">客户姓名：</span><span
							id="info_colle_view_custom_name"></span></td>
					<td style="width:33%;"><span style="color:#3F48CC;">联系电话：</span><span
							id="info_colle_view_acc_nbr"></span></td>
					<td>家庭人口：<span id="info_colle_view_family_people"></span></td>
				</tr>
				<tr>
					<td style="width:33%;">分公司：<span id="info_colle_view_latn_name"></span></td>
					<td colspan=2>区县：<span id="info_colle_view_bureau_name"></span></td>
				</tr>
				<tr>
					<td style="width:33%;">支&nbsp;&nbsp;局：<span id="info_colle_view_sub_name"></span></td>
					<td style="width:33%;">网格：<span id="info_colle_view_grid_name"></span></td>
					<td>小区：<span id="info_colle_view_village_name"></span></td>
				</tr>
				<tr>
					<td colspan=3 style=""><span style="color:#3F48CC;">详细地址：</span><span
							id="info_colle_view_address"></span></td>
				</tr>
			</table>
		</div>
		<h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;padding-left:5px;">
			竞争信息
		</h3>

		<div style="margin:10px 16px 15px 0px;border-bottom:1px dashed #999;padding-bottom:17px;">
			<table class="content_table" style="width:100%;margin:0px auto;">
				<tr>
					<th width="80">产品</th>
					<th width="180">号码</th>
					<th width="80">运营商</th>
					<th width="120">消费情况</th>
					<th width="">到期时间</th>
				</tr>
				<tr>
					<td>手机1</td>
					<td><span id="info_colle_view_cellphone1_phoneNum"></span></td>
					<td><span id="info_colle_view_cellphone1_operators_type"></span></td>
					<td><span id="info_colle_view_cellphone1_pay"></span></td>
					<td><span id="info_colle_view_cellphone1_date"></span></td>
				</tr>
				<tr>
					<td>手机2</td>
					<td><span id="info_colle_view_cellphone2_phoneNum"></span></td>
					<td><span id="info_colle_view_cellphone2_operators_type"></span></td>
					<td><span id="info_colle_view_cellphone2_pay"></span></td>
					<td><span id="info_colle_view_cellphone2_date"></span></td>
				</tr>
				<tr>
					<td>手机3</td>
					<td><span id="info_colle_view_cellphone3_phoneNum"></span></td>
					<td><span id="info_colle_view_cellphone3_operators_type"></span></td>
					<td><span id="info_colle_view_cellphone3_pay"></span></td>
					<td><span id="info_colle_view_cellphone3_date"></span></td>
				</tr>
				<tr>
					<td>宽带</td>
					<td><span id="info_colle_view_kd_phoneNum"></span></td>
					<td><span id="info_colle_view_kd_operators_type"></span></td>
					<td><span id="info_colle_view_kd_pay"></span></td>
					<td><span id="info_colle_view_kd_date"></span></td>
				</tr>
				<tr>
					<td>电视</td>
					<td><span id="info_colle_view_ds_phoneNum"></span></td>
					<td><span id="info_colle_view_ds_operators_type"></span></td>
					<td><span id="info_colle_view_ds_pay"></span></td>
					<td><span id="info_colle_view_ds_date"></span></td>
				</tr>
			</table>
		</div>
		<h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;display:none;">
			资源信息
		</h3>

		<div style="display:none;">
			<table>
				<tr>
					<td>分纤箱：</td>
					<td><input type="text" id="info_colle_view_fxx"/></td>
				</tr>
				<tr>
					<td>分纤箱位置：</td>
					<td><img src="" alt="alt" title="title" id="info_colle_view_img_fxx"/></td>
				</tr>
				<tr>
					<td>大门照片：</td>
					<td><img src="" alt="alt" title="title" id="info_colle_view_img_gate"/></td>
				</tr>
				<tr>
					<td>居住照片：</td>
					<td><img src="" alt="alt" title="title" id="info_colle_view_img_house"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>
</body>
</html>
<script>
	var add6_id = '${param.add6_id}';
	var city_id = '${param.latn_id}';
  var area_id = '${param.bureau_no}';
  var substation = '${param.union_org_code}';
  var grid_id = '${param.grid_id}';
  
  var user_level = '${sessionScope.UserInfo.LEVEL}';

	$(function(){
		if(user_level=="" || user_level==undefined){
	    layer.msg("与服务器连接断开，请重新登录");
	    return;
	  }
	  if(user_level=="1" || user_level=="2"){//省、市用户隐藏编辑按钮
	  		$("#toInfoCollectEdit_btn").hide();
	  }else{
	  		$("#toInfoCollectEdit_btn").show();	
	  }
	  
		setPosition();
		getInfoCollect();
		$("#toInfoCollectEdit_btn").on("click",function(){
				parent.openWinInfoCollectEdit(add6_id,city_id,area_id,substation,grid_id);
		});
	});
	function getInfoCollect(){
		$.post(parent.url4Query,{"eaction":"getInfoCollectByAdd6","add6":add6_id},function(data){
			data = $.parseJSON(data);
			if(data==null){
				console.log("暂无信息");
				return;
			}
			
			//基础信息设值
			$("#info_colle_view_custom_name").text(data.CONTACT_PERSON);
			$("#info_colle_view_acc_nbr").text(data.CONTACT_NBR);
			$("#info_colle_view_family_people").text(data.PEOPLE_COUNT);
			$("#info_colle_view_address").text(data.STAND_NAME_2);
			
			//表格设值
			$("#info_colle_view_cellphone1_phoneNum").text(data.PHONE_NBR1);
			$("#info_colle_view_cellphone2_phoneNum").text(data.PHONE_NBR2);
			$("#info_colle_view_cellphone3_phoneNum").text(data.PHONE_NBR3);
			$("#info_colle_view_kd_phoneNum").text(data.KD_NBR);
			$("#info_colle_view_ds_phoneNum").text(data.ITV_NBR);
			
			$("#info_colle_view_cellphone1_operators_type").text(data.PHONE_BUSINESS1_TEXT);
			$("#info_colle_view_cellphone2_operators_type").text(data.PHONE_BUSINESS2_TEXT);
			$("#info_colle_view_cellphone3_operators_type").text(data.PHONE_BUSINESS3_TEXT);
			$("#info_colle_view_kd_operators_type").text(data.KD_BUSINESS_TEXT);
			$("#info_colle_view_ds_operators_type").text(data.ITV_BUSINESS_TEXT);
			
			$("#info_colle_view_cellphone1_pay").text(data.PHONE_XF1);
			$("#info_colle_view_cellphone2_pay").text(data.PHONE_XF2);
			$("#info_colle_view_cellphone3_pay").text(data.PHONE_XF3);
			$("#info_colle_view_kd_pay").text(data.KD_XF);
			$("#info_colle_view_ds_pay").text(data.ITV_XF);
			
			$("#info_colle_view_cellphone1_date").text(data.PHONE_DQ_DATE1);
			$("#info_colle_view_cellphone2_date").text(data.PHONE_DQ_DATE2);
			$("#info_colle_view_cellphone3_date").text(data.PHONE_DQ_DATE3);
			$("#info_colle_view_kd_date").text(data.KD_DQ_DATE);
			$("#info_colle_view_ds_date").text(data.ITV_DQ_DATE);
			
			//资源信息
			//分纤箱设值
			$("#info_colle_view_fxx").val(data.FIBER_BOX);
			//图片设值
			$("#info_colle_view_img_fxx").attr("src",data.FIBER_BOX_PLACES);
			$("#info_colle_view_img_gate").attr("src",data.GATE_PIC);
			$("#info_colle_view_img_house").attr("src",data.LIVE_PIC);
		});
	}

	//获取位置
  function setPosition(){
  	//地市编码为空，则是从楼宇视图中点击的。否则是从竞争收集中点击的。
  	if(city_id=="undefined" || city_id=="null" || city_id==null || city_id==""){
  		$("#info_colle_view_latn_name").text(parent.global_position_build_view[0]);
	  	$("#info_colle_view_bureau_name").text(parent.global_position_build_view[1]);
	  	$("#info_colle_view_sub_name").text(parent.global_position_build_view[2]);
	  	$("#info_colle_view_grid_name").text(parent.global_position_build_view[3]);
	  	$("#info_colle_view_village_name").text(parent.global_position_build_view[4]);
  	}else{
	  	$.post(parent.url4Query,{"eaction":"getPosition","city_id":city_id,"area_id":area_id,"sub_id":substation,"grid_id":grid_id},function(data){
	  		data = $.parseJSON(data);
	  		$("#info_colle_view_latn_name").text(data.LATN_NAME);
		  	$("#info_colle_view_bureau_name").text(data.BUREAU_NAME);
		  	$("#info_colle_view_sub_name").text(data.BRANCH_NAME);
		  	$("#info_colle_view_grid_name").text(data.GRID_NAME);
	  	});
	  	$.post(parent.url4Query,{"eaction":"getVillageNameByAdd6","add6":add6_id},function(data){
	  			data = $.parseJSON(data);
	  			$("#info_colle_view_village_name").text(data.VILLAGE_NAME);
	  	});
	  }
  }
</script>