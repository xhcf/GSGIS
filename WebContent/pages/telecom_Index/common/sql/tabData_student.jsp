<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="sql_part_tab_name1">
  <e:description>2018.9.11 表名更换 EDW.TB_MKT_OFFER_COMP2@GSEDW</e:description>
  ${gis_user}.TB_hdz_MKT_OFFER_COMP2
</e:set>
<e:set var="sql_part_tab_name2">
  <e:description>2018.9.11 表名更换 EDW.TB_MKT_OFFER_INFO@GSEDW</e:description>
  ${gis_user}.TB_HDZ_MKT_OFFER_INFO
</e:set>
<e:set var="sql_part_tab_name3">
  <e:description>2018.9.26 表名更换 EDW.TB_MKT_INFO@gsedw</e:description>
  ${gis_user}.TB_MKT_INFO
</e:set>
<e:set var="sql_part_tab_name4">
  <e:description>2018.9.26 表名更换 ${gis_user}.TB_HDZ_MKT_BILL_INFO</e:description>
  <e:description>2018.11.5 表名替换 EDW.TB_MKT_BILL_INFO@GSEDW</e:description>
  ${gis_user}.TB_HDZ_MKT_BILL_INFO
</e:set>
<e:set var="sql_part_tab_name5">
  ${gis_user}.TB_GIS_KD_RELATION_M
</e:set>
<e:set var="sql_part_tab_name6">
  ${gis_user}.TB_GIS_SCHOOL_USER_REF
</e:set>

<e:set var="sql_part_ids1">
  SELECT distinct b.prod_inst_id FROM ${sql_part_tab_name5} a,(select comp_inst_id,PROD_INST_ID from ${sql_part_tab_name1} where prod_inst_id = '${param.prod_inst_id}' AND rk = 1) b WHERE a.comp_inst_id = b.comp_inst_id
</e:set>

<e:set var="sql_part_ids2">
  SELECT DISTINCT prod_inst_Id FROM ${sql_part_tab_name1} WHERE comp_inst_id IN (
  SELECT comp_inst_id
  FROM ${sql_part_tab_name1}
  WHERE PROD_INST_ID = '${param.prod_inst_id}'
  AND RK = 1)
</e:set>

