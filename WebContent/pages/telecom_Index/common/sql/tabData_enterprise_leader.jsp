<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:description>领导层右侧指标区小报表</e:description>
<e:set var="sql_part_tab_name1">
    <e:description>
        2018.9.11 表名更换 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 改为 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY
        2018.9.20 表名恢复 从 ${gis_user}.TB_HDZ_GSCH_MKT_ORDER_STAT_DAY 更换为 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW
        2019.3.27 表名 从 EDW.VW_GSCH_MKT_ORDER_STAT_DAY@GSEDW 变成 ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
    </e:description>
    ${gis_user}.VW_GSCH_MKT_ORDER_STAT_DAY
</e:set>
<e:set var="format1">
	'FM9999999990.0'
</e:set>
<e:switch value="${param.eaction}">
    <e:description>地图</e:description>
    <e:case value="index_map">
        <c:tablequery>
          select '地图' a,t.* from (

            SELECT
            latn_id region_id,
            latn_name region_name,
            fun_rate_fmt(b.u_yd_cnt,b.student_cnt) index_val0,
            nvl(b.school_cnt,0) index_val1,
            nvl(b.student_cnt,0) index_val2,
            nvl(b.u_yd_cnt,0) index_val3,
            '0' index_val4,
            latn_order ord
            FROM ${gis_user}.TB_GIS_SCHOOL_KPI_DAY b
            where flag = '${param.level-1}'
            and b.acct_day = '${param.acct_day}'
            <e:if condition="${param.level eq '2'}">
                and b.parent_id = '${param.city_id}'
            </e:if>

            UNION ALL

            SELECT
            latn_id region_id,
            latn_name region_name,
            fun_rate_fmt(b.u_yd_cnt,b.student_cnt) index_val0,
            nvl(b.school_cnt,0) index_val1,
            nvl(b.student_cnt,0) index_val2,
            nvl(b.u_yd_cnt,0) index_val3,
            '0' index_val4,
            latn_order ord
            from ${gis_user}.TB_GIS_SCHOOL_KPI_DAY b
            where b.flag = '${param.level}'
            and b.acct_day = '${param.acct_day}'
            <e:if condition="${param.level eq '2'}">
                and b.parent_id = '${param.city_id}'
            </e:if>
          ) t
          where 1=1
          <e:if var="haveQueryList"  condition="${!empty param.condition_str}">
            and (${param.condition_str})
          </e:if>

        </c:tablequery>
    </e:case>

    <e:case value="index_top_summary">
        <e:q4o var="dataObject">
            SELECT
            '上方指标' a,
            to_char(fun_div_fmt(b.u_yd_cnt,b.student_cnt,3)*100,${format1}) index_val0,
            nvl(b.school_cnt,0) index_val1,
            nvl(b.student_cnt,0) index_val2,
            nvl(b.u_yd_cnt,0) index_val3
            FROM ${gis_user}.TB_GIS_SCHOOL_KPI_DAY b
            where b.flag = '${param.level-1}'
            and b.acct_day = '${param.acct_day}'
            <e:if condition="${param.level eq '2'}">
                and b.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${param.level eq '3'}">
                and b.latn_id = '${param.bureau_no}'
            </e:if>
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

    <e:case value="index_echart_bar">
        <e:q4l var="dataList">
            SELECT
            '移动渗透率趋势' a,
            a.month_code,
            fun_div_fmt(b.u_yd_cnt,b.student_cnt)*100 val
            FROM ${gis_user}.TB_GIS_SCHOOL_KPI_MON b
            RIGHT JOIN (SELECT DISTINCT MONTH_CODE, MONTH_NAME
            FROM ${gis_user}.TB_DIM_TIME
            WHERE MONTH_CODE BETWEEN
            TO_CHAR(ADD_MONTHS(TO_DATE('${param.acct_month}', 'yyyymm'), -${param.begin_count}),
            'yyyymm') AND
            TO_CHAR(ADD_MONTHS(TO_DATE('${param.acct_month}', 'yyyymm'), 0),
            'yyyymm')) a
            ON A.MONTH_CODE = B.acct_mon
            and b.flag = '${param.level-1}'
            <e:if condition="${param.level eq '2'}">
                and b.latn_id = '${param.region_id}'
            </e:if>
            <e:if condition="${param.level eq '3'}">
                and b.latn_id = '${param.bureau_no}'
            </e:if>
            ORDER BY MONTH_CODE ASC
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>右侧区域分布表格</e:description>
    <e:case value="index_datagrid">
        <c:tablequery>
            select '区域分布' a,t.*,
            count(1) over() c_num,
            row_number() over(order by order_num) row_num
            from (select latn_id region_id,
            latn_name region_name,
            <e:if condition="${param.level eq '1' || param.level eq '2'}">
                nvl(school_cnt,0) index1,
            </e:if>
            <e:if condition="${param.level eq '3'}">
                nvl(student_cnt,0) index1,
            </e:if>
            nvl(u_yd_cnt,0) index2,
            fun_rate_fmt(u_yd_cnt, student_cnt) index3,
            latn_order order_num
            from ${gis_user}.tb_gis_school_kpi_day
            where acct_day = '${param.acct_day}'
            and flag = ${param.level -1}
            <e:if condition="${param.level eq '2'}">
                and latn_id = '${param.city_id}'
            </e:if>
            <e:if condition="${param.level eq '3'}">
                and latn_id = '${param.bureau_no}'
            </e:if>
            union all
            select latn_id region_id,
            latn_name region_name,
            <e:if condition="${param.level eq '1' || param.level eq '2'}">
                school_cnt index1,
            </e:if>
            <e:if condition="${param.level eq '3'}">
                student_cnt index1,
            </e:if>
            u_yd_cnt index2,
            fun_rate_fmt(u_yd_cnt, student_cnt) index3,
            latn_order order_num
            from ${gis_user}.tb_gis_school_kpi_day
            where acct_day = '${param.acct_day}'
            <e:if condition="${param.level eq '1' || param.level eq '2'}">
                and flag = ${param.level}
            </e:if>
            <e:if condition="${param.level eq '3'}">
                and flag = 5
            </e:if>
            <e:if condition="${param.level eq '2'}">
                and parent_id = '${param.city_id}'
            </e:if>
            <e:if condition="${param.level eq '3'}">
                and parent_id = '${param.bureau_no}'
            </e:if>
            ) t
        </c:tablequery>
    </e:case>

    <e:case value="big_data_list">
        <e:q4l var="dataList">
            SELECT * FROM (
            select c.*,ROWNUM rn from (
            SELECT
            a.business_id,
            a.business_name,
            a.position,
            a.latn_id,
            a.latn_name,
            a.bureau_no,
            a.bureau_name,
            a.business_attr1,
            c.dic_desc,
            nvl(b.build_cnt,0) ly_cnt,
            nvl(b.house_cnt,0) fj_cnt,
            nvl(b.bed_cnt,0) cw_cnt,
            nvl(b.student_cnt,0) zhu_hu_count,

            nvl(b.u_yd_cnt,0) yd_count,
            fun_rate_fmt(b.u_yd_cnt,b.student_cnt) yd_lv,

            nvl(b.c_yd_cnt  ,0) sj_cnt,
            nvl(b.c_cm_yd_cnt  ,0) sj_cmcc_cnt,
            nvl(b.c_cu_yd_cnt  ,0) sj_unicom_cnt,
            nvl(b.c_ot_yd_cnt ,0) sj_other_cnt,

            count(1) over() c_num

            FROM ${gis_user}.TB_GIS_BUSINESS_BASE A
            LEFT JOIN ${gis_user}.TB_GIS_SCHOOL_KPI_DAY B
            ON A.BUSINESS_ID = B.latn_id
            and b.flag = 5
            LEFT JOIN ${gis_user}.TB_GIS_DIC_BUSINESS_TYPE C
            ON A.business_attr1 = C.dic_code
            LEFT JOIN
            (
            SELECT DISTINCT
                latn_id,city_order_num,
                bureau_no,region_order_num
            FROM ${gis_user}.DB_CDE_GRID) D
            ON a.latn_id = d.latn_id
            and a.bureau_no = d.bureau_no

            WHERE A.BUSINESS_ATTR1 IN ('99999316', '99999317')
            AND A.VALID_FLAG = 1
            <e:if condition="${!empty param.city_id}">
                and A.latn_id = '${param.city_id}'
            </e:if>
            <e:if condition="${!empty param.bureau_id}">
                and A.bureau_no = '${param.bureau_id}'
            </e:if>
            <e:if condition="${!empty param.v_name}">
                and A.business_name LIKE '%${param.v_name}%'
            </e:if>
            ORDER BY d.city_order_num,d.region_order_num,BUSINESS_NAME
            )c
            where 1=1
            <e:if condition="${!empty param.page}">
                AND ROWNUM <= ${param.pageSize} * (${param.page}+1)
            </e:if>
            )
            <e:if condition="${!empty param.page}">
                WHERE rn > ${param.pageSize} * ${param.page}
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>右侧指标区 学校详表</e:description>
    <e:case value="getSchoolList">
        <c:tablequery>
            select a.*,rownum rn from (
            select
            t1.latn_name,
            t1.bureau_no,
            t1.bureau_name,
            t1.BUSINESS_ID,
            t1.BUSINESS_NAME,
            nvl(t3.student_cnt,0) students_cnt,
            nvl(t3.u_yd_cnt,0) yd_user_cnt,
            fun_rate_fmt(t3.u_yd_cnt,t3.student_cnt) market_percent,
            t1.position,
            t2.ord_num,
            COUNT(1) OVER() C_NUM
            FROM ${gis_user}.TB_GIS_BUSINESS_BASE t1 left join
            ${gis_user}.tb_gis_dic_business t2
            on t1.business_id = t2.business_id
            left join
            ${gis_user}.TB_GIS_SCHOOL_KPI_DAY t3
            on t1.business_id = t3.latn_id
            where 1=1
            <e:if condition="${param.region_type eq '2'}">
                and t1.latn_id = '${param.city_id}'
            </e:if>
            <e:if condition="${param.region_type eq '3'}">
                and t1.bureau_no = '${param.bureau_no}'
            </e:if>
            <e:if condition="${!empty param.v_name}">
                and t1.business_name LIKE '%${param.v_name}%'
            </e:if>
            and t3.flag = 5
            AND t1.valid_flag = 1
            AND t1.business_attr1 IN ('99999316','99999317')
            order by t2.ord_num)a
        </c:tablequery>
    </e:case>

</e:switch>