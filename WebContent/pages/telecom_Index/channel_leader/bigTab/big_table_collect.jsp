<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="today_ymd">
    select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'YYYY'||'"年"'||'MM'||'"月"'||'DD'|| '"日"') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '1'
</e:q4o>
<e:q4o var="today_time">
    select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'YYYY'||'"年"'||'MM'||'"月"'||'DD'|| '"日"') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '1'
</e:q4o>
<e:q4o var="now">
    select to_char((to_date(min(const_value), 'yyyymmdd') + 1),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="yesterday">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="lastMonth">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '3'
</e:q4o>
<e:q4o var="acct_yesterday">
	select to_char(sysdate-1,'yyyymmdd') val,to_char(sysdate-1,'yyyy-mm-dd') val1 from dual
</e:q4o>
<e:set var="initTime">${acct_yesterday.VAL1}</e:set>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>竞争信息收集</title>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
    <!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/lead_tab.css?version=1.1" />' rel="stylesheet"
          type="text/css"
          media="all">
    <style>
        .search{border-color:#1851a9;}
        .table1, .table1 th, .table1 td{
            border-color:#12489a;
        }

        /*竞争收集统计 小区*/
        .tab0_vill tr:first-child th:first-child{width:5%;}
        .tab0_vill tr:first-child th:nth-child(2){width:15%;}
        .tab0_vill tr:first-child th:nth-child(3){width:6%;}
        .tab0_vill tr:first-child th:nth-child(4){width:6%;}
        .tab0_vill tr:first-child th:nth-child(5){width:6%;}
        .tab0_vill tr:first-child th:nth-child(6){width:5%;}
        .tab0_vill tr:first-child th:nth-child(7){width:5%;}

        .tab0_vill tr:first-child th:nth-child(8){width:38%;}

        .tab0_vill tr:first-child th:nth-child(9){width:7%;}
        .tab0_vill tr:first-child th:nth-child(10){width:7%;}


        .tab0_vill tr:nth-child(2) th:first-child{width:6%;}
        .tab0_vill tr:nth-child(2) th:nth-child(2){width:6%;}
        .tab0_vill tr:nth-child(2) th:nth-child(3){width:6%;}
        .tab0_vill tr:nth-child(2) th:nth-child(4){width:5%;}
        .tab0_vill tr:nth-child(2) th:nth-child(5){width:5%;}
        .tab0_vill tr:nth-child(2) th:nth-child(6){width:5%;}
        .tab0_vill tr:nth-child(2) th:nth-child(7){width:5%;}

        .body0_vill tr td:first-child{width:5%!important;}
        .body0_vill tr td:nth-child(2){width:15%!important;}
        .body0_vill tr td:nth-child(3){width:6%!important;}
        .body0_vill tr td:nth-child(4){width:6%!important;}
        .body0_vill tr td:nth-child(5){width:6%!important;}
        .body0_vill tr td:nth-child(6){width:5%!important;}
        .body0_vill tr td:nth-child(7){width:5%!important;}

        .body0_vill tr td:nth-child(8){width:6%!important;}
        .body0_vill tr td:nth-child(9){width:6%!important;}
        .body0_vill tr td:nth-child(10){width:6%!important;}
        .body0_vill tr td:nth-child(11){width:5%!important;}
        .body0_vill tr td:nth-child(12){width:5%!important;}
        .body0_vill tr td:nth-child(13){width:5%!important;}
        .body0_vill tr td:nth-child(14){width:5%!important;}

        .body0_vill tr td:nth-child(15){width:7%!important;}
        .body0_vill tr td:nth-child(16){width:7%!important;}

        /*竞争收集统计 市 县 支局 网格*/
        .tab0_other tr:first-child th:first-child{}
        .tab0_other tr:first-child th:nth-child(2){}
        .tab0_other tr:first-child th:nth-child(3){}
        .tab0_other tr:first-child th:nth-child(4){}
        .tab0_other tr:first-child th:nth-child(5){}
        .tab0_other tr:first-child th:nth-child(6){}
        .tab0_other tr:first-child th:nth-child(7){}
        .tab0_other tr:first-child th:nth-child(8){}
        .tab0_other tr:first-child th:nth-child(9){}
        .tab0_other tr:first-child th:nth-child(10){}

        .tab0_other tr:nth-child(2) th:first-child{}
        .tab0_other tr:nth-child(2) th:nth-child(2){}
        .tab0_other tr:nth-child(2) th:nth-child(3){}
        .tab0_other tr:nth-child(2) th:nth-child(4){}
        .tab0_other tr:nth-child(2) th:nth-child(5){}
        .tab0_other tr:nth-child(2) th:nth-child(6){}
        .tab0_other tr:nth-child(2) th:nth-child(7){}

        /*竞争预警 小区*/
        .tab1_vill tr:first-child th:first-child{}
        .tab1_vill tr:first-child th:nth-child(2){}
        .tab1_vill tr:first-child th:nth-child(3){}
        .tab1_vill tr:first-child th:nth-child(4){}
        .tab1_vill tr:first-child th:nth-child(5){}

        .tab1_vill tr:nth-child(2) th:first-child{}
        .tab1_vill tr:nth-child(2) th:nth-child(2){}
        .tab1_vill tr:nth-child(2) th:nth-child(3){}
        .tab1_vill tr:nth-child(2) th:nth-child(4){}
        .tab1_vill tr:nth-child(2) th:nth-child(5){}
        .tab1_vill tr:nth-child(2) th:nth-child(6){}
        .tab1_vill tr:nth-child(2) th:nth-child(7){}
        .tab1_vill tr:nth-child(2) th:nth-child(8){}
        .tab1_vill tr:nth-child(2) th:nth-child(9){}
        .tab1_vill tr:nth-child(2) th:nth-child(10){}
        .tab1_vill tr:nth-child(2) th:nth-child(11){}
        .tab1_vill tr:nth-child(2) th:nth-child(12){}
        .tab1_vill tr:nth-child(2) th:nth-child(13){}
        .tab1_vill tr:nth-child(2) th:nth-child(14){}

        /*竞争预警 市 县 支局 网格*/
        .tab1_other tr:first-child th:first-child{}
        .tab1_other tr:first-child th:nth-child(2){}
        .tab1_other tr:first-child th:nth-child(3){}
        .tab1_other tr:first-child th:nth-child(4){}
        .tab1_other tr:first-child th:nth-child(5){}

        .tab1_other tr:nth-child(2) th:first-child{}
        .tab1_other tr:nth-child(2) th:nth-child(2){}
        .tab1_other tr:nth-child(2) th:nth-child(3){}
        .tab1_other tr:nth-child(2) th:nth-child(4){}
        .tab1_other tr:nth-child(2) th:nth-child(5){}
        .tab1_other tr:nth-child(2) th:nth-child(6){}
        .tab1_other tr:nth-child(2) th:nth-child(7){}
        .tab1_other tr:nth-child(2) th:nth-child(8){}
        .tab1_other tr:nth-child(2) th:nth-child(9){}
        .tab1_other tr:nth-child(2) th:nth-child(10){}
        .tab1_other tr:nth-child(2) th:nth-child(11){}
        .tab1_other tr:nth-child(2) th:nth-child(12){}
        .tab1_other tr:nth-child(2) th:nth-child(13){}
        .tab1_other tr:nth-child(2) th:nth-child(14){}

        .tab0_vill {display:none;}
    </style>
</head>
<body>
<div class="sub_box">
    <div class="close_button" id="closeTab"></div>
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>竞&nbsp;争&nbsp;信&nbsp;息&nbsp;收&nbsp;集</h4></div>
        <div style="color:#FFFFFF; width:400px" class="databox_">
			<span style ="font-weight:700;font-size:14px;">账&nbsp;&nbsp;&nbsp;&nbsp;期：</span><input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
		</div>
        <div class="tabs_change" id="collect_tabs_change">
        </div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div id="big_table_change">
                    <div id="big_table_collect_type" class="inner_tab">
                        <span>竞争收集统计</span>|<span>竞争预警</span>
                    </div>
                </div>
                <div class="sub_b">
                    <div class="all_count right">总记录数：<span id="all_count">15</span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                    	<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </e:if>
                    <div id="big_table_content">
                        <div id="big_table_content_0" style="margin-right: 14px">
                            <table style="width: 100%" class="table1 tab0_other" id="table_head2">
                                <tr>
                                    <th width="50" rowspan="2">序号</th>
                                    <th width="100" rowspan="2"><div>地域</div></th>
                                    <th width="75" rowspan="2"><div>应收集数</div></th>
                                    <th width="75" rowspan="2"><div>已收集数</div></th>
                                    <th width="75" rowspan="2" onclick="query_list_sort()" style="cursor: pointer"><div>收集率<span class='sort_icon'></span></div></th>
                                    <th width="75" rowspan="2">本月提升</th>
                                    <th width="75" rowspan="2">全年提升</th>
                                    <th colspan="7">异网宽带收集情况</th>
                                </tr>
                                <tr>
                                    <th width="75">异网总数</th>
                                    <th width="75">移动</th>
                                    <th width="75">占比</th>
                                    <th width="75">联通</th>
                                    <th width="75">占比</th>
                                    <th width="75">广电</th>
                                    <th width="75">其他</th>
                                </tr>
                            </table>
                            <table style="width: 100%" class="table1 tab0_vill" id="table_head3">
                                <tr>
                                    <th rowspan="2">序号</th>
                                    <th rowspan="2"><div>地域</div></th>
                                    <th rowspan="2"><div>应收集数</div></th>
                                    <th rowspan="2"><div>已收集数</div></th>
                                    <th rowspan="2" onclick="query_list_sort()" style="cursor: pointer"><div>收集率<span class='sort_icon'></span></div></th>
                                    <th rowspan="2">本月提升</th>
                                    <th rowspan="2">全年提升</th>
                                    <th colspan="7">异网宽带收集情况</th>
                                    <th rowspan="2">录入进线<br/>运营商数</th>
                                    <th rowspan="2">统计进线<br/>运营商数</th>
                                </tr>
                                <tr>
                                    <th>异网总数</th>
                                    <th>移动</th>
                                    <th>占比</th>
                                    <th>联通</th>
                                    <th>占比</th>
                                    <th>广电</th>
                                    <th>其他</th>
                                </tr>
                            </table>
                        </div>
                        <div id="big_table_content_1" style="margin-right: 14px">
                            <table style="width: 100%" class="table1 tab1_other" id="table_head">
                                <tr>
                                    <th width="47" rowspan="2">序号</th>
                                    <th width="63" rowspan="2">地域</th>
                                    <th colspan="6">友商小区光网覆盖情况(个)</th>
                                    <th colspan="5">友商发展宽带用户数(个)</th>
                                    <th colspan="5">宽带市场份额(%)</th>
                                </tr>
                                <tr>
                                    <th width="73">小区总数(个)</th>
                                    <th width="91">友商光网覆盖<br/>小区总数</th>
                                    <th width="72">移动</th>
                                    <th width="72">联通</th>
                                    <th width="72">广电</th>
                                    <th width="72">其他</th>
                                    <th width="77">友商发展宽带总数</th>
                                    <th width="72">移动</th>
                                    <th width="72">联通</th>
                                    <th width="72">广电</th>
                                    <th width="72">其他</th>
                                    <th width="72">电信</th>
                                    <th width="72">移动</th>
                                    <th width="72">联通</th>
                                    <th width="72">广电</th>
                                    <th width="72">其他</th>
                                </tr>
                            </table>
                            <table style="width: 100%" class="table1 tab1_vill" id="table_head1">
                                <tr>
                                    <th width="47" rowspan="2">序号</th>
                                    <th width="63" rowspan="2">地域</th>
                                    <th colspan="4">友商小区光网覆盖情况(个)</th>
                                    <th colspan="5">友商发展宽带用户数(个)</th>
                                    <th colspan="5">宽带市场份额(%)</th>
                                </tr>
                                <tr>
                                    <th width="72">移动</th>
                                    <th width="72">联通</th>
                                    <th width="72">广电</th>
                                    <th width="72">其他</th>
                                    <th width="77">友商发展宽带总数</th>
                                    <th width="72">移动</th>
                                    <th width="72">联通</th>
                                    <th width="72">广电</th>
                                    <th width="72">其他</th>
                                    <th width="72">电信</th>
                                    <th width="72">移动</th>
                                    <th width="72">联通</th>
                                    <th width="72">广电</th>
                                    <th width="72">其他</th>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="t_body" id="big_table_info_div" style="overflow-y:scroll;">
                        <table cellspacing="0" cellpadding="0" class="table1" style="width: 100%">
                            <tbody id="big_tab_info_list">
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
var url4data = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_leader_tabs.jsp" />';
var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag, query_sort = '0', eaction = "collect_list";
//如果已经没有数据, 则不再次发起请求.
var hasMore = true;
var table_rows_array = "";
var table_rows_array_small_screen = [20,25,35];
var table_rows_array_big_screen = [30,40,50];

if(window.screen.height<=768){
    table_rows_array = table_rows_array_small_screen;
}else{
    table_rows_array = table_rows_array_big_screen;
}
$(function(){
	//账期
	$("#beginDate").datebox({
		onSelect : function(date){
 			var begin_tmp = $('#beginDate').datebox('getValue').replace(/-/g, "");
 			//初始化检索参数
			clear_dataBySelDay();
 			//重新加载数据
            load_list(0);
		}
	});
    //初始化账期日为前一天
	$("#beginDate").datebox("setValue",'${initTime}');

    $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 144 - $("#big_table_change").height() - $("#big_table_content").height());
    $(".t_body>table").width($(".table1:eq(0)").width()+2);
    set_query_flag();
    generate_head();
    generate_tab();
    default_select();

    var click_union_org_code = "";//记录上次点击过的支局id

    ///$(".panel-header").css({visibility:'hidden'})

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
});

$(function() {
	$("#big_table_collect_type > span").each(function (index) {
	    $(this).on("click", function () {
	        $(this).addClass("active").siblings().removeClass("active");
	        var $show_div = $("#big_table_content_" + index);
            //点击了竞争预警标签
            if(index==1){
                $("#big_tab_info_list").removeClass("body0_vill");
                if(query_flag=='5'){
                    $("#table_head").hide();
                    $("#table_head1").show();
                }else{
                    $("#table_head").show();
                    $("#table_head1").hide();
                }
            }else if(index==0){
                if(query_flag=='5'){
                    $("#table_head3").show();
                    $("#table_head2").hide();
                    $("#big_tab_info_list").addClass("body0_vill");
                }else{
                    $("#table_head3").hide();
                    $("#table_head2").show();
                    $("#big_tab_info_list").removeClass("body0_vill");
                }
            }
	        $show_div.show();
	        $("#big_table_content").children().not($show_div).hide();
	        var temp = flag;
	        clear_data();
	        flag = temp;
	        load_list(index);
	     });
	});
	$("#big_table_collect_type span").eq(0).click();
    $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 106 - $("#big_table_change").height() - $("#big_table_content").height());
})

