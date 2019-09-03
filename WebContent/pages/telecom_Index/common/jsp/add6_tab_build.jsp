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
    </style>
</head>
<body>
<div id="collect_new_body">
    <div class="collect_new_state_wrapper">
        <div id="collect_bselect1"  align="left" class="tab_accuracy_head follow_head small_padding" style="float:left;">运营商:<span class="active" onclick="select_collect_band1(-1)">全部<span id="collect_new_a_count1_build"></span></span>
         <span onclick="select_collect_band1(5)"> 电信<span id="collect_new_d_count1_build"></span></span>
         <span onclick="select_collect_band1(1)"> 移动<span id="collect_new_y_count1_build"></span></span>
         <span onclick="select_collect_band1(2)"> 联通<span id="collect_new_l_count1_build"></span></span>
         <span onclick="select_collect_band1(3)"> 广电<span id="collect_new_g_count1_build"></span></span>
         <span onclick="select_collect_band1(4)"> 其他<span id="collect_new_q_count1_build"></span></span>
         <span onclick="select_collect_band1(0)"> 未装<span id="collect_new_n_count1_build"></span></span>
        </div>
    </div>

    <div>
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
        <div id="collect_new_table_content1" class="t_table">
            <table class="content_table" id="collect_new_bulid_info_list2" style="width: 100%;"></table>
        </div>
    </div>
 </div>
</body>
</html>
<script>
  var seq_num = 0, collect_state = 0, collect_bselect1 = -1;
  //var village_id = '${param.village_id}';
  var res_id = '${param.res_id}';
  //表示是否选中, 选中:点击input下拉框选中, select选中.
  var select_count = 0;
  var url_zhqd2 = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_build_action.jsp' />";

  //做名字查询时使用
  /*以下部分为联动===start*/

  //做名字查询时使用, 数据库太慢
  var build_list = [];
  //flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.

  /*以上部分为联动===end*/

  function select_collect_band1(type) {
	  collect_bselect1 = type;
	  load_build_info1(1);
  }

  //为1保存选择条件,否则清除所有条件, 清除已选择.
  function before_load_bulid_info1(flag) {
	  if (flag) {
          var temp2 = collect_bselect1;
          clear_data1();
          collect_bselect1 =temp2;
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
			  res_id: res_id
	  };
	  $.post(url_zhqd2, params, function(data) {
		  if (data != null && data.trim() != 'null') {
			  data = JSON.parse(data);
              $("#collect_new_all_count1").html("(" + data.A_COUNT + ")");
              $("#collect_new_off_count1").html("(" + data.OFF_COUNT + ")");
              $("#collect_new_on_count1").html("(" + data.ON_COUNT + ")");
              $("#collect_new_a_count1_build").html("(" + data.A_COUNT + ")");
              $("#collect_new_d_count1_build").html("(" + data.D_COUNT + ")");
              $("#collect_new_y_count1_build").html("(" + data.Y_COUNT + ")");
              $("#collect_new_l_count1_build").html("(" + data.L_COUNT + ")");
              $("#collect_new_g_count1_build").html("(" + data.G_COUNT + ")");
              $("#collect_new_q_count1_build").html("(" + data.Q_COUNT + ")");
              $("#collect_new_n_count1_build").html("(" + data.N_COUNT + ")");
          } else {
        	  $("#collect_new_all_count1").html("(0)");
        	  $("#collect_new_off_count1").html("(0)");
        	  $("#collect_new_on_count1").html("(0)");
        	  $("#collect_new_a_count1_build").html("(0)");
              $("#collect_new_d_count1_build").html("(0)");
              $("#collect_new_y_count1_build").html("(0)");
              $("#collect_new_l_count1_build").html("(0)");
              $("#collect_new_g_count1_build").html("(0)");
              $("#collect_new_q_count1_build").html("(0)");
              $("#collect_new_n_count1_build").html("(0)");
          }
	  })
  }

  var load_build_info1 = function (flag) {
	  //选中文本回写进 input
      console.log(collect_bselect1);
	  var build_id = res_id;
	  var $build_list = $("#collect_new_bulid_info_list2");
      $build_list.empty();
	  if (build_id != "-1") {
		  var params = {
	              eaction: "collect_new_build_info",
	              res_id: res_id,
	              collect_bselect: collect_bselect1
	      };
		  $.post(url_zhqd2, params, function(data) {
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
	  $("#collect_new_bulid_info_list2").empty();
  }

  $(function() {
      $("#collect_bselect1 > span").each(function (index) {
          $(this).on("click", function () {
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
      load_build_info1();
      load_build_count_info1();
  });
</script>