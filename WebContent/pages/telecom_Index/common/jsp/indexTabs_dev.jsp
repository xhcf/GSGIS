<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="yesterday">
    select to_char((to_date(min(const_value), 'yyyymmdd')),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="lastMonth">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '3'
</e:q4o>
<e:q4o var="date_in_month">
    SELECT
    TO_CHAR(TO_DATE(MON_A, 'yyyymmdd'), 'yyyymmdd') AS CURRENT_FIRST,
    '${yesterday.val}' AS CURRENT_LAST,
    TO_CHAR(TO_DATE(MON_B, 'yyyymmdd'), 'yyyymmdd') AS LAST_FIRST,
    TO_CHAR(LAST_DAY(TO_DATE(MON_B, 'yyyymmdd')), 'yyyymmdd') AS LAST_LAST
    FROM (SELECT TO_CHAR(TO_DATE('${yesterday.val}', 'yyyymmdd'), 'yyyymm') || '01' MON_A,
    TO_CHAR(ADD_MONTHS(TO_DATE('${yesterday.val}', 'yyyymmdd'), -1),
    'yyyymm') || '01' MON_B
    FROM DUAL)
</e:q4o>

<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
<link href='<e:url value="/pages/telecom_Index/common/css/indexTabs_dev.css?version=1.1"/>' rel="stylesheet" type="text/css" media="all"/>
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<script type="text/javascript">
$(document).ready(function(){
$("body").height($(window).height());
})
</script>
<body style="width:100%;border:0px;" class="g_target">
<h1></h1>
<div class="target_wrap">
    <ul class="target_list">
        <li>
            <p class="target_title">市场</p>
            <dl>
                <dt id="t1" onMouseOver="javascript:show(this,'mydiv1');" onMouseOut="hide(this,'mydiv1')">- -</dt>
                <dd>- -</dd>
                <dd>- -
                    <b class=""></b>
                </dd>
            </dl>
        </li>
        <li>
            <p class="target_title">收入</p>
            <dl>
                <dt id="t2" onMouseOver="javascript:show(this,'mydiv2');" onMouseOut="hide(this,'mydiv2')">- -</dt>
                <dd>- -</dd>
                <dd>- -
                    <b class=""></b>
                </dd>
            </dl>
        </li>
        <li class="b_none">
            <p class="target_title">利润</p>
            <dl>
                <dt id="t3" onMouseOver="javascript:show(this,'mydiv3');" onMouseOut="hide(this,'mydiv3')">- -</dt>
                <dd>- -</dd>
                <dd>- -
                    <b class=""></b>
                </dd>
            </dl>
        </li>
    </ul>
</div>

<div class="target_wrap" style="position: relative;height:34%;width: 98%;">
    <div class="title_pos">日发展趋势</div>
    <div class="btn_c">
        <ul id="tab_btn">
            <li class="btn_uc" data="0">
                <input type="button" value="移动" style="color: #fff;cursor:pointer;"/>
            </li>
            <li class="btn_uc" data="1">
                <input type="button" value="宽带" style="color: #fff;cursor:pointer;"/>
            </li>
            <li class="btn_uc" data="2">
                <input type="button" value="ITV" style="color: #fff;cursor:pointer;"/>
            </li>
        </ul>
    </div>
    <div class="figure" id="day_fz1"></div>
</div>

<div class="target_wrap" style=" border:none;height:28%">
    <ul class="target_tab">
        <li class="clearfix">
            <p>用户发展</p>
            <span id="user_proc">
	        	<b>移动当月<font>- -</font></b>
	        	<b>环比：<font>- -</font></b>
	        	<b>宽带当月<font>- -</font></b>
				<b>环比：<font>- -</font></b>
	        	<b>ITV&nbsp;当月<font>- -</font></b>
				<b>环比：<font>- -</font></b>
	        </span>
        </li>
        <li class="clearfix">
            <p>终端销售</p>
            <span id="terminal_sale">
	        	<b>当月新增(部):<font>- -</font></b>
	        	<b>智能机(部)：<font>- -</font></b>
	        	<b>800M(部)：<font>- -</font></b>
	        </span>
        </li>
    </ul>
</div>

<div id="mydiv1" style="position:absolute;display:none;border:1px solid #333333;background:rgba(0,0,0,0.9);height: 28px;padding-top: 5px;padding-bottom:5px;padding-left: 5px;padding-right:5px;color: #fff;font-size: 12px;text-align: center;-webkit-border-radius: 4px;-moz-border-radius: 4px;-o-border-radius: 4px;border-radius: 4px;">
    市场占有率
</div>
<div id="mydiv2" style="position:absolute;display:none;border:1px solid #333333;background:rgba(0,0,0,0.9);height: 28px;padding-top: 5px;padding-bottom:5px;padding-left: 5px;padding-right:5px;color: #fff;font-size: 12px;text-align: center;-webkit-border-radius: 4px;-moz-border-radius: 4px;-o-border-radius: 4px;border-radius: 4px;">
    收入进度
</div>
<div id="mydiv3" style="position:absolute;display:none;border:1px solid #333333;background:rgba(0,0,0,0.9);height: 28px;padding-top: 5px;padding-bottom:5px;padding-left: 5px;padding-right:5px;color: #fff;font-size: 12px;text-align: center;-webkit-border-radius: 4px;-moz-border-radius: 4px;-o-border-radius: 4px;border-radius: 4px;">
    本年累计利润(万元)
</div>

<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
<!-- echarts 3.2.3 -->
<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
<%--<script src='<e:url value="/pages/telecom_Index/js/freshTab.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshChart.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshRank.js"/>' charset="utf-8"></script>--%>
<script>
    var parent_name = parent.global_parent_area_name;
    var city_full_name = parent.global_current_full_area_name;
    var city_name = parent.global_current_area_name;
    var city_id = parent.global_current_city_id;
    var index_type = parent.global_current_index_type;
    var flag = parent.global_current_flag;
    var url4echartmap = parent.url4echartmap;
    parent.global_position.splice(0, 1, province_name);
    parent.updatePosition(flag);

    /*var last_month_first = parent.last_month_first;
    var last_month_last = parent.last_month_last;
    var current_month_first = parent.current_month_first;
    var current_month_last = parent.current_month_last;*/
    var last_month_first = '${date_in_month.LAST_FIRST}';
    var last_month_last = '${date_in_month.LAST_LAST}';
    var current_month_first = '${date_in_month.CURRENT_FIRST}';
    var current_month_last = '${date_in_month.CURRENT_LAST}';

    var url4Query = parent.url4Query;

    var myChart = "";

    var substation = parent.global_substation;

    //鼠标悬浮显示和离开不现实
    function show(obj,id) {
        var objDiv = $("#"+id+"");
        $(objDiv).css("display","block");
        $(objDiv).css("left", event.clientX);
        $(objDiv).css("top", event.clientY + 10);
    }
    function hide(obj,id) {
        var objDiv = $("#"+id+"");
        $(objDiv).css("display", "none");
    }

    $(function () {
        if(isIE()){
            $("#day_fz1").height($(".target_wrap").eq(1).height());
        }
        myChart = echarts.init(document.getElementById('day_fz1'));
        //echart地图下钻要加载的页面
        //freshTab(city_name,flag,url4Query);
        //freshChart(city_name,flag,index_type,last_month_first,last_month_last,current_month_first,current_month_last,url4Query);
        //freshRank(city_name);

        //var $div_li =$("div.tab_menu a");
        /*$div_li.click(function(){
         $(this).addClass("selected")            //当前<li>元素高亮
         .siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
         var index =  $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。

         $("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
         //.eq(index).show()   //显示 <li>元素对应的<div>元素
         .siblings().hide(); //隐藏其它几个同辈的<div>元素
         var index_type = $.trim($(this).html());

         //当前地图类型是echarts，改变地图显示
         /*if(global_current_map=="echarts"){
         var params = {};
         params.flag = global_current_flag;//市级
         params.index_type = global_current_index_type;
         params.city_name = global_current_full_area_name;
         doQuery(params);
         }*/
        /*	if(myChart!="")
         myChart.dispose();
         //freshChart(city_name,flag,index_type,last_month_first,last_month_last,current_month_first,current_month_last,url4Query);
         $("div.tab_box > div").eq(index).show();
         });*/

        var qx_name_temp = "";
        if (city_id == undefined) {//百度地市层点某个区县，将来要替换成分局的模块
            if (city_name_speical.indexOf(parent_name) > -1)
                qx_name_temp = parent_name.replace(/州/gi, '');
            else
                qx_name_temp = parent_name.replace(/市/gi, '');
            city_id = city_ids[qx_name_temp];
        }

        //三包发展情况 ---begion
        $.post(url4Query, {
            eaction: 'three_index',
            flag: flag,
            latn_id: city_id,
            last_month: '${lastMonth.VAL}',
            click_name: city_full_name,
            substation: substation
        }, function (data) {
            data = $.parseJSON(data);
            if (data == null) {
                return;
            }
            //市场 ----begin
            var income_divs0 = $(".target_title").eq(0).next().children();
            if(data.ZYL==null)
            	;//
            else
            	$(income_divs0[0]).html("" + data.ZYL.toFixed(2) + "%");//
            var danwei = "户";
            if (flag == 1 || flag == 2 || flag == 3)
                danwei = "万户";
            $(income_divs0[1]).html("住户数:" + (data.ADDR_NUM==null?'--':data.ADDR_NUM) + danwei);//
            $(income_divs0[2]).html("宽带数:" + (data.KD_NUM==null?'--':data.KD_NUM) + danwei);
            var b_class0 = "";
            /*var b_class1 = "b1";
             if(data.INCOME_RATIO<0){
             b_class1 = "b2";
             }*/
            $(income_divs0[2]).children("b").attr("class", b_class0);
            //市场 ----end

            //收入 ----begin
            var income_divs1 = $(".target_title").eq(1).next().children();
            $(income_divs1[0]).html("" + data.INCOME_BUDGET_FINISH_RATE.toFixed(2) + "%");//收入完成进度
            var yuan = "";
            if (flag == 1 || flag == 2 || flag == 3)
                yuan = "亿";
            else if (flag > 3) {
                yuan = "万";
            }
            $(income_divs1[1]).html("本年:" + data.Y_CUM_INCOME.toFixed(2) + yuan + "元");//本年累计收入
            $(income_divs1[2]).html("环比:" + data.INCOME_RATIO.toFixed(2) + "%");
            var b_class1 = "b1";
            if (data.INCOME_RATIO < 0) {
                b_class1 = "b2";
            }
            $(income_divs1[2]).children("b").attr("class", b_class1);
            //收入 ----end

            //利润 ----begin
            var income_divs2 = $(".target_title").eq(2).next().children();
            $(income_divs2[0]).html("" + data.OPERATE_PROFIT_MON_YEAR.toFixed(2));//经营利润:
            $(income_divs2[1]).html("本月:" + data.OPERATE_PROFIT_MON.toFixed(2) + yuan + "元");//当月利润:
            $(income_divs2[2]).html("环比:" + data.JYLRHB.toFixed(2) + "%");
            var b_class2 = "b1";
            if (data.JYLRHB < 0) {
                b_class2 = "b2";
            }
            $(income_divs2[2]).children("b").attr("class", b_class2);
            //利润 ----end
        });
        //三包发展情况 ---end

        //日发展趋势 曲线图---begin
        //曲线图 移动 每日累计
        var current_month_data0 = new Array(31);//当月
        var last_month_data0 = new Array(31);//上月
        //曲线图 宽带 每日累计
        var current_month_data1 = new Array(31);//当月
        var last_month_data1 = new Array(31);//上月
        //曲线图 ITV 每日累计
        var current_month_data2 = new Array(31);//当月
        var last_month_data2 = new Array(31);//上月
        //曲线图 x轴 日期 31天
        var day_array = new Array();
        for (var i = 0, l = current_month_data0.length; i < l; i++) {
            day_array.push(i + 1);
        }
        //默认是展现的移动标签
        var div_index_type = 0;
        //曲线图数据请求
        //当月数据
        $.post(url4Query, {
            eaction: "index_month_diff",
            region_id: city_id,
            click_name: city_full_name,
            date_start: current_month_first,
            date_end: current_month_last,
            flag: flag,
            substation: substation
        }, function (data) {
            data = $.parseJSON(data);
            for (var i = 0, l = data.length; i < l; i++) {
                var index = parseInt(data[i].STAT_DATE.substring(6));
                current_month_data0.splice(index - 1, 1, data[i].MOBILE_SERV_DAY_NEW);
                current_month_data1.splice(index - 1, 1, data[i].BRD_SERV_DAY_NEW);
                current_month_data2.splice(index - 1, 1, data[i].ITV_SERV_DAY_NEW);
            }
            //上月数据
            $.post(url4Query, {
                eaction: "index_month_diff",
                region_id: city_id,
                click_name: city_full_name,
                date_start: last_month_first,
                date_end: last_month_last,
                flag: flag,
                substation: substation
            }, function (data) {
                data = $.parseJSON(data);
                for (var i = 0, l = data.length; i < l; i++) {
                    var index = parseInt(data[i].STAT_DATE.substring(6));
                    last_month_data0.splice(index - 1, 1, data[i].MOBILE_SERV_DAY_NEW);
                    last_month_data1.splice(index - 1, 1, data[i].BRD_SERV_DAY_NEW);
                    last_month_data2.splice(index - 1, 1, data[i].ITV_SERV_DAY_NEW);
                }
                //刷新echart的曲线图
                if (div_index_type == 0)
                    freshFigue(day_array, current_month_data0, last_month_data0);
                else if (div_index_type == 1)
                    freshFigue(day_array, current_month_data1, last_month_data1);
                else if (div_index_type == 2)
                    freshFigue(day_array, current_month_data2, last_month_data2);
            });
        });
        //三个标签切换日发展趋势的曲线图变化

        function changeStyle() {
            this.onclick = function () {
                var list = this.parentNode.childNodes;
                for (var i = 0; i < list.length; i++) {
                    if (1 == list[i].nodeType) {
                        list[i].className = "btn_uc";
                    }
                }
                this.className = 'btn_active';
                var index_type = $(this).attr("data");//移动0，宽带1，itv2
                div_index_type = index_type;

                var current_month_data = "";
                var last_month_data = "";
                if (index_type == 0) {
                    current_month_data = current_month_data0;
                    last_month_data = last_month_data0;
                } else if (index_type == 1) {
                    current_month_data = current_month_data1;
                    last_month_data = last_month_data1;
                } else if (index_type == 2) {
                    current_month_data = current_month_data2;
                    last_month_data = last_month_data2;
                }
                myChart.dispose();
                myChart = echarts.init(document.getElementById('day_fz1'));
                freshFigue(day_array, current_month_data, last_month_data);
            }
        }

        var tabs = document.getElementById('tab_btn').childNodes;
        //给三个标签按钮绑定事件
        for (var i = 0; i < tabs.length; i++) {
            if (1 == tabs[i].nodeType) {
                changeStyle.call(tabs[i]);
                if ($(tabs[i]).attr("data") == 0)
                    tabs[i].className = "btn_active";
            }
        }
        //日发展趋势 曲线图---end

        //用户发展 终端销售 ---begin
        var user_proc_div = $("#user_proc");
        var terminal_sale_div = $("#terminal_sale");

        $.post(url4Query, {
            eaction: "user_proc",
            date: '${yesterday.VAL}',
            flag: flag,
            region_id: city_id,
            click_name: city_full_name,
            substation: substation
        }, function (data) {
            if (data == null) {
                return;
            }
            data = $.parseJSON(data);
            var yhfz_doms = $(user_proc_div).children();
            var zdxs_doms = $(terminal_sale_div).children();
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                //移动
                if (flag == 1 || flag == 2) {
                    yhfz_doms.eq(0).find("font").html("(万户):" + d.MOBILE_MON_CUM_NEW);
                } else {
                    yhfz_doms.eq(0).find("font").html("(户):" + d.MOBILE_MON_CUM_NEW);
                }
                yhfz_doms.eq(1).find("font").html(d.YDHB + "%");
                //宽带
                if (flag == 1 || flag == 2) {
                    yhfz_doms.eq(2).find("font").html("(万户):" + d.BRD_MON_CUM_NEW);
                } else {
                    yhfz_doms.eq(2).find("font").html("(户):" + d.BRD_MON_CUM_NEW);
                }
                yhfz_doms.eq(3).find("font").html(d.KDHB + "%");
                //ITV
                if (flag == 1 || flag == 2) {
                    yhfz_doms.eq(4).find("font").html("(万户):" + d.ITV_SERV_CUR_MON_NEW);
                } else {
                    yhfz_doms.eq(4).find("font").html("(户):" + d.ITV_SERV_CUR_MON_NEW);
                }
                yhfz_doms.eq(5).find("font").html(d.ITVHB + "%");

                zdxs_doms.eq(0).find("font").html(d.CUR_TERMINAL_TOTAL_MON);
                zdxs_doms.eq(1).find("font").html(d.CUR_ZNJ_COUNT_MON);
                zdxs_doms.eq(2).find("font").html(d.CUR_COUNT_800M_MON);
            }
        });
        //用户发展 终端销售 ---end

        //当前位置信息（甘肃省>兰州市)
        parent.updateTabPosition();

    });
    function freshFigue(day_array, current_month_data, last_month_data) {
        var option = {
            title: {
                text: ''
            },
            tooltip: {
                trigger: 'axis',
                formatter: function (params, ticket) {
                    var content = "";
                    for (var i = params.length-1; i >= 0; i--) {
                        content += params[i].seriesName + params[i].name + "号:" + (params[i].data == undefined ? "- -" : params[i].data);
                        if (i > 0) {
                            content += "<br/>";
                        }
                    }
                    return content;
                },//'{a0}{b}日:{c0}<br/>{a1}{b}日:{c1}',
                position: "top"
            },
            legend: {
                data: ['本月', '上月'],
                orient: 'horizontal',
                left: 'right',
                top: 20,

                /*right:0,
                 top:0,
                 inactiveColor:'#999',*/
                textStyle: {
                    color: '#eee'
                },
                show: true
            },
            color: ['#2f4554', '#61a0a8'],
            toolbox: {
                show: false
            },
            /*tooltip:{
             position:"top"
             },*/
            grid: {
                /*left: '3%',
                 right: '4%',
                 bottom: '3%',*/
                top: 40,
                left: 0,
                right: 0,
                bottom: 18,
                //containLabel: true,
                align: "right"
            },
            xAxis: [
                {
                    min: 1,
                    max: 31,
                    scale: 0,
                    splitNumber: 1,
                    minInterval: 1,
                    interval: 1,
                    type: 'category',

                    show: false,

                    boundaryGap: false,
                    data: day_array
                }
            ],
            yAxis: [
                {
                    silent: true,
                    splitLine: {
                        show: false
                    },
                    type: 'value'
                }
            ],
            series: [
                {
                    name: '上月',
                    type: 'line',
                    stack: '总量',
                    smooth: true,
                    itemStyle: {
                        normal: {
                            color: '#03d2e3',
                            label: {
                                show: false,
                                textStyle: {
                                    fontWeight: '700',
                                    fontSize: '0'
                                }
                            },
                            lineStyle: {
                                color: '#03d2e3',
                                width: 1
                            }
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: '#03d2e3',
                            opacity: 0.2
                        }
                    },
                    data: last_month_data
                },
                {
                    name: '本月',
                    type: 'line',
                    stack: '总量',
                    smooth: true,
                    itemStyle: {
                        normal: {
                            color: '#feef02',
                            label: {
                                show: false,
                                textStyle: {
                                    fontWeight: '700',
                                    fontSize: '0'
                                }
                            },
                            lineStyle: {
                                color: '#feef02',
                                width: 1
                            }
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: '#feef02',
                            opacity: 0.2
                        }
                    },
                    data: current_month_data
                }
            ]
        };
        myChart.setOption(option);
    }

    //选择右侧三个标签中的一个，曲线图改变

</script>
</body>
