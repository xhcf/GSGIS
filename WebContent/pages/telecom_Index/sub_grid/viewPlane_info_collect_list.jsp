<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="yesterday">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4l var="scene_list">
    select t.scenes_type_cd id,t.scenes_type_desc text from gis_data.TB_DIC_GIS_SCENES_TYPE t where t.scenes_type_cd in('04','21','10','11') order by t.priority asc
</e:q4l>
<html>
<head>
    <title>收集列表</title>
    <meta charset="utf-8">
    <meta name="author" content="jasmine">
    <!-- 定义作者-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
    <link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet"
          type="text/css"/>
    <link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.5"/>'
          rel="stylesheet"
          type="text/css" media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.3"/>'
          rel="stylesheet"
          type="text/css" media="all"/>
    <link href='<e:url value="/pages/telecom_Index/common/css/info_collect.css?version=0.1"/>' rel="stylesheet"
          type="text/css" media="all"/>
    <script type="text/javascript"
            src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script type="text/javascript"
            src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
    <style type="text/css">
        body {
            background-color: #fff;
        }
        #toInfoCollectNew_btn {
            float: right;
        }
    </style>
</head>
<body>
    <div style="padding-bottom:5px;margin:10px 0px 10px 15px;border-bottom:1px solid #000;width:95%;">
        <table style="width:100%;">
            <tr>
                <td style="width:40%">分公司：<span id="info_colle_list_latn_name"></span></td>
                <td style="">区县：<span id="info_colle_list_bureau_name"></span></td>
            </tr>
            <tr>
                <td style="width:40%">支局：<span id="info_colle_list_sub_name"></span></td>
                <td style="">网格：<span id="info_colle_list_grid_name"></span></td>
            </tr>
        </table>
    </div>
    <div class="village_new_searchbar" style="margin:0px 15px;width:95%;">
        <div class="count_num">记录数：<span id="info_collect_count"></span></div>
        <button id="toInfoCollectNew_btn">新&nbsp;建</button>
    </div>
    </div>
    <div class="village_m_tab">
        <table class="content_table">
            <tr>
                <th width="40">序号</th>
                <th width="80">客户名称</th>
                <th width="80">联系电话</th>
                <th width="290">详细地址</th>
                <th width="50">运营商</th>
                <th width="">到期时间</th>
            </tr>
        </table>
    </div>
    <div class="village_m_tab" style="margin-top:-1px;height:291px;overflow-x:hidden;overflow-y:auto;" id="info_collect_list_div">
        <table class="content_table" id="info_collect_list">
            <!-- <tr>latn_id bureau_no union_org_code grid_id
                <td>1</td>	<td><a href="javascript:toInfoCollectView('000102140000000042693721')">张家辉</a></td><td>1385421338</td><td>天水市清城区解放门3号1单元101</td><td>移动</td><td>2017年10月30日</td>
            </tr> -->
        </table>
    </div>
</body>
</html>
<script>
    var seq_um = 0;
    var infoColle_list_page = 0;
    var page = 0;
    var begin_scroll = "";

    var city_id = '${param.latn_id}';
    var area_id = '${param.bureau_no}';
    var substation = '${param.union_org_code}';
    var grid_id = '${param.grid_id}';

    var user_level = '${sessionScope.UserInfo.LEVEL}';

    $(function () {
        if (user_level == "" || user_level == undefined) {
            layer.msg("与服务器连接断开，请重新登录");
            return;
        }
        if (user_level == "1" || user_level == "2") {//省、市用户隐藏新建按钮
            $("#toInfoCollectNew_btn").hide();
        } else {
            $("#toInfoCollectNew_btn").show();
        }

        $("#toInfoCollectNew_btn").on("click", function () {
            parent.openWinInfoCollectEdit("", city_id, area_id, substation, grid_id);
        });

        setPosition();

        $("#info_collect_list_div").unbind();
        $("#info_collect_list_div").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();
            //alert(scrollTop / (contentH - viewH));

            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin_scroll > 500) {
                    infoColle_list_page++;
                    infoColleListScroll(city_id, area_id, substation, grid_id, infoColle_list_page);
                }
                begin_scroll = new Date().getTime();
            }
        });
        $("#info_collect_list").empty();
        infoColleListScroll(city_id, area_id, substation, grid_id, page);
        getColleListCount(city_id, area_id, substation, grid_id);
    });
    function toInfoCollectView(add6_id) {//TB_GIS_ADDR_other_ALL
        parent.openWinInfoCollectionView(add6_id, city_id, area_id, substation, grid_id);
    }

    function infoColleListScroll(city_id, area_id, substation, grid_id, page) {

        $.post(parent.url4Query, {
            "eaction": "getInfoCollectListByPage",
            "city_id": city_id,
            "area_id": area_id,
            "sub_id": substation,
            "grid_id": grid_id,
            "page": page
        }, function (data) {
            data = $.parseJSON(data);
            for (var i = 0, l = data.length; i < l; i++) {
                var d = data[i];
                var tr_str = "<tr>";
                tr_str += "<td style=\"width:40\">" + (++seq_um) + "</td><td style=\"width:80;\"><a href=\"javascript:toInfoCollectView('" + d.SEGM_ID_2 + "')\">" + d.CONTACT_PERSON + "</a></td><td style=\"width:65;\">" + d.CONTACT_NBR + "</td><td style=\"width:290;\">" + d.STAND_NAME_2 + "</td><td style=\"width:50;\">" + d.KD_BUSINESS_TEXT + "</td><td>" + d.KD_DQ_DATE + "</td>";
                tr_str += "</tr>";
                $("#info_collect_list").append(tr_str);
            }
        });
    }
    function getColleListCount(city_id, region_id, substation, grid_id) {
        $.post(parent.url4Query, {
            "eaction": "getInfoCollectListCount",
            "city_id": city_id,
            "area_id": area_id,
            "sub_id": substation,
            "grid_id": grid_id
        }, function (data) {
            data = $.parseJSON(data);
            $("#info_collect_count").text(data.COUNT);
        });
    }
    //获取位置
    function setPosition() {
        $.post(parent.url4Query, {
            "eaction": "getPosition",
            "city_id": city_id,
            "area_id": area_id,
            "sub_id": substation,
            "grid_id": grid_id
        }, function (data) {
            data = $.parseJSON(data);
            $("#info_colle_list_latn_name").text(data.LATN_NAME);
            $("#info_colle_list_bureau_name").text(data.BUREAU_NAME);
            $("#info_colle_list_sub_name").text(data.BRANCH_NAME);
            $("#info_colle_list_grid_name").text(data.GRID_NAME);
        });
    }

</script>