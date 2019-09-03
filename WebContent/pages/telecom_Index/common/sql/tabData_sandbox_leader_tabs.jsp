<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:description>领导层大报表</e:description>
<e:set var="sql_part_tab_name1">
    <e:description>
        2018.9.11 表名更换 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 改为 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY
        2018.9.20 表名恢复 从 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY 更换为 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW
        2019.3.27 表名 从 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 变成 ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
    </e:description>
    ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
</e:set>
<e:set var="sql_part_tab_name2">
    ${gis_user}.VIEW_GSCH_MKT_ORDER_STAT_DAY
</e:set>
<e:set var="sql_part_yx_column">
    nvl(sum(nvl(T.ORDER_CNT,0)),0) MBYH_CNT,

    nvl(sum(NVL(T.EXEC_CNT,0)  -  nvl(T1.EXEC_CNT,0)),0) ZX_CNT,

    DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),
    '0',
    '0.00%',
    TO_CHAR(ROUND(sum(NVL(T.EXEC_CNT  -  T1.EXEC_CNT,0)) /
    sum(NVL(T.ORDER_CNT,0)),
    4) * 100,
    'FM999999990.00') || '%') ZX_RATE,

    nvl(sum(NVL(T.SUCC_CNT  -  T1.SUCC_CNT,0)),0) CGYH_CNT,

    DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),
    '0',
    '0.00%',
    TO_CHAR(ROUND(sum(NVL(T.SUCC_CNT  -  T1.SUCC_CNT,0)) /
    sum(NVL(T.ORDER_CNT,0)),
    4) * 100,
    'FM999999990.00') || '%') CG_RATE,

    nvl(sum(NVL(T.EXEC_CNT,0)),0)  ZX_CNT_MONTH,

    DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),
    '0',
    '0.00%',
    TO_CHAR(ROUND(sum(NVL(T.EXEC_CNT,0)) /
    sum(NVL(T.ORDER_CNT,0)),
    4) * 100,
    'FM999999990.00') || '%') ZX_RATE_MONTH,

    nvl(sum(NVL(T.SUCC_CNT,0)),0)  CGYH_CNT_MONTH,

    DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),
    '0',
    '0.00%',
    TO_CHAR(ROUND(sum(NVL(T.SUCC_CNT,0)) /
    sum(NVL(T.ORDER_CNT,0)),
    4) * 100,
    'FM999999990.00') || '%') CG_RATE_MONTH
