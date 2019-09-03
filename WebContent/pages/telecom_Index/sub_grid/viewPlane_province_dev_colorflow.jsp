<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="yesterday">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" content="ie=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>省级地图</title>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
    <!-- echarts 3.2.3 -->
    <script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap.js?version=1.2.3"/>'
            charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.0"/>'
          rel="stylesheet" type="text/css" media="all"/>
    <style>
        div.tab_menu a {
            display: inline-block;
            float: left;
            height: 22px;
            line-height: 22px;
            width: 60px;
            border-radius: 2px;
            text-align: center;
            color: #a7d9ff;
            text-decoration: none;
        }

        div.tab_menu a.selected {
            background-color: #025aac;
            color: #fff;
        }

        #pagemap {
            width: 100%;
            height: 100%;
        }

        #pagemap div {
            text-align: center;
            margin: auto;
        }

        #pagemap canvas {
            text-align: center;
            margin: auto;
            width: 100%;
        }

        #pagemap {
            background: none !important;
        }

        .anchorBL * {
            display: none;
        }

        .BMap_cpyCtrl {
            display: none;
        }

        #tools {
            height: 95%;
        }

        #query_div {
            width: 120px;
            height: 47px;
            background: #0f2c92;
            padding: 0;
            position: absolute;
            display: none;
        }

        #query_div div {
            float: left;
            line-height: 29px;
            color: #fff;
            cursor: pointer;
            padding-left: 0px;
        }

        .ico {
            width: 17px;
            height: 17px;
            margin-right: 7px;
            margin-top: -20px;
        }

        #query_div span {
            height: 18px;
            line-height: 18px;
            width: 30px;
            font-size: 12px;
            display: inline-block;
            margin-top: 2px;
        }
    </style>
    <!-- 	<script type="text/javascript">
		$(document).ready(function(){
		  $("#tools_scroll").height($("#pagemap").height()-3);
		})
   </script> -->
</head>
<body>
<div style="position:relative;">
    <div id="pagemap" name="pagemap"></div>
    <div class="tools_n" id="tools_scroll" style="position:absolute;top:-12px;left:0px;text-align:center;">
        <%--<a href="javascript:void(0)" id="show">显示</a>
			<a href="javascript:void(0)" id="hide">隐藏</a>--%>
        <ul id="tools">
            <li id="nav_hidetiled" class="active" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)"
                                                                                              id="hidetiled"
                                                                                              style="cursor:not-allowed;">地图</a>
            </li>
            <li id="model_to_rank" style="cursor: hand"><span></span><a href="javascript:void(0)" id="">统计</a></li>
            <li id="nav_zoomin" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="zoomin"
                                                                            style="cursor:not-allowed;">放大</a></li>
            <li id="nav_zoomout" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="zoomout"
                                                                             style="cursor:not-allowed;">缩小</a></li>
            <li id="nav_hidepoint" style="cursor:not-allowed;"><span></span><a href="javascript:void(0)" id="hidepoint"
                                                                               style="cursor:not-allowed;">网点</a></li>
            <%--<li id="nav_query"><span></span><a href="javascript:void(0)" id="query">查找</a></li>--%>
            <li id="nav_list" style="cursor: hand"><span></span><a href="javascript:void(0)" id="list">支局</a></li>
            <li id="nav_grid" style="cursor: not-allowed;"><span></span><a href="javascript:void(0)" id="grid"
                                                                           style="cursor:not-allowed;">网格</a></li>
            <li id="nav_village" style="cursor: not-allowed;;"><span></span><a href="javascript:void(0)" id="village"
                                                                               style="cursor:not-allowed;">小区</a></li>
            <li id="nav_standard" style="cursor: not-allowed;"><span></span><a href="javascript:void(0)" id="standard"
                                                                               style="cursor:not-allowed;">楼宇</a></li>
            <li id="nav_marketing_village" style="cursor: not-allowed;"><span></span><a href="javascript:void(0)"
                                                                                        id="marketing_village"
                                                                                        style="cursor:not-allowed;">营销</a>
            </li>
            <li id="nav_info_collect" style="cursor: hand"><span></span><a href="javascript:void(0)" id="info_collect"
                                                                           style="cursor: hand">收集</a></li>
            <!--<li id="nav_marketing" style="cursor: hand"><span></span><a href="javascript:void(0)" id="marketing">自建</a></li>-->
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
</div>

