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
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '6'
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
 TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.VAL}','yyyymm'), -5),'yyyymm') a,
 TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.VAL}','yyyymm'), -4),'yyyymm') b,
 TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.VAL}','yyyymm'), -3),'yyyymm') c,
 TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.VAL}','yyyymm'), -2),'yyyymm') d,
 TO_CHAR(ADD_MONTHS(to_date('${lastMonth_market.VAL}','yyyymm'), -1),'yyyymm') e,
 '${lastMonth_market.VAL}' f
FROM dual
</e:q4o>
<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<c:resources type="easyui,app" style="b"/>
<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
<link href='<e:url value="/pages/telecom_Index/common/css/indexTabs_dev_grid_new.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
<script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>

<body style="width:100%;border:0px;overflow:hidden;height: 100%" class="g_target">
<h1></h1>
<div class="tab">
	<ul>
		<li class="active" id="market" style="cursor: pointer">市场<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="deve">发展<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="income">收入<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="resource">资源<div class="line"></div></li>
		<li style="margin-left: 10px;cursor: pointer" id="village">小区</li>
	</ul>
</div>

<%--市场tab--%>
<div id="base_content">
	<ul class="market_topline">
		<%--<li><span>住户数:</span><span id="ADDR_NUM_ID"  class="topline_orange">--</span></li>
        <li><span>光宽用户:</span><span id="PEOPLE_NUM_ID" class="topline_orange">--</span></li>
        <li><span>政企住户:</span><span  id="FTTH_PORT_NUM_ID" class="topline_orange">--</span></li>
        <li><span>政企光宽:</span><span id="FTTH_PORT_KX_NUM_ID" class="topline_orange">--</span></li>--%>
		<li><span>小区数:</span><span id="village_num_id" class="topline_orange">--</span></li>
		<li><span>楼宇数:</span><span  id="build_num_id" class="topline_orange">--</span></li>
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
    <div class="target_wrap_a" id="mark_grid">
        <%--<h3 class="wrap_a" style="border-left:none;padding-left: 0px">
			<a href="javascript:void(0)" class="active1" style="font-size: 14px;display: none;">市场渗透率</a><span style="color: #fa8513;display: inline-block;">| </span>
			<a href="javascript:void(0)" style="font-size: 14px;display: none;margin-left: 5px;margin-right: 5px">网格渗透</a><span style="color: #fa8513;display:none;">| </span>
			<a href="javascript:void(0)" style="font-size: 14px;display: none;">网格资源</a><span style="color: #fa8513;display:none;">| </span>
			<a href="javascript:void(0)" style="font-size: 14px;">网格渗透率</a>
	    </h3>--%>
        <h3 class="wrap_a">网格渗透率</h3>
	    <div id="mark_grid_in">
            <div class="layout" id="tab">
                <table id="sub" style="width:98%;cursor:pointer;position:absolute;top:0px;left: 0px;height: 100%;margin: 5px auto">
                </table>
            </div>
            <div class="layout" id="tab2">
                <table id="sub2" style="width:98%;cursor:pointer;position:absolute;top:0px;left: 0px;height: 100%;margin: 5px auto;">
                </table>
            </div>
            <div class="layout" id="tab3">
                <table id="sub3" style="width:98%;cursor:pointer;position:absolute;top:0px;left: 0px;height: 100%;margin: 5px auto;">
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
        <h3 class="wrap_a">小区信息<span class="_num" style="display:none;"></span></h3>
        <table id="asd" style=" width:98%;cursor:pointer;position:absolute;top:46px;left: 15px;height: 83%;text-align: center">
            <%--<thead>
            <tr>
                <th field="ROWNUM" width="10%" align="center" halign="center" formatter="">序号</th>
                <th field="VILLAGE_NAME" width="30%"  align="center" halign="center" formatter="grid_name_formatter">小区名称</th>
                <th field="MOBILE_NUM" width="20%" align="center" halign="center" formatter="">移动用户</th>
                <th field="WIDEBAND_NUM" width="20%" align="center" halign="center" formatter="">宽带用户</th>
                <th field="IPTV_NUM" width="20%" align="center" halign="center"> 电视</th>
                <th field="GRID_ID" showHeader="false"></th>
            </tr>
            </thead>--%>
        </table>
    </div>
</div>

<%--收入tab--%>
<div id="base_content_b" style="display: none">
    <div class="target_wrap_in">
        <h3 class="wrap_a" style="margin-top: 10px;margin-left: 10px">收入进度</h3>
        <ul class="in_plan">
            <li><div id="in_pie" style="height: 100px;width: 100px"></div><span   id="wcjd_id" class="pie_number"> </span></li>
            <li><div class="paln_title1" id="income_budget_id"> </div><div class="paln_title2">预算目标</div></li>
            <li><div class="paln_title1" id="y_cum_income_id"> </div><div class="paln_title2">本年累计</div></li>
            <li><div class="paln_title1" id="income_budget_finish_rate_id"> </div><div class="paln_title2">完成进度</div></li>
        </ul>
    </div>
    <div class="target_wrap" style="position: relative;height:28% !important;width: 98%;">
        <h3 class="wrap_a" style="margin-top: 0px">收入趋势</h3>
        <div class="figure" id="in_bar"></div>
    </div>
    <div class="target_wrap1" style="position: relative;width: 98%;border-bottom: none" id="in_target">
        <h3 class="wrap_a" style="margin-top: 10px;margin-left: 10px">网格收入</h3>
        <div>
            <table id="in_table" style="width:98%;cursor:pointer;position:absolute;top:30px;left: 15px;height: 90%;margin: 5px auto;">
            </table>
        </div>
