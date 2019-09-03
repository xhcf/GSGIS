<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="initTime">
	select max(USED_VIEW) as val from edw.tb_cde_process_para@gsedw t   WHERE T.USERD_NAME='TB_MKT_BILL_INFO'
</e:q4o>
<html>
<head>
	<title>执行窗口</title>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/pages/telecom_Index/common/js/md5.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/pages/telecom_Index/common/js/sip-0.7.3.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/pages/telecom_Index/common/js/callCenter.js?version=1.5"/>'></script>
	<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.3" />' rel="stylesheet" type="text/css" media="all" />
	<meta name="apple-mobile-web-capable" content="yes">
	<style>
		#execute_tab_content {height:62%;position: relative;}
		#advise_h3,#advise_tab{display:none;}
		.exec_his_recode{float:right;display: inline-block;font-size:12px;line-height:24px;height:24px;}
		#advise_tab {max-height:80px;}
		.zx_blk{overflow-y:scroll;overflow-x:hidden;padding-right:10px;}

		.village_advise_head,.village_advise_body {width:96%;font-size:12px;margin:0 auto;}
		.village_advise_head {margin-top:1%;}
		.village_advise_body {margin-bottom:1%;}
		.village_advise_head tr th{
			border-collapse: collapse;
			border: solid 1px #e4e4e4;
			background: #108ee9;
			color: #fff;
			font-weight: normal;
			font-size: 12px;
			height: 25px;
		}
		.village_advise_head tr th:first-child{width:10%}
		.village_advise_head tr th:nth-child(2){width:15%}
		.village_advise_head tr th:nth-child(3){width:75%}

		.village_advise_body tr td{
			border-collapse: collapse;
			border-top: solid 1px #d7d7d7;
			/*border: solid 1px #d7d7d7;*/
			height: 26px;
			text-align: center;
			padding:5px 0px;
			padding-left:3%;
		}
		.village_advise_body tr td:first-child{width:10%}
		.village_advise_body tr td:nth-child(2){width:15%}
		.village_advise_body tr td:nth-child(3){width:75%}

		/*小区营销*/
		#village_tab{height:auto;display:none;}

		.advise_div {
			display: block;
			float: left;
			height: 100%;
			margin-right:10px;
		}
		.advise_div span {
			font-weight: bold;
			/*color:#108ee9;*/
			color:red;
		}

		.scene_class {font-weight: bold;margin-left:5px;color:#108ee9;}

		#call_history_body {
			width: 96%;
			margin: 0px auto;
		}
		#call_history_head tr th:first-child{width:5%}
		#call_history_head tr th:nth-child(2){width:10%}
		#call_history_head tr th:nth-child(3){width:15%}
		#call_history_head tr th:nth-child(4){width:20%}
		#call_history_head tr th:nth-child(5){width:20%}
		#call_history_head tr th:nth-child(6){width:20%}
		#call_history_head tr th:nth-child(7){width:5%}
		#call_history_head tr th:nth-child(8){width:5%}

		#call_history_list tr td:first-child{width:5%}
		#call_history_list tr td:nth-child(2){width:10%}
		#call_history_list tr td:nth-child(3){width:15%}
		#call_history_list tr td:nth-child(4){width:20%}
		#call_history_list tr td:nth-child(5){width:20%}
		#call_history_list tr td:nth-child(6){width:20%}
		#call_history_list tr td:nth-child(7){width:5%}
		#call_history_list tr td:nth-child(8){width:5%}

		#call_history_head tr th,#call_history_list table tr td {font-size:12px;text-align:center;border:1px solid;}
		#call_history_head tr th {border-color:#fff;}
		#call_history_list table tr td {border-color:#c9c9ca;}
		#call_history_head,#call_history_list,#call_history_list table {width:100%;}

		#call_history_head tr {
			/*background: #1e6ee7;
			color: #fff;
			*/
			background: #d9d9d9;
			height: 40px;
			color:#000;
			font-weight: bold;
		}

		#call_history_head,#call_history_list table {border-collapse: collapse;}
		#call_history_list {overflow-y:scroll;height:80%;}

		#recode {font-size:12px;height:25px;line-height:25px;vertical-align: middle;}
		#total_num,#total_page {color:red;}

		/*外呼窗口*/
		#call_out_win {display:none;width:250px;height:300px;background-image: url("<e:url value='pages/telecom_Index/common/images/call_out_bg.jpg' />")}
		.call_cancel,.call_bye {cursor:pointer;width:55px;height:55px;background-size:55px;background-repeat:no-repeat;background-color:transparent;border:none;display:inline-block;}
		.call_cancel {display:none;background-image: url("<e:url value='pages/telecom_Index/common/images/call_cancel.png' />")}
		.call_bye {background-image: url("<e:url value='pages/telecom_Index/common/images/call_bye.png' />")}
		#call_status,#call_who {text-align:center;height:20px;width:100%;}
		#call_who {color:#fff;position:absolute;top:15px;text-align: center;font-size:15px;}
		#call_status {color:#fff;position:absolute;top:35px;text-align: center;font-size:15px;}
	</style>