//默认选中支局或是其他.
function default_select() {
    var index = query_flag  - global_current_flag;
    $("#collect_tabs_change > div").eq(index).click();
}

function generate_head() {
    var $head = $("#collect_tabs_change");
    var current_level = global_current_flag;
    var content = "";
    if (current_level == '1') {
        content += "<div onclick=\"change_region('1')\">市</div>" +
        "<div onclick=\"change_region('2')\">县</div>";
    } else if (current_level == '2') {
        content += "<div onclick=\"change_region('2')\">县</div>";
    }
    content += "<div onclick=\"change_region('3')\">支局</div>" +
    "<div onclick=\"change_region('4')\">网格</div>" +
    "<div onclick=\"change_region('5')\">小区</div>";
    $head.append(content);
}

function generate_tab(){
    if(query_flag == '1' || query_flag == '2' || query_flag == '3' || query_flag == '4'){
        $("#table_head").show();
        $("#table_head1").hide();
        $("#broad_home_tab_list").show();
        $("#broad_home_tab_list1").hide();
    }else if(query_flag == '5'){
        $("#table_head").hide();
        $("#table_head1").show();
        $("#broad_home_tab_list").hide();
        $("#broad_home_tab_list1").show();
    }
}

function set_query_flag() {
    if (global_region_type == 'city') {
        query_flag = '1';
    } else if (global_region_type == 'bureau') {
        query_flag = '2';
    } else if (global_region_type == 'sub') {
        query_flag = '3';
    } else if (global_region_type == 'grid') {
        query_flag = '4';
    } else if (global_region_type == 'village') {
        query_flag = '5';
    }
}

