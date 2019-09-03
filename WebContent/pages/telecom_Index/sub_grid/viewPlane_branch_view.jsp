<%--
  Created by IntelliJ IDEA.
  User: xuezhang
  Date: 17/6/21
  Time: 下午6:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<html>
<head>
    <title>支局视图</title>
    <meta charset="utf-8">
    <meta name="author" content="jasmine"><!-- 定义作者-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_branch_view.css"/>' rel="stylesheet"
          type="text/css" media="all"/>
    <link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <script type="text/javascript"
            src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script type="text/javascript"
            src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script type="text/javascript" src='<e:url value="/pages/telecom_Index/sub_grid/js/heatmap.js"/>'></script>
    <script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
    <style>
        #heatmapArea {
            position: absolute;
            left: 14px;
            width: 100%;
            height: 100%;
            z-index: -999;
            bottom: 6px;
        }
        .prop{
            margin-top: -20px;
        }
        #grid_data tr td{
            height: 30px;
            line-height: 30px;
            text-align: center;
            font-size: 12px;
        }
    </style>
</head>
<body style="background-color: #0a1e66">
<div class="toptt">

</div>
<div class="content-left">
    <div class="content-top">
        <ul id='tabnav' class="tabul">
            <li class='active' id="act">
                <div class="ali">
                    <div class="image_typea"></div>
                    <div class="type_a">用户云图</div>
                </div>
            </li>
            <li class="nor">
                <div class="ali">
                    <div class="image_typeb"></div>
                    <div class="type_a">话务云图</div>
                </div>
            </li>
            <li class="nor">
                <div class="ali">
                    <div class="image_typec"></div>
                    <div class="type_a">流量云图</div>
                </div>
            </li>
        </ul>

        <div class="non" id="non"></div>
        <div id="heatmapArea">
            <div id="heatLayer"></div>
            <div id="map" style="height: 100%;z-index: -999"></div>
            <div class="find" id="fin">
                <span class="pp">账期时间：</span>
                <input type="text" id="dd" class="easyui-datebox" style="width: 90px;color: #ffffff" value="${yesterday.val}" name="edb"/>
                <input type="radio" name="location" value="1" checked="checked" class="radio-a"><span style="font-size: 9px; color: #ffffff">居住地</span>
                <input type="radio" name="location" value="2" class="radio-a"><span style="font-size: 9px; color: #ffffff">工作地</span>
                <input type="button" value="查询" class="inbu" style="cursor: pointer"/>
            </div>
            <script type="text/javascript">
                $("#dd").datebox({
                    formatter:function (date) {
                        var y = date.getFullYear();
                        var m = date.getMonth()+1;
                        var d = date.getDate();
                        return y+(m>9?m+'':"0"+m)+(d>9?d+'':"0"+d)
                    }
                })
            </script>
        </div>
    </div>
    <div id="table_grid" style="display: none;max-height: 260px">
        <table id="grid_data" border="solid" style="collapse: 0;width: 100%">
            <tr ><td rowspan="2" style="font-weight: bold">网格名称</td><td colspan="2" style="font-weight: bold">当月收入(万元)</td><td colspan="2" style="font-weight: bold">当月发展(户)</td><td colspan="2" style="font-weight: bold">上月到达(户)</td></tr>
            <tr ><td style="font-weight: bold">移动</td><td style="font-weight: bold">固网</td><td style="font-weight: bold" style="font-weight: bold">移动</td><td style="font-weight: bold">宽带</td><td style="font-weight: bold">移动</td><td style="font-weight: bold">宽带</td></tr>
        </table>
    </div>
    <div class="content-bottom">
        <div style="height:32px">
            <div class="tt">重点业务日发展趋势</div>
            <div class="btn_c" style="z-index:999">
                <ul id="tab_btn">
                    <li class="btn_active" data="0">
                        <a>移动</a>
                    </li>
                    <li class="btn_uc" data="1">
                        <a>宽带</a>
                    </li>
                    <li class="btn_uc" data="2">
                        <a>ITV</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="main_ec" style="height:100%;width:100%;margin: -10px auto;"></div>
    </div>
