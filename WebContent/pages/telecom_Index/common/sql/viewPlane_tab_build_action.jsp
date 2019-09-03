<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_part_on_count">
  COUNT(CASE
  WHEN O.Is_kd_dx = 0 and O.SERIAL_NO in('1','4') and((O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL) or O.KD_BUSINESS = '0') then
  O.segm_id_2  END
  ) ON_COUNT
</e:set>
<e:set var="sql_part_off_count">
  COUNT(CASE
  WHEN O.Is_kd_dx = 0 and O.SERIAL_NO in('1','4') and (O.KD_BUSINESS IS NULL OR ( O.KD_BUSINESS<> '0' AND O.KD_DQ_DATE IS NULL)) then
  O.segm_id_2 END
  ) OFF_COUNT
</e:set>
<e:set var="sql_part_no_collect">
  (Is_kd_dx = 0 and SERIAL_NO <> 2 and (KD_BUSINESS IS NULL OR ( KD_BUSINESS<> '0' AND KD_DQ_DATE IS NULL)))
</e:set>
<e:set var="sql_part_collected">
  (Is_kd_dx = 0 and SERIAL_NO <> 2 and((KD_BUSINESS IS NOT NULL AND KD_DQ_DATE IS NOT NULL) or KD_BUSINESS = '0'))
</e:set>
<e:set var="sql_part_tab_name3">
  <e:description>2018.9.26 表名更换 EDW.TB_MKT_INFO@gsedw</e:description>
  ${gis_user}.TB_MKT_INFO
</e:set>
<e:set var="sql_part_dqsj">
  <e:description>NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') KD_DQ_DATE,</e:description>
  CASE WHEN NVL(O.IS_KD_DX, 0) = '0' AND (O.KD_BUSINESS = '0' OR O.KD_BUSINESS IS NULL) THEN ' '
  ELSE NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') END KD_DQ_DATE,
</e:set>