function query_list_sort() {
    var temp = query_flag;
    var temp2 = (query_sort == '0'  ? '1' : '0');
    clear_data();
    query_sort = temp2;
    query_flag = temp;
    load_list();
}

function load_list(typeIndex) {

	//账期
	var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
	//alert(beginDate);

    if (typeIndex == '0') {
        eaction = "collect_list"
    } else if (typeIndex == '1') {
        eaction = "collect_list_2"
    }

    var params = {
        eaction: eaction,
        beginDate:beginDate,
        flag: global_current_flag,
        page: 0,
        region_id: global_region_id,
        query_flag: query_flag,
        query_sort: query_sort,
        city_id: global_current_city_id,
        pageSize: table_rows_array[0]
    }
    listScroll(params, true, eaction);
}


$("#big_table_info_div").scroll(function () {
	//账期
	var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
    var viewH = $(this).height();
    var contentH = $(this).get(0).scrollHeight;
    var scrollTop = $(this).scrollTop();
    if (scrollTop / (contentH - viewH) >= 0.95) {
        if (new Date().getTime() - begin_scroll > 500) {
            var params = {
                eaction: eaction,
                beginDate:beginDate,
                page: ++page_list,
                flag: global_current_flag,
                region_id: global_region_id,
                query_flag: query_flag,
                query_sort: query_sort,
                city_id: global_current_city_id,
                pageSize: table_rows_array[0]
            }
            listScroll(params, false, eaction);
        }
        begin_scroll = new Date().getTime();
    }
});

