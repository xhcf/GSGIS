<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '5'
</e:q4o>
<html>
    <head>
        <title>城市小区工作台_收集清单</title>
        <style>
            #collect_new_collect_state {
                float: left;
            }

            #collect_bselect {
                float: right;
            }

            #collect_new_collect_state, #collect_bselect {
                display: inline-block;
            }
            #collect_new_table_content{height:56%;}
            .bold_blue a{text-decoration: underline;}
            .tab_header tr th:first-child {width:5%!important;}
            .tab_header tr th:nth-child(2) {width:34%!important;}
            .tab_header tr th:nth-child(3) {width:8%!important;}
            .tab_header tr th:nth-child(4) {width:10%!important;}
            .tab_header tr th:nth-child(5) {width:10%!important;}
            .tab_header tr th:nth-child(6) {width:15%!important;}
            .tab_header tr th:nth-child(7) {width:8%!important;}
            .tab_header tr th:nth-child(8) {width:10%!important;}

            #collect_new_bulid_info_list_sj tr td:first-child {width:5%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(2) {width:34%!important;text-align:left!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(3) {width:8%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(4) {width:10%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(5) {width:10%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(6) {width:15%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(7) {width:8%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(8) {width:10%!important;}

            .red_font {color:red;}

            .inside_data_orange {
                text-align: center!important;
            }
        </style>
        <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <script src='<e:url value="/pages/telecom_Index/common/js/tuomin.js?version=New Date()"/>' charset="utf-8"></script>
    </head>
    <body>
        <div id="collect_new_body">
            <table style="width:100%">
                <tr>
                    <td>
                        <div class="count_num desk_orange_bar inside_data inside_data_orange">
                            住户数：<span id="sjqd_all" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            应收集：<span id="sjqd_ying" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <%--应收集：<span id="sjqd_ying" style ="color:#FF0000">0</span>&nbsp;&nbsp;--%>
                            已收集：<span id="sjqd_yi" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            收集率：<span id="sjqd_lv" style="color:#FF0000">0</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
                            <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
                                楼宇:
                                <select id="collect_new_build_list_sj" onchange="load_build_info_sj(0)"
                                        style="width: 92%;padding-left:0px;"></select>
                                <input type="text" id="collect_new_build_name_sj"
                                       style="width: 80%;border:none;height:22px!important;line-height:22px!important;margin:1px;"
                                       oninput="load_build_name_list_sj()">
                                <ul id="collect_new_build_name_sj_list">
                                </ul>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>

                        <div id="collect_bselect" class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu"
                             style="width:62%;margin-left:2.5%;float:left;">
                            运营商:<span class="active" onclick="select_collect_band(-1)"
                                      id="collect_all"> 全部<span
                                id="collect_new_a_count_in_village"></span></span>
                            <span onclick="select_collect_band(5)" style="display:none;"> 电信<span id="collect_new_d_count_in_village"></span></span>
                            <span onclick="select_collect_band(1)"> 移动<span id="collect_new_y_count_in_village"></span></span>
                            <span onclick="select_collect_band(2)"> 联通<span id="collect_new_l_count_in_village"></span></span>
                            <span onclick="select_collect_band(3)"> 广电<span id="collect_new_g_count_in_village"></span></span>
                            <span onclick="select_collect_band(4)"> 其他<span id="collect_new_q_count_in_village"></span></span>
                            <span onclick="select_collect_band(0)"> 未装<span id="collect_new_n_count_in_village"></span></span>
                        </div>
                        <div id="collect_new_collect_state" align="left"
                             class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu"
                             style="width:32%;float:right;">
                            收集: <span class="active" onclick="select_collect_state(0)" id="collect_all_first"> 全部<span
                                id="collect_new_all_count"></span></span>
                            <span onclick="select_collect_state(2)"> 已收集<span id="collect_new_on_count_in_village"></span></span>
                            <span onclick="select_collect_state(1)"> 未收集<span id="collect_new_off_count_in_village"></span></span>
                        </div>
                    </td>
                </tr>

            </table>
        </div>
        <div class="grid_count_title grid_count_title_small" style="display: none;">
            选定楼宇:<span id="collect_new_select_build"></span>
        </div>
        <div style="width:96%;margin:0px auto;">
            <div class="head_table_wrapper">
                <table class="head_table tab_header" cellspacing="0" cellpadding="0">
                    <tr>
                        <th>序号</th>
                        <th>详细地址</th>
                        <th>联系人</th>
                        <th>联系电话</th>
                        <th>宽带运营商</th>
                        <th>宽带到期时间</th>
                        <th>是否安装</th>
                        <th>操作</th>
                    </tr>
                </table>
            </div>
            <div id="collect_new_table_content" class="t_table">
                <table cellspacing="0" cellpadding="0" class="content_table tab_body" id="collect_new_bulid_info_list_sj" style="width: 100%"></table>
            </div>
        </div>
    </body>
