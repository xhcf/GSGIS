<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<!-- 获取月账期 -->
<e:q4o var="monthObj">
 select t.const_value,substr(t.const_value,0,4) || '年' || SUBSTR(t.const_value,5) || '月' acc_month_desc from easy_data.sys_const_table t where const_type='var.dss29' and  const_name='calendar.curdate'
</e:q4o>
<e:q4o var="quryDate1">
	select t.const_value ACCT_MON from easy_data.sys_const_table t where const_type='var.dss29' and const_name='calendar.mindate'
</e:q4o>
<e:set var="initMonth1">${quryDate1.ACCT_MON}</e:set>
<head>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_org_frame.css?version=1.1.1"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_bureau_index.css?version=1.2.11"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/leader_condition_init.js?version=1.5"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.colors.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/channel_leader/js/dataFormat.js?version=New Date()"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/channel_leader/js/explain.js?version=New Date()"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/sp_channel.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
    <e:script value="/resources/layer/layer.js?version=1.1"/>
    <title>效能概览</title>
	<style>
		#acc_month {
			color: #fff;position: absolute;top: 0px;right: 8px;
		}
		.tag span {display:none;}
	</style>
    <c:resources type="easyui,app" style="b"/>
</head>
<body>
<div class="portrait">
	<ul class="p_tab">
		<li class="p_show">基本信息</li>
		<li style="border-right:none">能力分析</li>
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
					<span id="yingli"></span>
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
						<P>渠道效能</P>
						<span id="channel_xn">92</span>
						<ul>
							<li>•  渠道布局：  <font id="bjl">95</font></li>
							<li>•  渠道效益：   <font id="qdxyl">90</font></li>
							<li>•  用户规模：   <font id="yhgml">88</font></li>
							<li>•  用户质态：   <font id="yhztl">80</font></li>
						</ul>
					</div>
					<div>
						<P >渠道积分</P>
						<span id="channel_jf">100,000</span>
						<ul>
							<li>•  本年累计： <font id="curyear_jf">95,000</font></li>
							<li>•  本月积分：  <font id="curmonth_jf">95,000</font></li>
							<li>•  上月积分：  <font id="lastmonth_jf">95,000</font></li>
						</ul>
					</div>
					<div>
						<P>业务发展</P>
						<span id="channel_fz">100,000</span>
						<ul>
							<li>•  移&nbsp;&nbsp;&nbsp;动：  <font id="yd_xz">95,000</font></li>
							<li>•  宽&nbsp;&nbsp;&nbsp;带：   <font id="kd_xz">95,000</font></li>
							<li>•  ITV&nbsp;&nbsp;&nbsp;&nbsp;：   <font id="itv_xz">95,000</font></li>
						</ul>
					</div>
					<div>
						<P>渠道毛利</P>
						<span id="channel_ml">100,000</span>
						<ul>
							<li>•  收&nbsp;&nbsp;&nbsp;入：  <font id="sr">95,000</font></li>
							<li>•  成&nbsp;&nbsp;&nbsp;本： <font id="cb">95,000</font></li>
							<li>•  毛利率： <font id="benefit_rate">80%</font > </li>
						</ul>
					</div>
				</div>
			</div>

		</div>
		<!--//基本信息end-->

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
							<p>渠道效能 ：<span id="xnNumber" style="font-size:14px;">80</span> </p>
							<p>渠道布局 ： <font id="qdbj">123</font></p>
							<p>渠道效益 ： <font id="qdxy">+10</font></p>
							<p>用户规模 ： <font id="yhgm">+10</font></p>
							<p>用户质态 ： <font id="yhzt">+10</font></p>
						</div>
						<div class="fl one_echart">
							<div id="radar_01" style="width: 100%;height: 220px;"></div>
						</div>
					</div>
					<div class="fr xn_com xn_two">
						<h6 class="xn_title"><i></i>效能趋势</h6>
						<div class="bar_com" >
							<div id="bar1" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
			<!--渠道积分-->
			<div class="ability">
				<h4 class="ability_title"><i class="fa fa-database"></i>渠道积分
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
									<td id="jfTotal">99,999</td>
									<td id="jfpmTotal">99,999</td>
								</tr>
								<tr>
									<td>发展积分</td>
									<td id="fzjf">99,999</td>
									<td id="fzpm">99,999</td>
								</tr>
								<tr>
									<td>存量积分</td>
									<td id="cljf">99,999</td>
									<td id="clpm">99,999</td>
								</tr>
								<!-- <tr>
									<td>收入积分</td>
									<td id="srjf">99,999</td>
									<td id="srpm">99,999</td>
								</tr> -->
								<tr>
									<td>其它积分</td>
									<td id="qtjf">99,999</td>
									<td id="qtpm">99,999</td>
								</tr>
							</tbody>
						</table>

					</div>
					<div class="fr xn_com xn_two">
						<h6 class="xn_title"><i></i>月积分趋势</h6>
						<div class="bar_com" >
							<div id="line1" style="width: 100%;height: 200px;"></div>
						</div>
					</div>
				</div>
				<div class="xn_com jf_day">
					<h6 class="xn_title"><i></i>日积分趋势</h6>
					<div class="bar_com" >
						<div id="line2" style="width: 100%;height: 200px;"></div>
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
									<td id="byyd">99,999</td>
									<td id="syyd">99,999</td>
									<td id="dryd">99,999</td>
								</tr>
								<tr>
									<td>宽带</td>
									<td id="bykd">99,999</td>
									<td id="sykd">99,999</td>
									<td id="drkd">99,999</td>
								</tr>
								<tr>
									<td>ITV</td>
									<td id="byitv">99,999</td>
									<td id="syitv">99,999</td>
									<td id="dritv">99,999</td>
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
									<td id="byml">99,999</td>
									<td id="syml">99,999</td>
								</tr>
								<tr>
									<td>收入</td>
									<td id="bysr">99,999</td>
									<td id="sysr">99,999</td>
								</tr>
								<tr>
									<td>成本</td>
									<td id="bycb">99,999</td>
									<td id="sycb">99,999</td>
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
	var sql_url = "<e:url value='pages/telecom_Index/channel_leader/channel_action/channel_portraitAction.jsp'/>";
	var channel_nbr="${param.channel_nbr}";
	//var channel_nbr="6209221000979";
	var month = "${monthObj.CONST_VALUE}";
	var channel_obj = {};
	$(function(){
		$("#acc_month").text('${monthObj.ACC_MONTH_DESC}');
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
	})
	function getBaseInfo(){
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
	}
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

				$("#channel_ml").html(json.QDML_CUR_MONTH);
				$("#sr").html(json.SR==null?'0.00':json.SR.toFixed(2));
				$("#cb").html(json.CB==null?'0.00':json.CB.toFixed(2));
				$("#benefit_rate").html(json.BENEFIT_RATE==null?'0.00':json.BENEFIT_RATE.toFixed(2)+'%');

				$("#channel_fz").html(json.YWFZ_CUR_MONTH_SUM);
				$("#yd_xz").html(json.YWFZ_CUR_MONTH_YD);
				$("#kd_xz").html(json.YWFZ_CUR_MONTH_KD);
				$("#itv_xz").html(json.YWFZ_CUR_MONTH_ITV);
			}
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
		//getChannelXnFzqs();//效能趋势
		getChannelJf();//渠道积分构成
		getChannelJfFzqs();//积分趋势
		getDayJfFzqs();//日积分趋势
		getChannelMl();//渠道毛利构成
		//getChannelMlFzqs();//毛利趋势
		getYwfz();//业务发展
		//getYwfzFzqs();//发展趋势
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
	function getChannelXn(){
		$('#xnNumber').text(filterNull(channel_obj.XN_CUR_MONTH_SCORE).toFixed(2));
		$('#qdbj').text(filterNull(channel_obj.BJL).toFixed(2));
		$('#qdxy').text(filterNull(channel_obj.QDXYL).toFixed(2));
		$('#yhgm').text(filterNull(channel_obj.YHGML).toFixed(2));
		$('#yhzt').text(filterNull(channel_obj.YHZTL).toFixed(2));
		/*效能构成*/
		var channelXn = [channel_obj.BJL, channel_obj.YHGML, channel_obj.YHZTL, channel_obj.QDXYL];
		var radar_01 = echarts.init(document.getElementById('radar_01'));
		var max = parseInt(getMax1(channelXn))+1;
		var option = {
			 //这里配置鼠标放上去显示数值
			 tooltip: {
				  position: ['50%', '30%'],
	       	      formatter: function (params, ticket, callback) {
	       	          var str = '';
		       	          str += '渠道布局: ' + channel_obj.BJL 	 +' </br> ';
		           	      str += '用户规模: ' + channel_obj.YHGML +'</br>';
		           	      str += '用户质态: ' + channel_obj.YHZTL +'</br> ';
		           	      str += '渠道效益: ' + channel_obj.QDXYL +'</br>';
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
		           { name: '渠道布局('+channel_obj.BJ_MAX+')',max: max},
		           { name: '用 \n户 \n规 \n模 \n('+channel_obj.GM_MAX+')',max: max},
		           { name: '用户质态('+channel_obj.ZT_MAX+')',max: max},
		           { name: ' 渠\n 道\n 效\n 益\n('+channel_obj.XY_MAX+')',max: max}
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
		                value : [channel_obj.BJL, channel_obj.YHGML, channel_obj.YHZTL, channel_obj.QDXYL],
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
	}

	/*tab切换，获取echart宽度*/
	var w1 = $(".p_content").width()/3.2;
	$("#radar_01").width(w1);
	//radar_01.resize();

	function filterNull(el){
		var result = el;
		if(el==null || el=='null'|| el==undefined || el==''){
			result = 0;
		}
		return result;
	}

	function getChannelJfFzqs(){
		$.post(sql_url,{"eaction":"getTrendQDList","channel_nbr":channel_nbr,'acct_month':'${initMonth1}'},function(result){
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
				xnqsY.push(nullToEmpty(n.XN_CUR_MONTH_SCORE));//效能趋势
				jfqsY.push(nullToEmpty(n.QDJF_CUR_MONTH));//月积分趋势
				mlqsY.push(nullToEmpty(n.QDML_CUR_MONTH));//毛利趋势
				ydfzY.push(nullToEmpty(n.YWFZ_CUR_MONTH_YD));//发展趋势 移动
				kdfzY.push(nullToEmpty(n.YWFZ_CUR_MONTH_KD));//发展趋势 宽带
				itvfzY.push(nullToEmpty(n.YWFZ_CUR_MONTH_ITV));//发展趋势 itv
				/*xnqsY.push(filterNull(n.XN_CUR_MONTH_SCORE).toFixed(2));
				jfqsY.push(filterNull(n.QDJF_CUR_MONTH).toFixed(2));
				mlqsY.push(filterNull(n.QDML_CUR_MONTH).toFixed(2));
				ydfzY.push(filterNull(n.YWFZ_CUR_MONTH_YD).toFixed(2));
				kdfzY.push(filterNull(n.YWFZ_CUR_MONTH_KD).toFixed(2));
				itvfzY.push(filterNull(n.YWFZ_CUR_MONTH_ITV).toFixed(2));*/
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
					}
				}]
			};
			bar1.setOption(optionXNQS);

			//月积分趋势
			var line1 = echarts.init(document.getElementById('line1'));
			var option1 = {
				color: ['#960F08'],
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
					type: 'line',
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
	$("#line1").width(w2);
	$("#line2").width($(".p_content").width());
	$("#bar2").width(w2);
	$("#bar3").width(w2);

	/*line1.resize();
	line2.resize();
	bar2.resize();
	bar3.resize();*/

	function getDayJfFzqs(){
		var cur_month = getNowFormatDate();
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
					byjfDay.push(filterNull(n.CHANNEL_JF));
				})
				$.each(json2, function(j, k){
					syjfDay.push(filterNull(k.CHANNEL_JF));
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
							type:'line',
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
							type:'line',
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
				line2.setOption(option4);
			});
		});
	}

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
	
	
</script>
</body>
</html>