function listScroll(params, flag, action) {
    if (action == "collect_list") {
        listOtherScroll(params, flag);
    } else if (action == "collect_list_2") {
        listCollectScroll(params, flag);
    }
}

function listOtherScroll(params, flag) {
    var $list = $("#big_tab_info_list");
    if (hasMore) {
        $.post(url4data, params, function (data) {
            data = $.parseJSON(data);
            if (data.length == 0 && flag) {
                $("#all_count").html('0');
            } else {
                $("#all_count").html(data[1].C_NUM);
            }
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td>" + (++seq_num) + "</td>";
                if (query_flag == '1') {
                    newRow += "<td style='text-align:center;'>" + d.AREA_DESC + "</td>"
                } else {
                    newRow += "<td style='text-align:left;'>" + d.AREA_DESC + "</td>"
                }
                if (query_flag == '5'){
                    newRow += "<td>" + d.SHOULD_COLLECT_CNT +
                    "</td><td>" + d.ALREADY_COLLECT_CNT + "</td><td>" + d.COLLECT_RATE +
                    "</td><td>" + d.OTHER_MON_RATE + "</td><td>" + d.OTHER_YEAR_RATE +
                    "</td><td>" + d.OTHER_BD_CNT + "</td><td>" + d.OTHER_CM_CNT +
                    "</td><td>" + d.MB_RATE + "</td><td>" + d.OTHER_CU_CNT +
                    "</td><td>" + d.MU_RATE + "</td><td>" + d.OTHER_SARFT_CNT +
                    "</td><td>" + d.OTHER_Y_CNT + "</td>";

                    if(d.AREA_DESC=="全省"){
                        newRow += "<td>--</td>";
                        newRow += "<td>--</td>";
                    }else{
                        newRow += "<td>"+coll_bus_cnt(d.OTHER_OPTICAL_FIBER, d.WIDEBAND_IN, d.CM_OPTICAL_FIBER, d.CU_OPTICAL_FIBER, d.SARFT_OPTICAL_FIBER)+"</td>";
                        newRow += "<td>"+buss_cnt(d.OTHER_CM_CNT, d.OTHER_CU_CNT, d.OTHER_SARFT_CNT, d.OTHER_Y_CNT)+"</td>";
                    }
                    newRow += "</tr>";
                }else{
                    newRow += "<td>" + d.SHOULD_COLLECT_CNT +
                    "</td><td>" + d.ALREADY_COLLECT_CNT + "</td><td>" + d.COLLECT_RATE +
                    "</td><td>" + d.OTHER_MON_RATE + "</td><td>" + d.OTHER_YEAR_RATE +
                    "</td><td>" + d.OTHER_BD_CNT + "</td><td>" + d.OTHER_CM_CNT +
                    "</td><td>" + d.MB_RATE + "</td><td>" + d.OTHER_CU_CNT +
                    "</td><td>" + d.MU_RATE + "</td><td>" + d.OTHER_SARFT_CNT +
                    "</td><td>" + d.OTHER_Y_CNT + "</td>"+
                    "</tr>";
                }
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
        });
    }
}

