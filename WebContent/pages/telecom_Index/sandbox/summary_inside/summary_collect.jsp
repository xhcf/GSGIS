<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="grid_list">
  SELECT '-1' CODE, '全部' TEXT FROM DUAL UNION ALL
  SELECT GRID_ID CODE,GRID_NAME TEXT FROM gis_data.db_cde_grid
  where UNION_ORG_CODE = '${param.substation }'
  and grid_status = 1 AND GRID_UNION_ORG_CODE <> '-1'
</e:q4l>
<e:q4o var="query_table_name">
    SELECT DISTINCT LATN_ID,bureau_no,union_org_code FROM gis_data.db_cde_grid where UNION_ORG_CODE = '${param.substation }'
</e:q4o>
<html>
<head>
    <title>资料标签</title>
  <style>
    .div_show{display:block;}
    .div_hide{display:none;}
    .red_font {color:red;}

    .tab_header tr th:first-child {width:6%!important;}
    .tab_header tr th:nth-child(2) {width:6%!important;}
    .tab_header tr th:nth-child(3) {width:6%!important;}
    .tab_header tr th:nth-child(4) {width:16%!important;}
    .tab_header tr th:nth-child(5) {width:15%!important;}
    .tab_header tr th:nth-child(6) {width:10%!important;}
    .tab_header tr th:nth-child(7) {width:15%!important;}
    .tab_header tr th:nth-child(8) {width:10%!important;}
    .tab_header tr th:nth-child(9) {width:10%!important;}
    .tab_header tr th:nth-child(10) {width:6%!important;}

    #collect_new1_bulid_info_list tr td:first-child {width:6%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(2) {width:6%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(3) {width:6%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(4) {width:16%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(5) {width:15%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(6) {width:10%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(7) {width:15%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(8) {width:10%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(9) {width:10%!important;}
    #collect_new1_bulid_info_list tr td:nth-child(10) {width:6%!important;}

    .tag_switch{width:50%;float:right;text-align:right;padding-right:15px;}
    .tag_switch span {font-size: 12px;font-weight: normal;padding: 0 3px;cursor: pointer;margin-left: 0;}
    .tag_switch .active {color: #ee7008;}
  </style>
  <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
  <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
</head>
<body>
<div id="info_sub_name" class="sub_name"></div>

<div class="tab_head" id="info_tab_head">
  <span class="active">小区</span> <span>竞争收集</span>
</div>
<div class="tab_body" id="info_tab_body">
  <div class="div_show div_0">
    <!--小区标签页内容 -->
    <div class="info_village">
	    <span>小区数： <span id="info_village_on">--</span></span>
	    <span>, 已用楼宇： <span id="info_build_on">--</span></span>
	    <span>, 未用楼宇： <span id="info_build_off">--</span></span>
    </div>
    <div class="resident_wrapper">
	            网格：<e:select id="info_village_grid_id" name="info_village_grid_id" items="${grid_list.list }" label="TEXT" value="CODE"/>
	           小区：<input type="text" id="info_village_name" />
	    <button class="button_click margin_button" onclick="village_query()">查询</button>
        <button class="button_click" onclick="village_new()" >新建</button>
    </div>
    <div class="grid_count_title">
        记录数:<span id="info_village_count"></span>
        <div class="tag_switch">
            <span data="">全部</span><span data="-1">白区</span><span data="0">拔旗</span><span data="1">急迫</span><span data="2">紧迫</span><span data="3">操心</span><span data="4">平稳</span>
        </div>
    </div>
    <div class="village_datagrid">
      <div class="head_table_wrapper">
        <table class="head_table">
          <tr>
            <th style="width: 50px;">序号</th>
            <th style="width: 200px;">小区名称</th>
            <th style="width: 60px;">楼宇数</th>
            <th style="width: 70px;">住户数</th>
            <th style="width: 70px;">市场渗透率</th>
            <th style="width: 70px;">端口占有率</th>
          </tr>
        </table>
      </div>
      <div class="t_table village_m_tab" id="info_m_tab" style="margin:0px auto;">
        <table class="content_table village_detail_in" id="info_village_info_list" style="width:100%;">
        </table>
      </div>
    </div>
  </div>
  <div class="div_hide div_1">
    <!--竞争收集标签页内容 -->
    <div id="collect_new_body">
    <div class="info_village">
        <span>小区数： <span id="collect_new1_village_count">--</span></span>
        <span>, 楼宇数： <span id="collect_new1_build_count">--</span></span>
        <span>, 住户数： <span id="collect_new1_user_count">--</span></span>
        <span>, 应收集： <span id="collect_new1_collect_off">--</span></span>
        <span>, 已收集： <span id="collect_new1_collect_on">--</span></span>
        <span>, 收集率： <span id="collect_new1_collect_rate">--</span></span>
    </div>
    <div class="collect_new_choice">
        <div class="collect_contain_choice" style="margin-left: 15px">
            网格:<e:select items="${grid_list.list }" label="TEXT"
                         value="CODE" id="collect_new1_grid_list" name="collect_new1_grid_list" onchange="load_village_list()"/>
        </div>
        <div>
            <div class="collect_contain_choice">
                小区:
                <select id="collect_new1_village_list" onchange="load_build_list(true)"></select>
                <input type="text" id="collect_new1_village_name" oninput="load_village_name_list()"/>
                <ul id="collect_new1_village_name_list">
                </ul>
            </div>
            <div class="collect_contain_choice">
                楼宇:
                <select id="collect_new1_build_list" onchange="load_build_info(0)"></select>
                <input type="text" id="collect_new1_build_name" oninput="load_build_name_list()">
                <ul id="collect_new1_build_name_list">
                </ul>
            </div>
        </div>
    </div>
    <div class="collect_new_state_wrapper">
        <div id="collect_new1_collect_state" class="tab_accuracy_head follow_head small_padding">
            收集: <span class="active" onclick="select_collect_state(0)"> 全部<span id="collect_new1_all_count"></span></span>
           <span onclick="select_collect_state(1)"> 未收集<span id="collect_new1_off_count"></span></span>
           <span onclick="select_collect_state(2)"> 已收集<span id="collect_new1_on_count"></span></span>
        </div>
        <div id="collect_new1_bselect" class="tab_accuracy_head follow_head small_padding">
            运营商:<span class="active" onclick="select_collect_band(-1)">全部<span id="collect_new1_a_count"></span></span>
         <span onclick="select_collect_band(5)"> 电信<span id="collect_new1_d_count"></span></span>
         <span onclick="select_collect_band(1)"> 移动<span id="collect_new1_y_count"></span></span>
         <span onclick="select_collect_band(2)"> 联通<span id="collect_new1_l_count"></span></span>
         <span onclick="select_collect_band(3)"> 广电<span id="collect_new1_g_count"></span></span>
         <span onclick="select_collect_band(4)"> 其他<span id="collect_new1_q_count"></span></span>
         <span onclick="select_collect_band(0)"> 未装<span id="collect_new1_n_count"></span></span>
        </div>
    </div>
    <div class="grid_count_title grid_count_title_small">
        选定楼宇:<span id="collect_new1_select_build"></span>
    </div>
    <div>
        <div class="head_table_wrapper">
            <table class="head_table">
                <table class="head_table tab_header" cellspacing="0" cellpadding="0">
                    <tr>
                        <th>  </th>
                        <th>序号</th>
                        <th>房间号</th>
                        <th>联系人</th>
                        <th>联系电话</th>
                        <th>宽带运营商</th>
                        <th>宽带到期时间</th>
                        <th>异网收集</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </table>
            </table>
        </div>
        <div id="collect_new1_table_content" class="t_table">
            <table class="content_table" id="collect_new1_bulid_info_list" style="width: 100%"></table>
        </div>
    </div>
 </div>
  </div>
</div>
</body>
</html>
<script>
var begin_scroll = "", seq_num = 0, list_page = 0, collect_bselect = -1, v_type_span = "";
var select_count = 0;
var url = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary_inside.jsp' />";
var url1 = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_build_action.jsp' />";
var url_summary_sub = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary.jsp' />";
var query_table_name = "sde.map_addr_segm_" + ${query_table_name.LATN_ID};
var condition = '${param.condition}';

function initCondition(){
    $.post(url_summary_sub,{"eaction":"get_info_all","substation":substation},function(data){
        var data = $.parseJSON(data);
        if(data.length){
            var d = data[0];
            $(".tag_switch > span[data='']").text($(".tag_switch > span[data='']").text()+"("+d.VILLAGE_CNT+")");//小区 全部
            $(".tag_switch > span[data='-1']").text($(".tag_switch > span[data='-1']").text()+"("+d.LOW_10_FILTER_VILLAGE_CNT+")");//小区 白区
            $(".tag_switch > span[data='0']").text($(".tag_switch > span[data='0']").text()+"("+d.NO_RES_VILLAGE_CNT+")");//小区 拔旗
        }else{
            $(".tag_switch > span[data='']").text($(".tag_switch > span[data='']").text()+"(0)");//小区 全部
            $(".tag_switch > span[data='-1']").text($(".tag_switch > span[data='-1']").text()+"(0)");//小区 白区
            $(".tag_switch > span[data='0']").text($(".tag_switch > span[data='0']").text()+"(0)");//小区 拔旗
        }
    });
    $.post(url_summary_sub,{"eaction":"get_four_vill_type","substation":substation},function(data){
        var data = $.parseJSON(data);

        $(".tag_switch > span[data='1']").text($(".tag_switch > span[data='1']").text()+"("+data.V_TYPE1+")");//小区 急迫小区 20190214
        $(".tag_switch > span[data='2']").text($(".tag_switch > span[data='2']").text()+"("+data.V_TYPE2+")");//小区 紧迫小区 20190214
        $(".tag_switch > span[data='3']").text($(".tag_switch > span[data='3']").text()+"("+data.V_TYPE3+")");//小区 操心小区 20190214
        $(".tag_switch > span[data='4']").text($(".tag_switch > span[data='4']").text()+"("+data.V_TYPE4+")");//小区 平稳小区 20190214
    });

    if(condition == 'baiqu'){
        v_type_span = "-1";
    }else if(condition == 'baqi'){
        v_type_span = "0";
    }else if(condition == 'jipo'){
        v_type_span = "1";
    }else if(condition == 'jinpo'){
        v_type_span = "2";
    }else if(condition == 'caoxin'){
        v_type_span = "3";
    }else if(condition == 'pingwen'){
        v_type_span = "4";
    }
    $(".tag_switch > span[data='"+v_type_span+"']").addClass("active");
}

$(function(){
    //支局名赋值
    $("#info_sub_name").text(sub_name);
    //标签页切换事件
    $("#info_tab_head > span").each(function (index) {
        $(this).on("click", function () {
	        $(this).addClass("active").siblings().removeClass("active");
	        var $show_div = $(".div_" + index);
	        $show_div.show();
	        $("#info_tab_body").children().not($show_div).hide();
	        clear_has_selected();
	        clear_data();
	        if(index==0){
	            load_village(1);
	            load_basic_village_info();
	        }else if(index==1){
	            $("select[name=collect_new1_grid_list]").change();
	            load_collect_basic_info();
	        }
        });
    });

    initCondition();

    //默认先加载第一个标签的数据
    var tab_index = "${param.tab_index}";
    if(tab_index==0){
        $("#info_tab_head span").eq(0).click();
    }else if(tab_index==1){
        $("#info_tab_head span").eq(1).click();
    }else{
        $("#info_tab_head span").eq(0).click();
    }

    //小区页签，小区类型切换
    $(".tag_switch > span").each(function(index){
        $(this).on("click",function(){
            $(this).addClass("active").siblings().removeClass("active");
            v_type_span = $(this).attr("data");
            village_query();
        });
    });
});

$(function () {
    $("#collect_new1_bselect > span").each(function (index) {
         $(this).on("click", function () {
             $("#collect_new1_collect_state > span").removeClass("active");
             $("#collect_new1_collect_state > span").eq(0).addClass("active");
             $(this).addClass("active").siblings().removeClass("active");
         })
    })
    $("#collect_new1_collect_state > span").each(function (index) {
        $(this).on("click", function () {
            $("#collect_new1_bselect > span").removeClass("active");
            $("#collect_new1_bselect > span").eq(0).addClass("active");
            $(this).addClass("active").siblings().removeClass("active");
        })
    })
})

//清除已选中的样式, 一般需要在标签页切换时调用.
function clear_has_selected() {
     $("#collect_new1_bselect > span").removeClass("active");
     $("#collect_new1_bselect > span").eq(0).addClass("active");
     $("#collect_new1_collect_state > span").removeClass("active");
     $("#collect_new1_collect_state > span").eq(0).addClass("active");
}

//下面是标签对应的加载事件
function load_village(is_first){
    var params = {
        "eaction": "info_village_list",
        "village_name": $("#info_village_name").val().trim(),
        "page": list_page,
        "village_grid_id": $("select[name=info_village_grid_id]").val() == '-1' ? '' : $("select[name=info_village_grid_id]").val(),
        "v_type_span": v_type_span,
        "substation": substation
    }
    villageListScroll(params, is_first);
    /*params.eaction = "info_village_count";
    $.post(url, params, function (data) {
        if (data != null && data.trim() != 'null') {
            data = $.parseJSON(data);
            $("#info_village_count").html(data.C_NUM);
        } else {
            $("#info_village_count").html(0);
        }
    })*/
}

function load_basic_village_info() {
    var params = {
	    eaction: "info_village_bsif",
	    substation: substation
    }

	$.post(url, params, function (data) {
	      if (data != null && data.trim() != 'null') {
	          data = $.parseJSON(data);
	          $("#info_village_on").html(data.VILLAGE_IN_MAP);
	          $("#info_build_on").html(data.BUILD_IN_MAP);
	          $("#info_build_off").html(data.BUILD_OUT_MAP);
	      } else {
	    	  $("#info_village_on").html('--');
	          $("#info_build_on").html('--');
	          $("#info_build_off").html('--');
	      }
	})
}

function clear_data() {
    begin_scroll = "", seq_num = 0, list_page = 0, collect_bselect = -1,
    collect_state = 0;
    $("#info_village_info_list").empty();
    $("#collect_new1_bulid_info_list").empty();
}

function village_query() {
    clear_data();
    $("#info_village_info_list").empty();
    load_village(1);
}

function village_new(){
    openVillageNewPopWin();
}

$("#info_m_tab").scroll(function () {
    var viewH = $(this).height();
    var contentH = $(this).get(0).scrollHeight;
    var scrollTop = $(this).scrollTop();
    if (scrollTop / (contentH - viewH) >= 0.95) {
        if (new Date().getTime() - begin_scroll > 500) {
            ++list_page;
            load_village(0);
        }
        begin_scroll = new Date().getTime();
    }
});

function villageListScroll(params, flag) {
    var $village_list = $("#info_village_info_list");
    $.post(url, params, function (data) {
        data = $.parseJSON(data);
        if(list_page==0 && data.length){
            $("#info_village_count").html(data[0].C_NUM);
        }
        for (var i = 0, l = data.length; i < l; i++) {
            var d = data[i];
            var newRow = "<tr><td style='width: 50px'>" + (++seq_num) + "</td>";
            newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" onclick=\"javascript:village_position('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "','" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "');\" >" + d.VILLAGE_NAME + "</a></td>";
            //newRow += "<td style='width: 200px'><a href=\"javascript:void(0);\" onclick=\"test()\">" + d.VILLAGE_NAME + "</a></td>";
            newRow += "<td style='width: 60px'>" + d.BUILD_SUM + "</td><td style='width: 70px'>" + d.ZHU_HU_SUM +
            "</td><td style='width: 70px'>" + d.MARKET_PENETRANCE +
            "</td><td style='width: 70px'>" + d.PORT_PERCENT + "</td></tr>";
            $village_list.append(newRow);
        }

        if (data.length == 0 && flag) {
            $("#info_village_count").html(0);
            $village_list.empty();
            $village_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
            return;
        }
        if (data.length == 0 && flag == 0 && !is_list_load_end){
            getEmptyVillage();
        }
    });
}
var is_list_load_end = false;
function getEmptyVillage(){
    var params = {};
    params.union_org_code = substation;
    params.flag = 3;
    params.eaction = "info_village_empty";
    $.post(url,params,function(data){
        var d = $.parseJSON(data);
        var newRow = "<tr><td style='width: 50px'></td>";
        newRow += "<td style='width:200px'>未建小区</td>";
        newRow += "<td style='width: 60px'>" + d.BUILD_SUM + "</td><td style='width: 70px'>" + d.ZHU_HU_SUM +
        "</td><td style='width: 70px'>" + d.MARKET_PENETRANCE +
        "</td><td style='width: 70px'>" + d.PORT_PERCENT + "</td></tr>";
        $("#info_village_info_list").append(newRow);
    });
    is_list_load_end = true;
}

function village_position(union_org_code,branch_name,grid_name,station_id,village_id){
    clickToGridAndVillage(union_org_code,branch_name ,'',9,grid_name,station_id,village_id,1);
    closeLayerAll();
}

function load_collect_basic_info() {

    var params = {
        eaction: "collect_new_bsif",
        substation: substation
    }

    $.post(url, params, function (data) {
        if (data != null && data.trim() != 'null') {
            data = $.parseJSON(data);
            $("#collect_new1_village_count").html(data.V_COUNT);
            $("#collect_new1_build_count").html(data.B_COUNT);
            $("#collect_new1_user_count").html(data.R_COUNT);
            $("#collect_new1_collect_off").html(data.A_COUNT);
            $("#collect_new1_collect_on").html(data.ON_COUNT);
            $("#collect_new1_collect_rate").html(data.C_RATE);
        } else {
            $("#collect_new1_village_count").html("--");
            $("#collect_new1_build_count").html("--");
            $("#collect_new1_user_count").html("--");
            $("#collect_new1_collect_off").html("--");
            $("#collect_new1_collect_on").html("--");
            $("#collect_new1_collect_rate").html("--");
        }
    })
}
//竞争收集表格
var load_build_info = function (flag) {
    //选中文本回写进 input
    var text = $("#collect_new1_build_list").find("option:selected").text();
    $("#collect_new1_build_name").val(text);
    $("#collect_new1_select_build").html(text);

    before_load_bulid_info(flag);
    load_build_count_info();

    var build_id = $("#collect_new1_build_list").val();
    var $build_list = $("#collect_new1_bulid_info_list");
    if (build_id != "-1") {
        var params = {
            eaction: "collect_new_build_info",
            build_id: build_id,
            res_id: build_id,
            collect_state: collect_state,
            collect_bselect: collect_bselect
        };
        $.post(url1, params, function(data) {
            data = $.parseJSON(data);
            if(!data.length){
                $build_list.append("<tr><td colspan=10>未查到记录</td></tr>");
                return;
            }
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                //var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
                var newRow = "<tr><td class='buss_ico'>";
                if(d.IS_DX>0)
                //电信
                    newRow += "<span class='dx_ico'></span>";
                else if(d.KD_BUS_FLAG==0)
                //未装
                    newRow += "<span class='none_ico'></span>";
                else if(d.KD_BUS_FLAG==1)
                //移动
                    newRow += "<span class='yd_ico'></span>";
                else if(d.KD_BUS_FLAG==2)
                //联通
                    newRow += "<span class='lt_ico'></span>";
                else if(d.KD_BUS_FLAG==3)
                //广电
                    newRow += "<span class='gd_ico'></span>";
                else if(d.KD_BUS_FLAG==4)
                //其他
                    newRow += "<span class='other_ico'></span>";
                //else if(d.KD_BUS_FLAG==5)
                //电信
                newRow += "</td>";
                //if (d.IS_DX == '0') {

                newRow += "<td>"+(i+1)+"</td>";

                newRow += "<td class='bold_blue'>";
                if(d.SERIAL_NO==2)//政企
                    newRow += "<span class='zhengqi_flag'>政</span><a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a></td>";
                else if(d.SERIAL_NO==1 || d.SERIAL_NO==4)//普通住户
                    newRow += "<a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a></td>";

                //} else {
                //      newRow += "<td style='width: 100px' class='bold_blue'>" + d.SEGM_NAME_2 + "</td>";
                //}
                newRow += "<td>" + d.CONTACT_PERSON + "</td>"
                +"<td ' class='num_blue'>" + d.CONTACT_NBR + "</td>";
                if(d.KD_BUSINESS!='电信')
                    newRow += "<td class='buss_red'>" + d.KD_BUSINESS + "</td>";
                else
                    newRow += "<td >" + d.KD_BUSINESS + "(<span class='red_font'>"+ d.IS_KD_DX +"</span>)</td>";

                newRow += "<td >" + d.KD_DQ_DATE + "</td>"
                    //+"<td style='width: 100px;'>" + d.MKT_CONTENT + "</td>"
                +"<td>" + d.COLLLECT_FLAG + "</td>"
                +"<td>" + d.STOP_TYPE_NAME + "</td>";
                //if(d.KD_BUSINESS!='电信')///20181204 电信不收集
                    newRow += "<td><a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>收集</a></td>";
                //else
                //    newRow += "<td></td>";
                newRow += "</tr>"
                $build_list.append(newRow);
            }
            if (data.length == 0 && flag) {
                $build_list.empty();
                $build_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                return;
            }

        })
    }
}

