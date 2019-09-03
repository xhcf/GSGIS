<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="today_ymd">
  SELECT TO_CHAR(SYSDATE,'YYYY'||'"年"'||'MM'||'"月"'||'DD'|| '"日"') val FROM DUAL
</e:q4o>
<e:q4o var="today_time">
  SELECT TO_CHAR(SYSDATE,'hh24'||'":"'||'mi'||'":"'||'ss') val FROM DUAL
</e:q4o>
<e:q4o var="now">
  SELECT TO_CHAR(SYSDATE,'YYYYMMDD') val FROM DUAL
</e:q4o>
<e:q4o var="yesterday">
  SELECT TO_CHAR(SYSDATE-1,'YYYYMMDD') val FROM DUAL
</e:q4o>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" content="ie=edge"/>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
  <title>实时发展量</title>
  <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css" />
  <link href='<e:url value="/resources/css/reset.css"/>' rel="stylesheet" type="text/css" />
  <link href='<e:url value="/resources/css/style.css"/>' rel="stylesheet" type="text/css" />
  <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <e:script value="/resources/layer/layer.js" />
  <c:resources type="easyui,app" style="b"/>
  <script src='<e:url value="/resources/component/echarts_2/echarts-all.js"/>'></script><!-- echarts 2.2.7 -->
  <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
  <!-- <script src='<e:url value="/pages/telecom_Index/common/js/lazyFade.js"/>' charset="utf-8"></script> -->
  <script src='<e:url value="/pages/telecom_Index/common/js/dz.js"/>' charset="utf-8"></script>
<%--     <script src='<e:url value="/pages/telecom_Index/common/js/jquery-2.1.1.js"/>' charset="utf-8"></script>
 --%>
  <script src='<e:url value="/pages/telecom_Index/common/js/modernizr.js"/>' charset="utf-8"></script>
<%--      <script src='<e:url value="/pages/telecom_Index/common/js/main.js"/>' charset="utf-8"></script>
 --%>
  <script src='<e:url value="/pages/telecom_Index/common/js/setDataToEchartMap1.js"/>' charset="utf-8"></script>
  <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
  <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/real_time_dev/css/viewPlane_realTime.css"/>' rel="stylesheet" type="text/css" media="all" />
</head>
<body style="margin:0px;padding:0px;">
<div style="height:99.8%;width:99.5%;margin:0px auto;overflow:hidden;">
  <div data-options="region:'north'" style="height:59.7%;margin-top:0.3%;overflow:hidden;" class="realtimeContainer">
    <div class="map_area">
      <div class="opacity_bg"></div>
      <div class="alpha_content" style="width:100%;height:100%;padding:0px;">
        <div class="title_pos ico1">地图</div>
        <div id="pagemap" name="pagemap" style=""></div>
        <%--<div style="position:absolute;top:300px;left:20px" id="color_tab">
          <table>
            <tbody><tr><td style="color:#ef0a25">●</td><td style="color:#fff;">&nbsp;强</td></tr>
            <tr><td style="color:#ef960a">●</td><td style="color:#fff;">&nbsp;中</td></tr>
            <tr><td style="color:#7ad589">●</td><td style="color:#fff;">&nbsp;弱</td></tr>
            </tbody></table>
        </div>--%>
        <%--<iframe id="mapContainer" style="margin:0px;padding:0px;border:0px;height:100%;width:100%;overflow:auto;box-shadow:none;"></iframe>--%>
      </div>
    </div>
    <div class="realTime_title">
      <div class="opacity_bg"></div>
      <div class="alpha_content">
        <div class="date">-年-月-日 <span>-:-:-</span></div>
        <span class="title_text">实时发展量</span>
      </div>
    </div>
    <div class="realTime_data">
      <div class="opacity_bg"></div>
      <div class="alpha_content">
        <table cellspacing="0" cellpadding="0" border="0" class="data_show_layout">
          <tr> 
            <td>
              <div class="ss_title"><span class="mobile">移动</span></div>
