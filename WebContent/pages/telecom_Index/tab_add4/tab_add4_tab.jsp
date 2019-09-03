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
        and T.latn_id = '${param.city_id}'
    </e:if>
    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY city_order_num
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT  T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.region_order_num FROM ${gis_user}.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
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
    SELECT T.bureau_no PID, T.union_org_code CODE, T.branch_name  TEXT FROM ${gis_user}.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='a1'
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
    and t.branch_type='a1' and t.grid_union_org_code is not null
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
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>四级地址查询</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/areaSelectAddon.js"/>' charset="utf-8"></script>
    <style>
        #tools{height:95%;}
        #query_div{width:120px;height:47px;padding:0;position:absolute;display:none;}
        #query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
        .ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
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
        .datagrid-header {height:auto;line-height:auto;}
        .cityNo a {    display: block;
            float: left;
            margin-right: 20px;width:auto;}
        .cityNo a.selected {background-color: #ff8a00;
            width: auto;
            height: auto;
            text-align: center;
            border-radius: 4px;
            color: #fff;}
        .search_head{
            width:7%;
            text-align:right;
            font-weight:bold;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }
        .search{
            background: #043572;
            width:100%;
            color:#fff;
            border:1px solid  #999;
        }
        .search a{
            color:#fff;
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
        }
        /*.slt_select,.fgl_select{display:inline-block;}
        .fgl_select{margin-left:30px;}*/
        .table1 tr:nth-child(1) td{background:none;}
        .important td{color:#fa8513!important;}
        #table_head,#big_tab_info_list{border-color:#aaa;}
        .search{border-color:#1851a9;}
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
        .search_head span{
            background: none!important;
        }
        #download_div {display:none;}
        #table_head tr:first-child th:first-child{width:4%!important;}
        #table_head tr:first-child th:nth-child(2){width:20%!important;}
        #table_head tr:first-child th:nth-child(3){width:4%!important;}

        #table_head tr:first-child th:nth-child(4){width:21%!important;}
        #table_head tr:first-child th:nth-child(5){width:7%!important;}
        #table_head tr:first-child th:nth-child(6){width:11%!important;}
        #table_head tr:first-child th:nth-child(7){width:19%!important;}

        #table_head tr:nth-child(2) th:first-child{width:5%!important;}
        #table_head tr:nth-child(2) th:nth-child(2){width:5%!important;}
        #table_head tr:nth-child(2) th:nth-child(3){width:5%!important;}
        #table_head tr:nth-child(2) th:nth-child(4){width:6%!important;}

        #table_head tr:nth-child(2) th:nth-child(5){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(6){width:7%!important;}

        #table_head tr:nth-child(2) th:nth-child(7){width:12%!important;}
        #table_head tr:nth-child(2) th:nth-child(8){width:7%!important;}

        #table_head tr:first-child th:nth-child(8){width:7%!important;}
        #table_head tr:first-child th:nth-child(9){width:7%!important;}

        #data_list tr td:first-child {width:4%!important;}
        #data_list tr td:nth-child(2){width:20%!important;}
        #data_list tr td:nth-child(3){width:4%!important;}

        #data_list tr td:nth-child(4){width:5%!important;}
        #data_list tr td:nth-child(5){width:5%!important;}
        #data_list tr td:nth-child(6){width:5%!important;}
        #data_list tr td:nth-child(7){width:6%!important;}

        #data_list tr td:nth-child(8){width:7%!important;}

        #data_list tr td:nth-child(9){width:4%!important;}
        #data_list tr td:nth-child(10){width:7%!important;}

        #data_list tr td:nth-child(11){width:12%!important;}
        #data_list tr td:nth-child(12){width:7%!important;}

        #data_list tr td:nth-child(13){width:7%!important;}
        #data_list tr td:nth-child(14){width:7%!important;}

        #data_list td {font-size:12px;}

        .table1 tbody tr td:nth-child(4){min-width: 0px!important;}
        .vil_type_condition span {display:inline-block;margin-right:15px;cursor:pointer;}
        /*#village_select {float:left;width:70%;}*/
        .zj_submit {color:#fff;border:none;background:#086db7;width:65px;float:right;cursor:pointer;}
        .panel-body {background:#fff;}
        .textbox {background:none;}
        .textbox combo {border:1px solid #fff;}
        .trans_condition {background:none;border:1px solid #3E4997;}
        .textbox-addon {right:-8px!important;}
        .download_btn {top:20px;}
        select {line-height:25px!important;height:25px!important;}
        input {line-height:25px!important;height:25px!important;}
        /*2018.9.17 新样式*/
        #total_num {color:red;}
        /*表格中要突出的字*/
        .text-important {color:#00FFFF!important;}
        .text-important-a {color:#4CB9F9!important;}
        .text-important-b {color:#fa8513!important;}
        .vil_type_condition .selected{
            color:#FFCC33;
        }
        .sub_box {background:#011157;}

        /*数据列表表头*/
        #table_head th, #big_table_content th{background:none;}
        #table_head thead tr th{
            border:1px solid #333399;
        }
        /*数据列表表体*/
        .table1 td {border-color:#333366;}

        /*本页标题*/
        .sub_box .big_table_title {height:28px;}
        .sub_box .big_table_title h4 {font-size:20px;}
        .select_width {width:100%;color:#aaa;}
        #big_table_info_div {overflow-y: scroll;}
        /*记录数*/
        .rows_num {height:32px;line-height:32px;}

        #add4_name_text {color:#aaa;width:100%;}/*width:80%*/
        .clickable {color:#4CB9F9!important;text-decoration:underline;cursor:pointer;}
        .close_button {top:12px;}
        .select_option span {margin-right:8%;display:inline-block;}
        .select_option2 span {width:23%;display:inline-block;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>四&nbsp;级&nbsp;地&nbsp;址&nbsp;查&nbsp;询</h4></div>
        <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">

        </e:if>
        <div class="close_button" id="closeTab1"></div>
        <!--<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>-->
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search">
                    <tr style="display: none;">
                        <td class="search_head"><span>帐&nbsp;&nbsp;&nbsp;&nbsp;期:</span></td></td>
                        <td style="padding-left:8px;" colspan="6"><input id="acctday" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;" /></td>
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
                        <td style="width:14%;">
                            <!--<select id="bureau_select" class="trans_condition select_width" onchange="bureauSwitch()">
                            </select>-->
                            <select id="cityNo" name="cityNo" class="trans_condition select_width"></select>
                        </td>
                        <!-- 支局 -->
                        <td class="search_head"><span>支局：</span></td>
                        <td style="width:14%;">
                            <!--<select id="branch_select" class="trans_condition select_width" onchange="branchSwitch()">
                            </select>-->
                            <select id="centerNo" name="centerNo" class="trans_condition select_width"></select>
                        </td>
                        <td width="width:27%;"></td>
                    </tr>
                    <tr id="bqfq_tj" style="">
                        <!-- 网格 -->
                        <td class="search_head"><span>网格：</span></td>
                        <td style="width:14%;">
                            <!--<select id="grid_select" class="trans_condition select_width" onchange="gridSwitch()">
                            </select>-->
                            <select id="gridNo" name="gridNo" onchange="query()" class="trans_condition select_width"></select>
                        </td>

                        <!-- 小区 -->
                        <td class="search_head"><span>小区：</span></td>
                        <td style="width:14%;">
                            <select id="village_select" class="trans_condition select_width" onchange="villageSwitch()">
                            </select>
                        </td>
                        <td class="search_head"><span>四级地址：</span></td>
                        <td style="width:14%;">
                            <input id="add4_name_text" class="trans_condition" type="text" placeholder="请输入四级地址关键字" />
                        </td>
                        <td style="width:1%;"></td>
                    </tr>
                    <tr>
                        <td class="search_head"><span>归集小区：</span></td>
                        <td class="text-left select_option">
                            <span><input type="radio" name="in_vill_radio" value="" checked="checked" />全部&nbsp;&nbsp;</span>
                            <span><input type="radio" name="in_vill_radio" value="1" />已归集&nbsp;&nbsp;</span>
                            <span><input type="radio" name="in_vill_radio" value="0" />未归集</span>
                        </td>
                        <td class="search_head"><span>上图时间：</span></td>
                        <td class="text-left select_option">
                            <span><input type="radio" name="gis_radio" value="" checked="checked" />全部&nbsp;&nbsp;</span>
                            <span><input type="radio" name="gis_radio" value="3" />3个月内&nbsp;&nbsp;</span>
                            <span><input type="radio" name="gis_radio" value="6" />6个月内</span>
                        </td>
                        <td class="search_head"><span>网络资源：</span></td>
                        <td class="text-left select_option2">
                            <span><input type="radio" name="res_radio" value="" checked="checked" />全部&nbsp;&nbsp;</span>
                            <span><input type="radio" name="res_radio" value="1" />已达&nbsp;&nbsp;</span>
                            <span><input type="radio" name="res_radio" value="0" />未达</span>

                            <input type="button" value="查询" id="query_btn" class="zj_submit" style="float:right;" />
                        </td>
                        <td style="width:1%;"></td>
                    </tr>
                    <%--<tr id="bqfq_tj" style="">
                        <!-- 四级地址 -->
                        <td class="search_head"><span>四级地址：</span></td>
                        <td colspan="6">
                            <input id="add4_name_text" class="trans_condition" type="text" placeholder="请输入四级地址关键字" />
                            <input type="button" value="查询" id="query_btn" class="zj_submit" style="margin-right:1%;" />
                        </td>
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
                                    <th rowspan="2">序号</th>
                                    <th rowspan="2">四级地址</th>
                                    <th rowspan="2">六级<br/>地址数</th>
                                    <th colspan="4">资源</th>
                                    <th rowspan="2">标准地址<br/>创建时间</th>
                                    <th colspan="2">GIS上图</th>
                                    <th colspan="2">小区</th>
                                    <th rowspan="2">支局</th>
                                    <th rowspan="2">网格</th>
                                </tr>
                                <tr>
                                    <th>OBD数</th>
                                    <th>端口数</th>
                                    <th>占用数</th>
                                    <th>端口占用率</th>

                                    <th>是否上图</th>
                                    <th>上图时间</th>

                                    <th>小区名称</th>
                                    <th>创建时间</th>
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
    var url4data_vill_market = '<e:url value="/pages/telecom_Index/common/sql/tabData_add4.jsp" />';
    var url4data = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp" />';
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "getAdd4List",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '${param.branch_id}';
    var grid_id_temp = '${param.grid_id}';
    var village_id_temp = "";
    var add4_name_text = "";
    //var vil_type_temp = "";
    var in_vill_radio = "";
    var gis_radio = "";
    var res_radio = "";

    var fgl = 'all';
    var stl = 'all';
    var jzcd_flag = '';
    var villageMode_flag = '';
    var portLv_flag = '';
    var line_flag = '';

    //如果已经没有数据, 则不再次发起请求.
    var hasMore = true;

    var init_tab_height = 0;

    var table_rows_array = "";
    var table_rows_array_small_screen = [20,25,35];
    var table_rows_array_big_screen = [30,40,50];

    if(window.screen.height<=768){
        table_rows_array = table_rows_array_small_screen;
    }else{
        table_rows_array = table_rows_array_big_screen;
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
            if(city_id_temp!="")
                filterBureauByCity(city_id_temp);
            $("#cityNo").children("[value='"+bureau_id_temp+"']").attr("selected","selected");
            if(bureau_id_temp!="")
                filterBranchByBureau(bureau_id_temp);
            $("#centerNo").children("[value='"+branch_id_temp+"']").attr("selected","selected");
            if(branch_id_temp!="")
                filterGridByBranch(branch_id_temp);
            $("#gridNo").children("[value='"+grid_id_temp+"']").attr("selected","selected");
            /*if(user_level<3)
                $("#areaNo").trigger("change");*/
        }

        //网格联动出小区
        $("#gridNo").bind("change",function(){
            grid_id_temp = $("#gridNo").val();
            if(grid_id_temp!=''){
                changeVillageSelect(grid_id_temp);
            }
        });
        changeVillageSelect(grid_id_temp);
        resetSelectFunc();
    }

    function resetSelectFunc(){
        if(user_level==2){
            $("#areaNo").attr("disabled",true);
            $("#cityNo").removeAttr("disabled");
            if(bureau_id_temp!="")
                $("#centerNo").removeAttr("disabled");
            else
                $("#centerNo").attr("disabled",true);
            $("#gridNo").attr("disabled",true);
        }else if(user_level==3){
            $("#areaNo").attr("disabled",true);
            $("#cityNo").attr("disabled",true);
            $("#centerNo").removeAttr("disabled");
            if(branch_id_temp!="")
                $("#gridNo").removeAttr("disabled");
            else
                $("#gridNo").attr("disabled",true);
        }else if(user_level==4){
            $("#areaNo").attr("disabled",true);
            $("#cityNo").attr("disabled",true);
            $("#centerNo").attr("disabled",true);
            $("#gridNo").removeAttr("disabled");
        }
    }

    function initQueryOpt(){
        var qt = '${param.query_type}';
        if(qt==1){
            $("input[name='in_vill_radio']").removeAttr("checked");
            $("input[name='in_vill_radio'][value='0']").attr("checked","checked");
        }else if(qt==2){
            $("input[name='in_vill_radio']").removeAttr("checked");
            $("input[name='in_vill_radio'][value='0']").attr("checked","checked");
            $("input[name='res_radio']").removeAttr("checked");
            $("input[name='res_radio'][value='1']").attr("checked","checked");
        }
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

        init_tab_height = document.body.offsetHeight*0.94 - 100 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();
        //long_message_width = $("#data_list").width()*0.17;

        //var a=$('#acctday').datebox('getValue').replace(/-/g, "");

        /*initCitySelect(user_level);
        initBureauSelect(user_level);
        initBranchSelect(user_level);
        initGridSelect(user_level);*/
        initAreaSelect();

	    initTabHeight_province();
        initTabHeight_city();

        initQueryOpt();
        //$(".t_body>table").width($(".table1:eq(0)").width()+2);

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
        });

        //归集小区
        $("input[name='in_vill_radio']").on("click",function(){
            clear_data();
            query(true);
        });
        //GIS上图
        $("input[name='gis_radio']").on("click",function(){
            clear_data();
            query(true);
        });
        //资源上图
        $("input[name='res_radio']").on("click",function(){
            clear_data();
            query(true);
        });

        query(true);

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
        //$("#village_select").width(($("#village_select").parent().width()-$(".zj_submit").width())-20);
        //$(".zj_submit").css("margin-right",$(".search").width()*0.7);
        //$("#add4_name_text").width($("#add4_name_text").parent().width()-$(".zj_submit").width()-50);
        $("#query_btn").on("click",function(){query(true);});
    });

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-12);
    }

    $("#big_table_info_div").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                page_list++;
                if(total_num<=seq_num)
                    query(false);
                else
                    query(true);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function query(is_first) {
        if(!is_first){
            clear_data();
            is_first = true;
        }

        listCollectScroll(is_first);
    }

    var total_num = 0;
    function listCollectScroll(is_first) {
        var params = getParams();
        var $list = $("#data_list");
        if (hasMore) {
            $.post(url4data_vill_market, params, function (data) {
                data = $.parseJSON(data);
                if(data.length){
                    $("#download_div").show();
                }else
                    $("#download_div").hide();
                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    if(i==0 && is_first){
                        total_num = d.C_NUM;
                        $("#total_num").text(d.C_NUM);
                    }
                    var newRow = "<tr><td class='text-center'>" + (++seq_num) + "</td>";//序号

                    if('${sessionScope.UserInfo.LEVEL}'<4){
                        newRow += "<td class='text-left'>"+ d.STAND_NAME +"</td>";
                    }else
                        newRow += "<td class='text-left clickable' onclick='javascript:toMap_add4(\""+ d.LATN_ID +"\",\""+ d.SEGM_ID +"\")'>" + d.STAND_NAME + "</td>";//四级地址

                    newRow += ""
                    +"<td class='text-center'>" + d.ZHU_HU_COUNT + "</td>"//六级地址数
                    +"<td class='text-center'>" + d.OBD_CNT + "</td>"//OBD数
                    +"<td class='text-center'>" + d.PORT_ID_CNT + "</td>"//端口数
                    +"<td class='text-center'>" + d.USE_PORT_CNT + "</td>"//占用数
                    +"<td class='text-center text-important-b'>" + d.PORT_LV + "</td>"//端口占用率
                    +"<td class='text-center'>" + d.CREATE_DATE + "</td>"//标准地址创建时间
                    +"<td class='text-center'>" + d.GIS_FLG + "</td>"//是否上图
                    +"<td class='text-center'>" + d.GIS_DATE + "</td>"//上图时间
                    +"<td class='text-center'>" + d.VILLAGE_NAME + "</td>"//小区名称
                    +"<td class='text-center'>" + d.CREATE_TIME + "</td>"//创建时间
                    +"<td class='text-center'>" + d.BRANCH_NAME + "</td>"//支局
                    +"<td class='text-center'>" + d.GRID_NAME + "</td>"//网格

                    +"</tr>";
                    $list.append(newRow);
                }
                //只有第一次加载没有数据的时候显示如下内容
                if (data.length == 0) {
                    hasMore = false;
                    if (is_first) {
                        $list.empty();
                        $list.append("<tr><td style='text-align:center' colspan='15' >没有查询到数据</td></tr>")
                    }
                }
            });
        }
    }

    function toMap_add4(latn_id,segm_id){
        global_res_id = segm_id;
        global_current_city_id = latn_id;
        if('${sessionScope.UserInfo.LEVEL}' == '4' || '${sessionScope.UserInfo.LEVEL}' == '5'){
            debugger;
            if(global_add4_position_flag!="2"){
                layer.msg("等待地图初始化完成");
                return;
            }else{
                try{
                    load_map_view();
                }catch(e){
                }
                if('${sessionScope.UserInfo.LEVEL}' == '4' || '${sessionScope.UserInfo.LEVEL}' == '5'){
                    global_func_general_location();
                }else{
                    $.post(url4data,{"eaction":"getOrgsByResid","add4":segm_id,"city_id":latn_id},function(data){
                        var data = $.parseJSON(data);
                        global_current_full_area_name = data.BUREAU_NAME;
                        global_current_flag = 2;

                        global_current_city_id = data.LATN_ID;
                        global_current_area_name = data.BUREAU_NAME;//城关区

                        global_position.splice(1,1,data.LATN_NAME);
                        //global_position.splice(2,1,data.BUREAU_NAME);
                        //if(zxs[data.BUREAU_NAME]!=undefined){
                        //    global_position.splice(2,1,data.BUREAU_NAME);
                        //}

                        //echarts地图刷新和gis都要重新加载地图和指标侧边，执行下面两句
                        if(global_region_type=="city" || global_region_type=="bureau")
                            global_region_type = "sub";
                        var url = "";
                        if('${sessionScope.UserInfo.LEVEL}' == '1' || '${sessionScope.UserInfo.LEVEL}' == '2')
                            url = map_url_bureau_school;
                        //else if('${sessionScope.UserInfo.LEVEL}' == '3')
                        //    url = map_url_bureau_user;
                        global_add4_position_flag = 2;
                        freshMapContainer(url);
                    });
                }
            }
        }
    }

    function clear_data() {
        begin = 0, end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,
        query_sort = '0', in_vill_radio = 0, gis_radio = 0, res_radio = 0;
        $("#total_num").text("0");
        $("#data_list").empty();
        $("#download_div").hide();
    }
    function getParams() {
        city_id_temp = $("#areaNo option:selected").val();
        bureau_id_temp = $("#cityNo option:selected").val();
        branch_id_temp = $("#centerNo option:selected").val();
        grid_id_temp = $("#gridNo option:selected").val();
        village_id_temp = $("#village_select option:selected").val();
        add4_name_text = $("#add4_name_text").val();
        in_vill_radio = $("input[name='in_vill_radio']:checked").val();
        gis_radio = $("input[name='gis_radio']:checked").val();
        res_radio = $("input[name='res_radio']:checked").val();

        return params = {
            "eaction": eaction,
            "city_id":city_id_temp,
            "bureau_id":bureau_id_temp,
            "branch_id":branch_id_temp,
            "grid_id":grid_id_temp,
            "village_id":village_id_temp,
            "add4_name":add4_name_text,
            "in_vill_radio":in_vill_radio,
            "gis_radio":gis_radio,
            "res_radio":res_radio,
            "page": page_list,
            "pageSize": table_rows_array[0]
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
    function changeBureauSelect(city_id_temp){
        $.post(url4data_vill_market,{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
            var data_list = $.parseJSON(data);
            $("#bureau_select").empty();
            addOption(data_list,"bureau_select");
        });
    }

    function changeBranchSelect(bureau_no){
        $("#branch_select").empty();
        $.post(url4data_vill_market,{"eaction":"getBranchByBureauId","bureau_id":bureau_no},function(data){
            var data_list = $.parseJSON(data);
            addOption(data_list,"branch_select");
        });
    }

    function changeGridSelect(branch_id){
        $("#grid_select").empty();
        $("#grid_select").append(option_default);
        $.post(url4data_vill_market,{"eaction":"getGridByBranchId","branch_id":branch_id},function(data){
            var data_list = $.parseJSON(data);
            addOption(data_list,"grid_select");
            /*if(data_list.length==1){//支局下无网格
                changeVillageSelect(branch_id);
            }*/
        });
    }

    function changeVillageSelect(grid_id_temp){
        $("#village_select").empty();
        $("#village_select").append(option_default);
        $.post(url4data_vill_market,{"eaction":"getVillageIdByGridId","grid_id":grid_id_temp},function(data){
            var data_list = $.parseJSON(data);
            addOption(data_list,"village_select");
        });
    }

    function citySwitch(){
        if(user_level>1)
            return;
        var city_id = $("#city_select option:checked").val();
        if(city_id=='-1'){
            //initTabHeight_province();
            //document.getElementById("bqfq_tj").style.display="none";
            city_id='';
        }else{
            //initTabHeight_city();
            $(".line_select_bq").empty();
            changeBureauSelect(city_id);
            //$("#bqfq_tj").show();
        }
        city_id_temp = city_id;
        bureau_id_temp='';
        branch_id_temp='';
        grid_id_temp='';
        //village_name_temp = "";
        //changeVillageSelect(bureau_id_temp);
        clear_data();
        clear_option(2);
        query(true);
    }
    function bureauSwitch(){
        if(user_level>2)
            return;
        /*if(bureau_id=='999')
            bureau_id = "";*/
        bureau_id_temp = $("#bureau_select option:checked").val();
        if(bureau_id_temp=='-1')
            bureau_id_temp='';
        else
            changeBranchSelect(bureau_id_temp);
        branch_id_temp='';
        grid_id_temp='';
        //village_name_temp = "";
        //changeVillageSelect(bureau_id_temp);
        clear_data();
        clear_option(3);
        query(true);
    }
    function branchSwitch(){
        if(user_level>3)
            return;
        branch_id_temp = $("#branch_select option:checked").val();
        if(branch_id_temp=='-1')
            branch_id_temp='';
        else
            changeGridSelect(branch_id_temp);
        grid_id_temp = '';
        //village_id_temp = "";
        //branch_id_temp = $("#branch_select option:selected").val();
        //changeVillageSelect(branch_id_temp);

        clear_data();
        clear_option(4);
        query(true);
    }
    function gridSwitch(){
        if(user_level>4)
            return;
        grid_id_temp = $("#grid_select option:checked").val();
        if(grid_id_temp=='-1')
            grid_id_temp='';
        //village_id_temp = "";
        //branch_id_temp = $("#branch_select option:selected").val();
        changeVillageSelect(grid_id_temp);
        clear_data();
        //clear_option(5);
        query(true);
    }
    function villageSwitch(){
        village_id_temp = $("#village_select option:checked").val();
        if(village_id_temp=='-1')
            village_id_temp='';
        clear_data();
        query(true);
    }

</script>