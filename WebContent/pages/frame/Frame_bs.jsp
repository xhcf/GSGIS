<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%@ include file="/pages/frame/homesql.jsp"%>
<e:q4o var="now">
	SELECT TO_CHAR(SYSDATE,'yyyy"年"MM"月"dd"日"') now FROM DUAL
</e:q4o>
<!DOCTYPE html>
<html>
	<head>
		<title>${applicationScope["SysTitle"] }</title>
		<base href="<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"%>">
		<meta charset="UTF-8">
		<e:if condition="${param.isIE8=='1'}">
			<meta http-equiv="X-UA-Compatible" content="IE=8" />
		</e:if>
		<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
	    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	    <!--声明以360极速模式进行渲染 -->
	    <meta name=”renderer” content=”webkit” />
	    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
	    <link rel ="Shortcut Icon" href="" />
		<c:resources type="easyui,app" style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/blue.css?version=New Date()"/>
			<style>
			#boncFrame .globalMenu ul li d	{
				display: inline-block;
				width: 19px;
				height: 19px;
				background: url(<e:url value="resources/themes/common/frame_bs_contract_logos/g_telphone.png"/>);
				vertical-align: sub;
				margin-right: 6px;
			}
			#boncFrame .globalMenu ul li e	{
				display: inline-block;
	    	width: 19px;
	    	height: 19px;
	    	background: url(<e:url value="resources/themes/common/frame_bs_contract_logos/g_qq_group.png"/>);
    		vertical-align: sub;
    		margin-right: 6px;
			}
			#boncFrame .mainMenu li ul{
				background-color:#073b8a;
			}
			#boncFrame .mainMenu li ul li{
				border-bottom:1px #999 solid;

			}
			#boncFrame .mainMenu li ul li a{
				line-height:30px;
				padding-left:20px;
				height:30px;
			}
			.g_logo p{
				background:url(resources/themes/base/images/boncLayout/img/logo2.png) no-repeat left;
			}
		</style>
		<script type="text/javascript" src='<e:url value="/resources/themes/base/js/Frame.js"/>'></script>
	    <script type="text/javascript">
			var isNotClickHideLeft=true;
			firstTabClosable = '${applicationScope.firstTabClosable}';
			var ContextPathJs = '<%=request.getContextPath()%>';
			//是否全屏标识
			SysScreenType = '${applicationScope.SysScreenType}';
			MenuExpandLvl = '${applicationScope.MenuExpandLvl}';
			DefaultOpenPage = '${applicationScope.DefaultOpenPage}';
			SysMenuType = '${SysMenuType}';
			TopKpiPred = '${TopKpiPred}';
			ThemeStyle = '${ThemeStyle}';   //判断主题样式
			ReOpenPage = '${applicationScope.ReOpenPage}';

			IsPortal = '${applicationScope.isPortal}';//是否是门户
			LoginOutPortalUrl='${applicationScope.LoginOutPortalUrl}';//退出（注销）类型为门户时，退出（注销）的url
			var locationUrl=window.location.href;
			var LoginOutPortalUrl1='${applicationScope.LoginOutPortalUrl1}';
			var LoginOutPortalUrl2='${applicationScope.LoginOutPortalUrl2}';
			if(LoginOutPortalUrl1!=""&&locationUrl.substring(locationUrl.indexOf(":")+3,locationUrl.indexOf("."))==LoginOutPortalUrl1.substring(LoginOutPortalUrl1.indexOf(":")+3,LoginOutPortalUrl1.indexOf("."))){
				LoginOutPortalUrl=LoginOutPortalUrl1;
			}else if(LoginOutPortalUrl2!=""&&locationUrl.substring(locationUrl.indexOf(":")+3,locationUrl.indexOf("."))==LoginOutPortalUrl2.substring(LoginOutPortalUrl2.indexOf(":")+3,LoginOutPortalUrl2.indexOf("."))){
				LoginOutPortalUrl=LoginOutPortalUrl2;
			}
			appName='<%=request.getContextPath()%>';

			var ForceChangePasswordDayNum='${applicationScope.ForceChangePasswordDayNum}';
			var CurrentUserDayNum='${userDaysObj.DAYNUM}';

			if(ForceChangePasswordDayNum==''){
				ForceChangePasswordDayNum=0;
			}else{
				ForceChangePasswordDayNum=parseInt(ForceChangePasswordDayNum);
			}
			if(CurrentUserDayNum==''){
				CurrentUserDayNum=0;
			}else{
				CurrentUserDayNum=parseInt(CurrentUserDayNum);
			}

			//选择的1级目录id，配置的选项卡数
			var currentId='${FirstMenuId}',SelectedMenuId='${FirstMenuId}',SelectedMenuLabel='${FirstMenuLabel}',SelectedMenuUrl='${FirstMenuUrl}',tabNums='${SysMenuTab}';
			//导航首菜单信息
			firstPageMenuId = '${FirstPageMenuId}';
			FirstPageMenuName = '${FirstPageMenuName}';
			FirstPageMenuUrl = '${FirstPageMenuUrl}';
			FirstPageMenuState = '${FirstPageMenuState}';

			//是否显示当前位置
			var HiddenCurrentLocation = '${HiddenCurrentLocation}';

		</script>
	</head>
	<body id="boncFrame">
			<!-- 框架外容器 -->
		    <div class="easyui-layout boncLayout" data-options="fit:true" id="frameLayout">
		    	<div data-options="region:'north',border:false" style="box-shadow:0 0 3px #000;" class="header_layout">
		    		<div class="g_logo"><p></p></div>
		            <div class="globalMenu">
			            <ul>
			            	<li><d></d>0931-8788782</li>
			            	<!--<li><d></d>18054198824</li>-->
			            	<li><e></e>172951596(群)</li>
							<%--<li><a href="http://135.149.96.130:9032/zgs-res-sample" target="_blank">资源GIS</a></li>--%>
			            	<li><b></b>${now.now}</li>
							<e:if condition="${!empty sessionScope.UserInfo.CAN_CHANGE_ROLE}">
								<!-- <li><a id="" href="javascript:openSubMenus('9999','角色切换','pages/telecom_Index/role_switch/viewPlane_tab_switch_org_framework.jsp','3','1');">切换</a></li> -->
								<li><a id="" onclick="roleConvert()" style="padding:4px 5px;cursor:pointer;">角色切换</a></li>
							</e:if>
							<!--<e:if condition="${!empty sessionScope.UserInfoSource}">
								<li><a id="" onclick="roleFallBack()" style="padding:4px 5px;cursor:pointer;">角色还原</a></li>
							</e:if>-->
			                <li id="frame_manager" style="height: 20px;"><a class="OpenUserLink" href="javascript:void(0)">欢迎您！ ${sessionScope.UserInfo.USER_NAME}</a></li>
			            </ul>
			        </div>
			        <ul class="mainMenu g_nav" type="disc">
		                <e:forEach items="${RootMenuList.list}" var="item">
							<e:if condition="${item.RESOURCES_TYPE eq '3'}"><!-- 页面链接 -->
								<li><a href='${item.URL}' id="resource_${item.RESOURCES_ID}" menuType="${item.RESOURCES_TYPE}" target="_blank" title="${item.RESOURCES_NAME}"><img src="<e:url value="${item.ATTACHMENT}"/>" />${item.RESOURCES_NAME}</a></li>
							</e:if>
							<e:if condition="${item.RESOURCES_TYPE ne '3'}"><!-- 系统菜单 -->
								<li>
									<a href="javascript:void(0);" menuUrl="${item.URL}" menuType="${item.RESOURCES_TYPE}" id="resource_${item.RESOURCES_ID}" onClick="openSubMenus('${item.RESOURCES_ID}','${item.RESOURCES_NAME}','${item.URL}','${item.RESOURCE_STATE}','${item.RESOURCES_TYPE}');"><img src="<e:url value="${item.ATTACHMENT}"/>" />${item.RESOURCES_NAME}</a>
									<e:if condition="${item.URL==null||item.URL==''}">
										<ul onClick="closeSubMenus();" type="disc"></ul>
									</e:if>
								</li>
							</e:if>
					     </e:forEach>
		            </ul>
		    	</div>

		        <div data-options="region:'center', border:false" style="top:0px;border-bottom:solid 3px #0d459b;width:100%;">
		            <div class="easyui-layout" data-options="fit:true">
		                <div data-options="region:'center', border:false">
		                    <div id="content" class="easyui-layout" data-options="fit:true, border:false">
								<div id="content-body" region="center" border="false">
									<e:if var="TabModel" condition="${SysMenuTab==null||SysMenuTab==''||SysMenuTab=='0'}">
										<div id = "pageLayout" class="easyui-layout" data-options="fit:true, border:false" >
											<div id="pageWest" data-options="region:'west'" title="&nbsp;" style="width:200px;" >
												<ul id="LeftMenu"></ul>
											</div>
											<div data-options="region:'center',border:false" style="padding:10px;">
												<iframe id="ContentIframe" class="contentsIframe" src=""></iframe>
												<div class="move-btn">
													<a href="javascript:void(0);" id="retrunL_btn"onclick="unMenu()"></a>
													<a href="javascript:void(0);" id="retrunR_btn" onclick="showMenu()"></a>
												</div>
											</div>
										</div>
									</e:if>
									<e:else condition="${TabModel}">
										<script type="text/javascript" src='<e:url value="/resources/themes/base/js/tabExtFunction.js"/>'></script>
										<div id="pageLayout" class="easyui-layout" data-options="fit:true, border:false">
											<div data-options="region:'center', border:false" >
												<div id="TabDiv" class="easyui-tabs boncTabs" fit="true" plain="true" border="false" data-options="onSelect:tabSelect" >

												</div>
												<div class="moveBtnGroup">
													<a href="javascript:void(0);" id="retrunL_btn"onclick="unMenu()"></a>
													<a href="javascript:void(0);" id="retrunR_btn" onclick="showMenu()"></a>
												</div>
											</div>
										</div>
									</e:else>
								</div>
							</div>
		                </div>
		            </div>
		        </div>

		        <!-- 框架底部声明 -->

		    </div>
		    <!-- //框架外容器 -->
		    <!-- 框架缩略图主菜单容器 -->
		    <div id="mainMenuSimple">
		        <a style="width:100%" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'layout-button-right'" onclick="$('.boncLayout').layout('expand','west')"></a>
		        <ul class="mainMenu">
		            <e:forEach items="${RootMenuList.list}" var="item">
						 <li><a href='javascript:void(0);' title="${item.RESOURCES_NAME}" onClick="openSubMenuByShotcuts('${item.RESOURCES_ID}','${item.RESOURCES_NAME}','${item.URL}','${item.RESOURCE_STATE}','${item.RESOURCES_TYPE}');"><img src="<e:url value="${item.ATTACHMENT}"/>" style="width:20px;height:20px"/><span>${item.RESOURCES_NAME}</span></a></li>
					</e:forEach>
		        </ul>
		    </div>
		    <!-- //框架缩略图主菜单容器 -->

		    <!-- ------------------------------------------------------页面弹出窗start---------------------------------------------------------- -->
		<div id="favoritesWindow" class="favoriteWindows"></div>
		<!-- 用户管理弹出框 -->
		<div id="managerWindow" class="userWindows">
			<b class="triangleDown"><span></span></b>
			<ul>
				<!--<li><a id="frame_mpwd" href="javascript:void(0);">修改密码</a></li>-->
				<%--<e:if condition="${!empty sessionScope.UserInfo.CAN_CHANGE_ROLE}">
					<!-- <li><a id="" href="javascript:openSubMenus('9999','角色切换','pages/telecom_Index/role_switch/viewPlane_tab_switch_org_framework.jsp','3','1');">切换</a></li> -->
					<li><a id="" onclick="roleConvert()">切换</a></li>
				</e:if>--%>
				<li><a id="frame_logout" href="javascript:void(0);">注销</a></li>
			</ul>
		</div>

		<!-- 修改密码弹出框 -->
		<div id="updPwdDialog" title="修改密码" class="easyui-dialog" data-options="closed:true,modal:true,height:280,width:400,buttons:[{
				text:'确定',
				iconCls:'icon-ok',
				handler:function(){
					updPwd();
				}
			}]">
			<div id="updPwdLoad"></div>
		</div>
		<!-- 添加收藏弹出框 -->
		<div id="insColDialog" title="添加收藏夹" class="easyui-dialog" data-options="closed:true,modal:true,width:260,buttons:[{
				text:'收藏',
				iconCls:'',
				handler:function(){
					insCol();
				}
			}]">
			<div id="insColLoad"></div>
		</div>
		<!-- 角色切换 -->
		 <div id="roleConvert" style="width:100%; height:auto; padding:0;top:0" closed="true" shadow="true" resizable="false" collapsible="true" minimizable="false" maximizable="false" title="角色切换">
			<iframe id="roleContainer" width="100%" height="100%"></iframe>
		</div>
	   <!-- -------------------------------------------------页面弹出窗end--------------------------------------------------------------- -->
	</body>
</html>
<script>
//默认标记重点指标是选中状态 2017年1月17日15:42:07
$(function(){
	$(".mainMenu").children().eq(0).children().addClass("selected");

	$("#roleConvert").dialog({
		width:900,
		height:570,
		//left:450,
		modal:true,
		closed:true
		//top:150
	});
});

function roleConvert(){
	document.getElementById('roleContainer').src="<e:url value='pages/telecom_Index/role_switch/viewPlane_tab_switch_org_framework.jsp' />";
	//$("#list_div").load("<e:url value='pages/telecom_Index/role_switch/viewPlane_tab_switch_org_framework.jsp' />");
	$('#roleConvert').dialog('open');
	$('#roleConvert').panel("move",{top:$(document).scrollTop() + ($(window).height()-570) * 0.5});
}
function roleFallBack(){
	window.parent.location.href = "<e:url value='/fallBack.e?'/>flag=2";
}
//$("#resource_1841").addClass("selected");
</script>