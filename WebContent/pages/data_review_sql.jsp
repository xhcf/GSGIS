<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:description>审核更新数据</e:description>
	<e:case value="update_data">
		<e:update var="linenumber">
			begin
			<e:forEach items="${e:split(param.list, ',')}" var="item">
				update GIS_DATA.TB_GIS_ADDR_OTHER_ALL_imp set check_flag=1 where segm_id_2='${item}';
			</e:forEach>
			end;
		</e:update>${e:java2json(linenumber)}
	</e:case>


	<e:description>市级下对应筛选条件未审核录入信息</e:description>
	<e:case value="search_by_condition">
		<%--<e:q4l var="datalist">--%>
			<%--SELECT a.* FROM (--%>
			<%--SELECT t.*,ROWNUM rn FROM(--%>
			<%--select segm_id_2,stand_name_2,CONTACT_PERSON,CONTACT_NBR,--%>
			<%--kd_business,kd_xf,kd_dq_date,itv_business,itv_xf,itv_dq_date,--%>
			<%--note_txt,warn_date,COMMENTS, import_person, import_time--%>
			<%--from GIS_DATA.TB_GIS_ADDR_OTHER_ALL_imp--%>

			<%--)t WHERE ROWNUM <= ${param.page+1}*15 )a WHERE rn >${param.page}*15--%>
		<%--</e:q4l>${e:java2json(datalist.list)}--%>

		<e:q4l var="datalist">

			SELECT a.* FROM (
			SELECT t.*,ROWNUM rn FROM(
			select aa.segm_id_2,aa.stand_name_2,aa.CONTACT_PERSON,aa.CONTACT_NBR,
			aa.kd_business,aa.kd_xf,aa.kd_dq_date,aa.itv_business,aa.itv_xf,aa.itv_dq_date,
			aa.note_txt,aa.warn_date,aa.COMMENTS, aa.import_person, aa.import_time
			from GIS_DATA.TB_GIS_ADDR_OTHER_ALL_imp aa , SDE.TB_GIS_MAP_SEGM_LATN_MON bb
			WHERE aa.segm_id = bb.segm_id   and nvl(aa.check_flag,0)=0
			<e:if condition="${!empty param.city_id}">
				and bb.latn_id=${param.city_id}
			</e:if>
			and  <e:if var="test_tmp1" condition="${null== param.bureau_no||''.equals(param.bureau_no)}">
			     1=1
		         </e:if>
			     <e:else condition="${test_tmp1}">
				bb.bureau_no=${param.bureau_no}
			     </e:else>
			and  <e:if var="test_tmp2" condition="${null== param.branch_no||''.equals(param.branch_no)}">
			     1=1
		         </e:if>
			     <e:else condition="${test_tmp2}">
				 bb.branch_no=${param.branch_no}
			     </e:else>
			and <e:if var="test_tmp3" condition="${null== param.grid_id ||''.equals(param.grid_id)}">
			    1=1
		        </e:if>
			    <e:else condition="${test_tmp3}">
				bb.grid_id=${param.grid_id}
			    </e:else>
			)t WHERE ROWNUM <= ${param.page+1}*15 )a WHERE rn >${param.page}*15
		</e:q4l>${e:java2json(datalist.list)}
	</e:case>



	<%--<e:description>对应市级下县局列表  移到JSP页面中去了</e:description>--%>
	<%--<e:case value="info_bureau_list">--%>
	<%--<e:q4l var="datalist">--%>
		<%--select DISTINCT bureau_no,bureau_name FROM SDE.TB_GIS_MAP_SEGM_LATN_MON where latn_id=${param.city_id}--%>
	<%--</e:q4l>${e:java2json(datalist.list)}--%>
    <%--</e:case>--%>



	<e:description>对应县局下支局列表</e:description>
	<e:case value="info_branch_list">
		<e:q4l var="datalist">
			select DISTINCT branch_no,branch_name FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
			where  1=1
			<e:if condition="${!empty param.city_id}">
				and latn_id=${param.city_id}
			</e:if>
			and  <e:if var="test_tmp1" condition="${null== param.bureau_no||''.equals(param.bureau_no)}">
			        1=1
		         </e:if>
			     <e:else condition="${test_tmp1}">
					 bureau_no=${param.bureau_no}
			     </e:else>

		</e:q4l>${e:java2json(datalist.list)}
	</e:case>


	<e:description>对应支局下网格列表</e:description>
	<e:case value="info_grid_list">
		<e:q4l var="datalist">
			select DISTINCT grid_id,grid_name FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
			where 1=1
			<e:if condition="${!empty param.city_id}">
				and latn_id=${param.city_id}
			</e:if>
			and <e:if var="test_tmp1" condition="${null== param.bureau_no||''.equals(param.bureau_no)}">
			      1=1
		        </e:if>
			    <e:else condition="${test_tmp1}">
				  bureau_no=${param.bureau_no}
				</e:else>
			and <e:if var="test_tmp2" condition="${null== param.branch_no||''.equals(param.branch_no)}">
			     1=1
		        </e:if>
			    <e:else condition="${test_tmp2}">
					branch_no=${param.branch_no}
			    </e:else>
		</e:q4l>${e:java2json(datalist.list)}
	</e:case>


	<e:description>对应网格下小区列表  待用  级联只到网格</e:description>
	<e:case value="info_stand_list">
		<e:q4l var="datalist">
			select DISTINCT stand_name FROM SDE.TB_GIS_MAP_SEGM_LATN_MON
			where 1=1
			<e:if condition="${!empty param.city_id}">
			and latn_id=${param.city_id}
			</e:if>
			and
			<e:if var="test_tmp1" condition="${null== param.bureau_no||''.equals(param.bureau_no)}">
				1=1
			</e:if>
			<e:else condition="${test_tmp1}">
				bureau_no=${param.bureau_no}
			</e:else>
			and
			<e:if var="test_tmp2" condition="${null== param.branch_no||''.equals(param.branch_no)}">
			1=1
		    </e:if>
			<e:else condition="${test_tmp2}">
				branch_no=${param.branch_no}
			</e:else>
			and
			<e:if var="test_tmp3" condition="${null== param.grid_id ||''.equals(param.grid_id)}">
			1=1
		    </e:if>
			<e:else condition="${test_tmp3}">
				grid_id=${param.grid_id}
			</e:else>
		</e:q4l>${e:java2json(datalist.list)}
	</e:case>
</e:switch>