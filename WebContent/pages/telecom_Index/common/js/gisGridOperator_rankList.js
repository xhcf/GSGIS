/**
 * Created by admin on 2017/4/9.
 */
var gisGridOperator = function(params){
    var level = params.level;
    var graLayer_wg = params.graLayer_wg;
    var new_url_sub_grid = params.new_url_sub_grid;
    var graLayer_grid_mouseover = params.graLayer_grid_mouseover;
    var highlightSymbolzj_grid = params.highlightSymbolzj_grid;
    switch (level){
        case 2:
            graLayer_grid_mouseover.on("click",function(evt){
                //graLayer_mouseclick.clear();
                //graLayer_mouseclick.hide();
                dojo.stopEvent(evt);
                //evt.stopPropagation();
                var global_param_temp_for_subgridlist = parent.global_param_temp_for_subgridlist;
                global_param_temp_for_subgridlist["current_flag"] = 5;
                parent.global_param_temp_for_subgridlist = global_param_temp_for_subgridlist;

                /*var graphics = new esri.Graphic(evt.graphic.geometry, highlightSymbolzj_grid,evt.graphic.attributes);
                graLayer_mouseclick.add(graphics);
                graLayer_mouseclick.show();*/

                var attr = evt.graphic.attributes;
                var win_content = "";
                var report_to_id = attr.REPORT_TO_ID;
                report_to_id = $.trim(report_to_id);

                //数据调整后使用这里的代码↓
                if(report_to_id==""||report_to_id=="null")
                    win_content = "<span>暂无关联数据</span>";
                else{
                    $.post(params.get_grid_dev_by_repttoNo,{repttoNo:report_to_id,date:params.date},function(data){
                        data = $.parseJSON(data);
                        if(data==null||data=="")
                            win_content = "<span>暂无关联数据</span>";
                        else{
                            //data = {"BRANCH_NAME":"1","MOBILE_SERV_DAY_NEW":1,"BRD_SERV_DAY_NEW":2,"ITV_SERV_DAY_NEW":3,"ITV_DAY_NEW_INSTALL_SERV":4};
                            /*win_content =  "<span>归属:"+data.BRANCH_NAME+"</span><br/>"+
                            "<table><tr><td>移动</td><td>"+data.MOBILE_SERV_DAY_NEW+"</td></tr>"
                            +"<tr><td>宽带</td><td>"+data.BRD_SERV_DAY_NEW +"</td></tr>"
                            +"<tr><td>ITV</td><td>"+data.ITV_SERV_DAY_NEW+"</td></tr>"
                            +"<tr><td>ITV装机</td><td>"+data.ITV_DAY_NEW_INSTALL_SERV+"</td></tr></table>"*/
                            win_content = "<table style='width: 100%;'>"+
                            "<tr style='font-size: 1.4em;'><td colspan=\"3\" style='font-weight: bold;color: red;padding-bottom: 2px;font-family:\"Microsoft Yahei\";'>网格名称："+attr.REPORTTO.substr(attr.REPORTTO.indexOf("-")+1)+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td colspan=\"3\" style='font-weight: bold;color: black;padding-bottom: 2px;font-family:\"Microsoft Yahei\";'>所属支局："+data.BRANCH_NAME+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;border-right: 1px solid #bab9cf;padding-right: 5px;font-family:\"Microsoft Yahei\";'>指标名称</td><td style='font-weight: bold;padding-left: 5px;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;border-right: 1px solid #bab9cf;padding-right: 5px;font-family:\"Microsoft Yahei\";'>当日发展</td><td style='font-weight: bold;padding-left: 5px;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;font-family:\"Microsoft Yahei\";'>当月发展</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>移动</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.MOBILE_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.MOBILE_MON_CUM_NEW+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>宽带</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.BRD_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.BRD_MON_CUM_NEW+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> ITV</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.ITV_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.ITV_SERV_CUR_MON_NEW+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> 终端</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.LA_TERMINAL_TOTAL+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.CUR_TERMINAL_TOTAL_MON+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> 800M</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.LA_COUNT_800M+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.CUR_COUNT_800M_MON+"</td></tr>"+
                            "</table>";
                        }
                        map.infoWindow.setContent(win_content);
                    });
                }
                map.infoWindow.setContent(win_content);
                map.infoWindow.setTitle("网格指标");
                map.infoWindow.resize(250,180);

                map.infoWindow.show(evt.screenPoint);
                /*var queryTask1 = new esri.tasks.QueryTask(new_url_sub_grid + "/1");
                var query1 = new esri.tasks.Query();
                query1.outFields = ["RESNO","RESNAME"];
                query1.geometry = evt.mapPoint;
                query1.returnGeometry = true;
                queryTask1.execute(query1, function (results){
                    if(results.features.length==0)
                        return;
                    //点网格，刷新右侧联动
                    var grid_name = results.features[0].attributes.RESNAME;//所选网格名*/

                    //parent.global_current_full_area_name = grid_name;
                    //parent.global_current_area_name = grid_name;
                    //parent.freshIndexContainer();
                    //parent.global_position.splice(4,1,grid_name);
                    //parent.updatePosition(parent.global_current_flag-1);
                    //var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(click_line_color), 3);
                    //var graphics = new esri.Graphic(results.features[0].geometry, linesymbol);

                //});
            });

            graLayer_wg_text.on("click",function(evt){
                //graLayer_mouseclick.clear();
                //graLayer_mouseclick.hide();
                dojo.stopEvent(evt);
                //evt.stopPropagation();
                parent.global_current_flag = 5;

                /*var graphics = new esri.Graphic(evt.graphic.geometry, highlightSymbolzj_grid,evt.graphic.attributes);
                 graLayer_mouseclick.add(graphics);
                 graLayer_mouseclick.show();*/

                var attr = evt.graphic.attributes.grid_attr;
                var win_content = "";
                var report_to_id = attr.REPORT_TO_ID;
                report_to_id = $.trim(report_to_id);

                //数据调整后使用这里的代码↓
                if(report_to_id==""||report_to_id=="null")
                    win_content = "<span>暂无关联数据</span>";
                else{
                    $.post(params.get_grid_dev_by_repttoNo,{repttoNo:report_to_id,date:params.date},function(data){
                        data = $.parseJSON(data);
                        if(data==null||data=="")
                            win_content = "<span>暂无关联数据</span>";
                        else{
                            //data = {"BRANCH_NAME":"1","MOBILE_SERV_DAY_NEW":1,"BRD_SERV_DAY_NEW":2,"ITV_SERV_DAY_NEW":3,"ITV_DAY_NEW_INSTALL_SERV":4};
                            /*win_content =  "<span>归属:"+data.BRANCH_NAME+"</span><br/>"+
                             "<table><tr><td>移动</td><td>"+data.MOBILE_SERV_DAY_NEW+"</td></tr>"
                             +"<tr><td>宽带</td><td>"+data.BRD_SERV_DAY_NEW +"</td></tr>"
                             +"<tr><td>ITV</td><td>"+data.ITV_SERV_DAY_NEW+"</td></tr>"
                             +"<tr><td>ITV装机</td><td>"+data.ITV_DAY_NEW_INSTALL_SERV+"</td></tr></table>"*/
                            win_content = "<table style='width: 100%;'>"+
                            "<tr style='font-size: 1.4em;'><td colspan=\"3\" style='font-weight: bold;color: red;padding-bottom: 2px;font-family:\"Microsoft Yahei\";'>网格名称："+attr.REPORTTO.substr(attr.REPORTTO.indexOf("-")+1)+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td colspan=\"3\" style='font-weight: bold;color: black;padding-bottom: 2px;font-family:\"Microsoft Yahei\";'>所属支局："+data.BRANCH_NAME+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;border-right: 1px solid #bab9cf;padding-right: 5px;font-family:\"Microsoft Yahei\";'>指标名称</td><td style='font-weight: bold;padding-left: 5px;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;border-right: 1px solid #bab9cf;padding-right: 5px;font-family:\"Microsoft Yahei\";'>当日发展</td><td style='font-weight: bold;padding-left: 5px;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;border-top: 1px solid #bab9cf;padding-top: 2px;text-align: center;font-family:\"Microsoft Yahei\";'>当月发展</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>移动</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.MOBILE_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.MOBILE_MON_CUM_NEW+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>宽带</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.BRD_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.BRD_MON_CUM_NEW+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> ITV</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.ITV_SERV_DAY_NEW+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.ITV_SERV_CUR_MON_NEW+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> 终端</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.LA_TERMINAL_TOTAL+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.CUR_TERMINAL_TOTAL_MON+"</td></tr>"+
                            "<tr style='font-size: 1.4em;'><td style='font-weight: bold;border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'> 800M</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center;border-right: 1px solid #bab9cf;'>"+data.LA_COUNT_800M+"</td><td style='border-bottom: 1px solid #bab9cf;padding-bottom: 2px;text-align: center'>"+data.CUR_COUNT_800M_MON+"</td></tr>"+
                            "</table>";
                        }
                        map.infoWindow.setContent(win_content);
                    });
                }
                map.infoWindow.setContent(win_content);
                map.infoWindow.setTitle("网格指标");
                map.infoWindow.resize(250,180);

                map.infoWindow.show(evt.screenPoint);
                /*var queryTask1 = new esri.tasks.QueryTask(new_url_sub_grid + "/1");
                 var query1 = new esri.tasks.Query();
                 query1.outFields = ["RESNO","RESNAME"];
                 query1.geometry = evt.mapPoint;
                 query1.returnGeometry = true;
                 queryTask1.execute(query1, function (results){
                 if(results.features.length==0)
                 return;
                 //点网格，刷新右侧联动
                 var grid_name = results.features[0].attributes.RESNAME;//所选网格名*/

                //parent.global_current_full_area_name = grid_name;
                //parent.global_current_area_name = grid_name;
                //parent.freshIndexContainer();
                //parent.global_position.splice(4,1,grid_name);
                //parent.updatePosition(parent.global_current_flag-1);
                //var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(click_line_color), 3);
                //var graphics = new esri.Graphic(results.features[0].geometry, linesymbol);

                //});
            });
        case 1:
            graLayer_wg.on("mouse-over", function(evt){
                //手型
                graLayer_sub_mouseover.clear();
                map.setMapCursor("pointer");
                dojo.stopEvent(evt);
                evt.stopPropagation();
                graLayer_grid_mouseover.clear();
                //var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(sub_mouse_over_color), 3);
                //var graphics = new esri.Graphic(evt.graphic.geometry, linesymbol);
                var graphics = new esri.Graphic(evt.graphic.geometry, highlightSymbolzj_grid,evt.graphic.attributes);
                graLayer_grid_mouseover.add(graphics);
            });
            graLayer_wg_text.on("mouse-over", function(evt){
                //手型
                graLayer_sub_mouseover.clear();
                map.setMapCursor("pointer");
                dojo.stopEvent(evt);
                evt.stopPropagation();
                graLayer_grid_mouseover.clear();
                //var linesymbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new esri.Color(sub_mouse_over_color), 3);
                //var graphics = new esri.Graphic(evt.graphic.geometry, linesymbol);
                var graphics = new esri.Graphic(evt.graphic.attributes.grid_geo, highlightSymbolzj_grid,evt.graphic.attributes.grid_attr);
                graLayer_grid_mouseover.add(graphics);
            });
            graLayer_wg.on("mouse-out", function(evt){
                //默认
                map.setMapCursor("default");
            });
            graLayer_grid_mouseover.on("mouse-over",function(){
                graLayer_sub_mouseover.clear();
                map.setMapCursor("pointer");
            });
    }
}