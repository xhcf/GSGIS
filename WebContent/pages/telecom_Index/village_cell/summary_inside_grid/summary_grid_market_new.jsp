<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
   select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '6'
</e:q4o>
<html>
<head>
    <title>市场标签</title>
    <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.1"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <style>
        .clickable_room a {
            color: blue;
            cursor: pointer;
            text-decoration: underline;
        }
        .red_font {color:red;}

        /*网格*/
        #tab1_thead tr th:first-child{width:6%;}
        #tab1_thead tr th:nth-child(2){width:21%;}
        #tab1_thead tr th:nth-child(3){width:11%;}
        #tab1_thead tr th:nth-child(4){width:9%;}
        #tab1_thead tr th:nth-child(5){width:11%;}
        #tab1_thead tr th:nth-child(6){width:11%;}
        #tab1_thead tr th:nth-child(7){width:9%;}
        #tab1_thead tr th:nth-child(8){width:11%;}
        #tab1_thead tr th:nth-child(9){width:11%;}

        #tab1_tbody tr td:first-child{width:6%;}
        #tab1_tbody tr td:nth-child(2){width:21%;}
        #tab1_tbody tr td:nth-child(3){width:11%;}
        #tab1_tbody tr td:nth-child(4){width:9%;}
        #tab1_tbody tr td:nth-child(5){width:11%;}
        #tab1_tbody tr td:nth-child(6){width:11%;}
        #tab1_tbody tr td:nth-child(7){width:9%;}
        #tab1_tbody tr td:nth-child(8){width:11%;}
        #tab1_tbody tr td:nth-child(9){width:11%;}

        /*行政村*/
        #tab2_thead tr th:first-child{width:7%;}
        #tab2_thead tr th:nth-child(2){width:22%;}
        #tab2_thead tr th:nth-child(3){width:11%;}
        #tab2_thead tr th:nth-child(4){width:11%;}
        #tab2_thead tr th:nth-child(5){width:9%;}
        #tab2_thead tr th:nth-child(6){width:9%;}
        #tab2_thead tr th:nth-child(7){width:9%;}
        #tab2_thead tr th:nth-child(8){width:11%;}
        #tab2_thead tr th:nth-child(9){width:11%;}

        #tab2_tbody tr td:first-child{width:7%;}
        #tab2_tbody tr td:nth-child(2){width:22%;}
        #tab2_tbody tr td:nth-child(3){width:11%;}
        #tab2_tbody tr td:nth-child(4){width:11%;}
        #tab2_tbody tr td:nth-child(5){width:9%;}
        #tab2_tbody tr td:nth-child(6){width:9%;}
        #tab2_tbody tr td:nth-child(7){width:9%;}
        #tab2_tbody tr td:nth-child(8){width:11%;}
        #tab2_tbody tr td:nth-child(9){width:11%;}

        /*用户*/
        #tab3_thead tr th:first-child{width:5%;}
        #tab3_thead tr th:nth-child(2){width:10%;}
        #tab3_thead tr th:nth-child(3){width:13%;}
        #tab3_thead tr th:nth-child(4){width:9%;}
        #tab3_thead tr th:nth-child(5){width:13%;}
        #tab3_thead tr th:nth-child(6){width:24%;}
        #tab3_thead tr th:nth-child(7){width:36%;}

        #tab3_tbody tr td:first-child{width:5%;}
        #tab3_tbody tr td:nth-child(2){width:10%;}
        #tab3_tbody tr td:nth-child(3){width:13%;}
        #tab3_tbody tr td:nth-child(4){width:9%;}
        #tab3_tbody tr td:nth-child(5){width:13%;}
        #tab3_tbody tr td:nth-child(6){width:24%;}
        #tab3_tbody tr td:nth-child(7){width:36%;text-align:left;}

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

        #tab2_text,#tab3_text {
            width:30%;
        }
    </style>
    <script>
    var url_summary_vc_grid = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_grid_village_cell.jsp" />';
    var url_summary_inside_vc_grid = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_inside_grid_vc.jsp" />';
    var condition = '${param.condition}';
    var grid_id_short = '${param.grid_id_short}';
    $(function(){
        //支局名赋值
        $("#market_org_name").text(grid_name);
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
                }else if(index==3){
                    load_tab3();
                    //load_village_list('resident_village', 'resident_grid_id');
                    //load_resident();
                }
            });
        });
        //默认先加载第一个标签的数据
        var tab_index = "${param.tab_index}";
        if(tab_index==0){
            $("#span_switch span").eq(0).click();
        }/*else if(tab_index==1){
            $("#span_switch span").eq(1).click();
        }*/else if(tab_index==1){
            $("#span_switch span").eq(2).click();
        }else if(tab_index==2){
            $("#span_switch span").eq(3).click();
        }else{
            $("#span_switch span").eq(0).click();
        }

        //tab1_scroll();
        tab2_scroll();
        tab3_scroll();
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

    function load_tab0(){
        tab0_index();
        tab0_bar();
    }

    function tab0_index(){
        $.post(url_summary_vc_grid,{"eaction":"get_info_all","grid_id_short":grid_id_short},function(data){
            var data = $.parseJSON(data);
            if(data.length){
                var d = data[0];
                $("#market_rate").text(d.MARKET_RATE);
                $("#market_zhu_hu_cnt").text(d.HOUSEHOLD_NUM);
                $("#market_popul_cnt").text(d.POPULATION_NUM);
                $("#market_h_user_cnt").text(d.H_USE_CNT);
                $("#market_she_dui_cnt").text(d.BRIGADE_ID_CNT);
                $("#market_unreach_she_dui_cnt").text(d.RESOURCE_UNREACH_CNT);
            }else{
                $("#market_rate").text("");
                $("#market_zhu_hu_cnt").text("");
                $("#market_popul_cnt").text("");
                $("#market_h_user_cnt").text("");
                $("#market_she_dui_cnt").text("");
                $("#market_unreach_she_dui_cnt").text("");
            }
        });
        //行政村数
        $.post(url_summary_vc_grid,{"eaction":"getVillageCellCnt","grid_id_short":grid_id_short},function(data){
            var d = $.parseJSON(data);
            if(d!=null){
                $("#market_vc_cnt").text(d.VC_CNT);
            }else{
                $("#market_vc_cnt").text("0");
            }
        });
    }


    //加载 统计—市场占有率柱形图
	function tab0_bar(){
        $.post(url_summary_inside_vc_grid,{"eaction":"summary_bar",grid_id_short:grid_id_short},function(data){
            var month=[];
            var rate=[];
            var data = $.parseJSON(data);
            for(var i=0;i<data.length;i++){
                month.push(data[i].MONTH_CODE);
                rate.push(data[i].USE_RATE);
            }

            var myChart = echarts.init(document.getElementById('summary_right'));
            option = {
                title: {
                    text: '宽带渗透率月趋势',
                    textStyle:{
                        //文字颜色
                        color:'#000',
                        //字体风格,'normal','italic','oblique'
                        fontStyle:'normal',
                        //字体粗细 'normal','bold','bolder','lighter',100 | 200 | 300 | 400...
                        fontWeight:'700',
                        //字体大小
                        fontSize:14,
                        fontFamily:'Microsoft Yahei'
                    },
                    left: 'center'
                },
                color: ['#3398DB'],
                tooltip : {
                    show:false
                },
                grid: {
                    top:'10%',
                    left: '0%',
                    right: '0%',
                    bottom: '15%',
                    containLabel: true
                },
                xAxis : [
                    {
                        type : 'category',
                        data :month,
                        axisTick: {
                            alignWithLabel: true
                        }
                    }
                ],
                yAxis : [
                    {
                        type : 'value',
                        axisLabel: {
                            formatter: '{value} %'
                        },
                        splitLine:{
                            show:false,
                        },
                    }
                ],
                series : [
                    {
                        name:'渗透值',
                        type:'bar',
                        barWidth: '40%',
                        label:{
                            normal:{
                                show:true,
                                position: 'top' ,
                                textStyle : {
                                    fontWeight : 500 ,
                                    fontSize : 12,    //文字的字体大小
                                    color:'#000'
                                },
                                formatter: '{c}%'
                            }
                        },
                        data: rate
                    }
                ]
            };
            myChart.setOption(option);
        });
    }

    //网格经理暂不用
    function load_tab1(){
        clear_data1();
        load_data_list1(0,1);
    };

    //tab1滚动加载 3
    //表格数据加载 1/3
    var begin_scroll = "";//滚动延迟，防止滚动中频繁加载
    var seq_num1 = 0,page1 = 0;
    //page 页码    flag 第一次加载时1否则0
    function load_data_list1(page,flag){
        var $list = $("#tab1_tbody");
        $.post(url_summary_inside_vc_grid,{"eaction":"market_grid","substation":substation,"page": page},function(data){
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
                row += "<td>" + (++seq_num1) + "</td>";
                row += "<td><a href=\"javascript:void(0);\"  >" + d.GRID_NAME + "</a></td>";
                row += "<td class='head_table_color'>" + d.MARKET_RATE + "</td>";
                row += "<td>" + d.HOUSEHOLD_NUM + "</td>";
                row += "<td>" + d.H_USE_CNT +"</td>";
                row += "<td class='head_table_color'>" + d.PORT_LV + "</td>";
                row += "<td>" + d.CAPACITY + "</td>";
                row += "<td>" + d.ACTUALCAPACITY+"</td>";
                row += "<td>" + d.FREE_PORT + "</td>";
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
        seq_num1 = 0, page1 = 0;
        $("#tab1_tbody").empty();
    }

    //滚动加载 3/3
    function tab1_scroll(){
        $("#tab1_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();
            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll > 500) {
                    load_data_list1(++page1,0);
                }
                begin_scroll = new Date().getTime();
            }
        });
    }

    //第二个页签
    function load_tab2(){
        clear_data2();
        load_data_list2(0,1);
    }

    //tab2滚动加载 3
    //表格数据加载 1/3
    var seq_num2 = 0,page2 = 0,tab2_text = "";
    function load_data_list2(page,flag){
        var $list = $("#tab2_tbody");
        $.post(url_summary_inside_vc_grid,{"eaction":"market_vc","grid_id_short":grid_id_short,"page":page,"tab2_text":tab2_text},function(data){
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
                row += "<td>"+ d.VILLAGE_NAME +"</td>";
                row += "<td>"+ d.MARKET_RATE +"</td>";
                row += "<td>"+ d.H_USE_CNT +"</td>";
                row += "<td>"+ d.BRIGADE_ID_CNT +"</td>";
                row += "<td>"+ d.HOUSEHOLD_NUM +"</td>";
                row += "<td>"+ d.POPULATION_NUM +"</td>";
                row += "<td>"+ d.PORT_LV +"</td>";
                row += "<td>"+ d.ACTUALCAPACITY +"</td>";
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
    function clear_data2(){
        seq_num2 = 0, page2 = 0, tab2_text = "";
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
        tab2_text = $("#tab2_text").val();
        load_data_list2(0,1);
    }

    //第三个页签
    function load_tab3(){
        load_data_list3(0,1);
    }

    //tab2滚动加载 3
    //表格数据加载 1/3
    var seq_num3 = 0,page3 = 0,tab3_text = "";
    function load_data_list3(page,flag){
        var $list = $("#tab3_tbody");
        $.post(url_summary_inside_vc_grid,{"eaction":"market_user","grid_id_short":grid_id_short,"page":page,"tab3_text":tab3_text},function(data){
            var objs = $.parseJSON(data);
            if(page==0){
                if(objs.length){
                    $("#recode_count3").text(objs[0].C_NUM);
                }else{
                    $("#recode_count3").text("0");
                }
            }
            for(var i = 0,l = objs.length;i<l;i++){
                var d = objs[i];
                var row = "<tr>";
                row += "<td>"+ (++seq_num3) +"</td>";
                row += "<td>"+ name(d.SERV_NAME) +"</td>";
                row += "<td>"+ phoneHide(d.ACC_NBR) +"</td>";
                row += "<td>"+ d.STOP_TYPE_NAME +"</td>";
                row += "<td>"+ phoneHide(d.USER_CONTACT_NBR) +"</td>";
                row += "<td>"+ d.EQP_NO +"</td>";
                row += "<td>"+ addr(d.ADDRESS) +"</td>";
                row += "</tr>";
                $list.append(row);
            }

            if(objs.length==0 && flag){
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan='7' \">没有查询到数据</td></tr>")
            }
        });
    }
    //清理数据，初始化参数 2/3
    function clear_data3(){
        seq_num3 = 0, page3 = 0, tab3_text = "";
        $("#tab3_tbody").empty();
    }
    //滚动加载 3/3
    function tab3_scroll(){
        $("#tab3_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();

            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll_village > 500) {
                    load_data_list3(++page2,0);
                }
                begin_scroll_village = new Date().getTime();
            }
        });
    }

    function tab3_query(){
        clear_data3();
        tab3_text = $("#tab3_text").val();
        load_data_list3(0,1);
    }

  </script>
