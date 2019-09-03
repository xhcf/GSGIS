<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
  <e:description>20181215</e:description>

  <e:description>行政架构</e:description>
  <e:case value="getIndex_xzjg">
    <e:q4l var="dataList">
      select * from (
      select village_id,village_name,city_name,county_name,town_name,brigade_name,NVL(BRIGADE_ALIAS,' ') BRIGADE_ALIAS
      from edw.vw_tb_cde_village@gsedw where brigade_id='${param.res_id}'
      group by village_id,village_name,city_name,county_name,town_name,brigade_name,BRIGADE_ALIAS)
      where rownum<2
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>市场</e:description>
  <e:case value="getIndex_market">
    <e:q4l var="dataList">
      select village_id,brigade_id,household_num,h_use_cnt,
      to_char(round(decode(nvl(t.household_num,0),0,0,t.h_use_cnt/t.household_num),4)*100,'FM9999999990.00')||'%' markt_lv
      from gis_data.TB_GIS_BRIGADE_DAY t where brigade_id='${param.res_id}'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>资源 端口</e:description>
  <e:case value="getIndex_resourse">
    <e:q4l var="dataList">
      select village_id,brigade_id,count(distinct eqp_no) eqp_cnt,sum(capacity) port_cnt,sum(actualcapacity) userd_port_cnt,
      to_char(round(decode(nvl(sum(capacity),0),0,0,sum(actualcapacity)/sum(capacity)),4)*100,'FM9999999990.00')||'%' port_lv
      from 	gis_data.TB_GIS_COUNTRY_ODB_D  where brigade_id='${param.res_id}'
      group by village_id,brigade_id
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>营销</e:description>
  <e:case value="getIndex_yx">
    <e:q4l var="dataList">
      select t.scene_count,t.yx_count,t.zx_count,t.suc_count,
      to_char(round(decode(t.order_count,0,0,t.zx_count/t.order_count),4)*100,'FM9999999990.00')||'%' zx_lv,
      to_char(round(decode(t.yx_count,0,0,t.suc_count/t.yx_count),4)*100,'FM9999999990.00')||'%' suc_lv
      from(
      select count(DISTINCT b.scene_id) scene_count,count(DISTINCT b.order_id) yx_count,count(distinct b.order_id) order_count,
      count(decode(b.exec_stat,0,null,order_id)) zx_count,count(decode(b.SUCC_FLAG,1,order_id,null)) suc_count
      from ${gis_user}.view_gis_order_b1_mon b
      where b.brigade_id='${param.res_id}') t
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>收集</e:description>
  <e:case value="getIndex_collect">
    <e:q4l var="dataList">
      select sum(c.household_num) -sum(c.h_use_cnt) y_collect,count(address_id) collected_cnt,
      to_char(round(decode((sum(c.household_num) -sum(c.h_use_cnt)),0,0,count(address_id)/(sum(c.household_num) -sum(c.h_use_cnt))),4)*100,'FM9999999990.00')||'%' collect_lv
      from EDWWEB.TB_COUNTRY_GATHER@GSEDW a,gis_data.TB_GIS_BRIGADE_DAY c
      where a.brigade_id=c.brigade_id and a.village_id='${param.village_id}' and a.brigade_id='${param.res_id}' group by a.brigade_id
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>