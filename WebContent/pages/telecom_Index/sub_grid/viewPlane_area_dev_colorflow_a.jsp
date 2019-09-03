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
<e:q4o var="username">
	select '${sessionScope.UserInfo.USER_NAME}' val from dual
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
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>区县地图</title>
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
	<link href='<e:url value="/resources/themes/common/css/reset.css?version=1.0"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js" />
	<c:resources type="easyui,app" style="b"/>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js?version=2.0"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/resources/scripts/admin.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/esri.symbol.MultiLineTextSymbol.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
	<%--<script src='<e:url value="/pages/telecom_Index/common/js/Marquee.js?version=1.2"/>' charset="utf-8"></script>--%>
	<script src='<e:url value="/pages/telecom_Index/common/js/left_menu_control.js?version=1.1"/>' charset="utf-8"></script>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css"/>' rel="stylesheet" type="text/css" media="all" />

</head>
<body class="body_padding" style="position:relative;background-color:transparent;width:100%;height:100%;">
<style>
	html, body, #map { height: 100%; margin: 0;padding: 0; }.myInfoWindow {position: absolute;z-index: 999;-moz-box-shadow: 0 0 1em #26393D;font-family: sans-serif; font-size: 12px; background-color: rgba(255, 255, 255, 0);}.dj_ie .myInfoWindow {border: 1px solid black;}.myInfoWindow .content {position: relative;background-color:#EFECCA;color:#002F2F;overflow: auto;padding:2px 2px 2px 2px; background-color: rgba(255, 255, 255, 0); }
	body .demo-class {background:#0d3d88; color:#fff; border: none;}
	body .demo-class {border-top:1px solid #E9E7E7}
	body .demo-class .layui-layer-btn a{background:#333;}
	body .demo-class .layui-layer-btn {background:#999;}
	body .demo-class .layui-layer-content {background:#040f54; color:#fff; border: none;}
	#leida_div {width:50px;height:50px;position:absolute;left:0px;top:0px;z-index:9999;display:none;border:1px solid #f00;}

	#updown {
		background-color: #f00;
		display: block;
		height: 24px;
		width: 40px;
		position: absolute;
		z-index: 9999;
		bottom: 20px;
		left: 5px;
	}

</style>


<div id="sub_info_win" style="display:none;background-color: #fff;position: absolute;bottom: 1;right: 0;z-index: 99999999999;width: 220px;height: 110px;border: 2px solid #2070dc;border-radius: 4px;">
	<div style="width:100%;text-align: left;height: 26px;line-height: 26px;font-size: 14px;background-color:#073b8a;color: #fcd001;padding-left: 10px ">支局信息</div>
	<span style="font-weight:bold;color: red;margin-left: 8px;margin-top: 2px;display: inline-block;font-size: 12px">支局名称：</span><em style="color: red;font-size: 12px"></em>
	<br>
	<!-- liangliyuan 2017年7月20日11:56:23 新增所属分局内容 ↓-->
	<!-- liangliyuan 2017年7月21日10:24:57 修改所属分局字体为黑色 -->
	<span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block;font-size: 12px">所属分局：</span><em style="font-size: 12px;"></em>
	<br>
	<!-- liangliyuan 2017年7月20日11:56:31 新增所属分局内容 ↑-->
	<span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block;font-size: 12px">网&nbsp;格&nbsp;数 ：</span><e style="font-size:12px ;">共</e><em style="font-size:12px ;"></em><e style="font-size:12px ;">个</e><e>,</e><em style="font-size:12px ;"></em><e style="font-size:12px ;">个未上图</e>
	<br>
	<%--<span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block">支局类型：</span><em></em>
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
	</table>--%>
</div>

<div id="grid_info_win" style="display:none;background-color: #fff;position: absolute;bottom: 0;right: 0;z-index: 99999999999;width: 260px;height: 200px;border: 2px solid #2070dc;border-radius: 4px;">
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
<div class="build_info_win" id="build_info_win" style="display: none">
	<div class="titlea"><div id="build_title"  class="build_title"></div><div  class="titlec" onclick="$('#build_info_win').hide()"></div></div>

	<div class="base" style="border-bottom: none">
		<h3 class="wrap_aa" style="display: inline-block">基础信息</h3>
		<div class="close"> <a id="build_close" class="closed" href="javascript:skip()"  style="cursor: pointer">详情</a></div>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px"></div>
		<div class="base1" style="margin-top: 5px"><span class="bb1" >所&nbsp&nbsp&nbsp属：<span id="bb1">-</span></span></div>
		<div class="base1"><span class="bb1">住户数：<span id="bb7"></span></span><span class="linec">人口数：<span id='bb3'></span></span><span class="linec">入住率：<span id='bb4'></span></span><span class="linec">楼高：<span id='bb8'></span></span></div>
	</div>
	<div class="re" style="border-bottom: none">
		<h3 class="wrap_aa" style="color: #109afb;">资源信息</h3>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px"></div>
		<div class="base1" style="margin-top: 5px"><span class="bb1">端口数：<span id='bb5'></span></span><span class="lineb">未占用：<span id="bb6"></span></span></div>
	</div>
	<div class="yin">
		<h3 class="wrap_aa" style="color:#109afb">营销信息</h3>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px"></div>
		<table class="table_y" style="margin-top: 10px">
			<tr>
				<th>业务</th>
				<th>可新开</th>
				<th>加装宽带</th>
				<th>加装ITV</th>
				<th>加装固话</th>
			</tr>
			<tr>
				<td>宽带</td>
				<td>23</td>
				<td>--</td>
				<td>23</td>
				<td>23</td>
			</tr>
			<tr>
				<td>ITV</td>
				<td>23</td>
				<td>23</td>
				<td>--</td>
				<td>23</td>
			</tr>
			<tr>
				<td>固话</td>
				<td>23</td>
				<td>23</td>
				<td>23</td>
				<td>--</td>
			</tr>
		</table>

	</div>

</div>
<!-- 楼宇详情弹窗 shenruijie -->
<div class="build_more_win"  id="detail_more" style="display:none;">
  <div class="titlea"><div id="build_more_title" style='text-align:center;width:90%;display: inline-block'></div><div  class="titlec" onclick="$('#detail_more').hide()"></div></div>

</div>
<!-- 楼宇详情弹窗 shenruijie end-->
<div class="village_info_win" id="village_info_win" style="display: none">
        <div class="target_dev" style="width: 100%">
            <div class="village_title"><span id="village_title">小区名称</span><div class="village_close" id="village_close"></div></div>
            <div class="devep">
                <div class="deve_ta">
                    <div class="tave">概<br/>况</div>
                    <div class="tava">
                        <div  class="tavae"  id="rzl">23%</div>
                        <div style="width: 100%;color: #aaa;font-size: 12px" id="spe">入住率</div>
                    </div>
                </div>
                <div class="deve_tb">

                    <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">楼宇：<span id="bn"></span></span><span style="position: absolute;left: 128px;">单元：<span id="dn"></span></span></div>
                    <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">人口：<span id="rn"></span></span><span style="position: absolute;left: 128px;">住户：<span id="zn"></span></span></div>

                </div>
            </div>
            <div class="devep" >
                <div class="deve_ta">
                    <div class="tave">资<br/>源</div>
                    <div class="tava">
                        <div class="tavae" id="hly">23%</div>
                        <div style="width: 100%;color: #aaa;font-size: 12px">H 利用率</div>
                    </div>
                </div>
                <div class="deve_tb">

                    <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">独家进线：<span id="dj"></span></span></div>
                    <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">光网覆盖：<span id="hf"></span></span><span style="position: absolute;left: 118px;">H端口：<span id="hp"></span></span></div>

                </div>
            </div>
            <div class="devep">
                <div class="deve_ta">
                    <div class="tave">业<br/>务</div>
                    <div class="tava">
                        <div class="tavae" id="b_n">45%</div>
                        <div style="width: 100%;color: #aaa;font-size: 12px">宽带用户</div>
                    </div>
                </div>
                <div class="deve_tb">

                    <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">H用户：<span id="h_n"></span></span></div>
                    <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">电视用户：<span id="i_n"></span></span><span style="position: absolute;left: 118px;"> 移动用户：<span id="m_n"></span></span></div>

                </div>
            </div>

        </div>
        <div class="target_b">
            <h3 class="wrap_a">市场竞争</h3>
            <div class="figure" id="Histogram"></div>
        </div>

    <div>
            <h3 class="wrap_a">竞争详情</h3>
            <table  class="content_table" style="width:96%;margin: 10px auto;">
                <tr>
                    <th>运营商</th>
                    <th>移动</th>
                    <th>宽带</th>
                    <th>电视</th>
                </tr>
                <tr>
                    <td>电信</td>
                    <td id="dy"></td>
                    <td id="db"></td>
                    <td id="di"></td>
                </tr>
                <tr>
                    <td>联通</td>
                    <td id="ly"></td>
                    <td id="lb"></td>
                    <td id="li"></td>
                </tr>
                <tr>
                    <td>移动</td>
                    <td id="my"></td>
                    <td id="mb"></td>
                    <td id="mi"></td>
                </tr>

            </table>
        </div>

</div>
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
<div id="yingxiao_info_win_new" class="yingxiao_info_win" style="display: none;" >
	<div class="village_title"><span id="yingxiao_title">营销查看</span><div class="village_close" id="yingxiao_new_close"></div></div>
	<div class="target_a" style="height: 20%">
		<h3 class="wrap_aa">基本信息</h3>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px"></div>
		<div class="base2"><span class="linea">营销名称：<span id="yx_name"></span></span></div>
		<div class="base2" style="margin-top:-5px" ><span class="linea">创&nbsp建&nbsp人&nbsp：<span id="yx_creatp"></span></span><span class="linec" style="margin-left:25px">创建时间：<span id="yx_creatt"></span></span></div>
	</div>
	<div class="target_a" style="height: 16%;">
		<h3 class="wrap_aa" style="color: #109afb;">营销对象</h3>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px"></div>
		<div class="base2"><span class="linea">楼宇数：<span id="countlou_new"></span></span><span class="lineb">住户数：<span id="countzhu_new"></span></span><span class="lineb">人口数：<span id="countren_new"></span></span><span class="lineb">营销目标：<span id="countying_new"></span></span></div>
	</div>
	<div>
		<h3 class="wrap_aa" style="color: #109afb;    padding-left: 5px;">营销明细</h3>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px;padding-left: 5px;"></div>
		<div style="padding-right: 14px;margin-top:10px">
			<table class="yingxiao_win_table" >
				<tr>
					<th rowspan="2" width="8%">序号</th>
					<th rowspan="2" width="38%">四级地址</th>
					<th rowspan="2" width="10%">住户</th>
					<th rowspan="2" width="10%">人口</th>
					<th colspan="3">营销目标</th>
				</tr>
				<tr>
					<th width="10%">宽带</th>
					<th width="10%">电视</th>
					<th width="10%">固话</th>
				</tr>
			</table>
		</div>
		<div style="height: 120px;overflow-y: scroll;margin-top: -1px">
			<table class="yingxiao_win_table_b" id="yingxiao_table_c">
				<%--<tr>
                    <td width="8%">1</td>
                    <td width="38%">定西市安定区凤羽街街道</td>
                    <td width="10%">2</td>
                    <td width="10%">2</td>
                    <td class="yingxiao_td" width="10%">2</td>
                    <td class="yingxiao_td" width="10%">2</td>
                    <td class="yingxiao_td" width="10%">2</td>
                </tr>--%>
			</table>
		</div>
	</div>

</div>
<div id="yingxiao_info_win" class="yingxiao_info_win"  style="display: none">
	<div class="village_title"><span>营销新建</span><div class="village_close" id="yingxiao_close"></div></div>
	<div class="target_a" style="height: 17%">
		<h3 class="wrap_aa" style="display: inline-block">营销对象</h3>
		<div style="float: right;margin-right: 10px;cursor: pointer;text-decoration: underline;color: #0087d4;font-size: 14px;margin-top: 8px" id="yingxiao_baocun">保存</div>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px"></div>
		<div class="base2"><span class="linea">楼宇数：<span id="countlou"></span></span><span class="lineb">住户数：<span id="countzhu"></span></span><span class="lineb">人口数：<span id="countren"></span></span><span class="lineb">营销目标：<span id="countying"></span></span></div>
	</div>
	<div style="padding:0 5px">
		<h3 class="wrap_aa" style="color: #109afb">营销明细</h3>
		<div style="width: 94%;height: 2px;background-color: #109afb;margin-left: 10px"></div>
		<div style="padding-right: 14px;margin-top: 10px">
			<table class="yingxiao_win_table" >
				<tr>
					<th rowspan="2" width="8%">序号</th>
					<th rowspan="2" width="38%">四级地址</th>
					<th rowspan="2" width="10%">住户</th>
					<th rowspan="2" width="10%">人口</th>
					<th colspan="3">营销目标</th>
				</tr>
				<tr>
					<th width="10%">宽带</th>
					<th width="10%">电视</th>
					<th width="10%">固话</th>
				</tr>
			</table>
		</div>
		<div style="height: 200px;overflow-y: scroll;margin-top: -1px;">
			<table class="yingxiao_win_table_b" id="yingxiao_win_table_b">
				<%--<tr>
                    <td width="8%">1</td>
                    <td width="38%">定西市安定区凤羽街街道</td>
                    <td width="10%">2</td>
                    <td width="10%">2</td>
                    <td class="yingxiao_td" width="10%">2</td>
                    <td class="yingxiao_td" width="10%">2</td>
                    <td class="yingxiao_td" width="10%">2</td>
                </tr>--%>
			</table>
		</div>
	</div>

</div>
<div id="leida_div"></div>
<%--列表--%>
<div id="list_div" style="display: none;height: 100%">
	<div style="overflow: hidden;">
		<div style="margin-top: 5px">
			<div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
			<div class="list_search" >
				<div style="margin-top:5px">
					<div style="margin-left: 5px;display: inline-block;line-height: 26px;font-size:12px">分公司:</div>
					<select id="br_city"  class="list_select" style="width: 66px;margin-left: 6px"><option value="">全部</option></select>
					<div style="margin-left: 10px;display: inline-block;font-size:12px">区&nbsp&nbsp县:</div>
					<select id="br_area" class="list_select" style="width: 93px;;margin-left: 5px"><option value="" >全部</option></select>
				</div>
				<div style="margin-bottom: 2px;margin-top:5px">
					<div style="margin-left: 7px;display: inline-block;font-size:12px">支&nbsp&nbsp局:</div>
					<input type="text" id="b_branch_name" placeholder="输入网格名称" style="width: 140px;margin: 5px;margin-left:8px;height:26px!important;margin-top: 2px;font-size:12px">
					<button id="branch_query" class="btn_uc" style="font-size:12px">查&nbsp&nbsp询</button>
			</div>

		</div>
			<div>
				<div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
				<div class="list_search" style="padding: 5px;">
					<span  style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px" id="tacount1"></span><span  style="font-size:12px">个支局，未上图</span><span style="color:red;font-size:12px" id="tacount2"></span><span  style="font-size:12px">个</span>
				</div>
			</div>
		</div>
	</div>

		<div style="color: #fff; background-color: #8ed2ff; position:fixed;top:214px;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold">
			<div style='text-align: center;width: 12%;display: inline-block'>序号</div>
			<div style='text-align: center;width: 16%;display: inline-block'>本地网</div>
			<div style='text-align: center;width: 43%;display: inline-block;margin-left: 3px'>支局名称</div>
			<div style='text-align: center;width: 20%;display: inline-block'>类型</div>
		</div>
	<div id="ta" class="ta">
		<table class="list_table" style="/*display: block;*/margin-bottom:20px;height: 100%;width:100%;">
		</table>
	</div>
	<%--<div class="tb" id="tb_1"></div>--%>
</div>
<div id="grid_div" style="display: none;height: 100%">
	<div style="overflow: hidden">
		<div style="margin-top: 5px">
			<div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
			<div class="list_search">
				<div style="margin-left: 5px;margin-top:5px">
					<div class="list_text">分公司:</div><select id="g_city"  class="list_select" style="width: 70px;margin-left:5px"><option value="">全部</option></select>
					<div  class="list_text" style="margin-left:10px">区&nbsp&nbsp县:</div><select id="g_area" class="list_select" style="width: 86px;;margin-left: 5px"><option value="" >全部</option></select>
				</div>
				<div style="margin-left: 5px;margin-top:5px">
					<div class="list_text">支&nbsp&nbsp局:</div><select id="g_branch"  class="list_select" style="width: 210px;margin-left: 10px;"><option value="">全部</option></select>
				</div>
				<div style="margin-left: 5px">
					<div class="list_text">网&nbsp&nbsp格:</div><input type="text" id="g_grid_name" placeholder="输入网格名称" style="width: 130px;margin: 5px;margin-left: 10px;font-size: 12px;">
				<button id="grid_query" class="btn_uc" style="font-size:12px">查&nbsp&nbsp询</button>
				</div>
			</div>
		</div>
		<div>
			<div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
			<div class="list_search" style="padding: 5px;">
				<span  style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px" id="gridcount1"></span><span  style="font-size:12px">个支局，未上图</span><span style="color:red;font-size:12px" id="gridcount2"></span><span  style="font-size:12px">个</span>
			</div>
		</div>
	</div>
	<div style="color: #fff; background-color: #8ed2ff; position:fixed;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold">
		<div style='text-align: center;width: 10%;display: inline-block'>序号</div>
		<div style='text-align: center;width: 32%;display: inline-block'>支局名称</div>
		<div style='text-align: center;width:50%;display: inline-block'>网格名称</div>
	</div>
	<div class="tc">
		<table class="grid_table" style="/*display: block;*/margin-bottom:20px;margin-top:0px;height: 88%;width:100%;">
		</table>
	</div>
	<%--<div id="grid_show"></div>--%>
</div>
<div id="village_div" style="display: none;height: 100%">
	<div style="overflow: hidden">
		<div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
		<div class="list_search" >
			<div style="margin-left: 5px;margin-top: 5px">
				<div class="list_text">分公司:</div><select id="v_city" class="list_select" style="width: 70px;margin-left:8px"><option value="" >全部</option></select>
				<div class="list_text" style="margin-left:10px">区&nbsp&nbsp县:</div><select id="v_area" class="list_select" style="width: 85px;margin-left:5px"><option  value="">全部</option></select>
			</div>
			<div style="margin-left: 5px;margin-top:5px">
				<div class="list_text">支&nbsp&nbsp局:</div><select id="v_branch" class="list_select" style="  width: 210px;margin-left: 13px"><option value="">全部</option></select>
			</div>
			<div style="margin-left: 5px;margin-top: 5px">
				<div class="list_text">网&nbsp&nbsp格:</div><select id="v_grid"  class="list_select" style="width: 210px;margin-left: 13px"><option value="">全部</option></select>
			</div>
			<div style="margin-left: 5px;margin-bottom: 5px">
				<div class="list_text">小&nbsp&nbsp区:</div><input type="text" id="v_village_name" placeholder="输入小区名称" style="width: 135px;margin-left: 13px;margin-top: 5px;font-size:12px">
				<button id="village_query" class="btn_uc" style="margin-top: 5px;font-size: 12px">查&nbsp&nbsp询</button>
			</div>
		</div>
		<div>
			<div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
			<div class="list_search" style="padding: 5px;">
				<span  style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px" id="villagecount1"></span><span  style="font-size:12px">个支局，未上图</span><span style="color:red;font-size:12px" id="villagecount2"></span><span  style="font-size:12px">个</span>
			</div>
		</div>
	</div>
	<div>
		<div style="color: #fff; background-color: #8ed2ff; position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold;    margin-top: -1px;">
			<div style='text-align: center;width: 14%;display: inline-block'>序号</div>
			<div style='text-align: center;width: 34%;display: inline-block'>网格名称</div>
			<div style='text-align: center;width: 34%;display: inline-block'>小区名称</div>
		</div>
	</div>
	<div  class="td">
		<table class="village_table" style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
		</table>
	</div>
	<%--<div id="village_show" class="tb"></div>--%>
</div>
<div id="build_div" style="display: none;height: 100%">
	<div style="overflow: hidden">
		<div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
		<div class="list_search">
			<div style="margin-left:5px;margin-top: 5px">
				<div class="list_text">分公司：</div><select id="b_city" class="list_select" style="width: 60px;margin-left:5px"><option value="" >全部</option></select>
				<div class="list_text" style="margin-left: 10px">区&nbsp&nbsp县：</div><select id="b_area" class="list_select" style="width: 84px;;margin-left:3px"><option value="" >全部</option></select>
			</div>
			<div style="margin-left:5px;margin-bottom:5px">
				<div class="list_text">地&nbsp&nbsp&nbsp址：</div><input type="text" id="b_build_name" placeholder="输入楼宇名称" style="width: 126px;margin-left: 5px;margin-top: 5px;font-size:12px">
				<button id="build_query" class="btn_uc" style=";margin-left: 6px;margin-top: 5px">查&nbsp;&nbsp;询</button>
			</div>
		</div>
	</div>
	<div>
		<div style="color: #fff; background-color: #8ed2ff; position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold;">
			<div style='text-align: center;width: 14%;display: inline-block'>序号</div>
			<div style='    text-align: center;width: 70%;display: inline-block'>楼宇名称</div>
		</div>
	</div>
	<div  class="te">
		<table id="build_table" class="build_table" style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
		</table>
	</div>
</div>
<div id="yingxiao_div" style="display: none;height: 100%">
	<div style="overflow:hidden;">
		<div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
		<div class="list_search"style="padding-bottom: 5px;margin-bottom: 0px" >
			<div style="margin-left: 5px;margin-top: 5px;">
				<div class="list_text">分公司：</div><select id="y_city"  class="list_select" style="width: 60px;margin-left:5px"><option value="" >全部</option></select>
				<div class="list_text" style="margin-left: 10px">区&nbsp&nbsp县：</div><select id="y_area"  class="list_select" style="width: 75px;;margin-left:5px"><option value="" >全部</option></select>
			</div>
			<div style="margin-left: 5px">
				<div class="list_text">名&nbsp&nbsp&nbsp称：</div><input type="text" id="chaxun" placeholder="输入营销名称" style="width: 200px;margin-left: 5px;margin-top: 5px">
			</div>
			<div style="margin-left: 5px">
				<button id="cc" class="btn_uc" style="margin-left:60px;margin-right: 20px;margin-top: 5px;">查&nbsp;&nbsp;询</button>
				<button id="xinjian" class="btn_xj" style="margin-top: 5px;">新&nbsp;&nbsp;建</button>

			</div>
		</div>
	</div>
	<div>
		<div style="color: #fff; background-color: #8ed2ff; position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:13px;font-weight: bold;    margin-top: 5px;">
			<div style='text-align: center;width: 14%;display: inline-block'>序号</div>
			<div style='text-align: center;width: 55%;display: inline-block'>营销名称</div>
			<%--<div style='text-align: center;width: 24%;display: inline-block'>创建人</div>--%>
			<div style='text-align: center;display: inline-block'>创建时间</div>

		</div>
	</div>
	<div  class="tf">
		<table id="yingxiao_table" style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
		</table>
	</div>
</div>
<div id="show_grid_menu">显示网格</div>

<div style="clear:both ">
	<!--绘制结果上右键弹出的快捷菜单-->
	<%--<div id="delete_village" style="padding: 10px;background-color: rgba(0,0,0,0.8);color: #fff;margin-top: 10px">移除位置</div>
	<div id="clear_draw_menu" style="padding: 10px 10px 0px 10px;background-color: rgba(0,0,0,0.8);color: #fff;">退出绘制</div>
	<div id="pop_res_win_layer" style="padding: 10px;background-color: rgba(0,0,0,0.8);color: #fff;margin-top: 10px">结果窗口</div>--%>

	<!--圈定范围后的结果窗口-->
	<div id="draw_result_container">
		<div id="draw_result" style="z-index:99999">
			<table style="color: #fff;text-align: center;width: 100%;margin-top: 34px;">
			</table>
		</div>
		<div id="draw_result_total"></div>
	</div>

	<div id="gismap" name="gismap" style="text-align: left;background-image: url('bgg.jpg');background-repeat: no-repeat;background-size:100% 100%;-moz-background-size:100% 100%;z-index:5;"></div>
	<a href="javascript:backToEchart()" id="nav_fanhui" class="add_backcolor"></a>
	<a href="javascript:backToCity()" id="nav_fanhui_city" class="add_backcolor"></a>
	<a href="javascript:backToQx()" id="nav_fanhui_qx" class="add_backcolor"></a>
	<a href="javascript:backToSub()" id="nav_fanhui_sub" class="add_backcolor"></a>
	<div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;">
		<a href="javascript:void(0)" id="show">显示</a>
		<a href="javascript:void(0)" id="hide">隐藏</a>
		<ul id="tools">
			<li id="nav_zoomin"><span></span><a href="javascript:void(0)" id="zoomin">放大</a></li>
			<li id="nav_zoomout"><span></span><a href="javascript:void(0)" id="zoomout">缩小</a></li>
			<!--
            <li><span></span><a href="javascript:void(0)">热力</a></li>
            <li><span></span><a href="javascript:void(0)">列表</a></li>
            <li><span></span><a href="javascript:void(0)">网络</a></li>
            <li><span></span><a href="javascript:void(0)">趋势</a></li>-->
			<li id="nav_hidetiled" class="active"><span></span><a href="javascript:void(0)" id="hidetiled">地图</a></li>
			<li id="nav_hidepoint"><span></span><a href="javascript:void(0)" id="hidepoint">网点</a></li>
			<%--<li id="nav_query"><span></span><a href="javascript:void(0)" id="query">查找</a></li>--%>
			<li id="nav_list" style="cursor: hand"><span></span><a href="javascript:void(0)" id="list">支局</a></li>
			<li id="nav_grid" style="cursor: hand"><span></span><a href="javascript:void(0)" id="grid">网格</a></li>
			<li id="nav_village" style="cursor: hand;"><span></span><a href="javascript:void(0)" id="village">小区</a></li>
			<li id="nav_standard" style="cursor: hand"><span></span><a href="javascript:void(0)" id="standard">楼宇</a></li>
			<li id="nav_marketing" style="cursor: hand"><span></span><a href="javascript:void(0)" id="marketing">营销</a></li>
			<!-- <li id="nav_earse"><span></span><a href="javascript:void(0)" id="earseTool">擦除</a></li>-->
			<!--<li id="nav_chart" style="cursor: hand"><span></span><a href="javascript:void(0)" id="hidechart">市场</a></li>-->
			<!--<li id="nav_heatmap" style="cursor: hand"><span></span><a href="javascript:void(0)" id="heatmap">热力图</a></li>-->
			<!--<li id="nav_tianyi"><span></span><a href="javascript:void(0)">天翼</a></li>
            <li id="nav_kuandai"><span></span><a href="javascript:void(0)">宽带</a></li>
            <li id="nav_itv"><span></span><a href="javascript:void(0)">ITV</a></li>
            <li id="nav_reli"><span></span><a href="javascript:void(0)">热力</a></li>
            <li id="nav_guanbi"><span></span><a href="javascript:void(0)">关闭</a></li>-->
			<!--  li id="nav_fanhui"><span></span><a href="javascript:backToEchart()" id="backtop">返回</a></li-->
			<!--  li id="nav_fanhui_qx" style="display:none;"><span></span><a href="javascript:backToQx()" id="backtop_qx">返回</a></li-->
		</ul>
	</div>
	<%--<div id="updown">
		<a href="javascript:void(0);" id="goU">上</a> <a href="javascript:void(0);" id="goD">下</a>
	</div>--%>
</div>
<%--营销保存弹框--%>
<div id="nameinput" style="display:none;background-color: #fff;position: absolute;bottom: 140px;right:100px;z-index: 99999999999;width: 280px;height: 180px;border: 2px solid #2070dc;border-radius: 4px;font-size:14px">
	<div style="width:100%;text-align: left;height: 26px;line-height: 26px;font-size: 14px;background-color:#073b8a;color: #fcd001;padding-left: 10px ">营销名称</div>
	<div style="display: inline-block;margin-left: 10px;margin-top:10px">营销名称:<input type="text" id="yxname" placeholder="请输入营销名称" style="margin-top:0px;margin-left: 10px"><div style="    color: red;font-size: 12px;text-align: center;margin-top: 2px" id="yxspan"></div></div>
	<div><div style="margin-left: 10px;margin-top:10px;display: inline-block;">操&nbsp作&nbsp人:</div><div style="margin-left: 13px;display: inline-block">${username.val}</div></div>
	<button id="OK" style="width: 70px;height: 30px;background-color: #eee;border: 1px solid #ddd;margin-left: 60px;cursor:pointer;margin-top:15px">保存</button><button style="width: 70px;height: 30px;background-color: #eee;border: 1px solid #ddd;margin-left: 20px;cursor:pointer;margin-top:15px" onclick='javascript:$("#nameinput").hide()'>取消</button>
</div>



<div id="query_div">
	<select id="location_type">
		<option value="1">支局</option>
		<!--<option value="0">网格</option>-->
	</select>
	<input type="text" id="location_name" />
	<input class="button" id="location_find" value="搜索" />
</div>
<!--绘制工具箱-->

<div id="marketing_div" class="tools">
	<div style="width:50px;display: inline-block;line-height: 50px;color:#ffd200;font-size: 14px;margin-left: 10px;border-right: 1px dotted #fff;    float: left;">工具栏</div>
	<ul class="tools_content">
		<li id="draw_range_start">
			<div class="dianxuan"></div>
			<div class="shuoming">点选框</div>
		</li>
		<li id="draw_rectangle">
			<div class="kuangxuan"></div>
			<div class="shuoming">框选</div>
		</li>
		<li id="draw_set">
			<div class="shezhi"></div>
			<div class="shuoming">设置</div>
		</li>
		<li id="clear_draw">
			<div class="chexiao"></div>
			<div class="shuoming">撤销</div>
		</li>
		<li id="exit_draw" onclick="tuichu(event)">
			<div class="tuichu"></div>
			<div class="shuoming">退出</div>
		</li>
	</ul>
	<%--<div id="draw_range_start" class="draw_range_start" style="float: left;margin-top: 7px;margin-left: 10px;"  title="圆形框选"></div><span id="range_corner"></span><input type="text" class="dist" value="0.1" style="float: left;margin-top:2px"/><font style="font-size: 12px;height: 18px;float: left;margin-left: 5px;margin-top:7px;border-right: 1px solid #abbac3;padding-right: 5px;">公里</font>
	<div id="draw_rectangle" class="draw_rectangle" title="矩形框选" style="float: left;margin-left: 5px;border-right: 1px solid #abbac3;padding-right: 5px;margin-top: 7px;"></div>
	<div id="clear_draw" title="清除绘制" style="float: left;border-right: 1px solid #abbac3;padding-right: 5px;margin-top: 7px;"></div>
	&lt;%&ndash;<div id="hand_draw" title="拖拽" style="float: left;border-right: 1px solid #abbac3;padding-right: 5px;margin-top: 7px;"></div>&ndash;%&gt;
	<div id="exit_draw" title="退出" onclick="javascript:tuichu(event)" style="float: left;margin-top: 7px;"></div>--%>
	<%--<a href="javascript:void(0)" id="nav_range">辐射范围</a><a href="javascript:void(0)" id="nav_draw">划定区域</a>
	<div id="range_div"><span id="range_corner"></span><input type="text" class="dist" value="0.1"/>公里范围内<button id="draw_range_start"/>确定</div>
	<div id="draw_div">
		<button id="draw_ellipse" data-dojo-type="dijit/form/Button" title="椭圆形框选"></button>
		<button id="draw_circle" data-dojo-type="dijit/form/Button" title="正圆形框选"></button>
		<button id="draw_rectangle" data-dojo-type="dijit/form/Button" title="矩形框选"/></button>
		<button id="draw_polygon" data-dojo-type="dijit/form/Button" title="多边形框选"/></button>
		<button id="draw_freehand_polygon" data-dojo-type="dijit/form/Button" title="自由框选"/></button>
	</div>--%>
</div>
<%--设置框--%>
<div class="shezhi_content" id="shezhi_content" style="display: none">
	<div class="shezhi_text">点选半径:</div><input type="text" value="100" id="draw_half" style="width: 100px;color:#487ccb;margin-bottom: 2px"/><span style="font-size: 12px;color:#487ccb">米</span><button class="shezhi_button" onclick="$('#draw_range_start').click();$('#draw_set').click()">确定</button>
</div>

<!--小区上图工具箱-->
<div id="village_draw_tool_div" style="width: 32px;height: 32px">
	<div id="exit_draw1" title="退出" onclick="javascript:tuichu(event)" style="float: left;margin-top: 7px;"></div>
</div>

</body>
</html>
<script type="text/javascript">
	//parent.toggleModelButton();//隐藏左上角的地图排名按钮
    var flag_set=false;
	//区县线条配色
/*	var qx_all_line_color = [32,112,220,1];//所有区县的轮廓线颜色
	var qx_selected_line_color = [255,89,35,1];//选中的区县的描边颜色*/
    var qx_all_line_color = [44,169,253,1];//所有区县的轮廓线颜色
    var qx_selected_line_color = [44,169,253,1];//选中的区县的描边颜色

	//区县线条宽度
	var qx_all_line_width = 3;//所有区县的轮廓线宽度
	var qx_selected_line_width = 3;//选中的区县的描边宽度

	//选中的支局
	var sub_selected_line_color = [255,146,20,1];//选中的支局的轮廓线颜色
	var sub_selected_line_width = 3;//选中的支局的描边宽度
	var sub_selected_fill_color = [0,255,6];//选中的支局的填充色

	//选中的网格
	var grid_selected_line_color = [255,146,20,1];//选中的网格的轮廓线颜色
	var grid_selected_line_width = 4;//选中的网格的描边宽度
	var grid_selected_fill_color = [0,255,6];//选中的网格的填充色

	//悬浮的支局
	var highlight_sub_mouse_over_color = [255,210,0];//高亮填充色
	var highlight_sub_mouse_over_line_width = 2;

	//悬浮的网格
	var highlight_grid_mouse_over_color = [255,210,0];//高亮填充色
	var highlight_grid_mouse_over_line_width = 2;

	//支局下钻后，包含网格时，支局的轮廓线
	/*var sub_has_grid_self_line_color = [50,50,128,1];//支局的轮廓线线条颜色
	var sub_has_grid_self_line_width = 2;//支局的轮廓线线条宽度*/
    var sub_has_grid_self_line_color = [44,169,253,1];//支局的轮廓线线条颜色
//    var sub_has_grid_self_line_color = [44,169,253,1];//支局的轮廓线线条颜色
    var sub_has_grid_self_line_width = 4;//支局的轮廓线线条宽度

	//支局下钻后，包含网格时，网格的填充色
	var fill_color_array = [
		/*[139,179,240,0.4],
		 [109,169,246,0.4],
		 [71,138,240,0.4],
		 [82,150,236,0.4],
		 [59,139,220,0.4],
		 [62,127,213,0.4],
		 [66,153,232,0.4]*/
		[0,198,255,0.4],
		[240,156,160,0.4],
		[72,241,231,0.4],
		[35,255,166,0.4],
		[54,193,0,0.4],
		[239,159,194,0.4],
		[0,217,86,0.4],
		[33,168,230,0.4],
		[143,251,16,0.4]
	];//网格的轮廓线配色
	var grid_line_color = [141,141,139,1];
	//var grid_line_color = [44,169,253,1];
	//var grid_line_color = [224,224,224,1];//浅灰色
	var grid_line_width = 2;//网格的轮廓线宽度

	var sub_none_grid_text_color = [36,49,222];//显示“未划配网格”提示字的颜色

	var qx_text_color = [140,19,13];//区县名称

	var sub_name_text_color = [105,108,116];//支局名文字颜色
	var grid_name_text_color = [31,34,34];//网格名文字颜色

	var grid_name_text_selected_color = [128,81,34];//网格名文字颜色，网格选中时

	//绘制工具绘制图案的配色
	var draw_line_color = [234,0,61];//绘制工具 划线 线条配色 rgb
	var draw_line_width = 2;//绘制工具 划线 线条粗细 越大越粗
	var draw_fill_color = [10,10,10,0.3];//绘制工具 封闭多边形填充色 rgba

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

	var user_level = '${sessionScope.UserInfo.LEVEL}';//用户的划小层级

	/*parent.global_parent_area_name = parent.global_position[1];
	var city_full_name = parent.global_parent_area_name;//兰州市
	var area_full_name = parent.global_current_full_area_name;//城关区
	var area_name = parent.global_current_area_name;*///城关区

	var city_full_name = global_position[1];//兰州市
	var area_full_name = parent.global_current_full_area_name;//城关区
	var area_name = parent.global_current_area_name;//城关区
	var global_position = parent.global_position;

	var backToCity = parent.backToCity;
	var backToQx = parent.backToQx;
	var backToSub = parent.backToSub;

	var city_name = "";//城市短名称，去市、州
	if(city_name_speical.indexOf(city_full_name)>-1)
		city_name = city_full_name.replace(/州/gi,'');
	else
		city_name = city_full_name.replace(/市/gi,'');

	var city_id = city_ids[city_name];
	var map_id = map_id_in_gis[city_id];
	var index_type = parent.global_current_index_type;
	var flag = parent.global_current_flag;

	if(zxs[city_full_name]!=undefined)//嘉峪关特殊处理
		parent.updatePosition(flag);
	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';

	var colorflow = [[68,169,254],[1,1,89]];
	var colorflow_grid = [[68,169,254],[1,1,89]];//[[109,252,146],[39,255,80]];

	var map = "";

	var indexContainer_url_bearue = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev.jsp" />';
	var indexContainer_url_sub = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_sub_new.jsp" />';
	var indexContainer_url_grid = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_grid_new.jsp" />';
	var indexContainer_url_village = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_village_new.jsp" />';
	/*var fill_color_array1 = [
		//紫色
		[63,78,222,1],
		[133,141,210,1],
		[97,111,234,1],

		//红色：,
		[249,75,78,1],
		[223,95,98,1],
		[232,138,139,1],
		[204,146,145,1],
		[234,91,90,1],
		[237,193,193,1],

		//橙色：
		[255,136,0,1],
		[242,148,39,1],
		[218,161,93,1],
		[255,201,0,1],
		[255,217,75,1],
		[246,218,115,1],
		[251,233,165,1],

		//蓝色：
		[0,198,255,1],
		[22,180,225,1],
		[84,209,245,1],
		[0,174,255,1],
		[53,189,253,1],
		[121,195,229,1],
		[96,164,241,1]
	];*/

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
			"陇西北城支局":1,
			"陇西东城支局":1
		}
	};

	var sub_selected_ext = "";

	var clickToSub = "";
	var operateVillage="";
    var skip='';
	//选择框联动 小区
	var setCitys;
	var setBranchs='';
	var setGrids='';
	//选择框联动 楼宇
	var setBuildCity='';
	var setBuildArea='';
	var setBuildStreet='';
	//选择框联动 网格;
	var setGArea='';
	var setGBranch='';
	//营销
	var type_xy = '';
	var x = '';
    var y = '';
    var radius = '';
    var xmax = '';
    var xmin = '';
    var ymax = '';
    var ymin = '';


	var standard_position_load='';
	var showBuildDetail='';
	var tuichu ='';
    var segmid = "";
    var village_id=parent.global_village_id;
    var myChart= echarts.init(document.getElementById('Histogram'));
	var option = {
            title: {
                text: ''
            },
            tooltip : {
                trigger: 'axis',
                formatter:'{b}<br/>{a}:&nbsp;&nbsp;{c}%',
                position:"top",
                show:false,
            },
            legend: {
                show:false
            },
            toolbox: {
                show:false
            },
            grid: {
                top: '20%',
//              left:40,
//				x:20,
				y:20,
                right:50,
                bottom:20,
//                containLabel: true,
                align:"right"
            },
            xAxis : [
                {
                    min:1,
                    max:10,
                    scale:0,
                    splitNumber:1,
                    minInterval:1,
//                    interval:1,
                    type : 'category',
					axisLine:{
                        lineStyle:{
                            color:'#ccc'
						}
					},
                    axisLabel: {
                        show: true,
                        textStyle: {
                            fontSize: 10,
                            color:'#777',
                        }
                    },
                    show: true,

                    boundaryGap : false,
                    data :['移动渗透率','宽带入户率','电视入户率','光网入户率']
                }
            ],
            yAxis : [
                {
                    silent: true,
                    show: false,
                    splitLine: {
                        show: false
                    },
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'上月',
                    type:'bar',
                    stack: '总量',
                    smooth:true,
                    barMinHeight:10,
                    itemStyle: {
                        normal: {
                            color: function(params) {
                                //首先定义一个数组
                                var colorList = [
                                    '#1dbbb5','#fa8513','#b5ef8e','#109afb'
                                ];
                                return colorList[params.dataIndex]
                            },
                            //以下为是否显示
                            label: {

                                show: true,
                                formatter:'{c}%',
                                textStyle: {
                                    fontWeight: 'normal',
                                    fontSize: 10,
                                    color:'#f00',
                                    position: 'insideTop',
                                }
                            },
                            lineStyle: {
                                color: '#03d2e3',
                                width:1
                            }
                        }
                    },
                    barWidth:30,
//					barGap:'20%',
                    /*label: {
                        normal: {
                            show: true,
                            position: 'insideTop',
                            fontWeight: 'normal',
                            fontSize: 10,
                            color:'#777',
                        },
                    },*/
                    data:[12,13,14,15]
                }
            ]
        };
        myChart.setOption(option);

	/*yinming 2017年7月22日15:36:13 新增uuid*/
    function uuid() {
        var s = [];
        var hexDigits = "0123456789abcdef";
        for (var i = 0; i < 36; i++) {
            s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
        }
        s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
        s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
        s[8] = s[13] = s[18] = s[23] = "-";

        var uuid = s.join("");
        return uuid;
    }
	/*yinming 2017年7月22日15:36:13 新增uuid end*/

	$(function(){
		toGis();//城关区，兰州市
        //小区基础数据展示
        $("#village_close").on('click',function () {
            $("#village_info_win").hide()
        })
        $('#village_info_win').draggable();
        $('#build_info_win').draggable();
        $('.build_more_win').draggable();
        $('.yingxiao_info_win').draggable();
        //$('#draw_tools').draggable();
		$('#draw_set').on('click',function () {
            if(flag_set){
				$(this).css("background-color","transparent")
			}else{
				$(this).css("background-color","#051961")
			}
			flag_set=!flag_set;
            $("#shezhi_content").toggle()
        })
        //$('#nameinput').draggable();

	});
    $('#build_close').on('click',function () {
		$('#build_info_win').hide();
    });

    function querygrid(latn_id){
		if(latn_id!=null&&latn_id!=undefined){

		}else {
			latn_id=$("#g_city option:selected").val()
		}
		var bureau_no=$("#g_area option:selected").val()
		var union_org_code=$("#g_branch option:selected").val()
        var g_grid_name = $("#g_grid_name").val();
        g_grid_name = $.trim(g_grid_name);
        $.post(url4Query,{eaction:"grid_list",latn_id:latn_id,bureau_no:bureau_no,union_org_code:union_org_code,grid_name:g_grid_name},function(data){
            data=$.parseJSON(data)
            if(data.length==0) {
                $(".grid_table").html("<tr><td style='text-align:center' onMouseOver=\"this.style.background='rgb(250,250,250)'\" >没有查询到数据</td></tr>")
            }else{
                $(".grid_table").html(' ')
                var gridall = 0;
                var gridshow = 0;
                $.each(data,function (i, d) {
                    var str = "<tr class=\"tr_default_background_color\" style='height:30px;color:"+(d.GRID_SHOW==0?'#f00':'#000')+"' onclick=\"javascript:clickToGrid('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',this,"+ d.GRID_ZOOM+",'"+d.GRID_NAME+"','"+d.STATION_ID+"')\"  ><td style='width: 12%;text-align: left;padding-left:10px'>"+ (i+1)+"</td><td style='width: 38%;text-align: left;padding-left: 5px' title=\""+d.BRANCH_NAME+"\">"+d.BRANCH_NAME+"</td><td style='width: 55%;text-align: left;padding-left:5px'>"+ d.GRID_NAME+"("+d.COUNT+")</td></tr>";
                    $(".grid_table").append(str)
                    gridall++;
                    if(d.GRID_SHOW==1){
                        gridshow++
                    }
                })
                var stan=22
                var len=$(parent.window).width()
                if(len<1900)
                    stan=10
                if(data.length<=stan){
                    for(var i=0;i<stan-data.length;i++){
                        var str = "<tr class=\"tr_default_background_color\" style='height:30px'  onMouseOver=\"this.style.background='rgb(250,250,250)'\" onMouseOut=\"this.style.background='rgb(250,250,250)'\" ><td style='width: 12%;text-align: center'></td><td style='width: 35%;text-align:center'></td><td style='width: 40%;text-align: center'></td></tr>";
                        $(".grid_table").append(str)
                    }
                }
                //$("#grid_show").html("共"+gridall+"个网格，未上图<font color=\"red\">"+(gridall-gridshow)+"</font>个");
                $("#gridcount1").html(gridall);
                $("#gridcount2").html(gridall-gridshow);
            }
        });
    }
	//渲染 某个区县 下的支局群板块，填充颜色
	function toGis() {//城关区，兰州市
		global_current_flag = 4;
		var cityForLayer = cityNames[city_full_name];
		if (cityForLayer == undefined)
			return;
		var pageMapHeight = $(window).height();
		if(pageMapHeight==0)
			pageMapHeight = parent.document.documentElement.clientHeight-6;
		$("#gismap").height(pageMapHeight);
		$("#gismap").show();
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
					"esri/geometry/Circle",
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
					"esri/units",
					"CustomModules/ChartInfoWindow",
					"CustomModules/CustomTheme",
					"CustomModules/geometryUtils",
					"dijit/registry",
					"dijit/form/Button",
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
						  Circle,
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
						  Draw,
						  Navigation,
						  Units,
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
				) {
					Config.defaults.io.proxyUrl = "http://135.149.64.140:8888/proxy/proxy.jsp";
					Config.defaults.io.alwaysUseProxy = false;
					//本地网地图url
					var layer_ds = tiled_address_pre + cityForLayer + tiled_address_suf;

					var sub_layer_index = "/1";
					var grid_layer_index = "/0";

					var new_url_sub_vaild = new_url_sub_grid;
					var new_url_grid_vaild = new_url_sub_grid;

					if(city_id == "932"){
						new_url_sub_vaild = new_url_sub_dx;
						new_url_grid_vaild = new_url_grid_dx;
						sub_layer_index = "/0";
					}else if(city_id == "947"){
						new_url_sub_vaild = new_url_sub_jyg;
						new_url_grid_vaild = new_url_grid_jyg;
						sub_layer_index = "/0";
					}

					/*var new_url_sub_grid = new_url_sub_grid;
					var gpServerUrl =gpServerUrl;
					var new_url_point = new_url_point;*/
					//标准地址 第四级地址，到栋幢+单元，点要素
					var standard_address = standard_address_pre+cityForLayer+standard_address_suf;
					//var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/new_sub_grid_20160613/MapServer";
					//var new_url = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/new_sub_grid_netpoint/MapServer";
					//var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/new_sub_grid_with_area_20170616/MapServer";
					//var gpServerUrl ="http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/juhe_tools/GPServer";
					var currentOpacity = 1;
					var highlightSymbol_sub_mouse_over = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_SOLID,
							new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([highlight_sub_mouse_over_color[0],highlight_sub_mouse_over_color[1],highlight_sub_mouse_over_color[2],currentOpacity]),highlight_sub_mouse_over_line_width),//0.3],2
							new Color([highlight_sub_mouse_over_color[0],highlight_sub_mouse_over_color[1],highlight_sub_mouse_over_color[2],currentOpacity])//0.6
					);
					var highlightSymbol_grid_mouse_over = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_SOLID,
							new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([highlight_grid_mouse_over_color[0],highlight_grid_mouse_over_color[1],highlight_grid_mouse_over_color[2],currentOpacity]),highlight_grid_mouse_over_line_width),//0.3],2
							new Color([highlight_grid_mouse_over_color[0],highlight_grid_mouse_over_color[1],highlight_grid_mouse_over_color[2],currentOpacity])//0.6
					);
					var highlightSymbol_sub_click = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_SOLID,
							new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([sub_selected_fill_color[0],sub_selected_fill_color[1],sub_selected_fill_color[2],currentOpacity]),sub_selected_line_width),//0.3],2  //255,255,102 20170616
							new Color([sub_selected_fill_color[0],sub_selected_fill_color[1],sub_selected_fill_color[2],currentOpacity])//0.6
					);
					var highlightSymbol_grid_click = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_SOLID,
							new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([grid_selected_fill_color[0],grid_selected_fill_color[1],grid_selected_fill_color[2],currentOpacity]),grid_selected_line_width),//0.3],2
							new Color([grid_selected_fill_color[0],grid_selected_fill_color[1],grid_selected_fill_color[2],currentOpacity])//0.6
					);
					var linesymbol_sub_selected = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(sub_selected_line_color), sub_selected_line_width);
					var linesymbol_grid_selected = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(grid_selected_line_color), grid_selected_line_width);

					//var linesymbol_qx_all_line = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_all_line_color), qx_all_line_width);
					var linesymbol_qx_all_line = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_all_line_color), qx_all_line_width);
					var linesymbol_qx_selected = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_selected_line_color), qx_selected_line_width);

					//支局下有网格存在时候，给支局加轮廓线
					var linesymbol_has_grid_in_sub = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(sub_has_grid_self_line_color), sub_has_grid_self_line_width);

					//支局下没有网格的时候，给支局加渔网背景
					if(beforeMouseOverColor_sub=="" || beforeMouseOverColor_sub==undefined)
						beforeMouseOverColor_sub = {r:128,g:128,b:128};
					var fillsymbol_none_grid_in_sub = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS,
							new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,
									new esri.Color([255,0,0]), 2),new esri.Color([beforeMouseOverColor_sub.r, beforeMouseOverColor_sub.g, beforeMouseOverColor_sub.b,0.25]));

					var point_selected_mark = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 30,
							new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
									new Color([0,255,0]), 1),
							new Color([0,255,0,0.25]));

					//未划配网格 提示文字的字体
					var font_sub_none_grid_text = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
					font_sub_none_grid_text.setFamily("微软雅黑");

					var font_qx_text = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
					font_qx_text.setFamily("华文中宋");

					var grid_zoom = 1;
					//parser.parse();//解释小部件标签属性
					map = new Map("gismap");
					//map.showPanArrows();
					map.on("load", function () {
						map.hideZoomSlider();
						toolbar = new Draw(map);
						toolbar.on("draw-end", drawAddToMap);
					});
					var navToolbar = new Navigation(map);

                    $('#yingxiao_close').on('click',function () {
                        $('#yingxiao_info_win').hide();
                        $('#yingxiao_info_win_new').hide();
                        draw_layer.clear();
                    })
                    $('#yingxiao_new_close').on('click',function () {
                        $('#yingxiao_info_win_new').hide();
                        $('#yingxiao_info_win').hide();
                    })
					$("#nav_zoomprev").click(
						function(){
							navToolbar.zoomToPrevExtent();
						}
					);
					$("#nav_zoomnext").click(
						function(){
							navToolbar.zoomToNextExtent();
						}
					);
					$("#nav_extent").click(
						function(){
							navToolbar.zoomToFullExtent();
						}
					);
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
                                $('#build_info_win').hide()
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
                                $('#build_info_win').hide()
							}
						}
					);

					//查找 支局 网格
					$("#nav_query").click(function(){
						$("#query_div").css({"top":$(this).offset().top});
						$("#query_div").css({"left":"32px"});
						$("#query_div").toggle();
						layer.closeAll();
						tmp = '1';
						$("#nav_query").toggleClass("active");
						$('#build_info_win').hide()
						if($("#query_div").is(':visible'))
							$("#nav_list").removeClass("active");
					});
					//支局的查询按钮
					$("#location_find").click(
						function(){
							var location_name = $("#location_name").val();
							location_name = $.trim(location_name);
							if(location_name==""){
								layer.msg("请输入名称");
								return;
							}
							map.infoWindow.hide();
							$("#sub_info_win").hide();
							$("#grid_info_win").hide();
							$("#nav_fanhui").hide();
							$("#nav_fanhui_sub").hide();
							$("#nav_fanhui_qx").show();
							graLayer_subname_result.clear();
							graLayer_mouseclick.clear();
							graLayer_mouseclick.hide();
							graLayer_zj_click.clear();
							graLayer_wg_click.clear();
							graLayer_wg.hide();
							graLayer_wg_text.hide();
							graLayer_grid_mouseover.clear();

							featureLayer.show();
							graLayer_zjname.show();
							graLayer_qx.show();
							graLayer_qx_all.show();

							$("#query_div").hide();
							$("#nav_query").toggleClass("active");
							var location_type = $("#location_type").val();
							//var queryTask1 = new QueryTask(new_url_sub_vaild + "/"+location_type);
							var queryTask1 = new QueryTask(new_url_sub_vaild + sub_layer_index);
							var query = new Query();

							query.where = "REPORTTO LIKE '%"+location_name+"%' AND MAPID = "+map_id;
							query.outFields = ["SUBSTATION_NO","REPORTTO"];
							query.returnGeometry = true;
							queryTask1.execute(query, function(results) {
								var fs = results.features;
								if(fs.length==0){
									layer.msg("暂无查询结果");
									return;
								}

								var feature = results.features[0];
								//支局
								if(location_type==1){
									//绘制所查询支局的归属区县的轮廓线
									var substation = feature.attributes.SUBSTATION_NO;
									var sub_name = sub_data[substation];
									drawQXLine(substation,sub_name);

									parent.global_substation = substation;
									parent.global_current_flag = 4;
									parent.global_current_full_area_name = sub_name;
									parent.global_current_area_name = sub_name;
									parent.freshIndexContainer(indexContainer_url_sub);
									parent.global_position.splice(3,1,sub_name);
									parent.updatePosition(parent.global_current_flag);

									parent.frmTitleShow();
									parent.bar_status_history = parent.status;
									//所点支局的视野、名称
									var sub_selected_geometry = feature.geometry;
									sub_selected_ext = sub_selected_geometry.getExtent();
									map.setExtent(sub_selected_ext.expand(1.5));

									var graphics = new esri.Graphic(sub_selected_geometry, linesymbol_sub_selected);
									graLayer_zj_click.add(graphics);
								}/*else if(location_type==1){
								 //查询后的网格，进行描边
								 var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(click_line_color), 3);
								 var graphics = new esri.Graphic(feature.geometry, linesymbol);
								 graLayer_mouseclick.add(graphics);
								 graLayer_mouseclick.show();
								 graLayer_mouseclick.redraw();
								 //放大到所选支局的视野
								 map.setExtent(feature.geometry.getExtent().expand(1.2));
								 }*/
							});
						}
					);

					operateVillage=function(village_id,st,addr,thiz){
                    //定位并更新右边小区信息
                        $("#village_info_win").show()
                        $.post(url4Query,{eaction:'village_message',village_id:village_id},function (data) {
                            var d =$.parseJSON(data)
							$("#village_title").text(d.VILLAGE_NAME)
                            freshFigue([d.MOBILE_ST_RATE.toFixed(2),d.WIDEBAND_ST_RATE.toFixed(2),d.IPTV_ST_RATE.toFixed(2),d.H_USER_ST_RATE.toFixed(2)])
                            $("#bn").text(d.BUILDING_NUM==null?'-':d.BUILDING_NUM)
                            $("#rn").text(d.PEOPLE_NUM==null?'-':d.PEOPLE_NUM)
                            $("#dn").text(d.UNIT_NUM==null?'-':d.UNIT_NUM)
                            $("#zn").text(d.FAMILY_NUM==null?'-':d.FAMILY_NUM)
                            $("#dj").text(d.IS_SOLE==null?'-':d.IS_SOLE)
                            $("#hf").text(d.IS_FDDI==null?'-':d.IS_FDDI)
                            $("#hp").text(d.H_PORT_NUM==null?'-':d.H_PORT_NUM)
                            $("#b_n").text(d.WIDEBAND_NUM==null?'-':d.WIDEBAND_NUM)
                            $("#h_n").text(d.H_USER_NUM==null?'-':d.H_USER_NUM)
                            $("#i_n").text(d.IPTV_NUM==null?'-':d.IPTV_NUM)
                            $("#m_n").text(d.MOBILE_NUM==null?'-':d.MOBILE_NUM)
                            $("#hly").text(d.H_PORT_USE_RATE==null?'-':(d.H_PORT_USE_RATE)+'%')
                            $("#rzl").text(d.OCCUPANCY_RATE==null?'-':d.OCCUPANCY_RATE+'%')
                            //更新表格
                            //电信
                            $("#dy").text(d.MOBILE_NUM==null?'-':d.MOBILE_NUM)
                            $("#db").text(d.WIDEBAND_NUM==null?'-':d.WIDEBAND_NUM)
                            $("#di").text(d.IPTV_NUM==null?'-':d.IPTV_NUM)
                            //联通
                            $("#my").text(d.CMCC_NUM==null?'-':d.CMCC_NUM)
                            $("#mb").text(d.CM_WIDEBAND_NUM==null?'-':d.CM_WIDEBAND_NUM)
                            $("#mi").text(d.CMCC_TV_NUM==null?'-':d.CMCC_TV_NUM)
                            //移动
                            $("#ly").text(d.CUCC_NUM==null?'-':d.CUCC_NUM)
                            $("#lb").text(d.CU_WIDEBAND_NUM==null?'-':d.CU_WIDEBAND_NUM)
                            $("#li").text(d.CUCC_TV_USER_NUM==null?'-':d.CUCC_TV_USER_NUM)
                            if(d.VILLAGE_TYPE!='1')
                                $("#spe").text('H 入户率')
                        })
						function freshFigue(fourdata){
							var option = {
								title: {
									text: ''
								},
								tooltip : {
									trigger: 'axis',
									formatter:'{b}<br/>{a}:&nbsp;&nbsp;{c}%',
									position:"top",
									show:false,
								},
								legend: {
									show:false
								},
								toolbox: {
									show:false
								},
								grid: {
								    top:15,
									bottom:25,
                                   containLabel:true,
								},
								xAxis : [
									{
								/*		min:1,
										max:20,
										scale:0,
										splitNumber:1,
										minInterval:1,
//                    interval:1,*/
										type : 'category',
										axisLine:{
											lineStyle:{
												color:'#ccc'
											}
										},
										axisLabel: {
											show: true,
											textStyle: {
												fontSize: '12',
												color:'#777',
											}
										},
										show: true,

										boundaryGap : false,
										data :['移动渗透率','宽带入户率','电视入户率','光网入户率']
									}
								],
								yAxis : [
									{
										silent: true,
										show: false,
										splitLine: {
											show: false
										},
										type : 'value'
									}
								],
								series : [
									{
										name:'上月',
										type:'bar',
										stack: '总量',
										smooth:true,
										barMinHeight:10,
										itemStyle: {
											normal: {
												color: function(params) {
													//首先定义一个数组
													var colorList = [
														'#1dbbb5','#fa8513','#b5ef8e','#109afb'
													];
													return colorList[params.dataIndex]
												},
												//以下为是否显示
												label: {
													show: true,
													formatter:'{c}%',
													textStyle: {
														fontWeight: '700',
														fontSize: '12',
														color:'#777',
													}
												},
												lineStyle: {
													color: '#03d2e3',
													width:1
												}
											}
										},
										barWidth:30,
//					barGap:'20%',
										label: {
											normal: {
												show: true,
												position: 'top'
											}
										},
										data:fourdata
									}
								]
							};
							myChart.setOption(option);
						}


					}
					$("#v_village_name").on("keypress",function (event) {
						var keyCode= event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
						if(keyCode==13){
							$("#village_query").click()
						}
					})
                    $("#g_grid_name").on("keypress",function (event) {
                        var keyCode= event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
                        if(keyCode==13){
                            $("#grid_query").click()
                        }
                    })
					$("#b_branch_name").on("keypress",function (event) {
						var keyCode= event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
						if(keyCode==13){
							$("#branch_query").click()
						}
					})
					//小区查询开始
					$("#village_query").on("click",function () {
						queryVillage()
					})
					function queryVillage(latn_id) {
						var vn = $("#v_village_name").val()
						if(latn_id==null||latn_id==undefined){
							latn_id=$("#v_city option:selected").val()
						}
						var bureau_no=$("#v_area option:selected").val()
						var union_org_code=$("#v_branch option:selected").val()
						var grid_id=$("#v_grid option:selected").val()
						var notUpload=0

						$.post(url4Query,{eaction:'village_list',latn_id:latn_id,bureau_no:bureau_no,union_org_code:union_org_code,grid_id:grid_id,village_name:$.trim(vn)},function (data) {
							data=$.parseJSON(data)
							$(".village_table").html(' ');
							$.each(data,function (i, d) {
								var up = d.BEN_GIS_UPLOAD;
								var color='red';
								if (up==1){
									color='black';
								}else{
									notUpload++;
								}
								var x =d.VILLAGE_NAME
								if(x.length>8)
									x=x.substr(0,7)+'..'
								//var str = "<tr class=\"tr_default_background_color\" style='height:32px;font-size:14px;cursor:pointer;color:"+color+"' onclick=\"javascript:operateVillage('"+d.VILLAGE_ID+"','"+d.VILLAGE_NAME+"','"+d.VILLAGE_ADDR+"',this)\" ><td style='width: 15%;text-align: center'>"+ (i+1)+"</td><td style='width: 35%;text-align:left' title=\""+d.BRANCH_NAME+"\">"+d.BRANCH_NAME+"</td><td style='width: 40%;text-align: left' title='"+d.VILLAGE_NAME+"'>"+x+"</td></tr>"
                                var str = "<tr class=\"tr_default_background_color\" style='height:32px;font-size:14px;cursor:pointer;color:"+color+"' onclick=\"javascript:clickToGridAndVillage('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',this,"+ d.GRID_ZOOM+",'"+d.GRID_NAME+"','"+d.STATION_ID+"','"+d.VILLAGE_ID+"')\" ><td style='width: 15%;text-align: center'>"+ (i+1)+"</td><td style='width: 35%;text-align:left' title=\""+d.GRID_NAME+"\">"+d.GRID_NAME+"</td><td style='width: 40%;text-align: left' title='"+d.VILLAGE_NAME+"'>"+x+"</td></tr>"
                                $(".village_table").append(str)
							})
							var stan=20;
							var width=$(parent.window).width()
							if(width<=1900)
								stan=9
							if(data.length==0) {
								$(".village_table").append("<tr><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
							}else if(data.length<stan){
								for(var i=0;i<=stan-data.length;i++) {
									var str = "<tr class=\"tr_default_background_color\" style='height:30px'onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='width: 10%;text-align: center'></td><td style='width: 35%;text-align:center' ></td><td style='width: 40%;text-align: center'></td></tr>";
									$(".village_table").append(str)
								}
							}

							//$("#village_show").html("共"+data.length+"个小区，未上图<font color=\"red\">"+notUpload+"</font>个")
                            $("#villagecount1").html(data.length);
                            $("#villagecount2").html(notUpload);
						})
					}
					/*yinming 2017年7月20日12:06:51 新增小区右侧列表定位*/
                    global_village_map = function (village_id) {
						//operateVillage(village_id)
						village_position_layer.clear();
						$.post(url4Query,{eaction:'village_ding',village_id:village_id},function (data) {
                            data=$.parseJSON(data);
                            //console.log(data);
							if (data!=null){
								var size = standard_point_get_size(map.getZoom());
								var img = new PictureMarkerSymbol(village_ico_selected, size*3, size*3);
								var village_gras = village_layer.graphics;
								for(var i = 0,l = village_gras.length;i<l;i++){
									var gra = village_gras[i];
									if(gra.attributes.village_id == village_id){
										var graphic = new esri.Graphic(new Point(parseFloat(data.POS_X),parseFloat(data.POS_Y),new SpatialReference({ wkid: 4326 })),img,gra.attributes);
										village_position_layer.add(graphic);
									}
								}
								village_position_layer.redraw();
								map.addLayer(village_layer);
								map.removeLayer(village_position_layer);
								map.addLayer(village_position_layer);
								map.centerAndZoom([parseFloat(data.POS_X),parseFloat(data.POS_Y)],map.getZoom());
							}else{
                                layer.msg("该小区未上图");
							}
                        })
                    }
                    parent.global_village_map = global_village_map;

					/*yinming 2017年7月20日12:16:51 新增小区左侧列表定位*/
					//20170724 liangliyuan修改，点击小区后，放大到网格范围，并绿色框标识出所点小区位置
                    clickToGridAndVillage = function (substation,sub_name,thiz,zoom,grid_name,station_id,village_id) {
						clickToGridAndPositionVillage(substation,sub_name,thiz,zoom,grid_name,station_id,village_id);
						//operateVillage(village_id);
                        //global_village_map(village_id);
                    }

					var village_table_height=['298px', '99.7%']
					var village_table_layer;

                    //网格查询按钮
                    $("#grid_query").click(
                        function () {
                            querygrid();
                        }
                    );

                    var tmp = '1';
                    var tmp2 = '1';
                    var tmpx = '1';
                    var tmpl = '1';
                    var tmpy = '1';
					//支局列表开始
					$('#nav_list').on('click', function () {
						parent.global_substation = "";
                        layer.closeAll();
                        $('#build_info_win').hide()
						$("#village_info_win").hide()
                        $('#build_info_win').hide();
                        $("#marketing_div").hide();
                        $("#yingxiao_info_win").hide();
                        $('#yingxiao_info_win_new').hide();
                        $("#detail_more").hide();
                        tmp2 = "1";
                        $("#nav_grid").removeClass("active");
                        tmpx = '1';
                        $("#nav_village").removeClass("active");
                        tmpl = '1';
                        $("#nav_standard").removeClass("active");
                        tmpy = '1';
                        $("#nav_marketing").removeClass("active");
						if (tmp == '') {
                            tmp = "1";
							$("#nav_list").removeClass("active");
						} else {
                            tmp = '';
							$("#nav_list").addClass("active");
							$("#nav_query").removeClass("active");
							$("#query_div").hide();
							layer.open({
								title: ['支局列表', 'line-height:32px;text-size:30px;height:32px;'],
								//title:false,
								type: 1,
								shade: 0,
								area: ["298px","99.7%"],
								offset: ['1px', '38px'],
								content: $("#list_div"),
								cancel: function(index){
									$("#nav_list").removeClass("active");
									return tmp='1';
								}
							});
						}
					});
					//支局列表结束
                    //网格列表开始
                    $('#nav_grid').on('click', function () {
						parent.global_substation = "";
                        layer.closeAll();
						$("#village_info_win").hide()
                        $('#build_info_win').hide()
                        $('#build_info_win').hide();
                        $("#marketing_div").hide();
                        $("#yingxiao_info_win").hide();
                        $('#yingxiao_info_win_new').hide();
                        $("#detail_more").hide();
                        tmp = "1";
                        $("#nav_list").removeClass("active");
                        tmpx = '1';
                        $("#nav_village").removeClass("active");
                        tmpl = '1';
                        $("#nav_standard").removeClass("active");
                        tmpy = '1';
                        $("#nav_marketing").removeClass("active");
                        if (tmp2 == '') {
                            //重置网格
                            tmp2 = "1";
                            $("#nav_grid").removeClass("active");
                        } else {
                            //重置网格
                            tmp2 = '';
                            $("#nav_grid").addClass("active");
                            $("#nav_query").removeClass("active");
                            $("#query_div").hide();
                            $("#g_grid_name").val("");
                            layer.open({
                                title: ['网格列表', 'line-height:32px;text-size:30px;height:32px;'],
                                //title:false,
                                type: 1,
                                shade: 0,
                                area: ['298px', '99.7%'],
                                offset: ['1px', '38px'],
                                content: $("#grid_div"),
                                cancel: function(index){
                                    $("#nav_grid").removeClass("active");
                                    return tmp2='1';
                                }
                            });

                        }
                    });
					querygrid(city_id);
                    //网格列表结束
                    //小区列表开始
					var village_list;
					$('#nav_village').on('click', function () {
						layer.closeAll();
						$("#village_info_win").hide()
                        $('#build_info_win').hide()
                        $('#build_info_win').hide();
                        $("#marketing_div").hide();
                        $("#yingxiao_info_win").hide();
                        $('#yingxiao_info_win_new').hide();
                        $("#detail_more").hide();
                        tmp = "1";
                        $("#nav_list").removeClass("active");
                        tmp2 = "1";
                        $("#nav_grid").removeClass("active");
                        tmpl = '1';
                        $("#nav_standard").removeClass("active");
                        tmpy = '1';
                        $("#nav_marketing").removeClass("active");
						if (tmpx == '') {
                            tmpx = '1';
                            $("#nav_village").removeClass("active");
						} else {
                            tmpx = '';
							$("#nav_village").addClass("active");
							queryVillage(city_id)
							village_table_layer= layer.open({
								title: ['小区列表', 'line-height:32px;text-size:30px;height:32px;'],
								//title:false,
								type: 1,
								shade: 0,
								area: ['298px', '99.7%'],
								offset: ['1px', '38px'],
								content: $("#village_div"),
								cancel: function(index){
									$("#nav_village").removeClass("active");
									return tmpx='1';
								}
							});
						}
					});

                    //小区列表结
					//小区查询选择框筛选
					setCitys($("#v_city"),$("#v_area"),$("#v_branch"),$("#v_grid"),$("#village_query"))
					setGCitys();
					var baseFullOption="<option  value=''>全部</option>"
					//获取所有地市级信息，并填充到小区select标签
                    function setCitys(e,e1,e2,e3,e4){
						$.post(url4Query,{eaction:'setcitys'},function(data){
							data=$.parseJSON(data)
							var str=''

							e.on("change",function () {
								var id=e.find(":selected").val()
								e1.html(baseFullOption)
								e2.html(baseFullOption)
								e3.html(baseFullOption)
								e4.click()
								if(id!='')
								 setArea(id,e1,e2,e3,e4)
							})
							$.each(data,function (i, d) {
								str+="<option value='"+d.LATN_ID+"'>"+d.LATN_NAME+"</option>"
							})
							e.html(baseFullOption)
							e.append(str)
							e.find("option[value="+city_id+"]").attr("selected","selected")
							setArea(city_id,e1,e2,e3,e4)
						})
					}
					function setArea(id,e1,e2,e3,e4){
 						$.post(url4Query,{eaction:"setareas",latn_id:id},function (data) {
							data=$.parseJSON(data)

							e1.on("change",function () {
								e2.html(baseFullOption)
								e3.html(baseFullOption)
								var id=e1.find(":selected").val()
								e4.click()
								setBranchs(id,e2,e3,e4)
								if(id!=null){
									setGrids(null,e3,e4)
								}
							})
							var str=''
							$.each(data,function (i,d) {
							str+="<option value='"+d.BUREAU_NO+"'>"+d.BUREAU_NAME+"</option>"
							})
							e1.html(baseFullOption)
							e1.append(str)
							setBranchs(null,e2,e3,e4)
						})
					}
					setBranchs=function (id, e1, e2,e3) {
						var latn_id = $("#v_city option:selected").val()
						$.post(url4Query,{eaction:"setbranchs",id:id,latn_id:latn_id},function (data) {
							data=$.parseJSON(data)

							e1.on("change",function () {
									var id=e1.find(":selected").val()
								e2.html(baseFullOption);
								e3.click();
								setGrids(id,e2,e3)
							})
							var str=''
							$.each(data,function (i,d) {
								str+="<option value='"+d.UNION_ORG_CODE+"'>"+d.BRANCH_NAME+"</option>"
							})
							e1.html(baseFullOption)
							e1.append(str)
						})
					}
					setGrids=function(id,e1,e2){
						var latn_id = $("#v_city option:selected").val()
						var bureau_no = $("#v_area option:selected").val()
						$.post(url4Query,{eaction:"setgrids",id:id,latn_id:latn_id,bureau_no:bureau_no},function (data) {
							data=$.parseJSON(data)
							e1.on("change",function () {
						e2.click();
							})
							var str=''
							$.each(data,function (i,d) {
								str+="<option value='"+d.GRID_ID+"'>"+d.GRID_NAME+"</option>"
							})
							e1.html(baseFullOption)
							e1.append(str)
						})
					}
					//网格查询选择框筛选
					function	setGCitys(){
						$.post(url4Query,{eaction:'setcitys'},function(data){
							data=$.parseJSON(data)
							var str='';
							$("#g_city").on("change",function () {
								var id=$(this).find(":selected").val()
								$("#g_area").html(baseFullOption);
								$("#g_branch").html(baseFullOption)
								if(id!=''){
									$("#grid_query").click()
									setGArea(id)
								}

							})
							$.each(data,function (i, d) {
								str+="<option value='"+d.LATN_ID+"'>"+d.LATN_NAME+"</option>"
							})
							$("#g_city").html(baseFullOption)
							$("#g_city").append(str)
							$("#g_city").find("option[value="+city_id+"]").attr("selected","selected")
							setGArea(city_id)
						})
					}
					setGArea=function(id){
						$.post(url4Query,{eaction:"setareas",latn_id:id},function (data) {
							data=$.parseJSON(data)

							$("#g_area").on("change",function () {
								$("#g_branch").html(baseFullOption)
								var id=$("#g_area").find(":selected").val()
								$("#grid_query").click()
								setGBranch(id)
							})
							var str=''
							$.each(data,function (i,d) {
								str+="<option value='"+d.BUREAU_NO+"'>"+d.BUREAU_NAME+"</option>"
							})
							$("#g_area").html(baseFullOption)
							$("#g_area").append(str)
							setGBranch()
						})

					}
					setGBranch=function(id){
						var latn_id=$("#g_city option:selected").val()
						$.post(url4Query,{eaction:"setbranchs",id:id,latn_id:latn_id},function (data) {
							data=$.parseJSON(data)

							$("#g_branch").on("change",function () {
								$("#grid_query").click();
							})
							var str=''
							$.each(data,function (i,d) {
								str+="<option value='"+d.UNION_ORG_CODE+"'>"+d.BRANCH_NAME+"</option>"
							})
							$("#g_branch").html(baseFullOption)
							$("#g_branch").append(str)
						})
					}
					//支局列表联动
					function setBranchCity(){
						$.post(url4Query,{eaction:'setcitys'},function(data){
							data=$.parseJSON(data)
							var str='';
							$("#br_city").on("change",function () {
								var id=$(this).find(":selected").val()
								$("#br_area").html(baseFullOption);
								if(id!=''){
									$("#branch_query").click()
								}
								setBranchArea(id)
							})
							$.each(data,function (i, d) {
								str+="<option value='"+d.LATN_ID+"'>"+d.LATN_NAME+"</option>"
							})
							$("#br_city").html(baseFullOption)
							$("#br_city").append(str)
							$("#br_city").find("option[value="+city_id+"]").attr("selected","selected")
							setBranchArea(city_id)
						})
					}
					function setBranchArea(id){
						$.post(url4Query,{eaction:"setareas",latn_id:id},function (data) {
							data=$.parseJSON(data);

							$("#br_area").on("change",function () {
								$("#branch_query").click();
							})
							var str='';
							$.each(data,function (i,d) {
								str+="<option value='"+d.BUREAU_NO+"'>"+d.BUREAU_NAME+"</option>";
							})
							$("#br_area").html(baseFullOption);
							$("#br_area").append(str);
						})
					}
					function setYCity(){
						$.post(url4Query,{eaction:'setcitys'},function(data){
							data=$.parseJSON(data)
							var str='';
							$("#y_city").on("change",function () {
								var id=$(this).find(":selected").val()
								$("#y_area").html(baseFullOption);
								$("#cc").click()
								setYArea(id)
							})
							$.each(data,function (i, d) {
								str+="<option value='"+d.LATN_ID+"'>"+d.LATN_NAME+"</option>"
							})
							$("#y_city").html(baseFullOption)
							$("#y_city").append(str)
							$("#y_city").find("option[value="+city_id+"]").attr("selected","selected")
							setYArea(city_id)
						})
					}
					function setYArea(id){
						$.post(url4Query,{eaction:"setareas",latn_id:id},function (data) {
							data=$.parseJSON(data);

							$("#y_area").on("change",function () {
								$("#cc").click();
							})
							var str='';
							$.each(data,function (i,d) {
								str+="<option value='"+d.BUREAU_NO+"'>"+d.BUREAU_NAME+"</option>";
							})
							$("#y_area").html(baseFullOption);
							$("#y_area").append(str);
						})
					}
					setYCity()
					$("#branch_query").on("click",function () {
						queryBranch()
					})
					function queryBranch(id){
						if(id!=city_id)
								id=$("#br_city option:selected").val()
						var area = $("#br_area option:selected").val()
						var branch_name=$("#b_branch_name").val()
						$.post('<e:url value="querysubgrid.e"/>',{eaction:"getSubListByLatnId",city_id:id,id:area,branch_name:branch_name},function(data){
							data = $.parseJSON(data);
							var data1 = data[1];
							data = data[0];
							var sub_style_num = new Array();
							var sub_show_num = 0;
							$(".list_table").html("")
							for(var i = 0,l = data.length;i<l;i++){
								var d = data[i];
								var str = "<tr class=\"tr_default_background_color\" style=\"color:"+(d.BRANCH_SHOW==0||d.FLAG!=1?'#f00':'#000')+"\" onclick=\"javascript:clickToSub('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',this,"+ d.ZOOM+")\" ><td style='width: 10%;text-align: center'>"+ (i+1)+"</td><td style='width: 22%;text-align: center'>"+ d.LATN_NAME+"</td><td style='width: 48%' title=\""+d.BRANCH_NAME+"\">"+ (d.BRANCH_NAME.length>7?d.BRANCH_NAME.substr(0,7)+"..":d.BRANCH_NAME)+d.GRID_NUM+"</td><td style='width: 20%;text-align: center'>"+ d.BRANCH_TYPE_CHAR+"</td></tr>";
								$(".list_table").append(str);
								if(sub_style_num[d.BRANCH_TYPE]==undefined)
									sub_style_num[d.BRANCH_TYPE] = 1;
								else
									sub_style_num[d.BRANCH_TYPE] += 1;
								sub_show_num += d.BRANCH_SHOW;
							}
							var stan=20;
							var len=$(parent.window).width()
							if(len<1900)
								stan=10;
							if(data.length<=stan){
								for(var j=0;j<stan-data.length;j++){
									var ss = "<tr class=\"tr_default_background_color\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\" onMouseOut=\"this.style.background='rgb(250,250,250)'\" ><td style='width: 10%;text-align: center'></td><td style='width: 22%;text-align:center'></td><td style='width: 48%;text-align: center'></td><td style='width: 20%;text-align: center'></td></tr>";
									$(".list_table").append(ss)
								}
							}
							/*$("#ta").next("div").html("<table higth=\"100%\" width=\"296px\" style=\"text-align:center;color:#000;height:100%;border-color:#CCC;table-layout: fixed;font-size: 0.8em\">"
									+"<tr style=\"border-top:1px solid #CCC;background-color: #E3E3E3;font-size: 14px;height: 32px;line-height: 32px\"><th style=\"font-weight:bold\">类型</th><th style=\"font-weight:bold\">总数</th><th style=\"font-weight:bold\">上图</th><th style=\"font-weight:bold\">未上图</th></tr>"
									+"<tr style=\"border-top:1px solid #CCC\"><td style=\"height: 28px;line-height:28px\">支局</td><td style=\"\">"+data1.COUNT1+"</td><td style=\"\">"+(data1.COUNT1-data1.COUNT4)+"</td><td><font color=\"red\">"+data1.COUNT4+"</font></td></tr>"
									+"<tr style=\"border-top:1px solid #CCC\"><td style=\"height: 28px;line-height: 28px\">网格</td><td style=\"\">"+data1.COUNT5+"</td><td style=\"\">"+(data1.COUNT5-data1.COUNT6)+"</td><td><font color=\"#ff0000\">"+data1.COUNT6+"</font></td></tr></table>");*/
                            //$("#ta").next("div").html("共"+data1.COUNT1+"个支局，未上图<font color=\"red\">"+data1.COUNT4+"</font>个");
                            $("#tacount1").html(data1.COUNT1);
                            $("#tacount2").html(data1.COUNT4);
						});
					}
					setBranchCity();
					//楼宇开始
					$("#nav_standard").click(
						function(){
							$("#b_city").html(baseFullOption)
                            layer.closeAll();
							$("#village_info_win").hide()
                            $('#build_info_win').hide()
                            $('#build_info_win').hide();
                            $("#marketing_div").hide();
                            $("#yingxiao_info_win").hide();
                            $('#yingxiao_info_win_new').hide();
                            $("#detail_more").hide();
                            tmp = "1";
                            $("#nav_list").removeClass("active");
                            tmp2 = "1";
                            $("#nav_grid").removeClass("active");
                            tmpx = '1';
                            $("#nav_village").removeClass("active");
                            tmpy = '1';
                            $("#nav_marketing").removeClass("active");
                            if (tmpl == '') {
                                tmpl = '1';
                                $("#nav_standard").removeClass("active");
                            }else{
                                tmpl = '';
//                                var point = map.center;
//                                var zoom = map.getZoom()>=9?map.getZoom():9;
//                                map.centerAndZoom(point,zoom);
                                $("#nav_standard").addClass("active");
								setBuildCity()

//                                standard_load();
								layer.open({
									title: ['楼宇列表', 'line-height:32px;text-size:30px;height:32px;'],
									//title:false,
									type: 1,
									shade: 0,
									area: ['298px', '99.7%'],
									offset: ['1px', '38px'],
									content: $("#build_div"),
									cancel: function(index){
										$("#nav_standard").removeClass("active");
										return tmp1='1';
									}
								});
							}
						}
					);
					queryBuild(city_id)
					/*yinming 2017-7-21 10:30:13 营销按钮点击移动到楼宇点击下面 做出相应逻辑修改*/
					//营销弹出 绘图菜单
                    $("#nav_marketing").click(
                        function(){
							$("#village_info_win").hide()
                            $('#build_info_win').hide()
                            $('#build_info_win').hide();
                            $("#marketing_div").hide();
                            $("#yingxiao_info_win").hide();
                            $('#yingxiao_info_win_new').hide();
                            $("#detail_more").hide();
                            //$("#nav_marketing").toggleClass("active");
                            layer.closeAll();
                            tmp = "1";
                            $("#nav_list").removeClass("active");
                            tmp2 = "1";
                            $("#nav_grid").removeClass("active");
                            tmpx = '1';
                            $("#nav_village").removeClass("active");
							tmpl = '1';
							$("#nav_standard").removeClass("active");
                            if (tmpy == '') {
                                tmpy = '1';
                                $("#nav_marketing").removeClass("active");
                            }else{
                                tmpy = '';
                                $("#nav_marketing").addClass("active");
                                $("#chaxun").val("");
                                yingxiao_table_layer= layer.open({
                                    title: ['营销列表', 'line-height:32px;text-size:30px;height:32px;'],
                                    //title:false,
                                    type: 1,
                                    shade: 0,
                                    area: ['298px', '99.7%'],
                                    offset: ['1px', '38px'],
                                    content: $("#yingxiao_div"),
                                    cancel: function(index){
                                        $("#nav_marketing").removeClass("active");
                                        return tmpx='1';
                                    }
                                });
                                queryYX();
							}
                        }
                    );

                    $("#clear_draw").on('click',function () {
                        $('#yingxiao_info_win').hide();
                        $('#yingxiao_info_win_new').hide();
                        draw_layer.clear();
                    })
					/*yinming 2017-7-21 10:30:13 营销按钮end*/
                    $("#xinjian").click(
                        function(){
                            //隐藏无关的按钮
                            if($("#nav_fanhui_sub").is(':visible')){
                                $("#nav_fanhui_sub").hide();//隐藏返回按钮
                                back_btn_hided = "#nav_fanhui_sub";
                            }
                            else if($("#nav_fanhui_qx").is(':visible')){
                                $("#nav_fanhui_qx").hide();//隐藏返回按钮
                                back_btn_hided = "#nav_fanhui_qx";
                            }else if($("#nav_fanhui").is(':visible')){
                                $("#nav_fanhui").hide();//隐藏返回按钮
                                back_btn_hided = "#nav_fanhui";
                            }else if($("#nav_fanhui_city").is(':visible')){
								$("#nav_fanhui_city").hide();//隐藏返回按钮
								back_btn_hided = "#nav_fanhui_city";
							}
                            $('#yingxiao_info_win_new').hide();
                            $(".tools_n").hide();//隐藏左侧工具条
                            parent.hideMapPosition();//隐藏地图右上方返回路径条
                            //先放大到楼宇级别，9级，只在框选功能中有效
                            var zoom = map.getZoom();
                            if(zoom<9 && draw_type != "village"){
                                var point = map.center;
                                map.centerAndZoom(point,9);
                            }

                            $("#nav_standard").addClass("active");

                            $("#nav_marketing").addClass("active");
                            //map.setMapCursor("crosshair");
                            map.infoWindow.hide();
                            draw_layer.clear();
                            draw_layer.show();
                            killEvent();
                            if(draw_layer_leida_click_handler!="")
                                dojo.disconnect(draw_layer_leida_click_handler);
                            layer.closeAll();
                            tmp = "1";
                            $("#nav_list").removeClass("active");
                            tmp2 = "1";
                            $("#nav_grid").removeClass("active");
                            tmpx = '1';
                            $("#nav_village").removeClass("active");
                            tmpl = '1';
                            $("#nav_standard").removeClass("active");
							tmpy = '1';
							$("#nav_marketing").removeClass("active");
                            $("#marketing_div").show();
                            draw_layer.show();
                        }
                    );
					/*yinming 2017年7月21日16:12:42 营销新建*/

					/*yinming 2017年7月21日16:12:42 营销新建end*/

					/*yinming 2017年7月21日10:39:10 新增营销查询*/
                    $("#cc").click(function () {
                        queryYX()
                    })

					function queryYX() {
                        //清空列表
						var latn_id=$("#y_city option:selected").val()
						var area_id=$("#y_area option:selected").val()
						if(latn_id==947)
								latn_id=937
					    var chaxun = $("#chaxun").val();
                        $.post(url4Query,{eaction:'yingxiao_list',chaxun:chaxun,latn_id:latn_id,area_id:area_id},function (data) {
                            data=$.parseJSON(data);
							$("#yingxiao_table").html("");
                            if(data!=null){
                                $.each(data,function (i, d) {
                                    /*var x =d.VILLAGE_NAME
                                    if(x.length>8)
                                        x=x.substr(0,7)+'..'*/
                                    var str = "<tr class=\"tr_default_background_color\" style='height:32px;font-size:14px;'><td style='width: 15%;text-align: center'>"+ (i+1)+"</td><td style='width: 55%;text-align:left' ><u onclick=\"javascript:queryfromyxid('"+d.YX_ID+"')\" style='cursor:pointer'>"+d.YX_NAME+"</u></td><td style='text-align: left' >"+d.CREATE_DATE+"</td></tr>"
                                    $("#yingxiao_table").append(str);
                                })
							}
                            var stan=20;
                            var width=$(parent.window).width()
                            if(width<=1900)
                                stan=8
                            if(data.length==0) {
								$("#yingxiao_table").html("")
                                $("#yingxiao_table").html("<tr><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                            }else if(data.length<stan){
                                for(var i=0;i<=stan-data.length;i++) {
                                    var str = "<tr class=\"tr_default_background_color\" style='height:30px'onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='text-align: center'></td><td style='text-align:center' ></td><td style='text-align: center'></td></tr>";
                                    $("#yingxiao_table").append(str)
                                }
                            }
						})
                    }
					/*yinming 2017年7月21日10:39:10 新增营销查询 end*/
					/*yinming 2017年7月22日14:51:59 营销联动*/
                    queryfromyxid = function (id) {
                        $.post(url4Query,{eaction:"yingxiao_list_3",yxid:id},function(data){
                            data = $.parseJSON(data);
                            var yingxiaotable = $("#yingxiao_table_c");
                            yingxiaotable.html("");
                            var str = "";
                            var zhu = 0;
                            var ren = 0;
                            var ying = 0;
                            var segm_id2 = "";
                            $.each(data,function (i, d) {
                                if(i==0){
                                    $("#yx_name").html(d.YX_NAME);
                                    $("#yx_creatp").html(d.CREATE_NAME);
                                    $("#yx_creatt").html(d.CREATE_DATE);
                                }
                                segm_id2 += (d.ADDRESS_4_SEGM_ID+ ".");
                                str += "<tr>" +
                                    "<td width=\"8%\">"+(i+1)+"</td> " +
                                    "<td width=\"38%\" style=\"cursor: pointer;text-decoration: underline;color: blue;text-align: left\" onclick=\"showBuildDetail('"+d.ADDRESS_4_SEGM_ID+"','"+d.SEGM_NAME+"','all',0,9)\">"+d.SEGM_NAME+"</td> " +
                                    "<td width=\"10%\">"+d.ZHU_HU_COUNT+"</td>" +
                                    "<td width=\"10%\">";
                                if(d.PEOPLE_COUNT!=null){
                                    str += d.PEOPLE_COUNT;
                                }else {
                                    str += '-';
                                }
                                str +="</td><td class=\"\" width=\"10%\" " ;
                                //不为0才能点击
                                if(d.KD_YX>0){
                                    str+="style=\"cursor: pointer\" onclick=\"showBuildDetail('"+d.ADDRESS_4_SEGM_ID+"','"+d.SEGM_NAME+"','kd',0)\"";
                                }
                                str +=">"+d.KD_YX+"</td>" +
                                    "<td class=\"\" width=\"10%\" ";
                                if(d.DX_YX>0){
                                    str+="style=\"cursor: pointer\" onclick=\"showBuildDetail('"+d.ADDRESS_4_SEGM_ID+"','"+d.SEGM_NAME+"','itv',0)\"";
                                }
                                str +=">"+d.DX_YX+"</td>" +
                                    "<td class=\"\" width=\"10%\" ";
                                if(d.GU_YX>0){
                                    str+="style=\"cursor: pointer\" onclick=\"showBuildDetail('"+d.ADDRESS_4_SEGM_ID+"','"+d.SEGM_NAME+"','gu',0)\"";
                                }
                                str +=">"+d.GU_YX+"</td>" +
                                    "</tr>"
                                zhu += d.ZHU_HU_COUNT;
                                ren += d.PEOPLE_COUNT;
                                ying += (d.KD_YX+d.DX_YX+d.GU_YX);
                            })
                            yingxiaotable.append(str);
                            $("#countlou_new").html(data.length);
                            $("#countzhu_new").html(zhu);
                            $("#countren_new").html(ren);
                            $("#countying_new").html("<u style='cursor: pointer' onclick=\"showBuildDetail('"+segm_id2+"','','',1,9)\">"+ying+"</u>");
                            $("#yingxiao_info_win_new").show();
                            $("#yingxiao_baocun").hide();
							/*yinming 2017年7月22日11:28:37 修改营销窗口end*/
                        })
                    }
					/*yinming 2017年7月22日14:51:59 营销联动 end*/

					setBuildCity=function(){
					    $.post(url4Query,{eaction:'b_city'},function (data) {
							data=$.parseJSON(data)
						    var e = $("#b_city");

							e.on("change",function(){
								var id = e.find(":selected").val()
								$("#b_area").html(baseFullOption)
								$("#b_street").html(baseFullOption)
								//联动
								if(id!=''){
									setBuildArea(id)
								}
							})
							var str=''
 							$.each(data,function(i,obj){
								str+="<option value='"+obj.LATN_ID+"'>"+obj.LATN_NAME+"</option>"
							})
							e.append(str)

							e.find("option[value="+city_id+"]").attr("selected","selected")
							setBuildArea(city_id)
					    })
					}

					setBuildArea=function(id){
						var e=$("#b_area");
						$.post(url4Query,{eaction:'b_area',id:id},function (data) {
							data=$.parseJSON(data)
							e.html(baseFullOption)
							e.on("change",function(){
								var id = e.find(":selected").val()
								$("#b_street").html(baseFullOption)
								//联动
								if(id!=''){
									setBuildStreet(id)
								}
							})
							var str=''
							$.each(data,function(i,obj){
								str+="<option value='"+obj.REGION_NO+"'>"+obj.REGION_NAME+"</option>"
							})
							e.append(str)
						})

					}
					setBuildStreet=function(id){
						var e=$("#b_street");
						$.post(url4Query,{eaction:'b_street',id:id},function (data) {
							data=$.parseJSON(data)
							e.html(baseFullOption)
							e.on("change",function(){
								//联动
							})
							var str=''
							$.each(data,function(i,obj){
								str+="<option value='"+obj.STREET_NO+"'>"+obj.STREET_NAME+"</option>"
							})
							e.append(str)
						})
					}

					$("#build_query").on('click',function(){
						queryBuild('')
					})
					function queryBuild(latn_id){
						if(latn_id=='') {
							latn_id = $("#b_city option:selected").val()
						}
						var region_id = $("#b_area option:selected").val()
						var street_id = $("#b_street option:selected").val()
						var build_list= $("#build_table");
						build_list.html('')
						var build_name=$("#b_build_name").val()
						$.post(url4Query,{eaction:'build_list',region_id:region_id,build_name:build_name,latn_id:latn_id==947?937:latn_id,street_id:street_id},function (data) {
							var d=$.parseJSON(data)
							var str=''
							$.each(d,function (i, obj) {
								var name = obj.STAND_NAME
								var x =name
								var latn_name=obj.LATN_NAME
								var latn_id = obj.LATN_ID
								str+="<tr class=\"tr_default_background_color\" style='height:30px;cursor:pointer;font-size:14px' onclick=\"standard_position_load('"+obj.SEGM_ID+"','"+latn_name+"','"+latn_id+"',this)\"><td style='width: 14%;text-align: center'>"+ (i+1)+"</td><td style='width: 80%;text-align: left' title=\""+obj.STAND_NAME+"\">"+x+"</td></tr>"

							})
							var stan=24
							var len=$(parent.window).width()
							if(len<1900)
							{stan=12}
							if(d.length==0){
								str+="<tr class=\"tr_default_background_color\">没有查询到楼宇信息</tr>"
							}else if(d.length<=stan) {
								for (var i = 0; i < stan - d.length; i++) {
									str += "<tr class=\"tr_default_background_color\" style='height:30px' ><td style='width: 18%;text-align: center'></td><td style='width: 60%;text-align:center'></td></tr>";
								}
							}
							build_list.append(str)
						})
					}
					//楼宇结束

					dojo.query("#nav_range").onclick(function(evt) {
						$("#range_div").toggle();
						if($("#range_div").is(":visible"))
							$("#draw_div").hide();
					});
					// //去掉默认的contextmenu事件，否则会和右键事件同时出现。
					document.oncontextmenu = function(e){
						e.preventDefault();
					};
					document.onmousedown = function(e){
						e.stopPropagation();
						if(e.button==2){//鼠标右键事件，右键菜单，右键清除 退出绘制，右键结果窗口
							if($("#clear_draw_menu").is(":hidden")){
								if(draw_layer.visible){//如果可见，则可以清理
									$("#nav_marketing").removeClass("active");
									//map.setMapCursor("default");//绘制结束，还原鼠标
									$("#clear_draw_menu").show();
									if(draw_type=="village" && parent.villageObjectEdited.isOnMap == 1)//如果是小区绘制功能
										$("#delete_village").show();
									if(draw_finish)
										$("#pop_res_win_layer").show();
									$("#clear_draw_menu").css({left:e.x,top:e.y});
									$("#pop_res_win_layer").css({left:e.x,top:e.y+($("#clear_draw_menu").height())});
									$("#delete_village").css({left:e.x,top:e.y+($("#clear_draw_menu").height())});
								}
							}
							else{
								$("#clear_draw_menu").hide();
								$("#pop_res_win_layer").hide();
								$("#delete_village").hide();
							}
						}
					}
					$("#clear_draw_menu").click(function(e){
                        tuichu(e);
					});
                    tuichu = function(e){
                        e.stopPropagation();
                        e.preventDefault();
                        if(draw_layer.visible){
							$("#shezhi_content").hide()
							$("#marketing_div").hide();
							$(".tools_content li").css("background-color","transparent")
							$("#nav_marketing").removeClass("active")
							$("#village_draw_tool_div").hide();
                            dojo.disconnect(draw_layer_leida_click_handler);//停止雷达圈定功能
                            dojo.disconnect(draw_layer_leida_move_handler);//停止雷达圈定功能
                            draw_layer.clear();
                            draw_layer.hide();
                            draw_layer.visible = false;
                            reboundEvent();
                            draw_finish = false;
                            toolbar.deactivate();//停止绘图功能
                            map.setMapCursor("default");
                            //退出小区绘制，还原现场
                            graLayer_wg_for_village.clear();
                            graLayer_wg.show();//显示网格板块层
                            graLayer_wg_text.show();//显示网格名称层
                            graLayer_mouseclick.show();//显示支局的网格线

                            $(back_btn_hided).show();//显示返回按钮
                            $(".tools_n").show();//显示工具条
                            parent.showMapPosition();//显示地图右上方返回路径条
                        }
                        $("#clear_draw_menu").hide();
                        $("#pop_res_win_layer").hide();
                        $("#delete_village").hide();
                        $("#nameinput").hide();
                        $('#yingxiao_info_win').hide();
                        $('#yingxiao_info_win_new').hide();
                        tmp = "1";
                        $("#nav_list").removeClass("active");
                        tmp2 = "1";
                        $("#nav_grid").removeClass("active");
                        tmpx = '1';
                        $("#nav_village").removeClass("active");
                        tmpl = '1';
                        $("#nav_standard").removeClass("active");
                    }
					$("#pop_res_win_layer").click(function(e){
						e.stopPropagation();
						e.preventDefault();
						$("#clear_draw_menu").hide();
						$("#pop_res_win_layer").hide();
						$("#delete_village").hide();
						map.setMapCursor("default");
						layer.open({
							title: ['查询结果','line-height:30px;text-size:30px;height:30px;'],
							type: 1,
							shade: 0,
							area: ['55%','50%'],
//							skin: 'demo-class',
							left:'45%',
							content: $("#draw_result_container"),
							cancel: function(){//右上角关闭回调
								$("#draw_result_container").hide();
							}
						});
					});
					/*$("#delete_village").click(function(e){
						e.stopPropagation();
						e.preventDefault();
						$("#clear_draw_menu").hide();
						$("#pop_res_win_layer").hide();
						$("#delete_village").hide();
						parent.villageObjectEdited.isOnMap = 0;
						var village = parent.villageObjectEdited;
						layer.confirm("\""+village.name+"\"已上图,"+'您确定删除"'+village.name+'"在地图上的位置？', {
							btn: ['确定','取消'] //按钮
						}, function(){
							var eaction = "village_delete";
							$.post(url4Query,{eaction:eaction,village_id:village.id},function(){
								layer.msg('已删除', {icon: 1});
								parent.freshVillageDatagrid();
							});
						}, function(){
							draw_layer.clear();
						});
					});*/
                    click_dele = function(id,name){
                        $("#clear_draw_menu").hide();
                        $("#pop_res_win_layer").hide();
                        $("#delete_village").hide();
                        parent.villageObjectEdited.isOnMap = 0;
                        layer.confirm('确定移除小区【"'+name+'"】？', {
                            btn: ['确定','取消'] //按钮
                        }, function(){
                            var eaction = "village_delete";
                            $.post(url4Query,{eaction:eaction,village_id:id},function(){
                                layer.msg('已移除', {icon: 1});
                                parent.freshVillageDatagrid();

								village_load("RES_ID = '"+parent.global_report_to_id+"' AND STATUS = 1");
                            });
                        }, function(){
                            draw_layer.clear();
                        });
                    };
                    parent.click_dele=click_dele;
					var draw_type = "";
					dojo.query("#nav_draw").onclick(function(evt){
						draw_type = "polygon";
						$("#draw_div").toggle();
						if($("#draw_div").is(":visible"))
							$("#range_div").hide();
					});
					dojo.query("#draw_range_start").onclick(function(evt){
						var num = $("#draw_half").val();
					$('.tools_content').find('li').css('backgroundColor','transparent')
					$('#draw_range_start').css('backgroundColor','#051961')
						if(flag_set){
							$('#draw_set').css('backgroundColor','#051961')
						}else{
							$('#draw_set').css('backgroundColor','transparent')
						}
						if(isNaN(num)){
							layer.msg("请输入数字，不填内容时默认0.1");
							return;
						}
						if($.trim(num)=="")
							$$("#draw_half").val(100);
						draw_type = "leida";
						drawEnable(evt);

					});
					dojo.query("#draw_ellipse").onclick(function(evt){
						//drawEnable(evt, "circle");
						draw_type = "ellipse";
						drawEnable(evt);
					});
					dojo.query("#draw_circle").onclick(function(evt){
						//drawEnable(evt, "circle");
						draw_type = "circle";
						drawEnable(evt);
					});
					dojo.query("#draw_rectangle").onclick(function(evt){
						//drawEnable(evt, "circle");
						$('.tools_content').find('li').css('backgroundColor','transparent')
						$('#draw_rectangle').css('backgroundColor','#051961')
						if(flag_set){
							$('#draw_set').css('backgroundColor','#051961')
						}else{
							$('#draw_set').css('backgroundColor','transparent')
						}
						draw_type = "rectangle";
						drawEnable(evt);
					});
					dojo.query("#draw_polygon").onclick(function(evt){
						//drawEnable(evt, "circle");
						draw_type = "polygon";
						drawEnable(evt);
					});
					dojo.query("#draw_freehand_polygon").onclick(function(evt){
						//drawEnable(evt, "circle");
						draw_type = "freehand_polygon";
						drawEnable(evt);
					});

					var back_btn_hided = "";
					var draw_layer_leida_click_handler = "";
					var draw_layer_leida_move_handler = "";
					function drawEnable(evt){
						//隐藏无关的功能
						$("#range_div").hide();
						//$("#marketing_div").hide();

						/*//隐藏无关的按钮
						if($("#nav_fanhui_sub").is(':visible')){
							$("#nav_fanhui_sub").hide();//隐藏返回按钮
							back_btn_hided = "#nav_fanhui_sub";
						}
						else if($("#nav_fanhui_qx").is(':visible')){
							$("#nav_fanhui_qx").hide();//隐藏返回按钮
							back_btn_hided = "#nav_fanhui_qx";
						}

						$(".tools_n").hide();//隐藏左侧工具条*/
						//parent.hideMapPosition();//隐藏地图右上方返回路径条

						//先放大到楼宇级别，9级，只在框选功能中有效
						var zoom = map.getZoom();
						if(zoom<9 && draw_type != "village"){
							var point = map.center;
							map.centerAndZoom(point,9);
						}

						$("#nav_standard").addClass("active");

						$("#nav_marketing").addClass("active");
						map.setMapCursor("crosshair");
						map.infoWindow.hide();
						draw_layer.clear();
						draw_layer.show();
						killEvent();
						if(draw_layer_leida_click_handler!="")
							dojo.disconnect(draw_layer_leida_click_handler);
						/*if(draw_layer_leida_move_handler!="")
							dojo.disconnect(draw_layer_leida_move_handler);*/
						if(draw_type=="ellipse"){
							//esri.bundle.toolbars.draw.addPoint = "点击鼠标后拖拽，释放鼠标完成绘制";
							toolbar.activate(Draw.ELLIPSE);
						}
						else if(draw_type=="circle"){
							//esri.bundle.toolbars.draw.addPoint = "点击鼠标后拖拽，释放鼠标完成绘制";
							toolbar.activate(Draw.CIRCLE);
						}
						else if(draw_type=="rectangle"){
							//esri.bundle.toolbars.draw.addPoint = "点击鼠标后拖拽，释放鼠标完成绘制";
							toolbar.activate(Draw.RECTANGLE);
						}
						else if(draw_type=="polygon"){
							//esri.bundle.toolbars.draw.addPoint = "点击一次鼠标增加一个点，双击鼠标完成绘制";
							toolbar.activate(Draw.POLYGON);
						}
						else if(draw_type=="freehand_polygon"){
							//esri.bundle.toolbars.draw.addPoint = "点击鼠标后移动，自由绘制，释放鼠标完成绘制";
							toolbar.activate(Draw.FREEHAND_POLYGON);
						}
						else if(draw_type=="leida"){
							//toolbar.activate(Draw.POINT);
							//esri.bundle.toolbars.draw.addPoint = "鼠标点击的位置为辐射范围中心点，点击鼠标完成绘制";
							draw_layer_leida_click_handler = dojo.connect(map,"onClick",function(evt){
								draw_layer_leida_click_f(evt,$("#draw_half").val());
							});
							/*draw_layer_leida_move_handler = dojo.connect(map,"onMouseMove",function(evt){
								draw_layer_leida_move_f(evt);
							});*/
						}
						else if(draw_type == "village"){
							draw_layer_village_click_handler = dojo.connect(graLayer_wg_for_village,"onClick",function(evt){
								draw_layer_village_click_f(evt);
							});
						}
					}
					var circleSymb = new SimpleFillSymbol(
						SimpleFillSymbol.STYLE_SOLID,
						new SimpleLineSymbol(
								SimpleLineSymbol.STYLE_SHORTDASHDOTDOT,
								new Color([105, 105, 105]),
								2
						), new Color([255, 255, 0, 1])
					);
					draw_layer_leida_click_f = function(evt,num){
						//dojo.disconnect(draw_layer_leida_handler);
						circle = new Circle({
							center: evt.mapPoint,
							geodesic: false,
							radius: num/1000,
							radiusUnit: Units.KILOMETERS
						});
						draw_layer.clear();
						var graphic = new Graphic(circle, circleSymb);
						draw_layer.show();
						draw_layer.add(graphic);
						drawAddToMap(evt);
					};
					draw_layer_leida_move_f = function(evt){
						/*$("#leida_div").css("left",(evt.x-25) + "px");
						$("#leida_div").css("top",(evt.y-25) + "px");*/
					}
					draw_layer_village_click_f = function(evt){
						symbol = new SimpleMarkerSymbol();
						draw_layer.clear();
						var graphic = new Graphic(evt.geometry, symbol);
						draw_layer.show();
						draw_layer.add(graphic);
						drawAddToMap(evt);
					};
					var circleSymb = new SimpleFillSymbol(
							SimpleFillSymbol.STYLE_NULL,
							new SimpleLineSymbol(
									SimpleLineSymbol.STYLE_SHORTDASHDOTDOT,
									new Color([105, 105, 105]),
									2
							), new Color([255, 255, 0, 0.25])
					);
					var circle;

					// When the map is clicked create a buffer around the click point of the specified distance
					/*map.on("click", function(evt){
						circle = new Circle({
							center: evt.mapPoint,
							geodesic: true,
							radius: 1,
							radiusUnit: "esriMiles"
						});
						map.graphics.clear();
						var graphic = new Graphic(circle, circleSymb);
						draw_layer.show();
						draw_layer.add(graphic);

					});*/
					/*dojo.query("#nav_earse").onclick(function(evt){
						if(draw_layer.visible){
							$("#nav_marketing").removeClass("active");
							map.setMapCursor("default");//绘制结束，还原鼠标
							draw_layer.clear();
							draw_layer.hide();
					 		draw_layer.visible = false;
							reboundEvent();
						}
					});*/
					function killEvent(){
						dojo.disconnect(map_mouse_move_handler);

						dojo.disconnect(featureLayer_mouse_over_handler);
						dojo.disconnect(featureLayer_mouse_out_handler);
						dojo.disconnect(featureLayer_click_handler);

						dojo.disconnect(graLayer_zjname_mouse_over_handler);
						dojo.disconnect(graLayer_zjname_mouse_out_handler);
						dojo.disconnect(graLayer_zjname_click_handler);

						dojo.disconnect(graLayer_wg_mouse_over_handler);
						dojo.disconnect(graLayer_wg_mouse_out_handler);
						dojo.disconnect(graLayer_wg_click_handler);

						dojo.disconnect(graLayer_wg_text_mouse_over_handler);
						dojo.disconnect(graLayer_wg_text_mouse_out_handler);
						dojo.disconnect(graLayer_wg_text_click_handler);

						dojo.disconnect(graLayer_wd_mouse_over_handler);
						dojo.disconnect(graLayer_wd_mouse_out_handler);

						dojo.disconnect(standard_layer_mouse_over_handler);
						dojo.disconnect(standard_layer_mouse_out_handler);
						dojo.disconnect(standard_layer_click_handler);
					}
					function reboundEvent(){
						map_mouse_move_handler = dojo.connect(map,"onMouseOver",function(evt){
							map_mouse_move(evt);
						});

						featureLayer_mouse_over_handler = dojo.connect(featureLayer,"onMouseOver",function(evt){
							featureLayer_mouse_over(evt);
						});
						featureLayer_mouse_out_handler = dojo.connect(featureLayer,"onMouseOut",function(evt){
							featureLayer_mouse_out(evt);
						});
						featureLayer_click_handler = dojo.connect(featureLayer,"onClick",function(evt){
							featureLayer_click(evt);
						});

						graLayer_zjname_mouse_over_handler = dojo.connect(graLayer_zjname,"onMouseOver",function(evt){
							graLayer_zjname_mouse_over(evt);
						});
						graLayer_zjname_mouse_out_handler = dojo.connect(graLayer_zjname,"onMouseOut",function(evt){
							map.setMapCursor("default");
						});
						graLayer_zjname_click_handler = dojo.connect(graLayer_zjname,"onClick",function(evt){
							graLayer_zjname_click(evt);
						});

						graLayer_wg_mouse_over_handler = dojo.connect(graLayer_wg,"onMouseOver",function(evt){
							graLayer_wg_mouse_over(evt);
						});
						graLayer_wg_mouse_out_handler = dojo.connect(graLayer_wg,"onMouseOut",function(evt){
							graLayer_wg_mouse_out(evt);
						});
						graLayer_wg_click_handler = dojo.connect(graLayer_wg,"onClick",function(evt){
							graLayer_wg_click_f(evt);
						});

						graLayer_wg_text_mouse_over_handler = dojo.connect(graLayer_wg_text,"onMouseOver",function(evt){
							graLayer_wg_text_mouse_over(evt);
						});
						graLayer_wg_text_mouse_out_handler = dojo.connect(graLayer_wg_text,"onMouseOut",function(evt){
							graLayer_wg_text_mouse_out(evt);
						});
						graLayer_wg_text_click_handler = dojo.connect(graLayer_wg_text,"onClick",function(evt){
							graLayer_wg_text_click(evt);
						});

						graLayer_wd_mouse_over_handler = dojo.connect(graLayer_wd,"onMouseOver",function(evt){
							graLayer_wd_mouse_over(evt);
						});
						graLayer_wd_mouse_out_handler = dojo.connect(graLayer_wd,"onMouseOut",function(evt){
							graLayer_wd_mouse_out(evt);
						});

						standard_layer_mouse_over_handler = dojo.connect(standard_layer,"onMouseOver",function(evt){
							map.setMapCursor("pointer");
						});
						standard_layer_mouse_out_handler = dojo.connect(standard_layer,"onMouseOut",function(evt){
							map.setMapCursor("default");
							map.infoWindow.hide();
						});
						standard_layer_click_handler = dojo.connect(standard_layer,"onClick",function(evt){
							standard_layer_click(evt);
						});

						village_layer_click_handler = dojo.connect(village_layer,"onClick",function(evt){
							operateVillage(evt.graphic.attributes.village_id);
						});
					}
					//营销弹出end
					//直方图，暂不用
					$("#nav_chart").click(
						function(){
							if(chartIsShow){
								hideWINInfo();
							}else{
								showWINInfo();
							}
							$("#nav_chart").toggleClass("active");
							chartIsShow = !chartIsShow;
						}
					);
					//直方图，结束
					//热力图
					/*$("#nav_heatmap").click(
						function(){
							if(chartIsShow){
								hideHeatMap();
							}else{
								showHeatMap();
							}
							chartIsShow = !chartIsShow;
						}
					);*/

					//支局 id 字典
					var js_map = new Array();
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

					var standard_ico = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/build1.png" />';
					var village_ico = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/community.png" />';
					var village_ico_selected = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/community_selected.png" />';

					var tiled = new ArcGISTiledMapServiceLayer(layer_ds);
					map.addLayer(tiled);

					var featureLayer = new FeatureLayer(new_url_sub_vaild+sub_layer_index,{
						definitionExpression : "MAPID = "+map_id,
						mode: FeatureLayer.MODE_SNAPSHOT,
						//mode: FeatureLayer.MODE_ONDEMAND,
						outFields: ["*"],
						visible:true,
						opacity:1
					});
					//修改 楼宇点击切换地市定位问题 720 1159↓
					function changeMapToCity(city_name,latn_id){
						var full_name=city_name+"市";
						cityForLayer=cityNames[city_name+"市"];
						if(cityForLayer==null||cityForLayer==undefined){
							cityForLayer=cityNames[city_name+"州"];
							full_name=city_name+"州";
						}
						//支局图层服务地址
						if(latn_id == "932"){
							new_url_sub_vaild = new_url_sub_dx;
							new_url_grid_vaild = new_url_grid_dx;
							sub_layer_index = "/0";
						}else if(latn_id == "937"&&city_name.indexOf("嘉峪关")!=-1){
							new_url_sub_vaild = new_url_sub_jyg;
							new_url_grid_vaild = new_url_grid_jyg;
							sub_layer_index = "/0";
						}
						//全局变量修改
						city_id=latn_id;
						map_id = map_id_in_gis[city_id]
						var layer_ds = tiled_address_pre + cityForLayer + tiled_address_suf;
						parent.global_position[1]=city_name;
						parent.global_position[2]='';
						parent.global_position[3]='';
						parent.global_position[4]='';
						parent.global_current_full_area_name=full_name;
						parent.global_current_area_name=city_name
						//移除之前地市的地图图层
						map.removeLayer(tiled)
						//添加新地市的基础图层
						tiled = new ArcGISTiledMapServiceLayer(layer_ds);
						map.addLayer(tiled);
						//清空支局图层

					}
					//修改 楼宇点击切换地市定位问题 ↑

					//绘制所有支局的颜色
					var sub_dev = new Array();
					var sub_graphics_init = new Array();//存放所有支局的graphics
					var defaultSymbol = new SimpleFillSymbol().setStyle(SimpleFillSymbol.STYLE_NULL);
					defaultSymbol.outline.setStyle(SimpleLineSymbol.STYLE_NULL);
					var renderer = new UniqueValueRenderer(defaultSymbol, "SUBSTATION_NO");
					$.post(url4Query,{eaction:"getSubColorByLatnId",city_id:city_id,yesterday:'${yesterday.VAL}',last_month:'${lastMonth.VAL}'},function(data){
						data = $.parseJSON(data);
						for(var i = 0,l = data.length;i<l;i++){
							var d = data[i];
							sub_dev[d.UNION_ORG_CODE] = {bureau_name: d.BUREAU_NAME,branch_type:d.BRANCH_TYPE,grid_id_cnt:d.GRID_ID_CNT,grid_show: d.GRID_SHOW,mobile_mon_cum_new:d.MOBILE_MON_CUM_NEW,mobile_mon_cum_new_last: d.MOBILE_MON_CUM_NEW_LAST,cur_mon_bil_serv:d.CUR_MON_BIL_SERV,brd_mon_cum_new: d.BRD_MON_CUM_NEW,brd_mon_cum_new_last: d.BRD_MON_CUM_NEW_LAST,cur_mon_brd_serv: d.CUR_MON_BRD_SERV,itv_mon_new_install_serv: d.ITV_MON_NEW_INSTALL_SERV,itv_serv_cur_mon_new_last: d.ITV_SERV_CUR_MON_NEW_LAST,branch_hlzoom: d.BRANCH_HLZOOM,};
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

						//设置左侧列表内容
						$.post('<e:url value="querysubgrid.e"/>',{eaction:"getSubListByLatnId",city_id:city_id},function(data){
							data = $.parseJSON(data);
							var data1 = data[1];
							data = data[0];
							var sub_style_num = new Array();
							var sub_show_num = 0;
							var where_temp = "SUBSTATION_NO IN (";
							for(var i = 0,l = data.length;i<l;i++){
								var d = data[i];
								var str = "<tr class=\"tr_default_background_color\" style=\"color:"+(d.BRANCH_SHOW==0||d.FLAG!=1?'#f00':'#000')+"\" onclick=\"javascript:clickToSub('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',this,"+ d.ZOOM+")\" ><td style='width: 10%;text-align: center'>"+ (i+1)+"</td><td style='width: 22%;text-align: center'>"+ d.LATN_NAME+"</td><td style='width: 48%' title=\""+d.BRANCH_NAME+"\">"+ (d.BRANCH_NAME.length>7?d.BRANCH_NAME.substr(0,7)+"..":d.BRANCH_NAME)+d.GRID_NUM+"</td><td style='width: 20%;text-align: center'>"+ d.BRANCH_TYPE_CHAR+"</td></tr>";
								$(".list_table").append(str);
								where_temp += "'"+d.UNION_ORG_CODE+"'";
								if(i<l-1)
									where_temp += ",";
								if(sub_style_num[d.BRANCH_TYPE]==undefined)
									sub_style_num[d.BRANCH_TYPE] = 1;
								else
									sub_style_num[d.BRANCH_TYPE] += 1;
								sub_show_num += d.BRANCH_SHOW;
							}
							where_temp += ")";
							/*$("#ta").next("div").html("<table higth=\"100%\" width=\"296px\" style=\"text-align:center;color:#000;height:100%;border-color:#CCC;table-layout: fixed;font-size: 0.8em\">"
							+"<tr style=\"border-top:1px solid #CCC;background-color: #E3E3E3;font-size: 14px;height: 32px;line-height: 32px\"><th style=\"font-weight:bold\">类型</th><th style=\"font-weight:bold\">总数</th><th style=\"font-weight:bold\">上图</th><th style=\"font-weight:bold\">未上图</th></tr>"
							+"<tr style=\"border-top:1px solid #CCC\"><td style=\"height: 28px;line-height:28px\">支局</td><td style=\"\">"+data1.COUNT1+"</td><td style=\"\">"+(data1.COUNT1-data1.COUNT4)+"</td><td><font color=\"red\">"+data1.COUNT4+"</font></td></tr>"
							+"<tr style=\"border-top:1px solid #CCC\"><td style=\"height: 28px;line-height: 28px\">网格</td><td style=\"\">"+data1.COUNT5+"</td><td style=\"\">"+(data1.COUNT5-data1.COUNT6)+"</td><td><font color=\"#ff0000\">"+data1.COUNT6+"</font></td></tr></table>");*/
                            //$("#ta").next("div").html("共"+data1.COUNT1+"个支局，未上图<font color=\"red\">"+data1.COUNT4+"</font>个");
                            $("#tacount1").html(data1.COUNT1);
                            $("#tacount2").html(data1.COUNT4);
							featureLayer.setDefinitionExpression("MAPID = "+map_id + " AND "+where_temp);

							featureLayer.setRenderer(renderer);

							featureLayer.on("graphic-add",function(evt){
								var sub_gra_init = evt.graphic;
								var sub_attr = sub_gra_init.attributes;
								sub_graphics_init[sub_attr.SUBSTATION_NO] = sub_gra_init;
							});
						});
					});

					//var layer = new esri.layers.ArcGISDynamicMapServiceLayer(standard_address);
					//map.addLayer(layer);

					//标准地址
					var standard_layer = GraphicsLayer();

					var village_position_layer = GraphicsLayer();
					//小区图层
					var village_layer = GraphicsLayer();

					//绘制层，对标准地址操作
					var draw_layer = new GraphicsLayer();
					map.addLayer(draw_layer);
					draw_layer.hide();
					draw_layer.visible = false;

					var draw_finish = false;//绘制完成标记
					var drawAddToMap = function(evt){
						var done= false;
						var symbol;

						if(draw_type!="leida" && draw_type!="village"){
							switch (evt.geometry.type) {
								case "point":
									//console.log("暂无结果");
									break;
								case "multipoint":
									//console.log("暂无结果");
									symbol = new SimpleMarkerSymbol();
									break;
								case "polyline":
									//console.log("暂无结果");
									symbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,new Color(draw_line_color), 1);
									break;
								default://封闭多边形
									done = true;
									toolbar.deactivate();
									map.setMapCursor("default");//绘制结束，还原鼠标
									$("#nav_marketing").removeClass("active");
									symbol = new SimpleFillSymbol().setColor(new dojo.Color(draw_fill_color));
									symbol.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(draw_line_color), draw_line_width));
									var graphic = new Graphic(evt.geometry, symbol);//将绘制的图形写到draw_layer层
									draw_layer.add(graphic);
							}
						}
						else if(draw_type=="leida"){
							toolbar.deactivate();
							done = true;
							$("#leida_div").hide();
						}
						else if(draw_type=="village"){
							//toolbar.deactivate();
							var size = standard_point_get_size(map.getZoom());//获取当前放大级别下，标准地址图标的大小
							var img = new PictureMarkerSymbol(village_ico, size*3, size*3);
							var pointAttributes = parent.villageObjectEdited;
							var graphic = new esri.Graphic(evt.mapPoint,img,pointAttributes);
							draw_layer.add(graphic);
							
							//插入数据库
							var village = parent.villageObjectEdited;
							var question = "确定小区【"+village.name+"】上图？";
							var eaction = "village_insert";
							if(village.isOnMap==1){
								eaction = "village_update";
								question = "确定修改小区【"+village.name+"】到新的位置？";
							}
							layer.confirm(question, {
								btn: ['确定','取消'] //按钮
							}, function(){
								$.post(url4Query,{eaction:eaction,x:evt.mapPoint.x,y:evt.mapPoint.y,village_id:village.id,res_id:parent.global_report_to_id,grid_id:village.grid_id,sub_id:pointAttributes.sub_id,breau_id:pointAttributes.breau_id,city_id:pointAttributes.city_id},function(){
									layer.msg('上图成功', {icon: 1});
									//dojo.disconnect(draw_layer_leida_click_handler);//停止雷达圈定功能
									//dojo.disconnect(draw_layer_leida_move_handler);//停止雷达圈定功能
									draw_layer.clear();
									draw_layer.hide();
									draw_layer.visible = false;
									$("#village_draw_tool_div").hide();
									reboundEvent();
									draw_finish = false;
									toolbar.deactivate();//停止绘图功能
									//退出小区绘制，还原现场
									graLayer_wg_for_village.clear();
									graLayer_wg.show();//显示网格板块层
									graLayer_wg_text.show();//显示网格名称层
									graLayer_mouseclick.show();//显示支局的网格线

									$("#nav_fanhui_sub").show();//显示返回按钮
									$(".tools_n").show();//显示工具条
									parent.showMapPosition();//显示地图右上方返回路径条

									parent.freshVillageDatagrid();

									village_load("RES_ID = '"+parent.global_report_to_id+"' AND STATUS = 1");
								});
							}, function(){
								draw_layer.clear();
							});
						}
						if(done){
							var queryTask = new QueryTask(standard_address);
							var query = new Query();
							//query.where = "LATN_ID = "+ city_id + " AND CLASS3_ID IN ("+ class3_str +")";
							if(draw_type=="leida")
								query.geometry = draw_layer.graphics[0].geometry;
							else
								query.geometry = evt.geometry;
							console.log(query.geometry);
							if(query.geometry.center != null){//点选
                                type_xy = '0';
                                x=query.geometry.center.x;
                                y=query.geometry.center.y;
                                radius = query.geometry.radius;
							}else{//框选
                                type_xy = '1';
                                xmax=query.geometry.cache._extent.xmax;
                                xmin=query.geometry.cache._extent.xmin;
                                ymax=query.geometry.cache._extent.ymax;
                                ymin=query.geometry.cache._extent.ymin;
                            }
							query.outFields = ["*"];
							query.returnGeometry = true;
							queryTask.execute(query, function (results) {
								toolbar.deactivate();//成功绘制并正常执行查询后，停用工具
								var features = results.features;
								if(features.length==0){
									layer.msg("暂无查询结果");
									return;
								}
								draw_finish = true;//绘制成功且有结果
								/*$("#draw_result_total").html("共搜索到"+features.length+"个结果");
								$("#draw_result").children("table").empty();
								$("#draw_result").children("table").append("<div class='result_container'><div style='width: 15%;display: inline-block'>序号</div><div style='text-align: left;width: 55%;display: inline-block'>地址名称</div><div style='text-align: left;width: 30%;display: inline-block'>简称</div></div>");
								$("#draw_result_container").show();
								layer.open({
									title: ['查询结果','line-height:36px;height:36px;font-size:1.2em;'],
									type: 1,
									shade:0,
//									skin: 'demo-class',
									area: ['55%','50%'],
									left:'45%',
									content: $("#draw_result_container"),
									cancel: function(){//右上角关闭回调
										$("#draw_result_container").hide();
									},
								});
								$("#layui-layer1").css({left:'340px'})*/
								var result_li = "";
								var result_size = features.length;
								var channel_name_str = "";
								var channel_dev_array = new Array();
								segmid = "(";
								/*yinming 2017年7月22日11:28:37 修改营销窗口*/
								for(var i = 0;i<result_size;i++){
									var attrs = features[i].attributes;
									if(i!=0){
									    segmid+=",";
									}
									segmid += "'"+attrs.RESID+"'";
									//$("#draw_result").children("table").append("<tr style='border-bottom: 1px solid #120f4b;font-size:1.3em;padding-left: 20px;height: 28px;line-height: 28px;background-color: #040f54'><td style='width: 15%'>"+(i+1)+"</td><td style=\"text-align:left;width: 55% \">"+ attrs.RESFULLNAME+"</td><td style=\"text-align:left;width: 30%\">"+ attrs.RESNAME+"</td></tr>");
									//console.log(attrs);
									/*channel_name_str += "'"+attrs.CHANNEL_NA+"'";
									 if(i<result_size-1)
									 channel_name_str += ",";
									 channel_dev_array[attrs.CHANNEL_NA] = {"CHANNEL_NAME":attrs.CHANNEL_NA,"CLASS1_FIN":attrs.CHANNEL__1,"YD_CURRENT_DAY_DEV":"- -","KD_CURRENT_DAY_DEV":"- -","ITV_CURRENT_DAY_DEV":"- -","YD_CURRENT_MON_DEV":"- -","KD_CURRENT_MON_DEV":"- -","ITV_CURRENT_MON_DEV":"- -"};*/
								}
								segmid+=")";
								$.post(url4Query,{eaction:"yingxiao_list_2",segmid:segmid},function(data){
                                    data = $.parseJSON(data);
									var yingxiaotable = $(".yingxiao_win_table_b");
									yingxiaotable.html("");
									var str = "";
									var zhu = 0;
                                    var ren = 0;
                                    var ying = 0;
                                    var segm_id2 = "";
                                    $.each(data,function (i, d) {
                                        segm_id2 += d.SEGM_ID+".";
                                        str += "<tr>" +
											"<td width=\"8%\">"+(i+1)+"</td><td style='display:none'>"+d.SEGM_ID+"</td> " +
											"<td width=\"38%\" style=\"cursor: pointer;text-decoration: underline;color: blue;;text-align: left\" onclick=\"showBuildDetail('"+d.SEGM_ID+"','"+d.STAND_NAME+"','all',0)\">"+d.STAND_NAME+"</td> " +
											"<td width=\"10%\">"+d.ZHU_HU_COUNT+"</td>" +
											"<td width=\"10%\">";
                                        if(d.PEOPLE_COUNT==null){
                                            str +="-";
										}else{
                                            str +=d.PEOPLE_COUNT;
										}
                                        str +="</td>" +
											"<td class=\"\" width=\"10%\" " ;
                                        //不为0才能点击
										if(d.KD_YX_COUNT>0){
                                            str+="style=\"cursor: pointer\" onclick=\"showBuildDetail('"+d.SEGM_ID+"','"+d.STAND_NAME+"','kd',0)\"";
                                        }
                                        str +=">"+d.KD_YX_COUNT+"</td>" +
											"<td class=\"\" width=\"10%\" ";
                                        if(d.ITV_YX_COUNT>0){
                                            str+="style=\"cursor: pointer\" onclick=\"showBuildDetail('"+d.SEGM_ID+"','"+d.STAND_NAME+"','itv',0)\"";
                                        }
                                        str +=">"+d.ITV_YX_COUNT+"</td>" +
											"<td class=\"\" width=\"10%\" ";
                                        if(d.GU_YX_COUNT>0){
                                            str+="style=\"cursor: pointer\" onclick=\"showBuildDetail('"+d.SEGM_ID+"','"+d.STAND_NAME+"','gu',0)\"";
                                        }
                                        str +=">"+d.GU_YX_COUNT+"</td>" +
											"</tr>"
										zhu += d.ZHU_HU_COUNT;
                                        ren += d.PEOPLE_COUNT;
                                        ying += (d.KD_YX_COUNT+d.ITV_YX_COUNT+d.GU_YX_COUNT);
                                    })
                                    yingxiaotable.append(str);
									$("#countlou").html(data.length);
									$("#countzhu").html(zhu);
									$("#countren").html(ren);
									$("#countying").html("<u style='cursor: pointer' onclick=\"showBuildDetail('"+segm_id2+"','','',1)\">"+ying+"</u>");
									$("#yingxiao_info_win").show();
                                    $("#yingxiao_baocun").show();
                                    $("#yxspan").val("");
									/*yinming 2017年7月22日11:28:37 修改营销窗口end*/
								})

								/*$.post(url4query,{eaction:"index_get_by_channel_names",channel_names:channel_name_str,date:'${yesterday.VAL}',city_name:global_current_area_name},function(data) {
								 data = $.parseJSON(data);
								 for(var i = 0,l = data.length;i<l;i++){
								 var d = data[i];
								 var type = channel_dev_array[d.CHANNEL_NAME]["CLASS1_FIN"];
								 d["CLASS1_FIN"] = type;
								 channel_dev_array[d.CHANNEL_NAME] = d;
								 }
								 var keys = Object.keys(channel_dev_array);
								 for(var i = 0,l = keys.length;i<l;i++){
								 var d = channel_dev_array[keys[i]];
								 $("#draw_result").children("table").append("<tr style='border-bottom: 1px solid #120f4b;font-size:1.3em;padding-left: 20px;height: 28px;line-height: 28px;'><td style='width: 10%'>"+(i+1)+"</td><td style=\"text-align:left;width: 25% \">"+ d.CHANNEL_NAME+"</td><td style=\"text-align:left;width: 25%\">"+ d.CLASS1_FIN+"</td><td style='width: 15%;'>"+(d.YD_CURRENT_DAY_DEV)+"</td><td style='width: 15%;'>"+d.KD_CURRENT_DAY_DEV+"</td><td style='width: 10%;'>"+d.ITV_CURRENT_DAY_DEV+"</td></tr>");
								 }
								 });*/
							},function(error){
								layer.msg("图形不合法，无法分析结果");
							});
						}
					}

					/*yinming 2017年7月22日15:53:42 营销保存按按钮*/
                    $("#yingxiao_baocun").click(function () {
                        $("#nameinput").show();
                        $("#yxspan").html("");
                        $("#yxname").val("");
                    })
                    $("#OK").click(function () {
                        var name = $.trim($("#yxname").val());
                        if(name.length==0){
                            $("#yxspan").html("请输入名称");
						}else if(name.length<16){
                            $.post(url4Query,{eaction:"yingxiao_add_1",name:name,segmid:segmid,type_xy:type_xy,x:x,y:y,radius:radius,xmax:xmax,xmin:xmin,ymax:ymax,ymin:ymin},function(data){
                                $("#nameinput").hide();
                                $('#yingxiao_info_win').hide();
                                $('#yingxiao_info_win_new').hide();
                                layer.msg("保存成功");
                            })
						}else{
                            $("#yxspan").html("请输入15个字以内的名称");
						}

                    })
					/*yinming 2017年7月22日15:53:42 营销保存按按钮 end*/

					var toolbar;//工具栏，放置绘图工具

					//支局名称层
					var graLayer_zjname = new GraphicsLayer();

					//支局的鼠标点击层
					var graLayer_zj_click = new GraphicsLayer();

					//网格的鼠标点击层
					var graLayer_wg_click = new GraphicsLayer();

					var grid_name_temp_layer = new GraphicsLayer();
					map.addLayer(grid_name_temp_layer);
					grid_name_temp_layer.hide();

					/*var featureLayer_grid = new FeatureLayer(new_url_grid_vaild+grid_layer_index,{
						definitionExpression : "MAPID = "+map_id,
						mode: FeatureLayer.MODE_SNAPSHOT,
						//mode: FeatureLayer.MODE_ONDEMAND,
						outFields: ["*"],
						visible:true,
						opacity:1
					});
					var defaultSymbol_grid = new SimpleFillSymbol().setStyle(SimpleFillSymbol.STYLE_NULL).setOutline(new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([128,128,128]), 1.5));
					var renderer_grid = new SimpleRenderer(defaultSymbol_grid);
					featureLayer_grid.setRenderer(renderer_grid);*/

					var font = new esri.symbol.Font("12px", esri.symbol.Font.WEIGHT_NORMAL, esri.symbol.Font.WEIGHT_NORMAL,esri.symbol.Font.WEIGHT_NORMAL);
					font.setFamily("微软雅黑");

					/*featureLayer_grid.on("graphic-add",function(evt){
						var grid_gra = evt.graphic;
						var grid_attr = grid_gra.attributes;

						var geo = grid_gra.geometry;
						var temp=geo.rings;

						var grid_name = grid_attr.REPORTTO;
						if($.trim(grid_name)=="")
							grid_name = grid_attr.RESNAME;
						grid_name = grid_name.substr(grid_name.indexOf("-")+1);

						var textSymbol = new esri.symbol.TextSymbol(grid_name, font, new esri.Color([50,50,250]));//feature.attributes.REPORTTO
						//textSymbol.setHaloColor(new esri.Color([255, 0, 0]));
						//textSymbol.setHaloSize(10);
						var name_point = getGravityCenter(geo,temp);

						var labelGraphic = new esri.Graphic(name_point, textSymbol);
						/!*var grid_geo_attr = new Array();
						grid_geo_attr["grid_geo"] = geo;
						grid_geo_attr["grid_attr"] = feature.attributes;
						grid_geo_attr["grid_fill_gra"] = graphic;
						labelGraphic.setAttributes(grid_geo_attr);*!/
						grid_name_temp_layer.add(labelGraphic);
					});

					map.addLayer(featureLayer_grid);
					featureLayer_grid.hide();*/
					map.addLayer(featureLayer);

					//鼠标悬浮到支局，突出显示鼠标下的支局
					var graLayer_sub_mouseover = new GraphicsLayer();
					map.addLayer(graLayer_sub_mouseover);

					//勾选所有区县轮廓的层
					var graLayer_qx_all = new GraphicsLayer();
					map.addLayer(graLayer_qx_all);

					//勾选选定的区县边框
					var graLayer_qx = new GraphicsLayer();
					map.addLayer(graLayer_qx);

					//支局选中边框层
					map.addLayer(graLayer_zj_click);

					//鼠标点击支局，突出显示支局渔网背景
					var graLayer_mouseclick = new GraphicsLayer();

					//graLayer_mouseclick.setOpacity(0.25);

					var graLayer_subname_result = new GraphicsLayer();
					map.addLayer(graLayer_subname_result);

					//网格填充层
					var graLayer_wg = new GraphicsLayer();
					map.addLayer(graLayer_wg);
					graLayer_wg.hide();

					//绘制小区的时候，网格的参考范围
					var graLayer_wg_for_village = new GraphicsLayer();
					map.addLayer(graLayer_wg_for_village);

					//网格层鼠标悬浮层
					var graLayer_grid_mouseover = new GraphicsLayer();
					map.addLayer(graLayer_grid_mouseover);
					//网格名称层
					var graLayer_wg_text = new GraphicsLayer();
					map.addLayer(graLayer_wg_text);
					graLayer_wg_text.hide();

					//渠道网点展示
					var graLayer_wd = new GraphicsLayer();
					graLayer_wd.hide();
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
					/*var featureLayer_grid_show_hide = function(current_zoom){
						if(current_zoom>4 && current_zoom<9){
							featureLayer_grid.show();
							grid_name_temp_layer.show();
						}
						else{
							featureLayer_grid.hide();
							grid_name_temp_layer.hide();
						}
					}*/
					//支局名称层刷新
					var zj_name_show_hide = function(current_zoom){
						graLayer_zjname.clear();
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
					var wg_name_show_hide = function(current_zoom){
						graLayer_wg_text.clear();
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
					var fontSizeChange = function(current_zoom){
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

					var getLayerOpacity = function(current_zoom){
						var opacity = 0;
						if(current_zoom>7)
							opacity = 0.2;
						else if(current_zoom>6)
							opacity = 0.4;
						else if(current_zoom == 6 || current_zoom == 5)
							opacity = 0.7;
						else if(current_zoom<5)
							opacity = 1;
						return opacity;
					}
					//根据地图放大缩小级别设定图层透明度
					var layerOpacityChange = function(current_zoom){
						var opacity = 1;
						if(city_id=='947'){
							if(current_zoom>=9){
								standard_load();
								opacity = 0.0;
							}
							else if(current_zoom==8)
								opacity = 0.3;
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
							if(current_zoom>=9){
								standard_load();
								opacity = 0.0;
							}
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

						featureLayer.setOpacity(opacity);
						graLayer_wg.setOpacity(opacity);
					}

					//渠道网点的图标大小控制
					var channel_point_get_size = function(current_zoom){
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
					var channel_point_resize = function(current_zoom){
						var size = channel_point_get_size(current_zoom);
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
					//标准地址的图标大小控制
					var standard_point_get_size = function(current_zoom){
						var size = 10;
						if(current_zoom==9){
							size = 10;
						}else if(current_zoom==10){
							size = 14;
						}else if(current_zoom>10){
							size = 17;
						}
						return size;
					}
					var standard_point_resize = function(current_zoom){
						var size = standard_point_get_size(current_zoom);
						var gs = standard_layer.graphics;
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
						standard_layer.clear();
						for(var i = 0,l = gs_new.length;i<l;i++){
							var pointAttributes = attr_new[i];//{address:'101',city:'Portland',state:'Oregon'};
							var img = new PictureMarkerSymbol(gs_new[i].url, gs_new[i].width, gs_new[i].height);
							var graphic = new esri.Graphic(geo_new[i],img,pointAttributes);
							standard_layer.add(graphic);
						}
					}

					//响应左侧列表每行的点击事件
					var sub_gra_last = "";//最后一次点击的支局
					var grid_gra_last = "";//最后一次点击的网格
					clickToSub = function(substation,sub_name,thiz,zoom){
						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").hide();
						$("#nav_fanhui_city").hide();
						$("#nav_fanhui_qx").show();
						$("#nav_fanhui_sub").hide();
						graLayer_subname_result.clear();
						graLayer_mouseclick.clear();
						graLayer_grid_mouseover.clear();
						graLayer_sub_mouseover.clear();

						village_layer.clear();
						village_position_layer.clear();

						$(thiz).siblings().removeClass("tr_click_background_color");//background-color: #c1c1c1;
                        $(thiz).siblings().addClass("tr_default_background_color");
                        $(thiz).removeClass("tr_default_background_color");
                        $(thiz).addClass("tr_click_background_color");
						featureLayer.show();//显示全部支局的层
						graLayer_zjname.show();//显示支局名称层
						graLayer_zj_click.clear();
						graLayer_wg_click.clear();
						graLayer_wg.hide();
						graLayer_wg_text.hide();

						parent.global_current_flag = 4;
						parent.global_current_full_area_name = sub_name;
						parent.global_current_area_name = sub_name;
						parent.global_substation = substation;
						parent.freshIndexContainer(indexContainer_url_sub);

						//设置所点支局归属的区县的范围轮廓线
						drawQXLine(substation,sub_name);

						//此次点击的支局
						var sub_gra_last_temp = sub_graphics_init[substation];
						if(sub_gra_last_temp==undefined || sub_gra_last_temp==""){
							layer.msg(sub_name+"暂未上图",{time:2000});
							return;
						}else{
							subFillRecover_click();//还原上次点击过的支局
							beforeClickColor_sub = beforeMouseOverColor_sub;
							sub_gra_clicked = sub_gra_last_temp;

							var sub_selected_geometry = sub_gra_clicked.geometry;
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

							var graphics = new esri.Graphic(sub_selected_geometry, linesymbol_sub_selected);
							graLayer_zj_click.add(graphics);
							try{
								var zoom = map.getZoom();
								currentOpacity = getLayerOpacity(zoom);
								sub_gra_clicked.setSymbol(highlightSymbol_sub_click);
							}catch(e){

							}

						}
					}
					var grid_selected_id = "";
					//左侧列表，网格定位
					clickToGrid = function(substation,sub_name,thiz,zoom,grid_name,station_id){
						clickToGrid_function(substation,sub_name,thiz,zoom,grid_name,station_id);
						village_load("RES_ID = '"+station_id+"' AND STATUS = 1");
					}
					clickToGridAndPositionVillage = function(substation,sub_name,thiz,zoom,grid_name,station_id,village_id){
						clickToGrid_function(substation,sub_name,thiz,zoom,grid_name,station_id);
						village_load("RES_ID = '"+station_id+"' AND STATUS = 1",village_id);
					}
					function clickToGrid_function(substation,sub_name,thiz,zoom,grid_name,station_id){
						grid_selected_id = station_id;
						$(thiz).siblings().removeClass("tr_click_background_color");//background-color: #c1c1c1;
						$(thiz).siblings().addClass("tr_default_background_color");
						$(thiz).removeClass("tr_default_background_color");
						$(thiz).addClass("tr_click_background_color");
						//var grid_id_temp = 左侧列表传递过来的resid;
						subToGridFlag = true;

						gridFillRecover_click();

						village_position_layer.clear();
						if(parent.global_substation == substation && subToGridFlag){//点击同一个支局中其他网格
							//高亮当前支局中另一个网格
							graLayer_wg.redraw();

							try{
								var graphics = grid_graphics_init[station_id];

								graLayer_wg_click.clear();
								var geo = graphics.geometry;
								var gra = new esri.Graphic(geo, linesymbol_grid_selected);
								graLayer_wg_click.add(gra);

								grid_gra_last = "";
								grid_gra_clicked = graphics;
								beforeClickColor_grid=graphics._shape.fillStyle;
								//var zoom = map.getZoom();
								currentOpacity = beforeClickColor_grid.a;
								highlightSymbol_grid_click.color.a = currentOpacity;
								graphics.setSymbol(highlightSymbol_grid_click);
								if(zoom<0)
									map.setExtent(sub_selected_ext.expand(1.5));
								else
									map.centerAndZoom(getGravityCenter(geo,geo.rings),zoom);
								//map.setExtent(geo.getExtent().expand(grid_zoom));
							}catch(e){

							}

							parent.global_current_flag = 5;
							parent.global_current_area_name = grid_name;
							parent.global_current_full_area_name = grid_name;
							parent.global_position.splice(4, 1, grid_name);
							parent.global_substation = substation;
							parent.global_report_to_id = station_id;
							//console.log(sub_gra_last_temp.attributes.REPORT_TO_ID);
							parent.freshIndexContainer(indexContainer_url_grid);
							parent.updatePosition(5);

							return;
						}
						parent.global_substation = substation;
						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").hide();
						$("#nav_fanhui_city").hide();
						$("#nav_fanhui_qx").show();
						$("#nav_fanhui_sub").hide();
						graLayer_subname_result.clear();
						graLayer_mouseclick.clear();
						graLayer_grid_mouseover.clear();
						graLayer_sub_mouseover.clear();

						featureLayer.show();//显示全部支局的层
						graLayer_zjname.show();//显示支局名称层
						graLayer_zj_click.clear();
						graLayer_wg_click.clear();
						graLayer_wg.hide();
						graLayer_wg_text.hide();

						//设置所点支局归属的区县的范围轮廓线
						drawQXLine(substation,sub_name);

						//subFillRecover_mouseover();
						subFillRecover_click();//还原上次点击过的支局

						//此次点击的支局
						var sub_gra_last_temp = sub_graphics_init[substation];
						var sub_selected_geometry = null;
						if(sub_gra_last_temp==undefined || sub_gra_last_temp==""){
							layer.msg(sub_name+"暂未上图",{time:2000});
							return;
						}else{
							sub_gra_last = sub_gra_last_temp;
							sub_gra_clicked = sub_gra_last;
							beforeClickColor_sub = beforeMouseOverColor_sub;

							sub_selected_geometry = sub_gra_last.geometry;
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

							try{
								beforeMouseOverColor_sub=sub_gra_last._shape.fillStyle;
							}catch(e){

							}
							var zoom = map.getZoom();
							currentOpacity = getLayerOpacity(zoom);
							sub_gra_last.setSymbol(highlightSymbol_sub_click);
							subToGrid_toGrid(sub_gra_last_temp,sub_selected_geometry,sub_gra_last_temp.attributes,station_id,grid_name,false);
						}
					}
					//右侧支局联动，网格列表点击定位
					clickToGridFromSub = function(substation,sub_name,zoom,grid_name,station_id){
						//var grid_id_temp = 左侧列表传递过来的resid;
						subToGridFlag = true;

						gridFillRecover_click();

						//点击同一个支局中其他网格
						if(parent.global_substation == substation && subToGridFlag){
							//高亮当前支局中另一个网格
							graLayer_wg.redraw();

							try{
								var graphics = grid_graphics_init[station_id];
								graLayer_wg_click.clear();
								var geo = graphics.geometry;
								var gra = new esri.Graphic(geo, linesymbol_grid_selected);
								graLayer_wg_click.add(gra);
								map.centerAndZoom(getGravityCenter(geo,geo.rings),map.getZoom());

								beforeClickColor_grid=graphics._shape.fillStyle;
								//var zoom = map.getZoom();
								currentOpacity = beforeClickColor_grid.a;
								highlightSymbol_grid_click.color.a = currentOpacity;
								graphics.setSymbol(highlightSymbol_grid_click);
							}catch(e){

							}

							village_load("RES_ID = '"+station_id+"' AND STATUS = 1");
							parent.global_current_flag = 5;
							parent.global_current_area_name = grid_name;
							parent.global_current_full_area_name = grid_name;
							parent.global_position.splice(4, 1, grid_name);
							parent.global_substation = substation;
							parent.global_report_to_id = station_id;
							//console.log(sub_gra_last_temp.attributes.REPORT_TO_ID);
							parent.freshIndexContainer(indexContainer_url_grid);
							parent.updatePosition(5);
							return;
						}
						//点了不同的支局
						parent.global_substation = substation;
						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").hide();
						$("#nav_fanhui_city").hide();
						$("#nav_fanhui_qx").show();
						$("#nav_fanhui_sub").hide();
						graLayer_subname_result.clear();
						graLayer_mouseclick.clear();
						graLayer_grid_mouseover.clear();
						graLayer_sub_mouseover.clear();

						featureLayer.show();//显示全部支局的层
						graLayer_zjname.show();//显示支局名称层
						graLayer_zj_click.clear();
						graLayer_wg_click.clear();
						graLayer_wg.hide();
						graLayer_wg_text.hide();

						//设置所点支局归属的区县的范围轮廓线
						drawQXLine(substation,sub_name);

						subFillRecover_click();

						//此次点击的支局
						var sub_gra_last_temp = sub_graphics_init[substation];
						var sub_selected_geometry = null;
						if(sub_gra_last_temp==undefined || sub_gra_last_temp==""){
							layer.msg(sub_name+"暂未上图",{time:2000});
							return;
						}else{
							sub_gra_last = sub_gra_last_temp;
							sub_gra_clicked = sub_gra_last;
							sub_selected_geometry = sub_gra_last.geometry;
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

							try{
								beforeMouseOverColor_sub=sub_gra_last._shape.fillStyle;
							}catch(e){

							}
							var zoom = map.getZoom();
							currentOpacity = getLayerOpacity(zoom);
							sub_gra_last.setSymbol(highlightSymbol_sub_click);
							subToGrid_toGrid(sub_gra_last_temp,sub_selected_geometry,sub_gra_last_temp.attributes,station_id,grid_name,true);
							village_load("RES_ID = '"+station_id+"' AND STATUS = 1");
						}
					}
                    parent.clickToGridFromSub=clickToGridFromSub;

					//处理地图视野改变事件，拖拽、滚轮、聚焦
					map.on("extent-change", function(evt){
						if(chartIsShow){
							showWINInfo();
						}
						var mapZoom = map.getZoom();
						console.log("mapZoom:"+mapZoom);

						/*if(mapZoom>6){
							 village_layer.clear();
							 village_load("CITY_ID = "+city_id+" AND STATUS = 1");
						}else{
							 village_layer.clear();
							 village_layer.hide();
						}*/
						var qx_line_and_text = graLayer_qx_all.graphics;
						if(mapZoom>=3){
							for(var i = 0,l = qx_line_and_text.length;i<l;i++){
								var lt = qx_line_and_text[i];
								if(lt.symbol.type == "textsymbol"){
									lt.symbol.color.a = 0;
								}
							}
						}else{
							for(var i = 0,l = qx_line_and_text.length;i<l;i++){
								var lt = qx_line_and_text[i];
								if(lt.symbol.type == "textsymbol"){
									lt.symbol.color.a = 1;
								}
							}
						}

						if(mapZoom<9){
							standard_layer.clear();
							position_layer.clear();
						}else{
							standard_load();
							standard_point_resize(mapZoom);
						}
						///featureLayer_grid_show_hide(mapZoom);
						//地图缩放的时候zoom大，地图放大的时候zoom小
						zj_name_show_hide(mapZoom);
						wg_name_show_hide(mapZoom);
						layerOpacityChange(mapZoom);
						graLayer_zjname.redraw();
						graLayer_wg_text.redraw();
						channel_point_resize(mapZoom);
					});

					//描边所有区县的轮廓 qx_nameList_new qx_nameList_all:{city_name:area_name}
					$.post(url4Query,{"eaction":"qx_nameList_new","city_id": city_id}, function (data) {
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
								var k = results.features.length;
								if (k == 0)//没有对应区县地图数据
									return;

								for(var j = 0;j<k;j++){
									var geometry = results.features[j].geometry;
									qx_geometry = geometry;
									back_to_ext = geometry;
//									var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_all_line_color), 1.5);
									var graphics = new esri.Graphic(geometry, linesymbol_qx_all_line);
									graLayer_qx_all.add(graphics);
									var textSymbol = new esri.symbol.TextSymbol(results.features[j].attributes["NAME"], font_qx_text, new esri.Color(qx_text_color));//feature.attributes.REPORTTO
									/*textSymbol.setDecoration(TextSymbol.DECORATION_UNDERLINE);
									textSymbol.setDecoration(TextSymbol.DECORATION_OVERLINE);*/
									var labelGraphic = new esri.Graphic(geometry, textSymbol);
									graLayer_qx_all.add(labelGraphic);
								}
							});
						}
					});
					//查询开始
					//var queryTask = new QueryTask(layer_ds + "/112");
					//加载底图，并画出区县范围的边线（除了嘉峪关以外）
					/*var queryTask_tile = new QueryTask(layer_ds + "/" + city_gis_tiled_layerids[city_name]);
					var query_tile = new Query();
					query_tile.where = "NAME = '" + area_name + "'";//某区县名
					query_tile.returnGeometry = true;
					var qx_geometry = "";//所展示区县范围的图形对象
					if(city_id==947){//嘉峪关特殊处理地图初始放大级别及中心点
						map.centerAndZoom(new esri.geometry.Point(98.28700964379297,39.7848151118973, new esri.SpatialReference(4326)), 5);
					}
					else{
						queryTask_tile.execute(query_tile, function (results) {
							//指定范围的结果
							var feature = results.features;
							var l = feature.length;
							for(var i = 0;i<l;i++){
								//显示圈定范围的业务图层
								var geometry = feature[i].geometry;
								qx_geometry = geometry;
								var graphics = new esri.Graphic(qx_geometry, linesymbol_qx_selected);
								graLayer_qx.add(graphics);
							}
							if(l==1){
								//区县级别的下钻视野聚焦调整
								var ext = qx_geometry.getExtent();
								/!*var reg=new RegExp("区$");
								 if(reg.test(city_name)) //区一级地图放大点
									map.setExtent(ext.expand(0.4));
								 else					//县一级地图缩小点
									map.setExtent(ext.expand(0.8));*!/
								map.setExtent(ext);
							}
						});
					}*/

					//直方图开始
					featureLayer.on("update-end", function (evt) {
						/*var arrs=new Array();
						array.forEach(featureLayer.graphics, function (graphic) {
							var labelPt =getGravityCenter(graphic.geometry,graphic.geometry.rings);
							arrs.push({"charname":graphic.attributes.RESNAME,"x":labelPt.x,"y":labelPt.y,"val1":Math.floor(Math.random()*40),"val2":Math.floor(Math.random()*60),"val3":Math.floor(Math.random()*80)});
						});
						var temp=$.toJSON(arrs);
						var temps = eval('(' + temp + ')');
						var showFields = ["val1", "val2", "val3"];
						createChartInfoWindow(temps, showFields);
						hideWINInfo();*/
					});
					//直方图结束

					map.on("mouse-drag-start",function(){

						hideWINInfo();
					});
					map.on("mouse-drag-end",function(){

						if(chartIsShow){
							showWINInfo();
						}
					});
					map.on("mouse-wheel",function(){

						hideWINInfo();
					});
					var labelPrt_array = new Array();
					var infoWindow2s = new Array();
					function createChartInfoWindow(temps, showFields) {
						var max = -100000;
						$.each(temps, function(index, obj) {
							for (var i = 0, j = showFields.length; i < j; i++) {
								if (max < obj[showFields[i]]) {
									max = obj[showFields[i]];
								}
							}
						});

						try {
							var optinalChart = null;

							$.each(temps, function(index, obj) {
								var  infoWindow2 = new ChartInfoWindow({
									domNode : domConstruct.create('div', null, document
											.getElementById('gismap'))
								});
								infoWindow2.setMap(map);
								var nodeChart = null;
								nodeChart = domConstruct.create("div", {
									id : 'nodeTest' + index,
									style : "width:20px;height:40px"
								}, win.body());

								var chart = makeChart(nodeChart, obj, showFields, max);
								optinalChart = chart;
								infoWindow2.resize(50, 101);
								var labelPt = new esri.geometry.Point(obj.x, obj.y,
										map.spatialReference);

								infoWindow2.setContent(nodeChart);
								infoWindow2.__mcoords = labelPt;
								labelPrt_array.push(labelPt);
								infoWindow2.show(map.toScreen(labelPt));
								infoWindow2s.push(infoWindow2);
							});
						} catch (ex) {
						}
					}
					function makeChart(node, attributes, showFields, max) {
						var chart = new Chart(node, { margins: { l: 0, r: 0, t: 0, b: 0 } }).
								setTheme(CustomTheme).
								addPlot("default", { type: "Columns", gap: 0 });
						var serieValues = [];
						var length = showFields.length;
						for (var i = 0; i < length; i++) {
							serieValues = [];
							for (var m = 0; m < i; m++) {
								serieValues.push(0);
							}

							serieValues.push(attributes[showFields[i]]);
							chart.addSeries(showFields[i], serieValues, { stroke: { color: "black" } });
						}

						serieValues = [];
						for (var k = 0; k < length; k++) {
							serieValues.push(0);
						}
						serieValues.push(max);
						chart.addSeries("隐藏", serieValues, { stroke: { color: new Color([0x3b, 0x44, 0x4b, 0]) }, fill: "transparent" });

						var anim1 = new Highlight(chart, "default", {
							highlight: function (e) {
								if (e.a == 0 && e.r == 0 && e.g == 0 && e.b == 0) {
								}
								else {
									return "lightskyblue";
								}
							}
						});
						var anim2 = new Tooltip(chart, "default", {
							text: function (o) {
								var fieldName = o.chart.series[o.index].name;
								if (fieldName == "隐藏") return "";
								return (fieldName + "：" + o.y);
							}
						});
						chart.render();

						return chart;
					}
					var chartIsShow = false;
					function hideWINInfo(){
						for(var i=0;i<infoWindow2s.length;i++){
							infoWindow2s[i].hide();
						}
					}
					function showWINInfo(){
						for(var i=0;i<infoWindow2s.length;i++){
							infoWindow2s[i].show(labelPrt_array[i]);
						}
					}

					var showSubInfoWin = function(graphic,attrs){
						/*map.infoWindow.setTitle("支局信息");
						map.infoWindow.resize(260,200);*/

						subFillRecover_mouseover();

						if(sub_gra_clicked!=""){
							if(sub_gra_clicked.attributes["SUBSTATION_NO"] == graphic.attributes["SUBSTATION_NO"]){
								//颜色不做操作
							}else{
								sub_gra_last = graphic;
								beforeMouseOverColor_sub=sub_gra_last._shape.fillStyle;

								//设置高亮显示
								var zoom = map.getZoom();
								currentOpacity = getLayerOpacity(zoom);
								graphic.setSymbol(highlightSymbol_sub_mouse_over);
							}
						}else{
							sub_gra_last = graphic;
							beforeMouseOverColor_sub=sub_gra_last._shape.fillStyle;

							//设置高亮显示
							var zoom = map.getZoom();
							currentOpacity = getLayerOpacity(zoom);
							graphic.setSymbol(highlightSymbol_sub_mouse_over);
						}

						var attr = sub_dev[attrs["SUBSTATION_NO"]];//attrs["sub_dev"];
						var ems = $("#sub_info_win").find("em");
						$(ems[0]).html(sub_data[attrs["SUBSTATION_NO"]]);

						$(ems[1]).html(attr["bureau_name"]);
						$(ems[2]).html(attr["grid_id_cnt"]);
						var grid_hide = attr["grid_show"];
						if(grid_hide==0){
							$(ems[3]).prev().hide();
							$(ems[3]).hide();
							$(ems[3]).next().hide();
						}else{
							$(ems[3]).html(grid_hide);
							$(ems[3]).prev().show();
							$(ems[3]).show();
							$(ems[3]).next().show();
						}

						$(ems[4]).html(attr["branch_type"]);
						$(ems[5]).html(attr["mobile_mon_cum_new"]);
						//$(ems[5]).html(attr["cur_mon_bil_serv"]);
						$(ems[6]).html(attr["mobile_mon_cum_new_last"]);
						$(ems[7]).html(attr["brd_mon_cum_new"]);
						//$(ems[7]).html(attr["cur_mon_brd_serv"]);
						$(ems[8]).html(attr["brd_mon_cum_new_last"]);
						$(ems[9]).html(attr["itv_mon_new_install_serv"]);
						//$(ems[9]).html("1");
						$(ems[10]).html(attr["itv_serv_cur_mon_new_last"]);

						$("#sub_info_win").css("visibility","visible");
						$("#sub_info_win").show();
						//var win_content = $("#sub_info_win").html();
						//map.infoWindow.setContent(win_content);
						//map.infoWindow.show(evt.screenPoint);
						//var winPos = new Point(map.extent.xmax, map.extent.ymin, new SpatialReference({ wkid: 4326 }));
						//map.infoWindow.show(winPos);
					}

					var beforeMouseOverColor_sub = "";
					var beforeMouseOverColor_grid = "";

					var beforeClickColor_sub = "";
					var beforeClickColor_grid = "";

					//还原上次悬浮的支局的颜色
					var subFillRecover_mouseover = function(){
						if(sub_gra_last!=undefined && sub_gra_last!=""){
							var color = beforeMouseOverColor_sub;
							if(color=="")//上次没有记录过支局的颜色
								return;
							var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
									new esri.Color([color.r,color.g,color.b,color.a]), 3),new esri.Color([color.r,color.g,color.b,color.a]));
							sub_gra_last.setSymbol(symbol);
							sub_gra_last = "";
						}
					};

					//还原上次点击的支局的颜色
					var subFillRecover_click = function(){
						if(sub_gra_clicked!=undefined && sub_gra_clicked!=""){
							var color = beforeClickColor_sub;
							if(color=="")//上次没有记录过支局的颜色
								return;
							var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
									new esri.Color([color.r,color.g,color.b,color.a]), 3),new esri.Color([color.r,color.g,color.b,color.a]));
							sub_gra_clicked.setSymbol(symbol);
							sub_gra_clicked = "";
						}
					};

					//还原上次悬浮的网格的颜色
					var gridFillRecover_mouseover = function(){
						if(grid_gra_last!=undefined && grid_gra_last!=""){
							var color = beforeMouseOverColor_grid;
							if(color=="" || color==null)//上次没有记录过网格的颜色
								return;
							var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(color));//fill_color_array[i]
							fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color([grid_line_color[0],grid_line_color[1],grid_line_color[2],grid_line_color[3]]), grid_line_width));//color.a,STYLE_DASH，click_line_color_grid
							grid_gra_last.setSymbol(fillsymbol1);
							grid_gra_last = "";
						}

					};

					//还原上次点击的网格的颜色
					var gridFillRecover_click = function(){
						if(grid_gra_clicked!=undefined && grid_gra_clicked!=""){
							var color = beforeClickColor_grid;
							if(color=="")//上次没有记录过支局的颜色
								return;
							var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
									new esri.Color([grid_line_color[0],grid_line_color[1],grid_line_color[2],grid_line_color[3]]), grid_line_width),new esri.Color([color.r,color.g,color.b,color.a]));//color.a
							grid_gra_clicked.setSymbol(symbol);
							grid_gra_clicked = "";
						}
					};

					var drawQXLine = function(substation,sub_name){
						parent.global_position.splice(3,1,sub_name);

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
							parent.global_position.splice(2,1,qx_name);

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

									var graphics = new esri.Graphic(geometry, linesymbol_qx_selected);
									graLayer_qx.add(graphics);
								}
								if(l==1){
									back_to_ext = geometry;
								}
							});
						});
					}

					var featureLayer_mouse_over_handler = dojo.connect(featureLayer,"onMouseOver",function(evt){
						featureLayer_mouse_over(evt);
					});
					function featureLayer_mouse_over(evt){
						map.infoWindow.hide();
						//防止事件冒泡
						dojo.stopEvent(evt);
						evt.stopPropagation();
						//手型
						map.setMapCursor("pointer");

						var graphic = evt.graphic;

						//显示支局基本信息
						var attr = graphic.attributes;
						showSubInfoWin(graphic,attr);
					}

					var featureLayer_mouse_out_handler = dojo.connect(featureLayer,"onMouseOut",function(evt){
						featureLayer_mouse_out(evt);
					});
					function featureLayer_mouse_out(evt){
						$("#sub_info_win").css({visibility:"hidden"});
						//map.infoWindow.hide();
						var ele = evt.toElement;

						if(ele==null||ele.id!='sub_info_win'){
							$("#sub_info_win").hide();
						}
						map.setMapCursor("default");
						subFillRecover_mouseover();
					}

					var graLayer_zjname_mouse_over_handler = dojo.connect(graLayer_zjname,"onMouseOver",function(evt){
						graLayer_zjname_mouse_over(evt);
					});
					function graLayer_zjname_mouse_over(evt){
						map.infoWindow.hide();
						//防止事件冒泡
						dojo.stopEvent(evt);
						evt.stopPropagation();
						//手型
						map.setMapCursor("pointer");

						var attr = evt.graphic.attributes;

						//设置此次支局状态以便下次恢复
						var graphic = attr["sub_fill_gra"];

						var attrs = attr.sub_attr;
						showSubInfoWin(graphic,attrs);
					}

					var graLayer_zjname_mouse_out_handler = dojo.connect(graLayer_zjname,"onMouseOut",function(evt){
						map.setMapCursor("default");
					});

					/*$("#sub_info_win").on("mouseout",function (e) {
					 e = window.event || e;
					 var s = e.toElement || e.relatedTarget;
					 if(document.all) {
					 if (!this.contains(s)) {
					 $("#sub_info_win").hide()
					 }
					 } else {
					 try {
					 var reg = this.compareDocumentPosition(s);
					 if (!(reg == 20 || reg == 0)) {
					 $("#sub_info_win").hide()
					 }
					 }catch(e){$("#sub_info_win").hide()}
					 }
					 })*/
					var grid_graphics_init = "";
					//支局到网格的下钻操作
					var subToGrid = function(graphics,sub_selected_geometry,sub_attr){
						back_to_ext = map.extent;

						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").hide();
						$("#nav_fanhui_city").hide();
						$("#nav_fanhui_qx").show();
						$("#nav_fanhui_sub").hide();

						graLayer_zj_click.clear();
						graLayer_wg_click.clear();
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

						subFillRecover_click();//还原上次点击过的支局
						beforeClickColor_sub = beforeMouseOverColor_sub;
						sub_gra_clicked = graphics;
						//var sub_name = evt.graphic.attributes.REPORTTO;

						var sub_name = sub_data[sub_attr.SUBSTATION_NO];
						var substation = sub_attr.SUBSTATION_NO;
						var resid = sub_attr.RESID;

						drawQXLine(substation,sub_name);

						parent.global_substation = substation;
						parent.global_current_flag = 4;
						parent.global_current_full_area_name = sub_name;
						parent.global_current_area_name = sub_name;
						//parent.updateTabPosition();

						grid_name_label_symbol1 = new Array();
						grid_name_label_symbol2 = new Array();
						grid_name_label_symbol3 = new Array();
						grid_name_label_symbol4 = new Array();
						grid_name_label_symbol5 = new Array();

						graLayer_mouseclick.clear();
						graLayer_mouseclick.show();

						//查询支局对应的网格（用业务图层的resid，查对应关系表(sub_id)，获取网格的资源resid，用资源id在网格图层查询resid）
						$.post(url4Query, {eaction:'grids_in_subBySubResid',sub_id: resid, city_id: city_id}, function (data) {
							data = $.parseJSON(data);
							if (data.length == 0){
								var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
								graLayer_mouseclick.add(graphic);

								//layer.msg("该支局的网格暂未上图",{time:2000});
								//back_to_ext = "";
								//该支局下没有一个网格的时候，支局填充后，写“xx支局 [换行] 未划配网格”

								var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
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

							var queryTask1 = new esri.tasks.QueryTask(new_url_grid_vaild + grid_layer_index);
							var query1 = new esri.tasks.Query();
							query1.where = where_temp;
							//query1.orderByFields = ["ORIG_FID"];
							query1.outFields = ['SHAPE.AREA', 'RESNAME', 'RESID', 'REPORTTO', 'REPORT_TO_ID'];
							query1.returnGeometry = true;
							queryTask1.execute(query1, function (results) {
								var l = results.features.length;
								if (l == 0){
									var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
									graLayer_mouseclick.add(graphic);
									//layer.msg("该支局的网格暂未上图");
									//back_to_ext = "";
									var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
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
									//支局中没有网格可以上图
									var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
									graLayer_mouseclick.add(graphic);

									var textSymbol = new esri.symbol.TextSymbol(sub_name+" \n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
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
								//这里才是可以上图的网格↓
								var graphic = new esri.Graphic(sub_selected_geometry, linesymbol_has_grid_in_sub);
								graLayer_mouseclick.add(graphic);

								//使用配色数组填充网格背景
								grid_graphics_init = new Array();
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
									fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(grid_line_color), grid_line_width));//STYLE_DASH，click_line_color_grid
									//fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), grid_line_width));//STYLE_DASH，click_line_color_grid

									/*var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
									fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color([fill_color_array[k][0],fill_color_array[k][1],fill_color_array[k][2],1]), grid_line_width));//STYLE_DASH，click_line_color_grid*/

									var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
									graphic.setAttributes(feature.attributes);
									graLayer_wg.add(graphic);

									graLayer_wg.on("graphic-add",function(evt){
										var grid_gra_init = evt.graphic;
										var grid_attr = grid_gra_init.attributes;
										//grid_graphics_init[grid_attr.RESID] = grid_gra_init;
										grid_graphics_init[grid_attr.REPORT_TO_ID] = grid_gra_init;
									});

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
								var mapZoom = map.getZoom();
								wg_name_show_hide(mapZoom);

								map.addLayer(graLayer_mouseclick);

								map.addLayer(graLayer_wg_click);
							});
						});

						//右侧联动
						parent.freshIndexContainer(indexContainer_url_sub);
						subToGridFlag = false;
					};

					var gridToEnd = function(attr){
						subToGridFlag = true;
						var grid_name = attr.REPORTTO;
						if($.trim(grid_name)=="")
							grid_name = attr.RESNAME;

						grid_name = grid_name.substr(grid_name.indexOf("-")+1);

						parent.global_current_flag = 5;
						parent.global_current_full_area_name = grid_name;
						parent.global_current_area_name = grid_name;
						parent.global_position.splice(4, 1, grid_name);
						parent.global_report_to_id=attr.REPORT_TO_ID;

						parent.freshIndexContainer(indexContainer_url_grid);

						village_load("RES_ID = '"+attr.REPORT_TO_ID+"' AND STATUS = 1");
					}

					var subToGrid_toGrid = function(graphics,sub_selected_geometry,sub_attr,station_id,grid_name_selected,zoomable){
						back_to_ext = map.extent;

						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").hide();
						$("#nav_fanhui_sub").show();
						$("#nav_fanhui_qx").hide();
						$("#nav_fanhui_city").hide();

						graLayer_wg.clear();
						graLayer_wg_text.clear();
						graLayer_wg.show();
						graLayer_wg_text.show();

						featureLayer.hide();
						graLayer_zjname.hide();
						graLayer_qx.hide();
						graLayer_qx_all.hide();
						graLayer_subname_result.clear();

						/*var sub_selected_ext = sub_selected_geometry.getExtent();
						if(zoomable)
							map.setExtent(sub_selected_ext.expand(1.5));*/

						//var sub_name = evt.graphic.attributes.REPORTTO;

						var sub_name = sub_data[sub_attr.SUBSTATION_NO];
						var substation = sub_attr.SUBSTATION_NO;
						var resid = sub_attr.RESID;

						drawQXLine(substation,sub_name);

						parent.global_substation = substation;
						parent.global_current_flag = 4;
						parent.global_current_full_area_name = sub_name;
						parent.global_current_area_name = sub_name;
						//parent.updateTabPosition();

						grid_name_label_symbol1 = new Array();
						grid_name_label_symbol2 = new Array();
						grid_name_label_symbol3 = new Array();
						grid_name_label_symbol4 = new Array();
						grid_name_label_symbol5 = new Array();

						graLayer_mouseclick.clear();
						graLayer_mouseclick.show();

						//查询支局对应的网格（用业务图层的resid，查对应关系表(sub_id)，获取网格的资源resid，用资源id在网格图层查询resid）
						$.post(url4Query, {eaction:'grids_in_subBySubResid',sub_id: resid, city_id: city_id}, function (data) {
							data = $.parseJSON(data);
							if (data.length == 0){
								var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
								graLayer_mouseclick.add(graphic);
								//layer.msg("该支局的网格暂未上图",{time:2000});
								//back_to_ext = "";
								//该支局下没有一个网格的时候，支局填充后，写“xx支局 [换行] 未划配网格”
								var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
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

							setTimeout(function(){
								var queryTask1 = new esri.tasks.QueryTask(new_url_grid_vaild + grid_layer_index);
								var query1 = new esri.tasks.Query();
								query1.where = where_temp;
								//query1.orderByFields = ["ORIG_FID"];
								query1.outFields = ['SHAPE.AREA', 'RESNAME', 'RESID', 'REPORTTO', 'REPORT_TO_ID'];
								query1.returnGeometry = true;
								queryTask1.execute(query1, function (results) {
									var l = results.features.length;
									if (l == 0){
										var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
										graLayer_mouseclick.add(graphic);
										//layer.msg("该支局的网格暂未上图");
										//back_to_ext = "";
										var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
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
										//支局下没有网格上图
										var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
										graLayer_mouseclick.add(graphic);

										var textSymbol = new esri.symbol.TextSymbol(sub_name+" \n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
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
									//这里才是可以上图的网格↓
									var graphic = new esri.Graphic(sub_selected_geometry, linesymbol_has_grid_in_sub);
									graLayer_mouseclick.add(graphic);
									//使用配色数组填充网格背景
									grid_graphics_init = new Array();
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
										fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(grid_line_color), grid_line_width));//STYLE_DASH，click_line_color_grid
										//fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), grid_line_width));//STYLE_DASH，click_line_color_grid
										//fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color([fill_color_array[k][0],fill_color_array[k][1],fill_color_array[k][2],1]), grid_line_width));//STYLE_DASH，click_line_color_grid
										var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
										graphic.setAttributes(feature.attributes);
										graLayer_wg.add(graphic);

										graLayer_wg.on("graphic-add",function(evt){
											var grid_gra_init = evt.graphic;
											var grid_attr = grid_gra_init.attributes;
											//grid_graphics_init[grid_attr.RESID] = grid_gra_init;
											grid_graphics_init[grid_attr.REPORT_TO_ID] = grid_gra_init;
										});

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
									var mapZoom = map.getZoom();
									wg_name_show_hide(mapZoom);

									parent.global_current_flag = 5;
									parent.global_current_area_name = grid_name_selected;
									parent.global_current_full_area_name = grid_name_selected;
									parent.global_position.splice(4, 1, grid_name_selected);
									parent.global_substation = substation;
									parent.global_report_to_id = station_id;
									//console.log(sub_gra_last_temp.attributes.REPORT_TO_ID);
									parent.freshIndexContainer(indexContainer_url_grid);
									parent.updatePosition(5);

									/*gridFillRecover();
									var graphics = grid_graphics_init[station_id];
									grid_gra_last = graphics;
									try{
										beforeMouseOverColor_grid=graphics._shape.fillStyle;
										//var zoom = map.getZoom();
										currentOpacity = beforeMouseOverColor_grid.a;
										highlightSymbolzj_grid.color.a = currentOpacity;
										graphics.setSymbol(highlightSymbolzj_grid);

										var geo = graphics.geometry;
										map.centerAndZoom(getGravityCenter(geo,geo.rings),map.getZoom());
									}catch(e){

									}*/
									try{
										map.addLayer(graLayer_wg_click);
										var graphics = grid_graphics_init[station_id];
										graLayer_wg_click.clear();
										var gra = new esri.Graphic(graphics.geometry, linesymbol_grid_selected);
										graLayer_wg_click.add(gra);
										//var geo = graphics.geometry;
										//map.centerAndZoom(getGravityCenter(geo,geo.rings),map.getZoom());
										//map.setExtent(geo.getExtent().expand(grid_zoom));

										grid_gra_last = "";
										grid_gra_clicked = graphics;
										beforeClickColor_grid=graphics._shape.fillStyle;
										//var zoom = map.getZoom();
										currentOpacity = beforeClickColor_grid.a;
										highlightSymbol_grid_click.color.a = currentOpacity;
										graphics.setSymbol(highlightSymbol_grid_click);
									}catch(e){

									}

								});
								graLayer_wg.redraw();
							},2000);
							map.addLayer(graLayer_mouseclick);
							map.addLayer(graLayer_wg_click);
						});

						//右侧联动
						//parent.freshIndexContainer(indexContainer_url_sub);
					};

					//支局下钻到网格
					var sub_gra_clicked = "";//记录点击过的支局，以便设置其高亮的颜色（在backToSub方法中）
					var grid_gra_clicked = "";
					//支局板块点击
					var featureLayer_click_handler = dojo.connect(featureLayer,"onClick",function(evt){
						featureLayer_click(evt);
					});
					function featureLayer_click(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var graphics = evt.graphic;

						var sub_selected_geometry = graphics.geometry;
						var sub_attr = graphics.attributes;

						subToGrid(graphics,sub_selected_geometry,sub_attr);
					}

					//支局名称点击
					var graLayer_zjname_click_handler = dojo.connect(graLayer_zjname,"onClick",function(evt){
						graLayer_zjname_click(evt);
					});
					function graLayer_zjname_click(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var attrs = evt.graphic.attributes;
						var graphics = attrs.sub_fill_gra;

						//定位到所点支局的视野
						var sub_selected_geometry = attrs.sub_geo;
						var sub_attr = attrs.sub_attr;

						subToGrid(graphics,sub_selected_geometry,sub_attr);
					}

					//从支局下钻到网格后，是否点击过网格，点击后表示下钻到网格，此时返回才刷新右侧为支局，否则仍然为支局，不刷新
					var subToGridFlag = false;
					//从网格返回支局
					backToSub = function(){
						map.infoWindow.hide();
						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

						$("#nav_fanhui").hide();
						$("#nav_fanhui_sub").hide();
						$("#nav_fanhui_qx").show();
						$("#nav_fanhui_city").hide();

						graLayer_subname_result.clear();
						graLayer_mouseclick.clear();
						/*graLayer_mouseclick.clear();
						graLayer_mouseclick.hide();*/
						graLayer_zj_click.clear();
						graLayer_wg_click.clear();
						graLayer_wg.clear();
						graLayer_wg_text.clear();
						graLayer_wg.hide();
						graLayer_wg_text.hide();

						village_layer.clear();
						village_position_layer.clear();

						grid_gra_last = "";
						grid_gra_clicked = "";
						//graLayer_grid_mouseover.clear();

						featureLayer.show();
						graLayer_zjname.show();
						graLayer_qx.show();
						graLayer_qx_all.show();

						if(back_to_ext=="")
							back_to_ext = map.extent;
						var ext = back_to_ext.getExtent();

						map.setExtent(ext);
						//zj_name_show_hide(map.getZoom());

						if(parent.bar_status_history==1){
							parent.frmTitleShow();
						}else{
							parent.frmTitleHide();
						}

						//设置所选支局为高亮
						var zoom = map.getZoom();
						currentOpacity = getLayerOpacity(zoom);
						sub_gra_clicked.setSymbol(highlightSymbol_sub_click);
						var graphics = new esri.Graphic(sub_gra_clicked.geometry, linesymbol_sub_selected);
						graLayer_zj_click.add(graphics);

						parent.global_current_flag = 4;
						parent.global_current_full_area_name = parent.global_position[3];
						parent.global_current_area_name = parent.global_position[3];
						//parent.updateTabPosition();

						parent.updatePosition(parent.global_current_flag);

						if(subToGridFlag){
							parent.freshIndexContainer(indexContainer_url_sub);
							subToGridFlag = false;
						}
					};
					parent.backToSub = backToSub;

					backToCity = function(){
						subFillRecover_click();
						map.infoWindow.hide();
						$("#nav_fanhui").show();
						$("#nav_fanhui_city").hide();
						$("#nav_fanhui_sub").hide();
						$("#nav_fanhui_qx").hide();

						graLayer_mouseclick.clear();
						graLayer_mouseclick.hide();
						parent.clickFlag = false;

						parent.global_current_area_name = city_name;
						parent.global_current_full_area_name = city_full_name;
						parent.global_current_flag = 2;
						featureLayer.show();
						graLayer_zjname.show();
						graLayer_qx.show();
						graLayer_qx_all.show();
						graLayer_zj_click.clear();
						graLayer_wg_click.clear();
						graLayer_wg.hide();
						graLayer_wg_text.hide();
						graLayer_grid_mouseover.clear();

						var ext = tiled.fullExtent;

						map.setExtent(ext);
						graLayer_sub_mouseover.clear();
						//zj_name_show_hide(map.getZoom());

						parent.global_position.splice(1,1,parent.global_current_full_area_name);
						parent.freshIndexContainer(indexContainer_url_bearue);
						parent.updateTabPosition();

						parent.updatePosition(parent.global_current_flag);

						if(parent.bar_status_history==1){
							parent.frmTitleShow();
						}else{
							parent.frmTitleHide();
						}
					}
					parent.backToCity = backToCity;

					backToQx = function(){
						//clickedFlag = false;
						map.infoWindow.hide();
						$("#nav_fanhui").hide();
						$("#nav_fanhui_city").show();
						$("#nav_fanhui_sub").hide();
						$("#nav_fanhui_qx").hide();
						graLayer_mouseclick.clear();
						graLayer_mouseclick.hide();
						parent.clickFlag = false;
						if(zxs[parent.global_parent_area_name]==1){//嘉峪关的特殊处理，返回全市的支局时候,右侧刷新是市级的数据
							parent.global_current_flag = 2;
						}else
							parent.global_current_flag = 3;
						parent.global_current_area_name = parent.global_position[2];
						parent.global_current_full_area_name = parent.global_position[2];
						featureLayer.show();
						graLayer_zjname.show();
						graLayer_qx.show();
						graLayer_qx_all.show();
						graLayer_zj_click.clear();
						graLayer_wg_click.clear();
						graLayer_wg.hide();
						graLayer_wg_text.hide();
						graLayer_grid_mouseover.clear();
						if(back_to_ext=="")
							back_to_ext = map.extent;
						var ext = back_to_ext.getExtent();

						map.setExtent(ext);
						graLayer_sub_mouseover.clear();
						//zj_name_show_hide(map.getZoom());

						parent.global_position.splice(2,1,parent.global_current_full_area_name);
						parent.freshIndexContainer(indexContainer_url_bearue);
						parent.updateTabPosition();

						parent.updatePosition(parent.global_current_flag);

						if(parent.bar_status_history==1){
							parent.frmTitleShow();
						}else{
							parent.frmTitleHide();
						}
					};
					parent.backToQx = backToQx;

					var map_mouse_move_handler = dojo.connect(map,"onMouseOver",function(evt){
						map_mouse_move(evt);
					});
					function map_mouse_move(evt){
						if(evt.target.id=="gismap_gc"){
							map.setMapCursor("default");
							subFillRecover_mouseover();
						}
					}
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
								var queryTask1 = new QueryTask(new_url_sub_vaild + sub_layer_index);
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
									//支局名称获取后，根据当前放大级别，绘制名称层
									map.addLayer(graLayer_zjname);
									map.addLayer(graLayer_wd);//网点图层位于支局名称图层之上
									var mapZoom = map.getZoom();
									zj_name_show_hide(mapZoom);
								});
							}
						});

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
						var current_zoom = map.getZoom();
						var size = channel_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
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
					var graLayer_wd_mouse_over_handler = dojo.connect(graLayer_wd,"onMouseOver",function(evt){
						graLayer_wd_mouse_over(evt);
					});
					function graLayer_wd_mouse_over(evt){
						$(".esriPopupWrapper").show()
						$(".outerPointer").show()
						dojo.stopEvent(evt);
						evt.stopPropagation();

						$("#sub_info_win").hide();
						$("#grid_info_win").hide();

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
					}

					var graLayer_wd_mouse_out_handler = dojo.connect(graLayer_wd,"onMouseOut",function(evt){
						graLayer_wd_mouse_out(evt);
					});
					function graLayer_wd_mouse_out(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						var ele = evt.toElement;
						if(ele && ele.id!='grid_info_win'){
							$("#grid_info_win").hide();
						}
						$(".esriPopupWrapper").hide();
						$(".outerPointer").hide();
					}

					//20170711 新增 标准地址
					function standard_load(){
						standard_layer.clear();
						var queryTask_standard = new QueryTask(standard_address);
						var query_standard = new Query();
						//query_standard.where = map.extent;
						query_standard.geometry = map.extent;
						query_standard.outFields = ["RESNAME","RESFULLNAME","RESID"];
						query_standard.returnGeometry = true;
						var city_geometry = "";//所展示市级范围的图形对象
						queryTask_standard.execute(query_standard, function (results) {
							if(results.features.length==0)
								return;
							var current_zoom = map.getZoom();
							var size = standard_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
							for(var i = 0,l = results.features.length;i<l;i++){
								var feature = results.features[i];
								var geo = feature.geometry;

								var pointAttributes = {RESNAME :feature.attributes.RESNAME ,RESFULLNAME:feature.attributes.RESFULLNAME,RESID:feature.attributes.RESID};
								var img = new PictureMarkerSymbol(standard_ico, size, size);
								var graphic = new esri.Graphic(geo,img,pointAttributes);
								//var symbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, size, new SimpleLineSymbol(), new Color([210,210,0]));
								//var graphic = new esri.Graphic(geo,symbol,pointAttributes);
								standard_layer.add(graphic);
							}
						});
						map.addLayer(standard_layer);
						map.addLayer(village_layer);
						map.addLayer(village_position_layer);
					}

					var position_layer=new GraphicsLayer()
					map.addLayer(position_layer)
					var graphic_position=''
					standard_position_load=function (res_id,latn_name,latn_id,thiz){
                        $(thiz).siblings().removeClass("tr_click_background_color");//background-color: #c1c1c1;
                        $(thiz).siblings().addClass("tr_default_background_color");
                        $(thiz).removeClass("tr_default_background_color");
                        $(thiz).addClass("tr_click_background_color");
						position_layer.clear();
						village_position_layer.clear();
						//地市改变，图层改变
						if(city_full_name.indexOf(latn_name)<=0){
							changeMapToCity(latn_name,latn_id)
						}
						//右侧联动到楼宇所在 网格,通过地理位置关联

						var build_geo = "";
						var queryTask_standard = new QueryTask(standard_address_pre+cityForLayer+standard_address_suf);
						var query_standard = new Query();
						//query_standard.where = map.extent;
						query_standard.where="RESID="+res_id
						query_standard.outFields = ["RESID","RESNAME","RESFULLNAME"];
						query_standard.returnGeometry = true;
						queryTask_standard.execute(query_standard, function (results) {
							if(results.features.length==0){
								layer.msg("该楼宇未上图")
								return;
							}
							standard_layer.clear();
							map.addLayer(position_layer)
							var current_zoom = map.getZoom();
							var size = standard_point_get_size(current_zoom)
							var geo = results.features[0].geometry;
							build_geo = geo;
							var x=geo.x;
							var y=geo.y;

							graphic_position=new Graphic(geo,point_selected_mark);
							position_layer.add(graphic_position);
							map.centerAndZoom([x,y],10);
							//显示弹窗
							var evt={}
							evt.graphic=results.features[0];
							evt.close=1;
							standard_layer_click(evt);
							queryAndSetGrid(build_geo)

						});
					}
					function queryAndSetGrid(build_geo){
						var queryTask_grid = new QueryTask(new_url_grid_vaild + grid_layer_index);
						var query_grid = new Query();
						query_grid.geometry = build_geo;
						query_grid.outFields = ["RESNAME","REPORTTO","REPORT_TO_ID"];
						query_grid.returnGeometry = false;
						queryTask_grid.execute(query_grid, function (results) {
							if(results.features.length==0){
								layer.msg("未找到所归属的网格")
								return;
							}

							var queryTask_sub = new QueryTask(new_url_sub_vaild + sub_layer_index);
							var querysub = new Query();
							querysub.geometry = build_geo;
							querysub.outFields = ["SUBSTATION_NO","RESNAME"];
							querysub.returnGeometry = false;
							queryTask_sub.execute(querysub,function(results1){
								if(results1.features.length==0){
									layer.msg("未找到所归属的支局")
									return;
								}

								$("#bb1").text(results1.features[0].attributes.RESNAME+">"+results.features[0].attributes.RESNAME)
								parent.global_position.splice(3, 1, sub_data[results1.features[0].attributes.SUBSTATION_NO]);
							});

							gridToEnd(results.features[0].attributes);
						});
					}

					/*yinming 2017年7月20日15:13:58 小区定位*/
                    position_village=function (x,y,res_id){
                        standard_layer.clear();
                        position_layer.clear();
                        var queryTask_standard = new QueryTask(standard_address_pre+cityForLayer+standard_address_suf);
                        var query_standard = new Query();
                        //query_standard.where = map.extent;
                        query_standard.where="RESID="+res_id
                        query_standard.outFields = ["RESNAME","RESFULLNAME"];
                        query_standard.returnGeometry = true;
                        queryTask_standard.execute(query_standard, function (results) {
                            map.addLayer(position_layer)
                            var current_zoom = map.getZoom();
                            //var size = standard_point_get_size(current_zoom)
                            var geo = results.features[0].geometry;
                            graphic_position=new Graphic(geo,point_selected_mark);//
                            position_layer.add(graphic_position);
                            map.centerAndZoom([x,y],10);//
                        });

                    }

					var standard_layer_mouse_over_handler = dojo.connect(standard_layer,"onMouseOver",function(evt){
						map.setMapCursor("pointer");
					});
					var standard_layer_mouse_out_handler = dojo.connect(standard_layer,"onMouseOut",function(evt){
						map.setMapCursor("default");
//						map.infoWindow.hide();
					});

					var standard_layer_click_handler = dojo.connect(standard_layer,"onClick",function(evt){
						standard_layer_click(evt);
					});
					function standard_layer_click(evt){
                        var attr = evt.graphic.attributes;
						var build_geo = evt.graphic.geometry;

						queryAndSetGrid(build_geo)
						var graphic_position=new Graphic(evt.graphic.geometry,point_selected_mark);
						position_layer.clear();
						village_position_layer.clear();
						position_layer.add(graphic_position);
                        $.post(url4Query,{eaction:'build_win',res_id:attr.RESID},function(data){
                            var d=$.parseJSON(data)
							if(d==null) {
								layer.msg("暂无该楼宇信息")
							}
							else {
								var str=attr.RESFULLNAME
								$("#build_title").text(str)
                                var width=$(parent.window).width()
								if(width<=1300) {
                                    if(str.length>=21){
                                        $("#build_title").css("line-height","18px")
                                    }else {
                                        $("#build_title").css("line-height","40px")
                                    }
								}else if(width<=1400){
                                    if(str.length>=21){
                                        $("#build_title").css("line-height","18px")
                                    }else {
                                        $("#build_title").css("line-height","40px")
                                    }
								}else{
                                    if(str.length>=22){
                                        $("#build_title").css("line-height","18px")
                                    }else {
                                        $("#build_title").css("line-height","40px")
                                    }
								}

								//$("#build_more_title").text(str.length>12?'...'+str.substring(str.length-12,str.length):str)
								$("#build_title").attr("title",str);
								$("#bb7").text(d.ZHU_HU_COUNT);
								$("#bb8").text(d.CENG_COUNT);
								$("#bb3").text(d.PEOPLE_COUNT==null?"-":d.PEOPLE_COUNT);
								$("#bb4").text(d.OCCUPANCY_RATE==null?'-':(d.OCCUPANCY_RATE.toFixed(2) + '%'));

								$("#bb5").text(d.RES_ID_COUNT);
								$("#bb6").text(d.SY_RES_COUNT);
								skip = function () {
									//更多详情界面
									showBuildDetail(d.SEGM_ID,str,'all',0,evt.close);
								}
								$("#build_info_win").show();
							}
                        })
					}

					/* lixiaofeng 楼宇 详情页7.21.15.12↓*/
					 showBuildDetail=function (res_id,str,visible,page,c){
						 layer.closeAll()
						 $("#nav_standard").removeClass("active")
						 $("#nav_marketing").removeClass("active")
						 tmpy='1';
						 tmpl = '1';
						$(".build_more_win").show()

						 if(page==0){
                             $(".build_more_win").html(" <div class=\"titlea\"><div id=\"build_more_title\" style='text-align:left;width:90%;display: inline-block;padding-bottom:5px'></div><div  class=\"titlec\" id='build_more_close'></div></div>")
							 $("#build_more_title").text(str)
							 $(".build_more_win").append("<iframe src=\"viewPlane_build_view_details.jsp?res_id="+res_id+"&vis="+visible+"\" width=\"720\" height=\"500\"></iframe>")
						 }else{
                             $(".build_more_win").html(" <div class=\"titlea\"><div id=\"build_more_title\" style='text-align:left;width:90%;display: inline-block;padding-bottom:5px'>营销详情</div><div  class=\"titlec\" id='build_more_close'></div></div>")
							 $(".build_more_win").append("<iframe src=\"viewPlane_buildings_view_details.jsp?res_id="+res_id+"&vis="+visible+"\" width=\"720\" height=\"500\"></iframe>")
						 }
						 $("#build_more_close").on("click",function(){
							 $(".build_more_win").hide()
							 if(c==1){
								$("#nav_standard").click()
							 }
						 })

					}

					var showGridInfoWin = function(graphic,attr){
						map.setMapCursor("pointer");

						gridFillRecover_mouseover();

						if(grid_gra_clicked!=""){
							if(grid_gra_clicked.attributes["RESID"] == graphic.attributes["RESID"]){
								//颜色不做操作
							}else{
								//记录此次网格及其颜色，以便下次还原
								grid_gra_last = graphic;
								beforeMouseOverColor_grid=grid_gra_last._shape.fillStyle;

								//设置高亮显示
								var zoom = map.getZoom();
								currentOpacity = getLayerOpacity(zoom);
								highlightSymbol_grid_mouse_over.color.a = currentOpacity;
								graphic.setSymbol(highlightSymbol_grid_mouse_over);
							}
						}else{
							//记录此次网格及其颜色，以便下次还原
							grid_gra_last = graphic;
							beforeMouseOverColor_grid=grid_gra_last._shape.fillStyle;

							//设置高亮显示
							var zoom = map.getZoom();
							currentOpacity = getLayerOpacity(zoom);
							highlightSymbol_grid_mouse_over.color.a = currentOpacity;
							graphic.setSymbol(highlightSymbol_grid_mouse_over);
						}

						var grid_name = attr.REPORTTO;
						if($.trim(grid_name)=="")
							grid_name = attr.RESNAME;

						var report_to_id = attr.REPORT_TO_ID;
						report_to_id = $.trim(report_to_id);

						return;
//						if(report_to_id==""||report_to_id=="null")
//							win_content = "<span>暂无关联数据</span>";
//						else{
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

									$("#grid_info_win").css("visibility","visible");
									$("#grid_info_win").show();
								}
