<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
	select to_char((to_date(min(const_value), 'yyyymmdd')),'yyyymmdd') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<e:q4o var="lastMonth">
	select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '3'
</e:q4o>
<e:q4o var="lastMonth_market">
	select const_value val,substr(const_value,0,6) sub_val from SYS_CONST_TABLE WHERE const_type='var.dss27' AND const_name = 'calendar.curdate'
</e:q4o>
<e:q4o var="beforeLastMonth">
	select to_char(add_months(to_date(min(const_value),'yyyymm'),-1),'yyyymm') val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '3'
</e:q4o>
<e:q4o var="date_in_month">
	SELECT
	TO_CHAR(TO_DATE(MON_A, 'yyyymmdd'), 'yyyymmdd') AS CURRENT_FIRST,
	'${yesterday.val}' AS CURRENT_LAST,
	TO_CHAR(TO_DATE(MON_B, 'yyyymmdd'), 'yyyymmdd') AS LAST_FIRST,
	TO_CHAR(LAST_DAY(TO_DATE(MON_B, 'yyyymmdd')), 'yyyymmdd') AS LAST_LAST
	FROM (SELECT TO_CHAR(TO_DATE('${yesterday.val}', 'yyyymmdd'), 'yyyymm') || '01' MON_A,
	TO_CHAR(ADD_MONTHS(TO_DATE('${yesterday.val}', 'yyyymmdd'), -1),
	'yyyymm') || '01' MON_B
	FROM DUAL)
</e:q4o>
<e:q4o var="six_month">
	SELECT
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth.VAL}','yyyymm'), -5),'yyyymm') a,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth.VAL}','yyyymm'), -4),'yyyymm') b,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth.VAL}','yyyymm'), -3),'yyyymm') c,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth.VAL}','yyyymm'), -2),'yyyymm') d,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth.VAL}','yyyymm'), -1),'yyyymm') e,
	'${lastMonth.VAL}' f
	FROM dual
</e:q4o>
<e:q4o var="six_month_market">
	SELECT
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.SUB_VAL}','yyyymm'), -5),'yyyymm') a,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.SUB_VAL}','yyyymm'), -4),'yyyymm') b,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.SUB_VAL}','yyyymm'), -3),'yyyymm') c,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.SUB_VAL}','yyyymm'), -2),'yyyymm') d,
	TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.SUB_VAL}','yyyymm'), -1),'yyyymm') e,
	'${lastMonth_market.SUB_VAL}' f
	FROM dual
</e:q4o>
<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<c:resources type="easyui,app" style="b"/>
<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
<link href='<e:url value="/pages/telecom_Index/common/css/indexTabs_dev_sub_new.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>

<body style="width:100%;border:0px;overflow:hidden;height: 100%" class="g_target">
<h1></h1>

<div class="tab">
	<ul>
		<li class="active" style="cursor: pointer" id="market">市场<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="deve">发展<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="income">收入<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="resource">资源<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="village">行政村</li>
	</ul>
</div>

<%--市场tab--%>
<div id="base_content">
	<ul class="market_topline">
		<%--<li><span>住户数:</span><span id="ADDR_NUM_ID"  class="topline_orange">--</span></li>
        <li><span>光宽用户:</span><span id="PEOPLE_NUM_ID" class="topline_orange">--</span></li>
        <li><span>政企住户:</span><span  id="FTTH_PORT_NUM_ID" class="topline_orange">--</span></li>
        <li><span>政企光宽:</span><span id="FTTH_PORT_KX_NUM_ID" class="topline_orange">--</span></li>--%>
		<li><span>网格数:</span><span id="grid_num_id"  class="topline_orange">--</span></li>
		<li><span>行政村数:</span><span id="village_num_id" class="topline_orange">--</span></li>
		<li><span>社队数:</span><span  id="she_dui_num_id" class="topline_orange">--</span></li>
	</ul>
	<div class="target_wrap">
		<ul class="target_list clearfix">
			<li>
				<p class="target_title">市场</p>
				<dl>
					<dt id="t1" onMouseOver="javascript:show(this,'mydiv1');" onMouseOut="hide(this,'mydiv1')">- -</dt>
					<dd>- -</dd>
					<dd>- -
						<b class=""></b>
					</dd>
				</dl>
			</li>
			<li>
				<p class="target_title">收入</p>
				<dl>
					<dt id="t2" onMouseOver="javascript:show(this,'mydiv2');" onMouseOut="hide(this,'mydiv2')">- -</dt>
					<dd>- -</dd>
					<dd>- -
						<b class=""></b>
					</dd>
				</dl>
			</li>
			<%--<li class="b_none">
				<p class="target_title">利润</p>
				<dl>
					<dt id="t3" onMouseOver="javascript:show(this,'mydiv3');" onMouseOut="hide(this,'mydiv3')">- -</dt>
					<dd>- -</dd>
					<dd>- -
						<b class=""></b>
					</dd>
				</dl>
			</li>--%>
			<li class="b_none">
				<p class="target_title">发展</p>
				<dl>
					<dt id="t3" onMouseOver="javascript:show(this,'mydiv3');" onMouseOut="hide(this,'mydiv3')">- -</dt>
					<dd>- -</dd>
					<dd>- -
						<b class=""></b>
					</dd>
				</dl>
			</li>
		</ul>
	</div>
	<div class="target_wrap_e" style="position: relative;width: 98%;">
		<%--<ul>
			<li id="occupancy" style="cursor: pointer">市场渗透率<div class="line1" style="display:none;"></div></li>
			<li style="margin-left: 10px;cursor: pointer;display:none;" id="penetrance">渗透率</li>
		</ul>--%>
		<h3 class="wrap_a">市场渗透率</h3>
		<div class="figure" id="Histogram" style="display: none"></div>
		<div class="figure" id="occupancy_content"></div>
	</div>
	<div class="target_wrap_a" id="mark_sub">
		<%--<h3 class="wrap_a" style="border-left:none;padding-left: 0px">
			<a href="javascript:void(0)" class="active1" style="font-size: 14px;display: none;">市场渗透率</a><span style="color: #fa8513;display: inline-block;">| </span>
			<a href="javascript:void(0)" style="font-size: 14px;display: none;margin-left: 5px;margin-right: 5px">网格渗透</a><span style="color: #fa8513;display:none;">| </span>
			<a href="javascript:void(0)" style="font-size: 14px;display: none;">网格资源</a><span style="color: #fa8513;display:none;">| </span>
			<a href="javascript:void(0)" style="font-size: 14px;">网格渗透率</a>
		</h3>--%>
		<h3 class="wrap_a">网格渗透率</h3>
	   <div id="mark_sub_in">
	    <div class="layout" id="tab">
			<table id="sub" style="width:98%;cursor:pointer;position:absolute;top:0px;left: 0px;height: 98%;margin: 5px auto;">
			</table>
		</div>
	    <div class="layout" id="tab2">
			<table id="sub2" style="width:98%;cursor:pointer;position:absolute;top:0px;left: 0px;height: 98%;margin: 5px auto;">
			</table>
		</div>
	    <div class="layout" id="tab3">
		   	<table id="sub3" style="width:98%;cursor:pointer;position:absolute;top:0px;left: 0px;height: 98%;margin: 5px auto;">
		   	</table>
	    </div>
	    <div class="layout" id="tab4">
		   	<table id="sub4" style="width:98%;cursor:pointer;position:absolute;top:0px;left: 0px;height: 98%;margin: 5px auto;">
		   	</table>
	    </div>
	  </div>
	</div>
</div>

