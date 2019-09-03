<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>


<e:switch value="${param.eaction}">

  <e:description>echarts地图</e:description>
  <e:case value="echarts_map">
    <e:q4l var = "dataList">
      <e:description>全省</e:description>
      <e:if condition="${param.flag eq '1'}">
        select
        a.mobile_mon_cum_new CURRENT_MON_DEV,
        a.latn_id ORG_ID,
        c.latn_name ORG_NAME
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d a,
        (select distinct latn_id, latn_name from ${gis_user}.db_cde_grid) c
        where flag = '2'
        and a.stat_date = '${param.date}'
        and a.latn_id = c.latn_id
      </e:if>
      <e:description>地市</e:description>
      <e:if condition="${param.flag eq '2'}">
        select
        sum(CURRENT_MON_DEV) CURRENT_MON_DEV, e.org_name
        from (select a.mobile_mon_cum_new CURRENT_MON_DEV,
        a.latn_id ORG_ID,
        c.bureau_name ORG_NAME
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d a,
        (select distinct bureau_no, bureau_name
        from ${gis_user}.db_cde_grid
        where latn_id = '${param.region_id}') c
        where flag = '3'
        and stat_date = '${param.date}'
        and a.latn_id = c.bureau_no) d
        left join (select cityidcol, org_name
        from freamwork2org
        where area_no = '${param.region_id}') e
        on d.org_id = e.cityidcol
        group by e.org_name
      </e:if>
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>支局网格 begin</e:description>
  <e:description>右侧 三包发展量 各级（省、市、区县、支局、网格）</e:description>
  <e:case value="three_index_market">
    <e:q4l var="list">
        <e:description>市场, 网格  支局</e:description>
          SELECT
	            nvl(GZ_ZHU_HU_COUNT,0) GZ_ZHU_HU_COUNT,
					    nvl(GZ_H_USE_CNT,0) GZ_H_USE_CNT,
					    DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100, 'FM9999999990.00') || '%') MARKET_RATE,
					    nvl(GOV_ZHU_HU_COUNT,0)  GOV_ZHU_HU_COUNT,
					    nvl(GOV_H_USE_CNT,0) GOV_H_USE_CNT
		    	FROM
				    ${gis_user}.TB_GIS_RES_INFO_DAY
				 <e:if condition="${param.flag eq '4' }">
	       	WHERE LATN_ID = '${param.substation }'
	       </e:if>
	       <e:if condition="${param.flag eq '5' }" >
		    	WHERE LATN_ID = (select grid_id from ${gis_user}.db_cde_grid where grid_union_org_code = (select station_no from ${gis_user}.spc_branch_station where station_id = '${param.report_to_id}'))
	       </e:if>
    </e:q4l>${e: java2json(list.list) }
  </e:case>
  <e:case value="three_index">
    <e:q4o var="dataObject">
      <e:description>省、市级别</e:description>
      <e:if condition="${param.flag eq '1' || param.flag eq '2'}">
        select
        <e:description>市场</e:description>
        case when ADDR_NUM=0 then 0
        else
        round(KD_NUM/ADDR_NUM*100,2) end zyl,
        round(ADDR_NUM/10000,1) ADDR_NUM,
        round(KD_NUM/10000,1) KD_NUM,
        <e:description>收入完成进度、本年累计收入、环比</e:description>
        trunc(income_budget_finish_rate,2) income_budget_finish_rate,
        trunc(y_cum_income/100000000,2) y_cum_income ,
        trunc(income_ratio,2) income_ratio,
        <e:description>经营利润、当月利润、环比</e:description>
        trunc(operate_profit_mon_year/100000000,2) operate_profit_mon_year,
        trunc(operate_profit_mon/100000000,2) operate_profit_mon,
        case when operate_profit_mon_last = 0 then 0 else trunc((operate_profit_mon - operate_profit_mon_last )/operate_profit_mon_last *100,2) end jylrhb
        from ${gis_user}.tb_dw_gis_zhi_ju_income_mon
        where flag = '${param.flag}'
        and latn_id = '${param.latn_id}'
        and statis_mon = '${param.last_month}'
      </e:if>
      <e:description>区县级别 目前是用下属分局的合计数</e:description>
      <e:if condition="${param.flag eq '3'}">
        select
        <e:description>市场</e:description>
        case when ADDR_NUM=0 then 0
        else
        round(KD_NUM/ADDR_NUM*100,2) end zyl,
        round(ADDR_NUM/10000,2) ADDR_NUM,
        round(KD_NUM/10000,2) KD_NUM,
        <e:description>收入完成进度、本年累计收入、环比</e:description>
        trunc(income_budget_finish_rate, 2) income_budget_finish_rate,
        trunc(y_cum_income / 100000000,2) y_cum_income,
        trunc(income_ratio, 2) income_ratio,
        <e:description>经营利润、当月利润、环比</e:description>
        trunc(operate_profit_mon_year/100000000,2) operate_profit_mon_year,
        trunc(operate_profit_mon/100000000,2) operate_profit_mon,
        case when operate_profit_mon_last = 0 then 0 else trunc((operate_profit_mon - operate_profit_mon_last )/operate_profit_mon_last*100,2) end jylrhb
        from ${gis_user}.tb_dw_gis_zhi_ju_income_mon
        where flag = '3'
        and latn_id = (select cityidcol
        from freamwork2org
        where org_Name = '${param.click_name}'
        and area_no = '${param.latn_id}'
        and rownum = 1
        )
        and statis_mon = '${param.last_month}'
      </e:if>
      <e:description>支局 目前是按支局名称匹配</e:description>
      <e:if condition="${param.flag eq '4'}">
      	<e:description>
        select
        <e:description>市场</e:description>
        case when nvl(m.ADDR_NUM,0)=0 then -1
        else
        nvl(round(m.KD_NUM/m.ADDR_NUM*100,2),-1) end zyl,
        nvl(m.ADDR_NUM,-1) ADDR_NUM,
        nvl(m.KD_NUM,-1) KD_NUM,
        nvl(m.PEOPLE_NUM,-1) PEOPLE_NUM,
        nvl(m.FTTH_PORT_NUM,-1) FTTH_PORT_NUM,
        nvl((m.FTTH_PORT_NUM-m.FTTH_PORT_ZY_NUM),-1) FTTH_PORT_KX_NUM,
        nvl(m.MARKET_SORT,-1) MARKET_SORT,
        <e:description>收入完成进度、本年累计收入、环比、当月收入</e:description>
        nvl(trunc(m.income_budget_finish_rate*100,2),-1) income_budget_finish_rate,
        nvl(trunc(m.y_cum_income/10000,2),-1) y_cum_income ,
        nvl(trunc(m.income_ratio*100,2),-1) income_ratio,
        nvl(trunc(m.fin_income/10000,2),-1) fin_income,
        <e:description>移动渗透率、宽带入户率、电视入户率、光网入户率</e:description>
        nvl(round(n.cdma_num_reate*100,2),-1) cdma_num_reate,
        nvl(round(n.brd_num_rate*100,2),-1) brd_num_rate,
        nvl(round(n.home_num_rate*100,2),-1) home_num_rate,
        nvl(trunc(n.h_num_rate*100,2),-1) ftth_num_rate,
        <e:description>经营利润、当月利润、环比</e:description>
        nvl(trunc(m.operate_profit_mon_year/10000,2),-1) operate_profit_mon_year,
        nvl(trunc(m.operate_profit_mon/10000,2),-1) operate_profit_mon,
        case when nvl(m.operate_profit_mon_last,0) = 0 then -1 else nvl(trunc((m.operate_profit_mon - m.operate_profit_mon_last )/m.operate_profit_mon_last *100,2),-1) end jylrhb,
        nvl(trunc(s.income_budget/10000,2),-1) income_budget
        from ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,${gis_user}.TB_SMALL_YS s,
        (SELECT DISTINCT LATN_ID,BRANCH_NO,UNION_ORG_CODE FROM ${gis_user}.DB_CDE_GRID) E
        where m.latn_id = n.branch_id(+) and m.flag=n.type(+)
        AND M.LATN_ID = E.BRANCH_NO
			  AND S.UNION_ORG_CODE = E.UNION_ORG_CODE
			  and m.flag = '${param.flag}'
			  AND S.flg=1
        and m.statis_mon = '${param.last_month}'
		    AND E.UNION_ORG_CODE = '${param.substation}'
		    AND E.LATN_ID = '${param.latn_id}'
		    </e:description>
		    select
		    '右侧市场' a,
		    case
		         when nvl(m.ADDR_NUM, 0) = 0 then
		          -1
		         else
		          nvl(round(m.KD_NUM / m.ADDR_NUM * 100, 2), -1)
		       end zyl,
		       nvl(m.ADDR_NUM, -1) ADDR_NUM,
		       nvl(m.KD_NUM, -1) KD_NUM,
		       nvl(m.PEOPLE_NUM, -1) PEOPLE_NUM,
		       nvl(m.FTTH_PORT_NUM, -1) FTTH_PORT_NUM,
		       nvl((m.FTTH_PORT_NUM - m.FTTH_PORT_ZY_NUM), -1) FTTH_PORT_KX_NUM,
		       nvl(m.MARKET_SORT, -1) MARKET_SORT,
		       nvl(trunc(m.income_budget_finish_rate * 100, 2), -1) income_budget_finish_rate,
		       nvl(trunc(m.y_cum_income / 10000, 2), -1) y_cum_income,
		       nvl(trunc(m.income_ratio * 100, 2), -1) income_ratio,
		       nvl(trunc(m.fin_income / 10000, 2), -1) fin_income,
		       nvl(round(n.cdma_num_reate * 100, 2), -1) cdma_num_reate,
		       nvl(round(n.brd_num_rate * 100, 2), -1) brd_num_rate,
		       nvl(round(n.home_num_rate * 100, 2), -1) home_num_rate,
		       nvl(trunc(n.h_num_rate * 100, 2), -1) ftth_num_rate,

		       nvl(b.mobile_serv_day_new,-1) mobile_serv_day_new,
        	 nvl(b.mobile_mon_cum_new,-1) mobile_mon_cum_new,
        	 case when nvl(b.mobile_mon_cum_new_last,0) = 0 then -1 else nvl(trunc((b.mobile_mon_cum_new - b.mobile_mon_cum_new_last )/b.mobile_mon_cum_new_last *100,2),-1) end jylrhb,

		       nvl(trunc(m.operate_profit_mon_year / 10000, 2), -1) operate_profit_mon_year,
		       nvl(trunc(m.operate_profit_mon / 10000, 2), -1) operate_profit_mon,
		       case
		         when nvl(m.operate_profit_mon_last, 0) = 0 then
		          -1
		         else
		          nvl(trunc((m.operate_profit_mon - m.operate_profit_mon_last) /
		                    m.operate_profit_mon_last * 100,
		                    2),
		              -1)
		       end jylrhb,
		       nvl(trunc(s.income_budget, 2), 0) income_budget
		  from (SELECT DISTINCT LATN_ID, BRANCH_NO, UNION_ORG_CODE
		          FROM ${gis_user}.DB_CDE_GRID) e,
		       (select * from ${gis_user}.tb_dw_gis_zhi_ju_income_mon m where m.statis_mon = '${param.last_month}' and m.flag='${param.flag}') m,
		       ${gis_user}.tb_dw_gis_zhi_ju_income_d b,
		       ${gis_user}.TB_DW_GIS_GRID_COMPETE n,
		       (select * from ${gis_user}.TB_SMALL_YS s  where flg=1) s
		 where e.branch_no = m.latn_id(+)
		 			 and m.latn_id= b.latn_id(+)
		       and e.branch_no = n.branch_id(+)
		       and e.union_org_code = s.union_org_code(+)
		   AND e.UNION_ORG_CODE = '${param.substation}'
      </e:if>
      <e:description>网格 目前是按网格名称匹配</e:description>
      <e:if condition="${param.flag eq '5'}">
      	select
        <e:description>市场</e:description>
        case when nvl(a.ADDR_NUM,0)=0 then 0
        else
        nvl(round(a.KD_NUM/a.ADDR_NUM*100,2),-1) end zyl,
        nvl(a.ADDR_NUM,-1) ADDR_NUM,
        nvl(a.KD_NUM,-1) KD_NUM,
        nvl(a.PEOPLE_NUM,-1) PEOPLE_NUM,
        nvl(a.FTTH_PORT_NUM,-1) FTTH_PORT_NUM,
        nvl((a.FTTH_PORT_NUM-a.FTTH_PORT_ZY_NUM),-1) FTTH_PORT_KX_NUM,
        nvl(a.MARKET_SORT,-1) MARKET_SORT,
        <e:description>收入完成进度、本年累计收入、本月收入</e:description>
        nvl(trunc(a.income_budget_finish_rate*100,2),-1) income_budget_finish_rate,
        nvl(trunc(a.y_cum_income/10000,2),-1) y_cum_income ,
        nvl(trunc(a.fin_income/10000,2),-1) fin_income,
        <e:description>移动渗透率、宽带入户率、电视入户率、光网入户率</e:description>
        nvl(round(c.cdma_num_reate*100,2),-1) cdma_num_reate,
        nvl(round(c.brd_num_rate*100,2),-1) brd_num_rate,
        nvl(round(c.home_num_rate*100,2),-1) home_num_rate,
        nvl(trunc(c.h_num_rate*100,2),-1) ftth_num_rate,
        <e:description> 当日发展、本月发展、环比</e:description>
        nvl(b.mobile_serv_day_new,-1) mobile_serv_day_new,
        nvl(b.mobile_mon_cum_new,-1) mobile_mon_cum_new,
        case when nvl(b.mobile_mon_cum_new_last,0) = 0 then -1 else nvl(trunc((b.mobile_mon_cum_new - b.mobile_mon_cum_new_last )/b.mobile_mon_cum_new_last *100,2),-1) end jylrhb,
        nvl(trunc(s.income_budget,2),0) income_budget
        from ${gis_user}.tb_dw_gis_zhi_ju_income_mon a ,${gis_user}.tb_dw_gis_zhi_ju_income_d b,${gis_user}.TB_SMALL_YS s,${gis_user}.TB_DW_GIS_GRID_COMPETE c
        where a.latn_id = (SELECT distinct grid_id FROM ${gis_user}.DB_CDE_GRID
        WHERE GRID_UNION_ORG_CODE = (select station_no from ${gis_user}.spc_branch_station t where t.station_id='${param.report_to_id}')
        )
        and a.latn_id= b.latn_id(+)
        and a.statis_mon = '${param.last_month}'
        and b.stat_date = '${param.yesterday}'
        and a.flag = b.flag(+)
        and a.flag = '5'
        AND a.latn_id = S.UNION_ORG_CODE(+)
        AND a.latn_id = c.branch_id(+)
        and a.flag=c.type(+)


      </e:if>
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>支局 网格 市场占有率柱状图</e:description>
  <e:case value="sc_zyl_zxt">
    <e:q4l var="list">
        SELECT T2.MONTH_CODE STATIS_MON, NVL(T1.USE_RATE, 0.00) ZYL
				FROM (
				SELECT ACCT_MONTH MONTH_CODE, ROUND(NVL(RATE, 0), 4) * 100 USE_RATE
				FROM ${gis_user}.TB_GIS_ST_RATE_MON
				WHERE
				<e:if condition="${param.flag eq '4' }">
				VILLAGE_ID = '${param.substation }'
				</e:if>
				<e:if condition="${param.flag eq '5' }">
				VILLAGE_ID = (
				SELECT DISTINCT GRID_ID FROM
				${gis_user}.db_cde_grid
				WHERE GRID_UNION_ORG_CODE = '${param.grid_id}'
				)
				</e:if>
				AND ACCT_MONTH BETWEEN
				TO_CHAR(ADD_MONTHS(TO_DATE('${param.last_month}', 'yyyymm'), -4), 'yyyymm') AND
				TO_CHAR(ADD_MONTHS(TO_DATE('${param.last_month}', 'yyyymm'), 0), 'yyyymm')) T1
				RIGHT JOIN (SELECT DISTINCT A.MONTH_CODE
				FROM ${gis_user}.TB_DIM_TIME A
				WHERE A.MONTH_CODE BETWEEN
				TO_CHAR(ADD_MONTHS(TO_DATE('${param.last_month}', 'yyyymm'), -4),
				'yyyymm') AND
				TO_CHAR(ADD_MONTHS(TO_DATE('${param.last_month}', 'yyyymm'), 0),
				'yyyymm')) T2
				ON T1.MONTH_CODE = T2.MONTH_CODE
				UNION ALL
				SELECT to_number(to_char(sysdate, 'yyyymm')) STATIS_MON,
				CASE
				WHEN GZ_ZHU_HU_COUNT = 0 THEN
				0
				ELSE
				(ROUND(NVL(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 0), 4) * 100)
				END ZYL
				FROM ${gis_user}.TB_GIS_RES_CITY_DAY
				where
				<e:if condition="${param.flag eq '4' }">
				 LATN_ID = '${param.substation }'
				</e:if>
				<e:if condition="${param.flag eq '5' }">
				 LATN_ID = (
				 (
					SELECT DISTINCT GRID_ID FROM
					${gis_user}.db_cde_grid
					WHERE GRID_UNION_ORG_CODE = '${param.grid_id}'
					)
				 )
				</e:if>
				ORDER BY STATIS_MON
    </e:q4l>${e: java2json(list.list) }
  </e:case>
  <e:case value="sc_zyl">
    <e:q4l var="scZylList">
      <e:if condition="${param.flag eq '4'}">
	       select
	        m.STATIS_MON,
	        case when m.ADDR_NUM=0 then 0
	             when m.ADDR_NUM is NULL  then 0
	        else
	        round(m.KD_NUM/m.ADDR_NUM*100,2) end zyl,
	        TRUNC (M .FIN_INCOME / 10000, 2) FIN_INCOME
	    	from ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n
	        where  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
	        and m.flag = '${param.flag}'
	        and m.latn_id = (SELECT distinct branch_no FROM ${gis_user}.DB_CDE_GRID
	        WHERE union_org_code = '${param.substation}'
	        AND latn_Id = '${param.latn_id}')
	        AND M .statis_mon BETWEEN to_char(add_months(to_date('${param.last_month}','yyyymm'),-5),'yyyymm')  AND  TO_CHAR(ADD_MONTHS(TO_DATE('${param.last_month}', 'yyyymm'), 0), 'yyyymm')
	        ORDER BY M.statis_mon
      </e:if>
      <e:if condition="${param.flag eq '5'}">
      select
	        A.STATIS_MON,
	        case when a.ADDR_NUM=0 then 0
	             when a.ADDR_NUM is NULL  then 0
	        else
	        round(a.KD_NUM/a.ADDR_NUM*100,2) end zyl,
	        TRUNC (a.FIN_INCOME / 10000, 2) FIN_INCOME
      	from ${gis_user}.tb_dw_gis_zhi_ju_income_mon a
        where a.latn_id = (SELECT distinct grid_id FROM ${gis_user}.DB_CDE_GRID
        WHERE GRID_UNION_ORG_CODE = (select station_no from ${gis_user}.spc_branch_station t where t.station_id='${param.report_to_id}')
        )
        and a.flag = '5'
        AND a.statis_mon BETWEEN to_char(add_months(to_date('${param.last_month}','yyyymm'),-5),'yyyymm')  AND TO_CHAR(ADD_MONTHS(TO_DATE('${param.last_month}', 'yyyymm'), 0), 'yyyymm')
	        ORDER BY a.statis_mon
      </e:if>
    </e:q4l>
    ${e:java2json(scZylList.list)}
  </e:case>

  <e:description>支局右侧占有率列表数据</e:description>
   <e:case value="getSubInfoBySubstation_zyl">

     <c:tablequery>
     		<e:description>
        SELECT * FROM (SELECT '全省' AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       1 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        and m.flag = '1'
			        and latn_id = '999'
			        and m.statis_mon = '${param.last_month}'
			UNION
			SELECT g.latn_name AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       2 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,(SELECT DISTINCT latn_id,latn_name FROM ${gis_user}.db_cde_grid )g
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        AND g.latn_id=m.latn_id
			        and m.flag = '2'
			        and m.latn_id = (SELECT DISTINCT latn_id FROM ${gis_user}.db_cde_grid t WHERE t.union_org_code='${param.substation}')
			        and m.statis_mon = '${param.last_month}'
			UNION
			SELECT g.BUREAU_NAME AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          nvl(ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2),-1)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       3 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,(SELECT DISTINCT BUREAU_NO,BUREAU_NAME FROM ${gis_user}.db_cde_grid )g
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        AND g.BUREAU_NO=m.latn_id
			        and m.flag = '3'
			        and m.latn_id = (SELECT DISTINCT BUREAU_NO FROM ${gis_user}.db_cde_grid t WHERE t.union_org_code='${param.substation}')
			        and m.statis_mon = '${param.last_month}'
			UNION
			SELECT g.branch_name AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       4 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,(SELECT DISTINCT branch_no,branch_name FROM ${gis_user}.db_cde_grid )g
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        AND g.branch_no=m.latn_id
			        and m.flag = '4'
			        and m.latn_id = (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid t WHERE t.union_org_code='${param.substation}')
			        and m.statis_mon = '${param.last_month}') ORDER BY rn
				</e:description>

				SELECT '999' LATN_ID,
					       '全省'    AREA,
					       USE_RATE     ZYL,
					       round(GZ_ZHU_HU_COUNT/10000,2)||'万' GZ_ZHU_HU_COUNT,
					       round(GZ_H_USE_CNT/10000,2)||'万' GZ_H_USE_CNT,
					       round(LY_CNT/10000,2)||'万' LY_CNT,
					       1 rn
					  FROM (SELECT LATN_ID,
					               CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY
					         WHERE FLG = 0
					           AND LATN_ID = '999') A
					 UNION
					SELECT B.LATN_ID||'',
					       LATN_NAME    AREA,
					       USE_RATE     ZYL,
					       round(GZ_ZHU_HU_COUNT/10000,2)||'万' GZ_ZHU_HU_COUNT,
					       round(GZ_H_USE_CNT/10000,2)||'万' GZ_H_USE_CNT,
					       round(LY_CNT/10000,2)||'万' LY_CNT,
					       2 rn
					  FROM (SELECT LATN_ID,
					               CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY
					         WHERE FLG = 1
					           AND LATN_ID ='${param.latn_id}') A,
					       (SELECT DISTINCT LATN_ID, LATN_NAME
					          FROM ${gis_user}.DB_CDE_GRID
					         WHERE LATN_ID = '${param.latn_id}') B
					 WHERE A.LATN_ID = B.LATN_ID
					UNION
					SELECT BUREAU_NO latn_id,
					       BUREAU_NAME    AREA,
					       USE_RATE     ZYL,
					       GZ_ZHU_HU_COUNT||'',
					       GZ_H_USE_CNT||'',
					       LY_CNT||'',
					       3 rn
					  FROM (SELECT CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT,
					               T.LATN_ID
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY T
					         WHERE FLG = 2
					           AND LATN_ID =
					               (SELECT DISTINCT BUREAU_NO
					                  FROM ${gis_user}.DB_CDE_GRID
					                 WHERE UNION_ORG_CODE = '${param.substation}')),
					       (SELECT DISTINCT BUREAU_NO, BUREAU_NAME
					          FROM ${gis_user}.DB_CDE_GRID
					         WHERE UNION_ORG_CODE ='${param.substation}')
					UNION
					SELECT union_org_code latn_id,
					       branch_name    AREA,
					       USE_RATE     ZYL,
					       GZ_ZHU_HU_COUNT||'',
					       GZ_H_USE_CNT||'',
					       LY_CNT||'',
					       4 rn
					  FROM (SELECT CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT,
					               T.LATN_ID
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY T
					         WHERE FLG = 3
					           AND LATN_ID = '${param.substation}'),
					           (SELECT DISTINCT union_org_code, branch_name
					          FROM ${gis_user}.DB_CDE_GRID
					         WHERE UNION_ORG_CODE = '${param.substation}')

					ORDER BY rn ASC

     </c:tablequery>
  </e:case>

  <e:description>网格右侧占有率列表数据</e:description>
  <e:case value="getGridInfoBySubstation_zyl">
     <c:tablequery>
     		<e:description>
     			SELECT * FROM (SELECT '全省' AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       1 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        and m.flag = '1'
			        and latn_id = '999'
			        and m.statis_mon = '${param.last_month}'
			UNION
			SELECT g.latn_name AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       2 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,(SELECT DISTINCT latn_id,latn_name FROM ${gis_user}.db_cde_grid )g
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        AND g.latn_id=m.latn_id
			        and m.flag = '2'
			        and m.latn_id = (SELECT DISTINCT latn_id FROM ${gis_user}.db_cde_grid t WHERE t.grid_union_org_code=（
			        SELECT t.station_no FROM ${gis_user}.spc_branch_station t WHERE t.station_id='${param.report_to_id}'
			        ）)
			        and m.statis_mon = '${param.last_month}'
			UNION
			SELECT g.BUREAU_NAME AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       3 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,(SELECT DISTINCT BUREAU_NO,BUREAU_NAME FROM ${gis_user}.db_cde_grid )g
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        AND g.BUREAU_NO=m.latn_id
			        and m.flag = '3'
			        and m.latn_id =
			        (SELECT DISTINCT BUREAU_NO FROM ${gis_user}.db_cde_grid t WHERE t.grid_union_org_code=（
			        SELECT t.station_no FROM ${gis_user}.spc_branch_station t WHERE t.station_id='${param.report_to_id}'
			        ）)
			        and m.statis_mon = '${param.last_month}'
			UNION
			SELECT g.branch_name AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       4 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,(SELECT DISTINCT branch_no,branch_name FROM ${gis_user}.db_cde_grid )g
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        AND g.branch_no=m.latn_id
			        and m.flag = '4'
			        and m.latn_id = (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid t WHERE t.grid_union_org_code=（
			        SELECT t.station_no FROM ${gis_user}.spc_branch_station t WHERE t.station_id='${param.report_to_id}'
			        ）)
			        and m.statis_mon = '${param.last_month}'
			UNION
			SELECT g.grid_name AREA,
			       CASE
			         WHEN M.ADDR_NUM = 0 THEN
			          0
			         ELSE
			          ROUND(M.KD_NUM / M.ADDR_NUM * 100, 2)
			       END ZYL,
			       NVL(TRUNC(N.CDMA_NUM_REATE * 100, 2), 0) CDMA_NUM_REATE,
			       NVL(TRUNC(N.BRD_NUM_RATE * 100, 2), 0) BRD_NUM_RATE,
			       NVL(TRUNC(N.HOME_NUM_RATE * 100, 2), 0) HOME_NUM_RATE,
			       5 rn
			  FROM  ${gis_user}.tb_dw_gis_zhi_ju_income_mon m , ${gis_user}.TB_DW_GIS_GRID_COMPETE n ,(SELECT DISTINCT grid_id,grid_name FROM ${gis_user}.db_cde_grid )g
			 WHERE  m.latn_id = n.branch_id(+) and m.flag=n.type(+)
			        AND g.grid_id=m.latn_id
			        and m.flag = '5'
			        and m.latn_id = (SELECT DISTINCT grid_id FROM ${gis_user}.db_cde_grid t WHERE t.grid_union_org_code=（
			        SELECT t.station_no FROM ${gis_user}.spc_branch_station t WHERE t.station_id='${param.report_to_id}'
			        ）)
			        and m.statis_mon = '${param.last_month}'
			        ) ORDER BY rn
     		</e:description>
        SELECT '999' LATN_ID,
					       '全省'    AREA,
					       USE_RATE     ZYL,
					       round(GZ_ZHU_HU_COUNT/10000,2)||'万' GZ_ZHU_HU_COUNT,
					       round(GZ_H_USE_CNT/10000,2)||'万' GZ_H_USE_CNT,
					       round(LY_CNT/10000,2)||'万' LY_CNT,
					       1 rn
					  FROM (SELECT LATN_ID,
					               CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY
					         WHERE FLG = 0
					           AND LATN_ID = '999') A
					 UNION
					SELECT B.LATN_ID||'',
					       LATN_NAME    AREA,
					       USE_RATE     ZYL,
					       round(GZ_ZHU_HU_COUNT/10000,2)||'万' GZ_ZHU_HU_COUNT,
					       round(GZ_H_USE_CNT/10000,2)||'万' GZ_H_USE_CNT,
					       round(LY_CNT/10000,2)||'万' LY_CNT,
					       2 rn
					  FROM (SELECT LATN_ID,
					               CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY
					         WHERE FLG = 1
					           AND LATN_ID ='${param.latn_id}') A,
					       (SELECT DISTINCT LATN_ID, LATN_NAME
					          FROM ${gis_user}.DB_CDE_GRID
					         WHERE LATN_ID = '${param.latn_id}') B
					 WHERE A.LATN_ID = B.LATN_ID
					UNION
					SELECT BUREAU_NO latn_id,
					       BUREAU_NAME    AREA,
					       USE_RATE||''     ZYL,
					       GZ_ZHU_HU_COUNT||'' GZ_ZHU_HU_COUNT,
					       GZ_H_USE_CNT||'' GZ_H_USE_CNT,
					       LY_CNT||'' LY_CNT,
					       3 rn
					  FROM (SELECT CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT,
					               T.LATN_ID
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY T
					         WHERE FLG = 2
					           AND LATN_ID ='${param.bureau_no}'
					               ),
					       (SELECT DISTINCT BUREAU_NO, BUREAU_NAME
					          FROM ${gis_user}.DB_CDE_GRID
					         WHERE bureau_no ='${param.bureau_no}')
					UNION
					SELECT union_org_code latn_id,
					       branch_name    AREA,
					       USE_RATE     ZYL,
					       GZ_ZHU_HU_COUNT||'' GZ_ZHU_HU_COUNT,
					       GZ_H_USE_CNT||'' GZ_H_USE_CNT,
					       LY_CNT||'' LY_CNT,
					       4 rn
					  FROM (SELECT CASE
					                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
					                  '--'
					                 ELSE
					                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
					               END USE_RATE,
					               GZ_ZHU_HU_COUNT,
					               GZ_H_USE_CNT,
					               LY_CNT,
					               T.LATN_ID
					          FROM ${gis_user}.TB_GIS_RES_INFO_DAY T
					         WHERE FLG = 3
					           AND LATN_ID = '${param.substation}'),
					           (SELECT DISTINCT union_org_code, branch_name
					          FROM ${gis_user}.DB_CDE_GRID
					         WHERE UNION_ORG_CODE = '${param.substation}')

					UNION
					SELECT GRID_ID      LATN_ID,
			       GRID_NAME    AREA,
			       USE_RATE     ZYL,
			       GZ_ZHU_HU_COUNT||'' GZ_ZHU_HU_COUNT,
			       GZ_H_USE_CNT||'' GZ_H_USE_CNT,
			       LY_CNT||'' LY_CNT,
			       5            RN
			  		FROM (SELECT CASE
			                 WHEN GZ_ZHU_HU_COUNT = 0 THEN
			                  '--'
			                 ELSE
			                  ROUND(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 4) * 100 || '%'
			               END USE_RATE,
			               GZ_ZHU_HU_COUNT,
			               GZ_H_USE_CNT,
			               LY_CNT,
			               T.LATN_ID
			          FROM ${gis_user}.TB_GIS_RES_INFO_DAY T
			         WHERE FLG = 4
			           AND LATN_ID =
			               (SELECT DISTINCT grid_id FROM ${gis_user}.db_cde_grid t WHERE t.grid_union_org_code=（                SELECT t.station_no FROM ${gis_user}.spc_branch_station t WHERE t.station_id=
			               '${param.report_to_id}'             ))),
			       (SELECT DISTINCT GRID_ID, GRID_NAME
			          FROM ${gis_user}.DB_CDE_GRID
			         WHERE GRID_ID =
			               (
			               SELECT DISTINCT grid_id FROM ${gis_user}.db_cde_grid t WHERE t.grid_union_org_code=（                SELECT t.station_no FROM ${gis_user}.spc_branch_station t WHERE t.station_id=
			               '${param.report_to_id}')
			               ))
					ORDER BY rn ASC
     </c:tablequery>
  </e:case>

  <e:description>右侧 曲线图（上月、本月）</e:description>
  <e:case value="index_month_diff">
    <e:q4l var="indexList">
      <e:description>省、市</e:description>
      <e:if condition="${param.flag eq '1' || param.flag eq '2'}">
        select
        stat_date,
        mobile_serv_day_new,
        mobile_serv_day_new_last,
        brd_serv_day_new,
        brd_serv_day_new_last,
        itv_serv_day_new,
        itv_serv_day_new_last
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id = '${param.region_id}'
        and stat_date BETWEEN '${param.date_start}' AND '${param.date_end}'
        order by stat_date asc
      </e:if>
      <e:description>区县 现在是取分局的合计数</e:description>
      <e:if condition="${param.flag eq '3'}">
        select
        stat_date,
        sum(mobile_serv_day_new) mobile_serv_day_new,
        sum(mobile_serv_day_new_last) mobile_serv_day_new_last,
        sum(brd_serv_day_new) brd_serv_day_new,
        sum(brd_serv_day_new_last) brd_serv_day_new_last,
        sum(itv_serv_day_new) itv_serv_day_new,
        sum(itv_serv_day_new_last) itv_serv_day_new_last
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id in (select cityidcol
        from freamwork2org
        where org_Name = '${param.click_name}'
        and area_no = '${param.region_id}'
        )
        and stat_date BETWEEN '${param.date_start}' AND '${param.date_end}'
        group by stat_date
        order by stat_date asc
      </e:if>
      <e:description>支局 现在是按支局名称匹配</e:description>
      <e:if condition="${param.flag eq '4'}">
        select
        stat_date,
        mobile_serv_day_new,
        mobile_serv_day_new_last,
        brd_serv_day_new,
        brd_serv_day_new_last,
        itv_serv_day_new,
        itv_serv_day_new_last
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id = (select distinct branch_no
        from ${gis_user}.db_cde_grid
        WHERE union_org_code = '${param.substation}'
        and latn_id = '${param.region_id}')
        and stat_date BETWEEN '${param.date_start}' AND '${param.date_end}'
        order by stat_date asc
      </e:if>
      <e:description>网格 现在是按网格名称匹配 目前是弹窗展示，右侧不联动，暂不用</e:description>
      <e:if condition="${param.flag eq '5'}">
        select
        stat_date,
        mobile_serv_day_new,
        mobile_serv_day_new_last,
        brd_serv_day_new,
        brd_serv_day_new_last,
        itv_serv_day_new,
        itv_serv_day_new_last
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id = (select distinct grid_id
        from ${gis_user}.db_cde_grid
        where union_org_code = '${param.grid_id}'
        and latn_id = '${param.region_id}')
        and stat_date BETWEEN '${param.date_start}' AND '${param.date_end}'
        order by stat_date asc
      </e:if>
      <e:description>网点 按网点名称匹配 暂不用</e:description>
      <e:if condition="${param.flag eq '6'}">
        SELECT
        acct_day,yd_current_day_dev DAY_ADD_CNT
        FROM ${gis_user}.DW_GIS_CHANNEL_DEV_D
        WHERE REGION_ID IN (SELECT TRIM(CHANNEL_NBR) FROM CHANNEL_INFO
        WHERE CHANNEL_NAME = '${param.click_name}' AND latn_Id = '${param.region_id}')
        AND ACCT_DAY BETWEEN '${param.date_start}' AND '${param.date_end}'
        ORDER BY ACCT_DAY
      </e:if>
    </e:q4l>
    ${e:java2json(indexList.list)}
  </e:case>

  <e:description>右侧 用户发展、终端销售</e:description>
  <e:case value="user_proc">
    <e:q4l var="dataList">
      <e:description>省、市</e:description>
      <e:if condition="${param.flag eq '1' || param.flag eq '2'}">
        select
        <e:description>移动本月累计 、环比</e:description>
        trunc(mobile_mon_cum_new/10000,2) mobile_mon_cum_new,
        case
        when mobile_mon_cum_new_last = 0 then
        0
        else
        trunc((mobile_mon_cum_new - mobile_mon_cum_new_last) /
        mobile_mon_cum_new_last * 100,
        2)
        end ydhb,
        <e:description>宽带本月累计、环比</e:description>
        trunc(brd_mon_cum_new/10000,2) brd_mon_cum_new,
        case
        when brd_mon_cum_new_last = 0 then
        0
        else
        trunc((brd_mon_cum_new - brd_mon_cum_new_last) / brd_mon_cum_new_last * 100,
        2)
        end kdhb,
        <e:description>itv本月累计、环比</e:description>
        trunc(itv_serv_cur_mon_new/10000,2) itv_serv_cur_mon_new,
        case
        when itv_serv_cur_mon_new_last = 0 then
        0
        else
        trunc((itv_serv_cur_mon_new - itv_serv_cur_mon_new_last) /
        itv_serv_cur_mon_new_last * 100,
        2)
        end itvhb,
        CUR_TERMINAL_TOTAL_MON,
        CUR_ZNJ_COUNT_MON,
        CUR_COUNT_800M_MON
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id = '${param.region_id}'
        and stat_date = '${param.date}'
      </e:if>

      <e:description>区县 现在是采用区县下分局的合计数据</e:description>
      <e:if condition="${param.flag eq '3'}">
        select
        <e:description>移动本月累计 、环比</e:description>
        sum(mobile_mon_cum_new) mobile_mon_cum_new,
        case
        when sum(mobile_mon_cum_new_last) = 0 then
        0
        else
        trunc((sum(mobile_mon_cum_new) - sum(mobile_mon_cum_new_last)) /
        sum(mobile_mon_cum_new_last) * 100,
        2)
        end ydhb,
        <e:description>宽带本月累计、环比</e:description>
        sum(brd_mon_cum_new) brd_mon_cum_new,
        case
        when sum(brd_mon_cum_new_last) = 0 then
        0
        else
        trunc((sum(brd_mon_cum_new) - sum(brd_mon_cum_new_last)) / sum(brd_mon_cum_new_last) * 100,
        2)
        end kdhb,
        <e:description>itv本月累计、环比</e:description>
        sum(itv_serv_cur_mon_new) itv_serv_cur_mon_new,
        case
        when sum(itv_serv_cur_mon_new_last) = 0 then
        0
        else
        trunc((sum(itv_serv_cur_mon_new) - sum(itv_serv_cur_mon_new_last)) /
        sum(itv_serv_cur_mon_new_last) * 100,
        2)
        end itvhb,
        sum(CUR_TERMINAL_TOTAL_MON) CUR_TERMINAL_TOTAL_MON,
        sum(CUR_ZNJ_COUNT_MON) CUR_ZNJ_COUNT_MON,
        sum(CUR_COUNT_800M_MON) CUR_COUNT_800M_MON
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id in (
        select cityidcol
        from freamwork2org
        where org_Name = '${param.click_name}'
        and area_no = '${param.region_id}'
        )
        and stat_date = '${param.date}'
      </e:if>

      <e:description>支局 现在是匹配支局substation,union_org_code</e:description>
      <e:if condition="${param.flag eq '4'}">
        select
        <e:description>移动本月累计 、环比</e:description>
        mobile_mon_cum_new,
        case
        when mobile_mon_cum_new_last = 0 then
        0
        else
        trunc((mobile_mon_cum_new - mobile_mon_cum_new_last) /
        mobile_mon_cum_new_last * 100,
        2)
        end ydhb,
        <e:description>宽带本月累计、环比</e:description>
        brd_mon_cum_new,
        case
        when brd_mon_cum_new_last = 0 then
        0
        else
        trunc((brd_mon_cum_new - brd_mon_cum_new_last) / brd_mon_cum_new_last * 100,
        2)
        end kdhb,
        <e:description>itv本月累计、环比</e:description>
        itv_serv_cur_mon_new,
        case
        when itv_serv_cur_mon_new_last = 0 then
        0
        else
        trunc((itv_serv_cur_mon_new - itv_serv_cur_mon_new_last) /
        itv_serv_cur_mon_new_last * 100,
        2)
        end itvhb,
        CUR_TERMINAL_TOTAL_MON,
        CUR_ZNJ_COUNT_MON,
        CUR_COUNT_800M_MON
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id = (
        select distinct branch_no
        from ${gis_user}.db_cde_grid
        WHERE union_org_code = '${param.substation}'
        and latn_id = '${param.region_id}'
        )
        and stat_date = '${param.date}'
      </e:if>

      <e:description>网格 现在是匹配网格名称</e:description>
      <e:if condition="${param.flag eq '5'}">
        select
        <e:description>移动本月累计 、环比</e:description>
        mobile_mon_cum_new,
        case
        when mobile_mon_cum_new_last = 0 then
        0
        else
        trunc((mobile_mon_cum_new - mobile_mon_cum_new_last) /
        mobile_mon_cum_new_last * 100,
        2)
        end ydhb,
        <e:description>宽带本月累计、环比</e:description>
        brd_mon_cum_new,
        case
        when brd_mon_cum_new_last = 0 then
        0
        else
        trunc((brd_mon_cum_new - brd_mon_cum_new_last) / brd_mon_cum_new_last * 100,
        2)
        end kdhb,
        <e:description>itv本月累计、环比</e:description>
        itv_serv_cur_mon_new,
        case
        when itv_serv_cur_mon_new_last = 0 then
        0
        else
        trunc((itv_serv_cur_mon_new - itv_serv_cur_mon_new_last) /
        itv_serv_cur_mon_new_last * 100,
        2)
        end itvhb,
        CUR_TERMINAL_TOTAL_MON,
        CUR_ZNJ_COUNT_MON,
        CUR_COUNT_800M_MON
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d
        where flag = '${param.flag}'
        and latn_id = (
        select distinct grid_id
        from ${gis_user}.db_cde_grid
        where grid_name = '${param.click_name}'
        and latn_id = '${param.region_id}'
        )
        and stat_date = '${param.date}'
      </e:if>

    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>右侧 终端销售 已从用户发展获取到</e:description>

  <e:description>右侧 流量经营 页面已删除</e:description>

  <e:description>左侧地图区域</e:description>
  <e:description>获取某地市下支局的union_org_code</e:description>
  <e:case value="sub_nameObject">
    <e:q4o var="dataObject">
      SELECT DISTINCT UNION_ORG_CODE FROM ${gis_user}.DB_CDE_GRID WHERE branch_name = '${param.org_name}' AND latn_name = '${param.latn_name}'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>获取某范围下的支局名集合，flag 2 获取省下的，3市级下，4区县下</e:description>
  <e:case value="sub_nameList">
    <e:q4l var="nameList">
      <e:if condition="${param.flag eq '2'}">

      </e:if>
      <e:if condition="${param.flag eq '3'}">
        SELECT
        T.*
        FROM (SELECT BRANCH_NAME, UNION_ORG_CODE, D.ROW_NUM
        FROM (SELECT DISTINCT LATN_ID,
        LATN_NAME,
        BUREAU_NO,
        BUREAU_NAME,
        BRANCH_NAME,
        UNION_ORG_CODE
        FROM ${gis_user}.DB_CDE_GRID) A,
        ${gis_user}.DW_GIS_KEY_DEV_D_TEST D
        WHERE A.BUREAU_NO IN
        (SELECT CITYIDCOL
        FROM FREAMWORK2ORG
        WHERE AREA_NO =
        (SELECT DISTINCT (LATN_ID)
        FROM ${gis_user}.DB_CDE_GRID
        WHERE LATN_NAME = '${param.city_name}')
        )
        AND D.CITY_TYPE IN ('城市', '农村')
        AND D.PRODUCT_DESC = '移动'
        AND A.UNION_ORG_CODE = D.REGION_ID
        ORDER BY ROW_NUM ASC) T
      </e:if>
      <e:if condition="${param.flag eq '4'}">
        SELECT T.*, ROWNUM
        FROM (SELECT BUREAU_NO,
        BUREAU_NAME,
        BRANCH_NAME,
        UNION_ORG_CODE,
        D.CURRENT_DAY_DEV,
        D.CURRENT_MON_DEV,
        D.ROW_NUM
        FROM (
        SELECT DISTINCT BUREAU_NO,
        BUREAU_NAME,
        BRANCH_NAME,
        UNION_ORG_CODE
        FROM ${gis_user}.DB_CDE_GRID) A,
        ${gis_user}.DW_GIS_KEY_DEV_D_TEST D
        WHERE A.BUREAU_NO IN (
        SELECT CITYIDCOL
        FROM FREAMWORK2ORG
        WHERE ORG_NAME IN ('${param.city_name}'))
        AND D.CITY_TYPE IN ('城市', '农村')
        AND D.PRODUCT_DESC = '移动'
        AND D.FLAG = '4'
        AND A.UNION_ORG_CODE = D.REGION_ID
        ORDER BY ROW_NUM ASC) T
      </e:if>
    </e:q4l>
    ${e:java2json(nameList.list)}
  </e:case>

  <e:description>获取某区县范围内的所有网格名称集合 flag 2 获取省下的，3市级下，4区县下</e:description>
  <e:case value="grid_nameList">
    <e:q4l var = "dataList">
      <e:if condition="${param.flag eq '4'}">
        select g.grid_name,
        t.latn_id,
        g.branch_name,
        t.mobile_mon_cum_new,
        t.brd_mon_cum_new,
        t.itv_serv_cur_mon_new,
        t.itv_mon_new_install_serv,
        t.mobile_mon_cum_new + t.brd_mon_cum_new + t.itv_serv_cur_mon_new CURRENT_DAY_DEV
        from ${gis_user}.tb_dw_gis_zhi_ju_income_d t, ${gis_user}.DB_CDE_GRID g
        where t.flag = 5
        and g.bureau_name = '${param.city_name}'
        and t.latn_id = g.grid_id
      </e:if>
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>根据支局ID获取其所属区县名称</e:description>
  <e:case value="getAreaNameBySubId">
    <e:q4o var="dataObject">
      SELECT AREA_NO,ORG_NAME,cityidcol
      FROM FREAMWORK2ORG
      WHERE CITYIDCOL = (
      SELECT DISTINCT (BUREAU_NO)
      FROM ${gis_user}.DB_CDE_GRID
      WHERE UNION_ORG_CODE = '${param.sub_id}'
      AND LATN_ID = '${param.city_id}')
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>获取不在某区县范围的其他支局名集合</e:description>
  <e:case value="sub_nameList_outside">
    <e:q4l var="nameList">
      SELECT DISTINCT branch_name,union_org_code FROM ${gis_user}.DB_CDE_GRID a WHERE a.bureau_no IN (SELECT DISTINCT(cityidcol) FROM FREAMWORK2ORG WHERE area_no IN (SELECT area_no FROM FREAMWORK2ORG WHERE org_name = '${param.city_name}') AND org_name !='${param.city_name}') AND branch_type IN( 'a1','b1')
    </e:q4l>
    ${e:java2json(nameList.list)}
  </e:case>

  <e:description>获取市区下其他区县的名称</e:description>
  <e:case value="qx_nameList_outside">
    <e:q4l var="nameList">
      SELECT distinct(org_name) org_Name FROM FREAMWORK2ORG WHERE area_no = (SELECT area_no FROM FREAMWORK2ORG WHERE org_name = '${param.city_name}' AND ROWNUM = 1) AND org_Name != '${param.city_name}'
    </e:q4l>
    ${e:java2json(nameList.list)}
  </e:case>
  <e:description>获取市级下所有区县的名称，传入城关区则获得兰州市下所有区县名称</e:description>
  <e:case value="qx_nameList_all">
    <e:q4l var="nameList">
      SELECT distinct(org_name) org_Name FROM FREAMWORK2ORG WHERE area_no = (SELECT area_no FROM FREAMWORK2ORG WHERE org_name = '${param.city_name}' AND ROWNUM = 1) and org_Name not in ('嘉峪关市')
    </e:q4l>
    ${e:java2json(nameList.list)}
  </e:case>
  <e:case value="qx_nameList_new">
    <e:q4l var="dataList">
      SELECT distinct(org_name) org_Name FROM FREAMWORK2ORG WHERE area_no = '${param.city_id}' and org_Name not in ('嘉峪关市')
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取区县所归属的市级id</e:description>
  <e:case value="getLatnIdByAreaName">
    select distinct area_no latn_id from FREAMWORK2ORG where org_name = '${param.area_name}'
  </e:case>

  <e:description>通过市级名称获取市级id</e:description>
  <e:case value="getLatnIdByCityName">
    <e:q4o var="latnId">
      SELECT latn_id FROM ${gis_user}.DB_CDE_GRID WHERE latn_Name = '${param.city_name}' AND ROWNUM = 1
    </e:q4o>
    ${e:java2json(latnId)}
  </e:case>

	<e:description>通过分局id获取区县名称</e:description>
  <e:case value="getQXNameByBureauNo">
    <e:q4o var="dataObject">
      select org_name BUREAU_NAME from easy_data.freamwork2org where cityidcol = '${param.bureau_no}'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>获取某支局下的网格名集合</e:description>
  <e:case value="grids_in_sub">
    <e:q4l var="nameList">
      SELECT DISTINCT grid_name FROM ${gis_user}.DB_CDE_GRID b WHERE union_org_code = '${param.sub_id}'
    </e:q4l>
    ${e:java2json(nameList.list)}
  </e:case>

  <e:description>已废弃 改为使用 grids_in_sub_by_substation_no， 获取某支局下的网格图层资源id集合，根据支局图层资源id select distinct resid,resname from grid_res_station_relation where subid=</e:description>
  <e:case value="grids_in_subBySubResid">
    <e:q4l var="residList">
      select distinct gridid resid from ${gis_user}.sub_station_grid_relation where subid='${param.sub_id}'
    </e:q4l>
    ${e:java2json(residList.list)}
  </e:case>

  <e:description>获取支局下网格图层资源集合，使用新视图（王明军）2017-11-29修改，以避免resid经常变动影响数据频繁更新，采用substation_no和report_to_id关联</e:description>
  <e:case value="grids_in_sub_by_substation_no">
  	<e:q4l var="dataList">
  		SELECT grid_id FROM ${gis_user}.view_sub_grid_ref WHERE union_org_code = '${param.sub_id}'
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>


  <e:description>通过网格id获取到地图服务对应的网格id</e:description>
  <e:case value="getResidByStationNo">
    <e:q4o var="dataObject">
      select station_id from ${gis_user}.SPC_BRANCH_STATION where station_no = '${param.grid_id}'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>通过支局id获取所有的网格id getVillageInfoBySubId</e:description>
  <e:case value="getGridIdBySubIdInVillage">
  	<e:q4l var="dataList">
  		select DISTINCT grid_Id from ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO t WHERE branch_no = '${param.sub_id}'
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:description>通过网格grid_union_org_code获得report_to_id</e:description>
  <e:case value="getGridUnionOrgCodeByReportToId">
  	<e:q4o var="dataObject">
  		SELECT station_no FROM ${gis_user}.spc_branch_station WHERE station_id = '${param.report_to_id}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>通过网格report_to_id获得grid_id_short</e:description>
  <e:case value="getGridIdByReportToId">
  	<e:q4o var="dataObject">
  		SELECT DISTINCT grid_id FROM ${gis_user}.db_cde_grid a,
			${gis_user}.spc_branch_station b
			WHERE a.grid_union_org_code = b.station_no
			AND b.station_id = '${param.report_to_id}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>楼宇是否被小区占用过</e:description>
  <e:case value="hasUsedInVillageByResids">
  	<e:q4l var="dataList">
  		SELECT SEGM_ID FROM ${gis_user}.tb_gis_village_addr4 WHERE segm_id in (${param.resids}) group by segm_id
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取某支局下的网格发展信息，支局网格支局层，支局下钻时候右侧联动，右下角网格数据表</e:description>
  <e:case value="getGridInfoBySubstation">
    <c:tablequery>
      select rownum,a.* from (
      select
      g.grid_id,
      g.grid_union_org_code,
      g.grid_name,
      round(m.fin_income/10000,2)fin_income,
      d.mobile_mon_cum_new,
      d.brd_mon_cum_new,
      d.itv_mon_new_install_serv,
      d.ITV_SERV_CUR_MON_NEW
      from ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m,
      ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_d   d,
      ${gis_user}.db_cde_grid                 g
      where
      g.grid_id = m.latn_id
      and m.latn_id = d.latn_id
      and m.flag = '5'
      and d.flag = '5'
      and m.statis_mon = '${param.last_month}'
      and d.stat_date = '${param.yesterday}'
      and g.grid_status = 1
      and g.grid_union_org_code is not null
      and g.union_org_code = '${param.substation}'
      )a
    </c:tablequery>
  </e:case>

	<e:description>获取某网格下小区的渗透率</e:description>
	<e:case value="getVillageInfoInGridId">
		<c:tablequery>
			SELECT
			0 rn,
			'0' VILLAGE_ID,
			'合计' VILLAGE_NAME,
			       CASE
			         WHEN NVL(sum(PEOPLE_NUM), 0) = 0 THEN
			          -1
			         ELSE
			          ROUND(sum(CTCC_MOBILE_USER_NUM) / sum(PEOPLE_NUM), 4) * 100
			       END YD_LV,
			       CASE
			         WHEN NVL(sum(ZHU_HU_SUM), 0) = 0 THEN
			          -1
			         ELSE
			          ROUND(sum(WIDEBAND_NUM) / sum(ZHU_HU_SUM), 4) * 100
			       END KD_LV,
			       CASE
			         WHEN NVL(sum(ZHU_HU_SUM), 0) = 0 THEN
			          -1
			         ELSE
			          ROUND(sum(TV_USER_NUM) / sum(ZHU_HU_SUM), 4) * 100
			       END DS_LV
			  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
			 WHERE GRID_ID = '${param.report_to_id}'
			 			 and vali_flag = 1
			 union

			SELECT ROWNUM,village_id,village_name,
			CASE WHEN nvl(people_num,0)=0 THEN -1 ELSE round(ctcc_mobile_user_num/people_num,4)*100 END yd_lv,
			     CASE WHEN NVL(zhu_hu_sum,0)=0 THEN -1 ELSE ROUND(wideband_num/zhu_hu_sum,4 )*100 END kd_lv,
			     CASE WHEN NVL(zhu_hu_sum,0)=0 THEN -1 ELSE ROUND(tv_user_num/zhu_hu_sum,4)*100 END ds_lv
			 FROM ${gis_user}.tb_gis_village_edit_info WHERE grid_id = '${param.report_to_id}' and vali_flag = 1
		</c:tablequery>
	</e:case>

  <e:description>获取某支局下的网格发展信息，支局网格支局层，支局下钻时候右侧联动，右下角网格数据表，带合计</e:description>
  <e:case value="getGridInfoBySubstation_new">
    <c:tablequery>
      select
      rownum,a.* from (
      select
      s.station_id,
      g.union_org_code,
      g.branch_name,
      g.grid_name,
      g.zoom,
      nvl(trunc(m.cdma_num_reate*100,2),-1) cdma_num_reate,
      nvl(trunc(m.brd_num_rate*100,2),-1) brd_num_rate,
      nvl(trunc(m.home_num_rate*100,2),-1) home_num_rate,
      nvl(trunc(m.h_num_rate*100,2),-1) ftth_num_rate,
      case when m1.ADDR_NUM=0 then 0
      else
      round(m1.KD_NUM/m1.ADDR_NUM*100,2) end zyl
      from
      ${gis_user}.TB_DW_GIS_GRID_COMPETE m,
      ${gis_user}.db_cde_grid g,
      ${gis_user}.SPC_BRANCH_STATION s,
      ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m1
      where
      g.grid_id = m.branch_id(+)
      and g.grid_id = m1.latn_id(+)
      and g.grid_status = 1
      and g.grid_union_org_code=s.station_no
      and g.union_org_code = '${param.substation}'
      and m1.statis_mon = '${param.last_month}'
      )a

      union

      select 0, b.*
      from (select '' station_id,
      '' union_org_code,
      '' branch_name,
      '合计' grid_name,
      0 zoom,
      case when nvl(sum(m.people_num),0) = 0 then -1 else nvl(trunc(sum(m.cdma_num)/sum(m.people_num),4)*100,-1) end cdma_num_reate,
      case when nvl(sum(m.home_num),0) = 0 then -1 else nvl(trunc(sum(m.brd_num)/sum(m.home_num),4)*100,-1) end brd_num_rate,
      case when nvl(sum(m.home_num),0) = 0 then -1 else nvl(trunc(sum(m.cdma_tv_num)/sum(m.home_num),4)*100,-1) end home_num_rate,
      0 ftth_num_rate,
      case when nvl(sum(m1.ADDR_NUM),0) = 0 then -1 else nvl(round(sum(m1.KD_NUM) / sum(m1.ADDR_NUM) , 4)* 100,-1) end zyl
      from
      ${gis_user}.TB_DW_GIS_GRID_COMPETE      m,
      ${gis_user}.db_cde_grid                 g,
      ${gis_user}.SPC_BRANCH_STATION          s,
      ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m1
      where g.grid_id = m.branch_id(+)
      and g.grid_id = m1.latn_id(+)
      and g.grid_status = 1
      and g.grid_union_org_code = s.station_no
      and g.union_org_code = '${param.substation}'
      and m1.statis_mon = '${param.last_month}') b
    </c:tablequery>
  </e:case>

  <e:description>获取某支局下的网格发展信息，支局网格支局层，支局下钻时候右侧联动，右下角网格数据表，不带合计</e:description>
  <e:case value="getGridInfoBySubstation_new_two">
    <c:tablequery>
      select
      rownum,a.* from (
      select
      s.station_id,
      g.union_org_code,
      g.branch_name,
      g.grid_name,
      g.zoom,
      nvl(trunc(m.cdma_num_reate*100,2),-1) cdma_num_reate,
      nvl(trunc(m.brd_num_rate*100,2),-1) brd_num_rate,
      nvl(trunc(m.home_num_rate*100,2),-1) home_num_rate,
      nvl(trunc(m.h_num_rate*100,2),-1) ftth_num_rate,
      case when m1.ADDR_NUM=0 then 0
      else
      round(m1.KD_NUM/m1.ADDR_NUM*100,2) end zyl
      from
      ${gis_user}.TB_DW_GIS_GRID_COMPETE m,
      ${gis_user}.db_cde_grid g,
      ${gis_user}.SPC_BRANCH_STATION s,
      ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m1
      where
      g.grid_id = m.branch_id(+)
      and g.grid_id = m1.latn_id(+)
      and g.grid_status = 1
      and g.grid_union_org_code=s.station_no
      and g.union_org_code = '${param.substation}'
      and m1.statis_mon = '${param.last_month}'
      )a
    </c:tablequery>
  </e:case>

 <e:description>获取支局下网格的资源</e:description>
 <e:case value="getGridResourceBySubstation">
    <c:tablequery>
      SELECT ROWNUM, A.*
 			 FROM (SELECT S.STATION_ID,
               G.UNION_ORG_CODE,
               G.BRANCH_NAME,
               G.GRID_NAME,
               G.ZOOM,
               nvl(T.gz_zhu_hu_count,0) ZHU_HU_COUNT,
               nvl(T.port_id_cnt,0) PORT,
               nvl(t.kong_port_cnt,0) PORT_FREE,
               CASE
                 WHEN NVL(T.port_id_cnt, 0) = 0 THEN
                  '0.00%'
                 ELSE
                  to_char(round(nvl(T.use_port_cnt,0) / T.port_id_cnt, 4) * 100,'FM9999.00') || '%'
               END PORT_LV
          FROM ${gis_user}.DB_CDE_GRID                 G,
               ${gis_user}.SPC_BRANCH_STATION          S,
               ${gis_user}.tb_gis_res_city_day				 T
         WHERE G.GRID_ID = T.LATN_ID(+)
           AND G.GRID_STATUS = 1
           AND G.GRID_UNION_ORG_CODE = S.STATION_NO
           AND G.UNION_ORG_CODE = '${param.substation}'
           and g.grid_id = t.latn_Id
           and t.flg = 4
           ) A
				UNION
				select 0,b.*
					from (
						SELECT '' STATION_ID,
               '' UNION_ORG_CODE,
               '' BRANCH_NAME,
               '合计' GRID_NAME,
               0 ZOOM,
               nvl(T.gz_zhu_hu_count,0) ZHU_HU_COUNT,
               nvl(T.port_id_cnt,0) PORT,
               nvl(t.kong_port_cnt,0) PORT_FREE,
               CASE
                 WHEN NVL(T.port_id_cnt, 0) = 0 THEN
                  '0.00%'
                 ELSE
                  to_char(round(nvl(T.use_port_cnt,0) / T.port_id_cnt, 4) * 100,'FM9999.00') || '%'
               END PORT_LV
            FROM
            	${gis_user}.tb_gis_res_city_day				 T
            	where flg =3
            	and latn_id = '${param.substation}'
					)b
    </c:tablequery>
  </e:case>

  <e:description>获取网格下的小区资源</e:description>
  <e:case value="getVillageResourceByGridId">
    <c:tablequery>
    	<e:description>
      SELECT ROWNUM,
       VILLAGE_ID,
       VILLAGE_NAME,
       nvl(ZHU_HU_SUM,-1) ZHU_HU_SUM,
       nvl(PEOPLE_NUM,-1) PEOPLE_NUM,
       nvl(PORT_SUM,-1) PORT,
       nvl(PORT_FREE_SUM,-1) PORT_FREE,
       CASE
         WHEN NVL(PORT_SUM, 0) = 0 THEN
          -1
         ELSE
          ROUND(PORT_USED_SUM / PORT_SUM, 4) * 100
       END PORT_LV
		  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO T
		 WHERE T.GRID_ID = '${param.report_to_id}'
		 and t.vali_flag = 1

		    UNION

   SELECT 0,
       '0' VILLAGE_ID,
       '合计' VILLAGE_NAME,
       NVL(sum(ZHU_HU_SUM), -1) ZHU_HU_SUM,
       NVL(sum(PEOPLE_NUM), -1) PEOPLE_NUM,
       -1 PORT,
       -1 PORT_FREE,
       -1 PORT_LV
		  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO T
		 WHERE T.GRID_ID = '${param.report_to_id}'
		   AND T.VALI_FLAG = 1
		   </e:description>


		   SELECT ROWNUM, A.VILLAGE_ID, A.VILLAGE_NAME,
		   		NVL(GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,
          NVL(PORT_ID_CNT, 0) PORT_ID_CNT,
          NVL(KONG_PORT_CNT, 0) KONG_PORT_CNT,
          CASE
            WHEN NVL(PORT_ID_CNT, 0) = 0 THEN
             '0.00%'
            ELSE
             TO_CHAR(ROUND(NVL(USE_PORT_CNT, 0) /
                           NVL(PORT_ID_CNT, 0),
                           4) * 100,
                     'fm9999.00') || '%'
          END PORT_LV
			  FROM (SELECT VILLAGE_ID, VILLAGE_NAME
			          FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
			         WHERE GRID_ID = '${param.report_to_id}') A
			  LEFT JOIN (SELECT LATN_ID,
			                    GZ_ZHU_HU_COUNT,
			                    PORT_ID_CNT,
			                    KONG_PORT_CNT,
			                    USE_PORT_CNT
			               FROM ${gis_user}.TB_GIS_RES_INFO_DAY
			              WHERE FLG = 5) B
			    ON A.VILLAGE_ID = B.LATN_ID
    </c:tablequery>
  </e:case>

  <e:description>支局收入格数据表格</e:description>
  <e:case value="getGridInfoBySubstation_zjsr">
  	 <c:tablequery>
       SELECT ROWNUM, A.*
 			 	FROM (SELECT G.GRID_ID,
               G.GRID_UNION_ORG_CODE,
               G.GRID_NAME,
               trunc(m.income_ratio*100,2) income_ratio,
               trunc(m.fin_income/10000,2) fin_income,
               trunc(n.fin_income/10000,2) fin_income_last,
               g.UNION_ORG_CODE,
               g.BRANCH_NAME,
               g.ZOOM,
               q.STATION_ID
          FROM ${gis_user}.DB_CDE_GRID                 G
          		LEFT JOIN ${gis_user}.SPC_BRANCH_STATION q
            	ON q.station_no = g.grid_union_org_code,
             ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON M
            LEFT JOIN ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON N
            ON M.LATN_ID = N.LATN_ID

         WHERE G.GRID_ID = M.LATN_ID
           AND M.FLAG = '5'
           AND G.GRID_STATUS = 1
           AND M.STATIS_MON = '${param.last_month}'
           AND n.STATIS_MON = '${param.beforeLastMonth}'
           AND G.GRID_UNION_ORG_CODE IS NOT NULL
           AND G.UNION_ORG_CODE = '${param.substation}') A
			UNION
			SELECT 0,
			       '' GRID_ID,
			       '' GRID_UNION_ORG_CODE,
			       '合计' GRID_NAME,
			       CASE WHEN NVL(sum(n.fin_income),0) = 0 THEN -1 ELSE
			           ROUND(sum(m.fin_income)/sum(n.fin_income)-1,4 )*100 END
			        income_ratio,
			       trunc(sum(m.fin_income)/10000,2) fin_income,
			       trunc(sum(n.fin_income)/10000,2) fin_income_last,
			       ' ' UNION_ORG_CODE,
             ' ' BRANCH_NAME,
             0 ZOOM,
             ' ' STATION_ID
			  FROM ${gis_user}.DB_CDE_GRID                 G,
			             ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON M
			            LEFT JOIN ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON N
			            ON M.LATN_ID = N.LATN_ID
			         WHERE G.GRID_ID = M.LATN_ID
			           AND M.FLAG = '5'
			           AND G.GRID_STATUS = 1
			           AND M.STATIS_MON = '${param.last_month}'
			           AND n.STATIS_MON = '${param.beforeLastMonth}'
			           AND G.GRID_UNION_ORG_CODE IS NOT NULL
			           AND G.UNION_ORG_CODE = '${param.substation}'
     </c:tablequery>
  </e:case>

  <e:description>网格收入数据表格</e:description>
  <e:case value="getGridInfoBySubstation_wgsr">
  	 <c:tablequery>
  	 	 SELECT * FROM (
				SELECT
		       B.GRID_ID,
		       B.GRID_UNION_ORG_CODE,
		       B.GRID_NAME,
		       TRUNC(A.INCOME_RATIO * 100, 2) INCOME_RATIO,
		       TRUNC(A.FIN_INCOME / 10000, 2) FIN_INCOME,
		       CASE
		         WHEN INCOME_RATIO = 0 THEN
		          0
		         WHEN INCOME_RATIO IS NULL THEN
		          0
		         ELSE
		          TRUNC((FIN_INCOME / (INCOME_RATIO + 1)) / 10000, 2)
		       END FIN_INCOME_LAST,
		       0 ord
				  FROM ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON A, ${gis_user}.DB_CDE_GRID B
				 WHERE A.LATN_ID =
				       (SELECT DISTINCT GRID_ID
				          FROM ${gis_user}.DB_CDE_GRID
				         WHERE GRID_UNION_ORG_CODE =
				               (SELECT STATION_NO
				                  FROM ${gis_user}.SPC_BRANCH_STATION T
				                 WHERE T.STATION_ID = '${param.report_to_id}'))
				   AND A.LATN_ID = B.GRID_ID
				   AND A.STATIS_MON = '${param.last_month}'
				   AND A.FLAG = '5'
				UNION
				SELECT A.*,ROWNUM ord
				  FROM (SELECT G.GRID_ID,
		               G.GRID_UNION_ORG_CODE,
		               G.GRID_NAME,
		               TRUNC(M.INCOME_RATIO * 100, 2) INCOME_RATIO,
		               TRUNC(M.FIN_INCOME / 10000, 2) FIN_INCOME,
		               TRUNC(N.FIN_INCOME / 10000, 2) FIN_INCOME_LAST
		          FROM ${gis_user}.DB_CDE_GRID                 G,
		               ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON M
		          LEFT JOIN ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON N
		            ON M.LATN_ID = N.LATN_ID
		         WHERE G.GRID_ID = M.LATN_ID
		           AND M.FLAG = '5'
		           AND G.GRID_STATUS = 1
		           AND M.STATIS_MON = '${param.last_month}'
		           AND N.STATIS_MON = '${param.beforeLastMonth}'
		           AND G.GRID_UNION_ORG_CODE IS NOT NULL
		           AND G.UNION_ORG_CODE = '${param.substation}'
		           AND M.LATN_ID <>
		               (SELECT DISTINCT GRID_ID
		                  FROM ${gis_user}.DB_CDE_GRID
		                 WHERE GRID_UNION_ORG_CODE =
		                       (SELECT STATION_NO
		                          FROM ${gis_user}.SPC_BRANCH_STATION T
		                         WHERE T.STATION_ID = '${param.report_to_id}'))) A
				) ORDER BY ord
			</c:tablequery>
  </e:case>

  <e:description>网格收入数据表格，已废弃</e:description>
  <e:case value="getGridInfoBySubstation_wgsr_nouse_bak">
  	 <c:tablequery>
        select * from ( select
         ROWNUM,
        '合计' sr_name,
        trunc(a.income_ratio*100,2) income_ratio,
        trunc(a.fin_income/10000,2) fin_income,
        case  when income_ratio=0 then 0
        	  when income_ratio is null then 0
        else trunc((fin_income/(income_ratio+1))/10000,2)  end sy_income,
        '1' px
        from ${gis_user}.tb_dw_gis_zhi_ju_income_mon a   , ${gis_user}.DB_CDE_GRID b
        where a.latn_id = (SELECT distinct grid_id FROM ${gis_user}.DB_CDE_GRID
        WHERE GRID_UNION_ORG_CODE = (select station_no from ${gis_user}.spc_branch_station t where t.station_id='${param.report_to_id}')
        )
         and a.latn_id=b.grid_id
        and a.statis_mon = '${param.last_month}'
        and a.flag = '5'

         union

        select
        ROWNUM,
        b.grid_name sr_name,
        trunc(a.income_ratio*100,2) income_ratio,
        trunc(a.fin_income/10000,2) fin_income,
        case  when income_ratio=0 then 0
        	  when income_ratio is null then 0
        else trunc((fin_income/(income_ratio+1))/10000,2)  end sy_income,
        '2' px
        from ${gis_user}.tb_dw_gis_zhi_ju_income_mon a   , ${gis_user}.DB_CDE_GRID b
        where a.latn_id = (SELECT distinct grid_id FROM ${gis_user}.DB_CDE_GRID
        WHERE GRID_UNION_ORG_CODE = (select station_no from ${gis_user}.spc_branch_station t where t.station_id='${param.report_to_id}')
        )
         and a.latn_id=b.grid_id
        and a.statis_mon = '${param.last_month}'
        and a.flag = '5') order by px asc
     </c:tablequery>
  </e:case>

  <e:description>获取某支局下的网格发展信息，支局网格支局层，支局下钻时候右侧联动，右下角网格数据表，已废弃</e:description>
  <e:case value="getGridInfoBySubstation_grid_new_old">
    <c:tablequery>
      select c.* from (
      select rownum,a.*, b.latn_id CITY_ID,b.union_org_code SUB_ID,b.bureau_no BREAU_ID
      from (
      select
      m.grid_id,
      m.VILLAGE_ID,
      m.village_name,
      BEN_GIS_UPLOAD,
      nvl(trunc(m.mobile_st_rate*100,2),-1) mobile_st_rate,
      nvl(trunc(m.wideband_st_rate*100,2),-1) wideband_st_rate,
      nvl(trunc(m.iptv_st_rate*100,2),-1) iptv_st_rate,
      nvl(trunc(m.h_user_st_rate*100,2),-1) h_user_st_rate
      from ${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY m
      where m.grid_id = (SELECT distinct grid_id FROM ${gis_user}.DB_CDE_GRID
      WHERE grid_union_org_code = (select station_no from ${gis_user}.spc_branch_station where station_id = '${param.report_to_id}')
      )
      and m.village_name is not null
      order by BEN_GIS_UPLOAD desc
      )a,${gis_user}.DB_CDE_GRID b
      where a.grid_id = b.grid_id)
      c
    </c:tablequery>
  </e:case>
  <e:description>市场发展标签 获取网格下的小区信息</e:description>
  <e:case value="getGridInfoBySubstation_grid_new">
    <c:tablequery>
    	select b.* from (
    	select rownum,a.* from (
    	select m.village_id,
       m.village_name,
       case when m.ctcc_mobile_user_num is null then -1 else trunc(m.ctcc_mobile_user_num / m.people_num*100,2) end mobile_st_rate,
       case when m.wideband_num is null then -1 else trunc(m.wideband_num/ n.ZHU_HU_COUNT*100,2) end wideband_st_rate,
       case when m.tv_user_num is null then -1 else trunc( m.tv_user_num/ n.ZHU_HU_COUNT*100,2) end iptv_st_rate,
       case when m.h_user_num is null then -1 else trunc(m.h_user_num /n.ZHU_HU_COUNT*100,2) end h_user_st_rate
			from
			${gis_user}.tb_gis_village_edit_info m,
			(select t.village_id ,
			        sum(t1.zhu_hu_count) zhu_hu_count
			from ${gis_user}.tb_gis_village_addr4 t,
			       ${gis_user}.TB_GIS_ADDR_INFO_VIEW t1
			where t.segm_id = t1.segm_id
			group by village_id) n
			where m.village_id = n.village_id
			and m.vali_flag = 1
			and m.grid_id = '${param.report_to_id}')a)b
    </c:tablequery>
  </e:case>

  <e:description>获取某地市下的网格名集合</e:description>
  <e:case value="grid_nameList_by_latn">
    <e:q4l var="nameList">
      SELECT grid_Name FROM ${gis_user}.DB_CDE_GRID WHERE latn_name = '${param.city_name}' ORDER BY grid_name
    </e:q4l>
    ${e:java2json(nameList.list)}
  </e:case>

  <e:description>支局清单</e:description>
  <e:case value="sub_list_detail">
    <e:q4l var="zhijuList">
      select * from(select
      rownum rn,s.*,
      case when s.addr_num1 is null then '--'
      else to_char(s.addr_num1) end addr_num,
      case when s.use_rate1 = -1 then '--'
      else to_char(s.use_rate1*100,'999.99') || '%' end use_rate
      from ( select
      <e:description>支局名称、本地网、区县、支局类型</e:description>
      c.branch_name,
      c.latn_id,
      c.latn_name,
      c.bureau_no,
      c.bureau_name,
      c.zoom,
      case
      when a.branch_type = 'a1' then
      '城市'
      when a.branch_type = 'b1' then
      '农村'
      when a.branch_type = 'c1' then
      '政企'
      end branch_type,

      <e:description>移动用户本月累计新增、移动用户日新增、宽带用户本月累计新增、宽带用户日新增、ITV本月累计新增、ITV当日新增、ITV本月累计装机、ITV当日装机</e:description>
      mobile_serv_cur_mon_cum_new,
      mobile_serv_day_new,
      brd_serv_cur_mon_cum_new,
      brd_serv_day_new,
      itv_serv_cur_mon_new,
      itv_serv_day_new,

      <e:description>移动渗透率、宽带渗透率、电视渗透率</e:description>
      case when d.cdma_num_reate is null then '--'
      else to_char(round(nvl(d.cdma_num_reate,0) * 100, 2),
                                  'fm999990.00') || '%' end cdma_num_reate,
      case when d.brd_num_rate is null then '--'
      else to_char(round(nvl(d.brd_num_rate,0) * 100, 2),
                                  'fm999990.00') || '%' end brd_num_rate,
			case when d.home_num_rate is null then '--'
      else to_char(round(nvl(d.home_num_rate,0) * 100, 2),
                                  'fm999990.00') || '%' end home_num_rate,
      case when m.CDMA_NUM_REATE is null then '--'
      else to_char(round(m.CDMA_NUM_REATE*100,2),'fm999990.00') || '%' end  CDMA_NUM_REATE1,
      case when m.BRD_NUM_RATE is null then '--'
      else to_char(round(m.BRD_NUM_RATE*100,2),'fm999990.00') || '%' end BRD_NUM_RATE1,
      case when m.home_num_rate is null then '--'
      else to_char(round(m.home_num_rate*100,2),'fm999990.00') || '%' end home_num_rate1,

      <e:description>本月累计销售终端、智能机、占比、800M终端、占比</e:description>
      terminal_total_mon,
      znj_count_mon,
      count_800m_mon,

      a.addr_num addr_num1,
      case when a.kd_num is null then '--'
      else to_char(a.kd_num) end kd_num,
      nvl(a.use_rate,-1) use_rate1,

      case when a.ftth_port_num is null then '--'
      else to_char(a.ftth_port_num) end ftth_port_num,
      a.ftth_port_zy_num,
      case when a.port_rate is null then '--'
      else to_char(a.port_rate*100,'999.99') || '%' end port_rate,


      <e:description>预算目标、本年累计收入、预算完成率、列账收入、收入环比、移动本年累计收入、移动预算完成率、移动列账收入、移动收入环比、固网本年累计收入、固网收入预算完成率、固网列账收入、固网收入环比</e:description>
      nvl(round(m.all_ys,2)||'','--') all_ys,
      round(a.y_cum_income/10000,2) y_cum_income,
      case when m.income_budget_finish_rate is null then '--'
      else to_char(round(a.income_budget_finish_rate * 100, 2),'999.99') || '%' end income_budget_finish_rate,
      round(a.fin_income/10000,2) fin_income,
      round(a.mobile_y_cum_income/10000,2) mobile_y_cum_income,
      round(a.pstn_y_cum_income/10000,2) pstn_y_cum_income,

      <e:description>经营利润、总收入、移动收入、固网收入、宽带收入、客户维系费、业务招待费、物业管理费、员工交通费、会议费、预算下达类成本、人工成本、营销费用、网运成本、管理费用、事后归集类成本、宽带端口占用费、欠费</e:description>
      round(operate_profit/10000,2) operate_profit,
      round(cum_owed/10000,2) cum_owed,
      c.union_org_code,
      round(OPERATE_PROFIT_YEAR/10000,2) OPERATE_PROFIT_MON_YEAR

      from ${gis_user}.dw_branch_dev_d a
      left join ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m
      on m.latn_id = a.branch_id
      and m.statis_mon = '${param.mon}'
      and m.flag = 4
      left join (select cdma_num_reate,brd_num_rate,home_num_rate,branch_id from ${gis_user}.TB_DW_GIS_GRID_COMPETE where type = 4)d
      on a.branch_id = d.branch_id
      left join (select distinct branch_no,
      branch_name,
      latn_id,
      latn_name,
      bureau_no,
      replace(bureau_name,'分局','') bureau_name,
      union_org_code,
      region_order_num,
      zoom
      from ${gis_user}.DB_CDE_GRID
      ) c
      on a.branch_id = c.branch_no
      where a.acct_day = '${param.date}' and
      a.branch_type in ('a1','b1')
      <e:if condition="${param.region_id ne '999'}">
        and a.latn_id = '${param.region_id}'
      </e:if>
      <e:if condition="${empty(param.branch_name)}" var="empty_branch_name">
      </e:if>
      <e:else condition="${empty_branch_name}">
        and c.branch_name like '%' || '${param.branch_name}' || '%'
      </e:else>
      <e:if condition="${param.union_code != null && param.union_code ne ''}">
        and a.branch_type = '${param.union_code}'
      </e:if>
      order by  use_rate1
      <e:if condition="${param.sort_world == null || param.sort_world eq '' || param.sort_world eq '1'}">
        desc
      </e:if>


      ) s)
      where rn <= ${param.end}
      and rn > ${param.begin}

    </e:q4l>
    ${e:java2json(zhijuList.list)}
  </e:case>

  <e:case value="sub_list_count">
    <e:q4l var="zhijuList">
      select
      case
      when a.branch_type = 'a1' then
      '城市'
      when a.branch_type = 'b1' then
      '农村'
      when a.branch_type = 'c1' then
      '政企'
      end branch_type

      from ${gis_user}.dw_branch_dev_d a
      left join ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m
      on m.latn_id = a.branch_id
      and m.statis_mon = '${param.mon}'
      and m.flag = 4
      left join (select distinct branch_no,
      branch_name,
      latn_id,
      latn_name,
      bureau_no,
      replace(bureau_name,'分局','') bureau_name,
      union_org_code,
      region_order_num
      from ${gis_user}.DB_CDE_GRID
      ) c
      on a.branch_id = c.branch_no
      where a.acct_day = '${param.date}' and
      a.branch_type in ('a1','b1')
      <e:if condition="${param.region_id ne '999'}">
        and a.latn_id = '${param.region_id}'
      </e:if>
      <e:if condition="${empty(param.branch_name)}" var="empty_branch_name">
      </e:if>
      <e:else condition="${empty_branch_name}">
        and c.branch_name like '%' || '${param.branch_name}' || '%'
      </e:else>
      <e:if condition="${param.union_code != null && param.union_code ne ''}">
        and a.branch_type = '${param.union_code}'
      </e:if>
    </e:q4l>
    ${e:java2json(zhijuList.list)}
  </e:case>

  <e:description>网格清单</e:description>
  <e:case value="wg_list_detail">
    <e:q4l var="wanggeList">
      select * from (
      select
      rownum rn,s.*,
      case
      when s.use_rate1 = -1 then
      '--'
      else
      to_char(s.use_rate1*100,'999.99')||'%'
      end use_rate from (
      select
      <e:description>网格名称、本地网、区县、支局名称、支局类型</e:description>
      c.grid_name,
      c.latn_id,
      c.latn_name,
      c.bureau_no,
      c.bureau_name,
      c.branch_name,
      case
      when c.branch_type = 'a1' then
      '城市'
      when c.branch_type = 'b1' then
      '农村'
      when c.branch_type = 'c1' then
      '政企'
      end branch_type,

      <e:description>移动用户本月累计新增、移动用户日新增、宽带用户本月累计新增、宽带用户日新增、ITV本月累计新增、ITV当日新增、ITV本月累计装机、ITV当日装机</e:description>
      MOBILE_MON_CUM_NEW,
      MOBILE_SERV_DAY_NEW,
      BRD_MON_CUM_NEW,
      BRD_SERV_DAY_NEW,
      ITV_SERV_CUR_MON_NEW,
      ITV_SERV_DAY_NEW,
      ITV_MON_NEW_INSTALL_SERV,
      ITV_DAY_NEW_INSTALL_SERV,

      <e:description>本月累计销售终端、智能机、占比、800M终端、占比</e:description>
      case
      when m.addr_num is null then
      '--'
      else
      to_char(m.addr_num)
      end addr_num,
      case
      when m.kd_num is null then
      '--'
      else
      to_char(m.kd_num)
      end kd_num,
      nvl(use_rate,-1) use_rate1,
      case
      when m.FTTH_PORT_NUM is null then
      '--'
      else
      to_char(m.FTTH_PORT_NUM)
      end ftth_port_num,
      m.FTTH_PORT_ZY_NUM,
      case
      when port_rate is null then
      '--'
      else
      round(port_rate*100,2)||'%'
      end port_rate,

      case when n.CDMA_NUM_REATE is null then '--'
      else to_char(round(n.CDMA_NUM_REATE*100,2),'fm999990.00') || '%' end  CDMA_NUM_REATE,
      case when n.BRD_NUM_RATE is null then '--'
      else to_char(round(n.BRD_NUM_RATE*100,2),'fm999990.00') || '%' end BRD_NUM_RATE,
      case when n.home_num_rate is null then '--'
      else to_char(round(n.home_num_rate*100,2),'fm999990.00') || '%' end home_num_rate,
      case when n.h_num_rate is null then '--'
      else to_char(round(n.h_num_rate*100,2),'fm999990.00') || '%' end h_num_rate,


      <e:description>本年累计收入、预算完成率、列账收入、收入环比、移动本年累计收入、移动预算完成率、移动列账收入、移动收入环比、固网本年累计收入、固网收入预算完成率、固网列账收入、固网收入环比</e:description>
      nvl(round(m.y_cum_income / 10000, 2)||'','--') y_cum_income,
      case when m.income_budget_finish_rate is null then '--'
      else to_char(round(m.income_budget_finish_rate * 100, 2),'999.99') || '%' end income_budget_finish_rate,
      nvl(round(m.fin_income / 10000, 2)||'','--') fin_income,
      round(m.mobile_y_cum_income / 10000, 2) mobile_y_cum_income,
      round(m.pstn_y_cum_income / 10000, 2) pstn_y_cum_income,

      <e:description>经营利润、总收入、移动收入、固网收入、宽带收入、客户维系费、业务招待费、物业管理费、员工交通费、会议费、预算下达类成本、人工成本、营销费用、网运成本、管理费用、事后归集类成本、宽带端口占用费、欠费</e:description>
      case when m.OPERATE_PROFIT_MON is null then '--'
      else to_char(round(m.OPERATE_PROFIT_MON / 10000, 2)) end operate_profit,
      c.union_org_code,
      case when m.OPERATE_PROFIT_MON_YEAR is null then '--'
      else to_char(round(m.OPERATE_PROFIT_MON_YEAR / 10000, 2)) end OPERATE_PROFIT_MON_YEAR
      from ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_D a
      left join ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m
      on a.latn_id = m.latn_id
      and m.statis_mon ='${param.mon}'
      and m.flag = 5
      left join ${gis_user}.Tb_Dw_Gis_Grid_Compete n
      on a.latn_id = n.branch_id
      and n.type = 5
      left join (select distinct grid_id,
      grid_name,
      branch_no,
      branch_name,
      branch_type,
      GRID_STATUS,
      grid_union_org_code,
      latn_id,
      latn_name,
      bureau_no,
      replace(bureau_name, '分局', '') bureau_name,
      union_org_code,
      region_order_num
      from ${gis_user}.DB_CDE_GRID) c
      on a.latn_id = c.grid_id
      where a.stat_date = '${param.date}' and
      c.branch_type in ('a1','b1')
      and a.flag = 5
      and c.GRID_STATUS = 1
      <e:if condition="${param.region_id ne '999' && param.region_id != '' && param.region_id != null}">
        and c.latn_id = '${param.region_id}'
      </e:if>
      <e:if condition="${empty(param.grid_name)}" var="empty_grid_name">
      </e:if>
      <e:else condition="${empty_grid_name}">
        and c.grid_name like '%' || '${param.grid_name}' || '%'
      </e:else>
      <e:if condition="${param.union_code_gw != null && param.union_code_gw ne ''}">
        and c.branch_type = '${param.union_code_gw}'
      </e:if>
      order by  use_rate1
      <e:if condition="${param.sort_world == null || param.sort_world eq '' || param.sort_world eq '1'}">
        desc
      </e:if>
      ) s )
      where rn <= ${param.end}
      and rn > ${param.begin}
    </e:q4l>
    ${e:java2json(wanggeList.list)}
  </e:case>

  <e:case value="wg_list_count">
    <e:q4l var="wanggeList">
      select
      case
      when c.branch_type = 'a1' then
      '城市'
      when c.branch_type = 'b1' then
      '农村'
      when c.branch_type = 'c1' then
      '政企'
      end branch_type
      from ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_D a
      left join ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m
      on a.latn_id = m.latn_id
      and m.statis_mon ='${param.mon}'
      and m.flag = 5
      left join ${gis_user}.Tb_Dw_Gis_Grid_Compete n
      on a.latn_id = n.branch_id
      and n.type = 5
      left join (select distinct grid_id,
      grid_name,
      branch_no,
      branch_name,
      branch_type,
      GRID_STATUS,
      grid_union_org_code,
      latn_id,
      latn_name,
      bureau_no,
      replace(bureau_name, '分局', '') bureau_name,
      union_org_code,
      region_order_num
      from ${gis_user}.DB_CDE_GRID) c
      on a.latn_id = c.grid_id
      where a.stat_date = '${param.date}' and
      c.branch_type in ('a1','b1')
      and a.flag = 5
      and c.GRID_STATUS = 1
      <e:if condition="${param.region_id ne '999' && param.region_id != '' && param.region_id != null}">
        and c.latn_id = '${param.region_id}'
      </e:if>
      <e:if condition="${empty(param.grid_name)}" var="empty_grid_name">
      </e:if>
      <e:else condition="${empty_grid_name}">
        and c.grid_name like '%' || '${param.grid_name}' || '%'
      </e:else>
      <e:if condition="${param.union_code_gw != null && param.union_code_gw ne ''}">
        and c.branch_type = '${param.union_code_gw}'
      </e:if>
    </e:q4l>
    ${e:java2json(wanggeList.list)}
  </e:case>

	<e:description>获取左侧营销列表的数量</e:description>
	<e:case value="getYxVillageCount_YxVillageList">
		<e:q4o var="dataObject">
			SELECT count(1) COUNT
			FROM ${gis_user}.VIEW_GIS_ALL_GRID_VILLAGE A,
			       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE  B
			 WHERE A.VILLAGE_ID = B.VILLAGE_ID
			   AND B.YX_ALL > 0
			<e:if condition="${param.latn_id != ''}">
				and a.latn_id = '${param.latn_id}'
			</e:if>
			<e:if condition="${param.bureau_no != ''}">
				and a.bureau_no = '${param.bureau_no}'
			</e:if>
			<e:if condition="${param.union_org_code != ''}">
				and a.union_org_code = '${param.union_org_code}'
			</e:if>
			<e:if condition="${param.grid_id != ''}">
				and (a.grid_id = '${param.grid_id}' or a.grid_union_org_code = '${param.grid_id}')
			</e:if>
			<e:if condition="${!empty param.village_name}">
				and a.village_name like '%${param.village_name}%'
			</e:if>
		</e:q4o>${dataObject.COUNT}
	</e:case>

  <e:description>支局网格 左侧列表功能</e:description>
  <e:case value="getSubListByLatnId">
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
      t.branch_type in ('a1','b1')
      order by t.latn_id,branch_show desc,t.region_order_num asc
      ) a
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>查询某个支局，参数是支局id</e:description>
  <e:case value="getSubInfoBySubId">
    <e:q4o var="dataObject">
      select
      a.union_org_code,
      a.color,
      a.branch_no,
      a.branch_name,
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
      select distinct union_org_code, color, t.branch_no,t.branch_type,t.branch_hlzoom,t.branch_name
      from ${gis_user}.db_cde_grid t
      where latn_id = '${param.city_id}'
      and t.grid_status = 1
      and branch_type in ('a1', 'b1')
      and t.union_org_code = '${param.sub_id}'
      ) a,
      ${gis_user}.tb_dw_gis_zhi_ju_income_d g,
      ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m
      where a.branch_no = g.latn_id
      and m.latn_id = g.latn_id
      and g.stat_date = '${param.yesterday}'
      and g.flag = 4
      and m.statis_mon = '${param.last_month}'
      and m.flag = '4'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>获取某网格的发展数据 弹出窗展示</e:description>
  <e:case value="getGridDevByRepttoNo">
    <e:q4o var="dataObject">
      select
      mobile_mon_cum_new ,mobile_serv_day_new ,
      brd_mon_cum_new ,brd_serv_day_new ,
      itv_serv_cur_mon_new ,itv_serv_day_new ,
      cur_terminal_total_mon ,la_terminal_total ,
      cur_count_800m_mon ,la_count_800m,
      c.branch_name
      from ${gis_user}.tb_dw_gis_zhi_ju_income_d d,
      (select grid_id, branch_name
      from ${gis_user}.db_cde_grid g, ${gis_user}.spc_branch_station a
      where a.station_id = '${param.repttoNo}'
      and g.grid_union_org_code = a.station_no) c
      where d.latn_id = c.grid_id
      and d.stat_date = '${param.date}'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>获取支局颜色 城市 农村</e:description>
  <e:case value="getSubColorByLatnId">
    <e:q4l var = "dataList">
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
	      <e:if condition="${param.id !=''&& param.id !=null}">
	        and t.bureau_no = ${param.id}
	      </e:if>
	      <e:if condition="${param.sub_id!='' && param.sub_id!=null}">
	      	and t.union_org_code = '${param.sub_id}'
	      </e:if>
	      and branch_type in ('a1', 'b1')) a,
	      (SELECT * FROM ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_D WHERE STAT_DATE = '${param.yesterday}' AND FLAG = 4) G,
	      (SELECT * FROM ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON WHERE STATIS_MON = '${param.last_month}' AND FLAG = '4') M
	       WHERE A.BRANCH_NO = G.LATN_ID(+)
   			 AND A.BRANCH_NO = M.LATN_ID(+)
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:description>获取支局颜色 已废弃</e:description>
  <e:description>
  	SELECT
					 UNION_ORG_CODE,
					 COLOR,
					 T.BUREAU_NAME,
					 T.BRANCH_NO,
					 case when t.branch_type = 'a1' then '城市' when t.branch_type = 'b1' then '农村' end branch_type,
					 T.grid_show,
					 T.BRANCH_HLZOOM,
					 COUNT(CASE
					         WHEN T.Grid_Union_Org_Code != -1 and T.GRID_STATUS = 1 THEN
					          1
					       END) GRID_ID_CNT
					  FROM ${gis_user}.DB_CDE_GRID T
					 where latn_id = '${param.city_id}'
			      <e:if condition="${param.id !=''&& param.id !=null}">
			        and t.bureau_no = ${param.id}
			      </e:if>
			      <e:if condition="${param.sub_id!='' && param.sub_id!=null}">
			      	and t.union_org_code = '${param.sub_id}'
			      </e:if>
					   AND BRANCH_TYPE IN ('a1', 'b1')
					 GROUP BY UNION_ORG_CODE,
					          COLOR,
					          T.BUREAU_NAME,
					          T.BRANCH_NO,
					          T.BRANCH_TYPE,
					          T.GRID_SHOW,
					          T.BRANCH_HLZOOM
  </e:description>

  <e:case value="getSubColorByLatnId_nouse_bak">
    <e:q4l var = "dataList">
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
      <e:if condition="${param.id !=''&& param.id !=null}">
        and t.bureau_no = ${param.id}
      </e:if>
      <e:if condition="${param.sub_id!='' && param.sub_id!=null}">
      	and t.union_org_code = '${param.sub_id}'
      </e:if>
      and t.grid_status = 1
      and branch_type in ('a1', 'b1')) a,
      ${gis_user}.tb_dw_gis_zhi_ju_income_d g,
      ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m
      where a.branch_no = g.latn_id
      and m.latn_id = g.latn_id
      and g.stat_date = '${param.yesterday}'
      and g.flag = 4
      and m.statis_mon = '${param.last_month}'
      and m.flag = '4'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>支局网格 end</e:description>

  <e:description>渠道网点 begin</e:description>
  <e:description>渠道网点 各级（市、网点）重点指标 右侧联动 展示某个地市的三个发展数字</e:description>
  <e:case value="index_get_channel">
    <e:q4l var="dataList">
      select *
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where up_time = (select max(up_time)
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where up_time <= sysdate) and latn_id = '${param.city_id}'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>渠道网点 各级（市、网点）重点指标 右侧联动 展示某个地市月累计及环比</e:description>
  <e:case value="index_get_channel_month_add_hb">
    <e:q4o var="dataObject">
      select
      yd_mon_add_cnt,case when yd_last_mon_add_cnt = 0 then 0 else trunc((yd_mon_add_cnt-yd_last_mon_add_cnt)/yd_last_mon_add_cnt ,3)*100 end hb_yd,
      kd_mon_add_cnt,case when kd_last_mon_add_cnt = 0 then 0 else trunc((kd_mon_add_cnt-kd_last_mon_add_cnt)/kd_last_mon_add_cnt ,3)*100 end hb_kd,
      itv_mon_add_cnt,case when itv_last_mon_add_cnt = 0 then 0 else trunc((itv_mon_add_cnt-itv_last_mon_add_cnt)/itv_last_mon_add_cnt ,3)*100 end hb_itv
      from ${gis_user}.DW_GIS_USER_DEV_D t
      where t.flag = 2
      and region_id = '${param.city_id}'
      and acct_day = '${param.date}'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>渠道网点 全省 用在echart全省范围的跳动点</e:description>
  <e:case value="index_get_channel_province">
    <e:q4l var="dataList">
      select a.latn_id, (a.cnt - b.cnt) cnt
      from (select latn_id, sum(cnt) cnt
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where t. up_time = (select max(up_time)
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where up_time <= sysdate)
      group by latn_Id) a,
      (select latn_id, sum(cnt) cnt
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where t. up_time =
      (select max(up_time)
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where up_time < (select max(up_time)
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where up_time <= sysdate))
      group by latn_Id) b
      where a.latn_id = b.latn_id
      and a.cnt <> b.cnt
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>某个渠道网点的重点指标</e:description>
  <e:case value="index_get_by_channel_name">
    <e:q4o var="dataObj">
      select
      channel_name,
      yd_current_mon_dev ,yd_current_day_dev ,
      kd_current_mon_dev ,kd_current_day_dev  ,
      itv_current_mon_dev ,itv_current_day_dev
      from ${gis_user}.DW_GIS_CHANNEL_DEV_D
      where channel_name = '${param.channel_name}'
      and acct_day = '${param.date}'
      and latn_name = '${param.city_name}'
    </e:q4o>
    ${e:java2json(dataObj)}
  </e:case>
  <e:description>某些渠道网点的重点指标</e:description>
  <e:case value="index_get_by_channel_names">
    <e:q4l var="dataList">
      select
      a.channel_name,
      yd_current_mon_dev,
      yd_current_day_dev,
      kd_current_mon_dev,
      kd_current_day_dev,
      itv_current_mon_dev,
      itv_current_day_dev
      from ${gis_user}.DW_GIS_CHANNEL_DEV_D a
      where a.channel_name in (${param.channel_names})
      and a.acct_day = '${param.date}'
      and a.latn_name = '${param.city_name}'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>渠道网点 发展排名</e:description>
  <e:case value="proc_get">
    <c:tablequery>
      SELECT a.latn_name,
      a.channel_name,
      a.yd_current_mon_dev,
      a.kd_current_mon_dev,
      a.itv_current_mon_dev
      FROM ${gis_user}.DW_GIS_CHANNEL_DEV_D a
      where ACCT_DAY = '${param.date}'
      and latn_name = '${param.city_name}'
    </c:tablequery>
  </e:case>

  <e:description>渠道网点 实时发展 分地市查询 根据三个发展数字查询对应的交易</e:description>
  <e:case value="getDevItemInit">
    <e:q4l var="dataList">
      select
      c.*, rownum
      from (
      select a.pro_latn_cnt,
      a.latn_Name,
      a.channel_name1,
      case
      when a.pro_type = 1 then
      '移动'
      when a.pro_type = 2 then
      '宽带'
      when a.pro_type = 3 then
      'ITV'
      end produce,
      substr(acc_nbr, 0, 3) || '***' || substr(acc_nbr, 8, 4) acc_nbr,
      to_char(bb.up_time, 'hh24:mi:ss') up_time
      from T_REL_PRD_PROD_INST_LATN@DW_GSCLAS a,
      (select m.*
      from (select t.*,
      row_number() over(partition by t.latn_id, t.prod_type, t.cnt order by up_time asc) rn
      from T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS t
      where to_char(t.up_time, 'yyyymmdd') = '${param.date}') m
      where m.rn = 1) bb
      where
      a.pro_latn_cnt <= ${param.max_num}
      and a.latn_id = '${param.city_id}'
      and a.pro_cnt = bb.cnt
      and a.pro_type = bb.prod_type
      and a.latn_Id = bb.latn_Id
      order by a.pro_latn_cnt desc) c
      where rownum <= '${param.num}'
      order by pro_latn_cnt asc
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:case value="getDevItemById">
    <e:q4l var="dataList">
      select m.*
      from (
      <e:if condition="${param.id0 ne '0'}">
        select * from (
        select * from (
        select
        a.pro_latn_cnt,
        a.latn_Name,
        a.channel_name1,
        case
        when a.pro_type = 1 then
        '移动'
        when a.pro_type = 2 then
        '宽带'
        when a.pro_type = 3 then
        'ITV'
        end produce,
        substr(acc_nbr,0,3) || '***' || substr(acc_nbr,8,4) acc_nbr,
        to_char(bb.up_time, 'hh24:mi:ss') up_time,
        row_number() over(partition by a.pro_latn_cnt order by up_time asc) rn
        from T_REL_PRD_PROD_INST_LATN@DW_GSCLAS a,
        T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS bb
        where a.pro_cnt = '${param.id0}'
        and a.pro_type = '${param.pro_type0}'
        and a.latn_Id = '${param.city_id}'
        and a.pro_cnt = bb.cnt
        and a.pro_type = bb.prod_type
        and a.latn_Id = bb.latn_Id
        and to_char(bb.up_time,'yyyymmdd') = '${param.date}'
        order by up_time desc
        ) where rn = 1
        ) a
      </e:if>
      <e:if condition="${param.id0 ne '0' && param.id1 ne '0'}">
        union
      </e:if>
      <e:if condition="${param.id1 ne '0'}">
        select * from (
        select * from (
        select a.pro_latn_cnt,a.latn_Name,
        a.channel_name1,
        case
        when a.pro_type = 1 then
        '移动'
        when a.pro_type = 2 then
        '宽带'
        when a.pro_type = 3 then
        'ITV'
        end produce,
        substr(acc_nbr,0,3) || '***' || substr(acc_nbr,8,4) acc_nbr,
        to_char(bb.up_time, 'hh24:mi:ss') up_time,
        row_number() over(partition by a.pro_latn_cnt order by up_time asc) rn
        from T_REL_PRD_PROD_INST_LATN@DW_GSCLAS a,
        T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS bb
        where a.pro_cnt = '${param.id1}'
        and a.pro_type = '${param.pro_type1}'
        and a.latn_Id = '${param.city_id}'
        and a.pro_cnt = bb.cnt
        and a.pro_type = bb.prod_type
        and a.latn_Id = bb.latn_Id
        and to_char(bb.up_time,'yyyymmdd') = '${param.date}'
        order by up_time desc
        ) where rn = 1
        ) b
      </e:if>
      <e:if condition="${param.id1 ne '0' && param.id2 ne '0'}">
        union
      </e:if>
      <e:if condition="${param.id0 ne '0' && param.id1 eq '0' && param.id2 ne '0'}">
        union
      </e:if>
      <e:if condition="${param.id2 ne '0'}">
        select * from (
        select * from (
        select a.pro_latn_cnt,a.latn_Name,
        a.channel_name1,
        case
        when a.pro_type = 1 then
        '移动'
        when a.pro_type = 2 then
        '宽带'
        when a.pro_type = 3 then
        'ITV'
        end produce,
        substr(acc_nbr,0,3) || '***' || substr(acc_nbr,8,4) acc_nbr,
        to_char(bb.up_time, 'hh24:mi:ss') up_time,
        row_number() over(partition by a.pro_latn_cnt order by up_time asc) rn
        from T_REL_PRD_PROD_INST_LATN@DW_GSCLAS a,
        T_FCT_REAL_REPORT_CHANNEL_LATN@DW_GSCLAS bb
        where a.pro_cnt = '${param.id2}'
        and a.pro_type = '${param.pro_type2}'
        and a.latn_Id = '${param.city_id}'
        and a.pro_cnt = bb.cnt
        and a.pro_type = bb.prod_type
        and a.latn_Id = bb.latn_Id
        and to_char(bb.up_time,'yyyymmdd') = '${param.date}'
        order by up_time desc
        ) where rn = 1
        ) c
      </e:if>
      )m
      order by m.pro_latn_cnt asc
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>渠道网点 end</e:description>

  <e:description>基站--begin</e:description>
  <e:description>基站制作厂家</e:description>
  <e:case value="basestation_factory">
    <e:q4l var="indexList">
      SELECT FACTORY,COUNT(1) COUNT FROM BASESTATION
      <e:if condition="${param.city_name ne '甘肃省'}">
        WHERE AREA LIKE '${param.city_name}%'
      </e:if>
      GROUP BY FACTORY
    </e:q4l>
    ${e:java2json(indexList.list)}
  </e:case>
  <e:description>基站覆盖类型</e:description>
  <e:case value="basestation_cover_area">
    <e:q4l var="indexList">
      SELECT COVER_AREA,COUNT(1) COUNT FROM BASESTATION
      <e:if condition="${param.city_name ne '甘肃省'}">
        WHERE AREA LIKE '${param.city_name}%'
      </e:if>
      GROUP BY COVER_AREA
    </e:q4l>
    ${e:java2json(indexList.list)}
  </e:case>
  <e:description>基站--end</e:description>

  <e:description>实时发展---begin</e:description>
  <e:description>省_实施发展量_6个数字</e:description>
  <e:case value="realTimeNum">
    <e:q4l var="realVal">
      SELECT
      1 DATA_FLAG,
      SUM(CASE
      WHEN PROD_TYPE = 1 THEN
      CNT
      ELSE
      0
      END) DEV_MOB,
      SUM(CASE
      WHEN PROD_TYPE = 2 THEN
      CNT
      ELSE
      0
      END) DEV_ADSL ,
      SUM(CASE
      WHEN PROD_TYPE = 3 THEN
      CNT
      ELSE
      0
      END) DEV_ITV,
      TO_CHAR(T.UP_TIME, 'hh24:mi:ss')
      FROM T_FCT_REAL_REPORT_LATN_REAL@DW_GSCLAS T
      LEFT JOIN CMCODE_AREA_GIS T1
      ON T.LATN_ID = T1.AREA_NO
      WHERE T.UP_TIME =
      (SELECT MAX(T.UP_TIME)
      FROM T_FCT_REAL_REPORT_LATN_REAL@DW_GSCLAS T
      WHERE TO_CHAR(UP_TIME, 'yyyymmddhh24miss') <
      TO_CHAR(SYSDATE, 'yyyymmddhh24miss'))
      GROUP BY T.UP_TIME
    </e:q4l>
    ${e:java2json(realVal.list)}
  </e:case>

  <e:description>地市_实施发展量_列表</e:description>
  <e:case value="realTimeSubList">
    <e:q4l var="realVal">
      SELECT
      1 DATA_FLAG,
      TO_CHAR(T.LATN_ID) REGION_ID,
      T1.AREA_DESC REGION_NAME,
      TO_NUMBER(T1.ORD),
      SUM(CASE
      WHEN PROD_TYPE = 1 THEN
      CNT
      ELSE
      0
      END) DEV_MOB,
      SUM(CASE
      WHEN PROD_TYPE = 2 THEN
      CNT
      ELSE
      0
      END) DEV_ADSL ,
      SUM(CASE
      WHEN PROD_TYPE = 3 THEN
      CNT
      ELSE
      0
      END) DEV_ITV,
      TO_CHAR(T.UP_TIME, 'hh24:mi:ss')
      FROM T_FCT_REAL_REPORT_LATN_REAL@DW_GSCLAS T
      LEFT JOIN CMCODE_AREA_GIS T1
      ON T.LATN_ID = T1.AREA_NO
      WHERE T.UP_TIME =
      (SELECT MAX(T.UP_TIME)
      FROM T_FCT_REAL_REPORT_LATN_REAL@DW_GSCLAS T
      WHERE TO_CHAR(UP_TIME, 'yyyymmddhh24miss') <
      TO_CHAR(SYSDATE, 'yyyymmddhh24miss'))
      GROUP BY T.LATN_ID, T1.AREA_DESC, T1.ORD, T.UP_TIME
      ORDER BY t1.ord
    </e:q4l>
    ${e:java2json(realVal.list)}
  </e:case>

  <e:description>时段-电信移动发展量-日发展趋势</e:description>
  <e:description>移动实时发展-月均</e:description>
  <e:case value="realTimeFigureMonthAvg">
    <e:q4l var="dataList">
      SELECT
      DEV_MOB_AVG
      FROM ${gis_user}.TB_DW_GIS_KEY_REAL_AVG_MON
      WHERE REGION_ID = '999'
      ORDER BY ORD_CNT ASC
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:case value="realTimeFigureCurrent">
    <e:q4l var="dataList">
      select a.*,rownum from
      (SELECT
      DEV_MOB_CHA, LOAD_TIME
      FROM ${gis_user}.GIS_KEY_REAL_TIME
      WHERE REGION_ID = '999'
      AND TO_CHAR(LOAD_TIME, 'yyyymmdd') = '${param.date}'
      AND to_char(load_time,'yyyymmddhh24miss') < '${param.now}'
      AND ORD_CNT > 0
      ORDER BY ORD_CNT DESC)a
      <e:if condition="${!empty param.len}">
        where rownum <= ${param.len}
      </e:if>
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:description>实时发展---end</e:description>

  <e:description>市场份额---begin--</e:description>
  <e:description>市场份额(电信的总量)-累计份额-新增份额</e:description>
  <e:case value="market_total">
    <e:q4o var="dataObject">
      select
      day_id,
      region_id,
      region_name,
      to_char(acc_rate_telecom,'999.00') acc_rate_telecom,
      to_char(add_rate_telecom,'999.00') add_rate_telecom
      from ${gis_user}.GIS_KEY_MARKET_D t
      where t.day_id='${param.date}'
      and t.data_flag = 1
      and t.region_id='${param.region_id}'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>市场份额-月增幅变化</e:description>
  <e:case value="month_acc">
    <e:q4l var="dataList">
      select *
      from ${gis_user}.TB_GIS_KEY_MARKET_MON
      where region_id = '${param.region_id}'
      and acct_month between '${param.month_begin}' and '${param.month_end}'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>市场份额-日新增份额</e:description>
  <e:case value="day_add">
    <e:q4l var="dataList">
      select
      SUBSTR(DAY_ID, 7, 8) DAY_ID,
      add_rate_telecom,
      add_rate_moblie,
      add_rate_union,
      add_rate_dx,
      add_rate_yd,
      add_rate_lt
      from ${gis_user}.GIS_KEY_MARKET_D t
      where to_char(t.day_Id) between to_char(to_date('${param.date}','yyyymmdd')-6,'yyyymmdd') and '${param.date}'
      and t.data_flag = 1
      and region_id = '${param.region_id}'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>市场份额-分公司数据</e:description>
  <e:case value="sub_crops">
    <e:q4l var="dataList">
      select day_id,
      region_id,
      region_name,
      pos,
      to_char(acc_rate_telecom,'999.00') acc_rate_telecom,
      to_char(accmon_rate_tel,'0.00') accmon_rate_tel,
      add_cnt_telecom,
      to_char(add_rate_telecom,'999.00') add_rate_telecom
      from ${gis_user}.GIS_KEY_MARKET_D t
      where t.day_id='${param.date}'
      and t.data_flag = 1
      order by pos
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:description>市场份额---end--</e:description>

  <e:description>三大业务---begin--</e:description>
  <e:description>重点业务当日发展量</e:description>
  <e:case value="import_busi_today_dev_num">
    <e:q4o var="dataObject">
      select
      t.day_id,
      dev_num1 dev_mob,
      dev_num2 dev_adsl,
      dev_num3 dev_itv,
      0 dev_redbag
      from ${gis_user}.GIS_KEY_BUSI_D t
      where t.day_id = '${param.date}'
      and t.pos=0
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>地图</e:description>
  <e:case value="import_index_echarts_map">
    <e:q4l var="dataList">
      select
      t.day_id,
      t.region_id,
      t.region_name ORG_NAME,
      <e:if condition="${param.index_type eq 'mob'}">
        dev_num1
      </e:if>
      <e:if condition="${param.index_type eq 'broad'}">
        dev_num2
      </e:if>
      <e:if condition="${param.index_type eq 'itv'}">
        dev_num3
      </e:if>
      <e:if condition="${param.index_type eq 'redbag'}">
        0
      </e:if>
      CURRENT_MON_DEV
      from ${gis_user}.GIS_KEY_BUSI_D t
      where t.pos != 0
      and t.day_id = '${param.date}'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>月发展趋势</e:description>
  <e:case value="dev_figure_month">
    <e:q4o var="dataObject">
      select
      t.month_id,
      TRUNC(curr_mon_bill/10000,1)curr_mon_bill,
      TRUNC(curr_mon_bill1/10000,1)curr_mon_bill1,
      TRUNC(curr_mon_bill2/10000,1)curr_mon_bill2,
      TRUNC(curr_mon_bill3/10000,1)curr_mon_bill3,
      TRUNC(curr_mon_bill4/10000,1)curr_mon_bill4,
      TRUNC(curr_mon_bill5/10000,1)curr_mon_bill5,
      TRUNC(CURR_MON_NEW/10000,1)CURR_MON_NEW,
      TRUNC(CURR_MON_NEW1/10000,1)CURR_MON_NEW1,
      TRUNC(CURR_MON_NEW2/10000,1)CURR_MON_NEW2,
      TRUNC(CURR_MON_NEW3/10000,1)CURR_MON_NEW3,
      TRUNC(CURR_MON_NEW4/10000,1)CURR_MON_NEW4,
      TRUNC(CURR_MON_NEW5/10000,1)CURR_MON_NEW5
      from ${gis_user}.gis_key_busi_m t
      where t.month_id = '${param.date}'
      and t.pos=0
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>日发展趋势</e:description>
  <e:case value="dev_figure_day">
    <e:q4o var="dataObject">
      select
      <e:if condition="${param.index_type eq 'mob'}">
        curr_dev_mob  c_dev,
        curr_dev_mob1 c_dev1,
        curr_dev_mob2 c_dev2,
        curr_dev_mob3 c_dev3,
        curr_dev_mob4 c_dev4,
        curr_dev_mob5 c_dev5,
        curr_dev_mob6 c_dev6  ,
        curr_dev_mob7 c_dev7  ,
        curr_dev_mob8 c_dev8  ,
        curr_dev_mob9 c_dev9  ,
        curr_dev_mob10 c_dev10  ,
        curr_dev_mob11 c_dev11  ,
        curr_dev_mob12 c_dev12  ,
        curr_dev_mob13 c_dev13  ,
        curr_dev_mob14 c_dev14  ,
        curr_dev_mob15 c_dev15  ,
        curr_dev_mob16 c_dev16  ,
        curr_dev_mob17 c_dev17  ,
        curr_dev_mob18 c_dev18  ,
        curr_dev_mob19 c_dev19  ,
        curr_dev_mob20 c_dev20  ,
        curr_dev_mob21 c_dev21  ,
        curr_dev_mob22 c_dev22  ,
        curr_dev_mob23 c_dev23  ,
        curr_dev_mob24 c_dev24  ,
        curr_dev_mob25 c_dev25  ,
        curr_dev_mob26 c_dev26  ,
        curr_dev_mob27 c_dev27  ,
        curr_dev_mob28 c_dev28  ,
        curr_dev_mob29 c_dev29  ,
        curr_dev_mob30 c_dev30  ,
        last_dev_mob  l_dev  ,
        last_dev_mob1 l_dev1  ,
        last_dev_mob2 l_dev2  ,
        last_dev_mob3 l_dev3  ,
        last_dev_mob4 l_dev4  ,
        last_dev_mob5 l_dev5  ,
        last_dev_mob6 l_dev6  ,
        last_dev_mob7 l_dev7  ,
        last_dev_mob8 l_dev8  ,
        last_dev_mob9 l_dev9  ,
        last_dev_mob10 l_dev10  ,
        last_dev_mob11 l_dev11  ,
        last_dev_mob12 l_dev12  ,
        last_dev_mob13 l_dev13  ,
        last_dev_mob14 l_dev14  ,
        last_dev_mob15 l_dev15  ,
        last_dev_mob16 l_dev16  ,
        last_dev_mob17 l_dev17  ,
        last_dev_mob18 l_dev18  ,
        last_dev_mob19 l_dev19  ,
        last_dev_mob20 l_dev20  ,
        last_dev_mob21 l_dev21  ,
        last_dev_mob22 l_dev22  ,
        last_dev_mob23 l_dev23  ,
        last_dev_mob24 l_dev24  ,
        last_dev_mob25 l_dev25  ,
        last_dev_mob26 l_dev26  ,
        last_dev_mob27 l_dev27  ,
        last_dev_mob28 l_dev28  ,
        last_dev_mob29 l_dev29  ,
        last_dev_mob30 l_dev30
      </e:if>
      <e:if condition="${param.index_type eq 'broad'}">
        curr_  c_dev  ,
        curr_1 c_dev1,
        curr_2 c_dev2,
        curr_3 c_dev3,
        curr_4 c_dev4,
        curr_5 c_dev5,
        curr_6 c_dev6  ,
        curr_7 c_dev7  ,
        curr_8 c_dev8  ,
        curr_9 c_dev9  ,
        curr_10 c_dev10  ,
        curr_11 c_dev11  ,
        curr_12 c_dev12  ,
        curr_13 c_dev13  ,
        curr_14 c_dev14  ,
        curr_15 c_dev15  ,
        curr_16 c_dev16  ,
        curr_17 c_dev17  ,
        curr_18 c_dev18  ,
        curr_19 c_dev19  ,
        curr_20 c_dev20  ,
        curr_21 c_dev21  ,
        curr_22 c_dev22  ,
        curr_23 c_dev23  ,
        curr_24 c_dev24  ,
        curr_25 c_dev25  ,
        curr_26 c_dev26  ,
        curr_27 c_dev27  ,
        curr_28 c_dev28  ,
        curr_29 c_dev29  ,
        curr_30 c_dev30  ,
        last_  l_dev  ,
        last_1 l_dev1  ,
        last_2 l_dev2  ,
        last_3 l_dev3  ,
        last_4 l_dev4  ,
        last_5 l_dev5  ,
        last_6 l_dev6  ,
        last_7 l_dev7  ,
        last_8 l_dev8  ,
        last_9 l_dev9  ,
        last_10 l_dev10  ,
        last_11 l_dev11  ,
        last_12 l_dev12  ,
        last_13 l_dev13  ,
        last_14 l_dev14  ,
        last_15 l_dev15  ,
        last_16 l_dev16  ,
        last_17 l_dev17  ,
        last_18 l_dev18  ,
        last_19 l_dev19  ,
        last_20 l_dev20  ,
        last_21 l_dev21  ,
        last_22 l_dev22  ,
        last_23 l_dev23  ,
        last_24 l_dev24  ,
        last_25 l_dev25  ,
        last_26 l_dev26  ,
        last_27 l_dev27  ,
        last_28 l_dev28  ,
        last_29 l_dev29  ,
        last_30 l_dev30
      </e:if>
      <e:if condition="${param.index_type eq 'itv'}">
        curr_dev_itv  c_dev  ,
        curr_dev_itv1 c_dev1,
        curr_dev_itv2 c_dev2,
        curr_dev_itv3 c_dev3,
        curr_dev_itv4 c_dev4,
        curr_dev_itv5 c_dev5,
        curr_dev_itv6 c_dev6  ,
        curr_dev_itv7 c_dev7  ,
        curr_dev_itv8 c_dev8  ,
        curr_dev_itv9 c_dev9  ,
        curr_dev_itv10 c_dev10  ,
        curr_dev_itv11 c_dev11  ,
        curr_dev_itv12 c_dev12  ,
        curr_dev_itv13 c_dev13  ,
        curr_dev_itv14 c_dev14  ,
        curr_dev_itv15 c_dev15  ,
        curr_dev_itv16 c_dev16  ,
        curr_dev_itv17 c_dev17  ,
        curr_dev_itv18 c_dev18  ,
        curr_dev_itv19 c_dev19  ,
        curr_dev_itv20 c_dev20  ,
        curr_dev_itv21 c_dev21  ,
        curr_dev_itv22 c_dev22  ,
        curr_dev_itv23 c_dev23  ,
        curr_dev_itv24 c_dev24  ,
        curr_dev_itv25 c_dev25  ,
        curr_dev_itv26 c_dev26  ,
        curr_dev_itv27 c_dev27  ,
        curr_dev_itv28 c_dev28  ,
        curr_dev_itv29 c_dev29  ,
        curr_dev_itv30 c_dev30  ,
        last_dev_itv  l_dev  ,
        last_dev_itv1 l_dev1  ,
        last_dev_itv2 l_dev2  ,
        last_dev_itv3 l_dev3  ,
        last_dev_itv4 l_dev4  ,
        last_dev_itv5 l_dev5  ,
        last_dev_itv6 l_dev6  ,
        last_dev_itv7 l_dev7  ,
        last_dev_itv8 l_dev8  ,
        last_dev_itv9 l_dev9  ,
        last_dev_itv10 l_dev10  ,
        last_dev_itv11 l_dev11  ,
        last_dev_itv12 l_dev12  ,
        last_dev_itv13 l_dev13  ,
        last_dev_itv14 l_dev14  ,
        last_dev_itv15 l_dev15  ,
        last_dev_itv16 l_dev16  ,
        last_dev_itv17 l_dev17  ,
        last_dev_itv18 l_dev18  ,
        last_dev_itv19 l_dev19  ,
        last_dev_itv20 l_dev20  ,
        last_dev_itv21 l_dev21  ,
        last_dev_itv22 l_dev22  ,
        last_dev_itv23 l_dev23  ,
        last_dev_itv24 l_dev24  ,
        last_dev_itv25 l_dev25  ,
        last_dev_itv26 l_dev26  ,
        last_dev_itv27 l_dev27  ,
        last_dev_itv28 l_dev28  ,
        last_dev_itv29 l_dev29  ,
        last_dev_itv30 l_dev30
      </e:if>
      from ${gis_user}.GIS_KEY_BUSI_D t
      where t.pos = 0
      and t.day_id = '${param.date}'
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>出账构成</e:description>
  <e:case value="czgc">
    <e:q4o var="dataObject">
      select
      t.month_id,
      TRUNC(curr_mon_bill1/10000,1) CURR_MON_BILL,
      TRUNC(CURR_MON_NEW_BILL/10000,1) CURR_MON_NEW,
      TRUNC(curr_mon_live/10000,1) CURR_MON_LIVE,
      TRUNC(curr_mon_lost/10000,1) CURR_MON_LOST
      from ${gis_user}.gis_key_busi_m t
      where t.month_id = '${param.date}'
      and t.pos=0
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>新增用户活跃率</e:description>
  <e:case value="activeRate">
    <e:q4l var="dataList">
      SELECT
      T.REGION_ID,
      T.REGION_NAME,
      TRUNC(t.curr_mon_new/10000,1) curr_mon_new,
      T.CURR_NEW_ACT_RATE NEW_ACT_RATE
      FROM ${gis_user}.GIS_KEY_BUSI_M T
      WHERE T.MONTH_ID = '${param.date}'
      and t.pos != 0
      ORDER BY T.POS
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>三大业务---end--</e:description>

  <e:description>支局信息</e:description>
  <e:case value="ZJ_data">
    <e:q4o var="dataObject">
      SELECT
      d.FIN_INCOME,
      d.MOBILE_SERV_CUR_MON_CUM_NEW AS MOBILE_MON_NEW,
      d.BRD_SERV_CUR_MON_CUM_NEW AS BRD_MON_NEW,
      d.ITV_SERV_CUR_MON_NEW AS ITV_MON_NEW,
      d.TERMINAL_TOTAL_MON,
      d.BN_EXP_CNT,
      d.BN_EXP_ZX_CNT,
      d.TC_EXP_CNT,
      d.TC_EXP_ZX_CNT,
      d.OWE_CNT,
      d.OWE_ZX_CNT,
      d.BLANCE_CNT,
      d.BLANCE_ZX_CNT,
      d.ZD_CNT,
      d.ZD_ZX_CNT,
      d.JZ_CNT,
      d.JZ_ZX_CNT,
      d.ADDR_NUM,
      d.KD_NUM,
      d.USE_RATE,
      d.FTTH_PORT_NUM,
      d.FTTH_PORT_ZY_NUM,
      d.PORT_RATE,
      g.BRANCH_NAME
      from ${gis_user}.DW_BRANCH_DEV_D d,${gis_user}.DB_CDE_GRID g
      WHERE d.branch_id in (select branch_no branch_id from ${gis_user}.DB_CDE_GRID where union_org_code=${param.union_org_code})
      AND d.ACCT_DAY=${param.yesterday}
      AND g.BRANCH_NO=d.branch_id
      AND g.grid_status=1
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>
  <e:case value="ZJ_data_h">
    <e:q4o var="obj">
      SELECT CUR_MON_BRD_SERV BRD_MON,CUR_MON_FIX_FEE_SERV FEE_MON,CUR_MON_ITV_SERV I FROM ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON WHERE latn_id IN (
      SELECT  branch_no LATN_ID FROM ${gis_user}.DB_CDE_GRID WHERE UNION_ORG_CODE=${param.union_org_code}
      ) and flag='4'
    </e:q4o>
    ${e:java2json(obj)}
  </e:case>

  <e:description>当月三大业务 日新增数据</e:description>
  <e:case value="day_new">
    <e:q4l var="dataList">
      select
      ACCT_DAY
      <e:switch value="${param.dataKind}">
        <e:case value="mobile">
          ,MOBILE_SERV_DAY_NEW as NEW_DATA
        </e:case>
        <e:case value="brd">
          ,BRD_SERV_DAY_NEW as NEW_DATA
        </e:case>
        <e:case value="itv">
          ,ITV_SERV_DAY_NEW as NEW_DATA
        </e:case>
      </e:switch>
      FROM(SELECT ACCT_DAY,
      MOBILE_SERV_DAY_NEW,
      BRD_SERV_DAY_NEW,
      ITV_SERV_DAY_NEW
      FROM
      ${gis_user}.DW_BRANCH_DEV_D d
      WHERE
      BRANCH_ID in (select branch_no BRANCH_ID from ${gis_user}.DB_CDE_GRID where union_org_code=${param.union_org_code} AND grid_status=1)
      ORDER BY d.ACCT_DAY DESC)
      WHERE ROWNUM<=30
      ORDER BY ACCT_DAY
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>支局视图热力图数据</e:description>
  <e:case value="heatData">
    <e:q4l var="heatDataList">
      SELECT u.* from(
      SELECT d.LONGITUDE1 ,
      d.LATITUDE1 ,
      g.LATN_NAME,
      SUM(d.CNT) numval
      FROM ${gis_user}.TB_DW_GIS_BIGDATA_ANA_H_D d,${gis_user}.DB_CDE_GRID g
      WHERE
      d.UNION_ORG_CODE=g.UNION_ORG_CODE AND
      <e:if condition="${param.union_code != null && param.union_code ne ''}">
        d.UNION_ORG_CODE=${param.union_code} AND
      </e:if>
      <e:if condition="${param.ow != null && param.ow ne ''}">
        d.TYPE_FLG = ${param.ow} AND
      </e:if>
      <e:if condition="${param.time != null && param.time ne ''}">
        d.ACCT_DAY = ${param.time} AND
      </e:if>
      g.grid_status=1
      GROUP BY d.LONGITUDE1,d.LATITUDE1,g.LATN_NAME
      ) u
    </e:q4l>
    ${e:java2json(heatDataList.list)}
  </e:case>

  <e:description>根据支局ID 获取下面网格的所有信息</e:description>
  <e:case value="grids">
    <e:q4l var="list">
      SELECT
      g.grid_name GRID_NAME,MOBILE_FIN_INCOME MOB_I,PSTN_FIN_INCOME PSTN_I,CUR_MON_FIX_FEE_serv FEE_C_S,CUR_MON_BRD_SERV BRD_C_S,LAST_MON_FIX_FEE_SERV FEE_L_S,LAST_MON_BRD_SERV BRD_L_S
      FROM ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m,${gis_user}.DB_cDE_GRID g
      where m.latn_id =g.grid_id
      and union_org_code=${param.union_org_code}
      and g.grid_status=1
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description> 获取支局发展三项指标 移动宽带电视</e:description>
  <e:case value="getDayNew">
    <e:q4o var="obj">
      select MOBILE_SERV_DAY_NEW M_N,BRD_SERV_DAY_NEW B_N,ITV_SERV_DAY_NEW I_N,MOBILE_SERV_CUR_MON_CUM_NEW m_MN,BRD_SERV_CUR_MON_CUM_NEW B_MN,ITV_SERV_CUR_MON_NEW I_MN from
      ${gis_user}.DW_BRANCH_DEV_D where branch_id in (select branch_no branch_id from ${gis_user}.DB_CDE_GRID where union_org_code=${param.substation})
      and ACCT_DAY='${param.date}'
    </e:q4o>
    ${e:java2json(obj)}
  </e:case>
  <e:description> 获取支局/网格 发展 的各项指标信息</e:description>
  <e:case value="deve">
    <e:q4o var="obj">
		    SELECT
		      '右侧支局、网格发展指标' a,
		    	 M.Y_CUM_INCOME,
		       M.INCOME_BUDGET_FINISH_RATE,
		       M.FIN_INCOME,
		       M.INCOME_RATIO,
		       <e:description>净增</e:description>
		       M.CUR_MON_BIL_SERV m_CZ,
		       M.LAST_MON_BIL_SERV m_CZJZ,

		       M.CUR_MON_BRD_SERV b_CZ,
		       M.LAST_MON_BRD_SERV b_CZJZ,

		       M.CUR_MON_ACTION I_CZ,
		       M.CUR_MON_ACTION_LAST I_CZJZ,

		       <e:description>月新增</e:description>
		       D.MOBILE_MON_CUM_NEW m_MN,
		       D.MOBILE_MON_CUM_NEW_LAST m_MNL,
		       to_char(decode(nvl(D.MOBILE_MON_CUM_NEW_LAST,0),0,0,trunc(nvl(D.MOBILE_MON_CUM_NEW,0)/D.MOBILE_MON_CUM_NEW_LAST-1,4)*100),'FM9999999990.00')||'%' m_add_lv,

		       D.BRD_MON_CUM_NEW b_MN,
		       D.BRD_MON_CUM_NEW_LAST b_MNL,
		       to_char(decode(nvl(D.BRD_MON_CUM_NEW_LAST,0),0,0,trunc(nvl(D.BRD_MON_CUM_NEW,0)/D.BRD_MON_CUM_NEW_LAST-1,4)*100),'FM9999999990.00')||'%' b_add_lv,

		       D.ITV_SERV_CUR_MON_NEW I_MN,
		       D.ITV_SERV_CUR_MON_NEW_LAST I_MNL,
		       to_char(decode(nvl(D.ITV_SERV_CUR_MON_NEW_LAST,0),0,0,trunc(nvl(D.ITV_SERV_CUR_MON_NEW,0)/D.ITV_SERV_CUR_MON_NEW_LAST-1,4)*100),'FM9999999990.00')||'%' i_add_lv,

		       to_char(decode(nvl(D.BRD_MON_CUM_NEW_LAST,0)+nvl(D.MOBILE_MON_CUM_NEW_LAST,0)+nvl(D.ITV_SERV_CUR_MON_NEW_LAST,0),0,0,trunc((nvl(D.BRD_MON_CUM_NEW,0)+nvl(D.MOBILE_MON_CUM_NEW,0)+nvl(D.ITV_SERV_CUR_MON_NEW,0))/(nvl(D.BRD_MON_CUM_NEW_LAST,0)+nvl(D.MOBILE_MON_CUM_NEW_LAST,0)+nvl(D.ITV_SERV_CUR_MON_NEW_LAST,0))-1,4)*100),'FM9999999990.00')||'%' all_add_lv,
		       
		       <e:description>当日发展</e:description>
		       D.MOBILE_SERV_DAY_NEW M_DN,
		       D.BRD_SERV_DAY_NEW B_DN,
		       D.ITV_SERV_DAY_NEW I_DN

		  	FROM ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON M,
		       ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_D   D
		 	WHERE M.FLAG = D.FLAG
			   AND M.LATN_ID = D.LATN_ID
			   AND M.STATIS_MON = ${param.month}
			   AND D.STAT_DATE = ${param.day}
			  <e:if condition="${param.type=='grid'}" >
			    and m.latn_id in (select grid_id latn_id from ${gis_user}.DB_CDE_GRID where grid_union_org_code=(
			    select station_no from ${gis_user}.SPC_BRANCH_STATION where station_id=${param.r_id}))
			    and d.STAT_DATE=${param.day} and d.flag='5' and m.flag='5'
			  </e:if>
			  <e:if condition="${param.type=='branch'}">
			    and m.latn_id in (select branch_no latn_id from ${gis_user}.DB_CDE_GRID where union_org_code=${param.substation})
			    and d.STAT_DATE=${param.day} and d.flag='4' and m.flag='4'
			  </e:if>
    </e:q4o>
    ${e:java2json(obj)}
  </e:case>
  <e:case value="getGridMsgBySubstation">
    <c:tablequery>
      select rownum,a.* from (
      select
      g.UNION_ORG_CODE,
      g.BRANCH_NAME,
      g.ZOOM,
      n.station_id,
      g.grid_id,
      g.grid_union_org_code,
      g.grid_name,
      round(m.fin_income/10000,2)fin_income,
      d.mobile_mon_cum_new,
      d.brd_mon_cum_new,
      d.itv_mon_new_install_serv,
      d.ITV_SERV_CUR_MON_NEW
      from ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON m,
      ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_d   d,
      ${gis_user}.db_cde_grid                 g,
      ${gis_user}.SPC_BRANCH_STATION 					n
      where
      g.grid_id = m.latn_id
      and m.latn_id = d.latn_id
      and n.station_no = g.grid_union_org_code
      and m.flag = '5'
      and d.flag = '5'
      and m.statis_mon = '${param.last_month}'
      and d.stat_date = '${param.yesterday}'
      and g.grid_status = 1
      and g.grid_union_org_code is not null
      and g.union_org_code = '${param.substation}'
      )a
      union

      SELECT
      				0,
      				'0' UNION_ORG_CODE,
				      '0' BRANCH_NAME,
				      0 ZOOM,
				      '0' station_id,
      				'0' GRID_ID,
              '' GRID_UNION_ORG_CODE,
							'合计'  GRID_NAME,
               ROUND(sum(M.FIN_INCOME) / 10000, 2) FIN_INCOME,
               sum(D.MOBILE_MON_CUM_NEW) MOBILE_MON_CUM_NEW,
               sum(D.BRD_MON_CUM_NEW) BRD_MON_CUM_NEW,
               sum(D.ITV_MON_NEW_INSTALL_SERV) ITV_MON_NEW_INSTALL_SERV,
               sum(D.ITV_SERV_CUR_MON_NEW) ITV_SERV_CUR_MON_NEW
          FROM ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_MON M,
               ${gis_user}.TB_DW_GIS_ZHI_JU_INCOME_D   D,
               ${gis_user}.DB_CDE_GRID                 G,
      				 ${gis_user}.SPC_BRANCH_STATION 					n
         WHERE G.GRID_ID = M.LATN_ID
           AND M.LATN_ID = D.LATN_ID
           and n.station_no = g.grid_union_org_code
           AND M.FLAG = '5'
           AND D.FLAG = '5'
           and m.statis_mon = '${param.last_month}'
			      and d.stat_date = '${param.yesterday}'
			      and g.grid_status = 1
			      and g.grid_union_org_code is not null
			      and g.union_org_code = '${param.substation}'
    </c:tablequery>
  </e:case>
  <e:description> 网格 两个月对比</e:description>
  <e:case value="compare_month">
    <e:q4l var="list">
      select
      stat_date,
      mobile_serv_day_new,
      mobile_serv_day_new_last,
      brd_serv_day_new,
      brd_serv_day_new_last,
      itv_serv_day_new,
      itv_serv_day_new_last
      from ${gis_user}.tb_dw_gis_zhi_ju_income_d
      where
      latn_id = (select grid_id from ${gis_user}.DB_CDE_GRID
      where grid_union_org_code=(
      select station_no from ${gis_user}.SPC_BRANCH_STATION where station_id='${param.r_id}'))
      and flag='5'
      and stat_date BETWEEN '${param.date_start}' AND '${param.date_end}'
      order by stat_date asc
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>网格小区数据 已废弃</e:description>
  <e:case value="village_old">
    <c:tablequery>
      select rownum,a.* from(
      select VILLAGE_NAME,MOBILE_NUM,WIDEBAND_NUM,IPTV_NUM,GRID_ID,VILLAGE_ID
      FROM ${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY
      where
      VILLAGE_NAME is not null and
      grid_id = (select grid_id from ${gis_user}.DB_CDE_GRID where
      grid_union_org_code = (
      select station_no from ${gis_user}.SPC_BRANCH_STATION where station_id=${param.r_id}))
      ) a
    </c:tablequery>
  </e:case>
  <e:description>发展标签 获取网格下的小区信息</e:description>
  <e:case value="getVillageDeveByGridId">
    <c:tablequery>
      select rownum,a.* from(
	      select village_id,
	       village_name,
	       nvl(ctcc_mobile_user_num,-1) MOBILE_NUM,
	       nvl(wideband_num,-1) WIDEBAND_NUM,
	       nvl(tv_user_num,-1) IPTV_NUM
			  from ${gis_user}.tb_gis_village_edit_info
			 where grid_id = '${param.r_id}'
			 and vali_flag = 1
      ) a

      UNION
			SELECT ROWNUM, B.*
  			FROM (SELECT '0' VILLAGE_ID,
               '合计' VILLAGE_NAME,
               NVL(sum(CTCC_MOBILE_USER_NUM), -1) MOBILE_NUM,
               NVL(sum(WIDEBAND_NUM), -1) WIDEBAND_NUM,
               NVL(sum(TV_USER_NUM), -1) IPTV_NUM
          FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
         WHERE GRID_ID = '${param.r_id}'
           AND VALI_FLAG = 1) B
    </c:tablequery>
  </e:case>
  <e:description>使用化小的小区数据，已废弃</e:description>
  <e:case value="village_list_old">
    <e:q4l var="list">
      select rownum,a.* from (
      select
      d.grid_id,
      d.village_id,
      d.village_name,
      g.branch_name,
      g.latn_name,
      g.union_org_code,
      d.ben_gis_upload,
      g.grid_name,
      s.station_id,
      g.zoom,
      g.grid_zoom
      from
      ${gis_user}.DB_CDE_GRID g,${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY d,${gis_user}.SPC_BRANCH_STATION s
      where g.grid_id=d.grid_id
      and g.grid_union_org_code=s.station_no
      <e:if condition="${param.latn_id != ''}">
        and g.latn_id =${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no != ''}">
        and g.bureau_no =${param.bureau_no}
      </e:if>
      <e:if condition="${param.union_org_code != ''}">
        and g.union_org_code =${param.union_org_code}
      </e:if>
      <e:if condition="${param.grid_id != ''}">
        and d.grid_id =${param.grid_id}
      </e:if>
      <e:if condition="${param.village_name != ''}">
        and d.village_name like '%${param.village_name}%'
      </e:if>
      and d.village_name is not null
      and g.branch_type in ('a1', 'b1')
      order by d.ben_gis_upload desc,UNION_ORG_CODE,STATION_ID
      ) a
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>使用国信gis系统左侧小区数据</e:description>
  <e:case value="village_list">
    <e:q4l var="list">
    select c.village_id,
       c.village_name,
       c.grid_id,
       c.branch_no UNION_ORG_CODE,
       d.branch_name,
       d.grid_name,
       e.station_id,
       d.zoom,
       d.grid_zoom
		  from ${gis_user}.tb_gis_village_edit_info c,
		       ${gis_user}.db_cde_grid              d,
		       ${gis_user}.spc_branch_station       e
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   order by d.grid_id
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>排除了支局下没有网格的列表</e:description>
  <e:case value="village_list_nouse_bak1">
    <e:q4l var="list">
    select c.village_id,
       c.village_name,
       c.grid_id,
       c.branch_no UNION_ORG_CODE,
       d.branch_name,
       d.grid_name,
       e.station_id,
       d.zoom,
       d.grid_zoom
		  from ${gis_user}.tb_gis_village_edit_info c,
		       ${gis_user}.db_cde_grid              d,
		       ${gis_user}.spc_branch_station       e
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   order by d.grid_id
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>去掉营销列表关联</e:description>
  <e:case value="village_list_nouse_bak">
    <e:q4l var="list">
    select c.village_id,
       c.village_name,
       c.grid_id,
       c.branch_no UNION_ORG_CODE,
       d.branch_name,
       d.grid_name,
       e.station_id,
       d.zoom,
       d.grid_zoom,
       case when c.zhu_hu_sum =0 then 0 else round((c.wideband_num/c.zhu_hu_sum),2) end market_lv,
       c.zhu_hu_sum ,
       c.wideband_num,
       c.tv_user_num ,
       c.ctcc_mobile_user_num ,
       c.port_sum ,
       c.port_free_sum ,
       case when c.port_sum=0 then 0 else round((c.port_used_sum/c.port_sum ),2) end port_lv,
       g.yx_all
		  from ${gis_user}.tb_gis_village_edit_info c,
		       ${gis_user}.db_cde_grid              d,
		       ${gis_user}.spc_branch_station       e,
		       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE g
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   and g.village_id = c.village_id
		   order by d.grid_id
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>获取小区列表，支局下有无网格通用</e:description>
  <e:case value="village_list_page">
    <e:q4l var="list">
    SELECT *
  		FROM (SELECT M.*, ROWNUM RN
          FROM (SELECT T.*
		    		FROM (SELECT VILLAGE_ID,
						       VILLAGE_NAME,
						       STATION_ID,
						       UNION_ORG_CODE,
						       BRANCH_NAME,
						       DECODE(GRID_NAME, NULL, BRANCH_NAME, GRID_NAME) GRID_NAME,
						       ZOOM,
						       GRID_ZOOM
						  FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY
						 WHERE BRANCH_TYPE IN ('a1', 'b1')
						       <e:if condition="${param.latn_id != ''}">
						        and latn_id = '${param.latn_id}'
						       </e:if>
						       <e:if condition="${param.bureau_no != ''}">
						        and bureau_no = '${param.bureau_no}'
						       </e:if>
						       <e:if condition="${param.union_org_code != ''}">
						        and union_org_code = '${param.union_org_code}'
						       </e:if>
						       <e:if condition="${param.grid_id != ''}">
						        and grid_id = '${param.grid_id}'
						       </e:if>
						       <e:if condition="${!empty param.village_name}">
						        and village_name like '%${param.village_name}%'
						       </e:if>
						       <e:if condition="${!empty param.branch_type}">
						        and branch_type ='${param.branch_type}'
						       </e:if>
						 ORDER BY CITY_ORDER_NUM,
	                    REGION_ORDER_NUM,
	                    BRANCH_TYPE,
	                    GRID_ID,
	                    VILLAGE_NAME
	    		)t
	    		where rownum <= ${param.page+1} * 100)m)n
	    where n.rn > ${param.page} * 100
    	</e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>
  	2017-12-06废弃 小区列表
  	SELECT B.*
			  FROM (SELECT C.VILLAGE_ID,
			               C.GRID_ID STATION_ID,
			               C.BRANCH_NO UNION_ORG_CODE,
			               D.BRANCH_NAME,
			               DECODE(C.GRID_ID, NULL, ' ', C.GRID_NAME) GRID_NAME,
			               D.ZOOM,
			               D.GRID_ZOOM,
			               C.VILLAGE_NAME,
			               ROW_NUMBER() OVER(ORDER BY D.GRID_ID) RN
			          FROM (SELECT C.*,
			                       DECODE(C.GRID_ID, NULL, C.BRANCH_NO, C.GRID_ID) ORG_CODE
			                  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C) C,
			               ${gis_user}.VIEW_GIS_ORG_CODE D
			         WHERE C.ORG_CODE =
			               DECODE(C.GRID_ID, NULL, D.UNION_ORG_CODE, D.SPC_STATIONID)
			           AND C.VALI_FLAG = 1
			           <e:if condition="${param.latn_id != ''}">
			            and d.latn_id = '${param.latn_id}'
							   </e:if>
							   <e:if condition="${param.bureau_no != ''}">
							    and d.bureau_no = '${param.bureau_no}'
							   </e:if>
							   <e:if condition="${param.union_org_code != ''}">
							    and d.union_org_code = '${param.union_org_code}'
							   </e:if>
							   AND D.BRANCH_TYPE IN ('a1', 'b1')
							   <e:if condition="${param.grid_id != ''}">
							    and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
							   </e:if>
							   <e:if condition="${!empty param.village_name}">
							    and c.village_name like '%${param.village_name}%'
							   </e:if>
							   <e:if condition="${!empty param.branch_type}">
							    and d.branch_type ='${param.branch_type}'
							   </e:if>
			         ORDER BY D.GRID_SHOW DESC, D.GRID_UNION_ORG_CODE, VILLAGE_NAME) B
			 WHERE RN > ${param.page} * 100
			   AND RN <= ${param.page+1} * 100
  </e:description>
  <e:description>
  	获取小区列表，支持支局有网格，没网格两种情况
  	select b.* from(
     select c.village_id,
       c.village_name,
       c.grid_id ,
       c.branch_no UNION_ORG_CODE,
       d.branch_name,
       d.grid_name,
       e.station_id,
       d.zoom,
       d.grid_zoom,
      ROW_NUMBER() OVER(order by d.grid_id) rn
		  from ${gis_user}.tb_gis_village_edit_info c,
		       ${gis_user}.db_cde_grid              d,
		       ${gis_user}.spc_branch_station       e
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		 	 <e:if condition="${!empty param.branch_type}">
		 	 	and d.branch_type ='${param.branch_type}'
		 	 </e:if>
		 	 	ORDER BY d.grid_show DESC,d.grid_union_org_code,village_name
		    )b
		     where rn> ${param.page}*100 and rn <= ${param.page+1}*100
  </e:description>

  <e:description>获取小区列表，支局下没有网格，已废弃</e:description>
  <e:case value="village_list_page_none_grid">
    <e:q4l var="list">
    	select b.* from(
  		SELECT C.VILLAGE_ID,
               C.VILLAGE_NAME,
               C.GRID_ID,
               C.BRANCH_NO UNION_ORG_CODE,
               D.BRANCH_NAME,
               nvl(D.GRID_NAME,' ') GRID_NAME,
               d.STATION_ID,
               D.ZOOM,
               D.GRID_ZOOM,
               ROW_NUMBER() OVER(ORDER BY c.GRID_ID) RN
          FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C
               LEFT JOIN (SELECT DISTINCT STATION_ID,
		                             T.LATN_ID,
		                             T.BUREAU_NO,
                                 T.UNION_ORG_CODE,
                                 T.BRANCH_TYPE,
		                             T.BRANCH_NAME,
		                             '' GRID_NAME,
		                             T.ZOOM,
		                             '' GRID_ZOOM
		               FROM ${gis_user}.DB_CDE_GRID T
		               LEFT JOIN ${gis_user}.SPC_BRANCH_STATION T1
		                 ON T.GRID_UNION_ORG_CODE = T1.STATION_NO) D
		    ON C.BRANCH_NO = D.UNION_ORG_CODE
         WHERE
            C.VALI_FLAG = 1
           <e:if condition="${param.latn_id != ''}">
				   	and d.latn_id = '${param.latn_id}'
				   </e:if>
           <e:if condition="${param.bureau_no != ''}">
				   	and d.bureau_no = '${param.bureau_no}'
				   </e:if>
           <e:if condition="${param.union_org_code != ''}">
				   	and d.union_org_code = '${param.union_org_code}'
				   </e:if>
           <e:if condition="${!empty param.branch_type}">
		 	 	and d.branch_type ='${param.branch_type}'
		 	 </e:if>
		    )b
		     where rn> ${param.page}*100 and rn <= ${param.page+1}*100
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>小区数量</e:description>
  <e:case value="village_list_count">
    <e:q4o var="villagecount">
			SELECT COUNT(1) VILLAGECOUNT
  			FROM (SELECT VILLAGE_ID,
               VILLAGE_NAME,
               STATION_ID,
               UNION_ORG_CODE,
               BRANCH_NAME,
               DECODE(GRID_NAME, NULL, BRANCH_NAME, GRID_NAME) GRID_NAME,
               ZOOM,
               GRID_ZOOM
          FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY
         WHERE BRANCH_TYPE IN ('a1', 'b1')
         <e:if condition="${param.latn_id != ''}">
            and latn_id = '${param.latn_id}'
           </e:if>
           <e:if condition="${param.bureau_no != ''}">
            and bureau_no = '${param.bureau_no}'
           </e:if>
           <e:if condition="${param.union_org_code != ''}">
            and union_org_code = '${param.union_org_code}'
           </e:if>
           <e:if condition="${!empty param.village_name}">
            AND village_name like '%${param.village_name}%'
           </e:if>
           <e:if condition="${!empty param.branch_type}">
            AND branch_type ='${param.branch_type}'
           </e:if>
           <e:if condition="${param.grid_id != ''}">
            AND grid_id = '${param.grid_id}'
           </e:if>
         )
		</e:q4o>
    ${e:java2json(villagecount)}
  </e:case>
  <e:description>
  	2017-12-06小区数量，已废弃
  	SELECT C1 + C2 VILLAGECOUNT
  		FROM (SELECT COUNT(DISTINCT T.VILLAGE_ID) C1
          FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO T,
               ${gis_user}.VIEW_GIS_ORG_CODE        T1
         WHERE T.GRID_ID = T1.SPC_STATIONID
           AND T.VALI_FLAG = 1
           AND t1.BRANCH_TYPE IN ('a1', 'b1')
           <e:if condition="${param.latn_id != ''}">
            and t1.latn_id = '${param.latn_id}'
           </e:if>
           <e:if condition="${param.bureau_no != ''}">
            and t1.bureau_no = '${param.bureau_no}'
           </e:if>
           <e:if condition="${param.union_org_code != ''}">
            and t1.union_org_code = '${param.union_org_code}'
           </e:if>
           <e:if condition="${!empty param.village_name}">
            AND t.village_name like '%${param.village_name}%'
           </e:if>
           <e:if condition="${!empty param.branch_type}">
            AND t1.branch_type ='${param.branch_type}'
           </e:if>
           <e:if condition="${param.grid_id != ''}">
            and (t1.grid_id = '${param.grid_id}' or t1.grid_union_org_code = '${param.grid_id}')
           </e:if>
           AND T.GRID_ID IS NOT NULL) M1,
       (SELECT COUNT(DISTINCT T.VILLAGE_ID) C2
          FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO T,
               ${gis_user}.VIEW_GIS_ORG_CODE        T1
         WHERE T.BRANCH_NO = T1.UNION_ORG_CODE
           AND T.VALI_FLAG = 1
           AND t1.BRANCH_TYPE IN ('a1', 'b1')
           <e:if condition="${param.latn_id != ''}">
            and t1.latn_id = '${param.latn_id}'
           </e:if>
           <e:if condition="${param.bureau_no != ''}">
            and t1.bureau_no = '${param.bureau_no}'
           </e:if>
           <e:if condition="${param.union_org_code != ''}">
            and t1.union_org_code = '${param.union_org_code}'
           </e:if>
           <e:if condition="${!empty param.village_name}">
            AND t.village_name like '%${param.village_name}%'
           </e:if>
           <e:if condition="${!empty param.branch_type}">
            AND t1.branch_type ='${param.branch_type}'
           </e:if>
           <e:if condition="${param.grid_id != ''}">
            and (t1.grid_id = '${param.grid_id}' or t1.grid_union_org_code = '${param.grid_id}')
           </e:if>
           AND T.GRID_ID IS NULL) M2
  </e:description>
  <e:description>
  	小区数量，已废弃
  		select count(*)  villagecount
		  from ${gis_user}.tb_gis_village_edit_info c,
		       ${gis_user}.db_cde_grid              d,
		       ${gis_user}.spc_branch_station       e
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		 	  <e:if condition="${!empty param.branch_type}">
		 	 	and d.branch_type ='${param.branch_type}'
		 	 </e:if>
		 	 </e:description>

  <e:description>小区数量，支局下没有网格时，已废弃</e:description>
  <e:case value="village_list_count_none_grid">
    <e:q4o var="villagecount">
  		SELECT COUNT(*) VILLAGECOUNT
  			FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C
       LEFT JOIN (SELECT DISTINCT '' STATION_ID,
		                             T.LATN_ID,
                                 T.BUREAU_NO,
                                 T.UNION_ORG_CODE,
                                 T.BRANCH_TYPE,
                                 T.BRANCH_NAME,
                                 '' GRID_NAME,
                                 T.ZOOM,
                                 '' GRID_ZOOM
                   FROM ${gis_user}.DB_CDE_GRID T
                   LEFT JOIN ${gis_user}.SPC_BRANCH_STATION T1
                     ON T.GRID_UNION_ORG_CODE = T1.STATION_NO) D
		    ON C.BRANCH_NO = D.UNION_ORG_CODE
 		WHERE C.VALI_FLAG = 1
   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
    <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
   <e:if condition="${!empty param.branch_type}">
		 	 	and d.branch_type ='${param.branch_type}'
		 	 </e:if>
    </e:q4o>
    ${e:java2json(villagecount)}
  </e:case>

  <e:description>网格经理查看小区信息</e:description>
  <e:case value="village_list_grid_user">
  	<e:q4l var="list">
	  	SELECT '' VILLAGE_ID,
       '合计' VILLAGE_NAME,
       '' STATION_ID,
       '' GRID_NAME,
       '' UNION_ORG_CODE,
       '' BRANCH_NAME,
       nvl(SUM(ZHU_HU_SUM),0) ZHU_HU_SUM,
       nvl(SUM(WIDEBAND_NUM),0) WIDEBAND_NUM,
       nvl(SUM(TV_USER_NUM),0) TV_USER_NUM,
       nvl(SUM(CTCC_MOBILE_USER_NUM),0) CTCC_MOBILE_USER_NUM,
       ROUND(SUM(WIDEBAND_NUM) / SUM(ZHU_HU_SUM), 4) * 100 || '%' MARKET_LV,
       nvl(SUM(YX_ALL),0) YX_ALL,
       null PORT_SUM,
       null PORT_FREE_SUM,
       '--' port_lv
		  FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
		 WHERE
		 		1=1
		 	 <e:if condition="${param.latn_id != ''}">
		   	and a.latn_id = '${param.latn_id}'
		   </e:if>
   		 <e:if condition="${param.union_org_code != ''}">
		   	and a.union_org_code = '${param.union_org_code}'
		   </e:if>
		   <e:if condition="${param.grid_id != ''}">
		   	AND GRID_ID = (SELECT grid_id FROM ${gis_user}.db_cde_grid WHERE grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
       <e:if condition="${!empty param.village_name}">
		 	 	and a.village_name like '%${param.village_name}%'
		 	 </e:if>
		 GROUP BY LATN_ID, UNION_ORG_CODE,grid_id
		UNION ALL
		select * from (
		SELECT VILLAGE_ID,
		       VILLAGE_NAME,
		       STATION_ID,
		       GRID_NAME,
		       UNION_ORG_CODE,
		       BRANCH_NAME,
		       nvl(ZHU_HU_SUM,0) ZHU_HU_SUM,
		       nvl(WIDEBAND_NUM,0) WIDEBAND_NUM,
		       nvl(TV_USER_NUM,0) TV_USER_NUM,
		       nvl(CTCC_MOBILE_USER_NUM,0) CTCC_MOBILE_USER_NUM,
		       MARKET_LV,
		       nvl(YX_ALL,0) YX_ALL,
		       nvl(PORT_SUM,0) PORT_SUM,
		       nvl(PORT_FREE_SUM,0) PORT_FREE_SUM,
		       PORT_LV
		  FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
		 WHERE
		 		1=1
		   <e:if condition="${param.latn_id != ''}">
				  and a.latn_id = '${param.latn_id}'
			 </e:if>
		   <e:if condition="${param.union_org_code != ''}">
				  and a.union_org_code = '${param.union_org_code}'
			 </e:if>
		   <e:if condition="${param.grid_id != ''}">
		   		AND GRID_ID = (SELECT grid_id FROM ${gis_user}.db_cde_grid WHERE grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
       <e:if condition="${!empty param.village_name}">
		 	 		and a.village_name like '%${param.village_name}%'
			</e:if>
				order by village_name
			)
		</e:q4l>
  	 ${e:java2json(list.list)}
  </e:case>
  <e:description>
  	网格经理查看小区信息，已废弃
  	select '0' village_id,
       '合计' village_name,
       c.grid_id,
       c.branch_no UNION_ORG_CODE,
       d.branch_name,
       d.grid_name,
       e.station_id,
       d.zoom,
       d.grid_zoom,
       case
         when nvl(sum(c.zhu_hu_sum), 0) = 0 then
          0
         else
          round((nvl(sum(c.wideband_num), 0) / sum(c.zhu_hu_sum)), 4)*100
       end market_lv,
       sum(c.zhu_hu_sum) zhu_hu_sum,
       sum(c.wideband_num) wideband_num,
       sum(c.tv_user_num) tv_user_num,
       sum(c.ctcc_mobile_user_num) ctcc_mobile_user_num,
       sum(c.port_sum) port_sum,
       sum(c.port_free_sum) port_free_sum,
       case
         when nvl(sum(c.port_sum), 0) = 0 then
          0
         else
          round((nvl(sum(c.port_used_sum), 0) / sum(c.port_sum)), 4)*100
       end port_lv,
       sum(g.yx_all) yx_all
		  from ${gis_user}.tb_gis_village_edit_info        c,
		       ${gis_user}.db_cde_grid                     d,
		       ${gis_user}.spc_branch_station              e,
		       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE g
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   and g.village_id = c.village_id
		 group by c.grid_id,
		          c.branch_no,
		          d.branch_name,
		          d.grid_name,
		          e.station_id,
		          d.zoom,
		          d.grid_zoom
		union
		select c.village_id,
		       c.village_name,
		       c.grid_id,
		       c.branch_no UNION_ORG_CODE,
		       d.branch_name,
		       d.grid_name,
		       e.station_id,
		       d.zoom,
		       d.grid_zoom,
		       case when c.zhu_hu_sum =0 then 0 else round((c.wideband_num/c.zhu_hu_sum),4)*100 end market_lv,
		       c.zhu_hu_sum ,
		       c.wideband_num,
		       c.tv_user_num ,
		       c.ctcc_mobile_user_num ,
		       c.port_sum ,
		       c.port_free_sum ,
		       case when c.port_sum=0 then 0 else round((c.port_used_sum/c.port_sum ),4)*100 end port_lv,
		       g.yx_all
		  from ${gis_user}.tb_gis_village_edit_info c,
		       ${gis_user}.db_cde_grid              d,
		       ${gis_user}.spc_branch_station       e,
		       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE g
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   and g.village_id = c.village_id
  </e:description>

  <e:description>省、市级用户查看小区统计信息列表</e:description>
	<e:case value="village_summary_list">
		<e:q4l var="list">
          SELECT *
          FROM (SELECT T.*, ROWNUM RN
          FROM (SELECT VILLAGE_ID,
          VILLAGE_NAME,
          STATION_ID,
          LATN_ID,
          LATN_NAME,
          BUREAU_NO,
          BUREAU_NAME,
          UNION_ORG_CODE,
          BRANCH_NAME,
          CASE
          WHEN BRANCH_TYPE = 'a1' THEN
          '城市'
          WHEN BRANCH_TYPE = 'b1' THEN
          '农村'
          END BRANCH_TYPE_TEXT,
          GRID_ID,
          DECODE(GRID_NAME, NULL, BRANCH_NAME, GRID_NAME) GRID_NAME,
          BUILD_SUM,
          NVL(ZHU_HU_SUM, 0) ZHU_HU_SUM,
          NVL(PORT_SUM, 0) PORT_SUM,
          NVL(PORT_USED_SUM, 0) PORT_USED_SUM,
          NVL(PORT_FREE_SUM, 0) PORT_FREE_SUM,
          MARKET_LV,
          PORT_LV
          FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
          WHERE 1 = 1
          <e:if condition="${!empty param.latn_id}">
            and a.latn_id = '${param.latn_id}'
          </e:if>
          <e:if condition="${!empty param.bureau_no}">
            and a.bureau_no = '${param.bureau_no}'
          </e:if>
          <e:if condition="${!empty param.union_org_code}">
            and a.union_org_code = '${param.union_org_code}'
          </e:if>
          <e:if condition="${!empty param.branch_type}">
            and a.branch_type ='${param.branch_type}'
          </e:if>
          <e:if condition="${!empty param.grid_id}">
            and a.grid_id = '${param.grid_id}'
          </e:if>
          <e:if condition="${!empty param.village_name}">
            and a.village_name like '%${param.village_name}%'
          </e:if>
          ORDER BY A.CITY_ORDER_NUM,
          A.REGION_ORDER_NUM,
          BRANCH_TYPE,
          GRID_ID,
          VILLAGE_NAME) T
          WHERE ROWNUM <= ${param.page+1} * 100) M
          WHERE M.RN > ${param.page} * 100
		</e:q4l>
	  ${e:java2json(list.list)}
  </e:case>
  <e:description>
  	2017-12-06 小区详表废弃 排序问题，orderby并没有起作用
  	select * from (
			SELECT VILLAGE_ID,
		       VILLAGE_NAME,
		       STATION_ID,
		       LATN_ID,
		       LATN_NAME,
		       BUREAU_NO,
		       BUREAU_NAME,
		       UNION_ORG_CODE,
		       BRANCH_NAME,
		       case when BRANCH_TYPE='a1' then '城市' when BRANCH_TYPE='b1' then '农村' end BRANCH_TYPE_TEXT,
		       GRID_ID,
		       GRID_NAME,
		       build_sum,
		       nvl(ZHU_HU_SUM,0) ZHU_HU_SUM,
					 nvl(PORT_SUM,0) PORT_SUM,
					 NVL(port_used_sum,0) port_used_sum,
		       nvl(PORT_FREE_SUM,0) PORT_FREE_SUM,
		       MARKET_LV,
		       PORT_LV,
		       row_number() over(ORDER BY latn_id) rn
		  FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
		 WHERE
		 		1=1
		 	 <e:if condition="${!empty param.latn_id}">
		   	and a.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${!empty param.bureau_no}">
		   	and a.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${!empty param.union_org_code}">
		   	and a.union_org_code = '${param.union_org_code}'
		   </e:if>
		   <e:if condition="${!empty param.branch_type}">
				and a.branch_type ='${param.branch_type}'
			 </e:if>
		   <e:if condition="${!empty param.grid_id}">
		   	and a.grid_id = '${param.grid_id}'
		 	 </e:if>
       <e:if condition="${!empty param.village_name}">
		 	 	and a.village_name like '%${param.village_name}%'
			 </e:if>
			 	order by CITY_ORDER_NUM,REGION_ORDER_NUM,BRANCH_TYPE,grid_id,VILLAGE_NAME
			 )t
    where rn>${param.page}*100 and rn <=${param.page+1}*100
  </e:description>

  <e:description>省、市级用户查看小区统计信息汇总数量统计</e:description>
  <e:case value="village_summary_count">
  	<e:q4o var="dataObject">
  		SELECT count(distinct village_id) count_sum,
             count(distinct case
                    when a.branch_type = 'a1'
                    then village_id
                  end) count_a1,
             count(distinct case
                    when a.branch_type = 'b1'
                    then village_id
                  end) count_b1
      FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
     WHERE 1 = 1
       <e:if condition="${!empty param.latn_id}">
        and a.latn_id = '${param.latn_id}'
       </e:if>
       <e:if condition="${!empty param.bureau_no}">
        and a.bureau_no = '${param.bureau_no}'
       </e:if>
       <e:if condition="${!empty param.union_org_code}">
        and a.union_org_code = '${param.union_org_code}'
       </e:if>
       <e:if condition="${!empty param.branch_type}">
        and a.branch_type ='${param.branch_type}'
       </e:if>
       <e:if condition="${!empty param.grid_id}">
        and a.grid_id = '${param.grid_id}'
       </e:if>
       <e:if condition="${!empty param.village_name}">
        and a.village_name like '%${param.village_name}%'
       </e:if>
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>支局经理查看小区信息，支局下有无网格通用</e:description>
	<e:case value="village_list_sub_user">
		<e:q4l var="list">
	  	SELECT '' VILLAGE_ID,
       '合计' VILLAGE_NAME,
       '' STATION_ID,
       '' GRID_NAME,
       '' UNION_ORG_CODE,
       '' BRANCH_NAME,
       SUM(ZHU_HU_SUM) ZHU_HU_SUM,
       SUM(WIDEBAND_NUM) WIDEBAND_NUM,
       SUM(TV_USER_NUM) TV_USER_NUM,
       SUM(CTCC_MOBILE_USER_NUM) CTCC_MOBILE_USER_NUM,
       ROUND(SUM(WIDEBAND_NUM) / SUM(ZHU_HU_SUM), 4) * 100 || '%' MARKET_LV,
       nvl(SUM(YX_ALL),0) YX_ALL,
       null PORT_SUM,
       null PORT_FREE_SUM,
       '--' port_lv
		  FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
		 WHERE 1=1
		 	 <e:if condition="${param.latn_id != ''}">
				and a.latn_id = '${param.latn_id}'
			 </e:if>
		   <e:if condition="${param.union_org_code != ''}">
			 	and a.union_org_code = '${param.union_org_code}'
			 </e:if>
			 <e:if condition="${param.grid_id != ''}" var="emptyGridId">
				and a.grid_id = '${param.grid_id}'
			 </e:if>
       <e:if condition="${!empty param.village_name}">
		 	 	and a.village_name like '%${param.village_name}%'
		 	 </e:if>
		  GROUP BY LATN_ID,
          UNION_ORG_CODE
		UNION ALL
		select * from (
		SELECT VILLAGE_ID,
		       VILLAGE_NAME,
		       STATION_ID,
		       GRID_NAME,
		       UNION_ORG_CODE,
		       BRANCH_NAME,
		       nvl(ZHU_HU_SUM,0) ZHU_HU_SUM,
		       nvl(WIDEBAND_NUM,0) WIDEBAND_NUM,
		       nvl(TV_USER_NUM,0) TV_USER_NUM,
		       nvl(CTCC_MOBILE_USER_NUM,0) CTCC_MOBILE_USER_NUM,
		       MARKET_LV,
		       nvl(YX_ALL,0) YX_ALL,
		       nvl(PORT_SUM,0) PORT_SUM,
		       nvl(PORT_FREE_SUM,0) PORT_FREE_SUM,
		       PORT_LV
		  FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
		 WHERE
		 		1=1
		 	 <e:if condition="${param.latn_id != ''}">
		   	and a.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and a.union_org_code = '${param.union_org_code}'
		   </e:if>
		   <e:if condition="${param.grid_id != ''}">
		   	and a.grid_id = '${param.grid_id}'
		 	 </e:if>
       <e:if condition="${!empty param.village_name}">
		 	 	and a.village_name like '%${param.village_name}%'
			 </e:if>
			 	order by village_Name
			 )
		</e:q4l>
	  ${e:java2json(list.list)}
  </e:case>

  <e:case value="village_list_sub_user_by_vids">
  	<e:q4l var="dataList">
  		select * from (
				SELECT VILLAGE_ID,
				       VILLAGE_NAME,
				       STATION_ID,
				       GRID_NAME,
				       UNION_ORG_CODE,
				       BRANCH_NAME,
				       nvl(ZHU_HU_SUM,0) ZHU_HU_SUM,
				       nvl(WIDEBAND_NUM,0) WIDEBAND_NUM,
				       nvl(TV_USER_NUM,0) TV_USER_NUM,
				       nvl(CTCC_MOBILE_USER_NUM,0) CTCC_MOBILE_USER_NUM,
				       MARKET_LV,
				       nvl(YX_ALL,0) YX_ALL,
				       nvl(PORT_SUM,0) PORT_SUM,
				       nvl(PORT_FREE_SUM,0) PORT_FREE_SUM,
				       PORT_LV
				  FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
				 WHERE
				 		1=1
				 	 <e:if condition="${param.vids != ''}">
				   	and a.village_id in (${param.vids})
				   </e:if>
					 	order by village_Name
					 )
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>
  	支局经理查看小区信息 支局下有网格 已废弃 village_list_sub_user_hasGrid
  	select  '0' VILLAGE_ID,
       '合计' VILLAGE_NAME,
       '' GRID_ID,
       C.BRANCH_NO UNION_ORG_CODE,
       D.BRANCH_NAME,
       '' GRID_NAME,
       '' STATION_ID,
       0 ZOOM,
       0 GRID_ZOOM,
       case
         when nvl(sum(c.zhu_hu_sum), 0) = 0 then
          0
         else
          round((nvl(sum(c.wideband_num), 0) / sum(c.zhu_hu_sum)), 4)*100
       end market_lv,
       sum(c.zhu_hu_sum) zhu_hu_sum,
       sum(c.wideband_num) wideband_num,
       sum(c.tv_user_num) tv_user_num,
       sum(c.ctcc_mobile_user_num) ctcc_mobile_user_num,
       sum(c.port_sum) port_sum,
       sum(c.port_free_sum) port_free_sum,
       case
         when nvl(sum(c.port_sum), 0) = 0 then
          0
         else
          round((nvl(sum(c.port_used_sum), 0) / sum(c.port_sum)), 4)*100
       end port_lv,
       sum(g.yx_all) yx_all
		  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C
			  LEFT JOIN ${gis_user}.SPC_BRANCH_STATION E
			  ON C.GRID_ID = E.STATION_ID
			  LEFT JOIN ${gis_user}.DB_CDE_GRID D
			  ON D.GRID_UNION_ORG_CODE = E.STATION_NO
			  LEFT JOIN ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE G
			    ON G.VILLAGE_ID = C.VILLAGE_ID
		 	WHERE C.VALI_FLAG = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   and g.village_id = c.village_id
		 group by C.BRANCH_NO,
          		D.BRANCH_NAME
		union
		select c.village_id,
		       c.village_name,
		       c.grid_id,
		       c.branch_no UNION_ORG_CODE,
		       d.branch_name,
		       d.grid_name,
		       e.station_id,
		       d.zoom,
		       d.grid_zoom,
		       case when c.zhu_hu_sum =0 then 0 else round((c.wideband_num/c.zhu_hu_sum),4)*100 end market_lv,
		       c.zhu_hu_sum ,
		       c.wideband_num,
		       c.tv_user_num ,
		       c.ctcc_mobile_user_num ,
		       c.port_sum ,
		       c.port_free_sum ,
		       case when c.port_sum=0 then 0 else round((c.port_used_sum/c.port_sum ),4)*100 end port_lv,
		       g.yx_all
		 FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C
		  LEFT JOIN ${gis_user}.SPC_BRANCH_STATION E
		  ON C.GRID_ID = E.STATION_ID
		  LEFT JOIN ${gis_user}.DB_CDE_GRID D
		  ON D.GRID_UNION_ORG_CODE = E.STATION_NO
		  LEFT JOIN ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE G
		    ON G.VILLAGE_ID = C.VILLAGE_ID
		 WHERE C.VALI_FLAG = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
  </e:description>
  <e:description>
  	获取小区列表，支局下没有网格 village_list_sub_user_noneGrid
  	SELECT '0' VILLAGE_ID,
       '合计' VILLAGE_NAME,
       '' GRID_ID,
       C.BRANCH_NO UNION_ORG_CODE,
       D.BRANCH_NAME,
       '' GRID_NAME,
       '' STATION_ID,
       D.ZOOM,
       '' GRID_ZOOM,
       CASE
         WHEN sum(C.ZHU_HU_SUM) = 0 THEN
          0
         ELSE
          ROUND((sum(C.WIDEBAND_NUM) / sum(C.ZHU_HU_SUM)), 4) * 100
       END MARKET_LV,
       sum(C.ZHU_HU_SUM) ZHU_HU_SUM,
       sum(C.WIDEBAND_NUM) WIDEBAND_NUM,
       sum(C.TV_USER_NUM) TV_USER_NUM,
       sum(C.CTCC_MOBILE_USER_NUM) CTCC_MOBILE_USER_NUM,
       sum(C.PORT_SUM) PORT_SUM,
       sum(C.PORT_FREE_SUM) PORT_FREE_SUM,
       CASE
         WHEN sum(C.PORT_SUM) = 0 THEN
          0
         ELSE
          ROUND((sum(C.PORT_USED_SUM) / sum(C.PORT_SUM)), 4) * 100
       END PORT_LV,
       sum(G.YX_ALL) YX_ALL
	  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C
	  LEFT JOIN (SELECT DISTINCT '' STATION_ID,
	                             T.LATN_ID,
	                             T.BUREAU_NO,
	                             T.UNION_ORG_CODE,
	                             T.BRANCH_TYPE,
	                             T.BRANCH_NAME,
	                             '' GRID_NAME,
	                             T.ZOOM,
	                             '' GRID_ZOOM
	               FROM ${gis_user}.DB_CDE_GRID T
	               LEFT JOIN ${gis_user}.SPC_BRANCH_STATION T1
	                 ON T.GRID_UNION_ORG_CODE = T1.STATION_NO) D
	    ON C.BRANCH_NO = D.UNION_ORG_CODE
	  LEFT JOIN ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE G
	    ON G.VILLAGE_ID = C.VILLAGE_ID
	 WHERE C.VALI_FLAG = 1
	   <e:if condition="${param.latn_id != ''}">
	   	and d.latn_id = '${param.latn_id}'
	   </e:if>
	   <e:if condition="${param.bureau_no != ''}">
	   	and d.bureau_no = '${param.bureau_no}'
	   </e:if>
	   <e:if condition="${param.union_org_code != ''}">
	   	and d.union_org_code = '${param.union_org_code}'
	   </e:if>
	   AND D.BRANCH_TYPE IN ('a1', 'b1')
	 GROUP BY c.BRANCH_NO,
	          d.BRANCH_NAME,
	          d.zoom
		UNION
		SELECT C.VILLAGE_ID,
		       C.VILLAGE_NAME,
		       C.GRID_ID,
		       C.BRANCH_NO UNION_ORG_CODE,
		       D.BRANCH_NAME,
		       D.GRID_NAME,
		       D.STATION_ID,
		       D.ZOOM,
		       D.GRID_ZOOM,
		       CASE
		         WHEN C.ZHU_HU_SUM = 0 THEN
		          0
		         ELSE
		          ROUND((C.WIDEBAND_NUM / C.ZHU_HU_SUM), 4) * 100
		       END MARKET_LV,
		       C.ZHU_HU_SUM,
		       C.WIDEBAND_NUM,
		       C.TV_USER_NUM,
		       C.CTCC_MOBILE_USER_NUM,
		       C.PORT_SUM,
		       C.PORT_FREE_SUM,
		       CASE
		         WHEN C.PORT_SUM = 0 THEN
		          0
		         ELSE
		          ROUND((C.PORT_USED_SUM / C.PORT_SUM), 4) * 100
		       END PORT_LV,
		       G.YX_ALL
		  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C
		  LEFT JOIN (SELECT DISTINCT '' STATION_ID,
		                             T.LATN_ID,
		                             T.BUREAU_NO,
		                             T.UNION_ORG_CODE,
		                             T.BRANCH_TYPE,
		                             T.BRANCH_NAME,
		                             '' GRID_NAME,
		                             T.ZOOM,
		                             '' GRID_ZOOM
		               FROM ${gis_user}.DB_CDE_GRID T
		               LEFT JOIN ${gis_user}.SPC_BRANCH_STATION T1
		                 ON T.GRID_UNION_ORG_CODE = T1.STATION_NO) D
		    ON C.BRANCH_NO = D.UNION_ORG_CODE
		  LEFT JOIN ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE G
		    ON G.VILLAGE_ID = C.VILLAGE_ID
		 WHERE C.VALI_FLAG = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   AND D.BRANCH_TYPE IN ('a1', 'b1')
  </e:description>

  <e:description>支局经理查看小区信息，等关联写法，已废弃</e:description>
  <e:case value="village_list_sub_user_nouse">
  	<e:q4l var="list">
  		select  '0' VILLAGE_ID,
       '合计' VILLAGE_NAME,
       '' GRID_ID,
       C.BRANCH_NO UNION_ORG_CODE,
       D.BRANCH_NAME,
       '' GRID_NAME,
       '' STATION_ID,
       0 ZOOM,
       0 GRID_ZOOM,
       case
         when nvl(sum(c.zhu_hu_sum), 0) = 0 then
          0
         else
          round((nvl(sum(c.wideband_num), 0) / sum(c.zhu_hu_sum)), 4)*100
       end market_lv,
       sum(c.zhu_hu_sum) zhu_hu_sum,
       sum(c.wideband_num) wideband_num,
       sum(c.tv_user_num) tv_user_num,
       sum(c.ctcc_mobile_user_num) ctcc_mobile_user_num,
       sum(c.port_sum) port_sum,
       sum(c.port_free_sum) port_free_sum,
       case
         when nvl(sum(c.port_sum), 0) = 0 then
          0
         else
          round((nvl(sum(c.port_used_sum), 0) / sum(c.port_sum)), 4)*100
       end port_lv,
       sum(g.yx_all) yx_all
		  from ${gis_user}.tb_gis_village_edit_info        c,
		       ${gis_user}.db_cde_grid                     d,
		       ${gis_user}.spc_branch_station              e,
		       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE g
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   and g.village_id = c.village_id
		 group by C.BRANCH_NO,
          		D.BRANCH_NAME
		union
		select c.village_id,
		       c.village_name,
		       c.grid_id,
		       c.branch_no UNION_ORG_CODE,
		       d.branch_name,
		       d.grid_name,
		       e.station_id,
		       d.zoom,
		       d.grid_zoom,
		       case when c.zhu_hu_sum =0 then 0 else round((c.wideband_num/c.zhu_hu_sum),4)*100 end market_lv,
		       c.zhu_hu_sum ,
		       c.wideband_num,
		       c.tv_user_num ,
		       c.ctcc_mobile_user_num ,
		       c.port_sum ,
		       c.port_free_sum ,
		       case when c.port_sum=0 then 0 else round((c.port_used_sum/c.port_sum ),4)*100 end port_lv,
		       g.yx_all
		  from ${gis_user}.tb_gis_village_edit_info c,
		       ${gis_user}.db_cde_grid              d,
		       ${gis_user}.spc_branch_station       e,
		       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE g
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.vali_flag = 1
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		   and g.village_id = c.village_id
  	</e:q4l>
  	 ${e:java2json(list.list)}
  </e:case>
  <e:description>左侧网格列表</e:description>
  <e:case value="grid_list">
    <e:q4l var="list">
      select rownum,a.* from (
      SELECT l.* from
      (select d.grid_id,
      d.grid_name,
      s.station_id,
      d.union_org_code,
      d.grid_union_org_code,
      d.branch_name,
      d.latn_name,
      d.grid_show,
      d.zoom,
      d.grid_zoom
      from
      ${gis_user}.DB_CDE_GRID d,${gis_user}.SPC_BRANCH_STATION s
      where d.branch_type in ('a1', 'b1')
      and d.grid_union_org_code is not null
      and d.grid_union_org_code=s.station_no
      and d.grid_status =1
      <e:if condition="${param.latn_id != ''}">
        and d.latn_id= ${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no != ''}">
        and d.bureau_no= ${param.bureau_no}
      </e:if>
      <e:if condition="${param.union_org_code != ''}">
        and d.union_org_code= ${param.union_org_code}
      </e:if>
      <e:if condition="${param.grid_name != ''}">
        and d.grid_name like '%${param.grid_name}%'
      </e:if>
      ) l
       order by grid_show desc,GRID_UNION_ORG_CODE
      ) a
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>左侧网格列表，去掉和TB_DW_GIS_GROW_VILLAGE_DAY表的关联，已废弃，此表是化小的旧小区，点方式上图</e:description>
  <e:case value="grid_list_nouse_bak">
    <e:q4l var="list">
      select rownum,a.* from (
      SELECT l.*,nvl(r.count,0) count from
      (select d.grid_id,
      d.grid_name,
      s.station_id,
      d.union_org_code,
      d.grid_union_org_code,
      d.branch_name,
      d.latn_name,
      d.grid_show,
      d.zoom,
      d.grid_zoom
      from
      ${gis_user}.DB_CDE_GRID d,${gis_user}.SPC_BRANCH_STATION s
      where d.branch_type in ('a1', 'b1')
      and d.grid_union_org_code is not null
      and d.grid_union_org_code=s.station_no
      and d.grid_status =1
      <e:if condition="${param.latn_id != ''}">
        and d.latn_id= ${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no != ''}">
        and d.bureau_no= ${param.bureau_no}
      </e:if>
      <e:if condition="${param.union_org_code != ''}">
        and d.union_org_code= ${param.union_org_code}
      </e:if>
      <e:if condition="${param.grid_name != ''}">
        and d.grid_name like '%${param.grid_name}%'
      </e:if>
      ) l left join (select GRID_ID,count(*) count from ${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY where village_name is not null GROUP BY GRID_ID) r
      on l.grid_id = r.GRID_ID order by grid_show desc,count DESC,GRID_UNION_ORG_CODE
      ) a
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>楼宇信息查看</e:description>
  <e:case value="build_win">
    <e:q4o var="obj">
     SELECT A.*, NVL(B.ORG_NAME, ' ') BUREAU_NAME
			  FROM (SELECT DISTINCT D.RESID SEGM_ID,
			                        D.RESFULLNAME STAND_NAME,

			                        NVL(D.LATN_NAME, ' ') LATN_NAME,
			                        D.BUREAU_NO,
			                        D.BUREAU_NAME,
			                        nvl(D.UNION_ORG_CODE, ' ') UNION_ORG_CODE,
			                        NVL(D.BRANCH_NAME, ' ') BRANCH_NAME,
			                        NVL(D.GRID_NAME, ' ') GRID_NAME,
			                        NVL(E.VILLAGE_NAME, ' ') VILLAGE_NAME,

			                        DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100, 'FM9990.00') || '%') MARKET_RATE,
			                        g.zhu_hu_count ,
			                        gz_h_use_cnt ,
			                        gov_zhu_hu_count ,
			                        ly_cnt ,
			                        h_use_cnt ,
			                        gov_h_use_cnt ,
			                        no_res_arrive_cnt ,

			                        DECODE(NVL(port_id_cnt , '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(g.use_port_cnt , 0) / port_id_cnt , 4) * 100, 'FM9999999990.00') || '%') port_lv,
			                        port_id_cnt ,
			                        obd_cnt ,
			                        zero_obd_cnt ,
			                        kong_port_cnt ,
			                        high_use_obd_cnt ,

			                        CASE WHEN nvl(should_collect_cnt,0) = 0 THEN '0.00%' ELSE to_char(ROUND(nvl(already_collect_cnt,0)/should_collect_cnt,4)*100, 'FM9999999990.00') || '%' END collect_lv,
			                        nvl(should_collect_cnt,0) should_collect_cnt,
			                        NVL(should_collect_cnt,0 )-NVL(already_collect_cnt,0 ) uncollect,
			                        NVL(filter_mon_rate ,0)||'%' filter_mon_rate,
			                        NVL(already_collect_cnt ,0) already_collect_cnt

			          FROM SDE.MAP_ADDR_SEGM_${param.latn_id} D
			          LEFT JOIN ${gis_user}.TB_GIS_RES_INFO_DAY g
			          ON d.resid = g.latn_id
			          LEFT JOIN (SELECT A.VILLAGE_NAME, B.SEGM_ID
			                      FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A,
			                           ${gis_user}.TB_GIS_VILLAGE_ADDR4     B
			                     WHERE A.VILLAGE_ID = B.VILLAGE_ID
			                       AND B.SEGM_ID = '${param.res_id}') E
			            ON D.RESID = E.SEGM_ID
			         WHERE D.RESID = '${param.res_id}') A
			  LEFT JOIN FREAMWORK2ORG B
			    ON A.BUREAU_NO = B.CITYIDCOL
    </e:q4o>${e:java2json(obj)}
  </e:case>

  <e:description>获取楼宇基本信息</e:description>
  <e:case value="getBuildBaseInfo">
  	<e:q4o var="dataObject">

  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>小区绘制后预览楼宇的情况</e:description>
  <e:case value="build_wines_selected_build">
    <e:q4l var="dataList">
			select '0' segm_id,
		       nvl(sum(a.ZHU_HU_COUNT),0) ZHU_HU_COUNT,
		       nvl(sum(CENG_COUNT),0) CENG_COUNT,
		       nvl(sum(PEOPLE_COUNT),0) PEOPLE_COUNT,
		       0 OCCUPANCY_RATE,
		       0 RES_ID_COUNT,
		       0 SY_RES_COUNT,
		       nvl(sum(a.KD_COUNT),0) KD_COUNT,
		       nvl(sum(ITV_COUNT),0) ITV_COUNT,
		       nvl(sum(GU_COUNT),0) GU_COUNT,
		       nvl(sum(YD_COUNT),0) YD_COUNT,
		       nvl(sum(d.obd_cnt),0) obd_cnt,
		       nvl(sum(e.yx_Un),0) yx_un
		  from (select a.SEGM_ID,
		               ZHU_HU_COUNT,
		               CENG_COUNT,
		               PEOPLE_COUNT,
		               OCCUPANCY_RATE,
		               a.KD_COUNT,
		               a.ITV_COUNT,
		               a.GU_COUNT,
		               a.YD_COUNT
		          FROM ${gis_user}.TB_GIS_ADDR_INFO_VIEW a
		         where a.SEGM_ID in (${param.segm_ids})) a
		  left join (select a.segm_id, count(1) yx_un
		               FROM ${gis_user}.TB_GIS_ADDR_INFO_VIEW a,
		                    ${gis_user}.TB_GIS_BROADBD_YX_D   c
		              where a.SEGM_ID in (${param.segm_ids})
		                and a.segm_Id = c.segm_id
		                and c.did_flag is null
		                and c.prod_inst_id is not null
		              group by a.SEGM_ID) e
		    on a.segm_Id = e.segm_id
			LEFT JOIN ${gis_user}.tb_gis_res_info_day d
    		ON a.segm_id = d.latn_id

		union

		select a.*,d.obd_cnt,nvl(e.yx_Un,0) yx_Un
		  from (select a.SEGM_ID,
		               nvl(a.ZHU_HU_COUNT,0) ZHU_HU_COUNT,
		               nvl(CENG_COUNT,0) CENG_COUNT,
		               nvl(PEOPLE_COUNT,0) PEOPLE_COUNT,
		               OCCUPANCY_RATE,
		               nvl(RES_ID_COUNT,0) RES_ID_COUNT,
		               nvl(SY_RES_COUNT,0) SY_RES_COUNT,
		               nvl(a.KD_COUNT,0) KD_COUNT,
		               nvl(a.ITV_COUNT,0) ITV_COUNT,
		               nvl(a.GU_COUNT,0) GU_COUNT,
		               nvl(a.YD_COUNT,0) YD_COUNT
		          FROM ${gis_user}.TB_GIS_ADDR_INFO_VIEW a
		         where a.SEGM_ID in (${param.segm_ids})) a
		  left join (select a.segm_id, count(1) yx_un

		               FROM ${gis_user}.TB_GIS_ADDR_INFO_VIEW a,
		                    ${gis_user}.TB_GIS_BROADBD_YX_D   c
		              where a.SEGM_ID in (${param.segm_ids})
		                and a.segm_Id = c.segm_id
		                and c.did_flag is null
		             		and c.prod_inst_id is not null
		              group by a.SEGM_ID) e
		    on a.segm_Id = e.segm_id
		  LEFT JOIN ${gis_user}.tb_gis_res_info_day d
    		ON a.segm_id = d.latn_id

    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getMapGridIdByGridUnionOrgCode">
  	<e:q4o var="dataObject">
  		SELECT station_id FROM ${gis_user}.spc_branch_station a,SDE.MAP_ADDR_SEGM_${param.latn_id} b WHERE a.station_no = b.grid_union_org_code AND grid_union_org_code = '${param.grid_union_org_code}'
  	</e:q4o>
  	${e:java2json(dataObject)}
  </e:case>

  <e:description>点小区编辑，加载小区下楼宇的信息，包含端口，营销数</e:description>
  <e:case value="build_wines">
    <e:q4l var="dataList">
      select '0' as segm_id,
       '' as segm_name,
       '合计' as stand_name,
       nvl(sum(a.ZHU_HU_COUNT),0) ZHU_HU_COUNT,
       nvl(sum(CENG_COUNT),0) CENG_COUNT,
       nvl(sum(PEOPLE_COUNT),0) PEOPLE_COUNT,
       0 OCCUPANCY_RATE,
       null RES_ID_COUNT,
       null SY_RES_COUNT,
       null port_lv,
       nvl(sum(a.KD_COUNT),0) KD_COUNT,
       nvl(sum(ITV_COUNT),0) ITV_COUNT,
       nvl(sum(GU_COUNT),0) GU_COUNT,
       nvl(sum(YD_COUNT),0) YD_COUNT,
       nvl(sum(d.obd_cnt),0) obd_cnt,
       nvl(sum(n.yx_all),0) yx_un
		  FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 c
		  left join ${gis_user}.TB_GIS_ADDR_INFO_VIEW a
		    on a.segm_id = c.segm_id
		  left join (select t.segm_id,
		                    count(distinct t.prod_inst_id) yx_all,
		                    count(distinct case
		                            when prod_inst_id is not null and did_flag is null then
		                             prod_inst_id
		                          end) yx_un,
		                    count(distinct case
		                            when prod_inst_id is not null and did_flag is not null then
		                             prod_inst_id
		                          end) yx_done
		               from ${gis_user}.TB_GIS_BROADBD_YX_D t
		              group by t.segm_id)n
		              on c.segm_id = n.segm_id
		 	LEFT JOIN ${gis_user}.tb_gis_res_info_day d
    		ON c.segm_id = d.latn_id
		 where c.village_id = '${param.village_id}'
		union
		select c.SEGM_ID,
		       c.segm_name,
		       c.stand_name,
		       a.ZHU_HU_COUNT,
		       CENG_COUNT,
		       PEOPLE_COUNT,
		       OCCUPANCY_RATE,
		       RES_ID_COUNT,
		       SY_RES_COUNT,
		       CASE WHEN RES_ID_COUNT=0 THEN 0 ELSE round((RES_ID_COUNT-SY_RES_COUNT)/RES_ID_COUNT,4)*100 end port_lv,
		       a.KD_COUNT,
		       ITV_COUNT,
		       GU_COUNT,
		       YD_COUNT,
		       d.obd_cnt,
		       nvl(n.yx_all,0) yx_un
		  FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 c
		  left join ${gis_user}.TB_GIS_ADDR_INFO_VIEW a
		    on a.segm_id = c.segm_id
		  left join (select t.segm_id,
		                    count(distinct t.prod_inst_id) yx_all,
		                    count(distinct case
		                            when prod_inst_id is not null and did_flag is null then
		                             prod_inst_id
		                          end) yx_un,
		                    count(distinct case
		                            when prod_inst_id is not null and did_flag is not null then
		                             prod_inst_id
		                          end) yx_done
		               from ${gis_user}.TB_GIS_BROADBD_YX_D t
		              group by t.segm_id)n
		              on c.segm_id = n.segm_id
			LEFT JOIN ${gis_user}.tb_gis_res_info_day d
    		ON c.segm_id = d.latn_id
		 where c.village_id = '${param.village_id}'
		    </e:q4l>
		    ${e:java2json(dataList.list)}
  </e:case>
  <e:description>使用化小的小区数据查询小区信息，已废弃</e:description>
  <e:case value="village_message_old">
    <e:q4o var="obj">
      select trunc(WIDEBAND_ST_RATE,4)*100 WIDEBAND_ST_RATE,trunc(MOBILE_ST_RATE,4)*100 MOBILE_ST_RATE,trunc(IPTV_ST_RATE,4)*100 IPTV_ST_RATE,trunc(H_USER_ST_RATE,4)*100 H_USER_ST_RATE,
      VILLAGE_NAME,BUILDING_NUM,UNIT_NUM,FAMILY_NUM,PEOPLE_NUM,MOBILE_NUM,WIDEBAND_NUM,IPTV_NUM,H_USER_NUM,VILLAGE_TYPE,
      OCCUPANCY_RATE,IS_SOLE,IS_FDDI,H_PORT_NUM,H_PORT_USE_RATE,CMCC_NUM,CM_WIDEBAND_NUM,CMCC_TV_NUM,
      CUCC_NUM,CU_WIDEBAND_NUM,CUCC_TV_USER_NUM,VILLAGE_NAME from ${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY where village_id='${param.village_id}'
    </e:q4o>
    ${e:java2json(obj)}
  </e:case>

  <e:description>使用国信的小区数据查询小区信息</e:description>
  <e:case value="village_message">
    <e:q4o var="obj">
      select village_name from ${gis_user}.tb_gis_village_edit_info where village_id = '${param.village_id}' and vali_flag = 1
    </e:q4o>
    ${e:java2json(obj)}
  </e:case>

  <e:case value="village_all">
    <e:q4l var="list">
      select * from ${gis_user}.TB_GIS_ADDR_INFO_ALL where SEGM_ID='${param.village_id}' ORDER BY  SEGM_NAME_2
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>化小的旧小区关系，点地图上图方式，已废弃</e:description>
  <e:case value="village_insert">
    <e:update>
      begin
      insert into SDE.GIS_MAP_VILLAGE_INFO
      (
      VILLAGE_ID,
      POS_X,
      POS_Y,
      STATUS,
      GRID_ID,
      RES_ID,
      pinnt,
      objectid,
      sub_id,
      breau_id,
      city_id
      )
      values
      (
      '${param.village_id}',
      '${param.x}',
      '${param.y}',
      1,
      '${param.grid_id}',
      '${param.res_id}',
      sde.st_point('${param.x}', '${param.y}',4326),
      sde.VILLAGE_SEQ.nextVal,
      '${param.sub_id}',
      '${param.breau_id}',
      '${param.city_id}'
      );

      update ${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY
      set BEN_GIS_UPLOAD = 1
      where village_id = '${param.village_id}';

      insert into ${gis_user}.log_village_ope
      (
      OPERATOR_ID,
      OPERA_TYPE,
      OPERA_TIME,
      VILLAGE_ID
      )
      values
      (
      '${sessionScope.UserInfo.LOGIN_ID}',
      '1',
      to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),
      '${param.village_id}'
      );
      end;
    </e:update>
  </e:case>
  <e:description>化小的旧小区关系，点地图上图方式，已废弃</e:description>
  <e:case value="village_update">
    <e:update>
      begin
      update SDE.GIS_MAP_VILLAGE_INFO
      set POS_X = '${param.x}',
      POS_Y = '${param.y}',
      pinnt =  sde.st_point('${param.x}', '${param.y}',4326)
      STATUS = 1
      where VILLAGE_ID = '${param.village_id}';

      update ${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY
      set BEN_GIS_UPLOAD = 1
      where village_id = '${param.village_id}';

      insert into ${gis_user}.log_village_ope
      (
      OPERATOR_ID,
      OPERA_TYPE,
      OPERA_TIME,
      VILLAGE_ID
      )
      values
      (
      '${sessionScope.UserInfo.LOGIN_ID}',
      '2',
      to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),
      '${param.village_id}'
      );
      end;
    </e:update>
  </e:case>
  <e:description>化小的旧小区关系，点地图上图方式，已废弃</e:description>
  <e:case value="village_delete">
    <e:update>
      begin
      update SDE.GIS_MAP_VILLAGE_INFO
      set STATUS = 0
      where VILLAGE_ID = '${param.village_id}';


      update ${gis_user}.TB_DW_GIS_GROW_VILLAGE_DAY
      set BEN_GIS_UPLOAD = 0
      where village_id = '${param.village_id}';

      insert into ${gis_user}.log_village_ope
      (
      OPERATOR_ID,
      OPERA_TYPE,
      OPERA_TIME,
      VILLAGE_ID
      )
      values
      (
      '${sessionScope.UserInfo.LOGIN_ID}',
      '3',
      to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),
      '${param.village_id}'
      );
      end;
    </e:update>
  </e:case>
  <e:case value="city_name">
    <e:q4l var="list">
      select REGION_ID,BUREAU_NAME city_desc,REGION_NO from ${gis_user}.TB_GIS_ADDR_INFO_ALL where latn_id = ${param.latn_id}
      GROUP BY REGION_ID,BUREAU_NAME,REGION_NO
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>左侧楼宇列表查询，已废弃</e:description>
  <e:case value="build_list_nouse">
    <e:q4l var="list">
      select b.* from(
      select distinct t.SEGM_ID,t.STAND_NAME,t.X,t.Y,a.latn_name,a.latn_id from ${gis_user}.TB_GIS_ADDR4_INFO t
      ,${gis_user}.TB_GIS_ADDR_INFO_ALL a
      where 1=1
      and a.SEGM_ID=t.SEGM_ID
      <e:if condition="${param.region_id !=''}">
        and a.region_no='${param.region_id}'
      </e:if>
      <e:if condition="${param.latn_id !=''}">
        and a.latn_id='${param.latn_id}'
      </e:if >
      <e:if condition="${!empty param.build_name}">
      	and t.STAND_NAME like '%${param.build_name}%'
      </e:if>
      ) b
      where rownum<=100
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>左侧楼宇列表查询，使用标准地址服务表</e:description>
  <e:case value="build_list">
  	<e:q4l var="list">
  		<e:if condition="${empty param.latn_id}" var="emptyCityId">
  			select b.* from(
		  		SELECT resid,resfullname,LATN_ID,LATN_NAME,row_number() over(order by resfullname) rn FROM sde.map_addr_segm_all where
		  			1=1
		  			<e:if condition="${param.region_id !=''}">
			        and union_org_code IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE bureau_no = '${param.region_id}')
			      </e:if>
			      <e:if condition="${param.substation !=''}">
			        and union_org_code = '${param.substation}'
			      </e:if>
			      <e:if condition="${param.grid_id !=''}">
			        and grid_id = '${param.grid_id}'
			      </e:if>
			      <e:if condition="${param.build_name !=''}">
			        and resfullname like '%'||'${param.build_name}'||'%'
			      </e:if>
		     )b
		    where rn>${param.page}*100 and rn <=${param.page+1}*100
  		</e:if>
  		<e:else condition="${emptyCityId}">
  			select b.* from(
		  		SELECT resid,resfullname,LATN_ID,LATN_NAME,row_number() over(order by resfullname) rn FROM sde.map_addr_segm_${param.latn_id} where
		  			1=1
		  			<e:if condition="${param.region_id !=''}">
			        and union_org_code IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE bureau_no = '${param.region_id}')
			      </e:if>
			      <e:if condition="${param.substation !=''}">
			        and union_org_code = '${param.substation}'
			      </e:if>
			      <e:if condition="${param.grid_id !=''}">
			        and grid_id = '${param.grid_id}'
			      </e:if>
			      <e:if condition="${param.build_name !=''}">
			        and resfullname like '%'||'${param.build_name}'||'%'
			      </e:if>
		     )b
		    where rn>${param.page}*100 and rn <=${param.page+1}*100
  		</e:else>
  	</e:q4l>
  	${e:java2json(list.list)}
  </e:case>

  <e:description>左侧楼宇数量查询，使用标准地址服务表</e:description>
  <e:case value="getBuildCount_buildList">
  	<e:q4o var="dataObject">
  		<e:if condition="${empty param.latn_id}" var="emptyCityId">
  			select sum(count) count from (
	  			SELECT count(1) count FROM sde.map_addr_segm_all where
		  			1=1
		  			<e:if condition="${!empty param.region_id && param.region_id !=''}">
			        and union_org_code IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE bureau_no = '${param.region_id}')
			      </e:if>
			      <e:if condition="${!empty param.substation && param.substation !=''}">
			        and union_org_code = '${param.substation}'
			      </e:if>
			      <e:if condition="${!empty param.grid_id && param.grid_id !=''}">
			        AND GRID_ID = '${param.grid_id}'
			      </e:if>
			      <e:if condition="${!empty param.build_name && param.build_name !=''}">
			        and resfullname like '%'||'${param.build_name}'||'%'
			      </e:if>
		    )
  		</e:if>
  		<e:else condition="${emptyCityId}">
  			SELECT count(1) count FROM sde.map_addr_segm_${param.latn_id} where
	  			1=1
	  			<e:if condition="${!empty param.region_id && param.region_id !=''}">
		        and union_org_code IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE bureau_no = '${param.region_id}')
		      </e:if>
		      <e:if condition="${!empty param.substation && param.substation !=''}">
		        and union_org_code = '${param.substation}'
		      </e:if>
		      <e:if condition="${!empty param.grid_id && param.grid_id !=''}">
		        AND GRID_ID = '${param.grid_id}'
		      </e:if>
		      <e:if condition="${!empty param.build_name && param.build_name !=''}">
		        and resfullname like '%'||'${param.build_name}'||'%'
		      </e:if>
  		</e:else>
  	</e:q4o>
  	${e:java2json(dataObject)}
  </e:case>
  <e:description>左侧楼宇数量查询，使用标准地址服务表，网格经理使用</e:description>
  <e:case value="getBuildCount_buildList_for_grid_user">
  	<e:q4o var="dataObject">
	  		SELECT count(1) count FROM sde.map_addr_segm_${param.latn_id} where
	  			1=1
	  			<e:if condition="${!empty param.region_id && param.region_id !=''}">
		        and union_org_code IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE bureau_no = '${param.region_id}')
		      </e:if>
		      <e:if condition="${!empty param.substation && param.substation !=''}">
		        and union_org_code = '${param.substation}'
		      </e:if>
		      <e:if condition="${!empty param.grid_id && param.grid_id !=''}">
		        AND GRID_ID = (SELECT grid_id FROM ${gis_user}.db_cde_grid WHERE grid_union_org_code = '${param.grid_id}')
		      </e:if>
		      <e:if condition="${!empty param.build_name && param.build_name !=''}">
		        and resfullname like '%'||'${param.build_name}'||'%'
		      </e:if>
  	</e:q4o>
  	${e:java2json(dataObject)}
  </e:case>

  <e:description>加载网格下的楼宇，网格经理使用</e:description>
  <e:case value="build_list_for_grid_user">
  		<e:q4l var="list">
      SELECT DISTINCT A.*, NVL(YX_ALL, 0) YX_ALL
			  FROM ((SELECT SEGM_ID,
			                STAND_NAME,
			                ZHU_HU_COUNT,
			                RES_ID_COUNT,
			                SY_RES_COUNT
			           FROM ${gis_user}.TB_GIS_ADDR_INFO_VIEW A
			          WHERE SEGM_ID IN (SELECT resid FROM (
			SELECT t.*,ROWNUM rn FROM (
			SELECT RESID, RESFULLNAME, LATN_ID, LATN_NAME
			  FROM SDE.MAP_ADDR_SEGM_${param.latn_id}
			 WHERE 1 = 1
			   <e:if condition="${param.region_id !=''}">
			    and union_org_code IN (SELECT union_org_code FROM ${gis_user}.db_cde_grid WHERE bureau_no = '${param.region_id}')
			  </e:if>
			  <e:if condition="${param.substation !=''}">
			    and union_org_code = '${param.substation}'
			  </e:if>
			  <e:if condition="${param.grid_id !=''}">
			    AND GRID_ID = (SELECT grid_id FROM ${gis_user}.db_cde_grid WHERE grid_union_org_code = '${param.grid_id}')
			  </e:if>
			  <e:if condition="${param.build_name !=''}">
			    and resfullname like '%'||'${param.build_name}'||'%'
				</e:if>
			 ORDER BY RESFULLNAME)t WHERE ROWNUM <= ${param.page+1}*100)WHERE rn > ${param.page}*100)) A LEFT JOIN
        ${gis_user}.VIEW_GIS_ADDR4_EXE C ON A.SEGM_ID = C.SEGM_ID)ORDER BY stand_name
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="setcitys">
    <e:q4l var="list">
      select distinct latn_name,latn_id,city_order_num from ${gis_user}.DB_CDE_GRID
      where latn_name is not null
      order by CITY_ORDER_NUM
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="setareas">
    <e:q4l var="list">
      select distinct BUREAU_NAME,BUREAU_NO,region_order_num  from ${gis_user}.DB_CDE_GRID
      where latn_name is not null
      <e:if condition="${param.latn_id !=null && param.latn_id!=''}">
        and latn_id = ${param.latn_id}
      </e:if>
      	AND branch_type IN ('a1','b1')
      order by region_order_num
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="setbranchs">
    <e:q4l var="list">
      select distinct BRANCH_NAME,UNION_ORG_CODE from ${gis_user}.DB_CDE_GRID
      where branch_name is not null
      <e:if condition="${param.id !=null && param.id!=''}">
        and BUREAU_no = ${param.id}
      </e:if>
      <e:if condition="${param.latn_id !=null && param.latn_id!=''}">
        and latn_id = ${param.latn_id}
      </e:if>
      <e:if condition="${param.branch_type !=null && param.branch_type!=''}">
        and branch_type = '${param.branch_type}'
      </e:if>
      and branch_type in ('a1','b1')
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="setgrids">
    <e:q4l var="list">
      select distinct GRID_NAME,GRID_ID,s.station_id,grid_zoom from ${gis_user}.DB_CDE_GRID,${gis_user}.SPC_BRANCH_STATION s
      where GRID_name is not null
      <e:if condition="${param.id !=null && param.id!=''}">
        and union_org_code = ${param.id}
      </e:if>
      <e:if condition="${param.latn_id !=null && param.latn_id!=''}">
        and latn_id = ${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no !=null && param.bureau_no!=''}">
        and bureau_no = ${param.bureau_no}
      </e:if>
      and branch_type in ('a1','b1') and grid_status=1
      and grid_union_org_code=s.station_no
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="b_city">
    <e:q4l var="list">
      select distinct LATN_NAME,LATN_ID from ${gis_user}.TB_GIS_ADDR_STREET
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="b_area">
    <e:q4l var="list">
      select distinct REGION_NO,REGION_NAME from ${gis_user}.TB_GIS_ADDR_STREET
      <e:if condition="${param.id !=null && param.id!=''}">
        where LATN_ID=${param.id}
      </e:if>
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="b_street">
    <e:q4l var="list">
      select distinct STREET_NAME,STREET_NO from ${gis_user}.TB_GIS_ADDR_STREET
      where REGION_NO='${param.id}'
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:case value="village_ding">
    <e:q4o var="list">
      select pos_x,pos_y,res_id from SDE.GIS_MAP_VILLAGE_INFO WHERE village_id = '${param.village_id}' and status = 1
    </e:q4o>
    ${e:java2json(list)}
  </e:case>
  <e:description>左侧营销列表查询，功能暂隐藏</e:description>
  <e:case value="yingxiao_list">
    <e:q4l var="list">
      SELECT
      YX_ID,
      YX_NAME,
      CREATE_DATE,
      CREATE_NAME,
      ROLE
      from
      SDE.TB_DIC_GIS_YX_DETAIL
      where
      CREATE_DATE>(LAST_DAY(ADD_MONTHS(SYSDATE, -2)) + 1)
      <e:if condition="${param.chaxun !=''}">
        and YX_NAME like '%'||'${param.chaxun}'||'%'
      </e:if >
      <e:if condition="${param.latn_id !=''||param.area_id != ''}">
        and YX_ID in (SELECT YX_ID from ${gis_user}.TB_DIC_GIS_YX_ADDRESS
        where ADDRESS_4_SEGM_ID in (
        SELECT SEGM_ID from ${gis_user}.TB_GIS_ADDR4_INFO t,${gis_user}.spc_region t1
        where t.region_id = t1.region_id
        <e:if condition="${param.latn_id !=''}">
          and t1.LATN_ID = '${param.latn_id}'
        </e:if >
        <e:if condition="${param.area_id !=''}">
          AND  t1.BUREAU_NO = '${param.area_id}'
        </e:if >
        ))
        <e:if condition="${!empty param.creater_id}">
          AND creater_id = '${param.creater_id}'
        </e:if >
      </e:if >
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>左侧小区区域营销结果的列表查询</e:description>
  <e:case value="yingxiao_list_for_village_page">
  	<e:q4l var="list">
  		SELECT * FROM (
				SELECT a.*,ROWNUM rn FROM (
				SELECT A.VILLAGE_ID,
				       A.VILLAGE_NAME,
				       A.LATN_ID,
				       A.BUREAU_NO,
				       A.UNION_ORG_CODE,
				       A.BRANCH_NAME,
				       A.GRID_ID,
				       A.GRID_UNION_ORG_CODE,
				       A.REPORT_TO_ID STATION_ID,
				       DECODE(A.GRID_ID, NULL, A.BRANCH_NAME, A.GRID_NAME) GRID_NAME,
				       A.GRID_ZOOM,
				       B.YX_ALL,
				       B.YX_UN,
				       B.YX_LV || '%' YX_LV
				  FROM ${gis_user}.VIEW_GIS_ALL_GRID_VILLAGE A,
				       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE  B
				 WHERE A.VILLAGE_ID = B.VILLAGE_ID
				   AND B.YX_ALL > 0
				<e:if condition="${param.latn_id != ''}">
				and a.latn_id = '${param.latn_id}'
				</e:if>
				<e:if condition="${param.bureau_no != ''}">
				and a.bureau_no = '${param.bureau_no}'
				</e:if>
				<e:if condition="${param.union_org_code != ''}">
				and a.union_org_code = '${param.union_org_code}'
				</e:if>
				<e:if condition="${param.grid_id != ''}">
				and (a.grid_id = '${param.grid_id}' or a.grid_union_org_code = '${param.grid_id}')
				</e:if>
				<e:if condition="${!empty param.village_name}">
				and a.village_name like '%${param.village_name}%'
				</e:if>
				 ORDER BY B.YX_ALL DESC) a
				 WHERE ROWNUM <= ${param.page+1}*100
				)WHERE rn > ${param.page}*100
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>支局、网格经理，左侧营销列表</e:description>
  <e:case value="yingxiao_list_for_village_for_grid_user">
  	<e:q4l var="list">
  		SELECT '0' VILLAGE_ID,
       '合计' VILLAGE_NAME,
       C.GRID_ID,
       C.BRANCH_NO UNION_ORG_CODE,
       D.BRANCH_NAME,
       D.GRID_NAME,
       E.STATION_ID,
       D.ZOOM,
       D.GRID_ZOOM,
       nvl(SUM(C.ZHU_HU_SUM),0) ZHU_HU_SUM,
       nvl(SUM(G.YX_ALL),0) YX_ALL,
       nvl(SUM(G.YX_DONE),0) YX_DONE,
       nvl(SUM(G.YX_UN),0) YX_UN,
       case when nvl(sum(G.YX_ALL),0)=0 THEN 0 ELSE ROUND(SUM(G.YX_DONE) / SUM(G.YX_ALL), 4)*100 END YX_LV
		  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO        C,
		       ${gis_user}.DB_CDE_GRID                     D,
		       ${gis_user}.SPC_BRANCH_STATION              E,
		       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE G
		 WHERE C.GRID_ID = E.STATION_ID
		   AND D.GRID_UNION_ORG_CODE = E.STATION_NO
		   AND C.VILLAGE_ID = G.VILLAGE_ID
		   AND C.VALI_FLAG = 1
		   AND G.YX_ALL > 0
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		 GROUP BY C.GRID_ID,
		          C.BRANCH_NO,
		          D.BRANCH_NAME,
		          D.GRID_NAME,
		          E.STATION_ID,
		          D.ZOOM,
		          D.GRID_ZOOM

		union

     	select c.village_id,
       c.village_name,
       c.grid_id,
       c.branch_no UNION_ORG_CODE,
       d.branch_name,
       d.grid_name,
       e.station_id,
       d.zoom,
       d.grid_zoom,
       c.zhu_hu_sum,
       g.yx_all,
       g.yx_done,
       g.yx_un,
       g.yx_lv
		  from ${gis_user}.tb_gis_village_edit_info        c,
		       ${gis_user}.db_cde_grid                     d,
		       ${gis_user}.spc_branch_station              e,
		       ${gis_user}.VIEW_GIS_VILLAGE_EXECUTE g
		 where c.grid_id = e.station_id
		   and d.grid_union_org_code = e.station_no
		   and c.village_id = g.village_Id
		   and c.vali_flag = 1
		   and g.yx_all > 0
		   <e:if condition="${param.latn_id != ''}">
		   	and d.latn_id = '${param.latn_id}'
		   </e:if>
		   <e:if condition="${param.bureau_no != ''}">
		   	and d.bureau_no = '${param.bureau_no}'
		   </e:if>
		   <e:if condition="${param.union_org_code != ''}">
		   	and d.union_org_code = '${param.union_org_code}'
		   </e:if>
		   and d.branch_type in ('a1', 'b1')
		   <e:if condition="${param.grid_id != ''}">
		   	and (d.grid_id = '${param.grid_id}' or d.grid_union_org_code = '${param.grid_id}')
		 	 </e:if>
		 	 <e:if condition="${!empty param.village_name}">
		 	 	and c.village_name like '%${param.village_name}%'
		 	 </e:if>
		 	 order by yx_all desc
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>营销新建时，展示四级地址列表，已废弃</e:description>
  <e:case value="yingxiao_list_2">
    <e:q4l var="list">
      select i.SEGM_ID,STAND_NAME,ZHU_HU_COUNT,PEOPLE_COUNT,KD_YX_COUNT,ITV_YX_COUNT,GU_YX_COUNT,res_id_count,sy_res_count,yd_count from ${gis_user}.TB_GIS_ADDR_INFO_VIEW v,${gis_user}.TB_GIS_ADDR4_INFO i where v.SEGM_ID=i.SEGM_ID and i.SEGM_ID in ${param.segmid}
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>营销新建时，展示四级地址列表，资源和营销在一个表格中，已废弃</e:description>
  <e:case value="yingxiao_new_add4_list">
    <e:q4l var="list">
      SELECT '0' SEGM_ID,
       '合计' SEGM_NAME,
       SUM(V.ZHU_HU_COUNT) ZHU_HU_COUNT,
       SUM(V.RES_ID_COUNT) RES_ID_COUNT,
       SUM(V.SY_RES_COUNT) SY_RES_COUNT,
       CASE
         WHEN SUM(V.RES_ID_COUNT) = 0 THEN
          0
         ELSE
          ROUND((SUM(V.RES_ID_COUNT) - SUM(V.SY_RES_COUNT)) /
                SUM(V.RES_ID_COUNT) * 100,
                2)
       END PORT_LV,
       SUM(V.KD_COUNT) KD_COUNT,
       SUM(V.ITV_COUNT) ITV_COUNT,
       SUM(V.GU_COUNT) GU_COUNT,
       SUM(V.YD_COUNT) YD_COUNT,
       nvl(SUM(BB.YX_ALL),0) YX_ALL,
       nvl(SUM(BB.YX_UN),0) YX_UN,
       nvl(SUM(BB.YX_DONE),0) YX_DONE,
       nvl(CASE
         WHEN SUM(BB.YX_ALL) = 0 THEN
          0
         ELSE
          ROUND((SUM(BB.YX_DONE) / SUM(BB.YX_ALL)), 2) * 100
       END,0) YX_LV

		  FROM ${gis_user}.TB_GIS_ADDR_INFO_VIEW V, ${gis_user}.TB_GIS_ADDR4_INFO I
		  LEFT JOIN ${gis_user}.VIEW_GIS_ADDR4_EXE BB
		    ON I.SEGM_ID = BB.SEGM_ID
		 WHERE V.SEGM_ID = I.SEGM_ID
		   AND I.SEGM_ID IN
		       ${param.segmid}
		   <e:if condition="${!empty param.segm_name}">
		 		and v.stand_name like '%${param.segm_name}%'
		 	 </e:if>
		UNION
		SELECT I.SEGM_ID,
		       V.STAND_NAME,
		       V.ZHU_HU_COUNT,
		       V.RES_ID_COUNT,
		       V.SY_RES_COUNT,
		       CASE
		         WHEN V.RES_ID_COUNT = 0 THEN
		          0
		         ELSE
		          ROUND((V.RES_ID_COUNT - V.SY_RES_COUNT) / V.RES_ID_COUNT, 2) * 100
		       END PORT_LV,
		       V.KD_COUNT,
		       V.ITV_COUNT,
		       V.GU_COUNT,
		       V.YD_COUNT,
		       nvl(BB.YX_ALL,0) YX_ALL,
		       nvl(BB.YX_UN,0) YX_UN,
		       nvl(BB.YX_DONE,0) YX_DONE,
		       nvl(CASE
		         WHEN BB.YX_ALL = 0 THEN
		          0
		         ELSE
		          ROUND(BB.YX_DONE / BB.YX_ALL, 2) * 100
		       END,0) YX_LV
		  FROM ${gis_user}.TB_GIS_ADDR_INFO_VIEW V, ${gis_user}.TB_GIS_ADDR4_INFO I
		  LEFT JOIN ${gis_user}.VIEW_GIS_ADDR4_EXE BB
		    ON I.SEGM_ID = BB.SEGM_ID
		 WHERE V.SEGM_ID = I.SEGM_ID
		   AND I.SEGM_ID IN
		       ${param.segmid}
		   <e:if condition="${!empty param.segm_name}">
		 		and v.stand_name like '%${param.segm_name}%'
		 	 </e:if>

    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

 	<e:description>营销新建时，展示四级地址列表，资源信息</e:description>
  <e:case value="yingxiao_new_build_list">
  	<e:q4l var="list">
	  	select '0' segm_id,
       '合计' segm_name,
       sum(v.ZHU_HU_COUNT) ZHU_HU_COUNT,
       sum(v.res_id_count) res_id_count,
       sum(v.sy_res_count) sy_res_count,
       case
         when sum(v.res_id_count) = 0 then
          0
         else
          round((sum(v.res_id_count) - sum(v.sy_res_count)) /
                sum(v.res_id_count),
                4) * 100
       end port_lv,
       sum(v.kd_count) kd_count,
       sum(v.itv_count) itv_count,
       sum(v.gu_count) gu_count,
       sum(v.yd_count) yd_count，
       case
       	when sum(v.ZHU_HU_COUNT) = 0 then 0 else
       	round((sum(v.kd_count)/sum(v.ZHU_HU_COUNT)),4)*100 end market_lv
		  from ${gis_user}.TB_GIS_ADDR_INFO_VIEW v, ${gis_user}.TB_GIS_ADDR4_INFO i
		 where v.SEGM_ID = i.SEGM_ID
		   and i.SEGM_ID in ${param.segmid}
		   <e:if condition="${!empty param.segm_name}">
		 	 		and v.stand_name like '%${param.segm_name}%'
		 	 </e:if>
		union
		select i.SEGM_ID,
		       v.STAND_NAME,
		       v.ZHU_HU_COUNT,
		       v.res_id_count,
		       v.sy_res_count,
		       case
		         when v.res_id_count = 0 then
		          0
		         else
		          round((v.res_id_count - v.sy_res_count) / v.res_id_count , 4)* 100
		       end port_lv,
		       v.kd_count,
		       v.itv_count,
		       v.gu_count,
		       v.yd_count,
		       case
		       	when v.ZHU_HU_COUNT = 0 then 0 else round((v.kd_count/v.ZHU_HU_COUNT),4)*100 end market_lv
		  from ${gis_user}.TB_GIS_ADDR_INFO_VIEW v, ${gis_user}.TB_GIS_ADDR4_INFO i
		 where v.SEGM_ID = i.SEGM_ID
		   and i.SEGM_ID in ${param.segmid}
		   <e:if condition="${!empty param.segm_name}">
		 	 		and v.stand_name like '%${param.segm_name}%'
		 	 </e:if>
		 group by i.SEGM_ID,
		          v.STAND_NAME,
		          v.ZHU_HU_COUNT,
		          v.res_id_count,
		          v.sy_res_count,
		          v.kd_count,
		          v.itv_count,
		          v.gu_count,
		          v.yd_count
		</e:q4l>
		${e:java2json(list.list)}
  </e:case>

  <e:description>营销新建时，展示四级地址列表，营销信息，功能暂停</e:description>
  <e:case value="yingxiao_new_yx_list">
  	<e:q4l var="list">
	  	select '0' segm_id,
       '合计' segm_name,
       		 nvl(sum(case
             when bb.prod_inst_id is not null then
              1
             else
              0
           end),0) yx_all,
           nvl(sum(case
                when bb.did_flag is not null then 1
                  else 0 end),0) yx_done,
           nvl(sum(case when bb.prod_inst_id is not null and bb.did_flag is null then 1 else 0 end),0) yx_un,
           case when nvl(sum(case when bb.prod_inst_id is not null then 1 else 0 end), 0)=0 then 0 else round(( nvl(sum(case when bb.did_flag is not null then 1 else 0 end), 0)/ nvl(sum(case when bb.prod_inst_id is not null then 1 else 0 end), 0) ),4)*100 end yx_lv
			  from ${gis_user}.TB_GIS_ADDR_INFO_VIEW v, ${gis_user}.TB_GIS_ADDR4_INFO i,${gis_user}.TB_GIS_BROADBD_YX_D bb
			 where v.SEGM_ID = i.SEGM_ID
			 and i.segm_id = bb.segm_id
			   and i.SEGM_ID in ${param.segmid}
			union
			select i.SEGM_ID,
			       v.STAND_NAME,
			       nvl(sum(case
			             when bb.prod_inst_id is not null then
			              1
			             else
			              0
			           end),0) yx_all,
	           nvl(sum(case
	                when bb.did_flag is not null then 1
	                  else 0 end),0) yx_done,
	           nvl(sum(case when bb.prod_inst_id is not null and bb.did_flag is null then 1 else 0 end),0) yx_un,
			       case when nvl(sum(case when bb.prod_inst_id is not null then 1 else 0 end),0)=0 then 0 else round(nvl(sum(case when bb.did_flag is not null then 1 else 0 end), 0)/ nvl(sum(case when bb.prod_inst_id is not null then 1 else 0 end),0),4)*100 end yx_lv
			  from ${gis_user}.TB_GIS_ADDR_INFO_VIEW v, ${gis_user}.TB_GIS_ADDR4_INFO i,
			  ${gis_user}.TB_GIS_BROADBD_YX_D bb
			 where v.SEGM_ID = i.SEGM_ID
			 and i.segm_id = bb.segm_id
			   and i.SEGM_ID in ${param.segmid}
			 group by i.SEGM_ID,
			          v.STAND_NAME,
			          v.ZHU_HU_COUNT,
			          v.res_id_count,
			          v.sy_res_count,
			          v.kd_count,
			          v.itv_count,
			          v.gu_count,
			          v.yd_count
		</e:q4l>
		${e:java2json(list.list)}
  </e:case>

  <e:description>旧的营销列表，已废弃</e:description>
  <e:case value="yingxiao_list_3_old">
    <e:q4l var="list">
      select a.yx_id yx_id,a.YX_NAME,ADDRESS_4_SEGM_ID,SEGM_NAME,ZHU_HU_COUNT,PEOPLE_COUNT,KD_YX,DX_YX,GU_YX ,CREATE_NAME,CREATE_DATE,ROLE,d.points,d.SELECT_TYPE,d.radius
      from ${gis_user}.TB_DIC_GIS_YX_ADDRESS a,sde.TB_DIC_GIS_YX_DETAIL d where a.YX_ID = '${param.yxid}' and a.YX_ID=d.YX_ID
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>获取营销的基本信息，包含其中楼宇的住户数，端口等，已废弃</e:description>
  <e:case value="yingxiao_list_3">
  	<e:q4l var="list">
  		select a.create_date,
       a.create_name,
       a.yx_name,
       c.address_4_segm_id,
       c.segm_name,
       c.zhu_hu_count,
       e.res_id_count,
       e.sy_res_count,
       t.did_flag,
       t.scene_type
		  from sde.TB_DIC_GIS_YX_DETAIL a,
		   ${gis_user}.TB_DIC_GIS_YX_ADDRESS c,
		   ${gis_user}.TB_GIS_ADDR_INFO_VIEW e,
		   ${gis_user}.TB_GIS_BROADBD_YX_D t
		 where a.yx_id = '${param.yxid}'
		 and a.yx_id = c.yx_id
		 and c.address_4_segm_id = e.segm_id
		 and e.segm_id = t.segm_id
  	</e:q4l>
  	${e:java2json(list.list)}
  </e:case>

  <e:description>营销保存，图形、关联的楼宇</e:description>
  <e:case value="yingxiao_add_1">
  	<e:q4o var="yx_id_new">
  			select to_char(sysdate,'yyyymmddhh24miss')||'${sessionScope.UserInfo.LOGIN_ID}' val from dual
  	</e:q4o>

    <e:update>
      begin
      insert into ${gis_user}.TB_DIC_GIS_YX_ADDRESS
      select '${yx_id_new.VAL}','${param.name}',i.SEGM_ID,STAND_NAME,ZHU_HU_COUNT,PEOPLE_COUNT,KD_YX_COUNT,ITV_YX_COUNT,GU_YX_COUNT from ${gis_user}.TB_GIS_ADDR_INFO_VIEW v,${gis_user}.TB_GIS_ADDR4_INFO i where v.SEGM_ID=i.SEGM_ID and i.SEGM_ID in ${param.segmid};

      insert into SDE.TB_DIC_GIS_YX_DETAIL
      (esri_oid,object_type,YX_ID,YX_NAME,CREATE_DATE,CREATE_NAME,CREATER_ID,ROLE,SELECT_TYPE,POINTS,RADIUS)
      values
      (sde.VILLAGE_SEQ.nextVal,sde.st_polyfromtext('${param.wktstr}', 4326),'${yx_id_new.VAL}','${param.name}',sysdate,'${sessionScope.UserInfo.USER_NAME}','${sessionScope.UserInfo.LOGIN_ID}','支局长','${param.type_xy}',
      <e:if condition="${param.type_xy =='0'}">
        ${param.x} || ',' || ${param.y},${param.radius}
      </e:if >
      <e:if condition="${param.type_xy =='1'}">
        ${param.xmin} || ',' || ${param.ymin} || ',' || ${param.xmax} || ',' || ${param.ymax},null
      </e:if >
      <e:if condition="${param.type_xy =='2'}">
        ${param.points},null
      </e:if >
      );
      end;
    </e:update>
  </e:case>
  <e:description>营销图形获取</e:description>
  <e:case value="yx_detail_query">
    <e:q4l var="list">
      SELECT h.yx_id,h.yx_name,h.select_type,sde.st_astext(h.object_type) as geoshpe FROM SDE.tb_dic_gis_yx_detail h where h.yx_name is not null and H.YX_ID = '${param.yxid}'
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:case value="village_view_build_detail_query_list">
    <e:q4l var="list">
				select
							 '0' segm_id,
               '合计' stand_name,
               nvl(sum(t3.zhu_hu_count), -1) zhu_hu_count,
               -1 port_count,
               -1 port_free_count,
               nvl(sum(t3.kd_count), -1) kd_count,
               nvl(sum(t3.itv_count), -1) itv_count,
               nvl(sum(t3.gu_count), -1) gu_count
          from ${gis_user}.TB_GIS_VILLAGE_ADDR4 t2
          left join ${gis_user}.TB_GIS_ADDR_INFO_VIEW t3
            on t2.segm_id = t3.segm_id
         where t2.village_id = '${param.yxid}'
         <e:if condition="${!empty param.standard_name && param.standard_name ne ''}">
         		and t2.stand_name like '%${param.standard_name}%'
         </e:if>
				union
				 select t2.segm_id,
               t2.stand_name,
               nvl(t3.zhu_hu_count, -1) zhu_hu_count,
               nvl(t3.res_id_count, -1) port_count,
               nvl(t3.sy_res_count, -1) port_free_count,
               nvl(t3.kd_count, -1) kd_count,
               nvl(t3.itv_count, -1) itv_count,
               nvl(t3.gu_count, -1) gu_count
          from ${gis_user}.TB_GIS_VILLAGE_ADDR4 t2
          left join ${gis_user}.TB_GIS_ADDR_INFO_VIEW t3
            on t2.segm_id = t3.segm_id
         where t2.village_id = '${param.yxid}'
         <e:if condition="${!empty param.standard_name && param.standard_name ne ''}">
         		and t2.stand_name like '%${param.standard_name}%'
         </e:if>
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>

  <e:description>营销查看窗口，概况</e:description>
  <e:case value="yx_view_query_sum">
  	<e:q4o var="dataObject">
			select a.yx_id,
       a.yx_name,
       a.create_name,
       to_char(a.create_date, 'yyyy"年"MM"月"dd"日"') create_date,
       sum(d.yd_count) yd_count,
       sum(d.kd_count) kd_count,
       sum(d.itv_count) itv_count,
       sum(d.zhu_hu_count) zhu_hu_count,
       sum(1) build_count,
       case
         when sum(d.kd_count) = 0 then
          0
         else
          round(sum(d.kd_count) / sum(d.zhu_hu_count)* 100, 2)
       end market_lv,
       sum(d.res_id_count) port_all,
       sum(d.sy_res_count) port_free,
       case
         when sum(d.res_id_count) = 0 then
          0
         else
          round((sum(d.res_id_count) - sum(d.sy_res_count)) /
                sum(d.res_id_count)* 100,
                2)
       end port_lv
		  from sde.TB_DIC_GIS_YX_DETAIL       a,
		       ${gis_user}.TB_DIC_GIS_YX_ADDRESS c,
		       ${gis_user}.TB_GIS_ADDR_INFO_VIEW d
		 where a.yx_id = c.yx_id
		   and c.address_4_segm_id = d.segm_id
		   and a.yx_id = '${param.yxid}'
		 group by a.yx_id,
		          a.yx_name,
		          a.create_name,
		          to_char(a.create_date, 'yyyy"年"MM"月"dd"日"')
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>
  <e:description>营销查看窗口，营销详表，功能暂停</e:description>
  <e:case value="yx_view_query_list">
    <e:q4l var="dataList">
     select '0' segm_id,
       '合计' segm_name,
       sum(d.zhu_hu_count) zhu_hu_count,
       sum(d.sy_res_count) port_free,
       sum(d.res_id_count) port_all,
       sum(d.kd_count) kd_count,
       sum(d.itv_count) itv_count,
       sum(d.gu_count) gu_count,
       sum(case when e.prod_inst_id is not null then 1 else 0 end) yx_all,
       sum(case when e.prod_inst_id is not null and e.did_flag is null then 1 else 0 end) yx_un,
       sum(case when e.did_flag is not null then 1 else 0 end) yx_done,
       case when sum(case when e.prod_inst_id is not null then 1 else 0 end) = 0 then 0
       			else round(sum(case when e.did_flag is not null then 1 else 0 end)/sum(case when e.prod_inst_id is not null then 1 else 0 end),4)*100 end yx_lv
			  from sde.TB_DIC_GIS_YX_DETAIL a, ${gis_user}.TB_DIC_GIS_YX_ADDRESS c
			  left join ${gis_user}.TB_GIS_BROADBD_YX_D e
			    on c.address_4_segm_id = e.segm_id, ${gis_user}.TB_GIS_ADDR_INFO_VIEW d
			 where a.yx_id = c.yx_id
			   and c.address_4_segm_id = d.segm_id
			   and a.yx_id = '${param.yxid}'
			   <e:if condition="${!empty param.standard_name}">
			   	and c.segm_name like '%${param.standard_name}%'
			   </e:if>

			 group by a.yx_id,
			          a.yx_name,
			          a.create_name,
			          to_char(a.create_date, 'yyyy"年"MM"月"dd"日"')

			union

			select c.address_4_segm_id segm_id,
			       c.segm_name,
			       sum(d.zhu_hu_count) zhu_hu_count,
			       sum(d.sy_res_count) port_free,
			       sum(d.res_id_count) port_all,
			       sum(d.kd_count) kd_count,
			       sum(d.itv_count) itv_count,
			       sum(d.gu_count) gu_count,
			       sum(case when e.prod_inst_id is not null then 1 else 0 end) yx_all,
       sum(case when e.prod_inst_id is not null and e.did_flag is null then 1 else 0 end) yx_un,
       sum(case when e.did_flag is not null then 1 else 0 end) yx_done,
       case when sum(case when e.prod_inst_id is not null then 1 else 0 end) = 0 then 0
       			else round(sum(case when e.did_flag is not null then 1 else 0 end)/sum(case when e.prod_inst_id is not null then 1 else 0 end),4)*100 end yx_lv
			  from sde.TB_DIC_GIS_YX_DETAIL a, ${gis_user}.TB_DIC_GIS_YX_ADDRESS c
			  left join ${gis_user}.TB_GIS_BROADBD_YX_D e
			    on c.address_4_segm_id = e.segm_id, ${gis_user}.TB_GIS_ADDR_INFO_VIEW d
			 where a.yx_id = c.yx_id
			   and c.address_4_segm_id = d.segm_id
			   and a.yx_id = '${param.yxid}'
			   <e:if condition="${!empty param.standard_name}">
			   	and c.segm_name like '%${param.standard_name}%'
			   </e:if>
			 group by c.address_4_segm_id, c.segm_name
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:description>小区查看 营销列表 已住户为单位统计</e:description>
  <e:case value="yx_detail_query_list">
    <e:q4l var="list">
				SELECT
			       '0' segm_id,
			       '合计' stand_name,
			       SUM(C.YX_ALL) YX_ALL,
			       SUM(C.YX_DONE) YX_DONE,
			       SUM(C.YX_UN) YX_UN,
			       CASE
			         WHEN NVL(SUM(C.YX_ALL), 0) = 0 THEN
			          0
			         ELSE
			          ROUND(SUM(C.YX_DONE) / SUM(C.YX_ALL), 4) * 100
			       END YX_LV,
			       SUM(C.DX_COUNT) DX_COUNT
			  FROM ${gis_user}.VIEW_GIS_VILLAGE_ADDR4_EXE C,
			       ${gis_user}.TB_GIS_ADDR_INFO_VIEW      E
			 WHERE C.SEGM_ID = E.SEGM_ID(+)
			   AND VILLAGE_ID = '${param.yxid}'
			   <e:if condition="${!empty param.standard_name}">
			       AND E.STAND_NAME LIKE '%${param.standard_name}%'
			   </e:if>
			 GROUP BY VILLAGE_ID
			UNION ALL
			SELECT
			       c.segm_id,
			       E.STAND_NAME,
			       C.YX_ALL,
			       C.YX_DONE,
			       C.YX_UN,
			       C.YX_LV,
			       C.DX_COUNT
			  FROM ${gis_user}.VIEW_GIS_VILLAGE_ADDR4_EXE C,
			       ${gis_user}.TB_GIS_ADDR_INFO_VIEW      E
			 WHERE C.SEGM_ID = E.SEGM_ID(+)
			   AND C.VILLAGE_ID = '${param.yxid}'
			   <e:if condition="${!empty param.standard_name}">
			      AND E.STAND_NAME LIKE '%${param.standard_name}%'
			   </e:if>
			   		AND C.YX_ALL > 0
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>小区查看 营销列表 以产品为主统计 已废弃</e:description>
  <e:case value="yx_detail_query_list_nouse_bak">
    <e:q4l var="list">
				select
							 '0' segm_id,
               '合计' stand_name,
               nvl(sum(t4.yx_all), 0) yx_all,
               nvl(sum(t4.yx_done), 0) yx_done,
               nvl(sum(t4.yx_un), 0) yx_un,
               case
                 when nvl(sum(t4.yx_all), 0) = 0 then
                  -1
                 else
                  round(nvl(sum(yx_done), 0) / sum(t4.yx_all), 4)*100
               end yx_lv
          from ${gis_user}.TB_GIS_VILLAGE_ADDR4 t2,
          (select t.segm_id,
                           count(distinct t.prod_inst_id) yx_all,
                           count(distinct case when prod_inst_id is not null and did_flag is null then prod_inst_id end) yx_un,
                           count(distinct case when did_flag is not null then prod_inst_id end) yx_done
                      from ${gis_user}.TB_GIS_BROADBD_YX_D t
                     group by t.segm_id) t4
            where t2.segm_id = t4.segm_id
         		and t2.village_id = '${param.yxid}'
         <e:if condition="${!empty param.standard_name}">
         		and t2.stand_name like '%${param.standard_name}%'
         </e:if>
				union
				 select t2.segm_id,
               t2.stand_name,
               nvl(t4.yx_all, 0) yx_all,
               nvl(t4.yx_done, 0) yx_done,
               nvl(t4.yx_un, 0) yx_un,
               case
                 when nvl(t4.yx_all, 0) = 0 then
                  -1
                 else
                  round(yx_done / t4.yx_all*100, 1)
               end yx_lv
          from ${gis_user}.TB_GIS_VILLAGE_ADDR4 t2,
          (select t.segm_id,
                           count(distinct t.prod_inst_id) yx_all,
                           count(distinct case when prod_inst_id is not null and did_flag is null then prod_inst_id end) yx_un,
                           count(distinct case when did_flag is not null then prod_inst_id end) yx_done
                      from ${gis_user}.TB_GIS_BROADBD_YX_D t
                     group by t.segm_id) t4
            where t2.segm_id = t4.segm_id
         		and t2.village_id = '${param.yxid}'
         <e:if condition="${!empty param.standard_name}">
         		and t2.stand_name like '%${param.standard_name}%'
         </e:if>
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>小区查看，汇总信息</e:description>
  <e:description>小区基本信息，2.0gis中已废弃</e:description>
  <e:case value="yx_detail_query_sum">
    <e:q4o var="dataObj">
     select t1.village_id v_id,
       t1.village_name v_name,
       t1.branch_no v_sub_id,
       t1.branch_name v_sub_name,
       t1.grid_id v_grid_Id,
       nvl(case when t1.grid_name = '全部' then ' ' else t1.grid_name end,' ') v_grid_name,
       nvl(t2.user_name,' ') creator_name,
       to_char(t1.create_time, 'yyyy-mm-dd') create_time,
       nvl(ctcc_mobile_user_num,0) yd_sum,
       nvl(wideband_num,0) kd_sum,
       nvl(tv_user_num,0) ds_sum,
       nvl(build_sum,0) build_sum,
       nvl(zhu_hu_sum,0) zhu_hu_sum,
       nvl(real_home_num,0) real_zhu_hu_sum,
       nvl(people_num,0) people_num,
       nvl(case
         when zhu_hu_sum = 0 then
          -1
         else
          round(nvl(wideband_num, 0) / zhu_hu_sum* 100, 1)
       end,0) market_lv,
       nvl(t1.port_sum,0) PORT_SUM,
       nvl(t1.port_used_sum,0) PORT_USED_SUM,
       nvl(t1.port_free_sum,0) PORT_FREE_SUM,
       NVL(CASE
             WHEN T1.PORT_SUM = 0 THEN
              -1
             ELSE
              ROUND(NVL(T1.PORT_USED_SUM, 0) / T1.PORT_SUM * 100, 1)
           END,
           0) PORT_LV,
       is_sole,
       nvl(cmcc_num,0) ydyd_sum,
       nvl(cm_wideband_num,0) ydkd_sum,
       nvl(cmcc_tv_user_num,0) ydds_sum,
       nvl(cucc_num,0) ltyd_sum,
       nvl(cu_wideband_num,0) ltkd_sum,
       nvl(cucc_tv_num,0) ltds_sum,
       nvl(sarft_wideband_num,0) gdkd_sum,
       nvl(sarft_tv_num,0) gdds_sum,
       nvl(cm_optical_fiber,0) cm_optical_fiber,
	   nvl(cu_optical_fiber,0) cu_optical_fiber,
	   nvl(sarft_optical_fiber,0) sarft_optical_fiber,
	   nvl(wideband_in,0) wideband_in,
	   CASE WHEN nvl(people_num,0)=0 THEN -1 ELSE round(ctcc_mobile_user_num/people_num,4)*100 END yd_lv,
	   CASE WHEN NVL(zhu_hu_sum,0)=0 THEN -1 ELSE ROUND(wideband_num/zhu_hu_sum,4 )*100 END kd_lv,
	   CASE WHEN NVL(zhu_hu_sum,0)=0 THEN -1 ELSE ROUND(tv_user_num/zhu_hu_sum,4)*100 END ds_lv
  from ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO t1 left join e_user t2
		  on t1.creater = t2.login_id
		 where t1.village_id = '${param.yxid}'
		 	and t1.vali_flag = 1
    </e:q4o>
    ${e:java2json(dataObj)}
  </e:case>

  <e:description>小区基本信息，新小区视图</e:description>
  <e:case value="getVillageBaseInfo">
  	<e:q4o var="dataObject">
  		select
			 <e:description>基础</e:description>
       t1.village_id v_id,
       t1.village_name v_name,
       t1.branch_no v_sub_id,
       t1.branch_name v_sub_name,
       t1.grid_id v_grid_Id,
       nvl(case when t1.grid_name = '全部' then ' ' else t1.grid_name end,' ') v_grid_name,
       nvl(t2.user_name,' ') creator_name,
       to_char(t1.create_time, 'yyyy-mm-dd') create_time,
       case when village_create_time is null then ' ' else to_char(village_create_time,'yyyy-mm-dd') end gua_ce_time,
       <e:description>市场</e:description>
       DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100, 'FM99990.00') || '%') MARKET_RATE,
       DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', 0, ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100) MARKET_RATE1,
       nvl(zhu_hu_count,0) zhu_hu_count,
       NVL(GZ_ZHU_HU_COUNT,0) GZ_ZHU_HU_SHU,
       nvl(GZ_H_USE_CNT,0) GZ_H_USE_CNT,
       nvl(gov_zhu_hu_count,0) gov_zhu_hu_count,
       nvl(ly_cnt,0) ly_cnt,
       nvl(h_use_cnt,0) h_use_cnt,
       nvl(gov_h_use_cnt,0) gov_h_use_cnt ,
       nvl(no_res_arrive_cnt,0) no_res_arrive_cnt ,
       nvl(ly_cnt,0) - nvl(no_res_arrive_cnt,0) res_arrived_cnt,
       DECODE(NVL(LY_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND((NVL(LY_CNT, 0) - NVL(NO_RES_ARRIVE_CNT, 0)) / LY_CNT, 4) * 100, 'FM999999990.00') || '%') RESOUCE_RATE,
       case when NVL(LY_CNT, 0)= 0 then 0 else ROUND((NVL(LY_CNT, 0) - NVL(NO_RES_ARRIVE_CNT, 0)) / LY_CNT, 4) * 100 end RESOUCE_RATE1,
       <e:description>资源</e:description>
       DECODE(NVL(port_id_cnt , '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(use_port_cnt , 0) / port_id_cnt , 4) * 100, 'FM9999999990.00') || '%') port_lv,
       case when NVL(port_id_cnt , '0') = '0' then 0 else ROUND(NVL(use_port_cnt , 0) / port_id_cnt , 4) * 100 end port_lv1,
       nvl(port_id_cnt,0) port_id_cnt,
       nvl(use_port_cnt,0) use_port_cnt,
       nvl(obd_cnt,0) obd_cnt,
       nvl(zero_obd_cnt,0) zero_obd_cnt,
       nvl(kong_port_cnt,0) kong_port_cnt,
			 nvl(first_obd_cnt,0) first_obd_cnt,
       nvl(high_use_obd_cnt,0) high_use_obd_cnt,
       <e:description>收集</e:description>
       decode(nvl(village_ru_rate,0),0,'--',1,'80%以上',2,'60-80%',3,'40-60%',4,'40%以下') village_ru_rate ,
       decode(t1.village_gm ,1,'小规模',2,'中规模',3,'大规模',' ') village_gm,
       decode(t1.village_xf ,1,'低档',2,'中档',3,'高档',0,'城中村','--') village_xf ,
       decode(nvl(village_label,'0'),'0','--','1','--','2','--',village_label) village_label,
       t1.village_label_flg,
       DECODE(t1.village_value,1,'公众',2,'政企',' ') village_value,
       nvl(wideband_in,0) wideband_in,
       nvl(cm_optical_fiber,0)  cm_optical_fiber,
       nvl(cu_optical_fiber,0)  cu_optical_fiber,
       nvl(sarft_optical_fiber,0)  sarft_optical_fiber,
       nvl(other_optical_fiber,0)  other_optical_fiber,
       nvl(should_collect_cnt,0) should_collect_cnt,
       nvl(already_collect_cnt,0) already_collect_cnt,
       CASE WHEN NVL(should_collect_cnt,0)=0 THEN '0.00%' ELSE to_char(ROUND(nvl(already_collect_cnt,0)/nvl(should_collect_cnt,0),4)*100,'FM9999999990.00') || '%' END collect_lv,
       CASE WHEN nvl(cc.arrive_cnt,0) = 0 then '0.00%' else TO_CHAR(round(nvl(cc.cm_cnt + cc.remove_cnt + cc.owe_cnt + cc.stop_cnt,0) /cc.arrive_cnt,4)*100,'FM9999999990.00') || '%' end COMPETE_PERCENT,
       CASE WHEN nvl(cc.arrive_cnt,0) = 0 then 0 else round(nvl(cc.cm_cnt + cc.remove_cnt + cc.owe_cnt + cc.stop_cnt,0) /cc.arrive_cnt,4)*100 end COMPETE_PERCENT1,
       nvl(cc.gz_h_d_user_cnt,0) gz_h_d_user_cnt,
       nvl(cc.gz_h_r_user_cnt,0) gz_h_r_user_cnt,
       case when nvl(gz_h_zhu_hu_shu,0) = 0 THEN '0.00' ELSE to_char(ROUND(nvl(charge,0)/arrive_cnt ,4),'FM9999999990.00') END arpu_hu,
       to_char(round(nvl(charge,0)/10000,2),'FM9999999990.00')||'万' arpu_month,
       CASE WHEN nvl(gz_h_d_zhu_hu_shu,0) = 0 THEN '0.00' ELSE to_char(ROUND(nvl(d_charge,0)/gz_h_d_user_cnt ,4),'FM9999999990.00') END dk_arpu,
			 CASE WHEN nvl(gz_h_r_zhu_hu_shu ,0) = 0 THEN '0.00' ELSE to_char(ROUND(nvl(r_charge ,0)/gz_h_r_user_cnt  ,4),'FM9999999990.00') END rh_arpu
		  from ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO t1 LEFT JOIN ${gis_user}.tb_gis_res_info_day t3 ON t1.village_id = t3.latn_id
		   left join ${gis_user}.TB_DW_GIS_SCENE_USER_M cc
		   		on t1.village_id=cc.latn_id
		   		and cc.acct_month = '${param.acct_month}'
		   left join e_user t2
		      on t1.creater = t2.login_id
		     where t1.village_id = '${param.village_id}'
		       and t1.vali_flag = 1
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>获取小区下的楼宇列表</e:description>
  <e:case value="getBuildInVillageList">
  	<e:q4l var="dataList">
				SELECT '0' SEGM_ID,
				       '合计' STAND_NAME,
				       SUM(nvl(zhu_hu_count ,0)) zhu_hu_count,
				       SUM(NVL(gz_h_use_cnt,0 )) gz_h_use_cnt ,
				       sum(nvl(already_collect_cnt ,0)) already_collect_cnt,
				       DECODE(sum(NVL(port_id_cnt , '0')), '0', ' ', TO_CHAR(ROUND(sum(NVL(use_port_cnt , 0)) / sum(nvl(port_id_cnt,0)) , 4) * 100, 'FM9999999990.00') || '%') port_lv,
				       sum(nvl(kong_port_cnt ,0)) kong_port_cnt
				  FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 T2
				  LEFT JOIN ${gis_user}.Tb_Gis_Res_Info_Day T3
				    ON T2.SEGM_ID = T3.latn_id
				 WHERE T2.VILLAGE_ID = '${param.village_id}'
				 <e:if condition="${!empty param.standard_name && param.standard_name ne ''}">
				 AND t2.segm_name LIKE '%${param.standard_name}%'
				 </e:if>
				UNION
				SELECT T2.SEGM_ID,
				       T2.STAND_NAME,
				       nvl(t3.zhu_hu_count,0) zhu_hu_count,
				       NVL(t3.gz_h_use_cnt,0) gz_h_use_cnt,
				       NVL(t3.already_collect_cnt,0) already_collect_cnt,
				       DECODE(NVL(port_id_cnt , '0'), '0', ' ', TO_CHAR(ROUND(NVL(use_port_cnt , 0) / nvl(port_id_cnt,0) , 4) * 100, 'FM9999999990.00') || '%') port_lv,
				       nvl(kong_port_cnt ,0) kong_port_cnt
				  FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 T2
				  LEFT JOIN ${gis_user}.Tb_Gis_Res_Info_Day T3
				    ON T2.SEGM_ID = T3.latn_id
				 WHERE T2.VILLAGE_ID = '${param.village_id}'
				 <e:if condition="${!empty param.standard_name && param.standard_name ne ''}">
				 AND t2.segm_name LIKE '%${param.standard_name}%'
				 </e:if>
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>小区营销、楼宇营销 begin</e:description>
  <e:description>支局长、网格经理营销清单 begin</e:description>
  <e:description>营销清单列表</e:description>
   <e:case value="yx_detail_query_list_six">
    <e:q4l var="list">
    	SELECT m.* FROM (
	    	select t1.*,t2.segm_name_2,
	    			 case when t3.contact_person is null then t2.user_contact_person else t3.contact_person end contact_person,
					 <e:description>2018.10.22 号码脱敏</e:description>
					 case when t3.contact_nbr is null then (substr(t2.user_contact_nbr,0,3) || '******' || substr(t2.user_contact_nbr,10,2)) else substr(t3.contact_nbr,0,3) || '******' || substr(t3.contact_nbr,10,2) end contact_iphone,
	      	 		 ROW_NUMBER() OVER(ORDER BY t1.SEGM_ID asc) rn
	    	 from (
		      select t.SEGM_ID,
		       t.stand_name_2,
		       t.address_id,
		       t.acc_nbr,
		       t.PROD_INST_ID,
		       t.did_flag,
		       t.conn_str
				  from ${gis_user}.TB_GIS_BROADBD_YX_D t
				 where 1 = 1 and  t.secen_type in('04','21','10','11')
		        <e:if condition='${param.segmid ne "0"}'>
		        	and t.SEGM_ID='${param.segmid}'
		        </e:if>
		        <e:description>网格</e:description>
		        <e:if condition='${param.segmid eq "0" && !empty param.grid_id}'>
	        		and t.SEGM_ID in (
		        		select segm_id from ${gis_user}.tb_gis_village_addr4 where village_id in (
		        			SELECT village_id FROM ${gis_user}.tb_gis_village_edit_info WHERE grid_id = '${param.grid_id}'
		        		)
		        	)
		        </e:if>
		        <e:description>支局</e:description>
		        <e:if condition='${param.segmid eq "0" && !empty param.substation  && param.user_level eq "4"}'>
		        	and t.SEGM_ID in (
		        		select segm_id from ${gis_user}.tb_gis_village_addr4 where village_id in (
		        			SELECT village_id FROM ${gis_user}.tb_gis_village_edit_info WHERE branch_no = '${param.substation}'
		        		)
		        	)
		        </e:if>
		        <e:description>小区</e:description>
		        <e:if condition='${param.segmid eq "0" && !empty param.v_id}'>
		        	and t.SEGM_ID in (select segm_id from ${gis_user}.tb_gis_village_addr4 where village_id = '${param.v_id}')
		        </e:if>
		        <e:if condition='${param.segmid eq "0" && !empty param.yx_id}'>
		        	and t.SEGM_ID in (select address_4_segm_Id from ${gis_user}.TB_DIC_GIS_YX_ADDRESS t where yx_id = '${param.yx_id}')
		        </e:if>
		        <e:description>营销场景</e:description>
		        <e:if condition='${!empty param.type && param.type ne "0"}'>
		        	and t.secen_type = '${param.type}'
		        </e:if>
		        <e:description>执行状态</e:description>
		        <e:if condition='${param.did_flag eq "1"}'>
		        	and t.did_flag is not null
		        </e:if>
		        <e:if condition='${param.did_flag eq "0"}'>
		        	and t.did_flag is null
		        </e:if>
		        <e:description>四级地址</e:description>
		        <e:if condition='${!empty param.address_id}'>
		        	and address_id = '${param.address_id}'
		        </e:if>
		        <e:description>关键字</e:description>
		        <e:if condition='${!empty param.keyword}'>
		        	and (acc_nbr LIKE '%' || '${param.keyword}' ||'%' OR t.contract_person LIKE '%' || '${param.keyword}' ||'%' OR t.contract_iphone LIKE '%' || '${param.keyword}' ||'%' OR t.STAND_NAME_2 LIKE '%' || '${param.keyword}')
		        </e:if>
		       )t1,
		       ${gis_user}.TB_GIS_ADDR_INFO_ALL t2,
		       ${gis_user}.TB_GIS_ADDR_OTHER_ALL t3
					where t1.address_Id = t2.segm_id_2
					and t2.segm_id_2 = t3.segm_id_2
					order by did_flag desc,length(t2.segm_name_2),t2.segm_name_2
				)m
				<e:if condition="${!empty param.page}">
					WHERE m.rn>${param.page}*100 AND m.rn<=${param.page+1}*100
				</e:if>
	    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
  <e:description>小区营销、楼宇营销 end</e:description>

  <e:description>营销清单数量</e:description>
  <e:case value="yx_detail_query_count_six">
  	<e:q4o var="dataObject">
	     select count(1) count from
	      (select DISTINCT t.ADDRESS_ID
			  from ${gis_user}.TB_GIS_BROADBD_YX_D t
			 where 1 = 1 and  t.secen_type in('04','21','10','11')
	        <e:if condition='${param.segmid ne "0"}'>
	        	and t.SEGM_ID='${param.segmid}'
	        </e:if>
	        <e:description>网格</e:description>
	        <e:if condition='${param.segmid eq "0" && !empty param.grid_id}'>
        		and t.SEGM_ID in (
	        		select segm_id from ${gis_user}.tb_gis_village_addr4 where village_id in (
	        			SELECT village_id FROM ${gis_user}.tb_gis_village_edit_info WHERE grid_id = '${param.grid_id}'
	        		)
	        	)
		      </e:if>
	        <e:description>支局</e:description>
	        <e:if condition='${param.segmid eq "0" && !empty param.substation && param.user_level eq "4"}'>
	        	and t.SEGM_ID in (
	        		select segm_id from ${gis_user}.tb_gis_village_addr4 where village_id in (
	        			SELECT village_id FROM ${gis_user}.tb_gis_village_edit_info WHERE branch_no = '${param.substation}'
	        		)
	        	)
	        </e:if>
	        <e:description>小区</e:description>
	        <e:if condition='${param.segmid eq "0" && !empty param.v_id}'>
	        	and t.SEGM_ID in (select segm_id from ${gis_user}.tb_gis_village_addr4 where village_id = '${param.v_id}')
	        </e:if>
	        <e:if condition='${param.segmid eq "0" && !empty param.yx_id}'>
	        	and t.SEGM_ID in (select address_4_segm_Id from ${gis_user}.TB_DIC_GIS_YX_ADDRESS t where yx_id = '${param.yx_id}')
	        </e:if>
	        <e:description>营销场景</e:description>
	        <e:if condition='${!empty param.type && param.type ne "0"}'>
	        	and t.secen_type = '${param.type}'
	        </e:if>
	        <e:description>执行状态</e:description>
	        <e:if condition='${param.did_flag eq "1"}'>
	        	and t.did_flag is not null
	        </e:if>
	        <e:if condition='${param.did_flag eq "0"}'>
	        	and t.did_flag is null
	        </e:if>
	        <e:description>四级地址</e:description>
	        <e:if condition='${!empty param.address_id}'>
	        	and address_id = '${param.address_id}'
	        </e:if>
	        <e:description>关键字</e:description>
	        <e:if condition='${!empty param.keyword}'>
	        	and (acc_nbr LIKE '%' || '${param.keyword}' ||'%' OR t.contract_person LIKE '%' || '${param.keyword}' ||'%' OR t.contract_iphone LIKE '%' || '${param.keyword}' ||'%' OR t.STAND_NAME_2 LIKE '%' || '${param.keyword}')
	        </e:if>
	       )t1,
	       ${gis_user}.TB_GIS_ADDR_INFO_ALL t2,
	       ${gis_user}.TB_GIS_ADDR_OTHER_ALL t3
				where t1.address_Id = t2.segm_id_2
				and t2.segm_id_2 = t3.segm_id_2
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:description>支局长、网格经理营销清单 end</e:description>


  <e:description>查询住户的营销资料</e:description>
  <e:case value="yx_detail_query_list_six_add6">
  	<e:q4l var="list">
  		SELECT *
			  FROM ((SELECT T2.SEGM_ID,
			                T2.SEGM_TYPE,
			                T2.SEGM_NAME,
			                T2.STAND_NAME_1,
			                T2.SEGM_NAME_1,
			                T2.SEGM_ID_2,
			                T2.SEGM_NAME_2,
			                T2.STAND_NAME_2,
			                T2.REGION_ID,
			                T2.REGION_NO,
			                T2.REGION_NAME,
			                T2.ALIAS,
			                T2.LATN_ID,
			                T2.LATN_NAME,
			                T2.BUREAU_NO,
			                T2.BUREAU_NAME,
			                T2.RES_ID_COUNT,
			                T2.USE_PORT_COUNT,
			                T2.IS_GU,
			                T2.IS_YD,
			                T2.IS_KD,
			                T2.IS_ITV,
			                T2.BN_COUNT,
			                T2.BN_COUNT_ZX,
			                T2.HY_COUNT,
			                T2.HY_COUNT_ZX,
			                T2.QF_COUNT,
			                T2.QF_COUNT_ZX,
			                T2.YE_COUNT,
			                T2.YE_COUNT_ZX
			           FROM ${gis_user}.TB_GIS_ADDR_INFO_ALL T2
			          WHERE T2.SEGM_ID_2 = '${param.add6}')) T2
			  LEFT JOIN (SELECT T.ADDRESS_ID,
			                    NVL(T.CONTRACT_PERSON, ' ') CONTRACT_PERSON,
			                    CONTRACT_IPHONE,
			                    T.ACC_NBR,
			                    T.PROD_INST_ID,
			                    T.DID_FLAG,
			                    T.CONN_STR
			               FROM ${gis_user}.TB_GIS_BROADBD_YX_D T
			              WHERE 1 = 1
			                AND T.SECEN_TYPE IN ('04', '21', '10', '11')
			                AND ADDRESS_ID = '${param.add6}') T1
			    ON T1.ADDRESS_ID = T2.SEGM_ID_2
			 ORDER BY DID_FLAG DESC, LENGTH(T2.SEGM_NAME_2), T2.SEGM_NAME_2
	 	</e:q4l>
	 	${e:java2json(list.list)}
	</e:case>

	<e:description>查询住户的产品构成</e:description>
	<e:case value="getCellProductList">
		<e:q4l var="list">
			SELECT m.*,CASE WHEN comp_flag = 1 AND is_zhu = 1 THEN 'a'
         WHEN comp_flag = 1 AND is_zhu = 2 THEN 'b'
         WHEN comp_flag = 1 AND is_zhu IS NULL THEN 'c'
         WHEN comp_flag IS NULL AND (PRODUCT_ID = '100000045' OR PRODUCT_ID = '122445247') THEN 'd'
         WHEN comp_flag IS NULL AND PRODUCT_ID = '100004466' THEN 'e'
         WHEN comp_flag IS NULL AND PRODUCT_ID = '100000000' THEN 'f' END main_offer_level FROM (
						SELECT nvl(T.MAIN_OFFER_NAME,'--') MAIN_OFFER_NAME,
			       T.ACC_NBR,
			       DECODE(T.PRODUCT_ID,
			              '900000001',
			              '移动',
			              '100000045',
			              '宽带',
						  '122445247',
						  '宽带',
			              '100004466',
			              'ITV',
			              '100000000',
			              '固话') PRODUCT_TYPE,
			       T.PRODUCT_ID,
			       T.IS_ZHU,
			       COMP_FLAG,
			       case WHEN EFF_DATE IS NULL THEN '--' ELSE substr(eff_date,0,4)||'年'||SUBSTR(eff_date,5,2)||'月'||SUBSTR(eff_date,7)||'日' end eff_date
						  FROM ${gis_user}.TB_GIS_USER_INFO T
						 WHERE CUST_ID IN
						       (SELECT OWN_CUST_ID
						          FROM ${gis_user}.TB_GIS_ADDR_INFO_ALL
						         WHERE SEGM_ID_2 = '${param.add6}')
						 ORDER BY T.PRODUCT_SORT ASC
				)m
		</e:q4l>${e:java2json(list.list)}
	</e:case>

  <e:description>以产品id为主查询到的营销信息，已废弃。改用六级地址关联营销信息</e:description>
  <e:case value="yx_detail_query_list_info_nouse_bak">
    <e:q4l var="list">
       select t.mobile_count a1,
		       t.fix_count a2,
		       t.itv_count a3,
		       t.acct_fee a4,
		       t.broad_fee a5,
		       t.conn_str,
		       contract_person,
		       acc_nbr,
		       case
		         when (t.work_days_days + t.rest_internet_days) >= 15 then
		          '<span class="redFont">高活跃</span>[' ||
		          (t.work_days_days + t.rest_internet_days) || '天/月]'
		         when (t.work_days_days + t.rest_internet_days) >= 5 and
		              (t.work_days_days + t.rest_internet_days) < 15 then
		          '<span class="redFont">中活跃</span>[' ||
		          (t.work_days_days + t.rest_internet_days) || '天/月]'
		         when (t.work_days_days + t.rest_internet_days) = 0 then
		          '<span class="redFont">沉 默</span>[' ||
		          (t.work_days_days + t.rest_internet_days) || '天/月]'
		         else
		          '<span class="redFont">低活跃</span>[' ||
		          (t.work_days_days + t.rest_internet_days) || '天/月]'
		       end a6,
		       t.rh_offer_name a7,
		       t.main_offer_name || ' [' || substr(t.eff_date, 1, 6) || '--' ||
		       substr(t.exp_date, 1, 6) || ']' a8,
		       t.INSTALL_DATE a9,
		       to_date(plan_exp_date, 'yyyymmdd') a10,
		       t.BROAD_MODE a11,
		       NVL(t.BROAD_RATE, '0') a12,
		       did_flag
		  from ${gis_user}.TB_GIS_BROADBD_YX_D t
		 where t.PROD_INST_ID = '${param.prodid}'
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>
   <e:case value="yx_detail_query_list_four">
    <e:q4l var="list">
    	<e:if condition="${!empty param.village_id}">
    		select distinct t.segm_id a1,t.stand_name a2 from  ${gis_user}.TB_GIS_ADDR_INFO_VIEW t where t.SEGM_ID in (select y.segm_id
                     from ${gis_user}.tb_gis_village_addr4 y
                    where y.village_id = '${param.village_id}')
    	</e:if>
    	<e:if condition="${!empty param.yx_id}">
				select distinct t.segm_id a1,t.stand_name a2 from  ${gis_user}.TB_GIS_ADDR_INFO_VIEW t where t.segm_id in (select y.address_4_segm_id
                     from ${gis_user}.TB_DIC_GIS_YX_ADDRESS y
                    where y.yx_id = '${param.yx_id}')
     	</e:if>
     	<e:if condition="${empty param.yx_id && empty param.village_id && !empty param.segm_id}">
     		select distinct t.segm_id a1,t.stand_name a2 from  ${gis_user}.TB_GIS_ADDR_INFO_VIEW t where t.segm_id = '${param.segm_id}'
     	</e:if>
     	<e:if condition="${empty param.yx_id && empty param.village_id && !empty param.res_id}">
     		select distinct t.segm_id a1,t.stand_name a2 from  ${gis_user}.TB_GIS_ADDR_INFO_VIEW t where t.segm_id = '${param.res_id}'
     	</e:if>
    </e:q4l>
    ${e:java2json(list.list)}
  </e:case>


  <e:case value="getBuildTotal">
    <e:q4o var="dataObject">
    	SELECT COUNT(1) COUNT FROM sde.map_addr_segm_${param.city_id}
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>
  <e:case value="getBuildTotal_no_use">
    <e:q4o var="dataObject">
      select count(1) num
      from (select distinct t.*,
      ROW_NUMBER() OVER(PARTITION BY t1.latn_id ORDER BY t.SEGM_ID asc) num
      from ${gis_user}.TB_GIS_ADDR4_INFO t, ${gis_user}.spc_region t1
      where t.region_id = t1.region_id
      and latn_id = '${param.city_id}') a
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>
  <e:case value="getBuildList">
    <e:q4l var="dataList">
			SELECT resid FROM (
		   select resid,
		   ROW_NUMBER() OVER(PARTITION BY latn_id ORDER BY resid asc) num
		    from sde.map_addr_segm_${param.city_id} )a
		    WHERE a.num <= ${param.pagesize} * (${param.page})
		      and a.num >(${param.page}-1) * ${param.pagesize}
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:description>
  	SELECT resid FROM (
		   select resid,
		   ROW_NUMBER() OVER(PARTITION BY latn_id ORDER BY resid asc) num
		    from sde.map_addr_segm_${param.city_id} )a
		    WHERE a.num <= 10 * (0 + 1)
		      and a.num >0 * 10

  </e:description>
  <e:case value="getBuildList_no_use">
    <e:q4l var="dataList">
      select a.*
      from (select distinct t.*,
      ROW_NUMBER() OVER(PARTITION BY t1.latn_id ORDER BY t.SEGM_ID asc) num
      from ${gis_user}.TB_GIS_ADDR4_INFO t, ${gis_user}.spc_region t1
      where t.region_id = t1.region_id
      and latn_id = '${param.city_id}') a
      where a.num <= ${param.num} * (${param.page} + 1)
      and a.num > ${param.page} * ${param.num}
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>
  <e:case value="addBuildRelation">
    <e:update>
      insert into GIS_MAP_BUILD_RELATE
      (segm_id,segm_name,grid_id,grid_name,sub_id,sub_name)
      values
      (
      '${param.segm_id}',
      '${param.segm_name}',
      '${param.grid_id}',
      '${param.grid_name}',
      '${param.sub_id}',
      '${param.sub_name}'
      )
    </e:update>
  </e:case>
  <e:case value="getCellInfo">
    <e:q4o var="dataObject">
      select
      a.stand_name_2,
      case when bb.contact_person is null then a.user_contact_person else bb.contact_person end contact_person,
		<e:description>2018.10.22 号码脱敏</e:description>
      case when bb.contact_nbr is null then (substr(a.user_contact_nbr,0,3) || '******' || substr(a.user_contact_nbr,10,2)) else (substr(bb.contact_nbr,0,3) || '******' || substr(bb.contact_nbr,10,2)) end contact_nbr,
      bb.people_count,
      case when a.is_kd > 0 then '是' else '否' end is_kd,
      nvl(a.broad_mode,'--')broad_mode,
      nvl(a.broad_rate,'--')broad_rate,
      case when a.is_itv > 0 then '是' else '否' end is_itv,
      nvl(a.gu_acc_nbr,'--') gu_acc_nbr,

      nvl(nvl(nvl(a.rh_offer_name,a.plan_offer_name),main_offer_name),' ') main_offer_name,
      nvl(bb.comments,'')comments,
      bb.operators_type ,
      nvl(bb.dx_comments,'') dx_comments,

      nvl(bb.PHONE_COUNT,0) PHONE_COUNT,
      nvl(bb.PHONE_BUSINESS,0) PHONE_BUSINESS,
      nvl(bb.PHONE_XF,0) PHONE_XF,
      to_char(bb.PHONE_DQ_DATE,'yyyy"年"mm"月"dd"日"') PHONE_DQ_DATE,

      nvl(bb.KD_COUNT,0) KD_COUNT,
      nvl(bb.KD_BUSINESS,0) KD_BUSINESS,
      nvl(bb.KD_XF,0) KD_XF,
      to_char(bb.KD_DQ_DATE,'yyyy"年"mm"月"dd"日"') KD_DQ_DATE,

      nvl(bb.ITV_COUNT,0) ITV_COUNT,
      nvl(bb.ITV_BUSINESS,0) ITV_BUSINESS,
      nvl(bb.ITV_XF,0) ITV_XF,
      to_char(bb.ITV_DQ_DATE,'yyyy"年"mm"月"dd"日"') ITV_DQ_DATE

      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL BB,
		       ${gis_user}.TB_GIS_ADDR_INFO_ALL A
		  where bb.SEGM_ID_2 = '${param.segm_id_2}'
			      and a.segm_id_2 = bb.segm_id_2
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>
  <e:case value="updateYX">
    <e:update>
      update ${gis_user}.TB_GIS_ADDR_OTHER_ALL
      set
      	contact_person = '${param.contact_person}',
				contact_nbr = '${param.contact_nbr}',
				people_count= '${param.people_count}',
				dx_comments = '${param.dx_comments}',
				operators_type = '${param.operators_type}',
				comments = '${param.comments}',

				phone_count = '${param.phone_count}',
				phone_business = '${param.phone_business}',
				phone_xf = '${param.phone_xf}',
				phone_dq_date = to_date('${param.phone_dq_date}','yyyy-mm-dd'),

				kd_count = '${param.kd_count}',
				kd_business = '${param.kd_business}',
				kd_xf = '${param.kd_xf}',
				kd_dq_date = to_date('${param.kd_dq_date}','yyyy-mm-dd'),

				itv_count = '${param.itv_count}',
				itv_business = '${param.itv_business}',
				itv_xf = '${param.itv_xf}',
				itv_dq_date = to_date('${param.itv_dq_date}','yyyy-mm-dd')


      where SEGM_ID_2 = '${param.segm_id_2}'
    </e:update>
  </e:case>
  <e:case value="saveBuildInVillage">
  	<e:set var="ids" value="${e:split(param.ids,',')}" />
  	<e:set var="full_names" value="${e:split(param.name_str,',')}" />
  	<e:set var="short_names" value="${e:split(param.short_name_str,',')}" />
		<e:q4o var="v_id">
			select sde.VILLAGE_SEQ.nextVal val from dual
		</e:q4o>
		<e:q4o var="grid_union_org_code">
				SELECT station_no grid_union_org_code FROM ${gis_user}.spc_branch_station WHERE station_id = '${param.grid_id}'
		</e:q4o>

  	<e:update>
  		begin
              insert into ${gis_user}.tb_gis_village_edit_info
              (
              other_optical_fiber,
              WIDEBAND_IN,
              CM_OPTICAL_FIBER,
              CU_OPTICAL_FIBER,
              SARFT_OPTICAL_FIBER,

              CREATE_TIME,

              <e:description>VILLAGE_GM,</e:description>
              VILLAGE_RU_RATE,
              VILLAGE_XF,
              <e:description>VILLAGE_VALUE,</e:description>

              VILLAGE_ID,
              VILLAGE_NAME,
              BRANCH_NO,
              BRANCH_NAME,
              GRID_ID,
              GRID_ID_2,
              GRID_NAME,
              CREATER,

				  		CTCC_MOBILE_USER_NUM,
				  		<e:description>WIDEBAND_NUM,</e:description>
              TV_USER_NUM,
              <e:description>zhu_hu_sum ,</e:description>
              build_sum ,

							REAL_HOME_NUM,
							PEOPLE_NUM,
							IS_SOLE,

							cmcc_num ,
							cm_wideband_num ,
							cmcc_tv_user_num ,

							cucc_num ,
							cu_wideband_num ,
							cucc_tv_num ,

							sarft_wideband_num ,
							sarft_tv_num,
							position,

							village_label

							)
              values
              (
		              '${param.OTHER}',
		              '${param.WIDEBAND_IN}',
		              '${param.CM_OPTICAL_FIBER}',
		              '${param.CU_OPTICAL_FIBER}',
		              '${param.SARFT_OPTICAL_FIBER}',

		              sysdate,
		              <e:description>'${param.village_scale}',</e:description>
		              '${param.xqrzl}',
		              '${param.village_expense_ability}',
		              <e:description>'${param.village_property}',</e:description>


                  '${v_id.VAL}',
                  '${e:replace(param.v_name,"#","号")}',
                  '${param.sub_id}',
                  '${e:replace(param.sub_name,"#","号")}',
                  '${param.grid_id}',
                  '${param.grid_id_short}',
                  '${e:replace(param.grid_name,"#","号")}',
                  '${sessionScope.UserInfo.LOGIN_ID}',

									'${param.yd_user_count}',
                  <e:description>'${param.kd_user_count}',</e:description>
                  '${param.ds_user_count}',
                  <e:description>'${param.zhu_hu_sum}',</e:description>
                  '${param.build_sum}',

                  '${param.real_home_num}',
                  '${param.people_num}',

                  '${param.village_new_dx_only}',

                  '${param.ydyd_user_count}',
                  '${param.ydkd_user_count}',
                  '${param.ydds_user_count}',

                  '${param.ltyd_user_count}',
                  '${param.ltkd_user_count}',
                  '${param.ltds_user_count}',

                  '${param.gdkd_user_count}',
                  '${param.gdds_user_count}',

                  '${param.village_new_center}',
                  <e:description>
                  '${param.village_type}',
									</e:description>
									'${param.kaipan_time}'
              );
              <e:description>更新服务表</e:description>
              insert into sde.map_village_edit_info
              (
              	 VILLAGE_ID,
						     VILLAGE_NAME,
						     POSITION,
						     SHAPE,
						     LATN_ID,
						     LATN_NAME,
						     BUREAU_NO,
						     BUREAU_NAME,
						     UNION_ORG_CODE,
						     BRANCH_NAME,
						     REPORT_TO_ID,
						     grid_union_org_code,
						     GRID_ID,
						     GRID_NAME,
						     IS_BH
              )
              values
              (
              	'${v_id.VAL}',
              	'${e:replace(param.v_name,"#","号")}',
              	'${param.village_new_center}',
              	sde.st_point('${param.x}', '${param.y}',4326),
              	'${param.latn_id}',
              	'${param.latn_name}',
              	'${param.bureau_no}',
              	'${param.bureau_name}',
                '${param.sub_id}',
                '${e:replace(param.sub_name,"#","号")}',
                '${param.grid_id}',
                '${grid_union_org_code.GRID_UNION_ORG_CODE}',
                '${param.grid_id_short}',
                '${e:replace(param.grid_name,"#","号")}',
                0
              );

              <e:forEach items="${ids}" var="id" indexName = "index">
                      insert into ${gis_user}.tb_gis_village_addr4
                      (
                          VILLAGE_ID,
                          SEGM_ID,
                          segm_name,
                          stand_name
                      )
                      values
                      (
                          '${v_id.VAL}',
                          '${id}',
                          '${e:replace(short_names[index],"#","号")}',
                          '${e:replace(full_names[index],"#","号")}'
                      );


                      <e:description>
                      insert into ${gis_user}.tb_gis_village_edit_info_all
                      (
                          VILLAGE_ID,
				                  VILLAGE_NAME,
				                  BRANCH_NO,
				                  BRANCH_NAME,
				                  GRID_ID,
				                  GRID_NAME,
				                  CREATER,
				                  CREATE_TIME,

													CTCC_MOBILE_USER_NUM,
				                  WIDEBAND_NUM,
				                  TV_USER_NUM,

													REAL_HOME_NUM,
													PEOPLE_NUM,

													IS_SOLE,

													cmcc_num ,
													cm_wideband_num ,
													cmcc_tv_user_num ,

													cucc_num ,
													cu_wideband_num ,
													cucc_tv_num ,

													sarft_wideband_num ,
													sarft_tv_num,

													segm_id,
													cm_optical_fiber,
													cu_optical_fiber,
													sarft_optical_fiber
                      )
                      values
                      (
                          '${v_id.VAL}',
				                  '${e:replace(param.v_name,"#","号")}',
				                  '${param.sub_id}',
				                  '${e:replace(param.sub_name,"#","号")}',
				                  '${param.grid_id}',
				                  '${e:replace(param.grid_name,"#","号")}',
				                  '${sessionScope.UserInfo.LOGIN_ID}',
				                  sysdate,

													'${param.yd_user_count}',
				                  '${param.kd_user_count}',
				                  '${param.ds_user_count}',

				                  '${param.real_home_num}',
				                  '${param.people_num}',

				                  '${param.village_new_dx_only}',

				                  '${param.ydyd_user_count}',
				                  '${param.ydkd_user_count}',
				                  '${param.ydds_user_count}',

				                  '${param.ltyd_user_count}',
				                  '${param.ltkd_user_count}',
				                  '${param.ltds_user_count}',

				                  '${param.gdkd_user_count}',
				                  '${param.gdds_user_count}',

				                  '${id}',
				                  '${param.village_new_ydgw_cover}',
				                  '${param.village_new_ltgw_cover}',
				                  '${param.village_new_gdgw_cover}'

                      );
                      </e:description>
              </e:forEach>
  		end;
  	</e:update>
  	<e:q4o var="dataObject">
  		select '${v_id.VAL}' val from dual
  	</e:q4o>
  	${e:java2json(dataObject)}
  </e:case>

  <e:case value="updateBuildInVillage">
  	<e:set var="ids" value="${e:split(param.ids,',')}" />
  	<e:set var="full_names" value="${e:split(param.name_str,',')}" />
  	<e:set var="short_names" value="${e:split(param.short_name_str,',')}" />

  	<e:update>
		begin
		update ${gis_user}.tb_gis_village_edit_info
			set VILLAGE_NAME = '${e:replace(param.v_name,"#","号")}',

			CTCC_MOBILE_USER_NUM = '${param.yd_user_count}',
			<e:description>WIDEBAND_NUM = '${param.kd_user_count}',</e:description>
			TV_USER_NUM = '${param.ds_user_count}',
			<e:description>zhu_hu_sum = '${param.zhu_hu_sum}',</e:description>

			build_sum = '${param.build_sum}',

			REAL_HOME_NUM = '${param.real_home_num}',
			PEOPLE_NUM = '${param.people_num}',

			IS_SOLE = '${param.village_new_dx_only}',

			CMCC_NUM = '${param.ydyd_user_count}',
			CM_WIDEBAND_NUM = '${param.ydkd_user_count}',
			CMCC_TV_USER_NUM = '${param.ydds_user_count}',

			CUCC_NUM = '${param.ltyd_user_count}',
			CU_WIDEBAND_NUM = '${param.ltkd_user_count}',
			CUCC_TV_NUM = '${param.ltds_user_count}',

			SARFT_WIDEBAND_NUM = '${param.gdkd_user_count}',
			sarft_tv_num = '${param.gdds_user_count}',

			LAST_CREATER = '${sessionScope.UserInfo.LOGIN_ID}',
			LAST_CREATE_TIME = sysdate,

			position = '${param.village_new_center}',
			cm_optical_fiber='${param.CM_OPTICAL_FIBER}',
			cu_optical_fiber='${param.CU_OPTICAL_FIBER}',
			sarft_optical_fiber='${param.SARFT_OPTICAL_FIBER}',
			wideband_in = '${param.WIDEBAND_IN}',

			<e:description>VILLAGE_GM = '${param.village_scale}',</e:description>
			village_ru_rate = '${param.xqrzl}',
			village_xf = '${param.village_expense_ability}',
			<e:description>village_value = '${param.village_property}',</e:description>
			<e:description>village_label = '${param.village_type}'</e:description>
			village_label = '${param.kaipan_time}'

		where VILLAGE_ID = '${param.v_id}';

		<e:description>更新服务表</e:description>
		UPDATE sde.map_village_edit_info SET village_name = '${e:replace(param.v_name,"#","号")}',position = '${param.village_new_center}',shape = sde.st_point('${param.x}', '${param.y}',4326),is_bh=0 WHERE village_id = '${param.v_id}';

		delete from ${gis_user}.tb_gis_village_addr4 where village_id = '${param.v_id}';

		<e:forEach items="${ids}" var="id" indexName="index">

			insert into ${gis_user}.tb_gis_village_addr4
			(
				VILLAGE_ID,
				SEGM_ID,
				segm_name,
				stand_name
			)
			values
			(
				'${param.v_id}',
				'${id}',
				'${e:replace(short_names[index],"#","号")}',
				'${e:replace(full_names[index],"#","号")}'
			);

			<e:description>
			insert into ${gis_user}.tb_gis_village_edit_info_all
				select
				a.VILLAGE_ID,
				a.VILLAGE_NAME,
				a.BRANCH_NO,
				a.BRANCH_NAME,
				a.GRID_ID,
				a.GRID_NAME,
				a.WIDEBAND_IN,
				a.WIDEBAND_NUM,
				a.TV_USER_NUM,
				a.H_USER_NUM,
				a.NOT_H_USER_NUM,
				a.CTCC_MOBILE_USER_NUM,
				a.IS_SOLE,
				a.CM_OPTICAL_FIBER,
				a.CM_WIDEBAND_NUM,
				a.CMCC_NUM,
				a.CMCC_TV_USER_NUM,
				a.CU_OPTICAL_FIBER,
				a.CU_WIDEBAND_NUM,
				a.CUCC_NUM,
				a.CUCC_TV_NUM,
				a.SARFT_OPTICAL_FIBER,
				a.SARFT_WIDEBAND_NUM,
				a.CREATER,
				a.CREATE_TIME,
				c.segm_id,
				a.LAST_CREATER,
				a.LAST_CREATE_TIME,
				a.PEOPLE_NUM,
				a.REAL_HOME_NUM，
				sarft_tv_num
			from ${gis_user}.tb_gis_village_edit_info a ,${gis_user}.tb_gis_village_addr4 c
			where a.village_id = c.village_id and a.village_id = '${param.v_id}';
			</e:description>

		</e:forEach>
  		end;
  	</e:update>
  </e:case>

  <e:description>小区删除 删除小区</e:description>
  <e:case value="deleteBuildInVillage">
  	<e:update>
  		begin
  			delete from ${gis_user}.tb_gis_village_edit_info where village_id = '${param.v_id}';
  			delete from ${gis_user}.tb_gis_village_addr4 where village_id = '${param.v_id}';
  			delete from SDE.MAP_VILLAGE_EDIT_INFO where village_id = '${param.v_id}';
  		end;
  	</e:update>
  </e:case>

  <e:description>小区删除 删除小区 已废弃</e:description>
  <e:case value="deleteBuildInVillage_nouse_bak">
  	<e:update>
  		update ${gis_user}.tb_gis_village_edit_info set vali_flag = 0 where village_id = '${param.v_id}'
  	</e:update>
  </e:case>

  <e:description>按网格id获取分组的小区和对应楼宇id</e:description>
  <e:case value="getBuildIds_new">
  	<e:q4l var="dataList">
  		select to_char(wm_concat(r.segm_id)) segm_ids,r.village_id from ${gis_user}.tb_gis_village_edit_info v ,${gis_user}.tb_gis_village_addr4 r where v.village_id =r.village_id and v.grid_id='${param.grid_id}' and v.vali_flag = 1 group by r.village_id
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>
  <e:case value="getBuildIds">
  	<e:q4l var="dataList">
		SELECT a.SEGM_ID, a.VILLAGE_ID,b.position
		FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 a,${gis_user}.tb_gis_village_edit_info b
		WHERE a.VILLAGE_ID = '${param.village_id}'
		AND a.village_id = b.village_id
		and rownum < 1001
  	</e:q4l>
  		${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取网格下的小区</e:description>
  <e:case value="getVillages">
  	<e:q4l var="dataList">
  		select village_id,village_name,position from ${gis_user}.tb_gis_village_edit_info where grid_id = '${param.grid_id}' and vali_flag = 1
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>
  <e:description>获取支局下的小区</e:description>
  <e:case value="getVillagesBySubId">
  	<e:q4l var="dataList">
  		select village_id,village_name,position from ${gis_user}.tb_gis_village_edit_info where branch_no = '${param.substation}' and vali_flag = 1
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>
  <e:description>获取仅建立在支局下的小区</e:description>
  <e:case value="getVillagesBySubIdOnly">
  	<e:q4l var="dataList">
  		select village_id,village_name,position from ${gis_user}.tb_gis_village_edit_info where branch_no = '${param.substation}' and grid_id is null and vali_flag = 1
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getVillageInfo">
  	<e:q4l var="dataList">
  		select a.*,nvl(case when a.grid_name = '全部' then ' ' else a.grid_name end,' ') grid_name, c.segm_id, c.segm_name, c.stand_name,
  			case when a.port_sum = 0 then 0 else round(a.port_used_sum/a.port_sum,4)*100 end port_lv
			  from ${gis_user}.tb_gis_village_edit_info a, ${gis_user}.tb_gis_village_addr4 c
			 where a.village_Id = '${param.village_id}'
			   and a.village_id = c.village_id
			   and a.vali_flag = 1
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:case value="updatevalbroadbd">
    <e:update var="res">
    	begin
			update ${gis_user}.TB_GIS_BROADBD_YX_D t set t.did_flag='${param.didflag}',t.did_desc='${param.desc}',t.did_time=to_char(sysdate,'yyyy-mm-dd'),t.author_id = '${sessionScope.UserInfo.USER_ID}' where t.address_id ='${param.add6}';
			insert into ${gis_user}.tb_gis_broadbd_yx_d_HISTORY values('${param.add6}','${param.desc}','${param.didflag}',to_char(sysdate,'yyyy"年"mm"月"dd"日"'),'${sessionScope.UserInfo.USER_ID}','');
      	end;
    </e:update>${res}
  </e:case>

  <e:case value="updatevalbroadbd_nouse_bak">
    <e:update var="res">
    	begin
      		update ${gis_user}.TB_GIS_BROADBD_YX_D t set t.did_flag='${param.didflag}',t.did_desc='${param.desc}',t.did_time=to_char(sysdate,'yyyy-mm-dd'),t.author_id = '${sessionScope.UserInfo.USER_ID}' where t.PROD_INST_ID =#proid#;
			insert into ${gis_user}.tb_gis_broadbd_yx_d_HISTORY values('${param.semg_id}','${param.desc}','${param.didflag}',to_char(sysdate,'yyyy"年"mm"月"dd"日"'),'${sessionScope.UserInfo.USER_ID}','${param.proid}');
      	end;
    </e:update>${res}
  </e:case>

  <e:description>获取营销</e:description>
  <e:case value="getYX_history">
  	<e:q4l var="dataList">
		SELECT A.*, NVL(B.USER_NAME, ' ') USER_NAME
		FROM (
		SELECT TO_CHAR(CC.EXEC_TIME, 'yyyy-mm-dd') DID_TIME,
		CC.EXEC_STAFF,
		DECODE(CC.EXEC_STAT,
		1,
		'有意向',
		2,
		'同意办理',
		3,
		'不需要',
		4,
		'无法联系',
		' ') EXEC_STAT_TEXT,
		DECODE(CC.CONTACT_TYPE, 1, '电话', 2, '上门', 3, '门店', ' ') CONTACT_TYPE_TEXT,
		NVL(CC.EXEC_DESC, ' ') DID_DESC
		FROM EDW.TB_MKT_ORDER_EXEC_HIS@GSEDW CC
		WHERE CC.PROD_INST_ID = '${param.prod_inst_id}'
		AND cc.exec_stat>0
		) A
		LEFT JOIN E_USER B
		ON A.EXEC_STAFF = B.EXT30
		ORDER BY DID_TIME DESC
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getProvinceBuildCount">
  	<e:q4l var="dataList">
  		select count(1) count from sde.map_addr_segm_931
  		union
  		select count(1) count from sde.map_addr_segm_938
  		union
  		select count(1) count from sde.map_addr_segm_943
  		union
  		select count(1) count from sde.map_addr_segm_937
  		union
  		select count(1) count from sde.map_addr_segm_936
  		union
  		select count(1) count from sde.map_addr_segm_935
  		union
  		select count(1) count from sde.map_addr_segm_945
  		union
  		select count(1) count from sde.map_addr_segm_947
  		union
  		select count(1) count from sde.map_addr_segm_932
  		union
  		select count(1) count from sde.map_addr_segm_933
  		union
  		select count(1) count from sde.map_addr_segm_934
  		union
  		select count(1) count from sde.map_addr_segm_939
  		union
  		select count(1) count from sde.map_addr_segm_930
  		union
  		select count(1) count from sde.map_addr_segm_941
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:case value="saveVillagePosition">
  	<e:update var="up_count">
  		begin
	  		update ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO set position = '${param.v_center}' where village_id = '${param.village_id}';
				update sde.map_village_edit_info set POSITION = '${param.v_center}',SHAPE = sde.st_point('${param.x}', '${param.y}',4326) where village_id = '${param.village_id}';
  		end;
  	</e:update>
  </e:case>
  <e:case value="validBuildUsed">
  	<e:q4o var="dataObject">
  		SELECT COUNT(1) COUNT FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 WHERE segm_id IN ( ${param.build_ids} )
  		<e:if condition="${!empty param.village_id}">
  			and village_id != '${param.village_id}'
  		</e:if>
  	</e:q4o>${e:java2json(dataObject.COUNT)}
  </e:case>

  <e:description>新建校园政企是否有重复选择楼宇</e:description>
  <e:case value="validBuildUsedForSchoolOrEnterprise">
  	<e:q4o var="dataObject">
  		SELECT COUNT(1) COUNT FROM ${gis_user}.TB_GIS_BUSINESS_ADDR4 WHERE segm_id IN ( ${param.build_ids} )
  		<e:if condition="${!empty param.village_id}">
  			and business_id != '${param.village_id}'
  		</e:if>
  	</e:q4o>${e:java2json(dataObject.COUNT)}
  </e:case>

  <e:description>保存四级地址和支局、网格的关系</e:description>
  <e:case value="saveBuildRelate">
  	<e:update>
  		insert into ${gis_user}.add4_sub_grid_relate values ('${param.resid}','${param.city_id}','${param.sub_id}','${param.grid_id}')
  	</e:update>
  </e:case>

  <e:description>获取六级地址的竞争信息收集</e:description>
  <e:case value="getInfoCollectByAdd6">
  	<e:q4o var="dataObject">
		select
			bb.segm_id_2,
			bb.stand_name_2,
			nvl(bb.contact_person,' ') contact_person,
			<e:description>2018.10.22 号码脱敏</e:description>
			substr(bb.contact_nbr,0,3) || '******' || substr(bb.contact_nbr,10,2) contact_nbr,
			nvl(bb.people_count,0) people_count,

			nvl(phone_nbr ,' ') phone_nbr1,
			nvl(phone_nbr1 ,' ') phone_nbr2,
			nvl(phone_nbr2 ,' ') phone_nbr3,

			nvl(phone_business,0) phone_business1,
			nvl(phone_business1 ,0) phone_business2,
			nvl(phone_business2 ,0) phone_business3,

			case when phone_business is null then ' ' when phone_business = 1 then '移动' when phone_business = 2 then '联通' end phone_business1_text,
			case when phone_business1 is null then ' ' when phone_business1 = 1 then '移动' when phone_business1 = 2 then '联通' end phone_business2_text,
			case when phone_business2 is null then ' ' when phone_business2 = 1 then '移动' when phone_business2 = 2 then '联通' end phone_business3_text,

			nvl(phone_xf,0) phone_xf1,
			nvl(phone_xf1,0) phone_xf2,
			nvl(phone_xf2,0) phone_xf3,

			nvl(to_char(bb.PHONE_DQ_DATE,'yyyy"年"mm"月"dd"日"'),' ') PHONE_DQ_DATE1,
			nvl(to_char(bb.PHONE_DQ_DATE1,'yyyy"年"mm"月"dd"日"'),' ') PHONE_DQ_DATE2,
			nvl(to_char(bb.PHONE_DQ_DATE2,'yyyy"年"mm"月"dd"日"'),' ') PHONE_DQ_DATE3,

			nvl(kd_nbr,' ') kd_nbr,
			nvl(itv_nbr,' ') itv_nbr,

			nvl(kd_business ,' ') kd_business,
			nvl(itv_business ,' ') itv_business,

			case when kd_business is null then ' ' when kd_business = 1 then '移动' when kd_business = 2 then '联通' when kd_business = 3 then '广电' when kd_business = 4 then '其他' end kd_business_text,
			case when itv_business is null then ' ' when itv_business = 1 then '移动' when itv_business = 2 then '联通' when itv_business = 3 then '广电' when itv_business = 4 then '其他' end itv_business_text,

			nvl(bb.KD_XF,0) KD_XF,
			nvl(bb.ITV_XF,0) ITV_XF,

			nvl(to_char(bb.KD_DQ_DATE,'yyyy"年"mm"月"dd"日"') ,' ') kd_dq_date,
			nvl(to_char(bb.ITV_DQ_DATE,'yyyy"年"mm"月"dd"日"') ,' ') itv_dq_date,

			nvl(fiber_box,' ')fiber_box,
			nvl(fiber_box_places,' ')fiber_box_places,
			nvl(gate_pic,' ')gate_pic,
			nvl(live_pic,' ')live_pic

		FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL BB
		where bb.SEGM_ID_2 = '${param.add6}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:description>暂不用</e:description>
  <e:case value="hasSavedInfoCollect">
	<e:q4o var="dataObject">
		select count(1) count from ${gis_user}.TB_GIS_ADDR_OTHER_ALL where SEGM_ID_2 = '${param.add6}' AND CONTACT_PERSON IS NULL AND CONTACT_NBR IS NULL
	</e:q4o>
	<e:if condition="${dataObject.COUNT == 0}" var="isEdited">
			-1
	</e:if>
	<e:else condition="${isEdited}">
		${dataObject.COUNT}
	</e:else>
  </e:case>
  <e:description>暂不用</e:description>
  <e:case value = "saveInfoCollect">
  	<e:if condition="${param.operate_type eq 'add'}">
		<e:q4o var="dataObject">
			select count(1) count from ${gis_user}.TB_GIS_ADDR_OTHER_ALL where SEGM_ID_2 = '${param.add6}' AND CONTACT_PERSON IS NULL AND CONTACT_NBR IS NULL
		</e:q4o>
		<e:q4o var='segm_id_2'>
					select SEGM_ID_2 val from ${gis_user}.TB_GIS_ADDR_OTHER_ALL where SEGM_ID_2 = '${param.add6}' and collect_date is null
			</e:q4o>
		<e:description>说明已经被编辑过了</e:description>
		<e:if condition="${dataObject.COUNT == 0}" var="isEdited">
			-1
		</e:if>
		<e:else condition="${isEdited}">
			<e:update var="res">
				update ${gis_user}.TB_GIS_ADDR_OTHER_ALL
			  	set
				contact_person = '${param.contact_person}',
				contact_nbr = '${param.contact_nbr}',
				people_count= '${param.people_count}',
				phone_nbr= '${param.phone_nbr}',
				phone_nbr1= '${param.phone_nbr1}',
				phone_nbr2= '${param.phone_nbr2}',
				kd_nbr= '${param.kd_nbr}',
				itv_nbr= '${param.itv_nbr}',
				phone_business= '${param.phone_business}',
				phone_business1= '${param.phone_business1}',
				phone_business2= '${param.phone_business2}',
				kd_business= '${param.kd_business}',
				itv_business= '${param.itv_business}',
				phone_xf= '${param.phone_xf}',
				phone_xf1= '${param.phone_xf1}',
				phone_xf2= '${param.phone_xf2}',
				kd_xf= '${param.kd_xf}',
				itv_xf= '${param.itv_xf}',
				phone_dq_date= to_date('${param.phone_dq_date}','yyyy-mm-dd'),
				phone_dq_date1= to_date('${param.phone_dq_date1}','yyyy-mm-dd'),
				phone_dq_date2= to_date('${param.phone_dq_date2}','yyyy-mm-dd'),
				kd_dq_date= to_date('${param.kd_dq_date}','yyyy-mm-dd'),
				itv_dq_date= to_date('${param.itv_dq_date}','yyyy-mm-dd'),
				fiber_box= '${param.fiber_box}',
				fiber_box_places= '${param.fiber_box_places}',
				gate_pic= '${param.gate_pic}',
				live_pic= '${param.live_pic}',
				<e:if condition='${empty segm_id_2.VAL}' var="isFirst">
					collect_date = sysdate
				</e:if>
				<e:else condition="${isFirst}">
					collect_update_date = sysdate
				</e:else>
			  where SEGM_ID_2 = '${param.add6}'
			</e:update>${res}
		</e:else>
  	</e:if>
  	<e:if condition="${param.operate_type eq 'update'}">
  		<e:q4o var='segm_id_2'>
			select SEGM_ID_2 val from ${gis_user}.TB_GIS_ADDR_OTHER_ALL where SEGM_ID_2 = '${param.add6}' and collect_date is null
		</e:q4o>
  		<e:update var="res">
			update ${gis_user}.TB_GIS_ADDR_OTHER_ALL
			set
			contact_person = '${param.contact_person}',
			contact_nbr = '${param.contact_nbr}',
			people_count= '${param.people_count}',
			phone_nbr= '${param.phone_nbr}',
			phone_nbr1= '${param.phone_nbr1}',
			phone_nbr2= '${param.phone_nbr2}',
			kd_nbr= '${param.kd_nbr}',
			itv_nbr= '${param.itv_nbr}',
			phone_business= '${param.phone_business}',
			phone_business1= '${param.phone_business1}',
			phone_business2= '${param.phone_business2}',
			kd_business= '${param.kd_business}',
			itv_business= '${param.itv_business}',
			phone_xf= '${param.phone_xf}',
			phone_xf1= '${param.phone_xf1}',
			phone_xf2= '${param.phone_xf2}',
			kd_xf= '${param.kd_xf}',
			itv_xf= '${param.itv_xf}',
			phone_dq_date= to_date('${param.phone_dq_date}','yyyy-mm-dd'),
			phone_dq_date1= to_date('${param.phone_dq_date1}','yyyy-mm-dd'),
			phone_dq_date2= to_date('${param.phone_dq_date2}','yyyy-mm-dd'),
			kd_dq_date= to_date('${param.kd_dq_date}','yyyy-mm-dd'),
			itv_dq_date= to_date('${param.itv_dq_date}','yyyy-mm-dd'),
			fiber_box= '${param.fiber_box}',
			fiber_box_places= '${param.fiber_box_places}',
			gate_pic= '${param.gate_pic}',
			live_pic= '${param.live_pic}',
			<e:if condition='${empty segm_id_2.VAL}' var="isFirst">
				collect_date = sysdate
			</e:if>
			<e:else condition="${isFirst}">
				collect_update_date = sysdate
			</e:else>

		  where SEGM_ID_2 = '${param.add6}'
		</e:update>${res}
  	</e:if>
  	<e:if condition="${param.operate_type eq 'add_diy'}">
  		<e:update var="res">
  			insert into ${gis_user}.TB_GIS_ADDR_OTHER_ALL_DIY
  				(
  					contact_person,
  					contact_nbr,
  					people_count,
  					phone_nbr,
  					phone_nbr1,
  					phone_nbr2,
  					kd_nbr,
  					itv_nbr,
  					phone_business,
  					phone_business1,
  					phone_business2,
  					kd_business,
  					itv_business,
  					phone_xf,
  					phone_xf1,
  					phone_xf2,
  					kd_xf,
  					itv_xf,
  					phone_dq_date,
  					phone_dq_date1,
  					phone_dq_date2,
  					kd_dq_date,
  					itv_dq_date，
  					latn_id,
  					bureau_no,
  					union_org_code,
  					grid_id,
  					village_id_diy,
  					village_name_diy,
  					segm_id,
  					segm_id_2,
  					segm_name_2,
  					collect_date
					)
  				values
		      (
		      	'${param.contact_person}',
						'${param.contact_nbr}',
						'${param.people_count}',
						'${param.phone_nbr}',
						'${param.phone_nbr1}',
						'${param.phone_nbr2}',
						'${param.kd_nbr}',
						'${param.itv_nbr}',
						'${param.phone_business}',
						'${param.phone_business1}',
						'${param.phone_business2}',
						'${param.kd_business}',
						'${param.itv_business}',
						'${param.phone_xf}',
						'${param.phone_xf1}',
						'${param.phone_xf2}',
						'${param.kd_xf}',
						'${param.itv_xf}',
						to_date('${param.phone_dq_date}','yyyy-mm-dd'),
						to_date('${param.phone_dq_date1}','yyyy-mm-dd'),
						to_date('${param.phone_dq_date2}','yyyy-mm-dd'),
						to_date('${param.kd_dq_date}','yyyy-mm-dd'),
						to_date('${param.itv_dq_date}','yyyy-mm-dd'),
						'${param.latn_id}',
						'${param.bureau_no}',
						'${param.union_org_code}',
						'${param.grid_id}',
						'${param.village_id_diy}',
						'${param.village_id_name}',
						'',
						${gis_user}.STANDARD_ID_SEQ.nextVal,
						'${param.add6_name}',
						sysdate
		      )
			</e:update>${res}
  	</e:if>
  	<e:if condition="${param.operate_type eq 'update_diy'}">
  		<e:update var="res">
  			update ${gis_user}.TB_GIS_ADDR_OTHER_ALL_DIY
		      set
		      	contact_person = '${param.contact_person}',
				contact_nbr = '${param.contact_nbr}',
				people_count= '${param.people_count}',
				phone_nbr= '${param.phone_nbr}',
				phone_nbr1= '${param.phone_nbr1}',
				phone_nbr2= '${param.phone_nbr2}',
				kd_nbr= '${param.kd_nbr}',
				itv_nbr= '${param.itv_nbr}',
				phone_business= '${param.phone_business}',
				phone_business1= '${param.phone_business1}',
				phone_business2= '${param.phone_business2}',
				kd_business= '${param.kd_business}',
				itv_business= '${param.itv_business}',
				phone_xf= '${param.phone_xf}',
				phone_xf1= '${param.phone_xf1}',
				phone_xf2= '${param.phone_xf2}',
				kd_xf= '${param.kd_xf}',
				itv_xf= '${param.itv_xf}',
				phone_dq_date= to_date('${param.phone_dq_date}','yyyy-mm-dd'),
				phone_dq_date1= to_date('${param.phone_dq_date1}','yyyy-mm-dd'),
				phone_dq_date2= to_date('${param.phone_dq_date2}','yyyy-mm-dd'),
				kd_dq_date= to_date('${param.kd_dq_date}','yyyy-mm-dd'),
				itv_dq_date= to_date('${param.itv_dq_date}','yyyy-mm-dd'),
				fiber_box= '${param.fiber_box}',
				fiber_box_places= '${param.fiber_box_places}',
				gate_pic= '${param.gate_pic}',
				live_pic= '${param.live_pic}'

		      where SEGM_ID_2 = '${param.add6}'
			</e:update>${res}
  	</e:if>
  </e:case>

  <e:description>竞争资料收集统计内容</e:description>
  <e:case value="getInfoColleSummaryByPage">
  	<e:q4l var="dataList">
  		SELECT m.* FROM (
				SELECT T.*,
				               ROW_NUMBER() OVER(ORDER BY t.LATN_ID) RN
				  FROM (SELECT LATN_ID,
				               LATN_NAME,
				               BUREAU_NO,
				               BUREAU_NAME,
				               UNION_ORG_CODE,
				               NVL(BRANCH_NAME, ' ') BRANCH_NAME,
				               GRID_ID,
				               NVL(GRID_NAME, ' ') GRID_NAME,
				               NUM
				          FROM ${gis_user}.TB_GIS_GRID_COLLECT
				         WHERE 1=1
				         		<e:if condition="${!empty param.city_id}">
					            AND LATN_ID = '${param.city_id}'
					          </e:if>
					          <e:if condition="${!empty param.area_id}">
					            AND BUREAU_NO = '${param.area_id}'
					          </e:if>
					          <e:if condition="${!empty param.sub_id}">
					            AND UNION_ORG_CODE = '${param.sub_id}'
					          </e:if>
					          <e:if condition="${param.level ne '5'}">
					          	<e:if condition="${!empty param.grid_id && param.grid_id != 'null'}">
						            AND GRID_ID = '${param.grid_id}'
						          </e:if>
					          </e:if>
					          <e:if condition="${param.level eq '5'}">
					          	<e:if condition="${!empty param.grid_id && param.grid_id != 'null'}">
						            AND GRID_ID = (select grid_id from ${gis_user}.db_cde_grid where grid_union_org_code = '${param.grid_id}')
						          </e:if>
					          </e:if>

				         ORDER BY NUM DESC) T)m
				 WHERE m.RN > ${param.page} * 100
				   AND m.RN <= ${param.page+1} * 100

  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>竞争资料收集列表内容</e:description>
  <e:case value="getInfoCollectListByPage">
  	<e:q4l var="dataList">
  		SELECT m.* FROM (
				SELECT t.*,ROW_NUMBER() OVER(ORDER BY SEGM_TYPE) RN
				  FROM (SELECT SEGM_ID_2,
				               T.STAND_NAME_2,
				               CONTACT_PERSON,
								<e:description>2018.10.22 号码脱敏</e:description>
							   substr(CONTACT_NBR,0,3) || '******' || substr(CONTACT_NBR,10,2) CONTACT_NBR,
				               CASE
				                 WHEN KD_BUSINESS IS NULL THEN
				                  ' '
				                 WHEN KD_BUSINESS = '1' OR KD_BUSINESS = '移动' THEN
				                  '移动'
				                 WHEN KD_BUSINESS = '2' OR KD_BUSINESS = '联通' THEN
				                  '联通'
				                 WHEN KD_BUSINESS = '3' OR KD_BUSINESS = '广电' THEN
				                  '广电'
				                 WHEN KD_BUSINESS = '4' OR KD_BUSINESS = '其他' THEN
				                  '其他'
				                 WHEN KD_BUSINESS = '5' OR KD_BUSINESS = '电信' THEN
				                  '电信'
				               END KD_BUSINESS_TEXT,
				               NVL(TO_CHAR(KD_DQ_DATE, 'yyyy"年"mm"月"dd"日"'), ' ') KD_DQ_DATE,
				               SEGM_TYPE
				          FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL T
				         WHERE SEGM_ID IN (SELECT SEGM_ID
				                             FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
				                            WHERE 1 = 1
				                              <e:if condition="${!empty param.city_id}">
								                    	AND LATN_ID = '${param.city_id}'
								                    </e:if>
								                    <e:if condition="${!empty param.area_id}">
								                      AND BUREAU_NO = '${param.area_id}'
								                    </e:if>
								                    <e:if condition="${!empty param.sub_id}">
								                      AND UNION_ORG_CODE = '${param.sub_id}'
								                    </e:if>
								                    <e:if condition="${!empty param.grid_id && param.grid_id != 'null'}">
								                      AND GRID_ID = '${param.grid_id}'
								                    </e:if>)
				           AND CONTACT_PERSON IS NOT NULL
				           AND CONTACT_NBR IS NOT NULL
				           ORDER BY SEGM_ID,CONTACT_PERSON
				           )t)m
				 WHERE m.RN > ${param.page} * 100
				   AND m.RN <= ${param.page+1} * 100
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:description>竞争资料收集列表数量</e:description>
  <e:case value="getInfoCollectListCount">
  	<e:q4o var="dataObject">
  	SELECT count(1) count
		  FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL T
		 WHERE SEGM_ID IN (SELECT SEGM_ID
		                     FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
		                    WHERE 1=1
		                    <e:if condition="${!empty param.city_id}">
		                    	AND LATN_ID = '${param.city_id}'
		                    </e:if>
		                    <e:if condition="${!empty param.area_id}">
		                      AND BUREAU_NO = '${param.area_id}'
		                    </e:if>
		                    <e:if condition="${!empty param.sub_id}">
		                      AND UNION_ORG_CODE = '${param.sub_id}'
		                    </e:if>
		                    <e:if condition="${!empty param.grid_id && param.grid_id != 'null'}">
		                      AND GRID_ID = '${param.grid_id}'
		                    </e:if>
		                   )
		   AND CONTACT_PERSON IS not NULL
		   AND CONTACT_NBR IS NOT NULL
  	</e:q4o>
  	${e:java2json(dataObject)}
  </e:case>

  <e:description>竞争资料收集，获取六级地址归属的地市区县支局网格</e:description>
  <e:case value="getPosition">
  	<e:q4o var="dataObject">
  		SELECT LATN_NAME, BUREAU_NAME, nvl(BRANCH_NAME,' ') BRANCH_NAME,
  			<e:if condition="${!empty param.grid_id && param.grid_id != 'null'}" var="emptyGridId">
  				nvl(GRID_NAME,' ') GRID_NAME
  			</e:if>
  			<e:else condition="${emptyGridId}">
  				' ' GRID_NAME
  			</e:else>
			  FROM ${gis_user}.DB_CDE_GRID
			 WHERE 1=1
			  <e:if condition="${!empty param.city_id}">
        	AND LATN_ID = '${param.city_id}'
        </e:if>
        <e:if condition="${!empty param.area_id}">
          AND BUREAU_NO = '${param.area_id}'
        </e:if>
        <e:if condition="${!empty param.sub_id}">
          AND UNION_ORG_CODE = '${param.sub_id}'
        </e:if>
        <e:if condition="${!empty param.grid_id && param.grid_id != 'null'}">
          AND GRID_ID = '${param.grid_id}'
        </e:if>
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>通过四级地址获得所属小区名称</e:description>
  <e:case value="getVillageNameByAdd4">
  	<e:q4o var="dataObject">
  		SELECT village_name FROM ${gis_user}.tb_gis_village_edit_info WHERE village_id = (SELECT village_id FROM ${gis_user}.tb_gis_village_addr4 WHERE segm_id = '${param.add4}')
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>通过六级地址获得所属小区名称</e:description>
  <e:case value="getVillageNameByAdd6">
  	<e:q4o var="dataObject">
  		SELECT VILLAGE_NAME
			  FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
			 WHERE VILLAGE_ID =
			       (SELECT VILLAGE_ID
			          FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4
			         WHERE SEGM_ID =
			               (SELECT SEGM_ID
			                  FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL
			                 WHERE SEGM_ID_2 = '${param.add6}'))
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>获取某支局、网格下没有维护过竞争信息的四级地址</e:description>
  <e:case value="getAdd4ListInSubAndGrid">
  	<e:q4l var="dataList">
  		SELECT distinct
	  			SEGM_ID,
		       T.STAND_NAME_1
				  FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL T
				 WHERE SEGM_ID IN (SELECT SEGM_ID
				                     FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
				                    WHERE 1=1
				                    <e:if condition="${!empty param.city_id}">
				                    	AND LATN_ID = '${param.city_id}'
				                    </e:if>
				                    <e:if condition="${!empty param.area_id}">
				                      AND BUREAU_NO = '${param.area_id}'
				                    </e:if>
				                    <e:if condition="${!empty param.sub_id}">
				                      AND UNION_ORG_CODE = '${param.sub_id}'
				                    </e:if>
				                    <e:if condition="${!empty param.grid_id}">
				                      AND GRID_ID = '${param.grid_id}'
				                    </e:if>
				                    <e:if condition="${!empty param.village_id}">
				                    	AND SEGM_ID IN(SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 where village_id = '${param.village_id}')
				                    </e:if>
				                   )
				   AND CONTACT_PERSON IS NULL
				   AND CONTACT_NBR IS NULL
				   <e:if condition="${sessionScope.UserInfo.LEVEL eq '1' || sessionScope.UserInfo.LEVEL eq '2'}">
				   	and rownum <=100
				   </e:if>
				   order by STAND_NAME_1
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取某四级地址下的六级地址</e:description>
  <e:case value="getAdd6ByAdd4Id">
  	<e:q4l var="dataList">
  		SELECT segm_id_2,segm_name_2 FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL WHERE segm_id = '${param.add4}'
  			AND CONTACT_PERSON IS NULL
				AND CONTACT_NBR IS NULL
  		order by segm_name_2
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取某支局、网格下没有维护过竞争信息的六级地址</e:description>
  <e:case value= "getAdd6ListInSubAndGrid">
  	<e:q4l var="dataList">
  		SELECT
	  			SEGM_ID_2,
		       T.STAND_NAME_2
				  FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL T
				 WHERE SEGM_ID IN (SELECT SEGM_ID
				                     FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
				                    WHERE 1=1
				                    <e:if condition="${!empty param.city_id}">
				                    	AND LATN_ID = '${param.city_id}'
				                    </e:if>
				                    <e:if condition="${!empty param.area_id}">
				                      AND BUREAU_NO = '${param.area_id}'
				                    </e:if>
				                    <e:if condition="${!empty param.sub_id}">
				                      AND UNION_ORG_CODE = '${param.sub_id}'
				                    </e:if>
				                    <e:if condition="${!empty param.grid_id}">
				                      AND GRID_ID = '${param.grid_id}'
				                    </e:if>
				                   )
				   AND CONTACT_PERSON IS NULL
				   AND CONTACT_NBR IS NULL
  	</e:q4l>
  	${e:java2json(dataList.list)}
  </e:case>

  <e:case value="upload_img">
  	<e:parseRequest/>
  	<e:if condition="${update_load eq 'fxx'}">
  		<e:q4o var="fileName_prefix">
  			select to_char(sysdate,'yyyymmddhh24miss') fileName from dual
  		</e:q4o>
  		<e:copy file="${Filedata}" tofile="/upload/fxx/${fileName_prefix.FILENAME}.${e:substringAfter(Filedata.name,'.')}"/>
  	</e:if>
  	<e:if condition="${update_load eq 'gate'}">
  		<e:copy file="${Filedata}" tofile="/upload/gate/${fileName_prefix.FILENAME}.${e:substringAfter(Filedata.name,'.')}"/>
  	</e:if>
  	<e:if condition="${update_load eq 'house'}">
  		<e:copy file="${Filedata}" tofile="/upload/house/${fileName_prefix.FILENAME}.${e:substringAfter(Filedata.name,'.')}"/>
  	</e:if>
  </e:case>

  <e:case value="getBranchTypeBySubId">
  	<e:q4o var="dataObject">
  		SELECT distinct branch_type,branch_no FROM ${gis_user}.db_cde_grid WHERE union_org_code	= '${param.substation}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="getGridIdByGridUnionOrgCode">
  	<e:q4o var="dataObject">
  		SELECT distinct grid_id FROM ${gis_user}.db_cde_grid WHERE grid_union_org_code	= '${param.grid_id}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="getBuildPositionByAdd6">
  	<e:q4o var="dataObject">
  		SELECT NVL(A.LATN_NAME, ' ') LATN_NAME,
       NVL(A.BUREAU_NAME, ' ') BUREAU_NAME,
       NVL(A.BRANCH_NAME, ' ') BRANCH_NAME,
       NVL(A.GRID_NAME, ' ') GRID_NAME,
       NVL(B.VILLAGE_NAME, ' ') VILLAGE_NAME
		  FROM (SELECT SEGM_ID, LATN_NAME, BUREAU_NAME, BRANCH_NAME, GRID_NAME
		          FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
		         WHERE SEGM_ID =
		               (SELECT SEGM_ID
		                  FROM ${gis_user}.TB_GIS_ADDR_INFO_ALL
		                 WHERE SEGM_ID_2 = '${param.add6}')) A
		  LEFT JOIN (SELECT SEGM_ID, VILLAGE_NAME
		               FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4     B,
		                    ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO C
		              WHERE B.VILLAGE_ID = C.VILLAGE_ID) B
		    ON A.SEGM_ID = B.SEGM_ID
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:description>新客户视图 收集信息</e:description>
  <e:case value="save_collect_info_new">
  		 <e:q4o var='collect_date'>
						select collect_date val from ${gis_user}.TB_GIS_ADDR_OTHER_ALL where SEGM_ID_2 = '${param.segment_id}'
			 </e:q4o>
       <e:update var="count">
            UPDATE ${gis_user}.TB_GIS_ADDR_OTHER_ALL
            SET CONTACT_PERSON = '${param.resident_name }',
            CONTACT_NBR = '${param.resident_phone }',
            KD_BUSINESS = '${param.collect_operator }',
            KD_XF = '${param.collect_expense }',
            KD_DQ_DATE = TO_DATE('${param.collect_date }', 'YYYY-MM-DD'),
            ITV_BUSINESS = '${param.collect_operator_itv }',
            ITV_XF = '${param.collect_expense_itv }',
            ITV_DQ_DATE = TO_DATE('${param.collect_date_itv }', 'YYYY-MM-DD'),
            <e:if condition='${empty collect_date.VAL}' var="isFirst">
							collect_date = sysdate
						</e:if>
						<e:else condition="${isFirst}">
							collect_update_date = sysdate
						</e:else>,
            note_txt = '${param.collect_note_txt}',
            warn_date = TO_DATE('${param.collect_warn_time}','YYYY-MM-DD'),
            comments = '${param.collect_comments}'
            WHERE SEGM_ID_2 = '${param.segment_id }'
       </e:update>${count }
  </e:case>

  <e:description>获得标准地址所属的区县、支局、网格</e:description>
  <e:case value="getOrgsByResid">
  	<e:q4o var="dataObject">
  		SELECT latn_id,latn_name,bureau_no,bureau_Name,union_org_code,branch_name,grid_union_org_code,grid_id,grid_name FROM sde.map_addr_segm_${param.city_id} WHERE resid = '${param.add4}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>根据支局获取其归属的地市和区县</e:description>
  <e:case value="getLatnNameBureauNameByUnionOrgCode">
  	<e:q4o var="dataObject"	>
  		select distinct latn_name,bureau_name from ${gis_user}.db_cde_grid where union_org_code = '${param.union_org_code}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>获取指定楼宇类型的楼宇id</e:description>
  <e:case value="getBuildIdByBuildType">
  	<e:q4l var="dataList">
  		select segm_id from ${gis_user}.addr_segm_build_lan where segm_id in (${param.ids_str})
  		<e:if condition="${!empty param.build_type}">
  			and build_id = '${param.build_type}'
  		</e:if>
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取订单号，一键订购甩单，2019新 一键甩单</e:description>
  <e:case value="getOrderId_oneKeyBuy">
  	<e:q4o var="dataObject">
  		SELECT a.contact_order_id,b.accept_type FROM EDW.TB_CONTACT_ORDER_HX@gsedw a,EDW.MKT_CAMPAIGN_HX@GSEDW b WHERE a.MKT_CAMPAIGN_ID = b.MKT_CAMPAIGN_ID and b.scene_id = '${param.mkt_id}' AND a.prod_inst_id = '${param.prod_inst_id}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

	<e:description>根据支局id获取支局类型是城市还是农村</e:description>
	<e:case value="getBranchType">
		<e:q4o var="dataObject">
			SELECT DECODE(branch_type,'a1','城市','b1','农村','c1','政企') branch_type FROM ${gis_user}.db_cde_grid WHERE 1=1
			<e:if condition="${!empty param.union_org_code}">
				and union_org_code = '${param.union_org_code}'
			</e:if>
			<e:if condition="${!empty param.grid_union_org_code}">
				and grid_union_org_code = '${param.grid_union_org_code}'
			</e:if>
		</e:q4o>${e:java2json(dataObject)}
	</e:case>

	<e:description>根据分局名称获取分局id</e:description>
	<e:case value="getUnionOrgCodeByBureauName">
		<e:q4l var="dataList">
			SELECT DISTINCT union_org_code FROM ${gis_user}.db_cde_grid WHERE bureau_name LIKE '%${param.bureau_name}%' and branch_type <> 'c1'
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>
	
</e:switch>
