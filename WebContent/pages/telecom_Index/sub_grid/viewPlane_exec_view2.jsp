<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="initTime">
	select max(USED_VIEW) as val from edw.tb_cde_process_para@gsedw t WHERE T.USERD_NAME='TB_MKT_BILL_INFO'
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
			src='<e:url value="/pages/telecom_Index/common/js/callCenter.js?version=1.3"/>'></script>
	<e:script value="/resources/layer/layer.js?version=1.1"/>
	<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.3" />' rel="stylesheet" type="text/css" media="all" />
	<link type="text/css" rel="stylesheet" href="<e:url value='pages/telecom_Index/common/css/custom_view.css?version=1.8' />">
	<meta name="apple-mobile-web-capable" content="yes">
	<style>
		#advise_h3,#advise_tab,#village_tab{display:none;}
		.yx_div {display:none;}
		table {font-size:12px;}

		.village_advise_head,.village_advise_body{width:100%;}

		.village_advise_head th {
			background: #00285e;
			height: 30px;
			border: solid 1px #003079;
			border-collapse: collapse;
		}

		.village_advise_head tr th:first-child{width:10%;}
		.village_advise_head tr th:nth-child(2){width:18%;}
		.village_advise_head tr th:nth-child(3){width:72%;}

		.village_advise_body tr td:first-child{width:10%;text-align:center;}
		.village_advise_body tr td:nth-child(2){width:18%;text-align:center;}
		.village_advise_body tr td:nth-child(3){width:72%;text-align:left;}

		.win_list_tab {width:100%;}

		.win_list_tab tr th:first-child{width:8%;}
		.win_list_tab tr th:nth-child(2){width:12%;}
		.win_list_tab tr th:nth-child(3){width:15%;}
		.win_list_tab tr th:nth-child(4){width:15%;}
		.win_list_tab tr th:nth-child(5){width:15%;}
		.win_list_tab tr th:nth-child(6){width:35%;}

		#history_list {width:100%;}

		#history_list tr td:first-child{width:8%;text-align:center;}
		#history_list tr td:nth-child(2){width:12%;text-align:center;}
		#history_list tr td:nth-child(3){width:15%;text-align:center;}
		#history_list tr td:nth-child(4){width:15%;text-align:center;}
		#history_list tr td:nth-child(5){width:15%;text-align:center;}
		#history_list tr td:nth-child(6){width:35%;text-align:left;}
	</style>
</head>
<body style="margin:0px;">
<div style="display: none">
	<audio id="right_video" ></audio>