<!--               <marquee width="150px" height="50px" scrollamount="10" direction="right" scrooldelay="10"><span class="span_fazhan">- -</span></marquee>
 -->            <section class="cd-intro">
					<h1 class="cd-headline letters rotate-3">
						<span class="span_fazhan">
							<b class="is-visible" style="position: absolute;width: 100%;left:0"></b>
							<b style="position: absolute;width: 100%;left:0"></b>
						</span>
					</h1>
				</section> 
              
            </td>
            <td>
              <div class="ss_title"><span class="board">宽带</span></div>
<!--               <marquee width="150px" height="50px" scrollamount="10" direction="right" scrooldelay="10"><span class="span_fazhan">- -</span></marquee>
 -->              <section class="cd-intro">
					<h1 class="cd-headline letters rotate-3">
						<span class="span_fazhan">
							<b class="is-visible" style="position: absolute;width: 100%;left:0"></b>
							<b style="position: absolute;width: 100%;left:0"></b>
						</span>
					</h1>
				</section>
            </td>
            <td style="border-right:none;">
              <div class="ss_title"><span class="ITV">ITV</span></div>
<!--               <marquee width="150px" height="50px" scrollamount="10" direction="right" scrooldelay="10"><span class="span_fazhan">- -</span></marquee>
 -->              <section class="cd-intro">
					<h1 class="cd-headline letters rotate-3">
						<span class="span_fazhan">
							<b class="is-visible" style="position: absolute;width: 100%;left:0"></b>
							<b style="position: absolute;width: 100%;left:0"></b>
						</span>
					</h1>
				</section>
            </td>
          </tr>
          <tr>
            <td>
              <div class="ss_title"><span class="flow">流量包</span></div>
              <span class="span_fazhan">2030</span>
            </td>
            <td>
              <div class="ss_title"><span class="flow_800">十全十美</span></div>
              <span class="span_fazhan">1942</span>
            </td>
            <td style="border-right:none;">
              <div class="ss_title"><span class="packet">红包卡</span></div>
              <span class="span_fazhan">3548</span>
            </td>
          </tr>
        </table>
        <!-- <ul class="data_layout clearfix">
        	<li>
        		<p class="c_mobile"></p>
        		<dl>
        			<dt>宽带用户</dt>
        			<dd>21800</dd>
        		</dl>
        	</li>
        </ul> -->
      </div>
    </div>
  </div>
  <div data-options="region:'south'" style="height:38.7%;margin-top:0.3%;clear:both;display:block;overflow:hidden;" class="realTimebottom_content">
    <!-- 一块表格内容 -->
      <div class="realTime_tab_layout">
          <div class="opacity_bg"></div>
          <div class="alpha_content">
              <table cellspacing="0" cellpadding="0" border="0" class="content_tab">
                  <thead>
                  <th>序号</th>
                  <th>分公司</th>
                  <th class="td2" colspan="3">
                  	<em>移动</em>
                  	<em>宽带</em>
                  	<em>ITV</em>
                  </th>                 
                  </thead>
                  <tbody>
                  <tr>
                      <td>1</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>2</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>3</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>4</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>5</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                     <td>6</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>7</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  </tbody>
              </table>
          </div>
      </div>
      <!-- 一块表格内容end -->
      <!-- 一块表格内容 -->
      <div class="realTime_tab_layout">
          <div class="opacity_bg"></div>
          <div class="alpha_content">
              <table cellspacing="0" cellpadding="0" border="0" class="content_tab">
                  <thead>
                  <th>序号</th>
                  <th>分公司</th>
                  <th class="td2" colspan="3">
                  	<em>移动</em>
                  	<em>宽带</em>
                  	<em>ITV</em>
                  </th>                 
                  </thead>
                  <tbody>
                  <tr>
                      <td>8</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>9</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>10</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>11</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>12</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                     <td>13</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  <tr>
                      <td>14</td>
                      <td>- -</td>
                      <td class="td2" colspan="3">
                      	<em>- -</em>
                      	<em>- -</em>
                      	<em>- -</em>
                      </td>
                  </tr>
                  </tbody>
              </table>
          </div>
      </div>
    <!-- 一块表格内容end -->
    <!-- 趋势图 -->
    <div class="realTime_tab_layout" style="float:right">
      <div class="opacity_bg"></div>
      <div class="alpha_content">
        <div class="title title_pos">实时发展趋势</div>
        <div class="figure" id="figure" style="width:100%;height:98%;">
        </div>
      </div>
    </div>
    <!-- 趋势图end -->
  </div>
