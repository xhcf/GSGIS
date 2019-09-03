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
	<title>支局视图</title>
	<meta charset="utf-8">
	<meta name="author" content="jasmine"><!-- 定义作者-->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
	<link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css"/>' rel="stylesheet"
		  type="text/css" media="all"/>
	<link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css"/>' rel="stylesheet"
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
		.wrap_a {margin:0px 5px}
		.yin {height:auto;}
		.base {padding:0px 5px;}
	</style>



	<style type="text/css">
		.table_yw .manufacture span {cursor: pointer;}
	</style>
</head>
<body>
<div class="detail_block tab_box" >
  <div class="village_name">小区名称:<span class="color_orange">岷州家园</span></div>
  <div class="village_layout">
    <div class="title">概况</div>
    <div class="body">
      <span>H端口利用率：<span class="color_orange">32.45%</span> </span>
      <span>楼宇数： <span class="color_orange">6</span></span>
      <span>住户数：<span class="color_orange">45</span></span>
	</div>
	<div class="title">资源</div>
    <div class="body">
      <span>端口利用率：<span class="color_orange">32.45%</span> </span>
      <span>楼宇数： <span class="color_orange">6</span></span>
      <span>H端口数：<span class="color_orange">45</span></span>
	</div>
	<div class="title mark">精准营销</div>
    <div class="body mark">
      <div class="total">
        <span>78</span><br/>营销目标
      </div>
      <div class="mark_detail">
                       套餐升档 <span class="color_orange">45</span><br/>
	           宽带维系 <span class="color_orange">45</span><br/>
                       异网策反 <span class="color_orange">45</span><br/>
      </div>
	</div>
  </div>
  <table class="village_tab">
    <thead>
      <tr>
        <th>序号</th>
        <th>四级地址</th>
        <th>合计</th>
        <th>宽带维系</th>
        <th>套餐升档</th>
        <th>异网策反</th>
      </tr>
    </thead>
    <tr>
      <td>1</td>
      <td>岷州人家小区一单元</td>
      <td><a href="viewPlane_village_view_details.jsp">60</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
    </tr>
    <tr>
      <td>2</td>
      <td>岷州人家小区二单元</td>
      <td><a href="viewPlane_village_view_details.jsp">60</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
    </tr>
    <tr>
      <td>3</td>
      <td>岷州人家小区三单元</td>
      <td><a href="viewPlane_village_view_details.jsp">60</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
      <td><a href="viewPlane_village_view_details.jsp">20</a></td>
    </tr>
  </table>