collect_new_load_build_info = load_build_info;

//做名字查询时使用
var village_list = [];
/*以下部分为联动===start*/
function load_village_list() {
    var $village_list =  $("#collect_new1_village_list");
    $village_list.empty();
    village_list = [];
    var params = {
            eaction: "collect_new_village_list",
            grid_id: $("select[name=collect_new1_grid_list]").val() == '-1' ? '' : $("select[name=collect_new1_grid_list]").val(),
            substation: substation
    };
    $.post(url, params, function(data) {
        data = $.parseJSON(data);
        if (data.length != 0) {
            var d, newRow = "<option value='-1' select='selected'>全部</option>";
            for (var i = 0, length = data.length; i < length; i++) {
                d = data[i];
                newRow += "<option value='" + d.VILLAGE_ID + "' select='selected'>" + d.VILLAGE_NAME + "</option>";
                village_list.push(d);
            }
            $village_list.append(newRow);
        }
        load_build_list();
    })
}

function load_village_name_list() {
    setTimeout(function() {
        //下拉列表显示
        var $village_list =  $("#collect_new1_village_name_list");
        $village_list.empty();
        var village_name = $("#collect_new1_village_name").val().trim();
        if (village_name != '') {
            var temp;
            var newRow = "";
            for (var i = 0, length = village_list.length, count = 0; i < length; i++) {
                if ((temp = village_list[i].VILLAGE_NAME).indexOf(village_name) != -1) {
                    newRow += "<li title='" + temp + "' onclick='select_village(\""+ temp + "\",\"" +
                    village_list[i].VILLAGE_ID + "\"," + i + ")'>" + temp + "</li>";
                    count++;
                }
                if (count >= 15) {
                    break;
                }
            }
            $village_list.append(newRow);
            $("#collect_new1_village_name_list").show();
        } else {
            $("#collect_new1_village_name_list").hide();
        }
        //联动改变 select框, 只要不做点击, 都会将select改回全部.
        if (select_count < 1) {
              $("#collect_new1_village_list option:eq(0)").attr('selected','selected');
        }
        select_count++;
        load_build_list(false);
    }, 300)
}

