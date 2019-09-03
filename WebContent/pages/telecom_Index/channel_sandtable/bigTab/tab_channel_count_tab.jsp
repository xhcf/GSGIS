<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="acctDayobj">
    select to_char(to_date(const_value,'yyyymmdd'),'yyyy-mm-dd') ACCT_DAY from ${easy_user}.sys_const_table where const_type = 'var.dss31' AND data_type = 'day' AND model_id = '16'
</e:q4o>
<e:set var="initDay">${acctDayobj.ACCT_DAY}</e:set>
<e:q4o var="initEnDdate">
    select to_char(SYSDATE,'yyyy-mm-dd') val from ${channel_user}.TB_GIS_QD_COLLECT_INFO
</e:q4o>
<e:set var="initEndDay">${initEnDdate.val}</e:set>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>异网网点信息维护</title>
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
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/big_tab_reset.css?version=New Date()" />'  rel="stylesheet" type="text/css"
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
        .table1, .table1 th, .table1 td{
            border-color:#092e67;
        }
        #big_table_info_div {border-top: 1px solid #092e67;border-bottom: 1px solid #092e67;}
        #big_tab_info_list {border:0px;}
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
        .download_btn1 {
            background: url(icons/excel.png) no-repeat center left;
            /* position: absolute; */
            /* top: -30px; */
            /* height: 30px; */
            /* right: 150px; */
            color: #fff;
            /* padding-left: 20px; */
            /* top: 5px; */
            /* right: 25px; */
            float: right;
            margin-right: 10px;
        }
        /*2018.9.21 新样式*/
        .text-important {color:#00FFFF!important;}
        .text-important-a {color:#4CB9F9!important;}
        .area_select_bq a.selected, .line_select_bq a.selected{
            color:#ee7008!important;
        }
        /*数据列表表头*/
        #table_head th, #big_table_content th{background:none;}
        #table_head thead tr th{
            border:1px solid #333399;
            /* border-bottom-color:transparent; */
        }
        /*数据列表表体*/
        .table1 td {border-color:#333366;}

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
        /*表格位置*/
        .textbox.combo.datebox {border:1px solid #3E4997!important;}
        /*返回按钮*/
		.close_button {
		    position: absolute;
		    right: 26px;
		    top: 20px;
		    width: 25px;
		    height: 25px;
		    background: url("../sandbox_leader/images/back.png")no-repeat center/cover;
		    cursor: pointer;
    	}
    	.all_count{margin-top:11%;}
    	.win_title_tag {
            width: 100%;
            position:fixed;
            background: #05418b;
            height:40px;
            line-height:36px;
            top:0px;
        }
        .my-skin .layui-layer-content{width:100%;background: #fff;}
        .my-skin .layui-layer-btn{background: #fff;}
        /* .market_view .layui-layer-title{display: none;} */
        .area_select_bq a{margin-right:13px!important;font-size: 13px;}
        .download_btn1 a span{background: #3d8ccf!important;color: #FFFFFF;height: 27px;line-height: 27px;width: 50px;text-align: center;}
    	#tab_div .table1 tr td, #tab_div .table1 tr th{font-size: 13px;}
    	#big_tab_info_list tr td{line-height:28px;}
    	#table_head tr th{line-height:28px;}
    	.market_view .layui-layer-title{text-align: center;font-size: 20px;font-weight: bold;}
    	.tel_agent{background: transparent;border: 1px solid #3E4997!important;width: 140px;color:#fff;}
    	.tel_agent option{color:#000;}

    	/* 表格字体颜色#f7e1e1 灰白 */
        #import_tab tr th,#big_tab_info_list tr td,.search td,.search a,#beginDate,.big_table_title h4,.all_count,.textbox .textbox-text{color:#f7e1e1!important;}
        #import_tab tr th,#resident_detail_list0 tr td{line-height:28px;}

        @media screen and (max-height: 1080px){
        	/* .sub_b{height:105%;} */
            .t_body{height:76%;}
        }
        @media screen and (max-height: 768px){
        	/* .sub_b{height:98%;} */
            .t_body{height:63%;}
        }
        #bqfq_tj {display:none;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
<div class="close_button" id="closeTab"></div>
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>渠&nbsp;道&nbsp;份&nbsp;额&nbsp;统&nbsp;计</h4></div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search" style="background: transparent!important;">
                    <tr style="height:40px;">
                        <td class="search_head">
                            <span>账&emsp;&emsp;期：</span>
                        </td>
                        <td style="padding-left:8px;">
                            <c:datebox required='false' format='yyyy-mm-dd' name='acct_day' id='acct_day'  defaultValue='${initDay}'/>
                        </td>
                    </tr>
                    <tr style="height:40px;">
                        <td class="area_select_bq search_head" style="width:70px"><span>分&nbsp;&nbsp;公&nbsp;&nbsp;司:</span></td>
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

                            <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                                <div class="download_btn1" id ="download_div" style="top:5px;right:25px;display: none;"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                            </e:if>
                            <!-- <div class="download_btn1" style="top:5px;right:25px;background: transparent;">
                            	<a href="javascript:void(0)" onclick="query();"><span style ="color:#FFFFFF;">查询</span></a>
                            	<a href="javascript:void(0)" onclick="addRecord();"><span style ="color:#FFFFFF;">新增</span></a>
                            </div> -->
                        </td>
                    </tr>
                    <tr id="bqfq_tj" style="display: none">
                        <td class="area_select_bq" style="width: 70px"><span>&nbsp;&nbsp;区&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;县:</span></td>
                        <td>
                            <div class="line_select_bq">
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="all_count" style="font-size:13px;">总记录数：<span id="all_count"></span></div>
                <div class="sub_b">
                    <div style="padding-right:15px;background: none;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width:1870px;">
                            <thead>
                                        <tr>
                                            <th rowspan="2" style='width:1%'>序号</th>
                                            <th rowspan="2" id="org1" style='width:2%'>分公司</th>
                                            <th rowspan="2" id="org2" style='width:5%'>县局</th>
                                            <!--<th rowspan="2">网点总数</th>-->
                                            <th colspan="6" class="index_row1">电信网点</th>
                                            <th colspan="6" class="index_row1">移动网点</th>
                                            <th colspan="6" class="index_row1">联通网点</th>
                                        </tr>
                                        <tr>
                                            <!--电信-->
                                            <th class="index_row2_item1" style='width:3%'>网点数量</th>
                                            <th class="index_row2_item2" style='width:3%'>网点份额</th>
                                            <th class="index_row2_item3" style='width:3%'>核心厅店</th>
                                            <th class="index_row2_item4" style='width:3%'>城市商圈</th>
                                            <th class="index_row2_item5" style='width:3%'>城市社区</th>
                                            <th class="index_row2_item6" style='width:3%'>农村乡镇</th>

                                            <!--移动-->
                                            <th class="index_row2_item1" style='width:3%'>网点数量</th>
                                            <th class="index_row2_item2" style='width:3%'>网点份额</th>
                                            <th class="index_row2_item3" style='width:3%'>核心厅店</th>
                                            <th class="index_row2_item4" style='width:3%'>城市商圈</th>
                                            <th class="index_row2_item5" style='width:3%'>城市社区</th>
                                            <th class="index_row2_item6" style='width:3%'>农村乡镇</th>

                                            <!--联通-->
                                            <th class="index_row2_item1" style='width:3%'>网点数量</th>
                                            <th class="index_row2_item2" style='width:3%'>网点份额</th>
                                            <th class="index_row2_item3" style='width:3%'>核心厅店</th>
                                            <th class="index_row2_item4" style='width:3%'>城市商圈</th>
                                            <th class="index_row2_item5" style='width:3%'>城市社区</th>
                                            <th class="index_row2_item6" style='width:3%'>农村乡镇</th>
                                        </tr>
                                    </thead>
                        </table>
                    </div>
                    <div class="t_body" style="overflow-x:auto!important;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list" style="width:1870px;">
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
    var url4data = '<e:url value="pages/telecom_Index/channel_sandtable/bigTab/tab_channel_count_tabData.jsp" />';
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "list",acct_mon='';
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

    //if(city_id_temp=="")
    //city_id_temp = city_id_for_village_tab_view;
    city_id_temp ='999';
    //else
    //   city_id_for_village_tab_view = city_id_temp;
    if(user_level==2)
        city_id_temp = "${sessionScope.UserInfo.AREA_NO}";
    //如果已经没有数据, 则不再次发起请求.
    var hasMore = true;

    var init_tab_height = 0;
    var open_win_handler = "";

    var table_rows_array = "";
    var table_rows_array_small_screen = [25,35,45];
    var table_rows_array_big_screen = [35,45,55];

    if(window.screen.height<=768){
        table_rows_array = table_rows_array_small_screen;
    }else{
        table_rows_array = table_rows_array_big_screen;
    }
    //var long_message_width = 0;
    $(function(){
    	$("#org2").hide();
		$("#org1").addClass("org_name");
        init_tab_height = document.body.offsetHeight*0.94 +10 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();
        //long_message_width = $("#big_tab_info_list").width()*0.17;

        //var a=$('#acct_day').datebox('getValue').replace(/-/g, "");

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

        load_list();

        //日期控件
        $("#acct_day").datebox({
            onChange: function(date){
                query();
            }
        });
        //$("#acct_day").datebox('setValue','${initTime.VAL}');
        //$("#endacctday").datebox('setValue','${initTime.VAL}');

    });
        function addr_fmt(text){
	       var len = text.length;   //当前HTML对象text的长度
	       if(len>18){
	           var str="";
	           str=text.substring(0,17)+"...";  //使用字符串截取，获取前30个字符，多余的字符使用“......”代替
	           //$(this).html(str);                   //将替换的值赋值给当前对象
	           return str;
	       }else{
	    	   return text;
	       }
	    }
    //查询数据
    function query(){
        clear_data();
        load_list();
    }

    function query_list_sort() {
        var temp = query_flag;
        var temp2 = (query_sort == '0'  ? '1' : '0');
        clear_data();
        query_sort = temp2;
        query_flag = temp;
        load_list();
    }

    function initTabHeight(){
        init_tab_height = document.body.offsetHeight*0.94 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".all_count").height() - $("#table_head").height() -25;
        $(".t_body").css("max-height", init_tab_height);
    }

    function load_list() {
        var city_flag=false;
        if (city_id_temp=='999'){
            city_flag=true;
        }
        var acct_day = $("#acct_day").datebox("getValue").replace(/-/g,'');
        //var acct_endday = $("#acct_endday").datebox("getValue").replace(/-/g,'');
        //var tel_agent = $("#tel_agent").val();
        var params = getParams();/* {
            "latn_id":city_id_temp,
            "bureau_no":bureau_id_temp,
            "acct_day":acct_day,
            "eaction": eaction,
            "page": 0
        } */
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
                var acct_day = $("#acct_day").datebox("getValue").replace(/-/g,'');
                //var acct_endday = $("#acct_endday").datebox("getValue").replace(/-/g,'');
                var params = getParams();
                listScroll(params, false, eaction);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function listScroll(params, flag, action) {
        listCollectScroll(params, flag);
    }

    var okimg = '<e:url value="pages/telecom_Index/other_internet_manager/images/ok.png"/>';
    function html_img(value){
    	if(value == '是'){
    		return "<img src='"+okimg+"' style='width: 15px;height: 15px;'>";
    	}else{
    		return " ";
    		}
    }

    function listCollectScroll(params, flag) {
        var $list = $("#big_tab_info_list");
        if (hasMore) {
            $.post(url4data, params, function (data) {
                data = $.parseJSON(data);
            	if(page_list == 0){
                    if (data.length) {
                        $("#all_count").html(data[0].C_NUM);
                    } else {
                        $("#all_count").html('0');
                    }
                }

                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];

                    	var newRow = "<tr>";

                        newRow += "<td style='width:1%'>"+ (++seq_num) +"</td>";

                        if(params.flg=="1"){
                        	newRow += "<td class=\"org_name\" style='width:2%'>"+ d.REGION_NAME +"</td>";
                        }
                        if(params.flg=="2"){
                        	if(i==0)
                        		newRow += "<td class=\"org_name1\" colspan=2 >"+ d.REGION_NAME +"</td>";
                        	else{
                        		newRow += "<td class=\"org_name1\" style='width:2%'>"+ d.REGION_NAME +"</td>";
                        		newRow += "<td class=\"org_name2\" style='width:5%'>"+ d.BUREAU_NAME +"</td>";
                        	}
                        }

                        newRow += "<td class=\"index_row2_item1\" style='width:3%'>"+ d.DX_CNT +"</td>";
                        newRow += "<td class=\"index_row2_item2 orange\" style='width:3%;color: #ee7008!important;'>"+ d.DX_PERCENT +"</td>";
                        newRow += "<td class=\"index_row2_item3\" style='width:3%'>"+ d.DX_CNT1 +"</td>";
                        newRow += "<td class=\"index_row2_item4\" style='width:3%'>"+ d.DX_CNT2 +"</td>";
                        newRow += "<td class=\"index_row2_item5\" style='width:3%'>"+ d.DX_CNT3 +"</td>";
                        newRow += "<td class=\"index_row2_item6\" style='width:3%'>"+ d.DX_CNT4 +"</td>";

                        newRow += "<td class=\"index_row2_item1\" style='width:3%'>"+ d.YD_CNT +"</td>";
                        newRow += "<td class=\"index_row2_item2 orange\" style='width:3%;color: #ee7008!important;'>"+ d.YD_PERCENT +"</td>";
                        newRow += "<td class=\"index_row2_item3\" style='width:3%'>"+ d.YD_CNT1 +"</td>";
                        newRow += "<td class=\"index_row2_item4\" style='width:3%'>"+ d.YD_CNT2 +"</td>";
                        newRow += "<td class=\"index_row2_item5\" style='width:3%'>"+ d.YD_CNT3 +"</td>";
                        newRow += "<td class=\"index_row2_item6\" style='width:3%'>"+ d.YD_CNT4 +"</td>";

                        newRow += "<td class=\"index_row2_item1\" style='width:3%'>"+ d.LT_CNT +"</td>";
                        newRow += "<td class=\"index_row2_item2 orange\" style='width:3%;color: #ee7008!important;'>"+ d.LT_PERCENT +"</td>";
                        newRow += "<td class=\"index_row2_item3\" style='width:3%'>"+ d.LT_CNT1 +"</td>";
                        newRow += "<td class=\"index_row2_item4\" style='width:3%'>"+ d.LT_CNT2 +"</td>";
                        newRow += "<td class=\"index_row2_item5\" style='width:3%'>"+ d.LT_CNT3 +"</td>";
                        newRow += "<td class=\"index_row2_item6\" style='width:3%'>"+ d.LT_CNT4 +"</td>";

                        "</tr>";
                        $list.append(newRow);
                    }
                    //只有第一次加载没有数据的时候显示如下内容
                    if (data.length == 0 && flag) {
                        $list.empty();
                        $list.append("<tr><td style='text-align:center' colspan=21 >没有查询到数据</td></tr>")
                    }
            });
        }
    }

    function getParams(){
        var a = "";//,b = "";

        acct_day = $('#acct_day').datebox('getValue').replace(/-/g, "");

        var params = {};

        var flag = 1;
        var region_id = 999;

        //a = $("#org_hx_sel_1 option:selected").val();
        //b = $("#org_hx_sel_2 option:selected").val();

        if(city_id_temp==undefined)
        	city_id_temp = "";
        //if(b==undefined)
        //	b = "";

        //if(city_id_temp=="")
        //    city_id_temp = 999;

        /*if(b!=""){
            region_id = b;
            flag = 3;
        }else if(a!="" && a!="999"){
            region_id = a;
            flag = 2;
        }else if(a=="999"){
            region_id = a;
            flag = 1;
        }*/

        if(city_id_temp!="" && city_id_temp!="999"){
            flag = 2;
        }

        params.eaction = eaction;
        params.acct_day = acct_day;
        if(region_id=='999')
        	region_id = "";
        if(city_id_temp=='999')
        	city_id_temp = "";

        params.region_id = region_id;
        params.city_id = city_id_temp;

        params.flg = flag;
        params.page = page_list;
        params.pageSize = table_rows_array[0];
        return params;
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
            console.log("changeBureauSelect");
            citySelectCss(city_id_temp);
            $("#org2").show();
            $(".area_select_bq").children().css({"cursor":"default"});
            $(".area_select_bq").children().attr("disabled","disabled");
            changeBureauSelect(city_id_temp);
            $("#bqfq_tj").hide();
        }else{
            $("#bqfq_tj").hide();
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
    function citySwitch1(city_id){
        if(user_level>1)
            return;
        if(city_id=='999'){
            initTabHeight();
            document.getElementById("bqfq_tj").style.display="none";
        }else{
            $(".line_select_bq").empty();
            changeBureauSelect(city_id);
            $("#bqfq_tj").show();
        }
        citySelectCss(city_id);
        city_id_temp = city_id;

        bureau_id_temp='999';
        clear_data();
        load_list();
    }
    function citySwitch(city_id){
		var width = $("#resident_detail_list0").width();
	    if(user_level>1)
	        return;
	    city_id_temp = city_id;
	    citySelectCss(city_id);
	    city_id_temp = city_id;
	    clear_data();

	  	if(city_id!="999"){
	  		$("#org1").removeClass("org_name").addClass("org_name1");
	  		$("#org2").addClass("org_name2");
	  		$("#org2").show();
	  	}else{
	  		$("#org1").removeClass("org_name1").addClass("org_name");
	  		$("#org2").hide();
	  	}
	  	query();
	    //showTotal();
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

    //Excel文件下载
    function doExcel() {
        var beginDate = $('#acct_day').datebox('getValue').replace(/-/g, "");

        //下载的文件名称拼接
        var fileName = '白区反抢日报'+'_'+beginDate+'.xlsx';

        var url = "<e:url value='villageGrabByDay_ExcelDownload.e?beginDate="+beginDate+"&city_id="+city_id_temp+"&file=1'/>";
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
            info.rpt_name ='异网网点';
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