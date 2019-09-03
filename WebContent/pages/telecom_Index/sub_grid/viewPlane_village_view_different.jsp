<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="yesterday">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="village_info">
    select village_name from gis_data.TB_GIS_VILLAGE_EDIT_INFO t where village_id = '${param.village_id}'
</e:q4o>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>
<e:q4o var="last_month_index_diff">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '8'
</e:q4o>
<e:q4o var="last_month_bar_chart">
    select const_value val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '6'
</e:q4o>
<e:q4l var="index_range_list">
    SELECT
    KPI_CODE,
    RANGE_NAME,
    RANGE_NAME_SHORT,
    RANGE_SIGNL,
    RANGE_MIN,
    RANGE_SIGNR,
    RANGE_MAX,
    RANGE_INDEX
    FROM GIS_DATA.TB_GIS_KPI_RANGE
    WHERE IS_VALID = 1
    ORDER BY KPI_CODE ASC, RANGE_INDEX ASC
</e:q4l>
<e:q4l var="degree_range_list">
    SELECT T.*
    FROM gis_data.TB_GIS_KPI_RANGE T
    WHERE IS_VALID = 1
    AND KPI_CODE LIKE 'KPI_DP%'
</e:q4l>
<html>
<head>
    <title>小区对标</title>
    <meta charset="utf-8">
    <meta name="author" content="jasmine">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <script type="text/javascript"
            src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <link href='<e:url value="/pages/telecom_Index/common/css/village_view.css?version=1.9"/>' rel="stylesheet"
          type="text/css" media="all"/>
    <style>
        .org_selectes {
            height: auto;
            background: #063C8F;
            border: 1px solid #0D4EA8;
        }

        .org_selectes {
            height: 35px!important;
            line-height: 35px!important;
            width: 100%;
            color: #fff;
            padding-left: 5px;
            padding-top: 3px;
        }

        .org_selectes span, .org_selectes div, .org_selectes input {
            display: inline-block;
            float: left;
            color: #fff !important;
        }

        .org_selectes span {
            width: 80px;
        }

        .org_selectes select {
            width: 100%;
            height: 22px !important;
            background: none;
            color: #fff;
            border: 1px solid #2657a5;
        }

        .org_selectes select option {
            color: #000;
        }

        .org_selectes table tr td {
            text-align: center;
        }

        table tbody tr td {
            color: #fff;
        }

        table thead tr th {
            color: #fff;
        }
        .data_list{height:83.5%;width:100%;}
        .data_list tbody tr td:nth-child(2), .data_list tbody tr td:nth-child(3),
        .data_list tbody tr td:nth-child(4), .data_list tbody tr td:nth-child(5),
        .data_list tbody tr td:nth-child(6) {
            text-align: center;
        }
        .figure_area {display:none;}
        #line_sale_1,#line_sale_2 {width:96.8%;margin:0px auto 10px auto;border:solid 1px #14306a;border-radius:5px;}
        #vill_dif_query{float:right;border:1px solid #467ace;background:#073b8a;width:80%;}
        .blue{width:12%;display:inline-block;}
        .zp_pj span {height:24px;line-height:24px;}
        #radar_01 {width:100%;}
        .layout_01 {width:99%;}
        .zongping td {height:15px;line-height:15px;}

        #market_toggle,#lost_toggle {float:right;display:inline-block;margin:10px 2% 6px 10px;color: #4abff9!important;font-weight: bold;text-decoration: none;}
        .figure_div {width:100%;height:auto!important;display:block!important;}
        .figure_tit {width:50%;margin:10px auto 6px 10px;display:inline-block;}
    </style>
    <script type="text/javascript">
        var village_id = '${param.village_id}';
        var build_list = [];
        var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp" />';
        var url4Query_village_diff = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_diff_action.jsp" />';
        //共同楼宇ID,标签联动切换使用,需要子页面去秀给他的编号
        var common_bulid_id = "-1";
        var obd_head_all = 0, obd_head_0 = 0, obd_head_1 = 0, obd_head_g = 0;

        var tag_market_index = "";
        var tag_compete_index = "";
        var tag_gm_index = "";

        //标签范围
        var index_range_str_temp = ${e:java2json(index_range_list.list)};
        var index_range_map = new Array();
        for (var i = 0, l = index_range_str_temp.length; i < l; i++) {
            var index_item = index_range_str_temp[i];
            var index_map = index_range_map[index_item['KPI_CODE']];
            if (index_map != undefined)
                index_map.push(index_item);
            else {
                index_map = new Array();
                index_map.push(index_item);
            }
            index_range_map[index_item['KPI_CODE']] = index_map;
        }

        //评分标准
        var degree_range_str_temp = ${e:java2json(degree_range_list.list)};
        var degree_range_map = new Array();
        for (var i = 0, l = degree_range_str_temp.length; i < l; i++) {
            var degree_item = degree_range_str_temp[i];
            var degree_map = degree_range_map[degree_item['KPI_CODE']];
            if (degree_map != undefined)
                degree_map.push(degree_item);
            else {
                degree_map = new Array();
                degree_map.push(degree_item);
            }
            degree_range_map[degree_item['KPI_CODE']] = degree_map;
        }

        var radar_echart = "";
        var this_village_data = {};
        var other_village_data = "";

        var degree01 = 0;
        var degree02 = 0;
        var degree03 = 0;
        var degree04 = 0;
        var degree05 = 0;
        /////
        function getVillageBaseInfo(village_id) {
            $.post(url4Query, {
                eaction: "getVillageBaseInfo",
                village_id: village_id,
                acct_month: '${last_month.VAL}'
            }, function (data) {
                var obj = $.parseJSON(data);

                $("#vill_me_title").text(item_name0);
                $("#vill_me_title").attr("title", obj.V_NAME);
                $("#vill_me_title1").text(obj.V_NAME);

                //第一个标签页
                //基础
                /*$.post(url4Query, {
                    eaction: "getLatnNameBureauNameByUnionOrgCode",
                    "union_org_code": obj.V_SUB_ID
                }, function (data) {
                    var obj_temp = $.parseJSON(data);
                    $("#vill_dif_latn").text(obj_temp.LATN_NAME);
                    $("#vill_dif_bureau").text(obj_temp.BUREAU_NAME);
                });*/

                //市场
                //$("#vill_me_market_lv").text(obj.MARKET_RATE);
                /*this_village_data = {
                    value: [obj.MARKET_RATE1, obj.ARPU_HU, obj.COMPETE_PERCENT1, obj.PORT_LV1, obj.RESOUCE_RATE1],
                    name: item_name0,//本小区
                    label: {
                        color: '#fff'
                    },
                    itemStyle: {
                        normal: {color: color_array[0]}
                    }
                };*/

                marketFlag(obj.MARKET_RATE1);

                //$("#vill_me_arpu_hu").text(obj.ARPU_HU);
                //$("#vill_me_arpu_hu1").text(obj.ARPU_HU);

                //占用率
                //$("#vill_me_port_lv").text(obj.PORT_LV);
                //$("#vill_me_resource_percent").text(obj.RESOUCE_RATE);

                modeFlag(obj.GZ_ZHU_HU_SHU);

                competeFlag(obj.COMPETE_PERCENT1);

                //village_compete_info();
                village_compete_with();
            });
        }
        function tableQuery(params) {
            var desc_sufix = "均值";
            $.post(url4Query_village_diff, params, function (data) {
                var data1 = $.parseJSON(data);
                for (var i = 0, l = data1.length; i < l; i++) {
                    var d = data1[i];

                    $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a1").parent().children().eq(0).text(d.MARK_DESC + desc_sufix);
                    $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a1").text(d.VILLAGE_RATE_AVG);
                    $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a2").text(d.HU_CHARGE_AVG);
                    $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a3").text(d.LS_RATE_AVG);
                    $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a4").text(d.PORT_RATE_AVG);
                    $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a5").text(d.ZY_RATE_AVG);

                    //渗透率
                    if (d["MARK_TYPE_CODE"] == 'MT01' && (tag_market_index == 1 || tag_market_index == 4)) {
                        $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a1").parent().attr("id", "index_" + d["MARK_TYPE_CODE"]);
                    } else if (d["MARK_TYPE_CODE"] == 'MT02' && (tag_gm_index == 1 || tag_gm_index == 4)) {//小区规模
                        $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a1").parent().attr("id", "index_" + d["MARK_TYPE_CODE"]);
                    } else if (d["MARK_TYPE_CODE"] == 'MT03' && (tag_compete_index == 1 || tag_compete_index == 4)) {//竞争流失
                        $("#vill_dif_" + d["MARK_TYPE_CODE"] + "_a1").parent().attr("id", "index_" + d["MARK_TYPE_CODE"]);
                    }
                }
            });
        }
        var tabMaxRowNums = 5;
        var tabCurrentRowNums = 4;

        var item_name0 = "本小区";
        var item_name1 = "对标小区";
        var legend_array = "";
        var legend_selected = "";

        var data_array = "";

        var color_array = ['#ff0000', '#EECB00', '#7BCE00', '#EA6C01', '#1AAF9D', ''];
        var indicator_array = "";
        var index1_max = 0;
        var index2_max = 0;
        var index3_max = 0;
        var index4_max = 0;
        var index5_max = 0;
        var index1_max_temp = "";
        var index2_max_temp = "";
        var index3_max_temp = "";
        var index4_max_temp = "";
        var index5_max_temp = "";

        function initRadarChart(params) {
            data_array = new Array();
            //data_array.push(this_village_data)/////

            legend_array = new Array();
            //legend_array.push(item_name0);
            legend_selected = new Object();

            if (other_village_data == "") {
                /*data_array.push(
                 {
                 value: [0,0,0,0,0],
                 name: item_name1,//本小区
                 label: {
                 color: '#fff'
                 },
                 itemStyle: {
                 normal: {color: color_array[1]}
                 }
                 }
                 );*/
            } else {
                //legend_array.push(item_name1);
                data_array.push(other_village_data);
            }
            /*if(other_village_data!=""){//选择过一个对标小区

             }*/
            index1_max_temp = new Array();
            index2_max_temp = new Array();
            index3_max_temp = new Array();
            index4_max_temp = new Array();
            index5_max_temp = new Array();

            for (var i = 0, l = color_array.length; i < l; i++) {
                if (i == 0) {
                    index1_max_temp.push(parseFloat(this_village_data.value[i]));
                    if (other_village_data != "")
                        index1_max_temp.push(parseFloat(other_village_data.value[i]));
                } else if (i == 1) {
                    index2_max_temp.push(parseFloat(this_village_data.value[i]));
                    if (other_village_data != "")
                        index2_max_temp.push(parseFloat(other_village_data.value[i]));
                } else if (i == 2) {
                    index3_max_temp.push(parseFloat(this_village_data.value[i]));
                    if (other_village_data != "")
                        index3_max_temp.push(parseFloat(other_village_data.value[i]));
                } else if (i == 3) {
                    index4_max_temp.push(parseFloat(this_village_data.value[i]));
                    if (other_village_data != "")
                        index4_max_temp.push(parseFloat(other_village_data.value[i]));
                } else if (i == 4) {
                    index5_max_temp.push(parseFloat(this_village_data.value[i]));
                    if (other_village_data != "")
                        index5_max_temp.push(parseFloat(other_village_data.value[i]));
                }
            }

            $.post(url4Query_village_diff, params, function (data) {
                var data1 = $.parseJSON(data);

                for (var i = 0, l = data1.length; i < l; i++) {
                    var d = data1[i];
                    legend_array.push(d.MARK_DESC);
                    if(d.TYPE==5)
                        legend_selected[d.MARK_DESC] = true;
                    else
                        legend_selected[d.MARK_DESC] = false;

                    var obj = {};
                    obj.value = [d.VILLAGE_RATE_AVG1, d.HU_CHARGE_AVG, d.LS_RATE_AVG1, d.PORT_RATE_AVG1, d.ZY_RATE_AVG1];

                    index1_max_temp.push(d.VILLAGE_RATE_AVG1);
                    index2_max_temp.push(d.HU_CHARGE_AVG);
                    index3_max_temp.push(d.LS_RATE_AVG1);
                    index4_max_temp.push(d.PORT_RATE_AVG1);
                    index5_max_temp.push(d.ZY_RATE_AVG1);

                    obj.name = d.MARK_DESC;
                    obj.label = {color: '#fff'};
                    obj.itemStyle = {normal: {color: color_array[i]}};

                    data_array.push(obj);
                }
                index1_max = index1_max_temp.sort(function (a, b) {
                    return a - b;
                })[index1_max_temp.length - 1] * 1.1;
                index2_max = index2_max_temp.sort(function (a, b) {
                    return a - b;
                })[index2_max_temp.length - 1] * 1.1;
                index3_max = index3_max_temp.sort(function (a, b) {
                    return a - b;
                })[index3_max_temp.length - 1] * 1.1;
                index4_max = index4_max_temp.sort(function (a, b) {
                    return a - b;
                })[index4_max_temp.length - 1] * 1.1;
                index5_max = index5_max_temp.sort(function (a, b) {
                    return a - b;
                })[index5_max_temp.length - 1] * 1.1;

                initRadarBasic(this_village_data.value,[index1_max==0?100:index1_max, index2_max==0?100:index2_max, index3_max==0?100:index3_max, index4_max==0?100:index4_max, index5_max==0?100:index5_max]);

                //蜘蛛网配置
                var option =
                {
                    title: {
                        text: ''
                    },
                    tooltip: {
                        //trigger: 'axis'
                        show:false
                    },
                    color: color_array,
                    grid: {
                        //top:0
                        //left: 15,
                        left: 15,
                        right: 5
                    },
                    legend: {
                        data: legend_array,
                        y: 'bottom',
                        textStyle: {
                            color: '#fff'
                        },
                        selected: legend_selected
                    },
                    polar: [
                        {
                            indicator: indicator_array,
                            center: ['50%', '50%'],
                            radius: 80, //半径，可放大放小雷达图
                            axisLine: {
                                show: false
                            },
                            axisTick: {
                                show: false
                            },
                            splitLine: {
                                show: true,
                                lineStyle: {
                                    color: '#666'
                                }
                            },
                            splitArea: {
                                show: false
                            }
                        }
                    ],
                    series: [{
                        name: '小区对标',
                        type: 'radar',
                        areaStyle: {normal: {color: '#f00'}},
                        data: data_array,
                        label: {
                            show:false,
                            fontSize: 8,
                            color: '#fff',
                            position: 'bottom'
                        },
                        areaStyle: {
                            color: 'transparent'
                        }
                    }]
                };
                radar_echart.setOption(option, true);
            });
        }
        function freshRadarChart() {
            var where_temp = getChecks();
            var params = {
                "eaction": "getVillageAndCityAndProvAvg",
                "acct_month": '${last_month_index_diff.VAL}',
                "latn_id": parent.global_current_city_id,
                "village_id": village_id,
                "other_village_id": other_village_id
            };
            initRadarChart(params);
        }

        //组合包含不同最大值的每个指标，用于构成雷达图
        function initRadarBasic(this_values,max_array) {
            indicator_array = new Array();
            indicator_array.push({text: '宽带渗透率\n'+this_values[0], max: max_array[0], color: '#fff'});
            indicator_array.push({text: 'APRU值\n'+this_values[1], max: max_array[1], color: '#fff'});
            indicator_array.push({text: '流失占比\n'+this_values[2], max: max_array[2], color: '#fff'});
            indicator_array.push({text: '端口占用率\n'+this_values[3], max: max_array[3], color: '#fff'});
            indicator_array.push({text: '资源覆盖率\n'+this_values[4], max: max_array[4], color: '#fff'});
        }

        function initVillDifSelect() {
            $("#vill_dif_latn_selected").append(baseFullOption);
            $("#vill_dif_bureau_selected").append(baseFullOption);
            $("#vill_dif_sub_selected").append(baseFullOption);
            //$("#vill_dif_vil_selected").append(baseFullOption);
        }

        function isFullTab() {
            return tabCurrentRowNums + 1 > tabMaxRowNums;
        }
        function fillTab() {
            for (var i = 0, l = tabMaxRowNums - tabCurrentRowNums; i < l; i++) {
                $(".vill_dif_tab1").eq(1).append("<tr class='empty_row'><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
            }
            for (var i = 0, l = tabMaxRowNums - $(".vill_dif_tab1").eq(1).children("tbody").children("tr:visible").length; i < l; i++) {
                $(".vill_dif_tab1").eq(1).append("<tr class='empty_row'><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
            }
        }
        //勾选框
        function initCheckFunc() {
            //全省均值
            /*$("#vd_ck_0").unbind();
             $("#vd_ck_0").bind("click",function(){
             $(".empty_row").remove();
             var ck_val = $(this).attr("checked");
             if(ck_val=="checked"){
             if(isFullTab()){
             layer.msg("对标指标不能超过"+tabMaxRowNums+"个");
             $(this).removeAttr("checked")
             return;
             }
             var where_str = "0,0";
             var params = {
             "where_str":where_str,
             "eaction":"getDiffIndex",
             "acct_month":'
            ${last_month_index_diff.VAL}'
             }

             $.post(url4Query_village_diff,params,function(data){
             var d = $.parseJSON(data);
             d = d[0];
             $(".vill_dif_tab1").eq(1).append("<tr id='index_MT00'>" +
             "<td>" + "全省均值" + "</td>" +
             "<td>" + d.VILLAGE_RATE_AVG + "</td>" +
             "<td>" + d.HU_CHARGE_AVG + "</td>" +
             "<td>" + d.LS_RATE_AVG + "</td>" +
             "<td>" + d.PORT_RATE_AVG + "</td>" +
             "<td>" + d.ZY_RATE_AVG + "</td>" +
             "</tr>"
             );
             tabCurrentRowNums++;
             });
             }else{
             $("#index_MT00").remove();
             }
             fillTab();
             freshRadarChart();
             });*/
        }

        var choiced_vill = false;
        var other_village_id = "";

        var bar1_echart = "";
        var bar2_echart = "";

        var market_time_type = 1;
        var lost_time_type = 1;

        $(function () {
            addTipToVillagePaint();
            //第一个标签页，小区汇总信息
            $("#radar_01").parent("td").css("width", $(".zongping").width() * 0.4);//蜘蛛宽度
            //$("#line_sale_1").width($(".layout_01").width());
            //$("#line_sale_2").width($(".layout_01").width());
            var radar_div = document.getElementById('radar_01');
            radar_echart = echarts.init(radar_div);
            getVillageBaseInfo(village_id);
            initVillDifSelect();

            //initCheckFunc();
            setCitys($("#vill_dif_latn_selected"), $("#vill_dif_bureau_selected"), $("#vill_dif_sub_selected"), $("#vill_dif_vil_selected"));
            $("#vill_dif_query").unbind();
            $("#vill_dif_query").bind("click", function () {
                other_village_id = $("#vill_dif_vil_selected option:checked").val();
                if (other_village_id != "" && other_village_id != undefined) {
                    if (isFullTab()) {
                        if (!choiced_vill) {
                            layer.msg("对标指标不能超过" + tabMaxRowNums + "个");
                            $(this).removeAttr("checked")
                            return;
                        }
                    }
                } else {
                    if (choiced_vill) {
                        tabCurrentRowNums--;
                        choiced_vill = false;
                    }
                    other_village_data = "";
                }
                $(".empty_row").remove();
                $(".org_selectes").hide();
                $(".compare").show();
                village_compete_with();
                //getVillageBaseInfoOther(other_village_id);
            });

            //柱状图初始化
            $("#line_sale_1").show();
            $("#line_sale_2").show();
            var bar1_div = document.getElementById('line_sale_1');
            var bar2_div = document.getElementById('line_sale_2');

            // 初始化图表
            bar1_echart = echarts.init(bar1_div);
            bar2_echart = echarts.init(bar2_div);

            initChart(bar1_echart,bar2_echart,1,0);

            //用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
            resizeMainContainer = function () {
                radar_div.style.width = ($(".zongping").width() * 0.45) + 'px';
                bar1_div.style.width = ($(".zongping").width()*0.96) + 'px';
                bar1_div.style.height = $("#radar_01").height() * 0.8 + 'px';
                bar2_div.style.width = ($(".zongping").width()*0.96) + 'px';
                bar2_div.style.height = $("#radar_01").height() * 0.8 + 'px';
                console.log($(".zongping").width() * 0.6);
                $(".data_list").parent("td").css("width",$(".zongping").width() * 0.6);
                radar_echart.resize();
                bar1_echart.resize();
                bar2_echart.resize();
            };
            //设置div容器高宽
            resizeMainContainer();

            $(".compare").unbind();
            $(".compare").on("click", function () {
                $(".org_selectes").show();
                $(this).toggle();
            });
            //宽带渗透率 宽带流失数 6个数字
            market_lost_num();

            //半年 一年 切换
            $("#market_toggle").unbind();
            $("#market_toggle").click(function(){
                if(market_time_type==1){
                    market_time_type = 2;
                    $("#market_toggle").text("近半年");
                }else{
                    market_time_type = 1;
                    $("#market_toggle").text("近一年");
                }
                initChart(bar1_echart,bar2_echart,market_time_type,1);
            });
            $("#lost_toggle").unbind();
            $("#lost_toggle").click(function(){
                if(lost_time_type==1){
                    lost_time_type = 2;
                    $("#lost_toggle").text("近半年");
                }else{
                    lost_time_type = 1;
                    $("#lost_toggle").text("近一年");
                }
                initChart(bar1_echart,bar2_echart,lost_time_type,2);
            });
        });
        function getChecks() {
            var str = "";
            var str_array = new Array();
            if ($("#vd_ck_0").is(":checked"))
                str_array.push("0,0");

            var vd_ck_mv = $("input[id^='vd_ck_mv_']:checked");
            var mv_str_temp = "";
            for (var i = 0, l = vd_ck_mv.length; i < l; i++) {
                var ck = vd_ck_mv[i];
                str_array.push("1," + $(ck).attr("data"));
                mv_str_temp += $(ck).attr("data");
            }
            if (mv_str_temp.indexOf(tag_market_index) == -1 && tag_market_index != 1 && tag_market_index != 4)
                str_array.push("1," + tag_market_index);

            var vd_ck_jz = $("input[id^='vd_ck_jz_']:checked");
            var jz_str_temp = "";
            for (var i = 0, l = vd_ck_jz.length; i < l; i++) {
                var ck = vd_ck_jz[i];
                str_array.push("3," + $(ck).attr("data"));
                jz_str_temp += $(ck).attr("data");
            }
            if (jz_str_temp.indexOf(tag_compete_index) == -1 && tag_compete_index != 1 && tag_compete_index != 4)
                str_array.push("3," + tag_compete_index);

            var vd_ck_mo = $("input[id^='vd_ck_mo_']:checked");
            var mo_str_temp = "";
            for (var i = 0, l = vd_ck_mo.length; i < l; i++) {
                var ck = vd_ck_mo[i];
                str_array.push("2," + $(ck).attr("data"));
                mo_str_temp += $(ck).attr("data");
            }
            if (mo_str_temp.indexOf(tag_gm_index) == -1 && tag_gm_index != 1 && tag_gm_index != 4)
                str_array.push("2," + tag_gm_index);

            return str_array.join("_");
        }

        //两个柱状图生成
        function initChart(bar1_echart,bar2_echart,time_type,index_type) {
            //市场渗透率柱状图
            var bar_month = new Array();
            var bar_data = new Array();
            var option = {
                grid: {
                    top: '25',
                    bottom: '25'
                    //left: '8%',
                },
                xAxis: {
                    type: 'category',
                    data: bar_month,//bar_month,
                    axisLine: {
                        lineStyle: {color: '#fff'}
                    }
                },
                yAxis: {
                    show: false,
                    type: 'value',
                    splitLine: {show: false},
                    axisLine: {
                        lineStyle: {color: '#fff'}
                    }
                },
                series: [{
                    data: bar_data,//bar_data,
                    type: 'bar',
                    barWidth: '38',
                    itemStyle: {
                        color: '#109afb',
                    },
                    label: {
                        show: true,
                        position: 'top',
                        color: '#A29013',
                        formatter:'{c}%'
                    }
                }]
            };

            var bar_data1 = new Array();
            var bar_data2 = new Array();
            var option1 = {
                grid: {
                    bottom: '25'
                    //left: '8%'
                },
                tooltip: {
                    show:false,
                    trigger: 'axis',
                    axisPointer: {
                        type: 'cross',
                        crossStyle: {
                            //color: '#999'
                        }
                    }
                },
                toolbox: {
                    show: false
                },
                legend: {
                    data: ['流失用户数', '流失率'],
                    textStyle: {
                        color: '#fff'
                    },
                    top:25
                },
                xAxis: [
                    {
                        type: 'category',
                        data: bar_month,
                        axisPointer: {
                            type: 'shadow'
                        },
                        axisLine: {
                            lineStyle: {color: '#fff'}
                        },
                        axisLabel: {
                            shadowColor:'transparent'
                        }
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        name: '流失用户数',
                        splitLine: {show: false},
                        show: false,
                        //min: 0,
                        //max: 250,
                        //interval: 50,
                        axisLabel: {
                            formatter: '{value}'
                        }
                    },
                    {
                        type: 'value',
                        name: '流失率',
                        show: false,
                        splitLine: {show: false},
                        //min: 0,
                        //max: 25,
                        //interval: 5,
                        axisLabel: {
                            formatter: '{value}%'
                        }
                    }
                ],
                series: [
                    {
                        name: '流失用户数',
                        type: 'bar',
                        data: bar_data1,//[1,2,3,4,5],
                        barWidth: '38',
                        itemStyle: {
                            color: '#109afb'
                        },
                        label: {
                            show: true,
                            position:'inside',
                            color: '#fff',
                            formatter:'{c}'
                        }
                    },
                    {
                        name: '流失率',
                        type: 'line',
                        yAxisIndex: 1,
                        data: bar_data2,//[10,20,30,40,50],
                        lineStyle: {color: '#edfe00'},
                        label: {
                            show: true,
                            position:'top',
                            color: '#A29013',
                            formatter:'{c}%'
                        }
                    }
                ]
            };
            var begin_count = 0;
            if(time_type==1){
                begin_count = 5;
            }else{
                begin_count = 11;
            }
            $.post(url4Query_village_diff,{"eaction":"getVillageByMonths","month":'${last_month_bar_chart.VAL}',"begin_count":begin_count,"village_id":village_id},function(data){
                var d_temp = $.parseJSON(data);
                if(d_temp.length){
                    for(var i = 0,l = d_temp.length;i<l;i++){
                        var d = d_temp[i];
                        bar_month.push({value:d.MONTH_CODE});
                        bar_data.push({name:d.MONTH_CODE,value:d.USE_RATE});
                        bar_data1.push({name:d.MONTH_CODE,value:d.LOST_REMOVE});
                        bar_data2.push({name:d.MONTH_CODE,value:d.LS_RATE_AVG});
                    }
                }

                if(index_type==1){
                    //市场渗透率 柱状图
                    bar1_echart.setOption(option);
                }else if(index_type==2){
                    //流失用户 柱状图、折线图
                    bar2_echart.setOption(option1);
                }else{
                    bar1_echart.setOption(option);
                    bar2_echart.setOption(option1);
                }
                bar1_echart.resize();
                bar2_echart.resize();
            });
        }
    </script>
</head>
<body style="overflow-y: hidden;">
<div class="cus_view_wrapper">
    <div class="cus_view_header">
        <div class="cus_view_header_tag"></div>
        <div class="text">小区画像</div>
    </div>
    <table cellpadding="0" cellspacing="0" class="zongping">
        <tr>
            <td width="9%" align="right"><span style="font-weight:bold;">总评分</span></td>
            <td width="12%"><span class="score_zp"></span></td>
            <td width="50%">
                <div style="height:35%;width:100%;">
                    <span class="zp_tit" style="margin-bottom:5px;width:22%;">宽带渗透率</span>
                    <span style="width:13%;">本月</span><span class="blue" id="market_this" style="width:13%;"></span>
                    <span style="width:13%;">上月</span><span class="blue" id="market_last" style="width:13%;"></span>
                    <span style="width:13%;">环比</span><span class="blue" id="market_huan" style="width:13%;"></span>
                </div>
                <div style="height:35%;width:100%;">
                    <span class="zp_tit" style="margin-bottom:5px;width:22%;">宽带流失数</span>
                    <span style="width:13%;">本月</span><span class="blue" id="lost_this" style="width:13%;"></span>
                    <span style="width:13%;">上月</span><span class="blue" id="lost_last" style="width:13%;"></span>
                    <span style="width:13%;">环比</span><span class="blue" id="lost_huan" style="width:13%;"></span>
                </div>
            </td>
            <td class="zp_pj" style="width:29%;">
                <span id="tag_market"></span>
                <span id="tag_compete"></span>
                <span id="tag_mode"></span>
            </td>
        </tr>
    </table>


    <!--下半部分内容开始-->
    <div class="cus_view_body" style="overflow-y: scroll;height:74%;">

        <!-- 对标选择 -->
        <div class="org_selectes" style="display:none;">
            <table style="width:100%;">
                <tr>
                    <td width="103" style="text-align:right;">
                        <bold>对标小区</bold>
                        ：地市
                    </td>
                    <td><select id="vill_dif_latn_selected"></select></td>
                    <td style="text-align:right;">分局</td>
                    <td><select id="vill_dif_bureau_selected"></select></td>
                    <td style="text-align:right;">支局</td>
                    <td><select id="vill_dif_sub_selected"></select></td>
                    <td style="text-align:right;">小区</td>
                    <td>
                        <select id="vill_dif_vil_selected" onchange="vil_name_changed()" style=""></select>
                        <input type="text" id="vill_dif_vil_selected_input"
                               oninput="load_name_list_filter()" placeholder="可输入关键字检索"
                               style="display:none;position:absolute;right:75px;">
                        <ul id="vill_dif_vil_selected_name_list">
                        </ul>
                    </td>
                    <td width="56"><input id="vill_dif_query" type="button" value="确定"/></td>
                </tr>
            </table>
        </div>

        <table cellpadding="0" cellspacing="0" class="layout_01">
            <tr>
                <td>
                    <div id="radar_01"></div>
                </td>
                <td>
                    <a href="javascript:void(0);" class="compare">对标</a>
                    <table cellpadding="0" cellspacing="0" class="data_list">
                        <thead>
                        <th>小区/指标</th>
                        <th>宽带渗透率</th>
                        <th>户均ARPU</th>
                        <th>竞争流失率</th>
                        <th>端口占用率</th>
                        <th>资源覆盖率</th>
                        </thead>
                        <tbody>
                        <tr>
                            <td id="vill_me_title">本小区</td>
                            <td id="vill_me_market_lv"></td>
                            <td id="vill_me_arpu_hu"></td>
                            <td id="vill_me_compete_percent"></td>
                            <td id="vill_me_port_lv"></td>
                            <td id="vill_me_resource_percent"></td>
                        </tr>
                        <tr>
                            <td>分公司均值</td>
                            <td id="city_market_lv"></td>
                            <td id="city_arpu_hu"></td>
                            <td id="city_compete_percent"></td>
                            <td id="city_port_lv"></td>
                            <td id="city_resource_percent"></td>
                        </tr>
                        <tr>
                            <td>全省均值</td>
                            <td id="prov_market_lv"></td>
                            <td id="prov_arpu_hu"></td>
                            <td id="prov_compete_percent"></td>
                            <td id="prov_port_lv"></td>
                            <td id="prov_resource_percent"></td>
                        </tr>
                        <tr>
                            <td id="compete_target">对标小区</td>
                            <td id="vill_dif_market_lv"></td>
                            <td id="vill_dif_arpu_hu"></td>
                            <td id="vill_dif_compete_percent"></td>
                            <td id="vill_dif_port_lv"></td>
                            <td id="vill_dif_resource_percent"></td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </table>

        <div class="figure_div">
            <h3 class="figure_tit">市场渗透率</h3>
            <%--<a href="javascript:void(0);" id="market_toggle">近一年</a>--%>
        </div>
        <div id="line_sale_1"></div>

        <div class="figure_div">
            <h3 class="figure_tit">流失用户</h3>
            <%--<a href="javascript:void(0);" id="lost_toggle">近一年</a>--%>
        </div>
        <div id="line_sale_2"></div>

        <%--<div class="figure_area">
            <div id="line_sale_1"></div>
        </div>

        <div class="figure_area">
            <div id="line_sale_2"></div>
        </div>--%>
        <!--下半部分内容结束-->
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    var begin_scroll = "", seq_num = 0, list_page = 0, select_count = 0, label = 0, collect_state = null;
    var zy_type = "";

    //获取省均值，分公司均值
    function village_compete_with() {
        var params = {
            "eaction": "getVillageAndCityAndProvAvg",
            "acct_month": '${last_month_index_diff.VAL}',
            "latn_id": parent.global_current_city_id,
            "village_id": village_id,
            "other_village_id": other_village_id
        };
        $.post(url4Query_village_diff, params, function (data) {
            var d_temp = $.parseJSON(data);
            if (d_temp.length) {
                for (var i = 0, l = d_temp.length; i < l; i++) {
                    var d = d_temp[i];
                    if (d.TYPE == 5) {
                        $("#vill_me_market_lv").text(d.VILLAGE_RATE_AVG);
                        $("#vill_me_arpu_hu").text(d.HU_CHARGE_AVG);
                        $("#vill_me_compete_percent").text(d.LS_RATE_AVG);
                        $("#vill_me_port_lv").text(d.PORT_RATE_AVG);
                        $("#vill_me_resource_percent").text(d.ZY_RATE_AVG);

                        this_village_data = {
                            value: [d.VILLAGE_RATE_AVG, d.HU_CHARGE_AVG, d.LS_RATE_AVG, d.PORT_RATE_AVG, d.ZY_RATE_AVG],
                            name: item_name0,//本小区
                            label: {
                                color: '#fff'
                            },
                            itemStyle: {
                                normal: {color: color_array[0]}
                            }
                        };

                        degreeFlag(d);//计算本小区的评分
                    } else if (d.TYPE == 2) {
                        $("#city_market_lv").text(d.VILLAGE_RATE_AVG);
                        $("#city_arpu_hu").text(d.HU_CHARGE_AVG);
                        $("#city_compete_percent").text(d.LS_RATE_AVG);
                        $("#city_port_lv").text(d.PORT_RATE_AVG);
                        $("#city_resource_percent").text(d.ZY_RATE_AVG);
                    } else if (d.TYPE == 1) {
                        $("#prov_market_lv").text(d.VILLAGE_RATE_AVG);
                        $("#prov_arpu_hu").text(d.HU_CHARGE_AVG);
                        $("#prov_compete_percent").text(d.LS_RATE_AVG);
                        $("#prov_port_lv").text(d.PORT_RATE_AVG);
                        $("#prov_resource_percent").text(d.ZY_RATE_AVG);
                    } else if (d.TYPE == '5_1') {
                        $("#vill_dif_market_lv").text(d.VILLAGE_RATE_AVG);
                        $("#vill_dif_arpu_hu").text(d.HU_CHARGE_AVG);
                        $("#vill_dif_compete_percent").text(d.LS_RATE_AVG);
                        $("#vill_dif_port_lv").text(d.PORT_RATE_AVG);
                        $("#vill_dif_resource_percent").text(d.ZY_RATE_AVG);

                        other_village_data = {
                            value : [d.VILLAGE_RATE_AVG, d.HU_CHARGE_AVG, d.LS_RATE_AVG, d.PORT_RATE_AVG, d.ZY_RATE_AVG],
                            name : item_name1,//本小区
                            label:{
                                color:'#fff'
                            },
                            itemStyle:{
                                normal:{color:color_array[1]}
                            }
                        };
                    }
                }
            } else {

            }
            freshRadarChart();
        });
    }

    function competeFlag(compete_percent) {
        //竞争标签
        var tag_compete_str = "";
        var compete_range = index_range_map["KPI_D_003"];
        for (var i = 0, l = compete_range.length; i < l; i++) {
            var item = compete_range[i];
            if (item.RANGE_MAX == null) {//最大值
                if (item.RANGE_SIGNL == '>=') {
                    if (compete_percent >= item.RANGE_MIN) {
                        tag_compete_str = item.RANGE_NAME_SHORT;
                        tag_compete_index = item.RANGE_INDEX;
                    }
                }
                if (item.RANGE_SIGNR == '>') {
                    if (compete_percent > item.RANGE_MIN) {
                        tag_compete_str = item.RANGE_NAME_SHORT;
                        tag_compete_index = item.RANGE_INDEX;
                    }
                }
            } else if (item.RANGE_MIN == null) {//最小值
                if (item.RANGE_SIGNR == '<=') {
                    if (compete_percent <= item.RANGE_MAX) {
                        tag_compete_str = item.RANGE_NAME_SHORT;
                        tag_compete_index = item.RANGE_INDEX;
                    }
                }
                if (item.RANGE_SIGNR == '<') {
                    if (compete_percent < item.RANGE_MAX) {
                        tag_compete_str = item.RANGE_NAME_SHORT;
                        tag_compete_index = item.RANGE_INDEX;
                    }
                }
            } else {
                if (item.RANGE_SIGNL == '>=') {
                    if (compete_percent >= item.RANGE_MIN) {
                        if (item.RANGE_SIGNR == '<') {
                            if (compete_percent < item.RANGE_MAX) {
                                tag_compete_str = item.RANGE_NAME_SHORT;
                                tag_compete_index = item.RANGE_INDEX;
                            }
                        } else if (item.RANGE_SIGNR == '<=') {
                            if (compete_percent <= item.RANGE_MAX) {
                                tag_compete_str = item.RANGE_NAME_SHORT;
                                tag_compete_index = item.RANGE_INDEX;
                            }
                        }
                    }
                } else if (item.RANGE_SIGNL == '>') {
                    if (compete_percent > item.RANGE_MIN) {
                        if (item.RANGE_SIGNR == '<') {
                            if (compete_percent < item.RANGE_MAX) {
                                tag_compete_str = item.RANGE_NAME_SHORT;
                                tag_compete_index = item.RANGE_INDEX;
                            }
                        } else if (item.RANGE_SIGNR == '<=') {
                            if (compete_percent <= item.RANGE_MAX) {
                                tag_compete_str = item.RANGE_NAME_SHORT;
                                tag_compete_index = item.RANGE_INDEX;
                            }
                        }
                    }
                }
            }
        }
        if (tag_compete_str != "")
            tag_compete_str += "竞争";

        $("#tag_compete").text(tag_compete_str);//竞争标签 tag
    }

    function marketFlag(market_lv) {
        var tag_market_str = "";
        var market_range = index_range_map["KPI_D_001"];
        for (var i = 0, l = market_range.length; i < l; i++) {
            var item = market_range[i];
            if (item.RANGE_MAX == null) {//最大值
                if (item.RANGE_SIGNL == '>=') {
                    if (market_lv >= item.RANGE_MIN) {
                        tag_market_str = item.RANGE_NAME_SHORT;
                        tag_market_index = item.RANGE_INDEX;
                        degree01 = item.range_name_short;
                    }
                }
                if (item.RANGE_SIGNR == '>') {
                    if (market_lv > item.RANGE_MIN) {
                        tag_market_str = item.RANGE_NAME_SHORT;
                        tag_market_index = item.RANGE_INDEX;
                    }
                }
            } else if (item.RANGE_MIN == null) {//最小值
                if (item.RANGE_SIGNR == '<=') {
                    if (market_lv <= item.RANGE_MAX) {
                        tag_market_str = item.RANGE_NAME_SHORT;
                        tag_market_index = item.RANGE_INDEX;
                    }
                }
                if (item.RANGE_SIGNR == '<') {
                    if (market_lv < item.RANGE_MAX) {
                        tag_market_str = item.RANGE_NAME_SHORT;
                        tag_market_index = item.RANGE_INDEX;
                    }
                }
            } else {
                if (item.RANGE_SIGNL == '>=') {
                    if (market_lv >= item.RANGE_MIN) {
                        if (item.RANGE_SIGNR == '<') {
                            if (market_lv < item.RANGE_MAX) {
                                tag_market_str = item.RANGE_NAME_SHORT;
                                tag_market_index = item.RANGE_INDEX;
                            }
                        } else if (item.RANGE_SIGNR == '<=') {
                            if (market_lv <= item.RANGE_MAX) {
                                tag_market_str = item.RANGE_NAME_SHORT;
                                tag_market_index = item.RANGE_INDEX;
                            }
                        }
                    }
                } else if (item.RANGE_SIGNL == '>') {
                    if (market_lv > item.RANGE_MIN) {
                        if (item.RANGE_SIGNR == '<') {
                            if (market_lv < item.RANGE_MAX) {
                                tag_market_str = item.RANGE_NAME_SHORT;
                                tag_market_index = item.RANGE_INDEX;
                            }
                        } else if (item.RANGE_SIGNR == '<=') {
                            if (market_lv <= item.RANGE_MAX) {
                                tag_market_str = item.RANGE_NAME_SHORT;
                                tag_market_index = item.RANGE_INDEX;
                            }
                        }
                    }
                }
            }
        }
        /*if(market_lv>=60)
         tag_market_str = "高";
         else if(market_lv>=30 && market_lv<60)
         tag_market_str = "中";
         else if(market_lv<30)
         tag_market_str = "低";*/

        if (tag_market_str != "")
            tag_market_str += "渗透";

        $("#tag_market").text(tag_market_str);//渗透标签 tag
    }

    function modeFlag(gz_zhs) {
        var village_gm_str = "";
        var village_gm_range = index_range_map["KPI_D_002"];
        for (var i = 0, l = village_gm_range.length; i < l; i++) {
            var item = village_gm_range[i];
            if (item.RANGE_MAX == null) {//最大值
                if (item.RANGE_SIGNL == '>=') {
                    if (gz_zhs >= item.RANGE_MIN) {
                        village_gm_str = item.RANGE_NAME_SHORT;
                        tag_gm_index = item.RANGE_INDEX;
                    }
                }
                if (item.RANGE_SIGNR == '>') {
                    if (gz_zhs > item.RANGE_MIN) {
                        village_gm_str = item.RANGE_NAME_SHORT;
                        tag_gm_index = item.RANGE_INDEX;
                    }
                }
            } else if (item.RANGE_MIN == null) {//最小值
                if (item.RANGE_SIGNR == '<=') {
                    if (gz_zhs <= item.RANGE_MAX) {
                        village_gm_str = item.RANGE_NAME_SHORT;
                        tag_gm_index = item.RANGE_INDEX;
                    }
                }
                if (item.RANGE_SIGNR == '<') {
                    if (gz_zhs < item.RANGE_MAX) {
                        village_gm_str = item.RANGE_NAME_SHORT;
                        tag_gm_index = item.RANGE_INDEX;
                    }
                }
            } else {
                if (item.RANGE_SIGNL == '>=') {
                    if (gz_zhs >= item.RANGE_MIN) {
                        if (item.RANGE_SIGNR == '<') {
                            if (gz_zhs < item.RANGE_MAX) {
                                village_gm_str = item.RANGE_NAME_SHORT;
                                tag_gm_index = item.RANGE_INDEX;
                            }
                        } else if (item.RANGE_SIGNR == '<=') {
                            if (gz_zhs <= item.RANGE_MAX) {
                                village_gm_str = item.RANGE_NAME_SHORT;
                                tag_gm_index = item.RANGE_INDEX;
                            }
                        }
                    }
                } else if (item.RANGE_SIGNL == '>') {
                    if (gz_zhs > item.RANGE_MIN) {
                        if (item.RANGE_SIGNR == '<') {
                            if (gz_zhs < item.RANGE_MAX) {
                                village_gm_str = item.RANGE_NAME_SHORT;
                                tag_gm_index = item.RANGE_INDEX;
                            }
                        } else if (item.RANGE_SIGNR == '<=') {
                            if (gz_zhs <= item.RANGE_MAX) {
                                village_gm_str = item.RANGE_NAME_SHORT;
                                tag_gm_index = item.RANGE_INDEX;
                            }
                        }
                    }
                }
            }
        }

        $("#village_view_village_mode").text(village_gm_str + "规模");
        $("#tag_mode").text(village_gm_str + "规模");
    }

    function degreeFlag(obj){
        var village_degree_str = 0;
        var degree_keys = Object.keys(degree_range_map);
        //KPI_DP_001 宽带渗透率
        //KPI_DP_002 宽带流失率
        //KPI_DP_003 用户ARPU
        //KPI_DP_004 端口占用率
        //KPI_DP_005 资源覆盖率

        for(var j = 0,k = degree_keys.length;j<k;j++){
            var key = degree_keys[j];
            var degreed_d = 0;
            if(key=='KPI_DP_001')
                degreed_d = obj.VILLAGE_RATE_AVG1;
            else if(key=='KPI_DP_002')
                degreed_d = obj.LS_RATE_AVG1;
            else if(key=='KPI_DP_003')
                degreed_d = obj.HU_CHARGE_AVG;
            else if(key=='KPI_DP_004')
                degreed_d = obj.PORT_RATE_AVG1;
            else if(key=='KPI_DP_005')
                degreed_d = obj.ZY_RATE_AVG1;


            var village_degree_range = degree_range_map[key];
            for (var i = 0, l = village_degree_range.length; i < l; i++) {
                var item = village_degree_range[i];
                if (item.RANGE_MAX == null) {//最大值
                    if (item.RANGE_SIGNL == '>=') {
                        if (degreed_d >= item.RANGE_MIN) {
                            village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                        }
                    }
                    if (item.RANGE_SIGNR == '>') {
                        if (degreed_d > item.RANGE_MIN) {
                            village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                        }
                    }
                } else if (item.RANGE_MIN == null) {//最小值
                    if (item.RANGE_SIGNR == '<=') {
                        if (degreed_d <= item.RANGE_MAX) {
                            village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                        }
                    }
                    if (item.RANGE_SIGNR == '<') {
                        if (degreed_d < item.RANGE_MAX) {
                            village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                        }
                    }
                } else {
                    if (item.RANGE_SIGNL == '>=') {
                        if (degreed_d >= item.RANGE_MIN) {
                            if (item.RANGE_SIGNR == '<') {
                                if (degreed_d < item.RANGE_MAX) {
                                    village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                                }
                            } else if (item.RANGE_SIGNR == '<=') {
                                if (degreed_d <= item.RANGE_MAX) {
                                    village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                                }
                            }
                        }
                    } else if (item.RANGE_SIGNL == '>') {
                        if (degreed_d > item.RANGE_MIN) {
                            if (item.RANGE_SIGNR == '<') {
                                if (degreed_d < item.RANGE_MAX) {
                                    village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                                }
                            } else if (item.RANGE_SIGNR == '<=') {
                                if (degreed_d <= item.RANGE_MAX) {
                                    village_degree_str += parseFloat(item.RANGE_NAME_SHORT);
                                }
                            }
                        }
                    }
                }
            }
        }
        $(".score_zp").text(village_degree_str);
    }

    //宽带渗透率 宽带流失数 6个数字
    function market_lost_num(){
        $.post(url4Query_village_diff,{"eaction":"getMarketLostSix","village_id":village_id,"acct_month":'${last_month_bar_chart.VAL}'},function(data){
            var d_temp = $.parseJSON(data);
            if(d_temp.length){
                var d = d_temp[0];
                $("#market_this").text(d.RATE_THIS);
                $("#market_last").text(d.RATE_LAST);
                $("#market_huan").text(d.RATE_HUAN);
                $("#lost_this").text(d.LOST_THIS);
                $("#lost_last").text(d.LOST_LAST);
                $("#lost_huan").text(d.LOST_HUAN);
            }
        });
    }
</script>
<script>
    var user_level = '${sessionScope.UserInfo.LEVEL}';
    var baseFullOptions = "<option value=''>全省</option>";
    var baseFullOption = "<option value=''>全部</option>";
    function setCitys(e, e1, e2, e3) {
        $.post(url4Query, {eaction: 'setcitys'}, function (data) {
            data = $.parseJSON(data)
            var str = ''
            e.unbind();
            e.on("change", function () {
                before_load_build_list_sj();
                var id = e.find(":selected").val();
                e1.html(baseFullOption);
                e2.html(baseFullOption);
                e3.html(baseFullOption);

                setArea(id, e1, e2, e3);
            })
            $.each(data, function (i, d) {
                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>";
            })
            e.html(baseFullOptions);
            e.append(str);
            e.find("option[value=" + city_id + "]").attr("selected", "selected");
            if(user_level>1){
                e.attr("disabled","disabled");
                e.css("background","#999");
                e.find("option[value!=" + city_id + "]").remove();
            }
            setArea(city_id, e1, e2, e3);
        })
    }

    function setArea(id, e1, e2, e3) {
        $.post(url4Query, {eaction: "setareas", latn_id: id}, function (data) {
            data = $.parseJSON(data);
            e1.unbind();
            e1.on("change", function () {
                before_load_build_list_sj();
                e2.html(baseFullOption);
                e3.html(baseFullOption);
                var id = e1.find(":selected").val();
                setBranchs(id, e2, e3);
                if (id != null) {
                    setGrids(null, e3);
                }
            })
            var str = '';
            $.each(data, function (i, d) {
                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>";
            })
            e1.html(baseFullOption);
            e1.append(str);
            if(user_level>2){
                e1.attr("disabled","disabled");
                e1.css("background","#999");
                e1.find("option[value=" + ${sessionScope.UserInfo.CITY_NO} + "]").attr("selected", "selected");
                e1.find("option[value!=" + ${sessionScope.UserInfo.CITY_NO} + "]").remove();
                setBranchs('${sessionScope.UserInfo.CITY_NO}', e2, e3);
            }else
                setBranchs(null, e2, e3);
        })
    }

    function setBranchs(id, e1, e2) {
        var latn_id = $("#vill_dif_latn_selected option:selected").val()
        $.post(url4Query, {eaction: "setbranchs", id: id, latn_id: latn_id}, function (data) {
            data = $.parseJSON(data);
            e1.unbind();
            e1.on("change", function () {
                before_load_build_list_sj();
                var id = e1.find(":selected").val();
                e2.html(baseFullOption);
                setVillages(id, e2);
            })
            var str = '';
            $.each(data, function (i, d) {
                str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>";
            })
            e1.html(baseFullOption);
            e1.append(str);
            if(user_level>3){
                e1.attr("disabled","disabled");
                e1.css("background","#999");
                e1.find("option[value=" + ${sessionScope.UserInfo.TOWN_NO} + "]").attr("selected", "selected");
                e1.find("option[value!=" + ${sessionScope.UserInfo.TOWN_NO} + "]").remove();
                setVillages('${sessionScope.UserInfo.TOWN_NO}', e2);
            }
        })
    }
    //暂不用
    function setGrids(id, e1) {
        var latn_id = $("#vill_dif_latn_selected option:selected").val()
        var bureau_no = $("#vill_dif_bureau_selected option:selected").val()
        $.post(url4Query, {
            eaction: "setgrids",
            id: id,
            latn_id: latn_id,
            bureau_no: bureau_no
        }, function (data) {
            data = $.parseJSON(data);
            e1.unbind();
            e1.on("change", function () {
                before_load_build_list_sj();
                var grid_id = $("#vill_dif_grid_selected option:selected").val();
            })
            var str = ''
            $.each(data, function (i, d) {
                str += "<option value='" + d.GRID_ID + "' value1='" + d.STATION_ID + "' value2='" + d.GRID_ZOOM + "'>" + d.GRID_NAME + "</option>"
            })
            e1.html(baseFullOption);
            if(user_level>4){
                e1.attr("disabled","disabled");
                e1.find("option[value=" + ${sessionScope.UserInfo.GRID_NO} + "]").attr("selected", "selected");
                e1.find("option[value!=" + ${sessionScope.UserInfo.GRID_NO} + "]").remove();
            }
            e1.append(str);
        })
    }
    var name_list = "";
    function setVillages(id, e1) {
        var latn_id = $("#vill_dif_latn_selected option:selected").val()
        var bureau_no = $("#vill_dif_bureau_selected option:selected").val()
        name_list = new Array();
        $.post(url4Query_village_diff, {
            eaction: "setvillages",
            id: id,
            latn_id: latn_id,
            bureau_no: bureau_no,
            village_except: village_id,
            acct_month: '${last_month.VAL}',
            stl: tag_market_index,
            jzcd_flag: tag_compete_index,
            villageMode_flag: tag_gm_index,
            grid_id:'${sessionScope.UserInfo.GRID_NO}'
        }, function (data) {
            data = $.parseJSON(data);
            e1.unbind();
            e1.on("change", function () {
            })
            var str = ''
            $.each(data, function (i, d) {
                str += "<option value='" + d.VILLAGE_ID + "'>" + d.VILLAGE_NAME + "</option>";
                name_list[i] = d;
            })
            e1.html(baseFullOption)
            e1.append(str)
        })
    }

    function before_load_build_list_sj() {
        //$("#collect_new_build_name_sj").val("");
        $("#vill_dif_vil_selected_input").val("");
    }
    var select_count = 0;
    function load_name_list_filter() {
        setTimeout(function () {
            //下拉列表显示
            var $name_list = $("#vill_dif_vil_selected_name_list");
            $name_list.empty();
            if (select_count <= 1) {
                before_load_build_list_sj();
            }

            var v_name = $("#vill_dif_vil_selected_input").val().trim();
            if (v_name != '') {
                var temp;
                var newRow = "";
                for (var i = 0, length = name_list.length, count = 0; i < length; i++) {
                    if ((temp = name_list[i].VILLAGE_NAME).indexOf(v_name) != -1) {
                        newRow += "<li title='" + temp + "' onclick='select_village_name(\"" + temp + "\",\"" +
                        name_list[i].VILLAGE_ID + "\"," + i + ")'>" + temp + "</li>";
                        count++;
                    }
                    if (count >= 15) {
                        break;
                    }
                }
                $name_list.append(newRow);
                $("#vill_dif_vil_selected_name_list").show();
            } else {
                $("#vill_dif_vil_selected_name_list").hide();
            }

            //联动改变 select框, 只要不做点击, 都会将select改回全部.
            // $("#vill_dif_vil_selected option:eq(0)").attr('selected','selected');
            select_count++;
        }, 800)
    }

    function select_village_name(name, id, index) {
        $("#vill_dif_vil_selected option[value=" + id + "]").attr('selected', 'selected');
        $("#vill_dif_vil_selected_name_list").hide();
        $("#vill_dif_vil_selected_input").val(name);
        //$("#vill_dif_vil_selected").change();
    }
    function vil_name_changed() {
        $("#vill_dif_vil_selected_input").val($("#vill_dif_vil_selected option:selected").text());
    }
</script>