function before_load_build_list() {
    clear_data();
    clear_has_selected();
    $("#collect_new1_select_build").html("");
    $("#collect_new1_all_count").html("(0)");
    $("#collect_new1_off_count").html("(0)");
    $("#collect_new1_on_count").html("(0)");
    $("#collect_new1_a_count").html("(0)");
    $("#collect_new1_d_count").html("(0)");
    $("#collect_new1_y_count").html("(0)");
    $("#collect_new1_l_count").html("(0)");
    $("#collect_new1_g_count").html("(0)");
    $("#collect_new1_q_count").html("(0)");
    $("#collect_new1_n_count").html("(0)");
}

//做名字查询时使用, 数据库太慢
var build_list = [];
//flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.
function load_build_list(selected) {
    var $build_list =  $("#collect_new1_build_list");
    before_load_build_list();
    //如果是通过 select选择的话,select_count重新开始计数.
    if (selected) {
        select_count = 0;
    }
    //只有当第一次改变input的时候将值置位1;
    if (select_count <= 1) {
        $build_list.empty();
        build_list = [];
        //回写,且只有在手动选中的时候才进行回写.
        if (select_count == 0) {
              $("#collect_new1_village_name").val($("#collect_new1_village_list").find("option:selected").text());
        }
        var params = {
                eaction: "collect_new_build_list",
                grid_id: $("select[name=collect_new1_grid_list]").val() == '-1' ? '' : $("select[name=collect_new1_grid_list]").val(),
                village_id: $("#collect_new1_village_list").val() == '-1' ? '' : $("#collect_new1_village_list").val(),
                substation: substation,
                table_name: query_table_name
        };
        $.post(url, params, function(data) {
            data = $.parseJSON(data);
            if (data.length != 0) {
                var d, newRow = "<option value='-1' select='selected'></option>";
                for (var i = 0, length = data.length; i < length; i++) {
                    d = data[i];
                    newRow += "<option value='" + d.SEGM_ID + "' select='selected'>" + d.STAND_NAME + "</option>";
                    build_list.push(d);
                }
                $build_list.append(newRow);

                checkDefaultOption();
            }
        })
    }
}

