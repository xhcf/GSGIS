<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<html>
<head>
    <title>竞争收集</title>
    <link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_level.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
    <style>
        #collect_new_collect_state1{float:left;}
        #collect_bselect1{float:right;}
        #collect_new_collect_state1,#collect_bselect1{display: inline-block;}
        .village_view_win .tab_box div .desk_orange_bar {
            text-align: center;
        }
    </style>
</head>
<body>
<div id="collect_new_body">
    <tr>
        <td>
            <div class="count_num" style ="background-color:#FAB900;width:100%;text-align:center;font-weight:bold;padding-top:0px;line-height:28px;">
                小区住户：<span id="zhqd_all" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                未装住户：<span id="zhqd_wz" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                电信：<span id="zhqd_dx" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                移动：<span id="zhqd_yd" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                联通：<span id="zhqd_lt" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                广电：<span id="zhqd_gd" style ="color:#FF0000">0</span>&nbsp;&nbsp;
                其他：<span id="zhqd_qt" style ="color:#FF0000">0</span>
            </div>
        </td>
    </tr>
    <div class="collect_new_choice" style ="position:relative;padding-top:5px;color:black;width:100%;">
        <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
            楼宇:
            <select id="collect_new_build_list1"onchange="load_build_info1(0)" style="width: 92%;padding-left:0px;"></select>
            <input type="text" id="collect_new_build_name1" style="width: 80%;border:none;height:18px!important;line-height:18px!important;margin:1px;" oninput="load_build_name_list1()">
            <ul id="collect_new_build_name1_list1">
            </ul>
        </div>
    </div>
    <div class="collect_new_state_wrapper" style="width:96%;margin:0px auto;padding-left:0px;">
        <div id="collect_new_collect_state1" class="tab_accuracy_head follow_head small_padding" style="display: none;">
            收集: <span class="active" onclick="select_collect_state1(0)" id="collect_all1_first"> 全部<span id="collect_new_all_count1"></span></span>
           <span onclick="select_collect_state1(1)"> 未收集<span id="collect_new_off_count1"></span></span>
           <span onclick="select_collect_state1(2)"> 已收集<span id="collect_new_on_count1"></span></span>
        </div>
        <div id="collect_bselect1"  align="left" class="tab_accuracy_head follow_head small_padding" style="float:left;">运营商:<span class="active" onclick="select_collect_band1(-1)" id="collect_all1">全部<span id="collect_new_a_count1"></span></span>
         <span onclick="select_collect_band1(5)"> 电信<span id="collect_new_d_count1"></span></span>
         <span onclick="select_collect_band1(1)"> 移动<span id="collect_new_y_count1"></span></span>
         <span onclick="select_collect_band1(2)"> 联通<span id="collect_new_l_count1"></span></span>
         <span onclick="select_collect_band1(3)"> 广电<span id="collect_new_g_count1"></span></span>
         <span onclick="select_collect_band1(4)"> 其他<span id="collect_new_q_count1"></span></span>
         <span onclick="select_collect_band1(0)"> 未装<span id="collect_new_n_count1"></span></span>
        </div>
    </div>
    <div class="grid_count_title grid_count_title_small" style="display: none;">
        选定楼宇:<span id="collect_new_select_build11"></span>
    </div>
    <div style="width:96%;margin:0px auto;">
        <div class="head_table_wrapper">
            <table class="head_table">
                <tr>
                    <th style="width: 40px;" rowspan="2">序号</th>
                    <th style="width: 60px;" rowspan="2">房间号</th>
                    <th style="width: 100px;" rowspan="2">联系方式</th>
                    <th colspan="3">宽带</th>
                    <th colspan="3">ITV</th>
                </tr>
                <tr>
                    <th style="width: 70px;">运营商</th>
                    <th style="width: 70px;">到期时间</th>
                    <th style="width: 70px;">资费</th>
                    <th style="width: 70px;">运营商</th>
                    <th style="width: 70px;">到期时间</th>
                    <th style="width: 70px;">资费</th>
                </tr>
            </table>
        </div>
        <div id="collect_new_table_content1" class="t_table" >
            <table class="content_table" id="collect_new_bulid_info_list1" style="width: 100%;"></table>
        </div>
    </div>
 </div>
