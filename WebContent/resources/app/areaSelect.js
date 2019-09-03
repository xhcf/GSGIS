/**
 * Created by Administrator on 2016/8/29 0029.
 */
/**
 *
 * var areaJSON=${e:java2json(areaList.list)};
 var cityJSON = ${e:java2json(cityList.list)};
 var centerJSON = ${e:java2json(centerList.list)};
 var gridJSON = ${e:java2json(gridList.list)};
 * */


function AreaSelect(){
    this.areaName="";
    this.cityName="";
    this.centerName="";
    this.gridName="";
    this.areaJSON="";
    this.cityJSON="";
    this.centerJSON="";
    this.gridJSON="";
    this.isDivDis=true;
    this.isNoDis=true;
    this.role='';
    this.area='';
    this.city='';
    this.center='';
    this.grid='';
    this.initAreaSelect=initAreaSelectS;

}


function initAreaSelectS(){
    //areaJSON,cityJSON,centerJSON,gridJSON,areaName,cityName,centerName,gridName,isDivDis,isNoDis,role
    var areadiv='#'+this.areaName;
    //var areaNo='#'+this.areaName.replace('Div','');
    var areaNo = 'select[name=\"'+this.areaName.replace('Div','')+"\"]";
    var cirydiv='#'+this.cityName;
    //var cityNo='#'+this.cityName.replace('Div','');
    var cityNo='select[name=\"'+this.cityName.replace('Div','')+"\"]";
    var centerdiv='#'+this.centerName;
    //var centerNo='#'+this.centerName.replace('Div','');
    var centerNo='select[name=\"'+this.centerName.replace('Div','')+"\"]";
    var griddiv='#'+this.gridName;
    //var gridNo='#'+this.gridName.replace('Div','');
    var gridNo='select[name=\"'+this.gridName.replace('Div','')+"\"]";

    var areaJSON= this.areaJSON;
    var cityJSON= this.cityJSON;
    var centerJSON=this.centerJSON;
    var gridJSON= this.gridJSON;
    var isDivDis= this.isDivDis;
    var isNoDis= this.isNoDis;
    var role= this.role;
    var area=this.area;
    var city=this.city;
    var center=this.center;
    var grid=this.grid;

    $(areaNo).empty();

    //地市
    $(areaNo).append("<option value=''>全省</option>");
    for(var i = 0,l = areaJSON.length;i<l;i++){
        $(areaNo).append("<option value='"+areaJSON[i].CODE+"'>"+areaJSON[i].TEXT+"</option>");
    }
    //区县
    $(cityNo).append("<option value=''>全部</option>");
    for(var i = 0,l = cityJSON.length;i<l;i++){
        $(cityNo).append("<option value='"+cityJSON[i].CODE+"'>"+cityJSON[i].TEXT+"</option>");
    }
    //支局
    $(centerNo).append("<option value=''>全部</option>");
    for(var i = 0,l = centerJSON.length;i<l;i++){
        $(centerNo).append("<option value='"+centerJSON[i].CODE+"'>"+centerJSON[i].TEXT+"</option>");
    }
    //网格
    $(gridNo).append("<option value=''>全部</option>");
    for(var i = 0,l = gridJSON.length;i<l;i++){
        $(gridNo).append("<option value='"+gridJSON[i].CODE+"'>"+gridJSON[i].TEXT+"</option>");
    }

    $(areaNo).bind("change",function(){
        $(cityNo).attr("disabled","disabled");
        $(centerNo).attr("disabled","disabled");
        $(gridNo).attr("disabled","disabled");
        var newValue = $(areaNo).val();
        if(newValue!=''){
            /*新值 变化 相应下一级 改变 */
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

            /*$(cityNo).combobox({
                editable : false,
                valueField : 'CODE',
                textField : 'TEXT'
            });*/
            $(cityNo).removeAttr("disabled");

            //$(cityNo).combobox('loadData', areaArr);
            $(cityNo).empty();
            for(var i = 0,l = index-1;i<=l;i++){
                $(cityNo).append("<option value='"+areaArr[i].CODE+"'>"+areaArr[i].TEXT+"</option>");
            }
            $(cityNo).children().eq(0).attr("selected","selected");
            //$(cityNo).combobox('select',$(cityNo).combobox('getData')[0].CODE);

            $(cityNo).val('');
            //$(cityNo).combobox('setValue', '');
            //$(cityNo).combobox('setText', '全部');
            $(centerNo).val('');
            /*$(centerNo).combobox('setValue', '');
            $(centerNo).combobox('setText', '全部');
            */
            $(gridNo).val('');
            /*$(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/
            //showControl('area',true);
        }else{
            /*$(cityNo).combobox('setValue', '');
            $(cityNo).combobox('setText', '全部');
            $(centerNo).combobox('setValue', '');
            $(centerNo).combobox('setText', '全部');
            $(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/

            $(cityNo).val('');
            $(centerNo).val('');
            $(gridNo).val('');

            //showControl('area',false);
        }
        try{
            query();
        }catch(e){

        }
    });

    //当地市发生变化的时候划小的选择范围也发生着变化
    /*$(areaNo).combobox({
        editable : false,
        onChange :

    });*/


    //当区县发生变化的时候划小的选择范围也发生着变化
    /*$(cityNo).combobox({
        editable : false,
        onChange :
    });*/

    $(cityNo).attr("disabled","disabled");
    $(cityNo).bind("change",function(){
        $(centerNo).attr("disabled","disabled");
        $(gridNo).attr("disabled","disabled");
        var newValue = $(cityNo).val();
        if(newValue == ""){
            //划小

            $(centerNo).val('');
            $(gridNo).val('');

            /*$(centerNo).combobox('setValue', '');
            $(centerNo).combobox('setText', '全部');
            $(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/
            //showControl('city',false);
            //return;
        }else{
            //划小

            $(centerNo).val('');
            $(gridNo).val('');

            /*$(centerNo).combobox('setValue', '');
            $(centerNo).combobox('setText', '全部');
            $(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/

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


            /*$(centerNo).combobox({
                editable : false,
                valueField : 'CODE',
                textField : 'TEXT'
            });

            $(centerNo).combobox('loadData', cityArr);
            $(centerNo).combobox('select',$(centerNo).combobox('getData')[0].CODE);*/

            $(centerNo).empty();
            $(centerNo).removeAttr("disabled");
            //$(cityNo).combobox('loadData', areaArr);
            for(var i = 0,l = index-1;i<=l;i++){
                $(centerNo).append("<option value='"+cityArr[i].CODE+"'>"+cityArr[i].TEXT+"</option>");
            }
            $(centerNo).children().eq(0).attr("selected","selected");

            //showControl('city',true);
        }
        try{
            query();
        }catch(e){

        }
    });


    //当划小发生变化的时候网格的选择范围也发生着变化
    /*$(centerNo).combobox({
        editable : false,
        onChange : function(newValue, oldValue){
            //控制显示
        }
    });*/

    $(centerNo).attr("disabled","disabled");
    $(centerNo).bind("change",function(){
        $(gridNo).attr("disabled","disabled");
        var newValue = $(centerNo).val();
        if(newValue == ""){
            //划小
            /*$(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/
            $(gridNo).val('');
            //showControl('center',false);
            //return;
        }else {
            /*$(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/
            $(gridNo).val('');

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

            //showControl('center',true);
        }
        try{
            query();
        }catch(e){

        }
    });

    $(gridNo).attr("disabled","disabled");

    var roleValue = this.role;
    //   var roleValue = "areaValue";

    /*$(areaNo).combobox("setValue",area);
    $(cityNo).combobox("setValue",city);
    $(centerNo).combobox("setValue",center);
    $(gridNo).combobox("setValue",grid);*/
    $(areaNo).val(area);
    $(cityNo).val(city);
    $(centerNo).val(center);
    $(gridNo).val(grid);


    //全省
    if(roleValue != null && roleValue != '' && roleValue == 'all'){

        showControl('area',false);

        if(area!=''){
            showControl('area',true);
            /*$(areaNo).combobox('setValue', area);
            $(cityNo).combobox('setValue', city);*/
            $(areaNo).val(area);
            $(cityNo).val(city);
        }

        //划小
        if(center == "" && city == ""){
            /*$(centerNo).combobox('setValue', '');
            $(centerNo).combobox('setText', '全部');*/
            $(centerNo).val('');
            //$(centerNo).val('setText', '全部');
        }else{
            /*$(cityNo).combobox('setValue', city);
            $(centerNo).combobox('setValue',center);*/
            $(cityNo).val(city);
            $(centerNo).val(center);
            //showControl('city',true);
        }
        //网格
        if(grid == "" && center == ""){
            $(gridNo).val('');
            //$(gridNo).combobox('setText', '全部');
/*            $(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/
        }else{
            $(cityNo).val(city);
            $(centerNo).val(center);
            $(gridNo).val(grid);
/*            $(cityNo).combobox('setValue', city);
            $(centerNo).combobox('setValue',center);
            $(gridNo).combobox('setValue',grid);*/
            //showControl('center',true);
        }
    }
    //地市
    if(roleValue != null && roleValue != '' && roleValue == 'areaValue'){

        //$(areaNo).combobox("disable");
        $(areaNo).attr("disabled","disabled");
        //showControl('area',true);

        //划小
        if(center == "" && city == ""){
            $(centerNo).val('');
            //$(centerNo).combobox('setText', '全部');
/*            $(centerNo).combobox('setValue', '');
            $(centerNo).combobox('setText', '全部');*/
        }else{
            $(cityNo).val(city);
            $(centerNo).val(center);
/*            $(cityNo).combobox('setValue', city);
            $(centerNo).combobox('setValue',center);*/
        }
        //网格
        if(grid == "" && center == ""){
            $(gridNo).val('');
            //$(gridNo).val('setText', '全部');
/*            $(gridNo).combobox('setValue', '');
            $(gridNo).combobox('setText', '全部');*/
        }else{
            $(cityNo).val(city);
            $(centerNo).val(center);
            $(gridNo).val(grid);
/*            $(cityNo).combobox('setValue', city);
            $(centerNo).combobox('setValue',center);
            $(gridNo).combobox('setValue',grid);*/
        }
    }

    console.log("city:"+city);
    console.log("center:"+center);
    console.log("grid:"+grid);
    console.log("bbb");
    console.log("roleValue:"+roleValue);

    //区县
    if(roleValue != null && roleValue != '' && roleValue == 'cityValue'){
        //地市
        $(areaNo).attr("disabled","disabled");
        //$(areaNo).combobox("disable");

        //区县
        //$(cityNo).combobox("disable");
        $(cityNo).attr("disabled","disabled");

        //划小
        //showControl('city',true);

        //网格
        $(cityNo).attr("disabled","disabled");
        if(grid == "" && center == ""){
            $("#gridDiv").hide();
            $(cityNo).children("[value='"+city+"']").attr("selected","selected");
        }else{
            $(cityNo).val(city);
            $(centerNo).val(center);
            $(gridNo).val(grid);
/*            $(cityNo).combobox('setValue', city);
            $(centerNo).combobox('setValue',center);
            $(gridNo).combobox('setValue',grid);*/
            $("#areaDiv").show();
            $("#cityDiv").show();
            $("#centerNoDiv").show();
            $("#gridDiv").show();
        }
    }

    //划小
    if(roleValue != null && roleValue != '' && roleValue == 'centerNoValue'){
        //地市
        $("#areaDiv").show();
        $(areaNo).attr("disabled","disabled");
        //$(areaNo).combobox("disable");
        //区县
        $("#cityDiv").show();
        //$(cityNo).combobox("disable");
        $(cityNo).attr("disabled","disabled");
        //划小
        $("#centerNoDiv").show();
        //$(centerNo).combobox("disable");
        $(centerNo).attr("disabled","disabled");
        //网格
        //showControl('center',true);
    }

    //网格
    if(roleValue != null && roleValue != '' && roleValue == 'gridValue'){
        //地市
        $("#areaDiv").show();
        //$(areaNo).combobox("disable");
        $(areaNo).attr("disabled","disabled");
        //区县
        $("#cityDiv").show();
        //$(cityNo).combobox("disable");
        $(cityNo).attr("disabled","disabled");
        //划小
        $("#centerNoDiv").show();
        //$(centerNo).combobox("disable");
        $(centerNo).attr("disabled","disabled");
        //网格
        $("#gridDiv").show();
        //$(gridNo).combobox("disable");
        $(gridNo).attr("disabled","disabled");
    }






    /**设置 是  div  不显示  模式   还是  显示  为不可用 模式**/

    function showControl(areaLevel,showorhide){
        if(isDivDis==true){
            if(isNoDis==true){
                showDivControl(areaLevel,showorhide);
                showNoControl(areaLevel,showorhide);
            }else{
                showDivControl(areaLevel,showorhide);
            }

        }else{
            if(isNoDis==true){
                showNoControl(areaLevel,showorhide);
            }else{

            }
        }
    }
    function showDivControl(areaLevel,showorhide){

        if(showorhide==false){//隐藏
            if(areaLevel=='area'){
                $(cityNoDiv).hide();
                $(centerNoDiv).hide();
                $(gridNoDiv).hide();
            }
            if(areaLevel=='city'){
                $(centerNoDiv).hide();
                $(gridNoDiv).hide();
            }
            if(areaLevel=='center'){
                $(gridNoDiv).hide();
            }
            if(areaLevel=='grid'){
            }
        }else if(showorhide==true){//显示下一级
            if(areaLevel=='area'){
                $(cityNoDiv).show();
                $(centerNoDiv).hide();
                $(gridNoDiv).hide();
            }
            if(areaLevel=='city'){
                $(centerNoDiv).show();
                $(gridNoDiv).hide();
            }
            if(areaLevel=='center'){
                $(gridNoDiv).show();
            }
            if(areaLevel=='grid'){
            }
        }

    }
    function showNoControl(areaLevel,showorhide){

        if(showorhide==false){//隐藏
            if(areaLevel=='area'){
                $(cityNo).attr('disable','disable' );
                $(centerNo).attr('disable','disable' );
                $(gridNo).attr('disable','disable' );
/*                $(cityNo).combobox('disable',true );
                $(centerNo).combobox('disable',true );
                $(gridNo).combobox('disable',true );*/
            }
            if(areaLevel=='city'){
                $(centerNo).attr('disable','disable' );
                $(gridNo).attr('disable','disable' );
/*                $(centerNo).combobox('disable',true );
                $(gridNo).combobox('disable',true );*/
            }
            if(areaLevel=='center'){
                $(gridNo).attr('disable','disable' );
                //$(gridNo).combobox('disable',true );
            }
            if(areaLevel=='grid'){
            }
        }else if(showorhide==true){//显示下一级
            if(areaLevel=='area'){
                $(cityNo).removeAttr('disable' );
                $(centerNo).attr('disable','disable' );
                $(gridNo).attr('disable','disable' );
/*                $(cityNo).combobox('enable',true );
                $(centerNo).combobox('disable',true );
                $(gridNo).combobox('disable',true );*/

            }
            if(areaLevel=='city'){
                $(centerNo).removeAttr('disable' );
                $(gridNo).attr('disable','disable' );
/*                $(centerNo).combobox('enable',true );
                $(gridNo).combobox('disable',true );*/
            }
            if(areaLevel=='center'){
                $(gridNo).removeAttr('disable' );
                //$(gridNo).combobox('enable',true );
            }
            if(areaLevel=='grid'){
            }
        }

    }

}