</head>
<body style="margin:0px;">
<div style="display: none">
	<video id="right_video" ></video>
</div>
<div class="jz_btn">
	<button class="save_btn" id="call_out">外呼</button>
	<button class="save_btn" id="call_history">外呼历史</button>
	<button class="save_btn" id="save_exe">执行</button>
	<button class="cancel_btn" id="cancel_exe">取消</button>
</div>
<div class="zx_blk">
	<h3 id="advise_h3">营销推荐</h3>
	<div id="advise_tab">
		<table cellspacing="0" cellpadding="0" border="0" class="zx_in">
			<tr><th width="15%">销售品推荐：</th><td id="advise_produce"></td></tr>
			<tr><th width="15%">营&nbsp;销&nbsp;术&nbsp;语：</th><td id="advise_content"></td></tr>
		</table>
	</div>
	<div id="village_tab">
		<table cellspacing="0" cellpadding="0" border="0" class="village_advise_head" style="display:none;">
			<tr><th>序号</th><th>号码</th><th>推荐信息</th></tr>
		</table>
		<table cellspacing="0" cellpadding="0" border="0" class="village_advise_body" id="village_advise_list">
		</table>
	</div>
	<h3>营销执行</h3>
	<div>
		<table cellspacing="0" cellpadding="0" border="0" class="zx_in">
			<tr>
				<th width="15%">接触方式：</th>
				<td><input type="radio" name="contactType" value="1" checked="checked"/>电话  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="contactType" value="2"/>上门  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="contactType" value="3"/>门店</td>
			</tr>
			<tr>
				<th>执行结果：</th>
				<td>
					<input type="radio" name="XXJ" value="2" checked="checked"/>同意办理 <span style="color:red;" id="jump_crm_tip">（可转CRM甩单受理）</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="XXJ" value="1" />有意向&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="XXJ" value="3" />不需要&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="XXJ" value="4" />无法联系
				</td>
			</tr>
			<tr>
				<th>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</th>
				<td>&nbsp;<input type="text" style="width:60%;" id="remark_note"/></td>
			</tr>
			<input type="hidden" id="execute_orderId" value=""/>
			<input type="hidden" id="execute_prodinstId" value=""/>
		</table>
	</div>
	<h3 style="display: inline-block;">执行历史</h3><span class="exec_his_recode" id="exec_history_cnt" style="margin-right:4%;"></span><span class="exec_his_recode">记录数：</span>
	<div style="height:42%">
		<div class="tab_header_zx" >
			<table cellspacing="0" cellpadding="0" border="0">
				<tr>
					<th>序号</th>
					<th>执行时间</th>
					<th>执行人</th>
					<th>接触方式</th>
					<th>执行状态</th>
					<th>执行说明</th>
				</tr>

			</table>
		</div>
		<div class="tab_body_zx">
			<table cellspacing="0" cellpadding="0" border="0" id="history_list">
			</table>
		</div>
	</div>
