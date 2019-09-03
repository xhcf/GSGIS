<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
    <e:description>小区营销策略清单 begin </e:description>
    <e:case value="data_list">
        <e:q4l var="dataList">
            select * from
            (
                SELECT T.*, ROWNUM ROW_NUM FROM
                (
                    select

                    ee.tactics_id,
                    aa.latn_name city_name,
                    aa.village_id village_id,
                    aa.latn_id,
                    aa.bureau_no,
                    aa.union_org_code,
                    aa.grid_id,
                    bb.latn_name village_name,

                    cc.zhu_hu_count,
                    bb.markt_lv,
                    bb.cover_lv,
                    bb.port_lv,
                    decode(cc.GZ_H_USE_CNT,0,'--',TO_CHAR(ROUND(nvl(dd.LOST_Y_TOTAL,0) / cc.GZ_H_USE_CNT,4) * 100,'FM9999999990.00') || '%') LOST_LV,
                    decode(cc.BY_ALL_CNT,0,'--',TO_CHAR(ROUND(nvl(cc.BY_CNT,0) / cc.BY_ALL_CNT,4) * 100,'FM9999999990.00') || '%') BY_LV,

                    decode(ee.goal_market_lv,0,'--',to_char(nvl(ee.goal_market_lv,0),'FM999999990.00') || '%') goal_market_lv,
                    decode(ee.goal_port_lv,0,'--',to_char(nvl(ee.goal_port_lv,0),'FM999999990.00') || '%') goal_port_lv,
                    decode(ee.goal_lost_lv,0,'--',to_char(nvl(ee.goal_lost_lv,0),'FM999999990.00') || '%') goal_lost_lv,
                    decode(ee.goal_d2r,0,'--',nvl(ee.goal_d2r,0)) goal_d2r,
                    decode(ee.goal_dqxy,0,'--',nvl(ee.goal_dqxy,0)) goal_dqxy,
                    decode(ee.goal_sleep2active,0,'--',nvl(ee.goal_sleep2active,0)) goal_sleep2active,
                    decode(ee.goal_collect_lv,0,'--',to_char(nvl(ee.goal_collect_lv,0),'FM999999990.00') || '%') goal_collect_lv,

                    COUNT(1) OVER() c_num from
                    ${gis_user}.view_db_cde_village aa,
                    ${gis_user}.view_GIS_RES_CITY_DAY bb,
                    ${gis_user}.tb_gis_res_info_day cc,
                    ${gis_user}.TB_HDZ_VILLAGE_LOST dd,
                    ${gis_user}.tb_gis_village_tactics ee

                    where
                    aa.village_id = bb.latn_id(+)
                    and aa.village_id = cc.latn_id(+)
                    and aa.village_id = dd.village_id(+)
                    and aa.village_id = ee.village_id
                    and aa.branch_type = 'a1'
                    and bb.acct_day = '${param.beginDate}'
                    and bb.flg = 5

                    <e:if condition="${!empty param.village_type}">
                        and bb.village_type = '${param.village_type}'
                    </e:if>

                    <e:if condition="${!empty param.latn_id}">
                        and aa.latn_id='${param.latn_id}'
                    </e:if>

                    <e:if condition="${!empty param.bureau_id}">
                        and aa.bureau_no='${param.bureau_id}'
                    </e:if>

                    <e:if condition="${!empty param.branch_id}">
                        and aa.union_org_code='${param.branch_id}'
                    </e:if>

                    <e:if condition="${!empty param.grid_id}">
                        and aa.grid_id='${param.grid_id}'
                    </e:if>
                    order by ord
                ) T
            )
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
        </e:q4l>${e: java2json(dataList.list)}
    </e:case>
    <e:description>小区营销策略清单 end </e:description>
</e:switch>