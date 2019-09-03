<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4l var="scene_list">
	select t.scenes_type_cd id,t.scenes_type_desc text from gis_data.TB_DIC_GIS_SCENES_TYPE t where t.scenes_type_cd in('04','21','10','11')	order by t.priority asc
</e:q4l>
<html>
<head>
	<title>收集统计</title>
	<meta charset="utf-8">
	<meta name="author" content="jasmine"><!-- 定义作者-->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.0"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/common/css/info_collect.css?version=0.1"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all"/>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
	<style type="text/css">
		body{background-color:#fff;}
	</style>
</head>
<body>
	<div class="tab_box" style="margin-left:0px;overflow:auto;">
		<div style="padding:10px 0;margin:0 0 10px 15px;border-bottom:1px solid #000;width:95.4%;">
			<h3 class="wrap_a" style="margin-top:0px;margin-bottom:0px;padding-left:10px;color:#109afb;">查询条件</h3>
            <table style="width:95%;">
                <tr>
                    <td style="width:50%;padding-left:10px;">
                        <span>分公司：</span>
                        <select id="b_city" class="list_select" style="width: 70%;margin-left:13px">
                            <option value="">全部</option>
                        </select>
                    </td>
                    <td style="width:50%;padding-left:10%;">
                        <span>区县：</span>
                        <select id="b_area" class="list_select" style="width: 70%;margin-left:13px">
                            <option value="">全部</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="width:50%;padding-left:10px;">
                        <span>支&nbsp;&nbsp;&nbsp;&nbsp;局：</span>
                        <select id="b_branch" class="list_select" style="width: 70%;margin-left:13px">
                            <option value="">全部</option>
                        </select>
                    </td>
                    <td style="width:50%;padding-left:10%;">
                        <span>网格：</span>
                        <select id="b_grid" class="list_select" style="width: 70%;margin-left:13px">
                            <option value="">全部</option>
                        </select>
                    </td>
                </tr>
            </table>
		</div>
		
		<div class="village_m_tab">
		    <table class="content_table">
		        <tr>
		            <th width="40" >序号</th>
		            <th width="60" >分公司</th>
		            <th width="80" >区县</th>
		            <th width="180" >支局</th>
		            <th width="180" >网格</th>
		            <th width="100" >收集数量</th>
		        </tr>
		    </table>
		</div>
		<div class="village_m_tab" style="margin-top:-1px;height:291px;overflow-x:hidden;overflow-y:auto;" id="info_collect_summary_div">
		    <table class="content_table" id="info_collect_summary">
		    </table>
		</div>
	</div>
</body>
</html>
<script>
	var seq_um = 0;
    var infoColle_summary_page = 0;
    var page = 0;
    var begin_scroll = "";
	
	var city_id = parent.city_id;
	var baseFullOptions = "<option  value=''>全部</option>";
	
	var area_id = "${sessionScope.UserInfo.CITY_NO}";	
	var substation = "${sessionScope.UserInfo.TOWN_NO}";
	var grid_id = "${sessionScope.UserInfo.GRID_NO}";
	
	var user_level = '${sessionScope.UserInfo.LEVEL}';
	
	$(function(){
		setCitys_build($("#b_city"), $("#b_area"), $("#b_branch"), $("#b_grid"));
		
		$("#info_collect_summary_div").unbind();
        $("#info_collect_summary_div").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();
            //alert(scrollTop / (contentH - viewH));

            if (scrollTop / (contentH - viewH) >= 0.95) {

                if (new Date().getTime() - begin_scroll > 500) {
                    infoColle_summary_page++;
                    infoColleSummaryQuery(infoColle_summary_page);
                }
                begin_scroll = new Date().getTime();
            }
        });
        $("#info_collect_list").empty();
        infoColleSummaryQuery(0);
        getColleSummaryCountQuery();
    });
	function toInfoCollectList(latn_id, bureau_no, union_org_code, grid_id){
		parent.openWinInfoCollectionList(latn_id, bureau_no, union_org_code, grid_id);
	}
	
	////楼宇查询
    function setCitys_build(b_city, b_area, b_sub, b_grid) {
        $.post(parent.url4Query, {eaction: 'setcitys'}, function (data) {
            data = $.parseJSON(data);
            var str = ''
            b_city.unbind();
            b_city.on("change", function () {
                city_id = b_city.find(":selected").val();
                b_area.html(baseFullOptions);
                b_sub.html(baseFullOptions);
                b_grid.html(baseFullOptions);
                $("#info_collect_summary").empty();
                infoColleSummaryQuery(0);
                getColleSummaryCountQuery();
                setArea_build(city_id, b_area, b_sub, b_grid);
            })
            $.each(data, function (i, d) {
                str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>";
            })
            b_city.html(baseFullOptions);
            b_city.append(str);
            b_city.find("option[value=" + city_id + "]").attr("selected", "selected");
            if (user_level == 2 || user_level == 4 || user_level == 5) {//支局用户
                b_city.attr("disabled", "disabled");
            }
            setArea_build(city_id, b_area, b_sub, b_grid)
        })
    }

    function setArea_build(latn_id, b_area, b_sub, b_grid) {
        $.post(parent.url4Query, {eaction: "setareas", latn_id: latn_id}, function (data) {
            data = $.parseJSON(data)
            b_area.unbind();
            if (user_level == 1 || user_level == 2) {
                b_area.on("change", function () {
                    b_sub.html(baseFullOptions);
                    b_grid.html(baseFullOptions);
                    var area_id = b_area.find(":selected").val();
                    $("#info_collect_summary").empty();
                    infoColleSummaryQuery(0);
                    getColleSummaryCountQuery();
                    setBranchs_build(area_id, b_sub, b_grid);
                });
            }

            var str = '';
            $.each(data, function (i, d) {
                str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>";
            })
            b_area.html(baseFullOptions);
            b_area.append(str);
            if (user_level == 4 || user_level == 5) {//支局用户
                b_area.attr("disabled", "disabled");
                b_area.empty().append("<option value=\"" + '${sessionScope.UserInfo.CITY_NO}' + "\">" + '${sessionScope.UserInfo.CITY_NAME}' + "</option>");
            }
            setBranchs_build(null, b_sub, b_grid);
        })
    }

    function setBranchs_build(area_id, b_sub, b_grid) {

        $.post(parent.url4Query, {eaction: "setbranchs", id: area_id, latn_id: city_id}, function (data) {
            data = $.parseJSON(data)
            b_sub.unbind();
            if (user_level == 1 || user_level == 2) {
                b_sub.on("change", function () {
                    var sub_id = b_sub.find(":selected").val();
                    b_grid.html(baseFullOptions);
                    $("#info_collect_summary").empty();
                    infoColleSummaryQuery(0);
                    getColleSummaryCountQuery();
                    setGrids_build(sub_id, b_grid);
                })
            }
            ;
            var str = '';
            $.each(data, function (i, d) {
                str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>";
            })
            b_sub.html(baseFullOptions);
            b_sub.append(str);
            if (user_level == 4 || user_level == 5) {//支局用户
                b_sub.attr("disabled", "disabled");
                b_sub.empty().append("<option value=\"" + '${sessionScope.UserInfo.TOWN_NO}' + "\">" + '${sessionScope.UserInfo.SUB_NAME}' + "</option>");
            }
            if (user_level == 1 || user_level == 2)
                setGrids_build(null, b_grid);
            else if (user_level == 4 || user_level == 5)
                setGrids_build(substation, b_grid);
        })
    }

    function setGrids_build(sub_id, b_grid) {
        var bureau_no = $("#b_area option:selected").val();
        $.post(parent.url4Query, {
            eaction: "setgrids",
            id: sub_id,
            latn_id: city_id,
            bureau_no: bureau_no
        }, function (data) {
            data = $.parseJSON(data);
            b_grid.unbind();
            b_grid.on("change", function () {
                $("#info_collect_summary").empty();
                infoColleSummaryQuery(0);
                getColleSummaryCountQuery();
            })
            var str = '';
            $.each(data, function (i, d) {
                str += "<option value='" + d.GRID_ID + "' value1='" + d.STATION_ID + "' value2='" + d.GRID_ZOOM + "'>" + d.GRID_NAME + "</option>";
            })
            b_grid.html(baseFullOptions);
            b_grid.append(str);
            if (user_level == 5) {
                b_grid.empty().append("<option value=\"" + ('${sessionScope.UserInfo.GRID_NO}') + "\">" + '${sessionScope.UserInfo.GRID_NAME}' + "</option>");
                b_grid.attr("disabled", "disabled");
            }
        })
    }

    function infoColleSummaryQuery(page) {
        if (user_level == 1 || user_level == 2) {
            area_id = $("#b_area option:selected").val();
            substation = $("#b_branch option:selected").val();
            grid_id = $("#b_grid option:selected").val();
        } else if (user_level == 4) {
            grid_id = $("#b_grid option:selected").val();
        }

        infoColleSummaryScroll(city_id, area_id, substation, grid_id, page);
    }

    //数量查询 暂时用不到
    function getColleSummaryCountQuery() {
        if (user_level == 1 || user_level == 2) {
            area_id = $("#b_area option:selected").val();
            substation = $("#b_branch option:selected").val();
            grid_id = $("#b_grid option:selected").val();
        } else if (user_level == 4) {
            grid_id = $("#b_grid option:selected").val();
        }

        seq_um = 0;
        getColleSummaryCount(city_id, area_id, substation, grid_id);
    }
    function infoColleSummaryScroll(city_id, area_id, substation, grid_id, page) {
        var info_collect_summary = $("#info_collect_summary");
        $.post(parent.url4Query, {
            "eaction": "getInfoColleSummaryByPage",
            "city_id": city_id,
            "area_id": area_id,
            "sub_id": substation,
            "grid_id": grid_id,
            "page": page,
            "level": user_level
        }, function (data) {
            data = $.parseJSON(data);
            if (data.length > 0) {
                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    var tr_str = "<tr><td width=\"40\">" + (++seq_um) + "</td><td width=\"60\">" + d.LATN_NAME + "</td><td width=\"80\">" + d.BUREAU_NAME + "</td><td width=\"180\">" + d.BRANCH_NAME + "</td><td width=\"180\">" + d.GRID_NAME + "</td><td width=\"100\"><a href=\"javascript:toInfoCollectList('" + d.LATN_ID + "','" + d.BUREAU_NO + "','" + d.UNION_ORG_CODE + "','" + d.GRID_ID + "')\">" + d.NUM + "</a></td></tr>";
                    info_collect_summary.append(tr_str);
                }
            } else {
                if (seq_um == 0) {
                    var tr_str = "<tr><td colspan=6>暂无数据</td></tr>";
                    info_collect_summary.append(tr_str);
                }
            }
        });
    }

    //数量查询 暂时用不到
    function getColleSummaryCount(city_id, region_id, substation, grid_id) {
        /*$.post(parent.url4Query,{"eaction":"getInfoCollectListCount","city_id":city_id,"area_id":area_id,"sub_id":substation,"grid_id":grid_id},function(data){
         data = $.parseJSON(data);
         $("#info_collect_count").text(data.COUNT);
         });*/
    }
 
</script>