</head>
<body>
    <div id="market_org_name" class="sub_name"></div>

    <div class="tab_head" id="span_switch">
      <span>统计</span> <span style="display: none;">网格</span> <span>行政村</span> <span>用户</span>
    </div>

    <div class="tab_body" id="div_switch">
      <div class="div_show div_0">
        <!--统计标签页内容 -->
        <div class="summary_content">
          <div id="summary_left">
            <div class="summary_left_title">
              光宽渗透率：<span id="market_rate">-</span>
            </div>
            <div class="summary_left_cont">
              <ul>
                <li class="p_date">住户数：<span id="market_zhu_hu_cnt"></span></li>
                <li class="p_date">人口数：<span id="market_popul_cnt"></span></li>
                <li class="p_date">光宽用户数：<span id="market_h_user_cnt"></span></li>
              </ul>
              <ul>
                <li class="p_date">行政村数：<span id="market_vc_cnt"></span></li>
                <li class="p_date">社队数：<span id="market_she_dui_cnt"></span></li>
                <li class="p_date">资源未达社队数：<span id="market_unreach_she_dui_cnt"></span></li>
              </ul>
            </div>
          </div>
          <div id="summary_right">
          </div>
        </div>
      </div>
      <div class="div_hide div_1" style="display: none;">
        <!--网格标签页内容 -->
        <div class="grid_count_title">记录数：<span id="recode_count1"></span></div>
        <div class="grid_datagrid">
          <div class="head_table_wrapper">
            <table class="head_table" id="tab1_thead">
              <tr>
                <th>序号</th>
                <th>网格名称</th>
                <th class="head_table_sort">市场渗透率</th>
                <th>住户数</th>
                <th>光宽用户数</th>
                <%--<th style="width: 65px;">政企<br>住户数</th>
                <th style="width: 65px;">政企光宽<br>用户数</th>--%>
                <th>端口占有率</th>
                <th>端口数</th>
                <th>占用端口数</th>
                <th>空闲端口数</th>
              </tr>
            </table>
          </div>
          <div class="t_table div_line_0" id="tab1_scroll" style="margin:0 auto;">
            <table class="content_table grid_detail_in" id="tab1_tbody" style="width:100%;">
            </table>
          </div>
        </div>
      </div>
      <div class="div_hide div_2" style="display: none;">
        <!--行政村标签页内容start -->
        <div id="village_query" class="resident_wrapper">
          行政村: <input type="text" id="tab2_text" />
          <button class="button_click" onclick="tab2_query()" >查询</button>
        </div>
          <!--
        <div class="summary_day_head tab_accuracy_head" id="market_village_pselect">
          <span class="active">全部<span id="market_village_a_count"></span></span><span> 高渗透率<span id="market_village_h_count"></span></span><span> 中渗透率<span id="market_village_m_count"></span></span><span> 低渗透率<span id="market_village_l_count"></span></span>
        </div>
        -->
        <div class="grid_count_title">记录数:<span id="recode_count2"></span></div>
        <div class="village_datagrid">
          <div class="head_table_wrapper">
            <table class="head_table" id="tab2_thead">
              <tr>
                <th>序号</th>
                <th>行政村</th>
                <th>宽带渗透率</th>
                <th>光宽用户数</th>
                <th>社队数</th>
                <th>住户数</th>
                <th>人口数</th>
                <th>端口占用率</th>
                <th>占用端口数</th>
              </tr>
            </table>
          </div>
          <div class="t_table div_line_1" id="tab2_scroll" style="margin:0 auto;">
            <table class="content_table village_detail_in" id="tab2_tbody" style="width:100%;">
            </table>
          </div>
        </div>
        <!--小区标签页内容end -->
      </div>
      <div class="div_hide div_3" style="display: none;">
        <!--用户标签页内容 -->
        <div class="resident_wrapper">
          <div id="resident">
              查询条件: <input type="text" id="tab3_text" placeholder="输入用户名或号码进行查询" />
              <button class="button_click" onclick="tab3_query()" >查询</button>
          </div>
        </div>
        <div class="grid_count_title">记录数:<span id="recode_count3"></span></div>
        <div class="resident_datagrid">
          <div class="head_table_wrapper">
            <table class="head_table" id="tab3_thead">
              <tr>
                  <th>序号</th>
                  <th>用户名称</th>
                  <th>接入号码</th>
                  <th>用户状态</th>
                  <th>联系电话</th>
                  <th>OBD设备</th>
                  <th>安装地址</th>
              </tr>
            </table>
          </div>
          <div class="t_table div_line_1" id="tab3_scroll" style="margin:0px auto;">
            <table class="content_table resident_detail_in" id="tab3_tbody" style="width:100%;">
            </table>
          </div>
        </div>
      </div>
    </div>

</body>
</html>