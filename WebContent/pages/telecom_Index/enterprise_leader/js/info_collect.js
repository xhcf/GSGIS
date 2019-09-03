$(function(){
    openNewWinInfoCollectEdit = function (segment_id,tab_id) {
        if(tab_id==undefined)
            tab_id = 0;
        $.post(appBase+"/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp",{"eaction":"prod_list","segment_id":segment_id,'acct_month':'${user_list_m_last_month.VAL}'},function(data){
            var d = $.parseJSON(data);
            if(d.length>1){
                $("#prod_list_win > iframe").attr("src", appBase+"/pages/telecom_Index/sub_grid/viewPlane_prod_list.jsp?segment_id=" + segment_id + "&city_id=" + city_id+"&acct_month="+'${user_list_m_last_month.VAL}');
                prod_list_win = layer.open({
                    title: '客户列表',
                    //title:false,
                    type: 1,
                    shade: 0,
                    area: ['414px','355px'],
                    //offset: ['56px', '158px'],
                    content: $("#prod_list_win"),
                    skin: 'yxzx_div',//'yxzx_div',
                    cancel: function (index) {

                    }
                });
                $(".info_collect .layui-layer-setwin").addClass("close_table");
            }else if(d.length==1){
                var param = {};
                param.segment_id = segment_id;
                param.prod_inst_id = d[0].PROD_INST_ID;
                param.tab_id = tab_id;
                openCustViewByProdInstId(param);
            }else{
                var param = {};
                param.segment_id = segment_id;
                param.tab_id = tab_id;
                openCustViewByProdInstId(param);
            }
        });
    }
});
