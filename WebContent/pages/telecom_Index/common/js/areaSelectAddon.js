function filterBureauByCity(newValue){
    var cityNo = "#cityNo";
    var areaArr = new Array();
    var v = {};
    v.CODE = '';
    v.TEXT = '全部';
    areaArr[0] = v;
    var index = 1;
    for(var i=0;i<cityJSON.length;i++){
        if(newValue == cityJSON[i].PID){
            var v = {};
            v.CODE = cityJSON[i].CODE;
            v.TEXT = cityJSON[i].TEXT;
            areaArr[index] = v;
            index++;
        }
    }

    $(cityNo).removeAttr("disabled");

    $(cityNo).empty();
    for(var i = 0,l = index-1;i<=l;i++){
        $(cityNo).append("<option value='"+areaArr[i].CODE+"'>"+areaArr[i].TEXT+"</option>");
    }
}

function filterBranchByBureau(newValue){
    var centerNo = "#centerNo";
    var cityArr = new Array();
    var v = {};
    v.CODE = '';
    v.TEXT = '全部';
    cityArr[0] = v;
    var index = 1;
    for(var i=0;i<centerJSON.length;i++){
        if(newValue == centerJSON[i].PID){
            var v = {};
            v.CODE = centerJSON[i].CODE;
            v.TEXT = centerJSON[i].TEXT;
            cityArr[index] = v;
            index++;
        }
    }

    $(centerNo).empty();
    $(centerNo).removeAttr("disabled");
    //$(cityNo).combobox('loadData', areaArr);
    for(var i = 0,l = index-1;i<=l;i++){
        $(centerNo).append("<option value='"+cityArr[i].CODE+"'>"+cityArr[i].TEXT+"</option>");
    }
    $(centerNo).children().eq(0).attr("selected","selected");
}

function filterGridByBranch(newValue){
    var gridNo = "#gridNo";
    var cityArr = new Array();
    var v = {};
    v.CODE = '';
    v.TEXT = '全部';
    cityArr[0] = v;
    var index = 1;

    for (var i = 0; i < gridJSON.length; i++) {
        if (newValue == gridJSON[i].PID) {
            var v = {};
            v.CODE = gridJSON[i].CODE;
            v.TEXT = gridJSON[i].TEXT;
            cityArr[index] = v;
            index++;
        }
    }

    $(gridNo).removeAttr("disabled");
    /*$(gridNo).combobox({
     editable: false,
     valueField: 'CODE',
     textField: 'TEXT'

     });*/

    /*$(gridNo).combobox('loadData', cityArr);
     $(gridNo).combobox('select', $(gridNo).combobox('getData')[0].CODE);*/
    $(gridNo).empty();
    for(var i = 0,l = index-1;i<=l;i++){
        $(gridNo).append("<option value='"+cityArr[i].CODE+"'>"+cityArr[i].TEXT+"</option>");
    }
    $(gridNo).children().eq(0).attr("selected","selected");
}