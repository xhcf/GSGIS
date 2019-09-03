<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="sql_part">
    count(1) sum_cnt,
    count(case when ze_port_flg=1 or fi_port_flg=1 then 1 else null end) obd01_cnt,
    count(case when ze_port_flg=1 then 1 else null end) obd0_cnt,
    count(case when fi_port_flg=1 then 1 else null end) obd1_cnt,
    <e:description>
        count(case when zero_port_flg=0 then 1 else null end) hobd_cnt
    </e:description>
    count(case when nvl(user_port_rate,0)>=0.6 then 1 else null end) hobd_cnt
</e:set>
<e:set var="sql_part_dqsj">
    <e:description>NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') KD_DQ_DATE,</e:description>
    CASE WHEN NVL(O.IS_KD_DX, 0) = '0' AND (O.KD_BUSINESS = '0' OR O.KD_BUSINESS IS NULL) THEN ' '
    ELSE NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') END KD_DQ_DATE,
</e:set>
<e:set var="sql_part_where">
    and nvl(t.user_port_rate,0)>=0.6
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
    <e:description>${gis_user}.VIEW_GIS_ORDER_LIST</e:description>
    ${gis_user}.VIEW_GIS_ORDER_LIST_TMP
</e:set>
<e:switch value="${param.eaction}">
<e:description>支局长部分 begin</e:description>
  <e:description>市场部分begin</e:description>
  <e:case value="summary_bar">
    <e:q4l var="summary_bar">
    SELECT T2.MONTH_CODE, NVL(T1.USE_RATE, 0.00) USE_RATE
      FROM (
            SELECT ACCT_MONTH MONTH_CODE, ROUND(NVL(RATE, 0), 4) * 100 USE_RATE
              FROM ${gis_user}.TB_GIS_ST_RATE_MON
             WHERE VILLAGE_ID = '${param.substation }'
               AND ACCT_MONTH BETWEEN
                   TO_CHAR(ADD_MONTHS(TO_DATE('${param.month}', 'yyyymm'), -4), 'yyyymm') AND
                   TO_CHAR(ADD_MONTHS(TO_DATE('${param.month}', 'yyyymm'), 0), 'yyyymm')) T1
     RIGHT JOIN (SELECT DISTINCT A.MONTH_CODE
                   FROM ${gis_user}.TB_DIM_TIME A
                  WHERE A.MONTH_CODE BETWEEN
                        TO_CHAR(ADD_MONTHS(TO_DATE('${param.month}', 'yyyymm'), -4),
                                'yyyymm') AND
                        TO_CHAR(ADD_MONTHS(TO_DATE('${param.month}', 'yyyymm'), 0),
                                'yyyymm')) T2
     ON T1.MONTH_CODE = T2.MONTH_CODE
        UNION ALL
        SELECT to_number(to_char(sysdate, 'yyyymm')) MONTH_CODE,
        CASE
        WHEN GZ_ZHU_HU_COUNT = 0 THEN
        0
        ELSE
        (ROUND(NVL(GZ_H_USE_CNT / GZ_ZHU_HU_COUNT, 0), 4) * 100)
        END USE_RATE
        FROM ${gis_user}.TB_GIS_RES_CITY_DAY
        where latn_id = '${param.substation }'
     ORDER BY MONTH_CODE
    </e:q4l>${e:java2json(summary_bar.list)}
  </e:case>
  <e:case value="basic_info">
    <e:q4l var="basic_info">
        select
        case when GZ_ZHU_HU_COUNT = 0 then '--' else round(GZ_H_USE_CNT/GZ_ZHU_HU_COUNT,4)*100 || '%' end USE_RATE,
        GZ_ZHU_HU_COUNT ADDR_NUM,
        GZ_H_USE_CNT USER_NUM_H,
        GOV_ZHU_HU_COUNT ZHU_HU_ZQ,
        GOV_H_USE_CNT ZHU_HU_ZQ_H,
        LY_CNT BUILD_NUM,
        NO_RES_ARRIVE_CNT BUILD_NUM_UNREACH
        from ${gis_user}.TB_GIS_RES_INFO_DAY
        where latn_id = '${param.substation}'
    </e:q4l>${e:java2json(basic_info.list)}
  </e:case>
  <e:case value="market_grid">
    <e:q4l var="market_grid">
        SELECT
        c.GRID_ID,
        c.GRID_NAME,
        CASE WHEN nvl(t.gz_zhu_hu_count,0) = 0 THEN '--' ELSE ROUND( nvl(t.gz_H_USE_CNT,0)/nvl(t.gz_zhu_hu_count,0),4)*100 ||'%' END USE_RATE,
        nvl(t.gz_zhu_hu_count,0) ADDR_NUM,
        nvl(t.gz_H_USE_CNT,0) gz_H_USE_CNT,
        nvl(t.GOV_ZHU_HU_COUNT,0) GOV_ZHU_HU_COUNT,
        nvl(t.GOV_H_USE_CNT,0) GOV_H_USE_CNT,
        CASE WHEN nvl(t.PORT_ID_CNT,0) = 0 THEN '--' ELSE round(NVL(t.USE_PORT_CNT,0)/nvl(t.PORT_ID_CNT,0),4)*100||'%' END PORT_RATE,
        nvl(t.PORT_ID_CNT,0) PORT_ID_CNT,
        NVL(t.USE_PORT_CNT,0) USE_PORT_CNT,
        nvl(t.KONG_PORT_CNT,0) KONG_PORT_CNT
        FROM ${gis_user}.TB_GIS_RES_INFO_DAY T ,${gis_user}.DB_CDE_GRID C
        WHERE flg = '4'
        AND T.LATN_ID(+) = C.GRID_ID
        AND C.UNION_ORG_CODE = '${param.substation }'
        AND C.GRID_STATUS = 1
        AND C.GRID_UNION_ORG_CODE <> '-1'
    </e:q4l>${e:java2json(market_grid.list)}
  </e:case>
  <e:case value="market_grid2">
    <e:q4l var="market_grid2">
	SELECT COUNT(1) NUM
	FROM
	${gis_user}.db_cde_grid
	WHERE
	 union_org_code='${param.substation }'
	 AND grid_status = 1
	 AND GRID_UNION_ORG_CODE <> '-1'
    </e:q4l>${e:java2json(market_grid2.list)}
  </e:case>
  <e:case value="market_village">
    <e:q4l var="village_list">
    SELECT * FROM (
    SELECT T.*, ROWNUM ROW_NUM FROM(
        SELECT
		    vif.village_name,
            vif.village_id,
            nvl(vif.build_sum,0) build_sum,
            nvl(dif.gz_zhu_hu_count,0) zhu_hu_sum,
            DECODE(NVL(dif.gz_zhu_hu_count, 0), 0, '--',TO_CHAR(ROUND(dif.gz_h_use_cnt / dif.gz_zhu_hu_count, 4) * 100, 'FM990.00') || '%') market_penetrance,
            NVL(dif.GOV_ZHU_HU_COUNT, 0) gov_user,
            NVL(dif.gz_H_USE_CNT, 0) wide_net_sum,
            NVL(dif.GOV_H_USE_CNT, 0) gov_net_sum,
            DECODE(dif.port_id_cnt,0,'--',TO_CHAR(round(dif.use_port_cnt / dif.port_id_cnt,4) * 100,'FM990.00')
            || '%') port_percent,
            nvl(dif.port_id_cnt,0) port_sum,
            nvl(dif.kong_port_cnt,0) port_free_sum,
            nvl(dif.use_port_cnt,0) port_used_sum,
            vif.branch_no union_org_code,
            vif.branch_name,
            vif.grid_id station_id,
            vif.grid_name
		FROM
		    ${gis_user}.tb_gis_village_edit_info vif
            LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY dif
            ON dif.LATN_ID = vif.village_id
		WHERE
		    vif.branch_no = '${param.substation }'
		    <e:if condition="${! empty param.village_grid_id }">
		    AND vif.GRID_ID_2 = '${param.village_grid_id }'
		    </e:if>
		    <e:if condition="${! empty param.village_name }">
		    AND vif.village_name like '%${param.village_name }%'
		    </e:if>
		    <e:if condition="${(! empty param.market_percent_select) && (param.market_percent_select ne '0') }">
	            <e:switch value="${param.market_percent_select }">
	                AND NVL(DIF.GZ_ZHU_HU_COUNT, 0) <> 0
	                <e:case value="1">
	                AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) >= 0.6
	                </e:case>
	                <e:case value="2">
                    AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) < 0.6
                    AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) > 0.3
                    </e:case>
                    <e:case value="3">
                    AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) <= 0.3
                    </e:case>
	            </e:switch>
	        </e:if>
	        ORDER BY
           <e:if condition="${param.sort_type eq '0' }">
               DECODE(NVL(DIF.GZ_ZHU_HU_COUNT, 0), 0, -1, NVL(DIF.GZ_H_USE_CNT, 0) / DIF.GZ_ZHU_HU_COUNT)
               <e:if condition="${param.sort_state eq '0' }" var="is_up">
                    DESC NULLS LAST
               </e:if>
               <e:else condition="${is_up }">
                    ASC NULLS FIRST
               </e:else>
           </e:if>
		    ) T
		    )
	   WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
    </e:q4l>${e: java2json(village_list.list) }
  </e:case>

  <e:case value="market_village_empty">
      <e:q4o var="dataObject">
          SELECT LATN_ID,
          CASE
          WHEN WJ_GZ_ZHU_HU_COUNT = 0 THEN
          '0'
          ELSE
          TO_CHAR(ROUND(DIF.WJ_GZ_H_USE_CNT / DIF.WJ_GZ_ZHU_HU_COUNT, 4) * 100,
          'FM990.00') || '%'
          END MARKET_PENETRANCE,
          WJ_CNT,
          WJ_GZ_ZHU_HU_COUNT,
          WJ_H_USE_CNT,
          DECODE(DIF.WJ_PORT_ID_CNT,
          0,
          '0',
          TO_CHAR(ROUND(DIF.WJ_USE_PORT_CNT / DIF.WJ_PORT_ID_CNT, 4) * 100,
          'FM990.00') || '%') PORT_PERCENT,
          WJ_PORT_ID_CNT,
          WJ_USE_PORT_CNT,
          WJ_KONG_PORT_CNT
          FROM ${gis_user}.TB_GIS_RES_CITY_DAY DIF
          WHERE WJ_CNT > 0
          AND FLG = '${param.flag}'
          <e:if condition="${!empty param.union_org_code}">
              AND LATN_ID = '${param.union_org_code}'
          </e:if>
      </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="market_village_count">
    <e:q4o var="village_count">
        SELECT
            DISTINCT COUNT(*) A_COUNT,
            NVL(SUM(CASE
            WHEN NVL(DIF.GZ_ZHU_HU_COUNT,0) = 0 THEN 0
            WHEN NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT >= 0.6 THEN 1
            ELSE 0
            END), 0) H_COUNT,
            NVL(SUM(CASE
            WHEN NVL(DIF.GZ_ZHU_HU_COUNT,0) = 0 THEN 0
            WHEN NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT < 0.6 AND NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT > 0.3  THEN 1
            ELSE 0
            END), 0) M_COUNT,
            NVL(SUM(CASE
            WHEN NVL(DIF.GZ_ZHU_HU_COUNT,0) = 0 THEN 0
            WHEN NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT <= 0.3 THEN 1
            ELSE 0
            END), 0) L_COUNT
        FROM
            ${gis_user}.tb_gis_village_edit_info vif
            LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY dif
            ON dif.LATN_ID = vif.village_id
        WHERE
            vif.branch_no = '${param.substation }'
            <e:if condition="${! empty param.village_grid_id }">
            AND vif.GRID_ID_2 = '${param.village_grid_id }'
            </e:if>
            <e:if condition="${! empty param.village_name }">
            AND vif.village_name like '%${param.village_name }%'
            </e:if>
            <e:if condition="${(! empty param.market_percent_select) && (param.market_percent_select ne '0') }">
                <e:switch value="${param.market_percent_select }">
                    AND NVL(DIF.GZ_ZHU_HU_COUNT, 0) <> 0
                    <e:case value="1">
                    AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) >= 0.6
                    </e:case>
                    <e:case value="2">
                    AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) < 0.6
                    AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) > 0.3
                    </e:case>
                    <e:case value="3">
                    AND NVL(DIF.GZ_H_USE_CNT , 0) / NVL(DIF.GZ_ZHU_HU_COUNT, 1) <= 0.3
                    </e:case>
                </e:switch>
            </e:if>
    </e:q4o>${e: java2json(village_count) }
  </e:case>

  <e:case value="market_build">
   <e:q4l var="build_list">
 select *
  from (select t.*, rownum row_num
          from (select nvl(vif.village_name, ' ') village_name,
                       nvl(vif.village_id, '-1') village_id,
                       bif.stand_name stand_name,
                       bif.segm_id segm_id,
                       decode(nvl(dif.gz_zhu_hu_count, 0),
                              0,
                              ' ',
                              to_char(round(dif.GZ_H_USE_CNT /
                                            dif.gz_zhu_hu_count,
                                            4) * 100,
                                      'FM99990.00') || '%') market_percent,
                       nvl(dif.gz_zhu_hu_count, 0) gz_zhu_hu_count,
                       nvl(dif.GZ_H_USE_CNT, 0) gz_kd_cnt,

                       decode(nvl(dif.port_id_cnt, 0),
                              0,
                              ' ',
                              to_char(round(dif.use_port_cnt / dif.port_id_cnt,
                                            4) * 100,
                                      'FM990.00') || '%') port_percent,
                       nvl(dif.port_id_cnt, 0) port_sum,
                       nvl(dif.kong_port_cnt, 0) port_free_sum,
                       nvl(dif.use_port_cnt, 0) port_used_sum
                  from
            sde.TB_GIS_MAP_SEGM_LATN_MON bif
            LEFT OUTER JOIN ${gis_user}.tb_gis_village_addr4 bvf
            ON bvf.SEGM_ID = bif.SEGM_ID
            LEFT OUTER JOIN ${gis_user}.tb_gis_village_edit_info vif
            ON bvf.VILLAGE_ID = vif.VILLAGE_ID
            LEFT OUTER JOIN ${gis_user}.tb_gis_res_info_day dif
            ON ( bif.SEGM_ID = dif.latn_id AND dif.flg = '6' )
        WHERE
            bif.UNION_ORG_CODE = '${param.substation }'
            <e:if condition="${! empty param.build_grid_id }">
            AND bif.GRID_ID = '${param.build_grid_id }'
            </e:if>
            <e:if condition="${! empty param.village_id }">
            AND vif.village_id like '${param.village_id }'
            </e:if>
            <e:if condition="${! empty param.build_name }">
            AND bif.STAND_NAME like '%${param.build_name }%'
            </e:if>
            <e:if condition="${(! empty param.market_percent_select) && (param.market_percent_select ne '0') }">
                AND NVL(DIF.GZ_ZHU_HU_COUNT, 0) <> 0
                <e:switch value="${param.market_percent_select }">
                    <e:case value="1">
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) >= 0.6
                    </e:case>
                    <e:case value="2">
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) < 0.6
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) > 0.3
                    </e:case>
                    <e:case value="3">
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) <= 0.3
                    </e:case>
                </e:switch>
            </e:if>
            ORDER BY
                stand_name asc,
            <e:if condition="${param.sort_type eq '0' }">
                DECODE(NVL(DIF.GZ_ZHU_HU_COUNT, 0), 0, -1, NVL(DIF.GZ_H_USE_CNT, 0) / DIF.GZ_ZHU_HU_COUNT)
	            <e:if condition="${param.sort_state eq '0' }" var="is_up">
	                DESC
	            </e:if>
	            <e:else condition="${is_up }">
	                ASC
	            </e:else>,
	            DECODE(VIF.VILLAGE_NAME,' ',NULL,VIF.VILLAGE_NAME) DESC NULLS LAST,
	            DECODE(BIF.STAND_NAME,' ',NULL,BIF.STAND_NAME) DESC NULLS LAST
	       </e:if>
	       <e:if condition="${param.sort_type eq '1' }">
	            DECODE(VIF.VILLAGE_NAME,' ',NULL,VIF.VILLAGE_NAME)
	            <e:if condition="${param.sort_state eq '0' }" var="is_up">
	                DESC NULLS LAST
	            </e:if>
	            <e:else condition="${is_up }">
	                ASC NULLS FIRST
	            </e:else>,
	            DECODE(NVL(DIF.GZ_ZHU_HU_COUNT, 0), 0, -1, NVL(DIF.GZ_H_USE_CNT, 0) / DIF.GZ_ZHU_HU_COUNT) DESC,
	            DECODE(BIF.STAND_NAME,'--',NULL,BIF.STAND_NAME) DESC NULLS LAST
	       </e:if>
	       <e:if condition="${param.sort_type eq '2' }">
	            DECODE(BIF.STAND_NAME,'--',NULL,BIF.STAND_NAME)
	            <e:if condition="${param.sort_state eq '0' }" var="is_up">
	                DESC NULLs LAST
	            </e:if>
	            <e:else condition="${is_up }">
	                ASC NULLs FIRST
	            </e:else>,
	            DECODE(NVL(DIF.GZ_ZHU_HU_COUNT, 0), 0, -1, NVL(DIF.GZ_H_USE_CNT, 0) / DIF.GZ_ZHU_HU_COUNT) DESC,
	            DECODE(VIF.VILLAGE_NAME,'--',NULL,VIF.VILLAGE_NAME) DESC NULLS LAST
	       </e:if>
            ) T
       )
       WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
    </e:q4l>${e: java2json(build_list.list) }
  </e:case>

  <e:case value="market_build_count">
    <e:q4o var="build_count">
        SELECT
            DISTINCT COUNT(*) A_COUNT,
            NVL(SUM(CASE
            WHEN NVL(DIF.GZ_ZHU_HU_COUNT,0) = 0 THEN 0
            WHEN NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT >= 0.6 THEN 1
            ELSE 0
            END), 0) H_COUNT,
            NVL(SUM(CASE
            WHEN NVL(DIF.GZ_ZHU_HU_COUNT,0) = 0 THEN 0
            WHEN NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT < 0.6 AND NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT > 0.3  THEN 1
            ELSE 0
            END), 0) M_COUNT,
            NVL(SUM(CASE
            WHEN NVL(DIF.GZ_ZHU_HU_COUNT,0) = 0 THEN 1
            WHEN NVL(DIF.GZ_H_USE_CNT,0) / DIF.GZ_ZHU_HU_COUNT <= 0.3 THEN 1
            ELSE 0
            END), 0) L_COUNT
        FROM
            SDE.TB_GIS_MAP_SEGM_LATN_MON bif
            LEFT OUTER JOIN ${gis_user}.tb_gis_village_addr4 bvf
            ON bvf.SEGM_ID = bif.SEGM_ID
            LEFT OUTER JOIN ${gis_user}.tb_gis_village_edit_info vif
            ON bvf.VILLAGE_ID = vif.VILLAGE_ID
            LEFT OUTER JOIN ${gis_user}.tb_gis_res_info_day dif
            ON ( bif.SEGM_ID = dif.latn_id AND dif.flg = '6' )
        WHERE
            bif.UNION_ORG_CODE = '${param.substation }'
            <e:if condition="${! empty param.build_grid_id }">
            AND bif.GRID_ID = '${param.build_grid_id }'
            </e:if>
            <e:if condition="${! empty param.village_id }">
            AND vif.village_id like '${param.village_id }'
            </e:if>
            <e:if condition="${! empty param.build_name }">
            AND bif.STAND_NAME like '%${param.build_name }%'
            </e:if>
            <e:if condition="${(! empty param.market_percent_select) && (param.market_percent_select ne '0') }">
                <e:switch value="${param.market_percent_select }">
                    AND NVL(DIF.GZ_ZHU_HU_COUNT, 0) <> 0
                    <e:case value="1">
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) >= 0.6
                    </e:case>
                    <e:case value="2">
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) < 0.6
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) > 0.3
                    </e:case>
                    <e:case value="3">
                    AND NVL(dif.GZ_H_USE_CNT, 0) / NVL(dif.gz_zhu_hu_count, 1) <= 0.3
                    </e:case>
                </e:switch>
            </e:if>
    </e:q4o>${e: java2json(build_count) }
  </e:case>
  <e:case value="market_resident">
    <e:q4l var="resident_list">
        SELECT *
        FROM (SELECT B.SEGM_ID,
        b.segm_id_2,
        B.STAND_NAME_1,
        B.SEGM_NAME_2,
        NVL(CASE
        WHEN  B.IS_KD_DX>0 THEN
        '已装'
        ELSE
        CASE
        WHEN (B.KD_BUSINESS IS NOT NULL AND B.KD_BUSINESS <> '0') THEN
        '已装'
        END
        END,
        ' ') H_NET,
        NVL(CASE
        WHEN B.IS_KD_DX>0 THEN
        '电信'
        ELSE
        CASE
        WHEN B.KD_BUSINESS = '1' THEN
        '移动'
        WHEN B.KD_BUSINESS = '2' THEN
        '联通'
        WHEN B.KD_BUSINESS = '3' THEN
        '广电'
        WHEN B.KD_BUSINESS = '4' THEN
        '其他'
        WHEN B.KD_BUSINESS = '0' THEN
        '  '
        END
        END,
        ' ') KD_BUSINESS,
        b.is_Kd_dx,
        DECODE(B.DX_CONTACT_PERSON,
        NULL,
        CASE
        WHEN B.CONTACT_PERSON IS NULL THEN
        ' '
        ELSE
        <e:description>脱敏 substr **</e:description><e:description>2018.10.22 号码脱敏</e:description>
        substr(B.CONTACT_PERSON,1,1) || '**<br />' || (substr(B.CONTACT_NBR,0,3) || '******' || substr(B.CONTACT_NBR,10,2))
        END,
        <e:description>脱敏 substr **</e:description><e:description>2018.10.22 号码脱敏</e:description>
        substr(B.DX_CONTACT_PERSON,1,1) || '**<br />' || (substr(B.DX_CONTACT_NBR,0,3) || '******' || substr(B.DX_CONTACT_NBR,10,2))) CONNECT_INFO,
        NVL(B.KD_XF, ' ') KD_XF,
        CASE
        WHEN B.IS_KD_DX>0 THEN
        NULL
        WHEN B.KD_BUSINESS IS NOT NULL THEN
        nvl(to_char(B.KD_DQ_DATE,'yyyy-mm-dd'),' ')
        ELSE
        NULL
        END KD_DQ_DATE,
        nvl(B.serial_no,'0') serial_no,
        ROWNUM rowno
        FROM (SELECT * FROM SDE.TB_GIS_MAP_SEGM_LATN_MON WHERE UNION_ORG_CODE = '${param.substation }'
        <e:if condition="${! empty param.resident_grid_id }">
            AND GRID_ID = '${param.resident_grid_id }'
        </e:if>
        )  W
        <e:if condition="${! empty param.resident_village }">
            RIGHT OUTER JOIN ${gis_user}.tb_gis_village_addr4 c on c.SEGM_ID = w.segm_id
        </e:if>
        ,${gis_user}.TB_GIS_ADDR_OTHER_ALL B
        WHERE B.SEGM_ID = W.SEGM_ID
        <e:if condition="${! empty param.resident_village }">
            AND c.VILLAGE_ID = '${param.resident_village }'
        </e:if>
        <e:if condition="${! empty param.resident_build }">
            AND stand_name_1 LIKE '%${param.resident_build }%'
        </e:if>
        <e:if condition="${ param.band eq '-1' }">
            AND b.is_Kd_dx=0 AND b.kd_business = 0
        </e:if>
        <e:if condition="${ param.band eq '1' }">
            AND (b.is_kd_dx>0 OR b.kd_business IS NOT NULL AND b.kd_business <> 0)
        </e:if>
        <e:if condition="${param.cmpy ne '0' }">
            <e:if condition="${param.cmpy eq '5' }" var="ifDX">
                AND b.is_kd_dx > 0
            </e:if>
            <e:else condition="${ifDX }">
                AND b.kd_business = '${param.cmpy }'
                AND b.is_kd_dx = 0
            </e:else>
        </e:if>
        and rownum<=${(param.page + 1) * 15 }) a
        WHERE a.rowno > ${param.page * 15 }
        ORDER BY STAND_NAME_1 ASC, length(segm_name_2) asc,SEGM_NAME_2 ASC
    </e:q4l>${e: java2json(resident_list.list) }
  </e:case>

  <e:case value="market_resident_count">
    <e:q4o var="resident_count">
    SELECT  DISTINCT C_NUM FROM(
        SELECT
            COUNT(*) OVER() C_NUM,
            ROWNUM ROW_NUM
        FROM
            sde.tb_gis_map_segm_latn_mon w
            RIGHT OUTER JOIN ${gis_user}.tb_gis_addr_info_all a ON a.segm_id = w.segm_id
            LEFT OUTER JOIN ${gis_user}.tb_gis_addr_other_all b ON A.SEGM_ID_2 = B.SEGM_ID_2
            <e:if condition="${! empty param.resident_village }">
            RIGHT OUTER JOIN ${gis_user}.tb_gis_village_addr4 c on c.SEGM_ID = w.segm_id
            </e:if>
            WHERE
            A.SEGM_ID_2 is not null
            and w.union_org_code = '${param.substation }'
            <e:if condition="${! empty param.resident_grid_id }">
            AND w.GRID_ID = '${param.resident_grid_id }'
            </e:if>
            <e:if condition="${! empty param.resident_build }">
            AND a.stand_name_1 like '%${param.resident_build }%'
            </e:if>
            <e:if condition="${! empty param.resident_village }">
            AND c.VILLAGE_ID = '${param.resident_village }'
            </e:if>
            <e:if condition="${ param.band eq '-1' }">
            AND a.is_kd <= 0
            AND (b.kd_business is null or b.kd_business = '0')
            </e:if>
            <e:if condition="${ param.band eq '1' }">
            AND(a.is_kd > 0 or (b.kd_business is not null and b.kd_business <> '0'))
            </e:if>
            <e:if condition="${param.cmpy ne '0' }">
              <e:if condition="${param.cmpy eq '5' }" var="ifDX">
              AND a.is_kd > 0
              </e:if>
              <e:else condition="${ifDX }">
              AND b.kd_business = '${param.cmpy }'
              AND a.is_kd = 0
              </e:else>
            </e:if>
        ) T
    </e:q4o>${e: java2json(resident_count) }
  </e:case>
    <e:description>市场部分 end</e:description>
    <e:description>资源部分 begin</e:description>
    <e:case value="resource_grid">
        <e:q4l var="grid_list">
        SELECT T.* FROM (
	        SELECT
			    T1.GRID_NAME,
			    T1.GRID_ID,
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
			    ${gis_user}.DB_CDE_GRID T1
			    LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY T2 ON T1.GRID_ID = T2.LATN_ID
			WHERE
			    T2.FLG = '4'
			    AND   T1.UNION_ORG_CODE = '${param.substation }'
			    AND T1.GRID_STATUS = '1'
			    AND T1.GRID_UNION_ORG_CODE <> '-1'
			) T
			WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
			ORDER BY GRID_NAME
        </e:q4l>${e: java2json(grid_list.list) }
    </e:case>
    <e:case value="resource_grid_count">
        <e:q4o var="grid_count">
       SELECT  DISTINCT C_NUM FROM(
        SELECT
            COUNT(*) OVER() C_NUM,
            ROWNUM ROW_NUM
            FROM
                ${gis_user}.DB_CDE_GRID T1
                LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY T2 ON T1.GRID_ID = T2.LATN_ID
            WHERE
                T2.FLG = '4'
                AND   T1.UNION_ORG_CODE = '${param.substation }'
                AND T1.GRID_STATUS = '1'
                AND T1.GRID_UNION_ORG_CODE <> '-1'
            ) T
        </e:q4o>${e: java2json(grid_count) }
    </e:case>
    <e:case value="resource_village">
        <e:q4l var="village_list">
            SELECT * FROM(
            SELECT T.*, ROWNUM ROW_NUM FROM (
	            SELECT
	                T1.VILLAGE_NAME,
	                T1.VILLAGE_ID,
	                NVL(TO_CHAR(T2.OBD_CNT), ' ') OBD_CNT,
	                NVL(TO_CHAR(T2.ZERO_OBD_CNT), ' ') ZERO_OBD_CNT,
	                NVL(TO_CHAR(T2.HIGH_USE_OBD_CNT), ' ') HIGH_USE_OBD_CNT,
	                DECODE(NVL(T2.PORT_ID_CNT, 0),
	                       0,
	                       ' ',
	                       TO_CHAR(ROUND(NVL(T2.USE_PORT_CNT, 0) / T2.PORT_ID_CNT,
	                                    4) * 100,
	                               'FM990.00') || '%') PORT_PERCENT,
	                NVL(TO_CHAR(T2.PORT_ID_CNT), ' ') PORT_ID_CNT,
	                NVL(TO_CHAR(T2.USE_PORT_CNT), ' ') USE_PORT_CNT,
	                NVL(TO_CHAR(T2.KONG_PORT_CNT), ' ') KONG_PORT_CNT,
	                DECODE(NVL(T2.PORT_ID_CNT, 0), 0, '-1', NVL(T2.USE_PORT_CNT, 0) / T2.PORT_ID_CNT ) PORT_PERCENT_SORT,
	                branch_no union_org_code,
					branch_name ,
					grid_name ,
					grid_id STATION_ID
	            FROM
	                ${gis_user}.tb_gis_village_edit_info T1
	                LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY T2 ON T1.VILLAGE_ID = T2.LATN_ID
	            WHERE
	                T2.FLG = '5'
	                <e:if condition="${param.collect_state eq '1' }">
	                AND T2.NO_RES_VILLAGE_CNT = '0'
	                </e:if>
	                <e:if condition="${param.collect_state eq '0' }">
                    AND T2.NO_RES_VILLAGE_CNT = '1'
                    </e:if>
	                <e:if condition="${! empty param.village_name }">
                    AND T1.VILLAGE_NAME like '%${param.village_name }%'
                    </e:if>
	                AND   T1.BRANCH_NO = '${param.substation }'
	                <e:if condition="${! empty param.village_grid_id }">
	                AND T1.GRID_ID_2 = '${param.village_grid_id }'
	                </e:if>

	                ORDER BY
	                <e:if condition="${param.label eq '0' }">
	                PORT_PERCENT_SORT DESC
	                </e:if>
	                <e:if condition="${param.label eq '1' }">
                    PORT_PERCENT_SORT ASC
                    </e:if>
	            ) T
	            )
	            WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:q4l>${e: java2json(village_list.list) }
    </e:case>

    <e:case value="resource_village_empty">
        <e:q4o var="dataObject">
            SELECT
            NVL(TO_CHAR(T2.wj_obd_cnt ), ' ') wj_obd_cnt ,
            NVL(TO_CHAR(T2.wj_zero_obd_cnt ), ' ') wj_zero_obd_cnt ,
            NVL(TO_CHAR(T2.wj_high_use_obd_cnt ), ' ') wj_high_use_obd_cnt ,
            DECODE(NVL(T2.wj_port_id_cnt , 0),
            0,
            ' ',
            TO_CHAR(ROUND(NVL(T2.wj_use_port_cnt , 0) / T2.wj_port_id_cnt ,
            4) * 100,
            'FM990.00') || '%') PORT_PERCENT,
            NVL(TO_CHAR(T2.wj_port_id_cnt ), ' ') wj_port_id_cnt ,
            NVL(TO_CHAR(T2.wj_use_port_cnt ), ' ') wj_use_port_cnt ,
            NVL(TO_CHAR(T2.wj_kong_port_cnt ), ' ') wj_kong_port_cnt ,
            DECODE(NVL(T2.wj_port_id_cnt , 0), 0, '-1', NVL(T2.wj_use_port_cnt , 0) / T2.wj_port_id_cnt  ) PORT_PERCENT_SORT
            FROM ${gis_user}.TB_GIS_RES_info_DAY t2 WHERE flg = '${param.flag}'
            <e:if condition="${!empty param.union_org_code}">
                AND LATN_ID = '${param.union_org_code}'
            </e:if>
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

    <e:case value="resource_village_count">
    <e:q4o var="village_count">
    SELECT
        COUNT(*) C_NUM,
        COUNT(CASE T2.NO_RES_VILLAGE_CNT WHEN 0 THEN 1
              WHEN 1 THEN NULL END) RES_VILLAGE,
        COUNT(CASE T2.NO_RES_VILLAGE_CNT WHEN 0 THEN NULL
              WHEN 1 THEN 1 END) NO_RES_VILLAGE
    FROM
        ${gis_user}.tb_gis_village_edit_info T1
        LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY T2 ON T1.VILLAGE_ID = T2.LATN_ID
    WHERE
        T2.FLG = '5'
        AND   T1.BRANCH_NO = '${param.substation }'
        <e:if condition="${! empty param.village_grid_id }">
        AND T1.GRID_ID_2 = '${param.village_grid_id }'
        </e:if>
       <e:if condition="${! empty param.village_name }">
        AND T1.VILLAGE_NAME like '%${param.village_name }%'
        </e:if>
        <e:if condition="${param.collect_state eq '1' }">
            AND T2.NO_RES_VILLAGE_CNT = '0'
        </e:if>
        <e:if condition="${param.collect_state eq '0' }">
            AND T2.NO_RES_VILLAGE_CNT = '1'
        </e:if>
    </e:q4o>${e: java2json(village_count) }
    </e:case>
    <e:case value="resource_build">
	    <e:q4l var="build_list">
            SELECT * FROM (
            SELECT T.*, ROWNUM ROW_NUM FROM (
               SELECT
                    DECODE(NVL(DIF.PORT_ID_CNT,0), 0, -1, NVL(DIF.USE_PORT_CNT,0) / DIF.PORT_ID_CNT) PORT_PERCENT1,
                    BIF.STAND_NAME STAND_NAME,
                    BIF.SEGM_ID SEGM_ID,
                    NVL(DIF.OBD_CNT,'0') OBD_COUNT,
                    NVL(DIF.ZERO_OBD_CNT,'0') LOW_OBD_COUNT,
                    NVL(DIF.HIGH_USE_OBD_CNT,'0') HIGH_OBD_COUNT,
                    DECODE(NVL(DIF.PORT_ID_CNT,0),0,'--',
                           TO_CHAR(ROUND( NVL(DIF.USE_PORT_CNT,0) / DIF.PORT_ID_CNT, 4) * 100,'FM990.00')
                           || '%') PORT_PERCENT,
                    NVL(DIF.PORT_ID_CNT,0) PORT_SUM,
                    NVL(DIF.KONG_PORT_CNT,0) PORT_FREE_SUM,
                    NVL(DIF.USE_PORT_CNT,0) PORT_USED_SUM
                      FROM
                    SDE.TB_GIS_MAP_SEGM_LATN_MON BIF
                    LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY DIF
                    ON ( BIF.SEGM_ID = DIF.LATN_ID AND DIF.FLG = '6' )
                    WHERE
                    BIF.UNION_ORG_CODE = '${param.substation }'
                    <e:if condition="${param.collect_state eq '1' }">
                    AND DIF.NO_RES_ARRIVE_CNT = '1'
                    </e:if>
                    <e:if condition="${param.collect_state eq '0' }">
                    AND DIF.NO_RES_ARRIVE_CNT = '0'
                    </e:if>
                    <e:if condition="${! empty param.build_grid_id }">
                    AND bif.GRID_ID = '${param.build_grid_id }'
                    </e:if>
                    <e:if condition="${! empty param.build_name }">
                    AND bif.STAND_NAME like '%${param.build_name }%'
                    </e:if>
                     ORDER BY
                    stand_name asc,
                   <e:if condition="${param.label=='0' }">
                   port_percent1 DESC
                    </e:if>
                      <e:if condition="${param.label=='1' }">
                   port_percent1 ASC
                    </e:if>
           ) t )
           WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:q4l>${e: java2json(build_list.list) }
    </e:case>
    <e:case value="resource_build_count">
        <e:q4o var="build_count">
        SELECT
            COUNT(*) C_NUM,
	        COUNT(CASE T2.NO_RES_ARRIVE_CNT WHEN 0 THEN NULL
	              WHEN 1 THEN 1 END) RES_BUILD,
	        COUNT(CASE T2.NO_RES_ARRIVE_CNT WHEN 0 THEN 1
	              WHEN 1 THEN NULL END) NO_RES_BUILD
            FROM
               SDE.TB_GIS_MAP_SEGM_LATN_MON bif
               LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY T2
               ON BIF.SEGM_ID = T2.LATN_ID
           WHERE
               T2.FLG = '6'
               AND bif.union_org_code = '${param.substation }'
               <e:if condition="${! empty param.build_grid_id }">
               AND bif.GRID_ID = '${param.build_grid_id }'
               </e:if>
               <e:if condition="${! empty param.build_name }">
               AND bif.STAND_NAME like '%${param.build_name }%'
               </e:if>
    </e:q4o>${e: java2json(build_count) }
    </e:case>
    <e:description>资源部分 end</e:description>
    <e:description>竞争 begin</e:description>
    <e:case value="info_village_list">
    <e:q4l var="village_list">
	    SELECT T.* FROM(
	        SELECT
	        	vif.branch_no union_org_code,
				vif.branch_name ,
				vif.grid_name ,
				vif.grid_id STATION_ID,
	            vif.village_name,
	            vif.village_id,
	            nvl(dif.ly_cnt,0) build_sum,
	            nvl(dif.gz_zhu_hu_count,0) zhu_hu_sum,
	            DECODE(NVL(dif.gz_zhu_hu_count, 0), 0, '--',
	            TO_CHAR(ROUND(dif.gz_h_use_cnt / dif.gz_zhu_hu_count, 4) * 100, 'FM990.00') || '%') market_penetrance,
	            DECODE(dif.port_id_cnt,0,'--',TO_CHAR(round(dif.use_port_cnt / dif.port_id_cnt,4) * 100,'FM990.00')
	            || '%') port_percent,
                count(1) over() c_num,
	            row_number() over(order by vif.village_name) row_num
	        FROM
	            ${gis_user}.tb_gis_village_edit_info vif
	            LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY dif
	            ON dif.LATN_ID = vif.village_id
	        WHERE
	            vif.branch_no = '${param.substation }'
	            <e:if condition="${! empty param.village_grid_id }">
	                AND vif.GRID_ID_2 = '${param.village_grid_id }'
	            </e:if>
	            <e:if condition="${! empty param.village_name }">
	                AND vif.VILLAGE_NAME like '%${param.village_name }%'
	            </e:if>
                <e:if condition="${!empty param.v_type_span && param.v_type_span > 0}">
                    AND vif.village_label_flg = ${param.v_type_span}
                </e:if>
                <e:if condition="${!empty param.v_type_span && param.v_type_span <= 0}">
                    <e:if condition="${param.v_type_span eq '-1'}">
                        <e:description>白区小区 渗透率小于10%</e:description>
                        and DECODE(NVL(dif.GZ_ZHU_HU_COUNT,0),0,0,NVL(dif.GZ_H_USE_CNT, 0) / dif.GZ_ZHU_HU_COUNT)<0.1
                    </e:if>
                    <e:if condition="${param.v_type_span eq '0'}">
                        <e:description>拔旗小区 没有资源进入</e:description>
                        and nvl(dif.no_res_village_cnt,0)>0
                    </e:if>
                </e:if>
	            ) T
	       WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
	       order by village_name
	    </e:q4l>${e: java2json(village_list.list) }
	</e:case>

    <e:description>资料收集 未建小区</e:description>
    <e:case value="info_village_empty">
        <e:q4o var="dataObject">
            SELECT
            nvl(vif.wj_cnt ,0) build_sum,
            nvl(vif.wj_zhu_hu_count ,0) zhu_hu_sum,
            DECODE(NVL(vif.wj_zhu_hu_count , 0), 0, '--',
            TO_CHAR(ROUND(vif.wj_gz_h_use_cnt  / vif.wj_zhu_hu_count , 4) * 100, 'FM990.00') || '%') market_penetrance,
            DECODE(vif.wj_port_id_cnt ,0,'--',TO_CHAR(round(vif.wj_use_port_cnt  / vif.wj_port_id_cnt ,4) * 100,'FM990.00')
            || '%') port_percent
            FROM ${gis_user}.TB_GIS_RES_INFO_DAY vif
            WHERE FLG = '${param.flag}'
            <e:if condition="${!empty param.union_org_code}">
                AND LATN_ID = '${param.union_org_code}'
            </e:if>
        </e:q4o>${e:java2json(dataObject)}
	</e:case>

	<e:case value="info_village_bsif">
	    <e:q4o var="basic_info">
            SELECT
            NVL(LY_CNT, 0) - NVL(WJ_CNT, 0) BUILD_IN_MAP,
            nvl(wj_cnt,0) build_out_map,
            nvl(village_cnt,0) VILLAGE_IN_MAP
            FROM ${gis_user}.TB_GIS_RES_INFO_DAY
            WHERE LATN_ID = '${param.substation }'
	    </e:q4o>${e: java2json(basic_info) }
	</e:case>

	<e:case value="info_village_count">
	    <e:q4o var="info_village_count">
	    SELECT  DISTINCT C_NUM FROM(
	        SELECT
	            COUNT(*) OVER() C_NUM,
	            ROWNUM ROW_NUM
	        FROM
	            ${gis_user}.tb_gis_village_edit_info
	        WHERE
	            branch_no = '${param.substation }'
	            <e:if condition="${! empty param.village_grid_id }">
	            AND GRID_ID_2 = '${param.village_grid_id }'
	            </e:if>
	            <e:if condition="${! empty param.village_name }">
	            AND VILLAGE_NAME like '%${param.village_name }%'
	            </e:if>
	            ) T
	    </e:q4o>${e: java2json(info_village_count) }
	</e:case>
	<e:case value="info_collect_list">
	   <e:q4l var="collect_list">
	   SELECT * FROM(
	   SELECT T.*, ROWNUM ROW_NUM FROM (
	           SELECT
                c.grid_id,
			    nvl(stand_name_1,'--') stand_name_1,
			    nvl(segm_id_2,'0') segm_id_2,
			    nvl(segm_name_2,'--') segm_name_2,
			    nvl(contact_person,'--')
			    || '<br />'
                <e:description>2018.10.22 号码脱敏</e:description>
			    || decode(contact_nbr,null,'--',nvl((substr(contact_nbr,0,3) || '******' || substr(contact_nbr,10,2)),'--')) connect_info,
			    CASE
			            WHEN kd_business = '1' THEN '移动'
			            WHEN kd_business = '2' THEN '联通'
			            WHEN kd_business = '3' THEN '广电'
			            WHEN kd_business = '4' THEN '其他'
			            WHEN kd_business = '0' THEN '  '
			            ELSE '--'
			        END
			    kd_business,
			    nvl(kd_xf,0) kd_xf,
			    nvl(TO_CHAR(kd_dq_date,'YYYY年MM月DD日'),'--') kd_dq_date
			FROM
			    ${gis_user}.tb_gis_addr_other_all t,
			    sde.tb_gis_map_segm_latn_mon c
			WHERE
			    t.segm_id = c.segm_id
			    <e:if condition="${! empty param.village_name }">
			    AND t.VILLAGE_NAME like '%${param.village_name }%'
			    </e:if>
			    <e:if condition="${! empty param.build_name }">
			    AND t.stand_name_1 like '%${param.build_name }%'
			    </e:if>
			    <e:if condition="${param.collect_state eq '0' }" var="collect">
			    AND ${sql_part_no_collect}
			    </e:if>
			    <e:else condition="${collect }">
                AND ${sql_part_collected}
			    </e:else>
			    <e:if condition="${param.collect_bselect ne '0' }">
			         AND kd_business = '${param.collect_bselect }'
			    </e:if>
			    AND c.union_org_code = '${param.substation }'
		        <e:if condition="${! empty param.village_grid_id }">
		        AND c.GRID_ID = '${param.village_grid_id }'
                </e:if>
                ORDER BY stand_name_1 DESC, segm_name_2 ASC
		) T
		)
		WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
	   </e:q4l>${e: java2json(collect_list.list) }
	</e:case>
	<e:case value="info_collect_count">
	    <e:q4o var="collect_count">
          SELECT
              COUNT(*)  A_COUNT,
           NVL(SUM(DECODE(T.KD_BUSINESS, '1', 1, 0)), 0) Y_COUNT,
           NVL(SUM(DECODE(T.KD_BUSINESS, '2', 1, 0)), 0) L_COUNT,
           NVL(SUM(DECODE(T.KD_BUSINESS, '3', 1, 0)), 0) G_COUNT,
           NVL(SUM(DECODE(T.KD_BUSINESS, '4', 1, 0)), 0) Q_COUNT,
           NVL(SUM(DECODE(T.KD_BUSINESS, '0', 1, 0)), 0) N_COUNT
          FROM
             ${gis_user}.tb_gis_addr_other_all t,
             sde.tb_gis_map_segm_latn_mon c
         WHERE
             t.segm_id = c.segm_id
             <e:if condition="${! empty param.village_name }">
             AND t.VILLAGE_NAME like '%${param.village_name }%'
             </e:if>
             <e:if condition="${! empty param.build_name }">
             AND t.stand_name_1 like '%${param.build_name }%'
             </e:if>
             <e:if condition="${param.collect_state eq '0' }" var="collect">
             AND ${sql_part_no_collect}
             </e:if>
             <e:else condition="${collect }">
             AND ${sql_part_collected}
             </e:else>
             AND c.union_org_code = '${param.substation }'
             <e:if condition="${! empty param.village_grid_id }">
             AND c.GRID_ID = '${param.village_grid_id }'
             </e:if>
	    </e:q4o>${e: java2json(collect_count) }
	</e:case>
	<e:case value="info_collect_bsif">
	   <e:q4o var="collect_bsif">
	       SELECT
			    count_all - count_off count_on,
			    count_off,
			    DECODE(nvl(count_all,0),'0','--',TO_CHAR(round( (count_all - count_off) / count_all,4) * 100,'FM990.00')
			    || '%') collect_percent
			FROM
			    (
			        SELECT
			            count(*) count_all, sum(case when t.kd_business IS NULL
			            OR   t.kd_dq_date IS NULL then 1 else 0 end) count_off
			        FROM
			            ${gis_user}.tb_gis_addr_other_all t,
			            sde.tb_gis_map_segm_latn_mon c
			        WHERE
			            t.segm_id = c.segm_id
			            AND   c.union_org_code = '${param.substation }'
			    )
	   </e:q4o>${e: java2json(collect_bsif) }
	</e:case>
    <e:description>竞争 end</e:description>
    <e:description>支局长部分 end</e:description>
    <e:description>营销部分 begin</e:description>
    <e:description>考核统计 日 已废弃，使用tabData_sandbox_summary_inside_yx中同名方法</e:description>
   <e:case value="marketing_dzr_day">
    <e:q4l var="marketing_dzr_day">
      select * from (
       select ROWNUM ROW_NUM ,A.*
       from(
      (
      select
      '99' order_date,
     decode (count(0),0,'0',count(0) ) total_count,
      nvl(sum(case when t.EXEC_STAT <> 0 then 1 else 0 end),0)||' ' num_1,
      case when count(0) = 0 then '0.00%' else to_char(sum(case when t.EXEC_STAT <> 0 then 1 else 0 end)/count(0)*100,'FM99999999990.00')||'%' end rate_1,
      nvl(sum(case when t.SUCC_FLAG is not null then 1 else 0 end),0)||'' num_2,
      case when count(0) = 0 then '0.00%' else to_char(sum(case when t.SUCC_FLAG is not null then 1 else 0 end)/count(0)*100,'FM99999999990.00')||'%' end rate_2
      from ${sql_part_tab1} t
      where 1=1
      <e:if condition="${!empty param.flag}">
      and t.scene_id='${param.flag}'
      </e:if>
      and t.union_org_code='${param.union_org_code}'
      <e:if condition="${!empty param.grid_id}">
        and t.grid_id = '${param.grid_id}'
      </e:if>
      and substr(t.order_date,1,6)=to_char(sysdate,'yyyymm')
      UNION ALL
      select
      substr(t1.day_code,7,2) order_date,
      decode( count(t2.order_id),0,' ', count(t2.order_id))total_count,
      case when count(t2.order_id)=0 then ' ' else sum(case when t2.EXEC_STAT <> 0 then 1 else 0 end)||'' end num_1,
      case when count(t2.order_id) = 0 then ' ' else to_char(sum(case when t2.EXEC_STAT <> 0 then 1 else 0 end)/count(t2.order_id)*100,'FM99999999990.00')||'%' end rate_1,
      case when count(t2.order_id)=0 then ' ' else sum(case when t2.SUCC_FLAG is not null then 1 else 0 end)||'' end num_2,
      case when count(t2.order_id) = 0 then ' ' else to_char(sum(case when t2.SUCC_FLAG is not null then 1 else 0 end)/count(t2.order_id)*100,'FM99999999990.00')||'%' end rate_2
      from ${gis_user}.tb_dim_time t1
      left join ${sql_part_tab1} t2 on t2.order_date=t1.day_code
      and t2.union_org_code='${param.union_org_code}'
       <e:if condition="${! empty param.flag }">
        and  t2.scene_id='${param.flag}'
       </e:if>
       where 1 = 1
         and t1.day_code between to_char(trunc(sysdate,'MM'),'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')
         group by substr(t1.day_code, 7, 2)
        order by order_date desc)A))

        </e:q4l>
        ${e:java2json(marketing_dzr_day.list) }
    </e:case>
   <e:description>考核统计月 已废弃，现用tabData_sandbox_summary_inside_yx.jsp里的同名方法</e:description>
   <e:case value="marketing_dzr_month">
        <e:q4l var="marketing_dzr_month">
        SELECT * FROM (
         SELECT SUBSTR(T1.DAY_CODE, 1, 6) ORDER_DATE,
          decode( count(t2.order_id),0,' ',count(t2.order_id)) total_count,
          CASE
          WHEN COUNT(T2.ORDER_ID) = 0 THEN
          ' '
          ELSE
          SUM(CASE
          WHEN T2.EXEC_STAT <> 0 THEN
          1
          ELSE
          0
          END) || ''
          END NUM_1,
          CASE
          WHEN COUNT(T2.ORDER_ID) = 0 THEN
          ' '
          ELSE
          TO_CHAR(SUM(CASE
          WHEN T2.EXEC_STAT <> 0 THEN
          1
          ELSE
          0
          END) / COUNT(T2.ORDER_ID) * 100,
          'FM99999999990.00') || '%'
          END RATE_1,
          CASE
          WHEN COUNT(T2.ORDER_ID) = 0 THEN
          ' '
          ELSE
          SUM(CASE
          WHEN T2.SUCC_FLAG IS NOT NULL THEN
          1
          ELSE
          0
          END) || ''
          END NUM_2,
          CASE
          WHEN COUNT(T2.ORDER_ID) = 0 THEN
          ' '
          ELSE
          TO_CHAR(SUM(CASE
          WHEN T2.SUCC_FLAG IS NOT NULL THEN
          1
          ELSE
          0
          END) / COUNT(T2.ORDER_ID) * 100,
          'FM99999999990.00') || '%'
          END RATE_2
          FROM ${gis_user}.TB_DIM_TIME T1
          LEFT JOIN (
                     SELECT ORDER_ID,EXEC_STAT,SUCC_FLAG,ORDER_DATE,UNION_ORG_CODE,SCENE_ID FROM ${sql_part_tab1}
                     UNION ALL
                     SELECT ORDER_ID,EXEC_STAT,SUCC_FLAG,ORDER_DATE,UNION_ORG_CODE,SCENE_ID FROM ${gis_user}.TB_MKT_ORDER_LIST_HIS
          ) T2
          ON T2.ORDER_DATE = T1.DAY_CODE
          AND T2.UNION_ORG_CODE = '${param.union_org_code}'
           <e:if condition="${! empty param.flag }">
                 and t2.scene_id='${param.flag}'
           </e:if>
          WHERE 1 = 1
          AND T1.MONTH_CODE BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMM') AND
          TO_CHAR(SYSDATE, 'YYYYMM')
          GROUP BY SUBSTR(T1.DAY_CODE, 1, 6)
          ORDER BY ORDER_DATE DESC)
          WHERE  ORDER_DATE BETWEEN '${param.begin_mon}'  AND  '${param.end_mon}'
        </e:q4l>${e: java2json(marketing_dzr_month.list) }
    </e:case>

     <e:case value="marketing_sence_num">
        <e:q4l var="marketing_sence_num">
          SELECT 'D' dateType,count(case when t2.scene_id='10' then t2.order_id end ) dr_num,
  		  count(case when t2.scene_id='11' then t2.order_id end ) xy_num,
  		  count(case
               when t2.scene_id = '12' then
                t2.order_id
             end)cmhx_num,
            COUNT( t2.order_id) sum_Num
  		   FROM ${sql_part_tab1} t2
		  where t2.union_org_code='${param.union_org_code}'
		  and t2.ORDER_DATE = to_char(sysdate,'yyyymmdd')
		  union all
		  SELECT 'M' dateType,count(case when t2.scene_id='10' then t2.order_id end ) dr_num,
		  count(case when t2.scene_id='11' then t2.order_id end ) xy_num,
		  count(case
               when t2.scene_id = '12' then
                t2.order_id
             end)cmhx_num,
            COUNT (t2.order_id) sum_num
		  FROM ${sql_part_tab1} t2,${gis_user}.TB_DIM_TIME t1
		  where t2.union_org_code='${param.union_org_code}'
		        and t2.order_date=t1.day_code
		        and t1.month_code = TO_CHAR(SYSDATE, 'YYYYMM')
            <e:description>
            between TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMM') AND
		  TO_CHAR(SYSDATE, 'YYYYMM')
            </e:description>
        </e:q4l>${e: java2json(marketing_sence_num.list) }
    </e:case>
    <e:case value="intraday_num">
        <e:q4l var="intraday_num">
            <e:if condition="${empty param.intraday_sence_id}">
            SELECT '0' MKT_ID,'全部' MKT_NAME, COUNT(T.ORDER_ID) MKT_CNT
            FROM ${sql_part_tab1} T
            WHERE T.EXEC_STAT = 0
            AND T.UNION_ORG_CODE = '${param.union_org_code}'
            AND T.ORDER_DATE = TO_CHAR(SYSDATE, 'YYYYMMDD')
            UNION ALL
            </e:if>
            SELECT A.MKT_ID, A.MKT_NAME, COUNT(O_CNT) MKT_CNT
            FROM ${sql_part_tab} A
            LEFT JOIN (SELECT T.SCENE_ID, COUNT(T.ORDER_ID) O_CNT
            FROM ${sql_part_tab1} T
            WHERE T.EXEC_STAT = 0
            AND T.UNION_ORG_CODE = '${param.union_org_code}'
            AND T.ORDER_DATE = TO_CHAR(SYSDATE, 'YYYYMMDD')
            GROUP BY T.SCENE_ID, T.ORDER_ID) B
            ON A.MKT_ID = B.SCENE_ID
            <e:if condition="${!empty param.intraday_sence_id}">
                where scene_id = '${param.intraday_sence_id}'
            </e:if>
            GROUP BY MKT_ID, MKT_NAME
        </e:q4l>${e: java2json(intraday_num.list) }
    </e:case>
    <e:case value="track_mun">
        <e:q4l var="track_mun">
        SELECT NVL(SUM(COUNT(DECODE(EXEC_STAT, 1, T.ORDER_ID))), 0) EXEC1,
		       NVL(SUM(COUNT(DECODE(EXEC_STAT, 2, T.ORDER_ID))), 0) EXEC2,
		       NVL(SUM(COUNT(DECODE(EXEC_STAT, 3, T.ORDER_ID))), 0) EXEC3,
		       NVL(SUM(COUNT(DECODE(EXEC_STAT, 4, T.ORDER_ID))), 0) EXEC4
		  FROM ${sql_part_tab1} T
            <e:description>
		  right join ${sql_part_tab} T2
		    ON T2.MKT_ID = T.SCENE_ID
            </e:description>
		 WHERE T.UNION_ORG_CODE = '${param.union_org_code}'
		   AND T.ORDER_DATE LIKE TO_CHAR(SYSDATE, 'yyyymm') || '%'
		 GROUP BY SUBSTR(T.ORDER_DATE, 1, 6)
        </e:q4l>${e: java2json(track_mun.list) }
    </e:case>
    <e:case value="succ_num">
        <e:q4l var="succ_num">
    select count(1) num
    from (select count(t.order_id)
            from  ${sql_part_tab1} t
            <e:description>
            right join ${sql_part_tab} t2
              on t2.MKT_ID = t.scene_id
            </e:description>
           where 1 = 1
             and t.union_org_code = '${param.union_org_code}'
             and t.order_date like to_char(sysdate,'yyyymm')||'%'
             and succ_flag = '1'
           group by order_id)
        </e:q4l>${e: java2json(succ_num.list) }
    </e:case>

    <e:case value="marketing_warning">
        <e:q4l var="warning_list">
        SELECT * FROM(
			SELECT
                <e:description>脱敏</e:description>
                case when CONTACT_PERSON='--' then contact_person
                when CONTACT_PERSON=' ' then CONTACT_PERSON
                else substr(CONTACT_PERSON,1,1)||'**' end contact_person,
                STAND_NAME_2,
                SEGM_ID_2,
                KD_BUSINESS,
                contact_nbr,
                KD_DQ_DATE,
                ROWNUM ROW_NUM
			FROM
			    (
			    SELECT
                  NVL(T.CONTACT_PERSON,'--') CONTACT_PERSON,
                  NVL(T.STAND_NAME_2,'--') STAND_NAME_2,
                  T.SEGM_ID_2,
                  CASE
                          WHEN T.KD_BUSINESS = '1' THEN '移动'
                          WHEN T.KD_BUSINESS = '2' THEN '联通'
                          WHEN T.KD_BUSINESS = '3' THEN '广电'
                          WHEN T.KD_BUSINESS = '4' THEN '其他'
                          WHEN T.KD_BUSINESS = '0' THEN '  '
                          ELSE '--'
                  END KD_BUSINESS,
                  decode(contact_nbr,null,' ',substr(contact_nbr,0,3)||'******'||substr(contact_nbr,10,2)) contact_nbr,
                  case when t.KD_DQ_DATE is null then ' ' else to_char(t.KD_DQ_DATE,'YYYY-MM-DD') end KD_DQ_DATE
              FROM
                  ${gis_user}.TB_GIS_ADDR_OTHER_ALL T,
                  SDE.TB_GIS_MAP_SEGM_LATN_MON C
              WHERE
                  T.SEGM_ID = C.SEGM_ID
                  AND (TO_CHAR(T.KD_DQ_DATE, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM') OR TO_CHAR(T.KD_DQ_DATE, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE,1), 'YYYYMM'))
                  AND T.KD_BUSINESS <> '5'
                  AND C.UNION_ORG_CODE ='${param.substation }'
              ORDER BY
              T.KD_DQ_DATE ASC NULLS LAST
			    ) T
			)
			WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:q4l>${e: java2json(warning_list.list) }
    </e:case>
    <e:case value="marketing_warning_count">
        <e:q4l var="warning_count">
             SELECT
                 COUNT(*) C_NUM
             FROM
                 ${gis_user}.TB_GIS_ADDR_OTHER_ALL T,
                 SDE.TB_GIS_MAP_SEGM_LATN_MON C
             WHERE
                 T.SEGM_ID = C.SEGM_ID
                 AND (TO_CHAR(T.KD_DQ_DATE, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM') OR TO_CHAR(T.KD_DQ_DATE, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'YYYYMM'))
                 AND T.KD_BUSINESS <> '5'
                 AND C.UNION_ORG_CODE = '${param.substation }'
        </e:q4l>${e: java2json(warning_count.list) }
    </e:case>

    <e:description>营销清单、转派清单</e:description>
    <e:case value="marketing_intraday">
        <e:q4l var="dataList">
         SELECT T.* FROM(
        select
          t.address_id,
          ROWNUM ROW_NUM,
	      t.prod_inst_id,
	      t.order_id,
	      nvl(t.contact_tel,' ') contact_tel,
	      nvl(t.acc_nbr,' ') acc_nbr,
            <e:description>脱敏</e:description>
          decode(T.SERV_NAME,NULL,' ', SUBSTR(NVL(T.SERV_NAME, ' '), 1, 1) || '**')SERV_NAME,
          decode(t.scene_id,10,'ren','11','sin',' ') scene_id_crm,
          t.scene_id scene_id_num,
          <e:description>
	      decode(t.scene_id,10,'单转融',11,'协议到期',12，'沉默激活',13,'欠费1-3月',14,'欠费三个月以上',15,'余额不足',' ') as scene_id,
          t2.mkt_name scene_name,
          </e:description>
          T.MKT_CONTENT SCENE_NAME,
	      t.mkt_content,
	      nvl(t.mkt_reason,' ') mkt_reason,
	      nvl(t.contact_adds,' ') contact_adds,
	      t.order_date,
          t.grid_id,
          t.mkt_carcate_id,
          t.accept_type,
          t.contact_chl_id,
          t.contact_chl_name,
          nvl(t.PROD_OFFER_ID,0) PROD_OFFER_ID,
          nvl(t.PROD_OFFER_NAME,' ') PROD_OFFER_NAME,
          count(1) over() c_num
      from
            <e:description>
            EDW.TB_MKT_ORDER_LIST@GSEDW t
      right join ${sql_part_tab} t2
            on t2.MKT_ID=t.scene_id
            </e:description>
            ${sql_part_tab1} t
      where t.exec_stat = 0
        and t.succ_flag = 0
        and t.union_org_code='${param.union_org_code}'
          <e:if condition="${!empty param.intraday_sence_id}" var="empty_scene_id">
            and t.scene_id = '${param.intraday_sence_id}'
          </e:if>
          <e:else condition="${empty_scene_id}">
              <e:if condition="${param.is_zhuanpai eq '1'}" >
                  <e:description>and t.scene_id = '999'</e:description>
                  and t.flag = '0'
              </e:if>
              <e:if condition="${param.is_zhuanpai eq '2'}">
                  <e:description>and t.scene_id <> '999'</e:description>
                  and t.flag = '2'
              </e:if>
              <e:if condition="${param.is_zhuanpai eq '3'}">
                  <e:description>and t.scene_id <> '999'</e:description>
                  and t.flag = '1'
              </e:if>
          </e:else>
          <e:if condition="${!empty param.intraday_query_text}">
            and (t.serv_name like '%${param.intraday_query_text}%' or t.contact_tel like '%${param.intraday_query_text}%' or t.ACC_NBR like '%${param.intraday_query_text}%')
          </e:if>
          <e:description>非转派场景，即scene_id不等于999</e:description>
          <e:description>
              当日派单 20190516日改为取月数据口径
          and t.order_date=to_char(sysdate,'YYYYMMDD')
          </e:description>
        and t.order_date = to_char(sysdate,'YYYYMM')
       ) T
	  WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
       order by t.grid_id asc
       </e:q4l> ${e: java2json(dataList.list) }
    </e:case>
  <e:case value="marketing_track">
    <e:q4l var="dataList">
    select * from(
        select A.*,ROWNUM ROW_NUM from (
        select
     	  nvl(t.contact_adds,' ') CONTACT_ADDS,
          <e:description>脱敏</e:description>
          decode(T.SERV_NAME,NULL,' ', SUBSTR(NVL(T.SERV_NAME, ' '), 1, 1) || '**')SERV_NAME,
          nvl(t.contact_tel,' ') contact_tel,
          nvl(t.acc_nbr,' ') acc_nbr,
          decode(t.scene_id,10,'ren','11','sin',' ') scene_id_crm,
		  t.order_id,
          <e:description>脱敏
          substr(t.contact_contperson,1,1)||'**' contact_contperson,
          </e:description>
		  t.scene_id,
          <e:description>
		  t2.mkt_name scene_name,
          </e:description>
          t.mkt_content scene_name,
		  t.mkt_content,
          nvl(t.mkt_reason,' ') mkt_reason,
		  t.order_date,
          T.PROD_INST_ID,
          t.address_id,
          t.scene_id scene_id_num,
		  case when t.EXEC_TIME is null then ' ' else to_char(t.EXEC_TIME,'YYYY-MM-DD') end EXEC_TIME,
		  nvl(t.exec_desc,' ') exec_desc,
          t.mkt_carcate_id,
          t.accept_type,
          t.contact_chl_id,
          t.contact_chl_name,
          t.PROD_OFFER_ID,
          t.PROD_OFFER_NAME,
          count(1) over() c_num
        from ${sql_part_tab1} t
            <e:description>
        right join ${sql_part_tab} t2 on t2.MKT_ID=t.scene_id
            </e:description>
        where 1=1
            and t.union_org_code='${param.union_org_code}'
            and t.order_date = to_char(sysdate,'yyyymm')
        <e:if condition="${!empty param.scene_id}" var="empty_scene_id">
            and t.scene_id = ${param.scene_id}
        </e:if>
        <e:else condition="${empty_scene_id}">
            and t.scene_id <> '999'
        </e:else>
        <e:if condition="${!empty param.query_text}">
            and (t.serv_name like '%${param.query_text}%' or t.ACC_NBR like '%${param.query_text}%')
        </e:if>
        <e:if condition="${!empty param.exec_stat}" var="one_stat">
            and t.exec_stat = ${param.exec_stat}
        </e:if>
        <e:else condition="${one_stat}">
            and t.exec_stat <> 0
        </e:else>
        order by t.exec_time desc)A
        )
        where
        ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:q4l>${e: java2json(dataList.list)}
    </e:case>
    <e:case value="marketing_succ">
        <e:q4l var="marketing_succ">
        select * from(
            select A.*,ROWNUM ROW_NUM from (
         select
             nvl( t.succ_business, ' ') succ_business,
              case when t.succ_time is null then ' ' else to_char(t.succ_time,'YYYY-MM-DD') end succ_time,
              t.order_id,
              t.acc_nbr,
              decode(T.SERV_NAME,NULL,' ', SUBSTR(NVL(T.SERV_NAME, ' '), 1, 1) || '**')SERV_NAME,
              <e:description>
              t.contact_contperson,
              </e:description>
              t.scene_id,
            <e:description>
              t2.mkt_name scene_name,
            </e:description>
              t.mkt_content scene_name,
              t.mkt_content,
              nvl(t.mkt_reason,' ') mkt_reason,
              t.order_date,
              case when t.EXEC_TIME is null then ' ' else to_char(t.EXEC_TIME,'YYYY-MM-DD') end EXEC_TIME,
              t.exec_desc,
              count(1) over() c_num
        from ${sql_part_tab1}    t
            <e:description>
        right join ${sql_part_tab} t2 on t2.MKT_ID=t.scene_id
            </e:description>
        where 1=1
            and t.union_org_code='${param.union_org_code}'
            and t.order_date = to_char(sysdate,'yyyymm')
            and succ_flag='${param.succ_flag}'
            <e:if condition="${!empty param.scene_id}" var="empty_scene_id">
                and t.scene_id = ${param.scene_id}
            </e:if>
            <e:else condition="${empty_scene_id}">
                and t.scene_id <> '999'
            </e:else>
            <e:if condition="${!empty param.query_text}">
                and (t.serv_name like '%${param.query_text}%' or t.ACC_NBR like '%${param.query_text}%')
            </e:if>
        order by t.succ_time desc)A
        )
        where
        ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:q4l>${e: java2json(marketing_succ.list) }
    </e:case>
    <e:description>营销部分 end</e:description>
    <e:case value="collect_new_village_list">
	    <e:q4l var="village_list">
	    SELECT
	        VILLAGE_ID,
	        VILLAGE_NAME
	    FROM
	         ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO VIF
	    WHERE 1=1
        <e:if condition="${! empty param.substation }">
           and VIF.BRANCH_NO = ${param.substation }
        </e:if>

	    <e:if condition="${! empty param.grid_id }">
	       AND GRID_ID_2 = '${param.grid_id }'
	    </e:if>
	    ORDER BY VILLAGE_NAME DESC
	    </e:q4l>${e: java2json(village_list.list) }
    </e:case>
    <e:case value="collect_new_build_list">
        <e:if condition="${! empty param.village_id }" var="notAll">
            <e:q4l var="build_list">
                SELECT
                    mas.resfullname STAND_NAME,
                    mas.resid SEGM_ID
                FROM
                    ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO VIF
                    LEFT OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_ADDR4 BVF
                    ON BVF.VILLAGE_ID = VIF.VILLAGE_ID,
                    ${param.table_name} mas
		        WHERE VIF.BRANCH_NO = '${param.substation }'
                      AND mas.resid = bvf.segm_id
		        <e:if condition="${! empty param.grid_id }">
		           AND GRID_ID_2 = '${param.grid_id }'
		        </e:if>
		        <e:if condition="${! empty param.village_id }">
		           AND VIF.VILLAGE_ID = '${param.village_id }'
		        </e:if>
		        ORDER BY STAND_NAME ASC
		    </e:q4l>
        </e:if>
        <e:else condition="${notAll }">
            <e:q4l var="build_list">
                SELECT A.resid SEGM_ID,
	                A.resfullname STAND_NAME
	            FROM ${param.table_name} A
                where 1=1
                <e:if condition='${!empty param.substation }'>
                   AND UNION_ORG_CODE = '${param.substation }'
                </e:if>
                <e:if condition="${! empty param.grid_id }">
                   AND GRID_ID = '${param.grid_id }'
                </e:if>
                ORDER BY STAND_NAME ASC
            </e:q4l>
        </e:else>${e: java2json(build_list.list) }
    </e:case>
    <e:case value="collect_new_build_info">
       <e:q4l var="build_list">
            SELECT
			    NVL(O.STAND_NAME_1,' ') STAND_NAME_1,
			    NVL(O.SEGM_ID_2,' ') SEGM_ID_2,
			    NVL(O.SEGM_NAME_2,'  ') SEGM_NAME_2,
                <e:description>脱敏</e:description>
                case when O.CONTACT_PERSON = '未装' then O.CONTACT_PERSON
                when NVL(O.CONTACT_PERSON,' ') = ' ' then ' '
			    else substr(NVL(O.CONTACT_PERSON,' '),1,1)||'**' end
			    || '<br />'
                <e:description>2018.10.22 号码脱敏</e:description>
			    || decode(O.CONTACT_NBR,null,' ',nvl((substr(O.CONTACT_NBR,0,3) || '******' || substr(O.CONTACT_NBR,10,2)),'--')) CONNECT_INFO,
               CASE
               WHEN nvl(O.IS_KD_DX,0) = '0' THEN
               CASE
               WHEN O.KD_BUSINESS = '1' THEN
               '移动'
               WHEN O.KD_BUSINESS = '2' THEN
               '联通'
               WHEN O.KD_BUSINESS = '3' THEN
               '广电'
               WHEN O.KD_BUSINESS = '4' THEN
               '其他'
               WHEN O.KD_BUSINESS = '0' THEN
               '  '
               ELSE
               '  '
               END
               WHEN O.IS_KD_DX > 0 THEN
               '电信'
               END KD_BUSINESS,
               CASE
               WHEN O.IS_KD_DX > 0 THEN
               1
               ELSE
               0
               END IS_DX,
               O.IS_KD_DX,
			   NVL(O.KD_XF, '  ') KD_XF,
               <e:description>到期时间↓</e:description>
               ${sql_part_dqsj}
               <e:description>到期时间↑</e:description>
               CASE
               WHEN nvl(O.IS_ITV_DX,0) = '0' THEN
               CASE
               WHEN O.ITV_BUSINESS = '1' THEN
               '移动'
               WHEN O.ITV_BUSINESS = '2' THEN
               '联通'
               WHEN O.ITV_BUSINESS = '3' THEN
               '广电'
               WHEN O.ITV_BUSINESS = '4' THEN
               '其他'
               WHEN O.ITV_BUSINESS = '0' THEN
               '  '
               ELSE
               '  '
               END
               WHEN O.IS_ITV_DX > 0 THEN
               '电信'
               END ITV_BUSINESS,
                NVL(O.ITV_XF, '  ') ITV_XF,
                NVL(TO_CHAR(O.ITV_DQ_DATE,'YYYY-MM-DD'),'  ') ITV_DQ_DATE,
                nvl(O.serial_no,'0') serial_no
			FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL O
			WHERE
            O.SEGM_ID = '${param.build_id }'
            and O.SEGM_ID_2 is not null
           <e:if condition="${param.collect_bselect ne '-1' }">
               <e:if condition="${param.collect_bselect eq '5' }" var="is_dx">
                   AND is_kd_dx>0
               </e:if>
               <e:else condition="${is_dx }">
                   AND KD_BUSINESS = '${param.collect_bselect }'
               </e:else>
           </e:if>
           <e:switch value="${param.collect_state }">
               <e:case value="1">
                   <e:description>未收集</e:description>
                   and ${sql_part_no_collect}
               </e:case>
               <e:case value="2">
                   <e:description>已收集</e:description>
                   AND ${sql_part_collected}
               </e:case>
           </e:switch>
             ORDER BY stand_name_1 ASC, length(segm_name_2)asc,segm_name_2 ASC
       </e:q4l>${e: java2json(build_list.list) }
    </e:case>
    <e:case value="collect_new_count">
        <e:q4o var="collect_count">
            SELECT COUNT(*) A_COUNT,
            ${sql_part_collect_cnt},
            ${sql_part_buss_cnt}
            FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL O
            WHERE O.SEGM_ID = '${param.build_id }'
            AND O.SEGM_ID_2 IS NOT NULL
        </e:q4o>${e: java2json(collect_count) }
    </e:case>
    <e:case value="collect_new_bsif">
       <e:q4o var="collect_bsif">
            SELECT
			NVL(TO_CHAR(VILLAGE_CNT), '--') V_COUNT,
			NVL(TO_CHAR(LY_CNT), '--') B_COUNT,
			NVL(TO_CHAR(GZ_ZHU_HU_COUNT), '--') R_COUNT,
			NVL(TO_CHAR(SHOULD_COLLECT_CNT), '--') A_COUNT,
			NVL(TO_CHAR(ALREADY_COLLECT_CNT), '--') ON_COUNT,
			DECODE(NVL(SHOULD_COLLECT_CNT, 0), 0, '--',
			TO_CHAR(ROUND(NVL(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT, 4) * 100, 'FM99999990.00') || '%') C_RATE
			FROM ${gis_user}.TB_GIS_RES_INFO_DAY
			WHERE LATN_ID = '${param.substation }'
       </e:q4o>${e: java2json(collect_bsif) }
    </e:case>
    <e:description>新功能添加(new) start</e:description>
    <e:case value="market_village_name_list">
        <e:q4l var="village_list">
        SELECT VILLAGE_ID, VILLAGE_NAME
        FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
        WHERE BRANCH_NO = '${param.substation }'
        <e:if condition="${! empty param.grid_id }">
        AND GRID_ID_2 = '${param.grid_id }'
        </e:if>
        </e:q4l>${e: java2json(village_list.list) }
    </e:case>
    <e:description>新功能添加(new) end</e:description>
    <e:description>存量维系 start</e:description>
    <e:case value="stock_grid">
    <e:q4l var="grid_list">
    <%-- 合计暂时无法求取 --%>
    <%-- SELECT '合计' GRID_NAME,
       DECODE(NVL(BY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(BY_CNT, 0) / BY_ALL_CNT, 4) * 100, 'FM990.00') || '%') BY_RATE,
       DECODE(NVL(ACTIVE_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT, 4) * 100, 'FM990.00') || '%') ACTIVE_RATE,
       DECODE(NVL(XY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(XY_CNT, 0) / XY_ALL_CNT, 4) * 100, 'FM990.00') || '%') XY_RATE,
       DECODE(NVL(LW_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(LW_CNT, 0) / LW_ALL_CNT, 4) * 100, 'FM990.00') || '%') LW_RATE
    FROM ${gis_user}.TB_GIS_RES_INFO_DAY
    WHERE LATN_ID = '${param.substation }'
    UNION ALL --%>
    SELECT
       A.GRID_NAME,
       DECODE(NVL(B.BY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(BY_CNT, 0) / B.BY_ALL_CNT, 4) * 100, 'FM990.00') || '%') BY_RATE,
       DECODE(NVL(B.ACTIVE_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / B.ACTIVE_ALL_CNT, 4) * 100, 'FM990.00') || '%') ACTIVE_RATE,
       DECODE(NVL(B.XY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(XY_CNT, 0) / B.XY_ALL_CNT, 4) * 100, 'FM990.00') || '%') XY_RATE,
       DECODE(NVL(B.LW_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(LW_CNT, 0) / B.LW_ALL_CNT, 4) * 100, 'FM990.00') || '%') LW_RATE
	FROM ${gis_user}.DB_CDE_GRID A
	LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY B
	ON A.GRID_ID = B.LATN_ID
	WHERE A.UNION_ORG_CODE = '${param.substation }'
	AND A.GRID_STATUS = '1'
    AND A.GRID_UNION_ORG_CODE <> '-1'
    </e:q4l>${e: java2json(grid_list.list) }
