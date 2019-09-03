<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
<link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
<link href='<e:url value="/pages/telecom_Index/common/css/indexTabs.css"/>' rel="stylesheet" type="text/css" media="all" />
<script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
<body style="width:100%;border:0px;" class="g_target">
  <h2 class="order_ico">全省支局排名</h2>
  <table cellspacing="0" cellpadding="0" border="0" class="new_table">
    <thead>
      <th>排名</th>
      <th>本地网</th>
      <th>支局名称</th>
      <th>市场份额</th>
      <th>累计份额</th>
    </thead>
    <tr>
      <td>1</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>2</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>3</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>4</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>5</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>6</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>7</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>8</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>9</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>10</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>11</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>12</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>13</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>14</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>15</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>16</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>17</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>18</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>19</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
    <tr>
      <td>20</td>
      <td>兰州</td>
      <td>工业城支局</td>
      <td>32.23%</td>
      <td>32.23%</td>
    </tr>
  </table>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
  <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/freshTab.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/freshChart.js"/>' charset="utf-8"></script>
  <script src='<e:url value="/pages/telecom_Index/common/js/freshRank.js"/>' charset="utf-8"></script>
  <script>
    var parent_name = parent.global_parent_area_name;
    var city_full_name = parent.global_current_full_area_name;
    var city_name = parent.global_current_area_name;
    var index_type = parent.global_current_index_type;
    var flag = parent.global_current_flag+1;
    var url4echartmap = parent.url4echartmap;
    var last_month_first = parent.last_month_first;
    var last_month_last = parent.last_month_last;
    var current_month_first = parent.current_month_first;
    var current_month_last = parent.current_month_last;

    var url4IndexTabQuery = parent.url4IndexTabQuery;

    parent.global_position.splice(0,1,province_name);
    parent.updatePosition(flag-1);

    var chart = "";
    $(function(){
      /*var pageMapHeight = $(window).height();
      if(pageMapHeight==0)
        pageMapHeight = parent.document.body.clientHeight-55;
      $("#pagemap").height(pageMapHeight);
      chart = echarts.init(document.getElementById('pagemap'),"dark");
      var params = new Object();
      params.parent_name = parent_name;
      params.city_name = city_name;
      params.city_full_name = city_full_name;
      params.index_type = index_type;
      params.flag = flag;

      //echart地图下钻要加载的页面
      var url4mapToWhere = '<e:url value="/pages/telecom_Index/viewPlane_city.jsp"/>';
      freshTab(city_name,parent.global_current_flag,parent.url4IndexTabQuery);
      freshChart(city_name,flag,index_type,last_month_first,last_month_last,current_month_first,current_month_last,url4IndexTabQuery);
      freshRank(city_name);*/
    });
  </script>
</body>
