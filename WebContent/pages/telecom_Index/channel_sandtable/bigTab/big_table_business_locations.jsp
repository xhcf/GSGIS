<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="now">
    <e:if condition="${!empty param.comp_date}" var="has_date">
        select to_char(last_day(to_date('${param.comp_date}','yyyymm')),'yyyy-mm-dd') CONST_VALUE from dual
    </e:if>
    <e:else condition="${has_date}">
    select substr(const_value,0,4)||'-'||substr(const_value,5,2)||'-'||substr(const_value,7,2) CONST_VALUE from ${easy_user}.sys_const_table t where const_type='var.dss31' and const_name='calendar.curdate'
    </e:else>
</e:q4o>
<e:q4o var="last_month">
    select to_char(last_day(add_months(sysdate,-1)),'yyyymm') val from dual
</e:q4o>
<e:set var="initTime">${now.CONST_VALUE}</e:set>

<e:q4o var="default_mon">
	select const_value yMonth,CASE WHEN SUBSTR(CONST_VALUE, 5)<10 THEN SUBSTR(CONST_VALUE, 6) ELSE SUBSTR(CONST_VALUE, 5) END || '月积分' ymonth_text from ${easy_user}.sys_const_table where const_type = 'var.dss32' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="default_acct_mon">${default_mon.yMonth}</e:set>

<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT T.latn_id CODE, T.latn_name TEXT,LATN_ORD FROM  ${channel_user}.tb_gis_channel_org T
    WHERE T.latn_id IS NOT NULL

    <e:if condition="${param.city_id !=null && param.city_id  ne ''}">
        and t.latn_id = '${param.city_id}'
    </e:if>

    group by T.latn_id, T.latn_name,LATN_ORD
    ORDER BY LATN_ORD
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT
    T.latn_id PID,
    T.bureau_no CODE,
    DECODE(replace(replace(t.BUREAU_NAME,'分局',''),'电信局',''),'其他','',replace(replace(t.BUREAU_NAME,'分局',''),'电信局','')) TEXT,
    t.city_ord
    FROM  ${channel_user}.tb_gis_channel_org T
    WHERE T.latn_id IS NOT NULL
    and t.bureau_no not in ('930013119','930013115', '930013199','930013113')
    and length(t.bureau_no)>3
    <e:if condition="${sessionScope.UserInfo.LEVEL > 1}">
        and t.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL > 2}">
        and t.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
    </e:if>
    <e:if condition="${param.bureau_id !=null && param.bureau_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
    </e:if>

    group by T.latn_id,T.bureau_no,T.bureau_name,t.city_ord
    ORDER BY T.city_ord
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.Branch_No CODE, T.branch_name TEXT,BRANCH_ORD FROM ${channel_user}.tb_gis_channel_org T
    WHERE T.Branch_No IS NOT NULL

    <e:if condition="${sessionScope.UserInfo.LEVEL > 1}">
        and t.latn_id = '${sessionScope.UserInfo.AREA_NO}'
    </e:if>
    <e:if condition="${sessionScope.UserInfo.LEVEL > 2}">
        and t.bureau_no = '${sessionScope.UserInfo.CITY_NO}'
    </e:if>
    <e:if condition="${param.branch_id !=null && param.branch_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
        and T.Branch_No = '${param.branch_id}'
    </e:if>

    group by T.bureau_no, T.branch_name,t.branch_no,BRANCH_ORD
    ORDER BY T.BRANCH_ORD
</e:q4l>