</div>
</div>

<%--资源--%>
<div id="base_content_c" style="display: none">
	<div class="target_dev_b" style="width: 100%">
		<h3 class="wrap_a">网络资源<span class="_num" style="display:none;"></span></h3>
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
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">资源已达：<span id="resouce_reach_build_cnt"></span></span><span style="position: absolute;left: 128px;">资源未达：<span id="resouce_unreach_build_cnt"></span></span></div>

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
		<h3 class="wrap_a">网格资源<span class="_num" style="display:none;"></span></h3>
		<table id="res_grid" style=" width:98%;cursor:pointer;position:absolute;top:46px;left: 15px;height: 83%">
		</table>
	</div>
</div>

<%--小区--%>
<div id="base_content_d" style="display: none">
	<div class="target_dev_c" style="width: 100%">
		<div class="devep" style="margin-top:0px;">
			<h3 class="wrap_a">小区概况<span class="_num" style="display:none;"></span></h3>
			<div class="deve_tc">
				<div class="tavb">
					<div  class="tavae"  id="village_cnt"></div>
					<div style="width: 100%;color: #8fa1c3;font-size: 12px">小区数</div>
				</div>
			</div>
			<div class="deve_td">

				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">急迫小区：<span id="ji_po_vill"></span></span><span style="position: absolute;left: 128px;">紧迫小区：<span id="jin_po_vill"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">操心小区：<span id="cao_xin_vill"></span></span><span style="position: absolute;left: 128px;">平稳小区：<span id="ping_wen_vill"></span></span></div>
				<div class="quota"><span style="color: #9ebaf1">•</span><span style="margin-left: 10px">已归集楼宇：<span id="build_in_vill_cnt"></span></span><span style="position: absolute;left: 128px;">未归集楼宇：<span id="build_not_in_vill_cnt"></span></span></div>

			</div>
		</div>
	</div>
	<div class="target_wrap_c" id="village_target">
		<h3 class="wrap_a">小区清单<span class="_num" style="display:none;"></span></h3>
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
    当日发展(户)
</div>
<!-- 悬浮信息 end-->

