/**
 * Created by admin on 2017/4/9.
 */
var graLayer_zjname = "";
var graLayer_wg = "";
var graLayer_wg_click = "";
var graLayer_zj_click = "";
var graLayer_wg_text = "";
var graLayer_grid_mouseover = "";
var graLayer_sub_mouseover = "";
var graLayer_mouseclick = "";
var js_map = "";
var substation = "";
var featureLayer = "";
var highlightSymbolzj = "";
var sub_data = "";
var grid_name_label_symbol1 = "";
var grid_name_label_symbol2 = "";
var grid_name_label_symbol3 = "";
var grid_name_label_symbol4 = "";
var grid_name_label_symbol5 = "";

var zj_name_show_hide = "";
var getGravityCenter = "";
var addSubLabel = "";
var fontSizeChange = "";

var gp_server_url = "";

var backToQx = function(){
    //clickedFlag = false;
    map.infoWindow.hide();
    $("#nav_fanhui").show();
    $("#nav_fanhui_qx").hide();
    graLayer_mouseclick.clear();
    graLayer_mouseclick.hide();
    graLayer_qx.show();
    parent.clickFlag = false;
    parent.global_current_flag = 3;
    parent.global_current_area_name = area_name;
    parent.global_current_full_area_name = area_full_name;
    featureLayer.show();
    graLayer_zjname.show();
    graLayer_zj_click.clear();
    graLayer_wg_click.clear();
    graLayer_wg.hide();
    graLayer_wg_text.hide();
    graLayer_grid_mouseover.clear();
    var ext = back_to_ext.getExtent();

    map.setExtent(ext);
    graLayer_sub_mouseover.clear();
    zj_name_show_hide(map.getZoom());

    parent.global_position.splice(2,1,area_full_name);
    parent.freshIndexContainer();
    parent.updateTabPosition();

    parent.updatePosition(parent.global_current_flag);

    if(parent.bar_status_history==1){
        parent.frmTitleShow();
    }else{
        parent.frmTitleHide();
    }
}

