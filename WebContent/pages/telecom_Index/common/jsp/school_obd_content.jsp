<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '5'
</e:q4o>
<html>
    <head>
        <title>OBD清单</title>
        <style>
            .div_hide.div_obd_2 .head_table tr th:first-child {width:5%;}
            .div_hide.div_obd_2 .head_table tr th:nth-child(2) {width:18%;}
            .div_hide.div_obd_2 .head_table tr th:nth-child(3) {width:30%;}
            .div_hide.div_obd_2 .head_table tr th:nth-child(4) {width:12%;}
            .div_hide.div_obd_2 .head_table tr th:nth-child(5) {width:12%;}
            .div_hide.div_obd_2 .head_table tr th:nth-child(6) {width:12%;}

            #obd_build_info_list tr td:first-child {width:5%;}
            #obd_build_info_list tr td:nth-child(2) {width:18%;}
            #obd_build_info_list tr td:nth-child(3) {width:30%;}
            #obd_build_info_list tr td:nth-child(4) {width:12%;}
            #obd_build_info_list tr td:nth-child(5) {width:12%;}
            #obd_build_info_list tr td:nth-child(6) {width:12%;}

            .grid_obd_m_tab{height:56%!important;}

            .inside_data_orange {
                text-align: center!important;
            }
        </style>
        <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
    </head>
    <body>
        <div id="collect_new_body">
            <table style = "width:100%">
                <tr>
                    <td>
                        <div class="count_num desk_orange_bar inside_data inside_data_orange">
                            OBD数：<span id="obd_sum_01" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            其中：0OBD：<span id="obd_sum_02" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            1OBD：<span id="obd_sum_03" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            高占用OBD：<span id="obd_sum_04" style ="color:#FF0000">0</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
                            <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
                                楼宇分区：<select id="obd_comp_01"></select>
                                楼宇：<select id="obd_comp_02"></select>
                            </div>
                        </div>
                    </td>
                </tr>
                <%--<tr>
                    <td>
                        <div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" style="width:95%;" id="collect_obd_state">状态:
                            <span class="active" onclick="select_obd_state_b(this,'');" id="obd_quanbu">全部<span id="res_obd_all_count" ></span></span>
                            <span onclick="select_obd_state_b(this,1);">0OBD<span id="res_0obd_count"></span></span>
                            <span onclick="select_obd_state_b(this,2);">1OBD<span id="res_1obd_count"></span></span>
                            <span onclick="select_obd_state_b(this,3);">高占用OBD<span id="res_hobd_count" ></span></span>
                        </div>
                    </td>
                </tr>--%>
                <tr>
                    <td>
					<span>
						<div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" id="res_tb">
                            记录数：
                            <span id="recode_cnt"></span>
                        </div>
					</span>
                    </td>
                </tr>
            </table>

            <div class="div_hide div_obd_2">
                <%--<div class="grid_count_title">记录数:<span id="resource_obd_build_count"></span></div>--%>
                <div class="build_datagrid" style="width:96%;margin:0px auto;">
                    <div class="head_table_wrapper">
                        <table class="head_table">
                            <tr>
                                <th >序号</th>
                                <th >设备编号</th>
                                <th >安装地址</th>
                                <th >端口数</th>
                                <th >占用端口数</th>
                                <th >空闲端口数</th>
                                <th >端口占用率</th>
                            </tr>
                        </table>
                    </div>
                    <div class="t_table grid_obd_m_tab" id="build_obd_m_tab2">
                        <table class="content_table build_detail_in" id="obd_build_info_list" style="width:100%;">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<script>
    var url4sql = "<e:url value='' />";
    var type1 = 1;//楼宇分区
    var type2 = "";//楼宇
    var begin = 0,end = 0,seq_num = 0,page = 0;

    var sum01 = "#obd_sum_01";
    var sum02 = "#obd_sum_02";
    var sum03 = "#obd_sum_03";
    var sum04 = "#obd_sum_04";

    var comp01 = "#obd_comp_01";
    var comp02 = "#obd_comp_02";

    var tab_head = "";
    var tab_body = "#obd_build_info_list";

    $(function(){
        get_summary();
        init_comp();
        get_list(true);
    });
    function get_summary(){
        $(sum01).text();
        $(sum02).text();
        $(sum03).text();
        $(sum04).text();
    }
    function init_comp(){
        /*是否新生公寓*/
        $(comp01).append("<option value=\"2\">宿舍区</option>");
        $(comp01).append("<option value=\"1\">教学区</option>");
        $(comp01).append("<option value=\"3\">生活区</option>");

        $(comp01).on("change",function(){
            type1 = $(comp01+" option:selected").val();
            fresh();
        });

        /*楼宇*/
        $(comp02).append("<option value=\"\">全部</option>");
        $(comp02).append("<option value=\"2\">楼1</option>");
        $(comp02).append("<option value=\"3\">楼2</option>");

        $(comp02).on("change",function(){
            type2 = $(comp02+" option:selected").val();
            clear();
            get_list(true);
        });

        $(".tab_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();
            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin > 500) {
                    get_list(false);
                }
                begin = new Date().getTime();
            }
        });
    }

    function freshBuild(){
        $(comp02).empty();
    }

    function get_list(flag){
        for(var i= 0,l = 10;i<l;i++){
            var str = "<tr>";
            str += "<td colspan=7>"+(++seq_num)+"</td>";
            str += "</tr>";
            $(tab_body).append(str);
        }
    }

    function fresh(){
        clear();
        freshBuild();
        get_list(true);
    }
    function clear(){
        begin = 0,end = 0,seq_num = 0,page = 0;
        $(tab_body).empty();
    }
</script>
<script>
    //利用js让头部与内容对应列宽度一致。

    function fix(){
        for(var i=0;i<=$(".tab_header tr").find("th").index();i++){
            $(".tab_body tr td").eq(i).css("width",$(".tab_header tr").find("th").eq(i).width());
        }
    }
    //window.load=fix();
    $(function(){
        //fix();
    });
    $(window).resize(function(){
        return fix();
    });

    //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
    $('.t_table').scroll(function(){
        $('#table_head').css('margin-left',-($('.t_table').scrollLeft()));
    });
</script>