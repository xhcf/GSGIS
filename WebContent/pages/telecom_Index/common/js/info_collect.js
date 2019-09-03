//左侧收集
var tmp_info_collect = "1";
$(function(){
    $("#nav_info_collect").unbind();
    $("#nav_info_collect").click(
        function () {
            resetNavMenu();
            if (tmp_info_collect == '') {
                tmp_info_collect = '1';
                $("#nav_info_collect").removeClass("active");
            } else {
                tmpy_v = '';
                $("#nav_info_collect").addClass("active");
                $("#info_collect_summary_div > iframe").attr("src", "viewPlane_info_collect_summary.jsp");
                //$("#info_collect_summary_div").show();
                collect_summary_handler = layer.open({
                    title: ['收集统计', 'line-height:32px;text-size:30px;height:32px;'],
                    //title:false,
                    type: 1,
                    shade: 0,
                    area: ['710px', '485px'],
                    //offset: ['1px', '38px'],
                    content: $("#info_collect_summary_div"),
                    cancel: function (index) {
                        $("#nav_marketing2").removeClass("active");
                        layer.close(collect_summary_handler);
                        tmp_info_collect = "1";
                        return tmpx = '1';
                    }
                });
            }
        }
    );
    //打开信息收集列表
    openWinInfoCollectionList = function (latn_id, bureau_no, union_org_code, grid_id) {
        //$("#info_collect_summary_div").hide();
        $("#info_collect_list_div > iframe").attr("src", "viewPlane_info_collect_list.jsp?latn_id=" + latn_id + "&bureau_no=" + bureau_no + "&union_org_code=" + union_org_code + "&grid_id=" + grid_id);
        //$("#info_collect_list_div").show();
        collect_list_handler = layer.open({
            title: ['收集列表', 'line-height:32px;text-size:30px;height:32px;'],
            //title:false,
            type: 1,
            shade: 0,
            area: ['710px', '485px'],
            //offset: ['1px', '38px'],
            content: $("#info_collect_list_div"),
            cancel: function (index) {
                layer.close(collect_list_handler);
                $("#nav_marketing2").removeClass("active");
                return tmpx = '1';
            }
        });
    }
    //打开信息收集详情
    openWinInfoCollectionView = function (add6_id, city_id, area_id, substation, grid_id) {
        $("#info_collect_view_div > iframe").attr("src", "viewPlane_info_collect_view.jsp?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
        //$("#info_collect_view_div").show();
        collect_view_handler = layer.open({
            title: ['收集详情', 'line-height:32px;text-size:30px;height:32px;'],
            //title:false,
            type: 1,
            shade: 0,
            area: ['710px', '485px'],
            //offset: ['1px', '38px'],
            content: $("#info_collect_view_div"),
            cancel: function (index) {
                layer.close(collect_view_handler);
                $("#nav_marketing2").removeClass("active");
                return tmpx = '1';
            }
        });
    }

    //打开信息收集编辑页面
    openWinInfoCollectEdit = function (add6_id, city_id, area_id, substation, grid_id) {
        //$("#info_collect_view_div").hide();
        $("#info_collect_edit_div > iframe").attr("src", "viewPlane_info_collect_edit.jsp?add6_id=" + add6_id + "&latn_id=" + city_id + "&bureau_no=" + area_id + "&union_org_code=" + substation + "&grid_id=" + grid_id);
        //$("#info_collect_edit_div").show();
        collect_edit_handler = layer.open({
            title: ['竞争收集', 'line-height:32px;text-size:30px;height:32px;'],
            //title:false,
            type: 1,
            shade: 0,
            area: ['710px', '485px'],
            //offset: ['1px', '38px'],
            content: $("#info_collect_edit_div"),
            cancel: function (index) {
                layer.close(collect_edit_handler);
                $("#nav_marketing2").removeClass("active");
                return tmpx = '1';
            }
        });
    }
    //关闭信息收集编辑页面
    closeWinInfoCollectionEdit = function (add6_id, city_id, area_id, substation, grid_id) {
        $("#info_collect_edit_div").hide();
        openWinInfoCollectionView(add6_id, city_id, area_id, substation, grid_id);
    }

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
