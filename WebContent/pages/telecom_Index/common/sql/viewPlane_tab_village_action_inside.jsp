<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="sql_part_scene_text">
	case when t.stop_type =0 then '拆机'
	when t.stop_type =8 THEN '单停'
	when t.stop_type =9 THEN '双停'
	when t.stop_type =3 THEN '沉默'<e:description>本年沉默</e:description>
	when t.stop_type =2 THEN '沉默'<e:description>近三个月沉默</e:description>
	else ' '
	end
</e:set>
<e:set var="sql_part_tab1">
	<e:description>EDW.TB_MKT_INFO_LOST@GSEDW</e:description>
	${gis_user}.tb_mkt_info_lost
</e:set>
<e:set var="sql_part_tab2">
	<e:description>
	${gis_user}.VIEW_GIS_ORDER_LIST_MON
	</e:description>
	${gis_user}.view_gis_order_a1_mon
</e:set>
<e:description>20180903 把 TB_HDZ_INT_PMP_EXE_CHL_LIST 换成 TB_HDZ_M_PMP_PA_CHL_QUERY_LIST</e:description>
<e:switch value="${param.eaction}">
	<e:description>小区工作台 营销概况</e:description>
	<e:case value="intraday_num_village_new">
		<e:q4l var="dataList">
			<e:description>已废弃
			<e:description>
			select order_num,exec_num,succ_num,exec_rate from ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_SUM where acct_month = '${param.acct_month}' and village_id = '${param.village_id}'
			</e:description>
			SELECT
			COUNT(1) order_num,
			NVL(SUM(DECODE(EXE_DATE, NULL, 0, 1)),0) EXEC_NUM,
			NVL(SUM(DECODE(SUC_FLAG, '成功', 1, 0)),0) SUCC_NUM
			FROM ${gis_user}.TB_HDZ_M_PMP_PA_CHL_QUERY_LIST A, ${gis_user}.TB_GIS_RELATION_D B
			WHERE A.TARGET_OBJ_NBR = B.PRD_INST_ID
			AND B.VILLAGE_ID = '${param.village_id}'
			<e:description>
				2018.9.3改为取月数据
				AND A.PA_DATE = (SELECT MAX(const_value) val FROM ${easy_user}.sys_const_table where model_id=10)
			</e:description>
			AND A.MONTH_NO = (SELECT max(const_value) val FROM ${easy_user}.sys_const_table where model_id=10 AND data_type='mon')
			</e:description>
			<e:description>已废弃
			SELECT COUNT(ORDER_ID) order_num,
			COUNT(DECODE(T.EXEC_STAT, 0, NULL, ORDER_ID)) EXEC_NUM,
			COUNT(DECODE(T.SUCC_FLAG, 1, ORDER_ID, NULL)) SUCC_NUM
			FROM ${gis_user}.VIEW_GIS_ORDER_LIST_MON T, ${gis_user}.TB_GIS_RELATION_D V
			WHERE T.PROD_INST_ID = V.PRD_INST_ID
			AND V.VILLAGE_ID = '${param.village_id}'
			</e:description>
			SELECT COUNT(ORDER_ID) order_num,
			COUNT(DECODE(T.EXEC_STAT, 0, NULL, ORDER_ID)) EXEC_NUM,
			COUNT(DECODE(T.SUCC_FLAG, 1, ORDER_ID, NULL)) SUCC_NUM
			FROM ${sql_part_tab2} T
			WHERE T.VILLAGE_ID = '${param.village_id}'
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>

	<e:description>小区营销 已废弃</e:description>
 	<e:case value="marketing_intraday">
    <e:q4l var="marketing_intraday">
         SELECT T.* FROM(
			 SELECT
				ROWNUM  ROW_NUM,
                trim(t.segm_id) segm_id,
				trim(t.segm_id_2) segm_id_2,
                t.stand_name_2 CONTACT_ADDS,
				t.scenes_type,
                t.scenes_name  scene_id,
				<e:description>脱敏 user_contact_person SERV_NAME,</e:description>
                case when nvl(t.user_contact_person,' ')=' ' then ' '
				else substr(nvl(t.user_contact_person,' '),1,1)||'**' end SERV_NAME ,
				<e:description>2018.10.22 号码脱敏</e:description>
				substr(NVL(t.USER_CONTACT_NBR, ' '),0,3)||'******'||SUBSTR(NVL(t.USER_CONTACT_NBR, ' '),10) CONTACT_TEL,
				t.ACC_NBR ACC_NBR,
                t.acct_month,
				t.mkt_reason,
				t.prod_inst_id
		  FROM  ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
		  where
		        t.acct_month = to_char(add_months(sysdate,-1),'yyyymm')
		        and t.village_id = '${param.village_id}'
				<e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
                and t.segm_id = '${param.segm_code}'
		        </e:if>
		     <e:if condition="${!empty param.intraday_sence_id}">
				and t.scenes_type = '${param.intraday_sence_id}'
		    </e:if>
			<e:if condition="${!empty param.deal_flag && param.deal_flag eq '1'}">
				and t.exec_stat <> 0
		    </e:if>
			<e:if condition="${!empty param.deal_flag && param.deal_flag eq '2'}">
				and t.exec_stat = 0
		    </e:if>
		 order by segm_id
       ) T
	  WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
       order by t.acct_month desc,t.segm_id ASC,t.segm_id_2 ASC
       </e:q4l> ${e: java2json(marketing_intraday.list) }
    </e:case>

	<e:description>小区营销 begin</e:description>
	<e:description>一级汇总:派单情况</e:description>
	<e:case value="intraday_num">
        <e:q4l var="dataList">
			<e:description>已废弃
				SELECT
					   order_num ,
					   exec_num,
					   exec_rate,
					   succ_num
				from
					   ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_SUM
				where
					   village_id = '${param.village_id}'
					   and acct_month = to_char(add_months(sysdate,-1),'yyyymm')
			</e:description>
			SELECT COUNT(DISTINCT t.scene_id) SCENE_NUM,
			COUNT(PROD_INST_ID) TARGET_NUM,
			count(decode(t.exec_stat,0,null,order_id)) EXEC_NUM,
			count(decode(t.succ_flag,1,order_id,null)) SUCC_NUM,
			to_char(round(DECODE(count(order_id),0,0,count(decode(t.exec_stat,0,null,order_id)) /count(order_id)),4) * 100,'FM9999999990.00') || '%' EXEC_LV
			FROM ${sql_part_tab2} t
			WHERE t.VILLAGE_ID = '${param.village_id}'
			<e:description>换为月表后去掉账期
			AND t.ORDER_DATE = TO_CHAR(SYSDATE, 'YYYYMMdd')
			</e:description>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

	<e:description>二级汇总:场景，状态 已废弃</e:description>
	<e:case value="intraday_sed_num">
         <e:q4l var="intraday_num">
			 select count(t.acct_month) count
			 FROM ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
			 where t.acct_month = to_char(add_months(sysdate, -1), 'yyyymm')
			 and t.village_id = '${param.village_id}'
			 <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
				 and t.segm_id = '${param.segm_code}'
			 </e:if>
			 union all
			 select count(t.acct_month) count
			 FROM ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
			 where t.acct_month = to_char(add_months(sysdate, -1), 'yyyymm')
			 and t.village_id = '${param.village_id}'
			 <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
				 and t.segm_id = '${param.segm_code}'
			 </e:if>
			 and t.scenes_type = '10'
			 union all
			 select count(t.acct_month) count
			 FROM ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
			 where t.acct_month = to_char(add_months(sysdate, -1), 'yyyymm')
			 and t.village_id = '${param.village_id}'
			 <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
				 and t.segm_id = '${param.segm_code}'
			 </e:if>
			 and t.scenes_type = '11'
			 union all
			 select count(t.acct_month) count
			 FROM ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
			 where t.acct_month = to_char(add_months(sysdate, -1), 'yyyymm')
			 and t.village_id = '${param.village_id}'
			 <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
				 and t.segm_id = '${param.segm_code}'
			 </e:if>
			 and t.scenes_type = '12'
			 union all
			 select count(t.acct_month) count
			 FROM ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
			 where t.acct_month = to_char(add_months(sysdate, -1), 'yyyymm')
			 and t.village_id = '${param.village_id}'
			 <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
				 and t.segm_id = '${param.segm_code}'
			 </e:if>
			 union all
			 select count(t.acct_month) count
			 FROM ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
			 where t.acct_month = to_char(add_months(sysdate, -1), 'yyyymm')
			 and t.village_id = '${param.village_id}'
			 <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
				 and t.segm_id = '${param.segm_code}'
			 </e:if>
			 and t.exec_stat = 0
			 union all
			 select count(t.acct_month) count
			 FROM ${gis_user}.VIEW_TB_GIS_VILLAGE_ORDER_LIST t
			 where t.acct_month = to_char(add_months(sysdate, -1), 'yyyymm')
			 and t.village_id = '${param.village_id}'
			 <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
				 and t.segm_id = '${param.segm_code}'
			 </e:if>
			 and t.exec_stat <> 0
        </e:q4l>${e: java2json(intraday_num.list) }
    </e:case>

	<e:description>小区工作台营销清单 场景营销 汇总列表</e:description>
	<e:case value="marketing_scene">
		<e:q4l var="dataList">
			<e:description>
			无8条固定场景
			SELECT *
			FROM (SELECT A.*, ROWNUM RN
			FROM (SELECT * FROM (
			SELECT A.MKT_CAMPAIGN_ID,
			A.MKT_CAMPAIGN_NAME SCENE_NAME,
			C.MKT_TYPE_NAME SCENE_TYPE,
			COUNT(DISTINCT TARGET_OBJ_NBR) USER_NUM,
			SUM(DECODE(EXE_DATE, NULL, 0, 1)) EXEC_NUM,
			COUNT(1) OVER() c_num
			FROM
			(select * from ${gis_user}.TB_HDZ_M_PMP_PA_CHL_QUERY_LIST
			where 1=1
			<e:description>
				2018.9.3改为取月数据
				and PA_DATE = (SELECT MAX(const_value) val FROM ${easy_user}.sys_const_table where model_id=10)
			</e:description>
			AND MONTH_NO = (SELECT max(const_value) val FROM ${easy_user}.sys_const_table where model_id=10 AND data_type='mon')
			<e:if condition="${!empty param.scene_id}">
				and mkt_campaign_id = '${param.scene_id}'
			</e:if>
			) A,
			${gis_user}.TB_GIS_RELATION_D           B,
			${gis_user}.TB_HDZ_DIC_MARKET_INFO      C
			WHERE A.TARGET_OBJ_NBR = B.PRD_INST_ID(+)
			AND B.VILLAGE_ID = '${param.village_id}'
			<e:if condition="${!empty param.segm_code}">
				and b.segm_id = '${param.segm_code}'
			</e:if>
			AND A.MKT_CAMPAIGN_ID = C.MKT_ID
			GROUP BY A.MKT_CAMPAIGN_ID, A.MKT_CAMPAIGN_NAME, C.MKT_TYPE_NAME
			order by A.MKT_CAMPAIGN_ID
			)
			WHERE ROWNUM <= (${param.page}+1)*10
			) A)
			WHERE RN > ${param.page}*10
			</e:description>

			SELECT * FROM (
			SELECT a.*,ROWNUM rn FROM (
			SELECT * FROM (SELECT *
			FROM (SELECT A.MKT_ID MKT_CAMPAIGN_ID,
			A.MKT_NAME SCENE_NAME,
			NVL(C.USER_NUM, 0) USER_NUM,
			NVL(C.EXEC_NUM, 0) EXEC_NUM,
			NVL(C.EXE_LV, '0.00%') EXE_LV,
			NVL(C.SUCC_NUM, 0) SUCC_NUM,
			NVL(C.SUCC_LV, '0.00%') SUCC_LV,
			A.ORD
			FROM ${gis_user}.TB_DIC_GIS_MARKET_TYPE A,
			(SELECT SCENE_ID,
			COUNT(ORDER_ID) USER_NUM,
			COUNT(DECODE(T.EXEC_STAT, 0, NULL, ORDER_ID)) EXEC_NUM,
			TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
			0,
			0,
			COUNT(DECODE(T.EXEC_STAT,
			0,
			NULL,
			ORDER_ID)) /
			COUNT(ORDER_ID)),
			4) * 100,
			'FM9999999990.00') || '%' EXE_LV,
			COUNT(DECODE(T.SUCC_FLAG, 1, ORDER_ID, NULL)) SUCC_NUM,
			TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
			0,
			0,
			COUNT(DECODE(T.SUCC_FLAG,
			1,
			ORDER_ID,
			NULL)) /
			COUNT(ORDER_ID)),
			4) * 100,
			'FM9999999990.00') || '%' SUCC_LV
			FROM ${sql_part_tab2} T
			WHERE
			<e:description>换为月表后去掉账期
			AND T.ORDER_DATE = TO_CHAR(SYSDATE, 'YYYYMMdd')
			</e:description>
			t.VILLAGE_ID = '${param.village_id}'
			GROUP BY SCENE_ID) C
			WHERE A.MKT_ID = C.SCENE_ID(+)
			UNION
			SELECT '',
			'全部',
			COUNT(ORDER_ID) USER_NUM,
			COUNT(DECODE(T.EXEC_STAT, 0, NULL, ORDER_ID)) EXEC_NUM,
			TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
			0,
			0,
			COUNT(DECODE(T.EXEC_STAT,
			0,
			NULL,
			ORDER_ID)) / COUNT(ORDER_ID)),
			4) * 100,
			'FM9999999990.00') || '%' EXE_LV,
			COUNT(DECODE(T.SUCC_FLAG, 1, ORDER_ID, NULL)) SUCC_NUM,
			TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
			0,
			0,
			COUNT(DECODE(T.SUCC_FLAG,
			1,
			ORDER_ID,
			NULL)) / COUNT(ORDER_ID)),
			4) * 100,
			'FM9999999990.00') || '%' SUCC_LV
			,
			9
			FROM ${sql_part_tab2} T
			WHERE
			<e:description>换为月表后去掉账期
			AND T.ORDER_DATE = TO_CHAR(SYSDATE, 'YYYYMMdd')
			</e:description>
			t.VILLAGE_ID = '${param.village_id}')
			ORDER BY ORD)
			WHERE ROWNUM < (${param.page} + 1) * 10)a)
			WHERE rn > ${param.page} * 10
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>

	<e:description>小区工作台营销清单 楼宇营销 汇总列表</e:description>
	<e:case value="marketing_build">
		<e:q4l var="dataList">
			<e:if condition="${param.page eq '0'}">
				SELECT ' ' SEGM_ID,
				'全部' BUILD_NAME,
				'0' ORD,
				COUNT(ORDER_ID) USER_NUM,
				COUNT(DECODE(T.EXEC_STAT, 0, NULL, ORDER_ID)) EXEC_NUM,
				TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
				0,
				0,
				COUNT(DECODE(T.EXEC_STAT,
				0,
				NULL,
				ORDER_ID)) / COUNT(ORDER_ID)),
				4) * 100,
				'FM9999999990.00') || '%' EXEC_LV,
				COUNT(DECODE(T.SUCC_FLAG, 1, ORDER_ID, NULL)) SUCC_NUM,
				TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
				0,
				0,
				COUNT(DECODE(T.SUCC_FLAG,
				1,
				ORDER_ID,
				NULL)) / COUNT(ORDER_ID)),
				4) * 100,
				'FM9999999990.00') || '%' SUCC_LV， 0 C_NUM,
				0 RN
				FROM ${sql_part_tab2} T
				WHERE
				<e:description>换为月表后去掉账期
				AND T.ORDER_DATE = TO_CHAR(SYSDATE, 'YYYYMMdd')
				</e:description>
				t.VILLAGE_ID = '${param.village_id}'
				<e:if condition="${!empty param.segm_code}">
					and t.add4 = '${param.segm_code}'
				</e:if>
				UNION ALL
			</e:if>
			SELECT *
			FROM (
			SELECT *
			FROM (SELECT A.*, ROWNUM RN
			FROM (SELECT *
			FROM (SELECT t.add4 segm_id,
			nvl(t.STAND_NAME_1,'无地址') BUILD_NAME,
			t.STAND_NAME_1 ORD,
			COUNT(ORDER_ID) USER_NUM,
			COUNT(DECODE(T.EXEC_STAT,
			0,
			NULL,
			ORDER_ID)) EXEC_NUM,
			TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
			0,
			0,
			COUNT(DECODE(T.EXEC_STAT,
			0,
			NULL,
			ORDER_ID)) /
			COUNT(ORDER_ID)),
			4) * 100,
			'FM9999999990.00') || '%' EXEC_LV,
			COUNT(DECODE(T.SUCC_FLAG,
			1,
			ORDER_ID,
			NULL)) SUCC_NUM,
			TO_CHAR(ROUND(DECODE(COUNT(ORDER_ID),
			0,
			0,
			COUNT(DECODE(T.SUCC_FLAG,
			1,
			ORDER_ID,
			NULL)) /
			COUNT(ORDER_ID)),
			4) * 100,
			'FM9999999990.00') || '%' SUCC_LV,
			COUNT(1) OVER() C_NUM
			FROM ${sql_part_tab2} T
			WHERE
			<e:description>换为月表后去掉账期
			AND T.ORDER_DATE =
			TO_CHAR(SYSDATE, 'YYYYMMdd')
			</e:description>
			t.VILLAGE_ID = '${param.village_id}'
			<e:if condition="${!empty param.segm_code}">
				and t.add4 = '${param.segm_code}'
			</e:if>
			GROUP BY add4, STAND_NAME_1)
			ORDER BY ORD) A
			WHERE ROWNUM <= (${param.page}+1)*10) A)
			WHERE RN > ${param.page}*10
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>

	<e:description>场景下的用户列表统计</e:description>
	<e:case value="getYXSumByScene">
		<e:q4l var="dataList">
			select
			count(order_id) YX_NUM,
			count(decode(t.exec_stat,0,null,order_id)) YX_EXECED,
			count(decode(t.exec_stat,0,order_id,null)) YX_UNEXEC
			from ${sql_part_tab2} t
			where
			<e:description>换为月表后去掉账期
			and t.ORDER_DATE = to_char(sysdate,'yyyymmdd')
			</e:description>
			t.village_id = '${param.village_id}'
			<e:if condition="${!empty param.scene_id && param.scene_id ne 'null'}">
				and t.SCENE_ID='${param.scene_id}'
			</e:if>
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>
	<e:description>场景下的用户列表</e:description>
	<e:case value="getYXListByScene">
		<e:q4l var="dataList">
			SELECT * FROM
			(select a.*,rownum rn from(
			select * from(
			SELECT T.ORDER_ID,
			T.SCENE_ID MKT_CAMPAIGN_ID,
			T.MKT_CONTENT SCENE_NAME,
			T.PROD_INST_ID TARGET_OBJ_NBR,
			SUBSTR(NVL(T.SERV_NAME, ' '), 1, 1) || '**' SERV_NAME,
			T.ACC_NBR,
			T.ADDRESS_ID,
			T.CONTACT_ADDS STAND_NAME_2,
			decode(succ_flag,1,'成功',DECODE(NVL(T.EXEC_STAT, 0), 0, ' ', '已执行')) EXE_STATE
			FROM ${sql_part_tab2} T
			WHERE
			<e:description>换为月表后去掉账期
			AND T.ORDER_DATE = to_char(sysdate,'yyyymmdd')
			</e:description>
			t.VILLAGE_ID = '${param.village_id}'
			<e:if condition="${!empty param.scene_id && param.scene_id ne 'null'}">
				AND T.SCENE_ID = '${param.scene_id}'
			</e:if>)
			where rownum <= ${param.page+1}*15)a
			)WHERE rn > ${param.page}*15
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>

	<e:description>楼宇下的用户列表统计</e:description>
	<e:case value="getYXSumByBuild">
		<e:q4l var="dataList">
			select
			count(order_id) YX_NUM,
			count(decode(t.exec_stat,0,null,order_id)) YX_EXECED,
			count(decode(t.exec_stat,0,order_id,null)) YX_UNEXEC
			from ${sql_part_tab2} t
			where
			<e:description>换为月表后去掉账期
			and t.ORDER_DATE = to_char(sysdate,'yyyymmdd')
			</e:description>
			t.village_id = '${param.village_id}'
			<e:if condition="${!empty param.segm_code}">
				and t.add4 = '${param.segm_code}'
			</e:if>
			<e:if condition="${!empty param.scene_id}">
				and t.SCENE_ID='${param.scene_id}'
			</e:if>
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>
	<e:description>楼宇下的用户列表</e:description>
	<e:case value="getYXListByBuild">
		<e:q4l var="dataList">
			SELECT * FROM
			(select a.*,rownum rn from(
			select * from(select t.ORDER_ID,
			t.SCENE_ID     MKT_CAMPAIGN_ID,
			t.MKT_CONTENT  SCENE_NAME,
			t.PROD_INST_ID TARGET_OBJ_NBR,
			substr(nvl(t.serv_name, ' '), 1, 1) || '**'SERV_NAME,
			t.ACC_NBR,
			t.ADDRESS_ID,
			nvl(t.segm_name_2,' ') SEGM_NAME_2,
			decode(nvl(t.exec_stat,0),0,' ','已执行') EXE_STATE
			from ${sql_part_tab2} t
			where
			<e:description>换为月表后去掉账期
			and t.ORDER_DATE = to_char(sysdate,'yyyymmdd')
			</e:description>
			t.village_id = '${param.village_id}'
			<e:if condition="${!empty param.segm_code}">
				and t.add4 = '${param.segm_code}'
			</e:if>
			order by t.add4
			)
			where rownum <= ${param.page+1}*15)a
			)WHERE rn > ${param.page}*15
		</e:q4l>${e:java2json(dataList.list)}
	</e:case>
	<e:description>小区营销 end</e:description>

	<e:case value="marketing_track">
        <e:q4l var="marketing_track">
		   select * from(
				select A.*,ROWNUM ROW_NUM from (
					SELECT  t.contact_adds,
					  t.order_id,
					  t.acc_nbr,
					  t.contact_contperson,
					  t.scene_id,
					  t.mkt_content,
					  t.mkt_reason,
					  t.order_date,
					  case when t.EXEC_TIME is null then ' ' else to_char(t.EXEC_TIME,'YYYY-MM-DD') end EXEC_TIME,
					  t.exec_desc
					  FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M aa, EDW.TB_MKT_ORDER_LIST@GSEDW t
					 where aa.prod_inst_id = t.prod_inst_id
					   and t.order_date like to_char(sysdate,'yyyymm') || '%'
					   <e:if condition="${!empty param.village_id}">
					   and aa.village_id = '${param.village_id}'
					   </e:if>
					   <e:if condition="${!empty param.segm_code  && param.segm_code ne '-1'}">
					   and aa.segm_id = '${param.segm_code}'
					   </e:if>
					   and t.exec_stat='${param.exec_stat}'
					 order by t.exec_time desc
				)A
			)
			where
			ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
        </e:q4l>${e: java2json(marketing_track.list) }
    </e:case>
	<e:case value="track_mun">
        <e:q4l var="track_mun">
        SELECT NVL(SUM(COUNT(DECODE(EXEC_STAT, 1, t.ORDER_ID))), 0) EXEC1,
		       NVL(SUM(COUNT(DECODE(EXEC_STAT, 2, t.ORDER_ID))), 0) EXEC2,
		       NVL(SUM(COUNT(DECODE(EXEC_STAT, 3, t.ORDER_ID))), 0) EXEC3,
		       NVL(SUM(COUNT(DECODE(EXEC_STAT, 4, t.ORDER_ID))), 0) EXEC4
		  FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M aa, EDW.TB_MKT_ORDER_LIST@GSEDW t
        where aa.prod_inst_id = t.prod_inst_id
              and t.order_date LIKE TO_CHAR(SYSDATE, 'yyyymm') || '%'
			  <e:if condition="${!empty param.village_id}">
              and aa.village_id = '${param.village_id}'
			  </e:if>
			  <e:if condition="${!empty param.segm_code  && param.segm_code ne '-1'}">
                   and aa.segm_id = '${param.segm_code}'
		      </e:if>
		GROUP BY SUBSTR(t.ORDER_DATE, 1, 6)

        </e:q4l>${e: java2json(track_mun.list) }
    </e:case>
	<e:case value="marketing_succ">
        <e:q4l var="marketing_succ">
			select * from(
				select A.*,ROWNUM ROW_NUM from (
				SELECT  nvl( t.succ_business, ' ') succ_business,
						case when t.succ_time is null then ' ' else to_char(t.succ_time,'YYYY-MM-DD') end succ_time,
						t.order_id,
						t.acc_nbr,
						t.contact_contperson,
						t.scene_id,
						t.mkt_content,
						t.mkt_reason,
						t.order_date,
						case when t.EXEC_TIME is null then ' ' else to_char(t.EXEC_TIME,'YYYY-MM-DD') end EXEC_TIME,
						t.exec_desc
				FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M aa, EDW.TB_MKT_ORDER_LIST@GSEDW t
					 where aa.prod_inst_id = t.prod_inst_id
					   and t.order_date like to_char(sysdate,'yyyymm') || '%'
					   <e:if condition="${!empty param.village_id}">
						   and aa.village_id = '${param.village_id}'
					   </e:if>
					   <e:if condition="${!empty param.segm_code && param.segm_code ne '-1'}">
						   and aa.segm_id = '${param.segm_code}'
					   </e:if>
					   and succ_flag='${param.succ_flag}'
					 order by t.succ_time desc
			)A
			)
			where
			ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
				</e:q4l>${e: java2json(marketing_succ.list) }
    </e:case>
	<e:case value="succ_num">
        <e:q4l var="succ_num">
			select count(1) num
			from (select count(t.order_id)
			 FROM ${gis_user}.TB_DW_GIS_SCENE_USER_LIST_M aa, EDW.TB_MKT_ORDER_LIST@GSEDW t
				where aa.prod_inst_id = t.prod_inst_id
				  and t.order_date LIKE TO_CHAR(SYSDATE, 'yyyymm') || '%'
				  <e:if condition="${!empty param.village_id}">
					   and aa.village_id = '${param.village_id}'
				  </e:if>
				  <e:if condition="${!empty param.segm_code  && param.segm_code ne '-1'}">
					   and aa.segm_id = '${param.segm_code}'
				  </e:if>
				  and succ_flag = '1'
				group by t.order_id)
        </e:q4l>${e: java2json(succ_num.list) }
    </e:case>

  <e:description>获取小区下的楼宇列表</e:description>
  <e:case value="getBuildInVillageList">
  	<e:q4l var="dataList">
		SELECT T2.SEGM_ID,
			   T2.STAND_NAME,
			   nvl(t3.zhu_hu_count, 0) zhu_hu_count,
			   NVL(t3.gz_h_use_cnt, 0) gz_h_use_cnt,
			   DECODE(NVL(GZ_H_USE_CNT, '0'),'0','0.00%', TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) / nvl(GZ_ZHU_HU_COUNT, 0), 4) * 100,'FM9990.00') || '%') use_lv,
			   DECODE(NVL(port_id_cnt, '0'),'0','0.00%',TO_CHAR(ROUND(NVL(use_port_cnt, 0) / nvl(port_id_cnt, 0), 4) * 100,'FM990.00') || '%') port_lv,
			   nvl(PORT_ID_CNT, 0) PORT_ID_CNT
		  FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 T2
		  LEFT JOIN ${gis_user}.Tb_Gis_Res_Info_Day T3
			ON T2.SEGM_ID = T3.latn_id
		 WHERE T2.VILLAGE_ID = '${param.village_id}'
		 <e:if condition="${!empty param.build_id && param.build_id ne '' && param.build_id ne '-1'}">
			  AND t2.SEGM_ID = '${param.build_id}'
		 </e:if>
		  <e:if condition="${!empty param.res_type && param.res_type ne '' && param.res_type ne ''}">
			 AND T3.FLG = 6
			 and T3.NO_RES_ARRIVE_CNT = '${param.res_type}'
		 </e:if>
		order by segm_id asc,segm_name asc
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取小区下的楼宇汇总信息</e:description>
  <e:case value="getBuildInVillageTotal">
  	<e:q4o var="dataObj">
		 select count(latn_id) ly_cnt,
				count(decode(no_res_arrive_cnt,1,latn_id)) res_arrive_cnt,
				count(decode(no_res_arrive_cnt,0,latn_id)) no_res_arrive_cnt
		  from ${gis_user}.tb_gis_res_info_day  where flg=6 and latn_id
		  in (  SELECT segm_id FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4 where village_id = '${param.village_id}'
			   <e:if condition="${!empty param.build_id && param.build_id ne ''  && param.build_id ne '-1'}">
				  AND SEGM_ID = '${param.build_id}'
			   </e:if>
		  )
  	</e:q4o>${e:java2json(dataObj)}
  </e:case>

  <e:description>获取小区下的楼宇用户质态列表</e:description>
  <e:case value="getBuildInVillageListByYhzt">
  	<e:q4l var="dataList">
		<e:description>废弃
		SELECT T.* FROM(
		select ROWNUM  ROW_NUM,
		COUNT(1) OVER() C_NUM,
		lev6_id village_id,
		address_id,
		address_desc stand_name,
		<e:description>脱敏</e:description>
		case when nvl(cust_name,' ')=' ' then ' ' else substr(nvl(cust_name,' '),1,1)||'**' end user_contact_person,
		acc_nbr,
		to_char(remove_date,'yyyy-mm-dd') remove_date,
		case when remove_date is null then '--'
		when trunc(months_between(sysdate,remove_date))/12 =0 then trunc(months_between(sysdate,remove_date))||'个月'
		when trunc(months_between(sysdate,remove_date))/12 >1 then  floor(trunc(months_between(sysdate,remove_date))/12) ||'年'
		end
		||  case when mod(trunc(months_between(sysdate,remove_date)),12)>0 then  mod(trunc(months_between(sysdate,remove_date)),12)||'个月'
		end owe_dur,
		t.stop_type,
		prod_inst_id,
		<e:description>
		${sql_part_scene_text} scene_text
		</e:description>
		<e:description>2018.11.29 类型关联码表</e:description>
		t.stop_type_name scene_text
		from
		(select t.*,t1.stop_type_name from
		${sql_part_tab1} t,
		PMART.T_DIM_LOST_TYPE@GSEDW t1,
		${gis_user}.TB_GIS_ADDR_INFO_ALL t2
		WHERE 1=1
		and t.address_id = t2.segm_id_2
		and t2.serial_no in(1,4)
		and t.stop_type = t1.stop_type
		<e:if condition="${!empty param.village_id && param.village_id ne ''}">
			AND lev6_id = '${param.village_id}'
		</e:if>
		<e:if condition="${!empty param.yhzt_type}">
			<e:description>选择 “沉默”
				t.stop_type='2'	表示 沉默用户 三个月内
				t.stop_type='3' 沉默用户 三个月以上
			</e:description>
			<e:if condition="${param.yhzt_type eq '3'}" var="cm_type">
				<e:description>选择 “三个月内”</e:description>
				<e:if condition="${param.stop_dura_type eq '1'}" var="cm_in_3">
					AND t.stop_type='2'
				</e:if>
				<e:description>选择 “三个月以上”</e:description>
				<e:else condition="${cm_in_3}">
					<e:if condition="${param.stop_dura_type eq '2'}" var="cm_more_3">
						AND t.stop_type='3'
					</e:if>
					<e:description>选择 “全部”</e:description>
					<e:else condition="${cm_in_3}">
						AND t.stop_type in ('2','3')
					</e:else>
				</e:else>
			</e:if>
			<e:description>选择 其他类型</e:description>
			<e:else condition="${cm_type}">
				<e:if condition="${param.yhzt_type eq '8'}" var="tj_flag">
					AND t.stop_type in ('8','9')
				</e:if>
				<e:else condition="${tj_flag}">
					AND t.stop_type='${param.yhzt_type}'
				</e:else>
			</e:else>
		</e:if>
		<e:if condition="${!empty param.segm_code && param.segm_code ne '' && param.segm_code ne '-1'}">
			AND t.address_id in (SELECT segm_id_2 FROM ${gis_user}.tb_gis_addr_info_all WHERE segm_id = '${param.segm_code}' )
		</e:if>
		<e:if condition="${param.yhzt_type ne '3'}" var="cm_type">
			<e:if condition="${!empty param.stop_dura_type}">
				<e:if condition="${param.stop_dura_type eq '1'}">
					AND months_between(sysdate,t.remove_date)<=3
				</e:if>
				<e:if condition="${param.stop_dura_type eq '2'}">
					AND months_between(sysdate,t.remove_date)>3
				</e:if>
			</e:if>
		</e:if>
			)t
		ORDER BY address_id
		)T
		WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
		</e:description>

		SELECT T.* FROM(
		select ROWNUM  ROW_NUM,
		COUNT(1) OVER() C_NUM,
		t.lev6_id village_id,
		t.address_id,
		t.address_desc stand_name,
		<e:description>脱敏</e:description>
		case when nvl(t.cust_name,' ')=' ' then ' ' else substr(nvl(t.cust_name,' '),1,1)||'**' end user_contact_person,
		t.acc_nbr,
		decode(t.stop_type,2,' ',3,' ',to_char(t.remove_date,'yyyy-mm-dd')) remove_date,
		case when t.stop_type in (2,3) then ' ' else (
		${gis_user}.DATE_DUR(t.remove_date,SYSDATE)) end owe_dur,
		t.stop_type,
		t.prod_inst_id,
		<e:description>
			${sql_part_scene_text} scene_text
		</e:description>
		<e:description>2018.11.29 类型关联码表</e:description>
		decode(t.stop_type,8,'欠停',9,'欠停',t.stop_type_name) scene_text
		from
		(
			select t.*,t1.stop_type_name from
			${sql_part_tab1} t,
			PMART.T_DIM_LOST_TYPE@GSEDW t1,
			${gis_user}.TB_GIS_ADDR_INFO_ALL t2
			WHERE 1=1
			and t.stop_type = t1.stop_type
			and t.address_id = t2.segm_id_2
			and t2.serial_no in(1,4)
			<e:if condition="${!empty param.village_id && param.village_id ne ''}">
				AND t.lev6_id = '${param.village_id}'
			</e:if>
			<e:if condition="${param.yhzt_type eq '0'}">
				AND t.stop_type = '${param.yhzt_type}'
			</e:if>
			<e:if condition="${param.yhzt_type eq '3'}">
				AND t.stop_type = '2'
			</e:if>
			<e:if condition="${param.yhzt_type eq '8'}">
				AND t.stop_type in ('8','9')
			</e:if>
			<e:if condition="${!empty param.segm_code && param.segm_code ne '' && param.segm_code ne '-1'}">
				AND t.address_id in (SELECT segm_id_2 FROM ${gis_user}.tb_gis_addr_info_all WHERE segm_id = '${param.segm_code}' )
			</e:if>
			<e:if condition="${!empty param.stop_dura_type}">
				<e:if condition="${param.stop_dura_type eq '1'}">
					AND months_between(sysdate,t.remove_date)<=3
				</e:if>
				<e:if condition="${param.stop_dura_type eq '2'}">
					AND (months_between(sysdate,t.remove_date)>3 and months_between(sysdate,t.remove_date)<=6)
				</e:if>
				<e:if condition="${param.stop_dura_type eq '3'}">
					AND (months_between(sysdate,t.remove_date)>6)
				</e:if>
			</e:if>
		)t
		ORDER BY t.address_id
		)T
		WHERE ROW_NUM > ${param.page * 15 } AND ROW_NUM <= ${(param.page + 1) * 15 }
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取小区下的楼宇用户质态汇总信息</e:description>
  <e:case value="getBuildInVillageTotalByYhzt">
  	 <e:q4o var="yhzt_num">
		 <e:if condition="${!empty param.village_id && param.village_id ne '' && (empty param.segm_code || param.segm_code eq '-1')}">
			 SELECT

			 <e:description>小区横幅</e:description>
			 B.GZ_H_USE_CNT,
			 B.GZ_H_USE_CNT ARRIVE_CNT_SUM,
			 lost_y_remove REMOVE_CNT_Y,
			 lost_y_stop STOP_CNT_Y,
			 lost_y_silent CM_CNT_Y,

			 <e:description>状态</e:description>
			 lost_y_total ARRIVE_CNT_Y,

			 LOST_3_TOTAL ARRIVE_CNT,
			 LOST_3_REMOVE REMOVE_CNT,
			 LOST_3_STOP STOP_CNT,
			 LOST_3_SILENT CM_CNT,

			 <e:description>小区工作台 概述 流失率</e:description>
			 CASE
			 WHEN NVL(B.GZ_H_USE_CNT, 0) = 0 THEN
			 '0.00%'
			 ELSE
			 TO_CHAR(ROUND(NVL(A.lost_y_total, 0) / B.GZ_H_USE_CNT, 4) * 100,
			 'FM9999999990.00') || '%'
			 END COMPETE_PERCENT,
			 CASE
			 WHEN NVL(B.GZ_H_USE_CNT, 0) = 0 THEN
			 0
			 ELSE
			 ROUND(NVL(A.lost_y_total, 0) / B.GZ_H_USE_CNT, 4) * 100
			 END COMPETE_PERCENT1
			 FROM
			 <e:description>
				 2018.9.11 表名替换 EDW.TB_VILLAGE_LOST@GSEDW A,
			 </e:description>
			 ${gis_user}.TB_hdz_VILLAGE_LOST A,
			 ${gis_user}.TB_GIS_RES_INFO_DAY B
			 WHERE A.VILLAGE_ID = B.LATN_ID
			 AND VILLAGE_ID = '${param.village_id}'
		 </e:if>
		 <e:if condition="${!empty param.segm_code && param.segm_code ne '' && param.segm_code ne '-1'}">
			 SELECT
			 count(1) ARRIVE_CNT_Y,
			 COUNT(CASE WHEN t.stop_type =0 THEN 1 ELSE NULL END) REMOVE_CNT_Y,
			 COUNT(CASE WHEN t.stop_type =8 when t.stop_type = 9 THEN 1 ELSE NULL END) STOP_CNT_Y,
			 COUNT(CASE WHEN t.stop_type =3 when t.stop_type = 2 THEN 1 ELSE NULL END) CM_CNT_Y
			 FROM ${sql_part_tab1} T
			 WHERE t.address_id in (SELECT segm_id_2 FROM ${gis_user}.tb_gis_addr_info_all WHERE segm_id = '${param.segm_code}' and serial_no in(1,4))
		 </e:if>
     </e:q4o>${e: java2json(yhzt_num) }
  </e:case>

	<e:case value="exec_update">
		<e:update var="num">
			insert into ${gis_user}.tb_market_exec_log values(
				sys_guid(),
				'${param.mkt_campaign_id}',
				'${param.prod_inst_id}',
				'${param.pa_date}',
				sysdate,
				'${sessionScope.UserInfo.LOGIN_ID}',
				'${param.exec_stat}',
				'${param.exec_desc}',
				'${param.contact_type}'
			)
		</e:update>${num}
	</e:case>
</e:switch>