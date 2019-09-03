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
        /*网格*/
        #tab0_thead tr th:first-child{width:8%;}
        #tab0_thead tr th:nth-child(2){width:24%;}
        #tab0_thead tr th:nth-child(3){width:17%;}
        #tab0_thead tr th:nth-child(4){width:17%;}
        #tab0_thead tr th:nth-child(5){width:17%;}
        #tab0_thead tr th:nth-child(6){width:17%;}

        #tab0_tbody tr td:first-child{width:8%;}
        #tab0_tbody tr td:nth-child(2){width:24%;}
        #tab0_tbody tr td:nth-child(3){width:17%;}
        #tab0_tbody tr td:nth-child(4){width:17%;}
        #tab0_tbody tr td:nth-child(5){width:17%;}
        #tab0_tbody tr td:nth-child(6){width:17%;}
    </style>
</head>
<body>
<div>
    <div class="sub_name" id="stock_org_name"></div>
    <div class="tab_head" id="span_switch">
	    <span class="active">网格</span>
	</div>
    <div class="tab_body" id="div_switch">
        <div class="div_show div_0">
            <div class="grid_count_title">
                记录数:<span id="recode_count0"></span>
            </div>
            <div class="head_table_wrapper">
               <table class="head_table" id="tab0_thead">
                   <tr>
                       <th>序号</th>
                       <th>网格名称</th>
                       <th>保有率</th>
                       <th>活跃率</th>
                       <th>续约率</th>
                       <th>离网率</th>
                   </tr>
               </table>
            </div>
            <div class="t_table div_line_0" id="tab0_scroll" style="margin:0 auto;">
                <table class="content_table grid_detail_in" id="tab0_tbody" style="width:100%;">
                </table>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    var url_summary_vc_sub = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_village_cell.jsp" />';
    var url_summary_inside_vc_sub = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_inside_sub_vc.jsp" />';

    $(function(){
        //支局名赋值
        $("#stock_org_name").text(sub_name);
        //标签页切换事件
        $("#span_switch > span").each(function (index) {
            $(this).on("click", function () {
                $(this).addClass("active").siblings().removeClass("active");
                var $show_div = $(".div_" + index);
                $show_div.show();
                $("#div_switch").children().not($show_div).hide();
                if(index==0){
                    load_tab0();
                }
            });
        });
        //默认先加载第一个标签的数据
        var tab_index = "${param.tab_index}";
        if(tab_index == 0) {
            $("#span_switch span").eq(0).click();
        }else if(tab_index == 1) {
            $("#span_switch span").eq(1).click();
        }else if(tab_index == 2) {
            $("#span_switch span").eq(2).click();
        }else{
            $("#span_switch span").eq(0).click();
        }
        tab0_scroll();
    });

    var begin_scroll = "";//滚动延迟，防止滚动中频繁加载

    /*第一个页签*/
    function load_tab0(){
        clear_data0();
        load_data_list0(0,1);
    };

    //tab1滚动加载 3
    //表格数据加载 1/3
    var seq_num0 = 0,page0 = 0;
    //page 页码    flag 第一次加载时1否则0
    function load_data_list0(page,flag){
        var $list = $("#tab0_tbody");
        $.post(url_summary_inside_vc_sub,{"eaction":"stock_grid","substation":substation,"page": page},function(data){
            var objs = $.parseJSON(data);
            if(page==0){
                if(objs.length){
                    $("#recode_count0").text(objs[0].C_NUM);
                }else{
                    $("#recode_count0").text("0");
                }
            }
            for(var i = 0,l = objs.length;i<l;i++){
                var d = objs[i];
                var row = "<tr>";
                row += "<td>" + (++seq_num0) + "</td>";
                row += "<td><a href=\"javascript:void(0);\">" + d.ORG_NAME + "</a></td>";
                row += "<td>" + d.BY_RATE + "</td>";
                row += "<td>" + d.ACTIVE_RATE + "</td>";
                row += "<td>" + d.XY_RATE +"</td>";
                row += "<td class='head_table_color'>" + d.LW_RATE + "</td>";
                row += "</tr>";
                $list.append(row);
            }

            if(objs.length==0 && flag){
                $list.empty();
                $list.append("<tr><td style='text-align:center' colspan='9' \">没有查询到数据</td></tr>")
            }
        });
    }

    //清理数据，初始化参数 2/3
    function clear_data0(){
        seq_num0 = 0, page0 = 0;
        $("#tab0_tbody").empty();
    }

    //滚动加载 3/3
    function tab0_scroll(){
        $("#tab0_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();
            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll > 500) {
                    load_data_list0(++page1,0);
                }
                begin_scroll = new Date().getTime();
            }
        });
    }

</script>
</body>
</html>