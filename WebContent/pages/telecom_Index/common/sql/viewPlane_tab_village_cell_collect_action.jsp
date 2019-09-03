<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_column">
  b.latn_id org_id,
  b.latn_name org_name,
  TO_CHAR(ROUND(DECODE(B.HOUSEHOLD_NUM,
  0,
  0,
  B.H_USE_CNT /
  B.HOUSEHOLD_NUM),
  4) * 100,
  'FM99999999990.00') MARKET_LV1,
  TO_CHAR(ROUND(DECODE(B.HOUSEHOLD_NUM,
  0,
  0,
  B.H_USE_CNT /
  B.HOUSEHOLD_NUM),
  4) * 100,
  'FM99999999990.00') || '%' MARKET_LV,
  B.H_USE_CNT,
  B.HOUSEHOLD_NUM,
  TO_CHAR(ROUND(DECODE(B.BRIGADE_ID_CNT,
  0,
  0,
  B.ZY_CNT /
  B.BRIGADE_ID_CNT),
  4) * 100,
  'FM99999999990.00') GW_LV1,
  TO_CHAR(ROUND(DECODE(B.BRIGADE_ID_CNT,
  0,
  0,
  B.ZY_CNT /
  B.BRIGADE_ID_CNT),
  4) * 100,
  'FM99999999990.00') || '%' GW_LV,
  NVL(B.BRIGADE_ID_CNT, 0) BRIGADE_ID_CNT,
  NVL(B.ZY_CNT, 0) ZY_CNT,
  NVL(EQP_CNT, 0) OBD_CNT,
  TO_CHAR(ROUND(DECODE(B.CAPACITY,
  0,
  0,
  B.ACTUALCAPACITY /
  B.CAPACITY),
  4) * 100,
  'FM99999999990.00') PORT_LV1,
  TO_CHAR(ROUND(DECODE(B.CAPACITY,
  0,
  0,
  B.ACTUALCAPACITY /
  B.CAPACITY),
  4) * 100,
  'FM99999999990.00') || '%' PORT_LV,
  NVL(B.CAPACITY, 0) CAPACITY,
  NVL(B.ACTUALCAPACITY, 0) ACTUALCAPACITY,
  NVL(B.Y_COLLECT_CNT, 0) SHOULD_COLLECT,
  NVL(B.COLLECT_CNT, 0) COLLECTED_CNT,
  TO_CHAR(ROUND(DECODE(B.Y_COLLECT_CNT,
  0,
  0,
  B.COLLECT_CNT /
  B.Y_COLLECT_CNT),
  4) * 100,
  'FM99999999990.00') COLLECT_LV1,
  TO_CHAR(ROUND(DECODE(B.Y_COLLECT_CNT,
  0,
  0,
  B.COLLECT_CNT /
  B.Y_COLLECT_CNT),
  4) * 100,
  'FM99999999990.00') || '%' COLLECT_LV,
  NVL(B.YW_COLLECT_CNT, 0) YW_COLLECT_CNT,
  NVL(B.ZX_COLLECT_CNT, 0) ZX_COLLECT_CNT
</e:set>
<e:set var="sql_column2">
  nvl(sum(col_num_1),0) pd_num,
  nvl(sum(col_num_2),0) zx_num,
  TO_CHAR(ROUND(DECODE(nvl(sum(COL_NUM_1),0),
  0,
  0,
  nvl(sum(COL_NUM_2),0) / nvl(sum(COL_NUM_1),0)),
  4) * 100,
  'FM99999999990.00') || '%' ZX_LV
</e:set>

