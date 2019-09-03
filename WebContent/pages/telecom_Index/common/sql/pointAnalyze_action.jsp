<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4o var="kpi_range_default">
    SELECT RANGE_SIGNL || RANGE_MIN VAL FROM ${gis_user}.TB_GIS_KPI_RANGE WHERE KPI_CODE = 'KPI_D_002' AND RANGE_INDEX = 3
</e:q4o>
<e:q4o var="kpi_range_1">
    SELECT RANGE_SIGNL || RANGE_MIN val FROM ${gis_user}.TB_GIS_KPI_RANGE WHERE KPI_CODE = 'KPI_D_002' AND RANGE_INDEX = '${param.village_degree}'
</e:q4o>
<e:q4o var="kpi_range_2">
    SELECT RANGE_SIGNL || RANGE_MIN val_left,range_signr || range_max val_right FROM ${gis_user}.TB_GIS_KPI_RANGE WHERE KPI_CODE = 'KPI_D_002' AND RANGE_INDEX = '${param.village_degree}'
</e:q4o>

<e:set var="four_type_default_condition">
    and t.GZ_ZHU_HU_COUNT0 ${kpi_range_default.VAL}
</e:set>
<e:set var="four_type_default_condition1">
    and t.gz_zhu_hu_count ${kpi_range_default.VAL}
</e:set>
<e:set var="type_province">
    and t.GZ_ZHU_HU_COUNT0 ${kpi_range_1.VAL}
</e:set>
<e:set var="type_province1">
    and t.gz_zhu_hu_count ${kpi_range_1.VAL}
</e:set>
<e:set var="type_city">
    and (t.GZ_ZHU_HU_COUNT0 ${kpi_range_2.VAL_LEFT} and t.GZ_ZHU_HU_COUNT0 ${kpi_range_2.VAL_RIGHT})
</e:set>
<e:set var="type_city1">
    and (t.gz_zhu_hu_count ${kpi_range_2.VAL_LEFT} and t.gz_zhu_hu_count ${kpi_range_2.VAL_RIGHT})
</e:set>
<e:set var="type_bureau">
    and (t.GZ_ZHU_HU_COUNT0 ${kpi_range_2.VAL_LEFT} and t.GZ_ZHU_HU_COUNT0 ${kpi_range_2.VAL_RIGHT})
</e:set>
<e:set var="type_bureau1">
    and (t.gz_zhu_hu_count ${kpi_range_2.VAL_LEFT} and t.gz_zhu_hu_count ${kpi_range_2.VAL_RIGHT})
</e:set>

