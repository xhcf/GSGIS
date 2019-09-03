<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
  <e:description>系统使用情况统计 汇总</e:description>
  <e:case value="used_summary">
    <c:tablequery>
      select e.latn_id,
      e.latn_name,
      nvl(login_num, 0) login_num,
      nvl(login_user_num, 0) login_user_num,
      a.user_all,
      CASE
      WHEN USER_ALL = 0 THEN
      '--'
      ELSE
      TO_CHAR(ROUND(nvl(LOGIN_USER_NUM,0） / USER_ALL, 4) * 100, '990.90')||'%'
      END USED_PERCENT
      from (select ext1, count(user_id) user_all
      from easy_data.e_user t
      where t.user_id not in ('1',
      '101',
      '1080',
      '1101',
      '1103',
      '1100',
      '1102',
      '1120',
      '1141',
      '1160',
      '1181',
      '1180',
      '1200',
      '154261')
      and t.state = 1
      and exists (SELECT 1 FROM ${gis_user}.db_cde_grid b  where grid_status = 1 and t.ext3=b.union_org_code )
      and not exists(select 1 from ${gis_user}.db_cde_grid b where grid_status=0  and t.ext4=B.grid_union_org_code )
      group by ext1) a,
      (select distinct latn_id, latn_name, city_order_num from ${gis_user}.db_cde_grid) e,
      (SELECT ext1,
      count(t.user_id) login_num,
      count(distinct t.user_id) login_user_num
      FROM easy_data.e_user t, easy_data.E_LOGIN_LOG a
      where t.user_id = a.user_id(+)
      and t.user_id not in ('1',
      '101',
      '1080',
      '1101',
      '1103',
      '1100',
      '1102',
      '1120',
      '1141',
      '1160',
      '1181',
      '1180',
      '1200',
      '154261')
      and t.state = 1
      and exists (SELECT 1 FROM ${gis_user}.db_cde_grid b  where grid_status = 1 and t.ext3=b.union_org_code )
      and not exists(select 1 from ${gis_user}.db_cde_grid b where grid_status=0  and t.ext4=B.grid_union_org_code )
      and to_date(substr(a.login_date, 1, 8), 'yyyymmdd') between
      <e:if condition="${!empty param.dateBegin}" var="empty_dateBegin">
        to_date('${param.dateBegin}', 'yyyy-mm-dd') and
        to_date('${param.dateEnd}', 'yyyy-mm-dd')
      </e:if>
      <e:else condition="${empty_dateBegin}">
        to_date('${param.acct_day}', 'yyyy-mm-dd') and
        to_date('${param.acct_day}', 'yyyy-mm-dd')
      </e:else>
      group by t.ext1) c
      where a.ext1 = c.ext1(+)
      and a.ext1 = e.latn_id
      order by e.city_order_num
    </c:tablequery>
  </e:case>

  <e:description>登录汇总_网格</e:description>
  <e:case value="grid">
    <c:tablequery>
      SELECT EXT1,
      EXT2,
      EXT3,
      EXT4,
      EXT6,
      EXT7,
      EXT8,
      EXT9,
      COUNT(DISTINCT SESSION_ID) LOGIN_NUM,
      COUNT(DISTINCT USER_ID2) login_user_num
      FROM (SELECT T.*, A.SESSION_ID, A.USER_ID USER_ID2
      FROM EASY_DATA.E_USER T,
      (SELECT *
      FROM EASY_DATA.E_LOGIN_LOG
      WHERE TO_DATE(SUBSTR(LOGIN_DATE, 1, 8), 'yyyymmdd') BETWEEN
      <e:if condition="${!empty param.dateBegin}" var="empty_dateBegin">
        to_date('${param.dateBegin}', 'yyyy-mm-dd') and
        to_date('${param.dateEnd}', 'yyyy-mm-dd')
      </e:if>
      <e:else condition="${empty_dateBegin}">
        to_date('${param.acct_day}', 'yyyy-mm-dd') and
        to_date('${param.acct_day}', 'yyyy-mm-dd')
      </e:else>
      ) A
      WHERE T.USER_ID = A.USER_ID(+)
      AND T.USER_ID NOT IN ('1',
      '101',
      '1080',
      '1101',
      '1103',
      '1100',
      '1102',
      '1120',
      '1141',
      '1160',
      '1181',
      '1180',
      '1200',
      '154261')
      AND T.STATE = 1) A,
      ${gis_user}.DB_CDE_GRID C
      WHERE A.EXT3 = C.UNION_ORG_CODE
      AND C.BRANCH_TYPE IN ('a1', 'b1')
      AND C.GRID_STATUS = 1
      <e:if condition="${!empty param.city_id1}" var="empty_city_id1">
        AND c.latn_id = '${param.city_id1}'
      </e:if>
      <e:else condition="${empty_city_id1 && !empty param.city_id}">
        AND c.latn_id = '${param.city_id}'
      </e:else>
      <e:if condition="${!empty param.bureau_id2}" var="empty_bureau_id2">
      </e:if>
      <e:else condition="${empty_bureau_id2}">
        <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
          AND C.BUREAU_NO='${param.bureau_id1}'
        </e:if>
        <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id && param.bureau_id ne '999'}">
          AND C.BUREAU_NO='${param.bureau_id}'
        </e:if>
      </e:else>
      GROUP BY
      EXT6,
      EXT7,
      EXT8,
      EXT9,
      C.CITY_ORDER_NUM,
      C.REGION_ORDER_NUM,
      EXT1,
      EXT2,
      EXT3,
      EXT4
      ORDER BY C.CITY_ORDER_NUM, C.REGION_ORDER_NUM,EXT3, EXT4,login_user_num desc
    </c:tablequery>
  </e:case>

  <e:description>登录明细</e:description>
  <e:case value="login_detail">
    <c:tablequery>
      SELECT ext6, ext7, ext8, ext9,login_id,user_name,count(1) login_num
      FROM easy_data.e_user t, easy_data.E_LOGIN_LOG a
      where t.user_id = a.user_id(+)
      and t.user_id not in ('1',
      '101',
      '1080',
      '1101',
      '1103',
      '1100',
      '1102',
      '1120',
      '1141',
      '1160',
      '1181',
      '1180',
      '1200',
      '154261')
      and t.state = 1
      and exists (SELECT 1 FROM ${gis_user}.db_cde_grid b  where grid_status = 1 and t.ext3=b.union_org_code )
      and not exists(select 1 from ${gis_user}.db_cde_grid b where grid_status=0  and t.ext4=B.grid_union_org_code )
      <e:if condition="${!empty param.city_id1}" var="empty_city_id1">
        and ext1 = '${param.city_id1}'
      </e:if>
      <e:else condition="${empty_city_id1}">
        and ext1 = '${param.city_id}'
      </e:else>
      <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
        and ext2 = '${param.bureau_id1}'
      </e:if>
      <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id}">
        and ext2 = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id1 && param.branch_id1 ne '999'}">
        and ext3 = '${param.branch_id1}'
      </e:if>
      <e:if condition="${empty param.branch_id1 && !empty param.branch_id}">
        and ext3 = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id1}" var="empty_grid_id1">
        <e:if condition="${param.grid_id1 ne '999'}">
          AND ext4 = '${param.grid_id1}'
        </e:if>
      </e:if>
      <e:if condition="${empty param.grid_id1 && !empty param.grid_id && param.grid_id ne '999'}">
        AND ext4 = '${param.grid_id}'
      </e:if>
      <e:if condition="${!empty param.text}">
        AND (ext7 LIKE '%${param.text}%' or ext8 like '%${param.text}%' or ext9 like '%${param.text}%')
      </e:if>
      <e:if condition="${!empty param.dateBegin}" var="empty_dateBegin">
        and to_date(substr(a.login_date, 1, 8), 'yyyymmdd') between
        to_date('${param.dateBegin}', 'yyyy-mm-dd') and
        to_date('${param.dateEnd}', 'yyyy-mm-dd')
      </e:if>
      group by login_id, user_name, ext6, ext7, ext8, ext9
    </c:tablequery>
  </e:case>

  <e:description>获取地市下的区县</e:description>
  <e:case value="getBureauByCityId">
    <e:q4l var="dataList">
      SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM ${gis_user}.db_cde_grid WHERE latn_id = '${param.city_id}' and branch_type in ('a1','b1') order by REGION_ORDER_NUM
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
  
</e:switch>