</div>
<!-- 信息收集 -->
<div class="build_info_win info_edit_win" id="info_edit" style="display:none;">
	<div class="titlea"><div id="build_title" style='text-align:left'>信息编辑</div><div class="titlec" onclick="$('#info_edit').hide()"></div></div>

	<div class="base" style="height:80px;border:none;margin-top:8px;">
		<div class="base1"><span class="bb1">详细地址：<span id="bb1">	定西市安定区福门新天地住宅小区1号楼1单元</span></span></div>
		<div class="base1"><span class="col_2">联系人：<span id="bb7"></span><input id="bb2" type="text" class="info_input"/></span><span class="col_2r">联系电话：<span id='bb3'><input id="bb5" type="text" class="info_input" /></span></span></div>
		<div class="base1"><span class="col_2">人口数：<span id='bb4'></span><input id="bb6" type="text" class="info_input"/></span><span class="col_2r">人均收入：<span id='bb8'></span><input id="bb9" type="text" class="info_input"/></span></div>
	</div>

	<div class="yin">
		<h3 class="wrap_a">业务信息</h3>
		<table class="table_yw">
			<tr>
				<th width="52">业务</th>
				<th width="140">运营商</th>
				<th>号码</th>
				<th>备注</th>
			</tr>
			<tr>
				<td>宽带</td>
				<td class="manufacture"><span class="active">电信</span> <span>移动</span> <span>联通</span></td>
				<td><input id="bb10" type="text" value="" class="num_input"/></td>
				<td><input id="bb11" type="text" value="" class="note_input"/></td>
			</tr>
			<tr>
				<td>电视</td>
				<td class="manufacture"><span>电信</span> <span>移动</span> <span>联通</span></td>
				<td><input id="bb12" type="text" value="" class="num_input"/></td>
				<td><input id="bb13" type="text" value="" class="note_input"/></td>
			</tr>
			<tr>
				<td>固话</td>
				<td class="manufacture"><span>电信</span> <span>移动</span> <span>联通</span></td>
				<td><input id="bb14" type="text" value="" class="num_input"/></td>
				<td><input id="bb15" type="text" value="" class="note_input"/></td>
			</tr>
			<tr class="noborder">
				<td rowspan="3">移动</td>
				<td class="manufacture" width="140" style="text-align:center;"><span class="long">电信</span></td>
				<td><input id="bb16" type="text" value="" class="num_input"/></td>
				<td><input id="bb17" type="text" value="" class="note_input"/></td>
			</tr>
			<tr class="noborder">
				<td class="manufacture" width="140" style="text-align:center;"><span class="long" style="margin-right:13px;">移动</span></td>
				<td><input id="bb18" type="text" value="" class="num_input"/></td>
				<td><input id="bb19" type="text" value="" class="note_input"/></td>
			</tr>
			<tr class="noborder">

				<td class="manufacture" width="140" style="text-align:center;"><span class="long" style="margin-right:13px;">联通</span></td>
				<td><input id="bb20" type="text" value="" class="num_input"/></td>
				<td><input id="bb21" type="text" value="" class="note_input"/></td>
			</tr>

		</table>

	</div>
	<input type="hidden" value="" id="hiddin"/>
	<div class="button_area"><button id="OK_1">确认</button>&nbsp;&nbsp;&nbsp;<button id="edit_cancel">取消</button></div>
</div>
<!-- 信息手机end -->

