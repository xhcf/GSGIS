<%--
  Created by IntelliJ IDEA.
  User: xuezhang
  Date: 17/6/21
  Time: 下午6:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="yesterday">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'day' and model_id = '3'
</e:q4o>
<html>
<head>
    <title>支局视图</title>
    <meta charset="utf-8">
    <meta name="author" content="jasmine"><!-- 定义作者-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href='<e:url value="/arcgis_js/esri/css/esri.css"/>' rel="stylesheet" type="text/css"/>

    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all"/>
    <link href='<e:url value="/resources/component/easyui/themes/default/easyui.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/component/easyui/icon.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_build_view.css"/>' rel="stylesheet"
          type="text/css" media="all"/>
          <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_area_dev_colorflow.css"/>' rel="stylesheet"
          type="text/css" media="all"/>
    <script type="text/javascript"
            src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script type="text/javascript"
            src='<e:url value="/resources/component/echarts_new/build/dist/echarts-all.js"/>'></script>
    <e:script value="/resources/layer/layer.js"/>
    <script type="text/javascript" src='<e:url value="/arcgis_js/init.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script type="text/javascript" src='<e:url value="/resources/component/easyui/jquery.easyui.min.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/Marquee2.js?version=1.2"/>' charset="utf-8"></script>
    <style type="text/css">
    body{background-color:#fff;}
    </style>
    <script type="text/javascript">
$(function(){

	
	//一次滚动一屏，不自动滚动，点击滚动，可作为导航
	$('#marquee4').kxbdSuperMarquee({
		isAuto:false,
		distance:232,
		btnGo:{left:'#goL2',right:'#goR2'},
		direction:'left',
		duration:100,
		scrollAmount:1,//步长
		scrollDelay:10,//时长
	});

	
});

</script>
</head>
<body style="width: 100%;height: 100%">
<div class="build_info_win detail" id="build_info_win" style="width:760px;top:10%;height:auto;overflow:hidden;">
	<div class="titlea"><div id="build_title" style='text-align:center'>楼宇详情</div><div  class="titlec" onclick="$('#build_info_win').hide()"></div></div>
	<div class="close"> </div>
	<a href="javascript:void(0);" id="goR2"></a>
	<a href="javascript:void(0);" id="goL2"></a>
	<div class="detail_block" id="marquee4">
	<table cellspacing="1" cellpadding="0" border="0" class="build_detail">
	  <tr>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer">电信</div>
		    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">联通</div>
		    <h4><a href="javascript:void(0)">502</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">503</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">504</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">505</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">506</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">507</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	  </tr>
	  <tr>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer">电信</div>
		    <h4><a href="javascript:void(0)">401</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">联通</div>
		    <h4><a href="javascript:void(0)">402</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">403</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">404</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">405</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">406</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	    <td>
	      <div class="detail_layout">
	        <div class="manufactuer_others">移动</div>
		    <h4><a href="javascript:void(0)">407</a></h4><span>黄田恬   18009517068</span>
		    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
		    <div class="bottom_info">
		      <div class="market_info">营销派单<span>(3)</span></div>
		      <div class="info_get">资料收集<span class="get"></span></div>
		    </div>
	      </div>
	    </td>
	  </tr>
	</table>
	
	</div>
	
	<!--  ul class="build_detail">
	  
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele active"></span><span class="itv active"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>

	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer_others">联通</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer_others">联通</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer_others">联通</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	  <li>
	    <div class="manufactuer">电信</div>
	    <h4><a href="javascript:void(0)">501</a></h4><span>黄田恬   18009517068</span>
	    <div class="icons"><span class="broad active"></span><span class="tele"></span><span class="itv"></span></div>
	    <div class="bottom_info">
	      <div class="market_info">营销派单<span>(3)</span></div>
	      <div class="info_get">资料收集<span class="get"></span></div>
	    </div>
	  </li>
	</ul-->
	

</div>

</body>
</html>

