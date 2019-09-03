<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<html>
<head>
  <title></title>
  <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="http://www.jeasyui.net/Public/js/easyui/jquery.easyui.min.js"></script>
  <script type="text/javascript" src="<e:url value='pages/telecom_Index/tab_village_summary/js/datagrid-detailview.js' />"></script>
</head>
<body>
<e:description>
  <c:datagrid id="tt" url="pages/telecom_Index/tab_village_summary/data_test.jsp?eaction=test_sql" pageSize="15" rownumbers="false" style="width:800px;height:300px;" data-options="view:scrollview,pageSize:10,pagination:false">
    <thead>
      <tr>
        <th field="LATN_ID" halign="center" align='center' >aaaa</th>
        <th field="KD_HU_COUNT" halign="center" align='center' >aaaa</th>
        <th field="H_USE_CNT" halign="center" align='center' >aaaa</th>
      </tr>
    </thead>
  </c:datagrid>
</e:description>
  <table id="tt" class="easyui-datagrid" style="width:700px;height:300px"
         title="DataGrid - VirtualScrollView"
         data-options="view:detailview,rownumbers:true,singleSelect:true,
              url:'data_test.jsp?eaction=test_sql',autoRowHeight:false,pageSize:50">
    <thead>
    <tr>
      <th field="LATN_ID" halign="center" align='center' >aaaa</th>
      <th field="KD_HU_COUNT" halign="center" align='center' >aaaa</th>
      <th field="H_USE_CNT" halign="center" align='center' >aaaa</th>
    </tr>
    </thead>
  </table>
</body>
</html>
