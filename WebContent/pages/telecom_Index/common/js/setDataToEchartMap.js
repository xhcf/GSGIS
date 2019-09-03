/**
 * Created by admin on 2017/3/31.
 */
/*
 彩色板块地图
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
    var datas = new Array();

    var min = 0;
    var max = 0;

    $.ajax({
        type:"POST",
        url:url4echartmap,
        data:params,
        success:function(data){
            var d = $.parseJSON(data);
            if(d.length==0){
                layer.msg('暂无数据');
                var city_names = Object.keys(cityMap);
                for(var i = 0,l = city_names.length;i<l;i++){
                    var obj = {};
                    obj.name = city_names[i];
                    obj.value = 0;
                    datas.push(obj);
                }
            } else {
                var vals = new Array();
                busi_type = params.busi_type;
                for (var i = 0; i < d.length; i++) {
                    var obj = {};
                    var org_name = d[i].ORG_NAME;
                    if(params.flag==1)//市级的名称处理(数据库里市级名称和地图不对应)
                        if(city_name_speical.indexOf(org_name)>-1)
                            org_name += '州';
                        else
                            org_name += '市';

                    var org_name_temp = name_short_array[org_name];
                    if(org_name_temp == undefined)
                        org_name_temp = org_name;
                    obj.name = org_name_temp;
                    var cm = 0;
                    try{
                        cm = parseInt(d[i].CURRENT_MON_DEV);
                    }catch(e){
                        cm = 0;
                    }

                    obj.value = cm;
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
            alert('查询出错');
        },
        complete:function(){
            echartMapReset(min,max,params,series_name,color,datas);
            //chartClickAction(url4echartmap,url4mapToWhere,url4devTabToWhere);
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

    var forma_str = "<p style=\"align: left;text-align:left;\">{b}<br/>{a}:{c}</p>";
    if(params.busi_type=='market')
        forma_str += "%";
    chart.setOption({
        tooltip: {
            trigger: 'item',
            formatter:forma_str
        },
        /*visualMap: {
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
         },*/
        dataRange: {
            show:false,
            min: min_num,
            max: max_num,
            x: 'left',
            y: 'bottom',
            selectedMode: false,
            //text: [max_num,min_num], // 文本，默认为数值文本
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
            data:data
        }]
    },true);
    //chartClickAction(silent);
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