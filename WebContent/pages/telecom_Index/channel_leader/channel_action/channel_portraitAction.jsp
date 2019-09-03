<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

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
	<e:case value="getLastDayJFList">
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
			  left join ${channel_user}.TB_QDSP_CHANNEL_m b
			    on a.month_code = b.acct_month
			   and channel_nbr = '${param.channel_nbr}'
			 order by a.month_code
		</e:q4l>${e:java2json(TrendQD_list.list)}
	</e:case>
	<e:description>渠道画像趋势</e:description>

	<e:case value="getKeyKpi">
		<e:q4o var="getKeyKpi_obj">
			select t.ACCT_MONTH,
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
  <e:description>重点指标统计分析 begin </e:description>
  <e:case value="point_data_list">

      <e:q4l var="point_list">
          select * from
          (SELECT T.*, ROWNUM ROW_NUM FROM (

          <e:if condition="${param.flag == '1'}">
              select tt.*,COUNT(1) OVER() c_num  from ${channel_user}.view_GIS_RES_CITY_DAY tt  where acct_day='${param.beginDate}' and flg=1 order by ord
          </e:if>
          <e:if condition="${param.flag == '2'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=1
              and latn_id='${param.region_id}'
              union
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=2
              and parent_id='${param.region_id}'
              )tt order by flg,ord
          </e:if>
          <e:if condition="${param.flag == '3'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=2
              and latn_id='${param.cityNo}'
              union
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=3
              and parent_id='${param.cityNo}'
              )tt order by flg,ord
          </e:if>
          <e:if condition="${param.flag == '4'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=3
              and latn_id='${param.centerNo}'
              union
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=4
              and parent_id='${param.centerNo}'
              )tt order by flg,ord
          </e:if>
          <e:if condition="${param.flag == '5'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=4 and
              latn_id='${param.gridNo}'
              union
              select * from ${channel_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=5
              and parent_id='${param.gridNo}'
              )tt order by flg,ord
          </e:if>
          ) T
          )
          WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
      </e:q4l>${e: java2json(point_list.list) }
  </e:case>
  <e:description>四类小区统计 end</e:description>

  <e:description>实体渠道清单 begin </e:description>
  <e:case value="business_locations_data_list">

      <e:q4l var="business_locations_list">
          select * from
          (SELECT T.*, ROWNUM ROW_NUM FROM (

          <e:if condition="${param.flag == '1'}">
              select tt.*,COUNT(1) OVER() c_num  from ${channel_user}.TB_QDSP_CHANNEL_m tt
              left join (select t.latn_id,
                    t.bureau_no,
                    t.city_order_num,
                    t.region_order_num from ${gis_user}.db_cde_grid t
              group by
                    t.latn_id,
                    t.bureau_no,
                    t.city_order_num,
                    t.region_order_num) d
   			 on d.bureau_no = tt.bureau_no

              where acct_month='${param.beginDate}'
              <e:if condition="${param.channelType ne '' && param.channelType != null}">
                    and channel_type_code_qd='${param.channelType}'
              </e:if>
              <e:if condition="${param.channelName ne '' && param.channelName != null}">
                    and channel_name like '%${param.channelName}%'
              </e:if>
                order by d.city_order_num,d.region_order_num
          </e:if>
          <e:if condition="${param.flag == '2'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${channel_user}.TB_QDSP_CHANNEL_m t
              left join (select t.latn_id,
                    t.bureau_no,
                    t.city_order_num,
                    t.region_order_num from ${gis_user}.db_cde_grid t
              group by
                    t.latn_id,
                    t.bureau_no,
                    t.city_order_num,
                    t.region_order_num) d
    		on d.bureau_no = t.bureau_no
              where acct_month='${param.beginDate}'
              and t.latn_id='${param.region_id}'
              <e:if condition="${param.channelType ne '' && param.channelType != null}">
                    and channel_type_code_qd='${param.channelType}'
              </e:if>
              <e:if condition="${param.channelName ne '' && param.channelName != null}">
                    and channel_name like '%${param.channelName}%'
              </e:if>
              order by d.city_order_num,d.region_order_num
              )tt
          </e:if>
          <e:if condition="${param.flag == '3'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${channel_user}.TB_QDSP_CHANNEL_m
              where acct_month='${param.beginDate}'
              and bureau_no='${param.cityNo}'
              <e:if condition="${param.channelType ne '' && param.channelType != null}">
                    and channel_type_code_qd='${param.channelType}'
              </e:if>
              <e:if condition="${param.channelName ne '' && param.channelName != null}">
                    and channel_name like '%${param.channelName}%'
              </e:if>
              )tt order by area_description,bureau_name,branch_name,channel_name
          </e:if>
          <e:if condition="${param.flag == '4'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${channel_user}.TB_QDSP_CHANNEL_m
              where acct_month='${param.beginDate}'
              and branch_no='${param.centerNo}'
              <e:if condition="${param.channelType ne '' && param.channelType != null}">
                    and channel_type_code_qd='${param.channelType}'
              </e:if>
              <e:if condition="${param.channelName ne '' && param.channelName != null}">
                    and channel_name like '%${param.channelName}%'
              </e:if>
              )tt order by area_description,bureau_name,branch_name,channel_name
          </e:if>
          ) T
          )
          WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
      </e:q4l>${e: java2json(business_locations_list.list) }
  </e:case>
  <e:description>实体渠道清单 end</e:description>

    <e:case value="region_data_list">

        <e:q4l var="region_list">
            select * from
            (SELECT T.*, ROWNUM ROW_NUM FROM (
            select tt.*,COUNT(1) OVER() c_num from ${channel_user}.view_gis_village_lable_collect tt
            where acct_day='${param.beginDate}'
            order by ord
            ) T
            )
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
        </e:q4l>${e: java2json(region_list.list) }
    </e:case>
    <e:description>四类小区统计 end</e:description>

    <e:description>四类小区统计清单 end</e:description>

    <e:case value="region_detail_list">

        <e:q4l var="detail_list">
            select * from
            (SELECT T.*, ROWNUM ROW_NUM FROM (
            select t.*, COUNT(1) OVER() c_num  from ${channel_user}.view_gis_village_lable_detail t
            where t.acct_day='${param.beginDate}'
            <e:if condition="${param.flag == '1'}">
                <e:if condition="${param.village_type ne '' && param.village_type != null}">
                    and t.village_label_flg=${param.village_type}
                </e:if>
            </e:if>
            <e:if condition="${param.flag == '2'}">
                and t.latn_id=${param.region_id}
                <e:if condition="${param.village_type ne '' && param.village_type != null}">
                    and t.village_label_flg=${param.village_type}
                </e:if>

            </e:if>
            <e:if condition="${param.flag == '3'}">
                and t.bureau_no=${param.cityNo}
                <e:if condition="${param.village_type ne '' && param.village_type != null}">
                    and t.village_label_flg=${param.village_type}
                </e:if>
            </e:if>
            <e:if condition="${param.flag == '4'}">
                and t.union_org_code=${param.centerNo}
                <e:if condition="${param.village_type ne '' && param.village_type != null}">
                    and t.village_label_flg=${param.village_type}
                </e:if>
            </e:if>
            <e:if condition="${param.flag == '5'}">
                and t.grid_id=${param.gridNo}
                <e:if condition="${param.village_type ne '' && param.village_type != null}">
                    and t.village_label_flg=${param.village_type}
                </e:if>
            </e:if>
            order by t.city_order_num,t.region_order_num,t.branch_no,t.grid_id,t.village_name
            ) T
            )
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
        </e:q4l>${e: java2json(detail_list.list) }
    </e:case>
    <e:description>四类小区统计清单 end</e:description>


</e:switch>