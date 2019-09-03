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
<html>
<head>
	<title>住户视图</title>
	<meta charset="utf-8">
	<meta name="author" content="jasmine"><!-- 定义作者-->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css?version=1.3"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=2.2"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<e:url value="/resources/component/easyui/locale/easyui-lang-zh_CN.js"/>'></script>
	<style type="text/css">
		body{background-color:#fff;}

		.wrap_a {margin:0px 5px 0px 5px;color:#109afb;font-weight:bold;padding-left:10px;}
		#info_edit .wrap_a {margin:0px 5px 0px 10px;}
		.yin {height:auto;}
		.base {padding:0px 0px 0px 5px;}
		.table_yw td {text-align:left;}
		.combo-panel{z-index:99999}
		.product_type.village_new_searchbar.build_bar{margin:0 20px;width:96%;}
		#cell_num{font-size:12px;line-height:14px;margin-top:8px;}
		.cell_view {overflow-y:auto;}
		#card_name_div {vertical-align:middle;/*display:table-cell;*/margin-top:60px;}
		#card_add_ico {background-image:url('<e:url value="/pages/telecom_Index/common/images/channel_ico_new/community3.png"/>');width:60px;height:60px;background-repeat:no-repeat;}
		#card_add_list ol li {margin:10px 0;}
	</style>

	<script type="text/javascript" >
		//<![CDATA[
		$(function(){
			var $div_li =$("div.tab_menu ul li");
			$div_li.click(function(){
				$(this).addClass("selected")            //当前<li>元素高亮
						.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
				var index =  $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
				$("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
						.eq(index).show()   //显示 <li>元素对应的<div>元素
						.siblings().hide(); //隐藏其它几个同辈的<div>元素
			})
		})
		//]]>

	</script>

	<style type="text/css">
		.table_yw .manufacture span {
			cursor: pointer;
		}

		.table_yw {
			margin: 0px;
		}

		.info_input {
			border-bottom: solid 1px #ddd;
			width: 90px;
			padding: 1px 3px;
		}

		#cell_edit_dx_comments {
			border-bottom: solid 1px #ddd;
			width: 380px;
			padding: 1px 3px;
		}

		.wrap_a.tab_menu {
			font-weight: normal;
			color: #666;
			border-left: none;
			border-bottom: solid 1px #ddd;
			width: 97%;
			padding-left: 1%;
			margin: 5px auto 0px auto;
		}

		#history_list tr td:nth-child(1) {
			width: 8%;
		}

		#history_list tr td:nth-child(2) {
			width: 22%;
		}

		#history_list tr td:nth-child(3) {
			width: 52%;
		}

		#cell_view_title {
			margin: 12px auto 6px auto;
			height: 20px
		}

		.history_thead {
			width: 100%;
			padding-rigth: 17px;
		}

		.history_tbody {
			width: 100%;
			overflow-y: auto;
		}

		.village_tab.history {
			width: 100%;
		}

		.offerInThead {
			text-align: left !important;
			padding-left: 10px;
			color: #1a59c0;
			font-weight: bold;
			background-color: #fff !important;
		}

		#product_list_empty_tip {
			padding-top: 15px;
			text-align: center;
			display: none;
		}

		.taocan_flag_zhu {
			border-radius: 50%;
			background-color: #FFA620;
			font-size: 15px;
			color: #fff;
			padding: 4px 5px;
			margin-left: 10px;
		}

		.taocan_flag_fu {
			border-radius: 50%;
			background-color: #7FADF1;
			font-size: 15px;
			color: #fff;
			padding: 4px 5px;
			margin-left: 10px;
		}
	</style>
</head>
<body>
<span id="cell_view_title" class="village_name_new"></span>
<h3 class="wrap_a tab_menu"><span style="cursor:pointer;" class="selected">营销信息</span>&nbsp;|&nbsp;<span style="cursor:pointer;">营销历史</span>&nbsp;|<span style="cursor:pointer;display:none;">信息收集</span>&nbsp;<span style="cursor:pointer;">位置信息</span>&nbsp;|&nbsp;<span style="cursor:pointer;">产品构成</span></h3>

