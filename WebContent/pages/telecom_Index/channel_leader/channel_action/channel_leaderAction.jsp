<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

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
            	${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M m
            where 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null)}">
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
                 where month_code <=
                       (select max(acct_month)
                          from ${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M)
                 group by month_code
                 order by month_code desc)
         WHERE ROWNUM <=6 ) a
         left join ${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M m
    		on a.month_code = m.acct_month AND 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null)}">
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
            LEFT JOIN ${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M M
            ON A.MONTH_CODE = M.ACCT_MONTH
            AND 1 = 1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null)}">
                AND	m.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${not empty param.bureau_no && !(param.bureau_no eq null)}">
                AND	m.bureau_no = '${param.bureau_no}'
            </e:if>
            AND m.flag = '${param.region_type}'
            order by a.month_code
        </e:q4l>${e: java2json(trend_list.list) }
    </e:case>
    <e:description>效能概览-门店类型统计</e:description>
    <e:case value="type_list">
        <e:q4l var="type_list">
          SELECT * FROM(
          SELECT  NVL(sum(T.CHANNEL_NUM),0) TOTALNUM,
              D.CHANNEL_TYPE_NAME CHANNEL_TYPE_NAME_QD,
              NVL(to_char(T.AVG_SCORE ,'FM99999999999990.00') ,'--') AVG_SCORE,
              NVL(to_char(T.QDJF_CUR_MONTH ,'FM99999999999990.00') ,'--') CHANNEL_SCORE_SUM,
              NVL(to_char(T.AVG_CHANNEL_QDJF,'FM99999999999990.00') ,'--') AVG_CHANNEL_SCORE
          FROM (select  distinct(c.CHANNEL_TYPE_CODE),c.ord ,c.channel_type_name from ${channel_user}.tb_channel_type c) d
          left join ${channel_user}.TB_QDSP_TYPE_CHANNEL_M T
          on d.channel_type_code = t.channel_type_code_qd
		  <e:if condition="${not empty param.region_id && !(param.region_id eq null)}">
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
		  <e:if condition="${not empty param.region_id && !(param.region_id eq null)}">
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
			          T.AVG_CHANNEL_QDJF
        </e:q4l>${e: java2json(type_list.list) }
    </e:case>
    <e:description>效能概览-排名</e:description>
    <e:case value="xn_rank">
        <c:tablequery>
            SELECT
            	row_number() over(order by D.QDXN_CUR_MONTH_SCORE desc) as RN,
            	LATN_ID,
            	to_char(CZ,'FM99999999999990.00') CZ,
                nvl(D.QDXN_CUR_MONTH_SCORE,0) QDXN_CUR_MONTH_SCORE_NUM,
            	to_char(QDXN_CUR_MONTH_SCORE,'FM99999999999990.00') QDXN_CUR_MONTH_SCORE,
                nvl(D.QDJF_CUR_MONTH,0) QDJF_CUR_MONTH_NUM,
            	to_char(QDJF_CUR_MONTH,'FM99999999999990.00') QDJF_CUR_MONTH,
            	AREA_DESCRIPTION,
				BUREAU_NAME,
				BRANCH_NAME
            FROM
            	${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M D
            WHERE 1=1
            <e:if condition="${not empty param.region_id && !(param.region_id eq null)}">
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
</e:switch>