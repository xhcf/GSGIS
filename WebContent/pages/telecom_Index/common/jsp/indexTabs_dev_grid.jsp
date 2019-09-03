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
<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<c:resources type="easyui,app" style="b"/>
<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
<link href='<e:url value="/pages/telecom_Index/common/css/indexTabs_dev_grid.css"/>' rel="stylesheet" type="text/css" media="all"/>
<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script>
<!-- echarts 3.2.3 -->
<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
<style>
    div.tab_menu a {
        cursor: pointer;
        display: inline-block;
        float: left;
        height: 22px;
        line-height: 22px;
        width: 60px;
        border-radius: 2px;
        text-align: center;
        color: #a7d9ff;
        text-decoration: none;
    }

    div.tab_menu a.selected {
        background-color: #025aac;
        color: #fff;
    }

    div.tab_box {
        clear: both;
    }

    input {
        line-height: 22px !important;
        height: 22px !important;

        border-radius: none;
        border: none;
        padding: 0;
        outline: none;
    }

    input[type="button"]::-moz-focus-inner {
        border: none;
        padding: 0;
        margin-top: -8px;
    }

    @media screen and (max-height: 1080px) {
        .target_wrap h3 {
            margin-top: 4px !important;
            font-size: 16px;
        }

        .target_list li {
            float: left;
            width: 33.33%;
            text-align: center;
            border-right: 1px dashed rgb(52, 51, 127);
            height: 86%;
        }

        .target_list p.target_title {
            padding: 4px 30px;
            font-size: 12px;
            margin-top: 10px;
        }

        .target_list dt {
            font-size: 18px;
            margin: 10px 0;
        }

        .target_list dd {
            font-size: 14px;
            height: 20px;
            padding-left: 10px;
            text-align: center;
            line-height: 20px;
            background-image: url("../images/phone.png");
            background-repeat: no-repeat;
            margin-left: 8px;
            margin-top: 20px;
        }

        .clearfix {
            overflow: hidden;
            _zoom: 1;
            clear: both;
            margin-top: -12px;
        }

        /*模块文字描述*/
        .copment {
            width: 100%;
            height: 20px;
            margin-left: -20px;
        }

        .dopment {
            width: 100%;
            height: 20px;
            margin-left: 10px;

        }

        .comp {
            display: inline-block;
            margin-left: 30px;
        }

        .com_white {
            color: #fff;
            font-size: 12px;
        }

        .com_yellow {
            color: #ffd305;
            font-size: 12px;
        }

        /*竞争表格*/
        #compment {
            color: #fff;
            width: 100%;
            margin-top: 5px;
            height: 70%;
        }

        #compment th {
            background-color: #02004f;
            color: #00deff;
            border: 1px solid rgb(70, 120, 175);
            font-size: 11px;
        }

        #compment td {
            color: #fff;
            text-align: center;
            border: 1px solid rgb(70, 120, 175);
            font-size: 11px;
        }

        /*发展*/
        #tab_btn {
            margin-top: -25px;
        }

        .domp {
            display: inline-block;
            margin-left: 30px;
        }

        #Development {
            width: 100%;
            height: 88%;
            -webkit-tap-highlight-color: transparent;
            user-select: none;
            position: relative;
            background: transparent;
            margin-top: 10px;
        }
    }

    @media screen and (max-height: 768px) {
        .target_wrap h3 {
            margin-top: 4px !important;
            font-size: 16px;
        }

        .target_list li {
            float: left;
            width: 33.33%;
            text-align: center;
            border-right: 1px dashed rgb(52, 51, 127);
            height: 86%;
            margin-top: 0px;
        }

        .target_list p.target_title {
            padding: 4px 30px;
            font-size: 12px;
            margin-top: 10px;
        }

        .target_list dt {
            font-size: 16px;
            margin: 10px 0;
        }

        .target_list dd {
            font-size: 12px;
            height: 20px;
            padding-left: 4px;
            text-align: center;
            line-height: 20px;
            background-image: url("../images/phone.png");
            background-repeat: no-repeat;
            margin-left: 8px;
            margin-top: -5px;
        }

        .clearfix {
            overflow: hidden;
            _zoom: 1;
            clear: both;
            margin-top: -12px;
        }

        /*模块文字描述*/
        .copment {
            width: 100%;
            height: 20px;
            margin-top: -8px;
            margin-left: 0px
        }

        .dopment {
            width: 100%;
            height: 20px;
            margin-top: -5px;
        }

        .comp {
            display: inline-block;
            margin-left: 8px;
        }

        .domp {
            display: inline-block;
            margin-left: 8px;
        }

        .com_white {
            color: #fff;
            font-size: 12px;
        }

        .com_yellow {
            color: #ffd305;
            font-size: 12px;
        }

        /*竞争表格*/
        #compment {
            color: #fff;
            width: 100%;
            margin-top: 5px;
            height: 66%;
        }

        #compment th {
            background-color: #02004f;
            color: #00deff;
            border: 1px solid rgb(70, 120, 175);
            font-size: 11px;
        }

        #compment td {
            color: #fff;
            text-align: center;
            border: 1px solid rgb(70, 120, 175);
            font-size: 11px;
        }

        /*发展*/
        #tab_btn {
            margin-top: -20px;
        }

        .domp {
            display: inline-block;
            margin-left: 18px;
        }

        #Development {
            width: 100%;
            height: 78%;
            -webkit-tap-highlight-color: transparent;
            user-select: none;
            position: relative;
            background: transparent;
        }
    }

    @media screen and (max-height: 600px) {
        .target_wrap h3 {
            margin-top: -3px !important;
            font-size: 14px;
        }

        .target_list li {
            float: left;
            width: 33.33%;
            text-align: center;
            border-right: 1px dashed rgb(52, 51, 127);
            height: 86%;
            margin-top: 10px;
        }

        .target_list p.target_title {
            padding: 3px 25px;
            font-size: 12px;
            margin-top: 10px;
        }

        .target_list dt {
            font-size: 14px;
            margin: 10px 0;
        }

        .target_list dd {
            font-size: 12px;
            height: 20px;
            padding-left: 4px;
            text-align: center;
            line-height: 20px;
            background-image: url("../images/phone.png");
            background-repeat: no-repeat;
            margin-left: 8px;
            margin-top: -10px;
        }

        .clearfix {
            overflow: hidden;
            _zoom: 1;
            clear: both;
            margin-top: -30px;
            height: 100%;
        }

        /*模块文字描述*/
        .copment {
            width: 100%;
            height: 20px;
            margin-top: -12px;
            margin-left: 0px;
        }

        .dopment {
            width: 100%;
            height: 20px;
            margin-top: -5px;
        }

        .comp {
            display: inline-block;
            margin-left: 8px;
        }

        .domp {
            display: inline-block;
            margin-left: 0px;
        }

        .com_white {
            color: #fff;
            font-size: 12px;
        }

        .com_yellow {
            color: #ffd305;
            font-size: 12px;
        }

        /*竞争表格*/
        #compment {
            color: #fff;
            width: 100%;
            margin-top: 0px
        }

        #compment th {
            background-color: #02004f;
            color: #00deff;
            border: 1px solid rgb(70, 120, 175);
            font-size: 11px;
        }

        #compment td {
            color: #fff;
            text-align: center;
            border: 1px solid rgb(70, 120, 175);
            font-size: 11px;
        }

        /*发展*/
        #tab_btn {
            margin-top: -25px;
        }

        .domp {
            display: inline-block;
            margin-left: 18px;
        }

        #Development {
            width: 100%;
            height: 70%;
            -webkit-tap-highlight-color: transparent;
            user-select: none;
            position: relative;
            background: transparent;
        }
    }

    .datagrid-header td.datagrid-header-over {
        background: none;
        cursor: pointer;
        border: none
    }


    .datagrid-body td, .datagrid-footer td {
        border: none;
    }

    .datagrid-body td, .datagrid-footer td {
        border-top: 1px solid #fff;
    }



    .datagrid-header .datagrid-cell span {
        color: #00deff;
    }



    .datagrid-pager .pagination {
        display: none;
    }

    .datagrid-htable td {
        border: none;
        cursor: default;
    }



    /*--------适配1920x1080分辨率-------*/
    @media screen and (min-height: 750px) {


        .target_wrap:last-child {
            padding: 1.2rem 0.4rem 0.2rem;
        }
        .target_wrap {
            padding: 1.2rem 0.4rem;
            height: 28% !important;
            padding-top: 0px;
        }
        .target_list p.channel_title {
            padding: 2px 20px;
            font-size: 15px;
        }
        .point_rank_tab th {
            padding: 10px 0;
        }
        .point_rank_tab td {
            padding: 4px 0;
        }

        .target_list {
            padding-top: 20px;
        }
    }

    .date span {
        color: #ffd200;
    }


    ::-webkit-scrollbar {
        width: 6px;
    }

    /* 滚动槽 */
    ::-webkit-scrollbar-track {
        -webkit-box-shadow: inset006pxrgba(0, 0, 0, 0.3);
        background: rgba(1, 12, 113, 1);
    }

    /* 滚动条滑块 */
    ::-webkit-scrollbar-thumb {
        background: rgba(6, 19, 140, 1);
        -webkit-box-shadow: inset006pxrgba(0, 0, 0, 0.5);
    }

    ::-webkit-scrollbar-thumb:window-inactive {
        background: rgba(11, 26, 165, 1);
    }

    ::-moz-scrollbar {
        width: 6px;
    }

    /* 滚动槽 */
    ::-moz-scrollbar-track {
        -moz-box-shadow: inset006pxrgba(0, 0, 0, 0.3);
        background: rgba(1, 12, 113, 1);
    }

    /* 滚动条滑块 */
    ::-moz-scrollbar-thumb {
        background: rgba(6, 19, 140, 1);
        -moz-box-shadow: inset006pxrgba(0, 0, 0, 0.5);
    }

    ::-moz-scrollbar-thumb:window-inactive {
        background: rgba(11, 26, 165, 1);
    }
