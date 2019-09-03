<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_part_tab1">
    <e:description>
        ${gis_user}.VIEW_GIS_ORDER_LIST_MON
    </e:description>
    ${gis_user}.view_gis_order_b1_mon
</e:set>
<e:set var="sql_part_where1">
    and a.epon_type = 2
    and a.product_type = 1
</e:set>
<e:switch value="${param.eaction}">
    <e:description>20181215</e:description>
    <e:case value="getVillageBaseInfo">
        <e:q4l var="dataList">
            select t.latn_id,t.latn_name,
            nvl(t.household_num,0) household_num,
            nvl(t.population_num,0) population_num,
            nvl(t.h_use_cnt,0) h_use_cnt,
            nvl(t.d_use_cnt,0) d_use_cnt,
            nvl(t.r_use_cnt,0) r_use_cnt,
            nvl(t.brigade_id_cnt,0) brigade_id_cnt,
            nvl(t.capacity,0) capacity,
            nvl(t.actualcapacity,0) actualcapacity,
            nvl(t.high_use_cnt,0) high_use_cnt,
            nvl(t.zero_use_cnt,0) zero_use_cnt,
            nvl(t.zy_cnt,0) zy_cnt,
            nvl(t.y_collect_cnt,0) y_collect_cnt,
            nvl(t.collect_cnt,0) collect_cnt,
            case WHEN NVL(y_collect_cnt+collect_cnt,0) = 0 THEN '0.00%' ELSE to_char(ROUND(NVL(collect_cnt,0)/NVL(y_collect_cnt+collect_cnt,0),2)*100,'FM9999999990.00')||'%' end collect_lv,
            nvl(t.yw_collect_cnt,0) yw_collect_cnt,
            nvl(t.zx_collect_cnt,0) zx_collect_cnt,
            nvl(t.chai_cnt,0) chai_cnt,
            nvl(t.stop_cnt,0) stop_cnt,
            nvl(t.chenm_cnt,0) chenm_cnt,
            nvl(t.eqp_cnt,0) eqp_cnt,
            to_char(round(nvl(comp_charge,0)/10000,2),'FM9999999990.00')||'万' charge,
            to_char(round(decode(nvl(t.h_use_cnt,0),0,0,t.comp_charge/t.h_use_cnt),2),'FM9999999990.00') arpu,
            to_char(round(decode(nvl(t.d_use_cnt,0),0,0,t.d_comp_charge/t.d_use_cnt),2),'FM9999999990.00') d_arpu,
            to_char(round(decode(nvl(t.r_use_cnt,0),0,0,t.r_comp_charge/t.r_use_cnt),2),'FM9999999990.00') r_arpu,
            to_char(round(decode(nvl(t.household_num,0),0,0,t.h_use_cnt/t.household_num),4)*100,'FM9999999990.00')||'%' markt_lv,
            to_char(round(decode(nvl(t.capacity,0),0,0,t.actualcapacity/t.capacity),4)*100,'FM9999999990.00')||'%' port_lv,
            to_char(round(decode(nvl(t.brigade_id_cnt,0),0,0,t.zy_cnt/t.brigade_id_cnt),4)*100,'FM9999999990.00')||'%' fg_lv
            from ${gis_user}.TB_GIS_COUNT_INFO_D t
            where t.latn_id='${param.village_id}'
            and t.acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="villageCellPath">
        <e:q4l var="dataList">
            select * from (
            select village_id,village_name,city_name||'>'||county_name||'>'||town_name xz_frm,latn_name||'>'||bureau_name||'>'||branch_name||'>'||grid_name hx_frm
            from edw.vw_tb_cde_village@gsedw where village_id='${param.village_id}'
            group by city_name,county_name,town_name,latn_name,bureau_name,branch_name,grid_name,village_id,village_name)
            where rownum<2
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="villageCell_yx_summary">
        <e:q4l var="dataList">
            select t.scene_count,t.yx_count,t.zx_count,t.suc_count,t.order_count,
            to_char(round(decode(t.order_count,0,0,t.zx_count/t.order_count),4)*100,'FM9999999990.00')||'%' zx_lv,
            to_char(round(decode(t.yx_count,0,0,t.suc_count/t.yx_count),4)*100,'FM9999999990.00')||'%' suc_lv
            from(
            select count(distinct a.scene_id) scene_count,count(distinct a.order_id) yx_count,count(distinct a.order_id) order_count,
            count(decode(a.exec_stat,0,null,order_id)) zx_count,count(decode(a.SUCC_FLAG,1,order_id,null)) suc_count

            from
            <e:description>
            ${gis_user}.VIEW_GIS_ORDER_LIST_MON a,
            ${gis_user}.TB_GIS_USER_LIST_D b,
            </e:description>
            ${sql_part_tab1} a,
            ${gis_user}.tb_mkt_info c

            where
            <e:description>
            a.prod_inst_id = b.prod_inst_id
            and b.prod_inst_id=c.prod_inst_id
            and b.village_id='${param.village_id}'
            </e:description>

            a.village_id='${param.village_id}'
            and a.prod_inst_id=c.prod_inst_id
            ${sql_part_where1}
            ) t
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="villageCell_yx_list">
        <e:q4l var="dataList">
            select * from (
            select t.*,rownum rn from (
            SELECT * FROM (
            SELECT a.SERV_NAME,
            a.ACC_NBR,
            decode(A.CONTACT_TEL,'0',' ',A.CONTACT_TEL) USER_CONTACT_NBR,
            A.scene_id MKT_CAMPAIGN_ID,
            A.mkt_content MKT_CAMPAIGN_NAME,
            A.mkt_reason CONTACT_SCRIPT,
            C.ADDRESS_DESC,
            a.PROD_INST_ID,
            a.brigade_id,
            COUNT(1) OVER() c_num
            FROM
            <e:description>
            ${gis_user}.VIEW_GIS_ORDER_LIST_MON A,
            ${gis_user}.TB_GIS_USER_LIST_D B,
            </e:description>
            ${sql_part_tab1} a,
            ${gis_user}.TB_MKT_INFO C
            WHERE
            A.PROD_INST_ID = C.PROD_INST_ID
            ${sql_part_where1}
            AND A.VILLAGE_ID = '${param.village_id}'
            <e:if condition="${!empty param.build_id && param.build_id ne '-1'}">
                AND A.brigade_id = '${param.build_id}'
            </e:if>
            <e:if condition="${!empty param.scene_id && param.scene_id ne '-1'}">
                AND a.scene_id = '${param.scene_id}'
            </e:if>
            )
            where rownum <= ${(param.page + 1) * 15}) t
            )t1
            where rn > ${param.page * 15}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="villageCell_shedui_list">
        <e:q4l var="dataList">
            SELECT *
            FROM (SELECT T.*, ROWNUM RN
            FROM (SELECT T.BRIGADE_ID,
            T.VILLAGE_ID,
            nvl(B.BRIGADE_NAME,'其它') BRIGADE_NAME,
            nvl(T.POPULATION_NUM,0) POPULATION_NUM,
            nvl(T.ZHU_HU_COUNT,0) ZHU_HU_COUNT,
            nvl(T.H_USE_CNT,0) H_USE_CNT,
            T.GKST_LV,
            COUNT(1) OVER() C_NUM
            FROM (SELECT A.BRIGADE_ID,
            A.VILLAGE_ID,
            A.POPULATION_NUM,
            A.HOUSEHOLD_NUM ZHU_HU_COUNT,
            A.H_USE_CNT,
            CASE
            WHEN NVL(HOUSEHOLD_NUM, 0) = 0 THEN
            '0.00%'
            ELSE
            TO_CHAR(ROUND(NVL(H_USE_CNT, 0) /
            HOUSEHOLD_NUM,
            4) * 100,
            'FM9999999990.00') || '%'
            END GKST_LV
            FROM ${gis_user}.TB_GIS_BRIGADE_DAY A
            WHERE VILLAGE_ID = '${param.village_id}'
            <e:if condition="${!empty param.build_id && param.build_id ne '-1'}">
                AND brigade_id = '${param.build_id}'
            </e:if>
            ) T,
            (SELECT BRIGADE_ID, BRIGADE_NAME
            FROM edw.vw_tb_cde_village@gsedw
            WHERE VILLAGE_ID = '${param.village_id}'
            GROUP BY BRIGADE_ID, BRIGADE_NAME
            ) B
            WHERE T.BRIGADE_ID = B.BRIGADE_ID
            order by BRIGADE_ID,length(BRIGADE_NAME) asc,BRIGADE_NAME asc)
            T
            WHERE ROWNUM <= ${(param.page + 1) * 15}
            )
            WHERE RN > ${param.page * 15}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getSheDuiSummaryByVillage">
        <e:q4o var="dataObject">
            SELECT nvl(SUM(household_num),0) zhu_hu_num,nvl(SUM(h_use_cnt),0) kd_num FROM ${gis_user}.TB_GIS_BRIGADE_DAY
            WHERE village_id = '${param.village_id}'

            <e:if condition="${!empty param.build_id && param.build_id ne '-1'}">
                AND brigade_id = '${param.build_id}'
            </e:if>
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

    <e:case value="getSheDuiCnt">
        <e:q4o var="dataObject">
            select BRIGADE_ID_CNT from ${gis_user}.TB_GIS_COUNT_INFO_D
            where latn_id = '${param.village_id}'
            and acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

    <e:case value="getVillageSelectOption">
        <e:q4l var="dataList">
            SELECT VILLAGE_ID, nvl(VILLAGE_NAME,'其它') VILLAGE_NAME
            FROM edw.vw_tb_cde_village@gsedw
            WHERE GRID_ID = '${param.grid_id_short}'
            GROUP BY VILLAGE_ID, VILLAGE_NAME
            ORDER BY VILLAGE_ID,length(VILLAGE_NAME) asc,VILLAGE_NAME asc
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getSheDuiSelectOption">
        <e:q4l var="dataList">
            SELECT BRIGADE_ID, nvl(BRIGADE_NAME,'其它') BRIGADE_NAME
            FROM edw.vw_tb_cde_village@gsedw
            WHERE VILLAGE_ID = '${param.village_id}'
            GROUP BY BRIGADE_ID, BRIGADE_NAME
            ORDER BY BRIGADE_ID,length(BRIGADE_NAME) asc,BRIGADE_NAME asc
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getSceneSelectOption">
        <e:q4l var="dataList">
            SELECT mkt_campaign_id,mkt_campaign_name FROM ${gis_user}.tb_dic_mkt_type
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
    <e:case value="getSceneSelectOptionInDB">
        <e:q4l var="dataList">
            SELECT
            distinct A.scene_id MKT_CAMPAIGN_ID,
            A.mkt_content MKT_CAMPAIGN_NAME
            FROM
            <e:description>
            ${gis_user}.VIEW_GIS_ORDER_LIST_MON A,
            ${gis_user}.TB_GIS_USER_LIST_D B
            </e:description>
            ${sql_part_tab1} a
            WHERE
            a.VILLAGE_ID = '${param.village_id}'
            ${sql_part_where1}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getUserSummary">
        <e:q4o var="dataObject">
            select nvl(t.household_num,0) household_num,nvl(t.population_num,0) population_num,nvl(t.h_use_cnt,0) h_use_cnt
            from ${gis_user}.TB_GIS_COUNT_INFO_D t
            where latn_id='${param.village_id}'
            and t.acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

    <e:case value="getUserList">
        <e:q4l var="dataList">
            select * from (
            select t.*,rownum rn from (
            select * from (
            SELECT
            serv_name,
            acc_nbr,
            to_char(finish_date,'yyyy-mm-dd') finish_date,
            CASE
            WHEN T.INET_MONTH IS NULL THEN
            '--'
            WHEN T.INET_MONTH / 12 = 1 THEN
            '1年'
            WHEN T.INET_MONTH / 12 > 1 THEN
            FLOOR(T.INET_MONTH / 12) || '年'
            END || CASE
            WHEN MOD(T.INET_MONTH, 12) > 0 THEN
            MOD(T.INET_MONTH, 12) || '个月'
            END INET_MONTH,
            c.stop_type_name,
            eqp_no,
            address,
            decode(user_contact_nbr,'0',' ',user_contact_nbr) user_contact_nbr,
            prod_inst_id,
            brigade_id,
            COUNT(1) OVER() c_num
            FROM ${gis_user}.TB_GIS_USER_LIST_D t,
            ${gis_user}.TB_DIC_GIS_STOP_TYPE c
            WHERE
            t.stop_type = c.stop_type
            and t.epon_type = 2
            AND t.village_id = '${param.village_id}'
            <e:if condition="${!empty param.res_id && param.res_id ne '-1'}">
                AND t.brigade_id = '${param.res_id}'
            </e:if>
            <e:if condition="${!empty param.query_text}">
                AND (t.user_contact_nbr like '%${param.query_text}%' or t.serv_name like '%${param.query_text}%' or acc_nbr like '%${param.query_text}%')
            </e:if>
            )
            where rownum <= ${(param.page + 1) * 15}) t
            )t1
            where rn > ${param.page * 15}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getOBDList">
        <e:q4l var="dataList">
            select * from (
            select t.*,rownum rn from (
            SELECT * FROM (
            SELECT nvl(eqp_no,' ') eqp_no,nvl(address,' ') address,nvl(capacity,0) capacity,nvl(t.actualcapacity,0) actualcapacity,
            to_char(round(decode(nvl(CAPACITY,0),0,0,ACTUALCAPACITY/CAPACITY),4)*100,'FM9999999990.00')||'%' rate,
            COUNT(1) OVER() c_num
            FROM ${gis_user}.TB_GIS_COUNTRY_ODB_D t
            WHERE t.village_id = '${param.village_id}'
            <e:if condition="${!empty param.res_id && param.res_id ne '-1'}">
                AND t.brigade_id = '${param.res_id}'
            </e:if>
            <e:if condition="${!empty param.obd_id && param.obd_id ne '-1'}">
                AND (t.eqp_no like '%${param.obd_id}%' or address like '%${param.obd_id}%')
            </e:if>
            )
            where rownum <= ${(param.page + 1) * 15}) t
            )t1
            where rn > ${param.page * 15}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getOBDSummary">
        <e:q4l var="dataList">
            select nvl(t.eqp_cnt,0) eqp_cnt,nvl(t.capacity,0) cap_cnt,nvl(t.actualcapacity,0) act_cap_cnt,to_char(round(decode(nvl(t.capacity,0),0,0,t.actualcapacity/t.capacity),4)*100,'FM9999999990.00')||'%' act_lv
            from ${gis_user}.TB_GIS_COUNT_INFO_D t
            WHERE latn_id = '${param.village_id}'
            and t.acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
            <%--<e:if condition="${!empty param.res_id && param.res_id ne '-1'}">
                AND brigade_id = '${param.res_id}'
            </e:if>--%>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getCollectList">
        <e:q4l var="dataList">
            select '行政村收集列表' a, t1.* from (
            select t.*,rownum rn from (
            SELECT * FROM (
            select
            nvl(t.cust_name,' ')cust_name,
            nvl(t.user_contact_nbr,' ') user_contact_nbr,
            nvl(t.PLATE_NUMBER,' ') PLATE_NUMBER,
            decode(CARRIER_TYPE,0,'占线入户','异网收集') collect_type,
            decode(CARRIER_TYPE,0,'电信',1,'移动',2,'联通',3,'广电','4','其它') bussness_type,
            nvl(to_char(EXP_DATE,'yyyy-mm-dd'),' ') EXP_DATE,
            nvl(TARIFF_DESC,' ') TARIFF_DESC,
            <e:description>非占线入户，甩线日期一律为空</e:description>
            decode(CARRIER_TYPE,0,nvl(TO_CHAR(HOLD_INSTALL_DATE, 'yyyy-mm-dd'),' '),' ') HOLD_INSTALL_DATE,
            t.address_id,
            T.brigade_id,
            t.village_id,
            COUNT(1) OVER() c_Num
            from EDWWEB.TB_COUNTRY_GATHER@GSEDW t where
            <e:if condition="${empty param.village_id}" var="empty_village_id">
                t.village_id in (
                    SELECT DISTINCT village_id FROM edw.vw_tb_cde_village@gsedw WHERE GRID_ID = '${param.grid_id_short}'
                )
            </e:if>
            <e:else condition="${empty_village_id}">
                t.village_id='${param.village_id}'
            </e:else>
            <e:if condition="${!empty param.res_id && param.res_id ne '-1'}">
                and brigade_id = '${param.res_id}'
            </e:if>
            <e:if condition="${!empty param.collect_bselect1 && param.collect_bselect1 ne '-1'}">
                and carrier_type = '${param.collect_bselect1}'
            </e:if>
            )
            where rownum <= ${(param.page + 1) * 15}) t
            )t1
            where rn > ${param.page * 15}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getCollectSummary">
        <e:q4l var="dataList">
            select c.latn_id,nvl(c.HOUSEHOLD_NUM,0) HOUSEHOLD_NUM,nvl(c.HOUSEHOLD_NUM-c.h_use_cnt,0) y_collect,nvl(count(a.village_id),0)collect_count,
            to_char(round(decode(c.HOUSEHOLD_NUM,0,0,count(village_id)/c.HOUSEHOLD_NUM),4)*100,'FM9999999990.00')||'%' collect_lv
            from EDWWEB.TB_COUNTRY_GATHER@GSEDW a, ${gis_user}.TB_GIS_COUNT_INFO_D c
            where
            a.village_id(+)=c.latn_id and c.flg=5 and c.latn_id='${param.village_id}'
            and c.acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
            group by c.latn_id,c.HOUSEHOLD_NUM,c.h_use_cnt
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getCollectBusSummary">
        <e:q4l var="dataList">
            select
            '类型数据' a,
            count(brigade_id) COL_ALL,
            count(decode(CARRIER_TYPE,0,brigade_id)) COL_ZX,
            count(decode(CARRIER_TYPE,1,brigade_id)) COL_YD,
            count(decode(CARRIER_TYPE,2,brigade_id)) COL_LT,
            count(decode(CARRIER_TYPE,3,brigade_id)) COL_GD,
            count(decode(CARRIER_TYPE,4,brigade_id)) COL_QT
            from EDWWEB.TB_COUNTRY_GATHER@GSEDW
            where 1=1
            <e:if condition="${empty param.village_id}" var="empty_village_id">
                and village_id in (
                SELECT DISTINCT village_id FROM edw.vw_tb_cde_village@gsedw WHERE GRID_ID = '${param.grid_id_short}'
                )
            </e:if>
            <e:else condition="${empty_village_id}">
                and village_id='${param.village_id}'
            </e:else>
            <e:if condition="${!empty param.res_id && param.res_id ne '-1'}">
                AND brigade_id = '${param.res_id}'
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getLostUserSummay">
        <e:q4l var="dataList">
            select
            nvl(t.h_use_cnt,0) h_use_cnt,
            nvl(t.chai_cnt,0) chai_cnt,
            nvl(t.stop_cnt,0) stop_cnt,
            nvl(t.chenm_cnt,0) chenm_cnt
            from ${gis_user}.TB_GIS_COUNT_INFO_D t
            where latn_id='${param.village_id}'
            and t.acct_day = (SELECT const_value FROM Sys_Const_Table WHERE const_type = 'var.dss27' AND data_type = 'day' AND const_name = 'calendar.curdate')
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getLostUserList">
        <e:q4l var="dataList">
            select * from (
            select t.*,rownum rn from (
            SELECT * FROM (
            SELECT
            a.serv_name ,
            a.acc_nbr ,
            decode(a.user_contact_nbr,'0',' ',a.user_contact_nbr) user_contact_nbr,
            a.eqp_no ,
            a.address ,
            case when b.stop_type in (2,3) then ' ' else to_char(a.remove_date ,'yyyy-mm-dd') end remove_date,
            case when b.stop_type in (2,3) then ' ' else (
            ${gis_user}.DATE_DUR(remove_date,SYSDATE)) end REMOVE_DUR,
            b.stop_type_name,
            a.brigade_id,
            a.prod_Inst_id,
            COUNT(1) OVER() c_num
            FROM ${gis_user}.TB_GIS_COUNTRY1_LS_D a,
            PMART.T_DIM_LOST_TYPE@GSEDW b
            WHERE village_id = '${param.village_id}'
            <e:if condition="${!empty param.res_id && param.res_id ne '-1'}">
                AND a.brigade_id = '${param.res_id}'
            </e:if>
            <e:if condition="${!empty param.yhzt_type && param.yhzt_type ne '-1' && param.yhzt_type ne '8' && param.yhzt_type ne '3'}">
                AND b.stop_type = '${param.yhzt_type}'
            </e:if>
            <e:if condition="${!empty param.yhzt_type}">
                <e:description>选择 “沉默”
                    b.stop_type='2'	表示 沉默用户 三个月内
                    b.stop_type='3'   沉默用户 三个月以上
                </e:description>
                <e:if condition="${param.yhzt_type eq '3'}" var="cm_type">
                    <e:description>选择 “三个月内”</e:description>
                    <e:if condition="${param.stop_dura_type eq '1'}" var="cm_in_3">
                        AND b.stop_type='2'
                    </e:if>
                    <e:description>选择 “三个月以上”</e:description>
                    <e:else condition="${cm_in_3}">
                        <e:if condition="${param.stop_dura_type eq '2'}" var="cm_more_3">
                            AND b.stop_type='3'
                        </e:if>
                        <e:description>选择 “全部”</e:description>
                        <e:else condition="${cm_in_3}">
                            AND b.stop_type in ('2','3')
                        </e:else>
                    </e:else>
                </e:if>
                <e:description>选择 其他类型</e:description>
                <e:else condition="${cm_type}">
                    <e:if condition="${param.yhzt_type eq '8'}" var="tj_flag">
                        AND b.stop_type in ('8','9')
                    </e:if>
                    <e:else condition="${tj_flag}">
                        AND b.stop_type='${param.yhzt_type}'
                    </e:else>
                </e:else>
            </e:if>
            <e:if condition="${param.yhzt_type ne '3'}" var="cm_type">
                <e:if condition="${!empty param.stop_dura_type}">
                    <e:if condition="${param.stop_dura_type eq '1'}">
                        AND months_between(sysdate,a.remove_date)<=3
                    </e:if>
                    <e:if condition="${param.stop_dura_type eq '2'}">
                        AND months_between(sysdate,a.remove_date)>3
                    </e:if>
                </e:if>
            </e:if>
            AND a.stop_type = b.stop_type
            )
            where rownum <= ${(param.page + 1) * 15}) t
            )t1
            where rn > ${param.page * 15}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getInfo">
        <e:q4l var="dataList">
            SELECT
            a.village_name,
            cust_name,
            decode(user_contact_nbr,'0',' ',user_contact_nbr) user_contact_nbr,
            nvl(plate_number,' ') plate_number,
            DECODE(carrier_type,0,1,2) colle_type,
            carrier_type,
            tariff_desc ,
            nvl(to_char(exp_date,'yyyy-mm-dd'),' ') exp_date,
            nvl(to_char(hold_install_date,'yyyy-mm-dd' ),' ') hold_install_date,
            info_desc
            FROM EDWWEB.TB_COUNTRY_GATHER@GSEDW t,
            edw.vw_tb_cde_village@gsedw a
            WHERE address_id = '${param.address_id}'
            and a.village_id = t.village_id
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="save_collect_info_village_cell">
        <e:update var="res">
            <e:if condition="${!empty param.address_id}" var="empty_add_id">
                UPDATE EDWWEB.TB_COUNTRY_GATHER@GSEDW
                SET cust_name = '${param.cust_name}',
                user_contact_nbr = '${param.cust_phone}',
                plate_number = '${param.door_hao}',
                carrier_type = '${param.collect_operator}',
                tariff_desc = '${param.collect_expense}',
                exp_date = to_date('${param.collect_date}','yyyy-mm-dd'),
                hold_install_date = to_date('${param.collect_date_sx}','yyyy-mm-dd'),
                gather_date = SYSDATE,
                brigade_id = '${param.she_dui_id}',
                INFO_DESC = '${param.collect_comments}'
                WHERE address_id = '${param.address_id}'
            </e:if>
            <e:else condition="${empty_add_id}">
                INSERT INTO EDWWEB.TB_COUNTRY_GATHER@GSEDW(
                village_id,
                cust_name,
                user_contact_nbr,
                plate_number,
                carrier_type,
                tariff_desc,
                exp_date,
                hold_install_date,
                brigade_id,
                info_desc,
                gather_date,
                address_id
                )VALUES(
                '${param.village_id}',
                '${param.cust_name}',
                '${param.cust_phone}',
                '${param.door_hao}',
                '${param.collect_operator}',
                '${param.collect_expense}',
                to_date('${param.collect_date}','yyyy-mm-dd'),
                to_date('${param.collect_date_sx}','yyyy-mm-dd'),
                '${param.she_dui_id}',
                '${param.collect_comments}',
                sysdate,
                sys_guid()
                )
            </e:else>
        </e:update>${res}
    </e:case>

    <e:case value="getSheDuiByAddressId">
        <e:q4l var="dataList">
            SELECT DISTINCT brigade_id FROM EDWWEB.TB_COUNTRY_GATHER@GSEDW
            WHERE address_id = '${param.address_id}'
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="get_obd_user_list">
        <e:q4l var="dataList">
            select * from (
            select t.*,rownum rn from (
            SELECT * FROM (
            SELECT DISTINCT t.*, COUNT(1) OVER() C_NUM
            FROM (SELECT NVL(SERV_NAME, ' ') SERV_NAME,
            t.ACC_NBR,
            TO_CHAR(FINISH_DATE, 'yyyy-mm-dd') FINISH_DATE,
            CASE
            WHEN T.INET_MONTH IS NULL THEN
            '--'
            WHEN T.INET_MONTH / 12 = 1 THEN
            '1年'
            WHEN T.INET_MONTH / 12 > 1 THEN
            FLOOR(T.INET_MONTH / 12) || '年'
            END || CASE
            WHEN MOD(T.INET_MONTH, 12) > 0 THEN
            MOD(T.INET_MONTH, 12) || '个月'
            END INET_MONTH,
            C.STOP_TYPE_NAME,
            EQP_NO,
            ADDRESS,
            DECODE(USER_CONTACT_NBR, '0', ' ', USER_CONTACT_NBR) USER_CONTACT_NBR,
            T.PROD_INST_ID,
            b.port_id,
            t.brigade_id
            FROM ${gis_user}.TB_GIS_USER_LIST_D   T,
            ${gis_user}.TB_DIC_GIS_STOP_TYPE C,
            EDWDEV.TB_SMA_OBD_PRO@GSEDW   B
            WHERE T.STOP_TYPE = C.STOP_TYPE
            and t.epon_type = 2
            AND T.VILLAGE_ID = '${param.village_id}'
            AND T.EQP_NO = '${param.eqp_no}'
            AND B.EQP_ID = T.EQP_ID
            AND b.prod_Inst_id = t.prod_inst_id
            )t
            )
            where rownum <= ${(param.page + 1) * 15}) t
            )t1
            where rn > ${param.page * 15}
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="get_obd_user_summary">
        <e:q4l var="dataList">
            SELECT nvl(eqp_no,' ') eqp_no,nvl(address,' ') address,nvl(capacity,0) capacity,nvl(t.actualcapacity,0) actualcapacity,
            to_char(round(decode(nvl(CAPACITY,0),0,0,ACTUALCAPACITY/CAPACITY),4)*100,'FM9999999990.00')||'%' rate
            FROM ${gis_user}.TB_GIS_COUNTRY_ODB_D t
            where t.eqp_no = '${param.eqp_no}'
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="getMktReasonByProdInstId">
        <e:q4o var="dataObject">
            <e:description>
            select CONTACT_SCRIPT from ${gis_user}.VIEW_GIS_ORDER_LIST_MON where TARGET_OBJ_NBR = '${param.prod_inst_id}'
            </e:description>
            select mkt_reason CONTACT_SCRIPT from ${sql_part_tab1} where prod_inst_id = '${param.prod_inst_id}'
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

</e:switch>