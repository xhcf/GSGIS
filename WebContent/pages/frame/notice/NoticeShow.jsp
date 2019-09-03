<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="now">
	select to_char(sysdate,'yyyy-mm-dd HH24:mi:ss') val from dual
</e:q4o>
<e:q4o var="notice_info">
	select a.*,b.user_name from ${easy_user}.e_post a,${easy_user}.e_user b where post_id = '${param.post_id}' AND a.user_id = b.user_id
</e:q4o>
<%
	/*
	 <e:forEach items="${pageContext.request.parameterNames}" var="item">
	 <e:if condition="${e:startsWith(item,'dim_')}">
	 <e:set var="values" value="${paramValues[item]}"/>
	 <e:if condition="${e:length(values)>1}">
	 ${e:replace(item,'dim_','')}=${e:join(values,',')}
	 </e:if>
	 <e:if condition="${e:length(values)==1}">
	 ${e:replace(item,'dim_','')}=${values[0]}
	 </e:if>
	 </e:if>
	 </e:forEach>
	 */
%>
<e:q4o var="post" sql="frame.notice.shownotice"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>活动</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<script src="<e:url value="/resources/xheditor/xheditor-1.1.14-zh-cn.min.js"/>"></script>
		<script type="text/javascript">
			function doEdit(){
				if($('#noticeForm').form('validate')){
					if($("#acpt_user_id").val()==""){
						$.messager.alert('验证','<br/>请取消后选择接收人!','info');
						return;
					}
					if(!editor.getSource()){
						$.messager.alert('验证','<br/>请填写回复内容!','info');
						return;
					}
					var queryParam = $('#noticeForm').serialize();
					$.post(appBase + '/pages/frame/notice/NoticeAction.jsp?eaction=edit_response', queryParam, function(){
						//window.location.href='<e:url value="/pages/frame/notice/NoticeManager.jsp"/>';
						doCancle();
						refreshResponseList();
					});
				}
			}
			function doCancle(){
				$("#acpt_user_id").val("");
				$("#acpt_user_name").text("");
				editor.setSource("");
				$("#response_area").hide();
			}
			function doResponse(user_id,user_name){
				$("#acpt_user_id").val(user_id);
				$("#acpt_user_name").text(user_name);
				$("#response_area").show();
				$("html,body").animate({"scrollTop":$("#response_area").offset().top},400);
			}
			var url4Query = "<e:url value='pages/frame/notice/NoticeAction.jsp' />";
			function refreshResponseList(){
				$("#response_list_tab").empty();
				$.post(url4Query,{"eaction":"response_list","post_id":"${param.post_id}"},function(data){
					var response_list = $.parseJSON(data);
					$("#response_count").text(response_list.length);
					if(response_list.length==0){
						return;
					}
					for(var i = 0,l = response_list.length;i<l;i++){
						var response = response_list[i];
						var row_str = "<div class='response_list_item'>";
						row_str += "<span>回复人：" + response.USER_NAME;
						row_str += "&nbsp;&nbsp;&nbsp;&nbsp;回复时间：" + response.SEND_TIME + "</span>";
						//当前人是发布人且该条记录的回复人不是当前人
						if(response.SEND_USER_ID!='${sessionScope.UserInfo.USER_ID}' && '${notice_info.USER_ID}'=='${sessionScope.UserInfo.USER_ID}' && '${notice_info.POST_STATE}'==1){
							row_str += "<a href='javascript:void(0);' onclick='javascript:doResponse(\""+response.SEND_USER_ID+"\",\""+response.USER_NAME+"\")' style='cursor:pointer;float:right;margin-right:15px;'>回复</a>";
						}else{
						}
						row_str += "<br/><br/>";
						row_str += response.SEND_CONTENT;
						row_str += "</div>";
						$("#response_list_tab").append(row_str);
					}
					//发布人可以回复所有人
					if('${notice_info.USER_ID}'=='${sessionScope.UserInfo.USER_ID}' && '${notice_info.POST_STATE}'==1){
						$("#response_list_tab").append("<a href='javascript:void(0);' onclick='javascript:doResponse(\"all\",\"所有人\")' style='cursor:pointer;'>回复全部</a>");
					}
				});

			}
			$(function(){
				$(".toggle_ico").click(function(){
					$(".response_list_item").toggle();
					$(this).toggleClass("toggle_ico_trans");
				});
				refreshResponseList();
				//发布人和当前人不是同一个,显示回复给发布人
				if('${notice_info.USER_ID}'!='${sessionScope.UserInfo.USER_ID}' && '${notice_info.POST_STATE}'==1){
					$("#response_hoster").show();
				}
			});
		</script>
		<style>
			#response_list_tab{padding:10px;}
			#response_list_tab div{margin-bottom:25px;}
			.response_list_item {background-color:#eee;}
			.toggle_ico {cursor:pointer;width:25px;height:25px;display:inline-block;background-image: url('<e:url value="pages/telecom_Index/common/images/arrow.jpg" />');background-size:25px 25px;}
			.toggle_ico_trans {
				transform:rotate(180deg);
				-ms-transform:rotate(180deg); 	/* IE 9 */
				-moz-transform:rotate(180deg); 	/* Firefox */
				-webkit-transform:rotate(180deg); /* Safari 和 Chrome */
				-o-transform:rotate(180deg); 	/* Opera */
			}
			#response_area {display:none;}
			#response_hoster {display:none;}
		</style>
	</head>
	<body>
    <div data-options="region:'north', border:false" style="height:62px">
    	<div class="contents-head">
    		<h2>${post.TITLE}</h2>
			<div class="search-area">
				<span class="easyui-font-red">时间:${post.BEGIN_DATE } | 发布人:${post.USER_NAME }</span>
				<a href="javascript:history.back();" class="easyui-linkbutton easyui-linkbutton-gray">返  回</a>
			</div>
    	</div>
    </div>
    <div data-options="region:'center', border:false" style="padding-left:10px;">
    	<p class="easyui-text-normal"> ${e:toString(post.CC) } </p>
    </div>

	<div style="margin-top:80px;">
		<div class="contents-head">
			<h2 style="display: inline-block;">
				<span>回复历史（</span>
				<span id="response_count" style="display: inline-block;"></span>
				<span>）</span>
				<span class="toggle_ico">&nbsp;</span>
				<a id="response_hoster" href="javascript:void(0);" onclick='javascript:doResponse("${notice_info.USER_ID}","${notice_info.USER_NAME}")' style='cursor:pointer;float:right;margin-left:25px;' >回复发布人</a>
			</h2>
		</div>
		<!-- 2018.10.30 工作流闭环 回复历史查看-->
		<div id="response_list_tab">
		</div>
	</div>

	<!-- 2018.10.30 工作流闭环 新增可编辑-->
	<div data-options="region:'south', border:false" style="margin-top:80px;" id="response_area">
		<div class="contents-head">
			<h2>回复消息</h2>
			<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doEdit();">保  存</a>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doCancle();">取  消</a>
				<!--<a href="<e:url value="/pages/frame/notice/NoticeManager.jsp"/>" class="easyui-linkbutton easyui-linkbutton-gray">取  消</a>-->
			</div>
		</div>
		<form id="noticeForm" method="post" action="#" >
			<input type="hidden" id="post_id" name="post_id" value="${param.post_id}">
			<input type="hidden" id="acpt_user_id" name="acpt_user_id" value=""/>
			<table class="pageTable">
				<colgroup>
					<col width="10%">
					<col width="*">
				</colgroup>
				<tr>
					<th>回复人:</th>
					<td>
						<span>${sessionScope.UserInfo.USER_NAME}</span>
						<span style="margin-left:10px;">${now.VAL}</span>
					</td>
				</tr>
				<tr>
					<th>接受人：</th>
					<td id="acpt_user_name">
					</td>
				</tr>
				<tr>
					<th>回复内容:</th>
					<td>
						<textarea id="editor1" name="editor1" cols="120" rows="12" style="height:230px; "></textarea>
						<script type="text/javascript">
							var editor=$('#editor1').xheditor({tools:'Cut,Copy,Paste,Pastetext,|,Blocktag,Fontface,FontSize,Bold,Italic,Underline,Strikethrough,FontColor,BackColor,SelectAll,Removeformat,|,Align,List,Outdent,Indent,|,Hr,Table,|,Fullscreen',skin:'default'});
						</script>
					</td>
				</tr>
			</table>
		</form>
	</div>
	</body>
</html>