</e:set>
<e:switch value="${param.eaction}">
  <e:description>宽带家庭渗透率 begin</e:description>
  <e:case value="broad_home_list">
      <e:if condition="${param.query_flag eq '5'}" var="is_village">
          <e:q4l var="broad_list">
              SELECT * FROM
              (SELECT T.*,
              <e:if condition="${param.query_flag ne '1' }">
                  <e:if condition="${param.query_sort eq '0' }">
                      row_number() over(ORDER BY BROAD_PENETRANCE_SORT DESC) row_num
                  </e:if>
                  <e:if condition="${param.query_sort eq '1' }">
                      row_number() over(ORDER BY BROAD_PENETRANCE_SORT ASC) row_num
                  </e:if>
              </e:if>
              FROM (
              SELECT
              ' '  AREA_DESC,
              <e:if condition="${ empty param.region_id }" var="region">
                  '全省' AREA_DESC1,
              </e:if>
              <e:else condition="${region }">
                  <e:switch value="${param.flag}">
                      <e:case value="1">
                          '全省' AREA_DESC1,
                      </e:case>
                      <e:case value="2">
                          '全市' AREA_DESC1,
                      </e:case>
                      <e:case value="3">
                          '全县' AREA_DESC1,
                      </e:case>
                      <e:case value="4">
                          '全支局' AREA_DESC1,
                      </e:case>
                      <e:case value="5">
                          '全网格' AREA_DESC1,
                      </e:case>
                  </e:switch>
              </e:else>
              '0' ORD,
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,
              DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,
              DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,
              NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
              NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
              nvl(A.gov_zhu_hu_count,0) gov_zhu_hu_count,
              nvl(A.gov_h_use_cnt,0) gov_h_use_cnt,
              0 C_NUM
              FROM ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
              where 1=1
              <e:if condition="${region }">
                  and A.FLG = '0'
              </e:if>
              <e:else condition="${region }">
                  <e:switch value="${param.flag }">
                      <e:case value="2">
                          and A.LATN_ID = '${param.region_id }'
                      </e:case>
                      <e:case value="3">
                          and A.LATN_ID IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                          )
                      </e:case>
                  </e:switch>
              </e:else>
              AND BRANCH_TYPE = 'a1'
              <e:if condition="${!empty param.data_monitor}" var="empty_data_monitor">
                  and DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0),
                  0,
                  0,
                  ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT,
                  4) * 100) > 100
                  and A.ACCT_DAY = (SELECT to_char(last_day(to_date('${param.beginDate}','yyyymm')),'yyyymmdd') FROM dual)
              </e:if>
              <e:else condition="${empty_data_monitor}">
                  AND A.ACCT_DAY = '${param.beginDate}'
              </e:else>
              UNION ALL
              SELECT T.*, COUNT(1) OVER() C_NUM FROM (
              SELECT
              DISTINCT
              <e:switch value="${param.query_flag }">
                  <e:case value="1">
                      B.AREA_DESC,
                      B.ORD,
                  </e:case>
                  <e:case value="2">
                      B.BUREAU_NAME AREA_DESC,
                      B.BUREAU_NO ORD,
                  </e:case>
                  <e:case value="3">
                      B.BRANCH_NAME AREA_DESC,
                      B.UNION_ORG_CODE ORD,
                  </e:case>
                  <e:case value="4">
                      B.GRID_NAME AREA_DESC,
                      B.GRID_ID ORD,
                  </e:case>
                  <e:case value="5">
                      B.VILLAGE_NAME AREA_DESC,
                      dd.latn_name AREA_DESC1,
                      B.VILLAGE_ID ORD,
                  </e:case>
              </e:switch>
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,
              DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,
              DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,
              NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
              NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
              nvl(A.gov_zhu_hu_count,0) gov_zhu_hu_count,
              nvl(A.gov_h_use_cnt,0) gov_h_use_cnt
              FROM ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
              <e:if condition="${region }">
                  <e:switch value="${param.query_flag }">
                      <e:case value="1">
                          right OUTER JOIN EASY_DATA.CMCODE_AREA B
                          ON A.LATN_ID = B.AREA_NO
                      </e:case>
                      <e:case value="2">
                          right OUTER JOIN (select * from ${gis_user}.DB_CDE_GRID WHERE BRANCH_TYPE = 'a1') B
                          ON A.LATN_ID = B.BUREAU_NO
                      </e:case>
                      <e:case value="3">
                          right OUTER JOIN (SELECT * FROM ${gis_user}.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and BRANCH_TYPE = 'a1') B
                          ON (A.LATN_ID = B.UNION_ORG_CODE)
                      </e:case>
                      <e:case value="4">
                          RIGHT OUTER JOIN (SELECT * FROM ${gis_user}.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and GRID_UNION_ORG_CODE != -1 and grid_status = 1 and BRANCH_TYPE = 'a1') B
                          ON (A.LATN_ID = B.GRID_ID)
                      </e:case>
                      <e:case value="5">
                          right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                          ON (A.LATN_ID = B.VILLAGE_ID)
                          right JOIN ${gis_user}.view_db_cde_village dd
                          ON(b.village_id = dd.village_id)
                      </e:case>
                  </e:switch>
                  WHERE
                  A.FLG = '${param.query_flag }'
                  AND A.BRANCH_TYPE = 'a1'
                  <e:if condition="${!empty param.data_monitor}" var="empty_data_monitor">
                      and DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0),
                      0,
                      0,
                      ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT,
                      4) * 100) > 100
                      and A.ACCT_DAY = (SELECT to_char(last_day(to_date('${param.beginDate}','yyyymm')),'yyyymmdd') FROM dual)
                  </e:if>
                  <e:else condition="${empty_data_monitor}">
                      AND A.ACCT_DAY = '${param.beginDate}'
                  </e:else>
                  <e:if condition="${!empty data_monitor}">
                      and DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0),
                      0,
                      0,
                      ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT,
                      4) * 100) > 100
                  </e:if>
              </e:if>
              <e:else condition="${region }">
                  <e:switch value="${param.flag }">
                      <e:case value="1">
                          where 1=1
                      </e:case>
                      <e:case value="2">
                          <e:switch value="${param.query_flag }">
                              <e:case value="2">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.BUREAU_NO
                                  WHERE B.LATN_ID = '${param.region_id }'
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="3">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.UNION_ORG_CODE
                                  WHERE B.LATN_ID = '${param.region_id }'
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="4">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.GRID_ID
                                  WHERE B.LATN_ID = '${param.region_id }'
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  and b.grid_union_org_code != -1 and b.grid_status = 1
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="5">
                                  right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  ON A.LATN_ID = B.VILLAGE_ID
                                  LEFT JOIN ${gis_user}.view_db_cde_village dd
                                  ON (b.village_id = dd.village_id)
                                  WHERE A.LATN_ID IN (
                                  SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                                  ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                                  and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                                  )
                                  WHERE C.LATN_ID = '${param.region_id }'
                                  )
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                          </e:switch>
                      </e:case>
                      <e:case value="3">
                          <e:switch value="${param.query_flag }">
                              <e:case value="3">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.UNION_ORG_CODE
                                  WHERE B.BUREAU_NO IN (
                                  SELECT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                  WHERE BUREAU_NAME = '${param.region_id }'
                                  and latn_id = '${param.city_id}'
                                  )
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="4">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.GRID_ID
                                  WHERE B.BUREAU_NO IN (
                                  SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                  WHERE BUREAU_NAME = '${param.region_id }'
                                  and latn_id = '${param.city_id}'
                                  )
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  and b.grid_union_org_code != -1 and b.grid_status = 1
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="5">
                                  right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  ON A.LATN_ID = B.VILLAGE_ID
                                  RIGHT OUTER JOIN ${gis_user}.view_db_cde_village dd
                                  ON a.latn_id = dd.village_id
                                  WHERE a.LATN_ID IN (
                                  SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                                  ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                                  and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                                  )
                                  WHERE C.BUREAU_NO IN (
                                  SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                  WHERE BUREAU_NAME = '${param.region_id }'
                                  and latn_id = '${param.city_id}'
                                  )
                                  )
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                          </e:switch>
                      </e:case>
                  </e:switch>
                  <e:if condition="${!empty param.data_monitor}" var="empty_data_monitor">
                      and A.ACCT_DAY = (SELECT to_char(last_day(to_date('${param.beginDate}','yyyymm')),'yyyymmdd') FROM dual)
                      and DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0),
                      0,
                      0,
                      ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT,
                      4) * 100) > 100
                  </e:if>
                  <e:else condition="${empty_data_monitor}">
                      AND A.ACCT_DAY = '${param.beginDate}'
                  </e:else>
              </e:else>

              ) T
              <e:if condition="${param.query_flag eq '1' }">
                  ORDER BY ORD
              </e:if>
              ) T
              )
              WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
          </e:q4l>
      </e:if>
      <e:else condition="${is_village}">
          <e:q4l var="broad_list">
              SELECT * FROM
              (SELECT T.*, ROWNUM ROW_NUM FROM (
              SELECT
              <e:if condition="${ empty param.region_id }" var="region">
                  '全省' AREA_DESC,
              </e:if>
              <e:else condition="${region }">
                  <e:switch value="${param.flag}">
                      <e:case value="1">
                          '全省' AREA_DESC,
                      </e:case>
                      <e:case value="2">
                          '全市' AREA_DESC,
                      </e:case>
                      <e:case value="3">
                          '全县' AREA_DESC,
                      </e:case>
                      <e:case value="4">
                          '全支局' AREA_DESC,
                      </e:case>
                      <e:case value="5">
                          '全网格' AREA_DESC,
                      </e:case>
                  </e:switch>
              </e:else>
              '0' ORD,
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,
              DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,
              DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,
              NVL(A.VILLAGE_CNT, 0) VILLAGE_CNT,
              NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
              NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
              NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) HIGH_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') HIGH_FILTER_RATE,
              NVL(A.MID_FILTER_VILLAGE_CNT, 0) MID_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.MID_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') MID_FILTER_RATE,
              NVL(A.LOW_FILTER_VILLAGE_CNT, 0) LOW_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_FILTER_RATE,
              NVL(A.LOW_10_FILTER_VILLAGE_CNT, 0) LOW_10_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_10_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_10_FILTER_RATE,
              0 C_NUM
              FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
              <e:if condition="${region }">
                  WHERE A.FLG = '0'
              </e:if>
              <e:else condition="${region }">
                  <e:switch value="${param.flag }">
                      <e:case value="2">
                          WHERE A.LATN_ID = '${param.region_id }'
                      </e:case>
                      <e:case value="3">
                          WHERE A.LATN_ID IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                          )
                      </e:case>
                  </e:switch>
              </e:else>
              AND BRANCH_TYPE = 'a1'
              AND A.ACCT_DAY = '${param.beginDate}'
              UNION ALL
              SELECT T.*, COUNT(1) OVER() C_NUM FROM (
              SELECT
              DISTINCT
              <e:switch value="${param.query_flag }">
                  <e:case value="1">
                      B.AREA_DESC,
                      B.ORD,
                  </e:case>
                  <e:case value="2">
                      B.BUREAU_NAME AREA_DESC,
                      B.BUREAU_NO ORD,
                  </e:case>
                  <e:case value="3">
                      B.BRANCH_NAME AREA_DESC,
                      B.UNION_ORG_CODE ORD,
                  </e:case>
                  <e:case value="4">
                      B.GRID_NAME AREA_DESC,
                      B.GRID_ID ORD,
                  </e:case>
                  <e:case value="5">
                      B.VILLAGE_NAME AREA_DESC,
                      B.VILLAGE_ID ORD,
                  </e:case>
              </e:switch>
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,
              DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,
              DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,
              DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,
              NVL(A.VILLAGE_CNT,  0) VILLAGE_CNT,
              NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
              NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,
              NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) HIGH_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') HIGH_FILTER_RATE,
              NVL(A.MID_FILTER_VILLAGE_CNT, 0) MID_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.MID_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') MID_FILTER_RATE,
              NVL(A.LOW_FILTER_VILLAGE_CNT, '0') LOW_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_FILTER_RATE,
              NVL(A.LOW_10_FILTER_VILLAGE_CNT, '0') LOW_10_FILTER_VILLAGE_CNT,
              DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_10_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_10_FILTER_RATE
              FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
              <e:if condition="${region }">
                  <e:switch value="${param.query_flag }">
                      <e:case value="1">
                          right OUTER JOIN EASY_DATA.CMCODE_AREA B
                          ON A.LATN_ID = B.AREA_NO
                      </e:case>
                      <e:case value="2">
                          right OUTER JOIN (select * from ${gis_user}.DB_CDE_GRID WHERE BRANCH_TYPE = 'a1') B
                          ON A.LATN_ID = B.BUREAU_NO
                      </e:case>
                      <e:case value="3">
                          right OUTER JOIN (SELECT * FROM ${gis_user}.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and BRANCH_TYPE = 'a1') B
                          ON (A.LATN_ID = B.UNION_ORG_CODE)
                      </e:case>
                      <e:case value="4">
                          RIGHT OUTER JOIN (SELECT * FROM ${gis_user}.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and GRID_UNION_ORG_CODE != -1 and grid_status = 1 and BRANCH_TYPE = 'a1') B
                          ON (A.LATN_ID = B.GRID_ID)
                      </e:case>
                      <e:case value="5">
                          right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                          ON (A.LATN_ID = B.VILLAGE_ID)
                      </e:case>
                  </e:switch>
                  WHERE
                  A.FLG = '${param.query_flag }'
                  AND A.BRANCH_TYPE = 'a1'
                  AND A.ACCT_DAY = '${param.beginDate}'
              </e:if>
              <e:else condition="${region }">
                  <e:switch value="${param.flag }">
                      <e:case value="2">
                          <e:switch value="${param.query_flag }">
                              <e:case value="2">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.BUREAU_NO
                                  WHERE B.LATN_ID = '${param.region_id }'
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="3">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.UNION_ORG_CODE
                                  WHERE B.LATN_ID = '${param.region_id }'
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="4">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.GRID_ID
                                  WHERE B.LATN_ID = '${param.region_id }'
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  and b.grid_union_org_code != -1 and b.grid_status = 1
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="5">
                                  right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  ON A.LATN_ID = B.VILLAGE_ID
                                  WHERE LATN_ID IN (
                                  SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                                  ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                                  and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                                  )
                                  WHERE C.LATN_ID = '${param.region_id }'
                                  )
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                          </e:switch>
                      </e:case>
                      <e:case value="3">
                          <e:switch value="${param.query_flag }">
                              <e:case value="3">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.UNION_ORG_CODE
                                  WHERE B.BUREAU_NO IN (
                                  SELECT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                  WHERE BUREAU_NAME = '${param.region_id }'
                                  and latn_id = '${param.city_id}'
                                  )
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="4">
                                  RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                  ON A.LATN_ID = B.GRID_ID
                                  WHERE B.BUREAU_NO IN (
                                  SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                  WHERE BUREAU_NAME = '${param.region_id }'
                                  and latn_id = '${param.city_id}'
                                  )
                                  AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                  and b.grid_union_org_code != -1 and b.grid_status = 1
                                  AND B.BRANCH_TYPE = 'a1'
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                              <e:case value="5">
                                  right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  ON A.LATN_ID = B.VILLAGE_ID
                                  WHERE LATN_ID IN (
                                  SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                  right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                                  ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                                  and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                                  )
                                  WHERE C.BUREAU_NO IN (
                                  SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                  WHERE BUREAU_NAME = '${param.region_id }'
                                  and latn_id = '${param.city_id}'
                                  )
                                  )
                                  AND A.BRANCH_TYPE = 'a1'
                              </e:case>
                          </e:switch>
                      </e:case>
                  </e:switch>
                   AND A.ACCT_DAY = '${param.beginDate}'
              </e:else>
              ) T
              <e:if condition="${param.query_flag eq '1' }">
                  ORDER BY ORD
              </e:if>
              ) T
              )
              WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
          </e:q4l>
      </e:else>
    ${e: java2json(broad_list.list) }
  </e:case>
  <e:description>宽带家庭渗透率 end</e:description>

  <e:description>光网覆盖情况 begin</e:description>
  <e:case value="fb_list">
    <e:q4l var="fb_list">
    SELECT * FROM
    (SELECT T.*, ROWNUM ROW_NUM FROM (
    SELECT
    <e:if condition="${ empty param.region_id }" var="region">
    '全省' AREA_DESC,
    </e:if>
    <e:else condition="${region }">
        <e:switch value="${param.flag}">
            <e:case value="1">
            '全省' AREA_DESC,
            </e:case>
            <e:case value="2">
            '全市' AREA_DESC,
            </e:case>
            <e:case value="3">
            '全县' AREA_DESC,
            </e:case>
            <e:case value="4">
            '全支局' AREA_DESC,
            </e:case>
            <e:case value="5">
            '全网格' AREA_DESC,
            </e:case>
        </e:switch>
    </e:else>
        '0' ORD,
        NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
        <e:if condition="${param.query_flag ne '5'}">
            NVL(A.VILLAGE_CNT, 0)  VILLAGE_CNT,
        </e:if>
        DECODE(NVL(A.LY_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND((NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT, 4) * 100, 'FM999999990.00') || '%') FB_RATE,
        DECODE(NVL(A.LY_CNT, 0), 0, 0, (NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT ) FB_RATE_SORT,
        NVL(A.LY_CNT, 0) FB_BUILD_VILLAGE,
        NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0) FB_BUILD_VILLAGE_RATE,
        NVL(A.NO_RES_ARRIVE_CNT, 0) FB_N_BUILD_VILLAGE,
        NVL(A.OBD_CNT, 0) FB_N_BUILD_VILLAGE_RATE,
         0 C_NUM
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
      WHERE A.FLG = '0'
      </e:if>
      <e:else condition="${region }">
           <e:switch value="${param.flag }">
               <e:case value="2">
               WHERE A.LATN_ID = '${param.region_id }'
               </e:case>
               <e:case value="3">
               WHERE A.LATN_ID IN (
               SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
               WHERE BUREAU_NAME = '${param.region_id }'
                   and latn_id = '${param.city_id}'
               )
               </e:case>
           </e:switch>
      </e:else>
      AND BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      UNION ALL
      SELECT T.*, COUNT(1) OVER() C_NUM FROM (
      SELECT
      DISTINCT
      <e:switch value="${param.query_flag }">
          <e:case value="1">
          B.AREA_DESC,
          B.ORD,
          </e:case>
          <e:case value="2">
          B.BUREAU_NAME AREA_DESC,
          B.BUREAU_NO ORD,
          </e:case>
          <e:case value="3">
          B.BRANCH_NAME AREA_DESC,
          B.UNION_ORG_CODE ORD,
          </e:case>
          <e:case value="4">
          B.GRID_NAME AREA_DESC,
          B.GRID_ID ORD,
          </e:case>
          <e:case value="5">
          B.VILLAGE_NAME AREA_DESC,
          B.VILLAGE_ID ORD,
          </e:case>
      </e:switch>
        NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
        <e:if condition="${param.query_flag ne '5'}">
        NVL(A.VILLAGE_CNT, 0)  VILLAGE_CNT,
        </e:if>
        DECODE(NVL(A.LY_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND((NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT, 4) * 100, 'FM999999990.00') || '%') FB_RATE,
        DECODE(NVL(A.LY_CNT, 0), 0, 0, (NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT ) FB_RATE_SORT,
        NVL(A.LY_CNT, 0) FB_BUILD_VILLAGE,
        NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0) FB_BUILD_VILLAGE_RATE,
        NVL(A.NO_RES_ARRIVE_CNT, 0) FB_N_BUILD_VILLAGE,
        NVL(A.OBD_CNT, 0) FB_N_BUILD_VILLAGE_RATE
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
           <e:switch value="${param.query_flag }">
               <e:case value="1">
               right OUTER JOIN EASY_DATA.CMCODE_AREA B
               ON A.LATN_ID = B.AREA_NO
               </e:case>
               <e:case value="2">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON A.LATN_ID = B.BUREAU_NO
               </e:case>
               <e:case value="3">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="4">
               RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL
                   and b.grid_union_org_code != -1 and b.grid_status = 1
                   AND B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="5">
               right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
               ON A.LATN_ID = B.VILLAGE_ID
               </e:case>
           </e:switch>
      WHERE
      A.FLG = '${param.query_flag }'
      AND A.BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      </e:if>
      <e:else condition="${region }">
          <e:switch value="${param.flag }">
               <e:case value="2">
                  <e:switch value="${param.query_flag }">
                      <e:case value="2">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.BUREAU_NO
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                          and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                          and C.BRANCH_TYPE = 'a1')
                      WHERE C.LATN_ID = '${param.region_id }'
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
               <e:case value="3">
                  <e:switch value="${param.query_flag }">
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.BUREAU_NO IN (
                          SELECT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                          and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                          and C.BRANCH_TYPE = 'a1')
                      WHERE C.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
          </e:switch>
           AND A.ACCT_DAY = '${param.beginDate}'
      </e:else>
      <e:if condition="${param.query_flag ne '1' }">
          <e:if condition="${param.query_sort eq '0' }">
          ORDER BY FB_RATE_SORT DESC
          </e:if>
          <e:if condition="${param.query_sort eq '1' }">
          ORDER BY FB_RATE_SORT ASC
          </e:if>
      </e:if>
      ) T
      <e:if condition="${param.query_flag eq '1' }">
      ORDER BY ORD
      </e:if>
      )T
      )
        WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
    </e:q4l>${e: java2json(fb_list.list) }
  </e:case>
  <e:description>光网覆盖情况 end</e:description>


  <e:description>光网实占情况 begin</e:description>
  <e:case value="reticle_use_list">
    <e:q4l var="reticle_list">
    SELECT * FROM
    (SELECT T.*, ROWNUM ROW_NUM FROM (
    SELECT
    <e:if condition="${ empty param.region_id }" var="region">
    '全省' AREA_DESC,
    </e:if>
    <e:else condition="${region }">
        <e:switch value="${param.flag}">
            <e:case value="1">
            '全省' AREA_DESC,
            </e:case>
            <e:case value="2">
            '全市' AREA_DESC,
            </e:case>
            <e:case value="3">
            '全县' AREA_DESC,
            </e:case>
            <e:case value="4">
            '全支局' AREA_DESC,
            </e:case>
            <e:case value="5">
            '全网格' AREA_DESC,
            </e:case>
        </e:switch>
    </e:else>
        '0' ORD,
	     NVL(A.GZ_ZHU_HU_COUNT,0) GZZH_CNT,
		 NVL(A.PORT_ID_CNT,0) PORT_CNT,
		 NVL(A.USE_PORT_CNT,0) USE_PORT_CNT,
		 DECODE(NVL(A.PORT_ID_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT, 4) * 100, 'FM999999990.00') || '%') PORT_RATE,
		 DECODE(NVL(A.PORT_ID_CNT, 0), 0, 0, NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT) PORT_RATE_SORT,
		 NVL(A.OBD_CNT,0) OBD_CNT,
		 NVL(A.ZERO_OBD_CNT_1,0) ZERO_OBD_CNT,
		 DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.ZERO_OBD_CNT_1, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ZERO_OBD_RATE,
		 NVL(A.FIRST_OBD_CNT,0) ONE_OBD_CNT,
		 DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.FIRST_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ONE_OBD_RATE,
		 NVL(A.LOW_OBD_CNT,0) LOW_OBD_CNT,
		 DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_OBD_RATE,
	      0 C_NUM
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
      WHERE A.FLG = '0'
      </e:if>
      <e:else condition="${region }">
           <e:switch value="${param.flag }">
               <e:case value="2">
               WHERE A.LATN_ID = '${param.region_id }'
               </e:case>
               <e:case value="3">
               WHERE A.LATN_ID IN (
               SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
               WHERE BUREAU_NAME = '${param.region_id }'
                   and latn_id = '${param.city_id}'
               )
               </e:case>
           </e:switch>
      </e:else>
      AND BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      UNION ALL
      SELECT T.*, COUNT(1) OVER() C_NUM FROM (
      SELECT
      DISTINCT
      <e:switch value="${param.query_flag }">
          <e:case value="1">
          B.AREA_DESC,
          B.ORD,
          </e:case>
          <e:case value="2">
          B.BUREAU_NAME AREA_DESC,
          B.BUREAU_NO ORD,
          </e:case>
          <e:case value="3">
          B.BRANCH_NAME AREA_DESC,
          B.UNION_ORG_CODE ORD,
          </e:case>
          <e:case value="4">
          B.GRID_NAME AREA_DESC,
          B.GRID_ID ORD,
          </e:case>
          <e:case value="5">
          B.VILLAGE_NAME AREA_DESC,
          B.VILLAGE_ID ORD,
          </e:case>
      </e:switch>
            NVL(A.GZ_ZHU_HU_COUNT,0) GZZH_CNT,
		    NVL(A.PORT_ID_CNT,0) PORT_CNT,
		    NVL(A.USE_PORT_CNT,0) USE_PORT_CNT,
		    DECODE(NVL(A.PORT_ID_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT, 4) * 100, 'FM999999990.00') || '%') PORT_RATE,
		    DECODE(NVL(A.PORT_ID_CNT, 0), 0, 0, NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT) PORT_RATE_SORT,
		    NVL(A.OBD_CNT,0) OBD_CNT,
		    NVL(A.ZERO_OBD_CNT_1,0) ZERO_OBD_CNT,
		    DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.ZERO_OBD_CNT_1, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ZERO_OBD_RATE,
		    NVL(A.FIRST_OBD_CNT,0) ONE_OBD_CNT,
		    DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.FIRST_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ONE_OBD_RATE,
		    NVL(A.LOW_OBD_CNT,0) LOW_OBD_CNT,
		    DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_OBD_RATE
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
           <e:switch value="${param.query_flag }">
               <e:case value="1">
               right OUTER JOIN EASY_DATA.CMCODE_AREA B
               ON A.LATN_ID = B.AREA_NO
               </e:case>
               <e:case value="2">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON A.LATN_ID = B.BUREAU_NO
               </e:case>
               <e:case value="3">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL AND B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="4">
               RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL
                   and b.grid_union_org_code != -1 and b.grid_status = 1
                   AND B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="5">
               right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
               ON A.LATN_ID = B.VILLAGE_ID
               </e:case>
           </e:switch>
      WHERE
      A.FLG = '${param.query_flag }'
      AND A.BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      </e:if>
      <e:else condition="${region }">
          <e:switch value="${param.flag }">
               <e:case value="2">
                  <e:switch value="${param.query_flag }">
                      <e:case value="2">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.BUREAU_NO
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID
                          and c.GRID_UNION_ORG_CODE !=-1 and c.grid_status = 1
                          )
                      WHERE C.LATN_ID = '${param.region_id }'
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
               <e:case value="3">
                  <e:switch value="${param.query_flag }">
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.BUREAU_NO IN (
                          SELECT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                          and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                          and C.BRANCH_TYPE = 'a1')
                      WHERE C.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
          </e:switch>
           AND A.ACCT_DAY = '${param.beginDate}'
      </e:else>
      <e:if condition="${param.query_flag ne '1' }">
          <e:if condition="${param.query_sort eq '0' }">
          ORDER BY PORT_RATE_SORT DESC
          </e:if>
          <e:if condition="${param.query_sort eq '1' }">
          ORDER BY PORT_RATE_SORT ASC
          </e:if>
      </e:if>
      ) T
      <e:if condition="${param.query_flag eq '1' }">
      ORDER BY ORD
      </e:if>
      )T
      )
        WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
    </e:q4l>${e: java2json(reticle_list.list) }
  </e:case>
  <e:description>光网实占情况 end</e:description>


  <e:description>精准派单营销 begin</e:description>
  <e:case value="marketing_list">
    <e:q4l var="marketing">
        <e:if condition="${param.query_flag eq '5'}" var="village">
            <e:description>
            <!--SELECT village_id LATN_ID,
            VILLAGE_NAME AREA_DESC,
            ORDER_NUM    MBYH_CNT,
            EXEC_NUM     ZX_CNT,
            to_char(EXEC_RATE,'FM990.00')||'%' ZX_RATE,
            EXEC_RATE   ZX_RATE1,
            succ_num CGYH_CNT,
            to_char(SUCC_RATE,'FM990.00')||'%' cg_rate,
            SUCC_RATE cg_rate1,
            c_num
            FROM (SELECT T.*, ROWNUM ROW_NUM
            FROM (
            SELECT '999' VILLAGE_ID,
            '全省' VILLAGE_NAME,
            NVL(SUM(ORDER_NUM), 0) ORDER_NUM,
            NVL(SUM(EXEC_NUM), 0) EXEC_NUM,
            NVL(SUM(SUCC_NUM), 0) SUCC_NUM,
            DECODE(NVL(SUM(ORDER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(EXEC_NUM), 0) / SUM(ORDER_NUM), 4) * 100) EXEC_RATE,
            DECODE(NVL(SUM(ALL_USER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(SUCC_NUM), 0) / SUM(ALL_USER_NUM),
            4) * 100) SUCC_RATE,
            0 C_NUM
            FROM (SELECT BB.VILLAGE_ID,
            COUNT(AA.ORDER_ID) ORDER_NUM,
            COUNT(DECODE(EXEC_STAT, 0, AA.ORDER_ID)) EXEC_NUM,
            COUNT(DISTINCT AA.PROD_INST_ID) ALL_USER_NUM,
            COUNT(DISTINCT
            DECODE(SUCC_FLAG, 1, AA.PROD_INST_ID)) SUCC_NUM
            FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M BB,
             (SELECT
                    ORDER_ID,
					ORDER_DATE,
					PROD_INST_ID,
					ACC_NBR,
					SERV_NAME,
					CONTACT_TEL,
					CONTACT_ADDS,
					DEAL_FLAG,
					LATN_ID,
					BUREAU_NO,
					UNION_ORG_CODE,
					GRID_ID,
					SCENE_ID,
					MKT_CONTENT,
					MKT_REASON,
					EXEC_TIME,
					EXEC_STAFF,
					EXEC_STAT,
					EXEC_DESC,
					SUCC_FLAG,
					SUCC_TIME,
					ORDER_NUM,
					CONTACT_CONTPERSON,
					CONTACT_TYPE,
					ADDRESS_ID,
					SUCC_BUSINESS,
					ORDER_WAVE_TIME,
					ORDER_MONTH
			  FROM  EDW.TB_MKT_ORDER_LIST@GSEDW
			 UNION  ALL
			SELECT  ORDER_ID,
					ORDER_DATE,
					PROD_INST_ID,
					ACC_NBR,
					SERV_NAME,
					CONTACT_TEL,
					CONTACT_ADDS,
					DEAL_FLAG,
					LATN_ID,
					BUREAU_NO,
					UNION_ORG_CODE,
					GRID_ID,
					SCENE_ID,
					MKT_CONTENT,
					MKT_REASON,
					EXEC_TIME,
					EXEC_STAFF,
					EXEC_STAT,
					EXEC_DESC,
					SUCC_FLAG,
					SUCC_TIME,
					ORDER_NUM,
					CONTACT_CONTPERSON,
					CONTACT_TYPE,
					ADDRESS_ID,
					SUCC_BUSINESS,
					ORDER_WAVE_TIME,
					ORDER_MONTH
			 FROM  ${gis_user}.TB_MKT_ORDER_LIST_HIS
            ) AA
            WHERE BB.PROD_INST_ID = AA.PROD_INST_ID
            AND BB.ACCT_MONTH = '${param.acct_month}'
            <e:if condition="${param.dateType eq '1' }">
            AND SUBSTR(AA.ORDER_DATE,0,6) = '${param.beginMonth}'
            </e:if>
            <e:if condition="${param.dateType eq '0' }">
            AND AA.ORDER_DATE = '${param.beginDate}'
            </e:if>

            <e:if condition="${! empty param.scene_id }">
                AND AA.SCENE_ID = '${param.scene_id}'
            </e:if>
            GROUP BY BB.VILLAGE_ID) AA,
            ${gis_user}.VIEW_DB_CDE_VILLAGE BB
            WHERE AA.VILLAGE_ID = BB.VILLAGE_ID
            UNION ALL
            SELECT T.*, COUNT(1) OVER() C_NUM
            FROM (SELECT BB.VILLAGE_ID,
            BB.VILLAGE_NAME,
            AA.ORDER_NUM,
            AA.EXEC_NUM,
            AA.SUCC_NUM,
            DECODE(ORDER_NUM,
            0,
            0,
            ROUND(EXEC_NUM / ORDER_NUM, 4) * 100) EXEC_RATE,
            DECODE(USER_NUM,
            0,
            0,
            ROUND(SUCC_NUM / USER_NUM, 4) * 100) SUCC_RATE
            FROM (SELECT BB.VILLAGE_ID,
            COUNT(AA.ORDER_ID) ORDER_NUM,
            COUNT(DECODE(EXEC_STAT, 0, AA.ORDER_ID)) EXEC_NUM,
            COUNT(DISTINCT AA.PROD_INST_ID) USER_NUM,
            COUNT(DISTINCT DECODE(SUCC_FLAG,
            1,
            AA.PROD_INST_ID)) SUCC_NUM
            FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M BB,

            (SELECT
                    ORDER_ID,
					ORDER_DATE,
					PROD_INST_ID,
					ACC_NBR,
					SERV_NAME,
					CONTACT_TEL,
					CONTACT_ADDS,
					DEAL_FLAG,
					LATN_ID,
					BUREAU_NO,
					UNION_ORG_CODE,
					GRID_ID,
					SCENE_ID,
					MKT_CONTENT,
					MKT_REASON,
					EXEC_TIME,
					EXEC_STAFF,
					EXEC_STAT,
					EXEC_DESC,
					SUCC_FLAG,
					SUCC_TIME,
					ORDER_NUM,
					CONTACT_CONTPERSON,
					CONTACT_TYPE,
					ADDRESS_ID,
					SUCC_BUSINESS,
					ORDER_WAVE_TIME,
					ORDER_MONTH
			  FROM  EDW.TB_MKT_ORDER_LIST@GSEDW
			 UNION  ALL
			SELECT  ORDER_ID,
					ORDER_DATE,
					PROD_INST_ID,
					ACC_NBR,
					SERV_NAME,
					CONTACT_TEL,
					CONTACT_ADDS,
					DEAL_FLAG,
					LATN_ID,
					BUREAU_NO,
					UNION_ORG_CODE,
					GRID_ID,
					SCENE_ID,
					MKT_CONTENT,
					MKT_REASON,
					EXEC_TIME,
					EXEC_STAFF,
					EXEC_STAT,
					EXEC_DESC,
					SUCC_FLAG,
					SUCC_TIME,
					ORDER_NUM,
					CONTACT_CONTPERSON,
					CONTACT_TYPE,
					ADDRESS_ID,
					SUCC_BUSINESS,
					ORDER_WAVE_TIME,
					ORDER_MONTH
			 FROM  ${gis_user}.TB_MKT_ORDER_LIST_HIS
            ) AA

            WHERE BB.PROD_INST_ID = AA.PROD_INST_ID
            AND BB.ACCT_MONTH = '${param.acct_month}'
            <e:if condition="${param.dateType eq '1' }">
            AND  SUBSTR(AA.ORDER_DATE,0,6) = '${param.beginMonth}'
            </e:if>
            <e:if condition="${param.dateType eq '0' }">
            AND AA.ORDER_DATE = '${param.beginDate}'
            </e:if>
            <e:if condition="${! empty param.scene_id }">
                AND AA.SCENE_ID = '${param.scene_id}'
            </e:if>
            GROUP BY BB.VILLAGE_ID) AA,
            ${gis_user}.VIEW_DB_CDE_VILLAGE BB
            WHERE AA.VILLAGE_ID = BB.VILLAGE_ID
            <e:if condition="${empty param.region_id }" var="region">

            </e:if>
            <e:else condition="${region }">
                <e:switch value="${param.flag }">
                    <e:case value="2">
                        and bb.latn_Id = '${param.region_id}'
                    </e:case>
                    <e:case value="3">
                        AND BUREAU_NAME = '${param.region_id }'
                        AND bb.LATN_ID = '${param.city_id }'
                    </e:case>
                </e:switch>
            </e:else>
            ORDER BY SUCC_RATE DESC) T) T)
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}-->
            </e:description>
            SELECT T.VILLAGE_ID LATN_ID,
            T.VILLAGE_NAME AREA_DESC,
            T.ORDER_NUM MBYH_CNT,
            T.EXEC_NUM ZX_CNT,
            T.SUCC_NUM CGYH_CNT,
            TO_CHAR(EXEC_RATE, 'FM990.00') || '%' ZX_RATE,
            EXEC_RATE ZX_RATE1,
            TO_CHAR(SUCC_RATE, 'FM990.00') || '%' CG_RATE,
            SUCC_RATE CG_RATE1,
            T.EXEC_NUM_MONTH ZX_CNT_MONTH,
            T.SUCC_NUM_MONTH CGYH_CNT_MONTH,
            TO_CHAR(EXEC_RATE_MONTH, 'FM990.00') || '%' ZX_RATE_MONTH,
            EXEC_RATE_MONTH ZX_RATE_MONTH1,
            TO_CHAR(SUCC_RATE_MONTH, 'FM990.00') || '%' CG_RATE_MONTH,
            SUCC_RATE_MONTH CG_RATE_MONTH1,
            C_NUM
            FROM (SELECT T.VILLAGE_ID,
            T.VILLAGE_NAME,
            T.ORDER_NUM,
            T.EXEC_NUM,
            T.SUCC_NUM,
            T.USER_NUM,
            DECODE(T.ORDER_NUM,
            0,
            0,
            ROUND(T.EXEC_NUM / T.ORDER_NUM, 4) * 100) EXEC_RATE,
            DECODE(T.USER_NUM,
            0,
            0,
            ROUND(T.SUCC_NUM / T.USER_NUM, 4) * 100) SUCC_RATE,
            EXEC_NUM_MONTH,
            SUCC_NUM_MONTH,
            USER_NUM_MONTH,
            DECODE(T.ORDER_NUM,
            0,
            0,
            ROUND(T.EXEC_NUM_MONTH / T.ORDER_NUM, 4) * 100) EXEC_RATE_MONTH,
            DECODE(T.USER_NUM_MONTH,
            0,
            0,
            ROUND(T.SUCC_NUM / T.USER_NUM, 4) * 100) SUCC_RATE_MONTH,
            C_NUM,
            ROWNUM RN
            FROM (WITH VILLAGE_ORDER_LIST AS (SELECT T.*
            FROM (SELECT BB.LEV6_ID,
            COUNT(AA.ORDER_ID) ORDER_NUM,
            COUNT(CASE
            WHEN EXEC_STAT <> 0 THEN
            AA.ORDER_ID
            END) EXEC_NUM,
            COUNT(DISTINCT
            DECODE(AA.SUCC_FLAG,1,AA.PROD_INST_ID)) SUCC_NUM,
            COUNT(DISTINCT AA.PROD_INST_ID) USER_NUM,
            COUNT(CASE
            WHEN EXEC_STAT_MONTH <> 0 THEN
            AA.ORDER_ID
            END) EXEC_NUM_MONTH,
            COUNT(DISTINCT
            DECODE(AA.SUCC_FLAG_MONTH,
            1,
            AA.PROD_INST_ID)) SUCC_NUM_MONTH,
            COUNT(DISTINCT
            AA.PROD_INST_ID_MONTH) USER_NUM_MONTH
            FROM ${gis_user}.TB_MKT_INFO BB,
            (SELECT B.PROD_INST_ID PROD_INST_ID_MONTH,
            B.ORDER_ID,
            A.EXEC_STAT,
            A.SUCC_FLAG,
            B.EXEC_STAT    EXEC_STAT_MONTH,
            B.SUCC_FLAG    SUCC_FLAG_MONTH,
            A.PROD_INST_ID
            FROM EDW.TB_MKT_ORDER_LIST@GSEDW A,
            EDW.TB_MKT_ORDER_LIST@GSEDW B
            WHERE 1 = 1
            AND TO_CHAR(A.EXEC_TIME,'yyyymmdd') = '${param.beginDate}'
            AND B.ORDER_MONTH = SUBSTR('${param.beginDate}',0,6)
            AND A.ORDER_ID = B.ORDER_ID
            <e:if condition="${! empty param.scene_id }">
                AND A.SCENE_ID = '${param.scene_id}'
            </e:if>
            ) AA
            WHERE BB.PROD_INST_ID =
            AA.PROD_INST_ID
            GROUP BY BB.LEV6_ID) T)
            SELECT '999' VILLAGE_ID,
            '全省' VILLAGE_NAME,
            NVL(SUM(ORDER_NUM), 0) ORDER_NUM,
            NVL(SUM(EXEC_NUM), 0) EXEC_NUM,
            NVL(SUM(SUCC_NUM), 0) SUCC_NUM,
            NVL(SUM(USER_NUM), 0) USER_NUM,
            DECODE(NVL(SUM(ORDER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(EXEC_NUM), 0) / SUM(ORDER_NUM), 4) * 100) EXEC_RATE,
            DECODE(NVL(SUM(USER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(SUCC_NUM), 0) / SUM(USER_NUM), 4) * 100) SUCC_RATE,
            NVL(SUM(EXEC_NUM_MONTH), 0) EXEC_NUM_MONTH,
            NVL(SUM(SUCC_NUM_MONTH), 0) SUCC_NUM_MONTH,
            NVL(SUM(USER_NUM_MONTH), 0) USER_NUM_MONTH,
            DECODE(NVL(SUM(ORDER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(EXEC_NUM_MONTH), 0) /
            SUM(ORDER_NUM),
            4) * 100) EXEC_RATE_MONTH,
            DECODE(NVL(SUM(USER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(SUCC_NUM_MONTH), 0) /
            SUM(USER_NUM),
            4) * 100) SUCC_RATE_MONTH,
            0 C_NUM
            FROM VILLAGE_ORDER_LIST
            WHERE LEV6_ID IS NOT NULL
            UNION
            SELECT V.VILLAGE_ID,
            V.VILLAGE_NAME,
            NVL(SUM(AA.ORDER_NUM), 0) ORDER_NUM,
            NVL(SUM(AA.EXEC_NUM), 0) EXEC_NUM,
            NVL(SUM(AA.SUCC_NUM), 0) SUCC_NUM,
            NVL(SUM(AA.USER_NUM), 0) USER_NUM,
            DECODE(ORDER_NUM,
            0,
            0,
            ROUND(EXEC_NUM / ORDER_NUM, 4) * 100) EXEC_RATE,
            DECODE(USER_NUM,
            0,
            0,
            ROUND(SUCC_NUM / USER_NUM, 4) * 100) SUCC_RATE,
            NVL(SUM(EXEC_NUM_MONTH), 0) EXEC_NUM_MONTH,
            NVL(SUM(SUCC_NUM_MONTH), 0) SUCC_NUM_MONTH,
            NVL(SUM(USER_NUM_MONTH), 0) USER_NUM_MONTH,
            DECODE(NVL(SUM(ORDER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(EXEC_NUM_MONTH), 0) /
            SUM(ORDER_NUM),
            4) * 100) EXEC_RATE_MONTH,
            DECODE(NVL(SUM(USER_NUM), 0),
            0,
            0,
            ROUND(NVL(SUM(SUCC_NUM_MONTH), 0) /
            SUM(USER_NUM),
            4) * 100) SUCC_RATE_MONTH,
            COUNT(1) OVER() C_NUM
            FROM VILLAGE_ORDER_LIST AA, ${gis_user}.VIEW_DB_CDE_VILLAGE V
            WHERE AA.LEV6_ID = V.VILLAGE_ID
            <e:if condition="${empty param.region_id}" var="no_region">
            </e:if>
            <e:else condition="${no_region}">
                <e:if condition="${param.flag eq '1'}">
                    and v.LATN_ID = '${param.city_id}'
                </e:if>
                <e:if condition="${param.flag eq '2'}">
                    AND v.LATN_ID = '${param.region_id}'
                </e:if>
                <e:if condition="${param.flag eq '3'}">
                    AND v.BUREAU_NAME = '${param.region_id }'
                    and v.LATN_ID = '${param.city_id}'
                </e:if>
            </e:else>
            GROUP BY VILLAGE_ID, V.VILLAGE_NAME
            ORDER BY C_NUM) T
            WHERE ROWNUM < ${param.page+1} * ${param.pageSize}
            ) T
            WHERE RN > ${param.page} * ${param.pageSize}
        </e:if>
        <e:else condition="${village}">
            select t.* from (
            SELECT T.*, ROWNUM ROW_NUM FROM (
            SELECT
            '999' LATN_ID,
            '全省' AREA_DESC,
            0 LATN_SORT,
            ${sql_part_yx_column},
            0 C_NUM
            FROM
                ${sql_part_tab_name2} T
                INNER JOIN ${sql_part_tab_name2} T1
            ON T.LATN_ID = T1.LATN_ID
            AND T.BRANCH_TYPE = T1.BRANCH_TYPE
            AND T.SCENE_ID = T1.SCENE_ID
            AND T.STAT_LVL = T1.STAT_LVL
            AND T.LATN_SORT = T1.LATN_SORT
            AND T.ACCT_DAY = '${param.beginDate}'
            AND T1.ACCT_DAY = to_char(to_date('${param.beginDate}','yyyymmdd')-1,'yyyymmdd')
            AND t.branch_type <> 'c1'
            AND t.STAT_LVL = ${param.query_flag }
            AND T.SCENE_ID IS NOT NULL
            <e:if condition="${! empty param.scene_id }">
                AND t.SCENE_ID = '${param.scene_id}'
            </e:if>
            UNION ALL
            SELECT
            t.latn_id REGION_ID,
            t.latn_name AREA_DESC,
            t.latn_sort,
            ${sql_part_yx_column},
            COUNT(1) OVER() C_NUM
            FROM
                ${sql_part_tab_name2} T,
                ${sql_part_tab_name2} T1
            <e:if condition="${!empty param.region_id }">
                ,(select distinct
                <e:switch value="${param.query_flag }">
                    <e:case value="1">
                        latn_id,bureau_no
                    </e:case>
                    <e:case value="2">
                        latn_id,bureau_no
                    </e:case>
                    <e:case value="3">
                        latn_id,bureau_name,branch_no
                    </e:case>
                    <e:case value="4">
                        latn_id,bureau_name,grid_id
                    </e:case>
                </e:switch>
                from ${gis_user}.db_cde_grid) a
            </e:if>
            WHERE T.LATN_ID = T1.LATN_ID
            AND T.BRANCH_TYPE = T1.BRANCH_TYPE
            AND T.SCENE_ID = T1.SCENE_ID
            AND T.STAT_LVL = T1.STAT_LVL
            AND T.ACCT_DAY = '${param.beginDate}'
            AND T1.ACCT_DAY = to_char(to_date('${param.beginDate}','yyyymmdd')-1,'yyyymmdd')
            AND t.branch_type <> 'c1'
            AND t.STAT_LVL = ${param.query_flag }
            AND T.SCENE_ID IS NOT NULL
            <e:if condition="${! empty param.scene_id }">
                AND t.SCENE_ID = '${param.scene_id}'
            </e:if>
            <e:if condition="${empty param.region_id}" var="no_region">
            </e:if>
            <e:else condition="${no_region}">
                <e:description>
                <e:switch value="${param.flag }">
                    <e:case value="1">
                        and A.LATN_ID = '${param.region_id }'
                        and A.BUREAU_NO = T.LATN_ID
                    </e:case>
                    <e:case value="2">
                        and A.LATN_ID = '${param.city_id }'
                        and A.BUREAU_NO = T.LATN_ID
                    </e:case>
                    <e:case value="3">
                        and A.BUREAU_NAME = '${param.region_id }'
                        and A.BRANCH_NO = T.LATN_ID
                    </e:case>
                </e:switch>
                </e:description>
                <e:switch value="${param.query_flag }">
                    <e:case value="1">
                        and a.latn_id = t.latn_id
                    </e:case>
                    <e:case value="2">
                        AND a.LATN_ID = '${param.region_id }'
                        and a.bureau_no = t.latn_id
                    </e:case>
                    <e:case value="3">
                        AND a.LATN_ID = '${param.city_id }'
                        <e:if condition="${param.flag eq '3'}">
                            and A.BUREAU_NAME = '${param.region_id }'
                        </e:if>
                        and a.branch_no = t.latn_id
                    </e:case>
                    <e:case value="4">
                        AND a.LATN_ID = '${param.city_id }'
                        <e:if condition="${param.flag eq '3'}">
                            and A.BUREAU_NAME = '${param.region_id }'
                        </e:if>
                        and a.grid_id = t.latn_id
                    </e:case>
                </e:switch>
            </e:else>
            GROUP BY
                t.LATN_ID, t.LATN_NAME, t.LATN_SORT
            order by latn_sort
            )T)T
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
        </e:else>
    </e:q4l>${e: java2json(marketing.list) }
  </e:case>
  <e:description>精准派单营销 end</e:description>


  <e:description>竞争信息收集 begin</e:description>
    <e:description>竞争收集统计 竞争对手光网进线情况</e:description>
    <e:case value="collect_list">
    <e:q4l var="list">
    SELECT * FROM
    (SELECT T.*, ROWNUM ROW_NUM FROM (
    SELECT
    <e:if condition="${ empty param.region_id }" var="region">
    '全省' AREA_DESC,
    </e:if>
    <e:else condition="${region }">
        <e:switch value="${param.flag}">
            <e:case value="1">
            '全省' AREA_DESC,
            </e:case>
            <e:case value="2">
            '全市' AREA_DESC,
            </e:case>
            <e:case value="3">
            '全县' AREA_DESC,
            </e:case>
            <e:case value="4">
            '全支局' AREA_DESC,
            </e:case>
            <e:case value="5">
            '全网格' AREA_DESC,
            </e:case>
        </e:switch>
    </e:else>
       '0' ORD,
       NVL(TO_CHAR(A.SHOULD_COLLECT_CNT), '0') SHOULD_COLLECT_CNT,
       NVL(TO_CHAR(A.ALREADY_COLLECT_CNT), '0') ALREADY_COLLECT_CNT,
       DECODE(NVL(A.SHOULD_COLLECT_CNT, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(NVL(A.ALREADY_COLLECT_CNT, 0) /
                            A.SHOULD_COLLECT_CNT,
                            4) * 100,
                      'FM999999990.00') || '%') COLLECT_RATE,
       DECODE(NVL(A.SHOULD_COLLECT_CNT, 0),  0, 0,  NVL(A.ALREADY_COLLECT_CNT, 0) / A.SHOULD_COLLECT_CNT) COLLECT_RATE_SORT,
       DECODE(NVL(A.OTHER_MON_RATE, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(A.OTHER_MON_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_MON_RATE,
       DECODE(NVL(A.OTHER_YEAR_RATE, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(A.OTHER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_YEAR_RATE,
       NVL(TO_CHAR(A.OTHER_BD_CNT), '0') OTHER_BD_CNT,
       NVL(TO_CHAR(A.OTHER_CM_CNT), '0') OTHER_CM_CNT,
       DECODE(NVL(A.OTHER_BD_CNT, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(NVL(A.OTHER_CM_CNT, 0) / A.OTHER_BD_CNT,
                            4) * 100,
                      'FM999999990.00') || '%') MB_RATE,

       NVL(TO_CHAR(A.OTHER_CU_CNT), '0') OTHER_CU_CNT,
       DECODE(NVL(A.OTHER_BD_CNT, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(NVL(A.OTHER_CU_CNT, 0) / A.OTHER_BD_CNT,
                            4) * 100,
                      'FM999999990.00') || '%') MU_RATE,
       NVL(TO_CHAR(A.OTHER_SARFT_CNT), '0') OTHER_SARFT_CNT,
       NVL(TO_CHAR(A.OTHER_Y_CNT), '0') OTHER_Y_CNT,
       NVL(A.ALREADY_COLLECT_CNT, 0) - nvl(A.OTHER_BD_CNT,0) OTHER_UNINSTALL_CNT,
        <e:if condition="${param.query_flag eq '5'}">
            '0' other_optical_fiber,
            '0' WIDEBAND_IN,
            '0' CM_OPTICAL_FIBER,
            '0' CU_OPTICAL_FIBER,
            '0' SARFT_OPTICAL_FIBER,
        </e:if>
       NVL(A.COLLECT_DAY_CNT,0) COLLECT_DAY_CNT,
       NVL(A.UPDATE_DAY_CNT,0) UPDATE_DAY_CNT,
       0 C_NUM
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
      WHERE A.FLG = '0'
      </e:if>
      <e:else condition="${region }">
           <e:switch value="${param.flag }">
               <e:case value="2">
               WHERE A.LATN_ID = '${param.region_id }'
               </e:case>
               <e:case value="3">
               WHERE A.LATN_ID IN (
               SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
               WHERE BUREAU_NAME = '${param.region_id }'
                   and latn_id = '${param.city_id}'
               )
               </e:case>
           </e:switch>
      </e:else>
      AND BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      UNION ALL
      SELECT T.*, COUNT(1) OVER() C_NUM FROM (
      SELECT
      DISTINCT
      <e:switch value="${param.query_flag }">
          <e:case value="1">
          B.AREA_DESC,
          B.ORD,
          </e:case>
          <e:case value="2">
          B.BUREAU_NAME AREA_DESC,
          B.BUREAU_NO ORD,
          </e:case>
          <e:case value="3">
          B.BRANCH_NAME AREA_DESC,
          B.UNION_ORG_CODE ORD,
          </e:case>
          <e:case value="4">
          B.GRID_NAME AREA_DESC,
          B.GRID_ID ORD,
          </e:case>
          <e:case value="5">
          B.VILLAGE_NAME AREA_DESC,
          B.VILLAGE_ID ORD,
          </e:case>
      </e:switch>
       NVL(TO_CHAR(A.SHOULD_COLLECT_CNT), '0') SHOULD_COLLECT_CNT,
       NVL(TO_CHAR(A.ALREADY_COLLECT_CNT), '0') ALREADY_COLLECT_CNT,
       DECODE(NVL(A.SHOULD_COLLECT_CNT, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(NVL(A.ALREADY_COLLECT_CNT, 0) /
                            A.SHOULD_COLLECT_CNT,
                            4) * 100,
                      'FM999999990.00') || '%') COLLECT_RATE,
       DECODE(NVL(A.SHOULD_COLLECT_CNT, 0),  0, 0,  NVL(A.ALREADY_COLLECT_CNT, 0) / A.SHOULD_COLLECT_CNT) COLLECT_RATE_SORT,
       DECODE(NVL(A.OTHER_MON_RATE, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(A.OTHER_MON_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_MON_RATE,
       DECODE(NVL(A.OTHER_YEAR_RATE, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(A.OTHER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_YEAR_RATE,
       NVL(TO_CHAR(A.OTHER_BD_CNT), '0') OTHER_BD_CNT,
       NVL(TO_CHAR(A.OTHER_CM_CNT), '0') OTHER_CM_CNT,
       DECODE(NVL(A.OTHER_BD_CNT, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(NVL(A.OTHER_CM_CNT, 0) / A.OTHER_BD_CNT,
                            4) * 100,
                      'FM999999990.00') || '%') MB_RATE,

       NVL(TO_CHAR(A.OTHER_CU_CNT), '0') OTHER_CU_CNT,
       DECODE(NVL(A.OTHER_BD_CNT, '0'),
              '0',
              '0.00%',
              TO_CHAR(ROUND(NVL(A.OTHER_CU_CNT, 0) / A.OTHER_BD_CNT,
                            4) * 100,
                      'FM999999990.00') || '%') MU_RATE,
       NVL(TO_CHAR(A.OTHER_SARFT_CNT), '0') OTHER_SARFT_CNT,
       NVL(TO_CHAR(A.OTHER_Y_CNT), '0') OTHER_Y_CNT,
       NVL(A.ALREADY_COLLECT_CNT, 0) - nvl(A.OTHER_BD_CNT,0) OTHER_UNINSTALL_CNT
        <e:if condition="${param.query_flag eq '5'}">
            ,
            other_optical_fiber,
            WIDEBAND_IN,
            CM_OPTICAL_FIBER,
            CU_OPTICAL_FIBER,
            SARFT_OPTICAL_FIBER
        </e:if>
        ,
        NVL(A.COLLECT_DAY_CNT,0) COLLECT_DAY_CNT,
        NVL(A.UPDATE_DAY_CNT,0) UPDATE_DAY_CNT
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
           <e:switch value="${param.query_flag }">
               <e:case value="1">
               right OUTER JOIN EASY_DATA.CMCODE_AREA B
               ON A.LATN_ID = B.AREA_NO
               </e:case>
               <e:case value="2">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON A.LATN_ID = B.BUREAU_NO
               </e:case>
               <e:case value="3">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.UNION_ORG_CODE and B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="4">
               RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL
                   and b.grid_union_org_code != -1 and b.grid_status = 1
                   and B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="5">
               right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
               ON A.LATN_ID = B.VILLAGE_ID
               </e:case>
           </e:switch>
      WHERE
      A.FLG = '${param.query_flag }'
      AND A.BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      </e:if>
      <e:else condition="${region }">
          <e:switch value="${param.flag }">
               <e:case value="2">
                  <e:switch value="${param.query_flag }">
                      <e:case value="2">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.BUREAU_NO
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID
                          AND C.GRID_UNION_ORG_CODE IS NOT NULL
                          and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                          and C.BRANCH_TYPE = 'a1')
                      WHERE C.LATN_ID = '${param.region_id }'
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
               <e:case value="3">
                  <e:switch value="${param.query_flag }">
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.BUREAU_NO IN (
                          SELECT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID
                          AND C.GRID_UNION_ORG_CODE IS NOT NULL
                          and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                          )
                      WHERE C.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
          </e:switch>
           AND A.ACCT_DAY = '${param.beginDate}'
      </e:else>
      <e:if condition="${param.query_flag ne '1' }">
          <e:if condition="${param.query_sort eq '0' }">
          ORDER BY COLLECT_RATE_SORT DESC
          </e:if>
          <e:if condition="${param.query_sort eq '1' }">
          ORDER BY COLLECT_RATE_SORT ASC
          </e:if>
      </e:if>
      ) T
      <e:if condition="${param.query_flag eq '1' }">
      ORDER BY ORD
      </e:if>
      ) T
      )
      WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
    </e:q4l>${e: java2json(list.list) }
  </e:case>

  <e:description>竞争预警</e:description>
    <e:case value="collect_list_2">
    <e:q4l var="list">
            SELECT * FROM
            (SELECT T.*, ROWNUM ROW_NUM FROM (
            SELECT
            <e:if condition="${ empty param.region_id }" var="region">
                '全省' AREA_DESC,
            </e:if>
            <e:else condition="${region }">
                <e:switch value="${param.flag}">
                    <e:case value="1">
                        '全省' AREA_DESC,
                    </e:case>
                    <e:case value="2">
                        '全市' AREA_DESC,
                    </e:case>
                    <e:case value="3">
                        '全县' AREA_DESC,
                    </e:case>
                    <e:case value="4">
                        '全支局' AREA_DESC,
                    </e:case>
                    <e:case value="5">
                        '全网格' AREA_DESC,
                    </e:case>
                </e:switch>
            </e:else>
            '0' ORD,
            NVL(TO_CHAR(A.VILLAGE_CNT), '0') VILLAGE_CNT,
            NVL(TO_CHAR(A.OTHER_NET_KD_VILLAGE_CNT), ' ') OTHER_NET_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.CMCC_KD_VILLAGE_CNT), ' ') CMCC_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.CUCC_KD_VILLAGE_CNT), ' ') CUCC_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.CBN_KD_VILLAGE_CNT), ' ') CBN_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.OTHER_KD_VILLAGE_CNT), ' ') OTHER_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.OTHER_BD_CNT), ' ') OTHER_BD_CNT,
            NVL(TO_CHAR(A.OTHER_CM_CNT), ' ') OTHER_CM_CNT,
            NVL(TO_CHAR(A.OTHER_CU_CNT), ' ') OTHER_CU_CNT,
            NVL(TO_CHAR(A.OTHER_SARFT_CNT), ' ') OTHER_SARFT_CNT,
            NVL(TO_CHAR(A.OTHER_Y_CNT), ' ') OTHER_Y_CNT,
            '0' DX_MARKET_SHARE,
            '0' CM_MARKET_SHARE,
            '0' CU_MARKET_SHARE,
            '0' SARFT_MARKET_SHARE,
            '0' OTHER_MARKET_SHARE,
            0 C_NUM
            FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
            <e:if condition="${region }">
                WHERE A.FLG = '0'
            </e:if>
            <e:else condition="${region }">
                <e:switch value="${param.flag }">
                    <e:case value="2">
                        WHERE A.LATN_ID = '${param.region_id }'
                    </e:case>
                    <e:case value="3">
                        WHERE A.LATN_ID IN (
                        SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                        WHERE BUREAU_NAME = '${param.region_id }'
                        and latn_id = '${param.city_id}'
                        )
                    </e:case>
                </e:switch>
            </e:else>
            AND BRANCH_TYPE = 'a1'
            AND A.ACCT_DAY = '${param.beginDate}'
            UNION ALL
            SELECT T.*, COUNT(1) OVER() C_NUM FROM (
            SELECT
            DISTINCT
            <e:switch value="${param.query_flag }">
                <e:case value="1">
                    B.AREA_DESC,
                    B.ORD,
                </e:case>
                <e:case value="2">
                    B.BUREAU_NAME AREA_DESC,
                    B.BUREAU_NO ORD,
                </e:case>
                <e:case value="3">
                    B.BRANCH_NAME AREA_DESC,
                    B.UNION_ORG_CODE ORD,
                </e:case>
                <e:case value="4">
                    B.GRID_NAME AREA_DESC,
                    B.GRID_ID ORD,
                </e:case>
                <e:case value="5">
                    B.VILLAGE_NAME AREA_DESC,
                    B.VILLAGE_ID ORD,
                </e:case>
            </e:switch>
            NVL(TO_CHAR(A.VILLAGE_CNT), ' ') VILLAGE_CNT,
            NVL(TO_CHAR(A.OTHER_NET_KD_VILLAGE_CNT), ' ') OTHER_NET_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.CMCC_KD_VILLAGE_CNT), ' ') CMCC_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.CUCC_KD_VILLAGE_CNT), ' ') CUCC_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.CBN_KD_VILLAGE_CNT), ' ') CBN_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.OTHER_KD_VILLAGE_CNT), ' ') OTHER_KD_VILLAGE_CNT,
            NVL(TO_CHAR(A.OTHER_BD_CNT), ' ') OTHER_BD_CNT,
            NVL(TO_CHAR(A.OTHER_CM_CNT), ' ') OTHER_CM_CNT,
            NVL(TO_CHAR(A.OTHER_CU_CNT), ' ') OTHER_CU_CNT,
            NVL(TO_CHAR(A.OTHER_SARFT_CNT), ' ') OTHER_SARFT_CNT,
            NVL(TO_CHAR(A.OTHER_Y_CNT), ' ') OTHER_Y_CNT,
            '0' DX_MARKET_SHARE,
            '0' CM_MARKET_SHARE,
            '0' CU_MARKET_SHARE,
            '0' SARFT_MARKET_SHARE,
            '0' OTHER_MARKET_SHARE
            FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
            <e:if condition="${region }">
                <e:switch value="${param.query_flag }">
                    <e:case value="1">
                        right OUTER JOIN EASY_DATA.CMCODE_AREA B
                        ON A.LATN_ID = B.AREA_NO
                    </e:case>
                    <e:case value="2">
                        right OUTER JOIN ${gis_user}.DB_CDE_GRID B
                        ON A.LATN_ID = B.BUREAU_NO
                    </e:case>
                    <e:case value="3">
                        right OUTER JOIN ${gis_user}.DB_CDE_GRID B
                        ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')
                    </e:case>
                    <e:case value="4">
                        RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                        ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL
                        and b.grid_union_org_code != -1 and b.grid_status = 1
                        AND B.BRANCH_TYPE = 'a1')
                    </e:case>
                    <e:case value="5">
                        right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                        ON A.LATN_ID = B.VILLAGE_ID
                    </e:case>
                </e:switch>
                WHERE
                A.FLG = '${param.query_flag }'
                AND A.BRANCH_TYPE = 'a1'
                AND A.ACCT_DAY = '${param.beginDate}'
            </e:if>
            <e:else condition="${region }">
                <e:switch value="${param.flag }">
                    <e:case value="2">
                        <e:switch value="${param.query_flag }">
                            <e:case value="2">
                                RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                ON A.LATN_ID = B.BUREAU_NO
                                WHERE B.LATN_ID = '${param.region_id }'
                                AND B.BRANCH_TYPE = 'a1'
                                AND A.BRANCH_TYPE = 'a1'
                            </e:case>
                            <e:case value="3">
                                RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                ON A.LATN_ID = B.UNION_ORG_CODE
                                WHERE B.LATN_ID = '${param.region_id }'
                                AND B.BRANCH_TYPE = 'a1'
                                AND A.BRANCH_TYPE = 'a1'
                                AND B.GRID_UNION_ORG_CODE IS NOT NULL
                            </e:case>
                            <e:case value="4">
                                RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                ON A.LATN_ID = B.GRID_ID
                                WHERE B.LATN_ID = '${param.region_id }'
                                AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                and b.grid_union_org_code != -1 and b.grid_status = 1
                                AND B.BRANCH_TYPE = 'a1'
                                AND A.BRANCH_TYPE = 'a1'
                            </e:case>
                            <e:case value="5">
                                right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                ON A.LATN_ID = B.VILLAGE_ID
                                WHERE LATN_ID IN (
                                SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                                ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                                and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1
                                and C.BRANCH_TYPE = 'a1')
                                WHERE C.LATN_ID = '${param.region_id }'
                                )
                                AND A.BRANCH_TYPE = 'a1'
                            </e:case>
                        </e:switch>
                    </e:case>
                    <e:case value="3">
                        <e:switch value="${param.query_flag }">
                            <e:case value="3">
                                RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                ON A.LATN_ID = B.UNION_ORG_CODE
                                WHERE B.BUREAU_NO IN (
                                SELECT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                WHERE BUREAU_NAME = '${param.region_id }'
                                and latn_id = '${param.city_id}'
                                )
                                AND B.BRANCH_TYPE = 'a1'
                                AND A.BRANCH_TYPE = 'a1'
                                AND B.GRID_UNION_ORG_CODE IS NOT NULL
                            </e:case>
                            <e:case value="4">
                                RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                                ON A.LATN_ID = B.GRID_ID
                                WHERE B.BUREAU_NO IN (
                                SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                WHERE BUREAU_NAME = '${param.region_id }'
                                and latn_id = '${param.city_id}'
                                )
                                AND B.GRID_UNION_ORG_CODE IS NOT NULL
                                and b.grid_union_org_code != -1 and b.grid_status = 1
                                AND B.BRANCH_TYPE = 'a1'
                                AND A.BRANCH_TYPE = 'a1'
                            </e:case>
                            <e:case value="5">
                                right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                ON A.LATN_ID = B.VILLAGE_ID
                                WHERE LATN_ID IN (
                                SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                                right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                                ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                                and c.GRID_UNION_ORG_CODE != -1 and grid_status = 1
                                and C.BRANCH_TYPE = 'a1')
                                WHERE C.BUREAU_NO IN (
                                SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                                WHERE BUREAU_NAME = '${param.region_id }'
                                and latn_id = '${param.city_id}'
                                )
                                )
                                AND A.BRANCH_TYPE = 'a1'
                            </e:case>
                        </e:switch>
                    </e:case>
                </e:switch>
                 AND A.ACCT_DAY = '${param.beginDate}'
            </e:else>
            <e:if condition="${param.query_flag ne '1' }">
                <e:if condition="${param.query_sort eq '0' }">
                    ORDER BY ORD DESC
                </e:if>
                <e:if condition="${param.query_sort eq '1' }">
                    ORDER BY ORD ASC
                </e:if>
            </e:if>
            ) T
            <e:if condition="${param.query_flag eq '1' }">
                ORDER BY ORD
            </e:if>
            ) T
            )
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
        </e:q4l>${e: java2json(list.list) }
    </e:case>
  <e:description>竞争信息收集 end</e:description>


  <e:description>宽带存量保有 begin</e:description>
  <e:case value="cunliang">
    <e:q4l var="cunliang_list">
    SELECT * FROM
    (SELECT T.*, ROWNUM ROW_NUM FROM (
    SELECT
    <e:if condition="${ empty param.region_id }" var="region">
    '全省' AREA_DESC,
    </e:if>
    <e:else condition="${region }">
        <e:switch value="${param.flag}">
            <e:case value="1">
            '全省' AREA_DESC,
            </e:case>
            <e:case value="2">
            '全市' AREA_DESC,
            </e:case>
            <e:case value="3">
            '全县' AREA_DESC,
            </e:case>
            <e:case value="4">
            '全支局' AREA_DESC,
            </e:case>
            <e:case value="5">
            '全网格' AREA_DESC,
            </e:case>
        </e:switch>
    </e:else>
       '0' ORD,
       DECODE(NVL(A.BY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(BY_CNT, 0) / A.BY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') BY_RATE,
       DECODE(NVL(A.ACTIVE_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / A.ACTIVE_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') ACTIVE_RATE,
       DECODE(NVL(A.XY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(XY_CNT, 0) / A.XY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') XY_RATE,
       DECODE(NVL(A.LW_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(LW_CNT, 0) / A.LW_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') LW_RATE,
       0 C_NUM
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
      WHERE A.FLG = '0'
      </e:if>
      <e:else condition="${region }">
           <e:switch value="${param.flag }">
               <e:case value="2">
               WHERE A.LATN_ID = '${param.region_id }'
               </e:case>
               <e:case value="3">
               WHERE A.LATN_ID IN (
               SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
               WHERE BUREAU_NAME = '${param.region_id }'
                   and latn_id = '${param.city_id}'
               )
               </e:case>
           </e:switch>
      </e:else>
      AND BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      UNION ALL
      SELECT T.*, COUNT(1) OVER() C_NUM FROM (
      SELECT
      DISTINCT
      <e:switch value="${param.query_flag }">
          <e:case value="1">
          B.AREA_DESC,
          B.ORD,
          </e:case>
          <e:case value="2">
          B.BUREAU_NAME AREA_DESC,
          B.BUREAU_NO ORD,
          </e:case>
          <e:case value="3">
          B.BRANCH_NAME AREA_DESC,
          B.UNION_ORG_CODE ORD,
          </e:case>
          <e:case value="4">
          B.GRID_NAME AREA_DESC,
          B.GRID_ID ORD,
          </e:case>
          <e:case value="5">
          B.VILLAGE_NAME AREA_DESC,
          B.VILLAGE_ID ORD,
          </e:case>
      </e:switch>
       DECODE(NVL(A.BY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(BY_CNT, 0) / A.BY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') BY_RATE,
       DECODE(NVL(A.ACTIVE_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / A.ACTIVE_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') ACTIVE_RATE,
       DECODE(NVL(A.XY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(XY_CNT, 0) / A.XY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') XY_RATE,
       DECODE(NVL(A.LW_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(LW_CNT, 0) / A.LW_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') LW_RATE
      FROM  ${gis_user}.TB_GIS_RES_CITY_DAY_HIS A
      <e:if condition="${region }">
           <e:switch value="${param.query_flag }">
               <e:case value="1">
               right OUTER JOIN EASY_DATA.CMCODE_AREA B
               ON A.LATN_ID = B.AREA_NO
               </e:case>
               <e:case value="2">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON A.LATN_ID = B.BUREAU_NO
               </e:case>
               <e:case value="3">
               right OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="4">
               RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
               ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL
                   and b.grid_union_org_code != -1 and b.grid_status = 1
                   AND B.BRANCH_TYPE = 'a1')
               </e:case>
               <e:case value="5">
               right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
               ON A.LATN_ID = B.VILLAGE_ID
               </e:case>
           </e:switch>
      WHERE
      A.FLG = '${param.query_flag }'
      AND A.BRANCH_TYPE = 'a1'
      AND A.ACCT_DAY = '${param.beginDate}'
      </e:if>
      <e:else condition="${region }">
          <e:switch value="${param.flag }">
               <e:case value="2">
                  <e:switch value="${param.query_flag }">
                      <e:case value="2">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.BUREAU_NO
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.LATN_ID = '${param.region_id }'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                          and c.GRID_UNION_ORG_CODE != -1 and grid_status = 1
                          and C.BRANCH_TYPE = 'a1')
                      WHERE C.LATN_ID = '${param.region_id }'
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
               <e:case value="3">
                  <e:switch value="${param.query_flag }">
                      <e:case value="3">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.UNION_ORG_CODE
                      WHERE B.BUREAU_NO IN (
                          SELECT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      </e:case>
                      <e:case value="4">
                      RIGHT OUTER JOIN ${gis_user}.DB_CDE_GRID B
                      ON A.LATN_ID = B.GRID_ID
                      WHERE B.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      AND B.GRID_UNION_ORG_CODE IS NOT NULL
                      and b.grid_union_org_code != -1 and b.grid_status = 1
                      AND B.BRANCH_TYPE = 'a1'
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                      <e:case value="5">
                      right OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      ON A.LATN_ID = B.VILLAGE_ID
                      WHERE LATN_ID IN (
                      SELECT DISTINCT VILLAGE_ID FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
                      right OUTER JOIN ${gis_user}.DB_CDE_GRID C
                      ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL
                          and c.GRID_UNION_ORG_CODE != -1 and grid_status = 1
                          and C.BRANCH_TYPE = 'a1')
                      WHERE C.BUREAU_NO IN (
                          SELECT DISTINCT BUREAU_NO FROM ${gis_user}.DB_CDE_GRID
                          WHERE BUREAU_NAME = '${param.region_id }'
                          and latn_id = '${param.city_id}'
                      )
                      )
                      AND A.BRANCH_TYPE = 'a1'
                      </e:case>
                  </e:switch>
               </e:case>
          </e:switch>
           AND A.ACCT_DAY = '${param.beginDate}'
      </e:else>
      <e:if condition="${param.query_flag ne '1' }">
          <e:if condition="${param.query_sort eq '0' }">
          ORDER BY BY_RATE DESC
          </e:if>
          <e:if condition="${param.query_sort eq '1' }">
          ORDER BY BY_RATE ASC
          </e:if>
      </e:if>
      ) T
      <e:if condition="${param.query_flag eq '1' }">
      ORDER BY ORD
      </e:if>
      ) T
      )
        WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
    </e:q4l>${e: java2json(cunliang_list.list) }
  </e:case>
  <e:description>宽带存量保有 end</e:description>

  <e:description>数据质量监控</e:description>
  <e:case value="market_data_monitor">
    <e:q4l var="dataList">
        SELECT a.* FROM (
        SELECT t.* FROM(
        SELECT
        b.LATN_ID,
        b.LATN_NAME,
        b.BUREAU_NO,
        b.BUREAU_NAME,
        b.VILLAGE_ID,
        b.VILLAGE_NAME,
        a.GZ_ZHU_HU_COUNT,
        a.GZ_H_USE_CNT,
        to_char(nvl(CASE
        WHEN a.GZ_ZHU_HU_COUNT = 0 THEN
        0
        ELSE
        ROUND((a.GZ_H_USE_CNT / a.GZ_ZHU_HU_COUNT), 4) * 100
        END,0),'FM9999999990.00')||'%' MARKET_LV1,
        CASE
        WHEN a.GZ_ZHU_HU_COUNT = 0 THEN
        0
        ELSE
        ROUND((a.GZ_H_USE_CNT / a.GZ_ZHU_HU_COUNT), 4) * 100
        END MARKET_LV,
        a.PORT_ID_CNT,
        a.USE_PORT_CNT,
        to_char(nvl(CASE
        WHEN a.PORT_ID_CNT = 0 THEN
        0
        ELSE
        ROUND((a.USE_PORT_CNT / a.PORT_ID_CNT), 4) * 100
        END,0),'FM9999999990.00')||'%' PORT_LV1,
        CASE
        WHEN a.PORT_ID_CNT = 0 THEN
        0
        ELSE
        ROUND((a.USE_PORT_CNT / a.PORT_ID_CNT), 4) * 100
        END PORT_LV,
        row_number() over(ORDER BY city_order_num ASC,region_order_num ASC,village_name ASC) rn,
        COUNT(1) OVER() c_num
        FROM ${gis_user}.TB_GIS_RES_CITY_DAY_HIS a,
        ${gis_user}.VIEW_DB_CDE_VILLAGE b
        WHERE 1=1
        and a.latn_id = b.village_id
        ${sql_part}
        <e:if condition="${param.city_id ne '999' && !empty param.city_id}">
            and b.latn_id=${param.city_id}
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '999'}">
            and b.bureau_no = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.union_org_code}">
            and b.union_org_code = '${param.union_org_code}'
        </e:if>
        <e:if condition="${!empty param.grid_union_org_code}">
            and b.grid_union_org_code = '${param.grid_union_org_code}'
        </e:if>
        <e:if condition="${!empty param.data_monitor}">
            AND a.GZ_H_USE_CNT>a.use_port_cnt
        </e:if>
        <e:if condition="${!empty param.data_monitor}" var="empty_data_monitor">
            and DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0),
            0,
            0,
            ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT,
            4) * 100) > 100
            and A.ACCT_DAY = (SELECT to_char(last_day(to_date('${param.beginDate}','yyyymm')),'yyyymmdd') FROM dual)
        </e:if>
        <e:else condition="${empty_data_monitor}">
            AND A.ACCT_DAY = '${param.beginDate}'
        </e:else>
        )
        t WHERE rn <= ${param.page+1}*${param.pageSize})a WHERE rn >${param.page}*${param.pageSize}
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>