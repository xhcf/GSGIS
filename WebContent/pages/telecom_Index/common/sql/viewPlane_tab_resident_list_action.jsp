<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
  <e:description>住户详单</e:description>
  <e:case value="get_resident_list">
    <e:q4l var="dataList">
      SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT NVL(O.STAND_NAME_1, ' ') STAND_NAME_1,
      NVL(O.SEGM_ID_2, ' ') SEGM_ID_2,
      NVL(O.SEGM_NAME_2, '  ') SEGM_NAME_2,
      <e:description>
      CASE WHEN O.IS_KD_DX > 0 THEN '是' ELSE ' ' END is_dx_user,
      </e:description>
      CASE
      WHEN NVL(O.DX_CONTACT_PERSON, ' ') = ' ' THEN
      ' '
      ELSE
      SUBSTR(NVL(O.DX_CONTACT_PERSON, ' '), 1, 1) || '**'
      END DX_CONTACT_PERSON,
      <e:description>2018.10.22 号码脱敏</e:description>
      CASE
      WHEN O.IS_KD_DX > 0 THEN
      nvl(BB.ACC_NBR,' ')
      ELSE
      ' '
      END ACC_NBR,
      DECODE(DX_CONTACT_NBR,
      NULL,
      ' ',
      NVL((SUBSTR(DX_CONTACT_NBR, 0, 3) || '******' ||
      SUBSTR(DX_CONTACT_NBR, 10, 2)),
      ' ')) DX_CONTACT_NBR,
      CASE
      WHEN O.KD_BUSINESS IS NULL OR O.KD_DQ_DATE IS NULL THEN ' '
      WHEN NVL(O.CONTACT_PERSON, ' ') = ' ' THEN  ' '
      WHEN O.CONTACT_PERSON = '未装' THEN
      '未装'
      ELSE
      SUBSTR(NVL(O.CONTACT_PERSON, ' '), 1, 1) || '**'
      END CONTACT_PERSON,
      CASE WHEN O.KD_BUSINESS IS NULL OR O.KD_DQ_DATE IS NULL THEN ' '
      WHEN O.CONTACT_NBR IS NULL THEN ' '
      ELSE
      SUBSTR(O.CONTACT_NBR, 0, 3) || '******' ||
      SUBSTR(O.CONTACT_NBR, 10, 2)
      END CONTACT_NBR,
      CASE
      WHEN NVL(O.IS_KD_DX, 0) = '0' THEN
      CASE
      WHEN O.KD_BUSINESS = '1' THEN
      '移动'
      WHEN O.KD_BUSINESS = '2' THEN
      '联通'
      WHEN O.KD_BUSINESS = '3' THEN
      '广电'
      WHEN O.KD_BUSINESS = '4' THEN
      '其他'
      WHEN O.KD_BUSINESS = '0' THEN
      '未装'
      ELSE
      '  '
      END
      WHEN O.IS_KD_DX > 0 THEN
      ' '
      END KD_BUSINESS,
      NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') KD_DQ_DATE,
      IS_KD_DX,
      NVL(O.KD_XF, '  ') KD_XF,
      COUNT(1) OVER() C_NUM
      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL O
      <e:if condition="${!empty param.village_id && param.village_id ne '-1'}">
        ,${gis_user}.tb_gis_village_addr4 A
      </e:if>
      ,(select address_id,acc_nbr from ${gis_user}.TB_MKT_INFO
      where PRODUCT_CD in ('999991020','999991010','999991030','999991040')
      ) bb
      WHERE 1=1
      and o.segm_id_2 = bb.address_id
      <e:if condition="${param.village_id eq '-1'}">
        <e:if condition="${!empty param.branch_no}">
          and segm_id in (
            SELECT segm_id FROM sde.TB_GIS_MAP_SEGM_LATN_MON where union_org_code='${param.branch_no}'
            and segm_id not in (select segm_id from gis_data.TB_GIS_VILLAGE_ADDR4)
          )
        </e:if>
        <e:if condition="${!empty param.grid_id}">
          and segm_id in (
            SELECT segm_id FROM sde.TB_GIS_MAP_SEGM_LATN_MON where grid_id='${param.grid_id}'
            and segm_id not in (select segm_id from gis_data.TB_GIS_VILLAGE_ADDR4)
          )
        </e:if>
      </e:if>
      <e:description>sde.map_addr_segm_${param.latn_id}</e:description>
      <e:if condition="${!empty param.build_id}">
        and O.SEGM_ID in (${param.build_id})
      </e:if>
      <e:if condition="${!empty param.village_id && param.village_id ne '-1'}">
        and O.SEGM_ID = A.SEGM_ID
        and A.VILLAGE_ID = '${param.village_id}'
      </e:if>
      <e:description>
        and O.SEGM_ID_2 is not null
      </e:description>
      ORDER BY stand_name_1 ASC, length(segm_name_2)asc,segm_name_2 ASC)
      t WHERE ROWNUM <= ${param.page+1}*25    )a WHERE rn >${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>