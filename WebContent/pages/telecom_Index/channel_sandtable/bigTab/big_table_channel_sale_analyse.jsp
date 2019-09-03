<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="acctDayobj">
    select substr(const_value,0,4)||'-'||substr(const_value,5) val from ${easy_user}.sys_const_table where const_type = 'var.dss32' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="initMonth">${acctDayobj.VAL}</e:set>
<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT T.latn_id CODE, T.latn_name TEXT,LATN_ORD FROM  ${channel_user}.tb_gis_channel_org T
    WHERE T.latn_id IS NOT NULL
    <e:if condition="${param.city_id !=null && param.city_id  ne ''}">
        and T.latn_id = '${param.city_id}'
    </e:if>
    group by T.latn_id, T.latn_name,LATN_ORD
    ORDER BY  LATN_ORD
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT  T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.city_ord FROM  ${channel_user}.tb_gis_channel_org T
    WHERE T.latn_id IS NOT NULL

    <e:if condition="${param.bureau_id !=null && param.bureau_id  ne ''}">
        and T.latn_id = '${param.city_id}'
        and T.bureau_no = '${param.bureau_id}'
    </e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.city_ord
    ORDER BY  T.city_ord
</e:q4l>

<e:description>渠道类型</e:description>
<e:q4l var="channelTypeList">
		select ' ' code,'全部' text from dual
		union all
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
    <title>实体渠道网点销量分析</title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <script src='<e:url value="resources/app/areaSelect.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/font-color.css?version=New Date()" />'  rel="stylesheet" type="text/css"
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
            width:auto;
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
        .search_compon {width:16%;}
        .search_compon select {width:90%;}
        .textbox,.textbox-text{background:none!important;border:0px;}
        .download_btn1 {
            /*background: url(icons/excel.png) no-repeat center left;*/
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
        .t_body {overflow-y: scroll;border-bottom:1px solid #333399;}
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
        .textbox.combo.datebox {border:1px solid #3E4997!important;}
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

        .index_col {width:10%!important;}
        #org1 {width:10%;}
        #org2 {width:15%;}
    </style>
</head>
<body>
<div class="sub_box grab_tab">
<div class="close_button" id="closeTab"></div>
    <div style="height:96.5%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>实&nbsp;体&nbsp;渠&nbsp;道&nbsp;网&nbsp;点&nbsp;销&nbsp;量&nbsp;分&nbsp;析</h4></div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <table cellspacing="0" cellpadding="0" class="search" style="background: transparent!important;">
                    <tr style="height:40px;">
                        <td class="search_head" style="width:100px;">
                            <span>账&emsp;&emsp;期：</span>
                        </td>
                        <td class="search_compon" style="width:250px;">
                            <input id="selectMonth" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
                        </td>

                        <!--<div id="areaNoDiv">
				                    <td class="search_head city_comp_sel">分&nbsp;&nbsp;公&nbsp;&nbsp;司：</td>
				                    <td class="search_compon city_comp_sel">
				                        <%--<e:select id="areaNo" name="areaNo"
				                                  items="${areaList.list}" label="TEXT" value="CODE"  class="easyui-combobox" headLabel="全省" headValue="" defaultValue="${param.city_id}"
				                                  style="width:129px" editable="false"/>--%>
				                         <select id="areaNo" name="areaNo" class="trans_condition"></select>
				                    </td>
				                </div>

				                <div id="cityNoDiv" >
				                    <td class="search_head bureau_comp_sel">县&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;区：</td>
				                    <td class="search_compon bureau_comp_sel">
				                        <%--<e:select id="cityNo" name="cityNo"
				                                  items="${cityList.list}" label="TEXT" value="CODE"  class="easyui-combobox"
				                                  headLabel="全部" headValue=""  style="width:129px" editable="false"/>--%>
				                         <select id="cityNo" name="cityNo" class="trans_condition"></select>
				                    </td>
				                </div>-->
                        <td class="search_head" style="width:100px;"><span>渠道类型：</span></td>
                        <td class="search_compon" style="width:250px;">
                            <select id="channelTypeNo" name="channelTypeNo" class="trans_condition"></select>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                    		<td class="area_select_bq search_head" style="width:100px;"><span>分&ensp;公&ensp;司：</span></td>
                        <td class="area_select_bq" colspan="4">
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
                        </td>
                    </tr>
                </table>
                <div class="all_count" style="font-size:13px;">总记录数：<span id="all_count"></span></div>
                <div class="sub_b">
                    <div style="padding-right:7px;background: none;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width:100%;">
                            <thead>
                                <tr>
                                    <th style="width:3%;">序号</th>
                                    <th id="org1">分公司</th>
                                    <th id="org2">县局</th>
                                    <!--<th rowspan="2">网点总数</th>-->
                                    <th class="index_col">门店数</th>
                                    <th class="index_col">零销门店数</th>
                                    <th class="index_col">零销占比</th>
                                    <th class="index_col">低销门店数</th>
                                    <th class="index_col">低销占比</th>
                                    <th class="index_col">高销门店数</th>
                                    <th class="index_col">高销占比</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" style="overflow-x:auto!important;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list" style="width:100%;">
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
    var url4data = '<e:url value="pages/telecom_Index/channel_sandtable/bigTab/big_table_channel_sale_analyse_tabData.jsp" />';
    var seq_num = 0, begin_scroll = 0, page = 0, eaction = "list", acct_mon='';
    var city_id_temp = '${param.city_id}';
    var bureau_id_temp = '${param.bureau_id}';
    var channelTypeJSON = ${e:java2json(channelTypeList.list)};
    //var branch_id_temp = '${param.branch_id}';
    //var grid_id_temp = '${param.grid_id}';
    var user_level = '${sessionScope.UserInfo.LEVEL}';

    var areaJSON=${e:java2json(areaList.list)};
    var cityJSON = ${e:java2json(cityList.list)};

    //if(city_id_temp=="")
    //city_id_temp = city_id_for_village_tab_view;
       city_id_temp ='999';
    //else
     //   city_id_for_village_tab_view = city_id_temp;
     if(user_level==2)
     	city_id_temp = "${sessionScope.UserInfo.AREA_NO}";
    //如果已经没有数据, 则不再次发起请求.

    var init_tab_height = 0;
    var open_win_handler = "";

    var table_rows_array = "";
    var table_rows_array_small_screen = [25,35,45];
    var table_rows_array_big_screen = [35,45,55];

    var show_bureau = 0;
    var compon_type = 1;

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

        //区域控制 js 加载
        var areaSelect=new AreaSelect();
        areaSelect.areaJSON=areaJSON;
        areaSelect.cityJSON=cityJSON;

        /* areaSelect.gridJSON=gridJSON; */
        areaSelect.areaName='areaNoDiv';
        areaSelect.cityName='cityNoDiv';
        /* areaSelect.gridName='gridNoDiv'; */
        areaSelect.isDivDis=false;
        areaSelect.isNoDis=true;
        areaSelect.role=roleName;
        areaSelect.area='${sessionScope.UserInfo.AREA_NO}';
        areaSelect.city='${sessionScope.UserInfo.CITY_NO}';
        /* areaSelect.grid='${sessionScope.UserInfo.GRID_NO}'; */
        areaSelect.initAreaSelect();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });
    }

    //var long_message_width = 0;
    $(function(){
    	if(compon_type==1){
    		$(".city_comp_sel").hide();
    		$(".bureau_comp_sel").hide();
    		$(".area_select_bq").show();
    	}else{
    		$(".city_comp_sel").show();
    		$(".bureau_comp_sel").show();
    		$(".area_select_bq").hide();
    	}
    	if(!show_bureau){
    		$(".bureau_head").hide();
    		$(".bureau_compon").hide();
    	}
    	initAreaSelect();
    	$.each(channelTypeJSON, function(){
		    $('#channelTypeNo').append('<option value ="'+this.CODE+'">'+this.TEXT+'</option>');
		 	});
		 	$('#channelTypeNo').change(function(){
				query();
	    });
    	$("#org2").hide();
			$("#org1").addClass("org_name");
      init_tab_height = document.body.offsetHeight*0.94 +10 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height();

      initCitySelect(user_level);
      citySelectCss(city_id_temp);

      initTabHeight();

      //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
      $('.t_body').scroll(function () {
          $('#table_head').css('margin-left', -($('.t_body').scrollLeft()));
          $('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
      });
      $('#tbody2').scroll(function () {
          $('#table_head2').css('margin-left', -($('#tbody2').scrollLeft()));
      });
      $("#closeTab").on("click",function(){
          load_map_view();
      });

      //日期控件
	    var db = $("#selectMonth");

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
	        },
	        editable: false,
	        onChange:function(){
	            try{
	                query();
	            }catch(e){

	            }
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
	        var dt = $.trim('${initMonth}');//秒表
	        var date = "";
	        if(dt=="" || dt=="0" || dt=="1" || dt=="2"){
	            dt = new Date();
	            date = dt.getFullYear()+"-"+("0"+(dt.getMonth()+1)).slice(-2);
	        }else
	            date = dt;
	        var date_arry = date.split("-");
	        var year = date_arry[0];
	        var mm = date_arry[1];
	        db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
	    }

    });

    function initTabHeight(){
        init_tab_height = document.body.offsetHeight*0.94 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".all_count").height() - $("#table_head").height() -25;
        $(".t_body").css("max-height", init_tab_height);
    }

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
        listScroll(true);
    }

    $(".t_body").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                page++;
                listScroll(false);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function listScroll(flag) {
    		var params = getParams();
        var $list = $("#big_tab_info_list");

        $.post(url4data, params, function (data) {
            data = $.parseJSON(data);
          	if(page == 0){
                if (data.length) {
                    $("#all_count").html(data[0].C_NUM);
                } else {
                    $("#all_count").html('0');
                }
            }

            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];

              	var newRow = "<tr>";

              	var org_id = "";
              	var org_id2 = "";

                newRow += "<td style='width:3%'>"+ (++seq_num) +"</td>";

                if(params.flg=="1"){
                	newRow += "<td class=\"org_name\" style=\"width:10%;\">"+ d.REGION_NAME +"</td>";
                	org_id = d.REGION_ID;
                	if(org_id=="000")
                		org_id = "";
                }
                if(params.flg=="2"){
                	org_id = d.REGION_ID;
                	if(i==0)
                		newRow += "<td class=\"org_name1\" colspan=2 >"+ d.REGION_NAME +"</td>";
                	else{
                		org_id2 = d.BUREAU_NO;
                		newRow += "<td class=\"org_name1\" style=\"width:10%;\">"+ d.REGION_NAME +"</td>";
                		newRow += "<td class=\"org_name2\" style=\"width:15%;\">"+ d.BUREAU_NAME +"</td>";
                	}
                }

                newRow += "<td class=\"index_col\">"+ d.CHANNEL_NUM +"</td>";

                //newRow += "<td class=\"index_col\"><a class=\"clickable\" href=\"javascript:void(0)\" onclick=\"toDetail('"+org_id+"','"+org_id2+"',0,'"+params.flg+"')\">"+ d.ZERO_SALE_CHANNEL +"</a></td>";
                newRow += "<td class=\"index_col\" style=\"color:#4CB9F9!important;\">"+ d.ZERO_SALE_CHANNEL +"</td>";
                newRow += "<td class=\"index_col\">"+ d.ZERO_RATE +"</td>";

                //newRow += "<td class=\"index_col\"><a class=\"clickable\" href=\"javascript:void(0)\" onclick=\"toDetail('"+org_id+"','"+org_id2+"',1,'"+params.flg+"')\">"+ d.LOW_SALE_CHANNEL +"</a></td>";
                newRow += "<td class=\"index_col\" style=\"color:#4CB9F9!important;\">"+ d.LOW_SALE_CHANNEL +"</td>";
                newRow += "<td class=\"index_col\">"+ d.LOW_RATE +"</td>";

                //newRow += "<td class=\"index_col\"><a class=\"clickable\" href=\"javascript:void(0)\" onclick=\"toDetail('"+org_id+"','"+org_id2+"',2,'"+params.flg+"')\">"+ d.HIGH_CHANNEL +"</a></td>";
                newRow += "<td class=\"index_col\" style=\"color:#4CB9F9!important;\">"+ d.HIGH_CHANNEL +"</td>";
                newRow += "<td class=\"index_col\">"+ d.HIGH_RATE +"</td>";

                "</tr>";
                $list.append(newRow);
            }
            //只有第一次加载没有数据的时候显示如下内容
            if (data.length == 0 && flag) {
              $list.empty();
              $list.append("<tr><td style='text-align:center' colspan=9 >没有查询到数据</td></tr>")
            }
        });
    }

    function getParams(){
    	selectMonth = $("#selectMonth").datebox("getValue").replace(/-/g, "");//$('#selectMonth').datebox('getValue').replace(/-/g, "");
    	//city_id_temp = $.trim($("select[name='areaNo']").val());
      bureau_id_temp =$.trim($("select[name='cityNo'] option:selected").val());
      entity_channel_type = $.trim($("select[name='channelTypeNo'] option:selected").val());
      if(city_id_temp=="999")
      	city_id_temp = "";
  		if(city_id_temp!="")
  			$("#org2").show();
  		else
  			$("#org2").hide();
  		return {
  			"eaction":eaction,
  			"acct_month":selectMonth,
  			"flg":(bureau_id_temp!=""?3:(city_id_temp!=""?2:1)),
  			"pageSize":table_rows_array[0],
  			"page":page,
  			"city_id":city_id_temp,
  			"bureau_no":bureau_id_temp,
  			"channel_type":entity_channel_type
  		};
    }

    function clear_data() {
        seq_num = 0, begin_scroll = 0, page = 0;
        $("#big_tab_info_list").empty();
    }

    function initCitySelect(user_level){
        if(user_level>1){
            console.log("changeBureauSelect");
            //initTabHeight_city();
            citySelectCss(city_id_temp);
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
        $(".bureau"+bureau_id_temp).addClass("selected");
        $(".bureau"+bureau_id_temp).siblings().removeClass("selected");
    }
    // function font_important_formatter(value,rowData){
    //     return "<span style=\"color:#FE7A23;\">"+value+"</span>";
    // }

    function backup(level){
        initListDiv(1);
    }
    function closeDetail(){
        $("#detail_div > iframe").empty();
        $("#detail_div").hide();
        $("#list_div").show();
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
		    if(user_level>1)
		        return;
		    city_id_temp = city_id;
		    if(city_id_temp=='999')
		    	city_id_temp = "";

		    citySelectCss(city_id);
		  	query();
		}
    function bureauSwitch(bureau_id){
	      if(user_level>2)
	          return;
	      bureau_id_temp = bureau_id;
	      bureauSelectCss(bureau_id_temp);
	      query();
    }

		function toDetail(org_id,org_id2,type,flag_temp){
				$("#list_div").hide();
        $("#detail_div").show();
        var channelTypeNo = $.trim($("select[name='channelTypeNo']").val());
				var selectMonth = $("#selectMonth").datebox("getValue").replace(/-/g, "");
        $("#detail_div > iframe").attr("src",'<e:url value="/pages/telecom_Index/channel_sandtable/bigTab/big_table_business_locations.jsp" />'+'?org_id='+org_id+'&org_id2='+org_id2+'&flag='+flag_temp+'&query_type='+type+'&comp_type='+channelTypeNo+'&comp_date='+selectMonth);
		}
    //Excel文件下载
    function doExcel() {
        var beginDate = $('#selectMonth').datebox('getValue').replace(/-/g, "");

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