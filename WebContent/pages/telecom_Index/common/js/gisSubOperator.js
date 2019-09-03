/**
 * Created by admin on 2017/4/9.
 */
var graLayer_zjname = "";
var graLayer_wg = "";
var graLayer_wg_click = "";
var graLayer_zj_click = "";
var graLayer_wg_text = "";
var graLayer_subname_result = "";
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

var indexContainer_url_bearue = "";
var indexContainer_url_sub = "";


var back_to_ext = "";
var gra_last = "";
//支局下钻
var gisSubOperator = function(params){
    graLayer_zjname = params.graLayer_zjname;
    graLayer_qx = params.graLayer_qx;
    graLayer_qx_all = params.graLayer_qx_all;
    graLayer_wg = params.graLayer_wg;
    graLayer_wg_click = params.graLayer_wg_click;
    graLayer_zj_click = params.graLayer_zj_click;
    graLayer_subname_result = params.graLayer_subname_result;
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
    zj_name_show_hide = params.zj_name_show_hide;
    wg_name_show_hide = params.wg_name_show_hide;
    qx_clicked_line_color = params.qx_clicked_line_color;

    var layer_ds = params.layer_ds;
    var tiled_id = params.tiled_id;

    indexContainer_url_bearue = params.indexContainer_url_bearue;
    indexContainer_url_sub = params.indexContainer_url_sub;

    var level = params.level;
    //var graLayer_qx_wd = params.graLayer_qx_wd;
    graLayer_mouseclick = params.graLayer_mouseclick;

    gra_last = params.gra_last;

    var new_url_sub_grid = params.new_url_sub_grid;
    var grid_url = params.grid_url;

    var sub_show_flag = true;

    var clickedFlag = true;

    switch (level){
        case 2:

        case 1:
            graLayer_zjname.on("mouse-over", function(evt){
                //手型
                map.setMapCursor("pointer");

                dojo.stopEvent(evt);
                evt.stopPropagation();
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