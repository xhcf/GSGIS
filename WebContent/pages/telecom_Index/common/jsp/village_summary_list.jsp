<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>划小承包小区统计</title>
    <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.1"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css?version=3.2"/>'
          rel="stylesheet" type="text/css" media="all"/>
    <style>
    	table td{border:1px solid #ccc;}	
    	table th{
    		border:1px solid #ccc;
    		font-size: 12px;
    		color: #000;
		    line-height: 14px;
		    text-align: center;	
    	}	
    	.search_table tr{height:30px;line-height:30px;padding-left:15px}
    	.search_table td{border:none}
    	#village_summary_count{font-size:12px;margin-bottom:0px;width:97%;margin-left: 15px;}
    </style>
</head>
<body style="background:#fff;">
	<div>
		<table class="search_table" style="width:100%; " cellspacing="0" cellpadding="0">
			<tbody>
			  <tr><td colspan=3 style="text-align:left;padding-left:5px;"><h3 class="wrap_a" style="padding-left:6px;height:18px;line-height:18px;color:#109afb;font-weight:bold;">查询条件</h3></td></tr>
				<tr style="">
					<td style="width:35%;padding-left:15px;"><span>分公司：</span><select id="village_summary_latn" style="width:70%;"><option value="">全部</option></select></td>	
					<td style="width:35%;"><span>区县：</span><select id="village_summary_bureau" style="width:70%;"><option value="">全部</option></select></td>	
					<td style="">
						<span>类型：</span>
						<select id="village_summary_branch_type" style="width:70%;">
							<option value="">全部</option>
              <option value="a1">城市</option>
              <option value="b1">农村</option>
						</select>
					</td>	
				</tr>	
				<tr style="">
					<td style="padding-left:15px;"><span>支&nbsp;&nbsp;&nbsp;局：</span><select id="village_summary_branch" style="width:70%;"><option value="">全部</option></select></td>	
					<td><span>网格：</span><select id="village_summary_grid" style="width:70%;"><option value="">全部</option></select></td>	
					<td><button id="village_summary_query" style="display:none;">查询</button></td>	
				</tr>	
			</tbody>
		</table>	
		
		<div id="village_summary_count"></div>
		
		<div style="width:100%;padding:5 22px 0 5px;">
			<table style="width:100%;background:#e8e8e8;color:#000" cellspacing="0" cellpadding="0">
				<thead>
					<th width=50>序号</th>	
					<th width=57>本地网</th>	
					<th width=102>区县</th>	
					<th width=38>类型</th>	
					<th width=114>支局名称</th>	
					<th width=115>网格名称</th>	
					<th width=89>小区名称</th>	
					
					<th width=48>楼宇数</th>	
					<th width=50>住户数</th>	
					<th width=80>总端口数</th>	
					<th width=60>占用<br/>端口数</th>	
					<th width=60>空闲<br/>端口数</th>	
					<th width=55>市场<br/>占有率</th>	
					<th width=55>端口<br/>占用率</th>	
				</thead>
			</table>
		</div>

		<div id="village_summary_table_div" style="height:65%;overflow-y:scroll;width:100%;padding:0 5px 0 5px;">
			<table id="village_summary_table" cellspacing="0" cellpadding="0">
			</table>
		</div>
		
	</div>
</body>
</html>
<script>
	var seq_um = 0;
  var villageSummary_list_page = 0;
  var page = 0;
  var begin_scroll = "";
  
	var city_id = '${param.city_id}';//用户的地市编码
	var bureau_no = "";
	var branch_type = "";
	var union_org_code = "";
	var grid_id = "";
	
	var user_level = '${sessionScope.UserInfo.LEVEL}';
	
	var baseFullOptions = "<option  value=''>全省</option>";
	var baseFullOption = "<option  value=''>全部</option>";
  	
	$(function(){
		if(user_level == 2){
			city_id = '${sessionScope.UserInfo.AREA_NO}';
			$("#village_summary_latn").val(city_id);
			$("#village_summary_latn").attr("disabled","disabled");
		}
		
		setCitys($("#village_summary_latn"), $("#village_summary_bureau"), $("#village_summary_branch"), $("#village_summary_grid"), $("#village_summary_query"), $("#village_summary_branch_type"));
		
		//getSelectedOption();
		villageSummaryCount(city_id,bureau_no,branch_type,union_org_code,grid_id);
		villageSummaryScroll(city_id,bureau_no,branch_type,union_org_code,grid_id,page);
		
		$("#village_summary_query").on("click", function () {
      seq_um = 0;
      getSelectedOption();
      $("#village_summary_count").text("");
      $("#village_summary_table").empty();
      villageSummaryCount(city_id,bureau_no,branch_type,union_org_code,grid_id);
      villageSummaryScroll(city_id,bureau_no,branch_type,union_org_code,grid_id,page);
  	})
  	
  	$("#village_summary_table_div").scroll(function () {
        var viewH = $(this).height();
        var contentH = $(this).get(0).scrollHeight;
        var scrollTop = $(this).scrollTop();
        //alert(scrollTop / (contentH - viewH));

        if (scrollTop / (contentH - viewH) >= 0.95) {
            if (new Date().getTime() - begin_scroll > 500) {
                villageSummary_list_page++;
                getSelectedOption();
                villageSummaryScroll(city_id,bureau_no,branch_type,union_org_code,grid_id,villageSummary_list_page);
            }
            begin_scroll = new Date().getTime();
        }
    });
	});	
	function getSelectedOption(){
		city_id = $("#village_summary_latn option:selected").val();
		bureau_no = $("#village_summary_bureau option:selected").val();
		branch_type = $("#village_summary_branch_type option:selected").val();
		union_org_code = $("#village_summary_branch option:selected").val();
		grid_id = $("#village_summary_grid option:selected").val();
	}
	function setCitys(e, e1, e2, e3, e4, e5) {
      $.post(parent.url4Query, {eaction: 'setcitys'}, function (data) {
          data = $.parseJSON(data)
          var str = ''
          parent.left_list_type_selected = "village";
          e.unbind();
          e.on("change", function () {
              $("#xinjian1").css({"background-color": "#989A9B"});
              var id = e.find(":selected").val()
              e1.html(baseFullOption)
              e2.html(baseFullOption)
              e3.html(baseFullOption)
              e4.click()
              setArea(id, e1, e2, e3, e4, e5);
          })
          $.each(data, function (i, d) {
              str += "<option value='" + d.LATN_ID + "'>" + d.LATN_NAME + "</option>"
          })
          e.html(baseFullOptions)
          e.append(str)
          e.find("option[value=" + city_id + "]").attr("selected", "selected")
          setArea(city_id, e1, e2, e3, e4, e5)
      })
  }

  function setArea(id, e1, e2, e3, e4, e5) {
      $.post(parent.url4Query, {eaction: "setareas", latn_id: id}, function (data) {
          data = $.parseJSON(data)
          e1.unbind();
          e1.on("change", function () {
              e2.html(baseFullOption)
              e3.html(baseFullOption)
              e5.val("")
              var id = e1.find(":selected").val()
              e4.click()
              setBranchs(id, e2, e3, e4)
              setBranchType(id, e2, e3, e4, e5)
              if (id != null) {
                  setGrids(null, e3, e4)
              }
          })
          var str = ''
          $.each(data, function (i, d) {
              str += "<option value='" + d.BUREAU_NO + "'>" + d.BUREAU_NAME + "</option>"
          })
          e1.html(baseFullOption)
          e1.append(str)
          setBranchs(null, e2, e3, e4)
          setBranchType(null, e2, e3, e4, e5)
      })
  }

  setBranchType = function (id, e2, e3, e4, e5) {
      e5.unbind();
      e5.on("change", function () {
          e2.html(baseFullOption)
          e3.html(baseFullOption)
          e4.click()
          setBranchs(id, e2, e3, e4)
      })
  }

  setBranchs = function (id, e1, e2, e3) {
      var latn_id = $("#v_city option:selected").val()
      var branch_type = $("#v_branch_type option:selected").val()
      $.post(parent.url4Query, {
          eaction: "setbranchs",
          id: id,
          latn_id: latn_id,
          branch_type: branch_type
      }, function (data) {
          data = $.parseJSON(data)
          e1.unbind();
          e1.on("change", function () {
              var id = e1.find(":selected").val()
              e2.html(baseFullOption);
              e3.click();
              setGrids(id, e2, e3);
              //$("#xinjian1").css({"background-color":"#989A9B"});
          })
          var str = ''
          $.each(data, function (i, d) {
              str += "<option value='" + d.UNION_ORG_CODE + "'>" + d.BRANCH_NAME + "</option>"
          })
          e1.html(baseFullOption)
          e1.append(str)
      })
  }
  setGrids = function (id, e1, e2) {
      var latn_id = $("#v_city option:selected").val()
      var bureau_no = $("#v_area option:selected").val()
      $.post(parent.url4Query, {
          eaction: "setgrids",
          id: id,
          latn_id: latn_id,
          bureau_no: bureau_no
      }, function (data) {
          data = $.parseJSON(data);
          e1.unbind();
          e1.on("change", function () {
              e2.click();
              var grid_id = $("#v_grid option:selected").val();
              if (grid_id != "")//#0087d4
                  $("#xinjian1").css({"background-color": "#0087d4"});
              else
                  $("#xinjian1").css({"background-color": "#989A9B"});
          })
          var str = ''
          $.each(data, function (i, d) {
              str += "<option value='" + d.GRID_ID + "' value1='" + d.STATION_ID + "' value2='" + d.GRID_ZOOM + "'>" + d.GRID_NAME + "</option>"
          })
          e1.html(baseFullOption)
          e1.append(str)
      })
  }
  
  function villageSummaryCount(city_id,bureau_no,branch_type,union_org_code,grid_id){
  	$.post(parent.url4Query,
  			{
  				"eaction":"village_summary_count",
  				"latn_id":city_id,
					"bureau_no":bureau_no,
					"union_org_code":union_org_code,
					"branch_type":branch_type,
					"grid_id":grid_id
  			},function(data){
  				data = $.parseJSON(data);
  				$("#village_summary_count").append("<span>汇总：小区<font color='#fc8500'>"+data.COUNT_SUM+"</font>个，城市<font color='#fc8500'>"+data.COUNT_A1+"</font>个，农村<font color='#fc8500'>"+data.COUNT_B1+"</font>个</span>");
  			}
  	);
  }
	function villageSummaryScroll(city_id,bureau_no,branch_type,union_org_code,grid_id,page){
		$.post(parent.url4Query,
					  {"eaction":"village_summary_list",
							"latn_id":city_id,
							"bureau_no":bureau_no,
							"union_org_code":union_org_code,
							"branch_type":branch_type,
							"grid_id":grid_id,
							"page":page
						},function(data){
								data = $.parseJSON(data);
								for(var i =0,l = data.length;i<l;i++){
									var d = data[i];
									var tr_str = "<tr>";
									tr_str += "<td width=\"50\" style=\"text-align:center;\">"+(++seq_um)+"</td>"+
														"<td width=\"60\" style=\"text-align:center;\">"+(d.LATN_NAME)+"</td>"+
														"<td width=\"100\">"+(d.BUREAU_NAME)+"</td>"+
														"<td width=\"40\">"+(d.BRANCH_TYPE_TEXT)+"</td>"+
														"<td width=\"120\">"+(d.BRANCH_NAME)+"</td>"+
														"<td width=\"120\">"+(d.GRID_NAME)+"</td>"+
														"<td width=\"90\" style=\"color:#fc8500;\">"+(d.VILLAGE_NAME)+"</td>"+
														"<td width=\"50\" style=\"font-weight:bold;text-align:center;\">"+(d.BUILD_SUM)+"</td>"+
														"<td width=\"50\" style=\"font-weight:bold;text-align:center;\">"+(d.ZHU_HU_SUM)+"</td>"+
														"<td width=\"80\" style=\"font-weight:bold;text-align:center;\">"+(d.PORT_SUM)+"</td>"+
														"<td width=\"60\" style=\"font-weight:bold;text-align:center;\">"+(d.PORT_USED_SUM)+"</td>"+
														"<td width=\"60\" style=\"font-weight:bold;text-align:center;\">"+(d.PORT_FREE_SUM)+"</td>"+
														"<td width=\"50\" style=\"text-align:center;\">"+(d.MARKET_LV)+"</td>"+
														"<td width=\"50\" style=\"text-align:center;\">"+(d.PORT_LV)+"</td>";
														
									tr_str += "</tr>";
									$("#village_summary_table").append(tr_str);
								}
						}
		);
	}
		
</script>

