<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
  <e:description>系统使用情况统计 汇总</e:description>

    <e:description>获取支局或者网格的用户账号和密码</e:description>
	<e:case value="getUserInfo">
      <e:q4o var="selInfo">
        SELECT
              LOGIN_ID,
              PASSWORD
        FROM
              ${easy_user}.E_USER
        WHERE
              1=1
              <e:if condition="${param.type eq '0' }">
                AND EXT5=4
                AND STATE=1
                AND EXT3 ='${param.id}'
                AND EXT4 IS NULL
              </e:if>
              <e:if condition="${param.type eq '1' }">
                AND EXT5=5
                AND STATE=1
                AND EXT4='${param.id}'
              </e:if>
              AND ROWNUM=1
      </e:q4o>${e:java2json(selInfo)}
	</e:case>

	<e:description>角色切换-列表数据查询</e:description>
    <e:case value="data_list">
    <c:tablequery>
      SELECT
      distinct
      T.LATN_NAME,
      T.BUREAU_NAME,
      T.BRANCH_NAME,
      T.GRID_NAME,
      T.LATN_ID,
      T.CITY_ORDER_NUM,
      T.BUREAU_NO,
      T.REGION_ORDER_NUM,
      T.UNION_ORG_CODE,
      T.GRID_UNION_ORG_CODE,
      T1.SUB_NUM SUB_COUNT,
      T2.GRID_NUM GRID_COUNT
      FROM (SELECT LATN_NAME,
      BUREAU_NAME,
      BRANCH_NAME,
      GRID_NAME,
      LATN_ID,
      BUREAU_NO,
      UNION_ORG_CODE,
      GRID_UNION_ORG_CODE,
      CITY_ORDER_NUM,
      REGION_ORDER_NUM
      FROM GIS_DATA.DB_CDE_GRID B
      WHERE B.GRID_UNION_ORG_CODE IS NOT NULL
      AND B.GRID_STATUS = 1
      AND B.BRANCH_TYPE <> 'c1'
      <e:description>
        AND grid_union_org_code <> -1
        AND grid_union_Org_code IS NOT NULL
      </e:description>
      <e:if condition="${! empty param.latn_id && param.latn_id ne '999'}">
        and latn_id = '${param.latn_id}'
      </e:if>
      <e:if condition="${! empty param.bureau_id && param.bureau_id ne '999'}">
        and bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${! empty param.name_mask }">
        and (branch_name LIKE '%${param.name_mask}%'
        OR grid_name LIKE '%${param.name_mask}%' )
      </e:if>
      ) T
      LEFT JOIN (SELECT EXT3, COUNT(LOGIN_ID) OVER(PARTITION BY EXT3) SUB_NUM
      FROM EASY_DATA.E_USER
      WHERE STATE = 1
      AND (EXT3 IS NOT NULL OR EXT4 IS NULL)
      AND EXT5 = 4) T1
      ON T.UNION_ORG_CODE = T1.EXT3
      LEFT JOIN (SELECT EXT3,
      EXT4,
      COUNT(LOGIN_ID) OVER(PARTITION BY EXT3, EXT4) GRID_NUM
      FROM EASY_DATA.E_USER
      WHERE STATE = 1
      AND EXT3 IS NOT NULL
      AND EXT4 IS NOT NULL
      AND EXT5 = 5) T2
      ON T.UNION_ORG_CODE = T2.EXT3
      AND T.GRID_UNION_ORG_CODE = T2.EXT4
      order by t.city_order_num,t.region_order_num,t.union_org_code,t.GRID_UNION_ORG_CODE
    </c:tablequery>
  </e:case>

  <e:case value="org_summary">
    <c:tablequery>
      SELECT
      latn_id,
      latn_name,
      COUNT(DISTINCT t.bureau_no) bureau_num,
      COUNT(DISTINCT t.union_org_code) branch_num,
      COUNT(DISTINCT t.grid_union_org_code) grid_num,
      m.cnt user_num
      FROM ${gis_user}.db_cde_grid t,(SELECT e.ext1 ext1,COUNT(1) cnt FROM e_user e WHERE  e.ext5 IN (4,5) AND e.state=1 AND (e.ext3 IS NOT NULL OR e.ext4 IS NOT NULL) AND e.ext1 IS NOT NULL GROUP BY e.ext1) m
      WHERE grid_union_org_code IS NOT NULL AND branch_type = 'a1' AND t.latn_id = m.ext1
      GROUP BY latn_id,latn_name,t.city_order_num,m.cnt
      ORDER BY t.city_order_num
    </c:tablequery>
  </e:case>

  <e:description>登录汇总_网格</e:description>
  <e:case value="sub">
    <c:tablequery>
      SELECT E.EXT1,
      E.EXT2,
      E.EXT3,
      E.EXT6,
      E.EXT7,
      e.ext8,
      E.LOGIN_ID,
      E.PASSWORD,
      E.USER_NAME,
      e.telephone
      FROM E_USER E,
      (SELECT DISTINCT G.Union_Org_Code,g.region_order_num,
      G.BRANCH_TYPE FROM ${gis_user}.DB_CDE_GRID G  WHERE G.GRID_UNION_ORG_CODE IS NOT NULL AND G.BRANCH_TYPE = 'a1') D
      WHERE E.EXT3 = D.UNION_ORG_CODE AND  E.EXT5 = 4
      AND E.STATE = 1
      AND E.EXT3 IS NOT NULL
      <e:if condition="${!empty param.city_id1}" var="empty_city_id1">
        AND e.ext1 = '${param.city_id1}'
      </e:if>
      <e:else condition="${empty_city_id1 && !empty param.city_id}">
        AND e.ext1 = '${param.city_id}'
      </e:else>
      <e:if condition="${!empty param.bureau_id2}" var="empty_bureau_id2">
      </e:if>
      <e:else condition="${empty_bureau_id2}">
        <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
          AND e.ext2='${param.bureau_id1}'
        </e:if>
        <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id && param.bureau_id ne '999'}">
          AND e.ext2='${param.bureau_id}'
        </e:if>
      </e:else>
      ORDER BY   d.region_order_num
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