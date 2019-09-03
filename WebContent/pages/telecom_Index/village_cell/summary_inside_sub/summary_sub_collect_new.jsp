<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="grid_list">
  SELECT '-1' CODE, '全部' TEXT FROM DUAL UNION ALL
  SELECT GRID_ID CODE,GRID_NAME TEXT FROM gis_data.db_cde_grid
  where UNION_ORG_CODE = '${param.substation }'
  and grid_status = 1 AND GRID_UNION_ORG_CODE <> '-1'
</e:q4l>
<html>
<head>
    <title>竞争收集</title>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <style>
        .red_font {color:red;}

        #add6_head tr th:first-child {width:8%!important;}
        #add6_head tr th:nth-child(2) {width:10%!important;}
        #add6_head tr th:nth-child(3) {width:15%!important;}
        #add6_head tr th:nth-child(4) {width:10%!important;}
        #add6_head tr th:nth-child(5) {width:9%!important;}
        #add6_head tr th:nth-child(6) {width:10%!important;}
        #add6_head tr th:nth-child(7) {width:14%!important;}
        #add6_head tr th:nth-child(8) {width:10%!important;}
        #add6_head tr th:nth-child(9) {width:14%!important;}

        #summary_inside_sub_collect_list tr td:first-child {width:8%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(2) {width:10%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(3) {width:15%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(4) {width:10%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(5) {width:9%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(6) {width:10%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(7) {width:14%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(8) {width:10%!important;}
        #summary_inside_sub_collect_list tr td:nth-child(9) {width:14%!important;}

        .count_num2 {display:none;}

        #collect_add_btn {
            color:#FFFFFF;
            height: 28px;
            line-height: 28px;
            vertical-align: middle;
            width: 56px;
            background: #2ea5e9;
            border-color: #74b9e1;
            border-radius: 2px;
            border-width: 1px;
            border-style: solid;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="collect_new_sub_name" class="sub_name"></div>

    <div id="collect_new_body">
        <div class="info_village">
            <span style="display:none;">小区数： <span id="collect_new_village_count">--</span></span>
            <span style="display:none;">, 楼宇数： <span id="collect_new_build_count">--</span></span>
            <span>住户数： <span id="collect_zhu_hu_shu">--</span></span>
            <span>&nbsp;&nbsp;&nbsp;&nbsp;应收集： <span id="collect_should">--</span></span>
            <span>&nbsp;&nbsp;&nbsp;&nbsp;已收集： <span id="collect_done">--</span></span>
            <span>&nbsp;&nbsp;&nbsp;&nbsp;收集率： <span id="collect_lv">--</span></span>
        </div>
        <div class="collect_new_choice" style ="position:relative;color:black;">
            <div class="collect_contain_choice" style="width:43%;">
                <b style='font-weight:bold;'>行政村:</b>
                <select id="collect_new_village_list" onchange="change_select1()" style="width:75%;"></select>
                <%--<input type="text" id="collect_new_village_name" oninput="load_village_name_list()"/>
                <ul id="collect_new_village_name_list">
                </ul>--%>
            </div>
            <div class="collect_contain_choice" style="width:43%;">
                <b style='font-weight:bold;'>社队:</b>
                <select id="collect_new_build_list_sj_info" onchange="queryBySD()"
                        style="width: 75%;padding-left:0px;"></select>
                <%--<input type="text" id="collect_new_build_name" oninput="load_build_name_list()" style="height:20px!important;">
                <ul id="collect_new_build_name_list">
                </ul>--%>
            </div>
            <div id="collect_bselect1"  align="left" class="tab_accuracy_head follow_head small_padding collect_contain_choice" style="margin:0px 0px 0px 5%;width: 75%;float:left;">
                <b style='font-weight:bold;'>类型:</b>
                <span class="active" onclick="select_collect_band1(-1)" id="collect_all1">全部<span id="collect_new_a_count1"></span></span>
                <span onclick="select_collect_band1(1)"> 移动<span id="collect_new_y_count1"></span></span>
                <span onclick="select_collect_band1(2)"> 联通<span id="collect_new_l_count1"></span></span>
                <span onclick="select_collect_band1(3)"> 广电<span id="collect_new_g_count1"></span></span>
                <span onclick="select_collect_band1(4)"> 其他<span id="collect_new_q_count1"></span></span>
                <span onclick="select_collect_band1(0)"> 占线用户<span id="collect_new_d_count1"></span></span>
            </div>
            <div style="float:left;display:inline-block;width:8%;" class="collect_contain_choice">
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
            <div id="collect_new_table_content1" class="t_table" style="height:58%!important;">
                <table class="content_table" id="summary_inside_sub_collect_list" style="width: 100%;"></table>
            </div>
        </div>
     </div>
