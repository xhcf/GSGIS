<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
    <e:description>支局 市场 网格渗透率</e:description>
    <e:description>这里要求显示该网格所在支局的所有网格信息</e:description>
    <e:case value="newAdd4Order">
        <e:q4o var="branch_no">
            select distinct branch_no val from ${gis_user}.db_cde_grid where union_org_code = '${sessionScope.UserInfo.TOWN_NO}'
        </e:q4o>
        <e:q4o var="order_id">
            select to_char(sysdate,'yyyymmddhh24miss') || '${sessionScope.UserInfo.USER_ID}' || '_' val from dual
        </e:q4o>
        <e:update var="cnt">
            insert into ${gis_user}.tb_gis_addr_order
                (order_id,latn_id,bureau_no,branch_no,union_org_code,grid_id,user_id,user_name,user_tel,create_time,order_sub,order_content,order_status)
            values
                (
                    '${e:replace(order_id.VAL, "_", "")}',
                    '${sessionScope.UserInfo.AREA_NO}',
                    '${sessionScope.UserInfo.CITY_NO}',
                    '${branch_no.VAL}',
                    '${sessionScope.UserInfo.TOWN_NO}',
                    '${sessionScope.UserInfo.GRID_NO}',
                    '${sessionScope.UserInfo.USER_ID}',
                    '${sessionScope.UserInfo.USER_NAME}',
                    '${sessionScope.UserInfo.TELEPHONE}',
                    to_date('${param.send_time}','yyyy-mm-dd hh24:mi:ss'),
                    '${param.order_title}',
                    '${param.order_content}',
                    -1
                )
        </e:update>
        <e:if condition="${cnt > 0}" var="empty_res">
            ${order_id.VAL}
        </e:if>
        <e:else condition="${empty_res}">
            0
        </e:else>
    </e:case>

    <e:case value="deleteAdd4Order">
        <e:update var="cnt">
            delete from ${gis_user}.tb_gis_addr_order where order_id = '${param.order_id}'
        </e:update>${cnt}
    </e:case>

    <e:case value="getAdd4RepairList">
        <e:q4l var="dataList">
            select * from
            (
            SELECT
            a.order_id order_id_num,
            'NO:' || a.order_id order_id,
            a.order_sub ,
            decode(a.create_time,NULL,' ',to_char(a.create_time,'yyyy-mm-dd hh24:mi:ss')) send_time,
            a.user_name ,
            NVL(a.user_tel,' ' ) user_tel ,
            nvl(a.order_content,' ') order_content,
            nvl(a.opr_name,' ') opr_name,
            nvl(a.opr_tel,' ') opr_tel,
            decode(a.opr_time,NULL,' ',to_char(a.opr_time,'yyyy-mm-dd hh24:mi:ss')) opr_time,
            nvl(a.back_content,' ') back_content,
            a.order_status,
            DECODE(a.order_status, 0,'未处理',1,'已处理',-1,'待处理',' ') order_status_text,
            a.order_confirm,
            DECODE(a.order_confirm,0,'未修正',1,'已修正','未确认') order_confirm_text,
            b.latn_name,
            b.bureau_name,
            count(1) over() c_num,
            row_number() over(order by a.order_id) ROW_NUM
            FROM ${gis_user}.tb_gis_addr_order a,
            (select distinct latn_id,latn_name,bureau_no,bureau_name from ${gis_user}.db_cde_grid) b
            WHERE 1=1
            and a.latn_id = b.latn_id
            and a.bureau_no = b.bureau_no
            <e:if condition="${!empty param.city_id && param.city_id ne '-1'}">
            and a.latn_id = '${param.city_id}'
            </e:if>
            <e:if condition="${!empty param.bureau_id && param.bureau_id ne '-1'}">
            AND a.bureau_no ='${param.bureau_id}'
            </e:if>
            <e:if condition="${!empty param.branch_id && param.branch_id ne '-1'}">
            AND a.union_org_code ='${param.branch_id}'
            </e:if>
            <e:if condition="${!empty param.grid_id && param.grid_id ne '-1'}">
            AND a.grid_id ='${param.grid_id}'
            </e:if>
            <e:if condition="${!empty param.order_status && param.order_status ne '-1'}">
            AND a.order_status ='${param.order_status}'
            </e:if>
            <e:if condition="${!empty param.order_confirm && param.order_confirm ne '-1'}">
            AND a.order_confirm ='${param.order_confirm}'
            </e:if>
            <e:if condition="${!empty param.order_id && param.order_id ne '-1'}">
            and a.order_id = '${param.order_id}'
            </e:if>
            <e:if condition="${!empty param.radio0}"><e:description>整改状态</e:description>
            and a.order_confirm = '${param.radio0}'
            </e:if>
            <e:if condition="${!empty param.radio1}"><e:description>工单状态</e:description>
            and a.order_status = '${param.radio1}'
            </e:if>
            <e:if condition="${!empty param.query_text}"><e:description>工单标题</e:description>
            and a.order_sub like '%${param.query_text}%'
            </e:if>
            order by a.create_time desc
            )
            <e:if condition="${!empty param.page}">
                WHERE ROW_NUM BETWEEN ${param.page} * 20 + 1 AND (${param.page} + 1) * 20
            </e:if>
        </e:q4l>${e:java2json(dataList.list)}
    </e:case>

    <e:case value="updateAdd4Confirm">
        <e:update var="cnt">
            UPDATE ${gis_user}.tb_gis_addr_order SET order_confirm = '${param.order_confirm}' WHERE order_id = '${param.order_id}'
        </e:update>${cnt}
    </e:case>
</e:switch>