</div>
</div>
<!-- 右部 div -->
<div class="content-right">
    <div class="right_contenta" style="border-bottom:1px solid #073b8a;">
        <div style="height:32px;width:100%">
            <span
                  class="branch_name tt">--</span>
            <span  style="font-size: 16px;color: #fff;height: 24px;line-height: 24px;margin-left: 10px;padding-top: 5px;float:right;">网格数量：<a
                    style="color:#ffd200;padding-right:20px;text-decoration: underline;cursor:pointer"
                    class="grid_num">4</a></span>
        </div>
        <div class="right_contentb" style="text-align:center;margin:10 auto;">
            <ul>
                <li class="special">
                    <span class="numf">--</span>
                    <div class="naf">移动计费用户</div>
                </li>
                <li class="special">
                    <span class="numf">--</span>
                    <div class="naf">宽带计费用户</div>
                </li>
                <li class="special">
                    <span class="numf">--</span>
                    <div class="naf">ITV装机数</div>
                </li>
                <li class="special">
                    <span class="numf">--</span>
                    <div class="naf">当月累计收入</div>
                </li>
            </ul>
        </div>
        <div class="right_contentb" style="text-align:center;margin:20 auto;">
            <ul>
                <li class="specials">
                    <span class="numfs">--</span>
                    <div class="naf">移动当月新增</div>
                </li>
                <li class="specials">
                    <span class="numfs">--</span>
                    <div class="naf">宽带当月新增</div>
                </li>
                <li class="specials">
                    <span class="numfs">--</span>
                    <div class="naf">ITV当月新增</div>
                </li>
                <li class="specials">
                    <span class="numfs">--</span>
                    <div class="naf"> 终端当月新增</div>
                </li>
            </ul>
        </div>
    </div>
    <div class="right_contentb" style="border-bottom:1px solid #073b8a">
        <div class="tt">营销信息</div>
        <div class="right_contentb" style="text-align:center;margin:20 15;">
            <ul>
                <li class="marketing">
                    <div class="numms">--</div>
                    <div class="bottom">
                        <div class="proportion" style="width: 0%"></div>
                        <span class="prop">0%</span>
                    </div>
                    <div class="nam">宽带包年到期用户</div>
                </li>
                <li class="marketing">
                    <div class="numms">--</div>
                    <div class="bottom">
                        <div class="proportion" style="width:0%"></div>
                        <span class="prop">0%</span>
                    </div>
                    <div class="nam">宽带合约到期用户</div>
                </li>
                <li class="marketing">
                    <div class="numms">--</div>
                    <div class="bottom">
                        <div class="proportion" style="width:0%"></div>
                        <span class="prop">0%</span>
                    </div>
                    <div class="nam">宽带欠费提醒用户</div>
                </li>
            </ul>
        </div>
        <div class="right_contentb" style="text-align:center;margin:20 15;">
            <ul>
                <li class="marketing">
                    <div class="nummsp">--</div>
                    <div class="bottom">
                        <div class="proportion_a" style="width:0%"></div>
                        <span class="prop">0%</span>
                    </div>
                    <div class="nam">宽带余额不足用户</div>
                </li>
                <li class="marketing">
                    <div class="nummsp">--</div>
                    <div class="bottom">
                        <div class="proportion_a" style="width:0%"></div>
                        <span class="prop">0%</span>
                    </div>
                    <div class="nam">终端营销用户</div>
                </li>
                <li class="marketing">
                    <div class="nummsp">--</div>
                    <div class="bottom">
                        <div class="proportion_a" style="width:0%"></div>
                        <span class="prop">0%</span>
                    </div>
                    <div class="nam">终端协议到期用户</div>
                </li>
            </ul>
        </div>
    </div>
    <div class="right_contentc">
        <div class="tt">资源信息</div>
        <div class="right_contentb" style="text-align:center;margin:30 15;">
            <ul>
                <li class="re">
                    <div class="resou_a"></div>
                    <div class="resour_a">
                        <div class="nar">住户数</div>
                        <div class="numms">--</div>
                    </div>
                </li>
                <li class="re">
                    <div class="resou_b"></div>
                    <div class="resour_a">
                        <div class="nar">宽带数</div>
                        <div class="numms">--</div>
                    </div>
                </li>
                <li class="re">
                    <div class="resou_c"></div>
                    <div class="resour_a">
                        <div class="nar">市场占有率</div>
                        <div class="numms">--</div>
                    </div>
                </li>
            </ul>
        </div>
        <div class="right_contentb" style="text-align:center;margin:30 15;">
            <ul>
                <li class="re">
                    <div class="resou_d"></div>
                    <div class="resour_a">
                        <div class="nar">端口数</div>
                        <div class="numms">--</div>
                    </div>
                </li>
                <li class="re">
                    <div class="resou_e"></div>
                    <div class="resour_a">
                        <div class="nar">占用端口数</div>
                        <div class="numms">--</div>
                    </div>
                </li>
                <li class="re">
                    <div class="resou_f"></div>
                    <div class="resour_a">
                        <div class="nar">端口使用率</div>
                        <div class="numms">--</div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>


