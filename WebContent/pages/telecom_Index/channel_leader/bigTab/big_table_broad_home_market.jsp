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
    <title>宽带覆盖情况--省级用户</title>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
    <!-- echarts 3.2.3 -->
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css"/>?version=1.1' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/lead_tab.css?version=1.1" />'  rel="stylesheet" type="text/css"
          media="all">
    <style>
        #tab_div .table1 tr td{
            width: 80px;
        }
        .table1, .table1 th, .table1 td{
            border-color:#12489a;
        }
        #table_head1 th, #big_table_content1 th{
            background: #0b0a8a;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="sub_box">
    <div class="close_button" id="closeTab"></div>
    <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
        <div class="big_table_title"><h4>宽&nbsp;带&nbsp;家&nbsp;庭&nbsp;渗&nbsp;透&nbsp;率</h4></div>
         <div style="color:#FFFFFF; width:400px" class="databox_">
			  <span style ="font-weight:700;font-size:14px;">账&nbsp;&nbsp;&nbsp;&nbsp;期：</span><input id="beginDate" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
		</div>
        <div class="tabs_change" id="collect_tabs_change"></div>
        <div class="tab_box table_cont_wrapper">
            <div class="sub_">
                <div class="sub_b">
                    <div class="all_count right">总记录数：<span id="all_count"></span></div>
                     <e:if condition="${!empty sessionScope.UserInfo.CAN_DOWNLOAD_PERMISSIONS && sessionScope.UserInfo.LEVEL eq '1'}">
                    	<div class="download_btn" id ="download_div"><a href="javascript:doExcel()"><span style ="color:#FFFFFF;">报表导出</span></a></div>
                     </e:if>
                    <div style="margin-right: 14px;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
                            <thead>
                            <tr>
                                <th width="50"><div>序号</div></th>
                                <th width="141"><div>地域</div></th>
                                <th width="85" onclick="query_list_sort()" style="cursor: pointer"><div>累计到达<br>渗透率<span class='sort_icon'></span></div></th>
                                <th width="80" formatter="formatterper2"><div>本月提升</div></th>
                                <th width="80"><div>本年提升</div></th>
                                <th width="80">小区数</th>
                                <th width="80">住户数</th>
                                <th width="80">光宽用户数</th>
                                <th width="80">高渗透率<br>小区</th>
                                <th width="80">占比</th>
                                <th width="80">中渗透率<br>小区</th>
                                <th width="80">占比</th>
                                <th width="80">中低渗透率<br>小区</th>
                                <th width="80">占比</th>
                                <th width="80">低渗透率<br>小区</th>
                                <th width="80">占比</th>
                            </tr>
                            </thead>
                        </table>
                        <table cellspacing="0" cellpadding="0" class="table1" id="table_head1" style="width: 100%;">
                            <thead>
                            <tr>
                                <th width="50"><div>序号</div></th>
                                <th width="80">分公司</th>
                                <th width="150"><div>小区名称</div></th>
                                <th width="95" onclick="query_list_sort()" style="cursor: pointer"><div>累计到达<br>渗透率<span class='sort_icon'></span></div></th>
                                <th width="90" formatter="formatterper2"><div>本月提升</div></th>
                                <th width="90"><div>本年提升</div></th>
                                <th width="90">住户数</th>
                                <th width="90">光宽用户数</th>
                                <th width="90">政企住户</th>
                                <th width="90">政企宽带</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="t_body" id="broad_home_table" style="overflow-y:scroll;">
                        <table cellspacing="0" cellpadding="0" class="table1" id="broad_home_tab_list" style="width: 100%">
                        </table>
                        <table cellspacing="0" cellpadding="0" class="table1" id="broad_home_tab_list1" style="width: 100%">
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
var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_flag, query_sort = '0';
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
            load_list();
		}
	});
    //初始化账期日为前一天
	$("#beginDate").datebox("setValue",'${initTime}');

    $(".t_body").css("max-height", document.body.offsetHeight*0.94 - 156 - $("#big_table_content").height());
    //$(".table1:eq(1)").width($(".table1:eq(0)").width()+2);
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

function load_list() {
	//账期
	var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
	//alert(beginDate);
    var params = {
        eaction: 'broad_home_list',
        beginDate:beginDate,
        flag: global_current_flag,
        page: 0,
        region_id: global_region_id,
        query_flag: query_flag,
        query_sort: query_sort,
        city_id: global_current_city_id,
        pageSize: table_rows_array[0]
    }
	listScroll(params, true);
}

$("#broad_home_table").scroll(function () {
	//账期
	var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
    var viewH = $(this).height();
    var contentH = $(this).get(0).scrollHeight;
    var scrollTop = $(this).scrollTop();
    if (scrollTop / (contentH - viewH) >= 0.95) {
      if (new Date().getTime() - begin_scroll > 500) {
          var params = {
              eaction: 'broad_home_list',
              beginDate:beginDate,
              page: ++page_list,
              flag: global_current_flag,
              region_id: global_region_id,
              query_flag: query_flag,
              query_sort: query_sort,
              city_id: global_current_city_id,
              pageSize: table_rows_array[0]
          }
          listScroll(params, false);
      }
      begin_scroll = new Date().getTime();
    }
});

