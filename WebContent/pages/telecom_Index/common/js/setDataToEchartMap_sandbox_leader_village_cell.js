/**
 * Created by admin on 2018/12/15.
 */
/*
 区域块染色
 params echart的option参数
 url4echartmap chartClickAction方法使用 下钻后数据从这里查询
 url4mapToWhere chartClickAction方法使用 下钻后加载的地图，省到市是viewPlane_city(echarts)，市到区县是viewPlane_area(gis)
 */
var series_name_array_village_cell = ["市场渗透率"];
//地市 区域块
function setDataToEchartMap_village_cell(params,url4realTimeSubList,url4mapToWhere){
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

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    var color = ['#f04144', '#f67d7f', '#fcb666','#ff9c2b','#8ae9b0','#42c877'];//从小到大
    //var color = ['#0101c2','#067bff'];
    //var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    var datas = new Array();
    var datas2 = new Array();

    var min = 100;
    var max = 100;

    var vals = new Array();

    var d = Object.keys(city_ids);

    for (var i = 0; i < d.length; i++) {
        var obj = {};

        var org_name = d[i];
        obj.name = org_name;

        var stl = 50;
        if(stl=="--")
            stl = "0";
        obj.value = stl;

        vals.push(obj.value);

        datas.push(obj);
        datas2[org_name] = [50];
    }

    /*if (vals.length > 0) {
        max = Math.ceil(Math.max.apply(null, vals));
        min = Math.floor(Math.min.apply(null, vals));
        if (min == max)
            min = 0;
    }*/
    echartMapReset_village_cell(min,max,params,color,datas,datas2);
    chart_map.hideLoading();
}
//地市 区域块
function echartMapReset_village_cell(min_num,max_num,params,color,data,data2){
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

    var isShowLabel = true;

    if(params.flag == 3) {
        isShowLabel = false;
    }
    if(chart_map!=""){
        chart_map.dispose();
        chart_map = "";
    }

    chart_map = echarts.init(document.getElementById('pagemap'),"dark");

    var option = {
        tooltip: {
            show:false,
            trigger: 'item',
            backgroundColor: 'rgba(0,0,0,0.7)',
            padding: 0,
            formatter: function(params) {
                city_name = params.name;
                var res = "<div class='tips_table_wrapper'><table><tr><td colspan='2'>"+params.name+"</td></tr>";
                for (var i = 0; i < option.series[0].data.length; i++) {
                    if(params.name==option.series[0].data[i].name){
                        res+="<tr><td>"+series_name_array_village_cell[0] +":</td><td>"+data2[params.name][0]+"</td></tr>";
                        res+="<tr><td>"+series_name_array_village_cell[1] +":</td><td>"+data2[params.name][1]+"</td></tr>";
                        res+="<tr><td>"+series_name_array_village_cell[2] +":</td><td>"+data2[params.name][2]+"</td></tr>";
                        res+="<tr><td>"+series_name_array_village_cell[3] +":</td><td>"+data2[params.name][3]+"</td></tr>";
                        res+="<tr><td>"+series_name_array_village_cell[4] +":</td><td>"+data2[params.name][4]+"</td></tr>";
                    }
                }
                res += "</table></div>";
                return res;
            }
        },
        series: [
            //series 0
            {
                layoutCenter: ['50%', '50%'],
                layoutSize: '120%',
                name: series_name_array_village_cell[0],
                type: 'map',
                //stack:series_name_array_village_cell[0],
                mapType: city_name,
                selectedMode: false,
                showLegendSymbol:true,
                roam : true,

                itemStyle: {
                    normal: {
                        borderColor: '#fff',
                        borderWidth: 1.5,
                        areaStyle: {
                            color: 'transparent'
                        },
                        label: {
                            show: isShowLabel,
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
                nameMap: {
                    '甘南州': '甘南',
                    '临夏州': '临夏',
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
                data:data
            }
        ],
        /*legend: {
            orient: 'vertical',
            left: 'left',
            data:['市场渗透率']
        },*/
        visualMap:{
            type:"piecewise",
            splitNumber:6,
            bottom:20,
            left:135,
            show:false,
            //selectedMode:'single',
            //dimension:0,
            seriesIndex:0,
            pieces: [
                {min: 40,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                {min: 35, max: 40,color:'#8ae9b0'},
                {min: 30, max: 35,color:'#ff9c2b'},
                {min: 25, max: 30,color:'#fcb666'},
                {min: 20, max: 25,color:'#f67d7f'},
                {min: 0,max:20,color:'#f04144'}     // 不指定 min，表示 min 为无限大（-Infinity）。
            ],
            textStyle:{
                color:"#fff"
            }/*,
            formatter:function(value,name){
                var myseries = option.series;
                var market_percent = myseries[0];
                var listdata = market_percent.data;
                for(var i= 0,l = listdata.length;i<l;i++){
                    ///'收集数'判断
                    if(listdata[i].name == city_name){
                        return listdata[i].value;
                    }
                }
            }*/
        }
    };
    chart_map.setOption(option,true);

    chartClickAction(params.url4mapInsideWhere);
}