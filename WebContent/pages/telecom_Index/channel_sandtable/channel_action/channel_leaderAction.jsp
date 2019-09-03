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
                          from ${tab1})
                 group by month_code
                 order by month_code desc)
         WHERE ROWNUM <=6 ) a
         left join ${tab1} m
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
            LEFT JOIN ${tab1} M
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
			          T.AVG_CHANNEL_QDJF) A
        </e:q4l>${e: java2json(type_list.list) }
    </e:case>
    <e:description>渠道沙盘-积分构成</e:description>
    <e:case value="share_list">
        <e:q4l var="share_list">
        SELECT A.*,ROWNUM FROM (
	        select '999' LATN_ID,
					'全省' LATN_NAME,
					QDXN_CUR_MONTH_SCORE,
					QDXN_LAST_MONTH_SCORE,
					'000' city_order_num
			from
	        	${tab1} t
	        where T.ACCT_MONTH = '${param.acct_month}'
	        	and flag = '0'
	        union all
	          select d.LATN_ID||'' LATN_ID,
					AREA_DESCRIPTION LATN_NAME,
					QDXN_CUR_MONTH_SCORE,
					QDXN_LAST_MONTH_SCORE,
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
    <e:case value="getcityDataEcharts_bak">
        <e:q4l var="dataList">
            SELECT A.*,ROWNUM RN FROM(
            	SELECT
		            D.LATN_NAME,
		          TO_CHAR(NVL(d.CHANNEL_NUM,'0'),'FM9999999990')          CHANNEL_NUM,
		          TO_CHAR(NVL(d.SALE_CHANNEL_NUM,    '0'),'FM9999999990') SALE_CHANNEL_NUM,
		          TO_CHAR(NVL(d.SINGLE_CHANNEL_NUM,  '0'),'FM9999999990') SINGLE_CHANNEL_NUM,
		          TO_CHAR(NVL(d.HIGH_CHANNEL,        '0'),'FM9999999990') HIGH_CHANNEL,
		          TO_CHAR(NVL(d.LOW_SALE_CHANNEL,    '0'),'FM9999999990') LOW_SALE_CHANNEL,
		          TO_CHAR(NVL(d.ZERO_SALE_CHANNEL,   '0'),'FM9999999990') ZERO_SALE_CHANNEL,

		          TO_CHAR(NVL(d.CUR_MONTH_SUM_JF,   '0'),'FM9999999990.00') CUR_MONTH_SUM_JF,
		          TO_CHAR(NVL(d.CUR_DAY_JF,   '0'),'FM9999999990.00') CUR_DAY_JF,
		          TO_CHAR(NVL(d.FZ_OF_CUR_DAY_JF,   '0'),'FM9999999990.00') FZ_OF_CUR_DAY_JF,
		          TO_CHAR(NVL(d.CL_OF_CUR_DAY_JF,   '0'),'FM9999999990.00') CL_OF_CUR_DAY_JF,
		          CASE WHEN d.USER_CUR_MONTH_SUM_JF = 0 THEN '0.00'
				  ELSE
					to_char(NVL(d.CUR_MONTH_SUM_JF/d.USER_CUR_MONTH_SUM_JF,'0.00'), 'FM99999999999990.00')  END  CUR_MONTH_AVE_JF      ,

		          CASE WHEN USER_CUR_DAY_JF = 0 THEN '0.00'
		          ELSE
		          TO_CHAR(NVL(d.CL_OF_CUR_DAY_JF/USER_CUR_DAY_JF,   '0'),'FM9999999990.00') END CUR_DAY_AVE_JF,

		          TO_CHAR(NVL(d.CUR_MONTH_FZ,   '0'),'FM9999999990') CUR_MONTH_FZ,
		          TO_CHAR(NVL(d.CUR_DAY_FZ,   '0'),'FM9999999990') CUR_DAY_FZ,
		          TO_CHAR(NVL(d.LASTDAY_FZ,   '0'),'FM9999999990') LASTDAY_FZ,

		          TO_CHAR(NVL(m.CUR_MON_ACTIVE_RATE*100, '0'),'FM9999999990.00')||'%' CUR_MON_ACTIVE_RATE,
		          TO_CHAR(NVL(m.CUR_MON_ACTIVE,   '0'),'FM9999999990') CUR_MON_ACTIVE,
		          TO_CHAR(NVL(m.CUR_MON_BILLING_RATE*100,'0'),'FM9999999990.00')||'%' CUR_MON_BILLING_RATE,
		          TO_CHAR(NVL(m.CUR_MON_BILLING,   '0'),'FM9999999990') CUR_MON_BILLING,
		          TO_CHAR(NVL(m.CUR_MON_REMOVE_RATE*100, '0'),'FM9999999990.00')||'%' CUR_MON_REMOVE_RATE,
		          TO_CHAR(NVL(m.CUR_MON_BENEFIT_RATE*100,'0'),'FM9999999990.00')||'%' CUR_MON_BENEFIT_RATE,
		          TO_CHAR(NVL(m.CUR_MON_INCOME/10000,      '0'),'FM9999999990.00') CUR_MON_INCOME,
		          TO_CHAR(NVL(m.CUR_MON_CB/10000,          '0'),'FM9999999990.00') CUR_MON_CB,
		          TO_CHAR(NVL(m.CUR_MON_AMOUNT/10000,          '0'),'FM9999999990.00') CUR_MON_AMOUNT,

		          TO_CHAR(NVL(m.CUR_MON_WORTH_RATE,          '0'),'FM9999999990.00') CUR_MON_WORTH_RATE,
					s.d1 CHANNEL_SCORE
					FROM
				   (select * from ${channel_user}.TB_QDSP_STAT_VIEW_D d
				   		where d.acct_day = '${param.acct_day}' and d.flag ='1') d,
				   (select * from ${channel_user}.TB_QDSP_STAT_VIEW_M d
				   		where d.acct_month = '${param.acct_month}' and d.flag ='1') m,
				(select t.latn_id,
				        TRUNC(decode(sum(nvl(bjl_channel_num,0)),0,0,sum(nvl(bjl,0)) /sum(nvl(bjl_channel_num,0))),1)
				        +TRUNC(decode(sum(nvl(yhgml_channel_num,0)),0,0,sum(nvl(yhgml,0)) /sum(nvl(yhgml_channel_num,0))),1)
				        +TRUNC(decode(sum(nvl(yhztl_channel_num,0)),0,0,sum(nvl(yhztl,0)) /sum(nvl(yhztl_channel_num,0))),1)
				        +TRUNC(decode(sum(nvl(qdxyl_channel_num,0)),0,0,sum(nvl(qdxyl,0)) /sum(nvl(qdxyl_channel_num,0))),1)
				        d1
				    from ${tab1} t
				        where t.acct_month = '${param.acct_month}'
				           and t.flag = '1'
				        group by latn_id
				        ) s
				 where d.latn_id = m.latn_id and m.latn_id = s.latn_id
           			order by s.d1 DESC) A
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="getcityDataEcharts_xn">
        <e:q4l var="dataList">
            select '市级悬浮_xn',AREA_DESCRIPTION LATN_NAME,
		       to_char(TRUNC(decode(sum(nvl(bjl_channel_num,0)),0,0,sum(nvl(bjl,0)) /sum(nvl(bjl_channel_num,0))),1)
		      +TRUNC(decode(sum(nvl(yhgml_channel_num,0)),0,0,sum(nvl(yhgml,0)) /sum(nvl(yhgml_channel_num,0))),1)
		      +TRUNC(decode(sum(nvl(yhztl_channel_num,0)),0,0,sum(nvl(yhztl,0)) /sum(nvl(yhztl_channel_num,0))),1)
		      +TRUNC(decode(sum(nvl(qdxyl_channel_num,0)),0,0,sum(nvl(qdxyl,0)) /sum(nvl(qdxyl_channel_num,0))),1)
		      ,'FM9999999990.0')
					LATN_XN
					  from  ${channel_user}.tb_qdsp_channel_overview_m t
					         where t.acct_month = '${param.acct_month}'
					           and t.flag = '1'
					    group by t.latn_id,AREA_DESCRIPTION
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="getcityDataEcharts">
        <e:q4l var="dataList">

				select '市级悬浮',
							t.latn_id,
				       t2.region_id,
				       t2.region_name LATN_NAME,
				       t.qd_type,
				       t.qd_type_name,
				       t.dx_cnt,
				       t.qdfe,
				       to_char(nvl(t1.QDXN, 0), 'FM990.00') QDXN
				  from (select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               0 latn_ord,
				               '00' qd_type,
				               '全部' qd_type_name,
				               dx_cnt,
				               total_cnt,
				               ${channel_user}.fun_rate_fmt(dx_cnt, total_cnt) QDFE
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               1,
				               '30' qd_type,
				               '核心厅店' qd_name_name,
				               dx_cnt1,
				               dx_cnt1 + yd_cnt1 + lt_cnt1 total_cnt1,
				               ${channel_user}.fun_rate_fmt(dx_cnt1, dx_cnt1 + yd_cnt1 + lt_cnt1)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               2,
				               '10' qd_type,
				               '城市商圈' qd_name_name,
				               dx_cnt2,
				               dx_cnt2 + yd_cnt2 + lt_cnt2 total_cnt2,
				               ${channel_user}.fun_rate_fmt(dx_cnt2, dx_cnt2 + yd_cnt2 + lt_cnt2)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               3,
				               '20' qd_type,
				               '城市社区' qd_name_name,
				               dx_cnt3,
				               dx_cnt3 + yd_cnt3 + lt_cnt3 total_cnt3,
				               ${channel_user}.fun_rate_fmt(dx_cnt3, dx_cnt3 + yd_cnt3 + lt_cnt3)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               4,
				               '40' qd_type,
				               '农村乡镇' qd_name_name,
				               dx_cnt4,
				               dx_cnt4 + yd_cnt4 + lt_cnt4 total_cnt4,
				               ${channel_user}.fun_rate_fmt(dx_cnt4, dx_cnt4 + yd_cnt4 + lt_cnt4)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT) t
				  left join (select decode(t.flag, 0, t.latn_id, 1, t.latn_id, 2, t.COMMON_REGION_ID) latn_id,
				                    t.flag,
				                    '00' CHANNEL_TYPE_CODE_QD,
				                    '全部' channel_type_name_qd,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) bjl,
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) yhgml,
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) yhztl,
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) qdxyl,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) QDXN
				               from ${channel_user}.tb_qdsp_channel_overview_m t
				              where t.acct_month = '${param.acct_month}'
				              group by t.acct_month,
				                       decode(t.flag,
				                              0,
				                              t.latn_id,
				                              1,
				                              t.latn_id,
				                              2,
				                              t.COMMON_REGION_ID),
				                       t.flag
				             union
				             select decode(t.flag, 0, t.latn_id, 1, t.latn_id, 2, t.COMMON_REGION_ID),
				                    flag,
				                    t.CHANNEL_TYPE_CODE_QD,
				                    t.channel_type_name_qd,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) bjl,
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) yhgml,
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) yhztl,
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) qdxyl,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) QDXN
				               from ${channel_user}.tb_qdsp_channel_overview_m t
				              where t.acct_month = '${param.acct_month}'
				              group by t.acct_month,
				                       decode(t.flag,
				                              0,
				                              t.latn_id,
				                              1,
				                              t.latn_id,
				                              2,
				                              t.COMMON_REGION_ID),
				                       t.CHANNEL_TYPE_CODE_QD,
				                       t.channel_type_name_qd,
				                       t.flag) t1
				    on t.latn_id = t1.latn_id
				   and t.flag = t1.flag
				   and t.qd_type = t1.CHANNEL_TYPE_CODE_QD

				  left join (SELECT DISTINCT latn_Id region_id, latn_name region_name
				               FROM ${channel_user}.tb_gis_qd_bureau_ref) t2
				    on t.latn_id = t2.region_id

				 where t.flag = 1

				   and t.acct_day = '${param.acct_day}'
				 order by t.QD_TYPE

        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="getBureauDataEcharts_bak">
        <e:q4l var="dataList">
         SELECT A.*,ROWNUM RN FROM(
            SELECT
					D.BUREAU_NAME,
					TO_CHAR(NVL(d.CHANNEL_NUM,'0'),'FM9999999990')          CHANNEL_NUM,
		          TO_CHAR(NVL(d.SALE_CHANNEL_NUM,    '0'),'FM9999999990') SALE_CHANNEL_NUM,
		          TO_CHAR(NVL(d.SINGLE_CHANNEL_NUM,  '0'),'FM9999999990') SINGLE_CHANNEL_NUM,
		          TO_CHAR(NVL(d.HIGH_CHANNEL,        '0'),'FM9999999990') HIGH_CHANNEL,
		          TO_CHAR(NVL(d.LOW_SALE_CHANNEL,    '0'),'FM9999999990') LOW_SALE_CHANNEL,
		          TO_CHAR(NVL(d.ZERO_SALE_CHANNEL,   '0'),'FM9999999990') ZERO_SALE_CHANNEL,

		          TO_CHAR(NVL(d.CUR_MONTH_SUM_JF,   '0'),'FM9999999990.00') CUR_MONTH_SUM_JF,
		          TO_CHAR(NVL(d.CUR_DAY_JF,   '0'),'FM9999999990.00') CUR_DAY_JF,
		          TO_CHAR(NVL(d.FZ_OF_CUR_DAY_JF,   '0'),'FM9999999990.00') FZ_OF_CUR_DAY_JF,
		          TO_CHAR(NVL(d.CL_OF_CUR_DAY_JF,   '0'),'FM9999999990.00') CL_OF_CUR_DAY_JF,
		          CASE WHEN d.USER_CUR_MONTH_SUM_JF = 0 THEN '0.00'
				  ELSE
					to_char(NVL(d.CUR_MONTH_SUM_JF/d.USER_CUR_MONTH_SUM_JF,'0.00'), 'FM99999999999990.00')  END  CUR_MONTH_AVE_JF      ,

		          CASE WHEN USER_CUR_DAY_JF = 0 THEN '0.00'
		          ELSE
		          TO_CHAR(NVL(d.CL_OF_CUR_DAY_JF/USER_CUR_DAY_JF,   '0'),'FM9999999990.00') END CUR_DAY_AVE_JF,

		          TO_CHAR(NVL(d.CUR_MONTH_FZ,   '0'),'FM9999999990') CUR_MONTH_FZ,
		          TO_CHAR(NVL(d.CUR_DAY_FZ,   '0'),'FM9999999990') CUR_DAY_FZ,
		          TO_CHAR(NVL(d.LASTDAY_FZ,   '0'),'FM9999999990') LASTDAY_FZ,

		          TO_CHAR(NVL(m.CUR_MON_ACTIVE_RATE*100, '0'),'FM9999999990.00')||'%' CUR_MON_ACTIVE_RATE,
		          TO_CHAR(NVL(m.CUR_MON_ACTIVE,   '0'),'FM9999999990') CUR_MON_ACTIVE,
		          TO_CHAR(NVL(m.CUR_MON_BILLING_RATE*100,'0'),'FM9999999990.00')||'%' CUR_MON_BILLING_RATE,
		          TO_CHAR(NVL(m.CUR_MON_BILLING,   '0'),'FM9999999990') CUR_MON_BILLING,
		          TO_CHAR(NVL(m.CUR_MON_REMOVE_RATE*100, '0'),'FM9999999990.00')||'%' CUR_MON_REMOVE_RATE,
		          TO_CHAR(NVL(m.CUR_MON_BENEFIT_RATE*100,'0'),'FM9999999990.00')||'%' CUR_MON_BENEFIT_RATE,
		          TO_CHAR(NVL(m.CUR_MON_INCOME/10000,      '0'),'FM9999999990.00') CUR_MON_INCOME,
		          TO_CHAR(NVL(m.CUR_MON_CB/10000,          '0'),'FM9999999990.00') CUR_MON_CB,
		          TO_CHAR(NVL(m.CUR_MON_AMOUNT/10000,          '0'),'FM9999999990.00') CUR_MON_AMOUNT,

		          TO_CHAR(NVL(m.CUR_MON_WORTH_RATE,          '0'),'FM9999999990.00') CUR_MON_WORTH_RATE,
		          s.d1 CHANNEL_SCORE
					FROM (select d.*,g.region_order_num from ${channel_user}.TB_QDSP_STAT_VIEW_D d
				       left join (SELECT DISTINCT BUREAU_NO,t.region_order_num from ${tab2} t) g on g.bureau_no = d.bureau_no

				            where d.acct_day ='${param.acct_day}' and d.flag ='2' order by region_order_num) d,

				  (select m.*,g.region_order_num from ${channel_user}.TB_QDSP_STAT_VIEW_m m
				      left join (SELECT DISTINCT BUREAU_NO,t.region_order_num from ${tab2} t) g on g.bureau_no = m.bureau_no
				  where m.acct_month ='${param.acct_month}' and m.flag ='2'
				   order by region_order_num) m,
				   (select t.bureau_no,
				        TRUNC(decode(sum(nvl(bjl_channel_num,0)),0,0,sum(nvl(bjl,0)) /sum(nvl(bjl_channel_num,0))),1)
				        +TRUNC(decode(sum(nvl(yhgml_channel_num,0)),0,0,sum(nvl(yhgml,0)) /sum(nvl(yhgml_channel_num,0))),1)
				        +TRUNC(decode(sum(nvl(yhztl_channel_num,0)),0,0,sum(nvl(yhztl,0)) /sum(nvl(yhztl_channel_num,0))),1)
				        +TRUNC(decode(sum(nvl(qdxyl_channel_num,0)),0,0,sum(nvl(qdxyl,0)) /sum(nvl(qdxyl_channel_num,0))),1)
				        d1
				    from ${tab1} t
				        where t.acct_month = '${param.acct_month}'
				           and t.flag = '2'
				        group by bureau_no
				        ) s
				where d.bureau_no = m.bureau_no and m.bureau_no = s.bureau_no
				order by s.d1 DESC
				) A
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="getBureauDataEcharts">
        <e:q4l var="dataList">
          select '区县悬浮-份额' ,
          				t.latn_id,
				       t2.region_id,
				       t2.region_name BUREAU_NAME,
				       t.qd_type,
				       t.qd_type_name,
				       t.dx_cnt,
				       t.qdfe,
				       to_char(nvl(t1.QDXN, 0), 'FM990.00') QDXN
				  from (select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               0 latn_ord,
				               '00' qd_type,
				               '全部' qd_type_name,
				               dx_cnt,
				               total_cnt,
				               ${channel_user}.fun_rate_fmt(dx_cnt, total_cnt) QDFE
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               1,
				               '30' qd_type,
				               '核心厅店' qd_name_name,
				               dx_cnt1,
				               dx_cnt1 + yd_cnt1 + lt_cnt1 total_cnt1,
				               ${channel_user}.fun_rate_fmt(dx_cnt1, dx_cnt1 + yd_cnt1 + lt_cnt1)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               2,
				               '10' qd_type,
				               '城市商圈' qd_name_name,
				               dx_cnt2,
				               dx_cnt2 + yd_cnt2 + lt_cnt2 total_cnt2,
				               ${channel_user}.fun_rate_fmt(dx_cnt2, dx_cnt2 + yd_cnt2 + lt_cnt2)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               3,
				               '20' qd_type,
				               '城市社区' qd_name_name,
				               dx_cnt3,
				               dx_cnt3 + yd_cnt3 + lt_cnt3 total_cnt3,
				               ${channel_user}.fun_rate_fmt(dx_cnt3, dx_cnt3 + yd_cnt3 + lt_cnt3)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				        union
				        select acct_day,
				               latn_id,
				               parent_id,
				               flag,
				               4,
				               '40' qd_type,
				               '农村乡镇' qd_name_name,
				               dx_cnt4,
				               dx_cnt4 + yd_cnt4 + lt_cnt4 total_cnt4,
				               ${channel_user}.fun_rate_fmt(dx_cnt4, dx_cnt4 + yd_cnt4 + lt_cnt4)
				          from ${channel_user}.TB_GIS_QD_MARKET_COLLECT) t
				  left join (select decode(flag, 0, latn_id, 1, latn_id, 2, COMMON_REGION_ID) latn_id,
				                    flag,
				                    '00' CHANNEL_TYPE_CODE_QD,
				                    '全部' channel_type_name_qd,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) bjl,
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) yhgml,
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) yhztl,
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) qdxyl,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) QDXN
				               from ${channel_user}.tb_qdsp_channel_overview_m t
				              where t.acct_month = '${param.acct_month}'

				              group by t.acct_month,
				                       decode(t.flag,
				                              0,
				                              t.latn_id,
				                              1,
				                              t.latn_id,
				                              2,
				                              t.COMMON_REGION_ID),
				                       t.flag
				             union
				             select decode(flag, 0, latn_id, 1, latn_id, 2, COMMON_REGION_ID),
				                    flag,
				                    CHANNEL_TYPE_CODE_QD,
				                    channel_type_name_qd,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) bjl,
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) yhgml,
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) yhztl,
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) qdxyl,
				                    ${channel_user}.fun_div_fmt(sum(bjl), sum(bjl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhgml), sum(yhgml_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(yhztl), sum(yhztl_channel_num)) +
				                    ${channel_user}.fun_div_fmt(sum(qdxyl), sum(qdxyl_channel_num)) QDXN
				               from ${channel_user}.tb_qdsp_channel_overview_m t
				              where t.acct_month = '${param.acct_month}'
				              group by t.acct_month,
				                       decode(t.flag,
				                              0,
				                              t.latn_id,
				                              1,
				                              t.latn_id,
				                              2,
				                              t.COMMON_REGION_ID),
				                       t.CHANNEL_TYPE_CODE_QD,
				                       t.channel_type_name_qd,
				                       t.flag) t1
				    on t.latn_id = t1.latn_id
				   and t.flag = t1.flag
				   and t.qd_type = t1.CHANNEL_TYPE_CODE_QD

				  left join (SELECT DISTINCT bureau_no region_id, bureau_name2 region_name
				               FROM ${channel_user}.tb_gis_qd_bureau_ref) t2
				    on t.latn_id = t2.region_id

				 where t.flag = 2

				   and t.acct_day = '${param.acct_day}'
				 order by t.QD_TYPE
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="getBureauDataEcharts_xn">
        <e:q4l var="dataList">
            select '区县悬浮',BUREAU_NAME2 BUREAU_NAME,
		       to_char(TRUNC(decode(sum(nvl(bjl_channel_num,0)),0,0,sum(nvl(bjl,0)) /sum(nvl(bjl_channel_num,0))),1)
		      +TRUNC(decode(sum(nvl(yhgml_channel_num,0)),0,0,sum(nvl(yhgml,0)) /sum(nvl(yhgml_channel_num,0))),1)
		      +TRUNC(decode(sum(nvl(yhztl_channel_num,0)),0,0,sum(nvl(yhztl,0)) /sum(nvl(yhztl_channel_num,0))),1)
		      +TRUNC(decode(sum(nvl(qdxyl_channel_num,0)),0,0,sum(nvl(qdxyl,0)) /sum(nvl(qdxyl_channel_num,0))),1)
		      ,'FM9999999990.0')
					LATN_XN
					  from  ${channel_user}.tb_qdsp_channel_overview_m t
					  ,qdsp.tb_gis_qd_bureau_ref r
					         where t.acct_month = '${param.acct_month}'
					         and t.common_region_id = r.bureau_no
					           and t.flag = '2'
					    group by BUREAU_NAME2
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="getBureauDataEchartsbak">
        <e:q4l var="dataList">
         select t.channel_type_name_qd,
            		t.DESCRIPTION BUREAU_NAME,
					CHANNEL_NUM,
					TRUNC(decode(nvl(bjl_channel_num,0),0,0,nvl(bjl,0) /nvl(bjl_channel_num,0)),1)
					+TRUNC(decode(nvl(yhgml_channel_num,0),0,0,nvl(yhgml,0) /nvl(yhgml_channel_num,0)),1)
					+TRUNC(decode(nvl(yhztl_channel_num,0),0,0,nvl(yhztl,0) /nvl(yhztl_channel_num,0)),1)
					+TRUNC(decode(nvl(qdxyl_channel_num,0),0,0,nvl(qdxyl,0) /nvl(qdxyl_channel_num,0)),1) CHANNEL_XN,
					          f.*

					  from (select * from ${channel_user}.tb_qdsp_channel_overview_m t
					         where t.acct_month = '${param.acct_month}'
					           and t.flag = '2'
					           and t.channel_type_name_qd <> '未归类') t,
					        (select f.latn_id,
					              ${channel_user}.FUN_RATE_FMT(dx_cnt, total_cnt) d1,
					             ${channel_user}.FUN_RATE_FMT(dx_cnt1, total_cnt) d2,
					             ${channel_user}.FUN_RATE_FMT(dx_cnt2, total_cnt) d3,
					             ${channel_user}.FUN_RATE_FMT(dx_cnt3, total_cnt) d4,
					             ${channel_user}.FUN_RATE_FMT(dx_cnt4, total_cnt) d5

					              from ${channel_user}.TB_GIS_QD_MARKET_COLLECT f
					         where acct_day = '${param.acct_day}'
					           and f.flag = '2') f
					           where t.COMMON_REGION_ID = f.latn_id
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:description>当月日积分趋势</e:description>
	<e:case value="yxjf_trendList">
		<e:q4l var="DayJF_list">
		<e:description>
			select *
           from (select day_code
                   from ${gis_user}.tb_dim_time
                  where month_code in
                        (select max(acct_month)
                           from ${channel_user}.TB_QDSP_CHANNEL_m
                          where channel_nbr = '${param.channel_nbr}')
                  order by day_code desc) a
           left join ${channel_user}.TB_QDSP_CHANNEL_D b
             on a.day_code = b.acct_day
            and b.channel_nbr = '${param.channel_nbr}'
          order by a.day_code
		</e:description>
		SELECT
			d.acct_day,d.CHANNEL_JF
		FROM
			${channel_user}.TB_QDSP_CHANNEL_D d
        WHERE  1 = 1
        AND   d.acct_day BETWEEN '${param.acct_month}01'
        					AND '${param.acct_month}31'
            and d.channel_nbr = '${param.channel_nbr}'
          order by d.acct_day
		</e:q4l>${e:java2json(DayJF_list.list)}
	</e:case>
	<e:description>当月日积分趋势</e:description>

	<e:description>上月日积分趋势</e:description>
	<e:case value="yxjf_lasttrendList">
		<e:q4l var="LastDayJF_list">
		<e:description>
			select *
			  from (select day_code
			          from ${gis_user}.tb_dim_time
			         where month_code in
			               (select *
			                  from (select month_code
			                          from ${gis_user}.tb_dim_time
			                         where month_code <
			                               (select max(acct_month)
			                                  from ${channel_user}.TB_QDSP_CHANNEL_m
			                                 where channel_nbr = '${param.channel_nbr}')
			                         group by month_code
			                         order by month_code desc)
			                 WHERE ROWNUM < 2)
			         order by day_code desc) a
			  left join ${channel_user}.TB_QDSP_CHANNEL_D b
			    on a.day_code = b.acct_day
			   and b.channel_nbr = '${param.channel_nbr}'
			 order by a.day_code
		</e:description>
		SELECT
			d.acct_day,d.CHANNEL_JF
		FROM
			${channel_user}.TB_QDSP_CHANNEL_D d
        WHERE  1 = 1
        AND   d.acct_day BETWEEN '${param.last_month}01'
        					AND '${param.last_month}31'
            and d.channel_nbr = '${param.channel_nbr}'
          order by d.acct_day
		</e:q4l>${e:java2json(LastDayJF_list.list)}
	</e:case>
	<e:description>上月日积分趋势</e:description>

	<e:description>地图悬浮-销售门店数</e:description>
	<e:case value="tooltip_sale_channel">
		<e:q4l var="dataList">
			SELECT DISTINCT latn_id,zero_sale_channel,low_sale_channel,high_channel FROM ${channel_user}.tb_qdsp_stat_view_m WHERE flag = '${param.flg}' AND acct_month = '${param.acct_month}'
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>

</e:switch>
