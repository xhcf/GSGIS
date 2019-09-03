<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today">
	select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="lastMonth">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '3'
</e:q4o>
<e:q4o var="date_in_month">
	SELECT TO_CHAR(TO_DATE(MON_A, 'yyyymmdd'), 'yyyymmdd') AS CURRENT_FIRST,
	TO_CHAR(LAST_DAY(TO_DATE(MON_A, 'yyyymmdd')),'yyyymmdd') AS CURRENT_LAST,
	TO_CHAR(TO_DATE(MON_B, 'yyyymmdd'), 'yyyymmdd') AS LAST_FIRST,
	TO_CHAR(LAST_DAY(TO_DATE(MON_B, 'yyyymmdd')), 'yyyymmdd') AS LAST_LAST
	FROM (SELECT TO_CHAR(TO_DATE('${today.val}', 'yyyymmdd'), 'yyyymm') || '01' MON_A,
	TO_CHAR(ADD_MONTHS(TO_DATE('${today.val}', 'yyyymmdd'), -1),
	'yyyymm') || '01' MON_B
	FROM DUAL)
</e:q4o>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=7" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
		<meta http-equiv="expires" content="0">
		<title>区县地图</title>
		<%--<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />--%>
		<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css" />
		<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
		<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
		<!--<script src='<e:url value="/pages/telecom_Index/common/js/gisSubOperator_rankList.js?version=1.3.5"/>' charset="utf-8"></script>-->
		<!--<script src='<e:url value="/pages/telecom_Index/common/js/gisGridOperator_rankList.js?version=1.2.3"/>' charset="utf-8"></script>-->
		<script src='<e:url value="/resources/scripts/admin.js"/>'></script>
		<script src='<e:url value="/pages/telecom_Index/common/js/esri.symbol.MultiLineTextSymbol.js"/>'></script>
		<script src='<e:url value="/pages/telecom_Index/common/js/left_menu_control.js?version=1.1"/>' charset="utf-8"></script>
		<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow_from_sub_rank_tab.css"/>' rel="stylesheet" type="text/css" media="all" />
	</head>
	<body class="body_padding" style="position:relative;background-color:transparent;">
		<div id="channel_info_win" style="display:none;background-color: #fff;position: fixed;top: 40%;left: 26%;z-index: 99999999999;width: 300px;height: 180px;border: 2px solid #2070dc;border-radius: 4px">
			<span style="font-weight: bold;color: red;padding-top: 20px">店名：</span><em style="color: red;"></em>
			<br>
			<span style="font-weight: bold;margin-top: 20px">地址：</span><em></em>
			<br>
			<span style="font-weight: bold;margin-top: 20px">类型：</span><em></em>
			<table style="width: 98%;font-size: 14px;text-align: center";>
				<tr>
					<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf  "></td>
					<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">当月</td>
					<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;">当日</td>
				</tr>
				<tr>
					<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">移动</td>
					<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf" ><em></em></td>
					<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;"><em></em></td>
				</tr>
				<tr>
					<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">宽带</td>
					<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
					<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
				</tr>
				<tr>
					<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">itv</td>
					<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
					<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
				</tr>
			</table>
		</div>
		<div>
			<div class="new_map" id="mainleft">
				<h2 id="click_path" style="display:none;"></h2>
				<div id="gismap" name="gismap" style="text-align: left;background-image: url('sub_grid/bgg.jpg');background-repeat: no-repeat;background-size:100% 100%;-moz-background-size:100% 100%;z-index:5;"></div>
				<a href="javascript:backToEchart()" id="nav_fanhui" class="add_backcolor"></a>
				<a href="javascript:backToSub()" id="nav_fanhui_sub" class="add_backcolor"></a>

				<div id="sub_info_win" style="display:none;bottom:0px;right:0px;background-color: #fff;position: absolute;z-index: 99999999999;width: 260px;height: 180px;border: 2px solid #2070dc;border-radius: 4px;">
					<div style="width:100%;text-align: left;height: 26px;line-height: 26px;font-size: 16px;background-color:#0d0a8b;color: #ffffff;padding-left: 10px ">支局信息</div>
					<span style="font-weight:bold;color: red;margin-left: 8px;margin-top: 2px;display: inline-block">支局名称：</span><em style="color: red;"></em>
					<br>
					<span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block">网&nbsp;格&nbsp;数 ：</span>共<em></em>个<e>,</e><em></em><e>个未上图</e>
					<br>
					<span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block">支局类型：</span><em></em>
					<table style="width: 98%;font-size:14px;text-align:center;margin-top: 2px">
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf  ">指标名称</td>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">本月发展</td>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;">上月发展</td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">移动</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf" ><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;"><em></em></td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">宽带</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">ITV装机</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
						</tr>
					</table>
				</div>
				<div id="grid_info_win" style="display:none;bottom:0px;right:0px;background-color: #fff;position: absolute;z-index: 99999999999;width: 260px;height: 200px;border: 2px solid #2070dc;border-radius: 4px;">
					<div style="width:100%;text-align: left;height: 26px;line-height: 26px;font-size: 16px;background-color:#0d0a8b;color: #ffffff;padding-left: 10px ">网格信息</div>
					<span style="font-weight:bold;color: red;margin-left: 8px;margin-top: 2px;display: inline-block">网格名称：</span><em style="color: red;"></em>
					<br>
					<span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block">所属支局：</span><em></em>
					<br>
					<table style="width: 98%;font-size:14px;text-align:center;margin-top: 2px">
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">指标名称</td>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">当日发展</td>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;">当月发展</td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">移动</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf" ><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;"><em></em></td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">宽带</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">ITV</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">终端</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
						</tr>
						<tr>
							<td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">800M</td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf"><em></em></td>
							<td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
						</tr>
					</table>
				</div>
			</div>
			<div class="picBox" onclick="switchSysBar()" id="switchPoint"></div>

			<!-- 支局右侧联动的div start -->
			<div class="new_rightcont g_target sub_right_div frmTitle" name="fmTitle">
				<h1 class="click_name">&nbsp;</h1>
				<div class="target_wrap">
					<ul class="target_list">
						<li>
							<p class="target_title">市场</p>
							<dl>
								<dt>- -</dt>
								<dd>- -</dd>
								<dd>- -
									<b class=""></b>
								</dd>
							</dl>
						</li>
						<li>
							<p class="target_title">收入</p>
							<dl>
								<dt>- -</dt>
								<dd>- -</dd>
								<dd>- -
									<b class=""></b>
								</dd>
							</dl>
						</li>
						<li class="b_none">
							<p class="target_title">利润</p>
							<dl>
								<dt>- -</dt>
								<dd>- -</dd>
								<dd>- -
									<b class=""></b>
								</dd>
							</dl>
						</li>
					</ul>
				</div>

				<div class="target_wrap" style="position: relative;height:28%;">
					<div class="title_pos">日发展趋势</div>
					<div class="btn_c">
						<ul id="tab_btn">
							<li class="btn_uc" data="0">
								<input type="button" value="移动" style="color: #fff;cursor:pointer;" />
							</li>
							<li class="btn_uc" data="1">
								<input type="button" value="宽带" style="color: #fff;cursor:pointer;" />
							</li>
							<li class="btn_uc" data="2">
								<input type="button" value="ITV" style="color: #fff;cursor:pointer;"/>
							</li>
						</ul>
					</div>
					<div class="figure" id="day_fz1" style="width:100%;height:92%;margin-top: 36px"></div>
				</div>

				<div class="target_wrap" style=" height:10%;position: relative;border-bottom: 1px solid #28266a;padding-bottom: 5px">
					<ul class="target_tab">
						<li class="clearfix">
							<p>用户发展</p>
							<span id="user_proc" style="margin-left: -5px">
								<b>移动当月<font>- -</font></b>
								<%--<b>环比：<font>- -</font></b>--%>
								<b style="padding-left: 10px">宽带当月<font>- -</font></b>
								<%--<b>环比：<font>- -</font></b>--%>
								<b>ITV&nbsp;当月<font>- -</font></b>
								<%--<b>环比：<font>- -</font></b>--%>
							</span>
						</li>
						<%--<li class="clearfix">
							<p>终端销售</p>
							   <span id="terminal_sale">
								<b>当月新增:<font>- -</font></b>
								<b>智能机：<font>- -</font></b>
								<b>800M：<font>- -</font></b>
							</span>
						</li>--%>
					</ul>
				</div>
				<div class="target_wrap_a" style=" border:none;height:22%;position: relative">
					<div class="title_pos ico6">网格列表</div>

					<div style="line-height: 30px;height: 30px;background-color: #0a1e66;position: absolute;top: 30;width: 100%;font-size: 12px;color: #fff;padding-right: 10px">
						<div  height="30" align="center" formatter="" style="display: inline-block;width: 10%;color: #00deff">序号</div>
						<div height="30" align="center" formatter="" style="display: inline-block;width: 20%;color: #00deff">网格</div>
						<div  height="30" align="center" style="display: inline-block;width: 15%;color: #00deff">当月收入</div>
						<div  height="30" align="center" halign="center" formatter="" style="display: inline-block;width: 15%;color: #00deff">移动当月</div>
						<div  height="30" align="center" style="display: inline-block;width: 15%;color: #00deff">宽带当月</div>
						<div  height="30" align="center" style="display: inline-block;width: 15%;color: #00deff">ITV当月</div>
					</div>
					<div style="width:100%;height: 100%;cursor:pointer;position: absolute;top:60;overflow-y: scroll;padding-right: 10px;margin-bottom: 10px">
						<table id="sub" class="sub" style="width:100%;cursor:pointer;color:#ffffff;font-size: 12px;margin-bottom: 10px;">
							<tbody style="font-size: 12px;margin-bottom: 5px"></tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- 支局联动联动的div end -->

			<!-- 网格联动联动的div start -->
			<div class="new_rightcont g_target grid_right_div frmTitle" name="fmTitle" style="display:none;">
				<h1 class="click_name">&nbsp;</h1>
				<div class="target_wrap" style="height:21% !important">
					<h3>基础信息</h3>
					<ul class="target_list clearfix">
						<li>
							<p class="target_title">所属支局</p>
							<dl>
								<dt>党政军客户营销分部</dt>
							</dl>
						</li>
						<li>
							<p class="target_title">网格经理</p>
							<dl>
								<dt>张三</dt>
								<dd>13609276318</dd>
							</dl>
						</li>
						<li class="b_none">
							<p class="target_title">帮扶党员</p>
							<dl>
								<dt>李四</dt>
								<dd>17692087631</dd>
							</dl>
						</li>
					</ul>
				</div>

				<div class="target_wrap" style="position: relative;height:24% !important;width: 98%;">
					<h3>竞争</h3>
					<div class="copment">
						<ul>
							<li class="comp"><span class="com_white">人口数：</span><span class="com_yellow">29800</span></li>
							<li class="comp"><span class="com_white">家庭数：</span><span class="com_yellow">29800</span></li>
							<li class="comp"><span class="com_white">移动：</span><span class="com_yellow">29800</span></li>
							<li class="comp"><span class="com_white">宽带：</span><span class="com_yellow">29800</span></li>
						</ul>
					</div>
					<table id="compment">
						<tr>
							<th rowspan="2" style="border-left: none">运营商</th>
							<th colspan="2">移动市场</th>
							<th colspan="2">宽带市场</th>
							<th colspan="2">电视市场</th>
							<th colspan="2" style="border-right: none">移动收入市场</th>
						</tr>
						<tr>
							<th>用户数</th>
							<th>渗透率</th>
							<th>用户数</th>
							<th>渗透率</th>
							<th>用户数</th>
							<th>渗透率</th>
							<th>收入</th>
							<th style="border-right: none">占有率</th>
						</tr>
						<tr>
							<td style="border-left: none">电信</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td style="border-right: none"></td>

						</tr>
						<tr>
							<td style="border-left: none">移动</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td style="border-right: none"></td>

						</tr>
						<tr>
							<td style="border-left: none">联通</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td style="border-right: none"></td>

						</tr>
					</table>
				</div>

				<div class="target_wrap"
					 style=" height:20% !important;position: relative;border-bottom: 1px solid #28266a;padding-bottom: 5px">
					<h3>收入</h3>
				</div>
				<div class="target_wrap" style=" border:none;height:24% !important;position: relative">
					<h3>发展</h3>
					<div class="btn_c">
						<ul id="tab_btn">
							<li class="btn_uc" data="0">
								<input type="button" value="移动" style="color: #fff;cursor:pointer;"/>
							</li>
							<li class="btn_uc" data="1">
								<input type="button" value="宽带" style="color: #fff;cursor:pointer;"/>
							</li>
							<li class="btn_uc" data="2">
								<input type="button" value="ITV" style="color: #fff;cursor:pointer;"/>
							</li>
						</ul>
					</div>
					<div id="Development"></div>
					<div style="position: fixed;bottom: 1px">
						<div class="dopment">
							<ul>
								<li class="domp"><span class="com_white">移动当日：</span><span class="com_yellow">29800</span></li>
								<li class="domp"><span class="com_white">宽带当日：</span><span class="com_yellow">29800</span></li>
								<li class="domp"><span class="com_white">电视当日：</span><span class="com_yellow">29800</span></li>
							</ul>
						</div>
						<div class="dopment">
							<ul>
								<li class="domp"><span class="com_white">移动当月：</span><span class="com_yellow">29800</span></li>
								<li class="domp"><span class="com_white">宽带当月：</span><span class="com_yellow">29800</span></li>
								<li class="domp"><span class="com_white">电视当月：</span><span class="com_yellow">29800</span></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!-- 网格联动联动的div end -->

			<div class="tools_n" style="position:absolute;top:-12px;left:0px;text-align:center;">
				<a href="javascript:void(0)" id="show">显示</a>
				<a href="javascript:void(0)" id="hide">隐藏</a>
				<ul id="tools">
					<li id="nav_zoomin"><span></span><a href="javascript:void(0)" id="zoomin">放大</a></li>
					<li id="nav_zoomout"><span></span><a href="javascript:void(0)" id="zoomout">缩小</a></li>
					<li id="nav_hidetiled"><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
					<li id="nav_hidepoint"><span></span><a href="javascript:void(0)" id="hidepoint">网点</a></li>
				</ul>
			</div>
		</div>
	</body>
