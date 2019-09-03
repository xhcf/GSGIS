<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_part">
    count(1) sum_cnt,
    count(case when ze_port_flg=1 then 1 else null end) obd0_cnt,
    count(case when fi_port_flg=1 then 1 else null end) obd1_cnt,
    <e:description>
        count(case when zero_port_flg=0 then 1 else null end) hobd_cnt
    </e:description>
    count(case when nvl(user_port_rate,0)>=0.6 then 1 else null end) hobd_cnt
</e:set>
<e:set var="sql_part_dqsj">
    <e:description>NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') KD_DQ_DATE,</e:description>
    CASE WHEN NVL(O.IS_KD_DX, 0) = '0' AND (O.KD_BUSINESS = '0' OR O.KD_BUSINESS IS NULL) THEN ' '
    ELSE NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') END KD_DQ_DATE,
</e:set>
<e:set var="sql_part_where">
    and nvl(t.user_port_rate,0)>=0.6
</e:set>
<e:set var="sql_part_on_count">
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 and O.SERIAL_NO in('1','4') and((O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL) or O.KD_BUSINESS = '0') then
    O.segm_id_2  END
    ) ON_COUNT
</e:set>
<e:set var="sql_part_off_count">
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 and O.SERIAL_NO in('1','4') and (O.KD_BUSINESS IS NULL OR ( O.KD_BUSINESS<> '0' AND O.KD_DQ_DATE IS NULL)) then
    O.segm_id_2 END
    ) OFF_COUNT
