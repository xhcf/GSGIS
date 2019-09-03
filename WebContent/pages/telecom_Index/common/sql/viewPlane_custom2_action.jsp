<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="product_type">
  CASE
  WHEN A.PRODUCT_CD = '900000001' THEN
  '手机'
  WHEN A.PRODUCT_CD = '100004466' THEN
  '电视'
  WHEN A.PRODUCT_CD in ('999991020','999991010','999991030','999991040') THEN
  '宽带'
  WHEN A.PRODUCT_CD in ('999992090','999992010','999992140','999992130','100000000','999992020','999992040','999992070','999992150','999992080','999992100','999992030','999992050','999992060','999992110','999992120') THEN
  '固话'
  ELSE
  ' '
  END PRODUCT_TYPE
</e:set>
<e:set var="product_cd_pool">
  ('999991020','999991010','999991030','999991040','100004466','900000001','999992090','999992010','999992140','999992130','100000000','999992020','999992040','999992070','999992150','999992080','999992100','999992030','999992050','999992060','999992110','999992120')
</e:set>
<e:set var="product_ord">
  CASE
  WHEN A.PRODUCT_CD in ('999991020','999991010','999991030','999991040') THEN '1'<e:description>宽带</e:description>
  WHEN A.PRODUCT_CD = '100004466' THEN '2'<e:description>电视</e:description>
  WHEN A.PRODUCT_CD = '900000001' THEN '3'<e:description>移动</e:description>
  WHEN A.PRODUCT_CD in ('999992090','999992010','999992140','999992130','100000000','999992020','999992040','999992070','999992150','999992080','999992100','999992030','999992050','999992060','999992110','999992120') THEN '4'<e:description>固话</e:description>
  ELSE '5'
  END product_ord
