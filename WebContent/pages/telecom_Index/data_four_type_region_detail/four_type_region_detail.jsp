<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%--查询账期--%>
<e:q4o var="now">
    SELECT to_char(to_date(const_value,'yyyymmdd'),'yyyy-mm-dd') val FROM easy_data.sys_const_table WHERE const_type = 'var.dss28' AND data_type = 'day'
</e:q4o>
<e:q4o var="last_month">
    select to_char(last_day(add_months(sysdate,-1)),'yyyymm') val from dual
</e:q4o>

<e:set var="initTime">${now.VAL}</e:set>
<e:if condition="${param.beginDate ne '' && param.beginDate !=null }">
    <e:set var="initTime">${param.beginDate}</e:set>
</e:if>
<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT to_char(T.latn_id) CODE, T.latn_name TEXT,city_order_num FROM  gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${param.frome_page ne '' && param.frome_page !=null}" var="frome_page">

    </e:if>
    <e:else condition="${frome_page}">
        <e:if condition="${param.city_id !=null && param.city_id  ne ''}">
            and T.latn_id = '${param.city_id}'
        </e:if>
    </e:else>

    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY  city_order_num
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT  T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.region_order_num FROM gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${param.bureau_id !=null && param.bureau_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.region_order_num
    ORDER BY  T.region_order_num
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.union_org_code CODE, T.branch_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${param.branch_id !=null && param.branch_id  ne ''}" var="empty_branch">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.union_org_code = '${param.branch_id}'
    </e:if>
    <e:else condition="${empty_branch}">
        <e:if condition="${sessionScope.UserInfo.LEVEL eq '3'}">
            and t.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
        </e:if>
        <e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
            and t.union_org_code = '${sessionScope.UserInfo.TOWN_NO}'
        </e:if>
    </e:else>
    group by T.bureau_no, T.union_org_code, T.branch_name,t.branch_no
    ORDER BY  T.branch_no
</e:q4l>

<e:description>网格</e:description>
<e:q4l var="gridList">
    SELECT  T.union_org_code PID, T.grid_id CODE, T.grid_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.grid_id IS NOT NULL
    and t.branch_type='a1' and t.grid_union_org_code is not null
    <e:if condition="${param.grid_id !=null && param.grid_id  ne ''}" var="empty_grid">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.union_org_code = '${param.branch_id}'
        and T.grid_id = '${param.grid_id}'
    </e:if>
    <e:else condition="${empty_grid}">
        <e:if condition="${sessionScope.UserInfo.LEVEL eq '3'}">
            and T.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
        </e:if>
        <e:if condition="${sessionScope.UserInfo.LEVEL eq '4'}">
            and T.union_org_code = '${sessionScope.UserInfo.TOWN_NO}'
        </e:if>
        <e:if condition="${sessionScope.UserInfo.LEVEL eq '5'}">
            and T.grid_union_org_code = '${sessionScope.UserInfo.GRID_NO}'
        </e:if>
    </e:else>
    group by t.union_org_code,t.grid_id,t.grid_name
    ORDER BY  T.grid_id
</e:q4l>

<e:description>小区类型</e:description>
<e:q4l var="villageTypeList">
    select ' ' CODE , '全部'    TEXT from dual
    union
    select '1' CODE , '急迫小区' TEXT from dual
    union
    select '2' CODE , '紧迫小区' TEXT from dual
    union
    select '3' CODE , '操心小区' TEXT from dual
    union
    select '4' CODE , '平稳小区' TEXT from dual
</e:q4l>


<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>四类小区清单</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <%--秦智宏：新加下拉框js--%>
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/areaSelectAddon.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.1"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=1.3.0" />'  rel="stylesheet" type="text/css"
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
            .tab_box{margin-top:8px;}
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
        .search{border:1px solid #1851a9;}
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
        .textbox,.textbox-text{background:none!important;}



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
        .textbox.combo.datebox {margin-top:6px;}
        .textbox {border: 1px solid #3E4997!important;}
        .search tr:first-child td {padding-top:5px;}
        .search tr:last-child td {padding-bottom:5px;}
        #closeTab {top:15px;}
        .tab_scroll_x {border-right:0px!important;}
        /*.textbox.combo.datebox {width:120px!important;}*/
        #areaNo,#cityNo,#centerNo,#gridNo,#villageNo,#village_degree {width:70%;}
        .cond_head {width:20%;}
        #download_div {display:none;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
    <e:if condition="${param.from_menu ne '' }">
    </e:if>
    <e:if condition="${param.from_menu eq '' || param.from_menu == null}">
        <div class="close_button" id="closeTab"></div>
    </e:if>
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>四&nbsp;类&nbsp;小&nbsp;区&nbsp;清&nbsp;单</h4></div>

        <table cellspacing="0" cellpadding="0" class="search">
            <tr style="height: 42px;">
                <td width="20%">
                    <div style="margin-left:25px" class="databox_">
                        <span class="cond_head">账&emsp;期：</span>
                        <%--<input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>--%>
                        <c:datebox id="acctDate" name="acctDate" required="true" format="yyyy-mm-dd" defaultValue='${initTime}' />
                    </div>
                </td>
                <td>
                    <span class="cond_head">小区类型：</span>
                    <%--<e:select id="villageNo" name="villageNo"
                              items="${villageTypeList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                              headLabel="全部" headValue=""  style="width:200px" editable="false"/>--%>
                    <select id="villageNo" name="villageNo" class="trans_condition" onchange="javascript:query1();"></select>
                </td>
                <td>
                    <span class="cond_head">小区等级：</span>
                    <select id="village_degree" class="trans_condition" onchange="javascript:query1();">
                        <option value="">全部</option>
                        <option value="1">省级</option>
                        <option value="2">市级</option>
                        <option value="3">县级</option>
                    </select>
                </td>
                <td colspan="2"></td>
            </tr>
            <tr>
                <td style="height:42px;">
                    <div id="areaNoDiv" style="margin-left:25px">
                        <span class="cond_head">分公司：</span>
                        <%--<e:select id="areaNo" name="area"
                                  items="${areaList.list}" label="TEXT" value="CODE"  class="easyui-combobox" headLabel="全省" headValue="" defaultValue="${param.city_id}"
                                  style="width:120px" editable="false"/>--%>
                        <select id="areaNo" name="areaNo" class="trans_condition"></select>
                    </div>
                </td>
                <td width="24%">
                    <div id="cityNoDiv">
                        <span class="cond_head">县&emsp;&emsp;区：</span>
                        <%--<e:select id="cityNo" name="city"
                                  items="${cityList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:200px" editable="false"/>--%>
                        <select id="cityNo" name="cityNo" class="trans_condition"></select>
                    </div>
                </td>
                <td width="24%">
                    <div id="centerNoDiv">
                        <span class="cond_head">支&emsp;&emsp;局：</span>
                        <%--<e:select id="centerNo" name="centerNo"
                                  items="${centerList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:220px" editable="false" />--%>
                        <select id="centerNo" name="centerNo" class="trans_condition"></select>
                    </div>
                </td>
                <td width="24%">
                    <div id="gridNoDiv">
                        <span class="cond_head">网&emsp;&emsp;格：</span>
                        <%--<e:select id="gridNo" name="gridNo"
                                  items="${gridList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:220px" editable="false"/>--%>
                        <select id="gridNo" name="gridNo" onchange="query1()" class="trans_condition"></select>
                    </div>
                </td>
                <td>
                    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query1()">查询</a>
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
                    <div class="all_count">总记录数：<span id="all_count"></span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </e:if>
                    <div class="tab_scroll_x">
                        <div id="big_table_content">
                            <div id="big_table_content_0" style="margin-right: 14px;display:block;">
                                <table cellspacing="0" cellpadding="0" style="width:2130px;" id="four_type2">
                                    <thead>
                                    <tr>
                                        <th rowspan="2">序号</th>
                                        <th rowspan="2">分公司</th>
                                        <th rowspan="2">分局</th>
                                        <th rowspan="2">支局</th>
                                        <th rowspan="2">网格</th>
                                        <th rowspan="2">小区</th>
                                        <th rowspan="2">类型</th>
                                        <th colspan="3">市场占有</th>
                                        <th colspan="3">竞争收集</th>
                                        <th colspan="3">精准营销</th>
                                        <th colspan="3">用户流失</th>
                                        <th colspan="3">光网覆盖</th>
                                        <th colspan="3">端口占用</th>
                                    </tr>
                                    <tr>
                                        <th>本月渗透率</th>
                                        <th>上月渗透率</th>
                                        <th>本月提升</th>

                                        <th>本月收集率</th>
                                        <th>上月收集率</th>
                                        <th>本月提升</th>

                                        <th>本月执行率</th>
                                        <th>上月执行率</th>
                                        <th>本月提升</th>

                                        <th>本月占比</th>
                                        <th>上月占比</th>
                                        <th>本月下降</th>

                                        <th>本月覆盖率</th>
                                        <th>上月覆盖率</th>
                                        <th>本月提升</th>

                                        <th>本月占有率</th>
                                        <th>上月占有率</th>
                                        <th>本月提升</th>
                                    </tr>
                                    </thead>
                                </table>
                            </div>

                        </div>
                        <div class="t_body" id="big_table_info_div1" style="overflow-y:scroll;display:block;width:2150px">
                            <table cellspacing="0" cellpadding="0"  style="width:2130px">
                                <tbody id="resident_detail_list0" class="detail">
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
    var roleName='';
    var areaJSON=${e:java2json(areaList.list)};
    var cityJSON = ${e:java2json(cityList.list)};
    var centerJSON = ${e:java2json(centerList.list)};
    var gridJSON = ${e:java2json(gridList.list)};

    var curr_time = new Date();
    var url4data_list = '<e:url value="/pages/telecom_Index/common/sql/pointAnalyze_action.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, eaction = "region_detail_list",acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var branch_id_temp = '${param.branch_id}';
    var grid_id_temp = '${param.grid_id}';
    var village_type='${param.village_type}';
    var village_degree = "${param.village_degree}";

    var beginDate = "";

    //如果已经没有数据, 则不再次发起请求.
    var init_tab_height = 0;

    var table_rows_array = "";
    var table_rows_array_small_screen = [20,25,35];
    var table_rows_array_big_screen = [35,45,55];

    if(window.screen.height<=768){
        table_rows_array = table_rows_array_small_screen;
    }else{
        table_rows_array = table_rows_array_big_screen;
    }

    function initAreaSelect() {
        if(user_level=='1'){
            roleName='all';
        }
        if(user_level=='2'){
            roleName='areaValue';
        }
        if(user_level=='3'){
            roleName='cityValue';
        }
        if(user_level=='4'){
            roleName='centerNoValue';
        }
        if(user_level=='5'){
            roleName='gridValue';
        }
        //区域控制 js 加载
        var areaSelect=new AreaSelect();
        areaSelect.areaJSON=areaJSON;
        areaSelect.cityJSON=cityJSON;
        areaSelect.centerJSON=centerJSON;
        areaSelect.gridJSON=gridJSON;
        areaSelect.areaName='areaNoDiv';
        areaSelect.cityName='cityNoDiv';
        areaSelect.centerName='centerNoDiv';
        areaSelect.gridName='gridNoDiv';
        areaSelect.isDivDis=false;
        areaSelect.isNoDis=true;
        areaSelect.role=roleName;
        areaSelect.area='${sessionScope.UserInfo.AREA_NO}';
        areaSelect.city='${sessionScope.UserInfo.CITY_NO}';
        areaSelect.center='${sessionScope.UserInfo.TOWN_NO}';
        areaSelect.grid='${sessionScope.UserInfo.GRID_NO}';
        areaSelect.initAreaSelect();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });
    }

    function resetAreaSelect(){
        if(city_id_temp == '999' || city_id_temp=='' ){
            //$(areaNo).combobox('select','');
            $("#areaNo").val('');
        }else {
            //$(areaNo).combobox('select',city_id_temp);
            $("#areaNo").children("[value='"+city_id_temp+"']").attr("selected","selected");
            if(user_level<3)
                //$("#areaNo").trigger("change");
                filterBureauByCity('${sessionScope.UserInfo.AREA_NO}');
            else{
                filterBranchByBureau('${sessionScope.UserInfo.CITY_NO}');
            }
        }
    }

    if(city_id_temp==""){
        city_id_temp ='999';
    }
    // else{
    //     city_id_for_village_tab_view = city_id_temp;
    // }

    //var long_message_width = 0;
    $(function(){
        $(".textbox.combo.datebox").width($(".search").width()*0.2-25-$(".cond_head").width());
        //下拉框初始化方法
        $('#acctDate').datebox({
            onChange: function(date){
                query1();
            }
        });

        initAreaSelect();
        resetAreaSelect();
        resetSelectFunc();
        query1();

        $(".tab_scroll_x").css("height", document.body.offsetHeight*0.94 - $(".big_table_title").height() - $(".search").height() - $(".all_count").height() - 30);
        //$(".t_body").css("max-height", document.body.offsetHeight*0.94 - $(".big_table_title").height() - $(".search").height() - $(".all_count").height() - 106 - $("#four_type2").height());

        init_tab_height = $(".tab_scroll_x").height() - $("#four_type").height() - 75;
        initTabHeight_province();
        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('#big_table_info_div1').scroll(function () {
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
            load_list_view(8,'',$('#acctDate').datebox('getValue'),'');
        });

        $("#big_table_collect_type span").eq(0).click();
    });

    function resetSelectFunc(){
        if(user_level==2){
            $("#cityNo").removeAttr("disabled");
            //$("#centerNo").removeAttr("disabled");
            //$("#gridNo").removeAttr("disabled");
        }else if(user_level==3){
            $("#centerNo").removeAttr("disabled");
            //$("#gridNo").removeAttr("disabled");
        }

        var village_type_list = ${e:java2json(villageTypeList.list)};
        for(var i = 0,l = village_type_list.length;i<l;i++){
            var type = village_type_list[i];
            $("#villageNo").append("<option value='"+type.CODE+"'>"+type.TEXT+"</option>");
        }

        if(village_type == '' || village_type == null){
            //$(villageNo).combobox('select','');
            $("#villageNo").val('');
        }else {
            //$(villageNo).combobox('select',village_type);
            $("#villageNo").val(village_type);
        }
        if(village_degree == '' || village_degree == null){
            //$(villageNo).combobox('select','');
            $("#village_degree").val('');
        }else {
            //$(villageNo).combobox('select',village_type);
            $("#village_degree").val(village_degree);
        }
    }

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-55);
    }

    function query1(){
        clear_data();
        listCollectScroll(true);
    }

    function getParams(){
        beginDate = $('#acctDate').datebox('getValue').replace(/-/g, "");
        city_id_temp = $.trim($('select[name="areaNo"]').val());
        bureau_id_temp = $.trim($('select[name="cityNo"]').val());
        branch_id_temp = $.trim($('select[name="centerNo"]').val());
        grid_id_temp = $.trim($('select[name="gridNo"]').val());
        village_type = $.trim($('select[name="villageNo"]').val());
        village_degree = $("#village_degree option:selected").val();
        return {
            "eaction" : eaction,
            "beginDate" : beginDate,
            "page" : page,
            "region_id" : city_id_temp,
            "cityNo" : bureau_id_temp,
            "centerNo" : branch_id_temp,
            "gridNo" : grid_id_temp,
            "village_type" : village_type,
            "village_degree" : village_degree,
            "pageSize" : table_rows_array[0]
        };
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
                if (data.length) {
                    $("#all_count").html(data[0].C_NUM);
                } else {
                    $("#all_count").html('0');
                }
            }

            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td>" + (++seq_num) + "</td>" +
                    "<td style='text-align:center;'>" + d.LATN_NAME + "</td>"+
                    "<td>" + d.BUREAU_NAME + "</td>"+
                    "<td>" + d.BRANCH_NAME + "</td>"+
                    "<td>" + d.GRID_NAME + "</td>"+
                    "<td><a onclick=\"insideToVillage("+d.VILLAGE_ID+")\">" + d.VILLAGE_NAME + "</a></td>" +
                    "<td>" + d.VILLAGE_LABEL_NAME + "</td>"+

                    "<td>" + d.ST_RATE + "</td>"+
                    "<td>" + d.ST_RATE_UP + "</td>"+
                    "<td>" + d.ST_RATE_YUP + "</td>"+

                    "<td>" + d.SJ_RATE + "</td>"+
                    "<td>" + d.SJ_RATE_UP + "</td>"+
                    "<td>" + d.SJ_RATE_YUP + "</td>"+

                    "<td>" + d.EXEC_LV + "</td>"+
                    "<td>" + d.LAST_EXEC_LV + "</td>"+
                    "<td>" + d.EXEC_LV_UP + "</td>"+

                    "<td>" + dataFormat(d.LOST_ZB) + "</td>"+
                    "<td>" + d.LAST_LOST_ZB + "</td>"+
                    "<td>" + dataFormat(d.LOST_ZB_UP) + "</td>"+

                    "<td>" + d.H_ARRIVE_RATE + "</td>"+
                    "<td>" + d.H_ARRIVE_RATE_M + "</td>"+
                    "<td>" + d.H_ARRIVE_RATE_UP + "</td>"+

                    "<td>" + d.PORT_RATE + "</td>"+
                    "<td>" + d.PORT_RATE_M + "</td>"+
                    "<td>" + d.PORT_RATE_UP + "</td>"+
                    "</tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=25 >没有查询到数据</td></tr>")
            }
        });
    }

    function dataFormat(data){
        if(data=="%")
            return '--';
        return data;
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