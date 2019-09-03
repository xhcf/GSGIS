<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_cols">
		total_cnt,
		dx_cnt,
		fun_rate_fmt(dx_cnt,total_cnt) dx_percent,
		dx_cnt1,
		dx_cnt2,
		dx_cnt3,
		dx_cnt4,
		yd_cnt,
		fun_rate_fmt(yd_cnt,total_cnt) yd_percent,
		yd_cnt1,
		yd_cnt2,
		yd_cnt3,
		yd_cnt4,
		lt_cnt,
		fun_rate_fmt(lt_cnt,total_cnt) lt_percent,
		lt_cnt1,
		lt_cnt2,
		lt_cnt3,
		lt_cnt4,
		<e:if condition="${empty param.city_id}" var="empty_city">
				nvl(LATN_ORDER,'0') ORDER_NUM
		</e:if>
		<e:else condition="${empty_city}">
				nvl(LATN_ORDER,'999') ORDER_NUM
		</e:else>
</e:set>
<e:switch value="${param.eaction}">
  <e:case value="list">
    <e:q4l var="dataList">
    	select '渠道份额统计',a.* from (
    	select t.*,row_number() over(ORDER BY order_num) ROW_NUM,COUNT(1) OVER() c_num from (
    	select

    	<e:if condition="${empty param.city_id}" var="empty_city">
	      '' region_id,
	    	'全省' region_name,
    	</e:if>
    	<e:else condition="${empty_city}">
    		a.latn_id region_id,
    		a.latn_name region_name,
    		'' bureau_no,
    		' ' bureau_name,
    	</e:else>
    	${sql_cols}
    	from ${channel_user}.TB_GIS_QD_MARKET_COLLECT a
    	<e:if condition="${empty_city}">
    		where a.flag = 0 and a.acct_day ='${param.acct_day}'
    	</e:if>
    	<e:else condition="${empty_city}">
    		where a.flag = 1 and a.acct_day ='${param.acct_day}'
    		and latn_id = '${param.city_id}'

    	</e:else>

    	union all

      select
      <e:if condition="${empty_city}">
      	latn_id region_id,latn_name region_name,
      </e:if>
      <e:else condition="${empty_city}">
      	b.latn_id||'' region_id,b.latn_name region_name,a.latn_id bureau_no,a.latn_name bureau_name,
      </e:else>
      ${sql_cols}
      from ${channel_user}.TB_GIS_QD_MARKET_COLLECT a
      <e:if condition="${empty_city}">
    		where a.flag = 1 and a.acct_day ='${param.acct_day}'
    	</e:if>
    	<e:else condition="${empty_city}">
    		,(select distinct latn_id,latn_name from ${channel_user}.tb_gis_channel_org where latn_id = '${param.city_id}') b
    		where a.flag = 2 and a.acct_day ='${param.acct_day}'
    		and a.parent_id = b.latn_id
    	</e:else>
      ) t
      )a
      <e:if condition="${!empty param.page}">
      	WHERE ROW_NUM BETWEEN ${param.page} * 20+1 AND ${param.page+1} * 20
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
</e:switch>