/**
 * Created by admin on 2017/3/31.
 */
/*
 区域块染色
 params echart的option参数
 url4echartmap chartClickAction方法使用 下钻后数据从这里查询
 url4mapToWhere chartClickAction方法使用 下钻后加载的地图，省到市是viewPlane_city(echarts)，市到区县是viewPlane_area(gis)
 */

var series_name_array6 = ["保有率","续约率","活跃率"];
//地市 区域块
function setDataToEchartMap6(params,url4realTimeSubList,url4mapToWhere){
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
                    var org_name_temp = org_name.substr(org_name.indexOf("_")+1);
                    obj.name = org_name_temp;

                    var stl = d[i].USE_RATE;
                    if(stl=="--")
                        stl = "0";
                    obj.value = parseFloat(stl.replace("%",''));

                    vals.push(obj.value);

                    datas.push(obj);
                    datas2[org_name_temp] = [d[i].USE_RATE,d[i].XY_RATE,d[i].ACTIVE_RATE];
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
            echartMapReset6(min,max,params,series_name,color,datas,datas2);
            chart_map.hideLoading();
        }
    });
}
//地市 区域块
function echartMapReset6(min_num,max_num,params,series_name,color,data,data2){
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
                        res+="<tr><td>"+series_name_array6[0] +":</td><td>"+data2[params.name][0]+"</td></tr>";
                        res+="<tr><td>"+series_name_array6[1] +":</td><td>"+data2[params.name][1]+"</td></tr>";
                        res+="<tr><td>"+series_name_array6[2] +":</td><td>"+data2[params.name][2]+"</td></tr>";
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
                name: series_name_array6[0],
                type: 'map',
                //stack:series_name_array6[0],
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
                {min: 98,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                {min: 97, max: 98,color:'#8ae9b0'},
                {min: 96, max: 97,color:'#ff9c2b'},
                {min: 95, max: 96,color:'#fcb666'},
                {min: 94, max: 95,color:'#f67d7f'},
                {min: 0,max:94,color:'#f04144'}     // 不指定 min，表示 min 为无限大（-Infinity）。
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
function setDataToEchartMap_bar_sub6(params,url4realTimeSubList,url4mapToWhere){
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
                    data_map[org_name] = [d[i].USE_RATE,d[i].XY_RATE,d[i].ACTIVE_RATE];
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
            echartMapReset_bar_sub6(min,max,params,color,datas,data_map);
            chart_map.hideLoading();
        }
    });
}

//某个地市下 支局点图
function echartMapReset_bar_sub6(min_num,max_num,params,color,data,data_map){
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
                    var res = "<table id=\"tips_table_wrapper\"><tr><td colspan='2'>"+params.name+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[0] +":</td><td>"+data_map[params.name][0]+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[1] +":</td><td>"+data_map[params.name][1]+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[2] +":</td><td>"+data_map[params.name][2]+"</td></tr>";
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
                },
            },
            series: [
                {
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    geoIndex:0,
                    data: convertData_sub(data),
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
                    {min: 98,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                    {min: 97, max: 98,color:'#8ae9b0'},
                    {min: 96, max: 97,color:'#ff9c2b'},
                    {min: 95, max: 96,color:'#fcb666'},
                    {min: 94, max: 95,color:'#f67d7f'},
                    {min: 0,max:94,color:'#f04144'}     // 不指定 min，表示 min 为无限大（-Infinity）。
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


//某个地市下 网格点图
function setDataToEchartMap_bar_grid6(params,url4realTimeSubList,url4mapToWhere){
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
                    data_map[org_name] = [d[i].USE_RATE,d[i].XY_RATE,d[i].ACTIVE_RATE];
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
        	echartMapReset_bar_grid6(min,max,params,color,datas,data_map);
            chart_map.hideLoading();
        }
    });
}

//某个地市下 网格点图
function echartMapReset_bar_grid6(min_num,max_num,params,color,data,data_map){
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
                    var res = "<table id=\"tips_table_wrapper\"><tr><td colspan='2'>"+params.name+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[0] +":</td><td>"+data_map[params.name][0]+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[1] +":</td><td>"+data_map[params.name][1]+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[2] +":</td><td>"+data_map[params.name][2]+"</td></tr>";
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
                },
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
                    {min: 98,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                    {min: 97, max: 98,color:'#8ae9b0'},
                    {min: 96, max: 97,color:'#ff9c2b'},
                    {min: 95, max: 96,color:'#fcb666'},
                    {min: 94, max: 95,color:'#f67d7f'},
                    {min: 0,max:94,color:'#f04144'}     // 不指定 min，表示 min 为无限大（-Infinity）。
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
function setDataToEchartMap_bar_village6(params,url4realTimeSubList,url4mapToWhere){
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
                    data_map[org_name] = [d[i].USE_RATE,d[i].XY_RATE,d[i].ACTIVE_RATE];
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
        	echartMapReset_bar_village6(min,max,params,color,datas,data_map);
            chart_map.hideLoading();
        }
    });
}

//某个地市下 小区点图
function echartMapReset_bar_village6(min_num,max_num,params,color,data,data_map){
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
                    var res = "<table id=\"tips_table_wrapper\"><tr><td colspan='2'>"+params.name+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[0] +":</td><td>"+data_map[params.name][0]+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[1] +":</td><td>"+data_map[params.name][1]+"</td></tr>";
                    res+="<tr><td>"+series_name_array6[2] +":</td><td>"+data_map[params.name][2]+"</td></tr>";
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
                },
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
                    {min: 98,color:'#42c877'}, // 不指定 max，表示 max 为无限大（Infinity）。
                    {min: 97, max: 98,color:'#8ae9b0'},
                    {min: 96, max: 97,color:'#ff9c2b'},
                    {min: 95, max: 96,color:'#fcb666'},
                    {min: 94, max: 95,color:'#f67d7f'},
                    {min: 0,max:94,color:'#f04144'}     // 不指定 min，表示 min 为无限大（-Infinity）。
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