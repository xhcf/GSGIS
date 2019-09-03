<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '5'
</e:q4o>
<e:q4l var="use_in_add6_list">
    select * from (SELECT DISTINCT use_cust_id FROM gis_data.TB_GIS_KD_RELATION_M where address_id='${param.segment_id}' GROUP BY use_cust_id) where rownum <=5
</e:q4l>
<!DOCTYPE>
<html>
<head>
    <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <title>住户视图</title>
    <style>
        .text_center{text-align: center;border-right:1px solid #d1d1d1;padding-left:0px;}
        .text_left{text-align: left;border-right:1px solid #d1d1d1;}
        .user_switch,.product_num_item{padding:0 5px;}
        .user_switch_selected{color:#ffd200!important;font-weight: bold;}
        .bar_title{
            width:75px;
            height:100%;
            display:inline-block;
            text-align: justify;
            vertical-align:top;}
        .bar_title::after{
            content:"";
            display: inline-block;
            width:100%;
            overflow:hidden;
            height:0;
        }
        .bar_title,.bar_title_select{float:left;}
        .bar_title_select{margin-left:0px;height:35px;line-height:35px;}
        .bar_title_select a {text-decoration: underline;color:#fff;}
        .blue_bar{height: 35px;line-height: 35px;background: #0066FF;color: #fff;padding-left:5px;}
        .gray_thead{background-color:#F2F2F2;color:#000;}
        .gray_thead th{padding-left:0px;color:#000;}
        .font_red{color:red;}
        .no_border{border:none!important;}
        .need_muil{
            width:75px;
            display:inline-block;
            text-align: justify;
            vertical-align:top;
        }
        .need_muil::after{
            content:"";
            display: inline-block;
            width:100%;
            overflow:hidden;
            height:0;
        }
        .layui-layer{background-color:transparent!important;border:0px!important;}
        .home_view table tr {height:40px;}
        .dw_font{font-weight: bold;color:#000!important;}
    </style>
</head>
<body>
<div class="new_collect_wrapper1">
    <!-- 客户信息 -->
    <div class="blue_bar">
        <div class="bar_title">客户信息：</div><div class="bar_title_select" id="homeview_user_switch_list"></div>
    </div>
    <div class="base_messages home_view" style="padding-left:5px;">
        <table cellspacing="0" cellpadding="0">
            <tr><td class="font_bold" width="75"><div class="need_muil">客户名称：</div></td><td id="cust_name"><span></span></td><td class="font_bold" width="70">用户状态：</td><td id="cust_stop_type_name" width="150"><span></span></td></tr>
            <tr><td class="font_bold" width="75"><div class="need_muil">套餐名称：</div></td><td id="main_offer_name" width="300"><span></span></td><td class="font_bold" width="70">入网时间：</td><td id="eff_date" width="150"><span></span></td></tr>
            <tr><td class="font_bold" width="75"><div class="need_muil">月收入：</div></td><td id="arpu_val"><span></span></td><td class="font_bold" width="70">联系电话：</td><td id="cust_phone" width="150"><span></span></td></tr>
            <%--<tr><td class="font_bold no_border" width="75"><div class="need_muil">详细地址：</div></td><td colspan="3" id="add6_detail" class="no_border"><span></span></td></tr>--%>
        </table>
    </div>

    <!-- 产品信息 -->
    <div class="blue_bar" style="margin-top:8px;">
        <div class="bar_title">产品构成：</div><div class="bar_title_select" id="homeview_product_list" ></div>
    </div>
    <div class="product_messages home_view" style="width:98%;">
        <table cellspacing="0" cellpadding="0">
            <tr class="gray_thead">
                <th width="50" class="text_center">序号</th>
                <th width="80" class="text_center" >产品</th>
                <th width="160" class="text_center" >业务号码</th>
                <th width="190" class="text_center" >上月使用量</th>
                <th width="" class="text_center" >本月使用量</th>
                <!--<th class="text_center" >费用(元)</th>-->
            </tr>
        </table>
    </div>
    <div class="product_messages home_view table_line" style="max-height:120px;overflow-y:scroll;">
        <table cellspacing="0" cellpadding="0" id="product_list" style="margin-top:0px;">

        </table>
    </div>
</div>

<script type="text/javascript">
var home_view_url_sql = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_info_collect_diy_action.jsp" />';
$(function() {
    //初始化用户列表
    initUseList();
    //加载数据
    load_info('${use_in_add6_list.list[0].USE_CUST_ID}');
})
function initUseList(){
    var use_list = ${e:java2json(use_in_add6_list.list)};
    if(use_list.length>1){
        var use_list_str = "";
        for(var i = 0,l = use_list.length;i<l;i++){
            var item = use_list[i];
            use_list_str += "<a class='user_switch' href='javascript:void(0);' onclick='showProductList("+item.USE_CUST_ID+",this)'>客户"+(i+1)+"</a>";
        }
        $("#homeview_user_switch_list").append(use_list_str);
        $(".user_switch").eq(0).addClass("user_switch_selected");
    }else{
        //客户只有一个的时候
        $(".bar_title").eq(0).width("60");
        $(".bar_title").eq(0).text("客户信息");
    }
}
function clearProductList(){
    $("#cust_name").text("");
    $("#cust_stop_type_name").text("");
    $("#main_offer_name").text("");
    $("#eff_date").text("");
    $("#arpu_val").text("");
    $("#cust_phone").text("");
    $("#add6_detail").text("");
    $("#kd_num").text("");
    $("#product_list").empty();
    $("#homeview_product_list").empty();
}
function showProductList(use_cust_id,target){
    clearProductList();
    $(target).addClass("user_switch_selected").siblings().removeClass("user_switch_selected");
    load_info(use_cust_id);
}

function load_info(use_cust_id) {
    var index = layer.load(1, {
        shade: [0.1,'#fff'] //0.1透明度的白色背景
    });
    $.post(home_view_url_sql,{"eaction":"resident_info","segment_id":'${param.segment_id}',"use_cust_id":use_cust_id,"acct_month":'${last_month.VAL}'},function(data){
        clearProductList();
        layer.close(index);
        var info_obj = $.parseJSON(data);
        if(info_obj!=null && info_obj!=""){
            //第一条记录作为概况
            var base_obj = info_obj[0];
            $("#cust_name").text(base_obj.CUST_NAME);
            $("#cust_stop_type_name").text(base_obj.STOP_TYPE_NAME);
            $("#main_offer_name").text(base_obj.MAIN_OFFER_NAME);
            $("#eff_date").text(base_obj.EFF_DATE);
            $("#arpu_val").text(base_obj.CHARGE1);
            $("#cust_phone").text(base_obj.USER_CONTACT_NBR);
            $("#add6_detail").text(base_obj.STAND_NAME);
            $("#kd_num").text(base_obj.ACC_NBR);
            //$("#ds_num").text(info_obj.);
            //$("#phone_num").text(info_obj.);

            //其他记录作为产品列表
            var broad_num = 0,itv_num = 0,phone_num = 0;
            for(var i = 0,l = info_obj.length;i<l;i++){
                var pro_item = info_obj[i];
                var pro_type = pro_item.PRODUCT_TEXT;
                var pro_use_last = "";
                var pro_use_this = "";
                if(pro_item.PRODUCT_ORD=='1'){//宽带
                    pro_use_last = pro_item.BYTE_ALL_LAST+"<span class='dw_font'>&nbsp;G</span>";
                    pro_use_this = pro_item.BYTE_ALL+"<span class='dw_font'>&nbsp;G</span>";
                    broad_num ++;
                }
                else if(pro_item.PRODUCT_ORD=='2'){//电视
                    pro_use_last = pro_item.DURATION_LAST+"<span class='dw_font'>&nbsp;小时</span>";
                    pro_use_this = pro_item.DURATION+"<span class='dw_font'>&nbsp;小时</span>";
                    itv_num ++;
                }
                else if(pro_item.PRODUCT_ORD=='3'){//移动
                    pro_use_last = pro_item.FLOW_LAST+"<span class='dw_font'>&nbsp;G</span>";
                    pro_use_this = pro_item.FLOW+"<span class='dw_font'>&nbsp;G</span>";
                    phone_num ++;
                }

                var pro_str = "<tr>" +
                        "<td width='50' class='text_center'>"+(i+1)+"</td>"+
                        "<th width='80' class='text_center' >"+pro_type+"</th>" +
                        "<td width='160' class='text_left' >&nbsp;&nbsp;"+pro_item.ACC_NBR+"</td>" +
                        "<td width='190' class='text_center' >"+pro_use_last+"</td>" +
                        "<td width='' class='text_center' >"+pro_use_this+"</td>" +
                            //"<td class='text_center' style='border-right:1px solid #d1d1d1;padding-left:0px;'>"+pro_item.AMOUNT+"</td>" +
                        "</tr>";
                $("#product_list").append(pro_str);
            }
            $("#homeview_product_list").append("<span class='product_num_item'>宽带：<span class='font_red'>"+broad_num+"</span></span>"+
                    "<span class='product_num_item'>电视：<span class='font_red'>"+itv_num+"</span></span>"+
                    "<span class='product_num_item'>手机：<span class='font_red'>"+phone_num+"</span></span>"
            );
        }
    });
}
</script>
</body>
</html>
