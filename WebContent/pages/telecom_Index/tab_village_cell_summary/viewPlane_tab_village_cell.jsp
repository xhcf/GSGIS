<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="initTime">
    SELECT const_value val FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate'
</e:q4o>
<e:q4l var="index_range_list">
    SELECT
    KPI_CODE,
    RANGE_NAME,
    RANGE_NAME_SHORT,
    RANGE_SIGNL,
    RANGE_MIN,
    RANGE_SIGNR,
    RANGE_MAX
    FROM ${gis_user}.TB_GIS_KPI_RANGE
    WHERE IS_VALID = 1
    ORDER BY KPI_CODE ASC, RANGE_INDEX ASC
</e:q4l>

<e:description>划小组织机构</e:description>
<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT T.latn_id CODE, T.latn_name TEXT,city_order_num FROM ${gis_user}.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='b1'
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and T.latn_id = '${param.city_id}'
    </e:if>
    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY city_order_num
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.region_order_num FROM ${gis_user}.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='b1'
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '2'}">
        and T.latn_id = '${param.city_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '3' || sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.region_order_num
    ORDER BY T.region_order_num
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.union_org_code CODE, T.branch_name TEXT FROM ${gis_user}.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='b1'
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
        and T.union_org_code = '${param.branch_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '3'}">
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '2'}">
        and T.latn_id = '${param.city_id}'
    </e:if>
    group by T.bureau_no, T.union_org_code, T.branch_name,t.branch_no
    ORDER BY T.branch_no
</e:q4l>

<e:description>网格</e:description>
<e:q4l var="gridList">
    SELECT T.union_org_code PID, T.grid_id CODE, T.grid_name TEXT FROM ${gis_user}.db_cde_grid T
    WHERE T.grid_id IS NOT NULL
    and t.branch_type='b1' and t.grid_union_org_code is not null
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '5'}">
        and T.grid_id = '${param.grid_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '4'}">
        and T.union_org_code = '${param.branch_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '3'}">
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '2'}">
        and T.latn_id = '${param.city_id}'
    </e:if>
    group by t.union_org_code,t.grid_id,t.grid_name
    ORDER BY T.grid_id
</e:q4l>

<e:description>行政组织机构</e:description>
<e:description>地市</e:description>
<e:q4l var="latnList">
    SELECT T.CITY_ID CODE, T.CITY_NAME TEXT, CITY_ORDER_NUM
    FROM (SELECT DISTINCT city_id,city_name FROM EDW.VW_TB_CDE_VILLAGE@GSEDW) T,(SELECT DISTINCT latn_id,latn_name,city_order_num FROM ${gis_user}.db_cde_grid) b
    WHERE 1 = 1
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and T.city_id = '${param.city_id}'
    </e:if>
    AND t.city_id = b.latn_id
    ORDER BY b.city_order_num
</e:q4l>

<e:description>县区</e:description>
<e:q4l var="countyList">
    SELECT DISTINCT T.city_id PID, T.county_id CODE, T.county_name TEXT FROM EDW.VW_TB_CDE_VILLAGE@GSEDW T
    WHERE 1 = 1
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '2'}">
    		and T.latn_id = '${param.city_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '3' || sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    ORDER BY T.county_name
</e:q4l>

<e:description>乡镇</e:description>
<e:q4l var="townList">
    SELECT DISTINCT T.county_id PID, T.town_id CODE, T.town_name TEXT FROM EDW.VW_TB_CDE_VILLAGE@GSEDW T
    WHERE 1 = 1
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
    	and T.union_org_code = '${param.branch_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '3'}">
    	and T.bureau_no = '${param.bureau_id}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '2'}">
    		and T.latn_id = '${param.city_id}'
    </e:if>
    ORDER BY T.town_name
