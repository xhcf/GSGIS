<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="initTime">
    SELECT to_char(to_date(MIN(const_value),'yyyymmdd'),'yyyy-mm-dd') val FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate'
</e:q4o>

<e:description>划小组织机构</e:description>
<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT T.latn_id CODE, T.latn_name TEXT,city_order_num FROM ${gis_user}.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='b1'
    <e:if condition="${param.city_id !=null && param.city_id ne ''}">
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
    <e:if condition="${param.bureau_id !=null && param.bureau_id ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.region_order_num
    ORDER BY T.region_order_num
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.branch_no CODE, T.branch_name TEXT FROM ${gis_user}.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='b1'
    <e:if condition="${param.branch_id !=null && param.branch_id ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.union_org_code = '${param.branch_id}'
    </e:if>
    group by T.bureau_no, T.branch_no, T.branch_name
    ORDER BY T.branch_no
</e:q4l>

<e:description>网格</e:description>
<e:q4l var="gridList">
    SELECT T.branch_no PID, T.grid_id CODE, T.grid_name TEXT FROM ${gis_user}.db_cde_grid T
    WHERE T.grid_id IS NOT NULL
    and t.branch_type='b1' and t.grid_union_org_code is not null
    <e:if condition="${param.grid_id !=null && param.grid_id ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.branch_no = '${param.branch_id}'
        and T.grid_id = '${param.grid_id}'
    </e:if>
    group by t.branch_no,t.grid_id,t.grid_name
    ORDER BY T.grid_id
</e:q4l>

<e:description>行政组织机构</e:description>
<e:description>地市</e:description>
<e:q4l var="latnList">
    SELECT T.CITY_ID CODE, T.CITY_NAME TEXT, CITY_ORDER_NUM
    FROM (SELECT DISTINCT city_id,city_name FROM EDW.VW_TB_CDE_VILLAGE@GSEDW) T,(SELECT DISTINCT latn_id,latn_name,city_order_num FROM ${gis_user}.db_cde_grid) b
    WHERE 1 = 1
    <e:if condition="${param.city_id !=null && param.city_id ne ''}">
        and T.city_id = '${param.city_id}'
    </e:if>
    AND t.city_id = b.latn_id
    ORDER BY b.city_order_num
</e:q4l>

<e:description>县区</e:description>
<e:q4l var="countyList">
    SELECT DISTINCT T.city_id PID, T.county_id CODE, T.county_name TEXT FROM EDW.VW_TB_CDE_VILLAGE@GSEDW T
    WHERE 1 = 1
    <e:if condition="${param.bureau_id !=null && param.bureau_id ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    ORDER BY T.county_name
</e:q4l>

<e:description>乡镇</e:description>
<e:q4l var="townList">
    SELECT DISTINCT T.county_id PID, T.town_id CODE, T.town_name TEXT FROM EDW.VW_TB_CDE_VILLAGE@GSEDW T
    WHERE 1 = 1
    <e:if condition="${param.branch_id !=null && param.branch_id ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.union_org_code = '${param.branch_id}'
    </e:if>
    ORDER BY T.town_name
