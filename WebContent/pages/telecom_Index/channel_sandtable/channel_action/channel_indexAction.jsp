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
<e:set var="tab3">
	${channel_user}.tb_gis_qd_bureau_ref
</e:set>
<e:set var="jing_du">
	1
</e:set>
<e:set var="sql_part0">
	fun_div_fmt(
		fun_div_fmt(sum(nvl(bjl,0)),sum(nvl(bjl_channel_num,0)),1)
		+fun_div_fmt(sum(nvl(yhgml,0)),sum(nvl(yhgml_channel_num,0)),1)
		+fun_div_fmt(sum(nvl(yhztl,0)),sum(nvl(yhztl_channel_num,0)),1)
		+fun_div_fmt(sum(nvl(qdxyl,0)),sum(nvl(qdxyl_channel_num,0)),1)
	,1,1)
</e:set>
<e:set var="sql_part1">
	fun_div_fmt(sum(nvl(bjl,0)),sum(nvl(bjl_channel_num,0)),1) d2,
	fun_div_fmt(sum(nvl(yhgml,0)),sum(nvl(yhgml_channel_num,0)),1) d3,
	fun_div_fmt(sum(nvl(qdxyl,0)),sum(nvl(qdxyl_channel_num,0)),1) d4,
	fun_div_fmt(sum(nvl(yhztl,0)),sum(nvl(yhztl_channel_num,0)),1) d5,

	${sql_part0} d1
</e:set>
<e:set var="sql_part2">
	fun_div_fmt(sum(nvl(bjl,0)),sum(nvl(bjl_channel_num,0))) d2,
	fun_div_fmt(sum(nvl(yhgml,0)),sum(nvl(yhgml_channel_num,0))) d3,
	fun_div_fmt(sum(nvl(qdxyl,0)),sum(nvl(qdxyl_channel_num,0))) d4,
	fun_div_fmt(sum(nvl(yhztl,0)),sum(nvl(yhztl_channel_num,0))) d5,

	fun_div_fmt(
		fun_div_fmt(sum(nvl(bjl,0)),sum(nvl(bjl_channel_num,0)))
		+fun_div_fmt(sum(nvl(yhgml,0)),sum(nvl(yhgml_channel_num,0)))
		+fun_div_fmt(sum(nvl(yhztl,0)),sum(nvl(yhztl_channel_num,0)))
		+fun_div_fmt(sum(nvl(qdxyl,0)),sum(nvl(qdxyl_channel_num,0)))
	)
	d1
