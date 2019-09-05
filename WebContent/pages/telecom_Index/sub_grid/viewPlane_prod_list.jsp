<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="acct_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '6'
</e:q4o>
<!DOCTYPE>
<html>
<head>
    <c:resources type="easyui,app" style="b" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <e:script value="/resources/layer/layer.js"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.2"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_info_collect_edit_diy_new.css?version=1.1.7"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <title>客户列表</title>
    <style>
        .user_list {width:96%;margin:0px auto;border-collapse: collapse;border:solid 1px #dadada;}
        .user_list td {border-collapse: collapse;border:solid 1px #dadada; text-align: center;height:30px;}
        .user_list.tab_h tr td {background: #efefef;}
        .user_list tr td:first-child{width:10%;}
        .user_list tr td:nth-child(2){width:15%;}
        .user_list tr td:nth-child(3){width:15%;}
        .user_list tr td:nth-child(4){width:20%;}
        .user_list tr td:nth-child(5){width:40%;}

    </style>
</head>
<body>
<div>

    <table class="user_list tab_h" cellpadding="0" cellspacing="0" style="margin-top:8px;">
        <tr><td>序号</td><td>客户名称</td><td>产品</td><td>状态</td><td>接入号</td></tr>
    </table>

    <table id="prod_list_tab" class="user_list" cellpadding="0" cellspacing="0">

    </table>

</div>
<script type="text/javascript">
    var prod_list_url = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp' />";
    $(function() {
        //加载数据
        initProdList();
    })

    function initProdList(){
        $.post(prod_list_url,{"eaction":"prod_list","segment_id":'${param.segment_id}',"acct_month":'${acct_month.VAL}'},function(data){
            var prod_list = $.parseJSON(data);
            for(var i = 0,l = prod_list.length;i<l;i++){
                var prod = prod_list[i];
                var row = "<tr>";
                row += "<td>"+(i+1)+"</td>";
                row += "<td><a href='javascript:void(0);' onclick='toCustView("+prod.PROD_INST_ID+")'>"+prod.CUST_NAME+"</a></td>";
                row += "<td>"+prod.PRODUCT_TYPE+"</td>";
                row += "<td>"+prod.SCENE_TEXT+"</td>";
                row += "<td>"+prod.ACC_NBR+"</td>";
                row += "</tr>";
                $("#prod_list_tab").append(row);
            }
        });
    }
    function toCustView(prod_inst_id){
        var param = {};
        param.segment_id = '${param.segment_id }';
        param.prod_inst_id = prod_inst_id;
        parent.openCustViewByProdInstId(param);
        parent.closeWinCustViewWin();//关闭本窗口
    }
</script>
</body>
</html>
