<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="now">
    SELECT to_char(to_date(const_value,'yyyymmdd'),'yyyy-mm-dd') val FROM easy_data.sys_const_table WHERE const_type = 'var.dss28' AND data_type = 'day'
</e:q4o>
<e:q4o var="last_month">
    select to_char(last_day(add_months(sysdate,-1)),'yyyymm') val from dual
</e:q4o>
<e:set var="initTime">${now.VAL}</e:set>

<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT T.latn_id CODE, T.latn_name TEXT,city_order_num FROM  gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${param.city_id !=null && param.city_id  ne ''}">
        and T.latn_id = '${param.city_id}'
    </e:if>
    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY  city_order_num
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT  T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.region_order_num FROM gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${param.bureau_id !=null && param.bureau_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.region_order_num
    ORDER BY  T.region_order_num
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.union_org_code CODE, T.branch_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${param.branch_id !=null && param.branch_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.union_org_code = '${param.branch_id}'
    </e:if>
    group by T.bureau_no, T.union_org_code, T.branch_name,t.branch_no
    ORDER BY  T.branch_no
</e:q4l>

<e:description>网格</e:description>
<e:q4l var="gridList">
    SELECT  T.union_org_code PID, T.grid_id CODE, T.grid_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.grid_id IS NOT NULL
    and t.branch_type='a1' and t.grid_union_org_code is not null
    <e:if condition="${param.grid_id !=null && param.grid_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.union_org_code = '${param.branch_id}'
        and T.grid_id = '${param.grid_id}'
    </e:if>
    group by t.union_org_code,t.grid_id,t.grid_name
    ORDER BY T.grid_id
</e:q4l>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>重点指标统计</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <%--秦智宏：新加下拉框js--%>
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.8.0" />'  rel="stylesheet" type="text/css"
          media="all">
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
        .bureau_select a {    display: block;
            float: left;
            margin-right: 20px;width:auto;}
        .bureau_select a.selected {background-color: #ff8a00;
            width: auto;
            height: auto;
            text-align: center;
            border-radius: 4px;
            color: #fff;}
        .search_head{
            width:60px;
            text-align:center;
            font-weight:bold;
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
        .search_head span{
            background: none!important;
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
        .tab_scroll_x {width:100%;height:77.7%;overflow-x: scroll;overflow-y: hidden;border-right:solid 1px #092e67;}
        .table1.tab_head1 tr:nth-child(2) th:first-child {width:10%;}
        .combobox-item, .combobox-group, .combobox-stick {padding:2px 3px!important;font-size:13px;}
        .textbox .textbox-text {font-size:13px;}
        .l-btn-text {line-height:26px;}

        #areaNo,#cityNo,#centerNo,#gridNo {background: none;color: #aaa;width:100%;border:1px solid #3E4997;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:94%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>重&nbsp;点&nbsp;指&nbsp;标&nbsp;统&nbsp;计</h4></div>

        <table cellspacing="0" cellpadding="0" class="search">
            <tr  style="height: 50px;">
                <td width="230">
                    <div style="color:#FFFFFF; width:230px" class="databox_">
                        <span style ="font-weight:700;font-size:14px;">账&nbsp;&nbsp;&nbsp;&nbsp;期：</span>
                        <%--<input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>--%>
                        <c:datebox id="acctDate" name="acctDate" required="true" format="yyyy-mm-dd" defaultValue='${initTime}'/>
                    </div>
                </td>

                <div id="areaNoDiv">
                    <td class="search_head">分公司：</td>
                    <td  width="12%" align="left">
                        <%--<e:select id="areaNo" name="areaNo"
                                  items="${areaList.list}" label="TEXT" value="CODE"  class="easyui-combobox" headLabel="全省" headValue="" defaultValue="${param.city_id}"
                                  style="width:129px" editable="false"/>--%>
                         <select id="areaNo" name="areaNo"></select>
                    </td>
                </div>

                <div id="cityNoDiv" >
                    <td class="search_head">县区：</td>
                    <td width="12%" align="left">
                        <%--<e:select id="cityNo" name="cityNo"
                                  items="${cityList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:129px" editable="false"/>--%>
                         <select id="cityNo" name="cityNo"></select>
                    </td>
                </div>

                <div id="centerNoDiv">
                    <td class="search_head">支局：</td>
                    <td  width="12%"  align="left">
                        <%--<e:select id="centerNo" name="centerNo"
                                  items="${centerList.list}" label="TEXT" value="CODE" class="easyui-combobox"
                                  headLabel="全部" headValue="" style="width:170px" editable="false" />--%>
                         <select id="centerNo" name="centerNo"></select>
                    </td>
                </div>

                <div id="gridNoDiv">
                    <td class="search_head">网格：</td>
                    <td  width="12%" align="left">
                        <%--<e:select id="gridNo" name="gridNo"
                                  items="${gridList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:170px" editable="false"/>--%>
                         <select id="gridNo" name="gridNo" onchange="query()"></select>
                    </td>
                </div>

                <td align="center" style="padding-right: 20px">
                    <a id="btn" href="javascript:void(0)" class="easyui-linkbutton"   data-options="iconCls:'icon-search'" onclick="query()">查询</a>
                </td>
                <td></td>
            </tr>
        </table>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div id="big_table_change">
                    <div id="big_table_collect_type" class="inner_tab">

                    </div>
                </div>
                <div class="sub_b">
                    <div class="all_count" >总记录数：<span id="all_count">15</span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </e:if>
                    <div class="tab_scroll_x">
                        <div id="big_table_content">
                            <div id="big_table_content_0" style="margin-right: 14px;display:block;">
                                <table cellspacing="0" cellpadding="0" class="table1 tab_head1" id="import_tab" style="width:2140px">
                                    <thead>
                                    <tr>
                                        <th rowspan="2">序号</th>
                                        <th rowspan="2">区域</th>
                                        <th colspan="3">市场占有</th>
                                        <th colspan="3">竞争收集</th>
                                        <th colspan="3">精准营销</th>
                                        <th colspan="3">用户流失</th>
                                        <th colspan="3">光网覆盖</th>
                                        <th colspan="3">端口占用</th>
                                        <th colspan="3">存量保有</th>
                                    </tr>
                                    <tr>
                                        <th>渗透率</th>
                                        <th>本月提升</th>
                                        <th>本年提升</th>

                                        <th>收集率</th>
                                        <th>本月提升</th>
                                        <th>本年提升</th>

                                        <th>执行率</th>
                                        <th>本月提升</th>
                                        <th>本年提升</th>

                                        <th>占比</th>
                                        <th>本月下降</th>
                                        <th>本年下降</th>

                                        <th>覆盖率</th>
                                        <th>本月提升</th>
                                        <th>本年提升</th>

                                        <th>占用率</th>
                                        <th>本月提升</th>
                                        <th>本年提升</th>

                                        <th>保有率</th>
                                        <th>本月变化</th>
                                        <th>本年变化</th>
                                    </tr>
                                    </thead>
                                </table>
                            </div>

                        </div>
                        <div class="t_body"  style="overflow-y:scroll;display:block;width:2160px;">
                            <table cellspacing="0" cellpadding="0" class="tab_comm" style="width:2140px">
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
    var areaJSON=${e:java2json(areaList.list)};
    var cityJSON = ${e:java2json(cityList.list)};
    var centerJSON = ${e:java2json(centerList.list)};
    var gridJSON = ${e:java2json(gridList.list)};
    var from_menu = '${param.from_menu}';

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
    }


    var curr_time = new Date();
    var url4data_list = '<e:url value="/pages/telecom_Index/common/sql/pointAnalyze_action.jsp" />';
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0,page = 0, query_flag=2, query_sort = '0', eaction = "point_data_list",acct_mon='',flag_scroll = 1,flag = 1;
    var city_id_temp = '${param.city_id}';
    console.log(city_id_temp);
    var bureau_id_temp = '${param.bureau_id}';
    console.log(bureau_id_temp);
    var branch_id_temp = '${param.branch_id}';
    console.log(branch_id_temp);
    var grid_id_temp = '${param.grid_id}';
    console.log(grid_id_temp);


    var fgl = 'all';
    var stl = 'all';
    var jzcd_flag = '';
    var villageMode_flag = '';
    var portLv_flag = '';
    var line_flag = '';

    var beginDate = "";
    var index_temp = 0;

    if(city_id_temp==""){
        city_id_temp ='999';
    }
    console.log(city_id_temp);
    // else{
    //     city_id_for_village_tab_view = city_id_temp;
    // }

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

    //var long_message_width = 0;
    $(function(){
        //下拉框初始化方法
        console.log("aaa");
        $('#acctDate').datebox({
            onChange: function(date){
                clear_data();
                load_list();
            }
        });
        initAreaSelect();
        clear_data();
        load_list();

        $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 70 - $("#big_table_change").height() - $("#big_table_content").height());

        init_tab_height = document.body.offsetHeight*0.94 - 148 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();
        initTabHeight_province();
        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('.t_body').scroll(function () {
            //alert($(this).scrollLeft());
            $('#table_head').css('margin-left', -($('.t_body').scrollLeft()));

            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();

            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll > 500) {
                    console.log(000);
                    flag_scroll = 0;
                    ++page;
                    load_list();
                }
                begin_scroll = new Date().getTime();
            }
        });

        $("#closeTab").on("click",function(){
            load_map_view();
        });

        //load_list();
        $("#big_table_collect_type span").eq(0).click();

        resetSelectFunc();
    });

    function resetSelectFunc(){
        if(user_level==2){
            $("#cityNo").removeAttr("disabled");
            $("#centerNo").removeAttr("disabled");
            $("#gridNo").removeAttr("disabled");
        }else if(user_level==3){
            $("#centerNo").removeAttr("disabled");
            $("#gridNo").removeAttr("disabled");
        }
    }

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height+22);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-22);
    }

    function load_list() {

        beginDate = $('#acctDate').datebox('getValue').replace(/-/g, "");
        city_id_temp = $.trim($("select[name='areaNo']").val());
        bureau_id_temp =$.trim($("select[name='cityNo']").val());
        branch_id_temp = $.trim($("select[name='centerNo']").val());
        grid_id_temp = $.trim($("select[name='gridNo']").val());
        if(city_id_temp==""){
            city_id_temp ='999';
        }
        if (city_id_temp=='999'){
            flag = 1;
        }else if(city_id_temp !='999' && city_id_temp != '' && bureau_id_temp == '' ){
            flag = 2;
        }else if(bureau_id_temp != '' && branch_id_temp ==''){
            flag = 3;
        }else if (branch_id_temp != '' && grid_id_temp == ''){
            flag = 4;
        }else if(grid_id_temp != ''){
            flag = 5;
        }

        //市场渗透率
        if(index_temp==0){
            var params = {
                "eaction": eaction,
                beginDate:beginDate,
                flag: flag,
                page: page,
                pageSize: table_rows_array[0],
                //region_id: global_region_id,
                query_flag: 5,
                query_sort: 0,
                //query_sort: query_sort,
                region_id: city_id_temp,
                cityNo:bureau_id_temp,
                centerNo:branch_id_temp,
                gridNo:grid_id_temp,
                index:index_temp
            }
            listScroll(params, true, eaction);
        }
    }
    function query(){
        clear_data();
        load_list();
    }

    $("#big_table_info_div0").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        city_id_temp = $.trim($('#areaNo').combobox('getValue'));
        bureau_id_temp =$.trim($('#cityNo').combobox('getValue'));
        branch_id_temp = $.trim($('#centerNo').combobox('getValue'));
        grid_id_temp = $.trim($('#gridNo').combobox('getValue'));
        if(city_id_temp==""){
            city_id_temp ='999';
        }
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                if (city_id_temp=='999'){
                    flag = 1;
                }else if(city_id_temp !='999' && city_id_temp != '' && bureau_id_temp == '' ){
                    flag = 2;
                }else if(bureau_id_temp != '' && branch_id_temp ==''){
                    flag = 3;
                }else if (branch_id_temp != '' && grid_id_temp == ''){
                    flag = 4;
                }else if(grid_id_temp != ''){
                    flag = 5;
                }
                var params = {
                    "eaction": eaction,
                    beginDate:beginDate,
                    flag: flag,
                    page: ++page,
                    //region_id: global_region_id,
                    query_flag: 5,
                    query_sort: 0,
                    //query_sort: query_sort,
                    region_id: city_id_temp,
                    cityNo:bureau_id_temp,
                    centerNo:branch_id_temp,
                    gridNo:grid_id_temp,
                    pageSize: table_rows_array[0],
                    index:0
                }
                if(total_num<=seq_num)
                    listScroll(params, false, eaction);
                else
                    listScroll(params, true, eaction);
            }
            begin_scroll = new Date().getTime();
        }
    });


    function listScroll(params, flag, action) {
        listCollectScroll(params, flag);
    }

    var total_num = 0;
    function listCollectScroll(params, flag) {
        var $list = $("#resident_detail_list"+params.index);

        if (hasMore) {
            var url4data_url = "";
            if(index_temp==0)
                url4data_url = url4data_list;
            $.post(url4data_url, params, function (data) {
                data = $.parseJSON(data);
                /*if(data.length)
                    $("#download_div").show();
                else
                    $("#download_div").hide();*/
                if (data.length == 0 && flag_scroll) {
                    $("#all_count").html('0');
                } else {
                    if(page==0)
                        $("#all_count").html(data[0].C_NUM);
                }
                if(index_temp==0){
                    for (var i = 0, l = data.length; i < l; i++) {
                        var d = data[i];
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

                        var name_str = "";
                        if(d.FLG==5)
                            name_str = "<td style='text-align:center;'><a onclick=\"insideToVillage("+d.LATN_ID+")\">" + d.LATN_NAME + "</a></td>";
                        else
                            name_str = "<td style='text-align:center;'>" + d.LATN_NAME + "</td>";

                        newRow += name_str +
                        "</td><td>" + d.MARKT_LV +
                        "</td><td>" + d.FILTER_MON_RATE +
                        "</td><td>" + d.FILTER_YEAR_RATE +
                        "</td><td>" + d.COLLECT_LV +
                        "</td><td>" + d.COLLECT_MON_RATE +
                        "</td><td>" + d.COLLECT_YEAR_RATE +
                        "</td><td>" + d.EXE_RATE +
                        "</td><td>" + d.EXE_MON_RATE +
                        "</td><td>" + d.EXE_YEAR_RATE +

                        "</td><td>" + d.LOST_ZB +
                        "</td><td>" + d.LOST_MON_CHG +
                        "</td><td>" + d.LOST_YEAR_CHG +
                        "</td><td>" + d.COVER_LV +
                        "</td><td>" + d.COVER_MON_RATE +
                        "</td><td>" + d.COVER_YEAR_RATE +
                        "</td><td>" + d.PORT_LV +
                        "</td><td>" + d.PORT_MON_RATE +
                        "</td><td>" + d.PORT_YEAR_RATE +
                        "</td><td>" + d.BY_LV +
                        "</td><td>" + d.BY_MON_RATE+
                        "</td><td>" + d.BY_YEAR_RATE +
                        "</td></tr>";
                        $list.append(newRow);
                    }
                    //只有第一次加载没有数据的时候显示如下内容
                    if (data.length == 0) {
                        hasMore = false;
                        if (flag_scroll) {
                            $list.empty();
                            $list.append("<tr><td style='text-align:center' colspan=10 >没有查询到数据</td></tr>")
                        }
                    }
                }
            });
        }
    }

    $("#collect_tabs_change > div").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    })

    function clear_data() {
        begin = 0, end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,page = 0,
        flag = '1', query_sort = '0',flag_scroll = 1;
        $("#total_num").text("");
        $("#resident_detail_list0").empty();
        $("#download_div").hide();
    }
    function backup(level){
        initListDiv(1);
    }

</script>