<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
  <e:case value="test_sql">
    <c:tablequery>
      SELECT latn_id,
      kd_hu_count,
      h_use_cnt,
      use_port_cnt,
      high_use_obd_cnt,
      gz_kd_cnt,
      gz_zhu_hu_count,
      wj_cnt
      FROM gis_data.TB_GIS_RES_city_DAY
    </c:tablequery>
  </e:case>
</e:switch>