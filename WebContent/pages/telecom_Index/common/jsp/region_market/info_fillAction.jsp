<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:case value="getVillageData">
		<e:q4o var="dataObject">
			SELECT
			decode(GZ_ZHU_HU_COUNT,0,'--',GZ_ZHU_HU_COUNT) GZ_ZHU_HU_COUNT,
			decode(GZ_H_USE_CNT,0,'--',GZ_H_USE_CNT) GZ_H_USE_CNT,
			decode(GZ_ZHU_HU_COUNT,0,'--',TO_CHAR(ROUND(nvl(GZ_H_USE_CNT,0) / GZ_ZHU_HU_COUNT,4) * 100,'FM9999999990.00') || '%') MARKT_LV,
			decode(OBD_CNT,0,'--',OBD_CNT) OBD_CNT,
			decode(NO_RES_ARRIVE_CNT,'--',NO_RES_ARRIVE_CNT) NO_RES_ARRIVE_CNT,
			case when OBD_CNT is null and NO_RES_ARRIVE_CNT is null then '--' ELSE (nvl(OBD_CNT,0) - nvl(NO_RES_ARRIVE_CNT,0)) || '' END RES_ARRIVE_CNT,
			decode(LY_CNT,0,'--',LY_CNT) LY_CNT,
			DECODE(LY_CNT,0,'--',TO_CHAR(ROUND((LY_CNT - NO_RES_ARRIVE_CNT) / LY_CNT,4) * 100,'FM9999999990.00')|| '%')  CONVER_LV,
			decode(PORT_ID_CNT,0,'--',PORT_ID_CNT) PORT_ID_CNT,
			decode(USE_PORT_CNT,0,'--',USE_PORT_CNT) USE_PORT_CNT,
			decode(PORT_ID_CNT,0,'--',TO_CHAR(ROUND(nvl(USE_PORT_CNT,0) / PORT_ID_CNT,4) * 100,'FM9999999990.00') || '%') PORT_LV,
			SHOULD_COLLECT_CNT,
			ALREADY_COLLECT_CNT,
			decode(SHOULD_COLLECT_CNT,0,'--',TO_CHAR(ROUND(nvl(ALREADY_COLLECT_CNT,0) / SHOULD_COLLECT_CNT,4) * 100,'FM9999999990.00') || '%') COLLECT_LV,
			c.LOST_Y_REMOVE,
			c.LOST_Y_STOP,
			c.LOST_Y_SILENT,
			c.LOST_Y_TOTAL,
			decode(GZ_H_USE_CNT,0,'--',TO_CHAR(ROUND(nvl(c.LOST_Y_TOTAL,0) / GZ_H_USE_CNT,4) * 100,'FM9999999990.00') || '%') LOST_LV,
			BY_ALL_CNT,
			BY_CNT,
			decode(BY_ALL_CNT,0,'--',TO_CHAR(ROUND(nvl(BY_CNT,0) / BY_ALL_CNT,4) * 100,'FM9999999990.00') || '%') BY_LV,
			VILLAGE_LABEL_FLG
			FROM ${gis_user}.TB_GIS_RES_CITY_DAY A, ${gis_user}.TB_HDZ_VILLAGE_LOST C
			WHERE A.LATN_ID = C.VILLAGE_ID(+)
			AND A.FLG = 5
			AND A.LATN_ID = '${param.village_id}'
		</e:q4o>${e:java2json(dataObject)}
	</e:case>

	<e:case value="getTacticsData">
		<e:q4o var="dataObject">
			select * from (
			select
			decode(goal_market_lv,0,'--',to_char(nvl(goal_market_lv,0),'FM999999990.00') || '%') goal_market_lv,
			decode(goal_port_lv,0,'--',to_char(nvl(goal_port_lv,0),'FM999999990.00') || '%') goal_port_lv,
			decode(goal_lost_lv,0,'--',to_char(nvl(goal_lost_lv,0),'FM999999990.00') || '%') goal_lost_lv,
			decode(goal_d2r,0,'--',nvl(goal_d2r,0)) goal_d2r,
			decode(goal_dqxy,0,'--',nvl(goal_dqxy,0)) goal_dqxy,
			decode(goal_sleep2active,0,'--',nvl(goal_sleep2active,0)) goal_sleep2active,
			decode(goal_collect_lv,0,'--',to_char(nvl(goal_collect_lv,0),'FM999999990.00') || '%') goal_collect_lv,

			NVL(YX_SUB_CONTENT, '--') YX_SUB_CONTENT,
			NVL(YX_TACTICS_CONTENT, '--') YX_TACTICS_CONTENT,
			NVL(ZC_FEE, '--') ZC_FEE,
			NVL(ZC_SELL, '--') ZC_SELL,
			NVL(ORG_EMP, '--') ORG_EMP,
			NVL(ORG_ACT, '--') ORG_ACT,
			NVL(ORG_YX, '--') ORG_YX,
			NVL(PLAN_CONENT, '--') PLAN_CONENT,
			row_number() OVER(ORDER BY opr_time DESC) rn
			from ${gis_user}.tb_gis_village_tactics
			where 1=1
			<e:if condition="${!empty param.tactics_id && param.tactics_id ne 'undefined'}" var="empty_tactics">
				and tactics_id = '${param.tactics_id}')
			</e:if>
			<e:else condition="${empty_tactics}">
				and village_id = '${param.village_id}')
				where rn = 1
			</e:else>
		</e:q4o>${e:java2json(dataObject)}
	</e:case>

	<e:case value="saveTacticsInfo">
		<e:if condition="${empty param.tactics_id}" var="empty_recode">
			<e:update var="save_cnt">
				insert into ${gis_user}.tb_gis_village_tactics
				(
				tactics_id,
				village_id,

				gz_zhu_hu_count,
				gz_h_use_cnt,
				market_lv,
				obd_cnt,
				res_arrive_cnt,
				ly_cnt,
				cover_lv,
				port_id_cnt,
				use_port_cnt,
				port_lv,
				should_collect_cnt,
				already_collect_cnt,
				collect_lv,
				lost_cj_cnt,
				lost_qt_cnt,
				lost_cm_cnt,
				lost_lv,
				by_all_cnt,
				by_cnt,
				by_lv,

				goal_market_lv,
				goal_port_lv,
				goal_lost_lv,
				goal_d2r,
				goal_dqxy,
				goal_sleep2active,
				goal_collect_lv,

				yx_sub_content,

				yx_tactics_content,

				zc_fee,
				zc_sell,

				org_emp,
				org_act,
				org_yx,

				plan_conent,

				opr_id,
				opr_time
				)
				values
				(
				sys_guid(),
				'${param.village_id}',

				'${param.gz_zhu_hu_count}',
				'${param.gz_h_use_cnt}',
				'${param.market_lv}',
				'${param.obd_cnt}',
				'${param.res_arrive_cnt}',
				'${param.ly_cnt}',
				'${param.cover_lv}',
				'${param.port_id_cnt}',
				'${param.use_port_cnt}',
				'${param.port_lv}',
				'${param.should_collect_cnt}',
				'${param.already_collect_cnt}',
				'${param.collect_lv}',
				'${param.lost_cj_cnt}',
				'${param.lost_qt_cnt}',
				'${param.lost_cm_cnt}',
				'${param.lost_lv}',
				'${param.by_all_cnt}',
				'${param.by_cnt}',
				'${param.by_lv}',

				'${param.goal_market_lv}',
				'${param.goal_port_lv}',
				'${param.goal_lost_lv}',
				'${param.goal_d2r}',
				'${param.goal_dqxy}',
				'${param.goal_sleep2active}',
				'${param.goal_collect_lv}',

				'${param.yx_sub_content}',

				'${param.yx_tactics_content}',

				'${param.zc_fee}',
				'${param.zc_sell}',

				'${param.org_emp}',
				'${param.org_act}',
				'${param.org_yx}',

				'${param.plan_conent}',

				'${sessionScope.UserInfo.USER_ID}',
				SYSDATE
				)
			</e:update>
		</e:if>
		<e:else condition="${empty_recode}">
			<e:update var="save_cnt">
				update ${gis_user}.tb_gis_village_tactics

				set

				goal_market_lv = '${param.goal_market_lv}',
				goal_port_lv = '${param.goal_port_lv}',
				goal_lost_lv = '${param.goal_lost_lv}',
				goal_d2r = '${param.goal_d2r}',
				goal_dqxy = '${param.goal_dqxy}',
				goal_sleep2active = '${param.goal_sleep2active}',
				goal_collect_lv = '${param.goal_collect_lv}',

				yx_sub_content = '${param.yx_sub_content}',

				yx_tactics_content = '${param.yx_tactics_content}',

				zc_fee = '${param.zc_fee}',
				zc_sell = '${param.zc_sell}',

				org_emp = '${param.org_emp}',
				org_act = '${param.org_act}',
				org_yx = '${param.org_yx}',

				plan_conent = '${param.plan_conent}',

				opr_id = '${sessionScope.UserInfo.USER_ID}',
				opr_time = SYSDATE

				where tactics_id = '${param.tactics_id}'
			</e:update>
		</e:else>
	</e:case>${save_cnt}

	<e:case value="getVillageByGrid">
		<e:q4l var="dataList">
			select distinct a.village_id,a.village_name from ${gis_user}.tb_gis_village_edit_info a
			where a.grid_id_2 = '${param.grid_id}'
			<e:if condition="${!empty param.village_type}">
				and a.village_label_flg = ${param.village_type}
			</e:if>
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>

</e:switch>