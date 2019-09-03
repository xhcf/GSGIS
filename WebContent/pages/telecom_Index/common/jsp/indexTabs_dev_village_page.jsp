<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
    select to_char((to_date(min(const_value), 'yyyymmdd')),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="lastMonth">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '3'
</e:q4o>
<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<c:resources type="easyui,app" style="b"/>
<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
<link href='<e:url value="/pages/telecom_Index/common/css/indexTabs_dev_village_new.css"/>' rel="stylesheet" type="text/css" media="all" />
<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>

<body style="width:100%;border:0px;overflow:hidden;height: 100%" class="g_target">
<h1></h1>
<div id="base_content">
    <div class="target_dev" style="width: 100%">
        
        <div class="devep">
            <div class="deve_ta">
                <div class="tave">概<br/>况</div>
                <div class="tava">
                    <div  class="tavae"  id="rzl"></div>
                    <div style="width: 100%;color: #8fa1c3;font-size: 12px" id="spe">入住率</div>
                </div>
            </div>
            <div class="deve_tb">

                <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">楼宇数：<span id="bn"></span></span><span style="position: absolute;left: 128px;">单元数：<span id="dn"></span></span></div>
                <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">人口数：<span id="rn"></span></span><span style="position: absolute;left: 128px;">住户数：<span id="zn"></span></span></div>

            </div>
        </div>
        <div class="devep" >
            <div class="deve_ta">
                <div class="tave">资<br/>源</div>
                <div class="tava">
                    <div class="tavae" id="hly"></div>
                    <div style="width: 100%;color: #8fa1c3;font-size: 12px">H 利用率</div>
                </div>
            </div>
            <div class="deve_tb">

                <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">独家进线：<span id="dj"></span></span></div>
                <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">光网覆盖：<span id="hf"></span></span><span style="position: absolute;left: 128px;">H端口数：<span id="hp"></span></span></div>

            </div>
        </div>
        <div class="devep">
            <div class="deve_ta">
                <div class="tave">业<br/>务</div>
                <div class="tava">
                    <div class="tavae" id="b_n"></div>
                    <div style="width: 100%;color: #8fa1c3;font-size: 12px">宽带用户数</div>
                </div>
            </div>
            <div class="deve_tb">

                <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">H用户数：<span id="h_n"></span></span></div>
                <div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">电视用户数：<span id="i_n"></span></span><span style="position: absolute;left: 128px;"> 移动用户数：<span id="m_n"></span></span></div>

            </div>
        </div>

    </div>
    <div class="target_wrap" style="position: relative;height:28% !important;width: 98%;">
        <h3 class="wrap_a">市场竞争</h3>
        <div class="figure" id="Histogram"></div>
    </div>
    <div class="target_wrap_a">
        <h3 class="wrap_a">竞争详情</h3>
        <table  class="content_table" style="width:96%;margin: 20px auto;">
            <tr>
                <th>运营商</th>
                <th>移动</th>
                <th>宽带</th>
                <th>电视</th>
            </tr>
            <tr>
                <td>电信</td>
                <td id="dy"></td>
                <td id="db"></td>
                <td id="di"></td>
            </tr>
            <tr>
                <td>联通</td>
                <td id="ly"></td>
                <td id="lb"></td>
                <td id="li"></td>
            </tr>
            <tr>
                <td>移动</td>
                <td id="my"></td>
                <td id="mb"></td>
                <td id="mi"></td>
            </tr>

        </table>
    </div>
</div>



<%--<script src='<e:url value="/pages/telecom_Index/js/freshTab.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshChart.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshRank.js"/>' charset="utf-8"></script>--%>
<script>
    var city_full_name = parent.global_current_full_area_name;
    var city_name = parent.global_current_area_name;
    var village_id=parent.global_village_id
    var url4Query = parent.url4Query;
    var name=city_name.length>8?city_name.substr(0,7)+'..':city_name
    $("h1").text(name)
    $("h1").attr("title",((city_full_name==null||city_full_name=='null'||city_full_name=='undefined')?'':city_full_name)+" "+city_name)
    var myChart = echarts.init(document.getElementById('Histogram'));

    //鼠标悬浮显示和离开不显示
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

    $(function(){
        //小区基础数据展示
        $.post(url4Query,{eaction:'village_message',village_id:village_id},function (data) {
            var d =$.parseJSON(data)
          freshFigue([d.MOBILE_ST_RATE.toFixed(2),d.WIDEBAND_ST_RATE.toFixed(2),d.IPTV_ST_RATE.toFixed(2),d.H_USER_ST_RATE.toFixed(2)])
            $("#bn").text(d.BUILDING_NUM==null?'-':d.BUILDING_NUM)
            $("#rn").text(d.PEOPLE_NUM==null?'-':d.PEOPLE_NUM)
            $("#dn").text(d.UNIT_NUM==null?'-':d.UNIT_NUM)
            $("#zn").text(d.FAMILY_NUM==null?'-':d.FAMILY_NUM)
            $("#dj").text(d.IS_SOLE==null?'-':d.IS_SOLE)
            $("#hf").text(d.IS_FDDI==null?'-':d.IS_FDDI)
            $("#hp").text(d.H_PORT_NUM==null?'-':d.H_PORT_NUM)
            $("#b_n").text(d.WIDEBAND_NUM==null?'-':d.WIDEBAND_NUM)
            $("#h_n").text(d.H_USER_NUM==null?'-':d.H_USER_NUM)
            $("#i_n").text(d.IPTV_NUM==null?'-':d.IPTV_NUM)
            $("#m_n").text(d.MOBILE_NUM==null?'-':d.MOBILE_NUM)
            $("#hly").text(d.H_PORT_USE_RATE==null?'-':(d.H_PORT_USE_RATE)+'%')
            $("#rzl").text(d.OCCUPANCY_RATE==null?'-':d.OCCUPANCY_RATE+'%')
            //更新表格
           //电信
            $("#dy").text(d.MOBILE_NUM==null?'-':d.MOBILE_NUM)
            $("#db").text(d.WIDEBAND_NUM==null?'-':d.WIDEBAND_NUM)
            $("#di").text(d.IPTV_NUM==null?'-':d.IPTV_NUM)
            //联通
            $("#my").text(d.CMCC_NUM==null?'-':d.CMCC_NUM)
            $("#mb").text(d.CM_WIDEBAND_NUM==null?'-':d.CM_WIDEBAND_NUM)
            $("#mi").text(d.CMCC_TV_NUM==null?'-':d.CMCC_TV_NUM)
            //移动
            $("#ly").text(d.CUCC_NUM==null?'-':d.CUCC_NUM)
            $("#lb").text(d.CU_WIDEBAND_NUM==null?'-':d.CU_WIDEBAND_NUM)
            $("#li").text(d.CUCC_TV_USER_NUM==null?'-':d.CUCC_TV_USER_NUM)
            if(d.VILLAGE_TYPE!='1')
                    $("#spe").text('H 入户率')
        })


    function freshFigue(fourdata){
        var option = {
            title: {
                text: ''
            },
            tooltip : {
                trigger: 'axis',
                formatter:'{b}<br/>{a}:&nbsp;&nbsp;{c}%',
                position:"top",
                show:false,
            },
            legend: {
                show:false
            },
            toolbox: {
                show:false
            },
            grid: {
                /*left: '3%',
                 right: '4%',
                 bottom: '3%',*/
                top: 20,
                left:30,
                right:40,
                bottom:45,
                //containLabel: true,
                align:"right"
            },
            xAxis : [
                {
                    min:1,
                    max:31,
                    scale:0,
                    splitNumber:1,
                    minInterval:1,
                    interval:1,
                    type : 'category',
                    axisLabel: {
                        show: true,
                        textStyle: {
                            fontSize: '12',
                            color:'#fff',
                        }
                    },
                    show: true,

                    boundaryGap : false,
                    data :['移动渗透率','宽带入户率','电视入户率','光网入户率']
                }
            ],
            yAxis : [
                {
                    silent: true,
                    show: false,
                    splitLine: {
                        show: false
                    },
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'上月',
                    type:'bar',
                    stack: '总量',
                    smooth:true,
                    barMinHeight:10,
                    itemStyle: {
                        normal: {
                            color: function(params) {
                                //首先定义一个数组
                                var colorList = [
                                    '#1dbbb5','#fa8513','#b5ef8e','#109afb'
                                ];
                                return colorList[params.dataIndex]
                            },
                            //以下为是否显示
                            label: {
                                show: true,
                                formatter:'{c}%',
                                textStyle: {
                                    fontWeight: '700',
                                    fontSize: '12',
                                    color:'#fff',
                                }
                            },
                            lineStyle: {
                                color: '#03d2e3',
                                width:1
                            }
                        }
                    },
                    barWidth:35,
//					barGap:'20%',
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    data:fourdata
                }
            ]
        };
        myChart.setOption(option);
    }
    })
</script>
</body>