<e:switch value="${param.eaction}">
    <e:description>重点指标统计分析 begin </e:description>
    <e:case value="point_data_list">
      <e:q4l var="dataList">
          select * from
          (SELECT T.*, ROWNUM ROW_NUM FROM (

          <e:if condition="${param.flag == '1'}">
              select tt.*,COUNT(1) OVER() c_num  from ${gis_user}.view_GIS_RES_CITY_DAY tt  where acct_day='${param.beginDate}' and flg=1 order by ord
          </e:if>
          <e:if condition="${param.flag == '2'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=1
              and latn_id='${param.region_id}'
              union
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=2
              and parent_id='${param.region_id}'
              )tt order by flg,ord
          </e:if>
          <e:if condition="${param.flag == '3'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=2
              and latn_id='${param.cityNo}'
              union
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=3
              and parent_id='${param.cityNo}'
              )tt order by flg,ord
          </e:if>
          <e:if condition="${param.flag == '4'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=3
              and latn_id='${param.centerNo}'
              union
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=4
              and parent_id='${param.centerNo}'
              )tt order by flg,ord
          </e:if>
          <e:if condition="${param.flag == '5'}">
              select tt.*,COUNT(1) OVER() c_num from (
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=4 and
              latn_id='${param.gridNo}'
              union
              select * from ${gis_user}.view_GIS_RES_CITY_DAY
              where acct_day='${param.beginDate}'
              and flg=5
              and parent_id='${param.gridNo}'
              )tt order by flg,ord
          </e:if>
          ) T
          )
          WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
      </e:q4l>${e: java2json(dataList.list) }
    </e:case>

    <e:description>四类小区统计 begin</e:description>
    <e:case value="region_data_list">
        <e:q4l var="dataList">
            <e:description>已废弃
            select * from
            (SELECT T.*, ROWNUM ROW_NUM FROM (
            select tt.*,COUNT(1) OVER() c_num from ${gis_user}.view_gis_village_lable_collect tt
            where tt.acct_day='${param.beginDate}'
            <e:description>四类小区新定义，小区规模大于某人数以上的，竞争情况含有移动进线的，消费能力是全部，小区分群去掉政企。</e:description>
            <e:if condition="${empty param.village_degree}">
                ${four_type_default_condition}
            </e:if>
            <e:if condition="${param.village_degree eq '1'}">
                ${type_province}
            </e:if>
            <e:if condition="${param.village_degree eq '2'}">
                ${type_city}
            </e:if>
            <e:if condition="${param.village_degree eq '3'}">
                ${type_bureau}
            </e:if>
            order by ord
            ) T
            )
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
            </e:description>

            select * from(
                SELECT T.*, ROWNUM ROW_NUM FROM (
                    select tt.*,COUNT(1) OVER() c_num from (
                        select
                        t.acct_day,
                        latn_id,
                        latn_name,
                        ord,
                        sum(village_count0) village_count0,
                        sum(gz_zhu_hu_count0) gz_zhu_hu_count0,
                        sum(gz_h_use_cnt0) gz_h_use_cnt0,
                        sum(lost_count0) lost_count0,
                        to_char(round(decode(nvl(sum(t.gz_zhu_hu_count0), 0),
                        0,
                        0,
                        sum(t.gz_h_use_cnt0) /
                        sum(t.gz_zhu_hu_count0)),
                        4) * 100,
                        'FM9999999990.00') || '%' markt_lv0,
                        to_char(round(decode(nvl(sum(t.gz_h_use_cnt0), 0),
                        0,
                        0,
                        sum(t.lost_count0) /
                        sum(t.gz_h_use_cnt0)),
                        4) * 100,
                        'FM9999999990.00') || '%' lost_zb0,
                        sum(village_count1) village_count1,
                        sum(gz_zhu_hu_count1) gz_zhu_hu_count1,
                        sum(gz_h_use_cnt1) gz_h_use_cnt1,
                        sum(lost_count1) lost_count1,
                        to_char(round(decode(nvl(sum(t.gz_zhu_hu_count1), 0),
                        0,
                        0,
                        sum(t.gz_h_use_cnt1) /
                        sum(t.gz_zhu_hu_count1)),
                        4) * 100,
                        'FM9999999990.00') || '%' markt_lv1,
                        to_char(round(decode(nvl(sum(t.gz_h_use_cnt1), 0),
                        0,
                        0,
                        sum(t.lost_count1) /
                        sum(t.gz_h_use_cnt1)),
                        4) * 100,
                        'FM9999999990.00') || '%' lost_zb1,
                        sum(village_count2) village_count2,
                        sum(gz_zhu_hu_count2) gz_zhu_hu_count2,
                        sum(gz_h_use_cnt2) gz_h_use_cnt2,
                        sum(lost_count2) lost_count2,
                        to_char(round(decode(nvl(sum(t.gz_zhu_hu_count2), 0),
                        0,
                        0,
                        sum(t.gz_h_use_cnt2) /
                        sum(t.gz_zhu_hu_count2)),
                        4) * 100,
                        'FM9999999990.00') || '%' markt_lv2,
                        to_char(round(decode(nvl(sum(t.gz_h_use_cnt2), 0),
                        0,
                        0,
                        sum(t.lost_count2) /
                        sum(t.gz_h_use_cnt2)),
                        4) * 100,
                        'FM9999999990.00') || '%' lost_zb2,
                        sum(village_count3) village_count3,
                        sum(gz_zhu_hu_count3) gz_zhu_hu_count3,
                        sum(gz_h_use_cnt3) gz_h_use_cnt3,
                        sum(lost_count3) lost_count3,
                        to_char(round(decode(nvl(sum(t.gz_zhu_hu_count3), 0),
                        0,
                        0,
                        sum(t.gz_h_use_cnt3) /
                        sum(t.gz_zhu_hu_count3)),
                        4) * 100,
                        'FM9999999990.00') || '%' markt_lv3,
                        to_char(round(decode(nvl(sum(t.gz_h_use_cnt3), 0),
                        0,
                        0,
                        sum(t.lost_count3) /
                        sum(t.gz_h_use_cnt3)),
                        4) * 100,
                        'FM9999999990.00') || '%' lost_zb3,
                        sum(village_count4) village_count4,
                        sum(gz_zhu_hu_count4) gz_zhu_hu_count4,
                        sum(gz_h_use_cnt4) gz_h_use_cnt4,
                        sum(lost_count4) lost_count4,
                        to_char(round(decode(nvl(sum(t.gz_zhu_hu_count4), 0),
                        0,
                        0,
                        sum(t.gz_h_use_cnt4) /
                        sum(t.gz_zhu_hu_count4)),
                        4) * 100,
                        'FM9999999990.00') || '%' markt_lv4,
                        to_char(round(decode(nvl(sum(t.gz_h_use_cnt4), 0),
                        0,
                        0,
                        sum(t.lost_count4) /
                        sum(t.gz_h_use_cnt4)),
                        4) * 100,
                        'FM9999999990.00') || '%' lost_zb4
                        from ${gis_user}.TB_GIS_VILLAGE_LEVEL_D t
                        where acct_day = '${param.beginDate}'
                        <e:if condition="${!empty param.latn_id}">
                            and latn_id = '${param.latn_id}'
                        </e:if>
                        <e:if condition="${empty param.village_degree}" var="empty_vd">
                            and village_level in ('001','002','003')
                        </e:if>
                        <e:else condition="${empty_vd}">
                            and village_level = '00${param.village_degree}'
                        </e:else>
                        group by t.acct_day, latn_id, latn_name, ord
                        order by ord
                    )tt
                )t
            )
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
        </e:q4l>${e: java2json(dataList.list) }
    </e:case>
    <e:description>四类小区统计 end</e:description>

    <e:description>四类小区统计清单 begin</e:description>
    <e:case value="region_detail_list">
        <e:q4l var="dataList">
            select * from (
                SELECT T.*, ROWNUM ROW_NUM FROM (
                    select t.*, COUNT(1) OVER() c_num from ${gis_user}.TB_GIS_VILLAGE_LEVEL_D_DETAIL t
                    where t.acct_day='${param.beginDate}'
                    <e:if condition="${!empty param.region_id}">
                        and t.latn_id=${param.region_id}
                    </e:if>
                    <e:if condition="${!empty param.cityNo}">
                        and t.bureau_no=${param.cityNo}
                    </e:if>
                    <e:if condition="${!empty param.centerNo}">
                        and t.union_org_code=${param.centerNo}
                    </e:if>
                    <e:if condition="${!empty param.gridNo}">
                        and t.grid_id=${param.gridNo}
                    </e:if>
                    <e:if condition="${param.village_type ne '' && param.village_type != null}">
                        and t.village_label_flg=${param.village_type}
                    </e:if>
                    <e:description>四类小区新定义，小区规模大于某人数以上的，竞争情况含有移动进线的，消费能力是全部，小区分群去掉政企。</e:description>
                    <e:if condition="${empty param.village_degree}">
                        ${four_type_default_condition1}
                    </e:if>
                    <e:if condition="${param.village_degree eq '1'}">
                        ${type_province1}
                    </e:if>
                    <e:if condition="${param.village_degree eq '2'}">
                        ${type_city1}
                    </e:if>
                    <e:if condition="${param.village_degree eq '3'}">
                        ${type_bureau1}
                    </e:if>
                    order by t.city_order_num,t.region_order_num,t.branch_no,t.grid_id,t.village_name
                ) T
            )
            WHERE ROW_NUM > ${param.page} * ${param.pageSize} AND ROW_NUM <= ${(param.page + 1)} * ${param.pageSize}
        </e:q4l>${e: java2json(dataList.list)}
    </e:case>
    <e:description>四类小区统计清单 end</e:description>

</e:switch>