<%--<script src='<e:url value="/pages/telecom_Index/js/freshTab.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshChart.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/js/freshRank.js"/>' charset="utf-8"></script>--%>
<script type="text/javascript" >
		//<![CDATA[
		var width=$(parent.parent.parent.window).width();
		var length_standard=6;
		$(function(){
			$("#tab").hide();
			$("#tab2").hide();
			$("#tab3").hide();
			var $div_li =$("#mark_grid > .wrap_a > a");
			$div_li.click(function(){
				$(this).addClass("active1")            //当前<li>元素高亮
						.siblings().removeClass("active1");  //去掉其它同辈<li>元素的高亮
				var index =  $div_li.index(this);  // 获取当前点击的<li>元素 在 全部li元素中的索引。
				$("#mark_grid_in > div")   	//选取子节点。不选取子节点的话，会引起错误。如果里面还有div
						.eq(index).show()   //显示 <li>元素对应的<div>元素
						.siblings().hide();//隐藏其它几个同辈的<div>元素

                if(index==1){
                    $("#sub2").height($("#mark_grid").height() * 0.9);
                    $("#sub2").width($("#base_content").width());
                    var sub_width = $("#sub2").width();
                    $("#sub2").datagrid({
                        url:url4Query,
                        queryParams:{
                            //eaction:'getGridInfoBySubstation_new', 去掉了合计
                            //eaction:'getGridInfoBySubstation_new',
                            eaction:'getVillageInfoInGridId',
                            yesterday:'${yesterday.VAL}',
                            last_month:'${lastMonth.VAL}',
                            report_to_id:report_to_id
                        },
                        fitColumns:false,
                        columns:[[
                            {field:'RN',title:'序号',align:'center',halign:'center',width: sub_width*0.1,
                                formatter:function(value,rowData){
                                    if(value==0)
                                        return "";
                                    return value;
                                }
                            },
                            {field:'VILLAGE_NAME',title:'小区名称',align:'left',halign:'center',width:sub_width*0.34,
                                formatter:function(value,rowData){
                                    if (width>=1360)length_standard=7;
                                    if(width>=1520)length_standard=8;

                                    if(value.length>length_standard)
                                        return "<u title='"+value+"' style='cursor: pointer' onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
                                    else{
                                    		if(value=='合计')
                                    			return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;'>"+value+"</span>";
                                   			return "<u title='"+value+"' style='cursor: pointer' onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value+"</u>";
                                    }

                                }
                            },
                            {field:'YD_LV',title:'移动<br/>渗透率',align:'center',halign:'center',width:sub_width*0.16,
                                formatter:function(value,rowData){
                                    if(isNaN(parseFloat(value)))
                                        return"";
                                    if(value!=null&&value!=undefined&&value!=-1)
                                        return ""+value.toFixed(1)+"%";
                                    else
                                        return "--";
                                }
                            },
                            {field:'KD_LV',title:'宽带<br/>渗透率',align:'center',halign:'center',width:sub_width*0.16,
                                formatter:function(value,rowData){
                                    if(isNaN(parseFloat(value)))
                                        return"";
                                    if(value!=null&&value!=undefined&&value!=-1)
                                        return ""+value.toFixed(1)+"%";
                                    else
                                        return "--";
                                }
                            },
                            {field:'DS_LV',title:'电视<br/>渗透率',align:'center',halign:'center',width:sub_width*0.16,
                                formatter:function(value,rowData){
                                    if(isNaN(parseFloat(value)))
                                        return"";
                                    if(value!=null&&value!=undefined&&value!=-1)
                                        return ""+value.toFixed(1)+"%";
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
                            $("._num").text(data.rows.length-1);
                            if(data.rows.length==0){
                                var rows = $("#sub2").datagrid("getRows");

                                var copyRows = [];
                                for ( var j= 0; j < rows.length; j++) {
                                  copyRows.push(rows[j]);
                                }

                                for(var j=0;j<copyRows.length;j++){
                                //删除行
                                    var index = $('#sub2').datagrid('getRowIndex',copyRows[j]);
                                  $('#sub2').datagrid('deleteRow',index);
                                }

                                for(var i = 0,l = 5;i<l;i++){
                                    $('#sub2').datagrid('appendRow',{
                                        RN            :'',
                                        VILLAGE_NAME  :'',
                                        YD_LV         :'',
                                        KD_LV         :'',
                                        DS_LV         :''
                                    });
                                }
                            }
                        },onClickRow: function (index,row){
                            //global_substation_sub = "";
                            //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
                        }
                    });
                }else if(index==2){
                    $("#sub3").height($("#mark_grid").height() * 0.9);
                    $("#sub3").width($("#base_content").width());
                    var sub_width = $("#sub3").width();
                    $("#sub3").datagrid({
                        url:url4Query,
                        queryParams:{
							eaction:'getVillageResourceByGridId',
                            report_to_id:report_to_id
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
                            {field:'VILLAGE_NAME',title:'小区名称',align:'left',halign:'center',width:sub_width*0.37,
									formatter:function(value,rowData){
                                    if (width>=1360)length_standard=7;
                                    if(width>=1520)length_standard=8;

                                    if(value.length>length_standard)
                                        return "<u title='"+value+"' style='cursor: pointer' onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
                                    else{
                                        if(value=='合计')
                                            return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;'>"+value+"</span>";
                                        return "<u title='"+value+"' style='cursor: pointer' onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value+"</u>";
                                    }
                                }
                            },
                            {field:'GZ_ZHU_HU_COUNT',title:'住户数',align:'center',halign:'center',width:sub_width*0.12,
								formatter:function(value,rowData){
                                if(value==-1)
                                    return "";
                                else
                                    return value;
                              }
                            },
                            /*{field:'PEOPLE_NUM',title:'人口数',align:'center',halign:'center',width:sub_width*0.12,
								formatter:function(value,rowData){
                                if(value==-1)
                                    return "";
                                else
                                    return value;
                              }
                            },*/
                            {field:'PORT_ID_CNT',title:'端口',align:'center',halign:'center',width:sub_width*0.12,
								formatter:function(value,rowData){
                                if(value==-1)
                                    return "";
                                else
                                    return value;
                              }
                            },
                            {field:'KONG_PORT_CNT',title:'空闲</br>端口',align:'center',halign:'center',width:sub_width*0.12,
                            	formatter:function(value,rowData){
                                if(value==-1)
                                    return "";
                                else
                                    return value;
                              }
                            },
                            {field:'PORT_LV',title:'占用率',align:'center',halign:'center',width:sub_width*0.12,
                            	formatter:function(value,rowData){
                                if(isNaN(parseFloat(value)))
                                    return"";
                                if(value!=null&&value!=undefined&&value!=-1)
                                    return ""+value;
                                else
                                    return "--";
                              }
                            }
                        ]],
                        scrollbarSize:"8",
                        onLoadSuccess:function (data) {
                            $("._num").text(data.rows.length);
                            if(data.rows.length==0){

                            	var rows = $("#sub3").datagrid("getRows");

								var copyRows = [];
                                for ( var j= 0; j < rows.length; j++) {
                                  copyRows.push(rows[j]);
                                }

                                /*for(var j=0;j<copyRows.length;j++){
                                //删除行
                                    var index = $('#sub3').datagrid('getRowIndex',copyRows[j]);
                                  $('#sub3').datagrid('deleteRow',index);
                                }*/

                                if(copyRows.length<5){
                                		for(var i = 0,l = 5-copyRows.length;i<l;i++){
		                                    $('#sub3').datagrid('appendRow',{
		                                        ROWNUM          :'',
		                                        VILLAGE_NAME    :'',
		                                        GZ_ZHU_HU_COUNT      :'',
		                                        //PEOPLE_NUM      :'',
		                                        PORT_ID_CNT            :'',
		                                        KONG_PORT_CNT       :'',
		                                        PORT_LV         :''
		                                    });
		                                }
                                }else{

                                }
                            }
                        },onClickRow: function (index,row){
                            //global_substation_sub = "";
                            //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
                        }
                    });
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

	var url4Query_index = '<e:url value="pages/telecom_Index/common/sql/tabData_index_new_grid.jsp" />';

	var url4Query_sandSummary = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_grid.jsp" />';
	var url4Query_sandSummaryInside = '<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary_inside.jsp' />';

    if(isIE()) {
        $("#Histogram").height($(".target_wrap").height());
    }
    var myChart = echarts.init(document.getElementById('Histogram'));
    var bureau_no = parent.global_bureau_id;
    var substation = parent.global_substation;
    var grid_id = parent.global_grid_id;
    var report_to_id=parent.global_report_to_id;

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
		deve();

        if(isIE()) {
            $("#day_fz1").height($(".target_wrap").eq(1).height());
        }
        $("#day_fz1").height($(".target_wrap").eq(1).height()*0.93);

        if(isIE()) {
            $("#asd").height($("#base_content_a").height()*0.32);
        }
        var asd_width = $("#base_content_a").width();
        $("#asd").datagrid({
            url:url4Query,
            queryParams:{
                eaction:'getVillageDeveByGridId',
                r_id:report_to_id
            },
            fitColumns:false,
            columns:[[
                {field:'ROWNUM',title:'序号',align:'center',halign:'center',width:asd_width*0.1,
										 formatter:function(value,rowData){
                        if(rowData.VILLAGE_NAME=='合计')
                        	return "";
                        return value;
                    }
                },
                {field:'VILLAGE_NAME',title:'小区名称',align:'left',halign:'center',width:asd_width*0.26,
                    formatter:function(value,rowData){
                        if(value!=null&&value.length>7)
                            return "<span title='"+value+"' style=\"color:white;text-decoration: underline;cursor:pointer;\" onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value.substr(0,7)+"..</span>";
                        else{
                        	if(value=='合计')
                        		return "<span title='"+value+"' style=\"color:white;text-align:center;width:100%;display:inline-block;\" >"+value+"</span>";
                        	return "<span title='"+value+"' style=\"color:white;text-decoration: underline;cursor:pointer;\" onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value+"</span>";
                        }
                    }
                },
                {field:'MOBILE_NUM',title:'移动用户',align:'center',halign:'center',width:asd_width*0.19,
                    formatter:function(value,rowData){
                        if(isNaN(parseFloat(value)))
                            return"";
                        else if(value!=null && value!=undefined && value!=-1)
                            return ""+value;
                        else
                            return "--";
                    }
                },
                {field:'WIDEBAND_NUM',title:'宽带用户',align:'center',halign:'center',width:asd_width*0.19,
                    formatter:function(value,rowData){
                        if(isNaN(parseFloat(value)))
                            return"";
                        if(value!=null&&value!=undefined&&value!=-1)
                            return ""+value;
                        else
                            return "--";
                    }
                },
                {field:'IPTV_NUM',title:'电视',align:'center',halign:'center',width:asd_width*0.19,
                    formatter:function(value,rowData){
                        if(isNaN(parseFloat(value)))
                            return"";
                        if(value!=null&&value!=undefined&&value!=-1)
                            return ""+value;
                        else
                            return "--";
                    }
                }
            ]],
            scrollbarSize:"8",
            onLoadSuccess:function (data) {
                if(data.rows.length==1){

                	var rows = $("#asd").datagrid("getRows");

									var copyRows = [];
					        for ( var j= 0; j < rows.length; j++) {
					          copyRows.push(rows[j]);
					        }

									for(var j=0;j<copyRows.length;j++){
									//删除行
										var index = $('#asd').datagrid('getRowIndex',copyRows[j]);
									  $('#asd').datagrid('deleteRow',index);
									}

									for(var i = 0,l = 4;i<l;i++){
										$('#asd').datagrid('appendRow',{
											ROWNUM      :'',
											VILLAGE_NAME:'',
											MOBILE_NUM  :'',
											WIDEBAND_NUM:'',
											IPTV_NUM    :''
										});
									}
								}
            },onClickRow: function (index,row){
                //global_substation_sub = "";
                //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });

    })
	//大页签收入
    $('#income').on('click',function(){
		hideAllTab();
		$('#base_content_b').css({display:'block'});
		$('#income').addClass("active");

        $.post(url4Query,{eaction:'three_index',flag:flag,city_name:city_name,report_to_id:report_to_id,substation:substation,yesterday:'${yesterday.VAL}',last_month:'${lastMonth.VAL}'},function(data){
            data = $.parseJSON(data);
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

        $("#in_table").height($("#in_target").height()*0.8);
        var sub_width = $("#in_target").width();
        $("#in_table").datagrid({
            url:url4Query,
            queryParams:{
                //eaction:'getGridInfoBySubstation_wgsr',
                eaction:'getGridInfoBySubstation_wgsr',
                yesterday:'${yesterday.VAL}',
                beforeLastMonth:'${beforeLastMonth.VAL}',
                last_month:'${lastMonth.VAL}',
                substation:substation,
                latn_id:city_id,
                click_name:city_full_name,
                report_to_id:report_to_id
            },
            fitColumns:false,
            columns:[
                [
                    {field:'ORD',title:'序号',align:'center',halign:'center',width: sub_width*0.12,
                    	 formatter:function(value,rowData){
                          return parseInt(value)+1;
                      }
                    },
                    {field:'GRID_NAME',title:'网格名称',align:'center',halign:'center',width:sub_width*0.34,
                    	formatter:function(value,rowData){
                          if (width>=1360)length_standard=7
                          if(width>=1520)length_standard=8
                          if(value.length>length_standard)
                              return "<span title='"+value+"' style='margin-left: 5px' >"+value.substr(0,length_standard)+"..</span>";
                          else{
                          	if(value=='合计')
                          		return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px'>"+value+"</span>";
                          	return "<span title='"+value+"' style='margin-left: 5px' >"+value+"</span>";
                          }
                      }
                    },
                    {field:'FIN_INCOME',title:'当月',align:'center',halign:'center',width:sub_width*0.16,
                    },
                    {field:'FIN_INCOME_LAST',title:'上月',align:'center',halign:'center',width:sub_width*0.16,
                    },
                    {field:'INCOME_RATIO',title:'环比',align:'center',halign:'center',width:sub_width*0.16,
                    	formatter:function(value,rowData){
							 if(isNaN(parseFloat(value)))
							 return"";
							 if(value!=null&&value!=undefined&&value!=-1)
							 return ""+value.toFixed(2)+"%";
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
                $("._num").text(data.rows.length-1);
                var panel =  $("#in_table").datagrid('getPanel');

				        var tr = panel.find('div.datagrid-body tr :eq(0)');

		            var td = $(tr).children('td');  // 取出行中，DATA_NAME 这一列。

		            //td.children("div").css({"color": "#fa8513"});
            },onClickRow: function (index,row){
                //global_substation_sub = "";
                //toMap_grid(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });
    })
    //大页签资源
	$("#resource").on("click",function(){
		hideAllTab();
		$('#base_content_c').css({display:'block'});
		$('#resource').addClass("active");

		$.post(url4Query_index,{"eaction":"get_info_all","grid_id":grid_id},function(data){
			var data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				$("#res_fib_percent").text(d.RESOUCE_RATE);
				$("#obd_cnt").text(d.OBD_CNT);
				$("#gz_obd_cnt").text(d.HIGH_USE_OBD_CNT);
				$("#0_obd_cnt").text(d.ZERO_OBD_CNT);
				$("#resouce_reach_build_cnt").text(d.RES_ARRIVE_CNT);
				$("#resouce_unreach_build_cnt").text(d.NO_RES_ARRIVE_CNT);

				$("#res_port_percent").text(d.PORT_RATE);
				$("#port_cnt").text(d.PORT_ID_CNT);
				$("#used_port_cnt").text(d.USE_PORT_CNT);
				$("#free_port_cnt").text(d.KONG_PORT_CNT);
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
				eaction:'getGridResourceBySubstation',
                substation: substation
			},
			fitColumns:false,
			columns:[
				[
					{field:'ROWNUM',title:'序号',align:'center',halign:'center',width: sub_width*0.10,
						formatter:function(value,rowData){
							if(value=='0')
								return "";
							return value;
						}
					},
					{field:'GRID_NAME',title:'网格名称',align:'center',halign:'center',width:sub_width*0.30,
						formatter:function(value,rowData){
                            if (width>=1360)length_standard=7
                            if(width>=1520)length_standard=8

                            if(value.length>length_standard){
                                if('${sessionScope.UserInfo.LEVEL}'==5)
                                    return "<span title='"+value+"' style='margin-left: 5px' >"+value.substr(0,length_standard)+"..</span>";
                                else
                                    return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
                            }else{
                                if('${sessionScope.UserInfo.LEVEL}'==5)
                                    return value;
                                else
                                    return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
                                //return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
                                //return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
                            }
						}
					},
					{field:'OBD_CNT',title:'OBD数',align:'center',halign:'center',width:sub_width*0.13
					},
					{field:'PORT_ID_CNT',title:'端口数',align:'center',halign:'center',width:sub_width*0.13
					},
					{field:'USE_PORT_CNT',title:'占用端口',align:'center',halign:'center',width:sub_width*0.14
					},
					{field:'PORT_PERCENT',title:'端口占用率',align:'center',halign:'center',width:sub_width*0.18,
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
				//toMap_grid(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
			}
		});
	})
	//大页签小区
	$("#village").on("click",function(){
		hideAllTab();
		$('#base_content_d').css({display:'block'});
		$('#village').addClass("active");

		$.post(url4Query_index,{"eaction":"getVillgeCntByType","grid_id":grid_id},function(data){
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
		$.post(url4Query_index,{"eaction":"get_info_all","grid_id": grid_id},function(data){
			var data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				$("#village_cnt").text(d.VILLAGE_CNT);
				$("#build_in_vill_cnt").text(d.USED_BUILD_NUM);
				$("#build_not_in_vill_cnt").text(d.WJ_CNT);
			}else{
				$("#village_cnt").text("0");
				$("#build_in_vill_cnt").text("0");
				$("#build_not_in_vill_cnt").text("0");
			}
		});

		$("#village_detail_list").height($("#village_target").height());
		var sub_width = $("#village_target").width();
		$("#village_detail_list").datagrid({
			url:url4Query_index,
			queryParams:{
				eaction:'getVillageMarketByGrid',
				grid_id:grid_id
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
					{field:'VILLAGE_NAME',title:'小区名称',align:'left',halign:'center',width:sub_width*0.32,
						formatter:function(value,rowData){
							if(value!=null&&value.length>7)
								return "<span title='"+value+"' style=\"color:white;text-decoration: underline;cursor:pointer;\" onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value.substr(0,7)+"..</span>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style=\"color:white;text-align:center;width:100%;display:inline-block;\" >"+value+"</span>";
								return "<span title='"+value+"' style=\"color:white;text-decoration: underline;cursor:pointer;\" onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value+"</span>";
							}
						}
					},
					{field:'MARKET_PENETRANCE',title:'市场渗透率',align:'center',halign:'center',width:sub_width*0.18,
                        formatter:function(value,rowData){
                            return "<span style='color:#fa8513;'>"+value+"</span>";
                        }
					},
					{field:'FILTER_MON_RATE',title:'本月提升',align:'center',halign:'center',width:sub_width*0.16
					},
					{field:'FILTER_YEAR_RATE',title:'本年提升',align:'center',halign:'center',width:sub_width*0.16
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
				//toMap_grid(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
			}
		});
	})


    /*    占有率渗透率切换   */
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
		parent.global_func_searchVillage(village_id);
		parent.global_func_operateVillage(village_id);
	}

   /* function show1(obj,id) {
        var objDiv = $("#"+id+"");
        $(objDiv).css("display","block");
        $(objDiv).css("left", 50);
        $(objDiv).css("top", 165);
    }
    function show2(obj,id) {
        var objDiv = $("#"+id+"");
        $(objDiv).css("display","block");
        $(objDiv).css("left", 160);
        $(objDiv).css("top", 165);
    }
    function show3(obj,id) {
        var objDiv = $("#"+id+"");
        $(objDiv).css("display","block");
        $(objDiv).css("left", 280);
        $(objDiv).css("top", 165);
    }*/
    function hide(obj,id) {
        var objDiv = $("#"+id+"");
        $(objDiv).css("display", "none");
    }

		function revetNameByRn(rn){
				if(rn==1)
					return "省";
				else if(rn==2)
					return "市";
				else if(rn==3)
					return "县";
				else if(rn==4)
					return "支";
				else if(rn==5)
					return "网";
		}

    $(function(){
        //alert("parent_name:"+parent_name+" city_full_name:"+city_full_name+" city_name:"+city_name+" city_id:"+city_id+" index_type:"+index_type+" flag:"+flag+" substation:"+substation );
        $(".btn_uc").each(function (index, obj) {
            $(this).on("click",function () {
                $(".btn_uc").removeClass("btn_active")
                $(this).addClass("btn_active")
                div_index_type=index;
                initChart()
            })
        })
        summary_info();
        //打开支局视图
        if(isIE()) {
            $("#sub4").height($("#mark_grid").height()*0.82);
        }
        $("#sub4").height($("#mark_grid").height()*0.82);
        var sub_width = $("#sub4").width();

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

						if(value.length>length_standard){
                            if('${sessionScope.UserInfo.LEVEL}'==5)
                                return "<span title='"+value+"' style='margin-left: 5px' >"+value.substr(0,length_standard)+"..</span>";
                            else
                                return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value.substr(0,length_standard)+"..</u>";
                        }else{
                            if('${sessionScope.UserInfo.LEVEL}'==5)
                                return value;
                            else
                                return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
								//return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
							//return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"toMap_grid('"+rowData.UNION_ORG_CODE+"','"+rowData.BRANCH_NAME+"','"+rowData.ZOOM+"','"+rowData.GRID_NAME+"','"+rowData.STATION_ID+"')\">"+value+"</u>";
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
                {field:'GZ_ZHU_HU_COUNT',title:'住户数',align:'center',halign:'center',width:sub_width*0.16,
                    formatter:function(value,rowData){
                        if(value!=null&&value!=undefined&&value!=-1){
                        	return value;
                        }
                        else
                            return "--";
                    }
                },
                {field:'GZ_H_USE_CNT',title:'光宽用户',align:'center',halign:'center',width:sub_width*0.14,
                    formatter:function(value,rowData){
                        if(value!=null&&value!=undefined&&value!=-1)
                            return value;
                        else
                            return "--";
                    }
                },
                {field:'LY_CNT',title:'楼宇数',align:'center',halign:'center',width:sub_width*0.15,
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
                //toMap_grid(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });

        parent.freshVillageDatagrid = function(){
            $("#sub").datagrid('reload');
            //$("#asd").datagrid('reload');
        }

        var qx_name_temp = "";
        if(city_id==undefined){//百度地市层点某个区县，将来要替换成分局的模块
            if(city_name_speical.indexOf(parent_name)>-1)
                qx_name_temp = parent_name.replace(/州/gi,'');
            else
                qx_name_temp = parent_name.replace(/市/gi,'');
            city_id = city_ids[qx_name_temp];
        }

        deve();

        $.post(url4Query, {
        	   eaction:'three_index_market',
        	   flag: flag,
        	   report_to_id:report_to_id
            },
            function(data) {
            	var income_divs0 = $(".target_title").eq(0).next().children();
            	var danwei = "户";
                if(flag==1 || flag==2 || flag==3) {
                    danwei = "万户";
                }

            	data = JSON.parse(data);
            	if (data.length != 0) {
            		$("#ADDR_NUM_ID").text(data[0].GZ_ZHU_HU_COUNT);
                    $("#PEOPLE_NUM_ID").text(data[0].GZ_H_USE_CNT);
                    $("#FTTH_PORT_NUM_ID").text(data[0].GOV_ZHU_HU_COUNT);
                    $("#FTTH_PORT_KX_NUM_ID").text(data[0].GOV_H_USE_CNT);
                    $(income_divs0[0]).html(data[0].MARKET_RATE);
                    $(income_divs0[1]).html("住户数:"+data[0].GZ_ZHU_HU_COUNT);
                    $(income_divs0[2]).html("光宽用户:"+data[0].GZ_H_USE_CNT+danwei);
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

        //三包发展情况、市场竞争 ---begion
        $.post(url4Query,{eaction:'three_index',flag:flag,city_name:city_name,report_to_id:report_to_id,substation:substation,yesterday:'${yesterday.VAL}',last_month:'${lastMonth.VAL}'},function(data){
            data = $.parseJSON(data);
            if(data==null){
                return;
            }

            /*var income_divs0 = $(".target_title").eq(0).next().children();
            if(data.ZYL!=-1){
                $(income_divs0[0]).html(""+data.ZYL.toFixed(2)+"%");//
            }else{
                $(income_divs0[0]).html("--");
            }
            var danwei = "户";
            if(flag==1 || flag==2 || flag==3)
                danwei = "万户";
            if(data.MARKET_SORT!=-1){
                $(income_divs0[1]).html("住户数:"+data.MARKET_SORT);//
            }else{
                $(income_divs0[1]).html("住户数:--");//
            }
            if(data.KD_NUM!=-1){
                $(income_divs0[2]).html("光宽用户:"+data.KD_NUM+danwei);
            }else{
                $(income_divs0[2]).html("光宽用户:--");
            }*/

            //var b_class0 = "";
            /*var b_class1 = "b1";
             if(data.INCOME_RATIO<0){
             b_class1 = "b2";
             }*/
            //$(income_divs0[2]).children("b").attr("class",b_class0);
            //市场 ----end

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

            //发展 ----begin
            /*var income_divs2 = $(".target_title").eq(2).next().children();
            if(data.MOBILE_SERV_DAY_NEW!=-1){
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
            }
            var b_class2 = "b1";
            if(data.JYLRHB<0){
                b_class2 = "b2";
            }
            $(income_divs2[2]).children("b").attr("class",b_class2);*/
            //发展 ----end

            //市场竞争 ----begin
            //freshFigue([data.CDMA_NUM_REATE,data.BRD_NUM_RATE,data.HOME_NUM_RATE,data.FTTH_NUM_RATE]);
            //freshFigue([data.CDMA_NUM_REATE,data.BRD_NUM_RATE,data.HOME_NUM_RATE,(data.ZYL==null?0:data.ZYL.toFixed(2))]);
            stl_data[0]=data.CDMA_NUM_REATE==-1?0:data.CDMA_NUM_REATE;
           	stl_data[1]=data.BRD_NUM_RATE==-1?0:data.BRD_NUM_RATE;
           	stl_data[2]=data.HOME_NUM_RATE==-1?0:data.HOME_NUM_RATE;
            //市场竞争 ----end
        });
        //三包发展情况、市场竞争 ---end

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
        //默认是展现的移动标签
        var div_index_type = 0;
        //曲线图数据请求
        //当月数据
        $.post(url4Query,{eaction:"compare_month",region_id:city_id,r_id:report_to_id,date_start:current_month_first,date_end:current_month_last,substation:substation},function(data){
            data = $.parseJSON(data);
            for(var i = 0,l = data.length;i<l;i++){
                var index = parseInt(data[i].STAT_DATE.substring(6));
                current_month_data0.splice(index-1,1,data[i].MOBILE_SERV_DAY_NEW);
                current_month_data1.splice(index-1,1,data[i].BRD_SERV_DAY_NEW);
                current_month_data2.splice(index-1,1,data[i].ITV_SERV_DAY_NEW);
            }
            //上月数据
            $.post(url4Query,{eaction:"compare_month",region_id:city_id,r_id:report_to_id,date_start:last_month_first,date_end:last_month_last,substation:substation},function(data){
                data = $.parseJSON(data);
                for(var i = 0,l = data.length;i<l;i++){
                    var index = parseInt(data[i].STAT_DATE.substring(6));
                    last_month_data0.splice(index-1,1,data[i].MOBILE_SERV_DAY_NEW);
                    last_month_data1.splice(index-1,1,data[i].BRD_SERV_DAY_NEW);
                    last_month_data2.splice(index-1,1,data[i].ITV_SERV_DAY_NEW);
                }
                initChart()
            });
        });
        function initChart() {
            //刷新echart的曲线图
            if(div_index_type==0)
                showLineFigure(day_array,current_month_data0,last_month_data0);
            else if(div_index_type==1)
                showLineFigure(day_array,current_month_data1,last_month_data1);
            else if(div_index_type==2)
                showLineFigure(day_array,current_month_data2,last_month_data2);
        }

        myChart = echarts.init(document.getElementById('Histogram'));
        myChart2 = echarts.init(document.getElementById('occupancy_content'));
        myChart3 = echarts.init(document.getElementById('in_pie'));
        myChart4 = echarts.init(document.getElementById('in_bar'));

        //用户发展 终端销售 ---begin
        //当前位置信息（甘肃省>兰州市)
        parent.updateTabPosition();
    });

    function summary_info(){
        $.post(url4Query_index,{
            eaction:'get_info_all',
            flag: flag,
            grid_id: grid_id
        },function(data){
            var data = $.parseJSON(data);
            var d = data[0];
            $("#village_num_id").text(d.VILLAGE_CNT);
            $("#build_num_id").text(d.LY_CNT);
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
                right:40,
                bottom:20,
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

        $.post(url4Query,{"eaction":"getGridUnionOrgCodeByReportToId","report_to_id":parent.global_report_to_id},function(data){
            var d = $.parseJSON(data);
            $.post(url4Query,{"eaction":'sc_zyl_zxt',"flag":flag,"grid_id": d.STATION_NO,"last_month":'${lastMonth_market.VAL}'},function(data){
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
        });
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

		var sr_data =["0","0","0","0","0","0"];
        $.post(url4Query,{eaction:'sc_zyl',flag:flag,latn_id:city_id,click_name:city_full_name,report_to_id:report_to_id,substation:substation,"last_month":'${lastMonth.VAL}'},function(data){
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




    /*if(isIE()) {
        $("#day_fz1").height($(".target_wrap").eq(1).height());
    }
    $("#day_fz1").height($(".target_wrap").eq(1).height()*0.88);*/
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
                }
                ,
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
    function deve(){
        $.post(url4Query,{eaction:'deve',day:${yesterday.VAL},month:${lastMonth.VAL},r_id:report_to_id,substation:substation,type:'grid'},function (data) {
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
                $(income_divs2[0]).html(""+(data.M_DN+data.B_DN+data.I_DN));//当日发展:
            }else{
                $(income_divs2[0]).html("--");//当日发展:
            }
            if(data.MOBILE_MON_CUM_NEW!=-1){
                $(income_divs2[1]).html("本月:"+(data.M_MN+data.B_MN+data.I_MN)+"户");//:
            }else{
                $(income_divs2[1]).html("本月:--");//:
            }
            //if(data.JYLRHB!=-1){
            $(income_divs2[2]).html("环比:"+data.ALL_ADD_LV);
            //}else{
            //	$(income_divs2[2]).html("环比:--");
            //}
        })
    }

    function grid_name_formatter(value,rowData){
        if(rowData.BEN_GIS_UPLOAD==0 || rowData.BEN_GIS_UPLOAD==null)
//            color="#FFB73E";
            color="white";
        else
            color="white";
        if(value!=null&&value.length>7)
            return "<span title='"+value+"' style=\"color:"+color+";text-decoration: underline;cursor:pointer;\" onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value.substr(0,7)+"..</span>";
        else
            return "<span title='"+value+"' style=\"color:"+color+";text-decoration: underline;cursor:pointer;\" onclick=\"toMap_village('"+rowData.VILLAGE_ID+"')\">"+value+"</span>";

    }
    function fin_income_formatter(value){
        return value+"万";
    }
    function formatterper(value,rowData){
        if (value=='a')
            return ""
        else if(value!=null&&value!=undefined&&value!=-1 && value!="")
            return ""+value.toFixed(1)+"%";
        else
            return "--"
    }
    function formatterUpload(value, rowData) {
        var gid=rowData.GRID_ID;
        var vid=rowData.VILLAGE_ID
        var rownum=rowData.ROWNUM
        var up=rowData.BEN_GIS_UPLOAD
        var name = rowData.VILLAGE_NAME
        var sub_id = rowData.SUB_ID;
        var breau_id = rowData.BREAU_ID;
        var city_id = rowData.CITY_ID;


        if (value==1){
            return "<u style='cursor:pointer;color:#00a8ff ; text-decoration: underline' onclick=\"clickdelete('"+vid+"','"+name+"')\">已上图</u>"
        }else if (value==''){
            return ''
        }else{
            return "<u style='color:#fde36c;cursor:pointer;text-decoration: underline' onclick=\"upLaodMap("+rownum+",'"+name+"',"+up+",'"+vid+"','"+gid+"','"+sub_id+"','"+breau_id+"','"+city_id+"')\">未上图</u>"
        }
    }
    function clickdelete(id,name) {
        parent.click_dele(id,name)
    }
    function upLaodMap(ROWNUM,VILLAGE_NAME,BEN_GIS_UPLOAD,VILLAGE_ID,GRID_ID,SUB_ID,BREAU_ID,CITY_ID){
        if(ROWNUM=="")
            return;
        var isOnMap = 1;
        if(BEN_GIS_UPLOAD!=1)
            isOnMap = 0;
        parent.villageObjectEdited = {"id":VILLAGE_ID,"name":VILLAGE_NAME,"isOnMap":isOnMap,"grid_id":GRID_ID,"sub_id":SUB_ID,"breau_id":BREAU_ID,"city_id":CITY_ID};
        parent.villageToMap();
    }
    $(function () {
        freshFigue1();
    })
</script>
</body>
