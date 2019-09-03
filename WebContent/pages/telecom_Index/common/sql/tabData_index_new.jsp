<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
    <e:description>支局 市场 网格渗透率</e:description>
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
            AND union_org_code = '${param.substation }'
            )
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:description>支局 小区 小区清单</e:description>
    <e:case value="getVillageMarketBySubstation">
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
            and vif.branch_no = '${param.substation }'
            ) T
        </c:tablequery>
    </e:case>

</e:switch>