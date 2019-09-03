/**
 * Created by admin on 2017/3/31.
 */
/*
 营销沙盘
 params echart的option参数
 url4echartmap chartClickAction方法使用 下钻后数据从这里查询
 url4mapToWhere chartClickAction方法使用 下钻后加载的地图，省到市是viewPlane_city(echarts)，市到区县是viewPlane_area(gis)
 */
//短名称优化
var name_short_array = {
    "甘肃省张家川回族自治县":"张家川回族自治县",//天水
    "甘肃省肃北蒙古族自治县":"肃北蒙古族自治县",//酒泉
    "甘肃省阿克塞哈萨克族自治县":"阿克塞哈萨克族自治县",//酒泉
    "甘肃省肃南裕固族自治县":"肃南裕固族自治县",//张掖
    "甘肃省天祝藏族自治县":"天祝藏族自治县",//武威,两个凉州区
    "甘肃省东乡族自治县":"东乡族自治县",//临夏
    "合作区":"合作市",//甘南
    "市辖区":"嘉峪关市"
};
var busi_type = "";
var datas1 = "";
var datas2 = "";
var datas3 = "";
var datas4 = "";

function setDataToEchartMap(params,url4echartmap,url4mapToWhere,url4devTabToWhere){
    if(isIE()){
        var pageMapHeight = parent.document.body.clientHeight*0.975;
        $("#pagemap").height(pageMapHeight);
    }
    chart = echarts.init(document.getElementById('pagemap'),"dark");

    chartClickAction(url4echartmap,url4mapToWhere,url4devTabToWhere)
    //chart.showLoading();
    //wait();
    var fullCityName = params.city_full_name;
    if(params.flag == 2){
        if(city_name_speical.indexOf(fullCityName)>-1)
            params.city_name = fullCityName.replace(/州/gi,'');
        else
            params.city_name = fullCityName.replace(/市/gi,'');
    }
    if(params.flag ==1 && params.city_name != parent.province_name){//flag是2，查询的却不是省名称，则返回
        return;
    }
    /*if(global_backToEcharts){
        global_backToEcharts = false;
        if(city_name_speical.indexOf(fullCityName)>-1)
            fullCityName += '州';
        else
            fullCityName += '市';
    }*/

    var series_name = params.series_name;
    //表格数据

    //var color = ['#4aad01','#f4d003','#f4430c','#b80303'];
    //var color = ['#0096ff','#b0e0ff'];
    var color = ['#0101c2','#067bff'];
    //var color = ['#4575b4','#74add1','#abd9e9','#81ee51'];
    //地图数据展示用,最大值最小值
    datas1 = new Array();
    datas2 = new Array();
    datas3 = new Array();
    datas4 = new Array();

    var min = 0;
    var max = 100;

    $.ajax({
        type:"POST",
        url:url4echartmap,
        data:params,
        success:function(data){
            var d = $.parseJSON(data);
            console.log()
            if(d.length==0){
                layer.msg('暂无数据');
                    var city_names = Object.keys(cityMap);
                    for(var i = 0,l = city_names.length;i<l;i++) {
                        var obj = {};
                        obj.name = city_names[i];
                        obj.value = 0;
                        datas1.push(obj);
                        datas2.push(obj);
                        datas3.push(obj);
                        datas4.push(obj);
                    }
            }else{


                var vals = new Array();
                    busi_type = params.busi_type;
                    min = d[1].VILLAGE_COUNT;
                    max = d[d.length-1].VILLAGE_COUNT;
                    for (var i = 0; i < d.length; i++) {
                        var obj = {};
                        var obj2 = {};
                        var obj3 = {};
                        var obj4 = {};
                        var org_name = d[i].LATN_NAME;
                        if (org_name == "全省"){
                            continue;
                        }
                        if(params.flag==1)//市级的名称处理(数据库里市级名称和地图不对应)
                                    if(city_name_speical.indexOf(org_name)>-1)
                                        org_name += '州';
                                    else
                                        org_name += '市';

                                var org_name_temp = name_short_array[org_name];
                                if(org_name_temp == undefined)
                                    org_name_temp = org_name;
                                obj.name = org_name_temp;
                                obj2.name = org_name_temp;
                                obj3.name = org_name_temp;


                                obj.value = d[i].VILLAGE_COUNT;
                                obj2.value = d[i].PORT_RATE;
                                obj2.visualMap = false;
                                obj3.value = d[i].USE_RATE;
                                obj3.visualMap = false;

                                vals.push(obj4.value);
                                datas1.push(obj);
                                datas2.push(obj2);
                                datas3.push(obj3);


                    }
                }

            // d = d.rows;
            // if(d.length==0){
            //     layer.msg('暂无数据');
            //     var city_names = Object.keys(cityMap);
            //     for(var i = 0,l = city_names.length;i<l;i++){
            //         var obj = {};
            //         obj.name = city_names[i];
            //         obj.value = 0;
            //         datas1.push(obj);
            //         datas2.push(obj);
            //         datas3.push(obj);
            //         datas4.push(obj);
            //     }
            // } else {
            //     var vals = new Array();
            //     busi_type = params.busi_type;
            //     console.log(busi_type)
            //     for (var i = 0; i < d.length; i++) {
            //         var obj = {};
            //         var obj2 = {};
            //         var obj3 = {};
            //         var obj4 = {};
            //         var org_name = d[i].LATN_NAME;
            //         if(org_name=="全省")
            //             continue;
            //         if(params.flag==1)//市级的名称处理(数据库里市级名称和地图不对应)
            //             if(city_name_speical.indexOf(org_name)>-1)
            //                 org_name += '州';
            //             else
            //                 org_name += '市';
            //
            //         var org_name_temp = name_short_array[org_name];
            //         if(org_name_temp == undefined)
            //             org_name_temp = org_name;
            //         obj.name = org_name_temp;
            //         obj2.name = org_name_temp;
            //         obj3.name = org_name_temp;
            //         obj4.name = org_name_temp;
            //         var cm = 0;
            //         try{
            //             cm = (parseInt(d[i].DQ_1_COUNT)+parseInt(d[i].DQ_2_COUNT));
            //         }catch(e){
            //             cm = 0;
            //         }
            //
            //         obj.value = d[i].ZHU_HU_COUNT;
            //         obj2.value = d[i].COLLECT_NUM;
            //         obj2.visualMap = false;
            //         obj3.value = $.trim(d[i].COLLECT_V.replace("%",""));
            //         obj3.visualMap = false;
            //         obj4.value = cm;
            //         obj4.visualMap = false;
            //         vals.push(obj4.value);
            //         datas1.push(obj);
            //         datas2.push(obj2);
            //         datas3.push(obj3);
            //         datas4.push(obj4);
            //     }
            //
            //     if (vals.length > 0) {
            //         max = Math.ceil(Math.max.apply(null, vals));
            //         min = Math.floor(Math.min.apply(null, vals));
            //         if (min == max)
            //             min = 0;
            //     }
            // }
        },
        error:function(){
            layer.msg('查询出错');
            alert('查询出错');
        },
        complete:function(){
            echartMapReset(min,max,params,series_name,color,datas1,datas2,datas3);
            //chartClickAction(url4echartmap,url4mapToWhere,url4devTabToWhere);
            chart.hideLoading();
        }
    });
}