</div>
<div class="win_wrapper">
	<div style="display: none">
		<audio id="right_video" ></audio>
	</div>
	<div class="btn_layout jz_btn">
		<!--<button id="call_out">外呼</button>
		<button id="call_history">外呼历史</button>-->
		<button id="save_exe">执行</button>
		<button id="cancel_exe">取消</button>
	</div>

	<div class="win_cont yx_div">
		<h2 class="common_tit" id="advise_h3">营销推荐</h2>
		<div id="advise_tab">
			<table cellspacing="0" cellpadding="0" class="win_layout_tab">
				<tr>
					<th>销售品推荐：</th>
					<td id="advise_produce">天翼不限量99元套餐201802</td>
				</tr>
				<tr>
					<th width="80">营销术语：</th>
					<td id="advise_content">宽带产品，用户ARPU 53元，月均活跃14天，月均流量24.64G</td>
				</tr>
			</table>
		</div>
		<div id="village_tab">
			<table cellspacing="0" cellpadding="0" border="0" class="village_advise_head">
				<tr><th>序号</th><th>号码</th><th>推荐信息</th></tr>
			</table>
			<table cellspacing="0" cellpadding="0" border="0" class="village_advise_body" id="village_advise_list">
			</table>
		</div>
	</div>

	<div class="win_cont">
		<h2 class="common_tit">营销执行</h2>

		<table cellspacing="0" cellpadding="0" class="win_layout_tab lineh_32">
			<tr>
				<th width="80">接触方式：</th>
				<td><input type="radio"  name="contactType" value="1" checked="checked" />电话   <input type="radio" style="margin-left:28px;" name="contactType" value="2" />上门   <input type="radio" style="margin-left:28px;" name="contactType" value="3" />门店
				</td>
			</tr>
			<tr>
				<th>执行结果：</th>
				<td>
					<input type="radio" name="XXJ" value="2" checked="checked" />同意办理(可转CRM甩单办理)  <input type="radio" style="margin-left:28px;" name="XXJ" value="1" />有意向
					<input type="radio" style="margin-left:28px;" name="XXJ" value="3" />不需要  <input type="radio" style="margin-left:28px;" name="XXJ" value="4" />无法联系
				</td>
			</tr>
			<tr class="lineh_32">
				<th>备注：</th>
				<td><input type="text" style="width:300px;color:#fff;" id="remark_note" /></td>
			</tr>
			<input type="hidden" id="execute_orderId" value=""/>
			<input type="hidden" id="execute_prodinstId" value=""/>
		</table>

	</div>

	<div class="win_cont">
		<h2 class="common_tit">执行历史</h2>
		<table cellspacing="0" cellpadding="0" class="win_list_tab">
			<tr>
				<th>序号</th>
				<th>执行时间</th>
				<th>执行人</th>
				<th>接触方式</th>
				<th>执行状态</th>
				<th>执行说明</th>
			</tr>
		</table>
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

	if(order_id=='undefined')
		order_id = "";
	if(scene_id=='undefined')
		scene_id = "";
	if(is_village=='undefined')
		is_village = "";

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
				parent.yx_load_intraday_data_view();
				parent.closeWinInfoCollectionEdit();
			}catch(e){
				parent.closeWinInfoCollectionEdit();
			}
		});
		if(is_yx!="undefined" && is_yx!=""){
			$.post(url4Query_sandBox,{"eaction":"getMktReasonByOrderId","order_id":order_id},function(data){
				if(data==null)
					$("#advise_content").text("");
				else{
					var d = $.parseJSON(data);
					$("#advise_content").text(d.MKT_REASON);
				}
			});
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
			$(".yx_div").show();
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
					}
				}else{
					$("#village_advise_list").append("<tr><td colspan='3'>暂无数据</td></tr>");
				}
			});

			$(".yx_div").show();
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
					var user_contract_num = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp' />";
					$.post(user_contract_num,{"eaction":"baseInfo",'prod_inst_id':'${param.prod_inst_id}'},function(data1){
						var d1 = $.parseJSON(data1);
						var call_who = d1[0].USER_CONTACT_NBR;
						//call_who = '17793102293';///测试
						if(call_who=='' || call_who=='null'){
							layer.msg("没有被叫方电话号码，请核实数据");
							return;
						}
						$("#call_who").text(phoneHide(call_who));
						sendSipInviteRequest(call_who+"");
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

	function execute_update(prod_inst_id){
		//if(order_id=="" || order_id==undefined)
		//	alert("没有可执行的工单");
		var staffNo = '${sessionScope.UserInfo.ext30}';
		if(staffNo==''){
			layer.msg("没有关联的划小操作员工号，请重新绑定");
			return;
		}

		var prod_inst_id = $("#execute_prodinstId").val();
		var orderId = $("#execute_orderId").val();
		var exec_stat = $("input[name='XXJ']:checked").val();
		var contactType = $("input[name='contactType']:checked").val();//接触方式
		var exec_desc = $("#remark_note").val();

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
					setTimeout(function(){
						parent.fresh_village_yx();
						parent.closeCustomView();
						parent.closeWinInfoCollectionEdit();
					},3000);
				}else{
					layer.msg("执行失败");
				}
			});
		}else{
			var url_prefix = "http://135.149.64.144:9000/gsch-api";
			var url6 = "/mkt/mktExecute";
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
				params_secu.prodinstId = prod_inst_id;
				params_secu.orderId = orderId;
				params_secu.execStat = exec_stat;
				params_secu.execDesc = exec_desc;
				params_secu.contactType = contactType;
				params_secu.staffNo = staffNo;
				params_secu.sceneId = scene_id;

				$.post(url_prefix+url6,params_secu,function(res){
					if(res.errorCode=='0'){
						//parent.exec_clear_data();
						//parent.closeWinInfoCollectionEdit();

						//单转融、合约到期，在选择同意办理，跳转的时候，不显示“执行成功”，其他情况都显示
						if((scene_id=='10' || scene_id=='11') && exec_stat==2){
						}else{
							layer.msg("执行成功");
						}

						//修改本地记录
						/*$.post(url4Query_sandBox,{"eaction":"executeOrder","prod_inst_id":prod_inst_id,"exec_stat":exec_stat,"exec_desc":exec_desc},function(data){
						 //layer.msg("执行成功");
						 });*/
						if(exec_stat==2){//如果选择了“同意办理”，则跳转crm甩单流程
							try{
								parent.call_execute_new_cust_view(prod_inst_id);
							}catch(e){

							}
						}
						try{
							parent.yx_load_intraday_data_view();
						}catch(e){

						}
						query_yx_history(prod_inst_id);
						setTimeout(function(){
							//parent.closeWinInfoCollectionEdit();
							parent.closeCustomView();
							parent.closeWinInfoCollectionEdit();
						},3000);
					}else{
						layer.msg(res.message);
					}
				},'json');
			});
		}
	}

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