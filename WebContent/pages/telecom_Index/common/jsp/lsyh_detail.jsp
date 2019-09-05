<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="last_month">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '4'
</e:q4o>
<e:set var="sql_part_tab1">
	<e:description>EDW.TB_MKT_INFO_LOST@GSEDW</e:description>
	${gis_user}.tb_mkt_info_lost
</e:set>
<e:q4l var="owe_info">
	SELECT a.*, b.stop_type_name stop_type_text,B.STOP_TYPE FROM (
	SELECT a.*,nvl(PROD_OFFER_NAME,'--') PROD_OFFER_NAME,nvl(b.PROD_OFFER_DESC,'--') PROD_OFFER_DESC
	FROM (SELECT NVL(ACC_NBR, ' ') || '   ' || NVL(CUST_NAME, ' ') CUST_INFO,
	CASE
	WHEN SEX = 1 THEN
	'男'
	WHEN SEX = 2 THEN
	'女'
	ELSE
	' '
	END SEX,
	CASE
	WHEN AGE IS NOT NULL THEN
	AGE || '岁'
	ELSE
	' '
	END AGE,
	STOP_TYPE,
	NVL(TO_CHAR(SERV_ARPU), '0')||'元' SERV_ARPU,
	nvl(to_char(FINISH_DATE,'yyyy"年"mm"月"dd"日"'),' ') FINISH_DATE,
	nvl(to_char(REMOVE_DATE,'yyyy"年"mm"月"dd"日"'),' ') REMOVE_DATE,
	case when INET_MONTH is null then '--'
	when INET_MONTH/12 >1 then  floor(INET_MONTH/12) ||'年'
	end
	||  case when mod(INET_MONTH,12)>0 then  mod(INET_MONTH,12)||'个月'
	end INET_MONTH,
	${gis_user}.DATE_DUR(remove_date,SYSDATE) owe_dur,
	nvl(to_char(ADDRESS_DESC),' ') ADDRESS_DESC,
	<e:description>2018.10.22 号码脱敏</e:description>
	substr(NVL(USER_CONTACT_NBR, ' '),0,3)||'******'||SUBSTR(NVL(USER_CONTACT_NBR, ' '),10,2) USER_CONTACT_NBR,
	LEV4_ID,
	LEV5_ID,
	LEV6_ID,
	nvl(B.BRANCH_NAME,' ') BRANCH_NAME,
	nvl(B.GRID_NAME,' ') GRID_NAME,
	nvl(B.VILLAGE_NAME,' ') VILLAGE_NAME,
	CASE
	WHEN CUST_PHONE IS NULL THEN
	nvl(CUST_MANAGER_NAME,'--')
	ELSE
	nvl(CUST_MANAGER_NAME,'--') || ' ' || substr(CUST_PHONE,0,3) || '******' || substr(CUST_PHONE,10,2)
	END CUST_MANAGER,
	PROD_INST_ID,
	ADDRESS_ID,
	substr(NVL(A.CUST_STAR_LEVEL, ' '),0,2) CUST_STAR_LEVEL
	FROM ${sql_part_tab1} A
	RIGHT OUTER JOIN ${gis_user}.VIEW_DB_CDE_VILLAGE B
	ON A.LEV6_ID = B.VILLAGE_ID
	WHERE PROD_INST_ID = '${param.prod_inst_id}') A
	LEFT JOIN (SELECT T7.PROD_INST_ID,
	NVL(T7.PROD_OFFER_NAME, '--') PROD_OFFER_NAME,
	NVL(T7.PROD_OFFER_DESC, '--') PROD_OFFER_DESC
	FROM
	<e:description>
		2018.9.11 表名更换
		EDW.TB_MKT_OFFER_INFO@GSEDW T7
	</e:description>
	${gis_user}.TB_HDZ_MKT_OFFER_INFO T7
	WHERE EXISTS (SELECT 1
	FROM
	<e:description>
		2018.9.11 表名更换
		EDW.TB_MKT_OFFER_COMP2@GSEDW T8
	</e:description>
	${gis_user}.TB_hdz_MKT_OFFER_COMP2 T8
	WHERE T8.PROD_INST_ID = '${param.prod_inst_id}'
	AND T7.COMP_INST_ID = T8.COMP_INST_ID
	AND T7.PROD_INST_ID = T8.PROD_INST_ID)) B
	ON A.PROD_INST_ID = B.PROD_INST_ID
	)a,PMART.T_DIM_LOST_TYPE@GSEDW b
	WHERE a.stop_type = b.stop_type
