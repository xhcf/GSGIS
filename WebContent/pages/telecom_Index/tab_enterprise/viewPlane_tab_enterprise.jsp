<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="initTime">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
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
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>校园清单</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.7"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <script src='<e:url value="/pages/telecom_Index/common/js/db_common.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/big_tab_reset.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
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
        .bureau_select a {
            display: block;
            float: left;
            margin-right: 20px;width:auto;
            text-decoration: underline;
        }
        .span_selected {font-weight:bold;color:#ee7008;}
        .search_head{
            width:80px;
            text-align:center;
            font-weight:bold;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }
        .search{
            background: #043572;
            width:100%;
            color:#fff;
            border:1px solid #1851a9;
        }
        .search a{
            color:#fff;
        }
        .search td{
            height:32px;
        }
        #village_count{
            font-size:12px;
            padding-top:2px;
        }
        #village_count span{
            text-decoration: underline;
            cursor:pointer;
            display:inline-block;
            margin-right:8px;
        }
        .text-left{
            text-align:left!important;
        }
        .text-center{
            text-align:center!important;
        }
        .text-right{
            text-align:right!important;
            /*padding-right:15px!important;*/
        }
        /*.slt_select,.fgl_select{display:inline-block;}
        .fgl_select{margin-left:30px;}*/
        .table1 tr:nth-child(1) td{background:none;}
        .important td{color:#fa8513!important;}
        #table_head,#big_tab_info_list{border-color:#aaa;}
        .search{border-color:#1851a9;}
        .table1, .table1 td{
            border-color:#092e67;border-width:1px;
        }
        /*.long_message{
            display: block;
            text-overflow:ellipsis;
            overflow:hidden;
            white-space:nowrap;
        }*/
        td {padding-right:0px!important;}
        #table_head th, #big_table_content th{background:none;}
        .small_range{font-size:13px;}

        /*2018.9.13新样式*/
        .search_head span {
            background:none;
            text-align:right;
        }
        .area_select a.selected, .slt_select a.selected, .fgl_select a.selected, .jzcd_select a.selected, .village_mode_select a.selected, .port_lv_select a.selected, .line_select a.selected{
            color:#ee7008;
        }

        .sub_box {background:#011157;}
        /*数据列表表头*/
        #table_head thead tr th{
            border:1px solid #333399;
            border-bottom-color:transparent;
        }
        /*数据列表表体*/
        .table1 td {border-color:#333366;}

        /*第一行表头*/
        #table_head tr:first-child th:first-child{width:3%!important;}
        #table_head tr:first-child th:nth-child(2){width:5%!important;}
        #table_head tr:first-child th:nth-child(3){width:8%!important;}
        #table_head tr:first-child th:nth-child(4){width:20%!important;}
        #table_head tr:first-child th:nth-child(5){width:7%!important;}
        #table_head tr:first-child th:nth-child(6){width:5%!important;}
        #table_head tr:first-child th:nth-child(7){width:5%!important;}
        #table_head tr:first-child th:nth-child(8){width:5%!important;}
        #table_head tr:first-child th:nth-child(9){width:5%!important;}
        #table_head tr:first-child th:nth-child(10){width:13%!important;}
        #table_head tr:first-child th:nth-child(11){width:24%!important;}

        /*第二行表头*/
        /*市场*/
        #table_head tr:nth-child(2) th:nth-child(1){width:6%!important;}
        #table_head tr:nth-child(2) th:nth-child(2){width:7%!important;}

        /*竞争*/
        #table_head tr:nth-child(2) th:nth-child(3){width:6%!important;}
        #table_head tr:nth-child(2) th:nth-child(4){width:6%!important;}
        #table_head tr:nth-child(2) th:nth-child(5){width:6%!important;}
        #table_head tr:nth-child(2) th:nth-child(6){width:6%!important;}


        /*表体*/
        /*基础信息*/
        #big_tab_info_list tr td:first-child {width:3%!important;}
        #big_tab_info_list tr td:nth-child(2){width:5%!important;}
        #big_tab_info_list tr td:nth-child(3){width:8%!important;}
        #big_tab_info_list tr td:nth-child(4){width:20%!important;text-align:left!important;}
        #big_tab_info_list tr td:nth-child(5){width:7%!important;}
        #big_tab_info_list tr td:nth-child(6){width:5%!important;}
        #big_tab_info_list tr td:nth-child(7){width:5%!important;}
        #big_tab_info_list tr td:nth-child(8){width:5%!important;}
        #big_tab_info_list tr td:nth-child(9){width:5%!important;}

        /*市场*/
        #big_tab_info_list tr td:nth-child(10){width:6%!important;}
        #big_tab_info_list tr td:nth-child(11){width:7%!important;}

        /*竞争*/
        #big_tab_info_list tr td:nth-child(12){width:6%!important;}
        #big_tab_info_list tr td:nth-child(13){width:6%!important;}
        #big_tab_info_list tr td:nth-child(14){width:6%!important;}
        #big_tab_info_list tr td:nth-child(15){width:6%!important;}

        /*表格中要突出的字*/
        .text-important {color:#00FFFF!important;}
        .text-important-a {color:#4CB9F9!important;}
        /*本页标题*/
        .sub_box .big_table_title {height:28px;}
        .sub_box .big_table_title h4 {font-size:20px;}

        .download_btn {top: 15px;right: 60px;}

        .area_select a,.area_select a.selected {text-align:left;margin-right:10px!important;}
        #query_btn {width:70px;margin-left:5px;}

        #bureau_select {display:none;}

        .t_body {overflow-y:scroll;}
        #total_num {color:#ee7008;font-weight:bold;}
        .search tr td:last-child {border-right:0px;}
        
        .area_select {padding-left:15px;}
        .table1 td {font-size:12px;}
    </style>
</head>
<body>
<div class="sub_box">
    <div class="close_button" id="closeTab"></div>
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>校&nbsp;园&nbsp;清&nbsp;单</h4></div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search" style="background: transparent!important;">
                    <tr style="display: none;">
                        <td class="search_head"><span>帐&nbsp;&nbsp;&nbsp;&nbsp;期:</span></td></td>
                        <td><input id="acctday" type="text" style="color:#ffffff; width:100px" /></td>
                    </tr>
                    <tr style="height:40px;">
                        <td class="search_head"><span>分&ensp;公&ensp;司:</span></td>
                        <td class="area_select">
                            <a href="javascript:void(0)" onclick="citySwitch(999)">全省</a>
                            <a href="javascript:void(0)" onclick="citySwitch(931)">兰州</a>
                            <a href="javascript:void(0)" onclick="citySwitch(938)">天水</a>
                            <a href="javascript:void(0)" onclick="citySwitch(943)">白银</a>
                            <a href="javascript:void(0)" onclick="citySwitch(937)">酒泉</a>
                            <a href="javascript:void(0)" onclick="citySwitch(936)">张掖</a>
                            <a href="javascript:void(0)" onclick="citySwitch(935)">武威</a>
                            <a href="javascript:void(0)" onclick="citySwitch(945)">金昌</a>
                            <a href="javascript:void(0)" onclick="citySwitch(947)">嘉峪关</a>
                            <a href="javascript:void(0)" onclick="citySwitch(932)">定西</a>
                            <a href="javascript:void(0)" onclick="citySwitch(933)">平凉</a>
                            <a href="javascript:void(0)" onclick="citySwitch(934)">庆阳</a>
                            <a href="javascript:void(0)" onclick="citySwitch(939)">陇南</a>
                            <a href="javascript:void(0)" onclick="citySwitch(941)">甘南</a>
                            <a href="javascript:void(0)" onclick="citySwitch(930)">临夏</a>
                        </td>
                    </tr>

                    <tr id="bureau_select">
                        <td class="search_head"><span>县&emsp;局:</span></td>
                        <td id="village_count" style="border-right:none;">

                        </td>
                    </tr>
                    <tr style="height:40px;">
                        <td class="search_head"><span>查询条件:</span></td>
                        <td class="area_select">
                            <input type="text" id="key_word" placeholder="请输入校园名称关键字进行检索" class="trans_condition" style="width:48%;color:#eee;" />
                            <input type="button" value="查询" id="query_btn" onclick="javascript:query_list();" class="easyui-linkbutton" />
                        </td>
                    </tr>
                </table>
                <div class="sub_b">
                    <div class="all_count all_count1" style="font-size:13px;color:#f7e1e1;">总记录数：<span id="total_num"></span></div>
                    <div style="padding-right:14px;"><!--#0b0a8a;-->
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                            <tr>
                                <th rowspan="2">序号</th>
                                <th rowspan="2">分公司</th>
                                <th rowspan="2">县局</th>
                                <th rowspan="2">校园名称</th>
                                <th rowspan="2">类型</th>
                                <th rowspan="2">楼宇数</th>
                                <th rowspan="2">房间数</th>
                                <th rowspan="2">床位数</th>
                                <th rowspan="2">学生数</th>
                                <th colspan="2" style="border-bottom-color:#333399;">市场</th>
                                <th colspan="4" style="border-bottom-color:#333399;">竞争</th>
                            </tr>
                            <tr>
                                <!-- 市场 -->
                                <th>移动用户</th>
                                <th>市场渗透率</th>

                                <!-- 竞争 -->
                                <th>移动用户</th>
                                <th>其中：移动</th>
                                <th>其中：联通</th>
                                <th>其中：其他</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div">
                        <table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list" style="width: 100%">
                        </table>
                    </div>

                    <div style="display:none;">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    global_current_index_is_village_cell = "0";
    var curr_time = new Date();
    var url4data = '<e:url value="/pages/telecom_Index/common/sql/tabData_enterprise_leader.jsp" />';
    var url4data_common = '<e:url value="/pages/telecom_Index/common/sql/tabData_common.jsp" />';
    var seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "big_data_list",acct_mon='';
    var city_id_temp = '${param.region_id}';

    var bureau_id_temp = '${sessionScope.UserInfo.CITY_NO}';
    var branch_id_temp = '${sessionScope.UserInfo.TOWN_NO}';
    var grid_id_temp = '${sessionScope.UserInfo.GRID_NO}';
    var user_level = '${sessionScope.UserInfo.LEVEL}';

    var default_option = "<span onclick=\"bureauSwitch(\'999\')\" class=\"bureau999\">全部</span>";

    if(city_id_temp==""){
        if(user_level==1)
            city_id_temp ='999';
        else
            city_id_temp ='${sessionScope.UserInfo.AREA_NO}';
    }else{
        city_id_for_village_tab_view = city_id_temp;
        getBureauList();
    }

    function initTabHeight(){
        var initHeight = document.body.offsetHeight*0.94 - 50 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".all_count").eq(1).height() - $("#table_head").height();
        $(".t_body").css("max-height",initHeight);
    }

    //var long_message_width = 0;
    $(function(){
        if('${param.from_menu}'=="1")
            $("#closeTab").hide();
        //long_message_width = $("#big_tab_info_list").width()*0.17;

        //var a=$('#acctday').datebox('getValue').replace(/-/g, "");

        initCitySelect(user_level);
        citySelectCss(city_id_temp);

        initTabHeight();
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
        $("#acctday").datebox({
            onChange: function(date){
                acct_mon = date;
                acct_mon = acct_mon.replace(/-/g,'');
                query_list();
                //alert(date.getFullYear()+":"+(date.getMonth()+1)+":"+date.getDate());
            }
        });
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
            //var date_arry = date.split("-");
            //var year = date_arry[0];
            //var mm = date_arry[1];
            var year = date.substr(0,4);
            var mm = date.substr(4);
            db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
        }
    });

    function query_list(){
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
        var key_word = $.trim($("#key_word").val());
        if(city_id_temp=="999")
            city_id_temp = "";
        if(bureau_id_temp=="999")
            bureau_id_temp = "";
        return {
            "eaction": eaction,
            "page": page_list,
            "pageSize": table_rows_array[0],
            "city_id": city_id_temp,
            "bureau_id": bureau_id_temp,
            "v_name": key_word
        };
    }

    function listCollectScroll(flag) {
        var params = getParams();
        //$("#list_hide").datagrid({queryParams:params});
        var $list = $("#big_tab_info_list");
        $.post(url4data, params, function (data) {
            data = $.parseJSON(data);

            if(page_list==0){
                if(data.length){
                    //总记录数
                    $("#total_num").text(data[0].C_NUM);
                }else{
                    //总记录数
                    $("#total_num").text("0");
                }
            }
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td class='text-center'>" + (++seq_num) + "</td>";
                newRow += "<td class='text-center'>" + d.LATN_NAME + "</td>";
                newRow += "<td class='text-center'>" + d.BUREAU_NAME + "</td>";
                /*if('${param.from_menu}'=="1"){
                    if(user_level>3)
                        newRow += "<td class='text-left'><a onclick='insideToVillage("+ d.VILLAGE_ID +")' class='text-important-a' style='text-decoration:underline;cursor:pointer;'>" + d.VILLAGE_NAME + "</a>";
                    else
                        newRow += "<td class='text-left text-important'>" + d.VILLAGE_NAME + "";
                }else{
                    newRow += "<td class='text-left'><a onclick='insideToVillage("+ d.VILLAGE_ID +")' class='text-important-a' style='text-decoration:underline;cursor:pointer;'>" + d.VILLAGE_NAME + "</a>";
                }*/
                newRow += "<td class='text-center'><a href=\"javascript:void(0);\" onclick=\"javascript:pos('"+ d.BUSINESS_ID+"','"+ d.LATN_ID +"','" + d.LATN_NAME + "','"+ d.BUREAU_NO +"','"+ d.BUREAU_NAME +"','"+ d.POSITION +"')\" class=\"text-important-a\">" + d.BUSINESS_NAME + "</a></td>";
                newRow += "<td class='text-center'>" + d.DIC_DESC + "</td>";
                newRow += "<td class='text-center'>" + d.LY_CNT + "</td>";
                newRow += "<td class='text-center'>" + d.FJ_CNT + "</td>";
                newRow += "<td class='text-center'>" + d.CW_CNT + "</td>";
                newRow += "<td class='text-center'>" + d.ZHU_HU_COUNT + "</td>";

                newRow += "<td class='text-center'>" + d.YD_COUNT + "</td>";
                newRow += "<td class='text-center text-important-b'>" + d.YD_LV + "</td>";

                newRow += "<td class='text-center'>" + d.SJ_CNT + "</td>";
                newRow += "<td class='text-center'>" + d.SJ_CMCC_CNT + "</td>";
                newRow += "<td class='text-center'>" + d.SJ_UNICOM_CNT + "</td>";
                newRow += "<td class='text-center'>" + d.SJ_OTHER_CNT + "</td>";

                newRow += "</tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=6 >没有查询到数据</td></tr>")
            }
        });
    }

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page_list = 0;
        $("#big_tab_info_list").empty();
    }

    function initCitySelect(user_level){
        if(user_level>1){
            $(".area_select").children().css({"cursor":"default"});
            $(".area_select").children().attr("disabled","disabled");
        }
    }
    function citySelectCss(city_id_temp){
        $(".area_select a[onclick='citySwitch("+city_id_temp+")']").addClass("selected");
        $(".area_select a[onclick='citySwitch("+city_id_temp+")']").siblings().removeClass("selected");

        $(".city"+bureau_id_temp).addClass("span_selected");
        $(".city"+bureau_id_temp).siblings().removeClass("span_selected");
    }
    function bureauSelectCss(bureau_id){
        bureau_id_temp = bureau_id;
        $(".bureau"+bureau_id_temp).addClass("span_selected");
        $(".bureau"+bureau_id_temp).siblings().removeClass("span_selected");
    }
    function initTabSelect(kpi_id,element_name,func_name){
        var select_str = "";
        var items = index_range_map[kpi_id]
        var temp1 = "<a href=\"javascript:void(0)\" onclick=\"";
        var temp2 = "</a>";
        var temp3 = "";
        if(kpi_id=="KPI_D_001" || kpi_id=="KPI_D_003")
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

    function backup(level){
        initListDiv(1);
    }

    function citySwitch(city_id){
        if(user_level>1)
            return;
        bureau_id_temp = '999';
        citySelectCss(city_id);
        city_id_temp = city_id;
        getBureauList();
        query_list();
        initTabHeight();
    }
    function bureauSwitch(bureau_id){
        if(user_level>2)
            return;
        /*if(bureau_id=='999')
         bureau_id = "";*/
        bureau_id_temp = bureau_id;
        bureauSelectCss(bureau_id_temp);
        query_list();
    }
    function getBureauList(){
        $("#village_count").empty();
        var params = {
            city_id: city_id_temp
        }
        if(city_id_temp=='999'){
            $("#bureau_select").hide();
        }else{
            $("#village_count").append(default_option);
            $("#bureau_select").show();
            params.eaction='getAllBureauByCityId';
            $.post(url4data_common,params, function (data) {
                data = $.parseJSON(data);
                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    var newSpan="<span onclick='bureauSwitch(\""+ d.BUREAU_NO +"\")' class='bureau"+d.BUREAU_NO+"'>"+d.BUREAU_NAME+"</span>";
                    $("#village_count").append(newSpan);
                }
                if(user_level>2){
                    bureauSelectCss(bureau_id_temp);
                }else{
                    bureauSelectCss("999");
                }
                initTabHeight();
            });
        }
    }

    function pos(id,latn_id,latn_name,bureau_no,bureau_name,position){
        load_map_view();
        insideToSchool(id,latn_id,latn_name,bureau_no,bureau_name,position);
    }

</script>