</style>
<body style="width:100%;border:0px;overflow:hidden;height: 100%" class="g_target">
    <h1>党政军营销单元5</h1>
    <div class="target_wrap" style="height:21% !important">
        <h3>基础信息</h3>
        <ul class="target_list clearfix">
            <li>
                <p class="target_title">所属支局</p>
                <dl>
                    <dt>党政军客户营销分部</dt>
                </dl>
            </li>
            <li>
                <p class="target_title">网格经理</p>
                <dl>
                    <dt>张三</dt>
                    <dd>13609276318</dd>
                </dl>
            </li>
            <li class="b_none">
                <p class="target_title">帮扶党员</p>
                <dl>
                    <dt>李四</dt>
                    <dd>17692087631</dd>
                </dl>
            </li>
        </ul>
    </div>

    <div class="target_wrap" style="position: relative;height:24% !important;width: 98%;">
        <h3>竞争</h3>
        <div class="copment">
            <ul>
                <li class="comp"><span class="com_white">人口数：</span><span class="com_yellow">29800</span></li>
                <li class="comp"><span class="com_white">家庭数：</span><span class="com_yellow">29800</span></li>
                <li class="comp"><span class="com_white">移动：</span><span class="com_yellow">29800</span></li>
                <li class="comp"><span class="com_white">宽带：</span><span class="com_yellow">29800</span></li>
            </ul>
        </div>
        <table id="compment">
            <tr>
                <th rowspan="2" style="border-left: none">运营商</th>
                <th colspan="2">移动市场</th>
                <th colspan="2">宽带市场</th>
                <th colspan="2">电视市场</th>
                <th colspan="2" style="border-right: none">移动收入市场</th>
            </tr>
            <tr>
                <th>用户数</th>
                <th>渗透率</th>
                <th>用户数</th>
                <th>渗透率</th>
                <th>用户数</th>
                <th>渗透率</th>
                <th>收入</th>
                <th style="border-right: none">占有率</th>
            </tr>
            <tr>
                <td style="border-left: none">电信</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td style="border-right: none"></td>

            </tr>
            <tr>
                <td style="border-left: none">移动</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td style="border-right: none"></td>

            </tr>
            <tr>
                <td style="border-left: none">联通</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td style="border-right: none"></td>

            </tr>
        </table>
    </div>

    <div class="target_wrap"
         style=" height:20% !important;position: relative;border-bottom: 1px solid #28266a;padding-bottom: 5px">
        <h3>收入</h3>
    </div>
    <div class="target_wrap" style=" border:none;height:24% !important;position: relative">
        <h3>发展</h3>
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
        <div id="Development"></div>
        <div style="position: fixed;bottom: 1px">
            <div class="dopment">
                <ul>
                    <li class="domp"><span class="com_white">移动当日：</span><span class="com_yellow">29800</span></li>
                    <li class="domp"><span class="com_white">宽带当日：</span><span class="com_yellow">29800</span></li>
                    <li class="domp"><span class="com_white">电视当日：</span><span class="com_yellow">29800</span></li>
                </ul>
            </div>
            <div class="dopment">
                <ul>
                    <li class="domp"><span class="com_white">移动当月：</span><span class="com_yellow">29800</span></li>
                    <li class="domp"><span class="com_white">宽带当月：</span><span class="com_yellow">29800</span></li>
                    <li class="domp"><span class="com_white">电视当月：</span><span class="com_yellow">29800</span></li>
                </ul>
            </div>
        </div>
    </div>
