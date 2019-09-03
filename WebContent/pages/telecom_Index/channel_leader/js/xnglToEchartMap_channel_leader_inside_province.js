/**
 * Created by admin on 2017/3/31.
 */
/*
 区域块染色
 params echart的option参数
 url4echartmap chartClickAction方法使用 下钻后数据从这里查询
 url4mapToWhere chartClickAction方法使用 下钻后加载的地图，省到市是viewPlane_city(echarts)，市到区县是viewPlane_area(gis)
 */
var chart_map = "";
var series_name_array = ["合计",
    "直营厅",
    "外包厅",
    "专营店",
    "连锁店",
    "独立店",
    "便利店"
];
//地市 区域块
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
    /*if(params.flag ==2 && params.city_name != params.parent_name){//flag是2，查询的却不是省名称，则返回
        return;
    }*/
    /*if(global_backToEcharts){
     global_backToEcharts = false;
     if(city_name_speical.indexOf(fullCityName)>-1)
     fullCityName += '州';
     else
     fullCityName += '市';
     }*/

    var series_name = "累计到达渗透率";
    //表格数据

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    var color = ['#f04144', '#f67d7f', '#fcb666','#ff9c2b','#8ae9b0','#42c877'];//从小到大
    //var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    var datas = new Array();
    var datas2 = new Array();

    var min = 0;
    var max = 0;

    $.ajax({
        type:"POST",
        url:url4realTimeSubList,
        data:params,
        success:function(data){
            var data_temp = $.parseJSON(data);
            var d = data_temp.rows;
            if(d.length==0)
                layer.msg('暂无数据');
            else {
                //地图数据展示用
                var vals = new Array();

                for (var i = 0; i < d.length; i++) {
                    var obj = {};

                    var org_name = d[i].AREA_DESC;
                    if(d[i].AREA_NO=='999')
                        continue;
                    obj.name = org_name;

                    var stl = d[i].USE_RATE;
                    if(stl=="--")
                        stl = "0";
                    obj.value = parseFloat(stl.replace("%",''));

                    vals.push(obj.value);

                    datas.push(obj);
                    datas2[org_name] = [d[i].USE_RATE,d[i].GZ_ZHU_HU_COUNT,d[i].GZ_H_USE_CNT,d[i].GOV_H_USE_CNT,d[i].GOV_ZHU_HU_COUNT];
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
            echartMapReset(min,max,params,series_name,color,datas,datas2);
            chart_map.hideLoading();
        }
    });
}
//地市 区域块
function echartMapReset(min_num,max_num,params,series_name,color,data,data2){
    var city_name = params.city_name;
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
            trigger: 'item',
            backgroundColor: 'rgba(0,0,0,0.7)',
            padding: 0,
            formatter: function(params) {
                city_name = params.name;
                var res = "<div class='tips_table_wrapper'><table><tr><td colspan='2'>"+params.name+"</td></tr>";
                for (var i = 0; i < option.series[0].data.length; i++) {
                    if(params.name==option.series[0].data[i].name){
                        res+="<tr><td>"+series_name_array[0] +":</td><td>"+data2[params.name][0]+"</td></tr>";
                        res+="<tr><td>"+series_name_array[1] +":</td><td>"+data2[params.name][1]+"</td></tr>";
                        res+="<tr><td>"+series_name_array[2] +":</td><td>"+data2[params.name][2]+"</td></tr>";
                        res+="<tr><td>"+series_name_array[3] +":</td><td>"+data2[params.name][3]+"</td></tr>";
                        res+="<tr><td>"+series_name_array[4] +":</td><td>"+data2[params.name][4]+"</td></tr>";
                        res+="<tr><td>"+series_name_array[5] +":</td><td>"+data2[params.name][5]+"</td></tr>";
                        res+="<tr><td>"+series_name_array[6] +":</td><td>"+data2[params.name][6]+"</td></tr>";
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
                name: series_name_array[0],
                type: 'map',
                //stack:series_name_array[0],
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
                /*nameMap: {
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
                },*/
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
                {min: 60,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                {min: 50, max: 60,color:'#8ae9b0'},
                {min: 40, max: 50,color:'#ff9c2b'},
                {min: 30, max: 40,color:'#fcb666'},
                {min: 20, max: 30,color:'#f67d7f'},
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

    chartClickActionToGis(params.url4mapInsideWhere);
}

//某个地市下 支局点图
//市级地图 有效代码
function setDataToEchartMap_bar_sub(params,url4realTimeSubList,url4mapToWhere,sql_url,sql_url1){
    //chart.showLoading();
    //wait();

    var fullCityName = params.city_full_name;

    /*if(global_backToEcharts){
     global_backToEcharts = false;
     if(city_name_speical.indexOf(fullCityName)>-1)
     fullCityName += '州';
     else
     fullCityName += '市';
     }*/

    //表格数据

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    var color = ['#050483'];//从小到大
    //var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    //var datas = new Array();

    var datas1 = [];
    var datas2 = [];
    var datas3 = [];

    var data_map = new Array();
    var datatype_tip = new Array();
    var datatype_simple_temp = new Array();
    var datatype_simple = new Array();

    var min = 0;
    var max = 0;

    $.ajax({
        type:"POST",
        url:url4realTimeSubList,
        data:params,
        success:function(data){
            var data_temp = $.parseJSON(data);
            var d = data_temp.rows;
            if(d.length==0)
                layer.msg('暂无数据');
            else {
            	//地图数据展示用
                var vals = new Array();
                var arr = [60,50,40,30,20,0];

                for (var i = 0; i < d.length; i++) {
                    var obj = {};
                    var org_name = d[i].NAME;
                    obj.name = org_name;
                    if(org_name.indexOf('直营')>-1){
                        obj.value = 65;
                        datas1.push(obj);
                    }else if(org_name.indexOf('外包')>-1){
                        obj.value = 55;
                        datas2.push(obj);
                    }else if(org_name.indexOf('专营')>-1){
                        obj.value = 45;
                        datas1.push(obj);
                    }else if(org_name.indexOf('连锁')>-1){
                        obj.value = 35;
                        datas3.push(obj);
                    }else if(org_name.indexOf('独立')>-1){
                        obj.value = 25;
                        datas3.push(obj);
                    }else if(org_name.indexOf('便利')>-1){
                    	obj.value = 0;
                        datas3.push(obj);
                    }
                    //obj.value = arr[i];//d[i].VALUE;

                    vals.push(obj.value);
                    //datas.push(obj);
                    data_map[org_name] = [d[i].VALUE,d[i].AVG_SCORE,d[i].CHANNEL_SCORE_SUM,d[i].AVG_CHANNEL_SCORE];
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
            //门店类型统计查询
            $.post(sql_url,{},
            function(obj){
                var data = $.parseJSON(obj);
                if(data != '' && data != null ){
                    $.each(data, function (index, value) {
                        var org_name = value.ORG_NAME;
                        var arr = datatype_tip[org_name];
                        if(!arr){
                            arr = new Array();
                        }
                        arr.push([value.CHANNEL_TYPE_NAME_QD,value.TOTALNUM,value.AVG_SCORE,value.CHANNEL_SCORE_SUM,value.AVG_CHANNEL_SCORE]);

                        datatype_tip[org_name]=arr;

                        /*var val = datatype_simple_temp[org_name];
                        if(!val){
                            datatype_simple_temp[org_name] = 1;
                        }*/
                    });
                    /*var simple_keys = Object.keys(datatype_simple_temp);
                    for(var i = 0,l = simple_keys.length;i<l;i++){
                        var key = simple_keys[i];
                        datatype_simple.push({"name":key,"value":1});
                    }*/

                    $.post(sql_url1,{},function(data){
                        var data1 = $.parseJSON(data);
                        $.each(data1.rows,function(index1,value1){
                            var val = datatype_simple[value1.BUREAU_NAME];//20190409 隐藏点
                            if(!val){
                                datatype_simple.push({"name":value1.BUREAU_NAME,"value":value1.QDXN_CUR_MONTH_SCORE_NUM});
                            }
                        });

                        echartMapReset_bar_sub(min,max,params,color,datas1,datas2,datas3,data_map,datatype_tip,datatype_simple);
                        chart_map.hideLoading();
                    });
                }
            });
        }
    });
}

//某个地市下 支局点图
function echartMapReset_bar_sub(min_num,max_num,params,color,datas1,datas2,datas3,data_map,datatype_tip,datatype_simple){
    var city_name = params.city_name;
    /*if(city_name.indexOf("省")>-1)
        city_name = city_name.replace(/省/gi,'');*/
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
        color = ['#050483'];

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
    chart_map.setOption(
        {
            tooltip: {
                trigger: 'item',
                backgroundColor: 'rgba(0,0,0,0.7)',
                padding: 0,
                formatter:function(params){
                    var res = "";
                    if(params.seriesType=='scatter'){
                        res = "<div class='tips_table_wrapper'><table><tr><td colspan='2'>"+params.name+"</td></tr>";
                        res+="<tr><td>总&nbsp;&nbsp;&nbsp;&nbsp;数:</td><td>"+data_map[params.name][0]+"</td></tr>";
                        res+="<tr><td>效能均值:</td><td>"+data_map[params.name][1]+"</td></tr>";
                        res+="<tr><td>渠道积分:</td><td>"+data_map[params.name][2]+"</td></tr>";
                        res+="<tr><td>店均积分:</td><td>"+data_map[params.name][3]+"</td></tr>";
                        res += "</table></div>";
                    }else{
                        var index_arr = datatype_tip[params.name];
                        if(index_arr){
                            res = "<div class='tips_table_wrapper1'><table><tr><td colspan='5'>"+params.name+"</td></tr>";
                            res += "<tr><td>门店类型</td><td>厅店数</td><td>渠道效能</td><td>渠道积分</td><td>店均积分</td></tr>";
                            $.each(index_arr,function(i,n){
                                res += "<tr><td>"+ n[0] +"</td>" +
                                "<td>"+ n[1] +"</td>" +
                                "<td>"+ n[2] +"</td>" +
                                "<td>"+ n[3] +"</td>" +
                                "<td>"+ n[4] +"</td></tr>";
                            });
                            res += "</table></div>";
                        }
                    }

                    return res;
                }
            },
            geo: {
                show: false,
                map: city_name,
                layoutCenter: ['50%', '50%'],
                layoutSize: '120%',
                roam: true,
                selectedMode: false,
                label: {
                    normal: {
                        show: true,
                        position: 'center',
                        textStyle: {
                            color: '#fff',
                            fontFamily:'微软雅黑',
                            fontSize:10
                        }

                    },
                    emphasis:{
                        show:true
                    }
                },
                itemStyle: {
                    normal:{
                        borderColor: '#fff',
                        borderWidth:1,
                        color:'#067bff'
                    },
                    /*color: ['#0101c2', '#067bff', '#0101c2']*/
                    emphasis:{
                        areaColor: '#0101c2',
                        shadowOffsetX: 0,
                        shadowOffsetY: 0,
                        shadowBlur: 20,
                        borderWidth: 0,
                        shadowColor: 'rgba(255, 255, 255, 0.6)'
                    }
                }
            },
            series: [
                {
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    geoIndex:0,
                    data: convertData_channel(params.region_id,datas1,[60,50,40,30,20,0]),
                    symbolSize: [0,0],//[16,16], //20190409 隐藏点
                    label: {
                        normal: {
                            formatter: function(params){
                                return params.name;
                            },
                            position: 'right',
                            show: false,
                            width:8,
                            height:15
                        },
                        emphasis: {
                            show: false
                        }
                    }
                },
                {
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    geoIndex:0,
                    data: convertData_channel(params.region_id,datas2,[60,50,40,30,20,0]),
                    symbolSize: [0,0],//[13,13], //20190409 隐藏点
                    label: {
                        normal: {
                            formatter: function(params){
                                return params.name;
                            },
                            position: 'right',
                            show: false,
                            width:8,
                            height:15
                        },
                        emphasis: {
                            show: false
                        }
                    }
                },
                {
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    geoIndex:0,
                    data: convertData_channel(params.region_id,datas3,[60,50,40,30,20,0]),
                    symbolSize: [0,0],//[10,10], //20190409 隐藏点
                    label: {
                        normal: {
                            formatter: function(params){
                                return params.name;
                            },
                            position: 'right',
                            show: false,
                            width:8,
                            height:15
                        },
                        emphasis: {
                            show: false
                        }
                    }
                },
                {
                    layoutCenter: ['50%', '50%'],
                    layoutSize: '120%',
                    name: series_name_array[0],
                    type: 'map',
                    //stack:series_name_array[0],
                    mapType: city_name,
                    selectedMode: true,
                    showLegendSymbol:true,
                    roam : true,
                    label: {
                        normal:{show:true},
                        emphasis:{show:true}
                    },
                    itemStyle: {
                        normal: {
                            borderColor: '#fff',
                            borderWidth: 1.5,
                            areaStyle: {
                                color: 'transparent'
                            },
                            label: {
                                show: false,
                                textStyle: {
                                    color: '#fff',
                                    fontSize: 14,
                                    fontFamliy: '微软雅黑',
                                    fontWeight: 500
                                }
                            },
                            opacity:1 //20190409 隐藏点
                        },
                        emphasis:{
                            show:false,
                            color:'transparent'
                        }
                    },
                    /*nameMap: {//20190409 隐藏点
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
                     },*/
                    data:datatype_simple
                }
            ],
            visualMap:{
                type:"piecewise",
                splitNumber:4,
                bottom:20,
                left:135,
                show:false,//20190409 隐藏点
                //selectedMode:'single',
                //dimension:0,
                seriesIndex:3,//[0,1,2],//20190409 隐藏点
                pieces: [
                    /*{min: 60,color:'#be111e'}, // 不指定 max，表示 max 为无限大（Infinity）。
                    {min: 50, max: 60,color:'#ff4800'},
                    {min: 40, max: 50,color:'#f9970b'},
                    {min: 30, max: 40,color:'#e1da17'},
                    {min: 20, max: 30,color:'#f600ff'},
                    {min: 0,max:20,color:'#44d661'}     // 不指定 min，表示 min 为无限大（-Infinity）。*/
                    {min: 80, color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                    {min: 30, max: 80,color:'#8ae9b0'},
                    {min: 10, max: 30,color:'#ff9c2b'},
                    {max: 10, color:'#fcb666'}     // 不指定 min，表示 min 为无限大（-Infinity）。
                ],
                textStyle:{
                    color:"#fff"
                }
            }
        },true
    );
    chartClickActionToGis(params.url4mapInsideWhere);
}


//某个地市下 网格点图
function setDataToEchartMap_bar_grid(params,url4realTimeSubList,url4mapToWhere){
    //chart.showLoading();
    //wait();

    var fullCityName = params.city_full_name;

    /*if(global_backToEcharts){
     global_backToEcharts = false;
     if(city_name_speical.indexOf(fullCityName)>-1)
     fullCityName += '州';
     else
     fullCityName += '市';
     }*/

    var series_name = "累计到达渗透率";
    //表格数据

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    var color = ['#050483'];//从小到大
    //var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    var datas = new Array();
    var data_map = new Array();

    var min = 0;
    var max = 0;

    $.ajax({
        type:"POST",
        url:url4realTimeSubList,
        data:params,
        success:function(data){
            var data_temp = $.parseJSON(data);
            var d = data_temp.rows;
            if(d.length==0)
                layer.msg('暂无数据');
            else {
                //地图数据展示用
                var vals = new Array();

                for (var i = 0; i < d.length; i++) {
                    var obj = {};
                    var sub_id = d[i].GRID_UNION_ORG_CODE;
                    obj.id = sub_id;
                    var org_name = d[i].AREA_DESC;
                    obj.name = org_name;
                    var stl = d[i].USE_RATE;
                    if(stl=="--")
                        stl = "0";
                    obj.value = parseFloat(stl.replace("%",''));

                    vals.push(obj.value);
                    datas.push(obj);
                    data_map[org_name] = [d[i].USE_RATE,d[i].GZ_ZHU_HU_COUNT,d[i].GZ_H_USE_CNT,d[i].GOV_H_USE_CNT,d[i].GOV_ZHU_HU_COUNT];
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
        	echartMapReset_bar_grid(min,max,params,color,datas,data_map);
            chart_map.hideLoading();
        }
    });
}

//某个地市下 网格点图
function echartMapReset_bar_grid(min_num,max_num,params,color,data,data_map){
    var city_name = params.city_name;
    /*if(city_name.indexOf("省")>-1)
        city_name = city_name.replace(/省/gi,'');*/
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
        color = ['#050483'];

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
    chart_map.setOption(
        {
            tooltip: {
                trigger: 'item',
                backgroundColor: 'rgba(0,0,0,0.7)',
                padding: 0,
                formatter:function(params){
                    var res = "<table id=\"map_tip_win\"><tr><td colspan='2'>"+params.name+"</td></tr>";
                    res+="<tr><td>"+series_name_array[0] +":</td><td>"+data_map[params.name][0]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[1] +":</td><td>"+data_map[params.name][1]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[2] +":</td><td>"+data_map[params.name][2]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[3] +":</td><td>"+data_map[params.name][3]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[4] +":</td><td>"+data_map[params.name][4]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[5] +":</td><td>"+data_map[params.name][5]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[6] +":</td><td>"+data_map[params.name][6]+"</td></tr>";
                    res += "</table>";
                    return res;
                }
            },
            geo: {
                map: city_name,
                layoutCenter: ['52%', '50%'],
                layoutSize: '120%',
                roam: true,
                selectedMode: false,
                label: {
                    normal: {
                        show: true,
                        position: 'center',
                        textStyle: {
                            color: '#fff',
                            fontFamily:'微软雅黑',
                            fontSize:10
                        }

                    },
                    emphasis:{
                        show:true
                    }
                },
                itemStyle: {
                    normal:{
                        borderColor: '#fff',
                        borderWidth:1,
                        color:'#067bff'
                    },
                    /*color: ['#0101c2', '#067bff', '#0101c2']*/
                    emphasis:{
                        areaColor: '#0101c2',
                        shadowOffsetX: 0,
                        shadowOffsetY: 0,
                        shadowBlur: 20,
                        borderWidth: 0,
                        shadowColor: 'rgba(255, 255, 255, 0.6)'
                    }
                }
            },
            series: [
                {
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    geoIndex:0,
                    data: convertData_grid(data),
                    symbolSize: [8,8],
                    label: {
                        normal: {
                            formatter: function(params){
                                return params.name;
                            },
                            position: 'right',
                            show: false,
                            width:8,
                            height:15
                        },
                        emphasis: {
                            //show: false
                        }
                    }
                }
            ],
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
                    {min: 60,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                    {min: 50, max: 60,color:'#8ae9b0'},
                    {min: 40, max: 50,color:'#ff9c2b'},
                    {min: 30, max: 40,color:'#fcb666'},
                    {min: 20, max: 30,color:'#f67d7f'},
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
        },true
    );
    chartClickActionToGis(params.url4mapInsideWhere);
}

//某个地市下 小区点图
function setDataToEchartMap_bar_village(params,url4realTimeSubList,url4mapToWhere){
    //chart.showLoading();
    //wait();

    var fullCityName = params.city_full_name;

    /*if(global_backToEcharts){
     global_backToEcharts = false;
     if(city_name_speical.indexOf(fullCityName)>-1)
     fullCityName += '州';
     else
     fullCityName += '市';
     }*/

    var series_name = "累计到达渗透率";
    //表格数据

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    var color = ['#050483'];//从小到大
    //var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    var datas = new Array();
    var data_map = new Array();

    var min = 0;
    var max = 0;

    $.ajax({
        type:"POST",
        url:url4realTimeSubList,
        data:params,
        success:function(data){
            var data_temp = $.parseJSON(data);
            var d = data_temp.rows;
            if(d.length==0)
                layer.msg('暂无数据');
            else {
                //地图数据展示用
                var vals = new Array();

                for (var i = 0; i < d.length; i++) {
                    var obj = {};
                    var sub_id = d[i].LATN_ID;
                    obj.id = sub_id;
                    var org_name = d[i].AREA_DESC;
                    obj.name = org_name;
                    var stl = d[i].USE_RATE;
                    if(stl=="--")
                        stl = "0";
                    obj.value = parseFloat(stl.replace("%",''));

                    vals.push(obj.value);
                    datas.push(obj);
                    data_map[org_name] = [d[i].USE_RATE,d[i].GZ_ZHU_HU_COUNT,d[i].GZ_H_USE_CNT,d[i].GOV_H_USE_CNT,d[i].GOV_ZHU_HU_COUNT];
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
        	echartMapReset_bar_village(min,max,params,color,datas,data_map);
            chart_map.hideLoading();
        }
    });
}

//某个地市下 小区点图
function echartMapReset_bar_village(min_num,max_num,params,color,data,data_map){
    var city_name = params.city_name;
    /*if(city_name.indexOf("省")>-1)
        city_name = city_name.replace(/省/gi,'');*/
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
        color = ['#050483'];

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
    chart_map.setOption(
        {
            tooltip: {
                trigger: 'item',
                backgroundColor: 'rgba(0,0,0,0.7)',
                padding: 0,
                formatter:function(params){
                    var res = "<table id=\"map_tip_win\"><tr><td colspan='2'>"+params.name+"</td></tr>";
                    res+="<tr><td>"+series_name_array[0] +":</td><td>"+data_map[params.name][0]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[1] +":</td><td>"+data_map[params.name][1]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[2] +":</td><td>"+data_map[params.name][2]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[3] +":</td><td>"+data_map[params.name][3]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[4] +":</td><td>"+data_map[params.name][4]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[5] +":</td><td>"+data_map[params.name][5]+"</td></tr>";
                    res+="<tr><td>"+series_name_array[6] +":</td><td>"+data_map[params.name][6]+"</td></tr>";
                    res += "</table>";
                    return res;
                }
            },
            geo: {
                map: city_name,
                layoutCenter: ['52%', '50%'],
                layoutSize: '120%',
                roam: true,
                selectedMode: false,
                label: {
                    normal: {
                        show: true,
                        position: 'center',
                        textStyle: {
                            color: '#fff',
                            fontFamily:'微软雅黑',
                            fontSize:10
                        }

                    },
                    emphasis:{
                        show:true
                    }
                },
                itemStyle: {
                    normal:{
                        borderColor: '#fff',
                        borderWidth:1,
                        color:'#067bff'
                    },
                    /*color: ['#0101c2', '#067bff', '#0101c2']*/
                    emphasis:{
                        areaColor: '#0101c2',
                        shadowOffsetX: 0,
                        shadowOffsetY: 0,
                        shadowBlur: 20,
                        borderWidth: 0,
                        shadowColor: 'rgba(255, 255, 255, 0.6)'
                    }
                }
            },
            series: [
                {
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    geoIndex:0,
                    data: convertData_village(data),
                    symbolSize: [8,8],
                    symbol:'circle',
                    label: {
                        normal: {
                            formatter: function(params){
                                return params.name;
                            },
                            position: 'right',
                            show: false,
                            width:8,
                            height:15
                        },
                        emphasis: {
                            //show: false
                        }
                    }
                }
            ],
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
                    {min: 60,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                    {min: 50, max: 60,color:'#8ae9b0'},
                    {min: 40, max: 50,color:'#ff9c2b'},
                    {min: 30, max: 40,color:'#fcb666'},
                    {min: 20, max: 30,color:'#f67d7f'},
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
        },true
    );
    chartClickActionToGis(params.url4mapInsideWhere);
}