</e:case>
    <e:case value="stock_grid_count">
    <e:q4o var="grid_count">
    SELECT COUNT(*) C_NUM
    FROM ${gis_user}.DB_CDE_GRID A
    LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY B
    ON A.GRID_ID = B.LATN_ID
    WHERE A.UNION_ORG_CODE = '${param.substation }'
    AND A.GRID_STATUS = '1'
    AND A.GRID_UNION_ORG_CODE <> '-1'
    </e:q4o>${e: java2json(grid_count) }
</e:case>

    <e:case value="stock_village">
    <e:q4l var="village_list">
    <%-- 合计暂时无法求取 --%>
    <%-- <e:if condition="${param.page eq '0' }">
    SELECT '合计' VILLAGE_NAME,
       DECODE(NVL(BY_ALL_CNT, '0'),
              '0',
              '--',
              TO_CHAR(ROUND(NVL(BY_CNT, 0) / BY_ALL_CNT, 4) * 100,
                      'FM990.00') || '%') BY_RATE,
       DECODE(NVL(ACTIVE_ALL_CNT, '0'),
              '0',
              '--',
              TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT, 4) * 100,
                      'FM990.00') || '%') ACTIVE_RATE,
       DECODE(NVL(XY_ALL_CNT, '0'),
              '0',
              '--',
              TO_CHAR(ROUND(NVL(XY_CNT, 0) / XY_ALL_CNT, 4) * 100,
                      'FM990.00') || '%') XY_RATE,
       DECODE(NVL(LW_ALL_CNT, '0'),
              '0',
              '--',
              TO_CHAR(ROUND(NVL(LW_CNT, 0) / LW_ALL_CNT, 4) * 100,
                      'FM990.00') || '%') LW_RATE,
       ROWNUM ROW_NUM
    FROM (SELECT SUM(NVL(B.BY_ALL_CNT, '0')) BY_ALL_CNT,
               SUM(NVL(B.BY_CNT, '0')) BY_CNT,
               SUM(NVL(B.ACTIVE_ALL_CNT, '0')) ACTIVE_ALL_CNT,
               SUM(NVL(B.ACTIVE_CNT, '0')) ACTIVE_CNT,
               SUM(NVL(B.XY_ALL_CNT, '0')) XY_ALL_CNT,
               SUM(NVL(B.XY_CNT, '0')) XY_CNT,
               SUM(NVL(B.LW_ALL_CNT, '0')) LW_ALL_CNT,
               SUM(NVL(B.LW_CNT, '0')) LW_CNT
          FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A
          LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY B
            ON A.VILLAGE_ID = B.LATN_ID
         WHERE A.BRANCH_NO = '${param.substation }'
         <e:if condition="${! empty param.grid_id }">
         AND A.GRID_ID_2 = '${param.grid_id }'
         </e:if>
         <e:if condition="${! empty param.village_name }">
         AND A.VILLAGE_NAME LIKE '%${param.village_name }%'
         </e:if>
         )
    UNION ALL
    </e:if> --%>
    SELECT * FROM(
    SELECT T.*, ROWNUM ROW_NUM FROM(
    SELECT
       A.VILLAGE_ID,
       A.VILLAGE_NAME,
       DECODE(NVL(B.BY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(BY_CNT, 0) / B.BY_ALL_CNT, 4) * 100, 'FM990.00') || '%') BY_RATE,
       DECODE(NVL(B.ACTIVE_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / B.ACTIVE_ALL_CNT, 4) * 100, 'FM990.00') || '%') ACTIVE_RATE,
       DECODE(NVL(B.XY_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(XY_CNT, 0) / B.XY_ALL_CNT, 4) * 100, 'FM990.00') || '%') XY_RATE,
       DECODE(NVL(B.LW_ALL_CNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(LW_CNT, 0) / B.LW_ALL_CNT, 4) * 100, 'FM990.00') || '%') LW_RATE,
       branch_no union_org_code,
	   branch_name ,
	   grid_name ,
	   grid_id STATION_ID
      FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A
	  LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY B
	  ON A.VILLAGE_ID = B.LATN_ID
	  WHERE A.BRANCH_NO = '${param.substation }'
	  <e:if condition="${! empty param.grid_id }">
	  AND A.GRID_ID_2 = '${param.grid_id }'
	  </e:if>
	  <e:if condition="${! empty param.village_name }">
	  AND A.VILLAGE_NAME LIKE '%${param.village_name }%'
	  </e:if>
	  ) T
	  )
	  WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
    </e:q4l>${e: java2json(village_list.list) }
