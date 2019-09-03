<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="tab_channel">
	<e:description>原表 ${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M</e:description>
	${channel_user}.view_QDSP_CHANNEL_OVERVIEW_M
</e:set>
<e:set var="tab2">
    <e:description>原表 ${gis_user}.db_cde_grid，组织机构码表换为渠道的组织机构码表</e:description>
    ${channel_user}.view_tb_gis_channel_org
</e:set>
<e:set var="format2">
	FM9999999990.00
</e:set>
<e:switch value="${param.eaction}">
    <e:description>
		渠道基本信息
	</e:description>
	<e:case value="getBaseInfo">
		<e:q4o var="getBaseInfo_obj">
			select t.*,d.*

			from ${channel_user}.TB_QDSP_CHANNEL_M t
			left join (select distinct(p.channel_type_code),
					p.channel_type_name,p.ord,p.bj_max,p.gm_max,p.zt_max,p.xy_max
				from ${channel_user}.TB_CHANNEL_TYPE p) d
  			on t.channel_type_code_qd = d.channel_type_code
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.month }'

		</e:q4o>${e:java2json(getBaseInfo_obj)}
	</e:case>
    <e:description>网点效能</e:description>
	<e:case value="getChannelInfo">
		<e:q4o var="getChannelInfo_obj">
			select
				'雷达图指标',
				channel_score d1,
	      fun_div_fmt(bjl) d2,
				fun_div_fmt(yhgml) d3,
				fun_div_fmt(qdxyl) d4,
				fun_div_fmt(yhztl) d5,
				CHANNEL_TYPE_NAME
			from ${channel_user}.view_QDSP_CHANNEL_OVERVIEW_M t

			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.month }'
		</e:q4o>${e:java2json(getChannelInfo_obj)}
	</e:case>
    <e:description>网点效能-效能指标</e:description>
	<e:case value="getChannelExplain">
		<e:q4o var="getChannelExplain_obj">
			select CHANNEL_TYPE_NAME,
					TO_CHAR(NVL(ARPU_AREA_SIZE_RATE,     '0.00'), '${format2}') ARPU_AREA_SIZE_RATE,

					case when YD_KD_ITV_CHARGE<10000 then 'xiao' else 'da' end ykic_flag,
					to_char(case when YD_KD_ITV_CHARGE>10000 then NVL(YD_KD_ITV_CHARGE/10000, '0.00') else YD_KD_ITV_CHARGE end,'${format2}') YD_KD_ITV_CHARGE,

					TO_CHAR(NVL(CHANNEL_AREA    , '0.00'), '${format2}')  CHANNEL_AREA    ,
					TO_CHAR(NVL(ARPU_STAFF_RATE,         '0.00'), '${format2}') ARPU_STAFF_RATE,
					TO_CHAR(NVL(SALES_NUM,'0.00'), '${format2}') STATIC_AVE_VALUE,

					TO_CHAR(NVL(YD_XZ,                   '0'), 'FM99999999999990') YD_XZ,
					TO_CHAR(NVL(YD_3ZERO,                '0'), 'FM99999999999990') YD_3ZERO,
					TO_CHAR(NVL(YD_YOUXIAO,              '0'), 'FM99999999999990') YD_YOUXIAO,
					TO_CHAR(NVL(TWO_CZ,                  '0'), 'FM99999999999990') TWO_CZ,
					TO_CHAR(NVL(KD_XZ,                   '0'), 'FM99999999999990') KD_XZ,
					TO_CHAR(NVL(KD_ZERO,                 '0'), 'FM99999999999990') KD_ZERO,
					TO_CHAR(NVL(KD_YOUXIAO,              '0'), 'FM99999999999990') KD_YOUXIAO,
					TO_CHAR(NVL(ITV_XZ,                  '0'), 'FM99999999999990') ITV_XZ,

					case when FZJF_KJ<10000 then 'xiao' else 'da' end fzjf_kj_flag,
					to_char(case when FZJF_KJ>10000 then NVL(FZJF_KJ/10000, '0.00') else FZJF_KJ end,'${format2}') FZJF_KJ,

					case when LEVEL_NUMBER<10000 then 'xiao' else 'da' end ln_flag,
					to_char(case when LEVEL_NUMBER>10000 then NVL(LEVEL_NUMBER/10000, '0.00') else LEVEL_NUMBER end,'${format2}') LEVEL_NUMBER,

					TO_CHAR(NVL(BAOYOU_YEAR_RETE*100,        '0.00'), '${format2}')||'%' BAOYOU_YEAR_RETE,
					TO_CHAR(NVL(YD_KD_ITV_XZ_YEAR,'0'), 'FM99999999999990') YD_KD_ITV_XZ_YEAR,
					TO_CHAR(NVL(YD_XZ_YEAR,       '0'), 'FM99999999999990') YD_XZ_YEAR,
					TO_CHAR(NVL(YD_XZ_ZW_YEAR,       '0'), 'FM99999999999990') YD_XZ_ZW_YEAR,

					case when NEW_ARPU_COMM_100_FEE<10000 then 'xiao' else 'da' end nac1f_flag,
					to_char(case when NEW_ARPU_COMM_100_FEE>10000 then NVL(NEW_ARPU_COMM_100_FEE/10000, '0.00') else NEW_ARPU_COMM_100_FEE end,'${format2}') NEW_ARPU_COMM_100_FEE,

					case when REWARD_COST<10000 then 'xiao' else 'da' end rc_flag,
					to_char(case when REWARD_COST>10000 then NVL(REWARD_COST/10000, '0.00') else REWARD_COST end,'${format2}') REWARD_COST,

					TO_CHAR(NVL(NEW_USER_COMM_100_NUM,   '0'), '${format2}') NEW_USER_COMM_100_NUM,
					TO_CHAR(NVL(CUR_MON_BENEFIT_RATE*100,    '0.00'), '${format2}')||'%' CUR_MON_BENEFIT_RATE ,

					TO_CHAR(NVL(ARPU_AREA_SIZE_RATE_SCORE,    '0.00'), '${format2}') ARPU_AREA_SIZE_RATE_SCORE,
					TO_CHAR(NVL(ARPU_STAFF_RATE_SCORE,        '0.00'), '${format2}') ARPU_STAFF_RATE_SCORE,
					TO_CHAR(NVL(YD_XZ_SCORE,                  '0.00'), '${format2}') YD_XZ_SCORE,
					TO_CHAR(NVL(YD_3ZERO_SCORE,               '0.00'), '${format2}') YD_3ZERO_SCORE,
					TO_CHAR(NVL(YD_YOUXIAO_SCORE,             '0.00'), '${format2}') YD_YOUXIAO_SCORE,
					TO_CHAR(NVL(TWO_CZ_SCORE,                 '0.00'), '${format2}') TWO_CZ_SCORE,
					TO_CHAR(NVL(KD_XZ_SCORE,                  '0.00'), '${format2}') KD_XZ_SCORE,
					TO_CHAR(NVL(KD_ZERO_SCORE,                '0.00'), '${format2}') KD_ZERO_SCORE,
					TO_CHAR(NVL(KD_YOUXIAO_SCORE,             '0.00'), '${format2}') KD_YOUXIAO_SCORE,
					TO_CHAR(NVL(ITV_XZ_SCORE,                 '0.00'), '${format2}') ITV_XZ_SCORE,
					TO_CHAR(NVL(FZJF_KJ_SCORE,                '0.00'), '${format2}') FZJF_KJ_SCORE,
					TO_CHAR(NVL(LEVEL_NUMBER_SCORE,           '0.00'), '${format2}') LEVEL_NUMBER_SCORE,
					TO_CHAR(NVL(BAOYOU_YEAR_RETE_SCORE,       '0.00'), '${format2}') BAOYOU_YEAR_RETE_SCORE,
					TO_CHAR(NVL(NEW_ARPU_COMM_100_FEE_SCORE,  '0.00'), '${format2}') NEW_ARPU_COMM_100_FEE_SCORE,
					TO_CHAR(NVL(NEW_USER_COMM_100_NUM_SCORE,  '0.00'), '${format2}') NEW_USER_COMM_100_NUM_SCORE,
					TO_CHAR(NVL(BENEFIT_RATE_SCORE,           '0.00'), '${format2}') BENEFIT_RATE_SCORE,
					TO_CHAR(NVL(BJL,                          '0.00'), '${format2}') BJL,
					TO_CHAR(NVL(YHGML,                        '0.00'), '${format2}') YHGML,
					TO_CHAR(NVL(YHZTL,                        '0.00'), '${format2}') YHZTL,
					TO_CHAR(NVL(QDXYL,                        '0.00'), '${format2}') QDXYL,
					TO_CHAR(NVL(CHANNEL_SCORE ,               '0.00'), '${format2}') CHANNEL_SCORE
			from ${channel_user}.TB_QDSP_CHANNEL_OVERVIEW_M t

			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.month }'
		</e:q4o>${e:java2json(getChannelExplain_obj)}
	</e:case>

	<e:description>
		渠道重点指标
	</e:description>

	<e:description>渠道画像详情</e:description>
	<e:case value="getDetailQDList">
		<e:q4l var="DetailQD_list">
			SELECT * FROM (
			select t.*
			from ${channel_user}.TB_QDSP_CHANNEL_M t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'
				order by t.acct_month DESC
			) WHERE ROWNUM < 13
		</e:q4l>${e:java2json(DetailQD_list.list)}
	</e:case>
	<e:description>渠道画像详情</e:description>

	<e:description>当月日积分趋势</e:description>
	<e:case value="getDayJFList">
		<e:q4l var="DayJF_list">
		SELECT
			d.acct_day,
			to_char(NVL(d.CUR_DAY_JF,'0'),'${format2}') CUR_DAY_JF
		FROM
			${channel_user}.TB_QDSP_STAT_VIEW_D d
        WHERE  1 = 1
        AND   d.acct_day BETWEEN '${param.acct_month}01'
        					AND '${param.acct_month}31'
            and d.channel_nbr = '${param.channel_nbr}'
          order by d.acct_day
		</e:q4l>${e:java2json(DayJF_list.list)}
	</e:case>
	<e:description>当月日积分趋势</e:description>

	<e:description>上月日积分趋势</e:description>
	<e:case value="getLastDayJFList">
		<e:q4l var="LastDayJF_list">
		SELECT
			d.acct_day,
			to_char(NVL(d.CUR_DAY_JF,'0'),'${format2}') CUR_DAY_JF
		FROM
			${channel_user}.TB_QDSP_STAT_VIEW_D d
        WHERE  1 = 1
        AND   d.acct_day BETWEEN '${param.last_month}01'
        					AND '${param.last_month}31'
            and d.channel_nbr = '${param.channel_nbr}'
          order by d.acct_day
		</e:q4l>${e:java2json(LastDayJF_list.list)}
	</e:case>
	<e:description>上月日积分趋势</e:description>

	<e:description>渠道画像趋势</e:description>
	<e:case value="getTrendQDList">
		<e:q4l var="TrendQD_list">
			select *
			  from (select *
			          from (select month_code
			                  from ${gis_user}.tb_dim_time
                            WHERE MONTH_CODE >= '${param.acct_month}'
                            GROUP BY MONTH_CODE
                            ORDER BY MONTH_CODE ASC)
			         WHERE ROWNUM < 7) a
			  left join ${channel_user}.TB_QDSP_STAT_VIEW_M b
			    on a.month_code = b.acct_month
			   and channel_nbr = '${param.channel_nbr}'
			 order by a.month_code
		</e:q4l>${e:java2json(TrendQD_list.list)}
	</e:case>
	<e:description>NBS Add 渠道效能趋势</e:description>
	<e:case value="getXnTrend">
		<e:q4l var="Trend_list">
		SELECT
			month_code,
			channel_score XN_SCORE
			from(
			select *
			  from (select *
			          from (select month_code
			                  from ${gis_user}.tb_dim_time
                            WHERE MONTH_CODE >= '${param.acct_month}'
                            GROUP BY MONTH_CODE
                            ORDER BY MONTH_CODE ASC)
			         WHERE ROWNUM < 7) a
			  left join ${channel_user}.view_QDSP_CHANNEL_OVERVIEW_M b
			    on a.month_code = b.acct_month
			   and channel_nbr = '${param.channel_nbr}')
			 order by month_code
		</e:q4l>${e:java2json(Trend_list.list)}
	</e:case>
	<e:description>渠道画像趋势</e:description>

	<e:case value="getKeyKpi">
		<e:q4o var="getKeyKpi_obj">
			select
				'渠道画像',
				t.ACCT_MONTH,
			    t.CHANNEL_NBR,
				round(nvl(t.XN_CUR_MONTH_SCORE,0),2) XN_CUR_MONTH_SCORE,
				round(nvl(t.BJL,0),2) BJL,
				round(nvl(t.QDXYL,0),2) QDXYL,
				round(nvl(t.YHGML,0),2) YHGML,
				round(nvl(t.YHZTL,0),2) YHZTL,



				round(nvl(t.HJ_JF_YEAR,0),2) HJ_JF_YEAR,
				round(nvl(T.QDJF_CUR_MONTH,0),2) QDJF_CUR_MONTH,
				round(nvl(T.QDJF_LAST_MONTH,0),2) QDJF_LAST_MONTH,

				round(nvl(T.QDML_CUR_MONTH,0),2) QDML_CUR_MONTH,
				round(nvl(t.SR,0),2) SR,
				round(nvl(t.CB,0),2) CB,
				round(nvl(T.BENEFIT_RATE,0)*100,2)  BENEFIT_RATE,
				round(NVL(t.YWFZ_CUR_MONTH_YD+t.YWFZ_CUR_MONTH_KD+t.YWFZ_CUR_MONTH_ITV,0),2) AS YWFZ_CUR_MONTH_SUM,
				round(nvl(t.YWFZ_CUR_MONTH_YD,0),2) YWFZ_CUR_MONTH_YD,
				round(nvl(t.YWFZ_CUR_MONTH_KD,0),2) YWFZ_CUR_MONTH_KD,
				round(nvl(t.YWFZ_CUR_MONTH_ITV,0),2) YWFZ_CUR_MONTH_ITV



			from ${channel_user}.TB_QDSP_CHANNEL_M t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.month }'

		</e:q4o>${e:java2json(getKeyKpi_obj)}
	</e:case>
	<e:description>
		效能发展趋势
	</e:description>
	<e:case value="channel_xn_fzqs">
		<e:q4l var="channel_xn_fzqsList">
		SELECT *
		FROM
		(
			SELECT DISTINCT
				T.ACCT_MONTH,
				T.CHANNEL_NBR,


			  NVL(T.XN_CUR_MONTH_SCORE ,0) AS XN_CUR_MONTH_SCORE

			FROM
				${channel_user}.TB_QDSP_CHANNEL_M T
			WHERE

				 t.ACCT_MONTH  <= '${param.month }'
				and t.acct_month > to_char(add_months(to_date('${param.month }' ,'yyyyMM'),-6),'yyyyMM')
		) N
		WHERE N.CHANNEL_NBR = '${param.channel_nbr}'

			ORDER BY N.ACCT_MONTH ASC
		</e:q4l>${e:java2json(channel_xn_fzqsList.list)}
	</e:case>

	<e:description>NBS Add 渠道画像-质态和效益</e:description>
	<e:case value="qdhx_qdgl_mon">
		<e:q4o var="qdhx_qdgl_obj">
			select
				'渠道画像',
				T.ACCT_MONTH              ,
				T.CHANNEL_NBR             ,
				T.CHANNEL_NAME            ,
				T.BIZ_MANAGER_CODE        ,
				T.OPERATORS_NBR           ,
				T.OPERATORS_NAME          ,
				T.CHANNEL_ATTR            ,
				T.CHANNEL_ATTR_NAME       ,
				T.CHANNEL_SPEC            ,
				T.CHANNEL_SPEC_NAME       ,
				T.CHANNEL_TYPE            ,
				T.CHANNEL_TYPE_NAME       ,
				T.ENTITY_CHANNEL_TYPE     ,
				nvl(T.ENTITY_CHANNEL_TYPE_NAME,'--') ENTITY_CHANNEL_TYPE_NAME,
				T.CHANNEL_AREA            ,
				T.CHANNEL_MANAGER         ,
				T.CHANNEL_MANAGER_TEL     ,
				T.EFF_DATE                ,
				T.EXP_DATE                ,
				T.CHANNEL_ADDRESS         ,
				to_char(nvl(CUR_YEAR_JF                 ,'0.00'),'FM9999999990.00') CUR_YEAR_JF                 ,
				to_char(nvl(CUR_MON_JF                  ,'0.00'),'FM9999999990.00') CUR_MON_JF                  ,
				to_char(nvl(LAST_MON_JF                 ,'0.00'),'FM9999999990.00') LAST_MON_JF                 ,
				to_char(nvl(JF_MONTH_RATE*100               ,'0.00'),'FM9999999990.00')||'%' JF_MONTH_RATE               ,
				to_char(nvl(CUR_MON_NEW_FZ              ,'0'),'FM9999999999') CUR_MON_NEW_FZ              ,
				to_char(nvl(YD_OF_CUR_MON_NEW_FZ              ,'0'),'FM9999999999') YD_OF_CUR_MON_NEW_FZ              ,
				to_char(nvl(KD_OF_CUR_MON_NEW_FZ              ,'0'),'FM9999999999') KD_OF_CUR_MON_NEW_FZ              ,
				to_char(nvl(ITV_OF_CUR_MON_NEW_FZ              ,'0'),'FM9999999999') ITV_OF_CUR_MON_NEW_FZ              ,
				to_char(nvl(CUR_MON_ACTIVE_RATE*100         ,'0.00'),'FM9999999990.00')||'%' CUR_MON_ACTIVE_RATE         ,
				to_char(nvl(CUR_MON_DEAD_ZONE_USER_RATE*100 ,'0.00'),'FM9999999990.00')||'%' CUR_MON_DEAD_ZONE_USER_RATE ,
				to_char(nvl(CUR_MON_BENEFIT_RATE*100        ,'0.00'),'FM9999999990.00')||'%' CUR_MON_BENEFIT_RATE        ,
				to_char(nvl(CUR_MON_BILLING_RATE*100        ,'0.00'),'FM9999999990.00')||'%' CUR_MON_BILLING_RATE        ,
				to_char(nvl(CUR_MON_REMOVE_RATE*100        ,'0.00'),'FM9999999990.00')||'%' CUR_MON_REMOVE_RATE        ,
				to_char(nvl(CUR_MON_WORTH_RATE        ,'0.00'),'FM9999999990.00') CUR_MON_WORTH_RATE        ,
				to_char(nvl(CUR_MON_INCOME              ,'0.00'),'FM9999999990.00') CUR_MON_INCOME              ,
				to_char(nvl(CUR_MON_CB                  ,'0.00'),'FM9999999990.00') CUR_MON_CB                  ,
				CASE WHEN CUR_MON_AMOUNT > 10000 THEN
			       to_char(nvl(CUR_MON_AMOUNT / 10000, '0.0'), 'FM9999999990.0')||'万元'
			    ELSE to_char(nvl(CUR_MON_AMOUNT, '0.0'), 'FM9999999990.00')||'元' END CUR_MON_AMOUNT,
				CASE WHEN CUR_MON_100_INCOME > 10000 THEN
					to_char(nvl(CUR_MON_100_INCOME/10000                  ,'0.00'),'FM9999999990')||'万元'
				ELSE to_char(nvl(CUR_MON_100_INCOME                  ,'0.00'),'FM9999999990')||'元' END CUR_MON_100_INCOME                  ,
				to_char(nvl(CUR_MON_100_USER,'0.00'),'FM9999999990.0') CUR_MON_100_USER                  ,
				to_char(nvl(CUR_MONTH_FZ_REWARD+CUR_MONTH_SERVICE_REWARD+CUR_MONTH_CZ_JF_REWARD,'0.00'),'FM9999999990.00') CUR_MON_YJ
			from ${channel_user}.TB_QDSP_STAT_VIEW_M t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.month}'

		</e:q4o>${e:java2json(qdhx_qdgl_obj)}
	</e:case>
	<e:case value="qdhx_qdgl">
		<e:q4o var="qdhx_qdgl_obj">
			select
				'渠道画像-概览日积分',
				T.ACCT_DAY              ,
				T.CHANNEL_NBR             ,
				T.CHANNEL_NAME            ,
				T.BIZ_MANAGER_CODE        ,
				T.OPERATORS_NBR           ,
				T.OPERATORS_NAME          ,
				T.CHANNEL_ATTR            ,
				T.CHANNEL_ATTR_NAME       ,
				T.CHANNEL_SPEC            ,
				T.CHANNEL_SPEC_NAME       ,
				T.CHANNEL_TYPE            ,
				T.CHANNEL_TYPE_NAME       ,
				T.ENTITY_CHANNEL_TYPE     ,
				nvl(T.ENTITY_CHANNEL_TYPE_NAME,'--') ENTITY_CHANNEL_TYPE_NAME,
				nvl(T.CHANNEL_AREA,'--')    CHANNEL_AREA        ,
				T.CHANNEL_MANAGER         ,
				T.CHANNEL_MANAGER_TEL     ,
				T.EFF_DATE                ,
				T.EXP_DATE                ,
				T.CHANNEL_ADDRESS         ,
				to_char(nvl(CUR_DAY_JF                 ,'0.00'),'FM9999999990.00') CUR_DAY_JF                 ,
				to_char(nvl(FZ_OF_CUR_DAY_JF                 ,'0.00'),'FM9999999990.00') FZ_OF_CUR_DAY_JF                 ,
				to_char(nvl(CL_OF_CUR_DAY_JF                 ,'0.00'),'FM9999999990.00') CL_OF_CUR_DAY_JF                 ,
				to_char(nvl(CUR_MONTH_SUM_JF                 ,'0.00'),'FM9999999990.00') CUR_MONTH_SUM_JF                 ,
				to_char(nvl(FZ_OF_CUR_MONTH_SUM_JF, '0.00'), 'FM9999999990.00') FZ_OF_CUR_MONTH_SUM_JF,
       			to_char(nvl(CL_OF_CUR_MONTH_SUM_JF, '0.00'), 'FM9999999990.00') CL_OF_CUR_MONTH_SUM_JF,
				to_char(nvl(CUR_MONTH_FZ                 ,'0'),'FM9999999990') CUR_MONTH_FZ                 ,
				CASE WHEN USER_CUR_DAY_JF = 0 THEN '0.00'
				ELSE
				to_char(nvl(CUR_DAY_JF/USER_CUR_DAY_JF                  ,'0.00'),'FM9999999990.00') END CUR_DAY_AVE_JF                  ,
				to_char(nvl(JF_DAY_RATE*100               ,'0.00'),'FM9999999990')||'%' JF_DAY_RATE,

				to_char(nvl(CUR_DAY_FZ_YD                 ,'0.00'),'FM9999999990') CUR_DAY_FZ_YD                 ,
				to_char(nvl(CUR_DAY_FZ_KD                 ,'0.00'),'FM9999999990') CUR_DAY_FZ_KD                 ,
				to_char(nvl(CUR_DAY_FZ_ITV                 ,'0.00'),'FM9999999990') CUR_DAY_FZ_ITV                 ,
				to_char(nvl(CUR_MONTH_FZ_YD                 ,'0.00'),'FM9999999990') CUR_MONTH_FZ_YD                 ,
				to_char(nvl(CUR_MONTH_FZ_KD                 ,'0.00'),'FM9999999990') CUR_MONTH_FZ_KD                 ,
				to_char(nvl(CUR_MONTH_FZ_ITV                 ,'0.00'),'FM9999999990') CUR_MONTH_FZ_ITV
			from ${channel_user}.TB_QDSP_STAT_VIEW_D t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_DAY = '${param.day}'

		</e:q4o>${e:java2json(qdhx_qdgl_obj)}
	</e:case>
	<e:description>NBS Add 渠道积分-渠道日积分表格</e:description>
	<e:case value="qdjf_qdjfday">
		<e:q4o var="qdjf_qdjfday_obj">
			select
				'渠道网点画像-营销积分-营销日积分',
				T.ACCT_DAY,

				<e:description>月累计积分</e:description>
				to_char(nvl(cur_month_sum_jf              ,'0.00'),'${format2}') cur_month_sum_jf,<e:description>当月积分</e:description>
				to_char(nvl(fz_of_cur_month_sum_jf             ,'0.00'),'${format2}') fz_of_cur_month_sum_jf,<e:description>当月发展积分</e:description>
				to_char(nvl(jz_fz_cur_month_sum_jf             ,'0.00'),'${format2}') jz_fz_cur_month_sum_jf,<e:description>当月发展价值积分</e:description>
				to_char(nvl(jl_fz_cur_month_sum_jf             ,'0.00'),'${format2}') jl_fz_cur_month_sum_jf,<e:description>当月发展奖励积分</e:description>

				to_char(nvl(cl_of_cur_month_sum_jf             ,'0.00'),'${format2}') cl_of_cur_month_sum_jf,<e:description>当月存量积分</e:description>
				to_char(nvl(jz_cl_cur_month_sum_jf             ,'0.00'),'${format2}') jz_cl_cur_month_sum_jf,<e:description>当月存量价值积分</e:description>
				to_char(nvl(jl_cl_cur_month_sum_jf             ,'0.00'),'${format2}') jl_cl_cur_month_sum_jf,<e:description>当月存量奖励积分</e:description>
				to_char(nvl(dz_cl_cur_month_sum_jf             ,'0.00'),'${format2}') dz_cl_cur_month_sum_jf,<e:description>当月存量动作积分</e:description>

				<e:description>当月户均</e:description>
				fun_div_fmt(cur_month_sum_jf,user_cur_month_sum_jf) cur_month_avg,<e:description>当月 户均</e:description>
				fun_div_fmt(fz_of_cur_month_sum_jf,user_fz_of_cur_month_sum_jf) cur_month_fz_avg,<e:description>当月发展 户均</e:description>
				fun_div_fmt(jz_fz_cur_month_sum_jf,user_fz_of_cur_month_sum_jz) cur_month_fzjz_avg,<e:description>当月发展价值 户均</e:description>
				fun_div_fmt(jl_fz_cur_month_sum_jf,user_fz_of_cur_month_sum_jl) cur_month_fzjl_avg,<e:description>当月发展奖励 户均</e:description>

				fun_div_fmt(cl_of_cur_month_sum_jf,user_cl_of_cur_month_sum_jf) cur_month_cl_avg,<e:description>当月存量 户均</e:description>
				fun_div_fmt(jz_cl_cur_month_sum_jf,user_cl_of_cur_month_sum_jf) cur_month_cljz_avg,<e:description>当月存量价值 户均</e:description>
				fun_div_fmt(jl_cl_cur_month_sum_jf,user_cl_of_cur_month_sum_jz) cur_month_cljl_avg,<e:description>当月存量奖励 户均</e:description>
				fun_div_fmt(dz_cl_cur_month_sum_jf,user_cl_of_cur_month_sum_dz) cur_month_cldz_avg,<e:description>当月存量动作 户均</e:description>

				<e:description>当日积分</e:description>
				to_char(nvl(cur_day_jf                ,'0.00'),'${format2}') cur_day_jf,<e:description>当日 积分</e:description>
				to_char(nvl(fz_of_cur_day_jf          ,'0.00'),'${format2}') fz_of_cur_day_jf,<e:description>当日 发展</e:description>
				to_char(nvl(jz_fz_cur_day_jf          ,'0.00'),'${format2}') jz_fz_cur_day_jf,<e:description>当日 发展价值</e:description>
				to_char(nvl(jl_fz_cur_day_jf          ,'0.00'),'${format2}') jl_fz_cur_day_jf,<e:description>当日 发展奖励</e:description>

				to_char(nvl(cl_of_cur_day_jf          ,'0.00'),'${format2}') cl_of_cur_day_jf,<e:description>当日 存量</e:description>
				to_char(nvl(jz_cl_cur_day_jf          ,'0.00'),'${format2}') jz_cl_cur_day_jf,<e:description>当日 存量价值</e:description>
				to_char(nvl(jl_cl_cur_day_jf          ,'0.00'),'${format2}') jl_cl_cur_day_jf,<e:description>当日 存量奖励</e:description>
				to_char(nvl(dz_cl_cur_day_jf          ,'0.00'),'${format2}') dz_cl_cur_day_jf,<e:description>当日 存量动作</e:description>

				<e:description>当日户均</e:description>
				fun_div_fmt(cur_day_jf,user_cur_day_jf) cur_day_avg,<e:description>当日 户均</e:description>
				fun_div_fmt(fz_of_cur_day_jf,user_fz_of_cur_day_jf) cur_day_fz_avg,<e:description>当日 发展户均</e:description>
				fun_div_fmt(jz_fz_cur_day_jf,user_fz_of_jz) cur_day_fzjz_avg,<e:description>当日 发展价值户均</e:description>
				fun_div_fmt(jl_fz_cur_day_jf,user_fz_of_jl) cur_day_fzjl_avg,<e:description>当日 发展奖励户均</e:description>

				fun_div_fmt(cl_of_cur_day_jf,user_cl_of_cur_day_jf) cur_day_cl_avg,<e:description>当日 存量户均</e:description>
				fun_div_fmt(jz_cl_cur_day_jf,user_cl_of_jz) cur_day_cljz_avg,<e:description>当日 存量价值户均</e:description>
				fun_div_fmt(jl_cl_cur_day_jf,user_cl_of_jl) cur_day_cljl_avg,<e:description>当日 存量奖励户均</e:description>
				fun_div_fmt(dz_cl_cur_day_jf,user_cl_of_dz) cur_day_cldz_avg<e:description>当日 存量动作户均</e:description>

			from ${channel_user}.TB_QDSP_STAT_VIEW_D t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_DAY = '${param.acct_day}'

		</e:q4o>${e:java2json(qdjf_qdjfday_obj)}
	</e:case>
	<e:description>渠道积分-月积分表格</e:description>
	<e:case value="qdjf_qdjfmonth">
		<e:q4o var="qdjf_qdjfmon_obj">
			select
				'渠道网点画像-营销积分-营销月积分',
				T.ACCT_MONTH,

				<e:description>年累计积分</e:description>
				to_char(nvl(cur_year_jf              ,'0.00'),'${format2}') cur_year_jf,<e:description>年积分</e:description>
				to_char(nvl(fz_of_cur_year_jf             ,'0.00'),'${format2}') fz_of_cur_year_jf,<e:description>年发展积分</e:description>
				to_char(nvl(jz_fz_cur_year_jf             ,'0.00'),'${format2}') jz_fz_cur_year_jf,<e:description>年发展价值积分</e:description>
				to_char(nvl(jl_fz_cur_year_jf             ,'0.00'),'${format2}') jl_fz_cur_year_jf,<e:description>年发展奖励积分</e:description>

				to_char(nvl(cl_of_cur_year_jf             ,'0.00'),'${format2}') cl_of_cur_year_jf,<e:description>年存量积分</e:description>
				to_char(nvl(cl_jz_cur_year_jf             ,'0.00'),'${format2}') cl_jz_cur_year_jf,<e:description>年存量价值积分</e:description>
				to_char(nvl(cl_jl_cur_year_jf             ,'0.00'),'${format2}') cl_jl_cur_year_jf,<e:description>年存量奖励积分</e:description>
				to_char(nvl(cl_dz_cur_year_jf             ,'0.00'),'${format2}') cl_dz_cur_year_jf,<e:description>年存量动作积分</e:description>

				to_char(nvl(ZS_OF_CUR_YEAR_JF             ,'0.00'),'${format2}') zs_of_cur_year_jf,<e:description>年追溯积分</e:description>

				<e:description>本月值</e:description>
				to_char(nvl(cur_mon_jf                 ,'0.00'),'${format2}') cur_mon_jf,<e:description>本月值</e:description>
				to_char(nvl(fz_of_cur_mon_jf          ,'0.00'),'${format2}') fz_of_cur_mon_jf,<e:description>本月发展值</e:description>
				to_char(nvl(jz_fz_cur_mon_jf             ,'0.00'),'${format2}') jz_fz_cur_mon_jf,<e:description>本月发展价值值</e:description>
				to_char(nvl(jl_fz_cur_mon_jf             ,'0.00'),'${format2}') jl_fz_cur_mon_jf,<e:description>本月发展奖励值</e:description>

				to_char(nvl(cl_of_cur_mon_jf          ,'0.00'),'${format2}') cl_of_cur_mon_jf,<e:description>本月存量值</e:description>
				to_char(nvl(cl_jz_cur_mon_jf             ,'0.00'),'${format2}') cl_jz_cur_mon_jf,<e:description>本月存量价值值</e:description>
				to_char(nvl(cl_jl_cur_mon_jf          ,'0.00'),'${format2}') cl_jl_cur_mon_jf,<e:description>本月存量奖励值</e:description>
				to_char(nvl(cl_dz_cur_mon_jf          ,'0.00'),'${format2}') cl_dz_cur_mon_jf,<e:description>本月存量动作值</e:description>

				to_char(nvl(zs_of_cur_mon_jf          ,'0.00'),'${format2}') zs_of_cur_mon_jf,<e:description>本月追溯</e:description>

				<e:description>上月值</e:description>
				to_char(nvl(last_mon_jf                  ,'0.00'),'${format2}') last_mon_jf,<e:description>上月值</e:description>
				to_char(nvl(fz_of_last_mon_jf            ,'0.00'),'${format2}') fz_of_last_mon_jf,<e:description>上月发展值</e:description>
				to_char(nvl(jz_fz_last_mon_jf            ,'0.00'),'${format2}') jz_fz_last_mon_jf,<e:description>上月发展价值值</e:description>
				to_char(nvl(jl_fz_last_mon_jf            ,'0.00'),'${format2}') jl_fz_last_mon_jf,<e:description>上月发展奖励值</e:description>

				to_char(nvl(cl_of_last_mon_jf            ,'0.00'),'${format2}') cl_of_last_mon_jf,<e:description>上月存量值</e:description>
				to_char(nvl(cl_jz_last_mon_jf            ,'0.00'),'${format2}') cl_jz_last_mon_jf,<e:description>上月存量价值值</e:description>
				to_char(nvl(cl_jl_last_mon_jf            ,'0.00'),'${format2}') cl_jl_last_mon_jf,<e:description>上月存量奖励值</e:description>
				to_char(nvl(cl_dz_last_mon_jf            ,'0.00'),'${format2}') cl_dz_last_mon_jf,<e:description>上月存量动作值</e:description>

				to_char(nvl(zs_of_last_mon_jf            ,'0.00'),'${format2}') zs_of_last_mon_jf,<e:description>上月追溯</e:description>

				<e:description>差值</e:description>
				to_char(nvl(cur_mon_jf,0)-nvl(last_mon_jf,0),'${format2}') month_cz,<e:description>月差值</e:description>
				to_char(nvl(fz_of_cur_mon_jf,0)-nvl(fz_of_last_mon_jf,0),'${format2}') month_fz_cz,<e:description>月发展差值</e:description>
				to_char(nvl(jz_fz_cur_mon_jf,0)-nvl(jz_fz_last_mon_jf,0),'${format2}') month_fzjz_cz,<e:description>月发展价值差值</e:description>
				to_char(nvl(jl_fz_cur_mon_jf,0)-nvl(jl_fz_last_mon_jf,0),'${format2}') month_fzjl_cz,<e:description>月发展奖励差值</e:description>

				to_char(nvl(cl_of_cur_mon_jf,0)-nvl(cl_of_last_mon_jf,0),'${format2}') month_cl_cz,<e:description>月存量差值</e:description>
				to_char(nvl(cl_jz_cur_mon_jf,0)-nvl(cl_jz_last_mon_jf,0),'${format2}') month_cljz_cz,<e:description>月存量价值差值</e:description>
				to_char(nvl(cl_jl_cur_mon_jf,0)-nvl(cl_jl_last_mon_jf,0),'${format2}') month_cljl_cz,<e:description>月存量奖励差值</e:description>
				to_char(nvl(cl_dz_cur_mon_jf,0)-nvl(cl_dz_last_mon_jf,0),'${format2}') month_cldz_cz,<e:description>月存量动作差值</e:description>

				to_char(nvl(zs_of_cur_mon_jf,0)-nvl(zs_of_last_mon_jf,0),'${format2}') month_zs_cz,<e:description>月追溯差值</e:description>

				<e:description>环比</e:description>
				fun_rate_fmt(nvl(cur_mon_jf,0)-nvl(last_mon_jf,0),last_mon_jf) month_hb,<e:description>月环比</e:description>
				fun_rate_fmt(nvl(fz_of_cur_mon_jf,0)-nvl(fz_of_last_mon_jf,0),fz_of_last_mon_jf) month_fz_hb,<e:description>月发展环比</e:description>
				fun_rate_fmt(nvl(jz_fz_cur_mon_jf,0)-nvl(jz_fz_last_mon_jf,0),jz_fz_last_mon_jf) month_fzjz_hb,<e:description>月发展价值环比</e:description>
				fun_rate_fmt(nvl(jl_fz_cur_mon_jf,0)-nvl(jl_fz_cur_mon_jf,0),jl_fz_cur_mon_jf) month_fzjl_hb,<e:description>月发展奖励环比</e:description>

				fun_rate_fmt(nvl(cl_of_cur_mon_jf,0)-nvl(cl_of_last_mon_jf,0),cl_of_last_mon_jf) month_cl_hb,<e:description>月存量环比</e:description>
				fun_rate_fmt(nvl(cl_jz_cur_mon_jf,0)-nvl(cl_jz_last_mon_jf,0),cl_jz_last_mon_jf) month_cljz_hb,<e:description>月存量价值环比</e:description>
				fun_rate_fmt(nvl(cl_jl_cur_mon_jf,0)-nvl(cl_jl_last_mon_jf,0),cl_jl_last_mon_jf) month_cljl_hb,<e:description>月存量奖励环比</e:description>
				fun_rate_fmt(nvl(cl_dz_cur_mon_jf,0)-nvl(cl_dz_last_mon_jf,0),cl_dz_last_mon_jf) month_cldz_hb,<e:description>月存量动作环比</e:description>

				fun_rate_fmt(nvl(zs_of_cur_mon_jf,0)-nvl(zs_of_last_mon_jf,0),zs_of_last_mon_jf) month_zs_hb<e:description>月追溯环比</e:description>

			from ${channel_user}.TB_QDSP_STAT_VIEW_M t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.acct_month}'

		</e:q4o>${e:java2json(qdjf_qdjfmon_obj)}
	</e:case>
	<e:description>发展效能-日发展效能表格</e:description>
	<e:case value="fzxn_fzxnday">
		<e:q4o var="fzxn_obj">
			select
				T.ACCT_DAY              ,
				to_char(nvl(CUR_MONTH_FZ,  '0.00'),'FM9999999990') CUR_MONTH_FZ,
				to_char(nvl(LAST_MONTH_FZ, '0.00'),'FM9999999990') LAST_MONTH_FZ,
				to_char(nvl(MONTH_FZ_RATE*100, '0.00'),'FM9999999990.00')||'%' MONTH_FZ_RATE,
				to_char(nvl(CUR_DAY_FZ,    '0.00'),'FM9999999990') CUR_DAY_FZ,
				to_char(nvl(LASTDAY_FZ,    '0.00'),'FM9999999990') LASTDAY_FZ,
				to_char(nvl(DAY_FZ_RATE*100,    '0.00'),'FM9999999990.00')||'%' DAY_FZ_RATE,

				to_char(nvl(CUR_MONTH_FZ_YD	  ,  '0.00'),'FM9999999990') CUR_MONTH_FZ_YD	  ,
				to_char(nvl(LAST_MONTH_FZ_YD  ,  '0.00'),'FM9999999990') LAST_MONTH_FZ_YD  ,
				to_char(nvl(FZ_YD_MONTH_RATE*100  ,  '0.00'),'FM9999999990.00')||'%' FZ_YD_MONTH_RATE  ,
				to_char(nvl(CUR_DAY_FZ_YD	  ,  '0.00'),'FM9999999990') CUR_DAY_FZ_YD	  ,
				to_char(nvl(LAST_DAY_FZ_YD	  ,  '0.00'),'FM9999999990') LAST_DAY_FZ_YD	  ,
				to_char(nvl(FZ_YD_DAY_RATE*100	  ,  '0.00'),'FM9999999990.00')||'%' FZ_YD_DAY_RATE	  ,

				to_char(nvl(CUR_MONTH_FZ_KD	  ,  '0.00'),'FM9999999990') CUR_MONTH_FZ_KD	  ,
				to_char(nvl(LAST_MONTH_FZ_KD  ,  '0.00'),'FM9999999990') LAST_MONTH_FZ_KD  ,
				to_char(nvl(FZ_KD_MONTH_RATE*100  ,  '0.00'),'FM9999999990.00')||'%' FZ_KD_MONTH_RATE  ,
				to_char(nvl(CUR_DAY_FZ_KD	  ,  '0.00'),'FM9999999990') CUR_DAY_FZ_KD	  ,
				to_char(nvl(LAST_DAY_FZ_KD	  ,  '0.00'),'FM9999999990') LAST_DAY_FZ_KD	  ,
				to_char(nvl(FZ_KD_DAY_RATE*100	  ,  '0.00'),'FM9999999990.00')||'%' FZ_KD_DAY_RATE	  ,

				to_char(nvl(CUR_MONTH_FZ_ITV  ,  '0.00'),'FM9999999990') CUR_MONTH_FZ_ITV  ,
				to_char(nvl(LAST_MONTH_FZ_ITV ,  '0.00'),'FM9999999990') LAST_MONTH_FZ_ITV ,
				to_char(nvl(FZ_ITV_MONTH_RATE*100 ,  '0.00'),'FM9999999990.00')||'%' FZ_ITV_MONTH_RATE ,
				to_char(nvl(CUR_DAY_FZ_ITV	  ,  '0.00'),'FM9999999990') CUR_DAY_FZ_ITV	  ,
				to_char(nvl(LAST_DAY_FZ_ITV	  ,  '0.00'),'FM9999999990') LAST_DAY_FZ_ITV	  ,
				to_char(nvl(FZ_ITV_DAY_RATE*100	  ,  '0.00'),'FM9999999990.00')||'%' FZ_ITV_DAY_RATE
			from ${channel_user}.TB_QDSP_STAT_VIEW_D t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_DAY = '${param.acct_day}'

		</e:q4o>${e:java2json(fzxn_obj)}
	</e:case>
	<e:description>发展效能-月发展效能表格</e:description>
	<e:case value="fzxn_fzxnmonth">
		<e:q4o var="fzxn_obj">
			select
				T.ACCT_MONTH             ,
				to_char(nvl(CUR_MON_NEW_FZ	          ,  '0.00'),'FM9999999990') CUR_MON_NEW_FZ	          ,
				to_char(nvl(LAST_MON_NEW_FZ	          ,  '0.00'),'FM9999999990') LAST_MON_NEW_FZ	          ,
				to_char(nvl(CUR_MON_NEW_FZ_RATE*100	      ,  '0.00'),'FM9999999990.00')||'%' CUR_MON_NEW_FZ_RATE	      ,
				to_char(nvl(YD_OF_CUR_MON_NEW_FZ	  ,  '0.00'),'FM9999999990') YD_OF_CUR_MON_NEW_FZ	  ,
				to_char(nvl(YD_OF_LAST_MON_NEW_FZ	  ,  '0.00'),'FM9999999990') YD_OF_LAST_MON_NEW_FZ	  ,
				to_char(nvl(RATE_YD_OF_CUR_MON_NEW_FZ*100 ,  '0.00'),'FM9999999990.00')||'%' RATE_YD_OF_CUR_MON_NEW_FZ ,
				to_char(nvl(KD_OF_CUR_MON_NEW_FZ	  ,  '0.00'),'FM9999999990') KD_OF_CUR_MON_NEW_FZ	  ,
				to_char(nvl(KD_OF_LAST_MON_NEW_FZ	  ,  '0.00'),'FM9999999990') KD_OF_LAST_MON_NEW_FZ	  ,
				to_char(nvl(RATE_KD_OF_CUR_MON_NEW_FZ*100 ,  '0.00'),'FM9999999990.00')||'%' RATE_KD_OF_CUR_MON_NEW_FZ ,
				to_char(nvl(ITV_OF_CUR_MON_NEW_FZ	  ,  '0.00'),'FM9999999990') ITV_OF_CUR_MON_NEW_FZ	  ,
				to_char(nvl(ITV_OF_LAST_MON_NEW_FZ	  ,  '0.00'),'FM9999999990') ITV_OF_LAST_MON_NEW_FZ	  ,
				to_char(nvl(RATE_ITV_OF_CUR_MON_NEW_FZ*100,  '0.00'),'FM9999999990.00')||'%' RATE_ITV_OF_CUR_MON_NEW_FZ,
				to_char(nvl(ALL_OF_CUR_YEAR_NEW_FZ	  ,  '0.00'),'FM9999999990') ALL_OF_CUR_YEAR_NEW_FZ	  ,
				to_char(nvl(YD_OF_CUR_YEAR_NEW_FZ	  ,  '0.00'),'FM9999999990') YD_OF_CUR_YEAR_NEW_FZ	  ,
				to_char(nvl(KD_OF_CUR_YEAR_NEW_FZ	  ,  '0.00'),'FM9999999990') KD_OF_CUR_YEAR_NEW_FZ	  ,
				to_char(nvl(ITV_OF_CUR_YEAR_NEW_FZ	  ,  '0.00'),'FM9999999990') ITV_OF_CUR_YEAR_NEW_FZ
			from ${channel_user}.TB_QDSP_STAT_VIEW_M t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.acct_month}'

		</e:q4o>${e:java2json(fzxn_obj)}
	</e:case>
	<e:description>发展效能趋势</e:description>
	<e:case value="fzxn_trendList">
		<e:q4l var="fzxn_list">
		select '发展效能趋势',
				TO_CHAR(NVL(CUR_DAY_FZ_YD,       '0'), 'FM99999999999990') CUR_DAY_FZ_YD,
				TO_CHAR(NVL(CUR_DAY_FZ_KD, '0'), 'FM99999999999990') CUR_DAY_FZ_KD,
				TO_CHAR(NVL(CUR_DAY_FZ_ITV, '0'), 'FM99999999999990') CUR_DAY_FZ_ITV
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
                AND d.CHANNEL_NBR = '${param.channel_nbr}'
	            AND d.acct_day like '${param.acct_month}%'
	         order by acct_day
		</e:q4l>${e:java2json(fzxn_list.list)}
	</e:case>
	<e:description>当月日积分趋势</e:description>
	<e:description>上月日积分趋势</e:description>
	<e:case value="fzxn_lasttrendList">
		<e:q4l var="Lastfzxn_list">
		select '发展效能趋势',
				TO_CHAR(NVL(CUR_DAY_FZ_YD,       '0'), 'FM99999999999990') CUR_DAY_FZ_YD,
				TO_CHAR(NVL(CUR_DAY_FZ_KD, '0'), 'FM99999999999990') CUR_DAY_FZ_KD,
				TO_CHAR(NVL(CUR_DAY_FZ_ITV, '0'), 'FM99999999999990') CUR_DAY_FZ_ITV
			 from
            	${channel_user}.TB_QDSP_STAT_VIEW_D d
            where 1 = 1
            	AND d.CHANNEL_NBR = '${param.channel_nbr}'
	            AND d.acct_day like '${param.last_month}%'
	         order by acct_day
		</e:q4l>${e:java2json(Lastfzxn_list.list)}
	</e:case>

	<e:description>发展质态-发展质态表格</e:description>
	<e:case value="fzzt_fzztmonth">
		<e:q4o var="fzzt_obj">
			SELECT
				ACCT_MONTH,
				CUR_MON_NEW_FZ,
				LAST_MON_NEW_FZ,
				CUR_MON_NEW_FZ_RATE,
				CUR_MON_ACTIVE_RATE,
				LAST_MON_ACTIVE_RATE,
				CUR_MON_ACTIVE_RATE_RATE,
				CUR_MON_BILLING_RATE,
				LAST_MON_BILLING_RATE,
				CUR_MON_BILLING_RATE_RATE,
				CUR_MON_REMOVE_RATE,
				LAST_MON_REMOVE_RATE,
				CUR_MON_REMOVE_RATE_RATE,
				CUR_MON_WORTH_RATE,
				LAST_MON_WORTH_RATE,
				CUR_MON_WORTH_RATE_RATE,
				CUR_MON_KD_LEAVE_RATE,
				LAST_MON_KD_LEAVE_RATE,
				CASE WHEN replace(LAST_MON_KD_LEAVE_RATE,'%','') = 0.00 THEN '100.00%'
				ELSE
				CASE WHEN replace(CUR_MON_KD_LEAVE_RATE,'%','') = 0.00 THEN '0.00%'
				ELSE
				to_char(nvl( ((replace(CUR_MON_KD_LEAVE_RATE,'%','') - replace(LAST_MON_KD_LEAVE_RATE,'%',''))/replace(LAST_MON_KD_LEAVE_RATE,'%',''))*100,'0.00'),'FM990.00') END
				END KD_LW_RATE_RATE  ,
				kd_active_cur_mon,
				kd_active_last_mon

			FROM
			(select
				T.ACCT_MONTH              ,
				to_char(nvl(CUR_MON_NEW_FZ,'0'),'FM9999999990')                                CUR_MON_NEW_FZ,
				to_char(nvl(LAST_MON_NEW_FZ,'0'),'FM9999999990')                               LAST_MON_NEW_FZ,
				to_char(nvl(CUR_MON_NEW_FZ_RATE*100,'0.00'),'FM9999999990.00')||'%'            CUR_MON_NEW_FZ_RATE,
				to_char(nvl(CUR_MON_ACTIVE_RATE*100,      '0.00'),'FM9999999990.00')||'%'      CUR_MON_ACTIVE_RATE,
				to_char(nvl(LAST_MON_ACTIVE_RATE*100,     '0.00'),'FM9999999990.00')||'%'      LAST_MON_ACTIVE_RATE,
				to_char(nvl(CUR_MON_ACTIVE_RATE_RATE*100, '0.00'),'FM9999999990.00')||'%'      CUR_MON_ACTIVE_RATE_RATE,
				to_char(nvl(CUR_MON_BILLING_RATE*100,     '0.00'),'FM9999999990.00')||'%'      CUR_MON_BILLING_RATE,
				to_char(nvl(LAST_MON_BILLING_RATE*100,    '0.00'),'FM9999999990.00')||'%'      LAST_MON_BILLING_RATE,
				to_char(nvl(CUR_MON_BILLING_RATE_RATE*100,'0.00'),'FM9999999990.00')||'%'      CUR_MON_BILLING_RATE_RATE,
				to_char(nvl(CUR_MON_REMOVE_RATE*100,      '0.00'),'FM9999999990.00')||'%'      CUR_MON_REMOVE_RATE,
				to_char(nvl(LAST_MON_REMOVE_RATE*100,     '0.00'),'FM9999999990.00')||'%'      LAST_MON_REMOVE_RATE,
				to_char(nvl(CUR_MON_REMOVE_RATE_RATE*100, '0.00'),'FM9999999990.00')||'%'      CUR_MON_REMOVE_RATE_RATE,
				to_char(nvl(CUR_MON_WORTH_RATE,'0'),'FM9999999990.00')                               CUR_MON_WORTH_RATE,
				to_char(nvl(LAST_MON_WORTH_RATE,'0'),'FM9999999990.00')                               LAST_MON_WORTH_RATE,
				to_char(nvl(CUR_MON_WORTH_RATE_RATE*100,'0'),'FM9999999990.00')||'%'           CUR_MON_WORTH_RATE_RATE,
				CASE WHEN KD_JF_CNT = 0 THEN '0.00%'
					ELSE to_char(nvl((KD_LW_CNT/KD_JF_CNT)*100,'0'),'FM9999999990.00')||'%'  END  CUR_MON_KD_LEAVE_RATE,

				CASE WHEN KD_JF_CNT_LAST = 0 THEN '0.00%'
					ELSE to_char(nvl((KD_LW_CNT_LAST/KD_JF_CNT_LAST)*100,'0'),'FM9999999990.00')||'%'  END  LAST_MON_KD_LEAVE_RATE,
				fun_rate_fmt(kd_active_user,kd_user) kd_active_cur_mon,
				fun_rate_fmt(last_kd_active_user,last_kd_user) kd_active_last_mon

			from ${channel_user}.TB_QDSP_STAT_VIEW_M t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.acct_month}'
			)
		</e:q4o>${e:java2json(fzzt_obj)}
	</e:case>
	<e:description>发展质态-发展质态表格</e:description>
	<e:case value="fzzt_fzztmonthdna">
		<e:q4o var="fzzt_obj">
			select
				T.ACCT_MONTH              ,
				to_char(nvl(CUR_MON_ALL_USER,'0'),'FM9999999990')                                CUR_MON_ALL_USER,
				CASE WHEN CUR_MON_ALL_USER = 0 THEN '0'
				ELSE
				to_char(nvl(CUR_MON_ALL_SOURCE/CUR_MON_ALL_USER,'0'),'FM9999999990.0')  END  CUR_DNA_ALL_JF,

				to_char(nvl(LAST_MON_ALL_USER,'0'),'FM9999999990')                                LAST_MON_ALL_USER,
				CASE WHEN LAST_MON_ALL_USER = 0 THEN '0'
				ELSE
				to_char(nvl(LAST_MON_ALL_SOURCE/LAST_MON_ALL_USER,'0'),'FM9999999990.0')  END  LAST_DNA_ALL_JF,


				CASE WHEN CUR_MON_COMP_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       COMP_SOURCE/CUR_MON_COMP_SOURCE_USER,'0.00'),'FM99990.00') END CUR_COMP_SCORE,
				CASE WHEN CUR_MON_PCARD_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       PCARD_SOURCE/CUR_MON_PCARD_SOURCE_USER,'0.00'),'FM99990.00') END CUR_PCARD_SCORE,
				CASE WHEN CUR_MON_TER_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       TER_SOURCE/CUR_MON_TER_SOURCE_USER,'0.00'),'FM99990.00') END CUR_TER_SCORE,
				CASE WHEN CUR_MON_CERT_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       CERT_SOURCE/CUR_MON_CERT_SOURCE_USER,'0.00'),'FM99990.00') END CUR_CERT_SCORE,
				CASE WHEN CUR_MON_AGREE_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       AGREE_SOURCE/CUR_MON_AGREE_SOURCE_USER,'0.00'),'FM99990.00') END CUR_AGREE_SCORE,
				CASE WHEN CUR_MON_YCK_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       YCK_SOURCE/CUR_MON_YCK_SOURCE_USER,'0.00'),'FM99990.00') END CUR_YCK_SCORE,
				CASE WHEN CUR_MON_LEVEL_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       LEVEL_SOURCE/CUR_MON_LEVEL_SOURCE_USER,'0.00'),'FM99990.00') END CUR_LEVEL_SCORE,



				CASE WHEN LAST_MON_COMP_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       COMP_SOURCE_LAST/LAST_MON_COMP_SOURCE_USER,'0.00'),'FM99990.00') END LAST_COMP_SCORE,
				CASE WHEN LAST_MON_PCARD_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       PCARD_SOURCE_LAST/LAST_MON_PCARD_SOURCE_USER,'0.00'),'FM99990.00') END LAST_PCARD_SCORE,
				CASE WHEN LAST_MON_TER_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       TER_SOURCE_LAST/LAST_MON_TER_SOURCE_USER,'0.00'),'FM99990.00') END LAST_TER_SCORE,
				CASE WHEN LAST_MON_CERT_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       CERT_SOURCE_LAST/LAST_MON_CERT_SOURCE_USER,'0.00'),'FM99990.00') END LAST_CERT_SCORE,
				CASE WHEN LAST_MON_AGREE_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       AGREE_SOURCE_LAST/LAST_MON_AGREE_SOURCE_USER,'0.00'),'FM99990.00') END LAST_AGREE_SCORE,
				CASE WHEN LAST_MON_YCK_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       YCK_SOURCE_LAST/LAST_MON_YCK_SOURCE_USER,'0.00'),'FM99990.00') END LAST_YCK_SCORE,
				CASE WHEN LAST_MON_LEVEL_SOURCE_USER = 0 THEN '0.00'
				ELSE TO_CHAR(NVL(
				       LEVEL_SOURCE_LAST/LAST_MON_LEVEL_SOURCE_USER,'0.00'),'FM99990.00') END LAST_LEVEL_SCORE

			from ${channel_user}.TB_QDSP_STAT_VIEW_M t
			where
				t.CHANNEL_NBR = '${param.channel_nbr}'

				and t.ACCT_MONTH = '${param.acct_month}'

		</e:q4o>${e:java2json(fzzt_obj)}
	</e:case>


	<e:description>发展质态趋势</e:description>
	<e:case value="getFzztList">
		<e:q4l var="Dayzt_list">
		SELECT '发展质态趋势',
			d.acct_day,
			to_char(NVL(d.CUR_MON_ACTIVE_RATE*100,'0.00'),'${format2}') CUR_MON_ACTIVE_RATE,
			to_char(NVL(d.CUR_MON_BILLING_RATE*100,'0.00'),'${format2}') CUR_MON_BILLING_RATE,
			to_char(NVL(d.CUR_MON_REMOVE_RATE*100,'0.00'),'${format2}') CUR_MON_REMOVE_RATE,
			NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE
		FROM
			${channel_user}.TB_QDSP_STAT_VIEW_D d
        WHERE  1 = 1
        AND   d.acct_day like '${param.acct_month}%'
            and d.channel_nbr = '${param.channel_nbr}'
          order by d.acct_day
		</e:q4l>${e:java2json(Dayzt_list.list)}
	</e:case>
	<e:description>上月日积分趋势</e:description>
	<e:case value="getLastFzztList">
		<e:q4l var="LastZt_list">
		SELECT '发展质态趋势',
			d.acct_day,
			to_char(NVL(d.CUR_MON_ACTIVE_RATE*100,'0.00'),'${format2}') CUR_MON_ACTIVE_RATE,
			to_char(NVL(d.CUR_MON_BILLING_RATE*100,'0.00'),'${format2}') CUR_MON_BILLING_RATE,
			to_char(NVL(d.CUR_MON_REMOVE_RATE*100,'0.00'),'${format2}') CUR_MON_REMOVE_RATE,
			NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE
		FROM
			${channel_user}.TB_QDSP_STAT_VIEW_D d
        WHERE  1 = 1
        AND   d.acct_day like '${param.last_month}%'
            and d.channel_nbr = '${param.channel_nbr}'
          order by d.acct_day
		</e:q4l>${e:java2json(LastZt_list.list)}
	</e:case>
	<e:description>发展效益-效益分析</e:description>
    <e:case value="qdxy_analyze_data">
        <e:q4o var="qdxy_data">
            select '渠道效益',
            CUR_MON_BENEFIT_RATE,LAST_MON_BENEFIT_RATE,CUR_MON_BENEFIT_RATE_RATE,
            CUR_MON_AMOUNT,LAST_MON_AMOUNT,CUR_MON_AMOUNT_RATE,
            CUR_MON_INCOME,LAST_MON_INCOME,CUR_MON_INCOME_RATE,
            CUR_MON_CB,LAST_MON_CB,CUR_MON_COST_RATE,
            CUR_MON_100_INCOME,
            LAST_MON_100_INCOME,
            CUR_MON_100_INCOME_RATE,
            to_char(CUR_MON_100_USER,'${format2}')  CUR_MON_100_USER,
            to_char(LAST_MON_100_USER,'${format2}')  LAST_MON_100_USER,
            CUR_MON_100_USER_RATE,
            cur_total_yj,last_total_yj,
            cur_fc_yj CUR_MONTH_ALL_FC,last_fc_yj LAST_MONTH_ALL_FC,
            cur_jl_yj CUR_MONTH_ALL_JL, last_jl_yj LAST_MONTH_ALL_JL,
            cur_cb_yj CUR_MONTH_ALL_YJ, last_cb_yj LAST_MONTH_ALL_YJ,
            cur_zc_yj CUR_MONTH_ALL_ZC, last_zc_yj LAST_MONTH_ALL_ZC,

            CASE WHEN nvl(cur_cb_yj,0) =0 then '0.00%' else
               case when NVL(last_cb_yj, 0) = 0
                             THEN '100.00%'
                               ELSE
                                 to_char(round(((cur_cb_yj - last_cb_yj) / last_cb_yj),4)*100,'FM9990.00')||'%' END
                                 end CUR_MONTH_ALL_YJ_RATE,
            CASE WHEN nvl(cur_jl_yj,0) =0 then '0.00%' else
               case when NVL(last_jl_yj, 0) = 0
                             THEN '100.00%'
                               ELSE
                                 to_char(round(((cur_jl_yj - last_jl_yj) / last_jl_yj),4)*100,'FM9990.00')||'%' END
                                 end CUR_MONTH_ALL_JL_RATE,
            CASE WHEN nvl(cur_zc_yj,0) =0 then '0.00%' else
               case when NVL(last_zc_yj, 0) = 0
                             THEN '100.00%'
                               ELSE
                                 to_char(round(((cur_zc_yj - last_zc_yj) / last_zc_yj),4)*100,'FM9990.00')||'%' END
                                 end CUR_MONTH_ALL_ZC_RATE,
            CASE WHEN nvl(cur_fc_yj,0) =0 then '0.00%' else
               case when NVL(last_fc_yj, 0) = 0
                             THEN '100.00%'
                               ELSE
                                 to_char(round(((cur_fc_yj - last_fc_yj) / last_fc_yj),4)*100,'FM9990.00')||'%' END
                                 end CUR_MONTH_ALL_FC_RATE,
            CASE WHEN nvl(cur_total_yj,0) =0 then '0.00%' else
               case when NVL(last_total_yj, 0) = 0
                             THEN '100.00%'
                               ELSE
                                 to_char(round(((cur_total_yj - last_total_yj) / last_total_yj),4)*100,'FM9990.00')||'%' END
                                 end CUR_MONTH_YJ_RATE
            from(
            select TO_CHAR(NVL(CUR_MON_BENEFIT_RATE*100, '0'), '${format2}')||'%' CUR_MON_BENEFIT_RATE,
					TO_CHAR(NVL(LAST_MON_BENEFIT_RATE*100, '0'), '${format2}')||'%' LAST_MON_BENEFIT_RATE,
					TO_CHAR(NVL(CUR_MON_BENEFIT_RATE_RATE*100, '0'), '${format2}')||'%' CUR_MON_BENEFIT_RATE_RATE,

					TO_CHAR(NVL(CUR_MON_AMOUNT,       '0'), '${format2}') CUR_MON_AMOUNT,
					TO_CHAR(NVL(LAST_MON_AMOUNT,       '0'), '${format2}') LAST_MON_AMOUNT,
					TO_CHAR(NVL(CUR_MON_AMOUNT_RATE*100,       '0'), '${format2}')||'%' CUR_MON_AMOUNT_RATE,

          TO_CHAR(NVL(CUR_MON_INCOME,       '0'), '${format2}') CUR_MON_INCOME,
          TO_CHAR(NVL(LAST_MON_INCOME,       '0'), '${format2}') LAST_MON_INCOME,
          TO_CHAR(NVL(CUR_MON_INCOME_RATE*100,       '0'), '${format2}')||'%' CUR_MON_INCOME_RATE,

          TO_CHAR(NVL(CUR_MON_CB,           '0'), '${format2}') CUR_MON_CB,
          TO_CHAR(NVL(LAST_MON_CB,       '0'), '${format2}') LAST_MON_CB,
          TO_CHAR(NVL(CUR_MON_COST_RATE*100,       '0'), '${format2}')||'%' CUR_MON_COST_RATE,

          TO_CHAR(NVL(CUR_MON_100_INCOME,   '0'), '${format2}') CUR_MON_100_INCOME,
          TO_CHAR(NVL(LAST_MON_100_INCOME,       '0'), '${format2}') LAST_MON_100_INCOME,
          TO_CHAR(NVL(CUR_MON_100_INCOME_RATE*100,       '0'), '${format2}')||'%' CUR_MON_100_INCOME_RATE,

          TO_CHAR(NVL(CUR_MON_100_USER,     '0.00'), '${format2}') CUR_MON_100_USER,
          TO_CHAR(NVL(LAST_MON_100_USER,       '0.00'), '${format2}') LAST_MON_100_USER,
          TO_CHAR(NVL(CUR_MON_100_USER_RATE*100,       '0'), '${format2}')||'%' CUR_MON_100_USER_RATE,


          TO_CHAR(NVL((CUR_MONTH_PRODUCT_REWARD+CUR_MONTH_FC_REWARD),       '0'), '${format2}') CUR_MONTH_ALL_FC,
          TO_CHAR(NVL((CUR_MONTH_ARRIVE_REWARD+CUR_MONTH_SALE_REWARD+CUR_MONTH_TMN_REWARD),       '0'), '${format2}') CUR_MONTH_ALL_JL,
          TO_CHAR(NVL((CUR_MONTH_FZ_REWARD+CUR_MONTH_SERVICE_REWARD+CUR_MONTH_CZ_JF_REWARD),       '0'), '${format2}') CUR_MONTH_ALL_YJ,
          TO_CHAR(NVL((CUR_MONTH_HOUSE_REWARD+CUR_MONTH_ZX_REWARD+CUR_MONTH_OTHER_REWARD),       '0'), '${format2}') CUR_MONTH_ALL_ZC,

          TO_CHAR(NVL((LAST_MONTH_PRODUCT_REWARD+LAST_MONTH_FC_REWARD),       '0'), '${format2}') LAST_MONTH_ALL_FC,
          TO_CHAR(NVL((LAST_MONTH_ARRIVE_REWARD+LAST_MONTH_SALE_REWARD+LAST_MONTH_TMN_REWARD),       '0'), '${format2}') LAST_MONTH_ALL_JL,
					TO_CHAR(NVL((LAST_MONTH_FZ_REWARD+LAST_MONTH_SERVICE_REWARD+LAST_MONTH_CZ_JF_REWARD),       '0'), '${format2}') LAST_MONTH_ALL_YJ,
					TO_CHAR(NVL((LAST_MONTH_HOUSE_REWARD+LAST_MONTH_ZX_REWARD+LAST_MONTH_OTHER_REWARD),       '0'), '${format2}') LAST_MONTH_ALL_ZC,

          CUR_MONTH_FZ_REWARD + CUR_MONTH_SERVICE_REWARD + CUR_MONTH_CZ_JF_REWARD cur_cb_yj,
          LAST_MONTH_FZ_REWARD + LAST_MONTH_SERVICE_REWARD + LAST_MONTH_CZ_JF_REWARD last_cb_yj,

          CUR_MONTH_ARRIVE_REWARD + CUR_MONTH_SALE_REWARD + CUR_MONTH_TMN_REWARD cur_jl_yj,
          LAST_MONTH_ARRIVE_REWARD + LAST_MONTH_SALE_REWARD + LAST_MONTH_TMN_REWARD last_jl_yj,

          CUR_MONTH_HOUSE_REWARD + CUR_MONTH_ZX_REWARD + CUR_MONTH_OTHER_REWARD cur_zc_yj,
          LAST_MONTH_HOUSE_REWARD + LAST_MONTH_ZX_REWARD + LAST_MONTH_OTHER_REWARD last_zc_yj,

          CUR_MONTH_PRODUCT_REWARD + CUR_MONTH_FC_REWARD cur_fc_yj,
          LAST_MONTH_PRODUCT_REWARD + LAST_MONTH_FC_REWARD last_fc_yj,

          CUR_MONTH_PRODUCT_REWARD+CUR_MONTH_FC_REWARD+CUR_MONTH_ARRIVE_REWARD+CUR_MONTH_SALE_REWARD
                   +CUR_MONTH_TMN_REWARD+CUR_MONTH_FZ_REWARD+CUR_MONTH_SERVICE_REWARD+CUR_MONTH_CZ_JF_REWARD+
              CUR_MONTH_HOUSE_REWARD+CUR_MONTH_ZX_REWARD+CUR_MONTH_OTHER_REWARD  cur_total_yj,
          LAST_MONTH_PRODUCT_REWARD+LAST_MONTH_FC_REWARD+LAST_MONTH_ARRIVE_REWARD+LAST_MONTH_SALE_REWARD
                   +LAST_MONTH_TMN_REWARD+LAST_MONTH_FZ_REWARD+LAST_MONTH_SERVICE_REWARD+LAST_MONTH_CZ_JF_REWARD+
              LAST_MONTH_HOUSE_REWARD+LAST_MONTH_ZX_REWARD+LAST_MONTH_OTHER_REWARD last_total_yj

          from
            	${channel_user}.TB_QDSP_STAT_VIEW_M d
            where 1 = 1
	            AND d.acct_month ='${param.acct_month}'
	            and d.channel_nbr = '${param.channel_nbr}')
        </e:q4o>${e:java2json(qdxy_data)}
    </e:case>
	<e:description>发展质态-趋势柱状图</e:description>
    <e:case value="ml_trend">
        <e:q4l var="mltrend_list">
            SELECT MONTH_CODE,
            to_char(NVL(CUR_MON_ACTIVE_RATE*100,'0.00'), '${format2}') CUR_MON_ACTIVE_RATE,
            to_char(NVL(CUR_MON_BILLING_RATE*100,'0.00'), '${format2}') CUR_MON_BILLING_RATE,
            to_char(NVL(CUR_MON_REMOVE_RATE*100,'0.00'), '${format2}') CUR_MON_REMOVE_RATE,
            NVL(CUR_MON_WORTH_RATE,'0.00') CUR_MON_DNA_RATE,
            CASE WHEN KD_JF_CNT = 0 THEN '0.00%'
						ELSE to_char(nvl((KD_LW_CNT/KD_JF_CNT)*100,'0'),'FM9999999990.00')  END  CUR_MON_KD_LEAVE_RATE

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
            and m.channel_nbr = '${param.channel_nbr}'
            order by a.month_code
        </e:q4l>${e: java2json(mltrend_list.list) }
    </e:case>
    <e:description>发展效益-毛利率柱状图</e:description>
    <e:case value="mlqs_trend">
        <e:q4l var="mlqstrend_list">
            SELECT MONTH_CODE,
            to_char(NVL(CUR_MON_BENEFIT_RATE*100,'0.00'), '${format2}') CUR_MON_BENEFIT_RATE
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
            and m.channel_nbr = '${param.channel_nbr}'
            order by a.month_code
        </e:q4l>${e: java2json(mlqstrend_list.list) }
    </e:case>

    <e:description>实体渠道清单 begin </e:description>
  <e:case value="business_locations_data_list">

      <e:q4l var="business_locations_list">
          select * from
              (SELECT '大表格',T.*, ROWNUM ROW_NUM FROM (
               select NVL(g.latn_ord,'9999') latn_ord,
                    d.LATN_NAME,
                    d.LATN_ID,
                    d.BUREAU_NO,
                    DECODE(replace(replace(g.BUREAU_NAME,'分局',''),'电信局',''),'其他','',replace(replace(g.BUREAU_NAME,'分局',''),'电信局','')) BUREAU_NAME,
                    d.BRANCH_NO,
                    DECODE(d.BRANCH_NAME,'其他','',d.BRANCH_NAME) BRANCH_NAME,
                    d.CHANNEL_NBR,
                    d.CHANNEL_NAME,
                    NVL(d.ENTITY_CHANNEL_TYPE_NAME,' ') ENTITY_CHANNEL_TYPE_NAME,<e:description>未归类</e:description>
                    to_char(NVL(d.CUR_MONTH_SUM_JF      ,'0.00'), '${format2}')    CUR_MONTH_SUM_JF      ,

                    CASE WHEN d.USER_CUR_MONTH_SUM_JF = 0 THEN '0.00'
                    ELSE
                    to_char(NVL(d.CUR_MONTH_SUM_JF/d.USER_CUR_MONTH_SUM_JF,'0.00'), '${format2}')  END  CUR_MONTH_AVE_JF      ,

                    to_char(NVL(d.CUR_DAY_JF      ,'0.00'), '${format2}')    CUR_DAY_JF      ,
                    CASE WHEN d.USER_CUR_DAY_JF = 0 THEN '0.00'
                    ELSE
                    to_char(NVL(d.CUR_DAY_JF/d.USER_CUR_DAY_JF      ,'0.00'), '${format2}')  END  CUR_DAY_AVE_JF      ,

                    to_char(NVL(d.FZ_OF_CUR_MONTH_SUM_JF,'0.00'), '${format2}')    FZ_OF_CUR_MONTH_SUM_JF,
                    to_char(NVL(d.CL_OF_CUR_MONTH_SUM_JF,'0.00'), '${format2}')    CL_OF_CUR_MONTH_SUM_JF,

                    to_char(NVL(d.CUR_MONTH_FZ          ,'0'), 'FM99999999999990')          CUR_MONTH_FZ          ,
                    to_char(NVL(d.CUR_MONTH_FZ_YD       ,'0'), 'FM99999999999990')          CUR_MONTH_FZ_YD       ,
                    to_char(NVL(d.CUR_MONTH_FZ_KD       ,'0'), 'FM99999999999990')          CUR_MONTH_FZ_KD       ,
                    to_char(NVL(d.CUR_MONTH_FZ_ITV      ,'0'), 'FM99999999999990')          CUR_MONTH_FZ_ITV      ,

                    to_char(NVL(d.CUR_DAY_FZ          ,'0'), 'FM99999999999990')          CUR_DAY_FZ          ,
                    to_char(NVL(d.CUR_DAY_FZ_YD       ,'0'), 'FM99999999999990')          CUR_DAY_FZ_YD       ,
                    to_char(NVL(d.CUR_DAY_FZ_KD       ,'0'), 'FM99999999999990')          CUR_DAY_FZ_KD       ,
                    to_char(NVL(d.CUR_DAY_FZ_ITV      ,'0'), 'FM99999999999990')          CUR_DAY_FZ_ITV      ,

                    to_char(NVL(m.CUR_MON_ACTIVE_RATE*100   ,'0.00'), '${format2}')||'%'    CUR_MON_ACTIVE_RATE   ,
                    to_char(NVL(m.CUR_MON_ACTIVE      ,'0'), 'FM99999999999990')          CUR_MON_ACTIVE_USER      ,
                    to_char(NVL(m.CUR_MON_BILLING_RATE*100  ,'0.00'), '${format2}')||'%'    CUR_MON_BILLING_RATE  ,
                    to_char(NVL(m.CUR_MON_BILLING      ,'0'), 'FM99999999999990')          CUR_MON_BILLING_USER      ,
                    to_char(NVL(m.CUR_MON_REMOVE_RATE*100   ,'0.00'), '${format2}')||'%'    CUR_MON_REMOVE_RATE   ,
                    to_char(NVL(m.CUR_MON_REMOVE      ,'0'), 'FM99999999999990')          CUR_MON_REMOVE_USER      ,
                    to_char(NVL(m.CUR_MON_WORTH_RATE    ,'0.00'), '${format2}')   CUR_MON_WORTH_RATE    ,
                    to_char(NVL(m.CUR_MON_NEW_FZ      ,'0'), 'FM99999999999990')          CUR_MON_NEW_FZ      ,
                    to_char(NVL(m.CUR_MON_BENEFIT_RATE*100  ,'0.00'), '${format2}')||'%'    CUR_MON_BENEFIT_RATE  ,

                    to_char(NVL(m.CUR_MON_INCOME/10000        ,'0.00'), '${format2}')    CUR_MON_INCOME        ,
                    to_char(NVL(m.CUR_MON_CB/10000            ,'0.00'), '${format2}')    CUR_MON_CB
                    ,COUNT(1) OVER() c_num  from
                    ${channel_user}.TB_QDSP_STAT_VIEW_D d
                        left join
                    (select * from ${channel_user}.TB_QDSP_STAT_VIEW_M where acct_month='${param.acct_month}' and flag = '5' and channel_spec = '1') m
                  on d.channel_nbr = m.channel_nbr
                  left join (select distinct t.latn_id,latn_name, t.bureau_no,t.city_ord,bureau_name,t.latn_ord,branch_no,branch_ord,branch_name
                          from ${channel_user}.tb_gis_channel_org t) g
                on  d.bureau_no = g.bureau_no and d.branch_no = g.branch_no
                  where d.acct_day ='${param.beginDate}' and d.flag = '5'
                  	and d.channel_spec = '1'
              <e:if condition="${param.region_id ne '' && param.region_id != null && param.region_id != '999'}">
                    and d.latn_id='${param.region_id}'
              </e:if>
              <e:if condition="${param.cityNo ne '' && param.cityNo != null}">
                    and d.bureau_no='${param.cityNo}'
              </e:if>
              <e:if condition="${param.centerNo ne '' && param.centerNo != null}">
                    and d.branch_no='${param.centerNo}'
              </e:if>
              <e:if condition="${param.entity_channel_type ne '' && param.entity_channel_type != null}">
              	<e:if condition="${param.entity_channel_type eq '99'}" var="no_type">
              		and d.entity_channel_type is null
              	</e:if>
              	<e:else condition="${no_type}">
              		and d.entity_channel_type='${param.entity_channel_type}'
              	</e:else>
              </e:if>
              <e:if condition="${!empty param.saleType}">
              		<e:if condition="${param.saleType eq '0'}">
              			and d.zero_sale_channel = 1
              		</e:if>
              		<e:if condition="${param.saleType eq '1'}">
              			and d.low_sale_channel = 1
              		</e:if>
              		<e:if condition="${param.saleType eq '2'}">
              			and d.high_channel = 1
              		</e:if>
              		<e:if condition="${param.saleType eq '-1'}">
              			and (d.zero_sale_channel = 0 and d.low_sale_channel = 0 and d.high_channel = 0)
              		</e:if>
              </e:if>
              <e:if condition="${param.channelName ne '' && param.channelName != null}">
                    and d.channel_name like '%${param.channelName}%'
              </e:if>
                order by g.latn_ord,G.city_ord,G.branch_ord
          ) T
          )
          WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
      </e:q4l>${e: java2json(business_locations_list.list) }
  </e:case>
</e:switch>