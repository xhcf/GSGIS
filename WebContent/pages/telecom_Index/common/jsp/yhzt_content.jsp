<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="yhzt_list">
	select dd.segm_id CODE,dd.stand_name TEXT
	from gis_data.TB_GIS_VILLAGE_ADDR4 ff,
		 sde.TB_GIS_MAP_SEGM_LATN_MON dd
	where ff.segm_id = dd.segm_id
	and ff.village_id='${param.village_id}'
	order by TEXT
</e:q4l>
<e:q4o var="last_month">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>
<head>
	<title>异常用户 流失用户</title>
	<style>
		.tip {
			margin-left:18px;
			margin-top:5px;
			display:none;
		}
		.center {text-align:center!important;padding-left:0px!important;color:#328ECE;}
		.important {color:#2E40E7;}
		.bold_blue a{font-weight: normal;text-decoration: underline;}
		.layui-layer-title {text-align: center;padding:0px;}
		.yhzt_exec_tab_body{height:56%;}
		.toViewWin span {
			text-decoration: underline;
			cursor:pointer;
			color:blue;
		}
		.radio span{padding:0 8px;}

		.layui-layer-setwin{top:5px;}
		.layui-layer-setwin .layui-layer-close1{background-position:0px -38px;}
		#sum_record {cursor:default;color:#f00;}
		#sum_record:hover {color:#f00;}

		/*表头 表体*/
		.tab_header tr th:first-child {width:5%!important;}
		.tab_header tr th:nth-child(2) {width:40%!important;}
		.tab_header tr th:nth-child(3) {width:10%!important;}
		.tab_header tr th:nth-child(4) {width:15%!important;}
		.tab_header tr th:nth-child(5) {width:10%!important;}
		.tab_header tr th:nth-child(6) {width:10%!important;}
		.tab_header tr th:nth-child(7) {width:10%!important;}

		#village_view_build_listByYhzt {width:100%;}

		#village_view_build_listByYhzt tr td:first-child {width:5%!important;}
		#village_view_build_listByYhzt tr td:nth-child(2) {width:40%!important;}
		#village_view_build_listByYhzt tr td:nth-child(3) {width:10%!important;padding-left:0px!important;}
		#village_view_build_listByYhzt tr td:nth-child(4) {width:15%!important;}
		#village_view_build_listByYhzt tr td:nth-child(5) {width:10%!important;}
		#village_view_build_listByYhzt tr td:nth-child(6) {width:10%!important;}
		#village_view_build_listByYhzt tr td:nth-child(7) {width:10%!important;}

		.inside_data_orange {
			text-align: center!important;
		}

		span .deny_span {
			color:#aaa;
			cursor:not-allowed;
		}
		b {font-size:12px;font-weight: normal;color:#666;}
	</style>
</head>
<body>
    <a href="#" id="lsyh_win" style="display: none;position: absolute;right:28px;top:80px;">流失用户</a>
	<!----------------------------用户质态----------20180414------------- 开始---------------------->
	<div class="village_new_searchbar">
		<table style="width:100%">
			<tr>
				<td>
					<div class="count_num desk_orange_bar inside_data inside_data_orange">
						<!--小区光宽用户：<span id="head_all" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
						<!--
                        其中：沉默用户：<span id="head_cm" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                        欠费用户：<span id="head_owe" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                        拆机用户：<span id="head_remove" style ="color:#FF0000">0</span>
                        -->
						拆机<b>(近一年拆机)</b>：<span id="head_remove" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						欠停<b>(3个月及以上欠停)</b>：<span id="head_stop" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<!--欠费：<span id="head_owe" style ="color:#FF0000">0</span>&nbsp;&nbsp;-->
						沉默<b>(连续三月沉默)</b>：<span id="head_cm" style="color:#FF0000">0</span><!--&nbsp;&nbsp;
					非计费：<span id="head_fei" style ="color:#FF0000">0</span>-->
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
						<div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
							楼宇:
							<select id="yhzt_collect_new_build_list" onchange="yhzt_load_build_info(0)"
									style="width: 94%;padding-left:0px;"></select>
							<input type="text" id="yhzt_collect_new_build_name" oninput="yhzt_load_build_name_list()"
								   style="width: 80%;border:none;margin:1px;">
							<ul id="yhzt_collect_new_build_name_list"
								style="width:92%;margin-left:0;z-index:999999;position: absolute;">
							</ul>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					 <span>
						 <div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" id="hyzt_tb"
							  style="border-bottom: none;width:30%;padding-left:0px;float:left;margin-left:2.5%;">
							 流失状态：
							 <span class="active" value="0">全部 <!--(<span id="sub_all" style ="color:#FF0000">0</span> )--></span>
							 <span value="1">拆机 <!--(<span id="sub_remove" style ="color:#FF0000">0</span> )--></span>
							 <span value="2">欠停 <!--(<span id="sub_stop" style ="color:#FF0000">0</span> )--></span>
							 <span value="3" style='display:none;'>欠费 <!--(<span id="sub_owe" style ="color:#FF0000">0</span> )--></span>
							 <span value="4">沉默 <!--(<span id="sub_cm" style ="color:#FF0000">0</span> )--></span>
							 <!--<span  value="5">非计费 (<span id="sub_fei" style ="color:#FF0000">0</span> )</span>-->
						 </div>
						 <div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" id="hyzt_dura"
							  style="border-bottom: none;width:32%;padding-left:0px;float:left;margin-right:2.5%;">
							 流失时长：
							 <span class="active" value="0">全部<!-- (<span id="dura_all" style ="color:#FF0000">0</span> )--></span>
							 <span value="1">3个月内 <!--(<span id="dura_month_3" style ="color:#FF0000">0</span> )--></span>
							 <span value="2">3-6个月 <!--(<span id="dura_month_gt_3" style ="color:#FF0000">0</span> )--></span>
							 <span value="3">6个月以上 <!--(<span id="dura_month_gt_3" style ="color:#FF0000">0</span> )--></span>
						 </div>
						 <div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu"
							  style="border-bottom: none;width:30%;padding-left:0px;float:right;margin-right:2.5%;text-align:right;">
							 总记录数：
							 <span id="sum_record"></span>
						 </div>
					</span>
				</td>
			</tr>
		</table>
	</div>

	<div style="width: 96%;margin:0 auto;">
		<div class="head_table_wrapper">
			<table class="head_table tab_header" cellspacing="0" cellpadding="0">
				<tr><!-- 序号 详细地址 客户 拆停日期 停机时长 状态 -->
					<th>序号</th>
					<th>详细地址</th>
					<th>联系人</th>
					<th>接入号</th>
					<th>拆停日期</th>
					<th>拆停时长</th>
					<th>状态</th>
				</tr>
			</table>
		</div>
		<!--表体-->
		<div class="yhzt_exec_tab_body t_table" style="padding-right:0px;">
			<table cellspacing="0" cellpadding="0" class="content_table tab_body" id="village_view_build_listByYhzt">
			</table>
		</div>
	</div>

	<div class="tip">
		<span style="font-weight: bold;">拆机：</span>指本年的光宽拆机用户数；<span style="font-weight: bold;">停机：</span>指本年该用户为计费用户，但状态为停机的光宽用户数；<br/>
		<span style="font-weight: bold;">沉默：</span>指本年该用户为计费用户，但近三个月连续沉默的非欠费未停机光宽用户数；
	</div>
	<div id="lsyh_div" style="display:none;">-----</div>
	<!------------------------------用户质态----------20180414------------- 结束---------------------->
</body>
<script type="text/javascript">
	var yhzt_begin_scroll = "", yhzt_seq_num = 0, yhzt_list_page = 0;
	//获取最大记录数
	var yhzt_maxRec  = 0;
	var yhzt_build_list = [];
	var yhzt_select_count = 0;
	var urlyhztQuery = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp" />';
	//楼宇ID
	var yhzt_build_id = "";
	var village_yhzt_type='';//用户质态
	var village_stop_dura_type='';//时长
	//标签六 用户质态
	function freshVillageViewBuildListByYhzt(village_yhzt_type,village_stop_dura_type,page,flag) {
		//翻页，不清楚数据
		if(flag==1){
			var cit = $("#village_view_build_listByYhzt");
			cit.empty();
		}
		$.post(urlyhztQuery, {
			eaction : "getBuildInVillageListByYhzt",
			segm_code : yhzt_build_id,
			yhzt_type : village_yhzt_type,
			stop_dura_type : village_stop_dura_type,
			acct_month : '${last_month.VAL}',
			village_id : village_id,
			page : page
		}, function (data) {
			data = $.parseJSON(data);
			if (data.length == 0 && flag) {
				$("#village_view_build_listByYhzt").append("<tr><td colspan='5'>暂无信息</td></tr>");
				$("#sum_record").text(0);
				return;
			}
			if(data.length)
				$("#sum_record").text(data[0].C_NUM);
			//$("#village_view_build_record_count").text(data.length - 1);
			for (var j = 0; j < data.length; j++) {
				++yhzt_seq_num;
				var newRow = "";
				var obj = data[j];
				if (obj.STAND_NAME != '')
					newRow += "<tr><td>" + yhzt_seq_num ;
				else
					newRow += "<tr class=\"heji\"><td>";
				newRow += "</td>";
				newRow += "<td style='text-align:left;padding-left:10px;'>" + (obj.STAND_NAME) + "</td>";
				newRow += "<td style='text-align:center;'>" + (obj.USER_CONTACT_PERSON) + "</td>";
				newRow += "<td class='toViewWin'><span onclick='openOwnView(\""+obj.PROD_INST_ID+"\")'>"+(obj.ACC_NBR==' '?'':(obj.ACC_NBR))+"</span></td>";

				/*if(obj.SCENE_TEXT=="拆机")
					newRow += "<td>" + (obj.REMOVE_DATE) + "</td><td></td>";
				else if(obj.SCENE_TEXT=="停机")
					newRow += "<td></td><td>" + (obj.OWE_DUR) + "</td>";
				else
					newRow += "<td></td><td></td>";*/

				newRow += "<td>" + (obj.REMOVE_DATE) + "</td><td>" + (obj.OWE_DUR) + "</td>";

				newRow += "<td style='color:red;'>"+ obj.SCENE_TEXT + "</td>";
				newRow += "</tr>";

				$("#village_view_build_listByYhzt").append(newRow);
			}
		});
	}

	function openOwnView(prod_inst_id){
		layer.open({
			type: 2,
			title: '流失用户',
			shadeClose: true,
			shade: 0,
			area: ['60%', '410'],
			//skin: 'win_blue',
			content: "<e:url value='/pages/telecom_Index/common/jsp/lsyh_detail.jsp' />?prod_inst_id="+prod_inst_id
		});
	}
	//标签六 用户质态
	var total_first = true;
	function freshVillageViewBuildByYhzt_num() {
		var params = new Object();
		params.eaction = "getBuildInVillageTotalByYhzt";
		params.village_id = village_id;
		params.acct_month = '${last_month.VAL}';
		if(total_first){
			$.post(urlyhztQuery, params, function (data) {
				data = $.parseJSON(data);
				if(data != null){
					//小区光宽用户
					$("#head_all").text(data.ARRIVE_CNT_SUM);
					//拆机
					$("#head_remove").text(data.REMOVE_CNT_Y);
					//停机
					$("#head_stop").text(data.STOP_CNT_Y);
					//欠费
					//$("#head_owe").text(data.OWE_CNT_Y);
					//沉默
					$("#head_cm").text(data.CM_CNT_Y);
					//非计费
					//$("#head_fei").text(data.FEI_CNT_Y);
				}
			});
			total_first = false;
		}
		return;
		params.segm_code = yhzt_build_id;
		$.post(urlyhztQuery, params, function (data) {
			data = $.parseJSON(data);
			if(data != null){
				//获取最大记录数
				//yhzt_maxRec  = data.ARRIVE_CNT;
				//全部
				console.log("params.segm_code:"+params.segm_code);
				//if(params.segm_code==-1)
				//	$("#sub_all").text(parseInt(data.ARRIVE_CNT) + parseInt(data.REMOVE_CNT));
				//else
					$("#sub_all").text(data.ARRIVE_CNT_Y);
				//拆机
				$("#sub_remove").text(data.REMOVE_CNT_Y);
				//停机
				$("#sub_stop").text(data.STOP_CNT_Y);
				//欠费
				//$("#sub_owe").text(data.OWE_CNT_Y);
				//沉默
				$("#sub_cm").text(data.CM_CNT_Y);
				//非计费
				//$("#sub_fei").text(data.FEI_CNT);
				//$("#dura_all").text(data.STOP_TOTAL);
				//$("#dura_month_3").text(data.STOP_CNT);
				//$("#dura_month_gt_3").text(data.STOP_CNT_Y);
			}
		});
	}

	var duraingEnableFlag = 1;
	$(function(){
		//初始化comb
		yhzt_initComb();

		//营销清单-营销派单tab(单转融、协议到期、沉默唤)切换
		$("#hyzt_tb >span ").each(function (index) {
			$(this).unbind();
			$(this).on("click", function () {
				$(this).addClass("active").siblings().removeClass("active");
				village_yhzt_type='';
				//显示当前表格，隐藏其他表格
				if(index==0){//全部
					village_yhzt_type='';
					//获取最大记录数
					yhzt_maxRec  = $("#sub_all").text();
					enableDuringSpan();
				}else if(index==1){//拆机
					village_yhzt_type='0';
					yhzt_maxRec  = $("#sub_remove").text();
					enableDuringSpan();
				}else if(index==2){//停机
					village_yhzt_type='8';
					yhzt_maxRec  = $("#sub_stop").text();
					enableDuringSpan();
				}else if(index==3){//欠费
					village_yhzt_type='4';
					yhzt_maxRec  = $("#sub_owe").text();
					enableDuringSpan();
				}
				else if(index==4){//沉默
					console.log("index:"+index);
					village_yhzt_type='3';
					console.log("village_yhzt_type:"+village_yhzt_type);
					yhzt_maxRec  = $("#sub_cm").text();
					village_stop_dura_type = "";
					$("#hyzt_dura >span").eq(0).addClass("active").siblings().removeClass("active");
					disableDuringSpan();
				}
				else if(index==5){//非计费
					village_yhzt_type='5';
					yhzt_maxRec  = $("#sub_fei").text();
					enableDuringSpan();
				}

				var cit = $("#village_view_build_listByYhzt");
				cit.empty();
				//var village_view_build_search_add4ByHyzt = $("#village_view_build_search_add4ByHyzt").val();
				//var selLY = $("#yhzt_collect_new_build_list").find("option:selected").val();
				//freshVillageViewBuildByYhzt_num();
				yhzt_seq_num = 0;
				yhzt_begin_scroll= "";
				yhzt_list_page= 0;
				freshVillageViewBuildListByYhzt(village_yhzt_type,village_stop_dura_type,0,1);
			})
		});

		//时长选项
		$("#hyzt_dura >span ").each(function (index) {
			$(this).unbind();
			$(this).on("click", function () {
				if(duraingEnableFlag==0)
					return;
				$(this).addClass("active").siblings().removeClass("active");
				village_stop_dura_type='';
				//显示当前表格，隐藏其他表格
				if(index==0){//全部
					village_stop_dura_type='';
					//获取最大记录数
					yhzt_maxRec  = $("#dura_all").text();
				}else if(index==1){//3个月内
					village_stop_dura_type='1';
					yhzt_maxRec  = $("#dura_month_3").text();
				}else if(index==2){//3-6个月
					village_stop_dura_type='2';
					yhzt_maxRec  = $("#dura_month_gt_3").text();
				}else if(index==3){//6个月以上
					village_stop_dura_type='3';
				}

				var cit = $("#village_view_build_listByYhzt");
				cit.empty();
				//var village_view_build_search_add4ByHyzt = $("#village_view_build_search_add4ByHyzt").val();
				//var selLY = $("#yhzt_collect_new_build_list").find("option:selected").val();
				//freshVillageViewBuildByYhzt_num();
				yhzt_seq_num = 0;
				yhzt_begin_scroll= "";
				yhzt_list_page= 0;
				freshVillageViewBuildListByYhzt(village_yhzt_type,village_stop_dura_type,0,1);
			})
		});

		//设置滚动事件
		$(".yhzt_exec_tab_body").scroll(function () {
			//到达最大值
			/*if(parseInt(yhzt_seq_num) >= parseInt(yhzt_maxRec)){
				return;
			}*/
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - yhzt_begin_scroll > 500) {
					freshVillageViewBuildListByYhzt(village_yhzt_type,village_stop_dura_type,++yhzt_list_page,0);
				}
				yhzt_begin_scroll = new Date().getTime();
			}
		});
	});

	function enableDuringSpan(){
		duraingEnableFlag = 1;
		$("#hyzt_dura > span").slice(1).removeClass("deny_span");
	}

	function disableDuringSpan(){
		duraingEnableFlag = 0;
		$("#hyzt_dura > span").slice(1).addClass("deny_span");
	}

	//楼宇combonchage事件
	var yhzt_load_build_info = function (flag) {
		//默认选中第一个span
		$("#sts_select").addClass("active").siblings().removeClass("active");

		var text = $("#yhzt_collect_new_build_list").find("option:selected").text();
		$("#yhzt_collect_new_build_name").val(text);
		$("#yhzt_collect_new_select_build").html(text);

		yhzt_build_id = $("#yhzt_collect_new_build_list").val();
		//共同楼宇ID,标签联动切换使用,需要子页面去赋值
		common_bulid_id  = yhzt_build_id;
		//console.log("异常改变："+common_bulid_id);
		freshVillageViewBuildByYhzt_num();
		yhzt_seq_num = 0;
		freshVillageViewBuildListByYhzt("","",0,1);
	};

	//楼宇comb初始化
	function yhzt_initComb(){
		//预警区域信息编辑
		//console.log("异常获取:"+common_bulid_id);
		var data = ${e:java2json(yhzt_list.list)};
		var d, newRow = "<option value='-1'>全部楼宇</option>";//<option value='-1' select='selected'>全部</option>
		for (var i = 0, length = data.length; i < length; i++) {
			d = data[i];
			newRow += "<option value='" + d.CODE + "'>" + d.TEXT + "</option>";
			yhzt_build_list.push(d);
		}
		$("#yhzt_collect_new_build_list").append(newRow);
		/*if(common_bulid_id!="-1")
			$("#yhzt_collect_new_build_list option[value='"+common_bulid_id+"']").attr("selected","selected");
		else*/
			$("#yhzt_collect_new_build_list option").eq(0).attr("selected","selected");

		yhzt_build_id = $("#yhzt_collect_new_build_list").val();
		//初始化选中
		var text = $("#yhzt_collect_new_build_list").find("option:selected").text();
		$("#yhzt_collect_new_build_name").val(text);
		//$("#yhzt_collect_new_select_build").html(text);

		freshVillageViewBuildListByYhzt('','',0,1);
		freshVillageViewBuildByYhzt_num();
	}

	//楼宇comb输入事件
	function yhzt_load_build_name_list() {
		setTimeout(function() {
			//下拉列表显示
			var $build_list =  $("#yhzt_collect_new_build_name_list");
			$build_list.empty();
			if (yhzt_select_count <= 1) {
				//before_load_build_list();
			}

			var build_name = $("#yhzt_collect_new_build_name").val().trim();
			if (build_name != '') {
				var temp;
				var newRow = "";
				for (var i = 0, length = yhzt_build_list.length, count = 0; i < length; i++) {
					if ((temp = yhzt_build_list[i].TEXT).indexOf(build_name) != -1) {
						newRow += "<li title='" + temp + "' onclick='yhzt_select_build(\""+ temp + "\",\"" +
						yhzt_build_list[i].CODE + "\"," + i + ")'>" + temp + "</li>";
						count++;
					}

				}
				$build_list.append(newRow);
				$("#yhzt_collect_new_build_name_list").show();
			} else {
				$("#yhzt_collect_new_build_name_list").hide();
				//[全部]选中
				var text = $("#yhzt_collect_new_build_list").find("option:selected").text();
				$("#yhzt_collect_new_build_name").val(text);
				$("#yhzt_collect_new_select_build").html(text);

				yhzt_build_id = $("#yhzt_collect_new_build_list").val();
				//共同楼宇ID,标签联动切换使用,需要子页面去赋值
				//common_bulid_id  = yhzt_build_id;

				//freshVillageViewBuildByYhzt_num();
				yhzt_seq_num = 0;
				freshVillageViewBuildListByYhzt(village_yhzt_type,village_stop_dura_type,0,1);
			}

			//联动改变 select框, 只要不做点击, 都会将select改回全部.
			$("#yhzt_collect_new_build_list option:eq(0)").attr('selected','selected');
			yhzt_select_count++;
		}, 800)
	}

	//楼宇comb显示
	function yhzt_select_build(name, id, index) {
		$("#yhzt_collect_new_build_list option[value=" + id + "]").attr('selected','selected');
		$("#yhzt_collect_new_build_name_list").hide();
		$("#yhzt_collect_new_build_list").change();
	}

</script>