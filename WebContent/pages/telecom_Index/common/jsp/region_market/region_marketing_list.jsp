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
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and t.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY  city_order_num
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT  T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.region_order_num FROM gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
        and t.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.region_order_num
    ORDER BY  T.region_order_num
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.union_org_code CODE, T.branch_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${sessionScope.UserInfo.LEVEL ne '1' && sessionScope.UserInfo.LEVEL ne '2'}">
        and T.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
    </e:if>
    group by T.bureau_no, T.union_org_code, T.branch_name,t.branch_no
    ORDER BY  T.branch_no
</e:q4l>

<e:description>网格</e:description>
<e:q4l var="gridList">
    SELECT  T.union_org_code PID, T.grid_id CODE, T.grid_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.grid_id IS NOT NULL
    and t.branch_type='a1' and t.grid_union_org_code is not null
    <e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
        and T.union_org_code = '${sessionScope.UserInfo.TOWN_NO}'
    </e:if>
    group by t.union_org_code,t.grid_id,t.grid_name
    ORDER BY  T.grid_id
</e:q4l>

<e:description>小区类型</e:description>
<e:q4l var="village_type">
    select '1' CODE , '急迫小区' TEXT from dual
    union
    select '2' CODE , '紧迫小区' TEXT from dual
    union
    select '3' CODE , '操心小区' TEXT from dual
    union
    select '4' CODE , '平稳小区' TEXT from dual
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
    <script src='<e:url value="resources/app/areaSelect.js?version=New Date()"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.8.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.6"/>' rel="stylesheet" type="text/css" media="all" />
    <link type="text/css" rel="stylesheet" href="info_fill.css?version=1.8">
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
            width:5%;
            text-align:right;
            font-weight:bold;
        }
        #tab_div .table1 tr td{
            width: 80px;
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
        input {color:#fff;}
        .databox_ .textbox.combo.datebox {margin-top:7px;}
        .textbox.combo.datebox {border:1px solid #3E4997;}
        .search a{margin:0px;}
        .textbox.combo {border:1px solid #3E4997;}
        .all_count {left:5px!important;height:22px!important;}
        .tab_scroll_x {width:100%;height:65%;overflow-y: hidden;overflow-x:hidden;border:none;}
        .table1.tab_head1 tr:nth-child(2) th:first-child {width:10%;}
        .combobox-item, .combobox-group, .combobox-stick {padding:2px 3px!important;font-size:13px;}
        .textbox .textbox-text {font-size:13px;}
        .l-btn-text {line-height:26px;}

        #areaNo,#cityNo,#centerNo,#gridNo,#villageType,#village_select {background: none;color: #aaa;width:100%;border:1px solid #3E4997;}

        input::-webkit-input-placeholder {
	        /* placeholder颜色  */
	        color: #aab2bd;
	        /* placeholder字体大小  */
	        font-size: 12px;
	        /* placeholder位置  */
	        text-align: right;
	    }

        #import_tab tr:first-child th:first-child{width:4%;}
        #import_tab tr:first-child th:nth-child(2){width:6%;}
        #import_tab tr:first-child th:nth-child(3){width:15%;}
        #import_tab tr:first-child th:nth-child(6){width:3%;}

        #import_tab tr:nth-child(2) th:first-child{width:5%;}
        #import_tab tr:nth-child(2) th:nth-child(2){width:8%;}
        #import_tab tr:nth-child(2) th:nth-child(3){width:5%;}
        #import_tab tr:nth-child(2) th:nth-child(4){width:5%;}
        #import_tab tr:nth-child(2) th:nth-child(5){width:6%;}
        #import_tab tr:nth-child(2) th:nth-child(6){width:5%;}

        #import_tab tr:nth-child(2) th:nth-child(7){width:7%;}
        #import_tab tr:nth-child(2) th:nth-child(8){width:5%;}
        #import_tab tr:nth-child(2) th:nth-child(9){width:6%;}
        #import_tab tr:nth-child(2) th:nth-child(10){width:5%;}
        #import_tab tr:nth-child(2) th:nth-child(11){width:5%;}
        #import_tab tr:nth-child(2) th:nth-child(12){width:5%;}
        #import_tab tr:nth-child(2) th:nth-child(13){width:5%;}

        #import_tab tr:nth-child(2) th:nth-child(14){width:3%;}

        #table_body tr td:first-child{width:4%;}
        #table_body tr td:nth-child(2){width:6%;}
        #table_body tr td:nth-child(3){width:15%;text-align:left!important;}

        #table_body tr td:nth-child(4){width:5%;}
        #table_body tr td:nth-child(5){width:8%;}
        #table_body tr td:nth-child(6){width:5%;}
        #table_body tr td:nth-child(7){width:5%;}
        #table_body tr td:nth-child(8){width:6%;}
        #table_body tr td:nth-child(9){width:5%;}

        #table_body tr td:nth-child(10){width:7%;color:#ffa22e;}
        #table_body tr td:nth-child(11){width:5%;color:#ffa22e;}
        #table_body tr td:nth-child(12){width:6%;color:#ffa22e;}
        #table_body tr td:nth-child(13){width:5%;color:#ffa22e;}
        #table_body tr td:nth-child(14){width:5%;color:#ffa22e;}
        #table_body tr td:nth-child(15){width:5%;color:#ffa22e;}
        #table_body tr td:nth-child(16){width:5%;color:#ffa22e;}

        #table_body tr td:nth-child(17){width:3%;}

        .search_div {
            border:1px solid #1851a9;
            padding-top:10px;
            background:#043572;
        }
        .search {
            background:none!important;
            border:none;
            width:98%;
            margin:0 auto;
            padding:5px 15 5px 0;
        }
        .search tr td:last-child{
            border:none!important;
        }

        input::-moz-placeholder
        {
            text-align: left;
        }
        input::-moz-placeholder
        {
            text-align: left;
        }
        input::-ms-input-placeholder
        {
            text-align: left;
        }
        input::-webkit-input-placeholder
        {
            text-align: left;
        }
        input::-webkit-input-placeholder {
             /* placeholder颜色
             color: #aab2bd;*/
             /* placeholder字体大小
             font-size: 12px;*/
             /* placeholder位置  */
             text-align: left;
        }

        a:link, a:visited{text-decoration:underline;color:#fff;}

        /*搜索区*/
        .search_head {width:6%;}
        .search_space {width:4%;}
        .search_space2 {width:6%;}
        .search_input {width:14%;}

        .win_title_tag {
            width: 100%;
            position:fixed;
            background: #05418b;
            height:40px;
            line-height:36px;
            top:0px;
        }

        /*和info_fill.css body背景色冲突的解决*/
        body{
            background:none;
        }
        .layui-layer-content{
            margin-top:-2px;
        }
        #new_input{
            position: absolute;
            top: 28px;
            right: 15px;
        }
        #new_input,#btn {height:22px;line-height:22px;}
        .l-btn-text {line-height:22px;margin:0 10px;}

        .sub_b {height:25px!important;}
        .all_count {top:0px;height:25px!important;}
        .download_btn {top:0px;height:25px!important;}
    </style>
</head>
<body>
    <div id="list_div" style="width:99.7%!important;height:98.5%!important;margin:0.1% auto;position: absolute;left: 00px;border: 2px solid #2070dc;background:#030C57;overflow-y:auto;">

        <div class="sub_box grab_tab">
            <div style="height:100%;width:100%;" id="tab_div">
                <div class="big_table_title"><h4>小&nbsp;区&nbsp;营&nbsp;销&nbsp;策&nbsp;略&nbsp;清&nbsp;单</h4></div>
                <a id="new_input" class="easyui-linkbutton" href="javascript:void(0)" onclick="pop_win()">营销策划</a>
                <div class="search_div">
                    <table cellspacing="0" cellpadding="0" class="search">
                        <tr style="height: 50px;display:none;">
                            <td class="search_head">账&nbsp;&nbsp;&nbsp;&nbsp;期：</td>
                            <td colspan="9">
                                <div style="color:#FFFFFF;" class="databox_">
                                    <%--<input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>--%>
                                    <c:datebox id="acctDate" name="acctDate" required="true" format="yyyy-mm-dd" defaultValue='${initTime}'/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="search_head">分公司：</td>
                            <td class="search_input">
                                <%--<e:select id="areaNo" name="areaNo"
                                          items="${areaList.list}" label="TEXT" value="CODE"  class="easyui-combobox" headLabel="全省" headValue="" defaultValue="${param.city_id}"
                                          style="width:129px" editable="false"/>--%>
                                <select id="areaNo" name="areaNo"></select>
                            </td>

                            <td class="search_space"></td>

                            <td class="search_head">县区：</td>
                            <td class="search_input">
                                <%--<e:select id="cityNo" name="cityNo"
                                          items="${cityList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                          headLabel="全部" headValue=""  style="width:129px" editable="false"/>--%>
                                <select id="cityNo" name="cityNo"></select>
                            </td>

                            <td class="search_space"></td>

                            <td class="search_head">支局：</td>
                            <td class="search_input">
                                <%--<e:select id="centerNo" name="centerNo"
                                          items="${centerList.list}" label="TEXT" value="CODE" class="easyui-combobox"
                                          headLabel="全部" headValue="" style="width:170px" editable="false" />--%>
                                <select id="centerNo" name="centerNo"></select>
                            </td>

                            <td class="search_space2"></td>

                            <td width="20%">
                                <span style="display:inline-block;text-align:left;font-weight:bold;">网格：</span><span style="display:inline-block;"><select id="gridNo" name="gridNo" onchange="query()"></select></span>
                            </td>

                            <!--<td class="search_head"></td>
                            <td width="8%">
                                 <select id="gridNo" name="gridNo" onchange="query()"></select>
                            </td>-->
                        </tr>
                        <tr style="height: 50px;">
                            <td class="search_head">小区类型：</td>
                            <td class="search_input">
                                <select id="villageType" name="villageType" onchange="query()"></select>
                            </td>

                            <td class="search_space"></td>

                            <td class="search_head">小区：</td>
                            <td colspan="4">
                                <input id="village_select" type="text" style="text-align:left;" placeholder="请输入小区名称进行检索">
                            </td>

                            <td class="search_space2"></td>

                            <td style="text-align:left;" width="20%">
                                <span style="display:inline-block;text-align:left;"><a id="btn" href="javascript:void(0)" class="easyui-linkbutton" onclick="query()">查询</a></span>
                                <!--<span style="display:inline-block;margin-left:15px;"><a id="new_input" href="javascript:void(0)" class="easyui-linkbutton" onclick="pop_win()">营销策划</a></span>-->
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="tab_box table_cont_wrapper">
                    <div class="sub_b">
                        <div class="all_count">总记录数：<span id="all_count"></span></div>
                        <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">

                        </e:if>
                        <div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </div>
                </div>
                <div class="tab_scroll_x">
                    <div id="big_table_content">
                        <div id="big_table_content_0" style="margin-right: 14px;display:block;">
                            <table cellspacing="0" cellpadding="0" class="table1 tab_head1" id="import_tab" style="width:100%">
                                <thead>
                                <tr>
                                    <th rowspan="2">序号</th>
                                    <th rowspan="2">区域</th>
                                    <th rowspan="2">小区</th>
                                    <th colspan="6">初始指标</th>
                                    <th colspan="7">营销指标</th>
                                    <th rowspan="2">详情</th>
                                </tr>
                                <tr>
                                    <th>住户数 </th>
                                    <th>家庭宽带渗透率</th>
                                    <th>光网覆盖率</th>
                                    <th>端口占用率</th>
                                    <th>异常用户占比</th>
                                    <th>宽带保有率</th>

                                    <th>三大业务渗透率</th>
                                    <th>端口实占率</th>
                                    <th>异网用户占比</th>
                                    <th>单转融</th>
                                    <th>到期续约</th>
                                    <th>沉默激活</th>
                                    <th>竞争收集率</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                    <div class="t_body" id="scroll_div" style="overflow-y:scroll;display:block;width:100%;">
                        <table cellspacing="0" cellpadding="0" class="tab_comm" id="table_body" style="width:100%">
                        </table>
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
    var default_option = "<option value=''>全部</option>";

    var url4data_list = '<e:url value="/pages/telecom_Index/common/jsp/region_market/region_marketing_action.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, eaction = "data_list";
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '${param.branch_id}';
    var grid_id_temp = '${param.grid_id}';
    var village_type = "";

    var beginDate = "";

    //如果已经没有数据, 则不再次发起请求.

    var init_tab_height = 0;

    var table_rows_array = "";
    var table_rows_array_small_screen = [20,25,35];
    var table_rows_array_big_screen = [30,40,50];

    var open_win_handler = "";

    var pop_relate = 0;//为1，弹窗里参数用列表页的参数；为0，弹窗里参数根据当前用户权限取
    var pop_level = 0;

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
    }

    function initVillageTypeSelect(){
        var vt = ${e:java2json(village_type.list)};
        $("#villageType").append(default_option);
        for(var i = 0,l = vt.length;i<l;i++){
            var item = vt[i];
            var option = "<option value='"+item.CODE+"'>"+item.TEXT+"</option>";
            $("#villageType").append(option);
        }
    }

    //var long_message_width = 0;
    $(function(){
        //下拉框初始化方法
        $('#acctDate').datebox({
            onChange: function(date){
                query();
            }
        });
        initAreaSelect();
        initVillageTypeSelect();
        query();

        $("#scroll_div").css("max-height", document.body.offsetHeight*0.94 - 40 - $(".search").height() - 150);

        init_tab_height = document.body.offsetHeight*0.94 - 148 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();
        initTabHeight_province();
        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('#scroll_div').scroll(function () {
            //alert($(this).scrollLeft());
            $('#table_head').css('margin-left', -($('.t_body').scrollLeft()));

            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();

            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll > 500) {
                    ++page;
                    listCollectScroll(false);
                }
                begin_scroll = new Date().getTime();
            }
        });

        $("#closeTab").on("click",function(){
            load_map_view();
        });

        resetSelectFunc();
    });

		//根据权限扩展联动功能
    function resetSelectFunc(){
        if(user_level==2){
            $("#cityNo").removeAttr("disabled");
            //$("#centerNo").removeAttr("disabled");
            //$("#gridNo").removeAttr("disabled");
        }else if(user_level==3){
            $("#centerNo").removeAttr("disabled");
            //$("#gridNo").removeAttr("disabled");
        }
    }

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height+22);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-22);
    }

    function getParams(){
        beginDate = $('#acctDate').datebox('getValue').replace(/-/g, "");
        village_type = $("#villageType option:selected").val();
        city_id_temp = $.trim($("select[name='areaNo']").val());
        bureau_id_temp =$.trim($("select[name='cityNo']").val());
        branch_id_temp = $.trim($("select[name='centerNo']").val());
        grid_id_temp = $.trim($("select[name='gridNo']").val());

        if(city_id_temp == ""){
            pop_level = 1;
        }else if(bureau_id_temp == ""){
            pop_level = 2;
        }else if(branch_id_temp == ""){
            pop_level = 3;
        }else if(grid_id_temp == ""){
            pop_level = 4;
        }else{
            pop_level = 5;
        }
        return {
            "eaction"   :   "data_list",
            "beginDate" :   beginDate,
            "village_type": village_type,
            "latn_id"   :   city_id_temp,
            "bureau_id" :   bureau_id_temp,
            "branch_id" :   branch_id_temp,
            "grid_id"   :   grid_id_temp,
            "page"      :   page,
            "pageSize"  :   table_rows_array[0]
        }
    }

    function query(){
        clear_data();
        listCollectScroll(true);
    }

    //新建
    function pop_win(){
        if(open_win_handler!=""){
            layer.close(open_win_handler);
        }
        if(pop_relate){
            getParams();
            view_detail(city_id_temp,bureau_id_temp,branch_id_temp,grid_id_temp,'');
        }else{
            var user_level = '${sessionScope.UserInfo.LEVEL}';
            if(user_level==1){
                view_detail('','','','','');
            }else if(user_level==2){
                view_detail(city_id_temp,'','','','');
            }else if(user_level==3){
                view_detail(city_id_temp,bureau_id_temp,'','','');
            }
        }
    }

    function listCollectScroll(flag) {
        var params = getParams();
        var $list = $("#table_body");
        $.post(url4data_list, params, function (data) {
            data = $.parseJSON(data);
            /*if(data.length)
                $("#download_div").show();
            else
                $("#download_div").hide();*/
            if (page == 0){
                if(data.length)
                    $("#all_count").html(data[0].C_NUM);
                else
                    $("#all_count").html('0');
            }
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                /*if(d.LATN_NAME == '全省'){
                    var newRow = "<tr style=\"background-color:#043572 \"><td>" + (++seq_num) + "</td>";
                }else {
                    var newRow = "<tr><td>" + (++seq_num) + "</td>";
                }*/
                var newRow = "";
                newRow += "<tr>";
                newRow += "<td>"+ (++seq_num) + "</td>";

                newRow += "<td>"+ d.CITY_NAME + "</td>";

                var name_str = "<td>";
                if(d.FLG==5)
                    name_str += "<a href=\"javascript:void(0);\" onclick=\"insideToVillage('"+d.VILLAGE_ID+"')\">" + d.VILLAGE_NAME + "</a>";
                else
                    name_str += d.VILLAGE_NAME;
                name_str += "</td>";

                newRow += name_str;

                newRow +=
                "<td>" + d.ZHU_HU_COUNT + "</td>" +
                "<td>" + d.MARKT_LV + "</td>" +
                "<td>" + d.COVER_LV + "</td>" +
                "<td>" + d.PORT_LV + "</td>" +
                "<td>" + d.LOST_LV + "</td>" +
                "<td>" + d.BY_LV + "</td>" +

                "<td>" + d.GOAL_MARKET_LV + "</td>" +
                "<td>" + d.GOAL_PORT_LV + "</td>" +
                "<td>" + d.GOAL_LOST_LV + "</td>" +
                "<td>" + d.GOAL_D2R + "</td>" +
                "<td>" + d.GOAL_DQXY + "</td>" +
                "<td>" + d.GOAL_SLEEP2ACTIVE + "</td>" +
                "<td>" + d.GOAL_COLLECT_LV + "</td>" +
                "<td><a href=\"javascript:void(0);\" onclick=\"view_detail('"+ d.LATN_ID+"','"+ d.BUREAU_NO+"','"+ d.UNION_ORG_CODE+"','"+ d.GRID_ID+"','"+d.VILLAGE_ID+"','"+ d.TACTICS_ID+"')\" >查看</a></td>";

                newRow += "</tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=17>没有查询到数据</td></tr>")
            }
        });
    }

    function view_detail(latn_id,bureau_no,union_org_code,grid_id,village_id,tactics_id){
        open_win_handler = layer.open({
            title: ' ',
            //title:false,
            type: 2,
            shade: 0,
            //maxmin: true, //开启最大化最小化按钮
            area: ['86%', '95%'],
            content: "<e:url value='pages/telecom_Index/common/jsp/region_market/info_fill.jsp' />?latn_id="+latn_id+"&bureau_no="+bureau_no+"&union_org_code="+union_org_code+"&grid_id="+grid_id+"&village_id="+village_id+"&tactics_id="+tactics_id+"&from_list=1&pop_relate="+pop_relate+"&pop_level="+pop_level,
            skin: 'market_view',
            success:function(layero, index){//替换原有标题内容，还需设置.layui-layer-content{margin-top:-2px;}，添加.win_title_tag样式
                var tag_html = "<div class=\"win_title_tag\"><h2 class=\"total_tit\">小区营销策略录入</h2></div>";
                $(".layui-layer-title").append(tag_html);
            },
            cancel: function (index) {
                //$("#nav_info_collect").removeClass("active");
                //return tmp_info_collect = '1';
            }
        });
    }

    function closeWin(){
        layer.close(open_win_handler);
    }

    $("#collect_tabs_change > div").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    })

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page = 0;
        $("#total_num").text("");
        $("#table_body").empty();
        $("#download_div").hide();
    }
    function backup(level){
        initListDiv(1);
    }

</script>