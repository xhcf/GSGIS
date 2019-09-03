<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
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
    <title>政企校园</title>
    <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.3"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js?version=1.1"/>
    <c:resources type="easyui,app" style="b"/>
    <!--<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>-->
    <!--<script type="text/javascript" src='<e:url value="/resources/component/echarts_new/3.8.5/echarts.js"/>'></script>-->
    <script type="text/javascript" src='<e:url value="/pages/telecom_Index/common/js/echarts_4.0.4/echarts.min.js"/>'></script>
    <!-- echarts 3.2.3 -->
    <script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js?version=1.1"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/scripts/admin.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/esri.symbol.MultiLineTextSymbol.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <%--<script src='<e:url value="/pages/telecom_Index/common/js/Marquee.js?version=1.2"/>' charset="utf-8"></script>--%>
    <script src='<e:url value="/pages/telecom_Index/common/js/left_menu_control.js?version=1.1"/>'
            charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/sub_grid/js/mapTran.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/sub_grid/js/WKTUtil.js"/>' charset="utf-8"></script>
		<link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_org_frame.css" />' rel="stylesheet" type="text/css" media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=1.4"/>'
          rel="stylesheet" type="text/css" media="all"/>

    <script src='<e:url value="/pages/telecom_Index/common/js/bureau_geo_center.js?version=1.4"/>'
            charset="utf-8"></script>
		<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.3"/>' rel="stylesheet" type="text/css" media="all" />
		<!--<link href='<e:url value="/pages/telecom_Index/common/css/build_view_new.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all" />-->
		<link href='<e:url value="/pages/telecom_Index/common/css/enterprise.css?version=1.1" />' rel="stylesheet" type="text/css" media="all" />
	  <link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_org_frame.css?version=1.2"/>' rel="stylesheet" type="text/css" media="all" />
</head>
<body class="body_padding" style="position:relative;background-color:transparent;width:100%;height:100%;">
<style>
    html, body, #map {
        height: 100%;
        margin: 0;
        padding: 0;
    }

    .myInfoWindow {
        position: absolute;
        z-index: 999;
        -moz-box-shadow: 0 0 1em #26393D;
        font-family: sans-serif;
        font-size: 12px;
        background-color: rgba(255, 255, 255, 0);
    }

    .dj_ie .myInfoWindow {
        border: 1px solid black;
    }

    .myInfoWindow .content {
        position: relative;
        background-color: #EFECCA;
        color: #002F2F;
        overflow: auto;
        padding: 2px 2px 2px 2px;
        background-color: rgba(255, 255, 255, 0);
    }

    body .demo-class {
        background: #0d3d88;
        color: #fff;
        border: none;
    }

    body .demo-class {
        border-top: 1px solid #E9E7E7
    }

    body .demo-class .layui-layer-btn a {
        background: #333;
    }

    body .demo-class .layui-layer-btn {
        background: #999;
    }

    body .demo-class .layui-layer-content {
        background: #040f54;
        color: #fff;
        border: none;
    }

    #leida_div {
        width: 50px;
        height: 50px;
        position: absolute;
        left: 0px;
        top: 0px;
        z-index: 9999;
        display: none;
        border: 1px solid #f00;
    }

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
    #query_div{width:120px;height:47px;background:#0f2c92;padding:0;position:absolute;display:none;}
    #query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
    .ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
    #query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
    #village_info_win.win_full_screen {top:0px!important;left:0px!important;}
    #village_info_win.win_full_screen .win_operate {top:10px!important;}

    #schoolOrEnterprise_info_win {height:430px;}
    #schoolOrEnterprise_info_win.win_full_screen {top:0px!important;left:0px!important;}
    #schoolOrEnterprise_info_win.win_full_screen .win_operate {top:10px!important;}

    #prod_list_win{width:400px;height:300px;display:none;}

    /*客户视图 2018*/
	  .cus_view_body {height:67%;width:100%;position:relative;}
	  .cus_view_body > div {display:none;}
	  .cus_view_body > div{height:95%;}
	  #info_collect_edit_div{z-index:10000;}

	  /*小列表*/
	  #pos_tab_win {position:absolute;top:0px;right:0px;display:none;width:300px;height:100%;background:#fff;z-index:31;border:solid 1px #1069c9;}
	  #pos_tab_title {line-height:26px;width:80%;color:#fff;font-size:14px;font-weight:bold;padding:5px;vertical-align:middle;float:left;}
	  #pos_tab_div {width:100%;overflow-y:scroll;padding:0 5px 13px 5px;margin:0px auto;margin-top:-1px;}
	  #pos_tab_div table {border-collapse:collapse;width:100%;}
	  #pos_tab_total_num {color:red;}
	  #pos_tab_thead {width:100%;padding-right:19px;height:auto;}
	  #pos_tab_thead tr th,#pos_tab_tbody tr td{border:1px solid #c9c9ca;}
	  #pos_tab_thead tr th:first-child{width:15%;}
	  #pos_tab_thead tr th:nth-child(2){width:60%}
	  #pos_tab_thead tr th:nth-child(3){width:25%}
	  #pos_tab_tbody tr td:first-child{width:15%;}
	  #pos_tab_tbody tr td:nth-child(2){width:60%}
	  #pos_tab_tbody tr th:nth-child(3){width:25%}
	  .text-center {text-align:center;}
	  .text-left {text-align:left;}
	  .pos_item {color:#3d8ccf;text-decoration:underline;cursor:pointer;}
</style>

<div id="sub_info_win"
     style="display:none;background-color: #fff;position: absolute;bottom: 1;right: 0;z-index: 99999999999;width: 220px;height: 110px;border: 2px solid #2070dc;border-radius: 4px;">
    <div style="width:100%;text-align: left;height: 26px;line-height: 26px;font-size: 14px;background-color:#073b8a;color: #fcd001;padding-left: 10px ">
        支局信息
    </div>
    <span style="font-weight:bold;color: red;margin-left: 8px;margin-top: 2px;display: inline-block;font-size: 12px">支局名称：</span><em
        style="color: red;font-size: 12px"></em>
    <br>
    <!-- liangliyuan 2017年7月20日11:56:23 新增所属分局内容 ↓-->
    <!-- liangliyuan 2017年7月21日10:24:57 修改所属分局字体为黑色 -->
    <span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block;font-size: 12px">所属分局：</span><em
        style="font-size: 12px;"></em>
    <br>
    <!-- liangliyuan 2017年7月20日11:56:31 新增所属分局内容 ↑-->
    <span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block;font-size: 12px">网&nbsp;格&nbsp;数 ：</span>
    <e style="font-size:12px ;">共</e>
    <em style="font-size:12px ;"></em>
    <e style="font-size:12px ;">个</e>
    <e>,</e>
    <em style="font-size:12px ;"></em>
    <e style="font-size:12px ;">个未上图</e>
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
<!--
<div id="grid_info_win"
     style="display:none;background-color: #fff;position: absolute;bottom: 0;right: 0;z-index: 99999999999;width: 260px;height: 200px;border: 2px solid #2070dc;border-radius: 4px;">
    <div style="width:100%;text-align: left;height: 26px;line-height: 26px;font-size: 16px;background-color:#0d0a8b;color: #ffffff;padding-left: 10px ">
        网格信息
    </div>
    <span style="font-weight:bold;color: red;margin-left: 8px;margin-top: 2px;display: inline-block">网格名称：</span><em
        style="color: red;"></em>
    <br>
    <span style="font-weight:bold;margin-left: 8px;margin-top: 2px;display: inline-block">所属支局：</span><em></em>
    <br>
    <table style="width: 98%;font-size:14px;text-align:center;margin-top: 2px">
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">
                指标名称
            </td>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">
                当日发展
            </td>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;">
                当月发展
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                移动
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;"><em></em></td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                宽带
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                ITV
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                终端
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                800M
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
        </tr>
    </table>
</div>
-->
<!-- 楼宇右下角信息窗，已废弃↓ -->
<div class="village_info_win new_beta" id="build_info_win1" style="display: none;height:360px;">
    <div class="village_title" id="build_info_win_draggable"><span>楼宇信息</span>

        <div class="village_close" onclick="$('#build_info_win').hide()"></div>
    </div>
    <span id="build_view_title" class="village_name_new"></span>
    <span><a id="build_close" class="closed build_detail_button" href="javascript:skip()" style="cursor: pointer">详情</a></span>

    <!--概况-->
    <div style="margin-top:25px;">
        <div class="devep village_new_base">
            <div class="deve_ta">
                基础
            </div>
            <div class="deve_tb">
                <table border="0" width="100%" style="margin-top:15px;">
                    <tr>
                        <td width="50%">
                            <div class="quota"><span style="color: #9ebaf1">•</span><span
                                    style="margin-left: 5px">支局：<span id="build_view_sub"></span></span></div>
                        </td>
                        <td>
                            <div class="quota"><span>网格：<span id="build_view_grid"></span></span></div>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="deve_ta">
                业务
            </div>
            <div class="deve_tb" style="padding-top:12px;">
                <table border="0" width="100%">
                    <tr>
                        <td width="31%">
                            <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">移动用户：<span
                                    id="build_view_yd_count"></span></span></div>
                        </td>
                        <td width="23%">
                            <div class="quota"><span>宽带用户：<span id="build_view_kd_count"></span></span></div>
                        </td>
                        <td width="24%">
                            <div class="quota"><span>电视用户：<span id="build_view_ds_count"></span></span></div>
                        </td>
                        <td width="22%"></td>
                    </tr>
                </table>
            </div>
            <div class="deve_ta">
                市场
            </div>
            <div class="deve_tb" style="padding-top:12px;">
                <table border="0" width="100%">
                    <tr>
                        <td width="31%">
                            <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">市场占有率：<span
                                    id="build_view_market_lv" style="color:#FF9214;font-weight:bold!important;"></span></span>
                            </div>
                        </td>
                        <td width="23%">
                            <div class="quota"><span>营销目标：<span id="build_view_yx_all"></span></span></div>
                        </td>
                        <td width="24%">
                            <div class="quota"><span>住户数：<span id="build_view_zhu_hu"></span></span></div>
                        </td>
                        <td width="22%"></td>
                    </tr>
                </table>
            </div>
            <div class="deve_ta">
                资源
            </div>
            <div class="deve_tb" style="padding-top:12px;">
                <table border="0" width="100%">
                    <tr>
                        <td width="31%">
                            <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">端口占用率：<span
                                    id="build_view_port_lv"
                                    style="color:#FF9214;font-weight:bold!important;"></span></span></div>
                        </td>
                        <td width="23%">
                            <div class="quota"><span>总端口：<span id="build_view_port"></span></span></div>
                        </td>
                        <td width="24%">
                            <div class="quota"><span>占用端口：<span id="build_view_port_used"></span></span></div>
                        </td>
                        <td width="22%">
                            <div class="quota"><span>空闲端口：<span id="build_view_free_port"></span></span></div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
<!-- 楼宇右下角信息窗，已废弃↑ -->

<!-- 楼宇详情弹窗 shenruijie -->
<div class="build_more_win" id="detail_more" style="display:none;">
    <div class="titlea">
        <div id="detail_more_draggable" style='text-align:left;width:90%;display: inline-block'>楼宇视图</div>
        <div class="titlec" onclick="$('#detail_more').hide()"></div>
    </div>
    <iframe width="100%" height="100%"></iframe>
</div>
<!-- 楼宇详情弹窗 shenruijie end-->
<!-- 营销详情弹窗 -->
<div class="build_more_win" id="mark_detail" style="display:none;">
    <div class="titlea">
        <div id="mark_detail_draggable" style='text-align:left;width:90%;display: inline-block'></div>
        <div class="titlec" onclick="$('#mark_detail').hide()"></div>
    </div>
    <a href="javascript:void(0)" id="mark_link">营销</a>
    <iframe width="100%" height="100%"></iframe>
</div>

<!-- 小区查看弹窗 小区工作台 --><!-- 2018-12-11 小区工作台宽屏适应 -->
<div class="village_info_win new_beta leader" id="village_info_win" style="display: none;width:70%;height:95%;"><!-- width:880px -->

		<input type="hidden" id="village_view_v_id"/>
    <input type="hidden" id="village_view_sub_id"/>
    <input type="hidden" id="village_view_grid_id"/>

    <div class="village_title village_desk" id="village_drag_handler"><span>小区工作台</span>

        <div class="win_operate">
            <div class="village_full_screen"></div>
            <div class="village_normal_screen" style="display:none;"></div>
            <div class="village_close" id="village_close"></div>
        </div>
    </div>

    <iframe id="village_info_win_body" style="width:100%;height:415px;border:0"></iframe>

</div>
<!-- 政企校园工作台 -->
<div class="village_info_win new_beta leader" id="schoolOrEnterprise_info_win" style="display: none;width:650px">

    <div class="village_title village_desk" id="schoolOrEnterprise_drag_handler"><span>工作台</span>

        <div class="win_operate">
            <div class="village_full_screen"></div>
            <div class="village_normal_screen" style="display:none;"></div>
            <div class="village_close" id="schoolOrEnterprise_close"></div>
        </div>
    </div>

    <iframe id="schoolOrEnterprise_info_win_body" style="width:100%;height:380px;border:0"></iframe>

</div>


<!-- 小区查看弹窗END -->
<div id="village_paint_div"></div>
<!-- 小区营销弹窗 -->
<div class="build_more_win" id="village_market_detail" style="display: none;position:absolute;z-index:99999999999888;">
    <div class="target_dev" style="width: 100%">
        <div class="village_title"><span id="village_title">营销清单</span>

            <div class="village_close" id="vvv" onclick="village_close_fun()"></div>
        </div>
        <iframe width="100%" height="100%" name="market_detail_id" id="market_detail_id"></iframe>
    </div>
</div>
<!-- 自定义营销弹窗 -->
<div class="build_more_win" id="yx_market_detail" style="display: none;position:absolute;z-index:99999999999888;">
    <div class="target_dev" style="width: 100%">
        <div class="village_title"><span id="yx_market_detail_title">营销清单</span>

            <div class="village_close" id="vvv" onclick="yx_market_detail_close_fun()"></div>
        </div>
        <iframe width="100%" height="100%" name="yx_market_detail_id" id="yx_market_detail_id"></iframe>
    </div>
</div>
<!-- 楼宇营销弹窗 -->
<div class="build_more_win" id="build_market_detail" style="display: none;position:absolute;z-index:99999999999888;">
    <div class="target_dev" style="width: 100%">
        <div class="village_title"><span id="build_market_detail_title">营销清单</span>

            <div class="village_close" id="vvv" onclick="build_market_detail_close_fun()"></div>
        </div>
        <iframe width="100%" height="100%" name="build_market_detail_id" id="build_market_detail_id"></iframe>
    </div>
</div>

<!-- 小区框选功能弹窗 -->
<!-- 小区框选功能弹窗 -->
<div id="buildInVillage_review_win" class="village_info_win" style="position:absolute;z-index:999;display:none;">
    <div class="village_title" id="yingxiao_info_new_title"><span id="yingxiao_title">小区编辑</span>

        <div class="village_close" id="" onclick="javascript:cancleBuildInVillage()"></div>
    </div>
    <div class="target_a" style="border-bottom:none;">
        <h3 class="wrap_a tab_menu" style="border-left:0;"><span
                style="cursor:pointer;" class="selected">归属信息</span>
        </h3>
        <div class="bulid_village_btn">
            <button onclick="javascript:saveBuildInVillage(this)" id="saveBuildInVillageBtn">保存</button>
            <button onclick="javascript:cancleBuildInVillage()">取消</button>
        </div>
    </div>
    <div class="tab_box">
        <div>
            <div class="target_a" style="border-bottom:none;">
                <div class="base1">
                    小区名称：<input id="village_name" type="text"/>
                    <div class="message_cont">
                        <div>地市：<span id="village_in_city"></span></div>
                    </div>
                </div>
                <h3 class="wrap_a" style="margin-top:5px;margin-bottom:0px;">统计信息</h3>

                <div class="base1">
                    <div class="message_cont">
                    	 <div>楼宇总数： <span id="village_builds_total"></span></div>
                    	 <div>住户数： <span id="village_people_total"></span></div>
                        <div>宽带用户： <span id="village_new_kd_sum"></span></div>
                        <div>宽带家庭渗透率： <span id="broad_home_percent">--</span></div>
                    </div>
                </div>
                  <h3 class="wrap_a" style="margin-top:5px;margin-bottom:0px;">收集信息</h3>

                <div class="base1">
                    <div class="message_cont">
                        <div>
                            类型：
                            <select id="village_scale">

                            </select>
                        </div>
                    </div>
                    进线运营商：
                  	<input style="margin-left:5px" class="radio_none"  id="none_jx" type="radio" name="none" value="0" checked="checked"/>无
                 	       <span class="jx">
                               <input class="checkb" id="dx_jx" type="checkbox" name="dx" value="1" />电信
                 	  		<input class="checkb" id="yd_jx" type="checkbox" name="yd" value="2"  />移动
                 	  		<input class="checkb" id="lt_jx" type="checkbox" name="lt" value="3" />联通
                 	  		<input class="checkb" id="gd_jx"  type="checkbox" name="gd" value="4" />广电
                 	  		<input class="checkb"  id="qt_jx" type="checkbox" name="qt" value="5" />其他
                 	         </span>
                    进线运营商数：<span id="jx_num">--</span>
                </div>
                <h3 class="wrap_a">楼宇列表<span class="add_item" onclick="javascript:cancleBuildInVillage()"
                                             style="margin:0;float:right;">&nbsp;</span></h3>

                <input type="hidden" id="village_in_sub_id"/>
                <input type="hidden" id="village_in_grid_id"/>
                <input type="hidden" id="village_new_center"/>
                <input type="hidden" id="village_in_grid_id_short"/>

            </div>
            <div style="width:100%;padding-right:17px;">
                <table class="build_village_tab">
                    <tr>
                        <th style="width: 35px;">序号</th>
                        <th style="width: 250px">四级地址</th>
                        <th style="width: 60px">住户数</th>
                        <th style="width: 60px">宽带用户</th>
                        <th style="width: 60px">OBD数</th>
                        <th style="width: 60px">营销派单</th>
                        <th style="width: 40px">操作</th>
                    </tr>
                </table>
            </div>
            <div class="build_village_layout exec_tab_body t_table" style="margin:0px auto;border:none;">
                <table id="buildInvillage_res_list" class="build_village_tab"></table>
            </div>

        </div>
        <div style="display:none;" class="competition">
            <div class="target_a" style="border-bottom:none;">
                <h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;">住户信息</h3>

                <div class="base1" style="height:36px;">
                    <table border="0" width="100%">
                        <tr>
                             <td width="33%">光网覆盖：<input type="radio" name="h_is_cover" value="1"/>是  &nbsp;&nbsp;<input type="radio" name="h_is_cover" checked="checked" value="0"/>否</td>
                            <td width="33%"><span class="comp">实际住户数:</span> <input type="text" class="number"
                                                                                    name="real_home_num"/></td>
                            <td width="33%"><span class="comp">人口数:</span> <input type="text" class="number"
                                                                                  name="people_num"/></td>
                        </tr>
                    </table>
                </div>
                <h3 class="wrap_a" style="margin-top:5px;">竞争情况</h3>

                <div>
                    <table border="0" width="100%">
                        <tr>
                            <td width="33%">
                                <div class="quota"><span>电信独家进线：</span><select id="village_new_dx_only"
                                                                               class="list_select"
                                                                               style="width: 66px;margin-left: 6px">
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select></div>
                            </td>
                            <td width="33%">
                                <div class="quota"><span>电信光网覆盖：</span><select id="village_new_dxgw_cover"
                                                                               class="list_select"
                                                                               style="width: 66px;margin-left: 6px">
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select></div>
                            </td>
                        </tr>
                        <tr>
                            <td width="33%">
                                <div class="quota"><span>移动光网覆盖：</span><select id="village_new_ydgw_cover"
                                                                               class="list_select"
                                                                               style="width: 66px;margin-left: 6px">
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select></div>
                            </td>
                            <td width="33%">
                                <div class="quota"><span>联通光网覆盖：</span><select id="village_new_ltgw_cover"
                                                                               class="list_select"
                                                                               style="width: 66px;margin-left: 6px">
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select></div>
                            </td>
                            <td width="33%">
                                <div class="quota"><span>广电光网覆盖：</span><select id="village_new_gdgw_cover"
                                                                               class="list_select"
                                                                               style="width: 66px;margin-left: 6px">
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select></div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="devep village_new_base">
                    <div class="deve_ta">
                        电信
                    </div>
                    <div class="deve_tb" style="padding-top:12px;">
                        <table border="0" width="100%">
                            <tr>
                                 <td><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">电信独家进线: <input type="radio" name="only_telecom_line"  value="1" />是  &nbsp;&nbsp;<input type="radio" checked="checked" name="only_telecom_line"  value="0"/>否<span class="comp"></span></span></div></td>
                                <td width="35%">
                                    <div class="quota"><span style="color: #9ebaf1">•</span><span
                                            style="margin-left:5px">移动用户：<span id="village_new_dxyd_count"
                                                                               style="color:#FF9214;font-weight:bold!important;"></span></span>
                                    </div>
                                </td>
                                <td width="33%">
                                    <div class="quota"><span>宽带用户：<span id="village_new_dxkd_count"
                                                                        style="color:#FF9214;font-weight:bold!important;"></span></span>
                                    </div>
                                </td>
                                <td width="">
                                    <div class="quota"><span style="margin-left: 10px">电视用户：<span
                                            id="village_new_dxds_count"
                                            style="color:#FF9214;font-weight:bold!important;"></span></span></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="deve_ta">
                        移动
                    </div>
                    <div class="deve_tb text_input" style="padding-top:12px;">
                        <table border="0" width="100%">
                            <tr>
                                <td width="35%">
                                    <div class="quota"><span style="color: #9ebaf1">•</span><span
                                            style="margin-left: 5px">移动用户：<input type="text"
                                                                                 name="village_new_ydyd_count"/></span>
                                    </div>
                                </td>
                                <td width="33%">
                                    <div class="quota"><span>宽带用户：<input type="text"
                                                                         name="village_new_ydkd_count"/></span></div>
                                </td>
                                <td>
                                    <div class="quota"><span style="margin-left: 10px">电视用户：<input type="text"
                                                                                                   name="village_new_ydds_count"/></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="deve_ta">
                        联通
                    </div>
                    <div class="deve_tb text_input" style="padding-top:10px;">
                        <table border="0" width="100%">
                            <tr>
                                <td width="35%">
                                    <div class="quota"><span style="color: #9ebaf1">•</span><span
                                            style="margin-left: 5px">移动用户：<input type="text"
                                                                                 name="village_new_ltyd_count"
                                                                                 style="width:40px;"/></span></div>
                                </td>
                                <td width="33%">
                                    <div class="quota"><span>宽带用户：<input type="text" name="village_new_ltkd_count"
                                                                         style="width:40px;"/></span></div>
                                </td>
                                <td>
                                    <div class="quota"><span style="margin-left: 10px">电视用户：<input type="text"
                                                                                                   name="village_new_ltds_count"
                                                                                                   style="width:40px;"/></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="deve_ta">
                        广电
                    </div>
                    <div class="deve_tb text_input" style="padding-top:10px;">
                        <table border="0" width="100%">
                            <tr>
                                <td width="35%">
                                    <div class="quota"><span style="color: #9ebaf1">•</span><span
                                            style="margin-left: 5px">宽带用户：<input type="text"
                                                                                 name="village_new_gdkd_count"
                                                                                 style="width:40px;"/></span></div>
                                </td>
                                <td width="33%">
                                    <div class="quota"><span>电视用户：<input type="text" name="village_new_gdds_count"
                                                                         style="width:40px;"/></span></div>
                                </td>
                                <td>
                                    <div class="quota"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 鼠标悬浮楼宇、小区上，显示名称的半透明tip -->
<div class="village_info_mini_win" id="village_info_mini_win"
     style="display:none;position:absolute;z-index:100;background:rgba(0,0,0,0.5);border-radius:5;color:#fff;">

</div>
<!-- 渠道网点弹窗 -->
<div id="channel_info_win"
     style="display:none;background-color: #fff;position: fixed;top: 40%;left: 26%;z-index: 99999999999;width: 300px;height: 180px;border: 2px solid #2070dc;border-radius: 4px">
    <span style="font-weight: bold;color: red;padding-top: 20px">店名：</span><em style="color: red;"></em>
    <br>
    <span style="font-weight: bold;margin-top: 20px">地址：</span><em></em>
    <br>
    <span style="font-weight: bold;margin-top: 20px">类型：</span><em></em>
    <table style="width: 98%;font-size: 14px;text-align: center" ;>
        <tr>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf  "></td>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;border-right:1px solid #bab9cf">
                当月
            </td>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-top:1px solid #bab9cf;padding-top: 2px;">
                当日
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                移动
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;"><em></em></td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                宽带
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
        </tr>
        <tr>
            <td style="font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                itv
            </td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right:1px solid #bab9cf">
                <em></em></td>
            <td style="border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center"><em></em></td>
        </tr>
    </table>
</div>

<div id="village_summary_list_pop_win" style="display:none;">
	<iframe style="width:100%;height:100%;"></iframe>
</div>

<!-- 营销查看弹窗 -->
<!--<div class="village_info_win new_beta" id="yingxiao_info_win_new" style="display: none;">
	<div class="village_title" id="yx_drag_handler"><span>营销查看</span><div class="village_close" id="yingxiao_view_close"></div></div>
	<div class="village_name_new" id="yx_view_title"></div>
	<input type="hidden" id="yx_view_yx_id" />
  <h3 class="wrap_a tab_menu" style="border-left:none;margin-left:15px;"><span style="cursor:pointer;" class="selected">概况</span> | <span style="cursor:pointer;">清单</span></h3>

  <div class="tab_box">

  	<div style="padding-top:10px;">
  		<div class="devep village_new_base">
  				<div class="deve_ta">
  						基础
  				</div>
  				<div class="deve_tb" style="padding-top:13px;">
  					<table border="0" width="100%">
  						<tr>
  							<td width="50%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">创建人：<span id="yx_view_creator"></span></span></div></td>
  							<td><div class="quota"><span>创建时间：<span id="yx_view_create_time"></span></span></div></td>
  						</tr>
  					</table>
  				</div>
  				<div class="deve_ta">
  						业务
  				</div>
  				<div class="deve_tb" style="padding-top:12px;">
  					<table border="0" width="100%">
  						<tr>
  							<td width="25%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">移动用户：<span id="yx_view_yd_count"></span></span></div></td>
  							<td width="25%"><div class="quota"><span>宽带用户：<span id="yx_view_kd_count"></span></span></div></td>
  							<td width="25%"><div class="quota"><span>电视用户：<span id="yx_view_ds_count"></span></span></div></td>
  							<td width="25%"></td>
  						</tr>
  					</table>
  				</div>
  				<div class="deve_ta">
  						市场
  				</div>
  				<div class="deve_tb" style="padding-top:13px;">
  					<table border="0" width="100%">
  						<tr>
  							<td width="25%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">市场占有率：<span id="yx_view_market_lv" style="color:#FF9214;"></span></span></div></td>
  							<td width="25%"><div class="quota"><span>楼宇数：<span id="yx_view_build_count"></span></span></div></td>
  							<td width="25%"><div class="quota"><span>住户数：<span id="yx_view_zhu_hu"></span></span></div></td>
  							<td width="25%"></td>
  						</tr>
  					</table>
  				</div>
  				<div class="deve_ta">
  						资源
  				</div>
  				<div class="deve_tb" style="padding-top:13px;">
  					<table border="0" width="100%">
  						<tr>
  							<td width="25%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">端口占用率：<span id="yx_view_port_lv" style="color:#FF9214;"></span></span></div></td>
  							<td width="25%"><div class="quota"><span>总端口：<span id="yx_view_port"></span></span></div></td>
  							<td width="25%"><div class="quota"><span>占用端口：<span id="yx_view_port_used"></span></span></div></td>
  							<td width="25%"><div class="quota"><span>空闲端口：<span id="yx_view_free_port"></span></span></div></td>
  						</tr>
  					</table>
  				</div>
  		</div>
  	</div>


  	<div style="display:none;" >
  		<div class="village_new_searchbar">
  		  <div>记录数：<span id="yx_view_yx_record_count"></span></div><div>四级地址：<input type="text" id="yx_view_yx_search_add4" class="search_input" /><button id="yx_view_yx_search_btn">查询</button></div>
  		</div>

  		<div class="village_m_tab" style="width:98%;padding-right:17px;">
        <table  class="content_table"  style="width:100%;margin:0px auto;">
        	<tr>
            <th width="24" rowspan=2>序号</th>
            <th width="198" rowspan=2>四级地址</th>
          	<th width="38" rowspan=2 style="color:#4472C4;">住户数</th>
            <th colspan=2>资源</th>
            <th colspan=3>业务</th>
            <th colspan=4>营销</th>
					</tr>
					<tr>
						<th width="39">总端口</th><th width="48">空闲<br/>端口</th>
						<th width="31">宽带</th><th width="31">电视</th><th width="31">固话</th>
						<th width="34" style="color:#4472C4;">总数</th><th width="34">已执行</th><th width="34">未执行</th><th>执行率</th>
					</tr>
			  </table>
			</div>
			<div  class="village_m_tab9" style="width:97.5%;">
			  <table class="content_table" id="yx_view_yx_list"  style="width:100%;margin:0px auto;">

			  </table>
			</div>
  	</div>
  </div>
</div>-->
<!-- 营销查看弹窗END -->

<!-- 营销新建弹窗 已废弃-->
<!--<div id="yingxiao_info_win" class="village_info_win new_beta" style="display: none">
  <div class="village_title" id="yingxiao_info_title"><span>营销新建</span>
        <div class="village_close" id="yingxiao_close"></div>
  </div>
  <div class="target_a" style="border-bottom:none;">
     <h3 class="wrap_a">基本信息</h3>
     <div style="float:right;">
        <button id="yingxiao_baocun">保存</button>
        <button id="cancelYXnew">取消</button>
    </div>
    营销名称：<span><input type="text" id ="yx_new_yx_name" /></span>
    创建人： <span id="yx_new_creator"></span>
  </div>
  <div class="target_a" style="border-bottom:none;">
     <h3 class="wrap_a">统计信息</h3>
     <div class="base1" style="height:72px;">
					移动用户： <span id="yx_new_yd_sum"></span>宽带用户： <span id="yx_new_kd_sum"></span>电视用户： <span id="yx_new_ds_sum"></span>住户数： <span id="yx_people_total"></span><br/>
					楼宇总数： <span id="yx_new_builds_total"></span>端口占用率： <span id="yx_new_port_used_rate"></span>总端口： <span id="yx_new_port_total"></span>空闲端口： <span id="yx_new_port_free"></span>
		 </div>
  </div>
  <div class="target_a" style="border-bottom:none;">
     <h3 class="wrap_a">楼宇列表</h3>
     <div class="village_m_tab">
        <table class="content_table" style="width:100%;">
            <tr>
                <th width="30">序号</th>
                <th width="240">四级地址</th>
                <th width="30">住户数</th>
                <th width="30">总端口</th>
                <th width="30">空闲<br/>端口</th>
                <th width="30">宽带</th>
                <th width="30">电视</th>
                <th width="30">固话</th>
                <th width="45">营销<br/>派单</th>
                <th>操作</th>
            </tr>
        </table>
        </div>
        <div class="village_m_tab4">
        <table class="content_table" style="width:100%;" id="yx_new_four_address_list">

        </table>
     </div>
  </div>
  <input type="hidden" id="wktstr" />
</div>-->

<!-- 营销新建，合并的形式↓-->
<div id="yingxiao_new_win" class="village_info_win new_beta" style="display: none">
    <div class="village_title" id="yingxiao_info_title"><span>现场营销</span>

        <div class="village_close" id="yingxiao_close"></div>
    </div>
    <!--<div class="target_a" style="border-bottom:none;">
     <h3 class="wrap_a">基本信息</h3>
     <div style="float:right;">
        <button id="yingxiao_baocun">保存</button>
        <button id="cancelYXnew">取消</button>
    </div>
    营销名称：<span><input type="text" id ="yx_new_yx_name" /></span>
    创建人： <span id="yx_new_creator"></span>
  </div>-->
    <div class="target_a" style="border-bottom:none;display:none;">
        <h3 class="wrap_a">统计信息</h3>

        <div class="base1" style="height:72px;">
            移动用户： <span id="yx_new_yd_sum"></span>宽带用户： <span id="yx_new_kd_sum"></span>电视用户： <span
                id="yx_new_ds_sum"></span>住户数： <span id="yx_people_total"></span><br/>
            楼宇总数： <span id="yx_new_builds_total"></span>端口占用率： <span id="yx_new_port_used_rate"></span>总端口： <span
                id="yx_new_port_total"></span>空闲端口： <span id="yx_new_port_free"></span>
        </div>
    </div>
    <div class="target_a" style="border-bottom:none;">
        <!--<h3 class="wrap_a">楼宇列表</h3>-->
        <!--<div>查询条件</div>-->
        <div class="village_new_searchbar creat_bar" style="border:none;margin-top:12px;">
            <div class="count_num">记录数：<span id="yx_new_build_record_count"></span></div>
            <div>四级地址：<input type="text" id="yx_new_build_search_add4" class="search_input"/>
                <button id="yx_new_build_search_btn">查询</button>
            </div>
        </div>
        <div class="village_m_tab" style="margin-left:0px;width:616px;">
            <table class="content_table" style="width:100%;">
                <tr>
                    <th width="30" rowspan=2>序号</th>
                    <th width="225" rowspan=2>四级地址</th>
                    <th width="45" rowspan=2>住户数</th>
                    <th width="30" colspan=2>资源</th>
                    <th width="30" colspan=3>业务</th>
                    <th width="45" colspan=3>营销</th>
                    <!--<th  rowspan=2>操作</th>-->
                </tr>
                <tr>
                    <th width="42">总端口</th>
                    <th width="52">空闲端口</th>
                    <th width="30">宽带</th>
                    <th width="30">电视</th>
                    <th width="30">固话</th>
                    <th width="30">总数</th>
                    <th width="42">未执行</th>
                    <th>执行率</th>
                </tr>
            </table>
        </div>
        <div class="village_m_tab4">
            <table class="content_table" style="width:100%;" id="yx_new_four_address_list">

            </table>
        </div>
    </div>
    <input type="hidden" id="wktstr"/>
</div>
<!-- 营销新建，合并的形式↑

<!-- 营销新建，三个标签的形式↓ id="yingxiao_new_win"-->
<!--<div class="village_info_win new_beta" id="yingxiao_new_win" style="display: none;">
	<input type="hidden" id="segmid_for_yx_save_hide" />
	<div class="village_title" id="yx_drag_handler"><span>位置营销</span><div class="village_close" id="yingxiao_new_close"></div></div>
  <h3 class="wrap_a tab_menu" style="border-left:none;margin-left:15px;"><span style="cursor:pointer;" class="selected">概况</span> | <span style="cursor:pointer;">清单</span> | <span style="cursor:pointer;">营销</span></h3>

  <div class="tab_box">
  	<!--概况-->
<!--<div style="padding-top:10px;">
  		<div class="devep village_new_base">
  				<div class="deve_ta">
  						业务
  				</div>
  				<div class="deve_tb" style="padding-top:16px;">
  					<table border="0" width="100%">
  						<tr>
  							<td width="32%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">移动用户：<span id="yx_new_yd_sum"></span></span></div></td>
  							<td width="23%"><div class="quota"><span>宽带用户：<span id="yx_new_kd_count"></span></span></div></td>
  							<td><div class="quota"><span>电视用户：<span id="yx_new_ds_sum"></span></span></div></td>

  						</tr>
  					</table>
  				</div>
  				<div class="deve_ta">
  						市场
  				</div>
  				<div class="deve_tb" style="padding-top:13px;">
  					<table border="0" width="100%">
  						<tr>
  							<td width="32%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">市场占有率：<span id="yx_new_market_lv" style="color:#FF9214;"></span></span></div></td>
  							<td width="23%"><div class="quota"><span>楼宇数：<span id="yx_new_builds_total"></span></span></div></td>
  							<td><div class="quota"><span>住户数：<span id="yx_new_zhu_hu_shu"></span></span></div></td>

  						</tr>
  					</table>
  				</div>
  				<div class="deve_ta">
  						资源
  				</div>
  				<div class="deve_tb" style="padding-top:13px;">
  					<table border="0" width="100%">
  						<tr>
  							<td width="32%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">端口占用率：<span id="yx_new_port_used_rate" style="color:#FF9214;"></span></span></div></td>
  							<td width="23%"><div class="quota"><span>总端口：<span id="yx_new_port_total"></span></span></div></td>
  							<td><div class="quota"><span>空闲端口：<span id="yx_new_port_free"></span></span></div></td>
  						</tr>
  					</table>
  				</div>
  		</div>
  	</div>

  	<!--楼宇信息清单-->
<!--<div style="display:none;" >
  		<div class="village_new_searchbar">
  		  <div class="count_num">记录数：<span id="yx_new_build_record_count"></span></div><div>四级地址：<input type="text" id="yx_new_build_search_add4" class="search_input" /><button id="yx_new_build_search_btn">查询</button></div>
  		</div>
  		<!--表头-->
<!--<div class="village_m_tab" style="width:98%;padding-right:17px;">
        <table  class="content_table"  style="width:100%;margin:0px auto;">
        	<tr>
            <th width="29" rowspan=2>序号</th>
            <th width="198" rowspan=2>四级地址</th>
          	<th width="38" rowspan=2 >住户数</th>
            <th colspan=2>资源</th>
            <th colspan=3>业务</th>
					</tr>
					<tr>
						<th width="39">总端口</th><th width="48">空闲<br/>端口</th>
						<th width="31">宽带</th><th width="31">电视</th><th width="31">固话</th>
					</tr>
			  </table>
			</div>
			<div  class="village_m_tab9" style="width:97.5%;">
			  <table class="content_table" id="yx_new_build_list"  style="width:100%;margin:0px auto;">

			  </table>
			</div>
  	</div>

  	<!--营销信息清单-->
<!--<div style="display:none;">
  		<div class="village_new_searchbar">
  		  <div class="count_num">记录数：<span id="yx_new_yx_record_count"></span></div><div>四级地址：<input type="text" id="yx_new_yx_search_add4" class="search_input" /><button id="yx_new_yx_search_btn">查询</button></div>
  		</div>
  		<!--表头-->
<!--<div class="village_m_tab" style="width:98%;padding-right:17px;">
        <table  class="content_table"  style="width:100%;margin:0px auto;">
        	<tr>
            <th width="29" rowspan=2>序号</th>
            <th width="308" rowspan=2>四级地址</th>
            <th colspan=4>营销</th>
					</tr>
					<tr>
						<th width="50">总数</th><th width="50">已执行</th><th width="50">未执行</th><th>执行率</th>
					</tr>
			  </table>
			</div>
			<div  class="village_m_tab10" style="width:97.5%;">
			  <table class="content_table" id="yx_new_yx_list"  style="width:100%;margin:0px auto;">

			  </table>
			</div>
  	</div>
  </div>
</div>-->
<!-- 营销新建，三个标签的形式↑ -->

<div id="leida_div"></div>
<%--列表--%>
<div id="list_div" style="display: none;height: 100%">
    <div style="overflow: hidden;">
        <div style="margin-top: 5px">
            <div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
            <div class="list_search">
                <div style="margin-top:5px">
                    <div style="margin-left: 5px;display: inline-block;line-height: 26px;font-size:12px">分公司:</div>
                    <select id="br_city" class="list_select" style="width: 66px;margin-left: 6px">
                        <option value="">全部</option>
                    </select>

                    <div style="margin-left: 10px;display: inline-block;font-size:12px">区&nbsp&nbsp县:</div>
                    <select id="br_area" class="list_select" style="width: 93px;;margin-left: 5px">
                        <option value="">全部</option>
                    </select>
                </div>
                <div style="margin-bottom: 2px">
                    <div style="margin-left: 7px;display: inline-block;font-size:12px">支&nbsp&nbsp局:</div>
                    <input type="text" id="b_branch_name" placeholder="输入支局名称"
                           style="width: 140px;margin: 5px;margin-left:8px;height:26px!important;font-size:12px">
                    <button id="branch_query" class="btn_uc" style="font-size:12px">查&nbsp&nbsp询</button>
                </div>

            </div>
            <div>
                <div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
                <div class="list_search" style="padding: 5px;">
                    <span style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px"
                                                               id="tacount1"></span><span
                        style="font-size:12px">个支局，未上图</span><span style="color:red;font-size:12px"
                                                                   id="tacount2"></span><span
                        style="font-size:12px">个</span>
                </div>
            </div>
        </div>
    </div>

    <div style="color: #fff; background-color: #8ed2ff; position:fixed;top:208px;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold">
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
                    <div class="list_text">分公司:</div>
                    <select id="g_city" class="list_select" style="width: 70px;margin-left:5px">
                        <option value="">全部</option>
                    </select>

                    <div class="list_text" style="margin-left:10px">区&nbsp&nbsp县:</div>
                    <select id="g_area" class="list_select" style="width: 86px;;margin-left: 5px">
                        <option value="">全部</option>
                    </select>
                </div>
                <div style="margin-left: 5px;margin-top:5px">
                    <div class="list_text">支&nbsp&nbsp局:</div>
                    <select id="g_branch" class="list_select" style="width: 210px;margin-left: 10px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div style="margin-left: 5px">
                    <div class="list_text">网&nbsp&nbsp格:</div>
                    <input type="text" id="g_grid_name" placeholder="输入网格名称"
                           style="width: 130px;margin: 5px;margin-left: 10px;font-size: 12px;">
                    <button id="grid_query" class="btn_uc" style="font-size:12px">查&nbsp&nbsp询</button>
                </div>
            </div>
        </div>
        <div>
            <div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
            <div class="list_search" style="padding: 5px;">
                <span style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px"
                                                           id="gridcount1"></span><span
                    style="font-size:12px">个网格，未上图</span><span style="color:red;font-size:12px"
                                                               id="gridcount2"></span><span
                    style="font-size:12px">个</span>
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
        <div>
            <div style="color: #000;font-size: 14px;margin: 10px;display: inline-block;margin-bottom: 5px">查询条件</div>
            <button id="xinjian1" class="btn_xj">新&nbsp;&nbsp;建</button>
        </div>
        <%--<div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>--%>
        <div class="list_search">
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">分公司:</div>
                <select id="v_city" class="list_select" style="width: 70px;margin-left:8px">
                    <option value="">全部</option>
                </select>

                <div class="list_text" style="margin-left:10px">区&nbsp&nbsp县:</div>
                <select id="v_area" class="list_select" style="width: 85px;margin-left:5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top:5px">
                <div class="list_text">支&nbsp&nbsp局:</div>
                <select id="v_branch_type" class="list_select" style="width: 55px;margin-left: 8px">
                    <option value="">全部</option>
                    <option value="a1">城市</option>
                    <option value="b1">农村</option>
                </select>
                <select id="v_branch" class="list_select" style="  width: 145px;margin-left: 5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">网&nbsp&nbsp格:</div>
                <select id="v_grid" class="list_select" style="width: 210px;margin-left: 13px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-bottom: 5px">
                <div class="list_text">小&nbsp&nbsp区:</div>
                <input type="text" id="v_village_name" placeholder="输入小区名称"
                       style="width: 135px;margin-left: 13px;margin-top: 5px;font-size:12px">
                <button id="village_query" class="btn_uc" style="margin-top: 5px;font-size: 12px">查&nbsp&nbsp询</button>
            </div>
        </div>
        <div>
            <div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
            <div class="list_search" style="padding: 5px;">
                <span style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px"
                                                           id="villagecount1"></span><span
                    style="font-size:12px">个小区</span>
                <!--<button id="village_summary_list_pop_btn" class="btn_uc" style="margin:-2px 4px;font-size: 12px;float:right;">统&nbsp;&nbsp;计</button>-->
            </div>
        </div>
    </div>
    <div>
        <div style="color: #fff; background-color: #8ed2ff; position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold;    margin-top: -1px;">
            <div style='text-align: center;width: 12%;display: inline-block'>序号</div>
            <div style='text-align: center;width: 39%;display: inline-block'>网格名称</div>
            <div style='text-align: center;width: 40%;display: inline-block'>小区名称</div>
        </div>
    </div>
    <div class="td">
        <table id="village_table" class="village_table"
               style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
        </table>
    </div>
    <%--<div id="village_show" class="tb"></div>--%>
</div>

<div id="yingxiao_village_div" style="display:none;height:100%">
    <div style="overflow: hidden">
        <div>
            <div style="color: #000;font-size: 14px;margin: 10px;display: inline-block;margin-bottom: 5px">查询条件</div>
        </div>
        <div class="list_search">
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">分公司:</div>
                <select id="yx_v_city" class="list_select" style="width: 70px;margin-left:8px">
                    <option value="">全部</option>
                </select>

                <div class="list_text" style="margin-left:10px">区&nbsp&nbsp县:</div>
                <select id="yx_v_area" class="list_select" style="width: 85px;margin-left:5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top:5px">
                <div class="list_text">支&nbsp&nbsp局:</div>
                <select id="yx_v_branch" class="list_select" style="  width: 210px;margin-left: 13px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">网&nbsp&nbsp格:</div>
                <select id="yx_v_grid" class="list_select" style="width: 210px;margin-left: 13px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-bottom: 5px">
                <div class="list_text">小&nbsp&nbsp区:</div>
                <input type="text" id="yx_v_village_name" placeholder="输入小区名称"
                       style="width: 135px;margin-left: 13px;margin-top: 5px;font-size:12px">
                <button id="yx_village_query" class="btn_uc" style="margin-top: 5px;font-size: 12px">查&nbsp&nbsp询
                </button>
            </div>
        </div>
        <div>
            <div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
            <div class="list_search" style="padding: 5px;">
                <span style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px"
                                                           id="yx_villagecount1"></span><span
                    style="font-size:12px">条记录</span>
                <button id="nav_marketing_btn">新&nbsp;&nbsp;建</button>
            </div>
        </div>
    </div>
    <div>
        <div style="color: #fff; background-color: #8ed2ff; position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold;    margin-top: -1px;">
            <div style='text-align: center;width: 12%;display: inline-block'>序号</div>
            <div style='text-align: center;width: 30%;display: inline-block;text-align:left;'>小区名称</div>
            <div style='text-align: center;width: 17%;display: inline-block'>目标数</div>
            <div style='text-align: center;width: 15%;display: inline-block'>未执行</div>
            <div style='text-align: center;width: 15%;display: inline-block'>执行率</div>
        </div>
    </div>
    <div class="tf_yx_v">
        <table class="yx_village_table" style="/*display: block;*/margin-top:0px;height:88%;width:100%;">
        </table>
    </div>
</div>

<!-- 信息收集div 开始-->
<!-- 统计窗口 -->
<div class="info_collect_win" id="info_collect_summary_div" style="display:none;">
    <!--<div class="titlea">
        <div id="info_collect_summary_draggable" style='text-align:left;width:90%;display: inline-block'>收集统计</div>
        <div class="titlec" id="info_collect_summary_div_close"></div>
    </div>-->
    <iframe width="100%" height="100%"></iframe>
</div>
<!-- 列表窗口 -->
<div class="info_collect_win" id="info_collect_list_div" style="display:none;">
    <!--<div class="titlea">
        <div id="info_collect_list_draggable" style='text-align:left;width:90%;display: inline-block'>收集列表</div>
        <div class="titlec" id="info_collect_list_div_close"></div>
    </div>-->
    <iframe width="100%" height="100%"></iframe>
</div>
<!-- 收集详情 -->
<div class="info_collect_win" id="info_collect_view_div" style="display:none;">
    <!--<div class="titlea">
        <div id="info_collect_view_draggable" style='text-align:left;width:90%;display: inline-block'>收集详情</div>
        <div class="titlec" id="info_collect_view_div_close"></div>
    </div>-->
    <iframe width="100%" height="100%"></iframe>
</div>
<!-- 用户列表-->
<div id="prod_list_win">
	<iframe width="100%" height="100%" style="border:none;padding:0px;margin:0px;"></iframe>
</div>
<!-- 竞争收集 收集编辑 -->
<div class="" id="info_collect_edit_div" style="display:none;">
    <!--<div class="titlea">
        <div id="info_collect_edit_draggable" style='text-align:left;width:90%;display: inline-block'>竞争收集</div>
        <div class="titlec" id="info_collect_edit_div_close"></div>
    </div>-->
    <iframe width="100%" height="100%" style="border:none;padding:0px;"></iframe>
</div>

<!-- 信息收集div 结束-->

<div id="build_div" style="display: none;height: 100%">
    <div style="overflow: hidden">
        <div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
        <div class="list_search">
            <div style="margin-left:5px;margin-top: 5px">
                <div class="list_text">分公司:</div>
                <select id="b_city" class="list_select" style="width: 60px;margin-left:13px">
                    <option value="">全部</option>
                </select>

                <div class="list_text" style="margin-left: 10px">区&nbsp&nbsp县:</div>
                <select id="b_area" class="list_select" style="width: 84px;;margin-left:3px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top:5px">
                <div class="list_text">支&nbsp&nbsp局:</div>
                <select id="b_branch" class="list_select" style="width: 210px;margin-left: 13px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">网&nbsp&nbsp格:</div>
                <select id="b_grid" class="list_select" style="width: 210px;margin-left: 13px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left:5px;margin-bottom:5px">
                <div class="list_text">地&nbsp&nbsp&nbsp址:</div>
                <input type="text" id="b_build_name" placeholder="输入楼宇名称"
                       style="width: 126px;margin-left: 13px;margin-top: 5px;font-size:12px">
                <button id="build_query" class="btn_uc" style="margin-left: 6px;margin-top: 5px">查&nbsp;&nbsp;询</button>
            </div>
        </div>
        <div>
            <div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
            <div class="list_search" style="padding: 5px;">
                <span style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px" id="build_count"></span><span
                    style="font-size:12px">条记录</span>
            </div>
        </div>
    </div>
    <div>
        <div style="color: #fff; background-color: #8ed2ff; position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold;">
            <div style='text-align: center;width: 14%;display: inline-block'>序号</div>
            <div style='text-align: center;width: 70%;display: inline-block'>楼宇名称</div>
        </div>
    </div>
    <div class="te">
        <table id="build_table" class="build_table" style="/*display: block;*/margin-top:0px;height: 88%;width:99.6%;">
        </table>
    </div>
</div>
<div id="yingxiao_div" style="display: none;height: 100%">
    <div style="overflow:hidden;">
        <div>
            <div style="color: #000;font-size: 14px;margin: 10px;display: inline-block;margin-bottom: 5px">查询条件</div>
            <button id="xinjian" class="btn_xj">新&nbsp;&nbsp;建</button>
        </div>
        <div class="list_search" style="padding-bottom: 5px;margin-bottom: 0px">
            <div style="margin-left: 5px;margin-top: 5px;">
                <div class="list_text">分公司：</div>
                <select id="y_city" class="list_select" style="width: 60px;margin-left:5px">
                    <option value="">全部</option>
                </select>

                <div class="list_text" style="margin-left: 10px">区&nbsp;&nbsp县：</div>
                <select id="y_area" class="list_select" style="width: 75px;;margin-left:5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top:5px">
                <div class="list_text">名&nbsp;&nbsp&nbsp称：</div>
                <input type="text" id="chaxun" placeholder="输入营销名称" style="width: 115px;margin-left: 5px">
                <button id="cc" class="btn_uc" style="margin-left:10px">查&nbsp;&nbsp;询</button>
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
    <div class="tf">
        <table id="yingxiao_table" class="yingxiao_table"
               style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
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

    <a href="javascript:backToEchart()" id="nav_fanhui" class="add_backcolor" style="display:none;"></a>
    <a href="javascript:backToCity()" id="nav_fanhui_city" class="add_backcolor" style="display:none;"></a>
    <a href="javascript:backToQx()" id="nav_fanhui_qx" class="add_backcolor" style="display:none;"></a>
    <a href="javascript:backToSub()" id="nav_fanhui_sub" class="add_backcolor" style="display:none;"></a>

    <div style="position:relative;">
		  <div class="leader_tools" id="tools_scroll">
		    <ul class="nav_index_group">
		      <!--<li id="nav_index_broad_home_percent"><span></span><a href="javascript:void(0)" id="">宽带家庭渗透率</a></li>
		      <li id="nav_index_fb_cover"><span></span><a href="javascript:void(0)" id="">光网覆盖情况</a></li>
		      <li id="nav_index_fb_real_percent"><span></span><a href="javascript:void(0)" id="">光网实占情况</a></li>
		      <li id="nav_index_dispatch_yx"><span></span><a href="javascript:void(0)" id="">精准派单营销</a></li>
		      <li id="nav_index_collect"><span></span><a href="javascript:void(0)" id="">竞争信息收集</a></li>
		      <li id="nav_index_protection"><span></span><a href="javascript:void(0)" id="">宽带存量保有</a></li>
		      <li id="nav_index_village_detail"><span></span><a href="javascript:void(0)" id="">小区清单明细</a></li>-->

		      <li id="nav_type_village"><span></span><a href="javascript:void(0)" id="">小区</a></li>
		      <li id="nav_type_school"><span></span><a href="javascript:void(0)" id="">校园</a></li>
		      <li id="nav_type_enterprise"><span></span><a href="javascript:void(0)" id="">商客</a></li>
		      <e:if condition="${sessionScope.UserInfo.LOGIN_ID eq 'gsdx'}">
		      <li id="nav_func_xinjian1"><span></span><a href="javascript:void(0)" id="">新建</a></li>
		      </e:if>
		      <li id="nav_func_pos_tab"><span></span><a href="javascript:void(0)" id="">清单</a></li>
		      <li id="nav_func_back"><span></span><a href="javascript:void(0)" id="">返回</a></li>
		    </ul>
		  </div>
		  <div id="gismap" name="gismap"
         style="text-align: left;background-image: url('bgg.jpg');background-repeat: no-repeat;background-size:100% 100%;-moz-background-size:100% 100%;z-index:5;"></div>
		</div>
</div>
<!-- 搜索框，已废弃 -->
<!--<div id="query_div">
    <select id="location_type">
        <option value="1">支局</option>-->
        <!--<option value="0">网格</option>-->
    <!--</select>
    <input type="text" id="location_name"/>
    <input class="button" id="location_find" value="搜索"/>
</div>-->

<!--<div id="query_div">
		关键字：<input type="text" id="acc_nbr_search_input" placeholder="请输入用户号码" style="display:inline;" />
  	<input class="button" id="acc_nbr_search_btn" value="查 询"/>
</div>-->
<div id="query_div">
    <div style="width:60px;border-right:1px solid #ccc;padding-left:0px;padding-top:3px;padding-bottom:7px;" onclick="javascript:viewRank();">
        <div style="width:100%;height:15px;"><img src="<e:url value='/pages/telecom_Index/sub_grid/image/paiming1.png' />" class="ico" style="margin-left:20px;margin-top:0px;" /></div>
        <div style="width:100%;height:15px;font-size:12px;text-align:center;">划小排名</div>
    </div>
    <div style="width:60px;padding-left:0px;padding-top:3px;padding-bottom:3px;" class="mapico" onclick="javascript:viewVillageDraw();">
        <div style="width:100%;height:15px;"><img src="<e:url value='/pages/telecom_Index/sub_grid/image/shangtu1.png' />" class="ico" style="margin-left:20px;margin-top:0px;" /></div>
        <div style="width:100%;height:15px;font-size:12px;text-align:center;">小区统计</div>
    </div>
</div>

<!--绘制工具箱-->

<div id="marketing_div" class="tools" style="width:400px;">
    <div style="width:50px;display: inline-block;line-height: 42px;margin-top:3px;color:#ffd200;font-size: 14px;margin-left: 10px;border-right: 1px solid #ccc;float: left;">
        工具栏
    </div>
    <ul class="tools_content">
        <li id="draw_range_start">
            <div class="dianxuan"></div>
            <div class="shuoming">点选框</div>
        </li>
        <li id="draw_rectangle">
            <div class="kuangxuan"></div>
            <div class="shuoming">框选</div>
        </li>
        <li id="draw_polygon">
            <div class="duobianxing"></div>
            <div class="shuoming">多边形</div>
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

<div id="village_frame_div" class="tools">
    <div style="width:50px;display: inline-block;line-height:42px;margin-top:3px;color:#ffd200;font-size: 14px;margin-left: 10px;border-right: 1px solid #ccc;    float: left;">
        工具栏
    </div>
    <ul class="tools_content">
        <li id="draw_point_tool_village">
            <div class="dianxuan1"></div>
            <div class="shuoming">点选</div>
        </li>
        <li id="draw_rectangle_tool_village">
            <div class="kuangxuan"></div>
            <div class="shuoming">框选</div>
        </li>
        <li id="draw_polygon_tool_village">
            <div class="duobianxing"></div>
            <div class="shuoming">多边形</div>
        </li>
        <li id="draw_draggable_tool_village">
            <div class="drag_map"></div>
            <div class="shuoming">拖动</div>
        </li>
        <!--<li id="draw_set">
			<div class="shezhi"></div>
			<div class="shuoming">设置</div>
		</li>-->
        <li id="draw_polygon_village_review">
            <div class="queding"></div>
            <div class="shuoming">确定</div>
        </li>
        <li id="clear_draw_village">
            <div class="chexiao"></div>
            <div class="shuoming">撤销</div>
        </li>
        <li id="exit_draw_village" onclick="tuichu(event)">
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
    <div class="shezhi_text">点选半径:</div>
    <input type="text" value="100" id="draw_half" style="width: 100px;color:#487ccb;margin-bottom: 2px"/><span
        style="font-size: 12px;color:#487ccb">米</span>
    <button class="shezhi_button" onclick="$('#draw_range_start').click();$('#draw_set').click()">确定</button>
</div>

<!--小区上图工具箱-->
<div id="village_draw_tool_div" style="width: 120px;height: 50px" onclick="javascript:tuichu(event)">
    <div style="width:50px;display: inline-block;line-height: 50px;color:#ffd200;font-size: 14px;margin-left: 10px;border-right: 1px dotted #fff;    float: left;">
        工具栏
    </div>
    <ul class="tools_content">
        <li id="exit_draw1">
            <div class="tuichu"></div>
            <div class="shuoming">退出</div>
        </li>
    </ul>
</div>
<!-- 小列表 -->
<div id="pos_tab_win" class="">
	<div style="background:#1069c9;height:35px;"><div id="pos_tab_title">校园清单</div><div class="village_close" onclick="$('#pos_tab_win').hide()"></div></div>
	<div style="height:23px;width:280px;padding-left:5px;"><span style="display:inline-block;">记录数：</span><span id="pos_tab_total_num" style="display:inline-block;"></span></div>
	<div style="padding-right:19px;padding-left:5px;background: none;">
		<table id="pos_tab_thead">
			<tr><th>序号</th><th id="pos_tab_name">校园名称</th><th>市场渗透率</th></tr>
		</table>
	</div>
	<div class="t_body" id="pos_tab_div">
		<table id="pos_tab_tbody">

		</table>
	</div>
</div>

</body>
</html>
<script type="text/javascript">
		$("#pos_tab_div").height($("#pos_tab_win").height()-35-25-23-7);
		/*显示小列表*/
		$("#pos_tab_win").show();

		parent.hideRightDiv();

    parent.global_is_inside = true;
    //parent.toggleModelButton();//隐藏左上角的地图排名按钮
    var flag_set = false;
    //区县线条配色
    /*	var qx_all_line_color = [32,112,220,1];//所有区县的轮廓线颜色
     var qx_selected_line_color = [255,89,35,1];//选中的区县的描边颜色*/
    var qx_all_line_color = [44, 169, 253, 1];//所有区县的轮廓线颜色
    var qx_selected_line_color = [44, 169, 253, 1];//选中的区县的描边颜色

    //区县线条宽度
    var qx_all_line_width = 1.5;//所有区县的轮廓线宽度
    var qx_selected_line_width = 3;//选中的区县的描边宽度

    //选中的支局
    var sub_selected_line_color = [255, 146, 20, 1];//选中的支局的轮廓线颜色
    var sub_selected_line_width = 3;//选中的支局的描边宽度
    var sub_selected_fill_color = [0, 255, 6];//选中的支局的填充色

    //选中的网格
    var grid_selected_line_color = [255, 146, 20, 1];//选中的网格的轮廓线颜色
    var grid_selected_line_width = 4;//选中的网格的描边宽度
    var grid_selected_fill_color = [0, 255, 6];//选中的网格的填充色

    //悬浮的支局
    var highlight_sub_mouse_over_color = [255, 210, 0];//高亮填充色
    var highlight_sub_mouse_over_line_width = 2;

    //悬浮的网格
    var highlight_grid_mouse_over_color = [255, 210, 0];//高亮填充色
    var highlight_grid_mouse_over_line_width = 2;

    //支局下钻后，包含网格时，支局的轮廓线
    /*var sub_has_grid_self_line_color = [50,50,128,1];//支局的轮廓线线条颜色
     var sub_has_grid_self_line_width = 2;//支局的轮廓线线条宽度*/
    var sub_has_grid_self_line_color = [44, 169, 253, 1];//支局的轮廓线线条颜色
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
        [0, 198, 255, 0.4],
        [240, 156, 160, 0.4],
        [72, 241, 231, 0.4],
        [35, 255, 166, 0.4],
        [54, 193, 0, 0.4],
        [239, 159, 194, 0.4],
        [0, 217, 86, 0.4],
        [33, 168, 230, 0.4],
        [143, 251, 16, 0.4]
    ];//网格的轮廓线配色
    var grid_line_color = [141, 141, 139, 1];
    //var grid_line_color = [44,169,253,1];
    //var grid_line_color = [224,224,224,1];//浅灰色
    var grid_line_width = 2;//网格的轮廓线宽度

    var sub_none_grid_text_color = [36, 49, 222];//显示“未划配网格”提示字的颜色

    var qx_text_color = [140, 19, 13];//区县名称

    var sub_name_text_color = [105, 108, 116];//支局名文字颜色
    var grid_name_text_color = [31, 34, 34];//网格名文字颜色

    var grid_name_text_selected_color = [128, 81, 34];//网格名文字颜色，网格选中时

    //绘制工具绘制图案的配色
    var draw_line_color = [234, 0, 61];//绘制工具 划线 线条配色 rgb
    var draw_line_width = 2;//绘制工具 划线 线条粗细 越大越粗
    var draw_fill_color = [10, 10, 10, 0.3];//绘制工具 封闭多边形填充色 rgba

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

    var global_position = parent.global_position;
    var city_full_name = global_position[1];//兰州市
    var area_full_name = parent.global_current_full_area_name;//城关区
    var area_name = parent.global_current_area_name;//城关区


    var backToCity = parent.backToCity;
    var backToQx = parent.backToQx;
    var backToSub = parent.backToSub;

    var city_name = "";//城市短名称，去市、州
    if (city_name_speical.indexOf(city_full_name) > -1)
        city_name = city_full_name.replace(/州/gi, '');
    else
        city_name = city_full_name.replace(/市/gi, '');

    var city_id = city_ids[city_name];
    parent.global_current_city_id = city_id;
    var map_id = map_id_in_gis[city_id];
    var index_type = parent.global_current_index_type;
    var flag = parent.global_current_flag;

    var region_type = parent.global_region_type;
    if(region_type==undefined)
		    	region_type = "sub";
    parent.global_region_id = global_position[2];

    //if (zxs[city_full_name] != undefined)//嘉峪关特殊处理
        parent.updatePosition(flag);
    var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
    var url4Query_leader = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_leader.jsp"/>';
    var url4Query_enterprise = '<e:url value="/pages/telecom_Index/common/sql/tabData_enterprise.jsp"/>';

    var colorflow = [[68, 169, 254], [1, 1, 89]];
    var colorflow_grid = [[68, 169, 254], [1, 1, 89]];//[[109,252,146],[39,255,80]];

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
        "947": {
            "昌盛支局": 1,
            "东安支局": 1,
            "四零四支局": 1,
            "永乐支局": 1,
            "新华支局": 1
        },
        "932": {
            "陇西北城支局": 1,
            "陇西东城支局": 1
        }
    };

    var sub_selected_ext = "";

    var clickToSub = "";
    var operateVillage = "";
    var pos_bus = "";
    var skip = '';
    //选择框联动 小区
    var setCitys;
    var setBranchs = '';
    var setGrids = '';
    //选择框联动 楼宇
    var setBuildCity = '';
    var setBuildArea = '';
    var setBuildStreet = '';
    //选择框联动 网格;
    var setGArea = '';
    var setGBranch = '';

    //框选楼宇结果中，操作列表的方法
    var addItemToBuildInVillage = "";
    var removeItemFromBuildInVillage = "";

    var saveBuildInVillage = "";
    var editBuildInVillage = "";
    var deleteBuildInVillage = "";
    //营销
    var type_xy = '';
    var x = '';
    var y = '';
    var radius = '';
    var xmax = '';
    var xmin = '';
    var ymax = '';
    var ymin = '';

    var standard_position_load = '';
    var showBuildDetail = '';

    var tuichu = '';
    var segmid_for_yx_save = "";
    var segmid_for_yx_save_array = "";
    var global_village_id = parent.global_village_id;
    var global_position_build_view = "";

    var openWinInfoCollectionList = "";
    var openWinInfoCollectionView = "";
    var openWinInfoCollectEdit = "";
    var openNewWinInfoCollectEdit = "";
    var closeWinInfoCollectionEdit = "";

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

    var tiled = "";
    var featureLayer = "";
    var featureLayer_grid = "";
    var graLayer_zjname = "";
    var graLayer_zj_click = "";
    var graLayer_wg_click = "";
    var grid_name_temp_layer = "";
    var graLayer_sub_mouseover = "";
    var graLayer_qx_all = "";
    var graLayer_qx = "";
    var graLayer_mouseclick = "";
    var graLayer_subname_result = "";
    var graLayer_wg = "";
    var graLayer_wg_for_village = "";
    var graLayer_grid_mouseover = "";
    var graLayer_wg_text = "";
    var graLayer_wd = "";
    var standard_layer = "";

    var village_position_layer = "";
    //小区图层
    var village_layer = "";
    var draw_layer = "";
    var position_layer = "";

    var village_service_load = "";
    var school_service_load = "";
    var enterprise_service_load = "";

    //小区服务层
    var village_service_feature_layer = "";
	  var village_service_feature_layer1 = "";
	  var village_service_feature_layer2 = "";

	  //学校服务层
	  var school_GraphicsLayer = "";
		var school_GraphicsLayer_selected = "";
	  //政企服务层
	  var enterprise_GraphicsLayer = "";
	  var enterprise_GraphicsLayer_selected = "";

	  var prod_list_win = "";
	  var prod_list_win_size = ['400px','300px'];

	  var resizeMainContainer = "";

	  var nav_type_index = "school";

	  //var region_type = 'sub';
	  var sub_summary_div_size = ["82%","680px"];
	  if(window.innerHeight<800){
        sub_summary_div_size = ["90%", "458px"];
        sub_market_div_area = ["758px", "430px"];
        sub_yx_div_area = ["758px", "475px"];
        collect_div_area = ["758px", "430px"];
        yxzx_div_area = ["520px", "420px"];
    }

	  var village_paint_name = "";
	  var village_paint_win_size = ['880px','495px'];
    function villagePaintTrigger(){
    		$("#village_paint_div").load("<e:url value='/pages/telecom_Index/sub_grid/viewPlane_village_view_different.jsp' />?village_id="+global_village_id);
				var title_length = village_paint_name.length;
				layer.open({
					title: "<span class='village_paint_ico'></span>"+(title_length>15?village_paint_name.substr(0,15)+'...':village_paint_name),
					maxmin: true, //开启最大化最小化按钮
					//title:false,
					type: 1,
					shade: 0,
					area: village_paint_win_size,//sub_summary_div_size
					content: $("#village_paint_div"),
					skin: 'village_paint',
					cancel: function (index) {
					},
					full: function() { //点击最大化后的回调函数
						$(".village_paint .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
						resizeMainContainer();
					},
					restore: function() { //点击还原后的回调函数
						$(".village_paint .layui-layer-setwin").css("top",'6px');
						resizeMainContainer();
					}
				});
    }
    function addTipToVillagePaint(){
    	$(".village_paint .layui-layer-title").attr("title",village_paint_name);
    }

    function viewRank(){
        parent.load_list_view();
        $("#query_div").hide();
        $("#model_to_rank").removeClass("active");
    }
    function viewVillageDraw(){
        if(city_id=="")
            city_id = city_id_for_village_tab_view;
        parent.load_list_village(2, city_id,'999');
        $("#query_div").hide();
        $("#model_to_rank").removeClass("active");
    }

    function backToPrevLevel(region_index){
    		var region_type_num = 0;
        if(region_type=="city"){
        	region_type_num = 1;
        }else if(region_type=="bureau"){
        	region_type_num = 2;
        }else if(region_type=="sub"){
        	region_type_num = 3;
        }else if(region_type=="grid"){
        	region_type_num = 4;
        }else if(region_type=="village"){
        	region_type_num = 5;
        }
    	if(region_index == 0){
    		parent.global_current_flag = 1;
	    	parent.global_current_city_id = '999';
	    	parent.global_current_area_name = city_name;
	    	parent.freshMapContainer('<e:url value="/pages/telecom_Index/channel_leader/leader_province_level.jsp"/>');
	    	parent.loadSmallTab(1,index_type,'',region_type_num);
    	}else if(region_index == 1){
    		parent.global_current_flag = 2;
	    	parent.global_current_city_id = city_id;
	    	parent.global_current_area_name = city_name;
	    	parent.freshMapContainer('<e:url value="/pages/telecom_Index/channel_leader/leader_city_level.jsp"/>');
	    	parent.loadSmallTab(2,index_type,city_id,region_type_num);
    	}
	  }

	  function hideVillageLayer(){
	  	if(village_service_feature_layer!="")
	  		village_service_feature_layer.hide();
	  	if(village_service_feature_layer1!="")
      	village_service_feature_layer1.hide();
      if(village_service_feature_layer2!="")
      	village_service_feature_layer2.hide();
      if(village_position_layer!="")
      	village_position_layer.hide();
	  }
	  function showVillageLayer(){
	  	if(village_service_feature_layer!="")
	  		village_service_feature_layer.show();
	  	if(village_service_feature_layer1!="")
      	village_service_feature_layer1.show();
      if(village_service_feature_layer2!="")
      	village_service_feature_layer2.show();
      if(village_position_layer!="")
      	village_position_layer.show();
	  }
	  function hideSchoolLayer(){
	  	if(school_GraphicsLayer!="")
	  		school_GraphicsLayer.hide();
	  	if(school_GraphicsLayer_selected!="")
	  		school_GraphicsLayer_selected.hide();
	  }
	  function showSchoolLayer(){
	  	if(school_GraphicsLayer!="")
	  		school_GraphicsLayer.show();
	  	if(school_GraphicsLayer_selected!="")
	  		school_GraphicsLayer_selected.show();
	  }
	  function hideEnterpriseLayer(){
	  	if(enterprise_GraphicsLayer!="")
	  		enterprise_GraphicsLayer.hide();
	  	if(enterprise_GraphicsLayer_selected!="")
	  		enterprise_GraphicsLayer_selected.hide();
	  }
	  function showEnterpriseLayer(){
	  	if(enterprise_GraphicsLayer!="")
	  		enterprise_GraphicsLayer.show();
	  	if(enterprise_GraphicsLayer_selected!="")
	  		enterprise_GraphicsLayer_selected.show();
	  }
    //同级切换
    var extent_init = "";
    function switch_region(region_type){
    	parent.global_region_type = region_type;
	    $(".region_switch_group li").removeClass("active");
	    var mapZoom = map.getZoom();
	    if(region_type=="city"){
	      //这里将返回市级地图
	      backToPrevLevel(0);
	    }else if(region_type=="bureau"){
	      backToPrevLevel(1);
	    }else if(region_type=="sub"){
	      $(".region_switch_group li:eq(2)").addClass("active");
	      if(featureLayer_grid!="")
	      	featureLayer_grid.hide();
	      if(grid_name_temp_layer!="")
        	grid_name_temp_layer.hide();

        hideVillageLayer();
        if(featureLayer!='')
					featureLayer.show();
				if(graLayer_zjname!="")
        graLayer_zjname.show();
        //map.setExtent(extent_init.expand(1.5));
	      parent.loadSmallTab(3,index_type,"");
	      if(mapZoom>=9)
	      	map.centerAndZoom(map.extent.getCenter(),8);
	    }else if(region_type=="grid"){
	    	if(featureLayer!="")
					featureLayer.hide();
	    	if(graLayer_zjname!="")
        	graLayer_zjname.hide();

        hideVillageLayer();
        if(featureLayer_grid!="")
	      	featureLayer_grid.show();
	      if(grid_name_temp_layer!="")
        	grid_name_temp_layer.show();
	      parent.loadSmallTab(4,index_type,"");
	      if(mapZoom>=9)
	      	map.centerAndZoom(map.extent.getCenter(),8);
	      //map.setExtent(extent_init.expand(1.5));
	    }else if(region_type=="village"){
	      village_service_load();
	      var mapZoom = map.getZoom();
	      /*if(mapZoom>=9)
	      	showVillageLayer();
	      else
	      	hideVillageLayer();*/
	      if(mapZoom<9){
	      	//map.centerAndZoom(extent_init.getCenter(),9);
	      	map.centerAndZoom(map.extent.getCenter(),9);
	      	showVillageLayer();
	      }
	      parent.loadSmallTab(5,index_type,"");
	    }
	  }

		var grid_id_map = new Array();
		var inside_flag = false;
    $(function () {
    		parent.hideEntrance();
    		$("#tools_scroll").hide();//20181206
    		$(".region_switch_group").hide();//20181206
				$.post(url4Query_leader,{eaction:"grid_list",latn_id:city_id},function(data){
					data = $.parseJSON(data);
					for(var i = 0,l = data.length;i<l;i++){
					var d = data[i];
					grid_id_map[d.STATION_ID] = d.GRID_UNION_ORG_CODE;
					}
				});
				var region_type_num = 5;//20181206 默认右侧加载小区
				parent.global_region_type = "village";//20181206 默认右侧加载小区
				//var region_type_num = 0;
	        /*if(region_type=="city"){
	        	region_type_num = 1;
	        }else if(region_type=="bureau"){
	        	region_type_num = 2;
	        }else if(region_type=="sub"){
	        	region_type_num = 3;
	        }else if(region_type=="grid"){
	        	region_type_num = 4;
	        }else if(region_type=="village"){
	        	region_type_num = 5;
	        }*/
				//parent.loadSmallTab(region_type_num,index_type,'');

    		$(".region_switch_group > ul >li").on("click",function(){
		      switch_region($(this).attr("region_type"));
      		region_type = $(this).attr("region_type");
      		$(this).addClass("active").siblings().removeClass("active");
      		parent.global_region_type = region_type;
		    });
		    var click_index_temp = 0;
		    if(region_type=="sub")
		    	click_index_temp = 2;
		    else if(region_type=="grid")
		    	click_index_temp = 3;
		    else if(region_type=="village")
		    	click_index_temp = 4;
    		$(".region_switch_group > ul >li").eq(click_index_temp).addClass("active");

    		$(".nav_index_group").children().eq(index_type).addClass("active");


    		//parent.hideMapPosition();
    		//parent.hideIndex();
        toGis();//城关区，兰州市
        //小区基础数据展示
        $("#village_close").on('click', function () {
            $("#village_info_win").hide();
            $("#village_info_win_body").empty();
        })
        $("#yingxiao_view_close").on("click", function () {
            $("#yingxiao_info_win_new").hide();
        });
        //校园政企工作台关闭
        $("#schoolOrEnterprise_close").on('click', function () {
            $("#schoolOrEnterprise_info_win").hide();
            $("#schoolOrEnterprise_info_win_body").empty();
        })

        $('#village_info_win').draggable({handle: $('#village_drag_handler')});
        $('#schoolOrEnterprise_info_win').draggable({handle: $('#schoolOrEnterprise_drag_handler')});
        $("#detail_more").draggable({handle: $("#detail_more_draggable")});
        $("#mark_detail").draggable({handle: $("#mark_detail_draggable")});
        $('#build_info_win').draggable({handle: $('#build_info_win_draggable')});
        $('.build_more_win').draggable();
        $('#yingxiao_info_win').draggable({handle: $('#yingxiao_info_title')});
        $('#yingxiao_info_win_new').draggable({handle: $('#yx_drag_handler')});
        $("#buildInVillage_review_win").draggable({handle: $('#yingxiao_info_new_title')});
        $("#pos_tab_win").draggable({handle:$("#pos_tab_title")});
        //信息收集
        //信息收集统计
        $("#info_collect_summary_div").draggable({handle: $("#info_collect_summary_draggable")});
        //信息收集列表
        $("#info_collect_list_div").draggable({handle: $("#info_collect_list_draggable")});
        //信息收集详情
        $("#info_collect_view_div").draggable({handle: $("#info_collect_view_draggable")});
        //信息竞争收集
        $("#info_collect_edit_div").draggable({handle: $("#info_collect_edit_draggable")});

        //$('#draw_tools').draggable();
        $('#draw_set').on('click', function () {
            if (flag_set) {
                $(this).css("background-color", "transparent")
            } else {
                $(this).css("background-color", "#051961")
            }
            flag_set = !flag_set;
            $("#shezhi_content").toggle()
        })
        //$('#nameinput').draggable();
        $('#mark_link').on('click', function () {
            $('#mark_detail').show();//viewPlane_village_view.jsp
            $("#mark_detail").next("iframe").src = "viewPlane_village_view.jsp";
        });

        $('.open_detail').on('click', function () {
            $('#village_market_detail').show();
            //$('').hide()
        });



        var $div_li = $(".tab_menu span");
        $div_li.click(function () {
            $(this).addClass("selected")            //当前<li>元素高亮
                    .siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
            var index = $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
            $("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
                    .eq(index).show()   //显示 <li>元素对应的<div>元素
                    .siblings().hide(); //隐藏其它几个同辈的<div>元素
        })

        $("#build_more_close").click(function () {
            $("#village_market_detail").hide();
        });

    });
    $('#build_close').on('click', function () {
        $('#build_info_win').hide();
    });

    function funshow(village_id, segm_id) {
        //market_detail_id

        //document.getElementById("market_detail_id").src="viewPlane_village_view_details.jsp?segm_id="+segm_id+"&village_id="+village_id;
        //$('#village_market_detail').show();
				if(global_position_build_view=="")
					global_position_build_view = new Array();
        global_position_build_view.splice(0, 1, city_name);
				global_position_build_view.splice(1, 1, parent.global_position[2]);
				global_position_build_view.splice(2, 1, $("#village_view_sub").text());
				global_position_build_view.splice(3, 1, $("#village_view_grid").text());
				global_position_build_view.splice(4, 1, $("#village_view_title").text());
        showBuildDetail(segm_id, '', 'all', 4, 0, village_id);
    }
    function funshow1(yx_id, segm_id) {
        /*if(segm_id ==null || segm_id =="null"){
         layer.msg("该四级地址没有可营销信息");
         return;
         }*/
        //document.getElementById("yx_market_detail_id").src="viewPlane_village_view_details.jsp?segm_id="+segm_id+"&yx_id="+yx_id;
        //$('#yx_market_detail').show();
        showBuildDetail(segm_id, '', 'all', 4, 0, yx_id);
    }
    function funshow2(segm_id) {
        /*if(segm_id ==null || segm_id =="null"){
         layer.msg("该四级地址没有可营销信息");
         return;
         }*/
        //document.getElementById("build_market_detail_id").src="viewPlane_village_view_details.jsp?segm_id="+segm_id;
        //$('#build_market_detail').show();
        showBuildDetail(segm_id, '', 'all', 4, 0, '');
    }
    function village_close_fun() {
        $('#village_market_detail').hide();
    }

    function yx_market_detail_close_fun() {
        $('#yx_market_detail').hide();
    }
    function build_market_detail_close_fun() {
        $("#build_market_detail").hide();
    }


    function querygrid(latn_id) {
        if (latn_id != null && latn_id != undefined) {

        } else {
            latn_id = $("#g_city option:selected").val()
        }
        var bureau_no = $("#g_area option:selected").val()
        var union_org_code = $("#g_branch option:selected").val()
        var g_grid_name = $("#g_grid_name").val();
        g_grid_name = $.trim(g_grid_name);
        $.post(url4Query, {
            eaction: "grid_list",
            latn_id: latn_id,
            bureau_no: bureau_no,
            union_org_code: union_org_code,
            grid_name: g_grid_name
        }, function (data) {
            data = $.parseJSON(data)
            if (data.length == 0) {
            		$("#gridcount1").html(0);
                $("#gridcount2").html(0);
                $(".grid_table").html("<tr><td style='text-align:center' onMouseOver=\"this.style.background='rgb(250,250,250)'\" >没有查询到数据</td></tr>")
            } else {
                $(".grid_table").html(' ')
                var gridall = 0;
                var gridshow = 0;
                var str = "";
                $.each(data, function (i, d) {
                    //str += "<tr class=\"tr_default_background_color\" style='color:"+(d.GRID_SHOW==0?'#f00':'#000')+"' onclick=\"javascript:clickToGrid('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',this,"+ d.GRID_ZOOM+",'"+d.GRID_NAME+"','"+d.STATION_ID+"')\"  ><td style='width: 12%;text-align: left;padding-left:10px'>"+ (i+1)+"</td><td style='width: 38%;text-align: left;padding-left: 5px' title=\""+d.BRANCH_NAME+"\">"+d.BRANCH_NAME+"</td><td style='width: 55%;text-align: left;padding-left:5px'>"+ d.GRID_NAME+"("+d.COUNT+")</td></tr>";
                    str += "<tr class=\"tr_default_background_color\" style='color:" + (d.GRID_SHOW == 0 ? '#f00' : '#000') + "' onclick=\"javascript:clickToGrid('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this," + d.GRID_ZOOM + ",'" + d.GRID_NAME + "','" + d.STATION_ID + "')\"  ><td style='width: 12%;text-align: left;padding-left:10px'>" + (i + 1) + "</td><td style='width: 38%;text-align: left;padding-left: 5px' title=\"" + d.BRANCH_NAME + "\">" + d.BRANCH_NAME + "</td><td style='width: 55%;text-align: left;padding-left:5px'>" + d.GRID_NAME + "</td></tr>";
                    gridall++;
                    if (d.GRID_SHOW == 1) {
                        gridshow++
                    }
                })
                $(".grid_table").append(str);
                var stan = 22
                var len = $(parent.window).width()
                if (len < 1900)
                    stan = 10
                if (data.length <= stan) {
                    for (var i = 0; i < stan - data.length; i++) {
                        var str = "<tr class=\"tr_default_background_color\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\" onMouseOut=\"this.style.background='rgb(250,250,250)'\" ><td style='width: 12%;text-align: center'></td><td style='width: 35%;text-align:center'></td><td style='width: 40%;text-align: center'></td></tr>";
                        $(".grid_table").append(str)
                    }
                }
                //$("#grid_show").html("共"+gridall+"个网格，未上图<font color=\"red\">"+(gridall-gridshow)+"</font>个");
                $("#gridcount1").html(gridall);
                $("#gridcount2").html(gridall - gridshow);
            }
        });
    }

    function clearAllLayer() {
        sub_name_label_symbol1 = new Array();
        sub_name_label_symbol2 = new Array();
        sub_name_label_symbol3 = new Array();
        sub_name_label_symbol4 = new Array();
        sub_name_label_symbol5 = new Array();
        sub_name_label_symbol6 = new Array();
        sub_name_label_symbol7 = new Array();

        //网格名称 按地图放大缩小 分级展示用的数组
        grid_name_label_symbol1 = new Array();
        grid_name_label_symbol2 = new Array();
        grid_name_label_symbol3 = new Array();
        grid_name_label_symbol4 = new Array();
        grid_name_label_symbol5 = new Array();
    }
    //渲染 某个区县 下的支局群板块，填充颜色
    function toGis() {//城关区，兰州市
        if (map != "") {
            try {
                clearAllLayer();
                map.removeAllLayers();
                map.destroy();
                map = "";
                parent.freshIndexContainer(indexContainer_url_bearue);
            } catch (e) {
                return;
            }
        }
        global_current_flag = 4;
        city_full_name = parent.global_position[1];
        //if (zxs[city_id] != undefined)
        //    parent.global_position.splice(2, 1, parent.global_position[1]);
        var cityForLayer = cityNames[city_id];
        if (cityForLayer == undefined)
            return;
        var pageMapHeight = $(window).height();
        if (pageMapHeight == 0)
            pageMapHeight = parent.document.documentElement.clientHeight - 6;
        $("#gismap").height(pageMapHeight);
        $("#gismap").show();
        require(["esri/config",
                    "esri/Color",
                    "esri/graphic",
                    "esri/graphicsUtils",
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
                          graphicsUtils,
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
                          ClusteredColumns) {
                    Config.defaults.io.proxyUrl = "http://135.149.64.140:8888/proxy/proxy.jsp";
                    Config.defaults.io.alwaysUseProxy = false;
                    //本地网地图url
                    var layer_ds = tiled_address_pre + cityForLayer + tiled_address_suf;

                    var sub_layer_index = "/2";
                    var grid_layer_index = "/1";

                    var standard_layer_index = "/0";

                    var channel_point_layer_index = "/0";

                    var new_url_sub_vaild = "";
                    var new_url_grid_vaild = "";

                    /*if(city_id == "932"){
                     new_url_sub_vaild = new_url_sub_dx;
                     new_url_grid_vaild = new_url_grid_dx;
                     sub_layer_index = "/0";
                     }else if(city_id == "947"){
                     new_url_sub_vaild = new_url_sub_jyg;
                     new_url_grid_vaild = new_url_grid_jyg;
                     sub_layer_index = "/0";
                     }*/
                    //if(city_id == '931' || city_id == '947' || city_id == '932' || city_id == '933' || city_id == '938'){
                    new_url_sub_vaild = new_url_sub_pre + cityForLayer + new_url_sub_suf;
                    new_url_grid_vaild = new_url_grid_pre + cityForLayer + new_url_grid_suf;
                    //}

                    /*if(city_id=="938"){
                     new_url_sub_vaild = "http://135.149.48.83:8030/arcgis/rest/services/BONC_gansu/gs_tianshui_local/MapServer";
                     new_url_grid_vaild = "http://135.149.48.83:8030/arcgis/rest/services/BONC_gansu/gs_tianshui_local/MapServer";
                     sub_layer_index = "/2";
                     grid_layer_index = "/1";
                     standard_layer_index = "/0";
                     }*/

                    /*var new_url_sub_grid = new_url_sub_grid;
                     var gpServerUrl =gpServerUrl;
                     var new_url_point = new_url_point;*/
                    //标准地址 第四级地址，到栋幢+单元，点要素
                    //var standard_address = standard_address_pre+cityForLayer+standard_address_suf;
                    var standard_address = new_url_grid_pre + cityForLayer + new_url_grid_suf + standard_layer_index;

                    var village_service_url = village_url;
                    var village_where = "LATN_ID = " + city_id;
                    var school_where = "latn_id = " + city_id;
                    var enterprise_where = "latn_id = "+ city_id;

                    //if(city_id=="938")
                    //	standard_address = "http://135.149.48.83:8030/arcgis/rest/services/BONC_gansu/gs_tianshui_local/MapServer"+standard_layer_index;
                    //var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/new_sub_grid_20160613/MapServer";
                    //var new_url = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/new_sub_grid_netpoint/MapServer";
                    //var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/new_sub_grid_with_area_20170616/MapServer";
                    //var gpServerUrl ="http://135.149.48.47:6080/arcgis/rest/services/bonc_gansu/juhe_tools/GPServer";
                    var geometryService2 = new GeometryService("http://135.149.48.47:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer");

                    var currentOpacity = 1;
                    var highlightSymbol_sub_mouse_over = new SimpleFillSymbol(
                            SimpleFillSymbol.STYLE_SOLID,
                            new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([highlight_sub_mouse_over_color[0], highlight_sub_mouse_over_color[1], highlight_sub_mouse_over_color[2], currentOpacity]), highlight_sub_mouse_over_line_width),//0.3],2
                            new Color([highlight_sub_mouse_over_color[0], highlight_sub_mouse_over_color[1], highlight_sub_mouse_over_color[2], currentOpacity])//0.6
                    );
                    var highlightSymbol_grid_mouse_over = new SimpleFillSymbol(
                            SimpleFillSymbol.STYLE_SOLID,
                            new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([highlight_grid_mouse_over_color[0], highlight_grid_mouse_over_color[1], highlight_grid_mouse_over_color[2], currentOpacity]), highlight_grid_mouse_over_line_width),//0.3],2
                            new Color([highlight_grid_mouse_over_color[0], highlight_grid_mouse_over_color[1], highlight_grid_mouse_over_color[2], currentOpacity])//0.6
                    );
                    var highlightSymbol_sub_click = new SimpleFillSymbol(
                            SimpleFillSymbol.STYLE_SOLID,
                            new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([sub_selected_fill_color[0], sub_selected_fill_color[1], sub_selected_fill_color[2], currentOpacity]), sub_selected_line_width),//0.3],2  //255,255,102 20170616
                            new Color([sub_selected_fill_color[0], sub_selected_fill_color[1], sub_selected_fill_color[2], currentOpacity])//0.6
                    );
                    var highlightSymbol_grid_click = new SimpleFillSymbol(
                            SimpleFillSymbol.STYLE_SOLID,
                            new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([grid_selected_fill_color[0], grid_selected_fill_color[1], grid_selected_fill_color[2], currentOpacity]), grid_selected_line_width),//0.3],2
                            new Color([grid_selected_fill_color[0], grid_selected_fill_color[1], grid_selected_fill_color[2], currentOpacity])//0.6
                    );
                    var linesymbol_sub_selected = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(sub_selected_line_color), sub_selected_line_width);
                    var linesymbol_grid_selected = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(grid_selected_line_color), grid_selected_line_width);

                    //var linesymbol_qx_all_line = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_all_line_color), qx_all_line_width);
                    var linesymbol_qx_all_line = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_all_line_color), qx_all_line_width);
                    var linesymbol_qx_selected = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_selected_line_color), qx_selected_line_width);

                    //支局下有网格存在时候，给支局加轮廓线
                    var linesymbol_has_grid_in_sub = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(sub_has_grid_self_line_color), sub_has_grid_self_line_width);

                    //支局下没有网格的时候，给支局加渔网背景
                    if (beforeMouseOverColor_sub == "" || beforeMouseOverColor_sub == undefined)
                        beforeMouseOverColor_sub = {r: 128, g: 128, b: 128};
                    var fillsymbol_none_grid_in_sub = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS,
                            new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,
                                    new esri.Color([255, 0, 0]), 2), new esri.Color([beforeMouseOverColor_sub.r, beforeMouseOverColor_sub.g, beforeMouseOverColor_sub.b, 0.25]));

                    var point_selected_mark = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 20,
                            new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
                                    new Color([0, 255, 0]), 1),
                            new Color([0, 255, 0, 0.25]));

                    //未划配网格 提示文字的字体
                    var font_sub_none_grid_text = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD);
                    font_sub_none_grid_text.setFamily("微软雅黑");

                    var font_qx_text = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD);
                    font_qx_text.setFamily("华文中宋");

                    var grid_zoom = 1;

                    /*var cenAndZoom = city_center_zoom_gis[city_id];
                    if (cenAndZoom != undefined) {
                    		map.on("load",function(){
                    			map.centerAndZoom([cenAndZoom['lng'], cenAndZoom['lat'], cenAndZoom['zoom']]);
                    		});
                    }*/


                    //parser.parse();//解释小部件标签属性

                    //地图中心点及放大级别 城市中心 默认分局 默认区县
                    var default_bureau_of_city = {
                    	"931":{'pos':[103.8612929860706,36.05046997482121],'zoom':7},
                    	"938":{'pos':[105.72872124939818,34.581546369492145],'zoom':7},
                    	'943':{'pos':[104.82121106631105,36.72885148452257],zoom:7},//
											'937':{'pos':[94.66524527387607,40.14419275364026],zoom:7},//
											'936':{'pos':[100.45716040290318,38.94172909274361],zoom:7},//
											'935':{'pos':[102.63627798414609,37.93127049249927],zoom:7},//
											'945':{'pos':[102.19465573630383,38.5252846437488],zoom:7},//
											'947':{'pos':[98.28831834734618,39.77281073112289],zoom:7},//
											'932':{'pos':[104.61159385101291,35.59367340465359],zoom:7},//
											'933':{'pos':[106.67303840062002,35.54497689577579],zoom:7},//
											'934':{'pos':[107.64361523820335,35.722568915411934],zoom:7},//
											'939':{'pos':[104.95514890066127,33.37379267044918],zoom:7},//
											'930':{'pos':[103.21388602448695,35.599316690660046],zoom:7},//
											'941':{'pos':[102.91521403938441,34.987338694452134],zoom:7}//
                    };
                    //var cenAndZoom = city_center_zoom_gis[city_id];
                    var cenAndZoom = "";
                    
                    	cenAndZoom = default_bureau_of_city[city_id]['pos'];
                    
                    
										//map.centerAndZoom(bureau_center_point,7);
                    //var cenAndZoom = area_name_point_lng_lat[city_id];

                    if (cenAndZoom != undefined) {
                    	var mapInitOption = new Object();
                    	mapInitOption.center = cenAndZoom;//[cenAndZoom['lng'], cenAndZoom['lat']];
                    	var zoom_temp = "";
                    	
                    		zoom_temp = default_bureau_of_city[city_id]['zoom'];
                    	
                    	mapInitOption.zoom = zoom_temp;//cenAndZoom['zoom'];
                    	map = new Map("gismap",mapInitOption);
                    }else{
                    	map = new Map("gismap");
                    }
                    //map.showPanArrows();
                    map.on("load", function () {
                        map.hideZoomSlider();
                        toolbar = new Draw(map);
                        toolbar.on("draw-end", drawAddToMap);
                        //默认选择的项目
                        $("#nav_type_school").click();
                    });
                    var navToolbar = new Navigation(map);

                    $('#yingxiao_close').unbind();
                    $('#yingxiao_close').on('click', function () {
                        $('#yingxiao_info_win').hide();
                        $('#yingxiao_info_win_new').hide();
                        $("#yingxiao_new_win").hide();
                        draw_layer.clear();
                    });
                    $('#yingxiao_new_close').unbind();
                    $('#yingxiao_new_close').on('click', function () {
                        $('#yingxiao_info_win_new').hide();
                        $('#yingxiao_info_win').hide();
                        $("#yingxiao_new_win").hide();
                        //draw_layer.clear();
                        //draw_layer.hide();
                        //draw_layer.visible = false;
                    });
                    $('#nav_zoomprev').unbind();
                    $("#nav_zoomprev").click(
                            function () {
                                navToolbar.zoomToPrevExtent();
                            }
                    );
                    $('#nav_zoomnext').unbind();
                    $("#nav_zoomnext").click(
                            function () {
                                navToolbar.zoomToNextExtent();
                            }
                    );
                    $('#nav_extent').unbind();
                    $("#nav_extent").click(
                            function () {
                                navToolbar.zoomToFullExtent();
                            }
                    );
                    $('#nav_zoomin').unbind();
                    $("#nav_zoomin").click(
                            function () {
                                map.setLevel(map.getLevel() + 1);
                            }
                    );
                    $('#nav_zoomout').unbind();
                    $("#nav_zoomout").click(
                            function () {
                                map.setLevel(map.getLevel() - 1);
                            }
                    );
                    $('#nav_hidetiled').unbind();
                    $("#nav_hidetiled").click(//隐藏、显示底图 20170730修改，取消此功能，修改为地图模式转换
                            function () {
                                parent.load_map_view();
                                /*if (tiled.visible){
                                 tiled.hide();
                                 $("#nav_hidetiled").removeClass("active");
                                 }else{
                                 tiled.show();
                                 $("#nav_hidetiled").addClass("active");
                                 $('#build_info_win').hide()
                                 }*/
                            }
                    );
                    $('#nav_hidepoint').unbind();
                    $("#nav_hidepoint").click(
                            function () {
                                if (graLayer_wd.visible) {
                                    map.infoWindow.hide();
                                    graLayer_wd.hide();
                                    $("#nav_hidepoint").removeClass("active");
                                } else {
                                    graLayer_wd.show();
                                    $("#nav_hidepoint").addClass("active");
                                    $('#build_info_win').hide()
                                }
                            }
                    );

                    //查找 支局 网格
                    $('#nav_query').unbind();
                    $("#nav_query").click(function () {
                        /*$("#query_div").css({"top": $(this).offset().top-28});
                        $("#query_div").css({"left": "32px"});
                        $("#query_div").toggle();*/
                        layer.closeAll();
                        tmp_query = '1';
                        $("#nav_query").toggleClass("active");
                        $('#build_info_win').hide();
                        //if ($("#query_div").is(':visible'))
                        //    $("#nav_list").removeClass("active");
                        var top_px = $(this).offset().top-38;
                        layer.open({
                            title: ['用户查询', 'line-height:32px;text-size:30px;height:32px;'],
                            //title:false,
                            type: 1,
                            shade: 0,
                            area: ["298px", "70px"],
                            offset: [top_px+"px", '38px'],
                            content: $("#query_div"),
                            cancel: function (index) {
                                $("#nav_query").removeClass("active");
                                return tmp_query = '1';
                            }
                        });
                    });
                    $("#acc_nbr_search_btn").unbind();
                    $("#acc_nbr_search_btn").click(
                    				function(){
                    					var phone_num_for_search = $("#acc_nbr_search_btn").val();
                    					phone_num_for_search = $.trim(phone_num_for_search);
                                if (phone_num_for_search == "") {
                                    layer.msg("请输入号码");
                                    return;
                                }

                    				}
                    );
                    //支局的查询按钮
                    $('#location_find').unbind();
                    $("#location_find").click(
                            function () {
                                var location_name = $("#location_name").val();
                                location_name = $.trim(location_name);
                                if (location_name == "") {
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

                                query.where = "REPORTTO LIKE '%" + location_name + "%' AND MAPID = " + map_id;
                                query.outFields = ["SUBSTATION_NO", "REPORTTO"];
                                query.returnGeometry = true;
                                queryTask1.execute(query, function (results) {
                                    var fs = results.features;
                                    if (fs.length == 0) {
                                        layer.msg("暂无查询结果");
                                        return;
                                    }

                                    var feature = results.features[0];
                                    //支局
                                    if (location_type == 1) {
                                        //绘制所查询支局的归属区县的轮廓线
                                        var substation = feature.attributes.SUBSTATION_NO;
                                        var sub_name = sub_data[substation];
                                        drawQXLine(substation, sub_name);

                                        parent.global_substation = substation;
                                        parent.global_current_flag = 4;
                                        parent.global_current_full_area_name = sub_name;
                                        parent.global_current_area_name = sub_name;
                                        parent.freshIndexContainer(indexContainer_url_sub);
                                        parent.global_position.splice(3, 1, sub_name);
                                        parent.updatePosition(parent.global_current_flag);

                                        parent.frmTitleShow();
                                        parent.bar_status_history = parent.status;
                                        //所点支局的视野、名称
                                        var sub_selected_geometry = feature.geometry;
                                        sub_selected_ext = sub_selected_geometry.getExtent();
                                        map.setExtent(sub_selected_ext.expand(1.5));

                                        var graphics = new esri.Graphic(sub_selected_geometry, linesymbol_sub_selected);
                                        graLayer_zj_click.add(graphics);
                                    }
                                    /*else if(location_type==1){
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
                    $("#village_view_build_search_btn").unbind();
                    $("#village_view_build_search_btn").click(function () {
                        var village_view_build_search_add4 = $("#village_view_build_search_add4").val();
                        var village_id = $("#village_view_v_id").val();
                        freshVillageViewBuildList(village_id, village_view_build_search_add4);
                    });
                    $("#village_view_yx_search_btn").unbind();
                    $("#village_view_yx_search_btn").click(function () {
                        var village_view_yx_search_add4 = $("#village_view_yx_search_add4").val();
                        var village_id = $("#village_view_v_id").val();
                        freshVillageViewYXList(village_id, village_view_yx_search_add4);
                    });

                    $("#yx_view_yx_search_btn").unbind();
                    $("#yx_view_yx_search_btn").click(function () {
                        var yx_view_yx_search_add4 = $("#yx_view_yx_search_add4").val();
                        var yx_id = $("#yx_view_yx_id").val();
                        freshYXViewList(yx_id, yx_view_yx_search_add4);
                    });

                    $("#yx_new_build_search_btn").unbind();
                    $("#yx_new_build_search_btn").click(function () {
                        var yx_view_yx_search_add4 = $("#yx_new_build_search_add4").val();
                        var yx_id = $("#segmid_for_yx_save_hide").val();
                        //三个标签的查询
                        //freshYX_new_build_list(yx_id,yx_view_yx_search_add4);
                        var segm_ids_array = Object.keys(segmid_for_yx_save_array);
                        if (segm_ids_array.length == 0) {
                            return;
                        }
                        var segmid_for_yx_save = "(";
                        /*yinming 2017年7月22日11:28:37 修改营销窗口*/
                        for (var i = 0; i < segm_ids_array.length; i++) {
                            if (i != 0) {
                                segmid_for_yx_save += ",";
                            }
                            var id = segm_ids_array[i];
                            segmid_for_yx_save += "'" + id + "'";
                        }
                        segmid_for_yx_save += ")";
                        freshYX_new_buildyx_list(segmid_for_yx_save, yx_view_yx_search_add4);
                    });

                    $("#yx_new_yx_search_btn").unbind();
                    $("#yx_new_yx_search_btn").click(function () {
                        var yx_view_yx_search_add4 = $("#yx_new_yx_search_add4").val();
                        var yx_id = $("#segmid_for_yx_save_hide").val();
                        freshYX_new_yx_list(yx_id, yx_view_yx_search_add4);
                    });

                    //信息收集统计关闭按钮
                    $("#info_collect_summary_div_close").on("click",function(){
								    		$('#info_collect_summary_div').hide();
								    		tmp_info_collect = "1";
								        $("#nav_info_collect").removeClass("active");
								    });
								    //信息收集列表关闭按钮
                    $("#info_collect_list_div_close").on("click",function(){
								    		$('#info_collect_list_div').hide();
								    		$('#info_collect_summary_div').show();
								    });
								    //信息收集详情关闭按钮
                    $("#info_collect_view_div_close").on("click",function(){
								    		$('#info_collect_view_div').hide();
								    });
								    //信息收集竞争收集关闭按钮
                    $("#info_collect_edit_div_close").on("click",function(){
								    		$('#info_collect_edit_div').hide();
								    });

                    //$("#deleteBuildInVillage_btn").unbind();
                    deleteBuildInVillage = function () {
                        var desc_text = "确定移除小区吗？";
                        var url_str = url4Query_enterprise;
                        var eaction = "deleteBuildInSchoolOrEnterprise";
                        if(nav_type_index=="school"){
                        	desc_text = "确定移除校园吗？";
                        }else if(nav_type_index=="enterprise"){
                        	desc_text = "确定移除商客吗？";
                        }else{
                        	url_str = url4Query;
                        	eaction = "deleteBuildInVillage";
                        }

                        layer.confirm(desc_text, {
                                    btn: ['确定', '取消'] //按钮
                                }, function () {
                                    var v_id = $("#village_view_v_id").val();
                                    $.post(url_str, {
                                        "eaction": eaction,
                                        "v_id": v_id
                                    }, function (data) {
                                        layer.msg("小区删除成功");
                                        //village_load(parent.global_report_to_id);
                                        //优化方案，只删除选中的小区图标，删除小区关联的楼宇图标（红色，灰色）
                                        village_position_layer.clear();
                                        draw_layer_mark_build.clear();
                                        removeBuildToVillageUsed(build_ids_for_del);
                                        if(nav_type_index=="village")
                                        	village_layer.remove(village_selected_gra_update);
                                        else if(nav_type_index=="school")
                                        	school_GraphicsLayer.remove(village_selected_gra_update);
                                        else if(nav_type_index=="enterprise")
                                        	enterprise_GraphicsLayer.remove(village_selected_gra_update);

                                        $("#village_info_win").hide();
                                        try{
                                        	parent.freshVillageDatagrid();
                                        }catch(e){
                                        }

                                    });
                                }, function () {
                                    draw_layer.clear();
                                }
                        );
                    }
                    function getCenter(target){
                    	return[$("body").width()/2-$(target).width()/2,$("body").height()/2-$(target).height()/2];
                    }
                    var build_ids_for_del = "";
                    var buildInVillageCopy = "";//修改小区，但不修改，保存原始的楼宇群
                    operateVillage = function (village_id, st, addr, thiz) {
                    		parent.hideRightDiv();//20181206
                    	  parent.reposMapPosition();//20181206
                    	  if(buildInVillage_mode!=""){
                    			return;
                    		}
                    		$("#village_view_v_id").val(village_id);
                        $("#build_info_win").hide();
                        village_selected_gra_update = village_gras_array[village_id];
                        global_village_id = village_id;
                        buildInVillage = new Array();
                        buildInVillage_short = new Array();
                        buildInVillageCopy = new Array();
                        draw_graphics_array_for_buildInVillage = new Array();
                        build_ids_for_del = new Array();

												if(nav_type_index == "school" || nav_type_index == "enterprise"){
													if(nav_type_index == "school")
														$("#schoolOrEnterprise_drag_handler span").text("校园视图");
													else if(nav_type_index == "enterprise"){
														$("#schoolOrEnterprise_drag_handler span").text("商客视图");
													}
													$("#schoolOrEnterprise_info_win_body").attr("src",'<e:url value="/pages/telecom_Index/sub_grid/viewPlane_school_or_enterprise_view_details.jsp" />?village_id='+village_id+'&nav_type_index='+nav_type_index);
	                        var cent_pos = getCenter("#schoolOrEnterprise_info_win");
	                        $("#schoolOrEnterprise_info_win").css({"left":cent_pos[0],"top":cent_pos[1]});
	                        $("#schoolOrEnterprise_info_win").show();
												}else{
													$("#village_drag_handler span").text("小区工作台");
													$("#village_info_win_body").attr("src",'<e:url value="/pages/telecom_Index/sub_grid/viewPlane_village_view_details.jsp" />?village_id='+village_id);
	                        var cent_pos = getCenter("#village_info_win");
	                        $("#village_info_win").css({"left":cent_pos[0],"top":cent_pos[1]});
	                        $("#village_info_win").show();
												}

                        draw_layer_mark_build.clear();
                        var ids_str = ids_str_array[village_id + "_"];
                        if(ids_str==undefined){
                        	var url = url4Query_leader;
                        	var action = "getBuildInsideVillage";
                        	if(nav_type_index == "school" || nav_type_index == "enterprise"){
                        		url = url4Query_enterprise;
                        		action = "getBuildInsideSchoolOrEnterprise";
                        	}
                        	$.post(url,{"eaction":action,"village_id":village_id},function(data){
                        		data = $.parseJSON(data);
                        		var ids_str = "RESID in (";
                            for (var i = 0, l = data.length; i < l; i++) {
                                var d = data[i];
                                if (i == 0) {
                                    v_id_temp = d.VILLAGE_ID;
                                    v_center = d.POSITION;
                                }

                                ids_str += "'" + d.SEGM_ID + "'";
                                if (i < l - 1)
                                    ids_str += ",";
                            }
                            ids_str += ")";
                            getBuildInsideVillage(ids_str);
                        	});
                        }else{
                        	getBuildInsideVillage(ids_str);
                        }
                    }
                    //小列表点击 定位校园政企 定位校园商客
                    pos_bus = function(village_id,x,y){
                    	operateVillage(village_id);
                    	if(nav_type_index=="village")
                    		map.centerAndZoom([x, y],9);
                    	else
                    		map.centerAndZoom([x, y],7);
                      var ico_url1 = "";
                      try{
                      	var gra = village_gras_array[village_id];
	                      var pointAttributes = {};
	                      if(nav_type_index=="school"){
	                      	ico_url1 = school_ico_selected;
	                      	pointAttributes = {"school_id":village_id,"school_name":gra.attributes.school_name};
	                      }else if(nav_type_index=="enterprise"){
	                      	ico_url1 = enterprise_ico_selected;
	                      	pointAttributes = {"enterprise_id":enterprise_id,"enterprise_name":gra.attributes.enterprise_id_name};
	                      }else{
	                      	ico_url1 = village_ico_selected;
	                      	pointAttributes = {"village_id":village_id,"village_name":gra.attributes.village_name};
	                      }
	                      var size = village_ico_get_size(map.getZoom());
	                      var img1 = new PictureMarkerSymbol(ico_url1, size, size);
	
	
	                      var graphic1 = new esri.Graphic(gra.geometry, img1, pointAttributes);
	                      if(nav_type_index=="school"){
	                      	school_GraphicsLayer_selected.clear();
	                      	school_GraphicsLayer_selected.add(graphic1);
	                      }else if(nav_type_index=="enterprise"){
	                      	enterprise_GraphicsLayer_selected.clear();
	                      	enterprise_GraphicsLayer_selected.add(graphic1);
	                      }else{
	                      	village_position_layer.clear();
	                      	village_position_layer.add(graphic1);
	                      }
                      }catch(e){
                      
                      }
                      
                    }
                    function getBuildInsideVillage(build_ids_str){
                    	var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        //query_standard.where = map.extent;
                        query_standard.where = build_ids_str;
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0)
                                return;
                            var current_zoom = map.getZoom();
                            var size = standard_point_get_size(current_zoom);//获取当前放大级别下，楼宇图标的大小
                            var build_ids_temp = new Array();
                            for (var i = 0, l = results.features.length; i < l; i++) {
                                var feature = results.features[i];

                                var img = new PictureMarkerSymbol(standard_ico_selected, size, size);
                                var build_gra = new esri.Graphic(feature.geometry, img, feature.attributes);
                                draw_layer_mark_build.add(build_gra);
                                //map.addLayer(draw_layer_mark_build);
                                buildInVillage[feature.attributes.RESID] = feature.attributes.RESFULLNAME;
                                buildInVillage_short[feature.attributes.RESID] = feature.attributes.RESNAME;
                                buildInVillageCopy[feature.attributes.RESID] = 1;
                                build_ids_for_del.push(feature.attributes.RESID);
                            }
                        });
                    }
                    function freshVillageViewBuildList(village_id, segm_name_search) {
                        var cit = $("#village_view_build_list");
                        cit.empty();
                        $.post(url4Query, {
                            eaction: "village_view_build_detail_query_list",
                            yxid: village_id,
                            standard_name: segm_name_search
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data == null && data.length == 0) {
                                $("#village_view_build_list").append("<tr><td colspan='8'>暂无楼宇信息</td></tr>");
                                return;
                            }

                            $("#village_view_build_record_count").text(data.length - 1);

                            for (var j = 0; j < data.length; j++) {
                                var newRow = "";
                                var obj = data[j];
                                if (obj.SEGM_ID != 0)
                                    newRow += "<tr><td>" + j;
                                else
                                    newRow += "<tr class=\"heji\"><td>";
                                newRow += "</td>";
                                if (obj.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:showBuildDetail('" + obj.SEGM_ID + "','" + obj.STAND_NAME + "','all',0,this," + village_id + ")\">" + obj.STAND_NAME + "</a></td>";
                                else
                                    newRow += "<td class=\"heji_text_center\">" + obj.STAND_NAME + "</td>";
                                if (obj.ZHU_HU_COUNT > 0) {
                                    if (obj.SEGM_ID != 0)
                                        newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:showBuildDetail('" + obj.SEGM_ID + "','" + obj.STAND_NAME + "','all',0,this," + village_id + ")\">" + obj.ZHU_HU_COUNT + "</a></td>";
                                    else
                                        newRow += "<td>" + obj.ZHU_HU_COUNT + "</td>";
                                }
                                else if (obj.ZHU_HU_COUNT == -1)
                                    newRow += "<td>--</td>";
                                else
                                    newRow += "<td>0</td>";

                                newRow += "<td>" + (obj.PORT_COUNT < 0 ? '--' : obj.PORT_COUNT) + "</td>";
                                newRow += "<td>" + (obj.PORT_FREE_COUNT < 0 ? '--' : obj.PORT_FREE_COUNT) + "</td>";

                                newRow += "<td>" + (obj.KD_COUNT < 0 ? '--' : obj.KD_COUNT) + "</td>";
                                newRow += "<td>" + (obj.ITV_COUNT < 0 ? '--' : obj.ITV_COUNT) + "</td>";
                                newRow += "<td>" + (obj.GU_COUNT < 0 ? '--' : obj.GU_COUNT) + "</td>";
                                newRow += "</tr>";

                                $("#village_view_build_list").append(newRow);
                            }
                        });
                    }

                    function freshVillageViewYXList(village_id, segm_name_search) {
                        var cit = $("#village_view_yx_list");
                        cit.empty();
                        $.post(url4Query, {
                            eaction: "yx_detail_query_list",
                            yxid: village_id,
                            standard_name: segm_name_search
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data == null && data.length == 0) {
                                $("#village_view_yx_list").append("<tr><td colspan='6'>暂无楼宇信息</td></tr>");
                                return;
                            }

                            $("#village_view_yx_record_count").text((data.length - 1<0?0:data.length - 1));
                            $("#village_view_mbyh_count").text((data == null || data.length == 0) ? "0" : data[0].YX_ALL);

                            for (var j = 0; j < data.length; j++) {
                                var newRow = "";
                                var obj = data[j];
                                if (obj.SEGM_ID != 0)
                                    newRow += "<tr><td>" + j;
                                else
                                    newRow += "<tr class=\"heji\"><td>";
                                newRow += "</td>";
                                if (obj.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:funshow('" + village_id + "','" + obj.SEGM_ID + "')\">" + obj.STAND_NAME + "</a></td>";
                                else
                                    newRow += "<td class=\"heji_text_center\">" + obj.STAND_NAME + "</td>";

                                if (obj.YX_ALL > 0 && obj.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:funshow('" + village_id + "','" + obj.SEGM_ID + "')\">" + obj.YX_ALL + "</a></td>";
                                else
                                    newRow += "<td>" + obj.YX_ALL + "</td>";
                                newRow += "<td>" + obj.YX_DONE + "</td>";
                                newRow += "<td>" + obj.YX_UN + "</td>";
                                newRow += "<td>" + (obj.YX_LV < 0 ? '--' : obj.YX_LV + "%") + "</td>";
                                newRow += "</tr>";

                                $("#village_view_yx_list").append(newRow);
                            }
                        });
                    }

                    $("#v_village_name").unbind();
                    $("#v_village_name").on("keypress", function (event) {
                        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
                        if (keyCode == 13) {
                            $("#village_query").click()
                        }
                    })

                    $("#g_grid_name").unbind();
                    $("#g_grid_name").on("keypress", function (event) {
                        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
                        if (keyCode == 13) {
                            $("#grid_query").click()
                        }
                    })
                    $("#b_branch_name").unbind();
                    $("#b_branch_name").on("keypress", function (event) {
                        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
                        if (keyCode == 13) {
                            $("#branch_query").click()
                        }
                    })
                    //小区查询开始
                    $("#village_query").unbind();
                    $("#village_query").on("click", function () {
                        queryVillage('', 0);
                    })
                    $("#yx_village_query").unbind();
                    $("#yx_village_query").on("click", function () {
                        var latn_id = $("#yx_v_city option:selected").val();
                        queryYX_village(latn_id,0);
                    })



                    ////----
                    //小区查询开始 左侧小区
                    var begin_scroll_village = "";
                    var seq_um_village = 0;

                    function villageListScroll(latn_id, bureau_no, union_org_code, grid_id, village_name, branch_type, page) {
                        var village_list_p = $("#village_table");

                        $.post(url4Query, {
                            eaction: 'village_list_page',
                            latn_id: latn_id,
                            bureau_no: bureau_no,
                            union_org_code: union_org_code,
                            grid_id: grid_id,
                            village_name: village_name,
                            branch_type: branch_type,
                            "page": page
                        }, function (data) {
                            data = $.parseJSON(data)
                            var str = ''
                            $.each(data, function (i, d) {
                                var color = 'black';
                                var x = d.VILLAGE_NAME
                                if (x.length > 8)
                                    x = x.substr(0, 7) + '..'
                                str += "<tr class=\"tr_default_background_color\" style='font-size:14px;cursor:pointer;color:" + color + "' onclick=\"javascript:clickToGridAndVillage('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this," + d.GRID_ZOOM + ",'" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "')\" ><td style='text-align: center'>" + (++seq_um_village) + "</td><td style='text-align:left' title=\"" + d.GRID_NAME + "\">" + d.GRID_NAME + "</td><td style='text-align: left' title='" + d.VILLAGE_NAME + "'>" + x + "</td></tr>"
                            })
                            var stan = 20;
                            var width = $(parent.window).width()
                            if (width <= 1900)
                                stan = 9
                            if (data.length == 0 && seq_um_village == 0) {
                                str += "<tr class=\"tr_default_background_color\"><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>";
                                village_list_p.append(str)
                                return
                            } else if (data.length != 0 && data.length < stan) {
                                for (var i = 0; i <= stan - data.length; i++) {
                                    str += "<tr class=\"tr_default_background_color\" onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='width: 10%;text-align: center'></td><td style='width: 35%;text-align:center' ></td><td style='width: 40%;text-align: center'></td></tr>";
                                }
                            }

                            village_list_p.append(str)
                        })

                    }

                    function villageListScroll_none_grid(latn_id, bureau_no, union_org_code, village_name, branch_type, page) {
                        var village_list_p = $("#village_table");

                        $.post(url4Query, {
                            eaction: 'village_list_page_none_grid',
                            latn_id: latn_id,
                            bureau_no: bureau_no,
                            union_org_code: union_org_code,
                            village_name: village_name,
                            branch_type: branch_type,
                            "page": page
                        }, function (data) {
                            data = $.parseJSON(data)
                            var str = ''
                            $.each(data, function (i, d) {
                                var color = 'black';
                                var x = d.VILLAGE_NAME
                                if (x.length > 8)
                                    x = x.substr(0, 7) + '..'
                                str += "<tr class=\"tr_default_background_color\" style='font-size:14px;cursor:pointer;color:" + color + "' onclick=\"javascript:clickToGridAndVillage('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this," + d.GRID_ZOOM + ",'" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "')\" ><td style='text-align: center'>" + (++seq_um_village) + "</td><td style='text-align:left' title=\"" + d.GRID_NAME + "\">" + d.GRID_NAME + "</td><td style='text-align: left' title='" + d.VILLAGE_NAME + "'>" + x + "</td></tr>"
                            })
                            var stan = 20;
                            var width = $(parent.window).width()
                            if (width <= 1900)
                                stan = 9
                            if (data.length == 0 && seq_um_village == 0) {
                                str += "<tr class=\"tr_default_background_color\"><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>";
                                village_list_p.append(str)
                                return
                            } else if (data.length != 0 && data.length < stan) {
                                for (var i = 0; i <= stan - data.length; i++) {
                                    str += "<tr class=\"tr_default_background_color\" onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='width: 10%;text-align: center'></td><td style='width: 35%;text-align:center' ></td><td style='width: 40%;text-align: center'></td></tr>";
                                }
                            }

                            village_list_p.append(str)
                        })
                    }

                    function queryVillage(latn_id, page) {

                        seq_um_village = 0;
                        var vn = $("#v_village_name").val()
                        if (latn_id == null || latn_id == undefined || latn_id == '') {
                            latn_id = $("#v_city option:selected").val()
                        }
                        var bureau_no = $("#v_area option:selected").val()
                        var union_org_code = $("#v_branch option:selected").val()
                        var grid_id = $("#v_grid option:selected").val()
                        var branch_type = $("#v_branch_type option:selected").val()

                        var village_list_p = $("#village_table")
                        village_list_p.html('')

                        var village_name = $.trim(vn);
                        village_list_page = 0;

                        $.post(url4Query, {
                            eaction: 'village_list_count',
                            latn_id: latn_id,
                            bureau_no: bureau_no,
                            union_org_code: union_org_code,
                            grid_id: grid_id,
                            village_name: village_name,
                            branch_type: branch_type,
                            "page": page
                        }, function (data) {
                            $("#villagecount1").text($.parseJSON(data).VILLAGECOUNT);
                        })
                        //alert("latn_id--"+latn_id)
                        villageListScroll(latn_id, bureau_no, union_org_code, grid_id, village_name, branch_type, page);
                    }

                    var village_list_page = 0;
                    $(".td").unbind();
                    $(".td").scroll(function () {
                        var viewH = $(this).height();
                        var contentH = $(this).get(0).scrollHeight;
                        var scrollTop = $(this).scrollTop();
                        //alert(scrollTop / (contentH - viewH));

                        if (scrollTop / (contentH - viewH) >= 0.95) {
                            if (new Date().getTime() - begin_scroll_village > 500) {
                                var vn = $("#v_village_name").val()
                                var latn_id = $("#v_city option:selected").val()
                                var bureau_no = $("#v_area option:selected").val()
                                var union_org_code = $("#v_branch option:selected").val()
                                var grid_id = $("#v_grid option:selected").val()
                                var branch_type = $("#v_branch_type option:selected").val()
                                var village_name = $.trim(vn);
                                village_list_page++;
                                //if(grid_id!="")
                                	villageListScroll(latn_id, bureau_no, union_org_code, grid_id, village_name, branch_type, village_list_page);
                                //else
                                //	villageListScroll_none_grid(latn_id, bureau_no, union_org_code, village_name, branch_type, village_list_page);
                            }
                            begin_scroll_village = new Date().getTime();
                        }
                    });
                    ///小区查询结束


                    /*yinming 2017年7月20日12:06:51 新增小区右侧列表定位*/
                    global_village_map = function (village_id_selected) {
                        clearDrawLayer();
                        global_village_id = village_id_selected;

                        village_selected_gra_update = village_gras_array[village_id_selected];
                        var ico_url = village_ico_selected;
                        var size = village_ico_get_size(map.getZoom());
                        var img = new PictureMarkerSymbol(ico_url, size, size);
                        var graphic1 = new esri.Graphic(village_selected_gra_update.geometry, img, village_selected_gra_update.attributes);

                        village_position_layer.clear();
                        village_position_layer.add(graphic1);
                        village_position_layer.redraw();

                        draw_layer_mark_build.clear();
                        var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        //query_standard.where = map.extent;
                        query_standard.where = ids_str_array[village_id_selected + "_"];
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0)
                                return;
                            var current_zoom = map.getZoom();
                            var size = standard_point_get_size(current_zoom);//获取当前放大级别下，楼宇图标的大小
                            var build_ids_temp = new Array();
                            for (var i = 0, l = results.features.length; i < l; i++) {
                                var feature = results.features[i];

                                var size = standard_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
                                var img = new PictureMarkerSymbol(standard_ico_selected, size, size);
                                var build_gra = new esri.Graphic(feature.geometry, img, feature.attributes);
                                draw_layer_mark_build.add(build_gra);
                                //map.addLayer(draw_layer_mark_build);
                            }
                        });
                        map.centerAndZoom(village_selected_gra_update.geometry, 9);
                    }
                    parent.global_village_map = global_village_map;

                    /*yinming 2017年7月20日12:16:51 新增小区左侧列表定位*/
                    //20170724 liangliyuan修改，点击小区后，放大到网格范围，并绿色框标识出所点小区位置

                    var village_position_operat = false;

                    clickToGridAndVillage = function (substation, sub_name, thiz, zoom, grid_name, station_id, village_id, tab_id) {
                        global_village_id = village_id;
                        village_position_operat = true;
                        clickToGridAndPositionVillage(substation, sub_name, thiz, zoom, grid_name, station_id, village_id);

                        $("#buildInVillage_review_win").hide();

                        $("#village_info_win").hide();
                        //village_id_selected = village_id;
                        if (tab_id != undefined) {
                            operateVillage(village_id);
                            $("#village_info_win").children(".tab_menu").find("span").eq(2).click();
                        }
                        //if(!$("#village_info_win").is(":hidden"))
                        //operateVillage(village_id);
                        //global_village_map(village_id);m
                    }

                    var village_table_height = ['298px', '99.7%']
                    var village_table_layer;

                    //网格查询按钮
                    $("#grid_query").unbind();
                    $("#grid_query").click(
                            function () {
                                querygrid();
                            }
                    );

                    /*liangliyuan 2017年7月28日11:51:48 增加 排名 点击事件*/
                    $("#model_to_rank").click(function () {
                       // parent.load_list_view();
                        if($("#query_div").is(":hidden")){
                            var top_px = $(this).offset().top;
                            $("#query_div").css({"left":$(this).offset().left+38,"top":top_px,"height":$(this).height()+6});
                            $("#query_div").show();
                            $("#model_to_rank").addClass("active");
                            layer.closeAll();
                        }else{
                            $("#query_div").hide();
                            $("#model_to_rank").removeClass("active");
                        }
                        //
                    });
                    /*liangliyuan 2017年7月28日11:51:48 增加 排名 点击事件end*/

                    function resetNavMenu(){
                    	  clearDrawLayer();
                        parent.global_substation = "";
                        layer.closeAll();

                    	  $("#village_info_win").hide();
                        $('#build_info_win').hide();
                        $('#build_info_win').hide();
                        $("#marketing_div").hide();

                        $("#yingxiao_new_win").hide();
                        $('#yingxiao_info_win_new').hide();
                        $("#detail_more").hide();

                        $("#info_collect_summary_div").hide();
                        $("#info_collect_list_div").hide();
                        $("#info_collect_view_div").hide();
                        $("#info_collect_edit_div").hide();

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
                        tmpy_v = '1';
                        $("#nav_marketing_village").removeClass("active");
                    		tmp_info_collect = "1";
                        $("#nav_info_collect").removeClass("active");
                    }
                    //支局列表开始
                    $('#nav_list').unbind();
                    $('#nav_list').on('click', function () {
                        resetNavMenu();
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
                                area: ["298px", "99.4%"],
                                offset: ['1px', '38px'],
                                content: $("#list_div"),
                                cancel: function (index) {
                                    $("#nav_list").removeClass("active");
                                    return tmp = '1';
                                }
                            });
                            queryBranch(city_id);
                        }
                    });
                    //支局列表结束
                    //网格列表开始
                    $('#nav_grid').unbind();
                    $('#nav_grid').on('click', function () {
                        resetNavMenu();

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
                                area: ['298px', '99.4%'],
                                offset: ['1px', '38px'],
                                content: $("#grid_div"),
                                cancel: function (index) {
                                    $("#nav_grid").removeClass("active");
                                    return tmp2 = '1';
                                }
                            });
                            querygrid(city_id);
                        }
                    });
                    //网格列表结束
                    //小区列表开始
                    var village_list;
                    $('#nav_village').unbind();
                    $('#nav_village').on('click', function () {

                        resetNavMenu();

                        if (tmpx == '') {
                            tmpx = '1';
                            $("#nav_village").removeClass("active");
                        } else {
                            tmpx = '';
                            $("#nav_village").addClass("active");

                            queryVillage(city_id, 0)
                            village_table_layer = layer.open({
                                title: ['小区列表', 'line-height:32px;text-size:30px;height:32px;'],
                                //title:false,
                                type: 1,
                                shade: 0,
                                area: ['298px', '99.4%'],
                                offset: ['1px', '38px'],
                                content: $("#village_div"),
                                cancel: function (index) {
                                    $("#nav_village").removeClass("active");
                                    return tmpx = '1';
                                }
                            });
                        }
                    });

                    //小区列表结
                    //小区查询选择框筛选
                    setCitys($("#v_city"), $("#v_area"), $("#v_branch"), $("#v_grid"), $("#village_query"), $("#v_branch_type"));
                    setCitys_village($("#yx_v_city"), $("#yx_v_area"), $("#yx_v_branch"), $("#yx_v_grid"), $("#yx_village_query"));
                    setCitys_build($("#b_city"), $("#b_area"), $("#b_branch"), $("#b_grid"), $("#build_query"));
                    setGCitys();
                    var baseFullOptions = "<option  value=''>全省</option>"
                    var baseFullOption = "<option  value=''>全部</option>"
                    //获取所有地市级信息，并填充到小区select标签
                    function setCitys(e, e1, e2, e3, e4, e5) {
                        $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                            data = $.parseJSON(data)
                            var str = ''
                            e.unbind();
                            e.on("change", function () {
                                $("#xinjian1").css({"background-color": "#989A9B"});
                                var id = e.find(":selected").val()
                                e1.html(baseFullOption)
                                e2.html(baseFullOption)
                                e3.html(baseFullOption)
                                //e4.click()
                                if (id != '') {
                                		parent.left_list_type_selected = "village";
                                		$("#v_village_name").val("");
                                    changeMapToCity($(this).find(":selected").text(), id);
                                }
                                setArea(id, e1, e2, e3, e4, e5);
                            })
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
                            })
                            e.html(baseFullOptions)
                            e.append(str)
                            e.find("option[value=" + city_id + "]").attr("selected", "selected")
                            setArea(city_id, e1, e2, e3, e4, e5)
                        })
                    }

                    function setArea(id, e1, e2, e3, e4, e5) {
                        $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
                            data = $.parseJSON(data)
                            e1.unbind();
                            e1.on("change", function () {
                                //$("#xinjian1").css({"background-color":"#989A9B"});
                                e2.html(baseFullOption)
                                e3.html(baseFullOption)
                                e5.val("")
                                var id = e1.find(":selected").val()
                                e4.click()
                                setBranchs(id, e2, e3, e4)
                                setBranchType(id, e2, e3, e4, e5)
                                if (id != null) {
                                    setGrids(null, e3, e4)
                                }
                                //$("#xinjian1").css({"background-color":"#989A9B"});
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                            setBranchs(null, e2, e3, e4)
                            setBranchType(null, e2, e3, e4, e5)
                        })
                    }

                    setBranchType = function (id, e2, e3, e4, e5) {
                        e5.unbind();
                        e5.on("change", function () {
                            e2.html(baseFullOption)
                            e3.html(baseFullOption)
                            e4.click()
                            setBranchs(id, e2, e3, e4)
                        })
                    }

                    setBranchs = function (id, e1, e2, e3) {
                        var latn_id = $("#v_city option:selected").val()
                        var branch_type = $("#v_branch_type option:selected").val()
                        $.post(url4Query, {
                            eaction: "setbranchs",
                            id: id,
                            latn_id: latn_id,
                            branch_type: branch_type
                        }, function (data) {
                            data = $.parseJSON(data)
                            e1.unbind();
                            e1.on("change", function () {
                                var id = e1.find(":selected").val()
                                e2.html(baseFullOption);
                                e3.click();
                                setGrids(id, e2, e3);
                                //$("#xinjian1").css({"background-color":"#989A9B"});
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                        })
                    }
                    setGrids = function (id, e1, e2) {
                        var latn_id = $("#v_city option:selected").val()
                        var bureau_no = $("#v_area option:selected").val()
                        $.post(url4Query, {
                            eaction: "setgrids",
                            id: id,
                            latn_id: latn_id,
                            bureau_no: bureau_no
                        }, function (data) {
                            data = $.parseJSON(data);
                            e1.unbind();
                            e1.on("change", function () {
                                e2.click();
                                var grid_id = $("#v_grid option:selected").val();
                                if (grid_id != "")//#0087d4
                                    $("#xinjian1").css({"background-color": "#0087d4"});
                                else
                                    $("#xinjian1").css({"background-color": "#989A9B"});
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.GRID_ID + "' value1='" + d.STATION_ID + "' value2='" + d.GRID_ZOOM + "'>" + d.GRID_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                        })
                    }

                    ///////////////营销列表
                    function setCitys_village(e, e1, e2, e3, e4) {
                        $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                            data = $.parseJSON(data)
                            var str = ''
                            e.unbind();
                            e.on("change", function () {

                                var id = e.find(":selected").val()
                                e1.html(baseFullOption)
                                e2.html(baseFullOption)
                                e3.html(baseFullOption)
                                e4.unbind();
                                e4.click();
                                if (id != '') {
                                		$("#yx_v_village_name").val("");
                                		$(".yx_village_table").html("");
                                		parent.left_list_type_selected = "village_yx";
                                    changeMapToCity($(this).find(":selected").text(), id);
                                }
                                setArea_village(id, e1, e2, e3, e4);
                            })
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
                            })
                            e.html(baseFullOptions)
                            e.append(str)
                            e.find("option[value=" + city_id + "]").attr("selected", "selected")
                            setArea_village(city_id, e1, e2, e3, e4)
                        })
                    }

                    function setArea_village(id, e1, e2, e3, e4) {
                        $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
                            data = $.parseJSON(data)
                            e1.unbind();
                            e1.on("change", function () {

                                e2.html(baseFullOption)
                                e3.html(baseFullOption)
                                var id = e1.find(":selected").val();
                                e4.unbind();
                                e4.click();
                                setBranchs_village(id, e2, e3, e4)
                                if (id != null) {
                                    setGrids_village(null, e3, e4)
                                }
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                            setBranchs_village(null, e2, e3, e4)
                        })
                    }

                    setBranchs_village = function (id, e1, e2, e3) {
                        var latn_id = $("#yx_v_city option:selected").val()
                        $.post(url4Query, {eaction: "setbranchs", id: id, latn_id: latn_id}, function (data) {
                            data = $.parseJSON(data)
                            e1.unbind();
                            e1.on("change", function () {
                                var id = e1.find(":selected").val()
                                e2.html(baseFullOption);
                                e3.unbind();
                                e3.click();
                                setGrids_village(id, e2, e3);

                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                        })
                    }
                    setGrids_village = function (id, e1, e2) {
                        var latn_id = $("#yx_v_city option:selected").val()
                        var bureau_no = $("#yx_v_area option:selected").val()
                        $.post(url4Query, {
                            eaction: "setgrids",
                            id: id,
                            latn_id: latn_id,
                            bureau_no: bureau_no
                        }, function (data) {
                            data = $.parseJSON(data);
                            e1.unbind();
                            e1.on("change", function () {
                                e2.click();
                                var grid_id = $("#yx_v_grid option:selected").val();
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.GRID_ID + "' value1='" + d.STATION_ID + "' value2='" + d.GRID_ZOOM + "'>" + d.GRID_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                        })
                    }
                    ///////////////

                    ////楼宇查询
                    function setCitys_build(e, e1, e2, e3, e4) {
                        $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                            data = $.parseJSON(data)
                            var str = ''
                            e.unbind();
                            e.on("change", function () {

                                var id = e.find(":selected").val()
                                e1.html(baseFullOption)
                                e2.html(baseFullOption)
                                e3.html(baseFullOption)
                                e4.click()
                                if (id != '') {
                                		$("#b_build_name").val("");
                                		$(".build_table").html("");
                                		parent.left_list_type_selected = "build";
                                    changeMapToCity($(this).find(":selected").text(), id);
                                }
                                setArea_build(id, e1, e2, e3, e4);
                            })
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
                            })
                            e.html(baseFullOptions)
                            e.append(str)
                            e.find("option[value=" + city_id + "]").attr("selected", "selected")
                            setArea_build(city_id, e1, e2, e3, e4)
                        })
                    }

                    function setArea_build(id, e1, e2, e3, e4) {
                        $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
                            data = $.parseJSON(data)
                            e1.unbind();
                            e1.on("change", function () {

                                e2.html(baseFullOption)
                                e3.html(baseFullOption)
                                var id = e1.find(":selected").val()
                                e4.click()
                                setBranchs_build(id, e2, e3, e4)
                                if (id != null) {
                                    setGrids_build(null, e3, e4)
                                }
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                            setBranchs_build(null, e2, e3, e4)
                        })
                    }

                    function setBranchs_build(id, e1, e2, e3) {
                        var latn_id = $("#b_city option:selected").val()
                        $.post(url4Query, {eaction: "setbranchs", id: id, latn_id: latn_id}, function (data) {
                            data = $.parseJSON(data)
                            e1.unbind();
                            e1.on("change", function () {
                                var id = e1.find(":selected").val()
                                e2.html(baseFullOption);
                                e3.click();
                                setGrids_build(id, e2, e3);
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                        })
                    }

                    function setGrids_build(id, e1, e2) {
                        var latn_id = $("#b_city option:selected").val()
                        var bureau_no = $("#b_area option:selected").val()
                        $.post(url4Query, {
                            eaction: "setgrids",
                            id: id,
                            latn_id: latn_id,
                            bureau_no: bureau_no
                        }, function (data) {
                            data = $.parseJSON(data);
                            e1.unbind();
                            e1.on("change", function () {
                                e2.click();
                                //var grid_id=$("#b_grid option:selected").val();
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.GRID_ID + "' value1='" + d.STATION_ID + "' value2='" + d.GRID_ZOOM + "'>" + d.GRID_NAME + "</option>"
                            })
                            e1.html(baseFullOption)
                            e1.append(str)
                        })
                    }

                    //网格查询选择框筛选
                    function setGCitys() {
                        $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                            data = $.parseJSON(data)
                            var str = '';
                            $("#g_city").unbind();
                            $("#g_city").on("change", function () {
                                var id = $(this).find(":selected").val()
                                $("#g_area").html(baseFullOption);
                                $("#g_branch").html(baseFullOption)
                                if (id != '') {
                                    $("#grid_query").click();
                                    parent.left_list_type_selected = "grid";
                                    $("#g_grid_name").text("");
                                    changeMapToCity($(this).find(":selected").text(), id);
                                }
                                setGArea(id)
                            })
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
                            })
                            $("#g_city").html(baseFullOptions)
                            $("#g_city").append(str)
                            $("#g_city").find("option[value=" + city_id + "]").attr("selected", "selected")
                            setGArea(city_id)
                        })
                    }

                    setGArea = function (id) {
                        $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
                            data = $.parseJSON(data)
                            $("#g_area").unbind();
                            $("#g_area").on("change", function () {
                                $("#g_branch").html(baseFullOption)
                                var id = $("#g_area").find(":selected").val()
                                $("#grid_query").click()
                                setGBranch(id)
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>"
                            })
                            $("#g_area").html(baseFullOption)
                            $("#g_area").append(str)
                            setGBranch()
                        })

                    }
                    setGBranch = function (id) {
                        var latn_id = $("#g_city option:selected").val()
                        $.post(url4Query, {eaction: "setbranchs", id: id, latn_id: latn_id}, function (data) {
                            data = $.parseJSON(data)
                            $("#g_branch").unbind();
                            $("#g_branch").on("change", function () {
                                $("#grid_query").click();
                            })
                            var str = ''
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>"
                            })
                            $("#g_branch").html(baseFullOption)
                            $("#g_branch").append(str)
                        })
                    }
                    //支局列表联动
                    function setBranchCity() {
                        $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                            data = $.parseJSON(data)
                            var str = '';
                            $("#br_city").unbind();
                            $("#br_city").on("change", function () {
                                var id = $(this).find(":selected").val()
                                $("#br_area").html(baseFullOption);
                                if (id != '') {
                                		$("#b_branch_name").val("");
                                    //$("#branch_query").click();
                                    $(".list_table").html("")
                                    parent.left_list_type_selected = "sub";

                                    changeMapToCity($(this).find(":selected").text(), id);
                                }
                                setBranchArea(id)
                            })
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
                            })
                            $("#br_city").html(baseFullOptions)
                            $("#br_city").append(str)
                            $("#br_city").find("option[value=" + city_id + "]").attr("selected", "selected")
                            setBranchArea(city_id)
                        })
                    }

                    function setBranchArea(id) {
                        $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
                            data = $.parseJSON(data);
                            $("#br_area").unbind();
                            $("#br_area").on("change", function () {
                                $("#branch_query").click();
                            })
                            var str = '';
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>";
                            })
                            $("#br_area").html(baseFullOption);
                            $("#br_area").append(str);
                        })
                    }

                    function setYCity() {
                        $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                            data = $.parseJSON(data)
                            var str = '';
                            $("#y_city").unbind();
                            $("#y_city").on("change", function () {
                                var id = $(this).find(":selected").val();
                                $("#y_area").html(baseFullOption);
                                if (id != '') {
                                    changeMapToCity($(this).find(":selected").text(), id);
                                }
                                setYArea(id);
                                $("#cc").click();
                            })
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
                            })
                            $("#y_city").html(baseFullOptions)
                            $("#y_city").append(str)
                            $("#y_city").find("option[value=" + city_id + "]").attr("selected", "selected")
                            setYArea(city_id)
                        })
                    }

                    function setYArea(id) {
                        $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
                            data = $.parseJSON(data);
                            $("#y_area").unbind();
                            $("#y_area").on("change", function () {
                                $("#cc").click();
                            })
                            var str = '';
                            $.each(data, function (i, d) {
                                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>";
                            })
                            $("#y_area").html(baseFullOption);
                            $("#y_area").append(str);
                        })
                    }

                    //setYCity();
                    $("#branch_query").unbind();
                    $("#branch_query").on("click", function () {
                        queryBranch()
                    })
                    function queryBranch(id) {
                        if (id != city_id)
                            id = $("#br_city option:selected").val()
                        var area = $("#br_area option:selected").val()
                        var branch_name = $("#b_branch_name").val()
                        $.post('<e:url value="querysubgrid.e"/>', {
                            eaction: "getSubListByLatnId",
                            city_id: id,
                            id: area,
                            branch_name: branch_name
                        }, function (data) {
                            data = $.parseJSON(data);
                            var data1 = data[1];
                            data = data[0];
                            var sub_style_num = new Array();
                            var sub_show_num = 0;
                            var str = "";
                            $(".list_table").html("")
                            for (var i = 0, l = data.length; i < l; i++) {
                                var d = data[i];

                                str += "<tr class=\"tr_default_background_color\" style=\"color:" + (d.BRANCH_SHOW == 0 || (d.FLAG != 1 && d.FLAG !=0) ? '#f00' : '#000') + "\" onclick=\"javascript:clickToSub('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this," + d.ZOOM + ")\" ><td style='width: 10%;text-align: center'>" + (i + 1) + "</td><td style='width: 22%;text-align: center'>" + d.LATN_NAME + "</td><td style='width: 48%' title=\"" + d.BRANCH_NAME + "\">" + (d.BRANCH_NAME.length > 7 ? d.BRANCH_NAME.substr(0, 7) + ".." : d.BRANCH_NAME) + d.GRID_NUM + "</td><td style='width: 20%;text-align: center'>" + d.BRANCH_TYPE_CHAR + "</td></tr>";

                                if (sub_style_num[d.BRANCH_TYPE] == undefined)
                                    sub_style_num[d.BRANCH_TYPE] = 1;
                                else
                                    sub_style_num[d.BRANCH_TYPE] += 1;
                                sub_show_num += d.BRANCH_SHOW;
                            }
                            var stan = 20;
                            var len = $(parent.window).width()
                            if (len < 1900)
                                stan = 10;
                            if (data.length == 0) {
                                str += "<tr><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>";
                            } else if (data.length <= stan) {
                                for (var j = 0; j < stan - data.length; j++) {
                                    str += "<tr class=\"tr_default_background_color\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\" onMouseOut=\"this.style.background='rgb(250,250,250)'\" ><td style='width: 10%;text-align: center'></td><td style='width: 22%;text-align:center'></td><td style='width: 48%;text-align: center'></td><td style='width: 20%;text-align: center'></td></tr>";
                                }
                            }
                            $(".list_table").append(str);
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

                    setBuildCity = function () {
                        $.post(url4Query, {eaction: 'b_city'}, function (data) {
                            data = $.parseJSON(data)
                            var e = $("#b_city");
                            $("#b_city").unbind();
                            e.on("change", function () {
                                var id = e.find(":selected").val()
                                $("#b_area").html(baseFullOption)
                                $("#b_street").html(baseFullOption)
                                //联动
                                if (id != '') {
                                    changeMapToCity($(this).find(":selected").text(), id);

                                }
                                setBuildArea(id)
                                queryBuild('')
                            })
                            var str = ''
                            $.each(data, function (i, obj) {
                                str += "<option value='" + obj.LATN_ID + "'>" + obj.LATN_NAME + "</option>"
                            })
                            e.append(str)

                            e.find("option[value=" + city_id + "]").attr("selected", "selected")
                            setBuildArea(city_id)
                        })
                    }

                    setBuildArea = function (id) {
                        var e = $("#b_area");
                        $.post(url4Query, {eaction: 'b_area', id: id}, function (data) {
                            data = $.parseJSON(data)
                            e.html(baseFullOption)
                            $("#b_area").unbind();
                            e.on("change", function () {
                                var id = e.find(":selected").val()
                                $("#b_street").html(baseFullOption)
                                //联动
                                if (id != '') {
                                    setBuildStreet(id)
                                }
                                queryBuild('')
                            })
                            var str = ''
                            $.each(data, function (i, obj) {
                                str += "<option value='" + obj.REGION_NO + "'>" + obj.REGION_NAME + "</option>"
                            })
                            e.append(str)
                        })

                    }
                    setBuildStreet = function (id) {
                        var e = $("#b_street");
                        $.post(url4Query, {eaction: 'b_street', id: id}, function (data) {
                            data = $.parseJSON(data)
                            e.html(baseFullOption)
                            $("#b_street").unbind();
                            e.on("change", function () {
                                //联动
                            })
                            var str = ''
                            $.each(data, function (i, obj) {
                                str += "<option value='" + obj.STREET_NO + "'>" + obj.STREET_NAME + "</option>"
                            })
                            e.append(str)
                        })
                    }

										//左侧按钮
										//小区按钮
										//切换到小区
										$("#nav_type_village").unbind();
										$("#nav_type_village").click(
											function(){
												//hideVillageLayer();
												nav_type_index = "village";
												standard_where = "";
												if(map.getZoom()>=6){
													standard_load();
													draw_layer_mark_build.clear();
													drawed_layer_mark_build.clear();
													buildInsideVillageColorful();
												}
												position_layer.clear();
												xinjian_toggle();
												hideAllServiceLayers();
												showVillageLayer();
												pos_tab_query();
											}
										);
										//切换到校园
										$("#nav_type_school").unbind();
										$("#nav_type_school").click(
											function(){
												//hideVillageLayer();
												nav_type_index = "school";
												standard_where = "ext1 = 2";
												if(map.getZoom()>=6){
													standard_load();
													draw_layer_mark_build.clear();
													drawed_layer_mark_build.clear();
													buildInsideVillageColorful();
												}
												position_layer.clear();
												xinjian_toggle();
												hideAllServiceLayers();
												showSchoolLayer();
												pos_tab_query();
											}
										);
										//切换到商客
										$("#nav_type_enterprise").unbind();
										$("#nav_type_enterprise").click(
											function(){
												//hideVillageLayer();
												nav_type_index = "enterprise";
												standard_where = "ext1 = 3";
												if(map.getZoom()>=6){
													standard_load();
													draw_layer_mark_build.clear();
													drawed_layer_mark_build.clear();
													buildInsideVillageColorful();
												}
												position_layer.clear();
												xinjian_toggle();
												hideAllServiceLayers();
												showEnterpriseLayer();
												pos_tab_query();
											}
										);

										function xinjian_toggle(){
											if(nav_type_index=="village"){//小区不用新建功能
												$("#nav_func_xinjian1").hide();
											}else{
												$("#nav_func_xinjian1").show();
											}
										}
										function hideAllServiceLayers(){
												hideVillageLayer();
												hideSchoolLayer();
												hideEnterpriseLayer();
										}

										$("#nav_func_xinjian1").unbind();
										$("#nav_func_xinjian1").click(
											function(){
												//hideVillageLayer();
												$("#xinjian1").click();
											}
										);
										$("#nav_func_pos_tab").unbind();
										$("#nav_func_pos_tab").click(
											function(){
												$("#pos_tab_win").show();
											}
										);
										//校园政企返回 返回上级
										$("#nav_func_back").unbind();
										$("#nav_func_back").click(
											function(){
												//hideVillageLayer();
												if(parent.global_fromProvince==1)
													parent.backToPosition(1,'<e:url value="pages/telecom_Index/channel_leader/leader_province_level.jsp" />');
												else
													parent.backToPosition(1,'<e:url value="pages/telecom_Index/channel_leader/leader_city_level.jsp" />');
											}
										);
										//左侧指标按钮切换
								    $(".nav_index_group").children().each(function(){
								      $(this).on("click",function(){
								      	$(this).addClass("active").siblings().removeClass("active");
								      });
								    });

                    //楼宇开始
                    $("#nav_standard").unbind();
                    $("#nav_standard").click(
                            function () {
                                resetNavMenu();
                                if (tmpl == '') {
                                    tmpl = '1';
                                    $("#nav_standard").removeClass("active");
                                } else {
                                    tmpl = '';
//                                var point = map.center;
//                                var zoom = map.getZoom()>=9?map.getZoom():9;
//                                map.centerAndZoom(point,zoom);
                                    $("#nav_standard").addClass("active");
                                    //setBuildCity();

//                standard_load();
                                    layer.open({
                                        title: ['楼宇列表', 'line-height:32px;text-size:30px;height:32px;'],
                                        //title:false,
                                        type: 1,
                                        shade: 0,
                                        area: ['298px', '99.4%'],
                                        offset: ['1px', '38px'],
                                        content: $("#build_div"),
                                        cancel: function (index) {
                                            $("#nav_standard").removeClass("active");
                                            return tmp1 = '1';
                                        }
                                    });
                                    queryBuild('', 0);
                                }
                            }
                    );

                    //queryBuild(city_id, 0);
                    //getBuildCount_buildList('', '', city_id, '', '');
                    /*yinming 2017-7-21 10:30:13 营销按钮点击移动到楼宇点击下面 做出相应逻辑修改*/

                    //小区的营销情况 2017-09-06 新功能
                    $("#nav_marketing_village").unbind();
                    $("#nav_marketing_village").click(
                            function () {
                                resetNavMenu();
                                if (tmpy_v == '') {
                                    tmpy_v = '1';
                                    $("#nav_marketing_village").removeClass("active");
                                } else {
                                    tmpy_v = '';
                                    $("#nav_marketing_village").addClass("active");
                                    $("#chaxun_village").val("");
                                    yingxiao_village_table_layer = layer.open({
                                        title: ['营销列表', 'line-height:32px;text-size:30px;height:32px;'],
                                        //title:false,
                                        type: 1,
                                        shade: 0,
                                        area: ['298px', '99.4%'],
                                        offset: ['1px', '38px'],
                                        content: $("#yingxiao_village_div"),
                                        cancel: function (index) {
                                            $("#nav_marketing_village").removeClass("active");
                                            return tmpy_v = '1';
                                        }
                                    });
                                    queryYX_village(city_id,0);
                                }
                            }
                    );
                    //左侧收集
                    var tmp_info_collect = "1";
                    $("#nav_info_collect").unbind();
                    $("#nav_info_collect").click(//信息收集大表格
                            function(){
                                parent.load_list_info_collect();
                            }
                    );
                    /*$("#nav_info_collect").click(
                            function () {
                                resetNavMenu();
                                if (tmp_info_collect == '') {
                                    tmp_info_collect = '1';
                                    $("#nav_info_collect").removeClass("active");
                                } else {
                                    tmpy_v = '';
                                    $("#nav_info_collect").addClass("active");
                                    $("#info_collect_summary_div > iframe").attr("src", "viewPlane_info_collect_summary.jsp");
                                    //$("#info_collect_summary_div").show();
                                    collect_summary_handler = layer.open({
                                        title: ['收集统计', 'line-height:32px;text-size:30px;height:32px;'],
                                        //title:false,
                                        type: 1,
                                        shade: 0,
                                        area: ['710px', '485px'],
                                        //offset: ['1px', '38px'],
                                        content: $("#info_collect_summary_div"),
                                        cancel: function (index) {
                                            $("#nav_marketing2").removeClass("active");
                                            layer.close(collect_summary_handler);
                                            tmp_info_collect = "1";
                                            return tmpx = '1';
                                        }
                                    });
                                }
                            }
                    );*/
                    //打开信息收集列表
                    openWinInfoCollectionList = function (latn_id, bureau_no, union_org_code, grid_id) {
                        //$("#info_collect_summary_div").hide();
                        $("#info_collect_list_div > iframe").attr("src", "viewPlane_info_collect_list.jsp?latn_id=" + latn_id + "&bureau_no=" + bureau_no + "&union_org_code=" + union_org_code + "&grid_id=" + grid_id);
                        //$("#info_collect_list_div").show();
                        collect_list_handler = layer.open({
                            title: ['收集列表', 'line-height:32px;text-size:30px;height:32px;'],
                            //title:false,
                            type: 1,
                            shade: 0,
                            area: ['710px', '485px'],
                            //offset: ['1px', '38px'],
                            content: $("#info_collect_list_div"),
                            cancel: function (index) {
                                layer.close(collect_list_handler);
                                $("#nav_marketing2").removeClass("active");
                                return tmpx = '1';
                            }
                        });
                    }
                    //打开信息收集详情
                    openWinInfoCollectionView = function (add6_id, city_id, area_id, substation, grid_id) {
                        $("#info_collect_view_div > iframe").attr("src", "viewPlane_info_collect_view.jsp?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
                        //$("#info_collect_view_div").show();
                        collect_view_handler = layer.open({
                            title: ['收集详情', 'line-height:32px;text-size:30px;height:32px;'],
                            //title:false,
                            type: 1,
                            shade: 0,
                            area: ['660px', '470px'],
                            //offset: ['1px', '38px'],
                            content: $("#info_collect_view_div"),
                            cancel: function (index) {
                                layer.close(collect_view_handler);
                                $("#nav_marketing2").removeClass("active");
                                return tmpx = '1';
                            }
                        });
                    }

                    //打开信息收集编辑页面
                    openWinInfoCollectEdit = function (add6_id, city_id, area_id, substation, grid_id) {
                        //$("#info_collect_view_div").hide();
                        $("#info_collect_edit_div > iframe").attr("src", "viewPlane_info_collect_edit.jsp?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
                        //$("#info_collect_edit_div").show();
                        collect_edit_handler = layer.open({
                            title: ['竞争收集', 'line-height:32px;text-size:30px;height:32px;'],
                            //title:false,
                            type: 1,
                            shade: 0,
                            area: ['660px', '470px'],
                            //offset: ['1px', '38px'],
                            content: $("#info_collect_edit_div"),
                            cancel: function (index) {
                                layer.close(collect_edit_handler);
                                $("#nav_marketing2").removeClass("active");
                                return tmpx = '1';
                            }
                        });
                    }

                    //打开信息收集编辑页面
                    openCustViewByProdInstId = function (param) {
                    		var segment_id      =param.segment_id  ;
												var prod_inst_id    =param.prod_inst_id;
												var order_id        =param.order_id    ;
												var add6            =param.add6        ;
												var tab_id          =param.tab_id      ;
												var exec_able       =param.exec_able   ;
												var scene_id        =param.scene_id    ;
												var mkt_campaign_id =param.mkt_campaign_id;
												var pa_date					=param.pa_date		 ;
												var is_lost         =param.is_lost     ;
												var is_yx           =param.is_yx       ;
												var is_village			=param.is_village	 ;

												//新版本客户视图
												var is_new_cust_view = "";
												/*is_new_cust_view = 1;
												if(prod_inst_id){
	                    		parent.openCustomView(param);
	                    		return;
                    		}*/

                        //$("#info_collect_view_div").hide();
                        $("#info_collect_edit_div > iframe").attr("src", "<e:url value='/pages/telecom_Index/sub_grid/viewPlane_info_collect_edit_diy_new.jsp' />?segment_id=" + segment_id + "&city_id=" + city_id+"&prod_inst_id="+prod_inst_id+"&tab_id="+tab_id+"&add6="+add6+"&order_id="+order_id+"&exec_able="+exec_able+"&scene_id="+scene_id+"&is_lost="+is_lost+"&is_yx="+is_yx+"&is_village="+is_village+"&mkt_campaign_id="+mkt_campaign_id+"&pa_date="+pa_date+"&is_new_cust_view="+is_new_cust_view);
                        //$("#info_collect_edit_div > iframe").attr("src", "<e:url value='/pages/telecom_Index/sub_grid/viewPlane_custom_view.jsp' />?segment_id=" + segment_id + "&city_id=" + city_id);
                        //$("#info_collect_edit_div").show();
                        cust_view_handler = layer.open({
                            title: ' ',
                            //title:false,
                            maxmin: true, //开启最大化最小化按钮

                            type: 1,
                            shade: 0,
                            //maxmin: true, //开启最大化最小化按钮
                            area: ['860px', '485px'],
                            //offset: ['56px', '158px'],
                            content: $("#info_collect_edit_div"),
                            skin: 'cus_view',//'yxzx_div',
                            cancel: function (index) {
                                layer.close(cust_view_handler);
                                //$("#nav_info_collect").removeClass("active");
                                //return tmp_info_collect = '1';
                            },
                            full: function() { //点击最大化后的回调函数
								                 $(".cus_view .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
								            },
								            restore: function() { //点击还原后的回调函数
								                 $(".cus_view .layui-layer-setwin").css("top",'6px');
								            }
                        });
                        //$(".info_collect .layui-layer-setwin").addClass("close_table");
                    }

                    //新客户视图
                    openNewWinInfoCollectEdit = function (segment_id,tab_id) {
                    		if(tab_id==undefined)
                    			tab_id = 0;
                    		$.post("<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp' />",{"eaction":"prod_list","segment_id":segment_id,'acct_month':'${user_list_m_last_month.VAL}'},function(data){
                    				var d = $.parseJSON(data);
                    				if(d.length>1){
                    					$("#prod_list_win > iframe").attr("src", "<e:url value='/pages/telecom_Index/sub_grid/viewPlane_prod_list.jsp' />?segment_id=" + segment_id + "&city_id=" + city_id+"&acct_month="+'${user_list_m_last_month.VAL}');
			                        prod_list_win = layer.open({
			                            title: '客户列表',
			                            //title:false,
			                            type: 1,
			                            shade: 0,
			                            area: ['414px','355px'],
			                            //offset: ['56px', '158px'],
			                            content: $("#prod_list_win"),
			                            skin: 'yxzx_div',//'yxzx_div',
			                            cancel: function (index) {

			                            }
			                        });
			                        $(".info_collect .layui-layer-setwin").addClass("close_table");
                    				}else if(d.length==1){
                    					var param = {};
                    					param.segment_id = segment_id;
                    					param.prod_inst_id = d[0].PROD_INST_ID;
                    					param.tab_id = tab_id;
                    					openCustViewByProdInstId(param);
                    				}else{
                    					var param = {};
                    					param.segment_id = segment_id;
                    					param.tab_id = tab_id;
                    					openCustViewByProdInstId(param);
                    				}
                    		});
                    }
                    //关闭 新客户视图
                    closeWinCustViewWin = function(){
                    	layer.close(prod_list_win);
                    }

                    //关闭信息收集编辑页面
                    closeWinInfoCollectionEdit = function (add6_id, city_id, area_id, substation, grid_id) {
                        //$("#info_collect_edit_div").hide();
                        //openWinInfoCollectionView(add6_id, city_id, area_id, substation, grid_id);
                        layer.close(cust_view_handler);
                    }

                    $("#nav_marketing_btn").unbind();
                    $("#nav_marketing_btn").click(
                            function () {
                                tmpy_v = '1';
                                $("#nav_marketing_village").removeClass("active");
                                $("#xinjian").click();
                            }
                    );
                    //营销弹出 绘图菜单 功能暂时隐藏
                    $("#nav_marketing").unbind();
                    $("#nav_marketing").click(
                            function () {
                                $("#village_info_win").hide()
                                $('#build_info_win').hide()
                                $('#build_info_win').hide();
                                $("#marketing_div").hide();
                                $("#yingxiao_info_win").hide();
                                $("#yingxiao_new_win").hide();
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
                                tmpy_v = '1';
                                $("#nav_marketing_village").removeClass("active");
                                if (tmpy == '') {
                                    tmpy = '1';
                                    $("#nav_marketing").removeClass("active");
                                } else {
                                    tmpy = '';
                                    $("#nav_marketing").addClass("active");
                                    $("#chaxun").val("");
                                    yingxiao_table_layer = layer.open({
                                        title: ['营销列表', 'line-height:32px;text-size:30px;height:32px;'],
                                        //title:false,
                                        type: 1,
                                        shade: 0,
                                        area: ['298px', '99.4%'],
                                        offset: ['1px', '38px'],
                                        content: $("#yingxiao_div"),
                                        cancel: function (index) {
                                            $("#nav_marketing").removeClass("active");
                                            return tmpx = '1';
                                        }
                                    });
                                    queryYX();
                                }
                            }
                    );
                    $("#clear_draw").unbind();
                    $("#clear_draw").on('click', function () {
                        $('#yingxiao_info_win').hide();
                        $('#yingxiao_info_win_new').hide();
                        draw_layer.clear();
                    });
                    $("#clear_draw_village").unbind();
                    $("#clear_draw_village").on("click", function () {
                    		$("#buildInVillage_review_win").hide();
                        if (draw_build_result_array_for_buildVillage != "" && draw_build_result_array_for_buildVillage.length > 0) {
                            var ids = draw_build_result_array_for_buildVillage[draw_build_result_array_for_buildVillage.length - 1];
                            if (ids instanceof Array) {//框选的结果
                                for (var i = 0, l = ids.length; i < l; i++) {
                                    var id = ids[i];
                                    //清除图形
                                    draw_layer_mark_build.remove(draw_graphics_array_for_buildInVillage[id + ""]);

                                    delete draw_graphics_array_for_buildInVillage[id];
                                    //清除最终结果
                                    delete buildInVillage[id];
                                    delete buildInVillage_short[id];
                                }
                            }
                            else {//点选的结果
                                //清除图形
                                draw_layer_mark_build.remove(draw_graphics_array_for_buildInVillage[ids]);
                                delete draw_graphics_array_for_buildInVillage[ids];
                                //清除最终结果
                                delete buildInVillage[ids];
                                delete buildInVillage_short[ids];
                            }
                            draw_build_result_array_for_buildVillage.splice(draw_build_result_array_for_buildVillage.length - 1, 1);
                        }
                    });
                    /*yinming 2017-7-21 10:30:13 营销按钮end*/
                    /*function showLocation(position){
                     var pt = new Point(position.coords.longitude,position.coords.latitude);
                     var attributes = {"lat":pt.y.toFixed(2),"lon":pt.x.toFixed(2)};
                     var infoTemplate = new InfoTemplate("我的位置","纬度:
                    ${lat}<br/>经度:
                    ${lon}");
                     var graphic = new Graphic(pt,symbol,attributes,infoTemplate);
                     map.graphics.add(graphic);
                     map.centerAndZoom(pt,9);
                     }
                     function errorHandler(err){
                     if(err.code==1)
                     alert("错误:禁止方位");
                     else if(err.code==2)
                     alert("错误:不能获得位置");
                     else
                     alert("错误:"+err);
                     }*/
                    /*yinming 2017年7月21日16:12:42 营销新建*/
                    $("#xinjian").click(
                            function () {
                                $("#sub_info_win").hide();
                                $("#grid_info_win").hide();
                                //隐藏无关的按钮
                                if ($("#nav_fanhui_sub").is(':visible')) {
                                    $("#nav_fanhui_sub").hide();//隐藏返回按钮
                                    back_btn_hided = "#nav_fanhui_sub";
                                }
                                else if ($("#nav_fanhui_qx").is(':visible')) {
                                    $("#nav_fanhui_qx").hide();//隐藏返回按钮
                                    back_btn_hided = "#nav_fanhui_qx";
                                } else if ($("#nav_fanhui").is(':visible')) {
                                    $("#nav_fanhui").hide();//隐藏返回按钮
                                    back_btn_hided = "#nav_fanhui";
                                } else if ($("#nav_fanhui_city").is(':visible')) {
                                    $("#nav_fanhui_city").hide();//隐藏返回按钮
                                    back_btn_hided = "#nav_fanhui_city";
                                }
                                $('#yingxiao_info_win_new').hide();
                                $(".tools_n").hide();//隐藏左侧工具条
                                parent.hideMapPosition();//隐藏地图右上方返回路径条
                                //先放大到楼宇级别，9级，只在框选功能中有效
                                var zoom = map.getZoom();
                                if (zoom < 9 && draw_type != "village") {
                                    /*if(navigator.geolocation){
                                     navigator.geolocation.getCurrentPosition(showLocation,errorHandler);
                                     }else{
                                     console.log("该浏览器不支持geolocation");
                                     }*/
                                    var point = map.center;
                                    map.centerAndZoom(point, 9);
                                }

                                $("#nav_standard").addClass("active");

                                $("#nav_marketing").addClass("active");
                                //map.setMapCursor("crosshair");
                                map.infoWindow.hide();
                                draw_layer.clear();
                                draw_layer.show();
                                village_layer.clear();
                                village_position_layer.clear();
                                draw_layer_mark_build.clear();

                                killEvent();
                                killEventForBuildInVillage();
                                reboundForBuildInVillage();
                                if (draw_layer_leida_click_handler != "")
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
                    /*yinming 2017年7月21日16:12:42 营销新建end*/

                    var vboo = true;
                    var vgrid_id = null;
                    var vsub_id = null;
                    /*liangliyuan 2017年8月10日17:35:14 小区新建begin*/

                    var standard_where = "ext1 = 2";//默认加载校园关联的楼宇

                    $("#xinjian1").css({"background-color": "#989A9B"});//#0087d4 蓝色   #989A9B  灰色
                    $("#xinjian1").click(
                          function () {
                          		if(nav_type_index=="school"){
                          				hideAllServiceLayers();
																	showSchoolLayer();
                          		}else if(nav_type_index=="enterprise"){
                          				hideAllServiceLayers();
																	showEnterpriseLayer();
                          		}else{
                          				standard_where = "";
                          		}
                          		$("#village_scale").empty();
                          		$.post(url4Query_enterprise,{"eaction":"getEnterpriseType","type":nav_type_index},function(data){
																var d = $.parseJSON(data);
																for(var i = 0,l = d.length;i<l;i++){
																	var item = d[i];
																	$("#village_scale").append("<option value='"+item.DIC_CODE+"'>"+item.DIC_DESC+"</option>");
																}
															});

                          		map.setZoom(9);

                              $("#sub_info_win").hide();
                              $("#grid_info_win").hide();
                              vboo = false;
                              buildInVillage_mode = "add";

                              draw_layer_mark_build.clear();
                              draw_layer_mark_build.show();
                              draw_layer_mark_build.visible = true;
                              buildInVillage = new Array();
                              buildInVillage_short = new Array();
                              draw_graphics_array_for_buildInVillage = new Array();
                              draw_build_result_array_for_buildVillage = new Array();

                              //隐藏无关的按钮

                              //左侧新标签
                              $("#tools_scroll").hide();

                              if ($("#nav_fanhui_sub").is(':visible')) {
                                  $("#nav_fanhui_sub").hide();//隐藏返回按钮
                                  back_btn_hided = "#nav_fanhui_sub";
                              } else if ($("#nav_fanhui_qx").is(':visible')) {
                                  $("#nav_fanhui_qx").hide();//隐藏返回按钮
                                  back_btn_hided = "#nav_fanhui_qx";
                              } else if ($("#nav_fanhui").is(':visible')) {
                                  $("#nav_fanhui").hide();//隐藏返回按钮
                                  back_btn_hided = "#nav_fanhui";
                              } else if ($("#nav_fanhui_city").is(':visible')) {
                                  $("#nav_fanhui_city").hide();//隐藏返回按钮
                                  back_btn_hided = "#nav_fanhui_city";
                              }

                              $('#yingxiao_info_win_new').hide();
                              $(".tools_n").hide();//隐藏左侧工具条
                              parent.hideMapPosition();//隐藏地图右上方返回路径条
                              //先放大到楼宇级别，9级，只在框选功能中有效
                              //var zoom = map.getZoom();
                              //if(zoom<9 && draw_type != "village"){
                              /*if(navigator.geolocation){
                               navigator.geolocation.getCurrentPosition(showLocation,errorHandler);
                               }else{
                               console.log("该浏览器不支持geolocation");
                               }*/
                              //    var point = map.center;
                              //    map.centerAndZoom(point,9);
                              //}

                              $("#nav_standard").addClass("active");

                              $("#nav_marketing").addClass("active");
                              //map.setMapCursor("crosshair");
                              map.infoWindow.hide();
                              draw_layer.clear();
                              draw_layer.show();
                              village_layer.clear();
                              village_position_layer.clear();
                              draw_layer_mark_build.clear();
                              killEvent();
                              killEventForBuildInVillage();
                              reboundForBuildInVillage();
                              if (draw_layer_leida_click_handler != "")
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
                              $("#village_frame_div").show();
                              draw_layer.show();
                          }
                    );
                    /*liangliyuan 2017年8月10日17:35:14 小区新建end*/

                    /*yinming 2017年7月21日10:39:10 新增营销查询*/
                    $("#cc").unbind();
                    $("#cc").click(function () {
                        queryYX()
                    })

                    function queryYX() {
                        //清空列表
                        var latn_id = $("#y_city option:selected").val()
                        var area_id = $("#y_area option:selected").val()
                        if (latn_id == 947)
                            latn_id = 937
                        var chaxun = $("#chaxun").val();
                        $.post(url4Query, {
                            eaction: 'yingxiao_list',
                            chaxun: chaxun,
                            latn_id: latn_id,
                            area_id: area_id
                        }, function (data) {
                            data = $.parseJSON(data);
                            $("#yingxiao_table").html("");
                            if (data != null) {
                                $.each(data, function (i, d) {
                                    /*var x =d.VILLAGE_NAME
                                     if(x.length>8)
                                     x=x.substr(0,7)+'..'*/
                                    var str = "<tr class=\"tr_default_background_color\" style='font-size:14px;cursor:pointer;' onclick=\"javascript:queryfromyxid('" + d.YX_ID + "',this)\"><td style='width: 15%;text-align: center'>" + (i + 1) + "</td><td style='width: 55%;text-align:left;' >" + d.YX_NAME + "</td><td style='text-align: left' >" + d.CREATE_DATE + "</td></tr>"
                                    $("#yingxiao_table").append(str);
                                })
                            }
                            var stan = 20;
                            var width = $(parent.window).width()
                            if (width <= 1900)
                                stan = 8
                            if (data.length == 0) {
                                $("#yingxiao_table").html("")
                                $("#yingxiao_table").html("<tr><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                            } else if (data.length < stan) {
                                for (var i = 0; i <= stan - data.length; i++) {
                                    var str = "<tr class=\"tr_default_background_color\" onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='text-align: center'></td><td style='text-align:center;' ></td><td style='text-align: center'></td></tr>";
                                    $("#yingxiao_table").append(str)
                                }
                            }
                        })
                    }

                    /*yinming 2017年7月21日10:39:10 新增营销查询 end*/

                    /*liangliyuan 2017年9月6日18:33:00 新增小区范围的营销结果 begin*/
                    function queryYX_village(latn_id,page) {//yingxiao_village_div
                        //清空列表
                        seq_um_yx_village = 0;
                        var vn = $("#yx_v_village_name").val()
                        if (latn_id == null || latn_id == undefined) {
                            latn_id = $("#yx_v_city option:selected").val()
                        }
                        var bureau_no = $("#yx_v_area option:selected").val()
                        var union_org_code = $("#yx_v_branch option:selected").val()
                        var grid_id = $("#yx_v_grid option:selected").val()
                        yx_village_list_page = 0;
                        $(".yx_village_table").empty();
                        //获取数量
                        getYxVillageCount_YxVillageList(latn_id,bureau_no,union_org_code,grid_id,vn);
                        //加载一页数据
                        if(page==undefined || page=="")
                        	page = 0;
                        queryYX_villageListScroll(latn_id,bureau_no,union_org_code,grid_id,vn,page);
                    }

                    var seq_um_yx_village = 0;
                    function queryYX_villageListScroll(latn_id,bureau_no,union_org_code,grid_id,vn,page){
                    	$.post(url4Query, {
                            eaction: 'yingxiao_list_for_village_page',
                            latn_id: latn_id,
                            bureau_no: bureau_no,
                            union_org_code: union_org_code,
                            grid_id: grid_id,
                            village_name: $.trim(vn),
                            "page":page
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data != null) {
                                $.each(data, function (i, d) {
                                    /*var x =d.VILLAGE_NAME
                                     if(x.length>8)
                                     x=x.substr(0,7)+'..'*/
                                    var str = "<tr class=\"tr_default_background_color\" style='font-size:14px;cursor:pointer;color:\"black\"' onclick=\"javascript:clickToGridAndVillage('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this," + d.GRID_ZOOM + ",'" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "',3)\" ><td style='width:12%;text-align: center'>" + (++seq_um_yx_village) + "</td>";
                                    str += "<td style='width:25%;text-align:left' title=\"" + d.VILLAGE_NAME + "\">" + (d.VILLAGE_NAME.length > 7 ? d.VILLAGE_NAME.substr(0, 8) + "..." : d.VILLAGE_NAME) + "</td>";
                                    str += "<td style='width:16%;'>" + d.YX_ALL + "</td><td style='width:16%;'>" + d.YX_UN + "</td><td style='width:12%;'>" + d.YX_LV + "</td></tr>";
                                    $(".yx_village_table").append(str);
                                })
                            }
                            var stan = 20;
                            var width = $(parent.window).width()
                            if (width <= 1900)
                                stan = 8
                            if (data.length == 0 && seq_um_yx_village==0) {
                                $(".yx_village_table").html("")
                                $(".yx_village_table").html("<tr><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                            } else if (data.length < stan) {
                            		if(data.length == 0)
                            			return;
                                for (var i = 0; i <= stan - data.length; i++) {
                                    var str = "<tr class=\"tr_default_background_color\" onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='text-align: center'></td><td style='text-align:center;' ></td><td style='text-align: center'></td></tr>";
                                    $(".yx_village_table").append(str)
                                }
                            }
                        })
                    }

                    /*liangliyuan 2017年9月6日18:33:00 新增小区范围的营销结果 end*/

                    //小区统计弹窗
                    $("#village_summary_list_pop_btn").unbind();
                    $("#village_summary_list_pop_btn").on("click", function () {
                    		resetNavMenu();
                        $("#village_summary_list_pop_win > iframe").attr("src",'<e:url value="/pages/telecom_Index/common/jsp/village_summary_list.jsp"/>?city_id='+city_id);
                        villageSummaryListPop();
                    })

                    function villageSummaryListPop(){
                    	layer.open({
                            title: ['小区统计', 'line-height:30px;text-size:30px;height:30px;'],
                            type: 1,
                            shade: 0,
                            area: ['95%', '90%'],
						//							skin: 'demo-class',
                            offset: 'rb',
                            content: $("#village_summary_list_pop_win"),
                            cancel: function () {//右上角关闭回调
                                $("#village_summary_list_pop_win").hide();
                            }
                        });
                    }

                    /*yinming 2017年7月22日14:51:59 营销联动*/
                    var yx_id_global_from_win = "";//从营销窗口弹出的
                    queryfromyxid = function (id, thiz) {
                        //$("#village_title_yx_view").text("查看营销");
                        $("#yingxiao_info_win_new").children(".tab_menu").find("span").eq(0).click();
                        $("#yingxiao_info_win_new").show();
                        $("#yx_view_yx_id").val(id);

                        $(thiz).siblings().removeClass("tr_click_background_color");//background-color: #c1c1c1;
                        $(thiz).siblings().addClass("tr_default_background_color");
                        $(thiz).removeClass("tr_default_background_color");
                        $(thiz).addClass("tr_click_background_color");

                        //第一个标签页 营销概况
                        $.post(url4Query, {eaction: "yx_view_query_sum", yxid: id}, function (data) {
                            data = $.parseJSON(data);
                            $("#yx_view_title").text(data.YX_NAME);
                            $("#yx_view_creator").text(data.CREATE_NAME);
                            $("#yx_view_create_time").text(data.CREATE_DATE);
                            $("#yx_view_yd_count").text(data.YD_COUNT);
                            $("#yx_view_kd_count").text(data.KD_COUNT);
                            $("#yx_view_ds_count").text(data.ITV_COUNT);
                            $("#yx_view_market_lv").text(data.MARKET_LV + "%");
                            $("#yx_view_build_count").text(data.BUILD_COUNT);
                            $("#yx_view_zhu_hu").text(data.ZHU_HU_SHU);
                            //$("#yx_view_port_lv").text(data.PORT_LV + "%");
                            //$("#yx_view_port").text(data.PORT_ALL);
                            //$("#yx_view_port_used").text(data.PORT_ALL - data.PORT_FREE);
                            //$("#yx_view_free_port").text(data.PORT_FREE);
                        });

                        $("#yx_view_yx_list").empty();
                        //第二个营销标签页，营销列表
                        freshYXViewList(id, "");

                        //还原营销图形
                        draw_layer.clear();
                        $.post(url4Query, {eaction: "yx_detail_query", yxid: id}, function (geoData) {
                            var jsonData = $.parseJSON(geoData);
                            if (jsonData.length == 0) {
                                layer.msg("该营销没有绘制过图形");
                                return;
                            }
                            var geotry = WktToPolygon(jsonData[0].GEOSHPE, "4326");
                            var symbol = new SimpleFillSymbol().setColor(new dojo.Color(draw_fill_color));
                            symbol.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(draw_line_color), draw_line_width));
                            var graphic = new Graphic(geotry, symbol);
                            //点选
                            if (jsonData[0].select_type == 0) {
                                graphic = new Graphic(geotry, circleSymb);
                            }
                            var fitExtent = graphic.geometry.getExtent();

                            draw_layer.add(graphic);
                            draw_layer.redraw();
                            draw_layer.show();
                            map.setExtent(fitExtent.expand(1.5));
                        });
                        /*if(select_type_temp==0){//点选
                         var points = shape_points.split(",");
                         var circle = new Circle([parseFloat(points[0]), parseFloat(points[1])],{"radius": parseFloat(radius_temp),"radiusUnit": Units.KILOMETERS,"geodesic": false});
                         var graphic = new Graphic(circle, circleSymb);
                         draw_layer.add(graphic);
                         draw_layer.redraw();
                         map.centerAndZoom([parseFloat(points[0]), parseFloat(points[1])],9);
                         }else if(select_type_temp==1){//框选
                         var points = shape_points.split(",");
                         var polygon = new Polygon({"rings":[[[parseFloat(points[0]),parseFloat(points[1])],[parseFloat(points[0]),parseFloat(points[3])],[parseFloat(points[2]),parseFloat(points[3])],[parseFloat(points[2]),parseFloat(points[1])],
                         [parseFloat(points[0]),parseFloat(points[1])]]],"spatialReference":{"wkid":4326 }});
                         var symbol = new SimpleFillSymbol().setColor(new dojo.Color(draw_fill_color));
                         symbol.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(draw_line_color), draw_line_width));
                         var graphic = new Graphic(polygon,symbol);
                         var center_point = getGravityCenter(graphic.geometry,graphic.geometry.rings);
                         draw_layer.add(graphic);
                         map.centerAndZoom(center_point,9);
                         }else if(select_type_temp==2){
                         var points = shape_points.split(";");
                         var p_arr = new Array();
                         var p_arr_float = new Array();
                         for(var i = 0,l = points.length;i<l;i++){
                         var ps = points[i];
                         p_arr.push(ps.split(","));
                         }
                         for(var i =0,l = p_arr.length;i<l;i++){
                         var p_item = p_arr[i];
                         p_arr_float.push([parseFloat(p_item[0]),parseFloat(p_item[1])]);
                         }
                         p_arr_float.push(p_arr_float[0]);
                         var polygon = new Polygon({"rings":[p_arr_float],"spatialReference":{"wkid":4326 }});
                         var symbol = new SimpleFillSymbol().setColor(new dojo.Color(draw_fill_color));
                         symbol.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(draw_line_color), draw_line_width));
                         var graphic = new Graphic(polygon,symbol);
                         var center_point = getGravityCenter(graphic.geometry,graphic.geometry.rings);
                         draw_layer.add(graphic);
                         map.centerAndZoom(center_point,9);

                         }*/

                        /*yinming 2017年7月22日11:28:37 修改营销窗口end*/
                    }

                    function freshYXViewList(yx_id, yx_view_yx_search_add4) {
                        $("#yx_view_yx_list").empty();
                        $.post(url4Query, {
                            eaction: "yx_view_query_list",
                            yxid: yx_id,
                            standard_name: yx_view_yx_search_add4
                        }, function (data) {
                            data = $.parseJSON(data);
                            for (var i = 0, l = data.length; i < l; i++) {
                                var d = data[i];
                                var newRow = "";
                                if (d.SEGM_ID == 0)
                                    newRow += "<tr class=\"heji\"><td></td>" + "<td class=\"heji_text_center\">" + d.SEGM_NAME + "</td>" + "<td>" + d.ZHU_HU_COUNT + "</td>";
                                else
                                    newRow += "<tr><td>" + (i) + "</td>" + "<td>" + d.SEGM_NAME + "</td>" + "<td><a href=\"javascript:void(0);\" onclick=\"javascript:showBuildDetail('" + d.SEGM_ID + "','" + d.SEGM_NAME + "','all',1,this,'" + yx_id + "')\">" + d.ZHU_HU_COUNT + "</a></td>";

                                if (d.SEGM_ID == 0)
                                	newRow += "<td>--</td><td>--</td>";
                                else
                                	newRow += "<td>" + d.PORT_ALL + "</td><td>" + d.PORT_FREE + "</td>";

                                newRow += "<td>" + d.KD_COUNT + "</td><td>" + d.ITV_COUNT + "</td><td>" + d.GU_COUNT + "</td>";

                                if (d.YX_ALL == 0)
                                    newRow += "<td>" + d.YX_ALL + "</td>";
                                else
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:funshow1('" + yx_id + "','" + d.SEGM_ID + "')\">" + d.YX_ALL + "</a></td>";

                                newRow += "<td>" + d.YX_DONE + "</td><td>" + d.YX_UN + "</td><td>" + d.YX_LV + "%</td>";

                                $("#yx_view_yx_list").append(newRow);
                            }
                            $("#yx_view_yx_record_count").text(data.length - 1 < 0 ? '0' : data.length - 1);
                        });
                    }

                    /*yinming 2017年7月22日14:51:59 营销联动 end*/

                    $("#build_query").unbind();
                    $("#build_query").on('click', function () {
                        queryBuild('', 0)
                    })
                    //楼宇查询，已废弃
                    function queryBuild_nouse(latn_id) {
                        if (latn_id == '') {
                            latn_id = $("#b_city option:selected").val()
                        }
                        var region_id = $("#b_area option:selected").val()
                        var street_id = $("#b_street option:selected").val()
                        var build_list = $("#build_table");
                        build_list.html('')
                        var build_name = $("#b_build_name").val();

                        $.post(url4Query, {
                            eaction: 'build_list',
                            region_id: region_id,
                            build_name: build_name,
                            latn_id: latn_id == 947 ? 937 : latn_id,
                            street_id: street_id
                        }, function (data) {
                            var d = $.parseJSON(data)
                            $("#build_count").text(d.length);
                            var str = ''
                            $.each(d, function (i, obj) {
                                var name = obj.STAND_NAME
                                var x = name
                                var latn_name = obj.LATN_NAME
                                var latn_id = obj.LATN_ID
                                str += "<tr class=\"tr_default_background_color\" style='cursor:pointer;font-size:14px' onclick=\"standard_position_load('" + obj.SEGM_ID + "','" + latn_name + "','" + latn_id + "',this)\"><td style='width: 14%;text-align: center'>" + (i + 1) + "</td><td style='width: 80%;text-align: left' title=\"" + obj.STAND_NAME + "\">" + x + "</td></tr>"

                            })
                            var stan = 24
                            var len = $(parent.window).width()
                            if (len < 1900) {
                                stan = 12
                            }
                            if (d.length == 0) {
                                str += "<tr class=\"tr_default_background_color\"><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到楼宇信息</td></tr>"
                            } else if (d.length <= stan) {
                                for (var i = 0; i < stan - d.length; i++) {
                                    str += "<tr class=\"tr_default_background_color\"><td style='width: 18%;text-align: center'></td><td style='width: 60%;text-align:center'></td></tr>";
                                }
                            }
                            build_list.append(str)
                        })
                    }

                    //楼宇结束
                    var begin_scroll = "";
                    var seq_um = 0;

                    function buildListScroll(region_id, build_name, latn_id, substation, grid_id, page) {
                        var build_list = $("#build_table");
                        $.post(url4Query, {
                            eaction: "build_list",
                            "region_id": region_id,
                            build_name: build_name,
                            latn_id: latn_id,
                            "substation": substation,
                            "grid_id": grid_id,
                            "page": page
                        }, function (data) {
                            var d = $.parseJSON(data)

                            var str = ''
                            $.each(d, function (i, obj) {
                                var name = obj.RESFULLNAME
                                var x = name
                                var latn_name = obj.LATN_NAME
                                var latn_id = obj.LATN_ID
                                str += "<tr class=\"tr_default_background_color\" style='cursor:pointer;font-size:14px' onclick=\"standard_position_load('" + obj.RESID + "','" + latn_name + "','" + latn_id + "',this)\"><td style='width: 14%;text-align: center'>" + (++seq_um) + "</td><td style='width: 80%;text-align: left' title=\"" + obj.RESFULLNAME + "\">" + x + "</td></tr>"

                            })
                            var stan = 24
                            var len = $(parent.window).width()
                            if (len < 1900) {
                                stan = 12
                            }
                            if (d.length == 0) {
                                str += "<tr class=\"tr_default_background_color\"><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到楼宇信息</td></tr>"
                                return;
                            } else if (d.length <= stan) {
                                for (var i = 0; i < stan - d.length; i++) {
                                    str += "<tr class=\"tr_default_background_color\"><td style='width: 18%;text-align: center'></td><td style='width: 60%;text-align:center'></td></tr>";
                                }
                            }
                            build_list.append(str)
                        })
                    }

                    //楼宇查询 2017 09 18
                    function queryBuild(latn_id, page) {
                        seq_um = 0;
                        if (latn_id == '') {
                            latn_id = $("#b_city option:selected").val()
                        }
                        var region_id = $("#b_area option:selected").val()
                        var substation = $("#b_branch option:selected").val();
                        var grid_id = $("#b_grid option:selected").val();
                        var build_list = $("#build_table");
                        build_list.html('')
                        var build_name = $("#b_build_name").val();
                        build_list_page = 0;
                        buildListScroll(region_id, build_name, latn_id, substation, grid_id, page);
                        getBuildCount_buildList(region_id, build_name, latn_id, substation, grid_id);
                    }

                    function getBuildCount_buildList(region_id, build_name, latn_id, substation, grid_id) {
                        $.post(url4Query, {
                            eaction: "getBuildCount_buildList",
                            "region_id": region_id,
                            build_name: build_name,
                            latn_id: latn_id,
                            "substation": substation,
                            "grid_id": grid_id
                        }, function (data) {
                            data = $.parseJSON(data);
                            $("#build_count").text(data.COUNT);
                        });
                    }

                    //左侧楼宇滚动加载
                    var build_list_page = 0;
                    $(".te").unbind();
                    $(".te").scroll(function () {
                        var viewH = $(this).height();
                        var contentH = $(this).get(0).scrollHeight;
                        var scrollTop = $(this).scrollTop();
                        //alert(scrollTop / (contentH - viewH));

                        if (scrollTop / (contentH - viewH) >= 0.95) {
                            if (new Date().getTime() - begin_scroll > 500) {
                                var region_id = $("#b_area option:selected").val()
                                var build_name = $("#b_build_name").val();
                                var latn_id = $("#b_city option:selected").val();
                                var substation = $("#b_branch option:selected").val();
                                var grid_id = $("#b_grid option:selected").val();
                                var build_list = $("#build_table");
                                build_list_page++;
                                buildListScroll(region_id, build_name, latn_id, substation, grid_id, build_list_page);
                            }
                            begin_scroll = new Date().getTime();
                        }
                    });

                    function getYxVillageCount_YxVillageList(latn_id,bureau_no,union_org_code,grid_id,vn) {
                        $.post(url4Query, {
                            "eaction": "getYxVillageCount_YxVillageList",
                            "latn_id": latn_id,
                           	"bureau_no": bureau_no,
                            "union_org_code": union_org_code,
                            "grid_id": grid_id,
                            "village_name":vn
                        }, function (data) {
                            data = $.parseJSON(data);
                            $("#yx_villagecount1").text(data);
                        });
                    }
                    //左侧营销滚动加载
                    var yx_village_list_page = 0;
                    $(".tf_yx_v").unbind();
                    $(".tf_yx_v").scroll(function () {
                        var viewH = $(this).height();
                        var contentH = $(this).get(0).scrollHeight;
                        var scrollTop = $(this).scrollTop();
                        //alert(scrollTop / (contentH - viewH));

                        if (scrollTop / (contentH - viewH) >= 0.95) {
                            if (new Date().getTime() - begin_scroll > 500) {
                                var vn = $("#yx_v_village_name").val()
				                        var latn_id = $("#yx_v_city option:selected").val()
				                        var bureau_no = $("#yx_v_area option:selected").val()
				                        var union_org_code = $("#yx_v_branch option:selected").val()
				                        var grid_id = $("#yx_v_grid option:selected").val()
				                        var notUpload = 0
				                        yx_village_list_page++;
				                        //加载一页数据
				                        queryYX_villageListScroll(latn_id,bureau_no,union_org_code,grid_id,vn,yx_village_list_page);
                            }
                            begin_scroll = new Date().getTime();
                        }
                    });

                    $("#nav_range").unbind();
                    dojo.query("#nav_range").onclick(function (evt) {
                        $("#range_div").toggle();
                        if ($("#range_div").is(":visible"))
                            $("#draw_div").hide();
                    });
                    // //去掉默认的contextmenu事件，否则会和右键事件同时出现。
                    document.oncontextmenu = function (e) {
                        e.preventDefault();
                    };
                    document.onmousedown = function (e) {
                        e.stopPropagation();
                        if (e.button == 2) {//鼠标右键事件，右键菜单，右键清除 退出绘制，右键结果窗口
                            if ($("#clear_draw_menu").is(":hidden")) {
                                if (draw_layer.visible) {//如果可见，则可以清理
                                    $("#nav_marketing").removeClass("active");
                                    //map.setMapCursor("default");//绘制结束，还原鼠标
                                    $("#clear_draw_menu").show();
                                    if (draw_type == "village" && parent.villageObjectEdited.isOnMap == 1)//如果是小区绘制功能
                                        $("#delete_village").show();
                                    if (draw_finish)
                                        $("#pop_res_win_layer").show();
                                    $("#clear_draw_menu").css({left: e.x, top: e.y});
                                    $("#pop_res_win_layer").css({
                                        left: e.x,
                                        top: e.y + ($("#clear_draw_menu").height())
                                    });
                                    $("#delete_village").css({left: e.x, top: e.y + ($("#clear_draw_menu").height())});
                                }
                            }
                            else {
                                $("#clear_draw_menu").hide();
                                $("#pop_res_win_layer").hide();
                                $("#delete_village").hide();
                            }
                        }
                    }
                    $("#clear_draw_menu").unbind();
                    $("#clear_draw_menu").click(function (e) {
                        tuichu(e);
                    });
                    function resetVillageInputs() {
                        $("#village_name").val("");
                        $("#village_people_total").text("");
                        $("#village_in_sub").text("");
                        $("#village_in_grid").text("");
                        $("#village_creator").text("");
                        $("#village_builds_total").text("");
                        // $("#village_port_used_rate").text("");
                        // $("#village_port_total").text("");
                        // $("#village_used_num").text();
                        $("#village_in_sub_id").val("");
                        $("#village_in_grid_id").val("");

                        //$("input[name='h_is_cover']").eq(0).removeAttr("checked");
                        //$("input[name='h_is_cover']").eq(1).attr("checked","checked");

                        $("input[name='kd_user_count']").val("");
                        $("input[name='ds_user_count']").val("");
                        $("input[name='real_home_num']").val("");

                        $("input[name='h_user_count']").val("");
                        $("input[name='no_h_user_count']").val("");
                        $("input[name='yd_user_count']").val("");
                        $("input[name='people_num']").val("");

                        $("input[name='only_telecom_line']").eq(0).removeAttr("checked");
                        $("input[name='only_telecom_line']").eq(1).attr("checked", "checked");

                        //$("input[name='yd_h_is_cover']").eq(0).removeAttr("checked");
                        //$("input[name='yd_h_is_cover']").eq(1).attr("checked","checked");

                        //$("input[name='lt_h_is_cover']").eq(0).removeAttr("checked");
                        //$("input[name='lt_h_is_cover']").eq(1).attr("checked","checked");

                        //$("input[name='gd_h_is_cover']").eq(0).removeAttr("checked");
                        //$("input[name='gd_h_is_cover']").eq(1).attr("checked","checked");

                        $("input[name='ydkd_user_count']").val("");
                        $("input[name='ltkd_user_count']").val("");
                        $("input[name='gdkd_user_count']").val("");

                        $("input[name='ydyd_user_count']").val("");
                        $("input[name='ltyd_user_count']").val("");

                        $("input[name='ydds_user_count']").val("");
                        $("input[name='ltds_user_count']").val("");

                        $("#buildInvillage_res_list").empty();

                        $("#village_new_dx_only").val("");
                        $("#village_new_dxgw_cover").val("");
                        $("#village_new_ydgw_cover").val("");
                        $("#village_new_ltgw_cover").val("");
                        $("#village_new_gdgw_cover").val("");

                        $("input[name='village_new_ydyd_count']").val("");
                        $("input[name='village_new_ydkd_count']").val("");
                        $("input[name='village_new_ydds_count']").val("");

                        $("input[name='village_new_ltyd_count']").val("");
                        $("input[name='village_new_ltkd_count']").val("");
                        $("input[name='village_new_ltds_count']").val("");

                        $("input[name='village_new_gdkd_count']").val("");
                        $("input[name='village_new_gdds_count']").val("");
                    }

                    function resetYXInputs() {
                        $("#target_yx_new").text("");
                        $("#kdwx_yx_new").text("");
                        $("#ywcf_yx_new").text("");
                        $("#tcsd_yx_new").text("");
                        $("#ru_zhu_lv_yx_new").text("");
                        $("#build_count_yx_new").text("");
                        $("#zhu_hu_shu_yx_new").text("");
                        $("#real_zhu_hu_shu_new").text("");
                        //$("#port_used_rate_yx_new").text("");
                        //$("#port_count_yx_new").text("");
                        //$("#port_used_count_yx_new").text("");
                        $("#yd_user_count_yx_new").text("");
                        $("#yx_new_four_address_list").empty();
                    }

                    var village_saved_flag = false;
                    tuichu = function (e) {
                        parent.showMapPosition();
                        vboo = true;
                        subToGridFlag = true;

                        //小区新增或编辑功能后退出，且点了保存，重新加载新建或编辑的小区
                        if(buildInVillage_mode!="" && village_saved_flag){

                            var ids = Object.keys(buildInVillage);

                            var ids_str = "RESID in (";
                            for (var i = 0, l = ids.length; i < l; i++) {
                                var d = ids[i];

                                ids_str += "'" + d + "'";
                                if (i < l - 1)
                                    ids_str += ",";
                            }
                            ids_str += ")";

                            queryBuildFunc(village_id_selected, ids_str, village_updated_position);
                            village_position_layer.clear();
                            if(village_selected_gra_update!=undefined && village_selected_gra_update!="" && village_selected_gra_update!=null)
                            	village_layer.remove(village_gras_array[village_selected_gra_update.attributes.village_id]);
                            village_selected_gra_update = "";
                            village_id_selected = "";
                        }
                        //小区新建功能，没有点保存，清空选择的红点
                        if(buildInVillage_mode=="add" && !village_saved_flag){
                        		draw_layer_mark_build.clear();
                        }
                        //小区编辑功能，没有点保存
                        if(buildInVillage_mode=="update" && !village_saved_flag){
                        		draw_layer_mark_build.clear();
		                  			var ids = Object.keys(buildInVillageCopy);

		                        var ids_str = "RESID in (";
		                        for (var i = 0, l = ids.length; i < l; i++) {
		                            var d = ids[i];

		                            ids_str += "'" + d + "'";
		                            if (i < l - 1)
		                                ids_str += ",";
		                        }
		                        ids_str += ")";

		                        queryBuildFunc(village_id_selected, ids_str, village_updated_position);
		                        village_selected_gra_update = "";
		                        village_id_selected = "";
                        }
                        buildInVillage_mode = "";
                        village_saved_flag = false;

                        resetVillageInputs();
                        resetYXInputs();
                        try {
                            e.stopPropagation();
                            e.preventDefault();
                        } catch (e) {

                        }
                        killEventForBuildInVillage();
                        if (draw_layer.visible) {
                            $("#village_info_mini_win").hide();
                            $("#buildInVillage_review_win").hide();
                            $("#yingxiao_new_win").hide();
                            $("#shezhi_content").hide();
                            $("#marketing_div").hide();
                            $("#village_frame_div").hide();
                            $(".tools_content li").css("background-color", "transparent")
                            $("#nav_marketing").removeClass("active")
                            $("#village_draw_tool_div").hide();
                            dojo.disconnect(draw_layer_leida_click_handler);//停止雷达圈定功能
                            dojo.disconnect(draw_layer_leida_move_handler);//停止雷达圈定功能
                            dojo.disconnect(draw_layer_village_click_handler);//停止小区上图功能
                            dojo.disconnect(village_mouse_over_when_draw_handler);//停止小区上图功能
                            dojo.disconnect(village_mouse_over_when_draw_handler1);//停止小区上图功能
                            draw_layer.clear();
                            draw_layer.hide();
                            draw_layer.visible = false;
                            killEvent();
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

                            //绘制小区
                            //$("#village_in_grid_id").val(
                            //village_load($("#village_view_grid_id").val(),global_village_id);
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
                        $("#tools_scroll").show();
                    }
                    $("#pop_res_win_layer").unbind();
                    $("#pop_res_win_layer").click(function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                        $("#clear_draw_menu").hide();
                        $("#pop_res_win_layer").hide();
                        $("#delete_village").hide();
                        map.setMapCursor("default");
                        layer.open({
                            title: ['查询结果', 'line-height:30px;text-size:30px;height:30px;'],
                            type: 1,
                            shade: 0,
                            area: ['55%', '50%'],
//							skin: 'demo-class',
                            left: '45%',
                            content: $("#draw_result_container"),
                            cancel: function () {//右上角关闭回调
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
                    click_dele = function (id, name) {
                        $("#clear_draw_menu").hide();
                        $("#pop_res_win_layer").hide();
                        $("#delete_village").hide();
                        parent.villageObjectEdited.isOnMap = 0;
                        layer.confirm('确定移除小区【"' + name + '"】？', {
                            btn: ['确定', '取消'] //按钮
                        }, function () {
                            var eaction = "village_delete";
                            $.post(url4Query, {eaction: eaction, village_id: id}, function () {
                                layer.msg('已移除', {icon: 1});
                                parent.freshVillageDatagrid();

                                village_load("RES_ID = '" + parent.global_report_to_id + "' AND STATUS = 1");
                            });
                        }, function () {
                            draw_layer.clear();
                        });
                    };
                    parent.click_dele = click_dele;
                    var draw_type = "";
                    $("#nav_draw").unbind();
                    dojo.query("#nav_draw").onclick(function (evt) {
                        draw_type = "polygon";
                        $("#draw_div").toggle();
                        if ($("#draw_div").is(":visible"))
                            $("#range_div").hide();
                    });
                    $("#draw_range_start").unbind();
                    dojo.query("#draw_range_start").onclick(function (evt) {
                        var num = $("#draw_half").val();
                        $('.tools_content').find('li').css('backgroundColor', 'transparent')
                        $('#draw_range_start').css('backgroundColor', '#051961')
                        if (flag_set) {
                            $('#draw_set').css('backgroundColor', '#051961')
                        } else {
                            $('#draw_set').css('backgroundColor', 'transparent')
                        }
                        if (isNaN(num)) {
                            layer.msg("请输入数字，不填内容时默认0.1");
                            return;
                        }
                        if ($.trim(num) == "")
                            $$("#draw_half").val(100);
                        draw_type = "leida";
                        drawEnable(evt);

                    });
                    $("#draw_ellipse").unbind();
                    dojo.query("#draw_ellipse").onclick(function (evt) {
                        //drawEnable(evt, "circle");
                        draw_type = "ellipse";
                        drawEnable(evt);
                    });
                    $("#draw_circle").unbind();
                    dojo.query("#draw_circle").onclick(function (evt) {
                        //drawEnable(evt, "circle");
                        draw_type = "circle";
                        drawEnable(evt);
                    });
                    $("#draw_rectangle").unbind();
                    dojo.query("#draw_rectangle").onclick(function (evt) {
                        //drawEnable(evt, "circle");
                        $('.tools_content').find('li').css('backgroundColor', 'transparent')
                        $('#draw_rectangle').css('backgroundColor', '#051961')
                        if (flag_set) {
                            $('#draw_set').css('backgroundColor', '#051961')
                        } else {
                            $('#draw_set').css('backgroundColor', 'transparent')
                        }
                        draw_type = "rectangle";
                        drawEnable(evt);
                    });
                    $("#draw_polygon").unbind();
                    dojo.query("#draw_polygon").onclick(function (evt) {
                        //drawEnable(evt, "circle");
                        $('.tools_content').find('li').css('backgroundColor', 'transparent')
                        $('#draw_polygon').css('backgroundColor', '#051961')
                        if (flag_set) {
                            $('#draw_set').css('backgroundColor', '#051961')
                        } else {
                            $('#draw_set').css('backgroundColor', 'transparent')
                        }
                        draw_type = "polygon";
                        drawEnable(evt);
                    });

                    //框选楼宇添加到小区的工具栏，按钮事件绑定
                    $("#draw_point_tool_village").unbind();
                    dojo.query("#draw_point_tool_village").onclick(function (evt) {//楼宇点选的功能，由于画点可能因为鼠标点的位置不准，画偏，不能完全覆盖所点的楼宇。所以采用查询方式实现“点选”功能
                        //buildInVillage_mode = "add";
                        $("#buildInVillage_review_win").hide();
                        $("#village_frame_div > .tools_content").children("li").css("backgroundColor", "transparent");
                        $('#draw_point_tool_village').css('backgroundColor', '#051961');
                        toolbar.deactivate();//禁止绘图功能
                        map.setMapCursor("crosshair");
                        draw_type = "point_village";
                        killEvent();
                        killEventForBuildInVillage();
                        reboundForBuildInVillage();
                        if (standard_layer_click_for_buildInVillage_handler != "")
                            dojo.disconnect(standard_layer_click_for_buildInVillage_handler);
                        standard_layer_click_for_buildInVillage_handler = dojo.connect(standard_layer, "onClick", function (evt) {
                            addBuildToVillagePoint(evt);
                        });
                        if (draw_layer_mark_build_click_handler != "")
                            dojo.disconnect(draw_layer_mark_build_click_handler);
                        draw_layer_mark_build_click_handler = dojo.connect(draw_layer_mark_build, "onClick", function (evt) {
                            addBuildToVillagePoint(evt);
                        });
                    });
                    $("#draw_rectangle_tool_village").unbind();
                    dojo.query("#draw_rectangle_tool_village").onclick(function (evt) {
                    		$("#buildInVillage_review_win").hide();
                        $("#village_frame_div > .tools_content").children("li").css("backgroundColor", "transparent");
                        $('#draw_rectangle_tool_village').css('backgroundColor', '#051961');
                        draw_type = "rectangle_village";
                        if (standard_layer_click_for_buildInVillage_handler != "")
                            dojo.disconnect(standard_layer_click_for_buildInVillage_handler);
                        if (standard_layer_click_handler != "")
                            dojo.disconnect(standard_layer_click_handler);
                        if (draw_layer_mark_build_click_handler != "")
                            dojo.disconnect(draw_layer_mark_build_click_handler);
                        if (drawed_layer_mark_build_click_handler != "")
                            dojo.disconnect(drawed_layer_mark_build_click_handler);
                        drawEnable(evt);
                    });
                    $("#draw_polygon_tool_village").unbind();
                    dojo.query("#draw_polygon_tool_village").onclick(function (evt) {
                    		$("#buildInVillage_review_win").hide();
                        $("#village_frame_div > .tools_content").children("li").css("backgroundColor", "transparent");
                        $('#draw_polygon_tool_village').css('backgroundColor', '#051961');
                        draw_type = "polygon_village";
                        if (standard_layer_click_for_buildInVillage_handler != "")
                            dojo.disconnect(standard_layer_click_for_buildInVillage_handler);
                        if (standard_layer_click_handler != "")
                            dojo.disconnect(standard_layer_click_handler);
                        if (draw_layer_mark_build_click_handler != "")
                            dojo.disconnect(draw_layer_mark_build_click_handler);
                        if (drawed_layer_mark_build_click_handler != "")
                            dojo.disconnect(drawed_layer_mark_build_click_handler);
                        drawEnable(evt);
                    });
                    $("#draw_draggable_tool_village").unbind();
                    dojo.query("#draw_draggable_tool_village").onclick(function (evt) {
                    		$("#buildInVillage_review_win").hide();
                        toolbar.deactivate();
                        map.setMapCursor("move");
                        $("#village_frame_div > .tools_content").children("li").css("backgroundColor", "transparent");
                        $('#draw_draggable_tool_village').css('backgroundColor', '#051961');
                    });

                    removeItemFromBuildInVillage = function (element, build_id) {
                        layer.confirm('您确定移除该条记录？', {
                                    btn: ['确定', '取消'] //按钮
                                }, function (index) {
                                    $(element).parent("td").parent("tr").remove();
                                    delete buildInVillage[build_id];
                                    delete buildInVillage_short[build_id];
                                    draw_layer_mark_build.remove(draw_graphics_array_for_buildInVillage[build_id]);
                                    freshBuildInVillageWin(build_id);

                                    if (draw_build_result_array_for_buildVillage[build_id])//这里只能处理，在撤销数组中，是点选操作的楼宇记录
                                        delete draw_build_result_array_for_buildVillage[build_id];
                                    layer.close(index);
                                }, function (index) {
                                    layer.close(index);
                                }
                        );
                        /*$(element).parent("td").prev("td").css({"text-decoration":"line-through"});
                         draw_layer_mark_build.remove(draw_graphics_array_for_buildInVillage[build_id]);
                         $(element).hide();
                         $(element).next().show();*/
                    }
                    function freshBuildInVillageWin(build_id) {
                        var should_removed_item = buildRes[build_id];
                        village_new_total_nums["YD_COUNT"] = village_new_total_nums["YD_COUNT"] - should_removed_item["YD_COUNT"];
                        village_new_total_nums["KD_COUNT"] = village_new_total_nums["KD_COUNT"] - should_removed_item["KD_COUNT"];
                        village_new_total_nums["ITV_COUNT"] = village_new_total_nums["ITV_COUNT"] - should_removed_item["ITV_COUNT"];
                        village_new_total_nums["GU_COUNT"] = village_new_total_nums["GU_COUNT"] - should_removed_item["GU_COUNT"];
                        village_new_total_nums["YX_UN"] = village_new_total_nums["YX_UN"] - should_removed_item["YX_UN"];
                        village_new_total_nums["ZHU_HU_COUNT"] = village_new_total_nums["ZHU_HU_COUNT"] - should_removed_item["ZHU_HU_COUNT"];
                        //village_new_total_nums["RES_ID_COUNT"] = village_new_total_nums["RES_ID_COUNT"] - should_removed_item["RES_ID_COUNT"];
                        //village_new_total_nums["SY_RES_COUNT"] = village_new_total_nums["SY_RES_COUNT"] - should_removed_item["SY_RES_COUNT"];
                        village_new_total_nums["village_builds_total"] = village_new_total_nums["village_builds_total"] - 1;

                        $("#village_new_yd_sum").text(village_new_total_nums.YD_COUNT);
                        $("#village_new_kd_sum").text(village_new_total_nums.KD_COUNT);
                        $("#village_new_ds_sum").text(village_new_total_nums.ITV_COUNT);
                        $("#village_people_total").text(village_new_total_nums.ZHU_HU_COUNT);
                        //$("#village_port_total").text(village_new_total_nums.RES_ID_COUNT);
                        //$("#village_port_free").text(village_new_total_nums.SY_RES_COUNT);
                        //$("#village_used_num").text(village_new_total_nums.RES_ID_COUNT - village_new_total_nums.SY_RES_COUNT);
                        $("#village_builds_total").text(village_new_total_nums["village_builds_total"]);

                        /* if (village_new_total_nums.RES_ID_COUNT == 0)
                            $("#village_port_used_rate").text("--");
                        else
                            $("#village_port_used_rate").text(((village_new_total_nums.RES_ID_COUNT - village_new_total_nums.SY_RES_COUNT) / village_new_total_nums.RES_ID_COUNT * 100).toFixed(1) + "%"); */

                        delete buildRes[build_id];
                        if (village_new_total_nums["village_builds_total"] == 0)
                            $("#saveBuildInVillageBtn").hide();
                        else
                            $("#saveBuildInVillageBtn").show();

                        var item_str = "<tr><td></td><td>合计</td>" +
                                "<td>" + village_new_total_nums.ZHU_HU_COUNT + "</td>" +
                                "<td>--</td>" +
                                "<td>--</td>" +
                                "<td>" + village_new_total_nums.KD_COUNT + "</td>" +
                                "<td>" + village_new_total_nums.ITV_COUNT + "</td>" +
                                "<td>" + village_new_total_nums.GU_COUNT + "</td>" +
                                "<td>" + (village_new_total_nums.YX_UN == null ? '--' : village_new_total_nums.YX_UN) + "</td>";
                        item_str += "<td></td></tr>";

                        //更新合计行
                        $("#buildInvillage_res_list").find("tr:eq(0)").remove();
                        $("#buildInvillage_res_list").prepend(item_str);

                        var order_ele = $("#buildInvillage_res_list").find(".order");

                        for (var i = 0, l = order_ele.length; i < l; i++) {
                            var ele = order_ele[i];
                            $(ele).html(i + 1);
                        }


                    }

                    var buildRes = "";
                    var village_new_total_nums = "";
                    var village_new_items = "";
                    $("#draw_polygon_village_review").unbind();
                    dojo.query("#draw_polygon_village_review").onclick(function (evt) {
                        $("#saveBuildInVillageBtn").show();
                        $("#saveBuildInVillageBtn").removeAttr("disabled");  //tangjie 2017/9/20 小区信息保存按钮防止重复点击
                        var ids = Object.keys(buildInVillage);
                        if (ids == null || ids == undefined || ids.length == 0) {
                            layer.msg("还未选择任何楼宇");
                        } else {
                            var ext = graphicsUtils.graphicsExtent(draw_layer_mark_build.graphics);
                            var center = ext.getCenter();
                            $("#village_new_center").val(center.x + "," + center.y);

                            buildRes = new Array();

                            var substation = $("#v_branch option:selected").val();
                            var sub_name = $("#v_branch option:selected").text();
                            var station_id = $("#v_grid option:selected").attr("value1");
                            var grid_name = $("#v_grid option:selected").text();

                            $("#buildInVillage_review_win").children(".target_a").find("span").eq(0).click();
                            $("#buildInVillage_review_win").show();

                            $("#village_in_city").text(city_name);

                            $("#village_in_sub_id").val(substation);
                            $("#village_in_sub").html(sub_name);
                            $("#village_in_grid_id").val(station_id);
                            //20180115小区信息中添加grid_id
                            $("#village_in_grid_id_short").val($("#v_grid option:selected").val());
                            $("#village_in_grid").html(grid_name=="全部"?'':grid_name);

                            $("#village_creator").html('${sessionScope.UserInfo.USER_NAME}');
                            $("#village_builds_total").html(ids.length);

                            $("#buildInvillage_res_list").empty();

                            var res_id_str = "";
                            for (var i = 0, l = ids.length; i < l; i++) {
                                res_id_str += "'" + ids[i] + "',";
                            }
                            res_id_str = res_id_str.substr(0, res_id_str.length - 1);

                            $.post(url4Query, {
                                eaction: 'build_wines_selected_build',
                                segm_ids: res_id_str
                            }, function (data) {
                                data = $.parseJSON(data);
                                for (var i = 0, l = data.length; i < l; i++) {
                                    var d = data[i];
                                    var item_str = "<tr>";

                                    if (d.SEGM_ID == 0) {
                                        village_new_total_nums = d;
                                        village_new_total_nums["village_builds_total"] = data.length - 1;
                                        item_str += "<td></td>";
                                        //village_port_total = d.RES_ID_COUNT;
                                        //village_port_unused_num = d.SY_RES_COUNT;
                                        $("#village_new_yd_sum").text(d.YD_COUNT);
                                        $("#village_new_kd_sum").text(d.KD_COUNT);
                                        $("#village_new_ds_sum").text(d.ITV_COUNT);

                                        $("#village_new_dxyd_count").text(village_new_total_nums.YD_COUNT);
                                        $("#village_new_dxkd_count").text(village_new_total_nums.KD_COUNT);
                                        $("#village_new_dxds_count").text(village_new_total_nums.ITV_COUNT);

                                        /* $("#village_people_total").text(d.ZHU_HU_COUNT);
                                        $("#village_port_total").text(d.RES_ID_COUNT);
                                        $("#village_port_free").text(d.SY_RES_COUNT);
                                        $("#village_used_num").html(village_port_total - village_port_unused_num);
                                        var total_port_used_rate = ((village_port_total - village_port_unused_num) / village_port_total * 100).toFixed(2);
                                        if (isNaN(total_port_used_rate))
                                            total_port_used_rate = 0;

                                        if (d.RES_ID_COUNT == 0)
                                            $("#village_port_used_rate").text("--");
                                        else
                                            $("#village_port_used_rate").text(((d.RES_ID_COUNT - d.SY_RES_COUNT) / d.RES_ID_COUNT * 100).toFixed(1) + "%"); */
                                    } else
                                        item_str += "<td class=\"order\" >" + i + "</td>";

                                    buildRes[d.SEGM_ID] = d;

                                    /*var port_used_rate = ((parseInt(d.RES_ID_COUNT) - parseInt(d.SY_RES_COUNT)) / parseInt(d.RES_ID_COUNT) * 100).toFixed(2);
                                    if (isNaN(port_used_rate))
                                        port_used_rate = 0;
                                    if (d.RES_ID_COUNT == 0)
                                        port_used_rate = 0; */

                                    var b_name = buildInVillage[d.SEGM_ID];
                                    if (b_name == undefined)
                                        b_name = "合计";
                                    item_str += "<td>" + b_name + "</td>" +
                                    "<td>" + d.ZHU_HU_COUNT + "</td>";
                                    if(i==0)
                                    	item_str += "<td>--</td><td>--</td>";
                                    else
                                    	item_str += "<td>" + d.RES_ID_COUNT + "</td>" +
                                    							"<td>" + d.SY_RES_COUNT +"</td>";

                                    item_str += "<td>" + d.KD_COUNT + "</td>" +
                                    "<td>" + d.ITV_COUNT + "</td>" +
                                    "<td>" + d.GU_COUNT + "</td>" +
                                    "<td>" + (d.YX_UN == null ? '--' : d.YX_UN) + "</td>";
                                    if (buildInVillage[d.SEGM_ID] == undefined)
                                        item_str += "<td>";
                                    else
                                        item_str += "<td>" + "<a href=\"javascript:void(0);\" onclick=\"javascript:removeItemFromBuildInVillage(this,'" + d.SEGM_ID + "')\"></a>";

                                    item_str += "</td></tr>";

                                    $("#buildInvillage_res_list").append(item_str);
                                }
                                if (data.length - 1 < ids.length) {//表里的楼宇数据比圈定的楼宇数少，需要把没有在表里的楼宇也展现出来
                                    var bivCopy = new Array();
                                    for (var i = 0, l = ids.length; i < l; i++) {
                                        bivCopy[ids[i]] = buildInVillage[ids[i]];
                                    }

                                    for (var j = 0, k = data.length; j < k; j++) {
                                        delete bivCopy[data[j].SEGM_ID];
                                    }
                                    var keys = Object.keys(bivCopy);
                                    for (var i = 0, l = keys.length; i < l; i++) {
                                        var item_str = "<tr><td class=\"order\">" + (data.length + (i + 1)) + "</td>";

                                        item_str += "<td>" + bivCopy[keys[i]] + "</td>" +
                                        "<td>--</td>" +
                                        "<td>--</td>" +
                                        "<td>--</td>" +
                                        "<td>--</td>" +
                                        "<td>" + "<a href=\"javascript:void(0);\" onclick=\"javascript:removeItemFromBuildInVillage(this,'" + d.SEGM_ID + "')\"></a>";
                                        item_str += "</td></tr>";

                                        $("#buildInvillage_res_list").append(item_str);
                                    }
                                }

                            });

                        }
                    });
                    $("#draw_freehand_polygon").unbind();
                    dojo.query("#draw_freehand_polygon").onclick(function (evt) {
                        //drawEnable(evt, "circle");
                        draw_type = "freehand_polygon";
                        drawEnable(evt);
                    });

                    saveBuildInVillage = function (event) {
                        if (!buildInVillage instanceof Array) {
                            layer.msg("还未选择任何楼宇");
                            return;
                        }
                        var ids = Object.keys(buildInVillage);
                        if (ids.length == 0) {
                            layer.msg("还未选择任何楼宇");
                            return;
                        }
                        if(ids.length > 1000){
                        		layer.msg("所选楼宇数量请不要超过1000个");
                            return;
                        }
                        var v_name = $.trim($("#village_name").val());
                        if (v_name == "") {
                            layer.msg("请输入小区名称，50字内");
                            return;
                        }
                        if ((v_name + "").length > 50) {
                            layer.msg("小区名称已超过50个字，请重新输入！");
                            return;
                        }

                        $("#saveBuildInVillageBtn").attr("disabled", true); //tangjie 2017/9/20 小区信息保存按钮防止重复点击

                        /*var substation = $("#village_in_sub_id").val();
                        var station_id = $("#village_in_grid_id").val();
                        var grid_id_short = $("#village_in_grid_id_short").val();
                        var sub_name = $("#village_in_sub").text();
                        var grid_name = $("#village_in_grid").text();*/
                        var ids_str = ids.join(",");
                        var ids_str_for_update = "";
                        var name_str = "";
                        var short_name_str = "";
                        for (var i = 0, l = ids.length; i < l; i++) {
                            var id = ids[i];
                            var full_name = buildInVillage[id];
                            var short_name = buildInVillage_short[id];
                            name_str += (full_name + ",");
                            short_name_str += (short_name + ",");
                            ids_str_for_update += "'" + id + "'" + ",";
                        }
                        name_str = name_str.substr(0, name_str.length - 1);
                        short_name_str = short_name_str.substr(0, short_name_str.length - 1);
                        ids_str_for_update = ids_str_for_update.substr(0, ids_str_for_update.length - 1);

                        var village_create_time= $("#village_create_time").text();    //创建时间
                        var village_scale =$('#village_scale option:selected') .val();   //小区规模
                        //小区入住率
                       var xqrzl=$("#xqrzl").val();
                        //小区消费能力
                       var village_expense_ability =$('#village_expense_ability option:selected') .val();
                        //小区属性
                       var village_property =$('#village_property option:selected') .val();
                       var  is_none=$("#none_jx").is(":checked");
                       var  is_dx=$("#dx_jx").is(":checked");
                       var  is_yd=$("#yd_jx").is(":checked");
                       var  is_lt=$("#lt_jx").is(":checked");
                       var  is_gd=$("#gd_jx").is(":checked");
                       var  is_qt=$("#qt_jx").is(":checked");


	                     var OTHER=0;
	                     var CM_OPTICAL_FIBER=0;
	                     var WIDEBAND_IN=0;
	                     var CU_OPTICAL_FIBER=0;
	                     var SARFT_OPTICAL_FIBER=0;

	                     if(is_qt){
	                         OTHER=1;
	                     }
	                     if(is_yd){
	                         CM_OPTICAL_FIBER=1;
	                     }
	                     if(is_dx){
	                         WIDEBAND_IN=1;
	                     }
	                     if(is_lt){
	                        CU_OPTICAL_FIBER=1;
	                     }
	                     if(is_gd){
	                         SARFT_OPTICAL_FIBER=1;
	                     }
                        //第二个标签页的值
                        var h_is_cover = $("input[name='h_is_cover']:checked").val();
                        var real_home_num = $("input[name='real_home_num']").val();
                        var people_num = $("input[name='people_num']").val();

                        var only_telecom_line = $("input[name='only_telecom_line']:checked").val();


                        var ydyd_user_count = $("input[name='village_new_ydyd_count']").val();
                        var ydkd_user_count = $("input[name='village_new_ydkd_count']").val();
                        var ydds_user_count = $("input[name='village_new_ydds_count']").val();

                        var ltyd_user_count = $("input[name='village_new_ltyd_count']").val();
                        var ltkd_user_count = $("input[name='village_new_ltkd_count']").val();
                        var ltds_user_count = $("input[name='village_new_ltds_count']").val();

                        var gdkd_user_count = $("input[name='village_new_gdkd_count']").val();
                        var gdds_user_count = $("input[name='village_new_gdds_count']").val();

                        var village_new_dx_only = $("#village_new_dx_only").val();
                        var village_new_dxgw_cover = $("#village_new_dxgw_cover").val();
                        var village_new_ydgw_cover = $("#village_new_ydgw_cover").val();
                        var village_new_ltgw_cover = $("#village_new_ltgw_cover").val();
                        var village_new_gdgw_cover = $("#village_new_gdgw_cover").val();


                        //第一个标签页的值
                        var village_new_yd_sum = $("#village_new_yd_sum").text();
                        var village_new_kd_sum = $("#village_new_kd_sum").text();
                        var village_new_ds_sum = $("#village_new_ds_sum").text();
                        var village_people_total = $("#village_people_total").text();
                        var village_builds_total = $("#village_builds_total").text();
                        var village_port_total = $("#village_port_total").text();
                        var village_port_free = $("#village_port_free").text();

                        var village_new_center = $("#village_new_center").val();

                        //先验证选择的楼宇在之前是否被选用过了，如果有，则不能继续流程。没有被用过才算合法。
                        //验证楼宇合法性
                        if (buildInVillage_mode == "add")
                            global_village_id = "";

                        var index = layer.load(1, {
										        shade: [0.1,'#fff'] //0.1透明度的白色背景
										    });
                        $.post(url4Query,{
                        	"eaction":"validBuildUsedForSchoolOrEnterprise",
                        	"build_ids": ids_str_for_update,
                          "village_id": global_village_id
                        	},function(data){
                        	data = $.parseJSON(data);
                        	if(data>0){
                        		layer.msg("您选择的一部分楼宇已被其他校园或商客占用，请刷新页面",{time:6000});
                        		return;
                        	}else{
                        		try {
	                            if (buildInVillage_mode == "add") {
		                            	var url_str = url4Query;
		                            	var eaction_str = "saveBuildInVillage";
		                            	if(nav_type_index!="village"){
		                            			url_str = url4Query_enterprise;
		                            			eaction_str = 'saveBuildInSchoolOrEnterprise';
		                            	}
	                                $.post(url_str, {
	                                    'eaction': eaction_str,

	                                    'business_name': v_name,

	                                    'latn_id': city_id,
	                                    'latn_name': city_name,

	                                    'ct_business': WIDEBAND_IN,
	                                    'cm_business': CM_OPTICAL_FIBER,
	                                    'cu_business': CU_OPTICAL_FIBER,
	                                    'sarft_business': SARFT_OPTICAL_FIBER,
	                                    'other_business': OTHER,

	                                    'business_attr1':$("#village_scale option:selected").val(),

	                                    'position': village_new_center,

	                                    'ids': ids_str,
	                                    'name_str': name_str,
	                                    'short_name_str': short_name_str

	                                }, function (data) {
	                                		layer.close(index);
	                                    layer.msg("保存成功");
	                                    data = $.parseJSON(data);
	                                    $("#buildInVillage_review_win").hide();
	                                    village_id_selected = data.VAL;
	                                    village_saved_flag = true;
	                                    ids_str_array[village_id_selected + "_"] = "RESID in (" + ids_str_for_update + ")";
	                                    tuichu(event);
	                                });
	                            }
	                            else if (buildInVillage_mode == "update") {
	                            		var url_str = url4Query;
		                            	var eaction_str = "updateBuildInVillage";
		                            	if(nav_type_index!="village"){
		                            			url_str = url4Query_enterprise;
		                            			eaction_str = 'updateBuildInSchoolOrEnterprise';
		                            	}
	                                $.post(url_str, {
	                                    eaction: eaction_str,
	                                    'business_id': global_village_id,
	                                    'business_name': v_name,

	                                    'ct_business': WIDEBAND_IN,
	                                    'cm_business': CM_OPTICAL_FIBER,
	                                    'cu_business': CU_OPTICAL_FIBER,
	                                    'sarft_business': SARFT_OPTICAL_FIBER,
	                                    'other_business': OTHER,

	                                    'business_attr1':$("#village_scale option:selected").val(),

	                                    'position': village_new_center,

	                                    'ids': ids_str,
	                                    'name_str': name_str,
	                                    'short_name_str': short_name_str
	                                }, function (data) {
	                                		layer.close(index);
	                                    layer.msg("保存成功");
	                                    $("#buildInVillage_review_win").hide();
	                                    village_saved_flag = true;
	                                    ids_str_array[global_village_id + "_"] = "RESID in (" + ids_str_for_update + ")";
	                                    tuichu(event);
	                                });
	                            }
		                        } catch (e) {
		                            layer.msg("保存失败");
		                            village_saved_flag = false;
		                        }
                        	}
                        });

                    }


                    cancleBuildInVillage = function () {
                        $("#buildInVillage_review_win").hide();
                    }

                    var buildInVillage_mode = "";
                    //$("#editBuildInVillage_btn").unbind();

                    var build_num_for_village_edit = 0;
                    editBuildInVillage = function () {
                        vboo = false;
                        buildInVillage_mode = "update";
                        $("#saveBuildInVillageBtn").removeAttr("disabled");

                        draw_build_result_array_for_buildVillage = new Array();

                        draw_layer_mark_build.show();
                        draw_layer_mark_build.visible = true;
                        //draw_layer_mark_build.clear();

                        //隐藏无关的按钮
                        if ($("#nav_fanhui_sub").is(':visible')) {
                            $("#nav_fanhui_sub").hide();//隐藏返回按钮
                            back_btn_hided = "#nav_fanhui_sub";
                        } else if ($("#nav_fanhui_qx").is(':visible')) {
                            $("#nav_fanhui_qx").hide();//隐藏返回按钮
                            back_btn_hided = "#nav_fanhui_qx";
                        } else if ($("#nav_fanhui").is(':visible')) {
                            $("#nav_fanhui").hide();//隐藏返回按钮
                            back_btn_hided = "#nav_fanhui";
                        } else if ($("#nav_fanhui_city").is(':visible')) {
                            $("#nav_fanhui_city").hide();//隐藏返回按钮
                            back_btn_hided = "#nav_fanhui_city";
                        }
                        $('#yingxiao_info_win_new').hide();
                        $(".tools_n").hide();//隐藏左侧工具条
                        parent.hideMapPosition();//隐藏地图右上方返回路径条
                        //先放大到楼宇级别，9级，只在框选功能中有效
                        //var zoom = map.getZoom();
                        //if(zoom<9 && draw_type != "village"){
                        /*if(navigator.geolocation){
                         navigator.geolocation.getCurrentPosition(showLocation,errorHandler);
                         }else{
                         console.log("该浏览器不支持geolocation");
                         }*/
                        //    var point = map.center;
                        //    map.centerAndZoom(point,9);
                        //}
                        //map.setMapCursor("crosshair");
                        map.infoWindow.hide();
                        draw_layer.clear();
                        killEvent();
                        if (draw_layer_leida_click_handler != "")
                            dojo.disconnect(draw_layer_leida_click_handler);
                        resetNavMenu();
                        draw_layer.show();
                        $("#village_frame_div").show();

                        $("#buildInVillage_review_win").children(".target_a").find("span").eq(0).click();
                        $("#buildInVillage_review_win").show();
                        $("#buildInvillage_res_list").empty();
                        var v_id = global_village_id;
                        village_id_selected = v_id;
                        //小区编辑
                        var url_str = url4Query;
                        var eaction_str = "getVillageInfo";
                        if(nav_type_index!="village"){
                        	url_str = url4Query_enterprise;
                        	eaction_str = "getBuildInSchoolOrEnterprise";
                        }
                        $.post(url_str, {eaction: eaction_str, village_id: v_id}, function (data) {
                            data = $.parseJSON(data);
                            if (data == null) {
                                layer.msg("该小区下没有楼宇信息");
                                return;
                            }

                            build_num_for_village_edit = data.length;
                            buildRes = new Array();

                            var build_id_used = new Array();

                            var ids_str = "RESID IN (";

                            if(nav_type_index=="village"){
                            	for (var i = 0, l = data.length; i < l; i++) {
	                                var d = data[i];
	                                if (i == 0) {
	                                    $("#village_name").val(d.VILLAGE_NAME);
	                                    $("#village_in_sub_id").val(d.BRANCH_NO);
	                                    $("#village_in_sub").text(d.BRANCH_NAME);
	                                    $("#village_in_grid_id").val(d.GRID_ID);
	                                    $("#village_in_grid").text(d.GRID_NAME);
	                                    $("#village_creator").text('${sessionScope.UserInfo.USER_NAME}');//d.CREATER

	                                    $("input[name='village_new_ydyd_count']").val(d.CMCC_NUM);
	                                    $("input[name='village_new_ydkd_count']").val(d.CM_WIDEBAND_NUM);
	                                    $("input[name='village_new_ydds_count']").val(d.CMCC_TV_USER_NUM);

	                                    $("input[name='village_new_ltyd_count']").val(d.CUCC_NUM);
	                                    $("input[name='village_new_ltkd_count']").val(d.CU_WIDEBAND_NUM);
	                                    $("input[name='village_new_ltds_count']").val(d.CUCC_TV_NUM);

	                                    $("input[name='village_new_gdkd_count']").val(d.SARFT_WIDEBAND_NUM);
	                                    $("input[name='village_new_gdds_count']").val(d.SARFT_TV_NUM);


	                                    $("input[name='people_num']").val(d.PEOPLE_NUM);
	                                    $("input[name='real_home_num']").val(d.REAL_HOME_NUM);


	                                    $("#village_new_dx_only").val(d.IS_SOLE == null ? "0" : d.IS_SOLE);
	                                    $("#village_new_dxgw_cover").val(d.WIDEBAND_IN == null ? "0" : d.WIDEBAND_IN);//小区编辑2017-9-21
	                                    $("#village_new_ydgw_cover").val(d.CM_OPTICAL_FIBER == null ? "0" : d.CM_OPTICAL_FIBER);
	                                    $("#village_new_ltgw_cover").val(d.CU_OPTICAL_FIBER == null ? "0" : d.CU_OPTICAL_FIBER);
	                                    $("#village_new_gdgw_cover").val(d.SARFT_OPTICAL_FIBER == null ? "0" : d.SARFT_OPTICAL_FIBER);
	                                }

	                                ids_str += ("'" + d.SEGM_ID + "',");
	                                build_id_used.push(d.SEGM_ID);
	                            }
                            }else{
                            	for (var i = 0, l = data.length; i < l; i++) {
                            		var d = data[i];
                            		if(i==0){
                            			$("#village_name").val(d.BUSINESS_NAME);
                            			ids_str += ("'" + d.SEGM_ID + "',");
	                                build_id_used.push(d.SEGM_ID);
                            		}
                            	}
                            }

                            ids_str = ids_str.substr(0, ids_str.length - 1);
                            ids_str += ")";

                            if(nav_type_index=="village"){
                            	$.post(url4Query, {eaction: "build_wines", village_id: v_id}, function (data1) {
	                                data1 = $.parseJSON(data1);
	                                for (var i = 0, l = data1.length; i < l; i++) {
	                                    var d = data1[i];
	                                    var item_str = "";
	                                    if (d.SEGM_ID == 0) {
	                                        village_new_total_nums = d;
	                                        item_str = "<tr><td></td>";
	                                    }
	                                    else
	                                        item_str = "<tr><td class=\"order\">" + (i) + "</td>";

	                                    buildRes[d.SEGM_ID] = d;
	                                    var zhu_hu_count = d.ZHU_HU_COUNT;
	                                    if (zhu_hu_count == null)
	                                        zhu_hu_count = '--';

	                                    //if(zhu_hu_count!="--")
	                                    //	village_people_total += parseInt(zhu_hu_count);

	                                    var res_id_count = d.RES_ID_COUNT;
	                                    if (res_id_count == null)
	                                        res_id_count = '--';

	                                    //if(res_id_count!="--")
	                                    //	village_port_total += parseInt(res_id_count);

	                                    var sy_res_count = d.SY_RES_COUNT;
	                                    if (sy_res_count == null)
	                                        sy_res_count = '--';

	                                    //if(sy_res_count!="--")
	                                    //	village_port_unused_num += parseInt(sy_res_count);

	                                    var port_used_rate = 0;
	                                    if (res_id_count == 0)
	                                        port_used_rate = "--";

	                                    if (res_id_count != "--" && sy_res_count != "--" && res_id_count != 0)
	                                        port_used_rate = ((res_id_count - sy_res_count) / res_id_count * 100).toFixed(2) + "%";
	                                    else
	                                        port_used_rate = "--";

	                                    var used_port = 0;
	                                    if (isNaN(res_id_count) || isNaN(sy_res_count)) {
	                                        used_port = "--";
	                                    } else {
	                                        used_port = res_id_count - sy_res_count;
	                                    }

	                                    item_str += "<td>" + d.STAND_NAME + "</td>" +
	                                    "<td>" + zhu_hu_count + "</td>";

	                                    if(i==0){
	                                    	item_str += "<td>--</td><td>--</td>";
	                                    }else{
	                                    	item_str += "<td>" + res_id_count + "</td>" +
	                                    		"<td>" + sy_res_count + "</td>";
	                                    }

	                                    item_str += "<td>" + d.KD_COUNT + "</td>" +
	                                    "<td>" + d.ITV_COUNT + "</td>" +
	                                    "<td>" + d.GU_COUNT + "</td>" +
	                                    "<td>" + d.YX_UN + "</td>";

	                                    if (d.SEGM_ID != 0)
	                                        item_str += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:removeItemFromBuildInVillage(this,'" + d.SEGM_ID + "')\"></a>";
	                                    else
	                                        item_str += "<td>";

	                                    item_str += "</td></tr>";
	                                    $("#buildInvillage_res_list").append(item_str);
	                                }

	                            });
                            }else{
                            	$.post(url4Query_enterprise, {eaction: "build_wines_in_school_or_enterprise", village_id: v_id}, function (data1) {
	                                data1 = $.parseJSON(data1);
	                                for (var i = 0, l = data1.length; i < l; i++) {
	                                    var d = data1[i];
	                                    var item_str = "";
	                                    if (d.SEGM_ID == 0) {
	                                        village_new_total_nums = d;
	                                        item_str = "<tr><td></td>";
	                                    }
	                                    else
	                                        item_str = "<tr><td class=\"order\">" + (i) + "</td>";

	                                    buildRes[d.SEGM_ID] = d;
	                                    var zhu_hu_count = d.ZHU_HU_COUNT;
	                                    if (zhu_hu_count == null)
	                                        zhu_hu_count = '--';

	                                    //if(zhu_hu_count!="--")
	                                    //	village_people_total += parseInt(zhu_hu_count);

	                                    var res_id_count = d.RES_ID_COUNT;
	                                    if (res_id_count == null)
	                                        res_id_count = '--';

	                                    //if(res_id_count!="--")
	                                    //	village_port_total += parseInt(res_id_count);

	                                    var sy_res_count = d.SY_RES_COUNT;
	                                    if (sy_res_count == null)
	                                        sy_res_count = '--';

	                                    //if(sy_res_count!="--")
	                                    //	village_port_unused_num += parseInt(sy_res_count);

	                                    var port_used_rate = 0;
	                                    if (res_id_count == 0)
	                                        port_used_rate = "--";

	                                    if (res_id_count != "--" && sy_res_count != "--" && res_id_count != 0)
	                                        port_used_rate = ((res_id_count - sy_res_count) / res_id_count * 100).toFixed(2) + "%";
	                                    else
	                                        port_used_rate = "--";

	                                    var used_port = 0;
	                                    if (isNaN(res_id_count) || isNaN(sy_res_count)) {
	                                        used_port = "--";
	                                    } else {
	                                        used_port = res_id_count - sy_res_count;
	                                    }

	                                    item_str += "<td>" + d.STAND_NAME + "</td>" +
	                                    "<td>" + zhu_hu_count + "</td>";

	                                    if(i==0){
	                                    	item_str += "<td>--</td><td>--</td>";
	                                    }else{
	                                    	item_str += "<td>" + res_id_count + "</td>" +
	                                    		"<td>" + sy_res_count + "</td>";
	                                    }

	                                        //"<td>" + port_used_rate + "</td>" +
	                                    item_str += "<td>" + d.KD_COUNT + "</td>" +
	                                    "<td>" + d.ITV_COUNT + "</td>" +
	                                    "<td>" + d.GU_COUNT + "</td>" +
	                                    "<td>" + d.YX_UN + "</td>";

	                                    if (d.SEGM_ID != 0)
	                                        item_str += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:removeItemFromBuildInVillage(this,'" + d.SEGM_ID + "')\"></a>";
	                                    else
	                                        item_str += "<td>";

	                                    item_str += "</td></tr>";
	                                    $("#buildInvillage_res_list").append(item_str);
	                                }
	                                //if(sort>ids.length){

	                                $("#village_new_yd_sum").text(village_new_total_nums.YD_COUNT);
	                                $("#village_new_kd_sum").text(village_new_total_nums.KD_COUNT);
	                                $("#village_new_ds_sum").text(village_new_total_nums.ITV_COUNT);
	                                $("#village_people_total").text(village_new_total_nums.ZHU_HU_COUNT);
	                                /* $("#village_port_total").text(village_new_total_nums.RES_ID_COUNT);
	                                $("#village_port_free").text(village_new_total_nums.SY_RES_COUNT);
	                                $("#village_used_num").text(village_new_total_nums.RES_ID_COUNT - village_new_total_nums.SY_RES_COUNT); */
	                                village_new_total_nums["village_builds_total"] = data1.length - 1 < 0 ? 0 : data1.length - 1;
	                                $("#village_builds_total").text(village_new_total_nums["village_builds_total"]);
	                                //$("#village_port_used_rate").html(village_new_total_nums.PORT_LV + "%");

	                                $("#village_new_dxyd_count").text(village_new_total_nums.YD_COUNT);
	                                $("#village_new_dxkd_count").text(village_new_total_nums.KD_COUNT);
	                                $("#village_new_dxds_count").text(village_new_total_nums.ITV_COUNT);

	                                //}
	                            });
                            }

                            //addBuildToVillagePolygen('', ids_str);
                            removeBuildToVillageUsed(build_id_used);
                        });
                    }

                    var back_btn_hided = "";
                    var draw_layer_leida_click_handler = "";
                    var draw_layer_leida_move_handler = "";
                    var draw_layer_village_click_handler = "";
                    var village_mouse_over_when_draw_handler = "";
                    var village_mouse_over_when_draw_handler1 = "";
                    var village_mouse_out_when_draw_handler = "";
                    var village_mouse_out_when_draw_handler = "";

                    function drawEnable(evt) {
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
                        if (zoom < 9 && draw_type != "village") {
                            var point = map.center;
                            map.centerAndZoom(point, 9);
                        }

                        $("#nav_standard").addClass("active");

                        $("#nav_marketing").addClass("active");
                        map.setMapCursor("crosshair");
                        map.infoWindow.hide();
                        draw_layer.clear();
                        draw_layer.show();
                        killEvent();
                        if (draw_layer_leida_click_handler != "")
                            dojo.disconnect(draw_layer_leida_click_handler);
                        /*if(draw_layer_leida_move_handler!="")
                         dojo.disconnect(draw_layer_leida_move_handler);*/
                        if (draw_type == "ellipse") {
                            //esri.bundle.toolbars.draw.addPoint = "点击鼠标后拖拽，释放鼠标完成绘制";
                            toolbar.activate(Draw.ELLIPSE);
                        }
                        else if (draw_type == "circle") {
                            //esri.bundle.toolbars.draw.addPoint = "点击鼠标后拖拽，释放鼠标完成绘制";
                            toolbar.activate(Draw.CIRCLE);
                        }
                        else if (draw_type == "rectangle" || draw_type == "rectangle_village") {
                            //esri.bundle.toolbars.draw.addPoint = "点击鼠标后拖拽，释放鼠标完成绘制";
                            toolbar.activate(Draw.RECTANGLE);
                            if (draw_type == "rectangle_village") {
                                //map.addLayer(draw_layer_mark_build);
                                killEventForBuildInVillage();
                                reboundForBuildInVillage();
                            }
                        }
                        else if (draw_type == "polygon" || draw_type == "polygon_village") {
                            toolbar.activate(Draw.POLYGON);
                            if (draw_type == "polygon_village") {
                                //map.addLayer(draw_layer_mark_build);
                                killEventForBuildInVillage();
                                reboundForBuildInVillage();
                            }
                            //esri.bundle.toolbars.draw.addPoint = "点击一次鼠标增加一个点，双击鼠标完成绘制";
                        }
                        else if (draw_type == "freehand_polygon") {
                            //esri.bundle.toolbars.draw.addPoint = "点击鼠标后移动，自由绘制，释放鼠标完成绘制";
                            toolbar.activate(Draw.FREEHAND_POLYGON);
                        }
                        else if (draw_type == "leida") {//点框选功能
                            //toolbar.activate(Draw.POINT);
                            //esri.bundle.toolbars.draw.addPoint = "鼠标点击的位置为辐射范围中心点，点击鼠标完成绘制";
                            draw_layer_leida_click_handler = dojo.connect(map, "onClick", function (evt) {
                                draw_layer_leida_click_f(evt, $("#draw_half").val());
                            });
                            /*draw_layer_leida_move_handler = dojo.connect(map,"onMouseMove",function(evt){
                             draw_layer_leida_move_f(evt);
                             });*/
                        }
                        else if (draw_type == "village") {
                            draw_layer_village_click_handler = dojo.connect(graLayer_wg_for_village, "onClick", function (evt) {
                                draw_layer_village_click_f(evt);
                            });
                            village_mouse_over_when_draw_handler = dojo.connect(village_layer, "onMouseOver", function (evt) {
                                village_mouse_over_when_draw_f(evt);
                            });
                            village_mouse_over_when_draw_handler1 = dojo.connect(village_position_layer, "onMouseOver", function (evt) {
                                village_mouse_over_when_draw_f(evt);
                            });
                            village_mouse_out_when_draw_handler = dojo.connect(village_layer, "onMouseOut", function (evt) {
                                village_mouse_out_when_draw_f(evt);
                            });
                            village_mouse_out_when_draw_handler1 = dojo.connect(village_position_layer, "onMouseOut", function (evt) {
                                village_mouse_out_when_draw_f(evt);
                            });
                            //校园事件
                            /*draw_layer_school_click_f = dojo.connect(graLayer_wg_for_village, "onClick", function (evt) {
                                draw_layer_village_click_f(evt);
                            });*/
                            school_GraphicsLayer_mouse_over_handler = dojo.connect(school_GraphicsLayer, "onMouseOver", function (evt) {
														    map.setMapCursor("pointer");
														    school_mouse_over_when_draw_f(evt);
														});
                            school_GraphicsLayer_mouse_out_handler = dojo.connect(school_GraphicsLayer, "onMouseOver", function (evt) {
                            		map.setMapCursor("default");
                                school_mouse_out_when_draw_f(evt);
                            });
                            school_GraphicsLayer_selected_mouse_over_handler = dojo.connect(school_GraphicsLayer_selected, "onMouseOut", function (evt) {
                                school_mouse_over_when_draw_f(evt);
                            });
                            school_GraphicsLayer_selected_mouse_out_handler = dojo.connect(school_GraphicsLayer_selected, "onMouseOut", function (evt) {
                                school_mouse_out_when_draw_f(evt);
                            });

                            //商客事件
                            enterprise_GraphicsLayer_mouse_over_handler = dojo.connect(enterprise_GraphicsLayer, "onMouseOver", function (evt) {
														    map.setMapCursor("pointer");
														    enterprise_mouse_over_when_draw_f(evt);
														});
                            enterprise_GraphicsLayer_mouse_out_handler = dojo.connect(enterprise_GraphicsLayer, "onMouseOver", function (evt) {
                            		map.setMapCursor("default");
                                enterprise_mouse_out_when_draw_f(evt);
                            });
                            enterprise_GraphicsLayer_selected_mouse_over_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onMouseOut", function (evt) {
                                enterprise_mouse_over_when_draw_f(evt);
                            });
                            enterprise_GraphicsLayer_selected_mouse_out_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onMouseOut", function (evt) {
                                enterprise_mouse_out_when_draw_f(evt);
                            });

                        }
                    }

                    draw_layer_leida_click_f = function (evt, num) {
                        //dojo.disconnect(draw_layer_leida_handler);
                        circle = new Circle({
                            center: evt.mapPoint,
                            geodesic: false,
                            radius: num / 1000,
                            radiusUnit: Units.KILOMETERS
                        });
                        draw_layer.clear();
                        var graphic = new Graphic(circle, circleSymb);
                        draw_layer.show();
                        draw_layer.add(graphic);
                        drawAddToMap(evt);
                    };
                    draw_layer_leida_move_f = function (evt) {
                        /*$("#leida_div").css("left",(evt.x-25) + "px");
                         $("#leida_div").css("top",(evt.y-25) + "px");*/
                    }
                    draw_layer_village_click_f = function (evt) {
                        symbol = new SimpleMarkerSymbol();
                        draw_layer.clear();
                        var graphic = new Graphic(evt.geometry, symbol);
                        draw_layer.show();
                        draw_layer.add(graphic);
                        drawAddToMap(evt);
                    };
                    village_mouse_over_when_draw_f = function (evt) {
                        var village_id = evt.graphic.attributes.village_id;
                        $.post(url4Query, {eaction: 'village_message', village_id: village_id}, function (data) {
                            var d = $.parseJSON(data);
                            var village_name = "未查询到名称";
                            if (d != null)
                                village_name = d.VILLAGE_NAME;
                            $("#village_info_mini_win").html(village_name);
                            $("#village_info_mini_win").css({top: evt.pageY + 10, left: evt.pageX + 10});
                            $("#village_info_mini_win").show();
                        });
                    }
                    village_mouse_out_when_draw_f = function (evt) {
                        $("#village_info_mini_win").hide();
                    }

                    draw_layer_school_click_f = function (evt) {
										    symbol = new SimpleMarkerSymbol();
										    draw_layer.clear();
										    var graphic = new Graphic(evt.geometry, symbol);
										    draw_layer.show();
										    draw_layer.add(graphic);
										    drawAddToMap(evt);
										};
										school_mouse_over_when_draw_f = function (evt) {
										    var school_name = evt.graphic.attributes.school_name;
										    $("#village_info_mini_win").html(school_name);
								        $("#village_info_mini_win").css({top: evt.pageY + 10, left: evt.pageX + 10});
								        $("#village_info_mini_win").show();
										}
										school_mouse_out_when_draw_f = function (evt) {
										    $("#village_info_mini_win").hide();
										}


										draw_layer_enterprise_click_f = function (evt) {
										    symbol = new SimpleMarkerSymbol();
										    draw_layer.clear();
										    var graphic = new Graphic(evt.geometry, symbol);
										    draw_layer.show();
										    draw_layer.add(graphic);
										    drawAddToMap(evt);
										};
										enterprise_mouse_over_when_draw_f = function (evt) {
										    var enterprise_name = evt.graphic.attributes.enterprise_name;
										    $("#village_info_mini_win").html(enterprise_name);
								        $("#village_info_mini_win").css({top: evt.pageY + 10, left: evt.pageX + 10});
								        $("#village_info_mini_win").show();
										}
										enterprise_mouse_out_when_draw_f = function (evt) {
										    $("#village_info_mini_win").hide();
										}

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
                    map.on("click", function(evt){
                     /*circle = new Circle({
                     center: evt.mapPoint,
                     geodesic: true,
                     radius: 1,
                     radiusUnit: "esriMiles"
                     });
                     map.graphics.clear();
                     var graphic = new Graphic(circle, circleSymb);
                     draw_layer.show();
                     draw_layer.add(graphic);*/
                     console.log(evt.mapPoint);

                     });
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
                    function killEventForBuildView() {//在能看到楼宇的视野范围下要禁止的事件,也就是地图放大到9级的时候
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
                    }

                    function killEventForBuildInVillage() {//在从框选楼宇加入到小区的功能退出时要禁止的事件
                        dojo.disconnect(standard_layer_mouse_over_handler);
                        dojo.disconnect(standard_layer_mouse_out_handler);
                        dojo.disconnect(standard_layer_click_for_buildInVillage_handler);
                        dojo.disconnect(draw_layer_mark_build_mouse_over_handler);
                        dojo.disconnect(draw_layer_mark_build_mouse_out_handler);
                        dojo.disconnect(draw_layer_mark_build_click_handler);
                        dojo.disconnect(drawed_layer_mark_build_mouse_over_handler);
                        dojo.disconnect(drawed_layer_mark_build_mouse_out_handler);
                        dojo.disconnect(drawed_layer_mark_build_click_handler);
                    }

                    function killEvent() {
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

                        dojo.disconnect(draw_layer_mark_build_mouse_over_handler);
                        dojo.disconnect(draw_layer_mark_build_mouse_out_handler);
                        dojo.disconnect(draw_layer_mark_build_click_handler);
                        dojo.disconnect(drawed_layer_mark_build_mouse_over_handler);
                        dojo.disconnect(drawed_layer_mark_build_mouse_out_handler);
                        dojo.disconnect(drawed_layer_mark_build_click_handler);

                        dojo.disconnect(village_layer_mouse_over_handler);
                        dojo.disconnect(village_layer_mouse_out_handler);
                        dojo.disconnect(village_layer_click_handler);

                        dojo.disconnect(village_selected_layer_mouse_over_handler);
                        dojo.disconnect(village_selected_layer_mouse_out_handler);
                        dojo.disconnect(village_selected_layer_click_handler);

                        dojo.disconnect(school_GraphicsLayer_mouse_over_handler);
                        dojo.disconnect(school_GraphicsLayer_mouse_out_handler);
                        dojo.disconnect(school_GraphicsLayer_click_handler);

                        dojo.disconnect(school_GraphicsLayer_selected_mouse_over_handler);
                        dojo.disconnect(school_GraphicsLayer_selected_mouse_out_handler);
                        dojo.disconnect(school_GraphicsLayer_selected_click_handler);

                        dojo.disconnect(enterprise_GraphicsLayer_mouse_over_handler);
                        dojo.disconnect(enterprise_GraphicsLayer_mouse_out_handler);
                        dojo.disconnect(enterprise_GraphicsLayer_click_handler);

                        dojo.disconnect(enterprise_GraphicsLayer_selected_mouse_over_handler);
                        dojo.disconnect(enterprise_GraphicsLayer_selected_mouse_out_handler);
                        dojo.disconnect(enterprise_GraphicsLayer_selected_click_handler);
                    }

                    function reboundForBuildView() {//在能看到楼宇的视野范围下要禁止的事件，也就是地图缩放级别在小于9级的时候
                        featureLayer_mouse_over_handler = dojo.connect(featureLayer, "onMouseOver", function (evt) {
                            featureLayer_mouse_over(evt);
                        });
                        featureLayer_mouse_out_handler = dojo.connect(featureLayer, "onMouseOut", function (evt) {
                            featureLayer_mouse_out(evt);
                        });
                        featureLayer_click_handler = dojo.connect(featureLayer, "onClick", function (evt) {
                            featureLayer_click(evt);
                        });

                        graLayer_zjname_mouse_over_handler = dojo.connect(graLayer_zjname, "onMouseOver", function (evt) {
                            graLayer_zjname_mouse_over(evt);
                        });
                        graLayer_zjname_mouse_out_handler = dojo.connect(graLayer_zjname, "onMouseOut", function (evt) {
                            map.setMapCursor("default");
                        });
                        graLayer_zjname_click_handler = dojo.connect(graLayer_zjname, "onClick", function (evt) {
                            graLayer_zjname_click(evt);
                        });

                        graLayer_wg_mouse_over_handler = dojo.connect(graLayer_wg, "onMouseOver", function (evt) {
                            graLayer_wg_mouse_over(evt);
                        });
                        graLayer_wg_mouse_out_handler = dojo.connect(graLayer_wg, "onMouseOut", function (evt) {
                            graLayer_wg_mouse_out(evt);
                        });
                        graLayer_wg_click_handler = dojo.connect(graLayer_wg, "onClick", function (evt) {
                            graLayer_wg_click_f(evt);
                        });

                        graLayer_wg_text_mouse_over_handler = dojo.connect(graLayer_wg_text, "onMouseOver", function (evt) {
                            graLayer_wg_text_mouse_over(evt);
                        });
                        graLayer_wg_text_mouse_out_handler = dojo.connect(graLayer_wg_text, "onMouseOut", function (evt) {
                            graLayer_wg_text_mouse_out(evt);
                        });
                        graLayer_wg_text_click_handler = dojo.connect(graLayer_wg_text, "onClick", function (evt) {
                            graLayer_wg_text_click(evt);
                        });
                    }

                    var standard_layer_click_for_buildInVillage_handler = "";
                    var draw_layer_mark_build_click_handler = "";
                    var drawed_layer_mark_build_click_handler = "";

                    function reboundForBuildInVillage() {
                        standard_layer_mouse_over_handler = dojo.connect(standard_layer, "onMouseOver", function (evt) {
                            $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                            $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                            $("#village_info_mini_win").show();
                        });
                        standard_layer_mouse_out_handler = dojo.connect(standard_layer, "onMouseOut", function (evt) {
                            $("#village_info_mini_win").hide();
                        });
                        draw_layer_mark_build_mouse_over_handler = dojo.connect(draw_layer_mark_build, "onMouseOver", function (evt) {
                            $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                            $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                            $("#village_info_mini_win").show();
                        });
                        draw_layer_mark_build_mouse_out_handler = dojo.connect(draw_layer_mark_build, "onMouseOut", function (evt) {
                            $("#village_info_mini_win").hide();
                        });
                        drawed_layer_mark_build_mouse_over_handler = dojo.connect(drawed_layer_mark_build, "onMouseOver", function (evt) {
                            $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                            $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                            $("#village_info_mini_win").show();
                        });
                        drawed_layer_mark_build_mouse_out_handler = dojo.connect(drawed_layer_mark_build, "onMouseOut", function (evt) {
                            $("#village_info_mini_win").hide();
                        });
                    }

                    var village_selected_gra_update = "";

                    function reboundEvent() {
                        map_mouse_move_handler = dojo.connect(map, "onMouseOver", function (evt) {
                            map_mouse_move(evt);
                        });

                        featureLayer_mouse_over_handler = dojo.connect(featureLayer, "onMouseOver", function (evt) {
                            featureLayer_mouse_over(evt);
                        });
                        featureLayer_mouse_out_handler = dojo.connect(featureLayer, "onMouseOut", function (evt) {
                            featureLayer_mouse_out(evt);
                        });
                        featureLayer_click_handler = dojo.connect(featureLayer, "onClick", function (evt) {
                            featureLayer_click(evt);
                        });

                        graLayer_zjname_mouse_over_handler = dojo.connect(graLayer_zjname, "onMouseOver", function (evt) {
                            graLayer_zjname_mouse_over(evt);
                        });
                        graLayer_zjname_mouse_out_handler = dojo.connect(graLayer_zjname, "onMouseOut", function (evt) {
                            map.setMapCursor("default");
                        });
                        graLayer_zjname_click_handler = dojo.connect(graLayer_zjname, "onClick", function (evt) {
                            graLayer_zjname_click(evt);
                        });

                        graLayer_wg_mouse_over_handler = dojo.connect(graLayer_wg, "onMouseOver", function (evt) {
                            graLayer_wg_mouse_over(evt);
                        });
                        graLayer_wg_mouse_out_handler = dojo.connect(graLayer_wg, "onMouseOut", function (evt) {
                            graLayer_wg_mouse_out(evt);
                        });
                        graLayer_wg_click_handler = dojo.connect(graLayer_wg, "onClick", function (evt) {
                            graLayer_wg_click_f(evt);
                        });

                        graLayer_wg_text_mouse_over_handler = dojo.connect(graLayer_wg_text, "onMouseOver", function (evt) {
                            graLayer_wg_text_mouse_over(evt);
                        });
                        graLayer_wg_text_mouse_out_handler = dojo.connect(graLayer_wg_text, "onMouseOut", function (evt) {
                            graLayer_wg_text_mouse_out(evt);
                        });
                        graLayer_wg_text_click_handler = dojo.connect(graLayer_wg_text, "onClick", function (evt) {
                            graLayer_wg_text_click(evt);
                        });

                        graLayer_wd_mouse_over_handler = dojo.connect(graLayer_wd, "onMouseOver", function (evt) {
                            graLayer_wd_mouse_over(evt);
                        });
                        graLayer_wd_mouse_out_handler = dojo.connect(graLayer_wd, "onMouseOut", function (evt) {
                            graLayer_wd_mouse_out(evt);
                        });

                        standard_layer_mouse_over_handler = dojo.connect(standard_layer, "onMouseOver", function (evt) {
                            map.setMapCursor("pointer");
                            //standard_layer_click(evt);
                            $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                            $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                            $("#village_info_mini_win").show();
                        });
                        standard_layer_mouse_out_handler = dojo.connect(standard_layer, "onMouseOut", function (evt) {
                            map.setMapCursor("default");
                            //$("#build_info_win").hide();
                            $("#village_info_mini_win").hide();
                        });
                        standard_layer_click_handler = dojo.connect(standard_layer, "onClick", function (evt) {
                            standard_layer_click(evt);
                        });

                        draw_layer_mark_build_mouse_over_handler = dojo.connect(draw_layer_mark_build, "onMouseOver", function (evt) {
                            map.setMapCursor("pointer");
                            $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                            $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                            $("#village_info_mini_win").show();
                        });

                        draw_layer_mark_build_mouse_out_handler = dojo.connect(draw_layer_mark_build, "onMouseOut", function (evt) {
                            map.setMapCursor("default");
                            //map.infoWindow.hide();
                            $("#village_info_mini_win").hide();
                        });

                        draw_layer_mark_build_click_handler = dojo.connect(draw_layer_mark_build, "onClick", function (evt) {
                            standard_layer_click(evt);
                        });

                        drawed_layer_mark_build_mouse_over_handler = dojo.connect(drawed_layer_mark_build, "onMouseOver", function (evt) {
                            map.setMapCursor("pointer");
                            $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                            $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                            $("#village_info_mini_win").show();
                        });

                        drawed_layer_mark_build_mouse_out_handler = dojo.connect(drawed_layer_mark_build, "onMouseOut", function (evt) {
                            map.setMapCursor("default");
                            //map.infoWindow.hide();
                            $("#village_info_mini_win").hide();
                        });

                        drawed_layer_mark_build_click_handler = dojo.connect(drawed_layer_mark_build, "onClick", function (evt) {
                            standard_layer_click(evt);
                        });

                        village_layer_mouse_over_handler = dojo.connect(village_layer, "onMouseOver", function (evt) {
                            map.setMapCursor("pointer");
                            village_mouse_over_when_draw_f(evt);
                        });

                        village_layer_mouse_out_handler = dojo.connect(village_layer, "onMouseOut", function (evt) {
                            map.setMapCursor("default");
                            village_mouse_out_when_draw_f(evt);
                        });

                        village_layer_click_handler = dojo.connect(village_layer, "onClick", function (evt) {
                            layer.closeAll();
                            tmp2 = "1";
                            $("#nav_grid").removeClass("active");
                            tmpx = '1';
                            $("#nav_village").removeClass("active");
                            operateVillage(evt.graphic.attributes.village_id);
                            var pointAttributes = {"village_id": evt.graphic.attributes.village_id};
                            var ico_url1 = village_ico_selected;
                            var size = village_ico_get_size(map.getZoom());
                            village_selected_gra_update = evt.graphic;
                            var img1 = new PictureMarkerSymbol(ico_url1, size, size);
                            var graphic1 = new esri.Graphic(evt.graphic.geometry, img1, pointAttributes);
                            village_position_layer.clear();
                            village_position_layer.add(graphic1);
                        });

                        village_selected_layer_mouse_over_handler = dojo.connect(village_position_layer, "onMouseOver", function (evt) {
                            map.setMapCursor("pointer");
                            village_mouse_over_when_draw_f(evt);
                        });

                        village_selected_layer_mouse_out_handler = dojo.connect(village_position_layer, "onMouseOut", function (evt) {
                            map.setMapCursor("default");
                            village_mouse_out_when_draw_f(evt);
                        });

                        village_selected_layer_click_handler = dojo.connect(village_position_layer, "onClick", function (evt) {
                            layer.closeAll();
                            tmpx = '1';
                            $("#nav_village").removeClass("active");
                            operateVillage(evt.graphic.attributes.village_id);
                        });

                        school_GraphicsLayer_mouse_over_handler = dojo.connect(school_GraphicsLayer, "onMouseOver", function (evt) {
												    map.setMapCursor("pointer");
												    school_mouse_over_when_draw_f(evt);
												});
												school_GraphicsLayer_mouse_out_handler = dojo.connect(school_GraphicsLayer, "onMouseOut", function (evt) {
												    map.setMapCursor("default");
												    school_mouse_out_when_draw_f(evt);
												});
												//学校点击 校园点击
												school_GraphicsLayer_click_handler = dojo.connect(school_GraphicsLayer, "onClick", function (evt) {
												    layer.closeAll();
												    var school_id = evt.graphic.attributes.school_id;
												    village_gras_array[school_id] = evt.graphic;
												    operateVillage(school_id);
												    var pointAttributes = {"school_id": school_id};
												    var ico_url1 = school_ico_selected;
												    var size = village_ico_get_size(map.getZoom());
												    village_selected_gra_update = evt.graphic;
												    var img1 = new PictureMarkerSymbol(ico_url1, size, size);
												    var graphic1 = new esri.Graphic(evt.graphic.geometry, img1, pointAttributes);
												    school_GraphicsLayer_selected.clear();
												    school_GraphicsLayer_selected.add(graphic1);
												});

												school_GraphicsLayer_selected_mouse_over_handler = dojo.connect(school_GraphicsLayer_selected, "onMouseOver", function (evt) {
												    map.setMapCursor("pointer");
												    school_mouse_over_when_draw_f(evt);
												});
												school_GraphicsLayer_selected_mouse_out_handler = dojo.connect(school_GraphicsLayer_selected, "onMouseOut", function (evt) {
												    map.setMapCursor("default");
												    school_mouse_out_when_draw_f(evt);
												});
												school_GraphicsLayer_selected_click_handler = dojo.connect(school_GraphicsLayer_selected, "onClick", function (evt) {
												    tmpx = '1';
												    $("#nav_village").removeClass("active");
												    layer.closeAll();
												    village_selected_gra_update = evt.graphic;
												    operateVillage(evt.graphic.attributes.school_id);
												});

												enterprise_GraphicsLayer_mouse_over_handler = dojo.connect(enterprise_GraphicsLayer, "onMouseOver", function (evt) {
												    map.setMapCursor("pointer");
												    enterprise_mouse_over_when_draw_f(evt);
												});
												enterprise_GraphicsLayer_mouse_out_handler = dojo.connect(enterprise_GraphicsLayer, "onMouseOut", function (evt) {
												    map.setMapCursor("default");
												    enterprise_mouse_out_when_draw_f(evt);
												});
												//学校点击 校园点击
												enterprise_GraphicsLayer_click_handler = dojo.connect(enterprise_GraphicsLayer, "onClick", function (evt) {
												    layer.closeAll();
												    var enterprise_id = evt.graphic.attributes.enterprise_id;
												    village_gras_array[enterprise_id] = evt.graphic;
												    operateVillage(enterprise_id);
												    var pointAttributes = {"enterprise_id": enterprise_id};
												    var ico_url1 = enterprise_ico_selected;
												    var size = village_ico_get_size(map.getZoom());
												    village_selected_gra_update = evt.graphic;
												    var img1 = new PictureMarkerSymbol(ico_url1, size, size);
												    var graphic1 = new esri.Graphic(evt.graphic.geometry, img1, pointAttributes);
												    enterprise_GraphicsLayer_selected.clear();
												    enterprise_GraphicsLayer_selected.add(graphic1);
												});

												enterprise_GraphicsLayer_selected_mouse_over_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onMouseOver", function (evt) {
												    map.setMapCursor("pointer");
												    enterprise_mouse_over_when_draw_f(evt);
												});
												enterprise_GraphicsLayer_selected_mouse_out_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onMouseOut", function (evt) {
												    map.setMapCursor("default");
												    enterprise_mouse_out_when_draw_f(evt);
												});
												enterprise_GraphicsLayer_selected_click_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onClick", function (evt) {
												    tmpx = '1';
												    $("#nav_village").removeClass("active");
												    layer.closeAll();
												    village_selected_gra_update = evt.graphic;
												    operateVillage(evt.graphic.attributes.enterprise_id);
												});
                    }

                    function addBuildToVillagePoint(evt) {
                        var attr = evt.graphic.attributes;
                        if (buildInVillage[attr.RESID] != undefined) {//已经选中的楼宇上再次点击，则取消它
                            delete buildInVillage[attr.RESID];
                            delete buildInVillage_short[attr.RESID];
                            draw_layer_mark_build.remove(draw_graphics_array_for_buildInVillage[attr.RESID]);//从图层上消除选中
                            delete draw_graphics_array_for_buildInVillage[attr.RESID];
                            return;
                        }
                        if (drawed_graphics_array_for_buildInVillage[attr.RESID] != undefined) {//选了不可用的楼宇，其他小区使用过的
                            return;
                        }
                        var build_geo = evt.graphic.geometry;

                        //var build_gra=new Graphic(build_geo,point_selected_mark);

                        var size = standard_point_get_size(map.getZoom());//获取当前放大级别下，渠道网点图标的大小
                        var img = new PictureMarkerSymbol(standard_ico_selected, size, size);
                        var build_gra = new esri.Graphic(build_geo, img, evt.graphic.attributes);
                        draw_layer_mark_build.add(build_gra);
                        //draw_graphics_array_for_buildInVillage[attr.RESID] = build_gra;
                        //map.addLayer(draw_layer_mark_build);

                        buildInVillage[attr.RESID] = attr.RESFULLNAME;
                        buildInVillage_short[attr.RESID] = attr.RESNAME;
                        draw_build_result_array_for_buildVillage.push(attr.RESID);
                    }

                    function removeBuildToVillageUsed(build_id_used) {
                        for (var i = 0, l = build_id_used.length; i < l; i++) {
                            drawed_layer_mark_build.remove(drawed_graphics_array_for_buildInVillage[build_id_used[i]]);
                            delete drawed_graphics_array_for_buildInVillage[build_id_used[i]];
                        }
                    }

                    //营销弹出end
                    //直方图，暂不用
                    $("#nav_chart").unbind();
                    $("#nav_chart").click(
                            function () {
                                if (chartIsShow) {
                                    hideWINInfo();
                                } else {
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
                    color_map['2001000'] = [164, 0, 233, 1];
                    color_map['2001100'] = [255, 229, 0, 1];
                    color_map['2001200'] = [254, 84, 0, 1];
                    color_map['2001300'] = [106, 226, 0, 1];
                    color_map['2001400'] = [9, 0, 183, 1];
                    var color_point_line = [255, 0, 0];

                    var channel_ico = new Array();
                    channel_ico['2001000'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point1.png" />';
                    channel_ico['2001100'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point2.png" />';
                    channel_ico['2001200'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point3.png" />';
                    channel_ico['2001300'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point4.png" />';
                    channel_ico['2001400'] = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/channel_point5.png" />';

                    var standard_ico = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/build1.png" />';
                    var standard_ico_selected = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/build1_selected.png" />';
                    var standard_ico_used = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/build1_used.png" />';
                    //var village_ico = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/community.png" />';
                    var village_ico = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/community3.png" />';
                    var village_ico_selected = '<e:url value="/pages/telecom_Index/common/images/channel_ico_new/community_selected.png" />';

                    var school_ico = '<e:url value="/pages/telecom_Index/common/images/enterprise/school_ico.png" />';
                    var school_ico_selected = '<e:url value="/pages/telecom_Index/common/images/enterprise/school_ico_selected.png" />';

                    var enterprise_ico = '<e:url value="/pages/telecom_Index/common/images/enterprise/enterprise_ico.png" />';
                    var enterprise_ico_selected = '<e:url value="/pages/telecom_Index/common/images/enterprise/enterprise_ico_selected.png" />';

                    tiled = new ArcGISTiledMapServiceLayer(layer_ds);
                    map.addLayer(tiled);

                    featureLayer = new FeatureLayer(new_url_sub_vaild + sub_layer_index, {
                        definitionExpression: "BRANCH_TYPE ='a1' ",
                        mode: FeatureLayer.MODE_SNAPSHOT,
                        //mode: FeatureLayer.MODE_ONDEMAND,
                        outFields: ["*"],
                        visible: true,
                        opacity: 1
                    });

                    //修改 楼宇点击切换地市定位问题 720 1159↓
                    function changeMapToCity(city_name_var, latn_id) {
                        var full_name = city_name_var + "市";
                        cityForLayer = cityNames[latn_id];
                        if (cityForLayer == null || cityForLayer == undefined) {
                            cityForLayer = cityNames[latn_id];
                            full_name = city_name_var + "州";
                        }

                        //全局变量修改
                        city_id = latn_id;
                        city_name = city_name_var;
                        map_id = map_id_in_gis[city_id];

                        parent.global_current_flag = 2;
                        parent.global_position[1] = full_name;
                        parent.global_position[2] = '';
                        if (zxs[city_id] != undefined)
                            parent.global_position[2] = full_name;
                        parent.global_position[3] = '';
                        parent.global_position[4] = '';
                        parent.global_current_full_area_name = full_name;
                        parent.global_current_area_name = city_name_var;
                        parent.global_current_city_id = city_id;

                        toGis();
                    }

                    //修改 楼宇点击切换地市定位问题 ↑

                    //绘制所有支局的颜色
                    var sub_dev = new Array();
                    var sub_graphics_init = new Array();//存放所有支局的graphics
                    var sub_zoom_array = new Array();//支局的放大级别
                    var defaultSymbol = new SimpleFillSymbol().setStyle(SimpleFillSymbol.STYLE_NULL);
                    defaultSymbol.outline.setStyle(SimpleLineSymbol.STYLE_NULL);
                    var renderer = new UniqueValueRenderer(defaultSymbol, "SUBSTATION_NO");

                    subDraw_subList();
                    function subDraw_subList() {
                        $.post(url4Query, {
                            eaction: "getSubColorByLatnId",
                            city_id: city_id,
                            yesterday: '${yesterday.VAL}',
                            last_month: '${lastMonth.VAL}'
                        }, function (data) {
                            data = $.parseJSON(data);
                            for (var i = 0, l = data.length; i < l; i++) {
                                var d = data[i];
                                sub_dev[d.UNION_ORG_CODE] = {
                                    bureau_name: d.BUREAU_NAME,
                                    branch_type: d.BRANCH_TYPE,
                                    grid_id_cnt: d.GRID_ID_CNT,
                                    grid_show: d.GRID_SHOW,
                                    mobile_mon_cum_new: d.MOBILE_MON_CUM_NEW,
                                    mobile_mon_cum_new_last: d.MOBILE_MON_CUM_NEW_LAST,
                                    cur_mon_bil_serv: d.CUR_MON_BIL_SERV,
                                    brd_mon_cum_new: d.BRD_MON_CUM_NEW,
                                    brd_mon_cum_new_last: d.BRD_MON_CUM_NEW_LAST,
                                    cur_mon_brd_serv: d.CUR_MON_BRD_SERV,
                                    itv_mon_new_install_serv: d.ITV_MON_NEW_INSTALL_SERV,
                                    itv_serv_cur_mon_new_last: d.ITV_SERV_CUR_MON_NEW_LAST,
                                    branch_hlzoom: d.BRANCH_HLZOOM,
                                };
                                var color_temp = d.COLOR;
                                var sub_fill = "";
                                if (color_temp == null) {
                                    sub_fill = new SimpleFillSymbol(
                                            SimpleFillSymbol.STYLE_NULL,
                                            new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL, new Color([255, 0, 0, 1]), 2),//0.3],2
                                            new Color([255, 0, 0, 1])//0.6
                                    );
                                } else {
                                    var color = d.COLOR.split(",");
                                    sub_fill = new SimpleFillSymbol(
                                            SimpleFillSymbol.STYLE_SOLID,
                                            new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([color[0], color[1], color[2], 1]), 2),//0.3],2
                                            new Color([color[0], color[1], color[2], 1])//0.6
                                    );
                                }
                                renderer.addValue(d.UNION_ORG_CODE, sub_fill);
                            }

                            //设置左侧列表内容 左侧支局
                            $.post('<e:url value="querysubgrid.e"/>', {
                                //eaction: "getSubListByLatnId",
                                city_id: city_id
                            }, function (data) {
                                data = $.parseJSON(data);
                                var data1 = data[1];
                                data = data[0];
                                var sub_style_num = new Array();
                                var sub_show_num = 0;
                                var where_temp = "SUBSTATION_NO IN (";
                                for (var i = 0, l = data.length; i < l; i++) {
                                    var d = data[i];
                                    var str = "<tr class=\"tr_default_background_color\" style=\"color:" + (d.BRANCH_SHOW == 0 || (d.FLAG != 1 && d.FLAG !=0) ? '#f00' : '#000') + "\" onclick=\"javascript:clickToSub('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this," + d.ZOOM + ")\" ><td style='width: 10%;text-align: center'>" + (i + 1) + "</td><td style='width: 22%;text-align: center'>" + d.LATN_NAME + "</td><td style='width: 48%' title=\"" + d.BRANCH_NAME + "\">" + (d.BRANCH_NAME.length > 7 ? d.BRANCH_NAME.substr(0, 7) + ".." : d.BRANCH_NAME) + d.GRID_NUM + "</td><td style='width: 20%;text-align: center'>" + d.BRANCH_TYPE_CHAR + "</td></tr>";
                                    $(".list_table").append(str);
                                    where_temp += "'" + d.UNION_ORG_CODE + "'";
                                    if (i < l - 1)
                                        where_temp += ",";
                                    if (sub_style_num[d.BRANCH_TYPE] == undefined)
                                        sub_style_num[d.BRANCH_TYPE] = 1;
                                    else
                                        sub_style_num[d.BRANCH_TYPE] += 1;
                                    sub_show_num += d.BRANCH_SHOW;
                                    sub_zoom_array[d.UNION_ORG_CODE] = d.ZOOM;
                                }
                                where_temp += ")";
                                /*$("#ta").next("div").html("<table higth=\"100%\" width=\"296px\" style=\"text-align:center;color:#000;height:100%;border-color:#CCC;table-layout: fixed;font-size: 0.8em\">"
                                 +"<tr style=\"border-top:1px solid #CCC;background-color: #E3E3E3;font-size: 14px;height: 32px;line-height: 32px\"><th style=\"font-weight:bold\">类型</th><th style=\"font-weight:bold\">总数</th><th style=\"font-weight:bold\">上图</th><th style=\"font-weight:bold\">未上图</th></tr>"
                                 +"<tr style=\"border-top:1px solid #CCC\"><td style=\"height: 28px;line-height:28px\">支局</td><td style=\"\">"+data1.COUNT1+"</td><td style=\"\">"+(data1.COUNT1-data1.COUNT4)+"</td><td><font color=\"red\">"+data1.COUNT4+"</font></td></tr>"
                                 +"<tr style=\"border-top:1px solid #CCC\"><td style=\"height: 28px;line-height: 28px\">网格</td><td style=\"\">"+data1.COUNT5+"</td><td style=\"\">"+(data1.COUNT5-data1.COUNT6)+"</td><td><font color=\"#ff0000\">"+data1.COUNT6+"</font></td></tr></table>");*/
                                //$("#ta").next("div").html("共"+data1.COUNT1+"个支局，未上图<font color=\"red\">"+data1.COUNT4+"</font>个");
                                $("#tacount1").html(data1.COUNT1);
                                $("#tacount2").html(data1.COUNT4);
                                //featureLayer.setDefinitionExpression("MAPID = " + map_id + " AND " + where_temp);

                                //featureLayer.setRenderer(renderer);

                                /*featureLayer.on("graphic-add", function (evt) {
                                    var sub_gra_init = evt.graphic;
                                    var sub_attr = sub_gra_init.attributes;
                                    sub_graphics_init[sub_attr.SUBSTATION_NO] = sub_gra_init;
                                });*/
                            });
                        });
                    }

                    //var layer = new esri.layers.ArcGISDynamicMapServiceLayer(standard_address);
                    //map.addLayer(layer);

                    //标准地址
                    var standard_layer = new GraphicsLayer();

                    village_position_layer = new GraphicsLayer();
                    //小区图层
                    village_layer = new GraphicsLayer();
                    //校园图层
                    school_GraphicsLayer = new GraphicsLayer();
                    school_GraphicsLayer_selected = new GraphicsLayer();

                    //商客
                    enterprise_GraphicsLayer = new GraphicsLayer();
                    enterprise_GraphicsLayer_selected = new GraphicsLayer();

                    //绘制层，对标准地址操作
                    draw_layer = new GraphicsLayer();

                    draw_layer.hide();
                    draw_layer.visible = false;

                    var draw_layer_mark_build = new GraphicsLayer();
                    draw_layer_mark_build.hide();
                    draw_layer_mark_build.visible = false;

                    var drawed_layer_mark_build = new GraphicsLayer();
                    drawed_layer_mark_build.hide();
                    drawed_layer_mark_build.visible = false;

                    var draw_finish = false;//绘制完成标记
                    var draw_points = "";//保存绘制的多边形的点集合
                    var draw_graphics_array_for_buildInVillage = "";//框选楼宇的时候，记录每次画的形状，供撤销的时候使用
                    var drawed_graphics_array_for_buildInVillage = "";//记录同一个网格下，其他小区的楼宇图形集合

                    //营销活动新建，移除功能中需要的临时变量
                    var yx_new_total_nums = "";
                    var yx_new_items = "";
                    var drawAddToMap = function (evt) {
                        var done = false;
                        var symbol;

                        if (draw_type != "leida" && draw_type != "village") {
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
                                    symbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, new Color(draw_line_color), 1);
                                    break;
                                default://封闭多边形
                                    if (draw_type != "polygon_village" && draw_type != "rectangle_village") {//不是添加小区的操作，可能是营销的操作
                                        done = true;
                                        toolbar.deactivate();
                                        map.setMapCursor("default");//绘制结束，还原鼠标
                                        $("#nav_marketing").removeClass("active");
                                        var temp = PolygonToWKT(evt.geometry);//营销操作保存图形
                                        $("#wktstr").val(temp);
                                    } else {
                                        addBuildToVillagePolygen(evt.geometry);//是添加小区中的框选或多边形功能
                                    }
                                    symbol = new SimpleFillSymbol().setColor(new dojo.Color(draw_fill_color));
                                    symbol.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(draw_line_color), draw_line_width));
                                    var graphic = new Graphic(evt.geometry, symbol);//将绘制的图形写到draw_layer层

                                    draw_layer.add(graphic);
                                    if (draw_type == "polygon_village" || draw_type == "rectangle_village") {
                                        //draw_graphics_array_for_buildInVillage.push(graphic);
                                        //buildInVillage_mode = "add";
                                        draw_layer.remove(graphic);
                                    }
                            }
                        }
                        else if (draw_type == "leida") {
                            toolbar.deactivate();
                            done = true;
                        }
                        //点选方式的小区上图功能，已废弃↓
                        else if (draw_type == "village") {
                            //toolbar.deactivate();
                            $("#village_info_mini_win").hide();
                            var size = standard_point_get_size(map.getZoom());//获取当前放大级别下，标准地址图标的大小
                            var img = new PictureMarkerSymbol(village_ico, size * 3, size * 3);
                            var pointAttributes = parent.villageObjectEdited;
                            var graphic = new esri.Graphic(evt.mapPoint, img, pointAttributes);
                            draw_layer.add(graphic);

                            //插入数据库
                            var village = parent.villageObjectEdited;
                            var question = "确定小区【" + village.name + "】上图？";
                            var eaction = "village_insert";
                            if (village.isOnMap == 1) {
                                eaction = "village_update";
                                question = "确定修改小区【" + village.name + "】到新的位置？";
                            }
                            layer.confirm(question, {
                                btn: ['确定', '取消'] //按钮
                            }, function () {
                                $.post(url4Query, {
                                    eaction: eaction,
                                    x: evt.mapPoint.x,
                                    y: evt.mapPoint.y,
                                    village_id: village.id,
                                    res_id: parent.global_report_to_id,
                                    grid_id: village.grid_id,
                                    sub_id: pointAttributes.sub_id,
                                    breau_id: pointAttributes.breau_id,
                                    city_id: pointAttributes.city_id
                                }, function () {
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

                                    village_load("RES_ID = '" + parent.global_report_to_id + "' AND STATUS = 1");
                                });
                            }, function () {
                                draw_layer.clear();
                            });
                        }
                        //点选方式的小区上图功能，已废弃↑
                        if (done) {
                            var queryTask = new QueryTask(standard_address);
                            var query = new Query();
                            //query.where = "LATN_ID = "+ city_id + " AND CLASS3_ID IN ("+ class3_str +")";
                            if (draw_type == "leida") {
                                query.geometry = draw_layer.graphics[0].geometry;
                                var temp = PolygonToWKT(query.geometry);
                                $("#wktstr").val(temp);
                            }
                            else
                                query.geometry = evt.geometry;
                            //console.log(query.geometry);
                            //console.log(query.geometry);
                            //console.log(query.geometry.toJson());
                            //console.log(PolygonToWKT(query.geometry));
                            if (draw_type == "leida") {
                                type_xy = '0';
                                x = query.geometry.center.x;
                                y = query.geometry.center.y;
                                radius = query.geometry.radius;
                            } else if (draw_type == "rectangle") {
                                type_xy = '1';
                                xmax = query.geometry.cache._extent.xmax;
                                xmin = query.geometry.cache._extent.xmin;
                                ymax = query.geometry.cache._extent.ymax;
                                ymin = query.geometry.cache._extent.ymin;
                            } else if (draw_type == "polygon") {
                                type_xy = '2';
                                draw_points = query.geometry.rings[0];
                            }

                            query.outFields = ["*"];
                            query.returnGeometry = true;
                            queryTask.execute(query, function (results) {
                                        toolbar.deactivate();//成功绘制并正常执行查询后，停用工具
                                        var features = results.features;
                                        if (features.length == 0) {
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
                                        var result_size = features.length;
                                        segmid_for_yx_save_array = new Array();
                                        segmid_for_yx_save = "(";
                                        /*yinming 2017年7月22日11:28:37 修改营销窗口*/
                                        for (var i = 0; i < result_size; i++) {
                                            var attrs = features[i].attributes;
                                            if (i != 0) {
                                                segmid_for_yx_save += ",";
                                            }
                                            segmid_for_yx_save += "'" + $.trim(attrs.RESID) + "'";
                                            segmid_for_yx_save_array[attrs.RESID] = 1;
                                        }
                                        segmid_for_yx_save += ")";
                                        //三个标签页的代码↓
                                        /*$("#yingxiao_new_win").children(".tab_menu").find("span").eq(0).click();
                                         $("#yingxiao_new_win").show();
                                         $("#yx_new_build_list").empty();
                                         $("#yx_new_yx_list").empty();
                                         build_new_total_nums = "";
                                         yx_new_items = new Array();

                                         $("#segmid_for_yx_save_hide").val(segmid_for_yx_save);
                                         freshYX_new_build_list(segmid_for_yx_save);
                                         freshYX_new_yx_list(segmid_for_yx_save);


                                         if (yx_new_total_nums["BUILD_COUNT"] == 0) {
                                         $("#yingxiao_baocun").hide();
                                         }
                                         else
                                         $("#yingxiao_baocun").show();*/
                                        //三个标签页的代码↑

                                        //合并后的样式的代码↓
                                        $("#yx_new_four_address_list").empty();
                                        $("#yingxiao_new_win").show();
                                        yx_new_total_nums = "";
                                        yx_new_items = new Array();
                                        freshYX_new_buildyx_list(segmid_for_yx_save);
                                    },
                                    function (error) {
                                        layer.msg("图形不合法，无法分析结果");
                                    }
                            );
                        }
                    }

                    function freshYX_new_buildyx_list(segmid_for_yx_save, segm_name_for_search) {
                        $("#yx_new_four_address_list").empty();
                        $.post(url4Query, {
                            "eaction": "yingxiao_new_add4_list",
                            "segmid": segmid_for_yx_save,
                            "segm_name": segm_name_for_search
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data.length == 1) {//只有合计，表示没有查询到数据
                                layer.msg("暂无所选楼宇相关信息");
                                return;
                            }
                            yx_new_total_nums = data[0];

                            $("#yx_new_creator").text('${username.val}');

                            $("#yx_new_yd_sum").text(yx_new_total_nums.YD_COUNT);
                            $("#yx_new_kd_sum").text(yx_new_total_nums.KD_COUNT);
                            $("#yx_new_ds_sum").text(yx_new_total_nums.ITV_COUNT);
                            $("#yx_new_zhu_hu_shu").text(yx_new_total_nums.ZHU_HU_COUNT);
                            yx_new_total_nums["BUILD_COUNT"] = data.length - 1;
                            $("#yx_new_build_record_count").text(yx_new_total_nums["BUILD_COUNT"]);
                            $("#yx_new_builds_total").text(yx_new_total_nums["BUILD_COUNT"]);
                            $("#yx_new_port_used_rate").text(yx_new_total_nums.PORT_LV);
                            $("#yx_new_port_total").text(yx_new_total_nums.RES_ID_COUNT);
                            $("#yx_new_port_free").text(yx_new_total_nums.SY_RES_COUNT);

                            for (var i = 0, l = data.length; i < l; i++) {
                                var d = data[i];
                                yx_new_items[d.SEGM_ID] = d;
                                var newRow = "<tr>";
                                if (d.SEGM_ID == 0)
                                    newRow += "<td></td>";
                                else
                                    newRow += "<td class=\"sort_yx_new\">" + i + "</td>";

                                if (d.SEGM_ID != 0)
                                //newRow += "<td><a href=\"javascript:void(0);\" onclick=\"funshow2('"+d.SEGM_ID+"');\" >"+d.SEGM_NAME+"</a></td>";
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"showBuildDetail('" + d.SEGM_ID + "','" + d.SEGM_NAME + "','all',0,0);\"  >" + d.SEGM_NAME + "</a></td>";
                                else
                                    newRow += "<td>" + d.SEGM_NAME + "</td>";

                                //if(d.ZHU_HU_COUNT>0 && d.SEGM_ID!=0)
                                if (d.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"showBuildDetail('" + d.SEGM_ID + "','" + d.SEGM_NAME + "','all',0,0);\"  >" + d.ZHU_HU_COUNT + "</a></td>";
                                else
                                    newRow += "<td>" + d.ZHU_HU_COUNT + "</td>";
                                //else
                                //	newRow += "<td>"+d.ZHU_HU_COUNT+"</td>";
                                //newRow += "<td>"+d.ZHU_HU_COUNT+"</td>";
                                newRow += "<td>" + d.RES_ID_COUNT + "</td>";
                                newRow += "<td>" + d.SY_RES_COUNT + "</td>";

                                newRow += "<td>" + d.KD_COUNT + "</td>";
                                newRow += "<td>" + d.ITV_COUNT + "</td>";
                                newRow += "<td>" + d.GU_COUNT + "</td>";

                                if (d.YX_ALL > 0 && d.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"javascript:showBuildDetail('" + d.SEGM_ID + "','" + d.STAND_NAME + "','all',4,0)\" >" + d.YX_ALL + "</a></td>";
                                else
                                    newRow += "<td>" + d.YX_ALL + "</td>";

                                newRow += "<td>" + d.YX_UN + "</td>";
                                newRow += "<td>" + d.YX_LV + "%</td>";

                                /*if(d.SEGM_ID==0)
                                 newRow += "<td></td>";
                                 else {
                                 newRow += "<td><a href=\"javascript:void(0);\" class=\"remove_item_yx_new\"  ";
                                 newRow += "value=\""+d.SEGM_ID+"\" >移除</a>";
                                 }*/

                                newRow += "</tr>";
                                $("#yx_new_four_address_list").append(newRow);
                            }
                            $("#yingxiao_new_win").show();
                            /*if (yx_new_total_nums["BUILD_COUNT"] == 0) {
                             $("#yingxiao_baocun").hide();
                             }
                             else
                             $("#yingxiao_baocun").show();*/

                            //合并后的样式的代码↑
                        });
                    }

                    //营销新建时刷新楼宇信息表和营销信息表 三个标签页中第三个标签
                    function freshYX_new_yx_list(segmid_for_yx_save, segm_name) {
                        $.post(url4Query, {
                            "eaction": "yingxiao_new_yx_list",
                            "segmid": segmid_for_yx_save,
                            "segm_name": segm_name
                        }, function (data) {
                            data = $.parseJSON(data);
                            $("#yx_new_yx_record_count").text(data.length - 1);
                            if (data.length == 1) {//只有合计，表示没有查询到数据
                                layer.msg("暂无所选楼宇营销信息");
                                return;
                            }
                            yx_new_total_nums = data[0];

                            for (var i = 0, l = data.length; i < l; i++) {
                                var d = data[i];
                                yx_new_items[d.SEGM_ID] = d;
                                var newRow = "<tr>";
                                if (d.SEGM_ID == 0)
                                    newRow += "<td></td>";
                                else
                                    newRow += "<td class=\"sort_yx_new\">" + i + "</td>";

                                if (d.YX_ALL > 0 && d.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"funshow2('" + d.SEGM_ID + "')\" >" + d.SEGM_NAME + "</a></td>";
                                else
                                    newRow += "<td>" + d.SEGM_NAME + "</td>";

                                if (d.YX_ALL > 0 && d.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"funshow2('" + d.SEGM_ID + "')\" >" + d.YX_ALL + "</a></td>";
                                else
                                    newRow += "<td>" + d.YX_ALL + "</td>";

                                newRow += "<td>" + d.YX_DONE + "</td>";
                                newRow += "<td>" + d.YX_UN + "</td>";
                                newRow += "<td>" + d.YX_LV + "%</td>";
                                /*if(d.SEGM_ID==0)
                                 newRow += "<td></td>";
                                 else {
                                 newRow += "<td><a href=\"javascript:void(0);\" class=\"remove_item_yx_new\"  ";
                                 newRow += "value=\""+d.SEGM_ID+"\" >移除</a>";
                                 }*/

                                newRow += "</tr>";
                                $("#yx_new_yx_list").append(newRow);
                            }
                        });
                    }

                    //三个标签页中的第二个标签页
                    function freshYX_new_build_list(segmid_for_yx_save, segm_name) {
                        $.post(url4Query, {
                            "eaction": "yingxiao_new_build_list",
                            "segmid": segmid_for_yx_save,
                            "segm_name": segm_name
                        }, function (data) {
                            data = $.parseJSON(data);
                            $("#yx_new_build_record_count").text(data.length - 1);
                            if (data.length == 1) {//只有合计，表示没有查询到数据
                                layer.msg("暂无所选楼宇相关信息");

                                return;
                            }
                            build_new_total_nums = data[0];

                            $("#yx_new_yd_sum").text(build_new_total_nums.YD_COUNT);
                            $("#yx_new_kd_sum").text(build_new_total_nums.KD_COUNT);
                            $("#yx_new_ds_sum").text(build_new_total_nums.ITV_COUNT);
                            $("#yx_new_market_lv").text(build_new_total_nums.MARKET_LV + "%");
                            $("#yx_new_zhu_hu_shu").text(build_new_total_nums.ZHU_HU_COUNT);
                            build_new_total_nums["BUILD_COUNT"] = data.length - 1;
                            $("#yx_new_builds_total").text(build_new_total_nums["BUILD_COUNT"]);
                            $("#yx_new_port_used_rate").text(build_new_total_nums.PORT_LV);
                            $("#yx_new_port_total").text(build_new_total_nums.RES_ID_COUNT);
                            $("#yx_new_port_free").text(build_new_total_nums.SY_RES_COUNT);
                            $("#yx_new_port_used").text(build_new_total_nums.RES_ID_COUNT - build_new_total_nums.SY_RES_COUNT);

                            for (var i = 0, l = data.length; i < l; i++) {
                                var d = data[i];
                                yx_new_items[d.SEGM_ID] = d;
                                var newRow = "<tr>";
                                if (d.SEGM_ID == 0)
                                    newRow += "<td></td>";
                                else
                                    newRow += "<td class=\"sort_yx_new\">" + i + "</td>";

                                if (d.SEGM_ID != 0)
                                    newRow += "<td><a href=\"javascript:void(0);\" onclick=\"showBuildDetail('" + d.SEGM_ID + "','" + d.SEGM_NAME + "','all',0,0)\" >" + d.SEGM_NAME + "</a></td>";
                                else
                                    newRow += "<td>" + d.SEGM_NAME + "</td>";

                                newRow += "<td>" + d.ZHU_HU_COUNT + "</td>";
                                newRow += "<td>" + d.RES_ID_COUNT + "</td>";
                                newRow += "<td>" + d.SY_RES_COUNT + "</td>";

                                newRow += "<td>" + d.KD_COUNT + "</td>";
                                newRow += "<td>" + d.ITV_COUNT + "</td>";
                                newRow += "<td>" + d.GU_COUNT + "</td>";

                                /*if(d.SEGM_ID==0)
                                 newRow += "<td></td>";
                                 else {
                                 newRow += "<td><a href=\"javascript:void(0);\" class=\"remove_item_yx_new\"  ";
                                 newRow += "value=\""+d.SEGM_ID+"\" >移除</a>";
                                 }*/

                                newRow += "</tr>";
                                $("#yx_new_build_list").append(newRow);
                            }
                        });
                    }

                    //移除按钮的响应处理↓
                    $(".remove_item_yx_new").unbind();
                    $(".remove_item_yx_new").live("click", function (thiz) {
                        layer.confirm('您确定移除该条记录？', {
                                    btn: ['确定', '取消'] //按钮
                                }, function (index) {
                                    //重新计算移除后的总计各项数据
                                    var segm_id = $(thiz.target).attr("value");
                                    delete segmid_for_yx_save_array[segm_id];
                                    var itemForRemove = yx_new_items[segm_id];
                                    yx_new_total_nums["YD_COUNT"] = yx_new_total_nums["YD_COUNT"] - itemForRemove["YD_COUNT"];
                                    yx_new_total_nums["KD_COUNT"] = yx_new_total_nums["KD_COUNT"] - itemForRemove["KD_COUNT"];
                                    yx_new_total_nums["ITV_COUNT"] = yx_new_total_nums["ITV_COUNT"] - itemForRemove["ITV_COUNT"];
                                    yx_new_total_nums["GU_COUNT"] = yx_new_total_nums["GU_COUNT"] - itemForRemove["GU_COUNT"];

                                    yx_new_total_nums["ZHU_HU_COUNT"] = yx_new_total_nums["ZHU_HU_COUNT"] - itemForRemove["ZHU_HU_COUNT"];
                                    yx_new_total_nums["BUILD_COUNT"] = yx_new_total_nums["BUILD_COUNT"] - 1;

                                    yx_new_total_nums["RES_ID_COUNT"] = yx_new_total_nums["RES_ID_COUNT"] - itemForRemove["RES_ID_COUNT"];
                                    yx_new_total_nums["SY_RES_COUNT"] = yx_new_total_nums["SY_RES_COUNT"] - itemForRemove["SY_RES_COUNT"];
                                    if (yx_new_total_nums["RES_ID_COUNT"] == 0)
                                        yx_new_total_nums["PORT_LV"] = 0;
                                    else
                                        yx_new_total_nums["PORT_LV"] = (((yx_new_total_nums["RES_ID_COUNT"] - yx_new_total_nums["SY_RES_COUNT"]) / yx_new_total_nums["RES_ID_COUNT"]) * 100).toFixed(2);

                                    yx_new_total_nums["YX_ALL"] = yx_new_total_nums["YX_ALL"] - itemForRemove["YX_ALL"];

                                    delete yx_new_items[segm_id];
                                    $(thiz.target).parent().parent().remove();
                                    //更新统计信息中各项内容
                                    $("#yx_new_yd_sum").text(yx_new_total_nums.YD_COUNT);
                                    $("#yx_new_kd_sum").text(yx_new_total_nums.KD_COUNT);
                                    $("#yx_new_ds_sum").text(yx_new_total_nums.ITV_COUNT);
                                    $("#yx_new_zhu_hu_shu").text(yx_new_total_nums.ZHU_HU_COUNT);
                                    $("#yx_new_builds_total").text(yx_new_total_nums["BUILD_COUNT"]);
                                    //$("#yx_new_port_used_rate").text(yx_new_total_nums.PORT_LV);
                                    //$("#yx_new_port_total").text(yx_new_total_nums.RES_ID_COUNT);
                                    //$("#yx_new_port_free").text(yx_new_total_nums.SY_RES_COUNT);
                                    //更新表格中第一行合计
                                    var sumRow = " <tr><td></td><td>合计</td>" +
                                            "<td>" + yx_new_total_nums["ZHU_HU_COUNT"] + "</td>" +
                                            "<td>--</td>" +
                                            "<td>--</td>" +
                                            "<td>" + yx_new_total_nums["KD_COUNT"] + "</td>" +
                                            "<td>" + yx_new_total_nums["ITV_COUNT"] + "</td>" +
                                            "<td>" + yx_new_total_nums["GU_COUNT"] + "</td>" +
                                            "<td>" + yx_new_total_nums["YX_ALL"] + "</td>" +
                                            "</tr>";
                                    $("#yx_new_four_address_list").find("tr:eq(0)").remove();
                                    $("#yx_new_four_address_list").prepend(sumRow);
                                    //更新表格中序号
                                    var sort_td_ele = $("#yx_new_four_address_list").find(".sort_yx_new");
                                    for (var i = 1, l = yx_new_total_nums["BUILD_COUNT"]; i <= l; i++) {
                                        $(sort_td_ele[i - 1]).text(i);
                                    }

                                    //是否在表格为空时隐藏保存按钮
                                    if (yx_new_total_nums["BUILD_COUNT"] == 0) {
                                        $("#yingxiao_baocun").hide();
                                    }
                                    else
                                        $("#yingxiao_baocun").show();
                                    layer.close(index);
                                }, function (index) {
                                    layer.close(index);
                                }
                        );
                    });


                    var buildInVillage = "";//记录在将要新建小区中的楼宇集合的信息，最后是保存依据
                    var buildInVillage_short = "";
                    var draw_build_result_array_for_buildVillage = "";//记录每次框选楼宇后的框选结果，供撤销的时候用
                    function addBuildToVillagePolygen(geo, where) {
                        var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        if(standard_where!="")
                        		query_standard.where = standard_where;
                        query_standard.geometry = geo;
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0)
                                return;
                            var current_zoom = map.getZoom();
                            var size = standard_point_get_size(current_zoom);//获取当前放大级别下，楼宇图标的大小
                            var build_ids_temp = new Array();
                            for (var i = 0, l = results.features.length; i < l; i++) {
                                var feature = results.features[i];
                                //var geo = feature.geometry;

                                if (buildInVillage[feature.attributes.RESID] != undefined)//框选的内容已经存在于记录的数组中，则返回什么都不做，否则标记选择的点
                                    continue;

                                //框选的内容是其他小区使用过的楼宇
                                if (drawed_graphics_array_for_buildInVillage[feature.attributes.RESID] != undefined)
                                    continue;

                                buildInVillage[feature.attributes.RESID] = feature.attributes.RESFULLNAME;
                                buildInVillage_short[feature.attributes.RESID] = feature.attributes.RESNAME;
                                build_ids_temp.push(feature.attributes.RESID);
                                //var pointAttributes = {RESNAME :feature.attributes.RESNAME ,RESFULLNAME:feature.attributes.RESFULLNAME,RESID:feature.attributes.RESID};
                                //var img = new PictureMarkerSymbol(standard_ico, size, size);
                                //var graphic = new esri.Graphic(geo,img,pointAttributes);
                                //var symbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, size, new SimpleLineSymbol(), new Color([210,210,0]));
                                //var graphic = new esri.Graphic(geo,symbol,pointAttributes);
                                //standard_layer.add(graphic);
                                //var build_gra=new Graphic(feature.geometry,point_selected_mark);

                                var size = standard_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
                                var img = new PictureMarkerSymbol(standard_ico_selected, size, size);
                                var build_gra = new esri.Graphic(feature.geometry, img, feature.attributes);
                                draw_layer_mark_build.add(build_gra);
                                //draw_graphics_array_for_buildInVillage[feature.attributes.RESID] = build_gra;
                            }
                            //map.addLayer(draw_layer_mark_build);
                            draw_build_result_array_for_buildVillage.push(build_ids_temp);
                            //if (buildInVillage_mode != "") {
                            //    map.centerAndZoom(graphicsUtils.graphicsExtent(results.features).getCenter(), 9);
                            //}
                        });
                    }

                    draw_layer_mark_build.on("graphic-add", function (evt) {
                        var gra = evt.graphic;
                        draw_graphics_array_for_buildInVillage[evt.graphic.attributes.RESID] = gra;
                    });
                    drawed_layer_mark_build.on("graphic-add", function (evt) {
                        var gra = evt.graphic;
                        drawed_graphics_array_for_buildInVillage[evt.graphic.attributes.RESID] = gra;
                    });

                    /*yinming 2017年7月22日15:53:42 营销保存按按钮*/

                    $("#cancelYXnew").unbind();
                    $("#cancelYXnew").click(function () {
                        $("#yingxiao_info_win").hide();
                    });
                    $("#yingxiao_baocun").unbind();
                    $("#yingxiao_baocun").click(function () {
                        var name = $.trim($("#yx_new_yx_name").val());
                        if (name.length == 0) {
                            layer.msg("请输入营销名称");
                        } else if (name.length < 16) {
                            if (draw_points != "") {
                                var draw_points_temp = "'";
                                for (var i = 0, l = draw_points.length - 1; i < l; i++) {
                                    var p = draw_points[i];
                                    draw_points_temp += p[0] + "," + p[1];
                                    if (i < l - 1)
                                        draw_points_temp += ";";
                                }
                                draw_points = draw_points_temp + "'";
                            }
                            var wktvalue = $("#wktstr").val();
                            var segm_ids_array = Object.keys(segmid_for_yx_save_array);
                            if (segm_ids_array.length == 0) {
                                layer.msg("没有选择任何楼宇，不能保存");
                                return;
                            }
                            var segmid_for_yx_save = "(";
                            /*yinming 2017年7月22日11:28:37 修改营销窗口*/
                            for (var i = 0; i < segm_ids_array.length; i++) {
                                if (i != 0) {
                                    segmid_for_yx_save += ",";
                                }
                                var id = segm_ids_array[i];
                                segmid_for_yx_save += "'" + id + "'";
                            }
                            segmid_for_yx_save += ")";
                            $.post(url4Query, {
                                eaction: "yingxiao_add_1",
                                wktstr: wktvalue,
                                name: name,
                                segmid: segmid_for_yx_save,
                                type_xy: type_xy,
                                x: x,
                                y: y,
                                radius: radius,
                                xmax: xmax,
                                xmin: xmin,
                                ymax: ymax,
                                ymin: ymin,
                                points: draw_points
                            }, function (data) {
                                $('#yingxiao_info_win').hide();
                                $('#yingxiao_info_win_new').hide();
                                layer.msg("保存成功");
                                $("#yx_new_yx_name").val("");
                            })
                        } else {
                            layer.msg("请输入15个字以内的名称");
                        }

                    })
                    function clearDrawLayer() {
                        draw_layer.clear();
                        draw_layer.hide();
                        draw_layer.visible = false;
                    }

						        featureLayer_grid = new FeatureLayer(new_url_sub_vaild + grid_layer_index,{
		                     definitionExpression : "branch_type = 'a1'",
		                     mode: FeatureLayer.MODE_SNAPSHOT,
		                     //mode: FeatureLayer.MODE_ONDEMAND,
		                     outFields: ["*"],
		                     visible:true,
		                     opacity:1
		                });

		                var grid_center_map = new Array();
		                //网格图层加载 begin
                    featureLayer_grid.on("graphic-add",function(evt){
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
	                     var grid_geo_attr = new Array();
	                     grid_geo_attr["grid_geo"] = geo;
	                     grid_geo_attr["grid_attr"] = grid_attr;
	                     grid_geo_attr["grid_fill_gra"] = grid_gra;
	                     labelGraphic.setAttributes(grid_geo_attr);
	                     grid_name_temp_layer.add(labelGraphic);

											if(grid_id_map[grid_attr.REPORT_TO_ID]!=undefined)
	                     	grid_center_map[grid_id_map[grid_attr.REPORT_TO_ID]] = "["+name_point.getLongitude()+","+name_point.getLatitude()+"]";
                     });

                     featureLayer_grid.on("update-end",function(){
                     	var keys = Object.keys(grid_center_map);
                     	for(var i = 0,l = keys.length;i<l;i++){
                     		var k = keys[i];
                     		//console.log( "'"+k+"'	:"+grid_center_map[k]+",");
                     	}
                     });

                     //var defaultSymbol_grid = new SimpleFillSymbol().setStyle(SimpleFillSymbol.STYLE_NULL).setOutline(new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new Color([128,128,128]), 1.5));
                     //var renderer_grid = new SimpleRenderer(defaultSymbol_grid);
                     //featureLayer_grid.setRenderer(renderer_grid);

                    var font = new esri.symbol.Font("12px", esri.symbol.Font.WEIGHT_NORMAL, esri.symbol.Font.WEIGHT_NORMAL, esri.symbol.Font.WEIGHT_NORMAL);
                    font.setFamily("微软雅黑");

                    var tmp = '1';
                    var tmp2 = '1';
                    var tmpx = '1';
                    var tmpl = '1';
                    var tmpy = '1';
                    var tmpy_v = '1';
                    var tmp_query = "1";
                    var tmp_info_collect = "1";
                    var left_list_type_selected = parent.left_list_type_selected;
                    if (left_list_type_selected != "" && left_list_type_selected != undefined) {
                        if (left_list_type_selected == "sub") {
                            tmp = "0";
                            $("#nav_list").click();
                        }

                        else if (left_list_type_selected == "grid") {
                            tmp2 = "0";
                            $("#nav_grid").click();
                        }

                        else if (left_list_type_selected == "village") {
                            tmpx = "0";
                            $("#nav_village").click();
                        }
                        else if (left_list_type_selected == "village_yx") {
                            tmpy_v = "0";
                            $("#nav_marketing_village").click();
                        }
                        else if (left_list_type_selected == "build") {
                            tmpl = "0";
                            $("#nav_standard").click();
                        }
                        left_list_type_selected = "";
                        parent.left_list_type_selected = "";
                    }
                    /*yinming 2017年7月22日15:53:42 营销保存按按钮 end*/

                    var toolbar;//工具栏，放置绘图工具

                    //支局名称层
                    graLayer_zjname = new GraphicsLayer();



                     map.addLayer(featureLayer_grid);
                     if(featureLayer_grid!="")
                     featureLayer_grid.hide();

										//网格图层加载 end

                    //图层加载顺序
                    //map.addLayer(featureLayer);

                    map.on("click", function (evt) {
                        console.log(evt);
                    });

                    //鼠标悬浮到支局，突出显示鼠标下的支局
                    graLayer_sub_mouseover = new GraphicsLayer();
                    map.addLayer(graLayer_sub_mouseover);

                    //勾选所有区县轮廓的层
                    graLayer_qx_all = new GraphicsLayer();
                    //map.addLayer(graLayer_qx_all);

                    //勾选选定的区县边框
                    graLayer_qx = new GraphicsLayer();
                    //map.addLayer(graLayer_qx);

                    //支局选中边框层
                    map.addLayer(graLayer_zj_click);

                    //鼠标点击支局，突出显示支局渔网背景
                    graLayer_mouseclick = new GraphicsLayer();
                    map.addLayer(graLayer_mouseclick);

                    //graLayer_mouseclick.setOpacity(0.25);

                    graLayer_subname_result = new GraphicsLayer();
                    map.addLayer(graLayer_subname_result);

                    //网格填充层
                    graLayer_wg = new GraphicsLayer();
                    map.addLayer(graLayer_wg);
                    graLayer_wg.hide();

                    //绘制小区的时候，网格的参考范围
                    graLayer_wg_for_village = new GraphicsLayer();
                    map.addLayer(graLayer_wg_for_village);

                    //网格层鼠标悬浮层
                    graLayer_grid_mouseover = new GraphicsLayer();
                    map.addLayer(graLayer_grid_mouseover);
                    //网格名称层
                    graLayer_wg_text = new GraphicsLayer();
                    map.addLayer(graLayer_wg_text);
                    graLayer_wg_text.hide();

                    //楼宇被选中的标记层
                    position_layer = new GraphicsLayer();
                    map.addLayer(position_layer);

                    map.addLayer(standard_layer);
                    map.addLayer(draw_layer);
                    map.addLayer(drawed_layer_mark_build);
                    map.addLayer(draw_layer_mark_build);

                    //小区图标层
                    map.addLayer(village_layer);
                    //小区被选中的标记层
                    //map.addLayer(village_position_layer);

                    //渠道网点展示
                    graLayer_wd = new GraphicsLayer();
                    graLayer_wd.hide();

                    map.addLayer(graLayer_zjname);
                    map.addLayer(graLayer_wd);//网点图层位于支局名称图层之上

                    //支局的鼠标点击层
                    graLayer_zj_click = new GraphicsLayer();
                    map.addLayer(graLayer_zj_click);
                    //网格的鼠标点击层
                    graLayer_wg_click = new GraphicsLayer();
                    map.addLayer(graLayer_wg_click);

                    grid_name_temp_layer = new GraphicsLayer();
                    map.addLayer(grid_name_temp_layer);
                    grid_name_temp_layer.hide();

                    //20180316小区服务
                    village_service_load = function(){
                    		village_gras_array = new Array();
                    		ids_str_array = new Array();
                    		if (village_service_feature_layer == ""){
                    			village_service_feature_layer = new FeatureLayer(village_service_url+"/0", {

                                outFields: '*',
                                showAttribution: false
                            });
                            village_service_layer_click_handler = dojo.connect(village_service_feature_layer, "onClick", function (evt) {
			                     		village_click_event(evt);
			                     });
			                     village_service_layer_mouseover_handler = dojo.connect(village_service_feature_layer, "onMouseOver", function (evt) {
			                     		map.setMapCursor("pointer");
			                     		$("#village_info_mini_win").html(evt.graphic.attributes.VILLAGE_NAME);
                            	$("#village_info_mini_win").css({top: evt.pageY + 10, left: evt.pageX + 10});
                            	$("#village_info_mini_win").show();
			                     });
			                     village_service_layer_mouseout_handler = dojo.connect(village_service_feature_layer, "onMouseOut", function (evt) {
			                     		map.setMapCursor("default");
			                     		$("#village_info_mini_win").hide();
			                     });
                    		}

                        if (village_service_feature_layer1 == ""){
                        	village_service_feature_layer1 = new FeatureLayer(village_service_url+"/1", {
                                outFields: '*',
                                showAttribution: false
                            });
                            village_service_layer_click_handler1 = dojo.connect(village_service_feature_layer1, "onClick", function (evt) {
                     		     village_click_event(evt);
                            });
                            village_service_layer_mouseover_handler1 = dojo.connect(village_service_feature_layer1, "onMouseOver", function (evt) {
			                     		map.setMapCursor("pointer");
			                     		$("#village_info_mini_win").html(evt.graphic.attributes.VILLAGE_NAME);
                            	$("#village_info_mini_win").css({top: evt.pageY + 10, left: evt.pageX + 10});
                            	$("#village_info_mini_win").show();
			                     });
                            village_service_layer_mouseout_handler1 = dojo.connect(village_service_feature_layer1, "onMouseOut", function (evt) {
			                     		map.setMapCursor("default");
			                     		$("#village_info_mini_win").hide();
			                     });
                        }

                        if (village_service_feature_layer2 == ""){
                        	village_service_feature_layer2 = new FeatureLayer(village_service_url+"/2", {
                                outFields: '*',
                                showAttribution: false
                            });
                            village_service_layer_click_handler2 = dojo.connect(village_service_feature_layer2, "onClick", function (evt) {
                     		      village_click_event(evt);
                            });
                            village_service_layer_mouseover_handler2 = dojo.connect(village_service_feature_layer2, "onMouseOver", function (evt) {
			                     		map.setMapCursor("pointer");
			                     		$("#village_info_mini_win").html(evt.graphic.attributes.VILLAGE_NAME);
                            	$("#village_info_mini_win").css({top: evt.pageY + 10, left: evt.pageX + 10});
                            	$("#village_info_mini_win").show();
			                     });
                            village_service_layer_mouseout_handler2 = dojo.connect(village_service_feature_layer2, "onMouseOut", function (evt) {
			                     		map.setMapCursor("default");
			                     		$("#village_info_mini_win").hide();
			                     });
                        }


                        village_service_feature_layer.setDefinitionExpression(village_where);
                        village_service_feature_layer1.setDefinitionExpression(village_where);
                        village_service_feature_layer2.setDefinitionExpression(village_where);
                        map.addLayer(village_service_feature_layer);
                        map.addLayer(village_service_feature_layer1);
                        map.addLayer(village_service_feature_layer2);
                        map.addLayer(village_position_layer);
                        return;
                    }

                    school_service_load = function(){
                    	school_GraphicsLayer.clear();
                      school_GraphicsLayer_selected.clear();
                      draw_layer_mark_build.clear();
                      drawed_layer_mark_build.clear();
                      //map.removeLayer(school_layer);
                      //map.removeLayer(school_position_layer);
                      //school_id_array = new Array();
                      drawed_graphics_array_for_buildInVillage = new Array();

                      village_gras_array = new Array();
                      ids_str_array = new Array();
                      $.post(url4Query_enterprise, {eaction: "getSchoolByCityId", city_id: city_id}, function (data) {
                          var data1 = $.parseJSON(data);

                          if (data1 != null) {
                              for (var j = 0, k = data1.length; j < k; j++) {
                                  var d1 = data1[j];
                                  var s_id = d1.SID;
                                  //小区的图标展现
                                  var ico_url = school_ico;
																	var size = village_ico_get_size(map.getZoom());
																	var school_img = new PictureMarkerSymbol(ico_url, size, size);
																	var school_graphic = "";
																	var point_str = d1.V_POSITION;
																	var point_array = point_str.split(",");
																	school_graphic = new esri.Graphic(new Point(parseFloat(point_array[0]), parseFloat(point_array[1]), new SpatialReference({wkid: 4326})), school_img, {"school_id": s_id,"school_name":d1.BUSINESS_NAME});
																	school_GraphicsLayer.add(school_graphic);//绘制新的小区位置
                              }
                          } else {
                              //layer.msg("该支局下没有小区信息");
                          }
                          map.addLayer(school_GraphicsLayer);
                          map.addLayer(school_GraphicsLayer_selected);
                      });
                    }

                    enterprise_service_load = function(){
                    	if(enterprise_GraphicsLayer!="")
                    		enterprise_GraphicsLayer.clear();
                    	else
                    		enterprise_GraphicsLayer = new GraphicsLayer();
                      enterprise_GraphicsLayer_selected.clear();
                      draw_layer_mark_build.clear();
                      drawed_layer_mark_build.clear();
                      //map.removeLayer(enterprise_layer);
                      //map.removeLayer(enterprise_position_layer);
                      //enterprise_id_array = new Array();
                      drawed_graphics_array_for_buildInVillage = new Array();

                      village_gras_array = new Array();
                      ids_str_array = new Array();
                      $.post(url4Query_enterprise, {eaction: "getEnterpriseByCityId", city_id: city_id}, function (data) {
                          var data1 = $.parseJSON(data);

                          if (data1 != null) {
                              for (var j = 0, k = data1.length; j < k; j++) {
                                  var d1 = data1[j];
                                  var s_id = d1.SID;
                                  //小区的图标展现
                                  var ico_url = enterprise_ico;
																	var size = village_ico_get_size(map.getZoom());
																	var enterprise_img = new PictureMarkerSymbol(ico_url, size, size);
																	var enterprise_graphic = "";
																	var point_str = d1.V_POSITION;
																	var point_array = point_str.split(",");
																	enterprise_graphic = new esri.Graphic(new Point(parseFloat(point_array[0]), parseFloat(point_array[1]), new SpatialReference({wkid: 4326})), enterprise_img, {"enterprise_id": s_id,"enterprise_name":d1.BUSINESS_NAME});
																	enterprise_GraphicsLayer.add(enterprise_graphic);//绘制新的小区位置
                              }
                          } else {
                              //layer.msg("该支局下没有小区信息");
                          }
                          map.addLayer(enterprise_GraphicsLayer);
                          map.addLayer(enterprise_GraphicsLayer_selected);
                      });
                    }

                    //加载三个服务层
                    village_service_load();
                    school_service_load();
                    enterprise_service_load();

                    var village_gras_array = new Array();
                     var village_service_layer_click_handler = "";
                     var village_service_layer_click_handler1 = "";
                     var village_service_layer_click_handler2 = "";
                     var village_service_layer_mouseover_handler = "";
                     var village_service_layer_mouseover_handler1 = "";
                     var village_service_layer_mouseover_handler2 = "";
                     var village_service_layer_mouseout_handler = "";
                     var village_service_layer_mouseout_handler1 = "";
                     var village_service_layer_mouseout_handler2 = "";

                     function village_click_event(evt){
                     	 layer.closeAll();
	                     var village_Id = evt.graphic.attributes.VILLAGE_ID;
	                     village_gras_array[village_Id] = evt.graphic;
	                     operateVillage(village_Id);
	                     var pointAttributes = {"village_id": village_Id};

	                     //var graphic_position = new Graphic(evt.graphic.geometry, point_selected_mark);
                       village_position_layer.clear();
                        //village_position_layer.clear();
                       //village_position_layer.add(graphic_position);
	                     var ico_url1 = village_ico_selected;
	                     var size = village_ico_get_size(map.getZoom());
	                     village_selected_gra_update = evt.graphic;
	                     var img1 = new PictureMarkerSymbol(ico_url1, size, size);
	                     var graphic1 = new esri.Graphic(evt.graphic.geometry, img1, pointAttributes);
	                     village_position_layer.clear();
	                     village_position_layer.add(graphic1);
                     }

                     var village_selected_layer_mouse_over_handler = dojo.connect(village_position_layer, "onMouseOver", function (evt) {
	                     map.setMapCursor("pointer");
	                     village_mouse_over_when_draw_f(evt);
                     });
                     var village_selected_layer_mouse_out_handler = dojo.connect(village_position_layer, "onMouseOut", function (evt) {
	                     map.setMapCursor("default");
	                     village_mouse_out_when_draw_f(evt);
                     });
                     var village_selected_layer_click_handler = dojo.connect(village_position_layer, "onClick", function (evt) {
	                     tmpx = '1';
	                     $("#nav_village").removeClass("active");
	                     layer.closeAll();
	                     village_selected_gra_update = evt.graphic;
	                     operateVillage(evt.graphic.attributes.village_id);
                     });

                    //支局名称层添加每个名字
                    var addSubLabel = function (font_size, label_symbols) {
                        for (var i = 0, l = label_symbols.length; i < l; i++) {
                            var graphics = label_symbols[i];
                            var text = graphics.symbol.text;
                            var geometry = graphics.geometry;
                            var attr = graphics.attributes;
                            var font = new Font(font_size, Font.WEIGHT_BOLD, Font.WEIGHT_BOLD, Font.WEIGHT_BOLD, "Microsoft Yahei");
                            if (text.length > 7)
                                text = text.substr(0, 7) + " \n " + text.substr(7);
                            var textSymbol = new TextSymbol(text, font, new Color(sub_name_text_color));
                            var labelGraphic = new esri.Graphic(geometry, textSymbol);
                            labelGraphic.setAttributes(attr);
                            graLayer_zjname.add(labelGraphic);
                        }
                    }

                    //网格名称层添加每个名字
                    var addGridLabel = function (font_size, label_symbols) {
                        for (var i = 0, l = label_symbols.length; i < l; i++) {
                            var graphics = label_symbols[i];
                            font_size = fontSizeChange(map.getZoom());
                            try {
                                if (grid_gra_clicked.attributes.RESID == graphics.attributes.grid_attr.RESID) {
                                    font_size += 2;
                                }
                            } catch (e) {
                            }
                            var geometry = graphics.geometry;
                            var text = graphics.symbol.text;
                            var attr = graphics.attributes;
                            var font = new Font(font_size, Font.WEIGHT_BOLD, Font.WEIGHT_BOLD, Font.WEIGHT_BOLD, "Microsoft Yahei");
                            if (text.length > 5)
                                text = text.substr(0, 5) + " \n " + text.substr(5);
                            var textSymbol = new TextSymbol(text, font, new Color(grid_name_text_color));
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
                    var zj_name_show_hide = function (current_zoom) {
                        graLayer_zjname.clear();
                        if (current_zoom > 6) {
                            addSubLabel("15px", sub_name_label_symbol1);
                            addSubLabel("15px", sub_name_label_symbol2);
                            addSubLabel("15px", sub_name_label_symbol3);
                            addSubLabel("15px", sub_name_label_symbol4);
                            addSubLabel("15px", sub_name_label_symbol5);
                            addSubLabel("15px", sub_name_label_symbol6);
                            addSubLabel("15px", sub_name_label_symbol7);
                        } else if (current_zoom == 6) {
                            addSubLabel("14px", sub_name_label_symbol2);
                            addSubLabel("14px", sub_name_label_symbol3);
                            addSubLabel("14px", sub_name_label_symbol4);
                            addSubLabel("14px", sub_name_label_symbol5);
                            addSubLabel("14px", sub_name_label_symbol6);
                            addSubLabel("14px", sub_name_label_symbol7);
                        } else if (current_zoom == 4 || current_zoom == 5) {
                            addSubLabel("13px", sub_name_label_symbol3);
                            addSubLabel("13px", sub_name_label_symbol4);
                            addSubLabel("13px", sub_name_label_symbol5);
                            addSubLabel("13px", sub_name_label_symbol6);
                            addSubLabel("13px", sub_name_label_symbol7);
                        } else if (current_zoom == 3) {
                            addSubLabel("13px", sub_name_label_symbol4);
                            addSubLabel("13px", sub_name_label_symbol5);
                            addSubLabel("13px", sub_name_label_symbol6);
                            addSubLabel("13px", sub_name_label_symbol7);
                        } else if (current_zoom == 2) {
                            addSubLabel("10px", sub_name_label_symbol6);
                            addSubLabel("10px", sub_name_label_symbol7);
                        } else if (current_zoom == 1) {
                            addSubLabel("10px", sub_name_label_symbol7);
                        }
                    }
                    //网格名称层刷新
                    var wg_name_show_hide = function (current_zoom) {
                        graLayer_wg_text.clear();
                        if (current_zoom > 6) {
                            //if(true){
                            addGridLabel("15px", grid_name_label_symbol1);
                            addGridLabel("15px", grid_name_label_symbol2);
                            addGridLabel("15px", grid_name_label_symbol3);
                            addGridLabel("15px", grid_name_label_symbol4);
                            addGridLabel("15px", grid_name_label_symbol5);
                        } else if (current_zoom == 6) {
                            addGridLabel("14px", grid_name_label_symbol2);
                            addGridLabel("14px", grid_name_label_symbol3);
                            addGridLabel("14px", grid_name_label_symbol4);
                            addGridLabel("14px", grid_name_label_symbol5);
                        } else if (current_zoom == 4 || current_zoom == 5) {
                            addGridLabel("13px", grid_name_label_symbol3);
                            addGridLabel("13px", grid_name_label_symbol4);
                            addGridLabel("13px", grid_name_label_symbol5);
                        } else if (current_zoom == 3) {
                            addGridLabel("13px", grid_name_label_symbol4);
                            addGridLabel("13px", grid_name_label_symbol5);
                        } else if (current_zoom == 2) {
                            addGridLabel("10px", grid_name_label_symbol5);
                        } else if (current_zoom == 1) {
                            addGridLabel("10px", grid_name_label_symbol5);
                        }
                    }
                    //根据地图放大级别设置名称的字体大小
                    var fontSizeChange = function (current_zoom) {
                        var font_size = 0;
                        if (current_zoom > 6)
                            font_size = 15;
                        else if (current_zoom == 6)
                            font_size = 14;
                        else if (current_zoom == 4 || current_zoom == 5)
                            font_size = 13;
                        else if (current_zoom == 3)
                            font_size = 13;
                        else if (current_zoom == 2)
                            font_size = 10;
                        else if (current_zoom == 1)
                            font_size = 10;

                        return font_size;
                    };

                    //获取图形重心（中心点），用来添加名称到合适的位置
                    var getGravityCenter = function (polygon, temp) {
                        var ext = polygon.getExtent();
                        var p0 = new Point(ext.xmin, ext.ymin, new SpatialReference({wkid: 4326}));
                        var momentX = 0;
                        var momentY = 0;
                        var weight = 0;
                        for (var j = 0; j < temp.length; j++) {
                            var pts = temp[j];
                            for (var m = 0; m < pts.length; m++) {
                                var p1 = polygon.getPoint(j, m);
                                var p2;
                                if (m == pts.length - 1) {
                                    p2 = polygon.getPoint(j, 0);
                                } else {
                                    p2 = polygon.getPoint(j, m + 1);
                                }
                                var dWeight = (p1.x - p0.x) * (p2.y - p1.y) - (p1.x - p0.x) * (p0.y - p1.y) / 2 - (p2.x - p0.x) * (p2.y - p0.y) / 2 - (p1.x - p2.x) * (p2.y - p1.y) / 2;
                                weight += dWeight;
                                var pTmp = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2, new SpatialReference({wkid: 4326}));
                                var gravityX = p0.x + (pTmp.x - p0.x) * 2 / 3;
                                var gravityY = p0.y + (pTmp.y - p0.y) * 2 / 3;
                                momentX += gravityX * dWeight;
                                momentY += gravityY * dWeight;
                            }
                        }
                        var bbb = new Point(momentX / weight, momentY / weight, new SpatialReference({wkid: 4326}));
                        return bbb;
                    }

                    var getLayerOpacity = function (current_zoom) {
                        var opacity = 0;
                        if (current_zoom > 7)
                            opacity = 0.2;
                        else if (current_zoom > 6)
                            opacity = 0.4;
                        else if (current_zoom == 6 || current_zoom == 5)
                            opacity = 0.7;
                        else if (current_zoom < 5)
                            opacity = 1;
                        return opacity;
                    }
                    //根据地图放大缩小级别设定图层透明度
                    var layerOpacityChange = function (current_zoom) {
                        var opacity = 1;
                        if (opacitySpecial[city_id] != undefined) {
                            if (current_zoom >= 9) {
                                standard_load();
                                opacity = 0.0;
                            }
                            else if (current_zoom == 8)
                                opacity = 0.3;
                            else if (current_zoom == 7)
                                opacity = 0.7;
                            else if (current_zoom == 6)
                                opacity = 0.9;
                            else if (current_zoom == 5)
                                opacity = 0.9;
                            else if (current_zoom == 4)
                                opacity = 0.9;
                            else if (current_zoom == 3)
                                opacity = 0.9;
                            else if (current_zoom == 2)
                                opacity = 0.9;
                            else if (current_zoom == 1)
                                opacity = 1;
                        } else {
                            if (current_zoom >= 9) {
                                standard_load();
                                opacity = 0.0;
                            }
                            else if (current_zoom == 8)
                                opacity = 0.3;
                            else if (current_zoom == 7)
                                opacity = 0.4;
                            else if (current_zoom == 6)
                                opacity = 0.5;
                            else if (current_zoom == 5)
                                opacity = 0.6;
                            else if (current_zoom == 4)
                                opacity = 0.7;
                            else if (current_zoom == 3)
                                opacity = 0.8;
                            else if (current_zoom == 2)
                                opacity = 0.9;
                            else if (current_zoom == 1)
                                opacity = 1;
                        }

                        featureLayer.setOpacity(opacity);
                        graLayer_wg.setOpacity(opacity);
                        if(featureLayer_grid!="")
                        featureLayer_grid.setOpacity(opacity);
                    }

                    //渠道网点的图标大小控制
                    var channel_point_get_size = function (current_zoom) {
                        var size = 0
                        if (current_zoom > 6) {
                            size = 22;
                        } else if (current_zoom == 6) {
                            size = 20;
                        } else if (current_zoom == 4 || current_zoom == 5) {
                            size = 18;
                        } else if (current_zoom == 3) {
                            size = 15;
                        } else if (current_zoom == 2) {
                            size = 12;
                        } else if (current_zoom == 1) {
                            size = 10;
                        }
                        return size;
                    }
                    var channel_point_resize = function (current_zoom) {
                        var size = channel_point_get_size(current_zoom);
                        var gs = graLayer_wd.graphics;
                        if (gs.length == 0)
                            return;
                        var gs_new = new Array();
                        var geo_new = new Array();
                        var attr_new = new Array();
                        for (var i = 0, l = gs.length; i < l; i++) {
                            var sym = gs[i].symbol;
                            sym.width = size;
                            sym.height = size;
                            gs_new.push(sym);
                            geo_new.push(gs[i].geometry);
                            attr_new.push(gs[i].attributes);
                        }
                        graLayer_wd.clear();
                        for (var i = 0, l = gs_new.length; i < l; i++) {
                            var pointAttributes = attr_new[i];//{address:'101',city:'Portland',state:'Oregon'};
                            var img = new PictureMarkerSymbol(gs_new[i].url, gs_new[i].width, gs_new[i].height);
                            var graphic = new esri.Graphic(geo_new[i], img, pointAttributes);
                            graLayer_wd.add(graphic);
                        }
                    }
                    //标准地址的图标大小控制
                    var standard_point_get_size = function (current_zoom) {
                        var size = 10;
                        if (current_zoom == 9) {
                            size = 10;
                        } else if (current_zoom == 10) {
                            size = 14;
                        } else if (current_zoom > 10) {
                            size = 17;
                        }
                        return size;
                    }
                    var village_ico_get_size = function (current_zoom) {
                        var size = 28;
                        if (current_zoom == 9) {
                            size = 28;
                        } else if (current_zoom == 10) {
                            size = 30;
                        } else if (current_zoom > 10) {
                            size = 32;
                        }
                        return size;
                    }
                    var standard_point_resize = function (current_zoom) {
                        var size = standard_point_get_size(current_zoom);
                        var gs = standard_layer.graphics;
                        if (gs.length == 0)
                            return;
                        var gs_new = new Array();
                        var geo_new = new Array();
                        var attr_new = new Array();
                        for (var i = 0, l = gs.length; i < l; i++) {
                            var sym = gs[i].symbol;
                            sym.width = size;
                            sym.height = size;
                            gs_new.push(sym);
                            geo_new.push(gs[i].geometry);
                            attr_new.push(gs[i].attributes);
                        }
                        standard_layer.clear();
                        for (var i = 0, l = gs_new.length; i < l; i++) {
                            var pointAttributes = attr_new[i];//{address:'101',city:'Portland',state:'Oregon'};
                            var img = new PictureMarkerSymbol(gs_new[i].url, gs_new[i].width, gs_new[i].height);
                            var graphic = new esri.Graphic(geo_new[i], img, pointAttributes);
                            standard_layer.add(graphic);
                        }
                        //map.addLayer(standard_layer);
                    }
                    var standard_point_selected_resize = function (current_zoom) {
                        var size = standard_point_get_size(current_zoom);

                        var gs_drawed = drawed_layer_mark_build.graphics;

                        if (gs_drawed.length == 0) {
                        } else {
                            var gs_drawed_new = new Array();
                            var geo_drawed_new = new Array();
                            var attr_drawed_new = new Array();
                            for (var i = 0, l = gs_drawed.length; i < l; i++) {
                                var sym = gs_drawed[i].symbol;
                                sym.width = size;
                                sym.height = size;
                                gs_drawed_new.push(sym);
                                geo_drawed_new.push(gs_drawed[i].geometry);
                                attr_drawed_new.push(gs_drawed[i].attributes);
                            }
                            drawed_layer_mark_build.clear();
                            for (var i = 0, l = gs_drawed_new.length; i < l; i++) {
                                var pointAttributes = attr_drawed_new[i];//{address:'101',city:'Portland',state:'Oregon'};
                                var img = new PictureMarkerSymbol(gs_drawed_new[i].url, gs_drawed_new[i].width, gs_drawed_new[i].height);
                                var graphic = new esri.Graphic(geo_drawed_new[i], img, pointAttributes);
                                drawed_layer_mark_build.add(graphic);
                            }
                            //map.addLayer(drawed_layer_mark_build);
                        }


                        var gs = draw_layer_mark_build.graphics;
                        if (gs.length == 0) {
                        } else {
                            var gs_new = new Array();
                            var geo_new = new Array();
                            var attr_new = new Array();
                            for (var i = 0, l = gs.length; i < l; i++) {
                                var sym = gs[i].symbol;
                                sym.width = size;
                                sym.height = size;
                                gs_new.push(sym);
                                geo_new.push(gs[i].geometry);
                                attr_new.push(gs[i].attributes);
                            }
                            draw_layer_mark_build.clear();
                            for (var i = 0, l = gs_new.length; i < l; i++) {
                                var pointAttributes = attr_new[i];//{address:'101',city:'Portland',state:'Oregon'};
                                var img = new PictureMarkerSymbol(gs_new[i].url, gs_new[i].width, gs_new[i].height);
                                var graphic = new esri.Graphic(geo_new[i], img, pointAttributes);
                                draw_layer_mark_build.add(graphic);
                            }
                            //map.addLayer(draw_layer_mark_build);
                        }

                    }

                    //响应左侧列表每行的点击事件
                    var sub_gra_last = "";//最后一次点击的支局
                    var grid_gra_last = "";//最后一次点击的网格
                    clickToSub = function (substation, sub_name, thiz, zoom) {
                        parent.global_report_to_id = "";
                        subToGridFlag = false;
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


                        //加载建立在支局下的小区
                        village_load_by_sub_only(substation);

                        //设置所点支局归属的区县的范围轮廓线
                        drawQXLine(substation, sub_name);

                        //此次点击的支局
                        var sub_gra_last_temp = sub_graphics_init[substation];
                        if (sub_gra_last_temp == undefined || sub_gra_last_temp == "") {
                            layer.msg(sub_name + "暂未上图", {time: 2000});
                            return;
                        } else {
                            subFillRecover_click();//还原上次点击过的支局
                            if (sub_gra_last_temp._shape != undefined)
                                beforeClickColor_sub = sub_gra_last_temp._shape.fillStyle;
                            else if (sub_gra_last_temp.symbol != undefined)
                                beforeClickColor_sub = sub_gra_last_temp.symbol.color;
                            sub_gra_clicked = sub_gra_last_temp;
                            var sub_selected_geometry = sub_gra_clicked.geometry;
                            sub_selected_ext = sub_selected_geometry.getExtent();
                            if (zoom > -1) {
                                var temp = sub_selected_geometry.rings;
                                var poly = new esri.geometry.Polygon(map.spatialReference);
                                for (var j = 0; j < temp.length; j++) {
                                    var temp5 = new Array();
                                    for (var m = 0; m < temp[j].length; m++) {
                                        var la = temp[j][m];
                                        var temp2 = [la[0], la[1]];
                                        temp5.push(temp2);
                                    }
                                    poly.addRing(temp5);
                                }

                                var name_point = getGravityCenter(sub_selected_geometry, temp);
                                map.centerAndZoom(name_point, zoom);
                            } else {
                                map.setExtent(sub_selected_ext.expand(1.5));
                            }

                            var graphics = new esri.Graphic(sub_selected_geometry, linesymbol_sub_selected);
                            graLayer_zj_click.add(graphics);
                            try {
                                var zoom = map.getZoom();
                                currentOpacity = getLayerOpacity(zoom);
                                sub_gra_clicked.setSymbol(highlightSymbol_sub_click);
                            } catch (e) {

                            }

                        }
                    }
                    var grid_selected_id = "";
                    //左侧列表，网格定位
                    clickToGrid = function (substation, sub_name, thiz, zoom, grid_name, station_id) {
                        subToGridFlag = false;
                        clickToGrid_function(substation, sub_name, thiz, zoom, grid_name, station_id);
                        //village_load("RES_ID = '"+station_id+"' AND STATUS = 1");
                        ////village_load(station_id);
                        village_where = "report_to_id = '"+station_id+"'";
                        village_service_load();
                    }
                    clickToGridAndPositionVillage = function (substation, sub_name, thiz, zoom, grid_name, station_id, village_id) {
                        subToGridFlag = false;
                        if (station_id == null || station_id == "null") {
                            clickToSub(substation, sub_name, thiz, zoom);
                            village_load_by_sub(substation, village_id);
                        } else {
                            clickToGrid_function(substation, sub_name, thiz, zoom, grid_name, station_id);
                            village_load(station_id, village_id);
                        }
                    }
                    function clickToGrid_function(substation, sub_name, thiz, zoom, grid_name, station_id) {
                        grid_selected_id = station_id;
                        $(thiz).siblings().removeClass("tr_click_background_color");//background-color: #c1c1c1;
                        $(thiz).siblings().addClass("tr_default_background_color");
                        $(thiz).removeClass("tr_default_background_color");
                        $(thiz).addClass("tr_click_background_color");
                        //var grid_id_temp = 左侧列表传递过来的resid;

                        gridFillRecover_click();

                        village_position_layer.clear();
                        if (parent.global_substation == substation && subToGridFlag) {//点击同一个支局中其他网格
                            //高亮当前支局中另一个网格
                            graLayer_wg.redraw();

                            try {
                                var graphics = grid_graphics_init[station_id];

                                graLayer_wg_click.clear();
                                var geo = graphics.geometry;
                                var gra = new esri.Graphic(geo, linesymbol_grid_selected);
                                graLayer_wg_click.add(gra);

                                grid_gra_last = "";
                                grid_gra_clicked = graphics;
                                beforeClickColor_grid = graphics._shape.fillStyle;
                                //var zoom = map.getZoom();
                                currentOpacity = beforeClickColor_grid.a;
                                highlightSymbol_grid_click.color.a = currentOpacity;
                                graphics.setSymbol(highlightSymbol_grid_click);
                                if (zoom < 0)
                                    map.setExtent(sub_selected_ext.expand(1.5));
                                else
                                    map.centerAndZoom(getGravityCenter(geo, geo.rings), zoom);
                                //map.setExtent(geo.getExtent().expand(grid_zoom));
                            } catch (e) {

                            }

                            parent.global_current_flag = 5;
                            parent.global_current_area_name = grid_name;
                            parent.global_current_full_area_name = grid_name;
                            parent.global_position.splice(3, 1, sub_name);
                            parent.global_position.splice(4, 1, grid_name);
                            parent.global_substation = substation;
                            parent.global_report_to_id = station_id;
                            //console.log(sub_gra_last_temp.attributes.REPORT_TO_ID);
                            parent.freshIndexContainer(indexContainer_url_grid);
                            parent.updatePosition(5);

                            return;
                        }
                        subToGridFlag = false;
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
                        drawQXLine(substation, sub_name);

                        //subFillRecover_mouseover();
                        subFillRecover_click();//还原上次点击过的支局

                        //此次点击的支局
                        var sub_gra_last_temp = sub_graphics_init[substation];
                        var sub_selected_geometry = null;
                        if (sub_gra_last_temp == undefined || sub_gra_last_temp == "") {
                            layer.msg(sub_name + "暂未上图", {time: 2000});
                            return;
                        } else {
                            sub_gra_last = sub_gra_last_temp;
                            sub_gra_clicked = sub_gra_last;

                            sub_selected_geometry = sub_gra_last.geometry;
                            sub_selected_ext = sub_selected_geometry.getExtent();

                            if (village_position_operat) {
                                //village_position_operat= false;
                            } else {
                                if (zoom == 9) {
                                }
                                else if (zoom > -1) {
                                    var temp = sub_selected_geometry.rings;
                                    var poly = new esri.geometry.Polygon(map.spatialReference);
                                    for (var j = 0; j < temp.length; j++) {
                                        var temp5 = new Array();
                                        for (var m = 0; m < temp[j].length; m++) {
                                            var la = temp[j][m];
                                            var temp2 = [la[0], la[1]];
                                            temp5.push(temp2);
                                        }
                                        poly.addRing(temp5);
                                    }

                                    var name_point = getGravityCenter(sub_selected_geometry, temp);
                                    map.centerAndZoom(name_point, zoom);
                                } else {
                                    map.setExtent(sub_selected_ext.expand(1.5));
                                }
                            }


                            if (sub_gra_last._shape != undefined)
                                beforeClickColor_sub = sub_gra_last._shape.fillStyle;
                            else if (sub_gra_last.symbol != undefined)
                                beforeClickColor_sub = sub_gra_last.symbol.color;

                            /*var zoom = map.getZoom();
                             currentOpacity = getLayerOpacity(zoom);
                             sub_gra_last.setSymbol(highlightSymbol_sub_click);*/
                            subToGrid_toGrid(sub_gra_last_temp, sub_selected_geometry, sub_gra_last_temp.attributes, station_id, grid_name, false, zoom);
                        }
                    }

                    //右侧支局联动，网格列表点击定位
                    clickToGridFromSub = function (substation, sub_name, zoom1, grid_name, station_id) {
                        clearDrawLayer();
                        //var grid_id_temp = 左侧列表传递过来的resid;
                        subToGridFlag = false;

                        gridFillRecover_click();

                        //点击同一个支局中其他网格
                        if (parent.global_substation == substation && subToGridFlag) {
                            //高亮当前支局中另一个网格
                            graLayer_wg.redraw();

                            try {
                                var graphics = grid_graphics_init[station_id];
                                graLayer_wg_click.clear();
                                var geo = graphics.geometry;
                                var gra = new esri.Graphic(geo, linesymbol_grid_selected);
                                graLayer_wg_click.add(gra);
                                map.centerAndZoom(getGravityCenter(geo, geo.rings), map.getZoom());

                                beforeClickColor_grid = graphics._shape.fillStyle;
                                //var zoom = map.getZoom();
                                currentOpacity = beforeClickColor_grid.a;
                                highlightSymbol_grid_click.color.a = currentOpacity;
                                graphics.setSymbol(highlightSymbol_grid_click);
                            } catch (e) {

                            }
                            village_load(station_id);
                            //village_load("RES_ID = '"+station_id+"' AND STATUS = 1");
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
                        drawQXLine(substation, sub_name);

                        subFillRecover_click();

                        //此次点击的支局
                        var sub_gra_last_temp = sub_graphics_init[substation];
                        var sub_selected_geometry = null;
                        if (sub_gra_last_temp == undefined || sub_gra_last_temp == "") {
                            layer.msg(sub_name + "暂未上图", {time: 2000});
                            return;
                        } else {
                            sub_gra_last = sub_gra_last_temp;
                            sub_gra_clicked = sub_gra_last;
                            sub_selected_geometry = sub_gra_last.geometry;
                            sub_selected_ext = sub_selected_geometry.getExtent();
                            if (zoom > -1) {
                                var temp = sub_selected_geometry.rings;
                                var poly = new esri.geometry.Polygon(map.spatialReference);
                                for (var j = 0; j < temp.length; j++) {
                                    var temp5 = new Array();
                                    for (var m = 0; m < temp[j].length; m++) {
                                        var la = temp[j][m];
                                        var temp2 = [la[0], la[1]];
                                        temp5.push(temp2);
                                    }
                                    poly.addRing(temp5);
                                }

                                var name_point = getGravityCenter(sub_selected_geometry, temp);
                                //map.centerAndZoom(name_point,zoom);
                            } else {
                                //map.setExtent(sub_selected_ext.expand(1.5));
                            }

                            try {
                                beforeMouseOverColor_sub = sub_gra_last._shape.fillStyle;
                            } catch (e) {

                            }
                            var zoom = map.getZoom();
                            currentOpacity = getLayerOpacity(zoom);
                            sub_gra_last.setSymbol(highlightSymbol_sub_click);
                            subToGrid_toGrid(sub_gra_last_temp, sub_selected_geometry, sub_gra_last_temp.attributes, station_id, grid_name, true, zoom1);
                            //village_load("RES_ID = '"+station_id+"' AND STATUS = 1");
                            village_load(station_id);

                            parent.global_current_flag = 5;
                            parent.global_current_area_name = grid_name;
                            parent.global_current_full_area_name = grid_name;
                            parent.global_position.splice(4, 1, grid_name);
                            parent.global_substation = substation;
                            parent.global_report_to_id = station_id;

                            subToGridFlag = true;
                        }
                    }
                    parent.clickToGridFromSub = clickToGridFromSub;

                    //处理地图视野改变事件，拖拽、滚轮、聚焦
                    map.on("extent-change", function (evt) {
                        if (chartIsShow) {
                            showWINInfo();
                        }
                        var mapZoom = map.getZoom();
                        console.log("mapZoom:" + mapZoom);

                        /*if(mapZoom>6){
                         village_layer.clear();
                         village_load("CITY_ID = "+city_id+" AND STATUS = 1");
                         }else{
                         village_layer.clear();
                         village_layer.hide();
                         }*/
                        var qx_line_and_text = graLayer_qx_all.graphics;
                        if (mapZoom >= 3) {
                            for (var i = 0, l = qx_line_and_text.length; i < l; i++) {
                                var lt = qx_line_and_text[i];
                                if (lt.symbol.type == "textsymbol") {
                                    lt.symbol.color.a = 0;
                                }
                            }
                        } else {
                            for (var i = 0, l = qx_line_and_text.length; i < l; i++) {
                                var lt = qx_line_and_text[i];
                                if (lt.symbol.type == "textsymbol") {
                                    lt.symbol.color.a = 1;
                                }
                            }
                        }

                        if (mapZoom < 7) {
                            standard_layer.clear();
                            position_layer.clear();
                            if (vboo) {
                                killEventForBuildView();
                                reboundForBuildView();
                            }
                            draw_layer_mark_build.hide();
                            drawed_layer_mark_build.hide();
                            //hideVillageLayer();
                            //showVillageLayer();
                        } else {
                            standard_load();
                            standard_point_resize(mapZoom);
                            standard_point_selected_resize(mapZoom);
                            draw_layer_mark_build.show();
                            drawed_layer_mark_build.show();
                            killEventForBuildView();
                            /*if(parent.global_region_type!="village"){
                            	village_service_load();
                            	showVillageLayer();
                            }
                            else
                            	showVillageLayer();*/

                           	buildInsideVillageColorful();

                            /*map.addLayer(standard_layer);
                             map.addLayer(drawed_layer_mark_build);
                             map.addLayer(draw_layer_mark_build);
                             map.addLayer(village_layer);
                             map.addLayer(village_position_layer);*/
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

                    function buildInsideVillageColorful(){
                    		var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        if(standard_where!="")
                        	query_standard.where = standard_where;
                        query_standard.geometry = map.extent;
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        var city_geometry = "";//所展示市级范围的图形对象
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0)
                                return;
                            var ids_str = "";
                            for (var i = 0, l = results.features.length; i < l; i++) {
                                var feature = results.features[i];
                                var attr = feature.attributes;
                                ids_str += "'" + attr.RESID + "'";
                                if(i==999)
                            			break;
                                if(i<l-1)
                                	ids_str += ",";
                            }
                            var url_query = "";
                            var eaction = "";
                            if(nav_type_index=="village"){
                            	url_query = url4Query_leader;
                            	eaction = "getBuildUsedInArea";
                            }else if(nav_type_index=="school" || nav_type_index=="enterprise"){
                            	url_query = url4Query_enterprise;
                            	eaction = "getBuildUsedInSchoolOrEnterprise";
                            }

                            $.post(url_query,{"eaction":eaction,"build_ids":ids_str,"latn_id":city_id},function(data){
                            	data = $.parseJSON(data);
                            	var ids_used_str = "RESID in (";
                            	for(var i = 0,l = data.length;i<l;i++){
                            		ids_used_str += "'" + data[i].SEGM_ID + "'";
                                if(i<l-1)
                                	ids_used_str += ",";
                            	}
                            	ids_used_str += ")";

                            	if(ids_used_str=="RESID in ()")
                            		return;
                            	var queryTask_standard = new QueryTask(standard_address);
			                        var query_standard = new Query();
			                        query_standard.where = ids_used_str;

			                        //query_standard.geometry = map.extent;
			                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
			                        query_standard.returnGeometry = true;
			                        var city_geometry = "";//所展示市级范围的图形对象

			                        queryTask_standard.execute(query_standard, function (results) {
			                            if (results.features.length == 0) {
			                                //layer.msg("地图数据中不包含查询结果");
			                                return;
			                            }

			                            //将绘制过小区的楼宇用一个颜色标记出来(standard_ico_used)，以便和未使用的楼宇区别
			                            var gra_array = new Array();
			                            for (var i = 0, l = results.features.length; i < l; i++) {
			                                var geo = results.features[i].geometry;

			                                var size = standard_point_get_size(map.getZoom());
			                                var build_img = new PictureMarkerSymbol(standard_ico_used, size, size);
			                                var build_gra = new esri.Graphic(geo, build_img, results.features[i].attributes);
			                                drawed_layer_mark_build.add(build_gra);

			                                gra_array.push(new Graphic(geo));
			                            }

			                        });
                            });
                        });
                    }

                    //描边所有区县的轮廓 qx_nameList_new qx_nameList_all:{city_name:area_name}
                    $.post(url4Query, {"eaction": "qx_nameList_new", "city_id": city_id}, function (data) {
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
                            if (name == undefined)
                                name = name_temp;
                            query.where = "NAME = '" + name + "'";
                            query.outFields = ['NAME'];
                            query.returnGeometry = true;
                            queryTask.execute(query, function (results) {
                                //var color = city_colors[i];
                                var k = results.features.length;
                                if (k == 0)//没有对应区县地图数据
                                    return;

                                for (var j = 0; j < k; j++) {
                                    var geometry = results.features[j].geometry;
                                    qx_geometry = geometry;
                                    //back_to_ext = geometry;
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

                    map.on("mouse-drag-start", function () {

                        hideWINInfo();
                    });
                    map.on("mouse-drag-end", function () {

                        if (chartIsShow) {
                            showWINInfo();
                        }
                    });
                    map.on("mouse-wheel", function () {

                        hideWINInfo();
                    });
                    var labelPrt_array = new Array();
                    var infoWindow2s = new Array();

                    function createChartInfoWindow(temps, showFields) {
                        var max = -100000;
                        $.each(temps, function (index, obj) {
                            for (var i = 0, j = showFields.length; i < j; i++) {
                                if (max < obj[showFields[i]]) {
                                    max = obj[showFields[i]];
                                }
                            }
                        });

                        try {
                            var optinalChart = null;

                            $.each(temps, function (index, obj) {
                                var infoWindow2 = new ChartInfoWindow({
                                    domNode: domConstruct.create('div', null, document
                                            .getElementById('gismap'))
                                });
                                infoWindow2.setMap(map);
                                var nodeChart = null;
                                nodeChart = domConstruct.create("div", {
                                    id: 'nodeTest' + index,
                                    style: "width:20px;height:40px"
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
                        var chart = new Chart(node, {margins: {l: 0, r: 0, t: 0, b: 0}}).
                                setTheme(CustomTheme).
                                addPlot("default", {type: "Columns", gap: 0});
                        var serieValues = [];
                        var length = showFields.length;
                        for (var i = 0; i < length; i++) {
                            serieValues = [];
                            for (var m = 0; m < i; m++) {
                                serieValues.push(0);
                            }

                            serieValues.push(attributes[showFields[i]]);
                            chart.addSeries(showFields[i], serieValues, {stroke: {color: "black"}});
                        }

                        serieValues = [];
                        for (var k = 0; k < length; k++) {
                            serieValues.push(0);
                        }
                        serieValues.push(max);
                        chart.addSeries("隐藏", serieValues, {
                            stroke: {color: new Color([0x3b, 0x44, 0x4b, 0])},
                            fill: "transparent"
                        });

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

                    function hideWINInfo() {
                        for (var i = 0; i < infoWindow2s.length; i++) {
                            infoWindow2s[i].hide();
                        }
                    }

                    function showWINInfo() {
                        for (var i = 0; i < infoWindow2s.length; i++) {
                            infoWindow2s[i].show(labelPrt_array[i]);
                        }
                    }

                    var showSubInfoWin = function (graphic, attrs) {
                        /*map.infoWindow.setTitle("支局信息");
                         map.infoWindow.resize(260,200);*/

                        subFillRecover_mouseover();

                        if (sub_gra_clicked != "") {
                            if (sub_gra_clicked.attributes["SUBSTATION_NO"] == graphic.attributes["SUBSTATION_NO"]) {
                                //悬浮的是点击选中的那个支局
                                sub_gra_last = graphic;
                                beforeMouseOverColor_sub = beforeClickColor_sub;
                            } else {
                                sub_gra_last = graphic;
                                beforeMouseOverColor_sub = graphic._shape.fillStyle;

                                //设置高亮显示
                                var zoom = map.getZoom();
                                currentOpacity = getLayerOpacity(zoom);
                                graphic.setSymbol(highlightSymbol_sub_mouse_over);
                            }
                        } else {
                            sub_gra_last = graphic;

                            try {
                                beforeMouseOverColor_sub = graphic._shape.fillStyle;//sub_gra_last._shape.fillStyle;

                                //设置高亮显示
                                var zoom = map.getZoom();
                                currentOpacity = getLayerOpacity(zoom);
                                graphic.setSymbol(highlightSymbol_sub_mouse_over);
                            } catch (e) {
                            }
                        }

                        var attr = sub_dev[attrs["SUBSTATION_NO"]];//attrs["sub_dev"];
                        var ems = $("#sub_info_win").find("em");
                        $(ems[0]).html(sub_data[attrs["SUBSTATION_NO"]]);

                        $(ems[1]).html(attr["bureau_name"]);
                        $(ems[2]).html(attr["grid_id_cnt"]);
                        var grid_hide = attr["grid_show"];
                        if (grid_hide == 0) {
                            $(ems[3]).prev().hide();
                            $(ems[3]).hide();
                            $(ems[3]).next().hide();
                        } else {
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

                        $("#sub_info_win").css("visibility", "visible");
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
                    var subFillRecover_mouseover = function () {
                        if (sub_gra_last != undefined && sub_gra_last != "") {
                            if (sub_gra_clicked != undefined && sub_gra_clicked != "")
                                if (sub_gra_last.attributes.RESID == sub_gra_clicked.attributes.RESID)
                                    return;
                            var color = beforeMouseOverColor_sub;
                            if (color == "" || color == undefined)//上次没有记录过支局的颜色
                                return;
                            var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
                                    new esri.Color([color.r, color.g, color.b, color.a]), 3), new esri.Color([color.r, color.g, color.b, color.a]));
                            sub_gra_last.setSymbol(symbol);
                            sub_gra_last = "";
                        }
                    };

                    //还原上次点击的支局的颜色
                    var subFillRecover_click = function () {
                        if (sub_gra_clicked != undefined && sub_gra_clicked != "") {
                            var color = beforeClickColor_sub;
                            if (color == "" || color == undefined)//上次没有记录过支局的颜色
                                return;
                            var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
                                    new esri.Color([color.r, color.g, color.b, color.a]), 3), new esri.Color([color.r, color.g, color.b, color.a]));
                            sub_gra_clicked.setSymbol(symbol);
                            sub_gra_clicked = "";
                            beforeClickColor_sub = "";
                        }
                    };

                    //还原上次悬浮的网格的颜色
                    var gridFillRecover_mouseover = function () {
                        if (grid_gra_last != undefined && grid_gra_last != "") {
                            var color = beforeMouseOverColor_grid;
                            if (color == "" || color == null)//上次没有记录过网格的颜色
                                return;
                            var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(color));//fill_color_array[i]
                            fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color([grid_line_color[0], grid_line_color[1], grid_line_color[2], grid_line_color[3]]), grid_line_width));//color.a,STYLE_DASH，click_line_color_grid
                            grid_gra_last.setSymbol(fillsymbol1);
                            grid_gra_last = "";
                        }

                    };

                    //还原上次点击的网格的颜色
                    var gridFillRecover_click = function () {
                        if (grid_gra_clicked != undefined && grid_gra_clicked != "") {
                            var color = beforeClickColor_grid;
                            if (color == "")//上次没有记录过支局的颜色
                                return;
                            var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
                                    new esri.Color([grid_line_color[0], grid_line_color[1], grid_line_color[2], grid_line_color[3]]), grid_line_width), new esri.Color([color.r, color.g, color.b, color.a]));//color.a
                            grid_gra_clicked.setSymbol(symbol);
                            grid_gra_clicked = "";
                        }
                    };

                    var drawQXLine = function (substation, sub_name) {
                    		//设置所点支局归属的区县的id
                        $.post(url4Query, {
                            eaction: "getAreaNameBySubId",
                            sub_id: substation,
                            city_id: city_id
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data == null)
                                return;
                            var qx_id = data.CITYIDCOL;
                            parent.global_bureau_id = qx_id;
                        });
                        parent.global_position.splice(3, 1, sub_name);

                        if (zxs[city_id] != undefined) {
                            return;//嘉峪关不处理有关区县变化
                        }
                    }

                    var featureLayer_mouse_over_handler = dojo.connect(featureLayer, "onMouseOver", function (evt) {
                        featureLayer_mouse_over(evt);
                    });

                    function featureLayer_mouse_over(evt) {
                        map.infoWindow.hide();
                        //防止事件冒泡
                        dojo.stopEvent(evt);
                        evt.stopPropagation();
                        //手型
                        map.setMapCursor("pointer");

                        var graphic = evt.graphic;

                        //显示支局基本信息
                        var attr = graphic.attributes;
                        showSubInfoWin(graphic, attr);
                    }

                    var featureLayer_mouse_out_handler = dojo.connect(featureLayer, "onMouseOut", function (evt) {
                        featureLayer_mouse_out(evt);
                    });

                    function featureLayer_mouse_out(evt) {
                        $("#sub_info_win").css({visibility: "hidden"});
                        //map.infoWindow.hide();
                        var ele = evt.toElement;

                        if (ele == null || ele.id != 'sub_info_win') {
                            $("#sub_info_win").hide();
                        }
                        map.setMapCursor("default");
                        subFillRecover_mouseover();
                    }

                    var graLayer_zjname_mouse_over_handler = dojo.connect(graLayer_zjname, "onMouseOver", function (evt) {
                        graLayer_zjname_mouse_over(evt);
                    });

                    function graLayer_zjname_mouse_over(evt) {
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
                        showSubInfoWin(graphic, attrs);
                    }

                    var graLayer_zjname_mouse_out_handler = dojo.connect(graLayer_zjname, "onMouseOut", function (evt) {
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
                    var subToGrid = function (graphics, sub_selected_geometry, sub_attr) {
                    		inside_flag = true;
                    		hideVillageLayer();
                    		$("#tools_scroll").hide();
                    		$(".region_switch_group").hide();
                        back_to_ext = map.extent;

                        map.infoWindow.hide();
                        $("#sub_info_win").hide();
                        $("#grid_info_win").hide();

                        $("#nav_fanhui").hide();
                        $("#nav_fanhui_city").hide();
                        $("#nav_fanhui_qx").show();
                        $("#nav_fanhui_sub").hide();

                        //var sub_selected_ext = sub_selected_geometry.getExtent();
                        //map.setExtent(sub_selected_ext.expand(1.5));
                        var sub_selected_ext = sub_selected_geometry.getExtent();
                        var zoom = -1;
                        if(sub_zoom_array[sub_attr.SUBSTATION_NO]!=undefined)
                            zoom = sub_zoom_array[sub_attr.SUBSTATION_NO];
                        if (zoom > -1) {
                            var temp = sub_selected_geometry.rings;
                            /*var poly = new esri.geometry.Polygon(map.spatialReference);
                             for (var j = 0; j < temp.length; j++) {
                             var temp5 = new Array();
                             for (var m = 0; m < temp[j].length; m++) {
                             var la = temp[j][m];
                             var temp2 = [la[0], la[1]];
                             temp5.push(temp2);
                             }
                             poly.addRing(temp5);
                             }*/

                            var name_point = getGravityCenter(sub_selected_geometry, temp);
                            map.centerAndZoom(name_point, zoom);
                        } else {
                            map.setExtent(sub_selected_ext.expand(1.5));
                        }

                        subFillRecover_click();//还原上次点击过的支局
                        beforeClickColor_sub = beforeMouseOverColor_sub;
                        if (beforeClickColor_sub == "" || beforeClickColor_sub == undefined) {
                            if (graphics._shape != undefined)
                                beforeClickColor_sub = graphics._shape.fillStyle;
                            else if (graphics.symbol != undefined)
                                beforeClickColor_sub = graphics.symbol.color;
                        }
                        sub_gra_clicked = graphics;
                        //var sub_name = evt.graphic.attributes.REPORTTO;

                        var substation = sub_attr.SUBSTATION_NO;
                        var sub_name = sub_data[substation];

                        //2017-11-29取消根据支局和网格resid的关系查询，改为使用视图 view_sub_grid_ref 中union_org_code，report_to_id
                        //var resid = sub_attr.RESID;

                        drawQXLine(substation, sub_name);

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

                        //加载建立在支局下的小区
                        ////village_load_by_sub_only(substation);
                        village_where = "union_org_code = '"+substation+"'";
                        village_service_load();

                        //查询支局下的网格
                        $.post(url4Query,{eaction:"setgrids",id:substation,latn_id:city_id},function (data) {
                        	data = $.parseJSON(data);
                        	if(data.length==0){
                        		//在划小下，该支局下没有网格
                        		layer.msg("该支局无网格");
                        		//右侧联动
                        		parent.freshIndexContainer(indexContainer_url_sub);
                        		subToGridFlag = false;
                        		return;
                        	}else{
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

		                    		//查询支局对应的网格（用业务图层的resid，查对应关系表(view_sub_grid_ref)，获取网格的资源resid，用资源id在网格图层查询resid）
		                        $.post(url4Query, {
		                            //eaction: 'grids_in_subBySubResid',
		                            //sub_id: resid
		                            eaction:"grids_in_sub_by_substation_no",
		                            sub_id:substation
		                        }, function (data) {
		                            data = $.parseJSON(data);
		                            if (data.length == 0) {
		                                var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
		                                graLayer_mouseclick.add(graphic);
		                                graLayer_mouseclick.show();

		                                //layer.msg("该支局的网格暂未上图",{time:2000});
		                                //back_to_ext = "";
		                                //该支局下没有一个网格的时候，支局填充后，写“xx支局 [换行] 未划配网格”

		                                var textSymbol = new esri.symbol.TextSymbol(sub_name + "\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
		                                //合并geo中的碎片块
		                                var temp = sub_selected_geometry.rings;
		                                var poly = new esri.geometry.Polygon(map.spatialReference);
		                                for (var j = 0; j < temp.length; j++) {
		                                    var temp5 = new Array();
		                                    for (var m = 0; m < temp[j].length; m++) {
		                                        var la = temp[j][m];
		                                        var temp2 = [la[0], la[1]];
		                                        temp5.push(temp2);
		                                    }
		                                    poly.addRing(temp5);
		                                }

		                                var name_point = getGravityCenter(sub_selected_geometry, temp);
		                                var labelGraphic = new esri.Graphic(name_point, textSymbol);
		                                graLayer_subname_result.clear();
		                                graLayer_subname_result.add(labelGraphic);
		                                graLayer_subname_result.redraw();
		                                return;
		                            }


		                            //2017-11-29 关联条件变化的调整
		                            /*var where_temp = "RESID IN (";
		                            for (var i = 0, l = data.length; i < l; i++) {
		                                var resid = data[i].RESID;
		                                where_temp += "'" + resid + "'";
		                                if (i < l - 1)
		                                    where_temp += ",";
		                            }
		                            where_temp += ")";*/
		                            var where_temp = "REPORT_TO_ID IN (";
		                            for (var i = 0, l = data.length; i < l; i++) {
		                                var grid_id = data[i].GRID_ID;
		                                where_temp += "'" + grid_id + "'";
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
		                                if (l == 0) {
		                                    var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
		                                    graLayer_mouseclick.add(graphic);
		                                    graLayer_mouseclick.show();
		                                    //layer.msg("该支局的网格暂未上图");
		                                    //back_to_ext = "";
		                                    var textSymbol = new esri.symbol.TextSymbol(sub_name + "\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
		                                    //合并geo中的碎片块
		                                    var temp = sub_selected_geometry.rings;
		                                    var poly = new esri.geometry.Polygon(map.spatialReference);
		                                    for (var j = 0; j < temp.length; j++) {
		                                        var temp5 = new Array();
		                                        for (var m = 0; m < temp[j].length; m++) {
		                                            var la = temp[j][m];
		                                            var temp2 = [la[0], la[1]];
		                                            temp5.push(temp2);
		                                        }
		                                        poly.addRing(temp5);
		                                    }

		                                    var name_point = getGravityCenter(sub_selected_geometry, temp);
		                                    var labelGraphic = new esri.Graphic(name_point, textSymbol);
		                                    graLayer_subname_result.add(labelGraphic);
		                                    graLayer_subname_result.redraw();
		                                    return;
		                                }
		                                //支局中的网格的REPORT_TO_ID为空，则不能下钻;2017-11-29已废弃,现使用report_to_id来关联
		                                /*var hasNoRepotId = 0;
		                                for (var i = 0; i < l; i++) {
		                                    var feature = results.features[i];
		                                    var id = feature.attributes["REPORT_TO_ID"];
		                                    if ($.trim(id) == "" || id == null || id == "null") {
		                                        hasNoRepotId += 1;
		                                    }
		                                }*/
		                                //所有的网格都没有REPORT_TO_ID;2017-11-29已废弃,现使用report_to_id来关联
		                                /*if (hasNoRepotId == l) {
		                                    //支局中没有网格可以上图
		                                    var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
		                                    graLayer_mouseclick.add(graphic);
		                                    graLayer_mouseclick.show();

		                                    var textSymbol = new esri.symbol.TextSymbol(sub_name + " \n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
		                                    //合并geo中的碎片块
		                                    var temp = sub_selected_geometry.rings;
		                                    var poly = new esri.geometry.Polygon(map.spatialReference);
		                                    for (var j = 0; j < temp.length; j++) {
		                                        var temp5 = new Array();
		                                        for (var m = 0; m < temp[j].length; m++) {
		                                            var la = temp[j][m];
		                                            var temp2 = [la[0], la[1]];
		                                            temp5.push(temp2);
		                                        }
		                                        poly.addRing(temp5);
		                                    }

		                                    var name_point = getGravityCenter(sub_selected_geometry, temp);
		                                    var labelGraphic = new esri.Graphic(name_point, textSymbol);
		                                    graLayer_subname_result.clear();
		                                    graLayer_subname_result.add(labelGraphic);
		                                    graLayer_subname_result.redraw();
		                                    return;
		                                }*/
		                                //这里才是可以上图的网格↓
		                                var graphic = new esri.Graphic(sub_selected_geometry, linesymbol_has_grid_in_sub);
		                                graLayer_mouseclick.add(graphic);
		                                graLayer_mouseclick.show();

		                                //使用配色数组填充网格背景
		                                grid_graphics_init = new Array();
		                                for (var i = 0, k = 0; i < l; i++, k++) {
		                                    //使用支局背景色填充网格背景
		                                    //for (var i = 0; i < l; i++) {
		                                    var feature = results.features[i];
		                                    var report_to_id = feature.attributes["REPORT_TO_ID"];
		                                    //if ($.trim(report_to_id) == "")//网格中REPORT_TO_ID为空的不绘制该网格
		                                    //    continue;
		                                    var geo = feature.geometry;
		                                    //合并geo中的碎片块
		                                    var temp = geo.rings;
		                                    var poly = new esri.geometry.Polygon(map.spatialReference);
		                                    for (var j = 0; j < temp.length; j++) {
		                                        var temp5 = new Array();
		                                        for (var m = 0; m < temp[j].length; m++) {
		                                            var la = temp[j][m];
		                                            var temp2 = [la[0], la[1]];
		                                            temp5.push(temp2);
		                                        }
		                                        poly.addRing(temp5);
		                                    }
		                                    //用隶属的支局颜色填充每个网格的颜色
		                                    //var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, beforeMouseOverColor.g, beforeMouseOverColor.b.a]));//fill_color_array[i]

		                                    if (k > fill_color_array.length - 1)
		                                        k = 0;
		                                    var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
		                                    fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(grid_line_color), grid_line_width));//STYLE_DASH，click_line_color_grid
		                                    //fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), grid_line_width));//STYLE_DASH，click_line_color_grid

		                                    /*var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
		                                     fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color([fill_color_array[k][0],fill_color_array[k][1],fill_color_array[k][2],1]), grid_line_width));//STYLE_DASH，click_line_color_grid*/

		                                    var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
		                                    graphic.setAttributes(feature.attributes);
		                                    graLayer_wg.add(graphic);

		                                    graLayer_wg.on("graphic-add", function (evt) {
		                                        var grid_gra_init = evt.graphic;
		                                        var grid_attr = grid_gra_init.attributes;
		                                        //grid_graphics_init[grid_attr.RESID] = grid_gra_init;
		                                        grid_graphics_init[grid_attr.REPORT_TO_ID] = grid_gra_init;
		                                    });

		                                    var area = feature.attributes["SHAPE.AREA"];
		                                    var font = new esri.symbol.Font("12px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD);
		                                    font.setFamily("微软雅黑");

		                                    var grid_name = feature.attributes.REPORTTO;
		                                    if ($.trim(grid_name) == "")
		                                        grid_name = feature.attributes.RESNAME;
		                                    grid_name = grid_name.substr(grid_name.indexOf("-") + 1);
		                                    var textSymbol = new esri.symbol.TextSymbol(grid_name, font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
		                                    //textSymbol.setHaloColor(new esri.Color([255, 0, 0]));
		                                    //textSymbol.setHaloSize(10);
		                                    var name_point = getGravityCenter(geo, temp);

		                                    var labelGraphic = new esri.Graphic(name_point, textSymbol);
		                                    var grid_geo_attr = new Array();
		                                    grid_geo_attr["grid_geo"] = geo;
		                                    grid_geo_attr["grid_attr"] = feature.attributes;
		                                    grid_geo_attr["grid_fill_gra"] = graphic;
		                                    labelGraphic.setAttributes(grid_geo_attr);
		                                    area = area * 10000000000;
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

		                                    //右侧联动
						                        		parent.freshIndexContainer(indexContainer_url_sub);
						                        		subToGridFlag = false;
		                                }
		                                var mapZoom = map.getZoom();
		                                wg_name_show_hide(mapZoom);
		                            });
		                        });
                        	}
                        });
                    };

                    var gridToEnd = function (attr) {
                    		inside_flag = true;
                    		hideVillageLayer();
                    		$("#tools_scroll").hide();
                    		$(".region_switch_group").hide();
                    		village_id_selected = "";
                        subToGridFlag = true;

                        $("#nav_fanhui").hide();
                        $("#nav_fanhui_city").hide();
                        $("#nav_fanhui_qx").hide();
                        $("#nav_fanhui_sub").show();

                        var grid_name = attr.REPORTTO;
                        if ($.trim(grid_name) == "")
                            grid_name = attr.RESNAME;

                        grid_name = grid_name.substr(grid_name.indexOf("-") + 1);

                        parent.global_current_flag = 5;
                        parent.global_current_full_area_name = grid_name;
                        parent.global_current_area_name = grid_name;
                        parent.global_position.splice(4, 1, grid_name);

                        if (parent.global_report_to_id == attr.REPORT_TO_ID && attr.REPORT_TO_ID != "") {
                            parent.global_report_to_id = attr.REPORT_TO_ID;
                            return;
                        } else
                            parent.global_report_to_id = attr.REPORT_TO_ID;

                        $.post(url4Query,{"eaction":"getGridUnionOrgCodeByReportToId","report_to_id":parent.global_report_to_id},function(data){
                        	data = $.parseJSON(data);
                        	if(data!=null)
                        		parent.global_grid_id = data.STATION_NO;
                        	parent.freshIndexContainer(indexContainer_url_grid);
                        });

                        //village_load("RES_ID = '"+attr.REPORT_TO_ID+"' AND STATUS = 1");
                       	village_load(attr.REPORT_TO_ID);
                    }

                    var subToGrid_toGrid = function (graphics, sub_selected_geometry, sub_attr, station_id, grid_name_selected, zoomable, zoom1) {
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

                        var substation = sub_attr.SUBSTATION_NO;
                        var sub_name = sub_data[substation];

                        //var resid = sub_attr.RESID;

                        drawQXLine(substation, sub_name);

                        parent.global_position.splice(3, 1, sub_name);
                        parent.global_position.splice(4, 1, grid_name_selected);
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
                        $.post(url4Query, {
                            //eaction: 'grids_in_subBySubResid',
                            //sub_id: resid,
                            //city_id: city_id
                            eaction:"grids_in_sub_by_substation_no",
		                        sub_id:substation
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data.length == 0) {
                                var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
                                graLayer_mouseclick.add(graphic);
                                //layer.msg("该支局的网格暂未上图",{time:2000});
                                //back_to_ext = "";
                                //该支局下没有一个网格的时候，支局填充后，写“xx支局 [换行] 未划配网格”
                                var textSymbol = new esri.symbol.TextSymbol(sub_name + "\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
                                //合并geo中的碎片块
                                var temp = sub_selected_geometry.rings;
                                var poly = new esri.geometry.Polygon(map.spatialReference);
                                for (var j = 0; j < temp.length; j++) {
                                    var temp5 = new Array();
                                    for (var m = 0; m < temp[j].length; m++) {
                                        var la = temp[j][m];
                                        var temp2 = [la[0], la[1]];
                                        temp5.push(temp2);
                                    }
                                    poly.addRing(temp5);
                                }

                                var name_point = getGravityCenter(sub_selected_geometry, temp);
                                var labelGraphic = new esri.Graphic(name_point, textSymbol);
                                graLayer_subname_result.clear();
                                graLayer_subname_result.add(labelGraphic);
                                graLayer_subname_result.redraw();

                                if (buildInVillage_mode != "") {
                                    layer.msg(sub_name + "未划配网格");
                                    map.centerAndZoom(getGravityCenter(sub_selected_geometry, sub_selected_geometry.rings), map.getZoom());
                                    tuichu();
                                }
                                if (village_position_operat) {
                                    layer.msg(sub_name + "未划配网格");
                                    village_position_operat = false;
                                    subToGridFlag = true;
                                }

                                return;
                            }

                            //2017-11-29 关联条件变化的调整
                            /*var where_temp = "RESID IN (";
                            for (var i = 0, l = data.length; i < l; i++) {
                                var resid = data[i].RESID;
                                where_temp += "'" + resid + "'";
                                if (i < l - 1)
                                    where_temp += ",";
                            }
                            where_temp += ")";*/
                            var where_temp = "REPORT_TO_ID IN (";
                            for (var i = 0, l = data.length; i < l; i++) {
                                var grid_id = data[i].GRID_ID;
                                where_temp += "'" + grid_id + "'";
                                if (i < l - 1)
                                    where_temp += ",";
                            }
                            where_temp += ")";

                            //setTimeout(function(){
                            var queryTask1 = new esri.tasks.QueryTask(new_url_grid_vaild + grid_layer_index);
                            var query1 = new esri.tasks.Query();
                            query1.where = where_temp;
                            //query1.orderByFields = ["ORIG_FID"];
                            query1.outFields = ['SHAPE.AREA', 'RESNAME', 'RESID', 'REPORTTO', 'REPORT_TO_ID'];
                            query1.returnGeometry = true;
                            console.log("where2:" + where_temp);
                            queryTask1.execute(query1, function (results) {
                                var l = results.features.length;
                                if (l == 0) {
                                    var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
                                    graLayer_mouseclick.add(graphic);
                                    //layer.msg("该支局的网格暂未上图");
                                    //back_to_ext = "";
                                    var textSymbol = new esri.symbol.TextSymbol(sub_name + "\n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
                                    //合并geo中的碎片块
                                    var temp = sub_selected_geometry.rings;
                                    var poly = new esri.geometry.Polygon(map.spatialReference);
                                    for (var j = 0; j < temp.length; j++) {
                                        var temp5 = new Array();
                                        for (var m = 0; m < temp[j].length; m++) {
                                            var la = temp[j][m];
                                            var temp2 = [la[0], la[1]];
                                            temp5.push(temp2);
                                        }
                                        poly.addRing(temp5);
                                    }

                                    var name_point = getGravityCenter(sub_selected_geometry, temp);
                                    var labelGraphic = new esri.Graphic(name_point, textSymbol);
                                    graLayer_subname_result.add(labelGraphic);
                                    graLayer_subname_result.redraw();

                                    if (buildInVillage_mode != "") {
                                        layer.msg(sub_name + "未划配网格");
                                        map.centerAndZoom(getGravityCenter(sub_selected_geometry, sub_selected_geometry.rings), map.getZoom());
                                        tuichu();
                                    }
                                    if (village_position_operat) {
                                        layer.msg(sub_name + "未划配网格");
                                        village_position_operat = false;
                                        subToGridFlag = true;
                                    }
                                    return;
                                }
                                //支局中的网格的REPORT_TO_ID为空，则不能下钻;2017-11-29已废弃
                                /*var hasNoRepotId = 0;
                                for (var i = 0; i < l; i++) {
                                    var feature = results.features[i];
                                    var id = feature.attributes["REPORT_TO_ID"];
                                    if ($.trim(id) == "" || id == null || id == "null") {
                                        hasNoRepotId += 1;
                                    }
                                }*/
                                //所有的网格都没有REPORT_TO_ID；2017-11-29已废弃
                                /*if (hasNoRepotId == l) {
                                    //支局下没有网格上图
                                    var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol_none_grid_in_sub);
                                    graLayer_mouseclick.add(graphic);

                                    var textSymbol = new esri.symbol.TextSymbol(sub_name + " \n 未划配网格", font_sub_none_grid_text, new esri.Color(sub_none_grid_text_color));//feature.attributes.REPORTTO
                                    //合并geo中的碎片块
                                    var temp = sub_selected_geometry.rings;
                                    var poly = new esri.geometry.Polygon(map.spatialReference);
                                    for (var j = 0; j < temp.length; j++) {
                                        var temp5 = new Array();
                                        for (var m = 0; m < temp[j].length; m++) {
                                            var la = temp[j][m];
                                            var temp2 = [la[0], la[1]];
                                            temp5.push(temp2);
                                        }
                                        poly.addRing(temp5);
                                    }

                                    var name_point = getGravityCenter(sub_selected_geometry, temp);
                                    var labelGraphic = new esri.Graphic(name_point, textSymbol);
                                    graLayer_subname_result.clear();
                                    graLayer_subname_result.add(labelGraphic);
                                    graLayer_subname_result.redraw();
                                    if (buildInVillage_mode != "") {
                                        layer.msg(sub_name + "未划配网格");
                                        map.centerAndZoom(getGravityCenter(sub_selected_geometry, sub_selected_geometry.rings), map.getZoom());
                                        tuichu();
                                    }
                                    if (village_position_operat) {
                                        layer.msg(sub_name + "未划配网格");
                                        village_position_operat = false;
                                        subToGridFlag = true;
                                    }
                                    return;
                                }*/
                                //这里才是可以上图的网格↓
                                var graphic = new esri.Graphic(sub_selected_geometry, linesymbol_has_grid_in_sub);
                                graLayer_mouseclick.add(graphic);
                                //使用配色数组填充网格背景
                                grid_graphics_init = new Array();
                                for (var i = 0, k = 0; i < l; i++, k++) {
                                    //使用支局背景色填充网格背景
                                    //for (var i = 0; i < l; i++) {
                                    var feature = results.features[i];
                                    var report_to_id = feature.attributes["REPORT_TO_ID"];
                                    //if ($.trim(report_to_id) == "")//网格中REPORT_TO_ID为空的不绘制该网格
                                    //    continue;
                                    var geo = feature.geometry;
                                    //合并geo中的碎片块
                                    var temp = geo.rings;
                                    var poly = new esri.geometry.Polygon(map.spatialReference);
                                    for (var j = 0; j < temp.length; j++) {
                                        var temp5 = new Array();
                                        for (var m = 0; m < temp[j].length; m++) {
                                            var la = temp[j][m];
                                            var temp2 = [la[0], la[1]];
                                            temp5.push(temp2);
                                        }
                                        poly.addRing(temp5);
                                    }
                                    //用隶属的支局颜色填充每个网格的颜色
                                    //var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, beforeMouseOverColor.g, beforeMouseOverColor.b.a]));//fill_color_array[i]
                                    if (k > fill_color_array.length - 1)
                                        k = 0;
                                    var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
                                    fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(grid_line_color), grid_line_width));//STYLE_DASH，click_line_color_grid
                                    //fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), grid_line_width));//STYLE_DASH，click_line_color_grid
                                    //fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color([fill_color_array[k][0],fill_color_array[k][1],fill_color_array[k][2],1]), grid_line_width));//STYLE_DASH，click_line_color_grid
                                    var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
                                    graphic.setAttributes(feature.attributes);
                                    grid_graphics_init[feature.attributes.REPORT_TO_ID] = graphic;
                                    graLayer_wg.add(graphic);

                                    var area = feature.attributes["SHAPE.AREA"];
                                    var font = new esri.symbol.Font("12px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD);
                                    font.setFamily("微软雅黑");

                                    var grid_name = feature.attributes.REPORTTO;
                                    if ($.trim(grid_name) == "")
                                        grid_name = feature.attributes.RESNAME;
                                    grid_name = grid_name.substr(grid_name.indexOf("-") + 1);
                                    var textSymbol = new esri.symbol.TextSymbol(grid_name, font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                                    //textSymbol.setHaloColor(new esri.Color([255, 0, 0]));
                                    //textSymbol.setHaloSize(10);
                                    var name_point = getGravityCenter(geo, temp);

                                    var labelGraphic = new esri.Graphic(name_point, textSymbol);
                                    var grid_geo_attr = new Array();
                                    grid_geo_attr["grid_geo"] = geo;
                                    grid_geo_attr["grid_attr"] = feature.attributes;
                                    grid_geo_attr["grid_fill_gra"] = graphic;
                                    labelGraphic.setAttributes(grid_geo_attr);
                                    area = area * 10000000000;
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

                                //try{
                                //map.addLayer(graLayer_wg_click);
                                var graphics = grid_graphics_init[station_id];
                                //所点网格没有上图，给予提示并放到支局视野范围
                                if (graphics == undefined) {
                                    layer.msg(grid_name_selected + "暂未上图");
                                    map.setExtent(sub_selected_geometry.getExtent());
                                    return;
                                }
                                graLayer_wg_click.clear();

                                var gra = new esri.Graphic(graphics.geometry, linesymbol_grid_selected);
                                graLayer_wg_click.add(gra);
                                //var geo = graphics.geometry;
                                //map.centerAndZoom(getGravityCenter(geo,geo.rings),map.getZoom());
                                //map.setExtent(geo.getExtent().expand(grid_zoom));

                                grid_gra_last = "";
                                grid_gra_clicked = graphics;


                                if (graphics._shape != undefined && graphics._shape != null)
                                    beforeClickColor_grid = graphics._shape.fillStyle;
                                else if (graphics.symbol != undefined && graphics.symbol != null)
                                    beforeClickColor_grid = graphics.symbol.color;

                                //var zoom = map.getZoom();
                                currentOpacity = beforeClickColor_grid.a;
                                highlightSymbol_grid_click.color.a = currentOpacity;
                                graphics.setSymbol(highlightSymbol_grid_click);
                                if (village_position_operat) {
                                    village_position_operat = false;
                                    subToGridFlag = true;
                                } else {
                                    if (zoom1 == 9) {//可能是小区框选功能
                                        map.centerAndZoom(getGravityCenter(graphics.geometry, graphics.geometry.rings), zoom1);
                                    } else
                                        map.setExtent(graphics.geometry.getExtent().expand(1.5));
                                }

                                //	}catch(e){
                                //		console.log(e);
                                //	}
                            });
                            graLayer_wg.redraw();
                            //},2000);
                            //map.addLayer(graLayer_mouseclick);
                            //map.addLayer(graLayer_wg_click);
                        });

                        //右侧联动
                        //parent.freshIndexContainer(indexContainer_url_sub);
                    };

                    //支局下钻到网格
                    var sub_gra_clicked = "";//记录点击过的支局，以便设置其高亮的颜色（在backToSub方法中）
                    var grid_gra_clicked = "";
                    //支局板块点击
                    var featureLayer_click_handler = dojo.connect(featureLayer, "onClick", function (evt) {
                        featureLayer_click(evt);
                    });

                    function featureLayer_click(evt) {
                        dojo.stopEvent(evt);
                        evt.stopPropagation();

                        var graphics = evt.graphic;

                        var sub_selected_geometry = graphics.geometry;
                        var sub_attr = graphics.attributes;

                        subToGrid(graphics, sub_selected_geometry, sub_attr);
                    }

                    //支局名称点击
                    var graLayer_zjname_click_handler = dojo.connect(graLayer_zjname, "onClick", function (evt) {
                        graLayer_zjname_click(evt);
                    });

                    function graLayer_zjname_click(evt) {
                        dojo.stopEvent(evt);
                        evt.stopPropagation();

                        var attrs = evt.graphic.attributes;
                        var graphics = attrs.sub_fill_gra;

                        //定位到所点支局的视野
                        var sub_selected_geometry = attrs.sub_geo;
                        var sub_attr = attrs.sub_attr;

                        subToGrid(graphics, sub_selected_geometry, sub_attr);
                    }

                    //从支局下钻到网格后，是否点击过网格，点击后表示下钻到网格，此时返回才刷新右侧为支局，否则仍然为支局，不刷新
                    var subToGridFlag = false;
                    //从网格返回支局
                    backToSub = function () {
                    		$(".region_switch_group > ul >li").eq(2).addClass("active");
                    	  parent.freshIndexContainer(indexContainer_url_sub);

                    		global_village_id = "";
                        parent.global_report_to_id = "";
                        clearDrawLayer();
                        map.infoWindow.hide();
                        $("#sub_info_win").hide();
                        $("#grid_info_win").hide();

                        $("#village_info_mini_win").hide();

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

                        if (back_to_ext == "")
                            back_to_ext = map.extent;
                        var ext = back_to_ext.getExtent();
                        map.setExtent(ext);

                        //zj_name_show_hide(map.getZoom());

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

                        if (subToGridFlag) {
                            parent.freshIndexContainer(indexContainer_url_sub);
                            subToGridFlag = false;
                        }
                    };
                    parent.backToSub = backToSub;

                    backToCity = function () {
                        //parent.global_current_area_name = city_name;
                        //parent.global_current_full_area_name = city_full_name;
                        //parent.global_current_flag = 2;
                        //parent.global_position.splice(1, 1, parent.global_current_full_area_name);
                        //parent.loadSmallTab(parent.global_current_flag,index_type);
                        //parent.updateTabPosition();
                        //parent.updatePosition(parent.global_current_flag);
                        backToPrevLevel(1);
                    }
                    parent.backToCity = backToCity;

                    backToQx = function () {
                    	village_where = "latn_id = "+city_id;
                    	$("#tools_scroll").show();
                    	$(".region_switch_group").show();
											parent.loadSmallTab(3,index_type,"");
											parent.updatePosition(2);

											var bureau_center_point = geoCoordMap_bureau[city_id][parent.global_position[2]];
                      map.centerAndZoom(bureau_center_point,7);

											global_village_id = "";
                  		village_id_selected = "";
                      //clickedFlag = false;
                      clearDrawLayer();
                      map.infoWindow.hide();

                      $("#village_info_mini_win").hide();
                      if (zxs[city_id] != undefined) {
                          $("#nav_fanhui").show();
                          $("#nav_fanhui_city").hide();
                      }
                      graLayer_subname_result.clear();
                      graLayer_mouseclick.clear();
                      graLayer_mouseclick.hide();
                      parent.clickFlag = false;
                      if (zxs[parent.global_parent_area_name] == 1) {//嘉峪关的特殊处理，返回全市的支局时候,右侧刷新是市级的数据
                          parent.global_current_flag = 2;
                      } else
                          parent.global_current_flag = 3;
                      parent.global_current_area_name = parent.global_position[2];
                      parent.global_current_full_area_name = parent.global_position[2];
                      featureLayer.show();
                      graLayer_zjname.show();
                      hideVillageLayer();

											if(featureLayer_grid!="")
								      	featureLayer_grid.hide();
								      if(grid_name_temp_layer!="")
							        	grid_name_temp_layer.hide();

                      graLayer_qx.show();
                      graLayer_qx_all.show();
                      graLayer_zj_click.clear();
                      graLayer_wg_click.clear();
                      graLayer_wg.hide();
                      graLayer_wg_text.hide();
                      graLayer_grid_mouseover.clear();
                      village_layer.clear();
                      village_position_layer.clear();
                      graLayer_sub_mouseover.clear();
                      //zj_name_show_hide(map.getZoom());

                      //parent.global_position.splice(2, 1, parent.global_current_full_area_name);
                      parent.updatePosition(parent.global_current_flag);
                    };
                    parent.backToQx = backToQx;

                    var map_mouse_move_handler = dojo.connect(map, "onMouseOver", function (evt) {
                        map_mouse_move(evt);
                    });

                    function map_mouse_move(evt) {
                        if (evt.target.id == "gismap_gc") {
                            map.setMapCursor("default");
                            subFillRecover_mouseover();
                        }
                    }

										featureLayer.on("graphic-add", function (evt) {
                        var sub_gra_init = evt.graphic;
                        var sub_attr = sub_gra_init.attributes;
                        sub_graphics_init[sub_attr.SUBSTATION_NO] = sub_gra_init;
                    });
                    //20170614修改 此处是某地市下的市级名称，去分别查询下属的支局集合，用union_org_code拼接去查询地图里的substation
                    var sub_data = new Array();
                    featureLayer.on("update-end", function () {
                        $.post(url4Query_leader, {"eaction": "getSubName_a1", "city_id": city_id}, function (data) {
                            data = $.parseJSON(data);
                            //data = data[0];
                            if (data.length == 0)
                                return;
                            else {
                                var where_temp = "SUBSTATION_NO IN (";
                                for (var i = 0, l = data.length; i < l; i++) {
                                    sub_data[data[i].UNION_ORG_CODE] = data[i].BRANCH_NAME;
                                    var union_org_code = data[i].UNION_ORG_CODE;
                                    where_temp += "'" + union_org_code + "'";
                                    if (i < l - 1)
                                        where_temp += ",";
                                }
                                where_temp += ")";
                                var queryTask1 = new QueryTask(new_url_sub_vaild + sub_layer_index);
                                var query1 = new Query();
                                query1.where = where_temp;
                                query1.outFields = ['SHAPE.AREA', 'RESNAME', 'RESNO', 'SUBSTATION_NO', 'REPORTTO', 'RESID'];
                                query1.returnGeometry = true;
                                queryTask1.execute(query1, function (results) {
                                    if (results.features.length == 0)
                                        return;
                                    for (var j = 0, k = results.features.length; j < k; j++) {
                                        var geo = results.features[j].geometry;
                                        var attr = results.features[j].attributes;
                                        var area = attr["SHAPE.AREA"];
                                        var substation = attr["SUBSTATION_NO"];
                                        var sub_name = sub_data[substation];
                                        var name_point = "";

                                        if (sub_name_speical[city_id] == undefined) {//按latn_id，获取要特殊处理的支局
                                            var temp = geo.rings;
                                            name_point = getGravityCenter(geo, temp);
                                        } else {
                                            if (sub_name_speical[city_id][sub_name] == undefined) {
                                                var temp = geo.rings;

                                                name_point = getGravityCenter(geo, temp);

                                            } else {
                                                name_point = geo;
                                            }
                                        }

                                        var font = new Font("12px", Font.WEIGHT_BOLD, Font.WEIGHT_BOLD, Font.WEIGHT_BOLD, "Microsoft Yahei");
                                        var textSymbol = new TextSymbol(sub_name, font, new Color(sub_name_text_color));
                                        var labelGraphic = new esri.Graphic(name_point, textSymbol);

                                        var sub_geo_attr = new Array();
                                        sub_geo_attr["sub_geo"] = geo;
                                        sub_geo_attr["sub_attr"] = attr;
                                        sub_geo_attr["sub_fill_gra"] = sub_graphics_init[substation];
                                        labelGraphic.setAttributes(sub_geo_attr);
                                        area = area * 10000000000;
                                        if (area > 500000000) {
                                            sub_name_label_symbol7.push(labelGraphic);
                                        } else if (area > 250000000) {
                                            sub_name_label_symbol6.push(labelGraphic);
                                        } else if (area > 200000000) {//zoom=3 地图收到很小
                                            sub_name_label_symbol5.push(labelGraphic);
                                        } else if (area > 70000000) { //zoom=4
                                            sub_name_label_symbol4.push(labelGraphic);
                                        } else if (area > 2500000) { //zoom=5
                                            sub_name_label_symbol3.push(labelGraphic);
                                        } else if (area > 300000) { //zoom=6
                                            sub_name_label_symbol2.push(labelGraphic);
                                        } else { //zoom>=7 地图放到最大，看最清晰的支局
                                            sub_name_label_symbol1.push(labelGraphic);
                                        }
                                    }

                                    try{
						                            //var ext = graphicsUtils.graphicsExtent(results.features);
						                            //map.setExtent(ext.expand(1.5));
						                            //extent_init = ext;
						                            //var center = ext.getCenter();
						                            //map.centerAndZoom(center,ext);
				                            }catch(e){
				                            		console.log(e);
				                            }
                                    //支局名称获取后，根据当前放大级别，绘制名称层

                                });
                            }
                            general_location();
                        });

                       var bureau_center_point = geoCoordMap_bureau[city_id][parent.global_position[2]];
                       map.centerAndZoom(bureau_center_point,7);
                      });
										general_location = function(){
											//首页跳转 首页入口
                      if (parent.global_entrance_type == "sub") {
                          var graphics = sub_graphics_init[parent.global_substation];
                          console.log(Object.keys(sub_graphics_init).length);
                          console.log(graphics);
                          var sub_selected_ext = graphics.geometry.getExtent();
                          map.setExtent(sub_selected_ext.expand(1.5));
                          subToGrid(graphics, graphics.geometry, graphics.attributes);
                          //subToGrid(global_substation,parent.global_position[3],"",need_zoom);
                      } else if (parent.global_entrance_type == "grid") {
                          clickToGrid(parent.global_substation, parent.global_position[3], "", -1, parent.global_position[4], parent.global_report_to_id);
                      }
                      else if (parent.global_entrance_type == "village") {
                      		if(parent.global_report_to_id!=""){
                      			//clickToGrid(parent.global_substation, parent.global_position[3], "", 9, parent.global_position[4], parent.global_report_to_id);
                      			village_where = "report_to_id = '"+parent.global_report_to_id+"'";
                  					village_service_load();
                      		}else{
                      			village_where = "union_org_code = '"+parent.global_substation+"'";
                  					village_service_load();
                      			//subToGrid(graphics, graphics.geometry, graphics.attributes);
                      		}
                      		searchVillage(parent.global_village_id);
                      		operateVillage(parent.global_village_id);
                      		//clickToGridAndVillage(parent.global_substation, parent.global_position[3], "", 9, parent.global_position[4], parent.global_report_to_id, parent.global_village_id,'')
                      }
                      /*else if (left_type_from_province == "build") {
                          standard_position_load(left_standard_id_from_province, parent.global_current_area_name, city_ids[parent.global_current_area_name], "");
                      }*/
										}
										parent.global_location = general_location;

										function searchVillage(village_id){
												var queryTask = new QueryTask(village_service_url + "/0");
                        var query = new Query();
                        query.where = "VILLAGE_ID  = '" + village_id + "'";
                        query.outFields = ['POSITION','VILLAGE_ID'];
                        query.returnGeometry = true;
                        queryTask.execute(query, function (results) {
                        	var k = results.features.length;
                          if (k == 0)//没有对应小区数据
                              return;
                          map.centerAndZoom(results.features[0].geometry,9);
                          villagePosition(village_id,results.features[0]);
                        });
										}
										function villagePosition(village_id,graphic){
												var pointAttributes = {"village_id": village_id};
                        var ico_url1 = village_ico_selected;
                        var size = village_ico_get_size(map.getZoom());
                        village_selected_gra_update = graphic;
                        var img1 = new PictureMarkerSymbol(ico_url1, size, size);
                        var graphic1 = new esri.Graphic(graphic.geometry, img1, pointAttributes);
                        village_position_layer.clear();
                        village_position_layer.add(graphic1);
										}

                    //20170620修改 新增网点展示功能
                    var queryTask_wd = new QueryTask(new_url_point + channel_point_layer_index);
                    var query_wd = new Query();
                    query_wd.where = "CLASS4 = '实体渠道' AND LATN_ID = " + city_id + "";
                    query_wd.outFields = ['CLASS3_ID', 'CHANNEL_NA', 'CHANNEL_AD'];
                    query_wd.returnGeometry = true;
                    var city_geometry = "";//所展示市级范围的图形对象
                    queryTask_wd.execute(query_wd, function (results) {
                        if (results.features.length == 0)
                            return;
                        var current_zoom = map.getZoom();
                        var size = channel_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
                        for (var i = 0, l = results.features.length; i < l; i++) {
                            var feature = results.features[i];
                            var geo = feature.geometry;
                            var class3_id = feature.attributes.CLASS3_ID;

                            var pointAttributes = {
                                CHANNEL_NA: feature.attributes.CHANNEL_NA,
                                CHANNEL_AD: feature.attributes.CHANNEL_AD,
                                CLASS3_ID: class3_id
                            };
                            var img = new PictureMarkerSymbol(channel_ico[class3_id], size, size);
                            var graphic = new esri.Graphic(geo, img, pointAttributes);
                            graLayer_wd.add(graphic);
                        }
                    });

                    var click_time = "";//保存上次点击过的时刻，解决冒泡事件
                    var graLayer_wd_mouse_over_handler = dojo.connect(graLayer_wd, "onMouseOver", function (evt) {
                        graLayer_wd_mouse_over(evt);
                    });

                    function graLayer_wd_mouse_over(evt) {
                        $(".esriPopupWrapper").show()
                        $(".outerPointer").show()
                        dojo.stopEvent(evt);
                        evt.stopPropagation();

                        $("#sub_info_win").hide();
                        $("#grid_info_win").hide();

                        map.infoWindow.hide();
                        map.setMapCursor("pointer");

                        if (click_time == "")//第一次点击
                            click_time = new Date().getTime();
                        else {
                            if (new Date().getTime() - click_time < 100)//两次操作小于半秒，可能是冒泡引起的
                                return;
                            click_time = new Date().getTime();
                        }
                        var attr = evt.graphic.attributes;

                        var address = attr.CHANNEL_AD;

                        map.infoWindow.setTitle("网点信息");
                        map.infoWindow.resize(260, 200);

                        var ems = $("#channel_info_win").find("em");
                        $(ems[0]).html(attr.CHANNEL_NA);
                        $(ems[1]).html(attr.CHANNEL_AD);
                        $(ems[2]).html(channel_type_array[attr.CLASS3_ID]);

                        map.infoWindow.show(evt.screenPoint);
                        $.post(url4Query, {
                            eaction: "index_get_by_channel_name",
                            channel_name: attr.CHANNEL_NA,
                            date: '${yesterday.VAL}',
                            city_name: city_name
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data == '' || data == null) {
                                $(ems[3]).html("- -");
                                $(ems[4]).html("- -");
                                $(ems[5]).html("- -");
                                $(ems[6]).html("- -");
                                $(ems[7]).html("- -");
                                $(ems[8]).html("- -");
                            } else {
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

                    var graLayer_wd_mouse_out_handler = dojo.connect(graLayer_wd, "onMouseOut", function (evt) {
                        graLayer_wd_mouse_out(evt);
                    });

                    function graLayer_wd_mouse_out(evt) {
                        dojo.stopEvent(evt);
                        evt.stopPropagation();
                        var ele = evt.toElement;
                        if (ele && ele.id != 'grid_info_win') {
                            $("#grid_info_win").hide();
                        }
                        $(".esriPopupWrapper").hide();
                        $(".outerPointer").hide();
                    }

                    //20170711 新增 标准地址
                    function standard_load() {
                        standard_layer.clear();
                        var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        if(standard_where!="")
                        	query_standard.where = standard_where;
                        query_standard.geometry = map.extent;
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        var city_geometry = "";//所展示市级范围的图形对象
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0)
                                return;
                            var current_zoom = map.getZoom();
                            var size = standard_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
                            for (var i = 0, l = results.features.length; i < l; i++) {
                                var feature = results.features[i];
                                var geo = feature.geometry;

                                var img = new PictureMarkerSymbol(standard_ico, size, size);
                                var graphic = new esri.Graphic(geo, img, feature.attributes);
                                //var symbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, size, new SimpleLineSymbol(), new Color([210,210,0]));
                                //var graphic = new esri.Graphic(geo,symbol,pointAttributes);
                                standard_layer.add(graphic);
                            }
                        });
                        /*map.addLayer(standard_layer);
                         map.addLayer(village_layer);
                         map.addLayer(village_position_layer);*/
                    }

                    function standard_load2(geotry) {
                        standard_layer.clear();
                        var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        //query_standard.where = map.extent;
                        query_standard.geometry = geotry;
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        var city_geometry = "";//所展示市级范围的图形对象
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0)
                                return;
                            var current_zoom = map.getZoom();
                            var size = standard_point_get_size(current_zoom);//获取当前放大级别下，渠道网点图标的大小
                            for (var i = 0, l = results.features.length; i < l; i++) {
                                var feature = results.features[i];
                                var geo = feature.geometry;

                                var img = new PictureMarkerSymbol(standard_ico, size, size);
                                var graphic = new esri.Graphic(geo, img, feature.attributes);
                                //var symbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, size, new SimpleLineSymbol(), new Color([210,210,0]));
                                //var graphic = new esri.Graphic(geo,symbol,pointAttributes);
                                standard_layer.add(graphic);
                            }
                        });
                        /*map.addLayer(standard_layer);
                         map.addLayer(village_layer);
                         map.addLayer(village_position_layer);*/
                    }

                    var graphic_position = '';
                    standard_position_load = function (res_id, latn_name, latn_id, thiz) {
                        subToGridFlag = false;

                        $(thiz).siblings().removeClass("tr_click_background_color");//background-color: #c1c1c1;
                        $(thiz).siblings().addClass("tr_default_background_color");
                        $(thiz).removeClass("tr_default_background_color");
                        $(thiz).addClass("tr_click_background_color");
                        position_layer.clear();

                        $("#sub_info_win").hide();
                        $("#grid_info_win").hide();

                        $("#village_info_mini_win").hide();

                        $("#nav_fanhui").hide();
                        $("#nav_fanhui_sub").hide();
                        $("#nav_fanhui_qx").show();
                        $("#nav_fanhui_city").hide();

                        graLayer_subname_result.clear();
                        graLayer_mouseclick.clear();

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

                        featureLayer.show();
                        graLayer_zjname.show();
                        graLayer_qx.show();
                        graLayer_qx_all.show();
                        //地市改变，图层改变
                        /*if(city_full_name.indexOf(latn_name)<=0){
                         changeMapToCity(latn_name,latn_id);
                         }*/
                        //右侧联动到楼宇所在 网格,通过地理位置关联

                        var build_geo = "";
                        var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        //query_standard.where = map.extent;
                        query_standard.where = "RESID='" + res_id + "'"
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0) {
                                layer.msg("该楼宇未上图")
                                return;
                            }
                            standard_layer.clear();

                            var current_zoom = map.getZoom();
                            var size = standard_point_get_size(current_zoom)
                            var geo = results.features[0].geometry;
                            build_geo = geo;
                            var x = geo.x;
                            var y = geo.y;

                            graphic_position = new Graphic(geo, point_selected_mark, results.features[0].attributes);
                            position_layer.add(graphic_position);
                            map.centerAndZoom([x, y], 10);
                            //显示弹窗10
                            var evt = {}
                            evt.graphic = results.features[0];
                            evt.graphic.attributes = results.features[0].attributes;
                            evt.close = 1;

                            standard_layer_click(evt);

                        });
                    }
                    function queryAndSetGrid(evt) {
                        parent.global_substation = "";
                        parent.global_current_full_area_name = city_full_name;
                        parent.global_current_area_name = city_name;
                        parent.global_current_flag = 2;
                        global_position_build_view = new Array(5);
                        global_position_build_view.splice(0, 1, city_name);
                        var attr = evt.graphic.attributes;
                        //若楼宇属性里分局为空，则数据没有空间数据，从地图查询其位置
                        if (attr.BUREAU_NAME == undefined || attr.BUREAU_NAME == null || attr.BUREAU_NAME == "null") {
                            var build_geo = evt.graphic.geometry;
                            //归属区县查询
                            var queryTask_qx = new QueryTask(layer_ds + "/" + city_gis_tiled_layerids[city_name]);
                            var queryqx = new Query();
                            queryqx.geometry = build_geo;
                            queryqx.outFields = ["NAME"];
                            queryqx.returnGeometry = false;
                            queryTask_qx.execute(queryqx, function (results2) {
                                if (results2.features.length == 0) {
                                    //layer.msg("未找到所归属的区县");
                                    //parent.global_position.splice(2, 1, undefined);
                                    parent.freshIndexContainer(indexContainer_url_bearue);
                                    return;
                                }
                                parent.global_current_flag = 3;
                                var qx_name = results2.features[0].attributes.NAME;
                                //parent.global_position.splice(2, 1, qx_name);
                                global_position_build_view.splice(1, 1, qx_name);

                                var queryTask_sub = new QueryTask(new_url_sub_vaild + sub_layer_index);
                                var querysub = new Query();
                                querysub.geometry = build_geo;
                                querysub.outFields = ["SUBSTATION_NO", "RESNAME"];
                                querysub.returnGeometry = false;
                                queryTask_sub.execute(querysub, function (results1) {
                                    if (results1.features.length == 0) {
                                        //layer.msg("未找到所归属的支局");
                                        parent.global_position.splice(3, 1, undefined);
                                        parent.freshIndexContainer(indexContainer_url_bearue);
                                        return;
                                    }
                                    parent.global_current_flag = 4;
                                    sub_gra_clicked = sub_graphics_init[results1.features[0].attributes.SUBSTATION_NO];
                                    parent.global_position.splice(3, 1, sub_data[results1.features[0].attributes.SUBSTATION_NO]);
                                    global_position_build_view.splice(2, 1, sub_data[results1.features[0].attributes.SUBSTATION_NO]);

                                    /*$.post(url4Query,{eaction:"setgrids",id:sub_attr.SUBSTATION_NO,latn_id:city_id},function (data) {
						                        	data = $.parseJSON(data);
						                        	if(data.length==0){
						                        		//在划小下，该支局下没有网格
						                        		return;
						                        	}else{}
						                        });*/

                                    var queryTask_grid = new QueryTask(new_url_grid_vaild + grid_layer_index);
                                    var query_grid = new Query();
                                    query_grid.geometry = build_geo;
                                    query_grid.outFields = ["RESNAME", "REPORTTO", "REPORT_TO_ID"];
                                    query_grid.returnGeometry = false;
                                    queryTask_grid.execute(query_grid, function (results) {
                                        if (results.features.length == 0) {
                                            //layer.msg("未找到所归属的网格")
                                            parent.global_position.splice(4, 1, undefined);
                                            parent.freshIndexContainer(indexContainer_url_sub);
                                            return;
                                        }
                                        parent.global_current_flag = 5;
                                        parent.global_position.splice(4, 1, grid_name);
                                        var grid_name = results.features[0].attributes.REPORTTO;
                                        if ($.trim(grid_name) == "")
                                            grid_name = results.features[0].attributes.RESNAME;
                                        global_position_build_view.splice(3, 1, grid_name);

                                        if(add4_click_flag){
                                        	add4_click_flag = false;
                                        }else{
                                        	gridToEnd(results.features[0].attributes);
                                        }
                                    });
                                });
                            });
                        } else {
                            parent.global_position.splice(3, 1, sub_data[attr.UNION_ORG_CODE]);
                            parent.global_substation = attr.UNION_ORG_CODE;
                            //获取分局对应的区县
                            $.post(url4Query,{"eaction":"getQXNameByBureauNo","bureau_no":attr.BUREAU_NO},function(data){
                            	if(data!=null){
                            		data = $.parseJSON(data);
                            		//parent.global_position.splice(2, 1, data.BUREAU_NAME);
                            		global_position_build_view.splice(1, 1, data.BUREAU_NAME);
                            	}else{
                            		//parent.global_position.splice(2, 1, attr.BUREAU_NAME);
                            		global_position_build_view.splice(1, 1, attr.BUREAU_NAME);
                            	}

                            	global_position_build_view.splice(2, 1, sub_data[attr.UNION_ORG_CODE]);
                            sub_gra_clicked = sub_graphics_init[attr.UNION_ORG_CODE];

                            //支局下没有网格时
                            if (attr.GRID_UNION_ORG_CODE == "" || attr.GRID_UNION_ORG_CODE == "null" || attr.GRID_UNION_ORG_CODE == null) {
                                parent.global_current_flag = 4;
                                parent.global_current_full_area_name = sub_data[attr.UNION_ORG_CODE];
                                parent.global_current_area_name = sub_data[attr.UNION_ORG_CODE];

                                if(add4_click_flag){
                                	add4_click_flag = false;
                                }else{
                                	village_load_by_sub(attr.UNION_ORG_CODE, global_village_id);
                                }
                                parent.freshIndexContainer(indexContainer_url_sub);
                            } else {//支局下有网格时
                                parent.global_current_flag = 5;
                                parent.global_current_full_area_name = attr.GRID_NAME;
                                parent.global_current_area_name = attr.GRID_NAME;

                                parent.global_position.splice(4, 1, attr.GRID_NAME);

                                global_position_build_view.splice(3, 1, attr.GRID_NAME);

                                $.post(url4Query, {
                                    "eaction": "getMapGridIdByGridUnionOrgCode",
                                    "latn_id": city_id,
                                    "grid_union_org_code": attr.GRID_UNION_ORG_CODE
                                }, function (data) {
                                    data = $.parseJSON(data);
                                    if (data != null) {
                                        parent.global_report_to_id = data.STATION_ID;
                                        //village_load(data.STATION_ID, global_village_id);
                                        parent.freshIndexContainer(indexContainer_url_grid);
                                        if(add4_click_flag){
                                        	add4_click_flag = false;
                                        }else{
                                        	gridToEnd({REPORTTO: attr.GRID_NAME, REPORT_TO_ID: data.STATION_ID});
                                        }
                                    }
                                });
                            }
                            });
                        }
                    }

                    /*yinming 2017年7月20日15:13:58 小区定位*/
                    position_village = function (x, y, res_id) {
                        standard_layer.clear();
                        position_layer.clear();
                        var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        //query_standard.where = map.extent;
                        query_standard.where = "RESID='" + res_id + "'";
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        queryTask_standard.execute(query_standard, function (results) {
                            map.addLayer(position_layer)
                            var current_zoom = map.getZoom();

                            var geo = results.features[0].geometry;
                            graphic_position = new Graphic(geo, point_selected_mark);//
                            position_layer.add(graphic_position);
                            map.centerAndZoom([x, y], 10);//
                        });

                    }

                    var standard_layer_mouse_over_handler = dojo.connect(standard_layer, "onMouseOver", function (evt) {
                        map.setMapCursor("pointer");
                        //standard_layer_click(evt);
                        /*map.infoWindow.setTitle("楼宇名称");
                         map.infoWindow.resize(260,200);
                         var attr = evt.graphic.attributes;
                         var content = "<span>"+attr.RESFULLNAME+"</span>";
                         map.infoWindow.setContent(content);
                         map.infoWindow.show(evt.screenPoint);*/
                        $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                        $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                        $("#village_info_mini_win").show();
                    });

                    var draw_layer_mark_build_mouse_over_handler = dojo.connect(draw_layer_mark_build, "onMouseOver", function (evt) {
                        map.setMapCursor("pointer");
                        //standard_layer_click(evt);
                        /*map.infoWindow.setTitle("楼宇名称");
                         map.infoWindow.resize(260,200);
                         var attr = evt.graphic.attributes;
                         var content = "<span>"+attr.RESFULLNAME+"</span>";
                         map.infoWindow.setContent(content);
                         map.infoWindow.show(evt.screenPoint);*/
                        $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                        $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                        $("#village_info_mini_win").show();
                    });

                    var drawed_layer_mark_build_mouse_over_handler = dojo.connect(drawed_layer_mark_build, "onMouseOver", function (evt) {
                        map.setMapCursor("pointer");
                        //standard_layer_click(evt);
                        /*map.infoWindow.setTitle("楼宇名称");
                         map.infoWindow.resize(260,200);
                         var attr = evt.graphic.attributes;
                         var content = "<span>"+attr.RESFULLNAME+"</span>";
                         map.infoWindow.setContent(content);
                         map.infoWindow.show(evt.screenPoint);*/
                        $("#village_info_mini_win").html(evt.graphic.attributes.RESFULLNAME);
                        $("#village_info_mini_win").css({top: evt.pageY - 15, left: evt.pageX + 15});
                        $("#village_info_mini_win").show();
                    });

                    var standard_layer_mouse_out_handler = dojo.connect(standard_layer, "onMouseOut", function (evt) {
                        map.setMapCursor("default");
                        //map.infoWindow.hide();
                        $("#village_info_mini_win").hide();
                    });

                    var draw_layer_mark_build_mouse_out_handler = dojo.connect(draw_layer_mark_build, "onMouseOut", function (evt) {
                        map.setMapCursor("default");
                        //map.infoWindow.hide();
                        $("#village_info_mini_win").hide();
                    });

                    var drawed_layer_mark_build_mouse_out_handler = dojo.connect(drawed_layer_mark_build, "onMouseOut", function (evt) {
                        map.setMapCursor("default");
                        //map.infoWindow.hide();
                        $("#village_info_mini_win").hide();
                    });

                    var standard_layer_click_handler = dojo.connect(standard_layer, "onClick", function (evt) {
                        standard_layer_click(evt);
                    });

                    var draw_layer_mark_build_click_handler = dojo.connect(draw_layer_mark_build, "onClick", function (evt) {
                        standard_layer_click(evt);
                    });

                    var drawed_layer_mark_build_click_handler = dojo.connect(drawed_layer_mark_build, "onClick", function (evt) {
                        standard_layer_click(evt);
                    });

                    var add4_click_flag = false;
                    function standard_layer_click(evt) {
                    		add4_click_flag = true;
                    		village_id_selected = "";
                        $("#village_info_win").hide();
                        var attr = evt.graphic.attributes;

                        queryAndSetGrid(evt);
                        var graphic_position = new Graphic(evt.graphic.geometry, point_selected_mark);
                        position_layer.clear();
                        //village_position_layer.clear();
                        position_layer.add(graphic_position);
                        //RESFULLNAME: "嘉峪关市镜铁区青禾园A3号楼西侧车库"
                        //RESID:
                        showBuildDetail(attr.RESID, attr.RESFULLNAME, 'all', 0, 0);
                    }

                    /* lixiaofeng 楼宇 详情页7.21.15.12↓*/
                    showBuildDetail = function (res_id, str, visible, page, c, query_id) {
                        layer.closeAll()
                        if (res_id == "null") {
                            layer.msg("暂无“" + str + "”的楼宇信息");
                            return;
                        }
                        $("#nav_standard").removeClass("active");
                        $("#nav_marketing").removeClass("active");
                        $("#nav_marketing_village").removeClass("active");
                        tmpy = '1';
                        tmpl = '1';
                        tmpy_v = '1';
                        $("#detail_more").show();

                        if (page == 0) {
                            //$(".build_more_win").html(" <div class=\"titlea\"><div id=\"build_more_title\" style='text-align:left;width:90%;display: inline-block;padding-bottom:5px'>楼宇视图</div><div  class=\"titlec\" id='build_more_close'></div></div>")
                            $("#detail_more > iframe").attr("src", '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_build_view_details_new.jsp" />?res_id=' + res_id + '&vis=' + visible + '&village_id=' + query_id);
                        } else if (page == 1) {
                            $("#detail_more > iframe").attr("src",'<e:url value="/pages/telecom_Index/sub_grid/viewPlane_build_view_details_new.jsp" />?res_id=' + res_id + '&vis=' + visible + '&village_id=' + query_id);
                            //$(".build_more_win").html(" <div class=\"titlea\"><div id=\"build_more_title\" style='text-align:left;width:90%;display: inline-block;padding-bottom:5px'>营销详情</div><div  class=\"titlec\" id='build_more_close'></div></div>")
                            // $("#detail_more > iframe").attr("src","/pages/telecom_Index/sub_grid/viewPlane_build_view_details_new.jsp" />?res_id="+res_id+"&vis="+visible)
                        } else if (page == 4) {
                            $("#detail_more > iframe").attr("src", '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_build_view_details_new.jsp" />?res_id=' + res_id + '&vis=' + visible + '&tab_flag=4' + '&village_id=' + query_id);
                        }
                        $("#build_more_close").unbind();
                        $("#build_more_close").on("click", function () {
                            $(".build_more_win").hide()
                            if (c == 1) {
                                $("#nav_standard").click()
                            }
                        })
                    }


                    var showGridInfoWin = function (graphic, attr) {
                        map.setMapCursor("pointer");

                        gridFillRecover_mouseover();

                        if (grid_gra_clicked != "") {
                            if (grid_gra_clicked.attributes["RESID"] == graphic.attributes["RESID"]) {
                                //颜色不做操作
                            } else {
                                //记录此次网格及其颜色，以便下次还原
                                grid_gra_last = graphic;
                                beforeMouseOverColor_grid = grid_gra_last._shape.fillStyle;

                                //设置高亮显示
                                var zoom = map.getZoom();
                                currentOpacity = getLayerOpacity(zoom);
                                highlightSymbol_grid_mouse_over.color.a = currentOpacity;
                                graphic.setSymbol(highlightSymbol_grid_mouse_over);
                            }
                        } else {
                            //记录此次网格及其颜色，以便下次还原
                            grid_gra_last = graphic;
                            beforeMouseOverColor_grid = grid_gra_last._shape.fillStyle;

                            //设置高亮显示
                            var zoom = map.getZoom();
                            currentOpacity = getLayerOpacity(zoom);
                            highlightSymbol_grid_mouse_over.color.a = currentOpacity;
                            graphic.setSymbol(highlightSymbol_grid_mouse_over);
                        }

                        var grid_name = attr.REPORTTO;
                        if ($.trim(grid_name) == "")
                            grid_name = attr.RESNAME;

                        var report_to_id = attr.REPORT_TO_ID;
                        report_to_id = $.trim(report_to_id);

                        return;
//						if(report_to_id==""||report_to_id=="null")
//							win_content = "<span>暂无关联数据</span>";
//						else{
                        $.post(url4Query, {
                            eaction: 'getGridDevByRepttoNo',
                            repttoNo: report_to_id,
                            date: '${yesterday.VAL}'
                        }, function (data) {
                            data = $.parseJSON(data);
                            if (data == null || data == "")
                                win_content = "<span>暂无关联数据</span>";
                            else {
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
                                $(ems[0]).html(grid_name.substr(grid_name.indexOf("-") + 1));

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

                                $("#grid_info_win").css("visibility", "visible");
                                $("#grid_info_win").show();
                            }
//								map.infoWindow.setContent(win_content);
                        });
//						}
                    }

                    var graLayer_wg_mouse_over_handler = dojo.connect(graLayer_wg, "onMouseOver", function (evt) {
                        graLayer_wg_mouse_over(evt);
                    });

                    function graLayer_wg_mouse_over(evt) {
                        map.infoWindow.hide();
                        dojo.stopEvent(evt);
                        evt.stopPropagation();
                        var graphics = evt.graphic;
                        var attr = graphics.attributes;
                        showGridInfoWin(graphics, attr);
                    };
                    var graLayer_wg_text_mouse_over_handler = dojo.connect(graLayer_wg_text, "onMouseOver", function (evt) {
                        graLayer_wg_text_mouse_over(evt);
                    });

                    function graLayer_wg_text_mouse_over(evt) {
                        map.infoWindow.hide();
                        dojo.stopEvent(evt);
                        evt.stopPropagation();
                        var attrs = evt.graphic.attributes;
                        var graphics = attrs["grid_fill_gra"];
                        var attr = attrs["grid_attr"];
                        showGridInfoWin(graphics, attr);
                    }

                    var graLayer_wg_mouse_out_handler = dojo.connect(graLayer_wg, "onMouseOut", function (evt) {
                        graLayer_wg_mouse_out(evt);
                    });

                    function graLayer_wg_mouse_out(evt) {
                        dojo.stopEvent(evt);
                        evt.stopPropagation();
                        map.setMapCursor("default");
                        gridFillRecover_mouseover();
                        var ele = evt.toElement;
                        if (ele == null || ele.id != 'grid_info_win') {
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
                    var graLayer_wg_text_mouse_out_handler = dojo.connect(graLayer_wg_text, "onMouseOut", function (evt) {
                        graLayer_wg_text_mouse_out(evt);
                    });

                    function graLayer_wg_text_mouse_out(evt) {
                        dojo.stopEvent(evt);
                        evt.stopPropagation();
                        gridFillRecover_mouseover();
                        $("#grid_info_win").hide();
                    }

                    //网格点击事件
                    var graLayer_wg_click_handler = dojo.connect(graLayer_wg, "onClick", function (evt) {
                        graLayer_wg_click_f(evt);
                    });

                    function graLayer_wg_click_f(evt) {
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
                        for (var i = 0, l = wg_gracs.length; i < l; i++) {
                            if (wg_gracs[i].attributes.RESID == grid_gra_clicked.attributes.RESID)
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

                        graLayer_wg_text.redraw();
                    }

                    //网格名称点击事件
                    var graLayer_wg_text_click_handler = dojo.connect(graLayer_wg_text, "onClick", function (evt) {
                        graLayer_wg_text_click(evt);
                    });

                    function graLayer_wg_text_click(evt) {
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
                        for (var i = 0, l = wg_gracs.length; i < l; i++) {
                            if (wg_gracs[i].attributes.RESID == grid_gra_clicked.attributes.RESID)
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

                    var village_layer_mouse_over_handler = dojo.connect(village_layer, "onMouseOver", function (evt) {
                        map.setMapCursor("pointer");
                        village_mouse_over_when_draw_f(evt);
                    });
                    var village_layer_mouse_out_handler = dojo.connect(village_layer, "onMouseOut", function (evt) {
                        map.setMapCursor("default");
                        village_mouse_out_when_draw_f(evt);
                    });
                    var village_layer_click_handler = dojo.connect(village_layer, "onClick", function (evt) {
                        layer.closeAll();
                        var village_Id = evt.graphic.attributes.village_id;
                        operateVillage(village_Id);
                        var pointAttributes = {"village_id": village_Id};
                        var ico_url1 = village_ico_selected;
                        var size = village_ico_get_size(map.getZoom());
                        village_selected_gra_update = evt.graphic;
                        var img1 = new PictureMarkerSymbol(ico_url1, size, size);
                        var graphic1 = new esri.Graphic(evt.graphic.geometry, img1, pointAttributes);
                        village_position_layer.clear();
                        village_position_layer.add(graphic1);
                    });

                    var village_selected_layer_mouse_over_handler = dojo.connect(village_position_layer, "onMouseOver", function (evt) {
                        map.setMapCursor("pointer");
                        village_mouse_over_when_draw_f(evt);
                    });
                    var village_selected_layer_mouse_out_handler = dojo.connect(village_position_layer, "onMouseOut", function (evt) {
                        map.setMapCursor("default");
                        village_mouse_out_when_draw_f(evt);
                    });
                    var village_selected_layer_click_handler = dojo.connect(village_position_layer, "onClick", function (evt) {
                        tmpx = '1';
                        $("#nav_village").removeClass("active");
                        layer.closeAll();
                        village_selected_gra_update = evt.graphic;
                        operateVillage(evt.graphic.attributes.village_id);
                    });

                    //校园图标响应事件
                    var school_GraphicsLayer_mouse_over_handler = dojo.connect(school_GraphicsLayer, "onMouseOver", function (evt) {
										    map.setMapCursor("pointer");
										    school_mouse_over_when_draw_f(evt);
										});
										var school_GraphicsLayer_mouse_out_handler = dojo.connect(school_GraphicsLayer, "onMouseOut", function (evt) {
										    map.setMapCursor("default");
										    school_mouse_out_when_draw_f(evt);
										});
										//学校点击 校园点击
										var school_GraphicsLayer_click_handler = dojo.connect(school_GraphicsLayer, "onClick", function (evt) {
										    layer.closeAll();
										    var school_id = evt.graphic.attributes.school_id;
										    village_gras_array[school_id] = evt.graphic;
										    operateVillage(school_id);
										    var pointAttributes = {"school_id": school_id,"school_name": evt.graphic.attributes.school_name};
										    var ico_url1 = school_ico_selected;
										    var size = village_ico_get_size(map.getZoom());
										    village_selected_gra_update = evt.graphic;
										    var img1 = new PictureMarkerSymbol(ico_url1, size, size);
										    var graphic1 = new esri.Graphic(evt.graphic.geometry, img1, pointAttributes);
										    school_GraphicsLayer_selected.clear();
										    school_GraphicsLayer_selected.add(graphic1);
										});

										var school_GraphicsLayer_selected_mouse_over_handler = dojo.connect(school_GraphicsLayer_selected, "onMouseOver", function (evt) {
										    map.setMapCursor("pointer");
										    school_mouse_over_when_draw_f(evt);
										});
										var school_GraphicsLayer_selected_mouse_out_handler = dojo.connect(school_GraphicsLayer_selected, "onMouseOut", function (evt) {
										    map.setMapCursor("default");
										    school_mouse_out_when_draw_f(evt);
										});
										var school_GraphicsLayer_selected_click_handler = dojo.connect(school_GraphicsLayer_selected, "onClick", function (evt) {
										    tmpx = '1';
										    $("#nav_village").removeClass("active");
										    layer.closeAll();
										    village_selected_gra_update = evt.graphic;
										    operateVillage(evt.graphic.attributes.school_id);
										});

										//商客图标响应事件
										var enterprise_GraphicsLayer_mouse_over_handler = dojo.connect(enterprise_GraphicsLayer, "onMouseOver", function (evt) {
										    map.setMapCursor("pointer");
										    enterprise_mouse_over_when_draw_f(evt);
										});
										var enterprise_GraphicsLayer_mouse_out_handler = dojo.connect(enterprise_GraphicsLayer, "onMouseOut", function (evt) {
										    map.setMapCursor("default");
										    enterprise_mouse_out_when_draw_f(evt);
										});
										//学校点击 商客点击
										var enterprise_GraphicsLayer_click_handler = dojo.connect(enterprise_GraphicsLayer, "onClick", function (evt) {
										    layer.closeAll();
										    var enterprise_id = evt.graphic.attributes.enterprise_id;
										    village_gras_array[enterprise_id] = evt.graphic;
										    operateVillage(enterprise_id);
										    var pointAttributes = {"enterprise_id": enterprise_id,"school_name": evt.graphic.attributes.enterprise_name};
										    var ico_url1 = enterprise_ico_selected;
										    var size = village_ico_get_size(map.getZoom());
										    village_selected_gra_update = evt.graphic;
										    var img1 = new PictureMarkerSymbol(ico_url1, size, size);
										    var graphic1 = new esri.Graphic(evt.graphic.geometry, img1, pointAttributes);
										    enterprise_GraphicsLayer_selected.clear();
										    enterprise_GraphicsLayer_selected.add(graphic1);
										});

										var enterprise_GraphicsLayer_selected_mouse_over_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onMouseOver", function (evt) {
										    map.setMapCursor("pointer");
										    enterprise_mouse_over_when_draw_f(evt);
										});
										var enterprise_GraphicsLayer_selected_mouse_out_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onMouseOut", function (evt) {
										    map.setMapCursor("default");
										    enterprise_mouse_out_when_draw_f(evt);
										});
										var enterprise_GraphicsLayer_selected_click_handler = dojo.connect(enterprise_GraphicsLayer_selected, "onClick", function (evt) {
										    tmpx = '1';
										    $("#nav_village").removeClass("active");
										    layer.closeAll();
										    village_selected_gra_update = evt.graphic;
										    operateVillage(evt.graphic.attributes.enterprise_id);
										});

                    //20170715 新增 小区上图功能
                    villageToMap = function () {
                        var user_id = '${sessionScope.UserInfo.LOGIN_ID}';
                        if (user_id == "") {
                            layer.msg("与服务器连接断开，请重新登录");
                            return;
                        }

                        var gra = grid_graphics_init[parent.global_report_to_id];
                        if (gra == undefined) {
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
                        sfs.setOutline(new SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL, new Color([0, 0, 0]), 1));
                        sfs.setColor(new Color([255, 210, 0, 0.2]));


                        var gra_grid = new Graphic(gra.geometry, sfs);
                        graLayer_wg_for_village.clear();
                        graLayer_wg_for_village.add(gra_grid);

                        //放大到要加小区的网格范围视野
                        map.setExtent(gra.geometry.getExtent().expand(1.5));
                        draw_type = "village";
                        drawEnable('');
                    }
                    parent.villageToMap = villageToMap;

                    var village_updated_position = "";

                    function queryBuildFunc(v_id_temp, ids_str_temp, v_position) {
                        var queryTask_standard = new QueryTask(standard_address);
                        var query_standard = new Query();
                        query_standard.where = ids_str_temp;

                        //query_standard.geometry = map.extent;
                        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                        query_standard.returnGeometry = true;
                        var city_geometry = "";//所展示市级范围的图形对象
                        var v_id = v_id_temp;
                        queryTask_standard.execute(query_standard, function (results) {
                            if (results.features.length == 0) {
                                //layer.msg("地图数据中不包含查询结果");
                                return;
                            }

                            //将绘制过小区的楼宇用一个颜色标记出来(standard_ico_used)，以便和未使用的楼宇区别
                            var gra_array = new Array();
                            for (var i = 0, l = results.features.length; i < l; i++) {
                                var geo = results.features[i].geometry;

                                var size = standard_point_get_size(map.getZoom());
                                var build_img = new PictureMarkerSymbol(standard_ico_used, size, size);
                                var build_gra = new esri.Graphic(geo, build_img, results.features[i].attributes);
                                drawed_layer_mark_build.add(build_gra);

                                gra_array.push(new Graphic(geo));
                            }

                            //小区的图标展现
                            var ico_url = village_ico;
                            var size = village_ico_get_size(map.getZoom());
                            var village_img = new PictureMarkerSymbol(ico_url, size, size);
                            var village_graphic = "";

                            //计算一次新的中心点
                            var ext = graphicsUtils.graphicsExtent(gra_array);
                            var center = ext.getCenter();

                            var point_str = v_position;//旧的小区中心点
                            var new_center_point = point_str;//新的小区中心点位置
                            var point_array = new Array();//小区坐标，x,y

                            if ((center.x + "," + center.y) != point_str) {
                                new_center_point = center.x + "," + center.y;//新旧不同，以新的为主，并更新小区中心点位置
                                saveVillagePosition(new_center_point, v_id);
                                point_array.push(center.x);
                                point_array.push(center.y);
                                village_updated_position = new_center_point;
                            } else {
                                point_array = point_str.split(",");
                            }
                            if (village_selected_gra_update != "" && village_selected_gra_update!=undefined)
                                village_layer.remove(village_gras_array[village_selected_gra_update.attributes.village_id]);//删除旧的小区位置
                            village_graphic = new esri.Graphic(new Point(parseFloat(point_array[0]), parseFloat(point_array[1]), new SpatialReference({wkid: 4326})), village_img, {"village_id": v_id});
                            village_layer.add(village_graphic);//绘制新的小区位置
                        });
                    }

                    function saveVillagePosition(center, v_id) {
                        $.post(url4Query, {
                            "eaction": "saveVillagePosition",
                            "v_center": center,
                            "village_id": v_id
                        }, function (data) {

                        });
                    }

                    var ids_str_temp = "";
                    var ids_str_array = "";
                    var village_id_selected = "";
                    //var village_id_array = "";
                    //liangliyuan 20170720 新增 小区服务功能 ↓
                    function village_load(where, village_id_selected_temp) {
                        //village_id_selected = village_id_selected_temp;
                        village_layer.clear();
                        village_position_layer.clear();
                        draw_layer_mark_build.clear();
                        drawed_layer_mark_build.clear();
                        //map.removeLayer(village_layer);
                        //map.removeLayer(village_position_layer);
                        //village_id_array = new Array();
                        drawed_graphics_array_for_buildInVillage = new Array();
                        village_gras_array = new Array();

                        ids_str_array = new Array();
                        $.post(url4Query, {eaction: "getVillages", grid_id: where}, function (data1) {
                            data1 = $.parseJSON(data1);

                            if (data1 != null) {
                                for (var j = 0, k = data1.length; j < k; j++) {
                                    var d1 = data1[j];
                                    var v_id = d1.VILLAGE_ID;
                                    //village_id_array.push(v_id);

                                    $.post(url4Query, {eaction: "getBuildIds", village_id: v_id}, function (data) {
                                        data = $.parseJSON(data);
                                        if (data != null) {
                                            var v_id_temp = "";
                                            var v_center = "";
                                            var ids_str = "RESID in (";
                                            for (var i = 0, l = data.length; i < l; i++) {
                                                var d = data[i];
                                                if (i == 0) {
                                                    v_id_temp = d.VILLAGE_ID;
                                                    v_center = d.POSITION;
                                                }

                                                ids_str += "'" + d.SEGM_ID + "'";
                                                if (i < l - 1)
                                                    ids_str += ",";
                                            }
                                            ids_str += ")";
                                            ids_str_temp = ids_str;
                                            ids_str_array[v_id_temp + "_"] = ids_str_temp;

                                            queryBuildFunc(v_id_temp, ids_str_temp, v_center);
                                        } else {
                                            layer.msg("该小区下包含任何楼宇信息");
                                            return;
                                        }

                                    });
                                }
                                /*map.addLayer(village_layer);
                                 map.addLayer(village_position_layer);*/
                            } else {
                                //layer.msg("该网格下没有小区信息");
                            }
                        });
                    }

                    function village_load_by_sub(where, village_id_selected_temp) {
                        //village_id_selected = village_id_selected_temp;
                        village_layer.clear();
                        village_position_layer.clear();
                        draw_layer_mark_build.clear();
                        drawed_layer_mark_build.clear();
                        //map.removeLayer(village_layer);
                        //map.removeLayer(village_position_layer);
                        //village_id_array = new Array();
                        drawed_graphics_array_for_buildInVillage = new Array();

                        ids_str_array = new Array();
                        $.post(url4Query, {eaction: "getVillagesBySubId", substation: where}, function (data1) {
                            data1 = $.parseJSON(data1);

                            if (data1 != null) {
                                for (var j = 0, k = data1.length; j < k; j++) {
                                    var d1 = data1[j];
                                    var v_id = d1.VILLAGE_ID;
                                    //village_id_array.push(v_id);
                                    $.post(url4Query, {eaction: "getBuildIds", village_id: v_id}, function (data) {
                                        data = $.parseJSON(data);
                                        if (data != null) {
                                            var v_id_temp = "";
                                            var v_center = "";
                                            var ids_str = "RESID in (";
                                            for (var i = 0, l = data.length; i < l; i++) {
                                                var d = data[i];
                                                if (i == 0) {
                                                    v_id_temp = d.VILLAGE_ID;
                                                    v_center = d.POSITION;
                                                }

                                                ids_str += "'" + d.SEGM_ID + "'";
                                                if (i < l - 1)
                                                    ids_str += ",";
                                            }
                                            ids_str += ")";
                                            ids_str_temp = ids_str;
                                            ids_str_array[v_id_temp + "_"] = ids_str_temp;

                                            queryBuildFunc(v_id_temp, ids_str_temp, v_center);

                                        } else {
                                            layer.msg("该小区下包含任何楼宇信息");
                                            return;
                                        }
                                    });
                                }
                            } else {
                                //layer.msg("该支局下没有小区信息");
                            }
                        });
                    }

                    function village_load_by_sub_only(substation){
                    	village_layer.clear();
                      village_position_layer.clear();
                      draw_layer_mark_build.clear();
                      drawed_layer_mark_build.clear();
                      //map.removeLayer(village_layer);
                      //map.removeLayer(village_position_layer);
                      //village_id_array = new Array();
                      drawed_graphics_array_for_buildInVillage = new Array();

                      ids_str_array = new Array();
                      $.post(url4Query, {eaction: "getVillagesBySubIdOnly", substation: substation}, function (data1) {
                          data1 = $.parseJSON(data1);

                          if (data1 != null) {
                              for (var j = 0, k = data1.length; j < k; j++) {
                                  var d1 = data1[j];
                                  var v_id = d1.VILLAGE_ID;
                                  //village_id_array.push(v_id);
                                  $.post(url4Query, {eaction: "getBuildIds", village_id: v_id}, function (data) {
                                      data = $.parseJSON(data);
                                      if (data != null) {
                                          var v_id_temp = "";
                                          var v_center = "";
                                          var ids_str = "RESID in (";
                                          for (var i = 0, l = data.length; i < l; i++) {
                                              var d = data[i];
                                              if (i == 0) {
                                                  v_id_temp = d.VILLAGE_ID;
                                                  v_center = d.POSITION;
                                              }

                                              ids_str += "'" + d.SEGM_ID + "'";
                                              if (i < l - 1)
                                                  ids_str += ",";
                                          }
                                          ids_str += ")";
                                          ids_str_temp = ids_str;
                                          ids_str_array[v_id_temp + "_"] = ids_str_temp;

                                          queryBuildFunc(v_id_temp, ids_str_temp, v_center);

                                      } else {
                                          layer.msg("该小区下未包含任何楼宇信息");
                                          return;
                                      }
                                  });
                              }
                          } else {
                              //layer.msg("该支局下没有小区信息");
                          }
                      });
                    }

                    var village_gras_array = new Array();
                    village_layer.on("graphic-add", function (evt) {
                        var gra = evt.graphic;
                        var attr = gra.attributes;
                        var id = attr.village_id;
                        village_gras_array[id] = gra;
                        if (id == village_id_selected || id == global_village_id) {
                            ico_url = village_ico_selected;
                            var size = village_ico_get_size(map.getZoom());

                            img = new PictureMarkerSymbol(ico_url, size, size);
                            var graphic1 = new esri.Graphic(gra.geometry, img, attr);

                            village_position_layer.clear();
                            village_position_layer.add(graphic1);
                            village_position_layer.redraw();

                            draw_layer_mark_build.clear();
                            var queryTask_standard = new QueryTask(standard_address);
                            var query_standard = new Query();
                            //query_standard.where = map.extent;
                            query_standard.where = ids_str_array[id + "_"];
                            query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                            query_standard.returnGeometry = true;
                            queryTask_standard.execute(query_standard, function (results) {
                                if (results.features.length == 0)
                                    return;
                                var current_zoom = map.getZoom();
                                var size = standard_point_get_size(current_zoom);//获取当前放大级别下，楼宇图标的大小
                                var build_ids_temp = new Array();
                                for (var i = 0, l = results.features.length; i < l; i++) {
                                    var feature = results.features[i];

                                    var img = new PictureMarkerSymbol(standard_ico_selected, size, size);
                                    var build_gra = new esri.Graphic(feature.geometry, img, feature.attributes);
                                    draw_layer_mark_build.add(build_gra);
                                    //map.addLayer(draw_layer_mark_build);
                                }
                            });
                            /*map.addLayer(standard_layer);
                             map.addLayer(drawed_layer_mark_build);
                             map.addLayer(draw_layer_mark_build);*/
                            map.centerAndZoom(gra.geometry, 9);
                        }

                    });

                    school_GraphicsLayer.on("graphic-add", function (evt) {
                        var gra = evt.graphic;
                        var attr = gra.attributes;
                        var id = attr.school_id;
                        village_gras_array[id] = gra;
                        if (id == village_id_selected || id == global_village_id) {
                            ico_url = village_ico_selected;
                            var size = village_ico_get_size(map.getZoom());

                            img = new PictureMarkerSymbol(ico_url, size, size);
                            var graphic1 = new esri.Graphic(gra.geometry, img, attr);

                            school_GraphicsLayer_selected.clear();
                            school_GraphicsLayer_selected.add(graphic1);
                            school_GraphicsLayer_selected.redraw();

                            draw_layer_mark_build.clear();
                            var queryTask_standard = new QueryTask(standard_address);
                            var query_standard = new Query();
                            //query_standard.geometry = map.extent;
                            query_standard.where = ids_str_array[id + "_"];
                            query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
                            query_standard.returnGeometry = true;
                            queryTask_standard.execute(query_standard, function (results) {
                                if (results.features.length == 0)
                                    return;
                                var current_zoom = map.getZoom();
                                var size = standard_point_get_size(current_zoom);//获取当前放大级别下，楼宇图标的大小
                                var build_ids_temp = new Array();
                                for (var i = 0, l = results.features.length; i < l; i++) {
                                    var feature = results.features[i];

                                    var img = new PictureMarkerSymbol(standard_ico_selected, size, size);
                                    var build_gra = new esri.Graphic(feature.geometry, img, feature.attributes);
                                    draw_layer_mark_build.add(build_gra);
                                    //map.addLayer(draw_layer_mark_build);
                                }
                            });
                            /*map.addLayer(standard_layer);
                             map.addLayer(drawed_layer_mark_build);
                             map.addLayer(draw_layer_mark_build);*/
                            map.centerAndZoom(gra.geometry, 9);
                        }

                    });

                    //liangliyuan 20170720 新增 小区服务功能 ↑
                    if(enterprise_GraphicsLayer!="")
                    enterprise_GraphicsLayer.on("graphic-add", function (evt) {
										    var gra = evt.graphic;
										    var attr = gra.attributes;
										    var id = attr.enterprise_id;
										    village_gras_array[id] = gra;
										    if (id == village_id_selected || id == global_village_id) {
										        ico_url = village_ico_selected;
										        var size = village_ico_get_size(map.getZoom());

										        img = new PictureMarkerSymbol(ico_url, size, size);
										        var graphic1 = new esri.Graphic(gra.geometry, img, attr);

										        enterprise_GraphicsLayer_selected.clear();
										        enterprise_GraphicsLayer_selected.add(graphic1);
										        enterprise_GraphicsLayer_selected.redraw();

										        draw_layer_mark_build.clear();
										        var queryTask_standard = new QueryTask(standard_address);
										        var query_standard = new Query();
										        //query_standard.geometry = map.extent;
										        query_standard.where = ids_str_array[id + "_"];
										        query_standard.outFields = ["RESID", "RESNAME", "RESFULLNAME", "UNION_ORG_CODE", "GRID_UNION_ORG_CODE", "GRID_NAME", "BUREAU_NAME","BUREAU_NO"];
										        query_standard.returnGeometry = true;
										        queryTask_standard.execute(query_standard, function (results) {
										            if (results.features.length == 0)
										                return;
										            var current_zoom = map.getZoom();
										            var size = standard_point_get_size(current_zoom);//获取当前放大级别下，楼宇图标的大小
										            var build_ids_temp = new Array();
										            for (var i = 0, l = results.features.length; i < l; i++) {
										                var feature = results.features[i];

										                var img = new PictureMarkerSymbol(standard_ico_selected, size, size);
										                var build_gra = new esri.Graphic(feature.geometry, img, feature.attributes);
										                draw_layer_mark_build.add(build_gra);
										                //map.addLayer(draw_layer_mark_build);
										            }
										        });
										        /*map.addLayer(standard_layer);
										         map.addLayer(drawed_layer_mark_build);
										         map.addLayer(draw_layer_mark_build);*/
										        map.centerAndZoom(gra.geometry, 9);
										    }

										});


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

    var backToEchart = function () {
        parent.global_parent_area_name = parent.global_position[0];
        parent.global_current_area_name = parent.global_position[0];
        parent.global_current_full_area_name = parent.global_position[0];
        //parent.global_current_city_id = city_id;//以前返回二级地市页面的时候用这个
        parent.global_current_city_id = province_id[parent.global_position[0]];
        parent.global_current_flag = 1;
        //var url4mapBackTop = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_city_dev_colorflow.jsp"/>';
        var url4mapBackTop = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_province_dev_colorflow.jsp"/>';
        parent.freshMapContainer(url4mapBackTop);
        parent.freshIndexContainer(indexContainer_url_bearue);
        //parent.toggleModelButton();
    }

    //楼宇详情弹窗

    $('#build_close').on('click', function () {
        $('#detail_more').show();
        $('#layui-layer1').hide()
    });


    //窗口最大化

    $(".village_full_screen").click(function(){
        $(".village_info_win").addClass("win_full_screen");
        $(this).hide();
        $(".village_normal_screen").show();
        $(".win_operate").css("top","32px");
    });
    $(".village_normal_screen").click(function(){
        $(".village_info_win").removeClass("win_full_screen");
        $(this).hide();
        $(".village_full_screen").show();
        $(".win_operate").css("top","10px")
    });

		//小列表
		var pos_tab_begin = 0,pos_tab_end = 0, pos_tab_seq_num = 0, pos_tab_begin_scroll = 0, pos_tab_page_list = 0, pos_tab_query_flag=2, pos_tab_query_sort = '0', pos_tab_eaction = "", pos_tab_acct_mon='', pos_v_name = "";
		function pos_tab_load_list() {
				if(nav_type_index=="school"){
	      	pos_tab_eaction = "getSchoolByCityId";
	      	$("#pos_tab_title").text("校园清单");
	      	$("#pos_tab_name").text("校园名称");
	      }else if(nav_type_index=="enterprise"){
	      	pos_tab_eaction = "getEnterpriseByCityId";
	      	$("#pos_tab_title").text("商客清单");
	      	$("#pos_tab_name").text("商客名称");
	      }else{
	      	pos_tab_eaction = "getVillageByCityId";
	      	$("#pos_tab_title").text("小区清单");
	      	$("#pos_tab_name").text("小区名称");
	      }
		    var params = {
		        "city_id":city_id,
		        //"bureau_no":bureau_id_temp,
		        //"branch_no":branch_id_temp,
		        //"village_id":village_id_temp,
		        //"build_id":build_id_temp,
		        "v_name": pos_v_name,
		        "eaction": pos_tab_eaction,
		        "page": 0
		    }
		    pos_tab_listScroll(params, true, pos_tab_eaction);
		}

		function pos_tab_query(){
		    pos_tab_clear_data();
		    pos_tab_load_list();
		}

		$("#pos_tab_div").scroll(function () {
		    var viewH = $(this).height();
		    var contentH = $(this).get(0).scrollHeight;
		    var scrollTop = $(this).scrollTop();
		    if (scrollTop / (contentH - viewH) >= 0.95) {
		        if (new Date().getTime() - pos_tab_begin_scroll > 500) {
		            var params = {
                        "city_id":city_id,
                        //"bureau_no":bureau_id_temp,
                        //"branch_no":branch_id_temp,
                        //"village_id":village_id_temp,
                        //"build_id":build_id_temp,
                        "v_name": pos_v_name,
                        "eaction": pos_tab_eaction,
                        "page": ++pos_tab_page_list
		            }
		            if(pos_tab_total_num<=pos_tab_seq_num)
		                pos_tab_listScroll(params, false, pos_tab_eaction);
		            else
		                pos_tab_listScroll(params, true, pos_tab_eaction);
		        }
		        pos_tab_begin_scroll = new Date().getTime();
		    }
		});

		function pos_tab_listScroll(params, flag, action) {
		    pos_tab_listCollectScroll(params, flag);
		}

		var pos_tab_total_num = 0;
		function pos_tab_listCollectScroll(params, flag) {
		    var $list = $("#pos_tab_tbody");
		    if (pos_tab_hasMore) {
		        $.post(url4Query_enterprise, params, function (data) {
		            data = $.parseJSON(data);
		            /*if(data.length)
		                $("#download_div").show();
		            else
		                $("#download_div").hide();*/
		            for (var i = 0, l = data.length; i < l; i++) {
		                var d = data[i];
		                if(i==0){
		                    pos_tab_total_num = d.C_NUM;
		                    $("#pos_tab_total_num").text(d.C_NUM);
		                }
		                var newRow = "<tr><td class='text-center'>" + (++pos_tab_seq_num) + "</td>";//序号
		                newRow += "<td class='text-left pos_item' pos='"+ d.V_POSITION +"' title='"+ d.BUSINESS_NAME +"' onclick=\'javascript:pos_bus("+ d.SID +","+d.V_POSITION+")\'>" + name_shorter(d.BUSINESS_NAME) + "</td>"//楼宇名称
		                newRow += "<td class='text-center'>" + d.MARKET_LV + "</td>"
		                newRow += "</tr>";
		                $list.append(newRow);
		            }
		            //只有第一次加载没有数据的时候显示如下内容
		            if (pos_tab_total_num == 0) {
		                pos_tab_hasMore = false;
		                if (flag) {
		                    $list.empty();
		                    $list.append("<tr><td style='text-align:center' colspan=11 >没有查询到数据</td></tr>")
		                }
		            }
		        });
		    }
		}

		function pos_tab_clear_data() {
		    pos_tab_begin = 0, pos_tab_end = 0, pos_tab_seq_num = 0, pos_tab_begin_scroll = 0, pos_tab_hasMore = true, pos_tab_page_list = 0
		    flag = '1', pos_tab_query_sort = '0';
		    $("#pos_tab_total_num").text("");
		    $("#pos_tab_tbody").empty();
		    $("#download_div").hide();
		}

		function name_shorter(v_name){
			if(v_name.length>11)
				return v_name.substr(0,10)+'...';
			return v_name;
		}
</script>