<e:description>渠道类型</e:description>
<e:q4l var="channelTypeList">
   	select entity_channel_type code,entity_channel_type_name text from ENTITY_CHANNEL_TYPE
   	union all
   	select '99' code,'未归类' text from dual
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
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/big_tab_reset.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">

    <style>
        #tools{height:95%;}
        #query_div{width:120px;height:47px;padding:0;position:absolute;display:none;}
        #query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
        .ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
        #query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}

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
        .all_count {left:5px!important;height:30px!important;}
        .tab_scroll_x {width:100%;overflow-x: hidden;overflow-y: hidden;border-right:solid 0px #092e67;}
        .table1.tab_head1 tr:nth-child(2) th:first-child {width:10%;}
        .combobox-item, .combobox-group, .combobox-stick {padding:2px 3px!important;font-size:13px;}
        .textbox .textbox-text {font-size:13px;}
        .l-btn-text {line-height:26px;}
		/* #storeName{border:none !important;} */
		.all_count span {color: #FF9900;font-weight: bold;}
		#resident_detail_list0 td a{color: #4CB9F9;}
		#areaNo,#cityNo,#centerNo,#channelTypeNo,#storeName {width:100%;color:#f7e1e1;}
        #storeName {border:1px solid #3E4997;}
		.search td a{height:32px;line-height: 32px;margin-left: 32px;}
		.l-btn-text{line-height: 32px;}
        .tab_comm td {border:solid 1px #092e67;color:#fff;line-height:26px;text-align: center;}

		/*表头*/
		#big_table_content_0 {padding-right:15px;}
		#import_tab tr th {border-color: #333399;line-height:28px!important;}
		#import_tab tr:first-child th:nth-child(1) {width:2%!important;font-size:13px;}
		#import_tab tr:first-child th:nth-child(2) {width:2%!important;font-size:13px;}
		#import_tab tr:first-child th:nth-child(3) {width:5%!important;font-size:13px;}
		#import_tab tr:first-child th:nth-child(4) {width:7%!important;font-size:13px;}
		#import_tab tr:first-child th:nth-child(5) {width:9%!important;font-size:13px;}
		#import_tab tr:first-child th:nth-child(6) {width:3%!important;font-size:13px;}

		#import_tab tr:nth-child(2) th:nth-child(1) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(2) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(3) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(4) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(5) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(6) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(7) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(8) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(9) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(10) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(11) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(12) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(13) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(14) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(15) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(16) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(17) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(18) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(19) {width:4%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(20) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(21) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(22) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(23) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(24) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(25) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(26) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(27) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(28) {width:3%!important;font-size:13px;}
		#import_tab tr:nth-child(2) th:nth-child(29) {width:3%!important;font-size:13px;}

        /*表体*/
        #resident_detail_list0 tr td:nth-child(1) {width:2%!important;}
        #resident_detail_list0 tr td:nth-child(2){width:2%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(3){width:5%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(4){width:7%!important;font-size:13px;;}
        #resident_detail_list0 tr td:nth-child(5){width:9%!important;font-size:13px;text-align:left!important}
        #resident_detail_list0 tr td:nth-child(6){width:3%!important;font-size:13px;}

        #resident_detail_list0 tr td:nth-child(7) {width:3%!important;font-size:13px;color:#f90!important;}
        #resident_detail_list0 tr td:nth-child(8) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(9) {width:3%!important;font-size:13px;color:#f90!important;}
        #resident_detail_list0 tr td:nth-child(10) {width:3%!important;font-size:13px;}

        #resident_detail_list0 tr td:nth-child(11) {width:3%!important;font-size:13px;color:#f90!important;}
        #resident_detail_list0 tr td:nth-child(12) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(13) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(14) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(15) {width:3%!important;font-size:13px;color:#f90!important;}
        #resident_detail_list0 tr td:nth-child(16) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(17) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(18) {width:3%!important;font-size:13px;}

        #resident_detail_list0 tr td:nth-child(19) {width:3%!important;font-size:13px;color:#f90!important;}
        #resident_detail_list0 tr td:nth-child(20) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(21) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(22) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(23) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(24) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(25) {width:4%!important;font-size:13px;color:#f90!important;}
        #resident_detail_list0 tr td:nth-child(26) {width:3%!important;font-size:13px;}

        #resident_detail_list0 tr td:nth-child(27) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(28) {width:3%!important;font-size:13px;}
        #resident_detail_list0 tr td:nth-child(29) {width:3%!important;font-size:13px;}

		/*表格行高*/
		#resident_detail_list0 tr td{line-height:28px!important;}
		/*返回按钮*/
		.close_button {
		    position: absolute;
		    right: 26px;
		    top: 20px;
		    width: 25px;
		    height: 25px;
		    background: url("<e:url value='pages/telecom_Index/channel_sandtable/images/back.png'/>")no-repeat center/cover;
		    cursor: pointer;
    	}
    	#closeTab{z-index: 9}

        .tbody {overflow-y: scroll;}
        #big_table_content_0{padding-right:6px;}
        .t_body{overflow-x: scroll!important;}

        @media screen and (max-height: 1080px){
        	/* .tab_scroll_x{height:100%;}
            .t_body{height:68%;} */
        }
        @media screen and (max-height: 768px){
        	/* .tab_scroll_x{height:84%;}
            .t_body{height:68%;} */
        }

        /* 表格字体颜色#f7e1e1 灰白 */
        #import_tab tr th,#resident_detail_list0 tr td,.search td,#beginDate,.big_table_title h4,.textbox .textbox-text{color:#f7e1e1!important;}
        #resident_detail_list0 td a{font-size:13px!important;text-decoration:none!important;}
        #resident_detail_list0 td a:hover{text-decoration:underline!important;}

        #saleTypeNo{width:100%;}
        .tab_scroll_x {height:auto!important;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
	<div class="close_button" id="closeTab1"></div>
    <div style="height:94%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title big_table_title1"><h4>实&nbsp;体&nbsp;渠&nbsp;道&nbsp;清&nbsp;单</h4></div>

        <table cellspacing="0" cellpadding="0" class="search search1">
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
                    <td style="width:8%;text-align:right;" class="search_head">分&ensp;公&ensp;司：</td>
                    <td  width="13%" align="left">
                        <%--<e:select id="areaNo" name="areaNo"
                                  items="${areaList.list}" label="TEXT" value="CODE"  class="easyui-combobox" headLabel="全省" headValue="" defaultValue="${param.city_id}"
                                  style="width:129px" editable="false"/>--%>
                         <select id="areaNo" name="areaNo" class="trans_condition"></select>
                    </td>
                </div>

                <div id="cityNoDiv" >
                    <td style="width:8%;text-align:right;" class="search_head">县&emsp;&emsp;区：</td>
                    <td width="13%" align="left">
                        <%--<e:select id="cityNo" name="cityNo"
                                  items="${cityList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                  headLabel="全部" headValue=""  style="width:129px" editable="false"/>--%>
                         <select id="cityNo" name="cityNo" class="trans_condition"></select>
                    </td>
                </div>
                <div id="centerNoDiv">
                    <td style="width:8%;text-align:right;" class="search_head">支&emsp;&emsp;局：</td>
                    <td  width="13%"  align="left">
                        <%--<e:select id="centerNo" name="centerNo"
                                  items="${centerList.list}" label="TEXT" value="CODE" class="easyui-combobox"
                                  headLabel="全部" headValue="" style="width:170px" editable="false" />--%>
                         <select id="centerNo" name="centerNo" class="trans_condition"></select>
                    </td>
                </div>
                <div>
                	<td colspan="2"></td>
                </div>
                <div>
                	<td align="center" style="padding-right: 20px" rowspan="2">
	                    <a id="btn" href="javascript:void(0)" class="easyui-linkbutton"  onclick="query()">查询</a>
	                </td>
                </div>

            </tr>
            <tr style="height: 50px;">
            	<td style="width:8%;text-align:right;" class="search_head">账&emsp;&emsp;期：</td>
            	<td width="13%">
                  <div style="color:#f7e1e1;">
                  	  <!-- <input id="beginDate" type="text" style="color:#ffffff; width:100%;height:30px;line-height:30px;"/> -->
                  	  <input id="beginDate" name='beginDate' style="color:#ffffff; width:100%;height:30px;line-height:30px;" />
                  		<!--<c:datebox required='false' format='yyyy-mm-dd' name='beginDate' id='beginDate' defaultValue='${initTime}' />-->
                  </div>
              </td>

              <div id="channelTypeDiv">
                  <td style="width:8%;text-align:right;" class="search_head">渠道类型：</td>
                  <td width="13%" align="left">
                      <%--<e:select id="gridNo" name="gridNo"
                                items="${gridList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
                                headLabel="全部" headValue=""  style="width:170px" editable="false"/>--%>
                       <select id="channelTypeNo" name="channelTypeNo" class="trans_condition"><option value ="">全部</option></select>
                  </td>
              </div>

              <div>
              		<td style="width:8%;text-align:right;" class="search_head">销售类型：</td>
              		<td width="13%">
              			<select id="saleTypeNo" name="saleTypeNo" class="trans_condition">
              				<option value ="">全部</option>
              				<option value ="0">零销门店</option>
              				<option value ="1">低销门店</option>
              				<option value ="2">高销门店</option>
              				<option value ="-1">其它</option>
              			</select>
              		</td>
              </div>

              <div id="storeNameDiv">
                  <td style="width:8%;text-align:right;" class="search_head">门店名称：</td>
                  <td width="13%" align="left" style="border-right-width: 0px;">
                      <input id="storeName" name="storeName" type="text" class="trans_condition" placeholder="请输入门店名称" />
                  </td>
              </div>

            </tr>
            <tbody>
        </table>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div class="sub_b">
                    <div class="all_count all_count1" style="font-size:13px;color:#f7e1e1;">总记录数：<span id="all_count"></span></div>
                    <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                        <div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                    </e:if>
                    <div class="tab_scroll_x">
                        <div id="big_table_content">
                            <div id="big_table_content_0" style="display:block;width:100%;">
                                <table cellspacing="0" cellpadding="0" class="table1 tab_head1" id="import_tab" style="width:2400px;">
                                    <thead>
                                    <tr>
                                        <th rowspan="2">序号</th>
                                        <th rowspan="2" width="15%">分公司</th>
                                        <th rowspan="2">区县</th>
                                        <th rowspan="2">支局</th>
                                        <th rowspan="2">渠道名称</th>
                                        <th rowspan="2">渠道类型</th>
                                        <th colspan="4" style="font-size:13px;">营销积分(日积分)</th>
                                        <th colspan="8" style="font-size:13px;">发展规模</th>
                                        <th colspan="8" style="font-size:13px;">发展质态</th>
                                        <th colspan="3" style="font-size:13px;">发展效益</th>

                                    </tr>

                                    <tr>
                                        <th>本月累计</th>
                                        <th>本月户均</th>
                                        <th>当日积分</th>
                                        <th>当日户均</th>

                                        <th>本月累计  </th>
																				<th>移动</th>
																				<th>宽带</th>
																				<th>电视</th>
																				<th>当日发展  </th>
																				<th>移动</th>
																				<th>宽带</th>
																				<th>电视</th>

										                    <th>移动新增<br/>活跃率 </th>
																				<th>移动新增<br/>活跃用户数 </th>
																				<th>移动新增<br/>出账率 </th>
																				<th>移动新增<br/>出账用户数 </th>
																				<th>移动新增<br/>离网率 </th>
																				<th>移动新增<br/>离网用户数 </th>
																				<th>移动新增<br/>DNA户均</th>
																				<th>移动新增<br/>用户数 </th>

                                        <th>毛利率</th>
                                        <th>收入（万)</th>
                                        <th>成本（万）</th>
                                    </tr>
                                    </thead>
                                </table>
                            </div>

                        </div>
                        <div class="t_body t_body1" style="display:block;width:100%;padding-bottom:1px;">
                            <table cellspacing="0" cellpadding="0" class="tab_comm" id="data_tbody" style="width:2400px;">
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

    var flag_level = '${param.flag}';
    var query_type = '${param.query_type}';
    var org_id = '${param.org_id}';
    var org_id2 = '${param.org_id2}';
    var comp_date = '${param.comp_date}';

    $(function(){
		 $.each(channelTypeJSON, function(){
		    $('#channelTypeNo').append('<option value ="'+this.CODE+'">'+this.TEXT+'</option>');
		 });
		 if('${param.comp_type}'!='')
		  	$('#saleTypeNo').val('${param.comp_type}');

		 $('#channelTypeNo').change(function(){
	      /* alert($(this).children('option:selected').val());
	      var p1=$(this).children('option:selected').val();//这就是selected的值
	      var p2=$('#param2').val();//获取本页面其他标签的值
	      window.location.href="xx.php?param1="+p1+"m2="+p2+"";//页面跳转并传参   */

		    query();
	     });
         $('#saleTypeNo').change(function(){
	      /* alert($(this).children('option:selected').val());
	      var p1=$(this).children('option:selected').val();//这就是selected的值
	      var p2=$('#param2').val();//获取本页面其他标签的值
	      window.location.href="xx.php?param1="+p1+"m2="+p2+"";//页面跳转并传参   */

		    query();
         });

		 $("#beginDate").datebox({
            width:'100%',
            onSelect:function(value,index){
                query();
            },
            value:'${initTime}'
		 });
         $('.t_body1').scroll(function () {
            //alert($(this).scrollLeft());
            $('#table_head').css('margin-left', -($('.t_body1').scrollLeft()));
            $('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
         });
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
        if(areaSelect.area==""){
        	if(org_id!="" && flag_level=="1")
        		areaSelect.area = org_id;
        }
        areaSelect.city='${sessionScope.UserInfo.CITY_NO}';
        if(areaSelect.city==""){
        	if(org_id!="" && flag_level=="2"){
        		areaSelect.area = org_id;
        		areaSelect.city = org_id2;
        	}
        }
        areaSelect.center='${sessionScope.UserInfo.TOWN_NO}';
        /* areaSelect.grid='${sessionScope.UserInfo.GRID_NO}'; */
        areaSelect.initAreaSelect();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });
    }


    var curr_time = new Date();
    var url4data_list = '<e:url value="/pages/telecom_Index/channel_sandtable/channel_action/channel_portraitAction.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, query_flag=2, query_sort = '0', eaction = "business_locations_data_list",acct_mon='',flag = 1;
    var city_id_temp = '${param.city_id}';
    console.log(city_id_temp);
    var bureau_id_temp = '${param.bureau_id}';
    console.log(bureau_id_temp);
    var branch_id_temp = '${param.branch_id}';
    console.log(branch_id_temp);
    var grid_id_temp = '${param.grid_id}';
    console.log(grid_id_temp);

    var entity_channel_type = "";
    var saleType = "";

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

    //var init_tab_height = 0;

    var table_rows_array = "";
    var table_rows_array_small_screen = [30,35,45];
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

        initAreaSelect();
        //query();

        var init_tab_height = document.body.offsetHeight*0.94 - $(".big_table_title1").height() - $(".search1").height() - $(".all_count1").height() - $(".tab_head1").height();
        if(query_type=="")
        	init_tab_height -= 27;
        $(".t_body1").css("height", init_tab_height);
        //init_tab_height = document.body.offsetHeight*0.94 - $(".big_table_title").height() - $(".search").height() - $("#big_table_change").height() - $("#big_table_content").height() -68;
        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('.t_body1').scroll(function () {
            //alert($(this).scrollLeft());
            $('#import_tab').css('margin-left', -($('.t_body1').scrollLeft()));

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

        /*if("${param.query_type}"!=""){
            $("#closeTab1").show();
        }else
            $("# Tab1").hide();*/
        $("#closeTab1").unbind();
        $("#closeTab1").on("click",function(){
        	if("${param.query_type}"!="")
            parent.closeDetail();
           else
           	closeDetail();
        });

        $("#big_table_collect_type span").eq(0).click();

        resetSelectFunc();
    });

    function resetSelectFunc(){
        if(user_level==2){
          $("#cityNo").removeAttr("disabled");
          $("#centerNo").attr("disabled","disabled");
          $("#gridNo").attr("disabled","disabled");
        }else if(user_level==3){
          $("#centerNo").removeAttr("disabled");
          $("#gridNo").attr("disabled","disabled");
        }
        if(query_type!=''){
          $('#saleTypeNo').val(query_type);
          if(org_id!=""){
            if(flag_level=="1"){
                $("#cityNo").removeAttr("disabled");
                $("#areaNo").change();
            }else if(flag_level=="2"){
                $("#centerNo").removeAttr("disabled");
                $("#cityNo").change();
            }
          }
        }else{
            query();
        }
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
        //acct_month = getPreMonth(beginDate);
        city_id_temp = $.trim($("select[name='areaNo']").val());
        bureau_id_temp =$.trim($("select[name='cityNo']").val());
        branch_id_temp = $.trim($("select[name='centerNo']").val());
        grid_id_temp = $.trim($("select[name='gridNo']").val());
        entity_channel_type = $.trim($("select[name='channelTypeNo']").val());
        saleType = $.trim($("select[name='saleTypeNo']").val());
        channelName = $.trim($("#storeName").val());
        acct_mon = '${default_acct_mon}';
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
            "acct_month":acct_mon,
            "flag": flag,
            "page": page,
            //region_id: global_region_id,
            "query_flag": 5,
            "query_sort": 0,
            //query_sort: query_sort,
            "region_id": city_id_temp,
            "cityNo":bureau_id_temp,
            "centerNo":branch_id_temp,
            "entity_channel_type":entity_channel_type,
            "saleType": saleType,
            "channelName":channelName,
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
                var branch_no_tmp = d.BRANCH_NO;
                var branch_name_tmp = d.BRANCH_NAME;
                var bureau_no_tmp = d.BUREAU_NO;
                var bureau_name_tmp = d.BUREAU_NAME;
                if(branch_no_tmp == "" || branch_no_tmp == null){
                    branch_no_tmp = " ";
                }
                if(branch_name_tmp == "" || branch_name_tmp == null){
                    branch_name_tmp = " ";
                }
                if(bureau_no_tmp == "" || bureau_no_tmp == null){
                    bureau_no_tmp = " ";
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

                newRow += "<td style='text-align:center;'>" + d.LATN_NAME + "</td>" +
                "<td>" + name_fmt(bureau_name_tmp) +
                "</td><td title='"+branch_name_tmp+"'>" + name_fmt(branch_name_tmp) +
                //"</td><td><a style='cursor: pointer;' onclick=\"insideToChannel('"+ d.LATN_ID+"','"+ d.LATN_NAME+"','"+ bureau_no_tmp +"','"+ bureau_name_tmp+"','"+branch_no_tmp+"','"+branch_name_tmp+"','"+d.CHANNEL_NBR+"')\">" + name_fmt(d.CHANNEL_NAME) + "</a>"+
                "</td><td title='"+d.CHANNEL_NAME+"' style='padding-left:10px;'><a style='cursor: pointer;' onclick=\"insideToChannel('"+ d.LATN_ID+"','"+ d.LATN_NAME+"','"+ bureau_no_tmp +"','"+ bureau_name_tmp+"','','','"+d.CHANNEL_NBR+"')\">" + name_fmt(d.CHANNEL_NAME) + "</a>"+
                "</td><td>"+ filterNull(d.ENTITY_CHANNEL_TYPE_NAME) + "</a>"+

                "</td><td>" + toDecimal(d.CUR_MONTH_SUM_JF) +
                "</td><td>" + toDecimal(filterNull(d.CUR_MONTH_AVE_JF)) +
                "</td><td>" + toDecimal(filterNull(d.CUR_DAY_JF)) +
                "</td><td>" + toDecimal(filterNull(d.CUR_DAY_AVE_JF)) +

                "</td><td>" + d.CUR_MONTH_FZ +
                "</td><td>" + d.CUR_MONTH_FZ_YD +
                "</td><td>" + d.CUR_MONTH_FZ_KD +
                "</td><td>" + d.CUR_MONTH_FZ_ITV +

                "</td><td>" + d.CUR_DAY_FZ +
                "</td><td>" + d.CUR_DAY_FZ_YD +
                "</td><td>" + d.CUR_DAY_FZ_KD +
                "</td><td>" + d.CUR_DAY_FZ_ITV +

                "</td><td>" + d.CUR_MON_ACTIVE_RATE +
                "</td><td>" + d.CUR_MON_ACTIVE_USER +
                "</td><td>" + d.CUR_MON_BILLING_RATE +
                "</td><td>" + d.CUR_MON_BILLING_USER +
                "</td><td>" + d.CUR_MON_REMOVE_RATE +
                "</td><td>" + d.CUR_MON_REMOVE_USER +
                "</td><td>" + d.CUR_MON_WORTH_RATE +
                "</td><td>" + d.CUR_MON_NEW_FZ +

                "</td><td>" + d.CUR_MON_BENEFIT_RATE +
                "</td><td><span class=\"too_long\">" + d.CUR_MON_INCOME+
                "</span></td><td><span class=\"too_long\">" + d.CUR_MON_CB +

                "</span></td></tr>";

                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan=10 >没有查询到数据</td></tr>")
            }
        });
    }
    function insideToChannel(latn_id,latn_name,bureau_no,bureau_name,branch_no,branch_name,c_id){
    		if(query_type!=""){
    			parent.global_current_city_id = latn_id;
	        parent.global_current_full_area_name = latn_name;
	        parent.global_bureau_id = "";
	        parent.global_position.splice(1,1,latn_name);
	        if($.trim(bureau_no)=="" || $.trim(bureau_name)==""){
		        parent.global_current_area_name = latn_name;
		        parent.global_position.splice(2,1,"");
		        parent.global_position.splice(3,1,"");
		        parent.global_position.splice(4,1,"");
		        parent.global_current_flag = 2;
	        }else if($.trim(branch_no)=="" || $.trim(branch_name)==""){
	        	parent.global_bureau_id = bureau_no;
	        	parent.global_substation = "";
		        parent.global_current_full_area_name = bureau_name;
		        parent.global_current_area_name = bureau_name;
		        parent.global_position.splice(2,1,bureau_name);
		        parent.global_position.splice(3,1,"");
		        parent.global_position.splice(4,1,"");
		        parent.global_current_flag = 3;
	        }else if($.trim(branch_no)!="" || $.trim(branch_name)!=""){
	        	parent.global_bureau_id = bureau_no;
	        	parent.global_substation = branch_no;
		        parent.global_current_full_area_name = branch_name;
		        parent.global_current_area_name = branch_name;
		        parent.global_position.splice(2,1,bureau_name);
		        parent.global_position.splice(3,1,branch_name);
		        parent.global_position.splice(4,1,"");
	        	parent.global_current_flag = 4;
	        }
	    		parent.updateTabPosition(parent.global_current_flag);
	    		parent.updatePosition(parent.global_current_flag);

	        parent.global_entrance_type = "channel";
	        parent.global_channel_id = c_id;
	        parent.load_map_view();
	        parent.toGIS();
    		}else{
    			global_current_city_id = latn_id;
	        global_current_full_area_name = latn_name;
	        global_bureau_id = "";
	        global_position.splice(1,1,latn_name);
	        if($.trim(bureau_no)=="" || $.trim(bureau_name)==""){
		        global_current_area_name = latn_name;
		        global_position.splice(2,1,"");
		        global_position.splice(3,1,"");
		        global_position.splice(4,1,"");
		        global_current_flag = 2;
	        }else if($.trim(branch_no)=="" || $.trim(branch_name)==""){
	        	global_bureau_id = bureau_no;
	        	global_substation = "";
		        global_current_full_area_name = bureau_name;
		        global_current_area_name = bureau_name;
		        global_position.splice(2,1,bureau_name);
		        global_position.splice(3,1,"");
		        global_position.splice(4,1,"");
		        global_current_flag = 3;
	        }else if($.trim(branch_no)!="" || $.trim(branch_name)!=""){
	        	global_bureau_id = bureau_no;
	        	global_substation = branch_no;
		        global_current_full_area_name = branch_name;
		        global_current_area_name = branch_name;
		        global_position.splice(2,1,bureau_name);
		        global_position.splice(3,1,branch_name);
		        global_position.splice(4,1,"");
	        	global_current_flag = 4;
	        }
	    		updateTabPosition(global_current_flag);
	    		updatePosition(global_current_flag);

	        global_entrance_type = "channel";
	        global_channel_id = c_id;
	        load_map_view();
	        toGIS();
    		}
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

  //获取上月
	function getPreMonth(date) {
        //var arr = date.split('-');
        var year = date.substring(0, 4);    //获取当前日期的年份
        var month = date.substring(4, 6);    //获取当前日期的月份

        var year2 = year;
        var month2 = parseInt(month) - 1;
        if (month2 == 0) {
            year2 = parseInt(year2) - 1;
            month2 = 12;
        }
        if (month2 < 10) {
            month2 = '0' + month2;
        }
        var t2 = year2 +""+ month2 ;
        //alert(t2);
        //$("#preMonth").val(t2);
        return t2;
    }

  	//格式化名称
	  function name_fmt(text){
	       var len = text.length;   //当前HTML对象text的长度
	       if(len>17){
	           var str="";
	           str=text.substring(0,17)+"...";  //使用字符串截取，获取前30个字符，多余的字符使用“......”代替
	           //$(this).html(str);                   //将替换的值赋值给当前对象
	           return str;
	       }else{
	    	   return text;
	       }
	    }
</script>
</html>