</e:q4l>
<head>
	<title>流失用户视图弹窗</title>
	<style>
		body {margin:0px;padding:0px;}
		.tip {
			margin-left:18px;
		}
		.center {text-align:center!important;padding-left:0px!important;color:#328ECE;}
		.important {color:#2E40E7;}
		.bold_blue a{font-weight: normal;text-decoration: underline;}

		.layui-layer{background-color:transparent!important;border:0px!important;}
		.head_div{width:100%;height:40px;line-height: 40px;}
		.tab_head{height: 32px;line-height: 32px;background: #0966fe;color: #fff;padding-left:25px;}
		.tab_head span {margin-left:5px;}
		.blue_bar{height: 36px;line-height: 36px;background: #e2f1fa;color: #fff;padding-left:5px;border-top:solid 1px #7bbbdf;}
		.blue_bar a {padding:2px 6px;background:#ffc820;border-radius: 5px;color:#fff;margin-left:15px;}
		.active{
			color:#FFCC00!important;
		}
		.tab_head span{
			color: #255489;
			width: 70px;
			line-height: 32px;
			/*background: ;*/
			vertical-align: middle;
			display: inline-block;
			cursor:pointer;
			font-weight: bold;
		}
		.tab_head span.active {background: #0094d9;padding:0px 3px;border-radius: 10px;line-height: 22px;text-align: center;color:#fff!important;margin-right:15px;}
		.tab_content{display:none;padding:10px 0px;font-size:14px;}

		#address_desc{text-align: center;vertical-align:middle;font-size:16px;height:36px;line-height:36px;font-weight: bold;}
		.cust_acct_day_div{
			width: 100px;
			height:28px;
			float:right;
			margin-right:21px;
			margin-top:2px;
		}
		#cust_acct_day{width:100px;}
		.bold_font{font-weight: bold;text-align:right;}
		.base_info_tab,.main_offer_tab,.income_tab{width:100%;border-collapse: collapse;}
		.base_info_tab tbody tr{height:30px;font-size:13px;}

		.base_info_tab td ,.main_offer_tab td,.income_tab td{border:solid 1px #ccc;padding-left:0px;border-collapse: collapse;}
		.base_info_tab td {border-color:#eee;height:28px;}
		.main_offer_tab td,.prod_tab td,.income_tab td {height:28px;}
		.income_head,.income_tab {width:100%;}

		.base_info_tab tr td:first-child ,.main_offer_tab tr td:first-child{width:28%;}
		.base_info_tab.base td,.main_offer_tab.base td {border-width: 0px 0px 1px 0px!important;padding-left:15px;}
		.base_info_tab.base td span,.main_offer_tab.base td span {margin-left:10px;font-weight: normal;}
		.main_offer_head{
			width: 100%;
			height:20px;
			font-size: 18px;
		}
		.main_offer_tab{
			width:100%;
		}
		/*.main_offer_tab tbody tr{height:25px;}*/
		#main_offer_tbody{
			width:100%;
			max-height:300px;
			overflow-y: scroll;
			padding-top:15px;
			border:solid 1px #ccc;
		}

		.list_order{
			width: 20px;
			height:20px;
			text-align: center;
			vertical-align: middle;
			background: #FF6600;
			border-radius: 50%;
			color:#fff;
			float:left;
		}
		.list_row{
			width:90%;
			display:inline-block;
			margin:3px;
		}
		.list_row span{
			margin-right:15px;
		}
		.row_pad_left{padding-left: 25px;}
		.title_row{
			float:left;
			padding-left: 5px;
		}
		.title_row span{
			margin-right:15px;
		}
		.main_offer_date{
			text-align: right;
		}
		.main_offer_date span{
			margin:0 5px;
		}
		.info_summary{
			background: #EDF3FF;
			color:red;
			height:30px;
			line-height:30px;
			vertical-align: middle;
			padding-left:10px;
		}
		#prod_tbody,#income_tbody {
			max-height:300px;
			overflow-y: scroll;
		}
		.align_right{
			text-align: right;
		}
		.align_left{
			text-align: left;
		}
		.color_blue{
			color:#5E9FFF;
		}
		.small_column{
			width:120px;
		}
		.big_auto_column{
			width:80%;
		}
		.full_width{
			width:100%;
		}
		.small_font{
			font-size:12px;
		}
		.big_font{
			font-size:14px;
		}
		.incoming_item{
			padding-left:20px;
		}
		.tab_scroll {height:253px;overflow-y: scroll;}
		.tab_header_lock {height:31px;padding-right: 14px;}
		.textbox {
			height: 24px;
			line-height: 24px;}
		.textbox-text .validatebox-text {height:24px!important;line-height:24!important;}
		.info_summary span {margin-left:6px;margin-right:6px;}
		.user_switch_selected {background-color:#ff8400!important;}

		.prod_head, .prod_head td, .income_head, .income_head td {
			text-align: center;
			border: solid 1px #ccc;
			border-collapse: collapse;
			height: 30px;
			background: #eaeaea;
			color: #333;
		}

		.base_info_tab.base {font-size:12px;color:#333;}

		.blue_line {
			min-height: 28px;
			line-height: 28px;
			margin-top: 0px;
			font-size: 14px;
			background: #eee;
			color: #2070DD;
			text-align: center;
			font-weight: bold;
			border-top: solid 0px #b4f5ff;
			border-bottom: solid 0px #0b68c3;
			padding-right:40px;
		}

		#view_more {
			display: none;
			top: 10px;
			right: 15px;
			position: absolute;
			font-size: 12px;
			cursor: pointer;
			text-decoration: underline;
			color: blue;
		}
		#owe_user span {width:auto;padding:0px 5px;background:#ee7008;border-radius: 5px;line-height:18px;font-size:12px;font-weight: normal;color:#fff;height:20px;display: inline-block;}
		#owe_sub {margin-left: 10px;}
		#owe_grid,#owe_village {margin-left:0px;}
	</style>
	<script type="text/javascript"
			src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/tuomin.js?version=New Date()"/>' charset="utf-8"></script>
	<script>
		$(function(){
			var obj = ${e:java2json(owe_info.list)};
			console.log(obj);
			if(obj.length){
				var d = obj[0];
				if(d.STOP_TYPE_TEXT=='拆机'){
					$("#view_more").hide();
				}else{
					$("#view_more").show();
				}

				if($.trim(d.CUST_STAR_LEVEL)=='')
					$("#owe_user").html(d.CUST_INFO);
				else
					$("#owe_user").html(d.CUST_INFO+"   <span> "+d.CUST_STAR_LEVEL+"</span>");

				$("#owe_sex").text(d.SEX==1?'男':'女');
				$("#owe_age").text(d.AGE);
				$("#owe_main_offer").text(d.PROD_OFFER_NAME);
				$("#owe_status").text(d.STOP_TYPE_TEXT);
				$("#owe_arpu").text(d.SERV_ARPU);
				$("#owe_inet_date").text(d.FINISH_DATE);
				//$("#owe_remove_date").text(d.REMOVE_DATE);

				if(d.STOP_TYPE=='2' || d.STOP_TYPE=='3'){
					$("#dura_name").text("沉默时长:");
					if(d.STOP_TYPE=='2')
						$("#owe_remove_dura").text("近三个月"+d.STOP_TYPE_TEXT);
					if(d.STOP_TYPE=='3')
						$("#owe_remove_dura").text("本年"+d.STOP_TYPE_TEXT);
				}else{
					$("#owe_remove_dura").text(d.OWE_DUR);
				}

				$("#owe_inet_dur").text(d.INET_MONTH);

				$("#owe_address").text(d.ADDRESS_DESC);
				$("#owe_address1").text(addr(d.ADDRESS_DESC));
				$("#owe_constact_nbr").text(d.USER_CONTACT_NBR);

				$("#owe_sub").text(d.BRANCH_NAME==' '?'':d.BRANCH_NAME);
				$("#owe_grid").text(d.GRID_NAME==' '?'':'->'+d.GRID_NAME);

				$("#owe_village").text(d.VILLAGE_NAME==' '?'':'->'+d.VILLAGE_NAME);
				$("#owe_manager").text(d.CUST_MANAGER);
			}else{
				$("#view_more").show();
				console.log("未找到异常用户信息");
				$("#owe_user").text("--");
				$("#owe_sex").text("--");
				$("#owe_age").text("--");
				$("#owe_main_offer").text("--");
				$("#owe_status").text("--");
				$("#owe_arpu").text("--");
				$("#owe_inet_date").text("--");
				$("#owe_remove_date").text("--");
				$("#owe_inet_dur").text("--");

				$("#owe_address").text("--");
				$("#owe_address1").text("");
				$("#owe_constact_nbr").text("--");

				$("#owe_sub").text("--");
				$("#owe_grid").text("--");

				$("#owe_village").text("--");
				$("#owe_manager").text("--");
			}

			$("#view_more").on("click",function(){
				var prod_inst_id = '${param.prod_inst_id}';
				var param = {};
				param.prod_inst_id = prod_inst_id;
				if(obj.length)
					param.add6 = obj[0].ADDRESS_ID;
				else
					param.add6 = "";
				param.tab_id = 0;
				param.exec_able = 1;
				param.is_lost = 1;
				if(obj.length)
					param.lost_type = obj[0].STOP_TYPE;
				else
					param.lost_type = "";
				parent.parent.openCustViewByProdInstId(param);
			});
		});
	</script>
</head>
<body>
<div class="blue_line" id="owe_user"></div>
<div class="blue_line" id="owe_address1"></div>
<span id="view_more">更多</span>
<div class="tab_content" style="display: block">
	<table class="base_info_tab base" cellpadding="0" cellspacing="0">
		<tr>
			<td class="bold_font">套餐名称:</td><td><span id="owe_main_offer"></span></td>
		</tr>
		<tr>
			<td class="bold_font">状态:</td><td><span id="owe_status" style="color:red;"></span></td>
		</tr>
		<tr>
			<td class="bold_font">ARPU:</td><td><span id="owe_arpu"></span></td>
		</tr>
		<tr>
			<td class="bold_font">入网日期:</td><td><span id="owe_inet_date"></span></td>
		</tr>
		<tr>
			<td class="bold_font">在网时长:</td><td><span id="owe_inet_dur"></span></td>
		</tr>
		<tr>
			<%--<td class="bold_font">拆停日期:</td><td><span id="owe_remove_date"></span></td>--%>
			<td class="bold_font" id="dura_name">拆停时长:</td><td><span id="owe_remove_dura" style="color:red;"></span></td>
		</tr>
		<tr>
			<td class="bold_font">客户电话:</td><td><span id="owe_constact_nbr"></span></td>
		</tr>
		<tr>
			<td class="bold_font">归属信息:</td>
			<td>
				<span id="owe_sub"></span>
				<span id="owe_grid"></span>
				<span id="owe_village"></span>
			</td>
		</tr>
		<tr>
			<td class="bold_font">客户经理:</td><td><span id="owe_manager"></span></td>
		</tr>
	</table>
</div>
</body>
