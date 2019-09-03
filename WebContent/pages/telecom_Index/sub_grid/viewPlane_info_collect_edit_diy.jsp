<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<html>
<head>
	<title>自填地址竞争收集</title><!-- 旧版本 暂不用-->
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
	<!--<script src='<e:url value="/pages/telecom_Index/common/js/upload_img.js"/>' charset="utf-8"></script>-->
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/locale/easyui-lang-zh_CN.js"/>'></script>
	<style type="text/css">
		body{background-color:#fff;}
		div input {border-bottom:1px solid #aaa;}
	</style>
</head>
<body>
<div class="tab_box" style="margin:15px;height:100%;overflow:auto;">
	<div class="target_a" style="border-bottom:none;">
		<h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;padding-left:5px;">基础信息</h3>

		<div class="bulid_village_btn village_edit" style="position:absolute;right:28px;top:5px;width:150px;">
			<button id="toInfoCollectSave_btn">保存</button>
			<button id="toInfoCollectCancel_btn">取消</button>
		</div>
		<div style="margin:10px 0;border-bottom:1px dashed #999;padding-bottom:15px;padding-left:8px;">
			<table>
				<tr>
					<td style="width:33%;"><span style="color:#3F48CC;">客户姓名：</span><input type="text"
																						   id="info_colle_edit_custom_name"/>
					</td>
					<td style="width:33%;"><span style="color:#3F48CC;">联系电话：</span><input type="text"
																						   id="info_colle_edit_acc_nbr"/>
					</td>
					<td style="width:33%;"><span style="color:#3F48CC;">家庭人口：</span><input type="text" id="info_colle_edit_family_people"/></td>
				</tr>
				<tr>
					<td style="width:33%;">分公司：<span id="info_colle_edit_latn_name"></span></td>
					<td colspan=2>区县：<span id="info_colle_edit_bureau_name"></span></td>
				</tr>
				<tr>
					<td style="width:33%;">支&nbsp;&nbsp;局：<span id="info_colle_edit_sub_name"></span></td>
					<e:if condition="${sessionScope.UserInfo.LEVEL eq '5'}" var="grid_user">
						<td style="width:33%;">网格：<select id="info_colle_edit_grid_name" disabled="disabled" style="width:150px;"><option></option></select></td>
					</e:if>
					<e:else condition="${grid_user}">
						<td style="width:33%;">网格：<select id="info_colle_edit_grid_name" style="width:150px;"><option></option></select></td>
					</e:else>
					<input type="hidden" id="info_colle_edit_grid_id" />
					<td style="width:33%;">小区：<select id="info_colle_edit_village_name" style="width:150px;"><option></option></select></td>
				</tr>
				<tr>
					<td colspan=3>
						<span style="color:#3F48CC;">详细地址：</span>
						<!-- 四级地址 -->
						<select id="info_colle_edit_address4" style="width:350px;">
							<option></option>
						</select>
						<!-- 六级地址 -->
						<select id="info_colle_edit_address6" style="width:150px;">
							<option></option>
						</select>

					<span id="info_colle_edit_address_span"></span></td>
				</tr>
			</table>
		</div>
		<h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;padding-left:5px;">竞争信息</h3>

		<div style="margin:10px 0 10px 0;padding-bottom:22px;border-bottom:1px dashed #999;">
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
					<td><input type="text" id="info_colle_edit_cellphone1_phoneNum"/></td>
					<td>
						<select id="info_colle_edit_cellphone1_operators_type">
							<option></option>
							<option value=1> 移动</option>
							<option value=2> 联通</option>
						</select>
					</td>
					<td><input type="text" id="info_colle_edit_cellphone1_pay"/></td>
					<td><input id="info_colle_edit_cellphone1_date" type="text" style="width:120px;"/></td>
				</tr>
				<tr>
					<td>手机2</td>
					<td><input type="text" id="info_colle_edit_cellphone2_phoneNum"/></td>
					<td>
						<select id="info_colle_edit_cellphone2_operators_type">
							<option></option>
							<option value=1> 移动</option>
							<option value=2> 联通</option>
						</select>
					</td>
					<td><input type="text" id="info_colle_edit_cellphone2_pay"/></td>
					<td><input id="info_colle_edit_cellphone2_date" type="text" style="width:120px;"/></td>
				</tr>
				<tr>
					<td>手机3</td>
					<td><input type="text" id="info_colle_edit_cellphone3_phoneNum"/></td>
					<td>
						<select id="info_colle_edit_cellphone3_operators_type">
							<option></option>
							<option value=1> 移动</option>
							<option value=2> 联通</option>
						</select>
					</td>
					<td><input type="text" id="info_colle_edit_cellphone3_pay"/></td>
					<td><input id="info_colle_edit_cellphone3_date" type="text" style="width:120px;"/></td>
				</tr>
				<tr>
					<td>宽带</td>
					<td><input type="text" id="info_colle_edit_kd_phoneNum"/></td>
					<td>
						<select id="info_colle_edit_kd_operators_type">
							<option></option>
							<option value=1> 移动</option>
							<option value=2> 联通</option>
							<option value=3> 广电</option>
							<option value=4> 其他</option>
						</select>
					</td>
					<td><input type="text" id="info_colle_edit_kd_pay"/></td>
					<td><input id="info_colle_edit_kd_date" type="text" style="width:120px;"/></td>
				</tr>
				<tr>
					<td>电视</td>
					<td><input type="text" id="info_colle_edit_ds_phoneNum"/></td>
					<td>
						<select id="info_colle_edit_ds_operators_type">
							<option></option>
							<option value=1> 移动</option>
							<option value=2> 联通</option>
							<option value=3> 广电</option>
							<option value=4> 其他</option>
						</select>
					</td>
					<td><input type="text" id="info_colle_edit_ds_pay"/></td>
					<td><input id="info_colle_edit_ds_date" type="text" style="width:120px;"/></td>
				</tr>
			</table>
		</div>
		<h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;display:none;">资源信息</h3>

		<div style="height:auto;padding-bottom:10px;display:none;">
			<table>
				<tr>
					<td>分纤箱：</td>
					<td><input type="text" id="info_colle_edit_fxx" style="width:450px;"/></td>
				</tr>
				<tr>
					<td>分纤箱位置：</td>
					<td>
						<div id="img_fxx_div">
							<img id="info_colle_edit_img_fxx" border=0 width="180" height="180"/>
						</div>
						<form id="form_ffx" method="post" enctype="multipart/form-data">
							<input type="hidden" name="update_load" value="fxx"/>
							<input type="file" name="Filedata" style="border:none;"
								   onchange="previewImage(this,'img_fxx_div','info_colle_edit_img_fxx')"/>
						</form>
						<button id="upload_ffx" onclick="testUpload('ffx')">上传分纤箱位置</button>
					</td>
				</tr>
				<tr>
					<td>大门照片：</td>
					<td>
						<div id="img_gate_div">
							<img id="info_colle_edit_img_gate" border=0 width="180" height="180"/>
						</div>
						<form id="form_gate" method="post" enctype="multipart/form-data">
							<input type="hidden" name="update_load" value="gate"/>
							<input type="file" name="Filedata" style="border:none;"
								   onchange="previewImage(this,'img_gate_div','info_colle_edit_img_gate')"/>
						</form>
						<button id="upload_gate" onclick="testUpload('gate')">上传大门照片</button>
					</td>
				</tr>
				<tr>
					<td>居住照片：</td>
					<td>
						<div id="img_house_div">
							<img id="info_colle_edit_img_house" border=0 width="180" height="180"/>
						</div>
						<form id="form_house" method="post" enctype="multipart/form-data">
							<input type="hidden" name="update_load" value="house"/>
							<input type="file" name="Filedata" style="border:none;"
								   onchange="previewImage(this,'img_house_div','info_colle_edit_img_house')"/>
						</form>
						<button id="upload_gate" onclick="testUpload('house')">上传居住照片</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</body>
</html>
<script>
	var url4Query_diy = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_info_collect_diy_action.jsp' />";
	var add6_id = '${param.add6_id}';
	var city_id = '${param.latn_id}';
	var area_id = ('${param.bureau_no}' == 'null' ? '' : '${param.bureau_no}');
	var substation = ('${param.union_org_code}' == 'null' ? '' : '${param.union_org_code}');
	var grid_id = ('${param.grid_id}' == 'null' ? '' : '${param.grid_id}');
	var village_id = "";

	$(function(){
		initForm();
		resetForm();
		setPosition();
		//若add6_id不为空，则为编辑
		if(add6_id!=""){
			setFormForUpdate();
		}else{//为空则为新建
			$("#info_colle_edit_address_span").empty().hide();
			$("#info_colle_edit_address4").show();
			$("#info_colle_edit_address6").show();
			setAdd6OptionList();
		}

		$("#toInfoCollectSave_btn").on("click",function(){
			saveInfoCollect();
		});
		$("#toInfoCollectCancel_btn").on("click",function(){
			parent.closeWinInfoCollectionEdit(add6_id);
		});

	});
	//初始化表单控件
	function initForm(){
		//初始化日期控件
		$("#info_colle_edit_cellphone1_date").datebox({
			editable:false,
			onSelect: function(date){
				$('#info_colle_edit_cellphone1_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});
		$("#info_colle_edit_cellphone2_date").datebox({
			editable:false,
			onSelect: function(date){
				$('#info_colle_edit_cellphone2_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});
		$("#info_colle_edit_cellphone3_date").datebox({
			editable:false,
			onSelect: function(date){
				$('#info_colle_edit_cellphone3_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});
		$("#info_colle_edit_kd_date").datebox({
			editable:false,
			onSelect: function(date){
				$('#info_colle_edit_kd_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});
		$("#info_colle_edit_ds_date").datebox({
			editable:false,
			onSelect: function(date){
				$('#info_colle_edit_ds_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});
		if('${sessionScope.UserInfo.LEVEL}'==4){
			$("#info_colle_edit_grid_name").combobox({
				url:url4Query_diy+"?eaction=getGridList&sub_id="+substation,
				valueField:'GRID_ID',
				textField:'GRID_NAME',
				onSelect:function(rec){
					grid_id = $.trim(rec.GRID_ID);
					village_id = "";
					$("#info_colle_edit_village_name").combobox({
						url:url4Query_diy+"?eaction=getVillageList&grid_id="+grid_id+"&sub_id="+substation,
						valueField:'VILLAGE_ID',
						textField:'VILLAGE_NAME',
						onSelect:function(rec){
							//标准地址联动
							village_id = $.trim(rec.VILLAGE_ID);
							setAdd6OptionList();
						}
					});
					//标准地址联动
					setAdd6OptionList();
				}
			});
			$("#info_colle_edit_village_name").combobox();
		}else if('${sessionScope.UserInfo.LEVEL}'==5){
			$("#info_colle_edit_grid_name").combobox({});
			$("#info_colle_edit_grid_id").val(grid_id);
			$("#info_colle_edit_village_name").combobox({
				url:url4Query_diy+"?eaction=getVillageList&grid_id="+grid_id,
				valueField:'VILLAGE_ID',
				textField:'VILLAGE_NAME',
				onSelect:function(rec){
					//标准地址联动
					village_id = $.trim(rec.VILLAGE_ID);
					setAdd6OptionList();
				},
				onUnselect:function(rec){
						console.log("rec:'"+rec+"'");
				}
			});
		}

	}

	//设置表单，以编辑数据
	function setFormForUpdate(){
		$.post(parent.url4Query,{"eaction":"getInfoCollectByAdd6","add6":add6_id},function(data){
			data = $.parseJSON(data);
			if(data==null){
				console.log("暂无信息");
				return;
			}

			//基础信息设值
			$("#info_colle_edit_custom_name").val(data.CONTACT_PERSON);
			$("#info_colle_edit_acc_nbr").val(data.CONTACT_NBR);
			$("#info_colle_edit_family_people").val(data.PEOPLE_COUNT);
			$("#info_colle_edit_address_span").show().text(data.STAND_NAME_2);
			$("#info_colle_edit_address4").hide();
			$("#info_colle_edit_address6").hide();

			//表格设值
			$("#info_colle_edit_cellphone1_phoneNum").val(data.PHONE_NBR1);
			$("#info_colle_edit_cellphone2_phoneNum").val(data.PHONE_NBR2);
			$("#info_colle_edit_cellphone3_phoneNum").val(data.PHONE_NBR3);
			$("#info_colle_edit_kd_phoneNum").val(data.KD_NBR);
			$("#info_colle_edit_ds_phoneNum").val(data.ITV_NBR);

			$("#info_colle_edit_cellphone1_operators_type").val(data.PHONE_BUSINESS1);
			$("#info_colle_edit_cellphone2_operators_type").val(data.PHONE_BUSINESS2);
			$("#info_colle_edit_cellphone3_operators_type").val(data.PHONE_BUSINESS3);
			$("#info_colle_edit_kd_operators_type").val(data.KD_BUSINESS);
			$("#info_colle_edit_ds_operators_type").val(data.ITV_BUSINESS);

			$("#info_colle_edit_cellphone1_pay").val(data.PHONE_XF1);
			$("#info_colle_edit_cellphone2_pay").val(data.PHONE_XF2);
			$("#info_colle_edit_cellphone3_pay").val(data.PHONE_XF3);
			$("#info_colle_edit_kd_pay").val(data.KD_XF);
			$("#info_colle_edit_ds_pay").val(data.ITV_XF);

			$("#info_colle_edit_cellphone1_date").datebox('setValue',data.PHONE_DQ_DATE1);
			$("#info_colle_edit_cellphone2_date").datebox('setValue',data.PHONE_DQ_DATE2);
			$("#info_colle_edit_cellphone3_date").datebox('setValue',data.PHONE_DQ_DATE3);
			$("#info_colle_edit_kd_date").datebox('setValue',data.KD_DQ_DATE);
			$("#info_colle_edit_ds_date").datebox('setValue',data.ITV_DQ_DATE);

			//资源信息
			//分纤箱设值
			$("#info_colle_edit_fxx").val(data.FIBER_BOX);
			//图片设值
			$("#info_colle_edit_img_fxx").attr("src",data.FIBER_BOX_PLACES);
			$("#info_colle_edit_img_gate").attr("src",data.GATE_PIC);
			$("#info_colle_edit_img_house").attr("src",data.LIVE_PIC);
		});

	}
	//表单清空
	function resetForm(){
		//基础信息重置
		$("#info_colle_edit_custom_name").val("");
		$("#info_colle_edit_acc_nbr").val("");
		$("#info_colle_edit_family_people").val("");
		$("#info_colle_edit_latn_name").text("");
		$("#info_colle_edit_bureau_name").text("");
		$("#info_colle_edit_sub_name").text("");
		$("#info_colle_edit_grid_name").text("");
		$("#info_colle_edit_village_name").text("");
		$("#info_colle_edit_address4").val("");
		$("#info_colle_edit_address6").val("");

		//表格重置
		$("#info_colle_edit_cellphone1_phoneNum").val("");
		$("#info_colle_edit_cellphone2_phoneNum").val("");
		$("#info_colle_edit_cellphone3_phoneNum").val("");
		$("#info_colle_edit_kd_phoneNum").val("");
		$("#info_colle_edit_ds_phoneNum").val("");

		$("#info_colle_edit_cellphone1_operators_type").val("");
		$("#info_colle_edit_cellphone2_operators_type").val("");
		$("#info_colle_edit_cellphone3_operators_type").val("");
		$("#info_colle_edit_kd_operators_type").val("");
		$("#info_colle_edit_ds_operators_type").val("");

		$("#info_colle_edit_cellphone1_pay").val("");
		$("#info_colle_edit_cellphone2_pay").val("");
		$("#info_colle_edit_cellphone3_pay").val("");
		$("#info_colle_edit_kd_pay").val("");
		$("#info_colle_edit_ds_pay").val("");

		$('#info_colle_edit_cellphone1_date').datebox('setValue','');
		$('#info_colle_edit_cellphone2_date').datebox('setValue','');
		$('#info_colle_edit_cellphone3_date').datebox('setValue','');
		$('#info_colle_edit_kd_date').datebox('setValue','');
		$('#info_colle_edit_ds_date').datebox('setValue','');

		//资源信息
		//分纤箱
		$("#info_colle_edit_fxx").val("");
		//图片
		$("#info_colle_edit_img_fxx").attr("src","");
		$("#info_colle_edit_img_gate").attr("src","");
		$("#info_colle_edit_img_house").attr("src","");
	}

	function saveInfoCollect(){
		$("#toInfoCollectSave_btn").attr("disabled","disabled");
		var operate_type = "";
		var info_colle_edit_custom_name = $.trim($("#info_colle_edit_custom_name").val());
		var info_colle_edit_acc_nbr = $.trim($("#info_colle_edit_acc_nbr").val());
		var info_colle_edit_family_people = $.trim($("#info_colle_edit_family_people").val());

		if(info_colle_edit_custom_name=="" || info_colle_edit_acc_nbr=="" || info_colle_edit_family_people==""){
			layer.msg("客户姓名、联系电话、家庭人口必填");
			$("#toInfoCollectSave_btn").removeAttr("disabled");
			return;
		}
		if(add6_id==""){
			operate_type = "add";
			/*var add4_id = $("#info_colle_edit_address4").combobox("getValue");
			if(add4_id==""){
				layer.msg("详细地址必选");
				$("#toInfoCollectSave_btn").removeAttr("disabled");
				return;
			}
			add6_id = $("#info_colle_edit_address6").combobox("getValue");*/
		}else{
			operate_type = "update";
		}
		/*if(add6_id=="" || add6_id==null || add6_id==undefined){
			layer.msg("详细地址必选");
			$("#toInfoCollectSave_btn").removeAttr("disabled");
			return;
		}*/

		var add6_name = "";

		var add4_id = $("#info_colle_edit_address4").combobox("getValue");

		//这两个值相等，则为自己手工填写的
		if(add4_id==$("#info_colle_edit_address4").combobox("getText") && add4_id!=""){
			if(operate_type=="add")
				operate_type = "add_diy";
			else if(operate_type=="update")
				operate_type = "update_diy";
			add6_id = "";
			try{
				add6_name = $.trim($("#info_colle_edit_address4").combobox("getText"))+ $.trim($("#info_colle_edit_address6").combobox("getText"));
			}catch(e){
				add6_name = $.trim($("#info_colle_edit_address4").combobox("getText"));
			}

		}else{
			if(add4_id==""){
				layer.msg("详细地址必选");
				$("#toInfoCollectSave_btn").removeAttr("disabled");
				return;
			}
			//如果选了4级地址，一定要选6级地址
			if(add4_id!=""){
				add6_id = $("#info_colle_edit_address6").combobox("getValue");
				if(add6_id=="" || add6_id==null || add6_id==undefined){
					layer.msg("详细地址必选");
					$("#toInfoCollectSave_btn").removeAttr("disabled");
					return;
				}else{
					//这是选出来的地址
					add6_id = $("#info_colle_edit_address6").combobox("getValue");
				}
			}
			//如果没有选择，则地址必填
			var add_name = $("#info_colle_edit_address4").combobox("getText");
			if(add_name==""){
				layer.msg("详细地址必填");
				$("#toInfoCollectSave_btn").removeAttr("disabled");
				return;
			}
		}

		var info_colle_edit_village_id = "";
		var info_colle_edit_village_name = "";
		//自己手工填写的，这两个值相等
		if($("#info_colle_edit_village_name").combobox("getValue")==$("#info_colle_edit_village_name").combobox("getText") || $("#info_colle_edit_village_name").combobox("getText")=="全部"){
		}else{
			//这是选出来的地址
			info_colle_edit_village_id = $("#info_colle_edit_village_name").combobox("getValue");
		}
		info_colle_edit_village_name = $("#info_colle_edit_village_name").combobox("getText");
		if(info_colle_edit_village_name=="全部")
			info_colle_edit_village_name = "";

		//表格重置
		var info_colle_edit_cellphone1_phoneNum = $.trim($("#info_colle_edit_cellphone1_phoneNum").val());
		var info_colle_edit_cellphone2_phoneNum = $.trim($("#info_colle_edit_cellphone2_phoneNum").val());
		var info_colle_edit_cellphone3_phoneNum = $.trim($("#info_colle_edit_cellphone3_phoneNum").val());
		var info_colle_edit_kd_phoneNum = $.trim($("#info_colle_edit_kd_phoneNum").val());
		var info_colle_edit_ds_phoneNum = $.trim($("#info_colle_edit_ds_phoneNum").val());

		var info_colle_edit_cellphone1_operators_type = $.trim($("#info_colle_edit_cellphone1_operators_type option:selected").val());
		var info_colle_edit_cellphone2_operators_type = $.trim($("#info_colle_edit_cellphone2_operators_type option:selected").val());
		var info_colle_edit_cellphone3_operators_type = $.trim($("#info_colle_edit_cellphone3_operators_type option:selected").val());
		var info_colle_edit_kd_operators_type = $.trim($("#info_colle_edit_kd_operators_type option:selected").val());
		var info_colle_edit_ds_operators_type = $.trim($("#info_colle_edit_ds_operators_type option:selected").val());

		var info_colle_edit_cellphone1_pay = $.trim($("#info_colle_edit_cellphone1_pay").val());
		var info_colle_edit_cellphone2_pay = $.trim($("#info_colle_edit_cellphone2_pay").val());
		var info_colle_edit_cellphone3_pay = $.trim($("#info_colle_edit_cellphone3_pay").val());
		var info_colle_edit_kd_pay = $.trim($("#info_colle_edit_kd_pay").val());
		var info_colle_edit_ds_pay = $.trim($("#info_colle_edit_ds_pay").val());

		var info_colle_edit_cellphone1_date = $.trim($('#info_colle_edit_cellphone1_date').datebox('getValue'));
		if (info_colle_edit_cellphone1_date != "")
			info_colle_edit_cellphone1_date = info_colle_edit_cellphone1_date.replace(/年|月|日/g, '-').substr(0, info_colle_edit_cellphone1_date.length - 1);
		var info_colle_edit_cellphone2_date = $.trim($('#info_colle_edit_cellphone2_date').datebox('getValue'));
		if (info_colle_edit_cellphone2_date != "")
			info_colle_edit_cellphone2_date = info_colle_edit_cellphone2_date.replace(/年|月|日/g, '-').substr(0, info_colle_edit_cellphone2_date.length - 1);
		var info_colle_edit_cellphone3_date = $.trim($('#info_colle_edit_cellphone3_date').datebox('getValue'));
		if (info_colle_edit_cellphone3_date != "")
			info_colle_edit_cellphone3_date = info_colle_edit_cellphone3_date.replace(/年|月|日/g, '-').substr(0, info_colle_edit_cellphone3_date.length - 1);
		var info_colle_edit_kd_date = $.trim($('#info_colle_edit_kd_date').datebox('getValue',''));
		if (info_colle_edit_kd_date != "")
			info_colle_edit_kd_date = info_colle_edit_kd_date.replace(/年|月|日/g, '-').substr(0, info_colle_edit_kd_date.length - 1);
		var info_colle_edit_ds_date = $.trim($('#info_colle_edit_ds_date').datebox('getValue',''));
		if (info_colle_edit_ds_date != "")
			info_colle_edit_ds_date = info_colle_edit_cellphone1_date.replace(/年|月|日/g, '-').substr(0, info_colle_edit_ds_date.length - 1);

		//资源信息
		//分纤箱
		var info_colle_edit_fxx = $.trim($("#info_colle_edit_fxx").val());
		//图片
		var info_colle_edit_img_fxx = $("#info_colle_edit_img_fxx").attr("src");
		var info_colle_edit_img_gate = $("#info_colle_edit_img_gate").attr("src");
		var info_colle_edit_img_house = $("#info_colle_edit_img_house").attr("src");

		var info_colle_edit_grid_id = "";
		<!-- 网格经理 -->
		<e:if condition="${sessionScope.UserInfo.LEVEL eq '5'}" var="grid_user">
			info_colle_edit_grid_id = $("#info_colle_edit_grid_id").val();
		</e:if>
		<!-- 非网格经理 -->
		<e:else condition="${grid_user}">
			info_colle_edit_grid_id = $("#info_colle_edit_grid_name").combobox("getValue");
			if($.trim(info_colle_edit_grid_id)=="")
				info_colle_edit_grid_id = "";
		</e:else>
		/*if(info_colle_edit_grid_id==""){
			layer.msg("网格必选");
		}*/

		$.post(parent.url4Query,{"eaction":"saveInfoCollect",
			//"add6":info_colle_edit_address,
			"add6":add6_id,
			"add6_name":add6_name,

			"latn_id":city_id,
			"bureau_no":area_id,
			"union_org_code":substation,
			"grid_id":info_colle_edit_grid_id,
			"village_id_diy":info_colle_edit_village_id,
			"village_id_name":info_colle_edit_village_name,

			"contact_person":info_colle_edit_custom_name,
			"contact_nbr":info_colle_edit_acc_nbr,
			"people_count":info_colle_edit_family_people,

			"phone_nbr":info_colle_edit_cellphone1_phoneNum,
			"phone_nbr1":info_colle_edit_cellphone2_phoneNum,
			"phone_nbr2":info_colle_edit_cellphone3_phoneNum,
			"kd_nbr":info_colle_edit_kd_phoneNum,
			"itv_nbr":info_colle_edit_ds_phoneNum,

			"phone_business":info_colle_edit_cellphone1_operators_type,
			"phone_business1":info_colle_edit_cellphone2_operators_type,
			"phone_business2":info_colle_edit_cellphone3_operators_type,
			"kd_business":info_colle_edit_kd_operators_type,
			"itv_business":info_colle_edit_ds_operators_type,

			"phone_xf":info_colle_edit_cellphone1_pay,
			"phone_xf1":info_colle_edit_cellphone2_pay,
			"phone_xf2":info_colle_edit_cellphone3_pay,
			"kd_xf":info_colle_edit_kd_pay,
			"itv_xf":info_colle_edit_ds_pay,

			"phone_dq_date":info_colle_edit_cellphone1_date,
			"phone_dq_date1":info_colle_edit_cellphone2_date,
			"phone_dq_date2":info_colle_edit_cellphone3_date,

			"kd_dq_date":info_colle_edit_kd_date,

			"itv_dq_date":info_colle_edit_ds_date,

			"fiber_box":info_colle_edit_fxx,

			"fiber_box_places":info_colle_edit_img_fxx,
			"gate_pic":info_colle_edit_img_gate,
			"live_pic":info_colle_edit_img_house,

			"operate_type":operate_type

		},function(data){
			data = $.parseJSON(data);
			if(data<0){
				layer.msg("该地址已被编辑过，请尝试编辑");
				return;
			}
			if(data>0){
				layer.msg("保存成功");
				setTimeout(function(){
					parent.closeWinInfoCollectionEdit(add6_id,city_id,area_id,substation,grid_id);
				},2000);
			}else{
				layer.msg("保存失败");
			}
		});
	}

	//获取位置
  function setPosition(){
  	//地市编码为空，则是从楼宇视图中点击的。否则是从竞争收集中点击的。
  	if(city_id=="undefined" || city_id=="null" || city_id==null || city_id==""){
		if(parent.global_position_build_view!=undefined){
			$("#info_colle_edit_latn_name").text(parent.global_position_build_view[0]);
			$("#info_colle_edit_bureau_name").text(parent.global_position_build_view[1]);
			$("#info_colle_edit_sub_name").text(parent.global_position_build_view[2]);
			$("#info_colle_edit_grid_name").combobox("setText",parent.global_position_build_view[3]);
			$("#info_colle_edit_village_name").text(parent.global_position_build_view[4]);
		}
  	}else{
  		$.post(parent.url4Query,{"eaction":"getPosition","city_id":city_id,"area_id":area_id,"sub_id":substation,"grid_id":grid_id},function(data){
	  		data = $.parseJSON(data);
	  		$("#info_colle_edit_latn_name").text(data.LATN_NAME);
		  	$("#info_colle_edit_bureau_name").text(data.BUREAU_NAME);
		  	$("#info_colle_edit_sub_name").text(data.BRANCH_NAME);
			$("#info_colle_edit_grid_name").combobox("setText",data.GRID_NAME);
		  	//$("#info_colle_edit_grid_name").text(data.GRID_NAME);
	  	});
	  	if(add6_id!=""){
	  		$.post(parent.url4Query,{"eaction":"getVillageNameByAdd6","add6":add6_id},function(data){
	  			data = $.parseJSON(data);
				if(data!=null)
	  				$("#info_colle_edit_village_name").combobox("setText",data.VILLAGE_NAME);
				else
					$("#info_colle_edit_village_name").combobox("setText","--");
	  		});
			$("#info_colle_edit_grid_name").combobox("disable");
			$("#info_colle_edit_village_name").combobox("disable");
	  	}
  	}
  }

  //设置没有编辑过资料的六级地址下拉菜单选项
  function setAdd6OptionList(){
  	//$.post(parent.url4Query,{"eaction":"getAdd6ListInSubAndGrid","city_id":city_id,"area_id":area_id,"sub_id":substation,"grid_id":grid_id},function(data){
  	$.post(parent.url4Query,{"eaction":"getAdd4ListInSubAndGrid","city_id":city_id,"area_id":area_id,"sub_id":substation,"grid_id":grid_id,"village_id":village_id},function(data){
  		data = $.parseJSON(data);
  		var arr = new Array();
		for (var i = 0; i < data.length; i++) {
			var obj = data[i];
			var obj_temp = "";
			obj_temp = {text: obj.STAND_NAME_1, value: obj.SEGM_ID};
			arr.push(obj_temp);
		}
		$("#info_colle_edit_address4").combobox({
			data: arr,
			filter: function (q, row) {
				var opts = $(this).combobox('options');
				return row[opts.textField].indexOf(q) > -1;
			},
			onSelect: function (record) {
				//获得标准地址所属的区县、支局、网格
				$.post(parent.url4Query, {"eaction": "getOrgsByResid", "add4": record.value, "city_id":city_id}, function(data){
					data = $.parseJSON(data);
					if(data!=null){
						$("#info_colle_edit_bureau_name").text(data.BUREAU_NAME);
						$("#info_colle_edit_sub_name").text(data.BRANCH_NAME);
						$("#info_colle_edit_grid_name").text(data.GRID_NAME);
					}else{
						$("#info_colle_edit_bureau_name").text("");
						$("#info_colle_edit_sub_name").text("");
						$("#info_colle_edit_grid_name").text("");
					}
				});
				//获得标准地址所属的小区名称
				$.post(parent.url4Query, {"eaction": "getVillageNameByAdd4", "add4": record.value}, function(data){
					data = $.parseJSON(data);
					if(data!=null){
						$("#info_colle_edit_village_name").text(data.VILLAGE_NAME);
					}else{
						$("#info_colle_edit_village_name").text("");
					}
				});
				$.post(parent.url4Query, {"eaction": "getAdd6ByAdd4Id", "add4": record.value}, function (data) {
					data = $.parseJSON(data);
					var arr1 = new Array();
					for (var i = 0; i < data.length; i++) {
						var obj = data[i];
						var obj_temp = "";
						obj_temp = {text: obj.SEGM_NAME_2, value: obj.SEGM_ID_2};
						arr1.push(obj_temp);
					}
					$("#info_colle_edit_address6").combobox({
						data: arr1,
						filter: function (q, row) {
							var opts = $(this).combobox('options');
							return row[opts.textField].indexOf(q) > -1;
						}
					});
				});
			}
		});
  	});
  }

  function testUpload(type){
  	var queryParam = $('#form_'+type).serialize();
  	$('#form_'+type).form('submit', {
			url: parent.url4Query+"?eaction=upload_img",
			data:queryParam,
			onSubmit: function(){
				var isValid = $(this).form('validate');
				if (!isValid){
					return false;
				}
			},
			success: function(data){
				var data = $.trim(data);
				console.log(data);
			}
		});
  }
</script>