</e:case>
    <e:case value="stock_village_count">
    <e:q4o var="village_count">
    SELECT COUNT(*) C_NUM
    FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO A
    LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY B
    ON A.VILLAGE_ID = B.LATN_ID
    WHERE A.BRANCH_NO = '${param.substation }'
    <e:if condition="${! empty param.grid_id }">
    AND A.GRID_ID_2 = '${param.grid_id }'
    </e:if>
    <e:if condition="${! empty param.village_name }">
    AND A.VILLAGE_NAME LIKE '%${param.village_name }%'
    </e:if>
    </e:q4o>${e: java2json(village_count) }
</e:case>
    <e:description>存量维系  end</e:description>
    <e:description>首页信息加载  end</e:description>

    <e:description>obd 网格</e:description>
    <e:case value="obd_grid">
    <e:q4l var="dataList">
        select * from(
            select A.*,ROWNUM ROW_NUM from (
                SELECT A.GRID_NAME,
                T.GRID_ID,
                SUBSTR(T.EQP_NO, 0, 5) || '***' || SUBSTR(T.EQP_NO, 20) EQP_ID1,
                t.EQP_NO EQP_ID,
                round(nvl(USER_PORT_RATE,0),4)*100 USER_PORT_RATE,
                PORT_ID_CNT,
                USE_PORT_CNT,
                DECODE(ZE_PORT_FLG, '0', ' ', '1', '是') ZE_TEXT,
                DECODE(FI_PORT_FLG, '0', ' ', '1', '是') FI_TEXT
                FROM ${gis_user}.TB_GIS_ODB_EQP_GRID_DAY T,
                ${gis_user}.DB_CDE_GRID A
                WHERE T.GRID_ID = A.GRID_ID
                <e:if condition="${!empty param.substation}">
                    AND a.UNION_ORG_CODE = '${param.substation}'
                </e:if>
                <e:if condition="${!empty param.grid_id_short}">
                    AND a.grid_id = '${param.grid_id_short}'
                </e:if>
                <e:if condition="${!empty param.zy}">
                    <e:if condition="${param.zy eq '1'}">
                        and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
                    </e:if>
                    <e:if condition="${param.zy eq '3'}">
                        ${sql_part_where}
                    </e:if>
                </e:if>
                order by grid_name
            )A
        )
        where
            ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

    <e:case value="obd_grid_count">
      <e:q4o var="dataObject">
          SELECT count(1) cnt
          FROM ${gis_user}.TB_GIS_ODB_EQP_GRID_DAY T,
          ${gis_user}.DB_CDE_GRID A
          WHERE T.GRID_ID = A.GRID_ID
          <e:if condition="${!empty param.substation}">
              AND a.UNION_ORG_CODE = '${param.substation}'
          </e:if>
          <e:if condition="${!empty param.grid_id_short}">
              AND a.grid_id = '${param.grid_id_short}'
          </e:if>
          <e:if condition="${!empty param.zy}">
              <e:if condition="${param.zy eq '1'}">
                  and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
              </e:if>
              <e:if condition="${param.zy eq '3'}">
                  ${sql_part_where}
              </e:if>
          </e:if>
      </e:q4o>${e:java2json(dataObject)}
  </e:case>

    <e:case value="obd_type_cnt_grid">
        <e:q4o var="dataObject">
            SELECT
            ${sql_part}
            FROM ${gis_user}.TB_GIS_ODB_EQP_GRID_DAY T,
            ${gis_user}.DB_CDE_GRID A
            WHERE T.GRID_ID = A.GRID_ID
            <e:if condition="${!empty param.substation}">
                AND a.UNION_ORG_CODE = '${param.substation}'
            </e:if>
            <e:if condition="${!empty param.grid_id_short}">
                AND a.grid_id = '${param.grid_id_short}'
            </e:if>
            <e:if condition="${!empty param.zy}">
                <e:if condition="${param.zy eq '1'}">
                    and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
                </e:if>
                <e:if condition="${param.zy eq '3'}">
                    ${sql_part_where}
                </e:if>
            </e:if>
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

    <e:description>obd 小区</e:description>
    <e:case value="obd_village">
    <e:q4l var="dataList">
        select * from(
            select A.*,ROWNUM ROW_NUM from (
                SELECT A.village_name,
                a.village_id,
                SUBSTR(T.EQP_NO, 0, 5) || '***' || SUBSTR(T.EQP_NO, 20) EQP_ID1,
                t.EQP_NO EQP_ID,
                round(nvl(USER_PORT_RATE,0),4)*100 USER_PORT_RATE,
                PORT_ID_CNT,
                USE_PORT_CNT,
                DECODE(ZE_PORT_FLG, '0', ' ', '1', '是') ZE_TEXT,
                DECODE(FI_PORT_FLG, '0', ' ', '1', '是') FI_TEXT
                FROM ${gis_user}.TB_GIS_ODB_EQP_VILLAGE_DAY T,
                ${gis_user}.tb_gis_village_edit_info a
                WHERE t.village_id = a.village_id
                <e:if condition="${!empty param.substation}">
                    AND a.branch_no = '${param.substation}'
                </e:if>
                <e:if condition="${!empty param.grid_id_short}">
                    AND a.grid_id_2 = '${param.grid_id_short}'
                </e:if>
                <e:if condition="${!empty param.village_id}">
                    AND a.village_id = '${param.village_id}'
                </e:if>
                <e:if condition="${!empty param.zy}">
                    <e:if condition="${param.zy eq '1'}">
                        and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
                    </e:if>
                    <e:if condition="${param.zy eq '3'}">
                        ${sql_part_where}
                    </e:if>
                </e:if>
                order by a.village_name
            )A
        )
        WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

    <e:case value="obd_village_count">
      <e:q4o var="dataObject">
          SELECT count(1) cnt
          FROM ${gis_user}.TB_GIS_ODB_EQP_VILLAGE_DAY T,
          ${gis_user}.tb_gis_village_edit_info a
          WHERE t.village_id = a.village_id
          <e:if condition="${!empty param.substation}">
              AND a.branch_no = '${param.substation}'
          </e:if>
          <e:if condition="${!empty param.grid_id_short}">
              AND a.grid_id_2 = '${param.grid_id_short}'
          </e:if>
          <e:if condition="${!empty param.village_id}">
              AND a.village_id = '${param.village_id}'
          </e:if>
          <e:if condition="${!empty param.zy}">
              <e:if condition="${param.zy eq '1'}">
                  and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
              </e:if>
              <e:if condition="${param.zy eq '3'}">
                  ${sql_part_where}
              </e:if>
          </e:if>
      </e:q4o>${e:java2json(dataObject)}
  </e:case>

    <e:case value="obd_type_cnt_village">
        <e:q4o var="dataObject">
            SELECT
            ${sql_part}
            FROM ${gis_user}.TB_GIS_ODB_EQP_VILLAGE_DAY T,
            ${gis_user}.tb_gis_village_edit_info a
            WHERE t.village_id = a.village_id
            <e:if condition="${!empty param.substation}">
                AND a.branch_no = '${param.substation}'
            </e:if>
            <e:if condition="${!empty param.grid_id_short}">
                AND a.grid_id_2 = '${param.grid_id_short}'
            </e:if>
            <e:if condition="${!empty param.village_id}">
                AND a.village_id = '${param.village_id}'
            </e:if>
            <e:if condition="${!empty param.zy}">
                <e:if condition="${param.zy eq '1'}">
                    and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
                </e:if>
                <e:if condition="${param.zy eq '3'}">
                    ${sql_part_where}
                </e:if>
            </e:if>
        </e:q4o>${e:java2json(dataObject)}
    </e:case>

    <e:description>obd 楼宇</e:description>
    <e:case value="obd_build">
    <e:q4l var="dataList">
        select * from(
            select A.*,ROWNUM ROW_NUM from (
                SELECT a.resfullname,
                a.resid,
                SUBSTR(T.EQP_NO, 0, 5) || '***' || SUBSTR(T.EQP_NO, 20) EQP_ID1,
                t.EQP_NO EQP_ID,
                round(nvl(USER_PORT_RATE,0),4)*100 USER_PORT_RATE,
                t.PORT_ID_CNT,
                t.USE_PORT_CNT,
                DECODE(ZE_PORT_FLG, '0', ' ', '1', '是') ZE_TEXT,
                DECODE(FI_PORT_FLG, '0', ' ', '1', '是') FI_TEXT
                FROM ${gis_user}.TB_GIS_ODB_EQP_ADRESS4_DAY T,
                sde.map_addr_segm_${param.city_id} A
                WHERE T.segm_id = A.Resid
                <e:if condition="${!empty param.substation}">
                    AND a.UNION_ORG_CODE = '${param.substation}'
                </e:if>
                <e:if condition="${!empty param.grid_id_short}">
                    AND a.grid_id = '${param.grid_id_short}'
                </e:if>
                <e:if condition="${!empty param.resid}">
                    and a.resid = '${param.resid}'
                </e:if>
                <e:if condition="${!empty param.village_id}">
                    and a.resid in (SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id ='${param.village_id}')
                </e:if>
                <e:if condition="${!empty param.zy}">
                    <e:if condition="${param.zy eq '1'}">
                        and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
                    </e:if>
                    <e:if condition="${param.zy eq '3'}">
                        ${sql_part_where}
                    </e:if>
                </e:if>
                order by a.resid
            )A
        )
        WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

    <e:case value="obd_build_count">
      <e:q4o var="dataObject">
          SELECT count(1) cnt
          FROM ${gis_user}.TB_GIS_ODB_EQP_ADRESS4_DAY T,
          sde.map_addr_segm_${param.city_id} A
          WHERE T.segm_id = A.Resid
          <e:if condition="${!empty param.substation}">
              AND a.UNION_ORG_CODE = '${param.substation}'
          </e:if>
          <e:if condition="${!empty param.grid_id_short}">
              AND a.grid_id = '${param.grid_id_short}'
          </e:if>
          <e:if condition="${!empty param.resid}">
              and a.resid = '${param.resid}'
          </e:if>
          <e:if condition="${!empty param.village_id}">
              and a.resid in (SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id ='${param.village_id}')
          </e:if>
          <e:if condition="${!empty param.zy}">
              <e:if condition="${param.zy eq '1'}">
                  and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
              </e:if>
              <e:if condition="${param.zy eq '3'}">
                  ${sql_part_where}
              </e:if>
          </e:if>
      </e:q4o>${e:java2json(dataObject)}
  </e:case>

    <e:case value="obd_type_cnt_build">
      <e:q4o var="dataObject">
          SELECT
          ${sql_part}
          FROM ${gis_user}.TB_GIS_ODB_EQP_ADRESS4_DAY T,
          sde.map_addr_segm_${param.city_id} A
          WHERE T.segm_id = A.Resid
          <e:if condition="${!empty param.substation}">
              AND a.UNION_ORG_CODE = '${param.substation}'
          </e:if>
          <e:if condition="${!empty param.grid_id_short}">
              AND a.grid_id = '${param.grid_id_short}'
          </e:if>
          <e:if condition="${!empty param.resid}">
              and a.resid = '${param.resid}'
          </e:if>
          <e:if condition="${!empty param.village_id}">
              and a.resid in (SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id ='${param.village_id}')
          </e:if>
          <e:if condition="${!empty param.zy}">
              <e:if condition="${param.zy eq '1'}">
                  and (t.ze_port_flg = 1 or t.fi_port_flg = 1)
              </e:if>
              <e:if condition="${param.zy eq '3'}">
                  ${sql_part_where}
              </e:if>
          </e:if>
      </e:q4o>${e:java2json(dataObject)}
  </e:case>

    <e:case value="getBuildListBySubstation">
        <e:q4l var="dataList">
            SELECT utl_raw.cast_to_nvarchar2('')||'-1' CODE, utl_raw.cast_to_nvarchar2('')||'全部' TEXT FROM DUAL UNION ALL
            SELECT RESID CODE,RESFULLNAME TEXT FROM sde.map_addr_segm_${param.city_id}
            where union_org_code = '${param.substation}'
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>
</e:switch>