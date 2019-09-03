var convertData = function (data) {
    var res = [];
    for (var i = 0; i < data.length; i++) {
        var city_name_full = "";
        if(city_name_speical.indexOf(data[i].name)>-1)
            city_name_full = data[i].name+'州';
        else
            city_name_full = data[i].name+'市';
        var geoCoord = geoCoordMap[city_name_full];
        if (geoCoord) {
            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value)
            });
        }
    }
    return res;
};

var convertData_bureau = function (city_id,data,value_range) {
    var res = [];
    for (var i = 0; i < data.length; i++) {
        if(city_id==undefined)
            city_id = '999';
        var geoCoord = geoCoordMap_bureau[city_id][data[i].name];
        if (geoCoord) {

            var symbol = "";
            for(var j = 0,k = value_range.length;j<k;j++){
                var range = value_range[j];
                if(data[i].value>=range){
                    if(j==0)
                        symbol = 'image://..//sandbox_leader/images/green01.png';
                    else if(j==1)
                        symbol = 'image://..//sandbox_leader/images/green02.png';
                    else if(j==2)
                        symbol = 'image://..//sandbox_leader/images/yellow01.png';
                    else if(j==3)
                        symbol = 'image://..//sandbox_leader/images/yellow02.png';
                    else if(j==4)
                        symbol = 'image://../sandbox_leader/images/red01.png';
                    //else if(j==5)
                       // symbol = 'image://../sandbox_leader/images/red02.png';
                    break;
                }else{
                    if(data[i].value<value_range[k-2]){
                        symbol = 'image://../sandbox_leader/images/red02.png';
                    }
                }
            }

            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value),
                symbol:symbol
            });
        }else{
            //console.log(data[i].name);
        }
    }
    return res;
};

var convertData_sub = function(data){
    var res = [];
    for (var i = 0; i < data.length; i++) {
        var geoCoord = geoCoordMap_sub[data[i].id];
        if (geoCoord) {

            var symbol = "";
            /*if(data[i].value>60)
                symbol = 'circle';
            else if(data[i].value>50)
                symbol = 'circle';
            else if(data[i].value>40)
                symbol = 'circle';
            else if(data[i].value>30)
                symbol = 'circle';
            else if(data[i].value>20)
                symbol = 'circle';
            else if(data[i].value>0)*/
                symbol = 'circle';

            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value),
                symbol:symbol
            });
        }else{
            //console.log(data[i].name);
        }
    }
    //console.log(res);
    return res;
}


var convertData_grid = function(data){
    var res = [];
    for (var i = 0; i < data.length; i++) {
        var geoCoord = geoCoordMap_grid[data[i].id];
        if (geoCoord) {

            var symbol = "";
            /*if(data[i].value>60)
                symbol = 'circle';
            else if(data[i].value>50)
                symbol = 'circle';
            else if(data[i].value>40)
                symbol = 'circle';
            else if(data[i].value>30)
                symbol = 'circle';
            else if(data[i].value>20)
                symbol = 'circle';
            else if(data[i].value>0)*/
                symbol = 'circle';

            res.push({
                name: data[i].name,
                value: geoCoord.concat($.trim(data[i].value)),
                symbol:symbol
            });
        }else{
            //console.log(data[i].name);
        }
    }
    return res;
}


var convertData_village = function(data){
    var res = [];
    for (var i = 0; i < data.length; i++) {
        var geoCoord = geoCoordMap_village[data[i].id];
        if (geoCoord) {

            /*var symbol = "";
            if(data[i].value>60)
                symbol = 'circle';
            else if(data[i].value>50)
                symbol = 'circle';
            else if(data[i].value>40)
                symbol = 'circle';
            else if(data[i].value>30)
                symbol = 'circle';
            else if(data[i].value>20)
                symbol = 'circle';
            else if(data[i].value>0)
                symbol = 'circle';*/

            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value)/*,
                symbol:'circle'*/
            });
        }else{
            //console.log(data[i].name);
        }
    }
    //console.log(res);
    return res;
}

//渠道沙盘门店坐标用
var convertData_channel = function (city_id,data,value_range) {
    var res = [];
    for (var i = 0; i < data.length; i++) {
        if(city_id==undefined)
            city_id = '999';
        var geoCoord = geoCoordMap_channel[city_id][data[i].name];
        if (geoCoord) {

            var symbol = "circle";
            //var symbol_size = [10,10];
            /*for(var j = 0,k = 6;j<k;j++){
                var range = value_range[j];
                if(data[i].value>=range){
                    if(j==0)
                        symbol_size = [16,16];
                    else if(j==1)
                        symbol_size = [12,12];
                    else if(j==2)
                        symbol_size = [14,14];
                    /!*else if(j==3)
                        symbol_size = [];
                    else if(j==4)
                        symbol_size = [];
                    else if(j==5)
                        symbol_size = [];*!/
                    break;
                }
            }*/

            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value),
                symbol:symbol
            });
        }else{
            //console.log(data[i].name);
        }
    }
    return res;
};