</e:set>
<e:switch value="${param.eaction}">
  <e:case value="tab1_index_top">
    <e:q4o var="dataObject">
      SELECT
      '渠道效能-上方指标',
		<e:if condition='${param.region_type eq "1" || param.region_type eq "2"}'>
		area_description,
		</e:if>
		<e:if condition='${param.region_type eq "3"}'>
		BUREAU_NAME,
		</e:if>
		<e:if condition='${param.region_type eq "4"}'>
		BRANCH_NAME,
		</e:if>
		${sql_part1}
		 FROM ${tab1}
		WHERE flag = '${param.region_type-1}' AND acct_month = '${param.acct_month}'
		<e:if condition='${!empty param.region_id && param.region_id ne "999"}'>
			<e:if condition='${param.region_type eq "2"}'>
				and latn_id = '${param.region_id}'
			</e:if>
			<e:if condition='${param.region_type eq "3"}'>
				and bureau_no = '${param.bureau_no}'
			</e:if>
			<e:if condition='${param.region_type eq "4"}'>
				and branch_no = '${param.branch_no}'
			</e:if>
		</e:if>
		GROUP BY
		<e:if condition='${param.region_type eq "1" || param.region_type eq "2"}'>
			latn_id,
			area_description
		</e:if>
		<e:if condition='${param.region_type eq "3"}'>
			bureau_no,
			BUREAU_NAME
		</e:if>
		<e:if condition='${param.region_type eq "4"}'>
			BRANCH_NO,
			BRANCH_NAME
		</e:if>
    </e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:case value="tab1_index_middle">
	<e:q4l var="dataList">
		SELECT
		'渠道效能-分类效能',
		channel_type_name_qd name,
		${sql_part0} value
		 FROM ${tab1} WHERE flag = '${param.region_type-1}' AND acct_month = '${param.acct_month}'
		 <e:if condition='${param.region_type eq "2"}'>
			and latn_id = '${param.region_id}'
		</e:if>
		<e:if condition='${param.region_type eq "3"}'>
			and bureau_no = '${param.bureau_no}'
		</e:if>
		<e:if condition='${param.region_type eq "4"}'>
			and branch_no = '${param.branch_no}'
		</e:if>
		GROUP BY CHANNEL_TYPE_NAME_QD
	</e:q4l>${e:java2json(dataList.list)}
  </e:case>
  <e:case value="tab1_index_middle1">
	<e:q4l var="dataList">
		SELECT
		'渠道效能-分类效能1',
		channel_type_name_qd name,
		sum(nvl(channel_num,0)) value
		 FROM ${tab1} WHERE flag = '${param.region_type-1}' AND acct_month = '${param.acct_month}'
		 <e:if condition='${param.region_type eq "2"}'>
			and latn_id = '${param.region_id}'
		</e:if>
		<e:if condition='${param.region_type eq "3"}'>
			and bureau_no = '${param.bureau_no}'
		</e:if>
		<e:if condition='${param.region_type eq "4"}'>
			and branch_no = '${param.branch_no}'
		</e:if>
		 group by channel_type_name_qd
	</e:q4l>${e:java2json(dataList.list)}
  </e:case>
  <e:case value="tab1_index_bottom">
    <e:q4l var="dataList">
    	select '渠道效能-区域效能',t.* from (
      SELECT
      <e:if condition='${param.region_type eq "1" || param.region_type eq "2"}'>
      	area_description
      </e:if>
      <e:if condition='${param.region_type eq "3"}'>
      	bureau_name
      </e:if>
      <e:if condition='${param.region_type eq "4"}'>
      	branch_name
      </e:if>

			 REGION_NAME,

			${sql_part2},
		    '0' order_num
			 FROM ${tab1}
			WHERE flag = '${param.region_type-1}' AND acct_month = '${param.acct_month}'
			<e:if condition='${param.region_type eq "2"}'>
				and latn_id = '${param.region_id}'
			</e:if>
			<e:if condition='${param.region_type eq "3"}'>
				and bureau_no = '${param.bureau_no}'
			</e:if>
			<e:if condition='${param.region_type eq "4"}'>
				and branch_no = '${param.branch_no}'
			</e:if>

			GROUP BY
			<e:if condition='${param.region_type eq "1" || param.region_type eq "2"}'>
				latn_id,area_description
			</e:if>
			<e:if condition='${param.region_type eq "3"}'>
				bureau_no,bureau_name
			</e:if>
			<e:if condition='${param.region_type eq "4"}'>
				branch_no,branch_name
			</e:if>

			union all

			SELECT
			<e:if condition='${param.region_type eq "1"}'>
      	a.area_description
      </e:if>
      <e:if condition='${param.region_type eq "2"}'>
      	b.bureau_name2
      </e:if>
      <e:if condition='${param.region_type eq "3"}'>
      	channel_name
      </e:if>
      <e:if condition='${param.region_type eq "4"}'>
      	a.grid_name
      </e:if>
			 REGION_NAME,

			${sql_part2},
        <e:if condition='${param.region_type eq "1"}'>
            b.city_order_num
        </e:if>
        <e:if condition='${param.region_type eq "2"}'>
            b.region_order_num
        </e:if>
        <e:if condition='${param.region_type eq "3"}'>
            a.channel_nbr
        </e:if>
        <e:if condition='${param.region_type eq "4"}'>
            a.grid_id
        </e:if>
        order_num
			 FROM (select * from ${tab1} WHERE flag =
			 <e:if condition='${param.region_type eq "3"}' var="bureau_level">
			 	 	5
			 </e:if>
			 <e:else condition="${bureau_level}">
			 		'${param.region_type}'
			 </e:else>
			 AND acct_month = '${param.acct_month}')
			 <e:if condition='${param.region_type eq "1"}'>
			 	a left join (SELECT DISTINCT latn_id,latn_name,city_order_num FROM ${tab3})b
			 	ON a.latn_id = b.latn_id
			 </e:if>
			 <e:if condition='${param.region_type eq "2"}'>
			 	a left join (select distinct bureau_no,bureau_name2,region_order_num from ${tab3}) b
				on a.bureau_no = b.bureau_no
				where latn_id = '${param.region_id}'
			 </e:if>
			<e:if condition='${param.region_type eq "3"}'>
				a where bureau_no = '${param.bureau_no}'
				and channel_spec = '1'
			</e:if>
			<e:if condition='${param.region_type eq "4"}'>
				a where branch_no = '${param.branch_no}'
			</e:if>
			GROUP BY
			<e:if condition='${param.region_type eq "1"}'>
				a.LATN_ID,
				b.city_order_num,
				a.AREA_DESCRIPTION
			</e:if>
			<e:if condition='${param.region_type eq "2"}'>
				a.bureau_no,
				b.region_order_num,
				b.bureau_name2
			</e:if>
			<e:if condition='${param.region_type eq "3"}'>
				a.channel_nbr,
				a.channel_name
			</e:if>
			<e:if condition='${param.region_type eq "4"}'>
				a.grid_id,
				a.grid_name
			</e:if>
			)t
			order by order_num
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

	<e:case value="tab2_index_top">
		<e:q4o var="dataObject">
			SELECT
	      '渠道份额-上方指标',
				fun_rate_fmt(dx_cnt,total_cnt,${jing_du}) d1,
				nvl(dx_cnt,0) d2,
				nvl(yd_cnt,0) d3,
				nvl(lt_cnt,0) d4
			FROM ${channel_user}.TB_GIS_QD_MARKET_COLLECT
				where flag = '${param.region_type-1}'
				AND acct_day = '${param.acct_day}'
				<e:if condition='${!empty param.region_id && param.region_id ne "999"}'>
					<e:if condition='${param.region_type eq "2"}'>
						and latn_id = '${param.region_id}'
					</e:if>
					<e:if condition='${param.region_type eq "3"}'>
						and latn_id = '${param.bureau_no}'
					</e:if>
					<e:if condition='${param.region_type eq "4"}'>
						and latn_id = '${param.branch_no}'
					</e:if>
				</e:if>
		</e:q4o>${e:java2json(dataObject)}
	</e:case>
	<e:case value="tab2_index_top_1">
			<e:q4o var="dataObject">
				select '渠道份额-电信门店数',channel_num from ${channel_user}.TB_QDSP_STAT_VIEW_D 
				where flag = '${param.region_type-1}' 
				and acct_day = '${param.acct_day}'
				<e:if condition='${!empty param.region_id && param.region_id ne "999"}'>
					<e:if condition='${param.region_type eq "2"}'>
						and latn_id = '${param.region_id}'
					</e:if>
					<e:if condition='${param.region_type eq "3"}'>
						and bureau_no = '${param.bureau_no}'
					</e:if>
				</e:if>
			</e:q4o>${e:java2json(dataObject)}
	</e:case>
	<e:case value="tab2_index_middle">
		<e:q4o var="dataObject">
			SELECT
				'渠道份额-分类分析',
				fun_div_fmt(DX_CNT1, dx_cnt1+yd_cnt1+lt_cnt1,${jing_du})*100  VALUE1,
				fun_div_fmt(DX_CNT2, dx_cnt2+yd_cnt2+lt_cnt2,${jing_du})*100  VALUE2,
				fun_div_fmt(DX_CNT3, dx_cnt3+yd_cnt3+lt_cnt3,${jing_du})*100  VALUE3,
				fun_div_fmt(DX_CNT4, dx_cnt4+yd_cnt4+lt_cnt4,${jing_du})*100  VALUE4
			FROM ${channel_user}.TB_GIS_QD_MARKET_COLLECT
			  WHERE
			  flag = '${param.region_type-1}'
			  AND acct_day = '${param.acct_day}'
			  <e:if condition='${param.region_type eq "2"}'>
					and latn_id = '${param.region_id}'
				</e:if>
				<e:if condition='${param.region_type eq "3"}'>
					and latn_id = '${param.bureau_no}'
				</e:if>
				<e:if condition='${param.region_type eq "4"}'>
					and latn_id = '${param.branch_no}'
				</e:if>
		</e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:case value="tab2_index_middle1">
		<e:q4o var="dataObject">
			SELECT
			'渠道份额-分类分析1',
				nvl(dx_cnt1,0) value1,
				nvl(dx_cnt2,0) value2,
				nvl(dx_cnt3,0) value3,
				nvl(dx_cnt4,0) value4
			 FROM ${channel_user}.TB_GIS_QD_MARKET_COLLECT
			 WHERE
			  flag = '${param.region_type-1}'
			  AND acct_day = '${param.acct_day}'
			 	<e:if condition='${param.region_type eq "2"}'>
					and latn_id = '${param.region_id}'
				</e:if>
				<e:if condition='${param.region_type eq "3"}'>
					and latn_id = '${param.bureau_no}'
				</e:if>
				<e:if condition='${param.region_type eq "4"}'>
					and latn_id = '${param.branch_no}'
				</e:if>
		</e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:case value="tab2_index_bottom">
    <e:q4l var="dataList">
      select '渠道份额-区域份额',t.* from (
      SELECT
      	latn_name REGION_NAME,
      	fun_rate_fmt(dx_cnt,total_cnt) d1,
      	fun_rate_fmt(dx_cnt1,dx_cnt1+yd_cnt1+lt_cnt1) d2,
      	fun_rate_fmt(dx_cnt2,dx_cnt2+yd_cnt2+lt_cnt2) d3,
      	fun_rate_fmt(dx_cnt3,dx_cnt3+yd_cnt3+lt_cnt3) d4,
      	fun_rate_fmt(dx_cnt4,dx_cnt4+yd_cnt4+lt_cnt4) d5,
				'0' order_num
			FROM ${channel_user}.TB_GIS_QD_MARKET_COLLECT
			WHERE
				flag = '${param.region_type-1}'
				AND acct_day = '${param.acct_day}'
				<e:if condition='${param.region_type eq "2"}'>
					and latn_id = '${param.region_id}'
				</e:if>
				<e:if condition='${param.region_type eq "3"}'>
					and latn_id = '${param.bureau_no}'
				</e:if>
				<e:if condition='${param.region_type eq "4"}'>
					and latn_id = '${param.branch_no}'
				</e:if>

			union all

			SELECT
				latn_name REGION_NAME,
      	fun_rate_fmt(dx_cnt,total_cnt) d1,
      	fun_rate_fmt(dx_cnt1,dx_cnt1+yd_cnt1+lt_cnt1) d2,
      	fun_rate_fmt(dx_cnt2,dx_cnt2+yd_cnt2+lt_cnt2) d3,
      	fun_rate_fmt(dx_cnt3,dx_cnt3+yd_cnt3+lt_cnt3) d4,
      	fun_rate_fmt(dx_cnt4,dx_cnt4+yd_cnt4+lt_cnt4) d5,
				latn_order order_num
			 FROM ${channel_user}.TB_GIS_QD_MARKET_COLLECT
			 where
			 flag = '${param.region_type}'
			 AND acct_day = '${param.acct_day}'
			 <e:if condition='${param.region_type eq "1"}'>
			 	and parent_id = '999'
			 </e:if>
			 <e:if condition='${param.region_type eq "2"}'>
			 	and parent_id = '${param.region_id}'
			 </e:if>
			 <e:if condition='${param.region_type eq "3"}'>
				and parent_id = '${param.bureau_no}'
			 </e:if>
			 <e:if condition='${param.region_type eq "4"}'>
				and parent_id = '${param.branch_no}'
			 </e:if>
			)t
			order by order_num
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
</e:switch>