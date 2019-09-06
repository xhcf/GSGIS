<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<html>
<head>
    <title>竞争收集</title>
    <link href='<e:url value="/pages/telecom_Index/sandbox/css/sandbox_sub_new_level.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/common/js/tuomin.js?version=New Date()"/>' charset="utf-8"></script>
    <style>
        #collect_new_collect_state1{float:left;}
        #collect_bselect1{float:right;}
        #collect_new_collect_state1,#collect_bselect1{display: inline-block;}
        .village_view_win .tab_box div .desk_orange_bar {
            text-align: center;
        }
        .head_table tr {background:#007BA9;}
        .count_num {
            width: 100%!important;
            background: #FAB900;
            height:40px;line-height:40px;
            color: #343434;
            margin: 0px;

            padding-left: 25px;
            background: -webkit-linear-gradient(left, #feb029 , #ffce49 ,#fffdd0);
            background: -o-linear-gradient(right, #feb029 , #ffce49 ,#fffdd0);
            background: -moz-linear-gradient(right, #feb029 , #ffce49 ,#fffdd0);
            background: linear-gradient(to right, #feb029 , #ffce49 ,#fffdd0);
            border-bottom: solid 1px #f68a00;
            font-size: 14px;
            text-align: center;
            font-weight: bold;
        }
        .btn {
            background: #007ba9;
            color: #fff;
            width: 55px;
            height: 25px;
        }
        span.active {
            background: none!important;
            color: #ee7008!important;
        }

        #add6_head tr th:first-child {width:5%!important;}
        #add6_head tr th:nth-child(2) {width:14%!important;}
        #add6_head tr th:nth-child(3) {width:13%!important;}
        #add6_head tr th:nth-child(4) {width:11%!important;}
        #add6_head tr th:nth-child(5) {width:7%!important;}
        #add6_head tr th:nth-child(6) {width:11%!important;}
        #add6_head tr th:nth-child(7) {width:16%!important;}
        #add6_head tr th:nth-child(8) {width:11%!important;}
        #add6_head tr th:nth-child(9) {width:16%!important;}

        #collect_new_bulid_info_list1 {width:100%;}

        #collect_new_bulid_info_list1 tr td:first-child {width:5%!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(2) {width:14%!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(3) {width:13%!important;padding-left:0px!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(4) {width:11%!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(5) {width:7%!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(6) {width:11%!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(7) {width:16%!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(8) {width:11%!important;}
        #collect_new_bulid_info_list1 tr td:nth-child(9) {width:16%!important;}

        #collect_new_table_content1 {
            border-bottom:1px solid #efefef;

        }
    </style>
</head>
<body>
<div id="collect_new_body">

    <!-- background-color:#FAB900;width:100%;text-align:center;font-weight:bold;padding-top:0px;line-height:28px; -->
    <div class="count_num" style ="">
        住户数：<span id="zhqd_all" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        应收集：<span id="zhqd_y" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        已收集：<span id="zhqd_wz" style ="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        收集率：<span id="zhqd_dx" style ="color:#FF0000">0</span>
    </div>

    <div class="collect_new_choice" style ="position:relative;color:black;">
        <div class="collect_contain_choice" style="margin:0px auto 0px auto;width: 40%;float:left;">
            <span style='font-weight:bold;'>社队:</span>
            <select id="collect_new_build_list_sj_info" onchange="queryBySD()"
                    style="width: 92%;padding-left:0px;"></select>
            <%--<input type="text" id="collect_new_build_name_sj"
                   style="width: 80%;border:none;height:22px!important;line-height:22px!important;margin:1px;"
                   oninput="load_build_name_list_sj()">
            <ul id="collect_new_build_name_sj_list">
            </ul>--%>
        </div>
        <div id="collect_bselect1"  align="left" class="tab_accuracy_head follow_head small_padding collect_contain_choice" style="margin:0px 0px 0px 5%;width: 45%;float:left;">
            <b style='font-weight:bold;'>类型:</b>
            <span class="active" onclick="select_collect_band1(-1)" id="collect_all1">全部<span id="collect_new_a_count1"></span></span>
            <span onclick="select_collect_band1(1)"> 移动<span id="collect_new_y_count1"></span></span>
            <span onclick="select_collect_band1(2)"> 联通<span id="collect_new_l_count1"></span></span>
            <span onclick="select_collect_band1(3)"> 广电<span id="collect_new_g_count1"></span></span>
            <span onclick="select_collect_band1(4)"> 其他<span id="collect_new_q_count1"></span></span>
            <span onclick="select_collect_band1(0)"> 占线用户<span id="collect_new_d_count1"></span></span>
        </div>
        <div style="float:left;display:inline-block;width:5%;" class="collect_contain_choice">
            <input type="button" value="收集" class="btn" id="collect_add_btn" />
        </div>
    </div>
    <div class="grid_count_title grid_count_title_small" style="display: none;">
        <span style='font-weight:bold;'>选定楼宇:</span><span id="collect_new_select_build11"></span>
    </div>

    <div class="count_num2">
        记录数：<span id="record_num_sj"></span>
    </div>

    <div style="width:96%;margin:0px auto;">
        <div class="head_table_wrapper">
            <table class="head_table" id="add6_head">
                <tr>
                    <th >序号</th>
                    <th >联系人</th>
                    <th >联系电话</th>
                    <th >门牌号</th>
                    <th >类型</th>
                    <th >宽带运营商</th>
                    <th >宽带到期日期</th>
                    <th >资费</th>
                    <th >甩线日期</th>
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
  function queryBySD(){
    clear_data();
    load_add6_build(0,1);
    load_add6_build_type_cnt();
  }

  function clear_data(){
      seq_num = 0, collect_state = 0, collect_bselect1 = -1,page_add6 = 0;
      $("#collect_new_bulid_info_list1").empty();
  }
  var seq_num = 0, collect_state = 0, collect_bselect1 = -1,page_add6 = 0;
  //var village_id = '${param.village_id}';
  //表示是否选中, 选中:点击input下拉框选中, select选中.
  var select_count = 0;
  console.log("add6 build_id:"+parent.common_bulid_id);
  var url_zhqd = "<e:url value='/pages/telecom_Index/common/sql/tabData_village_cell.jsp' />";
  $(function() {
	  //load_collect_basic_info();
      //load_build_list1(true);
      //load_build_head_count_info1();
      initSheDuiOption();
      //clear_data();
      load_add6_build(0,1);
      load_add6_build_type_cnt();
      load_add6_build_sum_cnt();

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

      var begin_scroll_village = 0;
      $("#collect_new_table_content1").scroll(function () {
          var viewH = $(this).height();
          var contentH = $(this).get(0).scrollHeight;
          var scrollTop = $(this).scrollTop();
          //alert(scrollTop / (contentH - viewH));

          if (scrollTop / (contentH - viewH) >= 0.95) {
              if (new Date().getTime() - begin_scroll_village > 500) {
                  page_add6++;
                  load_add6_build(page_add6,0);
              }
              begin_scroll_village = new Date().getTime();
          }
      });

      $("#collect_add_btn").unbind();
      $("#collect_add_btn").bind("click",function(){
          exec_agent(village_id,'',1);
      });

  });

  //做名字查询时使用
  /*以下部分为联动===start*/

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
      clear_data();
      console.log("type:"+type);
	  collect_state = 0;
	  collect_bselect1 = type;
      load_add6_build(0,1);
      //load_add6_build_type_cnt();
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
             $("#zhqd_y").text(data.A_COUNT);
              $("#zhqd_wz").text(data.N_COUNT);
              $("#zhqd_dx").text(data.D_COUNT);
              $("#zhqd_yd").text(data.Y_COUNT);
              $("#zhqd_lt").text(data.L_COUNT);
              $("#zhqd_gd").text(data.G_COUNT);
              $("#zhqd_qt").text(data.Q_COUNT );
          } else {
              $("#zhqd_all").text(0);
              $("#zhqd_y").text(0);
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
	  collect_bselect1 = -1, seq_num = 0, collect_state = 0,page = 0;
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
    //20181217
    function initSheDuiOption(){
        var newRow = "<option value='-1' select='selected'>全部</option>";
        $.post(url_zhqd,{
            "eaction":"getSheDuiSelectOption",
            "village_id":village_id
        },function(data){
            var ds = $.parseJSON(data);
            for(var i = 0,l = ds.length;i<l;i++){
                var d = ds[i];
                newRow += "<option value='" + d.BRIGADE_ID + "' >" + d.BRIGADE_NAME + "</option>";
                //ly_build_list.push(d);
            }
            $("#collect_new_build_list_sj_info").append(newRow);
            //初始化选中
            /*var text = $("#ly_collect_new_build_list").find("option:selected").text();
             $("#ly_collect_new_build_name").val(text);
             $("#ly_collect_new_select_build").html(text);*/
        });
    }

    function load_add6_build(page,flag){
        var $build_list = $("#collect_new_bulid_info_list1");
        var res_id = $("#collect_new_build_list_sj_info option:selected").val();
        $.post(url_zhqd,{"eaction":"getCollectList","village_id":village_id,"res_id":res_id,"collect_bselect1":collect_bselect1,"page":page},function(data){
            var objs = $.parseJSON(data);
            if(objs.length && page_add6==0){
                $("#record_num_sj").text(objs[0].C_NUM);
            }
            for(var i = 0,l = objs.length;i<l;i++){
                var d = objs[i];
                var row = "<tr>";
                row += "<td>"+ (++seq_num) +"</td>";
                row += "<td><a href=\"javascript:exec_agent('"+ d.VILLAGE_ID+"','"+ d.ADDRESS_ID+"',1)\">"+ name(d.CUST_NAME) +"</a></td>";
                row += "<td>"+ phoneHide(d.USER_CONTACT_NBR) +"</td>";
                row += "<td>"+ d.PLATE_NUMBER +"</td>";//门牌号
                row += "<td>"+ d.COLLECT_TYPE +"</td>";//类型
                row += "<td>"+ d.BUSSNESS_TYPE +"</td>";
                row += "<td>"+ d.EXP_DATE +"</td>";
                row += "<td>"+ d.TARIFF_DESC +"</td>";
                row += "<td>"+ d.HOLD_INSTALL_DATE +"</td>";
                row += "</tr>";
                $build_list.append(row);
            }
            if(objs.length==0 && flag){
                $("#record_num_sj").text("0");
                $build_list.empty();
                $build_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)' \">没有查询到数据</td></tr>")
            }
        });
    }

      function name_hide(str){
          return str.substr(0,1)+"**";
      }

    function load_add6_build_sum_cnt(){
        $.post(url_zhqd,{"eaction":"getCollectSummary","village_id":village_id},function(data){
            var objs = $.parseJSON(data);
            if(objs.length){
                var d = objs[0];
                $("#zhqd_all").text(d.HOUSEHOLD_NUM);
                $("#zhqd_y").text(d.Y_COLLECT);
                $("#zhqd_wz").text(d.COLLECT_COUNT);
                $("#zhqd_dx").text('0.00%');
            }else{
                $("#zhqd_all").text(0);
                $("#zhqd_y").text(0);
                $("#zhqd_wz").text(0);
                $("#zhqd_dx").text('0.00%');
            }
        });
    }

    function load_add6_build_type_cnt(){
        $.post(url_zhqd,{"eaction":"getCollectBusSummary","village_id":village_id,"res_id":$("#collect_new_build_list_sj option:selected").val()},function(data){
            var objs = $.parseJSON(data);
            if(objs.length){
                var d = objs[0];
                $("#collect_new_a_count1").text("("+d.COL_ALL+")");
                $("#collect_new_y_count1").text("("+d.COL_YD+")");
                $("#collect_new_l_count1").text("("+d.COL_LT+")");
                $("#collect_new_g_count1").text("("+d.COL_GD+")");
                $("#collect_new_q_count1").text("("+d.COL_QT+")");
                $("#collect_new_d_count1").text("("+d.COL_ZX+")");
            }else{
                $("#collect_new_a_count1").text("("+0+")");
                $("#collect_new_y_count1").text("("+0+")");
                $("#collect_new_l_count1").text("("+0+")");
                $("#collect_new_g_count1").text("("+0+")");
                $("#collect_new_q_count1").text("("+0+")");
                $("#collect_new_d_count1").text("("+0+")");
            }
        });
    }

    function exec_agent(village_id,address_id,tab_id){
        var params = {};
        params.village_id = village_id;
        params.address_id = address_id;
        params.tab_id = tab_id;
        parent.openNewWinInfoCollectEdit(params);
    }

    function closeWinInfoCollectionEdit(){
        parent.closeWinInfoCollectionEdit();
    }
</script>