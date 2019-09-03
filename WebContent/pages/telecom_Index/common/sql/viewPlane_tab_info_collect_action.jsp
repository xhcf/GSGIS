<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
  <e:description>分公司</e:description>
  <e:case value="province">
    <c:tablequery>
      SELECT * FROM (
      SELECT 0 latn_id,
      '全省' latn_name,
      nvl(sum(a.collect_num),0) collect_num,
      nvl(sum(a.zhu_hu_count),0) zhu_hu_count,
      nvl(sum(a.dq_1_count),0) dq_1_count,
      nvl(sum(dq_2_count),0) dq_2_count,
      nvl(sum(a.dq_1_count),0)+nvl(sum(dq_2_count),0) dq_count,
      CASE WHEN nvl(sum(zhu_hu_count),0)=0 THEN '--' ELSE trim(to_char(round(nvl(sum(collect_num),0) / nvl(sum(zhu_hu_count),0), 4)*100,'990.90')||'%') END collect_v,
      nvl(sum(no_branch_num),0) no_branch_num,
      '0' city_order_num
      FROM (SELECT A.LATN_ID,
      A.LATN_NAME,
      A.CITY_ORDER_NUM,
      NVL(SUM(A.NUM), 0) COLLECT_NUM,
      NVL(SUM(A.ZHU_HU_COUNT), 0) ZHU_HU_COUNT,
      NVL(SUM(A.DQ_1_COUNT), 0) DQ_1_COUNT,
      NVL(SUM(A.DQ_2_COUNT), 0) DQ_2_COUNT,
      NVL(ROUND(SUM(A.NUM) / SUM(A.ZHU_HU_COUNT), 4), 0)*100 COLLECT_V
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT A
      where 1=1 and
      <e:if condition="${empty param.branch_type}">
        branch_type IN ('a1','b1')
      </e:if>
      <e:if condition="${!empty param.branch_type}">
        branch_type = '${param.branch_type}'
      </e:if>
      GROUP BY A.LATN_ID, A.LATN_NAME, A.CITY_ORDER_NUM) A,
      (SELECT LATN_ID, COUNT(DISTINCT BRANCH_NO) NO_BRANCH_NUM
      FROM ${gis_user}.DB_CDE_GRID A
      WHERE NOT EXISTS (SELECT 1
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT C
      WHERE C.NUM > 0
      AND A.union_org_code = C.union_org_code)
      and
      <e:if condition="${empty param.branch_type}">
        branch_type IN ('a1','b1')
      </e:if>
      <e:if condition="${!empty param.branch_type}">
        branch_type = '${param.branch_type}'
      </e:if>
      AND GRID_STATUS = 1
      GROUP BY LATN_ID) C
      WHERE A.LATN_ID = C.LATN_ID

      UNION

      SELECT A.LATN_ID,
      A.LATN_NAME,
      A.COLLECT_NUM,
      A.ZHU_HU_COUNT,
      A.DQ_1_COUNT,
      A.DQ_2_COUNT,
      nvl(a.DQ_1_COUNT,0)+nvl(a.DQ_2_COUNT,0) dq_count,
      A.COLLECT_V,
      C.NO_BRANCH_NUM,
      a.city_order_num
      FROM (SELECT A.LATN_ID,
      A.LATN_NAME,
      A.CITY_ORDER_NUM,
      NVL(SUM(A.NUM), 0) COLLECT_NUM,
      NVL(SUM(A.ZHU_HU_COUNT), 0) ZHU_HU_COUNT,
      NVL(SUM(A.DQ_1_COUNT), 0) DQ_1_COUNT,
      NVL(SUM(A.DQ_2_COUNT), 0) DQ_2_COUNT,
      nvl(sum(a.dq_1_count),0)+nvl(sum(dq_2_count),0) dq_count,
      case WHEN SUM(a.zhu_hu_count)=0 THEN '--' ELSE trim(to_char(NVL(ROUND(SUM(A.NUM) / SUM(A.ZHU_HU_COUNT), 4), 0)*100,'990.90')||'%') END COLLECT_V
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT A
      where 1=1 and
      <e:if condition="${empty param.branch_type}">
        branch_type IN ('a1','b1')
      </e:if>
      <e:if condition="${!empty param.branch_type}">
        branch_type = '${param.branch_type}'
      </e:if>
      GROUP BY A.LATN_ID, A.LATN_NAME, A.CITY_ORDER_NUM) A,
      (SELECT LATN_ID, COUNT(DISTINCT BRANCH_NO) NO_BRANCH_NUM
      FROM ${gis_user}.DB_CDE_GRID A
      WHERE NOT EXISTS (SELECT 1
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT C
      WHERE C.NUM > 0
      AND A.union_org_code = C.union_org_code)
      and
      <e:if condition="${empty param.branch_type}">
        branch_type IN ('a1','b1')
      </e:if>
      <e:if condition="${!empty param.branch_type}">
        branch_type = '${param.branch_type}'
      </e:if>
      AND GRID_STATUS = 1
      GROUP BY LATN_ID) C
      WHERE A.LATN_ID = C.LATN_ID)
      ORDER BY city_order_num
    </c:tablequery>
  </e:case>

  <e:description>网格</e:description>
  <e:case value="grid">
    <c:tablequery>
      select * from (
        SELECT
        A.LATN_ID,
        A.BUREAU_NO,
        A.BUREAU_NAME,
        A.UNION_ORG_CODE,
        A.BRANCH_NAME,
        CASE
        WHEN GROUPING(GRID_ID) = 1 THEN
        MAX(UNION_ORG_CODE)
        ELSE
        MAX(GRID_ID)
        END GRID_ID,
        CASE
        WHEN GROUPING(GRID_ID) = 1 THEN
        '小计'
        ELSE
        MAX(GRID_NAME)
        END GRID_NAME,
        NVL(sum(A.NUM), 0) COLLECT_NUM,
        NVL(sum(A.ZHU_HU_COUNT), 0) ZHU_HU_COUNT,
        NVL(sum(A.DQ_1_COUNT), 0) DQ_1_COUNT,
        NVL(sum(A.DQ_2_COUNT), 0) DQ_2_COUNT,
        case when sum(A.ZHU_HU_COUNT)=0 then '--' else trim(to_char(NVL(ROUND(sum(A.NUM) / sum(A.ZHU_HU_COUNT), 4)*100, 0),'990.90')||'%') end COLLECT_V
        FROM ${gis_user}.VIEW_GIS_GRID_COLLECT A
        WHERE 1=1
        <e:if condition="${empty param.branch_type}">
          AND a.branch_type IN ('a1','b1')
        </e:if>
        <e:if condition="${!empty param.branch_type}">
          AND a.branch_type = '${param.branch_type}'
        </e:if>
        <e:if condition="${!empty param.city_id1}" var="empty_cityid1">
          AND a.LATN_ID='${param.city_id1}'
        </e:if>
        <e:else condition="${empty_cityid1}">
          AND a.LATN_ID='${param.city_id}'
        </e:else>
        <e:if condition="${!empty param.bureau_id2}" var="empty_bureau_id2">
        </e:if>
        <e:else condition="${empty_bureau_id2}">
          <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
            AND a.BUREAU_NO='${param.bureau_id1}'
          </e:if>
          <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id && param.bureau_id ne '999'}">
            AND a.BUREAU_NO='${param.bureau_id}'
          </e:if>
        </e:else>
        <e:if condition="${!empty param.branch_id && param.branch_id ne '999'}">
          AND a.UNION_ORG_CODE = '${param.branch_id}'
        </e:if>
        <e:if condition="${!empty param.grid_id && param.grid_id ne '999'}">
          AND a.GRID_ID = '${param.grid_id}'
        </e:if>
        GROUP BY latn_id,bureau_no,bureau_name,UNION_ORG_CODE,branch_name,
        ROLLUP(grid_id)
        ORDER BY BUREAU_NO, UNION_ORG_CODE
      ) where GRID_NAME is not null
    </c:tablequery>
  </e:case>

  <e:description>明细</e:description>
  <e:case value="detail">
    <c:tablequery>
      select * from (
      select a.*,
      CASE
      WHEN business IS NULL THEN
      ' '
      WHEN business = '1' OR business = '移动' THEN
      '移动'
      WHEN business = '2' OR business = '联通' THEN
      '联通'
      WHEN business = '3' OR business = '广电' THEN
      '广电'
      WHEN BUSINESS = '4' OR business = '其他' THEN
      '其他'
      WHEN business = '5' OR business = '电信' THEN
      '电信'
      END BUSINESS_TEXT,
      nvl(village_name,' ')village_Name
      <e:if condition="${!empty param.city_id1}" var="empty_cityid1">
        ,'${param.city_id1}' latn_id
      </e:if>
      <e:else condition="${empty_cityid1}">
        ,'${param.city_id}' latn_id
      </e:else>
      <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
        ,'${param.bureau_id1}' BUREAU_NO
      </e:if>
      <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id}">
        ,'${param.bureau_id}' BUREAU_NO
      </e:if>
      <e:if condition="${!empty param.branch_id1 && param.branch_id1 ne '999'}">
        ,'${param.branch_id1}' UNION_ORG_CODE
      </e:if>
      <e:if condition="${empty param.branch_id1 && !empty param.branch_id}">
        ,'${param.branch_id}' UNION_ORG_CODE
      </e:if>
      <e:if condition="${!empty param.grid_id1}" var="empty_grid_id1">
        <e:if condition="${param.grid_id1 ne '999'}">
          ,'${param.grid_id1}' GRID_ID
        </e:if>
      </e:if>
      <e:if condition="${empty param.grid_id1 && !empty param.grid_id && param.grid_id ne '999'}">
        ,'${param.grid_id}' GRID_ID
      </e:if>
      from(
      SELECT
      segm_id,
      SEGM_ID_2,
      T.STAND_NAME_2,
      CONTACT_PERSON,
      <e:description>2018.10.22 号码脱敏</e:description>
      decode(CONTACT_NBR,null,'--',nvl((substr(CONTACT_NBR,0,3) || '******' || substr(CONTACT_NBR,10,2)),'--')) CONTACT_NBR,
      case when KD_DQ_DATE is not null then KD_business
      when itv_dq_date is not null then itv_business
      when phone_dq_date is not null then phone_business
      when phone_dq_date1 is not null then phone_business1
      when phone_dq_date2 is not null then phone_business2
      end business,
      to_char(nvl(KD_DQ_DATE,nvl(itv_dq_date,nvl(phone_dq_date,nvl(phone_dq_date1,phone_dq_date2)))),'yyyy"年"mm"月"dd"日"') DQ_DATE,
      SEGM_TYPE
      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL T
      WHERE SEGM_ID IN (SELECT SEGM_ID
      FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
      WHERE 1 = 1
      <e:if condition="${!empty param.city_id1}" var="empty_city_id1">
        AND LATN_ID = '${param.city_id1}'
      </e:if>
      <e:else condition="${empty_city_id1}">
        AND LATN_ID = '${param.city_id}'
      </e:else>
      <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
        AND BUREAU_NO = '${param.bureau_id1}'
      </e:if>
      <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id}">
        AND BUREAU_NO = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id1 && param.branch_id1 ne '999'}">
        AND UNION_ORG_CODE = '${param.branch_id1}'
      </e:if>
      <e:if condition="${empty param.branch_id1 && !empty param.branch_id}">
        AND UNION_ORG_CODE = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id1}" var="empty_grid_id1">
        <e:if condition="${param.grid_id1 ne '999'}">
          AND GRID_ID = '${param.grid_id1}'
        </e:if>
      </e:if>
      <e:if condition="${empty param.grid_id1 && !empty param.grid_id && param.grid_id ne '999'}">
        AND GRID_ID = '${param.grid_id}'
      </e:if>
      )
      <e:if condition="${!empty param.month_flag1}">
        <e:if condition="${param.month_flag1 eq '1'}">
          AND
          (
          to_char(kd_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(itv_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date1,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date2,'yyyymm')=to_char(SYSDATE,'yyyymm')
          )
        </e:if>
        <e:if condition="${param.month_flag1 eq '2'}">
          AND
          (
          to_char(kd_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(itv_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date1,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date2,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          )
        </e:if>
      </e:if>
      <e:if condition="${empty param.month_flag1}">
        <e:if condition="${param.month_flag eq '1'}">
          AND
          (
          to_char(kd_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(itv_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date1,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date2,'yyyymm')=to_char(SYSDATE,'yyyymm')
          )
        </e:if>
        <e:if condition="${param.month_flag eq '2'}">
          AND
          (
          to_char(kd_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(itv_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date1,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date2,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          )
        </e:if>
      </e:if>
      AND CONTACT_PERSON IS NOT NULL
      AND CONTACT_NBR IS NOT NULL

      ORDER BY STAND_NAME_2,CONTACT_PERSON)a
      left join
      (SELECT b.segm_id,a.village_name FROM ${gis_user}.tb_gis_village_edit_info a,${gis_user}.tb_gis_village_addr4 b WHERE a.village_id = b.village_id
      )c
      ON a.segm_id = c.segm_id)
      where 1=1
      <e:if condition="${!empty param.text}">
        and (contact_person LIKE '%' || '${param.text}' ||'%'
        OR contact_nbr LIKE '%' || '${param.text}' ||'%'
        OR stand_name_2 LIKE '%' || '${param.text}' ||'%'
        OR village_name LIKE '%' || '${param.text}' ||'%'
        )
      </e:if>
    </c:tablequery>
  </e:case>

  <e:description>获取地市下的区县</e:description>
  <e:case value="getBureauByCityId">
    <e:q4l var="dataList">
      SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM ${gis_user}.db_cde_grid WHERE latn_id = '${param.city_id}' order by REGION_ORDER_NUM
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取区县下的支局</e:description>
  <e:case value="getBranchByBureauId">
    <e:q4l var="dataList">
      SELECT DISTINCT T.UNION_ORG_CODE,T.BRANCH_NO,T.BRANCH_NAME,'支局列表' b
      FROM ${gis_user}.DB_CDE_GRID T
      WHERE T.BUREAU_NO = '${param.bureau_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByBranchId">
    <e:q4l var="dataList">
      select DISTINCT grid_id,grid_name,'网格列表' c from ${gis_user}.DB_CDE_GRID t WHERE UNION_ORG_CODE = '${param.branch_id}' AND grid_status = 1 and grid_union_org_code <> -1
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取没有信息收集的支局信息</e:description>
  <e:case value="showSubNoCollect">
    <c:tablequery>
      SELECT distinct LATN_NAME,BUREAU_NAME,BRANCH_NAME
        FROM ${gis_user}.DB_CDE_GRID A
        WHERE NOT EXISTS (SELECT 1
        FROM ${gis_user}.TB_GIS_GRID_COLLECT C
        WHERE C.NUM > 0
        AND A.UNION_ORG_CODE = C.UNION_ORG_CODE)
        AND GRID_STATUS = 1
        <e:if condition="${empty param.branch_type}">
          and branch_type IN ('a1','b1')
        </e:if>
        <e:if condition="${!empty param.branch_type}">
          and branch_type = '${param.branch_type}'
        </e:if>
        <e:if condition="${!empty param.city_id1}" var="empty_cityid1">
          AND LATN_ID='${param.city_id1}'
        </e:if>
        <e:else condition="${empty_cityid1}">
          AND LATN_ID='${param.city_id}'
        </e:else>
    </c:tablequery>
  </e:case>

  <e:description>获取近一月到期的策反列表，当前月，废弃</e:description>
  <e:case value="showOneMonth">
    <c:tablequery>
      SELECT * FROM  ${gis_user}.TB_GIS_ADDR_OTHER_ALL
      WHERE SEGM_ID IN (SELECT SEGM_ID
      FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
      WHERE 1 = 1
      <e:if condition="${!empty_city_id}">
        AND LATN_ID = '${param.city_id}'
      </e:if>
      <e:if condition="${!empty param.bureau_id}">
        AND BUREAU_NO = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id}">
        AND UNION_ORG_CODE = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id}">
        AND GRID_ID = '${param.grid_id}'
      </e:if>
      )
      AND
      (
      to_char(kd_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(itv_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date1,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date2,'yyyymm')=to_char(SYSDATE,'yyyymm')
      )
    </c:tablequery>
  </e:case>

  <e:description>获取近两月到期的策反列表，当前月加1，废弃</e:description>
  <e:case value="showTwoMonth">
    <c:tablequery>
      SELECT * FROM  ${gis_user}.TB_GIS_ADDR_OTHER_ALL
      WHERE SEGM_ID IN (SELECT SEGM_ID
      FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
      WHERE 1 = 1
      <e:if condition="${!empty_city_id}">
        AND LATN_ID = '${param.city_id}'
      </e:if>
      <e:if condition="${!empty param.bureau_id}">
        AND BUREAU_NO = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id}">
        AND UNION_ORG_CODE = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id}">
        AND GRID_ID = '${param.grid_id}'
      </e:if>
      )
      AND
      (
      to_char(kd_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(itv_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date1,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date2,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      )
    </c:tablequery>
  </e:case>

</e:switch>