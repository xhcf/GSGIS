<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql">
  select count(1) val from ${easy_user}.e_user
</e:set>
<e:q4o var="gis">
  ${sql}
</e:q4o>
<e:q4o var="yxjf" extds="yxjf">
  ${sql}
</e:q4o>
<e:q4o var="qdxn" extds="yxjf">
  ${sql}
</e:q4o>
<e:q4o var="zhrl" extds="yxjf">
  ${sql}
</e:q4o>
<e:q4o var="zjjc" extds="yxjf">
  ${sql}
</e:q4o>
<e:q4o var="fqz" extds="yxjf">
  ${sql}
</e:q4o>
<html>
<body>
  <div>
    gis:${gis.VAL}<br/>
    yxjf:${yxjf.VAL}<br/>
    qdxn:${qdxn.VAL}<br/>
    zhrl:${zhrl.VAL}<br/>
    zjjc:${zjjc.VAL}<br/>
    fqz:${fqz.VAL}<br/>
  </div>
</body>
</html>
