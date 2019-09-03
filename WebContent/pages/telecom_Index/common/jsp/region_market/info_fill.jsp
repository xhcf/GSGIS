<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<e:description>地市</e:description>
<e:q4l var="areaList">
    SELECT T.latn_id CODE, T.latn_name TEXT,city_order_num FROM  gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
    group by T.latn_id, T.latn_name,city_order_num
    ORDER BY  city_order_num
</e:q4l>

<e:description>区县</e:description>
<e:q4l var="cityList">
    SELECT  T.latn_id PID, T.bureau_no CODE, T.bureau_name TEXT,t.region_order_num FROM gis_data.db_cde_grid T
    WHERE T.latn_id IS NOT NULL
    and t.branch_type='a1'
	<e:if condition="${sessionScope.UserInfo.LEVEL ne '1'}">
		<e:if condition="${param.latn_id !=null && param.latn_id  ne ''}">
			and T.latn_id = '${param.latn_id}'
		</e:if>
	</e:if>
    group by T.latn_id,T.bureau_no,T.bureau_name,t.region_order_num
    ORDER BY  T.region_order_num
</e:q4l>

<e:description>支局</e:description>
<e:q4l var="centerList">
    SELECT T.bureau_no PID, T.union_org_code CODE, T.branch_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.union_org_code IS NOT NULL
    and t.branch_type='a1'
	<e:if condition="${sessionScope.UserInfo.LEVEL ne '1' && sessionScope.UserInfo.LEVEL ne '2'}">
		<e:if condition="${param.bureau_no !=null && param.bureau_no  ne ''}">
			and T.bureau_no = '${param.bureau_no}'
		</e:if>
	</e:if>
    group by T.bureau_no, T.union_org_code, T.branch_name,t.branch_no
    ORDER BY  T.branch_no
</e:q4l>

<e:description>网格</e:description>
<e:q4l var="gridList">
    SELECT  T.union_org_code PID, T.grid_id CODE, T.grid_name  TEXT FROM gis_data.db_cde_grid T
    WHERE T.grid_id IS NOT NULL
    and t.branch_type='a1' and t.grid_union_org_code is not null
	<e:if condition="${sessionScope.UserInfo.LEVEL eq '4' || sessionScope.UserInfo.LEVEL eq '5'}">
		<e:if condition="${param.union_org_code !=null && param.union_org_code  ne ''}">
			and T.union_org_code = '${param.union_org_code}'
		</e:if>
	</e:if>
    group by t.union_org_code,t.grid_id,t.grid_name
    ORDER BY  T.grid_id
</e:q4l>

<e:if condition="${param.grid_id !=null && param.grid_id  ne ''}">
	<e:q4l var="villageList">
		select GRID_ID PID, village_id CODE,village_name TEXT from gis_data.view_db_cde_village  t
		  where 1 = 1
			and T.grid_id = '${param.grid_id}'
		order by village_id
	</e:q4l>
</e:if>

<e:description>小区类型</e:description>
<e:q4l var="village_type">
    select '1' CODE , '急迫小区' TEXT from dual
    union
    select '2' CODE , '紧迫小区' TEXT from dual
    union
    select '3' CODE , '操心小区' TEXT from dual
    union
    select '4' CODE , '平稳小区' TEXT from dual
</e:q4l>

