<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '5'
</e:q4o>
<html>
    <head>
        <title>用户清单</title>
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
            #info_head tr th:first-child {width:6%!important;}
            #info_head tr th:nth-child(2) {width:8%!important;}
            #info_head tr th:nth-child(3) {width:12%!important;}
            #info_head tr th:nth-child(4) {width:12%!important;}
            #info_head tr th:nth-child(5) {width:10%!important;}
            #info_head tr th:nth-child(6) {width:8%!important;}
            #info_head tr th:nth-child(7) {width:17%!important;}
            #info_head tr th:nth-child(8) {width:17%!important;}
            #info_head tr th:nth-child(9) {width:10%!important;}

            #collect_new_bulid_info_list_sj tr td:first-child {width:6%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(2) {width:8%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(3) {width:12%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(4) {width:12%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(5) {width:10%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(6) {width:8%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(7) {width:17%!important;text-align:left;}
            #collect_new_bulid_info_list_sj tr td:nth-child(8) {width:17%!important;text-align:left;}
            #collect_new_bulid_info_list_sj tr td:nth-child(9) {width:10%!important;}

            #collect_new_table_content {
                border-bottom:1px solid #efefef;

            }

            .red_font {color:red;}

            .village_view_win .tab_box div .desk_orange_bar {
                text-align: center;
            }
            .head_table tr{background:#007BA9;}
            .btn {
                background: #007ba9;
                color: #fff;
                width: 55px;
                height: 25px;
            }
            #collect_new_table_content{height:60%;}
        </style>
        <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <script src='<e:url value="/pages/telecom_Index/common/js/tuomin.js?version=New Date()"/>' charset="utf-8"></script>
    </head>
    <body>
        <div id="collect_new_body">
            <table style="width:100%" id="info_query_tab">
                <tr>
                    <td>
                        <div class="count_num desk_orange_bar inside_data">
                            住户数：<span id="sjqd_all" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            人口数：<span id="rk_all" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            光宽数：<span id="sjqd_dx" style="color:#FF0000">0</span>
                        </div>
                    </td>
                </tr>
            </table>
                <div class="collect_new_choice" style="position:relative;padding-top:5px;color:black;margin:0 auto;clear:both;">
                    <div class="collect_contain_choice" style="margin:0px auto 0px auto;width: 40%;display:inline-block;">
                        <span style='font-weight:bold;'>社队:</span>
                        <select id="collect_new_build_list_sj_yonghu"
                                style="width: 80%;"></select>
                        <%--<input type="text" id="collect_new_build_name_sj"
                               style="width: 80%;border:none;height:22px!important;line-height:22px!important;margin:1px;"
                               oninput="load_build_name_list_sj()">
                        <ul id="collect_new_build_name_sj_list">
                        </ul>--%>
                    </div>
                    <div class="collect_contain_choice" style="width:40%;display:inline-block;margin-left:35px;margin-top:0px;">
                        <span style='font-weight:bold;'>查询:</span>
                        <input type="text" placeholder="输入姓名或号码进行查询" style="width:80%;" id="collect_name_sj_yonghu" />
                    </div>
                    <div style="display:inline-block;width:40px;" class="collect_contain_choice">
                        <input type="button" value="查询" class="btn" id="query_btn" />
                    </div>
                </div>

                <!--<tr>
                    <td>

                        <div id="collect_bselect" class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu"
                             style="width:62%;margin-left:2.5%;float:left;">
                            运营商:<span class="active" onclick="select_collect_band(-1)"
                                      id="collect_all"> 全部<span
                                id="collect_new_a_count_in_village"></span></span>
                            <span onclick="select_collect_band(5)"> 电信<span id="collect_new_d_count_in_village"></span></span>
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
                </tr>-->

        </div>
        <!--<div class="grid_count_title grid_count_title_small" style="display: none;">
            选定社队:<span id="collect_new_select_build"></span>
        </div>-->

        <div class="count_num2">
            记录数：<span id="record_num_yh"></span>
        </div>

        <div style="width:96%;margin:0px auto;">
            <div class="head_table_wrapper">
                <table class="head_table tab_header" cellspacing="0" cellpadding="0" id="info_head">
                    <tr>
                        <th>序号</th>
                        <th>用户名称</th>
                        <th>接入号码</th>
                        <th>入网日期</th>
                        <th>在网时长</th>
                        <th>状态</th>
                        <th>OBD设备</th>
                        <th>安装地址</th>
                        <th>联系电话</th>
                    </tr>
                </table>
            </div>
            <div id="collect_new_table_content" class="t_table" style="height:60%;">
                <table cellspacing="0" cellpadding="0" class="content_table tab_body" id="collect_new_bulid_info_list_sj" style="width: 100%"></table>
            </div>
        </div>
    </body>
</html>
<script>
  var seq_num = 0, collect_state = 0, collect_bselect = -1,page_info = 0;
  var village_id = '${param.village_id}';
  //表示是否选中, 选中:点击input下拉框选中, select选中.
  var select_count = 0;
    //打开信息收集编辑页面

  var url_info = "<e:url value='/pages/telecom_Index/common/sql/tabData_village_cell.jsp' />";
  $(function() {
      ly_initComb();
      load_build_list(true);
      load_build_head_count_info();

      $("#query_btn").unbind();
      $("#query_btn").bind("click",function(){
          clear_data2();
          console.log("query_btn click");
          load_build_list(true);
      });

      var begin_scroll_village = 0;
      $("#collect_new_table_content").scroll(function () {
          var viewH = $(this).height();
          var contentH = $(this).get(0).scrollHeight;
          var scrollTop = $(this).scrollTop();
          //alert(scrollTop / (contentH - viewH));

          if (scrollTop / (contentH - viewH) >= 0.95) {
              if (new Date().getTime() - begin_scroll_village > 500) {
                  page_info++;
                  load_build_list(0);
              }
              begin_scroll_village = new Date().getTime();
          }
      });

      /*$("#collect_bselect > span").each(function (index) {
          $(this).on("click", function () {
              $(this).addClass("active").siblings().removeClass("active");
          })
      })
      $("#collect_new_collect_state > span").each(function (index) {
          $(this).on("click", function () {
              $(this).addClass("active").siblings().removeClass("active");
          })
      });
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
      })*/
  });

  function ly_initComb() {
      var newRow = "<option value='-1' select='selected'>全部</option>";
      $.post(url_info,{
          "eaction":"getSheDuiSelectOption",
          "village_id":village_id
      },function(data){
          var ds = $.parseJSON(data);
          for(var i = 0,l = ds.length;i<l;i++){
              var d = ds[i];
              newRow += "<option value='" + d.BRIGADE_ID + "' >" + d.BRIGADE_NAME + "</option>";
              //ly_build_list.push(d);
          }
          $("#collect_new_build_list_sj_yonghu").append(newRow);
          //初始化选中
          /*var text = $("#ly_collect_new_build_list").find("option:selected").text();
          $("#ly_collect_new_build_name").val(text);
          $("#ly_collect_new_select_build").html(text);*/
      });
  }

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

  //社队combonchage事件
  function load_build_info_sj(flag) {
      $("#collect_all").addClass("active").siblings().removeClass("active");
      $("#collect_all_first").addClass("active").siblings().removeClass("active");
      //选中文本回写进 input
      //var text = $("#collect_new_build_list_sj_yonghu option:selected").text();
      //$("#collect_new_build_name_sj").val(text);
      //$("#collect_new_select_build").html(text);

      //before_load_bulid_info(flag);
      //load_build_count_info_in_village();

      var build_id = $("#collect_new_build_list_sj_yonghu option:selected").val();
      //common_bulid_id=build_id;
      //console.log("住户清单改变:"+common_bulid_id);
      var $build_list = $("#collect_new_bulid_info_list_sj");
      var query_text = $("#collect_name_sj_yonghu").val();

      var params = {
          eaction: "getUserList",
          res_id: build_id,
          /*collect_state: collect_state,
           collect_bselect: collect_bselect,
           acct_month:'${last_month.VAL}',*/
          village_id:'${param.village_id}',
          query_text: query_text,
          page:page_info
      };
      $.post(url_info, params, function(data) {
          data = $.parseJSON(data);

          if(data.length && page_info==0)
              $("#record_num_yh").text(data[0].C_NUM);

          for (var i = 0, l = data.length; i < l; i++) {
              var d = data[i];
              //var newRow = "<tr><td style='width: 40px'>" + (++seq_num) + "</td>";
              var newRow = "<tr>";
              newRow += "<td>"+(++seq_num)+"</td>";
              newRow += "<td>"+ name(d.SERV_NAME)+"</td>";
              newRow += "<td><a href=\"javascript:cust_agent('"+ d.PROD_INST_ID+"','"+ d.BRIGADE_ID+"',0)\" class='clickable'>"+ phoneHide(d.ACC_NBR)+"</a></td>";
              newRow += "<td>"+ d.FINISH_DATE+"</td>";
              newRow += "<td>"+ d.INET_MONTH+"</td>";
              newRow += "<td>"+ d.STOP_TYPE_NAME+"</td>";
              newRow += "<td>"+ d.EQP_NO+"</td>";
              newRow += "<td>"+ addr(d.ADDRESS)+"</td>";
              newRow += "<td>"+ phoneHide(d.USER_CONTACT_NBR)+"</td>";
              newRow += "</tr>"
              $build_list.append(newRow);
              fix();
          }
          if (data.length == 0 && flag) {
              $("#record_num_yh").text("0");
              $build_list.empty();
              $build_list.append("<tr><td style='text-align:center' colspan=6 onMouseOver=\"this.style.background='rgb(250,250,250)' \">没有查询到数据</td></tr>")
              return;
          }
      })
  }
  function name_hide(str){
      return str.substr(0,1)+"**";
  }

  function cust_agent(prod_inst_id,brigade_id,tab_id){
      var params = {};
      params.prod_inst_id = prod_inst_id;
      params.brigade_id = brigade_id;
      params.tab_id = tab_id;
      params.village_id = village_id;
      parent.openNewWinInfoCollectEdit(params);
  }

  function closeWinInfoCollectionEdit(){
      parent.closeWinInfoCollectionEdit();
  }

  //做名字查询时使用, 数据库太慢
  var build_list = [];
  //flag表示通过什么方式触发当前方法, 1表示进行input 文本改变事件.
  function load_build_list(flag) {//社队下拉框初始化
      console.log("住户清单获取:"+common_bulid_id);
	  var $build_list =  $("#collect_new_build_list_sj_yonghu");
      var query_text = $("#collect_name_sj_yonghu").val();
	  //如果是通过 select选择的话,select_count重新开始计数.
	  //只有当第一次改变input的时候将值置位1;
      load_build_info_sj(flag);
      return;
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
         // $("#collect_new_build_list_sj_yonghu option:eq(0)").attr('selected','selected');
          select_count++;
      }, 800)
  }

  function select_build_sj(name, id, index) {
      $("#collect_new_build_list_sj_yonghu option[value=" + id + "]").attr('selected','selected');
      $("#collect_new_build_name_sj_list").hide();
      $("#collect_new_build_list_sj_yonghu").change();
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
  //加载选择社队的统计信息
  function load_build_count_info_in_village() {
      //选择社队后清空输入计数器
      select_count = 0;
      var params = {
          eaction: "collect_new_count",
          res_id: $('#collect_new_build_list_sj_yonghu option:checked').val()
      };
      $.post(url_info, params, function(data) {
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

  //加载选择社队黄标统计信息
  function load_build_head_count_info() {
      //选择社队后清空输入计数器
      var params = {
          eaction: "getUserSummary",
          village_id: village_id
      };
      $.post(url_info, params, function(data) {
          console.log("data:"+data);
          if (data != null && data.trim() != 'null') {
              data = JSON.parse(data);
              $("#sjqd_all").text(data.HOUSEHOLD_NUM);
              $("#rk_all").text(data.POPULATION_NUM);
              $("#sjqd_dx").text(data.H_USE_CNT);//
              //$("#sjqd_ying").text(data.YING_COUNT);
              //$("#sjqd_yi").text(data.ON_COUNT);
          } else {
              $("#sjqd_all").text(0);
              $("#rk_all").text(0);
              //$("#sjqd_ying").text(0);
              //$("#sjqd_yi").text(0);
              $("#sjqd_dx").text(0);
              //$("#sjqd_lv").text("0%");
          }
      })


  }

  //collect_new_load_build_info_sj = load_build_info_sj;

  //清除已选中的样式, 一般需要在标签页切换时调用.
  function clear_has_selected() {
      $("#collect_bselect > span").removeClass("active");
      $("#collect_bselect > span").eq(0).addClass("active");
      $("#collect_new_collect_state > span").removeClass("active");
      $("#collect_new_collect_state > span").eq(0).addClass("active");
  }

  function clear_data2() {
	  collect_bselect = -1, seq_num = 0, collect_state = 0,page_info = 0;
	  $("#collect_new_bulid_info_list_sj").empty();
  }

</script>
<script>
    //利用js让头部与内容对应列宽度一致。

    function fix(){
        for(var i=0;i<=$(".tab_header tr").find("th").index();i++){
            $(".tab_body tr td").eq(i).css("width",$(".tab_header tr").find("th").eq(i).width());
        }
    }
    //window.load=fix();
    $(function(){
        //fix();
    });
    $(window).resize(function(){
        //return fix();
    });

    //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
    $('.t_table').scroll(function(){
        $('#table_head').css('margin-left',-($('.t_table').scrollLeft()));
    });
</script>