</html>
<script type="text/javascript">
	//所有区县的轮廓线
	var qx_all_line_color = [32,112,220,1];//207,129,35
	var qx_clicked_line_color = [255,129,35,1];

	//支局名称 按地图放大缩小 分级展示用的数组
	var sub_name_label_symbol1 = new Array();
	var sub_name_label_symbol2 = new Array();
	var sub_name_label_symbol3 = new Array();
	var sub_name_label_symbol4 = new Array();
	var sub_name_label_symbol5 = new Array();
	var sub_name_label_symbol6 = new Array();
	var sub_name_label_symbol7 = new Array();

	//网格名称 按地图放大缩小 分级展示用的数组
	var grid_name_label_symbol1 = new Array();
	var grid_name_label_symbol2 = new Array();
	var grid_name_label_symbol3 = new Array();
	var grid_name_label_symbol4 = new Array();
	var grid_name_label_symbol5 = new Array();

	var global_param_temp_for_subgridlist = parent.global_param_temp_for_subgridlist;
	/*var global_param_temp_for_subgridlist = {
		"current_city_full_name":"兰州市",
		"current_city_name":"兰州",
		"current_full_area_name":"城关区",
		"current_area_name":"城关区",
		"current_sub_id":"862010101010218",
		"current_city_id":931,
		"current_flag":4
	};*/
	/*var global_param_temp_for_subgridlist = {
		"current_city_full_name":"定西市",
		"current_city_name":"定西",
		"current_full_area_name":"陇西县",
		"current_area_name":"陇西县",
		"current_sub_id":"862010902010601",
		"current_city_id":932,
		"current_flag":4,
		"position":['甘肃省','定西市','陇西县','eee']
	};*/

	var city_full_name = global_param_temp_for_subgridlist["current_city_full_name"];//兰州市
	var area_full_name = global_param_temp_for_subgridlist["current_full_area_name"];//城关区
	var area_name = global_param_temp_for_subgridlist["current_area_name"];//城关区
	var city_name = global_param_temp_for_subgridlist["current_city_name"]//城市短名称，去市、州

	var sub_id = global_param_temp_for_subgridlist["current_sub_id"];
	var city_id = global_param_temp_for_subgridlist["current_city_id"];
	var zoom = global_param_temp_for_subgridlist["zoom"];

	var map_id = map_id_in_gis[city_id];
	var index_type = parent.global_current_index_type;
	var flag = global_param_temp_for_subgridlist["current_flag"];

	var pos_obj = global_param_temp_for_subgridlist["position"];

	///parent.global_position.splice(2,1,area_full_name);//进入区县
	///if(city_full_name!="嘉峪关市")//嘉峪关特殊处理
	///	parent.updatePosition(flag);

	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';

	var colorflow = [[68,169,254],[1,1,89]];
	var colorflow_grid = [[68,169,254],[1,1,89]];//[[109,252,146],[39,255,80]];

	var fill_color_array = [
		[0,198,255,0.4],
		[240,156,160,0.4],
		[72,241,231,0.4],
		[35,255,166,0.4],
		[54,193,0,0.4],
		[239,159,194,0.4],
		[0,217,86,0.4],
		[33,168,230,0.4],
		[143,251,16,0.4]
	];

	var channel_type_array = {
		"2001100": "专营店",
		"2001000": "自有厅",
		"2001200": "连锁店",
		"2001300": "独立店",
		"2001400": "便利点"
	};

	var sub_name_speical = {
		"947":{
			"昌盛支局":1,
			"东安支局":1,
			"四零四支局":1,
			"永乐支局":1,
			"新华支局":1
		},
		"932":{
			"通渭西城支局":1,
			"陇西北城支局":1,
			"陇西东城支局":1
		}
	};

	var last_month_first = parent.last_month_first;///'20170501';//
	var last_month_last = parent.last_month_last;///'20170531';//
	var current_month_first = parent.current_month_first;///'20170601';//
	var current_month_last = parent.current_month_last;///'20170618';//

	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';

	//var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/new_sub_grid_with_area_20170616/MapServer";
	var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/EDA/GRID_SUB/MapServer";

	var sub_selected_ext = "";

	var clickedFlag = false;

	var myChart = echarts.init(document.getElementById('day_fz1'));
	$(function(){
		/*$("#sub").datagrid({
			data: [
				{Q:'0', W:'民乐永鑫商客支局', E:'232', R:'2314', T:'325', Y:'253'},
				{Q:'1', W:'马神庙支局', E:'1234', R:'324', T:'3245', Y:'215'},
				{Q:'2', W:'山丹仁和商客支局', E:'234', R:'2345', T:'35', Y:'1253'},
				{Q:'3', W:'山丹城南支局', E:'342', R:'325', T:'253', Y:'2153'},
				{Q:'4', W:'临泽城市支局', E:'2314', R:'35', T:'253', Y:'253'},
				{Q:'5', W:'高台园区商客支局', E:'1242', R:'253', T:'253', Y:'235'},
				{Q:'6', W:'高台园区商客支局', E:'1242', R:'253', T:'253', Y:'235'},
				{Q:'7', W:'高台园区商客支局', E:'1242', R:'253', T:'253', Y:'235'},
				{Q:'8', W:'高台园区商客支局', E:'1242', R:'253', T:'253', Y:'235'}
		]});*/

		//parent.hideSubTab();
		$("#nav_fanhui").show();
		$("#nav_fanhui_sub").hide();
		toGis();
		//$("#backtop").on("click",backToEchart());
		//$("#nav_fanhui").css({"position":"absolute","top":"37px","left":($("#mainleft").width()-40)});
	});

	var map = "";//在toGis中创建，在doShowAll中销毁

	var backToSub = "";

	//渲染 某个区县 下的支局群板块，填充颜色
	function toGis() {
		global_current_flag = 4;
		var cityForLayer = cityNames[city_full_name];
		if (cityForLayer == undefined)
			return;

		var pageMapHeight = $(window).height();
		if(pageMapHeight==0)
			pageMapHeight = parent.document.documentElement.clientHeight-6;
		$("#gismap").height(pageMapHeight);
		$("#gismap").show();

		var right = $('#gismap').offset().right;
		var bottom = $('#gismap').offset().bottom;



		require(["esri/config",
					"esri/Color",
					"esri/graphic",
					"esri/map",
					"esri/dijit/OverviewMap",
					"esri/dijit/Scalebar",
					"esri/geometry/Polygon",
					"esri/geometry/Point",
					"esri/geometry/Polyline",
					"esri/geometry/Multipoint",
					"esri/layers/ArcGISDynamicMapServiceLayer",
					"esri/layers/ArcGISTiledMapServiceLayer",
					"esri/layers/FeatureLayer",
					"esri/layers/GraphicsLayer",
					"esri/layers/LabelLayer",
					"esri/layers/ImageParameters",
					"esri/renderers/ClassBreaksRenderer",
					"esri/renderers/SimpleRenderer",
					"esri/renderers/UniqueValueRenderer",
					"esri/symbols/SimpleFillSymbol",
					"esri/symbols/SimpleLineSymbol",
					"esri/symbols/SimpleMarkerSymbol",
					"esri/symbols/Font",
					"esri/symbols/TextSymbol",
					"esri/symbols/PictureMarkerSymbol",
					"esri/SpatialReference",
					"esri/tasks/FeatureSet",
					"esri/tasks/IdentifyTask",
					"esri/tasks/IdentifyParameters",
					"esri/tasks/query",
					"esri/tasks/QueryTask",
					"esri/tasks/Geoprocessor",
					"esri/tasks/GeometryService",
					"esri/toolbars/draw",
					"esri/toolbars/navigation",
					"CustomModules/ChartInfoWindow",
					"CustomModules/CustomTheme",
					"CustomModules/geometryUtils",
					"dijit/registry",
					"dojo/_base/connect",
					"dojo/_base/array",
					"dojo/_base/window",
					"dojo/dom-construct",
					"dojo/parser",
					"dojo/query",
					"dojox/charting/Chart",
					"dojox/charting/action2d/Highlight",
					"dojox/charting/action2d/Tooltip",
					"dojox/charting/plot2d/ClusteredColumns",
					"dojo/domReady!"],
				function (Config,
						  Color,
						  Graphic,
						  Map,
						  OverviewMap,
						  Scalebar,
						  Polygon,
						  Point,
						  Polyline,
						  Multipoint,
						  Dynamic,
						  ArcGISTiledMapServiceLayer,
						  FeatureLayer,
						  GraphicsLayer,
						  LabelLayer,
						  ImageParameters,
						  ClassBreaksRenderer,
						  SimpleRenderer,
						  UniqueValueRenderer,
						  SimpleFillSymbol,
						  SimpleLineSymbol,
						  SimpleMarkerSymbol,
						  Font,
						  TextSymbol,
						  PictureMarkerSymbol,
						  SpatialReference,
						  FeatureSet,
						  IdentifyTask,
						  IdentifyParameters,
						  Query,
						  QueryTask,
						  Geoprocessor,
						  GeometryService,
						  draw,
						  Navigation,
						  ChartInfoWindow,
						  CustomTheme,
						  geometryUtils,
						  registry,
						  connect,
						  array,
						  win,
						  domConstruct,
						  parser,
						  query,
						  Chart,
						  Highlight,
						  Tooltip,
						  ClusteredColumns
				){
					Config.defaults.io.proxyUrl = "http://135.149.64.140:8888/proxy/proxy.jsp";
					Config.defaults.io.alwaysUseProxy = false;
					//本地网地图url
					var layer_ds = "http://135.149.48.47:6080/arcgis/rest/services/NewMap/" + cityForLayer + "/MapServer";
					var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/EDA/GRID_SUB/MapServer";
					var new_url_point = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/channel_point_new_20170609/MapServer";

					var currentOpacity = 1;
					var highlightSymbolzj_grid = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_SOLID,
							new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([255,210,0,currentOpacity]),2),//0.3],2
							new Color([255,210,0,currentOpacity])//0.6
					);
					var highlightSymbolzj = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_SOLID,
							new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([255,210,0,currentOpacity]),2),//0.3],2  //255,255,102 20170616
							new Color([255,210,0,currentOpacity])//0.6
					);
					var highlightSymbolzj_clicked = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_SOLID,
							new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([255,210,0,currentOpacity]),2),//0.3],2
							new Color([255,210,0,currentOpacity])//0.6
					);

					//parser.parse();//解释小部件标签属性
					map = new Map("gismap");
					map.showPanArrows();
					//map.showZoomSlider();

					map.on("load", function () {
						//$("#back").remove();
						//$("#gismap").append("<div id=\"back\" style=\"cursor:pointer;left:20px;top:18px;width:53px;height:64px;color:white;position:absolute;\" onclick=\"doShowAll('" + parent_name + "',true)\"></div>");
						//$("#navDiv1").append("<div id=\"back\" data-dojo-type=\"dijit/layout/ContentPane\" class=\"navItem\" data-dojo-props=\"splitter:'false'\" onclick=\"doShowAll('" + parent_name + "',true)\"><img class=\"navItem\" src=\"images/option_ico/back_to_top.png\" title=\"返回上级\"/></div>");
						//$("#back").css("background-image", 'url(<e:url value="/resources/component/echarts_new/images/map_03_city.png" />)');
						//$("#navDiv1").show();
						map.hideZoomSlider();
					});

					var navToolbar = new Navigation(map);

					$("#nav_zoomin").click(
						function(){
							map.setLevel(map.getLevel()+1);
						}
					);
					$("#nav_zoomout").click(
						function(){
							map.setLevel(map.getLevel()-1);
						}
					);
					$("#nav_hidetiled").click(
						function() {
							if (tiled.visible){
								tiled.hide();
								$("#nav_hidetiled").removeClass("active");
							}else{
								tiled.show();
								$("#nav_hidetiled").addClass("active");
							}
						}
					);
					$("#nav_hidepoint").click(
						function(){
							if(graLayer_wd.visible){
								map.infoWindow.hide();
								graLayer_wd.hide();
								$("#nav_hidepoint").removeClass("active");
							}else{
								graLayer_wd.show();
								$("#nav_hidepoint").addClass("active");
							}
						}
					);

					//支局 id 字典
					var js_map = new Array();
					//var sub_in_qx = new Array();

					//实体渠道 子分类
					var color_map = new Array();
					/*color_map['2001000'] = '自有厅';
					 color_map['2001100'] = '专营店';
					 color_map['2001200'] = '连锁店';
					 color_map['2001300'] = '独立店';
					 color_map['2001400'] = '便利点';*/
					color_map['2001000'] = [164,0, 233,1];
					color_map['2001100'] = [255,229,0,1];
					color_map['2001200'] = [254,84, 0,1];
					color_map['2001300'] = [106,226,0,1];
					color_map['2001400'] = [9,0, 183,1];
					var color_point_line = [255,0,0];

					var channel_ico = new Array();
					channel_ico['2001000'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point1.png" />';
					channel_ico['2001100'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point2.png" />';
					channel_ico['2001200'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point3.png" />';
					channel_ico['2001300'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point4.png" />';
					channel_ico['2001400'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point5.png" />';

					var tiled = new ArcGISTiledMapServiceLayer(layer_ds);
					map.addLayer(tiled);

					var graLayer_qx = new GraphicsLayer();

					//支局名字的层，包含所有支局名称
					var graLayer_zjname = new GraphicsLayer();
					//graLayer_zjname.setScaleRange(25000, 50000);
					//graLayer_zjname.setMinScale(5);

					//下钻时突出显示支局范围的层,包含网格填充、网格名称、支局轮廓
					//网格填充层
					var graLayer_wg = new GraphicsLayer();

					graLayer_wg.hide();
					//网格层鼠标悬浮层
					var graLayer_grid_mouseover = new GraphicsLayer();

					//网格名称层
					var graLayer_wg_text = new GraphicsLayer();

					//graLayer_wg_text.hide();

					var graLayer_zj_click = new GraphicsLayer();

					var graLayer_wg_click = new GraphicsLayer();


					//鼠标悬浮到支局，突出显示鼠标下的支局
					var graLayer_sub_mouseover = new GraphicsLayer();

					//勾选所有区县轮廓的层
					var graLayer_qx_all = new GraphicsLayer();

					//勾选选定的区县边框
					var graLayer_qx = new GraphicsLayer();

					//鼠标点击支局，突出显示支局轮廓
					var graLayer_mouseclick = new GraphicsLayer();
					graLayer_mouseclick.setOpacity(0.25);

					//鼠标点击支局，支局下网格未上图的提示
					var graLayer_subname_result = new GraphicsLayer();

					//鼠标悬浮到网格，突出显示鼠标下的网格
					var graLayer_grid_mouseover = new GraphicsLayer();

					//网点展示
					var graLayer_wd = new GraphicsLayer();
					graLayer_wd.hide();

					var featureLayer = new FeatureLayer(new_url_sub_grid+"/1",{
						mode: FeatureLayer.MODE_SNAPSHOT,
						//mode: FeatureLayer.MODE_ONDEMAND,
						outFields: ["*"],
						visible:true,
						opacity:1
					});

					//绘制所有支局的颜色
					var sub_dev = new Array();
					var sub_graphics_init = new Array();
					var defaultSymbol = new SimpleFillSymbol().setStyle(SimpleFillSymbol.STYLE_NULL);
					defaultSymbol.outline.setStyle(SimpleLineSymbol.STYLE_NULL);
					var renderer = new UniqueValueRenderer(defaultSymbol, "SUBSTATION_NO");
					$.post(url4Query,{eaction:"getSubColorByLatnId",city_id:city_id,yesterday:'${yesterday.VAL}',last_month:'${lastMonth.VAL}'},function(data){
						data = $.parseJSON(data);
						var where_temp = "SUBSTATION_NO IN (";
						for(var i = 0,l = data.length;i<l;i++){
							var d = data[i];
							where_temp += "'"+d.UNION_ORG_CODE+"'";
							if(i<l-1)
								where_temp += ",";
							sub_dev[d.UNION_ORG_CODE] = {branch_type:d.BRANCH_TYPE,grid_id_cnt:d.GRID_ID_CNT,grid_show: d.GRID_SHOW,mobile_mon_cum_new:d.MOBILE_MON_CUM_NEW,mobile_mon_cum_new_last: d.MOBILE_MON_CUM_NEW_LAST,cur_mon_bil_serv:d.CUR_MON_BIL_SERV,brd_mon_cum_new: d.BRD_MON_CUM_NEW,brd_mon_cum_new_last: d.BRD_MON_CUM_NEW_LAST,cur_mon_brd_serv: d.CUR_MON_BRD_SERV,itv_mon_new_install_serv: d.ITV_MON_NEW_INSTALL_SERV,itv_serv_cur_mon_new_last: d.ITV_SERV_CUR_MON_NEW_LAST,branch_hlzoom: d.BRANCH_HLZOOM,};
							var color_temp = d.COLOR;
							var sub_fill = "";
							if(color_temp==null){
								sub_fill = new SimpleFillSymbol(
										SimpleFillSymbol.STYLE_NULL,
										new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL, new Color([255,0,0,1]),2),//0.3],2
										new Color([255,0,0,1])//0.6
								);
							}else{
								var color = d.COLOR.split(",");
								sub_fill = new SimpleFillSymbol(
										SimpleFillSymbol.STYLE_SOLID,
										new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([color[0],color[1],color[2],1]),2),//0.3],2
										new Color([color[0],color[1],color[2],1])//0.6
								);
							}
							renderer.addValue(d.UNION_ORG_CODE, sub_fill);
						}
						where_temp += ")";
						featureLayer.setDefinitionExpression("MAPID = "+map_id + " AND "+where_temp);
						featureLayer.setRenderer(renderer);
						featureLayer.on("graphic-add",function(evt){
							var sub_gra_init = evt.graphic;
							var sub_attr = sub_gra_init.attributes;
							sub_graphics_init[sub_attr.SUBSTATION_NO] = sub_gra_init;
						});
						/*featureLayer.on("update-end",function(){
							featureLayer.redraw();
						});*/

						map.addLayer(featureLayer);

						map.addLayer(graLayer_mouseclick);
						map.addLayer(graLayer_subname_result);
						map.addLayer(graLayer_wg);

						map.addLayer(graLayer_sub_mouseover);
						map.addLayer(graLayer_zj_click);

						map.addLayer(graLayer_qx_all);

						map.addLayer(graLayer_grid_mouseover);
						map.addLayer(graLayer_wg_click);

						map.addLayer(graLayer_qx);

						map.addLayer(graLayer_zjname);
						map.addLayer(graLayer_wg_text);

						map.addLayer(graLayer_wd);

					});

					//20170614修改 此处是某地市下的市级名称，去分别查询下属的支局集合，用union_org_code拼接去查询地图里的substation
					var sub_data = new Array();
					featureLayer.on("update-end",function(){
						$.post(url4Query,{"eaction":"getSubListByLatnId","city_id":city_id},function(data){
							data = $.parseJSON(data);
							//data = data[0];
							if(data.length==0)
								return;
							else{
								var where_temp = "SUBSTATION_NO IN (";
								for(var i = 0,l = data.length;i<l;i++){
									sub_data[data[i].UNION_ORG_CODE] = data[i].BRANCH_NAME;
									var union_org_code = data[i].UNION_ORG_CODE;
									where_temp += "'"+union_org_code+"'";
									if(i<l-1)
										where_temp += ",";
								}
								where_temp += ")";
								var queryTask1 = new QueryTask(new_url_sub_grid + "/1");
								var query1 = new Query();
								query1.where = where_temp;
								query1.outFields = ['SHAPE.AREA','RESNAME','RESNO','SUBSTATION_NO','REPORTTO','RESID'];
								query1.returnGeometry = true;
								queryTask1.execute(query1, function (results){
									if(results.features.length==0)
										return;
									for(var j = 0,k = results.features.length;j<k;j++){
										var geo = results.features[j].geometry;
										var attr = results.features[j].attributes;
										var area = attr["SHAPE.AREA"];
										var substation = attr["SUBSTATION_NO"];
										var sub_name = sub_data[substation];
										var name_point = "";
										if(sub_name_speical[city_id]==undefined){//按latn_id，获取要特殊处理的支局
											var temp=geo.rings;
											name_point = getGravityCenter(geo,temp);
										}else{
											if(sub_name_speical[city_id][sub_name]==undefined){
												var temp=geo.rings;
												name_point = getGravityCenter(geo,temp);
											}else{
												name_point = geo;
											}
										}
										var font = new Font("12px", Font.WEIGHT_BOLD, Font.WEIGHT_BOLD,Font.WEIGHT_BOLD,"Microsoft Yahei");
										var textSymbol = new TextSymbol(sub_name,font, new Color(sub_name_text_color));
										var labelGraphic = new esri.Graphic(name_point, textSymbol);
										var sub_geo_attr = new Array();
										sub_geo_attr["sub_geo"] = geo;
										sub_geo_attr["sub_attr"] = attr;
										sub_geo_attr["sub_fill_gra"] = sub_graphics_init[substation];
										labelGraphic.setAttributes(sub_geo_attr);
										area = area*10000000000;
										if(area>500000000){
											sub_name_label_symbol7.push(labelGraphic);
										}else if(area>250000000){
											sub_name_label_symbol6.push(labelGraphic);
										}else if(area>200000000){//zoom=3 地图收到很小
											sub_name_label_symbol5.push(labelGraphic);
										}else if(area>70000000){ //zoom=4
											sub_name_label_symbol4.push(labelGraphic);
										}else if(area>2500000){ //zoom=5
											sub_name_label_symbol3.push(labelGraphic);
										}else if(area>300000){ //zoom=6
											sub_name_label_symbol2.push(labelGraphic);
										}else{ //zoom>=7 地图放到最大，看最清晰的支局
											sub_name_label_symbol1.push(labelGraphic);
										}
									}
									zj_name_show_hide();
								});
							}
						});

						//查询快捷键表格传递过来的支局
						var queryTask1 = new QueryTask(new_url_sub_grid + "/1");
						var query = new Query();

						var latn_name = pos_obj[1];
						if(city_name_speical.indexOf(latn_name)>-1)
							latn_name = latn_name.replace(/州/gi,'');
						else
							latn_name = latn_name.replace(/市/gi,'');

						query.where = "SUBSTATION_NO = "+sub_id+" AND MAPID = "+map_id;
						query.outFields = ["RESNO","REPORTTO"];
						query.returnGeometry = true;
						queryTask1.execute(query, function(results) {
							if(results.features.length==0){
								layer.msg("暂无查询结果");
								return;
							}
							var feature = results.features[0];
							var sub_name = feature.attributes.REPORTTO;
							parent.bar_status_history = parent.status;

							//所点支局的视野、名称

							var sub_selected_geometry = feature.geometry;
							sub_selected_ext = sub_selected_geometry.getExtent();
							if(zoom>-1){
								var temp=sub_selected_geometry.rings;
								var poly = new esri.geometry.Polygon(map.spatialReference);
								for(var j=0;j<temp.length;j++){
									var temp5=new Array();
									for(var m=0;m<temp[j].length;m++){
										var la=temp[j][m];
										var temp2=[la[0],la[1]];
										temp5.push(temp2);
									}
									poly.addRing(temp5);
								}
								var name_point = getGravityCenter(sub_selected_geometry,temp);
								map.centerAndZoom(name_point,zoom);
							}else{
								map.setExtent(sub_selected_ext.expand(1.5));
							}
							/*var graphics = new esri.Graphic(sub_selected_geometry, highlightSymbolzj,feature.attributes);
							 graLayer_sub_mouseover.add(graphics);
							 graLayer_sub_mouseover.show();
							 graLayer_sub_mouseover.redraw();*/
							var graphic = sub_graphics_init[sub_id];
							console.log(graphic);
							sub_gra_last = graphic;
							beforeMouseOverColor_sub=sub_gra_last._shape.fillStyle;

							currentOpacity = getLayerOpacity();
							graphic.setSymbol(highlightSymbolzj);

							freshTab(sub_id,"sub");

							//绘制所查询支局的归属区县的轮廓线
							drawQXLine(sub_id,sub_name);
						});
					});

					//描边所有区县的轮廓
					$.post(url4Query,{"eaction":"qx_nameList_all","city_name": area_name}, function (data) {
						data = $.parseJSON(data);
						if (data.length == 0)
							return;

						var index = 0;
						var colors_temp = new Array();
						//区县大板块填充色
						for (var i = 0, l = data.length; i < l; i++) {
							var queryTask = new QueryTask(layer_ds + "/" + city_gis_tiled_layerids[city_name]);
							var query = new Query();
							var name_temp = data[i].ORG_NAME;
							var name = name_short_array[name_temp];
							if(name==undefined)
								name = name_temp;
							query.where = "NAME = '" + name + "'";
							query.outFields = ['NAME'];
							query.returnGeometry = true;
							queryTask.execute(query, function (results) {
								//var color = city_colors[i];
								var l = results.features.length;
								if (l == 0)//没有对应区县地图数据
									return;

								for(var i = 0;i<l;i++){
									var geometry = results.features[i].geometry;
									qx_geometry = geometry;
									back_to_ext = geometry;
									var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_all_line_color), 1.5);
									var graphics = new esri.Graphic(geometry, linesymbol);
									graLayer_qx_all.add(graphics);
								}
							});
						}
					});

					//支局名称层添加每个名字
					var addSubLabel = function(font_size,label_symbols){
						for(var i = 0,l = label_symbols.length;i<l;i++){
							var graphics = label_symbols[i];
							var text = graphics.symbol.text;
							var geometry = graphics.geometry;
							var attr = graphics.attributes;
							var font = new Font(font_size, Font.WEIGHT_BOLD, Font.WEIGHT_BOLD,Font.WEIGHT_BOLD,"Microsoft Yahei");
							if(text.length>7)
								text = text.substr(0,7)+" \n "+text.substr(7);
							var textSymbol = new TextSymbol(text,font, new Color(sub_name_text_color));
							var labelGraphic = new esri.Graphic(geometry, textSymbol);
							labelGraphic.setAttributes(attr);
							graLayer_zjname.add(labelGraphic);
						}
					}

					//网格名称层添加每个名字
					var addGridLabel = function(font_size,label_symbols){
						for(var i = 0,l = label_symbols.length;i<l;i++){
							var graphics = label_symbols[i];
							var text = graphics.symbol.text;
							var geometry = graphics.geometry;
							var attr = graphics.attributes;
							var font = new Font(font_size, Font.WEIGHT_BOLD, Font.WEIGHT_BOLD,Font.WEIGHT_BOLD,"Microsoft Yahei");
							if(text.length>5)
								text = text.substr(0,5)+" \n "+text.substr(5);
							var textSymbol = new TextSymbol(text,font, new Color(grid_name_text_color));
							var labelGraphic = new esri.Graphic(geometry, textSymbol);
							labelGraphic.setAttributes(attr);
							graLayer_wg_text.add(labelGraphic);
						}
					}

					//支局名称层刷新
					var zj_name_show_hide = function(){
						var current_zoom = map.getZoom();
						if(current_zoom>6){
							addSubLabel("15px",sub_name_label_symbol1);
							addSubLabel("15px",sub_name_label_symbol2);
							addSubLabel("15px",sub_name_label_symbol3);
							addSubLabel("15px",sub_name_label_symbol4);
							addSubLabel("15px",sub_name_label_symbol5);
							addSubLabel("15px",sub_name_label_symbol6);
							addSubLabel("15px",sub_name_label_symbol7);
						}else if(current_zoom==6){
							addSubLabel("14px",sub_name_label_symbol2);
							addSubLabel("14px",sub_name_label_symbol3);
							addSubLabel("14px",sub_name_label_symbol4);
							addSubLabel("14px",sub_name_label_symbol5);
							addSubLabel("14px",sub_name_label_symbol6);
							addSubLabel("14px",sub_name_label_symbol7);
						}else if(current_zoom==4 || current_zoom==5){
							addSubLabel("13px",sub_name_label_symbol3);
							addSubLabel("13px",sub_name_label_symbol4);
							addSubLabel("13px",sub_name_label_symbol5);
							addSubLabel("13px",sub_name_label_symbol6);
							addSubLabel("13px",sub_name_label_symbol7);
						}else if(current_zoom==3){
							addSubLabel("13px",sub_name_label_symbol4);
							addSubLabel("13px",sub_name_label_symbol5);
							addSubLabel("13px",sub_name_label_symbol6);
							addSubLabel("13px",sub_name_label_symbol7);
						}else if(current_zoom==2){
							addSubLabel("10px",sub_name_label_symbol6);
							addSubLabel("10px",sub_name_label_symbol7);
						}else if(current_zoom==1){
							addSubLabel("10px",sub_name_label_symbol7);
						}
					}

					//网格名称层刷新
					var wg_name_show_hide = function(){
						var current_zoom = map.getZoom();
						if(current_zoom>6){
						//if(true){
							addGridLabel("12px",grid_name_label_symbol1);
							addGridLabel("12px",grid_name_label_symbol2);
							addGridLabel("12px",grid_name_label_symbol3);
							addGridLabel("12px",grid_name_label_symbol4);
							addGridLabel("12px",grid_name_label_symbol5);
						}else if(current_zoom==6){
							addGridLabel("12px",grid_name_label_symbol2);
							addGridLabel("12px",grid_name_label_symbol3);
							addGridLabel("12px",grid_name_label_symbol4);
							addGridLabel("12px",grid_name_label_symbol5);
						}else if(current_zoom==4 || current_zoom==5){
							addGridLabel("12px",grid_name_label_symbol3);
							addGridLabel("12px",grid_name_label_symbol4);
							addGridLabel("12px",grid_name_label_symbol5);
						}else if(current_zoom==3){
							addGridLabel("12px",grid_name_label_symbol4);
							addGridLabel("12px",grid_name_label_symbol5);
						}else if(current_zoom==2){
							addGridLabel("12px",grid_name_label_symbol5);
						}else if(current_zoom==1){
							addGridLabel("12px",grid_name_label_symbol5);
						}
					}

					//根据地图放大级别设置名称的字体大小
					var fontSizeChange = function(){
						var current_zoom = map.getZoom();
						var font_size = 0;
						if(current_zoom>6)
							font_size = 15;
						else if(current_zoom==6)
							font_size = 14;
						else if(current_zoom==5)
							font_size = 8;
						return font_size;
					};

					//获取图形重心（中心点），用来添加名称到合适的位置
					var getGravityCenter = function(polygon,temp){
						var ext=polygon.getExtent();
						var p0=new Point(ext.xmin, ext.ymin, new SpatialReference({ wkid: 4326 }));
						var momentX=0;
						var momentY=0;
						var weight=0;
						for(var j=0;j<temp.length;j++){
							var pts=temp[j];
							for(var m=0;m<pts.length;m++){
								var p1=polygon.getPoint(j,m);
								var p2;
								if(m==pts.length-1){
									p2 = polygon.getPoint(j, 0);
								}else{
									p2 = polygon.getPoint(j, m+1);
								}
								var dWeight=(p1.x-p0.x)*(p2.y-p1.y)-(p1.x-p0.x)*(p0.y-p1.y)/2- (p2.x-p0.x)*(p2.y-p0.y)/2-(p1.x-p2.x)*(p2.y-p1.y)/2;
								weight += dWeight;
								var pTmp=new Point((p1.x+p2.x)/2, (p1.y+p2.y)/2, new SpatialReference({ wkid: 4326 }));
								var gravityX=p0.x + (pTmp.x-p0.x)*2/3;
								var gravityY=p0.y + (pTmp.y-p0.y)*2/3;
								momentX += gravityX*dWeight;
								momentY += gravityY*dWeight;
							}
						}
						var bbb=new Point(momentX/weight, momentY/weight, new SpatialReference({ wkid: 4326 }));
						return bbb;
					}

					var getLayerOpacity = function(){
						var current_zoom = map.getZoom();
						var opacity = 1;
						if(city_id=='947'){
							if(current_zoom>9)
								opacity = 0.1;
							else if(current_zoom==9)
								opacity = 0.2;
							else if(current_zoom==8)
								opacity = 0.4;
							else if(current_zoom==7)
								opacity = 0.7;
							else if(current_zoom==6)
								opacity = 0.9;
							else if(current_zoom==5)
								opacity = 0.9;
							else if(current_zoom==4)
								opacity = 0.9;
							else if(current_zoom==3)
								opacity = 0.9;
							else if(current_zoom==2)
								opacity = 0.9;
							else if(current_zoom==1)
								opacity = 1;
						}else{
							if(current_zoom>9)
								opacity = 0.1;
							else if(current_zoom==9)
								opacity = 0.2;
							else if(current_zoom==8)
								opacity = 0.3;
							else if(current_zoom==7)
								opacity = 0.4;
							else if(current_zoom==6)
								opacity = 0.5;
							else if(current_zoom==5)
								opacity = 0.6;
							else if(current_zoom==4)
								opacity = 0.7;
							else if(current_zoom==3)
								opacity = 0.8;
							else if(current_zoom==2)
								opacity = 0.9;
							else if(current_zoom==1)
								opacity = 1;
						}
						return opacity;
					}

					//根据地图放大缩小级别设定图层透明度
					var layerOpacityChange = function(){
						var opacity = getLayerOpacity();
						featureLayer.setOpacity(opacity);
						graLayer_wg.setOpacity(opacity);
					}


					var channel_point_get_size = function(){
						var current_zoom = map.getZoom();
						var size = 0
						if(current_zoom>6){
							size = 22;
						}else if(current_zoom==6){
							size = 20;
						}else if(current_zoom==4 || current_zoom==5){
							size = 18;
						}else if(current_zoom==3){
							size = 15;
						}else if(current_zoom==2){
							size = 12;
						}else if(current_zoom==1){
							size = 10;
						}
						return size;
					}
					var channel_point_resize = function(){
						var size = channel_point_get_size();
						var gs = graLayer_wd.graphics;
						if(gs.length==0)
							return;
						var gs_new = new Array();
						var geo_new = new Array();
						var attr_new = new Array();
						for(var i = 0,l = gs.length;i<l;i++){
							var sym = gs[i].symbol;
							sym.width = size;
							sym.height = size;
							gs_new.push(sym);
							geo_new.push(gs[i].geometry);
							attr_new.push(gs[i].attributes);
						}
						graLayer_wd.clear();
						for(var i = 0,l = gs_new.length;i<l;i++){
							var pointAttributes = attr_new[i];//{address:'101',city:'Portland',state:'Oregon'};
							var img = new PictureMarkerSymbol(gs_new[i].url, gs_new[i].width, gs_new[i].height);
							var graphic = new esri.Graphic(geo_new[i],img,pointAttributes);
							graLayer_wd.add(graphic);
						}
					}
					
					//处理地图视野改变事件，拖拽、滚轮、聚焦
					map.on("extent-change", function(){
						var mapZoom = map.getZoom();
						graLayer_zjname.clear();
						graLayer_wg_text.clear();
						//地图缩放的时候zoom大，地图放大的时候zoom小
						zj_name_show_hide();
						wg_name_show_hide();
						layerOpacityChange();
						graLayer_zjname.redraw();
						graLayer_wg_text.redraw();
						channel_point_resize();
					});

					var sub_gra_last = "";//最后一次点击的支局
					var grid_gra_last = "";//最后一次点击的网格
					var beforeMouseOverColor_sub = "";
					var beforeMouseOverColor_grid = "";
					var subFillRecover = function(){
						//还原上次所点支局的颜色
						if(sub_gra_last!=undefined && sub_gra_last!=""){
							var color = beforeMouseOverColor_sub;
							var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
									new esri.Color([color.r,color.g,color.b,color.a]), 3),new esri.Color([color.r,color.g,color.b,color.a]));
							sub_gra_last.setSymbol(symbol);
						}
					};
					var gridFillRecover = function(){
						//还原上次所点支局的颜色
						if(grid_gra_last!=undefined && grid_gra_last!=""){
							var color = beforeMouseOverColor_grid;
							var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
									new esri.Color([color.r,color.g,color.b,color.a]), 3),new esri.Color([color.r,color.g,color.b,color.a]));
							grid_gra_last.setSymbol(symbol);
						}
					};

					var drawQXLine = function(substation,sub_name){
						global_param_temp_for_subgridlist.position.splice(3,1,sub_name);

						if(city_id==947){
							return;//嘉峪关不处理有关区县变化
						}

						//设置所点支局归属的区县的范围轮廓线
						$.post(url4Query,{eaction:"getAreaNameBySubId",sub_id:substation,city_id:city_id},function(data){
							data = $.parseJSON(data);
							var qx_name_temp = data.ORG_NAME;
							var qx_name = name_short_array[qx_name_temp];
							if(qx_name==undefined)
								qx_name = qx_name_temp;
							global_param_temp_for_subgridlist.position.splice(2,1,qx_name);

							//parent.updatePosition(parent.global_current_flag);

							var queryTask_tile = new QueryTask(layer_ds + "/" + city_gis_tiled_layerids[city_name]);
							var query_tile = new Query();
							query_tile.where = "NAME = '" + qx_name + "'";//某区县名
							query_tile.returnGeometry = true;

							queryTask_tile.execute(query_tile, function (results) {
								graLayer_qx.clear();
								//指定范围的结果
								var feature = results.features;
								//显示圈定范围的业务图层
								//区县会有分开多个部分绘制的情况
								var l = feature.length;
								for(var i = 0;i<l;i++){
									var geometry = feature[i].geometry;
									qx_geometry = geometry;

									var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_clicked_line_color), 2.5);
									var graphics = new esri.Graphic(geometry, linesymbol);
									graLayer_qx.add(graphics);
								}
								if(l==1){
									back_to_ext = geometry;
								}
							});
						});
					}

					featureLayer.on("mouse-over", function(evt){
						//防止事件冒泡
						dojo.stopEvent(evt);
						evt.stopPropagation();
						//手型
						map.setMapCursor("pointer");
						//之前支局颜色恢复
						subFillRecover();
						//保留此次支局状态以便下次恢复
						var graphic = evt.graphic;
						sub_gra_last = graphic;
						beforeMouseOverColor_sub=sub_gra_last._shape.fillStyle;

						//设置高亮显示
						currentOpacity = getLayerOpacity();
						graphic.setSymbol(highlightSymbolzj);

						//显示支局基本信息
						var attr = graphic.attributes;
						showSubInfoWin(attr);
					});
					
					graLayer_zjname.on("mouse-over",function(evt){
						//防止事件冒泡
						dojo.stopEvent(evt);
						evt.stopPropagation();
						//手型
						map.setMapCursor("pointer");
						//之前支局颜色恢复
						subFillRecover();

						var attr = evt.graphic.attributes;

						try{
							//设置此次支局状态以便下次恢复
							sub_gra_last = attr["sub_fill_gra"];
							beforeMouseOverColor_sub = sub_gra_last.getShape().getFill();
						}catch(e){

						}
						//设置高亮
						currentOpacity = getLayerOpacity();
						attr["sub_fill_gra"].setSymbol(highlightSymbolzj);

						var attrs = attr.sub_attr;
						showSubInfoWin(attrs);
					});

					graLayer_zjname.on("mouse-out",function(evt){
						$("#sub_info_win").hide();
						map.setMapCursor("default");
						//map.infoWindow.hide();
						subFillRecover();
					});
					featureLayer.on("mouse-out", function(evt){
						$("#sub_info_win").hide();
						//map.infoWindow.hide();
						map.setMapCursor("default");
						subFillRecover();
					});
					
					map.on("mouse-move", function(evt){
						if(evt.target.id=="gismap_gc"){
							graLayer_sub_mouseover.clear();
							graLayer_grid_mouseover.clear();
							$("#sub_info_win").hide();
							$("#grid_info_win").hide();
							map.setMapCursor("default");
						}
					});


					//支局到网格的下钻操作
					var subToGrid = function(graphics,sub_selected_geometry,sub_attr){
						back_to_ext = map.extent;

						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").hide();
						$("#nav_fanhui_sub").show();
						$("#nav_fanhui_qx").hide();

						graLayer_wg.clear();
						graLayer_wg_text.clear();
						graLayer_wg.show();
						graLayer_wg_text.show();

						featureLayer.hide();
						graLayer_zjname.hide();
						graLayer_qx.hide();
						graLayer_qx_all.hide();
						graLayer_subname_result.clear();

						var sub_selected_ext = sub_selected_geometry.getExtent();
						map.setExtent(sub_selected_ext.expand(1.5));

						featureLayer.hide();//隐藏全部支局的层
						graLayer_zjname.hide();
						graLayer_qx.hide();
						graLayer_qx_all.hide();

						//var sub_name = evt.graphic.attributes.REPORTTO;

						var sub_name = sub_data[sub_attr.SUBSTATION_NO];
						var substation = sub_attr.SUBSTATION_NO;
						var resid = sub_attr.RESID;

						drawQXLine(substation,sub_name);

						global_param_temp_for_subgridlist["current_flag"] = 4;
						global_param_temp_for_subgridlist["current_full_area_name"] = sub_name;
						global_param_temp_for_subgridlist["current_area_name"] = sub_name;
						global_param_temp_for_subgridlist["current_sub_id"] = substation;
						parent.global_param_temp_for_subgridlist = global_param_temp_for_subgridlist;

						grid_name_label_symbol1 = new Array();
						grid_name_label_symbol2 = new Array();
						grid_name_label_symbol3 = new Array();
						grid_name_label_symbol4 = new Array();
						grid_name_label_symbol5 = new Array();

						graLayer_mouseclick.clear();

						//支局中有网格时候，给所点支局加边框或填充效果
						//var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(click_line_color_sub), 2);
						//填充所点支局，不加边线
						if(beforeMouseOverColor_sub=="" || beforeMouseOverColor_sub==undefined)
							beforeMouseOverColor_sub = {r:128,g:128,b:128};
						var fillsymbol1 = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS,
								new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,
										new esri.Color([255,0,0]), 2),new esri.Color([beforeMouseOverColor_sub.r, beforeMouseOverColor_sub.g, beforeMouseOverColor_sub.b,0.25])
						);
						var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol1);
						//graphic.setAttributes(sub_attr);
						graLayer_mouseclick.add(graphic);
						graLayer_mouseclick.show();

						//查询支局对应的网格（用业务图层的resid，查对应关系表(sub_id)，获取网格的资源resid，用资源id在网格图层查询resid）
						$.post(url4Query, {eaction:'grids_in_subBySubResid',sub_id: resid, city_id: city_id}, function (data) {
							data = $.parseJSON(data);
							if (data.length == 0){
								//layer.msg("该支局的网格暂未上图",{time:2000});
								//back_to_ext = "";
								//该支局下没有一个网格的时候，支局填充后，写“xx支局 [换行] 未划配网格”
								var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
								font.setFamily("微软雅黑");
								var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
								//合并geo中的碎片块
								var temp=sub_selected_geometry.rings;
								var poly = new esri.geometry.Polygon(map.spatialReference);
								for(var j=0;j<temp.length;j++){
									var temp5=new Array();
									for(var m=0;m<temp[j].length;m++){
										var la=temp[j][m];
										var temp2=[la[0],la[1]];
										temp5.push(temp2);
									}
									poly.addRing(temp5);
								}

								var name_point = getGravityCenter(sub_selected_geometry,temp);
								var labelGraphic = new esri.Graphic(name_point, textSymbol);
								graLayer_subname_result.clear();
								graLayer_subname_result.add(labelGraphic);
								graLayer_subname_result.redraw();
								return;
							}

							var where_temp = "RESID IN (";
							for (var i = 0, l = data.length; i < l; i++) {
								var resid = data[i].RESID;
								where_temp += "'" + resid + "'";
								if (i < l - 1)
									where_temp += ",";
							}
							where_temp += ")";

							var queryTask1 = new esri.tasks.QueryTask(new_url_sub_grid + "/0");
							var query1 = new esri.tasks.Query();
							query1.where = where_temp;
							query1.outFields = ['SHAPE.AREA', 'RESNAME', 'RESID', 'REPORTTO', 'REPORT_TO_ID'];
							query1.returnGeometry = true;
							queryTask1.execute(query1, function (results) {
								var l = results.features.length;
								if (l == 0){
									//layer.msg("该支局的网格暂未上图");
									//back_to_ext = "";
									//grid_name_text_color
									var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
									font.setFamily("微软雅黑");
									var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
									//合并geo中的碎片块
									var temp=sub_selected_geometry.rings;
									var poly = new esri.geometry.Polygon(map.spatialReference);
									for(var j=0;j<temp.length;j++){
										var temp5=new Array();
										for(var m=0;m<temp[j].length;m++){
											var la=temp[j][m];
											var temp2=[la[0],la[1]];
											temp5.push(temp2);
										}
										poly.addRing(temp5);
									}

									var name_point = getGravityCenter(sub_selected_geometry,temp);
									var labelGraphic = new esri.Graphic(name_point, textSymbol);
									graLayer_subname_result.add(labelGraphic);
									graLayer_subname_result.redraw();
									return;
								}
								//支局中的网格的REPORT_TO_ID为空，则不能下钻
								var hasNoRepotId = 0;
								for(var i = 0;i<l;i++){
									var feature = results.features[i];
									var id = feature.attributes["REPORT_TO_ID"];
									if($.trim(id)=="" || id ==null){
										hasNoRepotId += 1;
									}
								}
								//所有的网格都没有REPORT_TO_ID
								if(hasNoRepotId==l){
									var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
									font.setFamily("微软雅黑");
									var textSymbol = new esri.symbol.TextSymbol(sub_name+" \n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
									//合并geo中的碎片块
									var temp=sub_selected_geometry.rings;
									var poly = new esri.geometry.Polygon(map.spatialReference);
									for(var j=0;j<temp.length;j++){
										var temp5=new Array();
										for(var m=0;m<temp[j].length;m++){
											var la=temp[j][m];
											var temp2=[la[0],la[1]];
											temp5.push(temp2);
										}
										poly.addRing(temp5);
									}

									var name_point = getGravityCenter(sub_selected_geometry,temp);
									var labelGraphic = new esri.Graphic(name_point, textSymbol);
									graLayer_subname_result.clear();
									graLayer_subname_result.add(labelGraphic);
									graLayer_subname_result.redraw();
									return;
								}

								//使用配色数组填充网格背景
								for (var i = 0,k = 0; i < l; i++,k++) {
									//使用支局背景色填充网格背景
									//for (var i = 0; i < l; i++) {
									var feature = results.features[i];
									var report_to_id = feature.attributes["REPORT_TO_ID"];
									if($.trim(report_to_id)=="")//网格中REPORT_TO_ID为空的不绘制该网格
										continue;
									var geo = feature.geometry;
									//合并geo中的碎片块
									var temp=geo.rings;
									var poly = new esri.geometry.Polygon(map.spatialReference);
									for(var j=0;j<temp.length;j++){
										var temp5=new Array();
										for(var m=0;m<temp[j].length;m++){
											var la=temp[j][m];
											var temp2=[la[0],la[1]];
											temp5.push(temp2);
										}
										poly.addRing(temp5);
									}
									//用隶属的支局颜色填充每个网格的颜色
									//var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, beforeMouseOverColor.g, beforeMouseOverColor.b.a]));//fill_color_array[i]

									if(k>fill_color_array.length-1)
										k = 0;
									var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
									fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), 2));//STYLE_DASH，click_line_color_grid
									var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
									graphic.setAttributes(feature.attributes);
									graLayer_wg.add(graphic);

									var area = feature.attributes["SHAPE.AREA"];
									var font = new esri.symbol.Font("12px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
									font.setFamily("微软雅黑");

									var grid_name = feature.attributes.REPORTTO;
									if($.trim(grid_name)=="")
										grid_name = feature.attributes.RESNAME;
									grid_name = grid_name.substr(grid_name.indexOf("-")+1);
									var textSymbol = new esri.symbol.TextSymbol(grid_name, font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
									//textSymbol.setHaloColor(new esri.Color([255, 0, 0]));
									//textSymbol.setHaloSize(10);
									var name_point = getGravityCenter(geo,temp);

									var labelGraphic = new esri.Graphic(name_point, textSymbol);
									var grid_geo_attr = new Array();
									grid_geo_attr["grid_geo"] = geo;
									grid_geo_attr["grid_attr"] = feature.attributes;
									grid_geo_attr["grid_fill_gra"] = graphic;
									labelGraphic.setAttributes(grid_geo_attr);
									area = area*10000000000;
									if (area > 500000000) {//zoom=3 地图收到很小
										grid_name_label_symbol5.push(labelGraphic);
									} else if (area > 70000000) { //zoom=4
										grid_name_label_symbol4.push(labelGraphic);
									} else if (area > 8000000) { //zoom=5
										grid_name_label_symbol3.push(labelGraphic);
									} else if (area > 300000) { //zoom=6
										grid_name_label_symbol2.push(labelGraphic);
									} else { //zoom>=7 地图放到最大，看最清晰的支局
										grid_name_label_symbol1.push(labelGraphic);
									}
									//根据当前地图放大级别，写网格名称到图层上
								}
								wg_name_show_hide();
							});
						});

						//右侧联动
						freshTab(substation,"sub");
					};
					
					var gridToEnd = function(attr){
						subToGridFlag = true;

						var grid_name = attr.REPORTTO;
						if($.trim(grid_name)=="")
							grid_name = attr.RESNAME;

						grid_name = grid_name.substr(grid_name.indexOf("-")+1);

						global_param_temp_for_subgridlist["current_flag"] = 5;
						global_param_temp_for_subgridlist["current_full_area_name"] = grid_name;
						global_param_temp_for_subgridlist["current_area_name"] = grid_name;
						parent.global_param_temp_for_subgridlist = global_param_temp_for_subgridlist;

						var global_position = global_param_temp_for_subgridlist["position"];
						global_position.splice(4, 1, grid_name);
						parent.global_position = global_position;

						//右侧联动
						freshTab(attr.RESID,"grid");
					}

					//支局下钻到网格
					var sub_gra_clicked = "";//记录点击过的支局，以便设置其高亮的颜色（在backToSub方法中）
					//支局板块点击
					featureLayer.on("click", function(evt) {
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var graphics = evt.graphic;
						sub_gra_clicked = graphics;

						var sub_selected_geometry = graphics.geometry;
						var sub_attr = graphics.attributes;

						subToGrid(graphics,sub_selected_geometry,sub_attr);
					});

					//支局名称点击
					graLayer_zjname.on("click",function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var attrs = evt.graphic.attributes;
						var graphics = attrs.sub_fill_gra;
						sub_gra_clicked = graphics;

						//定位到所点支局的视野
						var sub_selected_geometry = attrs.sub_geo;
						var sub_attr = attrs.sub_attr;

						subToGrid(graphics,sub_selected_geometry,sub_attr);
					});

					//从支局下钻到网格后，是否点击过网格，点击后表示下钻到网格，此时返回才刷新右侧为支局，否则仍然为支局，不刷新
					var subToGridFlag = false;
					//从网格返回支局
					backToSub = function(){
						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").show();
						$("#nav_fanhui_sub").hide();

						graLayer_subname_result.clear();
						graLayer_mouseclick.clear();
						/*graLayer_mouseclick.clear();
						 graLayer_mouseclick.hide();
						 graLayer_zj_click.clear();
						 graLayer_wg_click.clear();*/
						graLayer_wg.clear();
						graLayer_wg_text.clear();
						graLayer_wg.hide();
						graLayer_wg_text.hide();
						//graLayer_grid_mouseover.clear();

						featureLayer.show();
						graLayer_zjname.show();
						graLayer_qx.show();
						graLayer_qx_all.show();

						if(back_to_ext=="")
							back_to_ext = map.extent;
						var ext = back_to_ext.getExtent();

						map.setExtent(ext);

						zj_name_show_hide();

						//设置所选支局为高亮
						currentOpacity = getLayerOpacity();
						sub_gra_clicked.setSymbol(highlightSymbolzj);

						var global_param_temp_for_subgridlist = parent.global_param_temp_for_subgridlist;
						global_param_temp_for_subgridlist["current_flag"] = 4;
						//global_param_temp_for_subgridlist["current_full_area_name"] = sub_name;
						//global_param_temp_for_subgridlist["current_area_name"] = sub_name;
						//global_param_temp_for_subgridlist["current_sub_id"] = substation;
						parent.global_param_temp_for_subgridlist = global_param_temp_for_subgridlist;
						//parent.updateTabPosition();

						if(subToGridFlag){
							freshTab(global_param_temp_for_subgridlist["current_sub_id"],"sub");
							subToGridFlag = false;
						}
					}

					map.on("mouse-move", function(evt){
						if(evt.target.id=="gismap_gc"){
							//graLayer_sub_mouseover.clear();
							//graLayer_grid_mouseover.clear();

							map.setMapCursor("default");
							subFillRecover();
						}
					});

					//20170620修改 新增网点展示功能
					var queryTask_wd = new QueryTask(new_url_point + "/0");
					var query_wd = new Query();
					query_wd.where = "CLASS4 = '实体渠道' AND LATN_ID = "+ city_id +"";
					query_wd.outFields = ['CLASS3_ID','CHANNEL_NA','CHANNEL_AD'];
					query_wd.returnGeometry = true;
					var city_geometry = "";//所展示市级范围的图形对象
					queryTask_wd.execute(query_wd, function (results) {
						if(results.features.length==0)
							return;
						var size = channel_point_get_size();//获取当前放大级别下，渠道网点图标的大小
						for(var i = 0,l = results.features.length;i<l;i++){
							var feature = results.features[i];
							var geo = feature.geometry;
							var class3_id = feature.attributes.CLASS3_ID;

							var pointAttributes = {CHANNEL_NA:feature.attributes.CHANNEL_NA,CHANNEL_AD:feature.attributes.CHANNEL_AD,CLASS3_ID:class3_id};
							var img = new PictureMarkerSymbol(channel_ico[class3_id], size, size);
							var graphic = new esri.Graphic(geo,img,pointAttributes);
							graLayer_wd.add(graphic);
						}
					});

					var click_time = "";//保存上次点击过的时刻，解决冒泡事件
					graLayer_wd.on("mouse-over",function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						map.infoWindow.hide();
						map.setMapCursor("pointer");

						if(click_time=="")//第一次点击
							click_time = new Date().getTime();
						else{
							if(new Date().getTime()-click_time<100)//两次操作小于半秒，可能是冒泡引起的
								return;
							click_time = new Date().getTime();
						}
						var attr = evt.graphic.attributes;

						var address = attr.CHANNEL_AD;

						var global_current_flag = 7;

						map.infoWindow.setTitle("网点信息");
						map.infoWindow.resize(260,200);

						var ems = $("#channel_info_win").find("em");
						$(ems[0]).html(attr.CHANNEL_NA);
						$(ems[1]).html(attr.CHANNEL_AD);
						$(ems[2]).html(channel_type_array[attr.CLASS3_ID]);

						map.infoWindow.show(evt.screenPoint);
						$.post(url4Query,{eaction:"index_get_by_channel_name",channel_name:attr.CHANNEL_NA,date:'${yesterday.VAL}',city_name:city_name},function(data) {
							data = $.parseJSON(data);
							if(data=='' || data ==null){
								$(ems[3]).html("- -");
								$(ems[4]).html("- -");
								$(ems[5]).html("- -");
								$(ems[6]).html("- -");
								$(ems[7]).html("- -");
								$(ems[8]).html("- -");
							}else{
								$(ems[3]).html(data.YD_CURRENT_MON_DEV);
								$(ems[4]).html(data.YD_CURRENT_DAY_DEV);
								$(ems[5]).html(data.KD_CURRENT_MON_DEV);
								$(ems[6]).html(data.KD_CURRENT_DAY_DEV);
								$(ems[7]).html(data.ITV_CURRENT_MON_DEV);
								$(ems[8]).html(data.ITV_CURRENT_DAY_DEV);
							}
							$(".contentPane").empty();
							$(".contentPane").append($("#channel_info_win").html());
						});
					});
					graLayer_wd.on("mouse-out",function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						map.infoWindow.hide();
					});

					var showSubInfoWin = function(attrs){
						/*map.infoWindow.setTitle("支局信息");
						 map.infoWindow.resize(260,200);*/

						var attr = sub_dev[attrs["SUBSTATION_NO"]];//attrs["sub_dev"];
						var ems = $("#sub_info_win").find("em");
						$(ems[0]).html(sub_data[attrs["SUBSTATION_NO"]]);

						$(ems[1]).html(attr["grid_id_cnt"]);
						var grid_hide = attr["grid_show"];
						if(grid_hide==0){
							$(ems[2]).prev().hide();
							$(ems[2]).hide();
							$(ems[2]).next().hide();
						}else{
							$(ems[2]).html(grid_hide);
							$(ems[2]).prev().show();
							$(ems[2]).show();
							$(ems[2]).next().show();
						}

						$(ems[3]).html(attr["branch_type"]);
						$(ems[4]).html(attr["mobile_mon_cum_new"]);
						//$(ems[5]).html(attr["cur_mon_bil_serv"]);
						$(ems[5]).html(attr["mobile_mon_cum_new_last"]);
						$(ems[6]).html(attr["brd_mon_cum_new"]);
						//$(ems[7]).html(attr["cur_mon_brd_serv"]);
						$(ems[7]).html(attr["brd_mon_cum_new_last"]);
						$(ems[8]).html(attr["itv_mon_new_install_serv"]);
						//$(ems[9]).html("1");
						$(ems[9]).html(attr["itv_serv_cur_mon_new_last"]);

						$("#sub_info_win").show();
						//var win_content = $("#sub_info_win").html();
						//map.infoWindow.setContent(win_content);
						//map.infoWindow.show(evt.screenPoint);
						//var winPos = new Point(map.extent.xmax, map.extent.ymin, new SpatialReference({ wkid: 4326 }));
						//map.infoWindow.show(winPos);
					}

					var showGridInfoWin = function(graphics,attr){
						map.setMapCursor("pointer");

						gridFillRecover();

						//记录此次网格及其颜色，以便下次还原
						grid_gra_last = graphics;
						beforeMouseOverColor_grid=graphics._shape.fillStyle;
						//var zoom = map.getZoom();
						currentOpacity = beforeMouseOverColor_grid.a;
						highlightSymbolzj_grid.color.a = currentOpacity;
						graphics.setSymbol(highlightSymbolzj_grid);

						var grid_name = attr.REPORTTO;
						if($.trim(grid_name)=="")
							grid_name = attr.RESNAME;

						var report_to_id = attr.REPORT_TO_ID;
						report_to_id = $.trim(report_to_id);
						if(report_to_id==""||report_to_id=="null")
							win_content = "<span>暂无关联数据</span>";
						else{
							$.post(url4Query,{eaction:'getGridDevByRepttoNo',repttoNo:report_to_id,date:'${yesterday.VAL}'},function(data){
								data = $.parseJSON(data);
								if(data==null||data=="")
									win_content = "<span>暂无关联数据</span>";
								else{
									//data = {"BRANCH_NAME":"1","MOBILE_SERV_DAY_NEW":1,"BRD_SERV_DAY_NEW":2,"ITV_SERV_DAY_NEW":3,"ITV_DAY_NEW_INSTALL_SERV":4};
									/*win_content =  "<span>归属:"+data.BRANCH_NAME+"</span><br/>"+
									 "<table><tr><td>移动</td><td>"+data.MOBILE_SERV_DAY_NEW+"</td></tr>"
									 +"<tr><td>宽带</td><td>"+data.BRD_SERV_DAY_NEW +"</td></tr>"
									 +"<tr><td>ITV</td><td>"+data.ITV_SERV_DAY_NEW+"</td></tr>"
									 +"<tr><td>ITV装机</td><td>"+data.ITV_DAY_NEW_INSTALL_SERV+"</td></tr></table>"*/
									/*win_content = "<table style='width: 100%;'>"+
									 "<tr style='font-size: 1.4em;'><td colspan=\"3\" style='font-weight: bold;color: red;padding-bottom: 2px;font-family:\"Microsoft Yahei\";'>网格名称："+attr.REPORTTO.substr(attr.REPORTTO.indexOf("-")+1)+"</td></tr>"+
									 "<tr style='font-size: 1.4em;'><td colspan=\"3\" style='font-weight: bold;color: black;padding-bottom: 2px;font-family:\"Microsoft Yahei\";'>所属支局："+data.BRANCH_NAME+"</td></tr>"+
									 "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;border-right: 1px solid #bab9cf;padding-right: 5px;font-family:\"Microsoft Yahei\";'>指标名称</td><td style='font-weight: bold;padding-left: 5px;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;border-right: 1px solid #bab9cf;padding-right: 5px;font-family:\"Microsoft Yahei\";'>当日发展</td><td style='font-weight: bold;padding-left: 5px;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;font-family:\"Microsoft Yahei\";'>当月发展</td></tr>"+
									 "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>移动</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.MOBILE_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.MOBILE_MON_CUM_NEW+"</td></tr>"+
									 "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>宽带</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.BRD_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.BRD_MON_CUM_NEW+"</td></tr>"+
									 "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> ITV</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.ITV_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.ITV_SERV_CUR_MON_NEW+"</td></tr>"+
									 "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> 终端</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.LA_TERMINAL_TOTAL+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.CUR_TERMINAL_TOTAL_MON+"</td></tr>"+
									 "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> 800M</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.LA_COUNT_800M+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.CUR_COUNT_800M_MON+"</td></tr>"+
									 "</table>";*/
									var ems = $("#grid_info_win").find("em");
									$(ems[0]).html(grid_name.substr(grid_name.indexOf("-")+1));

									$(ems[1]).html(data.BRANCH_NAME);
									$(ems[2]).html(data.MOBILE_SERV_DAY_NEW);

									$(ems[3]).html(data.MOBILE_MON_CUM_NEW);
									$(ems[4]).html(data.BRD_SERV_DAY_NEW);
									$(ems[5]).html(data.BRD_MON_CUM_NEW);
									$(ems[6]).html(data.ITV_SERV_DAY_NEW);
									$(ems[7]).html(data.ITV_SERV_CUR_MON_NEW);
									$(ems[8]).html(data.LA_TERMINAL_TOTAL);
									$(ems[9]).html(data.CUR_TERMINAL_TOTAL_MON);
									$(ems[10]).html(data.LA_COUNT_800M);
									$(ems[11]).html(data.CUR_COUNT_800M_MON);

									$("#grid_info_win").show();
								}
								//map.infoWindow.setContent(win_content);
							});
						}
					}

					graLayer_wg.on("mouse-over", function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						var graphics = evt.graphic;
						var attr = graphics.attributes;
						showGridInfoWin(graphics,attr);
					});
					graLayer_wg_text.on("mouse-over", function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						var attrs = evt.graphic.attributes;
						var graphics = attrs["grid_fill_gra"];
						var attr = attrs["grid_attr"];
						showGridInfoWin(graphics,attr);
					});
					graLayer_wg.on("mouse-out", function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						map.setMapCursor("default");
						gridFillRecover();
						$("#grid_info_win").hide();
					});
					graLayer_wg_text.on("mouse-out",function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						gridFillRecover();
						$("#grid_info_win").hide();
					});

					graLayer_wg.on("click",function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var attr = evt.graphic.attributes;
						gridToEnd(attr);
					});
					graLayer_wg_text.on("click",function(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var attr = evt.graphic.attributes.grid_attr;
						gridToEnd(attr);
					});
				}
		)
	}

	function getGridListTable(substation){
		$("#sub > tbody").empty();
		$.post(url4Query,{eaction:'getGridInfoBySubstation',yesterday:'${yesterday.VAL}',last_month:'${lastMonth.VAL}',substation:substation},function(data){
			data = $.parseJSON(data);
			var rows = data.rows;
			for(var i = 0,l = rows.length;i<l;i++){
				var d = rows[i];
				var tr_str = "<tr style='height: 20px;line-height: 20px;border-bottom: 1px solid #fff'><td align='center' style='width: 8%'>"+ d.ROWNUM+"</td><td align='left' style='width: 25%' title='"+d.GRID_NAME+"'>"+ (d.GRID_NAME.length>7?d.GRID_NAME.substr(0,7)+"..":d.GRID_NAME) +"</td><td align='center' style='width: 12%'>"+ d.FIN_INCOME+"</td><td align='center' style='width: 15%'>"+ d.MOBILE_MON_CUM_NEW+"</td><td align='center' style='width: 15%'>"+ d.BRD_MON_CUM_NEW+"</td><td align='center' style='width: 15%'>"+ d.ITV_MON_NEW_INSTALL_SERV+"</td></tr>";
				$("#sub > tbody").append(tr_str);
			}
		});
	}
	//右侧数据联动
	function freshTab(substation,clickFlag){

		if(clickFlag=="sub"){
			$(".grid_right_div").hide();
			$(".sub_right_div").show();

			flag = global_param_temp_for_subgridlist["current_flag"];
			//三包发展情况 ---begion
			$.post(url4Query,{eaction:'three_index',flag:flag,latn_id:city_id,last_month:'${lastMonth.VAL}',click_name:city_full_name,substation:substation},function(data){
				data = $.parseJSON(data);
				if(data==null){
					return;
				}
				//市场 ----begin
				var income_divs0 = $(".target_title").eq(0).next().children();
				$(income_divs0[0]).html(""+data.ZYL+"%");//
				var danwei = "户";
				if(flag==1 || flag==2 || flag==3)
					danwei = "万户";
				$(income_divs0[1]).html("住户数:"+data.ADDR_NUM+danwei);//
				$(income_divs0[2]).html("宽带数:"+data.KD_NUM+danwei);
				var b_class0 = "";
				/*var b_class1 = "b1";
				 if(data.INCOME_RATIO<0){
				 b_class1 = "b2";
				 }*/
				$(income_divs0[2]).children("b").attr("class",b_class0);
				//市场 ----end

				//收入 ----begin
				var income_divs1 = $(".target_title").eq(1).next().children();
				$(income_divs1[0]).html(""+data.INCOME_BUDGET_FINISH_RATE+"%");//收入完成进度
				var yuan = "";
				if(flag==1 || flag==2 || flag==3)
					yuan = "亿";
				else if(flag>3){
					yuan = "万";
				}
				$(income_divs1[1]).html("本年累计:"+data.Y_CUM_INCOME+yuan+"元");//本年累计收入
				$(income_divs1[2]).html("环比:"+data.INCOME_RATIO+"%");
				var b_class1 = "b1";
				if(data.INCOME_RATIO<0){
					b_class1 = "b2";
				}
				$(income_divs1[2]).children("b").attr("class",b_class1);
				//收入 ----end

				//利润 ----begin
				var income_divs2 = $(".target_title").eq(2).next().children();
				$(income_divs2[0]).html(""+data.OPERATE_PROFIT_MON_YEAR);//经营利润:
				$(income_divs2[1]).html("本月利润:"+data.OPERATE_PROFIT_MON+yuan+"元");//当月利润:
				$(income_divs2[2]).html("环比:"+data.JYLRHB+"%");
				var b_class2 = "b1";
				if(data.JYLRHB<0){
					b_class2 = "b2";
				}
				$(income_divs2[2]).children("b").attr("class",b_class2);
				//利润 ----end
			});
			//三包发展情况 ---end

			//日发展趋势 曲线图---begin
			//曲线图 移动 每日累计
			var current_month_data0 = new Array(31);//当月
			var last_month_data0 = new Array(31);//上月
			//曲线图 宽带 每日累计
			var current_month_data1 = new Array(31);//当月
			var last_month_data1 = new Array(31);//上月
			//曲线图 ITV 每日累计
			var current_month_data2 = new Array(31);//当月
			var last_month_data2 = new Array(31);//上月
			//曲线图 x轴 日期 31天
			var day_array = new Array();
			for(var i = 0,l = current_month_data0.length;i<l;i++){
				day_array.push(i+1);
			}
			//默认是展现的移动标签
			var div_index_type = 0;
			//曲线图数据请求
			//当月数据
			$.post(url4Query,{eaction:"index_month_diff",region_id:city_id,click_name:city_full_name,date_start:current_month_first,date_end:current_month_last,flag:flag,substation:substation},function(data){
				data = $.parseJSON(data);
				for(var i = 0,l = data.length;i<l;i++){
					var index = parseInt(data[i].STAT_DATE.substring(6));
					current_month_data0.splice(index-1,1,data[i].MOBILE_SERV_DAY_NEW);
					current_month_data1.splice(index-1,1,data[i].BRD_SERV_DAY_NEW);
					current_month_data2.splice(index-1,1,data[i].ITV_SERV_DAY_NEW);
				}
				//上月数据
				$.post(url4Query,{eaction:"index_month_diff",region_id:city_id,click_name:city_full_name,date_start:last_month_first,date_end:last_month_last,flag:flag,substation:substation},function(data){
					data = $.parseJSON(data);
					for(var i = 0,l = data.length;i<l;i++){
						var index = parseInt(data[i].STAT_DATE.substring(6));
						last_month_data0.splice(index-1,1,data[i].MOBILE_SERV_DAY_NEW);
						last_month_data1.splice(index-1,1,data[i].BRD_SERV_DAY_NEW);
						last_month_data2.splice(index-1,1,data[i].ITV_SERV_DAY_NEW);
					}
					//刷新echart的曲线图
					if(div_index_type==0)
						freshFigue(day_array,current_month_data0,last_month_data0);
					else if(div_index_type==1)
						freshFigue(day_array,current_month_data1,last_month_data1);
					else if(div_index_type==2)
						freshFigue(day_array,current_month_data2,last_month_data2);
				});
			});

			//三个标签切换日发展趋势的曲线图变化
			function changeStyle(){
				this.onclick=function(){
					var list=this.parentNode.childNodes;
					for(var i=0;i<list.length;i++){
						if(1==list[i].nodeType){
							list[i].className="btn_uc";
						}
					}
					this.className='btn_active';
					var index_type = $(this).attr("data");//移动0，宽带1，itv2
					div_index_type = index_type;

					var current_month_data = "";
					var last_month_data = "";
					if(index_type==0){
						current_month_data = current_month_data0;
						last_month_data = last_month_data0;
					}else if(index_type==1){
						current_month_data = current_month_data1;
						last_month_data = last_month_data1;
					}else if(index_type==2){
						current_month_data = current_month_data2;
						last_month_data = last_month_data2;
					}
					myChart.dispose();
					myChart = echarts.init(document.getElementById('day_fz1'));
					freshFigue(day_array,current_month_data,last_month_data);
				}
			}
			var tabs=document.getElementById('tab_btn').childNodes;
			//给三个标签按钮绑定事件
			for(var i=0;i<tabs.length;i++){
				if(1==tabs[i].nodeType){
					changeStyle.call(tabs[i]);
					if($(tabs[i]).attr("data")==0)
						tabs[i].className="btn_active";
				}
			}
			//日发展趋势 曲线图---end

			//用户发展 终端销售 ---begin
			var user_proc_div = $("#user_proc");
			var terminal_sale_div = $("#terminal_sale");

			$.post(url4Query,{eaction:"user_proc",date:'${yesterday.VAL}',flag:flag,region_id:city_id,click_name:city_full_name,substation:substation},function(data){
				if(data==null){
					return;
				}
				data = $.parseJSON(data);
				var yhfz_doms = $(user_proc_div).children();
				var zdxs_doms = $(terminal_sale_div).children();
				for(var i = 0,l = data.length;i<l;i++){
					var d = data[i];
					//移动
					if(flag==1 || flag==2){
						yhfz_doms.eq(0).find("font").html("(万户):"+d.MOBILE_MON_CUM_NEW);
					}else{
						yhfz_doms.eq(0).find("font").html("(户):"+d.MOBILE_MON_CUM_NEW);
					}
					//宽带
					if(flag==1 || flag==2){
						yhfz_doms.eq(1).find("font").html("(万户):"+d.BRD_MON_CUM_NEW);
					}else{
						yhfz_doms.eq(1).find("font").html("(户):"+d.BRD_MON_CUM_NEW);
					}
					//ITV
					if(flag==1 || flag==2){
						yhfz_doms.eq(2).find("font").html("(万户):"+d.ITV_SERV_CUR_MON_NEW);
					}else{
						yhfz_doms.eq(2).find("font").html("(户):"+d.ITV_SERV_CUR_MON_NEW);
					}

					zdxs_doms.eq(0).find("font").html(d.CUR_TERMINAL_TOTAL_MON);
					zdxs_doms.eq(1).find("font").html(d.CUR_ZNJ_COUNT_MON);
					zdxs_doms.eq(2).find("font").html(d.CUR_COUNT_800M_MON);
				}
			});
			//用户发展 终端销售 ---end

			//网格列表
			getGridListTable(substation);
		}else if(clickFlag=="grid"){
			$(".sub_right_div").hide();
			$(".grid_right_div").show();
		}

		//当前位置信息（甘肃省>兰州市)
		updatePositionForSubgridList(global_param_temp_for_subgridlist["current_flag"]);
	}

	function freshFigue(day_array,current_month_data,last_month_data){
		var option = {
			title: {
				text: ''
			},
			tooltip : {
				trigger: 'axis',
				formatter:function(params, ticket){
					var content = "";
					for(var i = 0,l = params.length;i<l;i++){
						content += params[i].seriesName+params[0].name+"号:"+(params[i].data==undefined?"- -":params[i].data);
						if(i < l-1){
							content += "<br/>";
						}
					}
					return content;
				},//'{a0}{b}日:{c0}<br/>{a1}{b}日:{c1}',
				position:"top"
			},
			legend: {
				data:['本月','上月'],
				orient: 'horizontal',
				left:'right',
				top:20,

				/*right:0,
				 top:0,
				 inactiveColor:'#999',*/
				textStyle:{
					color:'#eee'
				},
				show:true
			},
			color:['#2f4554','#61a0a8'],
			toolbox: {
				show:false
			},
			/*tooltip:{
			 position:"top"
			 },*/
			grid: {
				/*left: '3%',
				 right: '4%',
				 bottom: '3%',*/
				top: 40,
				left:0,
				right:0,
				bottom:18,
				//containLabel: true,
				align:"right"
			},
			xAxis : [
				{
					min:1,
					max:31,
					scale:0,
					splitNumber:1,
					minInterval:1,
					interval:1,
					type : 'category',

					show: false,

					boundaryGap : false,
					data : day_array
				}
			],
			yAxis : [
				{
					silent: true,
					splitLine: {
						show: false
					},
					type : 'value'
				}
			],
			series : [
				{
					name:'上月',
					type:'line',
					stack: '总量',
					smooth:true,
					itemStyle: {
						normal: {
							color: '#03d2e3',
							label: {
								show: false,
								textStyle: {
									fontWeight: '700',
									fontSize: '0'
								}
							},
							lineStyle: {
								color: '#03d2e3',
								width:1
							}
						}
					},
					label: {
						normal: {
							show: true,
							position: 'top'
						}
					},
					areaStyle: {
						normal: {
							color: '#03d2e3',
							opacity: 0.2
						}
					},
					data:last_month_data
				},
				{
					name:'本月',
					type:'line',
					stack: '总量',
					smooth:true,
					itemStyle: {
						normal: {
							color: '#feef02',
							label: {
								show: false,
								textStyle: {
									fontWeight: '700',
									fontSize: '0'
								}
							},
							lineStyle: {
								color: '#feef02',
								width:1
							}
						}
					},
					label: {
						normal: {
							show: true,
							position: 'top'
						}
					},
					areaStyle: {
						normal: {
							color: '#feef02',
							opacity: 0.2
						}
					},
					data:current_month_data
				}
			]
		};
		myChart.setOption(option);
	}

	//更新地图右上方路径和右侧联动的上方名称
	function updatePositionForSubgridList(flag){
		var click_path = $(".click_path");
		var position = global_param_temp_for_subgridlist["position"];
		var temp = "";
		$(".click_name").html(position[flag-1]);
		for(var i =0;i<flag;i++){
			var str = position[i];
			if(str == undefined)
				return;

			/*if(i==2)
			 temp += "<a href=\"javascript:void(0);\" onclick=\"javascript:backToQx();\" >"+global_position[i]+"</a>";*/
			temp += str;

			if(i!=flag-1)
				temp += ">";
		}
		click_path.html(""+temp);
	}

	function backToEchart(){
		$("#model_to_map").show();
		$("#model_to_rank").show();
		$("#tab_div").css({top:0,left:0});
		$("#map_div").css({top:0,left:-1*$("#map_div").width()});
		$("#nav_fanhui").hide();
	}
</script>