<e:switch value="${param.eaction}">
  <e:description>省级概况 显示全省及各地市</e:description>
  <e:case value="collect_new_build_list">
    <e:if condition="${! empty param.village_id }" var="notAll">
      <e:q4l var="build_list">
        SELECT
        STAND_NAME,
        SEGM_ID
        FROM
        ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO VIF
        LEFT OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_ADDR4 BVF
        ON BVF.VILLAGE_ID = VIF.VILLAGE_ID
        LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY GID
        ON BVF.SEGM_ID = GID.LATN_ID
        WHERE 1=1
        <e:if condition="${!empty param.substation }">
        and VIF.BRANCH_NO = '${param.substation }'
        </e:if>
        <e:description>
        AND GID.GZ_CNT = '1'
        </e:description>
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
        SELECT A.SEGM_ID,
        A.STAND_NAME
        FROM SDE.TB_GIS_MAP_SEGM_LATN_MON A
        LEFT OUTER JOIN ${gis_user}.TB_GIS_RES_INFO_DAY B
        ON A.SEGM_ID = B.LATN_ID
        WHERE  1=1
        <e:description>
        and B.GZ_CNT = '1'
        </e:description>
        <e:if condition="${! empty param.substation }">
          and VIF.BRANCH_NO = '${param.substation }'
        </e:if>
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
  <e:case value="collect_new_count">
    <e:q4o var="collect_count">
      SELECT COUNT(*) A_COUNT,
      ${sql_part_on_count},
      ${sql_part_off_count},
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
      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL O
      <e:if condition="${!empty param.res_id}" var="empty_res_id">
        where O.SEGM_ID = '${param.res_id}'
      </e:if>
      <e:else condition="${empty_res_id}">
        <e:if condition="${!empty param.v_id}">
          ,${gis_user}.tb_gis_village_addr4 b
          where O.segm_id = b.segm_id
          and b.village_id = '${param.v_id}'
        </e:if>
      </e:else>
    </e:q4o>${e: java2json(collect_count) }
  </e:case>

  <e:description>楼宇视图 住户详表</e:description>
  <e:case value="collect_new_build_info">
    <e:q4l var="build_list">
      SELECT a.*,nvl(b.stop_type_name,' ') stop_type_name
      FROM (SELECT NVL(O.STAND_NAME_1, ' ') STAND_NAME_1,
      NVL(O.SEGM_ID_2, ' ') SEGM_ID_2,
      NVL(O.SEGM_NAME_2, '  ') SEGM_NAME_2,
      CASE
      WHEN O.IS_KD_DX > 0 THEN
      <e:description>脱敏 NVL(O.CONTACT_PERSON, ' ')</e:description>
      case when NVL(O.DX_CONTACT_PERSON, ' ')=' ' then ' '
      else substr(NVL(O.DX_CONTACT_PERSON, ' '),1,1) || '**' end
      ELSE
      <e:description>脱敏 NVL(O.CONTACT_PERSON, ' ')</e:description>
      case when NVL(O.CONTACT_PERSON, ' ')='未装' then '未装'
      when NVL(O.CONTACT_PERSON, ' ')=' ' then ' '
      else substr(NVL(O.CONTACT_PERSON, ' '),1,1) || '**' end
      END CONTACT_PERSON,
      CASE
      WHEN O.IS_KD_DX > 0 THEN
      <e:description>2018.10.22 号码脱敏</e:description>
      decode(O.DX_CONTACT_NBR,null,'--',nvl((substr(O.DX_CONTACT_NBR,0,3) || '******' || substr(O.DX_CONTACT_NBR,10,2)),' '))
      ELSE
      <e:description>2018.10.22 号码脱敏</e:description>
      decode(O.CONTACT_NBR,null,'--',nvl((substr(O.CONTACT_NBR,0,3) || '******' || substr(O.CONTACT_NBR,10,2)),' '))
      END CONTACT_NBR,
      CASE
      WHEN NVL(O.IS_KD_DX, 0) = '0' THEN
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
      O.KD_BUSINESS KD_BUS_FLAG,
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
      WHEN NVL(O.IS_ITV_DX, 0) = '0' THEN
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
      NVL(TO_CHAR(O.ITV_DQ_DATE, 'YYYY-MM-DD'), '  ') ITV_DQ_DATE,
      CASE
      WHEN O.KD_BUSINESS = '0' and O.SERIAL_NO in('1','4') THEN
      '是'
      WHEN O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL and O.SERIAL_NO in('1','4') THEN
      '是'
      <e:description>政企 不显示收集状态</e:description>
      WHEN O.SERIAL_NO = '2' THEN
      ' '
      <e:description>电信用户 不显示收集状态</e:description>
      WHEN O.IS_KD_DX > 0 THEN
      ' '
      ELSE
      '否'
      END COLLLECT_FLAG,
      NVL(O.SERIAL_NO, '0') SERIAL_NO,
      C.STOP_TYPE STOP_TYPE1
      FROM (SELECT *
      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL
      WHERE SEGM_ID = '${param.res_id }'
      AND IS_KD_DX = 1
      <e:if condition="${param.collect_bselect ne '-1' }">
        <e:if condition="${param.collect_bselect ne '0'}" var="uninstall_bus">
          <e:if condition="${param.collect_bselect eq '5' }" var="is_dx">
            AND is_kd_dx>0
          </e:if>
          <e:else condition="${is_dx}">
            AND KD_BUSINESS = '${param.collect_bselect }'
          </e:else>
        </e:if>
        <e:description>未装</e:description>
        <e:else condition="${uninstall_bus}">
          AND (IS_KD_DX = 0 AND kd_business = 0)
        </e:else>
      </e:if>
      <e:switch value="${param.collect_state }">
        <e:case value="1">
          AND ${sql_part_no_collect}
        </e:case>
        <e:case value="2"><e:description>已收集</e:description>
          AND ${sql_part_collected}
        </e:case>
      </e:switch>
      ) O,
      (SELECT ADDRESS_ID, PROD_INST_ID, STOP_TYPE
      FROM ${sql_part_tab_name3}
      WHERE 1=1
      <e:if condition='${!empty param.village_id}'>
        and LEV6_ID = '${param.village_id}'
      </e:if>
      AND (PRODUCT_ID = '100000045' OR PRODUCT_ID = '122445247')
      AND STATE_CD = '001') C
      WHERE O.SEGM_ID_2 = C.ADDRESS_ID(+)
      UNION
      SELECT NVL(O.STAND_NAME_1, ' ') STAND_NAME_1,
      NVL(O.SEGM_ID_2, ' ') SEGM_ID_2,
      NVL(O.SEGM_NAME_2, '  ') SEGM_NAME_2,
      CASE
      WHEN O.IS_KD_DX > 0 THEN
      <e:description>脱敏 NVL(O.CONTACT_PERSON, ' ')</e:description>
      case when NVL(O.DX_CONTACT_PERSON, ' ')=' ' then ' '
      else substr(NVL(O.DX_CONTACT_PERSON, ' '),1,1) || '**' end
      ELSE
      <e:description>脱敏 NVL(O.CONTACT_PERSON, ' ')</e:description>
      case when NVL(O.CONTACT_PERSON, ' ')='未装' then '未装'
      when NVL(O.CONTACT_PERSON, ' ')=' ' then ' '
      else substr(NVL(O.CONTACT_PERSON, ' '),1,1) || '**' end
      END CONTACT_PERSON,
      CASE
      WHEN O.IS_KD_DX > 0 THEN
      decode(O.DX_CONTACT_NBR,null,' ',nvl((substr(O.DX_CONTACT_NBR,0,3) || '******' || substr(O.DX_CONTACT_NBR,10,2)),'--'))
      ELSE
      decode(O.CONTACT_NBR,null,' ',nvl((substr(O.CONTACT_NBR,0,3) || '******' || substr(O.CONTACT_NBR,10,2)),'--'))
      END CONTACT_NBR,
      CASE
      WHEN NVL(O.IS_KD_DX, 0) = '0' THEN
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
      O.KD_BUSINESS KD_BUS_FLAG,
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
      WHEN NVL(O.IS_ITV_DX, 0) = '0' THEN
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
      NVL(TO_CHAR(O.ITV_DQ_DATE, 'YYYY-MM-DD'), '  ') ITV_DQ_DATE,
      CASE
      WHEN O.KD_BUSINESS = '0' AND O.SERIAL_NO in('1','4') THEN
      '是'
      WHEN O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL AND O.SERIAL_NO in('1','4') THEN
      '是'
      <e:description>政企 不显示收集状态</e:description>
      WHEN O.SERIAL_NO = '2' THEN
      ' '
      <e:description>电信用户 不显示收集状态</e:description>
      WHEN O.IS_KD_DX > 0 THEN
      ' '
      ELSE
      '否'
      END COLLLECT_FLAG,
      NVL(O.SERIAL_NO, '0') SERIAL_NO,
      '-1' STOP_TYPE1
      FROM (SELECT *
      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL
      WHERE SEGM_ID = '${param.res_id }'
      AND IS_KD_DX <> 1
      <e:if condition="${param.collect_bselect ne '-1' }">
        <e:if condition="${param.collect_bselect ne '0'}" var="uninstall_bus">
          <e:if condition="${param.collect_bselect eq '5' }" var="is_dx">
            AND is_kd_dx>0
          </e:if>
          <e:else condition="${is_dx}">
            AND KD_BUSINESS = '${param.collect_bselect }'
          </e:else>
        </e:if>
        <e:description>未装</e:description>
        <e:else condition="${uninstall_bus}">
          AND (IS_KD_DX = 0 AND kd_business = 0)
        </e:else>
      </e:if>
      <e:switch value="${param.collect_state }">
        <e:case value="1">
          AND ${sql_part_no_collect}
        </e:case>
        <e:case value="2"><e:description>已收集</e:description>
          AND ${sql_part_collected}
        </e:case>
      </e:switch>
      ) O) A
      LEFT JOIN ${gis_user}.TB_DIC_GIS_STOP_TYPE B
      ON A.STOP_TYPE1 = B.STOP_TYPE
      ORDER BY STAND_NAME_1 DESC, LENGTH(SEGM_NAME_2) ASC, SEGM_NAME_2 ASC
    </e:q4l>${e: java2json(build_list.list) }
  </e:case>
  <e:case value="obd_type_cnt_build">
    <e:q4o var="dataObject">
      SELECT
      count(1) sum_cnt,
      count(case when ze_port_flg=1 then 1 else null end) obd0_cnt,
      count(case when fi_port_flg=1 then 1 else null end) obd1_cnt,
      count(case when zero_port_flg=0 then 1 else null end) hobd_cnt
      FROM ${gis_user}.TB_GIS_ODB_EQP_ADRESS4_DAY T,
      sde.map_addr_segm_${param.city_id} A
      WHERE T.segm_id = A.Resid
      <e:if condition="${!empty param.substation}">
        AND a.UNION_ORG_CODE = '${param.substation}'
      </e:if>
      <e:if condition="${!empty param.grid_id_short}">
        AND a.grid_id = '${param.grid_id_short}'
      </e:if>
      <e:if condition="${!empty param.res_id}">
        and a.resid = '${param.res_id}'
      </e:if>
      <e:if condition="${!empty param.village_id}">
        and a.resid in (SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id ='${param.village_id}')
      </e:if>
      <e:if condition="${!empty param.zy}">
        <e:if condition="${param.zy eq '1'}">
          and t.ze_port_flg = 1
        </e:if>
        <e:if condition="${param.zy eq '2'}">
          and t.fi_port_flg = 1
        </e:if>
        <e:if condition="${param.zy eq '3'}">
          and t.zero_port_flg = 0
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
      SUBSTR(T.EQP_ID, 0, 5) || '***' || SUBSTR(T.EQP_ID, 20) EQP_ID1,
      t.EQP_ID,
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
      <e:if condition="${!empty param.res_id}">
        and a.resid = '${param.res_id}'
      </e:if>
      <e:if condition="${!empty param.village_id}">
        and a.resid in (SELECT segm_id FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id ='${param.village_id}')
      </e:if>
      <e:if condition="${!empty param.zy}">
        <e:if condition="${param.zy eq '1'}">
          and t.ze_port_flg = 1
        </e:if>
        <e:if condition="${param.zy eq '2'}">
          and t.fi_port_flg = 1
        </e:if>
        <e:if condition="${param.zy eq '3'}">
          and t.zero_port_flg = 0
        </e:if>
      </e:if>
      order by a.resid
      )A
      )
      WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取楼宇所在网格里的所有小区</e:description>
  <e:case value="getVillBySegmId">
    <e:q4l var="dataList">
      SELECT A.VILLAGE_ID code, A.VILLAGE_NAME name
      FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO A, SDE.TB_GIS_MAP_SEGM_LATN_MON B
      WHERE A.GRID_ID_2 = B.GRID_ID
      AND B.SEGM_ID = '${param.res_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>将楼宇归入小区中</e:description>
  <e:case value="buildJoinVillage">
    <e:description>1.先判断楼宇隶属的小区下剩余多少楼宇，如果剩一个楼宇，就删除小区</e:description>
    <e:q4o var="buildCntInVill">
      select count(1) val from ${gis_user}.tb_gis_village_addr4 where village_id = '${param.old_v_id}'
    </e:q4o>
    <e:if condition="${buildCntInVill.VAL eq '1'}">
      <e:update>
        begin
          delete from ${gis_user}.tb_gis_village_edit_info where village_id = '${param.old_v_id}';
          delete from ${gis_user}.tb_gis_village_addr4 where village_id = '${param.old_v_id}';
          delete from SDE.MAP_VILLAGE_EDIT_INFO where village_id = '${param.old_v_id}';
        end;
      </e:update>
    </e:if>

    <e:description>2.解除小区和楼宇的关系，并调整楼宇到目标小区里</e:description>
    <e:update var="cnt">
      begin
        delete from ${gis_user}.tb_gis_village_addr4 where SEGM_ID = '${param.res_id}';
        insert into ${gis_user}.tb_gis_village_addr4(VILLAGE_ID,SEGM_ID,segm_name,stand_name)
          values('${param.v_id}','${param.res_id}',(SELECT resname FROM sde.MAP_ADDR_SEGM_${param.latn_id} WHERE resid = '${param.res_id}'),'${param.stand_name}');
      end;
    </e:update>${cnt}
  </e:case>

  <e:description>小区工作台 新增收集清单 列表sql</e:description>
  <e:case value="getVillCollectDetail">
    <e:q4l var="dataList">
      SELECT A.*
      FROM (SELECT
      NVL(O.SEGM_ID_2, ' ') SEGM_ID_2,
      NVL(O.STAND_NAME_2, ' ') STAND_NAME_2,
      CASE
      WHEN O.IS_KD_DX > 0 THEN
      <e:description>脱敏 NVL(O.CONTACT_PERSON, ' ')</e:description>
      CASE
      WHEN NVL(O.DX_CONTACT_PERSON, ' ') = ' ' THEN
      ' '
      ELSE
      SUBSTR(NVL(O.DX_CONTACT_PERSON, ' '), 1, 1) || '**'
      END
      ELSE
      <e:description>脱敏 NVL(O.CONTACT_PERSON, ' ')</e:description>
      CASE
      WHEN NVL(O.CONTACT_PERSON, ' ') = '未装' THEN
      '未装'
      WHEN NVL(O.CONTACT_PERSON, ' ') = ' ' THEN
      ' '
      ELSE
      SUBSTR(NVL(O.CONTACT_PERSON, ' '), 1, 1) || '**'
      END
      END CONTACT_PERSON,
      CASE
      WHEN O.IS_KD_DX > 0 THEN
      <e:description>2018.10.22 号码脱敏</e:description>
      DECODE(O.DX_CONTACT_NBR,
      NULL,
      '--',
      NVL((SUBSTR(O.DX_CONTACT_NBR, 0, 3) || '******' ||
      SUBSTR(O.DX_CONTACT_NBR, 10, 2)),
      ' '))
      ELSE
      <e:description>2018.10.22 号码脱敏</e:description>
      DECODE(O.CONTACT_NBR,
      NULL,
      '--',
      NVL((SUBSTR(O.CONTACT_NBR, 0, 3) || '******' ||
      SUBSTR(O.CONTACT_NBR, 10, 2)),
      ' '))
      END CONTACT_NBR,
      CASE
      WHEN NVL(O.IS_KD_DX, 0) = '0' THEN
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
      O.KD_BUSINESS KD_BUS_FLAG,
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
      WHEN NVL(O.IS_ITV_DX, 0) = '0' THEN
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
      NVL(TO_CHAR(O.ITV_DQ_DATE, 'YYYY-MM-DD'), '  ') ITV_DQ_DATE,
      CASE
      WHEN O.KD_BUSINESS = '0' AND O.SERIAL_NO IN ('1', '4') THEN
      '是'
      WHEN O.KD_BUSINESS IS NOT NULL AND O.KD_DQ_DATE IS NOT NULL AND
      O.SERIAL_NO IN ('1', '4') THEN
      '是'
      WHEN O.is_kd_dx = 0 AND O.kd_business IS NULL THEN
      '否'
      <e:description>政企 不显示收集状态</e:description>
      WHEN O.SERIAL_NO = '2' THEN
      ' '
      ELSE
      '否'
      END COLLLECT_FLAG,
      NVL(O.SERIAL_NO, '0') SERIAL_NO,
      CASE
      WHEN O.kd_business = 0 AND O.IS_KD_DX = 0 THEN '否'
      WHEN O.kd_business IS NULL AND O.IS_KD_DX = 0 THEN ' '
      ELSE '是'
      END is_install
      FROM (SELECT *
      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL a
      <e:if condition="${!empty param.res_id}" var="empty_res_id">
        where SEGM_ID = '${param.res_id }'
      </e:if>
      <e:else condition="${empty_res_id}">
        <e:if condition="${!empty param.v_id}">
          , ${gis_user}.tb_gis_village_addr4 b
          where a.segm_id = b.segm_id
          and b.village_id = '${param.v_id}'
        </e:if>
      </e:else>
      <e:if condition="${param.collect_bselect ne '-1' }">
        <e:if condition="${param.collect_bselect ne '0'}" var="uninstall_bus">
          <e:if condition="${param.collect_bselect eq '5' }" var="is_dx">
            AND IS_KD_DX>0
          </e:if>
          <e:else condition="${is_dx}">
            AND KD_BUSINESS = '${param.collect_bselect }'
          </e:else>
        </e:if>
        <e:description>未装</e:description>
        <e:else condition="${uninstall_bus}">
          AND (IS_KD_DX = 0 AND kd_business = 0)
        </e:else>
      </e:if>
      <e:switch value="${param.collect_state }">
        <e:case value="1">
          AND ${sql_part_no_collect}
        </e:case>
        <e:case value="2"><e:description>已收集</e:description>
          AND ${sql_part_collected}
        </e:case>
      </e:switch>
      and IS_KD_DX = 0 and SERIAL_NO IN ('1', '4')
      ) O
      ) A
      ORDER BY SEGM_ID_2 ASC, LENGTH(STAND_NAME_2) ASC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>小区新增页签 收集清单 只统计异网用户</e:description>
  <e:case value="collect_new_count_yw">
    <e:q4o var="collect_count">
      SELECT COUNT(*) A_COUNT,
      ${sql_part_on_count},
      ${sql_part_off_count},
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
      FROM ${gis_user}.TB_GIS_ADDR_OTHER_ALL O
      <e:if condition="${!empty param.res_id}" var="empty_res_id">
        where O.SEGM_ID = '${param.res_id}'
      </e:if>
      <e:else condition="${empty_res_id}">
        <e:if condition="${!empty param.v_id}">
          ,${gis_user}.tb_gis_village_addr4 b
          where O.segm_id = b.segm_id
          and b.village_id = '${param.v_id}'
        </e:if>
      </e:else>
      and O.Is_kd_dx = 0 and SERIAL_NO IN ('1', '4')
    </e:q4o>${e: java2json(collect_count) }
  </e:case>
</e:switch>