</html>
<script>
  var seq_num = 0, collect_state = 0, collect_bselect = -1;
  var village_id = '${param.village_id}';
  //表示是否选中, 选中:点击input下拉框选中, select选中.
  var select_count = 0;
    //打开信息收集编辑页面

  var url_jz = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_village_action1.jsp' />";
  var url_build = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_tab_build_action.jsp' />";
  $(function() {
      load_build_list(true);
      load_build_head_count_info();

      $("#collect_bselect > span").each(function (index) {
          $(this).on("click", function () {
              $("#collect_new_collect_state > span").removeClass("active");
              $("#collect_new_collect_state > span").eq(0).addClass("active");
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
      $("#collect_new_collect_state > span").each(function (index) {
          $(this).on("click", function () {
              $("#collect_bselect > span").removeClass("active");
              $("#collect_bselect > span").eq(0).addClass("active");
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
  });

  //做名字查询时使用
  /*以下部分为联动===start*/

  function before_load_build_list_sj() {
	  //$("#collect_new_build_name_sj").val("");
      clear_data2();
      clear_has_selected();
      //$("#collect_new_select_build_in_village").html("");
	  $("#collect_new_all_count").html("(0)");
      $("#collect_new_off_count_in_village").html("(0)");
      $("#collect_new_on_count_in_village").html("(0)");
      $("#collect_new_a_count_in_village").html("(0)");
      $("#collect_new_d_count_in_village").html("(0)");
      $("#collect_new_y_count_in_village").html("(0)");
      $("#collect_new_l_count_in_village").html("(0)");
      $("#collect_new_g_count_in_village").html("(0)");
      $("#collect_new_q_count_in_village").html("(0)");
      $("#collect_new_n_count_in_village").html("(0)");

  }

  //做名字查询时使用, 数据库太慢
  var build_list = [];
  //flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.
  function load_build_list(selected) {//楼宇下拉框初始化
      console.log("住户清单获取:"+common_bulid_id);
	  var $build_list =  $("#collect_new_build_list_sj");
	  before_load_build_list_sj();
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
          $build_list.append("<option value=''>全部</option>");
          var params = {
              eaction: "collect_new_build_list",
              village_id: village_id
          };
	      $.post(url_jz, params, function(data) {
	          data = $.parseJSON(data);
	          if (data.length != 0) {
	              var d, newRow = "";//<option value='-1' select='selected'>全部</option>
                  for (var i = 0, length = data.length; i < length; i++) {
                      d = data[i];
                      newRow += "<option value='" + d.SEGM_ID + "'>" + d.STAND_NAME + "</option>";

                      build_list.push(d);
                  }
                  $build_list.append(newRow);
                  $("#collect_new_build_list_sj option").removeAttr("selected");
                  /*if(common_bulid_id!="-1")
                      $("#collect_new_build_list_sj option[value='"+common_bulid_id+"']").attr("selected","selected");
                  else*/
                      $("#collect_new_build_list_sj option").eq(0).attr("selected","selected");
                  yx_build_id = $("#collect_new_build_list_sj option:selected").val();

                  //初始化选中
                  //var text = $("#collect_new_build_list_sj").find("option:selected").text();
                  //$("#collect_new_build_name_sj").val(text);

                  load_build_info_sj();
                  load_build_count_info_in_village();
	          }
	      })
	  }
  }

  function load_build_name_list_sj() {
      setTimeout(function() {
          //下拉列表显示
          var $build_list =  $("#collect_new_build_name_sj_list");
          $build_list.empty();
          if (select_count <= 1) {
        	  before_load_build_list_sj();
          }

          var build_name = $("#collect_new_build_name_sj").val().trim();
          if (build_name != '') {
              var temp;
              var newRow = "";
              for (var i = 0, length = build_list.length, count = 0; i < length; i++) {
                  if ((temp = build_list[i].STAND_NAME).indexOf(build_name) != -1) {
                      newRow += "<li title='" + temp + "' onclick='select_build_sj(\""+ temp + "\",\"" +
                      build_list[i].SEGM_ID + "\"," + i + ")'>" + temp + "</li>";
                      count++;
                  }
                  if (count >= 15) {
                      break;
                  }
              }
              $build_list.append(newRow);
              $("#collect_new_build_name_sj_list").show();
          } else {
        	  $("#collect_new_build_name_sj_list").hide();
          }

          //联动改变 select框, 只要不做点击, 都会将select改回全部.
         // $("#collect_new_build_list_sj option:eq(0)").attr('selected','selected');
          select_count++;
      }, 800)
  }

  function select_build_sj(name, id, index) {
      $("#collect_new_build_list_sj option[value=" + id + "]").attr('selected','selected');
      $("#collect_new_build_name_sj_list").hide();
      $("#collect_new_build_list_sj").change();
  }
  /*以上部分为联动===end*/

  function select_collect_state(type) {
	  collect_bselect = -1;
	  collect_state = type;
	  load_build_info_sj(1);
  }

  function select_collect_band(type) {
	  collect_state = 0;
	  collect_bselect = type;
	  load_build_info_sj(1);
  }

  //为1保存选择条件,否则清除所有条件, 清除已选择.
  function before_load_bulid_info(flag) {
	  if (flag) {
          var temp1 = collect_state, temp2 = collect_bselect;
          clear_data2();
          collect_state = temp1, collect_bselect =temp2;
      } else {
          clear_data2();
          clear_has_selected();
      }
  }
  //加载选择楼宇的统计信息
  function load_build_count_info_in_village() {
      //选择楼宇后清空输入计数器
      select_count = 0;
      var params = {
          eaction: "collect_new_count_yw",
          res_id: $('#collect_new_build_list_sj option:checked').val(),
          v_id: village_id
      };
      $.post(url_build, params, function(data) {
          if (data != null && data.trim() != 'null') {
              data = JSON.parse(data);
              $("#collect_new_a_count_in_village").html("(" + data.A_COUNT + ")");
              $("#collect_new_d_count_in_village").html("(" + data.D_COUNT + ")");
              $("#collect_new_y_count_in_village").html("(" + data.Y_COUNT + ")");
              $("#collect_new_l_count_in_village").html("(" + data.L_COUNT + ")");
              $("#collect_new_g_count_in_village").html("(" + data.G_COUNT + ")");
              $("#collect_new_q_count_in_village").html("(" + data.Q_COUNT + ")");
              $("#collect_new_n_count_in_village").html("(" + data.N_COUNT + ")");

              $("#collect_new_all_count").text("("+ data.A_COUNT +")");
              $("#collect_new_on_count_in_village").text("("+ data.ON_COUNT +")");
              $("#collect_new_off_count_in_village").text("("+ data.OFF_COUNT +")");
          } else {
              $("#collect_new_a_count_in_village").html("(0)");
              $("#collect_new_d_count_in_village").html("(0)");
              $("#collect_new_y_count_in_village").html("(0)");
              $("#collect_new_l_count_in_village").html("(0)");
              $("#collect_new_g_count_in_village").html("(0)");
              $("#collect_new_q_count_in_village").html("(0)");
              $("#collect_new_n_count_in_village").html("(0)");

              $("#collect_new_all_count").text("(0)");
              $("#collect_new_on_count_in_village").text("(0)");
              $("#collect_new_off_count_in_village").text("(0)");
          }
      })
  }

  //加载选择楼宇黄标统计信息
  function load_build_head_count_info() {
      //选择楼宇后清空输入计数器
      var params = {
          eaction: "collect_new_count_head",
          village_id: village_id
      };
      $.post(url_jz, params, function(data) {
          if (data != null && data.trim() != 'null') {
              data = JSON.parse(data);
              $("#sjqd_all").text(data.A_COUNT);
              $("#sjqd_ying").text(data.YING_COUNT);
              $("#sjqd_yi").text(data.ON_COUNT);
              var temp_lv=0;
              if(data.YING_COUNT==0) $("#sjqd_lv").text("0%");
              else
              {
                  temp_lv=(data.ON_COUNT/data.YING_COUNT*100).toFixed(2);
                  $("#sjqd_lv").text(temp_lv + "%");
              }
          } else {
              $("#sjqd_all").text(0);
              $("#sjqd_ying").text(0);
              $("#sjqd_yi").text(0);
              $("#sjqd_lv").text("0%");
          }
      })

  }
  //楼宇combonchage事件
  var load_build_info_sj = function (flag) {
      $("#collect_all").addClass("active").siblings().removeClass("active");
      $("#collect_all_first").addClass("active").siblings().removeClass("active");
	  //选中文本回写进 input
	  var text = $("#collect_new_build_list_sj option:selected").text();
	  $("#collect_new_build_name_sj").val(text);
	  $("#collect_new_select_build").html(text);

	  before_load_bulid_info(flag);
	  load_build_count_info_in_village();

	  var build_id = $("#collect_new_build_list_sj option:selected").val();
      common_bulid_id=build_id;
      console.log("住户清单改变:"+common_bulid_id);
	  var $build_list = $("#collect_new_bulid_info_list_sj");
      $build_list.empty();

      if (build_id != "-1") {
          var params = {
              eaction: "getVillCollectDetail",
              res_id: $('#collect_new_build_list_sj option:selected').val(),
              collect_state: collect_state,
              collect_bselect: collect_bselect,
              acct_month:'${last_month.VAL}',
              v_id:village_id
          };
          $.post(url_build, params, function(data) {
              data = $.parseJSON(data);
              for (var i = 0, l = data.length; i < l; i++) {
                  var d = data[i];
                  var newRow = "<tr><td>" + (++seq_num) + "</td>";

                  newRow += "<td>";
                  if(d.SERIAL_NO==2)//政企
                    newRow += "<span class='zhengqi_flag'>政</span>";

                  newRow += addr(d.STAND_NAME_2) + "</td>";
                  newRow += "<td>" + name(d.CONTACT_PERSON) + "</td>"+"<td class='num_blue'>" + phoneHide(d.CONTACT_NBR) + "</td>";
                  if(d.KD_BUSINESS!='电信')
                      newRow += "<td class='buss_red'>" + d.KD_BUSINESS + "</td>";
                  else
                      newRow += "<td >" + d.KD_BUSINESS + "(<span class='red_font'>"+ d.IS_KD_DX +"</span>)</td>";

                  newRow += "<td>" + d.KD_DQ_DATE + "</td><td>" + d.IS_INSTALL + "</td>";
                  newRow += "<td><a href='javascript:void(0);' onclick='parent.openNewWinInfoCollectEdit(\"" + d.SEGM_ID_2 + "\")'>收集</a></td>";
                  newRow += "</tr>"
                  $build_list.append(newRow);
              }
              if (data.length == 0 && flag) {
                  $build_list.empty();
                  $build_list.append("<tr><td style='text-align:center' colspan=8 onMouseOver=\"this.style.background='rgb(250,250,250)' \">没有查询到数据</td></tr>")
                  return;
              }
          })
      }
  }

  collect_new_load_build_info_sj = load_build_info_sj;

  //清除已选中的样式, 一般需要在标签页切换时调用.
  function clear_has_selected() {
      $("#collect_bselect > span").removeClass("active");
      $("#collect_bselect > span").eq(0).addClass("active");
      $("#collect_new_collect_state > span").removeClass("active");
      $("#collect_new_collect_state > span").eq(0).addClass("active");
  }

  function clear_data2() {
	  collect_bselect = -1, seq_num = 0, collect_state = 0;
	  $("#collect_new_bulid_info_list_sj").empty();
  }

</script>