<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="initTime">
    select to_char(to_date(MIN(const_value),'yyyymmdd'),'yyyy-mm-dd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '7'
</e:q4o>
<e:q4o var="now">
    select to_char(sysdate,'yyyy-mm-dd') val from dual
</e:q4o>
<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT to_char(T.latn_id) CODE, T.latn_name TEXT,city_order_num FROM  ${gis_user}.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and T.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY  city_order_num
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT  T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.region_order_num FROM ${gis_user}.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and T.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1' && sessionScope.UserInfo.LEVEL ne '2'}">
        and T.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
    </e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.region_order_num
    ORDER BY  T.region_order_num
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.union_org_code CODE, T.branch_name TEXT FROM ${gis_user}.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and T.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1' && sessionScope.UserInfo.LEVEL ne '2'}">
        and T.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
        and T.union_org_code = '${sessionScope.UserInfo.TOWN_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '5'}">
        and t.grid_id = '${sessionScope.UserInfo.GRID_NO}'
    </e:if>
    group by T.bureau_no, T.union_org_code, T.branch_name,t.branch_no
    ORDER BY  T.branch_no
</e:q4l>

<e:description>网格</e:description>
<e:q4l var="gridList">
    SELECT T.union_org_code PID, T.grid_id CODE, T.grid_name TEXT FROM ${gis_user}.db_cde_grid T
    WHERE T.grid_id IS NOT NULL
    and t.branch_type='a1' and t.grid_union_org_code is not null
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and T.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1' && sessionScope.UserInfo.LEVEL ne '2'}">
        and T.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
        and T.union_org_code = '${sessionScope.UserInfo.TOWN_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '5'}">
        and t.grid_id = '${sessionScope.UserInfo.GRID_NO}'
    </e:if>
    group by t.union_org_code,t.grid_id,t.grid_name
    ORDER BY T.GRID_id
</e:q4l>

<e:if condition="${param.grid_id !=null && param.grid_id  ne ''}">
    <e:q4l var="villageList">
        select GRID_ID PID, village_id CODE,village_name TEXT from ${gis_user}.view_db_cde_village  t
        where 1 = 1
        and T.grid_id = '${param.grid_id}'
        order by village_id
    </e:q4l>
</e:if>

<html>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>工单查询</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.0" />' rel="stylesheet" type="text/css"
          media="all">
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <link href='<e:url value="pages/telecom_Index/common/css/layer_win.css?version=1.4" />' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="pages/telecom_Index/common/css/button.css?version=New Date()" />' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="pages/telecom_Index/common/css/button_reset.css?version=New Date()" />' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="pages/telecom_Index/common/css/font-color.css?version=New Date()" />' rel="stylesheet" type="text/css" media="all" />
    <style>
        #query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
        #query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
        @media screen and (max-height: 1080px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
            .backup{right:1.4%;top:2.5%;}
            .tab_box{margin-top:18px;}
        }
        @media screen and (max-height: 768px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
            .tab_box{margin-top:13px;}
        }

        .cityNo a {
            display: block;
            float: left;
            margin-right: 20px;width:auto;}
        .cityNo a.selected {background-color: #ff8a00;
            width: auto;
            height: auto;
            text-align: center;
            border-radius: 4px;
            color: #fff;}
        .search_head{
            width:6%;
            /*width:5%; 隐藏 确认结果、工单状态*/
            text-align:right;
            font-weight:bold;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }
        .search{
            background: #043572;
            color:#fff;
            border:1px solid  #999;
        }
        .rows_num {width:97.5%;padding-left:1.2%;color:red;}
        .sub_b {width:97.5%;}

        .search a{
            color:#fff;
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

        .table1 tr:nth-child(1) td{background:none;}
        .search{border-color:#1851a9;}
        #table_head, #big_tab_info_list tr td:last-child {padding-right: 0px;}

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
        .search_head span{
            background: none!important;
        }

        /*数据列表表体*/

        #table_head tr th:first-child {width:5%!important;}
        #table_head tr th:nth-child(2) {width:35%!important;}
        #table_head tr th:nth-child(3) {width:10%!important;}
        #table_head tr th:nth-child(4) {width:16%!important;}
        #table_head tr th:nth-child(5) {width:10%!important;}
        #table_head tr th:nth-child(6) {width:10%!important;}
        #table_head tr th:nth-child(7) {width:7%!important;}
        #table_head tr th:nth-child(8) {width:7%!important;}

        #data_list td {font-size:12px;}

        #data_list tr td:first-child {width:5%!important;}
        #data_list tr td:nth-child(2){width:35%!important;}
        #data_list tr td:nth-child(3){width:10%!important;}
        #data_list tr td:nth-child(4){width:16%!important;}
        #data_list tr td:nth-child(5){width:10%!important;}
        #data_list tr td:nth-child(6){width:10%!important;}
        #data_list tr td:nth-child(7){width:7%!important;}
        #data_list tr td:nth-child(8){width:7%!important;}

        #table_head,#data_list {border:0px;}
        .table1, .table1 th, .table1 td {border:1px solid #092e67;}

        .table1 tbody tr td:nth-child(4){min-width: 0px!important;}
        .vil_type_condition span {display:inline-block;margin-right:15px;cursor:pointer;}
        .textbox combo {border:1px solid #fff;}
        .trans_condition {background:none;border:1px solid #3E4997;}
        select {line-height:25px!important;height:25px!important;}
        input {line-height:25px!important;height:25px!important;}
        /*2018.9.17 新样式*/
        #total_num {color:red;}
        /*表格中要突出的字*/
        .vil_type_condition .selected{
            color:#FFCC33;
        }
        /*数据列表表头*/
        #table_head th, #big_table_content th{background:none;}

        /*本页标题*/
        .sub_box .big_table_title {height:28px;}
        .sub_box .big_table_title h4 {font-size:20px;}
        .select_width {width:100%;color:#aaa;}
        #big_table_info_div {overflow-y: scroll;}
        /*记录数*/
        .rows_num {height:32px;line-height:32px;}

        .close_button {top:12px;}
        .select_option span {margin-right:2%;display:inline-block;}
        .select_option2 span {width:23%;display:inline-block;}

        #add4_order_edit_pop_win,#confirm_order_pop_win {display:none;}
        #add4_order_edit_pop_win {padding:1% 3%;}
        #confirm_order_pop_win {padding:10px;}
        #add4_order_edit_pop_win .layui-layer-title,.confirm_order_pop_win .layui-layer-title {font-size:14px;}

        /*地址修正弹窗内容样式*/
        .order_head {height:6%;font-weight:bold;}
        .div_border {border-top:1px solid #aaa;min-height:23%;padding:5px 15px;}
        .div_border_2 {border-top:1px solid #aaa;height:10%;padding:5px 15px;}
        .div_border div {margin-top:8px;margin-bottom:8px;}

        .span_head {font-weight: bold;}

        .div1 c {margin-right:2%;display:inline-block;}
        .div2 c {margin-right:2%;display:inline-block;}

        .easyui-linkbutton-gray {color:#fff;cursor:pointer;}
    </style>
</head>
<body>
<div class="sub_box grab_tab" style="height:98%;width:99.6%;position: absolute;left: 0px;border: 2px solid #2070dc;overflow-y:auto;">
    <div style="" id="tab_div">
        <div class="big_table_title"><h4>工&nbsp;单&nbsp;查&nbsp;询</h4></div>
        <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">

        </e:if>
        <div class="close_button" id="closeTab1"></div>
        <!--<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>-->
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search">
                    <tr style="display: none;">
                        <td class="search_head"><span>帐&nbsp;&nbsp;&nbsp;&nbsp;期:</span></td></td>
                        <td style="padding-left:8px;" colspan="7"><input id="acctday" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;" /></td>
                    </tr>
                    <tr>
                        <!-- 地市 -->
                        <td class="search_head"><span>分公司：</span></td>
                        <td style="width:14%;">
                            <!--<select id="city_select" class="trans_condition select_width" onchange="citySwitch()">
                            </select>-->
                            <select id="areaNo" name="areaNo" class="trans_condition select_width"></select>
                        </td>
                        <!-- 区县 -->
                        <td class="search_head"><span>县局：</span></td>
                        <td style="width:18%;">
                            <!--<select id="bureau_select" class="trans_condition select_width" onchange="bureauSwitch()">
                            </select>-->
                            <select id="cityNo" name="cityNo" class="trans_condition select_width"></select>
                        </td>
                        <!-- 支局 -->
                        <td class="search_head"><span>支局：</span></td>
                        <td style="width:12%;">
                            <!--<select id="branch_select" class="trans_condition select_width" onchange="branchSwitch()">
                            </select>-->
                            <select id="centerNo" name="centerNo" class="trans_condition select_width"></select>
                        </td>
                        <!-- 网格 -->
                        <td class="search_head"><span>网格：</span></td>
                        <td style="width:12%;">
                            <!--<select id="grid_select" class="trans_condition select_width" onchange="gridSwitch()">
                            </select>-->
                            <select id="gridNo" name="gridNo" onchange="query()" class="trans_condition select_width"></select>
                        </td>
                        <td style="width:1%;"></td>
                    </tr>
                    <tr>
                        <td class="search_head"><span>查询条件：</span></td>
                        <td class="text-left select_option" colspan="7">
                            <input id="query_text" class="trans_condition" type="text" placeholder="请输入工单关键字进行检索" />
                            <input type="button" value="查询" id="query_btn" class="easyui-linkbutton" style="float:right;" />
                        </td>
                        <td style="width:1%;"></td>
                    </tr>
                    <%--隐藏 确认结果、工单状态<tr>
                        <td class="search_head"><span>确认结果：</span></td>
                        <td class="text-left select_option">
                            <span><input type="radio" name="radio0" value="" checked="checked" />全部&nbsp;&nbsp;</span>
                            <span><input type="radio" name="radio0" value="1" />已修正&nbsp;&nbsp;</span>
                            <span><input type="radio" name="radio0" value="0" />未修正</span>
                        </td>
                        <td class="search_head"><span>工单状态：</span></td>
                        <td class="text-left select_option">
                            <span><input type="radio" name="radio1" value="" checked="checked" />全部&nbsp;&nbsp;</span>
                            <span><input type="radio" name="radio1" value="-1" />待处理&nbsp;&nbsp;</span>
                            <span><input type="radio" name="radio1" value="1" />已处理</span>
                            <span><input type="radio" name="radio1" value="0" />未处理</span>
                        </td>
                        <td class="search_head"><span>查询条件：</span></td>
                        <td class="text-left select_option" colspan="3">
                            <input id="query_text" class="trans_condition" type="text" placeholder="请输入工单关键字进行检索" />
                            <input type="button" value="查询" id="query_btn" class="easyui-linkbutton" style="float:right;" />
                        </td>
                        <td style="width:1%;"></td>
                    </tr>--%>
                </table>
                <div class="rows_num">
                	<span style="color:white;">总记录数：</span><span id="total_num"></span>
                </div>
                <div class="sub_b">
                    <div style="padding-right:15px;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>序号</th>
                                    <th>工单主题</th>
                                    <th>派单时间</th>
                                    <th>处理人</th>
                                    <th>处理时间</th>
                                    <th>联系电话</th>
                                    <th>工单状态</th>
                                    <th>确认结果</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div">
                        <table cellspacing="0" cellpadding="0" class="table1" id="data_list" style="width: 100%;">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 弹窗 -->
<div id="add4_order_edit_pop_win">
    <!-- 工单详情 -->
    <div class="order_head span_head blue">
        <div>工单详情：<span id="ew_order_id"></span><input type="button" value="确认" id="order_ok" class="easyui-linkbutton" style="float:right;" /></div>
    </div>
    <div class="div_border">
        <div id="ew_order_title" class="span_head orange"></div>
        <div class="div1">
            <c><span class="span_head">派单人：</span><span id="ew_sender"></span></c>
            <c><span class="span_head">派单时间：</span><span id="ew_sender_time"></span></c>
            <c><span class="span_head">联系电话：</span><span id="ew_sender_tel"></span></c>
            <%--<c><span class="span_head">分公司：</span><span id="ew_latn_name"></span></c>
            <c><span class="span_head">区县：</span><span id="ew_bureau_name"></span></c>--%>
        </div>
        <div id="ew_order_content"></div>
    </div>

    <!-- 处理结果 -->
    <div class="order_head span_head blue">处理结果</div>
    <div class="div_border">
        <div class="div2">
            <c><span class="span_head">处理结果：</span><span id="ew_order_status"></span></c><!-- 工单状态 -->
            <c><span class="span_head">处理人：</span><span id="ew_opr_name"></span></c>
            <c><span class="span_head">联系电话：</span><span id="ew_opr_tel"></span></c>
            <c><span class="span_head">处理时间：</span><span id="ew_opr_time"></span></c>
        </div>
        <div>
            <span class="span_head">反馈内容：</span>
            <span id="ew_back_content"></span>
        </div>
    </div>

    <!-- 确认结果 -->
    <div class="order_head span_head blue">确认结果</div>
    <div class="div_border_2">
        <div class="div2">
            <span class="span_head">确认结果：</span>
            <span id="ew_order_confirm"></span>
        </div>
    </div>
</div>

<!-- 确认功能 -->
<div id="confirm_order_pop_win">
    <div style="width:100%;height:50%;padding-top:10%;"><span style="width:45%;display:inline-block;text-align:right;padding-right:10px;"><input type="radio" name="order_confirm" value="1" checked="checked" />已修正</span><span style="width:40%;display:inline-block;text-align:left;padding-left:10px;"><input type="radio" name="order_confirm" value="0" />未修正</span></div>
    <div style="width:100%;text-align:center;"><span style="width:45%;display:inline-block;text-align:right;"><input class="easyui-linkbutton" type="button" value="确认" id="confirm_ok" style="margin-right:20px;" /></span><span style="width:40%;display:inline-block;text-align:left;padding-left:10px;"><input class="easyui-linkbutton-gray" type="button" value="取消" id="confirm_cancel" /></span></div>
</div>

</body>
</html>
<script type="text/javascript">
    var user_level = '${sessionScope.UserInfo.LEVEL}';
    var roleName='';
    var areaJSON=${e:java2json(areaList.list)};
    var cityJSON = ${e:java2json(cityList.list)};
    var centerJSON = ${e:java2json(centerList.list)};
    var gridJSON = ${e:java2json(gridList.list)};

    var curr_time = new Date();
    var sql_url = '<e:url value="/pages/telecom_Index/common/sql/tabData_add4_order.jsp" />';
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "getAdd4RepairList",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '${param.branch_id}';
    var grid_id_temp = '${param.grid_id}';

    if(city_id_temp=="" || city_id_temp==undefined || city_id_temp=="undefined")
        city_id_temp = '${sessionScope.UserInfo.AREA_NO}';
    if(bureau_id_temp=="" || bureau_id_temp==undefined || bureau_id_temp=="undefined")
        bureau_id_temp = '${sessionScope.UserInfo.CITY_NO}';
    if(branch_id_temp=="" || branch_id_temp==undefined || branch_id_temp=="undefined")
        branch_id_temp = '${sessionScope.UserInfo.TOWN_NO}';
    if(grid_id_temp=="" || grid_id_temp==undefined || grid_id_temp=="undefined")
        grid_id_temp = '${sessionScope.UserInfo.GRID_NO}';

    var village_id_temp = "";
    var query_text = "";
    //var vil_type_temp = "";
    var radio0 = "";
    var radio1 = "";

    var order_id_for_edit = "";

    var fgl = 'all';
    var stl = 'all';
    var jzcd_flag = '';
    var villageMode_flag = '';
    var portLv_flag = '';
    var line_flag = '';

    //如果已经没有数据, 则不再次发起请求.
    var hasMore = true;

    var init_tab_height = 0;

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
        areaSelect.areaName='areaNoDiv';
        areaSelect.cityName='cityNoDiv';
        areaSelect.centerName='centerNoDiv';
        areaSelect.gridName='gridNoDiv';
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

        if(city_id_temp == '999' || city_id_temp=='' ){
            //$(areaNo).combobox('select','');
            $("#areaNo").val('');
        }else {
            //$(areaNo).combobox('select',city_id_temp);
            $("#areaNo").children("[value='"+city_id_temp+"']").attr("selected","selected");
            $("#cityNo").children("[value='"+bureau_id_temp+"']").attr("selected","selected");
            $("#centerNo").children("[value='"+branch_id_temp+"']").attr("selected","selected");
            $("#gridNo").children("[value='"+grid_id_temp+"']").attr("selected","selected");
            /*if(user_level<3)
                $("#areaNo").trigger("change");*/
        }

        //网格联动出小区
        /*$("#gridNo").bind("change",function(){
            grid_id_temp = $("#gridNo").val();
            if(grid_id_temp!=''){
                changeVillageSelect(grid_id_temp);
            }
        });*/
        //changeVillageSelect(grid_id_temp);
        resetSelectFunc();
    }

    function resetSelectFunc(){
        if(user_level==2){
            $("#cityNo").removeAttr("disabled");
            //$("#centerNo").removeAttr("disabled");
            //$("#gridNo").removeAttr("disabled");
        }else if(user_level==3){
            $("#centerNo").removeAttr("disabled");
            //$("#gridNo").removeAttr("disabled");
        }else if(user_level==4){
            $("#gridNo").removeAttr("disabled");
        }
    }

    function initQueryOpt(){
        var qt = '${param.query_type}';
        /*if(qt==1){
            $("input[name='radio0']").removeAttr("checked");
            $("input[name='radio0'][value='0']").attr("checked","checked");
        }else if(qt==2){
            $("input[name='radio0']").removeAttr("checked");
            $("input[name='radio0'][value='0']").attr("checked","checked");
        }*/
    }

    var option_default = "<option value='-1'>请选择</option>";

    //var long_message_width = 0;
    $(function(){
        if("${param.query_type}"!=""){
            $("#closeTab1").show();
        }else
            $("#closeTab1").hide();
        $("#closeTab1").unbind();
        $("#closeTab1").on("click",function(){
            parent.closeDetail();
        });

        init_tab_height = $(".sub_box ").height() - $(".big_table_title").height() - $(".search").height() - $(".rows_num").height();
        //long_message_width = $("#data_list").width()*0.17;

        //var a=$('#acctday').datebox('getValue').replace(/-/g, "");

        /*initCitySelect(user_level);
        initBureauSelect(user_level);
        initBranchSelect(user_level);
        initGridSelect(user_level);*/
        initAreaSelect();

	    //initTabHeight_province();
        initTabHeight_city();

        //initQueryOpt();
        //$(".t_body>table").width($(".table1:eq(0)").width()+2);

        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        /*$('.t_body').scroll(function () {
            //alert($(this).scrollLeft());
            $('#table_head').css('margin-left', -($('.t_body').scrollLeft()));
            $('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
        });
        $('#tbody2').scroll(function () {
            $('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
        });*/
        $("#closeTab").on("click",function(){
            load_map_view();
        });

        //归集小区
        $("input[name='radio0']").on("click",function(){
            clear_data();
            query(1);
        });
        //GIS上图
        $("input[name='radio1']").on("click",function(){
            clear_data();
            query(1);
        });

        query(1);

        //日期控件
        /*$("#acctday").datebox({
            onChange: function(date){
                acct_mon = date;
                acct_mon = acct_mon.replace(/-/g,'');
                clear_data();
                query();
            }
        });
        $("#acctday").datebox('setValue','${initTime.VAL}');*/
        $("#query_btn").on("click",function(){query(1);});

        $("#query_text").css({"width":$("#query_text").parent().width()-$("#query_btn").width()-20});

    });

    function initTabHeight_province(){
        $("#big_table_info_div").css("max-height", init_tab_height);
    }
    function initTabHeight_city(){
        $("#big_table_info_div").css("max-height", init_tab_height-78);
    }

    $("#big_table_info_div").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                page_list++;
                query(0);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function query(is_first) {
        if(is_first==undefined){
            is_first = 1;
        }
        if(is_first==1)
            clear_data();

        listCollectScroll(is_first);
    }

    function listCollectScroll(is_first) {
        var params = getParams();
        var $list = $("#data_list");
        if (hasMore) {
            $.post(sql_url, params, function (data) {
                var objs = $.parseJSON(data);

                if(page_list==0){
                    if(objs.length){
                        $("#total_num").text(objs[0].C_NUM);
                    }else{
                        $("#total_num").text("0");
                    }
                }

                for (var i = 0, l = objs.length; i < l; i++) {
                    var d = objs[i];
                    var newRow = "<tr><td class='text-center'>" + (++seq_num) + "</td>";//序号

                    if('${sessionScope.UserInfo.LEVEL}'<4)
                        newRow += "<td class='text-left' style='padding-left:5px;'><span>"+ d.ORDER_ID +"</span><br/><span>"+ d.ORDER_SUB +"</span></td>";
                    else
                        newRow += ""
                            +"<td class='text-left' style='padding-left:5px;' onclick='javascript:to_add4_order_edit(\""+d.ORDER_ID_NUM+"\")'><span style=\"cursor:pointer;\">" + d.ORDER_ID + "</span><br/><span class=\"clickable\" style=\"cursor:pointer;\">" + d.ORDER_SUB + "</span></td>";//工单主题

                    newRow +=
                    "<td class='text-center'>" + d.SEND_TIME + "</td>"//派单时间
                    +"<td class='text-center'>" + d.OPR_NAME + "</td>"//处理人
                    +"<td class='text-center'>" + d.OPR_TIME + "</td>"//处理时间
                    +"<td class='text-center'>" + d.OPR_TEL + "</td>"//联系电话
                    +"<td class='text-center'>" + d.ORDER_STATUS_TEXT + "</td>"//工单状态
                    +"<td class='text-center'>" + d.ORDER_CONFIRM_TEXT + "</td>"//确认结果

                    +"</tr>";
                    $list.append(newRow);
                }
                //只有第一次加载没有数据的时候显示如下内容
                if (objs.length == 0 && is_first) {
                    $list.empty();
                    $list.append("<tr><td style='text-align:center' colspan='15' >没有查询到数据</td></tr>")
                }
            });
        }
    }

    var width = document.body.clientWidth * 0.8;
    var height = document.body.clientHeight * 0.85;

    var order_edit_pop_win_handler = "";

    function to_add4_order_edit(order_id){
        layer.close(order_edit_pop_win_handler);
        order_id_for_edit = order_id;
        //工单填写初始化
        $.post(sql_url,{"eaction":"getAdd4RepairList","order_id":order_id},function(data){
            var data = $.parseJSON(data);
            if(data.length){
                var d = data[0];
                $("#ew_order_id").text(d.ORDER_ID_NUM);
                $("#ew_order_title").text(d.ORDER_SUB);
                $("#ew_sender").text(d.USER_NAME);
                $("#ew_sender_tel").text(d.USER_TEL);
                $("#ew_latn_name").text(d.LATN_NAME);
                $("#ew_bureau_name").text(d.BUREAU_NAME);
                $("#ew_sender_time").text(d.SEND_TIME);
                $("#ew_order_content").text(d.ORDER_CONTENT);
                $("#ew_order_content").prepend("<span class=\"span_head\">工单内容：</span>");
                $("#ew_order_status").text(d.ORDER_STATUS_TEXT);
                $("#ew_opr_name").text(d.OPR_NAME);
                $("#ew_opr_tel").text(d.OPR_TEL);
                $("#ew_opr_time").text(d.OPR_TIME);
                $("#ew_back_content").text(d.BACK_CONTENT);
                $("#ew_order_confirm").text(d.ORDER_CONFIRM_TEXT);

                /*$("#ew_order_status").removeClass("green");
                $("#ew_order_status").removeClass("red");
                $("#ew_order_confirm").removeClass("red");
                $("#ew_order_confirm").removeClass("green");*/

                $("#order_ok").unbind();
                $("#order_ok").removeClass("easyui-linkbutton");
                $("#order_ok").addClass("easyui-linkbutton-gray");

                if(d.ORDER_STATUS == -1){
                    $("#ew_opr_name").text("--");
                    $("#ew_opr_tel").text("--");
                    $("#ew_opr_time").text("--");
                    $("#ew_back_content").text("--");
                    //$("#ew_order_status").addClass("green");
                    //$("#ew_order_confirm").addClass("green");
                    $("#order_ok").bind("click",function(){layer.msg("请等待工单处理完成");});
                }else{//工单已处理，则到确认环节
                    /*if(d.ORDER_STATUS == 0){//工单无法处理
                        $("#ew_order_status").addClass("red");
                    }*/

                    if(d.ORDER_CONFIRM!=null){//工单已确认
                        $("#order_ok").unbind();
                        $("#order_ok").bind("click",function(){layer.msg("工单已经确认");});
                        /*if(d.ORDER_CONFIRM == 0)
                            $("#ew_order_confirm").addClass("red");*/
                    }else{//工单未确认
                        //$("#ew_order_confirm").addClass("green");

                        $("#order_ok").removeClass("easyui-linkbutton-gray");
                        $("#order_ok").addClass("easyui-linkbutton");
                        $("#order_ok").unbind();
                        $("#order_ok").bind("click",function(){order_confirm();});
                    }
                }
            }else{
                layer.msg("该记录已被删除！");
            }
        });

        //弹窗
        order_edit_pop_win_handler = layer.open({
            title: "工单详情",
            //maxmin: true, //开启最大化最小化按钮
            type: 1,
            shade: 0,
            area: [width,height],
            content: $("#add4_order_edit_pop_win"),
            skin: 'win_add4_repair',
            cancel: function (index) {
                layer.close(confirm_pop_win_handler);
            }/*,
             full: function() { //点击最大化后的回调函数
             $(".summary_market .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
             resizeMainContainer();
             },
             restore: function() { //点击还原后的回调函数
             $(".summary_market .layui-layer-setwin").css("top",'6px');
             resizeMainContainer();
             }*/
        });
    }

    var confirm_pop_win_handler = "";
    function order_confirm(){
        confirm_pop_win_handler = layer.open({
            title: "修正确认",
            type: 1,
            shade: 0,
            area: [400,250],
            content: $("#confirm_order_pop_win"),
            skin: 'win_add4_repair',
            cancel: function(index){
                layer.close(order_edit_pop_win_handler);
            }
        });
        $("#confirm_ok").unbind();
        $("#confirm_ok").bind("click",function(){
            var order_confirm = $("input[name='order_confirm']:checked").val();
            $.post(sql_url,{"eaction":"updateAdd4Confirm","order_confirm":order_confirm,"order_id":order_id_for_edit},function(data){
                var data = $.parseJSON(data);
                if(data){
                    layer.msg("保存成功");
                    setTimeout(function(){
                        layer.close(confirm_pop_win_handler);
                        layer.close(order_edit_pop_win_handler);
                        query(1);
                    },1500);
                }
            });
        });
        $("#confirm_cancel").unbind();
        $("#confirm_cancel").bind("click",function(){
            layer.close(confirm_pop_win_handler);
        });
    }

    function clear_data() {
        begin = 0, end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,
        query_sort = '0', radio0 = 0, radio1 = 0;
        $("#total_num").text("0");
        $("#data_list").empty();
        $("#download_div").hide();
    }
    function getParams() {
        city_id_temp = $("#areaNo option:selected").val();
        bureau_id_temp = $("#cityNo option:selected").val();
        branch_id_temp = $("#centerNo option:selected").val();
        grid_id_temp = $("#gridNo option:selected").val();
        radio0 = $("input[name='radio0']:checked").val();
        radio1 = $("input[name='radio1']:checked").val();
        query_text = $("#query_text").val();

        return params = {
            "eaction": eaction,
            "city_id":city_id_temp,
            "bureau_id":bureau_id_temp,
            "branch_id":branch_id_temp,
            "grid_id":grid_id_temp,
            "query_text":query_text,
            "radio0":radio0,
            "radio1":radio1,
            "page": page_list
        }
    }
    function clear_option(level){
        //if(level<6)
            //$("#village_select").empty();
        if(level<5){
            $("#centerNo").empty();
            $("#centerNo").append(option_default);
        }
        if(level<4){
            $("#centerNo").empty();
            $("#centerNo").append(option_default);
        }
	    if(level<3){
            $("#cityNo").empty();
            $("#cityNo").append(option_default);
        }
        $("#village_select").empty();
        $("#village_select").append(option_default);
    }

    function change_region(type) {
        $(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
        clear_data();
        query_flag = type;
        //$("#big_table_collect_type > span").eq(0).click();
    }

    function addOption(data_list,element_id){
        for(var i = 0,l = data_list.length;i<l;i++){
            var data = data_list[i];
            $("#"+element_id).append("<option value='"+data.VAL+"'>"+data.NAME+"</option>");
        }
    }
    function initCitySelect(user_level){
        //if(user_level>1){
            $("#areaNo").val(city_id_temp);
            $("#areaNo").attr("disabled","disabled");
        //}
    }
    function initBureauSelect(user_level){
        //if(user_level>2){
            $("#cityNo").val(bureau_id_temp);
            $("#cityNo").attr("disabled","disabled");
        //}
    }
    function initBranchSelect(user_level){
        //if(user_level>3){
            $("#centerNo").val(branch_id_temp);
            $("#centerNo").attr("disabled","disabled");
        //}
    }
    function initGridSelect(user_level){
        //if(user_level>4){
            $("#gridNo").val(grid_id_temp);
            $("#gridNo").attr("disabled","disabled");
        //}
    }
    function initVillageSelect(){

    }

    function backup(level){
        initListDiv(1);
    }

</script>