<div class="detail_block tab_box cell_view" style="background:none;">
	<!-- 营销信息 -->
	<div style="display:none;width:100%;padding: 0px;margin:0px;overflow:hidden;">
		<div class="market_exe_info">
			<div class="exe_user_info">
				联系人：<span id="cell_exe_constractor" style="margin-right:150px;"></span> 联系电话：<span
					id="cell_exe_constract_num"></span>
			</div>
			<!--<h3 class="wrap_a">特征信息</h3>
              <div id="tt1">
                产品构成：移动 --   固话 --  itv -- <br/>
                    账户收入：--<br/>
                    宽带收入：--<br/>
                    活跃度：  --
              </div>

              <h3 class="wrap_a">业务信息</h3>
              <div id="tt2">
                 产品构成：--<br/>
                用户套餐：--<br/>
                入网时间：--<br/>
                到期时间：--<br/>
                接入方式：--<br/>
                宽带速率：--
              </div>-->
			<div style="width:100%;border-bottom:dashed 1px #ddd;padding-bottom:8px">
				<h3 class="wrap_a" style="margin-top:5px;margin-left:7px;">营销推荐</h3>

				<div id="tt1" >
					<div style="margin-left:24px;">暂无营销</div>
				</div>

				<!--<h3 class="wrap_a" style="margin-top:5px;margin-left:7px;">用户资料</h3>

				<div id="tt2">
					<div class="all">用户套餐：--</div>
					<div class="half">入网时间：--</div>
					<div class="half">到期时间：--</div>
					<div class="half">接入方式：--</div>
					<div class="half">宽带速率：--</div>
				</div>-->
			</div>

			<h3 class="wrap_a" style="margin-top:5px;margin-left:7px;margin-top:8px;">执行</h3>

			<div class="doit">
				执行结果：&nbsp;<input type="radio" name="XXJ" value="1" checked="checked"/>成功办理 &nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="XXJ" value="2"/>同意办理 &nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="XXJ" value="3"/>待跟进 &nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="XXJ" value="4"/>不需要 &nbsp;&nbsp;&nbsp;&nbsp;<br/>
				备注: <input type="text" id="remark_note" maxlength="100" class="remark"/>
				<input type="hidden" id="add6" value=""/>
			</div>

		</div>
		<div class="operat">
			<span id="save_done_tip" style="display:none;">该纪录已执行</span>
			<button id="save_exe">确定</button>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<button id="cancel_exe">取消</button>
		</div>
	</div>
	<!-- 营销历史 -->
	<div style="display:none;width:98%;padding: 0px;margin:6px auto;overflow:hidden;">
		<div class="count_num" style="width:100%;text-align:left;color:#333;">记录数：<span id="history_num"></span></div>
		<div class="history_thead">
			<table class="village_tab history">
				<thead>
				<th width="8%">序号</th>
				<th width="22%">执行时间</th>
				<th width="52%">执行反馈</th>
				<th>执行人</th>
				</thead>
			</table>
		</div>
		<div class="history_tbody">
			<table class="village_tab history" id="history_list">

			</table>
		</div>
	</div>

	<!-- 信息收集 暂不用-->
	<div style="display:none;width:100%;padding: 0px;margin:0px;overflow:hidden;padding-bottom: 30px;">
		<div style="width:100%;border-bottom:dashed 1px #ddd;">
			<h3 class="wrap_a" style="margin-top:5px;margin-left:10px;">基础信息</h3>

			<div class="base" style="height:30px;border:none;margin-top:3px;">
				<table class="table_yw">
					<tr>
						<td width="52%">联系人：<input id="cell_edit_constractor" type="text" class="info_input"
												   style="width:200px;"/></td>
						<td>联系电话：<input id="cell_edit_constract_num" type="text" class="info_input"/></td>
						<td>人口数：<input id="cell_edit_people_num" type="text" class="info_input" style="width:30px;"/>
						</td>
					</tr>

				</table>
			</div>
		</div>

		<div class="yin">
			<h3 class="wrap_a">业务信息</h3>
			<table class="table_yw" style="margin-top:3px;">
				<tr>
					<td colspan="4">套餐：<span id="cell_edit_main_offer_name"></span></td>

				</tr>
				<tr>

					<td>接入方式：<span id="cell_edit_broad_mode"></span></td>

					<td>宽带速率：<span id="cell_edit_broad_rate"></span></td>
					<td>固话：<span id="cell_edit_gu_acc_nbr"></span><!--  宽带：&nbsp;&nbsp;<span id="cell_edit_is_kd"></span-->
					</td>
					<td>电视：&nbsp;&nbsp;&nbsp;<span id="cell_edit_is_itv"></span></td>
				</tr>

				<tr>
					<td colspan="3">备注：&nbsp;&nbsp;&nbsp;<input id="cell_edit_dx_comments" type="text"/></td>
				</tr>
			</table>
		</div>
		<!-- div class="yin">
            <h3 class="wrap_a">竞争信息</h3>
            <table class="table_yw info_get">
                <tr>
                    <td width="70">运营商：</td>
                    <td class="manufacture" id="cell_edit_operators_type"><input type="radio" value="1" name="cell_edit_operators_type"/> 移动&nbsp;&nbsp;&nbsp; <input type="radio" value="2" name="cell_edit_operators_type"/> 联通 &nbsp;&nbsp;&nbsp;<input type="radio" value="3" name="cell_edit_operators_type"/>广电</td>
                </tr>
                <tr>
                    <td>备注：</td><td><input id="cell_edit_comments" type="text" /></td>
                </tr>
            </table>
        </div -->
		<div class="yin" style="border:none;">
			<h3 class="wrap_a">竞争信息</h3>
			<table class="village_tab detail add_in" cellspacing="0" cellpadding="0"
				   style="margin:5px auto 0px auto;width:94%;">
				<thead>
				<tr>
					<th>产品</th>
					<th>数量</th>
					<th>运营商</th>
					<th>消费情况</th>
					<th>到期时间</th>
				</tr>
				</thead>
				<tr>
					<td width="90">手机</td>
					<td width="100"><input type="text" class="info_input" id="cell_edit_phone_count"/></td>
					<td width="100"><select class="manufucture" id="cell_edit_phone_business" style="width: 60px">
						<option value=1> 移动</option>
						<option value=2> 联通</option>
					</select></td>
					<td width="110"><input type="text" class="info_input" id="cell_edit_phone_xf"/></td>
					<td><input id="cell_edit_phone_dq_date" type="text" style="width:120px;"></td>
				</tr>
				<tr>
					<td>宽带</td>
					<td><input type="text" class="info_input" id="cell_edit_kd_count"/></td>
					<td><select class="manufucture" id="cell_edit_kd_business" style="width: 60px">
						<option value=1> 移动</option>
						<option value=2> 联通</option>
						<option value=3> 广电</option>
						<option value=4> 其他</option>
					</select></td>
					<td><input type="text" class="info_input" id="cell_edit_kd_xf"/></td>
					<td><input id="cell_edit_kd_dq_date" type="text" style="width:120px;"></td>
				</tr>
				<tr>
					<td>电视</td>
					<td><input type="text" class="info_input" id="cell_edit_itv_count"/></td>
					<td><select class="manufucture" id="cell_edit_itv_business" style="width: 60px">
						<option value=1> 移动</option>
						<option value=2> 联通</option>
						<option value=3> 广电</option>
						<option value=4> 其他</option>
					</select></td>
					<td><input type="text" class="info_input" id="cell_edit_itv_xf"/></td>
					<td><input id="cell_edit_itv_dq_date" type="text" style="width:120px;"></td>
				</tr>
			</table>
		</div>
		<input type="hidden" value="" id="hiddin"/>

		<div class="button_area" style="border:none;margin-top:0px;padding:0px;">
			<button id="save_cell_info">确定</button>
			&nbsp;&nbsp;&nbsp;
			<button id="cancel_cell_info">取消</button>
		</div>
	</div>

	<!-- 位置信息 -->
	<div style="padding-top:30px;">
		<div style="width:35%;height:75%;border-right:2px #00f solid;float:left;display:table;vertical-align:middle;">
			<div id="card_name_div"></div>
		</div>
		<div style="width:65%;height:75%;float:right;padding:30px 0px 0px 10px;">
			<div id="card_add_ico"></div>
			<div id="card_add_list"></div>
		</div>
	</div>

	<!-- 产品构成 -->
	<div>
		<div class="history_thead" id="product_list_thead">
			<table class="village_tab history">
				<thead>
					<th colspan="3" id="product_main_offer_name" class="offerInThead"></th>
				</thead>
				<thead>
					<th colspan="3" id="protocol_time" class="offerInThead"></th>
				</thead>
				<thead>
					<th width="8%">序号</th>
					<th width="52%">产品号码</th>
					<th>产品类型</th>
				</thead>
			</table>
		</div>
		<div class="history_tbody" id="product_list_tbody">
			<table class="village_tab history" id="produce_list">
			</table>
		</div>
		<div id="product_list_empty_tip">
			<span>暂无产品构成	</span>
		</div>
	</div>

