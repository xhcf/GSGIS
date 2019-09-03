<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<!-- 获取月账期 -->
<e:q4o var="monthObj">
 select t.const_value,substr(t.const_value,0,4) || '年' || SUBSTR(t.const_value,5) || '月' acc_month_desc from ${easy_user}.sys_const_table t where const_type = 'var.dss32' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:q4o var="quryDate1">
	select const_value ACCT_MON from ${easy_user}.sys_const_table where const_type = 'var.dss32' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="initMonth1">${quryDate1.ACCT_MON}</e:set>
<e:q4o var="default_day">
	select to_char(to_date(const_value,'yyyymmdd'),'yyyy-mm-dd') ACCT_DAY from ${easy_user}.sys_const_table where const_type = 'var.dss31' AND data_type = 'day' AND model_id = '16'
</e:q4o>
<e:set var="default_acct_day">${default_day.ACCT_DAY}</e:set>
<e:q4o var="initmonthobj">
 	select to_char(to_date(const_value,'yyyymm'),'yyyy-mm') acc_month from ${easy_user}.sys_const_table where const_type = 'var.dss32' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="initMonth">${initmonthobj.acc_month}</e:set>

<e:q4o var="minDate">
	select min(ACCT_MONTH) minMonth from ${channel_user}.TB_QDSP_STAT_VIEW_M t
</e:q4o>
<e:set var="initMinMonth">${minDate.minMonth}</e:set>

<e:q4o var="quryMonth">
	select const_value yMonth from ${easy_user}.sys_const_table where const_type = 'var.dss32' AND data_type = 'mon' AND model_id = '16'
</e:q4o>
<e:set var="maxMonth">${quryMonth.yMonth}</e:set>
<e:q4o var="acct_dayDate">
	select const_value acct_day from ${easy_user}.sys_const_table where const_type = 'var.dss31' AND data_type = 'day' AND model_id = '16'
</e:q4o>
<e:set var="initDay">${acct_dayDate.ACCT_DAY}</e:set>

<e:description>销售标签</e:description>
<e:q4o var="flag">
	SELECT ZERO_SALE_CHANNEL, LOW_SALE_CHANNEL, HIGH_CHANNEL,
		CASE
			WHEN ZERO_SALE_CHANNEL = 1 THEN '零销门店'
		  WHEN low_sale_channel = 1 THEN '低销门店'
	    WHEN high_channel = 1 THEN '高销门店'
	    ELSE '未归类门店'
    END VAL
  FROM ${channel_user}.TB_QDSP_STAT_VIEW_M T
 WHERE FLAG = 5
 AND channel_nbr = '${param.channel_nbr}'
 AND acct_month = '${maxMonth}'
