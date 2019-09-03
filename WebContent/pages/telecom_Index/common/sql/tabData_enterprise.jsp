<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">

  <e:description>获取政企类型</e:description>
  <e:case value="getEnterpriseType">
    <e:q4l var="dataList">
      SELECT dic_code,dic_desc FROM ${gis_user}.TB_GIS_DIC_BUSINESS_TYPE
      WHERE parent_code = '2'
      <e:if condition="${param.type eq 'enterprise'}">
        AND dic_code NOT IN ('99999316','99999317')
      </e:if>
      <e:if condition="${param.type eq 'school'}">
        AND dic_code IN ('99999316','99999317')
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取地市下的小区</e:description>
  <e:case value="getVillageByCityId">
    <e:q4l var="dataList">
      SELECT * FROM (
      select c.*,ROWNUM rn from (
      select
      t1.village_id sid,
      t1.village_name business_name,
      DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', '--', TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100, 'FM9999999990.00') || '%') market_lv,
      t4.position V_POSITION,
      COUNT(1) OVER() C_NUM
      FROM ${gis_user}.view_db_cde_village t1 LEFT JOIN ${gis_user}.tb_gis_res_info_day t3
      ON t1.village_id = t3.latn_id
      LEFT JOIN ${gis_user}.tb_gis_village_edit_info t4
      ON t4.village_id = t1.village_id
      where t1.latn_id = '${param.city_id}'
      <e:if condition="${!empty param.v_name}">
        and t1.business_name LIKE '%${param.v_name}%'
      </e:if>
      order by business_name
      )c
      where 1=1
      <e:if condition="${!empty param.page}">
        AND ROWNUM <= 30 * (${param.page}+1)
      </e:if>
      )
      <e:if condition="${!empty param.page}">
        WHERE rn > 30 * ${param.page}
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取地市下的校园</e:description>
  <e:case value="getSchoolByCityId">
    <e:q4l var="dataList">
      SELECT * FROM (
      select c.*,ROWNUM rn from (
      select
      t1.BUSINESS_ID SID,
      t1.BUSINESS_NAME,
      fun_rate_fmt(t3.u_yd_cnt,t3.student_cnt) market_lv,
      t1.position V_POSITION,
      COUNT(1) OVER() C_NUM
      FROM ${gis_user}.TB_GIS_BUSINESS_BASE t1 LEFT JOIN ${gis_user}.TB_GIS_SCHOOL_KPI_DAY t3
      ON t1.business_id = t3.latn_id
      and t3.flag = 5
      where t1.latn_id = '${param.city_id}'
      <e:if condition="${!empty param.bureau_no}">
        and t1.bureau_no = '${param.bureau_no}'
      </e:if>
      <e:if condition="${!empty param.v_name}">
        and t1.business_name LIKE '%${param.v_name}%'
      </e:if>
      AND t1.valid_flag = 1
      AND t1.business_attr1 IN ('99999316','99999317')
      order by business_name
      )c
      where 1=1
      <e:if condition="${!empty param.page}">
        AND ROWNUM <= 30 * (${param.page}+1)
      </e:if>
      )
      <e:if condition="${!empty param.page}">
        WHERE rn > 30 * ${param.page}
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取地市下的政企</e:description>
  <e:case value="getEnterpriseByCityId">
    <e:q4l var="dataList">
      SELECT * FROM (
      select c.*,ROWNUM rn from (
      select
      t1.BUSINESS_ID SID,
      t1.BUSINESS_NAME,
      fun_rate_fmt(t3.u_yd_cnt,t3.student_cnt) market_lv,
      t1.position V_POSITION,
      COUNT(1) OVER() C_NUM
      FROM ${gis_user}.TB_GIS_BUSINESS_BASE t1 LEFT JOIN ${gis_user}.TB_GIS_SCHOOL_KPI_DAY t3
      ON t1.business_id = t3.latn_id
      and t3.flag = 5
      where t1.latn_id = '${param.city_id}'
      <e:if condition="${!empty param.v_name}">
        and t1.business_name LIKE '%${param.v_name}%'
      </e:if>
      AND t1.valid_flag = 1
      AND t1.business_attr1 IN (SELECT dic_code FROM ${gis_user}.TB_GIS_DIC_BUSINESS_TYPE WHERE dic_code NOT IN ('99999316','99999317') and PARENT_CODE = '2')
      order by business_name
      )c
      where 1=1
      <e:if condition="${!empty param.page}">
        AND ROWNUM <= 30 * (${param.page}+1)
      </e:if>
      )
      <e:if condition="${!empty param.page}">
        WHERE rn > 30 * ${param.page}
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取归入校园或政企的楼宇</e:description>
  <e:case value="getBuildUsedInSchoolOrEnterprise">
    <e:q4l var="dataList">
      SELECT segm_id FROM ${gis_user}.TB_GIS_BUSINESS_ADDR4 WHERE 1=1 and segm_id IN (${param.build_ids})
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取校园或政企下的楼宇</e:description>
  <e:case value="getBuildInsideSchoolOrEnterprise">
    <e:q4l var="dataList">
      SELECT b.business_id village_id,b.position,a.segm_id,a.stand_name,a.area_type,b.bureau_name
      FROM ${gis_user}.TB_GIS_BUSINESS_BASE b,${gis_user}.TB_GIS_BUSINESS_ADDR4 a
      left join
      (select segm_id,is_new,build_type from ${gis_user}.TB_GIS_SCHOOL_USER_REF) c
      on a.segm_id = c.segm_id
      WHERE a.business_id = b.business_id
      AND b.business_id = '${param.village_id}'
      <e:if condition="${!empty param.area_type}">
        and a.area_type = '${param.area_type}'
      </e:if>
      <e:if condition="${!empty param.is_new}">
        and c.is_new = '${param.is_new}'
      </e:if>
      <e:if condition="${!empty param.sex}">
        and c.build_type = '${param.sex}'
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取政企校园信息</e:description>
  <e:case value="getSchoolOrEnterpriseBaseInfo">
    <e:q4o var="dataObject">
      SELECT
      a.BUSINESS_NAME,
      a.LATN_NAME,
      a.BUREAU_NAME,
      <e:description>市场</e:description>
      fun_rate_fmt(b.u_yd_cnt, b.student_cnt) yd_lv,
      nvl(b.u_yd_cnt,0) yd_cnt,
      nvl(b.student_cnt,0) reside_count,
      nvl(b.u_kd_cnt,0) kd_cnt,
      NVL(b.build_cnt,0) buildings_count,
      NVL(b.house_cnt,0) house_cnt,
      <e:description>价值</e:description>
      DECODE(nvl(b.u_yd_cnt,0)+nvl(b.u_kd_cnt,0),0,'--',to_char(round((nvl(b.income_yd,0)+nvl(b.income_kd,0))/(nvl(b.u_yd_cnt,0)+nvl(b.u_kd_cnt,0)),2),'FM9999999990.00')) arpu,
      nvl(b.income_yd,0)+nvl(b.income_kd,0) INCOMING_MONTH,
      nvl(b.income_yd,0) yd_incoming,
      nvl(b.income_kd,0) kd_incoming,
      <e:description>发展</e:description>
      nvl(b.u_yd_add_cnt,0) + nvl(u_kd_add_cnt,0)  user_add,
      nvl(b.u_yd_add_cnt,0) yd_add,
      nvl(b.u_yd_add_single,0) dcp_cnt,
      nvl(b.u_yd_add_rh,0) rh_cnt,
      nvl(b.u_kd_add_cnt,0) kd_add,
      <e:description>流失</e:description>
      0 lost_user,
      0 bu_chu_zhang,
      0 qian_fei,
      0 chen_mo,
      <e:description>竞争</e:description>
      nvl(b.c_yd_cnt,0) yw_cnt,
      nvl(b.c_cm_yd_cnt,0) yw_yd_cnt,
      nvl(b.c_cu_yd_cnt,0) yw_lt_cnt,
      nvl(b.c_ot_yd_cnt,0) yw_other_cnt
      FROM ${gis_user}.TB_GIS_BUSINESS_BASE a LEFT JOIN ${gis_user}.TB_GIS_SCHOOL_KPI_DAY b ON a.business_id = b.latn_id
      and b.flag = 5
      WHERE a.business_id = '${param.business_id}'
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="getBuildInSchoolOrEnterprise">
    <e:q4l var="dataList">
      SELECT a.business_name,b.segm_id,b.stand_name,a.latn_id,a.latn_name,a.bureau_no,a.bureau_name,nvl(business_attr1,' ') business_attr1,nvl(business_attr2,' ') business_attr2,a.position,nvl(c.attr_ext2,' ') attr_ext2 FROM ${gis_user}.TB_GIS_BUSINESS_BASE a left join ${gis_user}.TB_GIS_BUSINESS_addr4 b on a.business_id = b.business_id left join ${gis_user}.TB_GIS_DIC_BUSINESS c on a.business_id = c.business_id where a.business_id = '${param.village_id}'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取校园的三个中心点</e:description>
  <e:case value="getSchoolCenter">
  	<e:q4l var="dataList">
        select 0 area_type,position from ${gis_user}.TB_GIS_BUSINESS_BASE where business_id = '${param.school_id}'
        union all
  		SELECT area_type,position FROM ${gis_user}.TB_GIS_BUSINESS_POSITION WHERE business_id = '${param.school_id}'
  	</e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取校园范围图形</e:description>
  <e:case value="getSchoolPolygen">
  	<e:q4o var="dataObject">
  		select sde.st_astext(shape) as geoshpe from sde.tb_gis_business_base where business_id = '${param.id}'
  	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>校园政企删除 删除校园政企</e:description>
  <e:case value="deleteBuildInSchoolOrEnterprise">
    <e:update>
      begin
      delete from ${gis_user}.TB_GIS_BUSINESS_BASE where business_id = '${param.v_id}';
      delete from ${gis_user}.TB_GIS_BUSINESS_ADDR4 where business_id = '${param.v_id}';
      delete from ${gis_user}.tb_gis_business_position where business_id = '${param.v_id}';
      delete from sde.tb_gis_business_base where business_id = '${param.v_id}';
      <e:description>
        注意seq可能会勿删现有数据
        delete from SDE.MAP_SCHOOL_EDIT_INFO where village_id = '${param.v_id}';
      </e:description>
      end;
    </e:update>
  </e:case>

  <e:description>点小区编辑，加载小区下楼宇的信息，包含端口，营销数</e:description>
  <e:case value="build_wines_in_school_or_enterprise">
    <e:q4l var="dataList">
      select '0' as segm_id,
      '' as segm_name,
      '合计' as stand_name,
      nvl(sum(a.ZHU_HU_COUNT),0) ZHU_HU_COUNT,
      nvl(sum(CENG_COUNT),0) CENG_COUNT,
      nvl(sum(PEOPLE_COUNT),0) PEOPLE_COUNT,
      0 OCCUPANCY_RATE,
      null RES_ID_COUNT,
      null SY_RES_COUNT,
      null port_lv,
      nvl(sum(a.KD_COUNT),0) KD_COUNT,
      nvl(sum(ITV_COUNT),0) ITV_COUNT,
      nvl(sum(GU_COUNT),0) GU_COUNT,
      nvl(sum(YD_COUNT),0) YD_COUNT,
      nvl(sum(d.obd_cnt),0) obd_cnt,
      0 area_type
      FROM ${gis_user}.TB_GIS_BUSINESS_addr4 c
      left join ${gis_user}.TB_GIS_ADDR_INFO_VIEW a
      on a.segm_id = c.segm_id
      LEFT JOIN ${gis_user}.tb_gis_res_info_day d
    		ON a.segm_id = d.latn_id
      where c.business_id = '${param.village_id}'
      union
      select c.SEGM_ID,
      c.segm_name,
      c.stand_name,
      nvl(a.ZHU_HU_COUNT,0) ZHU_HU_COUNT,
      nvl(CENG_COUNT,0) CENG_COUNT,
      nvl(PEOPLE_COUNT,0) PEOPLE_COUNT,
      OCCUPANCY_RATE,
      nvl(RES_ID_COUNT,0) RES_ID_COUNT,
      nvl(SY_RES_COUNT,0) SY_RES_COUNT,
      CASE WHEN RES_ID_COUNT=0 THEN 0 ELSE round((RES_ID_COUNT-SY_RES_COUNT)/RES_ID_COUNT,4)*100 end port_lv,
      nvl(a.KD_COUNT,0) KD_COUNT,
      nvl(ITV_COUNT,0) ITV_COUNT,
      nvl(GU_COUNT,0) GU_COUNT,
      nvl(YD_COUNT,0) YD_COUNT,
      nvl(d.obd_cnt,0) obd_cnt,
      nvl(c.area_type,0) area_type
      FROM ${gis_user}.TB_GIS_BUSINESS_addr4 c
      left join ${gis_user}.TB_GIS_ADDR_INFO_VIEW a
      on a.segm_id = c.segm_id
      LEFT JOIN ${gis_user}.tb_gis_res_info_day d
    		ON a.segm_id = d.latn_id
      where c.business_id = '${param.village_id}'
    </e:q4l>
    ${e:java2json(dataList.list)}
  </e:case>

  <e:description>新增校园或政企</e:description>
  <e:case value="saveBuildInSchoolOrEnterprise">
    <e:set var="ids" value="${e:split(param.ids,',')}" />
    <e:set var="full_names" value="${e:split(param.name_str,',')}" />
    <e:set var="short_names" value="${e:split(param.short_name_str,',')}" />
    <e:set var="build_area_types" value="${e:split(param.build_area_type_str,',')}" />
    <%--<e:q4o var="v_id">
      select sde.SCH_ENT_SEQ.nextVal val from dual
    </e:q4o>--%>

    <e:update>
      begin
      insert into ${gis_user}.TB_GIS_BUSINESS_BASE
      (
      business_id,
      business_name,

      latn_id,
      latn_name,
      bureau_no,
      bureau_name,

      ct_business,
      cm_business,
      cu_business,
      sarft_business,
      other_business,

      creater,
      create_time,

      position,

      business_attr1
      )
      values
      (
      '${param.business_id}',
      '${e:replace(param.business_name,"#","号")}',

      '${param.latn_id}',
      '${param.latn_name}',
      '${param.bureau_id}',
      '${param.bureau_name}',

      '${param.ct_business}',
      '${param.cm_business}',
      '${param.cu_business}',
      '${param.sarft_business}',
      '${param.other_business}',

      '${sessionScope.UserInfo.LOGIN_ID}',
      sysdate,

      '${param.position}',

      '${param.business_attr1}'
      );
      <e:description>更新服务表</e:description>
      <e:if condition="${!empty param.wktstr}">
      	insert into sde.TB_GIS_BUSINESS_BASE values('${param.business_id}',sde.st_mpolyfromtext('${param.wktstr}', 4326));
      </e:if>

      <e:forEach items="${ids}" var="id" indexName = "index">
        insert into ${gis_user}.TB_GIS_BUSINESS_ADDR4
        (
        business_id,
        SEGM_ID,
        segm_name,
        stand_name
        )
        values
        (
        '${param.business_id}',
        '${id}',
        '${e:replace(short_names[index],"#","号")}',
        '${e:replace(full_names[index],"#","号")}'
        );
      </e:forEach>
      <e:forEach items="${build_area_types}" var="type" indexName = "index">
        update ${gis_user}.tb_gis_business_addr4 set area_type = '${e:substringAfter(type, "_")}' where segm_id = '${e:substringBefore(type, "_")}';
      </e:forEach>
      insert into ${gis_user}.tb_gis_business_position
      (
        business_id,
        position,
        area_type
      )values(
        '${param.business_id}',
        '${param.school_new_center1}',
        1
      );
      insert into ${gis_user}.tb_gis_business_position
      (
        business_id,
        position,
        area_type
      )values(
        '${param.business_id}',
        '${param.school_new_center2}',
        2
      );
      insert into ${gis_user}.tb_gis_business_position
      (
        business_id,
        position,
        area_type
      )values(
        '${param.business_id}',
        '${param.school_new_center3}',
        3
      );
      end;
    </e:update>
    <e:q4o var="dataObject">
      select '${param.business_id}' val from dual
    </e:q4o>
    ${e:java2json(dataObject)}
  </e:case>

  <e:description>修改校园或政企</e:description>
  <e:case value="updateBuildInSchoolOrEnterprise">
    <e:set var="ids" value="${e:split(param.ids,',')}" />
    <e:set var="full_names" value="${e:split(param.name_str,',')}" />
    <e:set var="short_names" value="${e:split(param.short_name_str,',')}" />
    <e:set var="build_area_types" value="${e:split(param.build_area_type_str,',')}" />
    <e:update>
      begin
      update ${gis_user}.TB_GIS_BUSINESS_BASE
      set

      ct_business = '${param.ct_business}',
      cm_business = '${param.cm_business}',
      cu_business = '${param.cu_business}',
      sarft_business = '${param.sarft_business}',
      other_business = '${param.other_business}',

      LAST_CREATER = '${sessionScope.UserInfo.LOGIN_ID}',
      LAST_CREATE_TIME = sysdate,

      position = '${param.position}',
      bureau_no = '${param.bureau_id}',
      bureau_name = '${param.bureau_name}',

      business_attr1 = '${param.business_attr1}'

      where business_id = '${param.business_id}';

      <e:description>更新服务表</e:description>
      <e:if condition="${!empty param.wktstr}">
      	update sde.TB_GIS_BUSINESS_BASE set shape = sde.st_mpolyfromtext('${param.wktstr}', 4326) where business_id = '${param.business_id}';
      	<e:description>update sde.TB_GIS_BUSINESS_BASE set shape = sde.st_polyfromtext('${param.wktstr}', 4326) where business_id = '${param.business_id}';</e:description>
      </e:if>

      delete from ${gis_user}.TB_GIS_BUSINESS_ADDR4 where business_id = '${param.business_id}';

      <e:forEach items="${ids}" var="id" indexName = "index">
        insert into ${gis_user}.TB_GIS_BUSINESS_ADDR4
        (
        business_id,
        segm_id,
        segm_name,
        stand_name
        )
        values
        (
        '${param.business_id}',
        '${id}',
        '${e:replace(short_names[index],"#","号")}',
        '${e:replace(full_names[index],"#","号")}'
        );
      </e:forEach>
      <e:forEach items="${build_area_types}" var="type" indexName = "index">
        update ${gis_user}.tb_gis_business_addr4 set area_type = '${e:substringAfter(type, "_")}' where segm_id = '${e:substringBefore(type, "_")}';
      </e:forEach>
      update ${gis_user}.tb_gis_business_position
      set position = '${param.school_new_center1}'
      where business_id = '${param.business_id}' and area_type = 1;

      update ${gis_user}.tb_gis_business_position
      set position = '${param.school_new_center2}'
      where business_id = '${param.business_id}' and area_type = 2;

      update ${gis_user}.tb_gis_business_position
      set position = '${param.school_new_center3}'
      where business_id = '${param.business_id}' and area_type = 3;

      end;
    </e:update>
  </e:case>

  <e:description>更新校园、政企中心点位置</e:description>
  <e:case value="saveVillagePosition">
  	<e:update var="up_count">
  		begin
	  		update ${gis_user}.TB_GIS_BUSINESS_BASE set position = '${param.v_center}' where business_id = '${param.village_id}';
  		end;
  	</e:update>
  </e:case>

  <e:case value="getBureauListByCity">
    <e:q4l var="dataList">
      select distinct bureau_no id,bureau_name text from ${gis_user}.db_cde_grid where latn_id = '${param.city_id}' ORDER BY bureau_no
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getNewSchoolList">
    <e:q4l var="dataList">
      SELECT A.BUSINESS_ID, A.BUSINESS_NAME,A.BUREAU_NO,A.BUREAU_NAME,nvl(A.ATTR_EXT2,' ') ATTR_EXT2,a.business_type,a.ord_num
      FROM ${gis_user}.TB_GIS_DIC_BUSINESS A
      LEFT JOIN ${gis_user}.TB_GIS_BUSINESS_BASE B
      ON A.BUSINESS_ID = B.BUSINESS_ID
      WHERE B.BUSINESS_ID IS NULL
      and a.latn_id = '${param.city_id}'
      order by a.ord_num
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="isExistSchool">
    <e:q4o var="dataObject">
      select business_id from ${gis_user}.tb_gis_business_base where business_id = '${param.business_id}'
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>楼宇统计</e:description>
  <e:case value="getBuildSummary">
    <e:q4o var="dataObject">
      select
      count(a.segm_id) build_cnt,
      count(decode(b.is_new,0,null,1,1)) new_cnt,
      count(decode(b.build_type,1,1,null)) male_cnt,
      count(decode(b.build_type,2,1,null)) female_cnt
      from
      (select segm_id from ${gis_user}.TB_GIS_BUSINESS_addr4 where business_id = '${param.business_id}') a
      left join
      (select distinct segm_id,is_new,build_type from ${gis_user}.TB_GIS_SCHOOL_USER_REF) b
      on a.segm_id = b.segm_id
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>楼宇清单</e:description>
  <e:case value="getBuildInfo">
    <e:q4l var="dataList">
      select * from (
      select
      a.stand_name,
      decode(nvl(c.is_new,0),0,'否','是') is_new,
      decode(nvl(c.build_type,0),0,'其他',1,'男',2,'女') sex,
      nvl(d.house_cnt,0) cell_num,
      nvl(d.bed_cnt,0) bed_num,
      nvl(d.student_cnt,0) zhu_hu_count,
      nvl(d.u_yd_cnt,0) yd_num,
      fun_rate_fmt(d.u_yd_cnt,d.student_cnt) yd_lv,
      a.area_type,
      case when a.area_type=1 then '教学区' when a.area_type=2 then '宿舍区' when a.area_type=3 then '生活区' end area_type_text,
      0 OBD_num,
      res_id_count port,
      to_char(decode(nvl(res_id_count,0),0,0,round((nvl(res_id_count,0)-nvl(sy_res_count,0))/nvl(res_id_count,0),4)*100),'FM9999999990.00') || '%' PORT_LV,
      count(1) over() c_num,
      row_number() over(order by a.stand_name) row_num
      FROM (select * from ${gis_user}.TB_GIS_BUSINESS_addr4 where business_id = '${param.business_id}') a
      left join ${gis_user}.TB_GIS_ADDR_INFO_VIEW b
      on a.segm_id = b.segm_id
      left join (select distinct segm_id,is_new,build_type from ${gis_user}.tb_gis_school_user_ref) c
      on a.segm_id = c.segm_id
      left join (select latn_id,house_cnt,bed_cnt,student_cnt,u_yd_cnt from ${gis_user}.TB_GIS_SCHOOL_KPI_DAY where flag = 6) d
      on a.segm_id = d.latn_id
      where 1=1
      <e:description>楼宇分区</e:description>
      <e:if condition="${!empty param.area_type}">
        and a.area_type = '${param.area_type}'
      </e:if>
      <e:description>新生公寓</e:description>
      <e:if condition="${!empty param.is_new}">
      	and c.is_new = ${param.is_new}
      </e:if>
      <e:description>男女公寓</e:description>
      <e:if condition="${!empty param.sex}">
      	and c.build_type = ${param.sex}
      </e:if>
      <e:description>楼宇</e:description>
      <e:if condition="${!empty param.resid}">
        and a.segm_id = '${param.resid}'
      </e:if>
      )where row_num between ${param.page}*20+1 and ${param.page+1}*20
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>学生统计</e:description>
  <e:case value="getStuSummary">
    <e:q4o var="dataObject">
      select
      count(bed_no) num1,
      count(acc_nbr) num2,
      count(decode(product_id,1,1,null)) num3,
      fun_rate_fmt(count(decode(product_id,1,1,null)),count(acc_nbr)) num4
      from
      ${gis_user}.TB_GIS_BUSINESS_ADDR4 a,
      ${gis_user}.TB_GIS_SCHOOL_USER_REF b
      where a.segm_id = b.segm_id
      and a.business_id = '${param.business_id}'
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>学生清单</e:description>
  <e:case value="getStuInfo">
    <e:q4l var="dataList">
      select * from (
      select
      nvl(stand_name_2,' ') stand_name_2,
      nvl(bed_name ,' ') bed_name,
      nvl(dept_name ,' ') dept_name,
      nvl(grade_name ,' ') grade_name,
      nvl(contact_user ,' ') contact_user,
      nvl(contact_tel ,' ') contact_tel,
      case when business_type =1 then '电信'
      when business_type = 2 then '移动'
      when business_type = 3 then '联通'
      when business_type = 4 then '广电'
      when business_type = 5 then '其他'
      end business_name,
      nvl(fee,0) fee,
      COUNT(1) OVER() C_NUM,
      row_number() over(order by segm_id_2) ROW_NUM
      from ${gis_user}.TB_GIS_SCHOOL_USER_REF
      where segm_id = '${param.resid}'
      )
      where row_num between ${param.page}*20+1 and ${param.page+1}*20
      <e:description>000102140000000017157466</e:description>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>营销清单</e:description>
  <e:case value="getYxInfo">
    <e:q4l var="dataList">
      select * from (
      select
      '张三' user_name,
      '兰州市城关区天水南路8号兰大本5区家属院3号楼1单元103室1023床' address,
      '本月欠费' scene,
      '尊敬的客户，您的账户余额不足，即将暂停服务，请您近期预存足额话费，避免通讯不畅，造成不必要的损失！' script,
      '已执行' status,
      count(1) over() c_num,
      row_number() over(order by 1) row_num
      from dual
      where 1=1
      <e:description>
        and business_id = '${param.business_id}'
        <e:if condition="${!empty scene}">
          and scene_id = '${param.scene}'
        </e:if>
        <e:if condition="${!empty resid}">
          and resid = '${param.resid}'
        </e:if>
        <e:if condition="${!empty status}">
          and status = '${param.status}'
        </e:if>
      </e:description>
      )
      where row_num between ${param.page}*20+1 and ${param.page+1}*20
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>流失用户</e:description>
  <e:case value="getLostInfo">
    <e:q4l var="dataList">
      select * from (
      select
      '兰州市城关区天水南路222号兰大本部05区家属院1号楼301' address,
      001 bed_no,
      'a' college_name,
      'b' grade_name,
      '张三' user_name,
      '189xxxxxxxx' tel,
      '2019-09-23' lost_date,
      '不出帐' status,
      COUNT(1) OVER() C_NUM,
      row_number() over(order by 1) ROW_NUM
      from dual
      where 1=1
      <e:description>
        and business_id = '${param.business_id}'
        <e:if condition="${!empty is_new}">
          and is_new = '${param.is_new}'
        </e:if>
        <e:if condition="${!empty sex}">
          and sex = '${param.sex}'
        </e:if>
        <e:if condition="${!empty resid}">
          and resid = '${param.resid}'
        </e:if>
      </e:description>
      )
      where row_num between ${param.page}*20+1 and ${param.page+1}*20
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>