<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="now">
    SELECT to_char(to_date(const_value,'yyyymmdd'),'yyyy-mm-dd') val FROM easy_data.sys_const_table WHERE const_type = 'var.dss28' AND data_type = 'day'
</e:q4o>

<e:set var="initTime">${now.VAL}</e:set>
<e:if condition="${param.acctDate ne '' && param.acctDate !=null }">
    <e:set var="initTime">${param.acctDate}</e:set>
</e:if>
<e:description>地市</e:description>
<e:q4l var="areaList">
    select 999 CODE, '全省' TEXT, '0' city_order_num from dual
    union
    SELECT T.latn_id CODE, T.latn_name TEXT,city_order_num FROM  gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY city_order_num
</e:q4l>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>四类小区统计</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <%--秦智宏：新加下拉框js--%>
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.3"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=1.3.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="pages/telecom_Index/common/css/layer_win.css?version=1.4" />' rel="stylesheet" type="text/css" media="all" />
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
            .tab_box{margin-top:6px;}
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
            height: 32px;
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
        .search{border-color: #feffff;}
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
        #resident_detail_list0 td a {}
        .tab_scroll_x {
            width: 100%;
            overflow-x: scroll;
            overflow-y: hidden;
            border-right: solid 0px #092e67;
        }
        .textbox.combo.datebox {
            border: 1px solid #3E4997;margin-top:5px;
        }
        .search {
            background: #043572;
            width: 100%;
            color: #fff;
            border: 1px solid #1851a9;
        }
        .textbox-text {border: 1px solid #3E4997;}
        .search a {margin:0px;}
        #village_degree {width:100px;}

        .l-btn-left {margin-top:0px;}
        .l-btn-text {margin:0 10px;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>四&nbsp;类&nbsp;小&nbsp;区&nbsp;统&nbsp;计</h4></div>
        <table class="search">
            <tr>
                <td style="width:300px;">
                    <div style="color:#FFFFFF;margin-left: 28px;margin-top:3px;" class="databox_">
                        <span style ="font-size:14px;">账&emsp;&emsp;期：</span>
                        <%--<input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>--%>
                        <c:datebox id="acctDate" name="acctDate" required="true" format="yyyy-mm-dd" defaultValue='${initTime}'/>
                    </div>
                </td>
                <td>
                    <span>小区等级：</span>
                    <select id="village_degree" class="trans_condition" onchange="javascript:query();">
                        <option value="">全部</option>
                        <option value="1">省级</option>
                        <option value="2">市级</option>
                        <option value="3">县级</option>
                    </select>
                </td>
                <td style="text-align:right;padding-right:15px;">
                    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="pop_win()" style="width:80px;height:27px;">指标口径</a>
                </td>
            </tr>
        </table>


        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div id="big_table_change">
                    <div id="big_table_collect_type" class="inner_tab">

                    </div>
                </div>
                <div class="sub_b">
                    <div class="all_count" style="left:0px;">总记录数：<span id="all_count"></span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <!--<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>-->
                    </e:if>
                    <div class="tab_scroll_x">
                      <div id="big_table_content">
                        <div id="big_table_content_0" style="margin-right: 14px;display:block;">
                            <table cellspacing="0" cellpadding="0"  style="width:2560px;" id="four_type">
                                <thead>
                                <tr>
                                    <th rowspan="2">序号</th>
                                    <th rowspan="2">分公司</th>
                                    <th colspan="6">全部</th>
                                    <th colspan="6">急迫小区</th>
                                    <th colspan="6">紧迫小区</th>
                                    <th colspan="6">操心小区</th>
                                    <th colspan="6">平稳小区</th>
                                </tr>
                                <tr>
                                    <th>小区数量</th>
                                    <th>住户数</th>
                                    <th>光宽用户数</th>
                                    <th>渗透率</th>
                                    <th>流失用户</th>
                                    <th>占比</th>

                                    <th>小区数量</th>
                                    <th>住户数</th>
                                    <th>光宽用户数</th>
                                    <th>渗透率</th>
                                    <th>流失用户</th>
                                    <th>占比</th>

                                    <th>小区数量</th>
                                    <th>住户数</th>
                                    <th>光宽用户数</th>
                                    <th>渗透率</th>
                                    <th>流失用户</th>
                                    <th>占比</th>

                                    <th>小区数量</th>
                                    <th>住户数</th>
                                    <th>光宽用户数</th>
                                    <th>渗透率</th>
                                    <th>流失用户</th>
                                    <th>占比</th>

                                    <th>小区数量</th>
                                    <th>住户数</th>
                                    <th>光宽用户数</th>
                                    <th>渗透率</th>
                                    <th>流失用户</th>
                                    <th>占比</th>

                                </tr>
                                </thead>
                            </table>
                        </div>

                      </div>
                      <div class="t_body" id="big_table_info_div0" style="overflow-y:scroll;display:block;width:2580px;">
                        <table cellspacing="0" cellpadding="0"  style="width: 2560px">
                            <tbody id="resident_detail_list0" class="count">
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
    var areaJSON=${e:java2json(areaList.list)};
    var roleName='';
    var curr_time = new Date();
    var url4data_list = '<e:url value="/pages/telecom_Index/common/sql/pointAnalyze_action.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, eaction = "region_data_list",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '${param.branch_id}';
    var grid_id_temp = '${param.grid_id}';

    var beginDate = "";
    var village_degree = "";

    if(city_id_temp==""){
        city_id_temp ='999';
    }
    // else{
    //     city_id_for_village_tab_view = city_id_temp;
    // }

    //如果已经没有数据, 则不再次发起请求.
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
        $('#acctDate').datebox({
            onChange: function(date){
                query();
            }
        });
        query();

        $(".tab_scroll_x").height(document.body.offsetHeight*0.94-$(".big_table_title").height()-$(".search").height()-$(".all_count").height()-30);

        init_tab_height = $(".tab_scroll_x").height() - $("#four_type").height() - 18;
        initTabHeight_province();
        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('#big_table_info_div0').scroll(function () {
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

    //日期控件
    $("#acctDate").datebox({
        onChange: function(date){
            clear_data();
            listCollectScroll(true);
        }
    });

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

    function listCollectScroll(flag) {
        var params = getParams();
        var $list = $("#resident_detail_list0");

        $.post(url4data_list, params, function (data) {
            data = $.parseJSON(data);
            /*if(data.length)
                $("#download_div").show();
            else
                $("#download_div").hide();*/
            if(page==0){
                if(data.length)
                    $("#all_count").html(data[0].C_NUM);
                else
                    $("#all_count").html('0');
            }

            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "";

                if(d.LATN_NAME == '全省'){
                    newRow = "<tr style=\"background-color:#043572 \"><td>" + (++seq_num) + "</td>";
                }else {
                    newRow = "<tr><td>" + (++seq_num) + "</td>";
                }
                newRow += "<td style='text-align:center;'>" + d.LATN_NAME + "</td>";
                if(d.VILLAGE_COUNT0)
                    newRow += "<td><a onclick=\"getRowData(this,'')\">" + d.VILLAGE_COUNT0 + "</a></td>";
                else
                    newRow += "<td>" + d.VILLAGE_COUNT0 + "</td>";

                newRow += "<td>" + d.GZ_ZHU_HU_COUNT0 + "</td>" +
                "<td>" + d.GZ_H_USE_CNT0 + "</td>" +
                "<td>" + d.MARKT_LV0 + "</td>" +
                "<td>" + d.LOST_COUNT0 + "</td>" +
                "<td>" + d.LOST_ZB0 + "</td>";

                if(d.VILLAGE_COUNT1)
                    newRow += "<td><a onclick=\"getRowData(this,'1')\">" + d.VILLAGE_COUNT1 + "</a></td>";
                else
                    newRow += "<td>" + d.VILLAGE_COUNT1 + "</td>";

                newRow += "<td>" + d.GZ_ZHU_HU_COUNT1 + "</td>" +
                "<td>" + d.GZ_H_USE_CNT1 + "</td>" +
                "<td>" + d.MARKT_LV1 + "</td>" +
                "<td>" + d.LOST_COUNT1 + "</td>" +
                "<td>" + d.LOST_ZB1 + "</td>";

                if(d.VILLAGE_COUNT2)
                    newRow += "<td><a onclick=\"getRowData(this,'2')\">" + d.VILLAGE_COUNT2 + "</a></td>";
                else
                    newRow += "<td>" + d.VILLAGE_COUNT2 + "</td>";

                newRow += "<td>" + d.GZ_ZHU_HU_COUNT2 + "</td>" +
                "</td><td>" + d.GZ_H_USE_CNT2 + "</td>" +
                "</td><td>" + d.MARKT_LV2 + "</td>" +
                "</td><td>" + d.LOST_COUNT2 + "</td>" +
                "</td><td>" + d.LOST_ZB2 + "</td>";

                if(d.VILLAGE_COUNT3)
                    newRow += "<td><a onclick=\"getRowData(this,'3')\">" + d.VILLAGE_COUNT3 + "</a></td>";
                else
                    newRow += "<td>" + d.VILLAGE_COUNT3 + "</td>";

                newRow += "<td>" + d.GZ_ZHU_HU_COUNT3 + "</td>" +
                "</td><td>" + d.GZ_H_USE_CNT3 + "</td>" +
                "</td><td>" + d.MARKT_LV3 + "</td>" +
                "</td><td>" + d.LOST_COUNT3 + "</td>" +
                "</td><td>" + d.LOST_ZB3 + "</td>";

                if(d.VILLAGE_COUNT4)
                    newRow += "<td><a onclick=\"getRowData(this,'4')\">" + d.VILLAGE_COUNT4 + "</a></td>";
                else
                    newRow += "<td>" + d.VILLAGE_COUNT4 + "</td>";

                newRow += "<td>" + d.GZ_ZHU_HU_COUNT4 + "</td>" +
                "</td><td>" + d.GZ_H_USE_CNT4 + "</td>" +
                "</td><td>" + d.MARKT_LV4 + "</td>" +
                "</td><td>" + d.LOST_COUNT4+ "</td>" +
                "</td><td>" + d.LOST_ZB4 + "</td>";

                newRow += "</tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=32 >没有查询到数据</td></tr>")
            }
        });
    }

    function getParams(){
        beginDate = $('#acctDate').datebox('getValue').replace(/-/g, "");
        village_degree = $("#village_degree option:selected").val();
        return {
            "eaction": eaction,
            "beginDate": beginDate,
            "village_degree": village_degree,
            "latn_id": "${sessionScope.UserInfo.AREA_NO}",
            "page": page,
            "pageSize": table_rows_array[0]
        };
    }

    function getRowData(obj,village_type){
        var acctDate = $('#acctDate').datebox('getValue');
        var values='';
        var rowArray = $(obj).parent().parent().find("td");
        var rowName = rowArray.eq(1).text();
        for(var i=0;i<areaJSON.length;i++){
            var text = areaJSON[i].TEXT;
            if(text == rowName){
                values=areaJSON[i].CODE;
            }
        }
        load_list_view2(values,village_type,acctDate,village_degree);
        <%--window.open('<e:url value='pages/telecom_Index/data_four_type_region_detail/four_type_region_detail_framework.jsp'/>?'--%>
            <%--+"city_id="+values--%>
            <%--+"&village_type="+village_type--%>
            <%--+"&beginDate="+acctDate--%>
            <%--+"&level=2"--%>
        <%--);--%>
    }

    var width = document.body.clientWidth * 0.6;
    var height = 470;//document.body.clientHeight * 0.75;
    var pop_win_handler = "";
    //弹窗
    function pop_win(){
        layer.close(pop_win_handler);
        pop_win_handler = layer.open({
            title: "指标口径",
            //maxmin: true, //开启最大化最小化按钮
            type: 2,
            shade: 0,
            area: [width,height],
            content: '<e:url value="/pages/telecom_Index/data_four_type_region/kpi_content.jsp" />',
            skin: 'win_add4_repair',
            cancel: function (index) {
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

    $("#collect_tabs_change > div").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    })

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page = 0;
        $("#all_count").text("");
        $("#resident_detail_list0").empty();
        $("#download_div").hide();
    }
    function backup(level){
        initListDiv(1);
    }

</script>