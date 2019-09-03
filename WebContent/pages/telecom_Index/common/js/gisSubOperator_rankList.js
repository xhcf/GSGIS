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

var getGravityCenter = "";
var addSubLabel = "";
var back_to_ext = "";

var graLayer_subname_result = "";
var graLayer_mouseclick= "";

var backToSub = function(){
    //clickedFlag = false;
    map.infoWindow.hide();
    $("#nav_fanhui").show();
    $("#nav_fanhui_sub").hide();
    graLayer_subname_result.clear();
    graLayer_mouseclick.clear();
    graLayer_mouseclick.hide();

    var global_param_temp_for_subgridlist = parent.global_param_temp_for_subgridlist;
    global_param_temp_for_subgridlist["current_flag"] = 3;
    global_param_temp_for_subgridlist["current_full_area_name"] = area_full_name;
    global_param_temp_for_subgridlist["current_area_name"] = area_name;
    parent.global_param_temp_for_subgridlist = global_param_temp_for_subgridlist;
    featureLayer.show();
    graLayer_zjname.show();
    graLayer_qx.show();
    graLayer_qx_all.show();
    graLayer_zj_click.clear();
    graLayer_wg_click.clear();
    graLayer_wg.hide();
    graLayer_wg_text.hide();
    graLayer_grid_mouseover.clear();
    if(back_to_ext=="")
        back_to_ext = map.extent;
    var ext = back_to_ext.getExtent();

    map.setExtent(ext);
    graLayer_sub_mouseover.clear();
    zj_name_show_hide(map.getZoom());

    var position = global_param_temp_for_subgridlist["position"];
    position.splice(2,1,area_full_name);
    global_param_temp_for_subgridlist["position"] = position;
    //freshTab('');//返回区县
    //updatePositionForSubgridList(global_param_temp_for_subgridlist["current_flag"]);
}

