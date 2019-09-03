<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
  <e:description>省级概况 显示全省及各地市</e:description>
  <e:case value="province">
    <c:tablequery>
      SELECT
      0 latn_id,
      '全省' LATN_NAME,
      sum(NVL(KD_ALL, 0)) KD_ALL,
      sum(NVL(KD_D_CNT, 0)) KD_D_CNT,
      sum(NVL(KD_RH_CNT, 0)) KD_RH_CNT,
      sum(NVL(EXP_ALL, 0)) EXP_ALL,
      sum(NVL(EXP_YEAR, 0)) EXP_YEAR,
      sum(NVL(EXP_COMP, 0)) EXP_COMP,
      '0' CITY_ORDER_NUM
      FROM (SELECT DISTINCT LATN_ID, LATN_NAME, CITY_ORDER_NUM
      FROM ${gis_user}.DB_CDE_GRID
      WHERE GRID_STATUS = 1) E,
      (SELECT A.LATN_ID,
      KD_ALL,
      KD_D_CNT,
      KD_RH_CNT,
      EXP_ALL,
      EXP_YEAR,
      EXP_COMP
      FROM ${gis_user}.TB_GIS_ADDR_KD_ALL_D A,
      (SELECT LATN_ID,
      COUNT(ADDRESS_ID) EXP_ALL,
      COUNT(DECODE(TYPE, 21, ADDRESS_ID)) EXP_YEAR,
      COUNT(DECODE(TYPE, 22, ADDRESS_ID)) EXP_COMP
      FROM ${gis_user}.TB_GIS_ADDR_KD_YX_D A
      WHERE ZHU_HU_COUNT >= 100
      AND A.LATN_ID IS NOT NULL
      AND A.VILLAGE_ID IS NOT NULL
      AND A.BRANCH_TYPE = 'a1'
      GROUP BY A.LATN_ID) C
      WHERE A.LATN_ID = C.LATN_ID(+)) A
      WHERE E.LATN_ID = A.LATN_ID(+)

      UNION

      SELECT
      E.LATN_ID,
      E.LATN_NAME,
      NVL(KD_ALL, 0) KD_ALL,
      NVL(KD_D_CNT, 0) KD_D_CNT,
      NVL(KD_RH_CNT, 0) KD_RH_CNT,
      NVL(EXP_ALL, 0) EXP_ALL,
      NVL(EXP_YEAR, 0) EXP_YEAR,
      NVL(EXP_COMP, 0) EXP_COMP,
      CITY_ORDER_NUM
      FROM (SELECT DISTINCT LATN_ID, LATN_NAME, CITY_ORDER_NUM
      FROM ${gis_user}.DB_CDE_GRID
      WHERE GRID_STATUS = 1) E,
      (SELECT A.LATN_ID,
      KD_ALL,
      KD_D_CNT,
      KD_RH_CNT,
      EXP_ALL,
      EXP_YEAR,
      EXP_COMP
      FROM ${gis_user}.TB_GIS_ADDR_KD_ALL_D A,
      (SELECT LATN_ID,
      COUNT(ADDRESS_ID) EXP_ALL,
      COUNT(DECODE(TYPE, 21, ADDRESS_ID)) EXP_YEAR,
      COUNT(DECODE(TYPE, 22, ADDRESS_ID)) EXP_COMP
      FROM ${gis_user}.TB_GIS_ADDR_KD_YX_D A
      WHERE ZHU_HU_COUNT >= 100
      AND A.LATN_ID IS NOT NULL
      AND A.VILLAGE_ID IS NOT NULL
      AND A.BRANCH_TYPE = 'a1'
      GROUP BY A.LATN_ID) C
      WHERE A.LATN_ID = C.LATN_ID(+)) A
      WHERE E.LATN_ID = A.LATN_ID(+)
      ORDER BY CITY_ORDER_NUM
    </c:tablequery>
  </e:case>

  <e:description>市级概况 显示区县</e:description>
  <e:case value="city">
    <c:tablequery>
      SELECT
        A.CITY_ORDER_NUM,
        A.REGION_ORDER_NUM,
        A.BUREAU_NO,
        A.LATN_ID,
        A.LATN_NAME,
        A.BUREAU_NAME,
        nvl(A.BRANCH_NUM,0) BRANCH_NUM,
        nvl(A.GRID_NUM,0) GRID_NUM,
        nvl(A.VILLAGE_NUM,0) VILLAGE_NUM,
        nvl(A.BRANCH_V,0) BRANCH_V,
        nvl(A.GRID_V,0) GRID_V
      FROM ${gis_user}.VIEW_GIS_BUREAU_COUNT A
      WHERE 1 = 1
      <e:if condition="${!empty param.city_id1 && param.city_id1 ne '999'}">
        AND A.LATN_ID='${param.city_id1}'
      </e:if>
      <e:if condition="${empty param.city_id1}">
        AND A.LATN_ID='${param.city_id}'
      </e:if>
      ORDER BY A.REGION_ORDER_NUM
    </c:tablequery>
  </e:case>

  <e:description>区县概况 显示网格下小区情况</e:description>
  <e:case value="grid">
    <c:tablequery>
      select t.latn_id,t.latn_name,
      t.bureau_no,t.bureau_name,
      t.union_org_code,t.branch_no,t.branch_name,
      decode(grid_union_org_code,-1,null,t.grid_id) grid_id,
      decode(grid_union_org_code,-1,null,t.grid_name) grid_name,
      NVL(VILLAGE_SUM,0) VILLAGE_SUM,
      NVL(YX_SUM,0) YX_SUM,
      NVL(YX_DONE,0) YX_DONE,
      case when a.yx_v is null then '--' else A.YX_V end YX_V,
      nvl(a.addr_num,0) addr_num,
      nvl(a.ftth_port_num,0) ftth_port_num,
      nvl(a.ftth_port_zy_num,0) ftth_port_zy_num,
      CASE WHEN NVL(A.FTTH_PORT_ZY_NUM, 0)=0 THEN '--' ELSE to_char(ROUND(A.FTTH_PORT_ZY_NUM/A.FTTH_PORT_NUM,4)*100,'990.90')||'%' END PORT_V
      from ${gis_user}.db_cde_grid t,(
      select a.*,case when nvl(yx_sum,0)=0 then null else to_char(round(yx_done/yx_sum,4)*100,'990.90') end yx_v from (
      select a.*,c.addr_num,c.ftth_port_num,c.ftth_port_zy_num from
      (select latn_id,addr_num,ftth_port_num,ftth_port_zy_num from ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON where statis_mon='${param.acct_date}' and flag=5) c,
      (SELECT a.bureau_no,
      a.bureau_name,
      a.branch_no,
      a.branch_name,
      a.grid_id,
      a.grid_name,
      count(distinct village_id) village_sum,
      count(ADDRESS_ID) yx_sum,
      count(decode(did_flag,null,null,ADDRESS_ID)) yx_done
      FROM ${gis_user}.TB_GIS_ADDR_KD_YX_D a where branch_type='a1' and grid_id is not null
      group by a.bureau_no,
      a.bureau_name,
      a.branch_no,
      a.branch_name,
      a.grid_id,
      a.grid_name) a
      where a.grid_id =c.latn_id
      union
      select a.*,c.addr_num,c.ftth_port_num,c.ftth_port_zy_num from
      (select latn_id,addr_num,ftth_port_num,ftth_port_zy_num from ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON where statis_mon='${param.acct_date}' and flag=4) c,
      (SELECT a.bureau_no,
      a.bureau_name,
      a.branch_no,
      a.branch_name,
      a.grid_id,
      a.grid_name,
      count(distinct village_id) village_sum,
      count(ADDRESS_ID) yx_sum,
      count(decode(did_flag,null,null,ADDRESS_ID)) yx_done
      FROM ${gis_user}.TB_GIS_ADDR_KD_YX_D a where branch_type='a1' and grid_id is null
      group by a.bureau_no,
      a.bureau_name,
      a.branch_no,
      a.branch_name,
      a.grid_id,
      a.grid_name) a
      where a.grid_id =c.latn_id) a) a
      where t.grid_id = a.grid_id(+)
      and t.grid_status=1 and t.branch_type='a1'
      <e:if condition="${!empty param.city_id1}" var="empty_city_id1">
        AND T.latn_id = '${param.city_id1}'
      </e:if>
      <e:else condition="${empty_city_id1}">
        AND T.latn_id = '${param.city_id}'
      </e:else>
      <e:if condition="${!empty param.bureau_id2}" var="empty_bureau_id2">
      </e:if>
      <e:else condition="${empty_bureau_id2}">
        <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
          AND T.BUREAU_NO='${param.bureau_id1}'
        </e:if>
        <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id && param.bureau_id ne '999'}">
          AND T.BUREAU_NO='${param.bureau_id}'
        </e:if>
      </e:else>
      AND T.GRID_ID IS NOT NULL
      <e:if condition="${!empty param.branch_no}">
        AND T.union_org_code = '${param.branch_no}'
      </e:if>
      <e:if condition="${!empty param.grid_id && param.grid_id ne '999'}">
        AND T.grid_id = '${param.grid_id}'
      </e:if>
      <e:if condition="${!empty param.text}">
        AND (bureau_name LIKE '%${param.text}%' OR branch_name LIKE '%${param.text}%' OR grid_name LIKE '%${param.text}%')
      </e:if>
      order by t.city_order_num,t.region_order_num,t.branch_no,t.grid_id
    </c:tablequery>
  </e:case>

  <e:description>网格下 展示各小区详细的情况</e:description>
  <e:case value="ying_xiao">
    <c:tablequery>
      SELECT LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      BRANCH_NO,
      BRANCH_NAME,
      GRID_ID,
      GRID_NAME,
      JR_NBR,
      <e:description>2018.10.22 号码脱敏</e:description>
      decode(USER_CONTACT_NBR,null,'--',nvl((substr(USER_CONTACT_NBR,0,3) || '******' || substr(USER_CONTACT_NBR,10,2)),'--')) USER_CONTACT_NBR,
      DECODE(COMP_FLAG, 1, '是', '否') COMP_FLAG,
      ACC_NBR,
      to_char(to_date(exp_date,'yyyymmdd'),'yyyy-mm-dd') EXP_DATE,
      C.VILLAGE_NAME
      FROM (SELECT *
      FROM ${gis_user}.TB_GIS_ADDR_KD_YX_D
      WHERE BRANCH_TYPE = 'a1'
      <e:if condition="${!empty param.city_id1}" var="empty_city_id1">
        AND LATN_ID = '${param.city_id1}'
      </e:if>
      <e:else condition="${empty_city_id1 && !empty param.city_id}">
        AND LATN_ID = '${param.city_id}'
      </e:else>
      <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
        and bureau_no = '${param.bureau_id1}'
      </e:if>
      <e:if condition="${empty param.bureau_id1}">
        and bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id1 && param.branch_id1 ne '999'}">
        and union_org_code = '${param.branch_id1}'
      </e:if>
      <e:if condition="${empty param.branch_id1}">
        and union_org_code = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id1}" var="empty_grid_id1">
        <e:if condition="${param.grid_id1 ne '999'}">
          AND GRID_ID = '${param.grid_id1}'
        </e:if>
      </e:if>
      <e:else condition="${empty_grid_id1 && !empty param.grid_id}">
        AND GRID_ID = '${param.grid_id}'
      </e:else>
      <e:if condition="${!empty param.text}">
        AND (BRANCH_NAME LIKE '%${param.text}%' or GRID_NAME like '%${param.text}%' or VILLAGE_NAME like '%${param.text}%')
      </e:if>
      ) T
      LEFT JOIN (SELECT A.SEGM_ID, B.VILLAGE_NAME
      FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4     A,
      ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO B
      WHERE A.VILLAGE_ID = B.VILLAGE_ID) C
      ON T.SEGM_ID = C.SEGM_ID
      ORDER BY BUREAU_NO, BRANCH_NO, GRID_ID,VILLAGE_NAME,exp_date ASC
    </c:tablequery>
  </e:case>

  <e:description>获取地市下的区县</e:description>
  <e:case value="getBureauByCityId">
    <e:q4l var="dataList">
      SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM ${gis_user}.db_cde_grid WHERE latn_id = '${param.city_id}' AND branch_type = 'a1' order by REGION_ORDER_NUM
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取区县下的支局</e:description>
  <e:case value="getBranchByBureauId">
    <e:q4l var="dataList">
      SELECT DISTINCT T.UNION_ORG_CODE,T.BRANCH_NO,T.BRANCH_NAME,'支局列表' b
      FROM ${gis_user}.DB_CDE_GRID T
      WHERE T.BUREAU_NO = '${param.bureau_id}' AND branch_type = 'a1'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByBranchId">
    <e:q4l var="dataList">
      select DISTINCT grid_id,grid_name,'网格列表' c from ${gis_user}.DB_CDE_GRID t WHERE UNION_ORG_CODE = '${param.branch_id}' AND branch_type = 'a1' AND grid_status = 1 and grid_union_org_code <> -1
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>