<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:q4o var="textBindObj">
		   select '432' AREA_NO,'吉林' AREA_DESC,'1000' VALUE from dual
</e:q4o>${e:java2json(textBindObj)}