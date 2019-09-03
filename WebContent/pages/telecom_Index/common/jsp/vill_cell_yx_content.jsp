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

		.village_view_win .tab_box div .desk_orange_bar {
			text-align: center;
		}
		.head_table tr {background:#007BA9;}
		.btn {
			background: #007ba9;
			color: #fff;
			width: 55px;
			height: 25px;
		}

		#yx_head tr th:first-child{width:5%;}
		#yx_head tr th:nth-child(2){width:10%;}
		#yx_head tr th:nth-child(3){width:12%;}
		#yx_head tr th:nth-child(4){width:12%;}
		#yx_head tr th:nth-child(5){width:29%;}
		#yx_head tr th:nth-child(6){width:24%;}
		#yx_head tr th:nth-child(7){width:11%;}

		#dispatch_info_list1 tr td:first-child{width:5%;}
		#dispatch_info_list1 tr td:nth-child(2){width:10%;text-align:center;}
		#dispatch_info_list1 tr td:nth-child(3){width:12%;}
		#dispatch_info_list1 tr td:nth-child(4){width:12%;}
		#dispatch_info_list1 tr td:nth-child(5){width:29%;text-align:left;}
		#dispatch_info_list1 tr td:nth-child(6){width:24%;text-align:left;}
		#dispatch_info_list1 tr td:nth-child(7){width:11%;}

		.dispatch_m_tab {
			border-bottom:1px solid #efefef;
		}

    </style>
</head>
<body>
    <!--营销清单----------20180412------------- 开始---------------------->
    <div class="village_new_searchbar">
        <table style="width:100%">
            <tr>
                <td>
                    <div class="count_num desk_orange_bar inside_data">
                        场景数：<span id="head_scene_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        目标数：<span id="head_target_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        执行数：<span id="head_exec_num" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        成功数：<span id="head_succ_num" style="color:#FF0000">0</span>
                    </div>
                </td>
            </tr>
        </table>
        <!--<div class="yx_tab_switch" style="height:26px;"><span class="active">场景营销</span><span>楼宇营销</span></div>-->

					<div class="collect_new_choice" style="position:relative;padding-top:5px;color:black;width:100%;">
						<div class="collect_contain_choice" style="margin:0px auto;width: 45%;">
							<span style='font-weight:bold;'>社队:</span>
							<select id="collect_new_build_list_sj_yx" style="width: 80%;padding-left:0px;" onchange="change()"></select>
							<!--<input type="text" id="collect_new_build_name_sj"
								   style="width: 80%;border:none;height:22px!important;line-height:22px!important;margin:1px;"
								   oninput="load_build_name_list_sj()">
							<ul id="collect_new_build_name_sj_list">
							</ul>-->
						</div>
						<div style="margin:0px auto;width:45%;text-align:left;float:left;margin-left:55px;" class="collect_contain_choice">
							<span style='font-weight:bold;'>场景:</span>
							<select id="collect_scene_list_sj" style="width: 80%;padding-left:0px;" onchange="change()"></select>
						</div>
						<%--<div style="width:8%;display:inline-block;" class="collect_contain_choice">
							<input type="button" value="查询" class="btn" id="query_btn" />
						</div>--%>
					</div>

        <!--<table id="select_tab2">
            <tr>
                <td style="width:6%;text-align:center;">楼宇：</td>
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
				</td>
            </tr>
        </table>-->
    </div>

	<div class="count_num2">
		记录数：<span id="record_num_yx"></span>
	</div>

    <!--场景营销标签页内容 -->
    <div id="content1" style="width:97.5%;margin:0px auto;">
        <div class="div_0_0">
            <div class="datagrid">
                <div class="head_table_wrapper">
                    <table class="head_table" id="yx_head">
                        <tr>
                            <th >序号</th>
                            <th >用户名称</th>
                            <th >接入号码</th>
                            <th >联系电话</th>
                            <th >营销推荐</th>
                            <th >地址</th>
                            <th >操作</th>
                        </tr>
                    </table>
                </div>
                <div class="t_table dispatch_m_tab" style="margin:0px auto;">
                    <table class="content_table dispatch_detail_in" id="dispatch_info_list1" style="width:100%;">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!--场景清单清单----------20180412------------- 结束---------------------->

    <!--楼宇营销标签页内容 -->
    <!--<div id="content2" style="width:96%;margin:0px auto;">
        <div class="div_hide div_0_0">
            <div class="datagrid">
                <div class="head_table_wrapper">
                    <table class="head_table">
                        <tr>
                            <th width="35">序号</th>
                            <th width="330">楼宇</th>
                            <th width="100">用户数</th>
                            <th width="100">执行数</th>
                            <!--
                            <th width="100">派单时间</th>
                            <th width="35">操作</th>
                            -->
                        <!--</tr>
                    </table>
                </div>
                <div class="t_table dispatch_m_tab" style="margin:0px auto;">
                    <table class="content_table dispatch_detail_in" id="dispatch_info_list2" style="width:100%;">
                    </table>
                </div>
            </div>
        </div>
    </div>-->
    <!--楼宇清单清单----------20180412------------- 结束---------------------->

	<!-- 营销清单弹窗内容 -->
	<!--<div id="yx_list_div">
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
	</div>-->
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
	var url = "<e:url value='/pages/telecom_Index/common/sql/tabData_village_cell.jsp'/>";
	var load_intraday_data = function (flag){
        var params = "";
        //clear_data();
        /*if(yx_type_flg==1){
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
		intradayListScroll(params);*/
		yx_build_id = $("#collect_new_build_list_sj_yx option:selected").val();
		scene_id = $("#collect_scene_list_sj option:selected").val();
		params = {
			eaction: "villageCell_yx_list",
			page: yx_list_page,
			village_id:village_id,
			build_id:yx_build_id,
			scene_id:scene_id,
			flag: flag
		}
		intradayListScroll(params);
	};
	//parent.yx_load_intraday_data_view = load_intraday_data;
	//parent.parent.fresh_village_yx = load_intraday_data;

	var flag = true;
	//加载表格数据-营销派单
	function intradayListScroll(params) {
		var flag = params.flag;
		$.post(url, params, function (data) {
			data = $.parseJSON(data);
            //场景营销
			var $grid_list = $("#dispatch_info_list1");
			//if(data.length)
			//	flag = false;

			if(yx_list_page==0){
				if(data.length){
					$("#record_num_yx").text(data[0].C_NUM);
				}else{
					$("#record_num_yx").text("0");

				}
			}

			for (var i = 0, l = data.length; i < l; i++) {
				var d = data[i];
				var newRow = "<tr><td>" + (++yx_seq_num) + "</td>";
				newRow +=
					"<td style=''>" + name_hide(d.SERV_NAME)  + "</td>"+
					"<td style=''><a class='clickable' href=\"javascript:exec_agent('"+ d.BRIGADE_ID +"','"+d.PROD_INST_ID+"','','"+ d.MKT_CAMPAIGN_ID+"','',0)\">" + d.ACC_NBR + "</a></td>"+
					"<td style=''>" + d.USER_CONTACT_NBR + "</td>";
				//if(d.USER_NUM>0)
				//	newRow +="<td style='width:100px'><a class='link' href='javascript:void(0);' onclick='showYXListByScene(\""+ d.MKT_CAMPAIGN_ID +"\")'>" + d.USER_NUM + "</a></td>";
				//else
					newRow += "<td style=''>";
				newRow += "<span style='color:#1c69b9;font-weight: bolder;'>【"+ d.MKT_CAMPAIGN_NAME+"】</span><br/>";
				newRow += "<span style='font-weight: bolder;font-size:+1'>原因：</span>"+d.CONTACT_SCRIPT;
				newRow += "</td>";

				newRow += "<td style=''>"+ d.ADDRESS_DESC +"</td>";
				newRow += "<td><a class='clickable' href=\"javascript:exec_agent('"+ d.BRIGADE_ID +"','"+d.PROD_INST_ID+"','','"+ d.MKT_CAMPAIGN_ID+"','',2)\">执行</a></td></tr>";

				$grid_list.append(newRow);
			}
			if (data.length == 0 && flag) {
				$("#record_num_yx").text("0");
				$grid_list.empty();
				$grid_list.append("<tr><td style='text-align:center' colspan=5 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
				return;
			}
		});
	}
	function name_hide(str){
		return str.substr(0,1)+"**";
	}

	var unusedBuildPage = 0;
	var yx_list_win_handler = "";
	//场景下的用户列表

	//楼宇下的用户列表

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

	function exec_agent(brigade_id,prod_inst_id,add6,mkt_campaign_id,pa_date,tab_id){
		var param = {};
		param.brigade_id = brigade_id;
		param.prod_inst_id = prod_inst_id;
		param.add6 = add6;
		param.mkt_campaign_id = mkt_campaign_id;
		param.pa_date = pa_date;
		param.village_id = '${param.village_id}';
		param.tab_id = tab_id;
		param.is_village = 1;
		parent.openCustViewByProdInstId(param);
	}

	//一级汇总:派单情况
	function intraday_num(){
		var params = {};
		params.village_id = village_id;
		params.eaction = "villageCell_yx_summary";
		$.post(url,params, function (data) {
			var datas = $.parseJSON(data);
			console.log(datas);
			if(datas.length){
				var d = datas[0];
				//营销场景
				$("#head_scene_num").text(""+d.SCENE_COUNT+"");
				//目标用户
				$("#head_target_num").text(""+d.YX_COUNT+"");
				//执行用户
				$("#head_exec_num").text(""+d.ZX_COUNT+"");
				//成功用户
				$("#head_succ_num").text(""+d.SUC_COUNT+"");
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
	}

	//初始化加载
	$(function(){
		//初始化场景
		//initScene();
		//初始化comb 楼宇
		yx_initComb();
		//一级汇总:派单情况
		////intraday_num();
		intraday_num();

		load_intraday_data(1);

		$("#query_btn").unbind();
		$("#query_btn").bind("click",function(){
			console.log("query_btn click");
			clear_data();
			load_intraday_data(1);
		});

		//设置滚动事件
		var yx_begin_scroll = 0;
		$(".dispatch_m_tab").scroll(function () {
			console.log(111);
			var viewH = $(this).height();
			var contentH = $(this).get(0).scrollHeight;
			var scrollTop = $(this).scrollTop();
			if (scrollTop / (contentH - viewH) >= 0.95) {
				if (new Date().getTime() - yx_begin_scroll > 500) {
					++yx_list_page;
					load_intraday_data(0);
				}
				yx_begin_scroll = new Date().getTime();
			}
		});
	});

	function change(){
		console.log("query_btn click");
		clear_data();
		load_intraday_data(1);
	}
	var order = 0;

	//楼宇comb初始化
	function yx_initComb() {
		var newRow = "<option value='-1' select='selected'>全部</option>";
		$.post(url,{
			"eaction":"getSheDuiSelectOption",
			"village_id":village_id
		},function(data){
			var ds = $.parseJSON(data);
			for(var i = 0,l = ds.length;i<l;i++){
				var d = ds[i];
				newRow += "<option value='" + d.BRIGADE_ID + "' >" + d.BRIGADE_NAME + "</option>";
				yx_build_list.push(d);
			}
			$("#collect_new_build_list_sj_yx").append(newRow);
			//初始化选中
			var text = $("#collect_new_build_list_sj_yx").find("option:selected").text();
			$("#ly_collect_new_build_name").val(text);
			$("#ly_collect_new_select_build").html(text);
		});

		var newRow1 = "<option value=''>全部</option>";
		$.post(url,{
			"eaction":"getSceneSelectOptionInDB",
			"village_id":village_id
		},function(data){
			var ds = $.parseJSON(data);
			for(var i = 0,l = ds.length;i<l;i++){
				var d = ds[i];
				newRow1 += "<option value='" + d.MKT_CAMPAIGN_ID + "' >" + d.MKT_CAMPAIGN_NAME + "</option>";
			}
			$("#collect_scene_list_sj").append(newRow1);
		});
	}


	//楼宇comb显示
	function yx_select_build(name, id, index, select_index) {
		$("#yx_collect_new_build_list"+select_index+" option[value=" + id + "]").attr('selected','selected');
		$("#yx_collect_new_build_name_list"+select_index).hide();
		$("#yx_collect_new_build_list"+select_index).change();
	}
</script>