<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="bureaulist">
	SELECT '-1' CODE, '全部' TEXT FROM DUAL UNION ALL
	select DISTINCT BUREAU_NO,BUREAU_NAME FROM ${gis_user}.db_cde_grid
    <e:if condition="${!empty sessionScope.UserInfo.AREA_NO}">
        where latn_id=${sessionScope.UserInfo.AREA_NO}
    </e:if>
</e:q4l>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
	<meta http-equiv="expires" content="0">
	<title>导入资料审核</title>
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
	<e:script value="/resources/layer/layer.js"/>
	<c:resources type="easyui,app" style="b"/>
	<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
	<script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
	<script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
	<script src='<e:url value="/pages/telecom_Index/common/js/getTableRowSizeByScreen.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.3.16" />'  rel="stylesheet" type="text/css"
          media="all">
	<style>
		#tools{height:95%;}
		#query_div{width:120px;height:47px;padding:0;position:absolute;display:none;}
		#query_div div{float:left;line-height:29px;color:#fff;cursor:pointer;padding-left:0px;}
		.ico{width:17px;height:17px;margin-right:7px;margin-top: -20px;}
		#query_div span{height:18px;line-height:18px;width:30px;font-size:12px;display:inline-block;margin-top:2px;}
		@media screen and (max-height: 1080px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.backup{right:1.4%;top:2.5%;}
			.tab_box{margin-top:18px;}
		}
		@media screen and (max-height: 768px){
			.search{width:97.5%;margin:0px auto;left:0px;position:relative;top:0px;}
			.tab_box{margin-top:13px;}
		}
		.datagrid-header {height:auto;line-height:auto;}
		.bureau_select a {    display: block;
			float: left;
			margin-right: 20px;width:auto;}
		.bureau_select a.selected {background-color: #ff8a00;
			width: auto;
			height: auto;
			text-align: center;
			border-radius: 4px;
			color: #fff;}
        .search_head{
            width:80px;
            text-align: right;
            font-weight:bold;
        }
        #tab_div .table1 tr td{
            width: 80px;
        }
        .search{
            background: none;
            width:100%;
            color:#fff;
            border:1px solid  #999;
        }
        .search a{
            color:#fff;
        }

        .sub_b {
            border-left: 1px solid #aaa;
            border-right: 1px solid #aaa;
        }
        .text-left{
            text-align:left!important;
        }
        .text-right{
            text-align:right!important;
            padding-right:15px!important;
        }
        .table1 tr:nth-child(1) td{background:none;}
        .important td{color:#fa8513!important;}
        #table_head,#big_tab_info_list{border-color:#aaa;}
		.search{border-color:#1851a9;}
		.table1, .table1 th, .table1 td{
			border-color:#092e67;
		}
		.buttonclick{
			padding: 5px 15px;
			background: #1069c9;
			border-radius: 5px;
			border: none;
			outline: none;
			color: #fff;
		}
		.selectstyle{
			width: 142px;
			margin-right: 20px;
			margin-left: 0;
			height: 20px!important;
			line-height: 20px!important;
		}
		body{
			background: url(img/total_bg.jpg) no-repeat top center;
		}
	</style>
</head>
<body>
 <%--style="background: #000"--%>
<div class="sub_box">
	<div class="close_button" id="closeTab"></div>
	<div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
		<div class="big_table_title"><h4>导&nbsp;入&nbsp;资&nbsp;料&nbsp;审&nbsp;核</h4></div>
			<div class="tab_box table_cont_wrapper">
			<div class="sub_">
				<table cellspacing="0" cellpadding="0" class="search">
					<tr>
						<td >
							&nbsp;&nbsp;&nbsp;&nbsp;筛选条件：&nbsp;&nbsp;&nbsp;&nbsp;
							县局:
							<e:select id="info_bureau_name"  name="info_bureau_name"  class="selectstyle" items="${bureaulist.list}" label="TEXT" value="CODE" onchange="load_bureau_to_branch_list()"/>
						支局:
							<select id="info_branch_name" name="info_branch_name" class="selectstyle" onchange="load_branch_to_grid_list()"></select>
						网格:
							<select id="info_grid_name" name="info_grid_name" class="selectstyle" onchange="show_info_village_list()"></select>
						</td>

						<td>
							<button id="selectall"  class="buttonclick" onclick="changeAllSelectTrue()">全选</button>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<button id="cancel_exe" class="buttonclick" onclick="changeAllSelectFalse()">取消</button>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<button id="save_exe" class="buttonclick" onclick="submitdata()">提交</button>
							&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
				</table>

				<div class="sub_b">
					<div style="padding-right:15px;background: #0b0a8a;">
						<table cellspacing="0" cellpadding="0" class="table1" id="table_head" style="width: 100%;">
							<thead>
							<tr>
								<th width="5%">是否通过</th>
								<%--<th width="6%">六级地址编码</th>--%>
								<th width="20%">六级地址名称</th>
								<th width="6%">客户名称</th>
								<th width="9%">联系电话</th>
								<th width="6%">宽带运营商</th>
								<th width="5%">宽带资费</th>
								<th width="7%">宽带到期时间</th>
								<th width="6%">ITV运营商</th>
								<th width="5%">ITV资费</th>
								<th width="7%">ITV到期时间</th>
								<th width="6%">记事内容</th>
								<th width="6%">提醒时间</th>
								<th width="6%">备注</th>
								<th width="6%">导入人工号</th>
								<%--<th width="6%">导入时间</th>--%>
								<%--<th width="5%">是否通过</th>--%>
							</tr>
							</thead>
						</table>
					</div>
					<div class="t_body" id="big_table_info_div">
						<table cellspacing="0" cellpadding="0" class="table1" id="big_tab_info_list" style="width: 100%">
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<script type="text/javascript">
    var url4data = "<e:url value='/pages/data_review_sql.jsp' />";
    var begin = 0,end = 0, seq_num = 0, begin_scroll = 0, page_list = 0, query_sort = '0', eaction = "search_by_condition";
     //eaction = "search_by_condition(默认)"  "info_bureau_list"  info_branch_list  info_grid_list  info_stand_list
//    var city_id =931;
    var city_id ='${sessionScope.UserInfo.AREA_NO}';
    var bureau_no,branch_no,grid_id;  //待用  赋值时注意上级包含下级 即数据库中执行结果为上级包含下级
    var clickarray=[]; //暂存每条显示数据的segm_id_2用于复选框的标记，注意在数据刷新前清空，不然会出现重复值。

    //如果已经没有数据, 则不再次发起请求.
    var hasMore = true;

    $(function() {
        load_list();
//        load_bureau_list();



        $(".t_body").css("max-height", $("#tab_div").height() - 55 - $(".big_table_title").height() - $(".search").eq(0).height() - $(".search").eq(1).height());
        $(".t_body>table").width($(".table1:eq(0)").width() + 2);

        //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
        $('.t_body').scroll(function () {
            //alert($(this).scrollLeft());
            $('#table_head').css('margin-left', -($('.t_body').scrollLeft()));
        });


        $("#closeTab").on("click", function () {
      //      load_map_view();  // 返回上一级  此页面的上一级页面还未确定
        });

    });


    function load_list() {
        var params = {
            eaction: eaction,
            page: 0,
            city_id: city_id,
            bureau_no:bureau_no,
            branch_no:branch_no,
            grid_id:grid_id,
        }
        listScroll(params, true, eaction);
    }


    $('.radio').click(function(){ //单选按钮点击事件
        alert("您是..." + $(this).val());
    });

    $("#big_table_info_div").scroll(function () { //表单滚动触底后触发新的数据请求
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                var params = {
                    eaction: eaction,
                    page: ++page_list,
                    city_id: city_id,
                    bureau_no: $("select[name=info_bureau_name]").val()=='-1'?'':$("select[name=info_bureau_name]").val(),
                    branch_no: $("select[name=info_branch_name]").val()=='-1'?'':$("select[name=info_branch_name]").val(),
                    grid_id: $("select[name=info_grid_name]").val()=='-1'?'':$("select[name=info_grid_name]").val(),
                }
                listScroll(params, false, eaction);
            }
            begin_scroll = new Date().getTime();
        }
    });

    function listScroll(params, flag, action) {
        listCollectScroll(params, flag);
    }


    function listCollectScroll(params, flag) {
        var $list = $("#big_tab_info_list");
//		clickarray=[];
        if (hasMore) {
            $.post(url4data, params, function (data) {
                data = $.parseJSON(data);

                for (var i = 0, l = data.length; i < l; i++) {
                    var d = data[i];
                    var newRow = "<tr><td style='width: 5%'> " +
//						"<input  type='checkbox' name='name' value='1' />通过<br/>"+
                        "<input  type='checkbox' id=" +d.SEGM_ID_2+ " value='1' />通过<br/>"+
						"</td><td style='width: 20%'>" + (d.STAND_NAME_2==null?'':d.STAND_NAME_2) +
                        "</td><td style='width: 6%'>" + (d.CONTACT_PERSON==null?'':d.CONTACT_PERSON) +
                        //						(++seq_num) +
						// 						"</td><td style='width: 6%'>" + (d.SEGM_ID_2==null?'':d.SEGM_ID_2) +
                        "</td><td style='width: 9%'>" + (d.CONTACT_NBR==null?'':phoneHide(d.CONTACT_NBR)) +
                        "</td><td style='width: 6%'>" + (d.KD_BUSINESS==null?'':d.KD_BUSINESS) +
                        "</td><td style='width: 5%'>" + (d.KD_XF==null?'':d.KD_XF) +
                        "</td><td style='width: 7%'>" + (d.KD_DQ_DATE==null?'':d.KD_DQ_DATE) +
                        "</td><td style='width: 6%'>" + (d.ITV_BUSINESS==null?'':d.ITV_BUSINESS) +
                        "</td><td style='width: 5%'>" + (d.ITV_XF==null?'':d.ITV_XF) +
                        "</td><td style='width: 7%'>" + (d.ITV_DQ_DATE==null?'':d.ITV_DQ_DATE) +
                        "</td><td style='width: 6%'>" + (d.NOTE_TXT==null?'':d.NOTE_TXT) +
                        "</td><td style='width: 6%'>" + (d.WARN_DATE==null?'':d.WARN_DATE) +
                        "</td><td style='width: 6%'>" + (d.COMMENTS==null?'':d.COMMENTS) +
                        "</td><td style='width: 6%'>" + (d.IMPORT_PERSON==null?'':d.IMPORT_PERSON) +
//                        "</td><td style='width: 6%'>" + (d.IMPORT_TIME==null?'':d.IMPORT_TIME) +
                        "</td></tr>";

                    clickarray.push(d.SEGM_ID_2);
                    $list.append(newRow);
                }
                //只有第一次加载没有数据的时候显示如下内容
                if (data.length == 0) {
                    hasMore = false;
                    if (flag) {
                        $list.empty();
                        $list.append("<tr><td style='text-align:center' colspan=7 >没有查询到数据</td></tr>")
                    }
                }
            });
        }
    }

    $("#collect_tabs_change > div").each(function (index) {
        $(this).on("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    });

    function clear_data() {
        begin = 0, end = 0, seq_num = 0, begin_scroll = 0, hasMore = true, page_list = 0
        flag = '1', query_sort = '0';
        $("#big_tab_info_list").empty();
    }

    //2018.10.22 号码脱敏
    function phoneHide(phone){
        var d = phone.substr(0,3);
        for(var i = 0,l = phone.length-5;i<l;i++){
            d += "*";
        }
        return d+phone.substr(-2);
    }

    //级联开始   到网格结束
//    var branch_list = [];
    //1县局到分局级联   2展示县局下数据
    function load_bureau_to_branch_list(){
        var $branch_list =  $("#info_branch_name");
        var $grid_list =  $("#info_grid_name");
        $branch_list.empty();
        $grid_list.empty();
//        branch_list = [];
        var params = {
            eaction: 'info_branch_list',
			page:0,
            city_id: city_id,
            bureau_no: $("select[name=info_bureau_name]").val()=='-1'?'':$("select[name=info_bureau_name]").val(),
        }
        $.post(url4data, params, function (data) {
            data = $.parseJSON(data);
            if (data.length != 0) {
                var d, newRow = "<option value='-1' select='selected'>全部</option>";
                for (var i = 0, length = data.length; i < length; i++) {
                    d = data[i];
                    newRow += "<option value='" + d.BRANCH_NO + "' select='selected'>" + d.BRANCH_NAME + "</option>";
//                    branch_list.push(d);
                }
                $branch_list.append(newRow);
            }
        });
		//数据展示
        clear_data();
        clickarray=[]; //清空暂存数据  避免重复
        params.eaction="search_by_condition";
        listCollectScroll(params,true);
    }

//    var grid_list = [];
    //1分局到网格级联   2分局下数据展示
    function load_branch_to_grid_list(){
        var $grid_list =  $("#info_grid_name");
        $grid_list.empty();
//        grid_list = [];
        var params = {
            eaction: 'info_grid_list',
			page:0,
            city_id: city_id,
            bureau_no: $("select[name=info_bureau_name]").val()=='-1'?'':$("select[name=info_bureau_name]").val(),
            branch_no: $("select[name=info_branch_name]").val()=='-1'?'':$("select[name=info_branch_name]").val(),
        }
        $.post(url4data, params, function (data) {
            data = $.parseJSON(data);
            if (data.length != 0) {
                var d, newRow = "<option value='-1' select='selected'>全部</option>";
                for (var i = 0, length = data.length; i < length; i++) {
                    d = data[i];
                    newRow += "<option value='" + d.GRID_ID + "' select='selected'>" + d.GRID_NAME + "</option>";
//                    grid_list.push(d);
                }
                $grid_list.append(newRow);
            }
        });

        //数据展示
		clear_data();
        clickarray=[]; //清空数据  避免重复
		params.eaction="search_by_condition";
		listCollectScroll(params,true);
    }
//级联结束


    //网格下数据展示
    function show_info_village_list(){
        var params = {
            eaction: 'search_by_condition',
			page:0,
            city_id: city_id,
            bureau_no: $("select[name=info_bureau_name]").val()=='-1'?'':$("select[name=info_bureau_name]").val(),
            branch_no: $("select[name=info_branch_name]").val()=='-1'?'':$("select[name=info_branch_name]").val(),
            grid_id: $("select[name=info_grid_name]").val()=='-1'?'':$("select[name=info_grid_name]").val(),
        }
        clear_data();
        clickarray=[]; //清空数据 避免重复
        listCollectScroll(params,true);
    }

    function changeAllSelectTrue(){
        for (var i = 0, length = clickarray.length; i < length; i++) {
            document.getElementById(clickarray[i]).checked=true;
        }
    }

    function changeAllSelectFalse(){
        for (var i = 0, length = clickarray.length; i < length; i++) {
            document.getElementById(clickarray[i]).checked=false;
        }
    }

    //提交数据
    <%--<%!--%>
     <%--List checkedlist=new ArrayList();--%>

	var checkedarraystring='';
	function submitdata() {
        checkedarraystring='';
        for (var i = 0, length = clickarray.length; i < length; i++) {
            if (document.getElementById(clickarray[i]).checked){
                checkedarraystring+=(clickarray[i]+',');
			}
        }
        if (""==checkedarraystring){
            alert("请选择审核数据！");
		}
		else {
            var params = {
                eaction: 'update_data',
                page:0,
                city_id: city_id,
                bureau_no: $("select[name=info_bureau_name]").val()=='-1'?'':$("select[name=info_bureau_name]").val(),
                branch_no: $("select[name=info_branch_name]").val()=='-1'?'':$("select[name=info_branch_name]").val(),
                grid_id: $("select[name=info_grid_name]").val()=='-1'?'':$("select[name=info_grid_name]").val(),
                list: checkedarraystring,
            }
            $.post(url4data, params,function (data) {
                data = $.parseJSON(data);
                if (data>0){
                    alert("数据审核成功");
                    clear_data();
                    clickarray=[]; //清空数据  避免重复
                    params.eaction="search_by_condition";
                    listCollectScroll(params,true);
                }
            });
		}

    }

</script>