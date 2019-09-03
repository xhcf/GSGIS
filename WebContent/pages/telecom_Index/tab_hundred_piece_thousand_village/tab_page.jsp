<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="initTime">
    <e:description>
    select to_char(to_date(MIN(const_value),'yyyymmdd'),'yyyy-mm-dd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '7'
    </e:description>
    select to_char(to_date(const_value,'yyyymmdd'),'yyyy-mm-dd') val from easy_data.sys_const_table where const_type = 'var.dss30'
</e:q4o>
<e:q4o var="now">
    select to_char(sysdate,'yyyy-mm-dd') val from dual
</e:q4o>
<e:q4l var="city_options">
    select ' ' val,'全省' name,'0' ord from dual
    union all
    select distinct latn_id || '' val,latn_name name,city_order_num ord from ${gis_user}.db_cde_grid
    <e:if condition="${!empty param.city_id}">
    where latn_id = '${param.city_id}'
    </e:if>
    order by ord
</e:q4l>
<e:q4l var="bureau_options">
    select ' ' val,'请选择' name,'0' ord from dual
    <e:if condition="${!empty param.bureau_id}" var="single">
        union all
        select distinct bureau_no val,bureau_name name,region_order_num ord from ${gis_user}.db_cde_grid
        where bureau_no = '${param.bureau_id}'
    </e:if>
    <e:else condition="${single}">
        <e:if condition="${!empty param.city_id}">
            union all
            select distinct bureau_no val,bureau_name name,region_order_num ord from ${gis_user}.db_cde_grid
            where latn_id = '${param.city_id}'
        </e:if>
    </e:else>
    order by ord
</e:q4l>
<e:q4l var="branch_options">
    select ' ' val,'请选择' name from dual
    <e:if condition="${!empty param.branch_id}" var="single">
        union all
        select distinct union_org_code val,branch_name name from ${gis_user}.db_cde_grid
        where union_org_code = '${param.branch_id}'
    </e:if>
    <e:else condition="${single}">
        <e:if condition="${!empty param.bureau_id}">
            union all
            select distinct union_org_code val,branch_name name from ${gis_user}.db_cde_grid
            where bureau_no = '${param.bureau_id}'
        </e:if>
    </e:else>
    order by val
</e:q4l>
<e:q4l var="grid_options">
    select ' ' val,'请选择' name from dual
    <e:if condition="${!empty param.grid_id}" var="single">
        union all
        select distinct grid_union_org_code val,grid_name name from ${gis_user}.db_cde_grid
        where grid_union_org_code = '${param.grid_id}'
    </e:if>
    <e:else condition="${single}">
        <e:if condition="${!empty param.branch_id}">
            union all
            select distinct grid_union_org_code val,grid_name name from ${gis_user}.db_cde_grid
            where union_org_code = '${param.branch_id}'
        </e:if>
    </e:else>
    order by val
</e:q4l>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>百片千区日报</title>
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
    <script src='<e:url value="/pages/telecom_Index/common/js/db_common.js"/>' charset="utf-8"></script>
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
            padding-right:15px!important;
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
        .search_item {width:10%;}

        #download_div {display:none;}
        #table_head tr th {font-size:13px;}
        #table_head tr th:first-child{width:3%!important;}
        #table_head tr th:nth-child(2){width:5%!important;}
        #table_head tr th:nth-child(3){width:9%!important;}
        #table_head tr th:nth-child(4){width:9%!important;}
        #table_head tr th:nth-child(5){width:9%!important;}
        #table_head tr th:nth-child(6){width:7%!important;}
        #table_head tr th:nth-child(7){width:7%!important;}
        #table_head tr th:nth-child(8){width:7%!important;}
        #table_head tr th:nth-child(9){width:7%!important;}
        #table_head tr th:nth-child(10){width:7%!important;}
        #table_head tr th:nth-child(11){width:7%!important;}
        #table_head tr th:nth-child(12){width:7%!important;}

        #village_market_list tr td:first-child {width:3%!important;}
        #village_market_list tr td:nth-child(2){width:5%!important;}
        #village_market_list tr td:nth-child(3){width:9%!important;}
        #village_market_list tr td:nth-child(4){width:9%!important;}
        #village_market_list tr td:nth-child(5){width:9%!important;}
        #village_market_list tr td:nth-child(6){width:7%!important;}
        #village_market_list tr td:nth-child(7){width:7%!important;}
        #village_market_list tr td:nth-child(8){width:7%!important;}
        #village_market_list tr td:nth-child(9){width:7%!important;}
        #village_market_list tr td:nth-child(10){width:7%!important;}
        #village_market_list tr td:nth-child(11){width:7%!important;}
        #village_market_list tr td:nth-child(12){width:7%!important;}

        .table1 tbody tr td:nth-child(4){min-width: 0px!important;}
        #village_select {float:left;width:70%;}
        .zj_submit {color:#fff;border:none;background:#086db7;width:65px;}
        .panel-body {background:#fff;}
        .textbox {background:none;}
        .textbox combo {border:1px solid #fff;}
        .trans_condition {background:none;border:1px solid #3E4997;}
        .download_btn {top:20px;}
        select {line-height:25px!important;height:25px!important;}
        input {line-height:25px!important;height:25px!important;}
        /*2018.9.17 新样式*/
        #total_num {color:red;}
        /*表格中要突出的字*/
        .text-important {color:#00FFFF!important;}
        .text-important-a {color:#4CB9F9!important;}
        .sub_box {background:#011157;}

        /*数据列表表头*/
        #table_head th, #big_table_content th{background:none;}
        #table_head thead tr th{
            border:1px solid #333399;
            border-bottom-color:transparent;
        }
        /*数据列表表体*/
        .table1 td {border-color:#333366;}

        /*本页标题*/
        .sub_box .big_table_title {height:28px;}
        .sub_box .big_table_title h4 {font-size:20px;}
        .select_width {width:100%;}
        #big_table_info_div {overflow-y: scroll;}
        /*记录数*/
        .rows_num {height:32px;line-height:32px;}
        /*日期控件样式*/
        .textbox {border:1px solid #3E4997;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>百&nbsp;片&nbsp;千&nbsp;区&nbsp;日&nbsp;报</h4></div>
        <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">

        </e:if>
        <!--<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>-->
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search">
                    <tr>
                        <td class="search_head"><span>帐&emsp;期：</span></td>
                        <td class="search_item"><input id="acctday" type="text" style="color:#ffffff;height:28px;line-height:28px;" /></td>
                        <td class="search_head"><span>城乡类型：</span></td>
                        <td class="search_item">
                            <select id="branch_type" class="trans_condition select_width">
                                <option value="1">城市</option>
                                <option value="2">农村</option>
                            </select>
                        </td>
                        <td class="search_head"><span>片区：</span></td>
                        <td class="search_item">
                            <select id="detail_level" class="trans_condition select_width">
                            </select>
                        </td>
                        <td colspan="5"></td>
                    </tr>
                    <tr>
                        <!-- 地市 -->
                        <td class="search_head"><span>&emsp;分公司：</span></td>
                        <td class="search_item">
                            <select id="city_select" class="trans_condition select_width" onchange="citySwitch()">
                            </select>
                        </td>
                        <!-- 区县 -->
                        <td class="search_head"><span>县局：</span></td>
                        <td class="search_item">
                            <select id="bureau_select" class="trans_condition select_width" onchange="bureauSwitch()">
                            </select>
                        </td>
                        <!-- 支局 -->
                        <td class="search_head"><span>支局：</span></td>
                        <td class="search_item">
                            <select id="branch_select" class="trans_condition select_width" onchange="branchSwitch()">
                            </select>
                        </td>
                        <!-- 网格 -->
                        <td class="search_head"><span>网格：</span></td>
                        <td class="search_item">
                            <select id="grid_select" class="trans_condition select_width" onchange="gridSwitch()">
                            </select>
                        </td>
                        <td class="search_head"><span id="search_title">小区/行政村：</span></td>
                        <td>
                            <!--<select id="search_text" onchange="villageSwitch()" style="width: 100%;"></select>-->
                            <input type="button" value="查询" onclick="query()" class="zj_submit" style="margin-left:5px;" />
                            <input id="search_text" class="trans_condition" type="text" placeholder="请输入小区/行政村名称进行检索" style="float:left;" />
                        </td>
                        <td></td>
                    </tr>
                    <!--<tr>
                    	<td style="text-align: right;">记录数：</td>
                    	<td style="height:10px;">
                    		<div style="height:28px;line-height:28px;"><div id="total_num"></div></div>
                    	</td>
                    </tr>-->
                </table>
                <div class="rows_num">
                	<span style="color:white;">记录数：</span><span id="total_num"></span>
                </div>
                <div class="sub_b">
                    <div style="padding-right:15px;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>序号</th>
                                    <th>分公司</th>
                                    <th>县局</th>
                                    <th>支局</th>
                                    <th id="column_append_target">网格</th>
                                    <th>锁定渗透率</th>
                                    <th>渗透率提升</th>
                                    <th>新增宽带数</th>
                                    <th>累计到达渗透率</th>
                                    <th>累计渗透率提升</th>
                                    <th>累计新增宽带数</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div">
                        <table cellspacing="0" cellpadding="0" class="table1" id="village_market_list" style="width: 100%;">
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
    var curr_time = new Date();
    var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData_hundred_piece_thousand_village.jsp" />';
    var url4common = '<e:url value="/pages/telecom_Index/common/sql/tabData_common_snap.jsp" />';
    var seq_num = 0, begin_scroll = 0, page_list = 0, eaction = "getSnapData",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '${param.branch_id}';
    var grid_id_temp = '${param.grid_id}';
    var village_name_temp = '';
    var acct_day = "";
    var vil_type_temp = "";

    var user_level = '${sessionScope.UserInfo.LEVEL}';
    //var user_level = '${param.level}';

    if(city_id_temp==""){
    //city_id_temp = city_id_for_village_tab_view;
        //city_id_temp ='931';
    }else
        city_id_for_village_tab_view = city_id_temp;
    //如果已经没有数据, 则不再次发起请求.

    var init_tab_height = 0;

    var option_default = "<option value=' '>请选择</option>";

    var detail_level_option1 = "<option value=\"1\">网格</option><option value=\"2\">小区</option>";
    var detail_level_option2 = "<option value=\"1\">网格</option><option value=\"2\">行政村</option>";

    var branch_type = "1";
    var detail_level= "1";

    var column_str = "<th id=\"column_v\" style=\"width:12%;\">小区</th>";

    //var long_message_width = 0;
    function initTab(){
        clear_data();
        var col_cnt = $("#table_head tr th").length;
        $("#village_market_list").append("<tr><td style='text-align:center' colspan='"+col_cnt+"' >没有查询到数据</td></tr>");
    }
    $(function(){
        //initTab();
        init_tab_height = document.body.offsetHeight*0.94 - 91 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();
        //long_message_width = $("#village_market_list").width()*0.17;

        //var a=$('#acctday').datebox('getValue').replace(/-/g, "");

        initCitySelect(user_level);
        initBureauSelect(user_level);
        initBranchSelect(user_level);
        initGridSelect(user_level);

        //changeBureauSelect(city_id_temp);

        initTabHeight_province();
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

        //日期控件
        $("#acctday").width($("#acctday").parent().width());
        $("#acctday").datebox({
            onChange: function(date){
                acct_mon = date;
                acct_mon = acct_mon.replace(/-/g,'');
                query();
            },
            value:'${initTime.VAL}'
        });
        $("#search_text").width(($("#search_text").parent().width()-$(".zj_submit").width())-50);

        //城市农村切换
        $("#branch_type").change(function(){
            initTab();
            branch_type = $("#branch_type option:selected").val();
            $("#search_title").parent().hide();
            $("#search_text").parent().hide();
            $("#detail_level").empty();
            $("#column_v").remove();
            if(branch_type==1){
                $("#detail_level").append(detail_level_option1);
            }else if(branch_type==2){
                $("#detail_level").append(detail_level_option2);
            }
            clear_data();
            bureau_id_temp = "";
            branch_id_temp = "";
            grid_id_temp = "";
            changeBureauSelect(city_id_temp);
            $("#bureau_select").empty();
            initBureauSelect(user_level);
            $("#branch_select").empty();
            initBranchSelect(user_level);
            $("#grid_select").empty();
            initGridSelect(user_level);
        });
        //片区切换
        $("#detail_level").change(function(){
            initTab();
            detail_level = $("#detail_level option:selected").val();
            $("#column_v").remove();
            if(detail_level==1){
                $("#search_title").parent().hide();
                $("#search_text").parent().hide();
            }else if(detail_level==2){
                $("#column_append_target").after(column_str);
                $("#search_title").parent().show();
                $("#search_text").parent().show();
                if(branch_type==1){
                    $("#search_title").text("小区：");
                    $("#search_text").attr("placeholder","请输入小区名称进行检索");
                }else if(branch_type==2){
                    $("#search_title").text("行政村：");
                    $("#search_text").attr("placeholder","请输入行政村名称进行检索");
                }
            }
            query();
        });

        init_search_componet();
        listCollectScroll(true);
    });

    function init_search_componet(){
        $("#detail_level").empty();
        $("#detail_level").append(detail_level_option1);
        $("#search_title").parent().hide();
        $("#search_text").parent().hide();
    }

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-55);
    }

    function query(){
        clear_data();
        listCollectScroll(true);
    }

    $("#big_table_info_div").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                page_list++;
                listCollectScroll(false);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function getParams(){
        city_id_temp = $.trim($("#city_select option:selected").val());
        bureau_id_temp = $.trim($("#bureau_select option:selected").val());
        branch_id_temp = $.trim($("#branch_select option:selected").val());
        grid_id_temp = $.trim($("#grid_select option:selected").val());
        village_name_temp = $.trim($("#search_text").val());
        acct_day = $('#acctday').datebox('getValue').replace(/-/g, "");
        return {
            "eaction": eaction,
            "city_id":city_id_temp,
            "bureau_id":bureau_id_temp,
            "branch_id":branch_id_temp,
            "grid_id":grid_id_temp,
            "branch_type":branch_type,
            "detail_level":detail_level,
            "village_name":village_name_temp,
            "acct_day":acct_day,
            "pageSize":table_rows_array[0],
            "page": page_list
        };
    }

    function listCollectScroll(flag) {
        var params = getParams();
        var $list = $("#village_market_list");
        $.post(url4Query, params, function (data) {
            data = $.parseJSON(data);
            if(data.length){
                $("#download_div").show();
            }else
                $("#download_div").hide();
            if(page_list==0){
                if(data.length)
                    $("#total_num").text(data[0].C_NUM);
                else
                    $("#total_num").text("0");
            }
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td>" + (++seq_num) +//序号
                "</td><td class='text-center'>" + d.LATN_NAME +//分公司
                "</td><td class='text-center'>" + d.BUREAU_NAME +//县局
                "</td><td class='text-center'>" + d.BRANCH_NAME;//支局

                if($("#detail_level option:selected").val()==2){
                    newRow += "</td><td class='text-center'>" + d.GRID_NAME +//网格
                    "</td><td class='text-left text-important-a' style=\"width:12%;\">" + d.VILLAGE_NAME;//小区
                }else{
                    newRow += "</td><td class='text-center text-important-a'>" + d.GRID_NAME;//网格
                }

                newRow +=
                "</td><td class='text-right text-important-b'>" + d.FILTER_RATE_LOCK +//锁定渗透率
                "</td><td class='text-right'>" + d.FILTER_RATE_D +//渗透率提升
                "</td><td class='text-right'>" + d.ADD_KD_CNT +//新增宽带数
                "</td><td class='text-right text-important-b'>" + d.FILTER_RATE +//累计到达渗透率
                "</td><td class='text-right'>" + d.FILTER_RATE_M +//累计渗透率提升
                "</td><td class='text-right'>" + d.M_ADD_KD_CNT +//累计新增宽带数

                "</td></tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                var col_cnt = $("#table_head tr th").length;
                $list.append("<tr><td style='text-align:center' colspan='"+col_cnt+"' >没有查询到数据</td></tr>");
            }
        });
    }

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page_list = 0,flag = '1';
        $("#total_num").text("0");
        $("#village_market_list").empty();
        $("#download_div").hide();
    }
    function clear_option(level){
        //if(level<6)
            //$("#search_text").empty();
        if(level<5){
            $("#grid_select").empty();
            $("#grid_select").append(option_default);
        }
        if(level<4){
            $("#branch_select").empty();
            $("#branch_select").append(option_default);
        }
        if(level<3){
            $("#bureau_select").empty();
            $("#bureau_select").append(option_default);
        }
    }

    function addOption(data_list,element_id){
        for(var i = 0,l = data_list.length;i<l;i++){
            var data = data_list[i];
            $("#"+element_id).append("<option value='"+data.VAL+"'>"+data.NAME+"</option>");
        }
    }
    function initCitySelect(user_level){
        var data_list = ${e:java2json(city_options.list)};
        addOption(data_list,"city_select");
        if(user_level>1){
            $("#city_select").val(city_id_temp);
            $("#city_select").attr("disabled","disabled");
        }
    }
    function initBureauSelect(user_level){
        var data_list = ${e:java2json(bureau_options.list)};
        addOption(data_list,"bureau_select");
        if(user_level>2){
            $("#bureau_select").val(bureau_id_temp);
            $("#bureau_select").attr("disabled","disabled");
        }
    }
    function initBranchSelect(user_level){
        var data_list = ${e:java2json(branch_options.list)};
        addOption(data_list,"branch_select");
        if(user_level>3){
            $("#branch_select").val(branch_id_temp);
            $("#branch_select").attr("disabled","disabled");
        }
    }
    function initGridSelect(user_level){
        var data_list = ${e:java2json(grid_options.list)};
        addOption(data_list,"grid_select");
        if(user_level>4){
            $("#grid_select").val(grid_id_temp);
            $("#grid_select").attr("disabled","disabled");
        }
    }
    function initVillageSelect(){

    }

    function changeBureauSelect(city_id_temp){
        $.post(url4common,{"eaction":"getBureauByCityId","city_id":city_id_temp,"branch_type":branch_type},function(data){
            var data_list = $.parseJSON(data);
            $("#bureau_select").empty();
            $("#bureau_select").append(option_default);
            addOption(data_list,"bureau_select");
            listCollectScroll(true);
            //changeBranchSelect(data_list[0].VAL);
        });
    }

    function changeBranchSelect(bureau_no){
        $.post(url4common,{"eaction":"getBranchByBureauId","bureau_id":bureau_no,"branch_type":branch_type},function(data){
            var data_list = $.parseJSON(data);
            $("#branch_select").empty();
            $("#branch_select").append(option_default);
            addOption(data_list,"branch_select");
            listCollectScroll(true);
            //changeGridSelect(data_list[0].VAL);
        });
    }

    function changeGridSelect(branch_id){
        $.post(url4common,{"eaction":"getGridByBranchId","branch_id":branch_id,"branch_type":branch_type},function(data){
            var data_list = $.parseJSON(data);
            $("#grid_select").empty();
            $("#grid_select").append(option_default);
            addOption(data_list,"grid_select");
            listCollectScroll(true);
        });
    }

    function changeVillageSelect(region_id){
        $("#search_text").empty();
        /*$.post(url4Query,{"eaction":"getVillageIdByReginId","region_id":grid_id},function(data){
            var data_list = $.parseJSON(data);
            $("#search_text").empty();
            addOption(data_list,"search_text");
        });*/
    }

    function citySwitch(){
        if(user_level>1)
            return;
        var city_id = $.trim($("#city_select option:checked").val());
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
        //clear_option(2);
        //listCollectScroll(true);
    }
    function bureauSwitch(){
        if(user_level>2)
            return;
        /*if(bureau_id=='999')
            bureau_id = "";*/
        bureau_id_temp = $.trim($("#bureau_select option:checked").val());
        if(bureau_id_temp=='-1')
            bureau_id_temp='';
        else
            changeBranchSelect(bureau_id_temp);
        branch_id_temp='';
        grid_id_temp='';
        //village_name_temp = "";
        //changeVillageSelect(bureau_id_temp);
        clear_data();
        //clear_option(3);
        //listCollectScroll(true);
    }
    function branchSwitch(){
        if(user_level>3)
            return;
        branch_id_temp = $.trim($("#branch_select option:checked").val());
        if(branch_id_temp=='-1')
            branch_id_temp='';
        else
            changeGridSelect(branch_id_temp);
        grid_id_temp = '';
        //village_name_temp = "";
        //branch_id_temp = $("#branch_select option:selected").val();
        //changeVillageSelect(branch_id_temp);

        clear_data();
        //clear_option(4);
        //listCollectScroll(true);
    }
    function gridSwitch(){
        if(user_level>4)
            return;
        grid_id_temp = $.trim($("#grid_select option:checked").val());
        if(grid_id_temp=='-1')
            grid_id_temp='';
        //village_name_temp = "";
        //branch_id_temp = $("#branch_select option:selected").val();
        //changeVillageSelect(branch_id_temp);
        clear_data();
        listCollectScroll(true);
    }

</script>