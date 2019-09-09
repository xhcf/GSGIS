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
      FROM ${sql_part_tab_name3} T
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

  <e:description>资料维护</e:description>
  <e:case value="info_collect_addons">
    <e:q4l var="dataList">
      select nvl(new_phone,' ') new_phone,nvl(new_address,' ') new_address from ${gis_user}.tb_gis_cust_ext where prod_inst_id = '${param.prod_inst_id}' and address_id = '${param.address_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品构成</e:description>
  <e:case value="prod_constuct">
    <e:q4l var="dataList">
      SELECT /*+parallel (10)*/
      '手机 <span style="color:red">' || nvl(SUM(CASE
      WHEN PRODUCT_CD = '900000001' THEN
      1
      ELSE
      0
      END),0) || '</span>   宽带 <span style="color:red">' || nvl(SUM(CASE
      WHEN PRODUCT_CD = '999991020' OR PRODUCT_CD = '999991010' OR
      PRODUCT_CD = '999991030' OR PRODUCT_CD = '999991040' OR
      PRODUCT_CD = '201190253' THEN
      1
      ELSE
      0
      END),0) || '</span>   电视 <span style="color:red">' ||
      nvl(SUM(CASE
      WHEN PRODUCT_CD = '100004466' THEN
      1
      ELSE
      0
      END),0) || '</span>   固话 <span style="color:red">' || nvl(SUM(CASE
      WHEN PRODUCT_CD = '999992010' THEN
      1
      ELSE
      0
      END),0) || '</span>' PRODUCT_STRUCTURE
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

  <e:description>产品信息</e:description>
  <e:case value="products">
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
      WHERE T1.PROD_INST_ID IN
      (
      <e:description></e:description>
      ${sql_part_ids2}

      )
      and t1.STATE_CD = '001'
      ORDER BY PRODUCT_ORD
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>产品汇总</e:description>
  <e:case value="products_summary">
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

  <e:description>收入信息_arpu arpu合计</e:description>
  <e:case value="incoming_arpu">
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

  <e:description>收入信息 列表</e:description>
  <e:case value="incoming">
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

  <e:description>收入汇总 费用合计 赠金合计</e:description>
  <e:case value="incoming_summary">
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
      <e:description>
        SELECT MONTH_ID,PRVNCE_ID,LATN_ID,PROD_INST_ID,ACCS_NBR,
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
        where month_id = (select const_value val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and const_type = 'var.dss24')
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
        SELECT nvl(A.ACC_NBR,' ')ACC_NBR, SUM(nvl(OLD_CHARGE,0)) CHARGE_TOTAL
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

  <e:description>获取小区营销的用户营销推荐</e:description>
  <e:description>20180910 把 TB_HDZ_INT_PMP_EXE_CHL_LIST 换成 TB_HDZ_M_PMP_PA_CHL_QUERY_LIST</e:description>
  <e:case value="getVillageAdvise">
    <e:q4l var="dataList">
      SELECT distinct nvl(A.ACC_NBR,' ') ACC_NBR, A.mkt_content SCENE_NAME, nvl(null,' ') CONTACT_SCRIPT
      FROM ${gis_user}.view_gis_order_a1_mon A
      WHERE A.prod_inst_id = '${param.prod_inst_id}'
        AND a.ADDRESS_ID = '${param.add6}'
      <e:description>
        2018.9.10改为取月数据
        and A.PA_DATE = (SELECT MAX(const_value) val FROM easy_data.sys_const_table where model_id=10)
      AND A.MONTH_NO = (SELECT max(const_value) val FROM easy_data.sys_const_table where model_id=10 AND data_type='mon')
      </e:description>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="info_addons_save">
    <e:update var="row_count" transaction="true">
      delete from ${gis_user}.tb_gis_cust_ext where prod_inst_id = '${param.prod_inst_id}' and address_id = '${param.address_id}';
      insert into ${gis_user}.tb_gis_cust_ext(prod_inst_id,address_id,new_phone,new_address,edit_time,eidt_opr)
      values('${param.prod_inst_id}','${param.address_id}','${param.new_phone}','${param.new_address}',sysdate,'${sessionScope.UserInfo.USER_ID}');
    </e:update>${row_count}
  </e:case>

  <e:case value="getVillageCellPath">
    <e:q4l var="dataList">
      SELECT town_name,village_name,brigade_name FROM edw.vw_tb_cde_village@gsedw WHERE brigade_id = '${param.brigade_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getOBDAdress">
    <e:q4o var="dataObject">
      SELECT address FROM ${gis_user}.TB_GIS_USER_LIST_D WHERE prod_Inst_id = '${param.prod_inst_id}' and epon_type = 2
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

</e:switch>
