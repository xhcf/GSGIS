<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="initTime">
    select to_char(to_date(MIN(const_value),'yyyymmdd'),'yyyy-mm-dd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '7'
</e:q4o>
<e:q4o var="now">
    select to_char(sysdate,'yyyy-mm-dd') val from dual
</e:q4o>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>农村行政资料查询</title>
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
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab_reset.css?version=1.1.1" />'  rel="stylesheet" type="text/css"
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
        .search_head span,.line_select_bq span{
            background: none!important;
        }
        #download_div {display:none;}
        #table_head tr:first-child th:first-child{width:3%!important;}
        #table_head tr:first-child th:nth-child(2){width:35%!important;}
        #table_head tr:first-child th:nth-child(3){width:20%!important;}
        #table_head tr:first-child th:nth-child(4){width:15%!important;}
        #table_head tr:first-child th:nth-child(5){width:10%!important;}
        #table_head tr:first-child th:nth-child(6){width:10%!important;}
        #table_head tr:first-child th:nth-child(7){width:7%;}

        #resident_detail_list tr td:first-child {width:3%!important;}
        #resident_detail_list tr td:nth-child(2) {width:35%!important;}
        #resident_detail_list tr td:nth-child(3) {width:20%!important;}
        #resident_detail_list tr td:nth-child(4) {width:15%!important;}
        #resident_detail_list tr td:nth-child(5) {width:10%!important;}
        #resident_detail_list tr td:nth-child(6) {width:10%!important;}
        #resident_detail_list tr td:nth-child(7) {width:7%!important;}

        .table1 tbody tr td:nth-child(4){min-width: 0px!important;}
        .zj_condition div {display:inline-block;margin-right:36px;}

        .panel-body {background:#fff;}
        .textbox {background:none;}
        .textbox combo {border:1px solid #fff;}
        #branch_select,#village_select {background:none;color:#aaa;}
        .textbox-addon {right:-8px!important;}
        #big_table_info_div {overflow-y:scroll;}
        .download_btn {top:20px;}
        select {line-height:25px!important;height:25px!important;}
        input {line-height:25px!important;height:25px!important;}
        #total_num {color:red;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>农村行政资料查询</h4></div>
        <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">

        </e:if>
        <!--<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>-->
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search">
                    <tr style="display: none;">
                        <td class="search_head"><span>帐&nbsp;&nbsp;&nbsp;&nbsp;期:</span></td></td>
                        <td style="padding-left:8px;" colspan="6"><input id="acctday" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;" /></td>
                    </tr>
                    <tr>
                        <td class="area_select_bq search_head" style="width:100px"><span style="text-align:right;">分公司：</span></td>
                        <td class="area_select_bq">
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
                    <tr id="bqfq_tj" style="">
                        <td class="area_select_bq" style="width: 100px"><span style="text-align:right;">分局：</span></td>
                        <td>
                            <div class="line_select_bq">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="org_type" id="small_org" />划小架构</td>
                        <td>
                            <div class="line_select_bureau">
                                县局：<select id="bureau_select" class="trans_condition" onchange="bureauSwitch()" style="width: 200px;"></select>
                            </div>
                            <div class="line_select_branch">
                                支局：<select id="branch_select" class="trans_condition" onchange="branchSwitch()" style="width: 200px;"></select>
                            </div>
                            <div class="line_select_grid">
                                网格：<select id="grid_select" class="trans_condition" onchange="gridSwitch()" style="width: 200px;"></select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="org_type" id="adm_org" />行政架构</td>
                        <td>
                            <div class="line_select_bureau">
                                县区：<select id="bureau1_select" class="trans_condition" onchange="bureau1Switch()" style="width: 200px;"></select>
                            </div>
                            <div class="line_select_branch">
                                乡镇：<select id="town_select" class="trans_condition" onchange="townSwitch()" style="width: 200px;"></select>
                            </div>
                            <div class="line_select_grid">
                                行政村：<select id="village1_select" class="trans_condition" onchange="village1Switch()" style="width: 200px;"></select>
                            </div>
                            <div class="line_select_grid">
                                社：<select id="community_select" class="trans_condition" onchange="communitySwitch()" style="width: 200px;"></select>
                            </div>
                            <input type="button" value="查询" onclick="query()" class="zj_submit"/>
                            <input type="button" value="导出" onclick="doExcel()" class="zj_submit" id ="download_div" style="margin-left:15px;" />
                        </td>
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
                    <div style="padding-right:15px;background: none;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th rowspan="2">序号</th>
                                    <th rowspan="2">分公司</th>
                                    <th colspan="3">划小架构</th>
                                    <th colspan="4">行政架构</th>
                                </tr>
                                <tr>


                                    <th>用户名称</th>
                                    <th>宽带接入号</th>
                                    <th>拆停日期</th>
                                    <th>拆停时长</th>
                                    <th>状态</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="big_table_info_div">
                        <table cellspacing="0" cellpadding="0" class="table1" id="resident_detail_list" style="width: 100%;">
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
    var url4data_list = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_lost_resident_list_action.jsp" />';
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag=2, query_sort = '0', eaction = "get_lost_resident_list",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '';
    var village_id_temp = '';
    var build_id_temp = '';
    var user_level = '${sessionScope.UserInfo.LEVEL}';

    var fgl = 'all';
    var stl = 'all';
    var jzcd_flag = '';
    var villageMode_flag = '';
    var portLv_flag = '';
    var line_flag = '';

    if(city_id_temp=="")
    //city_id_temp = city_id_for_village_tab_view;
        city_id_temp ='931';
    else
        city_id_for_village_tab_view = city_id_temp;
    //如果已经没有数据, 则不再次发起请求.
    var hasMore = true;

    var init_tab_height = 0;

    //var long_message_width = 0;
    $(function(){
        //表格高度
        init_tab_height = document.body.offsetHeight*0.94 - 93 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();
        //long_message_width = $("#resident_detail_list").width()*0.17;

        //var a=$('#acctday').datebox('getValue').replace(/-/g, "");

        initCitySelect(user_level);
        citySelectCss(city_id_temp);

        changeBureauSelect(city_id_temp);

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

        //load_list();

        //日期控件
        /*$("#acctday").datebox({
            onChange: function(date){
                acct_mon = date;
                acct_mon = acct_mon.replace(/-/g,'');
                clear_data();
                load_list();
            }
        });
        $("#acctday").datebox('setValue','${initTime.VAL}');*/
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
        if(village_id_temp=="")
            return;
        var city_flag=false;
        if (city_id_temp=='999'){
            city_flag=true;
        }
        if(build_id_temp=="undefined")
            build_id_temp = "";
        var params = {
            "latn_id":city_id_temp,
            "bureau_no":bureau_id_temp,
            "branch_no":branch_id_temp,
            "village_id":village_id_temp,
            "build_id":build_id_temp,
            "eaction": eaction,
            "page": 0
        }
        listScroll(params, true, eaction);
    }
    function query(){
        clear_data();
        load_list();
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
                    "branch_no":branch_id_temp,
                    "village_id":village_id_temp,
                    "build_id":build_id_temp,
                    "eaction": eaction,
                    "page": ++page_list
                }
                if(total_num<=seq_num)
                    listScroll(params, false, eaction);
                else
                    listScroll(params, true, eaction);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function listScroll(params, flag, action) {
        listCollectScroll(params, flag);
    }

    var total_num = 0;
    function listCollectScroll(params, flag) {
        var $list = $("#resident_detail_list");
        if (hasMore) {
            $.post(url4data_list, params, function (data) {
                data = $.parseJSON(data);
                if(data.length)
                    $("#download_div").show();
                else
                    $("#download_div").hide();
                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    if(i==0){
                        total_num = d.C_NUM;
                        $("#total_num").text(d.C_NUM);
                    }
                    var newRow = "<tr><td>" + (++seq_num) + "</td>";//序号
                    newRow += "<td class='text-left'>" + d.STAND_NAME + "</td>"//6级地址名称
                    newRow +=
                        "<td class='text-left'>" + d.USER_CONTACT_PERSON +//用户名称
                        "</td><td class='text-left'>" + d.ACC_NBR +//宽带接入号
                        "</td><td class='text-center'>" + d.REMOVE_DATE +//拆停日期
                        "</td><td class='text-center'>" + d.OWE_DUR +//拆停时长
                        "</td><td class='text-center'>" + d.SCENE_TEXT +//状态

                        "</td></tr>";
                    $list.append(newRow);
                }
                //只有第一次加载没有数据的时候显示如下内容
                if (total_num == 0) {
                    hasMore = false;
                    if (flag) {
                        $list.empty();
                        $list.append("<tr><td style='text-align:center' colspan=11 >没有查询到数据</td></tr>")
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
        $("#total_num").text("");
        $("#resident_detail_list").empty();
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
            console.log("changeBureauSelect");
            //initTabHeight_city();
            $(".area_select_bq").children().css({"cursor":"default"});
            $(".area_select_bq").children().attr("disabled","disabled");
            changeBureauSelect(city_id_temp);
            $("#bqfq_tj").show();
        }
    }
    function citySelectCss(city_id_temp){
        $(".area_select_bq a[onclick='citySwitch("+city_id_temp+")']").addClass("selected");
        $(".area_select_bq a[onclick='citySwitch("+city_id_temp+")']").siblings().removeClass("selected");
    }
    function bureauSelectCss(bureau_id){
        bureau_id_temp = bureau_id;
        console.log("bureauSelectCss");
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
            console.log("bureau_no_first:"+bureau_no_first);
            console.log("bureau_id_temp:"+bureau_id_temp);
            if(bureau_id_temp=="")
                bureau_id_temp = bureau_no_first;
            bureauSelectCss(bureau_id_temp);
            changeBranchSelect(bureau_id_temp);

            //changeVillageSelect(bureau_no_first);
            changeBuildSelect();
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

            branch_id_temp = $("#branch_select option:selected").val();
            changeVillageSelect(branch_id_temp);
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
            villageSwitch();
        });
    }
    function changeBuildSelect(){
        $("#build_select").empty();
        /*$.post(url4data,{"eaction":"getBuildIdByRegionId","village_id":village_id_temp},function(data){
            var build_json = $.parseJSON(data);
            for(var i = 0,l = build_json.length;i<l;i++){
                var build_item = build_json[i];
                if(i==0)
                    $("#build_select").append("<option value='"+build_item.SEGM_ID+"'>"+build_item.STAND_NAME+"</option>");
                else
                    $("#build_select").append("<option selected='selected' value='"+build_item.SEGM_ID+"'>"+build_item.STAND_NAME+"</option>");
            }
        });*/
        $('#build_select').combobox(
            {
                url:url4data+"?eaction=getBuildIdByRegionId&village_id="+village_id_temp,
                valueField:'SEGM_ID',
                textField:'STAND_NAME',
                multiple:true,
                onChange:function(newValue, oldValue){
                    var build_id_temp1 = $("#build_select").combobox("getValues");
                    if(build_id_temp1=="undefined")
                        build_id_temp= "";
                    build_id_temp = build_id_temp1.join(",")
                    console.log("build_id_temp:"+build_id_temp);
                    //clear_data();
                    //load_list();
                }
            }
        );
    }

    function citySwitch(city_id){
        if(user_level>1)
            return;
        if(city_id=='999'){
            initTabHeight_province();
            document.getElementById("bqfq_tj").style.display="none";
        }else{
            //initTabHeight_city();
            $(".line_select_bq").empty();
            changeBureauSelect(city_id);
            $("#bqfq_tj").show();
        }
        city_id_temp = city_id;
        bureau_id_temp='';
        village_id_temp = "";
        build_id_temp = "";
        citySelectCss(city_id_temp);
        bureauSelectCss(bureau_id_temp);
        //changeVillageSelect(bureau_id_temp);
        changeBuildSelect();
        clear_data();
        clear_option();
        //load_list();
    }
    function bureauSwitch(bureau_id){
        if(user_level>2)
            return;
        /*if(bureau_id=='999')
            bureau_id = "";*/
        bureau_id_temp = bureau_id;
        village_id_temp = "";
        build_id_temp = "";
        bureauSelectCss(bureau_id_temp);
        //changeVillageSelect(bureau_id_temp);
        changeBranchSelect(bureau_id_temp);
        changeBuildSelect();
        clear_data();
        clear_option();
        //load_list();
    }
    function branchSwitch(){
        village_id_temp = "-1";
        build_id_temp = "";
        branch_id_temp = $("#branch_select option:selected").val();
        changeVillageSelect(branch_id_temp);
        clear_data();
        //load_list();
    }
    function villageSwitch(){
        build_id_temp = "";
        village_id_temp = $("#village_select option:selected").val();
        changeBuildSelect();
        clear_data();
        /*if(village_id_temp==-1)
            return;*/
        load_list();
    }
    function buildSwitch(){
        //build_id_temp = $("#build_select option:selected").val();
        build_id_temp = $("#build_select").combobox("getValue");
        load_list();
    }
    //Excel文件下载
    function doExcel() {
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
        //下载的文件名称拼接
        var fileName = '流失用户清单_'+'${now.VAL}.xlsx';

        var url = "<e:url value='lostResident_ExcelDownload.e?village_id="+village_id_temp+"&build_id="+build_id_temp+"&branch_no="+branch_id_temp+"&flag="+flag+"&page="+0+"&region_id="+global_region_id+"&query_flag="+query_flag+"&query_sort="+query_sort+"&city_id="+global_current_city_id+"'/>";
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
            info.rpt_name ='流失用户清单';
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