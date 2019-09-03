<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="last_month">
	select to_char(add_months(sysdate,-1),'yyyymm') val from dual
</e:q4o>
<head>
    <link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_level.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all"/>
	<script type="text/javascript">
	    var ly_yhzt_begin_scroll = "", ly_yhzt_seq_num = 0, ly_yhzt_list_page = 0;
		//获取最大记录数
		var ly_yhzt_maxRec  = 0;
		//状态
		var ly_yhzt_type='';
	    //楼宇编码
	    var  segm_code = '${param.segm_code}';
	    var urlyhztQuery_ly = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp" />';
		//标签六 用户质态
		function freshVillageViewBuildListByYhzt_ly(yhzt_type,page,flag) {
			var cit = $("#village_view_build_listLyByYhzt");
			cit.empty();
			$.post(urlyhztQuery_ly, {
				eaction: "getBuildInVillageListByYhzt",
				segm_code: segm_code,
				yhzt_type:yhzt_type,
				acct_month:'${last_month.VAL}',
				page: page
			}, function (data) {
				data = $.parseJSON(data);
				if (data.length == 0 && flag) {
					$("#village_view_build_listLyByYhzt").append("<tr><td colspan='4'>暂无信息</td></tr>");
					return;
				}

				//$("#village_view_build_record_count").text(data.length - 1);
				for (var j = 0; j < data.length; j++) {
					++ly_yhzt_seq_num;
					var newRow = "";
					var obj = data[j];
					if (obj.STAND_NAME != '')
						newRow += "<tr><td style='width: 50px;'>" + ly_yhzt_seq_num;
					else
						newRow += "<tr class=\"heji\"><td style='width: 50px;'>";
					newRow += "</td>";
					newRow += "<td style='width: 250px;'>" + (obj.STAND_NAME) + "</td>";
					newRow += "<td style='width: 350px;'>" + (obj.USER_CONTACT_PERSON) + "</td>";
					newRow += "<td style='width: 350px;'>" + (obj.ACC_NBR) + "</td>";
					newRow += "</tr>";

					$("#village_view_build_listLyByYhzt").append(newRow);
				}
			});
		}

		//标签六 用户质态
		function freshVillageViewBuildByYhzt_num_ly() {
			$.post(urlyhztQuery_ly, {
				eaction: "getBuildInVillageTotalByYhzt",
				segm_code: segm_code,
				acct_month : '${last_month.VAL}'
			}, function (data) {
				    data = $.parseJSON(data);
					//获取最大记录数
				    ly_yhzt_maxRec  = data.ARRIVE_CNT;
					//小区光宽用户
					$("#sub_all_ly").text(data.ARRIVE_CNT);
					//其中：沉默用户
					$("#sub_cm_ly").text(data.CM_CNT);
					//欠费用户
					$("#sub_owe_ly").text(data.OWE_CNT);
					//停机用户
					$("#sub_remove_ly").text(data.REMOVE_CNT);
			});
		}

		$(function(){
			//第六个标签页，用户质态信息列表
			freshVillageViewBuildByYhzt_num_ly();
			//第六个标签页，用户质态信息汇总
			freshVillageViewBuildListByYhzt_ly('',0,1);
            //状态标签切换功能
			$("#hyzt_tb_ly >span ").each(function (index) {

					$(this).unbind();
					$(this).on("click", function () {
						$(this).addClass("active").siblings().removeClass("active");
						ly_yhzt_type='';
						//显示当前表格，隐藏其他表格
						if(index==0){
							ly_yhzt_type='';
							ly_yhzt_maxRec = $("#sub_all_ly").text();
						}else if(index==1){
							ly_yhzt_type='1';
							ly_yhzt_maxRec = $("#sub_cm_ly").text();
						}else if(index==2){
							ly_yhzt_type='2';
							ly_yhzt_maxRec = $("#sub_owe_ly").text();
						}else if(index==3){
							ly_yhzt_type='3';
							ly_yhzt_maxRec = $("#sub_remove_ly").text();
						}
						var cit = $("#village_view_build_listLyByYhzt");
			            cit.empty();

						ly_yhzt_seq_num = 0;
						ly_yhzt_begin_scroll= "";
						ly_yhzt_list_page= 0;

						freshVillageViewBuildListByYhzt_ly(ly_yhzt_type,0,1);
					})
			    });

				//设置滚动事件
				$(".ly_yhzt_exec_tab_body").scroll(function () {
					//到达最大值
					if(parseInt(ly_yhzt_seq_num) >= parseInt(ly_yhzt_maxRec)){
						return;
					}
					var viewH = $(this).height();
					var contentH = $(this).get(0).scrollHeight;
					var scrollTop = $(this).scrollTop();
					if (scrollTop / (contentH - viewH) >= 0.95) {
						if (new Date().getTime() - ly_yhzt_begin_scroll > 500) {
							freshVillageViewBuildListByYhzt_ly(ly_yhzt_type,++ly_yhzt_list_page,0);
						}
						ly_yhzt_begin_scroll = new Date().getTime();
					}
				});
		});

	</script>
</head>
<body>
		<!--用户质态----------20180414------------- 开始---------------------------------------------------------->
		<div class="village_new_searchbar">
			<table style = "width:100%">
				<tr>
				    <td>
						 <span>
							<div class="radio tab_accuracy_head tab_accuracy_other" id="hyzt_tb_ly" style="border-bottom: none;width:100%;padding-left:10px;">
								状态：
								<span class="active" value="1">全部 (<span id="sub_all_ly" style ="color:#FF0000">0</span> )</span>
								<span  value="2">沉默 (<span id="sub_cm_ly" style ="color:#FF0000">0</span> )</span>
								<span  value="2">欠费 (<span id="sub_owe_ly" style ="color:#FF0000">0</span> )</span>
								<span  value="3">拆机 (<span id="sub_remove_ly" style ="color:#FF0000">0</span> )</span>
							</div>
                         </span>
					</td>
				</tr>
			</table>
		</div>
		<!--表头-->
		<div class="village_m_tab" style="width:98%;height: auto;padding-right:17px;">
			<table class="content_table" style="width:100%;margin:0px auto;">
				<tr>
					<th width="50px;">序号</th>
					<th width="500px;">详细地址</th>
					<th width="95px;">联系人</th>
					<th width="95px;">接入号码</th>
				</tr>
			</table>
		</div>
		<div class="village_m_tab7 ly_yhzt_exec_tab_body" style="width:98%;margin:0px;">
			<table class="content_table" id="village_view_build_listLyByYhzt" style="width:100%;margin:0px auto;">
			</table>
		</div>
	    <!--用户质态----------20180414------------- 结束----------------------------------------------------------->
</body>