</e:q4o>
<head>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_org_frame.css?version=1.1.1"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/leader_bureau_index.css?version=1.2.11"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/leader_condition_init.js?version=1.5"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.colors.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/channel_sandtable/js/dataFormat.js?version=New Date()"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/channel_sandtable/js/explain.js?version=New Date()"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/sp_channel.css?version=1.0"/>' rel="stylesheet" type="text/css" media="all" />
    <e:script value="/resources/layer/layer.js?version=1.1"/>
    <e:script value="/resources/My97DatePicker/WdatePicker.js"/>
    <title>效能概览</title>
	<style>
		#acc_month {
			color: #fff;position: absolute;top: 0px;right: 8px;
		}
		h5{
		 text-align:center;
		 font-size:10px;
		 margin-top:8px;/*li -5*/
		 margin-bottom:2px;
		}
		#zt_ul li{margin-left:6%!important;}
		.p_showxn{background:#376092;color:#fff;}
		#wdxn_table{border: 1px solid #E2E2E2;}
		#wdxn_table thead,tbody{font-size: 12px;border:1px solid #E2E2E2;}
		#wdxn_table tr td{line-height: 28px;}
		#wdxn_table thead tr td{text-align:center;}
		/* #wdxn_table tr td:nth-child(3){text-align:center;}
		#wdxn_table tr td:nth-child(4){text-align:center;} */
		#fzzt_monthdna{border-left:0px;border-right:0px;}
	</style>
    <c:resources type="easyui,app" style="b"/>
</head>
<body>
<div class="portrait">
	<ul class="p_tab">
		<li class="p_show">门店概览</li>
		<li>网点效能</li>
		<li>营销积分</li>
		<li>发展规模</li>
		<li>发展质态</li>
		<li style="border-right:none">发展效益</li>
		<li style="display:none;">对比</li>
	</ul>
	<span id="acc_month"></span>
	<div class="p_content">
		<!--基本信息start-->
		<div>
			<div class="basic_top" >
				<i></i><font id="channel_name">城关区电信营业厅</font>
				<div class="tag">
					<span id="xiaoneng"></span>
					<span id="yingli" style="display:none;"></span>
				</div>
			</div>
			<div class="basic_com">
				<p class="basic_info"><i></i>基本信息</p>
				<ul class="clearfix basic_center">
					<li>渠道类型：<span id="channel_type">城市 - 自营厅</span></li>
					<li>开店时间：<span id="eff_date">2016-10-12</span></li>
					<li style="width: 20%;">门店面积：<span id="channel_area">20㎡</span></li>
					<li>店&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;长：<span id="channel_manager">张老板</span></li>
					<li>联系电话：<span id="channel_manager_tel">18991133210</span></li>
					<li style="width: 21%;">渠道编码：<span id="channel_nbr">29233212100</span></li>
					<li>代&nbsp;&nbsp;理&nbsp;&nbsp;商：<span id="operators_name">中国电信兰州分公司(209123123312)</span></li>
					<li>地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址：<span id="channel_address">兰州市城关区麦积山路25号</span></li>
				</ul>
			</div>
			<div class="basic_com" style="margin-bottom:0;">
				<p class="basic_info"><i></i>重点指标</p>
				<div class="basic_bottom clearfix">
					<div>
						<P >营销积分</P>
						<span id="channel_jf">100,000</span>
						<h5>本月累计积分</h5>
						<ul>
							<li>•  发展积分：  <font id="cur_day_fzjf">95,000</font>分</li>
							<li>•  存量积分：  <font id="cur_day_cljf">95,000</font>分</li>
							<li>•  当日积分：  <font id="cur_day_jf">95,000</font>分</li>
							<li>•  当日户均： <font id="cur_ave_jf">95,000</font>分</li>
							<!-- <li>•  日&nbsp;环&nbsp;比&nbsp;：  <font id="day_rate">25.22%</font></li> -->
						</ul>
					</div>
					<!-- <div>
						<P>渠道效能</P>
						<span id="channel_xn">92</span>
						<ul>
							<li>•  渠道布局：  <font id="bjl">95</font></li>
							<li>•  渠道效益：   <font id="qdxyl">90</font></li>
							<li>•  用户规模：   <font id="yhgml">88</font></li>
							<li>•  用户质态：   <font id="yhztl">80</font></li>
						</ul>
					</div> -->
					<div>
						<P>发展规模</P>
						<span id="channel_fz">100,000</span>
						<h5>本月累计发展</h5>
						<ul style="float:left;width:65%;">
								<h2 style="margin-left:8px;margin-left:50%;font-weight: normal;">本月累计</h2>
								<li style="margin-left:15%;">•  移动：  <font id="yd_xz">95,000</font></li>
								<li style="margin-left:15%;">•  宽带：   <font id="kd_xz">95,000</font></li>
								<li style="margin-left:15%;">•  电视：   <font id="itv_xz">95,000</font></li>
						</ul>
						<ul style="float:left;width:35%;">
							<h2 style="margin-left:13%;font-weight: normal;">当日发展</h2>
							<li style="margin-left: 30%;"><font id="yd_xzr">95</font></li>
							<li style="margin-left: 30%;"><font id="kd_xzr">9</font></li>
							<li style="margin-left: 30%;"><font id="itv_xzr">12</font></li>
						</ul>
					</div>
					<div>
						<P>发展质态</P>
						<span id="fz_zt">100,000</span>
						<h5>移动新增活跃率</h5>
						<ul id="zt_ul" style="padding-top: 15px;">
							<li style="padding-bottom: 5px;">•  移动新增出账率：   <font id="zt_account_rate">23.02%</font></li>
							<li style="padding-bottom: 5px;">•  移动新增离网率：   <font id="zt_leave_rate">3320</font></li>
							<li style="padding-bottom: 5px;">•  新增&nbsp;DNA&nbsp;户均： <font id="zt_dna_ave">95</font></li>
						</ul>
					</div>
					<div>
						<P>发展效益</P>
						<!-- <span id="channel_ml">100,000</span> -->
						<span id="benefit_rate_all">100,000</span>
						<h5>毛利率</h5>
						<ul style="padding-top: 15px;">
							<!-- <li>•  收&nbsp;&nbsp;&nbsp;入：  <font id="sr">95,000</font></li>
							<li>•  成&nbsp;&nbsp;&nbsp;本： <font id="cb">95,000</font></li>
							<li>•  毛&nbsp;&nbsp;&nbsp;利： <font id="ml">950</font></li> -->
							<li style="margin-left:6%;padding-bottom: 5px;">•  毛&emsp;&emsp;&emsp;&emsp;利：  <font id="mle">95,000</font></li>
							<li style="margin-left:6%;padding-bottom: 5px;">•  百元拉新收入： <font id="100income">95,000</font></li>
							<li style="margin-left:6%">•  百元拉新用户： <font id="100user">950</font></li>
						</ul>
					</div>
				</div>
			</div>

		</div>
		<div style="margin-top:1%;display: none;">
			<div class="clearfix">
				<div class="fl xn_com xn_one" style="width:49.5%;">
					<h6 class="xn_title"><i></i>效能构成</h6>
					<div class="fl xndf">
						<p>渠道效能 ：<span id="xnNumber" style="font-size:14px;">--</span> </p>
						<p>渠道布局 ： <font id="qdbj">--</font></p>
						<p>渠道效益 ： <font id="qdxy">--</font></p>
						<p>用户规模 ： <font id="yhgm">--</font></p>
						<p>用户质态 ： <font id="yhzt">--</font></p>
					</div>
					<div class="fl one_echart">
						<div id="radar_01" style="width: 100%;height: 220px;"></div>
					</div>
				</div>
				<div class="fr xn_com xn_two" style="width:49.5%;">
					<h6 class="xn_title"><i></i>效能趋势</h6>
					<div class="bar_com" >
						<div id="bar1" style="width: 100%;height: 200px;"></div>
					</div>
				</div>
			</div>
			<div class="clearfix">
				<div class="fr xn_com xn_two" style="width:100%;margin-top:10px;height: auto;">
					<h6 class="xn_title"><i></i>效能指标</h6>
					<div class="bar_com1" style="height: auto;">
						<div style="width: 100%;height: auto;overflow-y: auto;margin-bottom:10px;" id="wdxn_table">
							 <table class="zbjs-table" cellpadding="0" cellspacing="0" border="1">
									<thead>
										<tr class="zbjstable-head">
											<td style="width:10%;">指标分类</td>
											<td>指标名称</td>
											<td style="width:5%;">权重</td>
											<td style="width:10%;">实际得分</td>
											<td style="width: 34%;">指标定义或口径</td>
											<td>考核指标值及子指标值</td>
										</tr>
									</thead>
									<tr class="qianlan">
											<td rowspan="2" style="text-align:center;">渠道布局类<br/>（10分）</td>
											<td>实体渠道坪效</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/厅店面积数（渠道视图中）</td>
											<td>实体渠道坪效：<span style="color:#0011ff">--</span><br/>当年累积收入：<span style="color:#0011ff">--万元</span><br/>厅店面积：<span style="color:#0011ff">--平方米</span></td>
										</tr>
										<tr class="shenlan">
											<td>实体渠道人效</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/（渠道视图中本渠道单元年初工号数+统计月工号数）的静态平均值</td>
											<td>实体渠道人效：<span style="color:#0011ff">--</span><br/>当年累积收入：<span style="color:#0011ff">--万元</span><br/>静态平均值：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="qianlan">
											<td rowspan="9" style="text-align:center;">用户规模类<br/>（60分）</td>
											<td>移动新增</td>
											<td style="text-align:center;">9</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>本月在网移动新增用户</td>
											<td>移动新增：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="shenlan">
											<td>移动三零用户数</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>月短信条数+语音分钟+上网流量M数为零</td>
											<td>移动三零用户数：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="qianlan">
											<td>移动有效用户数</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>月短信条数+语音分钟+上网流量M数≥30</td>
											<td>移动有效用户数：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="shenlan">
											<td>二次充值用户数</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>除首次开户CRM送计费外，再有充值记录均符合二次充值范畴</td>
											<td>二次充值用户数：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="qianlan">
											<td>宽带新增</td>
											<td style="text-align:center;">9</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>本月在网宽带新增用户</td>
											<td>宽带新增：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="shenlan">
											<td>宽带零流量用户数</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>上网M数为零</td>
											<td>宽带零流量用户数：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="qianlan">
											<td>宽带有效用户数</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>上网M数≥300</td>
											<td>宽带有效用户数：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="shenlan">
											<td>天翼高清新装</td>
											<td style="text-align:center;">7</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>本月在网天翼高清新增用户</td>
											<td>天翼高清新装：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="qianlan">
											<td>渠道积分</td>
											<td style="text-align:center;">10</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>根据积分规则计算出的渠道积分</td>
											<td>渠道积分：<span style="color:#0011ff">--万</span></td>
										</tr>
										<tr class="shenlan">
											<td rowspan="2" style="text-align:center;">用户质态类<br/>（10分）</td>
											<td>移动套餐价值</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>移动用户套餐价值合计</td>
											<td>移动套餐价值：<span style="color:#0011ff">--</span>万元/月</td>
										</tr>
										<tr class="qianlan">
											<td>当年新增移动保有率</td>
											<td style="text-align:center;">5</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>本年新增移动统计期内在网用户数/本年新增移动用户数</td>
											<td>当年新增移动<br/>保有率：<span style="color:#0011ff">--</span><br/>本年新增移动在网用户数：<span style="color:#0011ff">--</span><br/>本年新增移动用户数：<span style="color:#0011ff">--</span></td>
										</tr>
										<tr class="shenlan">
											<td rowspan="3" style="text-align:center;">渠道效益类<br/>（20分）</td>
											<td>百元渠道佣金拉动新增收入</td>
											<td style="text-align:center;">6</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>本年新增用户本年累计新增收入（计费出账数据）/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>
											<td>百元渠道佣金<br/>拉动新增收入：<span style="color:#0011ff">--万元</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">--万元</span><br/>本年累计渠道佣金:<span style="color:#0011ff">--</span>元</td>
										</tr>
										<tr class="qianlan">
											<td>百元渠道佣金拉动新增用户</td>
											<td style="text-align:center;">6</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>本年新增用户本年累计新增用户/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>
											<td>百元渠道佣金拉动<br/>新增用户：<span style="color:#0011ff">--户</span><br/>本年累计新增用户：<span style="color:#0011ff">--户</span><br/>本年累计渠道佣金：<span style="color:#0011ff">--</span>元</td>
										</tr>
										<tr class="shenlan">
											<td>门店毛利率</td>
											<td style="text-align:center;">8</td>
											<td style="text-align:center;color:#f90;">--</td>
											<td>引用财务部毛利模型测算结果</td>
											<td>门店毛利率：<span style="color:#0011ff">--</span></td>
										</tr>
									</table>
							</div>
					</div>
				</div>
			</div>
		</div>
		<!--//基本信息end-->
			<!--营销积分 NBS-->
		<div  style="display: none;" class="nlfx">
			<div class="ability">
				<%-- <h4 class="ability_title"><i class="fa fa-database"></i>营销积分
					<a href="javascript:void(0)" class="det_btn">详情</a>
				</h4> --%>
				<div class="clearfix">
					<div class="fl xn_com xn_tree" style="margin-top:10px;height:350px;">
						<h6 class="xn_title"><i></i>营销日积分</h6>
						<span style="display: block;margin-top: -25px;text-align: right;margin-right: 20px;">日账期：
							<c:datebox required='false' format='yyyy-mm-dd' name='acct_day' id='acct_day'  defaultValue='${default_acct_day}'/>
						</span>

						<table class="xn_table jf_table">
							<thead>
								<tr style="background: #EEF7FF;">
									<td>指标项</td>
									<td>本月累计积分</td>
									<td>本月户均</td>
									<td>当日积分</td>
									<td>当日户均</td>
									<!-- <td>昨日积分</td>
									<td>日环比</td> -->
								</tr>
							</thead>
							<tbody id="qdjf_jfday">

							</tbody>
						</table>

					</div>
					<div class="xn_com jf_day" style="height:230px;">
						<h6 class="xn_title"><i></i>日积分趋势</h6>
						<div class="bar_com" >
							<div id="line2" style="width: 100%;height: 200px;"></div>
						</div>
					</div>

					<div class="fl xn_com xn_tree" style="margin-top:10px;height:380px;">
						<h6 class="xn_title"><i></i>营销月积分</h6>
						<span style="display: block;margin-top: -25px;text-align: right;margin-right: 20px;">月账期：
							<%-- <c:datebox required='false' format='yyyy-mm-dd' name='acct_month' id='acct_month'  defaultValue='${default_acct_day}'/> --%>
							<!-- <input id="acct_month" editable="false" class="easyui-datebox" type="text" style="color:#ffffff; width:120px;"/> -->
							<input id="acct_month" type="text" style="color:#000; width:120px;" value="${initMonth}"
				 						onclick="WdatePicker({dateFmt:'yyyy-MM',onpicked:function(){getScoreMonth()}})" class="Wdate" />
						</span>
						<table class="xn_table jf_table">
							<thead>
								<tr style="background: #EEF7FF;">
									<td>指标项</td>
									<td>本年累计积分</td>
									<td>当月值</td>
									<td>上月值</td>
									<td>差值</td>
									<td>月环比</td>
								</tr>
							</thead>
							<tbody id="qdjf_jfmonth">

							</tbody>
						</table>

					</div>
					<div class="fr xn_com xn_two"  style="margin-top:10px;height:230px;">
						<h6 class="xn_title"><i></i>月积分趋势</h6>
						<div class="bar_com" >
							<div id="line1" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
			<!--发展规模 NBS-->
		<div  style="display: none;" class="nlfx">
			<div class="ability">
				<%-- <h4 class="ability_title"><i class="fa fa-database"></i>营销积分
					<a href="javascript:void(0)" class="det_btn">详情</a>
				</h4> --%>
				<div class="clearfix">
					<div class="fl xn_com xn_tree" style="height:230px;margin-top: 10px;">
						<h6 class="xn_title"><i></i>日发展规模</h6>
						<span style="display: block;margin-top: -25px;text-align: right;margin-right: 20px;">日账期：
							<c:datebox required='false' format='yyyy-mm-dd' name='acct_dayfzxn' id='acct_dayfzxn' defaultValue='${default_acct_day}'/>
						</span>
						<table class="xn_table fzxn_table">
							<thead>
								<tr style="background: #EEF7FF;">
									<td>指标项</td>
									<td>本月累计发展</td>
									<!-- <td>上月累计</td>
									<td>月累计环比</td> -->
									<td>当日发展</td>
									<td>昨日发展</td>
									<!-- <td>日环比</td> -->
								</tr>
							</thead>
							<tbody id="fzxn_fzxnday">
								<tr>
									<td>合计</td>
									<td id="curmonth_xn">0.00</td>
									<td id="lastmonth_xn">0.00</td>
									<td id="month_xnrate">25.02%</td>
									<td id="curday_xn">0.00</td>
									<td id="lastday_xn">0.00</td>
									<td id="day_xnrate">0.00</td>
								</tr>
								<tr>
									<td>移动</td>
									<td id="curmonth_xnsj">0.00</td>
									<td id="lastmonth_xnsj">0.00</td>
									<td id="month_xnratesj">25.02%</td>
									<td id="curday_xnsj">0.00</td>
									<td id="lastday_xnsj">0.00</td>
									<td id="day_xnratesj">0.00</td>
								</tr>
								<tr>
									<td>宽带</td>
									<td id="curmonth_xnkd">0.00</td>
									<td id="lastmonth_xnkd">0.00</td>
									<td id="month_xnratekd">25.02%</td>
									<td id="curday_xnkd">0.00</td>
									<td id="lastday_xnkd">0.00</td>
									<td id="day_xnratekd">0.00</td>
								</tr>
								<tr>
									<td>电视</td>
									<td id="curmonth_xnds">0.00</td>
									<td id="lastmonth_xnds">0.00</td>
									<td id="month_xnrateds">25.02%</td>
									<td id="curday_xnds">0.00</td>
									<td id="lastday_xnds">0.00</td>
									<td id="day_xnrateds">0.00</td>
								</tr>
								<!-- <tr>
									<td>橙分期</td>
									<td id="curmonth_xncfq">0.00</td>
									<td id="lastmonth_xncfq">0.00</td>
									<td id="month_xnratecfq">25.02%</td>
									<td id="curday_xncfq">0.00</td>
									<td id="lastday_xncfq">0.00</td>
									<td id="day_xnratecfq">0.00</td>
								</tr>
								<tr>
									<td>终端</td>
									<td id="curmonth_xnzd">0.00</td>
									<td id="lastmonth_xnzd">0.00</td>
									<td id="month_xnratezd">25.02%</td>
									<td id="curday_xnzd">0.00</td>
									<td id="lastday_xnzd">0.00</td>
									<td id="day_xnratezd">0.00</td>
								</tr> -->
							</tbody>
						</table>

					</div>
					<div class="xn_com jf_day" style="margin-top:250px;">
						<h6 class="xn_title"><i></i>日发展趋势</h6>
						<button class="fzxn_btn p_showxn" style="margin-left:40%;" onclick="xnrfzds(1)">移动</button>
						<button class="fzxn_btn" onclick="xnrfzds(2)">宽带</button>
						<button class="fzxn_btn" onclick="xnrfzds(3)">电视</button>
						<!-- <button class="fzxn_btn" onclick="xnrfzds()">橙分期</button>
						<button class="fzxn_btn" onclick="xnrfzds()">终端</button> -->
						<div class="bar_com" >
							<div id="line3" style="width: 100%;height: 180px;"></div>
						</div>
					</div>

					<div class="fl xn_com xn_tree" style="margin-top:10px;height:270px;">
						<h6 class="xn_title"><i></i>月发展规模</h6>
						<span style="display: block;margin-top: -25px;text-align: right;margin-right: 20px;">月账期：
							<%-- <c:datebox required='false' format='yyyy-mm-dd' name='acct_month' id='acct_month'  defaultValue='${default_acct_day}'/> --%>
							<!-- <input id="acct_month" editable="false" class="easyui-datebox" type="text" style="color:#ffffff; width:120px;"/> -->
							<input id="acct_xnmonth" type="text" style="color:#000; width:120px;" value="${initMonth}"
				 						onclick="WdatePicker({dateFmt:'yyyy-MM',onpicked:function(){getFzxnMonth()}})" class="Wdate" />
						</span>
						<table class="xn_table jf_table">
							<thead>
								<tr style="background: #EEF7FF;">
									<td>指标项</td>
									<td>本年累计发展</td>
									<td>当月发展</td>
									<td>上月发展</td>
									<td>差值</td>
								</tr>
							</thead>
							<tbody id="fzxn_fzxnmonth">
								<tr>
									<td>合计</td>
									<td id="curmonth_jf">0.00</td>
									<td id="lastmonth_jf">0.00</td>
									<td id="month_rate">25.02%</td>
								</tr>
								<tr>
									<td>移动</td>
									<td id="curmonth_sjjf">0.00</td>
									<td id="lastmonth_sjjf">0.00</td>
									<td id="month_sjrate">25.02%</td>
								</tr>
								<tr>
									<td>电视</td>
									<td id="curmonth_dsjf">0.00</td>
									<td id="lastmonth_dsjf">0.00</td>
									<td id="month_dsrate">25.02%</td>
								</tr>
								<tr>
									<td>宽带</td>
									<td id="curmonth_kdjf">0.00</td>
									<td id="lastmonth_kdjf">0.00</td>
									<td id="month_kdrate">25.02%</td>
								</tr>
								<!-- <tr>
									<td>橙分期</td>
									<td id="curmonth_cfqjf">0.00</td>
									<td id="lastmonth_cfqjf">0.00</td>
									<td id="month_cfqrate">25.02%</td>
								</tr>
								<tr>
									<td>终端</td>
									<td id="curmonth_zdjf">0.00</td>
									<td id="lastmonth_zdjf">0.00</td>
									<td id="month_zdrate">25.02%</td>
								</tr> -->
							</tbody>
						</table>

					</div>
					<div class="fr xn_com xn_two"  style="margin-top:10px;">
						<h6 class="xn_title"><i></i>月发展趋势</h6>
						<div class="bar_com" >
							<div id="linexnmonth" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 发展质态NBS -->
		<div  style="display: none;" class="nlfx">
			<div class="ability">
				<%-- <h4 class="ability_title"><i class="fa fa-database"></i>营销积分
					<a href="javascript:void(0)" class="det_btn">详情</a>
				</h4> --%>
				<div class="clearfix">
					<div class="fl xn_com xn_tree" style="margin-top:10px;height:247px;">
						<h6 class="xn_title"><i></i>发展质态</h6>
						<span style="display: block;margin-top: -25px;text-align: right;margin-right: 20px;">月账期：
							<!-- <input id="acct_monthzt" editable="false" class="easyui-datebox" type="text" style="color:#ffffff; width:120px;"/> -->
							<input id="acct_monthzt" type="text" style="color:#000; width:120px;" value="${initMonth}"
				 						onclick="WdatePicker({dateFmt:'yyyy-MM',onpicked:function(){getFzztMonth()}})" class="Wdate" />
						</span>
						<table class="xn_table jf_table">
							<thead>
								<tr style="background: #EEF7FF;">
									<td>指标项</td>
									<td>当月值</td>
									<td>上月值</td>
									<td>差值</td>
								</tr>
							</thead>
							<tbody id="fzzt_month">
								<tr>
									<td>活跃率</td>
									<td id="curmonth_zt">0.00</td>
									<td id="lastmonth_zt">0.00</td>
									<td id="month_ratezt">25.02%</td>
								</tr>
								<tr>
									<td>新入网用户</td>
									<td id="curmonth_newuser">0.00</td>
									<td id="lastmonth_newuser">0.00</td>
									<td id="month_ratenewuser">25.02%</td>
								</tr>
								<tr>
									<td>出账率</td>
									<td id="curmonth_czrate">0.00</td>
									<td id="lastmonth_czrate">0.00</td>
									<td id="month_czrate">25.02%</td>
								</tr>
								<tr>
									<td>离网率</td>
									<td id="curmonth_lwrate">0.00</td>
									<td id="lastmonth_lwrate">0.00</td>
									<td id="month_lwrate">25.02%</td>
								</tr>
								<tr>
									<td>DNA户均得分</td>
									<td id="curmonth_dnascore">98</td>
									<td id="lastmonth_dnascore">55</td>
									<td id="month_dnascore">25.02%</td>
								</tr>
							</tbody>
						</table>

					</div>
					<div class="fr xn_com xn_two"  style="margin-top:10px;">
						<h6 class="xn_title"><i></i>趋势分析</h6>
						<button class="fzzt_btn p_showxn" style="margin-left:35%;" onclick="devAnalysis(1)">移动新增活跃率</button>
						<!-- <button class="fzzt_btn" onclick="devAnalysis()">新入网</button> -->
						<button class="fzzt_btn" onclick="devAnalysis(2)">移动新增出账率</button>
						<button class="fzzt_btn" onclick="devAnalysis(3)">移动新增离网率</button>
						<button class="fzzt_btn" onclick="devAnalysis(4)">宽带新增离网率</button>
						<div class="bar_com" >
							<div id="line4" style="width: 100%;height: 180px;"></div>
						</div>
					</div>
					<div class="fr xn_com xn_two"  style="margin-top:10px;">
						<h6 class="xn_title"><i></i>移动DNA得分</h6>
						<span style="display: block;margin-top: -25px;text-align: right;margin-right: 20px;">日账期：
							<!-- <input id="acct_monthzt" editable="false" class="easyui-datebox" type="text" style="color:#ffffff; width:120px;"/> -->
							<input id="" type="text" style="color:#000; width:120px;" value="${default_acct_day}"
				 						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){getFzztMonthDNA()}})" class="Wdate" />
							<input id="acct_monthdna" type="text" style="color:#000; width:120px;display:none;" value="${initMonth}"
				 						onclick="WdatePicker({dateFmt:'yyyy-MM',onpicked:function(){getFzztMonthDNA()}})" class="Wdate" />
						</span>
						<table class="xn_table dna_table" style="width: 90%;">
							<thead>
								<tr><td colspan="10">月累积DNA-7大基因分项平均分</td></tr>
								<tr>
									<td>账期               </td>
									<td>累计新增<br/>用户         </td>
									<td>总积分<br/>（10分）     </td>
									<td>融合度<br/>（1.5分）    </td>
									<td>证件主卡数<br/>（1.5分）</td>
									<td>终端注册<br/>（1.5分）  </td>
									<td>新旧身份证<br/>（1分）  </td>
									<td>协议系数<br/>（1.5分）  </td>
									<td>首次预付款<br/>（1.5分）</td>
									<td>套餐价值<br/>（1.5分）  </td>
								</tr>
							</thead>
							<tbody id="fzzt_monthdna">
								<tr>
									<td>本月</td>
									<td>521</td>
									<td>10</td>
									<td>1.2</td>
									<td>1.2</td>
									<td>1.2</td>
									<td>1.2</td>
									<td>1.2</td>
									<td>1.2</td>
									<td>1.2</td>
								</tr>
								<tr>
									<td>上月</td>
									<td>500</td>
									<td>7</td>
									<td>1.1</td>
									<td>1.3</td>
									<td>1.1</td>
									<td>1.1</td>
									<td>1.0</td>
									<td>1.2</td>
									<td>1.2</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!--发展效益start-->
		<div style="display: none;" class="nlfx">

			<div class="ability">
				<%-- <h4 class="ability_title"><i class="fa fa-database"></i>营销积分
					<a href="javascript:void(0)" class="det_btn">详情</a>
				</h4> --%>
				<div class="clearfix">
					<div class="fl xn_com xn_tree" style="margin-top:10px;height:300px;width: 100%">
						<h6 class="xn_title"><i></i>发展效益</h6>
						<span style="display: block;margin-top: -25px;text-align: right;margin-right: 20px;">月账期：
							<%-- <c:datebox required='false' format='yyyy-mm-dd' name='acct_month' id='acct_month'  defaultValue='${default_acct_day}'/> --%>
							<!-- <input id="acct_monthxy" editable="false" class="easyui-datebox" type="text" style="color:#ffffff; width:120px;"/> -->
							<input id="acct_monthxy" type="text" style="color:#000; width:120px;" value="${initMonth}"
							 						onclick="WdatePicker({dateFmt:'yyyy-MM',onpicked:function(){fzxy_xy_analize()}})" class="Wdate" />
						</span>
						<table class="xn_table jf_table">
							<thead>
								<tr style="background: #EEF7FF;">
									<td>指标项</td>
									<td>当月值</td>
									<td>上月值</td>
									<td>月环比</td>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>毛利率</td>
									<td id="ml_rate">0.00</td>
									<td id="last_ml_rate">0.00</td>
									<td id="ml_rate_rate">25.02%</td>
								</tr>
								<tr>
									<td>毛利（元）</td>
									<td id="ml_num">0.00</td>
									<td id="last_ml_num">0.00</td>
									<td id="ml_num_rate">25.02%</td>
								</tr>
								<tr>
									<td>收入（元）</td>
									<td id="sr_num">0.00</td>
									<td id="last_sr_num">0.00</td>
									<td id="sr_num_rate">25.02%</td>
								</tr>
								<tr>
									<td>成本（元）</td>
									<td id="cb_num">0.00</td>
									<td id="last_cb_num">0.00</td>
									<td id="cb_num_rate">25.02%</td>
								</tr>
								<tr>
									<td>百元拉新收入（元）</td>
									<td id="100new_num">0.00</td>
									<td id="last_100new_num">0.00</td>
									<td id="100new_num_rate">25.02%</td>
								</tr>
								<tr>
									<td>百元拉新用户</td>
									<td id="100new_income_num">0.00</td>
									<td id="last_100new_income_num">0.00</td>
									<td id="100new_income_num_rate">25.02%</td>
								</tr>
							</tbody>
						</table>

					</div>
					<div class="fl xn_com xn_tree" style="margin-left:10px;;margin-top:10px;height:300px;width: 49.3%;display:none;">
						<h6 class="xn_title"><i></i>佣金构成</h6>
						<table class="xn_table cb_table">
							<thead>
								<tr>
									<td>指标项</td>
									<td>本月值</td>
									<td>上月值</td>
									<td>月环比</td>
									<!-- <td>占比</td> -->
								</tr>
							</thead>
							<tbody id="fzxy_cb_table">
								<tr>
									<td>佣金</td>
									<td id="cb_total">0.00</td>
									<td id="last_cb_total">0.00</td>
									<td id="cb_total_rate">25.02%</td>
									<!-- <td id="cb_total_zb">25.02%</td> -->
								</tr>
								<tr>
									<td>基础佣金</td>
									<td id="cb_yj">0.00</td>
									<td id="last_cb_yj">0.00</td>
									<td id="cb_yj_rate">25.02%</td>
									<!-- <td id="cb_yj_zb">25.02%</td> -->
								</tr>
								<tr>
									<td>渠道奖励</td>
									<td id="cb_jl">0.00</td>
									<td id="last_cb_jl">0.00</td>
									<td id="cb_jl_rate">25.02%</td>
									<!-- <td id="cb_jl_zb">25.02%</td> -->
								</tr>
								<tr>
									<td>渠道支撑</td>
									<td id="cb_zc">0.00</td>
									<td id="last_cb_zc">0.00</td>
									<td id="cb_zc_rate">25.02%</td>
									<!-- <td id="cb_zc_zb">25.02%</td> -->
								</tr>
								<tr>
									<td>收入分成</td>
									<td id="cb_fc">0.00</td>
									<td id="last_cb_fc">0.00</td>
									<td id="cb_fc_rate">25.02%</td>
									<!-- <td id="cb_fc_zb">25.02%</td> -->
								</tr>
							</tbody>
						</table>

					</div>
					<div class="fr xn_com xn_tree"  style="margin-top:10px;width: 100%;float: left;">
						<h6 class="xn_title"><i></i>毛利率趋势</h6>
						<div class="bar_com" >
							<div id="line5" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
					<div class="fr xn_com xn_tree"  style="margin-top:10px;width: 49.3%;float: left;margin-left: 10px;display:none;">
						<h6 class="xn_title"><i></i>佣金构成</h6>
						<div class="bar_com" >
							<div id="line6" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--//能力分析end-->
		<!--能力分析start-->
		<div style="display: none;" class="nlfx">
			<!--效能得分-->
			<div class="ability">
				<h4 class="ability_title"><i class="fa fa-th-large"></i>渠道效能
					<a href="javascript:void(0)" class="det_btn">详情</a>
				</h4>
				<div class="clearfix">
					<div class="fl xn_com xn_one">
						<h6 class="xn_title"><i></i>效能构成</h6>
						<div class="fl xndf">
							<p>渠道效能 ： <span id="xnNumber" style="font-size:14px;">80</span> </p>
							<p>渠道布局 ： <font id="qdbj"></font></p>
							<p>渠道效益 ： <font id="qdxy"></font></p>
							<p>用户规模 ： <font id="yhgm"></font></p>
							<p>用户质态 ： <font id="yhzt"></font></p>
						</div>
						<div class="fl one_echart">
							<div id="radar_01a" style="width: 100%;height: 220px;"></div>
						</div>
					</div>
					<div class="fr xn_com xn_two">
						<h6 class="xn_title"><i></i>效能趋势</h6>
						<div class="bar_com" >
							<div id="bar1a" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
			<!--营销积分-->
			<div class="ability">
				<h4 class="ability_title"><i class="fa fa-database"></i>营销积分
					<a href="javascript:void(0)" class="det_btn">详情</a>
				</h4>
				<div class="clearfix">
					<div class="fl xn_com xn_tree">
						<h6 class="xn_title"><i></i>积分构成</h6>
						<table class="xn_table jf_table">
							<thead>
								<tr>
									<td>指标项</td>
									<td>本月积分</td>
									<td>上月积分</td>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>合计</td>
									<td id="jfTotal">0.00</td>
									<td id="jfpmTotal">0.00</td>
								</tr>
								<tr>
									<td>发展积分</td>
									<td id="fzjf">0.00</td>
									<td id="fzpm">0.00</td>
								</tr>
								<tr>
									<td>存量积分</td>
									<td id="cljf">0.00</td>
									<td id="clpm">0.00</td>
								</tr>
								<!-- <tr>
									<td>收入积分</td>
									<td id="srjf">0.00</td>
									<td id="srpm">0.00</td>
								</tr> -->
								<tr>
									<td>其它积分</td>
									<td id="qtjf">0.00</td>
									<td id="qtpm">0.00</td>
								</tr>
							</tbody>
						</table>

					</div>
					<div class="fr xn_com xn_two">
						<h6 class="xn_title"><i></i>月积分趋势</h6>
						<div class="bar_com" >
							<div id="line1a" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
				<div class="xn_com jf_day">
					<h6 class="xn_title"><i></i>日积分趋势</h6>
					<div class="bar_com" >
						<div id="line2a" style="width: 100%;height: 200px;"></div>
					</div>
				</div>
			</div>
			<!--业务发展-->
			<div class="ability" style="margin-bottom: 10px;">
				<h4 class="ability_title"><i class="fa fa-area-chart"></i>业务发展
					<%-- <a href="javascript:void(0)" class="det_btn">详情</a> --%>
				</h4>
				<div class="clearfix">
					<div class="fl xn_com xn_tree">
						<h6 class="xn_title"><i></i>业务构成</h6>
						<table class="xn_table yw_table">
							<thead>
								<tr>
									<td>指标项</td>
									<td>上月发展量</td>
									<td>本月发展量</td>
									<td>当日发展量</td>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>移动</td>
									<td id="byyd">0.00</td>
									<td id="syyd">0.00</td>
									<td id="dryd">0.00</td>
								</tr>
								<tr>
									<td>宽带</td>
									<td id="bykd">0.00</td>
									<td id="sykd">0.00</td>
									<td id="drkd">0.00</td>
								</tr>
								<tr>
									<td>ITV</td>
									<td id="byitv">0.00</td>
									<td id="syitv">0.00</td>
									<td id="dritv">0.00</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="fr xn_com xn_two">
						<h6 class="xn_title"><i></i>发展趋势</h6>
						<div class="bar_com" >
							<div id="bar3" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
			<!--毛利-->
			<div class="ability" style="margin-bottom: 10px;">
				<h4 class="ability_title"><i class="fa fa-pie-chart"></i>毛利
					<%-- <a href="javascript:void(0)" class="det_btn">详情</a> --%>
				</h4>
				<div class="clearfix">
					<div class="fl xn_com xn_tree">
						<h6 class="xn_title"><i></i>毛利构成</h6>
						<table class="xn_table ml_table">
							<thead>
								<tr>
									<td>指标项</td>
									<td>本月值</td>
									<td>上月值</td>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>毛利</td>
									<td id="byml">0.00</td>
									<td id="syml">0.00</td>
								</tr>
								<tr>
									<td>收入</td>
									<td id="bysr">0.00</td>
									<td id="sysr">0.00</td>
								</tr>
								<tr>
									<td>成本</td>
									<td id="bycb">0.00</td>
									<td id="sycb">0.00</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="fr xn_com xn_two">
						<h6 class="xn_title"><i></i>毛利趋势</h6>
						<div class="bar_com" >
							<div id="bar2" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--//能力分析end-->

		<!--对比内容start-->
		<div style="display: none;text-align: center;"><h2>暂无内容</h2></div>
		<!--//对比内容end-->

		<!--详情start-->
		<div style="display: none;" class="p_detail_wrap">
			<h4><span>详情</span><i class="fa fa-close p_close"></i></h4>
			<div>
			<ul class="det_list clearfix">
				<li class="current">效能</li>
				<li>积分</li>
				<li>毛利</li>
				<li>业务发展</li>
			</ul>
			</div>
			<div id="pgjs" style="text-align:right;position:absolute;margin-left:90%;margin-top:-3.5%"><a style="color:blue;text-decoration:underline;" onclick="explain()">指标解释</a></div>
			<div id="jfjs" style="text-align:right;position:absolute;margin-left:90%;margin-top:-3.5%;display:none;"><a style="color:blue;text-decoration:underline;" onclick="viewScoreRule()">积分规则</a></div>
			<div class="p_detail">
				<table>
					<thead>
						<tr>
							<td>月份</td>
							<td>得分</td>
							<!-- <td>省排名</td> -->
							<td>渠道布局</td>
							<td>用户规模</td>
							<td>用户质态</td>
							<td>渠道效益</td>
						</tr>
					</thead>
					<tbody id="xnDetailTable">
					</tbody>
				</table>
				<table style="display: none;">
					<thead>
						<tr>
							<td>月份</td>
							<td>积分</td>
							<!-- <td>省排名</td> -->
							<td>发展积分</td>
							<td>存量积分</td>
							<!-- <td>收入积分</td> -->
							<td>其它积分</td>
						</tr>
					</thead>
					<tbody id="jfDetailTable">
					</tbody>
				</table>
				<table style="display: none;">
					<thead>
						<tr>
							<td>月份</td>
							<td>毛利</td>
							<!-- <td>省排名</td> -->
							<td>成本</td>
							<td>收入</td>
							<td>毛利率</td>
						</tr>
					</thead>
					<tbody id="mlDetailTable">
					</tbody>
				</table>
				<table style="display: none;">
					<thead>
						<tr>
							<td>月份</td>
							<td>移动发展量</td>
							<td>宽带发展量</td>
							<td>ITV发展量</td>
						</tr>
					</thead>
					<tbody id="ywfzTable">
					</tbody>
				</table>
			</div>
		</div>
		<!--//详情end-->

	</div>

