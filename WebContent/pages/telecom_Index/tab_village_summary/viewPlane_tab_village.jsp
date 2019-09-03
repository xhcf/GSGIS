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
    <title>城市支局小区信息统计_小区清单</title>
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
        #village_count span{cursor:pointer;}
        .span_selected {
            font-weight:bold;}
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
            color:#FFCC33;
        }
        #village_count span{
            color:#44E4FC;
        }
        .sub_box {background:#011157;}
        /*数据列表表头*/
        #table_head thead tr th{
            border:1px solid #333399;
            border-bottom-color:transparent;
        }
        /*数据列表表体*/
        .table1 td {border-color:#333366;}

        #table_head tr:first-child th:first-child{width:3%!important;}
        #table_head tr:first-child th:nth-child(2){width:3%!important;}
        #table_head tr:first-child th:nth-child(3){width:7%!important;}
        #table_head tr:first-child th:nth-child(4){width:12%!important;}
        #table_head tr:first-child th:nth-child(5){width:4%!important;}
        #table_head tr:first-child th:nth-child(6){width:4%!important;}
        #table_head tr:first-child th:nth-child(7){width:4%!important;}
        #table_head tr:first-child th:nth-child(8){width:4%!important;}
        #table_head tr:first-child th:nth-child(9){width:4%!important;}
        #table_head tr:first-child th:nth-child(10){width:4%!important;}
        #table_head tr:first-child th:nth-child(11){width:21%!important;}
        #table_head tr:first-child th:nth-child(12){width:5%!important;}
        #table_head tr:first-child th:nth-child(13){width:4%!important;}
        #table_head tr:first-child th:nth-child(14){width:5%!important;}
        #table_head tr:first-child th:nth-child(15){width:5%!important;}
        #table_head tr:first-child th:nth-child(16){width:5%!important;}
        #table_head tr:first-child th:nth-child(17){width:5%!important;}

        #table_head tr:nth-child(2) th:first-child{width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(2){width:5%!important;}
        #table_head tr:nth-child(2) th:nth-child(3){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(4){width:4%!important;}
        #table_head tr:nth-child(2) th:nth-child(5){width:4%!important;}

        #big_tab_info_list tr td:first-child {width:3%!important;}
        #big_tab_info_list tr td:nth-child(2){width:3%!important;}
        #big_tab_info_list tr td:nth-child(3){width:7%!important;}
        #big_tab_info_list tr td:nth-child(4){width:12%!important;}
        #big_tab_info_list tr td:nth-child(5){width:4%!important;}
        #big_tab_info_list tr td:nth-child(6){width:4%!important;}
        #big_tab_info_list tr td:nth-child(7){width:4%!important;}
        #big_tab_info_list tr td:nth-child(8){width:4%!important;}
        #big_tab_info_list tr td:nth-child(9){width:4%!important;}
        #big_tab_info_list tr td:nth-child(10){width:4%!important;}
        #big_tab_info_list tr td:nth-child(11){width:4%!important;}
        #big_tab_info_list tr td:nth-child(12){width:5%!important;}
        #big_tab_info_list tr td:nth-child(13){width:4%!important;}
        #big_tab_info_list tr td:nth-child(14){width:4%!important;}
        #big_tab_info_list tr td:nth-child(15){width:4%!important;}
        #big_tab_info_list tr td:nth-child(16){width:5%!important;}
        #big_tab_info_list tr td:nth-child(17){width:4%!important;}
        #big_tab_info_list tr td:nth-child(18){width:5%!important;}
        #big_tab_info_list tr td:nth-child(19){width:5%!important;}
        #big_tab_info_list tr td:nth-child(20){width:5%!important;}
        #big_tab_info_list tr td:nth-child(21){width:5%!important;}

        /*表格中要突出的字*/
        .text-important {color:#00FFFF!important;}
        .text-important-a {color:#4CB9F9!important;}
        /*本页标题*/
        .sub_box .big_table_title {height:28px;}
        .sub_box .big_table_title h4 {font-size:20px;}

        .search_head,.search_head span,.area_select a,#village_count,.table1 td,.tab_select a {font-size:12px!important;}

        .download_btn {top: 15px;right: 60px;}
    </style>
</head>
<body>
<div class="sub_box">
    <div class="close_button" id="closeTab"></div>
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>城&nbsp;市&nbsp;小&nbsp;区&nbsp;清&nbsp;单</h4></div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search" style="background-color: #043572;">
                    <tr style="display: none;">
                        <td class="search_head"><span>帐&nbsp;&nbsp;&nbsp;&nbsp;期:</span></td></td>
                        <td><input id="acctday" type="text" style="color:#ffffff; width:100px" /></td>
                    </tr>
                    <tr>
                        <td class="search_head"><span>分公司:</span></td>
                        <td class="area_select" colspan="6">
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
                    <tr><td class="search_head"><span>宽带渗透率:</span></td>
                        <td>
                            <div class="slt_select tab_select">
                                <a href="javascript:void(0)" onclick="stlSwitch('',this)">全部</a>
                            </div>
                        </td>
                        <td class="search_head"><span>小区规模:</span></td>
                        <td>
                            <div class="village_mode_select tab_select">
                                <a href="javascript:void(0)" onclick="villageModeSwitch('',this)">全部</a>
                            </div>
                        </td>
                        <td class="search_head"><span>光网覆盖率:</span></td>
                        <td>
                            <div class="fgl_select tab_select">
                                <a href="javascript:void(0)" onclick="fglSwitch('',this)">全部</a>
                                <%--<a href="javascript:void(0)" onclick="fglSwitch('h',this)">高<span class='small_range'>(&gt;=60%)</span></a>
                                <a href="javascript:void(0)" onclick="fglSwitch('m',this)">中<span class='small_range'>(30-60%)</span></a>
                                <a href="javascript:void(0)" onclick="fglSwitch('l',this)">低<span class='small_range'>(&lt;30%)</span></a>--%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="search_head"><span>流失占比:</span></td>
                        <td>
                            <div class="jzcd_select tab_select">
                                <a href="javascript:void(0)" onclick="jzcdSwitch('',this)">全部</a>
                            </div>
                        </td>
                        <td class="search_head"><span>端口占用率:</span></td>
                        <td>
                            <div class="port_lv_select tab_select">
                                <a href="javascript:void(0)" onclick="portLvSwitch('',this)">全部</a>
                                <%--<a href="javascript:void(0)" onclick="portLvSwitch('h',this)">高<span class='small_range'>(&gt;=60%)</span></a>
                                <a href="javascript:void(0)" onclick="portLvSwitch('m',this)">中<span class='small_range'>(30-60%)</span></a>
                                <a href="javascript:void(0)" onclick="portLvSwitch('l',this)">低<span class='small_range'>(&lt;30%)</span></a>--%>
                            </div>
                        </td>
                        <td class="search_head"><span>进线运营商:</span></td>
                        <td>
                            <div class="line_select tab_select">
                                <a href="javascript:void(0)" onclick="lineSwitch('',this)">全部</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('4',this)">4家</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('3',this)">3家</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('2',this)">2家</a>
                                <a href="javascript:void(0)" onclick="lineSwitch('1',this)">1家</a>
                            </div>
                        </td>
                    </tr>
                </table>
                <table cellspacing="0" cellpadding="0" class="search" style="border:none;background: none;">
                    <tr><td class="search_head">小区数:</td>
                        <td id="village_count" style="border-right:none;">

                        </td>
                    </tr>
                </table>
                <div class="sub_b">
                    <div style="padding-right:15px;"><!--#0b0a8a;-->
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                            <tr>
                                <th rowspan="2">序号</th>
                                <th rowspan="2">分公司</th>
                                <th rowspan="2">分局名称</th>
                                <th rowspan="2">小区名称</th>
                                <th rowspan="2">类型</th>
                                <th rowspan="2">住户数</th>
                                <th rowspan="2">光宽<br/>用户数</th>
                                <th rowspan="2">宽带<br/>渗透率</th>
                                <th rowspan="2">光网<br/>覆盖率</th>
                                <th rowspan="2">端口<br/>占用率</th>
                                <th rowspan="1" colspan="5" style="border-bottom-color:#333399;">流失情况</th>
                                <th rowspan="2">小区规模</th>
                                <th rowspan="2">入住率</th>
                                <th rowspan="2">消费能力</th>
                                <th rowspan="2">开盘时间</th>
                                <th rowspan="2">进线<br/>运营商数</th>
                                <th rowspan="2">统计进线<br/>运营商数</th>
                            </tr>
                            <tr>
                                <!-- 流失情况 -->
                                <th>流失<br/>用户</th>
                                <th>流失<br/>占比</th>
                                <th>其中<br/>拆机</th>
                                <!--<th width="5%">其中<br/>欠费用户</th>-->
                                <th>其中<br/>停机</th>
                                <th>其中<br/>沉默</th>
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
    var url4data = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_summary_action.jsp" />';
    var seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "market",acct_mon='';
    var city_id_temp = '${param.city_id}';

    var bureau_id_temp = '${sessionScope.UserInfo.CITY_NO}';
    var branch_id_temp = '${sessionScope.UserInfo.TOWN_NO}';
    var grid_id_temp = '${sessionScope.UserInfo.GRID_NO}';
    var user_level = '${sessionScope.UserInfo.LEVEL}';

    var fgl = '';
    var stl = '';
    var jzcd_flag = '';
    var villageMode_flag = '';
    var portLv_flag = '';
    var line_flag = '';

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
    var hasMore = true;
    //var long_message_width = 0;
    $(function(){
        if('${param.from_menu}'=="1")
            $("#closeTab").hide();
        //long_message_width = $("#big_tab_info_list").width()*0.17;

        //var a=$('#acctday').datebox('getValue').replace(/-/g, "");

        initCitySelect(user_level);
        citySelectCss(city_id_temp);

        initBureauCountBar();

        initTabSelect("KPI_D_001",$(".slt_select"),"stlSwitch");//宽带渗透率
        initTabSelect("KPI_D_002",$(".village_mode_select"),"villageModeSwitch");//小区规模
        initTabSelect("KPI_D_003",$(".jzcd_select"),"jzcdSwitch");//流失占比
        initTabSelect("KPI_D_008",$(".fgl_select"),"fglSwitch");//光网覆盖率
        initTabSelect("KPI_D_009",$(".port_lv_select"),"portLvSwitch");//端口占用率

        stlSelectCss(0);
        fglSelectCss(0);
        jzcdSelectCss(0);
        villageModeSelectCss(0);
        portLvSelectCss(0);
        lineSelectCss(0);
        /*$("input[name='fgl']").click(function(){
         fgl = $("input[name='fgl']:checked").val();
         clear_data();
         load_list();
         showTotal();
         });

         $("input[name='stl']").click(function(){
         stl = $("input[name='stl']:checked").val();
         clear_data();
         load_list();
         showTotal();
         });*/

        $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 79 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height());
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

        /*$("#big_table_collect_type > span").each(function (index) {
            $(this).on("click", function () {
                $(this).addClass("active").siblings().removeClass("active");
                var $show_div = $("#big_table_content_" + index);
                $show_div.show();
                $("#big_table_content").children().not($show_div).hide();
                var temp = flag;
                clear_data();
                flag = temp;
                load_list(index);
            });
        });*/
        //$("#big_table_collect_type span").eq(0).click();

        //load_list();

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
                clear_data();
                listCollectScroll(true);
                showTotal();
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

    function initBureauCountBar(){
        if(user_level>3){
            $(".search").eq(1).empty();
            $(".search").eq(1).append("<tr><td style='padding-left:15px;'><span style=\"color:white;\">记录数：</span><span id=\"total_num\" style='color:red;'></span></td></tr>");
        }
    }

    function query_list_sort() {
        var temp = query_flag;
        var temp2 = (query_sort == '0'  ? '1' : '0');
        clear_data();
        query_sort = temp2;
        query_flag = temp;
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
        var params = {
            "eaction": eaction,
            //"city_flag":city_flag,
            "fgl":fgl,
            "stl":stl,
            "jzcd_flag":jzcd_flag,
            "villageMode_flag":villageMode_flag,
            "portLv_flag":portLv_flag,
            "line_flag":line_flag,
            "page": page_list,
            "city_id": city_id_temp,
            "bureau_id": bureau_id_temp,
            "union_org_code": branch_id_temp,
            "grid_union_org_code": grid_id_temp,
            "acct_mon":acct_mon
        }
        return params;
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
                var newRow = "<tr><td>" + (++seq_num) + "</td>";
                newRow += "<td class='text-center'>" + d.LATN_NAME + "</td>"
                newRow += "<td class='text-center'>" + d.BUREAU_NAME;
                if('${param.from_menu}'=="1"){
                    if(user_level>3)
                        newRow += "</td><td class='text-left'><a onclick='insideToVillage("+ d.VILLAGE_ID +")' class='text-important-a' style='text-decoration:underline;cursor:pointer;'>" + d.VILLAGE_NAME + "</a>";
                    else
                        newRow += "</td><td class='text-left text-important'>" + d.VILLAGE_NAME + "";
                }else{
                    newRow += "</td><td class='text-left'><a onclick='insideToVillage("+ d.VILLAGE_ID +")' class='text-important-a' style='text-decoration:underline;cursor:pointer;'>" + d.VILLAGE_NAME + "</a>";
                }

                newRow += "</td>" +
                "<td class='text-center'>" + d.VILLAGE_VALUE_TEXT + "</td>" +
                "<td class='text-right'>" + d.GZ_ZHU_HU_COUNT +//住户数
                "</td><td class='text-right'>" + d.GZ_H_USE_CNT +//光宽用户数
                "</td><td class='text-right text-important'>" + d.MARKET_LV1 +//宽带渗透率
                "</td><td class='text-right'>" + d.FGL_LV1 +//光网覆盖率
                "</td><td class='text-right'>" + d.PORT_LV1 +//端口占用率

                    //发展
                    /*"</td><td style='width: 5%' class='text-right'>" + d.YEAR_DEV_CNT +//本年累计发展
                     "</td><td style='width: 5%' class='text-right'>" + d.MON_DEV_CNT +//本月发展
                     "</td><td style='width: 5%' class='text-right'>" + d.HB +//环比
                     "</td><td style='width: 5%' class='text-right'>" + d.RH_LV +//其中：融合占比
                     "</td><td style='width: 5%' class='text-right'>" + d.DK_LV +//其中：单产品占比*/

                    //竞争流失情况
                "</td><td class='text-right'>" + d.LOST_ALL +//流失用户
                "</td><td class='text-right text-important'>" + d.COMPETE_PERCENT1 +//流失占比

                "</td><td class='text-center'>" + d.REMOVE_CNT +//拆机
                    //"</td><td style='width: 5%' class='text-center'>" + d.OWE_CNT +//欠费
                "</td><td class='text-center'>" + d.STOP_CNT +//停机
                "</td><td class='text-center'>" + d.CM_CNT +//沉默

                "</td><td class='text-center'>" + d.VILLAGE_MODE +//小区规模
                "</td><td class='text-center'>" + d.VILLAGE_RU_RATE +//小区入住率
                "</td><td class='text-center'>" + d.VILLAGE_XF +//小区消费能力
                "</td><td class='text-center'>" + d.VILLAGE_LABEL +//小区开盘时间
                "</td><td class='text-center'>" + d.YYS_COUNT +//录入进线运营商数
                "</td><td class='text-center'>" + buss_cnt(d.OTHER_CM_CNT, d.OTHER_CU_CNT, d.OTHER_SARFT_CNT, d.OTHER_Y_CNT) +//统计进线运营商数
                "</td></tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=6 >没有查询到数据</td></tr>")
            }
        });
    }

    function buss_cnt(a,b,c,d){
        var i = 0;
        if(a>0) i++;
        if(b>0) i++;
        if(c>0) i++;
        if(d>0) i++;
        return i;
    }

    $("#collect_tabs_change > div").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    })

    function clear_data() {
        seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0
        flag = '1', query_sort = '0';
        $("#big_tab_info_list").empty();
        $("#all_count").empty();
    }

    function change_region(type) {
        $(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
        clear_data();
        query_flag = type;
        //$("#big_table_collect_type > span").eq(0).click();
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
    function stlSwitch(val,target){
        stl = val;
        var index = $(".slt_select > a").index(target);
        stlSelectCss(index);
        clear_data();
        listCollectScroll(true);
        showTotal();
    }

    function stlSelectCss(index){
        $(".slt_select > a").eq(index).addClass("selected").siblings().removeClass("selected");
    }

    function fglSwitch(val,target){
        fgl = val;
        var index = $(".fgl_select > a").index(target);
        fglSelectCss(index);
        clear_data();
        listCollectScroll(true);
        showTotal();
    }

    function fglSelectCss(index){
        $(".fgl_select > a").eq(index).addClass("selected").siblings().removeClass("selected");
    }

    function jzcdSwitch(val,target){
        jzcd_flag = val;
        var index = $(".jzcd_select > a").index(target);
        jzcdSelectCss(index);
        clear_data();
        listCollectScroll(true);
        showTotal();
    }

    function jzcdSelectCss(index){
        $(".jzcd_select > a").eq(index).addClass("selected").siblings().removeClass("selected");
    }

    function villageModeSwitch(val,target){
        villageMode_flag = val;
        var index = $(".village_mode_select > a").index(target);
        villageModeSelectCss(index);
        clear_data();
        listCollectScroll(true);
        showTotal();
    }

    function villageModeSelectCss(index){
        $(".village_mode_select > a").eq(index).addClass("selected").siblings().removeClass("selected");
    }

    function portLvSwitch(val,target){
        portLv_flag = val;
        var index = $(".port_lv_select > a").index(target);
        portLvSelectCss(index);
        clear_data();
        listCollectScroll(true);
        showTotal();
    }

    function portLvSelectCss(index){
        $(".port_lv_select > a").eq(index).addClass("selected").siblings().removeClass("selected");
    }

    function lineSwitch(val,target){
        line_flag = val;
        var index = $(".line_select > a").index(target);
        lineSelectCss(index);
        clear_data();
        listCollectScroll(true);
        showTotal();
    }

    function lineSelectCss(index){
        $(".line_select > a").eq(index).addClass("selected").siblings().removeClass("selected");
    }

    // function font_important_formatter(value,rowData){
    //     return "<span style=\"color:#FE7A23;\">"+value+"</span>";
    // }

    function backup(level){
        initListDiv(1);
    }

    function citySwitch(city_id){
        bureau_id_temp = '999';
        if(user_level>1)
            return;
        citySelectCss(city_id);
        city_id_temp = city_id;
        clear_data();
        listCollectScroll(true);
        showTotal();
    }
    function showTotal(){
        $("#village_count").empty();
        var params = {
            fgl:fgl,
            stl:stl,
            "jzcd_flag":jzcd_flag,
            "villageMode_flag":villageMode_flag,
            "portLv_flag":portLv_flag,
            "line_flag":line_flag,
            city_id: city_id_temp,
            acct_mon:acct_mon
        }
        if(city_id_temp=='999'){
            params.eaction='province';
            $.post(url4data, params, function (data) {
                data = $.parseJSON(data);
                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    var newSpan=d.LATN_NAME+"(<span onclick='citySwitch(\""+ d.LATN_ID+"\")' class='city"+ d.LATN_ID+"'>"+d.TOTAL+"</span>) ";
                    if(i<l-1)
                        newSpan += ",";
                    $("#village_count").append(newSpan);
                }
                citySelectCss("999");
            });
        }else{
            params.eaction='city';
            $.post(url4data,params, function (data) {
                data = $.parseJSON(data);
                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    var newSpan=d.BUREAU_NAME+"(<span onclick='bureauSwitch(\""+ d.BUREAU_NO +"\")' class='bureau"+d.BUREAU_NO+"'>"+d.TOTAL+"</span>) ";
                    if(i<l-1)
                        newSpan += ",";
                    $("#village_count").append(newSpan);
                }
                if(user_level>2){
                    bureauSelectCss(bureau_id_temp);
                }else{
                    bureauSelectCss("999");
                }
            });
        }
    }
    function bureauSwitch(bureau_id){
        if(user_level>2)
            return;
        /*if(bureau_id=='999')
         bureau_id = "";*/
        bureau_id_temp = bureau_id;
        bureauSelectCss(bureau_id_temp);
        clear_data();
        listCollectScroll(true);
    }
</script>