function listCollectScroll(params, flag) {
    var $list = $("#big_tab_info_list");
    if (hasMore) {
        $.post(url4data, params, function (data) {
            data = $.parseJSON(data);
            if (data.length == 0 && flag) {
                $("#all_count").html('0');
            } else {
                $("#all_count").html(data[1].C_NUM);
            }
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td style='width: 47px'>" + (++seq_num) + "</td>";
                if (query_flag == '1') {
                    newRow += "<td style='width: 63px;text-align:center;'>" + d.AREA_DESC + "</td>";
                } else if(query_flag=='5'){
                    newRow += "<td style='width: 63px;text-align:left;'>" + d.AREA_DESC + "</td>";
                } else{
                    newRow += "<td style='width: 63px;text-align:center;'>" + d.AREA_DESC + "</td>";
                }
                if(query_flag=='5'){
                    newRow += "<td style='width: 72px'>" + d.CMCC_KD_VILLAGE_CNT +
                    "</td><td style='width: 72px'>" + d.CUCC_KD_VILLAGE_CNT + "</td><td style='width: 72px'>" + d.CBN_KD_VILLAGE_CNT +
                    "</td><td style='width: 72px'>" + d.OTHER_KD_VILLAGE_CNT + "</td><td style='width: 77px'>" + d.OTHER_BD_CNT +
                    "</td><td style='width: 72px'>" + d.OTHER_CM_CNT + "</td><td style='width: 72px'>" + d.OTHER_CU_CNT +
                    "</td><td style='width: 72px'>" + d.OTHER_SARFT_CNT + "</td><td style='width: 72px'>" + d.OTHER_Y_CNT +
                    "</td><td style='width: 72px'>" + d.DX_MARKET_SHARE + "</td><td style='width: 72px'>" + d.CM_MARKET_SHARE +
                    "</td><td style='width: 72px'>" + d.CU_MARKET_SHARE + "</td><td style='width: 72px'>" + d.SARFT_MARKET_SHARE +
                    "</td><td style='width: 72px'>" + d.OTHER_MARKET_SHARE + "</td></tr>";
                }else{
                    newRow += "<td style='width: 73px'>" + d.VILLAGE_CNT + "</td>"+
                    "<td style='width: 91px'>" + d.OTHER_NET_KD_VILLAGE_CNT + "</td>"+
                    "<td style='width: 72px'>" + d.CMCC_KD_VILLAGE_CNT +
                    "</td><td style='width: 72px'>" + d.CUCC_KD_VILLAGE_CNT + "</td><td style='width: 72px'>" + d.CBN_KD_VILLAGE_CNT +
                    "</td><td style='width: 72px'>" + d.OTHER_KD_VILLAGE_CNT + "</td><td style='width: 77px'>" + d.OTHER_BD_CNT +
                    "</td><td style='width: 72px'>" + d.OTHER_CM_CNT + "</td><td style='width: 72px'>" + d.OTHER_CU_CNT +
                    "</td><td style='width: 72px'>" + d.OTHER_SARFT_CNT + "</td><td style='width: 72px'>" + d.OTHER_Y_CNT +
                    "</td><td style='width: 72px'>" + d.DX_MARKET_SHARE + "</td><td style='width: 72px'>" + d.CM_MARKET_SHARE +
                    "</td><td style='width: 72px'>" + d.CU_MARKET_SHARE + "</td><td style='width: 72px'>" + d.SARFT_MARKET_SHARE +
                    "</td><td style='width: 72px'>" + d.OTHER_MARKET_SHARE + "</td></tr>";
                }
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
        });
    }
}
function coll_bus_cnt(a,b,c,d,e){
    var i = 0;
    if(a>0) i++;
    if(b>0) i++;
    if(c>0) i++;
    if(d>0) i++;
    if(e>0) i++;
    return i;
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
    begin = 0, end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,
    flag = '1', query_sort = '0';
    $("#big_tab_info_list").empty();
}

