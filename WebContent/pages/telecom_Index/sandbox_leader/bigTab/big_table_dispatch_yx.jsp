<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
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
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '1'
</e:q4o>
<e:q4o var="acct_yesterday">
    select to_char(sysdate,'yyyy-mm') val,to_char(sysdate,'yyyy-mm-dd') val1 from dual
</e:q4o>
<e:set var="initMonth">${acct_yesterday.val}</e:set>
<e:set var="initTime">${acct_yesterday.VAL1}</e:set>
<e:q4l var="mkt_list">
    select ' ' mkt_id,'全部' mkt_name,0 ord from dual
    union all
    SELECT mkt_id,mkt_name,ord FROM
    <e:description>
        edw.tb_dim_send_market@gsedw
    </e:description>
    ${gis_user}.tb_dic_gis_market_type
    where mkt_id <> '999'
    order by ord
</e:q4l>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>宽带覆盖情况--省级用户</title>
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
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.1" />'  rel="stylesheet" type="text/css"
          media="all">
    <style>
        .search{border-color:#1851a9;}
        .table1, .table1 th, .table1 td{
            border-color:#12489a;
        }
        #mkt_scene_select {line-height:24px!important;height:24px!important;}
    </style>
</head>
<body>
<div class="sub_box">
    <div class="close_button" id="closeTab"></div>
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>精&nbsp;准&nbsp;派&nbsp;单&nbsp;营&nbsp;销</h4></div>
        <div style="color:#FFFFFF; width:400px" class="databox_">
            <span style ="font-weight:700;font-size:14px;">账&nbsp;&nbsp;&nbsp;&nbsp;期：</span>
            <div id ="date_div">
                <input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
            </div>
            <div id ="month_div">
                <input id="selectMonth" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
            </div>
        </div>
        <div class="tabs_change" id="collect_tabs_change">
        </div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div id="big_table_change">
                    <div id="big_table_marketing_dateType" class="inner_tab">
                        <span class="active" onclick="change_date_type('0')">精准营销(日)</span>|<span onclick="change_date_type('1')">精准营销(月)</span><br/>
                    </div>
                    <div id="big_table_marketing_sceneType" class="inner_tab">
                        场景：<select id="mkt_scene_select"></select>
                        <!--<span class="active" onclick="change_scene_type('')">全部</span>|<span onclick="change_scene_type('10')">单转融</span>|<span onclick="change_scene_type('11')">宽带续约</span>|<span onclick="change_scene_type('12')">沉默唤醒</span>-->
                    </div>
                </div>
                <div class="sub_b">
                    <div class="all_count right">总记录数：<span id="all_count"></span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </e:if>
                    <div style="margin-right: 14px">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                            <tr>
                                <th width="50" rowspan="2">序号</th>
                                <th width="100" rowspan="2">地域</th>
                                <th width="75" rowspan="2">派单数</th>
                                <th width="300" colspan="4">当日</th>
                                <th width="300" colspan="4">当月</th>
                            </tr>
                            <tr>
                                <th width="75">执行数</th>
                                <th width="75">执行率</th>
                                <th width="75">成功用户</th>
                                <th width="75">成功率</th>

                                <th width="75">执行数</th>
                                <th width="75">执行率</th>
                                <th width="75">成功用户</th>
                                <th width="75">成功率</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="broad_home_table" style="overflow-y:scroll;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="broad_home_tab_list" style="width: 100%;">
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
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, dateType = '0', sceneType = '',
            query_flag, query_sort = '0';
    //如果已经没有数据, 则不再次发起请求.
    var table_rows_array = "";
    var table_rows_array_small_screen = [20,25,35];
    var table_rows_array_big_screen = [35,45,55];
    //初始化月切换不出发数据检索
    if(window.screen.height<=768){
        table_rows_array = table_rows_array_small_screen;
    }else{
        table_rows_array = table_rows_array_big_screen;
    }
    $(function(){
        //初始化场景下拉选框
        var mkt_scene_list = ${e:java2json(mkt_list.list)};
        for(var i = 0,l = mkt_scene_list.length;i<l;i++){
            var scene = mkt_scene_list[i];
            var opt = "<option value='"+scene.MKT_ID+"'>"+scene.MKT_NAME+"</option>";
            $("#mkt_scene_select").append(opt);
        }
        $("#mkt_scene_select").bind("change",function(){
            var value = $.trim($("#mkt_scene_select option:selected").val());
            change_scene_type(value);
        });

        //账期
        $("#beginDate").datebox({
            onSelect : function(date){
                var begin_tmp = $('#beginDate').datebox('getValue').replace(/-/g, "");
                //初始化检索参数
                clear_dataBySelDay();
                //重新加载数据
                listScroll(true);
            }
        });
        //初始化账期日为前一天
        $("#beginDate").datebox("setValue",'${initTime}');

        //检索月
        var db = $('#selectMonth');
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

        $("#selectMonth").datebox({
            onChange: function(date){
                acct_mon = date;
                acct_mon = acct_mon.replace(/-/g,'');
                console.log(acct_mon);
                //初始化检索参数
                clear_dataBySelDay();
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
            var date = '${initMonth}';
            var date_arry = date.split("-");
            var year = date_arry[0];
            var mm = date_arry[1];
            db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
        }

        $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 132 - $("#big_table_change").height() - $("#big_table_content").height());
        //$(".t_body>table").width($(".table1:eq(0)").width()+2);

        set_query_flag();
        generate_head();
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
        $("#closeTab").on("click", function () {
            load_map_view();
            $("div[id^='mask_div']").remove();
        });

        //日期控件
        document.getElementById("month_div").style.display="none";
        //月份控件
        document.getElementById("date_div").style.display="inline";
        $("#big_table_marketing_dateType").hide();
        //change_date_type(0);
    });

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
        listScroll(true);
    }

    function change_date_type(type) {
        dateType = type;
        //$("#big_table_marketing_sceneType > span").eq(0).click();
        $("#mkt_scene_select").trigger("change");
        if('0'==type){
            //日期控件
            document.getElementById("month_div").style.display="none";
            //月份控件
            document.getElementById("date_div").style.display="inline";
        }else if('1'==type){
            //日期控件
            document.getElementById("month_div").style.display="inline";
            //月份控件
            document.getElementById("date_div").style.display="none";
        }
    }

    function change_scene_type(type) {
        var temp1 = dateType;
        var temp2 = query_flag;
        clear_data();
        sceneType = type;
        dateType = temp1;
        query_flag = temp2;
        listScroll(true);
    }

    function getParams(){
        //账期日
        var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
        //账期月
        ///var beginMonth = $('#selectMonth').datebox('getValue').replace(/-/g, "");
        var beginMonth = beginDate.substr(0,6);
        return {
            eaction: 'marketing_list',
            beginDate:beginDate,
            beginMonth:beginMonth,
            flag: global_current_flag,
            page: page_list,
            region_id: global_region_id,
            query_flag: query_flag,
            query_sort: query_sort,
            dateType: dateType,
            scene_id: sceneType,
            city_id: global_current_city_id,
            acct_month: '${last_month.VAL}',
            pageSize: table_rows_array[0]
        };
    }

    $("#broad_home_table").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                ++page_list;
                listScroll(false);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function listScroll(flag) {
        var params = getParams();
        var $list = $("#broad_home_tab_list");
        $.post(url4data, params, function (data) {
            data = $.parseJSON(data);
            if(page_list==0){
                if (data.length>1) {
                    $("#all_count").html(data[1].C_NUM);
                } else {
                    $("#all_count").html('0');
                }
            }
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td>" + (++seq_num) + "</td>";
                if (query_flag == '1') {
                    newRow += "<td style='text-align:center;'>" + d.AREA_DESC + "</td>"
                } else {
                    newRow += "<td style='text-align:left;'>" + d.AREA_DESC + "</td>"
                }
                newRow += "<td>" + d.MBYH_CNT + "</td>"+
                "<td>" + d.ZX_CNT + "</td>"+
                "<td>" + d.ZX_RATE +"</td>"+
                "<td>" + d.CGYH_CNT + "</td>"+
                "<td>" + d.CG_RATE +"</td>"+
                "<td>" + d.ZX_CNT_MONTH + "</td>"+
                "<td>" + d.ZX_RATE_MONTH +"</td>"+
                "<td>" + d.CGYH_CNT_MONTH + "</td>"+
                "<td>" + d.CG_RATE_MONTH +"</td>"+
                "</tr>";

                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=10 >没有查询到数据</td></tr>")
            }
        });
    }

    //改变选中市区县颜色
    $("#collect_tabs_change > div, #big_table_marketing_dateType > span, #big_table_marketing_sceneType > span").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    })

    function clear_data() {
        begin = 0,end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,//query_flag = global_current_flag,
                query_sort = '0';
        $("#broad_home_tab_list").empty();
    }

    //账期change时列表页面清空赋值
    function clear_dataBySelDay() {
        begin = 0,end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,//query_flag = global_current_flag,
                query_sort = '0';
        $("#broad_home_tab_list").empty();
    }

    function change_region(type) {
        $(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
        clear_data();
        query_flag = type;
        listScroll(true);
        //$("#big_table_marketing_dateType > span").eq(0).click();
    }

    //Excel文件下载
    function doExcel() {
        var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
        //账期月
        var beginMonth = $('#selectMonth').datebox('getValue').replace(/-/g, "");

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

        var sceneTypeTxt;
        /*if(""==sceneType){
            sceneTypeTxt ="全部";
        }else if("10"==sceneType){
            sceneTypeTxt ="单转融";
        }else if("11"==sceneType){
            sceneTypeTxt ="宽带续约";
        }else if("12"==sceneType){
            sceneTypeTxt ="沉默唤醒";
        }*/
        sceneTypeTxt = $("#mkt_scene_select option:selected").text();

        //下载的文件名称拼接
        var fileName;
        if(dateType==1){
            fileName = '精准派单营销(月)_'+sceneTypeTxt+'_'+region +"_"+beginMonth+'.xlsx';
        }else{
            fileName = '精准派单营销(日)_'+sceneTypeTxt+'_'+region +"_"+beginDate+'.xlsx';
        }

        //
        var last_month  = '${last_month.VAL}';
        var url = "<e:url value='dispatch_yx_ExcelDownload.e?beginDate="+beginDate+"&beginMonth="+beginMonth+"&flag="+flag+"&page="+0+"&region_id="+global_region_id+"&query_flag="+query_flag+"&query_sort="+query_sort+"&dateType="+dateType+"&scene_id="+sceneType+"&city_id="+global_current_city_id+"&acct_month="+last_month+"&pageSize="+table_rows_array[0]+"'/>";
        $.messager.progress({ // 显示进度条
            text: "导出中,请等待...",
            interval: 100
        });
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

            if(dateType==1){
                info.rpt_name ='精准派单营销(月)';
            }else{
                info.rpt_name ='精准派单营销(日)';
            }

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