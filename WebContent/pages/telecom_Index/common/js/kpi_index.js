var color0 = ['#42c877','#8ae9b0','#ff9c2b','#fcb666','#f67d7f','#f04144'];
var pieces0 = "";//echarts中使用 {value:xxx,color:xxx}
var value_range0 = "";//convertData.js中使用的参数 [60,45,30,0]
var choices_str0 = "";//自定义左下角图例，选项（字符串格式）
function generic_kpi_index0(index0_list){
    var pc_temp = new Array();
    var vr_temp = new Array();
    var ch_str_temp = "";
    for(var i = 0,l = index0_list.length;i<l;i++){
        var item = index0_list[i];
        if(i==0){
            pc_temp.push({min:item.RANGE_MIN,color:color0[i]});
            vr_temp.push(item.RANGE_COUNT);
            ch_str_temp += "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-"+item.RANGE_MIN+"\"/> "+item.RANGE_NAME_SHORT+"&nbsp;&nbsp;  ("+item.RANGE_MIN+"-100%)：<span></span></li>";
        }else if(i==l-1){
            pc_temp.push({min:0,max:item.RANGE_MAX,color:color0[l-1]});
            vr_temp.push(0);
            ch_str_temp += "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\""+item.RANGE_MAX+"-0\"/> "+item.RANGE_NAME_SHORT+"&nbsp;&nbsp;  (0-"+item.RANGE_MAX+"%)：<span></span></li>";
        }else{
            pc_temp.push({min:item.RANGE_MIN,max:item.RANGE_MAX,color:color0[i]});
            vr_temp.push(item.RANGE_COUNT);
            ch_str_temp += "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\""+item.RANGE_MAX+"-"+item.RANGE_MIN+"\"/> "+item.RANGE_NAME_SHORT+"&nbsp;&nbsp;  ("+item.RANGE_MIN+"-"+item.RANGE_MAX+"%)：<span></span></li>";
        }
    }
    pieces0 = pc_temp;
    value_range0 = vr_temp;
    choices_str0 = ch_str_temp;
}

function generic_kpi_index(index0_list){
    var pc_temp = new Array();
    var vr_temp = new Array();
    var ch_str_temp = "";
    for(var i = 0,l = index0_list.length;i<l;i++){
        var item = index0_list[i];
        if(i==0){
            pc_temp.push({min:item.RANGE_MIN,color:color0[i]});
            vr_temp.push(item.RANGE_COUNT);
            ch_str_temp += "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\"100-"+item.RANGE_MIN+"\"/> "+item.RANGE_NAME_SHORT+"&nbsp;&nbsp;  ("+item.RANGE_MIN+"-100%)：<span></span></li>";
        }else if(i==l-1){
            pc_temp.push({min:0,max:item.RANGE_MAX,color:color0[l-1]});
            vr_temp.push(0);
            ch_str_temp += "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\""+item.RANGE_MAX+"-0\"/> "+item.RANGE_NAME_SHORT+"&nbsp;&nbsp;  (0-"+item.RANGE_MAX+"%)：<span></span></li>";
        }else{
            pc_temp.push({min:item.RANGE_MIN,max:item.RANGE_MAX,color:color0[i]});
            vr_temp.push(item.RANGE_COUNT);
            ch_str_temp += "<li class=\"active\"><input type=\"checkbox\" name=\"percent_check\" checked=\"checked\" value=\""+item.RANGE_MAX+"-"+item.RANGE_MIN+"\"/> "+item.RANGE_NAME_SHORT+"&nbsp;&nbsp;  ("+item.RANGE_MIN+"-"+item.RANGE_MAX+"%)：<span></span></li>";
        }
    }
    return [pc_temp,vr_temp,ch_str_temp];
}

function arrayDiy(length){
    var arr = new Array(length);
    for(var i = 0,l = length;i<l;i++){
        arr[i] = 0;
    }
    return arr;
}

function objDiy(length){
    var obj = {};
    for(var i = 0,l = length;i<l;i++){
        obj[i] = false;
    }
    return obj;
}