<!-- ECharts单文件引入 -->
<script type="text/javascript">
    var map;
    var heatLayer;
    var featureLayer;
    var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
    var current_city='兰州';
    var new_url_sub_grid = "http://135.149.48.47:6080/arcgis/rest/services/EDA/GRID_SUB/MapServer";
    var union_org_code = '${param.substation}';
    if (union_org_code==null||union_org_code==undefined||union_org_code==''){
        union_org_code="862010901010303"
    }
    var city_full_name = parent.global_parent_area_name;//兰州市
    var layer_ds = getMapServer('兰州市')
    var zq_date='${yesterday.val}'
    function getMapServer(cityName) {
    return "http://135.149.48.47:6080/arcgis/rest/services/NewMap/" + cityNames[cityName] + "/MapServer";
    }
    require(["esri/map", "esri/geometry/Extent", "esri/symbols/SimpleMarkerSymbol",
                "esri/symbols/SimpleLineSymbol", "esri/symbols/SimpleFillSymbol", "esri/graphic", "esri/tasks/FeatureSet", "esri/geometry/Point", "esri/SpatialReference", "esri/layers/ArcGISTiledMapServiceLayer", "esri/layers/FeatureLayer", "esri/layers/GraphicsLayer", "esri/tasks/query","esri/tasks/QueryTask",
                "bism/HeatmapLayer", "dojo/dom", "dojo/on", "dojo/domReady!"],
            function (Map, Extent, SimpleMarkerSymbol, SimpleLineSymbol, SimpleFillSymbol, Graphic, FeatureSet, Point, SpatialReference, ArcGISTiledMapServiceLayer, FeatureLayer, GraphicsLayer, Query, QueryTask, HeatmapLayer, dom, on) {

                var circleSymb = new SimpleFillSymbol(
                        SimpleFillSymbol.STYLE_NULL,
                        new SimpleLineSymbol(
                                SimpleLineSymbol.STYLE_SHORTDASHDOTDOT,
                                new esri.Color([105, 105, 105]),
                                2
                        ), new esri.Color([255, 255, 0, 0.25])
                );

                map = new esri.Map("map", {
                    sliderStyle: "small"
                });
                var basemap = new ArcGISTiledMapServiceLayer(layer_ds);
                map.addLayer(basemap);
                var graficLayer = new GraphicsLayer();
                map.addLayer(graficLayer);
                map.on('load', function (theMap) {
                    map.setZoom(2);
                    try {
                        heatLayer = new HeatmapLayer({
                                    config: {
                                        "useLocalMaximum": true,
                                        "radius": 40,
                                        "gradient": {
                                            0.1: "rgb(000,000,255)",
                                            0.2: "rgb(000,255,255)",
                                            0.3: "rgb(000,255,000)",
                                            0.6: "rgb(255,255,000)",
                                            0.8: "rgb(255,123,000)",
                                            1.0:"rgb(255,000,024)"
                                        }
                                    },
                                    "map": map,
                                    "domNodeId": "heatLayer",
                                    "opacity": 0.75
                                }
                        );
                    } catch (ex) {
                        alert(ex);
                    }

                    // 添加热度图层
                    map.addLayer(heatLayer);
                    map.resize()
                    getFeatures();

                });
                /**
                 *
                 * 查询热力图数据并填充
                 * @param union_code 支局区域码
                 * @param ow  0.居住地 1.工作地
                 * @param time 账期时间yyyyMMdd
                 */
                function getHeadDataList(union_code, ow,time) {
                    $.ajax({
                        type: "post",
                        url: url4Query,
                        data: {
                            "union_code": union_code,
                            "ow": ow,
                            "time": time,
                            "eaction": "heatData"
                        },
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            data2=$.parseJSON(data);
                            setDataIntoHeatmap(data, data[0].LATN_NAME)
                        }
                    });
                }

                function setDataIntoHeatmap(data, latn_name) {
                    //设置基本地图,替换图层
                    if (latn_name != null && latn_name != undefined) {
                        if (current_city != latn_name) {
                            map.removeLayer(basemap)
                            var obj;
                            if(latn_center_point[latn_name+"市"]!=null) {
                                basemap = new ArcGISTiledMapServiceLayer(getMapServer(latn_name+"市"))
                            }else {
                                basemap = new ArcGISTiledMapServiceLayer(getMapServer(latn_name+'州'))
                            }
                            getPlace();
                            map.addLayer(basemap)
                            map.reorderLayer(basemap   , 0)
                            current_city = latn_name;
                        }

                    }
                    var featureSet = new FeatureSet();
                    var features = [];
                    $.each(data, function (index, obj) {
                        try {
                            var a1 = new esri.geometry.Point(obj.LONGITUDE1, obj.LATITUDE1, map.spatialReference);

                            var attr1 = {"count": obj.numval};
                            var g1 = new Graphic(a1, circleSymb, attr1);
                            features.push(g1);

                        } catch (ex) {
                            alert(ex);
                        }
                    });
                    featureSet.features = features;
                    heatLayer.setData(featureSet.features);
                }
                // 从要素图层中的得到当前显示范围中的所有要素
                function getFeatures() {
                    getHeadDataList(union_org_code, 1,'20170621');
                }

                var btn = document.getElementsByClassName("inbu")[0]
                btn.onclick = function () {
                  var  val=$("input[class=radio-a]:checked").val()
                    zq_date=$("input[name='edb']").val()
                   getHeadDataList(union_org_code,val,'20170621')
                    doQueryRightData(union_org_code,zq_date)
                }
                function getPlace(){
                      var queryTask=new QueryTask(new_url_sub_grid+"/1")
                      var query = new Query()
                    query.where="SUBSTATION_NO="+union_org_code
                    query.returnGeometry = true;
                    queryTask.execute(query,function (results) {
                        var fs = results.features
                        if(fs.length==0){
                            layer.msg("服务器无数据")
                        }else{
                            var fs1 = fs[0]
                            var geo = fs1.geometry
                            var ext = geo.getExtent() ;

                            var linesymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS,
                                    new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,
                                            new esri.Color([102,204,255,1]), 2),new esri.Color([102,204,255,1])
                            );

                            var graphics = new esri.Graphic(geo, linesymbol);
                            graficLayer.add(graphics)
                            map.setExtent(ext.expand(2.5))
                        }
                    })
                }
            });

    function changeStyle() {
        this.onclick = function () {
            var list = this.parentNode.childNodes;
            for (var i = 0; i < list.length; i++) {
                if (1 == list[i].nodeType) {
                    list[i].className = "btn_uc";
                }
            }
            this.className = 'btn_active';
        }
    }
    var myChart = echarts.init(document.getElementById('main_ec'));
    // 指定图表的配置项和数据
    var option = {
        title: {
            show: false
        },
        tooltip: {
            z: 9999999
        },
        legend: {
            data: ['装机', '拆机'],
            x: 'right',
            itemWidth: 20,
            itemHeight: 10,
            textStyle: {color: '#b3b3b3'},
            align: 'left',
            left: 10,
            y: 1
        },
        grid: {
            width: '95%',
            height: '50%',
            borderColor: 'transparent',
            y: 14,
            x: 20
        },
        xAxis: {
            axisLabel: {
                textStyle: {color: '#b3b3b3'},
                show:true
            }, splitLine: {
                show: false
            },
            axisLine:{
              show:true
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
            type: 'bar',
            stack: 'one',
            itemStyle: {
                normal: {
                    color: '#feef02',
                    lineStyle: {
                        color: '#03d2e3',
                        width: 1
                    }
                }
            },
            data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        },
            {
                name: '拆机',
                type: 'bar',
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
                data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            }]
    };

    // 切换搜索框显示
    var tabs = $('#tabnav li')
    function tab_change(j) {
        for (i = 0; i < 3; i++) {
            tabs[i].className = "nor"
        }
        tabs[j].className = "active";
    }

    var tab_li = $("#tab_btn li")
    var len = tab_li.length;
    var num = 0;
    var timer = null;

    var period_tab_change = 5000 //三大业务发展量 切换显示频率ms
    var i = 0;
    var numf = $(".numf");
    var numfs = $(".numfs")
    var numms = $(".marketing .numms")
    var nummsp = $(".marketing .nummsp")
    var proportion = $(".marketing .bottom .proportion")
    var proportion_a = $(".marketing .bottom .proportion_a")
    var prop = $(".marketing .bottom .prop")
    var numms_data = $(".resour_a .numms")
    var bn = $(".branch_name");
    var gn = $(".grid_num")
    var grids;//弹出表数据
    //右侧数据，弹出网格表 查询 填充
    function doQueryZJ(union_org_code,day) {
        doQueryRightData(union_org_code,day)
        doQueryTableData(union_org_code)
    }
    function doQueryTableData(union_org_code) {
        $.post(url4Query, {eaction: "grids", union_org_code: union_org_code}, function (data) {
            data = $.parseJSON($.trim(data));
            var table_grid=$("#grid_data")
            $.each(data,function (index, obj) {
                var str = "<tr><td>"+obj.GRID_NAME+"</td><td>"+(obj.MOB_I/10000).toFixed(2)+"</td><td>"+(obj.PSTN_I/10000).toFixed(2)+"</td><td>"+obj.FEE_C_S+"</td><td>"+obj.BRD_C_S+"</td><td>"+obj.FEE_L_S+"</td><td>"+obj.BRD_L_S+"</td></tr>"
                table_grid.append(str)
            })
            //装填支局表格
            addTextIntoE(gn[0], data.length)
            grid_num=data.length;
        })
    }
