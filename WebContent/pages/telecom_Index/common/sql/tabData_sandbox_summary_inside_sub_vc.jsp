<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="sql_part">
    count(1) sum_cnt,
    count(case when ze_port_flg=1 then 1 else null end) obd0_cnt,
    count(case when fi_port_flg=1 then 1 else null end) obd1_cnt,
    <e:description>
        count(case when zero_port_flg=0 then 1 else null end) hobd_cnt
    </e:description>
    count(case when nvl(user_port_rate,0)>=0.6 then 1 else null end) hobd_cnt
</e:set>
<e:set var="sql_part_hobd">
    a.capacity>0 AND a.actualcapacity/a.capacity*100>60
</e:set>
<e:set var="sql_part_lobd">
    a.actualcapacity = 0 OR a.actualcapacity = 1
</e:set>
<e:set var="sql_part_where">
    and nvl(t.user_port_rate,0)>=0.6
</e:set>
<e:set var="sql_part_where1">
    and t.epon_type = 2
    and t.product_type = 1
</e:set>
<e:set var="sql_part_collect_cnt">
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 and O.SERIAL_NO in('1','4') and((O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL) or O.KD_BUSINESS = '0') then
    O.segm_id_2  END
    ) ON_COUNT,
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 and O.SERIAL_NO in('1','4') and (O.KD_BUSINESS IS NULL OR ( O.KD_BUSINESS<> '0' AND O.KD_DQ_DATE IS NULL)) then
    O.segm_id_2 END
    ) OFF_COUNT
</e:set>
<e:set var="sql_part_buss_cnt">
    COUNT(CASE
    WHEN O.Is_kd_dx > 0 THEN
    '1'
    END) D_COUNT,
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 AND O.KD_BUSINESS = '1' THEN
    '1'
    END) Y_COUNT,
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 AND O.KD_BUSINESS = '2' THEN
    '1'
    END) L_COUNT,
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 AND O.KD_BUSINESS = '3' THEN
    '1'
    END) G_COUNT,
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 AND O.KD_BUSINESS = '4' THEN
    '1'
    END) Q_COUNT,
    COUNT(CASE
    WHEN O.Is_kd_dx = 0 AND O.KD_BUSINESS = '0' THEN
    '1'
    END) N_COUNT
</e:set>
<e:set var="sql_part_no_collect">
    (O.Is_kd_dx = 0 and SERIAL_NO <> 2 and (O.KD_BUSINESS IS NULL OR ( O.KD_BUSINESS<> '0' AND O.KD_DQ_DATE IS NULL)))
</e:set>
<e:set var="sql_part_collected">
    (O.Is_kd_dx = 0 and SERIAL_NO <> 2 and((O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL) or O.KD_BUSINESS = '0'))
</e:set>
<e:set var="sql_part_tab">
    <e:description>2018.11.30 场景维护 更换表名 ${gis_user}.tb_dim_scene_type</e:description>
    <e:description>edw.tb_dim_send_market@gsedw</e:description>
    ${gis_user}.tb_dic_gis_market_type
</e:set>
<e:set var="sql_part_tab1">
    <e:description>EDW.TB_MKT_ORDER_LIST@GSEDW</e:description>
    ${gis_user}.VIEW_GIS_ORDER_LIST_TMP
</e:set>
<e:set var="sql_part_tab2">
    SELECT DISTINCT village_id,village_name FROM edw.vw_tb_cde_village@gsedw
    WHERE branch_no = (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid WHERE union_org_code='${param.substation}')
</e:set>
<e:set var="sql_part_tab3">
    SELECT DISTINCT brigade_id,brigade_name FROM edw.vw_tb_cde_village@gsedw
    WHERE branch_no = (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid WHERE union_org_code='${param.substation}')
</e:set>
<e:set var="sql_part_acct_day">
    SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate'
</e:set>
<e:set var="sql_part_acct_day1">
    SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss26' AND data_type = 'day' AND const_name = 'calendar.curdate'