</e:set>
<e:switch value="${param.eaction}">
  <e:description>住户清单获取小区下的楼</e:description>
  <e:case value="collect_new_build_list">
      <e:q4l var="build_list">
          SELECT DD.SEGM_ID SEGM_ID, DD.STAND_NAME STAND_NAME
          FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 FF, SDE.TB_GIS_MAP_SEGM_LATN_MON DD
          WHERE FF.SEGM_ID = DD.SEGM_ID
          AND FF.VILLAGE_ID = '${param.village_id}'
          ORDER BY SEGM_ID asc,segm_name ASC
      </e:q4l>${e:java2json(build_list.list)}
  </e:case>
  <e:case value="collect_new_count">
    <e:q4o var="collect_count">
      SELECT
      COUNT(*) A_COUNT,
        ${sql_part_on_count},
        ${sql_part_off_count},
      COUNT(CASE WHEN A.IS_KD > 0 THEN '1' END) D_COUNT,
      COUNT(CASE WHEN A.IS_KD = 0 AND O.KD_BUSINESS = '1' THEN '1' END) Y_COUNT,
      COUNT(CASE WHEN A.IS_KD = 0 AND O.KD_BUSINESS = '2' THEN '1' END) L_COUNT,
      COUNT(CASE WHEN A.IS_KD = 0 AND O.KD_BUSINESS = '3' THEN '1' END) G_COUNT,
      COUNT(CASE WHEN A.IS_KD = 0 AND O.KD_BUSINESS = '4' THEN '1' END) Q_COUNT,
      COUNT(CASE WHEN A.IS_KD = 0 AND O.KD_BUSINESS = '0' THEN '1' END) N_COUNT
      FROM
      ${gis_user}.TB_GIS_ADDR_INFO_ALL A
      LEFT OUTER JOIN ${gis_user}.TB_GIS_ADDR_OTHER_ALL O
      ON O.SEGM_ID_2 = A.SEGM_ID_2
      WHERE
      A.SEGM_ID = '${param.build_id }'
    </e:q4o>${e: java2json(collect_count) }
  </e:case>
  <e:case value="collect_new_count_head">
    <e:q4o var="collect_count">
        SELECT
        COUNT(*) A_COUNT,
        ${sql_part_on_count},
        ${sql_part_off_count},
        COUNT(CASE
        WHEN O.IS_KD_DX = 0 and O.SERIAL_NO <>2 THEN
        '1'
        END) YING_COUNT,
        COUNT(CASE
        WHEN O.IS_KD_DX > 0 THEN
        '1'
        END) D_COUNT,
        COUNT(CASE
        WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '1' AND
        O.KD_DQ_DATE IS NOT NULL THEN
        '1'
        END) Y_COUNT,
        COUNT(CASE
        WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '2' AND
        O.KD_DQ_DATE IS NOT NULL THEN
        '1'
        END) L_COUNT,
        COUNT(CASE
        WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '3' AND
        O.KD_DQ_DATE IS NOT NULL THEN
        '1'
        END) G_COUNT,
        COUNT(CASE
        WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '4' AND
        O.KD_DQ_DATE IS NOT NULL THEN
        '1'
        END) Q_COUNT,
        COUNT(CASE
        WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '0' AND
        O.KD_DQ_DATE IS NOT NULL THEN
        '1'
        END) N_COUNT
        FROM
        ${gis_user}.TB_GIS_ADDR_OTHER_ALL O,
        ${gis_user}.TB_GIS_VILLAGE_ADDR4 A
        WHERE O.SEGM_ID = A.SEGM_ID
        and a.VILLAGE_ID = '${param.village_id }'
    </e:q4o>${e: java2json(collect_count) }
  </e:case>
  <e:case value="collect_new_build_info">
    <e:q4l var="build_list">
      SELECT
      NVL(O.STAND_NAME_1,' ') STAND_NAME_1,
      NVL(O.SEGM_ID_2,' ') SEGM_ID_2,
      NVL(O.SEGM_NAME_2,'  ') SEGM_NAME_2,
      NVL(O.CONTACT_PERSON,' ')
      || '<br />'
      <e:description>2018.10.22 号码脱敏</e:description>
      || substr(NVL(O.CONTACT_NBR, ' '),0,3)||'******'||SUBSTR(NVL(O.CONTACT_NBR, ' '),10) CONNECT_INFO,
      CASE
      WHEN A.IS_KD = '0' THEN
      CASE
      WHEN O.KD_BUSINESS = '1' THEN '移动'
      WHEN O.KD_BUSINESS = '2' THEN '联通'
      WHEN O.KD_BUSINESS = '3' THEN '广电'
      WHEN O.KD_BUSINESS = '4' THEN '其他'
      WHEN O.KD_BUSINESS = '0' THEN '  '
      ELSE '  '
      END
      WHEN A.IS_KD > 0 THEN '电信'
      END
      KD_BUSINESS,
      CASE
      WHEN a.is_kd > 0 THEN 1
      ELSE 0
      END IS_DX,
      NVL(O.KD_XF, '  ') KD_XF,
      <e:description>到期时间↓</e:description>
      ${sql_part_dqsj}
      <e:description>到期时间↑</e:description>
      CASE
      WHEN A.IS_ITV = '0' THEN
      CASE
      WHEN O.ITV_BUSINESS = '1' THEN '移动'
      WHEN O.ITV_BUSINESS = '2' THEN '联通'
      WHEN O.ITV_BUSINESS = '3' THEN '广电'
      WHEN O.ITV_BUSINESS = '4' THEN '其他'
      WHEN O.ITV_BUSINESS = '0' THEN '  '
      ELSE '  '
      END
      WHEN A.IS_ITV > 0 THEN '电信'
      END
      ITV_BUSINESS,
      NVL(O.ITV_XF, '  ') ITV_XF,
      NVL(TO_CHAR(O.ITV_DQ_DATE,'YYYY-MM-DD'),'  ') ITV_DQ_DATE
      FROM ${gis_user}.TB_GIS_ADDR_INFO_ALL A
      LEFT OUTER JOIN ${gis_user}.TB_GIS_ADDR_OTHER_ALL O
      ON O.SEGM_ID_2 = A.SEGM_ID_2
      WHERE
      A.SEGM_ID = '${param.build_id }'
      <e:switch value="${param.collect_state }">
        <e:case value="1">
          AND NVL(A.IS_KD, 0) = 0
          AND (O.KD_BUSINESS IS NULL OR (O.KD_DQ_DATE IS NULL AND O.KD_BUSINESS <> 0))
        </e:case>
        <e:case value="2">
          AND NVL(A.IS_KD, 0) = 0
          AND ((O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL) OR O.KD_BUSINESS = '0')
        </e:case>
      </e:switch>
      <e:if condition="${param.collect_bselect ne '-1' }">
        <e:if condition="${param.collect_bselect eq '5' }" var="is_dx">
          AND A.IS_KD > 0
        </e:if>
        <e:else condition="${is_dx }">
          AND KD_BUSINESS = '${param.collect_bselect }'
        </e:else>
      </e:if>
      ORDER BY segm_id_2 asc, length(segm_name_2) ASC,segm_name_2 ASC
    </e:q4l>${e: java2json(build_list.list) }
  </e:case>
  <e:case value="obd_type_cnt_build">
    <e:q4o var="dataObject">
      SELECT
      ${sql_part}
      FROM
        (   SELECT distinct EQP_NO,ze_port_flg,fi_port_flg,zero_port_flg,user_port_rate FROM ${gis_user}.TB_GIS_ODB_EQP_ADRESS4_DAY T,
      sde.map_addr_segm_${param.city_id} A
      WHERE T.segm_id = A.Resid
      <e:if condition="${!empty param.substation}">
        AND a.UNION_ORG_CODE = '${param.substation}'
      </e:if>
      <e:if condition="${!empty param.grid_id_short}">
        AND a.grid_id = '${param.grid_id_short}'
      </e:if>
      <e:if condition="${!empty param.resid}">
        and a.resid = '${param.resid}'
      </e:if>
      <e:if condition="${!empty param.village_id}">
        and a.resid in (SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id ='${param.village_id}')
      </e:if>
      <e:if condition="${!empty param.zy}">
        <e:if condition="${param.zy eq '1'}">
          and t.ze_port_flg = 1
        </e:if>
        <e:if condition="${param.zy eq '2'}">
          and t.fi_port_flg = 1
        </e:if>
        <e:if condition="${param.zy eq '3'}">
            ${sql_part_where}
        </e:if>
      </e:if>
        )
    </e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:description>obd 楼宇</e:description>
  <e:case value="obd_build">
    <e:q4l var="dataList">
        <e:if condition="${ param.resid=='-1'}">
            select * from(
            select A.*,ROWNUM ROW_NUM from (
            SELECT
            distinct t.EQP_NO EQP_ID,
            t.ADDRESS,
            SUBSTR(T.EQP_NO, 0, 5) || '***' || SUBSTR(T.EQP_NO, 20) EQP_ID1,
            to_char(round(nvl(USER_PORT_RATE,0),4)*100,'FM990.00')||'%' USER_PORT_RATE,
            t.PORT_ID_CNT,
            t.USE_PORT_CNT,
            t.PORT_ID_CNT-t.USE_PORT_CNT REMAINDER_CNT,
            DECODE(ZE_PORT_FLG, '0', ' ', '1', '是') ZE_TEXT,
            DECODE(FI_PORT_FLG, '0', ' ', '1', '是') FI_TEXT
            FROM ${gis_user}.TB_GIS_ODB_EQP_ADRESS4_DAY T,
            <e:if condition="${!empty param.village_id}" var="no_empty_v_id">
                ${gis_user}.tb_gis_village_addr4 a
                where t.segm_id = a.segm_id
                and a.village_id = '${param.village_id}'
            </e:if>
            <e:else condition="${no_empty_v_id}">
                sde.map_addr_segm_${param.city_id} a
                WHERE T.segm_id = A.Resid
                <e:if condition="${!empty param.substation}">
                    AND a.UNION_ORG_CODE = '${param.substation}'
                </e:if>
                <e:if condition="${!empty param.grid_id_short}">
                    AND a.grid_id = '${param.grid_id_short}'
                </e:if>
            </e:else>
            <e:if condition="${!empty param.zy}">
                <e:if condition="${param.zy eq '1'}">
                    and t.ze_port_flg = 1
                </e:if>
                <e:if condition="${param.zy eq '2'}">
                    and t.fi_port_flg = 1
                </e:if>
                <e:if condition="${param.zy eq '3'}">
                    ${sql_part_where}
                </e:if>
            </e:if>
            order by t.EQP_NO
            )A
            )
            WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:if>
        <e:if condition="${param.resid != '-1'}">
            select * from(
            select A.*,ROWNUM ROW_NUM from (
            SELECT
            a.stand_name resfullname,
            a.segm_id res_id,
            t.ADDRESS,
            SUBSTR(T.EQP_NO, 0, 5) || '***' || SUBSTR(T.EQP_NO, 20) EQP_ID1,
            t.EQP_NO EQP_ID,
            round(nvl(USER_PORT_RATE,0),4)*100 USER_PORT_RATE,
            t.PORT_ID_CNT,
            t.USE_PORT_CNT,
            t.PORT_ID_CNT-t.USE_PORT_CNT REMAINDER_CNT,
            DECODE(ZE_PORT_FLG, '0', ' ', '1', '是') ZE_TEXT,
            DECODE(FI_PORT_FLG, '0', ' ', '1', '是') FI_TEXT
            FROM ${gis_user}.TB_GIS_ODB_EQP_ADRESS4_DAY T,
            ${gis_user}.tb_gis_village_addr4 a
            where t.segm_id = a.segm_id
            and a.segm_id = '${param.resid}'
            <e:if condition="${!empty param.zy}">
                <e:if condition="${param.zy eq '1'}">
                    and t.ze_port_flg = 1
                </e:if>
                <e:if condition="${param.zy eq '2'}">
                    and t.fi_port_flg = 1
                </e:if>
                <e:if condition="${param.zy eq '3'}">
                    ${sql_part_where}
                </e:if>
            </e:if>
            order by a.segm_id
            )A
            )
            WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>单宽用户</e:description>
  <e:case value="get_dkd_count">
    <e:q4o var="dataObject">
        SELECT COUNT(1) COUNT FROM ${gis_user}.TB_GIS_VILLAGE_KD_LIST_DAY WHERE village_id = '${param.village_id}' and comp_flg = 0
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>融合用户</e:description>
  <e:case value="get_rh_count">
    <e:q4o var="dataObject">
        SELECT COUNT(1) COUNT FROM ${gis_user}.TB_GIS_VILLAGE_KD_LIST_DAY WHERE village_id = '${param.village_id}' and comp_flg = 1
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>单宽用户列表</e:description>
  <e:case value="get_dkd_list">
    <e:q4l var="dataList">
        SELECT A.*
        FROM (SELECT *
        FROM (
        SELECT TELE_NO,
        USER_CONTACT_PERSON,
        USER_CONTACT_NBR,
        STAND_NAME_2,
        COUNT(1) OVER() C_NUM,
        row_number() over(ORDER BY length(stand_name_2),stand_name_2) ROW_NUM,
        SEGM_ID_2
        FROM ${gis_user}.TB_GIS_VILLAGE_KD_LIST_DAY
        WHERE VILLAGE_ID = '${param.village_id}'
        AND COMP_FLG = 0
        )
        WHERE ROW_NUM <= ${(param.page + 1)} * 20) A
        WHERE ROW_NUM > ${param.page} * 20
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>融合用户列表</e:description>
  <e:case value="get_rh_list">
    <e:q4l var="dataList">
        SELECT A.*
        FROM (SELECT *
        FROM (SELECT TELE_NO,
        PROD_INST_ID,
        SEGM_ID_2,
        USER_CONTACT_PERSON,
        USER_CONTACT_NBR,
        STAND_NAME_2,
        COUNT(1) OVER() C_NUM,
        row_number() over(ORDER BY length(stand_name_2),stand_name_2) ROW_NUM
        FROM ${gis_user}.TB_GIS_VILLAGE_KD_LIST_DAY
        WHERE VILLAGE_ID = '${param.village_id}'
        AND COMP_FLG = 1
        )
        WHERE ROW_NUM <= ${(param.page + 1)} * 20) A
        WHERE ROW_NUM > ${param.page} * 20
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>