function checkDefaultOption(){
    $('#collect_new1_build_list').get(0).selectedIndex = 1;
    $('#collect_new1_build_list').trigger("change");
}

function load_build_name_list() {
    setTimeout(function() {
        //下拉列表显示
        var $build_list =  $("#collect_new1_build_name_list");
        $build_list.empty();
        if (select_count <= 1) {
            before_load_build_list();
        }

        var build_name = $("#collect_new1_build_name").val().trim();
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
            $("#collect_new1_build_name_list").show();
        } else {
            $("#collect_new1_build_name_list").hide();
        }

        //联动改变 select框, 只要不做点击, 都会将select改回全部.
        $("#collect_new1_build_list option:eq(0)").attr('selected','selected');
        select_count++;
    }, 300)
}

function select_village(name, id, index) {
    $("#collect_new1_village_list option[value=" + id + "]").attr('selected','selected');
    $("#collect_new1_village_name_list").hide();
    $("#collect_new1_village_list").change();
}

function select_build(name, id, index) {
    $("#collect_new1_build_list option[value=" + id + "]").attr('selected','selected');
    $("#collect_new1_build_name_list").hide();
    $("#collect_new1_build_list").change();
}
/*以上部分为联动===end*/

function select_collect_state(type) {
    collect_bselect = -1;
    collect_state = type;
    load_build_info(1);
}

