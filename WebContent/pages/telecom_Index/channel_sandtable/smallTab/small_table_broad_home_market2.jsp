<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>

<e:q4o var="quryDate">
	select t.const_value ACCT_MON from ${easy_user}.sys_const_table t where const_type='var.dss29' and const_name='calendar.curdate'
</e:q4o>
<e:set var="initMonth">${quryDate.ACCT_MON}</e:set>

<e:q4o var="quryDate1">
	select t.const_value ACCT_MON from ${easy_user}.sys_const_table t where const_type='var.dss29' and const_name='calendar.mindate'
</e:q4o>
<e:set var="initMonth1">${quryDate1.ACCT_MON}</e:set>
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
    <link href='<e:url value="/pages/telecom_Index/channel_sandtable/css/sp_channel.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
	<script src='<e:url value="/pages/telecom_Index/channel_sandtable/js/dataFormat.js?version=New Date()"/>' charset="utf-8"></script>
    <title>效能概览</title>
    <e:script value="/resources/layer/layer.js"/>
    <c:resources type="easyui,app" style="b"/>
    <style type="text/css">
    .tab_label{
    	margin:8px;
    	border-bottom: 1px solid #fff;
    }
    .tab_label span{
    	font-size:17px;
    	margin: 5px;
    }
    .qd_score{
	    margin: 20px;
    }

    .qd_content{
    	padding: 5px;
    	float:left;
    	list-style: disc;
    }

    .datagrid-row-selected{
    	background:transparent;
    }

    .datagrid-cell, .datagrid-cell-group, .datagrid-header-rownumber, .datagrid-cell-rownumber{
    	color: #fff;
    }
    #sub4{width: 94%;margin:2% auto 0; height:32%;}
	#sub4 thead td{padding:8px 0}
	#sub4 td{color: #E9EAEE;font-size: 12px;border: 1px solid #014A94;padding:3px 2px; text-align: center;}
	#sub4 td:nth-child(1){border-left: none;}
	#sub4 td:nth-child(4){border-right: none;}
	#sub4 tbody td:nth-child(3){color: #FF6600;}

	.datagrid-sort-icon{cursor:pointer;}
	i {
		margin-left:10px;
	    display: inline-block;
	    width: 4px;
	    height: 14px;
	    background: #FFD000;
	    margin-right: 8px;
	    vertical-align: middle;
	}
	.jfqs_btn,.xnqs_btn,.fzztbar_btn {border:1px solid #073b8a;background:transparent;color:#fff;}
	.p_showxn{background:#073b8a;color:#fff;}
	.xn_fz{
		display: block;
	    margin-top: 5%;
	}
	.xy_fz{
		display: block;
	    margin-top: 5%;
	}
	.xy_cb{
		display: block;
	    /* margin-top: 5%; */
	}
	 .c_energy_table thead td{line-height:calc(4vh);padding:0px;}
	 #energy_trend_data td{line-height:calc(4vh);}
	 .c_fzzt_table thead td{line-height:calc(4vh);padding:0px;}
	 #fzzt_type_data td{line-height:calc(4vh);}
	 
	 /* NBS Add new EchartsMap message */
		.tips_table_wrapper1 .area_msg{
			/* display: block; */
			padding:3%;
		}
			 
    </style>
    <script type="text/javascript">
    function msg(){
    	var res = "<div class='tips_table_wrapper1'>NAME";
        res += "<div style='background:red;'>";
        res += "<div><span class='area_msg'>市场份额：<span>3300</span></span></div><br/>"+
    	"<div><span  class='area_msg'>门&nbsp;店&nbsp;数&nbsp;：<span>3300</span></span><span class='area_msg'>有销门店数：<span>3300</span></span><span class='area_msg'>单店销量：<span>3300</span></span></div><br/>"+ 
    	"<div><span class='area_msg'>高销门店：<span>3300</span></span><span class='area_msg'>低销门店：<span>3300</span></span><span class='area_msg'>零销门店：<span>3300</span></span></div><br/>"+
    	"<div><span class='area_msg'>活&nbsp;跃&nbsp;率&nbsp;：<span>3300</span></span><span class='area_msg'>出&nbsp;账&nbsp;率&nbsp;：<span>3300</span></span><span class='area_msg'>离&nbsp;网&nbsp;率&nbsp;：<span>3300</span></span></div><br/>"+ 
    	"<div><span class='area_msg'>收&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;入：<span>3300</span></span><span class='area_msg'>毛&nbsp;利&nbsp;率&nbsp;：<span>3300</span></span><span class='area_msg'>成&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本：<span>3300</span></span>";
    res += "</div></div>";
    	layer.open({
    	    type: 1,
    	    title: 'layer mobile页',
    	    shadeClose: true,
    	    shade: 0.8,
    	    area: ['380px', '90%'],
    	    content: res //iframe的url
    	}); 
    }
    </script>
</head>
<body style="width:100%;border:0px;" class="g_target">
<div style="width:100%;height:100%;">
	<div class="c_title"><h2 id="title_name">甘肃省</h2></div>
	<ul class="c_view_list">
		<!-- <i></i> -->
		<li class="current">市场份额</li>
		<li>营销积分</li>
		<li>发展效能</li>
		<li>发展质态</li>
		<li>发展效益</li>
	</ul>
	<div class="c_cont_wrap">
		<!--概览-->
		<div class="c_view">
			<div class="c_view_top clearfix" id="xn_score">
				<dl class="fl">
					<dd>90</dd>
					<dt>网点份额</dt>
				</dl>
				<!-- <ul class="fl">
					<li>• 渠道布局:<span>--</span></li>
					<li>• 用户规模:<span>--</span></li>
					<li>• 渠道效益:<span>--</span></li>
					<li>• 用户质态:<span>--</span></li>
				</ul> -->
				<div class="fl" id="market_share" style="width:75%;height:100%;/*margin-left: 27%;margin-top: calc(-48vh);*/"></div>
				<div class="fl-wordbox"  >
					<span style="left: 0;top: 58%;">核心厅店</span>
					<span style="left: 25%;top: 58%;">城市商圈</span>
					<span style="left: 50%;top: 58%;">城市社区</span>
					<span style="left: 75%;top: 58%;">农村乡镇</span>
				</div>
			</div>
			<div class="c_view_center">
				<h4 class="c_title_com"><i></i>市场份额趋势</h4>
				<div class="c_view_bar" id="c_view_bar"></div>
			</div>
			<div class="c_view_bottom">
				<h4 class="c_title_com"><i></i>区域份额</h4>
				<table class="c_view_table">
					<thead>
						<tr>
							<td>区域</td>
							<td>整体份额</td>
							<td>核心厅店</td>
							<td>城市商圈</td>
							<td>城市社区</td>
							<td>农村乡镇</td>
							<!-- <td>高于效能</td>
							<td>低于效能</td> -->
						</tr>
					</thead>
					<tbody id="store_type_data">

					</tbody>
				</table>
			</div>
		</div>
		<div class="c_view" id="c_view">
			<div class="c_view_yxjf clearfix" id="yxjf_score" style="padding-top:0px;">
			<h4 class="c_title_com"><i></i>积分分布</h4>
					<dl class="fl">
						<dd>2590.23</dd>
						<dt>日累计积分</dt>
					</dl>
					<div class="fl" id="yxjf_pie" style="width:100%;height:100%;margin-left:20%;margin-top:-27%;"></div>
				</div>
				<div class="c_view_center">
					<h4 class="c_title_com"><i></i>日积分趋势</h4>
					<button class="jfqs_btn p_showxn" onclick="yxjf_trendLine()" style="margin-left:25%;">总积分</button>
					<button class="jfqs_btn" onclick="yxjf_trendLine()">发展积分</button>
					<button class="jfqs_btn" onclick="yxjf_trendLine()">存量积分</button>
					<div class="c_view_bar" id="c_view_yxjf"></div>
				</div>
				<div class="c_view_bottom">
					<h4 class="c_title_com"><i></i>日积分分布</h4>
					<table class="c_yxjf_table">
						<thead>
							<tr>
								<td>序号</td>
								<td>分公司</td>
								<td>累计积分</td>
								<td>累计发展</td>
								<td>发展占比</td>
							</tr>
						</thead>
						<tbody id="yxjf_trend_data">
	
						</tbody>
					</table>
				</div>
		</div>
		<div class="c_view" id="c_xn">
			<div class="c_view_yxjf clearfix" id="yxjf_score" style="padding-top:0px;">
			<h4 class="c_title_com"><i></i>门店分析</h4>
					<dl class="fl" style="margin-left:5px;margin-top:2px;">
						<span class="xn_fz">门店总数：<span>1223</span></span><br/>
						<span class="xn_fz">有销门店数：<span>256</span></span><br/>
						<span class="xn_fz">单店销量数：<span>212</span></span>
					</dl>
					<div class="fl" id="energy_analysis_pie" style="width:100%;height:100%;margin-left:35%;margin-top:-26%;"></div>
				</div>
				<div class="c_view_center">
					<h4 class="c_title_com"><i></i>发展量分析</h4>
					<table class="c_energy_table">
						<thead>
							<tr>
								<td>指标</td>
								<td>日累计</td>
								<td>占比</td>
							</tr>
						</thead>
						<tbody id="energy_trend_data">
							<tr>
								<td>总销量</td>
								<td>1233</td>
								<td>50.23%</td>
							</tr>
							<tr>
								<td>移动销量</td>
								<td>123</td>
								<td>12.03%</td>
							</tr>
							<tr>
								<td>宽带销量</td>
								<td>232</td>
								<td>22.58%</td>
							</tr>
							<tr>
								<td>电视销量</td>
								<td>234</td>
								<td>25.22%</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="c_view_bottom">
					<h4 class="c_title_com"><i></i>趋势分析</h4>
					<button class="xnqs_btn p_showxn" onclick="xnqs_trendLine()" style="margin-left:calc(25vh);">移动</button>
					<button class="xnqs_btn" onclick="xnqs_trendLine()">宽带</button>
					<button class="xnqs_btn" onclick="xnqs_trendLine()">电视</button>
					<!-- <button class="xnqs_btn" onclick="xnqs_org()">橙分期</button>
					<button class="xnqs_btn" onclick="xnqs_org()">终端</button> -->
					<div class="c_view_bar" id="c_view_xnqs" style="height:32%;"></div>
				</div>
		</div>
		<div class="c_zt" id="c_zt">
				<div class="c_view_yxjf clearfix" id="fzzt_area" style="padding-top:0px;">
					<h4 class="c_title_com"><i></i>毛利率趋势</h4>
					<div style="z-index:777;">
						<button class="fzztbar_btn p_showxn" style="margin-left:20%;" onclick="fzzt_trendBar(x,data)">活跃率</button>
						<button class="fzztbar_btn" onclick="fzzt_trendBar(x,data)">出账率</button>
						<button class="fzztbar_btn" onclick="fzzt_trendBar(x,data)">离网率</button>
						<button class="fzztbar_btn" onclick="fzzt_trendBar(x,data)">DNA户均</button>
					</div>
					<!-- <div class="fl" id="fzzt_bar" style="width:100%;height:100%;margin-left:0%;margin-top:-13%;"></div> -->
					<div class="c_view_bar" id="fzzt_bar"></div>
				</div>
				<div class="c_view_center">
					<h4 class="c_title_com"><i></i>分类分析</h4>
					<table class="c_fzzt_table">
						<thead>
							<tr>
								<td>指标</td>
								<td>核心厅店</td>
								<td>城市商圈</td>
								<td>城市社区</td>
								<td>农村乡镇</td>
							</tr>
						</thead>
						<tbody id="fzzt_type_data">
							<tr>
								<td>活跃率</td>
								<td>1233</td>
								<td>50.23%</td>
								<td>50.23%</td>
								<td>50.23%</td>
							</tr>
							<tr>
								<td>出账率</td>
								<td>234</td>
								<td>25.22%</td>
								<td>25.22%</td>
								<td>25.22%</td>
							</tr>
							<tr>
								<td>离网率</td>
								<td>123</td>
								<td>12.03%</td>
								<td>12.03%</td>
								<td>12.03%</td>
							</tr>
							<tr>
								<td>DNA户均</td>
								<td>232</td>
								<td>22.58%</td>
								<td>22.58%</td>
								<td>22.58%</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="c_view_bottom">
				<h4 class="c_title_com"><i></i>区域分析</h4>
					<table class="c_fzztqy_table">
						<thead>
							<tr>
								<td>区域</td>
								<td>活跃率</td>
								<td>出账率</td>
								<td>离网率</td>
								<td>DNA户均</td>
							</tr>
						</thead>
						<tbody id="fzztqy_table_data">
						
						</tbody>
					</table>
				</div>
		</div>
		<div class="c_xy" id="c_xy">
			<div class="c_view_yxjf clearfix" id="yxjf_score" style="padding-top:0px;">
			<h4 class="c_title_com"><i></i>效益分析</h4>
					<div class="fl" style="margin-left:18%;margin-top:2px;">
						<span class="xy_fz">毛利率：<span>1223</span></span><br/>
						<span class="xy_fz">毛利：<span>256</span></span><br/>
						<span class="xy_fz">收入：<span>212</span></span>
					</div>
					<div class="fl" style="margin-left:13%;margin-top:-3px;">
						<span class="xy_fz">成&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本：<span>1223</span></span><br/>
						<span class="xy_fz">百元拉动新增收入：<span>256</span></span><br/>
						<span class="xy_fz">百元拉动新增用户：<span>212</span></span>
					</div>
					<!-- <div class="fl" id="energy_analysis_pie" style="width:100%;height:100%;margin-left:35%;margin-top:-26%;"></div> -->
				</div>
				<div class="c_view_center">
					<h4 class="c_title_com"><i></i>成本构成</h4>
					<div class="fl" id="fzxy_pie" style="width:100%;height:100%;margin-left:-20%;margin-top:-5%;"></div>
					<div class="fl" style="margin-left:60%;margin-top:-3px;position:absolute;">
						<span class="xy_cb">总&nbsp;成&nbsp;本&nbsp;：<span>1223</span></span><br/>
						<span class="xy_cb">收入分成：<span>256</span></span><br/>
						<span class="xy_cb">渠道奖励：<span>212</span></span><br/>
						<span class="xy_cb">基础佣金：<span>212</span></span><br/>
						<span class="xy_cb">渠道支撑：<span>212</span></span>
					</div>
				</div>
				<div class="c_view_bottom">
					<h4 class="c_title_com"><i></i>趋势分析</h4>
					<div class="c_view_bar" id="cbgc_bar"></div>
				</div>
		</div>
	</div>
</div>
</body>
<script>
	var sql_url = '<e:url value="/pages/telecom_Index/channel_sandtable/channel_action/channel_leaderAction.jsp" />';
	var seq_num = 0, begin_scroll = 0, page = 0, query_sort = '0', acct_month='${initMonth}',acct_month1='${initMonth1}',flag = 1;
	//如果已经没有数据, 则不再次发起请求.
  	var region_id = '${param.region_id}';

	var region_type = parent.global_current_flag;//'${param.region_type}';

	var bureau_no = parent.bureau_no;

	var table_rows_array = "";
	var table_rows_array_small_screen = [5,25,35];
	var table_rows_array_big_screen = [10,40,50];

	if(window.screen.height<=768){
		table_rows_array = table_rows_array_small_screen;
	}else{
		table_rows_array = table_rows_array_big_screen;
	}

	$(function(){
		$('.c_view_list li').click(function(){
			$(this).addClass('current').siblings().removeClass('current');
			$('.c_cont_wrap>div:eq('+$(this).index()+')').show().siblings().hide();
		})

		if(region_id == 'undefined'){
			region_id = '';
		}
	    if(bureau_no != ''){
			region_type =parent.rank_region_type;
	  	}
		/* 门店类型统计数 */
		//效能评分
        /*$.post(sql_url,
			{
				"eaction" : "xn_score",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_month
			},
    		function(obj){
	        	var data = $.parseJSON(obj);
	        	var score_html = '';
		    	 //为空判断
		        if(data != '' && data != null ){
		        	//拼接html
					score_html+='<dl class="fl">'+
							'	<dt>渠道效能</dt>'+
							'	<dd>'+data.QDXN_CUR_MONTH_SCORE+'</dd>'+
							'</dl>'+
							'<ul class="fl">'+
							'	<li>• 渠道布局：<span>'+data.BJL+'</span></li>'+
							'	<li>• 用户规模：<span>'+data.YHGML+'</span></li>'+
							'	<li>• 渠道效益：<span>'+data.QDXYL+'</span></li>'+
							'	<li>• 用户质态：<span>'+data.YHZTL+'</span></li>'+
							//'	<li>• 上月得分：<span>'+data.QDXN_LAST_MONTH_SCORE+'</span></li>'+
							//'	<li>• 差&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;值：<span>'+data.CZ+'</span></li>'+
							'</ul>';
				}else{
					 score_html+='<dl class="fl">'+
						'	<dt>渠道效能</dt>'+
						'	<dd>0</dd>'+
						'</dl>'+
						'<ul class="fl">'+
						'	<li>• 渠道布局:<span>0.00</span></li>'+
						'	<li>• 用户规模:<span>0.00</span></li>'+
						'	<li>• 渠道效益:<span>0.00</span></li>'+
						'	<li>• 用户质态:<span>0.00</span></li>'+
						//'	<li>• 上月得分:<span>0.00</span></li>'+
						//'	<li>• 差&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;值:<span>0.00</span></li>'+
						'</ul>';
				}
			$("#xn_score").html(score_html);
		});*/
		//效能趋势 柱状图
        $.post(sql_url,
			{
				"eaction"   : "xn_trend",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_month1
			},
    		function(obj){
	        	var data = $.parseJSON(obj);
	        	var xMonth = [],
	        		yData = [];
		    	 //为空判断
		        if(data != '' && data != null ){
		        	$.each(data, function (index, value) {
		        		xMonth.push(value.MONTH_CODE);
						yData.push(nullToEmpty(value.QDXN_CUR_MONTH_SCORE));//filterNull
		        	});
		        }else{
		        	xMonth.push(acct_month);
					yData.push('0.00');
		        }
	        xn_trendBar(xMonth,yData);
	        fzzt_trendBar(xMonth,yData);
	        cbgc_trendBar(xMonth,yData);
		});
		//门店类型统计查询
        $.post(sql_url,
			{
				"eaction"   : "share_list",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_month
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				var type_html='';
				if(data != '' && data != null ){
					$.each(data, function (index, value) {
						type_html+='<tr>'+
									'<td>'+value.LATN_NAME+'</td>    '+
									'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>    '+
									'		<td>'+value.QDXN_LAST_MONTH_SCORE+'</td>      '+
									'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>     '+
									'		<td>'+value.QDXN_LAST_MONTH_SCORE+'</td>     '+
									'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>     '+
									//'		<td>'+value.LARGE_AVG_CHANNEL_NUM+'</td>     '+
									//'		<td>'+value.LOW_AVG_CHANNEL_NUM+'</td>     '+
									'</tr> ';
				});
			}else{
				 type_html +='<tr>暂无数据!</tr>'
			}
			$("#store_type_data").html(type_html);
		});

        function toDecimal(x){
			var num = Number(x);
			num = num.toFixed(2);
			return num;
		}
		//地图右边显示排名
		var width=$(parent.parent.parent.window).width();
		var sub_width = $("#c_rank").width();
		var scoreWidth = 0;
		var area_width = 0;
		var jf_width = 0;
		var alin = '';
		//显示到渠道的时候宽度调整
		if(region_type == '3'){
			area_width = sub_width*0.35;
			scoreWidth = sub_width*0.25;
			jf_width = sub_width*0.3;
			alin = 'left';
		}else if(region_type == '2'){
			area_width = sub_width*0.35;
			scoreWidth = sub_width*0.25;
			jf_width = sub_width*0.3;
			alin = 'left';
		}else{
			area_width = sub_width*0.3;
			scoreWidth = sub_width*0.3;
			jf_width = sub_width*0.3;
			alin = 'center';
		}
		var areaDescription = '';
		if(region_type == '1'){
			areaDescription = 'AREA_DESCRIPTION';
		}else if(region_type == '2'){
			areaDescription = 'BUREAU_NAME';
		}else if(region_type == '3'){
			areaDescription = 'BRANCH_NAME';
		}
		//debugger;
		//$("#c_rank").height(window.screen.height-$(".c_title").height()-$(".c_view_list").height()-14);
		if(region_type == '1'){
			$(".c_rank").height('104%')
		}
		if(region_type == '3'){
			$("#sub4").datagrid({
				fit: true,
				url: sql_url,
				queryParams: {
					"eaction" : "xn_rank_bureau",
					"acct_month" : acct_month,
					"region_id" : region_id,
					"region_type" : region_type,
					"bureau_no" : bureau_no
				},
				pagination:false,
				pageSize: 500,//每页显示的记录条数，默认为10
				pageList: [500,1000,2000],//可以设置每页记录条数的列表
				//pageSize: [5],//table_rows_array[0],
				fitColumns:false,
				columns:[
					[
					{field:'RN',title:'序号',align:'center',halign:'center',width:sub_width*0.1,
						formatter:function(value,rowData,index){
							return index+1;
						}
					},
					{field:'CHANNEL_NAME',title:'区域',align:alin,halign:'center',width:area_width,
						formatter:function(value,rowData){
							var length_standard =10;
							if (width>=1360)length_standard=10
							if(width>=1520)length_standard=12

							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"parent.inside_channel_model('"+rowData.CHANNEL_NBR+"','"+value+"','"+region_type+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"parent.inside_channel_model('"+rowData.CHANNEL_NBR+"','"+value+"','"+region_type+"')\">"+value+"</u>";
							}
						}
					},
					{field:'CHANNEL_SCORE_NUM',title:'渠道效能',align:'center',halign:'center',width:scoreWidth,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.CHANNEL_SCORE;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1){
								return num_str;
							}
							else
								return "--";
						}
					},
					{field:'QDJF_CUR_MONTH_NUM',title:'渠道积分',align:'center',halign:'center',width:jf_width,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDJF_CUR_MONTH;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1)
								return num_str;
							else
								return "--";
						}
					}
				]],
				scrollbarSize:"8",
				onLoadSuccess:function (data) {
					$("._num").text(data.rows.length);
					if (data.rows.length == 0) {

					}
					 /*  if(region_type == '3'){
						$('#sub4').datagrid('hideColumn','CZ');
					}   */

				},onClickRow: function (index,row){
					//global_substation_sub = "";
					//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
				}
			});
		}else{
			 $("#sub4").datagrid({
				fit: true,
				url: sql_url,
				queryParams: {
					"eaction" : "xn_rank",
					"acct_month": acct_month,
					"region_id" : region_id,
					"region_type" : region_type,
					"bureau_no" : bureau_no
				},
				pagination:false,
				pageSize: 500,//每页显示的记录条数，默认为10
				pageList: [500,1000,2000],//可以设置每页记录条数的列表
				//pageSize: [5],//table_rows_array[0],
				fitColumns:false,
				columns:[
					[
					{field:'RN',title:'序号',align:'center',halign:'center',width:sub_width*0.1,
						formatter:function(value,rowData,index){
							return index+1;
						}
					},
					{field:areaDescription,title:'区域',align:alin,halign:'center',width:area_width,
						formatter:function(value,rowData){
							var length_standard =10;
							if (width>=1360)length_standard=10
							if(width>=1520)length_standard=12

							if(value.length>length_standard)
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"javascript:parent.inside_channel_model('"+rowData.LATN_ID+"','"+value+"','"+region_type+"')\">"+value.substr(0,length_standard)+"..</u>";
							else{
								if(value=='合计')
									return "<span title='"+value+"' style='text-align:center;width:100%;display:inline-block;margin-left: 5px' >"+value+"</span>";
								return "<u title='"+value+"' style='cursor: pointer;margin-left: 5px' onclick=\"javascript:parent.inside_channel_model('"+rowData.LATN_ID+"','"+value+"','"+region_type+"')\">"+value+"</u>";
							}
						}
					},
					{field:'QDXN_CUR_MONTH_SCORE_NUM',title:'渠道效能',align:'center',halign:'center',width:scoreWidth,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDXN_CUR_MONTH_SCORE;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1){
								return num_str;
							}
							else
								return "--";
						}
					},
					{field:'QDJF_CUR_MONTH_NUM',title:'渠道积分',align:'center',halign:'center',width:jf_width,sortable:true,
						formatter:function(value,rowData){
							var num_str = rowData.QDJF_CUR_MONTH;
							if(num_str!=null&&num_str!=undefined&&num_str!=-1)
								return num_str;
							else
								return "--";
						}
					}
				]],
				scrollbarSize:"8",
				onLoadSuccess:function (data) {
					$("._num").text(data.rows.length);
					if (data.rows.length == 0) {

					}
					 /* if(region_type == '3'){
						$('#sub4').datagrid('hideColumn','CZ');
					} */

				},onClickRow: function (index,row){
					//global_substation_sub = "";
					//parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
				}
			});

		}
		//parent.bureau_no = '';

		try{
			//parent.refresh_range_cnt(level_num);
			parent.show_range_cnt();
		}catch(e){
		}
		//按层级定义绑定的事件
		if(region_type==1){
			$("#title_name").text("甘肃省");
		}else if(region_type==2){
			$("#title_name").text(parent.global_position[1]);
		}else if(region_type==3){
			$("#title_name").text(parent.global_position[2]);
		}

		//滚动加载 暂不用
		/*$('.c_rank').scroll(function () {
			//alert($(this).scrollLeft());
			$('#table_head').css('margin-left', -($('.t_body').scrollLeft()));

			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();

			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - begin_scroll > 500) {
					++page;
					listScroll(true);
				}
				begin_scroll = new Date().getTime();
			}
		});*/
	});

	/*效能趋势 柱状图*/
	var c_view_bar = echarts.init(document.getElementById('c_view_bar'));
	function xn_trendBar(xMonth,yData){
		var option = {
			color: ['#00fff0'],
			grid:{
				bottom: '16%',
				right: '4%',
				top:'14%',
				left:'4%'
			},
			xAxis: {
				type: 'category',
				data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
				axisTick: {
					show: false},
				axisLine: {lineStyle: {color: '#e4e4e4'}},
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
				barWidth: '16',
				itemStyle: {
					normal: {
						label: {
							show: true,
							position: 'top' ,
							textStyle: {color:'#ffffff',fontSize: '13'}
						}
					}
				}
			}]
		};
		c_view_bar.setOption(option);
	}

    function num_formatter(value){
        var value_str = value+"";
        if(value_str.indexOf(".")==-1)
            return "<span style='color: #fa8513'>" + value + ".00%</span>";
        if(value_str.substr(value_str.indexOf(".")+1).length==1)
            return "<span style='color: #fa8513'>" + (value+"0") + "%</span>";
        else
            return "<span style='color: #fa8513'>" + value + "%</span>";
    }

    /*function query(){
        clear_data();
		listScroll(true);
    }*/
	/*function getParams(){
		return {
			"eaction": "xn_rank",
			"acct_month":acct_month,
			"region_type": region_type,
			"page": page,
			"pageSize": table_rows_array[0],
			"query_flag": 5,
			"query_sort": query_sort,
			"region_id": region_id,
			"bureau_no":bureau_no
		};
	}*/
    /*排名鼠标滚动加载数据*/
    /*function listScroll(flag) {
        listCollectScroll(flag);
    }*/
	/*function toDecimal(x){
		var num = Number(x);
		num = num.toFixed(2);
		return num;
	}*/
    //var total_num = 0;
    /*function listCollectScroll(flag) {
		var params = getParams();
        var $list = $("#sub4");

		$.post(sql_url, params, function (data) {
			data = $.parseJSON(data);
			 var newRow = "";
			 var type_html = "";
			$.each(data, function (index, value) {
				if(region_type == '1'){
					type_html+='<tr>'+
					'<td>'+value.RN+'</td>    '+
					'		<td>'+value.AREA_DESCRIPTION+'</td>    '+
					'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>      '+
					'		<td>'+value.CZ+'</td>     '+
					'</tr> ';
				}else if(region_type == '2'){
					type_html+='<tr>'+
					'<td>'+value.RN+'</td>    '+
					'		<td>'+value.BUREAU_NAME+'</td>    '+
					'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>      '+
					'		<td>'+value.CZ+'</td>     '+
					'</tr> ';
				}else if(region_type == '3'){
					type_html+='<tr>'+
					'<td>'+value.RN+'</td>    '+
					'		<td>'+value.BRANCH_NAME+'</td>    '+
					'		<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>      '+
					'</tr> ';
				}
				newRow += type_html;
			});
			$("#store_rank_data").html(newRow);
			//只有第一次加载没有数据的时候显示如下内容
			if (data.length == 0 && flag) {
				$list.empty();
				$list.append("<tr><td style='text-align:center' colspan=10 >没有查询到数据</td></tr>")
			}
		});
    }*/
    //清空数据
    /*function clear_data() {
        begin = 0, end = 0, seq_num = 0, begin_scroll = 0, page = 0,flag = '1', query_sort = '0',
        $("#sub4").empty();
        $("#download_div").hide();
    }*/
    /* NBS Add 20190715 */
    $(function(){
    	//tab切换
		$('.jfqs_btn').click(function(){
			$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
			//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
		})
    	//tab切换
		$('.xnqs_btn').click(function(){
			$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
			//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
		})
    	//tab切换
		$('.fzztbar_btn').click(function(){
			$(this).addClass('p_showxn').siblings().removeClass('p_showxn');
			//$('.p_content>div:eq('+$(this).index()+')').show().siblings().hide();
		})
    	//市场份额 圆环
    	market_rate();
    	//营销积分积分构成
    	score_comp();
    	//营销积分积分趋势
    	yxjf_trendLine();
    	//营销积分积分构成
    	yxjf_org();
    	//发展效能-效能分析
    	energy_analysis();
    	//发展效能-效能分析
    	xnqs_trendLine();
    	//发展质态-区域分析
    	fzzt_area();
    	//发展效益-饼状图
    	costPie();
    });
    //市场份额 环形图
    var market_pie = echarts.init(document.getElementById('market_share'));
    function market_rate(){
    	var labelTop = {
    		    normal : {
    		        label : {
    		            show : false,
    		            position : 'center',
    		            formatter : '{b}',
    		            textStyle: {
    		                baseline : 'bottom',
    		                color: '#fff'
    		            }
    		        },
    		        labelLine : {
    		            show : false
    		        }
    		    }
    		};
    		var labelFromatter = {
    		    normal : {
    		        label : {
    		            formatter : function (params){
    		                return 100 - params.value + '%'
    		            },
    		            textStyle: {
    		                baseline : 'middle',
    		                color: '#fff'
    		            }
    		        }
    		    },
    		}
    		var labelBottom = {
    		    normal : {
    		        color: '#fff',
    		        label : {
    		            show : true,
    		            position : 'center'
    		        },
    		        labelLine : {
    		            show : false
    		        }
    		    },
    		    emphasis: {
    		        color: 'rgba(255,255,255,1)'
    		    }
    		};
    		var radius = [23, 33];
            var colors=['#393939','#f5b031','#fad797','#59ccf7','#c3b4df'];
    		var markrt_option = {
    		    legend: {
    		    	show:false,
    		        x : 'center',
    		        y : '70%',
    		        data:[
    		            '核心厅店','城市商圈','城市社区','农村乡镇'
    		        ]
    		    },
    		    tooltip : {
    		        trigger: 'item',
    		      	show:false,
    		        formatter: "{a} <br/>{b} : {c} ({d}%)"
    		    },
                /*grid: {
                    right: '0%',
                    left: '0%',
                    top:'0%',
                    bottom:'0%',
                    containLabel: true
                },*/
    		    title : {
    		    	show:false,
    		        text: 'market_share',
    		        subtext: 'from global web index',
    		        x: 'center'
    		    },
    		    toolbox: {
    		        show : false,
    		        feature : {
    		            dataView : {show: true, readOnly: false},
    		            magicType : {
    		                show: true, 
    		                type: ['pie', 'funnel'],
    		                option: {
    		                    funnel: {
    		                        width: '20%',
    		                        height: '30%',
    		                        itemStyle : {
    		                            normal : {
    		                                label : {
    		                                    formatter : function (params){
    		                                        return 'other\n' + params.value + '%\n'
    		                                    },
    		                                    textStyle: {
    		                                        baseline : 'middle'
    		                                    }
    		                                }
    		                            },
    		                        } 
    		                    }
    		                }
    		            },
    		            restore : {show: true},
    		            saveAsImage : {show: true}
    		        }
    		    },
    		    series : [
    		        {
    		            type : 'pie',
                        color:['#00b7ff' ],
    		            center : ['12.5%', '47%'],
    		            radius : radius,
    		            x:'0%', // for funnel
    		            itemStyle : labelFromatter,
						data : [
    		                {name:'other', value:65, itemStyle : labelBottom},
    		                {name:'核心厅店', value:35,itemStyle : labelTop}
    		            ]
    		        },
    		        {
    		            type : 'pie',
    		            center : ['37.5%', '47%'],
                        color:['#fdd643'],
    		            radius : radius,
    		            x:'25%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:70, itemStyle : labelBottom},
    		                {name:'城市商圈', value:30,itemStyle : labelTop}
    		            ]
    		        },
    		        {
    		            type : 'pie',
    		            center : ['60.5%', '47%'],
                        color:['#1fe1ab'],
    		            radius : radius,
    		            x:'50%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:17, itemStyle : labelBottom},
    		                {name:'城市社区', value:83,itemStyle : labelTop}
    		            ]
    		        },
    		        {
    		            type : 'pie',
    		            center : ['84.5%', '47%'],
                        color:['#ee5091'],
    		            radius : radius,
    		            x:'75%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:11, itemStyle : labelBottom},
    		                {name:'农村乡镇', value:89,itemStyle : labelTop}
    		            ]
    		        }
    		    ]
    		};
    		market_pie.setOption(markrt_option);
    }
    //营销积分-积分构成饼状图
    var score_pie = echarts.init(document.getElementById('yxjf_pie'));
    function score_comp(){
    	var score_option = {
    		    title : {
    		    	show:false,
    		        text: '某站点用户访问来源',
    		        subtext: '纯属虚构',
    		        x:'center'
    		    },
    		    tooltip : {
    		        trigger: 'item',
    		        formatter: function(params){
    		        	var htmlStr='',a=params.seriesName,b=params.data.name,c=params.data.value;
			        	htmlStr += a +':'+ '<br/>'+b+' : '+c
			        	return '<div style="width:120px;height:120px;">'+htmlStr+'</div>';
    		        	},
    		        position:function(p){ //其中p为当前鼠标的位置
			        	return [p[0] - 40, p[1] - 40];
			        },
			        extraCssText:'width:80px;height:60px;background:#013c83;'
    		    },
    		    legend: {
    		    	show:false,
    		        orient : 'vertical',
    		        x : 'left',
    		        data:['发展','存量']
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
    		            name:'积分分布',
    		            type:'pie',
    		            radius : '75%',
                        color:['#00b7ff', '#ee5091',],
                        center: ['50%', '50%'],
    		            data:[
    		                {value:335, name:'发展'},
    		                {value:310, name:'存量'}
    		            ],
    		         	// 设置值域的标签
    		              label: {
    		                normal: {
    		                  position: 'inner',  // 设置标签位置，默认在饼状图外 可选值：'outer' ¦ 'inner（饼状图上）'
    		                  // formatter: '{a} {b} : {c}个 ({d}%)'   设置标签显示内容 ，默认显示{b}
    		                  // {a}指series.name  {b}指series.data的name
    		                  // {c}指series.data的value  {d}%指这一部分占总数的百分比 '\n\r'的意思是换行,使显示的内容更加紧凑
    		                  formatter: '{b}'+'\n\r'+'{d}%'
    		                }
    		              }
    		        }
    		    ]
    		};
    	score_pie.setOption(score_option);
    }
    
    //营销积分-日积分趋势
	var yxjf_trend = echarts.init(document.getElementById('c_view_yxjf'));
	var channel_nbr="6209221000979";
    function yxjf_trendLine(){
    	yxjf_trend.clear();
		var cur_month = getNowFormatDate();
		var last_month = getPreMonth(cur_month);
		var sep = "-";
		var legend_curMonth = cur_month.substring(0,4)+sep+cur_month.substring(4,6);
		var legend_lastMonth = last_month.substring(0,4)+sep+last_month.substring(4,6);
		$.post(sql_url,{"eaction":"yxjf_trendList","channel_nbr":channel_nbr,'acct_month':cur_month},function(resultmonth){
			$.post(sql_url,{"eaction":"yxjf_lasttrendList","channel_nbr":channel_nbr,'last_month':last_month},function(resultMonthLast){
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
				var yxjf_trendoption = {
					tooltip : {
						trigger: 'axis'
					},
					grid: {
						right: '4%',
						left: '0%',
						top:'12%',
						bottom:'14%',
						containLabel: true
					},
					legend: {
						show:true,
						top:'2%',
						right: '6%',
						data:[legend_curMonth,legend_lastMonth],
						textStyle:{//图例文字的样式
				            color:'#ccc',
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
	                                color: '#fff'
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
				yxjf_trend.setOption(yxjf_trendoption);
			});
		});
	}
     
    //日积分分布
    function yxjf_org(){
    	//日积分分布
        $.post(sql_url,
			{
				"eaction"   : "share_list",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_month
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				var type_html='';
				if(data != '' && data != null ){
					$.each(data, function (index, value) {
						type_html+='<tr>'+
										'<td>'+value.ROWNUM+'</td>    '+
										'<td>'+value.LATN_NAME+'</td>    '+
										'<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>      '+
										'<td>'+value.QDXN_LAST_MONTH_SCORE+'</td>     '+
										'<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>     '+
									'</tr> ';
				});
			}else{
				 type_html +='<tr>暂无数据!</tr>'
			}
			$("#yxjf_trend_data").html(type_html);
		});
    }
  //发展效能3个 环形图
    var energy_pie = echarts.init(document.getElementById('energy_analysis_pie'));
    function energy_analysis(){
    	var labelTop = {
    		    normal : {
    		        label : {
    		            show : true,
    		            position : 'center',
    		            formatter : '{b}',
    		            textStyle: {
    		                baseline : 'bottom',
    		                color: '#fff'
    		            }
    		        },
    		        labelLine : {
    		            show : false
    		        }
    		    }
    		};
    		var labelFromatter = {
    		    normal : {
    		        label : {
    		            formatter : function (params){
    		                return 100 - params.value + '%'
    		            },
    		            textStyle: {
    		                baseline : 'top',
    		                color: '#fff'
    		            }
    		        }
    		    },
    		}
    		var labelBottom = {
    		    normal : {
    		        color: '#fff',
    		        label : {
    		            show : true,
    		            position : 'center'
    		        },
    		        labelLine : {
    		            show : false
    		        }
    		    },
    		    emphasis: {
    		        color: 'rgba(255,255,255,1)'
    		    }
    		};


        var radius = ['35%', '50%'];
    		var energy_option = {
    		    legend: {
    		    	show:false,
    		        x : 'center',
    		        y : '70%',
    		        data:[
    		            '高销门店','低销门店','零销门店'
    		        ]
    		    },
    		    series : [
    		        {
    		            type : 'pie',
    		            center : ['10%', '47%'],
                        color:['#02fdff',],
                        radius : radius,
    		            x:'0%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:65, itemStyle : labelBottom},
    		                {name:'高销门店', value:35,itemStyle : labelTop}
    		            ]
    		        },
    		        {
    		            type : 'pie',
    		            center : ['32%', '47%'],
                        color:['#ff67a8',],
    		            radius : radius,
    		            x:'20%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:70, itemStyle : labelBottom},
    		                {name:'低销门店', value:30,itemStyle : labelTop}
    		            ]
    		        },
    		        {
    		            type : 'pie',
    		            center : ['55%', '47%'],
                        color:['#3685e6',],
    		            radius : radius,
    		            x:'40%', // for funnel
    		            itemStyle : labelFromatter,
    		            data : [
    		                {name:'other', value:17, itemStyle : labelBottom},
    		                {name:'零销门店', value:83,itemStyle : labelTop}
    		            ]
    		        }
    		    ]
    		};
    		energy_pie.setOption(energy_option);
    }
  //营销积分-日积分趋势
	var xnqs_trend = echarts.init(document.getElementById('c_view_xnqs'));
	var channel_nbr="6209221000979";
    function xnqs_trendLine(){
    	xnqs_trend.clear();
		var cur_month = getNowFormatDate();
		var last_month = getPreMonth(cur_month);
		var sep = "-";
		var legend_curMonth = cur_month.substring(0,4)+sep+cur_month.substring(4,6);
		var legend_lastMonth = last_month.substring(0,4)+sep+last_month.substring(4,6);
		$.post(sql_url,{"eaction":"yxjf_trendList","channel_nbr":channel_nbr,'acct_month':cur_month},function(resultmonth){
			$.post(sql_url,{"eaction":"yxjf_lasttrendList","channel_nbr":channel_nbr,'last_month':last_month},function(resultMonthLast){
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
						data:[legend_curMonth,legend_lastMonth],
						textStyle:{//图例文字的样式
				            color:'#ccc',
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
	                                color: '#fff'
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
				xnqs_trend.setOption(xnqs_trendoption);
			});
		});
	}
    
    /*发展质态 柱状图*/
	var c_fzzt_bar = echarts.init(document.getElementById('fzzt_bar'));
	function fzzt_trendBar(xMonth,yData){
		var option = {
			color: ['#00fff0'],
			grid:{
				bottom: '40%',
				right: '4%',
				top:'13%',
				left:'4%'
			},
			xAxis: {
				type: 'category',
				data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
				axisTick: {
					show: false},
				axisLine: {lineStyle: {color: '#e4e4e4'}},
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
				barWidth: '16',
				itemStyle: {
					normal: {
						label: {
							show: true,
							position: 'top' ,
							textStyle: {color:'#ffffff',fontSize: '13'}
						}
					}
				}
			}]
		};
		c_fzzt_bar.setOption(option);
	}
  //发展质态区域分布
    function fzzt_area(){
    	//日积分分布
        $.post(sql_url,
			{
				"eaction"   : "share_list",
				'region_id' : region_id,
				'bureau_no' : bureau_no,
				'region_type' : region_type-1,
				'acct_month': acct_month
			 },
			function(obj){
				var data = $.parseJSON(obj);
				 //为空判断
				var type_html='';
				if(data != '' && data != null ){
					$.each(data, function (index, value) {
						type_html+='<tr>'+
										'<td>'+value.LATN_NAME+'</td>    '+
										'<td>'+value.QDXN_CUR_MONTH_SCORE+'%</td>    '+
										'<td>'+value.QDXN_LAST_MONTH_SCORE+'%</td>      '+
										'<td>'+value.QDXN_LAST_MONTH_SCORE+'%</td>     '+
										'<td>'+value.QDXN_CUR_MONTH_SCORE+'</td>     '+
									'</tr> ';
				});
			}else{
				 type_html +='<tr>暂无数据!</tr>'
			}
			$("#fzztqy_table_data").html(type_html);
		});
    }
  //发展效益-成本构成pie
	var cost_pie = echarts.init(document.getElementById('fzxy_pie'));
	function costPie(){
		var cost_option = {
			    title : {
			    	show:false,
			        text: '某站点用户访问来源',
			        subtext: '纯属虚构',
			        x:'center'
			    },
            color:['#00b7ff', '#fedd63', '#1fe1ab', '#ee5091',],
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
			            radius: [0, '85%'],
			            center: ['50%', '52%'],
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
	}
	/*发展质态 柱状图*/
	var c_cbgc_bar = echarts.init(document.getElementById('cbgc_bar'));
	function cbgc_trendBar(xMonth,yData){
		var option = {
			color: ['#00fff0'],
			grid:{
				bottom: '68%',
				right: '4%',
				top:'3%',
				left:'4%'
			},
			xAxis: {
				type: 'category',
				data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
				axisTick: {
					show: false},
				axisLine: {lineStyle: {color: '#e4e4e4'}},
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
				barWidth: '16',
				itemStyle: {
					normal: {
						label: {
							show: true,
							position: 'top' ,
							textStyle: {color:'#ffffff',fontSize: '13'}
						}
					}
				}
			}]
		};
		c_cbgc_bar.setOption(option);
	}
    //工具方法
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