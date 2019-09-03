<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today">
  select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '1'
</e:q4o>
<e:q4o var="date_in_month">
  SELECT
    TO_CHAR(TO_DATE(MON_A, 'yyyymmdd'), 'yyyymmdd') AS CURRENT_FIRST,
    TO_CHAR(LAST_DAY(TO_DATE(MON_A, 'yyyymmdd')),'yyyymmdd') AS CURRENT_LAST,
    TO_CHAR(TO_DATE(MON_B, 'yyyymmdd'), 'yyyymmdd') AS LAST_FIRST,
    TO_CHAR(LAST_DAY(TO_DATE(MON_B, 'yyyymmdd')), 'yyyymmdd') AS LAST_LAST
  FROM (SELECT TO_CHAR(TO_DATE('${today.val}', 'yyyymmdd'), 'yyyymm') || '01' MON_A,
    TO_CHAR(ADD_MONTHS(TO_DATE('${today.val}', 'yyyymmdd'), -1),
    'yyyymm') || '01' MON_B
    FROM DUAL)
</e:q4o>
<html>
  <head>
    <title>重点指标</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <c:resources type="easyui,app" style="b"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
    <script src='<e:url value="/resources/component/echarts_new/gansu.js"/>'></script>
    <script src='<e:url value="/resources/component/echarts_new/theme/dark.js"/>'></script>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/resources/scripts/admin1.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <style>
      html,body {margin:0; padding:0;height:100%;width:100%;border:none;background-color:none;font-family:微软雅黑;}
      .main{width:100%;height:100%;text-align:left;}
     #contentContainer{width:100%;height:100%;}
     iframe {border:none;}
    </style>
    <script type="text/javascript">
    $(function(){
      if(isIE()){
        var pageMapHeight = $(window).height();
        if(pageMapHeight==0)
          pageMapHeight = parent.document.documentElement.clientHeight;
        $("#contentContainer").height(pageMapHeight);
      }

      $("#contentContainer").attr("src",'<e:url value="/pages/telecom_Index/important_index/viewPlane_marketShare.jsp" />');

      $('.tabPanel ul li').click(function(){
          $(this).addClass('hit').siblings().removeClass('hit');

        global_parent_area_name = province_name;
        global_current_area_name = province_name;//这里将按权限改动： 从sessionScope里取得用户级别，省名或市名或区县等级别
        global_current_full_area_name = province_name;
        global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
        global_current_flag = default_flag;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1

        last_month_first = '${date_in_month.LAST_FIRST}';
        last_month_last = '${date_in_month.LAST_LAST}';
        current_month_first = '${date_in_month.CURRENT_FIRST}';
        current_month_last = '${date_in_month.CURRENT_LAST}';
        global_position = new Array(5);//化小五层结构

        var index = $(this).index();
        if(index==0){
          $("#contentContainer").attr("src",'<e:url value="/pages/telecom_Index/important_index/viewPlane_marketShare.jsp" />');
        } else if(index ==1){
          $("#contentContainer").attr("src",'<e:url value="/pages/telecom_Index/important_index/viewPlane_business.jsp" />');
        }
      })
  })
  </script>
  <style type="text/css">
  .easyui-layout.layout.easyui-fluid {width:100%;padding:0px;}
  </style>
  </head>
  <body style='background-image:url("<e:url value='/resources/themes/common/css/icons/total_bg.jpg' />")'>
    <div style="height:100%;width:100%;padding:0px;margin:0px;overflow:hidden;">
      <div data-options="region:'north'" style="height:95.0%;overflow:hidden;margin-top:0.3%;width:100%;padding:0px;" >
        <div id="tab_content" style="width:100%;">
            <iframe id="contentContainer" style="width:100%;padding:0px;border:0px;"></iframe>
        </div>
      </div>
      <div data-options="region:'south',split:true" style="height:4.7%;" class="tabPanel">
        <ul class="tag_layout">
          <li class="hit"><a href="javascript:void(0)">市场份额</a></li>
          <li><a href="javascript:void(0)">三大业务</a></li>
          <li style="display:none;"><a href="javascript:void(0)">800M</a></li>
          <li style="display:none;"><a href="javascript:void(0)">收入完成</a></li>
        </ul>
      </div>
    </div>
  </body>
</html>
<script type="text/javascript">
  var global_parent_area_name = province_name;
  var global_current_area_name = province_name;//这里将按权限改动： 从sessionScope里取得用户级别，省名或市名或区县等级别
  var global_current_full_area_name = province_name;
  var global_current_index_type = default_show_index;//右侧曲线图默认显示的标签卡，此处配置是“移动”
  var global_current_flag = default_flag;//这里将按权限改动： 根据用户所在级别定义，省为1，市2，区县3，支局4，网格5，此处配置1。查询时加1
  var global_current_city_id = 0;

  var last_month_first = '${date_in_month.LAST_FIRST}';
  var last_month_last = '${date_in_month.LAST_LAST}';
  var current_month_first = '${date_in_month.CURRENT_FIRST}';
  var current_month_last = '${date_in_month.CURRENT_LAST}';
  var global_position = new Array(5);//化小五层结构
  //查询地图的数据
  var url4query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>';
  var url4echartmap = url4query+'?eaction=echarts_map';

  function updatePosition(level){
    //var click_path = $(window.frames["mapContainer"].contentWindow.document).find("#click_path");
    var click_path = $("#click_path");
    var temp = "";
    for(var i =0;i<level;i++){
      var str = global_position[i];
      if(str == undefined)
        return;
      temp += global_position[i];
      if(i!=level-1)
        temp += ">";
    }
    click_path.html("当前路径："+temp);
  }

  function freshMapContainer(new_url){
    document.getElementById('mapContainer').src=new_url;
  }
  function freshIndexContainer(){
    document.getElementById('indexContainer').contentWindow.location.reload(true);
  }
</script>