function listScroll(params, flag) {
    var $list = "";
    if(query_flag=='5'){//小区数据
        $list = $("#broad_home_tab_list1");
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
                    var newRow = "<tr><td style='width: 50px;text-align:center;'>" + (++seq_num) + "</td>";
                    newRow += "<td style='width: 80px;text-align:center;'>" + d.AREA_DESC1 + "</td>"
                    newRow += "<td style='width: 150px;text-align:left;'>" + d.AREA_DESC + "</td>"
                    newRow += "<td style='width: 95px;color: #fa8513'>" + d.BROAD_PENETRANCE +
                    "</td><td style='width: 90px;'>" + d.FILTER_MON_RATE +
                    "</td><td style='width: 90px;'>" + d.FILTER_YEAR_RATE +
                    "</td><td style='width: 90px;'>" + d.GZ_ZHU_HU_COUNT +
                    "</td><td style='width: 90px;'>" + d.GZ_H_USE_CNT +
                    "</td><td style='width: 90px;'>" + d.GOV_ZHU_HU_COUNT +
                    "</td><td style='width: 90px'>" + d.GOV_H_USE_CNT +
                    "</td></tr>";
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
    }else{
        $list = $("#broad_home_tab_list");
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
                    var newRow = "<tr><td style='width:50px;text-align:center;'>" + (++seq_num) + "</td>";
                    if (query_flag == '1') {
                        newRow += "<td style='width: 141px;text-align:center;'>" + d.AREA_DESC + "</td>"
                    } else {
                        newRow += "<td style='width: 141px;text-align:left;'>" + d.AREA_DESC + "</td>"
                    }

                    newRow += "<td style='width: 85px;color: #fa8513'>" + d.BROAD_PENETRANCE +
                    "</td><td>" + d.FILTER_MON_RATE + "</td><td>" + d.FILTER_YEAR_RATE +
                    "</td><td>" + d.VILLAGE_CNT + "</td><td>" + d.GZ_ZHU_HU_COUNT +
                    "</td><td>" + d.GZ_H_USE_CNT +
                    "</td><td style='width: 80px'>" + d.HIGH_FILTER_VILLAGE_CNT +
                    "</td><td>" + d.HIGH_FILTER_RATE + "</td><td style='width: 80px'>" + d.MID_FILTER_VILLAGE_CNT +
                    "</td><td>" + d.MID_FILTER_RATE + "</td><td style='width: 80px'>" + d.LOW_FILTER_VILLAGE_CNT +
                    "</td><td>" + d.LOW_FILTER_RATE + "</td><td style='width: 80px;color:#fa8513'>" + d.LOW_10_FILTER_VILLAGE_CNT +
                    "</td><td>" + d.LOW_10_FILTER_RATE + "</td></tr>";
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
}

function clear_data() {
	begin = 0,end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,//query_flag = global_current_flag,
	query_sort = '0';
	$("#broad_home_tab_list").empty();
}

function clear_dataBySelDay() {
	begin = 0,end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0,
	//query_flag = global_current_flag, query_sort = '0';
	query_sort = '0';
	if(query_flag == '1' || query_flag == '2' || query_flag == '3' || query_flag == '4'){
		$("#broad_home_tab_list").empty();
	}else if(query_flag=='5'){
		$("#broad_home_tab_list1").empty();
	}
}

function change_region(type) {
    $(".tabs_change div").eq(type - global_current_flag).addClass("active").siblings().removeClass("active");
	clear_data();
	query_flag = type;
    generate_tab();
	load_list();
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
	   //下载的文件名称拼接
       var fileName = '宽带家庭渗透率_'+region +"_"+beginDate+'.xlsx';

	   var url = "<e:url value='market_ExcelDownload.e?beginDate="+beginDate+"&flag="+flag+"&page="+0+"&region_id="+global_region_id+"&query_flag="+query_flag+"&query_sort="+query_sort+"&city_id="+global_current_city_id+"&pageSize="+table_rows_array[0]+"'/>";
	   $.messager.progress({ // 显示进度条
           text: "导出中,请等待...",
           interval: 100
       });

       var is_success= '1';

       $.post(url,{},function(data){
           //生成操作日志
           var info = {};
           info.rpt_name ='宽带家庭渗透率';
           info.exp_filename = fileName;
           info.exp_status = is_success;

           //用来传输相应的参数
           var postUrl="<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_download_log.jsp'/>?eaction=insertLog";
           $.post(postUrl,info,function(data){
           });
           $.messager.progress('close');//进度条关闭
       });

       var a = document.createElement('a');
       a.download = fileName;
       a.href = url+"&file=1";
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
	       info.rpt_name ='宽带家庭渗透率';
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