<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
    <e:description>支局 市场 网格渗透率</e:description>
    <e:description>这里要求显示该网格所在支局的所有网格信息</e:description>
    <e:case value="getGridMarketBySubstation">
        <c:tablequery>
            SELECT
            '网格渗透率' a,
            c.UNION_ORG_CODE,
            c.BRANCH_NAME,
            c.ZOOM,
            c.GRID_ID,
            c.GRID_NAME,
            s.STATION_ID,
            CASE WHEN nvl(t.gz_zhu_hu_count,0) = 0 THEN '--' ELSE ROUND( nvl(t.gz_H_USE_CNT,0)/nvl(t.gz_zhu_hu_count,0),4)*100 ||'%' END USE_RATE,
            nvl(t.gz_zhu_hu_count,0) GZ_ZHU_HU_COUNT,
            nvl(t.gz_H_USE_CNT,0) gz_H_USE_CNT,
            nvl(ly_cnt,0) ly_cnt
            FROM ${gis_user}.TB_GIS_RES_INFO_DAY T ,${gis_user}.DB_CDE_GRID C, ${gis_user}.SPC_BRANCH_STATION S
            WHERE flg = '4'
            AND T.LATN_ID(+) = C.GRID_ID
            AND C.GRID_UNION_ORG_CODE = S.STATION_NO
            AND C.UNION_ORG_CODE = '${param.substation }'
            AND C.GRID_STATUS = 1
            AND C.GRID_UNION_ORG_CODE <> '-1'
        </c:tablequery>
    </e:case>

    <e:case value="getGridResourceBySubstation">
        <c:tablequery>
            SELECT T.*,rownum FROM (
            SELECT
            '网格资源' a,
            t1.UNION_ORG_CODE,
            t1.BRANCH_NAME,
            t1.ZOOM,
            T1.GRID_NAME,
            T1.GRID_ID,
            s.STATION_ID,
            NVL(TO_CHAR(T2.OBD_CNT), ' ') OBD_CNT,
            NVL(TO_CHAR(T2.ZERO_OBD_CNT), ' ') ZERO_OBD_CNT,
            NVL(TO_CHAR(T2.HIGH_USE_OBD_CNT), ' ') HIGH_USE_OBD_CNT,
            DECODE(NVL(T2.PORT_ID_CNT, 0),
            0,
            ' ',
            TO_CHAR(ROUND(NVL(T2.USE_PORT_CNT, 0) / T2.PORT_ID_CNT, 4) * 100,
            'FM9999990.00') || '%') PORT_PERCENT,
            NVL(TO_CHAR(T2.PORT_ID_CNT), ' ') PORT_ID_CNT,
            NVL(TO_CHAR(T2.USE_PORT_CNT), ' ') USE_PORT_CNT,
            NVL(TO_CHAR(T2.KONG_PORT_CNT), ' ') KONG_PORT_CNT,
            ROWNUM ROW_NUM
            FROM
            ${gis_user}.DB_CDE_GRID T1,
            ${gis_user}.TB_GIS_RES_INFO_DAY T2,
            ${gis_user}.SPC_BRANCH_STATION S
            where T1.GRID_ID = T2.LATN_ID(+)
            AND T1.GRID_UNION_ORG_CODE = S.STATION_NO
            AND T1.UNION_ORG_CODE = '${param.substation }'
            AND T1.GRID_STATUS = '1'
            AND T2.FLG = '4'
            AND T1.GRID_UNION_ORG_CODE <> '-1'
            ) T
        </c:tablequery>
    </e:case>

    <e:case value="getVillgeCntByType">
        <e:q4l var="dataList">
            SELECT
            count(DECODE(village_label_flg,1,village_id,NULL)) JI_PO_VILL_CNT,
            count(DECODE(village_label_flg,2,village_id,NULL)) JIN_PO_VILL_CNT,
            count(DECODE(village_label_flg,3,village_id,NULL)) CAO_XIN_VILL_CNT,
            count(DECODE(village_label_flg,4,village_id,NULL)) PING_WEN_VILL_CNT
            from
            (
            select distinct village_id,village_label_flg
            FROM gis_data.view_gis_village_lable_detail t
            where t.acct_day=(SELECT to_char(to_date(const_value,'yyyymmdd'),'yyyymmdd') val FROM easy_data.sys_const_table WHERE const_type = 'var.dss28' AND data_type = 'day')
            AND grid_id = (select distinct grid_id from ${gis_user}.db_cde_grid where grid_union_org_code = '${param.grid_id}')
            )
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>网格 小区 小区清单</e:description>
    <e:case value="getVillageMarketByGrid">
        <c:tablequery>
            SELECT T.*, ROWNUM FROM(
            SELECT
            vif.village_name,
            vif.village_id,
            nvl(vif.build_sum,0) build_sum,
            nvl(dif.gz_zhu_hu_count,0) zhu_hu_sum,
            DECODE(NVL(dif.gz_zhu_hu_count, 0), 0, '0.00',TO_CHAR(ROUND(dif.gz_h_use_cnt / dif.gz_zhu_hu_count, 4) * 100, 'FM990.00')) || '%' market_penetrance,
            NVL(dif.GOV_ZHU_HU_COUNT, 0) gov_user,
            NVL(dif.H_USE_CNT, 0) wide_net_sum,
            NVL(dif.GOV_H_USE_CNT, 0) gov_net_sum,
            DECODE(dif.port_id_cnt,0,'--',TO_CHAR(round(dif.use_port_cnt / dif.port_id_cnt,4) * 100,'FM990.00')
            || '%') port_percent,
            nvl(dif.port_id_cnt,0) port_sum,
            nvl(dif.kong_port_cnt,0) port_free_sum,
            nvl(dif.use_port_cnt,0) port_used_sum,
            vif.branch_no union_org_code,
            vif.branch_name,
            vif.grid_id station_id,
            vif.grid_name,
            vgvsl.filter_mon_rate,
            vgvsl.filter_year_rate
            FROM
            ${gis_user}.tb_gis_village_edit_info vif,
            ${gis_user}.TB_GIS_RES_INFO_DAY dif,
            ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST vgvsl
            where vif.village_id = dif.LATN_ID(+)
            and vif.village_Id = vgvsl.village_id(+)
            and vif.grid_id_2 = (select distinct grid_id from ${gis_user}.db_cde_grid where grid_union_org_code = '${param.grid_id }')
            ) T
        </c:tablequery>
    </e:case>

    <e:case value="get_info_all">
        <e:q4l var="dataList">
            SELECT
            nvl(GZ_ZHU_HU_COUNT,0) GZ_ZHU_HU_COUNT,
            nvl(GZ_H_USE_CNT,0) GZ_H_USE_CNT,
            DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100, 'FM990.00') || '%') MARKET_RATE,
            nvl(GOV_ZHU_HU_COUNT,0)  GOV_ZHU_HU_COUNT,
            nvl(GOV_H_USE_CNT,0) GOV_H_USE_CNT,
            nvl(OBD_CNT,0) OBD_CNT,
            nvl(ZERO_OBD_CNT,0) ZERO_OBD_CNT,
            nvl(HIGH_USE_OBD_CNT,0) HIGH_USE_OBD_CNT,
            nvl(LY_CNT,0) LY_CNT,
            nvl(NO_RES_ARRIVE_CNT,0) NO_RES_ARRIVE_CNT,
            NVL(LY_CNT, 0) - NVL(NO_RES_ARRIVE_CNT, 0) RES_ARRIVE_CNT,
            DECODE(NVL(LY_CNT, '0'), '0', ' ', TO_CHAR(ROUND((NVL(LY_CNT, 0) - NVL(NO_RES_ARRIVE_CNT, 0)) / LY_CNT, 4) * 100, 'FM999999990.00') || '%') RESOUCE_RATE,
            nvl(PORT_ID_CNT,0) PORT_ID_CNT,
            nvl(USE_PORT_CNT,0) USE_PORT_CNT,
            nvl(KONG_PORT_CNT,0) KONG_PORT_CNT,
            DECODE(NVL(PORT_ID_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(USE_PORT_CNT, 0) / PORT_ID_CNT, 4) * 100, 'FM990.00') || '%') PORT_RATE,
            NVL(LY_CNT, 0) - NVL(WJ_CNT, 0) USED_BUILD_NUM,
            nvl(WJ_CNT,0) WJ_CNT,
            nvl(LOW_10_FILTER_VILLAGE_CNT,0) LOW_10_FILTER_VILLAGE_CNT,
            nvl(NO_RES_VILLAGE_CNT,0) NO_RES_VILLAGE_CNT,
            nvl(VILLAGE_CNT,0) VILLAGE_CNT,
            DECODE(NVL(ACTIVE_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT, 4) * 100, 'FM990.00') || '%') ACTIVE_RATE,
            DECODE(NVL(XY_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(XY_CNT, 0) / XY_ALL_CNT, 4) * 100, 'FM990.00') || '%') XY_RATE,
            DECODE(NVL(LW_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(LW_CNT, 0) / LW_ALL_CNT, 4) * 100, 'FM990.00') || '%') LW_RATE,
            DECODE(NVL(BY_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(BY_CNT, 0) / BY_ALL_CNT, 4) * 100, 'FM990.00') || '%') BY_RATE,
            nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
            nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
            DECODE(NVL(SHOULD_COLLECT_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT, 4) * 100, 'FM990.00') || '%') COLLECT_RATE
            FROM ${gis_user}.TB_GIS_RES_INFO_DAY
            WHERE LATN_ID = (select distinct grid_id from ${gis_user}.db_cde_grid where grid_union_org_code = '${param.grid_id }')
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

</e:switch>