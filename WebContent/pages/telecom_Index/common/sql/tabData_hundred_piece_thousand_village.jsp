<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
  <e:case value="getSnapData">
    <e:q4l var="dataList">
      select * from (
      select t.*,rownum rn from(
        select
        t1.latn_name,
        t1.bureau_name,
        t1.branch_name,
        t1.grid_name,
        <e:if condition="${param.detail_level eq '2'}">
          t1.village_name,
        </e:if>
        to_char(nvl(FILTER_RATE_LOCK,0)*100,'FM990.00') || '%' FILTER_RATE_LOCK,
        to_char(nvl(FILTER_RATE_D,0)*100,'FM990.00') || '%' FILTER_RATE_D,
        nvl(ADD_KD_CNT,0) ADD_KD_CNT,
        to_char(nvl(FILTER_RATE,0)*100,'FM990.00') || '%' FILTER_RATE,
        to_char(nvl(FILTER_RATE_M,0)*100,'FM990.00') || '%' FILTER_RATE_M,
        nvl(M_ADD_KD_CNT,0) M_ADD_KD_CNT,
        count(1) over() c_num
        from
        <e:if condition="${param.detail_level eq '1'}">
          ${gis_user}.tb_gis_rpt_grid_snapshot t1,
          ${gis_user}.tb_gis_rpt_grid_activity2 t2
        </e:if>
        <e:if condition="${param.detail_level eq '2'}">
          ${gis_user}.tb_gis_rpt_village_snapshot t1,
          ${gis_user}.tb_gis_rpt_village_activity2 t2
        </e:if>
        where
        <e:if condition="${param.detail_level eq '1'}">
          t1.grid_id = t2.grid_id
        </e:if>
        <e:if condition="${param.detail_level eq '2'}">
          t1.village_id = t2.village_id
        </e:if>
        <e:if condition="${param.branch_type eq '1'}">
          and t1.branch_type='a1'
        </e:if>
        <e:if condition="${param.branch_type eq '2'}">
          and t1.branch_type='b1'
        </e:if>
        <e:if condition="${!empty param.village_name}">
          and t1.village_name like '%${param.village_name}%'
        </e:if>
        <e:if condition="${!empty param.city_id}">
          and t1.latn_id = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.bureau_id}">
          and t1.bureau_no = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.branch_id}">
          and t1.branch_no = '${param.branch_id}'
        </e:if>
        and t2.acct_day='${param.acct_day}'
        order by
        t1.city_order_num ,t1.region_order_num ,t1.branch_no ,t1.grid_id
        <e:if condition="${param.detail_level eq '2'}">
        ,t1.village_id
        </e:if>
      )t where rownum <= ${param.pageSize}*${param.page+1})
      where rn > ${param.pageSize}*${param.page}
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
</e:switch>
