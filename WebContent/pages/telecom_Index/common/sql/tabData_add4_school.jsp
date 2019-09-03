<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:switch value="${param.eaction}">

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByBranchId">
    <e:q4l var="dataList">
      select '-1' val,'请选择' name from dual
      <e:if condition="${!empty param.grid_id}" var="single">
        union all
        select distinct grid_union_org_code val,grid_name name from ${gis_user}.db_cde_grid
        where grid_union_org_code = '${param.grid_id}'
      </e:if>
      <e:else condition="${single}">
        <e:if condition="${!empty param.branch_id}">
          union all
          select distinct grid_union_org_code val,grid_name name from ${gis_user}.db_cde_grid
          where union_org_code = '${param.branch_id}'
          and grid_union_org_code <> -1 and grid_union_org_code is not null
        </e:if>
      </e:else>
      order by val
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取网格下的小区</e:description>
  <e:case value="getVillageIdByGridId">
    <e:q4l var="dataList">
      SELECT village_id val,village_name name FROM ${gis_user}.tb_gis_village_edit_info
      WHERE grid_id_2 = '${param.grid_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>四级地址查询</e:description>
  <e:case value="getAdd4List">
    <e:q4l var="dataList">
      select * from (
      select
      /*+parallel(al,10)*/
      a.latn_id,
      al.segm_id,
      al.stand_name,
      nvl(al.zhu_hu_count,0) zhu_hu_count,
      nvl(d.obd_cnt,0) obd_cnt,
      nvl(d.port_id_cnt,0) port_id_cnt,
      nvl(d.use_port_cnt,0) use_port_cnt,
      to_char(decode(nvl(d.port_id_cnt,0),0,0,round(nvl(d.use_port_cnt,0)/nvl(d.port_id_cnt,0),4)*100),'FM9999999990.00')||'%' port_lv,
      decode(nvl(al.is_st,0),0,'否','是') gis_flg,
      nvl(to_char(al.st_create_date,'yyyy-mm-dd'),' ') gis_date,
      nvl(c.village_name,' ') village_name,
      nvl(to_char(c.create_time,'yyyy-mm-dd'),' ') create_time,
      nvl(a.branch_name,' ') branch_name,
      nvl(a.grid_name,' ') grid_name,
      to_char(al.create_date,'yyyy-mm-dd') create_date,
      count(1) over() C_NUM,
      row_number() over(order by a.segm_id) ROW_NUM
      from
      (
      select * from ${gis_user}.TB_GIS_ADDR_INFO_VIEW
      where 1=1
      <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
        and st_latn_id = '${param.city_id}'
      </e:if>
        and serial_no = '3'
      ) al
      left join
      (select * from sde.TB_GIS_MAP_SEGM_LATN_MON where branch_type = 'a1') a
      on al.segm_id = a.segm_id
      left join
      (select * from ${gis_user}.TB_GIS_RES_INFO_DAY where flg = 6) d
      on a.segm_id = d.latn_id
      left join
      ${gis_user}.TB_GIS_VILLAGE_ADDR4 b
      on a.segm_id = b.segm_id
      left join
      ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO c
      on b.village_id = c.village_id
      where 1=1
      and
      (
      (1=1
      and a.segm_id is not null
      <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
        and a.latn_id = '${param.city_id}'
      </e:if>
      <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
        and a.bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
        and a.union_org_code = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id && param.grid_id ne '-1'}">
        and a.grid_id = '${param.grid_id}'
      </e:if>
      <e:if condition="${!empty param.village_id && param.village_id ne '-1'}">
        and b.village_id = '${param.village_id}'
      </e:if>)
      <e:if condition="${!empty param.add4_name}">
        or al.stand_name LIKE '%${param.add4_name}%'
      </e:if>
      )
      <e:if condition="${!empty param.in_vill_radio}">
        <e:if condition="${param.in_vill_radio eq '1'}">
          and b.village_id is not null
        </e:if>
        <e:if condition="${param.in_vill_radio eq '0'}">
          and b.village_id is null
        </e:if>
      </e:if>
      <e:if condition="${!empty param.gis_radio}">
        <e:if condition="${param.gis_radio eq '3'}">
          and months_between(sysdate,al.st_create_date) <= 3
        </e:if>
        <e:if condition="${param.gis_radio eq '6'}">
          and months_between(sysdate,al.st_create_date) <= 6
        </e:if>
      </e:if>
      <e:if condition="${!empty param.res_radio}">
        and d.no_res_arrive_cnt = '${param.res_radio}'
      </e:if>
      )
      <e:if condition="${!empty param.page}">
        WHERE ROW_NUM BETWEEN ${param.page} * ${param.pageSize} + 1 AND (${param.page} + 1) * ${param.pageSize}
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>四级地址统计</e:description>
  <e:case value="getAdd4Summary">
    <e:q4l var="dataList">
      <e:if condition="${param.flag ne '5'}">
        SELECT *
        FROM (SELECT A.*,
        COUNT(1) OVER() C_NUM,
        ROW_NUMBER() OVER(ORDER BY ORDER_NUM) ROW_NUM
        FROM (SELECT
        B.ORG_ID|| '' ORG_ID,
        B.ORG_NAME,
        A.ADD4_CNT,
        A.HAD_RES_CNT,
        to_char(decode(nvl(A.ADD4_CNT,0),0,0,round(nvl(A.HAD_RES_CNT,0)/A.ADD4_CNT,4))*100,'FM9999999990.00') || '%' had_res_percent,
        A.WJ_CNT NO_IN_VILL_CNT,
        A.WJ_ARRIVE_CNT NO_IN_VILL_HAD_RES_CNT,
        to_char(decode(nvl(A.WJ_CNT,0),0,0,round(nvl(A.WJ_ARRIVE_CNT,0)/A.WJ_CNT,4))*100,'FM9999999990.00') || '%' no_in_vill_had_res_percent,
        0 || '' ORDER_NUM
        FROM (SELECT LATN_ID org_id,
        LY_CNT ADD4_CNT,
        LY_CNT - NO_RES_ARRIVE_CNT HAD_RES_CNT,
        WJ_CNT,
        WJ_ARRIVE_CNT
        FROM ${gis_user}.TB_GIS_RES_CITY_DAY
        WHERE FLG = ${param.flag-1}
        AND BRANCH_TYPE = 'a1'
        <e:if condition="${param.flag ne '1'}">
          AND latn_id =
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            ${param.city_id}
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            ${param.bureau_id}
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            ${param.branch_id}
          </e:if>
        </e:if>
        ) A,
        (
        select
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            distinct 999||'' org_id,'全省' org_name,0 order_num
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            distinct latn_id org_id,latn_name org_name,city_order_num order_num
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            distinct bureau_no org_id,bureau_name org_name,region_order_num order_num
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            distinct union_org_code org_id,branch_name org_name,union_org_code order_num
          </e:if>
        </e:if>
        from ${gis_user}.db_cde_grid
        where 1=1
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            and latn_id = '${param.city_id}'
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            and bureau_no = '${param.bureau_id}'
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            and union_org_code = '${param.branch_id}'
          </e:if>
        </e:if>
        AND grid_union_org_code IS NOT NULL AND grid_union_org_code <> -1
        ) b
        WHERE a.org_id = b.org_id

        UNION ALL

      </e:if>

      SELECT
      b.ORG_ID || '' ORG_ID,
      b.ORG_NAME,
      A.ADD4_CNT,
      A.HAD_RES_CNT,
      to_char(decode(nvl(A.ADD4_CNT,0),0,0,round(nvl(A.HAD_RES_CNT,0)/A.ADD4_CNT,4))*100,'FM9999999990.00') || '%' had_res_percent,
      a.wj_cnt NO_IN_VILL_CNT,
      a.wj_arrive_cnt NO_IN_VILL_HAD_RES_CNT,
      to_char(decode(nvl(A.WJ_CNT,0),0,0,round(nvl(A.WJ_ARRIVE_CNT,0)/A.WJ_CNT,4))*100,'FM9999999990.00') || '%' no_in_vill_had_res_percent,
      B.ORDER_NUM
      <e:if condition="${param.flag eq '5'}">
        ,COUNT(1) OVER() C_NUM,
        ROW_NUMBER() OVER(ORDER BY ORDER_NUM) ROW_NUM
      </e:if>
      FROM (
      select
      <e:if condition="${param.flag eq '1'}">
        <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
          distinct latn_id org_id,latn_name org_name,city_order_num order_num
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          distinct bureau_no org_id,bureau_name org_name,region_order_num order_num
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3'}">
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          distinct union_org_code org_id,branch_name org_name,union_org_code order_num
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '4' || param.flag eq '5'}">
        <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
          distinct grid_id org_id,grid_name org_name,grid_id order_num
        </e:if>
      </e:if>
      from ${gis_user}.db_cde_grid
      where 1=1
      <e:if condition="${param.flag eq '2'}">
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          and latn_id = '${param.city_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '3'}">
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          and bureau_no = '${param.bureau_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '4'}">
        <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
          and union_org_code = '${param.branch_id}'
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '5'}">
        <e:if condition="${!empty param.grid_id && param.grid_id ne '-1'}">
          and grid_id = '${param.grid_id}'
        </e:if>
      </e:if>
      AND grid_union_org_code IS NOT NULL AND grid_union_org_code <> -1
      ) B,
      (SELECT
      LATN_ID org_id,
      LY_CNT ADD4_CNT,
      LY_CNT - NO_RES_ARRIVE_CNT HAD_RES_CNT,
      wj_cnt,
      wj_arrive_cnt
      FROM ${gis_user}.TB_GIS_RES_CITY_DAY
      WHERE FLG =
      <e:if condition="${param.flag eq '5'}">
        ${param.flag -1}
      </e:if>
      <e:if condition="${param.flag ne '5'}">
        ${param.flag}
      </e:if>
      AND BRANCH_TYPE = 'a1') A
      WHERE a.org_id = b.org_id
      <e:if condition="${param.flag ne '5'}">
      ) A
      ORDER BY ORDER_NUM)
        <e:if condition="${!empty param.page}">
          WHERE ROW_NUM BETWEEN ${param.page} * ${param.pageSize} + 1 AND (${param.page} + 1) * ${param.pageSize}
        </e:if>
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>四级地址统计 已添加字段 已废弃</e:description>
  <e:case value="getAdd4Summary_no_use_bak1">
    <e:q4l var="dataList">
      <e:if condition="${param.flag ne '5'}">
        select * from(
        SELECT a.*,
        COUNT(1) OVER() C_NUM,
        ROW_NUMBER() OVER(ORDER BY ORDER_NUM) ROW_NUM
        FROM (
        select
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            c.LATN_ID || '' ORG_ID,
            c.LATN_NAME || '' ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            c.LATN_ID || '' ORG_ID,
            c.LATN_NAME || '' ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            c.BUREAU_NO ORG_ID,
            c.BUREAU_NAME ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            c.UNION_ORG_CODE ORG_ID,
            c.BRANCH_NAME ORG_NAME,
          </e:if>
        </e:if>
        a.ADD4_CNT,a.HAD_RES_CNT,c.NO_IN_VILL_CNT,c.NO_IN_VILL_HAD_RES_CNT,0 || '' order_num
        from
        (SELECT
          latn_id,
          ly_cnt ADD4_CNT,
          ly_cnt - no_res_arrive_cnt HAD_RES_CNT
          FROM ${gis_user}.TB_GIS_RES_city_DAY
          where flg = ${param.flag-1}
          and branch_type = 'a1'
        ) a,
        (select
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            999 latn_id,
            '全省' latn_name,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            a.LATN_ID,
            a.LATN_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            a.BUREAU_NO,
            a.BUREAU_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            a.UNION_ORG_CODE,
            a.BRANCH_NAME,
          </e:if>
        </e:if>
        count(a.segm_id) NO_IN_VILL_CNT,
        count(decode(d.NO_RES_ARRIVE_CNT, 1, a.segm_id, null)) NO_IN_VILL_HAD_RES_CNT
        from sde.TB_GIS_MAP_SEGM_LATN_MON  a,
        ${gis_user}.TB_GIS_VILLAGE_ADDR4 c,
        ${gis_user}.TB_GIS_RES_INFO_DAY  d
        where a.segm_id = c.segm_id(+)
        and a.segm_id = d.latn_id(+)
        and c.segm_id is null
        and a.branch_type = 'a1'
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            and a.LATN_ID = '${param.city_id}'
              group by a.latn_id,a.latn_name
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            and a.bureau_no = '${param.bureau_id}'
              group by a.bureau_no,a.bureau_name
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            and a.union_org_code = '${param.branch_id}'
              group by a.union_org_code,a.branch_name
          </e:if>
        </e:if>
        ) c
        where 1=1
        <e:if condition="${param.flag eq '2'}">
          AND a.latn_id = c.LATN_ID
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          AND a.latn_id = c.BUREAU_NO
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          AND a.latn_id = c.union_org_code
        </e:if>

        union all

        select
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            c.LATN_ID || '' ORG_ID,
            c.LATN_NAME || '' ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            c.BUREAU_NO || '' ORG_ID,
            c.BUREAU_NAME || '' ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            c.UNION_ORG_CODE ORG_ID,
            c.BRANCH_NAME ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            c.GRID_ID ORG_ID,
            c.GRID_NAME ORG_NAME,
          </e:if>
        </e:if>
        a.ADD4_CNT,a.HAD_RES_CNT,c.NO_IN_VILL_CNT,c.NO_IN_VILL_HAD_RES_CNT,b.order_num
        from
        (
          select
          <e:if condition="${param.flag eq '1'}">
            <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
              distinct latn_id,latn_name,city_order_num order_num
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
              distinct bureau_no,bureau_name,region_order_num order_num
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
              distinct union_org_code,branch_name,union_org_code order_num
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '4'}">
            <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
              distinct grid_id,grid_name,grid_id order_num
            </e:if>
          </e:if>
          from ${gis_user}.db_cde_grid
          where 1=1
          <e:if condition="${param.flag eq '2'}">
            <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
              and latn_id = '${param.city_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '3'}">
            <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
              and bureau_no = '${param.bureau_id}'
            </e:if>
          </e:if>
          <e:if condition="${param.flag eq '4'}">
            <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
              and union_org_code = '${param.branch_id}'
            </e:if>
          </e:if>
        ) b,
        (SELECT
            latn_id,
            ly_cnt ADD4_CNT,
            ly_cnt - no_res_arrive_cnt HAD_RES_CNT
            FROM ${gis_user}.TB_GIS_RES_city_DAY
            where flg = ${param.flag}
            and branch_type = 'a1'
        ) a,
        (select
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            a.latn_id,
            a.latn_name,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            a.BUREAU_NO,
            a.BUREAU_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            a.UNION_ORG_CODE,
            a.BRANCH_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            a.GRID_ID,
            a.GRID_NAME,
          </e:if>
        </e:if>
        count(a.segm_id) NO_IN_VILL_CNT,
        count(decode(d.NO_RES_ARRIVE_CNT, 1, a.segm_id, null)) NO_IN_VILL_HAD_RES_CNT
        from sde.TB_GIS_MAP_SEGM_LATN_MON  a,
        ${gis_user}.TB_GIS_VILLAGE_ADDR4 c,
        ${gis_user}.TB_GIS_RES_INFO_DAY  d
        where a.segm_id = c.segm_id(+)
        and a.segm_id = d.latn_id(+)
        and c.segm_id is null
        and a.branch_type = 'a1'
        group by
        <e:if condition="${param.flag eq '1'}">
          A.LATN_ID,A.LATN_NAME
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          A.bureau_no, A.bureau_name
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          A.union_org_code, A.branch_name
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          A.grid_id, A.grid_name
        </e:if>
        ) c
        where
        <e:if condition="${param.flag eq '1'}">
          a.latn_id = c.latn_id
          AND a.latn_id = b.latn_id
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          a.latn_id = c.bureau_no
          AND a.latn_id = b.bureau_no
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          a.latn_id = c.union_org_code
          AND a.latn_id = b.union_org_code
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          a.latn_id = c.grid_id
          AND a.latn_id = b.grid_id
        </e:if>
        )a
        ORDER BY order_num
        )
        <e:if condition="${!empty param.page}">
          WHERE ROW_NUM BETWEEN ${param.page} * 20 + 1 AND (${param.page} + 1) * 20
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '5'}">
        SELECT *
        FROM (SELECT /*+parallel(al,10)*/
        A.GRID_ID ORG_ID,
        A.GRID_NAME ORG_NAME,
        COUNT(A.SEGM_ID) ADD4_CNT,
        COUNT(DECODE(D.NO_RES_ARRIVE_CNT, 1, 1, NULL)) HAD_RES_CNT,
        COUNT(DECODE(B.VILLAGE_ID, NULL, 1, NULL)) NO_IN_VILL_CNT,
        COUNT(CASE
        WHEN D.NO_RES_ARRIVE_CNT = 1 AND
        B.VILLAGE_ID IS NULL THEN
        1
        ELSE
        NULL
        END) NO_IN_VILL_HAD_RES_CNT,
        C.ORDER_NUM,
        COUNT(1) OVER() C_NUM
        FROM
        (SELECT DISTINCT GRID_ID,
        GRID_NAME,
        GRID_ID ORDER_NUM
        FROM ${gis_user}.DB_CDE_GRID
        WHERE 1 = 1
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          AND LATN_ID = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          AND BUREAU_NO = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.grid_id && param.grid_id ne '-1'}">
          AND grid_id = '${param.grid_id}'
        </e:if>
        ) C
        left join
        (SELECT *
        FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
        WHERE BRANCH_TYPE = 'a1') A
        ON C.GRID_ID = A.GRID_ID
        LEFT JOIN (SELECT *
        FROM ${gis_user}.TB_GIS_RES_INFO_DAY
        WHERE FLG = 6) D
        ON A.SEGM_ID = D.LATN_ID
        LEFT JOIN ${gis_user}.TB_GIS_VILLAGE_ADDR4 B
        ON A.SEGM_ID = B.SEGM_ID
        WHERE 1 = 1
        AND (1 = 1
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          AND A.LATN_ID = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          AND A.BUREAU_NO = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.grid_id && param.grid_id ne '-1'}">
          AND A.grid_id  = '${param.grid_id}'
        </e:if>
        )
        GROUP BY A.BUREAU_NO,
        A.BUREAU_NAME,
        A.UNION_ORG_CODE,
        A.BRANCH_NAME,
        A.GRID_ID,
        A.GRID_NAME,
        C.ORDER_NUM)
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>四级地址统计 查询慢 已废弃</e:description>
  <e:case value="getAdd4Summary_no_use_bak">
    <e:q4l var="dataList">
      <e:if condition="${param.flag ne '5'}">
        SELECT * FROM (
        SELECT a.*, COUNT(1) OVER() C_NUM,
        ROW_NUMBER() OVER(ORDER BY ORDER_NUM) ROW_NUM
        FROM (
        SELECT /*+parallel(al,10)*/
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            999 ORG_ID,
            '全省' ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            A.LATN_ID || '' ORG_ID,
            A.LATN_NAME || '' ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            A.BUREAU_NO ORG_ID,
            A.BUREAU_NAME ORG_NAME,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            A.UNION_ORG_CODE ORG_ID,
            A.BRANCH_NAME ORG_NAME,
          </e:if>
        </e:if>
        COUNT(A.SEGM_ID) ADD4_CNT,
        COUNT(DECODE(D.NO_RES_ARRIVE_CNT, 1, 1, NULL)) HAD_RES_CNT,
        COUNT(DECODE(B.VILLAGE_ID, NULL, 1, NULL)) NO_IN_VILL_CNT,
        COUNT(CASE
        WHEN D.NO_RES_ARRIVE_CNT = 1 AND B.VILLAGE_ID IS NULL THEN
        1
        ELSE
        NULL
        END) NO_IN_VILL_HAD_RES_CNT,
        '0' ORDER_NUM
        FROM (SELECT *
        FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
        WHERE BRANCH_TYPE = 'a1'
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            and latn_id = '${param.city_id}'
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            and bureau_no = '${param.bureau_id}'
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            and union_org_code = '${param.branch_id}'
          </e:if>
        </e:if>
        ) A
        LEFT JOIN (SELECT * FROM ${gis_user}.TB_GIS_RES_INFO_DAY WHERE FLG = 6) D
        ON A.SEGM_ID = D.LATN_ID
        LEFT JOIN ${gis_user}.TB_GIS_VILLAGE_ADDR4 B
        ON A.SEGM_ID = B.SEGM_ID
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            GROUP BY A.LATN_ID,A.LATN_NAME
            HAVING A.LATN_ID IS NOT NULL
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            GROUP BY A.BUREAU_NO,A.BUREAU_NAME
            HAVING A.BUREAU_NO IS NOT NULL
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            GROUP BY A.UNION_ORG_CODE,A.BRANCH_NAME
            HAVING A.UNION_ORG_CODE IS NOT NULL
          </e:if>
        </e:if>

        union all

        select * from (
        select
        /*+parallel(al,10)*/
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            a.latn_id org_id,
            a.latn_name org_name,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            a.bureau_no org_id,
            a.bureau_name org_name,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            a.union_org_code org_id,
            a.branch_name org_name,
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            a.grid_id org_id,
            a.grid_name org_name,
          </e:if>
        </e:if>
        count(a.segm_id) add4_cnt,
        count(decode(d.no_res_arrive_cnt,1,1,null)) had_res_cnt,
        count(decode(b.village_id,null,1,null)) no_in_vill_cnt,
        count(case when d.no_res_arrive_cnt = 1 and b.village_id is null then 1 else null end) no_in_vill_had_res_cnt,
        c.order_num
        from
        (
        select
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            distinct latn_id,latn_name,city_order_num order_num
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            distinct bureau_no,bureau_name,region_order_num order_num
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            distinct union_org_code,branch_name,union_org_code order_num
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            distinct grid_id,grid_name,grid_id order_num
          </e:if>
        </e:if>
        from ${gis_user}.db_cde_grid
        where 1=1
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          and latn_id = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          and bureau_no = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
          and union_org_code = '${param.branch_id}'
        </e:if>
        ) c
        left join
        (select * from sde.TB_GIS_MAP_SEGM_LATN_MON where branch_type = 'a1') a
        on
        <e:if condition="${param.flag eq '1'}">
          <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
            c.latn_id = a.latn_id
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            c.bureau_no = a.bureau_no
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '3'}">
          <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            c.union_org_code = a.union_org_code
          </e:if>
        </e:if>
        <e:if condition="${param.flag eq '4'}">
          <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            c.grid_id = a.grid_id
          </e:if>
        </e:if>
        left join
        (select * from ${gis_user}.TB_GIS_RES_INFO_DAY where flg = 6) d
        on a.segm_id = d.latn_id
        left join
        ${gis_user}.TB_GIS_VILLAGE_ADDR4 b
        on a.segm_id = b.segm_id
        where 1=1
        and
        (
        1=1
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          and a.latn_id = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          and a.bureau_no = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
          and a.union_org_code = '${param.branch_id}'
        </e:if>
        )
        group by
        <e:if condition="${empty param.city_id || param.city_id eq '-1'}">
          a.latn_id,a.latn_name
        </e:if>
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          a.bureau_no,a.bureau_name
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          ,a.union_org_code,a.branch_name
        </e:if>
        <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
          ,a.grid_id,a.grid_name
        </e:if>
        ,c.order_num
        ))a
        order by order_num
        )
        <e:if condition="${!empty param.page}">
          WHERE ROW_NUM BETWEEN ${param.page} * 20 + 1 AND (${param.page} + 1) * 20
        </e:if>
      </e:if>
      <e:if condition="${param.flag eq '5'}">
        SELECT *
        FROM (SELECT /*+parallel(al,10)*/
        A.GRID_ID ORG_ID,
        A.GRID_NAME ORG_NAME,
        COUNT(A.SEGM_ID) ADD4_CNT,
        COUNT(DECODE(D.NO_RES_ARRIVE_CNT, 1, 1, NULL)) HAD_RES_CNT,
        COUNT(DECODE(B.VILLAGE_ID, NULL, 1, NULL)) NO_IN_VILL_CNT,
        COUNT(CASE
        WHEN D.NO_RES_ARRIVE_CNT = 1 AND
        B.VILLAGE_ID IS NULL THEN
        1
        ELSE
        NULL
        END) NO_IN_VILL_HAD_RES_CNT,
        C.ORDER_NUM,
        COUNT(1) OVER() C_NUM
        FROM
        (SELECT DISTINCT GRID_ID,
        GRID_NAME,
        GRID_ID ORDER_NUM
        FROM ${gis_user}.DB_CDE_GRID
        WHERE 1 = 1
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          AND LATN_ID = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          AND BUREAU_NO = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.grid_id && param.grid_id ne '-1'}">
          AND grid_id = '${param.grid_id}'
        </e:if>
        ) C
        left join
        (SELECT *
        FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
        WHERE BRANCH_TYPE = 'a1') A
        ON C.GRID_ID = A.GRID_ID
        LEFT JOIN (SELECT *
        FROM ${gis_user}.TB_GIS_RES_INFO_DAY
        WHERE FLG = 6) D
        ON A.SEGM_ID = D.LATN_ID
        LEFT JOIN ${gis_user}.TB_GIS_VILLAGE_ADDR4 B
        ON A.SEGM_ID = B.SEGM_ID
        WHERE 1 = 1
        AND (1 = 1
        <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
          AND A.LATN_ID = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
          AND A.BUREAU_NO = '${param.bureau_id}'
        </e:if>
        <e:if condition="${!empty param.grid_id && param.grid_id ne '-1'}">
          AND A.grid_id  = '${param.grid_id}'
        </e:if>
        )
        GROUP BY A.BUREAU_NO,
        A.BUREAU_NAME,
        A.UNION_ORG_CODE,
        A.BRANCH_NAME,
        A.GRID_ID,
        A.GRID_NAME,
        C.ORDER_NUM)
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>