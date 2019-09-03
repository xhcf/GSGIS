<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_cols">
		nvl(channel_num,0) channel_num,
		nvl(zero_sale_channel,0) zero_sale_channel,
		fun_rate_fmt(zero_sale_channel,channel_num) zero_rate,
		nvl(low_sale_channel,0) low_sale_channel,
		fun_rate_fmt(low_sale_channel,channel_num) low_rate,
		nvl(high_channel,0) high_channel,
		fun_rate_fmt(high_channel,channel_num) high_rate
</e:set>
<e:switch value="${param.eaction}">
  <e:case value="list">
    <e:q4l var="dataList">
    	<e:if condition="${!empty param.channel_type}" var="has_channel_type">
    		select '实体渠道网点销量分析_has',a.* from (
		    	select a.*,
		       row_number() over(ORDER BY order_num) ROW_NUM,
		       COUNT(1) OVER() c_num
		  			from (select 
		  				<e:if condition="${param.flg eq '1'}">
		  						'' region_id,
		               '全省' region_name,
		          </e:if>
		          <e:if condition="${param.flg eq '2'}">
		          		a.latn_id region_id,
		              a.latn_name region_name,
		              '' bureau_no,
		              '' bureau_name,
		          </e:if>
		               nvl(a.entity_channel_type,99) entity_channel_type,
		               nvl(a.entity_channel_type_name,'未归类') entity_channel_type_name,
		               count(channel_nbr) channel_num,
		               sum(zero_sale_channel) zero_sale_channel,
		               fun_rate_fmt(sum(zero_sale_channel), sum(channel_nbr)) zero_rate,
		               sum(low_sale_channel) low_sale_channel,
		               fun_rate_fmt(sum(low_sale_channel), sum(channel_nbr)) low_rate,
		               sum(high_channel) high_channel,
		               fun_rate_fmt(sum(high_channel), sum(channel_nbr)) high_rate,
		               '0' order_Num
		          from qdsp.TB_QDSP_STAT_VIEW_m a
		         where a.acct_month = '${param.acct_month}'
		           and a.channel_spec = 1
		           and a.flag = 5
		           <e:if condition="${param.channel_type eq '99'}" var="no_type">
              		and a.entity_channel_type is null
              	</e:if>
              	<e:else condition="${no_type}">
              		and a.entity_channel_type='${param.channel_type}'
              	</e:else>
		           <e:if condition="${param.flg eq '2'}">
		           	and a.latn_id = '${param.city_id}'
		           </e:if>
		         group by 
		         <e:if condition="${param.flg eq '2'}">
		         		a.latn_id,a.latn_name,
		         </e:if>
		         a.entity_channel_type, a.entity_channel_type_name
		        union all
		        select a.latn_id region_id,
		               a.latn_name region_name,
		               <e:if condition="${param.flg eq '2'}">
		               		a.bureau_no,
               				a.bureau_name,
		               </e:if>
		               nvl(a.entity_channel_type,99) entity_channel_type,
		               nvl(a.entity_channel_type_name,'未归类') entity_channel_type_name,
		               count(channel_nbr) channel_num,
		               sum(zero_sale_channel) zero_sale_channel,
		               fun_rate_fmt(sum(zero_sale_channel), sum(channel_nbr)) zero_rate,
		               sum(low_sale_channel) low_sale_channel,
		               fun_rate_fmt(sum(low_sale_channel), sum(channel_nbr)) low_rate,
		               sum(high_channel) high_channel,
		               fun_rate_fmt(sum(high_channel), sum(channel_nbr)) high_rate,
		               order_num
		          from qdsp.TB_QDSP_STAT_VIEW_m a,
		               (select distinct 
		               <e:if condition="${param.flg eq '1'}">
		               	latn_id, latn_name, latn_ord order_num
		             	 </e:if>
		             	 <e:if condition="${param.flg eq '2'}">
		               	latn_id,bureau_no, bureau_name, city_ord order_num
		             	 </e:if>
		                  from qdsp.tb_gis_channel_org
		                <e:if condition="${param.flg eq '2'}">
		                	where latn_id = '${param.city_id}' 
		              	</e:if>
		                ) b
		         where a.acct_month = '${param.acct_month}'
		         		<e:if condition="${param.flg eq '1'}">
		           		and a.latn_id = b.latn_id
		         		</e:if>
		         		<e:if condition="${param.flg eq '2'}">
		         			and a.latn_id = b.latn_id
		           		and a.bureau_No = b.bureau_no
		         		</e:if>
		           and a.channel_spec = 1
		           and a.flag = 5
		           <e:if condition="${param.channel_type eq '99'}" var="no_type">
              		and a.entity_channel_type is null
               </e:if>
               <e:else condition="${no_type}">
              		and a.entity_channel_type='${param.channel_type}'
               </e:else>
		         group by a.latn_id,
		                  a.latn_name,
		                  <e:if condition="${param.flg eq '2'}">
		                  	a.bureau_no,
                  			a.bureau_name,
		                  </e:if>
		                  order_num,
		                  a.entity_channel_type,
		                  a.entity_channel_type_name
		         order by order_num) a
         ) a
    	</e:if>
    	<e:else condition="has_channel_type">
    		select '实体渠道网点销量分析',a.* from (
		    	select t.*,row_number() over(ORDER BY order_num) ROW_NUM,COUNT(1) OVER() c_num from (
			    	select
			
			    	<e:if condition="${param.flg eq '1'}">
				      a.latn_id region_id,
				    	a.latn_name region_name,
			    	</e:if>
			    	<e:if condition="${param.flg eq '2'}">
			    		a.latn_id region_id,
			    		a.latn_name region_name,
			    		' ' bureau_no,
			    		' ' bureau_name,
			    	</e:if>
			    	<e:if condition="${param.flg eq '3'}">
			    		a.latn_id region_id,
			    		a.latn_name region_name,
			    		bureau_no,
			    		bureau_name,
			    		' ' branch_no,
			    		' ' branch_name,
			    	</e:if>
			    	${sql_cols},
			    	'0' order_num
			    	from ${channel_user}.TB_QDSP_STAT_VIEW_M a
			    	where a.acct_month ='${param.acct_month}'
			    	and a.flag = '${param.flg - 1}'
			    	<e:if condition="${param.flg eq '2'}">
			    		and a.flag = '${param.flg - 1}'
			    		and latn_id = '${param.city_id}'
			    	</e:if>
			    	<e:if condition="${param.flg eq '3'}">
			    		and a.flag = '${param.flg - 1}'
			    		and bureau_no = '${param.bureau_no}'
			    	</e:if>
			    	<e:description>
			    	<e:if condition="${!empty param.channel_type}">
			    		and a.entity_channel_type = '${param.channel_type}'
			    	</e:if>
			    	</e:description>
			
			    	union all
			
			      select
			      <e:if condition="${param.flg eq '1'}">
			      	a.latn_id region_id,
			      	a.latn_name region_name,
			      </e:if>
			      <e:if condition="${param.flg eq '2'}">
			      	a.latn_id||'' region_id,
			      	a.latn_name region_name,
			      	a.bureau_no bureau_no,
			      	a.bureau_name bureau_name,
			      </e:if>
			      <e:if condition="${param.flg eq '3'}">
			    		a.latn_id region_id,
			    		a.latn_name region_name,
			    		a.bureau_no,
			    		a.bureau_name,
			    		a.branch_no,
			    		a.branch_name,
			    	</e:if>
			      ${sql_cols},
			      b.order_num
			      from ${channel_user}.TB_QDSP_STAT_VIEW_M a
			      <e:if condition="${param.flg eq '1'}">
			      	,(select distinct latn_id,latn_name,latn_ord order_num from ${channel_user}.tb_gis_channel_org) b
			    		where a.acct_month ='${param.acct_month}'
			    		and a.latn_id = b.latn_id
			    	</e:if>
			    	<e:if condition="${param.flg eq '2'}">
			    		,(select distinct bureau_no,bureau_name,city_ord order_num from ${channel_user}.tb_gis_channel_org where latn_id = '${param.city_id}') b
			    		where a.acct_month ='${param.acct_month}'
			    		and a.bureau_no = b.bureau_no
			    	</e:if>
			    	<e:if condition="${param.flg eq '3'}">
			    		,(select distinct branch_no,branch_name,branch_ord order_num from ${channel_user}.tb_gis_channel_org where bureau_no = '${param.bureau_no}') b
			    		where a.acct_month ='${param.acct_month}'
			    		and a.branch_no = b.branch_no
			    		and bureau_no = '${param.bureau_no}'
			    	</e:if>
			    	<e:description>
			    	<e:if condition="${!empty param.channel_type}">
			    		and a.entity_channel_type = '${param.channel_type}'
			    	</e:if>
			    	</e:description>
			    	and a.flag = '${param.flg}'
		      ) t
	      )a
    	</e:else>
    	<e:if condition="${!empty param.page}">
	      	WHERE ROW_NUM BETWEEN ${param.page} * ${param.pageSize}+1 AND ${param.page+1} * ${param.pageSize}
	    </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
</e:switch>