//账期change时列表页面清空赋值
function clear_dataBySelDay() {
	begin = 0,end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,
	flag = '1', query_sort = '0';
	$("#big_tab_info_list").empty();
}

function change_region(type) {
	$(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
    clear_data();
    query_flag = type;
    $("#big_table_collect_type > span").eq(0).click();
}

//Excel文件下载
function doExcel() {
	   var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
	   var region;
	   if("1"==query_flag){
		   region = "市"
	   }else if("2"==query_flag){
		   region = "县"
	   }else if("3"==query_flag){
		   region = "支局"
	   }else if("4"==query_flag){
		   region = "网格"
	   }else if("5"==query_flag){
		   region = "小区"
	   }
	   var typeIndex;
	   var typeTxt;
	   if (eaction == 'collect_list') {
	        typeIndex= "0";
	        typeTxt= "竞争收集统计";
	        //typeTxt= "竞争对手光网进线情况";
	    } else if (eaction == 'collect_list_2') {
	        typeIndex= "1";
	        typeTxt= "竞争预警";
	    }

	   //下载的文件名称拼接
       var fileName = '竞争信息收集('+typeTxt+')_'+region +"_"+beginDate+'.xlsx';

	   var url = "<e:url value='collect_ExcelDownload.e?beginDate="+beginDate+"&flag="+flag+"&page="+0+"&region_id="+global_region_id+"&query_flag="+query_flag+"&query_sort="+query_sort+"&city_id="+global_current_city_id+"&typeIndex="+typeIndex+"&pageSize="+table_rows_array[0]+"'/>";
	   $.messager.progress({ // 显示进度条
          text: "导出中,请等待...",
          interval: 100
       });

    var is_success = '1';

    $.post(url, {}, function (data) {
        //生成操作日志
        var info = {};
        info.rpt_name = '竞争信息收集';
        info.exp_filename = fileName;
        info.exp_status = is_success;

        //用来传输相应的参数
        var postUrl = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_download_log.jsp'/>?eaction=insertLog";
        $.post(postUrl, info, function (data) {
        });
        $.messager.progress('close');//进度条关闭
    });

    var a = document.createElement('a');
    a.download = fileName;
    a.href = url + "&file=1";
    console.log(a.href);
    $("body").append(a);    // 修复firefox中无法触发click
    a.click();
    //$.messager.progress('close');//进度条关闭
    $(a).remove();

    return;

	   var xhr = new XMLHttpRequest();
	   //也可以使用POST方式，根据接口
	   xhr.open('POST', url, true);
	   //返回类型blob
	   xhr.responseType = "blob";
	   // 定义请求完成的处理函数，请求前也可以增加加载框/禁用下载按钮逻辑
	   xhr.onload = function () {
		    var is_success= '1';
	       // 请求完成
	       if (this.status === 200) {
	           // 返回200
	           var blob = this.response;
	           var reader = new FileReader();
	           reader.readAsDataURL(blob);    // 转换为base64，可以直接放入a表情href
	           reader.onload = function (e) {
	               // 转换完成，创建一个a标签用于下载
	               var a = document.createElement('a');
	               a.download = fileName;
	               a.href = e.target.result;
	               $("body").append(a);    // 修复firefox中无法触发click
	               a.click();
	               $(a).remove();
	           }
	           is_success= '1';
	       }else{
	    	   is_success= '0';
	       }
	       //生成操作日志
	       var info = {};
	       info.rpt_name ='竞争信息收集';
	       info.exp_filename = fileName;
	       info.exp_status = is_success;

	       //用来传输相应的参数
          var postUrl="<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_download_log.jsp'/>?eaction=insertLog";
          $.post(postUrl,info,function(data){
          });
	       $.messager.progress('close');//进度条关闭
	   };
	   // 发送ajax请求
	   xhr.send()
}
</script>