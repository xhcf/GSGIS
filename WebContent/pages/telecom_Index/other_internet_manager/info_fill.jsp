<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<e:description>地市</e:description>
<e:q4l var="areaList">
	SELECT null LATN_ID,'--请选择--' LATN_NAME,'000' latn_ord from dual
	union all
    SELECT T.latn_id LATN_ID, T.latn_name LATN_NAME,latn_ord FROM  ${channel_user}.tb_gis_channel_org T
    WHERE T.latn_id IS NOT NULL

    group by T.latn_id, T.latn_name,latn_ord
    ORDER BY  latn_ord
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="bureauList">
  SELECT '' BUREAU_NO, '--请选择--' BUREAU_NAME from dual
</e:q4l>

<e:description>渠道类型</e:description>
<e:q4l var="channel_type">
    select '10' CODE , '城市商圈' TEXT from dual
    union
    select '20' CODE , '城市社区' TEXT from dual
    union
    select '30' CODE , '核心厅店' TEXT from dual
    union
    select '40' CODE , '农村乡镇' TEXT from dual
    union
    select '999' CODE , '未归类' TEXT from dual
</e:q4l>
<e:q4o var="today">
	select to_char(sysdate,'yyyy-mm-dd') val from dual
</e:q4o>
<html>
<head>
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<script src='<e:url value="resources/app/areaSelect.js?version=New Date()"/>' charset="utf-8"></script>
<link type="text/css" rel="stylesheet" href="info_fill.css?version=1.2">
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<e:script value="/resources/layer/layer.js?version=1.1"/>
<%-- <link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" /> --%>
<style>
	body{font-size:14px;background: #fff;font-family:'微软雅黑'}
	#save_btn,#cancel_btn {cursor:pointer;margin-top:4px;}
	.blue {color:#1a9ed8;}

	.win_title_tag {
		width: 100%;
		position:fixed;
		background: #05418b;
		height:40px;
		line-height:36px;
		top:0px;
	}
	#info_edit_win {/* padding-top:10px; */}
	 .left_area select{width: 33%;height: 30px;}
	 .left_span input{width: 33%;height: 30px;}
	 .right_span{margin-left:6%;}
	 .right_span input{width: 33%;height: 30px;}
	 .right_span select{width: 33%;height: 30px;}
	 .msg_div{margin: 0px 0px;}
	 .msg_div label{margin-right: 1%;}
	  @media screen and (max-height: 1080px){
			 .rightyw_span{margin-left: 15%;}
			 .tab_name_msg{margin-top:9%;}
        }
        @media screen and (max-height: 768px){
			 .rightyw_span{margin-left: 15%;}
			 .tab_name_msg{margin-top:7%;}
        }
   .right {text-align:right;}
   .button_layout{background:none;text-align:center;}
</style>
<script type="text/javascript">
	var sql_url = "<e:url value='pages/telecom_Index/other_internet_manager/viewPlane_tab_village_summary_action.jsp'/>";
	//alert(window.screen.height);
	var default_option = '<option value="">--请选择--</option>';
	var user_level = '${sessionScope.UserInfo.LEVEL}';

	$(function(){
		$("#cancel_btn").bind("click",function(){
			parent.closeWin();
		});
		$("#save_btn").bind("click",function(){save_func()});

		//编辑进来 获取信息
		getInternetMsg();

		//设置高度
		/*if(window.screen.height >= 1080){
			 $("#channel_address").css("width","83%");
		}else{
			 $("#channel_address").css("width","83%");
		}*/

		$("#channel_ave").keyup(function(event){
			vaildOnlyNum(event.target.id);
		});
		$("#channel_area1").keyup(function(event){
			vaildOnlyNum(event.target.id);
		});

	});

	//获取所选网点的信息
	var internet_id = '${param.id}';
	function getInternetMsg(){
		$.ajax({
	        type:"POST",
	        url:sql_url,
	        data:{eaction:'getInternetMsg',id:internet_id},
	        success:function(data){
	        	data = $.trim(data);
				var json = $.parseJSON(data);
				if(json  != null && json != ''){
					$("#latn_name").val(json.LATN_ID);
					$("#latn_name").change();
					$("#bureau_name_tmp").val(json.BUREAU_NO);
					$("#channel_name").val(json.CHANNEL_NAME);
					$("#channel_type").val(json.CHANNEL_TYPE);
					$("#channel_address").val(json.CHANNEL_ADDRESS);
					$("#channel_jing").val(json.CHANNEL_JING);
					$("#channel_wei").val(json.CHANNEL_WEI);
					$("#channel_area1").val(json.CHANNEL_AREA1);
					$("#channel_ave").val(json.SELL_MONTH_CNT);
					var card_ck = document.getElementsByName("hkfg");
					for(var i = 0;i<card_ck.length;i++){
						card_ck[i].checked = false;
					}
					if(json.CARD_DX  == '1'){
						$("input[name='hkfg'][value='1']").attr("checked",true);
					}
					if(json.CARD_YD  == '1'){
						$("input[name='hkfg'][value='2']").attr("checked",true);
					}
					if(json.CARD_LT  == '1'){
						$("input[name='hkfg'][value='3']").attr("checked",true);
					}

					var adv_ck = document.getElementsByName("xcfg");
					for(var i = 0;i<adv_ck.length;i++){
						adv_ck[i].checked = false;
					}
					if(json.ADV_DX  == '1'){
						$("input[name='xcfg'][value='1']").attr("checked",true);
					}
					if(json.ADV_YD  == '1'){
						$("input[name='xcfg'][value='2']").attr("checked",true);
					}
					if(json.ADV_LT  == '1'){
						$("input[name='xcfg'][value='3']").attr("checked",true);
					}

					var head_ck = document.getElementsByName("mtfg");
					for(var i = 0;i<head_ck.length;i++){
						head_ck[i].checked = false;
					}
					if(json.HEAD_DX  == '1'){
						$("input[name='mtfg'][value='1']").attr("checked",true);
					}
					if(json.HEAD_YD  == '1'){
						$("input[name='mtfg'][value='2']").attr("checked",true);
					}
					if(json.HEAD_LT  == '1'){
						$("input[name='mtfg'][value='3']").attr("checked",true);
					}

					if(json.MAIN_YYS  == '0'){
						$("input:radio[value='0']").attr("checked",true);
					}
					if(json.MAIN_YYS  == '1'){
						$("input:radio[value='1']").attr("checked",true);
					}
					if(json.MAIN_YYS  == '2'){
						$("input:radio[value='2']").attr("checked",true);
					}
					if(json.MAIN_YYS  == '3'){
						$("input:radio[value='3']").attr("checked",true);
					}
				}else{

				}
	        },
	        error:function(){
	            layer.msg('查询出错');
	        },
	        complete:function(){

	        }
	    });
	}

	function isNumber(val){
	    var regNum = /^\d+$|^\d*\.\d+$/g;//"^([0-9])[0-9]*(\\.\\w*)?$");
	    if(regNum.test(val)){
	        return true;
	    }else{
	        return false;
	    }
	}

	function vaildOnlyNum(ele_id){
		var value = $("#"+ele_id).val();
		$("#"+ele_id).val(value.replace(/[^0-9.]/g,''));
	}

	//保存
	function save_func(){
		var id = internet_id;
		var latn_id 		= $("#latn_name").val();
		var latn_name 		= $("#latn_name").find("option:selected").text();
		var bureau_no 		= $("#bureau_name").val();
		var bureau_name 	= $("#bureau_name").find("option:selected").text();
			bureau_name == '--请选择--'?'':bureau_name;
		var channel_name 	= $("#channel_name").val();
		var channel_address = $("#channel_address").val();
		var channel_wei = $("#channel_wei").val();
		var channel_jing = $("#channel_jing").val();
		var channel_area 	= $("#channel_area").val();
		var channel_area1 	= $("#channel_area1").val();
		var channel_type 	= $("#channel_type").val();
		var channel_type_name 	= $("#channel_type_name").val();
		var channel_ave 	= $("#channel_ave").val();
		debugger;
		if(latn_id == '' || latn_id == '999' || latn_id == ' ' || latn_id == null){
			alert("请选择地市");
			return;
		}
		if(channel_name == '' || channel_name == ' ' || channel_name == null){
			alert("请输入门店名称");
			return;
		}
		if(channel_type == '' || channel_type == ' ' || channel_type == null){
			alert("请选择门店类型");
			return;
		}
		if(channel_ave == '' ){
			alert("请输入正确的月均销量");
			return;
		}else if(!isNumber(channel_ave)){
			alert("请输入正确的月均销量");
			return;
		}
		if(channel_area1 == '' ){
			alert("请输入正确的门店面积");
			return;
		}else if(!isNumber(channel_area1)){
			alert("请输入正确的门店面积");
			return;
		}
		if(channel_address == '' || channel_address == ' ' || channel_address == null){
			alert("请输入门店地址");
			return;
		}
		var card_dx = '0',card_yd = '0',card_lt = '0';
		$("input[name='hkfg']:checked").each(function(){
			if($(this).val() == 1){
				card_dx = 1;
			}else if($(this).val() == 2){
				card_yd = 1;
			}else{
				card_lt = 1;
			}
		});
		var adv_dx = '0',adv_yd = '0',adv_lt = '0';
		$("input[name='xcfg']:checked").each(function(){
			if($(this).val() == 1){
				adv_dx = 1;
			}else if($(this).val() == 2){
				adv_yd = 1;
			}else{
				adv_lt = 1;
			}
		});
		var head_dx = '0',head_yd = '0',head_lt = '0';
		$("input[name='mtfg']:checked").each(function(){
			if($(this).val() == 1){
				head_dx = 1;
			}else if($(this).val() == 2){
				head_yd = 1;
			}else{
				head_lt = 1;
			}
		});
		var main_yys = '0';
		main_yys = $("input[name='hkzt']:checked").val();

		$.post(sql_url,{
			"eaction":"saveInternetInfo",
			"id":id,
			"latn_id":latn_id,
			"latn_name":latn_name,
			"bureau_no":bureau_no,
			"bureau_name":bureau_name,
			"channel_name":channel_name,
			"channel_address":channel_address,
			"channel_jing":channel_jing,
			"channel_wei":channel_wei,
			"channel_area":channel_area,
			"channel_area1":channel_area1,
			"channel_type":channel_type,
			"channel_type_name":channel_type_name,
			"channel_ave":channel_ave ,
			//"channel_hkfg":channel_hkfg,
			//"channel_xcfg":channel_xcfg,
			//"channel_mtfg":channel_mtfg,
			//"channel_hkzt":channel_hkzt
			"card_dx":card_dx,
			"card_yd":card_yd,
			"card_lt":card_lt,

			"adv_dx":adv_dx,
			"adv_yd":adv_yd,
			"adv_lt":adv_lt,

			"head_dx":head_dx,
			"head_yd":head_yd,
			"head_lt":head_lt,

			"main_yys":main_yys
		},function(data){
			var data = $.parseJSON(data);
			if(data){
				layer.msg("保存成功",{time:3000});
				parent.query();
				parent.closeWin();
			}else{
				layer.msg("保存失败");
			}
		});
	}

	function vaild(value){
		return value=="" || value=="undefined" || value==null || value=="null";
	}

	function valFilter(value){
		return $.trim(value.replace(/[\n\r]/g, ""));
	}
		//地市change事件
	function latnChange(){
		$("select[name='bureau_name']").empty();
		$("select[name='bureau_name']").append(default_option);
		getBureauByLatn();
	}
	//获取区县
	function getBureauByLatn(){
		//分公司no
		var area_no = $.trim($("#latn_name").val());
		if(area_no!=""){
			$.post(sql_url,{eaction:'getBureauByCityId',city_id:area_no},function(data){
				data = $.trim(data);
				data = $.parseJSON(data);
				$.each(data,function(index,value){
					$("select[name='bureau_name']").append('<option value="'+value.BUREAU_NO+'">'+value.BUREAU_NAME+'</option>');
				});
				$("#bureau_name").val($("#bureau_name_tmp").val());
			});
		}
	}
	function bureauChange(){
		var latn_id = $("#latn_name").val();
	}
</script>
<style>
	span {font-size:14px;}
	#info_pop_win{background: #fff;}
	.tab_name_area{position:absolute;margin-top: 7px;font-weight: bold;color: blue;margin-left: 2%;}
	.tab_name_msg{position:absolute;font-weight: bold;color: blue;margin-left: 2%;}
	.tab_name_service{position:absolute;margin-top:2.5%;font-weight: bold;color: blue;margin-left: 2%;}
	.record_tit_layout:nth-child(2){border-top:none;}
	.record_tit_layout:nth-child(3){border-top:none;}
	.record_tit_layout:nth-child(4){border:none;}
	.head {width:95.2%;height:20px;line-height:20x;margin-left:2%;border-bottom:1px solid #ddd;color:#2427A8;font-size:14px;font-weight:bold;}
	.head_before {
    width:3px;
    background:#2427A8;
    height:20px;
    line-height:20px;
  	display:block;
  	float:left;
  	margin-right:5px;
  }
	.tab {width:95%;margin:1% auto;margin-bottom:1%;margin-top:0px;font-size:14px;}
	.tab tr {height:35px;}
	input,select,span {width:100%;height:30px;}
	label {width:22%;display:inline-block;}
	label input{width:auto;height:13px;line-height:30px;}
	#info_edit_win{padding-top:10px;}
	.button_layout {margin-top:1.5%;}
	input {border:none;border-bottom:1px solid #ddd;}
	select {border-color:#ddd;}
	</style>
</head>
<body style="overflow: hidden;">
	<div id="info_pop_win">

		<div class="wrapper" id="info_edit_win">
			<div class="head">
				<span class="head_before"></span>归属信息
			</div>
			<table class="tab">
				<tr>
					<td style="width:10%;" class="right">门店名称：</td><td style="width:40%;"><input type="text" value = "" id="channel_name" placeholder="请输入门店名称"/></td>
					<td style="width:10%;" class="right">门店类型：</td>
					<td style="width:40%;">
						<select id="channel_type" name="channel_type"">
							<option value="">--请选择--</option>
							<option value="10">城市商圈</option>
							<option value="20">城市社区</option>
							<option value="30">核心厅店</option>
							<option value="40">农村乡镇</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="right">地&emsp;&emsp;市：</td>
					<td>
						<select id="latn_name" name="latn_name" style="height:30px;" onchange="latnChange()">
							<e:forEach var="latn_item" items="${areaList.list}">
								<e:if condition="${empty latn_item.LATN_ID}">
									<option value="${latn_item.LATN_ID}" selected="selected">${latn_item.LATN_NAME}</option>
								</e:if>
								<e:if condition="${!empty latn_item.LATN_ID}">
									<option value="${latn_item.LATN_ID}">${latn_item.LATN_NAME}</option>
								</e:if>
							</e:forEach>
						</select>
					</td>
					<td class="right">区&emsp;&emsp;县：</td>
					<td>
							<select id="bureau_name" style="height:30px;" name="bureau_name" onChange="bureauChange();">
								<option value="">--请选择--</option>
							</select>
					</td>
				</tr>
				<tr>
					<td class="right">创&ensp;建&ensp;人：</td>	<td>${sessionScope.UserInfo.USER_NAME}</td>
					<td class="right">创建时间：</td><td>${today.VAL}</td>
				</tr>
			</table>
			<!--基本信息end-->
			<!--小区现状-->
			<!-- <div class="record_tit ico2">门店基础信息</div> -->
			<div class="head">
				<span class="head_before"></span>基本信息
			</div>
			<table class="tab">
				<tr>
					<td style="width:10%;" class="right">月均销量：</td><td style="width:40%;"><input type="text" value = "" id="channel_ave" placeholder="请输入月均销量"/></td>
					<td style="width:10%;" class="right">门店面积：</td><td style="width:40%;"><input type="text" value = "" id="channel_area1" placeholder="请输入门店面积"/></td>
				</tr>
				<tr>
					<td class="right">经&emsp;&emsp;度：</td><td><input type="text" value = "" id="channel_jing" placeholder="请输入经度"/></td>
					<td class="right">纬&emsp;&emsp;度：</td><td><input type="text" value = "" id="channel_wei" placeholder="请输入纬度"/></td>
				</tr>
				<tr>
					<td class="right">门店地址：</td><td colspan="3"><input type="text" value = "" id="channel_address" placeholder="请输入门店地址"/></td>
				</tr>
			</table>

			<div class="head">
				<span class="head_before"></span>业务覆盖
			</div>
			<table class="tab">
				<tr>
					<td style="width:10%;" class="right">号卡覆盖：</td>
					<td style="width:40%;">
						<span>
							<label><input type="checkbox" value = "1" name="hkfg"/><span>电信</span></label>
							<label><input type="checkbox" value = "2" name="hkfg"/><span>移动</label>
							<label><input type="checkbox" value = "3" name="hkfg"/><span>联通</span></label>
						</span>
					</td>
					<td style="width:10%;" class="right">宣传覆盖：</td>
					<td style="width:40%;">
						<span>
							<label><input type="checkbox" value = "1" name="xcfg"/><span>电信</span></label>
							<label><input type="checkbox" value = "2" name="xcfg"/><span>移动</span></label>
							<label><input type="checkbox" value = "3" name="xcfg"/><span>联通</span></label>
						</span>
					</td>
				</tr>
				<tr>
					<td class="right">门头覆盖：</td>
					<td>
						<span>
							<label><input type="checkbox" value = "1" name="mtfg"/><span>电信</span></label>
							<label><input type="checkbox" value = "2" name="mtfg"/><span>移动</span></label>
							<label><input type="checkbox" value = "3" name="mtfg"/><span>联通</span></label>
						</span>
					</td>
					<td class="right">号卡主推：</td>
					<td>
						<span>
							<label><input type="radio" value = "1" name="hkzt"/><span>电信</span></label>
							<label><input type="radio" value = "2" name="hkzt"/><span>移动</span></label>
							<label><input type="radio" value = "3" name="hkzt"/><span>联通</span></label>
							<label><input type="radio" value = "0" name="hkzt"/><span>无主推</span></label>
						</span>
					</td>
				</tr>
			</table>

		<!--小区现状end-->
		<!--目标制定-->
		<!-- <div class="record_tit ico3">门店业务覆盖</div> -->
		<!--适配政策end-->
		<!-- <div class="button_layout"><button id="save_btn">保存</button><button id="cancel_btn">取消</button></div> -->
	</div>
	<div class="button_layout"><button id="save_btn">保存</button><button id="cancel_btn">取消</button></div>
</div>
<input type="hidden" value="" id="bureau_name_tmp"/>
</body>
</html>