</div>
</body>
</html>
<script type="text/javascript">
  var global_province_py = province_name_py;
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

  var realTime_subList_data = new Array();//14地市的发展量

  var global_position = new Array(5);//化小五层结构

  var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData.jsp"/>?eaction=';

  var params = new Object();
  params.date = '${now.VAL}';
  //各地市发展量列表
  var url4realTimeSubList = url4Query+'realTimeSubList';
  //六个业务类型的发展量
  var url4realTimeNum = url4Query+'realTimeNum';
  //日发展趋势图
  var url4RealTimeDev_figure_monthAvg = url4Query+'realTimeFigureMonthAvg';
  var url4RealTimeDev_figure_current = url4Query+'realTimeFigureCurrent';
  //var url4getNearlyTime = url4Query+'getNearlyTime';

  ///日发展趋势图

  var chart_line = "";
  var chart_map = "";

  var interval_time = 5*1000;//刷新频率(毫秒)
  var database_update_delay = 5*1000;//数据库端更新延迟
  var interval_time_figure = 300*1000;//日实时发展趋势

  var time = '${today_time.VAL}';
  var time_arry = time.split(":");
  var date = '${today_ymd.VAL}';
  var year = date.substr(0,date.indexOf("年"));
  var month = date.substring(date.indexOf("年")+1,date.indexOf("月"));
  var day = date.substring(date.indexOf("月")+1,date.indexOf("日"));
  var dt = new Date();//秒表
  dt.setFullYear(parseInt(year));
  dt.setMonth(parseInt(month)-1);
  dt.setDate(parseInt(day));
  dt.setHours(parseInt(time_arry[0]));
  dt.setMinutes(parseInt(time_arry[1]));
  dt.setSeconds(parseInt(time_arry[2]));

  $(function(){
    //global_current_area_name = encodeURI(global_current_area_name);//后面页面用Parent取值，传递发生乱码，这里不传递，也就不编码
    //global_current_index_type = encodeURI(global_current_index_type);
    if(isIE()){
        var pageMapHeight = $(window).height();
        if(pageMapHeight==0)
            pageMapHeight = parent.document.documentElement.clientHeight;
        $(".realtimeContainer").height(pageMapHeight*0.597);
        $(".realTimebottom_content").height(pageMapHeight*0.387);

        $("#figure").height($(".realTime_tab_layout").height());
        $("#figure").width($(".realTime_tab_layout").width());
    }

    chart_line = echarts.init(document.getElementById('figure'));

    //初始化地图
    var size = getEchartsMapSize();
    $("#pagemap").height(size.height);
    $("#pagemap").width(size.width);
    $("#color_tab").css({'top':size.height-66});
    chart_map = echarts.init(document.getElementById('pagemap'));

    $(".date").html('${today_ymd.VAL}'+"<span>"+time+"</span>");

    //右上角时间指示
    setInterval(
      function(){
        dt.setTime(dt.getTime()+1000);
        $(".date").html(dt.getFullYear()+"年"+("0"+(dt.getMonth()+1)).slice(-2)+"月"+("0"+(dt.getDate())).slice(-2)+"日"+"<span>"+("0"+dt.getHours()).slice(-2)+":"+("0"+dt.getMinutes()).slice(-2)+":"+("0"+dt.getSeconds()).slice(-2));
      },1000
    );

    params.parent_name = global_parent_area_name;
    params.province_py = global_province_py;
    params.city_name = global_current_area_name;
    params.city_full_name = global_current_full_area_name;
    params.index_type = global_current_index_type;
    params.flag = global_current_flag+1;

    //加载地图
    freshEchartMap();
    setInterval(function(){
      freshEchartMap();
    },interval_time);

    //加载六个发展量大数字
    var realTime_dev_tr = $(".data_show_layout").find("tr");
    var td_arry = new Array();
    for(var i = 0,l = realTime_dev_tr.length;i<l;i++){
      var tr = $(realTime_dev_tr[i]);
      var tds = tr.children();
      for(var j = 0,k = tds.length;j<k;j++){
        td_arry.push($(tds[j]).children().eq(1));
      }
    }
    freshDevNum(td_arry);
    initHeadline();
    //刷新6个数
     setInterval(function(){
      freshDevNum(td_arry);
      initHeadline();
    },interval_time);  

    //加载地市发展列表
    var realTime_subList_tabs = $(".content_tab");
    var realTime_subList_trs = new Array();

    for(var i = 0,l = realTime_subList_tabs.length;i<l;i++){
      var tab = realTime_subList_tabs[i];
      var trs = $(tab).children().eq(1).find("tr");
      for(var j = 0,k = trs.length;j<k;j++){
        realTime_subList_trs.push(trs[j]);
      }
    }
    freshSubList(realTime_subList_trs,realTime_subList_data);

    //刷新地市发展表格
    setInterval(function(){
      realTime_subList_data = new Array();
      freshSubList(realTime_subList_trs,realTime_subList_data);
    },interval_time);

    //加载若干个日发展实时趋势曲线值，并在方法中时段的更新曲线图
    loadFigureByDay();
  });

  function freshEchartMap() {
    //查询地图的数据
    //echart地图下钻要加载的页面
    var url4mapToWhere = '<e:url value="/pages/telecom_Index/sub_grid/viewPlane_city_dev_colorflow.jsp"/>';
    params.geoCoord = geoCoordMap;
    setDataToEchartMap(params,url4realTimeSubList,url4mapToWhere);
  }

  //各地市发展量列表
  function freshSubList(realTime_subList_trs,realTime_subList_data){
    $.ajax({
      type: "POST",
      url: url4realTimeSubList,
      data: params,
      success: function (data) {
        var d = $.parseJSON(data);
        if (d.length == 0)
          layer.msg('暂无数据');
        else {
          for (var i = 0; i < d.length; i++) {
            var latn_obj = new Object();
            latn_obj.REGION_NAME = d[i].REGION_NAME;
            latn_obj.DEV_MOB = d[i].DEV_MOB;
            latn_obj.DEV_ADSL = d[i].DEV_ADSL;
            latn_obj.DEV_ITV = d[i].DEV_ITV;
            realTime_subList_data.push(latn_obj);
          }
        }
      },
      error: function () {
        layer.msg('查询出错');
      },
      complete: function () {
      /*   $(realTime_subList_trs).each(function(index,dom){
            $(dom).children(":gt(1)").children().fadeOut();
        }); */
        for (var i = 0, l = realTime_subList_trs.length; i < l; i++) {
          var tr = realTime_subList_trs[i];
          
          var tr2 = "";
          if(i==0){
             tr2 = realTime_subList_trs[13];
          }else{
             tr2 = realTime_subList_trs[i-1];
          }
          var tds = $(tr).children().slice(1);
          var tds2 = $(tr2).children().slice(1);
          var latn_obj = realTime_subList_data[i];
          if (latn_obj != undefined) {
            $(tds[0]).html(latn_obj.REGION_NAME);
            showNum(tds,tds2,latn_obj,i);
          }
        }
      }
    })
  }
  function showNum(tds,tds2,latn_obj,i){
      setTimeout(function(){
          var em_list = $(tds[1]).children();
          var em_list2 = $(tds2[1]).children();
          em_list.eq(0).css({"color":"#ffffff"});
          em_list.eq(0).html(latn_obj.DEV_MOB);
          em_list2.eq(0).css("color","#ff8a00");

          em_list.eq(1).css({"color":"#ffffff"});
          em_list.eq(1).html(latn_obj.DEV_ADSL);
          em_list2.eq(1).css("color","#ff8a00");

          em_list.eq(2).css({"color":"#ffffff"});
          em_list.eq(2).html(latn_obj.DEV_ITV);
          em_list2.eq(2).css("color","#ff8a00");
          },(i+1)*357
      )
  }
  function freshDevNum(td_arry){
    //六个业务类型的发展量
    var d = "";
    $.ajax({
      type:"POST",
      url:url4realTimeNum,
      data:params,
      success:function(data){
        d = $.parseJSON(data);
        if(d.length==0){
          layer.msg('暂无数据');
        }
      },
      error:function(){
        layer.msg('查询出错');
      },
      complete:function(){
        d = d[0];
        
       if(d.DEV_MOB!='' && d.DEV_MOB!=undefined && d.DEV_MOB!=null){
       //$(".ss_title").eq(0).siblings().find("b").eq(0).html(d.DEV_MOB);
       //initHeadline();
       //$(".ss_title").eq(0).siblings().find("b").eq(1).html(d.DEV_MOB);
       //initHeadline();
       		 $(".ss_title").eq(0).siblings().find("b").each(function(){
       		 	$(this).html(d.DEV_MOB);
       		 });  
       		 
        }
        if(d.DEV_ADSL!='' && d.DEV_ADSL!=undefined && d.DEV_ADSL!=null){
       		//$(".ss_title").eq(1).siblings().find("b").eq(0).html(d.DEV_ADSL);
	        //initHeadline();
	        //$(".ss_title").eq(1).siblings().find("b").eq(1).html(d.DEV_ADSL);
	        //initHeadline();
	        $(".ss_title").eq(1).siblings().find("b").each(function(){
       		 	$(this).html(d.DEV_ADSL);
       		 });
        }
        if(d.DEV_ITV!='' && d.DEV_ITV!=undefined && d.DEV_ITV!=null){
       	   //$(".ss_title").eq(2).siblings().find("b").eq(0).html(d.DEV_ITV);
	       //initHeadline();
	       //$(".ss_title").eq(2).siblings().find("b").eq(1).html(d.DEV_ITV);
	       //initHeadline();
	       $(".ss_title").eq(2).siblings().find("b").each(function(){
       		 	$(this).html(d.DEV_ITV);
       		 });
        }
        /* var textarr = new Array();
        textarr.push(d.DEV_MOB+"");
        textarr.push(d.DEV_ADSL+"");
        textarr.push(d.DEV_ITV+"");
        textarr.push("");
        textarr.push("");
        textarr.push("");
        start_Arr(td_arry,textarr); */
        
      }
    })
  }
  
  
  function freshMapContainer(new_url){
    document.getElementById('mapContainer').src=new_url;
  }
  function freshIndexContainer(){
    document.getElementById('indexContainer').contentWindow.location.reload(true);
  }
  function getEchartsMapSize(){
    var size = {};
    size.width = $(".alpha_content").eq(0).width();
    size.height = $(".alpha_content").eq(0).height();
    return size;
  }
  function loadFigureByDay(){
    var time_array = new Array();
    var hour = 0;
    var minutes = 0;
    var time_by_5_minutes = "00:00";
    for(var h = 9;h<=20;h++){
      hour = h;
      if(h==20){
        time_array.push("20:00");
      }else{
        for(var m = 0;m<=55;){
          minutes = m;
          m += 5;
          time_by_5_minutes = (hour<10?("0"+hour):hour)+":"+(minutes<10?("0"+minutes):minutes);
          time_array.push(time_by_5_minutes);
        }
      }
    }
    var month_avg_dev_num_array = new Array();
    var time_avg_dev_num_array = new Array();

    var len = (20-9)*(60/5);
    params.len = len;
    params.date = '${now.VAL}';
    var option = {
      title: {
        text: '',
        subtext: ''
      },
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: ['当日','月均'],
        x:'right',
        y:'10',
        itemWidth:10,  //图例标记的图形宽度
        itemHeight:10, //图例标记的图形高度
        textStyle:{    //图例文字的样式
          color:'#fff',
          fontSize:10
        }
      },
      grid: {
        x: 20,
        y: 40,
        x2: '20',
        y2: '14%',
        borderWidth:0//此处去掉那个白色边框
      },
      toolbox: {
        show: false,
        feature: {
          mark: {show: true},
          dataView: {show: true, readOnly: false},
          magicType: {show: true, type: ['line', 'bar', 'stack', 'tiled']},
          restore: {show: true},
          saveAsImage: {show: true}
        }
      },
      calculable: true,
      xAxis: [
        {
          type: 'category',
          boundaryGap: false,
          splitLine:{show: false},//去除网格线
          splitArea : {show : false},//保留网格区域
          axisLine: {
            lineStyle: {
              color:'#fff',
              width:1
            }
          },
          axisLabel: {
            show: true,
            textStyle: {
              color: '#fff'
            }
          },
          data: time_array,
          axisTick: {
            interval: 11
          },
          axisLabel: {
            interval: 11,
            textStyle: { color:"#FFF" }
          }
        }
      ],
      yAxis: [
        {
          show:false,
          splitLine:{show: false},//去除网格线
          splitArea : {show : false},//保留网格区域
          type: 'value'
        }
      ],
      series: [
          {
              name: '当日',
              type: 'line',
              symbol:'none',
              smooth: true,
              stack: '发展',
              itemStyle: {
                normal: {
                  color:'#39d095',
                  lineStyle: {color:'#00fa8d',width:1},
                  areaStyle: {type: 'default'}
                }
              },
              data: time_avg_dev_num_array
          },
          {
              name: '月均',
              type: 'line',
              symbol:'none',
              smooth: true,
              stack: '发展',
              itemStyle: {
                  normal: {
                      color:'#fff',
                      lineStyle: {color:'#f3e378',width:1},
                      areaStyle: {type: 'default'}
                  }
              },
              data: month_avg_dev_num_array
          }
      ]
    };

    //月均
    params.date = '${yesterday.VAL}';
    $.post(url4RealTimeDev_figure_monthAvg,params,function(data) {
      data = $.parseJSON(data);
      var l = data.length;
      if (l == 0) {
        //layer.alert("实时发展趋势暂无数据");
        //return;
      } else {
        //month_avg_dev_num_array.push(0);
        for(var i = 0;i<l;i++){
          //hour_array.push(time_array[i]);
          month_avg_dev_num_array.push(data[i].DEV_MOB_AVG);
        }

        //日均
        params.date = '${now.VAL}';
        params.now = dt.getFullYear()+("0"+(dt.getMonth()+1)).slice(-2)+("0"+(dt.getDate())).slice(-2)+("0"+dt.getHours()).slice(-2)+("0"+dt.getMinutes()).slice(-2)+("0"+dt.getSeconds()).slice(-2);
        $.post(url4RealTimeDev_figure_current,params,function(data1) {
          data1 = $.parseJSON(data1);
          var l = data1.length;
          if (l == 0) {
            //layer.alert("实时发展趋势暂无数据");
            //return;
          } else {
           // time_avg_dev_num_array.push(0);
            for(var i = l-1;i>0;i--){
              //hour_array.push(time_array[i]);
              time_avg_dev_num_array.push(data1[i].DEV_MOB_CHA);
            }
          }

          option.series[0].data = time_avg_dev_num_array;
          option.series[1].data = month_avg_dev_num_array;

          chart_line.setOption(option);
        });
      }
    });



    //当日移动实时发展量赋值过程
    /*var date_begin = new Date();
    date_begin.setFullYear(parseInt(year));
    date_begin.setMonth(parseInt(month)-1);
    date_begin.setDate(parseInt(day));
    date_begin.setHours(9);
    date_begin.setMinutes(0);
    date_begin.setSeconds(0);

    var date_end = new Date();
    date_end.setFullYear(parseInt(year));
    date_end.setMonth(parseInt(month)-1);
    date_end.setDate(parseInt(day));
    date_end.setHours(20);
    date_end.setMinutes(0);
    date_end.setSeconds(0);*/

    /*var length = ((dt.getHours()-9)*60+dt.getMinutes())/5;
    for(var i = 0,l = (20-9)*(60/5);i<l;i++){
      if(i<length){
        //time_avg_dev_num_array.push((i+0.3)*10+ parseInt(Math.random() * 10)+30);
        time_avg_dev_num_array.push(parseInt(Math.random() * 50));
      }else{
      }
    }*/
    //实时日发展趋势更新↓
    setInterval(function(){
      freshFigureByDay();
    },interval_time_figure);//interval_time_figure

    /*setTimeout(function(){
      //及时刷新一次，跟进数据库距离现在时刻最近的一次更新
      freshFigureByDay();
      //随后，每隔一个时段刷新实时曲线图
      setInterval(function(){
        freshFigureByDay();
      },interval_time);
    },should_updte_figue);*/
  }

  function freshFigureByDay(){
    var option = chart_line.getOption();
    //var axisData = ("0"+dt.getHours()).slice(-2)+":"+("0"+dt.getMinutes()).slice(-2)+":"+("0"+dt.getSeconds()).slice(-2);
    var data0 = option.series[0].data;
    //data0.shift();
    params.len = 1;
    params.date = '${now.VAL}';
    params.now = dt.getFullYear()+("0"+(dt.getMonth()+1)).slice(-2)+("0"+(dt.getDate())).slice(-2)+("0"+dt.getHours()).slice(-2)+("0"+dt.getMinutes()).slice(-2)+("0"+dt.getSeconds()).slice(-2);

    $.post(url4RealTimeDev_figure_current,params,function(data){
       data = $.parseJSON(data);
       if(data.length==0){
        data0.push(data0[data0.length-1]);
       }else{
        data0.push(data[0].DEV_MOB_CHA);
       }
       /*option.xAxis[0].data.shift();
       option.xAxis[0].data.push(data[0].UP_TIME);*/
       option.series[0].data = data0;
       chart_line.setOption(option);
     });

    /*data0.push(Math.random() * 10);
      option.xAxis[0].data.shift();
      option.xAxis[0].data.push(data[0].UP_TIME);
      option.series[0].data = data0;
      chart_line.setOption(option);*/
  }

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
  
	//set animation timing
	var animationDelay = 4900,
		//loading bar effect
		barAnimationDelay = 3800,
		barWaiting = barAnimationDelay - 3000, //3000 is the duration of the transition on the loading bar - set in the scss/css file
		//letters effect
		lettersDelay = 200,
		//type effect
		typeLettersDelay = 150,
		selectionDuration = 500,
		typeAnimationDelay = selectionDuration + 800,
		//clip effect 
		revealDuration = 600,
		revealAnimationDelay = 1500; 
	
	//initHeadline();
	

	function initHeadline() {
		//insert <i> element for each letter of a changing word
		singleLetters($('.cd-headline.letters').find('b'));
		//initialise headline animation
		animateHeadline($('.cd-headline'));
	}

	function singleLetters($words) {
		$words.each(function(){
			var word = $(this),
				letters = word.text().split(''),
				selected = word.hasClass('is-visible');
			for (i in letters) {
				if(word.parents('.rotate-2').length > 0) letters[i] = '<em>' + letters[i] + '</em>';
				letters[i] = (selected) ? '<i class="in">' + letters[i] + '</i>': '<i>' + letters[i] + '</i>';
			}
		    var newLetters = letters.join('');
		    word.html(newLetters);
		});
	}	

	function animateHeadline($headlines) {
		var duration = animationDelay;
		$headlines.each(function(){
			var headline = $(this);
			
			if(headline.hasClass('loading-bar')) {
				duration = barAnimationDelay;
				setTimeout(function(){ headline.find('.cd-words-wrapper').addClass('is-loading') }, barWaiting);
			} else if (headline.hasClass('clip')){
				var spanWrapper = headline.find('.cd-words-wrapper'),
					newWidth = spanWrapper.width() + 10
				spanWrapper.css('width', newWidth);
			} else if (!headline.hasClass('type') ) {
				//assign to .cd-words-wrapper the width of its longest word
				var words = headline.find('.cd-words-wrapper b'),
					width = 0;
				words.each(function(){
					var wordWidth = $(this).width();
				    if (wordWidth > width) width = wordWidth;
				});
				headline.find('.cd-words-wrapper').css('width', width);
			};

			//trigger animation
			setTimeout(function(){ hideWord( headline.find('.is-visible').eq(0) ) }, duration);
		});
	}

	function hideWord($word) {
		var nextWord = takeNext($word);
		
		if($word.parents('.cd-headline').hasClass('type')) {
			var parentSpan = $word.parent('.cd-words-wrapper');
			parentSpan.addClass('selected').removeClass('waiting');	
			setTimeout(function(){ 
				parentSpan.removeClass('selected'); 
				$word.removeClass('is-visible').addClass('is-hidden').children('i').removeClass('in').addClass('out');
			}, selectionDuration);
			setTimeout(function(){ showWord(nextWord, typeLettersDelay) }, typeAnimationDelay);
		
		} else if($word.parents('.cd-headline').hasClass('letters')) {
			var bool = ($word.children('i').length >= nextWord.children('i').length) ? true : false;
			hideLetter($word.find('i').eq(0), $word, bool, lettersDelay);
			showLetter(nextWord.find('i').eq(0), nextWord, bool, lettersDelay);

		}  else if($word.parents('.cd-headline').hasClass('clip')) {
			$word.parents('.cd-words-wrapper').animate({ width : '2px' }, revealDuration, function(){
				switchWord($word, nextWord);
				showWord(nextWord);
			});

		} else if ($word.parents('.cd-headline').hasClass('loading-bar')){
			$word.parents('.cd-words-wrapper').removeClass('is-loading');
			switchWord($word, nextWord);
			setTimeout(function(){ hideWord(nextWord) }, barAnimationDelay);
			setTimeout(function(){ $word.parents('.cd-words-wrapper').addClass('is-loading') }, barWaiting);

		} else {
			switchWord($word, nextWord);
			setTimeout(function(){ hideWord(nextWord) }, animationDelay);
		}
	}

	function showWord($word, $duration) {
		if($word.parents('.cd-headline').hasClass('type')) {
			showLetter($word.find('i').eq(0), $word, false, $duration);
			$word.addClass('is-visible').removeClass('is-hidden');

		}  else if($word.parents('.cd-headline').hasClass('clip')) {
			$word.parents('.cd-words-wrapper').animate({ 'width' : $word.width() + 10 }, revealDuration, function(){ 
				setTimeout(function(){ hideWord($word) }, revealAnimationDelay); 
			});
		}
	}

	function hideLetter($letter, $word, $bool, $duration) {
		$letter.removeClass('in').addClass('out');
		
		if(!$letter.is(':last-child')) {
		 	setTimeout(function(){ hideLetter($letter.next(), $word, $bool, $duration); }, $duration);  
		} else if($bool) { 
		 	setTimeout(function(){ hideWord(takeNext($word)) }, animationDelay);
		}

		if($letter.is(':last-child') && $('html').hasClass('no-csstransitions')) {
			var nextWord = takeNext($word);
			switchWord($word, nextWord);
		} 
	}

	function showLetter($letter, $word, $bool, $duration) {
		$letter.addClass('in').removeClass('out');
		
		if(!$letter.is(':last-child')) { 
			setTimeout(function(){ showLetter($letter.next(), $word, $bool, $duration); }, $duration); 
		} else { 
			if($word.parents('.cd-headline').hasClass('type')) { setTimeout(function(){ $word.parents('.cd-words-wrapper').addClass('waiting'); }, 200);}
			if(!$bool) { setTimeout(function(){ hideWord($word) }, animationDelay) }
		}
	}

	function takeNext($word) {
		return (!$word.is(':last-child')) ? $word.next() : $word.parent().children().eq(0);
	}

	function takePrev($word) {
		return (!$word.is(':first-child')) ? $word.prev() : $word.parent().children().last();
	}

	function switchWord($oldWord, $newWord) {
		$oldWord.removeClass('is-visible').addClass('is-hidden');
		$newWord.removeClass('is-hidden').addClass('is-visible');
	}
</script>