</body>
</html>
<script>
  var seq_num = 0, collect_state = 0, collect_bselect1 = -1,page_add6 = 0;;
  //表示是否选中, 选中:点击input下拉框选中, select选中.
  var select_count = 0;
  var url_vc = "<e:url value='/pages/telecom_Index/common/sql/tabData_village_cell.jsp' />";
  var url_summary_vc = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_summary_village_cell.jsp" />';
  //var query_table_name = "sde.map_addr_segm_" + ${query_table_name.LATN_ID};
  var village_id = "";
  var res_id = "";
  var substation = '${param.substation}';
  var option_default = "<option value=''>全部</option>";

  function clear_data(){
      seq_num = 0, collect_state = 0, collect_bselect1 = -1,page_add6 = 0,village_id = "",res_id = "";
      console.log("summary_inside_sub_collect_list empty");
      $("#summary_inside_sub_collect_list").empty();
  }

  $(function() {
	  $("#collect_new_sub_name").text(sub_name);
	  //$("select[name=collect_new_grid_list]").change();
	  //load_collect_basic_info();

      load_select1();
      load_select2();
      load_data_list(0,1);
      load_summary();
      load_buss_type_cnt();

      $("#collect_bselect1 > span").each(function (index) {
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
                  load_data_list(page_add6,0);
              }
              begin_scroll_village = new Date().getTime();
          }
      });

      $("#collect_add_btn").unbind();
      $("#collect_add_btn").bind("click",function(){
          //exec_agent(village_id,'',1);
          var brigade_id = $("#collect_new_build_list_sj_info option:selected").val();
          if(brigade_id==''){
              layer.msg("请选择一个社队");
              return;
          }
          var village_id = $("#collect_new_village_list option:selected").val();
          exec_agent(village_id,brigade_id,'',1);
      });

  });

  function select_collect_band1(type) {
      clear_data();
      collect_state = 0;
      collect_bselect1 = type;
      load_data_list(0,1);
      //load_add6_build_type_cnt();
  }

  function change_select1(){
      clear_data();
      var v_option = $("#collect_new_village_list option:selected").val();
      load_select2();
      $.post(url_vc,{"eaction":"getSheDuiSelectOption","village_id":v_option},function(data){
          var data = $.parseJSON(data);
          if(data.length){
              for(var i = 0,l = data.length;i<l;i++){
                  var option = "<option value='"+data[i].BRIGADE_ID+"'>"+data[i].BRIGADE_NAME+"</option>";
                  $("#collect_new_build_list_sj_info").append(option);
              }
          }
      });
      queryBySD();
  }

  function queryBySD(){
      clear_data();
      getQueryParam();
      load_data_list(0,1);
      load_buss_type_cnt();
  }


  function getQueryParam(){
      village_id = $("#collect_new_village_list option:selected").val();
      res_id = $("#collect_new_build_list_sj_info option:selected").val();
  }

  function load_summary(){
      $.post(url_summary_vc,{"eaction":"get_info_all","substation": substation},function(data){
          var objs = $.parseJSON(data);
          if(objs.length){
              var d = objs[0];
              $("#collect_zhu_hu_shu").text(d.HOUSEHOLD_NUM);
              $("#collect_should").text(d.Y_COLLECT_CNT);
              $("#collect_done").text(d.COLLECT_CNT);
              $("#collect_lv").text(d.COLLECT_LV);
          }
      });
  }

  function load_buss_type_cnt(){
      $.post(url_vc,{"eaction":"getCollectBusSummary","village_id":village_id,"res_id":res_id,"substation":substation},function(data){
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

  function load_select1(){
      $.post(url_vc,{"eaction":"getVillageSelectOption","substation":substation},function(data){
          var data = $.parseJSON(data);
          $("#collect_new_village_list").append(option_default);
          if(data.length){
              for(var i = 0,l = data.length;i<l;i++){
                  var option = "<option value='"+data[i].VILLAGE_ID+"'>"+data[i].VILLAGE_NAME+"</option>";
                  $("#collect_new_village_list").append(option);
              }
          }
      });
  }
  function load_select2(){
      $("#collect_new_build_list_sj_info").empty();
      $("#collect_new_build_list_sj_info").append(option_default);
  }

  function load_data_list(page,flag){
      var $build_list = $("#summary_inside_sub_collect_list");
      $.post(url_vc,{"eaction":"getCollectList","substation":substation,"village_id":village_id,"res_id":res_id,"collect_bselect1":collect_bselect1,"page":page},function(data){
          var objs = $.parseJSON(data);
          if(objs.length && page==0){
              $("#record_num_sj").text(objs[0].C_NUM);
          }
          for(var i = 0,l = objs.length;i<l;i++){
              var d = objs[i];
              var row = "<tr>";
              row += "<td>"+ (++seq_num) +"</td>";
              row += "<td><a href=\"javascript:exec_agent('"+ d.VILLAGE_ID+"','"+ d.BRIGADE_ID+"','"+ d.ADDRESS_ID +"',1)\">"+ name_hide(d.CUST_NAME) +"</a></td>";
              row += "<td>"+ d.USER_CONTACT_NBR +"</td>";
              row += "<td>"+ d.PLATE_NUMBER +"</td>";//门牌号
              row += "<td>"+ d.COLLECT_TYPE +"</td>";//类型
              row += "<td>"+ d.BUSSNESS_TYPE +"</td>";
              row += "<td>"+ d.EXP_DATE +"</td>";
              row += "<td>"+ d.TARIFF_DESC +"</td>";
              row += "<td>"+ d.HOLD_INSTALL_DATE +"</td>";
              row += "</tr>";
              $build_list.append(row);
          }
          console.log("objs.length:"+objs.length);
          console.log("flag:"+flag);
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

  function before_load_build_list() {
	  //$("#collect_new_build_name").val("");
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
			  build_id: $("#collect_new_she_dui_list").val()
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

  //清除已选中的样式, 一般需要在标签页切换时调用.
  function clear_has_selected() {
      $("#collect_bselect > span").removeClass("active");
      $("#collect_bselect > span").eq(0).addClass("active");
      $("#collect_new_collect_state > span").removeClass("active");
      $("#collect_new_collect_state > span").eq(0).addClass("active");
  }

  function exec_agent(village_id,brigade_id,address_id,tab_id){
      var params = {};
      params.village_id = village_id;
      params.brigade_id = brigade_id;
      params.address_id = address_id;
      params.tab_id = tab_id;
      params.only_collect = 1;
      openNewWinInfoCollectEdit(params);
  }
</script>