<e:switch value="${param.eaction}">
  <e:description>清单_划小组织机构</e:description>
  <e:case value="list_hx">
    <e:q4l var="dataList">
      <e:if condition="${param.flg ne '5'}">
      select * from (
      </e:if>
      SELECT d.*,nvl(e.pd_num,0) pd_num,nvl(e.zx_num,0) zx_num,nvl(e.zx_lv,'0.00%') zx_lv,c.vc_cnt,
      COUNT(1) OVER() C_NUM,
      ROW_NUMBER() OVER(ORDER BY order_num) RN
      FROM (
      SELECT
      ${sql_column},
      '0' order_num

      FROM

      ${gis_user}.TB_GIS_COUNT_INFO_D b
      WHERE 1 = 1
      AND b.latn_id = '${param.region_id}'
      AND b.flg =
      <e:switch value="${param.flg}">
        <e:case value="1">
          1
        </e:case>
        <e:case value="2">
          2
        </e:case>
        <e:case value="3">
          8
        </e:case>
        <e:case value="4">
          7
        </e:case>
        <e:case value="5">
          6
        </e:case>
      </e:switch>
      AND b.acct_day = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')

      <e:if condition="${param.flg eq '5'}">
        )d,
        <e:description>营销派单 begin</e:description>
        (
        SELECT
        grid_id org_id,
        ${sql_column2}
        FROM ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
        WHERE stat_date = '${param.accDate}'
        AND stat_lvl = 4
        AND grid_id = '${param.region_id}'
        GROUP BY grid_id
        ) e,
        <e:description>营销派单 end</e:description>

        <e:description>行政村数 begin</e:description>
        (SELECT
        grid_id org_id,
        count(DISTINCT village_id) vc_cnt
        FROM EDW.VW_TB_CDE_VILLAGE@GSEDW
        WHERE grid_id = '${param.region_id}'
        group by grid_id
        ) c
        <e:description>行政村数 end</e:description>
        WHERE d.org_id = e.org_id
        and d.org_id = c.org_id

      </e:if>

      <e:if condition="${param.flg ne '5'}">
        UNION ALL

        SELECT * FROM (
        SELECT a.*,b.order_num FROM (
        SELECT
        ${sql_column}
        FROM ${gis_user}.TB_GIS_COUNT_INFO_D b
        WHERE b.latn_id IN (
        SELECT DISTINCT
        <e:switch value="${param.flg}">
          <e:case value="1">
            latn_id
          </e:case>
          <e:case value="2">
            bureau_no
          </e:case>
          <e:case value="3">
            branch_no
          </e:case>
          <e:case value="4">
            grid_id
          </e:case>
        </e:switch>
        FROM
        EDW.VW_TB_CDE_VILLAGE@GSEDW
        where 1 = 1
        <e:switch value="${param.flg}">
          <e:case value="2">
            and latn_id = '${param.region_id}'
          </e:case>
          <e:case value="3">
            and bureau_no = '${param.region_id}'
          </e:case>
          <e:case value="4">
            and branch_no = '${param.region_id}'
          </e:case>
        </e:switch>
        )
        AND b.flg =
        <e:switch value="${param.flg}">
          <e:case value="1">
            2
          </e:case>
          <e:case value="2">
            8
          </e:case>
          <e:case value="3">
            7
          </e:case>
          <e:case value="4">
            6
          </e:case>
        </e:switch>
        AND b.acct_day = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')
        ) a,
        (SELECT DISTINCT
        <e:switch value="${param.flg}">
          <e:case value="1">
            c.latn_id
          </e:case>
          <e:case value="2">
            c.bureau_no
          </e:case>
          <e:case value="3">
            c.branch_no
          </e:case>
          <e:case value="4">
            c.grid_id
          </e:case>
        </e:switch>
        org_id,
        <e:switch value="${param.flg}">
          <e:case value="1">
            c.city_order_num
          </e:case>
          <e:case value="2">
            c.region_order_num
          </e:case>
          <e:case value="3">
            c.branch_no
          </e:case>
          <e:case value="4">
            c.grid_id
          </e:case>
        </e:switch>
        order_num FROM ${gis_user}.db_cde_grid c) b
        WHERE a.org_id = b.org_id)d
        )d,

        <e:description>营销派单 begin</e:description>
        (
        SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            latn_id
          </e:case>
          <e:case value="2">
            bureau_no
          </e:case>
          <e:case value="3">
            branch_no
          </e:case>
          <e:case value="4">
            grid_id
          </e:case>
        </e:switch>
        org_id,
        ${sql_column2}
        FROM ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
        WHERE stat_date = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')
        AND stat_lvl =
        <e:switch value="${param.flg}">
          <e:case value="1">
            1 group by latn_id
          </e:case>
          <e:case value="2">
            2 AND latn_id = '${param.region_id}' GROUP BY bureau_no
          </e:case>
          <e:case value="3">
            3 AND bureau_no = '${param.region_id}' GROUP BY branch_no
          </e:case>
          <e:case value="4">
            4 AND branch_no = '${param.region_id}' GROUP BY grid_id
          </e:case>
        </e:switch>
        UNION ALL
        SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            999
          </e:case>
          <e:case value="2">
            latn_id || ''
          </e:case>
          <e:case value="3">
            bureau_no
          </e:case>
          <e:case value="4">
            branch_no
          </e:case>
        </e:switch>
        org_id,
        ${sql_column2}
        FROM ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
        WHERE stat_date = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')
        AND stat_lvl =
        <e:switch value="${param.flg}">
          <e:case value="1">
            1
          </e:case>
          <e:case value="2">
            1 AND latn_id = '${param.region_id}' GROUP BY latn_id
          </e:case>
          <e:case value="3">
            2 AND bureau_no = '${param.region_id}' GROUP BY bureau_no
          </e:case>
          <e:case value="4">
            3 AND branch_no = '${param.region_id}' GROUP BY branch_no
          </e:case>
        </e:switch>
        )e,
        <e:description>营销派单 end</e:description>

        <e:description>行政村数 begin</e:description>
        (SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            '999'
          </e:case>
          <e:case value="2">
            latn_id || ''
          </e:case>
          <e:case value="3">
            bureau_no
          </e:case>
          <e:case value="4">
            branch_no
          </e:case>
        </e:switch>
        org_id,
        count(DISTINCT village_id) vc_cnt
        FROM EDW.VW_TB_CDE_VILLAGE@GSEDW
        WHERE 1 = 1
        <e:switch value="${param.flg}">
          <e:case value="2">
            and latn_id = '${param.region_id}' GROUP BY latn_id
          </e:case>
          <e:case value="3">
            and bureau_no = '${param.region_id}' GROUP BY bureau_no
          </e:case>
          <e:case value="4">
            and branch_no = '${param.region_id}' GROUP BY branch_no
          </e:case>
        </e:switch>
        UNION ALL
        SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            latn_id || ''
          </e:case>
          <e:case value="2">
            bureau_no
          </e:case>
          <e:case value="3">
            branch_no
          </e:case>
          <e:case value="4">
            grid_id
          </e:case>
        </e:switch>
        org_id,
        count(DISTINCT village_id) vc_cnt
        FROM EDW.VW_TB_CDE_VILLAGE@GSEDW
        GROUP BY
        <e:switch value="${param.flg}">
          <e:case value="1">
            latn_id
          </e:case>
          <e:case value="2">
            bureau_no
          </e:case>
          <e:case value="3">
            branch_no
          </e:case>
          <e:case value="4">
            grid_id
          </e:case>
        </e:switch>
        ) c
        <e:description>行政村数 end</e:description>

        WHERE d.org_id = e.org_id(+)
        and d.org_id = c.org_id

        )f WHERE rn <= ${param.page+1}*${param.pageSize} and rn >${param.page}*${param.pageSize}
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>清单_行政组织机构</e:description>
  <e:case value="list_xz">
    <e:q4l var="dataList">
      <e:if condition="${param.flg ne '5'}">
        select * from (
      </e:if>
      SELECT d.*,nvl(e.pd_num,0) pd_num,nvl(e.zx_num,0) zx_num,nvl(e.zx_lv,'0.00%') zx_lv,c.vc_cnt,
      COUNT(1) OVER() C_NUM,
      ROW_NUMBER() OVER(ORDER BY order_num) RN
      FROM (
      SELECT
      ${sql_column},
      '0' order_num

      FROM

      ${gis_user}.TB_GIS_COUNT_INFO_D b
      WHERE 1 = 1
      AND b.latn_id = '${param.region_id}'
      AND b.flg =
      <e:switch value="${param.flg}">
        <e:case value="1">
          1
        </e:case>
        <e:case value="2">
          2
        </e:case>
        <e:case value="3">
          3
        </e:case>
        <e:case value="4">
          4
        </e:case>
        <e:case value="5">
          6
        </e:case>
      </e:switch>
      AND b.acct_day = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')

      <e:if condition="${param.flg eq '5'}">
        )d,
        <e:description>营销派单 begin</e:description>
        (
        SELECT
        grid_id org_id,
        ${sql_column2}
        FROM ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
        WHERE stat_date = '${param.accDate}'
        AND stat_lvl = 4
        AND grid_id = '${param.region_id}'
        GROUP BY grid_id
        ) e,
        <e:description>营销派单 end</e:description>

        <e:description>行政村数 begin</e:description>
        (SELECT
        grid_id org_id,
        count(DISTINCT village_id) vc_cnt
        FROM EDW.VW_TB_CDE_VILLAGE@GSEDW
        WHERE grid_id = '${param.region_id}'
        group by grid_id
        ) c
        <e:description>行政村数 end</e:description>
        WHERE d.org_id = e.org_id
        and d.org_id = c.org_id

      </e:if>

      <e:if condition="${param.flg ne '5'}">
        UNION ALL

        SELECT * FROM (
        SELECT a.*,b.order_num FROM (
        SELECT
        ${sql_column}
        FROM ${gis_user}.TB_GIS_COUNT_INFO_D b
        WHERE b.latn_id IN (
        SELECT DISTINCT
        <e:switch value="${param.flg}">
          <e:case value="1">
            city_id
          </e:case>
          <e:case value="2">
            county_id
          </e:case>
          <e:case value="3">
            town_id
          </e:case>
          <e:case value="4">
            brigade_id
          </e:case>
        </e:switch>
        FROM
        EDW.VW_TB_CDE_VILLAGE@GSEDW
        where 1 = 1
        <e:switch value="${param.flg}">
          <e:case value="2">
            and city_id = '${param.region_id}'
          </e:case>
          <e:case value="3">
            and county_id = '${param.region_id}'
          </e:case>
          <e:case value="4">
            and town_id = '${param.region_id}'
          </e:case>
        </e:switch>
        )
        AND b.flg =
        <e:switch value="${param.flg}">
          <e:case value="1">
            2
          </e:case>
          <e:case value="2">
            3
          </e:case>
          <e:case value="3">
            4
          </e:case>
          <e:case value="4">
            5
          </e:case>
        </e:switch>
        AND b.acct_day = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')
        ) a,
        <e:switch value="${param.flg}">
          <e:case value="1">
            (
            SELECT
              AREA_NO ORG_ID,
              ORD order_num
            FROM
              CMCODE_AREA
          </e:case>
          <e:case value="2">
            (SELECT DISTINCT
              e.county_id org_id,
              ord order_num
            from
              EDW.VW_TB_CDE_VILLAGE@GSEDW e,
              cmcode_city c
            where c.city_no = e.bureau_no
          </e:case>
          <e:case value="3">
            (select distinct
              e.town_id org_id,
              e.town_id order_num
            from
              EDW.VW_TB_CDE_VILLAGE@GSEDW e
          </e:case>
          <e:case value="4">
            (select distinct
              e.brigade_id org_id,
              e.brigade_id order_num
            from
              EDW.VW_TB_CDE_VILLAGE@GSEDW e
          </e:case>
        </e:switch>

        <e:description>
        (SELECT DISTINCT
        <e:switch value="${param.flg}">
          <e:case value="1">
            e.city_id
          </e:case>
          <e:case value="2">
            e.county_id
          </e:case>
          <e:case value="3">
            e.town_id
          </e:case>
          <e:case value="4">
            e.brigade_id
          </e:case>
        </e:switch>
        org_id,
        <e:switch value="${param.flg}">
          <e:case value="1">
            c.city_order_num
          </e:case>
          <e:case value="2">
            c.region_order_num
          </e:case>
          <e:case value="3">
            c.branch_no
          </e:case>
          <e:case value="4">
            c.grid_id
          </e:case>
        </e:switch>
        order_num FROM ${gis_user}.db_cde_grid c,
        EDW.VW_TB_CDE_VILLAGE@GSEDW e
        where
        <e:switch value="${param.flg}">
          <e:case value="1">
            c.latn_id = e.latn_id
          </e:case>
          <e:case value="2">
            c.bureau_no = e.bureau_no
          </e:case>
          <e:case value="3">
            c.branch_no = e.branch_no
          </e:case>
          <e:case value="4">
            c.grid_id = e.grid_id
          </e:case>
        </e:switch>
        </e:description>

        ) b
        WHERE a.org_id = b.org_id)d
        )d,

        <e:description>营销派单 begin</e:description>
        (
        SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            999
          </e:case>
          <e:case value="2">
            latn_id || ''
          </e:case>
          <e:case value="3">
            b.county_id
          </e:case>
          <e:case value="4">
            b.town_id
          </e:case>
        </e:switch>
        org_id,
        ${sql_column2}
        FROM ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY a
        <e:switch value="${param.flg}">
          <e:case value="3">
            ,
            (select distinct county_id,bureau_no from EDW.VW_TB_CDE_VILLAGE@GSEDW where county_id = '${param.region_id}') b
          </e:case>
          <e:case value="4">
            ,
            (select distinct town_id,branch_no from EDW.VW_TB_CDE_VILLAGE@GSEDW where town_id = '${param.region_id}') b
          </e:case>
        </e:switch>
        WHERE stat_date = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')
        AND stat_lvl =
        <e:switch value="${param.flg}">
          <e:case value="1">
            1
          </e:case>
          <e:case value="2">
            1 AND latn_id = '${param.region_id}'
            GROUP BY latn_id
          </e:case>
          <e:case value="3">
            2 AND a.bureau_no = b.bureau_no
            GROUP BY b.county_id
          </e:case>
          <e:case value="4">
            3 AND a.branch_no = b.branch_no
            GROUP BY b.town_id
          </e:case>
        </e:switch>

        UNION ALL

        SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            latn_id
          </e:case>
          <e:case value="2">
            county_id
          </e:case>
          <e:case value="3">
            town_id
          </e:case>
          <e:case value="4">
            brigade_id
          </e:case>
        </e:switch>
        org_id,
        ${sql_column2}
        FROM ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY a
        <e:switch value="${param.flg}">
          <e:case value="2">
            ,
            (select distinct latn_id,county_id from EDW.VW_TB_CDE_VILLAGE@GSEDW where city_id = '${param.region_id}') b
          </e:case>
          <e:case value="3">
            ,
            (select distinct bureau_no,town_id from EDW.VW_TB_CDE_VILLAGE@GSEDW where county_id = '${param.region_id}') b
          </e:case>
          <e:case value="4">
            ,
            (select distinct branch_no,brigade_id from EDW.VW_TB_CDE_VILLAGE@GSEDW where town_id = '${param.region_id}') b
          </e:case>
        </e:switch>
        WHERE stat_date = to_char(to_date('${param.accDate}','yyyymmdd')-1,'yyyymmdd')
        AND stat_lvl =
        <e:switch value="${param.flg}">
          <e:case value="1">
            1 group by latn_id
          </e:case>
          <e:case value="2">
            2 AND a.latn_id = b.latn_id
            GROUP BY b.county_id
          </e:case>
          <e:case value="3">
            3 AND a.bureau_no = b.bureau_no
            GROUP BY b.town_id
          </e:case>
          <e:case value="4">
            4 AND a.branch_no = b.branch_no
            GROUP BY b.brigade_id
          </e:case>
        </e:switch>
        )e,
        <e:description>营销派单 end</e:description>

        <e:description>行政村数 begin</e:description>
        (SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            '999'
          </e:case>
          <e:case value="2">
            city_id || ''
          </e:case>
          <e:case value="3">
            county_id
          </e:case>
          <e:case value="4">
            town_id
          </e:case>
        </e:switch>
        org_id,
        count(DISTINCT village_id) vc_cnt
        FROM EDW.VW_TB_CDE_VILLAGE@GSEDW
        WHERE 1 = 1
        <e:switch value="${param.flg}">
          <e:case value="2">
            and city_id = '${param.region_id}' GROUP BY city_id
          </e:case>
          <e:case value="3">
            and county_id = '${param.region_id}' GROUP BY county_id
          </e:case>
          <e:case value="4">
            and town_id = '${param.region_id}' GROUP BY town_id
          </e:case>
        </e:switch>
        UNION ALL
        SELECT
        <e:switch value="${param.flg}">
          <e:case value="1">
            city_id || ''
          </e:case>
          <e:case value="2">
            county_id
          </e:case>
          <e:case value="3">
            town_id
          </e:case>
          <e:case value="4">
            brigade_id
          </e:case>
        </e:switch>
        org_id,
        count(DISTINCT village_id) vc_cnt
        FROM EDW.VW_TB_CDE_VILLAGE@GSEDW
        GROUP BY
        <e:switch value="${param.flg}">
          <e:case value="1">
            city_id
          </e:case>
          <e:case value="2">
            county_id
          </e:case>
          <e:case value="3">
            town_id
          </e:case>
          <e:case value="4">
            brigade_id
          </e:case>
        </e:switch>
        ) c
        <e:description>行政村数 end</e:description>

        WHERE d.org_id = e.org_id(+)
        and d.org_id = c.org_id

        )f WHERE rn <= ${param.page+1}*${param.pageSize} and rn >${param.page}*${param.pageSize}
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>