<%--发展tab--%>
<div id="base_content_a" style="display: none">
	<div class="target_dev" style="width: 100%">
		<div class="devep">
			<div class="deve_ta">
				<div class="tave">移<br/>动</div>
				<div class="tava">
					<div  class="tavae"  id="m_n"></div>
					<div style="width: 100%;color: #8fa1c3;font-size: 12px">当日发展</div>
				</div>
			</div>
			<div class="deve_tb">

				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">本月累计：<span id="m_mn"></span></span><span style="position: absolute;left: 128px;">环比：<span id="m_raito"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">出账用户：<span id="m_cz"></span></span><span style="position: absolute;left: 128px;">本月净增：<span id="m_jz"></span></span></div>

			</div>
		</div>
		<div class="devep" >
			<div class="deve_ta">
				<div class="tave">宽<br/>带</div>
				<div class="tava">
					<div class="tavae" id="b_n"></div>
					<div style="width: 100%;color: #8fa1c3;font-size: 12px">当日发展</div>
				</div>
			</div>
			<div class="deve_tb">

				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">本月累计：<span id="b_mn"></span></span><span style="position: absolute;left: 128px;">环比：<span id="b_raito"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">计费用户：<span id="b_cz"></span></span><span style="position: absolute;left: 128px;">本月净增：<span id="b_jz"></span></span></div>

			</div>
		</div>
		<div class="devep">
			<div class="deve_ta">
				<div class="tave">电<br/>视</div>
				<div class="tava">
					<div class="tavae" id="i_n"></div>
					<div style="width: 100%;color: #8fa1c3;font-size: 12px">当日发展</div>
				</div>
			</div>
			<div class="deve_tb">

				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">本月累计：<span id="i_mn"></span></span><span style="position: absolute;left: 128px;">环比：<span id="i_raito"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">装机用户：<span id="i_cz"></span></span><span style="position: absolute;left: 128px;">本月净增：<span id="i_jz"></span></span></div>

			</div>
		</div>
	</div>
	<div class="target_wrap" style="position: relative;height:22% !important;width: 98%;">
		<h3 class="wrap_a" style="margin-top: 0px">日发展趋势</h3>
		<div class="btn_c">
			<ul id="tab_btn">
				<li class="btn_uc btn_active" data="0">
					<input type="button" value="移动" style="color: #fff;cursor:pointer;" />
				</li>
				<li class="btn_uc" data="1">
					<input type="button" value="宽带" style="color: #fff;cursor:pointer;" />
				</li>
				<li class="btn_uc" data="2">
					<input type="button" value="ITV" style="color: #fff;cursor:pointer;"/>
				</li>
			</ul>
		</div>
		<div class="day" id="day_fz1"></div>
	</div>
	<div class="target_wrap_b">
		<h3 class="wrap_a">网格信息<span class="_num" style="display:none;"></span></h3>
		<table id="asd" style=" width:98%;cursor:pointer;position:absolute;top:46px;left: 15px;height: 83%">
		</table>
	</div>
</div>

<%--收入tab--%>
<div id="base_content_b" style="display: none">
	<div class="target_wrap_in">
		<h3 class="wrap_a" style="margin-top: 0px">收入进度</h3>
		<ul class="in_plan">
			<li><div id="in_pie" style="height: 100px;width: 100px"></div><span id="wcjd_id" class="pie_number"> </span></li>
			<li><div class="paln_title1" id="income_budget_id"> </div><div class="paln_title2">预算目标</div></li>
			<li><div class="paln_title1" id="y_cum_income_id"> </div><div class="paln_title2">本年累计</div></li>
			<li><div class="paln_title1" id="income_budget_finish_rate_id"> </div><div class="paln_title2">完成进度</div></li>
		</ul>
	</div>
	<div class="target_wrap" style="position: relative;height:28% !important;width: 98%;">
		<h3 class="wrap_a" style="margin-top: 0px">收入趋势</h3>
		<div class="figure1" id="in_bar"></div>
	</div>
	<div class="target_wrap1" style="position: relative;width: 98%;border-bottom: none" id="in_target">
		<h3 class="wrap_a" style="margin-top: 10px;margin-left: 10px">网格收入</h3>
		<div>
			<table id="in_table" style="width:98%;cursor:pointer;position:absolute;top:30px;left: 15px;height: 90%;margin: 5px auto;padding-bottom: 20px">
			</table>
		</div>
	</div>
</div>

<%--资源--%>
<div id="base_content_c" style="display: none">
	<div class="target_dev_b" style="width: 100%">
		<h3 class="wrap_a">资源概况<span class="_num" style="display:none;"></span></h3>
		<div class="deveq">
			<div class="deve_tc">
				<div class="tavb">
					<div  class="tavae"  id="res_fib_percent"></div>
					<div style="width: 100%;color: #8fa1c3;font-size: 12px">光网覆盖率</div>
				</div>
			</div>
			<div class="deve_td">

				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">OBD数：<span id="obd_cnt"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">高占OBD：<span id="gz_obd_cnt"></span></span><span style="position: absolute;left: 128px;">零低OBD：<span id="0_obd_cnt"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">已达社队：<span id="resouce_reached_she_dui_cnt"></span></span><span style="position: absolute;left: 128px;">未达社队：<span id="resouce_unreach_she_dui_cnt"></span></span></div>

			</div>
		</div>
		<div class="deveq">
			<div class="deve_tc">
				<div class="tavb">
					<div class="tavae" id="res_port_percent"></div>
					<div style="width: 100%;color: #8fa1c3;font-size: 12px">端口占用率</div>
				</div>
			</div>
			<div class="deve_te">

				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">端口数：<span id="port_cnt"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">占用端口：<span id="used_port_cnt"></span></span><span style="position: absolute;left: 128px;">空闲端口：<span id="free_port_cnt"></span></span></div>
				<!--<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 9px">占用端口：<span id="used_port_cnt"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">空闲端口：<span id="free_port_cnt"></span></span></div>-->
			</div>
		</div>
	</div>
	<div class="target_wrap_d" id="res_target">
		<h3 class="wrap_a">行政村资源<span class="_num" style="display:none;"></span></h3>
		<table id="res_grid" style=" width:98%;cursor:pointer;position:absolute;top:46px;left: 15px;height: 83%">
		</table>
	</div>
</div>

<%--行政村--%>
<div id="base_content_d" style="display: none">
	<div class="target_dev_c" style="width: 100%">
		<div class="devep" style="margin-top:0px;">
			<h3 class="wrap_a">行政村概况<span class="_num" style="display:none;"></span></h3>
			<div class="deve_tc">
				<div class="tavb">
					<div class="tavae" id="village_cnt"></div>
					<div style="width: 100%;color: #8fa1c3;font-size: 12px">行政村数</div>
				</div>
			</div>
			<div class="deve_te">
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">社队数：<span id="she_dui_cnt"></span></span><span style="position: absolute;left: 128px;">人口数：<span id="ren_kou_cnt"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">光宽用户：<span id="h_user_cnt"></span></span></div>
			</div>
		</div>
	</div>
	<div class="target_wrap_c" id="village_target">
		<h3 class="wrap_a">行政村清单<span class="_num" style="display:none;"></span></h3>
		<table id="village_detail_list" style=" width:98%;cursor:pointer;position:absolute;top:46px;left: 15px;height: 83%">
		</table>
	</div>
</div>

<!-- 悬浮信息 begin-->
<div id="mydiv1" style="position:absolute;display:none;border:1px solid #333333;background:rgba(0,0,0,0.9);height: 28px;padding-top: 5px;padding-bottom:5px;padding-left: 5px;padding-right:5px;color: #fff;font-size: 12px;text-align: center;-webkit-border-radius: 4px;-moz-border-radius: 4px;-o-border-radius: 4px;border-radius: 4px;">
	市场占有率
</div>
<div id="mydiv2" style="position:absolute;display:none;border:1px solid #333333;background:rgba(0,0,0,0.9);height: 28px;padding-top: 5px;padding-bottom:5px;padding-left: 5px;padding-right:5px;color: #fff;font-size: 12px;text-align: center;-webkit-border-radius: 4px;-moz-border-radius: 4px;-o-border-radius: 4px;border-radius: 4px;">
	收入进度
</div>
<div id="mydiv3" style="position:absolute;display:none;border:1px solid #333333;background:rgba(0,0,0,0.9);height: 28px;padding-top: 5px;padding-bottom:5px;padding-left: 5px;padding-right:5px;color: #fff;font-size: 12px;text-align: center;-webkit-border-radius: 4px;-moz-border-radius: 4px;-o-border-radius: 4px;border-radius: 4px;">
	<%--本年累计利润(万元)--%>
	当日发展(户)
</div>
<!-- 悬浮信息 end-->

