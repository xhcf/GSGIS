<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_part_tab1">
  <e:description>EDW.TB_MKT_INFO_LOST@GSEDW</e:description>
  ${gis_user}.tb_mkt_info_lost
</e:set>
<e:switch value="${param.eaction}">
  <e:description>住户详单</e:description>
  <e:case value="get_lost_resident_list">
    <e:q4l var="dataList">
      SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT ROWNUM ROW_NUM,
      COUNT(1) OVER() C_NUM,
      LEV6_ID VILLAGE_ID,
      ADDRESS_ID,
      ADDRESS_DESC STAND_NAME,
      case when nvl(CUST_NAME,' ')=' ' then ' ' else substr(nvl(CUST_NAME,' '),1,1)||'**' end USER_CONTACT_PERSON,
      ACC_NBR,
      TO_CHAR(REMOVE_DATE, 'yyyy-mm-dd') REMOVE_DATE,
      CASE
      WHEN REMOVE_DATE IS NULL THEN
      '--'
      WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) / 12 = 0 THEN
      TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) || '个月'
      WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) / 12 > 1 THEN
      FLOOR(TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) / 12) || '年'
      END || CASE
      WHEN MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)), 12) > 0 THEN
      MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)), 12) || '个月'
      END OWE_DUR,
      STOP_TYPE,
      PROD_INST_ID,
      CASE
      WHEN T.STOP_TYPE = 0 THEN
      '拆机'
      WHEN T.STOP_TYPE = 8 THEN
      '停机'
      WHEN T.STOP_TYPE = 3 THEN
      '沉默'
      WHEN T.STOP_TYPE = 2 THEN
      '沉默'
      ELSE
      ' '
      END SCENE_TEXT
      FROM (
      select t.* from
      ${sql_part_tab1} t,
      ${gis_user}.TB_GIS_ADDR_INFO_ALL t1
      WHERE 1 = 1
      and t.address_id = t1.segm_id_2
      and t1.serial_no in(1,4)
      <e:if condition="${!empty param.village_id && param.village_id ne '-1'}">
        AND t.LEV6_ID = '${param.village_id}'
      </e:if>
      <e:if condition="${!empty param.build_id}">
        AND t.address_id IN (
        SELECT segm_id_2 FROM ${gis_user}.tb_gis_addr_info_all WHERE segm_id IN ( ${param.build_id})
        )
      </e:if>
      <e:if condition="${param.village_id eq '-1'}">
        AND t.address_id IN (
        SELECT segm_id FROM sde.TB_GIS_MAP_SEGM_LATN_MON where union_org_code='${param.branch_no}'
        and segm_id not in(select segm_id from ${gis_user}.TB_GIS_VILLAGE_ADDR4)
        )
      </e:if>
      ) T

      ORDER BY ADDRESS_ID
      )
      t WHERE ROWNUM <= ${param.page+1}*25)a WHERE rn >${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>