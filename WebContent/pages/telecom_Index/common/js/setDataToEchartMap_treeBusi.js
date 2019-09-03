/**
 * Created by admin on 2017/3/31.
 */
/*
 三大业务，简化地图
 params echart的option参数
 url4echartmap chartClickAction方法使用 下钻后数据从这里查询
 url4mapToWhere chartClickAction方法使用 下钻后加载的地图，省到市是viewPlane_city(echarts)，市到区县是viewPlane_area(gis)
 */
var index_type = "mob";
function setDataToEchartMap(params,url4echartmap,url4mapToJson){
    //chart.showLoading();
    //wait();
    var fullCityName = params.city_full_name;
    index_type = params.index_type;
    parent.global_current_flag = params.flag;
    if(params.flag == 3){
        if(city_name_speical.indexOf(fullCityName)>-1)
            params.city_name = fullCityName.replace(/州/gi,'');
        else
            params.city_name = fullCityName.replace(/市/gi,'');
    }
    /*if(global_backToEcharts){
        global_backToEcharts = false;
        if(city_name_speical.indexOf(fullCityName)>-1)
            fullCityName += '州';
        else
            fullCityName += '市';
    }*/

    var series_name = "";
    //表格数据

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    var datas = new Array();

    var min = 0;
    var max = 0;

    $.ajax({
        type:"POST",
        url:url4echartmap,
        data:params,
        success:function(data){
            var d = $.parseJSON(data);
            if(d.length==0)
                layer.msg('暂无数据');
            else {
                var itemStyle = {};
                var emphasis = {color: "red"};
                itemStyle.emphasis = emphasis;
                //地图数据展示用
                var vals = new Array();

                for (var i = 0; i < d.length; i++) {
                    var obj = {};
                    var org_name = d[i].ORG_NAME;
                    if(params.flag==2)//市级的名称处理(数据库里市级名称和地图不对应)
                        if(city_name_speical.indexOf(org_name)>-1)
                            org_name += '州';
                        else
                            org_name += '市';
                    obj.name = org_name;
                    obj.value = d[i].CURRENT_MON_DEV;
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
            //done();
        },
        error:function(){
            layer.msg('查询出错');
            alert('查询出错');
        },
        complete:function(){
            echartMapReset(min,max,params,series_name,color,datas);
            chartClickAction(url4echartmap,url4mapToJson);
            chart.hideLoading();
        }
    });
}

function echartMapReset(min_num,max_num,params,series_name,color,data){
    var city_name = params.city_name;
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

    chart.setOption({
        tooltip: {
            trigger: 'item',
            formatter:"{b}:{c}"
        },
        /* visualMap: {
         min: min_num,
         max: max_num,
         left: 'left',
         top: 'bottom',
         text: [max_num,min_num],           // 文本，默认为数值文本
         textStyle:{
         color:"#fff"
         },
         calculable: true,
         color:color,
         bottom:'10%'
         }, */
        dataRange: {
            show:false,
            min: min_num,
            max: max_num,
            x: 'left',
            y: 'bottom',
            selectedMode: false,
            text: [max_num,min_num], // 文本，默认为数值文本
            calculable: true,
            color:color,
            textStyle:{
                color:"#fff"
            }
        },
        toolbox: {
            show: false,
            orient: 'vertical',
            left: 'right',
            top: 'bottom',
            feature: {
                dataView: {readOnly: false},
                restore: {},
                saveAsImage: {}
            }
        },
        series: [{
            layoutCenter: ['50%', '50%'],
            layoutSize: '120%',
            type: 'map',
            //map: city_name,
            mapType: city_name,
            name:series_name,
            roam:true,
            zoom:1,
            selectedMode:'single',
            label:{
                 normal:{
                    show:false
                 },
                 emphasis:{
                     show:false,
                     textStyle:{
                         color:'#000',
                         fontSize:12,
                         fontWeight:"bolder"
                     }
                 }
             },
            itemStyle:{
                normal : {
                    //borderWidth:0.5,
                    //borderColor:'#FFFFFF',
                    label : {
                        show : false
                    }
                },
                emphasis : {
                    label : {
                        show : true
                    }
                }
            },
            scaleLimit:{
                min:1,
                max:3
            },
            data:data
        }]
    },true);
}

function chartClickAction(url4echartmap,url4mapToJson){
    chart.on('click', function (params_evt){
        $("#back").remove();
        var cityFull = params_evt.name;//点击后获得的名字

        var jsonNo = cityMap[cityFull];

        //parent.global_current_full_area_name = cityFull;

        var params = {};
        //params.index_type = parent.default_show_index;
        params.index_type = index_type;

        if(jsonNo!=undefined){//从省级点，会获取到地市名称 echarts地图刷新
            params.city_full_name = cityFull;

            var city = "";
            if(city_name_speical.indexOf(cityFull)>-1)
                city = cityFull.replace(/州/gi,'');
            else
                city = cityFull.replace(/市/gi,'');

            //parent.global_current_area_name = city;

            //parent.global_current_city_id = city_ids[city];

            params.city_name = city;

            var jsonNo = cityMap[cityFull];

            $.get(url4mapToJson+jsonNo+'.json', function (cityJson) {
                echarts.registerMap(city, cityJson);
                //parent.global_current_flag = 3;
                params.flag = 3;
                //parent.global_parent_area_name = parent.province_name;
                //parent.global_current_full_area_name = cityFull;

                setDataToEchartMap(params,url4echartmap);
            });

        }else{//区县,返回全省
            //parent.global_current_area_name = parent.global_parent_area_name;
            params.city_name = parent.global_parent_area_name;
            params.city_full_name = parent.global_parent_area_name;
            //parent.global_current_flag = 2;
            params.flag = 2;//2
            setDataToEchartMap(params,url4echartmap);
        }
    });
}