function select_collect_band(type) {
    collect_state = 0;
    collect_bselect = type;
    load_build_info(1);
}

//为1保存选择条件,否则清除所有条件, 清除已选择.
function before_load_bulid_info(flag) {
    if (flag) {
        var temp1 = collect_state, temp2 = collect_bselect;
        clear_data();
        collect_state = temp1, collect_bselect =temp2;
    } else {
        clear_data();
        clear_has_selected();
    }
}
//加载选择楼宇的统计信息
function load_build_count_info() {
    //选择楼宇后清空输入计数器
    select_count = 0;
    var params = {
            eaction: "collect_new_count",
            build_id: $("#collect_new1_build_list").val()
    };
    $.post(url, params, function(data) {
        if (data != null && data.trim() != 'null') {
            data = JSON.parse(data);
            $("#collect_new1_all_count").html("(" + data.A_COUNT + ")");
            $("#collect_new1_off_count").html("(" + data.OFF_COUNT + ")");
            $("#collect_new1_on_count").html("(" + data.ON_COUNT + ")");
            $("#collect_new1_a_count").html("(" + data.A_COUNT + ")");
            $("#collect_new1_d_count").html("(" + data.D_COUNT + ")");
            $("#collect_new1_y_count").html("(" + data.Y_COUNT + ")");
            $("#collect_new1_l_count").html("(" + data.L_COUNT + ")");
            $("#collect_new1_g_count").html("(" + data.G_COUNT + ")");
            $("#collect_new1_q_count").html("(" + data.Q_COUNT + ")");
            $("#collect_new1_n_count").html("(" + data.N_COUNT + ")");
        } else {
            $("#collect_new1_all_count").html("(0)");
            $("#collect_new1_off_count").html("(0)");
            $("#collect_new1_on_count").html("(0)");
            $("#collect_new1_a_count").html("(0)");
            $("#collect_new1_d_count").html("(0)");
            $("#collect_new1_y_count").html("(0)");
            $("#collect_new1_l_count").html("(0)");
            $("#collect_new1_g_count").html("(0)");
            $("#collect_new1_q_count").html("(0)");
            $("#collect_new1_n_count").html("(0)");
        }
    })

}
</script>