<%--<script src='<e:url value="/pages/telecom_Index/js/freshTab.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshChart.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshRank.js"/>' charset="utf-8"></script>--%>
  <script type="text/javascript" >
		//<![CDATA[
		$(function(){
			//市场页签 最下面三个表格
			$("#tab").hide();
			$("#tab2").hide();
			$("#tab3").hide();
			var $div_li =$("#mark_sub > .wrap_a > a");
			$div_li.click(function(){
				$(this).addClass("active1")            //当前<li>元素高亮
						.siblings().removeClass("active1");  //去掉其它同辈<li>元素的高亮
				var index =  $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
				$("#mark_sub_in > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
						.eq(index).show()   //显示 <li>元素对应的<div>元素
						.siblings().hide(); //隐藏其它几个同辈的<div>元素

                if(index==1){
                    $("#sub2").height($("#mark_sub").height() * 0.9);
                    $("#sub2").width($("#base_content").width());
                    var sub_width = $("#sub2").width();
                    $("#sub2").datagrid({
                        url:url4Query,
                        queryParams:{
                            //eaction:'getGridInfoBySubstation_new', 去掉了合计
                            eaction:'getGridInfoBySubstation_new',
                            yesterday:'${yesterday.VAL}',
                            last_month:'${lastMonth.VAL}',
                            substation:substation
                        },
                        fitColumns:false,
                        columns:[[
                            {field:'ROWNUM',title:'序号',align:'center',halign:'center',width: sub_width*0.1,
                                formatter:function(value,rowData){
                                    if(value==0)
                                        return "";
                                    return value;
                                }
                            },
                            {field:'GRID_NAME',title:'网格名称',align:'center',halign:'center',style:'margin-left:5px',width:sub_width*0.34,
                                formatter:function(value,rowData){
                                    if (width>=1360)length_standard=7
                                    if(width>=1520)length_standard=8

                                    if(value.length>length_standard)
                                        return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
                                    else{
                                    	if(value=='合计')
                                    		return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
                                    	return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
                                    }

                                }
                            },
                            {field:'CDMA_NUM_REATE',title:'移动<br/>渗透率',align:'center',halign:'center',width:sub_width*0.16,
                                formatter:function(value,rowData){
                                    if(isNaN(parseFloat(value)))
                                        return"";
                                    if(value!=null&&value!=undefined&&value!=-1)
                                        return ""+value.toFixed(1)+"%";
                                    else
                                        return "--";
                                }
                            },
                            {field:'BRD_NUM_RATE',title:'宽带<br/>渗透率',align:'center',halign:'center',width:sub_width*0.16,
                                formatter:function(value,rowData){
                                    if(isNaN(parseFloat(value)))
                                        return"";
                                    if(value!=null&&value!=undefined&&value!=-1)
                                        return ""+value.toFixed(1)+"%";
                                    else
                                        return "--";
                                }
                            },
                            {field:'HOME_NUM_RATE',title:'电视<br/>渗透率',align:'center',halign:'center',width:sub_width*0.16,
                                formatter:function(value,rowData){
                                    if(isNaN(parseFloat(value)))
                                        return"";
                                    if(value!=null&&value!=undefined&&value!=-1)
                                        return ""+value.toFixed(1)+"%";
                                    else
                                        return "--";
                                }
                            }
                        ]],
                        scrollbarSize:"8",
                        onLoadSuccess:function (data) {
                            $("._num").text(data.rows.length-1);
														//只有一行合计，则补齐下面的行，用空行
							if (data.rows.length == 0) {

								var rows = $("#sub2").datagrid("getRows");

								var copyRows = [];
								for (var j = 0; j < rows.length; j++) {
									copyRows.push(rows[j]);
								}

								for (var j = 0; j < copyRows.length; j++) {
									//删除行
									var index = $('#sub2').datagrid('getRowIndex', copyRows[j]);
									$('#sub2').datagrid('deleteRow', index);
								}

								for (var i = 0, l = 5; i < l; i++) {
									$('#sub2').datagrid('appendRow', {
										ROWNUM: '',
										GRID_NAME: '',
										CDMA_NUM_REATE: '',
										BRD_NUM_RATE: '',
										HOME_NUM_RATE: ''
									});
								}
							}
                        },onClickRow: function (index,row){
                            //global_substation_sub = "";
                            //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
                        }
                    });
                }else if(index==2) {
                    $("#sub3").height($("#mark_sub").height() * 0.9);
                    $("#sub3").width($("#base_content").width());
                    var sub_width = $("#sub3").width();
                    $("#sub3").datagrid({
						url: url4Query,
						queryParams: {
							eaction: 'getGridResourceBySubstation',
							substation: substation
						},
                        fitColumns:false,
                        columns:[[
                            {field:'ROWNUM',title:'序号',align:'center',halign:'center',width: sub_width*0.1,
                            	formatter:function(value,rowData){
                                    if(value==0)
                                        return "";
                                    return value;
                              }
                            },
                            {field:'GRID_NAME',title:'网格名称',align:'center',halign:'center',width:sub_width*0.25,
								formatter:function(value,rowData){
                                    if (width>=1360)length_standard=7
                                    if(width>=1520)length_standard=8

                                    if(value.length>length_standard)
                                        return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
                                    else{
                                    	if(value=='合计')
                                    		return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
                                    	return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
                                    }

                                }
                            },
                            {field:'ZHU_HU_COUNT',title:'住户数',align:'center',halign:'center',width:sub_width*0.15,
                            	formatter:function(value,rowData){
                                    if(value==-1)
                                        return "";
                                    return value;
                              }
                            },
                            /*{field:'PEOPLE_NUM',title:'人口数',align:'center',halign:'center',width:sub_width*0.12,
                            	formatter:function(value,rowData){
                                    if(value==-1)
                                        return "";
                                    return value;
                              }

                            },*/
                            {field:'PORT',title:'端口',align:'center',halign:'center',width:sub_width*0.15,
                            	formatter:function(value,rowData){
                                    if(value==-1)
                                        return "";
                                    return value;
                              }

                            },
                            {field:'PORT_FREE',title:'空闲</br>端口',align:'center',halign:'center',width:sub_width*0.15,
                            	formatter:function(value,rowData){
                                    if(value==-1)
                                        return "";
                                    return value;
                              }
                            },
                            {field:'PORT_LV',title:'占用率',align:'center',halign:'center',width:sub_width*0.15,
								formatter:function(value,rowData){
									return value;
                              	}
                            }


                        ]],
                        scrollbarSize:"8",
                        onLoadSuccess:function (data) {
                            $("._num").text(data.rows.length);
							if (data.rows.length == 0) {

								var rows = $("#sub3").datagrid("getRows");

								var copyRows = [];
								for (var j = 0; j < rows.length; j++) {
									copyRows.push(rows[j]);
								}

								for (var j = 0; j < copyRows.length; j++) {
									//删除行
									var index = $('#sub3').datagrid('getRowIndex', copyRows[j]);
									$('#sub3').datagrid('deleteRow', index);
								}

								for (var i = 0, l = 5; i < l; i++) {
									$('#sub3').datagrid('appendRow', {
										ROWNUM: '',
										GRID_NAME: '',
										ZHU_HU_COUNT: '',
										PEOPLE_NUM: '',
										PORT: '',
										PORT_FREE: '',
										PORT_LV: ''
									});
								}
							}
                        },onClickRow: function (index,row){
                            //global_substation_sub = "";
                            //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
                        }
                    });
				}else if(index==3) {
					if(isIE()) {
						$("#sub4").height($("#mark_sub").height() * 0.82);
					}
					$("#sub4").height($("#mark_sub").height() * 0.82);
					$("#sub4").width($("#base_content").width());

					market_lv_datagrid();
				}
			})
		})
		//]]>

  </script>
  <script>
    var parent_name = parent.global_parent_area_name;
    var city_full_name = parent.global_current_full_area_name;
    var city_name = parent.global_current_area_name;
    var city_id = parent.global_current_city_id;
    var index_type = parent.global_current_index_type;
    var flag = parent.global_current_flag;
    var url4echartmap = parent.url4echartmap;
    parent.global_position.splice(0,1,province_name);
    parent.updatePosition(flag);

    /*var last_month_first = parent.last_month_first;
    var last_month_last = parent.last_month_last;
    var current_month_first = parent.current_month_first;
    var current_month_last = parent.current_month_last;*/
    var last_month_first = '${date_in_month.LAST_FIRST}';
    var last_month_last = '${date_in_month.LAST_LAST}';
    var current_month_first = '${date_in_month.CURRENT_FIRST}';
    var current_month_last = '${date_in_month.CURRENT_LAST}';

    var url4Query = parent.url4Query;
	var url4Query_index = '<e:url value="pages/telecom_Index/common/sql/tabData_index_sub_vc.jsp" />';

	var url4Query_sandSummary = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_village_cell.jsp" />';

    if(isIE()) {
        $("#Histogram").height($(".target_wrap").height());
    }
    var myChart = echarts.init(document.getElementById('Histogram'));
	var myChart2 = echarts.init(document.getElementById('occupancy_content'));
	var myChart3 = echarts.init(document.getElementById('in_pie'));
	var myChart4 = echarts.init(document.getElementById('in_bar'));
    var substation = parent.global_substation;

	function hideAllTab(){
		$('#market').removeClass("active");
		$('#deve').removeClass("active");
		$('#income').removeClass("active");
		$('#resource').removeClass("active");
		$('#village').removeClass("active");
		$('#base_content').css({display:'none'});
		$('#base_content_a').css({display:'none'});
		$('#base_content_b').css({display:'none'});
		$('#base_content_c').css({display:'none'});
		$('#base_content_d').css({display:'none'});
	}

	//大页签市场
    $('#market').on('click',function(){
		hideAllTab();
        $('#base_content').css({display:'block'});
        $('#market').addClass("active")
    })
	//大页签发展
	$('#deve').on('click',function(){
		hideAllTab();
		$('#base_content_a').css({display:'block'});
		$('#deve').addClass("active")

		if(isIE()) {
			$("#day_fz1").height($(".target_wrap").eq(1).height());
		}
		$("#day_fz1").height($(".target_wrap").eq(1).height()*0.93);

		//发展列表
		if(isIE()) {
			$("#asd").height($("#base_content_a").height()*0.32);
		}
		var asd_width =  $("#base_content_a").width();
		$("#asd").datagrid({
			url:url4Query,
			columns:[[
				{field:'ROWNUM',title:'序号',width:asd_width*0.1,align:'center',halign:'center',
					formatter:function(value,rowData){
					  if(value==0)
						  return "";
					  return value;
				  }
				},
				{field:'GRID_NAME',title:'网格名称',width:asd_width*0.26,align:'center',halign:'center',
					formatter:function(value,rowData){
						if (width>=1360)length_standard=7
						if(width>=1520)length_standard=8

						if(value.length>length_standard)
						   return "<u title='"+value+"' style='cursor: pointer' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
						else{
							if(value=='合计')
								return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;'>"+value+"</span>";
							return "<u title='"+value+"' style='cursor: pointer' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
						}

					}
				},
				{field:'MOBILE_MON_CUM_NEW',title:'移动当月',width:asd_width*0.19,align:'center',halign:'center'},
				{field:'BRD_MON_CUM_NEW',title:'宽带当月',width:asd_width*0.19,align:'center',halign:'center'},
				{field:'ITV_SERV_CUR_MON_NEW',title:'ITV当月',width:asd_width*0.19,align:'center',halign:'center'}
			]],
			queryParams:{
				eaction:'getGridMsgBySubstation',
				yesterday:'${yesterday.VAL}',
				last_month:'${lastMonth.VAL}',
				substation:substation
			},
			onLoadSuccess:function (data) {
				$("._num").text(data.rows.length - 1);

				if (data.rows.length == 0) {

					var rows = $("#asd").datagrid("getRows");

					var copyRows = [];
					for (var j = 0; j < rows.length; j++) {
						copyRows.push(rows[j]);
					}

					for (var j = 0; j < copyRows.length; j++) {
						//删除行
						var index = $('#asd').datagrid('getRowIndex', copyRows[j]);
						$('#asd').datagrid('deleteRow', index);
					}

					for (var i = 0, l = 4; i < l; i++) {
						$('#asd').datagrid('appendRow', {
							ROWNUM: '',
							GRID_NAME: '',
							MOBILE_MON_CUM_NEW: '',
							BRD_MON_CUM_NEW: '',
							ITV_SERV_CUR_MON_NEW: ''
						});
					}
				}
			}
		});
    });
	//大页签收入
    $('#income').on('click',function(){
		hideAllTab();
		$('#base_content_b').css({display:'block'});
		$('#income').addClass("active");

		$.post(url4Query,{eaction:'three_index',flag:flag,latn_id:city_id,last_month:'${lastMonth.VAL}',click_name:city_full_name,substation:substation},function(data){
			data=$.parseJSON(data)
			$("#income_budget_id").text(data.INCOME_BUDGET==-1?'--':data.INCOME_BUDGET);
			$("#y_cum_income_id").text(data.Y_CUM_INCOME==-1?'--':data.Y_CUM_INCOME);
			if(data.INCOME_BUDGET_FINISH_RATE!=-1){
				$("#income_budget_finish_rate_id").text(""+data.INCOME_BUDGET_FINISH_RATE+"%");
				$("#wcjd_id").text(""+data.INCOME_BUDGET_FINISH_RATE+"%");
			}else{
				$("#income_budget_finish_rate_id").text("--");
				$("#wcjd_id").text("0%");
			}

			freshPie(data.INCOME_BUDGET_FINISH_RATE!=-1?data.INCOME_BUDGET_FINISH_RATE:0,100);
		})

		myChart4.resize();
		freshBar();

		$("#in_table").height($("#in_target").height()*0.82);
		var sub_width = $("#in_target").width();
		$("#in_table").datagrid({
			url:url4Query,
			queryParams:{
				eaction:'getGridInfoBySubstation_zjsr',
				yesterday:'${yesterday.VAL}',
				beforeLastMonth:'${beforeLastMonth.VAL}',
				last_month:'${lastMonth.VAL}',
				substation:substation,
				latn_id:city_id,
				click_name:city_full_name
			},
			fitColumns:false,
			columns:[
				[
					{field:'ROWNUM',title:'序号',align:'center',halign:'center',width: sub_width*0.12,
						formatter:function(value,rowData){
							if(value=='0')
								return "";
							return value;
						}
					},
					{field:'GRID_NAME',title:'网格名称',align:'left',halign:'center',width:sub_width*0.34,
						formatter:function(value,rowData){
							if (width>=1360)length_standard=7
							if(width>=1520)length_standard=8
							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
							}

						}
					},
					{field:'FIN_INCOME',title:'当月',align:'center',halign:'center',width:sub_width*0.16
					},
					{field:'FIN_INCOME_LAST',title:'上月',align:'center',halign:'center',width:sub_width*0.16
					},
					{field:'INCOME_RATIO',title:'环比',align:'center',halign:'center',width:sub_width*0.16,
						formatter: function (value, rowData) {
							if (isNaN(parseFloat(value)))
								return "";
							if (value != null && value != undefined && value != -1)
								return "" + value.toFixed(2) + "%";
							else
								return "--";
						}
					}
					/*{field:'FTTH_NUM_RATE',title:'光网<br/>入户率',align:'center',halign:'center',width:sub_width*0.14,
					 formatter:function(value,rowData){
					 if(isNaN(parseFloat(value)))
					 return"";
					 if(value!=null&&value!=undefined&&value!=-1)
					 return ""+value.toFixed(2)+"%";
					 else
					 return "--";
					 }
					 }*/
				]],
			scrollbarSize:"8",
			onLoadSuccess:function (data) {
				$("._num").text(data.rows.length - 1);

				if (data.rows.length == 0) {

					var rows = $("#in_table").datagrid("getRows");

					var copyRows = [];
					for (var j = 0; j < rows.length; j++) {
						copyRows.push(rows[j]);
					}

					for (var j = 0; j < copyRows.length; j++) {
						//删除行
						var index = $('#in_table').datagrid('getRowIndex', copyRows[j]);
						$('#in_table').datagrid('deleteRow', index);
					}

					for (var i = 0, l = 4; i < l; i++) {
						$('#in_table').datagrid('appendRow', {
							ROWNUM: "",
							GRID_NAME: "",
							FIN_INCOME: "",
							FIN_INCOME_LAST: "",
							INCOME_RATIO: ""
						});
					}
				}
			},onClickRow: function (index,row){
				//global_substation_sub = "";
				//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
			}
		});
    })
	//大页签资源
	$("#resource").on("click",function(){
		hideAllTab();
		$('#base_content_c').css({display:'block'});
		$('#resource').addClass("active");

		$.post(url4Query_sandSummary,{"eaction":"get_info_all","substation":substation},function(data){
			var data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				$("#res_fib_percent").text(d.RESOURCE_RATE);
				$("#obd_cnt").text(d.OBD_CNT);
				$("#gz_obd_cnt").text(d.H_OBD_CNT);
				$("#0_obd_cnt").text(d.L_OBD_CNT);
				$("#resouce_reached_she_dui_cnt").text(d.ZY_CNT);
				$("#resouce_unreach_she_dui_cnt").text(d.RESOURCE_UNREACH_CNT);

				$("#res_port_percent").text(d.PORT_LV);
				$("#port_cnt").text(d.CAPACITY);
				$("#used_port_cnt").text(d.ACTUALCAPACITY);
				$("#free_port_cnt").text(d.FREE_PORT);
			}else{
				$("#res_fib_percent").text("--");
				$("#obd_cnt").text("0");
				$("#gz_obd_cnt").text("0");
				$("#0_obd_cnt").text("0");
				$("#resouce_reach_build_cnt").text("0");
				$("#resouce_unreach_build_cnt").text("0");

				$("#res_port_percent").text("--");
				$("#port_cnt").text("0");
				$("#used_port_cnt").text("0");
				$("#free_port_cnt").text("0");
			}
		});

		$("#res_grid").height($("#res_target").height()*0.85);
		var sub_width = $("#res_target").width();
		$("#res_grid").datagrid({
			url:url4Query_index,
			queryParams:{
				eaction:'resource_vc',
				substation:substation
			},
			fitColumns:false,
			columns:[
				[
					{field:'ROW_NUM',title:'序号',align:'center',halign:'center',width: sub_width*0.10,
						formatter:function(value,rowData){
							if(value=='0')
								return "";
							return value;
						}
					},
					{field:'ORG_NAME',title:'行政村',align:'center',halign:'center',width:sub_width*0.30,
						formatter:function(value,rowData){
							if (width>=1360)length_standard=7
							if(width>=1520)length_standard=8
							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value+"</u>";
							}

						}
					},
					{field:'ALL_OBD_CNT',title:'OBD数',align:'center',halign:'center',width:sub_width*0.13
					},
					{field:'PORT_CNT',title:'端口数',align:'center',halign:'center',width:sub_width*0.13
					},
					{field:'USE_PORT_CNT',title:'占用端口',align:'center',halign:'center',width:sub_width*0.14
					},
					{field:'PORT_LV',title:'端口占用率',align:'center',halign:'center',width:sub_width*0.18,
						formatter:function(value,rowData){
							return "<span style='color:#fa8513;'>"+value+"</span>";
						}
					}
				]],
			scrollbarSize:"8",
			onLoadSuccess:function (data) {
				$("._num").text(data.rows.length - 1);
				/*if (data.rows.length == 0) {

					var rows = $("#res_grid").datagrid("getRows");

					var copyRows = [];
					for (var j = 0; j < rows.length; j++) {
						copyRows.push(rows[j]);
					}

					for (var j = 0; j < copyRows.length; j++) {
						//删除行
						var index = $('#res_grid').datagrid('getRowIndex', copyRows[j]);
						$('#res_grid').datagrid('deleteRow', index);
					}

					for (var i = 0, l = 4; i < l; i++) {
						$('#res_grid').datagrid('appendRow', {
							ROWNUM: "",
							GRID_NAME: "",
							OBD_CNT: "",
							PORT_ID_CNT: "",
							USE_PORT_CNT: "",
							PORT_PERCENT: ""
						});
					}
				}*/
			},onClickRow: function (index,row){
				//global_substation_sub = "";
				//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
			}
		});
	})
	//大页签行政村
	$("#village").on("click",function(){
		hideAllTab();
		$('#base_content_d').css({display:'block'});
		$('#village').addClass("active");

		$.post(url4Query_index,{"eaction":"getVillgeCntByType","substation":substation},function(data){
			var data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				$("#ji_po_vill").text(d.JI_PO_VILL_CNT);
				$("#jin_po_vill").text(d.JIN_PO_VILL_CNT);
				$("#cao_xin_vill").text(d.CAO_XIN_VILL_CNT);
				$("#ping_wen_vill").text(d.PING_WEN_VILL_CNT);
			}else{
				$("#ji_po_vill").text("0");
				$("#jin_po_vill").text("0");
				$("#cao_xin_vill").text("0");
				$("#ping_wen_vill").text("0");
			}
		});
		$.post(url4Query_sandSummary,{"eaction":"get_info_all","substation":substation},function(data){
			var data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				$("#village_cnt").text(d.VILLAGE_CNT);
				$("#she_dui_cnt").text(d.BRIGADE_ID_CNT);
				$("#ren_kou_cnt").text(d.POPULATION_NUM);
				$("#h_user_cnt").text(d.H_USE_CNT);
			}else{
				$("#village_cnt").text("0");
				$("#she_dui_cnt").text("0");
				$("#ren_kou_cnt").text("0");
				$("#h_user_cnt").text("0");
			}
		});

		$("#village_detail_list").height($("#village_target").height());
		var sub_width = $("#village_target").width();
		$("#village_detail_list").datagrid({
			url:url4Query_index,
			queryParams:{
				eaction:'market_vc',
				substation:substation
			},
			fitColumns:false,
			columns:[
				[
					{field:'ROW_NUM',title:'序号',align:'center',halign:'center',width: sub_width*0.12,
						formatter:function(value,rowData){
							if(value=='0')
								return "";
							return value;
						}
					},
					{field:'VILLAGE_NAME',title:'行政村',align:'left',halign:'center',width:sub_width*0.32,
						formatter:function(value,rowData){
							return "<span title='"+value+"' style=\"color:white;text-decoration: underline;cursor:pointer;\" onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value+"</span>";
						}
					},
					{field:'MARKET_RATE',title:'市场渗透率',align:'center',halign:'center',width:sub_width*0.18,
						formatter:function(value,rowData){
							return "<span style='color:#fa8513;'>"+value+"</span>";
						}
					},
					{field:'ST_RATE_M',title:'本月提升',align:'center',halign:'center',width:sub_width*0.16
					},
					{field:'ST_RATE_Y',title:'本年提升',align:'center',halign:'center',width:sub_width*0.16
					}
				]],
			scrollbarSize:"8",
			onLoadSuccess:function (data) {
				console.log(data);
				$("._num").text(data.rows.length - 1);

				if (data.rows.length == 0) {

					var rows = $("#village_detail_list").datagrid("getRows");

					var copyRows = [];
					for (var j = 0; j < rows.length; j++) {
						copyRows.push(rows[j]);
					}

					for (var j = 0; j < copyRows.length; j++) {
						//删除行
						var index = $('#village_detail_list').datagrid('getRowIndex', copyRows[j]);
						$('#village_detail_list').datagrid('deleteRow', index);
					}

					for (var i = 0, l = 4; i < l; i++) {
						$('#village_detail_list').datagrid('appendRow', {
							ROW_NUM: "",
							VILLAGE_NAME: "",
							MARKET_RATE: "",
							ST_RATE_M: "",
							ST_RATE_Y: ""
						});
					}
				}
			},onClickRow: function (index,row){
				//global_substation_sub = "";
				//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
			}
		});
	})

	/*占有率渗透率切换*/
    $('#occupancy').on('click',function(){
        $('#occupancy_content').css({display:'block'})
        $('#Histogram').css({display:'none'})
        $('#penetrance').removeClass("active1")
        $('#occupancy').addClass("active1")
        freshFigue1();
    })

    var stl_data=new Array(3);//渗透率柱状图数据
    $('#penetrance').on('click',function(){
        $('#occupancy_content').css({display:'none'})
        $('#Histogram').css({display:'block'})
        $('#penetrance').addClass("active1")
        $('#occupancy').removeClass("active1")
        myChart.resize();
        freshFigue(stl_data);
    })

	//鼠标悬浮显示和离开不现实
    function show(obj,id) {
         var objDiv = $("#"+id+"");
         $(objDiv).css("display","block");
         $(objDiv).css("left", event.clientX);
         $(objDiv).css("top", event.clientY + 10);
	}

	function toMap_grid(union_org_code,branch_name,zoom,grid_name,station_id){
		parent.global_func_closeAllLayerWin();
		parent.clickToGridFromSub(union_org_code,branch_name,zoom,grid_name,station_id);
	}

	function toMap_village(village_id){
		parent.global_func_closeAllLayerWin();
		//parent.global_func_searchVillage(village_id);
		parent.global_func_operateVillage(village_id);
	}

    function hide(obj,id) {
        var objDiv = $("#"+id+"");
        $(objDiv).css("display", "none");
    }

    //var clickToGridFromSub = parent.clickToGridFromSub;
	function revetNameByRn(rn) {
		if (rn == 1)
			return "省";
		else if (rn == 2)
			return "市";
		else if (rn == 3)
			return "县";
		else if (rn == 4)
			return "支";
		else if (rn == 5)
			return "网";
	}
	//默认是展现的移动标签
	var div_index_type = 0;
	//日发展趋势 曲线图---begin
	//曲线图 移动 每日累计
	var current_month_data0 = new Array(31);//当月
	var last_month_data0 = new Array(31);//上月
	//曲线图 宽带 每日累计
	var current_month_data1 = new Array(31);//当月
	var last_month_data1 = new Array(31);//上月
	//曲线图 ITV 每日累计
	var current_month_data2 = new Array(31);//当月
	var last_month_data2 = new Array(31);//上月
	//曲线图 x轴 日期 31天
	var day_array = new Array();
	for(var i = 0,l = current_month_data0.length;i<l;i++){
		day_array.push(i+1);
	}
    $(function(){

		//三种基础数据 网格 行政村数 社队数
		summary_info();

        if(isIE()) {
            $("#sub4").height($("#mark_sub").height()*0.82);
        }
        $("#sub4").height($("#mark_sub").height()*0.82);

        var qx_name_temp = "";
        if(city_id==undefined){//百度地市层点某个区县，将来要替换成分局的模块
            if(city_name_speical.indexOf(parent_name)>-1)
                qx_name_temp = parent_name.replace(/州/gi,'');
            else
                qx_name_temp = parent_name.replace(/市/gi,'');
            city_id = city_ids[qx_name_temp];
        }
		//市场页签初始化
		market_tab();

		//发展页签初始化
		deve_tab();
		//发展页签 日发展趋势 移动宽itv日发展量折线图切换
		$(".btn_uc").each(function (index, obj) {
			$(this).on("click", function () {
				$(".btn_uc").removeClass("btn_active")
				$(this).addClass("btn_active")
				div_index_type = index;
				initChart()
			})
		})

        //当前位置信息（甘肃省>兰州市)
        parent.updateTabPosition();
    });

	//三种基础数据 网格 行政村 社队数
	function summary_info(){
		//网格数
		$.post(url4Query_sandSummary,{
			eaction:'getBaseInfo',
			flag: flag,
			substation:substation
		},function(data){
			var data = $.parseJSON(data);
			if(data != null){
				$("#grid_num_id").text(data.GRID_COUNT);//上方 网格数
			}
		});
		//社队数
		$.post(url4Query_sandSummary,{
			eaction:'get_info_all',
			flag: flag,
			substation:substation
		},function(data){
			var data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				$("#she_dui_num_id").text(d.BRIGADE_ID_CNT);
			}else{
				$("#she_dui_num_id").text(0);
			}
		});
		//行政村数
		$.post(url4Query_sandSummary,{"eaction":"getVillageCellCnt","substation":substation},function(data){
			var d = $.parseJSON(data);
			if(d!=null){
				$("#village_num_id").text(d.VC_CNT);
				//行政村页签 行政村数
				$("#village_cnt").text(d.VC_CNT);
			}
		});
	}

	//大页签市场
	function market_tab(){
		//市场 收入 发展 三组黄色大数字及下方小字
		$.post(url4Query, {eaction:'three_index_market',flag: flag,substation:parent.global_substation},
			function(data) {
				var income_divs0 = $(".target_title").eq(0).next().children();
				var danwei = "户";
				if(flag==1 || flag==2 || flag==3) {
					danwei = "万户";
				}

				data = JSON.parse(data);
				if (data.length != 0) {
					//$("#ADDR_NUM_ID").text(data[0].GZ_ZHU_HU_COUNT);
					//$("#PEOPLE_NUM_ID").text(data[0].GZ_H_USE_CNT);
					//$("#FTTH_PORT_NUM_ID").text(data[0].GOV_ZHU_HU_COUNT);
					//$("#FTTH_PORT_KX_NUM_ID").text(data[0].GOV_H_USE_CNT);
					//$(income_divs0[0]).html(data[0].MARKET_RATE);
					//$(income_divs0[1]).html("住户数:"+data[0].GZ_ZHU_HU_COUNT);
					//$(income_divs0[2]).html("光宽用户:"+data[0].GZ_H_USE_CNT+danwei);
				} else {
					$(income_divs0[1]).html("住户数:--");
					$(income_divs0[2]).html("光宽用户:--");
				}
				var b_class0 = "";
				/*var b_class1 = "b1";
				 if(data.INCOME_RATIO<0){
				 b_class1 = "b2";
				 }*/
				$(income_divs0[2]).children("b").attr("class",b_class0);
				//市场 ----end
			}
		)
		//2019-04-25指标来源调整
		$.post(url4Query_sandSummary,{"eaction":"get_info_all","substation":parent.global_substation},function(data1){
			var income_divs0 = $(".target_title").eq(0).next().children();
			var danwei = "户";
			if(flag==1 || flag==2 || flag==3) {
				danwei = "万户";
			}
			var data1_temp = $.parseJSON(data1);
			if(data1_temp.length){
				$(income_divs0[0]).html(data1_temp[0].MARKET_RATE);
				$(income_divs0[1]).html("住户数:"+data1_temp[0].HOUSEHOLD_NUM);
				$(income_divs0[2]).html("光宽用户:"+data1_temp[0].H_USE_CNT+danwei);
			}else{
				$(income_divs0[1]).html("住户数:--");
				$(income_divs0[2]).html("光宽用户:--");
			}
		});

		//市场渗透率柱状图
		freshFigue1();
		market_lv_datagrid();
	}

	function market_lv_datagrid(){
		var sub_width = $("#sub4").width();
		//市场页签 网格渗透率
		$("#sub4").datagrid({
			url:url4Query_index,
			queryParams:{
				eaction:"getGridMarketBySubstation",
				substation:substation,
				latn_id:city_id,
				click_name:city_full_name
			},
			fitColumns:false,
			columns:[
				[
					{field:'GRID_NAME',title:'网格名称',align:'center',halign:'center',width: sub_width*0.34,
						formatter:function(value,rowData){
							if (width>=1360)length_standard=7
							if(width>=1520)length_standard=8

							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
							}
						}
					},
					{field:'USE_RATE',title:'市场渗透率',align:'center',halign:'center',width:sub_width*0.17,
						formatter:function(value,rowData) {
							if (value != '--') {
								return "<span style='color: #fa8513'>" + value + "</span>";
							} else {
								return value;
							}
						}
					},
					{field:'HOUSEHOLD_NUM',title:'住户数',align:'center',halign:'center',width:sub_width*0.16,
						formatter:function(value,rowData){
							if(value!=null&&value!=undefined&&value!=-1){
								return value;
							}
							else
								return "--";
						}
					},
					{field:'H_USE_CNT',title:'光宽用户',align:'center',halign:'center',width:sub_width*0.14,
						formatter:function(value,rowData){
							if(value!=null&&value!=undefined&&value!=-1)
								return value;
							else
								return "--";
						}
					},
					{field:'POPULATION_NUM',title:'人口数',align:'center',halign:'center',width:sub_width*0.15,
						formatter:function(value,rowData){
							if(value!=null&&value!=undefined&&value!=-1)
								return value;
							else
								return "--";
						}
					}
				]],
			scrollbarSize:"8",
			onLoadSuccess:function (data) {
				$("._num").text(data.rows.length-1);

			},onClickRow: function (index,row){
				//global_substation_sub = "";
				//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
			}
		});
	}

    function freshFigue(fourdata){
        var option = {
            title: {
                text: ''
            },
            tooltip : {
                trigger: 'axis',
                formatter:'{b}<br/>{a}:&nbsp;&nbsp;{c}%',
                position:"top",
                show:false,
            },
            legend: {
                show:false
            },
            toolbox: {
                show:false
            },
            grid: {
				/*left: '3%',
				 right: '4%',
				 bottom: '3%',*/
                top: 20,
                left:30,
                right:30,
                bottom:45,
                //containLabel: true,
                align:"right"
            },
            xAxis : [
                {
                    min:1,
//                    max:31,
                    scale:0,
                    splitNumber:1,
                    minInterval:1,
                    interval:1,
                    type : 'category',
                    axisLabel: {
                        show: true,
                        textStyle: {
                            fontSize: '12',
                            color:'#fff',
                        }
                    },
                    show: true,

                    boundaryGap : false,
                    data :['移动渗透率','宽带渗透率','电视渗透率']
                }
            ],
            yAxis : [
                {
                    silent: true,
                    show: false,
                    splitLine: {
                        show: false
                    },
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'上月',
                    type:'bar',
                    stack: '总量',
                    smooth:true,
                    barMinHeight:10,
                    itemStyle: {
                        normal: {
                            color: function(params) {
								// build a color map as your need.
								var colorList = [
									'#2cbbb5','#f9852b','#b7ee93'
								];
								return colorList[params.dataIndex]
							},
                            //以下为是否显示
                            label: {
                                show: true,
                                formatter:'{c}%',
                                textStyle: {
                                    fontWeight: '700',
                                    fontSize: '12',
									color:'#fff',
                                }
                            },
                            lineStyle: {
                                color: '#03d2e3',
                                width:1
                            }
                        }
                    },
					barWidth:35,
//					barGap:'20%',
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    data:fourdata
                }
            ]
        };
        myChart.setOption(option);
    }
    function freshFigue1(){
    	var month_data = new Array(6);//月份
    	month_data[0]=${six_month_market.A};
    	month_data[1]=${six_month_market.B};
    	month_data[2]=${six_month_market.C};
    	month_data[3]=${six_month_market.D};
    	month_data[4]=${six_month_market.E};
    	month_data[5]=${six_month_market.F};

		var zyl_data =["0","0","0","0","0","0"];//占有率
        //$.post(url4Query,{"eaction":'sc_zyl_zxt',"flag":flag,"substation":substation,"last_month":'${lastMonth_market.VAL}'},function(data){
        $.post(url4Query_index,{"eaction":'getMarketChart',"substation":substation,"day":'${lastMonth_market.VAL}',"month":'${lastMonth_market.SUB_VAL}'},function(data){
        	  data = $.parseJSON(data);
			  /*for(var j=0;j<=5;j++){
        		  for(var i = 0,l = data.length;i<l;i++){
					  if(month_data[j]==data[i].STATIS_MON){
						  zyl_data[j]=data[i].ZYL;
					  }
				  }
        	  }*/

			  //20190114 和市场占有率一致的修改
			  for(var i = 0,l = data.length;i<l;i++){
				  zyl_data[i]=data[i].ZYL;
				  month_data[i]=data[i].STATIS_MON;
			  }

			  var option = {
		            title: {
		                text: ''
		            },
		            tooltip : {
		                trigger: 'axis',
		                formatter:'{b}<br/>{a}',
		                position:"top",
		                show:false
		            },
		            legend: {
		                show:false
		            },
		            toolbox: {
		                show:false
		            },
		            grid: {
						/*left: '3%',
						 right: '4%',
						 bottom: '3%',*/
		                top: 15,
		                left:30,
		                right:30,
		                bottom:45,
		                //containLabel: true,
		                align:"right"
		            },
		            xAxis : [
		                {
		                    min:1,
		                    max:31,
		                    scale:0,
		                    splitNumber:1,
		                    minInterval:1,
		                    interval:1,
		                    type : 'category',
		                    axisLabel: {
		                        show: true,
		                        textStyle: {
		                            fontSize: '12',
		                            color:'#fff',
		                        }
		                    },
		                    show: true,

		                    boundaryGap : false,
		                    data :month_data
		                }
		            ],
		            yAxis : [
		                {
		                    silent: true,
		                    show: false,
		                    splitLine: {
		                        show: false
		                    },
		                    type : 'value'
		                }
		            ],
		            series : [
		                {
		                    name:'上月',
		                    type:'bar',
		                    stack: '总量',
		                    smooth:true,
		                    barMinHeight:10,
		                    itemStyle: {
		                        normal: {
		                            color: '#109afb',
		                            //以下为是否显示
		                            label: {
		                                show: true,
		                                formatter:'{c}%',
		                                textStyle: {
		                                    fontWeight: '700',
		                                    fontSize: '12',
		                                    color:'#fff',
		                                }
		                            },
		                            lineStyle: {
		                                color: '#03d2e3',
		                                width:1
		                            }
		                        }
		                    },
		                    barWidth:35,
		//					barGap:'20%',
		                    label: {
		                        normal: {
		                            show: true,
		                            position: 'top'
		                        }
		                    },
		                    data:zyl_data
		                }
		            ]
		        };
			 myChart2.setOption(option);
        })
    }
    function freshPie(a,b){

        var a=a;  //本年累计
        var b=(b-a);  //预算目标减去本年累计
        var option = {
            legend: {
                show:false,
            },
            title : {
                text: '',
                formatter: "{d}%",
                x:'45%',
				y:'45%',
				textStyle:{
					color:'#fff'
				}
            },
            series: [
                {
                    type:'pie',
                    radius: ['50%', '70%'],
                    hoverAnimation:false,
                    avoidLabelOverlap: false,
                    label: {
                        normal: {
                            show: false,
                            position: 'right'
                        },
                        emphasis: {
                            show: false,
                            textStyle: {
                                fontSize: '12',
                                fontWeight: 'bold',
                                position: 'inside'
                            }
                        }
                    },
					itemStyle:{
                        normal:{
                            color: function(params) {
                                //首先定义一个数组
                                var colorList = [
                                    '#36bbb4','#2c3465'
                                ];
                                return colorList[params.dataIndex]
                            },
						}
					},
                    labelLine: {
                        normal: {
                            show: false
                        }
                    },
                    data:[
                        {value:a, name:'本年累计'},
                        {value:b, name:'剩余目标'},
                    ]
                }
            ]
        };
        myChart3.setOption(option);
    }
    function freshBar(){
    	var month_data = new Array(6);//月份
    	month_data[0]=${six_month.A};
    	month_data[1]=${six_month.B};
    	month_data[2]=${six_month.C};
    	month_data[3]=${six_month.D};
    	month_data[4]=${six_month.E};
    	month_data[5]=${six_month.F};

		var sr_data =["0","0","0","0","0","0"];//收入
        $.post(url4Query,{eaction:'sc_zyl',flag:flag,latn_id:city_id,click_name:city_full_name,substation:substation,"last_month":'${lastMonth.VAL}'},function(data){
        	data = $.parseJSON(data);
        	for(var j=0;j<=5;j++){
        		for(var i = 0,l = data.length;i<l;i++){
					if(month_data[j]==data[i].STATIS_MON){
						sr_data[j]=data[i].FIN_INCOME;
					}
				}
        	}

        	var option = {
	            title: {
	                text: ''
	            },
	            tooltip : {
	                trigger: 'axis',
	                formatter:'{b}<br/>{a}',
	                position:"top",
	                show:false,
	            },
	            legend: {
	                show:false
	            },
	            toolbox: {
	                show:false
	            },
	            grid: {
					/*left: '3%',
					 right: '4%',
					 bottom: '3%',*/
	                top: 20,
	                left:30,
	                right:30,
	                bottom:45,
	                //containLabel: true,
	                align:"right"
	            },
	            xAxis : [
	                {
	                    min:1,
	                    max:31,
	                    scale:0,
	                    splitNumber:1,
	                    minInterval:1,
	                    interval:1,
	                    type : 'category',
	                    axisLabel: {
	                        show: true,
	                        textStyle: {
	                            fontSize: '12',
	                            color:'#fff',
	                        }
	                    },
	                    show: true,

	                    boundaryGap : false,
	                    data :month_data
	                }
	            ],
	            yAxis : [
	                {
	                    silent: true,
	                    show: false,
	                    splitLine: {
	                        show: false
	                    },
	                    type : 'value'
	                }
	            ],
	            series : [
	                {
	                    name:'上月',
	                    type:'bar',
	                    stack: '总量',
	                    smooth:true,
	                    barMinHeight:10,
	                    itemStyle: {
	                        normal: {
	                            color: '#109afb',
	                            //以下为是否显示
	                            label: {
	                                show: true,
	                                //formatter:'{c}%',
	                                formatter:'{c}',
	                                textStyle: {
	                                    fontWeight: '700',
	                                    fontSize: '12',
	                                    color:'#fff',
	                                }
	                            },
	                            lineStyle: {
	                                color: '#03d2e3',
	                                width:1
	                            }
	                        }
	                    },
	                    barWidth:35,
	//					barGap:'20%',
	                    label: {
	                        normal: {
	                            show: true,
	                            position: 'top'
	                        }
	                    },
	                    data:sr_data
	                }
	            ]
	        };
	        myChart4.setOption(option);
        })

    }

    var myChart1 = echarts.init(document.getElementById('day_fz1'));
    function showLineFigure(date_array, current, last) {
        var option = {
            title: {
                text: ''
            },
            tooltip: {
                trigger: 'axis',
                position: "top"
            },
            legend: {
                data: ['本月', '上月'],
                orient: 'horizontal',
                left: 'right',
                top: 5,
                /*right:0,
                 top:0,
                 inactiveColor:'#999',*/
                textStyle:{
                    color: '#eee'
                },
                show:true
            },
            color:[
                '#2f4554', '#61a0a8'],
                toolbox: {
                    show: false
                },
                /*tooltip:{
             position:"top"
             },*/
            grid: {
                /*left: '3%',
                 right: '4%',
                 bottom: '3%',*/
                top: 20,
                left:0,
                right:0,
                bottom:0,
                //containLabel: true,
                align:"right"
            },
            xAxis : [
                {
                    min:1,
                    max:31,
                    scale:0,
                    splitNumber:1,
                    minInterval:1,
                    interval:1,
                    type : 'category',

                    show: false,

                    boundaryGap : false,
                    data : date_array
                }
            ],
            yAxis : [
                {
                    silent: true,
                    splitLine: {
                        show: false
                    },
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'上月',
                    type:'line',
                    stack: '总量',
                    smooth:true,
                    itemStyle: {
                        normal: {
                            color: '#03d2e3',
                            label: {
                                show: false,
                                textStyle: {
                                    fontWeight: '700',
                                    fontSize: '0'
                                }
                            },
                            lineStyle: {
                                color: '#03d2e3',
                                width:1
                            }
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: '#03d2e3',
                            opacity: 0.2
                        }
                    },
                    data:last
                },
                {
                    name:'本月',
                    type:'line',
                    stack: '总量',
                    smooth:true,
                    itemStyle: {
                        normal: {
                            color: '#feef02',
                            label: {
                                show: false,
                                textStyle: {
                                    fontWeight: '700',
                                    fontSize: '0'
                                }
                            },
                            lineStyle: {
                                color: '#feef02',
                                width:1
                            }
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: '#feef02',
                            opacity: 0.2
                        }
                    },
                    data:current
                }
            ]
        };
        // 使用刚指定的配置项和数据显示图表。
        myChart1.setOption(option);
    }

	//发展页签
    function deve_tab(){
		//发展页签上方表格
        $.post(url4Query,{eaction:'deve',day:${yesterday.VAL},month:${lastMonth.VAL},substation:substation,type:'branch'},function (data) {
            data=$.parseJSON(data)
            $("#m_cz").text(data.M_CZ)
            $("#m_jz").text(data.M_CZ-data.M_CZJZ)
            $("#m_raito").text(data.M_ADD_LV)

            $("#b_cz").text(data.B_CZ)
            $("#b_jz").text(data.B_CZ-data.B_CZJZ)
            $("#b_raito").text(data.B_ADD_LV)

            $("#i_cz").text(data.I_CZ)
            $("#i_jz").text(data.I_CZ-data.I_CZJZ)
            $("#i_raito").text(data.I_ADD_LV)

			$("#m_mn").text(data.M_MN)
			$("#b_mn").text(data.B_MN)
			$("#i_mn").text(data.I_MN)

			$("#m_n").text(data.M_DN)
			$("#b_n").text(data.B_DN)
			$("#i_n").text(data.I_DN)

			var income_divs2 = $(".target_title").eq(2).next().children();
			if(data.MOBILE_SERV_DAY_NEW!=-1){
				$(income_divs2[0]).html(""+data.B_DN);//当日发展:
			}else{
				$(income_divs2[0]).html("--");//当日发展:
			}
			if(data.MOBILE_MON_CUM_NEW!=-1){
				$(income_divs2[1]).html("本月:"+data.B_MN+"户");//:
			}else{
				$(income_divs2[1]).html("本月:--");//:
			}
			//if(data.JYLRHB!=-1){
				$(income_divs2[2]).html("环比:"+data.B_ADD_LV);
			//}else{
			//	$(income_divs2[2]).html("环比:--");
			//}
        })

		//三包发展情况、市场竞争 ---begion
		$.post(url4Query,{eaction:'three_index',flag:flag,latn_id:city_id,last_month:'${lastMonth.VAL}',click_name:city_full_name,substation:parent.global_substation},function(data){
			data = $.parseJSON(data);
			if(data==null){
				return;
			}
			//收入 ----begin
			var income_divs1 = $(".target_title").eq(1).next().children();
			if(data.INCOME_BUDGET_FINISH_RATE!=-1){
				$(income_divs1[0]).html(""+data.INCOME_BUDGET_FINISH_RATE.toFixed(2)+"%");//收入完成进度
			}else{

				$(income_divs1[0]).html("--");
			}
			var yuan = "";
			if(flag==1 || flag==2 || flag==3)
				yuan = "亿";
			else if(flag>3){
				yuan = "万";
			}
			if(data.FIN_INCOME!=-1){
				$(income_divs1[1]).html("本月:"+data.FIN_INCOME.toFixed(2)+yuan+"元");//本月收入
			}else{
				$(income_divs1[1]).html("本月:--");//本月收入
			}
			if(data.Y_CUM_INCOME!=-1){
				$(income_divs1[2]).html("本年:"+data.Y_CUM_INCOME.toFixed(2)+yuan+"元");//年收入
			}else{
				$(income_divs1[2]).html("本年:--");//年收入
			}
			var b_class1 = "b1";
			if(data.INCOME_RATIO<0){
				b_class1 = "b2";
			}
			$(income_divs1[2]).children("b").attr("class",b_class1);
			//收入 ----end

			//利润 ----begin
			/*var income_divs2 = $(".target_title").eq(2).next().children();
			 if(data.OPERATE_PROFIT_MON_YEAR!=-1){
			 $(income_divs2[0]).html(""+data.OPERATE_PROFIT_MON_YEAR.toFixed(2));//经营利润:
			 }else{
			 $(income_divs2[0]).html("--");//经营利润:
			 }
			 if(data.OPERATE_PROFIT_MON!=-1){
			 $(income_divs2[1]).html("本月:"+data.OPERATE_PROFIT_MON.toFixed(2)+yuan+"元");//当月利润:
			 }else{
			 $(income_divs2[1]).html("本月:--");//当月利润:
			 }
			 if(data.JYLRHB!=-1){
			 $(income_divs2[2]).html("环比:"+data.JYLRHB.toFixed(2)+"%");
			 }else{
			 $(income_divs2[2]).html("环比:--");
			 }*/
			/*20190109更换为发展*/
			/*if(data.MOBILE_SERV_DAY_NEW!=-1){
			 $(income_divs2[0]).html(""+data.MOBILE_SERV_DAY_NEW);//当日发展:
			 }else{
			 $(income_divs2[0]).html("--");//当日发展:
			 }
			 if(data.MOBILE_MON_CUM_NEW!=-1){
			 $(income_divs2[1]).html("本月:"+data.MOBILE_MON_CUM_NEW+"户");//:
			 }else{
			 $(income_divs2[1]).html("本月:--");//:
			 }
			 if(data.JYLRHB!=-1){
			 $(income_divs2[2]).html("环比:"+data.JYLRHB.toFixed(2)+"%");
			 }else{
			 $(income_divs2[2]).html("环比:--");
			 }*/
			var b_class2 = "b1";
			if(data.JYLRHB<0){
				b_class2 = "b2";
			}
			//$(income_divs2[2]).children("b").attr("class",b_class2);
			//已用deve_tab()替代发展值
			//利润 ----end

			//市场竞争 ----begin
			//freshFigue([data.CDMA_NUM_REATE,data.BRD_NUM_RATE,data.HOME_NUM_RATE,data.FTTH_NUM_RATE]);
			//freshFigue([data.CDMA_NUM_REATE,data.BRD_NUM_RATE,data.HOME_NUM_RATE,(data.ZYL==null?0:data.ZYL.toFixed(2))]);//20170731 liangliyuan 光网入户率的值用市场渗透率
			stl_data[0]=data.CDMA_NUM_REATE==-1?0:data.CDMA_NUM_REATE;
			stl_data[1]=data.BRD_NUM_RATE==-1?0:data.BRD_NUM_RATE;
			stl_data[2]=data.HOME_NUM_RATE==-1?0:data.HOME_NUM_RATE;
			//市场竞争 ----end
		});
		//三包发展情况、市场竞争 ---end

		//曲线图数据请求
		//当月数据
		$.post(url4Query,{eaction:"index_month_diff",region_id:city_id,click_name:city_full_name,date_start:current_month_first,date_end:current_month_last,flag:flag,substation:substation},function(data){
			data = $.parseJSON(data);
			for(var i = 0,l = data.length;i<l;i++){
				var index = parseInt(data[i].STAT_DATE.substring(6));
				current_month_data0.splice(index-1,1,data[i].MOBILE_SERV_DAY_NEW);
				current_month_data1.splice(index-1,1,data[i].BRD_SERV_DAY_NEW);
				current_month_data2.splice(index-1,1,data[i].ITV_SERV_DAY_NEW);
			}
			//上月数据
			$.post(url4Query,{eaction:"index_month_diff",region_id:city_id,click_name:city_full_name,date_start:last_month_first,date_end:last_month_last,flag:flag,substation:substation},function(data){
				data = $.parseJSON(data);
				for(var i = 0,l = data.length;i<l;i++){
					var index = parseInt(data[i].STAT_DATE.substring(6));
					last_month_data0.splice(index-1,1,data[i].MOBILE_SERV_DAY_NEW);
					last_month_data1.splice(index-1,1,data[i].BRD_SERV_DAY_NEW);
					last_month_data2.splice(index-1,1,data[i].ITV_SERV_DAY_NEW);
				}
				initChart();
			});
		});
    }

	function initChart(){
		if(div_index_type==0)
			showLineFigure(day_array,current_month_data0,last_month_data0);
		else if(div_index_type==1)
			showLineFigure(day_array,current_month_data1,last_month_data1);
		else if(div_index_type==2)
			showLineFigure(day_array,current_month_data2,last_month_data2);
	}
    var width=$(parent.parent.parent.window).width()
    var length_standard=6;
    //选择右侧三个标签中的一个，曲线图改变
    function grid_name_formatter(value, rowData){
        if (width>=1360)length_standard=7
        if(width>=1520)length_standard=8

        if(value.length>length_standard)
            return "<u title='"+value+"' style='cursor: pointer' onclick=\"clickToGridFromSub('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
        else
            return "<u title='"+value+"' style='cursor: pointer' onclick=\"clickToGridFromSub('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
    }
    function fin_income_formatter(value){
        return value+"万";
    }
    function formatterper(value,rowData){
        if(isNaN(value))
            return "--";
        if(value=="a"||value=="")
            return "";
        if(value!=null&&value!=undefined&&value!=-1)
        	return ""+value.toFixed(2)+"%";
        else
            return "--";
    }
  </script>
</body>
