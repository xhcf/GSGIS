<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="now">
    select const_value from easy_data.sys_const_table t where const_type='var.dss29' and const_name='calendar.curdate'
</e:q4o>
<e:q4o var="last_month">
    select to_char(last_day(add_months(sysdate,-1)),'yyyymm') val from dual
</e:q4o>
<e:set var="initTime">${now.CONST_VALUE}</e:set>

<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT T.latn_id CODE, T.latn_name TEXT,city_order_num FROM  gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    <e:if condition="${param.city_id !=null && param.city_id  ne ''}">
        and T.latn_id = '${param.city_id}'
    </e:if>
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
    <e:if condition="${param.branch_id !=null && param.branch_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.union_org_code = '${param.branch_id}'
    </e:if>
    group by T.bureau_no, T.union_org_code, T.branch_name,t.branch_no
    ORDER BY  T.branch_no
</e:q4l>


<e:description>渠道类型</e:description>
<e:q4l var="channelTypeList">
   	select channel_type_code code,channel_type_name text from gis_data.TB_CHANNEL_TYPE group by channel_type_code,channel_type_name order by channel_type_code
</e:q4l>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>实体渠道清单</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <%--秦智宏：新加下拉框js--%>
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.8.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <style>
        #tools{height:95%;}
        #query_div{width:120px;height:47px;padding:0;position:absolute;display:none;}
        #query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
        .ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
        #query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
        @media screen and (max-height: 1080px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;margin-bottom:18px;}
            .backup{right:1.4%;top:2.5%;}
            .tab_box{margin-top:18px;}
        }
        @media screen and (max-height: 768px){
            .search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
            .tab_box{margin-top:7px;}
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
            width:60px;
            text-align:center;
            font-weight:bold;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }
        .search{
            background:#030C57 !important;
            width: 100%;
            color: #fff;
            border: 1px solid #014b9f;
        }
        .search a{

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
		input::-webkit-input-placeholder{
          color:#aaa;
        }
        input::-moz-placeholder{   /* Mozilla Firefox 19+ */
          color:#aaa;
        }
        input:-moz-placeholder{    /* Mozilla Firefox 4 to 18 */
          color:#aaa;
        }
        input:-ms-input-placeholder{  /* Internet Explorer 10-11 */
          color:#aaa;}

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
        .databox_ {margin-left:28px;}

        input {color:#fff;}
        .databox_ .textbox.combo.datebox {margin-top:7px;}
        .textbox.combo.datebox {border:1px solid #3E4997;}
        .search a{margin:0px;}
        .textbox.combo {border:1px solid #3E4997;}
        .all_count {left:5px!important;height:22px!important;}
        .tab_scroll_x {width:100%;overflow-x: hidden;overflow-y: hidden;border-right:solid 0px #092e67;}
        .table1.tab_head1 tr:nth-child(2) th:first-child {width:10%;}
        .combobox-item, .combobox-group, .combobox-stick {padding:2px 3px!important;font-size:13px;}
        .textbox .textbox-text {font-size:13px;}
        .l-btn-text {line-height:26px;}
		/* #storeName{border:none !important;} */
		.all_count span {color: #FF9900;font-weight: bold;}
		#resident_detail_list0 td a{color: #FF9900;}
		#areaNo,#cityNo,#centerNo,#channelTypeNo,#storeName {width:100%;}
        #storeName {border:1px solid #3E4997;}
		.search td a{height:32px;line-height: 32px;margin-left: 32px;}
		.l-btn-text{line-height: 32px;}
        .tab_comm td {border:solid 1px #092e67;color:#fff;line-height:26px;text-align: center;}

        /*表体*/
		#resident_detail_list0.zd tr td:nth-child(1) {width:3%;}
		#resident_detail_list0.zd tr td:nth-child(2) {width:5%;}
		#resident_detail_list0.zd tr td:nth-child(3) {width:6%;color:#fff;}
		#resident_detail_list0.zd tr td:nth-child(4) {width:8%;color:#fff;}
		#resident_detail_list0.zd tr td:nth-child(5) {width:16%;color:#ff9900;text-align:left;padding-left:5px;}
		#resident_detail_list0.zd tr td:nth-child(6) {width:8%;color:#fff;}
		#resident_detail_list0.zd tr td:nth-child(7) {width:5%;color:#ff9900;}
		#resident_detail_list0.zd tr td:nth-child(8) {width:5%;}
		#resident_detail_list0.zd tr td:nth-child(9) {width:5%;color:#fff;}
		#resident_detail_list0.zd tr td:nth-child(10) {width:6%;color:#ff9900;}
		#resident_detail_list0.zd tr td:nth-child(11) {width:6%;}
		#resident_detail_list0.zd tr td:nth-child(12) {width:5%;color:#fff;}
		#resident_detail_list0.zd tr td:nth-child(13) {width:5%;}
		#resident_detail_list0.zd tr td:nth-child(14) {width:5%;}
		#resident_detail_list0.zd tr td:nth-child(15) {width:6%;color:#fff;}
		#resident_detail_list0.zd tr td:nth-child(16) {width:6%;}
		#resident_detail_list0 td{font-size:13px;}
		#resident_detail_list0 td a{font-size:13px;}

		/*表头*/
		#big_table_content_0 {padding-right:15px;}
		#import_tab tr th {border-color: #333399;line-height:28px!important;}
		#import_tab tr:first-child th:nth-child(1) {width:3%;font-size:13px;}
		#import_tab tr:first-child th:nth-child(2) {width:5%;font-size:13px;}
		#import_tab tr:first-child th:nth-child(3) {width:6%;font-size:13px;}
		#import_tab tr:first-child th:nth-child(4) {width:8%;font-size:13px;}
		#import_tab tr:first-child th:nth-child(5) {width:16%;font-size:13px;}
		#import_tab tr:first-child th:nth-child(6) {width:8%;font-size:13px;}

		#import_tab tr:nth-child(2) th:nth-child(1) {width:5%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(2) {width:5%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(3) {width:5%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(4) {width:6%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(5) {width:6%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(6) {width:5%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(7) {width:5%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(8) {width:5%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(9) {width:6%;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(10) {width:6%;font-size:13px;}
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
    	#closeTab{z-index: 9}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
	<div class="close_button" id="closeTab"></div>
    <div style="height:94%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>实&nbsp;体&nbsp;渠&nbsp;道&nbsp;清&nbsp;单</h4></div>

        <table cellspacing="0" cellpadding="0" class="search">
        	<tbody>
            <tr style="height: 50px;">
                <%-- <td width="230">
                    <div style="color:#FFFFFF; width:220px" class="databox_">
                        <span style ="font-weight:700;font-size:14px;">账&nbsp;&nbsp;&nbsp;&nbsp;期：</span>
                        <input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
                        <c:datebox id="acctDate" name="acctDate" required="true" format="yyyy-mm" defaultValue='${initTime}'/>
                    </div>
                </td> --%>

                <div id="areaNoDiv">
                    <td style="width:8%;text-align:right;" class="search_head">分&nbsp;&nbsp;公&nbsp;&nbsp;司：</td>
                    <td  width="20%" align="left">
                        <%--<e:select id="areaNo" name="areaNo"
                                  items="${areaList.list}" label="TEXT" value="CODE"  class="easyui-combobox" headLabel="全省" headValue="" defaultValue="${param.city_id}"
                                  style="width:129px" editable="false"/>--%>
                         <select id="areaNo" name="areaNo" class="trans_condition"></select>
                    </td>
                </div>

                <div id="cityNoDiv" >
                    <td style="width:8%;text-align:right;" class="search_head">县&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;区：</td>
                    <td width="20%" align="left">
                        <%--<e:select id="cityNo" name="cityNo"
                                  items="${cityList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:129px" editable="false"/>--%>
                         <select id="cityNo" name="cityNo" class="trans_condition"></select>
                    </td>
                </div>
                <div id="centerNoDiv">
                    <td style="width:8%;text-align:right;" class="search_head">支&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;局：</td>
                    <td  width="20%"  align="left">
                        <%--<e:select id="centerNo" name="centerNo"
                                  items="${centerList.list}" label="TEXT" value="CODE" class="easyui-combobox"
                                  headLabel="全部" headValue="" style="width:170px" editable="false" />--%>
                         <select id="centerNo" name="centerNo" class="trans_condition"></select>
                    </td>
                </div>
                <div>
                	<td align="center" style="padding-right: 20px" rowspan="2">
	                    <a id="btn" href="javascript:void(0)" class="easyui-linkbutton"  onclick="query()">查询</a>
	                </td>
                </div>

            </tr>
            <tr style="height: 50px;">
            	<td style="width:8%;text-align:right;" class="search_head">账&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;期：</td>
            	<td width="20%">
                    <div style="color:#FFFFFF;">
                        <input id="beginDate" type="text" style="color:#ffffff; width:100%;height:30px;line-height:30px;"/>
                    </div>
                </td>

                <div id="channelTypeDiv">
                    <td style="width:8%;text-align:right;" class="search_head">渠道类型：</td>
                    <td  width="20%" align="left">
                        <%--<e:select id="gridNo" name="gridNo"
                                  items="${gridList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:170px" editable="false"/>--%>
                         <select id="channelTypeNo" name="channelTypeNo" class="trans_condition"><option value ="">全部</option></select>
                    </td>
                </div>

                <div id="storeNameDiv">
                    <td style="width:8%;text-align:right;" class="search_head">门店名称：</td>
                    <td width="20%" align="left" style="border-right-width: 0px;">
                        <input id="storeName" name="storeName" type="text" placeholder="请输入门店名称" />
                    </td>
                </div>

            </tr>
            <tbody>
        </table>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div id="big_table_change">
                    <div id="big_table_collect_type" class="inner_tab">

                    </div>
                </div>
                <div class="sub_b">
                    <div class="all_count" >总记录数：<span id="all_count"></span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </e:if>
                    <div class="tab_scroll_x">
                        <div id="big_table_content">
                            <div id="big_table_content_0" style="margin-right: 14px;display:block;width:100%;">
                                <table cellspacing="0" cellpadding="0" class="table1 tab_head1" id="import_tab" style="width:100%;">
                                    <thead>
                                    <tr>
                                        <th rowspan="2">序号</th>
                                        <th rowspan="2" width="15%">分公司</th>
                                        <th rowspan="2">区县</th>
                                        <th rowspan="2">支局</th>
                                        <th rowspan="2">渠道名称</th>
                                        <th rowspan="2">渠道类型</th>
                                        <th colspan="3" style="font-size:13px;">效能</th>
                                        <th colspan="2" style="font-size:13px;">渠道积分</th>
                                        <th colspan="3" style="font-size:13px;">业务发展</th>
                                        <th colspan="2" style="font-size:13px;">渠道毛利</th>

                                    </tr>

                                    <tr>
                                        <th>本月</th>
                                        <th>上月</th>
                                        <th>差值</th>

                                        <th>本月积分</th>
                                        <th>上月积分</th>

                                        <th>移动</th>
                                        <th>宽带</th>
                                        <th>ITV</th>

                                        <th>本月毛利</th>
                                        <th>上月毛利</th>
                                    </tr>
                                    </thead>
                                </table>
                            </div>

                        </div>
                        <div class="t_body" style="display:block;width:100%;padding-bottom:1px;">
                            <table cellspacing="0" cellpadding="0" class="tab_comm" style="width:100%;">
                                <tbody id="resident_detail_list0" class="zd">
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
    var channelTypeJSON = ${e:java2json(channelTypeList.list)};
    /* var gridJSON = ${e:java2json(gridList.list)}; */

    var entityTypeJSON = ${e:java2json(entityTypeList.list)};
    var from_menu = '${param.from_menu}';
    $(function(){
		$.each(channelTypeJSON, function(){
		    $('#channelTypeNo').append('<option value ="'+this.CODE+'">'+this.TEXT+'</option>');
		 });
		 $('#channelTypeNo').change(function(){
	　　　　　　/* alert($(this).children('option:selected').val());
	　　　　　　var p1=$(this).children('option:selected').val();//这就是selected的值
	　　　　　　var p2=$('#param2').val();//获取本页面其他标签的值
	　　　　　　window.location.href="xx.php?param1="+p1+"m2="+p2+"";//页面跳转并传参   */

			query();
	　　　　})
	});

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
        /* if(user_level=='5'){
            roleName='gridValue';
        } */
        //区域控制 js 加载
        var areaSelect=new AreaSelect();
        areaSelect.areaJSON=areaJSON;
        areaSelect.cityJSON=cityJSON;
        areaSelect.centerJSON=centerJSON;
        areaSelect.channelTypeJSON=channelTypeJSON;
        /* areaSelect.gridJSON=gridJSON; */
        areaSelect.areaName='areaNoDiv';
        areaSelect.cityName='cityNoDiv';
        areaSelect.centerName='centerNoDiv';
        /* areaSelect.gridName='gridNoDiv'; */
        areaSelect.isDivDis=false;
        areaSelect.isNoDis=true;
        areaSelect.role=roleName;
        areaSelect.area='${sessionScope.UserInfo.AREA_NO}';
        areaSelect.city='${sessionScope.UserInfo.CITY_NO}';
        areaSelect.center='${sessionScope.UserInfo.TOWN_NO}';
        /* areaSelect.grid='${sessionScope.UserInfo.GRID_NO}'; */
        areaSelect.initAreaSelect();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });
    }


    var curr_time = new Date();
    var url4data_list = '<e:url value="/pages/telecom_Index/channel_leader/channel_action/channel_portraitAction.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, query_flag=2, query_sort = '0', eaction = "business_locations_data_list",acct_mon='',flag = 1;
    var city_id_temp = '${param.city_id}';
    console.log(city_id_temp);
    var bureau_id_temp = '${param.bureau_id}';
    console.log(bureau_id_temp);
    var branch_id_temp = '${param.branch_id}';
    console.log(branch_id_temp);
    var grid_id_temp = '${param.grid_id}';
    console.log(grid_id_temp);


    var fgl = 'all';
    var stl = 'all';
    var jzcd_flag = '';
    var villageMode_flag = '';
    var portLv_flag = '';
    var line_flag = '';

    var beginDate = "";

    if(city_id_temp==""){
        city_id_temp ='999';
    }
    console.log(city_id_temp);
    // else{
    //     city_id_for_village_tab_view = city_id_temp;
    // }

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
        /* console.log("aaa");
        $('#acctDate').datebox({
            onChange: function(date){
                clear_data();
                load_list();
            }
        }); */
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
        initAreaSelect();
        query();

        //$(".t_body").css("max-height", $("#tab_div").height() - $("") - $("#big_table_change").height() - $("#big_table_content").height());
        $(".t_body").css("max-height", document.body.offsetHeight*0.94 - $(".big_table_title").height() - $(".search").height() - $("#big_table_change").height() - $("#big_table_content").height() - 55);

        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('.t_body').scroll(function () {
            //alert($(this).scrollLeft());
            $('#import_tab').css('margin-left', -($('.t_body').scrollLeft()));

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

    function initTabHeight_province(){
        $(".t_body").css("max-height", init_tab_height+22);
    }
    function initTabHeight_city(){
        $(".t_body").css("max-height", init_tab_height-22);
    }

    function query(){
        clear_data();
        listCollectScroll(true);
    }

	function toDecimal(x){
		var num = Number(x);
		num = num.toFixed(2);
		return num;
	}

    function getParams(){
        beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
        city_id_temp = $.trim($("select[name='areaNo']").val());
        bureau_id_temp =$.trim($("select[name='cityNo']").val());
        branch_id_temp = $.trim($("select[name='centerNo']").val());
        grid_id_temp = $.trim($("select[name='gridNo']").val());
        if(city_id_temp==""){
            city_id_temp ='999';
        }
        if (city_id_temp=='999'){
            flag = 1;
        }else if(city_id_temp !='999' && city_id_temp != '' && bureau_id_temp == '' ){
            flag = 2;
        }else if(bureau_id_temp != '' && branch_id_temp ==''){
            flag = 3;
        }else if (branch_id_temp != '' && grid_id_temp == ''){
            flag = 4;
        }else if(grid_id_temp != ''){
            flag = 5;
        }
        return {
            "eaction": eaction,
            "beginDate":beginDate,
            "flag": flag,
            "page": page,
            //region_id: global_region_id,
            "query_flag": 5,
            "query_sort": 0,
            //query_sort: query_sort,
            "region_id": city_id_temp,
            "cityNo":bureau_id_temp,
            "centerNo":branch_id_temp,
            "pageSize": table_rows_array[0]
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
                var branch_name_tmp = d.BRANCH_NAME;
                var bureau_name_tmp = d.BUREAU_NAME;
                if(branch_name_tmp == "" || branch_name_tmp == null){
                    branch_name_tmp = " ";
                }
                if(bureau_name_tmp == "" || bureau_name_tmp == null){
                    bureau_name_tmp = " ";
                }
                var newRow = "";
                //if(i==0){
                //    newRow += "<tr style=\"background-color:#043572 \">";
                //}else{
                    newRow += "<tr>";
                //}
                newRow += "<td>"+ (++seq_num) +"</td>";

                var name_str = "";
                    name_str = "<td style='text-align:center;'>" + d.AREA_DESCRIPTION + "</td>";
                newRow += name_str +
                "<td>" + bureau_name_tmp +
                "</td><td>" + branch_name_tmp +
                "</td><td><a onclick=\"insideToChannel('"+ d.LATN_ID+"','"+ d.AREA_DESCRIPTION+"','"+ d.BUREAU_NO+"','"+ d.BUREAU_NAME+"','"+d.CHANNEL_NBR+"')\">" + d.CHANNEL_NAME + "</a>"+
                "</td><td>"+ d.CHANNEL_TYPE_NAME_QD + "</a>"+
                "</td><td>" + toDecimal(d.XN_CUR_MONTH_SCORE) +
                "</td><td>" + toDecimal(filterNull(d.XN_LAST_MONTH_SCORE)) +
                "</td><td>" + toDecimal(filterNull(d.CHAZHI)) +
                "</td><td>" + toDecimal(d.QDJF_CUR_MONTH) +
                "</td><td>" + toDecimal(filterNull(d.QDJF_LAST_MONTH)) +

                "</td><td>" + d.YWFZ_CUR_MONTH_YD +
                "</td><td>" + d.YWFZ_CUR_MONTH_KD +
                "</td><td>" + d.YWFZ_CUR_MONTH_ITV +

                "</td><td>" + toDecimal(d.QDML_CUR_MONTH) +
                "</td><td>" + toDecimal(filterNull(d.QDML_LAST_MONTH)) +

                "</td></tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=10 >没有查询到数据</td></tr>")
            }
        });
    }
    function insideToChannel(latn_id,latn_name,bureau_no,bureau_name,c_id){
        global_current_city_id = latn_id;
        global_position.splice(1,1,latn_name);
        global_bureau_id = bureau_no;
        global_current_full_area_name = bureau_name;
        global_current_area_name = bureau_name;
        global_position.splice(2,1,bureau_name);
        global_region_type = "bureau";
        global_entrance_type = "channel";
        global_channel_id = c_id;
        load_map_view();
        toGIS();
    }
    function filterNull(el){
    	var result = el;
    	if(el==null || el=='null'){
    		result = '';
    	}
    	return result;
    }

    $("#collect_tabs_change > div").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    })

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page = 0,
        flag = '1', query_sort = '0';
        $("#all_count").text("");
        $("#resident_detail_list0").empty();
        $("#download_div").hide();
    }
    function backup(level){
        initListDiv(1);
    }

</script>