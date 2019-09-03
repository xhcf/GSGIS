/**
 * Created by admin on 2017/3/31.
 */
/*
 冒泡地图
 params echart的option参数
 url4echartmap chartClickAction方法使用 下钻后数据从这里查询
 url4mapToWhere chartClickAction方法使用 下钻后加载的地图，省到市是viewPlane_city(echarts)，市到区县是viewPlane_area(gis)
 */

function setDataToEchartMap(params,url4realTimeSubList,url4mapToWhere){
    //chart.showLoading();
    //wait();
    var fullCityName = params.city_full_name;
    if(params.flag == 3){
        if(city_name_speical.indexOf(fullCityName)>-1)
            params.city_name = fullCityName.replace(/州/gi,'');
        else
            params.city_name = fullCityName.replace(/市/gi,'');
    }
    if(params.flag ==2 && params.city_name != params.parent_name){//flag是2，查询的却不是省名称，则返回
        return;
    }
    /*if(global_backToEcharts){
     global_backToEcharts = false;
     if(city_name_speical.indexOf(fullCityName)>-1)
     fullCityName += '州';
     else
     fullCityName += '市';
     }*/

    var series_name = "当前发展量";
    //表格数据

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    var color = ['#ef0a25', '#ef960a', '#7ad589'];
    //var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    var datas = new Array();

    var min = 0;
    var max = 0;

    $.ajax({
        type:"POST",
        url:url4realTimeSubList,
        data:params,
        success:function(d){
            d = $.parseJSON(d);
            if(d.length==0)
                layer.msg('暂无数据');
            else {
                //地图数据展示用
                var vals = new Array();

                for (var i = 0; i < d.length; i++) {
                    var obj = {};
                    var org_name = d[i].REGION_NAME;
                    /*if(params.flag==2)//市级的名称处理(数据库里市级名称和地图不对应)
                     if(city_name_speical.indexOf(org_name)>-1)
                     org_name += '州';
                     else
                     org_name += '市';*/
                    obj.name = org_name;
                    obj.value = d[i].DEV_MOB;
                    vals.push(obj.value);
                    datas.push(obj);
                }

                if (vals.length > 0) {
                    max = Math.ceil(Math.max.apply(null, vals));
                    min = Math.floor(Math.min.apply(null, vals));
                    if (min == max)
                        min = 0;
                }
            }
        },
        error:function(){
            layer.msg('查询出错');
        },
        complete:function(){
            echartMapReset(min,max,params,series_name,color,datas);
            //chart_mapClickAction(url4echartmap,url4mapToWhere);
            chart_map.hideLoading();
        }
    });
}

function echartMapReset(min_num,max_num,params,series_name,color,data){
    var city_name = params.parent_name;
    if(city_name.indexOf("省")>-1)
        city_name = city_name.replace(/省/gi,'');
    try{
        min_num = parseInt(min_num);
    }catch(e){
        min_num = 0;
    }
    try{
        max_num = parseInt(max_num);
    }catch(e){
        max_num = 0;
    }

    if(max_num==0)
        color = ['#A8A8A8'];

    var symbol_size_temp = (max_num+min_num)/2;
    var step = 15;
    if(max_num>5000)
        step = 5;
    else if(max_num>1000)
        step = 8;
    else if(max_num>500)
        step = 12;

    chart_map.setOption(
        {
            tooltip: {
                trigger: 'axis',
                backgroundColor: 'rgba(0,0,100,0.7)',
                formatter:'{a}<br/>{b}:{c}'
            },
            dataRange: {
                min: min_num,
                max: max_num,
                x: -150,
                calculable: false,
                normal: {
                    show: true
                },
                color: ['#ef0a25', '#ef960a', '#7ad589']
            },
            series: [
                {
                    name: series_name,
                    type: 'map',
                    mapType: '甘肃',
                    selectedMode: false,
                    //hoverable: true,
                    itemStyle: {
                        normal: {
                            borderColor: 'rgba(100,149,237,1)',
                            borderWidth: 1.5,
                            areaStyle: {
                                color: 'transparent'
                            },
                            label: {
                                show: true,
                                textStyle: {
                                    color: '#fff',
                                    fontSize: 14,
                                    fontFamliy: '微软雅黑',
                                    fontWeight: 500
                                }
                            }
                        },
                        emphasis:{
                            color:'transparent'
                        }
                    },
                    // roam:true,
                    data: [],
                    markPoint: {
                        symbol: 'emptyDiamond',
                        symbolSize: function (v) {
                            return 10; //v / (symbol_size_temp/step)
                        },
                        effect: {
                            show: true,
                            shadowBlur: 0
                        },
                        itemStyle: {
                            normal: {
                                label: {show: false}
                            },
                            emphasis: {
                                label: {show: false}
                            }
                        },
                        /*
                         * 闪烁点
                         */
                        /*
                        symbolSize: 10,
                        large: true,
                        effect : {
                            show: true
                        },
                        */
                        data: data
                    },
                    nameMap: {
                        '甘南藏族自治州': '甘南',
                        '临夏回族自治州': '临夏',
                        '酒泉市': '酒泉',
                        '嘉峪关市': '嘉峪关',
                        '张掖市': '张掖',
                        '金昌市': '金昌',
                        '武威市': '武威',
                        '白银市': '白银',
                        '定西市': '定西',
                        '庆阳市': '庆阳',
                        '平凉市': '平凉',
                        '天水市': '天水',
                        '陇南市': '陇南',
                        '兰州市': '兰州'
                    },
                    geoCoord: {
                        "嘉峪关": [98.821105, 40.133891],
                        "酒泉": [97.39429, 40.547606],
                        "张掖": [100.447717, 38.952124],
                        "金昌": [102.186262, 38.548726],
                        "白银": [104.127177, 36.564279],
                        "兰州": [103.814423, 36.080415],
                        "定西": [104.623904, 35.601041],
                        "天水": [105.718543, 34.610752],
                        "平凉": [106.647606, 35.563467],
                        "庆阳": [107.64106, 35.72866],
                        "陇南": [104.918261, 33.431177],
                        "甘南": [102.912955, 35.005297],
                        "武威": [102.632794, 37.973436],
                        "临夏": [103.244107, 35.623577]
                    }
                }
            ]
        }
    );
}

var convertData = function (data) {
    var res = [];
    for (var i = 0; i < data.length; i++) {
        var geoCoord = geoCoordMap[data[i].name];
        if (geoCoord) {
            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value)
            });
        }
    }
    return res;
};