//支局下钻
var gisSubOperator = function(params){
    graLayer_zjname = params.graLayer_zjname;
    graLayer_qx = params.graLayer_qx;
    graLayer_qx_all = params.graLayer_qx_all;
    graLayer_wg = params.graLayer_wg;
    graLayer_wg_click = params.graLayer_wg_click;
    graLayer_zj_click = params.graLayer_zj_click;
    graLayer_wg_text = params.graLayer_wg_text;
    graLayer_grid_mouseover = params.graLayer_grid_mouseover;
    graLayer_sub_mouseover = params.graLayer_sub_mouseover;
    graLayer_subname_result= params.graLayer_subname_result;
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
    zj_name_show_hide = params.zj_name_show_hide;
    wg_name_show_hide = params.wg_name_show_hide;

    qx_clicked_line_color = params.qx_clicked_line_color;

    var layer_ds = params.layer_ds;
    var tiled_id = params.tiled_id;

    graLayer_mouseclick = params.graLayer_mouseclick;
    var level = params.level;
    //var graLayer_qx_wd = params.graLayer_qx_wd;

    var new_url_sub_grid = params.new_url_sub_grid;
    var grid_url = params.grid_url;

    var sub_show_flag = true;

    var clickedFlag = true;

    switch (level){
        case 2:
            graLayer_sub_mouseover.on("click", function(evt) {//点区县层，也就是点某个支局，聚焦到这个支局
                map.infoWindow.hide();
                $("#nav_fanhui").hide();
                $("#nav_fanhui_sub").show();

                back_to_ext = map.extent;
                dojo.stopEvent(evt);
                evt.stopPropagation();

                //if(parent.clickFlag)
                //    return;
                //parent.clickFlag = true;
                //graLayer_qx.setOpacity(0.5);

                //graLayer_qx_wd.hide();

                graLayer_wg.clear();
                graLayer_wg_text.clear();
                graLayer_wg.show();
                graLayer_wg_text.show();

                graLayer_sub_mouseover.clear();

                //定位到所点支局的视野
                var sub_selected_geometry = evt.graphic.geometry;

                //放大到所选支局的位置
                var sub_selected_ext = sub_selected_geometry.getExtent();
                map.setExtent(sub_selected_ext.expand(1.5));
                //back_to_ext = sub_selected_ext.expand(1.5);

                featureLayer.hide();//隐藏全部支局的层
                graLayer_zjname.hide();
                graLayer_qx.hide();
                graLayer_qx_all.hide();

                //var sub_name = evt.graphic.attributes.REPORTTO;
                var sub_attr = evt.graphic.attributes;
                var sub_name = sub_data[sub_attr.SUBSTATION_NO];
                var substation = sub_attr.SUBSTATION_NO;
                var resid = sub_attr.RESID;

                var global_param_temp_for_subgridlist = parent.global_param_temp_for_subgridlist;
                global_param_temp_for_subgridlist["current_flag"] = 4;
                global_param_temp_for_subgridlist["current_full_area_name"] = sub_name;
                global_param_temp_for_subgridlist["current_area_name"] = sub_name;
                global_param_temp_for_subgridlist["current_sub_id"] = substation;
                parent.global_param_temp_for_subgridlist = global_param_temp_for_subgridlist;

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

                    var queryTask_tile = new esri.tasks.QueryTask(layer_ds + "/" + tiled_id);
                    var query_tile = new esri.tasks.Query();
                    query_tile.where = "NAME = '" + data.ORG_NAME + "'";//某区县名
                    query_tile.returnGeometry = true;
                    if(params.latn_id==947){
                    }else{
                        queryTask_tile.execute(query_tile, function (results) {
                            graLayer_qx.clear();
                            //指定范围的结果
                            var feature = results.features;
                            //显示圈定范围的业务图层
                            var geometry = feature[0].geometry;
                            qx_geometry = geometry;

                            var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_clicked_line_color), 2);
                            var graphics = new esri.Graphic(qx_geometry, linesymbol);
                            graLayer_qx.add(graphics);
                            graLayer_qx.redraw();
                        });
                    }

                    var position = global_param_temp_for_subgridlist["position"];
                    position.splice(2, 1, data.ORG_NAME);
                    position.splice(3, 1, sub_name);
                    updatePositionForSubgridList(global_param_temp_for_subgridlist["current_flag"]);
                });

                parent.bar_status_history = parent.status;
                freshTab(substation);

                //支局中有网格时候，给所点支局加边框或填充效果
                //var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(click_line_color_sub), 2);
                //填充所点支局，不加边线
                var beforeMouseOverColor = params.beforeMouseOverColor;//STYLE_DIAGONAL_CROSS
                if(beforeMouseOverColor=="" || beforeMouseOverColor==undefined)
                    beforeMouseOverColor = {r:128,g:128,b:128};
                //var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(esri.symbol.SimpleLineSymbol.STYLE_CROSS,new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, 0.5]));//fill_color_array[i]
                //fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, 0.5]), 2));//click_line_color_grid
                var fillsymbol1 = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS,
                    new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,
                        new esri.Color([255,0,0]), 2),new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b,0.25])
                );
                var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol1);
                graphic.setAttributes(sub_attr);
                graLayer_mouseclick.add(graphic);
                graLayer_mouseclick.show();

                graLayer_subname_result.clear();

                //查询支局对应的网格（用业务图层的resid，查对应关系表(sub_id)，获取网格的资源resid，用资源id在网格图层查询resid）
                $.post(params.grids_in_sub_by_subResid, {sub_id: resid, city_id: params.latn_id}, function (data) {
                    data = $.parseJSON(data);
                    if (data.length == 0){
                        //layer.msg("该支局的网格暂未上图",{time:2000});
                        //back_to_ext = "";
                        //该支局下没有一个网格的时候，支局填充后，写“xx支局 [换行] 未划配网格”
                        var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                        font.setFamily("微软雅黑");
                        var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                        //合并geo中的碎片块
                        var temp=sub_selected_geometry.rings;
                        var poly = new esri.geometry.Polygon(map.spatialReference);
                        for(var j=0;j<temp.length;j++){
                            var temp5=new Array();
                            for(var m=0;m<temp[j].length;m++){
                                var la=temp[j][m];
                                var temp2=[la[0],la[1]];
                                temp5.push(temp2);
                            }
                            poly.addRing(temp5);
                        }

                        var name_point = getGravityCenter(sub_selected_geometry,temp);
                        var labelGraphic = new esri.Graphic(name_point, textSymbol);
                        graLayer_subname_result.clear();
                        graLayer_subname_result.add(labelGraphic);
                        graLayer_subname_result.redraw();
                        return;
                    }

                    var where_temp = "RESID IN (";
                    for (var i = 0, l = data.length; i < l; i++) {
                        var resid = data[i].RESID;
                        where_temp += "'" + resid + "'";
                        if (i < l - 1)
                            where_temp += ",";
                    }
                    where_temp += ")";

                    var queryTask1 = new esri.tasks.QueryTask(new_url_sub_grid + "/0");
                    var query1 = new esri.tasks.Query();
                    query1.where = where_temp;
                    query1.outFields = ['SHAPE.AREA', 'RESNAME', 'RESID', 'REPORTTO', 'REPORT_TO_ID'];
                    query1.returnGeometry = true;
                    queryTask1.execute(query1, function (results) {
                        var l = results.features.length;
                        if (l == 0){
                            //layer.msg("该支局的网格暂未上图");
                            //back_to_ext = "";
                            //grid_name_text_color
                            var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                            font.setFamily("微软雅黑");
                            var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            //合并geo中的碎片块
                            var temp=sub_selected_geometry.rings;
                            var poly = new esri.geometry.Polygon(map.spatialReference);
                            for(var j=0;j<temp.length;j++){
                                var temp5=new Array();
                                for(var m=0;m<temp[j].length;m++){
                                    var la=temp[j][m];
                                    var temp2=[la[0],la[1]];
                                    temp5.push(temp2);
                                }
                                poly.addRing(temp5);
                            }

                            var name_point = getGravityCenter(sub_selected_geometry,temp);
                            var labelGraphic = new esri.Graphic(name_point, textSymbol);
                            graLayer_subname_result.add(labelGraphic);
                            graLayer_subname_result.redraw();
                            return;
                        }
                        //支局中的网格的REPORT_TO_ID为空，则不能下钻
                        var hasNoRepotId = 0;
                        for(var i = 0;i<l;i++){
                            var feature = results.features[i];
                            var id = feature.attributes["REPORT_TO_ID"];
                            if($.trim(id)=="" || id ==null){
                                hasNoRepotId += 1;
                            }
                        }

                        //所有的网格都没有REPORT_TO_ID
                        if(hasNoRepotId==l){
                            var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                            font.setFamily("微软雅黑");
                            var textSymbol = new esri.symbol.TextSymbol(sub_name+" \n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            //合并geo中的碎片块
                            var temp=sub_selected_geometry.rings;
                            var poly = new esri.geometry.Polygon(map.spatialReference);
                            for(var j=0;j<temp.length;j++){
                                var temp5=new Array();
                                for(var m=0;m<temp[j].length;m++){
                                    var la=temp[j][m];
                                    var temp2=[la[0],la[1]];
                                    temp5.push(temp2);
                                }
                                poly.addRing(temp5);
                            }

                            var name_point = getGravityCenter(sub_selected_geometry,temp);
                            var labelGraphic = new esri.Graphic(name_point, textSymbol);
                            graLayer_subname_result.clear();
                            graLayer_subname_result.add(labelGraphic);
                            graLayer_subname_result.redraw();
                            return;
                        }

                        //使用配色数组填充网格背景
                        for (var i = 0,k = 0; i < l; i++,k++) {
                            //使用支局背景色填充网格背景
                            //for (var i = 0; i < l; i++) {
                            var feature = results.features[i];
                            var report_to_id = feature.attributes["REPORT_TO_ID"];
                            if($.trim(report_to_id)=="")//网格中REPORT_TO_ID为空的不绘制该网格
                                continue;
                            var geo = feature.geometry;
                            //合并geo中的碎片块
                            var temp=geo.rings;
                            var poly = new esri.geometry.Polygon(map.spatialReference);
                            for(var j=0;j<temp.length;j++){
                                var temp5=new Array();
                                for(var m=0;m<temp[j].length;m++){
                                    var la=temp[j][m];
                                    var temp2=[la[0],la[1]];
                                    temp5.push(temp2);
                                }
                                poly.addRing(temp5);
                            }
                            //用隶属的支局颜色填充每个网格的颜色
                            //var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, beforeMouseOverColor.g, beforeMouseOverColor.b.a]));//fill_color_array[i]

                            if(k>fill_color_array.length-1)
                                k = 0;
                            var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
                            fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), 2));//STYLE_DASH，click_line_color_grid
                            var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
                            graphic.setAttributes(feature.attributes);
                            graLayer_wg.add(graphic);

                            var area = feature.attributes["SHAPE.AREA"];
                            var font = new esri.symbol.Font("12px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                            font.setFamily("微软雅黑");

                            var grid_name = feature.attributes.REPORTTO;
                            if($.trim(grid_name)=="")
                                grid_name = feature.attributes.RESNAME;
                            grid_name = grid_name.substr(grid_name.indexOf("-")+1);
                            var textSymbol = new esri.symbol.TextSymbol(grid_name, font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            //textSymbol.setHaloColor(new esri.Color([255, 0, 0]));
                            //textSymbol.setHaloSize(10);
                            var name_point = getGravityCenter(geo,temp);

                            var labelGraphic = new esri.Graphic(name_point, textSymbol);
                            var grid_geo_attr = new Array();
                            grid_geo_attr["grid_geo"] = geo;
                            grid_geo_attr["grid_attr"] = feature.attributes;
                            labelGraphic.setAttributes(grid_geo_attr);
                            area = area*10000000000;
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
                        }
                        params.level = 2;
                        gisGridOperator(params);
                        var mapZoom = map.getZoom();
                        wg_name_show_hide(mapZoom);
                    });
                });
            });

            graLayer_zjname.on("click",function(evt){
                map.infoWindow.hide();
                $("#nav_fanhui").hide();
                $("#nav_fanhui_sub").show();

                back_to_ext = map.extent;
                dojo.stopEvent(evt);
                evt.stopPropagation();

                //if(parent.clickFlag)
                //    return;
                //parent.clickFlag = true;
                //graLayer_qx.setOpacity(0.5);

                //graLayer_qx_wd.hide();

                graLayer_wg.clear();
                graLayer_wg_text.clear();
                graLayer_wg.show();
                graLayer_wg_text.show();

                graLayer_sub_mouseover.clear();

                //定位到所点支局的视野
                var sub_selected_geometry = evt.graphic.attributes.sub_geo;

                //放大到所选支局的位置
                var sub_selected_ext = sub_selected_geometry.getExtent();
                map.setExtent(sub_selected_ext.expand(1.5));
                //back_to_ext = sub_selected_ext.expand(1.5);

                featureLayer.hide();//隐藏全部支局的层
                graLayer_zjname.hide();
                graLayer_qx.hide();
                graLayer_qx_all.hide();

                //var sub_name = evt.graphic.attributes.REPORTTO;
                var sub_attr = evt.graphic.attributes.sub_attr;
                var sub_name = sub_data[sub_attr.SUBSTATION_NO];
                var substation = sub_attr.SUBSTATION_NO;
                var resid = sub_attr.RESID;

                var global_param_temp_for_subgridlist = parent.global_param_temp_for_subgridlist;
                global_param_temp_for_subgridlist["current_flag"] = 4;
                global_param_temp_for_subgridlist["current_full_area_name"] = sub_name;
                global_param_temp_for_subgridlist["current_area_name"] = sub_name;
                global_param_temp_for_subgridlist["current_sub_id"] = substation;
                parent.global_param_temp_for_subgridlist = global_param_temp_for_subgridlist;

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

                    var queryTask_tile = new esri.tasks.QueryTask(layer_ds + "/" + tiled_id);
                    var query_tile = new esri.tasks.Query();
                    query_tile.where = "NAME = '" + data.ORG_NAME + "'";//某区县名
                    query_tile.returnGeometry = true;
                    if(params.latn_id==947){
                    }else{
                        queryTask_tile.execute(query_tile, function (results) {
                            graLayer_qx.clear();
                            //指定范围的结果
                            var feature = results.features;
                            //显示圈定范围的业务图层
                            var geometry = feature[0].geometry;
                            qx_geometry = geometry;

                            var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(qx_clicked_line_color), 2);
                            var graphics = new esri.Graphic(qx_geometry, linesymbol);
                            graLayer_qx.add(graphics);
                            graLayer_qx.redraw();
                        });
                    }
                    parent.global_position.splice(2, 1, data.ORG_NAME);
                    parent.global_position.splice(3, 1, sub_name);
                    parent.updatePosition(parent.global_current_flag);
                });

                parent.bar_status_history = parent.status;

                graLayer_mouseclick.clear();

                //支局中有网格时候，给所点支局加边框或填充效果
                //var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(click_line_color_sub), 2);
                //填充所点支局，不加边线
                var beforeMouseOverColor = params.beforeMouseOverColor;//STYLE_DIAGONAL_CROSS
                if(beforeMouseOverColor=="" || beforeMouseOverColor==undefined)
                    beforeMouseOverColor = {r:128,g:128,b:128};
                //var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(esri.symbol.SimpleLineSymbol.STYLE_CROSS,new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, 0.5]));//fill_color_array[i]
                //fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, 0.5]), 2));//click_line_color_grid
                var fillsymbol1 = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS,
                    new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL,
                        new esri.Color([255,0,0]), 2),new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b,0.25])
                );
                var graphic = new esri.Graphic(sub_selected_geometry, fillsymbol1);
                graphic.setAttributes(sub_attr);
                graLayer_mouseclick.add(graphic);
                graLayer_mouseclick.show();

                //查询支局对应的网格（用业务图层的resid，查对应关系表(sub_id)，获取网格的资源resid，用资源id在网格图层查询resid）
                $.post(params.grids_in_sub_by_subResid, {sub_id: resid, city_id: params.latn_id}, function (data) {
                    data = $.parseJSON(data);
                    if (data.length == 0){
                        //layer.msg("该支局的网格暂未上图",{time:2000});
                        //back_to_ext = "";
                        //该支局下没有一个网格的时候，支局填充后，写“xx支局 [换行] 未划配网格”
                        var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                        font.setFamily("微软雅黑");
                        var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                        //合并geo中的碎片块
                        var temp=sub_selected_geometry.rings;
                        var poly = new esri.geometry.Polygon(map.spatialReference);
                        for(var j=0;j<temp.length;j++){
                            var temp5=new Array();
                            for(var m=0;m<temp[j].length;m++){
                                var la=temp[j][m];
                                var temp2=[la[0],la[1]];
                                temp5.push(temp2);
                            }
                            poly.addRing(temp5);
                        }

                        var name_point = getGravityCenter(sub_selected_geometry,temp);
                        var labelGraphic = new esri.Graphic(name_point, textSymbol);
                        graLayer_subname_result.clear();
                        graLayer_subname_result.add(labelGraphic);
                        graLayer_subname_result.redraw();
                        return;
                    }

                    var where_temp = "RESID IN (";
                    for (var i = 0, l = data.length; i < l; i++) {
                        var resid = data[i].RESID;
                        where_temp += "'" + resid + "'";
                        if (i < l - 1)
                            where_temp += ",";
                    }
                    where_temp += ")";

                    var queryTask1 = new esri.tasks.QueryTask(new_url_sub_grid + "/0");
                    var query1 = new esri.tasks.Query();
                    query1.where = where_temp;
                    query1.outFields = ['SHAPE.AREA', 'RESNAME', 'RESID', 'REPORTTO', 'REPORT_TO_ID'];
                    query1.returnGeometry = true;
                    queryTask1.execute(query1, function (results) {
                        var l = results.features.length;
                        if (l == 0){
                            //layer.msg("该支局的网格暂未上图");
                            //back_to_ext = "";
                            //grid_name_text_color
                            var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                            font.setFamily("微软雅黑");
                            var textSymbol = new esri.symbol.TextSymbol(sub_name+"\n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            //合并geo中的碎片块
                            var temp=sub_selected_geometry.rings;
                            var poly = new esri.geometry.Polygon(map.spatialReference);
                            for(var j=0;j<temp.length;j++){
                                var temp5=new Array();
                                for(var m=0;m<temp[j].length;m++){
                                    var la=temp[j][m];
                                    var temp2=[la[0],la[1]];
                                    temp5.push(temp2);
                                }
                                poly.addRing(temp5);
                            }

                            var name_point = getGravityCenter(sub_selected_geometry,temp);
                            var labelGraphic = new esri.Graphic(name_point, textSymbol);
                            graLayer_subname_result.add(labelGraphic);
                            graLayer_subname_result.redraw();
                            return;
                        }
                        //支局中的网格的REPORT_TO_ID为空，则不能下钻
                        var hasNoRepotId = 0;
                        for(var i = 0;i<l;i++){
                            var feature = results.features[i];
                            var id = feature.attributes["REPORT_TO_ID"];
                            if($.trim(id)=="" || id ==null){
                                hasNoRepotId += 1;
                            }
                        }
                        //所有的网格都没有REPORT_TO_ID
                        if(hasNoRepotId==l){
                            var font = new esri.symbol.Font("15px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                            font.setFamily("微软雅黑");
                            var textSymbol = new esri.symbol.TextSymbol(sub_name+" \n 未划配网格", font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            //合并geo中的碎片块
                            var temp=sub_selected_geometry.rings;
                            var poly = new esri.geometry.Polygon(map.spatialReference);
                            for(var j=0;j<temp.length;j++){
                                var temp5=new Array();
                                for(var m=0;m<temp[j].length;m++){
                                    var la=temp[j][m];
                                    var temp2=[la[0],la[1]];
                                    temp5.push(temp2);
                                }
                                poly.addRing(temp5);
                            }

                            var name_point = getGravityCenter(sub_selected_geometry,temp);
                            var labelGraphic = new esri.Graphic(name_point, textSymbol);
                            graLayer_subname_result.clear();
                            graLayer_subname_result.add(labelGraphic);
                            graLayer_subname_result.redraw();
                            return;
                        }

                        //使用配色数组填充网格背景
                        for (var i = 0,k = 0; i < l; i++,k++) {
                            //使用支局背景色填充网格背景
                            //for (var i = 0; i < l; i++) {
                            var feature = results.features[i];
                            var report_to_id = feature.attributes["REPORT_TO_ID"];
                            if($.trim(report_to_id)=="")//网格中REPORT_TO_ID为空的不绘制该网格
                                continue;
                            var geo = feature.geometry;
                            //合并geo中的碎片块
                            var temp=geo.rings;
                            var poly = new esri.geometry.Polygon(map.spatialReference);
                            for(var j=0;j<temp.length;j++){
                                var temp5=new Array();
                                for(var m=0;m<temp[j].length;m++){
                                    var la=temp[j][m];
                                    var temp2=[la[0],la[1]];
                                    temp5.push(temp2);
                                }
                                poly.addRing(temp5);
                            }
                            //用隶属的支局颜色填充每个网格的颜色
                            //var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color([beforeMouseOverColor.r, beforeMouseOverColor.g, beforeMouseOverColor.b, beforeMouseOverColor.g, beforeMouseOverColor.b.a]));//fill_color_array[i]

                            if(k>fill_color_array.length-1)
                                k = 0;
                            var fillsymbol1 = new esri.symbol.SimpleFillSymbol().setColor(new esri.Color(fill_color_array[k]));//fill_color_array[i]
                            fillsymbol1.setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(fill_color_array[k]), 2));//STYLE_DASH，click_line_color_grid
                            var graphic = new esri.Graphic(poly, fillsymbol1);//var graphic = new esri.Graphic(geo, fillsymbol1);
                            graphic.setAttributes(feature.attributes);
                            graLayer_wg.add(graphic);

                            var area = feature.attributes["SHAPE.AREA"];
                            var font = new esri.symbol.Font("12px", esri.symbol.Font.WEIGHT_BOLD, esri.symbol.Font.WEIGHT_BOLD,esri.symbol.Font.WEIGHT_BOLD);
                            font.setFamily("微软雅黑");

                            var grid_name = feature.attributes.REPORTTO;
                            if($.trim(grid_name)=="")
                                grid_name = feature.attributes.RESNAME;
                            grid_name = grid_name.substr(grid_name.indexOf("-")+1);
                            var textSymbol = new esri.symbol.TextSymbol(grid_name, font, new esri.Color(grid_name_text_color));//feature.attributes.REPORTTO
                            //textSymbol.setHaloColor(new esri.Color([255, 0, 0]));
                            //textSymbol.setHaloSize(10);
                            var name_point = getGravityCenter(geo,temp);

                            var labelGraphic = new esri.Graphic(name_point, textSymbol);
                            var grid_geo_attr = new Array();
                            grid_geo_attr["grid_geo"] = geo;
                            grid_geo_attr["grid_attr"] = feature.attributes;
                            labelGraphic.setAttributes(grid_geo_attr);
                            area = area*10000000000;
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
                        }
                        params.level = 2;
                        gisGridOperator(params);
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
            graLayer_zjname.on("mouse-over", function(evt){
                //手型
                map.setMapCursor("pointer");

                dojo.stopEvent(evt);
                evt.stopPropagation();

            });
            graLayer_zjname.on("mouse-out",function(evt){
                var attr = evt.graphic.attributes;
                var graphic = attr["sub_fill_gra"];
                var color = params.beforeMouseOverColor;
                var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
                    new esri.Color([color.r,color.g,color.b,color.a]), 3),new esri.Color([color.r,color.g,color.b,color.a]));
                graphic.setSymbol(symbol);
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
                var attrs = evt.graphic.attributes;
                map.infoWindow.setTitle("支局信息");
                map.infoWindow.resize(260,200);

                var attr = attrs["sub_dev"];
                var ems = $("#sub_info_win").find("em");
                $(ems[0]).html(sub_data[attrs.SUBSTATION_NO]);

                $(ems[1]).html(attr["grid_id_cnt"]);
                var grid_hide = attr["grid_show"];
                if(grid_hide==0){
                    $(ems[2]).prev().hide();
                    $(ems[2]).hide();
                    $(ems[2]).next().hide();
                }else{
                    $(ems[2]).html(grid_hide);
                    $(ems[2]).prev().show();
                    $(ems[2]).show();
                    $(ems[2]).next().show();
                }

                $(ems[3]).html(attr["branch_type"]);
                $(ems[4]).html(attr["mobile_mon_cum_new"]);
                //$(ems[5]).html(attr["cur_mon_bil_serv"]);
                $(ems[5]).html(attr["mobile_mon_cum_new_last"]);
                $(ems[6]).html(attr["brd_mon_cum_new"]);
                //$(ems[7]).html(attr["cur_mon_brd_serv"]);
                $(ems[7]).html(attr["brd_mon_cum_new_last"]);
                $(ems[8]).html(attr["itv_mon_new_install_serv"]);
                //$(ems[9]).html("1");
                $(ems[9]).html(attr["itv_serv_cur_mon_new_last"]);

                var win_content = $("#sub_info_win").html();
                map.infoWindow.setContent(win_content);
                map.infoWindow.show(evt.screenPoint);
            });
            graLayer_sub_mouseover.on("mouse-out", function(evt){
                //默认
                map.setMapCursor("default");
                map.infoWindow.hide();
            });
    }
}