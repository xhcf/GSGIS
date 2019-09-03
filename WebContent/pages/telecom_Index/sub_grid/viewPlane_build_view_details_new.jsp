<%--
  Created by IntelliJ IDEA.
  User: xuezhang
  Date: 17/6/21
  Time: 下午6:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>
<e:q4l var="scene_list">
	select t.scenes_type_cd id,t.scenes_type_desc text from gis_data.TB_DIC_GIS_SCENES_TYPE t where t.scenes_type_cd in('04','21','10','11')	order by t.priority asc
</e:q4l>
<e:q4l var="grid_list">
  SELECT '-1' CODE, '全部' TEXT FROM DUAL UNION ALL
  SELECT GRID_ID CODE,GRID_NAME TEXT FROM gis_data.db_cde_grid
  where UNION_ORG_CODE = '${param.substation }'
  and grid_status = 1 AND GRID_UNION_ORG_CODE <> '-1'
</e:q4l>
<e:q4o var="v_id">
    SELECT village_id id FROM ${gis_user}.tb_gis_village_addr4 WHERE segm_id = '${param.res_id}'
</e:q4o>
<html>
<head>
	<title>楼宇视图</title>
	<meta charset="utf-8">
	<meta name="author" content="jasmine"><!-- 定义作者-->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.0"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.8"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_info_collect_edit_diy_new.css?version=1.2.1"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_level.css?version=1.2.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.5"/>' rel="stylesheet" type="text/css"
          media="all"/>
	<!-- 加载竞争收集js -->
	<style type="text/css">
		body{background-color:#fff;}

		.wrap_a {margin:0px 5px 0px 5px;}
		#info_edit .wrap_a {margin:0px 5px 0px 10px;}
		.yin {height:auto;}
		.base {padding:0px 15px;}

		.combo-panel{z-index:99999}
		.product_type.village_new_searchbar.build_bar{margin:0 1.5%;width:95%;}
		#cell_num {font-size:12px;line-height:14px;margin-top:8px;margin-left:20px;}
		#yx_num {font-size:12px;line-height:14px;margin-top:8px;margin-left:20px;}
		.village_new_base .deve_ta {height:92%;padding-top:3%;}
		.village_new_base .deve_tb {height:92%;padding-top:1%;}



		@media screen and (min-width:1120px) and  (max-width:1345px){
		.village_new_base .deve_ta {margin-left: 0px;height:75%;margin-bottom:8px;margin-top:3px;padding-top:36px;font-size:16px;}
		.village_new_base .deve_tb {height:75%;margin-bottom:8px;margin-top:3px;width:85.8%;padding-top:1.5%;font-size:16px;}

		}
		@media screen and  (min-width:940px) and (max-width:958px){
		.village_new_base .deve_ta {margin-left: 0px;height:78px;margin-bottom:8px;margin-top:2px;padding-top:26px;}
		.village_new_base .deve_tb {height:78px;margin-bottom:8px;margin-top:2px;width:85.8%;padding-top:26px;}


		}
		@media screen and (max-width:815px) {
	    .village_new_base .deve_ta {margin-left: 0px;height:65px;margin-bottom:8px;margin-top:2px;padding-top:24px;}
		.village_new_base .deve_tb {height:65px;margin-bottom:8px;margin-top:2px;width:84%;padding-top:0;}

        }
		.yingxiaochangjing_table tr{border-top: 1px dotted #a7a7a7;}
		.yingxiaochangjing_table tr:first-child{border-top:none }
        .active {background: none;}

        .manufactuer_mobile,.manufactuer_unicom,.manufactuer_sarft,.manufactuer_others{
            background-color:#FF0000!important;
        }
        /*.other_ico{background-image:url('image/other_ico.png')}
        .none_ico{background-image:url('image/none_ico.png')}*/
        #collect_new_table_content, collect_new_table_content1 {
            height: 253px;
        }

		.head_table tr td:nth-child(5) {width:100px!important;}

        #collect_new_table_content, collect_new_table_content1 {
            height: 70%;
        }
		ul.build_detail {width:100%;}
		#ly_detail_tab tr th:first-child {width:5%;}
		#ly_detail_tab tr th:nth-child(2) {width:7%;}
		#ly_detail_tab tr th:nth-child(3) {width:11%;}
		#ly_detail_tab tr th:nth-child(4) {width:13%;}
		#ly_detail_tab tr th:nth-child(5) {width:15%;}
		#ly_detail_tab tr th:nth-child(6) {width:15%;}
		#ly_detail_tab tr th:nth-child(7) {width:15%;}
		#ly_detail_tab tr th:nth-child(8) {width:10%;}
		#ly_detail_tab tr th:nth-child(9) {width:9%;}

		#collect_new_bulid_info_list tr td:first-child {width:5%;}
		#collect_new_bulid_info_list tr td:nth-child(2) {width:7%;}
		#collect_new_bulid_info_list tr td:nth-child(3) {width:11%;}
		#collect_new_bulid_info_list tr td:nth-child(4) {width:13%;}
		#collect_new_bulid_info_list tr td:nth-child(5) {width:15%;}
		#collect_new_bulid_info_list tr td:nth-child(6) {width:15%;}
		#collect_new_bulid_info_list tr td:nth-child(7) {width:15%;}
		#collect_new_bulid_info_list tr td:nth-child(8) {width:10%;}
		#collect_new_bulid_info_list tr td:nth-child(9) {width:9%;}
        .red_font {color:red;}

        .btn {
            height: 22px;
            width: 56px;
            border-radius: 2px;
            border: 1px solid #74b9e1;
            line-height: 16px;
            font-size: 12px;
            color: #fff;
        }
        .grey_btn {background: #aaa;}
        .blue_btn {background: #2ea5e9;}
        #putIntoVillage {float:right;margin-right:3.5%;width:70px;display:none;}

        .full_width {width:100%;height:50%;text-align:center;padding:0 8px;}
        #putInto_Add4,#putInto_Village {font-weight:bold;}
	</style>
</head>
<body>

<div class="village_name_new"><span id="village_view_title" class="cate"> </span></div>
    <h3 class="wrap_a tab_menu" style="border-left:none;padding-left:15px;">
        <span style="cursor:pointer;" class="selected">基本信息</span>&nbsp;|&nbsp;
        <span style="cursor:pointer;">住户视图</span>&nbsp;|&nbsp;
        <span style="cursor:pointer;">住户详表</span><!--&nbsp;|&nbsp;-->
        <span style="cursor:pointer;display:none;">住户清单</span><!--&nbsp;|&nbsp;-->
        <span style="cursor:pointer;display:none;">OBD清单</span><!--&nbsp;|&nbsp;-->
        <span style="cursor:pointer;display:none;">营销清单</span><!--&nbsp;|&nbsp;-->
        <span style="cursor:pointer;display:none;">收集清单</span><!--&nbsp;|&nbsp;-->
        <span style="cursor:pointer;display:none;">异常用户</span>
        <e:if condition="${(sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5') && empty sessionScope.UserInfo.SCHOOL_PERMISSIONS}">
            <button id="putIntoVillage" class="btn blue_btn">调整小区</button>
        </e:if>
    </h3>
    <div class="product_type village_new_searchbar build_bar">
      <span>运营商：</span>
      <input type="checkbox" name="product_type" id="bussiness_all" value="-1" /><label for="bussiness_all">全部</label>
      <input type="checkbox" name="product_type" id="bussiness_dx" value="5" /><label for="bussiness_dx">电信</label>
      <input type="checkbox" name="product_type" id="bussiness_yd" value="1" /><label for="bussiness_yd">移动</label>
      <input type="checkbox" name="product_type" id="bussiness_lt" value="2" /><label for="bussiness_lt">联通</label>
      <input type="checkbox" name="product_type" id="bussiness_gd" value="3" /><label for="bussiness_gd">广电</label>
      <input type="checkbox" name="product_type" id="bussiness_qt" value="4" /><label for="bussiness_qt">其他</label>
      <input type="checkbox" name="product_type" id="bussiness_unintall" value="0" /><label for="bussiness_unintall">未装</label>

        <div id="scene_type_radios" style="display:none;">营销场景：&nbsp;<c></c>
            <div id="did_flag_radios" style="display:none;margin-right:90px;">
            执行状态：
            <input type="radio" name="did_flag" value="" checked="checked" >全部
            <input type="radio" name="did_flag" value="1" >已执行
            <input type="radio" name="did_flag" value="0" >未执行
          </div>
        </div>
      <!--<b class="yx_changjing_type selected" value="0">全部</b><b class="yx_changjing_type" value="1">宽带</b><b class="yx_changjing_type" value="2" > 电视</b><b class="yx_changjing_type" value="3">固话</b> -->

      <div>
          <span style="margin-left:0px;">四级地址：</span>
          <select id="fouraddress" name="fouraddress" style="width:320px;"></select>
      </div>
    </div>
    <div id="cell_num" class="count_num">记录数：<span></span></div>
    <div id="yx_num" class="count_num">记录数：<span></span></div>
    <div class="detail_block tab_box building_list_tab cell_layout" style="margin-top:8px;">
        <!-- 基本信息 -->
        <div style="width:100%;padding: 0px;margin:0px;overflow:hidden;">
            <div class="devep village_new_base">
                <div class="deve_ta">
                        基础
                </div>
                <div class="deve_tb" style="padding-top:1.3%;">
                    <table border="0" width="100%">
                        <tr>
                            <td width="40%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">支&nbsp;&nbsp;&nbsp;局：<span id="build_view_sub"></span></span></div></td>
                            <td width="50%"><div class="quota"><span>网格：<span id="build_view_grid"></span></span></div></td>
                        </tr>
                        <tr>
                            <td><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">小&nbsp;&nbsp;&nbsp;区：<span id="build_view_village_name"></span></span></div></td>
                            <td><div class="quota"><!--<span>挂测时间：<span id="build_view_gua_ce_time"
                                                                    style="line-height: 24px"></span></span>--></div></td>
                        </tr>
                    </table>
                </div>
                <div class="deve_ta">
                        市场
                </div>
                <div class="deve_tb">
                    <table border="0" width="100%">
                        <tr>
                            <td width="19%" rowspan="2"><!-- 30 -->
                                <div class="quota"><span style="color: #9ebaf1">•</span><span
                                        style="margin-left: 5px;">宽带家庭渗透率：<span id="build_view_market_lv"
                                                                                style="color:#FF9214;font-weight:bold!important;"></span></span>
                                </div>
                            </td>
                            <td width="20%">
                                <div class="quota"><span style="margin-left: 10px">住户数：<span
                                        id="build_view_zhu_hu"></span></span></div>
                            </td>
                            <td width="25%">
                                <div class="quota"><span style="margin-left: 10px">政企住户：<span
                                        id="build_view_gov_zhu_hu"></span></span></div>

                            </td>
                            <!--<td width="25%">
                                <div class="quota"><span style="margin-left: 10px">楼宇数：<span
                                        id="build_view_build_count"></span></span></div>

                            </td>-->
                        </tr>
                        <tr>
                            <td><div class="quota"><span style="margin-left: 10px">光宽用户：<span
                                    id="build_view_gz_h_use"></span></span></div></td>
                            <td> <div class="quota"><span style="margin-left: 10px">政企光宽：<span
                                    id="build_view_gov_h_use"></span></span></div></td>
                            <!--<td><div class="quota"><span style="margin-left: 10px">未到达楼宇数：<span
                                    id="build_view_unreach_build"></span></span></div></td>-->
                        </tr>
                    </table>
                </div>
                <div class="deve_ta">
                        资源
                </div>
                <div class="deve_tb">
                    <table border="0" width="100%">
                        <tr>
                            <td width="30%" rowspan="2">
                                <div class="quota"><span style="color: #9ebaf1">•</span><span
                                        style="margin-left: 5px;">端口占用率：<span id="build_view_port_lv"
                                                                              style="color:#FF9214;font-weight:bold!important;"></span></span>
                                </div>
                            </td>
                            <td width="20%">
                                <div class="quota"><span style="margin-left: 10px">总端口：<span
                                        id="build_view_port_sum"></span></span></div>

                            </td>
                            <td width="25%">
                                <div class="quota"><span style="margin-left: 10px">OBD设备：<span
                                        id="build_view_obd"></span></span></div>

                            </td>
                            <td width="25%">
                                <div class="quota"><span style="margin-left: 10px">0-1OBD：<span
                                        id="build_view_obd01"></span></span></div>
                            </td>
                        </tr>
                        <tr>
                            <td><div class="quota"><span style="margin-left: 10px">空闲端口：<span
                                    id="build_view_free_port"></span></span></div></td>
                            <td><div class="quota"><span style="margin-left: 10px">高占用OBD：<span
                                    id="build_view_hobd"></span></span></div></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="deve_ta">
                        竞争
                </div>
                <div class="deve_tb" >
                    <table border="0" width="100%">
                        <tr>
                            <td width="19%" rowspan="2">
                                <div class="quota"><span style="color: #9ebaf1">•</span><span
                                        style="margin-left: 5px;">收集率：<span id="build_view_collect_lv"
                                                                              style="color:#FF9214;font-weight:bold!important;"></span></span>
                                </div>
                            </td>
                            <td width="20%">
                                <div class="quota"><span style="margin-left: 10px">应收集住户：<span
                                        id="build_view_collect_sum"></span></span></div>

                            </td>
                            <td width="25%">
                                <div class="quota"><span style="margin-left: 10px">待收集：<span
                                        id="build_view_uncollect"></span></span></div>

                            </td>
                        </tr>
                        <tr>
                            <td><div class="quota"><span style="margin-left: 10px">本月提升：<span
                                    id="build_view_up_this_month"></span></span></div></td>
                            <td><div class="quota"><span style="margin-left: 10px">已收集：<span
                                    id="build_view_collected"></span></span></div></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <!-- 住户视图 -->
        <div style="display:none;width:100%;padding: 0px;margin:0px;height:70%!important;">
            <ul class="build_detail" id="bmt">

            </ul>
        </div>
        <!-- 住户详表 -->
        <div style="display:none;width:100%;padding: 0px;margin:0px;overflow:hidden;">
            <div id="collect_new_body">
                <div class="collect_new_state_wrapper">
                    <div id="collect_bselect" class="tab_accuracy_head follow_head small_padding">
                        运营商:<span class="active" onclick="select_collect_band(-1)">全部<span id="collect_new_a_count"></span></span>
                        <span onclick="select_collect_band(5)"> 电信<span id="collect_new_d_count1"></span></span>
                        <span onclick="select_collect_band(1)"> 移动<span id="collect_new_y_count1"></span></span>
                        <span onclick="select_collect_band(2)"> 联通<span id="collect_new_l_count1"></span></span>
                        <span onclick="select_collect_band(3)"> 广电<span id="collect_new_g_count1"></span></span>
                        <span onclick="select_collect_band(4)"> 其他<span id="collect_new_q_count1"></span></span>
                        <span onclick="select_collect_band(0)"> 未装<span id="collect_new_n_count1"></span></span>
                    </div>

                    <div class="tab_accuracy_head follow_head small_padding" style="margin-left:25px;">
                        状态:<span class="active" onclick="select_collect_state('')">全部<span id="collect_new_all_status_count"></span></span>
                        <span onclick="select_collect_state(2)">已收集<span id="collect_new_collected_status_count"></span></span>
                        <span onclick="select_collect_state(1)">未收集<span id="collect_new_uncollect_status_count"></span></span>
                    </div>
                </div>
                <div>
                    <div class="head_table_wrapper">
                        <table class="head_table" id="ly_detail_tab">
                            <tr>
                                <th rowspan="2"></th>
                                <th>序号</th>
                                <th>房间号</th>
                                <th>联系人</th>
                                <th>联系电话</th>
                                <th>宽带运营商</th>
                                <th>宽带到期时间</th>
                                <!--<th style="width: 100px;" rowspan="2">营销场景</th>-->
                                <th>异网收集</th>
                                <th>状态</th>
                            </tr>
                        </table>
                    </div>
                    <div id="collect_new_table_content" class="t_table">
                        <table class="content_table" id="collect_new_bulid_info_list" style="width: 100%"></table>
                    </div>
                </div>
            </div>
        </div>

        <!-- 住户清单 -->
        <div id="zhuhuqingdan" style="display: none"></div>

        <!--OBD清单-->
        <div style="display:none;">
            <div class="tab_accuracy_head follow_head" style="font-weight: bold;padding-left:0;float: left;line-height: 36px;
                height: 36px;" id="collect_obd_state">
                使用状态：
                <span class="active" onclick="select_obd_state_build(this,'');" id="obd_quanbu">全部<span id="res_obd_all_count" ></span></span>
                <span onclick="select_obd_state_build(this,1);">0OBD<span id="res_0obd_count"></span></span>
                <span onclick="select_obd_state_build(this,2);">1OBD<span id="res_1obd_count"></span></span>
                <span onclick="select_obd_state_build(this,3);">高占用OBD<span id="res_hobd_count" ></span></span>
            </div>

            <span class="collect_contain_choice" style="margin-left:0;width: 38%;margin-right:0;display:none;" id="obd_new1_build_span">
                楼宇:
                <select id="collect_new_build_list4" name="collect_new_build_list4" onchange="load_build_info4(0)" style="width:100%;"></select>
                <input type="text" id="collect_new_build_name4" name="collect_new_build_name4" oninput="load_build_name_list4()" style="width:95%">
                <ul id="collect_new_build_name4_list">
                </ul>
            </span>

            <div class="div_hide div_obd_2">
                <%--<div class="grid_count_title">记录数:<span id="resource_obd_build_count"></span></div>--%>
                <div class="build_datagrid">
                    <div class="head_table_wrapper">
                        <table class="head_table">
                            <tr>
                                <th style="width: 40px;">序号</th>
                                <th style="width: 200px;">楼宇</th>
                                <th style="width: 100px;">设备编号</th>
                                <th style="width: 60px;">使用率</th>
                                <th style="width: 50px;">端口数</th>
                                <th style="width: 70px;">占用端口数</th>
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

        <!--营销清单-->
        <div id="ly_yx_content"  style="display:none;"></div>

        <!-- 收集清单 -->
        <div id="info_content" style="display:none;"></div>

        <!--异常用户-->
        <div id="ly_yhzt_content"  style="display:none;"></div>
    </div>

<!-- 跳到执行、执行历史、资料维护的页面-->
	<div class="build_info_win info_edit_win" id="cell_view_container" style="display:none;">
		<div class="titlea"><div id="detail_more_draggable" style='text-align:left;width:90%;display: inline-block;height: 30px;line-height: 30px'>营销执行</div><div  class="titlec" onclick="javascript:closeCellViewIFrame(0);"></div></div>
		<iframe width="100%" height="100%"></iframe>
	</div>

    <div id="putIntoVillagePopWin">
        <div class="full_width" style="padding-top:8%;"><span style="vertical-align:middle;">小区：</span><select id="villSelect"></select></div>
        <div class="full_width"><button id="putInto" class="btn blue_btn">调整</button>&nbsp;&nbsp;<button id="cancel" class="btn grey_btn">取消</button></div>
    </div>

    <div id="putIntoRequire">
        <div class="full_width" style="padding-top:8%;">确定将地址【<span id="putInto_Add4"></span>】<br/>调整入小区【<span id="putInto_Village"></span>】吗？</div>
        <div class="full_width"><button id="join" class="btn grey_btn">是</button>&nbsp;&nbsp;<button id="giveup" class="btn blue_btn">否</button></div>
    </div>
<script>
      var seq_num = 0, collect_state = 0, collect_bselect = -1;
      //需要在页面切换的时候 将值重置为 true;
      var is_first_time_load = true;
      //表示是否选中, 选中:点击input下拉框选中, select选中.
      var select_count = 0;
      var url = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_build_action.jsp' />";

      //做名字查询时使用
      var village_list = [];
      /*以下部分为联动===start*/
      function load_village_list() {
		  return;
          if('${sessionScope.UserInfo.LEVEL}'==1 || '${sessionScope.UserInfo.LEVEL}'==2)
            return;
          var $village_list =  $("#collect_new_village_list");
          $village_list.empty();
          village_list = [];
          var params = {
              eaction: "collect_new_village_list",
              grid_id: $("select[name=collect_new_grid_list]").val() == '-1' ? '' : $("select[name=collect_new_grid_list]").val(),
              substation: parent.substation
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
              var $village_list =  $("#collect_new_village_name_list");
              $village_list.empty();
              var village_name = $("#collect_new_village_name").val().trim();
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
                  $("#collect_new_village_name_list").show();
              } else {
                  $("#collect_new_village_name_list").hide();
              }
              //联动改变 select框, 只要不做点击, 都会将select改回全部.
              if (select_count < 1) {
                    $("#collect_new_village_list option:eq(0)").attr('selected','selected');
              }
              select_count++;
              load_build_list(false);
          }, 300)
      }

      function before_load_build_list() {
          //$("#collect_new_build_name").val("");
          clear_data();
          clear_has_selected();
          $("#collect_new_select_build").html("");
          $("#collect_new_a_count").html("(0)");
          $("#collect_new_d_count1").html("(0)");
          $("#collect_new_y_count1").html("(0)");
          $("#collect_new_l_count1").html("(0)");
          $("#collect_new_g_count1").html("(0)");
          $("#collect_new_q_count1").html("(0)");
          $("#collect_new_n_count1").html("(0)");
      }

      //做名字查询时使用, 数据库太慢
      var build_list = [];
      //flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.
      function load_build_list(selected) {
          if('${sessionScope.UserInfo.LEVEL}'==1 || '${sessionScope.UserInfo.LEVEL}'==2 || '${sessionScope.UserInfo.LEVEL}'==3)
              return;
          var $build_list =  $("#collect_new_build_list");
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
                    $("#collect_new_village_name").val($("#collect_new_village_list").find("option:selected").text());
              }
              var params = {
                      eaction: "collect_new_build_list",
                      grid_id: $("select[name=collect_new_grid_list]").val() == '-1' ? '' : $("select[name=collect_new_grid_list]").val(),
                      village_id: $("#collect_new_village_list").val() == '-1' ? '' : $("#collect_new_village_list").val(),
                      substation: parent.substation
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
                  }
                  if (is_first_time_load) {
                      $("#collect_new_build_list option[value=${param.res_id}]").attr("selected", "selected");
                      $("#collect_new_build_list").change();
                      is_first_time_load = false;
                  }
              })
          }
      }

      function load_build_name_list() {
          setTimeout(function() {
              //下拉列表显示
              var $build_list =  $("#collect_new_build_name_list");
              $build_list.empty();
              if (select_count <= 1) {
                  before_load_build_list();
              }

              var build_name = $("#collect_new_build_name").val().trim();
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
                  $("#collect_new_build_name_list").show();
              } else {
                  $("#collect_new_build_name_list").hide();
              }

              //联动改变 select框, 只要不做点击, 都会将select改回全部.
              $("#collect_new_build_list option:eq(0)").attr('selected','selected');
              select_count++;
          }, 300)
      }

      function select_village(name, id, index) {

          $("#collect_new_village_list option[value=" + id + "]").attr('selected','selected');
          $("#collect_new_village_name_list").hide();
          $("#collect_new_village_list").change();
      }

      function select_build(name, id, index) {
          $("#collect_new_build_list option[value=" + id + "]").attr('selected','selected');
          $("#collect_new_build_name_list").hide();
          $("#collect_new_build_list").change();
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
              res_id: $('#fouraddress').combobox("getValue")
          };
          $.post(url, params, function(data) {
              if (data != null && data.trim() != 'null') {
                  data = JSON.parse(data);
                  $("#collect_new_a_count").html("(" + data.A_COUNT + ")");
                  $("#collect_new_d_count1").html("(" + data.D_COUNT + ")");
                  $("#collect_new_y_count1").html("(" + data.Y_COUNT + ")");
                  $("#collect_new_l_count1").html("(" + data.L_COUNT + ")");
                  $("#collect_new_g_count1").html("(" + data.G_COUNT + ")");
                  $("#collect_new_q_count1").html("(" + data.Q_COUNT + ")");
                  $("#collect_new_n_count1").html("(" + data.N_COUNT + ")");

                  $("#collect_new_all_status_count").text("("+ data.A_COUNT +")");
                  $("#collect_new_collected_status_count").text("("+ data.ON_COUNT +")");
                  $("#collect_new_uncollect_status_count").text("("+ data.OFF_COUNT +")");
              } else {
                  $("#collect_new_a_count").html("(0)");
                  $("#collect_new_d_count1").html("(0)");
                  $("#collect_new_y_count1").html("(0)");
                  $("#collect_new_l_count1").html("(0)");
                  $("#collect_new_g_count1").html("(0)");
                  $("#collect_new_q_count1").html("(0)");
                  $("#collect_new_n_count1").html("(0)");

                  $("#collect_new_all_status_count").text("(0)");
                  $("#collect_new_collected_status_count").text("(0)");
                  $("#collect_new_uncollect_status_count").text("(0)");
              }
          })
      }

      var load_build_info = function (flag) {
          //选中文本回写进 input
          var text = $("#collect_new_build_list").find("option:selected").text();
          $("#collect_new_build_name").val(text);
          $("#collect_new_select_build").html(text);

          before_load_bulid_info(flag);
          load_build_count_info();

          var build_id = $('#fouraddress').combobox("getValue");
          var $build_list = $("#collect_new_bulid_info_list");
          if (build_id != "-1") {
              var params = {
                  eaction: "collect_new_build_info",
                  res_id: res_id,
                  collect_state: collect_state,
                  collect_bselect: collect_bselect,
                  acct_month:'${last_month.VAL}',
                  village_id:village_id
              };
              $.post(url, params, function(data) {
                  data = $.parseJSON(data);
                  for (var i = 0, l = data.length; i < l; i++) {
                      var d = data[i];
                      //var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
                      var newRow = "<tr><td class='buss_ico'>";
                      if(d.IS_DX>0)
                        //电信
                        newRow += "<span class='dx_ico'>&nbsp;</span>";
                      else if(d.KD_BUS_FLAG==0)
                        //未装
                          newRow += "<span class='none_ico'>&nbsp;</span>";
                      else if(d.KD_BUS_FLAG==1)
                      //移动
                          newRow += "<span class='yd_ico'>&nbsp;</span>";
                      else if(d.KD_BUS_FLAG==2)
                      //联通
                          newRow += "<span class='lt_ico'>&nbsp;</span>";
                      else if(d.KD_BUS_FLAG==3)
                      //广电
                          newRow += "<span class='gd_ico'>&nbsp;</span>";
                      else if(d.KD_BUS_FLAG==4)
                      //其他
                          newRow += "<span class='other_ico'>&nbsp;</span>";
                      //else if(d.KD_BUS_FLAG==5)
                      //电信
                      newRow += "</td>";
                      newRow += "<td>"+(i+1)+"</td>";
                      //if (d.IS_DX == '0') {
                          newRow += "<td style='text-align:center;' class='bold_blue'>";
                      if(d.SERIAL_NO==2){//政企
                          newRow += "<span class='zhengqi_flag'>政</span><a href='javascript:void(0);' onclick='parent.openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a>"
                      }else if(d.SERIAL_NO==1 || d.SERIAL_NO==4){//普通住户
                          newRow += "<a href='javascript:void(0);' onclick='parent.openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a>"
                      }
                      newRow += "</td>";
                      //} else {
                      //      newRow += "<td style='width: 100px' class='bold_blue'>" + d.SEGM_NAME_2 + "</td>";
                      //}
                      newRow += "<td>" + d.CONTACT_PERSON + "</td>"
                      +"<td class='num_blue'>" + d.CONTACT_NBR + "</td>";
                      if(d.KD_BUSINESS!='电信')
                        newRow += "<td class='buss_red'>" + d.KD_BUSINESS + "</td>";
                      else
                        newRow += "<td>" + d.KD_BUSINESS + "(<span class='red_font'>"+ d.IS_KD_DX +"</span>)</td>";

                      newRow += "<td>" + d.KD_DQ_DATE + "</td>"
                      //+"<td style='width: 100px;'>" + d.MKT_CONTENT + "</td>"
                      +"<td>" + d.COLLLECT_FLAG + "</td>";
                      newRow += "<td>"+ d.STOP_TYPE_NAME+"</td>";
                      newRow += "</tr>"
                      $build_list.append(newRow);
                  }
                  if (data.length == 0 && flag) {
                      $build_list.empty();
                      $build_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)' \">没有查询到数据</td></tr>")
                      return;
                  }
              })
          }
      }

      parent.collect_new_load_build_info = load_build_info;

      //清除已选中的样式, 一般需要在标签页切换时调用.
      function clear_has_selected() {
          $("#collect_bselect > span").removeClass("active");
          $("#collect_bselect > span").eq(0).addClass("active");
          $("#collect_new_collect_state > span").removeClass("active");
          $("#collect_new_collect_state > span").eq(0).addClass("active");
      }

      function clear_data() {
          collect_bselect = -1, seq_num = 0, collect_state = 0;
          $("#collect_new_bulid_info_list").empty();
      }

	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
	var clickChangeSingleTable='';
	var fun2 = "";
	var fun4 = "";
	var checkbox_length = $(".product_type").children("input:gt(0):lt(6)").length;
	var res_id = '${param.res_id}';
	var check_val_str = "";///产品类型已废弃
	var check_val_bussiness_str = "";
    var contains_dx = "0";
    var contains_uninstall = "0";
	var village_id = '${param.village_id}';
	var yx_id = '${param.yx_id}';
	var type = '${param.vis}';
	var tab_flag = '${param.tab_flag}';
	var scene_type = "0";
	var did_flag = "";
	var build_position = parent.global_position_build_view;

	var to_cell_view = function(add6,flag){
		//信息收集被竞争收集代替的修改
        editInfoCollectWin(add6);
        return;
        //以下暂废弃
		if(flag=="info"){
			$.post(parent.url4Query,{"eaction":"hasSavedInfoCollect","add6":add6},function(data){
				data = $.parseJSON(data);
				if(data<0){//信息被编辑过，则打开查看窗口，否则打开编辑窗口
					viewInfoCollectWin(add6);
				}else{
					editInfoCollectWin(add6);
				}
			});
		}else{
			$("#cell_view_container").show();
			$("#cell_view_container > iframe").attr("src","viewPlane_cell_view_details.jsp?add6="+add6+"&flag="+flag);
		}
	}

    var editInfoCollectWin = function(add6){
        parent.openNewWinInfoCollectEdit(add6);
    }
	var viewInfoCollectWin = function(add6){
		parent.openWinInfoCollectionView(add6);
	}

    function closeWinInfoCollectionEdit(){
        load_build_info();
    }

	var closeCellViewIFrame = function(flag){
		$("#cell_view_container").hide();
		$("#cell_view_container > iframe").empty();
		if(flag==1){
			getData(res_id);
			freshYX_list_tab(res_id,scene_type,did_flag);
		}
	}
	var selTbl = "";
	$(function(){
		$('#cell_view_container').draggable({ handle: $('#detail_more_draggable')});
		$(".product_type").children(":lt(15)").hide();
		$("#cell_num").hide();
		$("#yx_num").hide();
		$("#scene_type_radios").hide();

		//标签页切换事件
		var $div_li =$(".tab_menu span");
		$div_li.click(function(){
			$(this).addClass("selected")            //当前<li>元素高亮
					.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
			var index =  $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
			$("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
					.eq(index).show()   //显示 <li>元素对应的<div>元素
					.siblings().hide(); //隐藏其它几个同辈的<div>元素
			is_first_time_load = true;
			//楼宇视窗特殊处理，在基本信息页签，隐藏“产品分类、记录数”，其他页签则显示这两个
			if(index==0){//楼宇概况
				$("#scene_type_radios").hide();
				$("#did_flag_radios").hide();
				$(".product_type").children(":lt(15)").hide();
				$(".product_type").children(":eq(15)").css("margin-left","0px");
				$(".product_type").show();
				$("#cell_num").hide();
				$("#yx_num").hide();
				$("#fouraddress").parent().css({"float":"left"});
			}else if(index==1){//住户视图
				$("#scene_type_radios").hide();
				$("#did_flag_radios").hide();
				$(".product_type").children(":lt(15)").show();
				$(".product_type").children(":eq(15)").css("margin-left","50px");
				$(".product_type").show();
				$("#cell_num").show();
				$("#yx_num").hide();
				$("#fouraddress").parent().css({"float":"right"});
			}else if(index==2){//住户详表
				$("#scene_type_radios").hide();
				$("#did_flag_radios").hide();
				$(".product_type").children(":lt(15)").hide();
				$(".product_type").children(":eq(15)").css("margin-left","0");
				$(".product_type").hide();
				$("#cell_num").hide();
				$("#yx_num").hide();
				$("#fouraddress").parent().css({"float":"right"});
				$(".village_m_tab").parent().hide();
			}else if(index==3){//住户清单 已废弃
				$(".product_type").hide();
				//记录数屏蔽不显示
				$("#cell_num").hide();
                $("#zhuhuqingdan").load("<e:url value='/pages/telecom_Index/common/jsp/add6_tab_build.jsp' />?res_id=" + res_id);
			}else if(index==4){//OBD 已废弃

            }else if(index==5){//营销清单 已废弃
                $("#ly_yx_content").load('<e:url value="/pages/telecom_Index/common/jsp/ly_yx_content.jsp"/>?segm_code='+res_id);
            }else if(index==6){//收集清单 已废弃
                $("#info_content").load("<e:url value='/pages/telecom_Index/common/jsp/info_tab_build.jsp' />?res_id=" + res_id);
            }else if(index==7){//异常用户 已废弃
                $("#ly_yhzt_content").load('<e:url value="/pages/telecom_Index/common/jsp/ly_yhzt_content.jsp"/>?segm_code='+res_id);
            }
            selTbl = index;
		})

		var query_param = {"eaction": "yx_detail_query_list_four"};
		//从小区、营销、楼宇分别链接到此的入口处理
		if(village_id!="" && village_id!=undefined && village_id!="undefined"){//小区入口
			query_param.village_id = village_id;
		}else if(yx_id!="" && yx_id!=undefined && yx_id!="undefined"){//营销入口
			query_param.yx_id = yx_id;
		}else
			query_param.res_id = res_id;//楼宇入口

		//楼宇基本信息标签页
		queryBaseInfo(res_id);
		if(selTbl == 0 || selTbl == 1 || selTbl == 2){
			//四级地址下拉框
		    comboboxAddr4Init(query_param);
		}

		//住户视图，住户详表
		getData(res_id);

		//营销清单 场景查询条件 页面元素初始化
		var scene_list = '${e:java2json(scene_list.list)}';
		var scene_container = $("#scene_type_radios > c");
		scene_container.empty();
		scene_container.append("<input type=\"radio\" name=\"scene_type\" value=\"0\" checked=\"checked\" >全部");
		if(scene_list!=null && scene_list!="")
			scene_list = $.parseJSON(scene_list);
		for(var i = 0,l = scene_list.length;i<l;i++){
			var scene_item = scene_list[i];
			var item_str = "<input type=\"radio\" name=\"scene_type\" value=\""+scene_item.ID+"\" style=\"margin-left:15px;\" />"+scene_item.TEXT;
			scene_container.append(item_str);
		}
		//营销清单列表处理↓
		//freshYX_list_tab(res_id,scene_type,did_flag);

		//跳转到此页面需要定位到营销清单标签页时
		if(tab_flag==4){
			$(".tab_menu").find("span").eq(3).click();
		}

		//住户视图、住户详表 查询条件的响应
		//产品分类 全部
		$("#bussiness_all").click(function(){
			if($(this).is(":checked")){
				$(".product_type").children("input").each(function(index,dom){
					this.checked = true;
					check_val_bussiness_str = "";
                    contains_uninstall = "";
				});
			}else{
				$(".product_type").children("input").each(function(index,dom){
					this.checked = false;
					check_val_bussiness_str = "";
                    contains_uninstall = "";
				});
			}
			getData(res_id);
		});
		//产品分类 宽带 电视 固话
		$(".product_type").children("input:gt(0):lt(6)").each(function(index,element){
			$(this).click(function(){
				var checkNum = 0;
                contains_dx = "0";
                contains_uninstall = "0";

				var types_cks = $(".product_type").children("input:gt(0):lt(6)");
				check_val_bussiness_str = "";
				for(var i = 0,l = types_cks.length;i<l;i++){
					if($(types_cks[i]).is(":checked")){
                        if($(types_cks[i]).val()=='5')
                            contains_dx = "1";
                        else if($(types_cks[i]).val()=='0')
                            contains_uninstall = "1";
                        else
						    check_val_bussiness_str += $(types_cks[i]).val()+",";
						checkNum += 1;
					}
				}
				check_val_bussiness_str = check_val_bussiness_str.substr(0,check_val_bussiness_str.length-1);

				if(checkNum==checkbox_length){
					$("#bussiness_all")[0].checked = true;
				}else{
					$("#bussiness_all")[0].checked = false;
				}
				getData(res_id);
			});
		});

		//营销清单标签的查询条件的响应
		//场景选择
		$("input[name='scene_type']").live("click",(function(){
			scene_type = $(this).val();
			freshYX_list_tab(res_id,scene_type,did_flag);
		}));
		//执行状态选项
		$("input[name='did_flag']").click(function(){
			did_flag = $(this).val();
			freshYX_list_tab(res_id,scene_type,did_flag);
		});

		$("select[name=collect_new_grid_list]").change();

		$("#collect_bselect > span").each(function (index) {
			$(this).on("click", function () {
				$("#collect_new_collect_state > span").removeClass("active");
				$("#collect_new_collect_state > span").eq(0).addClass("active");
				$(this).addClass("active").siblings().removeClass("active");
			})
		});
		$("#collect_new_collect_state > span").each(function (index) {
			$(this).on("click", function () {
				$("#collect_bselect > span").removeClass("active");
				$("#collect_bselect > span").eq(0).addClass("active");
				$(this).addClass("active").siblings().removeClass("active");
			})
		});
        //第三个标签，住户详表
        load_build_info();

		//第二个标签页，住户清单

		//第三个标签页，OBD清单

		//第四个标签页，营销清单
		//$("#ly_yx_content").load('<e:url value="/pages/telecom_Index/common/jsp/ly_yx_content.jsp"/>?segm_code='+res_id);
		//第五个标签页，用户质态
		//$("#ly_yhzt_content").load('<e:url value="/pages/telecom_Index/common/jsp/ly_yhzt_content.jsp"/>?segm_code='+res_id);
		//第七个标签页，竞争收集
		//$("#info_content").load("<e:url value='/pages/telecom_Index/common/jsp/info_tab_build.jsp' />?res_id=" + res_id);

        $("#putIntoVillage").click(function(){
            showVillSelectPopWin();
        });
	})

      var default_opt = "<option value=''>请选择小区</option>";
    var pop_win_handler = "";
    var pop_win_require_handler = "";
    function showVillSelectPopWin(){
        $("#villSelect").empty();
        $("#villSelect").append(default_opt);
        $.post(url,{"eaction":"getVillBySegmId","res_id":res_id},function(data){
            var data = $.parseJSON(data);
            for(var i = 0,l = data.length;i<l;i++){
                var item = data[i];
                var opt = "<option value='"+item.CODE+"'>"+item.NAME+"</option>";
                $("#villSelect").append(opt);
            }
            if(village_id==undefined || village_id=="undefined" || village_id=='null'){
                village_id = '${v_id.ID}';
            }
            if(village_id!=null && village_id!='null')
                $("#villSelect option[value='"+village_id+"']").attr("selected","selected");

            pop_win_handler = layer.open({
                title: '小区选择',
                type: 1,
                shade: 0,
                area: ["350px", "200px"],
                content: $("#putIntoVillagePopWin"),
                skin: 'sub_summary_div',
                cancel: function (index) {
                }
            });

            //调整按钮
            $("#putInto").unbind();
            $("#putInto").click(function(){
                var v_id = $.trim($("#villSelect option:selected").val());
                if(v_id==""){
                    layer.msg("请选择小区");
                    return;
                }
                $("#putInto_Add4").text($("#village_view_title").text());//被归入小区的地址名称 20190226
                $("#putInto_Village").text($("#villSelect option:selected").text());
                closePutIntoVillagePopWin();
                pop_win_require_handler = layer.open({
                    title: '消息',
                    type: 1,
                    shade: 0,
                    area: ["350px", "200px"],
                    content: $("#putIntoRequire"),
                    skin: 'sub_summary_div',
                    cancel: function (index){
                    }
                });
                //“是” 按钮
                $("#join").unbind();
                $("#join").click(function(){
                    closePutIntoVillageReqPopWin();
                    db_buildJoinVillage();
                });
                //“否” 按钮
                $("#giveup").unbind();
                $("#giveup").click(function(){
                    closePutIntoVillageReqPopWin();
                });
            });
            //取消按钮
            $("#cancel").unbind();
            $("#cancel").click(function(){
                closePutIntoVillagePopWin();
            });
        });
    }

    function closePutIntoVillagePopWin(){
      layer.close(pop_win_handler);
    }
    function closePutIntoVillageReqPopWin(){
      layer.close(pop_win_require_handler);
    }
    function db_buildJoinVillage(){
        var v_id = $("#villSelect option:selected").val();
        $.post(url,{"eaction":"buildJoinVillage","old_v_id":village_id,"v_id":v_id,"res_id":res_id,"latn_id":parent.city_id,"stand_name":$.trim($("#putInto_Add4").text())},function(data){
            var data = $.parseJSON(data);
            console.log(data);
            if(data>0){
                layer.msg("归入成功");
            }else{
                layer.msg("归入失败");
            }
        });
    }
	//楼宇基本信息
	function queryBaseInfo(res_id){
		$.post(url4Query,{eaction:'build_win',res_id:res_id,latn_id:parent.city_id},function(data){
      		var d=$.parseJSON(data);
			if(d==null) {
				layer.msg("暂无该楼宇信息")
			}
			else {
				$("#build_info_win").show();

				//$("#build_view_sub").text(build_sub_grid[0]==undefined?'--':build_sub_grid[0]);
				//$("#build_view_grid").text(build_sub_grid[1]==undefined?'--':build_sub_grid[1]);
				var latn_name = "";
				//if(build_position==""){
						latn_name = d.LATN_NAME;
						bureau_name = d.BUREAU_NAME;
						branch_name = d.BRANCH_NAME;
						grid_name = d.GRID_NAME;
                        build_position[3] = grid_name;
				/*}else{
						latn_name = build_position[0];
						bureau_name = build_position[1];
						branch_name = build_position[2];
						grid_name = build_position[3];
				}*/

				$("#build_view_latn_name").text(latn_name);

				$("#build_view_bureau_name").text(bureau_name);

				$("#build_view_sub").text(branch_name);

                getBranchType(d.UNION_ORG_CODE);

				$("#build_view_grid").text(grid_name);

				if(build_position==""){
					build_position = new Array();
					build_position[0] = latn_name;
					build_position[1] = bureau_name;
					build_position[2] = branch_name;
					build_position[3] = grid_name;
				}
				build_position[4] = d.VILLAGE_NAME;

				$("#build_view_village_name").text(d.VILLAGE_NAME);
				parent.global_position_build_view = build_position;

                //市场
                $("#build_view_market_lv").text(d.MARKET_RATE);
                $("#build_view_zhu_hu").text(d.ZHU_HU_COUNT);
                $("#build_view_gz_h_use").text(d.GZ_H_USE_CNT);
                $("#build_view_gov_zhu_hu").text(d.GOV_ZHU_HU_COUNT);
                $("#build_view_gov_h_use").text(d.GOV_H_USE_CNT);
                $("#build_view_build_count").text(d.LY_CNT);
                $("#build_view_unreach_build").text(d.NO_RES_ARRIVE_CNT);

                //资源
                $("#build_view_port_lv").text(d.PORT_LV);
                $("#build_view_port_sum").text(d.PORT_ID_CNT);
                $("#build_view_free_port").text(d.KONG_PORT_CNT);
                $("#build_view_obd").text(d.OBD_CNT);
                $("#build_view_hobd").text(d.HIGH_USE_OBD_CNT);
                $("#build_view_obd01").text(d.ZERO_OBD_CNT);

                //竞争
                $("#build_view_collect_lv").text(d.COLLECT_LV);
                $("#build_view_collect_sum").text(d.SHOULD_COLLECT_CNT);
                $("#build_view_up_this_month").text(d.FILTER_MON_RATE);
                $("#build_view_uncollect").text(d.UNCOLLECT);
                $("#build_view_collected").text(d.ALREADY_COLLECT_CNT);
			}
   		})
	}

    function getBranchType(union_org_code){
        $.post(url4Query,{"eaction":"getBranchType","union_org_code":union_org_code},function(data){
            var data = $.parseJSON(data);
            if(data.BRANCH_TYPE == '城市'){
                $("#putIntoVillage").show();
            }
        });
    }

	function comboboxAddr4Init(query_param){
		$.ajax({
			type: "post",
			url: url4Query,
			data: query_param,
			async: false,
			dataType: "json",
			success: function (data) {
				var arr = new Array();

				for (var i = 0; i < data.length; i++) {
					var obj = data[i];
					var obj_temp = "";
					if(obj.A1==res_id){
						$("#village_view_title").text(obj.A2);
						obj_temp = {text:obj.A2,value:obj.A1,"selected":true};
					}else
						obj_temp = {text:obj.A2,value:obj.A1};
					arr.push(obj_temp);
				}
				$("#fouraddress").combobox({
					data:arr,
					onSelect:function(){
						res_id = $("#fouraddress").combobox("getValue");
						getData(res_id);
						$("#village_view_title").text($("#fouraddress").combobox("getText"));
						queryBaseInfo(res_id);
					},
					filter: function(q, row){
						var opts = $(this).combobox('options');
						return row[opts.textField].indexOf(q) > -1;
					}
				});
			}
		});
	}
	//住户视图
	function sortBuilding(arr2) {
			arr2.sort(sortNumberOut);
			$.each(arr2,function (i,o) {
				arr2[i].sort(sortNumber);
			})
			function sortNumber(a,b) {
				return a.SEGM_NAME_2 - b.SEGM_NAME_2;
			}
			function sortNumberOut(a,b) {
				// 应该可以返回 a.SEGME_NAME_2-b.SEGME_NAME_2
				return a[0].SEGM_NAME_1.replace(/层/,'') - b[0].SEGM_NAME_1.replace(/层/,'');
			}
			return arr2;
	}
    function zhengqi_flag_ico(serial_no){
        var zqICO = "";
        if(serial_no==2){///政企
            zqICO += "<div class='zq_room_flag'>政</div>";
        }else if(serial_no==1 || serial_no==4){//普通住户
            zqICO += "<div class='normal_room_flag'></div>";
        }
        return zqICO;
    }
	function changeBussinessICO(d){
		//默认是电信用户
		var bussinessICO = "<div class=\"manufactuer_nothing\">";
		var bussiness_type = "未装";
		//有任意一个电信产品，则认为是电信用户
        //if(d.IS_KD>0 || d.IS_ITV>0 || d.IS_GU>0){
        if(d.IS_KD>0){
			bussinessICO = '<div class=\"manufactuer_telecom\">';
			bussiness_type = "电信";
		}else{//没有电信业务，则判断竞争信息收集
			//宽带运营商
			//if(d.KD_NBR!=null){
				if(d.KD_BUSINESS==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.KD_BUSINESS==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}else if(d.KD_BUSINESS==3){
					bussinessICO = '<div class=\"manufactuer_sarft\">';
					bussiness_type="广电";
				}else if(d.KD_BUSINESS==4){
					bussinessICO = '<div class=\"manufactuer_others\">';
					bussiness_type="其他";
				}
			//}else if(d.ITV_NBR!=null){//ITV运营商
				/*if(d.ITV_BUSINESS==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.ITV_BUSINESS==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}else if(d.ITV_BUSINESS==3){
					bussinessICO = '<div class=\"manufactuer_sarft\">';
					bussiness_type="广电";
				}else if(d.ITV_BUSINESS==4){
					bussinessICO = '<div class=\"manufactuer_others\">';
					bussiness_type="其他";
				}*/
			//}else if(d.PHONE_NBR!=null){//移动运营商 手机1
				/*if(d.PHONE_BUSINESS==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.PHONE_BUSINESS==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}*/
			//}else if(d.PHONE_NBR1!=null){//移动运营商 手机2
				/*if(d.PHONE_BUSINESS1==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.PHONE_BUSINESS1==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}*/
			//}else if(d.PHONE_NBR2!=null){//移动运营商 手机3
				/*if(d.PHONE_BUSINESS2==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.PHONE_BUSINESS2==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}*/
			//}
		}
		return bussinessICO+bussiness_type+"</div>";
	}
	//楼宇信息数据获取
	function getData(res_id){
		var table=$("#bmt")
		table.html("");
		$("#hhhsa").empty();
		$.post('<e:url value="villageAll.e"/>', {
			res_id: res_id,
            village_id: village_id,
			check_bussiness_val: check_val_bussiness_str,
            check_val:'',
            contains_dx: contains_dx,
            contains_uninstall: contains_uninstall
		}, function (data) {
			table.html("");
			$("#hhhsa").empty();
			data = $.parseJSON($.trim(data));

			//层数排序
			data = sortBuilding(data);
			var cell_num = 0;
			$.each(data,function (index, floor) {
				//高楼层到低楼层的排列,一次循环为一行
				var str=""
				var display=false;
				$.each(floor,function(i,d){
					cell_num++;
					var arr = getIconClass(d.IS_KD,d.IS_GU,d.IS_ITV);
					//if(type!=null&&type!=undefined){
						//if ((type=='kd'&&d.IS_KD>0)||(type=='itv'&&d.IS_ITV>0)||(type=='gu'&&d.IS_GU>0)||type=='all'){
							//if(!display)
							//clickChangeSingleTable(d.SEGM_ID_2);
							//	display=true;
                            var str1 = zhengqi_flag_ico(d.SERIAL_NO);
							var str2 = changeBussinessICO(d);
							var un=d.DX_CONTACT_PERSON;
							if(un==null || $.trim(un)=="")
								un = d.CMCC_CONTACT_PERSON;
							if(un==null || $.trim(un)=="")
								un = d.LT_CONTACT_PERSON;
							if(un==null || $.trim(un)=="")
								un = d.CONTACT_PERSON;
							if(un==null || $.trim(un)=="")
								un = "";

							un = (un.length>5?un.substr(0,5):un);
                            //脱敏
                            if(un.length>0)
                                un = un.substr(0,1) + "**";

							var nbr = d.DX_CONTACT_NBR;
							if(nbr==null || $.trim(nbr)=="")
								nbr = d.CMCC_CONTACT_NBR;
							if(nbr==null || $.trim(nbr)=="")
								nbr = d.LT_CONTACT_NBR;
							if(nbr==null || $.trim(nbr)=="")
								nbr = d.CONTACT_NBR;
							if(nbr==null || $.trim(nbr)=="")
								nbr = "";

							str+="<li> "+
                            str1+str2+
							"<h4><a href=\"javascript:void(0)\" onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','info')\">"+d.SEGM_NAME_2+"</a></h4><span>"+un+nbr+"</span> " +
							"<div class=\"icons\" style=\"display:table;padding-left:16%;\"><div style=\"width:28%;display:table-cell;\"><span class=\""+arr[0]+"\" style=\"float:left;\"></span><span style=\"float:left;line-height:22px;\">"+(d.IS_KD>1?d.IS_KD:'')+"</span></div><div style=\"width:28%;display:table-cell;\"><span class=\""+arr[2]+"\" style=\"float:left;\"></span><span style=\"float:left;line-height:22px;\">"+(d.IS_ITV>1?d.IS_ITV:'')+"</span></div><div style=\"width:28%;display:table-cell;\"><span class=\""+arr[1]+"\" style=\"float:left;\"></span><span style=\"float:left;line-height:22px;\">"+(d.IS_GU>1?d.IS_GU:'')+"</span></div></div> " +
							"<div class=\"bottom_info\"> ";
							if(d.IS_YX=='有')
								str += "<div class=\"market_info\"><a href=\"javascript:void(0)\" onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','exe')\"></a><span class=\"get\"></span></div> ";//营销派单
							else
								str += "<div class=\"market_info\"><span class=\"notget\"></span></div> ";//营销派单

							//其中一个不为空则资料收集为“有”，否则为“无”
                            //if(d.IS_KD>0)
                            //    str += "<div class=\"info_get\"><a href=\"javascript:void(0)\" style=\"color:#888;\">资料收集</a>";
                            //else
                            if(d.IS_KD==0)
							    str += "<div class=\"info_get\"><a href=\"javascript:void(0)\" onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','info')\">资料收集</a>";
                            else
                                str += "<div>";
							/*if(d.PEOPLE_COUNT1!=null || d.DX_COMMENTS!=null || d.PHONE_BUSINESS!=null ||
									d.PHONE_XF!=null || d.PHONE_DQ_DATE!=null || d.KD_COUNT!=null || d.KD_BUSINESS!=null ||
									d.KD_XF!=null || d.KD_DQ_DATE!=null || d.ITV_COUNT!=null || d.ITV_BUSINESS!=null ||
									d.ITV_XF!=null || d.ITV_DQ_DATE!=null)*/
							if(d.CONTACT_PERSON!=null || d.CONTACT_NBR!=null || d.PEOPLE_COUNT1!=null ||
									d.PHONE_NBR!=null || d.PHONE_NBR1!=null || d.PHONE_NBR2!=null ||
									d.KD_NBR!=null || d.ITV_NBR!=null
							)
								str += "<span class=\"info get\">";
							else
								str += "<span class=\"info notget\">";

							str += "</span></div>";
							str+="</div>";
							str+="</li>";
						//}
					//}

                    //20180711 废弃
					/*var hhhsa = $("#hhhsa");

					//房号
					var str_s = "<tr>";
					str_s += "<td>"+cell_num+"</td>";
					str_s += "<td><a href=\"javascript:void(0)\" class=\"show_edit\" onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','info')\">"+d.SEGM_NAME_2+"</a></td>" ;
					//联系人、联系电话
					if(d.DX_CONTACT_PERSON!=null && $.trim(d.DX_CONTACT_PERSON)!=""){
						str_s+= "<td><span class=\"yx_phone_num\">"+(d.DX_CONTACT_NBR==null?"-":d.DX_CONTACT_NBR)+"</span>"
							+d.DX_CONTACT_PERSON+"</td>";
					}else if(d.CMCC_CONTACT_PERSON!=null && $.trim(d.CMCC_CONTACT_PERSON)!=""){
						str_s+="<td><span class=\"yx_phone_num\">"+(d.CMCC_CONTACT_NBR==null?"-":d.CMCC_CONTACT_NBR)+"</span>"
							+d.CMCC_CONTACT_PERSON+"</td>";
					}else if(d.LT_CONTACT_PERSON!=null && $.trim(d.LT_CONTACT_PERSON)!=""){
						str_s+="<td><span class=\"yx_phone_num\">"+(d.LT_CONTACT_NBR==null?"-":d.LT_CONTACT_NBR)+"</span>"
							+d.LT_CONTACT_PERSON+"</td>";
					}else if(d.CONTACT_PERSON!=null && $.trim(d.CONTACT_PERSON)!=""){
						str_s+="<td><span class=\"yx_phone_num\">"+(d.CONTACT_NBR==null?"-":d.CONTACT_NBR)+"</span>"
							+d.CONTACT_PERSON+"</td>";
					}else{
						str_s+="<td></td>" ;
					}
					//住户数
					if(d.PEOPLE_COUNT==0)
						str_s += "<td></td>";
					else
						str_s += "<td>"+d.PEOPLE_COUNT+"</td>";

					//本网业务
					str_s += "<td>"+d.IS_KD_TEXT+"</td>";
					str_s += "<td>"+d.BROAD_MODE+"</td>";
					str_s += "<td>"+d.BROAD_RATE+"</td>";
					str_s += "<td>"+d.IS_ITV_TEXT+"</td>";
					str_s += "<td>"+d.GU_ACC_NBR+"</td>";
					str_s += "<td title=\""+d.MAIN_OFFER_NAME+"\">"+((d.MAIN_OFFER_NAME).length>18?(d.MAIN_OFFER_NAME).substr(0,18)+"...":d.MAIN_OFFER_NAME)+"</td>";

					//竞争
					str_s += "<td>"+d.OPERATORS_TYPE_TEXT+"</td>";//运营商
					str_s += "<td>"+d.COMMENTS+"</td>";//运营商备注

					//营销目标
					if(d.IS_YX=='有')
						str_s += "<td>有</td>";
						//str_s += "<td><a href=\"javascript:void(0)\" class=\"execution\"  onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','" + d.PROD_INST_ID + "','exe')\" >有</a></td>";
					else
						str_s += "<td></td>";

                    //
                    str_s += "</tr>";
					hhhsa.append(str_s);*/

				});
				str+="";
				//if(display){
					table.append(str);
				//}
			})
			$("#cell_num span").text(cell_num);
		})

	}

	//宽带 itv 固话 图标判断
	function getIconClass(brd,gh,itv) {
		var arr=[];
		arr[0]=brd>0?"broad active":"broad";
		arr[1]=gh>0?"tele active":"tele";
		arr[2]=itv>0?"itv active":"itv";
		return arr;
	}
	//利用js让头部与内容对应列宽度一致。
	/*function fix(){
	 for(var i=0;i<=$('.t_table .build_detail_in tr:last').find('td:last').index();i++){
	 $("#thead tr th").eq(i).css('width',$('.t_table .build_detail_in tr:last').find('td').eq(i).width());
	 }
	 }

	 window.onload=fix();
	 $(window).resize(function(){
	 return fix();
	 });*/

	 //加载表格
	function freshYX_list_tab(res_id, scene_type,did_flag) {
		var yx_changjing_type = 0;
		if (scene_type != undefined)
			yx_changjing_type = scene_type;//attr("value");
		//var segmname = $("#fouraddress").find("option:selected").text();
		var queryParam = {
            "eaction": "yx_detail_query_list_six",
            "segmid": res_id,
            "type": yx_changjing_type,
            "v_id":village_id,
            "yx_id":yx_id,
            "did_flag":did_flag
		};
		//查询清单列表，did_flag不传参是所有清单，1是已执行，0是未执行
		//freshBuildYxList(queryParam);
		//queryParam.did_flag = 1;
		//查询已执行列表
		//freshBuildYxList(queryParam);
	}
	function freshBuildYxList(queryParam){
		$.ajax({
			type: "post",
			url: url4Query,
			data: queryParam,
			async: false,
			dataType: "json",
			success: function (data) {

				var tb = document.getElementById('content_table_yx_list');
				//if(queryParam.did_flag==undefined){//未执行
				//	tb = document.getElementById('content_table_yx_list_un');
					//$(".tab_menu1 span").eq(0).text("未执行("+data.length+")");
				//	$("#yx_num span").text(data.length);
				//}
				//else{
				//	tb = document.getElementById('content_table_yx_list_done');
					//$(".tab_menu1 span").eq(1).text("已执行("+data.length+")");
				//}
				var rowNum = tb.rows.length;
				for (var i = 0; i < rowNum; i++) {
					tb.deleteRow(i);
					rowNum = rowNum - 1;
					i = i - 1;
				}

				if(data.length==0){
					for(var i = 0,l = 8;i<l;i++){
						$(tb).append("<tr><td width='5%'></td><td width=\"8%\"></td><td width=\"14%\"></td><td width=\"14%\"></td><td width=\"52%\"></td><td></td></tr>");
					}
				}

				//此处合并相同房号的营销信息
				var data_merge = new Array();
				for (var j = 0,k = data.length;j<k;j++){
					var d = data[j];
					var room_num = d.SEGM_NAME_2;
					var item = data_merge[room_num];
					if(item==undefined){//合并数组中没有该房号
						var item_arr = new Array();

						//需要合并的接入号
						var acc_nbr_arr = new Array();
						acc_nbr_arr.push(d.ACC_NBR);
						item_arr.ACC_NBR = acc_nbr_arr;
						//需要合并的营销推荐
						var yx_suggest = new Array();
						yx_suggest.push(d.CONN_STR);
						item_arr.CONN_STR = yx_suggest;
						//obj.CONTRACT_IPHONE+"<br/>"+obj.CONTACT_PERSON
						item_arr.ADDRESS_ID = d.ADDRESS_ID;
						item_arr.CONTACT_PERSON = d.CONTACT_PERSON;
						item_arr.CONTACT_IPHONE = d.CONTACT_IPHONE;

						item_arr.DID_FLAG= d.DID_FLAG;

						var prod_inst_id_arr = new Array();
						prod_inst_id_arr.push(d.PROD_INST_ID);
						item_arr.PROD_INST_ID = prod_inst_id_arr;

						item_arr.SEGM_ID = d.SEGM_ID;
						item_arr.SEGM_NAME_2 = d.SEGM_NAME_2;
						item_arr.STAND_NAME_2 = d.STAND_NAME_2;

						data_merge[room_num] = item_arr;
					}else{
						item.ACC_NBR.push(d.ACC_NBR);
						item.CONN_STR.push(d.CONN_STR);
						item.PROD_INST_ID.push(d.PROD_INST_ID);

						data_merge[room_num] = item_arr;
					}

				}

				//营销清单表格生成
				var keys = Object.keys(data_merge);
				$("#yx_num span").text(keys.length);
				for(var j = 0,k = keys.length;j<k;j++){
					var key = keys[j];

					var rowspan = data_merge[key].ACC_NBR.length;
					var obj = data_merge[key];
					var temp = "";
					temp += "<tr>";
					temp += "<td width=\"5%\" style=\"text-align:center;\">"+(j+1)+"</td>";

					temp += "<td width=\"8%\" rowspan=\"\">";
					temp += "<a href=\"javascript:void(0)\" class=\"execution\"  onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','info')\">"+obj.SEGM_NAME_2+"</a>";
					temp += "</td>";

					temp += "<td rowspan=\"\" width=\"14%\" style='text-align:center'>"+"<div style='color:#0681d8;font-weight: bold;font-size: 14px'>"+obj.CONTACT_IPHONE+"</div>"+obj.CONTACT_PERSON+"</td>";


					//接入号
					temp += "<td width=\"14%\" style=\"text-align:center;padding-top: 0px\">";
					var acc_nbr_arr = obj.ACC_NBR;
					var tr_temp = "<table style='height: 100%'>";
					for(var m = 0,n = acc_nbr_arr.length;m<n;m++){
						var acc_nbr = acc_nbr_arr[m];
						tr_temp += "<tr><td style='border: none'><span class=\"yx_phone_num1\">"+acc_nbr+"</span></td></tr>";
					}
					tr_temp += "</table>";
					temp += tr_temp + "</td>";

					//营销推荐
					temp += "<td width=\"52%\">";
					var conn_str = obj.CONN_STR;
					var tr_temp1 = "<table style='width: 100%' class='yingxiaochangjing_table'>";
					for(var m = 0,n = conn_str.length;m<n;m++){
						var yx_suggest = conn_str[m];
						tr_temp1 += "<tr><td style='border: none'>"+loadSuggest(yx_suggest,j,m)+"</td></tr>";
					}
					tr_temp1 += "</table>";
					temp += tr_temp1+"</td>";

					//执行、查看
					var did_flag = obj.DID_FLAG;
					if(did_flag==null)
						temp += "<td id='" + obj.PROD_INST_ID + "'><a href=\"javascript:void(0)\" class=\"execution\" onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','exe')\">执行</a></td>";
					else
						temp += "<td id='" + obj.PROD_INST_ID + "'><a href=\"javascript:void(0)\" class=\"execution\" onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','history')\">查看</a></td>";

					temp += "</tr>";

					$(tb).append(temp);
				}

				/*for (var j = 0,k = data.length;j<k; j++) {
					var obj = data[j];

					var temp = "";
					temp += "<tr>";
					temp += "<td width=\"5%\" style=\"text-align:center;\">"+(j+1)+"</td>";
					temp += "<td width=\"12%\">";
					temp += "<a href=\"javascript:void(0)\" class=\"execution\"  onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','info')\">"+obj.SEGM_NAME_2+"</a>";
					temp += "</td>";
					temp += " <td width=\"22%\" style=\"text-align:center;\">";
					temp += "<span class=\"yx_phone_num\">"+obj.ACC_NBR+"</span><br/>"+obj.CONTRACT_PERSON+"</td>";
					temp += "<td width=\"54%\">"+loadSuggest(obj.CONN_STR,j)+"</td>";
					if(obj.DID_FLAG!=null)
						temp += "<td id='"+ obj.PROD_INST_ID+"'><a href=\"javascript:void(0)\" class=\"execution\" onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','" + obj.PROD_INST_ID + "','history')\">查看</a></td>";
					else
						temp += " <td id='" + obj.PROD_INST_ID + "'><a href=\"javascript:void(0)\" class=\"execution\"  onclick=\"to_cell_view('" + obj.ADDRESS_ID + "','" + obj.PROD_INST_ID + "','exe')\">执行</a></td>";
					temp += "</tr>";

					$(tb).append(temp);
				}*/
//					$.parser.parse('#content_table_yx_list');
			}
		});
	}

	function loadSuggest(sug,id1,indez) {

		//sug的结果最多有三个值 ，可能是：0个值=空；1个值=aa<C>aa1111<A>；2个值=aa<C>aa1111<A>bb<C>bb2222<A>；3个值=aa<C>aa1111<A>bb<C>bb2222<A><cc><C>cc3333<A>

		//sug = '价值提升营销加副卡策略<C>目标用户： 单产品无主副卡存量用户、无协议、终端在网时长>24个月、ARPU值50~80元。营销策略：预存790元=890元分摊话费(24个月实际消费的42%返还)+赠送市场价890元的华为8813Q手机一部，但需加开副卡，两卡共享89元。<A>适合套餐提档乐享3G上网版V4.0-89元<C>bbbbb<A>适合推荐手机报<C>ccccccccccccc<A>系统-推荐终端升级营销<C>目标用户：用户终端使用一年以上且当前无有效合约；<A>';
		var arry = sug.split("<a>");
		var n = arry.length;
		$('#view_suggest_number').html(n-1);//给营销推荐个数赋值
		var html = '';
		//<li><em>2</em> <strong><a href="#this">适合套餐提档乐享3G上网版V4.0-89元</a></strong>目标用户：单产品无主副卡存量用户、无协议。终端在网时长>24个月、ARPU值50~80元</li>
		for(var i=0;i<n-1;i++){
			var sub = arry[i].split("<c>");
			var idx = i+1;
			if(i==0){
				html += '<li style="text-align: left"><em>'+idx+'</em><a style="font-weight:bold;cursor:pointer;" onclick="javascript:suggestDetail('+idx+','+n+','+id1+',this);">'+sub[0]+'</a><p id="view_suggest_p_'+id1+idx+'" style="display:block;margin-top:-10px;">&nbsp;&nbsp;&nbsp;&nbsp;'+sub[1]+'</p>';
			}else{
				html += '<li style="text-align: left"><em>'+idx+'</em><a style="font-weight:bold;cursor:pointer;" onclick="javascript:suggestDetail('+idx+','+n+','+id1+',this);">'+sub[0]+'</a><p id="view_suggest_p_'+id1+idx+'" style="display:none;margin-top:-10px;">&nbsp;&nbsp;&nbsp;&nbsp;'+sub[1]+'</p>';
			}
		}
		return html;
	}
	function suggestDetail(v,n,id1,thiz) {
		$(thiz).next().toggle();
		/*$('#view_suggest_p_'+id1+v).toggle();
		for(var i=1;i<n;i++){
			if(i!=v){
				$('#view_suggest_p_'+id1+i).hide();
			}
		}*/
	}

	function getOBD(village_id){
		  //加载楼宇列表
		  var params4 = {
			  eaction: "collect_new_build_list",
			  res_id: res_id
		  };
		  var $build_list =  $("#collect_new_build_list4");
		  $.post(url, params4, function(data) {
			  data = $.parseJSON(data);
			  if (data.length != 0) {
				  var d, newRow = "";
				  var name,id;
				  for (var i = 0, length = data.length; i < length; i++) {
					  d = data[i];
					  if(i==0){
						  newRow += "<option value='" + d.SEGM_ID + "' selected='selected'>" + d.STAND_NAME + "</option>";
						  name = d.STAND_NAME;
						  id = d.SEGM_ID;
					  }
					  else
						  newRow += "<option value='" + d.SEGM_ID + "'>" + d.STAND_NAME + "</option>";
					  build_list.push(d);
				  }
				  $build_list.append(newRow);
				  select_build(name, id, 0);
			  }
			  clear_data();
			  load_obd_build();
			  load_odb_build_sum_cnt();
			  load_obd_build_type_cnt();
		  });
	  }
</script>

</body>
</html>