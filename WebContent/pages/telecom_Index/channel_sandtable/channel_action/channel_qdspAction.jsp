<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="tab1">
	<e:description>原表 ${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M</e:description>
	${channel_user}.view_QDSP_CHANNEL_OVERVIEW_M
</e:set>
<e:set var="tab2">
	<e:description>原表 ${gis_user}.db_cde_grid，组织机构码表换为渠道的组织机构码表</e:description>
	${channel_user}.view_tb_gis_channel_org
</e:set>
<e:set var="format0">
	'FM99999999999990'
</e:set>
<e:set var="format1">
	'FM99999999999990.0'
</e:set>
<e:set var="format2">
	'FM99999999999990.00'
</e:set>
<e:set var="empty_fill">
	'0.0'
</e:set>
<e:set var="empty_fill1">
	'0'
</e:set>
<e:set var="fzxy_part">
	TO_CHAR(NVL(CUR_MON_BENEFIT_RATE*100, '0'), 'FM99999999999990.00')||'%' CUR_MON_BENEFIT_RATE,
	TO_CHAR(NVL(CUR_MON_AMOUNT/10000,       '0'), 'FM99999999999990.00') CUR_MON_AMOUNT,
	TO_CHAR(NVL(CUR_MON_INCOME/10000,       '0'), 'FM99999999999990.00') CUR_MON_INCOME,
	TO_CHAR(NVL(CUR_MON_CB/10000,           '0'), 'FM99999999999990.00') CUR_MON_CB,
	nvl(zero_sale_channel,0) zero_sale_channel,
	nvl(low_sale_channel,0) low_sale_channel,
	nvl(high_channel,0) high_channel
</e:set>

<e:switch value="${param.eaction}">
    <e:description>效能概览-效能得分</e:description>
    <e:case value="xn_score">
        <e:q4o var="score_data">
            select '效能概览得分',
				to_char(BJL,'FM99999999999990.00') BJL,
				to_char(YHGML,'FM99999999999990.00') YHGML,
				to_char(YHZTL,'FM99999999999990.00') YHZTL,
				to_char(QDXYL,'FM99999999999990.00') QDXYL,
				to_char(QDXN_CUR_MONTH_SCORE,'FM99999999999990.0') QDXN_CUR_MONTH_SCORE,
				to_char(QDXN_LAST_MONTH_SCORE,'FM99999999999990.00') QDXN_LAST_MONTH_SCORE,
				CZ
			 from
            	${tab1} m
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND m.latn_id = '${param.region_id}'
            </e:if>
            	AND m.flag = '${param.region_type}'
	            AND m.acct_month ='${param.acct_month}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND m.bureau_no = '${param.bureau_no}'
	         </e:if>
        </e:q4o>${e:java2json(score_data)}
    </e:case>
    <e:description>效能概览-效能趋势柱状图</e:description>
    <e:case value="xn_trend">
        <e:q4l var="trend_list">
            <e:description>
            select *
  			from (select *
          from (select month_code
                  from ${channel_user}.tb_dim_time
                 where month_code <= '${param.acct_month1}'
                 group by month_code
                 order by month_code desc)
         WHERE ROWNUM <=6 ) a
         left join ${tab1} m
    		on a.month_code = m.acct_month AND 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
            	AND	m.bureau_no = '${param.bureau_no}'
            </e:if>
            	AND m.flag = '${param.region_type}'
            	order by a.month_code
            </e:description>

            SELECT *
            FROM (SELECT *
            FROM (SELECT MONTH_CODE
            FROM ${gis_user}.TB_DIM_TIME
            WHERE MONTH_CODE >= '${param.acct_month}'
            GROUP BY MONTH_CODE
            ORDER BY MONTH_CODE ASC)
            WHERE ROWNUM <= 6) A
            LEFT JOIN ${tab1} M
            ON A.MONTH_CODE = M.ACCT_MONTH
            AND 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
                AND	m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
                AND	m.bureau_no = '${param.bureau_no}'
            </e:if>
            <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
                AND	m.branch_no = '${param.branch_no}'
            </e:if>
            AND m.flag = '${param.region_type}'
            order by a.month_code
        </e:q4l>${e: java2json(trend_list.list) }
    </e:case>
    <e:description>效能概览-门店类型统计</e:description>
    <e:case value="type_list">
        <e:q4l var="type_list">
        SELECT A.*,ROWNUM FROM (
          SELECT * FROM(
          SELECT  NVL(sum(T.CHANNEL_NUM),0) TOTALNUM,
              D.CHANNEL_TYPE_NAME CHANNEL_TYPE_NAME_QD,
              NVL(to_char(T.AVG_SCORE ,'FM99999999999990.00') ,'--') AVG_SCORE,
              NVL(to_char(T.QDJF_CUR_MONTH ,'FM99999999999990.00') ,'--') CHANNEL_SCORE_SUM,
              NVL(to_char(T.AVG_CHANNEL_QDJF,'FM99999999999990.00') ,'--') AVG_CHANNEL_SCORE
          FROM (select  distinct(c.CHANNEL_TYPE_CODE),c.ord ,c.channel_type_name from ${channel_user}.tb_channel_type c) d
          left join ${channel_user}.TB_QDSP_TYPE_CHANNEL_M T
          on d.channel_type_code = t.channel_type_code_qd
		  <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	T.latn_id = '${param.region_id}'
            </e:if>
			  	AND T.ACCT_MONTH = '${param.acct_month}'
			  	AND T.FLAG = '${param.region_type}'
			<e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
            	AND	T.bureau_no = '${param.bureau_no}'
            </e:if>
		  WHERE 1 = 1
	      GROUP BY
		      	T.CHANNEL_TYPE_CODE_QD,
		      	D.CHANNEL_TYPE_NAME,
		      	T.AVG_SCORE,
		      	T.QDJF_CUR_MONTH,
		      	T.AVG_CHANNEL_QDJF,
		      	d.ord
		  ORDER　BY d.ord)
		  union all
		  SELECT  NVL(sum(T.CHANNEL_NUM),0) TOTALNUM,
              T.CHANNEL_TYPE_NAME_QD CHANNEL_TYPE_NAME_QD,
              NVL(to_char(T.AVG_SCORE ,'FM99999999999990.00') ,'--') AVG_SCORE,
              NVL(to_char(T.QDJF_CUR_MONTH ,'FM99999999999990.00') ,'--') CHANNEL_SCORE_SUM,
              NVL(to_char(T.AVG_CHANNEL_QDJF,'FM99999999999990.00') ,'--') AVG_CHANNEL_SCORE
          FROM ${channel_user}.TB_QDSP_TYPE_CHANNEL_M T
		  WHERE 1 = 1 AND t.channel_type_code_qd is null
		  <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	T.latn_id = '${param.region_id}'
            </e:if>
			  	AND T.ACCT_MONTH = '${param.acct_month}'
			  	AND T.FLAG = '${param.region_type}'
			<e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
            	AND	T.bureau_no = '${param.bureau_no}'
            </e:if>
            GROUP BY t.channel_type_name_qd,
			          T.CHANNEL_TYPE_NAME_QD,
			          T.AVG_SCORE,
			          T.QDJF_CUR_MONTH,
			          T.AVG_CHANNEL_QDJF) A
        </e:q4l>${e: java2json(type_list.list) }
    </e:case>
    <e:description>渠道沙盘-积分构成</e:description>
    <e:case value="share_list">
        <e:q4l var="share_list">
        SELECT A.*,ROWNUM FROM (
	        select '999' LATN_ID,
					'全省' LATN_NAME,
			<e:description>
					QDXN_CUR_MONTH_SCORE,
					QDXN_LAST_MONTH_SCORE,
			</e:description>
					'000' city_order_num
			from
	        	${tab1} t
	        where T.ACCT_MONTH = '${param.acct_month}'
	        	and flag = '0'
	        union all
	          select d.LATN_ID||'' LATN_ID,
					AREA_DESCRIPTION LATN_NAME,
			<e:description>
					QDXN_CUR_MONTH_SCORE,
					QDXN_LAST_MONTH_SCORE,
			</e:description>
					city_order_num
				  from (select DISTINCT latn_id, city_order_num from ${tab2}) d
				  left join ${tab1} t
				    on d.latn_id = t.latn_id
				 where T.ACCT_MONTH = '${param.acct_month}'
				   and flag = '1'
 				order by city_order_num
 				) A
        </e:q4l>${e: java2json(share_list.list) }
    </e:case>
    <e:description>效能概览-排名</e:description>
    <e:case value="xn_rank">
        <c:tablequery>
            SELECT
            	LATN_ID,
				<e:description>
            	to_char(CZ,'FM99999999999990.00') CZ,
                nvl(D.QDXN_CUR_MONTH_SCORE,0) QDXN_CUR_MONTH_SCORE_NUM,
            	to_char(QDXN_CUR_MONTH_SCORE,'FM99999999999990.00') QDXN_CUR_MONTH_SCORE,
                nvl(D.QDJF_CUR_MONTH,0) QDJF_CUR_MONTH_NUM,
            	to_char(QDJF_CUR_MONTH,'FM99999999999990.00') QDJF_CUR_MONTH,
				</e:description>
				0 CZ,
				0 QDXN_CUR_MONTH_SCORE_NUM,
				'0.00' QDXN_CUR_MONTH_SCORE,
				0 QDJF_CUR_MONTH_NUM,
				'0.00' QDJF_CUR_MONTH,
            	AREA_DESCRIPTION,
				BUREAU_NAME,
				BRANCH_NAME
            FROM
            	${tab1} D
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	latn_id = '${param.region_id}'
				AND BUREAU_NAME  IS NOT NULL
            </e:if>
	            AND ACCT_MONTH = '${param.acct_month}'
	            AND FLAG = '${param.region_type}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME  IS NOT NULL
	         </e:if>

        </c:tablequery>
    </e:case>
    <e:description>效能概览-排名</e:description>
    <e:case value="xn_rank_bureau">
        <c:tablequery>
            select
	            row_number() over(order by D.CHANNEL_SCORE desc) as RN,
	            D.CHANNEL_NAME,
	            D.CHANNEL_NBR,
                nvl(D.CHANNEL_SCORE,0) CHANNEL_SCORE_NUM,
	            to_char(D.CHANNEL_SCORE,'FM99999999999990.00') CHANNEL_SCORE,
                nvl(D.QDJF_CUR_MONTH,0) QDJF_CUR_MONTH_NUM,
	            to_char(QDJF_CUR_MONTH,'FM99999999999990.00') QDJF_CUR_MONTH
            from ${channel_user}.TB_QDSP_CHANNEL_M D
            WHERE 1=1
	            AND ACCT_MONTH = '${param.acct_month}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME  IS NOT NULL
	         </e:if>
        </c:tablequery>
    </e:case>
    <e:case value="xn_rank_branch">
        <c:tablequery>
            select
	            row_number() over(order by D.CHANNEL_SCORE desc) as RN,
	            D.CHANNEL_NAME,
	            D.CHANNEL_NBR,
                nvl(D.CHANNEL_SCORE,0) CHANNEL_SCORE_NUM,
	            to_char(D.CHANNEL_SCORE,'FM99999999999990.00') CHANNEL_SCORE,
                nvl(D.QDJF_CUR_MONTH,0) QDJF_CUR_MONTH_NUM,
	            to_char(QDJF_CUR_MONTH,'FM99999999999990.00') QDJF_CUR_MONTH
            from ${channel_user}.TB_QDSP_CHANNEL_M D
            WHERE 1=1
	            AND ACCT_MONTH = '${param.acct_month}'
	         <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND branch_no = '${param.branch_no}'
				AND BRANCH_NAME  IS NOT NULL
	         </e:if>
        </c:tablequery>
    </e:case>

    <e:case value="getIndexForEcharts">
        <e:q4l var="dataList">
            SELECT *
            FROM (SELECT
            <e:if condition="${param.flg eq '1'}">
                t.area_description
            </e:if>
            <e:if condition="${param.flg eq '2'}">
                t.bureau_name
            </e:if>
            org_name,
            NVL(SUM(T.CHANNEL_NUM), 0) TOTALNUM,
            D.CHANNEL_TYPE_NAME CHANNEL_TYPE_NAME_QD,
            NVL(TO_CHAR(T.AVG_SCORE, 'FM99999999999990.00'), '--') AVG_SCORE,
            NVL(TO_CHAR(T.QDJF_CUR_MONTH, 'FM99999999999990.00'), '--') CHANNEL_SCORE_SUM,
            NVL(TO_CHAR(T.AVG_CHANNEL_QDJF, 'FM99999999999990.00'), '--') AVG_CHANNEL_SCORE
            FROM (SELECT DISTINCT (C.CHANNEL_TYPE_CODE),
            C.ORD,
            C.CHANNEL_TYPE_NAME
            FROM ${channel_user}.TB_CHANNEL_TYPE C) D
            LEFT JOIN ${channel_user}.TB_QDSP_TYPE_CHANNEL_M T
            ON D.CHANNEL_TYPE_CODE = T.CHANNEL_TYPE_CODE_QD
            AND T.ACCT_MONTH = '${param.acc_day}'
            AND T.FLAG = '${param.flg}'
            <e:if condition="${param.flg eq '2'}">
                AND t.latn_id = '${param.region_id}'
            </e:if>
            GROUP BY
            <e:if condition="${param.flg eq '1'}">
                t.area_description,
            </e:if>
            <e:if condition="${param.flg eq '2'}">
                t.bureau_name,
            </e:if>
            T.CHANNEL_TYPE_CODE_QD,
            D.CHANNEL_TYPE_NAME,
            T.AVG_SCORE,
            T.QDJF_CUR_MONTH,
            T.AVG_CHANNEL_QDJF,
            D.ORD ORDER BY
            <e:if condition="${param.flg eq '1'}">
                t.area_description,
            </e:if>
            <e:if condition="${param.flg eq '2'}">
                t.bureau_name,
            </e:if>
            D.ORD)
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

	<e:description>New 渠道沙盘 NBS</e:description>
	<e:description>营销积分-积分分布</e:description>
    <e:case value="yxjf_pie_data">
        <e:q4o var="yxjf_data">
        select '营销积分--积分概览',

        	TO_CHAR(CASE WHEN NVL(d.CUR_DAY_JF, 0) < 10000 THEN
               NVL(d.CUR_DAY_JF, ${empty_fill1}) ELSE
               NVL(d.CUR_DAY_JF / 10000, ${empty_fill1})
              END,${format1}) CUR_DAY_JF,

          CASE WHEN NVL(d.CUR_DAY_JF, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END CDJ_FLAG,

          TO_CHAR(CASE WHEN NVL(d.FZ_OF_CUR_DAY_JF, 0) < 10000 THEN
               NVL(d.FZ_OF_CUR_DAY_JF, ${empty_fill}) ELSE
               NVL(d.FZ_OF_CUR_DAY_JF / 10000, ${empty_fill})
              END,${format1}) FZ_OF_CUR_DAY_JF,

          CASE WHEN NVL(d.FZ_OF_CUR_DAY_JF, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END FOCDJ_FLAG,

          TO_CHAR(CASE WHEN NVL(d.CL_OF_CUR_DAY_JF, 0) < 10000 THEN
               NVL(d.CL_OF_CUR_DAY_JF, ${empty_fill}) ELSE
               NVL(d.CL_OF_CUR_DAY_JF / 10000, ${empty_fill})
              END,${format1}) CL_OF_CUR_DAY_JF,

          CASE WHEN NVL(d.CL_OF_CUR_DAY_JF, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END COCDJ_FLAG,

          TO_CHAR(CASE WHEN NVL(d.CUR_MONTH_SUM_JF, 0) < 10000 THEN
               NVL(d.CUR_MONTH_SUM_JF, ${empty_fill}) ELSE
               NVL(d.CUR_MONTH_SUM_JF / 10000, ${empty_fill})
              END,${format1}) CUR_MONTH_SUM_JF,

          CASE WHEN NVL(d.CUR_MONTH_SUM_JF, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END CMSJ_FLAG,

          TO_CHAR(CASE WHEN NVL(d.FZ_OF_CUR_MONTH_SUM_JF, 0) < 10000 THEN
               NVL(d.FZ_OF_CUR_MONTH_SUM_JF, ${empty_fill}) ELSE
               NVL(d.FZ_OF_CUR_MONTH_SUM_JF / 10000, ${empty_fill})
              END,${format1}) FZ_OF_CUR_MONTH_SUM_JF,

          CASE WHEN NVL(d.FZ_OF_CUR_MONTH_SUM_JF, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END FOCMSJ_FLAG,

          TO_CHAR(CASE WHEN NVL(d.CL_OF_CUR_MONTH_SUM_JF, 0) < 10000 THEN
               NVL(d.CL_OF_CUR_MONTH_SUM_JF, ${empty_fill}) ELSE
               NVL(d.CL_OF_CUR_MONTH_SUM_JF / 10000, ${empty_fill})
              END,${format1}) CL_OF_CUR_MONTH_SUM_JF,

          CASE WHEN NVL(d.CL_OF_CUR_MONTH_SUM_JF, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END COCMSJ_FLAG,

          TO_CHAR(CASE WHEN NVL(d.CL_OF_CUR_MONTH_SUM_JF, 0) < 10000 THEN
               NVL(d.CL_OF_CUR_MONTH_SUM_JF, ${empty_fill}) ELSE
               NVL(d.CL_OF_CUR_MONTH_SUM_JF / 10000, ${empty_fill})
              END,${format1}) CL_OF_CUR_MONTH_SUM_JF,

          CASE WHEN NVL(d.CL_OF_CUR_MONTH_SUM_JF, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END COCMSJ_FLAG,

        	<e:description>
					TO_CHAR(NVL(d.CUR_DAY_JF/10000,       '0'), ${format1}) CUR_DAY_JF,
					TO_CHAR(NVL(d.FZ_OF_CUR_DAY_JF/10000, '0.00'), ${format1}) FZ_OF_CUR_DAY_JF,
					TO_CHAR(NVL(d.CL_OF_CUR_DAY_JF/10000, '0.00'), ${format1}) CL_OF_CUR_DAY_JF,
					TO_CHAR(NVL(d.CUR_MONTH_SUM_JF/10000, '0'), ${format1}) CUR_MONTH_SUM_JF,
					TO_CHAR(NVL(d.FZ_OF_CUR_MONTH_SUM_JF/10000, '0.00'), ${format1}) FZ_OF_CUR_MONTH_SUM_JF,
					TO_CHAR(NVL(d.CL_OF_CUR_MONTH_SUM_JF/10000, '0.00'), ${format1}) CL_OF_CUR_MONTH_SUM_JF,
					</e:description>
					fun_div_fmt(d.cur_day_jf,d.user_cur_day_jf) hj_jf,

					TO_CHAR(CASE WHEN NVL(m.cur_mon_jf, 0) < 10000 THEN
               NVL(m.cur_mon_jf, ${empty_fill}) ELSE
               NVL(m.cur_mon_jf / 10000, ${empty_fill})
              END,${format1}) cur_mon_jf,

          CASE WHEN NVL(m.cur_mon_jf, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END cmj_flag,

          TO_CHAR(CASE WHEN NVL(m.fz_of_cur_mon_jf, 0) < 10000 THEN
               NVL(m.fz_of_cur_mon_jf, ${empty_fill}) ELSE
               NVL(m.fz_of_cur_mon_jf / 10000, ${empty_fill})
              END,${format1}) fz_of_cur_mon_jf,

          CASE WHEN NVL(m.fz_of_cur_mon_jf, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END focmj_flag,

          TO_CHAR(CASE WHEN NVL(m.cl_of_cur_mon_jf, 0) < 10000 THEN
               NVL(m.cl_of_cur_mon_jf, ${empty_fill}) ELSE
               NVL(m.cl_of_cur_mon_jf / 10000, ${empty_fill})
              END,${format1}) cl_of_cur_mon_jf,

          CASE WHEN NVL(m.cl_of_cur_mon_jf, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END cocmj_flag,

          TO_CHAR(CASE WHEN NVL(abs(m.zs_of_cur_mon_jf), 0) < 10000 THEN
               NVL(m.zs_of_cur_mon_jf, ${empty_fill}) ELSE
               NVL(m.zs_of_cur_mon_jf / 10000, ${empty_fill})
              END,${format1}) zs_of_cur_mon_jf,

          CASE WHEN NVL(m.zs_of_cur_mon_jf, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END zocmj_flag
					<e:description>
					TO_CHAR(NVL(m.cur_mon_jf/10000, '0'), ${format1}) cur_mon_jf,
					TO_CHAR(NVL(m.fz_of_cur_mon_jf/10000, '0.00'), ${format1}) fz_of_cur_mon_jf,
					TO_CHAR(NVL(m.cl_of_cur_mon_jf/10000, '0.00'), ${format1}) cl_of_cur_mon_jf,
					TO_CHAR(NVL(m.zs_of_cur_mon_jf/10000, '0.00'), ${format1}) zs_of_cur_mon_jf
					</e:description>
			  from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d,
            	${channel_user}.TB_QDSP_STAT_VIEW_M m
            where 1 = 1
            	AND d.flag = '${param.region_type}'
                and m.flag = '${param.region_type}'
	            AND d.acct_day ='${param.acct_day}'
	            and m.acct_month = '${param.acct_month}'
	            <e:if condition="${empty param.region_id}">
								and d.latn_id = m.latn_id
	            </e:if>
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	and d.latn_id = m.latn_id
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
            	and d.bureau_no = m.bureau_no
	            AND d.bureau_no = '${param.bureau_no}'
	          </e:if>
	          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	          	and d.branch_no = m.branch_no
	            AND d.branch_no = '${param.branch_no}'
	          </e:if>

        </e:q4o>${e:java2json(yxjf_data)}
    </e:case>
    <e:description>当月日积分趋势</e:description>
	<e:case value="yxjf_trendList">
		<e:q4l var="DayJF_list">
		select '营销积分趋势',
				<e:if condition="${param.region_type eq '0' || param.region_type eq '1'}" var="not_bureau">
					TO_CHAR(NVL(CUR_DAY_JF,0)/10000, ${format1}) CUR_DAY_JF,
					TO_CHAR(NVL(FZ_OF_CUR_DAY_JF,0)/10000, ${format1}) FZ_OF_CUR_DAY_JF,
					TO_CHAR(NVL(CL_OF_CUR_DAY_JF,0)/10000, ${format1}) CL_OF_CUR_DAY_JF
				</e:if>
				<e:else condition="${not_bureau}">
					TO_CHAR(NVL(CUR_DAY_JF,       '0.00'), ${format1}) CUR_DAY_JF,
					TO_CHAR(NVL(FZ_OF_CUR_DAY_JF, '0.00'), ${format1}) FZ_OF_CUR_DAY_JF,
					TO_CHAR(NVL(CL_OF_CUR_DAY_JF, '0.00'), ${format1}) CL_OF_CUR_DAY_JF
				</e:else>
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND d.bureau_no = '${param.bureau_no}'
	         </e:if>
	         <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND d.branch_no = '${param.branch_no}'
	         </e:if>
            	AND d.flag = '${param.region_type}'
	            AND d.acct_day like '${param.acct_month}%'

	         order by acct_day
		</e:q4l>${e:java2json(DayJF_list.list)}
	</e:case>
	<e:description>当月日积分趋势</e:description>
	<e:description>上月日积分趋势</e:description>
	<e:case value="yxjf_lasttrendList">
		<e:q4l var="LastDayJF_list">
		select '营销积分趋势',
				<e:if condition="${param.region_type eq '0' || param.region_type eq '1'}" var="not_bureau">
					TO_CHAR(NVL(CUR_DAY_JF,0)/10000, ${format1}) CUR_DAY_JF,
					TO_CHAR(NVL(FZ_OF_CUR_DAY_JF,0)/10000, ${format1}) FZ_OF_CUR_DAY_JF,
					TO_CHAR(NVL(CL_OF_CUR_DAY_JF,0)/10000, ${format1}) CL_OF_CUR_DAY_JF
				</e:if>
				<e:else condition="${not_bureau}">
					TO_CHAR(NVL(CUR_DAY_JF,       '0.00'), ${format1}) CUR_DAY_JF,
					TO_CHAR(NVL(FZ_OF_CUR_DAY_JF, '0.00'), ${format1}) FZ_OF_CUR_DAY_JF,
					TO_CHAR(NVL(CL_OF_CUR_DAY_JF, '0.00'), ${format1}) CL_OF_CUR_DAY_JF
				</e:else>
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND d.bureau_no = '${param.bureau_no}'
		         </e:if>
		         <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
		            AND d.branch_no = '${param.branch_no}'
		         </e:if>
            	AND d.flag = '${param.region_type}'
	            AND d.acct_day like '${param.last_month}%'

	         order by acct_day
		</e:q4l>${e:java2json(LastDayJF_list.list)}
	</e:case>

	<e:description>营销积分-区域积分-月</e:description>
	<e:case value="tab3_index_bottom">
		<e:q4l var="dataList">
			select '营销积分-区域积分-月', t.* from (
			select
			<e:if condition="${param.region_type eq '0'}">
				'全省' region_name,
				'0' region_id,
			</e:if>
			<e:if condition="${param.region_type eq '1'}">
				latn_name region_name,
				latn_id region_id,
			</e:if>
			<e:if condition="${param.region_type eq '2'}">
				bureau_name region_name,
				bureau_no region_id,
			</e:if>
			<e:if condition="${param.region_type eq '3'}">
				branch_name region_name,
				branch_no region_id,
			</e:if>
				<e:description>本年积分</e:description>
				<e:if condition="${param.div_10000 eq '1'}" var="div_10000">
					TO_CHAR(NVL(m.cur_year_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_year_jf,
				</e:if>
				<e:else condition="${div_10000}">
					TO_CHAR(NVL(m.cur_year_jf ,'0.00'), 'FM99999999999990.00') cur_year_jf,
				</e:else>
				
				<e:description>本月积分</e:description>
				<e:if condition="${param.div_10000 eq '1'}" var="div_10000_1">
					TO_CHAR(NVL(m.cur_mon_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_mon_jf,
				</e:if>
				<e:else condition="${div_10000_1}">
					TO_CHAR(NVL(m.cur_mon_jf ,'0.00'), 'FM99999999999990.00') cur_mon_jf,
				</e:else>
				<e:description>当月户均</e:description>
				fun_div_fmt(m.cur_mon_jf,m.user_fz_of_cur_mon_jf+m.user_cl_of_cur_mon_jf) cur_mon_hj,
				'0' order_num
			from
				${channel_user}.TB_QDSP_STAT_VIEW_M M
			where m.acct_month = '${param.acct_month}'
				AND m.FLAG = '${param.region_type}'
			<e:if condition="${param.region_type eq '0'}">
			</e:if>
			<e:if condition="${param.region_type eq '1'}">
				and m.latn_id = '${param.latn_id}'
			</e:if>
			<e:if condition="${param.region_type eq '2'}">
				and m.bureau_no = '${param.bureau_no}'
			</e:if>
			<e:if condition="${param.region_type eq '3'}">
				and m.branch_no = '${param.branch_no}'
			</e:if>

			union all

			select
			<e:if condition="${param.region_type eq '0'}">
				m.latn_name region_name,
				m.latn_id||'' region_id,
			</e:if>
			<e:if condition="${param.region_type eq '1'}">
				m.bureau_name region_name,
				m.bureau_no||'' region_id,
			</e:if>
			<e:if condition="${param.region_type eq '2'}">
				m.channel_name region_name,
				m.channel_nbr ||'' region_id,
			</e:if>
			<e:if condition="${param.region_type eq '3'}">
				m.grid_name region_name,
				m.grid_id||'' region_id,
			</e:if>
				TO_CHAR(NVL(m.cur_year_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_year_jf,
				TO_CHAR(NVL(m.cur_mon_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_mon_jf,
				<e:description>当月户均</e:description>
				fun_div_fmt(m.cur_mon_jf,m.user_fz_of_cur_mon_jf+m.user_cl_of_cur_mon_jf) cur_mon_hj,
				<e:if condition="${param.region_type eq '2'}">
					m.channel_nbr||''
				</e:if>
				order_num
			from
				${channel_user}.TB_QDSP_STAT_VIEW_M M
				<e:if condition="${param.region_type eq '0' || param.region_type eq '1'}">
					left join
					(SELECT DISTINCT
					<e:if condition="${param.region_type eq '0'}">
						latn_id region_id,
						latn_name region_name,
						city_order_num order_num
					</e:if>
					<e:if condition="${param.region_type eq '1'}">
						bureau_no region_id,
						bureau_name region_name,
						region_order_num order_num
					</e:if>
					FROM ${tab2}) c
				ON
				<e:if condition="${param.region_type eq '0'}">
					m.latn_id = c.region_id
				</e:if>
				<e:if condition="${param.region_type eq '1'}">
					m.bureau_no = c.region_id
				</e:if>
			</e:if>
				WHERE M.ACCT_MONTH = '${param.acct_month}'
           AND
           <e:if condition="${param.region_type eq '2'}" var="bureau_level">
           		m.flag = '5'
           		and m.channel_spec = '1'
           	</e:if>
           <e:else condition="${bureau_level}">
           		M.FLAG = '${param.region_type+1}'
           </e:else>
       	<e:if condition="${param.region_type eq '0'}">
				</e:if>
				<e:if condition="${param.region_type eq '1'}">
					and m.latn_id = '${param.latn_id}'
				</e:if>
				<e:if condition="${param.region_type eq '2'}">
					and m.bureau_no = '${param.bureau_no}'
				</e:if>
				<e:description>
				<e:if condition="${param.region_type eq '3'}">
					and m.branch_no = '${param.branch_no}'
				</e:if>
				</e:description>
			)t
			order by order_num
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>

	<e:description>营销积分-区域分布</e:description>
    <e:case value="yxjf_area">
        <e:q4l var="yxjf_areaList">
        SELECT '营销积分-区域积分-省市',A.*,
        <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="province">
	        row_number() over(order by to_number(A.region_order_num) asc)-1 as RN
        </e:if>
        <e:else condition="${province}">
        	ROWNUM-1 RN
        </e:else>
        FROM(
            SELECT
            	D.LATN_ID,
				D.LATN_NAME,
				'' BUREAU_NO,
				D.LATN_NAME BUREAU_NAME,
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="iscity">
					'0' region_Order_num,
				</e:if>
				<e:else condition="${iscity}">
					'000' CITY_ORDER_NUM,
				</e:else>
				
				<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000 eq '0'}" var="div_10000">
					TO_CHAR(NVL(CUR_MONTH_SUM_JF ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
				</e:if>
				<e:else condition="${div_10000}">
					TO_CHAR(NVL(CUR_MONTH_SUM_JF/10000 ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
				</e:else>
				
				<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000_1 eq '0'}" var="div_10000_1">
					TO_CHAR(NVL(cur_day_jf ,'0.00'), 'FM99999999999990.00') cur_day_jf,
				</e:if>
				<e:else condition="${div_10000_1}">
					TO_CHAR(NVL(cur_day_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_day_jf,
				</e:else>
				
				TO_CHAR(NVL(CUR_MONTH_FZ/10000,'0.00'), 'FM99999999999990.00') CUR_MONTH_FZ,
				TO_CHAR(NVL(MONTH_FZ_RATE*100,'0.00'), 'FM99999999999990.00')||'%' MONTH_FZ_RATE,
				
				fun_div_fmt(cur_day_jf,user_cur_day_jf) HJ_JF
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
			WHERE 1=1
				<e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
					AND bureau_no = '${param.bureau_no}'
				</e:if>
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
					AND	D.latn_id = '${param.region_id}'
					<e:description>
					AND BUREAU_NAME  IS NOT NULL
					</e:description>
				</e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	            AND FLAG = '${param.region_type}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME IS NOT NULL
	         </e:if>
	         union all
            SELECT
            	D.LATN_ID,
				D.LATN_NAME,
				D.BUREAU_NO,
				D.BUREAU_NAME,
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="iscity">
					t.region_Order_num,
				</e:if>
				<e:else condition="${iscity}">
					t.CITY_ORDER_NUM,
				</e:else>
				<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000 eq '0'}" var="div_10000">
					TO_CHAR(NVL(CUR_MONTH_SUM_JF ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
				</e:if>
				<e:else condition="${div_10000}">
					TO_CHAR(NVL(CUR_MONTH_SUM_JF/10000 ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
				</e:else>
				
				<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000_1 eq '0'}" var="div_10000_1">
					TO_CHAR(NVL(cur_day_jf ,'0.00'), 'FM99999999999990.00') cur_day_jf,
				</e:if>
				<e:else condition="${div_10000_1}">
					TO_CHAR(NVL(cur_day_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_day_jf,
				</e:else>
				
				TO_CHAR(NVL(CUR_MONTH_FZ/10000,'0.00'), 'FM99999999999990.00') CUR_MONTH_FZ,
				TO_CHAR(NVL(MONTH_FZ_RATE*100,'0.00'), 'FM99999999999990.00')||'%' MONTH_FZ_RATE,
				fun_div_fmt(cur_day_jf,user_cur_day_jf) HJ_JF
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="province">
					left join (select distinct bureau_no,bureau_name,region_order_num from ${tab2}) t on d.bureau_no = t.bureau_no
				</e:if>
				<e:else condition="${province}">
					left join (SELECT DISTINCT LATN_ID,CITY_ORDER_NUM from ${tab2}) t on d.latn_id = t.latn_id
				</e:else>
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	D.latn_id = '${param.region_id}'
				<e:description>
				AND BUREAU_NAME  IS NOT NULL
				</e:description>
				AND D.BUREAU_NAME <> '其他'
				AND D.BUREAU_NAME <> '合计'
            </e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	            AND FLAG = '${param.region_type+1}'
	        <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME  IS NOT NULL
	        </e:if>
			<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="city_order">
				ORDER BY region_order_num
			</e:if>
			<e:else condition="${city_order}">
				ORDER BY CITY_ORDER_NUM
			</e:else>
			) A
        </e:q4l>${e:java2json(yxjf_areaList.list)}
        </e:case>
	<e:description>营销积分-区域分布-区县</e:description>
    <e:case value="yxjf_area_bureau">
        <e:q4l var="yxjf_bureauList">
		SELECT '营销积分-区域积分-区县',A.*,
	        row_number() over(order by to_number(A.CUR_MONTH_SUM_JF) desc)-1 as RN
        FROM(
            SELECT
            	D.LATN_ID,
				D.LATN_NAME,
				D.BUREAU_NO,
				D.BUREAU_NAME,
				channel_name BRANCH_NAME,
				<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000 eq '0'}" var="div_10000">
					TO_CHAR(NVL(CUR_MONTH_SUM_JF ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
				</e:if>
				<e:else condition="${div_10000}">
					TO_CHAR(NVL(CUR_MONTH_SUM_JF/10000 ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
				</e:else>
				
				<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000_1 eq '0'}" var="div_10000_1">
					TO_CHAR(NVL(cur_day_jf ,'0.00'), 'FM99999999999990.00') cur_day_jf,
				</e:if>
				<e:else condition="${div_10000_1}">
					TO_CHAR(NVL(cur_day_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_day_jf,
				</e:else>
				
				TO_CHAR(NVL(CUR_MONTH_FZ/10000,'0.00'), 'FM99999999999990.00') CUR_MONTH_FZ,
				TO_CHAR(NVL(MONTH_FZ_RATE*100,'0.00'), 'FM99999999999990.00')||'%' MONTH_FZ_RATE,
				fun_div_fmt(cur_day_jf,user_cur_day_jf) HJ_JF
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	D.latn_id = '${param.region_id}'
				AND BUREAU_NAME  IS NOT NULL
            </e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME  IS NOT NULL
	         </e:if>
	         <e:description>
	            AND FLAG = '${param.region_type+1}'
	         </e:description>
	         and flag = '5'
	         and channel_spec = '1'
			) A
        </e:q4l>${e:java2json(yxjf_bureauList.list)}
    </e:case>
    <e:case value="yxjf_area_branch">
        <e:q4l var="yxjf_bureauList">
				SELECT '营销积分-区域积分-支局',A.*,
	        row_number() over(order by to_number(A.CUR_MONTH_SUM_JF) desc)-1 as RN
        	FROM(
            SELECT
            	D.LATN_ID,
							D.LATN_NAME,
							D.BUREAU_NO,
							D.BUREAU_NAME,
							D.BRANCH_NAME,
							D.GRID_NAME,
							<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000 eq '0'}" var="div_10000">
								TO_CHAR(NVL(CUR_MONTH_SUM_JF ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
							</e:if>
							<e:else condition="${div_10000}">
								TO_CHAR(NVL(CUR_MONTH_SUM_JF/10000 ,'0.00'), 'FM99999999999990.00') CUR_MONTH_SUM_JF,
							</e:else>
							
							<e:if condition="${(param.region_type eq '1' || param.region_type eq '2') && param.div_10000_1 eq '0'}" var="div_10000_1">
								TO_CHAR(NVL(cur_day_jf ,'0.00'), 'FM99999999999990.00') cur_day_jf,
							</e:if>
							<e:else condition="${div_10000_1}">
								TO_CHAR(NVL(cur_day_jf/10000 ,'0.00'), 'FM99999999999990.00') cur_day_jf,
							</e:else>
							TO_CHAR(NVL(MONTH_FZ_RATE*100,'0.00'), 'FM99999999999990.00')||'%' MONTH_FZ_RATE,
							TO_CHAR(NVL(CUR_MONTH_FZ/10000,'0.00'), 'FM99999999999990.00') CUR_MONTH_FZ,
							fun_div_fmt(cur_day_jf,user_cur_day_jf) HJ_JF
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
            WHERE 1=1
            and channel_spec = '1'
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	D.latn_id = '${param.region_id}'
							AND BUREAU_NAME  IS NOT NULL
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
							AND BRANCH_NAME  IS NOT NULL
	         </e:if>
	         <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND branch_no = '${param.branch_no}'
							AND grid_name  IS NOT NULL
	         </e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	            AND FLAG = '${param.region_type+1}'
			) A
        </e:q4l>${e:java2json(yxjf_bureauList.list)}
    </e:case>
    <e:description>New 渠道沙盘 NBS</e:description>
    <e:description>发展规模-区域分析</e:description>
    <e:case value="fzgm_area">
        <e:q4l var="fzgm_areaList">
        SELECT '发展规模-区域分析',A.*,
        <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="province">
	        row_number() over(order by to_number(A.region_Order_Num) asc)-1 as RN
        </e:if>
        <e:else condition="${province}">
        	ROWNUM-1 RN
        </e:else>
        FROM(
            SELECT
            	D.LATN_ID,
				D.LATN_NAME,
				'' BUREAU_NO,
				d.latn_name BUREAU_NAME,
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="iscity">
					'0' region_order_num,
				</e:if>
				<e:else condition="${iscity}">
					'000' CITY_ORDER_NUM,
				</e:else>
				TO_CHAR(NVL(CUR_MONTH_FZ ,'0.00'), 'FM99999999999990') CUR_MONTH_FZ,

				TO_CHAR(NVL(CUR_MONTH_FZ_YD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_YD,
				TO_CHAR(NVL(CUR_MONTH_FZ_KD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_KD,
				TO_CHAR(NVL(CUR_MONTH_FZ_ITV,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_ITV,

				NVL(cur_day_fz_yd,'0') cur_day_fz_yd,
				NVL(cur_day_fz_kd,'0') cur_day_fz_kd,
				NVL(cur_day_fz_itv,'0')  cur_day_fz_itv,

				NVL(last_day_fz_yd,'0')  last_d_yd,
				NVL(last_day_fz_kd,'0')  last_d_kd,
				NVL(last_day_fz_itv,'0') last_d_itv,

				to_char(decode(nvl(last_day_fz_yd,0),0,0,nvl(cur_day_fz_yd,0)/last_day_fz_yd-1),'FM9999999990.00')||'%' d_yd_huan,
				to_char(decode(nvl(last_day_fz_kd,0),0,0,nvl(cur_day_fz_kd,0)/last_day_fz_kd-1),'FM9999999990.00')||'%' d_kd_huan,
				to_char(decode(nvl(last_day_fz_itv,0),0,0,nvl(cur_day_fz_itv,0)/last_day_fz_itv-1),'FM9999999990.00')||'%' d_itv_huan

            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	D.latn_id = '${param.region_id}'
            </e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	            AND FLAG = '${param.region_type}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME  IS NOT NULL
	         </e:if>
	         union all
            SELECT
            	D.LATN_ID,
				D.LATN_NAME,
				D.BUREAU_NO,
				D.BUREAU_NAME,
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="iscity">
					t.region_Order_num,
				</e:if>
				<e:else condition="${iscity}">
					t.CITY_ORDER_NUM,
				</e:else>
				TO_CHAR(NVL(CUR_MONTH_FZ ,'0.00'), 'FM99999999999990') CUR_MONTH_FZ,

				TO_CHAR(NVL(CUR_MONTH_FZ_YD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_YD,
				TO_CHAR(NVL(CUR_MONTH_FZ_KD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_KD,
				TO_CHAR(NVL(CUR_MONTH_FZ_ITV,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_ITV,

				NVL(cur_day_fz_yd,'0') cur_day_fz_yd,
				NVL(cur_day_fz_kd,'0') cur_day_fz_kd,
				NVL(cur_day_fz_itv,'0')  cur_day_fz_itv,

				NVL(last_day_fz_yd,'0')  last_d_yd,
				NVL(last_day_fz_kd,'0')  last_d_kd,
				NVL(last_day_fz_itv,'0') last_d_itv,

				to_char(decode(nvl(last_day_fz_yd,0),0,0,nvl(cur_day_fz_yd,0)/last_day_fz_yd-1),'FM9999999990.00')||'%' d_yd_huan,
				to_char(decode(nvl(last_day_fz_kd,0),0,0,nvl(cur_day_fz_kd,0)/last_day_fz_kd-1),'FM9999999990.00')||'%' d_kd_huan,
				to_char(decode(nvl(last_day_fz_itv,0),0,0,nvl(cur_day_fz_itv,0)/last_day_fz_itv-1),'FM9999999990.00')||'%' d_itv_huan
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="province">
					left join (select distinct bureau_no,bureau_name,region_order_num from ${tab2}) t on d.bureau_no = t.bureau_no
				</e:if>
				<e:else condition="${province}">
					left join (SELECT DISTINCT LATN_ID,CITY_ORDER_NUM from ${tab2}) t on d.latn_id = t.latn_id
				</e:else>
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	D.latn_id = '${param.region_id}'
				AND d.bureau_name <> '其他'
				AND d.bureau_name <> '合计'
			</e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	            AND FLAG = '${param.region_type+1}'
	        <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME  IS NOT NULL
	        </e:if>
			<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="city_order">
				ORDER BY region_order_num
			</e:if>
			<e:else condition="${city_order}">
				ORDER BY CITY_ORDER_NUM
			</e:else>
			) A
        </e:q4l>${e:java2json(fzgm_areaList.list)}
        </e:case>
	<e:description>营销积分-区域分布-区县</e:description>
    <e:case value="fzgm_area_bureau">
        <e:q4l var="fzgm_bureauList">
        SELECT '发展规模-区域发展',A.*,
	        row_number() over(order by to_number(CUR_MONTH_FZ) desc)-1 as RN
        FROM(
            SELECT
            	D.LATN_ID,
				D.LATN_NAME,
				D.BUREAU_NO,
				D.BUREAU_NAME,
				channel_name BRANCH_NAME,
				TO_CHAR(NVL(CUR_MONTH_FZ ,'0.00'), 'FM99999999999990') CUR_MONTH_FZ,

				TO_CHAR(NVL(CUR_MONTH_FZ_YD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_YD,
				TO_CHAR(NVL(CUR_MONTH_FZ_KD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_KD,
				TO_CHAR(NVL(CUR_MONTH_FZ_ITV,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_ITV,

				NVL(cur_day_fz_yd,'0') cur_day_fz_yd,
				NVL(cur_day_fz_kd,'0') cur_day_fz_kd,
				NVL(cur_day_fz_itv,'0')  cur_day_fz_itv,

				NVL(last_day_fz_yd,'0')  last_d_yd,
				NVL(last_day_fz_kd,'0')  last_d_kd,
				NVL(last_day_fz_itv,'0') last_d_itv,

				to_char(decode(nvl(last_day_fz_yd,0),0,0,nvl(cur_day_fz_yd,0)/last_day_fz_yd-1),'FM9999999990.00')||'%' d_yd_huan,
				to_char(decode(nvl(last_day_fz_kd,0),0,0,nvl(cur_day_fz_kd,0)/last_day_fz_kd-1),'FM9999999990.00')||'%' d_kd_huan,
				to_char(decode(nvl(last_day_fz_itv,0),0,0,nvl(cur_day_fz_itv,0)/last_day_fz_itv-1),'FM9999999990.00')||'%' d_itv_huan

            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	D.latn_id = '${param.region_id}'
				AND BUREAU_NAME  IS NOT NULL
            </e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
				AND BRANCH_NAME  IS NOT NULL
	         </e:if>
	         <e:description>
	            AND FLAG = '${param.region_type+1}'
	         </e:description>
	         and flag = '5'
	         and channel_spec = '1'
			) A
        </e:q4l>${e:java2json(fzgm_bureauList.list)}
    </e:case>

    <e:description>营销积分-区域分布-支局</e:description>
    <e:case value="fzgm_area_branch">
        <e:q4l var="fzgm_bureauList">
        SELECT '发展规模-区域发展-支局',A.*,
	        row_number() over(order by to_number(CUR_MONTH_FZ) desc)-1 as RN
        FROM(
            SELECT
            	D.LATN_ID,
				D.LATN_NAME,
				D.BUREAU_NO,
				D.BUREAU_NAME,
				D.BRANCH_NAME,
				D.GRID_NAME,
				TO_CHAR(NVL(CUR_MONTH_FZ ,'0.00'), 'FM99999999999990') CUR_MONTH_FZ,

				TO_CHAR(NVL(CUR_MONTH_FZ_YD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_YD,
				TO_CHAR(NVL(CUR_MONTH_FZ_KD,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_KD,
				TO_CHAR(NVL(CUR_MONTH_FZ_ITV,'0.00'), 'FM99999999999990') CUR_MONTH_FZ_ITV,

				NVL(cur_day_fz_yd,'0') cur_day_fz_yd,
				NVL(cur_day_fz_kd,'0') cur_day_fz_kd,
				NVL(cur_day_fz_itv,'0')  cur_day_fz_itv,

				NVL(last_day_fz_yd,'0')  last_d_yd,
				NVL(last_day_fz_kd,'0')  last_d_kd,
				NVL(last_day_fz_itv,'0') last_d_itv,

				to_char(decode(nvl(last_day_fz_yd,0),0,0,nvl(cur_day_fz_yd,0)/last_day_fz_yd-1),'FM9999999990.00')||'%' d_yd_huan,
				to_char(decode(nvl(last_day_fz_kd,0),0,0,nvl(cur_day_fz_kd,0)/last_day_fz_kd-1),'FM9999999990.00')||'%' d_kd_huan,
				to_char(decode(nvl(last_day_fz_itv,0),0,0,nvl(cur_day_fz_itv,0)/last_day_fz_itv-1),'FM9999999990.00')||'%' d_itv_huan
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_D D
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	D.latn_id = '${param.region_id}'
							AND BUREAU_NAME  IS NOT NULL
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
							AND BRANCH_NAME  IS NOT NULL
	          </e:if>
	          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND branch_no = '${param.branch_no}'
							AND grid_name  IS NOT NULL
	          </e:if>
	            AND ACCT_DAY = '${param.acct_day}'
	            AND FLAG = '${param.region_type+1}'
			) A
        </e:q4l>${e:java2json(fzgm_bureauList.list)}
    </e:case>
	<e:description>渠道效能-门店分析</e:description>
    <e:case value="qdxn_pie_data">
        <e:q4o var="qdxn_data">
            select '渠道效能',
				NVL(SUM(CHANNEL_NUM),       '0') CHANNEL_NUM,
				NVL(SUM(SALE_CHANNEL_NUM), '0') SALE_CHANNEL_NUM,
				NVL(SUM(SINGLE_CHANNEL_NUM), '0') SINGLE_CHANNEL_NUM,
				NVL(SUM(HIGH_CHANNEL), '0') HIGH_CHANNEL,
				NVL(SUM(LOW_SALE_CHANNEL), '0') LOW_SALE_CHANNEL,
				NVL(SUM(ZERO_SALE_CHANNEL), '0') ZERO_SALE_CHANNEL,
				CASE WHEN SUM(CHANNEL_NUM) = 0 THEN '0'
				ELSE TO_CHAR(NVL((SUM(HIGH_CHANNEL)/SUM(CHANNEL_NUM))*100,'0.00'),'FM999999990.00') END HIGH_CHANNEL_RATE,
				CASE WHEN SUM(CHANNEL_NUM) = 0 THEN '0'
				ELSE TO_CHAR(NVL((SUM(LOW_SALE_CHANNEL)/SUM(CHANNEL_NUM))*100,'0.00'),'FM999999990.00') END LOW_SALE_CHANNEL_RATE,
				CASE WHEN SUM(CHANNEL_NUM) = 0 THEN '0'
				ELSE TO_CHAR(NVL((SUM(ZERO_SALE_CHANNEL)/SUM(CHANNEL_NUM))*100,'0.00'),'FM999999990.00') END ZERO_SALE_CHANNEL_RATE
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND d.bureau_no = '${param.bureau_no}'
	          </e:if>
	          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND d.branch_no = '${param.branch_no}'
	          </e:if>
            	AND d.flag = '${param.region_type}'
	            AND d.acct_day ='${param.acct_day}'

        </e:q4o>${e:java2json(qdxn_data)}
    </e:case>
	<e:description>渠道效能-发展量分析</e:description>
    <e:case value="qdxn_dev_data">
    <e:description>
        <e:q4o var="qdxn_data">
            select '渠道效能',
				NVL(CUR_DAY_FZ_YD+ CUR_DAY_FZ_KD+ CUR_DAY_FZ_ITV,       '0') TOTAL_DEV_NUM,
				NVL(CUR_DAY_FZ_YD,       '0') YD_DEV_NUM,
				NVL(CUR_DAY_FZ_KD,       '0') KD_DEV_NUM,
				NVL(CUR_DAY_FZ_ITV,      '0') ITV_DEV_NUM,
				TO_CHAR(NVL((CUR_DAY_FZ_YD/(CUR_DAY_FZ_YD+ CUR_DAY_FZ_KD+ CUR_DAY_FZ_ITV))*100,       '0'), 'FM99999999999990.00')||'%' YD_DEV_RATE,
				TO_CHAR(NVL((CUR_DAY_FZ_KD/(CUR_DAY_FZ_YD+ CUR_DAY_FZ_KD+ CUR_DAY_FZ_ITV))*100,       '0'), 'FM99999999999990.00')||'%' KD_DEV_RATE,
				TO_CHAR(NVL((CUR_DAY_FZ_ITV/(CUR_DAY_FZ_YD+ CUR_DAY_FZ_KD+ CUR_DAY_FZ_ITV))*100,      '0'), 'FM99999999999990.00')||'%' ITV_DEV_RATE
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            	AND d.flag = '${param.region_type}'
	            AND d.acct_day ='${param.acct_day}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND d.bureau_no = '${param.bureau_no}'
	         </e:if>
        </e:q4o>${e:java2json(qdxn_data)}
    </e:description>
	    <e:q4l var="fzxn_list">
			select '发展效能趋势',
					TO_CHAR(NVL(CUR_DAY_FZ_YD/10000,       '0.00'), 'FM99999999999990.00') CUR_DAY_FZ_YD,
					TO_CHAR(NVL(CUR_DAY_FZ_KD/10000, '0.00'), 'FM99999999999990.00') CUR_DAY_FZ_KD,
					TO_CHAR(NVL(CUR_DAY_FZ_ITV/10000, '0.00'), 'FM99999999999990.00') CUR_DAY_FZ_ITV
				 from
	            	${channel_user}.TB_QDSP_STAT_VIEW_D d
	            where 1 = 1
	            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
	            	AND d.latn_id = '${param.region_id}'
	            </e:if>
	            	AND d.flag = '${param.region_type}'
		            AND d.acct_day like '${param.acct_month}%'
		         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
		            AND d.bureau_no = '${param.bureau_no}'
		         </e:if>
		         order by acct_day
			</e:q4l>${e:java2json(fzxn_list.list)}
    </e:case>
    <e:description>发展规模-发展趋势 规模趋势</e:description>
	<e:case value="fzxn_trendList">
		<e:q4l var="fzxn_list">
		select '发展规模-发展趋势-本月',
				<e:if condition="${param.region_type eq '0'}" var="is_province">
					TO_CHAR(NVL(CUR_DAY_FZ_YD,0)/10000, ${format2}) CUR_DAY_FZ_YD,
					TO_CHAR(NVL(CUR_DAY_FZ_KD,0)/10000, ${format2}) CUR_DAY_FZ_KD,
					TO_CHAR(NVL(CUR_DAY_FZ_ITV,0)/10000, ${format2}) CUR_DAY_FZ_ITV
				</e:if>
				<e:else condition="${is_province}">
					TO_CHAR(NVL(CUR_DAY_FZ_YD,0), ${format0}) CUR_DAY_FZ_YD,
					TO_CHAR(NVL(CUR_DAY_FZ_KD,0), ${format0}) CUR_DAY_FZ_KD,
					TO_CHAR(NVL(CUR_DAY_FZ_ITV,0), ${format0}) CUR_DAY_FZ_ITV
				</e:else>
				
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND d.bureau_no = '${param.bureau_no}'
	          </e:if>
	          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND d.branch_no = '${param.branch_no}'
	          </e:if>
            	AND d.flag = '${param.region_type}'
	            AND d.acct_day like '${param.acct_month}%'

	         order by acct_day
		</e:q4l>${e:java2json(fzxn_list.list)}
	</e:case>
	<e:description>当月日积分趋势</e:description>
	<e:description>上月日积分趋势</e:description>
	<e:case value="fzxn_lasttrendList">
		<e:q4l var="Lastfzxn_list">
		select '发展规模-发展趋势-上月',
				<e:if condition="${param.region_type eq '0'}" var="is_province">
					TO_CHAR(NVL(CUR_DAY_FZ_YD,0)/10000, ${format2}) CUR_DAY_FZ_YD,
					TO_CHAR(NVL(CUR_DAY_FZ_KD,0)/10000, ${format2}) CUR_DAY_FZ_KD,
					TO_CHAR(NVL(CUR_DAY_FZ_ITV,0)/10000, ${format2}) CUR_DAY_FZ_ITV
				</e:if>
				<e:else condition="${is_province}">
					TO_CHAR(NVL(CUR_DAY_FZ_YD,0), ${format0}) CUR_DAY_FZ_YD,
					TO_CHAR(NVL(CUR_DAY_FZ_KD,0), ${format0}) CUR_DAY_FZ_KD,
					TO_CHAR(NVL(CUR_DAY_FZ_ITV,0), ${format0}) CUR_DAY_FZ_ITV
				</e:else>
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND d.bureau_no = '${param.bureau_no}'
	          </e:if>
	          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND d.branch_no = '${param.branch_no}'
	          </e:if>
            	AND d.flag = '${param.region_type}'
	            AND d.acct_day like '${param.last_month}%'
	         order by acct_day
		</e:q4l>${e:java2json(Lastfzxn_list.list)}
	</e:case>
	<e:description>效能概览-效能趋势柱状图</e:description>
    <e:case value="xn_trend1">
        <e:q4l var="trend_list">
            SELECT *
            FROM (SELECT *
            FROM (SELECT MONTH_CODE
            FROM ${gis_user}.TB_DIM_TIME
            WHERE MONTH_CODE >= '${param.acct_month}'
            GROUP BY MONTH_CODE
            ORDER BY MONTH_CODE ASC)
            WHERE ROWNUM <= 6) A
            LEFT JOIN ${tab1} M
            ON A.MONTH_CODE = M.ACCT_MONTH
            AND 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
                AND	m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
                AND	m.bureau_no = '${param.bureau_no}'
            </e:if>
            AND m.flag = '${param.region_type}'
            order by a.month_code
        </e:q4l>${e: java2json(trend_list.list) }
    </e:case>
    <e:description>发展质态-毛利率柱状图</e:description>
    <e:case value="ml_trend">
        <e:q4l var="mltrend_list">
            SELECT 
            '发展质态-质态趋势柱图',
            MONTH_CODE,
            to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), ${format1}) CUR_MON_ACTIVE_RATE,
            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), ${format1}) CUR_MON_BILLING_RATE,
            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), ${format1}) CUR_MON_REMOVE_RATE,
            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE
            FROM (SELECT *
            FROM (SELECT MONTH_CODE
            FROM ${gis_user}.TB_DIM_TIME
            WHERE MONTH_CODE >= '${param.acct_month}'
            GROUP BY MONTH_CODE
            ORDER BY MONTH_CODE ASC)
            WHERE ROWNUM <= 6) A
            LEFT JOIN ${channel_user}.TB_QDSP_STAT_VIEW_M M
            ON A.MONTH_CODE = M.ACCT_MONTH
            AND 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
                AND	m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
                AND	m.bureau_no = '${param.bureau_no}'
            </e:if>
            <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
                AND	m.branch_no = '${param.branch_no}'
            </e:if>
            AND m.flag = '${param.region_type}'
            order by a.month_code
        </e:q4l>${e: java2json(mltrend_list.list) }
    </e:case>
	<e:description>发展质态-区域质态</e:description>
    <e:case value="fzzt_type_list">
        <e:q4l var="fzzt_type_list">
            SELECT '发展质态-区域质态',
				TO_CHAR(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'),'FM99999999999990.00')||'%' CUR_MON_ACTIVE_RATE,
				TO_CHAR(NVL(CUR_MON_BILLING_RATE*100,'0.00'),'FM99999999999990.00')||'%' CUR_MON_BILLING_RATE,
				TO_CHAR(NVL(CUR_MON_REMOVE_RATE*100,'0.00'),'FM99999999999990.00')||'%' CUR_MON_REMOVE_RATE,
				'0.00%' DNA_AVE_RATE,
				e.ENTITY_CHANNEL_TYPE_NAME
			 FROM
			 entity_channel_type e left join (select * from
            ${channel_user}.TB_QDSP_STAT_VIEW_M m where M.ACCT_MONTH = '${param.acct_month}'
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
                AND	m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
                AND	m.bureau_no = '${param.bureau_no}'
            </e:if>
            <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
                AND	m.branch_no = '${param.branch_no}'
            </e:if>
            AND m.flag = '${param.region_type}'
            AND m.ENTITY_CHANNEL_TYPE_NAME IS NOT NULL)
            m on e.entity_channel_type = m.entity_channel_type
            order by e.ENTITY_CHANNEL_TYPE_NAME DESC
        </e:q4l>${e: java2json(fzzt_type_list.list) }
    </e:case>
    <e:description>发展质态-区域分布</e:description>
    <e:case value="fzzt_area">
        <e:q4l var="fzzt_areaList">
        SELECT '发展质态-区域质态',A.*,
        	ROWNUM-1 RN
        FROM(
            SELECT
            	M.LATN_ID,
				M.LATN_NAME,
				M.BUREAU_NO,
				M.LATN_NAME BUREAU_NAME,
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="iscity">
					'0' region_order_num,
	            </e:if>
	            <e:else condition="${iscity}">
					'000' CITY_ORDER_NUM,
	            </e:else>
							to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_ACTIVE_RATE,
	            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_BILLING_RATE,
	            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_REMOVE_RATE,
	            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE,

							<e:description>本月宽带活跃率</e:description>
							fun_rate_fmt(kd_active_user,kd_user) cur_mon_kd_active_rate,
	            <e:description>本月宽带离网率</e:description>
	            fun_rate_fmt(kd_lw_cnt,kd_jf_cnt) cur_mon_kd_remove_rate,

	            <e:description>本月ITV活跃率</e:description>
							'--' cur_mon_itv_active_rate,
	            <e:description>本月ITV离网率</e:description>
	            '--' cur_mon_itv_remove_rate

            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_M M
            WHERE 1=1
	            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	M.latn_id = '${param.region_id}'
	            </e:if>
		         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
		            AND bureau_no = '${param.bureau_no}'
	         	</e:if>
	            AND ACCT_MONTH = '${param.acct_month}'

		        AND FLAG = '${param.region_type}'

	         union all

            SELECT
            	M.LATN_ID,
				M.LATN_NAME,
				M.BUREAU_NO,
				M.BUREAU_NAME,
				<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="iscity">
					t.region_order_Num,
	            </e:if>
	            <e:else condition="${iscity}">
					t.CITY_ORDER_NUM,
	            </e:else>
				to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_ACTIVE_RATE,
	            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_BILLING_RATE,
	            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_REMOVE_RATE,
	            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE,

							<e:description>本月宽带活跃率</e:description>
							fun_rate_fmt(kd_active_user,kd_user) cur_mon_kd_active_rate,
	            <e:description>本月宽带离网率</e:description>
	            fun_rate_fmt(kd_lw_cnt,kd_jf_cnt) cur_mon_kd_remove_rate,

	            <e:description>本月ITV活跃率</e:description>
							'--' cur_mon_itv_active_rate,
	            <e:description>本月ITV离网率</e:description>
	            '--' cur_mon_itv_remove_rate
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_M M
            	<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="province">
					left join (select distinct bureau_no,bureau_name,region_order_num from ${tab2}) t on m.bureau_no = t.bureau_no
	            </e:if>
	            <e:else condition="${province}">
		            left join (SELECT DISTINCT LATN_ID,CITY_ORDER_NUM from ${tab2}) t on M.latn_id = t.latn_id
	            </e:else>

            WHERE 1=1
            	<e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="province">
            		AND	M.latn_id = '${param.region_id}'
	            </e:if>
		         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
		            AND bureau_no = '${param.bureau_no}'
	         	</e:if>
	            AND ACCT_MONTH = '${param.acct_month}'

		        AND FLAG = '${param.region_type+1}'
		        <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}" var="city_order">
					ORDER BY region_order_num
	            </e:if>
	            <e:else condition="${city_order}">
					ORDER BY CITY_ORDER_NUM
	            </e:else>
			) A
        </e:q4l>${e:java2json(fzzt_areaList.list)}
        </e:case>
	<e:description>营销积分-区域分布-区县</e:description>
    <e:case value="fzzt_area_bureau">
        <e:q4l var="fzzt_bureauList">
            SELECT
            	M.LATN_ID,
				M.LATN_NAME,
				M.BUREAU_NO,
				M.BUREAU_NAME,
				M.BUREAU_NAME BRANCH_NAME,
				to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_ACTIVE_RATE,
	            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_BILLING_RATE,
	            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_REMOVE_RATE,
	            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE,

							<e:description>本月宽带活跃率</e:description>
							fun_rate_fmt(kd_active_user,kd_user) cur_mon_kd_active_rate,
	            <e:description>本月宽带离网率</e:description>
	            fun_rate_fmt(kd_lw_cnt,kd_jf_cnt) cur_mon_kd_remove_rate,

	            <e:description>本月ITV活跃率</e:description>
							'--' cur_mon_itv_active_rate,
	            <e:description>本月ITV离网率</e:description>
	            '--' cur_mon_itv_remove_rate
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_M M
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	M.latn_id = '${param.region_id}'
            </e:if>
	            AND ACCT_MONTH = '${param.acct_month}'
	         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
	         </e:if>
	            AND FLAG = '${param.region_type}'

	            union all

	            SELECT
	            	M.LATN_ID,
					M.LATN_NAME,
					M.BUREAU_NO,
					M.BUREAU_NAME,
					m.channel_name BRANCH_NAME,
					to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_ACTIVE_RATE,
		            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_BILLING_RATE,
		            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_REMOVE_RATE,
		            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE,

							<e:description>本月宽带活跃率</e:description>
							fun_rate_fmt(kd_active_user,kd_user) cur_mon_kd_active_rate,
	            <e:description>本月宽带离网率</e:description>
	            fun_rate_fmt(kd_lw_cnt,kd_jf_cnt) cur_mon_kd_remove_rate,

	            <e:description>本月ITV活跃率</e:description>
							'--' cur_mon_itv_active_rate,
	            <e:description>本月ITV离网率</e:description>
	            '--' cur_mon_itv_remove_rate
	            FROM
	            	${channel_user}.TB_QDSP_STAT_VIEW_M M
	            WHERE 1=1
	            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
	            	AND	M.latn_id = '${param.region_id}'
	            </e:if>
		            AND ACCT_MONTH = '${param.acct_month}'
		         <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
		            AND bureau_no = '${param.bureau_no}'
		         </e:if>
		         <e:description>
		            AND FLAG = '${param.region_type+1}'
		         </e:description>
		         	and flag = '5'
		         	and channel_spec = '1'
        </e:q4l>${e:java2json(fzzt_bureauList.list)}
    </e:case>

    <e:description>营销积分-区域分布-支局</e:description>
    <e:case value="fzzt_area_branch">
        <e:q4l var="fzzt_bureauList">
            SELECT
            	M.LATN_ID,
				M.LATN_NAME,
				M.BUREAU_NO,
				M.BUREAU_NAME,
				M.BRANCH_NAM) BRANCH_NAME,
				nvl(M.GRID_NAME,'合计') GRID_NAME,
				to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_ACTIVE_RATE,
	            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_BILLING_RATE,
	            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_REMOVE_RATE,
	            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE,

							<e:description>本月宽带活跃率</e:description>
							fun_rate_fmt(kd_active_user,kd_user) cur_mon_kd_active_rate,
	            <e:description>本月宽带离网率</e:description>
	            fun_rate_fmt(kd_lw_cnt,kd_jf_cnt) cur_mon_kd_remove_rate,

	            <e:description>本月ITV活跃率</e:description>
							'--' cur_mon_itv_active_rate,
	            <e:description>本月ITV离网率</e:description>
	            '--' cur_mon_itv_remove_rate
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_M M
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND	M.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND bureau_no = '${param.bureau_no}'
		        </e:if>
		        <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
		          AND branch_no = '${param.branch_no}'
		        </e:if>
	            AND ACCT_MONTH = '${param.acct_month}'

	            AND FLAG = '${param.region_type}'

	            union all

	            SELECT
	            	M.LATN_ID,
					M.LATN_NAME,
					M.BUREAU_NO,
					M.BUREAU_NAME,
					M.BRANCH_NAME,
					m.grid_name,
					to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_ACTIVE_RATE,
		            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_BILLING_RATE,
		            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), 'FM99999999999990.00')||'%' CUR_MON_REMOVE_RATE,
		            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE,

							<e:description>本月宽带活跃率</e:description>
							fun_rate_fmt(kd_active_user,kd_user) cur_mon_kd_active_rate,
	            <e:description>本月宽带离网率</e:description>
	            fun_rate_fmt(kd_lw_cnt,kd_jf_cnt) cur_mon_kd_remove_rate,

	            <e:description>本月ITV活跃率</e:description>
							'--' cur_mon_itv_active_rate,
	            <e:description>本月ITV离网率</e:description>
	            '--' cur_mon_itv_remove_rate
	            FROM
	            	${channel_user}.TB_QDSP_STAT_VIEW_M M
	            WHERE 1=1
	            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
	            	AND	M.latn_id = '${param.region_id}'
	            </e:if>
	            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
		            AND bureau_no = '${param.bureau_no}'
		          </e:if>
		          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
		            AND branch_no = '${param.branch_no}'
		          </e:if>
		            AND ACCT_MONTH = '${param.acct_month}'
		            AND FLAG = '${param.region_type+1}'

        </e:q4l>${e:java2json(fzzt_bureauList.list)}
    </e:case>
    
    <e:description>发展效益-区域效益 各级通用</e:description>
    <e:case value="fzxy_area">
        <e:q4l var="dataList">
            SELECT
            	'发展效益-区域效益',
	            <e:if condition="${param.region_type eq '0' || param.region_type eq '1'}">
	            	m.latn_id
	            </e:if>
	            <e:if condition="${param.region_type eq '2'}">
	            	m.bureau_no	
	            </e:if>
	            region_id,
	            
	            <e:if condition="${param.region_type eq '0' || param.region_type eq '1'}">
	            	m.latn_name
	            </e:if>
	            <e:if condition="${param.region_type eq '2'}">
	            	m.bureau_name
	            </e:if>
	            region_name,
	            '0' order_num,
	            ${fzxy_part}
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_M M
            WHERE 
            		ACCT_MONTH = '${param.acct_month}'
            		AND FLAG = '${param.region_type}'
            	<e:if condition="${param.region_type eq '1'}">
            		and m.latn_id = '${param.region_id}'
            	</e:if>
            	<e:if condition="${param.region_type eq '2'}">
            		and m.bureau_no = '${param.bureau_no}'
            	</e:if>

	          union all

            SELECT
            	'',
            	<e:if condition="${param.region_type eq '0'}">
	            	m.latn_id
	            </e:if>
	            <e:if condition="${param.region_type eq '1'}">
	            	m.bureau_no	
	            </e:if>
	            <e:if condition="${param.region_type eq '2'}">
	            	m.channel_nbr	
	            </e:if>
	            region_id,
	            
	            <e:if condition="${param.region_type eq '0'}">
	            	m.latn_name
	            </e:if>
	            <e:if condition="${param.region_type eq '1'}">
	            	m.bureau_name
	            </e:if>
	            <e:if condition="${param.region_type eq '2'}">
	            	m.channel_name
	            </e:if>
	            region_name,
	            <e:if condition="${param.region_type eq '0'}">
	            	t.city_order_num
	          	</e:if>
	          	<e:if condition="${param.region_type eq '1'}">
	          		t.region_order_num	
	          	</e:if>
	          	<e:if condition="${param.region_type eq '2'}">
	            	m.channel_name
	            </e:if>
	            order_num,
							${fzxy_part}
            FROM
            	${channel_user}.TB_QDSP_STAT_VIEW_M M
            	<e:if condition="${param.region_type eq '0'}">
            		left join (SELECT DISTINCT LATN_ID,CITY_ORDER_NUM from ${tab2}) t on M.latn_id = t.latn_id
            	</e:if>
            	<e:if condition="${param.region_type eq '1'}">
            		left join (select distinct bureau_no,bureau_name,region_order_num,city_order_num from ${tab2} where latn_id = '${param.region_id}') t on m.bureau_no = t.bureau_no
            	</e:if>
            WHERE 
            		ACCT_MONTH = '${param.acct_month}'
            	<e:if condition="${param.region_type eq '0' || param.region_type eq '1'}">
            		and flag = '${param.region_type+1}'
            	</e:if>
            	<e:if condition="${param.region_type eq '2'}">
            		and flag = '5'
            		and channel_spec = '1'
            	</e:if>
            	<e:if condition="${param.region_type eq '1'}">
            		AND	M.latn_id = '${param.region_id}'
	            </e:if>
		          <e:if condition="${param.region_type eq '2'}">
		            AND m.bureau_no = '${param.bureau_no}'
	         		</e:if>
		        order by order_num
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

	<e:description>发展效益-效益分析</e:description>
    <e:case value="qdxy_analyze_data">
        <e:q4o var="qdxy_data">
            select '渠道效益',
					TO_CHAR(NVL(CUR_MON_BENEFIT_RATE*100, '0'), ${format1}) CUR_MON_BENEFIT_RATE,
					TO_CHAR(NVL(CUR_MON_INCOME/10000,       '0'), ${format1}) CUR_MON_INCOME,
					TO_CHAR(NVL(CUR_MON_CB/10000,           '0'), ${format1}) CUR_MON_CB,
					to_char(CASE WHEN NVL(CUR_MON_100_INCOME, 0) < 10000 THEN
               NVL(CUR_MON_100_INCOME, ${empty_fill}) ELSE
               NVL(CUR_MON_100_INCOME / 10000, ${empty_fill})
              END,${format1}) CUR_MON_100_INCOME,

          CASE WHEN NVL(CUR_MON_100_INCOME, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END cmi_flag,

					to_char(CASE WHEN NVL(CUR_MON_100_USER, 0) < 10000 THEN
               NVL(CUR_MON_100_USER, ${empty_fill}) ELSE
               NVL(CUR_MON_100_USER / 10000, ${empty_fill})
              END,${format1}) CUR_MON_100_USER,

					CASE WHEN NVL(CUR_MON_100_USER, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END cm_flag,
              
          to_char(CASE WHEN NVL(last_mon_100_user, 0) < 10000 THEN
               NVL(last_mon_100_user, ${empty_fill}) ELSE
               NVL(last_mon_100_user / 10000, ${empty_fill})
              END,${format1}) last_mon_100_user,

					CASE WHEN NVL(last_mon_100_user, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END lm_flag,

          to_char(CASE WHEN NVL(cur_mon_amount, 0) < 10000 THEN
               NVL(cur_mon_amount, ${empty_fill}) ELSE
               NVL(cur_mon_amount / 10000, ${empty_fill})
              END,${format1}) cur_mon_amount,

          CASE WHEN NVL(cur_mon_amount, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END ml_flag,

					TO_CHAR(NVL((CUR_MONTH_PRODUCT_REWARD+CUR_MONTH_FC_REWARD)/10000,       '0'), 'FM99999999999990.00') CUR_MONTH_ALL_FC,
					TO_CHAR(NVL((CUR_MONTH_ARRIVE_REWARD+CUR_MONTH_SALE_REWARD+CUR_MONTH_TMN_REWARD)/10000,       '0'), 'FM99999999999990.00') CUR_MONTH_ALL_JL,
					TO_CHAR(NVL((CUR_MONTH_FZ_REWARD+CUR_MONTH_SERVICE_REWARD+CUR_MONTH_CZ_JF_REWARD)/10000,       '0'), 'FM99999999999990.00') CUR_MONTH_ALL_YJ,
					TO_CHAR(NVL((CUR_MONTH_HOUSE_REWARD+CUR_MONTH_ZX_REWARD+CUR_MONTH_OTHER_REWARD)/10000,       '0'), 'FM99999999999990.00') CUR_MONTH_ALL_ZC,

					to_char(CASE WHEN NVL(cur_mon_jf_income, 0) < 10000 THEN
               NVL(cur_mon_jf_income, ${empty_fill}) ELSE
               NVL(cur_mon_jf_income / 10000, ${empty_fill})
              END,${format1}) cur_mon_jf_income,

					CASE WHEN NVL(cur_mon_jf_income, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END shouru_flag,


					to_char(CASE WHEN NVL(YD_KD_ITV_XZ_YEAR, 0) < 10000 THEN
               NVL(YD_KD_ITV_XZ_YEAR, ${empty_fill}) ELSE
               NVL(YD_KD_ITV_XZ_YEAR / 10000, ${empty_fill})
              END,${format1}) YD_KD_ITV_XZ_YEAR,

					CASE WHEN NVL(YD_KD_ITV_XZ_YEAR, 0) < 10000 THEN
               'xiao' ELSE
               'da'
              END xzyh_flag

			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_M d
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND d.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND d.bureau_no = '${param.bureau_no}'
	          </e:if>
	          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND d.branch_no = '${param.branch_no}'
	          </e:if>
            	AND d.flag = '${param.region_type}'
	            AND d.acct_month ='${param.acct_month}'

        </e:q4o>${e:java2json(qdxy_data)}
    </e:case>
    <e:description>发展效益-毛利率柱状图</e:description>
    <e:case value="mlqs_trend">
        <e:q4l var="mlqstrend_list">
            SELECT
            '月毛利趋势',
            MONTH_CODE,
            to_char(NVL(CUR_MON_BENEFIT_RATE*100,${empty_fill}), ${format1}) CUR_MON_BENEFIT_RATE
            FROM (SELECT *
            FROM (SELECT MONTH_CODE
            FROM ${gis_user}.TB_DIM_TIME
            WHERE MONTH_CODE >= '${param.acct_month}'
            GROUP BY MONTH_CODE
            ORDER BY MONTH_CODE ASC)
            WHERE ROWNUM <= 6) A
            LEFT JOIN ${channel_user}.TB_QDSP_STAT_VIEW_M M
            ON A.MONTH_CODE = M.ACCT_MONTH
            AND 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
                AND	m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
                AND	m.bureau_no = '${param.bureau_no}'
            </e:if>
            <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
                AND	m.branch_no = '${param.branch_no}'
            </e:if>
            AND m.flag = '${param.region_type}'
            order by a.month_code
        </e:q4l>${e: java2json(mlqstrend_list.list) }
    </e:case>
    <e:description>发展质态-质态概览</e:description>
    <e:case value="zt_org">
        <e:q4o var="zt_data">
            select '效能概览得分',
							to_char(NVL(CUR_MON_ACTIVE_RATE*100,${empty_fill}), ${format1})||'%' CUR_MON_ACTIVE_RATE,
	            to_char(NVL(CUR_MON_BILLING_RATE*100,${empty_fill}), ${format1})||'%' CUR_MON_BILLING_RATE,
	            to_char(NVL(CUR_MON_REMOVE_RATE*100,${empty_fill}), ${format1})||'%' CUR_MON_REMOVE_RATE,
	            NVL(CUR_MON_WORTH_RATE,${empty_fill}) CUR_MON_DNA_RATE,
	            fun_rate_fmt(kd_lw_cnt,kd_jf_cnt)  kd_leave,
	            fun_rate_fmt(kd_active_user,kd_user) KD_ACTIVE_RATE
			 			from
            	${channel_user}.TB_QDSP_STAT_VIEW_M m
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null) && (param.region_id ne '000')}">
            	AND m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
	            AND m.bureau_no = '${param.bureau_no}'
	          </e:if>
	          <e:if condition="${not empty param.branch_no && !(param.branch_no eq null)}">
	            AND m.branch_no = '${param.branch_no}'
	          </e:if>
            	AND m.flag = '${param.region_type}'
	            AND m.acct_month ='${param.acct_month}'

        </e:q4o>${e:java2json(zt_data)}
    </e:case>
</e:switch>