</body>
</html>
<script>
  var seq_num = 0, collect_state = 0, collect_bselect1 = -1;
  //var village_id = '${param.village_id}';
  //表示是否选中, 选中:点击input下拉框选中, select选中.
  var select_count = 0;
  console.log("add6 build_id:"+parent.common_bulid_id);
  var url_zhqd = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action1.jsp' />";
  $(function() {
	  //load_collect_basic_info();
      load_build_list1(true);
      load_build_head_count_info1();

      $("#collect_bselect1 > span").each(function (index) {
          $(this).on("click", function () {
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
      $("#collect_new_collect_state1 > span").each(function (index) {
          $(this).on("click", function () {
              $(this).addClass("active").siblings().removeClass("active");
          })
      });
      $("#collect_bselect1 > span").each(function (index) {
          $(this).on("click", function () {
              $("#collect_new_collect_state1 > span").removeClass("active");
              $("#collect_new_collect_state1 > span").eq(0).addClass("active");
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
      $("#collect_new_collect_state1 > span").each(function (index) {
          $(this).on("click", function () {
              $("#collect_bselect1 > span").removeClass("active");
              $("#collect_bselect1 > span").eq(0).addClass("active");
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
  });

  //做名字查询时使用
  /*以下部分为联动===start*/

  function before_load_build_list1() {
	  //$("#collect_new_build_name1").val("");
      clear_data1();
      clear_has_selected1();
      $("#collect_new_select_build11").html("");
	  $("#collect_new_all_count1").html("(0)");
      $("#collect_new_off_count1").html("(0)");
      $("#collect_new_on_count1").html("(0)");
      $("#collect_new_a_count1").html("(0)");
      $("#collect_new_d_count1").html("(0)");
      $("#collect_new_y_count1").html("(0)");
      $("#collect_new_l_count1").html("(0)");
      $("#collect_new_g_count1").html("(0)");
      $("#collect_new_q_count1").html("(0)");
      $("#collect_new_n_count1").html("(0)");
  }

  //做名字查询时使用, 数据库太慢
  var build_list = [];
  //flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.
  function load_build_list1(selected) {
	  var $build_list =  $("#collect_new_build_list1");
	  before_load_build_list1();
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
	              village_id: village_id
	      };
	      var name,id = "";
	      $.post(url_zhqd, params, function(data) {
	          data = $.parseJSON(data);
	          if (data.length != 0) {
	              var d, newRow = "<option value='-1' select='selected'>全部</option>";
	              for (var i = 0, length = data.length; i < length; i++) {
	                  d = data[i];
	                  if(i==0){
                          newRow += "<option value='" + d.SEGM_ID + "'>" + d.STAND_NAME + "</option>";
                          name = d.STAND_NAME;
                          id = d.SEGM_ID;
                      }
	                  else
	                    newRow += "<option value='" + d.SEGM_ID + "'>" + d.STAND_NAME + "</option>";
	                  build_list.push(d);
	              }
                  $build_list.append(newRow);
                  //select_build1(name, id, 0);

                  //初始化选中
                  var text = $("#collect_new_build_list1").find("option:selected").text();
                  $("#collect_new_build_name1").val(text);
	          }

	      })
	  }
  }

  function load_build_name_list1() {
      setTimeout(function() {
          //下拉列表显示
          var $build_list =  $("#collect_new_build_name1_list1");
          $build_list.empty();
          if (select_count <= 1) {
        	  before_load_build_list1();
          }

          var build_name = $("#collect_new_build_name1").val().trim();
          if (build_name != '') {
              var temp;
              var newRow = "";
              for (var i = 0, length = build_list.length, count = 0; i < length; i++) {
                  if ((temp = build_list[i].STAND_NAME).indexOf(build_name) != -1) {
                      newRow += "<li title='" + temp + "' onclick='select_build1(\""+ temp + "\",\"" +
                      build_list[i].SEGM_ID + "\"," + i + ")'>" + temp + "</li>";
                      count++;
                  }
                  if (count >= 15) {
                      break;
                  }
              }
              $build_list.append(newRow);
              $("#collect_new_build_name1_list1").show();
          } else {
        	  $("#collect_new_build_name1_list1").hide();
          }

          //联动改变 select框, 只要不做点击, 都会将select改回全部.
         // $("#collect_new_build_list1 option:eq(0)").attr('selected','selected');
          select_count++;
      }, 800)
  }



  function select_build1(name, id, index) {
      $("#collect_new_build_list1 option[value=" + id + "]").attr('selected','selected');
      $("#collect_new_build_name1_list1").hide();
      $("#collect_new_build_list1").change();
  }
  /*以上部分为联动===end*/

  function select_collect_state1(type) {
	  collect_bselect1 = -1;
	  collect_state = type;
	  load_build_info1(1);
  }

  function select_collect_band1(type) {
	  collect_state = 0;
	  collect_bselect1 = type;
	  load_build_info1(1);
  }


  //为1保存选择条件,否则清除所有条件, 清除已选择.
  function before_load_bulid_info1(flag) {
	  if (flag) {
          var temp1 = collect_state, temp2 = collect_bselect1;
          clear_data1();
          collect_state = temp1, collect_bselect1 =temp2;
      } else {
          clear_data1();
          clear_has_selected1();
      }
  }
  //加载选择楼宇的统计信息
  function load_build_count_info1() {
	  //选择楼宇后清空输入计数器
	  select_count = 0;
	  var params = {
			  eaction: "collect_new_count",
			  build_id: $("#collect_new_build_list1").val()
	  };
	  $.post(url_zhqd, params, function(data) {
		  if (data != null && data.trim() != 'null') {
			  data = JSON.parse(data);
              $("#collect_new_all_count1").html("(" + data.A_COUNT + ")");
              $("#collect_new_off_count1").html("(" + data.OFF_COUNT + ")");
              $("#collect_new_on_count1").html("(" + data.ON_COUNT + ")");
              $("#collect_new_a_count1").html("(" + data.A_COUNT + ")");
              $("#collect_new_d_count1").html("(" + data.D_COUNT + ")");
              $("#collect_new_y_count1").html("(" + data.Y_COUNT + ")");
              $("#collect_new_l_count1").html("(" + data.L_COUNT + ")");
              $("#collect_new_g_count1").html("(" + data.G_COUNT + ")");
              $("#collect_new_q_count1").html("(" + data.Q_COUNT + ")");
              $("#collect_new_n_count1").html("(" + data.N_COUNT + ")");
          } else {
        	  $("#collect_new_all_count1").html("(0)");
        	  $("#collect_new_off_count1").html("(0)");
        	  $("#collect_new_on_count1").html("(0)");
        	  $("#collect_new_a_count1").html("(0)");
              $("#collect_new_d_count1").html("(0)");
              $("#collect_new_y_count1").html("(0)");
              $("#collect_new_l_count1").html("(0)");
              $("#collect_new_g_count1").html("(0)");
              $("#collect_new_q_count1").html("(0)");
              $("#collect_new_n_count1").html("(0)");
          }
	  })

  }
  //加载选择楼宇黄标统计信息
  function load_build_head_count_info1() {
      //选择楼宇后清空输入计数器
      var params = {
          eaction: "collect_new_count_head",
          village_id: village_id
      };
      $.post(url_zhqd, params, function(data) {
          if (data != null && data.trim() != 'null') {
              data = JSON.parse(data);
             $("#zhqd_all").text(data.A_COUNT);
              $("#zhqd_wz").text(data.N_COUNT);
              $("#zhqd_dx").text(data.D_COUNT);
              $("#zhqd_yd").text(data.Y_COUNT);
              $("#zhqd_lt").text(data.L_COUNT);
              $("#zhqd_gd").text(data.G_COUNT);
              $("#zhqd_qt").text(data.Q_COUNT );
          } else {
              $("#zhqd_all").text(0);
              $("#zhqd_wz").text(0);
              $("#zhqd_dx").text(0);
              $("#zhqd_yd").text(0);
              $("#zhqd_lt").text(0);
              $("#zhqd_gd").text(0);
              $("#zhqd_qt").text(0);
          }
      })

  }

  var load_build_info1 = function (flag) {

      if(flag==2)
      {
          $("#collect_new_build_list1 option[value=" + parent.common_bulid_id + "]").attr('selected','selected');
          //默认选中第一个span
          //$("#collect_new_a_count1").addClass("active").siblings().removeClass("active");
          // $("#collect_new_a_count1").attr('selected','selected');
          build_id=parent.common_bulid_id;
          clear_data1();
      }
      $("#collect_all1").addClass("active").siblings().removeClass("active");
      $("#collect_all1_first").addClass("active").siblings().removeClass("active");
	  //选中文本回写进 input
	  var text = $("#collect_new_build_list1").find("option:selected").text();
	  $("#collect_new_build_name1").val(text);
	  $("#collect_new_select_build11").html(text);

	  before_load_bulid_info1(flag);
	  load_build_count_info1();

	  var build_id = $("#collect_new_build_list1").val();
      parent.common_bulid_id=build_id;

      var $build_list = $("#collect_new_bulid_info_list1");
      $build_list.empty();
	  if (build_id != "-1") {
		  var params = {
	              eaction: "collect_new_build_info",
	              build_id: build_id,
	              collect_state: collect_state,
	              collect_bselect: collect_bselect1

	      };
		  $.post(url_zhqd, params, function(data) {
              seq_num=0;
			  data = $.parseJSON(data);
			  for (var i = 0, l = data.length; i < l; i++) {
                  var d = data[i];
                  var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
                  if (d.IS_DX == '0') {
                        newRow += "<td style='width: 60px;text-align:center;'>" + "<a href='javascript:void(0);' onclick='parent.openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>" + d.SEGM_NAME_2 + "</a></td>";
                  } else {
                        newRow += "<td style='width: 60px'>" + d.SEGM_NAME_2 + "</td>";
                  }
                  newRow += "<td style='width: 100px'>" + d.CONNECT_INFO +
                  "</td><td style='width: 70px'>" + d.KD_BUSINESS + "</td><td style='width: 70px'>" + d.KD_DQ_DATE +
                  "</td><td style='width: 70px'>" + d.KD_XF + "</td><td style='width: 70px'>" + d.ITV_BUSINESS + "</td><td style='width: 70px'>" + d.ITV_DQ_DATE +
                  "</td><td style='width: 70px'>" + d.ITV_XF + "</td></tr>";
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

  collect_new_load_build_info1 = load_build_info1;

  //清除已选中的样式, 一般需要在标签页切换时调用.
  function clear_has_selected1() {
      $("#collect_bselect1 > span").removeClass("active");
      $("#collect_bselect1 > span").eq(0).addClass("active");
      $("#collect_new_collect_state1 > span").removeClass("active");
      $("#collect_new_collect_state1 > span").eq(0).addClass("active");
  }

  function clear_data1() {
	  collect_bselect1 = -1, seq_num = 0, collect_state = 0;
	  $("#collect_new_bulid_info_list1").empty();
  }

  function load_collect_basic_info() {

      var params = {
          eaction: "collect_new_bsif",
          village_id: village_id
      }

      $.post(url_zhqd, params, function (data) {
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