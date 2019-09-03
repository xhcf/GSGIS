<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
   	<head>
   	<title>文本绑定组件</title>
   	<c:resources type="easyui"  style="b"/>
   	<e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
   	</head>
   	<body>
		<e:q4o var="textBindObj">
		   select '431' AREA_NO,'长春' AREA_DESC,'1200' VALUE from dual
		</e:q4o>

	   同步方式：
	    <br/>
		<a:textbind id="tbd" width="500px" height="100px" delimiter="@" itemJson="${e:java2json(textBindObj)}">
		    <table style="border:solid 1px;width:100%;height:100%"">
		       <tr>
		       	  <td style="border:solid 1px;width:250px">地市编码: <font color="#c00">@AREA_NO@</font></td>
		       	  <td style="border:solid 1px;width:250px">地市名称: <font color="#c00">@AREA_DESC@</font></td>
		       	  <td style="border:solid 1px;width:250px">产值: <font color="#c00">@VALUE@</font></td>
		       </tr>
		    </table>
		</a:textbind>
		
	  异步方式：
	  <br/>
	  <a:textbind id="tbd2" width="500px" height="100px" delimiter="#"  url="/examples/textbind/action.jsp">
		    <table style="border:solid 1px;width:100%;height:100%">
		       <tr>
		       	  <td style="border:solid 1px;width:250px"><font color="#c00">地市编码:#AREA_NO#</font></td>
		       	  <td style="border:solid 1px;width:250px"><font color="#c00">地市名称:#AREA_DESC#</font></td>
		       	  <td style="border:solid 1px;width:250px"><font color="#c00">产值:#VALUE#</font></td>
		       </tr>
		    </table>
		</a:textbind>
</body>
</html>