<html>
<head>
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<script src='<e:url value="resources/app/areaSelect.js?version=New Date()"/>' charset="utf-8"></script>
<link type="text/css" rel="stylesheet" href="info_fill.css?version=2.2">
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<e:script value="/resources/layer/layer.js?version=1.1"/>
<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.5"/>' rel="stylesheet" type="text/css" media="all" />
<style>
	#save_btn,#cancel_btn {cursor:pointer;}
	.blue {color:#1a9ed8;}

	.win_title_tag {
		width: 100%;
		position:fixed;
		background: #05418b;
		height:40px;
		line-height:36px;
		top:0px;
	}
	#info_edit_win {padding-top:10px;}
</style>
<script type="text/javascript">
	var url4Query = "<e:url value='pages/telecom_Index/common/jsp/region_market/info_fillAction.jsp'/>";
	var village_id = "${param.village_id}";
	var tactics_id = "${param.tactics_id}";
	var village_type = "";
	var grid_id = "";
	var can_save = true;

	var empty_value = "";
	var empty_value1 = "";

	var user_level = '${sessionScope.UserInfo.LEVEL}';

	$(function(){
		if('${param.from_list}'!=1){//单独打开的新增页
			open_win_handler = layer.open({
				title: ' ',
				//title:false,
				type: 1,
				shade: 0,
				//maxmin: true, //开启最大化最小化按钮
				area: ['86%', '95%'],
				content: $("#info_pop_win"),
				skin: 'market_view',
				cancel: function (index) {
					//$("#nav_info_collect").removeClass("active");
					//return tmp_info_collect = '1';
				}
			});
			$("#cancel_btn").hide();
			$(".layui-layer-setwin").hide();
		}else{//从清单点开查看
			$("#cancel_btn").click(function(){
				parent.closeWin();
			});
			$(".win_title_tag").hide();
		}

		initAreaSelect();
		initAreaOption();
		initInputVaild();
		getVillageMsg();

		$("select[name='villageType']").on("change",function(data){
			village_type = $("select[name='villageType'] option:selected").val();
			getVillageOption();
		});

		$("#save_btn").bind("click",function(){save_func()});

		resetSelectFunc();
	});

	//根据权限扩展联动功能
  	function resetSelectFunc(){
		if(user_level==2){
			$("#cityNo").removeAttr("disabled");
			//$("#centerNo").removeAttr("disabled");
			//$("#gridNo").removeAttr("disabled");
      	}else if(user_level==3){
          	$("#centerNo").removeAttr("disabled");
          	//$("#gridNo").removeAttr("disabled");
      	}else if(user_level==4){
		  	$("#gridNo").removeAttr("disabled");
	  	}else if(user_level==5){
		  	//所有选项不可用
	  	}

	  	//若要求region_marketing_list选项关联
	  	if('${param.pop_relate}'){
		  	//省级
			if('${param.pop_level}'==1){
				$("#areaNo").removeAttr("disabled");
			}else if('${param.pop_level}'==2){
				$("#cityNo").removeAttr("disabled");
			}else if('${param.pop_level}'==3){
				$("#centerNo").removeAttr("disabled");
			}else if('${param.pop_level}'==4){
				$("#gridNo").removeAttr("disabled");
			}
	 	}
    }

	//保存
	function save_func(){
		if(!can_save)
			return;

		village_id = $('#villageNo option:selected').val();
		if(vaild(village_id)){
			layer.msg("请选择一个小区");
			return;
		}
		var gz_zhu_hu_count = $("#hi_01").val().replace("--","");
		var gz_h_use_cnt = $("#hi_02").val().replace("--","");
		var market_lv = $("#hi_03").val().replace("%","");
		var obd_cnt = $("#hi_04").val().replace("--","");
		var res_arrive_cnt = $("#hi_05").val().replace("--","");
		var ly_cnt = $("#hi_06").val().replace("--","");
		var cover_lv = $("#hi_07").val().replace("%","");
		var port_id_cnt = $("#hi_08").val().replace("--","");
		var use_port_cnt = $("#hi_09").val().replace("--","");
		var port_lv = $("#hi_10").val().replace("%","");
		var should_collect_cnt = $("#hi_11").val().replace("--","");
		var already_collect_cnt = $("#hi_12").val().replace("--","");
		var collect_lv = $("#hi_13").val().replace("%","");
		var lost_cj_cnt = $("#hi_14").val().replace("--","");
		var lost_qt_cnt = $("#hi_15").val().replace("--","");
		var lost_cm_cnt = $("#hi_16").val().replace("--","");
		var lost_lv = $("#hi_17").val().replace("%","");
		var by_all_cnt = $("#hi_18").val().replace("--","");
		var by_cnt = $("#hi_19").val().replace("--","");
		var by_lv = $("#hi_20").val().replace("%","");

		var goal_market_lv = valFilter($("#input_01").val());
		var goal_port_lv = valFilter($("#input_02").val());
		var goal_lost_lv = valFilter($("#input_03").val());
		var goal_d2r = valFilter($("#input_04").val());
		var goal_dqxy = valFilter($("#input_05").val());
		var goal_sleep2active = valFilter($("#input_06").val());
		var goal_collect_lv = valFilter($("#input_07").val());

		var yx_sub_content = valFilter($("#input_08").val());

		var yx_tactics_content = valFilter($("#input_09").val());

		var zc_fee = valFilter($("#input_10").val());
		var zc_sell = valFilter($("#input_11").val());

		var org_emp = valFilter($("#input_12").val());
		var org_act = valFilter($("#input_13").val());
		var org_yx = valFilter($("#input_14").val());

		var plan_conent = valFilter($("#input_15").val());

		$.post(url4Query,{
			"eaction":"saveTacticsInfo",
			//"tactics_id":tactics_id,
			"village_id":village_id,

			"gz_zhu_hu_count":gz_zhu_hu_count,
			"gz_h_use_cnt":gz_h_use_cnt,
			"market_lv":market_lv,
			"obd_cnt":obd_cnt,
			"res_arrive_cnt":res_arrive_cnt,
			"ly_cnt":ly_cnt,
			"cover_lv":cover_lv,
			"port_id_cnt":port_id_cnt,
			"use_port_cnt":use_port_cnt,
			"port_lv":port_lv,
			"should_collect_cnt":should_collect_cnt,
			"already_collect_cnt":already_collect_cnt,
			"collect_lv":collect_lv,
			"lost_cj_cnt":lost_cj_cnt,
			"lost_qt_cnt":lost_qt_cnt,
			"lost_cm_cnt":lost_cm_cnt,
			"lost_lv":lost_lv,
			"by_all_cnt":by_all_cnt,
			"by_cnt":by_cnt,
			"by_lv":by_lv,

			"goal_market_lv":goal_market_lv,
			"goal_port_lv":goal_port_lv,
			"goal_lost_lv":goal_lost_lv,
			"goal_d2r":goal_d2r,
			"goal_dqxy":goal_dqxy,
			"goal_sleep2active":goal_sleep2active,
			"goal_collect_lv":goal_collect_lv,

			"yx_sub_content":yx_sub_content,

			"yx_tactics_content":yx_tactics_content,

			"zc_fee":zc_fee,
			"zc_sell":zc_sell,

			"org_emp":org_emp,
			"org_act":org_act,
			"org_yx":org_yx,

			"plan_conent":plan_conent
		},function(data){
			var data = $.parseJSON(data);
			if(data){
				disable();
				layer.msg("保存成功");
				parent.query();
			}else{
				layer.msg("保存失败");
			}
		});
	}

	function vaild(value){
		return value=="" || value=="undefined" || value==null || value=="null";
	}

	function valFilter(value){
		return $.trim(value.replace(/[\n\r]/g, ""));
	}

	//组织机构控件初始化
	var areaJSON=${e:java2json(areaList.list)};
	var cityJSON = ${e:java2json(cityList.list)};
	var centerJSON = ${e:java2json(centerList.list)};
	var gridJSON = ${e:java2json(gridList.list)};
	//var villageJSON = ${e:java2json(villageList.list)};
	function initAreaSelect() {
		if(user_level=='1'){
            roleName='all';
        }
        if(user_level=='2'){
            roleName='areaValue';
        }
        if(user_level=='3'){
            roleName='cityValue';
        }
        if(user_level=='4'){
            roleName='centerNoValue';
        }
        if(user_level=='5'){
            roleName='gridValue';
        }
        //区域控制 js 加载
        var areaSelect=new AreaSelect();
        areaSelect.areaJSON=areaJSON;
        areaSelect.cityJSON=cityJSON;
        areaSelect.centerJSON=centerJSON;
        areaSelect.gridJSON=gridJSON;
        areaSelect.areaName='areaNoDiv';
        areaSelect.cityName='cityNoDiv';
        areaSelect.centerName='centerNoDiv';
        areaSelect.gridName='gridNoDiv';
        areaSelect.isDivDis=false;
        areaSelect.isNoDis=true;
        areaSelect.role=roleName;
        areaSelect.area='${sessionScope.UserInfo.AREA_NO}';
        areaSelect.city='${sessionScope.UserInfo.CITY_NO}';
        areaSelect.center='${sessionScope.UserInfo.TOWN_NO}';
        areaSelect.grid='${sessionScope.UserInfo.GRID_NO}';
        areaSelect.initAreaSelect();
        $('.combo-panel,.panel-body,.panel-body-noheader').each(function(i){
            $(this).css("background","#fff");
        });

		//网格联动出小区
		$("#gridNo").bind("change",function(){
			grid_id = $("#gridNo").val();
			if(grid_id!=''){
				getVillageOption();
			}
		});
	}
	//初始化小区选项，若打开此页时有小区参数，则同时选中该小区
	function getVillageOption(){
		$("#villageNo").empty();
		$.post(url4Query,{"eaction":"getVillageByGrid","grid_id":grid_id,"village_type":village_type},function(data){
			var data = $.parseJSON(data);
			if(data.length){
				for(var i = 0,l = data.length;i<l;i++){
					var row = "<option value='"+data[i].VILLAGE_ID+"'>"+data[i].VILLAGE_NAME+"</option>";
					$("#villageNo").append(row);
				}
				if('${param.village_id}'!=""){
					$("select[name='villageNo']").children("[value='"+"${param.village_id}"+"']").attr("selected","selected");
				}
				getVillageMsg();
			}else{
				emptyAllInputs1();
				emptyAllInputs2();
			}
		});
	}

	//组织机构控件初始赋值选定
	function initAreaOption(){
		var latn_id = '${param.latn_id}';
		var bureau_no = '${param.bureau_no}';
		var union_org_code = '${param.union_org_code}';
		var grid_id = '${param.grid_id}';

		$("select[name='areaNo']").children("[value='"+latn_id+"']").attr("selected","selected");
		$("select[name='areaNo']").trigger("change");

		$("select[name='cityNo']").children("[value='"+bureau_no+"']").attr("selected","selected");
		$("select[name='cityNo']").trigger("change");

		$("select[name='centerNo']").children("[value='"+union_org_code+"']").attr("selected","selected");
		$("select[name='centerNo']").trigger("change");

		$("select[name='gridNo']").children("[value='"+grid_id+"']").attr("selected","selected");
		$("select[name='gridNo']").trigger("change");

		//$("select[name='villageNo']").trigger("change");
	}

	//输入框用户输入控制
	function initInputVaild(){
		for(var i = 1,l = 7;i<=l;i++){
			var temp = "";
			if(i<10)
				temp += "0"+i;
			else
				temp = i;
			var ele_id = "#input_"+temp;
			$(ele_id).keyup(function(event){
				vaildOnlyNum(event.target.id);
			});
		}
	}

	//输入控制-只能输入数字
	function vaildOnlyNum(ele_id){
		var value = $("#"+ele_id).val();
		$("#"+ele_id).val(value.replace(/[^0-9.]/g,''));
	}

	//展现选定小区或策略的信息，若操作是从此页面选小区，则展现所选小区“最新”策略信息；若操作是上一个页面选策略，则展现所选这条策略的信息
	function getVillageMsgBefore(){
		village_id = $("select[name='villageNo']").val();
		if(village_id!='${param.village_id}')
			tactics_id = "";
		getVillageMsg();
	}
	function getVillageMsg(){
		village_id = $("select[name='villageNo']").val();
		if(vaild(village_id)){
			emptyAllInputs1();
			emptyAllInputs2();
			return;
		}

		//小区“基本信息”、小区“小区现状”
		$.post(url4Query,{"eaction":"getVillageData","village_id":village_id},
			function(result){
				var data = $.parseJSON(result);
				if(data==null){
					emptyAllInputs1();
				}else{
					//基本信息
					$("#zhu_hu_shu").html("<span class='blue'>"+data.GZ_ZHU_HU_COUNT+"</span>");
					$("#gk_user_cnt").html("<span class='blue'>"+data.GZ_H_USE_CNT+"</span>");
					$("#market_lv").html("<span class='blue'>"+data.MARKT_LV+"</span>");

					$("#obd_cnt").html("<span class='blue'>"+data.OBD_CNT+"</span>");
					$("#gk_cover_lv").html("<span class='blue'>"+data.CONVER_LV+"</span>");
					$("#port_used_lv").html("<span class='blue'>"+data.PORT_LV+"</span>");

					$("#collect_lv").html("<span class='blue'>"+data.COLLECT_LV+"</span>");
					$("#yc_user_lv").html("<span class='blue'>"+data.LOST_LV+"</span>");
					$("#kd_get_lv").html("<span class='blue'>"+data.BY_LV+"</span>");

					//小区现状
					$("#hi_01").val(data.GZ_ZHU_HU_COUNT);
					$("#hi_02").val(data.GZ_H_USE_CNT);
					$("#hi_03").val(data.MARKT_LV);
					$("#hi_04").val(data.OBD_CNT);
					$("#hi_05").val(data.RES_ARRIVE_CNT);
					$("#hi_06").val(data.LY_CNT);
					$("#hi_07").val(data.CONVER_LV);
					$("#hi_08").val(data.PORT_ID_CNT);
					$("#hi_09").val(data.USE_PORT_CNT);
					$("#hi_10").val(data.PORT_LV);
					$("#hi_11").val(data.SHOULD_COLLECT_CNT);
					$("#hi_12").val(data.ALREADY_COLLECT_CNT);
					$("#hi_13").val(data.COLLECT_LV);
					$("#hi_14").val(data.LOST_Y_REMOVE);
					$("#hi_15").val(data.LOST_Y_STOP);
					$("#hi_16").val(data.LOST_Y_SILENT);
					$("#hi_17").val(data.LOST_LV);
					$("#hi_18").val(data.BY_ALL_CNT);
					$("#hi_19").val(data.BY_CNT);
					$("#hi_20").val(data.BY_LV);
				}
			}
		);

		if(tactics_id=="undefined"){
			can_save = true;
			$("#save_btn").css({"background":"#108ee9","cursor":"pointer"});
			emptyAllInputs2();
			enable();
		}else{
			//营销策略
			$.post(url4Query,{"eaction":"getTacticsData","tactics_id":tactics_id,"village_id":village_id},
					function(result1){
						var data = $.parseJSON(result1);
						if(data==null){//没有数据,表示可以保存
							can_save = true;
							$("#save_btn").css({"background":"#108ee9","cursor":"pointer"});
							emptyAllInputs2();
							enable();

						}else{//有数据，则不能再次保存
							disable();

							$("#input_01").val(data.GOAL_MARKET_LV);
							$("#input_02").val(data.GOAL_PORT_LV);
							$("#input_03").val(data.GOAL_LOST_LV);
							$("#input_04").val(data.GOAL_D2R);
							$("#input_05").val(data.GOAL_DQXY);
							$("#input_06").val(data.GOAL_SLEEP2ACTIVE);
							$("#input_07").val(data.GOAL_COLLECT_LV);

							$("#input_08").val(data.YX_SUB_CONTENT);

							$("#input_09").val(data.YX_TACTICS_CONTENT);

							$("#input_10").val(data.ZC_FEE);
							$("#input_11").val(data.ZC_SELL);

							$("#input_12").val(data.ORG_EMP);
							$("#input_13").val(data.ORG_ACT);
							$("#input_14").val(data.ORG_YX);

							$("#input_15").val(data.PLAN_CONENT);
						}
					}
			);
		}
	}

	function enable(){
		$("#input_01").removeAttr("disabled");
		$("#input_02").removeAttr("disabled");
		$("#input_03").removeAttr("disabled");
		$("#input_04").removeAttr("disabled");
		$("#input_05").removeAttr("disabled");
		$("#input_06").removeAttr("disabled");
		$("#input_07").removeAttr("disabled");
		$("#input_08").removeAttr("disabled");
		$("#input_09").removeAttr("disabled");
		$("#input_10").removeAttr("disabled");
		$("#input_11").removeAttr("disabled");
		$("#input_12").removeAttr("disabled");
		$("#input_13").removeAttr("disabled");
		$("#input_14").removeAttr("disabled");
		$("#input_15").removeAttr("disabled");
	}

	function disable(){
		can_save = false;
		$("#save_btn").css({"background":"#a1a2a2","cursor":"not-allowed"});
		$("#input_01").attr("disabled","disabled");
		$("#input_02").attr("disabled","disabled");
		$("#input_03").attr("disabled","disabled");
		$("#input_04").attr("disabled","disabled");
		$("#input_05").attr("disabled","disabled");
		$("#input_06").attr("disabled","disabled");
		$("#input_07").attr("disabled","disabled");
		$("#input_08").attr("disabled","disabled");
		$("#input_09").attr("disabled","disabled");
		$("#input_10").attr("disabled","disabled");
		$("#input_11").attr("disabled","disabled");
		$("#input_12").attr("disabled","disabled");
		$("#input_13").attr("disabled","disabled");
		$("#input_14").attr("disabled","disabled");
		$("#input_15").attr("disabled","disabled");
	}

	function emptyAllInputs1(){
		$("#zhu_hu_shu").text(empty_value);
		$("#gk_user_cnt").text(empty_value);
		$("#market_lv").text(empty_value);

		$("#obd_cnt").text(empty_value);
		$("#gk_cover_lv").text(empty_value);
		$("#port_used_lv").text(empty_value);

		$("#collect_lv").text(empty_value);
		$("#yc_user_lv").text(empty_value);
		$("#kd_get_lv").text(empty_value);

		$("#hi_01").val("");
		$("#hi_02").val("");
		$("#hi_03").val("");
		$("#hi_04").val("");
		$("#hi_05").val("");
		$("#hi_06").val("");
		$("#hi_07").val("");
		$("#hi_08").val("");
		$("#hi_09").val("");
		$("#hi_10").val("");
		$("#hi_11").val("");
		$("#hi_12").val("");
		$("#hi_13").val("");
	}
	function emptyAllInputs2(){
		$("#input_01").val(empty_value1);
		$("#input_02").val(empty_value1);
		$("#input_03").val(empty_value1);
		$("#input_04").val(empty_value1);
		$("#input_05").val(empty_value1);
		$("#input_06").val(empty_value1);
		$("#input_07").val(empty_value1);

		$("#input_08").val(empty_value1);

		$("#input_09").val(empty_value1);

		$("#input_10").val(empty_value1);
		$("#input_11").val(empty_value1);

		$("#input_12").val(empty_value1);
		$("#input_13").val(empty_value1);
		$("#input_14").val(empty_value1);

		$("#input_15").val(empty_value1);
	}

</script>
</head>
<body>
<div id="info_pop_win">
	<div class="win_title_tag">
		<h2 class="total_tit ">小区营销策略录入</h2>
	</div>
	<div class="wrapper" id="info_edit_win">
		<!--基本信息-->
		<div class="record_tit ico1">基本信息</div>
		<div class="record_tit_layout">
			<table class="record_tab" cellspacing="0" cellpadding="0">
				<tr>
					<th>分公司：</th>
					<td width="15%">
						<select id="areaNo" name="areaNo"></select>
					</td>
					<th>县区：</th>
					<td width="15%">
						<select id="cityNo" name="cityNo"></select>
					</td>
					<th>支局：</th>
					<td width="15%">
						<select id="centerNo" name="centerNo"></select>
					</td>
				</tr>
				<tr>
					<th>网格：</th>
					<td>
						<select id="gridNo" name="gridNo" ></select>
					</td>
					<th>小区类型：</th>
					<td width="15%">
						<e:select id="villageType" name="villageType"
								  items="${village_type.list}" label="TEXT" value="CODE"  class="easyui-combobox"
								  headLabel="全部" headValue=""  editable="false"/>
					</td>
					<th>小区名称：</th>
					<td>
						<select id="villageNo" name="villageNo" onchange="getVillageMsgBefore()"></select>
						<%-- <e:select id="village_id" name="village_id"
                              items="${village_list.list}" label="village_name" value="village_id"  class="easyui-combobox"
                              headLabel="全部" headValue=""  editable="false"/>  --%>
					</td>
				</tr>
			</table>
		</div>
		<!--基本信息end-->
		<!--小区现状-->
		<div class="record_tit ico2">小区现状</div>
		<div class="record_tit_layout">
			<table class="record_tab small_row_height" cellspacing="0" cellpadding="0">
				<tr>
					<th>住户数：</th>
					<td width="15%">
						<span id="zhu_hu_shu"></span>
					</td>
					<th>光宽用户数：</th>
					<td width="15%">
						<span id="gk_user_cnt"></span>
					</td>
					<th>宽带家庭渗透率：</th>
					<td width="15%">
						<span id="market_lv"></span>
					</td>
				</tr>
				<tr>
					<th>OBD数：</th>
					<td width="15%">
						<span id="obd_cnt"></span>
					</td>
					<th>光网覆盖率：</th>
					<td width="15%">
						<span id="gk_cover_lv"></span>
					</td>
					<th>端口占用率：</th>
					<td width="15%">
						<span id="port_used_lv"></span>
					</td>
				</tr>
				<tr>
					<th>竞争收集率：</th>
					<td width="15%">
						<span id="collect_lv"></span>
					</td>
					<th>异常用户占比：</th>
					<td width="15%">
						<span id="yc_user_lv"></span>
					</td>
					<th>宽带保有率</th>
					<td width="15%">
						<span id="kd_get_lv"></span>
					</td>
				</tr>
			</table>
		</div>

		<input type="hidden" id="hi_01" />
		<input type="hidden" id="hi_02" />
		<input type="hidden" id="hi_03" />
		<input type="hidden" id="hi_04" />
		<input type="hidden" id="hi_05" />
		<input type="hidden" id="hi_06" />
		<input type="hidden" id="hi_07" />
		<input type="hidden" id="hi_08" />
		<input type="hidden" id="hi_09" />
		<input type="hidden" id="hi_10" />
		<input type="hidden" id="hi_11" />
		<input type="hidden" id="hi_12" />
		<input type="hidden" id="hi_13" />
		<input type="hidden" id="hi_14" />
		<input type="hidden" id="hi_15" />
		<input type="hidden" id="hi_16" />
		<input type="hidden" id="hi_17" />
		<input type="hidden" id="hi_18" />
		<input type="hidden" id="hi_19" />
		<input type="hidden" id="hi_20" />
		
		<!--小区现状end-->
		<!--目标制定-->
		<div class="record_tit ico3">目标制定</div>
		<div class="record_tit_layout">
			<table class="record_tab" cellspacing="0" cellpadding="0">
				<tr>
					<th>三大业务渗透率：</th>
					<td width="15%">
						<input type="text" id="input_01"/>
					</td>
					<th>端口占用率：</th>
					<td width="15%">
						<input type="text" id="input_02"/>
					</td>
					<th>异常用户占比：</th>
					<td width="15%">
						<input type="text" id="input_03"/>
					</td>
				</tr>
				<tr>
					<th>单转融：</th>
					<td width="15%">
						<input type="text" id="input_04"/>
					</td>
					<th>到期续约：</th>
					<td width="15%">
						<input type="text" id="input_05"/>
					</td>
					<th>沉默激活：</th>
					<td width="15%">
						<input type="text" id="input_06"/>
					</td>
				</tr>
				<tr>
					<th>竞争信息收集率：</th>
					<td width="15%">
						<input type="text" id="input_07"/>
					</td>
					<td colspan="4">
					</td>
				</tr>
			</table>
		</div>
		<!--目标制定end-->
		<!--营销主题-->
		<div class="record_tit ico4">营销主题</div>
		<div class="record_tit_layout">
			<table class="record_tab" cellspacing="0" cellpadding="0">
				<tr>
					<th class="area_th">主题内容：</th>
					<td>
						<textarea type="textarea" rows="2" id="input_08" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<!--营销主题end-->
		<!--营销策略-->
		<div class="record_tit ico5">营销策略</div>
		<div class="record_tit_layout">
			<table class="record_tab" cellspacing="0" cellpadding="0">
				<tr>
					<th class="area_th">策略内容：</th>
					<td>
						<textarea type="textarea" rows="2" id="input_09" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<!--营销策略end-->
		<!--适配政策-->
		<div class="record_tit ico6">适配政策</div>
		<div class="record_tit_layout">
			<table class="record_tab" cellspacing="0" cellpadding="0">
				<tr>
					<th class="area_th">资费政策：</th>
					<td>
						<textarea type="textarea" class="wth2" rows="2" id="input_10" /></textarea>
					</td>
					<th class="area_th">销售政策：</th>
					<td>
						<textarea type="textarea" class="wth2" rows="2" id="input_11" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<!--适配政策end-->
		<!--销售组织-->
		<div class="record_tit ico7">销售组织</div>
		<div class="record_tit_layout">
			<table class="record_tab" cellspacing="0" cellpadding="0">
				<tr>
					<th class="area_th2">人员组织：</th>
					<td>
						<%--<input type="text" id="input_12" class="wth2" />--%>
						<textarea type="textarea" class="wth2" rows="1" id="input_12" style="height:26px!important;" /></textarea>
					</td>
					<th class="area_th2" rowspan="2">规定动作：</th>
					<td rowspan="2">
						<%--<input type="text" id="input_13" class="wth2" />--%>
						<textarea type="textarea" class="wth2" rows="2" id="input_13" /></textarea>
					</td>

				</tr>

				<tr>
					<th class="area_th2">营销方式：</th>
					<td>
						<textarea type="textarea" class="wth2" rows="1" id="input_14" style="height:26px!important;" /></textarea>
						<%--<input type="text" id="input_14" class="wth2" />--%>
					</td>

					<%--<td colspan="2">

                       </td>--%>

				</tr>
			</table>
		</div>
		<!--销售组织end-->
		<!--适配政策-->
		<div class="record_tit ico8">营销计划</div>
		<div class="record_tit_layout">
			<table class="record_tab" cellspacing="0" cellpadding="0">
				<tr>
					<th class="area_th">时间计划：</th>
					<td>
						<textarea type="textarea" rows="2" id="input_15" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<!--适配政策end-->
		<div class="button_layout"><button id="save_btn">保存</button><button id="cancel_btn">取消</button></div>
	</div>
</div>
</body>
</html>