<%--yinming 2017年7月26日19:36:19--%>
<%--列表--%>
<div id="list_div" style="display: none;height: 100%">
    <div style="overflow: hidden;">
        <div style="margin-top: 5px">
            <div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
            <div class="list_search">
                <div style="margin-top: 5px">
                    <div style="margin-left: 5px;display: inline-block;line-height: 26px;font-size:12px">分公司:</div>
                    <select id="br_city" class="list_select" style="width: 66px;margin-left: 6px">
                        <option value="">全部</option>
                    </select>

                    <div style="margin-left: 18px;display: inline-block;font-size:12px">区&nbsp&nbsp县:</div>
                    <select id="br_area" class="list_select" style="width: 82px;;margin-left: 5px">
                        <option value="">全部</option>
                    </select>
                </div>
                <div style="margin-bottom: 2px">
                    <div style="margin-left: 7px;display: inline-block;font-size:12px">支&nbsp&nbsp局:</div>
                    <input type="text" id="b_branch_name" placeholder="输入网格名称"
                           style="width: 136px;margin: 5px;height:26px!important;margin-left: 8px;font-size:12px">
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
                <div style="margin-left: 5px;margin-top: 5px">
                    <div class="list_text">分公司:</div>
                    <select id="g_city" class="list_select" style="width: 70px;margin-left:5px">
                        <option value="">全部</option>
                    </select>

                    <div class="list_text" style="margin-left:10px">区&nbsp&nbsp县:</div>
                    <select id="g_area" class="list_select" style="width: 86px;;margin-left: 5px">
                        <option value="">全部</option>
                    </select>
                </div>
                <div style="margin-left: 5px;margin-top: 5px">
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
        <div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
        <div class="list_search">
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">分公司:</div>
                <select id="v_city" class="list_select" style="width: 70px;margin-left:8px">
                    <option value="">全部</option>
                </select>

                <div class="list_text" style="margin-left:10px">区&nbsp&nbsp县:</div>
                <select id="v_area" class="list_select" style="width: 88px;margin-left:5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">支&nbsp&nbsp局:</div>
                <select id="v_branch_type" class="list_select" style="width: 55px;margin-left: 8px">
                    <option value="">全部</option>
                    <option value="a1">城市</option>
                    <option value="b1">农村</option>
                </select>
                <select id="v_branch" class="list_select" style="  width:150px;margin-left: 5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">网&nbsp&nbsp格:</div>
                <select id="v_grid" class="list_select" style="width: 212px;margin-left: 13px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-bottom: 5px;">
                <div class="list_text">小&nbsp&nbsp区:</div>
                <input type="text" id="v_village_name" placeholder="输入小区名称"
                       style="width: 136px;margin-left: 13px;margin-top: 5px;">
                <button id="village_query" class="btn_uc" style="margin-top: 5px;font-size: 12px">查&nbsp&nbsp询</button>
            </div>
        </div>
        <div>
            <div style="color: #000;font-size: 14px;margin-left: 10px">汇总信息</div>
            <div class="list_search" style="padding: 5px;">
                <span style="font-size:12px">共</span><span style="color:#fc8500;font-size:12px"
                                                           id="villagecount1"></span><span
                    style="font-size:12px">个小区</span>
                <!-- ，未上图</span><span style="color:red;font-size:12px" id="villagecount2"></span><span  style="font-size:12px">个 -->
                <!--<button id="village_summary_list_pop_btn" class="btn_uc" style="margin:-2px 4px;font-size: 12px;float:right;">统&nbsp;&nbsp;计</button>-->
            </div>
        </div>
    </div>
    <div>
        <div style="color: #fff; background-color: #8ed2ff; position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:14px;font-weight: bold;    margin-top: -1px;">
            <div style='text-align: center;width: 12%;display: inline-block'>序号</div>
            <div style='text-align: center;width: 35%;display: inline-block'>网格名称</div>
            <div style='text-align: center;width: 40%;display: inline-block'>小区名称</div>
        </div>
    </div>
    <div class="td" style="top:296px;">
        <table id="village_table" class="village_table"
               style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
        </table>
    </div>
    <%--<div id="village_show" class="tb"></div>--%>
</div>

<div id="yingxiao_village_div" style="display: none;height: 100%">
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
                <button id="nav_marketing_btn">位置营销</button>
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
    <div class="td">
        <table class="yx_village_table" style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
        </table>
    </div>
</div>

!-- 信息收集div 开始-->
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
<!-- 竞争收集 收集编辑 -->
<div class="info_collect_win" id="info_collect_edit_div" style="display:none;">
    <!--<div class="titlea">
        <div id="info_collect_edit_draggable" style='text-align:left;width:90%;display: inline-block'>竞争收集</div>
        <div class="titlec" id="info_collect_edit_div_close"></div>
    </div>-->
    <iframe width="100%" height="100%"></iframe>
</div>

<div id="village_summary_list_pop_win" style="display:none;">
    <iframe style="width:100%;height:100%;"></iframe>
</div>

<%--tangjie 2017年9月18日16:15:38--%>
<div id="build_div" style="display: none;height: 100%">
    <div style="overflow: hidden">
        <div style="color: #000;font-size: 14px;margin-left: 10px">查询条件</div>
        <div class="list_search">
            <div style="margin-left:5px;margin-top: 5px">
                <div class="list_text">分公司：</div>
                <select id="b_city" class="list_select" style="width: 60px;margin-left:5px">
                    <option value="">全部</option>
                </select>

                <div class="list_text" style="margin-left: 10px">区&nbsp&nbsp县：</div>
                <select id="b_area" class="list_select" style="width: 84px;;margin-left:3px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">支&nbsp&nbsp局:</div>
                <select id="b_branch" class="list_select" style="  width: 212px;margin-left: 5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top: 5px">
                <div class="list_text">网&nbsp&nbsp格:</div>
                <select id="b_grid" class="list_select" style="width: 212px;margin-left: 5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left:5px;margin-bottom:5px">
                <div class="list_text">地&nbsp&nbsp址：</div>
                <input type="text" id="b_build_name" placeholder="输入楼宇名称"
                       style="width: 128px;margin-left: 5px;margin-top: 5px">
                <button id="build_query" class="btn_uc" style=";margin-left: 5px;margin-top: 5px">查&nbsp;&nbsp;询
                </button>
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
        <table id="build_table" class="build_table" style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
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

                <div class="list_text" style="margin-left: 10px">区&nbsp&nbsp县：</div>
                <select id="y_area" class="list_select" style="width: 75px;;margin-left:5px">
                    <option value="">全部</option>
                </select>
            </div>
            <div style="margin-left: 5px;margin-top:5px">
                <div class="list_text">名&nbsp&nbsp&nbsp称：</div>
                <input type="text" id="chaxun" placeholder="输入营销名称" style="width: 115px;margin-left: 5px">
                <button id="cc" class="btn_uc" style="margin-left:10px">查&nbsp;&nbsp;询</button>
            </div>
        </div>
    </div>
    <div>
        <div style="color: #fff; background-color: #8ed2ff;  position:relative;width: 296px;z-index: 9999999;height: 32px;line-height: 32px;font-size:13px;font-weight: bold;    margin-top: 5px;">
            <div style='text-align: center;width: 14%;display: inline-block'>序号</div>
            <div style='text-align: center;width: 55%;display: inline-block'>营销名称</div>
            <%--<div style='text-align: center;width: 24%;display: inline-block'>创建人</div>--%>
            <div style='text-align: center;display: inline-block'>创建时间</div>

        </div>
    </div>
    <div class="tf">
        <table id="yingxiao_table" style="/*display: block;*/margin-top:0px;height: 88%;width:100%;">
        </table>
    </div>
