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


function AreaSelect_vc(){
    this.areaName="";
    this.cityName="";
    this.centerName="";
    this.latnJSON="";
    this.countyJSON="";
    this.townJSON="";
    this.isDivDis=true;
    this.isNoDis=true;
    this.role='';
    this.area='';
    this.city='';
    this.center='';
    this.initAreaSelect_vc=initAreaSelectS_vc;
}

function initAreaSelectS_vc() {
    //latnJSON,countyJSON,townJSON,areaName,cityName,centerName,gridName,isDivDis,isNoDis,role
    var areadiv = '#' + this.areaName;
    //var areaNo='#'+this.areaName.replace('Div','');
    var areaNo = 'select[name=\"' + this.areaName.replace('Div', '') + "\"]";
    var cirydiv = '#' + this.cityName;
    //var cityNo='#'+this.cityName.replace('Div','');
    var cityNo = 'select[name=\"' + this.cityName.replace('Div', '') + "\"]";
    var centerdiv = '#' + this.centerName;
    //var centerNo='#'+this.centerName.replace('Div','');
    var centerNo = 'select[name=\"' + this.centerName.replace('Div', '') + "\"]";

    var latnJSON = this.latnJSON;
    var countyJSON = this.countyJSON;
    var townJSON = this.townJSON;
    var isDivDis = this.isDivDis;
    var isNoDis = this.isNoDis;
    var role = this.role;
    var area = this.area;
    var city = this.city;
    var center = this.center;

    $(areaNo).empty();

    //地市
    $(areaNo).append("<option value=''>全部</option>");
    for (var i = 0, l = latnJSON.length; i < l; i++) {
        $(areaNo).append("<option value='" + latnJSON[i].CODE + "'>" + latnJSON[i].TEXT + "</option>");
    }
    //区县
    $(cityNo).append("<option value=''>全部</option>");
    for (var i = 0, l = countyJSON.length; i < l; i++) {
        $(cityNo).append("<option value='" + countyJSON[i].CODE + "'>" + countyJSON[i].TEXT + "</option>");
    }
    //支局
    $(centerNo).append("<option value=''>全部</option>");
    for (var i = 0, l = townJSON.length; i < l; i++) {
        $(centerNo).append("<option value='" + townJSON[i].CODE + "'>" + townJSON[i].TEXT + "</option>");
    }

    $(areaNo).bind("change", function () {
        $(cityNo).attr("disabled", "disabled");
        $(centerNo).attr("disabled", "disabled");
        var newValue = $(areaNo).val();
        if (newValue != '') {
            /*新值 变化 相应下一级 改变 */
            var areaArr = new Array();
            var v = {};
            v.CODE = '';
            v.TEXT = '全部';
            areaArr[0] = v;
            var index = 1;
            for (var i = 0; i < countyJSON.length; i++) {
                if (newValue == countyJSON[i].PID) {
                    var v = {};
                    v.CODE = countyJSON[i].CODE;
                    v.TEXT = countyJSON[i].TEXT;
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
            for (var i = 0, l = index - 1; i <= l; i++) {
                $(cityNo).append("<option value='" + areaArr[i].CODE + "'>" + areaArr[i].TEXT + "</option>");
            }
            $(cityNo).children().eq(0).attr("selected", "selected");
            //$(cityNo).combobox('select',$(cityNo).combobox('getData')[0].CODE);

            $(cityNo).val('');
            //$(cityNo).combobox('setValue', '');
            //$(cityNo).combobox('setText', '全部');
            $(centerNo).val('');
            /*$(centerNo).combobox('setValue', '');
             $(centerNo).combobox('setText', '全部');
             */
            //showControl('area',true);
        } else {
            /*$(cityNo).combobox('setValue', '');
             $(cityNo).combobox('setText', '全部');
             $(centerNo).combobox('setValue', '');
             $(centerNo).combobox('setText', '全部');
             */

            $(cityNo).val('');
            $(centerNo).val('');

            //showControl('area',false);
        }
        try {
            query();
        } catch (e) {

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

    $(cityNo).attr("disabled", "disabled");
    $(cityNo).bind("change", function () {
        $(centerNo).attr("disabled", "disabled");
        var newValue = $(cityNo).val();
        if (newValue == "") {
            //划小

            $(centerNo).val('');

            /*$(centerNo).combobox('setValue', '');
             $(centerNo).combobox('setText', '全部');
             */
            //showControl('city',false);
            //return;
        } else {
            //划小

            $(centerNo).val('');

            /*$(centerNo).combobox('setValue', '');
             $(centerNo).combobox('setText', '全部');
             */

            var cityArr = new Array();
            var v = {};
            v.CODE = '';
            v.TEXT = '全部';
            cityArr[0] = v;
            var index = 1;
            for (var i = 0; i < townJSON.length; i++) {
                if (newValue == townJSON[i].PID) {
                    var v = {};
                    v.CODE = townJSON[i].CODE;
                    v.TEXT = townJSON[i].TEXT;
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
            for (var i = 0, l = index - 1; i <= l; i++) {
                $(centerNo).append("<option value='" + cityArr[i].CODE + "'>" + cityArr[i].TEXT + "</option>");
            }
            $(centerNo).children().eq(0).attr("selected", "selected");

            //showControl('city',true);
        }
        try {
            query();
        } catch (e) {

        }
    });


    //当划小发生变化的时候网格的选择范围也发生着变化
    /*$(centerNo).combobox({
     editable : false,
     onChange : function(newValue, oldValue){
     //控制显示
     }
     });*/

    $(centerNo).attr("disabled", "disabled");
    $(centerNo).bind("change", function () {
        var newValue = $(centerNo).val();
        if (newValue == "") {
            //划小
            /*
             //showControl('center',false);
             return;
             }else {

             var cityArr = new Array();
             var v = {};
             v.CODE = '';
             v.TEXT = '全部';
             cityArr[0] = v;
             var index = 1;

             //showControl('center',true);
             }
             try{
             query();
             }catch(e){

             }
             });


             var roleValue = this.role;
             //   var roleValue = "areaValue";

             /*$(areaNo).combobox("setValue",area);
             $(cityNo).combobox("setValue",city);
             $(centerNo).combobox("setValue",center);
             $(gridNo).combobox("setValue",grid);*/
             //$(areaNo).val(area);
             //$(cityNo).val(city);
             //$(centerNo).val(center);
        }
        try{
            //query();
        }catch(e){

        }
    });

    var roleValue = this.role;
    //   var roleValue = "areaValue";

    /*$(areaNo).combobox("setValue",area);
     $(cityNo).combobox("setValue",city);
     $(centerNo).combobox("setValue",center);
     $(gridNo).combobox("setValue",grid);*/
    $(areaNo).val(area);
    $(cityNo).val(city);
    $(centerNo).val(center);

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
        if(center == ""){
            //$(gridNo).combobox('setText', '全部');
            /*            $(gridNo).combobox('setValue', '');
             $(gridNo).combobox('setText', '全部');*/
        }else{
            $(cityNo).val(city);
            $(centerNo).val(center);
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
        if(center == ""){
            //$(gridNo).val('setText', '全部');
            /*            $(gridNo).combobox('setValue', '');
             $(gridNo).combobox('setText', '全部');*/
        }else{
            $(cityNo).val(city);
            $(centerNo).val(center);
            /*            $(cityNo).combobox('setValue', city);
             $(centerNo).combobox('setValue',center);
             $(gridNo).combobox('setValue',grid);*/
        }
    }

    console.log("city:"+city);
    console.log("center:"+center);
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
        if(center == ""){
            $(cityNo).children("[value='"+city+"']").attr("selected","selected");
        }else{
            $(cityNo).val(city);
            $(centerNo).val(center);
            $("#areaDiv").show();
            $("#cityDiv").show();
            $("#centerNoDiv").show();
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

    /**设置 是  div  不显示  模式   还是  显示  为不可用 模式**/

    function showControl(areaLevel, showorhide) {
        if (isDivDis == true) {
            if (isNoDis == true) {
                showDivControl(areaLevel, showorhide);
                showNoControl(areaLevel, showorhide);
            } else {
                showDivControl(areaLevel, showorhide);
            }

        } else {
            if (isNoDis == true) {
                showNoControl(areaLevel, showorhide);
            } else {

            }
        }
    }
    function showDivControl(areaLevel, showorhide) {

        if (showorhide == false) {//隐藏
            if (areaLevel == 'area') {
                $(cityNoDiv).hide();
                $(centerNoDiv).hide();
            }
            if (areaLevel == 'city') {
                $(centerNoDiv).hide();
            }
        } else if (showorhide == true) {//显示下一级
            if (areaLevel == 'area') {
                $(cityNoDiv).show();
                $(centerNoDiv).hide();
            }
            if (areaLevel == 'city') {
                $(centerNoDiv).show();
            }
        }

    }
    function showNoControl(areaLevel, showorhide) {

        if (showorhide == false) {//隐藏
            if (areaLevel == 'area') {
                $(cityNo).attr('disable', 'disable');
                $(centerNo).attr('disable', 'disable');
            }
            if (areaLevel == 'city') {
                $(centerNo).attr('disable', 'disable');
            }
        } else if (showorhide == true) {//显示下一级
            if (areaLevel == 'area') {
                $(cityNo).removeAttr('disable');
                $(centerNo).attr('disable', 'disable');

            }
            if (areaLevel == 'city') {
                $(centerNo).removeAttr('disable');
            }
        }

    }
}