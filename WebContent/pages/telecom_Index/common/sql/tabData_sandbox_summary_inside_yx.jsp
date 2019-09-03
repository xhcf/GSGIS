<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="exec_succ_percent">
	case when sum(nvl(col_num_1,0)) = 0 then '0.00%' else to_char(sum(col_num_2)/sum(col_num_1) * 100 ,'FM99999999990.00') || '%' end zx_rate,
	case when sum(nvl(col_num_1,0)) = 0 then '0.00%' else to_char(sum(col_num_3)/sum(col_num_1) * 100 ,'FM99999999990.00') || '%' end cg_rate
</e:set>
<e:set var="exec_succ_percent1">
	case when sum(nvl(col_num_1,0)) = 0 then '0.00%' else to_char(sum(col_num_2)/sum(col_num_1) * 100 ,'FM99999999990.00') || '%' end rate_1,
	case when sum(nvl(col_num_1,0)) = 0 then '0.00%' else to_char(sum(col_num_3)/sum(col_num_1) * 100 ,'FM99999999990.00') || '%' end rate_2
</e:set>
<e:set var="sql_part_tab_name1">
	<e:description>
		2018.9.11 表名更换 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 改为 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY
		2018.9.20 表名恢复 从 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY 更换为 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW
		2019.3.27 表名 从 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 变成 ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
	</e:description>
	${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
</e:set>
<e:set var="sql_part_tab_name2">
	<e:description>2018.11.30 场景维护 更换表名 ${gis_user}.tb_dim_scene_type</e:description>
	<e:description>edw.tb_dim_send_market@gsedw</e:description>
	${gis_user}.tb_dic_gis_market_type
</e:set>
<e:switch value="${param.eaction}">
<e:description>支局长部分 begin</e:description>
<e:description>考核统计_趋势(日)统计部分</e:description>
    <e:case value="marketing_sence_num">
        <e:q4l var="marketing_sence_num">
			SELECT '0' MKT_ID,'全部' MKT_NAME, nvl(SUM(T1.COL_NUM_1),0) MKT_CNT
			FROM ${sql_part_tab_name1} T1
			WHERE T1.BRANCH_UNION_ORG_CODE = '${param.union_org_code}'
			AND T1.STAT_DATE = TO_CHAR(SYSDATE, 'yyyymmdd')
			AND T1.STAT_LVL = 3
			UNION ALL
			SELECT T2.MKT_ID, T2.MKT_NAME, NVL(T1.MKT_CNT, 0) MKT_CNT
			FROM ${sql_part_tab_name2} T2
			LEFT JOIN (SELECT T1.SCENE_ID, SUM(T1.COL_NUM_1) MKT_CNT
			FROM ${sql_part_tab_name1} T1
			WHERE T1.BRANCH_UNION_ORG_CODE = '${param.union_org_code}'
			AND T1.STAT_DATE = TO_CHAR(SYSDATE, 'yyyymmdd')
			AND T1.STAT_LVL = 3
			GROUP BY T1.SCENE_ID) T1
			ON T2.MKT_ID = T1.SCENE_ID
			ORDER BY MKT_ID
        </e:q4l>${e: java2json(marketing_sence_num.list) }
    </e:case>

    <e:description>考核统计_趋势(日) 列表部分</e:description>
	<e:case value="marketing_dzr_day">
		<e:q4l var="marketing_dzr_day">
			select * from (
			select ROWNUM ROW_NUM ,A.*
			from(
			(
			select
			'99' order_date,
			sum(col_num_1) total_count,
			sum(col_num_2) num_1,
			sum(col_num_3) num_2,
			${exec_succ_percent1}
			from ${sql_part_tab_name1} t
			where 1=1
			and t.stat_lvl = 3
			<e:if condition="${!empty param.flag}">
				and t.scene_id='${param.flag}'
			</e:if>
			and t.branch_union_org_code='${param.union_org_code}'
			<e:if condition="${!empty param.grid_id}">
				and t.grid_id = '${param.grid_id}'
			</e:if>
			and substr(t.STAT_DATE,1,6)=to_char(sysdate,'yyyymm')
			UNION ALL
			select
			substr(t1.day_code,7,2) order_date,
			sum(col_num_1) total_count,
			sum(col_num_2) num_1,
			sum(col_num_3) num_2,
			${exec_succ_percent1}
			from ${gis_user}.tb_dim_time t1
			left join ${sql_part_tab_name1} t2 on t2.STAT_DATE=t1.day_code
			and t2.branch_union_org_code='${param.union_org_code}'
			and t2.stat_lvl = 3
			<e:if condition="${! empty param.flag }">
				and t2.scene_id='${param.flag}'
			</e:if>
			where 1 = 1
			and t1.day_code between to_char(trunc(sysdate,'MM'),'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')
			group by substr(t1.day_code, 7, 2)
			order by order_date desc)A))
		</e:q4l>
		${e:java2json(marketing_dzr_day.list) }
	</e:case>

	 <e:description>考核统计网格月汇总统计</e:description>
	 <e:case value="marketing_sence_month_num">
        <e:q4l var="marketing_sence_month_num">
			SELECT '0' SCENE_ID,'全部' MKT_NAME, nvl(SUM(T1.COL_NUM_1),0) MKT_CNT
			FROM EDW.VW_GSCH_MKT_ORDER_STAT_MONTH@GSEDW t1
			WHERE BRANCH_UNION_ORG_CODE = '${param.union_org_code}'
			AND STAT_MONTH ='${param.acct_month}'
			UNION ALL
			SELECT T2.MKT_ID, T2.MKT_NAME, NVL(T1.MKT_CNT, 0) MKT_CNT
			FROM ${sql_part_tab_name2} T2
			LEFT JOIN(
			SELECT t1.SCENE_ID,SUM(T1.COL_NUM_1) MKT_CNT
			FROM EDW.VW_GSCH_MKT_ORDER_STAT_MONTH@GSEDW t1
			WHERE BRANCH_UNION_ORG_CODE = '${param.union_org_code}'
			AND STAT_MONTH = '${param.acct_month}'
			GROUP BY SCENE_ID
			)t1
			ON T2.MKT_ID = T1.SCENE_ID
			ORDER BY SCENE_ID
        </e:q4l>${e: java2json(marketing_sence_month_num.list) }
    </e:case>

	<e:description>考核统计网格月列表</e:description>
    <e:case value="marketing_dzr_month">
          <e:q4l var="marketing_dzr_month">
			SELECT
				branch_name quyuname,
				sum(col_num_1) pd_num,
				sum(col_num_2) zx_num,
				sum(col_num_3) cg_num,
				${exec_succ_percent}
			FROM
				EDW.vw_gsch_mkt_order_stat_month@GSEDW
			where
			  	stat_lvl = 3
				AND branch_union_org_code = '${param.union_org_code}'
				AND stat_month = '${param.acct_month}'
				<e:if condition="${! empty param.flag }">
				and  scene_id='${param.flag}'
				</e:if>
		    group by
				branch_name

		    union all

			SELECT  * FROM (
				SELECT
					GRID_NAME quyuname,
					sum(col_num_1) pd_num,
					sum(col_num_2) zx_num,
					sum(col_num_3) cg_num,
					${exec_succ_percent}
				FROM
					EDW.vw_gsch_mkt_order_stat_month@GSEDW
				where
					grid_union_org_code is not null
					and stat_lvl = 4
					AND branch_union_org_code = '${param.union_org_code}'
					AND stat_month = '${param.acct_month}'
					<e:if condition="${! empty param.flag }">
						and scene_id='${param.flag}'
					</e:if>
				  GROUP BY
				  	GRID_NAME,GRID_SORT
				  ORDER BY
				 	GRID_SORT
			)
        </e:q4l>${e: java2json(marketing_dzr_month.list) }
    </e:case>

	<e:description>考核统计网格日汇总统计</e:description>
	 <e:case value="marketing_sence_wgday_num">
        <e:q4l var="marketing_sence_wgday_num">
			SELECT '0' MKT_ID,'全部' MKT_NAME, nvl(SUM(T1.COL_NUM_1),0) MKT_CNT
			FROM ${sql_part_tab_name1} T1
			WHERE T1.BRANCH_UNION_ORG_CODE = '${param.union_org_code}'
			AND T1.STAT_DATE = TO_CHAR(SYSDATE, 'yyyymmdd')
			AND T1.STAT_LVL = 3
			UNION ALL
			SELECT T2.MKT_ID, T2.MKT_NAME, NVL(T1.MKT_CNT, 0) MKT_CNT
			FROM ${sql_part_tab_name2} T2
			LEFT JOIN (SELECT T1.SCENE_ID, SUM(T1.COL_NUM_1) MKT_CNT
			FROM ${sql_part_tab_name1} T1
			WHERE T1.BRANCH_UNION_ORG_CODE = '${param.union_org_code}'
			AND T1.STAT_DATE = '${param.acct_day}'
			AND T1.STAT_LVL = 3
			GROUP BY T1.SCENE_ID) T1
			ON T2.MKT_ID = T1.SCENE_ID
			ORDER BY MKT_ID
        </e:q4l>${e: java2json(marketing_sence_wgday_num.list) }
    </e:case>

	<e:description>考核统计网格日列表</e:description>
    <e:case value="marketing_dzr_wgday">
		<e:q4l var="marketing_dzr_wgday">
		SELECT *
        FROM ( SELECT
				branch_name quyuname,
				sum(col_num_1) pd_num,
				sum(col_num_2) zx_num,
				sum(col_num_3) cg_num,
				${exec_succ_percent}
          FROM
	            ${sql_part_tab_name1}
         where  stat_lvl = 3
           and  branch_union_org_code = '${param.union_org_code}'
           AND  STAT_DATE = '${param.acct_day}'
                <e:if condition="${!empty param.flag}">
                and scene_id='${param.flag}'
                </e:if>
		  group by
               branch_name)
       union all
	     SELECT  * FROM (
		SELECT
				GRID_NAME QUYUNAME,
				sum(col_num_1) pd_num,
				sum(col_num_2) zx_num,
				sum(col_num_3) cg_num,
				${exec_succ_percent}
		   FROM
		        ${sql_part_tab_name1}
				WHERE grid_union_org_code is not null
		 		and stat_lvl = 4
		   		AND branch_union_org_code = '${param.union_org_code}'
		   		AND STAT_DATE = '${param.acct_day}'
                <e:if condition="${!empty param.flag}">
                and scene_id='${param.flag}'
                </e:if>
		group by
               GRID_NAME
        )
		</e:q4l>${e: java2json(marketing_dzr_wgday.list) }
    </e:case>
</e:switch>