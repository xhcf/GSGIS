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
                            小区OBD：<span id="head_obd_all" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            其中：0OBD：<span id="head_obd_0" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            1OBD：<span id="head_obd_1" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            高占用OBD：<span id="head_obd_g" style ="color:#FF0000">0</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="collect_new_choice">
                            <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;" id="obd_new1_build_span" >楼宇:
                                <select id="collect_new_build_list4" name="collect_new_build_list4" onchange="load_build_info4(0)" style="width: 92%;padding-left:0px;"></select>
                                <input type="text" id="collect_new_build_name4" name="collect_new_build_name4" oninput="load_build_name_list4()" style="width: 80%;border:none;margin: 1px 0px 0px 1px;">
                                <ul id="collect_new_build_name4_list">
                                </ul>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" style="width:95%;" id="collect_obd_state">状态:
                            <span class="active" onclick="select_obd_state_b(this,'');" id="obd_quanbu">全部<span id="res_obd_all_count" ></span></span>
                            <span onclick="select_obd_state_b(this,1);">0OBD<span id="res_0obd_count"></span></span>
                            <span onclick="select_obd_state_b(this,2);">1OBD<span id="res_1obd_count"></span></span>
                            <span onclick="select_obd_state_b(this,3);">高占用OBD<span id="res_hobd_count" ></span></span>
                        </div>
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
                                <th >使用率</th>
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
    var begin_scroll = "", seq_num = 0, list_page = 0,select_count = 0, label=0, collect_state = null;
    var url2 = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action1.jsp' />";
    var zy_type = "";
    var select_count = 0;
    var village_id = '${param.village_id}';

    var obd_head_all=0,obd_head_0=0,obd_head_1=0,obd_head_g=0;

    //打开信息收集编辑页面

    var url_jz = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action1.jsp' />";
    var url_build = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_build_action.jsp' />";
    $(function() {
        initOBDComobo();

        /*$("#collect_new_build_list4 option").removeAttr("selected");
        $("#collect_new_build_list4 option").eq(0).attr("selected","selected")
        var text = $("#collect_new_build_list4").find("option:selected").text();
        $("#collect_new_build_name4").val(text);
        clear_data_OBD();
        load_obd_build();
        load_odb_build_sum_cnt();
        load_obd_build_type_cnt();*/
    });

    function initOBDComobo(){
        //加载楼宇列表
        var params4 = {
            eaction: "collect_new_build_list",
            village_id: village_id
        };
        build_list = [];
        var $build_list =  $("#collect_new_build_list4");
        $.post(url2, params4, function(data) {
            data = $.parseJSON(data);
            if (data.length != 0) {
                var d, newRow = "<option value='-1'>全部</option>";//<option value='-1' select='selected'>全部</option>
                var name,id;
                for (var i = 0, length = data.length; i < length; i++) {
                    d = data[i];
                    newRow += "<option value='" + d.SEGM_ID + "'>" + d.STAND_NAME + "</option>";
                    build_list.push(d);
                }
                $build_list.append(newRow);
                //select_build(name, id, 0);

                //初始化选中
                /*console.log("obd common_build_Id:"+common_bulid_id);
                 if(common_bulid_id!="-1")
                 $("#collect_new_build_list4 option[value='"+common_bulid_id+"']").attr("selected","selected");
                 else*/
                $("#collect_new_build_list4 option").eq(0).attr("selected","selected");

                //console.log("obd楼宇选框");
                //console.log($("#collect_new_build_list4 option[value='"+common_bulid_id+"']"));
                var text = $("#collect_new_build_list4").find("option:selected").text();
                $("#collect_new_build_name4").val(text);
            }
            clear_data_OBD();
            load_obd_build();
            load_odb_build_sum_cnt();
            load_obd_build_type_cnt();
        });
    }

    function clear_data_OBD() {
        begin_scroll = "", seq_num = 0, list_page = 0, collect_state = null;
        $("#obd_build_info_list").empty();
    }

    function load_obd_build(){
        var params = {
            eaction: "obd_build",
            page: 0,
            resid: $("select[name='collect_new_build_list4']").val() == '-1' ? '-1':$("select[name='collect_new_build_list4']").val(),
            //grid_id_short: $("select[name='obd_new1_grid_list']").val() == '-1' ? '' : $("select[name='obd_new1_grid_list']").val(),
            //substation:substation,
            village_id: village_id,
            city_id:parent.city_id,
            zy:zy_type
        }
        buildOBDListScroll(params, 1);
    }

    function load_odb_build_sum_cnt(){
        $.post(url4Query, {eaction: "getVillageBaseInfo", village_id: village_id,acct_month:'${last_month.VAL}'}, function (data) {
            var obj = $.parseJSON(data);
            obd_head_all=obj.OBD_CNT,obd_head_0=obj.ZERO_OBD_CNT,obd_head_1=obj.FIRST_OBD_CNT,obd_head_g=obj.HIGH_USE_OBD_CNT;

            $("#head_obd_all").text(obd_head_all);
            $("#head_obd_0").text(obd_head_0);
            $("#head_obd_1").text(obd_head_1);
            $("#head_obd_g").text(obd_head_g);

        });
    }

    function load_obd_build_type_cnt(){
        var params = {
            eaction: "obd_type_cnt_build",
            resid: $("select[name='collect_new_build_list4']").val() == '-1' ? '':$("select[name='collect_new_build_list4']").val(),
            village_id:village_id,
            city_id:parent.city_id
        }
        $.post(url2,params,function(data){
            if(data!=null && data!="null"){
                var data1 = $.parseJSON(data);
                $("#res_obd_all_count").text("("+data1.SUM_CNT+")");
                $("#res_0obd_count").text("("+data1.OBD0_CNT+")");
                $("#res_1obd_count").text("("+data1.OBD1_CNT+")");
                $("#res_hobd_count").text("("+data1.HOBD_CNT+")");
            }
        });
    }

    function buildOBDListScroll(params,flag){
        //$("#obd_build_info_list").empty();
        var $build_list = $("#obd_build_info_list");
        var build_id_ld = $("#collect_new_build_list4").val();
        common_bulid_id=build_id_ld;
        $.post(url2,params, function (data) {
            data = $.parseJSON(data);
            //seq_num = 0;
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var newRow = "<tr><td >" + (++seq_num) + "</td>";
                //newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" onclick=\"standard_position_load('" + d.GRID_ID + "',this)\" >" + d.GRID_NAME + "</a></td>";
                //newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" style=\"text-align:left;\">" + d.RESFULLNAME + "</a></td>";
                newRow += "<td >" + d.EQP_ID + "<td >" + d.ADDRESS + "</td><td >" + d.PORT_ID_CNT +
                "</td><td>" + d.USE_PORT_CNT + "</td><td >" + d.REMAINDER_CNT  + "</td><td >" + d.USER_PORT_RATE + "</td></tr>";
                //"</td><td style='width: 50px'>" + d.ZE_TEXT + "</td><td style='width: 50px'>" + d.FI_TEXT + "</td></tr>";
                $build_list.append(newRow);
            }
            if (data.length == 0 && flag) {
                $build_list.empty();
                $build_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                return;
            }
        });
    }

    $("#build_obd_m_tab2").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                var params = {
                    eaction: "obd_build",
                    page: ++list_page,
                    resid: $("select[name='collect_new_build_list4']").val() == '-1' ? '-1':$("select[name='collect_new_build_list4']").val(),
                    //grid_id_short: $("select[name='obd_new1_grid_list']").val() == '-1' ? '' : $("select[name='obd_new1_grid_list']").val(),
                    //substation:substation,
                    village_id:village_id,
                    city_id:parent.city_id,
                    zy:zy_type
                }
                buildOBDListScroll(params, 0);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function select_obd_state_b(element,type){
        $(element).addClass("active").siblings().removeClass();
        zy_type = type;
        clear_data_OBD();
        load_obd_build();
        //load_obd_build_type_cnt();
    }

    function load_build_name_list4() {
        setTimeout(function() {
            //下拉列表显示
            var $build_list =  $("#collect_new_build_name4_list");
            $build_list.empty();
            if (select_count <= 1) {
                //before_load_build_list();
            }

            var build_name = $("#collect_new_build_name4").val().trim();
            if (build_name != '') {
                var temp;
                var newRow = "";
                for (var i = 0, length = build_list.length, count = 0; i < length; i++) {
                    if ((temp = build_list[i].STAND_NAME).indexOf(build_name) != -1) {
                        newRow += "<li title='" + temp + "' onclick='select_build(\""+ temp + "\",\"" +
                        build_list[i].SEGM_ID + "\"," + i + ")'>" + temp + "</li>";
                        count++;
                    }
                    if (count >= 15) {
                        break;
                    }
                }
                $build_list.append(newRow);
                $("#collect_new_build_name4_list").show();
            } else {
                $("#collect_new_build_name4_list").hide();

                //[全部]选中
                var text = $("#collect_new_build_list4").find("option:selected").text();
                $("#collect_new_build_name4").val(text);
                $("#collect_new_build_name4_list").html(text);

                yhzt_build_id = $("#collect_new_build_list4").val();
            }

            //联动改变 select框, 只要不做点击, 都会将select改回全部.
            //$("#collect_new_build_list4 option:eq(0)").attr('selected','selected');
            select_count++;
        }, 800)
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