</div>
<div id="show_grid_menu">显示网格</div>

<div id="query_div">
    <div style="width:60px;border-right:1px solid #ccc;padding-left:0px;padding-top:3px;padding-bottom:7px;"
         onclick="javascript:viewRank();">
        <div style="width:100%;height:15px;"><img
                src="<e:url value='/pages/telecom_Index/sub_grid/image/paiming1.png' />" class="ico"
                style="margin-left:20px;margin-top:0px;"/></div>
        <div style="width:100%;height:15px;font-size:12px;text-align:center;">划小排名</div>
    </div>
    <div style="width:60px;padding-left:0px;padding-top:3px;padding-bottom:3px;" class="mapico"
         onclick="javascript:viewVillageDraw();">
        <div style="width:100%;height:15px;"><img
                src="<e:url value='/pages/telecom_Index/sub_grid/image/shangtu1.png' />" class="ico"
                style="margin-left:20px;margin-top:0px;"/></div>
        <div style="width:100%;height:15px;font-size:12px;text-align:center;">小区统计</div>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    //位置对应着left top，数字越小，越靠左、上
    var city_name_point_lng_lat = {
        '兰州': [103.208857, 36.589835],
        '天水': [105.526916, 34.636945],
        '白银': [104.404681, 36.752862],
        '酒泉': [96.916981, 40.334902],
        '张掖': [99.823754, 38.96968],
        '武威': [102.896103, 38.71068],
        '金昌': [101.847457, 38.436262],
        '嘉峪关': [98.094408, 39.854496],
        '定西': [104.165516, 35.212758],
        '平凉': [106.79633, 35.393745],
        '庆阳': [107.421838, 36.188202],
        '陇南': [104.974997, 33.719506],
        '临夏': [103.098473, 35.619404],
        '甘南': [102.638541, 34.712942]
    };

    var parent_name = parent.global_parent_area_name;
    var city_full_name = parent.global_current_full_area_name;
    var city_name = parent.global_current_area_name;
    var index_type = parent.global_current_index_type;
    var flag = parent.global_current_flag;
    parent.global_position.splice(0, 1, province_name);
    parent.updatePosition(flag);
    parent.global_city_id_for_vp_table = province_id[province_name];

    var map = "";
    var city_id = "";
    var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
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

    var url4echartmap = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=echarts_map';
    //echart地图下钻要加载的页面
    //var url4mapToWhere = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_city_dev_colorflow.jsp"/>';
    var url4mapToWhere = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_area_dev_colorflow.jsp"/>';
    var url4devTabToWhere = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev.jsp" />';

    function clickToSub(union_org_code, branch_name, zoom, city_name_var, latn_id) {
        parent.global_current_flag = 4;
        var full_name = city_name_var + "市";
        cityForLayer = cityNames[city_name_var + "市"];
        if (cityForLayer == null || cityForLayer == undefined) {
            cityForLayer = cityNames[city_name_var + "州"];
            full_name = city_name_var + "州";
        }
        parent.global_position[1] = full_name;
        parent.global_position[2] = '';
        parent.global_position[3] = branch_name;
        parent.global_position[4] = "";
        parent.global_current_full_area_name = full_name;
        parent.global_current_area_name = city_name_var;
        parent.global_substation = union_org_code;
        parent.zoom_from_province = zoom;
        parent.left_list_item_selected = "sub";
        parent.global_current_city_id = latn_id;

        parent.freshMapContainer(url4mapToWhere);
    }

    function clickToGrid(union_org_code, branch_name, zoom, grid_name, station_id, city_name_var) {
        /*parent.global_current_flag = 5;
         var full_name=city_name_var+"市";
         cityForLayer=cityNames[city_name_var+"市"];
         if(cityForLayer==null||cityForLayer==undefined){
         cityForLayer=cityNames[city_name_var+"州"];
         full_name=city_name_var+"州";
         }
         parent.global_position[1]=full_name;
         parent.global_position[2]='';
         parent.global_position[3]=branch_name;
         parent.global_position[4]=grid_name;
         parent.global_current_full_area_name=full_name;
         parent.global_current_area_name=city_name_var;
         parent.global_substation = union_org_code;
         parent.zoom_from_province = zoom;
         parent.grid_id_from_province = station_id;
         parent.left_list_item_selected = "grid";
         parent.global_current_city_id = city_ids[city_name_var];

         parent.freshMapContainer(url4mapToWhere);*/
    }

    function clickToGridAndVillage(union_org_code, branch_name, zoom, grid_name, station_id, village_id) {
        parent.global_current_flag = 5;
        var full_name = city_name_var + "市";
        cityForLayer = cityNames[city_name_var + "市"];
        if (cityForLayer == null || cityForLayer == undefined) {
            cityForLayer = cityNames[city_name_var + "州"];
            full_name = city_name_var + "州";
        }
        parent.global_position[1] = full_name;
        parent.global_position[2] = '';
        parent.global_position[3] = branch_name;
        parent.global_position[4] = grid_name;
        parent.global_current_full_area_name = full_name;
        parent.global_current_area_name = city_name_var;
        parent.global_substation = union_org_code;
        parent.zoom_from_province = zoom;
        parent.village_id_selected_from_province = village_id;
        parent.left_list_item_selected = "village";

        parent.freshMapContainer(url4mapToWhere);
    }

    function standard_position_load(segm_id, latn_name, latn_id) {
        return;
        parent.global_current_flag = 5;
        city_name_var = latn_name;
        var full_name = city_name_var + "市";
        cityForLayer = cityNames[city_name_var + "市"];
        if (cityForLayer == null || cityForLayer == undefined) {
            cityForLayer = cityNames[city_name_var + "州"];
            full_name = city_name_var + "州";
        }
        parent.global_position[1] = full_name;
        parent.global_position[2] = '';
        parent.global_position[3] = "";
        parent.global_position[4] = "";
        parent.global_current_full_area_name = full_name;
        parent.global_current_area_name = city_name_var;
        parent.global_substation = union_org_code;
        parent.zoom_from_province = zoom;
        parent.standard_id_from_province = segm_id;
        parent.left_list_item_selected = "build";

        parent.freshMapContainer(url4mapToWhere);
    }

    function viewRank() {
        parent.load_list_view();
        $("#query_div").hide();
        $("#model_to_rank").removeClass("active");
    }
    function viewVillageDraw() {
        parent.load_list_village(1);
        $("#query_div").hide();
        $("#model_to_rank").removeClass("active");
    }

    $(function () {
                var params = new Object();
                params.parent_name = parent_name;
                params.city_name = city_name;
                params.region_id = city_ids[city_name];
                params.city_full_name = city_full_name;
                params.index_type = index_type;
                params.flag = flag;
                params.busi_type = "dev";
                params.date = '${yesterday.VAL}';
                params.series_name = '移动当月发展量';
                //查询地图的数据

                setDataToEchartMap(params, url4echartmap, url4mapToWhere, url4devTabToWhere);

                $("#model_to_rank").click(function () {
                    if ($("#query_div").is(":hidden")) {
                        var top_px = $(this).offset().top + 2;
                        $("#query_div").css({
                            "left": $(this).offset().left + 38,
                            "top": top_px,
                            "height": $(this).height()+6
                        });
                        $("#query_div").show();
                        $("#model_to_rank").addClass("active");
                        layer.closeAll();
                    } else {
                        $("#query_div").hide();
                        $("#model_to_rank").removeClass("active");
                    }
                    //
                });

                function resetNavMenu() {
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

                /*yingming 2017年7月26日19:40:01*/
                var tmp = '1';
                var tmp2 = '1';
                var tmpx = '1';
                var tmpl = '1';
                var tmpy = '1';
                var tmpy_v = '1';
                //支局列表开始
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
                            area: ["298px", "99.7%"],
                            offset: ['1px', '38px'],
                            content: $("#list_div"),
                            cancel: function (index) {
                                $("#nav_list").removeClass("active");
                                return tmp = '1';
                            }
                        });
                        queryBranch();
                    }
                });
                //支局列表结束
                //网格列表开始
                $('#nav_grid').on('click', function () {
                    //20171225首页屏蔽
                    return;
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
                            area: ['298px', '99.7%'],
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
                $('#nav_village').on('click', function () {
                    //20171225首页屏蔽
                    return;
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
                            area: ['298px', '99.7%'],
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
                            var id = e.find(":selected").val()
                            e1.html(baseFullOption)
                            e2.html(baseFullOption)
                            e3.html(baseFullOption)
                            e4.click()
                            if (id != '') {
                                setArea(id, e1, e2, e3, e4, e5);
                                changeMapToCity($(this).find(":selected").text(), id);
                                parent.left_list_type_selected = "village";
                            }

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
                            setGrids(id, e2, e3)
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
                        data = $.parseJSON(data)
                        e1.unbind();
                        e1.on("change", function () {
                            e2.click();
                        })
                        var str = ''
                        $.each(data, function (i, d) {
                            str += "<option value='" + d.GRID_ID + "'>" + d.GRID_NAME + "</option>"
                        })
                        e1.html(baseFullOption)
                        e1.append(str)
                    })
                }

                ///////////////
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
                            e4.click()
                            if (id != '') {
                                changeMapToCity($(this).find(":selected").text(), id);
                                parent.left_list_type_selected = "village_yx";
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
                            var id = e1.find(":selected").val()
                            e4.click()
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
                    var latn_id = $("#v_city option:selected").val()
                    $.post(url4Query, {eaction: "setbranchs", id: id, latn_id: latn_id}, function (data) {
                        data = $.parseJSON(data)
                        e1.unbind();
                        e1.on("change", function () {
                            var id = e1.find(":selected").val()
                            e2.html(baseFullOption);
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

                //网格查询选择框筛选
                function setGCitys() {
                    $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                        data = $.parseJSON(data)
                        var str = '';
                        $("#g_city").on("change", function () {
                            var id = $(this).find(":selected").val()
                            $("#g_area").html(baseFullOption);
                            $("#g_branch").html(baseFullOption)
                            if (id != '') {
                                $("#grid_query").click()
                                setGArea(id)
                                changeMapToCity($(this).find(":selected").text(), id);
                                parent.left_list_type_selected = "grid";
                            }

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
                        $("#br_city").on("change", function () {
                            var id = $(this).find(":selected").val()
                            $("#br_area").html(baseFullOption);
                            if (id != '') {
                                $("#b_branch_name").val("");
                                $("#branch_query").click()
                                changeMapToCity($(this).find(":selected").text(), id);
                                parent.left_list_type_selected = "sub";
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
                        $("#y_city").on("change", function () {
                            var id = $(this).find(":selected").val()
                            $("#y_area").html(baseFullOption);
                            $("#cc").click()
                            setYArea(id);
                            changeMapToCity($(this).find(":selected").text(), id);
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

                setYCity()
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
                            str += "<tr class=\"tr_default_background_color\" style=\"color:" + (d.BRANCH_SHOW == 0 || (d.FLAG != 1 && d.FLAG != 0) ? '#f00' : '#000') + " \" onclick=\"javascript:clickToSub('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "'," + d.ZOOM + ",'" + d.LATN_NAME + "','" + d.LATN_ID + "')\" ><td style='width: 10%;text-align: center'>" + (i + 1) + "</td><td style='width: 22%;text-align: center'>" + d.LATN_NAME + "</td><td style='width: 48%' title=\"" + d.BRANCH_NAME + "\">" + (d.BRANCH_NAME.length > 7 ? d.BRANCH_NAME.substr(0, 7) + ".." : d.BRANCH_NAME) + d.GRID_NUM + "</td><td style='width: 20%;text-align: center'>" + d.BRANCH_TYPE_CHAR + "</td></tr>";

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

                //楼宇分公司、区县、支局、网格联动方法 开始
                function setCitysBulid(e, e1, e2, e3, e4) {
                    $.post(url4Query, {eaction: 'setcitys'}, function (data) {
                        data = $.parseJSON(data)
                        var str = ''

                        e.on("change", function () {
                            var id = e.find(":selected").val()
                            e1.html(baseFullOption)
                            e2.html(baseFullOption)
                            e3.html(baseFullOption)
                            e4.click()
                            if (id != '') {
                                setAreaBulid(id, e1, e2, e3, e4);
                                changeMapToCity($(this).find(":selected").text(), id);
                                parent.left_list_type_selected = "build";
                            }

                        })
                        $.each(data, function (i, d) {
                            str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
                        })
                        e.html(baseFullOptions)
                        e.append(str)
                        e.find("option[value=" + city_id + "]").attr("selected", "selected")
                        setAreaBulid(city_id, e1, e2, e3, e4)
                    })
                }

                function setAreaBulid(id, e1, e2, e3, e4) {
                    $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
                        data = $.parseJSON(data)

                        e1.on("change", function () {
                            e2.html(baseFullOption)
                            e3.html(baseFullOption)
                            var id = e1.find(":selected").val()
                            e4.click()
                            setBranchsBulid(id, e2, e3, e4)
                            if (id != null) {
                                setGridsBulid(null, e3, e4)
                            }
                        })
                        var str = ''
                        $.each(data, function (i, d) {
                            str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>"
                        })
                        e1.html(baseFullOption)
                        e1.append(str)
                        setBranchsBulid(null, e2, e3, e4)
                    })
                }

                setBranchsBulid = function (id, e1, e2, e3) {
                    var latn_id = $("#b_city option:selected").val()
                    $.post(url4Query, {eaction: "setbranchs", id: id, latn_id: latn_id}, function (data) {
                        data = $.parseJSON(data)

                        e1.on("change", function () {
                            var id = e1.find(":selected").val()
                            e2.html(baseFullOption);
                            e3.click();
                            setGridsBulid(id, e2, e3)
                        })
                        var str = ''
                        $.each(data, function (i, d) {
                            str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>"
                        })
                        e1.html(baseFullOption)
                        e1.append(str)
                    })
                }
                setGridsBulid = function (id, e1, e2) {
                    var latn_id = $("#b_city option:selected").val()
                    var bureau_no = $("#b_area option:selected").val()
                    $.post(url4Query, {
                        eaction: "setgrids",
                        id: id,
                        latn_id: latn_id,
                        bureau_no: bureau_no
                    }, function (data) {
                        data = $.parseJSON(data)
                        e1.on("change", function () {
                            e2.click();
                        })
                        var str = ''
                        $.each(data, function (i, d) {
                            str += "<option value='" + d.GRID_ID + "'>" + d.GRID_NAME + "</option>"
                        })
                        e1.html(baseFullOption)
                        e1.append(str)
                    })
                }
                //楼宇分公司、区县、支局、网格联动方法 结束

                function getProvinceBuildCount() {
                    $.post(url4Query, {eaction: "getProvinceBuildCount"}, function (data) {
                        data = $.parseJSON(data);
                        var build_sum = 0;
                        for (var i = 0, l = data.length; i < l; i++) {
                            var d = data[i];
                            build_sum += d.COUNT;
                        }
                        $("#build_count").text(build_sum);
                    });

                }

                getProvinceBuildCount();
                //楼宇开始
                $("#nav_standard").click(
                        function () {
                            //20171225首页屏蔽
                            return;
                            $("#b_city").html(baseFullOptions)
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
                                //				setBuildCity()

                                setCitysBulid($("#b_city"), $("#b_area"), $("#b_branch"), $("#b_grid"), $("#bulid_query"));

                                //                                standard_load();
                                layer.open({
                                    title: ['楼宇列表', 'line-height:32px;text-size:30px;height:32px;'],
                                    //title:false,
                                    type: 1,
                                    shade: 0,
                                    area: ['298px', '99.7%'],
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
                $("#nav_marketing").click(
                        function () {
                            resetNavMenu();
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
                                    area: ['298px', '99.7%'],
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

                //小区的营销情况 2017-09-06 新功能
                $("#nav_marketing_village").unbind();
                $("#nav_marketing_village").click(
                        function () {
                            //20171225首页屏蔽
                            return;
                            $("#village_info_win").hide()
                            $('#build_info_win').hide()
                            $('#build_info_win').hide();
                            $("#marketing_div").hide();
                            $("#yingxiao_info_win").hide();
                            $('#yingxiao_info_win_new').hide();
                            $("#detail_more").hide();
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
                                queryYX_village(city_id);
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
                /*$("#nav_info_collect").click(//信息收集汇总表小窗口 已废弃 改为大表格
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
                        area: ['710px', '485px'],
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
                        area: ['710px', '485px'],
                        //offset: ['1px', '38px'],
                        content: $("#info_collect_edit_div"),
                        cancel: function (index) {
                            layer.close(collect_edit_handler);
                            $("#nav_marketing2").removeClass("active");
                            return tmpx = '1';
                        }
                    });
                }
                //关闭信息收集编辑页面
                closeWinInfoCollectionEdit = function (add6_id, city_id, area_id, substation, grid_id) {
                    //$("#info_collect_edit_div").hide();
                    //openWinInfoCollectionView(add6_id, city_id, area_id, substation, grid_id);
                    layer.close(collect_edit_handler);
                }

                /*yinming 2017年7月21日10:39:10 新增营销查询*/
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
                                var str = "<tr class=\"tr_default_background_color\" style='font-size:14px;'><td style='width: 15%;text-align: center'>" + (i + 1) + "</td><td style='width: 50%;text-align:left' ><u onclick=\"javascript:queryfromyxid('" + d.YX_ID + "')\" style='cursor:pointer'>" + d.YX_NAME + "</u></td><td style='text-align: left' >" + d.CREATE_DATE + "</td></tr>"
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
                                var str = "<tr class=\"tr_default_background_color\" onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='text-align: center'></td><td style='text-align:center' ></td><td style='text-align: center'></td></tr>";
                                $("#yingxiao_table").append(str)
                            }
                        }
                    })
                }

                /*liangliyuan 2017年9月6日18:33:00 新增小区范围的营销结果 begin*/
                function queryYX_village(latn_id) {//yingxiao_village_div
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
                    getYxVillageCount_YxVillageList(latn_id, bureau_no, union_org_code, grid_id, vn);
                    //加载一页数据
                    queryYX_villageListScroll(latn_id, bureau_no, union_org_code, grid_id, vn, 0);
                }

                /*liangliyuan 2017年9月6日18:33:00 新增小区范围的营销结果 end*/

                var seq_um_yx_village = 0;

                function queryYX_villageListScroll(latn_id, bureau_no, union_org_code, grid_id, vn, page) {
                    $.post(url4Query, {
                        eaction: 'yingxiao_list_for_village_page',
                        latn_id: latn_id,
                        bureau_no: bureau_no,
                        union_org_code: union_org_code,
                        grid_id: grid_id,
                        village_name: $.trim(vn),
                        "page": page
                    }, function (data) {
                        data = $.parseJSON(data);
                        if (data != null) {
                            $.each(data, function (i, d) {
                                /*var x =d.VILLAGE_NAME
                                 if(x.length>8)
                                 x=x.substr(0,7)+'..'*/
                                //var str = "<tr class=\"tr_default_background_color\" style='font-size:14px;cursor:pointer;color:\"black\"' onclick=\"javascript:clickToGridAndVillage('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "',this," + d.GRID_ZOOM + ",'" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "',3)\" ><td style='width:12%;text-align: center'>" + (++seq_um_yx_village) + "</td>";
                                var str = "<tr class=\"tr_default_background_color\" style='font-size:14px;color:\"black\";cursor:default;' ><td style='width:12%;text-align: center'>" + (++seq_um_yx_village) + "</td>";
                                str += "<td style='width:25%;text-align:left' title=\"" + d.VILLAGE_NAME + "\">" + (d.VILLAGE_NAME.length > 7 ? d.VILLAGE_NAME.substr(0, 8) + "..." : d.VILLAGE_NAME) + "</td>";
                                str += "<td style='width:16%;'>" + d.YX_ALL + "</td><td style='width:16%;'>" + d.YX_UN + "</td><td style='width:12%;'>" + d.YX_LV + "</td></tr>";
                                $(".yx_village_table").append(str);
                            })
                        }
                        var stan = 20;
                        var width = $(parent.window).width()
                        if (width <= 1900)
                            stan = 8
                        if (data.length == 0 && seq_um_yx_village == 0) {
                            $(".yx_village_table").html("")
                            $(".yx_village_table").html("<tr><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                        } else if (data.length < stan) {
                            for (var i = 0; i <= stan - data.length; i++) {
                                var str = "<tr class=\"tr_default_background_color\" onclick=\"\"  onMouseOver=\"this.style.background='rgb(250,250,250)'\"><td style='text-align: center'></td><td style='text-align:center;' ></td><td style='text-align: center'></td></tr>";
                                $(".yx_village_table").append(str)
                            }
                        }
                    })
                }

                function getYxVillageCount_YxVillageList(latn_id, bureau_no, union_org_code, grid_id, vn) {
                    $.post(url4Query, {
                        "eaction": "getYxVillageCount_YxVillageList",
                        "latn_id": latn_id,
                        "bureau_no": bureau_no,
                        "union_org_code": union_org_code,
                        "grid_id": grid_id,
                        "village_name": vn
                    }, function (data) {
                        data = $.parseJSON(data);
                        $("#yx_villagecount1").text(data);
                    });
                }

                //小区统计弹窗
                $("#village_summary_list_pop_btn").unbind();
                $("#village_summary_list_pop_btn").on("click", function () {
                    resetNavMenu();
                    $("#village_summary_list_pop_win > iframe").attr("src", '<e:url value="/pages/telecom_Index/common/jsp/village_summary_list.jsp"/>?city_id=' + city_id);
                    villageSummaryListPop();
                })

                function villageSummaryListPop() {
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

                setBuildCity = function () {
                    $.post(url4Query, {eaction: 'b_city'}, function (data) {
                        data = $.parseJSON(data)
                        var e = $("#b_city");

                        e.on("change", function () {
                            var id = e.find(":selected").val()
                            $("#b_area").html(baseFullOption)
                            $("#b_street").html(baseFullOption)
                            //联动
                            if (id != '') {
                                setBuildArea(id);
                                changeMapToCity($(this).find(":selected").text(), id);
                                parent.left_list_type_selected = "build";
                            }
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

                $("#build_query").on('click', function () {
                    queryBuild('', 0)
                })

                var begin_scroll = "";
                var seq_um = 0;

                function buildListScroll(region_id, build_name, latn_id, substation, grid_id, page) {
                    var build_list = $("#build_table");
                    //首页默认查询兰州的信息
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
                            //str+="<tr class=\"tr_default_background_color\" style='cursor:pointer;font-size:14px' onclick=\"standard_position_load('"+obj.RESID+"','"+latn_name+"','"+latn_id+"',this)\"><td style='width: 14%;text-align: center'>"+ (++seq_um)+"</td><td style='width: 80%;text-align: left' title=\""+obj.RESFULLNAME+"\">"+x+"</td></tr>"
                            str += "<tr class=\"tr_default_background_color\" style='font-size:14px;cursor:default;'><td style='width: 14%;text-align: center'>" + (++seq_um) + "</td><td style='width: 80%;text-align: left' title=\"" + obj.RESFULLNAME + "\">" + x + "</td></tr>"

                        })
                        var stan = 24
                        var len = $(parent.window).width()
                        if (len < 1900) {
                            stan = 12
                        }
                        if (d.length == 0 && seq_um == 0) {
                            str += "<tr class=\"tr_default_background_color\"><td style='text-align:center'  onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到楼宇信息</td></tr>"
                        } else if (d.length <= stan) {
                            for (var i = 0; i < stan - d.length; i++) {
                                str += "<tr class=\"tr_default_background_color\"><td style='width: 18%;text-align: center'></td><td style='width: 60%;text-align:center'></td></tr>";
                            }
                        }
                        if (d.length == 0 && seq_um > 0)
                            return;
                        build_list.append(str);
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

                //楼宇查询结束
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
                            $(".grid_table").html("<tr><td style='text-align:center' onMouseOver=\"this.style.background='rgb(250,250,250)'\" >没有查询到数据</td></tr>")
                        } else {
                            $(".grid_table").html(' ')
                            var gridall = 0;
                            var gridshow = 0;
                            var str = "";
                            $.each(data, function (i, d) {
                                //str += "<tr class=\"tr_default_background_color\" style='color:"+(d.GRID_SHOW==0?'#f00':'#000')+"' onclick=\"javascript:clickToGrid('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',"+ d.GRID_ZOOM+",'"+d.GRID_NAME+"','"+d.STATION_ID+"','"+ d.LATN_NAME+"')\"  ><td style='width: 12%;text-align: left;padding-left:10px'>"+ (i+1)+"</td><td style='width: 38%;text-align: left;padding-left: 5px' title=\""+d.BRANCH_NAME+"\">"+d.BRANCH_NAME+"</td><td style='width: 50%;text-align: left;padding-left:5px'>"+ d.GRID_NAME+"</td></tr>";
                                str += "<tr class=\"tr_default_background_color\" style='color:" + (d.GRID_SHOW == 0 ? '#f00' : '#000') + ";cursor:default;' ><td style='width: 12%;text-align: left;padding-left:10px'>" + (i + 1) + "</td><td style='width: 38%;text-align: left;padding-left: 5px' title=\"" + d.BRANCH_NAME + "\">" + d.BRANCH_NAME + "</td><td style='width: 50%;text-align: left;padding-left:5px'>" + d.GRID_NAME + "</td></tr>";
                                gridall++;
                                if (d.GRID_SHOW == 1) {
                                    gridshow++
                                }
                            })
                            $(".grid_table").append(str)
                            var stan = 22
                            var len = $(parent.window).width()
                            if (len < 1900)
                                stan = 10
                            if (data.length <= stan) {
                                for (var i = 0; i < stan - data.length; i++) {
                                    var str = "<tr class=\"tr_default_background_color\" onMouseOver=\"this.style.background='rgb(250,250,250)'\" onMouseOut=\"this.style.background='rgb(250,250,250)'\" ><td style='width: 12%;text-align: center'></td><td style='width: 50%;text-align:center'></td><td style='width: 40%;text-align: center'></td></tr>";
                                    $(".grid_table").append(str)
                                }
                            }
                            $("#grid_show").html("共" + gridall + "个网格，未上图<font color=\"red\">" + (gridall - gridshow) + "</font>个");
                        }
                    });
                }

                //网格查询按钮
                $("#grid_query").click(
                        function () {
                            querygrid();
                        }
                );
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
                            $(".grid_table").html("<tr><td style='text-align:center' onMouseOver=\"this.style.background='rgb(250,250,250)'\" >没有查询到数据</td></tr>")
                        } else {
                            $(".grid_table").html(' ')
                            var gridall = 0;
                            var gridshow = 0;
                            $.each(data, function (i, d) {
                                //var str = "<tr class=\"tr_default_background_color\" style='color:"+(d.GRID_SHOW==0?'#f00':'#000')+"' onclick=\"javascript:clickToGrid('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',"+ d.GRID_ZOOM+",'"+d.GRID_NAME+"','"+d.STATION_ID+"','"+ d.LATN_NAME+"')\"  ><td style='width: 12%;text-align: left;padding-left:10px'>"+ (i+1)+"</td><td style='width: 38%;text-align: left;padding-left: 5px' title=\""+d.BRANCH_NAME+"\">"+d.BRANCH_NAME+"</td><td style='width: 55%;text-align: left;padding-left:5px'>"+ d.GRID_NAME+"</td></tr>";
                                var str = "<tr class=\"tr_default_background_color\" style='color:" + (d.GRID_SHOW == 0 ? '#f00' : '#000') + ";cursor:default;' ><td style='width: 12%;text-align: left;padding-left:10px'>" + (i + 1) + "</td><td style='width: 38%;text-align: left;padding-left: 5px' title=\"" + d.BRANCH_NAME + "\">" + d.BRANCH_NAME + "</td><td style='width: 55%;text-align: left;padding-left:5px'>" + d.GRID_NAME + "</td></tr>";
                                $(".grid_table").append(str)
                                gridall++;
                                if (d.GRID_SHOW == 1) {
                                    gridshow++
                                }
                            })
                            var stan = 22
                            var len = $(parent.window).width()
                            if (len < 1900)
                                stan = 10
                            if (data.length <= stan) {
                                for (var i = 0; i < stan - data.length; i++) {
                                    var str = "<tr class=\"tr_default_background_color\" onMouseOver=\"this.style.background='rgb(250,250,250)'\" onMouseOut=\"this.style.background='rgb(250,250,250)'\" ><td style='width: 12%;text-align: center'></td><td style='width: 55%;text-align:center'></td><td style='width: 40%;text-align: center'></td></tr>";
                                    $(".grid_table").append(str)
                                }
                            }
                            //$("#grid_show").html("共"+gridall+"个网格，未上图<font color=\"red\">"+(gridall-gridshow)+"</font>个");
                            $("#gridcount1").html(gridall);
                            $("#gridcount2").html(gridall - gridshow);
                        }
                    });
                }

                //小区查询开始
                $("#village_query").on("click", function () {
                    queryVillage('', 0)
                })
                $("#yx_village_query").unbind();
                $("#yx_village_query").on("click", function () {
                    var latn_id = $("#yx_v_city option:selected").val();
                    queryYX_village(latn_id);
                })


                ////----
                //小区查询开始
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
                                x = x.substr(0, 7) + '..';
                            //str+= "<tr class=\"tr_default_background_color\" style='font-size:14px;color:"+color+"' onclick=\"javascript:clickToGridAndVillage('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',this,"+ d.GRID_ZOOM+",'"+d.GRID_NAME+"','"+d.STATION_ID+"','"+d.VILLAGE_ID+"')\" ><td style='text-align: center'>"+ (++seq_um_village)+"</td><td style='text-align:left' title=\""+d.GRID_NAME+"\">"+d.GRID_NAME+"</td><td style='text-align: left' title='"+d.VILLAGE_NAME+"'>"+x+"</td></tr>"
                            str += "<tr class=\"tr_default_background_color\" style='font-size:14px;color:" + color + ";cursor:default;' ><td style='text-align: center'>" + (++seq_um_village) + "</td><td style='text-align:left' title=\"" + d.GRID_NAME + "\">" + d.GRID_NAME + "</td><td style='text-align: left' title='" + d.VILLAGE_NAME + "'>" + x + "</td></tr>";
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
                                x = x.substr(0, 7) + '..';
                            str += "<tr class=\"tr_default_background_color\" style='font-size:14px;color:" + color + ";cursor:default;' ><td style='text-align: center'>" + (++seq_um_village) + "</td><td style='text-align:left' title=\"" + d.GRID_NAME + "\">" + d.GRID_NAME + "</td><td style='text-align: left' title='" + d.VILLAGE_NAME + "'>" + x + "</td></tr>";
                            //str+= "<tr class=\"tr_default_background_color\" style='font-size:14px;cursor:pointer;color:"+color+"' onclick=\"javascript:clickToGridAndVillage('"+d.UNION_ORG_CODE+"','"+d.BRANCH_NAME+"',this,"+ d.GRID_ZOOM+",'"+d.GRID_NAME+"','"+d.STATION_ID+"','"+d.VILLAGE_ID+"')\" ><td style='text-align: center'>"+ (++seq_um_village)+"</td><td style='text-align:left' title=\""+d.GRID_NAME+"\">"+d.GRID_NAME+"</td><td style='text-align: left' title='"+d.VILLAGE_NAME+"'>"+x+"</td></tr>";
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
                            villageListScroll(latn_id, bureau_no, union_org_code, grid_id, village_name, branch_type, village_list_page);
                        }
                        begin_scroll_village = new Date().getTime();
                    }
                });
                ///小区查询结束


                function changeMapToCity(city_name_var, latn_id) {
                    var full_name = city_name_var + "市";
                    cityForLayer = cityNames[city_name_var + "市"];
                    if (cityForLayer == null || cityForLayer == undefined) {
                        cityForLayer = cityNames[city_name_var + "州"];
                        full_name = city_name_var + "州";
                    }

                    //全局变量修改
                    city_id = latn_id;

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

                    //toGis();
                    parent.freshMapContainer(url4mapToWhere);
                    parent.freshIndexContainer(url4devTabToWhere);
                }

            }
    );
</script>