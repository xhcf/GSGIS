<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:description>领导层右侧指标区小报表</e:description>
<e:set var="sql_part_tab_name1">
    <e:description>
        2018.9.11 表名更换 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 改为 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY
        2018.9.20 表名恢复 从 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY 更换为 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW
        2019.3.27 表名 从 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 变成 ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
    </e:description>
    ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
</e:set>

<e:switch value="${param.eaction}">
  <e:case value="index_province"><e:description>家庭宽带渗透率</e:description>
    <c:tablequery>
      select * from (SELECT
      '999' area_no,
      '全省' area_desc,
      case when nvl(GZ_ZHU_HU_COUNT,0) = 0 then '--' else to_char(round(nvl(GZ_H_USE_CNT,0)/GZ_ZHU_HU_COUNT,4)*100,'990.00') || '%' end USE_RATE,
      case when nvl(GZ_ZHU_HU_COUNT,0) = 0 then 0 else round(nvl(GZ_H_USE_CNT,0)/GZ_ZHU_HU_COUNT,4)*100 end USE_RATE1,
      nvl(gz_zhu_hu_count,0) gz_zhu_hu_count,
      nvl(gz_h_use_cnt,0) gz_h_use_cnt,
      nvl(gov_zhu_hu_count,0) gov_zhu_hu_count,
      nvl(gov_h_use_cnt,0) gov_h_use_cnt,
      trim(to_char(round(nvl(filter_mon_rate,0),4)*100,'9990.00')||'%') up_month,
      trim(to_char(round(nvl(filter_year_rate,0),4)*100,'9990.00')||'%') up_year,
      '0' ord
      FROM ${gis_user}.TB_GIS_RES_city_DAY
      WHERE flg = 0
      and branch_type = 'a1'
      UNION
      SELECT
      b.area_no,
      b.area_desc,
      case when nvl(GZ_ZHU_HU_COUNT,0) = 0 then '--' else to_char(round(nvl(GZ_H_USE_CNT,0)/GZ_ZHU_HU_COUNT,4)*100,'990.00') || '%' end USE_RATE,
      case when nvl(GZ_ZHU_HU_COUNT,0) = 0 then 0 else round(nvl(GZ_H_USE_CNT,0)/GZ_ZHU_HU_COUNT,4)*100 end USE_RATE1,
      nvl(gz_zhu_hu_count,0) gz_zhu_hu_count,
      nvl(gz_h_use_cnt,0) gz_h_use_cnt,
      nvl(gov_zhu_hu_count,0) gov_zhu_hu_count,
      nvl(gov_h_use_cnt,0) gov_h_use_cnt,
      trim(to_char(round(nvl(filter_mon_rate,0),4)*100,'9990.00')||'%') up_month,
      trim(to_char(round(nvl(filter_year_rate,0),4)*100,'9990.00')||'%') up_year,
      b.ord
      FROM ${gis_user}.TB_GIS_RES_city_DAY a,${easy_user}.cmcode_area b
      WHERE flg = 1
      and branch_type = 'a1'
      AND a.latn_id = b.area_no)
      where 1=1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

    </c:tablequery>
  </e:case>

  <e:case value="index_fb_cover_province">
    <c:tablequery>
  SELECT t.*
  FROM (SELECT '999' area_no,
               '全省' area_desc,
               case
                 when nvl(LY_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(LY_CNT - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100,'990.00') || '%'
               end USE_RATE,
               case
                when nvl(LY_CNT, 0) = 0 then
                0
                else
                round(nvl(LY_CNT - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100
               end USE_RATE1,
               nvl(ly_cnt, 0) ly_cnt,
               nvl(no_res_arrive_cnt, 0) no_res_arrive_cnt,
               nvl(gz_zhu_hu_count, 0) gz_zhu_hu_count,
               nvl(VILLAGE_CNT, 0) VILLAGE_CNT,
               '0' ord
          FROM ${gis_user}.TB_GIS_RES_city_DAY
         WHERE flg = 0 and branch_type = 'a1'
        UNION
        SELECT b.area_no,
               b.area_desc,
               case
                 when nvl(LY_CNT, 0) = 0 then
                  '--'
                 else
                  to_char(round(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT,
                                4) * 100,
                          '990.00') || '%'
               end USE_RATE,
                case
                when nvl(LY_CNT, 0) = 0 then
                0
                else
                round(nvl(LY_CNT - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100
                end USE_RATE1,
               nvl(ly_cnt, 0) ly_cnt,
               nvl(no_res_arrive_cnt, 0) no_res_arrive_cnt,
               nvl(gz_zhu_hu_count, 0) GZ_ZHU_HU_COUNT,
               nvl(VILLAGE_CNT, 0) VILLAGE_CNT,
               b.ord
          FROM ${gis_user}.TB_GIS_RES_city_DAY a, ${easy_user}.cmcode_area b
         WHERE flg = 1
           and BRANCH_TYPE = 'a1'
           AND a.latn_id = b.area_no) T
      where 1=1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
  ORDER BY ORD
    </c:tablequery>
  </e:case>

  <e:case value="index_fb_real_percent_province">
    <c:tablequery>
  SELECT t.*
  FROM (SELECT '999' area_no,
               '全省' area_desc,
               case
                 when nvl(PORT_ID_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100,'990.00') || '%'
               end USE_RATE,
                case
                when nvl(PORT_ID_CNT, 0) = 0 then
                0
                else
                round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100
                end USE_RATE1,
               nvl(USE_PORT_CNT, 0) USE_PORT_CNT,
               nvl(KONG_PORT_CNT, 0) KONG_PORT_CNT,
               nvl(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
               nvl(PORT_ID_CNT, 0) PORT_ID_CNT,
               '0' ord
          FROM ${gis_user}.TB_GIS_RES_CITY_DAY
         WHERE flg = 0 and branch_type = 'a1'
        UNION
        SELECT b.area_no,
               b.area_desc,
               case
                 when nvl(PORT_ID_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100,'990.00') || '%'
               end USE_RATE,
                case
                when nvl(PORT_ID_CNT, 0) = 0 then
                0
                else
                round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100
                end USE_RATE1,
               nvl(USE_PORT_CNT, 0) USE_PORT_CNT,
               nvl(KONG_PORT_CNT, 0) KONG_PORT_CNT,
               nvl(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
               nvl(PORT_ID_CNT, 0) PORT_ID_CNT,
               b.ord
          FROM ${gis_user}.TB_GIS_RES_city_DAY a, ${easy_user}.cmcode_area b
         WHERE flg = 1
           and BRANCH_TYPE = 'a1'
           AND a.latn_id = b.area_no) T
      where 1=1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
  ORDER BY ORD
    </c:tablequery>
  </e:case>

  <e:description>
  	宽带存量保有率省级sql
  </e:description>
  <e:case value="index_protection_province">
    <c:tablequery>
  SELECT t.*
  FROM (SELECT '999' area_no,
               '全省' area_desc,
               case
                 when nvl(BY_ALL_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100,'990.00') || '%'
               end USE_RATE,
               case
                 when nvl(BY_ALL_CNT, 0) = 0 then
                  0
                 else
                  round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
               end USE_RATE1,
               case
                 when nvl(XY_ALL_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100,'990.00') || '%'
               end XY_RATE,
               case
                 when nvl(XY_ALL_CNT, 0) = 0 then
                  0
                 else
                  round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100
               end XY_RATE1,
               case
                 when nvl(ACTIVE_ALL_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT,4) * 100,'990.00') || '%'
               end ACTIVE_RATE,
               '0' ord
          FROM ${gis_user}.TB_GIS_RES_city_DAY
         WHERE flg = 0 and branch_type = 'a1'
        UNION
        SELECT b.area_no,
               b.area_desc,
				case
                 when nvl(BY_ALL_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100,'990.00') || '%'
               end USE_RATE,
               case
                 when nvl(BY_ALL_CNT, 0) = 0 then
                  0
                 else
                  round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
               end USE_RATE1,
               case
                 when nvl(XY_ALL_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100,'990.00') || '%'
               end XY_RATE,
                case
                when nvl(XY_ALL_CNT, 0) = 0 then
                0
                else
                round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100
                end XY_RATE1,
               case
                 when nvl(ACTIVE_ALL_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT,4) * 100,'990.00') || '%'
               end ACTIVE_RATE,
               b.ord
          FROM ${gis_user}.TB_GIS_RES_city_DAY a, ${easy_user}.cmcode_area b
         WHERE flg = 1
           and BRANCH_TYPE = 'a1'
           AND a.latn_id = b.area_no) T
             where 1=1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
  ORDER BY ORD
    </c:tablequery>
  </e:case>


  <e:description>
  	竞争信息收集省级sql
  </e:description>
  <e:case value="index_collect_province">
    <c:tablequery>
  SELECT t.*
  FROM (SELECT '999' area_no,
               '全省' area_desc,
               case
                 when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100,'990.00') || '%'
               end USE_RATE,
               case
                 when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
                  0
                 else
                  round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
               end USE_RATE1,
               nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
               nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
               trim(to_char(round(nvl(OTHER_MON_RATE,0),4)*100,'9990.00')||'%') OTHER_MON_RATE,
      		   trim(to_char(round(nvl(OTHER_YEAR_RATE,0),4)*100,'9990.00')||'%') OTHER_YEAR_RATE,
               '0' ord
          FROM ${gis_user}.TB_GIS_RES_city_DAY
         WHERE flg = 0 and branch_type = 'a1'
        UNION
        SELECT b.area_no,
               b.area_desc,
				case
                 when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
                  '0.00%'
                 else
                  to_char(round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100,'990.00') || '%'
               end USE_RATE,
               case
                 when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
                  0
                 else
                  round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
               end USE_RATE1,
               nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
               nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
               trim(to_char(round(nvl(OTHER_MON_RATE,0),4)*100,'9990.00')||'%') OTHER_MON_RATE,
      		   trim(to_char(round(nvl(OTHER_YEAR_RATE,0),4)*100,'9990.00')||'%') OTHER_YEAR_RATE,
               b.ord
          FROM ${gis_user}.TB_GIS_RES_city_DAY a, ${easy_user}.cmcode_area b
         WHERE flg = 1
           and BRANCH_TYPE = 'a1'
           AND a.latn_id = b.area_no) T
             where 1=1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
  ORDER BY ORD
    </c:tablequery>
  </e:case>

  <e:description>
  	精准派单营销省级sql
  </e:description>
  <e:case value="index_dispatch_province">
    <c:tablequery>
        SELECT *
        FROM (SELECT *
        FROM (SELECT '999' LATN_ID,
        '全省' AREA_DESC,
        '0' ORD,
        NVL(SUM(COL_NUM_1), 0) ORDER_CNT,
        NVL(SUM(COL_NUM_2), 0) EXEC_CNT,
        DECODE(NVL(SUM(COL_NUM_1), 0),
        '0',
        '0.00%',
        TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /
        SUM(COL_NUM_1),
        4) * 100,
        'FM999999990.00') || '%') USE_RATE,
        DECODE(NVL(SUM(COL_NUM_1), 0),
        '0',
        '0.00%',
        TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /
        SUM(COL_NUM_1),
        4) * 100,
        'FM999999990.00')) USE_RATE1,
        NVL(SUM(COL_NUM_3), 0) SUCC_CNT,
        DECODE(NVL(SUM(COL_NUM_1), 0),
        '0',
        '0.00%',
        TO_CHAR(ROUND(NVL(SUM(COL_NUM_3), 0) /
        SUM(COL_NUM_1),
        4) * 100,
        'FM999999990.00') || '%') SUCC_LV,
        0 C_NUM
        FROM EDW.VW_GSCH_MKT_ORDER_STAT_MONTH@GSEDW
        WHERE 1 = 1
        AND STAT_MONTH = TO_CHAR(SYSDATE, 'yyyymm')
        AND STAT_LVL = '1'
        UNION ALL
        SELECT T.*, COUNT(1) OVER() C_NUM
        FROM (SELECT LATN_ID || '' REGION_ID,
        LATN_NAME AREA_DESC,
        LATN_SORT || '' LATN_SORT,
        SUM(COL_NUM_1) ORDER_CNT,
        SUM(COL_NUM_2) EXEC_CNT,
        DECODE(NVL(SUM(COL_NUM_1), 0),
        '0',
        '0.00%',
        TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /
        SUM(COL_NUM_1),
        4) * 100,
        'FM999999990.00') || '%') USE_RATE,
        DECODE(NVL(SUM(COL_NUM_1), 0),
        '0',
        '0.00%',
        TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /
        SUM(COL_NUM_1),
        4) * 100,
        'FM999999990.00')) USE_RATE1,
        SUM(COL_NUM_3) SUCC_CNT,
        DECODE(NVL(SUM(COL_NUM_1), 0),
        '0',
        '0.00%',
        TO_CHAR(ROUND(NVL(SUM(COL_NUM_3), 0) /
        SUM(COL_NUM_1),
        4) * 100,
        'FM999999990.00') || '%') SUCC_LV
        FROM EDW.VW_GSCH_MKT_ORDER_STAT_MONTH@GSEDW
        WHERE 1 = 1
        AND STAT_MONTH = TO_CHAR(SYSDATE, 'yyyymm')
        AND STAT_LVL = '1'
        GROUP BY LATN_ID, LATN_NAME, LATN_SORT) T
        )
        WHERE 1 = 1
        <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
            and (${param.condition_str})
        </e:if>
        )
        ORDER BY TO_NUMBER(ORD) ASC
    </c:tablequery>
  </e:case>

  <e:case value="index_bureau">
    <c:tablequery>
      select * from(
      SELECT DISTINCT
      b.bureau_no latn_id,b.latn_name,b.bureau_name AREA_DESC,
      CASE
      WHEN nvl(GZ_ZHU_HU_COUNT,0) = 0 THEN
      '0.00%'
      ELSE
      to_char(ROUND(nvl(GZ_H_USE_CNT,0) / GZ_ZHU_HU_COUNT, 4) * 100,'990.00') || '%'
      END USE_RATE,
      CASE
      WHEN nvl(GZ_ZHU_HU_COUNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(GZ_H_USE_CNT,0) / GZ_ZHU_HU_COUNT, 4)*100
      END USE_RATE1,
      nvl(gz_zhu_hu_count,0) gz_zhu_hu_count,
      nvl(gz_h_use_cnt,0) gz_h_use_cnt,
      nvl(gov_zhu_hu_count,0) gov_zhu_hu_count,
      nvl(gov_h_use_cnt,0) gov_h_use_cnt,
      trim(to_char(round(nvl(filter_mon_rate,0),4)*100,'9999990.00')||'%') up_month,
      trim(to_char(round(nvl(filter_year_rate,0),4)*100,'9999990.00')||'%') up_year
      FROM ${gis_user}.TB_GIS_RES_city_DAY a,
      (
        SELECT latn_name,bureau_no,bureau_name FROM ${gis_user}.db_cde_grid
        where 1=1
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.region_id}">
            and latn_Id = '${param.region_id}'
          </e:if>
        </e:if>
      ) b
      WHERE a.flg = 2 AND a.branch_type = 'a1' AND a.latn_id = b.bureau_no)
      where 1=1

      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY use_rate1 DESC
    </c:tablequery>
  </e:case>


  <e:case value="index_fb_cover_bureau">
    <c:tablequery>
      select * from(
      SELECT DISTINCT
      b.bureau_no latn_id,b.latn_name,b.bureau_name AREA_DESC,
      case
        when nvl(LY_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      CASE
      WHEN nvl(LY_CNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT, 4)*100
      END USE_RATE1,
      nvl(ly_cnt, 0) ly_cnt,
      nvl(no_res_arrive_cnt, 0) no_res_arrive_cnt,
      nvl(gz_zhu_hu_count, 0) gz_zhu_hu_count,
      nvl(VILLAGE_CNT, 0) VILLAGE_CNT
      FROM ${gis_user}.TB_GIS_RES_city_DAY a,
      (
        SELECT latn_name,bureau_no,bureau_name FROM ${gis_user}.db_cde_grid
        where 1=1
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.region_id}">
            and latn_Id = '${param.region_id}'
          </e:if>
        </e:if>
      ) b
      WHERE a.flg = 2 AND a.branch_type = 'a1' AND a.latn_id = b.bureau_no)
      where 1=1

      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY use_rate1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_fb_real_percent_bureau">
    <c:tablequery>
      select * from(
      SELECT DISTINCT
      b.bureau_no latn_id,b.latn_name,b.bureau_name AREA_DESC,
      CASE
        WHEN nvl(PORT_ID_CNT,0) = 0 THEN
            0
        ELSE
            ROUND(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT, 4)*100
      END USE_RATE1,
      case
        when nvl(PORT_ID_CNT, 0) = 0 then
            '0.00%'
        else
            to_char(round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      nvl(USE_PORT_CNT, 0) USE_PORT_CNT,
      nvl(KONG_PORT_CNT, 0) KONG_PORT_CNT,
      nvl(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
      nvl(PORT_ID_CNT, 0) PORT_ID_CNT
      FROM ${gis_user}.TB_GIS_RES_city_DAY a,
      (
        SELECT latn_name,bureau_no,bureau_name FROM ${gis_user}.db_cde_grid
        where 1=1
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.region_id}">
            and latn_Id = '${param.region_id}'
          </e:if>
        </e:if>
      ) b
      WHERE a.flg = 2 AND a.branch_type = 'a1' AND a.latn_id = b.bureau_no)
      where 1=1

      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY use_rate1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_protection_bureau">
    <c:tablequery>
      select * from(
      SELECT DISTINCT
      b.bureau_no latn_id,b.latn_name,b.bureau_name AREA_DESC,
      case
        when nvl(BY_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      case
        when nvl(BY_ALL_CNT, 0) = 0 then
         0
        else
         round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
      end USE_RATE1,
      case
        when nvl(XY_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100,'990.00') || '%'
      end XY_RATE,
        case
        when nvl(XY_ALL_CNT, 0) = 0 then
        0
        else
        round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100
        end XY_RATE1,
      case
        when nvl(ACTIVE_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT,4) * 100,'990.00') || '%'
      end ACTIVE_RATE
      FROM ${gis_user}.TB_GIS_RES_city_DAY a,
      (
        SELECT latn_name,bureau_no,bureau_name FROM ${gis_user}.db_cde_grid
        where 1=1
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.region_id}">
            and latn_Id = '${param.region_id}'
          </e:if>
        </e:if>
      ) b
      WHERE a.flg = 2 AND a.branch_type = 'a1' AND a.latn_id = b.bureau_no)
      where 1=1

      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY use_rate1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_dispatch_bureau">
    <c:tablequery>
        SELECT *
        FROM (
        SELECT T.*,COUNT(1) OVER() C_NUM FROM(
        SELECT
        latn_name,
        BUREAU_NO latn_id,
        BUREAU_NAME AREA_DESC,
        BUREAU_SORT||'' ord,
        SUM(COL_NUM_1) order_cnt,
        SUM(COL_NUM_2) exec_cnt,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00') || '%') use_rate,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00', TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00')) USE_RATE1,
        SUM(COL_NUM_3) succ_cnt,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_3), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00') || '%') succ_lv
        FROM
        EDW.VW_GSCH_MKT_ORDER_STAT_MONTH@GSEDW
        WHERE 1=1
        AND STAT_MONTH = to_char(sysdate,'yyyymm')
        AND STAT_LVL = '2'
        <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
                and latn_Id = '${param.region_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.region_id}">
                and bureau_name = '${param.region_id}'
                and latn_id = '${param.city_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and bureau_name = '${param.region_id}'
            </e:if>
        </e:if>
        GROUP BY
        LATN_NAME, BUREAU_NO, BUREAU_NAME, BUREAU_SORT
        )T
        where 1=1
        <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
            and (${param.condition_str})
        </e:if>
        )
        ORDER BY to_number(ord)
    </c:tablequery>
  </e:case>

  <e:case value="index_collect_bureau">
    <c:tablequery>
      select * from(
      SELECT DISTINCT
      b.bureau_no latn_id,b.latn_name,b.bureau_name AREA_DESC,
      case
        when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      case
        when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
         0
        else
         round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
      end USE_RATE1,
      nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
      nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
      trim(to_char(round(nvl(OTHER_MON_RATE,0),4)*100,'9990.00')||'%') OTHER_MON_RATE,
  	  trim(to_char(round(nvl(OTHER_YEAR_RATE,0),4)*100,'9990.00')||'%') OTHER_YEAR_RATE
      FROM ${gis_user}.TB_GIS_RES_city_DAY a,
      (
        SELECT latn_name,bureau_no,bureau_name FROM ${gis_user}.db_cde_grid
        where 1=1
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.region_id}">
            and latn_Id = '${param.region_id}'
          </e:if>
        </e:if>
      ) b
      WHERE a.flg = 2 AND a.branch_type = 'a1' AND a.latn_id = b.bureau_no)
      where 1=1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY use_rate1 DESC
    </c:tablequery>
  </e:case>


  <e:case value="index_sub">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.union_org_code LATN_ID,
        b.latn_name,
      B.branch_name AREA_DESC,
      CASE
      WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
      '0.00%'
      ELSE
      TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) /
      GZ_ZHU_HU_COUNT,
      4) * 100,
      '990.00') || '%'
      END USE_RATE,
      CASE
      WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
      0
      ELSE
      ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100
      END USE_RATE1，
      NVL(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
      NVL(GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
      NVL(GOV_ZHU_HU_COUNT, 0) GOV_ZHU_HU_COUNT,
      NVL(GOV_H_USE_CNT, 0) GOV_H_USE_CNT,
      trim(to_char(round(nvl(filter_mon_rate,0),4)*100,'9999990.00')||'%') up_month,
      trim(to_char(round(nvl(filter_year_rate,0),4)*100,'9999990.00')||'%') up_year
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,union_org_code, branch_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and branch_name like '%'||'${param.name}'||'%'
      </e:if>
        and grid_union_org_code is not null
        and BRANCH_TYPE = 'a1'
      ) B
      WHERE A.FLG = 3
      AND A.LATN_ID = B.union_org_code)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_fb_cover_sub">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.union_org_code LATN_ID,
      b.latn_name,
      B.branch_name AREA_DESC,
      case
        when nvl(LY_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      CASE
      WHEN nvl(LY_CNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT, 4)*100
      END USE_RATE1,
      nvl(ly_cnt, 0) ly_cnt,
      nvl(no_res_arrive_cnt, 0) no_res_arrive_cnt,
      nvl(gz_zhu_hu_count, 0) gz_zhu_hu_count,
      nvl(VILLAGE_CNT, 0) VILLAGE_CNT
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_Name,union_org_code, branch_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
	  <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and branch_name like '%'||'${param.name}'||'%'
      </e:if>
        and grid_union_org_code is not null
        and BRANCH_TYPE = 'a1'
      ) B
      WHERE A.FLG = 3
      AND A.LATN_ID = B.union_org_code)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_fb_real_percent_sub">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.union_org_code LATN_ID,
      b.latn_name,
      B.branch_name AREA_DESC,
      CASE
      WHEN nvl(PORT_ID_CNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT, 4)*100
      END USE_RATE1,
     case
       when nvl(PORT_ID_CNT, 0) = 0 then
        '0.00%'
       else
        to_char(round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100,'990.00') || '%'
     end USE_RATE,
     nvl(USE_PORT_CNT, 0) USE_PORT_CNT,
     nvl(KONG_PORT_CNT, 0) KONG_PORT_CNT,
     nvl(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
     nvl(PORT_ID_CNT, 0) PORT_ID_CNT
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,union_org_code, branch_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
	  <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and branch_name like '%'||'${param.name}'||'%'
      </e:if>
        and grid_union_org_code is not null
        and BRANCH_TYPE = 'a1'
      ) B
      WHERE A.FLG = 3
      AND A.LATN_ID = B.union_org_code)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_protection_sub">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.union_org_code LATN_ID,
      b.latn_name,
      B.branch_name AREA_DESC,
      case
        when nvl(BY_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      case
        when nvl(BY_ALL_CNT, 0) = 0 then
         0
        else
         round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
      end USE_RATE1,
      case
        when nvl(XY_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100,'990.00') || '%'
      end XY_RATE,
        case
        when nvl(XY_ALL_CNT, 0) = 0 then
        0
        else
        round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100
        end XY_RATE1,
      case
        when nvl(ACTIVE_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT,4) * 100,'990.00') || '%'
      end ACTIVE_RATE
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,union_org_code, branch_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
	  <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and branch_name like '%'||'${param.name}'||'%'
      </e:if>
        and grid_union_org_code is not null
        and BRANCH_TYPE = 'a1'
      ) B
      WHERE A.FLG = 3
      AND A.LATN_ID = B.union_org_code)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_collect_sub">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.union_org_code LATN_ID,
      b.latn_name,
      B.branch_name AREA_DESC,
      case
       when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
        '0.00%'
       else
        to_char(round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100,'990.00') || '%'
     end USE_RATE,
     case
       when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
        0
       else
        round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
     end USE_RATE1,
     nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
     nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
     trim(to_char(round(nvl(OTHER_MON_RATE,0),4)*100,'9990.00')||'%') OTHER_MON_RATE,
 	 trim(to_char(round(nvl(OTHER_YEAR_RATE,0),4)*100,'9990.00')||'%') OTHER_YEAR_RATE
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,union_org_code, branch_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
	  <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and branch_name like '%'||'${param.name}'||'%'
      </e:if>
        and grid_union_org_code is not null
        and BRANCH_TYPE = 'a1'
      ) B
      WHERE A.FLG = 3
      AND A.LATN_ID = B.union_org_code)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

   <e:case value="index_dispatch_sub">
    <c:tablequery>
        SELECT *
        FROM (
        SELECT T.*,COUNT(1) OVER() C_NUM FROM(
        SELECT
        latn_name,
        branch_union_org_code || '' UNION_ORG_CODE,
        BRANCH_NAME AREA_DESC,
        branch_sort || '' ord,

        SUM(COL_NUM_1) order_cnt,
        SUM(COL_NUM_2) exec_cnt,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00') || '%') use_rate,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00')) USE_RATE1,
        SUM(COL_NUM_3) succ_cnt,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_3), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00') || '%') succ_lv
        FROM
        EDW.VW_GSCH_MKT_ORDER_STAT_MONTH@GSEDW
        WHERE 1=1
        AND STAT_MONTH = to_char(sysdate,'yyyymm')
        AND STAT_LVL = '3'
        <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
                and latn_Id = '${param.region_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
        </e:if>
        <e:if condition="${!empty param.name}">
            and branch_name like '%'||'${param.name}'||'%'
        </e:if>
        GROUP BY
        latn_name,branch_union_org_code, branch_name, branch_sort
        )T
        where 1=1
        <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
            and (${param.condition_str})
        </e:if>
        )
        ORDER BY to_number(ord)
    </c:tablequery>
  </e:case>

  <e:case value="index_grid">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.grid_id LATN_ID,b.latn_name,
      b.grid_union_org_code,
      B.grid_name AREA_DESC,
      CASE
      WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
      '0.00%'
      ELSE
      TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) /
      GZ_ZHU_HU_COUNT,
      4) * 100,
      '990.00') || '%'
      END USE_RATE,
      CASE
      WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
      0
      ELSE
      ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100
      END USE_RATE1，
      NVL(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
      NVL(GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
      NVL(GOV_ZHU_HU_COUNT, 0) GOV_ZHU_HU_COUNT,
      NVL(GOV_H_USE_CNT, 0) GOV_H_USE_CNT,
      trim(to_char(round(nvl(filter_mon_rate,0),4)*100,'9999990.00')||'%') up_month,
      trim(to_char(round(nvl(filter_year_rate,0),4)*100,'9999990.00')||'%') up_year
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,grid_id,grid_union_org_code, grid_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
            and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
            and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and grid_name like '%'||'${param.name}'||'%'
      </e:if>
          and branch_type = 'a1'
          and grid_union_org_code is not null
          and grid_union_org_code != -1
          and grid_status = 1
      ) B
      WHERE A.FLG = 4
      AND A.LATN_ID = B.grid_id)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>


  <e:case value="index_fb_cover_grid">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.grid_id LATN_ID,b.latn_name,
      b.grid_union_org_code,
      B.grid_name AREA_DESC,
	  case
        when nvl(LY_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      CASE
      WHEN nvl(LY_CNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT, 4)*100
      END USE_RATE1,
      nvl(ly_cnt, 0) ly_cnt,
      nvl(no_res_arrive_cnt, 0) no_res_arrive_cnt,
      nvl(gz_zhu_hu_count, 0) gz_zhu_hu_count,
      nvl(VILLAGE_CNT, 0) VILLAGE_CNT
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,grid_id,grid_union_org_code, grid_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and grid_name like '%'||'${param.name}'||'%'
      </e:if>
          and branch_type = 'a1'
        and grid_union_org_code is not null
        and grid_union_org_code != -1
        and grid_status = 1
      ) B
      WHERE A.FLG = 4
      AND A.BRANCH_TYPE = 'a1'
      AND A.LATN_ID = B.grid_id)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_fb_real_percent_grid">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.grid_id LATN_ID,b.latn_name,
      b.grid_union_org_code,
      B.grid_name AREA_DESC,
	  CASE
      WHEN nvl(PORT_ID_CNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT, 4)*100
      END USE_RATE1,
     case
       when nvl(PORT_ID_CNT, 0) = 0 then
        '0.00%'
       else
        to_char(round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100,'990.00') || '%'
     end USE_RATE,
     nvl(USE_PORT_CNT, 0) USE_PORT_CNT,
     nvl(KONG_PORT_CNT, 0) KONG_PORT_CNT,
     nvl(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
     nvl(PORT_ID_CNT, 0) PORT_ID_CNT
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,grid_id,grid_union_org_code, grid_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and grid_name like '%'||'${param.name}'||'%'
      </e:if>
          and branch_type = 'a1'
        and grid_union_org_code is not null
        and grid_union_org_code != -1
        and grid_status = 1
      ) B
      WHERE A.FLG = 4
      AND A.BRANCH_TYPE = 'a1'
      AND A.LATN_ID = B.grid_id)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_protection_grid">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.grid_id LATN_ID,b.latn_name,
      b.grid_union_org_code,
      B.grid_name AREA_DESC,
	  case
        when nvl(BY_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      case
        when nvl(BY_ALL_CNT, 0) = 0 then
         0
        else
         round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
      end USE_RATE1,
      case
        when nvl(XY_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100,'990.00') || '%'
      end XY_RATE,
        case
        when nvl(XY_ALL_CNT, 0) = 0 then
        0
        else
        round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100
        end XY_RATE1,
      case
        when nvl(ACTIVE_ALL_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT,4) * 100,'990.00') || '%'
      end ACTIVE_RATE
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,grid_id,grid_union_org_code, grid_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and grid_name like '%'||'${param.name}'||'%'
      </e:if>
          and branch_type = 'a1'
        and grid_union_org_code is not null
        and grid_union_org_code != -1
        and grid_status = 1
      ) B
      WHERE A.FLG = 4
      AND A.BRANCH_TYPE = 'a1'
      AND A.LATN_ID = B.grid_id)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_collect_grid">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.grid_id LATN_ID,b.latn_name,
      b.grid_union_org_code,
      B.grid_name AREA_DESC,
	  case
        when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
      case
        when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
         0
        else
         round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
      end USE_RATE1,
      nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
      nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
      trim(to_char(round(nvl(OTHER_MON_RATE,0),4)*100,'9990.00')||'%') OTHER_MON_RATE,
  		trim(to_char(round(nvl(OTHER_YEAR_RATE,0),4)*100,'9990.00')||'%') OTHER_YEAR_RATE
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A,
      (SELECT latn_name,grid_id,grid_union_org_code, grid_name
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.region_id}">
          and latn_Id = '${param.region_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.region_id}">
          and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${!empty param.name}">
          and grid_name like '%'||'${param.name}'||'%'
      </e:if>
          and branch_type = 'a1'
        and grid_union_org_code is not null
        and grid_union_org_code != -1
        and grid_status = 1
      ) B
      WHERE A.FLG = 4
      AND A.BRANCH_TYPE = 'a1'
      AND A.LATN_ID = B.grid_id)
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>

      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

