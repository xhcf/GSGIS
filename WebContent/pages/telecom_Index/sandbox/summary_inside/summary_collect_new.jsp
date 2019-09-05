<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="grid_list">
  SELECT '-1' CODE, '全部' TEXT FROM DUAL UNION ALL
  SELECT GRID_ID CODE,GRID_NAME TEXT FROM gis_data.db_cde_grid
  where UNION_ORG_CODE = '${param.substation }'
  and grid_status = 1 AND GRID_UNION_ORG_CODE <> '-1'
</e:q4l>
<e:q4o var="query_table_name">
    SELECT DISTINCT LATN_ID,bureau_no,union_org_code FROM ${gis_user}.db_cde_grid where UNION_ORG_CODE = '${param.substation }'
</e:q4o>
<html>
<head>
    <title>竞争收集（单标签）</title>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <style>
        .red_font {color:red;}

        .tab_header tr th:first-child {width:6%!important;}
        .tab_header tr th:nth-child(2) {width:6%!important;}
        .tab_header tr th:nth-child(3) {width:6%!important;}
        .tab_header tr th:nth-child(4) {width:16%!important;}
        .tab_header tr th:nth-child(5) {width:15%!important;}
        .tab_header tr th:nth-child(6) {width:10%!important;}
        .tab_header tr th:nth-child(7) {width:15%!important;}
        .tab_header tr th:nth-child(8) {width:10%!important;}
        .tab_header tr th:nth-child(9) {width:10%!important;}
        .tab_header tr th:nth-child(10) {width:6%!important;}

        #collect_new_bulid_info_list tr td:first-child {width:6%!important;}
        #collect_new_bulid_info_list tr td:nth-child(2) {width:6%!important;}
        #collect_new_bulid_info_list tr td:nth-child(3) {width:6%!important;}
        #collect_new_bulid_info_list tr td:nth-child(4) {width:16%!important;}
        #collect_new_bulid_info_list tr td:nth-child(5) {width:15%!important;}
        #collect_new_bulid_info_list tr td:nth-child(6) {width:10%!important;}
        #collect_new_bulid_info_list tr td:nth-child(7) {width:15%!important;}
        #collect_new_bulid_info_list tr td:nth-child(8) {width:10%!important;}
        #collect_new_bulid_info_list tr td:nth-child(9) {width:10%!important;}
        #collect_new_bulid_info_list tr td:nth-child(10) {width:6%!important;}
    </style>
</head>
<body>
<div id="collect_new_sub_name" class="sub_name"></div>

