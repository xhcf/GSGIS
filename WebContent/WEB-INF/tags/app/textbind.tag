<%@ tag body-content="scriptless" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                                  <e:description>id</e:description>
<%@ attribute name="url" required="false" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="itemJson" required="false"%>  											<e:description>数据集</e:description>
<%@ attribute name="width" required="false" %>                                              <e:description>宽度</e:description>
<%@ attribute name="height" required="false" %>                                             <e:description>高度</e:description>
<%@ attribute name="delimiter" required="false" %>                                          <e:description>分隔符</e:description>
<jsp:doBody var="bodyRes" />

<e:if condition="${width==null || width==''}">
	<e:set var="width">100%</e:set>
</e:if> 

<e:if condition="${height==null || height==''}">
	<e:set var="height">100%</e:set>
</e:if> 

<e:if condition="${!e:endsWith(width,'%')&&!e:endsWith(width,'px')}">
	<e:set var="width">${width}px</e:set>
</e:if> 

<e:if condition="${!e:endsWith(height,'%')&&!e:endsWith(height,'px')}">
	<e:set var="height">${height}px</e:set>
</e:if> 

<e:if condition="${delimiter==null || delimiter==''}">
	<e:set var="delimiter">@</e:set>
</e:if> 

<div id="${id}_container" style="width:${width};height:${height}">
	${bodyRes}
</div>
<script type="text/javascript">

String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {  
    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {  
        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);  
    } else {  
        return this.replace(reallyDo, replaceWith);  
    }  
}  

function parseTextBind${id}(map){
	var htmlContent = $("#${id}_container").html();
	for(key in map){
		htmlContent = htmlContent.replaceAll("${delimiter}"+key+"${delimiter}",map[key],false);
	}
	$("#${id}_container").html(htmlContent);
}

$(function(){
	<e:if condition="${(url ==null || url eq '') && (itemJson !=null && itemJson ne '')}" var="itemif">
		var data = jQuery.parseJSON('${itemJson}');
		parseTextBind${id}(data);
	</e:if>
	<e:else condition="${itemif}">
		$.getJSON((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'), {}, function(data) {
			parseTextBind${id}(data);
        });
	</e:else>
});

</script>

