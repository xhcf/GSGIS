<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%--行政村选择 --%>
<e:q4l var="vc_options">
    select DISTINCT village_id id,village_name name from EDW.VW_TB_CDE_VILLAGE@GSEDW where GRID_ID = '${param.grid_id_short}' order by village_name
</e:q4l>
<e:q4o var="last_month">
   select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '6'
</e:q4o>
<html>
<head>
    <title>资源标签</title>
    <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.1"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <style>
        .clickable_room a {
            color: blue;
            cursor: pointer;
            text-decoration: underline;
        }
        .red_font {color:red;}

        /*行政村*/
        #tab0_thead tr th:first-child{width:8%;}
        #tab0_thead tr th:nth-child(2){width:20%;}
        #tab0_thead tr th:nth-child(3){width:12%;}
        #tab0_thead tr th:nth-child(4){width:12%;}
        #tab0_thead tr th:nth-child(5){width:12%;}
        #tab0_thead tr th:nth-child(6){width:12%;}
        #tab0_thead tr th:nth-child(7){width:12%;}
        #tab0_thead tr th:nth-child(8){width:12%;}

        #tab0_tbody tr td:first-child{width:8%;}
        #tab0_tbody tr td:nth-child(2){width:20%;}
        #tab0_tbody tr td:nth-child(3){width:12%;}
        #tab0_tbody tr td:nth-child(4){width:12%;}
        #tab0_tbody tr td:nth-child(5){width:12%;}
        #tab0_tbody tr td:nth-child(6){width:12%;}
        #tab0_tbody tr td:nth-child(7){width:12%;}
        #tab0_tbody tr td:nth-child(8){width:12%;}

        /*社队*/
        #tab1_thead tr th:first-child{width:8%;}
        #tab1_thead tr th:nth-child(2){width:20%;}
        #tab1_thead tr th:nth-child(3){width:12%;}
        #tab1_thead tr th:nth-child(4){width:12%;}
        #tab1_thead tr th:nth-child(5){width:12%;}
        #tab1_thead tr th:nth-child(6){width:12%;}
        #tab1_thead tr th:nth-child(7){width:12%;}
        #tab1_thead tr th:nth-child(8){width:12%;}

        #tab1_tbody tr td:first-child{width:8%;}
        #tab1_tbody tr td:nth-child(2){width:20%;}
        #tab1_tbody tr td:nth-child(3){width:12%;}
        #tab1_tbody tr td:nth-child(4){width:12%;}
        #tab1_tbody tr td:nth-child(5){width:12%;}
        #tab1_tbody tr td:nth-child(6){width:12%;}
        #tab1_tbody tr td:nth-child(7){width:12%;}
        #tab1_tbody tr td:nth-child(8){width:12%;}

        /*OBD*/
        #tab2_thead tr th:first-child{width:8%;}
        /*#tab2_thead tr th:nth-child(2){width:12%;}
        #tab2_thead tr th:nth-child(3){width:12%;}*/
        #tab2_thead tr th:nth-child(2){width:31%;}
        #tab2_thead tr th:nth-child(3){width:31%;}
        #tab2_thead tr th:nth-child(4){width:10%;}
        #tab2_thead tr th:nth-child(5){width:10%;}
        #tab2_thead tr th:nth-child(6){width:10%;}

        #tab2_tbody tr td:first-child{width:8%;}
        /*#tab2_tbody tr td:nth-child(2){width:12%;}
        #tab2_tbody tr td:nth-child(3){width:12%;}*/
        #tab2_tbody tr td:nth-child(2){width:31%;}
        #tab2_tbody tr td:nth-child(3){width:31%;}
        #tab2_tbody tr td:nth-child(4){width:10%;}
        #tab2_tbody tr td:nth-child(5){width:10%;}
        #tab2_tbody tr td:nth-child(6){width:10%;}

        .div_line_0 {height:372px;}
        @media screen and (max-height: 800px){
            .div_line_0 {
                height: 260px;
            }
        }
        .div_line_1 {height:312px;}
        @media screen and (max-height: 800px){
            .div_line_1 {
                height: 200px;
            }
        }
        #tab1_text,#tab2_text {
            width:30%;
        }
    </style>
    <script>
    var url_summary_vc_grid = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_grid_village_cell.jsp" />';
    var url_summary_inside_vc_grid = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_inside_grid_vc.jsp" />';
    var condition = '${param.condition}';
    var grid_id_short = '${param.grid_id_short}';
    var default_option = "<option value=''>全部</option>";
    $(function(){
        //支局名赋值
        $("#org_name").text(grid_name);
        //标签页切换事件
        $("#span_switch > span").each(function (index) {
            $(this).on("click", function () {
                $(this).addClass("active").siblings().removeClass("active");
                var $show_div = $(".div_" + index);
                $show_div.show();
                $("#div_switch").children().not($show_div).hide();
                if(index==0){
                    load_tab0();
                }else if(index==1){
                    load_tab1();
                }else if(index==2){
                    load_tab2();
                }
            });
        });
        //默认先加载第一个标签的数据
        var tab_index = "${param.tab_index}";
        if(tab_index==0){
            $("#span_switch span").eq(0).click();
        }else if(tab_index==1){
            $("#span_switch span").eq(1).click();
        }else if(tab_index==2){
            $("#span_switch span").eq(2).click();
        }else{
            $("#span_switch span").eq(0).click();
        }

        tab0_scroll();
        tab1_scroll();
        tab2_scroll();
    });

    /*$(function() {
    	$("#market_village_pselect > span").each(function(index) {
    		$(this).on("click", function () {
    			$(this).addClass("active").siblings().removeClass("active");
    			clear_data();
    			market_pselect = index;
    			load_tab2(1);
    		})
    	})
    	$("#market_build_pselect > span").each(function(index) {
            $(this).on("click", function () {
            	$(this).addClass("active").siblings().removeClass("active");
                clear_data();
                market_pselect = index;
                load_build(1);
            })
        })
    })*/

    var begin_scroll = "";//滚动延迟，防止滚动中频繁加载

    /*第一个页签*/
    function load_tab0(){
        clear_data0();
        load_data_list0(0,1);
    };

    //tab1滚动加载 3
    //表格数据加载 1/3
    var seq_num0 = 0,page0 = 0;
    //page 页码    flag 第一次加载时1否则0
    function load_data_list0(page,flag){
        var $list = $("#tab0_tbody");
        $.post(url_summary_inside_vc_grid,{"eaction":"resource_vc","grid_id_short":grid_id_short,"page": page},function(data){
            var objs = $.parseJSON(data);
            if(page==0){
                if(objs.length){
                    $("#recode_count0").text(objs[0].C_NUM);
                }else{
                    $("#recode_count0").text("0");
                }
            }
            for(var i = 0,l = objs.length;i<l;i++){
                var d = objs[i];
                var row = "<tr>";
                row += "<td>" + (++seq_num0) + "</td>";
                row += "<td><a href=\"javascript:void(0);\">" + d.ORG_NAME + "</a></td>";
                row += "<td>" + d.ALL_OBD_CNT + "</td>";
                row += "<td>" + d.LOBD_CNT + "</td>";
                row += "<td>" + d.HOBD_CNT +"</td>";
                row += "<td class='head_table_color'>" + d.PORT_LV + "</td>";
                row += "<td>" + d.PORT_CNT + "</td>";
                row += "<td>" + d.USE_PORT_CNT+"</td>";
                row += "</tr>";
                $list.append(row);
            }

            if(objs.length==0 && flag){
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan='9' \">没有查询到数据</td></tr>")
            }
        });
    }

    //清理数据，初始化参数 2/3
    function clear_data0(){
        seq_num0 = 0, page0 = 0;
        $("#tab0_tbody").empty();
    }

    //滚动加载 3/3
    function tab0_scroll(){
        $("#tab0_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();
            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll > 500) {
                    load_data_list0(++page0,0);
                }
                begin_scroll = new Date().getTime();
            }
        });
    }

    //第二个页签
    function load_tab1(){
        clear_data1();
        load_data_list1(0,1);
    }

    //tab2滚动加载 3
    //表格数据加载 1/3
    var seq_num1 = 0,page1 = 0,tab1_text = "";
    function load_data_list1(page,flag){
        var $list = $("#tab1_tbody");
        $.post(url_summary_inside_vc_grid,{"eaction":"resource_she_dui","grid_id_short":grid_id_short,"page":page,"tab1_text":tab1_text},function(data){
            var objs = $.parseJSON(data);
            if(page==0){
                if(objs.length){
                    $("#recode_count1").text(objs[0].C_NUM);
                }else{
                    $("#recode_count1").text("0");
                }
            }
            for(var i = 0,l = objs.length;i<l;i++){
                var d = objs[i];
                var row = "<tr>";
                row += "<td>" + (++seq_num1) +"</td>";
                row += "<td>" + d.ORG_NAME +"</td>";
                row += "<td>" + d.ALL_OBD_CNT +"</td>";
                row += "<td>" + d.LOBD_CNT +"</td>";
                row += "<td>" + d.HOBD_CNT +"</td>";
                row += "<td class='head_table_color'>" + d.PORT_LV +"</td>";
                row += "<td>" + d.PORT_CNT +"</td>";
                row += "<td>" + d.USE_PORT_CNT +"</td>";
                row += "</tr>";
                $list.append(row);
            }

            if(objs.length==0 && flag){
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan='9' \">没有查询到数据</td></tr>")
            }
        });
    }
    //清理数据，初始化参数 2/3
    function clear_data1(){
        seq_num1 = 0, page1 = 0, tab1_text = "";
        $("#tab1_tbody").empty();
    }
    //滚动加载 3/3
    function tab1_scroll(){
        $("#tab1_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();

            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll_village > 500) {
                    load_data_list1(++page2,0);
                }
                begin_scroll_village = new Date().getTime();
            }
        });
    }

    function tab1_query(){
        clear_data1();
        tab1_text = $("#tab1_text").val();
        load_data_list1(0,1);
    }

    //第三个页签
    var seq_num2 = 0,page2 = 0,tab2_text = "",tab2_select = "";

    function load_tab2(){
        init_option2();
        load_data_list2(0,1);
    }

    function init_option2(){
        $("#tab2_select").append(default_option);
        var json = ${e:java2json(vc_options.list)};
        for(var i = 0,l = json.length;i<l;i++){
            var item = json[i];
            var option = "<option value='"+item.ID+"'>"+item.NAME+"</option>";
            $("#tab2_select").append(option);
        }
        $("#tab2_select").on("change",function(){
            tab2_query();
        });
    }

    function get_option(){
        tab2_select = $("#tab2_select option:selected").val();
        tab2_text = $("#tab2_text").val();
    }

    //tab2滚动加载 3
    //表格数据加载 1/3
    function load_data_list2(page,flag){
        var $list = $("#tab2_tbody");
        $.post(url_summary_inside_vc_grid,{"eaction":"resource_obd","grid_id_short":grid_id_short,"page":page,"tab2_select":tab2_select,"tab2_text":tab2_text},function(data){
            var objs = $.parseJSON(data);
            if(page==0){
                if(objs.length){
                    $("#recode_count2").text(objs[0].C_NUM);
                }else{
                    $("#recode_count2").text("0");
                }
            }
            for(var i = 0,l = objs.length;i<l;i++){
                var d = objs[i];
                var row = "<tr>";
                row += "<td>"+ (++seq_num2) +"</td>";
                /*row += "<td>"+ d.VILLAGE_NAME +"</td>";
                row += "<td>"+ d.BRIGADE_NAME +"</td>";*/
                row += "<td>"+ d.EQP_NO +"</td>";
                row += "<td>"+ d.ADDRESS +"</td>";
                row += "<td>"+ d.CAPACITY +"</td>";
                row += "<td>"+ d.ACTUALCAPACITY +"</td>";
                row += "<td>"+ d.RATE +"</td>";
                row += "</tr>";
                $list.append(row);
            }

            if(objs.length==0 && flag){
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan='6' \">没有查询到数据</td></tr>")
            }
        });
    }
    //清理数据，初始化参数 2/3
    function clear_data2(){
        seq_num2 = 0, page2 = 0, tab2_text = "", tab2_select = "";
        $("#tab2_tbody").empty();
    }
    //滚动加载 3/3
    function tab2_scroll(){
        $("#tab2_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();

            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll_village > 500) {
                    load_data_list2(++page2,0);
                }
                begin_scroll_village = new Date().getTime();
            }
        });
    }

    function tab2_query(){
        clear_data2();
        get_option();
        load_data_list2(0,1);
    }
  </script>
