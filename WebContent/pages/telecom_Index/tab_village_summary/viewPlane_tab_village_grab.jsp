<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="initTime">
    SELECT to_char(add_months(SYSDATE,-1),'yyyy-mm') val FROM dual
</e:q4o>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>城市支局小区信息统计</title>
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
        .search{border-color:#1851a9;}
        #table_head, #big_tab_info_list tr td:last-child {padding-right: 0px;}
        /*.long_message{
            display: block;
            text-overflow:ellipsis;
            overflow:hidden;
            white-space:nowrap;
        }*/
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
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>白&nbsp;区&nbsp;反&nbsp;抢&nbsp;统&nbsp;计</h4></div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search">
                    <tr style="display: none;">
                        <td class="search_head"><span>帐&nbsp;&nbsp;&nbsp;&nbsp;期:</span></td></td>
                        <td><input id="acctday" type="text" style="color:#ffffff; width:100px" /></td>
                    </tr>
                    <tr>
                        <td class="area_select_bq" style="width:80px"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分公司:</span></td>
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
                    <tr id="bqfq_tj" style="display: none">
                        <td class="area_select_bq" style="width: 80px"><span>&nbsp;&nbsp;分局/区县:</span></td>
                        <td>
                            <div class="line_select_bq">
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="sub_b">
                    <div style="padding-right:15px;background: none;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                            <tr>
                                <th width="2%" rowspan="2">序号</th>
                                <th width="5%" rowspan="2">分公司</th>
                                <th width="8%" rowspan="2">县区</th>
                                <th width="8%" rowspan="2">支局</th>
                                <th width="8%" rowspan="2">网格</th>
                                <th width="18%" rowspan="2">小区</th>
                                <th width="6%" rowspan="2">原渗透率</th>
                                <th width="6%" rowspan="2">累计到达渗透率</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div">
                        <table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list" style="width: 100%;">
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
    var url4data = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_summary_action.jsp" />';
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "get_BQFQ",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    //var branch_id_temp = '${param.branch_id}';
    //var grid_id_temp = '${param.grid_id}';
    var user_level = '${sessionScope.UserInfo.LEVEL}';

    var fgl = 'all';
    var stl = 'all';
    var jzcd_flag = '';
    var villageMode_flag = '';
    var portLv_flag = '';
    var line_flag = '';

    if(city_id_temp=="")
    //city_id_temp = city_id_for_village_tab_view;
        city_id_temp ='999';
    else
        city_id_for_village_tab_view = city_id_temp;
    //如果已经没有数据, 则不再次发起请求.
    var hasMore = true;
    //var long_message_width = 0;
    $(function(){
        console.log(1);
        //long_message_width = $("#big_tab_info_list").width()*0.17;

        //var a=$('#acctday').datebox('getValue').replace(/-/g, "");

        initCitySelect(user_level);
        citySelectCss(city_id_temp);

        $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 84 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height());
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

        $("#big_table_collect_type > span").each(function (index) {
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
        });
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
                console.log(acct_mon);
                clear_data();
                load_list();
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
            var date_arry = date.split("-");
            var year = date_arry[0];
            var mm = date_arry[1];
            db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
        }
    });

    function query_list_sort() {
        var temp = query_flag;
        var temp2 = (query_sort == '0'  ? '1' : '0');
        clear_data();
        query_sort = temp2;
        query_flag = temp;
        load_list();
    }

    function load_list() {
        var city_flag=false;
        if (city_id_temp=='999'){
            city_flag=true;
        }
        var params = {
            "latn_id":city_id_temp,
            "bureau_no":bureau_id_temp,
            "eaction": eaction,
            "page": 0
        }
        listScroll(params, true, eaction);
    }

    $("#big_table_info_div").scroll(function () {
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
                    "latn_id":city_id_temp,
                    "bureau_no":bureau_id_temp,
                    eaction: eaction,
                    page: ++page_list
                }
                listScroll(params, false, eaction);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function listScroll(params, flag, action) {
        listCollectScroll(params, flag);
    }

    function listCollectScroll(params, flag) {
        var $list = $("#big_tab_info_list");
        if (hasMore) {
            $.post(url4data, params, function (data) {
                data = $.parseJSON(data);

                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    var newRow = "<tr><td style='width: 2%'>" + (++seq_num) + "</td>";
                    newRow += "<td style='width: 5%;text-align:center;'>" + d.LATN_NAME + "</td>"//分公司
                    newRow += "<td style='width: 8%'>" + d.BUREAU_NAME +//县区
                        "</td><td style='width: 8%' >" + d.BRANCH_NAME +//支局
                        "</td><td style='width: 8%' >" + d.GRID_NAME +//网格
                        "</td><td style='width: 18%' class='text-left'>" + d.VILLAGE_NAME +//小区
                        "</td><td style='width: 6%;' class='text-right important'>" + d.YUAN_ST +//原渗透率
                        "</td><td style='width: 6%;color:#fa8513;'  class='text-right important'>" + d.LJ_ST +//累计到达渗透率
                        "</td></tr>";
                    $list.append(newRow);
                }
                //只有第一次加载没有数据的时候显示如下内容
                if (data.length == 0) {
                    hasMore = false;
                    if (flag) {
                        $list.empty();
                        $list.append("<tr><td style='text-align:center' colspan=6 >没有查询到数据</td></tr>")
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
        begin = 0, end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0
        flag = '1', query_sort = '0';
        $("#big_tab_info_list").empty();
    }

    function change_region(type) {
        $(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
        clear_data();
        query_flag = type;
        //$("#big_table_collect_type > span").eq(0).click();
    }

    function initCitySelect(user_level){
        if(user_level>1){
            $(".area_select_bq").children().css({"cursor":"default"});
            $(".area_select_bq").children().attr("disabled","disabled");
        }
    }
    function citySelectCss(city_id_temp){
        $(".area_select_bq a[onclick='citySwitch("+city_id_temp+")']").addClass("selected");
        $(".area_select_bq a[onclick='citySwitch("+city_id_temp+")']").siblings().removeClass("selected");
    }
    function bureauSelectCss(bureau_id){
        bureau_id_temp = bureau_id;
        $(".bureau"+bureau_id_temp).addClass("selected");
        $(".bureau"+bureau_id_temp).siblings().removeClass("selected");
    }
     // function font_important_formatter(value,rowData){
    //     return "<span style=\"color:#FE7A23;\">"+value+"</span>";
    // }

    function backup(level){
        initListDiv(1);
    }
    function changeBureauSelect(city_id_temp){
        $.post(url4data,{"eaction":"getBureauByCityId","city_id":city_id_temp},function(data){
            var bureau_json = $.parseJSON(data);
            $(".line_select_bq").empty();
            $(".line_select_bq").append("<a href=\"javascript:void(0)\" class=\"bureau999 selected\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('999')\">全部</a>");
            for(var i = 0,l = bureau_json.length;i<l;i++){
                var bureau_item = bureau_json[i];
                $(".line_select_bq").append("<a href=\"javascript:void(0)\" class=\"bureau"+bureau_item.BUREAU_NO+"\" style=\"display:inline-block;text-wrap:normal;\" onclick=\"javascript:bureauSwitch('"+bureau_item.BUREAU_NO+"')\">"+bureau_item.BUREAU_NAME+"</a>");
            }
        });
    }
    function citySwitch(city_id){
        if(city_id=='999')
            document.getElementById("bqfq_tj").style.display="none";
        else
        {
            $(".line_select_bq").empty();
            changeBureauSelect(city_id);
            $("#bqfq_tj").show();
        }
        //document.getElementById("bqfq_tj").style.display="show";
        if(user_level>1)
            return;
        citySelectCss(city_id);
        city_id_temp = city_id;
        bureau_id_temp='999';
        clear_data();
        load_list();
    }
    function bureauSwitch(bureau_id){
        if(user_level>2)
            return;
        /*if(bureau_id=='999')
            bureau_id = "";*/
        bureau_id_temp = bureau_id;
        bureauSelectCss(bureau_id_temp);
        clear_data();
        load_list();
    }
</script>