//点击事件 地市下钻到区县的echarts地图
function chartClickAction(url4mapInsideWhere){
    chart_map.on('click', function (params_evt){
        if(params_evt.seriesType=='scatter')
            return;
        var cityFull = params_evt.name;//点击后获得的名字
        parent.global_current_full_area_name = cityFull;
        parent.global_current_flag = parseInt(flag)+1;

        //var jsonNo = cityMap[cityFull];

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

        //echarts地图刷新和gis都要重新加载地图和指标侧边，执行下面两句
        if(parent.global_region_type=="city")
            parent.global_region_type = "bureau";
        parent.freshMapContainer(url4mapInsideWhere);

        //if(zxs[cityFull] && parent.global_current_flag==3){//直辖市的特殊处理，到地市一层，点区县下钻时右侧不刷新

        //}else{
        //    parent.freshIndexContainer(url4devTabToWhere);
        //}
    });
}

function chartClickActionToGis(url4mapInsideWhere){
    chart_map.on('click', function (params_evt){
    	//debugger;
        if(params_evt.seriesType=='scatter')
            return;
        var cityFull = params_evt.name;//点击后获得的名字
        parent.global_current_full_area_name = cityFull;
        parent.global_current_flag = parseInt(flag)+1;

        //var jsonNo = cityMap[cityFull];

        var city = "";
        if(city_name_speical.indexOf(cityFull)>-1)
            city = cityFull.replace(/州/gi,'');
        else
            city = cityFull.replace(/市/gi,'');

        parent.global_current_city_id = city_ids[city];
        parent.global_current_area_name = city;//城关区

        parent.global_position.splice(2,1,cityFull);
        if(zxs[cityFull]!=undefined){
            parent.global_position.splice(2,1,cityFull);
        }

        //echarts地图刷新和gis都要重新加载地图和指标侧边，执行下面两句
        if(parent.global_region_type=="city" || parent.global_region_type=="bureau")
            parent.global_region_type = "sub";
        parent.freshMapContainer(url4mapInsideWhere);
        //if(zxs[cityFull] && parent.global_current_flag==3){//直辖市的特殊处理，到地市一层，点区县下钻时右侧不刷新

        //}else{
        //    parent.freshIndexContainer(url4devTabToWhere);
        //}
    });
}