</div>

<script type="text/javascript">
	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
	var add6 = '${param.add6}';
	//var prod_inst_id = '${param.prod_inst_id}';
	var flag = '${param.flag}';
	var build_position = parent.build_position;

	$(function () {
		var $div_li = $(".tab_menu span");
		$div_li.click(function () {
			$(this).addClass("selected")            //当前<li>元素高亮
					.siblings().removeClass("selected");  //去掉其它同辈<li>元素的高亮
			var index = $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
			$("div.tab_box > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
					.eq(index).show()   //显示 <li>元素对应的<div>元素
					.siblings().hide(); //隐藏其它几个同辈的<div>元素
		})

		if (flag == "info")//已废弃，用竞争资料收集代替
			$(".tab_menu").find("span").eq(2).click();
		else if(flag == "history")
			$(".tab_menu").find("span").eq(1).click();
		else if (flag == "exe")
			$(".tab_menu").find("span").eq(0).click();

		//query_exe_info(prod_inst_id);
		query_exe_info(add6);
		query_yx_history(add6);
		query_cell_info(add6);
		query_cell_position(add6);
		query_product_list(add6);

		$("#cancel_cell_info").click(function () {
			parent.closeCellViewIFrame(0);
		});
		$("#cancel_exe").click(function () {
			parent.closeCellViewIFrame(0);
		});

		$("#cell_edit_phone_dq_date").datebox({
			editable:false,
			onSelect: function(date){
				//alert(date.getFullYear()+":"+(date.getMonth()+1)+":"+date.getDate());
				$('#cell_edit_phone_dq_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});
		$("#cell_edit_kd_dq_date").datebox({
			editable:false,
			onSelect: function(date){
				$('#cell_edit_kd_dq_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});
		$("#cell_edit_itv_dq_date").datebox({
			editable:false,
			onSelect: function(date){
				$('#cell_edit_itv_dq_date').datebox('setValue', date.getFullYear()+"年"+(date.getMonth()+1<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))+"月"+(date.getDate()<10?"0"+date.getDate():date.getDate())+"日");
			}
		});

		$(".datebox-button").each(function(index){
			$(this).append("<a href=\"javascript:void(0)\" class=\"datebox-clear\" onclick=\"javascript:clearDateBox("+index+");\" >清除</a>");
		});
	})

	function clearDateBox(index){
		if(index==0){
			$("#cell_edit_phone_dq_date").datebox("setValue", "");
			$("#cell_edit_phone_dq_date").datebox("hidePanel");
		}else if(index==1){
			$("#cell_edit_kd_dq_date").datebox("setValue", "");
			$("#cell_edit_kd_dq_date").datebox("hidePanel");
		}else if(index==2){
			$("#cell_edit_itv_dq_date").datebox("setValue", "");
			$("#cell_edit_itv_dq_date").datebox("hidePanel");
		}
	}

	//营销资料查询
	function query_exe_info(add6) {
		$("#cell_exe_constractor").text("");
		$("#cell_exe_constract_num").text("");

		if (add6 == null || add6 == 'null') {
			return;
		}

		$.ajax({
			type: "post",
			url: url4Query,
			data: {
				"eaction": "yx_detail_query_list_six_add6", //yx_detail_query_list_info
				"add6": add6
			},
			async: false,
			dataType: "json",
			success: function (data) {

				var obj = data[0];
				var room_name = obj.STAND_NAME_2;
				if(room_name==null){
					room_name = obj.STAND_NAME_1 || obj.SEGM_NAME_1 || obj.SEGM_NAME_2
				}

				$("#cell_view_title").text(room_name);
				$("#add6").val(add6);

				$("#cell_exe_constractor").text(obj.CONTRACT_PERSON == null ? "" : obj.CONTRACT_PERSON);
				$("#cell_exe_constract_num").text(obj.CONTRACT_IPHONE == null ? "" : obj.CONTRACT_IPHONE);

				var temp1 = "";
				//var temp2 = "";

				$("#tt1").html("");
				//$("#tt2").html("");

				//营销推荐表格生成 ↓
				temp1 += "<table class='yinxiaotuijian_table'>";
				for(var i = 0,l = data.length;i<l;i++){
					var row_str = "<tr>";
					var d = data[i];
					if(d.ACC_NBR==null){
					}else{
						row_str += "<td>"+d.ACC_NBR+"</td>";
						row_str += "<td>"+loadSuggest(d.CONN_STR)+"</td>";
						row_str += "</tr>";
						temp1 += row_str;
					}

				}
				temp1 += "</table>";
				//营销推荐表格生成 ↑

				//temp1 += " 产品构成：移动     " + (obj.A1==null?'--':obj.A1) + "   固话   " + (obj.A2==null?'--':obj.A2) + "  itv " + (obj.A3==null?'--':obj.A3) + " <br/>";
				//temp1 += "账户收入：" + (obj.A4==null?'--':obj.A4) + "元<br/>";
				//temp1 += "宽带收入：" + (obj.A5==null?'--':obj.A5) + "元<br/>";
				//temp1 += "活跃度：" + (obj.A6==null?'--':obj.A6) + "";

				/*temp2 += "<div class=\"all\">用户套餐：" + (obj.A8 == null ? '--' : obj.A8) + "</div>";
				var rong_he_tao_can = obj.A7;
				if (rong_he_tao_can == null)
					rong_he_tao_can = "--";


				temp2 += "<div class=\"half\">入网时间：" + (obj.A9 == null ? '--' : obj.A9) + "</div>";
				var dao_qi_shi_jian = obj.A10;
				if (dao_qi_shi_jian == null)
					dao_qi_shi_jian = "--";
				temp2 += "<div class=\"half\">到期时间：" + dao_qi_shi_jian + "</div>";
				temp2 += "<div class=\"half\">接入方式：" + (obj.A11 == null ? '--' : obj.A11) + "</div>";
				temp2 += "<div class=\"half\">宽带速率：" + (obj.A12 == null ? '--' : obj.A12) + "</div>";*/
				$("#tt1").html(temp1);

				$("#save_exe").unbind();
				if($(".yinxiaotuijian_table").children("tbody").children().length==0){
					$("#tt1").html("<span style=\"padding-left:16px;\">暂无营销推荐</span>");
					$("#save_exe").css({"background-color":"#c6c8ca"}).on("click",function(){layer.msg("没有可营销的信息");});
				}else{
					$("#save_exe").css({"background-color":"#1479c0"}).on("click",function(){execute();});
				}



				//$("#tt2").html(temp2);

				$("#exec_detail").show();
				if (obj.DID_FLAG != null && obj.DID_FLAG != "") {
					$("#save_exe").hide();
					$("#save_done_tip").show();
				}
				else {
					$("#save_exe").show();
					$("#save_done_tip").hide();
				}
			}
		});
	}

	//按产品id查询出的营销资料，已废弃
	function query_exe_info_nouse_bak(id) {
		$("#cell_exe_constractor").text("");
		$("#cell_exe_constract_num").text("");

		if (id == null || id == 'null') {
			return;
		}

		$.ajax({
			type: "post",
			url: url4Query,
			data: {
				"eaction": "yx_detail_query_list_info",
				"prodid": id
			},
			async: false,
			dataType: "json",
			success: function (data) {
				var obj = data[0];
				$("#prodid").val(id);

				$("#cell_exe_constractor").text(obj.CONTRACT_PERSON == null ? "" : obj.CONTRACT_PERSON);
				$("#cell_exe_constract_num").text(obj.ACC_NBR == null ? "" : obj.ACC_NBR);

				var temp1 = "";
				var temp2 = "";

				$("#tt1").html("");
				$("#tt2").html("");

				temp1 = loadSuggest(obj.CONN_STR);
				//temp1 += " 产品构成：移动     " + (obj.A1==null?'--':obj.A1) + "   固话   " + (obj.A2==null?'--':obj.A2) + "  itv " + (obj.A3==null?'--':obj.A3) + " <br/>";
				//temp1 += "账户收入：" + (obj.A4==null?'--':obj.A4) + "元<br/>";
				//temp1 += "宽带收入：" + (obj.A5==null?'--':obj.A5) + "元<br/>";
				//temp1 += "活跃度：" + (obj.A6==null?'--':obj.A6) + "";

				temp2 += "<div class=\"all\">用户套餐：" + (obj.A8 == null ? '--' : obj.A8) + "</div>";
				var rong_he_tao_can = obj.A7;
				if (rong_he_tao_can == null)
					rong_he_tao_can = "--";
				//temp2 += " <div class=\"all\">融合套餐：" + rong_he_tao_can + "</div>";

				temp2 += "<div class=\"half\">入网时间：" + (obj.A9 == null ? '--' : obj.A9) + "</div>";
				var dao_qi_shi_jian = obj.A10;
				if (dao_qi_shi_jian == null)
					dao_qi_shi_jian = "--";
				temp2 += "<div class=\"half\">到期时间：" + dao_qi_shi_jian + "</div>";
				temp2 += "<div class=\"half\">接入方式：" + (obj.A11 == null ? '--' : obj.A11) + "</div>";
				temp2 += "<div class=\"half\">宽带速率：" + (obj.A12 == null ? '--' : obj.A12) + "</div>";
				$("#tt1").html(temp1);
				$("#tt2").html(temp2);

				$("#exec_detail").show();
				if (obj.DID_FLAG != null && obj.DID_FLAG != "") {
					$("#save_exe").hide();
					$("#save_done_tip").show();
				}
				else {
					$("#save_exe").show();
					$("#save_done_tip").hide();
				}
			}
		});
	}

	//营销执行
	function execute() {
		layer.confirm('您确定提交吗？', {
					btn: ['确定', '取消'] //按钮
				}, function (index) {
					if (add6 == null || add6 == 'null') {
						layer.msg("没有可营销的信息");
						return;
					}

					var typeid = $("input[name='XXJ']:checked").val();
					var note = $("#remark_note").val();

					if (typeid === "") {
						layer.msg(" 执行结果为必选项");
						return;
					}

					$.ajax({
						type: "post",
						url: url4Query,
						data: {
							"eaction": "updatevalbroadbd",
							"didflag": typeid,
							"desc": note,
							//"proid": prod_inst_id,
							"add6": add6
						},
						async: false,
						dataType: "text",
						success: function (data) {
							if (data.indexOf("1") != -1) {
								layer.msg("执行成功.");
								setTimeout(function(){
									parent.closeCellViewIFrame(1);
								},1500);
							}
						}
					});

				}, function (index) {
					layer.close(index);
				}
		);

	}

  //营销历史
	function query_yx_history(add6) {
		$("#history_list").empty();
		if (add6 == null || add6 == "null") {
			$("#history_num").text(0);
			history_list_empty_tr_add();
			return;
		}
		$.post(url4Query, {eaction: 'getYX_history', add6: add6}, function (data) {
			data = $.parseJSON(data);
			$("#history_num").text(data.length);
			if (data.length == 0)
				history_list_empty_tr_add();
			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var rowNew = "<tr><td>" + (i + 1) + "</td><td>" + d.DID_TIME + "</td><td>" + d.DID_DESC + "</td><td>" + d.USER_NAME + "</td></tr>";
				$("#history_list").append(rowNew);
			}
		});
	}

	//营销历史表格为空时添加几行空行
	function history_list_empty_tr_add() {
		for (var i = 0, l = 5; i < l; i++) {
			var rowNew = "<tr><td></td><td></td><td></td><td></td></tr>";
			$("#history_list").append(rowNew);
		}
	}
	//位置信息中的联系人名和联系电话
	function query_cell_info(add6){
		$.post(url4Query, {eaction: 'getCellInfo', segm_id_2: add6}, function (data) {
			data = $.parseJSON($.trim(data));
			if (data == null)
				return;
			query_cell_card_name(data.CONTACT_PERSON,data.CONTACT_NBR);
		});
	}
	//住户资料查询 暂时不用 用竞争收集代替了
	function query_cell_info_nouse(add6) {
		$("#cell_edit_constractor").text("");
		$("#cell_edit_constract_num").text("");
		$("#cell_edit_people_num").text("");
		$("#cell_edit_is_kd").text("");
		$("#cell_edit_broad_mode").text("");
		$("#cell_edit_broad_rate").text("");
		$("#cell_edit_is_itv").text("");
		$("#cell_edit_gu_acc_nbr").text("");
		$("#cell_edit_main_offer_name").text();
		$("#cell_edit_dx_comments").val("");

		$.post(url4Query, {eaction: 'getCellInfo', segm_id_2: add6}, function (data) {
			data = $.parseJSON($.trim(data));
			if (data == null)
				return;
			//$("#cell_edit_add6").text(data.STAND_NAME_2);

			$("#cell_edit_constractor").val(data.CONTACT_PERSON);
			$("#cell_edit_constract_num").val(data.CONTACT_NBR);
			query_cell_card_name(data.CONTACT_PERSON,data.CONTACT_NBR);
			$("#cell_edit_people_num").val(data.PEOPLE_COUNT);
			$("#cell_edit_is_kd").text(data.IS_KD);
			$("#cell_edit_broad_mode").text(data.BROAD_MODE);
			$("#cell_edit_broad_rate").text(data.BROAD_RATE);
			$("#cell_edit_is_itv").text(data.IS_ITV);
			$("#cell_edit_gu_acc_nbr").text(data.GU_ACC_NBR);

			$("#cell_edit_main_offer_name").text(data.MAIN_OFFER_NAME);
			$("#cell_edit_dx_comments").val(data.DX_COMMENTS);
			if (data.OPERATORS_TYPE == 1)//移动
				$("input[name='cell_edit_operators_type']:eq(0)").attr("checked", "checked");
			else if (data.OPERATORS_TYPE == 2)//联通
				$("input[name='cell_edit_operators_type']:eq(1)").attr("checked", "checked");
			else if (data.OPERATORS_TYPE == 3)//广电
				$("input[name='cell_edit_operators_type']:eq(2)").attr("checked", "checked");
			$("#cell_edit_comments").val(data.COMMENTS);

			//资料维护新增内容
			$('#cell_edit_phone_count').val(data.PHONE_COUNT);
			$('#cell_edit_phone_business').val(data.PHONE_BUSINESS);
			$('#cell_edit_phone_xf').val(data.PHONE_XF);
			$('#cell_edit_phone_dq_date').datebox('setValue',data.PHONE_DQ_DATE);

			$('#cell_edit_kd_count').val(data.KD_COUNT);
			$('#cell_edit_kd_business').val(data.KD_BUSINESS);
			$('#cell_edit_kd_xf').val(data.KD_XF);
			$('#cell_edit_kd_dq_date').datebox('setValue',data.KD_DQ_DATE);

			$('#cell_edit_itv_count').val(data.ITV_COUNT);
			$('#cell_edit_itv_business').val(data.ITV_BUSINESS);
			$('#cell_edit_itv_xf').val(data.ITV_XF);
			$('#cell_edit_itv_dq_date').datebox('setValue',data.ITV_DQ_DATE);
		})
	}

	//资料维护 保存信息
	$("#save_cell_info").click(function () {
		var contact_person = $("#cell_edit_constractor").val();
		var contact_nbr = $("#cell_edit_constract_num").val();
		var people_count = $("#cell_edit_people_num").val();
		var dx_comments = $("#cell_edit_dx_comments").val();

		///var operators_type = $("input[name='cell_edit_operators_type']:checked").val();
		var operators_type = '';
		///var comments = $("#cell_edit_comments").val();
		var comments = '';

		//竞争信息，新内容
		var phone_count = $("#cell_edit_phone_count").val();
		var phone_business = $("#cell_edit_phone_business").val();
		var phone_xf = $("#cell_edit_phone_xf").val();
		var phone_dq_date = $("#cell_edit_phone_dq_date").datebox("getValue");
		if (phone_dq_date != "")
			phone_dq_date = phone_dq_date.replace(/年|月|日/g, '-').substr(0, phone_dq_date.length - 1);

		var kd_count = $("#cell_edit_kd_count").val();
		var kd_business = $("#cell_edit_kd_business").val();
		var kd_xf = $("#cell_edit_kd_xf").val();
		var kd_dq_date = $("#cell_edit_kd_dq_date").datebox("getValue");
		if (kd_dq_date != "")
			kd_dq_date = kd_dq_date.replace(/年|月|日/g, '-').substr(0, kd_dq_date.length - 1);

		var itv_count = $("#cell_edit_itv_count").val();
		var itv_business = $("#cell_edit_itv_business").val();
		var itv_xf = $("#cell_edit_itv_xf").val();
		var itv_dq_date = $("#cell_edit_itv_dq_date").datebox("getValue");
		if (itv_dq_date != "")
			itv_dq_date = itv_dq_date.replace(/年|月|日/g, '-').substr(0, itv_dq_date.length - 1);

		//号码验证不通过时，标注错误的号码编辑框位置
		var invaildInput = new Array();
		var num_invaildInput = new Array();
		var flag = true;
		var flag_num = true;
		var phone_nums = contact_nbr.split(",");

		for (var i = 0, l = phone_nums.length; i < l; i++) {
			var item = phone_nums[i];
			if (item != '' && !( /^(0|86|17951)?(13[0-9]|15[012356789]|17[01678]|18[0-9]|14[57])[0-9]{8}$/.test(item) || /^(0[0-9]{2,3}\-)([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$/.test(item))) {
				flag = false;
				invaildInput.push("cell_edit_constract_num");
				break;
			}
		}
		if (phone_count != '' && !(/^[0-9]*$/.test(phone_count))) {
			flag_num = false;
			num_invaildInput.push("cell_edit_phone_count");
		}
		/*if(phone_xf!='' && !(/^[0-9]*$/.test(phone_xf))){
		 flag_num = false;
		 num_invaildInput.push("cell_edit_phone_xf");
		 }*/
		 if(kd_count!='' && !(/^[0-9]*$/.test(kd_count))){
			 flag_num = false;
			 num_invaildInput.push("cell_edit_kd_count");
		 }
		 /*if(kd_xf!='' && !(/^[0-9]*$/.test(kd_xf))){
		 flag_num = false;
		 num_invaildInput.push("cell_edit_kd_xf");
		 }*/
		if (itv_count != '' && !(/^[0-9]*$/.test(itv_count))) {
			flag_num = false;
			num_invaildInput.push("cell_edit_itv_count");
		}
		/*if(itv_xf!='' && !(/^[0-9]*$/.test(itv_xf))){
		 flag_num = false;
		 num_invaildInput.push("cell_edit_itv_xf");
		 }*/

		$("#cell_edit_constract_num").next().remove();

		$("#cell_edit_phone_count").next().remove();
		//$("#cell_edit_phone_xf").next().remove();
		$("#cell_edit_kd_count").next().remove();
		//$("#cell_edit_kd_xf").next().remove();
		$("#cell_edit_itv_count").next().remove();
		//$("#cell_edit_itv_xf").next().remove();

		if (flag && flag_num) {
			layer.confirm('您确定提交吗？', {
				btn: ['确定', '取消'] //按钮
			}, function (index) {
				$.post(
						url4Query,
						{
							'eaction': 'updateYX',
							'segm_id_2': add6,
							'contact_person': contact_person,
							'contact_nbr': contact_nbr,
							'people_count': people_count,
							'dx_comments': dx_comments,
							'operators_type': operators_type,
							'comments': comments,

							//资料维护新增内容↓
							'phone_count': phone_count,
							'phone_business': phone_business,
							'phone_xf': phone_xf,
							'phone_dq_date': phone_dq_date,

							'kd_count': kd_count,
							'kd_business': kd_business,
							'kd_xf': kd_xf,
							'kd_dq_date': kd_dq_date,

							'itv_count': itv_count,
							'itv_business': itv_business,
							'itv_xf': itv_xf,
							'itv_dq_date': itv_dq_date
						},
						function (data) {
							layer.msg("修改成功!");
							layer.close(index);
							setTimeout(function () {
								parent.closeCellViewIFrame(1);
							}, 1500);
						}
				)
			}, function (index) {
				layer.close(index);
			});
		} else {
			if (!flag) {
				layer.msg("请输入正确的联系电话!");
				for (var i = 0, l = invaildInput.length; i < l; i++) {
					var elem_str = invaildInput[i];
					$("#" + elem_str).after("<span style='color:red;'>*</span>");
				}
			}
			if (!flag_num) {
				layer.msg("请输入正确的数字格式!");
				for (var i = 0, l = num_invaildInput.length; i < l; i++) {
					var elem_str = num_invaildInput[i];
					$("#" + elem_str).after("<span style='color:red;'>*</span>");
				}
			}
		}
	});

	function loadSuggest(sug) {
		if(sug==null || sug=="" || sug==undefined || sug=="undefined" || sug=="null")
			return;
		//sug的结果最多有三个值 ，可能是：0个值=空；1个值=aa<C>aa1111<A>；2个值=aa<C>aa1111<A>bb<C>bb2222<A>；3个值=aa<C>aa1111<A>bb<C>bb2222<A><cc><C>cc3333<A>

		//sug = '价值提升营销加副卡策略<C>目标用户： 单产品无主副卡存量用户、无协议、终端在网时长>24个月、ARPU值50~80元。营销策略：预存790元=890元分摊话费(24个月实际消费的42%返还)+赠送市场价890元的华为8813Q手机一部，但需加开副卡，两卡共享89元。<A>适合套餐提档乐享3G上网版V4.0-89元<C>bbbbb<A>适合推荐手机报<C>ccccccccccccc<A>系统-推荐终端升级营销<C>目标用户：用户终端使用一年以上且当前无有效合约；<A>';
		var arry = sug.split("<a>");
		var n = arry.length;
		$('#view_suggest_number').html(n - 1);//给营销推荐个数赋值
		var html = '';
		//<li><em>2</em> <strong><a href="#this">适合套餐提档乐享3G上网版V4.0-89元</a></strong>目标用户：单产品无主副卡存量用户、无协议。终端在网时长>24个月、ARPU值50~80元</li>
		for (var i = 0; i < n - 1; i++) {
			var sub = arry[i].split("<c>");
			var idx = i + 1;
			if (i == 0) {
				html += '<li><em>' + idx + '</em><a style="font-weight:bold;display: block" href="javascript:suggestDetail(' + idx + ',' + n + ');">' + sub[0] + '</a><span id="view_suggest_p_' + idx + '">&nbsp;&nbsp;&nbsp;&nbsp;' + sub[1] + '</span>';
			} else {
				html += '<li><em>' + idx + '</em><a style="font-weight:bold;display: block" href="javascript:suggestDetail(' + idx + ',' + n + ');">' + sub[0] + '</a><span id="view_suggest_p_' + idx + '">&nbsp;&nbsp;&nbsp;&nbsp;' + sub[1] + '</span>';
			}
		}
		return html;
	}
	function suggestDetail(v, n) {
		$('#view_suggest_p_' + v).toggle();
		for (var i = 1; i < n; i++) {
			if (i != v) {
				$('#view_suggest_p_' + i).hide();
			}
		}
	}
	function query_cell_card_name(person_name,phone_num){
		$("#card_name_div").empty();
		var table_name_str = "<table style=\"margin:auto;\">";
		if(person_name==null && phone_num==null){
			table_name_str += "<tr><td><span style=\"font-size:10px;\">暂无联系方式</span></td></tr>";
		}else{
			table_name_str += "<tr><td><span style=\"font-size:18px;font-weight:bold;\">"+(person_name==null?"--":person_name)+"|</span><span style=\"font-size:10px;\">联系人</span><td></tr>";
			table_name_str += "<tr><td><span style=\"font-size:18px;font-weight:bold;\">"+(phone_num==null?"--":phone_num)+"</span><td></tr>";
		}
		table_name_str += "</table>";
		$("#card_name_div").append(table_name_str);
	}
	function query_cell_position(add6){
		$("#card_add_list").empty();
		var table_add_str = "<ol>";
		if(build_position=="" || build_position===undefined){
			build_position = new Array(5);
			$.post(url4Query,{"eaction":"getBuildPositionByAdd6","add6":add6},function(data){
				data = $.parseJSON(data);
				build_position.splice(0,1,data.LATN_NAME);
				build_position.splice(1,1,data.BUREAU_NAME);
				build_position.splice(2,1,data.BRANCH_NAME);
				build_position.splice(3,1,data.GRID_NAME);
				build_position.splice(4,1,data.VILLAGE_NAME);

				table_add_str += "<li>分公司："+(build_position[0]==' '?'--':build_position[0])+"</li>";
				table_add_str += "<li>区县："+(build_position[1]==' '?'--':build_position[1])+"</li>";
				table_add_str += "<li>支局："+(build_position[2]==' '?'--':build_position[2])+"</li>";
				table_add_str += "<li>网格："+(build_position[3]==' '?'--':build_position[3])+"</li>";
				table_add_str += "<li>小区："+((build_position[4]==" " || build_position[4]=="undefined" || build_position[4]==undefined)?"--":build_position[4])+"</li>";
				table_add_str += "</ol>";
				$("#card_add_list").append(table_add_str);
			});
		}else{
			try{
				//table_add_str += "<li>省份："+province_name+"</li>";
				table_add_str += "<li>分公司："+(build_position[0]==undefined?'--':build_position[0])+"</li>";
				table_add_str += "<li>区县："+(build_position[1]==undefined?'--':build_position[1])+"</li>";
				table_add_str += "<li>支局："+(build_position[2]==undefined?'--':build_position[2])+"</li>";
				table_add_str += "<li>网格："+(build_position[3]==undefined?'--':build_position[3])+"</li>";
				table_add_str += "<li>小区："+((build_position[4]==" " || build_position[4]=="undefined" || build_position[4]==undefined)?"--":build_position[4])+"</li>";
				table_add_str += "</ol>";
				$("#card_add_list").append(table_add_str);
			}catch(e){

			}
		}
	}

	function query_product_list(add6){
		$("#produce_list").empty();
		$("#product_main_offer_name").text("");
		$("#protocol_time").text("");
		$.post(url4Query,{eaction:"getCellProductList",add6:add6},function(data){
			data = $.parseJSON(data);
			if(data == "" || data.length==0){
				$("#product_list_thead").hide();
				$("#product_list_tbody").hide();
				$("#product_list_empty_tip").show();
			}else{
				$("#product_list_thead").show();
				$("#product_list_tbody").show();
				$("#product_list_empty_tip").hide();

				//产品列表中按规则取数放在表格表头前两行，规则 comp_flag字段判断，是融合就取手机套餐，否则取宽带，没有宽带取itv，没有itv取固话。
				setTabHead(data);
				// 当有多个主卡的时候，标记第一个为主卡。
				var isZhuFirst = true;

				for(var i = 0,l = data.length;i<l;i++){
					var d= data[i];

					//已废弃：第一条数据放在表格表头前两行 改为setTabHead方法
					/*if(i==0){
						$("#product_main_offer_name").text("主套餐："+d.MAIN_OFFER_NAME);
						$("#protocol_time").text("协议生效时间："+d.EFF_DATE);
					}*/

					var row = "<tr>";
					row += "<td style=\"width:8%;\">"+(i+1)+"</td>";

					row += "<td style=\"width:52%;text-align:left;padding-left:10px;\">";

					//主副卡判断
					if(d.IS_ZHU=="1"){
						row += "<span style=\"color:#67BBF5;font-weight:bold;\">"+d.ACC_NBR+"</span>";
						if(isZhuFirst){
							row += "<span class=\"taocan_flag_zhu\">主</span>";
						}
						isZhuFirst = false;
					} // if(i==0)

					else if(d.IS_ZHU=="2") // if(i==1)
						row += "<span style=\"color:#67BBF5;\">"+d.ACC_NBR+"</span><span class=\"taocan_flag_fu\">副</span>";
					else
						row += "<span style=\"color:#000;\">"+d.ACC_NBR+"</span>";
					row += "</td>";

					row += "<td>"+d.PRODUCT_TYPE+"</td>";
					row += "</tr>";
					$("#produce_list").append(row);
				}
			}
		});
		//表格表头前两行 放数据的方法
		function setTabHead(data){
			var result = new Array();
			var level_sort_array = new Array();
			for(var i = 0,l = data.length;i<l;i++){
				var d = data[i];
				level_sort_array.push(d.MAIN_OFFER_LEVEL);
				var temp = result[d.MAIN_OFFER_LEVEL+""];
				if(temp==undefined){
					result[d.MAIN_OFFER_LEVEL+""] = d;
				}
			}
			var headObj = result[level_sort_array.sort()[0]];
			$("#product_main_offer_name").text("主套餐："+headObj.MAIN_OFFER_NAME);
			$("#protocol_time").text("协议生效时间："+headObj.EFF_DATE);
		}

	}
</script>
</body>
</html>