</e:q4l>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>行政村清单</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.7"/>' rel="stylesheet" type="text/css" media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.0" />'  rel="stylesheet" type="text/css" media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <script src='<e:url value="resources/app/areaSelect_vc.js?version=New Date()"/>' charset="utf-8"></script>

    <style>
        #tools{height:95%;}
        #query_div{width:120px;height:47px;padding:0;position:absolute;display:none;}
        #query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
        .ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
        #query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
        /*@media screen and (max-height: 1080px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
            .backup{right:1.4%;top:2.5%;}
            .tab_box{margin-top:18px;}
        }
        @media screen and (max-height: 768px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
            .tab_box{margin-top:13px;}
        }*/
        .datagrid-header {height:auto;line-height:auto;}
        .bureau_select a {
            display: block;
            float: left;
            margin-right: 20px;width:auto;
            text-decoration: underline;
        }
        #village_count span{cursor:pointer;}
        .span_selected {
            font-weight:bold;}

        .search_head{
            text-align:center;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }

        #village_count{
            font-size:12px;
            padding-top:2px;
        }
        #village_count span{
            color:#f00;
            text-decoration: underline;
        }
        .text-left{
            text-align:left!important;
        }
        .text-center{
            text-align:center!important;
        }
        .text-right{
            text-align:right!important;
            padding-right:15px!important;
        }
        .table1 tr:nth-child(1) td{background:none;}
        .important td{color:#fa8513!important;}
        #table_head,#big_tab_info_list{border-color:#aaa;}
        .table1,  .table1 td{
            border-color:#092e67;border-width:1px;
        }
        /*.long_message{
            display: block;
            text-overflow:ellipsis;
            overflow:hidden;
            white-space:nowrap;
        }*/
        td {padding-right:0px!important;}
        #table_head th, #big_table_content th{background:transparent;}
        .small_range{font-size:13px;}

        /*2018.9.13新样式*/
        .search_head span {
            background:none;
            text-align:right;
            display:inline-block;
            font-weight:bold;
        }
        .search_head a span{
            font-weight:normal;
        }
        #village_count span{
            color:#44E4FC;
        }
        .sub_box {background:#011157;}

        .sub_b {overflow-x:scroll;}

        /*表头表体字体白色*/
        .table1 th, #table1 td {color:#fff;}

        /*数据列表表头*/
        .table1 thead tr th{
            border:1px solid #333399;
            border-bottom-color:transparent;
        }
        /*表头 下划线*/
        .line_bottom {border-bottom-color:#333399!important;}

        /*数据列表表体*/
        .table1 td {border-color:#333366;}

        /*划小*/
        #table_head tr:first-child th:first-child {width:3%!important;}
        #table_head tr:first-child th:nth-child(2){width:4%!important;}
        #table_head tr:first-child th:nth-child(3){width:8%!important;}
        #table_head tr:first-child th:nth-child(4){width:8%!important;}
        #table_head tr:first-child th:nth-child(5){width:8%!important;}
        #table_head tr:first-child th:nth-child(6){width:9%!important;}
        #table_head tr:first-child th:nth-child(7){width:4%!important;}

        #table_head tr:first-child th:nth-child(8){width:13%!important;}
        #table_head tr:first-child th:nth-child(9){width:9%!important;}
        #table_head tr:first-child th:nth-child(10){width:13%!important;}
        #table_head tr:first-child th:nth-child(11){width:21%!important;}

        #table_head tr:nth-child(2) th:first-child{width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(2){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(3){width:5%!important;}

        #table_head tr:nth-child(2) th:nth-child(4){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(5){width:5%!important;}

        #table_head tr:nth-child(2) th:nth-child(6){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(7){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(8){width:5%!important;}

        #table_head tr:nth-child(2) th:nth-child(9){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(10){width:5%!important;}
        #table_head tr:nth-child(2) th:nth-child(11){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(12){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(13){width:4%!important;}

        #big_tab_info_list1 tr td:first-child {width:3%!important;}
        #big_tab_info_list1 tr td:nth-child(2){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(3){width:8%!important;}
        #big_tab_info_list1 tr td:nth-child(4){width:8%!important;}
        #big_tab_info_list1 tr td:nth-child(5){width:8%!important;}
        #big_tab_info_list1 tr td:nth-child(6){width:9%!important;padding-left:6px;}
        #big_tab_info_list1 tr td:nth-child(7){width:4%!important;}

        #big_tab_info_list1 tr td:nth-child(8){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(9){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(10){width:5%!important;}

        #big_tab_info_list1 tr td:nth-child(11){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(12){width:5%!important;}

        #big_tab_info_list1 tr td:nth-child(13){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(14){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(15){width:5%!important;}

        #big_tab_info_list1 tr td:nth-child(16){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(17){width:5%!important;}
        #big_tab_info_list1 tr td:nth-child(18){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(19){width:4%!important;}
        #big_tab_info_list1 tr td:nth-child(20){width:4%!important;}

        /*行政*/
        #tab_div2 {display:none;}
        #table_head2 tr:first-child th:first-child {width:3%!important;}
        #table_head2 tr:first-child th:nth-child(2){width:4%!important;}
        #table_head2 tr:first-child th:nth-child(3){width:10%!important;}
        #table_head2 tr:first-child th:nth-child(4){width:10%!important;}
        #table_head2 tr:first-child th:nth-child(5){width:12%!important;}
        #table_head2 tr:first-child th:nth-child(6){width:5%!important;}

        #table_head2 tr:first-child th:nth-child(7){width:13%!important;}
        #table_head2 tr:first-child th:nth-child(8){width:9%!important;}
        #table_head2 tr:first-child th:nth-child(9){width:13%!important;}
        #table_head2 tr:first-child th:nth-child(10){width:21%!important;}

        #table_head2 tr:nth-child(2) th:first-child {width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(2){width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(3){width:5%!important;}

        #table_head2 tr:nth-child(2) th:nth-child(4){width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(5){width:5%!important;}

        #table_head2 tr:nth-child(2) th:nth-child(6){width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(7){width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(8){width:5%!important;}

        #table_head2 tr:nth-child(2) th:nth-child(9){width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(10){width:5%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(11){width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(12){width:4%!important;}
        #table_head2 tr:nth-child(2) th:nth-child(13){width:4%!important;}

        #big_tab_info_list2 tr td:first-child {width:3%!important;}
        #big_tab_info_list2 tr td:nth-child(2){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(3){width:10%!important;}
        #big_tab_info_list2 tr td:nth-child(4){width:10%!important;}
        #big_tab_info_list2 tr td:nth-child(5){width:12%!important;padding-left:6px;}
        #big_tab_info_list2 tr td:nth-child(6){width:5%!important;}

        #big_tab_info_list2 tr td:nth-child(7){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(8){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(9){width:5%!important;}

        #big_tab_info_list2 tr td:nth-child(10){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(11){width:5%!important;}

        #big_tab_info_list2 tr td:nth-child(12){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(13){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(14){width:5%!important;}

        #big_tab_info_list2 tr td:nth-child(15){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(16){width:5%!important;}
        #big_tab_info_list2 tr td:nth-child(17){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(18){width:4%!important;}
        #big_tab_info_list2 tr td:nth-child(19){width:4%!important;}

        /*划小 行政 切换开关 按钮样式 切换按钮*/
        .swith_btn{background:#003399 ; position: absolute; right:15px; top:11px; width: 120px; height: 22px; line-height: 22px; border-radius: 20px;}
        .swith_btn span{cursor: pointer; width: 56%;text-align: center; color:#fff;display: block; position: absolute;height: 22px; line-height: 22px; border-radius: 20px;}
        .s_fl{left: 0;}
        .s_fr{right: 0;}
        .now{background:#00ccff!important;}

        /*查询区 名称 下拉框*/
        .search_head div {display:inline-block;}
        .search_title {width:10%;}
        .search_component {width:34%;text-align:left;}
        .search_btn {width:18%;}

        .div2_hx,.div2,.div3_hx,.div3,.div4_hx,.div4,.div5_hx {width:20%;}
        #org_hx_sel_1,#org_hx_sel_2,#org_hx_sel_3,#org_hx_sel_4,
        #org_sel_1,#org_sel_2,#org_sel_3 {width:75%;}

        .left {position:relative;line-height:30px;top:0px;}

        .query_option {width:100%;}
        .query_option a {margin-right:3%;}
    </style>
</head>
<body>
<div class="sub_box">
    <div class="close_button" id="closeTab"></div>
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>行&nbsp;政&nbsp;村&nbsp;清&nbsp;单</h4></div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search">
                    <tr style="display: none;">
                        <td class="search_head"><span>帐&nbsp;&nbsp;&nbsp;&nbsp;期:</span></td></td>
                        <td><input id="acctday" type="text" style="color:#ffffff; width:100px" /></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td class="search_head org_hx_head_1 search_title"><span>划小架构:</span></td>
                        <td class="search_head org_head_1 search_title"><span>行政架构:</span></td>

                        <td class="search_head search_component" colspan="4" style="padding-top:5px;">
                            <div class="div2_hx">
                                <span class="org_hx_head_2">分公司:</span><select id="org_hx_sel_1" name="org_hx_sel_1" class="trans_condition"></select>
                            </div>
                            <div class="div2">
                                <span class="org_head_2">地市:</span><select id="org_sel_1" name="org_sel_1" class="trans_condition"></select>
                            </div>

                            <div class="div3_hx">
                                <span class="org_hx_head_3">县局:</span><select id="org_hx_sel_2" name="org_hx_sel_2" class="trans_condition"></select>
                            </div>
                            <div class="div3">
                                <span class="org_head_3">县区:</span><select id="org_sel_2" name="org_sel_2" class="trans_condition"></select>
                            </div>
                            <div class="div4_hx">
                                <span class="org_hx_head_4">支局:</span><select id="org_hx_sel_3" name="org_hx_sel_3" class="trans_condition"></select>
                            </div>
                            <div class="div4">
                                <span class="org_head_4">乡镇:</span><select id="org_sel_3" name="org_sel_3" class="trans_condition"></select>
                            </div>
                            <div class="div5_hx">
                                <span class="org_hx_head_5">网格:</span><select id="org_hx_sel_4" name="org_hx_sel_4" class="trans_condition"></select>
                            </div>

                            <div class="swith_btn">
                                <span class="s_fl now">划小</span>
                                <span class="s_fr">行政</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="search_head search_title"><span>宽带渗透率:</span></td>
                        <td class="search_head search_component">
                            <div class="query_option" id="option_select1">
                                <a href="javascript:void(0)" onclick="optChange1('',this)">全部</a>
                            </div>
                        </td>
                        <%--<td class="search_head"><span>小区规模:</span></td>
                        <td>
                            <div class="village_mode_select">
                                <a href="javascript:void(0)" onclick="villageModeSwitch('',this)">全部</a>
                            </div>
                        </td>--%>
                        <td class="search_head search_title"><span>光网覆盖率:</span></td>
                        <td class="search_head search_component">
                            <div class="query_option" id="option_select2">
                                <a href="javascript:void(0)" onclick="optChange2('',this)">全部</a>
                                <a href="javascript:void(0)" onclick="optChange2('h',this)">高<span class='small_range'>(&gt;=60%)</span></a>
                                <a href="javascript:void(0)" onclick="optChange2('m',this)">中<span class='small_range'>(30-60%)</span></a>
                                <a href="javascript:void(0)" onclick="optChange2('l',this)">低<span class='small_range'>(&lt;30%)</span></a>
                            </div>
                        </td>
                        <td class="search_head search_btn">

                        </td>
                    </tr>
                    <tr>
                        <td class="search_head search_title"><span>流失占比:</span></td>
                        <td class="search_head search_component">
                            <div class="query_option" id="option_select3">
                                <a href="javascript:void(0)" onclick="optChange3('',this)">全部</a>
                            </div>
                        </td>
                        <td class="search_head search_title"><span>端口占用率:</span></td>
                        <td class="search_head search_component">
                            <div class="query_option" id="option_select4">
                                <a href="javascript:void(0)" onclick="optChange4('',this)">全部</a>
                                <a href="javascript:void(0)" onclick="optChange4('h',this)">高<span class='small_range'>(&gt;=60%)</span></a>
                                <a href="javascript:void(0)" onclick="optChange4('m',this)">中<span class='small_range'>(30-60%)</span></a>
                                <a href="javascript:void(0)" onclick="optChange4('l',this)">低<span class='small_range'>(&lt;30%)</span></a>
                            </div>
                        </td>
                        <td class="search_head search_btn"><input type="button" value="查询" id="query_btn" class="easyui-linkbutton" onclick="javascript:query();" style="width:55px;display:none;" /></td>
                        <%--<td class="search_head"><span>进线运营商:</span></td>
                        <td>
                            <div class="line_select">
                                <a href="javascript:void(0)" onclick="lineSwitch('',this)">全部</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('4',this)">4家</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('3',this)">3家</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('2',this)">2家</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('1',this)">1家</a>
                            </div>
                        </td>--%>
                    </tr>
                </table>
                <!--<table cellspacing="0" cellpadding="0" class="search" style="border:none;background: none;">
                    <tr><td class="search_head">小区数:</td>
                        <td id="village_count" style="border-right:none;">

                        </td>
                    </tr>
                </table>-->
                <div class="all_count left">
                    记录数：<span id="all_count" class="red"></span>
                </div>
                <div class="sub_b" id="tab_div1">
                    <div style="padding-right:15px;width: 1920px;"><!--#0b0a8a;-->
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 1920px;">
                            <thead>
                            <tr>
                                <th rowspan="2">序号</th>
                                <th rowspan="2">分公司</th>
                                <th rowspan="2">县局</th>
                                <th rowspan="2">支局</th>
                                <th rowspan="2">网格</th>
                                <th rowspan="2">行政村</th>
                                <th rowspan="2">人口数</th>
                                <th rowspan="1" colspan="3" class="line_bottom">市场占有</th>
                                <th rowspan="1" colspan="2" class="line_bottom">光网覆盖</th>
                                <th rowspan="1" colspan="3" class="line_bottom">光网实占</th>
                                <th rowspan="1" colspan="5" class="line_bottom">用户流失</th>
                            </tr>
                            <tr>
                                <!-- 市场占有 -->
                                <th>住户数</th>
                                <th>光宽用户数</th>
                                <th>宽带渗透率</th>

                                <th>OBD数</th>
                                <th>光网覆盖率</th>

                                <th>端口数</th>
                                <th>占用端口数</th>
                                <th>端口占用率</th>

                                <th>流失用户</th>
                                <th>流失占比</th>
                                <th>其中：拆机</th>
                                <th>其中：欠停</th>
                                <th>其中：沉默</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div1" style="width: 1920px">
                        <table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list1" style="width: 1920px">
                        </table>
                    </div>
                </div>

                <div class="sub_b" id="tab_div2">
                    <div style="padding-right:15px;width: 1920px;"><!--#0b0a8a;-->
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head2" style="width: 1920px;">
                            <thead>
                            <tr>
                                <th rowspan="2">序号</th>
                                <th rowspan="2">地市</th>
                                <th rowspan="2">县区</th>
                                <th rowspan="2">乡镇</th>
                                <th rowspan="2">行政村</th>
                                <th rowspan="2">人口数</th>
                                <th rowspan="1" colspan="3" class="line_bottom">市场占有</th>
                                <th rowspan="1" colspan="2" class="line_bottom">光网覆盖</th>
                                <th rowspan="1" colspan="3" class="line_bottom">光网实占</th>
                                <th rowspan="1" colspan="5" class="line_bottom">用户流失</th>
                            </tr>
                            <tr>
                                <!-- 市场占有 -->
                                <th>住户数</th>
                                <th>光宽用户数</th>
                                <th>宽带渗透率</th>

                                <th>OBD数</th>
                                <th>光网覆盖率</th>

                                <th>端口数</th>
                                <th>占用端口数</th>
                                <th>端口占用率</th>

                                <th>流失用户</th>
                                <th>流失占比</th>
                                <th>其中：拆机</th>
                                <th>其中：欠停</th>
                                <th>其中：沉默</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div2" style="width: 1920px">
                        <table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list2" style="width: 1920px;">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    var areaJSON=${e:java2json(areaList.list)};
    var cityJSON = ${e:java2json(cityList.list)};
    var centerJSON = ${e:java2json(centerList.list)};
    var gridJSON = ${e:java2json(gridList.list)};

    var latnJSON = ${e:java2json(latnList.list)};
    var countyJSON = ${e:java2json(countyList.list)};
    var townJSON = ${e:java2json(townList.list)};

    var curr_time = new Date();
    var url4data = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_cell_summary_action.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, eaction1 = "list_hx",eaction2 = "list_xz";
    var city_id_temp = '${param.city_id}';

    var bureau_id_temp = '${sessionScope.UserInfo.CITY_NO}';
    var branch_id_temp = '${sessionScope.UserInfo.TOWN_NO}';
    var grid_id_temp = '${sessionScope.UserInfo.GRID_NO}';
    var user_level = '${sessionScope.UserInfo.LEVEL}';

    var opt1_val = '';
    var opt2_val = '';
    var opt3_val = '';
    var opt4_val = '';

    var index_range_str_temp = ${e:java2json(index_range_list.list)};
    var index_range_map = new Array();
    for(var i = 0,l = index_range_str_temp.length;i<l;i++){
        var index_item = index_range_str_temp[i];
        var index_map = index_range_map[index_item['KPI_CODE']];
        if(index_map!=undefined)
            index_map.push(index_item);
        else{
            index_map = new Array();
            index_map.push(index_item);
        }
        index_range_map[index_item['KPI_CODE']] = index_map;
    }

    if(city_id_temp==""){
        if(user_level==1)
            city_id_temp ='999';
        else
            city_id_temp ='${sessionScope.UserInfo.AREA_NO}';
    }else
        city_id_for_village_tab_view = city_id_temp;
    //如果已经没有数据, 则不再次发起请求.

    var org_type = 'hx';

    function toggleOrgComponent(){
        $('.swith_btn span').click(function(){
            $(this).addClass('now').siblings().removeClass('now');

            if(org_type == 'hx'){
                //显示行政的内容
                org_type = 'xz';
                $(".org_hx_head_1").hide();
                $(".org_head_1").show();

                $(".div2_hx").hide();
                $(".div3_hx").hide();
                $(".div4_hx").hide();
                $(".div5_hx").hide();

                $(".div2").show();
                $(".div3").show();
                $(".div4").show();
                $(".div5").show();

                $("#tab_div1").hide();
                $("#tab_div2").show();
            } else if(org_type == 'xz'){
                //显示划小的内容
                org_type = 'hx';
                $(".org_hx_head_1").show();
                $(".org_head_1").hide();

                $(".div2_hx").show();
                $(".div3_hx").show();
                $(".div4_hx").show();
                $(".div5_hx").show();

                $(".div2").hide();
                $(".div3").hide();
                $(".div4").hide();
                $(".div5").hide();

                $("#tab_div1").show();
                $("#tab_div2").hide();
            }

            query();
        })
    }

    function initAreaSelect() {
        if(user_level=='1'){
            roleName='all';
        }
        if(user_level=='2'){
            roleName='areaValue';
        }
        if(user_level=='3'){
            roleName='cityValue';
        }
        if(user_level=='4'){
            roleName='centerNoValue';
        }
        if(user_level=='5'){
            roleName='gridValue';
        }
        //区域控制 js 加载
        var areaSelect=new AreaSelect();
        areaSelect.areaJSON=areaJSON;
        areaSelect.cityJSON=cityJSON;
        areaSelect.centerJSON=centerJSON;
        areaSelect.gridJSON=gridJSON;
        areaSelect.areaName='org_hx_sel_1';
        areaSelect.cityName='org_hx_sel_2';
        areaSelect.centerName='org_hx_sel_3';
        areaSelect.gridName='org_hx_sel_4';
        areaSelect.isDivDis=false;
        areaSelect.isNoDis=true;
        areaSelect.role=roleName;
        areaSelect.area='${sessionScope.UserInfo.AREA_NO}';
        areaSelect.city='${sessionScope.UserInfo.CITY_NO}';
        areaSelect.center='${sessionScope.UserInfo.TOWN_NO}';
        areaSelect.grid='${sessionScope.UserInfo.GRID_NO}';
        areaSelect.initAreaSelect();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });
    }

    function resetAreaSelect(){
        $("select[name='org_hx_sel_4']").bind("change",function(){
            query();
        });
        if(user_level==2){
            $("#org_hx_sel_1").attr("disabled",true);
            $("#org_hx_sel_2").removeAttr("disabled");
            $("#org_hx_sel_3").attr("disabled",true);
            $("#org_hx_sel_4").attr("disabled",true);
        }else if(user_level==3){
            $("#org_hx_sel_1").attr("disabled",true);
            $("#org_hx_sel_2").attr("disabled",true);
            $("#org_hx_sel_3").removeAttr("disabled");
            $("#org_hx_sel_4").attr("disabled",true);
        }else if(user_level==4){
            $("#org_hx_sel_1").attr("disabled",true);
            $("#org_hx_sel_2").attr("disabled",true);
            $("#org_hx_sel_3").attr("disabled",true);
            $("#org_hx_sel_4").removeAttr("disabled");
        }
    }

    function initAreaSelect1() {
        if(user_level=='1'){
            roleName='all';
        }
        if(user_level=='2'){
            roleName='areaValue';
        }
        if(user_level=='3'){
            roleName='cityValue';
        }
        if(user_level=='4'){
            roleName='centerNoValue';
        }
        if(user_level=='5'){
            roleName='gridValue';
        }
        //区域控制 js 加载
        var areaSelect=new AreaSelect_vc();
        areaSelect.latnJSON=latnJSON;
        areaSelect.countyJSON=countyJSON;
        areaSelect.townJSON=townJSON;
        areaSelect.areaName='org_sel_1';
        areaSelect.cityName='org_sel_2';
        areaSelect.centerName='org_sel_3';
        areaSelect.isDivDis=false;
        areaSelect.isNoDis=true;
        areaSelect.role=roleName;
        areaSelect.area='${sessionScope.UserInfo.AREA_NO}';
        areaSelect.city='${sessionScope.UserInfo.CITY_NO}';
        areaSelect.center='${sessionScope.UserInfo.TOWN_NO}';
        //areaSelect.grid='${sessionScope.UserInfo.GRID_NO}';
        debugger;
        areaSelect.initAreaSelect_vc();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });
    }

    function resetAreaSelect1(){
        $("select[name='org_sel_3']").bind("change",function(){
            query();
        });
        if(user_level==2){
            $("#org_sel_1").attr("disabled",true);
            $("#org_sel_2").removeAttr("disabled");
            $("#org_sel_3").attr("disabled",true);
            $("#org_sel_4").attr("disabled",true);
        }else if(user_level==3){
            $("#org_sel_1").attr("disabled",true);
            $("#org_sel_2").attr("disabled",true);
            $("#org_sel_3").removeAttr("disabled");
            $("#org_sel_4").attr("disabled",true);
        }else if(user_level==4){
            $("#org_sel_1").attr("disabled",true);
            $("#org_sel_2").attr("disabled",true);
            $("#org_sel_3").attr("disabled",true);
            $("#org_sel_4").removeAttr("disabled");
        }
    }

    function query(){
        clear_data();
        listScroll(1);
    }

    $(function(){
        $(".org_head_1").hide();
        $(".div2").hide();
        $(".div3").hide();
        $(".div4").hide();

        if('${param.from_menu}'=="1")
            $("#closeTab").hide();

        toggleOrgComponent();
        initAreaSelect();
        initAreaSelect1();

        initTabSelect("KPI_D_005",$("#option_select1"),"optChange1");//宽带渗透率
        initTabSelect("KPI_D_007",$("#option_select3"),"optChange3");//流失占比

        initQueryOption();

        resetAreaSelect();
        resetAreaSelect1();

        //高度调整
        $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 121 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height());

        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('.t_body').scroll(function () {
            //alert($(this).scrollLeft());
            $('#table_head').css('margin-left', -($('.t_body').scrollLeft()));
            $('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
        });
        $('#tbody2').scroll(function () {
            $('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
        });
        $("#closeTab").on("click",function(){
            load_map_view();
            $("div[id^='mask_div']").remove();
        });

        //日期控件
        var db = $('#acctday');
        db.datebox({
            onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层
                span.trigger('click'); //触发click事件弹出月份层
                //fix 1.3.x不选择日期点击其他地方隐藏在弹出日期框显示日期面板
                if (p.find('div.calendar-menu').is(':hidden')) p.find('div.calendar-menu').show();
                if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔
                    tds = p.find('div.calendar-menu-month-inner td');
                    tds.click(function (e) {
                        e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件
                        var year = /\d{4}/.exec(span.html())[0]//得到年份
                                , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1
                        db.datebox('hidePanel')//隐藏日期对象
                                .datebox('setValue', year + '-' + (month < 10 ? "0" + month : month)); //设置日期的值
                    });
                }, 0);
                yearIpt.unbind();//解绑年份输入框中任何事件
            },
            parser: function (s) {
                if (!s) return new Date();
                var arr = s.split('-');
                return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
            },
            formatter: function (d) {
                return d.getFullYear() + '-' + ((d.getMonth() + 1) < 10 ? "0" + (d.getMonth() + 1) : (d.getMonth() + 1));
                /*getMonth返回的是0开始的，忘记了。。已修正*/
            }
        });
        /*$("#acctday").datebox({
            onChange: function(date){
                acct_mon = date;
                acct_mon = acct_mon.replace(/-/g,'');
                clear_data();
                listScroll(1);
                //alert(date.getFullYear()+":"+(date.getMonth()+1)+":"+date.getDate());
            }
        });*/
        var p = db.datebox('panel'), //日期选择对象
                tds = false, //日期选择对象中月份
                aToday = p.find('a.datebox-current'),
                yearIpt = p.find('input.calendar-menu-year'),//年份输入框
        //显示月份层的触发控件
                span = aToday.length ? p.find('div.calendar-title span') ://1.3.x版本
                        p.find('span.calendar-text'); //1.4.x版本
        if (aToday.length) {//1.3.x版本，取消Today按钮的click事件，重新绑定新事件设置日期框为今天，防止弹出日期选择面板

            aToday.unbind('click').click(function () {
                var now = new Date();
                db.datebox('hidePanel').datebox('setValue', now.getFullYear() + '-' + ((now.getMonth() + 1) < 10 ? "0" + (now.getMonth() + 1) : (now.getMonth() + 1)));
            });
        } else {
            var date = '${initTime.VAL}';
            var year = date.substr(0,4);
            var mm = date.substr(4);
            db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
        }

        query();
    });

    $("#big_table_info_div1").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                ++page;
                listScroll(0);
            }
            begin_scroll = new Date().getTime();
        }
    });
    $("#big_table_info_div2").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                ++page;
                listScroll(0);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function listScroll(flag) {
        var params = getParams();
        var $list = "";
        if(org_type=='hx')
            $list = $("#big_tab_info_list1");
        else if(org_type=='xz')
            $list = $("#big_tab_info_list2");

        $.post(url4data, params, function (data) {
            if(org_type=='hx'){
                var objs = $.parseJSON(data);
                if(page==0){
                    if(objs.length){
                        $("#all_count").text(objs[0].C_NUM);
                    }else{
                        $("#all_count").text("0");
                    }
                }
                for (var i = 0, l = objs.length; i < l; i++) {
                    var d = objs[i];
                    var newRow = "<tr><td>" + (++seq_num) + "</td>";
                    newRow += "<td class='text-center'>" + d.LATN_NAME + "</td>"
                    newRow += "<td class='text-center'>" + d.BUREAU_NAME + "</td>";
                    newRow += "<td class='text-center'>" + d.BRANCH_NAME + "</td>";//支局
                    newRow += "<td class='text-center'>" + d.GRID_NAME + "</td>";//网格
                    if('${param.from_menu}'=="1"){
                        newRow += "<td class='text-left text-important'>" + d.VILLAGE_NAME + "";//行政村
                    }else{
                        newRow += "<td class='text-left'><a onclick=\"insideToVillageCell('"+ d.VILLAGE_ID +"')\" class='text-important-a' style='text-decoration:underline;cursor:pointer;'>" + d.VILLAGE_NAME + "</a>";//行政村
                    }
                    newRow += "</td>";
                    newRow += "<td class='text-right'>" + d.POPULATION_NUM + "</td>";//人口数

                    newRow += "<td class='text-right'>" + d.HOUSEHOLD_NUM + "</td>" +//住户数
                    "<td class='text-right'>" + d.H_USE_CNT + "</td>" +//光宽用户数
                    "<td class='text-right text-important'>" + d.MARKET_LV + "</td>" +//宽带渗透率

                    "<td class='text-right'>" + d.OBD_CNT + "</td>" + //obd数
                    "<td class='text-right text-important'>" + d.GW_LV + "</td>" + //光宽覆盖率

                    "<td class='text-right'>" + d.CAPACITY + "</td>" + //端口数
                    "<td class='text-right'>" + d.ACTUALCAPACITY + "</td>" + //占用端口数
                    "<td class='text-right text-important'>" + d.PORT_LV + "</td>" + //端口占用率

                    "<td class='text-right'>" + d.LOST_CNT + "</td>" + //流失用户
                    "<td class='text-right text-important'>" + d.LOST_LV + "</td>" + //流失占比
                    "<td class='text-right'>" + d.LOST_CJ_CNT + "</td>" + //拆机
                    "<td class='text-right'>" + d.LOST_QT_CNT + "</td>" + //欠停
                    "<td class='text-right'>" + d.LOST_CM_CNT + "</td>" + //沉默

                    "</tr>";
                    $list.append(newRow);
                }
                //只有第一次加载没有数据的时候显示如下内容
                if (objs.length == 0 && flag) {
                    $list.empty();
                    $list.append("<tr><td style='text-align:center' colspan=20 >没有查询到数据</td></tr>");
                }
            }else if(org_type=='xz'){
                var objs = $.parseJSON(data);
                if(page==0){
                    if(objs.length){
                        $("#all_count").text(objs[0].C_NUM);
                    }else{
                        $("#all_count").text("0");
                    }
                }
                for (var i = 0, l = objs.length; i < l; i++) {
                    var d = objs[i];
                    var newRow = "<tr><td>" + (++seq_num) + "</td>";
                    newRow += "<td class='text-center'>" + d.CITY_NAME + "</td>"
                    newRow += "<td class='text-center'>" + d.COUNTY_NAME + "</td>";
                    newRow += "<td class='text-center'>" + d.TOWN_NAME + "</td>";//支局
                    if('${param.from_menu}'=="1"){
                        newRow += "<td class='text-left text-important'>" + d.VILLAGE_NAME + "";//行政村
                    }else{
                        newRow += "<td class='text-left'><a onclick=\"insideToVillageCell('"+ d.VILLAGE_ID +"')\" class='text-important-a' style='text-decoration:underline;cursor:pointer;'>" + d.VILLAGE_NAME + "</a>";//行政村
                    }
                    newRow += "</td>";
                    newRow += "<td class='text-right'>" + d.POPULATION_NUM + "</td>";//人口数

                    newRow += "<td class='text-right'>" + d.HOUSEHOLD_NUM + "</td>" +//住户数
                    "<td class='text-right'>" + d.H_USE_CNT + "</td>" +//光宽用户数
                    "<td class='text-right text-important'>" + d.MARKET_LV + "</td>" +//宽带渗透率

                    "<td class='text-right'>" + d.OBD_CNT + "</td>" + //obd数
                    "<td class='text-right text-important'>" + d.GW_LV + "</td>" + //光宽覆盖率

                    "<td class='text-right'>" + d.CAPACITY + "</td>" + //端口数
                    "<td class='text-right'>" + d.ACTUALCAPACITY + "</td>" + //占用端口数
                    "<td class='text-right text-important'>" + d.PORT_LV + "</td>" + //端口占用率

                    "<td class='text-right'>" + d.LOST_CNT + "</td>" + //流失用户
                    "<td class='text-right text-important'>" + d.LOST_LV + "</td>" + //流失占比
                    "<td class='text-right'>" + d.LOST_CJ_CNT + "</td>" + //拆机
                    "<td class='text-right'>" + d.LOST_QT_CNT + "</td>" + //欠停
                    "<td class='text-right'>" + d.LOST_CM_CNT + "</td>" + //沉默
                    "</tr>";
                    $list.append(newRow);
                }
                //只有第一次加载没有数据的时候显示如下内容
                if (objs.length == 0 && flag) {
                    $list.empty();
                    $list.append("<tr><td style='text-align:center' colspan=19 >没有查询到数据</td></tr>");
                }
            }
        });
    }

    function getParams(){
        var eaction = "",a = "",b = "",c = "",d = "";

        var params = {
            "opt1":opt1_val,
            "opt2":opt2_val,
            "opt3":opt3_val,
            "opt4":opt4_val,
            "page": page
            /*"acct_mon":acct_mon*/
        }

        if(org_type=='hx'){
            eaction = eaction1;
            a = $("#org_hx_sel_1 option:selected").val();
            b = $("#org_hx_sel_2 option:selected").val();
            c = $("#org_hx_sel_3 option:selected").val();
            d = $("#org_hx_sel_4 option:selected").val();

            params.eaction = eaction;
            params.city_id = a;
            params.bureau_id = b;
            params.union_org_code = c;
            params.grid_union_org_code = d;
        }
        else if(org_type=='xz'){
            eaction = eaction2;
            a = $("#org_sel_1 option:selected").val();
            b = $("#org_sel_2 option:selected").val();
            c = $("#org_sel_3 option:selected").val();

            params.eaction = eaction;
            params.city_id = a;
            params.county_id = b;
            params.town_id = c;
        }

        return params;
    }

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page = 0;
        $("#big_tab_info_list1").empty();
        $("#big_tab_info_list2").empty();
        $("#all_count").empty();
    }

    function initQueryOption(){
        $("#option_select1").children().eq(0).addClass("selected");
        $("#option_select2").children().eq(0).addClass("selected");
        $("#option_select3").children().eq(0).addClass("selected");
        $("#option_select4").children().eq(0).addClass("selected");
    }

    function initTabSelect(kpi_id,element_name,func_name){
        var select_str = "";
        var items = index_range_map[kpi_id]
        var temp1 = "<a href=\"javascript:void(0)\" onclick=\"";
        var temp2 = "</a>";
        var temp3 = "";
        if(kpi_id=="KPI_D_005" || kpi_id=="KPI_D_007")
            temp3 = "%";
        for(var i = 0,l = items.length;i<l;i++){
            var item = items[i];
            select_str += (temp1+func_name+"("+(i+1)+",this)\">"+item.RANGE_NAME_SHORT);
            if(item.RANGE_SIGNR==null){//最大值
                select_str += ("<span class='small_range'>("+item.RANGE_SIGNL+item.RANGE_MIN+temp3+")</span>");
            }else if(item.RANGE_SIGNL==null){//最小值
                select_str += ("<span class='small_range'>("+item.RANGE_SIGNR+item.RANGE_MAX+temp3+")</span>");
            }else{//中间范围的值
                select_str += ("<span class='small_range'>("+item.RANGE_MIN+"-"+item.RANGE_MAX+temp3+")</span>");
            }
            select_str += temp2;
        }
        element_name.append(select_str);
    }

    function optChange1(val,target){
        $(target).addClass("selected").siblings().removeClass("selected");
        opt1_val = val;
        query();
    }
    function optChange2(val,target){
        $(target).addClass("selected").siblings().removeClass("selected");
        opt2_val = val;
        query();
    }
    function optChange3(val,target){
        $(target).addClass("selected").siblings().removeClass("selected");
        opt3_val = val;
        query();
    }
    function optChange4(val,target){
        $(target).addClass("selected").siblings().removeClass("selected");
        opt4_val = val;
        query();
    }

</script>