<e:case value="index_dispatch_grid">
    <c:tablequery>
        SELECT *
        FROM (
        SELECT T.*,COUNT(1) OVER() C_NUM FROM(
        SELECT
        grid_union_org_code || '' latn_id,
        latn_name,
        GRID_NAME AREA_DESC,
        grid_sort || '' ord,
        SUM(COL_NUM_1) order_cnt,
        SUM(COL_NUM_2) exec_cnt,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00') || '%') use_rate,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_2), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00')) USE_RATE1,
        SUM(COL_NUM_3) succ_cnt,
        DECODE(NVL(SUM(COL_NUM_1), 0), '0', '0.00%', TO_CHAR(ROUND(NVL(SUM(COL_NUM_3), 0) /SUM(COL_NUM_1), 4) * 100, 'FM999999990.00') || '%') succ_lv
        FROM
        EDW.VW_GSCH_MKT_ORDER_STAT_MONTH@GSEDW
        WHERE 1=1
        AND STAT_MONTH = to_char(sysdate,'yyyymm')
        AND STAT_LVL = '4'
        <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
                and latn_Id = '${param.region_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
        </e:if>
        <e:if condition="${!empty param.name}">
            and grid_name like '%'||'${param.name}'||'%'
        </e:if>
        GROUP BY
        latn_name,grid_union_org_code, grid_name, grid_sort
        )T
        where 1=1
        <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
            and (${param.condition_str})
        </e:if>
        )
        ORDER BY to_number(ord)
    </c:tablequery>
  </e:case>

  <e:case value="index_village">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.village_id LATN_ID,
      b.latn_name,
      B.village_name AREA_DESC,
      CASE
      WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
      '0.00%'
      ELSE
      TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) /
      GZ_ZHU_HU_COUNT,
      4) * 100,
      '9999999990.00') || '%'
      END USE_RATE,
      CASE
      WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
      0
      ELSE
      (case when ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4)*100 > 1000 then 0 else
        (ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4))
        end) * 100
      END
      USE_RATE1，
      NVL(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
      NVL(GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
      NVL(GOV_ZHU_HU_COUNT, 0) GOV_ZHU_HU_COUNT,
      NVL(GOV_H_USE_CNT, 0) GOV_H_USE_CNT,
      trim(to_char(round(nvl(filter_mon_rate,0),4)*100,'9999990.00')||'%') up_month,
      case when round(nvl(filter_mon_rate,0),4)*100 > 100 then 0 else round(nvl(filter_mon_rate,0),4)*100 end up_month1,
      trim(to_char(round(nvl(filter_year_rate,0),4)*100,'9999990.00')||'%') up_year
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
      (
        SELECT village_id,village_name,latn_Name FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A,
        (
        SELECT DISTINCT latn_name,UNION_ORG_CODE,grid_id
        FROM ${gis_user}.DB_CDE_GRID
        WHERE 1 = 1
        AND BRANCH_TYPE = 'a1'
        AND GRID_UNION_ORG_CODE IS NOT NULL
        <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
                and latn_Id = '${param.region_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
        </e:if>
        )b
        WHERE (a.branch_no = b.union_org_code
        OR a.grid_id_2 = b.grid_id)
        <e:if condition="${!empty param.name}">
            and village_name like '%'||'${param.name}'||'%'
        </e:if>
      ) B
      on A.LATN_ID = B.village_id
      and A.FLG = 5
      )
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

    <e:case value="index_village_count_limited">
        <c:tablequery>
            select * from(
            SELECT *
            FROM (SELECT DISTINCT B.village_id LATN_ID,b.latn_Name,
            B.village_name AREA_DESC,
            CASE
            WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
            '0.00%'
            ELSE
            TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) /
            GZ_ZHU_HU_COUNT,
            4) * 100,
            '9999999990.00') || '%'
            END USE_RATE,
            CASE
            WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
            0
            ELSE
            (case when ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4)*100 > 1000 then 0 else
            (ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4))
            end) * 100
            END
            USE_RATE1，
            NVL(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
            NVL(GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
            NVL(GOV_ZHU_HU_COUNT, 0) GOV_ZHU_HU_COUNT,
            NVL(GOV_H_USE_CNT, 0) GOV_H_USE_CNT,
            trim(to_char(round(nvl(filter_mon_rate,0),4)*100,'9999990.00')||'%') up_month,
            ROUND(NVL(FILTER_MON_RATE,
            0),4) * 100  up_month1,
            trim(to_char(round(nvl(filter_year_rate,0),4)*100,'9999990.00')||'%') up_year
            FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
            (SELECT village_id,village_name,latn_Name FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A,
            (
            SELECT DISTINCT latn_name,UNION_ORG_CODE,grid_id
            FROM ${gis_user}.DB_CDE_GRID
            WHERE 1 = 1
            AND BRANCH_TYPE = 'a1'
            AND GRID_UNION_ORG_CODE IS NOT NULL
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3' || param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            )b
            WHERE (a.branch_no = b.union_org_code
            OR a.grid_id_2 = b.grid_id)
            <e:if condition="${!empty param.name}">
                and village_name like '%'||'${param.name}'||'%'
            </e:if>
            ) B
            on A.LATN_ID = B.village_id
            and A.FLG = 5
            )
            WHERE 1 = 1
            AND UP_MONTH1 <= 100
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
            )
            where 1=1
        </c:tablequery>
    </e:case>

    <e:case value="index_village_cnt">
        <e:q4o var="dataObject">
            SELECT COUNT(CASE
            WHEN a.use_rate1 >= 60 THEN
            1
            END) GT_1,
            COUNT(CASE
            WHEN (a.use_rate1 < 60 AND a.use_rate1 >= 50) THEN
            1
            END) RAG_2,
            COUNT(CASE
            WHEN (a.use_rate1 < 50 AND a.use_rate1 >= 40) THEN
            1
            END) RAG_3,
            COUNT(CASE
            WHEN (a.use_rate1 < 40 AND a.use_rate1 >= 30) THEN
            1
            END) RAG_4,
            COUNT(CASE
            WHEN (a.use_rate1 < 30 AND a.use_rate1 >= 20) THEN
            1
            END) RAG_5,
            COUNT(CASE
            WHEN (a.use_rate1 < 20) THEN
            1
            END) LT_6,
            COUNT(1) SUM_CNT
            FROM
            (
            SELECT * FROM (
            SELECT
            (
            CASE
            WHEN NVL(GZ_ZHU_HU_COUNT, 0) = 0 THEN
            0
            ELSE
            (case when ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4)*100 > 1000 then 0 else
            (ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4))
            end) * 100
            END
            )
            use_rate1,
            latn_id,flg
            FROM
            ${gis_user}.TB_GIS_RES_CITY_DAY)
            WHERE 1=1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
            ) A right outer join
            (SELECT VILLAGE_ID, VILLAGE_NAME
            FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A
            WHERE 1 = 1
            <e:if condition="${!empty param.name}">
                and A.village_name like '%'||'${param.name}'||'%'
            </e:if>
            AND A.BRANCH_NO IN
            (SELECT UNION_ORG_CODE
            FROM ${gis_user}.DB_CDE_GRID
            WHERE 1 = 1
            AND BRANCH_TYPE = 'a1'
            AND GRID_UNION_ORG_CODE IS NOT NULL
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            )) B
            on A.LATN_ID = B.VILLAGE_ID
            and A.FLG = 5
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

  <e:case value="index_fb_cover_village">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.village_id LATN_ID,
      B.village_name AREA_DESC,
      case
        when nvl(LY_CNT, 0) = 0 then
         '0.00%'
        else
         to_char(round(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100,'990.00') || '%'
      end USE_RATE,
       CASE
      WHEN nvl(LY_CNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT, 4)*100
      END USE_RATE1,
      nvl(ly_cnt, 0) ly_cnt,
      nvl(no_res_arrive_cnt, 0) no_res_arrive_cnt,
      nvl(gz_zhu_hu_count, 0) gz_zhu_hu_count,
      nvl(VILLAGE_CNT, 0) VILLAGE_CNT
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
      (SELECT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info a
        WHERE 1=1
        <e:if condition="${!empty param.name}">
            and a.village_name like '%'||'${param.name}'||'%'
        </e:if>
        AND a.branch_no IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE 1=1
          and branch_type= 'a1'
          and grid_union_org_code is not null
          <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
              and latn_Id = '${param.region_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.region_id}">
              and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
              and latn_id = '${param.city_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
          </e:if>
        )
      ) B
      on A.LATN_ID = B.village_id
      and A.FLG = 5
      )
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

  <e:case value="index_village_count_fb_cover_limited">
      <c:tablequery>
          select * from (
          SELECT *
          FROM (SELECT DISTINCT B.village_id LATN_ID,b.latn_name,
          B.village_name AREA_DESC,
          case
          when nvl(LY_CNT, 0) = 0 then
          '0.00%'
          else
          to_char(round(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT,4) * 100,'990.00') || '%'
          end USE_RATE,
          CASE
          WHEN nvl(LY_CNT,0) = 0 THEN
          0
          ELSE
          ROUND(nvl(ly_cnt - NO_RES_ARRIVE_CNT, 0) / LY_CNT, 4)*100
          END USE_RATE1,
          nvl(ly_cnt, 0) ly_cnt,
          nvl(no_res_arrive_cnt, 0) no_res_arrive_cnt,
          nvl(gz_zhu_hu_count, 0) gz_zhu_hu_count,
          nvl(VILLAGE_CNT, 0) VILLAGE_CNT
          FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
          (SELECT village_id,village_name,latn_Name FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A,
              (
              SELECT DISTINCT latn_name,UNION_ORG_CODE,grid_id
              FROM ${gis_user}.DB_CDE_GRID
              WHERE 1 = 1
              AND BRANCH_TYPE = 'a1'
              AND GRID_UNION_ORG_CODE IS NOT NULL
              <e:if condition="${param.flag eq '2'}">
                  <e:if condition="${!empty param.region_id}">
                      and latn_Id = '${param.region_id}'
                  </e:if>
              </e:if>
              <e:if condition="${param.flag eq '3'}">
                  <e:if condition="${!empty param.region_id}">
                      and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                      and latn_id = '${param.city_id}'
                  </e:if>
              </e:if>
              <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                  <e:if condition="${!empty param.region_id}">
                      and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                      and latn_id = '${param.city_id}'
                  </e:if>
              </e:if>
              )b
              WHERE (a.branch_no = b.union_org_code
              OR a.grid_id_2 = b.grid_id)
              <e:if condition="${!empty param.name}">
                  and village_name like '%'||'${param.name}'||'%'
              </e:if>
          ) B
          on A.LATN_ID = B.village_id
          and A.FLG = 5
          )
          WHERE 1 = 1
          <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
              and (${param.condition_str})
          </e:if>
          )
          where 1=1
      </c:tablequery>
  </e:case>

  <e:case value="index_village_fb_cover_cnt">
      <e:q4o var="dataObject">
          SELECT COUNT(CASE
          WHEN use_rate1 >= 80 THEN
          1
          END) GT_1,
          COUNT(CASE
          WHEN (use_rate1 < 80 AND use_rate1 >= 70) THEN
          1
          END) RAG_2,
          COUNT(CASE
          WHEN (use_rate1 < 70 AND use_rate1 >= 60) THEN
          1
          END) RAG_3,
          COUNT(CASE
          WHEN (use_rate1 < 60 AND use_rate1 >= 50) THEN
          1
          END) RAG_4,
          COUNT(CASE
          WHEN (use_rate1 < 50 AND use_rate1 >= 40) THEN
          1
          END) RAG_5,
          COUNT(CASE
          WHEN (use_rate1 < 40) THEN
          1
          END) LT_6,
          COUNT(1) SUM_CNT
          FROM
          (
          SELECT * FROM(
          SELECT flg,latn_id,
          (CASE
          WHEN NVL(LY_CNT, 0) = 0 THEN
          0
          ELSE
          ROUND(NVL(LY_CNT - NO_RES_ARRIVE_CNT, 0) / LY_CNT, 4) * 100
          END) use_rate1 from
          ${gis_user}.TB_GIS_RES_CITY_DAY
          )
          WHERE 1=1
          <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
              and (${param.condition_str})
          </e:if>
          ) A right outer join
          (SELECT VILLAGE_ID, VILLAGE_NAME
          FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A
          WHERE 1 = 1
          <e:if condition="${!empty param.name}">
              and a.village_name like '%'||'${param.name}'||'%'
          </e:if>
          AND A.BRANCH_NO IN
          (SELECT UNION_ORG_CODE
          FROM ${gis_user}.DB_CDE_GRID
          WHERE 1 = 1
          AND BRANCH_TYPE = 'a1'
          AND GRID_UNION_ORG_CODE IS NOT NULL
          <e:if condition="${param.flag eq '2'}">
              <e:if condition="${!empty param.region_id}">
                  and latn_Id = '${param.region_id}'
              </e:if>
          </e:if>
          <e:if condition="${param.flag eq '3'}">
              <e:if condition="${!empty param.region_id}">
                  and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
              </e:if>
          </e:if>
          <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
              <e:if condition="${!empty param.region_id}">
                  and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                  and latn_id = '${param.city_id}'
              </e:if>
          </e:if>
          )) B
          on A.LATN_ID = B.VILLAGE_ID
          and A.FLG = 5
      </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="index_fb_real_percent_village">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.village_id LATN_ID,
      B.village_name AREA_DESC,
      CASE
      WHEN nvl(PORT_ID_CNT,0) = 0 THEN
      0
      ELSE
      ROUND(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT, 4)*100
      END USE_RATE1,
     case
       when nvl(PORT_ID_CNT, 0) = 0 then
        '0.00%'
       else
        to_char(round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100,'990.00') || '%'
     end USE_RATE,
     nvl(USE_PORT_CNT, 0) USE_PORT_CNT,
     nvl(KONG_PORT_CNT, 0) KONG_PORT_CNT,
     nvl(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
     nvl(PORT_ID_CNT, 0) PORT_ID_CNT
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
      (SELECT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info a
        WHERE 1=1
        <e:if condition="${!empty param.name}">
            and a.village_name like '%'||'${param.name}'||'%'
        </e:if>
        AND a.branch_no IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE 1=1
          and branch_type= 'a1'
          and grid_union_org_code is not null

          <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
              and latn_Id = '${param.region_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.region_id}">
              and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
              and latn_id = '${param.city_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
          </e:if>
        )
      ) B
      on A.LATN_ID = B.village_id
      and A.FLG = 5
      )
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

    <e:case value="index_fb_real_percent_village_limited">
        <c:tablequery>
            select * from (
            SELECT *
            FROM (SELECT DISTINCT b.village_id LATN_ID,b.latn_name,
            B.village_name AREA_DESC,
            CASE
            WHEN nvl(PORT_ID_CNT,0) = 0 THEN
            0
            ELSE
            ROUND(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT, 4)*100
            END USE_RATE1,
            case
            when nvl(PORT_ID_CNT, 0) = 0 then
            '0.00%'
            else
            to_char(round(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT,4) * 100,'990.00') || '%'
            end USE_RATE,
            nvl(USE_PORT_CNT, 0) USE_PORT_CNT,
            nvl(KONG_PORT_CNT, 0) KONG_PORT_CNT,
            nvl(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
            nvl(PORT_ID_CNT, 0) PORT_ID_CNT
            FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
            (SELECT village_id,village_name,latn_Name FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A,
            (
            SELECT DISTINCT latn_name,UNION_ORG_CODE,grid_id
            FROM ${gis_user}.DB_CDE_GRID
            WHERE 1 = 1
            AND BRANCH_TYPE = 'a1'
            AND GRID_UNION_ORG_CODE IS NOT NULL

            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            )b
            WHERE (a.branch_no = b.union_org_code
            OR a.grid_id_2 = b.grid_id)
            <e:if condition="${!empty param.name}">
                and village_name like '%'||'${param.name}'||'%'
            </e:if>
            ) B
            on a.latn_id = b.village_id
            and A.FLG = 5
            )
            WHERE 1 = 1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
            )
            where 1=1
        </c:tablequery>
    </e:case>

  <e:case value="index_village_real_percent_cnt">
      <e:q4o var="dataObject">
          SELECT
          count(
          case when use_rate1>=40 then 1 END) gt_1,
          count(
          case when (
          use_rate1<40 AND
          use_rate1>=35)
          then 1 END) rag_2,
          count(
          case when (
          use_rate1<35 AND
          use_rate1>=30)
          then 1 END) rag_3,
          count(
          case when (
          use_rate1<30 AND
          use_rate1>=25)
          then 1 END) rag_4,
          count(
          case when (
          use_rate1<25 AND
          use_rate1>=20)
          then 1 END) rag_5,
          count(
          case when (
          use_rate1<20)
          then 1 END) lt_6,
          COUNT(1) sum_cnt
          FROM
          (
          SELECT * FROM(
          select
          flg,latn_id,
          (CASE
          WHEN nvl(PORT_ID_CNT,0) = 0 THEN
          0
          ELSE
          ROUND(nvl(USE_PORT_CNT, 0) / PORT_ID_CNT, 4)*100
          END ) use_rate1 from
          ${gis_user}.TB_GIS_RES_CITY_DAY
          )
          where 1=1
          <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
              and (${param.condition_str})
          </e:if>
          )A right outer join
          (SELECT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info a
          WHERE 1=1
          <e:if condition="${!empty param.name}">
              and a.village_name like '%'||'${param.name}'||'%'
          </e:if>
          AND a.branch_no IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid
          WHERE 1=1 and branch_type= 'a1'
          and grid_union_org_code is not null

          <e:if condition="${param.flag eq '2'}">
              <e:if condition="${!empty param.region_id}">
                  and latn_Id = '${param.region_id}'
              </e:if>
          </e:if>
          <e:if condition="${param.flag eq '3'}">
              <e:if condition="${!empty param.region_id}">
                  and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
              </e:if>
          </e:if>
          <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
              <e:if condition="${!empty param.region_id}">
                  and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                  and latn_id = '${param.city_id}'
              </e:if>
          </e:if>
          )
          ) B
          on A.LATN_ID = B.village_id
          and A.FLG = 5
      </e:q4o>${e:java2json(dataObject)}
  </e:case>


  <e:case value="index_protection_village">
    <c:tablequery>
        SELECT *
        FROM (SELECT DISTINCT B.village_id LATN_ID,
        B.village_name AREA_DESC,
        case
        when nvl(BY_ALL_CNT, 0) = 0 then
        '0.00%'
        else
        to_char(round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100,'990.00') || '%'
        end USE_RATE,
        case
        when nvl(BY_ALL_CNT, 0) = 0 then
        0
        else
        round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
        end USE_RATE1,
        case
        when nvl(XY_ALL_CNT, 0) = 0 then
        '0.00%'
        else
        to_char(round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100,'990.00') || '%'
        end XY_RATE,
        case
        when nvl(XY_ALL_CNT, 0) = 0 then
        0
        else
        round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100
        end XY_RATE1,
        case
        when nvl(ACTIVE_ALL_CNT, 0) = 0 then
        '0.00%'
        else
        to_char(round(nvl(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT,4) * 100,'990.00') || '%'
        end ACTIVE_RATE
        FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
        (SELECT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info a
        WHERE 1=1
        <e:if condition="${!empty param.name}">
            and a.village_name like '%'||'${param.name}'||'%'
        </e:if>
        AND a.branch_no IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE 1=1
        and branch_type= 'a1'
        and grid_union_org_code is not null

        <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
                and latn_Id = '${param.region_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
        </e:if>
        )
        ) B
        on A.LATN_ID = B.village_id
        and A.FLG = 5
        )
        WHERE 1 = 1
        <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
            and (${param.condition_str})
        </e:if>
        ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

    <e:case value="index_protection_village_limited">
        <c:tablequery>
            select * from (
            SELECT *
            FROM (SELECT DISTINCT B.village_id LATN_ID,b.latn_Name,
            B.village_name AREA_DESC,
            case
            when nvl(BY_ALL_CNT, 0) = 0 then
            '0.00%'
            else
            to_char(round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100,'990.00') || '%'
            end USE_RATE,
            case
            when nvl(BY_ALL_CNT, 0) = 0 then
            0
            else
            round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
            end USE_RATE1,
            case
            when nvl(XY_ALL_CNT, 0) = 0 then
            '0.00%'
            else
            to_char(round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100,'990.00') || '%'
            end XY_RATE,
            case
            when nvl(XY_ALL_CNT, 0) = 0 then
            0
            else
            round(nvl(XY_CNT, 0) / XY_ALL_CNT,4) * 100
            end XY_RATE1,
            case
            when nvl(ACTIVE_ALL_CNT, 0) = 0 then
            '0.00%'
            else
            to_char(round(nvl(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT,4) * 100,'990.00') || '%'
            end ACTIVE_RATE
            FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
            (SELECT village_id,village_name,latn_Name FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A,
            (
            SELECT DISTINCT latn_name,UNION_ORG_CODE,grid_id
            FROM ${gis_user}.DB_CDE_GRID
            WHERE 1 = 1
            AND BRANCH_TYPE = 'a1'
            AND GRID_UNION_ORG_CODE IS NOT NULL

            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            )b
            WHERE (a.branch_no = b.union_org_code
            OR a.grid_id_2 = b.grid_id)
            <e:if condition="${!empty param.name}">
                and a.village_name like '%'||'${param.name}'||'%'
            </e:if>
            ) B
            on A.LATN_ID = B.village_id
            and A.FLG = 5
            )
            WHERE 1 = 1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
            )
            where 1=1
        </c:tablequery>
    </e:case>

    <e:case value="index_protection_village_cnt">
        <e:q4o var="dataObject">
            SELECT
            count(
            case when use_rate1>=98 then 1 END) gt_1,
            count(
            case when (
            use_rate1<98 AND
            use_rate1>=97)
            then 1 END) rag_2,

            count(
            case when (
            use_rate1<97 AND
            use_rate1>=96)
            then 1 END) rag_3,

            count(
            case when (
            use_rate1<96 AND
            use_rate1>=95)
            then 1 END) rag_4,

            count(
            case when (
            use_rate1<95 AND
            use_rate1>=94)
            then 1 END) rag_5,

            count(
            case when (
            use_rate1<94)
            then 1 END) lt_6,

            COUNT(1) sum_cnt
            FROM
            (SELECT * FROM(
            SELECT flg,latn_id,
            (case
            when nvl(BY_ALL_CNT, 0) = 0 then
            0
            else
            round(nvl(BY_CNT, 0) / BY_ALL_CNT,4) * 100
            end ) use_rate1 FROM
            ${gis_user}.TB_GIS_RES_CITY_DAY)
            WHERE 1=1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
            ) A right outer join
            (SELECT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info a
            WHERE 1=1
            <e:if condition="${!empty param.name}">
                and a.village_name like '%'||'${param.name}'||'%'
            </e:if>
            AND a.branch_no IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE 1=1
            and branch_type= 'a1'
            and grid_union_org_code is not null
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            )
            ) B
            on A.LATN_ID = B.village_id
            and A.FLG = 5
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

  <e:case value="index_collect_village">
    <c:tablequery>
      SELECT *
      FROM (SELECT DISTINCT B.village_id LATN_ID,
      B.village_name AREA_DESC,
      case
         when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
          '0.00%'
         else
          to_char(round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100,'990.00') || '%'
       end USE_RATE,
       case
         when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
          0
         else
          round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
       end USE_RATE1,
       nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
       nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
       trim(to_char(round(nvl(OTHER_MON_RATE,0),4)*100,'9990.00')||'%') OTHER_MON_RATE,
   		trim(to_char(round(nvl(OTHER_YEAR_RATE,0),4)*100,'9990.00')||'%') OTHER_YEAR_RATE
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
      (SELECT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info a
        WHERE 1=1
        <e:if condition="${!empty param.name}">
            and a.village_name like '%'||'${param.name}'||'%'
        </e:if>
        AND a.branch_no IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE 1=1
          and branch_type= 'a1'
          and grid_union_org_code is not null
          <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
              and latn_Id = '${param.region_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.region_id}">
              and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
              and latn_id = '${param.city_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                and latn_id = '${param.city_id}'
            </e:if>
          </e:if>
        )
      ) B
      on A.LATN_ID = B.village_id
      and A.FLG = 5
      )
      WHERE 1 = 1
      <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
        and (${param.condition_str})
      </e:if>
      ORDER BY USE_RATE1 DESC
    </c:tablequery>
  </e:case>

    <e:case value="index_collect_village_limited">
        <c:tablequery>
            select * from (
            SELECT *
            FROM (SELECT DISTINCT B.village_id LATN_ID,b.latn_Name,
            B.village_name AREA_DESC,
            case
            when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
            '0.00%'
            else
            to_char(round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100,'990.00') || '%'
            end USE_RATE,
            case
            when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
            0
            else
            round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
            end USE_RATE1,
            nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
            nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
            trim(to_char(round(nvl(OTHER_MON_RATE,0),4)*100,'9990.00')||'%') OTHER_MON_RATE,
            trim(to_char(round(nvl(OTHER_YEAR_RATE,0),4)*100,'9990.00')||'%') OTHER_YEAR_RATE
            FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
            (SELECT village_id,village_name,latn_Name FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A,
                (
                SELECT DISTINCT latn_name,UNION_ORG_CODE,grid_id
                FROM ${gis_user}.DB_CDE_GRID
                WHERE 1 = 1
                AND BRANCH_TYPE = 'a1'
                AND GRID_UNION_ORG_CODE IS NOT NULL

                <e:if condition="${param.flag eq '2'}">
                    <e:if condition="${!empty param.region_id}">
                        and latn_Id = '${param.region_id}'
                    </e:if>
                </e:if>
                <e:if condition="${param.flag eq '3'}">
                    <e:if condition="${!empty param.region_id}">
                        and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                        and latn_id = '${param.city_id}'
                    </e:if>
                </e:if>
                <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                    <e:if condition="${!empty param.region_id}">
                        and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                        and latn_id = '${param.city_id}'
                    </e:if>
                </e:if>
                )b
                WHERE (a.branch_no = b.union_org_code
                OR a.grid_id_2 = b.grid_id)
                <e:if condition="${!empty param.name}">
                    and a.village_name like '%'||'${param.name}'||'%'
                </e:if>
            ) B
            on A.LATN_ID = B.village_id
            and A.FLG = 5
            )
            WHERE 1 = 1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
            ORDER BY USE_RATE1 DESC)
            where 1=1
        </c:tablequery>
    </e:case>

    <e:case value="index_collect_village_cnt">
        <e:q4o var="dataObject">
            SELECT
            count(CASE WHEN USE_RATE1 >=60 THEN 1 ELSE NULL END) gt_1,
            COUNT(CASE WHEN use_rate1 < 60 AND use_rate1 >=50 THEN 1 ELSE NULL END) rag_2,
            COUNT(CASE WHEN use_rate1 < 50 AND use_rate1 >=40 THEN 1 ELSE NULL END) rag_3,
            COUNT(CASE WHEN use_rate1 < 40 AND use_rate1 >=30 THEN 1 ELSE NULL END) rag_4,
            COUNT(CASE WHEN use_rate1 < 30 AND use_rate1 >=20 THEN 1 ELSE NULL END) rag_5,
            COUNT(CASE WHEN use_rate1 < 20 THEN 1 ELSE NULL END) lt_6,
            COUNT(1) sum_cnt
            FROM (
            SELECT *
            FROM (SELECT DISTINCT A.LATN_ID,
            B.village_name AREA_DESC,
            case
            when nvl(SHOULD_COLLECT_CNT, 0) = 0 then
            0
            else
            round(nvl(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT,4) * 100
            end USE_RATE1
            FROM ${gis_user}.TB_GIS_RES_CITY_DAY A right outer join
            (SELECT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info a
            WHERE 1=1
            <e:if condition="${!empty param.name}">
                and a.village_name like '%'||'${param.name}'||'%'
            </e:if>
            AND a.branch_no IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE 1=1
            and branch_type= 'a1'
            and grid_union_org_code is not null
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bureau_name = '${param.region_id}' or bureau_no = '${param.region_id}')
                    and latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            )
            ) B
            on A.LATN_ID = B.village_id
            and A.FLG = 5
            )
            WHERE 1 = 1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
            ORDER BY USE_RATE1 DESC
            )
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

   <e:case value="index_dispatch_village">
    <c:tablequery>
        select
        a.village_id latn_id,
        a.village_name area_desc,
        nvl(b.order_cnt,0) order_cnt,
        nvl(b.exec_cnt,0) exec_cnt,
        nvl(b.succ_cnt,0) succ_cnt,
        nvl(b.use_rate||'','0.00%') use_rate,
        nvl(b.use_rate1,0) use_rate1,
        nvl(b.succ_lv||'','0.00%') succ_lv,
        nvl(b.succ_lv1,0) succ_lv1,
        b.order_num
        from
        (select distinct village_id,village_name from ${gis_user}.tb_gis_village_edit_info c
        where
        c.branch_no in (
         select distinct union_org_code from ${gis_user}.db_cde_grid bb
            where 1=1
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and bb.latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
                    and bb.latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
                </e:if>
            </e:if>
            )
        <e:if condition="${!empty param.name}">
            and c.village_name like '%'||'${param.name}'||'%'
        </e:if>
        )a
        left join
        (SELECT
        BB.latn_name,
        BB.VILLAGE_ID,
        BB.VILLAGE_NAME,
        AA.ORDER_NUM ORDER_CNT,
        AA.EXEC_NUM EXEC_CNT,
        AA.SUCC_NUM SUCC_CNT,
        DECODE(ORDER_NUM, 0, 0, to_char(ROUND(EXEC_NUM / ORDER_NUM, 4) * 100,'FM999999990.00')) || '%' USE_RATE,
        DECODE(ORDER_NUM, 0, 0, ROUND(EXEC_NUM / ORDER_NUM, 4) * 100) USE_RATE1,
        DECODE(USER_NUM, 0, 0, to_char(ROUND(SUCC_NUM / USER_NUM, 4) * 100,'FM999999990.00')) || '%' SUCC_LV,
        DECODE(USER_NUM, 0, 0, ROUND(SUCC_NUM / USER_NUM, 4) * 100) SUCC_LV1,
        1 ORDER_NUM
        FROM (SELECT BB.VILLAGE_ID,
        COUNT(AA.ORDER_ID) ORDER_NUM,
        COUNT(DECODE(EXEC_STAT, 0, AA.ORDER_ID)) EXEC_NUM,
        COUNT(DISTINCT AA.PROD_INST_ID) USER_NUM,
        COUNT(DISTINCT DECODE(SUCC_FLAG, 1, AA.PROD_INST_ID)) SUCC_NUM
        FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M BB,
        EDW.TB_MKT_ORDER_LIST@GSEDW          AA
        WHERE BB.PROD_INST_ID = AA.PROD_INST_ID
        AND BB.ACCT_MONTH = '${param.acct_month}'
        AND AA.ORDER_DATE = TO_CHAR(SYSDATE, 'yyyymmdd')
        GROUP BY BB.VILLAGE_ID) AA,
        ${gis_user}.VIEW_DB_CDE_VILLAGE BB
        WHERE AA.VILLAGE_ID = BB.VILLAGE_ID
        <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.region_id}">
                and bb.latn_Id = '${param.region_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.region_id}">
                and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
                and bb.latn_id = '${param.city_id}'
            </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
            <e:if condition="${!empty param.region_id}">
                and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
            </e:if>
        </e:if>
        <e:if condition="${!empty param.name}">
            and bb.village_name like '%'||'${param.name}'||'%'
        </e:if>)b
        on a.village_id = b.village_id
        ORDER BY succ_lv1 DESC
    </c:tablequery>
  </e:case>

    <e:case value="index_dispatch_village_limited">
        <c:tablequery>
            select
            a.latn_name,
            a.village_id latn_id,
            a.village_name area_desc,
            nvl(b.order_cnt,0) order_cnt,
            nvl(b.exec_cnt,0) exec_cnt,
            nvl(b.succ_cnt,0) succ_cnt,
            nvl(b.use_rate||'','0.00%') use_rate,
            nvl(b.use_rate1,0) use_rate1,
            nvl(b.succ_lv||'','0.00%') succ_lv,
            nvl(b.succ_lv1,0) succ_lv1,
            nvl(b.order_num,0) order_num
            from
            (select distinct latn_id,latn_name,village_id,village_name from ${gis_user}.view_db_cde_village c
            where 1=1
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and c.latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (c.bureau_name = '${param.region_id}' or c.bureau_no = '${param.region_id}')
                    and c.latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (c.bureau_name = '${param.region_id}' or c.bureau_no = '${param.region_id}')
                </e:if>
            </e:if>
            <e:if condition="${!empty param.name}">
                    and c.village_name like '%'||'${param.name}'||'%'
            </e:if>
            )a
            left join
            (
            SELECT
            BB.latn_name,
            BB.VILLAGE_ID,
            BB.VILLAGE_NAME,
            AA.ORDER_NUM ORDER_CNT,
            AA.EXEC_NUM EXEC_CNT,
            AA.SUCC_NUM SUCC_CNT,
            DECODE(ORDER_NUM, 0, 0, to_char(ROUND(EXEC_NUM / ORDER_NUM, 4) * 100,'FM999999990.00')) || '%' USE_RATE,
            DECODE(ORDER_NUM, 0, 0, ROUND(EXEC_NUM / ORDER_NUM, 4) * 100) USE_RATE1,
            DECODE(USER_NUM, 0, 0, to_char(ROUND(SUCC_NUM / USER_NUM, 4) * 100,'FM999999990.00')) || '%' SUCC_LV,
            DECODE(USER_NUM, 0, 0, ROUND(SUCC_NUM / USER_NUM, 4) * 100) SUCC_LV1,
            1 ORDER_NUM
            FROM (SELECT BB.VILLAGE_ID,
            COUNT(AA.ORDER_ID) ORDER_NUM,
            COUNT(DECODE(EXEC_STAT, 0, AA.ORDER_ID)) EXEC_NUM,
            COUNT(DISTINCT AA.PROD_INST_ID) USER_NUM,
            COUNT(DISTINCT DECODE(SUCC_FLAG, 1, AA.PROD_INST_ID)) SUCC_NUM
            FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M BB,
            EDW.TB_MKT_ORDER_LIST@GSEDW          AA
            WHERE BB.PROD_INST_ID = AA.PROD_INST_ID
            AND BB.ACCT_MONTH = '${param.acct_month}'
            AND AA.ORDER_DATE = TO_CHAR(SYSDATE, 'yyyymmdd')
            GROUP BY BB.VILLAGE_ID) AA,
            ${gis_user}.VIEW_DB_CDE_VILLAGE BB
            WHERE AA.VILLAGE_ID = BB.VILLAGE_ID
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and bb.latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
                    and bb.latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
                </e:if>
            </e:if>
            <e:if condition="${!empty param.name}">
                and bb.village_name like '%'||'${param.name}'||'%'
            </e:if>
            ORDER BY succ_lv1 DESC)b
            on a.village_id = b.village_id
            where 1=1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
        </c:tablequery>
    </e:case>

    <e:case value="index_dispatch_village_cnt">
        <e:q4o var="dataObject">
            SELECT
            count(CASE WHEN use_rate1>=40 THEN 1 end)gt_1,
            count(CASE WHEN use_rate1<40 AND use_rate1>=35 THEN 1 END)rag_2,
            count(CASE WHEN use_rate1<35 AND use_rate1>=30 THEN 1 END)rag_3,
            count(CASE WHEN use_rate1<30 AND use_rate1>=25 THEN 1 END)rag_4,
            count(CASE WHEN use_rate1<25 AND use_rate1>=20 THEN 1 END)rag_5,
            count(CASE WHEN use_rate1<20 THEN 1 END)lt_6,
            COUNT(use_rate1) sum_cnt
            FROM (
            SELECT
            nvl(DECODE(ORDER_NUM, 0, 0, ROUND(EXEC_NUM / ORDER_NUM, 4) * 100),0) USE_RATE1
            FROM (SELECT
            BB.VILLAGE_ID,
            COUNT(AA.ORDER_ID) ORDER_NUM,
            COUNT(DECODE(EXEC_STAT, 0, AA.ORDER_ID)) EXEC_NUM
            FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M BB,
            EDW.TB_MKT_ORDER_LIST@GSEDW          AA
            WHERE BB.PROD_INST_ID = AA.PROD_INST_ID
            AND BB.ACCT_MONTH = '${param.acct_month}'
            AND AA.ORDER_DATE = TO_CHAR(SYSDATE, 'yyyymmdd')
            GROUP BY BB.VILLAGE_ID) AA right join
            (select * from ${gis_user}.VIEW_DB_CDE_VILLAGE bb
            where 1=1
            <e:if condition="${param.flag eq '2'}">
                <e:if condition="${!empty param.region_id}">
                    and bb.latn_Id = '${param.region_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '3'}">
                <e:if condition="${!empty param.region_id}">
                    and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
                    and bb.latn_id = '${param.city_id}'
                </e:if>
            </e:if>
            <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
                <e:if condition="${!empty param.region_id}">
                    and (bb.bureau_name = '${param.region_id}' or bb.bureau_no = '${param.region_id}')
                </e:if>
            </e:if>
            <e:if condition="${!empty param.name}">
                and bb.village_name like '%'||'${param.name}'||'%'
            </e:if>
            ) BB
            on AA.VILLAGE_ID = BB.VILLAGE_ID
            ORDER BY USE_RATE1 DESC)
            where 1=1
            <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
                and (${param.condition_str})
            </e:if>
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

  <e:case value="getSubName_a1">
    <e:q4l var="dataList">
      select rownum, a.*
      from (select distinct t.latn_id,
      t.latn_name,
      t.union_org_code,
      t.branch_no,
      t.branch_name,
      t.branch_type,
      case
      when t.branch_type = 'a1' then
      '城市'
      when t.branch_type = 'b1' then
      '农村'
      end branch_type_char,
      t.region_order_num,
      t.zoom,
      t.branch_show,
      t.grid_show,
      t.branch_hlzoom

      from ${gis_user}.db_cde_grid t
      where
      <e:if condition="${param.city_id !=''&& param.city_id !=null}">
        t.latn_id = '${param.city_id}' and
      </e:if>
      <e:if condition="${param.id !=''&& param.id !=null}">
        t.bureau_no = ${param.id} and
      </e:if>
      <e:if condition="${param.sub_id !=''&& param.sub_id !=null}">
        t.union_org_code = ${param.sub_id} and
      </e:if>
      t.branch_type = 'a1'
      order by t.latn_id,branch_show desc,t.region_order_num asc
      ) a
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

    <e:case value="getSubName">
        <e:q4l var="dataList">
            select rownum, a.*
            from (select distinct t.latn_id,
            t.latn_name,
            t.union_org_code,
            t.branch_no,
            t.branch_name,
            t.branch_type,
            case
            when t.branch_type = 'a1' then
            '城市'
            when t.branch_type = 'b1' then
            '农村'
            end branch_type_char,
            t.region_order_num,
            t.zoom,
            t.branch_show,
            t.grid_show,
            t.branch_hlzoom

            from ${gis_user}.db_cde_grid t
            where
            <e:if condition="${param.city_id !=''&& param.city_id !=null}">
                t.latn_id = '${param.city_id}' and
            </e:if>
            <e:if condition="${param.id !=''&& param.id !=null}">
                t.bureau_no = ${param.id} and
            </e:if>
            <e:if condition="${param.sub_id !=''&& param.sub_id !=null}">
                t.union_org_code = ${param.sub_id} and
            </e:if>
            1=1
            order by t.latn_id,branch_show desc,t.region_order_num asc
            ) a
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

  <e:case value="sub_list">
    <e:q4l var="dataList">
        select distinct t.latn_id,
        t.latn_name,
        t.bureau_no,
        t.bureau_name,
        t.union_org_code,
        t.branch_no,
        t.branch_name
        from ${gis_user}.db_cde_grid t
        where 1=1
        <e:if condition="${param.city_id !=''&& param.city_id !=null}">
            and t.latn_id = '${param.city_id}'
        </e:if>
        <e:if condition="${param.id !=''&& param.id !=null}">
            and t.bureau_no = ${param.id}
        </e:if>
        <e:if condition="${param.sub_id !=''&& param.sub_id !=null}">
            and t.union_org_code = ${param.sub_id}
        </e:if>
        and t.branch_type in ('a1')
        order by t.latn_id
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="grid_list">
    <e:q4l var="dataList">
      select rownum,a.* from (
      SELECT l.* from
      (select
        distinct
      d.latn_id,
      d.latn_name,
      d.bureau_no,
      d.bureau_name,
      d.union_org_code,
      d.branch_name,
      d.grid_id,
      d.grid_union_org_code,
      d.grid_name,
      s.station_id,
      d.grid_show,
      d.zoom,
      d.grid_zoom
      from
      ${gis_user}.DB_CDE_GRID d,${gis_user}.SPC_BRANCH_STATION s
      where d.branch_type in ('a1')
        and d.grid_union_org_code is not null
        and d.grid_union_org_code=s.station_no
        and d.grid_status =1
      <e:if condition="${!empty param.city_id}">
        and d.latn_id = ${param.city_id}
      </e:if>
      <e:if condition="${!empty param.bureau_no}">
        and d.bureau_no = ${param.bureau_no}
      </e:if>
      <e:if condition="${!empty param.grid_id}">
        and d.grid_id = ${param.grid_id}
      </e:if>
      ) l
      order by grid_show desc,GRID_UNION_ORG_CODE
      ) a
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="grid_list_for_village_cell">
    <e:q4l var="dataList">
        SELECT DISTINCT b.LATN_ID,
        b.LATN_NAME,
        b.BUREAU_NO,
        b.BUREAU_NAME,
        B.UNION_ORG_CODE,
        B.BRANCH_NAME,
        B.GRID_ID,
        B.GRID_UNION_ORG_CODE,
        B.GRID_NAME,
        S.STATION_ID,
        B.GRID_SHOW,
        B.ZOOM,
        B.GRID_ZOOM
        FROM edw.vw_tb_cde_village@gsedw A,
        ${gis_user}.DB_CDE_GRID B,
        ${gis_user}.SPC_BRANCH_STATION S
        WHERE 1=1
        AND A.GRID_ID = B.GRID_ID
        AND B.GRID_UNION_ORG_CODE = S.STATION_NO
        <e:if condition="${!empty param.village_cell_id}">
            and a.VILLAGE_ID = ${param.village_cell_id}
        </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="village_list">
      <e:q4l var="dataList">
          select
          LATN_ID,
          LATN_NAME,
          bureau_no,
          bureau_name,
          UNION_ORG_CODE,
          BRANCH_NAME,
          report_to_id STATION_ID,
          GRID_NAME,
          GRID_UNION_ORG_CODE,
          VILLAGE_ID,
          VILLAGE_NAME
          FROM
          ${gis_user}.view_db_cde_village
          WHERE 1=1
          <e:if condition="${!empty param.city_id}">
              and latn_id= ${param.city_id}
          </e:if>
          <e:if condition="${!empty param.village_id}">
              and VILLAGE_ID = ${param.village_id}
          </e:if>
      </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getSubList">
      <e:q4l var="dataList">
          select
          a.union_org_code,
          a.color,
          a.bureau_name,
          a.branch_no,
          g.grid_id_cnt,
          g.grid_show,
          case when a.branch_type = 'a1' then '城市' when a.branch_type = 'b1' then '农村' end branch_type,
          g.mobile_mon_cum_new,
          g.mobile_mon_cum_new_last,
          g.brd_mon_cum_new,
          g.brd_mon_cum_new_last,
          g.itv_mon_new_install_serv,
          g.itv_serv_cur_mon_new_last,
          m.cur_mon_bil_serv,
          m.cur_mon_brd_serv,
          a.branch_hlzoom
          from (
          select distinct union_org_code, color, t.bureau_name, t.branch_no,t.branch_type,t.branch_hlzoom
          from ${gis_user}.db_cde_grid t
          where latn_id = '${param.city_id}'
          <e:if condition="${!empty param.city_id}">
              and latn_id = '${param.city_id}'
          </e:if>
          <e:if condition="${!empty param.bureau_no}">
              and bureau_no = '${param.bureau_no}'
          </e:if>
          and branch_type in ('a1', 'b1')) a,
          ${gis_user}.tb_dw_gis_zhi_ju_income_d g,
          ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m
          where a.branch_no = g.latn_id
          and m.latn_id = g.latn_id
          and g.stat_date = '${param.yesterday}'
          and g.flag = 4
          and m.statis_mon = '${param.last_month}'
          and m.flag = '4'
      </e:q4l>${e:java2json(dataList.list)}
  </e:case>

    <e:case value="getBuildInsideVillage">
        <e:q4l var="dataList">
            SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id = '${param.village_id}'
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getBuildUsedInArea">
        <e:q4l var="dataList">
            SELECT a.segm_id FROM (
                SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE 1=1 and segm_id IN (${param.build_ids})
            ) a,
            (SELECT resid FROM sde.map_addr_segm_${param.latn_id}
                WHERE 1=1
            <e:if condition="${!empty param.bureau_no}">
                AND bureau_no = '${param.bureau_no}'
            </e:if>
            )b
            WHERE segm_id = b.resid
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="village_cell_list_province">
        <e:q4l var="dataList">
            select * from (
            SELECT *
            FROM (SELECT A.LATN_ID,
            A.LATN_NAME,
            A.VILLAGE_ID,
            A.VILLAGE_NAME,
            ROUND(DECODE(NVL(T.HOUSEHOLD_NUM, 0),
            0,
            0,
            T.H_USE_CNT / T.HOUSEHOLD_NUM),
            4) * 100 MARKT_LV_cnt,
            TO_CHAR(ROUND(DECODE(NVL(T.HOUSEHOLD_NUM, 0),
            0,
            0,
            T.H_USE_CNT / T.HOUSEHOLD_NUM),
            4) * 100,
            'FM9999999990.00') || '%' MARKT_LV,
            0.00 TS_MONTH_LV_cnt,
            '0.00%' TS_MONTH_LV,
            COUNT(1) OVER() C_NUM
            FROM ${gis_user}.TB_GIS_COUNT_INFO_D T,
            (SELECT A.LATN_ID, A.LATN_NAME, A.VILLAGE_ID, A.VILLAGE_NAME
            FROM edw.vw_tb_cde_village@gsedw A
            <e:if condition="${!empty param.name}">
                where village_Name LIKE '%${param.name}%'
            </e:if>
            GROUP BY A.LATN_ID,
            A.LATN_NAME,
            A.VILLAGE_ID,
            A.VILLAGE_NAME) A
            WHERE T.LATN_ID = A.VILLAGE_ID
            and t.acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
            AND FLG = 5)
            ORDER BY MARKT_LV DESC)
            where rownum <= 500
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="village_cell_list_city">
        <e:q4l var="dataList">
            select * from (
            SELECT *
            FROM (SELECT A.LATN_ID,
            A.LATN_NAME,
            A.VILLAGE_ID,
            A.VILLAGE_NAME,
            ROUND(DECODE(NVL(T.HOUSEHOLD_NUM, 0),
            0,
            0,
            T.H_USE_CNT / T.HOUSEHOLD_NUM),
            4) * 100 MARKT_LV_cnt,
            TO_CHAR(ROUND(DECODE(NVL(T.HOUSEHOLD_NUM, 0),
            0,
            0,
            T.H_USE_CNT / T.HOUSEHOLD_NUM),
            4) * 100,
            'FM9999999990.00') || '%' MARKT_LV,
            0.00 TS_MONTH_LV_cnt,
            '0.00%' TS_MONTH_LV,
            COUNT(1) OVER() C_NUM
            FROM ${gis_user}.TB_GIS_COUNT_INFO_D T,
            (SELECT A.LATN_ID, A.LATN_NAME, A.VILLAGE_ID, A.VILLAGE_NAME
            FROM edw.vw_tb_cde_village@gsedw A
            <e:if condition="${!empty param.name}">
                where village_Name LIKE '%${param.name}%'
            </e:if>
            GROUP BY A.LATN_ID,
            A.LATN_NAME,
            A.VILLAGE_ID,
            A.VILLAGE_NAME) A
            WHERE T.LATN_ID = A.VILLAGE_ID
            and t.acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
            AND FLG = 5
            and a.latn_id = '${param.region_id}'
            )
            ORDER BY MARKT_LV DESC)
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="village_cell_cnt">
        <e:q4o var="dataObject">
            SELECT count(1) SUM_CNT FROM  edw.vw_tb_cde_village@gsedw WHERE village_Name LIKE '%${param.name}%'
        </e:q4o>${e:java2json(dataObject)}
    </e:case>
</e:switch>