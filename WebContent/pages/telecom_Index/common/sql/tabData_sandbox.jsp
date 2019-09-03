<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:switch value="${param.eaction}">

  <e:description>竞争沙盘 begin</e:description>

  <e:description>echarts地图，使用了viewPlane_tab_info_collect_action中province方法</e:description>

  <e:description>省级地图左下角表格，使用了viewPlane_tab_info_collect_action中province方法</e:description>

  <e:description>市级地图左下角表格</e:description>
  <e:case value="LBTable_city">
    <e:q4l var="dataList">
      SELECT A.LATN_ID,
      A.LATN_NAME,
      '' BUREAU_NO,
      LATN_NAME BUREAU_NAME,
      A.COLLECT_NUM,
      A.DQ_1_COUNT + DQ_2_COUNT DQ_COUNT
      FROM (SELECT A.LATN_ID,
      A.LATN_NAME,
      NVL(SUM(A.NUM), 0) COLLECT_NUM,
      NVL(SUM(A.DQ_1_COUNT), 0) DQ_1_COUNT,
      NVL(SUM(A.DQ_2_COUNT), 0) DQ_2_COUNT
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT A
      WHERE A.LATN_ID = '${param.city_id1}'
      and branch_type in( 'a1','b1')
      GROUP BY A.LATN_ID, A.LATN_NAME) A
      UNION ALL
      SELECT A.LATN_ID,
      A.LATN_NAME,
      A.BUREAU_NO,
      A.BUREAU_NAME,
      A.COLLECT_NUM,
      A.DQ_1_COUNT + DQ_2_COUNT DQ_COUNT
      FROM (SELECT A.LATN_ID,
      A.LATN_NAME,
      A.BUREAU_NO,
      A.BUREAU_NAME,
      NVL(SUM(A.NUM), 0) COLLECT_NUM,
      NVL(SUM(A.DQ_1_COUNT), 0) DQ_1_COUNT,
      NVL(SUM(A.DQ_2_COUNT), 0) DQ_2_COUNT
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT A
      WHERE A.LATN_ID = '${param.city_id1}'
      and branch_type in( 'a1','b1')
      GROUP BY A.LATN_ID, A.LATN_NAME, A.BUREAU_NO, A.BUREAU_NAME) A
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>支局左下角表格</e:description>
  <e:case value="LBTable_sub">
    <e:q4l var="dataList">
      SELECT '0' GRID_ID,
      BRANCH_NAME GRID_NAME,
      SUM(NUM) COLLECT_NUM,
      SUM(ZHU_HU_COUNT) ZHU_HU_COUNT,
      SUM(DQ_1_COUNT) DQ_1_COUNT,
      SUM(DQ_2_COUNT) DQ_2_COUNT,
      SUM(DQ_1_COUNT)+SUM(DQ_2_COUNT) DQ_COUNT,
      CASE
      WHEN SUM(ZHU_HU_COUNT) = 0 THEN
      '--'
      ELSE
      ROUND(SUM(NUM) / SUM(ZHU_HU_COUNT), 4) * 100 || '%'
      END COLLECT_V
      FROM ${gis_user}.TB_GIS_GRID_COLLECT
      WHERE UNION_ORG_CODE = '${param.sub_id}'
      GROUP BY BRANCH_NAME
      UNION
      SELECT GRID_ID,
      GRID_NAME,
      NUM COLLECT_NUM,
      ZHU_HU_COUNT,
      DQ_1_COUNT,
      DQ_2_COUNT,
      DQ_1_COUNT+DQ_2_COUNT DQ_COUNT,
      CASE
      WHEN ZHU_HU_COUNT = 0 THEN
      '--'
      ELSE
      ROUND(NUM / ZHU_HU_COUNT, 4) * 100 || '%'
      END COLLECT_V
      FROM ${gis_user}.TB_GIS_GRID_COLLECT
      WHERE UNION_ORG_CODE ='${param.sub_id}'
      ORDER BY GRID_ID
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>网格左下角表格</e:description>
  <e:case value="LBTable_grid">
    <e:q4l var="dataList">
      SELECT GRID_ID,
      GRID_NAME,
      NUM COLLECT_NUM,
      ZHU_HU_COUNT,
      DQ_1_COUNT,
      DQ_2_COUNT,
      DQ_1_COUNT+DQ_2_COUNT DQ_COUNT,
      CASE
      WHEN ZHU_HU_COUNT = 0 THEN
      '--'
      ELSE
      ROUND(NUM / ZHU_HU_COUNT, 4) * 100 || '%'
      END COLLECT_V
      FROM ${gis_user}.TB_GIS_GRID_COLLECT
      WHERE GRID_ID ='${param.grid_id}'
      ORDER BY GRID_ID
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取收集过信息的标准地址id</e:description>
  <e:case value="getCollectedStandard">
    <e:q4l var="dataList">
      select DISTINCT c.resid,
      CASE WHEN (
      to_char(kd_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(itv_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date1,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date2,'yyyymm')=to_char(SYSDATE,'yyyymm')
      )THEN 1 ELSE 0 END dq1,
      CASE WHEN (
      to_char(kd_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(itv_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date1,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date2,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      )THEN 2 ELSE 0 END dq2
      from (SELECT * FROM ${gis_user}.TB_GIS_ADDR_OTHER_COLLECT t WHERE t.contact_person IS NOT NULL AND t.contact_nbr IS NOT NULL) a,sde.map_addr_segm_${param.city_id} c
      where a.segm_id = c.resid
      and rownum < 2000
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局的信息收集情况</e:description>
  <e:case value="getSubInfoCollectSummay">
    <e:q4o var="dataObject">
      SELECT
      BRANCH_NAME,
      NVL(SUM(A.NUM), 0) COLLECT_NUM,
      NVL(SUM(A.ZHU_HU_COUNT), 0) ZHU_HU_COUNT,
      NVL(SUM(A.DQ_1_COUNT), 0) DQ_1_COUNT,
      NVL(SUM(A.DQ_2_COUNT), 0) DQ_2_COUNT,
      NVL(SUM(A.DQ_1_COUNT), 0)+NVL(SUM(A.DQ_2_COUNT), 0) DQ_COUNT,
      TRIM(TO_CHAR(NVL(ROUND(SUM(A.NUM) / SUM(A.ZHU_HU_COUNT), 4) * 100, 0),
      '990.90')) COLLECT_V
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT A
      WHERE a.union_org_code = '${param.union_org_code}'
      GROUP BY BRANCH_NAME
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>获取网格的信息收集情况</e:description>
  <e:case value="getGridInfoCollectSummay">
    <e:q4o var="dataObject">
      SELECT
      grid_name,
      NVL(A.NUM, 0) COLLECT_NUM,
      NVL(A.ZHU_HU_COUNT, 0) ZHU_HU_COUNT,
      NVL(A.DQ_1_COUNT, 0) DQ_1_COUNT,
      NVL(A.DQ_2_COUNT, 0) DQ_2_COUNT,
      NVL(A.DQ_1_COUNT, 0)+NVL(A.DQ_2_COUNT, 0) DQ_COUNT,
      TRIM(TO_CHAR(NVL(ROUND(A.NUM / A.ZHU_HU_COUNT, 4) * 100, 0),
      '990.90')) COLLECT_V
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT a WHERE grid_id = (
        SELECT grid_id FROM ${gis_user}.db_cde_grid
        WHERE grid_union_org_code =
        (SELECT station_no FROM ${gis_user}.spc_branch_station WHERE station_id = '${param.report_to_id}')
      )
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>获取标准地址的信息收集情况</e:description>
  <e:case value="getStandardInfoCollectSummary">
    <e:q4o var="dataObject">
      SELECT COUNT(CASE WHEN contact_person  IS NOT NULL AND contact_nbr  IS NOT NULL THEN 1 ELSE NULL END ) COUNT,
      count(
      CASE WHEN
      to_char(kd_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(itv_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date1,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(phone_dq_date2,'yyyymm')=to_char(SYSDATE,'yyyymm')
      OR
      to_char(kd_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(itv_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date1,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      OR
      to_char(phone_dq_date2,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
      THEN 1 ELSE null END
      ) dq_count FROM ${gis_user}.TB_GIS_ADDR_OTHER_COLLECT t WHERE segm_id = '${param.add4}'
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>获取多个标准地址的信息收集情况</e:description>
  <e:case value="getStandardInfoCollectSummarys">
    <e:q4o var="dataObject">
      SELECT COUNT(CASE WHEN contact_person  IS NOT NULL AND contact_nbr  IS NOT NULL THEN 1 ELSE NULL END ) COUNT,
        count(
        CASE WHEN
          to_char(kd_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(itv_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date1,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(phone_dq_date2,'yyyymm')=to_char(SYSDATE,'yyyymm')
          OR
          to_char(kd_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(itv_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date1,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
          OR
          to_char(phone_dq_date2,'yyyymm')=to_char(add_months(SYSDATE,1),'yyyymm')
        THEN 1 ELSE null END
      ) dq_count FROM ${gis_user}.TB_GIS_ADDR_OTHER_COLLECT t WHERE segm_id in (${param.resids})
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>通过网格资源id获取网格grid_union_org_code</e:description>
  <e:case value="getGridUnionOrgCodeByReporttoid">
    <e:q4o var="dataObject">
      select station_no from ${gis_user}.SPC_BRANCH_STATION where station_id = '${param.reporttoid}'
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>竞争沙盘 end</e:description>

  <e:description>考核统计 日</e:description>
  <e:case value="getKHIndex_day">
    <e:q4l var="dataList">
      select * from
      (
      select
      '0' order_date,
      count(0) total_count,
      sum(case when t.EXEC_STAT <> 0 then 1 else 0 end)||'' num_1,
      case when count(0) = 0 then '0.00%' else to_char(sum(case when t.EXEC_STAT <> 0 then 1 else 0 end)/count(0)*100,'FM99999999990.00')||'%' end rate_1,
      sum(case when t.SUCC_FLAG is not null then 1 else 0 end)||'' num_2,
      case when count(0) = 0 then '0.00%' else to_char(sum(case when t.SUCC_FLAG is not null then 1 else 0 end)/count(0)*100,'FM99999999990.00')||'%' end rate_2
      from ${gis_user}.TB_MKT_ORDER_LIST t
      where 1=1
      and t.union_org_code='${param.union_org_code}'
      <e:if condition="${!empty param.grid_id}">
        and t.grid_id = '${param.grid_id}'
      </e:if>
      and substr(t.order_date,1,6)=to_char(add_months(sysdate,-1),'yyyymm')
      UNION ALL
      select
      substr(t1.day_code,7,2) order_date,
      count(t2.order_id) total_count,
      case when count(t2.order_id)=0 then '--' else sum(case when t2.EXEC_STAT <> 0 then 1 else 0 end)||'' end num_1,
      case when count(t2.order_id) = 0 then '--' else to_char(sum(case when t2.EXEC_STAT <> 0 then 1 else 0 end)/count(t2.order_id)*100,'FM99999999990.00')||'%' end rate_1,
      case when count(t2.order_id)=0 then '--' else sum(case when t2.SUCC_FLAG is not null then 1 else 0 end)||'' end num_2,
      case when count(t2.order_id) = 0 then '--' else to_char(sum(case when t2.SUCC_FLAG is not null then 1 else 0 end)/count(t2.order_id)*100,'FM99999999990.00')||'%' end rate_2
      from ${gis_user}.tb_dim_time t1
      left join ${gis_user}.TB_MKT_ORDER_LIST t2 on t2.order_date=t1.day_code
      and t2.union_org_code='${param.union_org_code}'
      <e:if condition="${!empty param.grid_id}">
        and t2.grid_id = '${param.grid_id}'
      </e:if>
      where 1=1
      and t1.month_code=to_char(add_months(sysdate,-1),'yyyymm')
      group by substr(t1.day_code,7,2)
      )
      order by order_date asc
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>考核统计 月</e:description>
  <e:case value="getKHIndex_month">
    <e:q4l var="dataList">
      SELECT SUBSTR(T1.DAY_CODE, 1, 6) ORDER_DATE,
      COUNT(T2.ORDER_ID) TOTAL_COUNT,
      CASE
      WHEN COUNT(T2.ORDER_ID) = 0 THEN
      '--'
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
      '--'
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
      '--'
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
      '--'
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
      LEFT JOIN ${gis_user}.TB_MKT_ORDER_LIST T2
      ON T2.ORDER_DATE = T1.DAY_CODE
      AND T2.UNION_ORG_CODE = '${param.union_org_code}'
      <e:if condition="${!empty param.grid_id}">
        and t2.grid_id = '${param.grid_id}'
      </e:if>
      WHERE 1 = 1
      AND T1.MONTH_CODE BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMM') AND
      TO_CHAR(SYSDATE, 'YYYYMM')
      GROUP BY SUBSTR(T1.DAY_CODE, 1, 6)
      ORDER BY ORDER_DATE DESC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>当日派单 begin</e:description>
  <e:case value="getYXlistToday">
    <e:q4l var="dataList">
      select
      t.prod_inst_id,
      t.order_id,
      t.acc_nbr,
      t.contact_contperson,
      t.scene_id,
      t2.scene_name,
      t.mkt_content,
      t.mkt_reason,
      t.contact_adds,
      t.order_date
      from ${gis_user}.TB_MKT_ORDER_LIST t
      left join ${gis_user}.tb_dim_scene_type t2 on t2.scene_id=t.scene_id
      where t.exec_stat=0
      and t.union_org_code='${param.union_org_code}'
      <e:if condition="${!empty param.grid_id}">
        and t.grid_id = '${param.grid_id}'
      </e:if>
      and t.order_date=to_char(sysdate,'YYYYMMDD')
      order by t.order_date asc
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
  <e:description>当日派单 end</e:description>

  <e:description>已废弃，现使用划小提供的接口</e:description>
  <e:case value="executeOrder">
    <e:update>
      update ${gis_user}.TB_MKT_ORDER_LIST set exec_time = sysdate,exec_staff = '${sessionScope.UserInfo.LOGIN_ID}',exec_stat = '${param.exec_stat}',exec_desc = '${param.exec_desc}' where prod_inst_id = '${param.prod_inst_id}'
    </e:update>
  </e:case>

  <e:description>获取营销术语</e:description>
  <e:case value="getMktReasonByOrderId">
    <e:q4o var="dataObject">
      SELECT DISTINCT mkt_reason FROM ${gis_user}.view_gis_order_list_tmp t
      WHERE t.prod_inst_id = '${param.prod_inst_id}'
      and t.scene_id = '${param.scene_id}'
      <e:if condition="${empty param.is_track}">
        and t.order_date = to_char(sysdate,'yyyymm')
      </e:if>
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>销售品推荐</e:description>
  <e:case value="getMktProduceAdvice">
    <e:q4o var="dataObject">
      SELECT * FROM gis_data.tb_gis_dic_wxltc WHERE tc_fee >'${param.arpu}' AND ROWNUM = 1
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="executeOrderGet">
    <e:q4o var="lastMonth">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '1'
    </e:q4o>
    <e:q4l var="dataObject">
    select
        t.prod_inst_id prod_inst_id,
        nvl(a.cust_name,' ')cust_name,
        nvl(a.age,0)age,
        nvl(a.finish_date,' ')finish_date,
        nvl(a.main_offer_name,' ')main_offer_name,
        nvl(a.amount,0)amount,
        <e:description>2018.10.22 号码脱敏</e:description>
        substr(NVL(a.USER_CONTACT_NBR, ' '),0,3)||'******'||SUBSTR(NVL(a.USER_CONTACT_NBR, ' '),10,2) USER_CONTACT_NBR,
        nvl(a.stand_name,' ')stand_name,
        round(nvl(byte_all_last,0)/1024,2) ll_last_month,
        round(nvl(byte_all,0)/1024,2) ll_this_month
    from edw.tb_mkt_order_list@gsedw t, ${gis_user}.TB_GIS_USER_INFO_M a
    where t.prod_inst_id = a.prod_inst_id
    AND A.ACCT_MONTH = '${lastMonth.VAL }'
    AND ORDER_DATE = TO_CHAR(SYSDATE, 'YYYYMMDD')
    and a.prod_inst_Id = '${param.prod_inst_id}'
    </e:q4l>${e:java2json(dataObject.list)}
  </e:case>

  <e:case value="executeOrderHistory">
    <e:q4l var="dataList">
    select
	     t.exec_time EXEC_DATE,
	     e.user_name executor,
	     case to_char(t.contact_type)
	     when '1' then '电话'
	     when '2' then '上门'
	     when '3' then '门店'
	     else ''
	     end contact_type,
	     case to_char(t.exec_stat)
	     when '1' then '有意向'
	     when '2' then '同意办理'
	     when '3' then '不需要'
	     when '4' then '无法联系'
	     else ''
	     end exec_stat,
	     t.exec_desc exec_desc
      from edw.tb_mkt_order_exec_his@gsedw t
      left join
      e_user e
      on  t.exec_staff=e.login_id
      where  t.prod_inst_id='${param.prod_inst_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
 <e:case value="Village_edit">
    <e:q4l var="Village_edit">
   select b.*,user_name from(
   select
   		t.VILLAGE_NAME,
        t.branch_name,
        t.grid_name,
        t.creater,
        t.build_sum,
        t.zhu_hu_sum,
        t.wideband_num,
        nvl(t.village_gm,-1) village_gm,
        NVL(t.village_ru_rate,0) village_ru_rate,
        nvl(t.village_xf,-1) village_xf,
        nvl(t.village_value,-1) village_value,
        nvl(t.village_label,' ') village_label,
        c.segm_id, c.segm_name, c.stand_name,
        to_char(t.create_time,'yyyy-mm-dd') create_time,
        position,
        nvl(cm_optical_fiber,0) cm_optical_fiber,
        nvl(cu_optical_fiber,0) cu_optical_fiber,
        nvl(sarft_optical_fiber,0) sarft_optical_fiber,
        nvl(other_optical_fiber,0) other_optical_fiber,
        nvl(wideband_in,0) wideband_in,
        nvl(cm_optical_fiber,0)+nvl(cu_optical_fiber,0)+nvl(sarft_optical_fiber,0)+nvl(other_optical_fiber,0)+nvl(wideband_in,0) line_cnt,
        grid_id_2
     from
        ${gis_user}.tb_gis_village_edit_info t,${gis_user}.tb_gis_village_addr4 c
where t.village_id='${param.village_id}'
		and t.village_id = c.village_id
		and t.vali_flag = 1)b left join ${easy_user}.e_user e on b.creater = e.login_id
    </e:q4l>${e:java2json(Village_edit.list)}
  </e:case>
</e:switch>
