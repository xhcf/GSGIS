<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2018/12/26
  Time: 11:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <style type="text/css">

    /*.andSoOn{
        white-space: nowrap;
        text-overflow: ellipsis;
        display: inline-block;
        overflow:hidden;
            width:50%;
    }*/

    /*黄色汇总区 和 搜索条件 的容器*/
    .village_new_searchbar{
      width: 100%;
      overflow: hidden;
    }

    .village_new_searchbar div{
      color: #333;
      font-size: 12px;
    }

    /*黄色汇总区*/
    .village_view_win .tab_box div .desk_orange_bar{
      text-align:center;
    }

    .desk_orange_bar{
      width:100%!important;
      line-height:40px;
      height:40px;

      background: linear-gradient(to right, #feb029 , #ffce49 ,#fffdd0);
      border-bottom: solid 1px #f68a00;
    }

    /*黄色条内容的容器*/
    .desk_orange_bar.inside_data{
      font-size:14px;
      font-weight:bold;
      text-align:center;
      color:#333;
    }


    /*楼宇下拉选框最外层容器*/
    .collect_new_choice {
      position: relative;
      padding-top: 2px;
      color: black;
      width: 100%;
    }
    .collect_contain_choice {
      margin: 0px auto;
      width: 95%;
      float: none;
    }

    /*楼宇下拉框*/
    .collect_new_choice select {
      width: 92%;
      padding-left: 0px;
      margin-right: 20px;
      margin-left: 0;
      height: 24px!important;
      line-height: 24px!important;
      position: absolute;
      left: 40px;
      top: 0;
    }

    @media screen and (max-height: 800px){
      .collect_new_choice select {
        margin-right: 20px;
        margin-left: 0;
        height: 20px!important;
        line-height: 20px!important;
      }
    }

    .radio.tab_accuracy_head.tab_accuracy_other.desk_sub_menu {
      width: 100%;
      border-bottom: none;
      width: 95%;
      float: none;
      padding-left: 0px;
      margin: 6px auto 6px auto;
    }

    .tab_accuracy_head {
      height: 24px!important;
      line-height: 24px!important;
    }

    /*带数字的统计标签*/
    .tab_accuracy_head>span {
      padding: 0 3px;
      position: relative;
      cursor: pointer;
    }

    /*带数字的统计标签 选中状态*/
    .tab_accuracy_head .active {
      font-weight: normal;
      color: #ee7008;
    }

    .village_m_tab .blue_thead .tab_head_lock {
      width: 100%;
      padding-right: 17px;
      height: auto;
    }

    @media screen and (max-height: 1080px){
      .content_table {
        color: #666;
        text-align: center;
      }
    }

    .content_table .tab_header {
      width: 100%;
      color: #666;
      text-align: center;
      font-size: 12px;

    }

    @media screen and (max-height: 600px){
      .content_table tr {
        height: 24px;
        line-height: 24px;
      }
    }

    @media screen and (max-height: 1080px){
      .content_table tr {
        height: 28px;
        line-height: 28px;
      }
    }

    @media screen and (max-height: 1080px){
      .content_table th {
        border: 1px solid #c9c9ca;
        font-size: 14px;
        color: #000;
        background-color: #e8e8e8;
      }
    }
    .tab_header th {
      height: 26px!important;
      background: #1e6ee7;
      color: #fff;
      font-weight: bold;
    }

    .content_table tr {
      height: 24px;
      line-height: 24px;
    }

    .exec_tab_body .desk_tab .tab_scroll {
      overflow-y: scroll;
      width: 100%;
      height: 56%!important;
    }

    @media screen and (max-height: 1080px){
      .content_table {
        color: #666;
        text-align: center;
      }
    }

    @media screen and (max-height: 600px){
      .content_table tr {
        height: 24px;
        line-height: 24px;
      }
    }

    @media screen and (max-height: 1080px){
      .content_table tr {
        height: 28px;
        line-height: 28px;
      }
    }

    @media screen and (max-height: 800px){
      table.content_table td, table.content_table td a {
        font-size: 12px;
        line-height: 20px;
      }
    }

    @media screen and (max-height: 1080px){
      .content_table td {
        border: 1px solid #c9c9ca;
        font-size: 12px;
      }
    }

    .tab_header tr th:first-child {width:5%!important;}
    .tab_header tr th:nth-child(2) {width:50%!important;}
    .tab_header tr th:nth-child(3) {width:5%!important;}
    .tab_header tr th:nth-child(4) {width:10%!important;}
    .tab_header tr th:nth-child(5) {width:10%!important;}
    .tab_header tr th:nth-child(6) {width:10%!important;}
    .tab_header tr th:nth-child(7) {width:10%!important;}

    #village_view_build_list tr td:first-child {width:5%!important;}
    #village_view_build_list tr td:nth-child(2) {width:50%!important;}
    #village_view_build_list tr td:nth-child(3) {width:5%!important;}
    #village_view_build_list tr td:nth-child(4) {width:10%!important;}
    #village_view_build_list tr td:nth-child(5) {width:10%!important;}
    #village_view_build_list tr td:nth-child(6) {width:10%!important;}
    #village_view_build_list tr td:nth-child(7) {width:10%!important;}

  </style>
</head>
<body>
<div class="village_new_searchbar">
  <table style = "width:100%">
    <tr>
      <td>
        <div class="count_num desk_orange_bar inside_data">
          楼宇数：<span id="village_view_build_record_total_count" style ="color:#FF0000">0</span>&nbsp;&nbsp;
          资源已达楼宇：<span id="village_view_build_record_exist" style ="color:#FF0000">0</span>&nbsp;&nbsp;
          资源未达楼宇：<span id="village_view_build_record_noexist" style ="color:#FF0000">0</span>
        </div>
      </td>
    </tr>
    <tr>
      <td>
        <div class="collect_new_choice" style ="position:relative;padding-top:2px;color:black;width:100%;">
          <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
            楼宇:&nbsp;
            <select id="ly_collect_new_build_list" onchange="ly_load_build_info(0)" style="width:92%;padding-left:0px;"></select>
            <input type="text" id="ly_collect_new_build_name" oninput="ly_load_build_name_list()" style="margin-left:0;padding-left:0px;border:none;display: none;">
            <ul id="ly_collect_new_build_name_list" style="width:100%;margin-left:0;padding-left:85px;">
            </ul>
          </div>
        </div>

        <div class="collect_new_choice" style="position:relative;color:black;width:96%;margin:0 auto;">
          <div class="collect_contain_choice" style="margin:0px auto 0px auto;width: 40%;float:left;">
            <span style="font-weight:bold;">社队:</span>
            <select id="collect_new_build_list_sj_info" onchange="queryBySD()" style="width: 92%;padding-left:0px;"><option value="-1" select="selected">全部</option><option value="2553008001">堡上社</option><option value="2553008002">堡下社</option><option value="2553008003">地窑社</option><option value="2553008006">沟老社</option><option value="2553008007">老庄社</option><option value="2553008008">庙上社</option><option value="2553008009">庙下社</option><option value="2553008010">新庄社</option><option value="2553008004">杜家桥社</option><option value="2553008005">杜家庄社</option><option value="2553008011">寨子沟社</option><option value="2553008012">峁丹沟社</option></select>
          </div>
          <div id="collect_bselect1" align="left" class="tab_accuracy_head follow_head small_padding collect_contain_choice" style="margin:0px 0px 0px 5%;width: 45%;float:left;">
            <b style="font-weight:bold;">类型:</b>
            <span class="active" onclick="select_collect_band1(-1)" id="collect_all1">全部<span id="collect_new_a_count1">(0)</span></span>
            <span onclick="select_collect_band1(1)"> 移动<span id="collect_new_y_count1">(0)</span></span>
            <span onclick="select_collect_band1(2)"> 联通<span id="collect_new_l_count1">(0)</span></span>
            <span onclick="select_collect_band1(3)"> 广电<span id="collect_new_g_count1">(0)</span></span>
            <span onclick="select_collect_band1(4)"> 其他<span id="collect_new_q_count1">(0)</span></span>
            <span onclick="select_collect_band1(0)"> 占线用户<span id="collect_new_d_count1">(0)</span></span>
          </div>
          <div style="float:left;display:inline-block;width:5%;" class="collect_contain_choice">
            <input type="button" value="收集" class="btn" id="collect_add_btn">
          </div>
        </div>

      </td>
    </tr>
    <tr>
      <td>
        <span>
            <div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" id="res_tb">
              资源到达：
              <span class="active" value="1" id ="res_select">全部 (<span id="village_view_build_resource_all" style ="color:#FF0000">0</span> )</span>
              <span  value="2">已达楼宇 (<span id="village_view_build_resource_exist" style ="color:#FF0000">0</span> )</span>
              <span  value="3">未达楼宇 (<span id="village_view_build_resource_noexist" style ="color:#FF0000">0</span> )</span>
            </div>
         </span>
      </td>
    </tr>
  </table>
</div>


<div style="width: 96%;margin:0 auto;">
  <div class="village_m_tab blue_thead tab_head_lock" style="width:100%;padding-right:17px;height:auto;">
    <table class="content_table tab_header" style="width:100%;" cellspacing="0" cellpadding="0">
      <tr>
        <th>序号</th>
        <th>楼宇</th>
        <th>住户数</th>
        <th>光宽用户数</th>
        <th>宽带渗透率</th>
        <th>端口数</th>
        <th>端口占用率</th>
      </tr>
    </table>
  </div>
  <div class="exec_tab_body desk_tab tab_scroll" style="overflow-y:scroll;width:100%;">
    <table class="content_table tab_body" id="village_view_build_list" style="width:100%;" cellspacing="0" cellpadding="0">
    </table>
  </div>
</div>
</body>
</html>