</div>
<div id="call_history_div" style="display:none;">
	<div id="call_history_body">
		<div id="recode">总记录数：<span id="total_num"></span>&nbsp;&nbsp;&nbsp;&nbsp;总页数：<span id="total_page"></span></div>
		<div style="padding-right:15px;">
			<table id="call_history_head">
				<thead>
					<th>序号</th>
					<th>座席<br/>编号</th>
					<th>被叫号码</th>
					<th>开始时间</th>
					<th>应答时间</th>
					<th>挂断时间</th>
					<th>是否<br/>接通</th>
					<th>计费<br/>时间</th>
				</thead>
			</table>
		</div>
		<div id="call_history_list">
			<table>

			</table>
		</div>
	</div>
</div>
<div id="call_out_win">
	<div style="" id="call_who"></div>
	<div style="" id="call_status"></div>
	<div style="position: absolute;bottom:25px;padding-left:97.5px;">
		<div class="call_bye" id="call_bye" title="挂断"></div><!--挂断-->
		<div class="call_cancel" id="call_cancel" title="结束"></div><!--取消呼叫-->
	</div>
</div>

<script type="text/javascript">
	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
	var prod_inst_id = '${param.prod_inst_id}';
	var segment_id = '${param.segment_id}';
	var add6 = '${param.add6}';
	var order_id = '${param.order_id}';
	var scene_id = '${param.scene_id}';
	var is_village = '${param.is_village}';
	var is_track = '${param.is_track}';
	var accept_type = '${param.accept_type}';

	if(order_id=='undefined')
		order_id = "";
	if(scene_id=='undefined')
		scene_id = "";
	if(is_village=='undefined')
		is_village = "";
	console.log(is_village);

	var url4Query_sandBox = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox.jsp"/>';
	var url4Query_custom = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp"/>';
	//var flag = '${param.flag}';
	//var build_position = parent.build_position;
	var is_yx = '${param.is_yx}';
	var acct_month = '${initTime.VAL}';
	var my_phone = '${sessionScope.UserInfo.telephone}';

	$(function () {
		//当是单转融和合约到期的时候显示“（可转CRM甩单受理）”，否则隐藏
		if(scene_id!=10 && scene_id!=11){
			$("#jump_crm_tip").hide();
		}else{
			$("#jump_crm_tip").show();
		}

		$("#execute_prodinstId").val(prod_inst_id);
		$("#execute_orderId").val(order_id);
		query_yx_history(prod_inst_id);

		//外呼
		$("#call_out").on("click",function(){
			call_out();
		});
		//外呼挂断
		/*$("#call_bye").on("click",function(){
			call_bye();
		});*/
		//外呼取消
		$("#call_cancel").on("click",function(){
			layer.close(call_out_handler);
			//call_cancel();
		});
		//外呼历史
		$("#call_history").on("click",function(){
			call_history();
		});
		$("#save_exe").on("click",function(){
			execute_update();
		});
		$("#cancel_exe").on("click",function(){
			try{
				if(is_track=="")
					parent.yx_load_intraday_data_view();
				parent.closeWinInfoCollectionEdit();
			}catch(e){
				parent.closeWinInfoCollectionEdit();
			}
		});
		console.log("prod_inst_id:"+prod_inst_id);
		console.log("is_yx:"+is_yx);
		console.log("global_village_cell:"+parent.parent.global_current_index_is_village_cell);
		if(is_yx!="undefined" && is_yx!=""){
			debugger;
			if(parent.parent.global_current_index_is_village_cell=="1"){
				var url = '<e:url value="pages/telecom_Index/common/sql/tabData_village_cell.jsp" />';
				$.post(url,{"eaction":"getMktReasonByProdInstId","prod_inst_id":prod_inst_id},function(data1){
					console.log("data1:"+data1);
					var mkt_reason = $.parseJSON(data1);
					if(mkt_reason!=null)
						$("#advise_content").text(mkt_reason.CONTACT_SCRIPT);
				});
			}else{
				$.post(url4Query_sandBox,{"eaction":"getMktReasonByOrderId","prod_inst_id":prod_inst_id,"scene_id":scene_id,"is_track":is_track},function(data){
					if(data==null)
						$("#advise_content").text("");
					else{
						var d = $.parseJSON(data);
						if(d!=null)
							$("#advise_content").text(d.MKT_REASON);
					}
				});
			}

			$.post(url4Query_custom,{"eaction":"incoming_arpu","acct_month":acct_month,"prod_inst_id":prod_inst_id},function(data){
				var d0 = $.parseJSON(data);
				if(d0.length){
					var d = d0[0];
					$.post(url4Query_sandBox,{"eaction":"getMktProduceAdvice","arpu": d.SERV_ARPU},function(data1){
						var d1 = $.parseJSON(data1);
						if(d1==null)
							$("#advise_produce").text("");
						else
							$("#advise_produce").text(d1.TC_NAME);
					});
				}else{
					$("#advise_produce").text("");
				}
			});
			$("#advise_h3").show();
			$("#advise_tab").show();
		}
		//小区营销
		if(is_village!="undefined" && is_village!=""){
			$("#village_advise_list").show();
			$.post(url4Query_custom,{"eaction":"getVillageAdvise","prod_inst_id":prod_inst_id,"add6":add6},function(data){
				var list = $.parseJSON(data);
				if(list.length){
					var data_array = new Array();
					for(var i= 0,l = list.length;i<l;i++){
						var d = list[i];
						var item = data_array[d.ACC_NBR];
						console.log(d,item);
						if(item==undefined)
							item = new Array();

						item.push({"tj":"推荐"+(item.length+1), "scene_name":d.SCENE_NAME,"scene_script": d.CONTACT_SCRIPT});
						data_array[d.ACC_NBR] = item;
					}
					var keys = Object.keys(data_array);

					/*
					20190114 营销推荐样式修改 营销术语去掉表头
					for(var j= 0,k=keys.length;j<k;j++){
						var key = keys[j];
						var advises = data_array[key];
						var row = "<tr>";
						console.log("advises.length:"+advises.length);
						row += "<td rowspan='"+advises.length+"'>"+(j+1)+"</td>";
						row += "<td rowspan='"+advises.length+"'>"+ phoneHide(key)+"</td>";

						var item0 = advises[0];
						row += "<td style='text-align: left;'><div class='advise_div'><span>"+item0.tj+"</span></div><div style='padding-left:5px;'><span style='font-weight: bold;color:#108ee9;'>"+item0.scene_name+"</span><br/><span>"+item0.scene_script+"</span></div></td>";
						row += "</tr>";

						$("#village_advise_list").append(row);

						var row1 = "";
						for(var m= 1,n=advises.length;m<n;m++){
							var advise = advises[m];
							row1 = "<tr>";
							row1 += "<td style='text-align: left;'><div class='advise_div'><span>"+advise.tj+"</span></div><div style='padding-left:5px;'><span style='font-weight: bold;color:#108ee9;'>"+advise.scene_name+"</span><br/><span>"+advise.scene_script+"</span></div></td>";
							row1 += "</tr>";
							$("#village_advise_list").append(row1);
						}
					}*/

					for(var j= 0,k=keys.length;j<k;j++){
						var key = keys[j];
						var advises = data_array[key];
						//var row = "<tr>";
						//row += "<td rowspan='"+advises.length+"'>"+(j+1)+"</td>";
						//row += "<td rowspan='"+advises.length+"'>"+ phoneHide(key)+"</td>";

						var item0 = advises[0];
						//row += "<td style='text-align: left;'><div class='advise_div'><span>"+item0.tj+"</span></div></td>";
						//row += "<td style='text-align: left;'><span>"+phoneHide(key)+"</span><span style='font-weight: bold;color:#108ee9;'>"+item0.scene_name+"</span><br/><span>"+item0.scene_script+"</span></td>";
						//row += "</tr>";

						//$("#village_advise_list").append(row);

						var row1 = "";
						for(var m= 0,n=advises.length;m<n;m++){
							var advise = advises[m];
							var row1 = "<tr>";
							if(m>0)
								row1 += "<td style='text-align: left;'><div class='advise_div'><span>"+advise.tj+"</span></div><span>"+phoneHide(key)+"</span><span class='scene_class'>【"+advise.scene_name+"】</span><br/><span>"+advise.scene_script+"</span></td>";
							else
								row1 += "<td style='text-align: left;border:none;'><div class='advise_div'><span>"+advise.tj+"</span></div><span>"+phoneHide(key)+"</span><span class='scene_class'>【"+advise.scene_name+"】</span><br/><span>"+advise.scene_script+"</span></td>";
							row1 += "</tr>";
							//row1 = "<tr>";
							//row1 += "<td style='text-align: left;'><div class='advise_div'><span>"+advise.tj+"</span></div><div style='padding-left:5px;'><span style='font-weight: bold;color:#108ee9;'>"+advise.scene_name+"</span><br/><span>"+advise.scene_script+"</span></div></td>";
							//row1 += "</tr>";
							$("#village_advise_list").append(row1);
						}
					}
				}else{
					$("#village_advise_list").append("<tr><td colspan='3'>暂无数据</td></tr>");
				}
			});

			$("#advise_h3").show();
			$("#village_tab").show();
		}

		var begin_scroll = "";
		$("#call_history_list").scroll(function () {
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - begin_scroll > 500) {
					call_history_list_page(my_phone,page++,call_who);
				}
				begin_scroll = new Date().getTime();
			}
		});
	})

	//外呼
	var fsInfo = {};
	var call_out_handler = "";
	function call_out(){
		$("#call_status").text("正在呼叫...");
		if(my_phone==''){
			layer.msg("没有关联的主叫号码，请重新绑定");
			return;
		}
		call_out_handler = layer.open({
			type: 1,
			title: "电话拨出",
			area: call_out_win_size,
			skin: 'call_out',
			content: $('#call_out_win'),
			cancel: function(index, layero){
				if(confirm('确定结束通话？')){ //只有当点击confirm框的确定时，该层才会关闭
					call_cancel();
					layer.close(call_out_handler);
					layer.close(index);
				}
				return false;
			}
		});
		//var call_out_login = "https://60.164.231.147:8443/51Call/companyUsers/doLoginForCallcenter.html";
		//my_phone = '13369454943';///测试
		var call_out_login = "https://135.149.47.199:8443/51Call/companyUsers/doLoginForCallcenter.html";
		var login_params = "?username="+my_phone+"&securityinfo="+("Zh@"+my_phone)+"&terminalType=3&usercode="+(hex_md5(my_phone+("Zh@"+my_phone)+"GSDX").toUpperCase());
		$.post("<e:url value="accessUrl.e"/>",{"url":call_out_login+login_params},function(data0){
			var d0 = $.parseJSON(data0);
			console.log(d0);
			try{
				if(d0.status!='200'){//登录失败
					layer.close(call_out_handler);
					layer.msg(d0.msg);
					call_cancel();
				}else{//登录成功
					fsInfo.sipID = d0.sipSeatid;
					fsInfo.sipDomain = d0.domain;
					fsInfo.wss_ip = d0.sippath;
					fsInfo.wss_port = d0.sipport;
					fsInfo.sipPasswd = d0.password;
					//初始化控件
					initial_gsgis(fsInfo);
					initial();

					//外呼号码
					debugger;
					var user_contract_num = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp' />";
					$.post(user_contract_num,{"eaction":"baseInfo",'prod_inst_id':'${param.prod_inst_id}'},function(data1){
						var d1 = $.parseJSON(data1);
						var call_who = d1[0].USER_CONTACT_NBR;
						///call_who = '17793102293';///测试
						if(call_who=='' || call_who=='null'){
							layer.msg("没有被叫方电话号码，请核实数据");
							return;
						}
						$("#call_who").text(phoneHide(call_who));
						//sendSipInviteRequest(call_who+"");
						sendSipInviteRequest(d1[0].USER_CONTACT_NBR_CALL+"");
					});
				}
			}catch(e){
				console.log(e);
				layer.msg(e);
			}
		});
	}

	//外呼挂断
	function call_bye(){
		if(sessionUI.isClose==1){
			//layer.msg("不在通话中");
			return;
		}
		sessionUI.session.bye();
	}

	//外呼取消
	function call_cancel(){
		if(sessionUI.isClose==1){
			//layer.msg("不在通话中");
			return;
		}
		sessionUI.session.cancel();
	}

	function initial_gsgis(fsInfo){
		var uri = fsInfo.sipID+'@'+fsInfo.sipDomain;
		var wssStr='wss://'+fsInfo.wss_ip+':'+fsInfo.wss_port;
		var config = {
			uri: uri,
			wsServers: wssStr,
			authorizationUser: fsInfo.sipID,
			password:  fsInfo.sipPasswd,
			userAgentString: "SIP.js/0.7.0 BB",
			iceCheckingTimeout: 500,
			rel100:SIP.C.supported.SUPPORTED,
			registerExpires: 60,
			traceSip: true
		};
		/*var uri = '1022@1493979535316.com';
		var wssStr='wss://yy.91callcenter.cn:17443';
		var config = {
			uri: uri,
			wsServers: wssStr,
			authorizationUser: 1022,
			password: 19027161,
			userAgentString: "SIP.js/0.7.0 BB",
			iceCheckingTimeout: 500,
			rel100:SIP.C.supported.SUPPORTED,
			registerExpires: 60,
			traceSip: true
		};*/
		ua = new SIP.UA(config);
	}
	var hasNoData = true;
	var order = 1;
	function call_history_list_page(my_phone,page,call_who){
		var call_history = "https://135.149.47.199:8443/51Call/callrecord/QueryRecordForOther.html";
		var histroy_params = "?username="+my_phone+"&companyid=3&page="+page+"&phone="+call_who;
		$.post("<e:url value="accessUrl.e"/>",{"url":call_history+histroy_params},function(data2){
			var d2 = $.parseJSON(data2);
			console.log(data2+"");
			if (d2.TSR_CODE != '1') {//查询失败
				layer.msg(d2['TSR_MSG']);
				if(hasNoData){
					$("#call_history_list > table").empty();
					$("#call_history_list > table").append("<tr><td colspan=7 style='text-align:center;'>暂无数据</td></tr>");
					$("#total_num").text("0");
					$("#total_page").text("0");
				}
				return;
			} else {
				var list = d2.list;
				if(list.length>0)
					hasNoData = false;
				$("#total_num").text(d2.totalSize);
				$("#total_page").text(d2.pageSize);
				for (var i = 0, l = list.length; i < l; i++) {
					var item = list[i];
					var tr_str = "<tr>";
					tr_str += "<td>" + (order++) + "</td>";
					tr_str += "<td>" + item.callernum + "</td>";
					tr_str += "<td>" + item.calleenum + "</td>";
					tr_str += "<td>" + item.startstamp + "</td>";
					tr_str += "<td>" + item.answerstamp + "</td>";
					tr_str += "<td>" + item.endstamp + "</td>";
					tr_str += "<td>" + (item.isanswer == '1' ? '是' : '否') + "</td>";
					tr_str += "<td>" + item.billsec + "</td>";
					tr_str += "</tr>";
					$("#call_history_list > table").append(tr_str);
				}
			}
		});
	}
	//外呼历史
	var page = 1;
	var call_who = "";
	var call_history_win_size = ['750','400'];
	var call_out_win_size = ['250','336'];
	function call_history(){
		if(my_phone==''){
			layer.msg("没有关联的座席电话号码，请重新绑定");
			return;
		}else{
			var user_contract_num = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp' />";
			$.post(user_contract_num,{"eaction":"baseInfo",'prod_inst_id':'${param.prod_inst_id}'},function(data1){
				var d1 = $.parseJSON(data1);
				if(d1.length==0){
					layer.msg("没有被叫方电话号码，请核实数据");
					return;
				}
				call_who = d1[0].USER_CONTACT_NBR;
				if(call_who=='' || call_who=='null') {
					layer.msg("没有被叫方电话号码，请核实数据");
					return;
				}
				hasNoData = true;
				order = 1;
				call_history_list_page(my_phone,page++,call_who);
				layer.open({
					type: 1,
					title: '通话记录',
					area: call_history_win_size,
					skin: 'call_history',
					content: $('#call_history_div'),
					cancel: function(){
						hasNoData = true;
						order = 1;
					}
				});
			});
		}
	}

	var exec_params = {};

	function execute_update(){
		//if(order_id=="" || order_id==undefined)
		//	alert("没有可执行的工单");
		var staffNo = '${sessionScope.UserInfo.ext30}';
		if(staffNo==''){
			layer.msg("没有关联的划小操作员工号，请重新绑定");
			return;
		}

		var staffName = '${sessionScope.UserInfo.USER_NAME}';
		var orderId = $("#execute_orderId").val();
		var prod_inst_id = $("#execute_prodinstId").val();
		var exec_stat = $("input[name='XXJ']:checked").val();
		var exec_desc = $("#remark_note").val();
		var contactType = $("input[name='contactType']:checked").val();//接触方式

		if(orderId==undefined)
			orderId = "";
		//20180625
		/*if(exec_stat==2){//如果选择了“同意办理”，则跳转crm甩单流程
			console.log("aaa");
			parent.call_execute(prod_inst_id);
			setTimeout(function(){
				//parent.closeWinInfoCollectionEdit();
			},5000);
		}
		return;*/
		console.log("orderId:::"+orderId);
		//测试 http://135.149.64.146:9004/gsch-api/mkt/mktexec
		//正式 http://135.149.64.144:9000/gsch-api/mkt/mktexec

		//小区营销
		if(is_village!="undefined" && is_village!=""){
			var url = '<e:url value="pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp" />';
			console.log("exec_stat:"+exec_stat);
			console.log("exec_desc:"+exec_desc);
			console.log("contactType:"+contactType);
			$.post(url,{"eaction":"exec_update","mkt_campaign_id":'${param.mkt_campaign_id}',"prod_inst_id":prod_inst_id,"pa_date":'${param.pa_date}',"exec_stat":exec_stat,"exec_desc":exec_desc,"contact_type":contactType},function(data){
				var d = $.parseJSON(data);
				if(d=="1"){
					layer.msg("执行成功");
				}else{
					layer.msg("执行失败");
				}
			});
		}else{
			/*$.post('<e:url value="pages/telecom_Index/common/sql/tabData.jsp" />',{"eaction":"getOrderId_oneKeyBuy","mkt_id":scene_id,"prod_inst_id":prod_inst_id},function(data){
				var data = $.parseJSON(data);
				if(data==null){
					layer.msg("营服协同中心工单ID不存在，无法执行");
					return;
				}

				/!*var accept_type = "";
				accept_type = data.ACCEPT_TYPE;*!/


			});*/
			//20190311 营销逻辑修改 先跳转后执行
			//执行参数 调用划小执行接口使用
			exec_params.staffNo = staffNo;
			exec_params.staffName = staffName;
			//exec_params.contact_order_id = data.CONTACT_ORDER_ID;
			exec_params.contact_order_id = orderId;
			exec_params.exec_stat = exec_stat;
			exec_params.exec_desc = exec_desc;
			exec_params.contactType = contactType;
			exec_params.prod_inst_id = prod_inst_id;
			exec_params.scene_id = scene_id;

			parent.yx_exec_params = exec_params;

			if(exec_desc==""){
				layer.msg("执行内容不能为空");
				return;
			}

			//11协议到期、10单转融 且选了同意办理 且accept_type不为0的工单 跳转crm甩单，跳转后再调用 “划小执行”接口
			if((scene_id=='10' || scene_id=='11') && exec_stat==2 && accept_type!='0'){
				debugger;
				parent.call_execute(prod_inst_id);
				setTimeout(function(){
					//parent.closeWinInfoCollectionEdit();
				},5000);
			}else{
				//其他情况 直接调用 “划小执行” 接口
				execute_small_interface(exec_params);
			}
		}
	}

	var url_prefix = "http://135.149.64.144:9000/gsch-api";
	var url6 = "/mkt/mktExecute";
	function execute_small_interface(param){//20190311 营销逻辑修改 先跳转后 执行
		debugger;
		var params_secu = {
			"appId":"GIS-PC",
			"appKey":"",
			"reqTime":"",
			"reqPath":""
		}
		params_secu.reqPath = url6;///
		$.post("<e:url value='makeKey.e' />",params_secu,function(key) {
			var key = $.parseJSON(key);
			params_secu.appKey = key.key_val;
			params_secu.reqTime = key.reqTime;
			params_secu.staffNo = param.staffNo;
			params_secu.staffName = param.staffName;
			params_secu.orderId = param.contact_order_id;
			params_secu.execStat = param.exec_stat;
			params_secu.execDesc = param.exec_desc;
			params_secu.contactType = param.contactType;
			params_secu.orderTarget = 104401;
			params_secu.prodinstId = param.prod_inst_id;
			params_secu.sceneId = param.scene_id;

			$.post(url_prefix+url6,params_secu,function(res){
				debugger;
				if(res.errorCode=='0'){
					parent.exec_clear_data();

					layer.msg("执行成功");

					try{
						parent.yx_load_intraday_data_view();
					}catch(e){

					}
				}else{
					layer.msg(res.message);
				}
			},'json');
		});
	}
	parent.exec_view_exe_small_interface = execute_small_interface;//20190311 营销逻辑修改 先跳转后执行

  	//营销历史
	function query_yx_history(prod_inst_id) {
		$("#history_list").empty();
		/*if (add6 == null || add6 == "null") {
			$("#history_num").text(0);
			$("#exec_history_cnt").text(0);
			history_list_empty_tr_add();
			return;
		}*/
		console.log("is_village:"+is_village);
		if(prod_inst_id!='undefined'){
			$.post(url4Query, {eaction: 'getYX_history', "prod_inst_id": prod_inst_id,"is_village":is_village}, function (data) {
				data = $.parseJSON(data);
				$("#history_num").text(data.length);
				if (data.length == 0)
					history_list_empty_tr_add();
				for (var i = 0, l = data.length; i < l; i++) {
					var d = data[i];
					var rowNew = "<tr><td>" + (i + 1) + "</td><td>" + d.DID_TIME + "</td><td>"+ d.USER_NAME+"</td><td>"+ d.CONTACT_TYPE_TEXT+"</td><td>" + d.EXEC_STAT_TEXT + "</td><td>" + d.DID_DESC + "</td></tr>";
					$("#history_list").append(rowNew);
				}
				$("#exec_history_cnt").text(data.length);
				fix();
			});
		}else{
			$("#history_num").text(0);
			$("#exec_history_cnt").text(0);
			history_list_empty_tr_add();
		}

	}

	//营销历史表格为空时添加几行空行
	function history_list_empty_tr_add() {
		for (var i = 0, l = 3; i < l; i++) {
			var rowNew = "<tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>";
			$("#history_list").append(rowNew);
		}
	}

	function phoneHide(phone){
		var d = phone.substr(0,3);
		for(var i = 0,l = phone.length-5;i<l;i++){
			d += "*";
		}
		return d+phone.substr(-2);
	}

</script>
<script>
    //利用js让头部与内容对应列宽度一致。

    function fix(){
        for(var i=0;i<=$(".tab_header tr").find("th").index();i++){
            $(".tab_body tr td").eq(i).css("width",$(".tab_header tr").find("th").eq(i).width());
        }
    }
    //window.load=fix();
    $(function(){
        //fix();
    });
    $(window).resize(function(){
        return fix();
    });

    //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
    $('.t_table').scroll(function(){
        $('#table_head').css('margin-left',-($('.t_table').scrollLeft()));
    });
</script>
</body>
</html>