</div>

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

    var myChart = echarts.init(document.getElementById('Development'));

    // 指定图表的配置项和数据
    var option = {
        title: {
            show: false
        },
        tooltip: {
            z: 9999999
        },
        legend: {
            show: false
        },
        grid: {
            width: '95%',
            height: '75%',
            borderColor: 'transparent',
            y: 14,
            x: 5
        },
        xAxis: {
            axisLabel: {
                textStyle: {color: '#b3b3b3'},
                show: false
            }, splitLine: {
                show: false
            },
            axisLine: {
                show: true
            },
            data: ['20170601', '20170602', '20170603', '20170604', '20170605', '20170606', '20170607', '20170608', '20170609', '20170610', '20170611', '20170612', '20170613', '20170614', '20170615', '20170616', '20170617', '20170618', '20170619', '20170620', '20170621', '20170622', '20170623', '20170624', '20170625', '20170626', '20170627', '20170628', '20170629', '20170630']
        },
        yAxis: {
            axisLabel: {
                textStyle: {color: '#b3b3b3'}
            },
            splitLine: {
                show: false
            },
            show: false
        },
        series: [{
            name: '装机',
            type: 'line',
            stack: 'one',
            itemStyle: {
                normal: {
                    color: '#03d2e3',
                    lineStyle: {
                        color: '#03d2e3',
                        width: 1
                    }
                }
            },
            areaStyle: {
                normal: {
                    color: '#03d2e3',
                    opacity: 0.2
                }
            },
            data: [13, 12, 32, 23, 32, 28, 9, 10, 13, 12, 32, 23, 32, 28, 9, 10, 13, 12, 32, 23, 32, 28, 9, 10]
        }]
    };

    // 使用刚指定的配置项和数据显示图表。
    $(function () {
        parent.updateTabPosition();
        myChart.setOption(option);
    });

</script>
</body>