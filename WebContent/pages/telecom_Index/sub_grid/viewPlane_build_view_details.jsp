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
<e:q4l var="scene_list">
	select t.scenes_type_cd id,t.scenes_type_desc text from gis_data.TB_DIC_GIS_SCENES_TYPE t where t.scenes_type_cd in('04','21','10','11')	order by t.priority asc
</e:q4l>
<html>
<head>
	<title>楼宇视图</title><!-- 代码sub_grid目录里 支局网格模块使用的-->
	<meta charset="utf-8">
	<meta name="author" content="jasmine"><!-- 定义作者-->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.5"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=3.0"/>' rel="stylesheet"
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
		body{background-color:#fff;}

		.wrap_a {margin:0px 5px 0px 5px;}
		#info_edit .wrap_a {margin:0px 5px 0px 10px;}
		.yin {height:auto;}
		.base {padding:0px 15px;}

		.combo-panel{z-index:99999}
		.product_type.village_new_searchbar.build_bar{margin:0 20px;width:95%;}
		#cell_num {font-size:12px;line-height:14px;margin-top:8px;margin-left:20px;}
		#yx_num {font-size:12px;line-height:14px;margin-top:8px;margin-left:20px;}
		.village_new_base .deve_ta {height:60px;padding-top:18px;}
		.village_new_base .deve_tb {height:60px;}


		@media screen and (min-width:1120px) and  (max-width:1345px){
		.village_new_base .deve_ta {margin-left: 0px;height:96px;margin-bottom:13px;margin-top:3px;padding-top:36px;font-size:16px;}
		.village_new_base .deve_tb {height:96px;margin-bottom:13px;margin-top:3px;width:85.8%;padding-top:36px;font-size:16px;}
		}
		@media screen and  (min-width:940px) and (max-width:958px){
		.village_new_base .deve_ta {margin-left: 0px;height:78px;margin-bottom:8px;margin-top:2px;padding-top:26px;}
		.village_new_base .deve_tb {height:78px;margin-bottom:8px;margin-top:2px;width:85.8%;padding-top:26px;}


		}
		@media screen and (max-width:815px) {
	    .village_new_base .deve_ta {margin-left: 0px;height:65px;margin-bottom:8px;margin-top:2px;padding-top:24px;}
		.village_new_base .deve_tb {height:65px;margin-bottom:8px;margin-top:2px;width:84%;padding-top:17px;}

}
		.yingxiaochangjing_table tr{border-top: 1px dotted #a7a7a7;}
		.yingxiaochangjing_table tr:first-child{border-top:none }
	</style>

	<style type="text/css">
		.table_yw .manufacture span {cursor: pointer;}
	</style>
</head>
<body>

<div class="village_name_new"><span id="village_view_title" class="cate"> </span></div>
<h3 class="wrap_a tab_menu" style="border-left:none;padding-left:15px;"><span style="cursor:pointer;" class="selected">基本信息</span>&nbsp;|&nbsp;<span style="cursor:pointer;">住户视图</span>&nbsp;|&nbsp;<span style="cursor:pointer;">住户详表</span>&nbsp;|&nbsp;<span style="cursor:pointer;">营销清单</span></h3>
<div class="product_type village_new_searchbar build_bar">
  <span>产品类型：</span>
  <input type="checkbox" name="product_type" id="product_type_a" value="kd,itv,gh" /><label for="point_type1">全部</label>
  <input type="checkbox" name="product_type" id="product_type_kd" value="kd" /><label for="product_type_kd">宽带</label>
  <input type="checkbox" name="product_type" id="product_type_itv" value="itv" /><label for="product_type_itv">电视</label>
  <input type="checkbox" name="product_type" id="product_type_gh" value="gh" /><label for="product_type_gh">固话</label>

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
	<div style="width:100%;padding: 0px;margin:0px;overflow:hidden;">
		<div class="devep village_new_base">
			<div class="deve_ta">
					归属
			</div>
			<div class="deve_tb" style="padding-top:0px;">
				<table border="0" width="100%">
					<tr>
						<td width="31%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">分公司：<span id="build_view_latn_name"></span></span></div></td>
						<td width="28%"><div class="quota"><span>区县：<span id="build_view_bureau_name"></span></span></div></td>
						<td width="38%"></td>
						<td></td>
					</tr>
					<tr>
						<td width="31%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">支&nbsp;&nbsp;&nbsp;局：<span id="build_view_sub"></span></span></div></td>
						<td width="28%"><div class="quota"><span>网格：<span id="build_view_grid"></span></span></div></td>
						<td width="38%"><div class="quota"><span>小区：<span id="build_view_village_name"></span></span></div></td>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="deve_ta">
					市场
			</div>
			<div class="deve_tb">
				<table border="0" width="100%">
					<tr>
						<td width="31%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">市场占有率：<span id="build_view_market_lv" style="color:#FF9214;font-weight:bold!important;"></span></span></div></td>
						<td width="23%"><div class="quota"><span>营销目标：<span id="build_view_yx_all"></span></span></div></td>
						<td width="24%"><div class="quota"><span>住户数：<span id="build_view_zhu_hu"></span></span></div></td>
						<td width="22%"><div class="quota"><span>人口数：<span id="build_view_people_count"></span></span></div></td>
					</tr>
				</table>
			</div>
			<div class="deve_ta">
					业务
			</div>
			<div class="deve_tb">
				<table border="0" width="100%">
					<tr>
						<td width="31%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">移动用户：<span id="build_view_yd_count" style="color:#FF9214;font-weight:bold!important;"></span></span></div></td>
						<td width="23%"><div class="quota"><span>宽带用户：<span id="build_view_kd_count" style="color:#FF9214;font-weight:bold!important;"></span></span></div></td>
						<td width="24%"><div class="quota"><span>电视用户：<span id="build_view_ds_count" style="color:#FF9214;font-weight:bold!important;"></span></span></div></td>
						<td width="22%"></td>
					</tr>
				</table>
			</div>
			<div class="deve_ta">
					资源
			</div>
			<div class="deve_tb" >
				<table border="0" width="100%">
					<tr>
							<td width="31%"><div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 5px">端口占用率：<span id="build_view_port_lv" style="color:#FF9214;font-weight:bold!important;"></span></span></div></td>
							<td width="23%"><div class="quota"><span>总端口：<span id="build_view_port"></span></span></div></td>
							<td width="24%"><div class="quota"><span>占用端口：<span id="build_view_port_used"></span></span></div></td>
							<td width="22%"><div class="quota"><span>空闲端口：<span id="build_view_free_port"></span></span></div></td>
					</tr>
				</table>
			</div>
		</div>
	</div>

	<div style="display:none;width:100%;padding: 0px;margin:0px;overflow:hidden;">
		<ul class="build_detail" id="bmt">

		</ul>
	</div>

	<div style="display:none;width:100%;padding: 0px;margin:0px;overflow:hidden;">
		<div style="padding-right:17px;width:100%;margin:0px;" class="village_m_tab">
			<table cellspacing="0" cellpadding="0" border="1" class="build_detail_in" id="thead" style="margin-top:3px;">
				<tr>
					<th rowspan="2" style="width:4%;">
						序号
					</th>
					<th rowspan="2" style="width:7%;">
						房号
					</th>
					<th rowspan="2" style="width:14%;">
						联系方式
					</th>
					<th rowspan="2" style="width:6%;">
						人口数
					</th>
					<th colspan="6">
						本网业务
					</th>
					<th colspan="2">
						竞争
					</th>
					<th rowspan="2">
						营销<br/>目标
					</th>
				</tr>
				<tr>
					<th style="width:7%;">
						宽带
					</th>
					<th style="width:7%;">
						接入<br/>方式
					</th>
					<th style="width:6%;">
						宽带<br/>速率
					</th>
					<th style="width:6%;">
						电视
					</th>
					<th style="width:9%;">
						固话
					</th>
					<th style="width:15%;">
					    套餐
					</th>
					<th style="width:6%;">
						运营商
					</th>
					<th style="width:7%;">
						备注
					</th>
				</tr>
			</table>
		</div>
		<div class="t_table village_m_tab6">
			<table cellspacing="0" cellpadding="0" border="1" class="build_detail_in" id="hhhsa">
			</table>
		</div>
	</div>

	<div style="display:none;width:100%;padding: 0px;margin:0px;overflow:hidden;">
	  <div style="width:100%;margin-left:0px;">
	  <!--<h3 class="wrap_a tab_menu1" style="border-left:none;"><span style="cursor:pointer;" class="selected1">未执行</span> | <span style="cursor:pointer;">已执行</span></h3>-->
		  <div style="padding-right:18px;margin-top:0px;">
		    <table class="village_tab detail">
			    <thead>
			      <tr>
			      	<th width="5%" rowspan="2">序号</th>
			        <th width="8%" rowspan="2">房号</th>
					  <th width="14%" rowspan="2">联系人</th>
			        <th  colspan="2">营销推荐</th>
			        <th rowspan="2">操作</th>
			       </tr>

				  <tr>
					  <th width="14%">接入号</th>
					  <th width="52%">营销场景</th>
				  </tr>
			    </thead>
		    </table>
		  </div>

			<div class="tab_box1">
				<div class="mark_tab_layout">
				  <table class="village_tab detail" id="content_table_yx_list">
				  </table>
				</div>
		  </div>
		</div>
	</div>
</div>

<!-- 跳到执行、执行历史、资料维护的页面-->
	<div class="build_info_win info_edit_win" id="cell_view_container" style="display:none;">
		<div class="titlea"><div id="detail_more_draggable" style='text-align:left;width:90%;display: inline-block;height: 30px;line-height: 30px'>营销执行</div><div  class="titlec" onclick="javascript:closeCellViewIFrame(0);"></div></div>
		<iframe width="100%" height="100%"></iframe>
	</div>

<script type="text/javascript">

	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
	var clickChangeSingleTable='';
	var fun2 = "";
	var fun4 = "";
	var checkbox_length = $(".product_type").children("input:gt(0):lt(3)").length;
	var res_id = '${param.res_id}';
	var check_val_str = "";
	var village_id = '${param.village_id}';
	var yx_id = '${param.yx_id}';
	var type = '${param.vis}';
	var tab_flag = '${param.tab_flag}';
	var scene_type = "0";
	var did_flag = "";
	var build_position = parent.global_position_build_view;

	var to_cell_view = function(add6,flag){
		//信息收集被竞争收集代替的修改
		//editInfoCollectWin(add6);
		//return;
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
		parent.openWinInfoCollectEdit(add6);
	}
	var viewInfoCollectWin = function(add6){
		parent.openWinInfoCollectionView(add6);
	}

	var closeCellViewIFrame = function(flag){
		$("#cell_view_container").hide();
		$("#cell_view_container > iframe").empty();
		if(flag==1){
			getData(res_id);
			freshYX_list_tab(res_id,scene_type,did_flag);
		}
	}

	$(function(){
		$('#cell_view_container').draggable({ handle: $('#detail_more_draggable')});
		$(".product_type").children(":lt(9)").hide();
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

			//楼宇视窗特殊处理，在基本信息页签，隐藏“产品分类、记录数”，其他页签则显示这两个
			if(index==0){
				$("#scene_type_radios").hide();
				$("#did_flag_radios").hide();
				$(".product_type").children(":lt(9)").hide();
				$(".product_type").children(":eq(9)").css("margin-left","0px");
				$("#cell_num").hide();
				$("#yx_num").hide();
				$("#fouraddress").parent().css({"float":"left"});
			}else if(index==1 || index==2){
				$("#scene_type_radios").hide();
				$("#did_flag_radios").hide();
				$(".product_type").children(":lt(9)").show();
				$(".product_type").children(":eq(9)").css("margin-left","50px");
				$("#cell_num").show();
				$("#yx_num").hide();
				$("#fouraddress").parent().css({"float":"right"});
			}else if(index==3){
				$(".product_type").children(":lt(9)").hide();
				$(".product_type").children(":eq(9)").css("margin-left","0px");
				$("#scene_type_radios").show();
				$("#did_flag_radios").show();
				$("#cell_num").hide();
				$("#yx_num").show();
				$("#fouraddress").parent().css({"float":"left"});
			}
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

		//四级地址下拉框
		//comboboxAddr4Init(query_param);

		//住户视图，住户详表
		//getData(res_id);

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
		$("#product_type_a").click(function(){
			if($(this).is(":checked")){
				$(".product_type").children("input").each(function(index,dom){
					this.checked = true;
					check_val_str = $("#product_type_a").val();
				});
			}else{
				$(".product_type").children("input").each(function(index,dom){
					this.checked = false;
					check_val_str = "";
				});
			}
			getData(res_id);
		});
		//产品分类 宽带 电视 固话
		$(".product_type").children("input:gt(0):lt(3)").each(function(index,element){
			$(this).click(function(){
				var checkNum = 0;

				var types_cks = $(".product_type").children("input:gt(0):lt(3)");
				check_val_str = "";
				for(var i = 0,l = types_cks.length;i<l;i++){
					if($(types_cks[i]).is(":checked")){
						check_val_str += $(types_cks[i]).val()+",";
						checkNum += 1;
					}
				}
				check_val_str = check_val_str.substr(0,check_val_str.length-1);

				if(checkNum==checkbox_length){
					$("#product_type_a")[0].checked = true;
				}else{
					$("#product_type_a")[0].checked = false;
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

	})

	//楼宇基本信息
	function queryBaseInfo(res_id){
		$.post(url4Query,{eaction:'build_win',res_id:res_id,latn_id:parent.city_id},function(data){
      		var d=$.parseJSON(data);
			if(d==null) {
				layer.msg("暂无该楼宇信息")
			}
			else {
				$("#build_view_title").text(d.STAND_NAME);
				$("#build_view_yd_count").text(d.YD_COUNT);
				$("#build_view_kd_count").text(d.KD_COUNT);
				$("#build_view_ds_count").text(d.ITV_COUNT);
				$("#build_view_market_lv").text(d.MARKET_LV+"%");
				if(d.YX_ALL==0)
					$("#build_view_yx_all").text("0");
				else{
					$("#build_view_yx_all").text("");
					//$("#build_view_yx_all").append("<a href=\"javascript:void(0);\" onclick=\"javascript:funshow2('"+res_id+"')\">"+d.YX_ALL+"</a>");
					$("#build_view_yx_all").text(d.YX_ALL);
				}

				$("#build_view_zhu_hu").text(d.ZHU_HU_COUNT);
				$("#build_view_people_count").text(d.PEOPLE_COUNT);
				$("#build_view_port_lv").text(d.PORT_LV+"%");
				$("#build_view_port").text(d.RES_ID_COUNT);
				$("#build_view_port_used").text(d.RES_ID_COUNT-d.SY_RES_COUNT);
				$("#build_view_free_port").text(d.SY_RES_COUNT);

				$("#build_info_win").show();

				//$("#build_view_sub").text(build_sub_grid[0]==undefined?'--':build_sub_grid[0]);
				//$("#build_view_grid").text(build_sub_grid[1]==undefined?'--':build_sub_grid[1]);
				var latn_name = "";
				if(build_position==""){
						latn_name = d.LATN_NAME;
						bureau_name = d.BUREAU_NAME;
						branch_name = d.BRANCH_NAME;
						grid_name = d.GRID_NAME;
				}else{
						latn_name = build_position[0];
						bureau_name = build_position[1];
						branch_name = build_position[2];
						grid_name = build_position[3];
				}

				$("#build_view_latn_name").text(latn_name);

				$("#build_view_bureau_name").text(bureau_name);

				$("#build_view_sub").text(branch_name);

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
			}
   		})
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
	function changeBussinessICO(d){
		//默认是电信用户
		var bussinessICO = "<div class=\"manufactuer_nothing\">";
		var bussiness_type = "未装";
		//有任意一个电信产品，则认为是电信用户
		if(d.IS_KD>0 || d.IS_ITV>0 || d.IS_GU>0){
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
				if(d.ITV_BUSINESS==1){
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
				}
			//}else if(d.PHONE_NBR!=null){//移动运营商 手机1
				if(d.PHONE_BUSINESS==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.PHONE_BUSINESS==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}
			//}else if(d.PHONE_NBR1!=null){//移动运营商 手机2
				if(d.PHONE_BUSINESS1==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.PHONE_BUSINESS1==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}
			//}else if(d.PHONE_NBR2!=null){//移动运营商 手机3
				if(d.PHONE_BUSINESS2==1){
					bussinessICO = '<div class=\"manufactuer_mobile\">';
					bussiness_type="移动";
				}else if(d.PHONE_BUSINESS2==2){
					bussinessICO = '<div class=\"manufactuer_unicom\">';
					bussiness_type="联通";
				}
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
			check_val: check_val_str
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
					if(type!=null&&type!=undefined){
						if ((type=='kd'&&d.IS_KD>0)||(type=='itv'&&d.IS_ITV>0)||(type=='gu'&&d.IS_GU>0)||type=='all'){
							if(!display)
							//clickChangeSingleTable(d.SEGM_ID_2);
								display=true;
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
							str2+
							"<h4><a href=\"javascript:void(0)\" onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','info')\">"+d.SEGM_NAME_2+"</a></h4><span>"+un+nbr+"</span> " +
							"<div class=\"icons\" style=\"display:table;padding-left:16%;\"><div style=\"width:28%;display:table-cell;\"><span class=\""+arr[0]+"\" style=\"float:left;\"></span><span style=\"float:left;line-height:22px;\">"+(d.IS_KD>1?d.IS_KD:'')+"</span></div><div style=\"width:28%;display:table-cell;\"><span class=\""+arr[2]+"\" style=\"float:left;\"></span><span style=\"float:left;line-height:22px;\">"+(d.IS_ITV>1?d.IS_ITV:'')+"</span></div><div style=\"width:28%;display:table-cell;\"><span class=\""+arr[1]+"\" style=\"float:left;\"></span><span style=\"float:left;line-height:22px;\">"+(d.IS_GU>1?d.IS_GU:'')+"</span></div></div> " +
							"<div class=\"bottom_info\"> ";
							if(d.IS_YX=='有')
								str += "<div class=\"market_info\"><a href=\"javascript:void(0)\" onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','exe')\">营销派单</a><span class=\"get\"></span></div> ";
							else
								str += "<div class=\"market_info\">营销派单<span class=\"notget\"></span></div> ";

							//其中一个不为空则资料收集为“有”，否则为“无”
							str += "<div class=\"info_get\"><a href=\"javascript:void(0)\" disabled=\"disabled\" onclick=\"to_cell_view('" + d.SEGM_ID_2 + "','info')\">资料收集</a>";
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
						}
					}
					var hhhsa = $("#hhhsa");

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

					"</tr>";
					hhhsa.append(str_s);

				});
				str+="";
				if(display){
					table.append(str);
				}
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
		freshBuildYxList(queryParam);
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
</script>

</body>
</html>