var grid_num;
    function doQueryRightData(union_org_code,day) {
         $.post(url4Query,{eaction:"ZJ_data_h",union_org_code:union_org_code},function (data) {
             data = $.parseJSON($.trim(data))
             addTextIntoE(numf[0], data.FEE_MON)
             addTextIntoE(numf[1], data.BRD_MON)
             addTextIntoE(numf[2], data.I)
         })
         $.post(url4Query, {eaction: "ZJ_data", union_org_code: union_org_code, yesterday:day}, function (data) {
             data = $.parseJSON($.trim(data));
             addTextIntoE(numf[3], (data.FIN_INCOME/10000).toFixed(2)+"万")
             addTextIntoE(numfs[0], data.MOBILE_MON_NEW)
             addTextIntoE(numfs[1], data.BRD_MON_NEW)
             addTextIntoE(numfs[2], data.ITV_MON_NEW)
             addTextIntoE(numfs[3], data.TERMINAL_TOTAL_MON)
             setMarketingData(0, data.BN_EXP_CNT, data.BN_EXP_ZX_CNT)
             setMarketingData(1, data.TC_EXP_CNT, data.TC_EXP_ZX_CNT)
             setMarketingData(2, data.OWE_CNT, data.OWE_ZX_CNT)
             setMarketingData(3, data.BLANCE_CNT, data.BLANCE_ZX_CNT)
             setMarketingData(4, data.ZD_CNT, data.ZD_ZX_CNT)
             setMarketingData(5, data.JZ_CNT, data.JZ_ZX_CNT)
             addTextIntoE(numms_data[0], data.ADDR_NUM)
             addTextIntoE(numms_data[1], data.KD_NUM)
             addTextIntoE(numms_data[2], (data.USE_RATE==0||data.USE_RATE==null)?(data.KD_NUM*100/(data.ADDR_NUM+0.001)).toFixed(0)+"%":(data.USE_RATE * 100).toFixed(0) + "%")
             addTextIntoE(numms_data[3], data.FTTH_PORT_NUM)
             addTextIntoE(numms_data[4], data.FTTH_PORT_ZY_NUM)
             addTextIntoE(numms_data[5], (data.PORT_RATE==0||data.PORT_RATE==null)?(data.FTTH_PORT_ZY_NUM*100/(data.FTTH_PORT_NUM+0.001)).toFixed(0)+"%":(data.PORT_RATE * 100).toFixed(0) + "%")
             addTextIntoE(bn[0], data.BRANCH_NAME)

         })
     }
    function addTextIntoE(e, data) {
        e.innerText = data == null ? "无数据" : data
    }

    function setMarketingData(index, total, zx) {
        prop[index].innerText = total == null || zx == null || zx == 0 || total == 0 ? '0%' : ((zx / total) * 100).toFixed(2) + '%'
        if (index < 3) {
            numms[index].innerText = total == null ? "无数据" : total
            proportion[index].style.width = total == null || zx == null || zx == 0 || total == 0 ? '0%' : ((zx / total) * 100).toFixed(2) + '%'
        } else {
            nummsp[index % 3].innerText = total == null ? "无数据" : total
            proportion_a[index % 3].style.width = total == null || zx == null || zx == 0 || total == 0 ? '0%' : ((zx / total) * 100).toFixed(2) + '%'
        }
    }
    //查询轮播 柱图数据
    function doQueryDayChangeInMonth(union_org_code, dataType) {
        $.post(url4Query, {
            eaction: "day_new",
            dataKind: dataType,
            union_org_code: union_org_code
        }, function (data) {
            var time = []
            var day_new_data = []
            var day_old_data = []
            data = $.parseJSON($.trim(data))
            for (var i = 0; i < data.length; i++) {
                var one = data[i];
                day_new_data[i] = one.NEW_DATA;
                day_old_data[i] = one.OLD_DATA;
                time[i] = one.ACCT_DAY
            }
            option.series[0].data = day_new_data;
            option.series[1].data = day_old_data;//此处为拆机数据
            option.xAxis.data = time;
            myChart.setOption(option)
        })
    }

    function tab_change2() {
        for (i = 0; i < len; i++) {
            tab_li[i].className = "btn_uc"
        }
        tab_li[num].className = "btn_active"
        switch (num) {
            case 0:
                doQueryDayChangeInMonth(union_org_code, "mobile")
                break;
            case 1:
                doQueryDayChangeInMonth(union_org_code, "brd")
                break;
            case 2:
                doQueryDayChangeInMonth(union_org_code, "itv")
                break;
        }
    }


    function auto_play() {
        timer = setInterval(function () {
            num++;
            if (num >= len)num = 0;
            tab_change2();
        }, period_tab_change)
    }
    function getHeight() {
        return grid_num>5?'250px':'auto'
    }
    $(function () {
        var flag=true;
        $("#non").click(function () {
            if (flag){
                $("#fin").animate({right:'-400'},40)
                $("#non").addClass("nonna")
            }else {
                $("#fin").animate({right:'0'},40)
                $("#non").removeClass("nonna")
            }
            flag=!flag
        });
        var tmp='1'
        $(".grid_num").on("click",function () {
            if(tmp!='1'){
                layer.closeAll()
                tmp='1'
            }else{
                tmp='54'
                layer.open({
                    title:['网格信息',"line-height:32px;text-size:30px;height:32px;"],
                    type:1,
                    area:['620px',getHeight()] ,
                    shade:0,
                    content:$("#table_grid"),
                    cancel:function () {
                        return tmp='1'
                    }
                })
            }
        })
        tabs.each(function (index) {
            $(this).on("click", function () {
                tab_change(index);
            })
        })
        tab_li.each(function (index) {
            $(this).on("mouseover", function () {
                clearInterval(timer)
                num = index;
                tab_change2();
            })
            $(this).on("mouseout", function () {
                auto_play();
            })
        })

    })
    auto_play();
    doQueryDayChangeInMonth(union_org_code, "mobile")
    doQueryZJ(union_org_code,zq_date)
</script>
</body>
</html>