<script type="text/javascript">
	$('#test2').on('click', function(){
		$('#detail_more_in').show();
	});
	var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
	var clickChangeSingleTable='';
	$(function(){
		var type = '${param.vis}'
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
		function getData(res_id){
			var table=$("#bmt")
			table.html("")
			$.post('<e:url value="villageAll.e"/>', {
				res_id: res_id
			}, function (data) {
				data = $.parseJSON($.trim(data));
				//层数排序
				data = sortBuilding(data);
				$.each(data,function (index, floor) {
					//高楼层到低楼层的排列,一次循环为一行
					var str=""
					var display=false;
					$.each(floor,function(i,d){
						var arr = getIconClass(d.IS_KD,d.IS_GU,d.IS_ITV);
						if(type!=null&&type!=undefined){
							if ((type=='kd'&&d.IS_KD>0)||(type=='itv'&&d.IS_ITV>0)||(type=='gu'&&d.IS_GU>0)||type=='all'){
								if(!display)
								//clickChangeSingleTable(d.SEGM_ID_2);
									display=true;
								var str2='<div class=\"manufactuer\">电信</div>'
								if(d.IS_KD==0&&d.IS_ITV==0&&d.IS_GU==0){
									str2="<div class=\"manufactuer_nothing\">未装</div>"
								}
								var un=d.DX_CONTACT_PERSON;
								if(un==null)
									un = d.CMCC_CONTACT_PERSON;
								else if(un=="-")
									un = d.LT_CONTACT_PERSON;

								if(un==null)
									un = "-";

								un = (un.length>5?un.substr(0,5):un);
								str+="<li> "+
								str2+
								"<h4><a href=\"javascript:void(0)\" id=\"test2\" onclick=\"clickChangeSingleTable('"+d.SEGM_ID_2+"')\">"+d.SEGM_NAME_2+"</a></h4><span>"+un+(d.USER_CONTACT_NBR==null?"":phoneHide(d.USER_CONTACT_NBR))+"</span> " +
								"<div class=\"icons\"><span class=\""+arr[0]+"\"></span><span class=\""+arr[2]+"\"></span><span class=\""+arr[1]+"\"></span></div> " +
								"<div class=\"bottom_info\"> " +
								"<div class=\"market_info\">营销派单<span>(0)</span></div> " +
								"<div class=\"info_get\">资料收集<span class=\"get\"></span></div></div></li>"
							}
						}
						var hhhsa = $("#hhhsa");
						var str_s = "<tr>" +
								"<td><div class=\"td_normal\"><a href=\"javascript:void(0)\" class=\"show_edit\" onclick=\"clickChangeSingleTable('"+d.SEGM_ID_2+"')\">"+d.SEGM_NAME_2+"</a></div></td>" ;
						if(d.DX_CONTACT_PERSON!=null){
							str_s+="<td><div class=\"td_wide\">"+d.DX_CONTACT_PERSON+"</div></td> " +
							"<td><div class=\"td_wide\">"+(d.DX_CONTACT_NBR==null?"-":d.DX_CONTACT_NBR)+"</div></td> " ;
						}else if(d.CMCC_CONTACT_PERSON!='-'){
							str_s+="<td><div class=\"td_wide\">"+d.CMCC_CONTACT_PERSON+"</div></td> " +
							"<td><div class=\"td_wide\">"+d.CMCC_CONTACT_NBR+"</div></td> " ;
						}else if(d.LT_CONTACT_PERSON!='-'){
							str_s+="<td><div class=\"td_wide\">"+d.LT_CONTACT_PERSON+"</div></td> " +
							"<td><div class=\"td_wide\">"+d.LT_CONTACT_NBR+"</div></td> " ;
						}else{
							str_s+="<td><div class=\"td_wide\">-</div></td> " +
							"<td><div class=\"td_wide\">-</div></td> " ;
						}
						str_s+="<td><div class=\"td_mid\">"+(d.PEOPLE_COUNT==null?"-":d.PEOPLE_COUNT)+"</div></td> " +
						"<td><div class=\"td_mid2\">"+(d.INCOME_AVG==null?"-":d.INCOME_AVG)+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_KD>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_KD_CMCC>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_KD_LT>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_ITV>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_ITV_CMCC>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_ITV_LT>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_GU>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_GU_CMCC>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_GU_LT>0?"<span></span>":"-")+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_YD=='-'?"-":d.IS_YD)+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_YD_CMCC=='-'?"-":d.IS_YD_CMCC)+"</div></td> " +
						"<td><div class=\"td_normal\">"+(d.IS_YD_LT=='-'?"-":d.IS_YD_LT)+"</div></td> " +
						"</tr>";
						hhhsa.append(str_s);

					});
					str+="";
					if(display){
						table.append(str);
					}
				})
			})
		}
		//2018.10.22 号码脱敏
		function phoneHide(phone){
			var d = phone.substr(0,3);
			for(var i = 0,l = phone.length-5;i<l;i++){
				d += "*";
			}
			return d+phone.substr(-2);
		}
		function getIconClass(brd,gh,itv) {
			var arr=[];
			arr[0]=brd>0?"broad active":"broad";
			arr[1]=gh>0?"tele active":"tele";
			arr[2]=itv>0?"itv active":"itv";
			return arr;
		}
		var tmp=false;
		clickChangeSingleTable = function (id) {
			/*$("#x1").text(name_2)
			 $("#x2").text(name)
			 $("#x3").text(people)
			 $("#x4").text(income)
			 $("#x5").text(phone)
			 $("#x6").text(yys)
			 $("#x7").text(kd)
			 $("#x8").text(ds)
			 $("#x9").text(gh)
			 $("#xx").text(yd)*/
			$("#bb5").next().remove();
			$("#bb14").next().remove();
			$("#bb16").next().remove();
			$("#bb18").next().remove();
			$("#bb20").next().remove();

			$("#hiddin").val(id);
			$.post(url4Query, {eaction:'getYX',segm_id_2: id}, function (data){
				data = $.parseJSON($.trim(data));
				if(data==null)
					return;
				//console.log(data);
				$("#bb1").text(data.STAND_NAME_2);
				//联系人和联系方式
				if(data.DX_CONTACT_PERSON!=null){
					$("#bb2").val(data.DX_CONTACT_PERSON);
					$("#bb5").val(data.DX_CONTACT_NBR==null?'':data.DX_CONTACT_NBR);
				}else if(data.CMCC_CONTACT_PERSON!=null){
					$("#bb2").val(data.CMCC_CONTACT_PERSON=='-'?'':data.CMCC_CONTACT_PERSON);
					$("#bb5").val(data.CMCC_CONTACT_NBR=='-'?'':data.CMCC_CONTACT_NBR);
				}else{
					$("#bb2").val(data.LT_CONTACT_PERSON=='-'?'':data.LT_CONTACT_PERSON);
					$("#bb5").val(data.LT_CONTACT_NBR=='-'?'':data.LT_CONTACT_NBR);
				}
				$("#bb6").val(data.PEOPLE_COUNT==null?'':data.PEOPLE_COUNT);
				$("#bb9").val(data.INCOME_AVG==null?'':data.INCOME_AVG);
				/*$(".manufacture > span").click(function(){
				 $(this).addClass("active");
				 $(this).siblings().removeClass("active");
				 });*/
				//宽带
				if(data.KD_DX_NBR!=null){
					$(".manufacture:eq(0) > span:eq(0)").addClass("active");
					$(".manufacture:eq(0) > span:eq(0)").siblings().removeClass("active");
					$("#bb10").val(data.KD_DX_NBR);
					$("#bb11").val(data.DX_KD_COMMENTS==null?'':data.DX_KD_COMMENTS);
				}else if(data.KD_CMCC_NBR!=null){
					$(".manufacture:eq(0) > span:eq(1)").addClass("active");
					$(".manufacture:eq(0) > span:eq(1)").siblings().removeClass("active");
					$("#bb10").val(data.KD_CMCC_NBR);
					$("#bb11").val(data.CMCC_KD_COMMENTS==null?'':data.CMCC_KD_COMMENTS);
				}else if(data.KD_LT_NBR!=null){
					$(".manufacture:eq(0) > span:eq(2)").addClass("active");
					$(".manufacture:eq(0) > span:eq(2)").siblings().removeClass("active");
					$("#bb10").val(data.KD_LT_NBR);
					$("#bb11").val(data.LT_KD_COMMENTS==null?'':data.LT_KD_COMMENTS);
				}else{
					$(".manufacture:eq(0) > span:eq(0)").removeClass("active");
					$(".manufacture:eq(0) > span:eq(0)").siblings().removeClass("active");
					$("#bb10").val("");
					$("#bb11").val("");
				}

				//电视
				if(data.ITV_DX_NBR!=null){
					$(".manufacture:eq(1) > span:eq(0)").addClass("active");
					$(".manufacture:eq(1) > span:eq(0)").siblings().removeClass("active");
					$("#bb12").val(data.ITV_DX_NBR);
					$("#bb13").val(data.DX_ITV_COMMENTS==null?'':data.DX_ITV_COMMENTS);
				}else if(data.ITV_CMCC_NBR!=null){
					$(".manufacture:eq(1) > span:eq(1)").addClass("active");
					$(".manufacture:eq(1) > span:eq(1)").siblings().removeClass("active");
					$("#bb12").val(data.ITV_CMCC_NBR);
					$("#bb13").val(data.CMCC_ITV_COMMENTS==null?'':data.CMCC_ITV_COMMENTS);
				}else if(data.ITV_LT_NBR!=null){
					$(".manufacture:eq(1) > span:eq(2)").addClass("active");
					$(".manufacture:eq(1) > span:eq(2)").siblings().removeClass("active");
					$("#bb12").val(data.ITV_LT_NBR);
					$("#bb13").val(data.LT_ITV_COMMENTS==null?'':data.LT_ITV_COMMENTS);
				}else{
					$(".manufacture:eq(1) > span:eq(0)").removeClass("active");
					$(".manufacture:eq(1) > span:eq(0)").siblings().removeClass("active");
					$("#bb12").val("");
					$("#bb13").val("");
				}

				//固话
				if(data.GU_DX_NBR!=null){
					$("#bb14").val(data.GU_DX_NBR);
					$(".manufacture:eq(2) > span:eq(0)").addClass("active");
					$(".manufacture:eq(2) > span:eq(0)").siblings().removeClass("active");
					$("#bb15").val(data.DX_GU_COMMENTS==null?'':data.DX_GU_COMMENTS);
				}else if(data.GU_CMCC_NBR!=null){
					$(".manufacture:eq(2) > span:eq(1)").addClass("active");
					$(".manufacture:eq(2) > span:eq(1)").siblings().removeClass("active");
					$("#bb14").val(data.GU_CMCC_NBR);
					$("#bb15").val(data.CMCC_GU_COMMENTS==null?'':data.CMCC_GU_COMMENTS);
				}else if(data.GU_LT_NBR!=null){
					$(".manufacture:eq(2) > span:eq(2)").addClass("active");
					$(".manufacture:eq(2) > span:eq(2)").siblings().removeClass("active");
					$("#bb14").val(data.GU_LT_NBR);
					$("#bb15").val(data.LT_GU_COMMENTS==null?'':data.LT_GU_COMMENTS);
				}else{
					$(".manufacture:eq(2) > span:eq(0)").removeClass("active");
					$(".manufacture:eq(2) > span:eq(0)").siblings().removeClass("active");
					$("#bb14").val("");
					$("#bb15").val("");
				}

				//电信、移动、联通的移动号码
				$("#bb16").val(data.YD_DX_NBR==null?'':data.YD_DX_NBR);
				$("#bb17").val(data.DX_YD_COMMENTS==null?'':data.DX_YD_COMMENTS);
				$("#bb18").val(data.YD_CMCC_NBR==null?'':data.YD_CMCC_NBR);
				$("#bb19").val(data.CMCC_YD_COMMENTS==null?'':data.CMCC_YD_COMMENTS);
				$("#bb20").val(data.YD_LT_NBR==null?'':data.YD_LT_NBR);
				$("#bb21").val(data.LT_YD_COMMENTS==null?'':data.LT_YD_COMMENTS);
			})

		}
		if('${param.res_id}'!="")
			getData('${param.res_id}')

		$("#OK_1").click(function () {
			var id = $("#hiddin").val();
			var bb2 = $("#bb2").val();
			var bb5 = $("#bb5").val();
			var bb6 = $("#bb6").val();
			var bb9 = $("#bb9").val();
			var bb10 = $("#bb10").val();
			var bb11 = $("#bb11").val();
			var bb12 = $("#bb12").val();
			var bb13 = $("#bb13").val();
			var bb14 = $("#bb14").val();
			var bb15 = $("#bb15").val();
			var bb16 = $("#bb16").val();
			var bb17 = $("#bb17").val();
			var bb18 = $("#bb18").val();
			var bb19 = $("#bb19").val();
			var bb20 = $("#bb20").val();
			var bb21 = $("#bb21").val();
			//判断宽带选择 1电信 2移动 3联通 ""为没填
			var tmp0 = "";
			if($(".manufacture:eq(0) > span:eq(0)").attr("class")=="active"){
				tmp0 = "1";
			}else if($(".manufacture:eq(0) > span:eq(1)").attr("class")=="active"){
				tmp0 = "2";
			}else if($(".manufacture:eq(0) > span:eq(2)").attr("class")=="active"){
				tmp0 = "3";
			}
			//判断电视选择 1电信 2移动 3联通 ""为没填
			var tmp1 = "";
			if($(".manufacture:eq(1) > span:eq(0)").attr("class")=="active"){
				tmp1 = "1";
			}else if($(".manufacture:eq(1) > span:eq(1)").attr("class")=="active"){
				tmp1 = "2";
			}else if($(".manufacture:eq(1) > span:eq(2)").attr("class")=="active"){
				tmp1 = "3";
			}
			//判断固话选择 1电信 2移动 3联通 ""为没填
			var tmp2 = "";
			if($(".manufacture:eq(2) > span:eq(0)").attr("class")=="active"){
				tmp2 = "1";
			}else if($(".manufacture:eq(2) > span:eq(1)").attr("class")=="active"){
				tmp2 = "2";
			}else if($(".manufacture:eq(2) > span:eq(2)").attr("class")=="active"){
				tmp2 = "3";
			}

			//号码验证不通过时，标注错误的号码编辑框位置
			var invaildInput = new Array();
			var flag = true;
			var bb5_items = bb5.split(",");
			for(var i = 0,l = bb5_items.length;i<l;i++){
				var item = bb5_items[i];
				if(item!=''&&!( /^(0|86|17951)?(13[0-9]|15[012356789]|17[01678]|18[0-9]|14[57])[0-9]{8}$/.test(item)||/^(0[0-9]{2,3}\-)([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$/.test(item))){
					flag = false;
					invaildInput.push("bb5");
					break;
				}
			}
			var bb14_items = bb14.split(",");
			for(var i = 0,l = bb14_items.length;i<l;i++){
				var item = bb14_items[i];
				if(item!=''&&!/^(0[0-9]{2,3}\-)([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$/.test(item)){
					flag = false;
					invaildInput.push("bb14");
					break;
				}
			}
			var bb16_items = bb16.split(",");
			for(var i = 0,l = bb16_items.length;i<l;i++){
				var item = bb16_items[i];
				if(item!=''&&!( /^(0|86|17951)?(13[0-9]|15[012356789]|17[01678]|18[0-9]|14[57])[0-9]{8}$/.test(item))){
					flag = false;
					invaildInput.push("bb16");
					break;
				}
			}

			var bb18_items = bb18.split(",");
			for(var i = 0,l = bb18_items.length;i<l;i++){
				var item = bb18_items[i];
				if(item!=''&&!( /^(0|86|17951)?(13[0-9]|15[012356789]|17[01678]|18[0-9]|14[57])[0-9]{8}$/.test(item))){
					flag = false;
					invaildInput.push("bb18");
					break;
				}
			}
			var bb20_items = bb20.split(",");
			for(var i = 0,l = bb20_items.length;i<l;i++){
				var item = bb20_items[i];
				if(item!=''&&!( /^(0|86|17951)?(13[0-9]|15[012356789]|17[01678]|18[0-9]|14[57])[0-9]{8}$/.test(item))){
					flag = false;
					invaildInput.push("bb20");
					break;
				}
			}
			$("#bb5").next().remove();
			$("#bb14").next().remove();
			$("#bb16").next().remove();
			$("#bb18").next().remove();
			$("#bb20").next().remove();
			if(flag){
				$.post(url4Query, {eaction:'updateYX',segm_id_2: id,bb2:bb2,bb5:bb5,bb6:bb6,bb9:bb9,bb10:bb10,bb11:bb11,bb12:bb12,bb13:bb13,bb14:bb14,bb15:bb15,bb16:bb16,bb17:bb17,bb18:bb18,bb19:bb19,bb20:bb20,bb21:bb21,tmp0:tmp0,tmp1:tmp1,tmp2:tmp2}, function (data){
					layer.msg("修改成功!");
					$("#info_edit").hide();
				})
			}else{
				layer.msg("请输入正确的手机号!");
				for(var i = 0,l = invaildInput.length;i<l;i++){
					var elem_str = invaildInput[i];
					$("#"+elem_str).after("<span style='color:red;'>*</span>");
				}
			}
		})
	})
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
</script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#info_edit").draggable({handle: $("#info_edit > .titlea")});
		$(".manufacture > span").click(function () {$("#info_edit").draggable({handle:$("#info_edit > .titlea")});
			$(this).addClass("active");
			$(this).siblings().removeClass("active");
		});
		$(".build_detail li h4").live("click", function () {
			$("#info_edit").show();
		});
		$(".show_edit").live("click", function () {
			$("#info_edit").show();
		});
		$(".info_get").live("click", function () {
			$("#info_edit").show();
		});
		$("#edit_cancel").live("click", function () {
			$("#info_edit").hide();
		});
	});
</script>
</body>
</html>