<div id="collect_new_body">
    <div class="info_village">
        <span>小区数： <span id="collect_new_village_count">--</span></span>
        <span>, 楼宇数： <span id="collect_new_build_count">--</span></span>
        <span>, 住户数： <span id="collect_new_user_count">--</span></span>
        <span>, 应收集： <span id="collect_new_collect_off">--</span></span>
        <span>, 已收集： <span id="collect_new_collect_on">--</span></span>
        <span>, 收集率： <span id="collect_new_collect_rate">--</span></span>
    </div>
    <div class="collect_new_choice">
        <div class="collect_contain_choice" style="margin-left: 15px">
            网格:<e:select items="${grid_list.list }" label="TEXT"
                         value="CODE" id="collect_new_grid_list" name="collect_new_grid_list" onchange="load_village_list()"/>
        </div>
        <div class="collect_contain_choice">
            小区:
            <select id="collect_new_village_list" onchange="load_build_list(true)"></select>
            <input type="text" id="collect_new_village_name" oninput="load_village_name_list()"/>
            <ul id="collect_new_village_name_list">
            </ul>
        </div>
        <div class="collect_contain_choice">
            楼宇:
            <select id="collect_new_build_list1" onchange="load_build_info(0)"></select>
            <input type="text" id="collect_new_build_name1" oninput="load_build_name_list()" style="height:20px!important;">
            <ul id="collect_new_build_name_list">
            </ul>
        </div>
    </div>
    <div class="collect_new_state_wrapper">
        <div id="collect_new_collect_state" class="tab_accuracy_head follow_head small_padding">
            收集: <span class="active" onclick="select_collect_state(0)"> 全部<span id="collect_new_all_count"></span></span>
           <span onclick="select_collect_state(1)"> 未收集<span id="collect_new_off_count"></span></span>
           <span onclick="select_collect_state(2)"> 已收集<span id="collect_new_on_count"></span></span>
        </div>
        <div id="collect_bselect" class="tab_accuracy_head follow_head small_padding">
            运营商:<span class="active" onclick="select_collect_band(-1)">全部<span id="collect_new_a_count"></span></span>
         <span onclick="select_collect_band(5)"> 电信<span id="collect_new_d_count"></span></span>
         <span onclick="select_collect_band(1)"> 移动<span id="collect_new_y_count"></span></span>
         <span onclick="select_collect_band(2)"> 联通<span id="collect_new_l_count"></span></span>
         <span onclick="select_collect_band(3)"> 广电<span id="collect_new_g_count"></span></span>
         <span onclick="select_collect_band(4)"> 其他<span id="collect_new_q_count"></span></span>
         <span onclick="select_collect_band(0)"> 未装<span id="collect_new_n_count"></span></span>
        </div>
    </div>
    <div class="grid_count_title grid_count_title_small">
        选定楼宇:<span id="collect_new_select_build"></span>
    </div>
    <div>
        <div class="head_table_wrapper">
            <table class="head_table tab_header">
                <%--<tr>
                    <th style="width: 40px;" rowspan="2">序号</th>
                    <th style="width: 60px;" rowspan="2">房间号</th>
                    <th style="width: 100px;" rowspan="2">联系方式</th>
                    <th colspan="3">宽带</th>
                    <th colspan="3">ITV</th>
                    <th style="width: 50px;" rowspan="2">操作</th>
                </tr>
                <tr>
                    <th style="width: 70px;">运营商</th>
                    <th style="width: 70px;">到期时间</th>
                    <th style="width: 70px;">资费</th>
                    <th style="width: 70px;">运营商</th>
                    <th style="width: 70px;">到期时间</th>
                    <th style="width: 70px;">资费</th>
                </tr>--%>
                    <th>  </th>
                    <th>序号</th>
                    <th>房间号</th>
                    <th>联系人</th>
                    <th>联系电话</th>
                    <th>宽带运营商</th>
                    <th>宽带到期时间</th>
                    <th>异网收集</th>
                    <th>状态</th>
                    <th>操作</th>
            </table>
        </div>
        <div id="collect_new_table_content" class="t_table">
            <table class="content_table" id="collect_new_bulid_info_list" style="width: 100%"></table>
        </div>
    </div>
 </div>
