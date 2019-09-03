<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="village_info">
	select village_name from ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO t where village_id = '${param.village_id}'
</e:q4o>
<e:q4o var="last_month">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>

<e:description>融移用户</e:description>
<e:q4o var="rh_yd">
	SELECT COUNT(PROD_INST_YD) YD_COUNT FROM ${gis_user}.TB_GIS_VILLAGE_YD_INFO_D WHERE VILLAGE_ID = '${param.village_id}'
</e:q4o>

<e:q4l var="index_range_list">
	SELECT
	KPI_CODE,
	RANGE_NAME,
	RANGE_NAME_SHORT,
	RANGE_SIGNL,
	RANGE_MIN,
	RANGE_SIGNR,
	RANGE_MAX
	FROM ${gis_user}.TB_GIS_KPI_RANGE
	WHERE IS_VALID = 1
	ORDER BY KPI_CODE ASC, RANGE_INDEX ASC
</e:q4l>
<e:q4o var="yx_last_month">
	SELECT max(const_value) val FROM ${easy_user}.sys_const_table where model_id=10 AND data_type='mon'
</e:q4o>
<html>
<head>
	<title>小区工作台</title>
	<meta charset="utf-8">
	<meta name="author" content="jasmine">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css?version=2.5"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.4"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.0"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
	<link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_desk.css?version=2.2"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.4" />' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_village_view_details.css?version=1.2.2"/>' rel="stylesheet" type="text/css" media="all"/>
	<style>
		#village_view_bussiness_count{
			color:red;
		}
		input {
			border-radius: 3px;
			border: 1px solid #ddd;
			padding: 0 4px;
			outline: none;
			color: #777;
		}
		#village_view_latn,#village_view_bureau,#village_view_sub,#village_view_grid{font-size:12px;}
		.sub_summary_tabs_title{cursor:default;}
		.li_first_important{width:100%!important;}
		.li_first_important li:first-child {
			font-weight: bold;
		}
		.li_first_important li:first-child span{
			font-weight: normal;
		}
		.li_first_important li:first-child:before {
			position: absolute;
			content: '';
			top: 50%;
			left: 0;
			display: block;
			width: 4px;
			height: 4px;
			margin-top: -2px;
			background: #000;
			-webkit-border-radius: 50%;
			-moz-border-radius: 50%;
			border-radius: 50%;
		}
		.index_desc{line-height:20px;text-align: center;}

		/*小区工作台 单宽数列表*/
		#vill_dkd_div {display:none;padding:0 10px;}
		#vill_dkd_head tr th:first-child{width:8%;}
		#vill_dkd_head tr th:nth-child(2){width:17%;}
		#vill_dkd_head tr th:nth-child(3){width:12%;}
		#vill_dkd_head tr th:nth-child(4){width:18%;}
		#vill_dkd_head tr th:nth-child(5){width:45%;}

		#vill_dkd_list tr td:first-child{width:8%;text-align:center;}
		#vill_dkd_list tr td:nth-child(2){width:17%;text-align:center;}
		#vill_dkd_list tr td:nth-child(3){width:12%;text-align:center;}
		#vill_dkd_list tr td:nth-child(4){width:18%;text-align:center;}
		#vill_dkd_list tr td:nth-child(5){width:45%;text-align:left;}

		#vill_rh_div {display:none;padding:0 10px;}
		#vill_rh_head tr th:first-child{width:8%;}
		#vill_rh_head tr th:nth-child(2){width:17%;}
		#vill_rh_head tr th:nth-child(3){width:12%;}
		#vill_rh_head tr th:nth-child(4){width:18%;}
		#vill_rh_head tr th:nth-child(5){width:45%;}

		#vill_rh_list tr td:first-child{width:8%;text-align:center;}
		#vill_rh_list tr td:nth-child(2){width:17%;text-align:center;}
		#vill_rh_list tr td:nth-child(3){width:12%;text-align:center;}
		#vill_rh_list tr td:nth-child(4){width:18%;text-align:center;}
		#vill_rh_list tr td:nth-child(5){width:45%;text-align:left;}

		#vill_dkd_list_scroll,#vill_rh_list_scroll{
			height:80%;
			overflow-y: scroll;
		}
		#vill_dkd_count,#vill_rh_count {color:red;}

		/*#deleteBuildInVillage_btn {display:none;}*//*//20190305删除临时开放*/
		#collect_new_build_list4{
			height:24px!important;
			line-height:24px!important;
		}

		.village_view_win .tab_box div .desk_orange_bar {
			text-align: left;
		}

		#add4_order_pop_win {display:none;}

		.layui-layer-setwin {top:8px;}

		/*地址修正按钮样式修改*/
		#add4_repair {
			position: absolute;
			right: 0;
			top: 38px;
			background: #aaa;
			border-color: #aaa;
			display:none;
		}
	</style>
	<script type="text/javascript">
		var village_id = '${param.village_id}';
        var build_list = [];
		var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp" />';
		var url4Query2 = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action1.jsp' />";
        //共同楼宇ID,标签联动切换使用,需要子页面去秀给他的编号
        var common_bulid_id  = "-1";
        /*var obd_head_all=0,obd_head_0=0,obd_head_1=0,obd_head_g=0;*/

		var index_range_str_temp = ${e:java2json(index_range_list.list)};
		var index_range_map = new Array();
		for(var i = 0,l = index_range_str_temp.length;i<l;i++){
			var index_item = index_range_str_temp[i];
			var index_map = index_range_map[index_item['KPI_CODE']];
			if(index_map!=undefined)
				index_map.push(index_item);
			else{
				index_map = new Array();
				index_map.push(index_item);
			}
			index_range_map[index_item['KPI_CODE']] = index_map;
		}

		function getVillageBaseInfo(village_id){
			$.post(url4Query, {eaction: "getVillageBaseInfo", village_id: village_id,acct_month:'${last_month.VAL}'}, function (data) {
				var obj = $.parseJSON(data);

				if(obj==null){
					layer.msg("该小区已被删除");
					setTimeout(function(){parent.closeOtherLayerWin();},2000);
					return;
				}

				//隐藏域
				$("#village_view_title").text(obj.V_NAME);
				parent.village_paint_name = obj.V_NAME;

				//20190305删除临时开放
				/*if(obj.VILLAGE_LABEL_FLG==null){//小区状态为空，可以删除
					$("#deleteBuildInVillage_btn").show();
				}else{
					$("#deleteBuildInVillage_btn").removeAttr("onclick");
					$("#deleteBuildInVillage_btn").show();
					//cursor:not-allowed;background:#a5a3a3;
					$("#deleteBuildInVillage_btn").css({"cursor":"not-allowed","background":"#a5a3a3"});
				}*/

				//第一个标签页
				//基础
				$.post(url4Query,{eaction:"getLatnNameBureauNameByUnionOrgCode","union_org_code":obj.V_SUB_ID},function(data){
					var obj_temp = $.parseJSON(data);
					$("#village_view_latn").text(obj_temp.LATN_NAME);
					$("#village_view_bureau").text(obj_temp.BUREAU_NAME);
				});
				$("#village_view_sub").text(obj.V_SUB_NAME);
				$("#village_view_grid").text(obj.V_GRID_NAME);
				$("#village_view_creator").text(obj.CREATOR_NAME);
				$("#village_view_create_time").text(obj.CREATE_TIME);
				$("#village_view_gua_ce_time").text(obj.GUA_CE_TIME);//挂测时间

				//市场
				$("#village_view_market_lv").text(obj.MARKET_RATE);

				marketFlag(obj.MARKET_RATE1);

				$("#village_view_zhu_hu").text(obj.GZ_ZHU_HU_SHU);
				$("#village_view_zhu_hu1").text(obj.GZ_ZHU_HU_SHU);
				$("#village_view_zhu_hu2").text(obj.GZ_ZHU_HU_SHU);

				$("#village_view_gz_h_use").text(obj.GZ_H_USE_CNT);

				$("#village_view_arpu_hu").text(obj.ARPU_HU);
				$("#village_view_arpu_hu1").text(obj.ARPU_HU);

				$("#village_view_arpu_month").text(obj.ARPU_MONTH);
				$("#village_view_arpu_dk").text(obj.DK_ARPU);
				$("#village_view_arpu_rh").text(obj.RH_ARPU);

				$("#village_view_gov_zhu_hu").text(obj.GOV_ZHU_HU_COUNT);
				$("#village_view_gov_h_use").text(obj.GOV_H_USE_CNT);

				//覆盖率
				$("#village_view_build_count").text(obj.LY_CNT);
				$("#village_view_reached_build").text(obj.RES_ARRIVED_CNT);
				//$("#village_view_unreach_build").text(obj.NO_RES_ARRIVE_CNT);
				$("#village_view_resource_percent").text(obj.RESOUCE_RATE);//资源覆盖率
				$("#village_view_obd").text(obj.OBD_CNT);
				$("#village_view_hobd").text(obj.HIGH_USE_OBD_CNT);
				$("#village_view_obd01").text(obj.ZERO_OBD_CNT);

				//占用率
				$("#village_view_port_lv").text(obj.PORT_LV);
				$("#village_view_port_num").text(obj.PORT_ID_CNT);
				$("#village_view_port_used").text(obj.USE_PORT_CNT);
				$("#village_view_free_port").text(obj.KONG_PORT_CNT);

				//竞争 新口径在village_compete_info方法中
				//$("#village_view_compete_percent").text(obj.COMPETE_PERCENT);

                //obd_head_all=obj.OBD_CNT,obd_head_0=obj.ZERO_OBD_CNT,obd_head_1=obj.FIRST_OBD_CNT,obd_head_g=obj.HIGH_USE_OBD_CNT;
				//竞争其他指标在village_compete_info方法中

				//规模
				$("#village_view_ru_zhu_lv").text(obj.VILLAGE_RU_RATE);
				$("#village_view_kaipan").text(obj.VILLAGE_LABEL);

				modeFlag(obj.GZ_ZHU_HU_SHU);

				/*$("#village_view_village_mode").text(obj.VILLAGE_GM);

				console.log("obj.VILLAGE_GM:"+"'"+obj.VILLAGE_GM+"");
				if($.trim(obj.VILLAGE_GM)!="")
					$("#tag_mode").text(obj.VILLAGE_GM);//规模标签 tag
				else
					$("#tag_mode").html("&nbsp;");

				$("#village_view_village_attr").text(obj.VILLAGE_VALUE);*/
				$("#village_view_village_xf").text(obj.VILLAGE_XF);

				//营销
				$("#village_view_collect_lv").text(obj.COLLECT_LV);
				$("#village_view_should_collect").text(obj.SHOULD_COLLECT_CNT);
				$("#village_view_already_collect").text(obj.ALREADY_COLLECT_CNT);

				var bussiness_count = 0;
				var bussiness_text = "";
				if(obj.WIDEBAND_IN==1){
					bussiness_count += 1;
					bussiness_text += "电信";
				}
				if(obj.CM_OPTICAL_FIBER==1){
					bussiness_count += 1;
					if(bussiness_text!="")
						bussiness_text += "/";
					bussiness_text += "移动";
				}
				if(obj.CU_OPTICAL_FIBER==1){
					bussiness_count += 1;
					if(bussiness_text!="")
						bussiness_text += "/";
					bussiness_text += "联通";
				}
				if(obj.SARFT_OPTICAL_FIBER==1){
					bussiness_count += 1;
					if(bussiness_text!="")
						bussiness_text += "/";
					bussiness_text += "广电";
				}
				if(obj.OTHER_OPTICAL_FIBER==1){
					bussiness_count += 1;
					if(bussiness_text!="")
						bussiness_text += "/";
					bussiness_text += "其他";
				}
				$("#village_view_bussiness_count").text(bussiness_count);
				$("#village_view_bussiness_text").text(bussiness_text);
			});

			village_compete_info();
			intraday_num();
		}

		function marketFlag(market_rate){
			var tag_market_str = "";
			var market_range = index_range_map["KPI_D_001"];
			for(var i = 0,l = market_range.length;i<l;i++){
				var item = market_range[i];
				if(item.RANGE_MAX==null){//最大值
					if(item.RANGE_SIGNL=='>='){
						if(market_rate >= item.RANGE_MIN){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='>'){
						if(market_rate > item.RANGE_MIN){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
				}else if(item.RANGE_MIN==null){//最小值
					if(item.RANGE_SIGNR=='<='){
						if(market_rate <= item.RANGE_MAX){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='<'){
						if(market_rate < item.RANGE_MAX){
							tag_market_str = item.RANGE_NAME_SHORT;
						}
					}
				}else{
					if(item.RANGE_SIGNL=='>='){
						if(market_rate >= item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(market_rate < item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(market_rate <= item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}else if(item.RANGE_SIGNL=='>'){
						if(market_rate > item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(market_rate < item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(market_rate <= item.RANGE_MAX){
									tag_market_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}
				}
			}
			if(tag_market_str!="")
				tag_market_str += "渗透";

			$("#tag_market").text(tag_market_str);//渗透标签 tag
		}

		function modeFlag(gz_zhs){
			var village_gm_str = "";
			var village_gm_range = index_range_map["KPI_D_002"];
			for(var i = 0,l = village_gm_range.length;i<l;i++){
				var item = village_gm_range[i];
				if(item.RANGE_MAX==null){//最大值
					if(item.RANGE_SIGNL=='>='){
						if(gz_zhs >= item.RANGE_MIN){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='>'){
						if(gz_zhs > item.RANGE_MIN){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
				}else if(item.RANGE_MIN==null){//最小值
					if(item.RANGE_SIGNR=='<='){
						if(gz_zhs <= item.RANGE_MAX){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
					if(item.RANGE_SIGNR=='<'){
						if(gz_zhs < item.RANGE_MAX){
							village_gm_str = item.RANGE_NAME_SHORT;
						}
					}
				}else{
					if(item.RANGE_SIGNL=='>='){
						if(gz_zhs >= item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(gz_zhs < item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(gz_zhs <= item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}else if(item.RANGE_SIGNL=='>'){
						if(gz_zhs > item.RANGE_MIN){
							if(item.RANGE_SIGNR=='<'){
								if(gz_zhs < item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}else if(item.RANGE_SIGNR=='<='){
								if(gz_zhs <= item.RANGE_MAX){
									village_gm_str = item.RANGE_NAME_SHORT;
								}
							}
						}
					}
				}
			}

			$("#village_view_village_mode").text(village_gm_str+"规模");
			$("#tag_mode").text(village_gm_str+"规模");
		}

		var vill_dkd_div_size = ["75%","80%"];//620 360
		var vill_dkd_div_handle = "";
		var vill_rh_div_handle = "";

		var add4_order_pop_win_handler = "";

		$(function(){
			//第一个标签页，小区汇总信息
			getVillageBaseInfo(village_id);
			//融移用户
			$("#village_view_rh_yd").text('${rh_yd.YD_COUNT}');

			//单宽数
			$.post(url4Query2,{"eaction":"get_dkd_count","village_id":village_id},function(data){
				var d = $.parseJSON(data);
				$("#village_view_dkd_use_cnt").text(d.COUNT);
				if(d.COUNT>0){
					$("#village_view_dkd_use_cnt").addClass("summary_index_clickable");
					$("#village_view_dkd_use_cnt").unbind();
					$("#village_view_dkd_use_cnt").on("click",function(){
						clearVillDkdList();
						villDkdList();
						vill_dkd_div_handle = layer.open({
							title: ['单宽用户清单', 'font-size:18px;text-align:center;'],
							type: 1,
							shade: 0,
							maxmin: false, //开启最大化最小化按钮
							area: vill_dkd_div_size,
							content: $("#vill_dkd_div"),
							skin: 'vill_dkd_div',
							cancel: function (index) {
								layer.close(vill_dkd_div_handle);
							},
							full: function() { //点击最大化后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
							},
							restore: function() { //点击还原后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css("top",'6px');
							}
						});
					});
				}
			});

			//融合数
			$.post(url4Query2,{"eaction":"get_rh_count","village_id":village_id},function(data){
				var d = $.parseJSON(data);
				$("#village_view_rh_use_cnt").text(d.COUNT);
				if(d.COUNT>0){
					$("#village_view_rh_use_cnt").addClass("summary_index_clickable");
					$("#village_view_rh_use_cnt").unbind();
					$("#village_view_rh_use_cnt").on("click",function(){
						clearVillRhList();
						villRhList();
						vill_rh_div_handle = layer.open({
							title: ['融合用户清单', 'font-size:18px;text-align:center;'],
							type: 1,
							shade: 0,
							maxmin: false, //开启最大化最小化按钮
							area: vill_dkd_div_size,
							content: $("#vill_rh_div"),
							skin: 'vill_dkd_div',
							cancel: function (index) {
								layer.close(vill_rh_div_handle);
							},
							full: function() { //点击最大化后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
							},
							restore: function() { //点击还原后的回调函数
								$(".vill_dkd_div .layui-layer-setwin").css("top",'6px');
							}
						});
					});
				}
			});

			//第四个标签页，OBD清单
            //initOBDComobo(village_id);

			//标签切换
			var $div_li = $(".tab_menu span");
			$div_li.click(function () {
				$("#add4_repair").hide();
				$(this).addClass("selected")            //当前<li>元素高亮
						.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
				var index = $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
				$("div.tab_box > div")      //选取子节点。不选取子节点的话，会引起错误。如果里面还有div
						.eq(index).show()   //显示 <li>元素对应的<div>元素
						.siblings().hide(); //隐藏其它几个同辈的<div>元素
				if(index!=0){
					$("#village_view_title").parent().hide();
				}else{
					$("#village_view_title").parent().show();
				}
				emptyAllDiv();
                if(index==1){//第二个标签页，楼宇清单
					$("#ly_content").load('<e:url value="/pages/telecom_Index/common/jsp/ly_content.jsp"/>?village_id=' + village_id);
                }else if(index==2){//第三个标签页，住户清单
					$("#add4_repair").show();
                    $("#zhuhuqingdan").load("<e:url value='/pages/telecom_Index/common/jsp/info_tab.jsp' />?village_id=" + village_id);
                }else if(index==3){//第四个标签页，OBD清单
					$("#obd_content").load("<e:url value='/pages/telecom_Index/common/jsp/obd_tab.jsp' />?village_id=" + village_id);
                }else if(index==4){//第五个标签页，营销清单
                    //修改子页面的楼宇id
					$("#yx_content").load('<e:url value="/pages/telecom_Index/common/jsp/yx_content.jsp"/>?village_id=' + village_id);
                    ///yx_build_id = common_bulid_id;
                    //调用子页面楼宇onchange事件
                    //yx_load_build_info(1);
                }else if(index==5){//第六个标签页，流失用户
                    $("#yhzt_content").load('<e:url value="/pages/telecom_Index/common/jsp/yhzt_content.jsp"/>?village_id='+village_id);
                }else if(index==6){
					$("#collect_content").load('<e:url value="/pages/telecom_Index/common/jsp/vill_collect_content.jsp"/>?village_id='+village_id);
				}
			})

			var width = "85%";
			var height = "90%";

			$("#add4_repair").unbind();
			$("#add4_repair").bind("click",function(){
				$("#add4_order_pop_win").load("<e:url value='pages/telecom_Index/sub_grid/viewPlane_add4_repair_pop_content.jsp' />");
				add4_order_pop_win_handler = layer.open({
					title:'新建工单',
					type: 1,
					shade: 0,
					//offset: 't',
					area:[width,height],
					content:$("#add4_order_pop_win"),
					skin: 'summary_market'
				});
			});

			$("#village_paint").unbind();
			$("#village_paint").bind("click",function(){
				parent.villagePaintTrigger();
			});

			//单宽用户清单滚动加载
			var begin_scroll_village = "";
			$("#vill_dkd_list_scroll").scroll(function () {
				var viewH = $(this).height();
				var contentH = $(this).get(0).scrollHeight;
				var scrollTop = $(this).scrollTop();
				//alert(scrollTop / (contentH - viewH));

				if (scrollTop / (contentH - viewH) >= 0.95) {
					if (new Date().getTime() - begin_scroll_village > 500) {
						villDkdPage++;
						villDkdList();
					}
					begin_scroll_village = new Date().getTime();
				}
			});
			$("#vill_rh_list_scroll").scroll(function () {
				var viewH = $(this).height();
				var contentH = $(this).get(0).scrollHeight;
				var scrollTop = $(this).scrollTop();
				//alert(scrollTop / (contentH - viewH));

				if (scrollTop / (contentH - viewH) >= 0.95) {
					if (new Date().getTime() - begin_scroll_village > 500) {
						villRhPage++;
						villRhList();
					}
					begin_scroll_village = new Date().getTime();
				}
			});
		});

		var villDkdPage = 0;
		var vill_dkd_order = 1;

		function villDkdList(){
			$.post(url4Query2,{"eaction":"get_dkd_list","village_id":village_id,"page":villDkdPage},function(data){
				var list = $.parseJSON(data);
				if(list.length){
					for(var i = 0,l = list.length;i<l;i++){
						var d = list[i];
						if(i==0 && villDkdPage==0)
							$("#vill_dkd_count").text(d.C_NUM);
						var row = "<tr><td>"+(vill_dkd_order++)+"</td><td>"+ (d.TELE_NO)+"</td><td>"+ nameHide(d.USER_CONTACT_PERSON) +"</td><td>"+ (d.USER_CONTACT_NBR)+"</td><td>"+ d.STAND_NAME_2+"</td></tr>";
						$("#vill_dkd_list").append(row);
					}
				}else{
					if(villDkdPage==0)
						$("#vill_dkd_count").text("0");
				}
			});
		}

		var villRhPage = 0;
		var vill_rh_order = 1;

		function villRhList(){
			$.post(url4Query2,{"eaction":"get_rh_list","village_id":village_id,"page":villRhPage},function(data){
				var list = $.parseJSON(data);
				if(list.length){
					for(var i = 0,l = list.length;i<l;i++){
						var d = list[i];
						if(i==0 && villRhPage==0)
							$("#vill_rh_count").text(d.C_NUM);
						var row = "<tr>";
						row += "<td>"+(vill_rh_order++)+"</td>";
						row += "<td><a href='javascript:void(0);' onclick='cust_agent(\"\",\""+ d.PROD_INST_ID+"\",\""+ d.SEGM_ID_2+"\",\"\",\"\")'>"+ (d.TELE_NO)+"</a></td>";
						row += "<td>"+ nameHide(d.USER_CONTACT_PERSON) +"</td>";
						row += "<td>"+ (d.USER_CONTACT_NBR)+"</td>";
						row += "<td>"+ d.STAND_NAME_2+"</td>";
						row += "</tr>";
						$("#vill_rh_list").append(row);
					}
				}else{
					if(villRhPage==0)
						$("#vill_rh_count").text("0");
				}
			});
		}

		function cust_agent(segm_id,prod_inst_id,add6,mkt_campaign_id,pa_date){
			var param = {};
			param.segment_id = segm_id;
			param.prod_inst_id = prod_inst_id;
			param.add6 = add6;
			param.mkt_campaign_id = mkt_campaign_id;
			param.pa_date = pa_date;
			param.tab_id = 2;
			param.is_village = 1;
			parent.openCustViewByProdInstId(param);
		}

		function phoneHide(phone){
			if(phone.length>5){
				var d = phone.substr(0,3);
				for(var i = 0,l = phone.length-5;i<l;i++){
					d += "*";
				}
				return d+phone.substr(-2);
			}else
				return phone;

		}
		function nameHide(name){
			if(name.length>1){
				var d = name.substr(0,1);
				/*for(var i = 0,l = name.length-1;i<l;i++){
					d += "*";
				}
				return d;*/
				return d+"**";
			}
			return name;
		}

		function clearVillDkdList(){
			$("#vill_dkd_list").empty();
			villDkdPage = 0;
			vill_dkd_order = 1;
		}

		function clearVillRhList(){
			$("#vill_rh_list").empty();
			villRhPage = 0;
			vill_rh_order = 1;
		}

		function closeOrderPopWin(){
			$("#add4_order_pop_win").empty();
			layer.close(add4_order_pop_win_handler);
		}
	</script>
</head>
<body class="village_view_win">
    <div class="info_collect_win_new" id="info_collect_edit_div" style="display:none;height: 200px;">
        <!--<div class="titlea">
            <div id="info_collect_edit_draggable" style='text-align:left;width:90%;display: inline-block'>竞争收集</div>
            <div class="titlec" id="info_collect_edit_div_close"></div>
        </div>-->
        <iframe width="100%" height="100%"></iframe>
    </div>
	<h3 class="wrap_a tab_menu desk_menu" style="border-left:none;padding-left:11px;">
		<span style="cursor:pointer;" class="selected">小区概况</span>
		<span style="cursor:pointer;">楼宇清单</span>
		<span style="cursor:pointer;">住户清单</span>
		<span style="cursor:pointer;">OBD清单</span>
		<span style="cursor:pointer;">营销清单</span>
		<span style="cursor:pointer;">流失用户</span>
		<span style="cursor:pointer;">收集清单</span>

		<div class="bulid_village_btn village_edit" style="top:-10px;width:auto;margin-right:17px;">
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
				<button id="add4_repair">地址修正</button>
			</e:if>
			<button id="village_paint">画像</button>
			<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
			<button id="editBuildInVillage_btn" onclick="javascript:parent.editBuildInVillage();">编辑</button>
			<button id="deleteBuildInVillage_btn" onclick="javascript:parent.deleteBuildInVillage();">删除</button>
			</e:if>
		</div>
	</h3>

	<div class="tab_box">
		<!--概况-->
        <div style="width:100%;">
			<span class="village_name_new desk_orange_bar" style="display: block!important;">
				<span id="village_view_title" class="cate2"></span>
				(<span id="village_view_latn"></span>-<span id="village_view_bureau"></span>-<span id="village_view_sub"></span>-<span id="village_view_grid"></span>)
			</span>
		    <div class="desk_tag">
			    <span id="tag_market"></span> <span id="tag_compete"></span><span id="tag_mode"></span>
		    </div>
		    <div class="sub_summary_tabs tabs_suvery">
				<div style="clear:both;float:none;">
					<div class="sub_summary_tabs_title">市场</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_market_lv" class="village_summary_percent_num"></div>
							<div class="index_desc">宽带渗透率</div>
						</div>
						<ul class="li_first_important">
							<li>住户数：<span id="village_view_zhu_hu"></span></li>
							<li>宽带数：<span id="village_view_gz_h_use"></span></li>
							<li>单宽数：<span id="village_view_dkd_use_cnt"></span></li>
							<li>融合数：<span id="village_view_rh_use_cnt"></span></li>
						</ul>
						<ul class="li_first_important">
							<li>政企住户：<span id="village_view_gov_zhu_hu"></span></li>
							<li>政企宽带：<span id="village_view_gov_h_use"></span></li>
						</ul>
						<ul class="li_first_important" style="display:none;">
							<li>融移用户：<span id="village_view_rh_yd"></span></li>
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">价值</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_arpu_hu" class="village_summary_percent_num">--</div><!--village_view_resource_percent-->
							<div class="index_desc">户均ARPU</div><!---->
						</div>
						<ul class="li_first_important">
							<li>户均ARPU：<span id="village_view_arpu_hu1"></span></li>
							<li>单宽ARPU：<span id="village_view_arpu_dk"></span></li>
							<li>融合ARPU：<span id="village_view_arpu_rh"></span></li>
							<!--<li>未达楼宇：<span id="village_view_build_num_unreach"></span></li>-->
						</ul>
						<ul class="li_first_important">
							<li>小区月收：<span id="village_view_arpu_month"></span></li><!--月收入-->
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">资源</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_port_lv" class="village_summary_percent_num"></div>
							<div class="index_desc">端口占用率</div>
						</div>
						<ul class="li_first_important">
							<li>端口数：<span id="village_view_port_num"></span></li>
							<li>占用端口：<span id="village_view_port_used"></span></li>
							<!--<li>空闲端口：<span id="village_view_free_port"></span></li>-->
						</ul>
						<ul class="li_first_important">
							<li>OBD数：<span id="village_view_obd"></span></li>
							<li>高占：<span id="village_view_hobd"></span></li>
							<li>零低：<span id="village_view_obd01"></span></li>
						</ul>
						<ul class="li_first_important">
							<li>覆盖率：<span id="village_view_resource_percent"></span></li>
							<li>楼宇数：<span class="" id="village_view_build_count"></span></li>
							<li>资源已达：<span id="village_view_reached_build"></span></li>
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">竞争</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_compete_percent" class="village_summary_percent_num"></div>
							<div class="index_desc">流失率</div>
						</div>
						<ul class="li_first_important">
							<li>流失用户：<span id="village_view_lost_cnt_y"></span></li>
							<li>拆机：<span id="village_view_remove_cnt_y"></span></li>
							<li>欠停：<span id="village_view_stop_cnt_y"></span></li>
							<!--<li>欠费用户：<span id="village_view_owe_cnt"></span></li>-->
							<li>沉默：<span id="village_view_silent_cnt_y"></span></li>
							<!--<li>非计费用户：<span id="village_view_fei_cnt"></span></li>-->
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">规模</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_zhu_hu2" class="village_summary_percent_num"></div>
							<div class="index_desc">住户数</div>
						</div>
						<ul class="li_first_important">
							<!--<li>住户数：<span id="village_view_zhu_hu1">--</span></li>-->
							<li>进线商家：<span id="village_view_bussiness_count">--</span></li>
							<li>消费能力：<span id="village_view_village_xf">--</span></li>
							<li>入住率：<span id="village_view_ru_zhu_lv">--</span></li>
							<li>开盘时间：<span id="village_view_kaipan">--</span></li>
						</ul>
					</div>
				</div>
				<span></span>
				<div>
					<div class="sub_summary_tabs_title">营销</div>
					<div class="sub_summary_index_content">
						<div class="village_summary_percent">
							<div id="village_view_exec_rate" class="village_summary_percent_num"></div>
							<div class="index_desc">营销数</div>
						</div>
						<ul class="li_first_important">
							<li>营销数：<span id="village_view_dispatch_cnt">--</span></li>
							<li>执行数：<span id="village_view_exec_cnt">--</span></li>
							<li>成功数：<span id="village_view_succ_cnt">--</span></li>
						</ul>
						<ul class="li_first_important">
							<li>收集率：<span id="village_view_collect_lv">--</span></li>
							<li>应收集：<span id="village_view_should_collect">--</span></li>
							<li>已收集：<span id="village_view_already_collect">--</span></li>
						</ul>
					</div>
				</div>
			</div>
	    </div>
		<!--楼宇基本信息清单-->
		<div id="ly_content"  style="display:none;"></div>
		<!--住户清单 -->
		<div id="zhuhuqingdan" style="display: none"></div>

		<!--OBD清单-->
		<div id="obd_content" style="display:none;"></div>
		<!--营销清单-->
		<div id="yx_content" style="display:none;"></div>
        <!--竞争收集 -->
        <%--<div id="info_content" style="display:none;">
        </div>--%>
		<!--流失用户-->
		<div id="yhzt_content"  style="display:none;"></div>
		<!-- 收集清单 -->
		<div id="collect_content"  style="display:none;"></div>
	</div>


	<div id="vill_dkd_div">
		<!-- 此处将加载“单宽数”的列表 -->
		<div class="head_table_wrapper" style="padding-left:1px;height:5%;">记录数：<span id="vill_dkd_count"></span></div>
		<div class="head_table_wrapper" style="height:10%">
			<table class="head_table" id="vill_dkd_head">
				<tr>
					<th>序号</th>
					<th>接入号</th>
					<th>联系人</th>
					<th>联系电话</th>
					<th>安装地址</th>
				</tr>
			</table>
		</div>
		<div class="" id="vill_dkd_list_scroll">
			<table class="content_table build_detail_in" id="vill_dkd_list" style="width:100%;">
			</table>
		</div>
	</div>

	<div id="vill_rh_div">
		<!-- 此处将加载“融合数”的列表 -->
		<div class="head_table_wrapper" style="padding-left:1px;height:5%;">记录数：<span id="vill_rh_count"></span></div>
		<div class="head_table_wrapper" style="height:10%">
			<table class="head_table" id="vill_rh_head">
				<tr>
					<th>序号</th>
					<th>接入号</th>
					<th>联系人</th>
					<th>联系电话</th>
					<th>安装地址</th>
				</tr>
			</table>
		</div>
		<div class="" id="vill_rh_list_scroll">
			<table class="content_table build_detail_in" id="vill_rh_list" style="width:100%;">
			</table>
		</div>
	</div>

	<!-- 地址修正 工单 -->
	<div id="add4_order_pop_win"></div>
</body>
</html>
<script type="text/javascript">
    var begin_scroll = "", seq_num = 0, list_page = 0,select_count = 0, label=0, collect_state = null;
    var url2 = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action1.jsp' />";
    var zy_type = "";

    var load_build_info4 = function (flag) {
        //选中文本回写进 input
        var text = $("#collect_new_build_list4").find("option:selected").text();
        $("#collect_new_build_name4").val(text);
        //$("#obd_new1_select_build").html(text);

        //var build_id = $("#obd_build_build").val()==null?'':$("#obd_build_build").val();
        //var $build_list = $("#obd_new1_bulid_info_list");
        clear_data_OBD();
        load_obd_build();
        load_obd_build_type_cnt();
        load_odb_build_sum_cnt();
    }

    //obd楼宇
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
    //联动调动
    function load_obd_build_ld(){
        $("#obd_quanbu").addClass("active").siblings().removeClass("active");

        $("#collect_new_build_list4 option[value=" + common_bulid_id + "]").attr('selected','selected');
        build_id=common_bulid_id;
        clear_data_OBD();
        zy_type='';
        var params = {
            eaction: "obd_build",
            page: 0,
            resid: common_bulid_id,
            village_id: village_id,
            city_id:parent.city_id,
            zy:zy_type
        }
        buildOBDListScroll(params, 1);
    }

    function select_build(name, id, index) {
		$("#collect_new_build_list4 option").removeAttr("selected");
        $("#collect_new_build_list4 option[value=" + id + "]").attr('selected','selected');
        $("#collect_new_build_name4_list").hide();
        $("#collect_new_build_list4").change();
		$("#collect_new_build_name4").val(name);
    }

	var urlyhztQuery = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp" />';
	function village_compete_info() {
		var params = new Object();
		params.eaction = "getBuildInVillageTotalByYhzt";
		params.village_id = village_id;
		//params.acct_month = '${last_month.VAL}';
		$.post(urlyhztQuery, params, function (data) {
			if($.trim(data)!="null"){
				data = $.parseJSON(data);
				//小区光宽用户
				//$("#head_all").text(data[0].CNT);
				$("#village_view_lost_cnt").text(data.ARRIVE_CNT);
				$("#village_view_lost_cnt_y").text(data.ARRIVE_CNT_Y);
				//拆机用户
				$("#village_view_remove_cnt").text(data.REMOVE_CNT);
				$("#village_view_remove_cnt_y").text(data.REMOVE_CNT_Y);
				//停机用户
				//$("#village_view_stop_cnt").text(data.STOP_CNT);
				$("#village_view_stop_cnt").text(data.STOP_CNT_Y);
				$("#village_view_stop_cnt_y").text(data.STOP_CNT_Y);
				//欠费用户
				//$("#village_view_owe_cnt").text(data.OWE_CNT);
				//其中：沉默用户
				//$("#village_view_silent_cnt").text(data.CM_CNT);
				$("#village_view_silent_cnt").text(data.CM_CNT_Y);
				$("#village_view_silent_cnt_y").text(data.CM_CNT_Y);
				//非计费未拆机
				//$("#village_view_fei_cnt").text(data.FEI_CNT);
				$("#village_view_compete_percent").text(data.COMPETE_PERCENT);
				competeFlag(data.COMPETE_PERCENT1);
			}else{
				$("#village_view_lost_cnt").text(0);
				$("#village_view_lost_cnt_y").text(0);
				//流失用户
				$("#village_view_remove_cnt").text(0);
				$("#village_view_remove_cnt_y").text(0);
				//停机用户
				$("#village_view_stop_cnt").text(0);
				$("#village_view_stop_cnt_y").text(0);
				//欠费用户
				//$("#village_view_owe_cnt").text(0);
				//其中：沉默用户
				$("#village_view_silent_cnt").text(0);
				$("#village_view_silent_cnt_y").text(0);
				//非计费未拆机
				//$("#village_view_fei_cnt").text(0);
				$("#village_view_compete_percent").text("0.00%");
				competeFlag(0);
			}
		});
	}

	function competeFlag(compete_percent){
		//竞争标签
		var tag_compete_str = "";
		var compete_range = index_range_map["KPI_D_003"];
		for(var i = 0,l = compete_range.length;i<l;i++){
			var item = compete_range[i];
			if(item.RANGE_MAX==null){//最大值
				if(item.RANGE_SIGNL=='>='){
					if(compete_percent >= item.RANGE_MIN){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
				if(item.RANGE_SIGNR=='>'){
					if(compete_percent > item.RANGE_MIN){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
			}else if(item.RANGE_MIN==null){//最小值
				if(item.RANGE_SIGNR=='<='){
					if(compete_percent <= item.RANGE_MAX){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
				if(item.RANGE_SIGNR=='<'){
					if(compete_percent < item.RANGE_MAX){
						tag_compete_str = item.RANGE_NAME_SHORT;
					}
				}
			}else{
				if(item.RANGE_SIGNL=='>='){
					if(compete_percent >= item.RANGE_MIN){
						if(item.RANGE_SIGNR=='<'){
							if(compete_percent < item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}else if(item.RANGE_SIGNR=='<='){
							if(compete_percent <= item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}
					}
				}else if(item.RANGE_SIGNL=='>'){
					if(compete_percent > item.RANGE_MIN){
						if(item.RANGE_SIGNR=='<'){
							if(compete_percent < item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}else if(item.RANGE_SIGNR=='<='){
							if(compete_percent <= item.RANGE_MAX){
								tag_compete_str = item.RANGE_NAME_SHORT;
							}
						}
					}
				}
			}
		}
		if(tag_compete_str!="")
			tag_compete_str += "竞争";

		$("#tag_compete").text(tag_compete_str);//竞争标签 tag
	}

	function intraday_num(){
		var params = {};
		params.village_id=village_id;
		params.acct_month='${yx_last_month.VAL}';
		var postUrl="<e:url value='pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp?eaction=intraday_num_village_new'/>";
		try{
			$.post(postUrl,params, function (data) {
				data = $.parseJSON(data);
				if(data.length>0){
					//月派单数
					$("#village_view_dispatch_cnt").html(""+data[0].ORDER_NUM+"");
					//执行数
					$("#village_view_exec_cnt").html(""+data[0].EXEC_NUM+"");
					//执行率
					var order_num = data[0].ORDER_NUM;
					if(order_num!='--')
						$("#village_view_exec_rate").html(""+order_num);
					else
						$("#village_view_exec_rate").html(order_num);
					//成功数
					$("#village_view_succ_cnt").html(""+data[0].SUCC_NUM+"");
				}else{
					$("#village_view_dispatch_cnt").html(0);
					$("#village_view_exec_cnt").html(0);
					$("#village_view_exec_rate").html("0");
					$("#village_view_succ_cnt").html("0");
				}
			})
		}catch(e){
			$("#village_view_dispatch_cnt").html(0);
			$("#village_view_exec_cnt").html(0);
			$("#village_view_exec_rate").html("0");
			$("#village_view_succ_cnt").html("0");
		}
	}
	function emptyAllDiv(){
		$("#ly_content").empty();
		$("#zhuhuqingdan").empty();
		$("#obd_content").empty();
		$("#yx_content").empty();
		$("#yhzt_content").empty();
		$("#collect_content").empty();
	}
</script>