function echartMapReset(min_num,max_num,params,series_name,color,data1,data2,data3){
    var city_name = params.city_name;
    if(city_name.indexOf("省")>-1)
        city_name = city_name.replace(/省/gi,'');

    /*try{
        min_num = parseInt(min_num);
    }catch(e){
        min_num = 0;
    }*/
    /*try{
        max_num = parseInt(max_num);
    }catch(e){
        max_num = 0;
    }*/

    if(max_num==0)
        color = ['#A8A8A8'];

    /*var forma_str = "<p style=\"align: left;text-align:left;\">{b}<br/>{a}:{c}</p>";
    if(params.busi_type=='market')
        forma_str += "%";*/
    var city_name;
    var option = {
        lengend: {
            right:'10',
            bottom:'10'
        },
        tooltip: {
            trigger: 'item',
            formatter: function(params) {
                city_name = params.name;
                var res = "<table id=\"map_tip_win\"><tr><td colspan='2'>"+params.name+"</td></tr>";
                //var myseries = ["住户数","收集住户数","收集占比","到期住户"];
                var myseries = option.series;
                for (var i = 0; i < myseries.length; i++) {
                    for(var j=0;j<myseries[i].data.length;j++){
                        if(myseries[i].data[j].name==params.name){
                            if(myseries[i].name=='小区数'){
                                res+="<tr><td>"+myseries[i].name +":</td><td>"+myseries[i].data[j].value+"</td></tr>";
                            }else if(myseries[i].name=='市场占有率' || myseries[i].name=='端口占用率'){
                                res+="<tr><td>"+myseries[i].name +":</td><td>"+myseries[i].data[j].value+"%</td></tr>";
                            }
                        }
                    }
                }
                res += "</table>";
                return res;
            }
        },
        visualMap: {
            min: min_num,
            max: max_num,
            left: 'right',
            top: 'bottom',
            text: [min_num,max_num],           // 文本，默认为数值文本
            textStyle:{
                color:"#fff"
            },
            calculable: true,
            color:color,
            formatter:function(value,name){
                var myseries = option.series;
                var sjs = myseries[0];
                var listdata = sjs.data;
                for(var i= 0,l = listdata.length;i<l;i++){
                    if(listdata[i].name == city_name){
                        return listdata[i].value;
                    }

                }
            }
            //bottom:'10%'
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
        geo: {
            map: city_name,
            layoutCenter: ['52%', '50%'],
            layoutSize: '120%',
            //nameMap:nameMap,
            //zoom:zoom,
            //center:center,
            roam: true,
            selectedMode: false,
            /*regions:[
             selected_city
             ],*/
            label: {
                normal: {
                    show: false,
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
                    borderWidth:1.3,
                    color:'transparent'
                },
                emphasis:{
                    areaColor: null,
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
                layoutCenter: ['52%', '50%'],
                layoutSize: '120%',
                type: 'map',
                //map: city_name,
                mapType: city_name,
                name:'小区数',
                roam:true,
                label: {
                    normal: {
                        show: true
                    },
                    emphasis: {
                        show: true
                    }
                },
                zoom:1,
                selectedMode:'single',
                nameMap:name_short_array,
                itemStyle:{
                    normal : {
                        borderWidth:1.5,
                        borderColor:'#FFFFFF',
                        label : {
                            show : true,
                            textStyle:{
                                color:"#fff"
                            }
                        }
                    },
                    emphasis : {
                        label : {
                            show : true,
                            textStyle:{
                                color:"#fff"
                            }
                        },
                        areaColor:'#FFD200'
                    }
                },
                scaleLimit:{
                    min:1,
                    max:3
                },
                data:data1
            },
            {
                layoutCenter: ['52%', '50%'],
                layoutSize: '120%',
                type: 'map',
                //map: city_name,
                mapType: city_name,
                name:'市场占有率',
                roam:true,
                label: {
                    normal: {
                        show: true
                    },
                    emphasis: {
                        show: true
                    }
                },
                zoom:1,
                selectedMode:'single',
                nameMap:name_short_array,
                itemStyle:{
                    normal : {
                        borderWidth:1.5,
                        borderColor:'#FFFFFF',
                        label : {
                            show : true,
                            textStyle:{
                                color:"#fff"
                            }
                        }
                    },
                    emphasis : {
                        label : {
                            show : true,
                            textStyle:{
                                color:"#fff"
                            }
                        },
                        areaColor:'#FFD200'
                    }
                },
                scaleLimit:{
                    min:1,
                    max:3
                },
                data:data3
            },
            {
                //layoutCenter: ['52%', '50%'],
                //layoutSize: '120%',
                type: 'map',
                //map: city_name,
                mapType: city_name,
                name:'端口占用率',
                roam:true,
                label: {
                    normal: {
                        show: true
                    },
                    emphasis: {
                        show: true
                    }
                },
                zoom:1,
                selectedMode:'single',
                nameMap:name_short_array,
                itemStyle:{
                    normal : {
                        borderWidth:1.5,
                        borderColor:'#FFFFFF',
                        label : {
                            show : true,
                            textStyle:{
                                color:"#fff"
                            }
                        }
                    },
                    emphasis : {
                        label : {
                            show : true,
                            textStyle:{
                                color:"#fff"
                            }
                        },
                        areaColor:'#FFD200'
                    }
                },
                scaleLimit:{
                    min:1,
                    max:3
                },
                data:data2
            },
            {
                type: 'scatter',
                coordinateSystem: 'geo',
                geoIndex:0,
                data: convertData(data2),
                symbol:'image://../common/images/channel_ico_new/channel_point5.png',
                /*symbol:'pin',
                 itemStyle:{
                 normal:{color:'#f00',borderWidth:1},
                 emphasis:{color:'#f00'}
                 },*/
                symbolSize: 18,
                label: {
                    normal: {
                        formatter: function(params){
                            return params.name;
                        },
                        position: 'right',
                        show: false
                    },
                    emphasis: {
                        show: false
                    }
                }
            }
            // {
            //     //layoutCenter: ['52%', '50%'],
            //     //layoutSize: '120%',
            //     type: 'map',
            //     //map: city_name,
            //     mapType: city_name,
            //     name:'到期住户',
            //     roam:true,
            //     label: {
            //         normal: {
            //             show: true
            //         },
            //         emphasis: {
            //             show: true
            //         }
            //     },
            //     zoom:1,
            //     selectedMode:'single',
            //     nameMap:name_short_array,
            //     itemStyle:{
            //         normal : {
            //             borderWidth:1.5,
            //             borderColor:'#FFFFFF',
            //             label : {
            //                 show : true,
            //                 textStyle:{
            //                     color:"#fff"
            //                 }
            //             }
            //         },
            //         emphasis : {
            //             label : {
            //                 show : true,
            //                 textStyle:{
            //                     color:"#fff"
            //                 }
            //             },
            //             areaColor:'#FFD200'
            //         }
            //     },
            //     scaleLimit:{
            //         min:1,
            //         max:3
            //     },
            //     data:data4
            // }
        ]
    };

    chart.setOption(option,true);
    //chartClickAction(silent);
}

function convertData(data) {
    var res = [];
    if(data==null || data==undefined)
        data = new Array();
    for (var i = 0; i < data.length; i++) {
        if(data[i].value>0){
            var geoCoord = geoCoordMap[data[i].name];
            if (geoCoord) {
                res.push({
                    name: data[i].name,
                    value: geoCoord.concat(data[i].value/100),
                    //symbol:"circle",
                    itemStyle:{
                        normal:{color:'rgb(128, 128, 128)'},
                        emphasis:{color:'rgb(128, 128, 128)'}
                    }
                });
            }
        }
    }
    return res;
}

function chartClickAction(url4echartmap,url4mapToWhere,url4devTabToWhere){
    chart.on('click', function (params_evt){
        $("#back").remove();
        var cityFull = params_evt.name;//点击后获得的名字

        parent.global_current_full_area_name = cityFull;
        parent.global_current_flag = parseInt(flag)+1;

        var jsonNo = cityMap[cityFull];

        var city = "";
        if(city_name_speical.indexOf(cityFull)>-1)
            city = cityFull.replace(/州/gi,'');
        else
            city = cityFull.replace(/市/gi,'');

        parent.global_current_city_id = city_ids[city];
        parent.global_current_area_name = city;//城关区

        parent.global_position.splice(1,1,cityFull);
        if(zxs[cityFull]!=undefined){
            parent.global_position.splice(2,1,cityFull);
        }
        /*if(jsonNo!=undefined && flag==1){//从省级点，会获取到地市名称 echarts地图刷新
            var params = {};
            params.city_full_name = cityFull;

            var city = "";
            if(city_name_speical.indexOf(cityFull)>-1)
                city = cityFull.replace(/州/gi,'');
            else
                city = cityFull.replace(/市/gi,'');

            parent.global_current_area_name = city;
            parent.global_current_city_id = city_ids[city];
        }else{//区县,下钻到gis
            parent.global_current_area_name = cityFull;//城关区
            parent.global_position.splice(2,1,cityFull);//进入区县
        }*/

        //echarts地图刷新和gis都要重新加载地图和指标侧边，执行下面两句
        parent.freshMapContainer(url4mapToWhere);
        if(zxs[cityFull] && parent.global_current_flag==3){//直辖市的特殊处理，到地市一层，点区县下钻时右侧不刷新

        }else{
            parent.freshIndexContainer(url4devTabToWhere);
        }
    });
}