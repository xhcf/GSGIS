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
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_org_frame.css?version=1.1.1"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_bureau_index.css?version=1.2.11"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/leader_condition_init.js?version=1.5"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.colors.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/sp_channel.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
	<link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
	<script src='<e:url value="/pages/telecom_Index/channel_leader/js/dataFormat.js?version=New Date()"/>' charset="utf-8"></script>
    <title>效能概览</title>
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
    </style>
</head>
<body style="width:100%;border:0px;" class="g_target">
<div style="width:100%;height:100%;">
	<div class="c_title"><h2 id="title_name">甘肃省</h2></div>
	<ul class="c_view_list">
		<li class="current">概览</li>
		<li>排名</li>
	</ul>
	<div class="c_cont_wrap">
		<!--概览-->
		<div class="c_view">
			<div class="c_view_top clearfix" id="xn_score">
				<dl class="fl">
					<dt>渠道效能</dt>
					<dd>90</dd>
				</dl>
				<ul class="fl">
					<li>• 渠道布局:<span>--</span></li>
					<li>• 用户规模:<span>--</span></li>
					<li>• 渠道效益:<span>--</span></li>
					<li>• 用户质态:<span>--</span></li>
					<!-- <li>• 上月得分:<span>--</span></li>
					<li>• 差&nbsp;&nbsp;&nbsp;&nbsp;值:<span>--</span></li> -->
				</ul>
			</div>
			<div class="c_view_center">
				<h4 class="c_title_com"><i></i>效能趋势</h4>
				<div class="c_view_bar" id="c_view_bar"></div>
			</div>
			<div class="c_view_bottom">
				<h4 class="c_title_com"><i></i>门店类别</h4>
				<table class="c_view_table">
					<thead>
						<tr>
							<td>门店类型</td>
							<td>厅店数</td>
							<td>渠道效能</td>
							<td>渠道积分</td>
							<td>店均积分</td>
							<!-- <td>高于效能</td>
							<td>低于效能</td> -->
						</tr>
					</thead>
					<tbody id="store_type_data">

					</tbody>
				</table>
			</div>
		</div>
		<div class="c_rank" id="c_rank">
		<!-- <div>总记录数：<span>200</span></div> -->
			<table id="sub4" style="overflow-y: scroll;">
				<thead>
						<tr>
							<td>序号</td>
							<td>区域</td>
							<td style="cursor: pointer">渠道效能<span class='sort_icon'></span></td>
							<td>渠道积分</td>
						</tr>
					</thead>
					<tbody id="store_rank_data">

					</tbody>
			</table>
		</div>
	</div>
</div>
</body>
<script>
	var sql_url = '<e:url value="/pages/telecom_Index/channel_leader/channel_action/channel_leaderAction.jsp" />';
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
        $.post(sql_url,
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
		});
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
		});
		//门店类型统计查询
        $.post(sql_url,
			{
				"eaction"   : "type_list",
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
									'<td>'+value.CHANNEL_TYPE_NAME_QD+'</td>    '+
									'		<td>'+value.TOTALNUM+'</td>    '+
									'		<td>'+value.AVG_SCORE+'</td>      '+
									'		<td>'+value.CHANNEL_SCORE_SUM+'</td>     '+
									'		<td>'+value.AVG_CHANNEL_SCORE+'</td>     '+
									//'		<td>'+value.LARGE_AVG_CHANNEL_NUM+'</td>     '+
									//'		<td>'+value.LOW_AVG_CHANNEL_NUM+'</td>     '+
									'</tr> ';
				});
			}else{
				 type_html +='<tr>暂无数据!</tr>'
			}
			$("#store_type_data").html(type_html);
		});

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
	function xn_trendBar(xMonth,yData){
		var c_view_bar = echarts.init(document.getElementById('c_view_bar'));
		var option = {
			color: ['#21A9F5'],
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
				barWidth: '22',
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
</script>