</e:q4l>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>行政村统计报表</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <%--秦智宏：新加下拉框js--%>
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <script src='<e:url value="resources/app/areaSelect_vc.js?version=New Date()"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.8.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <script src='<e:url value="/pages/telecom_Index/channel_leader/js/dataFormat.js?version=New Date()"/>' charset="utf-8"></script>
    <style>
        #tools{height:95%;}
        #query_div{width:120px;height:47px;padding:0;position:absolute;display:none;}
        #query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
        .ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
        #query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
        @media screen and (max-height: 1080px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;margin-bottom:18px;}
            .backup{right:1.4%;top:2.5%;}
            .tab_box{margin-top:18px;}
        }
        @media screen and (max-height: 768px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
            .tab_box{margin-top:7px;}
        }
        .datagrid-header {height:auto;line-height:auto;}
        .bureau_select a {display: block;
            float: left;
            margin-right: 20px;width:auto;}
        .bureau_select a.selected {background-color: #ff8a00;
            width: auto;
            height: auto;
            text-align: center;
            border-radius: 4px;
            color: #fff;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }
        .search{
            background: #043572;
            width: 100%;
            color: #fff;
            border: 1px solid #1851a9;
        }
        .search a{

        }
        #village_count{
            font-size:12px;
            padding-top:2px;
        }
        #village_count span{
            color:#f00;
        }
        .sub_b {
            border-left: 0px solid #aaa;
            border-right: 0px solid #aaa;
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
        /*.slt_select,.fgl_select{display:inline-block;}
        .fgl_select{margin-left:30px;}*/
        .table1 tr:nth-child(1) td{background:none;}
        .important td{color:#fa8513!important;}
        #table_head,#big_tab_info_list{border-color:#aaa;}

        .table1, .table1 th, .table1 td{
            border-color:#092e67;
        }
        #table_head, #big_tab_info_list tr td:last-child {padding-right: 0px;}
        /*.long_message{
            display: block;
            text-overflow:ellipsis;
            overflow:hidden;
            white-space:nowrap;
        }*/
        .area_select_bq span{
            display: block;
            width: auto;
            height: 20px;
            line-height: 20px;
            padding: 0px 0px;
            border-radius: 3px;
            background: none!important;
            margin-left: 5px;
        }
        .search_head{
            width:80px;
            text-align:center;
            font-weight:bold;
        }
        .search_head span {
            background:none;
            text-align:right;
            display:inline-block;
            font-weight:bold;
        }
        .textbox,.textbox-text{background:none!important;border:0px;}

        /*2018.9.21 新样式*/
        .text-important {color:#00FFFF!important;}
        .text-important-a {color:#4CB9F9!important;}
        .area_select_bq a.selected, .line_select_bq a.selected{
            color:#FFCC33;
        }
        /*数据列表表头*/
        #table_head th, #big_table_content th{background:none;}
        #table_head thead tr th{
            border:1px solid #333399;
            border-bottom-color:transparent;
        }
        /*数据列表表体*/
        .table1 td {border:1px solid #333366;}

        /*本页标题*/
        .sub_box .big_table_title {height:28px;}
        .sub_box .big_table_title h4 {font-size:20px;}
        .select_width {width:100%;color:#aaa;}
        #big_table_info_div {overflow-y: scroll;}
        /*记录数*/
        .rows_num {height:32px;line-height:32px;}
        /*表头内边框填补*/
        .border_fix {border-bottom-color:#333399!important;}
        /*表格背景*/
        .sub_box {background: none;}
        .sub_b {margin-top:5px;}
        /*去除表格边框*/
        .table1 {border:none;}
        /*标签页选中效果*/
        .inner_tab .active, .inner_tab span:hover {color:#FFCC33;}

        .panel-body {
            background:white;
            border: none;
            font-family: 微软雅黑;
        }
        .databox_ {margin-left:28px;}

        input {color:#fff;}
        .databox_ .textbox.combo.datebox {margin-top:7px;}
        .textbox.combo.datebox {border:1px solid #3E4997;}
        .search a{margin:0px;}
        .textbox.combo {border:1px solid #3E4997;}
        .all_count {left:5px!important;height:22px!important;}
        .tab_scroll_x {width:100%;height:auto;overflow-x: scroll;overflow-y: hidden;border-right:solid 1px #092e67;}
        .table1.tab_head1 tr:nth-child(2) th:first-child {width:10%;}
        .combobox-item, .combobox-group, .combobox-stick {padding:2px 3px!important;font-size:13px;}
        .textbox .textbox-text {font-size:13px;}
        .l-btn-text {line-height:26px;}

        #areaNo,#cityNo,#centerNo,#gridNo {width:100%;}

        /*表格样式*/
        .tab_head1 {width:1920px;}
        .tab_head1 tr:first-child th:first-child {width:4%!important;}
        .tab_head1 tr:first-child th:nth-child(2) {width:10%!important;}

        .tab_head1 tr:first-child th:nth-child(3) {width:17%!important;}
        .tab_head1 tr:first-child th:nth-child(4) {width:33%!important;}
        .tab_head1 tr:first-child th:nth-child(5) {width:13%!important;}
        .tab_head1 tr:first-child th:nth-child(6) {width:23%!important;}

        .tab_head1 tr:nth-child(2) th:nth-child(1) {width:5%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(2) {width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(3) {width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(4) {width:4%!important;}

        .tab_head1 tr:nth-child(2) th:nth-child(5) {width:5%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(6) {width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(7) {width:5%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(8) {width:5%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(9) {width:5%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(10) {width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(11) {width:5%!important;}

        .tab_head1 tr:nth-child(2) th:nth-child(12){width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(13){width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(14){width:5%!important;}

        .tab_head1 tr:nth-child(2) th:nth-child(15){width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(16){width:4%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(17){width:5%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(18){width:5%!important;}
        .tab_head1 tr:nth-child(2) th:nth-child(19){width:5%!important;}

        .t_body {width:1920px;}
        .tab_comm {width:1920px;}
        .tab_comm tr td:first-child {width:4%!important;color:#fff!important;}/*text-align:center;*/
        .tab_comm tr td:nth-child(2){width:10%!important;color:#fff!important;}

        .tab_comm tr td:nth-child(3){width:5%!important;color:#ff9900!important;}
        .tab_comm tr td:nth-child(4){width:4%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(5){width:4%!important;color:#fff!important;}/*color:#ff9900 橙色*/
        .tab_comm tr td:nth-child(6){width:4%!important;color:#fff!important;}

        .tab_comm tr td:nth-child(7){width:5%!important;color:#ff9900!important;}
        .tab_comm tr td:nth-child(8){width:4%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(9){width:5%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(10){width:5%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(11){width:5%!important;color:#ff9900!important;}
        .tab_comm tr td:nth-child(12){width:4%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(13){width:5%!important;color:#fff!important;}

        .tab_comm tr td:nth-child(14){width:4%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(15){width:4%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(16){width:5%!important;color:#ff9900!important;}

        .tab_comm tr td:nth-child(17){width:4%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(18){width:4%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(19){width:5%!important;color:#ff9900!important;}
        .tab_comm tr td:nth-child(20){width:5%!important;color:#fff!important;}
        .tab_comm tr td:nth-child(21){width:5%!important;color:#fff!important;}

        /*查询区 名称 下拉框*/
        .search_head div {display:inline-block;}
        .search_title {width:9%;}
        .search_component {text-align:left;}
        /*组织机构控件样式*/
        .div2_hx,.div2,.div3_hx,.div3,.div4_hx,.div4,.div5_hx {width:20%;}
        #org_hx_sel_1,#org_hx_sel_2,#org_hx_sel_3,#org_hx_sel_4,
        #org_sel_1,#org_sel_2,#org_sel_3 {width:75%;}

        .left {position:relative;line-height:30px;top:0px;}

        /*划小 行政 切换开关 按钮样式 切换按钮*/
        .swith_btn{background:#003399 ; position: absolute; right:15px; top:50px; width: 120px; height: 22px; line-height: 22px; border-radius: 20px;}
        .swith_btn span{cursor: pointer; width: 56%;text-align: center; color:#fff;display: block; position: absolute;height: 22px; line-height: 22px; border-radius: 20px;}
        .s_fl{left: 0;}
        .s_fr{right: 0;}
        .swith_btn .now{background:#00ccff!important;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>行&nbsp;政&nbsp;村&nbsp;统&nbsp;计</h4></div>

        <table cellspacing="0" cellpadding="0" class="search">
            <tr style="height: 40px;">
                <td class="search_head"><span>账&nbsp;&nbsp;&nbsp;期：</span></td>
                <td colspan="10">
                    <div style="color:#FFFFFF; width:230px;">
                        <span style ="font-weight:700;font-size:14px;"></span>
                        <input id="accDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
                    </div>
                </td>
            </tr>
            <tr style="height: 40px;">
                <td class="search_head org_hx_head_1 search_title"><span>划小架构:</span></td>
                <td class="search_head org_head_1 search_title"><span>行政架构:</span></td>

                <td class="search_head search_component" colspan="10" style="padding-top:5px;">
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
        </table>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div id="big_table_change">
                    <div id="big_table_collect_type" class="inner_tab">

                    </div>
                </div>
                <div class="sub_b">
                    <div class="all_count">总记录数：<span id="all_count">0</span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <%--<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>--%>
                    </e:if>
                    <div class="tab_scroll_x">
                        <div id="big_table_content">
                            <div id="big_table_content_0" style="margin-right: 14px;display:block;">
                                <table cellspacing="0" cellpadding="0" class="table1 tab_head1" id="import_tab">
                                    <thead>
                                        <tr>
                                            <th rowspan="2">序号</th>
                                            <th rowspan="2">区域</th>
                                            <th colspan="4">市场</th>
                                            <th colspan="7">资源</th>
                                            <th colspan="3">营销派单</th>
                                            <th colspan="5">竞争收集</th>
                                        </tr>
                                        <tr>
                                            <th>宽带渗透率</th>
                                            <th>光宽数</th>
                                            <th>行政村数</th>
                                            <th>住户数</th>

                                            <th>光网覆盖率</th>
                                            <th>社队数</th>
                                            <th>已达社队数</th>
                                            <th>OBD设备数</th>
                                            <th>端口占用率</th>
                                            <th>端口数</th>
                                            <th>占用端口数</th>

                                            <th>派单数</th>
                                            <th>执行数</th>
                                            <th>执行率</th>

                                            <th>应收集</th>
                                            <th>已收集</th>
                                            <th>收集率</th>
                                            <th>异网收集数</th>
                                            <th>占线入户数</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div class="t_body" style="overflow-y:scroll;display:block;">
                            <table cellspacing="0" cellpadding="0" class="tab_comm">
                                <tbody id="resident_detail_list0" class="zd">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    var user_level = '${sessionScope.UserInfo.LEVEL}';
    var roleName='';

    var sql_url = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_cell_collect_action.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, eaction1 = "list_hx",eaction2 = "list_xz";
    var accDate = "";
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '${param.branch_id}';
    var grid_id_temp = '${param.grid_id}';

    if(city_id_temp==""){
        city_id_temp ='999';
    }

    var init_tab_height = 0;

    var table_rows_array = "";
    var table_rows_array_small_screen = [25,35,45];
    var table_rows_array_big_screen = [35,45,55];

    if(window.screen.height<=768){
        table_rows_array = table_rows_array_small_screen;
    }else{
        table_rows_array = table_rows_array_big_screen;
    }

    var areaJSON=${e:java2json(areaList.list)};
    var cityJSON = ${e:java2json(cityList.list)};
    var centerJSON = ${e:java2json(centerList.list)};
    var gridJSON = ${e:java2json(gridList.list)};

    var latnJSON = ${e:java2json(latnList.list)};
    var countyJSON = ${e:java2json(countyList.list)};
    var townJSON = ${e:java2json(townList.list)};

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
        areaSelect.initAreaSelect_vc();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });
    }

    function resetAreaSelect1(){
        $("select[name='org_sel_3']").bind("change",function(){
            query();
        });
    }

    //var long_message_width = 0;
    $(function(){
        $(".org_head_1").hide();
        $(".div2").hide();
        $(".div3").hide();
        $(".div4").hide();

        //下拉框初始化方法
        $('#accDate').datebox({
            onChange: function(date){
                query();
            },
            value:'${initTime.VAL}'
        });

        toggleOrgComponent();
        initAreaSelect();
        initAreaSelect1();

        resetAreaSelect();
        resetAreaSelect1();

        //表格外层滚动框的高度
        $(".t_body").css("max-height", document.body.offsetHeight*0.94 - $(".big_table_title").height() - $(".search").height() - $("#big_table_change").height() - $("#big_table_content").height() - 50);

        //init_tab_height = $("#tab_div").height() - 108 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();
        //initTabHeight_province();
        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('.t_body').scroll(function () {
            //alert($(this).scrollLeft());
            $('#import_tab').css('margin-left', -($('.t_body').scrollLeft()));

            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();

            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll > 500) {
                    ++page;
                    listCollectScroll(0);
                }
                begin_scroll = new Date().getTime();
            }
        });

        /*$("#closeTab").on("click",function(){
            load_map_view();
        });*/

        //$("#big_table_collect_type span").eq(0).click();

        resetSelectFunc();
        query();
    });

    function resetSelectFunc(){
        if(user_level==2){
            $("#cityNo").removeAttr("disabled");
            $("#centerNo").removeAttr("disabled");
            $("#gridNo").removeAttr("disabled");
        }else if(user_level==3){
            $("#centerNo").removeAttr("disabled");
            $("#gridNo").removeAttr("disabled");
        }else if(user_level==4){
            $("#gridNo").removeAttr("disabled");
        }
    }

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height+22);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-22);
    }

    function query(){
        clear_data();
        listCollectScroll(1);
    }

    function listCollectScroll(flag) {
        var $list = $("#resident_detail_list0");
        var params = getParams();
        $.post(sql_url, params, function (data) {
            var objs = $.parseJSON(data);
            /*if(data.length)
             $("#download_div").show();
             else
             $("#download_div").hide();*/
            if(page==0){
                if(objs.length){
                    $("#all_count").html(objs[0].C_NUM);
                }else{
                    $("#all_count").html('0');
                }
            }

            for (var i = 0, l = objs.length; i < l; i++) {
                var d = objs[i];
                /*if(d.LATN_NAME == '全省'){
                 var newRow = "<tr style=\"background-color:#043572 \"><td>" + (++seq_num) + "</td>";
                 }else {
                 var newRow = "<tr><td>" + (++seq_num) + "</td>";
                 }*/

                var newRow = "";
                if(i==0){
                    newRow += "<tr style=\"background-color:#043572 \">";
                }else{
                    newRow += "<tr>";
                }
                newRow += "<td>"+ (++seq_num) +"</td>";

                newRow += "<td>" + d.ORG_NAME + "</td>" +
                "<td>" + d.MARKET_LV + "</td>" +
                "<td>" + d.H_USE_CNT + "</td>" +
                "<td>" + d.VC_CNT + "</td>" +
                "<td>" + d.HOUSEHOLD_NUM + "</td>" +

                "<td>" + d.GW_LV + "</td>" +
                "<td>" + d.BRIGADE_ID_CNT + "</td>" +
                "<td>" + d.ZY_CNT + "</td>" +
                "<td>" + d.OBD_CNT + "</td>" +
                "<td>" + d.PORT_LV + "</td>" +
                "<td>" + d.CAPACITY + "</td>" +
                "<td>" + d.ACTUALCAPACITY + "</td>" +

                "<td>" + d.PD_NUM + "</td>" +
                "<td>" + d.ZX_NUM + "</td>" +
                "<td>" + d.ZX_LV + "</td>" +

                "<td>" + d.SHOULD_COLLECT + "</td>" +
                "<td>" + d.COLLECTED_CNT + "</td>" +
                "<td>" + d.COLLECT_LV + "</td>" +
                "<td>" + d.YW_COLLECT_CNT + "</td>" +
                "<td>" + d.ZX_COLLECT_CNT + "</td>" +

                "</tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (objs.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=21 >没有查询到数据</td></tr>")
            }
        });
    }

    function getParams(){
        var eaction = "",a = "",b = "",c = "",d = "";

        accDate = $('#accDate').datebox('getValue').replace(/-/g, "");

        var params = {};

        var flag = 1;
        var region_id = 999;

        if(org_type=='hx'){
            eaction = eaction1;
            a = $("#org_hx_sel_1 option:selected").val();
            b = $("#org_hx_sel_2 option:selected").val();
            c = $("#org_hx_sel_3 option:selected").val();
            d = $("#org_hx_sel_4 option:selected").val();

            if(a=="")
                a = 999;

            if(d!=""){
                region_id = d;
                flag = 5;
            }else if(c!=""){
                region_id = c;
                flag = 4;
            }else if(b!=""){
                region_id = b;
                flag = 3;
            }else if(a!="" && a!="999"){
                region_id = a;
                flag = 2;
            }else if(a=="999"){
                region_id = a;
                flag = 1;
            }
        }
        else if(org_type=='xz'){
            eaction = eaction2;
            a = $("#org_sel_1 option:selected").val();
            b = $("#org_sel_2 option:selected").val();
            c = $("#org_sel_3 option:selected").val();

            if(c!=""){
                region_id = c;
                flag = 4;
            }else if(b!=""){
                region_id = b;
                flag = 3;
            }else if(a!="" && a!="999"){
                region_id = a;
                flag = 2;
            }else if(a=="999"){
                region_id = a;
                flag = 1;
            }
        }
        params.eaction = eaction;
        params.accDate = accDate;
        params.region_id = region_id;
        params.flg = flag;
        params.page = page;
        params.pageSize = table_rows_array[0];
        return params;
    }

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page = 0;
        $("#all_count").text("");
        $("#resident_detail_list0").empty();
        //$("#download_div").hide();
    }

</script>