<e:switch value="${param.eaction}">

  <e:description>基本信息</e:description>
  <e:case value="getBaseInfo">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      <e:description>脱敏</e:description>
      case when NVL(T.SERV_NAME, '--')='--' then '--'
      else substr(T.SERV_NAME,1,1)||'**' end CUST_NAME,
      NVL(TO_CHAR(T.AGE), ' ') AGE,
      DECODE(T.SEX, '1', '男', '2', '女', '未知') AS SEX,
      <e:description>2018.10.22 号码脱敏</e:description>
      decode(t.USER_CONTACT_NBR,null,' ',nvl((substr(t.USER_CONTACT_NBR,0,3) || '******' || substr(t.USER_CONTACT_NBR,10,2)),'--')) USER_CONTACT_NBR,
      decode(t.USER_CONTACT_NBR,null,' ',t.USER_CONTACT_NBR) USER_CONTACT_NBR_CALL,
      NVL(T1.PROD_OFFER_NAME, ' ') PROD_OFFER_NAME,
      TO_CHAR(T.FINISH_DATE, 'YYYY') || '年' || TO_CHAR(T.FINISH_DATE, 'MM') || '月' ||
      TO_CHAR(T.FINISH_DATE, 'DD') || '日' 　FINISH_DATE,
      CASE
      WHEN T.INET_MONTH IS NULL THEN
      '--'
      WHEN t.inet_month / 12 = 1 THEN
      '1年'
      WHEN T.INET_MONTH / 12 > 1 THEN
      FLOOR(T.INET_MONTH / 12) || '年'
      END || CASE
      WHEN MOD(T.INET_MONTH, 12) > 0 THEN
      MOD(T.INET_MONTH, 12) || '个月'
      END INET_MONTH,
      NVL(T.CUST_MANAGER_NAME, ' ') CUST_MANAGER_NAME,
      decode(T.CUST_PHONE,null,'--',nvl((substr(T.CUST_PHONE,0,3) || '******' || substr(T.CUST_PHONE,10,2)),'--')) CUST_PHONE,
      NVL(T.USER_CONTACT_PERSON, ' ') USER_CONTACT_PERSON,
      <e:description>如果是当日派单</e:description>
      <e:if condition="${!empty param.is_yx}" var="is_yx">
        NVL(G.BRANCH_NAME, NVL(k.branch_name,' ')) BRANCH_NAME,
        NVL(GG.GRID_NAME,NVL(k.grid_name,' ')) GRID_NAME,
      </e:if>
      <e:description>如果不是当日派单</e:description>
      <e:else condition="is_yx">
        NVL( B.BRANCH_NAME, NVL(k.branch_name,' ')) BRANCH_NAME,
        NVL( B.GRID_NAME, NVL(k.grid_name,' ')) GRID_NAME,
      </e:else>
      NVL(B.VILLAGE_NAME, ' ') VILLAGE_NAME,
      NVL(T.ADDRESS_DESC, NVL(f.stand_name_2,' ')) ADDRESS_DESC,
      C.STOP_TYPE_NAME,
      T.PRODUCT_CD,
      nvl(T.ACC_NBR,' ') ACC_NBR,
      SUBSTR(NVL(T.CUST_STAR_LEVEL, ' '), 0, 2) CUST_STAR_LEVEL,
      nvl(LEV4_ID,k.branch_no) LEV4_ID,
      nvl(LEV5_ID,k.grid_id) LEV4_ID,
      nvl(LEV6_ID,j.village_id) LEV6_ID
      FROM
      ${sql_part_tab_name3} T
      LEFT JOIN (SELECT T7.PROD_INST_ID, T7.PROD_OFFER_NAME
      FROM ${sql_part_tab_name2}  T7,
      ${sql_part_tab_name1} T8
      WHERE T7.PROD_INST_ID = T8.PROD_INST_ID
      AND T7.COMP_INST_ID = T8.COMP_INST_ID) T1
      ON T1.PROD_INST_ID = T.PROD_INST_ID
      LEFT JOIN ${gis_user}.VIEW_DB_CDE_VILLAGE B
      ON T.LEV6_ID = B.VILLAGE_ID
      LEFT JOIN ${gis_user}.TB_DIC_GIS_STOP_TYPE C
      ON T.STOP_TYPE = C.STOP_TYPE
      LEFT JOIN ${gis_user}.TB_GIS_RELATION_D f
      ON t.prod_inst_id = f.prd_inst_id
      <e:if condition="${!empty param.is_yx}">
        LEFT JOIN EDW.TB_MKT_ORDER_LIST@GSEDW E
        ON T.PROD_INST_ID = E.PROD_INST_ID
        and E.ORDER_DATE = to_char(sysdate,'YYYYMMDD')
        LEFT JOIN (SELECT DISTINCT UNION_ORG_CODE, BRANCH_NAME
        FROM ${gis_user}.DB_CDE_GRID) G
        ON E.UNION_ORG_CODE = G.UNION_ORG_CODE
        LEFT OUTER JOIN (SELECT GRID_ID, GRID_NAME FROM ${gis_user}.DB_CDE_GRID) GG
        ON E.GRID_ID = GG.GRID_ID
      </e:if>
      LEFT JOIN SDE.TB_GIS_MAP_SEGM_LATN_MON k
      ON F.SEGM_ID = k.SEGM_ID
      LEFT JOIN ${gis_user}.tb_gis_village_addr4 h
      ON F.segm_id = h.segm_id
      LEFT JOIN ${gis_user}.tb_gis_village_edit_info j
      ON F.village_id = j.village_id
      WHERE T.PROD_INST_ID = '${param.prod_inst_id}'
      AND STATE_CD = '001'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>学生基本信息2</e:description>
  <e:case value="getBaseInfo2">
    <e:q4o var="dataObject">
      select nvl(a.fee,0) COMBO_VAL,
      nvl(to_char(a.end_date,'yyyy-mm-dd'),' ') COMBO_END_DATE,
      nvl(a.bed_name,' ') BED_NO,
      nvl(a.dept_name,' ') COLLEGE_NAME,
      nvl(a.grade_name,' ') GRADE_NAME,
      c.business_name
      from 
      (select * from ${gis_user}.tb_mkt_info 
      where prod_inst_id = '${param.prod_inst_id}'
      )d,
      ${gis_user}.tb_gis_school_user_ref a,
      ${gis_user}.TB_GIS_BUSINESS_ADDR4 b,
      ${gis_user}.TB_GIS_BUSINESS_BASE c
      where 
      d.address_id = a.segm_id_2
      and a.segm_id = b.segm_id
      and b.business_id = c.business_id
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>套餐信息</e:description>
  <e:case value="getComboInfo">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      nvl(T4.ACC_NBR,' ') ACC_NBR,
      nvl(PROD_OFFER_NAME,' ')PROD_OFFER_NAME,
      TO_CHAR(T.EFF_DATE, 'YYYY-MM-DD') EFF_DATE,
      TO_CHAR(T.EXP_DATE, 'YYYY-MM-DD') EXP_DATE
      FROM ${sql_part_tab_name2} T
      INNER JOIN ${sql_part_tab_name3} T4
      ON T.PROD_INST_ID = T4.PROD_INST_ID
      WHERE T.PROD_INST_ID = '938861697644'
      <e:description>
      IN
      (
      ${sql_part_ids2}
      )
      </e:description>
      and t4.STATE_CD = '001'
      ORDER BY T4.ACC_NBR DESC, EFF_DATE DESC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品汇总</e:description>
  <e:case value="getProduceSum">
    <e:q4l var="dataList">
      select
      /*+parallel (10)*/
      '<span>手机总流量 <span class="font_red">'||nvl(TO_CHAR(trunc(sum(NVL(FLOW, 0))/1024,2),'FM9999999990.00'),0)||'G' ||'</span></span> | <span>手机总通话时长<span class="font_red">' ||  nvl(to_char(round(sum(nvl(VOICE_DURA,0)),2),'FM9999999990'),0) || ' 分钟</span></span>' product_desc,
      0 orderDesc
      from ${sql_part_tab_name3} t1
      left join EDW.TB_MKT_BIZ_INFO@GSEDW t on t1.PROD_INST_ID=t.PROD_INST_ID
      where  t1.PROD_INST_ID in
      (
      select  /*+parallel (10)*/  distinct t2.PROD_INST_ID from
      ${sql_part_tab_name1} T2
      where comp_inst_id
      in (select   /*+parallel (10)*/  comp_inst_id from
      ${sql_part_tab_name1} T
      where  t.prod_inst_id='${param.prod_inst_id}' and rk=1)
      ) and PRODUCT_CD ='900000001'
      AND T1.ARRIVE_REMOVE_FLAG = '1' and t1.state_cd='001'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品使用</e:description>
  <e:case value="getUsedList">
    <e:q4l var="dataList">
      SELECT
      sum(CASE WHEN flag = 1 THEN old_charge ELSE 0 END) oc1,
      sum(CASE WHEN flag = 2 THEN old_charge ELSE 0 END) oc2,
      sum(CASE WHEN flag = 3 THEN old_charge ELSE 0 END) oc3,
      0 OC4,
      0 OC5,
      0 OC6,
      0 OC7,
      0 OC8,
      0 OC9,

      0 PRODUCT_ORD
      FROM
      (SELECT /*+parallel (10)*/
      nvl(SUM(V.OLD_CHARGE),0) OLD_CHARGE,
      1 flag
      FROM ${sql_part_tab_name4} V
      WHERE V.PROD_INST_ID = '${param.prod_inst_id}'
      <e:description>
      IN
      (
      ${sql_part_ids2}
      )
      </e:description>
      AND BILLING_MONTH = '${param.m1}'
      union all
      SELECT /*+parallel (10)*/
      nvl(SUM(V.OLD_CHARGE),0) OLD_CHARGE,
      2 flag
      FROM ${sql_part_tab_name4} V
      WHERE V.PROD_INST_ID = '${param.prod_inst_id}'
      <e:description>
        IN
        (
        ${sql_part_ids2}
        )
      </e:description>
      AND BILLING_MONTH = '${param.m2}'
      union all
      SELECT /*+parallel (10)*/
      nvl(SUM(V.OLD_CHARGE),0) OLD_CHARGE,
      3 flag
      FROM ${sql_part_tab_name4} V
      WHERE V.PROD_INST_ID = '${param.prod_inst_id}'
      <e:description>
        IN
        (
        ${sql_part_ids2}
        )
      </e:description>
      AND BILLING_MONTH = '${param.m3}')

      union all

      select

      sum(nvl(FLOW,0))  FLOW,
      sum(nvl(LAST_FLOW,0))  LAST_FLOW,
      0 oc3,

      sum(nvl(voice_dura,0))  voice_dura,
      sum(nvl(LAST_VOICE_DURA,0))  LAST_VOICE_DURA,
      0 oc6,

      sum(nvl(ONLINE_TIME,0))  ONLINE_TIME,
      sum(nvl(LAST_ONLINE_TIME,0))  LAST_ONLINE_TIME,
      0 oc9,

      PRODUCT_ORD
      from (
      SELECT /*+parallel (10)*/
      DECODE(T.VOICE_DURA,NULL,0,ROUND(T.VOICE_DURA, 0)) VOICE_DURA,
      DECODE(T.ONLINE_TIME,NULL,0,ROUND(NVL(T.ONLINE_TIME, 0),0)) ONLINE_TIME,
      DECODE(T.FLOW,NULL,0,ROUND(NVL(T.FLOW, 0) / 1024, 2)) FLOW,
      DECODE(T.LAST_VOICE_DURA,NULL,0,ROUND(T.LAST_VOICE_DURA, 0)) LAST_VOICE_DURA,
      DECODE(T.LAST_ONLINE_TIME,NULL,0,ROUND(T.LAST_ONLINE_TIME, 0)) LAST_ONLINE_TIME,
      DECODE(T.LAST_FLOW,NULL,0,ROUND(T.LAST_FLOW / 1024, 2)) LAST_FLOW,
      CASE
      WHEN PRODUCT_CD = '900000001' THEN
      1
      WHEN PRODUCT_CD = '999991020' OR PRODUCT_CD = '999991010' OR
      PRODUCT_CD = '999991030' OR PRODUCT_CD = '999991040' OR
      PRODUCT_CD = '201190253' THEN
      2
      WHEN PRODUCT_CD = '100004466' THEN
      3
      WHEN PRODUCT_CD = '999992010' THEN
      4
      END PRODUCT_ORD
      FROM ${sql_part_tab_name3} T1
      LEFT JOIN EDW.TB_MKT_BIZ_INFO@GSEDW T
      ON T1.PROD_INST_ID = T.PROD_INST_ID
      WHERE T1.PROD_INST_ID
      in ('500000099647','500000099872','500000100184','500000099608','500000099867','500000099764')

      and t1.STATE_CD = '001'
      )
      group by PRODUCT_ORD

    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品信息</e:description>
  <e:case value="getProduceList">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      nvl(T1.ACC_NBR,' ') ACC_NBR,
      DECODE(T.VOICE_DURA,NULL,' ',TO_CHAR(ROUND(T.VOICE_DURA, 0), 'FM9999999990') || '分钟') VOICE_DURA,
      DECODE(T.ONLINE_TIME,NULL,' ',TO_CHAR(ROUND(NVL(T.ONLINE_TIME, 0), 0), 'FM9999999990') || '分钟') ONLINE_TIME,
      DECODE(T.FLOW,NULL,' ',TO_CHAR(ROUND(NVL(T.FLOW, 0) / 1024, 2), 'FM9999999990.00') || 'G') FLOW,
      SMS_ROW,
      DECODE(T.LAST_VOICE_DURA,NULL,' ',TO_CHAR(ROUND(T.LAST_VOICE_DURA, 0), 'FM9999999990') || '分钟') LAST_VOICE_DURA,
      DECODE(T.LAST_ONLINE_TIME,NULL,' ',TO_CHAR(ROUND(T.LAST_ONLINE_TIME, 0), 'FM9999999990') || '分钟') LAST_ONLINE_TIME,
      DECODE(T.LAST_FLOW,NULL,' ',TO_CHAR(ROUND(T.LAST_FLOW / 1024, 2), 'FM9999999990.00') || 'G') LAST_FLOW,
      T.LAST_SMS_ROW,
      T1.PRODUCT_CD,
      CASE
      WHEN T1.EPON_TYPE = '2' THEN
      'ftth'
      WHEN T1.EPON_TYPE = '1' THEN
      'fttb'
      WHEN T1.EPON_TYPE = '0' THEN
      'dsl'
      ELSE
      '其他'
      END EPON_TYPE,
      T1.MT,
      CASE
      WHEN PRODUCT_CD = '900000001' THEN
      1
      WHEN PRODUCT_CD = '999991020' OR PRODUCT_CD = '999991010' OR
      PRODUCT_CD = '999991030' OR PRODUCT_CD = '999991040' OR
      PRODUCT_CD = '201190253' THEN
      2
      WHEN PRODUCT_CD = '100004466' THEN
      3
      WHEN PRODUCT_CD = '999992010' THEN
      4
      END PRODUCT_ORD
      FROM ${sql_part_tab_name3} T1
      LEFT JOIN EDW.TB_MKT_BIZ_INFO@GSEDW T
      ON T1.PROD_INST_ID = T.PROD_INST_ID
      WHERE T1.PROD_INST_ID
      = '${param.prod_inst_id}'
      <e:description>
        IN
        (
        ${sql_part_ids2}
        )
      </e:description>
      and t1.STATE_CD = '001'
      ORDER BY PRODUCT_ORD
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>收入信息_arpu arpu合计</e:description>
  <e:case value="getIncomeSum1">
    <e:q4l var="dataList">
      SELECT /*+parallel (20)*/
      nvl(SUM(W.SERV_ARPU),0) SERV_ARPU
      FROM EDW.TB_MKT_BIL_ARPU@GSEDW W
      WHERE W.PROD_INST_ID IN
      (SELECT /*+parallel (20)*/
      DISTINCT T2.PROD_INST_ID
      FROM ${sql_part_tab_name1} T2
      WHERE COMP_INST_ID IN
      (SELECT /*+parallel (20)*/
      COMP_INST_ID
      FROM ${sql_part_tab_name1} T
      WHERE T.PROD_INST_ID = '${param.prod_inst_id}' AND RK = 1))
      AND W.STAT_MONTH = '${param.acct_month}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>收入汇总 费用合计 赠金合计</e:description>
  <e:case value="getIncomeSum2">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      nvl(SUM(V.OLD_CHARGE),0) OLD_CHARGE,
      nvl(SUM(V.NO_INVOICE_AMOUNT),0) NO_INVOICE_AMOUNT

      FROM ${sql_part_tab_name4} V
      WHERE V.PROD_INST_ID IN
      (
      ${sql_part_ids2}
      )
      AND BILLING_MONTH = '${param.acct_month}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>收入信息 列表</e:description>
  <e:case value="getIncomeList">
    <e:q4l var="dataList">
      SELECT /*+PARALLEL (20) */
      nvl(V.ACC_NBR,' ') ACC_NBR,
      V.ACCT_ITEM_TYPE_NAME,
      SUM(V.OLD_CHARGE) OLD_CHARGE
      <e:description>
        <e:if condition="${!empty param.acct_month}" var="empty_month">
          FROM EDW.TB_MKT_BILL_INFO_${param.acct_month}@GSEDW V
        </e:if>
        <e:else condition="${empty_month}">
          FROM ${sql_part_tab_name4} V
        </e:else>
      </e:description>
      FROM ${sql_part_tab_name4} V
      WHERE V.PROD_INST_ID IN
      (
      ${sql_part_ids2}
      )
      <e:if condition="${!empty param.acct_month}" var="empty_month">
        AND BILLING_MONTH = '${param.acct_month}'
      </e:if>
      <e:else condition="${empty_month}">
        AND BILLING_MONTH = (select max(USED_VIEW) as val from edw.tb_cde_process_para@gsedw t WHERE T.USERD_NAME='TB_MKT_BILL_INFO')
      </e:else>
      GROUP BY V.ACC_NBR, V.ACCT_ITEM_TYPE_NAME
      ORDER BY SUM(V.OLD_CHARGE) DESC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>