//								map.infoWindow.setContent(win_content);
							});
//						}
					}

					var graLayer_wg_mouse_over_handler = dojo.connect(graLayer_wg,"onMouseOver",function(evt){
						graLayer_wg_mouse_over(evt);
					});
					function graLayer_wg_mouse_over(evt){
						map.infoWindow.hide();
						dojo.stopEvent(evt);
						evt.stopPropagation();
						var graphics = evt.graphic;
						var attr = graphics.attributes;
						showGridInfoWin(graphics,attr);
					};
					var graLayer_wg_text_mouse_over_handler = dojo.connect(graLayer_wg_text,"onMouseOver",function(evt){
						graLayer_wg_text_mouse_over(evt);
					});
					function graLayer_wg_text_mouse_over(evt){
						map.infoWindow.hide();
						dojo.stopEvent(evt);
						evt.stopPropagation();
						var attrs = evt.graphic.attributes;
						var graphics = attrs["grid_fill_gra"];
						var attr = attrs["grid_attr"];
						showGridInfoWin(graphics,attr);
					}
					var graLayer_wg_mouse_out_handler = dojo.connect(graLayer_wg,"onMouseOut",function(evt){
						graLayer_wg_mouse_out(evt);
					});
					function graLayer_wg_mouse_out(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						map.setMapCursor("default");
						gridFillRecover_mouseover();
						var ele = evt.toElement;
						if(ele==null || ele.id!='grid_info_win'){
							$("#grid_info_win").hide();
						}
					}
					$("#grid_info_win").on("mouseout", function (e) {
						e = window.event || e;
						var s = e.toElement || e.relatedTarget;
						if (document.all) {
							if (!this.contains(s)) {
								$("#grid_info_win").hide();
							}
						} else {
							try {
								var reg = this.compareDocumentPosition(s);
								if (!(reg == 20 || reg == 0)) {
									$("#grid_info_win").hide();
								}
							} catch (e) {
								$("#grid_info_win").hide();
							}
						}
					});
					//网格名称鼠标移出事件
					var graLayer_wg_text_mouse_out_handler = dojo.connect(graLayer_wg_text,"onMouseOut",function(evt){
						graLayer_wg_text_mouse_out(evt);
					});
					function graLayer_wg_text_mouse_out(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();
						gridFillRecover_mouseover();
						$("#grid_info_win").hide();
					}
					//网格点击事件
					var graLayer_wg_click_handler = dojo.connect(graLayer_wg,"onClick",function(evt){
						graLayer_wg_click_f(evt);
					});
					function graLayer_wg_click_f(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var attr = evt.graphic.attributes;
						gridToEnd(attr);

						gridFillRecover_click();

						grid_gra_last = "";
						grid_gra_clicked = evt.graphic;
						beforeClickColor_grid = beforeMouseOverColor_grid;

						//设置所选支局为高亮
						/*var zoom = map.getZoom();
						currentOpacity = getLayerOpacity(zoom);
						grid_gra_clicked.setSymbol(highlightSymbol_grid_click);*/

						//graLayer_wg.setOpacity(0);//选中网格则把网格的填充层透明度降低为0

						var wg_gracs = graLayer_wg.graphics;
						for(var i = 0,l = wg_gracs.length;i<l;i++){
							if(wg_gracs[i].attributes.RESID == grid_gra_clicked.attributes.RESID)
								wg_gracs[i].symbol.color.a = 0;
							else
								wg_gracs[i].symbol.color.a = currentOpacity;
							grid_graphics_init[wg_gracs[i].attributes.RESID] = wg_gracs[i];
						}
						graLayer_wg.graphics = wg_gracs;
						graLayer_wg.redraw();

						graLayer_wg_click.clear();
						var graphics = new esri.Graphic(evt.graphic.geometry, linesymbol_grid_selected);
						graLayer_wg_click.add(graphics);

						map.setExtent(grid_gra_clicked.geometry.getExtent().expand(grid_zoom));
					}
					//网格名称点击事件
					var graLayer_wg_text_click_handler = dojo.connect(graLayer_wg_text,"onClick",function(evt){
						graLayer_wg_text_click(evt);
					});
					function graLayer_wg_text_click(evt){
						dojo.stopEvent(evt);
						evt.stopPropagation();

						var attr = evt.graphic.attributes.grid_attr;
						gridToEnd(attr);

						gridFillRecover_click();

						grid_gra_last = "";
						grid_gra_clicked = evt.graphic.attributes.grid_fill_gra;
						beforeClickColor_grid = beforeMouseOverColor_grid;

						//设置所选支局为高亮
						/*var zoom = map.getZoom();
						currentOpacity = getLayerOpacity(zoom);
						grid_gra_clicked.setSymbol(highlightSymbol_grid_click);*/

						//graLayer_wg.setOpacity(0);//选中网格则把网格的填充层透明度降低为0
						var wg_gracs = graLayer_wg.graphics;
						for(var i = 0,l = wg_gracs.length;i<l;i++){
							if(wg_gracs[i].attributes.RESID == grid_gra_clicked.attributes.RESID)
								wg_gracs[i].symbol.color.a = 0;
							else
								wg_gracs[i].symbol.color.a = currentOpacity;
							grid_graphics_init[wg_gracs[i].attributes.RESID] = wg_gracs[i];
						}
						graLayer_wg.graphics = wg_gracs;
						graLayer_wg.redraw();

						graLayer_wg_click.clear();
						var graphics = new esri.Graphic(evt.graphic.attributes.grid_geo, linesymbol_grid_selected);
						graLayer_wg_click.add(graphics);

						map.setExtent(grid_gra_clicked.geometry.getExtent().expand(grid_zoom));
					}

					var village_layer_click_handler = dojo.connect(village_layer,"onClick",function(evt){
						operateVillage(evt.graphic.attributes.village_id);
					});

					//20170715 新增 小区上图功能
					villageToMap = function(){
						var user_id = '${sessionScope.UserInfo.LOGIN_ID}';
						if(user_id==""){
							layer.msg("与服务器连接断开，请重新登录");
							return;
						}

						var gra = grid_graphics_init[parent.global_report_to_id];
						if(gra==undefined){
							layer.msg("该网格未划配，小区上图功能不可用");
							return;
						}

						$("#village_draw_tool_div").show();//显示小区上图的退出工具栏

						map.infoWindow.hide();

						//隐藏无关的图层
						graLayer_wg.hide();//隐藏网格板块
						graLayer_wg_text.hide();//隐藏网格名称
						graLayer_mouseclick.hide();//隐藏支局的网格线

						//隐藏无关的按钮
						$("#nav_fanhui_sub").hide();//隐藏返回按钮
						back_btn_hided = "#nav_fanhui_sub";
						$(".tools_n").hide();//隐藏左侧工具条
						parent.hideMapPosition();//隐藏地图右上方返回路径条

						//隐藏无关的表格
						layer.closeAll();

						var sfs = new SimpleFillSymbol();
						sfs.setOutline(new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL, new Color([0,0,0]), 1));
						sfs.setColor(new Color([255,210,0,0.2]));


						var gra_grid = new Graphic(gra.geometry,sfs);
						graLayer_wg_for_village.clear();
						graLayer_wg_for_village.add(gra_grid);

						//放大到要加小区的网格范围视野
						map.setExtent(gra.geometry.getExtent().expand(1.5));
						draw_type = "village";
						drawEnable('');
					}
					parent.villageToMap = villageToMap;

					//liangliyuan 20170720 新增 小区服务功能 ↓
					function village_load(where,village_id_selected){
						village_layer.clear();
						village_position_layer.clear();
						map.removeLayer(village_layer);
						map.removeLayer(village_position_layer);

						var queryTask_village = new QueryTask(village_url);
						var query_village = new Query();
						query_village.where = where;
						query_village.village_id_selected = village_id_selected;
						//query_village.geometry = map.extent;
						query_village.outFields = ["village_id","POS_X","POS_Y"];
						query_village.returnGeometry = true;
						var city_geometry = "";//所展示市级范围的图形对象
						queryTask_village.execute(query_village, function (results) {
							if(results.features.length==0)
								return;
							var current_zoom = map.getZoom();
							var size = standard_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
							for(var i = 0,l = results.features.length;i<l;i++){
								var feature = results.features[i];
								var geo = feature.geometry;
								var attr = feature.attributes;
								var pointAttributes = {"village_id":attr.VILLAGE_ID};
								var ico_url = village_ico;

								var img = new PictureMarkerSymbol(ico_url, size*3, size*3);
								var graphic = new esri.Graphic(geo,img,pointAttributes);
								//var symbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, size, new SimpleLineSymbol(), new Color([210,210,0]));
								//var graphic = new esri.Graphic(geo,symbol,pointAttributes);
								village_layer.add(graphic);

								if(query_village.village_id_selected!=undefined && attr.VILLAGE_ID == query_village.village_id_selected){
									var ico_url1 = village_ico_selected;
									var img1 = new PictureMarkerSymbol(ico_url1, size*3, size*3);
									var graphic1 = new esri.Graphic(geo,img1,pointAttributes);
									village_position_layer.add(graphic1);
								}
							}
							village_layer.show();
							village_position_layer.show();

							map.addLayer(village_layer);
							map.addLayer(village_position_layer);
						});
						/*village_layer.on("graphic-add",function(evt){
							var attr = evt.graphic.attributes;
							if(attr.village_id==village_id_selected){
								var ico_url = village_ico_selected;
								var current_zoom = map.getZoom();
								var size = standard_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
								var img1 = new PictureMarkerSymbol(ico_url, size*3, size*3);
								var graphic1 = new esri.Graphic(evt.graphic.geometry,img1,attr);
								village_position_layer.add(graphic1);
							}
						});*/
					}

					//liangliyuan 20170720 新增 小区服务功能 ↑

					//20170717 瑞杰新增菜单滚动功能
					/*$('#tools_scroll').kxbdSuperMarquee({
						distance:100,
						time:3,
						btnGo:{up:'#goU',down:'#goD'},
						direction:'down'
					});*/
				}
		)
	}
    /*layer.open({
        title: ['支局列表', 'line-height:32px;text-size:30px;height:32px;'],
//      title:false,
        type: 1,
        shade: 0,
        area: ['298px', '99.7%'],
        offset: ['1px', '34px'],
        content: $("#list_div"),
        cancel: function(index){
			$("#nav_list").removeClass("active");
			return tmp='1';
		}
    })*/


	var backToEchart = function(){
		parent.global_parent_area_name = parent.global_position[0];
		parent.global_current_area_name = parent.global_position[0];
		parent.global_current_full_area_name = parent.global_position[0];
		//parent.global_current_city_id = city_id;//以前返回二级地市页面的时候用这个
		parent.global_current_city_id = province_id[parent.global_position[0]];
		parent.global_current_flag = flag-1;
		//var url4mapBackTop = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_city_dev_colorflow.jsp"/>';
		var url4mapBackTop = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_province_dev_colorflow.jsp"/>';
		parent.freshMapContainer(url4mapBackTop);
		parent.freshIndexContainer(indexContainer_url_bearue);
		//parent.toggleModelButton();
	}

    //楼宇详情弹窗

   $('#build_close').on('click', function(){
	$('#detail_more').show();
	   $('#layui-layer1').hide()
	});
</script>