</head>
<body>
    <div id="org_name" class="sub_name"></div>

    <div class="tab_head" id="span_switch">
      <span class="active">行政村</span> <span>社队</span> <span>OBD</span>
    </div>

    <div class="tab_body" id="div_switch">
      <div class="div_hide div_0">
        <!--网格标签页内容 -->
        <div class="grid_count_title">记录数：<span id="recode_count0"></span></div>
        <div class="grid_datagrid">
          <div class="head_table_wrapper">
            <table class="head_table" id="tab0_thead">
              <tr>
                <th>序号</th>
                <th>行政村</th>
                <th>OBD数</th>
                <th>零低OBD数</th>
                <th>高占OBD数</th>
                <th>端口占有率</th>
                <th>端口数</th>
                <th>占用端口数</th>
              </tr>
            </table>
          </div>
          <div class="t_table div_line_0" id="tab0_scroll" style="margin:0 auto;">
            <table class="content_table grid_detail_in" id="tab0_tbody" style="width:100%;">
            </table>
          </div>
        </div>
      </div>
      <div class="div_hide div_1" style="display: none;">
        <!--行政村标签页内容start -->
        <div id="village_query" class="resident_wrapper">
            查询条件: <input type="text" id="tab1_text" placeholder="输入社队名称进行查询" />
          <button class="button_click" onclick="tab1_query()" >查询</button>
        </div>
          <!--
        <div class="summary_day_head tab_accuracy_head" id="market_village_pselect">
          <span class="active">全部<span id="market_village_a_count"></span></span><span> 高渗透率<span id="market_village_h_count"></span></span><span> 中渗透率<span id="market_village_m_count"></span></span><span> 低渗透率<span id="market_village_l_count"></span></span>
        </div>
        -->
        <div class="grid_count_title">记录数:<span id="recode_count1"></span></div>
        <div class="village_datagrid">
          <div class="head_table_wrapper">
            <table class="head_table" id="tab1_thead">
              <tr>
                <th>序号</th>
                <th>社队名称</th>
                <th>OBD数</th>
                <th>零低OBD数</th>
                <th>高占OBD数</th>
                <th>端口占有率</th>
                <th>端口数</th>
                <th>占用端口数</th>
              </tr>
            </table>
          </div>
          <div class="t_table div_line_1" id="tab1_scroll" style="margin:0 auto;">
            <table class="content_table village_detail_in" id="tab1_tbody" style="width:100%;">
            </table>
          </div>
        </div>
        <!--小区标签页内容end -->
      </div>
      <div class="div_hide div_2" style="display: none;">
        <!--用户标签页内容 -->
        <div class="resident_wrapper">
          <div id="resident">
              行政村：<select id="tab2_select"></select>
              查询条件: <input type="text" id="tab2_text" placeholder="请输入obd编号或安装地址进行查询" />
              <button class="button_click" onclick="tab2_query()" >查询</button>
          </div>
        </div>
        <div class="grid_count_title">记录数:<span id="recode_count2"></span></div>
        <div class="resident_datagrid">
          <div class="head_table_wrapper">
            <table class="head_table" id="tab2_thead">
              <tr>
                  <th>序号</th>
                  <%--<th>行政村</th>
                  <th>社队</th>--%>
                  <th>OBD编号</th>
                  <th>安装地址</th>
                  <th>端口号</th>
                  <th>占用端口数</th>
                  <th>端口占用率</th>
              </tr>
            </table>
          </div>
          <div class="t_table div_line_1" id="tab2_scroll" style="margin:0px auto;">
            <table class="content_table resident_detail_in" id="tab2_tbody" style="width:100%;">
            </table>
          </div>
        </div>
      </div>
    </div>

</body>
</html>