</e:set>

<e:switch value="${param.eaction}">
<e:description>支局长部分 begin</e:description>
  <e:description>市场部分begin</e:description>

    <e:description>市场概览 统计 柱状图</e:description>
    <e:case value="summary_bar">
        <e:q4o var="now">
            select substr(to_char(sysdate,'yyyymmdd'),7) val from dual
        </e:q4o>
        <e:description>当前日期是每月1号时，取前6个月；否则，取当前日期减一</e:description>
        <e:set var="where">
            <e:if condition="${now.VAL eq '01'}" var="first_day">
                day_code = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -6)), 'yyyymmdd')
            </e:if>
            <e:else condition="${first_day}">
                day_code = TO_CHAR(SYSDATE - 1, 'yyyymmdd')
            </e:else>
        </e:set>

        <e:q4l var="dataList">
            SELECT SUBSTR(b.day_code,0,6) MONTH_CODE,
            DECODE(NVL(a.HOUSEHOLD_NUM, '0'),'0','0',TO_CHAR(ROUND(NVL(a.H_USE_CNT, 0) / a.HOUSEHOLD_NUM, 4) * 100,'FM990.00')) USE_RATE
            FROM
            (SELECT DISTINCT day_code FROM ${gis_user}.TB_DIM_TIME WHERE
            ${where} OR
            day_code = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -1)), 'yyyymmdd') OR
            day_code = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -2)), 'yyyymmdd') OR
            day_code = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -3)), 'yyyymmdd') OR
            day_code = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -4)), 'yyyymmdd') OR
            day_code = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -5)), 'yyyymmdd')
            ) b,
            (
            SELECT acct_day,HOUSEHOLD_NUM,H_USE_CNT FROM
            ${gis_user}.TB_GIS_COUNT_INFO_D
            WHERE
            FLG = 7
            AND LATN_ID = (select distinct branch_no from ${gis_user}.db_cde_grid where union_org_code = '${param.substation}')
            )
            a
            WHERE
            b.day_code = a.acct_day(+)
            ORDER BY MONTH_CODE
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>市场 网格</e:description>
    <e:case value="market_grid">
        <e:q4l var="dataList">
            select * from(
                SELECT
                a.latn_id GRID_ID,
                a.latn_name GRID_NAME,
                DECODE(NVL(a.HOUSEHOLD_NUM, '0'),'0',' ',TO_CHAR(ROUND(NVL(a.H_USE_CNT, 0) / a.HOUSEHOLD_NUM, 4) * 100,'FM990.00') || '%') MARKET_RATE,
                nvl(a.HOUSEHOLD_NUM,0) HOUSEHOLD_NUM,
                nvl(a.H_USE_CNT,0) H_USE_CNT,
                DECODE(NVL(a.CAPACITY, 0),0,'0.00%',TO_CHAR(ROUND(NVL(A.ACTUALCAPACITY, 0) / A.CAPACITY, 4) * 100,'FM990.00') || '%') PORT_LV,
                NVL(a.CAPACITY, 0) CAPACITY,
                NVL(a.ACTUALCAPACITY, 0) ACTUALCAPACITY,
                NVL(a.CAPACITY, 0) - NVL(a.ACTUALCAPACITY, 0) FREE_PORT,
                COUNT(1) OVER() C_NUM,
                row_number() over(ORDER BY length(latn_id),latn_id) ROW_NUM
                FROM ${gis_user}.TB_GIS_COUNT_INFO_D a
                WHERE a.flg = '6'
                and a.acct_day = (${sql_part_acct_day})
                AND a.latn_id in(
                    select grid_id from ${gis_user}.db_cde_grid where union_org_code = '${param.substation}'
                )
            )
            <e:if condition="${!empty param.page}">
                where ROW_NUM between ${param.page}*20+1 and (${param.page}+1)*20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>市场 行政村</e:description>
    <e:case value="market_vc">
        <e:q4l var="dataList">
            select * from(
                SELECT a.village_id,a.village_Name,
                DECODE(NVL(b.HOUSEHOLD_NUM, '0'),'0',' ',TO_CHAR(ROUND(NVL(b.H_USE_CNT, 0) / b.HOUSEHOLD_NUM, 4) * 100,'FM990.00') || '%') MARKET_RATE,
                NVL(b.H_USE_CNT,0) H_USE_CNT,
                nvl(b.brigade_id_cnt,0) brigade_id_cnt,
                NVL(b.household_num,0) household_num,
                NVL(b.population_num,0 ) population_num,
                DECODE(NVL(b.CAPACITY, 0),0,'0.00%',TO_CHAR(ROUND(NVL(b.ACTUALCAPACITY, 0) / b.CAPACITY, 4) * 100,'FM990.00') || '%') PORT_LV,
                NVL(b.ACTUALCAPACITY, 0) ACTUALCAPACITY,
                COUNT(1) OVER() C_NUM,
                row_number() over(ORDER BY village_name) ROW_NUM
                FROM
                (
                    ${sql_part_tab2}
                    <e:if condition="${!empty param.tab2_text}">
                        and village_name like '%${param.tab2_text}%'
                    </e:if>
                ) a,
                ${gis_user}.TB_GIS_COUNT_INFO_D b
                WHERE 1=1
                AND a.village_id = b.latn_id(+)
                AND b.flg = 5
                and b.acct_day = (${sql_part_acct_day})
            )
            <e:if condition="${!empty param.page}">
                where ROW_NUM between ${param.page}*20+1 and (${param.page}+1)*20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>市场 用户</e:description>
    <e:case value="market_user">
        <e:q4l var="dataList">
            select * from(
                SELECT
                t.SERV_NAME,
                t.ACC_NBR,
                C.STOP_TYPE_NAME,
                DECODE(t.USER_CONTACT_NBR,
                '0',
                ' ',
                t.USER_CONTACT_NBR) USER_CONTACT_NBR,
                t.EQP_NO,
                t.ADDRESS,
                t.PROD_INST_ID,
                t.BRIGADE_ID,
                COUNT(1) OVER() C_NUM,
                row_number() over(ORDER BY t.SERV_NAME) ROW_NUM
                FROM ${gis_user}.TB_GIS_USER_LIST_D T,
                ${gis_user}.TB_DIC_GIS_STOP_TYPE C,
                (
                    ${sql_part_tab2}
                )a
                WHERE T.STOP_TYPE = C.STOP_TYPE
                ${sql_part_where1}
                AND t.village_id = a.village_id
                <e:if condition="${!empty param.tab3_text}">
                    AND (t.user_contact_nbr like '%${param.tab3_text}%' or t.serv_name like '%${param.tab3_text}%' or t.acc_nbr like '%${param.tab3_text}%')
                </e:if>
                )
            <e:if condition="${!empty param.page}">
                where ROW_NUM between ${param.page}*20+1 and (${param.page}+1)*20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>资源 网格</e:description>
    <e:case value="resource_grid">
        <e:q4l var="dataList">
            select * from(
                SELECT
                nvl(t.latn_name,' ') org_name,
                nvl(t.eqp_cnt,0) all_obd_cnt,
                nvl(t.zero_use_cnt,0) lobd_cnt,
                nvl(t.high_use_cnt,0) hobd_cnt,
                to_char(round(decode(nvl(t.CAPACITY,0),0,0,t.ACTUALCAPACITY/t.CAPACITY),4)*100,'FM9999999990.00')||'%' port_lv,
                nvl(t.capacity,0) port_cnt,
                nvl(t.actualcapacity,0) use_port_cnt,
                COUNT(1) OVER() c_num,
                row_number() over(ORDER BY t.latn_name) ROW_NUM
                FROM ${gis_user}.TB_GIS_COUNT_INFO_D t
                WHERE t.latn_id in (select distinct grid_id from ${gis_user}.db_cde_grid where union_org_code = '${param.substation}')
                and t.flg = '6'
                and t.acct_day = (${sql_part_acct_day})
            )
            <e:if condition="${!empty param.page}">
                where ROW_NUM between ${param.page}*20+1 and (${param.page}+1)*20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:description>资源 行政村</e:description>
    <e:case value="resource_vc">
        <e:q4l var="dataList">
            select * from(
                SELECT
                nvl(t.latn_name,' ') org_name,
                nvl(t.eqp_cnt,0) all_obd_cnt,
                nvl(t.zero_use_cnt,0) lobd_cnt,
                nvl(t.high_use_cnt,0) hobd_cnt,
                to_char(round(decode(nvl(t.CAPACITY,0),0,0,t.ACTUALCAPACITY/t.CAPACITY),4)*100,'FM9999999990.00')||'%' port_lv,
                nvl(t.capacity,0) port_cnt,
                nvl(t.actualcapacity,0) use_port_cnt,
                COUNT(1) OVER() c_num,
                row_number() over(ORDER BY t.latn_name) ROW_NUM
                FROM ${gis_user}.TB_GIS_COUNT_INFO_D t,
                (
                ${sql_part_tab2}
                )a
                WHERE t.latn_id = a.village_id
                and t.flg = '5'
                and t.acct_day = (${sql_part_acct_day})
            )
            <e:if condition="${!empty param.page}">
                where ROW_NUM between ${param.page}*20+1 and (${param.page}+1)*20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:description>资源 社队</e:description>
    <e:case value="resource_she_dui">
        <e:q4l var="dataList">
            SELECT *
            FROM (SELECT
            a.BRIGADE_ID,
            a.BRIGADE_NAME org_name,
            T.ALL_OBD_CNT,
            c.hobd HOBD_CNT,
            c.lobd LOBD_CNT,
            t.port_lv,
            t.port_cnt,
            t.use_port_cnt,
            COUNT(1) OVER() C_NUM,
            ROW_NUMBER() OVER(ORDER BY a.brigade_name) ROW_NUM
            FROM (SELECT T.BRIGADE_ID,
            COUNT(EQP_NO) ALL_OBD_CNT,
            to_char(round(decode(sum(nvl(t.CAPACITY,0)) ,0,0,SUM(NVL(t.ACTUALCAPACITY,0))/SUM(NVL(t.CAPACITY,0))),4)*100,'FM9999999990.00')||'%' port_lv,
            SUM(NVL(T.CAPACITY, 0)) PORT_CNT,
            SUM(NVL(T.ACTUALCAPACITY, 0)) USE_PORT_CNT,
            COUNT(1) OVER() c_num,
            row_number() over(ORDER BY t.BRIGADE_ID) ROW_NUM
            FROM ${gis_user}.TB_GIS_COUNTRY_ODB_D T
            WHERE ACCT_DAY =
            (${sql_part_acct_day1})
            GROUP BY T.BRIGADE_ID) T,
            (${sql_part_tab3}
            <e:if condition="${!empty param.tab2_text}">
                AND BRIGADE_NAME LIKE '%${param.tab2_text}%'
            </e:if>
            ) A,

            (
            SELECT
                a.brigade_id,
                sum(CASE WHEN ${sql_part_hobd} THEN 1 ELSE 0 END) hobd,
                sum(CASE WHEN ${sql_part_lobd} THEN 1 ELSE 0 END) lobd
                from ${gis_user}.TB_GIS_COUNTRY_ODB_D a,
                (${sql_part_tab3}
                <e:if condition="${!empty param.tab1_text}">
                    AND BRIGADE_NAME LIKE '%${param.tab1_text}%'
                </e:if>
                )b
                WHERE a.brigade_id = b.brigade_id
                GROUP BY a.brigade_id
            )C

            WHERE T.BRIGADE_ID = A.BRIGADE_ID
            AND T.BRIGADE_ID = c.brigade_id
            )
            <e:if condition="${!empty param.page}">
                WHERE ROW_NUM BETWEEN ${param.page} * 20 + 1 AND (${param.page} + 1) * 20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:description>资源 OBD</e:description>
    <e:case value="resource_obd">
        <e:q4l var="dataList">
            SELECT *
            FROM (
            SELECT
            DISTINCT
            TT.EQP_NO,
            TT.ADDRESS,
            TT.CAPACITY,
            TT.ACTUALCAPACITY,
            TT.RATE,
            COUNT(1) OVER() c_num,
            row_number() over(ORDER BY TT.EQP_NO) ROW_NUM
            FROM ${gis_user}.TB_GIS_COUNTRY_ODB_D TT, EDW.VW_TB_CDE_VILLAGE@GSEDW B
            WHERE TT.VILLAGE_ID = B.VILLAGE_ID
            AND tt.brigade_id = b.brigade_id
            AND B.BRANCH_NO =
            (select distinct branch_no from ${gis_user}.db_cde_grid where union_org_code = '${param.substation}')
            AND tt.ACCT_DAY =
            (SELECT CONST_VALUE
            FROM SYS_CONST_TABLE
            WHERE CONST_TYPE = 'var.dss26'
            AND DATA_TYPE = 'day'
            AND CONST_NAME = 'calendar.curdate')
            <e:if condition="${!empty param.tab3_select}">
                and b.village_id = '${param.tab3_select}'
            </e:if>
            <e:if condition="${!empty param.tab3_text}">
                and (tt.eqp_no like '%${param.tab3_text}%' or tt.address like '%${param.tab3_text}%')
            </e:if>
            GROUP BY eqp_no,ADDRESS,CAPACITY,ACTUALCAPACITY,RATE
            ORDER BY eqp_no)
            <e:if condition="${!empty param.page}">
                WHERE ROW_NUM BETWEEN ${param.page} * 20 + 1 AND (${param.page} + 1) * 20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>存量 网格</e:description>
    <e:case value="stock_grid">
        <e:q4l var="dataList">
            select * from(
            SELECT
            A.GRID_NAME org_name,
            DECODE(NVL(B.BY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(BY_CNT, 0) / B.BY_ALL_CNT, 4) * 100, 'FM990.00') || '%') BY_RATE,
            DECODE(NVL(B.ACTIVE_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / B.ACTIVE_ALL_CNT, 4) * 100, 'FM990.00') || '%') ACTIVE_RATE,
            DECODE(NVL(B.XY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(XY_CNT, 0) / B.XY_ALL_CNT, 4) * 100, 'FM990.00') || '%') XY_RATE,
            DECODE(NVL(B.LW_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(LW_CNT, 0) / B.LW_ALL_CNT, 4) * 100, 'FM990.00') || '%') LW_RATE,
            COUNT(1) OVER() c_num,
            row_number() over(ORDER BY a.GRID_NAME) ROW_NUM
            FROM ${gis_user}.DB_CDE_GRID A
            LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY B
            ON A.GRID_ID = B.LATN_ID
            WHERE A.UNION_ORG_CODE = '${param.substation}'
            AND A.GRID_STATUS = '1'
            AND A.GRID_UNION_ORG_CODE <> '-1')
            <e:if condition="${!empty param.page}">
                WHERE ROW_NUM BETWEEN ${param.page} * 20 + 1 AND (${param.page} + 1) * 20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>获取行政村所在网格，下钻网格用</e:description>
    <e:case value="getInsideOrgsByVcid">
        <e:q4o var="dataObject">
            select
            c.UNION_ORG_CODE,
            c.BRANCH_NAME,
            c.ZOOM,
            c.GRID_ID,
            c.GRID_NAME,
            s.STATION_ID
            from
            edw.vw_tb_cde_village@gsedw a,
            ${gis_user}.DB_CDE_GRID C,
            ${gis_user}.SPC_BRANCH_STATION S
            where C.GRID_UNION_ORG_CODE = S.STATION_NO
            and a.grid_id = c.grid_id
            and a.village_id = '${param.v_id}'
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

</e:switch>