</body>
</html>
<script>
  var seq_num = 0, collect_state = 0, collect_bselect = -1;
  //表示是否选中, 选中:点击input下拉框选中, select选中.
  var select_count = 0;
  var url = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary_inside.jsp' />";
  var url1 = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_build_action.jsp' />";
  var query_table_name = "sde.map_addr_segm_" + ${query_table_name.LATN_ID};
  $(function() {
	  $("#collect_new_sub_name").text(sub_name);
	  $("select[name=collect_new_grid_list]").change();
      //load_village_list();
	  load_collect_basic_info();

      $("#collect_bselect > span").each(function (index) {
          $(this).on("click", function () {
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
      $("#collect_new_collect_state > span").each(function (index) {
          $(this).on("click", function () {
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
  });

  //做名字查询时使用
  var village_list = [];
  /*以下部分为联动===start*/
  function load_village_list() {
	  var $village_list =  $("#collect_new_village_list");
	  $village_list.empty();
	  village_list = [];
	  var params = {
          eaction: "collect_new_village_list",
          grid_id: $("select[name=collect_new_grid_list]").val() == '-1' ? '' : $("select[name=collect_new_grid_list]").val(),
          substation: substation
	  };
	  $.post(url, params, function(data) {
		  data = $.parseJSON(data);
		  if (data.length != 0) {
			  var d, newRow = "<option value='-1' selected>全部</option>";
			  for (var i = 0, length = data.length; i < length; i++) {
				  d = data[i];
				  newRow += "<option value='" + d.VILLAGE_ID + "' >" + d.VILLAGE_NAME + "</option>";
				  village_list.push(d);
			  }
			  $village_list.append(newRow);
		  }
		  load_build_list();
	  })
  }

  function load_village_name_list() {
	  setTimeout(function() {
		  //下拉列表显示
		  var $village_list =  $("#collect_new_village_name_list");
		  $village_list.empty();
		  var village_name = $("#collect_new_village_name").val().trim();
		  if (village_name != '') {
			  var temp;
			  var newRow = "";
			  for (var i = 0, length = village_list.length, count = 0; i < length; i++) {
	              if ((temp = village_list[i].VILLAGE_NAME).indexOf(village_name) != -1) {
	            	  newRow += "<li title='" + temp + "' onclick='select_village(\""+ temp + "\",\"" +
	            	  village_list[i].VILLAGE_ID + "\"," + i + ")'>" + temp + "</li>";
	            	  count++;
	              }
	              if (count >= 15) {
	            	  break;
	              }
	          }
			  $village_list.append(newRow);
			  $("#collect_new_village_name_list").show();
		  } else {
			  $("#collect_new_village_name_list").hide();
		  }
		  //联动改变 select框, 只要不做点击, 都会将select改回全部.
		  if (select_count < 1) {
			    $("#collect_new_village_list option:eq(0)").attr('selected','selected');
		  }
		  select_count++;
		  load_build_list(false);
	  }, 300)
  }

  function before_load_build_list() {
	  //$("#collect_new_build_name1").val("");
      clear_data();
      clear_has_selected();
      $("#collect_new_select_build").html("");
	  $("#collect_new_all_count").html("(0)");
      $("#collect_new_off_count").html("(0)");
      $("#collect_new_on_count").html("(0)");
      $("#collect_new_a_count").html("(0)");
      $("#collect_new_d_count").html("(0)");
      $("#collect_new_y_count").html("(0)");
      $("#collect_new_l_count").html("(0)");
      $("#collect_new_g_count").html("(0)");
      $("#collect_new_q_count").html("(0)");
      $("#collect_new_n_count").html("(0)");
  }

  //做名字查询时使用, 数据库太慢
  var build_list = [];
  //flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.
  function load_build_list(selected) {
	  var $build_list =  $("#collect_new_build_list1");
	  before_load_build_list();
	  //如果是通过 select选择的话,select_count重新开始计数.
	  if (selected) {
		  select_count = 0;
	  }
	  //只有当第一次改变input的时候将值置位1;
	  if (select_count <= 1) {
		  $build_list.empty();
	      build_list = [];
	      //回写,且只有在手动选中的时候才进行回写.
	      if (select_count == 0) {
	    	    $("#collect_new_village_name").val($("#collect_new_village_list").find("option:selected").text());
	      }
	      var params = {
	              eaction: "collect_new_build_list",
	              grid_id: $("select[name=collect_new_grid_list]").val() == '-1' ? '' : $("select[name=collect_new_grid_list]").val(),
	              village_id: $("#collect_new_village_list").val() == '-1' ? '' : $("#collect_new_village_list").val(),
	              substation: substation,
                  table_name: query_table_name
	      };
	      $.post(url, params, function(data) {
	          data = $.parseJSON(data);
	          if (data.length != 0) {
	              var d, newRow = "<option value='-1'></option>";
	              for (var i = 0, length = data.length; i < length; i++) {
	                  d = data[i];
	                  newRow += "<option value='" + d.SEGM_ID + "' selected>" + d.STAND_NAME + "</option>";
	                  build_list.push(d);
	              }
	              $build_list.append(newRow);

                  checkDefaultOption();

                  //load_build_info(true);
	          }
	      })
	  }
  }

  function checkDefaultOption(){
      $('#collect_new_build_list1').get(0).selectedIndex = 1;
      $('#collect_new_build_list1').trigger("change");
  }

  function load_build_name_list() {
      setTimeout(function() {
          //下拉列表显示
          var $build_list =  $("#collect_new_build_name_list");
          $build_list.empty();
          if (select_count <= 1) {
        	  before_load_build_list();
          }

          var build_name = $("#collect_new_build_name1").val().trim();
          if (build_name != '') {
              var temp;
              var newRow = "";
              for (var i = 0, length = build_list.length, count = 0; i < length; i++) {
                  if ((temp = build_list[i].STAND_NAME).indexOf(build_name) != -1) {
                      newRow += "<li title='" + temp + "' onclick='select_build(\""+ temp + "\",\"" +
                      build_list[i].SEGM_ID + "\"," + i + ")'>" + temp + "</li>";
                      count++;
                  }
                  if (count >= 15) {
                      break;
                  }
              }
              $build_list.append(newRow);
              $("#collect_new_build_name_list").show();
          } else {
        	  $("#collect_new_build_name_list").hide();
          }

          //联动改变 select框, 只要不做点击, 都会将select改回全部.
          $("#collect_new_build_list option:eq(0)").attr('selected','selected');
          select_count++;
      }, 300)
  }

  function select_village(name, id, index) {
	  $("#collect_new_village_list option[value=" + id + "]").attr('selected','selected');
	  $("#collect_new_village_name_list").hide();
	  $("#collect_new_village_list").change();
  }

  function select_build(name, id, index) {
      $("#collect_new_build_list1 option[value=" + id + "]").attr('selected','selected');
      $("#collect_new_build_name_list").hide();
      $("#collect_new_build_list1").change();
  }
  /*以上部分为联动===end*/

  function select_collect_state(type) {
	  collect_bselect = -1;
	  collect_state = type;
	  load_build_info(1);
  }

  function select_collect_band(type) {
	  collect_state = 0;
	  collect_bselect = type;
	  load_build_info(1);
  }

  //为1保存选择条件,否则清除所有条件, 清除已选择.
  function before_load_bulid_info(flag) {
	  if (flag) {
          var temp1 = collect_state, temp2 = collect_bselect;
          clear_data();
          collect_state = temp1, collect_bselect =temp2;
      } else {
          clear_data();
          clear_has_selected();
      }
  }
  //加载选择楼宇的统计信息
  function load_build_count_info() {
	  //选择楼宇后清空输入计数器
	  select_count = 0;
	  var params = {
			  eaction: "collect_new_count",
			  build_id: $("#collect_new_build_list1").val()
	  };
	  $.post(url, params, function(data) {
		  if (data != null && data.trim() != 'null') {
			  data = JSON.parse(data);
              $("#collect_new_all_count").html("(" + data.A_COUNT + ")");
              $("#collect_new_off_count").html("(" + data.OFF_COUNT + ")");
              $("#collect_new_on_count").html("(" + data.ON_COUNT + ")");
              $("#collect_new_a_count").html("(" + data.A_COUNT + ")");
              $("#collect_new_d_count").html("(" + data.D_COUNT + ")");
              $("#collect_new_y_count").html("(" + data.Y_COUNT + ")");
              $("#collect_new_l_count").html("(" + data.L_COUNT + ")");
              $("#collect_new_g_count").html("(" + data.G_COUNT + ")");
              $("#collect_new_q_count").html("(" + data.Q_COUNT + ")");
              $("#collect_new_n_count").html("(" + data.N_COUNT + ")");
          } else {
        	  $("#collect_new_all_count").html("(0)");
        	  $("#collect_new_off_count").html("(0)");
        	  $("#collect_new_on_count").html("(0)");
        	  $("#collect_new_a_count").html("(0)");
              $("#collect_new_d_count").html("(0)");
              $("#collect_new_y_count").html("(0)");
              $("#collect_new_l_count").html("(0)");
              $("#collect_new_g_count").html("(0)");
              $("#collect_new_q_count").html("(0)");
              $("#collect_new_n_count").html("(0)");
          }
	  })

  }

  var load_build_info = function (flag) {
	  //选中文本回写进 input
	  var text = $("#collect_new_build_list1").find("option:selected").text();
	  $("#collect_new_build_name1").val(text);
	  $("#collect_new_select_build").html(text);

	  before_load_bulid_info(flag);
	  load_build_count_info();

	  var build_id = $("#collect_new_build_list1").val();
	  var $build_list = $("#collect_new_bulid_info_list");
	  if (build_id != "-1") {
		  var params = {
              eaction: "collect_new_build_info",
              build_id: build_id,
              res_id: build_id,
              collect_state: collect_state,
              collect_bselect: collect_bselect
	      };
		  $.post(url1, params, function(data) {
			  data = $.parseJSON(data);
              if(!data.length){
                  $build_list.append("<tr><td colspan=10>未查到记录</td></tr>");
                  return;
              }
			  /*for (var i = 0, l = data.length; i < l; i++) {
                  var d = data[i];
                  var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
                  //if (d.IS_DX == '0') {
                  if(d.SERIAL_NO==2)//政企
                      newRow += "<td style='width: 60px'><span class='zhengqi_flag'>政</span>" + "<a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a></td>";
                  else if(d.SERIAL_NO==1 || d.SERIAL_NO==4)//普通住户
                      newRow += "<td style='width: 60px'>" + "<a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a></td>";
                  //} else {
                  //      newRow += "<td style='width: 60px'>" + d.SEGM_NAME_2 + "</td>";
                  //}
                  newRow += "<td style='width: 100px'>" + d.CONNECT_INFO + "</td>";
                  if(d.IS_KD_DX>0)
                      newRow += "<td style='width: 70px'>" + d.KD_BUSINESS + "(<span class='red_font'>"+ d.IS_KD_DX +"</span>)</td>";
                  else
                      newRow += "<td style='width: 70px'>" + d.KD_BUSINESS + "</td>";
                  newRow += "<td style='width: 70px'>" + d.KD_DQ_DATE +
                  "</td><td style='width: 70px'>" + d.KD_XF + "</td><td style='width: 70px'>" + d.ITV_BUSINESS + "</td><td style='width: 70px'>" + d.ITV_DQ_DATE +
                  "</td><td style='width: 70px'>" + d.ITV_XF + "</td><td style='width: 50px'>";
                  //if (d.IS_DX == '0') {
                      newRow += "<a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>收集</a></td></tr>";
                  //} else {
                  //    newRow += "</tr>"
                  //}
                  $build_list.append(newRow);
              }*/
              for (var i = 0, l = data.length; i < l; i++) {
                  var d = data[i];
                  //var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
                  var newRow = "<tr><td class='buss_ico'>";
                  if(d.IS_DX>0)
                  //电信
                      newRow += "<span class='dx_ico'></span>";
                  else if(d.KD_BUS_FLAG==0)
                  //未装
                      newRow += "<span class='none_ico'></span>";
                  else if(d.KD_BUS_FLAG==1)
                  //移动
                      newRow += "<span class='yd_ico'></span>";
                  else if(d.KD_BUS_FLAG==2)
                  //联通
                      newRow += "<span class='lt_ico'></span>";
                  else if(d.KD_BUS_FLAG==3)
                  //广电
                      newRow += "<span class='gd_ico'></span>";
                  else if(d.KD_BUS_FLAG==4)
                  //其他
                      newRow += "<span class='other_ico'></span>";
                  //else if(d.KD_BUS_FLAG==5)
                  //电信
                  newRow += "</td>";
                  //if (d.IS_DX == '0') {

                  newRow += "<td>"+(i+1)+"</td>";

                  newRow += "<td class='bold_blue'>";
                  if(d.SERIAL_NO==2)//政企
                      newRow += "<span class='zhengqi_flag'>政</span><a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a></td>";
                  else if(d.SERIAL_NO==1 || d.SERIAL_NO==4)//普通住户
                      newRow += "<a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a></td>";

                  //} else {
                  //      newRow += "<td style='width: 100px' class='bold_blue'>" + d.SEGM_NAME_2 + "</td>";
                  //}
                  newRow += "<td>" + d.CONTACT_PERSON + "</td>"
                  +"<td 'class='num_blue'>" + d.CONTACT_NBR + "</td>";
                  if(d.KD_BUSINESS!='电信')
                      newRow += "<td class='buss_red'>" + d.KD_BUSINESS + "</td>";
                  else
                      newRow += "<td >" + d.KD_BUSINESS + "(<span class='red_font'>"+ d.IS_KD_DX +"</span>)</td>";

                  newRow += "<td >" + d.KD_DQ_DATE + "</td>"
                      //+"<td style='width: 100px;'>" + d.MKT_CONTENT + "</td>"
                  +"<td>" + d.COLLLECT_FLAG + "</td>"
                  +"<td>" + d.STOP_TYPE_NAME + "</td>";
                  //if(d.KD_BUSINESS!='电信')///20181204 电信不收集
                    newRow += "<td><a href='javascript:void(0);' onclick='openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>收集</a></td>";
                  //else
                  //  newRow += "<td></td>";
                  newRow += "</tr>"
                  $build_list.append(newRow);
              }
	          if (data.length == 0 && flag) {
	        	  $build_list.empty();
	        	  $build_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)' \">没有查询到数据</td></tr>")
	              return;
	          }

		  })
	  }

  }

  collect_new_load_build_info = load_build_info;

  //清除已选中的样式, 一般需要在标签页切换时调用.
  function clear_has_selected() {
      $("#collect_bselect > span").removeClass("active");
      $("#collect_bselect > span").eq(0).addClass("active");
      $("#collect_new_collect_state > span").removeClass("active");
      $("#collect_new_collect_state > span").eq(0).addClass("active");
  }

  function clear_data() {
	  collect_bselect = -1, seq_num = 0, collect_state = 0;
	  $("#collect_new_bulid_info_list").empty();
  }

  function load_collect_basic_info() {

      var params = {
          eaction: "collect_new_bsif",
          substation: substation
      }

      $.post(url, params, function (data) {
          if (data != null && data.trim() != 'null') {
              data = $.parseJSON(data);
              $("#collect_new_village_count").html(data.V_COUNT);
              $("#collect_new_build_count").html(data.B_COUNT);
              $("#collect_new_user_count").html(data.R_COUNT);
              $("#collect_new_collect_off").html(data.A_COUNT);
              $("#collect_new_collect_on").html(data.ON_COUNT);
              $("#collect_new_collect_rate").html(data.C_RATE);
          } else {
        	  $("#collect_new_village_count").html("--");
              $("#collect_new_build_count").html("--");
              $("#collect_new_user_count").html("--");
              $("#collect_new_collect_off").html("--");
              $("#collect_new_collect_on").html("--");
              $("#collect_new_collect_rate").html("--");
          }
      })
  }
</script>