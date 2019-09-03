<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<e:switch value="${param.eaction}">
  <e:case value="qd_market">
    <c:tablequery>
      select
      latn_name,
      bureau_name,
      branch_name,
      grid_name,
      business_name,
      channel_name,
      channel_count,
      to_char(INPUT_TIME,'yyyy-mm-dd HH24:mi:ss') INPUT_TIME,
      nvl(user_name,' ') user_name
      from
      ${gis_user}.TB_GIS_QD_MARKET
      order by input_time desc
    </c:tablequery>
  </e:case>
</e:switch>