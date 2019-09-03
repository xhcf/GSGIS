<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="now">
    select to_char(sysdate,'yyyy-mm-dd') val from dual
</e:q4o>
<e:q4o var="last_month">
    select to_char(last_day(add_months(sysdate,-1)),'yyyymm') val from dual
</e:q4o>
<e:set var="initTime">${last_month.VAL}</e:set>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>数据质量监控</title>
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
            width:90px;
            text-align:center;
            font-weight:bold;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }
        .search{
            background: none;
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
        .textbox,.textbox-text{background:none!important;border:0px;}

        .tab_head1 tr th:first-child{width:5%!important;}
        .tab_head1 tr th:nth-child(2){width:8%!important;}
        .tab_head1 tr th:nth-child(3){width:24%!important;}
        .tab_head1 tr th:nth-child(4){width:9%!important;}
        .tab_head1 tr th:nth-child(5){width:9%!important;}
        .tab_head1 tr th:nth-child(6){width:9%!important;}
        .tab_head1 tr th:nth-child(7){width:9%!important;}
        .tab_head1 tr th:nth-child(8){width:9%!important;}
        .tab_head1 tr th:nth-child(9){width:9%!important;}
        .tab_head1 tr th:nth-child(10){width:9%!important;}

        #resident_detail_list0 tr td:first-child{width:5%!important;}
        #resident_detail_list0 tr td:nth-child(2){width:8%!important;}
        #resident_detail_list0 tr td:nth-child(3){width:24%!important;}
        #resident_detail_list0 tr td:nth-child(4){width:9%!important;min-width:0px!important;}
        #resident_detail_list0 tr td:nth-child(5){width:9%!important;}
        #resident_detail_list0 tr td:nth-child(6){width:9%!important;}
        #resident_detail_list0 tr td:nth-child(7){width:9%!important;}
        #resident_detail_list0 tr td:nth-child(8){width:9%!important;}
        #resident_detail_list0 tr td:nth-child(9){width:9%!important;}
        #resident_detail_list0 tr td:nth-child(10){width:9%!important;}

        .tab_head2 tr th:first-child{width:5%!important;}
        .tab_head2 tr th:nth-child(2){width:8%!important;}
        .tab_head2 tr th:nth-child(3){width:33%!important;}
        .tab_head2 tr th:nth-child(4){width:9%!important;}
        .tab_head2 tr th:nth-child(5){width:9%!important;}
        .tab_head2 tr th:nth-child(6){width:9%!important;}
        .tab_head2 tr th:nth-child(7){width:9%!important;}
        .tab_head2 tr th:nth-child(8){width:9%!important;}
        .tab_head2 tr th:nth-child(9){width:9%!important;}

        #resident_detail_list1 tr td:first-child{width:5%!important;}
        #resident_detail_list1 tr td:nth-child(2){width:8%!important;}
        #resident_detail_list1 tr td:nth-child(3){width:33%!important;}
        #resident_detail_list1 tr td:nth-child(4){width:9%!important;min-width:0px!important;}
        #resident_detail_list1 tr td:nth-child(5){width:9%!important;}
        #resident_detail_list1 tr td:nth-child(6){width:9%!important;}
        #resident_detail_list1 tr td:nth-child(7){width:9%!important;}
        #resident_detail_list1 tr td:nth-child(8){width:9%!important;}
        #resident_detail_list1 tr td:nth-child(9){width:9%!important;}

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
        /*条件区*/
        .search{
            background: #043572;
            width:100%;
            color:#fff;
            border:1px solid #1851a9;
        }
        .search a{
            color:#fff;
            height:25px!important;
        }
        .sub_b {margin-top:5px;}
        /*去除表格边框*/
        .table1 {border:none;}
        /*标签页选中效果*/
        .inner_tab .active, .inner_tab span:hover {color:#FFCC33;}
        .textbox.combo.datebox {border:1px solid #3E4997!important;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>数&nbsp;据&nbsp;质&nbsp;量&nbsp;监&nbsp;控</h4></div>
        <div style="color:#FFFFFF; width:400px" class="databox_">
            <span style ="font-weight:700;font-size:14px;">账&nbsp;&nbsp;&nbsp;&nbsp;期：</span><input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
        </div>
        <table cellspacing="0" cellpadding="0" class="search">
            <tr style="">
                <td class="area_select_bq search_head" style="width:70px"><span>分公司:</span></td>
                <td class="area_select_bq" colspan="6">
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
            <tr id="bqfq_tj" style="display: none;">
                <td class="area_select_bq" style="width: 70px"><span>&nbsp;&nbsp;分局/区县:</span></td>
                <td>
                    <div class="line_select_bq">
                    </div>
                </td>
            </tr>
        </table>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div id="big_table_change">
                    <div id="big_table_collect_type" class="inner_tab">
                        <span>市场渗透率预警</span>|<span>光宽用户数大于实占端口数</span>
                    </div>
                </div>
                <div class="sub_b">
                    <div class="all_count" style="top:0px;position: relative;">总记录数：<span id="all_count">15</span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </e:if>
                    <div id="big_table_content">
                        <div id="big_table_content_0" style="margin-right: 14px;display:block;">
                            <table cellspacing="0" cellpadding="0" class="table1 tab_head1" style="width: 100%">
                                <thead>
                                <tr>
                                    <th><div>序号</div></th>
                                    <th>分公司</th>
                                    <th><div>小区名称</div></th>
                                    <th><div>累计到达<br>渗透率</div></th>
                                    <th formatter="formatterper2"><div>本月提升</div></th>
                                    <th><div>本年提升</div></th>
                                    <th>住户数</th>
                                    <th>光宽用户数</th>
                                    <th>政企住户</th>
                                    <th>政企宽带</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <div id="big_table_content_1" style="margin-right: 14px;display:none;">
                            <table cellspacing="0" cellpadding="0" class="table1 tab_head2" id="table_head" style="width: 100%;">
                                <thead>
                                <tr>
                                    <th><div>序号</div></th>
                                    <th>分公司</th>
                                    <th>小区名称</th>
                                    <th>住户数</th>
                                    <th><div>宽带渗透率</div></th>
                                    <th><div>光宽用户数</div></th>
                                    <th>端口数</th>
                                    <th>占用端口数</th>
                                    <th>端口占用率</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                    <div class="t_body" id="big_table_info_div0" style="overflow-y:scroll;display:block;">
                        <table cellspacing="0" cellpadding="0" class="table1" style="width: 100%">
                            <tbody id="resident_detail_list0">
                            </tbody>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div1" style="overflow-y:scroll;display:none;">
                        <table cellspacing="0" cellpadding="0" class="table1" style="width: 100%">
                            <tbody id="resident_detail_list1">
                            </tbody>
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
    var url4data_list = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_leader_tabs.jsp" />';
    var url4data = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_summary_action.jsp" />';
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0,page = 0, query_flag=2, query_sort = '0', eaction = "broad_home_list",eaction1 = "market_data_monitor",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '';
    var user_level = '${sessionScope.UserInfo.LEVEL}';

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
    }else{
        city_id_for_village_tab_view = city_id_temp;
    }

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
        var db = $('#beginDate');
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
            },
            onChange: function(date){
                beginDate = date.replace(/-/g,'');
                query();
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
            var month = '${initTime}';
            var year = month.substring(0, 4);
            var mm = month.substring(4, 6)
            db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
        }

        //页签切换
        $("#big_table_collect_type > span").each(function (index) {
            $(this).on("click", function () {
                index_temp = index;
                $(this).addClass("active").siblings().removeClass("active");
                var $show_div = $("#big_table_content_" + index_temp);
                $show_div.show();
                $("#big_table_content").children().not($show_div).hide();

                $("div[id^='big_table_info_div']").hide();

                var $show_content_div = $("#big_table_info_div"+index_temp);
                $show_content_div.show();
                //var temp = flag;
                clear_data();
                //flag = temp;
                load_list();
            });
        });

        $(".t_body").css("max-height", document.body.offsetHeight - $(".big_table_title").height() - $(".databox_").height() - $(".search").height() - $("#big_table_change").height() - $(".all_count").height() - $("#big_table_content").height() - 85);

        init_tab_height = document.body.offsetHeight*0.94 - 168 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();

        initCitySelect(user_level);
        citySelectCss(city_id_temp);

        //changeBureauSelect(city_id_temp);

        //initTabHeight_province();
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

        //load_list();
        $("#big_table_collect_type span").eq(0).click();
    });

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-55);
    }

    function query_list_sort() {
        var temp = query_flag;
        var temp2 = (query_sort == '0'  ? '1' : '0');
        clear_data();
        query_sort = temp2;
        query_flag = temp;
        load_list();
    }

    function load_list() {
        var flag = 0;
        beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
        var city_flag=false;
        if (city_id_temp=='999'){
            city_flag=true;
            flag = 1;
            if(index_temp==0)
                city_id_temp = "";
        }else{
            flag = 2;
        }

        //市场渗透率
        if(index_temp==0){
            var params = {
                "eaction": eaction,
                beginDate:beginDate,
                flag: flag,
                page: 0,
                pageSize: table_rows_array[0],
                //region_id: global_region_id,
                query_flag: 5,
                query_sort: 0,
                //query_sort: query_sort,
                region_id: city_id_temp,
                data_monitor:1,
                index:index_temp
            }
            listScroll(params, true, eaction);
        }else if(index_temp==1){//光宽大于实占端口数
            var params = {
                "eaction": eaction1,
                "beginDate":beginDate,
                "city_id":city_id_temp,
                "bureau_no":bureau_id_temp,
                "branch_no":branch_id_temp,
                "page": 0,
                "pageSize": table_rows_array[0],
                "index":index_temp,
                "data_monitor":1
            }
            listScroll(params, true, eaction);
        }
    }
    function query(){
        clear_data();
        load_list();
    }

    $("#big_table_info_div0").scroll(function () {
        var flag = 0;
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                var city_flag=false;
                if (city_id_temp=='999'){
                    city_flag=true;
                    flag = 1;
                }else{
                    flag = 2;
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
                    pageSize: table_rows_array[0],
                    data_monitor:1,
                    index:0
                }

                listScroll(params, false, eaction);

            }
            begin_scroll = new Date().getTime();
        }
    });
    $("#big_table_info_div1").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                var city_flag=false;
                if (city_id_temp=='999'){
                    city_flag=true;
                }
                var params = {
                    "eaction": eaction1,
                    "beginDate":beginDate,
                    "city_id":city_id_temp,
                    "bureau_no":bureau_id_temp,
                    "branch_no":branch_id_temp,
                    "page": ++page,
                    "pageSize": table_rows_array[0],
                    "index":index_temp,
                    "data_monitor":1
                }

                    listScroll(params, false, eaction);

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
            else if(index_temp==1)
                url4data_url = url4data_list;
            $.post(url4data_url, params, function (data) {
                data = $.parseJSON(data);
                /*if(data.length)
                    $("#download_div").show();
                else
                    $("#download_div").hide();*/
                if(page==0){
                    if (data.length == 0 && flag) {
                        $("#all_count").html('0');
                    } else {
                        $("#all_count").html(data[0].C_NUM);
                    }
                }

                if(index_temp==0){
                    for (var i = 0, l = data.length; i < l; i++) {
                        var d = data[i];
                        var newRow = "<tr><td>" + (++seq_num) + "</td>";
                        newRow += "<td style='text-align:center;'>" + d.AREA_DESC1 + "</td>"
                        newRow += "<td style='text-align:left;'>" + d.AREA_DESC + "</td>"
                        newRow += "<td style='color: #fa8513'>" + d.BROAD_PENETRANCE +
                        "</td><td>" + d.FILTER_MON_RATE +
                        "</td><td>" + d.FILTER_YEAR_RATE +
                        "</td><td>" + d.GZ_ZHU_HU_COUNT +
                        "</td><td>" + d.GZ_H_USE_CNT +
                        "</td><td>" + d.GOV_ZHU_HU_COUNT +
                        "</td><td>" + d.GOV_H_USE_CNT +
                        "</td></tr>";
                        $list.append(newRow);
                    }
                    //只有第一次加载没有数据的时候显示如下内容
                    if (data.length == 0) {
                        hasMore = false;
                        if (flag) {
                            $list.empty();
                            $list.append("<tr><td style='text-align:center' colspan=10 >没有查询到数据</td></tr>")
                        }
                    }
                }else if(index_temp==1){
                    for (var i = 0, l = data.length; i < l; i++) {
                        var d = data[i];
                        var newRow = "<tr><td>" + (++seq_num) + "</td>";
                        newRow += "<td class='text-center'>" + d.LATN_NAME + "</td>"
                        //newRow += "<td style='width: 12%;color:#fa8513;' class='text-left'><a onclick='insideToVillage("+ d.VILLAGE_ID +")' style='text-decoration:underline;cursor:pointer;color:#fa8513;'>" + d.VILLAGE_NAME + "</a>" +
                        newRow += "<td class='text-left'>" + d.VILLAGE_NAME + "" +
                        "</td><td class='text-right important'>" + d.GZ_ZHU_HU_COUNT +//住户数
                        "</td><td style='color:#fa8513;' class='text-right important'>" + d.MARKET_LV1 +//宽带渗透率
                        "</td><td class='text-right'>" + d.GZ_H_USE_CNT +//光宽用户数
                        "</td><td class='text-right'>" + d.PORT_ID_CNT +//端口数
                        "</td><td class='text-right'>" + d.USE_PORT_CNT +//端口数
                        "</td><td class='text-right'>" + d.PORT_LV1 +//端口占用率
                        "</td></tr>";
                        $list.append(newRow);
                    }
                    if (data.length == 0) {
                        hasMore = false;
                        if (flag) {
                            $list.empty();
                            $list.append("<tr><td style='text-align:center' colspan=9 >没有查询到数据</td></tr>")
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
        flag = '1', query_sort = '0';
        $("#total_num").text("");
        $("#resident_detail_list0").empty();
        $("#resident_detail_list1").empty();
        $("#download_div").hide();
    }
    function clear_option(){
        $("#village_select").empty();
        $("#build_select").empty();
    }

    function change_region(type) {
        $(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
        clear_data();
        query_flag = type;
        //$("#big_table_collect_type > span").eq(0).click();
    }

    function initCitySelect(user_level){
        if(user_level>1){
            //initTabHeight_city();
            $(".area_select_bq").children().css({"cursor":"default"});
            $(".area_select_bq").children().attr("disabled","disabled");
            //changeBureauSelect(city_id_temp);
            //$("#bqfq_tj").show();
        }
    }
    function citySelectCss(city_id_temp){
        $(".area_select_bq a[onclick='citySwitch("+city_id_temp+")']").addClass("selected");
        $(".area_select_bq a[onclick='citySwitch("+city_id_temp+")']").siblings().removeClass("selected");
    }
    function bureauSelectCss(bureau_id){
        bureau_id_temp = bureau_id;
        if(bureau_id_temp=="999" || bureau_id_temp==""){
            $(".line_select_bq").children().eq(0).addClass("selected");
            $(".line_select_bq").children().eq(0).siblings().removeClass("selected");
            //bureau_id_temp = $(".line_select_bq").children().eq(0).attr("class").replace("bureau","");
        }else{
            $(".bureau"+bureau_id_temp).addClass("selected");
            $(".bureau"+bureau_id_temp).siblings().removeClass("selected");
        }
    }

    function backup(level){
        initListDiv(1);
    }
    function changeBureauSelect(city_id_temp){
        $.post(url4data,{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
            var bureau_json = $.parseJSON(data);
            $(".line_select_bq").empty();
            var bureau_no_first = "";
            //$(".line_select_bq").append("<a href=\"javascript:void(0)\" class=\"bureau999 selected\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('999')\">全部</a>");
            for(var i = 0,l = bureau_json.length;i<l;i++){
                var bureau_item = bureau_json[i];
                $(".line_select_bq").append("<a href=\"javascript:void(0)\" class=\"bureau"+bureau_item.BUREAU_NO+"\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('"+bureau_item.BUREAU_NO+"')\">"+bureau_item.BUREAU_NAME+"</a>");
                if(i==0)
                    bureau_no_first = bureau_item.BUREAU_NO;
            }
            if(bureau_id_temp=="")
                bureau_id_temp = bureau_no_first;
            bureauSelectCss(bureau_id_temp);
            changeBranchSelect(bureau_id_temp);
        });
    }

    function changeBranchSelect(bureau_no){
        $.post(url4data,{"eaction":"getBranchByBureauId","bureau_no":bureau_no},function(data){
            var branch_json = $.parseJSON(data);
            $("#branch_select").empty();
            for(var i = 0,l = branch_json.length;i<l;i++){
                var branch_item = branch_json[i];
                if(i==0)
                    $("#branch_select").append("<option selected='selected' value='"+branch_item.UNION_ORG_CODE+"'>"+branch_item.BRANCH_NAME+"</option>");
                else
                    $("#branch_select").append("<option value='"+branch_item.UNION_ORG_CODE+"'>"+branch_item.BRANCH_NAME+"</option>");
            }
        });
    }

    function changeVillageSelect(branch_no){
        $("#village_select").empty();
        if(branch_no=="null")
            return;
        $.post(url4data,{"eaction":"getVillageIdByBranchNo","union_org_code":branch_no},function(data){
            var village_json = $.parseJSON(data);
            for(var i = 0,l = village_json.length;i<l;i++){
                var village_item = village_json[i];
                if(i==0)
                    $("#village_select").append("<option selected='selected' value='"+village_item.VILLAGE_ID+"'>"+village_item.VILLAGE_NAME+"</option>");
                else
                    $("#village_select").append("<option value='"+village_item.VILLAGE_ID+"'>"+village_item.VILLAGE_NAME+"</option>");
            }
        });
    }

    function citySwitch(city_id){
        debugger;
        if(user_level>1)
            return;
        if(city_id=='999'){
            initTabHeight_province();
            document.getElementById("bqfq_tj").style.display="none";
        }else{
            //initTabHeight_city();
            //$(".line_select_bq").empty();
            //changeBureauSelect(city_id);
            //$("#bqfq_tj").show();
        }
        city_id_temp = city_id;
        bureau_id_temp='';
        citySelectCss(city_id_temp);
        bureauSelectCss(bureau_id_temp);
        //changeVillageSelect(bureau_id_temp);
        clear_data();
        clear_option();
        load_list();
    }
    function bureauSwitch(bureau_id){
        if(user_level>2)
            return;
        /*if(bureau_id=='999')
            bureau_id = "";*/
        bureau_id_temp = bureau_id;
        bureauSelectCss(bureau_id_temp);
        //changeVillageSelect(bureau_id_temp);
        changeBranchSelect(bureau_id_temp);
        clear_data();
        clear_option();
        load_list();
    }
    function branchSwitch(){
        branch_id_temp = $("#branch_select option:selected").val();
        changeVillageSelect(branch_id_temp);
        clear_data();

        load_list();
    }
</script>