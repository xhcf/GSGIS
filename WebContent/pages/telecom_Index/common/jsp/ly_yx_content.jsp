<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<head>
    <link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_level.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
	<script type="text/javascript">
		//楼宇编码
	    var  segm_code = '${param.segm_code}';
		//场景：全部、单转融、协议到期、沉默唤
		var lyqd_intraday_sence_id='';
		//状态: 全部,未执行,已执行
	    var lyqd_deal_flg='';
	    var lyqd_begin_scroll = "", lyqd_seq_num = 0, lyqd_list_page = 0;

	    /*-----------------------营销派单 start-----------------------------*/
	    var ly_yx_url = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp'/>";
	    var lyqd_load_intraday_data = function (){
			var params = {
				eaction: "marketing_intraday",
				page: 0,
				segm_code:segm_code,
				intraday_sence_id:lyqd_intraday_sence_id,
				deal_flag:lyqd_deal_flg
			}
			lyqd_clear_data();
			lyqd_seq_num = 0;
			lyqd_intradayListScroll(params,1);
		};
		//parent.yx_load_intraday_data_view = lyqd_load_intraday_data;

		//加载表格数据-营销派单
		function lyqd_intradayListScroll(params, flag) {
			var $grid_list = $("#dispatch_info_list_ly");
			$.post(ly_yx_url, params, function (data) {
				data = $.parseJSON(data);
				for (var i = 0, l = data.length; i < l; i++) {
					var d = data[i];
					var newRow = "<tr><td style='width:35px'>" + (++lyqd_seq_num) + "</td>";
					newRow += "<td style='width:240px'>" + d.CONTACT_ADDS + "</td><td style='width:90px'><span>"+d.CONTACT_TEL +"</span></br>"+ d.SERV_NAME + "</td><td style='width:100px'>" + d.ACC_NBR
					+ "</td><td style='width:100px;text-align: left;'>" + d.SCENE_ID  +"</br>"+d.MKT_REASON+"</td><td style='width:100px;text-align: left;'>"+d.ORDER_DATE+"</td><td style='width:35px'><a onclick=\"exec_agent('" + d.PROD_INST_ID + "','" + d.ORDER_ID + "')\">执行</a></td></tr>";
					$grid_list.append(newRow);
				}
				if (data.length == 0 && flag) {
					$grid_list.empty();
					$grid_list.append("<tr><td style='text-align:center' colspan=7 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
					return;
				}
			});
		}
		function exec_agent(prod_inst_id,order_id){
			var param = {};
			param.prod_inst_id = prod_inst_id;
			param.order_id = order_id;
			parent.openCustViewByProdInstId(param);
		}

		//执行率计算
		function lyqd_execlvCount(exec_num,order_num){
			var exec_lv = "0.00";
			if(exec_num > 0  && order_num > 0){
				 exec_lv = parseInt(exec_num)/parseInt(order_num) * 100;
				 exec_lv = exec_lv.toFixed(2);
			}
			//执行率
			$("#lyqd_head_exec_lv").html(""+exec_lv+"%");
		}

		//一级汇总:派单情况
		function lyqd_intraday_num(){
			var params = {};
			params.segm_code=segm_code;
			var postUrl="<e:url value='pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp?eaction=intraday_num'/>";
			$.post(postUrl,params, function (data) {
				data = $.parseJSON(data);
				if(data.length>0){
					//月派单数
					$("#lyqd_head_order_num").html(""+data[0].COUNT+"");
					//执行数
					$("#lyqd_head_exec_num").html(""+data[1].COUNT+"");
					//执行率
					lyqd_execlvCount(data[1].COUNT,data[0].COUNT);
					//$("#head_exec_lv").html("("+execlvCount(data[1].COUNT,data[0].COUNT)+")");
					//$("#head_exec_lv").html("("+execlvCount(1,3)+")");
					//成功数
					$("#lyqd_head_succ_num").html(""+data[2].COUNT+"");
				}
			})
		}

		//二级汇总:场景，状态
		function lyqd_intraday_sed_num(){
			var params = {};
			params.segm_code=segm_code;
			var postUrl="<e:url value='pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp?eaction=intraday_sed_num'/>";
			$.post(postUrl,params, function (data) {
				data = $.parseJSON(data);
				if(data.length>0){
					//场景-全部
					$("#lyqd_intraday_all").html("("+data[0].COUNT+")");
					//场景-单转融
					$("#lyqd_intraday_dzr").html("("+data[1].COUNT+")");
					//场景-协议到期
					$("#lyqd_intraday_xydq").html("("+data[2].COUNT+")");
					//场景-沉默唤醒
					$("#lyqd_intraday_cmhx").html("("+data[3].COUNT+")");

					//状态-全部
					$("#lyqd_status_all").html("("+data[4].COUNT+")");
					//状态-未执行
					$("#lyqd_status_noexcute").html("("+data[5].COUNT+")");
					//状态-已执行
					$("#lyqd_status_excute").html("("+data[6].COUNT+")");
				}
			})
		}
		/*-------------------------------营销派单 end----------------------*/

		//类表数据清除
		function lyqd_clear_data() {
			lyqd_begin_scroll = "", lyqd_seq_num = 0, lyqd_list_page = 0;
			$("#dispatch_info_list_ly").empty();
		}

		//初始化加载
		$(function(){

			    //一级汇总:派单情况
		        //lyqd_intraday_num();
				//二级汇总:场景，状态
		        lyqd_intraday_sed_num();
				lyqd_load_intraday_data();
				//营销清单-营销派单tab(单转融、协议到期、沉默唤)切换
				$("#lyqd_intraday_tb >span ").each(function (index) {
					$(this).unbind();
					$(this).on("click", function () {
						$(this).addClass("active").siblings().removeClass("active");
						intraday_sence_id='';
						//显示当前表格，隐藏其他表格
						if(index==0){
							lyqd_intraday_sence_id='';
						}else if(index==1){
							lyqd_intraday_sence_id='10';
						}else if(index==2){
							lyqd_intraday_sence_id='11';
						}else if(index==3){
							lyqd_intraday_sence_id='12';
						}
						lyqd_load_intraday_data();

					})
			    });

				//状态: 全部,未执行,已执行
				$("#lyqd_intraday_sts_tb > span").each(function (index) {
					$(this).unbind();
					$(this).on("click", function () {
						$(this).addClass("active").siblings().removeClass("active");
						//显示当前表格，隐藏其他表格
						if(index==0){//全部
							lyqd_deal_flg="";
						}else if(index==1){//未执行
							lyqd_deal_flg=2;
						}else if(index==2){//已执行
							lyqd_deal_flg=1;
						}
						//列表数据展示
						lyqd_load_intraday_data();
					})
				});

				//设置滚动事件
				$(".lyqd_dispatch_m_tab").scroll(function () {
					var viewH = $(this).height();
					var contentH = $(this).get(0).scrollHeight;
					var scrollTop = $(this).scrollTop();
					if (scrollTop / (contentH - viewH) >= 0.95) {
						if (new Date().getTime() - lyqd_begin_scroll > 500) {
							var params = {
								eaction: "marketing_intraday",
								page: ++lyqd_list_page,
								segm_code:segm_code,
								intraday_sence_id:lyqd_intraday_sence_id,
								deal_flag:lyqd_deal_flg
							}

							lyqd_intradayListScroll(params, 0);
						}
						lyqd_begin_scroll = new Date().getTime();
					}
				});
		});
	</script>
</head>
<body>
        <!--营销清单----------20180412------------- 开始---------------------->
		<div class="village_new_searchbar">
			<table style = "width:100%">
				<tr>
				    <td>
						 <span>
							<div class="radio tab_accuracy_head tab_accuracy_other" id="lyqd_intraday_tb" style="border-bottom: none;width:100%;padding-left:0px;">
								场景：
								<span class="active" value="1" id ="lyqd_yx_cj_select">全部<span id="lyqd_intraday_all">(0)</span></span>
	                            <span  value="2">单转融<span id="lyqd_intraday_dzr">(0)</span></span>
	                            <span  value="3">协议到期<span id="lyqd_intraday_xydq">(0)</span></span>
	                            <span  value="4">沉默唤醒<span id="lyqd_intraday_cmhx">(0)</span></span>
							</div>
							<div class="radio tab_accuracy_head tab_accuracy_other" id="lyqd_intraday_sts_tb" style="border-bottom: none;width:100%;padding-left:0px;">
								状态：
								<span class="active" value="1" id ="lyqd_yx_sts_select">全部<span id="lyqd_status_all">(0)</span></span>
	                            <span  value="2">未执行<span id="lyqd_status_noexcute">(0)</span></span>
	                            <span  value="3">已执行<span id="lyqd_status_excute">(0)</span></span>
							</div>
						</span>
					</td>
				</tr>
			</table>
		</div>

		<!--精准营销标签页内容 -->

	   <div class="head_table_wrapper">
			<table class="head_table">
				<tr>
					<th width="35">序号</th>
					<th width="240">详细地址</th>
					<th width="90">联系人</th>
					<th width="100">接入号码</th>
					<th width="100">营销场景</th>
					<th width="100">派单时间</th>
					<th width="35">操作</th>
				</tr>
			</table>
		</div>
		<div class="t_table lyqd_dispatch_m_tab" style="margin:0px auto;">
			 <table class="content_table dispatch_detail_in" id="dispatch_info_list_ly" style="width:100%;">
			 </table>
		</div>

		<!--营销清单清单----------20180412------------- 结束---------------------->
</body>
