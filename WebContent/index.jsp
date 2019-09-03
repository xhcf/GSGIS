<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="boncEntryPage">
<head>
<a:base/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/resources/themes/blue/blue.css"/>
<c:resources type="easyui"  style="${ThemeStyle }"/>
	<script src='<e:url value="/pages/telecom_Index/common/js/jquery.cookie.js"/>' charset="utf-8"></script>
<title>${applicationScope["SysTitle"] }</title>
<script language="JavaScript">
	if (self!=top){top.location=window.location;}
	$(function(){
		$('input').each(function(){
			if(this.tabIndex==1){
				this.focus();
				return false;
			}
		});
		//		获取提示信息
		var message_code= '<%=request.getAttribute("LoginMsg_code")%>';
		if(message_code!='' && message_code!="null"){
			$("#code_p").show();
			$("#validNum").focus();
		}
		var message_user= '<%=request.getAttribute("LoginMsg_user")%>';
		if(message_user!='' && message_user!='null'){
			$("#user_p").show();
		}
		$("#reloadCode").click(function(){
			$("#codeImg").attr("src","pages/frame/validNum.jsp?random="+(new Date()).getTime());
		});
		$("#findPwd").click(function(){
			window.open("pages/frame/findPwd.jsp");
		});
		$("body").keydown(function(event){
			if(event.which==13){
				$('#formid').submit();
			}
        });
	});
	$(function () {
		$(".EntryGroupLine input").bind("hover focus", function () {
			$(this).parent('.EntryGroupLine').addClass('onFocus');
			$(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
		});

		if($.cookie("total")!=undefined && $.cookie("total")!='NaN' && $.cookie("total")!='null'){//cookie存在倒计时
			timekeeping();
		}else{//cookie 没有倒计时
			$('#send_vailCode').attr("disabled", false);
		}

		$("#send_vailCode").unbind();
		$("#send_vailCode").on("click", function () {
			var num = $.cookie("total");
			if(num == 0 || num == undefined){
				$.post("<e:url value='vaild.e' />",{"user":$("input[name='user']").val(),"pwd":$("input[name='pwd']").val()},function(data){
					var data = data.replace("null","''").replace(/'/g, '"');
					var d1 = $.parseJSON($.trim(data));
					var tel = d1.tel;
					if(d1.has==1){
						var url4data = '<e:url value="/pages/telecom_Index/common/sql/login_action.jsp" />';
						$.post(url4data,{"eaction":"getVailBase"},function(d){
							debugger;

							var vaild_info_obj = $.parseJSON(d);
							$("#order_id").val(vaild_info_obj.IDN);
							var phone = "";
							phone = tel;
							if(phone=="" || phone==null){
								phone = $("#user").val();
							}
							$.ajax({
								url: url4data,//服务器发送短信
								type: 'GET',
								dataType: 'json',
								data: {"eaction":"insertMsgData","login_id":$("input[name='user']").val(),"phone": phone,"idn": vaild_info_obj.IDN,"vailCode": vaild_info_obj.VAILCODE},
								complete:function(){
									var str = "发送短信验证码成功，请注意查看您的手机";
									// console.log(re);
									$.cookie("total", 1);
									timekeeping();
									alert(str);
								}
							});
						});
					}else{
						alert("用户名或密码错误");
						return;
					}
				});
			}else{
				return false;
			}
		});
	})

	function timekeeping(){
		//把按钮设置为不可以点击
		$('#send_vailCode').attr("disabled", true);
		var interval=setInterval(function(){//每秒读取一次cookie
			//从cookie 中读取剩余倒计时
			total=$.cookie("total");
			//在发送按钮显示剩余倒计时
			//$('#send_vailCode').val('请等待'+total+'秒');
			$('#send_vailCode').html('请等待'+total+'秒');
			//把剩余总倒计时减掉1
			total--;
			if(total==0){//剩余倒计时为零，则显示 重新发送，可点击
				//清除定时器
				clearInterval(interval);
				//删除cookie
				//total=$.cookie("total",total, { expires: -1 });
				$.cookie('total', null);
				$.removeCookie("total");
				//显示重新发送
				//$('#send_vailCode').val('重新发送');
				$('#send_vailCode').html('重新发送');
				//把发送按钮设置为可点击
				$('#send_vailCode').attr("disabled", false);
			}else{//剩余倒计时不为零
				//重新写入总倒计时
				$.cookie("total",total);
			}
		},1000);
	}
</script>
</head>
<body id="boncEntry">
<div class="boncEntryArea">
	<div class="EntryHead">
		<h1>中国电信</h1>
		<h2><img src="resources/themes/base/images/boncLayout/img/titSystemEntryXbulider1.png" alt="自助报表系统" /></h2>
	</div>

	<div class="EntryCon">
		<form action="login.e" method="post" id="formid">
			<div class="EntryGroup">
				<fieldset>
					<div class="EntryBox">
						<div class="EntryGroupLine">
							<span class="iconUser"></span>
							<input type="text" name="user" value="${requestScope.loginName}" tabindex="1" placeholder="请输入用户名" />
						</div>
						<%
						//	获取提示信息
						 String message_code = (String)request.getAttribute("LoginMsg_code");
						 if(message_code==null){
							 message_code=" ";
						 }
						 String message_user = (String)request.getAttribute("LoginMsg_user");
						 if(message_user==null){
							 message_user=" ";
						 }
						%>
					</div>

					<div class="EntryBox">
						<div class="EntryGroupLine">
							<span class="iconPassword"></span>
							<input type="password" value="${requestScope.loginPwd}" name="pwd"  placeholder="请输入密码" />
						</div>
					</div>

					<%--<div class="EntryBox">
						<div class="EntryGroupLine EntryGroupLineO">
							<span class="iconCode"></span>
							<input type="text" id="validNum" name="validNum" value="" placeholder="验证码" class="formCode" />
						</div>
						<img id="codeImg" class="imgCode" src="pages/frame/validNum.jsp" />
						<a href="javascript:void(0)" class="btnCode" id="reloadCode">换一张</a>
					</div>--%>
					<div class="EntryBox">
						<div class="EntryGroupLine EntryGroupLineO">
							<span class="iconCode"></span>
							<input type="text" id="validNum" name="validNum" value="" placeholder="验证码" class="formCode" />
							<!-- <input id="send_vailCode" type="button" value="发送验证码" disabled="disabled" /> -->
						</div>
						<%-- <img id="codeImg" class="imgCode" src="pages/frame/validNum.jsp" />
						<a href="javascript:void(0)" class="btnCode" id="reloadCode">换一张</a>
						<input id="send_vailCode" type="button" value="发送验证码" disabled="disabled" />--%>
						<a href="javascript:void(0)" class="btnCode" id="send_vailCode" style="text-decoration:underline;font-size:16px;">发送验证码</a>
						<input type="hidden" id="order_id" name="order_id" value="${param.order_id}" class="text_area" />
					</div>

					<input type="hidden" name="fromMyself" value="1" />
				</fieldset>
				<div class="boncLogin_check" >
					<p id="code_p" ><%=message_code%></p>
					<p id="user_p" ><%=message_user%></p>
				</div>
				<div class="btnSubmit"><a href="javascript:void(0)" onclick="javascript:document.getElementById('formid').submit();">登&nbsp;&nbsp;录</a></div>
				<div class="btnSubmit"><a href="javascript:void(0)" id="findPwd" class="find" onclick="findPwd()">忘记密码?</a></div>
			</div>
		</form>
	</div>
	<div class="EntryFoot">北京东方国信科技股份有限公司提供技术支持</div>
</div>
</body>
</html>