</div>
<script type="text/javascript">
	var sql_url = "<e:url value='pages/telecom_Index/channel_sandtable/channel_action/channel_portraitAction.jsp'/>";
	var channel_nbr="${param.channel_nbr}";

	var month = "${monthObj.CONST_VALUE}";
	var acct_day = "${default_acct_day}";
		acct_day = acct_day.replace(/-/g,'');
	var channel_obj = {};
	$(function(){
		$("#xiaoneng").text("${flag.VAL}");
		$("#acct_day").datebox({
			width:120,
			onChange:function(value,index){
				getScoreDay();
			}
		});
		$("#acct_dayfzxn").datebox({
			width:120,
			onChange:function(value,index){
				getFzxnDay();
			}
		});
		//tab切换
		$('.fzxn_btn').click(function(){
			$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
			//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
		})
		//tab切换
		$('.fzzt_btn').click(function(){
			$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
			//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
		})
		//tab切换
		$('.p_tab li').click(function(){
			$(this).addClass('p_show').siblings().removeClass('p_show');
			$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
		})
		//详情切换
		$('.det_btn').click(function(){
			$('.nlfx').css("display","none");
			$('.p_detail_wrap').css("display","block");
			$('.det_list li').eq($('.det_btn').index($(this))).click();
			//判断点击了那个的详情  效能=0   积分=1
			if($('.det_btn').index($(this)) == 0){
				$('#pgjs').css("display","block");
				$('#jfjs').css("display","none");
			}else if($('.det_btn').index($(this)) == 1){
				$('#jfjs').css("display","block");
				$('#pgjs').css("display","none");
			}else{
				$('#jfjs').css("display","none");
				$('#pgjs').css("display","none");
			}
		})
		$('.p_close').click(function(){
			$('.nlfx').css("display","block");
			$('.p_detail_wrap').css("display","none");
		})
		//详情内容切换
		$('.det_list li').click(function(){
			$(this).addClass('current').siblings().removeClass('current');
			$('.p_detail>table:eq('+$(this).index()+')').show().siblings().hide();
			//判断点击了那个的详情  效能=0   积分=1
			if($(this).index() == 0){
				$('#pgjs').css("display","block");
				$('#jfjs').css("display","none");
			}else if($(this).index() == 1){
				$('#jfjs').css("display","block");
				$('#pgjs').css("display","none");
			}else{
				$('#jfjs').css("display","none");
				$('#pgjs').css("display","none");
			}
		})

		getBaseInfo();//基本信息
		getScoreDay();//营销积分-日积分表格
		getScoreMonth();//营销积分-月积分表格
		getFzxnDay();//发展规模-日积分表格
		getFzxnMonth();//发展规模-月积分表格
		getFzztMonth();//发展质态-月积分表格
		getFzztMonthDNA();//发展质态-DNA表格

	})
	/*function getBaseInfo1(){
		$.post(sql_url,{"eaction":"getBaseInfo",month:month,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			if(json !=''&&json != null){
				channel_obj = json;
				$("#channel_name").html(json.CHANNEL_NAME);
				$("#channel_type").html(json.CHANNEL_TYPE_NAME_QD);
				$("#eff_date").html(json.EFF_DATE.substring(0,10));
				$("#channel_area").html(json.CHANNEL_AREA+"㎡");
				$("#channel_manager").html(json.CHANNEL_MANAGER);
				$("#channel_manager_tel").html(json.CHANNEL_MANAGER_TEL);
				$("#channel_nbr").html(json.CHANNEL_NBR);
				$("#operators_name").html(json.OPERATORS_NAME);
				$("#channel_address").html(json.CHANNEL_ADDRESS);
			}

			getKeyKpi();//重点指标
			getNengliAnalysis(); //能力分析
			getDetailQD();//详情

		});
	}*/
	function getKeyKpi(){
		$.post(sql_url,{"eaction":"getKeyKpi",month:month,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			if(json !=''&&json != null){
				$("#channel_xn").html(json.XN_CUR_MONTH_SCORE);
				$("#xiaoneng").text(xn_flag(json.XN_CUR_MONTH_SCORE)).show();//效能标签
				$("#bjl").html(json.BJL==null?'0.00':json.BJL.toFixed(2));
				$("#qdxyl").html(json.QDXYL==null?'0.00':json.QDXYL.toFixed(2));
				$("#yhgml").html(json.YHGML==null?'0.00':json.YHGML.toFixed(2));
				$("#yhztl").html(json.YHZTL==null?'0.00':json.YHZTL.toFixed(2));

				$("#channel_jf").html(json.QDJF_CUR_MONTH==null?'0.00':json.QDJF_CUR_MONTH.toFixed(2));
				$("#yingli").text(jf_flag(json.QDJF_CUR_MONTH)).show();//积分标签
				$("#curyear_jf").html(json.HJ_JF_YEAR==null?'0.00':json.HJ_JF_YEAR.toFixed(2));
				$("#curmonth_jf").html(json.QDJF_CUR_MONTH==null?'0.00':json.QDJF_CUR_MONTH.toFixed(2));
				$("#lastmonth_jf").html(json.QDJF_LAST_MONTH==null?'0.00':json.QDJF_LAST_MONTH.toFixed(2));
				$("#month_rate").html(json.QDJF_CUR_MONTH==null?'0.00':(((json.QDJF_CUR_MONTH - json.QDJF_LAST_MONTH)/json.QDJF_CUR_MONTH)*100).toFixed(2)+'%');

				$("#channel_ml").html(json.QDML_CUR_MONTH);
				$("#sr").html(json.SR==null?'0.00':json.SR.toFixed(2));
				$("#cb").html(json.CB==null?'0.00':json.CB.toFixed(2));
				$("#benefit_rate").html(json.BENEFIT_RATE==null?'0.00':json.BENEFIT_RATE.toFixed(2)+'%');
				$("#benefit_rate_all").html(json.BENEFIT_RATE==null?'0.00':json.BENEFIT_RATE.toFixed(2)+'%');

				$("#channel_fz").html(json.YWFZ_CUR_MONTH_SUM);
				$("#yd_xz").html(json.YWFZ_CUR_MONTH_YD);
				$("#kd_xz").html(json.YWFZ_CUR_MONTH_KD);
				$("#itv_xz").html(json.YWFZ_CUR_MONTH_ITV);
			}
		});
	}

	//NBS 数据绑定
	//渠道画像-效能概览
	function getBaseInfo(){

		$.post(sql_url,{"eaction":"qdhx_qdgl",month:month,day:acct_day,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			if(json !=''&&json != null){
				//基本信息
				$("#channel_name").html(json.CHANNEL_NAME);
				//$("#channel_type").html(json.CHANNEL_TYPE_NAME);
				$("#channel_type").html(json.ENTITY_CHANNEL_TYPE_NAME);
				$("#eff_date").html(json.EFF_DATE.substring(0,10));
				$("#channel_area").html(json.CHANNEL_AREA+"㎡");
				$("#channel_manager").html(json.CHANNEL_MANAGER);
				$("#channel_manager_tel").html(json.CHANNEL_MANAGER_TEL);
				$("#channel_nbr").html(json.CHANNEL_NBR);
				$("#operators_name").html(json.OPERATORS_NAME);
				$("#channel_address").html(json.CHANNEL_ADDRESS);

				//重点指标
				//积分
				$("#channel_jf").html(json.CUR_MONTH_SUM_JF);
				/*$("#curyear_jf").html(json.CUR_YEAR_JF);
				$("#curmonth_jf").html(json.CUR_MON_JF);
				$("#lastmonth_jf").html(json.LAST_MON_JF);
				$("#month_rate").html(json.JF_MONTH_RATE);*/

				$("#cur_ave_jf").html(json.CUR_DAY_AVE_JF);
				$("#cur_day_jf").html(json.CUR_DAY_JF);
				/* $("#cur_day_fzjf").html(json.FZ_OF_CUR_DAY_JF);
				$("#cur_day_cljf").html(json.CL_OF_CUR_DAY_JF); */
				$("#cur_day_fzjf").html(json.FZ_OF_CUR_MONTH_SUM_JF);
				$("#cur_day_cljf").html(json.CL_OF_CUR_MONTH_SUM_JF);

				$("#day_rate").html(json.JF_DAY_RATE);
				//效能
				$("#channel_fz").html(json.CUR_MONTH_FZ);
				//$("#channel_fz_all").html(json.CUR_MON_NEW_FZ);
				/*$("#yd_xz").html(json.YD_OF_CUR_MON_NEW_FZ);
				$("#kd_xz").html(json.KD_OF_CUR_MON_NEW_FZ);
				$("#itv_xz").html(json.ITV_OF_CUR_MON_NEW_FZ);*/
				$("#yd_xz").html(json.CUR_MONTH_FZ_YD);
				if(json.CUR_MONTH_FZ_YD == '0' || parseInt(json.CUR_MONTH_FZ_YD) < 100){
					$("#yd_xz").css("margin-left","15%");
				}
				$("#kd_xz").html(json.CUR_MONTH_FZ_KD);
				if(json.CUR_MONTH_FZ_KD == '0' || parseInt(json.CUR_MONTH_FZ_KD) < 100){
					$("#kd_xz").css("margin-left","15%");
				}
				$("#itv_xz").html(json.CUR_MONTH_FZ_ITV);
				if(json.CUR_MONTH_FZ_ITV == '0' || parseInt(json.CUR_MONTH_FZ_ITV) < 100){
					$("#itv_xz").css("margin-left","15%");
				}
				$("#yd_xzr").html(json.CUR_DAY_FZ_YD);
				$("#kd_xzr").html(json.CUR_DAY_FZ_KD);
				$("#itv_xzr").html(json.CUR_DAY_FZ_ITV);
			}

			//getKeyKpi();//重点指标
			getNengliAnalysis(); //能力分析
			//getDetailQD();//详情
			//基础信息下面的  质态和效益
			getBaseInfo_mon();
		});
	}
	//NBS 数据绑定
	//渠道画像-效能概览
	function getBaseInfo_mon(){
		$.post(sql_url,{"eaction":"qdhx_qdgl_mon",month:'${maxMonth}',day:acct_day,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			if(json !=''&&json != null){
				//质态
				$("#fz_zt").html(json.CUR_MON_ACTIVE_RATE);
				/*$("#zt_active_rate").html(json.CUR_MON_BILLING_RATE);
				$("#zt_new_user").html(json.CUR_MON_NEW_FZ);
				$("#zt_dna_ave").html("23.55");//json.YWFZ_CUR_MONTH_KD==null?'0.00':json.);
				$("#zt_dead_rate").html(json.CUR_MON_DEAD_ZONE_USER_RATE);*/

				$("#zt_account_rate").html(json.CUR_MON_BILLING_RATE);
				$("#zt_leave_rate").html(json.CUR_MON_REMOVE_RATE);
				$("#zt_dna_ave").html(json.CUR_MON_WORTH_RATE);
				//效益
				$("#benefit_rate_all").html(json.CUR_MON_BENEFIT_RATE);
				$("#benefit_rate").html(json.CUR_MON_BENEFIT_RATE);
				$("#sr").html(json.CUR_MON_INCOME);
				$("#cb").html(json.CUR_MON_CB);
				$("#ml").html(json.CUR_MON_AMOUNT);
				//新修改
				$("#mle").html(json.CUR_MON_AMOUNT);
				$("#100income").html(json.CUR_MON_100_INCOME);
				$("#100user").html(json.CUR_MON_100_USER+"户");
			}
		});
	}
	//营销积分-渠道日积分
	function getScoreDay(){
		acct_day = $("#acct_day").datebox("getValue").replace(/-/g,'');
		$.post(sql_url,{"eaction":"qdjf_qdjfday",acct_day:acct_day,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			var jf_html = "";
			if(json !=''&&json != null){
				//日积分
				jf_html +=
				'<tr style="font-weight: bold;">                                '+
				'	<td>总积分</td>                    '+
				'	<td id="month_jf">'+json.CUR_MONTH_SUM_JF+'</td>    '+
				'	<td id="lastday_jf">'+json.CUR_MONTH_AVG+'</td>     '+
				'	<td id="curday_jf">'+json.CUR_DAY_JF+'</td>     '+
				'	<td id="curday_jfave">'+json.CUR_DAY_AVG+'</td>    '+
				'</tr>                               '+
				'<tr style="font-weight: bold;">                                '+
				'	<td>发展积分</td>                 '+
				'	<td id="month_fzjf">'+json.FZ_OF_CUR_MONTH_SUM_JF+'</td>  '+
				'	<td id="lastday_fzjf">'+json.CUR_MONTH_FZ_AVG+'</td>   '+
				'	<td id="curday_fzjf">'+json.FZ_OF_CUR_DAY_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.CUR_DAY_FZ_AVG+'</td>'+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价值积分</td>                 '+
				'	<td id="month_fzjf">'+json.JZ_FZ_CUR_MONTH_SUM_JF+'</td>  '+
				'	<td id="lastday_fzjf">'+json.CUR_MONTH_FZJZ_AVG+'</td>   '+
				'	<td id="curday_fzjf">'+json.JZ_FZ_CUR_DAY_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.CUR_DAY_FZJZ_AVG+'</td>'+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;奖励积分</td>                 '+
				'	<td id="month_fzjf">'+json.JL_FZ_CUR_MONTH_SUM_JF+'</td>  '+
				'	<td id="lastday_fzjf">'+json.CUR_MONTH_FZJL_AVG+'</td>   '+
				'	<td id="curday_fzjf">'+json.JL_FZ_CUR_DAY_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.CUR_DAY_FZJL_AVG+'</td>'+
				'</tr>                               '+
				'<tr style="font-weight: bold;">                                '+
				'	<td>存量积分</td>                 '+
				'	<td id="month_cljf">'+json.CL_OF_CUR_MONTH_SUM_JF+'</td>  '+
				'	<td id="lastday_cljf">'+json.CUR_MONTH_CL_AVG+'</td>   '+
				'	<td id="curday_cljf">'+json.CL_OF_CUR_DAY_JF+'</td>   '+
				'	<td id="curday_cljfave">'+json.CUR_DAY_CL_AVG+'</td>'+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价值积分</td>                 '+
				'	<td id="month_fzjf">'+json.JZ_CL_CUR_MONTH_SUM_JF+'</td>  '+
				'	<td id="lastday_fzjf">'+json.CUR_MONTH_CLJZ_AVG+'</td>   '+
				'	<td id="curday_fzjf">'+json.JZ_CL_CUR_DAY_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.CUR_DAY_CLJZ_AVG+'</td>'+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;奖励积分</td>                 '+
				'	<td id="month_fzjf">'+json.JL_CL_CUR_MONTH_SUM_JF+'</td>  '+
				'	<td id="lastday_fzjf">'+json.CUR_MONTH_CLJL_AVG+'</td>   '+
				'	<td id="curday_fzjf">'+json.JL_CL_CUR_DAY_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.CUR_DAY_CLJL_AVG+'</td>'+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;动作积分</td>                 '+
				'	<td id="month_fzjf">'+json.DZ_CL_CUR_MONTH_SUM_JF+'</td>  '+
				'	<td id="lastday_fzjf">'+json.CUR_MONTH_CLDZ_AVG+'</td>   '+
				'	<td id="curday_fzjf">'+json.DZ_CL_CUR_DAY_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.CUR_DAY_CLDZ_AVG+'</td>'+
				'</tr>                               ';
			}else{
				jf_html +='<tr>----暂无数据----</td>'
			}
			$("#qdjf_jfday").html(jf_html);
		});
	}
	//营销积分-渠道月积分
	function getScoreMonth(){
	  var acct_monthjf = $("#acct_month").val().replace(/-/g,'');
		$.post(sql_url,{"eaction":"qdjf_qdjfmonth",acct_month:acct_monthjf,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			var jf_html = "";
			if(json !=''&&json != null){
				//日积分
				jf_html +=
				'<tr style="font-weight: bold;">                                '+
				'	<td style="font-weight: bold;">总积分</td>                    '+
				'	<td id="month_jf">'+json.CUR_YEAR_JF+'</td>    '+
				'	<td id="curday_jf">'+json.CUR_MON_JF+'</td>     '+
				'	<td id="lastday_jf">'+json.LAST_MON_JF+'</td>     '+
				'	<td id="curday_jfave">'+json.MONTH_CZ+'</td>    '+
				'	<td id="day_rate">'+json.MONTH_HB+'</td>    '+
				'</tr>                               '+
				'<tr style="font-weight: bold;">                                '+
				'	<td style="font-weight: bold;">发展积分</td>                 '+
				'	<td id="month_fzjf">'+json.FZ_OF_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_fzjf">'+json.FZ_OF_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_fzjf">'+json.FZ_OF_LAST_MON_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.MONTH_FZ_CZ+'</td>'+
				'	<td id="day_fzrate">'+json.MONTH_FZ_HB+'</td>  '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价值积分</td>                 '+
				'	<td id="month_fzjf">'+json.JZ_FZ_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_fzjf">'+json.JZ_FZ_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_fzjf">'+json.JZ_FZ_LAST_MON_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.MONTH_FZJZ_CZ+'</td>'+
				'	<td id="day_fzrate">'+json.MONTH_FZJZ_HB+'</td>  '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;奖励积分</td>                 '+
				'	<td id="month_fzjf">'+json.JL_FZ_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_fzjf">'+json.JL_FZ_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_fzjf">'+json.JL_FZ_LAST_MON_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.MONTH_FZJL_CZ+'</td>'+
				'	<td id="day_fzrate">'+json.MONTH_FZJL_HB+'</td>  '+
				'</tr>                               '+
				'<tr style="font-weight: bold;">                                '+
				'	<td>存量积分</td>                 '+
				'	<td id="month_cljf">'+json.CL_OF_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_cljf">'+json.CL_OF_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_cljf">'+json.CL_OF_LAST_MON_JF+'</td>   '+
				'	<td id="curday_cljfave">'+json.MONTH_CL_CZ+'</td>'+
				'	<td id="day_clrate">'+json.MONTH_CL_HB+'</td>  '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价值积分</td>                 '+
				'	<td id="month_fzjf">'+json.CL_JZ_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_fzjf">'+json.CL_JZ_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_fzjf">'+json.CL_JZ_LAST_MON_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.MONTH_CLJZ_CZ+'</td>'+
				'	<td id="day_fzrate">'+json.MONTH_CLJZ_HB+'</td>  '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;奖励积分</td>                 '+
				'	<td id="month_fzjf">'+json.CL_JL_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_fzjf">'+json.CL_JL_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_fzjf">'+json.CL_JL_LAST_MON_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.MONTH_CLJL_CZ+'</td>'+
				'	<td id="day_fzrate">'+json.MONTH_CLJL_HB+'</td>  '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;动作积分</td>                 '+
				'	<td id="month_fzjf">'+json.CL_DZ_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_fzjf">'+json.CL_DZ_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_fzjf">'+json.CL_DZ_LAST_MON_JF+'</td>   '+
				'	<td id="curday_fzjfave">'+json.MONTH_CLDZ_CZ+'</td>'+
				'	<td id="day_fzrate">'+json.MONTH_CLDZ_HB+'</td>  '+
				'</tr>                               '+
				'<tr style="font-weight: bold;">                                '+
				'	<td>追溯积分</td>                 '+
				'	<td id="month_cljf">'+json.ZS_OF_CUR_YEAR_JF+'</td>  '+
				'	<td id="curday_cljf">'+json.ZS_OF_CUR_MON_JF+'</td>   '+
				'	<td id="lastday_cljf">'+json.ZS_OF_LAST_MON_JF+'</td>   '+
				'	<td id="curday_cljfave">'+json.MONTH_ZS_CZ+'</td>'+
				'	<td id="day_clrate">'+json.MONTH_ZS_HB+'</td>  '+
				'</tr>                               ';
			}else{
				jf_html +='<tr>----暂无数据----</td>'
			}
			$("#qdjf_jfmonth").html(jf_html);
		});
	}
	//发展规模-日发展规模-表格
	function getFzxnDay(){
	   var 	acct_day = $("#acct_dayfzxn").datebox("getValue").replace(/-/g,'');
		$.post(sql_url,{"eaction":"fzxn_fzxnday",acct_day:acct_day,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			var jf_html = "";
			if(json !=''&&json != null){
				//日积分
				jf_html +=
				'<tr>                                '+
				'	<td>合计</td>                    '+
				'	<td>'+json.CUR_MONTH_FZ+'</td>    '+
				//'	<td>'+json.LAST_MONTH_FZ+'</td>     '+
				//'	<td>'+json.MONTH_FZ_RATE+'</td>     '+
				'	<td>'+json.CUR_DAY_FZ+'</td>    '+
				'	<td>'+json.LASTDAY_FZ+'</td>    '+
				//'	<td>'+json.DAY_FZ_RATE+'</td>    '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>移动</td>                 '+
				'	<td>'+json.CUR_MONTH_FZ_YD+'</td>'+
				//'	<td>'+json.LAST_MONTH_FZ_YD+'</td>   '+
				//'	<td>'+json.FZ_YD_MONTH_RATE+'</td>   '+
				'	<td>'+json.CUR_DAY_FZ_YD+'</td>  '+
				'	<td>'+json.LAST_DAY_FZ_YD+'</td>  '+
				//'	<td>'+json.FZ_YD_DAY_RATE+'</td>  '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>宽带</td>                 '+
				'	<td>'+json.CUR_MONTH_FZ_KD+'</td>'+
				//'	<td>'+json.LAST_MONTH_FZ_KD+'</td>   '+
				//'	<td>'+json.FZ_KD_MONTH_RATE+'</td>   '+
				'	<td>'+json.CUR_DAY_FZ_KD+'</td>  '+
				'	<td>'+json.LAST_DAY_FZ_KD+'</td>  '+
				//'	<td>'+json.FZ_KD_DAY_RATE+'</td>  '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>电视</td>                 '+
				'	<td>'+json.CUR_MONTH_FZ_ITV+'</td>'+
				//'	<td>'+json.LAST_MONTH_FZ_ITV+'</td>   '+
				//'	<td>'+json.FZ_ITV_MONTH_RATE+'</td>   '+
				'	<td>'+json.CUR_DAY_FZ_ITV+'</td>  '+
				'	<td>'+json.LAST_DAY_FZ_ITV+'</td>  '+
				//'	<td>'+json.FZ_ITV_DAY_RATE+'</td>  '+
				'</tr>                               ';
			}else{
				jf_html +='<tr>----暂无数据----</td>'
			}
			$("#fzxn_fzxnday").html(jf_html);
		});
	}
	//发展规模-月发展规模-表格
	function getFzxnMonth(){
	   var 	acct_month = $("#acct_xnmonth").val().replace(/-/g,'');
		$.post(sql_url,{"eaction":"fzxn_fzxnmonth",acct_month:acct_month,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			var jf_html = "";
			var all_cz = parseFloat(json.CUR_MON_NEW_FZ)-parseFloat(json.LAST_MON_NEW_FZ);
			var yd_cz = parseFloat(json.YD_OF_CUR_MON_NEW_FZ)-parseFloat(json.YD_OF_LAST_MON_NEW_FZ);
			var kd_cz = parseFloat(json.KD_OF_CUR_MON_NEW_FZ)-parseFloat(json.KD_OF_LAST_MON_NEW_FZ);
			var itv_cz = parseFloat(json.ITV_OF_CUR_MON_NEW_FZ)-parseFloat(json.ITV_OF_LAST_MON_NEW_FZ);
			if(json !=''&&json != null){
				var all_cz =
				//日积分
				jf_html +=
				'<tr>                                '+
				'	<td>合计</td>                    '+
				'	<td>'+json.ALL_OF_CUR_YEAR_NEW_FZ+'</td>    '+
				'	<td>'+json.CUR_MON_NEW_FZ+'</td>    '+
				'	<td>'+json.LAST_MON_NEW_FZ+'</td>     '+
				'	<td>'+all_cz+'</td>     '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>移动</td>                 '+
				'	<td>'+json.YD_OF_CUR_YEAR_NEW_FZ+'</td>'+
				'	<td>'+json.YD_OF_CUR_MON_NEW_FZ+'</td>'+
				'	<td>'+json.YD_OF_LAST_MON_NEW_FZ+'</td>   '+
				'	<td>'+yd_cz+'</td>   '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>宽带</td>                 '+
				'	<td>'+json.KD_OF_CUR_YEAR_NEW_FZ+'</td>'+
				'	<td>'+json.KD_OF_CUR_MON_NEW_FZ+'</td>'+
				'	<td>'+json.KD_OF_LAST_MON_NEW_FZ+'</td>   '+
				'	<td>'+kd_cz+'</td>   '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>电视</td>                 '+
				'	<td>'+json.ITV_OF_CUR_YEAR_NEW_FZ+'</td>'+
				'	<td>'+json.ITV_OF_CUR_MON_NEW_FZ+'</td>'+
				'	<td>'+json.ITV_OF_LAST_MON_NEW_FZ+'</td>   '+
				'	<td>'+itv_cz+'</td>   '+
				'</tr>                               ';
			}else{
				jf_html +='<tr>----暂无数据----</td>'
			}
			$("#fzxn_fzxnmonth").html(jf_html);
		});
	}
	//发展质态-月发展质态-表格
	function getFzztMonth(){
	   var 	acct_month = $("#acct_monthzt").val().replace(/-/g,'');
		$.post(sql_url,{"eaction":"fzzt_fzztmonth",acct_month:acct_month,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			var jf_html = "";
			if(json !=''&&json != null){
				var active_cz = ""+(parseFloat(json.CUR_MON_ACTIVE_RATE.replace(/%/,''))-parseFloat(json.LAST_MON_ACTIVE_RATE.replace(/%/,''))).toFixed(2)+"%",
					billing_cz = ""+(parseFloat(json.CUR_MON_BILLING_RATE.replace(/%/,''))-parseFloat(json.LAST_MON_BILLING_RATE.replace(/%/,''))).toFixed(2)+"%",
					yd_leave_cz = ""+(parseFloat(json.CUR_MON_REMOVE_RATE.replace(/%/,''))-parseFloat(json.LAST_MON_REMOVE_RATE.replace(/%/,''))).toFixed(2)+"%",
					kd_active_cz = ""+(parseFloat(json.KD_ACTIVE_CUR_MON.replace(/%/,''))-parseFloat(json.KD_ACTIVE_LAST_MON.replace(/%/,''))).toFixed(2)+"%",
					kd_leave_cz = ""+(parseFloat(json.CUR_MON_KD_LEAVE_RATE.replace(/%/,''))-parseFloat(json.LAST_MON_KD_LEAVE_RATE.replace(/%/,''))).toFixed(2)+"%";
				//日积分
				jf_html +=
				'<tr>                                '+
				'	<td>移动新增活跃率</td>                    '+
				'	<td>'+json.CUR_MON_ACTIVE_RATE+'</td>    '+
				'	<td>'+json.LAST_MON_ACTIVE_RATE+'</td>     '+
				'	<td>'+active_cz+'</td>     '+
				//'	<td>'+json.CUR_MON_ACTIVE_RATE_RATE+'</td>     '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>移动新增出账率</td>                 '+
				'	<td>'+json.CUR_MON_BILLING_RATE+'</td>'+
				'	<td>'+json.LAST_MON_BILLING_RATE+'</td>   '+
				'	<td>'+billing_cz+'</td>   '+
				//'	<td>'+json.CUR_MON_BILLING_RATE_RATE+'</td>   '+
				'</tr>                               '+
				'<tr>                                '+
				'	<td>移动新增离网率</td>                 '+
				'	<td>'+json.CUR_MON_REMOVE_RATE+'</td>'+
				'	<td>'+json.LAST_MON_REMOVE_RATE+'</td>   '+
				'	<td>'+yd_leave_cz+'</td>   '+
				//'	<td>'+json.CUR_MON_REMOVE_RATE_RATE+'</td>   '+
				'</tr>                               '+

				'<tr>                                '+
				'	<td>宽带新增活跃率</td>                 '+
				'	<td>'+json.KD_ACTIVE_CUR_MON+'</td>'+
				'	<td>'+json.KD_ACTIVE_LAST_MON+'</td>   '+
				'	<td>'+kd_active_cz+'</td>   '+
				//'	<td>'+json.CUR_MON_REMOVE_RATE_RATE+'</td>   '+
				'</tr>                               '+

				'<tr>                                '+
				'	<td>宽带新增离网率</td>                 '+
				//'	<td>'+json.CUR_MON_WORTH_RATE+'</td>'+
				//'	<td>'+json.LAST_MON_WORTH_RATE+'</td>   '+
				//'	<td>'+json.CUR_MON_WORTH_RATE_RATE+'</td>   '+
				'	<td>'+json.CUR_MON_KD_LEAVE_RATE+'</td>'+
				'	<td>'+json.LAST_MON_KD_LEAVE_RATE+'</td>'+
				'	<td>'+kd_leave_cz+'</td>'+
				//'	<td>'+json.KD_LW_RATE_RATE+'</td>   '+
				'</tr>                               ';
			}else{
				jf_html +='<tr>----暂无数据----</td>'
			}
			$("#fzzt_month").html(jf_html);
		});
	}
	//发展质态-月发展质态-表格
	function getFzztMonthDNA(){
	   var 	acct_month = $("#acct_monthdna").val().replace(/-/g,'');
		$.post(sql_url,{"eaction":"fzzt_fzztmonthdna",acct_month:acct_month,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			var jf_html = "";
			if(json !=''&&json != null){
				//日积分
				jf_html +=
					'<tr>            '+
					'	<td>本月</td>'+
					'	<td>'+json.CUR_MON_ALL_USER+'</td> '+
					'	<td>'+json.CUR_DNA_ALL_JF+'</td>  '+
					'	<td>'+json.CUR_COMP_SCORE+'</td> '+
					'	<td>'+json.CUR_PCARD_SCORE+'</td> '+
					'	<td>'+json.CUR_TER_SCORE+'</td> '+
					'	<td>'+json.CUR_CERT_SCORE+'</td> '+
					'	<td>'+json.CUR_AGREE_SCORE+'</td> '+
					'	<td>'+json.CUR_YCK_SCORE+'</td> '+
					'	<td>'+json.CUR_LEVEL_SCORE+'</td> '+
					'</tr>           '+
					'<tr>            '+
					'	<td>上月</td>'+
					'	<td>'+json.LAST_MON_ALL_USER+'</td> '+
					'	<td>'+json.LAST_DNA_ALL_JF+'</td>  '+
					'	<td>'+json.LAST_COMP_SCORE+'</td> '+
					'	<td>'+json.LAST_PCARD_SCORE+'</td> '+
					'	<td>'+json.LAST_TER_SCORE+'</td> '+
					'	<td>'+json.LAST_CERT_SCORE+'</td> '+
					'	<td>'+json.LAST_AGREE_SCORE+'</td> '+
					'	<td>'+json.LAST_YCK_SCORE+'</td> '+
					'	<td>'+json.LAST_LEVEL_SCORE+'</td> '+
					'</tr>           ';
			}else{
				jf_html +='<tr>----暂无数据----</td>'
			}
			$("#fzzt_monthdna").html(jf_html);
		});
	}

	function xn_flag(xn_score){
		if(xn_score>=80)
			return "高效能";
		else if(xn_score>=30)
			return "中效能";
		else if(xn_score>=10)
			return "中低效能";
		else
			return "低效能";
	}

	function jf_flag(jf_score){
		if(jf_score>=3000)
			return "高积分";
		else if(jf_score>=500)
			return "中积分";
		else if(jf_score>=0)
			return "低积分";
		else
			return "负积分";
	}

	function getNengliAnalysis(){
		getChannelXn();//渠道效能构成
		getChannelStandard();//渠道效能-效能指标
		//getChannelXnFzqs();//效能趋势
		getChannelJf();//营销积分构成
		getChannelJfFzqs();//积分趋势
		getChannelTread();//效能趋势
		getDayJfFzqs();//日积分趋势
		getChannelMl();//渠道毛利构成
		//getChannelMlFzqs();//毛利趋势
		getYwfz();//业务发展
		//getYwfzFzqs();//发展趋势
		//NBS Add 20190709
		//1、发展规模-日发展趋势
		xnrfzds(1);
		//2、发展效益-毛利率趋势
		//mlRateDev();
		//发展质态-趋势分析
		devAnalysis(1);
		//发展效益-成本构成、
		ml_trendxy();
		//costPie();
		//发展效益-表格数据
		fzxy_xy_analize();
	}
	function getDetailQD(){
		$.post(sql_url,{"eaction":"getDetailQDList",channel_nbr:channel_nbr},function(result){
			var qdDetail = $.parseJSON(result);
			$('#xnDetailTable').empty();
			$('#jfDetailTable').empty();
			$('#mlDetailTable').empty();
			$.each(qdDetail, function(){
				$('#xnDetailTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.XN_CUR_MONTH_SCORE.toFixed(2)+'</td><td>'+this.BJL.toFixed(2)+'</td><td>'+this.YHGML.toFixed(2)+'</td><td>'+this.YHZTL.toFixed(2)+'</td><td>'+this.QDXYL.toFixed(2)+'</td></tr>');
				$('#jfDetailTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.QDJF_CUR_MONTH.toFixed(2)+'</td><td>'+this.FZJF_KJ.toFixed(2)+'</td><td>'+this.CLJF_KJ.toFixed(2)+'</td><td>'+this.QT_JF_KJ.toFixed(2)+'</td></tr>');
				$('#mlDetailTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.QDML_CUR_MONTH.toFixed(2)+'</td><td>'+this.CB.toFixed(2)+'</td><td>'+this.SR.toFixed(2)+'</td><td>'+Number(this.BENEFIT_RATE*100).toFixed(1)+'%</td></tr>');
				$('#ywfzTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.YWFZ_CUR_MONTH_YD+'</td><td>'+this.YWFZ_CUR_MONTH_KD+'</td><td>'+this.YWFZ_CUR_MONTH_ITV+'</td></tr>');
				/*$('#xnDetailTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.XN_CUR_MONTH_SCORE+'</td><td>'+this.QD_RANKING+'</td><td>'+this.BJL+'</td><td>'+this.YHGML+'</td><td>'+this.YHZTL+'</td><td>'+this.QDXYL+'</td></tr>');
				$('#jfDetailTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.QDJF_CUR_MONTH+'</td><td>'+this.QD_RANKING+'</td><td>'+this.FZJF_KJ+'</td><td>'+this.CLJF_KJ+'</td><td>'+this.TOTLE_SR_JF+'</td><td>'+this.QT_JF_KJ+'</td></tr>');
				$('#mlDetailTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.QDML_CUR_MONTH+'</td><td>'+this.QD_RANKING+'</td><td>'+this.CB+'</td><td>'+this.SR+'</td><td>'+Number(this.BENEFIT_RATE*100).toFixed(1)+'%</td></tr>');
				$('#ywfzTable').append('<tr><td>'+this.ACCT_MONTH.substring(0,4)+'年'+this.ACCT_MONTH.substring(4,6)/1+'月'+'</td><td>'+this.YWFZ_CUR_MONTH_YD+'</td><td>'+this.YWFZ_CUR_MONTH_KD+'</td><td>'+this.YWFZ_CUR_MONTH_ITV+'</td></tr>'); */
			});
		});
	}
	function getChannelJf(){
		$('#jfTotal').text((parseFloat(channel_obj.FZJF_KJ)+parseFloat(channel_obj.CLJF_KJ)+parseFloat(channel_obj.QT_JF_KJ)).toFixed(2));
		$('#jfpmTotal').text(channel_obj.QD_RANKING);
		$('#fzjf').text(channel_obj.FZJF_KJ==null?'0.00':channel_obj.FZJF_KJ.toFixed(2));
		$('#syfzjf').text(channel_obj.FZJF_RANKING);
		$('#cljf').text(channel_obj.CLJF_KJ==null?'0.00':channel_obj.CLJF_KJ.toFixed(2));
		$('#sycljf').text(channel_obj.CLJF_RANKING);
		//$('#srjf').text(channel_obj.TOTLE_SR_JF==null?'0.00':channel_obj.TOTLE_SR_JF.toFixed(2));
		//$('#srpm').text(channel_obj.TOTLE_SR_RANKING);
		$('#qtjf').text(channel_obj.QT_JF_KJ==null?'0.00':channel_obj.QT_JF_KJ.toFixed(2));
		$('#syqtjf').text(channel_obj.QT_JF_RANKING);
	}
	function getChannelMl(){
		$('#byml').text(filterNull(channel_obj.QDML_CUR_MONTH).toFixed(2));
		$('#syml').text(filterNull(channel_obj.QDML_LAST_MONTH).toFixed(2));
		$('#bysr').text(filterNull(channel_obj.SR).toFixed(2));
		$('#sysr').text(filterNull(channel_obj.LAST_MONTH_SR).toFixed(2));
		$('#bycb').text(filterNull(channel_obj.CB).toFixed(2));
		$('#sycb').text(filterNull(channel_obj.LAST_MONTH_CB).toFixed(2));
	}
	function getYwfz(){
		$('#bykd').text(channel_obj.YWFZ_CUR_MONTH_KD);
		$('#sykd').text(channel_obj.YWFZ_LAST_MONTH_KD);
		$('#drkd').text('--');//Number(channel_obj.YWFZ_CUR_MONTH_KD)-Number(channel_obj.YWFZ_LAST_MONTH_KD));
		$('#byyd').text(channel_obj.YWFZ_CUR_MONTH_YD);
		$('#syyd').text(channel_obj.YWFZ_LAST_MONTH_YD);
		$('#dryd').text('--');//Number(channel_obj.YWFZ_CUR_MONTH_YD)-Number(channel_obj.YWFZ_LAST_MONTH_YD));
		$('#byitv').text(channel_obj.YWFZ_CUR_MONTH_ITV);
		$('#syitv').text(channel_obj.YWFZ_LAST_MONTH_ITV);
		$('#dritv').text('--');//Number(channel_obj.YWFZ_CUR_MONTH_ITV)-Number(channel_obj.YWFZ_LAST_MONTH_ITV));

	}
	function getMax1(arr){
		var res = Number(arr[0]);
		$.each(arr, function (i, n) {
			if(Number(n)>res){
				res = Number(n);
			}
		});
		return res;
	}

	function filterNull(el){
		var result = el;
		if(el==null || el=='null'|| el==undefined || el==''){
			result = 0;
		}
		return result;
	}

	//效能趋势
	function getChannelTread(){
		$.post(sql_url,{"eaction":"getXnTrend","channel_nbr":channel_nbr,'acct_month':'${initMinMonth}'},function(result){
			var json= $.parseJSON(result);
			var xnqsY = [];
			var jfqsY = [];
			var mlqsY = [];
			var ydfzY = [];
			var kdfzY = [];
			var itvfzY = [];
			var timeX = [];
			$.each(json, function(i, n){
				timeX.push(n.MONTH_CODE);
				xnqsY.push(nullToEmpty(n.XN_SCORE));//效能趋势
			})

			//效能趋势
			var bar1 = echarts.init(document.getElementById('bar1'));
			var optionXNQS = {
				color: ['#21A9F5'],
				grid:{
				  bottom: '28',
				  right: '10',
				  top:'14%'
				},
				xAxis: {
					type: 'category',
					data: timeX,
					axisTick: {
							show: false},
							axisLine: {lineStyle: {color: '#666'}}
				},
				yAxis: {
					show:false,
					type: 'value',
					splitLine:{show:false},
					axisLine: {
					 lineStyle: {color:'#555'}

					}
				},

				series: [{
					data: xnqsY,
					type: 'bar',
					barWidth: '20',
					itemStyle: {
						normal: {
							label: {
								show: true,
								position: 'top' ,
								textStyle: {color:'#444444'}
							}
						}
					},
					label:{
		            	normal:{
		            		show:true,
		            		position:'top',
		            		formatter:function(obj){
								if(obj.value=='0.00')
									return "";
								return obj.value;
							},
			            		textStyle: {color:'#444444'}
			            	}
		            }
				}]
			};
			bar1.setOption(optionXNQS);
		});
	}

	function getChannelJfFzqs(){
		$.post(sql_url,{"eaction":"getTrendQDList","channel_nbr":channel_nbr,'acct_month':'${initMinMonth}'},function(result){
			var json= $.parseJSON(result);
			var xnqsY = [];
			var jfqsY = [];
			var mlqsY = [];
			var ydfzY = [];
			var kdfzY = [];
			var itvfzY = [];
			var timeX = [];
			$.each(json, function(i, n){
				timeX.push(n.MONTH_CODE);
				xnqsY.push(nullToEmpty(n.CUR_MON_NEW_FZ));//效能趋势
				jfqsY.push(nullToEmpty(n.CUR_MON_JF));//月积分趋势
				mlqsY.push(nullToEmpty(n.QDML_CUR_MONTH));//毛利趋势
				ydfzY.push(n.YD_OF_CUR_MON_NEW_FZ);//发展趋势 移动
				kdfzY.push(n.KD_OF_CUR_MON_NEW_FZ);//发展趋势 宽带
				itvfzY.push(n.ITV_OF_CUR_MON_NEW_FZ);//发展趋势 itv
			})

			//效能趋势
			/*var bar1 = echarts.init(document.getElementById('bar1'));
			var optionXNQS = {
				color: ['#21A9F5'],
				grid:{
				  bottom: '28',
				  right: '10',
				  top:'14%'
				},
				xAxis: {
					type: 'category',
					data: timeX,
					axisTick: {
							show: false},
							axisLine: {lineStyle: {color: '#666'}}
				},
				yAxis: {
					show:false,
					type: 'value',
					splitLine:{show:false},
					axisLine: {
					 lineStyle: {color:'#555'}

					}
				},

				series: [{
					data: xnqsY,
					type: 'bar',
					barWidth: '20',
					itemStyle: {
						normal: {
							label: {
								show: true,
								position: 'top' ,
								textStyle: {color:'#444444'}
							}
						}
					}
				}]
			};
			bar1.setOption(optionXNQS);
			*/
			//月积分趋势
			var line1 = echarts.init(document.getElementById('line1'));
			var option1 = {
				color: ['#2070dc'],
				grid:{
				  bottom: '28',
				  right: '10',
				  top:'14%'
				},
				xAxis: {
					type: 'category',
					data: timeX,
					axisTick: {
							show: false},
							axisLine: {lineStyle: {color: '#666'}}
				},
				yAxis: {
					show:false,
					type: 'value',
					splitLine:{show:false},
					axisLine: {
					 lineStyle: {color:'#555'}

					}
				},
				series: [{
					data: jfqsY,
					type: 'bar',
					barWidth: '30',
					itemStyle: {
						normal: {
							label: {
								show: true,
								position: 'top' ,
								textStyle: {color:'#444444'}
							}
						}
					}
				}]
			};
			line1.setOption(option1);
			//发展规模-月积分趋势
			var linexn_month = echarts.init(document.getElementById('linexnmonth'));
			var linexn_month_option = {
				color: ['#2070dc'],
				grid:{
				  bottom: '28',
				  right: '10',
				  top:'14%'
				},
				legend: {
			    	show:true,
			        //orient : 'vertical',
			        //x : 'left',
			        data:['移动','宽带','电视']
			    },
				xAxis: {
					type: 'category',
					data: timeX,
					axisTick: {
							show: false},
							axisLine: {lineStyle: {color: '#666'}}
				},
				yAxis: {
					show:false,
					type: 'value',
					splitLine:{show:false},
					axisLine: {
					 lineStyle: {color:'#555'}

					}
				},
				series: [{
					name:'移动',
					data: ydfzY,
					type: 'bar',
					barWidth: '20',
					itemStyle: {
						normal: {
							label: {
								show: true,
								position: 'top' ,
								textStyle: {color:'#444444'}
							},
							color: function (params) {
                        var colorList = ['#7a65f2']; //每根柱子的颜色
                        return colorList[params.dataIndex];
                    }
						}
					}
				},
				{
					name:'宽带',
					data: kdfzY,
					type: 'bar',
					barWidth: '20',
					itemStyle: {
						normal: {
							label: {
								show: true,
								position: 'top' ,
								textStyle: {color:'#444ddd'}
							},
							color: function (params) {
                        var colorList = ['#65d186']; //每根柱子的颜色
                        return colorList[params.dataIndex];
                    }
						}
					}
				},
				{
					name:'电视',
					data: itvfzY,
					type: 'bar',
					barWidth: '20',
					itemStyle: {
						normal: {
							label: {
								show: true,
								position: 'top' ,
								textStyle: {color:'#FF9900'}
							},
							color: function (params) {
                  var colorList = ['#FF9900']; //每根柱子的颜色
                  return colorList[params.dataIndex];
              }
						}
					}
				},]
			};
			linexn_month.setOption(linexn_month_option);

			/*毛利*/
			var bar2 = echarts.init(document.getElementById('bar2'));
			var option2 = {
				 color: ['#21A9F5'],
				grid:{
				  bottom: '28',
				  right: '10',
				  top:'14%'
				},
				xAxis: {
					type: 'category',
					data: timeX,
					axisTick: {
							show: false},
							axisLine: {lineStyle: {color: '#666'}}
				},
				yAxis: {
					show:false,
					type: 'value',
					splitLine:{show:false},
					axisLine: {
					 lineStyle: {color:'#555'}

					}
				},

				series: [{
					data: mlqsY,
					type: 'bar',
					barWidth: '20',
					itemStyle: {
						normal: {
							label: {
								show: true,
								position: 'top' ,
								textStyle: {color:'#333333'}
							}
						}
					}

				}]
			};
			bar2.setOption(option2);

			/*业务发展*/
			var bar3 = echarts.init(document.getElementById('bar3'));
			var option3 = {
				 color: ['#21A9F5','#11a871','#ff9933'],
				 grid:{
					bottom: '28',
					right: '10',
					top:'14%'
				 },
				 legend: {
					data:['移动','宽带','ITV'],
					itemWidth: 14,
					selected: {
						'移动': true,
						'宽带': false,
						'ITV': false
					},
					itemHeight: 6,
					top:'0%',
					right:'2%',
					textStyle:{
						color:'#333'
					}
				},
				xAxis: {
					type: 'category',
					data: timeX,
					axisTick: {
						show: false
					},
					axisLine: {lineStyle: {color: '#666'}}
				},
				yAxis: {
					show:false,
					type: 'value',
					splitLine:{show:false},
					axisLine: {
						lineStyle: {color:'#555'}
					}
				},
				series: [
					{
						name: "移动",
						data: ydfzY,
						type: 'bar',
						stack: "总量",
						barWidth: '20',
						itemStyle: {
							normal: {
								label: {
									show: true,
									position: 'top' ,
									textStyle: {color:'#333333'}
								}
							}
						}
					},
					{
						name: "宽带",
						data: kdfzY,
						type: 'bar',
						stack: "总量",
						barWidth: '20',
						itemStyle: {
							normal: {
								label: {
									show: true,
									position: 'top' ,
									textStyle: {color:'#333333'}
								}
							}
						}
					},
					{
						name: "ITV",
						data: itvfzY,
						type: 'bar',
						stack: "总量",
						barWidth: '20',
						itemStyle: {
							normal: {
								label: {
									show: true,
									position: 'top' ,
									textStyle: {color:'#333333'}
								}
							}
						}
					}
				]
			};
			bar3.setOption(option3);
		});

	}
	/*tab切换，获取echart宽度*/
	var w2 = $(".p_content").width()/2.2;
	$("#bar1").width(w2);
	$("#line1").width($(".p_content").width()/1.1);
	$("#line2").width($(".p_content").width());
	$("#line3").width($(".p_content").width());
	$("#line4").width($(".p_content").width());
	$("#line5").width($(".p_content").width());
	$("#line6").width($(".p_content").width()/2);
	$("#linexnmonth").width($(".p_content").width());
	$("#bar2").width(w2);
	$("#bar3").width(w2);

	/*line1.resize();
	line2.resize();
	bar2.resize();
	bar3.resize();*/

	function getDayJfFzqs(){
		var cur_month = '${initDay}'.substring(0,6);//getNowFormatDate();
		var last_month = getPreMonth(cur_month);
		var sep = "-";
		var legend_curMonth = cur_month.substring(0,4)+sep+cur_month.substring(4,6);
		var legend_lastMonth = last_month.substring(0,4)+sep+last_month.substring(4,6);
		$.post(sql_url,{"eaction":"getDayJFList","channel_nbr":channel_nbr,'acct_month':cur_month},function(resultmonth){
			$.post(sql_url,{"eaction":"getLastDayJFList","channel_nbr":channel_nbr,'last_month':last_month},function(resultMonthLast){
				var json1= $.parseJSON(resultmonth);
				var json2= $.parseJSON(resultMonthLast);
				var byjfDay = [];//本月积分
				var syjfDay = [];//上月积分
				$.each(json1, function(i, n){
					byjfDay.push(filterNull(n.CUR_DAY_JF));
				})
				$.each(json2, function(j, k){
					syjfDay.push(filterNull(k.CUR_DAY_JF));
				})
				var line2 = echarts.init(document.getElementById('line2'));
				var option4 = {
					tooltip : {
						trigger: 'axis'
					},
					grid: {
						right: '4%',
						left: '0%',
						top:'10%',
						bottom:'4%',
						containLabel: true
					},
					legend: {
						right: '6%',
						data:['本月','上月']//[legend_curMonth,legend_lastMonth]
					},
					calculable : true,
					xAxis : [
						{
							axisTick: {
								show: false
							},
							axisLine: {lineStyle: {color: '#666'}},
							type : 'category',
							boundaryGap : false,
							data : ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
						}
					],
					yAxis : {
						show:false,
						type : 'value'
					},
					series : [
						{
							name:'本月',
							type:'line',
							/*areaStyle: {//不显示区域
								normal: {
									color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
										offset: 0,
										color: 'rgba(255, 180, 0,0.5)'
									}, {
										offset: 1,
										color: 'rgba(255, 180, 0,0.2)'
									}], false)
								}
							},*/
							smooth:true,
							showSymbol: true,
							itemStyle: {
								normal: {
									color: '#ffb400'
								}
							},
							lineStyle: {
								normal: {
									width: 1.5
								}
							},
							data:byjfDay
						},
						{
							name:'上月',
							type:'line',
							/*areaStyle: {//不显示区域
								normal: {
									color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
										offset: 0,
										color: 'rgba(216, 244, 247,0.8)'
									}, {
										offset: 1,
										color: 'rgba(216, 244, 247,0.2)'
									}], false)
								}
							},*/
							smooth:true,
							showSymbol: true,
							itemStyle: {
								normal: {
									color: '#58c8da'
								}
							},
							lineStyle: {
								normal: {
									width: 1.5
								}
							},
							data:syjfDay
						}
					]
				};
				line2.setOption(option4);
			});
		});
	}
	//发展规模-日发展趋势
	var xnqs_trend = echarts.init(document.getElementById('line3'));
	function xnrfzds(yxjf_type){

	    	xnqs_trend.clear();
			var cur_month = '${initDay}'.substring(0,6);//getNowFormatDate();
			var last_month = getPreMonth(cur_month);
			var sep = "-";
			var legend_curMonth = cur_month.substring(0,4)+sep+cur_month.substring(4,6);
			var legend_lastMonth = last_month.substring(0,4)+sep+last_month.substring(4,6);
			$.post(sql_url,{"eaction":"fzxn_trendList",
							"channel_nbr":channel_nbr,
							'acct_month':cur_month},
					function(resultmonth){
				$.post(sql_url,{"eaction":"fzxn_lasttrendList",
								"channel_nbr":channel_nbr,
								'last_month':last_month},
						function(resultMonthLast){
					var json1= $.parseJSON(resultmonth);
					var json2= $.parseJSON(resultMonthLast);
					var byjfDay = [];//本月积分
					var syjfDay = [];//上月积分
					$.each(json1, function(i, n){
						if(yxjf_type == '1'){
							byjfDay.push(filterNull(n.CUR_DAY_FZ_YD));
						}
						if(yxjf_type == '2'){
							byjfDay.push(filterNull(n.CUR_DAY_FZ_KD));
						}
						if(yxjf_type == '3'){
							byjfDay.push(filterNull(n.CUR_DAY_FZ_ITV));
						}
					})
					$.each(json2, function(j, k){
						if(yxjf_type == '1'){
							syjfDay.push(filterNull(k.CUR_DAY_FZ_YD));
						}
						if(yxjf_type == '2'){
							syjfDay.push(filterNull(k.CUR_DAY_FZ_KD));
						}
						if(yxjf_type == '3'){
							syjfDay.push(filterNull(k.CUR_DAY_FZ_ITV));
						}
					})
					var xnqs_trendoption = {
						tooltip : {
							trigger: 'axis'
						},
						grid: {
							right: '4%',
							left: '0%',
							top:'3%',
							bottom:'10%',
							containLabel: true
						},
						legend: {
							show:true,
							top:'2%',
							right: '6%',
							data:['本月','上月'],//[legend_curMonth,legend_lastMonth],
							textStyle:{//图例文字的样式
					            color:'#000',
					            fontSize:13
					        }
						},
						calculable : true,
						xAxis : [
							{
								axisTick: {
									show: false
								},
								axisLine: {
									show: true,
									lineStyle: {color: '#666'}
								},
								type : 'category',
								boundaryGap : false,
								data : ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
								,axisLabel: {
		                            show: true,
		                            textStyle: {
		                                color: '#000'
		                            }
		                        }
							}
						],
						yAxis : {
							show:false,
							type : 'value'
						},
						series : [
							{
								name:'本月',
								type:'line',
								/* areaStyle: {
									normal: {
										color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
											offset: 0,
											color: 'rgba(255, 180, 0,0.5)'
										}, {
											offset: 1,
											color: 'rgba(255, 180, 0,0.2)'
										}], false)
									}
								}, */
								smooth:true,
								showSymbol: true,
								itemStyle: {
									normal: {
										color: '#ffb400'
									}
								},
								lineStyle: {
									normal: {
										width: 1.5
									}
								},
								data:byjfDay
							},
							{
								name:'上月',
								type:'line',
								/* areaStyle: {
									normal: {
										color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
											offset: 0,
											color: 'rgba(216, 244, 247,0.8)'
										}, {
											offset: 1,
											color: 'rgba(216, 244, 247,0.2)'
										}], false)
									}
								}, */
								smooth:true,
								showSymbol: true,
								itemStyle: {
									normal: {
										color: '#58c8da'
									}
								},
								lineStyle: {
									normal: {
										width: 1.5
									}
								},
								data:syjfDay
							}
						]
					};
					xnqs_trend.setOption(xnqs_trendoption);
				});
			});
		}
	//发展质态-趋势分析
	/*var line4 = echarts.init(document.getElementById('line4'));
	function devAnalysis(type){
		var cur_month = getNowFormatDate();
		var last_month = getPreMonth(cur_month);
		var sep = "-";
		var legend_curMonth = cur_month.substring(0,4)+sep+cur_month.substring(4,6);
		var legend_lastMonth = last_month.substring(0,4)+sep+last_month.substring(4,6);
		$.post(sql_url,{"eaction":"getFzztList","channel_nbr":channel_nbr,'acct_month':cur_month},function(resultmonth){
			$.post(sql_url,{"eaction":"getLastFzztList","channel_nbr":channel_nbr,'last_month':last_month},function(resultMonthLast){
				var json1= $.parseJSON(resultmonth);
				var json2= $.parseJSON(resultMonthLast);
				var byjfDay = [];//本月积分
				var syjfDay = [];//上月积分
				$.each(json1, function(i, value){
					//byjfDay.push(filterNull(n.CUR_DAY_JF));
					if(type == 1){
						byjfDay.push(value.CUR_MON_ACTIVE_RATE);
	        		}
	        		if(type == 2){
	        			byjfDay.push(value.CUR_MON_BILLING_RATE);
	        		}
	        		if(type == 3){
	        			byjfDay.push(value.CUR_MON_REMOVE_RATE);
	        		}
	        		if(type == 4){
	        			byjfDay.push(value.CUR_MON_DNA_RATE);
	        		}
				})
				$.each(json2, function(j, values){
					if(type == 1){
						syjfDay.push(values.CUR_MON_ACTIVE_RATE);
	        		}
	        		if(type == 2){
	        			syjfDay.push(values.CUR_MON_BILLING_RATE);
	        		}
	        		if(type == 3){
	        			syjfDay.push(values.CUR_MON_REMOVE_RATE);
	        		}
	        		if(type == 4){
	        			syjfDay.push(values.CUR_MON_DNA_RATE);
	        		}
				})
				var option4 = {
					tooltip : {
						trigger: 'axis'
					},
					grid: {
						right: '4%',
						left: '0%',
						top:'10%',
						bottom:'4%',
						containLabel: true
					},
					legend: {
						right: '6%',
						data:[legend_curMonth,legend_lastMonth]
					},
					calculable : true,
					xAxis : [
						{
							axisTick: {
								show: false
							},
							axisLine: {lineStyle: {color: '#666'}},
							type : 'category',
							boundaryGap : false,
							data : ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
						}
					],
					yAxis : {
						show:false,
						type : 'value'
					},
					series : [
						{
							name:legend_curMonth,
							type:'bar',
							areaStyle: {
								normal: {
									color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
										offset: 0,
										color: 'rgba(255, 180, 0,0.5)'
									}, {
										offset: 1,
										color: 'rgba(255, 180, 0,0.2)'
									}], false)
								}
							},
							smooth:true,
							showSymbol: false,
							itemStyle: {
								normal: {
									color: '#ffb400'
								}
							},
							lineStyle: {
								normal: {
									width: 1.5
								}
							},
							data:byjfDay
						},
						{
							name:legend_lastMonth,
							type:'bar',
							areaStyle: {
								normal: {
									color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
										offset: 0,
										color: 'rgba(216, 244, 247,0.8)'
									}, {
										offset: 1,
										color: 'rgba(216, 244, 247,0.2)'
									}], false)
								}
							},
							smooth:true,
							showSymbol: false,
							itemStyle: {
								normal: {
									color: '#58c8da'
								}
							},
							lineStyle: {
								normal: {
									width: 1.5
								}
							},
							data:syjfDay
						}
					]
				};
				line4.setOption(option4);
			});
		});
	}*/
	/*发展质态 柱状图*/
	var c_fzzt_bar = echarts.init(document.getElementById('line4'));
	var acct_minmonth = '${initMinMonth}';
    function devAnalysis(type){
    	//发展质态 柱状图
        $.post(sql_url,
			{
				"eaction"   : "ml_trend",
				"channel_nbr":channel_nbr,
				'acct_month': acct_minmonth
			},
  		function(obj){
        	var data = $.parseJSON(obj);
        	var xMonth = [],
        		yData = [];
	    	 //为空判断
	        if(data != '' && data != null ){
	        	$.each(data, function (index, value) {
	        		xMonth.push(value.MONTH_CODE);
	        		if(type == 1){
								yData.push(value.CUR_MON_ACTIVE_RATE);
	        		}
	        		if(type == 2){
	        			yData.push(value.CUR_MON_BILLING_RATE);
	        		}
	        		if(type == 3){
	        			yData.push(value.CUR_MON_REMOVE_RATE);
	        		}
	        		if(type == 4){
	        			yData.push(value.CUR_MON_KD_LEAVE_RATE);
	        			//yData.push('0.00');
	        		}
	        	});
	        }else{
	        	xMonth.push(acct_month);
						yData.push('0.00');
	        }
        fzzt_trendBar(xMonth,yData,type);
			});
    }
	function fzzt_trendBar(xMonth,yData,type){
		c_fzzt_bar.clear();
		var option = {
			color: ['#21A9F5'],
			grid: {
				right: '4%',
				left: '0%',
				top:'10%',
				bottom:'4%',
				containLabel: true
			},
			xAxis: {
				type: 'category',
				data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
				axisTick: {
					show: false},
				axisLine: {lineStyle: {color: '#000'}},
				axisLabel: {textStyle: {fontSize:12}}
			},
			yAxis: {
				show:false,
				type: 'value',
				splitLine:{show:false},
				axisLine: {
					lineStyle: {color:'#555'}
				}
			},

			series: [{
				data: yData,//[820, 932, 901, 820, 932, 932],
				type: 'bar',
				barWidth: '22',
				itemStyle: {
					normal: {
						label: {
							show: true,
							position: 'top' ,
							formatter:function(obj){
								if(obj.value==0){
									if(obj.name <= '${maxMonth}')
											return "0.0%";
										else
											return "";
								}
								return obj.value+"%";
							},
							textStyle: {color:'#000',fontSize: '13'}
						}
					}
				}
			}]
		};
		c_fzzt_bar.setOption(option);
	}
	function doQuery(){

	}
	//发展效益---------
	//发展效益 毛利趋势柱状图
	function ml_trendxy(){
        $.post(sql_url,
			{
				"eaction"   : "mlqs_trend",
				"channel_nbr":channel_nbr,
				'acct_month': acct_minmonth
			},
    		function(obj){
	        	var data = $.parseJSON(obj);
	        	var xMonth = [],
	        		yData = [];
		    	 //为空判断
		        if(data != '' && data != null ){
		        	$.each(data, function (index,value) {
		        		xMonth.push(value.MONTH_CODE);
						yData.push(value.CUR_MON_BENEFIT_RATE);
		        	});
		        }else{
		        	xMonth.push(acct_month);
					yData.push('0.00');
		        }

	        ml_trendBar(xMonth,yData);
		});
	}

	function fzxy_xy_analize(){
		var acct_xymonth = $("#acct_monthxy").val().replace(/-/g,'');
		//发展效益-效益分析
	      $.post(sql_url,
				{
					"eaction"   : "qdxy_analyze_data",
					"channel_nbr":channel_nbr,
					'acct_month': acct_xymonth
				 },
				function(obj){
					var data = $.parseJSON(obj);
					 //为空判断
					if(data != '' && data != null ){
							//效益分析
							$("#ml_rate").html(data.CUR_MON_BENEFIT_RATE);
							$("#last_ml_rate").html(data.LAST_MON_BENEFIT_RATE);
							$("#ml_rate_rate").html(data.CUR_MON_BENEFIT_RATE_RATE);

							$("#ml_num").html(data.CUR_MON_AMOUNT);
							$("#last_ml_num").html(data.LAST_MON_AMOUNT);
							$("#ml_num_rate").html(data.CUR_MON_AMOUNT_RATE);

							$("#sr_num").html(data.CUR_MON_INCOME);
							$("#last_sr_num").html(data.LAST_MON_INCOME);
							$("#sr_num_rate").html(data.CUR_MON_INCOME_RATE);

							$("#cb_num").html(data.CUR_MON_CB);
							$("#last_cb_num").html(data.LAST_MON_CB);
							$("#cb_num_rate").html(data.CUR_MON_COST_RATE);

							$("#100new_num").html(data.CUR_MON_100_INCOME);
							$("#last_100new_num").html(data.LAST_MON_100_INCOME);
							$("#100new_num_rate").html(data.CUR_MON_100_INCOME_RATE);

							$("#100new_income_num").html(data.CUR_MON_100_USER);
							$("#last_100new_income_num").html(data.LAST_MON_100_USER);
							$("#100new_income_num_rate").html(data.CUR_MON_100_USER_RATE);
							//成本构成
							//本月
							$("#cb_total").html(data.CUR_TOTAL_YJ);
							$("#cb_jl").html(data.CUR_MONTH_ALL_JL);
							$("#cb_yj").html(data.CUR_MONTH_ALL_YJ);
							$("#cb_zc").html(data.CUR_MONTH_ALL_ZC);
							$("#cb_fc").html(data.CUR_MONTH_ALL_FC);
							//上月
							$("#last_cb_total").html(data.LAST_TOTAL_YJ);
							$("#last_cb_fc").html(data.LAST_MONTH_ALL_FC);
							$("#last_cb_jl").html(data.LAST_MONTH_ALL_JL);
							$("#last_cb_yj").html(data.LAST_MONTH_ALL_YJ);
							$("#last_cb_zc").html(data.LAST_MONTH_ALL_ZC);

							//环比
							$("#cb_total_rate").html(data.CUR_MONTH_YJ_RATE);
							$("#cb_jl_rate").html(data.CUR_MONTH_ALL_JL_RATE);
							$("#cb_yj_rate").html(data.CUR_MONTH_ALL_YJ_RATE);
							$("#cb_zc_rate").html(data.CUR_MONTH_ALL_ZC_RATE);
							$("#cb_fc_rate").html(data.CUR_MONTH_ALL_FC_RATE);

							costPie(data.CUR_MONTH_ALL_FC,data.CUR_MONTH_ALL_JL,data.CUR_MONTH_ALL_YJ,data.CUR_MONTH_ALL_ZC);

				}else{
					$("#ml_rate").html('0.00');
					$("#last_ml_rate").html('0.00');
					$("#ml_rate_rate").html('0.00');

					$("#ml_num").html('0.00');
					$("#last_ml_num").html('0.00');
					$("#ml_num_rate").html('0.00');

					$("#sr_num").html('0.00');
					$("#last_sr_num").html('0.00');
					$("#sr_num_rate").html('0.00');

					$("#cb_num").html('0.00');
					$("#last_cb_num").html('0.00');
					$("#cb_num_rate").html('0.00');

					$("#100new_num").html('0.00');
					$("#last_100new_num").html('0.00');
					$("#100new_num_rate").html('0.00');

					$("#100new_income_num").html('0.00');
					$("#last_100new_income_num").html('0.00');
					$("#100new_income_num_rate").html('0.00');
							//成本构成
							$("#cb_total").html('0.00');
							$("#cb_fc").html('0.00');
							$("#cb_jl").html('0.00');
							$("#cb_yj").html('0.00');
							$("#cb_zc").html('0.00');
							costPie(0,0,0,0);
				}
			});
	  }
	  //发展效益-成本构成pie
		var cost_pie = echarts.init(document.getElementById('line6'));
		function costPie(sr,jl,yj,zc){
			var cost_option = {
				    title : {
				    	show:false,
				        text: '某站点用户访问来源',
				        subtext: '纯属虚构',
				        x:'center'
				    },
				    tooltip : {
				        trigger: 'item',
				        formatter: "{a} <br/>{b} : {c} ({d}%)"
				    },
				    legend: {
				    	show:false,
				        orient : 'vertical',
				        x : 'left',
				        data:['收入分成','渠道奖励','基础佣金','渠道支撑']
				    },
				    calculable : true,
				    series : [
				        {
				            name:'成本构成',
				            type:'pie',
				            radius: [0, '90%'],
				            center: ['50%', '50%'],
				          label:{
				              normal:{
									show:true,
				                	position:'inner',
				                	formatter:'{b}'+'\n\r'+'{d}%'
				              }
				          },
				            data:[
				                {value:sr, name:'收入分成'},
				                {value:jl, name:'渠道奖励'},
				                {value:yj, name:'基础佣金'},
				                {value:zc, name:'渠道支撑'}
				            ]
				        }
				    ]
				};
			cost_pie.setOption(cost_option);
		}

	//发展效益- 柱状图
	var mlbar = echarts.init(document.getElementById('line5'));
	function ml_trendBar(xMonth,yData){
		var option = {
			    title: {
			    	show:false,
			        text: '毛利率趋势',
			        subtext: '单位%'
			    },
			    tooltip: {
			        trigger: 'axis',
			        show:false
			    },
			    legend: {
			    	show:false,
			        data: ['毛利趋势']
			    },
			    grid: {
					right: '5%',
					left: '0%',
					top:'10%',
					bottom:'4%',
					containLabel: true
				},
			    toolbox: {
			        show: false,
			        feature: {
			            dataView: {
			                show: true,
			                readOnly: false
			            },
			            magicType: {
			                show: true,
			                type: ['line', 'bar']
			            },
			            restore: {
			                show: true
			            },
			            saveAsImage: {
			                show: true
			            }
			        }
			    },
			    calculable: true,
			    xAxis: [{
			        type: 'category',
			        data: xMonth//['201901', '201902', '201903', '201904', '201905', '201906']
			    }],
			    yAxis: [{
			        type: 'value',
			        axisTick:{
			        	show:false
			         },
			         axisLine:{
			        	 show:false
			         },
			         splitLine: {
			                show: false
			         },
			         axisLabel:{
			        	  show:false
			          }
			    }],
			    series: [{
			            name: '毛利趋势',
			            type: 'bar',
			            barWidth: '30',
			            label:{
			            	normal:{
			            		show:true,
			            		position:'top',
			            		formatter:function(obj){

									if(obj.value==0){
										if(obj.name <= '${maxMonth}')
											return "0.0%";
										else
											return "";
									}
									return obj.value+'%';
								},
				            		textStyle: {color:'#444444'}
				            	}
			            },
			            itemStyle: {
							normal: {
								color: '#2070dc'
							}
						},
			            data: yData//[4.9, 7.0, 23.2, 25.6, 76.7, 13.6, ],
			        }
			    ]
			};
		mlbar.setOption(option);
	}
	//发展效益-成本构成pie
	/*var cost_pie = echarts.init(document.getElementById('line6'));
	function costPie(){
		var cost_option = {
			    title : {
			    	show:false,
			        text: '某站点用户访问来源',
			        subtext: '纯属虚构',
			        x:'center'
			    },
			    tooltip : {
			        trigger: 'item',
			        formatter: "{a} <br/>{b} : {c} ({d}%)"
			    },
			    legend: {
			    	show:false,
			        orient : 'vertical',
			        x : 'left',
			        data:['收入分成','渠道奖励','基础佣金','渠道支撑']
			    },
			    toolbox: {
			        show : false,
			        feature : {
			            mark : {show: true},
			            dataView : {show: true, readOnly: false},
			            magicType : {
			                show: true,
			                type: ['pie', 'funnel'],
			                option: {
			                    funnel: {
			                        x: '25%',
			                        width: '50%',
			                        funnelAlign: 'left',
			                        max: 1548
			                    }
			                }
			            },
			            restore : {show: true},
			            saveAsImage : {show: true}
			        }
			    },
			    calculable : true,
			    series : [
			        {
			            name:'访问来源',
			            type:'pie',
			            radius: [0, '90%'],
			            center: ['50%', '50%'],
			          label:{
			              normal:{
								show:true,
			                	position:'inner',
			                	formatter:'{b}:\n{c}%'
			              }
			          },
			            data:[
			                {value:335, name:'收入分成'},
			                {value:310, name:'渠道奖励'},
			                {value:234, name:'基础佣金'},
			                {value:135, name:'渠道支撑'}
			            ]
			        }
			    ]
			};
		cost_pie.setOption(cost_option);
	}*/
	//网点效能
	function getChannelXn(){

		//$.post(sql_url,{"eaction":"getBaseInfo",month:month,channel_nbr:channel_nbr},function(result){
		$.post(sql_url,{"eaction":"getChannelInfo",month:month,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			if(json !=''&&json != null){
				channel_obj = json;
				$('#xnNumber').text(channel_obj.D1);
				$('#qdbj').text(channel_obj.D2);
				$('#qdxy').text(channel_obj.D4);
				$('#yhgm').text(channel_obj.D3);
				$('#yhzt').text(channel_obj.D5);
				/*效能构成*/
				var channelXn = [channel_obj.D2, channel_obj.D3, channel_obj.D5, channel_obj.D4];
				var radar_01 = echarts.init(document.getElementById('radar_01'));
				var max = parseInt(getMax1(channelXn))+1;
				var option = {
					 //这里配置鼠标放上去显示数值
					 tooltip: {
						  position: ['50%', '30%'],
			       	      formatter: function (params, ticket, callback) {
			       	          var str = '';
				       	          str += '渠道布局: ' + channel_obj.D2 +'</br>';
				           	      str += '用户规模: ' + channel_obj.D3 +'</br>';
				           	      str += '用户质态: ' + channel_obj.D5 +'</br>';
				           	      str += '渠道效益: ' + channel_obj.D4 +'</br>';
			       	          return str;
			       	      }
			       	},
					grid:{
						left:5,
						right:-40,
						top:0,
						bottom:0
					},
				    radar: {
						center: ['50%','50%'],
						radius: '75%',
						startAngle: 90,
						splitNumber: 4, // 雷达图圈数设置
						shape: 'circle',
						splitLine: {
							show:true,
							lineStyle:{
								color:['#aaa']
							}
						},
						splitArea: {
						  	show: false,
							areaStyle: {
								color: ['rgba(114, 172, 209, 0.2)',
									'rgba(114, 172, 209, 0.4)', 'rgba(114, 172, 209, 0.6)',
									'rgba(114, 172, 209, 0.8)', 'rgba(114, 172, 209, 1)'],
								shadowColor: 'rgba(0, 0, 0, 0.3)',
								shadowBlur: 10
							}
						},
						axisLine: {
							show:false,
							lineStyle: {
								color: 'rgba(100,100,100,0.2)'
							}
						},
				        name: {
							show:true,
							padding:-15,
				            textStyle: {
				                color: '#000'
				            }
				        },
						nameGap: 5,
				        indicator: [
				           { name: '渠道布局('+channel_obj.D2+')',max: max},
				           { name: '用 \n户 \n规 \n模 \n('+channel_obj.D3+')',max: max},
				           { name: '用户质态('+channel_obj.D5+')',max: max},
				           { name: ' 渠\n 道\n 效\n 益\n('+channel_obj.D4+')',max: max}
				        ]
				        /*,
						axisLabel:{
							show:true,
							fontSize:12,
							color:'#838d9e',
							showMaxLabel:false,
							showMinLabel:false
						}*/
				    },
				    series: [{
				        name: '预算 vs 开销（Budget vs spending）',
				        type: 'radar',
				        data : [
				            {
				                value : [channel_obj.D2, channel_obj.D3, channel_obj.D5, channel_obj.D4],
				                name : '本小区',
								label: {
									normal:{
										show:false
									}
								}
				            }
				        ],
						symbol: 'circle',
						symbolSize: 8

				        /*,
						itemStyle:{
							normal:{
								borderWidth:20
							}
						}*/
				    }]
				};
				radar_01.setOption(option);
				//explain();
			}
		});
	}
	//网点效能-效能指标
	function getChannelStandard(){
		//$.post(sql_url,{"eaction":"getBaseInfo",month:month,channel_nbr:channel_nbr},function(result){
		$.post(sql_url,{"eaction":"getChannelExplain",month:month,channel_nbr:channel_nbr},function(result){
			var json= $.parseJSON(result);
			if(json !=''&&json != null){
				explain(json);
			}else{

			}
		});
	}

	/*tab切换，获取echart宽度*/
	var w1 = $(".p_content").width()/3.2;
	$("#radar_01").width(w1);
	//获取当前时间，格式YYYY-MM-DD
    function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + month; //+ strDate;
        return currentdate;
    }
	//获取上月
	function getPreMonth(date) {
        //var arr = date.split('-');
        var year = date.substring(0, 4);    //获取当前日期的年份
        var month = date.substring(4, 6);    //获取当前日期的月份

        var year2 = year;
        var month2 = parseInt(month) - 1;
        if (month2 == 0) {
            year2 = parseInt(year2) - 1;
            month2 = 12;
        }
        if (month2 < 10) {
            month2 = '0' + month2;
        }
        var t2 = year2 +""+ month2 ;
        //alert(t2);
        //$("#preMonth").val(t2);
        return t2;
    }
	//获取昨日
	function getLastDay() {
		/* var s = new Date().replace(/-/g,'');
        //var arr = date.split('-');
        /* var year = date.substring(0, 4);    //获取当前日期的年份
        var month = date.substring(4, 6);    //获取当前日期的月份
        var day = date.substring(6, 8);    //获取当前日期的月份*/

        var y = parseInt(s.substr(0,4), 10);
        var m = parseInt(s.substr(4,2), 10)-1;
        var d = parseInt(s.substr(6,2), 10);
        var dt = new Date(y, m, d-1);
        y = dt.getFullYear();
        m = dt.getMonth()+1;
        d = dt.getDate();
        m = m<10?"0"+m:m;
        d = d<10?"0"+d:d;
       var t2 = y + "" + m + "" + d;
        //alert( y + "=" + m + "=" + d);
        return t2;
    }
</script>
</body>
</html>