</e:set>
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

  <e:description>产品列表</e:description>
  <e:case value="prod_list">
    <e:q4l var="dataList">
      SELECT /*+PARALLEL (20) */
      '产品列表' a,
      <e:description>脱敏</e:description>
      case when NVL(SERV_NAME, '--')='--' then '--'
      else substr(SERV_NAME,1,1)||'**' end CUST_NAME,
      NVL(ACC_NBR, '--') ACC_NBR,
      CUST_ID,
      '宽带' PRODUCT_TYPE,
      PROD_INST_ID,
      b.stop_type_name scene_text
      FROM ${sql_part_tab_name3} T,
      ${gis_user}.TB_DIC_GIS_STOP_TYPE b
      WHERE (PRODUCT_CD = '999991020' OR PRODUCT_CD = '999991010' OR
      PRODUCT_CD = '999991030' OR PRODUCT_CD = '999991040' OR
      PRODUCT_CD = '201190253')
      AND ADDRESS_ID = '${param.segment_id }'
      AND STATE_CD = '001'
      AND ARRIVE_REMOVE_FLAG = '1'
      AND t.stop_type = b.stop_type
      ORDER BY PROD_INST_ID
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>基本信息</e:description>
  <e:case value="baseInfo">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      '基本信息' a,
      CASE
      WHEN NVL(T.SERV_NAME, '--') = '--' THEN
      '--'
      ELSE
      SUBSTR(T.SERV_NAME, 1, 1) || '**'
      END CUST_NAME,
      NVL(TO_CHAR(T.AGE), ' ') AGE,
      DECODE(T.SEX, '1', '男', '2', '女', '未知') AS SEX,
      DECODE(t.USER_CONTACT_NBR,
      NULL,
      ' ',
      NVL((SUBSTR(t.USER_CONTACT_NBR, 0, 3) || '******' ||
      SUBSTR(t.USER_CONTACT_NBR, 10, 2)),
      '--')) USER_CONTACT_NBR,
      TO_CHAR(T.FINISH_DATE, 'YYYY') || '年' || TO_CHAR(T.FINISH_DATE, 'MM') || '月' ||
      TO_CHAR(T.FINISH_DATE, 'DD') || '日' 　FINISH_DATE,
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
      NVL(T.CUST_MANAGER_NAME, ' ') CUST_MANAGER_NAME,
      DECODE(T.CUST_PHONE,
      NULL,
      '--',
      NVL((SUBSTR(T.CUST_PHONE, 0, 3) || '******' ||
      SUBSTR(T.CUST_PHONE, 10, 2)),
      '--')) CUST_PHONE,
      NVL(T.USER_CONTACT_PERSON, ' ') USER_CONTACT_PERSON,
      NVL(T.ADDRESS_DESC, NVL(E.STAND_NAME_2, NVL(g.contact_adds,' '))) ADDRESS_DESC,
      T.PRODUCT_CD,
      NVL(T.ACC_NBR, ' ') ACC_NBR,
      SUBSTR(NVL(T.CUST_STAR_LEVEL, ' '), 0, 2) CUST_STAR_LEVEL,
      decode(d.is_sm,1,'是','否') is_sm,
      c.stop_type_name
      FROM ${sql_part_tab_name3} T
      left join
      ${gis_user}.TB_GIS_CUST_INFO_D d
      ON T.PROD_INST_ID = D.PROD_INST_ID
      LEFT JOIN
      ${gis_user}.TB_DIC_GIS_STOP_TYPE c
      ON T.STOP_TYPE = C.STOP_TYPE
      LEFT JOIN
      ${gis_user}.TB_GIS_RELATION_D e
      ON t.prod_inst_id = e.prd_inst_id
      LEFT JOIN EDW.TB_MKT_ORDER_LIST@GSEDW g
      ON t.PROD_INST_ID = g.PROD_INST_ID
      WHERE T.PROD_INST_ID ='${param.prod_inst_id}'
      AND t.STATE_CD = '001'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品构成</e:description>
  <e:case value="prod_constuct">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      '产品构成' a,
      '<span class=''value''>宽带【' || nvl(SUM(CASE
      WHEN PRODUCT_CD = '999991020' OR PRODUCT_CD = '999991010' OR
      PRODUCT_CD = '999991030' OR PRODUCT_CD = '999991040' OR
      PRODUCT_CD = '201190253' THEN
      1
      ELSE
      0
      END),0) || '】</span><span class=''value''>移动【' || nvl(SUM(CASE
      WHEN PRODUCT_CD = '900000001' THEN
      1
      ELSE
      0
      END),0) || '】</span><span class=''value''>电视【' ||
      nvl(SUM(CASE
      WHEN PRODUCT_CD = '100004466' THEN
      1
      ELSE
      0
      END),0) || '】</span><span class=''value''>固话【' || nvl(SUM(CASE
      WHEN PRODUCT_CD = '999992010' THEN
      1
      ELSE
      0
      END),0) || '】</span>' PRODUCT_STRUCTURE
      FROM ${sql_part_tab_name3} T
      WHERE T.PROD_INST_ID IN
      (
        ${sql_part_ids2}
      )
      and t.STATE_CD = '001'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>基本信息_支局、网格、小区名称 已废弃</e:description>
  <e:case value="baseInfo_org_name">
    <e:q4l var="dataList">
      SELECT DISTINCT branch_name name,1 type FROM ${gis_user}.db_cde_grid WHERE branch_no = '${param.lev4_id}'
      UNION ALL
      SELECT DISTINCT grid_name name,2 type FROM ${gis_user}.db_cde_grid WHERE grid_id = '${param.lev5_id}'
      UNION ALL
      SELECT nvl(village_name,' ') village_name,3 type FROM ${gis_user}.tb_gis_village_edit_info WHERE village_Id = '${param.lev6_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>套餐信息</e:description>
  <e:case value="mainOffer">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      '套餐信息' a,
      nvl(T4.ACC_NBR,' ') ACC_NBR,
      nvl(PROD_OFFER_NAME,' ')PROD_OFFER_NAME,
      TO_CHAR(T.EFF_DATE, 'YYYY-MM-DD') EFF_DATE,
      TO_CHAR(T.EXP_DATE, 'YYYY-MM-DD') EXP_DATE
      FROM ${sql_part_tab_name2} T
      INNER JOIN ${sql_part_tab_name3} T4
      ON T.PROD_INST_ID = T4.PROD_INST_ID
      WHERE T.PROD_INST_ID IN
      (
        ${sql_part_ids2}
      )
      and t4.STATE_CD = '001'
      ORDER BY T4.ACC_NBR DESC, EFF_DATE DESC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品信息 使用信息</e:description>
  <e:case value="products">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      '使用信息' a,
      nvl(T1.ACC_NBR,' ') ACC_NBR,
      TO_CHAR(ROUND(NVL(T.VOICE_DURA, 0), 0), 'FM9999999990') || '分钟' VOICE_DURA,
      TO_CHAR(ROUND(NVL(T.ONLINE_TIME, 0), 0), 'FM9999999990') || '小时' ONLINE_TIME,
      TO_CHAR(ROUND(NVL(T.FLOW, 0) / 1024, 2), 'FM9999999990.00') || 'G' FLOW,
      SMS_ROW,
      TO_CHAR(ROUND(NVL(T.LAST_VOICE_DURA, 0), 0), 'FM9999999990') || '分钟' LAST_VOICE_DURA,
      TO_CHAR(ROUND(NVL(T.LAST_ONLINE_TIME, 0), 0), 'FM9999999990') || '小时' LAST_ONLINE_TIME,
      TO_CHAR(ROUND(NVL(T.LAST_FLOW, 0) / 1024, 2), 'FM9999999990.00') || 'G' LAST_FLOW,
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
      WHERE T1.PROD_INST_ID IN
      (
      <e:description></e:description>
        ${sql_part_ids2}

      <e:description>test
        '932024737436','933034117188','943027606597','501131882021','500524000951'
      </e:description>
      )
      and t1.STATE_CD = '001'
      ORDER BY PRODUCT_ORD
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品订购</e:description>
  <e:case value="product_info_list">
    <e:q4l var="dataList">
      <e:description>
      SELECT /*+parallel (10)*/
      '产品订购' a,
      nvl(T4.ACC_NBR,' ') acc_nbr,
      NVL(PROD_OFFER_NAME, ' ') PROD_OFFER_NAME,
      TO_CHAR(T.EFF_DATE, 'YYYY-MM-DD') EFF_DATE,
      TO_CHAR(T.EXP_DATE, 'YYYY-MM-DD') EXP_DATE,
      CASE
      WHEN T4.PRODUCT_CD in ('999991020','999991010','999991030','999991040') THEN '1'<e:description>宽带</e:description>
      WHEN T4.PRODUCT_CD = '100004466' THEN '2'<e:description>电视</e:description>
      WHEN T4.PRODUCT_CD = '900000001' THEN '3'<e:description>移动</e:description>
      WHEN T4.PRODUCT_CD in ('999992090','999992010','999992140','999992130','100000000','999992020','999992040','999992070','999992150','999992080','999992100','999992030','999992050','999992060','999992110','999992120') THEN '4'<e:description>固话</e:description>
      ELSE '5'
      END product_ord,
      t4.stop_type_name
      FROM ${sql_part_tab_name2} T
      INNER JOIN (
      SELECT
      T1.PROD_INST_ID,T1.ACC_NBR,t1.PRODUCT_CD,
      T1.STOP_TYPE,t1.stop_type_name
      FROM
      (select PROD_INST_ID,ACC_NBR,PRODUCT_CD,a.STOP_TYPE,b.stop_type_name from ${sql_part_tab_name3} a,
      ${gis_user}.TB_DIC_GIS_STOP_TYPE b WHERE a.stop_type = b.stop_type
      ) T1
      LEFT JOIN EDW.TB_MKT_BIZ_INFO@GSEDW T
      ON T1.PROD_INST_ID = T.PROD_INST_ID
      ) T4
      ON T.PROD_INST_ID = T4.PROD_INST_ID
      WHERE T.PROD_INST_ID IN
      <e:description>test
      ('501035825243','500529234457','500529234455','500529234451','500529234448','931032322723','931030261158','500045417075','501035825243','500529234457','500529234455')
      </e:description>
      <e:description></e:description>
      (${sql_part_ids2})

      ORDER BY PRODUCT_ORD,T4.ACC_NBR DESC, EFF_DATE DESC
      </e:description>

      select
      '产品订购' a,
      NVL(c.ACC_NBR, ' ') ACC_NBR,
      NVL(a.PROD_OFFER_NAME, ' ') PROD_OFFER_NAME,
      TO_CHAR(a.EFF_DATE, 'YYYY-MM-DD') EFF_DATE,
      TO_CHAR(a.EXP_DATE, 'YYYY-MM-DD') EXP_DATE,
      CASE
      WHEN (c.product_id = '100000045' OR c.product_id = '122445247') THEN
      '1'
      WHEN c.PRODUCT_id = '100004466' THEN
      '2'
      WHEN c.PRODUCT_id = '900000001' THEN
      '3'
      WHEN c.PRODUCT_id = '100000000' then
      '4'
      ELSE
      '5'
      END PRODUCT_ORD,
      b.stop_type_name
      from ${sql_part_tab_name2} a, ${sql_part_tab_name3} c,${gis_user}.TB_DIC_GIS_STOP_TYPE b
      where a.PROD_INST_ID = c.PROD_INST_ID
      and c.stop_type = b.stop_type
      and a.PROD_INST_ID in
      (${sql_part_ids2})
      and c.STATE_CD = '001'
      ORDER BY product_ord,c.ACC_NBR DESC, a.EFF_DATE DESC

    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>收入信息 列表</e:description>
  <e:case value="incoming">
    <e:q4l var="dataList">
      SELECT /*+PARALLEL (20) */
      '收入列表' a,
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

  <e:description>收入汇总 费用合计 赠金合计</e:description>
  <e:case value="incoming_summary">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      SUM(V.OLD_CHARGE) OLD_CHARGE,
      SUM(V.NO_INVOICE_AMOUNT) NO_INVOICE_AMOUNT
      FROM ${sql_part_tab_name4} V
      WHERE V.PROD_INST_ID IN
      (
        ${sql_part_ids2}
      )
      AND BILLING_MONTH = '${param.acct_month}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获得用户行为偏好</e:description>
  <e:case value="getFavirate">
    <e:q4o var="dataObject">
      select PROD_INST_ID from ${gis_user}.TB_MKT_INFO where state_cd='001'
      and PROD_INST_ID in
      (
        ${sql_part_ids2}
      )
      AND is_zfk=1
    </e:q4o>
    <e:if condition="${empty dataObject.PROD_INST_ID}">
      <e:q4o var="dataObject">
        select PROD_INST_ID from ${gis_user}.TB_MKT_INFO where state_cd='001'
        and PROD_INST_ID in
        (
        ${sql_part_ids2}
        )
        AND rownum=1
      </e:q4o>
    </e:if>
    <e:q4l var="dataList">
      <e:description>新版本已废弃
      SELECT
      '行为偏好'  a,
      MONTH_ID,PRVNCE_ID,LATN_ID,PROD_INST_ID,ACCS_NBR,
      decode(RESERV240,'-1','未知',RESERV240) jtlx, <e:description>家庭类型,</e:description>
      decode(RESERV241,'-1','未知',RESERV241) shfq,<e:description>社会分群,</e:description>
      decode(RESERV247,1,'土豪',2,'小康',3,'温饱',4,'低保',99000,'其他',-1,'未知') xfql,<e:description>消费潜力,</e:description>
      decode(RESERV247,1,'6个月月均arup>=80',2,'6个月月均arup：50=<arup<80',3,'6个月月均arup；20=<arup<50',4,'6个月月均arup<20',99000,'其他',-1,'未知') xfql_desc,<e:description>消费潜力,</e:description>
      RESERV251 qdph,<e:description>渠道偏好,</e:description>
      RESERV244 zdlx,<e:description>终端类型,</e:description>
      decode(RESERV245,'-1','未知',RESERV245) zdpp,<e:description>终端品牌,</e:description>
      decode(RESERV254,-1,'未知',to_char(RESERV254)) fwxx,<e:description>服务信息,</e:description>
      RESERV253 ywph,<e:description>业务偏好,</e:description>
      decode(RESERV252,1,'潜在离网',0,'否',-1,'未知') lwqx,<e:description>离网倾向,</e:description>
      case when t.RESERV248 = '-1' then '未知' else
      (
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,1) = '1' then 'top1[06:00~08:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,1) = '2' then 'top1[08:00~12:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,1) = '3' then 'top1[12:00~14:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,1) = '4' then 'top1[14:00~18:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,1) = '5' then 'top1[18:00~21:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,1) = '6' then 'top1[21:00~24:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,1) = '7' then 'top1[00:00~06:00),' end ||

      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,2) = '1' then 'top2[06:00~08:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,2) = '2' then 'top2[08:00~12:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,2) = '3' then 'top2[12:00~14:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,2) = '4' then 'top2[14:00~18:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,2) = '5' then 'top2[18:00~21:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,2) = '6' then 'top2[21:00~24:00),' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,2) = '7' then 'top2[00:00~06:00),' end ||

      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,3) = '1' then 'top3[06:00~08:00)' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,3) = '2' then 'top3[08:00~12:00)' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,3) = '3' then 'top3[12:00~14:00)' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,3) = '4' then 'top3[14:00~18:00)' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,3) = '5' then 'top3[18:00~21:00)' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,3) = '6' then 'top3[21:00~24:00)' end ||
      case when REGEXP_SUBSTR(t.RESERV248,'[^,]+',1,3) = '7' then 'top3[00:00~06:00)' end
      )
      end lltz<e:description>流量特征</e:description>
      FROM ${gis_user}.DAPM_GU_BDM_LABEL_PORTRAIT t
      where month_id = '201804'
      and prvnce_id = '862'
      and t.prod_inst_id = '${dataObject.PROD_INST_ID}'
      </e:description>

      select
      '行为偏好'  a,
      nvl(jtlx,' ') jtlx,<e:description>家庭类型,</e:description>
      nvl(shfq,' ') shfq,<e:description>社会分群,</e:description>
      nvl(xfql,' ') xfql,<e:description>消费潜力,</e:description>
      nvl(xfql_desc,' ') xfql_desc,<e:description>消费潜力描述信息,</e:description>
      nvl(decode(qdph,'-1','未知',qdph),' ') qdph,<e:description>渠道偏好,</e:description>
      nvl(zdlx,' ') zdlx,<e:description>终端类型,</e:description>
      nvl(zdpp,' ') zdpp,<e:description>终端品牌,</e:description>
      nvl(fwxx,' ') fwxx,<e:description>服务信息,</e:description>
      nvl(ywph,' ') ywph,<e:description>业务偏好,</e:description>
      nvl(lwqx,' ') lwqx,<e:description>离网倾向,</e:description>
      nvl(lltz,' ') lltz<e:description>流量特征</e:description>
      from ${gis_user}.TB_GIS_BDM_LABEL_M
      where prod_inst_id =
      <e:description>test
      '500131495119'
      </e:description>
      <e:description></e:description>
      '${dataObject.PROD_INST_ID}'

    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>收入 接入号分项汇总</e:description>
  <e:description>已废弃
  <e:case value="incoming_item_summary">
    <e:q4l var="dataList">
      SELECT A.ACC_NBR, SUM(nvl(OLD_CHARGE,0)) CHARGE_TOTAL
      FROM ${sql_part_tab_name3}  A,
      ${sql_part_tab_name4}  B,
      ${sql_part_tab_name2} C
      WHERE A.PROD_INST_ID = B.PROD_INST_ID
      AND A.PROD_INST_ID = C.PROD_INST_ID
      AND A.ADDRESS_ID = '${param.addr4}'
      AND A.CUST_ID = '${param.cust_id}'
      and B.BILLING_MONTH = '${param.acct_month}'
      GROUP BY A.ACC_NBR
      ORDER BY c.main_flag desc,c.EFF_DATE asc
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
  </e:description>

  <e:description>客户权益</e:description>
  <e:case value="getCustRights">
    <e:q4l var="dataList">
      select
      '客户权益' a,
      nvl(a.cust_point,0) cust_point,
      NVL(b.member_name,0) member_name,
      NVL(b.rights_content1,' ') rights_content1,
      NVL(b.rights_content2,' ') rights_content2,
      NVL(b.rights_content3,' ') rights_content3,
      NVL(b.rights_content4,' ') rights_content4,
      NVL(b.rights_content5,' ') rights_content5,
      NVL(b.rights_content6,' ') rights_content6,
      NVL(b.rights_content7,' ') rights_content7,
      NVL(b.rights_content8,' ') rights_content8,
      NVL(b.rights_content9,' ') rights_content9
      from ${gis_user}.TB_GIS_CUST_INFO_D a, ${gis_user}.tb_gis_dic_score_content b
      where a.cust_star_code = b.member_class
      and a.prod_inst_id =
      <e:description></e:description>
      '${param.prod_inst_id}'

      <e:description>test
      '935416725467'
      </e:description>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>消费信息</e:description>
  <e:case value="getPayfor">
    <e:q4l var="dataList">
      select owe_charge,acct_bal from ${gis_user}.TB_GIS_CUST_INFO_D where prod_inst_id = '${param.prod_inst_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>消费趋势图 消费历史</e:description>
  <e:case value="getPayforFigue">
    <e:q4l var="dataList">
        select
        '消费趋势图' a,
        month_code,nvl(old_charge,0) old_charge from (
        select distinct month_code from ${gis_user}.tb_dim_time where month_code between to_char(add_months(sysdate,-7),'yyyyMM') and to_char(add_months(sysdate,-2),'yyyyMM')) a
        left join
        (select acct_month,old_charge from ${gis_user}.TB_GIS_USER_FEE_MON_HIS where prod_inst_Id = '${param.prod_inst_id}') b
        on a.month_code = b.acct_month
        order by a.month_code
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取小区营销的用户营销推荐</e:description>
  <e:case value="getVillageAdvise">
    <e:q4l var="dataList">
      <e:description>已废弃
      select
      '营销推荐' a,
      MKT_CAMPAIGN_NAME SCENE_NAME,CONTACT_SCRIPT from ${gis_user}.tb_hdz_m_pmp_pa_chl_query_list a
      <e:description>test
      where rownum < 5 and order_date = to_char(SYSDATE,'yyyyMMdd')
      </e:description>
        where a.target_obj_nbr in
        (${sql_part_ids2})
        and order_date = to_char(SYSDATE,'yyyyMMdd')
      </e:description>

      SELECT
      DISTINCT
      '营销推荐' a,
      A.MKT_CAMPAIGN_ID,
      A.MKT_CAMPAIGN_NAME SCENE_NAME,
      C.MKT_TYPE_NAME SCENE_TYPE,
      A.TARGET_OBJ_NBR,
      A.ACC_NBR,
      DECODE(EXE_DATE, NULL, ' ', '已执行') EXE_STATE,
      A.CONTACT_SCRIPT
      FROM (SELECT *
      FROM ${gis_user}.TB_HDZ_M_PMP_PA_CHL_QUERY_LIST
      WHERE 1 = 1
      AND MONTH_NO = (SELECT MAX(CONST_VALUE) VAL
      FROM ${easy_user}.SYS_CONST_TABLE
      WHERE MODEL_ID = 10
      AND DATA_TYPE = 'mon')
      ) A,
      ${gis_user}.TB_HDZ_DIC_MARKET_INFO C
      WHERE
      <e:description></e:description>
      A.TARGET_OBJ_NBR in (${sql_part_ids2})
      <e:description>test
      rownum < 6
      </e:description>
      AND A.MKT_CAMPAIGN_ID = C.MKT_ID

      UNION ALL

      SELECT
      distinct
      '营销推荐' A,
      A.scene_id MKT_CAMPAIGN_ID,
      A.mkt_content SCENE_NAME,
      '' SCENE_TYPE,
      a.prod_inst_id TARGET_OBJ_NBR,
      A.ACC_NBR,
      DECODE(EXEc_time, NULL, ' ', '已执行') EXE_STATE,
      A.mkt_reason CONTACT_SCRIPT
      FROM EDW.TB_MKT_ORDER_LIST@GSEDW a
      WHERE prod_inst_id IN
      (${sql_part_ids2})
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>换机终端信息</e:description>
  <e:case value="terminal_info">
    <e:q4l var="dataList">
      select to_char(t.register_time,'yyyy-mm-dd') reg_time,
             nvl(t.mobile_model,'未知机型') mobile_model,
             nvl(t.brand_name,'未知品牌') brand_name,
             nvl(t.mobile_type,'未知档次') mobile_type,
             prod_inst_id,
             nvl(acc_nbr,' ') ACC_NBR
      from ${gis_user}.TB_GIS_MODEL_CHANGE_M t WHERE PROD_INST_ID in
      <e:description>test
      ('13309310266','934225089801','500323951411')
      </e:description>
      <e:description></e:description>
      (${sql_part_ids2})

      order by register_time desc
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>投诉举报</e:description>
  <e:case value="tsjb_info">
    <e:q4l var="dataList">
      SELECT
      '投诉举报' a,
      TO_CHAR(ACCEPT_DATE, 'yyyy-mm-dd') ACCEPT_DATE,
      NVL(T.ACCEPT_STAFF_NAME, '未知') ACCEPT_STAFF_NAME,
      CASE
      WHEN INSTR(ACCEPT_DESC, '具体描述') > 0 THEN
      REPLACE(SUBSTR(ACCEPT_DESC, INSTR(ACCEPT_DESC, '具体描述') + 5),
      SUBSTR(ACCEPT_DESC, INSTR(ACCEPT_DESC, '客支备注')),
      '')
      WHEN INSTR(ACCEPT_DESC, '备注') > 0 THEN
      REPLACE(SUBSTR(ACCEPT_DESC, INSTR(ACCEPT_DESC, '备注') + 3),
      SUBSTR(ACCEPT_DESC, CASE WHEN INSTR(ACCEPT_DESC, '诊断报告')>0 THEN INSTR(ACCEPT_DESC, '诊断报告')-1 END),
      '')
      END ACCEPT_DESC
      FROM ${gis_user}.TB_GIS_COMPLAIN_D t
      WHERE
      cmplnt_number IN
      (
        SELECT DISTINCT acc_nbr FROM ${gis_user}.tb_mkt_info WHERE prod_inst_id IN (
        ${sql_part_ids2}
        )
        union
        SELECT DISTINCT user_contact_nbr FROM ${gis_user}.tb_mkt_info WHERE prod_inst_id IN (
        ${sql_part_ids2}
        )
        union
        SELECT DISTINCT cust_phone FROM ${gis_user}.tb_mkt_info WHERE prod_inst_id IN (
        ${sql_part_ids2}
        )
      )and
      rownum < 6
      and flg <> 3
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>接触轨迹</e:description>
  <e:case value="contract_info">
    <e:q4l var="dataList">
      <e:description>已废弃
      select
      '接触轨迹' a,
      substr(exe_date, 0, 4) || '-' || substr(exe_date, 5, 2) || '-' || substr(exe_date, 7, 2) exe_date,
      exe_chl_code,
      exe_chl_name,
      contact_script
      from ${gis_user}.tb_hdz_m_pmp_pa_chl_query_list a
      where target_obj_nbr in
      <e:description>test
      ('500389915224','500389928484','500389967464','500389970206','500389984901','500389985131')
      </e:description>
      <e:description></e:description>
      (${sql_part_ids2})

      and exe_date is not null
      and exe_chl_code <> '103301'
      union all
      select
      '接触轨迹' a,
      substr(exe_date, 0, 4) || '-' || substr(exe_date, 5, 2) || '-' || substr(exe_date, 7, 2) exe_date,
      exe_chl_code,
      exe_chl_name,
      contact_script
      from ${gis_user}.TB_HDZ_M_PMP_PA_CHL_QUERY_MON b
      where target_obj_nbr in
      <e:description>test
      ('500575648420','500575741275','500575836118','500575842473','500575854076','500575854480')
      </e:description>
      <e:description></e:description>
      (${sql_part_ids2})

      and exe_date is not null
      and exe_chl_code <> '103301'
      order by exe_date desc
      </e:description>

      <e:description>已废弃
      SELECT *
      FROM (SELECT '接触轨迹' A,
      SUBSTR(EXE_DATE, 0, 4) || '-' || SUBSTR(EXE_DATE, 5, 2) || '-' ||
      SUBSTR(EXE_DATE, 7, 2) EXE_DATE,
      EXE_CHL_CODE,
      EXE_CHL_NAME,
      CONTACT_SCRIPT,
      A.TARGET_OBJ_NBR
      FROM ${gis_user}.TB_HDZ_M_PMP_PA_CHL_QUERY_LIST A
      WHERE 1=1
      <e:description></e:description>
      and TARGET_OBJ_NBR IN
      (${sql_part_ids2})

      and EXE_DATE IS NOT NULL
      AND EXE_CHL_CODE <> '103301'
      UNION
      SELECT '接触轨迹' A,
      SUBSTR(EXE_DATE, 0, 4) || '-' || SUBSTR(EXE_DATE, 5, 2) || '-' ||
      SUBSTR(EXE_DATE, 7, 2) EXE_DATE,
      EXE_CHL_CODE,
      EXE_CHL_NAME,
      CONTACT_SCRIPT,
      B.TARGET_OBJ_NBR
      FROM ${gis_user}.TB_HDZ_M_PMP_PA_CHL_QUERY_MON B
      WHERE 1=1
      <e:description></e:description>
      and TARGET_OBJ_NBR IN
        (${sql_part_ids2})

      and EXE_DATE IS NOT NULL
      AND EXE_CHL_CODE <> '103301'
      ORDER BY EXE_DATE DESC) A,
      (SELECT B.USER_NAME,
      A.EXEC_STAT,
      CASE
      WHEN A.EXEC_STAT = 2 THEN
      '同意办理'
      WHEN A.EXEC_STAT = 1 THEN
      '有意向'
      WHEN A.EXEC_STAT = 3 THEN
      '不需要'
      WHEN A.EXEC_STAT = 4 THEN
      '无法联系'
      END EXEC_STAT_NAME,
      A.EXEC_DESC,
      PROD_INST_ID
      FROM ${gis_user}.TB_MARKET_EXEC_LOG A, E_USER B
      WHERE A.EXEC_OPR = B.USER_ID
      <e:description></e:description>
      AND A.PROD_INST_ID IN
        (${sql_part_ids2})
      )b
      WHERE A.TARGET_OBJ_NBR = B.PROD_INST_ID
      </e:description>

      <e:description>已废弃
      SELECT a.did_time exe_date,

      nvl(b.user_name,' ')user_name
      FROM (
      SELECT to_char(aa.exec_time,'yyyy-mm-dd') DID_TIME,aa.exec_staff,
      decode(aa.exec_stat,1,'有意向',2,'同意办理',3,'不需要',4,'无法联系',' ') EXEC_STAT_NAME,
      DECODE(aa.contact_type,1,'电话',2,'上门',3,'门店',' ') contact_type_text,
      nvl(aa.exec_desc,' ') DID_DESC
      FROM EDW.TB_MKT_ORDER_LIST@GSEDW AA
      WHERE
      AA.prod_inst_id = '${param.prod_inst_id}'
      AND aa.exec_stat>0
      UNION ALL
      SELECT to_char(bb.exec_time,'yyyy-mm-dd') DID_TIME,bb.exec_staff,
      decode(bb.exec_stat,1,'有意向',2,'同意办理',3,'不需要',4,'无法联系',' ') exec_stat_text,
      DECODE(bb.contact_type,1,'电话',2,'上门',3,'门店',' ') contact_type_text,
      nvl(bb.exec_desc,' ') DID_DESC
      <e:description>
        FROM ${gis_user}.TB_MKT_ORDER_LIST_HIS BB
      </e:description>
      FROM EDW.TB_MKT_ORDER_EXEC_HIS@GSEDW BB
      WHERE
      BB.prod_inst_id = '${param.prod_inst_id}'
      AND bb.exec_stat>0
      )a LEFT JOIN e_user b
      ON a.exec_staff = b.ext30
      union all
      SELECT A.*, NVL(B.USER_NAME, ' ') USER_NAME
      FROM (
      SELECT TO_CHAR(CC.EXEC_TIME, 'yyyy-mm-dd') DID_TIME,
      CC.EXEC_OPR EXEC_STAFF,
      DECODE(CC.EXEC_STAT,
      1,
      '有意向',
      2,
      '同意办理',
      3,
      '不需要',
      4,
      '无法联系',
      ' ') EXEC_STAT_TEXT,
      DECODE(CC.CONTACT_TYPE, 1, '电话', 2, '上门', 3, '门店', ' ') CONTACT_TYPE_TEXT,
      NVL(CC.EXEC_DESC, ' ') DID_DESC
      FROM ${gis_user}.TB_MARKET_EXEC_LOG CC
      WHERE CC.PROD_INST_ID = '${param.prod_inst_id}') A
      LEFT JOIN E_USER B
      ON A.EXEC_STAFF = B.EXT30
      ORDER BY DID_TIME DESC
      </e:description>

      select distinct a.*,nvl(b.user_name,'未知') user_name from(
      select '接触轨迹' a,'0' EXE_CHL_CODE,'划小' EXE_CHL_NAME,to_char(exec_time,'yyyy-mm-dd') EXE_DATE,exec_staff,decode(aa.exec_stat,1,'有意向',2,'同意办理',3,'不需要',4,'无法联系',' ') EXEC_STAT_NAME,mkt_content, mkt_reason from EDW.TB_MKT_ORDER_LIST@GSEDW aa
      where prod_inst_id in '500105971423'<e:description>(${sql_part_ids2})</e:description>
      and exec_time is not null
      <e:description>(${sql_part_ids2})</e:description>
      union all
      select '接触轨迹' a,'0' EXE_CHL_CODE,'划小' EXE_CHL_NAME,to_char(bb.exec_time,'yyyy-mm-dd') EXE_DATE,bb.exec_staff,nvl(bb.exec_desc,' ') EXEC_STAT_NAME,ee.mkt_content,ee.mkt_reason from EDW.TB_MKT_ORDER_LIST@GSEDW ee, EDW.TB_MKT_ORDER_EXEC_HIS@GSEDW bb
      where bb.prod_inst_id in (${sql_part_ids2})
      and bb.exec_time is not null
      and bb.order_id = ee.order_id
      <e:description>(${sql_part_ids2})</e:description>
      union all
      select '接触轨迹' a,mkt_campaign_id EXE_CHL_CODE,dd.mkt_name EXE_CHL_NAME,to_char(exec_time,'yyyy-mm-dd') EXE_DATE,cc.exec_opr exec_staff,nvl(exec_desc,' ') EXEC_STAT_NAME,dd.mkt_name,mkt_desc from ${gis_user}.TB_MARKET_EXEC_LOG cc,${gis_user}.TB_HDZ_DIC_MARKET_INFO dd where cc.mkt_campaign_id = mkt_id
      and prod_inst_id in (${sql_part_ids2})
      and exec_time is not null
      <e:description>(${sql_part_ids2})</e:description>
      )a left join e_user b on
      a.exec_staff = b.ext30
      order by exe_date desc

    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>