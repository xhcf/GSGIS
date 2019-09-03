<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="now">
    SELECT TO_CHAR(SYSDATE,'yyyy-mm-dd hh24:mi:ss') val FROM DUAL
</e:q4o>
<html>
<head>
    <title>地址修正弹窗内容</title>
    <style>
        .align_right {text-align: right;}
        .align_top {vertical-align: top;}
        .tab_order_head {font-weight:bold;}
        .btn {
            height: 25px;
            width: 60px;
            border-radius: 2px;
            border: 1px solid #74b9e1;
            line-height: 16px;
            font-size: 12px;
            color: #fff;
        }
        .blue_btn {background: #2ea5e9;}
        .add4_repair_tab {height:90%;}
    </style>
</head>
<body>
    <div style="padding:12px 15px;">
        <table style="width:100%;" class="add4_repair_tab">
            <tr>
                <td class="align_right tab_order_head" style="width:15%;">派单人：</td><td style="width:35%;"><span type="text" id="sender"></span></td><td class="align_right tab_order_head" style="width:15%;">派单时间：</td><td style="width:35%;"><span type="text" id="send_time"></span></td>
            </tr>
            <tr>
                <td class="align_right tab_order_head">分公司：</td><td><span type="text" id="order_latn"></span></td><td class="align_right tab_order_head">县局：</td><td><span type="text" id="order_bureau"></span></td>
            </tr>
            <tr>
                <td class="align_right tab_order_head">主题：</td><td colspan="3"><input type="text" name="order_title" style="width:90%;height:20px;background: #fff;border:1px solid #bbb;color:#000;" /></td>
            </tr>
            <tr>
                <td class="align_right align_top tab_order_head">内容：</td><td colspan="3"><textarea name="order_content" style="width:90%;border:1px solid #bbb;" rows="10" /></td>
            </tr>
            <tr>
                <td colspan="4" style="text-align: center;padding-top:15px;"><input class="btn blue_btn" id="order_submit" type="button" value="提交" /><input class="btn blue_btn" id="order_cancel" type="button" value="取消" style="margin-left:25px;" /></td>
            </tr>
        </table>
    </div>
</body>
</html>
<script>
    var sql_url = "<e:url value='pages/telecom_Index/common/sql/tabData_add4_order.jsp' />";
    $(function(){
        initTable();

        $("#order_submit").unbind();
        $("#order_submit").bind("click",function(){
            var send_time = $("#send_time").text();
            var order_title = $("input[name='order_title']").val();
            var order_content = $("textarea[name='order_content']").val();
            $.post(sql_url,{"eaction":"newAdd4Order","order_title":order_title,"order_content":order_content,"send_time":send_time},function(data){
                var data = $.trim(data).replace("_","");
                if(data!='0'){
                    //调用webservice接口发送工单，如果失败，则要删除本地已生成的数据。如果成功，则继续后续逻辑
                    $.post('<e:url value="ws_addrRepairSendOrder.e" />',{"order_id":data,"latn_id":"${sessionScope.UserInfo.AREA_NO}","bureau_id":'${sessionScope.UserInfo.CITY_NO}',"sender":'${sessionScope.UserInfo.USER_NAME}',"sender_tel":'${sessionScope.UserInfo.TELEPHONE}',"title":order_title,"content":order_content},function(data1){
                        var data1 = $.parseJSON(data1);
                        if(data1.code==0){//派单成功
                            layer.msg("派单成功");
                            setTimeout(function(){
                                $("#order_cancel").click();
                            },1500);
                        }else{
                            layer.msg("派单失败"+data1.msg);
                            $.post(sql_url,{"eaction":"deleteAdd4Order","order_id":data},function(data2){
                                var data2 = $.parseJSON(data2);
                                console.log("删除工单条数："+data2);
                            });
                        }

                    });
                }else{
                    layer.msg("保存失败");
                }
            });
        });

        $("#order_cancel").unbind();
        $("#order_cancel").bind("click",function(){
            closeOrderPopWin();
        });
    });
    function initTable(){
        $("#sender").text('${sessionScope.UserInfo.USER_NAME}');
        $("#send_time").text('${now.VAL}');
        $("#order_latn").text('${sessionScope.UserInfo.AREA_NAME}');
        $("#order_bureau").text('${sessionScope.UserInfo.CITY_NAME}');
    }
</script>