//支局下钻
var gisSubOperator = function(params){
    graLayer_zjname = params.graLayer_zjname;
    graLayer_qx = params.graLayer_qx;
    graLayer_wg = params.graLayer_wg;
    graLayer_wg_click = params.graLayer_wg_click;
    graLayer_zj_click = params.graLayer_zj_click;
    graLayer_wg_text = params.graLayer_wg_text;
    graLayer_grid_mouseover = params.graLayer_grid_mouseover;
    graLayer_sub_mouseover = params.graLayer_sub_mouseover;
    //graLayer_wg_wd = params.graLayer_wg_wd;
    js_map = params.js_map;
    substation = params.global_substation;
    featureLayer = params.featureLayer;
    highlightSymbolzj = params.highlightSymbolzj;
    sub_data = params.sub_data;
    grid_name_label_symbol1 = params.grid_name_label_symbol1;
    grid_name_label_symbol2 = params.grid_name_label_symbol2;
    grid_name_label_symbol3 = params.grid_name_label_symbol3;
    grid_name_label_symbol4 = params.grid_name_label_symbol4;
    grid_name_label_symbol5 = params.grid_name_label_symbol5;

    zj_name_show_hide = params.zj_name_show_hide;
    getGravityCenter = params.getGravityCenter;
    addSubLabel = params.addSubLabel;
    fontSizeChange = params.fontSizeChange;
    zj_name_show_hide = params.zj_name_show_hide;
    wg_name_show_hide = params.wg_name_show_hide;

    gp_server_url = params.gp_server_url;

    var level = params.level;
    //var graLayer_qx_wd = params.graLayer_qx_wd;
    //var graLayer_zj_wd = params.graLayer_zj_wd;
    graLayer_mouseclick = params.graLayer_mouseclick;

    var new_url_sub_grid = params.new_url_sub_grid;
    var grid_url = params.grid_url;

    var sub_show_flag = true;

    var clickedFlag = true;

    switch (level){
        case 2:
            graLayer_sub_mouseover.on("click", function(evt) {//点区县层，也就是点某个支局，聚焦到这个支局
                back_to_ext = map.extent;
                dojo.stopEvent(evt);
                evt.stopPropagation();
                $("#nav_fanhui").hide();
                $("#nav_fanhui_qx").show();

                //if(parent.clickFlag)
                //    return;
                //parent.clickFlag = true;
                //graLayer_qx.setOpacity(0.5);

                //graLayer_qx_wd.hide();
                //graLayer_zj_wd.hide();

                graLayer_wg.clear();
                graLayer_wg_text.clear();
                graLayer_wg.show();
                graLayer_wg_text.show();

                graLayer_sub_mouseover.clear();

                //定位到所点支局的视野
                var sub_selected_geometry = evt.graphic.geometry;

                //var sub_name = evt.graphic.attributes.REPORTTO;
                var sub_name = sub_data[evt.graphic.attributes.SUBSTATION];
                var substation = evt.graphic.attributes.SUBSTATION;
                var resid = evt.graphic.attributes.RESID;
                var sub_attr = evt.graphic.attributes;
                parent.global_substation = substation;

                parent.global_current_flag = 4;
                parent.global_current_full_area_name = sub_name;
                parent.global_current_area_name = sub_name;

                grid_name_label_symbol1 = new Array();
                grid_name_label_symbol2 = new Array();
                grid_name_label_symbol3 = new Array();
                grid_name_label_symbol4 = new Array();
                grid_name_label_symbol5 = new Array();
                $.post(params.area_name_by_sub_name_url, {
                    sub_id: substation,
                    city_id: params.latn_id
                }, function (data) {
                    data = $.parseJSON(data);
                    if (data == null)
                        return;
                    parent.global_position.splice(2, 1, data.ORG_NAME);
                    parent.global_position.splice(3, 1, sub_name);
                    parent.updatePosition(parent.global_current_flag);
                    parent.updateTabPosition();
                });

                parent.bar_status_history = parent.status;
                parent.freshIndexContainer();

                graLayer_mouseclick.clear();

                //查询支局对应的网格（用业务图层的resid，查对应关系表(sub_id)，获取网格的资源resid，用资源id在网格图层查询resid）
                $.post(params.area_name_by_sub_resid_url, {sub_id: resid, city_id: params.latn_id}, function (data) {
                    data = $.parseJSON(data);
                    if (data.length == 0){
                        layer.msg("该支局网格暂未上图");
                        return;
                    }
                    //放大到所选支局的位置
                    sub_selected_ext = sub_selected_geometry.getExtent();
                    map.setExtent(sub_selected_ext.expand(1.5));

                    var where_temp = "RESID IN (";
                    for (var i = 0, l = data.length; i < l; i++) {
                        var resid = data[i].RESID;
                        where_temp += "'" + resid + "'";
                        if (i < l - 1)
                            where_temp += ",";
                    }
                    where_temp += ")";

                    var queryTask1 = new esri.tasks.QueryTask(new_url_sub_grid + "/1");
                    var query1 = new esri.tasks.Query();
                    query1.where = where_temp;
                    query1.outFields = ['F_AREA', 'RESNAME', 'RESID', 'REPORTTO', 'REPORT_TO_','OBJECTID'];
                    query1.returnGeometry = true;
                    queryTask1.execute(query1, function (results) {
                        var l = results.features.length;
                        if (l == 0){
                            layer.msg("该支局网格暂未上图");
                            return;
                        }
                        //支局中有网格时候，给所点支局加边框或填充效果
                        //var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(click_line_color_sub), 2);
                        graLayer_qx.hide();//隐藏区县范围线
                        featureLayer.hide();//隐藏全部支局的层
                        graLayer_zjname.hide();

                        //填充所点支局，不加边线
                        var beforeMouseOverColor = params.beforeMouseOverColor;
                        var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, 0.5]));//fill_color_array[i]
                        fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL, new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, 0.5]), 2));//click_line_color_grid
                        var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol1);
                        graphic.setAttributes(sub_attr);
                        //graLayer_mouseclick.add(graphic);
                        graLayer_mouseclick.show();

                        var grid_color_array = new Array();
                        //调用gp服务的对象
                        var geoprocessor = new esri.tasks.Geoprocessor(gp_server_url);

                        var distUnit = new esri.tasks.LinearUnit();
                        distUnit.distance = 1000;
                        distUnit.units="esriMeters";
                        var a1= new String("200");
                        var a2= new String("300");

                        //使用配色数组填充网格背景
                        for (var i = 0; i < l; i++) {
                        //使用支局背景色填充网格背景
                        //for (var i = 0; i < l; i++) {
                            var feature = results.features[i];
                            var geo = feature.geometry;

                            var graphic123 = new esri.Graphic(geo);
                            graphic123.setAttributes(feature.attributes);

                            var featureSet = new esri.tasks.FeatureSet();
                            featureSet.features = [ graphic123 ];
                            //featureSet.displayFieldName = ['RESNAME','OBJECTID'];
                            var paramsgp = {//a1是最小面积，a1是最小孔洞
                                "morePoly" : featureSet,jll:distUnit, mj:a1,kongdong:a2
                            };

                            //调用gp服务合并网格图形，去除碎片
                            var k = 0;
                            geoprocessor.execute(paramsgp,function(results, messages){
                                if(k>fill_color_array.length-1)
                                    k = 0;
                                var features = results[0].value.features;
                                var fillsymbol2 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));
                                fillsymbol2.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), 2));
                                var graphic2 = new esri.Graphic(features[0].geometry, fillsymbol2);
                                graphic2.setAttributes(results[1].value.features[0].attributes);
                                graLayer_wg.add(graphic2);
                                k++;
                            });

                            //用隶属的支局颜色填充每个网格的颜色
                            //var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, beforeMouseOverColor.g, beforeMouseOverColor.b.a]));//fill_color_array[i]


                            /*var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
                            fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), 2));//STYLE_DASH，click_line_color_grid
                            var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
                            graphic.setAttributes(feature.attributes);
                            graLayer_wg.add(graphic);*/

                            var area = feature.attributes.F_AREA;
                            var font = new esri.symbol.Font("11px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.VARIANT_NORMAL);
                            font.setFamily("微软雅黑");
                            //var textSymbol = new esri.symbol.TextSymbol(feature.attributes.REPORTTO, font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            var textSymbol = new esri.symbol.TextSymbol(feature.attributes.RESNAME, font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            //textSymbol.setHaloColor(new esri.Color([255, 0, 0]));
                            //textSymbol.setHaloSize(10);
                            //指定网格名称绘制的重心(图形中心点位置)
                            var temp=geo.rings;
                            var name_point = getGravityCenter(geo,temp);

                            var labelGraphic = new esri.Graphic(name_point, textSymbol);

                            if (area > 500000000) {//zoom=3 地图收到很小
                                grid_name_label_symbol5.push(labelGraphic);
                            } else if (area > 70000000) { //zoom=4
                                grid_name_label_symbol4.push(labelGraphic);
                            } else if (area > 8000000) { //zoom=5
                                grid_name_label_symbol3.push(labelGraphic);
                            } else if (area > 300000) { //zoom=6
                                grid_name_label_symbol2.push(labelGraphic);
                            } else { //zoom>=7 地图放到最大，看最清晰的支局
                                grid_name_label_symbol1.push(labelGraphic);
                            }

                            //根据当前地图放大级别，写网格名称到图层上
                            params.level = 2;
                            gisGridOperator(params);
                        }
                        var mapZoom = map.getZoom();
                        wg_name_show_hide(mapZoom);
                    });
                });
            });
        case 1:
            featureLayer.on("mouse-over", function(evt){
                //手型
                map.setMapCursor("pointer");

                dojo.stopEvent(evt);
                evt.stopPropagation();
            });
            graLayer_grid_mouseover.clear();
            featureLayer.on("mouse-out", function(evt){
                //默认
                map.setMapCursor("default");
                map.infoWindow.hide();
            });
            graLayer_sub_mouseover.on("mouse-over", function(evt){
                //手型
                map.setMapCursor("pointer");
                graLayer_grid_mouseover.clear();
                dojo.stopEvent(evt);
                evt.stopPropagation();
            });
            graLayer_sub_mouseover.on("mouse-out", function(evt){
                //默认
                map.setMapCursor("default");
                map.infoWindow.hide();
            });

    }
}


