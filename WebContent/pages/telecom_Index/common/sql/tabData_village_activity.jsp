<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="sql_part_column1">
  org_id|| '' org_id,
  org_name,
  nvl(campaign_all_num,0) campaign_all_num,
  nvl(campaign_day_num,0) campaign_day_num,
  nvl(campaign_mon_num,0) campaign_mon_num
</e:set>
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
      <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
        where st_latn_id = '${param.city_id}'
      </e:if>
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

  <e:description>小区活动统计</e:description>
  <e:case value="getListSummary">
    <e:q4l var="dataList">
      SELECT * FROM (
      SELECT c.*,count(1) over() c_num,row_number() OVER(ORDER BY POS) rn FROM (
      SELECT ${sql_part_column1},'0' pos FROM gs_small_org.VM_CITY_CAMPAIGN_${param.flag-1}@gsedw
      WHERE org_id =
      <e:switch value="${param.flag}">
        <e:case value="1">
          0
        </e:case>
        <e:case value="2">
          '${param.city_id}'
        </e:case>
        <e:case value="3">
          '${param.bureau_id}'
        </e:case>
        <e:case value="4">
          '${param.branch_id}'
        </e:case>
        <e:case value="5">
          '${param.grid_id}'
        </e:case>
      </e:switch>
      UNION ALL
      select ${sql_part_column1},pos||'' pos from gs_small_org.VM_CITY_CAMPAIGN_${param.flag}@gsedw
      WHERE parent_id =
      <e:switch value="${param.flag}">
        <e:case value="1">
          0
        </e:case>
        <e:case value="2">
          '${param.city_id}'
        </e:case>
        <e:case value="3">
          '${param.bureau_id}'
        </e:case>
        <e:case value="4">
          '${param.branch_id}'
        </e:case>
        <e:case value="5">
          '${param.grid_id}'
        </e:case>
      </e:switch>
      AND org_id IS NOT null)c
      )WHERE rn <=${param.page+1}*${param.pageSize} AND rn > ${param.page}*${param.pageSize}
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>