<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="scene_list">
	select mkt_id CODE,mkt_name TEXT from ${gis_user}.tb_hdz_dic_market_info order by mkt_name
</e:q4l>
<e:q4l var="yx_list">
	select dd.segm_id CODE,dd.stand_name TEXT
	from ${gis_user}.TB_GIS_VILLAGE_ADDR4 ff,
		 sde.TB_GIS_MAP_SEGM_LATN_MON dd
	where ff.segm_id = dd.segm_id
	and ff.village_id='${param.village_id}'
	order by TEXT
</e:q4l>
<head>
	<title>营销清单</title>
	<link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" /><link href='<e:url value="/pages/telecom_Index/common/css/layer_win.css?version=1.0" />' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/pages/telecom_Index/common/js/tuomin.js?version=New Date()"/>' charset="utf-8"></script>
    <style>
        #select_tab2,#content2{
            display:none;
        }
        .yx_tab_switch{width:100%;border-bottom: 1px solid #aaa;padding-bottom:3px;padding-left:5px;margin-top:5px;}
        .yx_tab_switch span {margin-right:5px;width:10%;border-top:1px solid #aaa;border-right:1px solid #aaa;border-left:1px solid #aaa;border-radius: 5px 5px 0px 0px;display:inline-block;text-align:center;cursor:pointer;}
        #select_tab1,#select_tab2{
            width:96%;
            margin:0px auto;
        }
		span.active {background: #003299!important;color:#fff!important;}
		#yx_list_div{display:none;}
		.head_table_gray {width:100%;padding-right:17px;}
		.head_table_gray tr{
			background: #d9d9d9;
		}
		.head_table_gray tr th{
			border: 1px solid #fff;
		}
		.content_table_gray{
			width:100%;
			border-spacing: 2px;
			border-color: grey;
		}

		/*场景营销*/
		.head_table_yx1 tr th:first-child{width:5%;}
		.head_table_yx1 tr th:nth-child(2){width:20%;}
		.head_table_yx1 tr th:nth-child(3){width:15%;}
		.head_table_yx1 tr th:nth-child(4){width:15%;}
		.head_table_yx1 tr th:nth-child(5){width:15%;}
		.head_table_yx1 tr th:nth-child(6){width:15%;}
		.head_table_yx1 tr th:nth-child(7){width:15%;}

		#dispatch_info_list1 tr td:first-child{width:5%;}
		#dispatch_info_list1 tr td:nth-child(2){width:20%;text-align:center;}
		#dispatch_info_list1 tr td:nth-child(3){width:15%;}
		#dispatch_info_list1 tr td:nth-child(4){width:15%;}
		#dispatch_info_list1 tr td:nth-child(5){width:15%;}
		#dispatch_info_list1 tr td:nth-child(6){width:15%;}
		#dispatch_info_list1 tr td:nth-child(7){width:15%;}

		/*楼宇营销*/
		.head_table_yx2 tr th:first-child{width:5%;}
		.head_table_yx2 tr th:nth-child(2){width:50%;}
		.head_table_yx2 tr th:nth-child(3){width:15%;}
		.head_table_yx2 tr th:nth-child(4){width:15%;}
		.head_table_yx2 tr th:nth-child(5){width:15%;}

		#dispatch_info_list2 tr td:first-child{width:5%;}
		#dispatch_info_list2 tr td:nth-child(2){width:50%;text-align:center;}
		#dispatch_info_list2 tr td:nth-child(3){width:15%;}
		#dispatch_info_list2 tr td:nth-child(4){width:15%;}
		#dispatch_info_list2 tr td:nth-child(5){width:15%;}

		/*营销清单弹窗内容*/
		#yx_list_tab_head0 tr{height:25px;}
		#yx_list_tab_head0 tr th:first-child{width:5%;}
		#yx_list_tab_head0 tr th:nth-child(2){width:10%;}
		#yx_list_tab_head0 tr th:nth-child(3){width:15%;}
		#yx_list_tab_head0 tr th:nth-child(4){width:45%;}
		#yx_list_tab_head0 tr th:nth-child(5){width:18%}
		#yx_list_tab_head0 tr th:nth-child(6){width:7%}

		.yx_list_tab_body_div{overflow-y: scroll;height:81%;}

		#yx_list_tab_body0 tr{height:30px;}
		#yx_list_tab_body0 tr td{border:1px solid #d9d9d9;}
		#yx_list_tab_body0 tr td:first-child{width:5%;text-align:center;}
		#yx_list_tab_body0 tr td:nth-child(2){width:10%;text-align:center;}
		#yx_list_tab_body0 tr td:nth-child(3){width:15%;text-align:center;}
		#yx_list_tab_body0 tr td:nth-child(4){width:45%;}
		#yx_list_tab_body0 tr td:nth-child(5){width:18%;text-align:center;}
		#yx_list_tab_body0 tr td:nth-child(6){width:7%;text-align:center;}

		#yx_list_tab_head1 tr{height:25px;}
		#yx_list_tab_head1 tr th:first-child{width:8%;}
		#yx_list_tab_head1 tr th:nth-child(2){width:12%;}
		#yx_list_tab_head1 tr th:nth-child(3){width:20%;}
		#yx_list_tab_head1 tr th:nth-child(4){width:20%;}
		#yx_list_tab_head1 tr th:nth-child(5){width:25%}
		#yx_list_tab_head1 tr th:nth-child(6){width:15%}

		#yx_list_tab_body1 tr{height:30px;}
		#yx_list_tab_body1 tr td{border:1px solid #d9d9d9;}
		#yx_list_tab_body1 tr td:first-child{width:8%;text-align:center;}
		#yx_list_tab_body1 tr td:nth-child(2){width:12%;text-align:center;}
		#yx_list_tab_body1 tr td:nth-child(3){width:20%;text-align:center;}
		#yx_list_tab_body1 tr td:nth-child(4){width:20%;text-align:center;}
		#yx_list_tab_body1 tr td:nth-child(5){width:25%;text-align:center;}
		#yx_list_tab_body1 tr td:nth-child(6){width:15%;text-align:center;}

		.sum_div{
			height:25px;
			line-height: 25px;
			vertical-align: middle;
			padding-left:15px;
		}
		.sum_div span {color:red;}
		.link {text-decoration: underline!important;}

		.inside_data_orange {
			text-align: center!important;
		}
    </style>
</head>
<body>
    <!--营销清单----------20180412------------- 开始---------------------->
    <div class="village_new_searchbar">
        <table style="width:100%">
            <tr>
                <td>
                    <div class="count_num desk_orange_bar inside_data inside_data_orange">
                        <%--营销场景：<span id="head_scene_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        目标用户：<span id="head_target_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        执行用户：<span id="head_exec_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        成功用户：<span id="head_succ_num" style="color:#FF0000">0</span>--%>
						目标数：<span id="head_target_num" style="color:#FF0000"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						执行数：<span id="head_exec_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						执行率：<span id="head_exec_lv" style="color:#FF0000">0</span>
                    </div>
                </td>
            </tr>
        </table>
        <div class="yx_tab_switch" style="height:26px;"><span class="active">场景营销</span><span>楼宇营销</span></div>
        <table id="select_tab1">
            <tr>
				<td style="width:15%;text-align:left;">
					记录数：<span id="scene_yx_total"></span>
				</td>
                <%--<td style="width:6%;text-align:center;">场景：</td>
                <td style="width:25%;">
                    <select style="width:100%;padding-left:0px;" onchange="scene_change(1)" id="scene_select1">
                    </select>
                </td>
                <td style="width: auto;">&nbsp;</td>
                <td style="width:6%;text-align: center;">楼宇：</td>
                <td style="width:40%;">
                    <select id="yx_collect_new_build_list1" onchange="yx_load_build_info(1)"
                            style="width:100%;padding-left:0px;"></select>
                    <input type="text" id="yx_collect_new_build_name1" oninput="yx_load_build_name_list(1)"
                           style="margin-left:0;padding-left:0px;border:none;display: none;">
                    <ul id="yx_collect_new_build_name_list1" style="width:100%;">
                    </ul>
                </td>
				<td style="width:15%;text-align:center;">
					记录数：<span id="scene_yx_total"></span>
				</td>--%>
            </tr>
        </table>
        <table id="select_tab2">
            <tr>
				<td style="width:15%;text-align:left;">
					记录数：<span id="build_yx_total"></span>
				</td>
                <%--<td style="width:6%;text-align:center;">楼宇：</td>
                <td style="width:40%;">
                    <select id="yx_collect_new_build_list2" onchange="yx_load_build_info(2)"
                            style="width:100%;padding-left:0px;"></select>
                    <input type="text" id="yx_collect_new_build_name2" oninput="yx_load_build_name_list(2)"
                           style="margin-left:0;padding-left:0px;border:none;display: none;">
                    <ul id="yx_collect_new_build_name_list2" style="width:100%;">
                    </ul>
                </td>
                <td style="width: auto;">&nbsp;</td>
                <td style="width:6%;text-align:center;">场景：</td>
                <td style="width:25%;">
					<select style="width:100%;padding-left:0px;" onchange="scene_change(2)" id="scene_select2">
                    </select>
                </td>
				<td style="width:15%;text-align:center;">
					记录数：<span id="build_yx_total"></span>
				</td>--%>
            </tr>
        </table>
    </div>

    <!--场景营销标签页内容 -->
    <div id="content1" style="width:96%;margin:0px auto;">
        <div class="div_0_0">
            <div class="datagrid">
                <div class="head_table_wrapper">
                    <table class="head_table head_table_yx1">
                        <tr>
                            <th>序号</th>
                            <th>场景</th>
                            <!--<th width="90">类别</th>-->
                            <th>目标数</th>
                            <th>执行数</th>
                            <th>执行率</th>
                            <th>成功数</th>
                            <th>成功率</th>
                            <!--
                            <th width="100">派单时间</th>
                            <th width="35">操作</th>
                            -->
                        </tr>
                    </table>
                </div>
                <div class="t_table dispatch_m_tab body_table_yx1" style="margin:0px auto;">
                    <table class="content_table dispatch_detail_in" id="dispatch_info_list1" style="width:100%;">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!--场景清单清单----------20180412------------- 结束---------------------->

    <!--楼宇营销标签页内容 -->
    <div id="content2" style="width:96%;margin:0px auto;">
        <div class="div_hide div_0_0">
            <div class="datagrid">
                <div class="head_table_wrapper">
                    <table class="head_table head_table_yx2">
                        <tr>
                            <th>序号</th>
                            <th>楼宇</th>
                            <th>目标数</th>
                            <th>执行数</th>
                            <th>执行率</th>
                            <!--
                            <th width="100">派单时间</th>
                            <th width="35">操作</th>
                            -->
                        </tr>
                    </table>
                </div>
                <div class="t_table dispatch_m_tab body_table_yx2" style="margin:0px auto;">
                    <table class="content_table dispatch_detail_in" id="dispatch_info_list2" style="width:100%;">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!--楼宇清单清单----------20180412------------- 结束---------------------->

	<!-- 营销清单弹窗内容 -->
	<div id="yx_list_div">
		<div class="sum_div">记录数：<span id="yx_num"></span>&nbsp;&nbsp;&nbsp;已执行：<span id="yx_execed"></span>&nbsp;&nbsp;&nbsp;未执行：<span id="yx_unexec"></span></div>
		<div class="head_table_wrapper">
			<table id="yx_list_tab_head0" class="head_table_gray">
				<tr><th>序号</th><th>用户</th><th>号码</th><th>详细地址</th><th>场景</th><th>状态</th></tr>
			</table>
		</div>
		<div id="yx_list_tab_body_div0" class="yx_list_tab_body_div">
			<table id="yx_list_tab_body0" class="content_table_gray">

			</table>
		</div>

		<div class="head_table_wrapper">
			<table id="yx_list_tab_head1" class="head_table_gray">
				<tr><th>序号</th><th>房间号</th><th>用户</th><th>号码</th><th>营销场景</th><th>状态</th></tr>
			</table>
		</div>
		<div id="yx_list_tab_body_div1" class="yx_list_tab_body_div">
			<table id="yx_list_tab_body1" class="content_table_gray">

			</table>
		</div>
	</div>
</body>

<script type="text/javascript">
	var yx_begin_scroll = "", yx_seq_num = 0, yx_list_page = 0, yx_list_pop_page = 0;

	var yx_build_list = [];
	var yx_select_count = 0;

	//楼宇ID
	var yx_build_id = "";

	//营销场景
	var scene_id="";

	//控件序号 场景和楼宇分别有两个
    var scene_type_flg = 1;
    var yx_type_flg = 1;

	//营销清单 表格序号
	var yx_list_index = 0;

	/*-营销派单 start-*/
	var url = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action_inside.jsp'/>";
	var load_intraday_data = function (){
        var params = "";
        //clear_data();
        if(yx_type_flg==1){
            params = {
                eaction: "marketing_scene",
                page: 0,
                village_id:village_id,
                segm_code:yx_build_id,
                scene_id:scene_id
            }
        }else if(yx_type_flg==2){
            params = {
                eaction: "marketing_build",
                page: 0,
                village_id:village_id,
                segm_code:yx_build_id,
                scene_id:scene_id
            }
        }
		//var seq_num = 0;
		intradayListScroll(params);
	};
	parent.yx_load_intraday_data_view = load_intraday_data;
	parent.parent.fresh_village_yx = load_intraday_data;

	var flag = true;
	//加载表格数据-营销派单
	function intradayListScroll(params) {
		$("#scene_yx_total").text("8");
		$.post(url, params, function (data) {

            //场景营销
            if(yx_type_flg==1){
				var data1 = $.parseJSON(data);
				var $grid_list1 = $("#dispatch_info_list1");
				if(data1.length)
					flag = false;
				else{
					//if(yx_list_page==0)
					//	$("#scene_yx_total").text("0");
				}
                for (var i = 0, l = data1.length; i < l; i++) {
                    var d = data1[i];

					var newRow = "<tr>";

					if(i<l-1){
						newRow += "<td>" + (++yx_seq_num) + "</td>";
						if(i<4)
							newRow += "<td style='color:red;'>";
						else
							newRow += "<td>";
					}else{
						newRow += "<td colspan='2'>";
					}

					newRow +=
							d.SCENE_NAME  + "</td>";
							//"<td style='width:90px'>" + d.SCENE_TYPE + "</td>";

					if(i<l-1){
						newRow += "<td>";
					}else{
						newRow += "<td style='width:15%;'>";
					}

					if(d.USER_NUM>0){
						newRow += "<a class='link' href='javascript:void(0);' onclick='showYXListByScene(\""+ d.MKT_CAMPAIGN_ID +"\")'>" + d.USER_NUM + "</a></td>";
					}else
						newRow += d.USER_NUM + "</td>";

					newRow += "<td>"+ d.EXEC_NUM +"</td>";

					newRow += "<td style='color:#ee7008;'>"+ d.EXE_LV +"</td>";
					newRow += "<td>"+ d.SUCC_NUM +"</td>";
					newRow += "<td>"+ d.SUCC_LV +"</td>";

					newRow += "</tr>";

					$grid_list1.append(newRow);
                }
                if (data.length == 0 && flag) {
					$grid_list1.empty();
					$grid_list1.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                    return;
                }
            }
            //楼宇营销
            else if(yx_type_flg==2){
				var data2 = $.parseJSON(data);
				var $grid_list = $("#dispatch_info_list2");
				if(data2.length)
					flag = false;
				else{
					if(yx_list_page==0)
						$("#build_yx_total").text("0");
				}
				for (var i = 0, l = data2.length; i < l; i++) {
                    var d = data2[i];
					if(i==0 && yx_list_page==0){
						try{
							console.log(data2[1]);
							console.log(data2[1].C_NUM);
							if(data2[1].C_NUM>0){
								$("#build_yx_total").text(data2[1].C_NUM);
							}else{
								$("#build_yx_total").text(1);
							}
						}catch(e){
							$("#build_yx_total").text(0);
						}

						//$("#build_yx_total").text(d.C_NUM);
					}

                    /*var newRow = "<tr><td>" + (++yx_seq_num) + "</td>";
					newRow +=
							//"<td style='width:330px'>" + d.ADDRESS_ID  + "</td>"+
							"<td>" + d.BUILD_NAME  + "</td>";*/

					var newRow = "<tr>";

					if(yx_list_page==0 && i==0){
						newRow += "<td colspan='2' style='width:auto;'>";
					}else{
						newRow += "<td>" + (++yx_seq_num) + "</td><td>";
					}

					newRow += d.BUILD_NAME  + "</td>";

					if(yx_list_page==0 && i==0){
						newRow += "<td style='width:15%;'>";
					}else{
						newRow += "<td>";
					}

					if(d.USER_NUM>0)
						newRow += "<a class='link' href='javascript:void(0);' onclick='showYXListByBuild(\""+ d.SEGM_ID +"\")'>" + d.USER_NUM + "</a></td>";
					else
						newRow += d.USER_NUM + "</td>";

					newRow += "<td>"+ d.EXEC_NUM +"</td>";
					newRow += "<td>"+ d.EXEC_LV +"</td>";
					newRow += "</tr>";

                    $grid_list.append(newRow);
                }
                if (data2.length == 0 && flag) {
                    $grid_list.empty();
                    $grid_list.append("<tr><td style='text-align:center' colspan=5 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
                    return;
                }
            }
		});
	}

	var unusedBuildPage = 0;
	var yx_list_win_handler = "";
	//场景下的用户列表
	function showYXListByScene(scene_id_temp){
		//汇总数
		scene_id = $.trim(scene_id_temp);
		var params_sum = {"eaction":"getYXSumByScene","village_id":village_id,"scene_id":scene_id};
		$.post(url,params_sum,function(data){
			var d = $.parseJSON(data);
			if(d.length){
				var item = d[0];
				$("#yx_num").text(item.YX_NUM);
				$("#yx_execed").text(item.YX_EXECED);
				$("#yx_unexec").text(item.YX_UNEXEC);
			}else{
				$("#yx_num").text("0");
				$("#yx_execed").text("0");
				$("#yx_unexec").text("0");
			}
		});
		//列表
		params_sum.eaction = "getYXListByScene";
		unusedBuildPage = 0;
		params_sum.page = unusedBuildPage;
		var params = params_sum;
		clearYXlist();
		yx_list_scroll(0,params);
	}
	//楼宇下的用户列表
	function showYXListByBuild(build_id_temp){
		yx_build_id = $.trim(build_id_temp);
		//汇总数
		var params_sum = {"eaction":"getYXSumByBuild","village_id":village_id,"segm_code":yx_build_id};
		$.post(url,params_sum,function(data){
			hideAndShowTab(1);
			var d = $.parseJSON(data);
			if(d.length){
				var item = d[0];
				$("#yx_num").text(item.YX_NUM);
				$("#yx_execed").text(item.YX_EXECED);
				$("#yx_unexec").text(item.YX_UNEXEC);
			}else{
				$("#yx_num").text("0");
				$("#yx_execed").text("0");
				$("#yx_unexec").text("0");
			}
		});
		//列表
		params_sum.eaction = "getYXListByBuild";
		unusedBuildPage = 0;
		params_sum.page = unusedBuildPage;
		var params = params_sum;
		clearYXlist();
		yx_list_scroll(1,params);
	}

	//营销清单 弹窗
	function popYXListWin(){
		yx_list_win_handler = layer.open({
			title: '营销清单',
			//title:false,
			type: 1,
			shade: 0,
			//maxmin: true, //开启最大化最小化按钮
			area: ['90%','90%'],
			content: $("#yx_list_div"),
			skin: "yx_list_pop_win",
			cancel: function (index) {
				scene_id = "";
				yx_build_id = "";
				layer.close(yx_list_win_handler);
			},
			full: function() { //点击最大化后的回调函数
				//$(".sub_summary_div .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
			},
			restore: function() { //点击还原后的回调函数
				//$(".sub_summary_div .layui-layer-setwin").css("top",'6px');
			}
		});
	}

	function hideAndShowTab(index){
		$("table[id^='yx_list_tab_head']").hide();
		$("div[id^='yx_list_tab_body_div']").hide();
		$("#yx_list_tab_head"+index).show();
		$("#yx_list_tab_body_div"+index).show();
	}

	function exec_agent(segm_id,prod_inst_id,add6,mkt_campaign_id,pa_date){
		var param = {};
		param.segment_id = segm_id;
		param.prod_inst_id = prod_inst_id;
		param.add6 = add6;
		param.mkt_campaign_id = mkt_campaign_id;
		param.pa_date = pa_date;
		param.tab_id = 2;
		param.is_village = 1;
		parent.openCustViewByProdInstId(param);
	}

	//一级汇总:派单情况
	function intraday_num(){
		var params = {};
		params.village_id = village_id;
		params.eaction = "intraday_num";
		$.post(url,params, function (data) {
			data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				//营销场景
				//$("#head_scene_num").html(""+d.SCENE_NUM+"");
				//目标用户
				$("#head_target_num").html(""+d.TARGET_NUM+"");
				//执行用户
				$("#head_exec_num").html(""+d.EXEC_NUM+"");
				//执行率
				$("#head_exec_lv").html(""+d.EXEC_LV+"");
				//成功用户
				//$("#head_succ_num").html(""+d.SUCC_NUM+"");
			}
		})
	}

	//二级汇总:场景，状态 已废弃
	function intraday_sed_num(){
		var params = {};
		params.village_id=village_id;
		params.segm_code=yx_build_id;
		params.eaction = "intraday_sed_num";
		$.post(url,params, function (data) {
			data = $.parseJSON(data);
			if(data.length){
				var d = data[0];
				//场景-全部
				$("#intraday_all").html("("+ a.A+")");
				//场景-单转融
				$("#intraday_dzr").html("("+ a.B+")");
				//场景-协议到期
				$("#intraday_xydq").html("("+ a.C+")");
				//场景-沉默唤醒
				$("#intraday_cmhx").html("("+ a.D+")");
				//状态-全部
				$("#status_all").html("("+ a.E+")");
				//状态-未执行
				$("#status_noexcute").html("("+ a.F+")");
				//状态-已执行
				$("#status_excute").html("("+ a.G+")");
			}
		})
	}

	//类表数据清除
	function clear_data() {
		yx_begin_scroll = "", yx_seq_num = 0, yx_list_page = 0, flag = true,scene_id = "",yx_build_id = "";
		$("#dispatch_info_list1").empty();
		$("#dispatch_info_list2").empty();
	}
	function clearYXlist(){
		order = 0;
		$("#yx_list_tab_body0").empty();
		$("#yx_list_tab_body1").empty();
	}

	//初始化加载
	var timeOut = new Date();
	$(function(){
		//初始化场景
		initScene();
		//初始化comb 楼宇
		yx_initComb();
		//一级汇总:派单情况
		intraday_num();

        $(".yx_tab_switch > span").each(function(index){
            $(this).unbind();
            $(this).bind("click", function(){
				var timeOutTemp = new Date();
				//每两秒允许点一次
				if(timeOutTemp-timeOut>2000){
					$(this).addClass("active").siblings().removeClass("active");
					//显示当前表格，隐藏其他表格
					if(index==0){//场景营销
						yx_type_flg=1;
					}else if(index==1){//楼宇营销
						yx_type_flg=2;
					}
					clear_data();
					$("table[id^='select_tab']").hide();
					$("#select_tab"+(index+1)).show();
					$("div[id^='content']").hide();
					$("#content"+(index+1)).show();
					//列表数据展示
					load_intraday_data();
					timeOut = new Date();
				}
			});
        });

		//设置滚动事件
		$(".dispatch_m_tab").scroll(function () {
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - yx_begin_scroll > 500) {
					var params = "";
					if(yx_type_flg==1){
						params = {
							eaction: "marketing_scene",
							page: ++yx_list_page,
							village_id:village_id,
							segm_code:yx_build_id,
							scene_id:scene_id
						}
					}else if(yx_type_flg==2){
						params = {
							eaction: "marketing_build",
							page: ++yx_list_page,
							village_id:village_id,
							segm_code:yx_build_id,
							scene_id:scene_id
						}
					}

					intradayListScroll(params, yx_type_flg);
				}
				yx_begin_scroll = new Date().getTime();
			}
		});

		//营销清单 滚动事件
		$(".yx_list_tab_body_div").scroll(function () {
			yx_list_index = $(".yx_list_tab_body_div").index($(this));
			console.log("yx_list_index:"+yx_list_index);
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - yx_begin_scroll > 500) {
					var params = "";
					if(yx_list_index==0){
						params = {
							eaction: "getYXListByScene",
							page: ++yx_list_pop_page,
							village_id:village_id,
							scene_id:scene_id
						}
					}else if(yx_list_index==1){
						params = {
							eaction: "getYXListByBuild",
							page: ++yx_list_pop_page,
							village_id:village_id,
							segm_code:yx_build_id
						}
					}

					yx_list_scroll(yx_list_index,params);
				}
				yx_begin_scroll = new Date().getTime();
			}
		});

	});

	var order = 0;
	function yx_list_scroll(index,params){
		hideAndShowTab(index);
		popYXListWin();
		$.post(url,params,function(data) {
			if(yx_list_pop_page==0){
				$("#yx_list_tab_body"+index).empty();
			}
			var list = $.parseJSON(data);
			if(list.length){
				if(index==0){
					for(var i = 0,l = list.length;i<l;i++){
						var d = list[i];
						var row = "<tr>";
						row += "<td>"+ (++order)+"</td>";
						row += "<td>"+ d.SERV_NAME +"</td>";
						row += "<td><a class='link' href='javascript:void(0);' onclick='exec_agent(\""+ d.SEGM_ID+"\",\""+ d.TARGET_OBJ_NBR+"\",\""+ d.ADDRESS_ID+"\",\""+ d.MKT_CAMPAIGN_ID +"\",\""+ d.PA_DATE +"\")'>"+ phoneHide(d.ACC_NBR) + "</a></td>";
						row += "<td>"+ addr(d.STAND_NAME_2) + "</td>";
						row += "<td>"+ d.SCENE_NAME + "</td>";
						row += "<td>"+ d.EXE_STATE + "</td>";
						row += "</tr>";
						$("#yx_list_tab_body"+index).append(row);
					}
				}else if(index==1){
					for(var i = 0,l = list.length;i<l;i++){
						var d = list[i];
						var row = "<tr>";
						row += "<td>"+ (++order)+"</td>";
						row += "<td>"+ d.SEGM_NAME_2 +"</td>";
						row += "<td>"+ d.SERV_NAME +"</td>";
						row += "<td><a class='link' href='javascript:void(0);' onclick='exec_agent(\""+ d.SEGM_ID+"\",\""+ d.TARGET_OBJ_NBR+"\",\""+ d.ADDRESS_ID+"\",\""+ d.MKT_CAMPAIGN_ID +"\",\""+ d.PA_DATE +"\")'>"+ d.ACC_NBR + "</a></td>";
						row += "<td>"+ d.SCENE_NAME + "</td>";
						row += "<td>"+ d.EXE_STATE + "</td>";
						row += "</tr>";
						$("#yx_list_tab_body"+index).append(row);
					}
					mc("yx_list_tab_body"+index,0,0,1);
					mc("yx_list_tab_body"+index,0,0,2);
				}
			}else{
			}
		});
	}

	function mc(tableId, startRow, endRow, col) {
		var tb = document.getElementById(tableId);
		console.log(col);
		console.log(tb.rows);
		if (col >= tb.rows[0].cells.length) {
			return;
		}
		if (col == 0) { endRow = tb.rows.length-1; }
		for (var i = startRow; i < endRow; i++) {
			if (tb.rows[startRow].cells[col].innerHTML == tb.rows[i + 1].cells[0].innerHTML) {
				tb.rows[i + 1].removeChild(tb.rows[i + 1].cells[0]);
				tb.rows[startRow].cells[col].rowSpan = (tb.rows[startRow].cells[col].rowSpan | 0) + 1;
				if (i == endRow - 1 && startRow != endRow) {
					mc(tableId, startRow, endRow, col + 1);
				}
			} else {
				mc(tableId, startRow, i + 0, col + 1);
				startRow = i + 1;
			}
		}
	}

	var scene_change = function(select_index){
		clear_data();
		scene_type_flg = select_index;
		scene_id = $("#scene_select"+select_index).val();
		load_intraday_data();
	}

	//楼宇combonchage事件
	var yx_load_build_info = function (select_index) {
		clear_data();
		yx_type_flg = select_index;
		yx_build_id = $("#yx_collect_new_build_list"+select_index).val();
		load_intraday_data();
	};

	//场景下拉框初始化
	function initScene(){
		var data = ${e:java2json(scene_list.list)};
		var d, newRow = "<option value=''>全部</option>";//<option value='-1' select='selected'>全部</option>
		for (var i = 0, length = data.length; i < length; i++) {
			d = data[i];
			newRow += "<option value='" + d.CODE + "'>" + d.TEXT + "</option>";
			yx_build_list.push(d);
		}
		$("#scene_select1").append(newRow);
		$("#scene_select2").append(newRow);
		$("#scene_select1 option").eq(0).attr("selected","selected");
		$("#scene_select2 option").eq(0).attr("selected","selected");

		//初始化选中
		scene_id = $("#scene_select1").val();
		load_intraday_data();
	}

	//楼宇comb初始化
	function yx_initComb() {
		var data = ${e:java2json(yx_list.list)};
		var d, newRow = "<option value=''>全部</option>";//<option value='-1' select='selected'>全部</option>
		for (var i = 0, length = data.length; i < length; i++) {
			d = data[i];
			newRow += "<option value='" + d.CODE + "'>" + d.TEXT + "</option>";
			yx_build_list.push(d);
		}
		$("#yx_collect_new_build_list1").append(newRow);
		$("#yx_collect_new_build_list2").append(newRow);
		$("#yx_collect_new_build_list1 option").eq(0).attr("selected","selected");
		$("#yx_collect_new_build_list2 option").eq(0).attr("selected","selected");

		//初始化选中
		yx_build_id = $("#yx_collect_new_build_list1").val();
		//load_intraday_data();
	}

	//楼宇comb输入事件
	function yx_load_build_name_list(index) {
		setTimeout(function() {
			//下拉列表显示
			var $build_list =  $("#yx_collect_new_build_name_list"+index);
			$build_list.empty();
			if (yhzt_select_count <= 1) {
				//before_load_build_list();
			}

			var build_name = $("#yx_collect_new_build_name"+index).val().trim();
			if (build_name != '') {
				var temp;
				var newRow = "";
				for (var i = 0, length = yx_build_list.length, count = 0; i < length; i++) {
					if ((temp = yx_build_list[i].TEXT).indexOf(build_name) != -1) {
						newRow += "<li title='" + temp + "' onclick='yx_select_build(\""+ temp + "\",\"" +
						yx_build_list[i].CODE + "\"," + i + ","+ select_index +")'>" + temp + "</li>";
						count++;
					}

				}
				$build_list.append(newRow);
				$("#yx_collect_new_build_name_list"+index).show();
			} else {
				$("#yx_collect_new_build_name_list"+index).hide();
				//[全部]选中
				var text = $("#yx_collect_new_build_list"+index).find("option:selected").text();
				$("#yx_collect_new_build_name"+index).val(text);
				$("#yx_collect_new_select_build"+index).html(text);

				yx_build_id = $("#yx_collect_new_build_list"+index).val();
				//共同楼宇ID,标签联动切换使用,需要子页面去赋值
				//统计显示
				//intraday_sed_num();
				clear_data();
				//列表信息
				load_intraday_data();
			}

			//联动改变 select框, 只要不做点击, 都会将select改回全部.
			$("#yx_collect_new_build_list"+index+" option:eq(0)").attr('selected','selected');
			yx_select_count++;
		}, 800)
	}

	//楼宇comb显示
	function yx_select_build(name, id, index, select_index) {
		$("#yx_collect_new_build_list"+select_index+" option[value=" + id + "]").attr('selected','selected');
		$("#yx_collect_new_build_name_list"+select_index).hide();
		$("#yx_collect_new_build_list"+select_index).change();
	}
</script>