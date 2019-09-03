<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE>
<html>
<head>
<c:resources type="easyui,app" style="b" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>存量</title>
    <style>
        #info_m_tab {height:46%;}
        .win_full_screen #info_m_tab {height:70%;}
        #stock_village_table_content {height:70%;}
        .win_full_screen #stock_village_table_content {height:91%;}
    </style>
</head>
<body>
<div>
    <div class="sub_name" id="stock_sub_name"></div>
    <div class="tab_head" id="stock_tab_head">
        <span>小区</span>
    </div>
    <div class="tab_body" id="stock_tab_body">
        <div id="stock_div_0" >
            <div id="stock_village_head" class="resident_wrapper">
            小区：<input type="text" id="stock_village_vname">
        <button class="button_click" onclick="village_query()" >查询</button>
            </div>
            <div class="grid_count_title">
                记录数:<span id="stock_village_count"></span>
            </div>
            <div class="head_table_wrapper">
               <table class="head_table">
                   <tr>
                       <th style="width: 50px;">序号</th>
                       <th style="width: 150px;">小区名称</th>
                       <th style="width: 80px;">保有率</th>
                       <th style="width: 80px;">活跃率</th>
                       <th style="width: 80px;">续约率</th>
                       <th style="width: 80px;">离网率</th>
                   </tr>
               </table>
            </div>
            <div class="t_table" id="stock_village_table_content">
               <table id="stock_village_table_list" class="content_table" width="100%"></table>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
var url = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary_grid.jsp' />";
var begin_scroll = "", seq_num = 0, list_page = 0;
var condition = '${param.condition}';
var grid_id_short = '${param.grid_id_short}';
$(function(){
    //支局名赋值
    $("#stock_sub_name").text(grid_name);
    //标签页切换事件
    $("#stock_tab_head > span").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
            var $show_div = $("#stock_div_" + index);
            $show_div.show();
            $("#stock_tab_body").children().not($show_div).hide();
            clear_data();
            if(index == 0){
            	load_village();
            }else if(index == 1){
                load_build();
            }
        });
    });
    //默认先加载第一个标签的数据
    var tab_index = "${param.tab_index}";
    if (tab_index == 0) {
        $("#stock_tab_head span").eq(0).click();
    } else if(tab_index == 1) {
        $("#stock_tab_head span").eq(1).click();
    }else {
        $("#stock_tab_head span").eq(0).click();
    }
});

function clear_data() {
    begin_scroll = "", seq_num = 0, list_page = 0;
    $("#stock_village_table_list").empty();
}

function load_village() {
    var params = {
        eaction: "stock_village",
        village_name: $("#stock_village_vname").val().trim(),
        "grid_id_short":grid_id_short,
        page: 0
    };
    villageListScroll(params,1);
    params.eaction = "stock_village_count";
    $.post(url, params, function (data) {
        //flag表示第一次加载或是二次加载,当点击渗透率值,排序时, 为2次加载, 不改变渗透率文本内容
        if (data != null && data.trim() != 'null') {
            data = $.parseJSON(data);
            $("#stock_village_count").html(data.C_NUM);
        } else {
            $("#stock_village_count").html(0);
        }
    })
}

$("#stock_village_table_content").scroll(function () {
    var viewH = $(this).height();
    var contentH = $(this).get(0).scrollHeight;
    var scrollTop = $(this).scrollTop();
    if (scrollTop / (contentH - viewH) >= 0.95) {
        if (new Date().getTime() - begin_scroll > 500) {
            var params = {
                    eaction: "stock_village",
                    substation: substation,
                    "grid_id_short":grid_id_short,
                    village_name: $("#stock_village_vname").val().trim(),
                    page: ++list_page
            };
            villageListScroll(params,0);
        }
        begin_scroll = new Date().getTime();
    }
});

function villageListScroll(params,flag) {
    var $village_table = $("#stock_village_table_list");
    $.post(url, params, function(data) {
        data = JSON.parse(data);
        var d = data[0];
        var newRow = "";
        for (var i = 0, length = data.length; i < length; i++) {
            d = data[i];
            newRow = "<tr><td style='width: 50px;'>" + (++seq_num) + "</td><td style='width: 150px;'><a href=\"javascript:void(0);\" onclick=\"javascript:village_position('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "','" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "');\" >" + d.VILLAGE_NAME + "</a>" +
                "</td><td style='width: 80px;'>" + d.BY_RATE + "</td><td style='width: 80px;'>" + d.ACTIVE_RATE +
                "</td><td style='width: 80px;'>" + d.XY_RATE + "</td><td style='width: 80px;'>" + d.LW_RATE + "</td></tr>";
            $village_table.append(newRow);
        }
        if (data.length == 0 && flag) {
            $village_table.empty();
            $village_table.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
            return;
        }
    })
}


function village_position(union_org_code,branch_name,grid_name,station_id,village_id){
    clickToGridAndVillage(union_org_code,branch_name ,'',9,grid_name,station_id,village_id,1);
    closeLayerAll();
}
function village_query() {
    clear_data();
    load_village();
}

function load_build() {
	//<a href=\"javascript:standard_position_load('" + d.SEGM_ID + "','" + parent.city_name + "','" + parent.city_id + "',this);\" >" + d.STAND_NAME + "</a>
}
</script>
</body>
</html>