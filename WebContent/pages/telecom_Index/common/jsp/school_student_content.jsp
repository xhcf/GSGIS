<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '5'
</e:q4o>
<html>
    <head>
        <title>学生清单</title>
        <style>
            #collect_new_collect_state {
                float: left;
            }

            #collect_bselect {
                float: right;
            }

            #collect_new_collect_state, #collect_bselect {
                display: inline-block;
            }
            #collect_new_table_content{height:56%;}
            .bold_blue a{text-decoration: underline;}

            .tab_header tr th:first-child {width:6%!important;}
            .tab_header tr th:nth-child(2) {width:6%!important;}
            .tab_header tr th:nth-child(3) {width:8%!important;}
            .tab_header tr th:nth-child(4) {width:15%!important;}
            .tab_header tr th:nth-child(5) {width:18%!important;}
            .tab_header tr th:nth-child(6) {width:13%!important;}
            .tab_header tr th:nth-child(7) {width:18%!important;}
            .tab_header tr th:nth-child(8) {width:6%!important;}
            .tab_header tr th:nth-child(9) {width:10%!important;}

            #collect_new_bulid_info_list_sj tr td:first-child {width:6%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(2) {width:6%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(3) {width:8%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(4) {width:15%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(5) {width:18%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(6) {width:13%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(7) {width:18%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(8) {width:6%!important;}
            #collect_new_bulid_info_list_sj tr td:nth-child(9) {width:10%!important;}

            .red_font {color:red;}

            .inside_data_orange {
                text-align: center!important;
            }

            /*控件样式*/
            .collect_contain_choice div {width:10%;} .collect_contain_choice select {width:20%;}
            #stu_comp_01,#stu_comp_02,#stu_comp_03 {width:15%;display:inline-block;float:left;}
        </style>
        <link href='<e:url value="/pages/telecom_Index/sub_grid/css/build_view_list.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.2"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/school_workspench.css?version=1.5"/>'
              rel="stylesheet" type="text/css" media="all"/>
    </head>
    <body>
        <div id="collect_new_body">
            <table style="width:100%">
                <tr>
                    <td>
                        <div class="count_num desk_orange_bar inside_data inside_data_orange">
                            床位数：<span id="stu_sum_01" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            学生数：<span id="stu_sum_02" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <%--应收集：<span id="sjqd_ying" style ="color:#FF0000">0</span>&nbsp;&nbsp;--%>
                            移动用户：<span id="stu_sum_03" style="color:#FF0000">0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            移动渗透率：<span id="stu_sum_04" style="color:#FF0000">0</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="collect_new_choice" style="position:relative;padding-top:2px;color:black;width:100%;">
                            <div class="collect_contain_choice" style="margin:0px auto;width: 95%;float:none;">
                                <div>新生公寓：</div><select id="stu_comp_01"></select>
                                <div style="text-align: center;">男女公寓：</div><select id="stu_comp_02"></select>
                                <div style="text-align: center;">楼宇：</div><select id="stu_comp_03" style="width:35%;"></select>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
					<span>
						<div class="radio tab_accuracy_head tab_accuracy_other desk_sub_menu" id="res_tb">
                            记录数：
                            <span id="recode_cnt"></span>
                        </div>
					</span>
                    </td>
                </tr>
            </table>
        </div>
        <div style="width:96%;margin:0px auto;">
            <div class="head_table_wrapper">
                <table class="head_table tab_header" cellspacing="0" cellpadding="0">
                    <tr>
                        <th>序号</th>
                        <th>房间号</th>
                        <th>床位</th>
                        <th>院系</th>
                        <th>年级</th>
                        <th>联系人</th>
                        <th>联系电话</th>
                        <th>运营商</th>
                        <th>套餐价值</th>
                    </tr>
                </table>
            </div>
            <div id="collect_new_table_content" class="t_table">
                <table cellspacing="0" cellpadding="0" class="content_table tab_body" id="collect_new_bulid_info_list_sj" style="width: 100%"></table>
            </div>
        </div>
    </body>
</html>
<script>
    var business_id = '${param.business_id}';
    var url4sql = "<e:url value='/pages/telecom_Index/common/sql/tabData_enterprise.jsp' />";
    var type1 = 1;//新生公寓
    var type2 = "";//男女公寓
    var type3 = "";//楼宇
    var begin = 0,end = 0,seq_num = 0,page = 0;

    var sum01 = "#stu_sum_01";
    var sum02 = "#stu_sum_02";
    var sum03 = "#stu_sum_03";
    var sum04 = "#stu_sum_04";

    var comp01 = "#stu_comp_01";
    var comp02 = "#stu_comp_02";
    var comp03 = "#stu_comp_03";

    var tab_head = "";
    var tab_body = "#collect_new_bulid_info_list_sj";

    $(function(){
        get_summary();
        init_comp();
        //get_list(true);///
    });
    function get_summary(){
        $.post(url4sql,{"eaction":"getStuSummary","business_id":business_id},function(data){
            var d = $.parseJSON(data);
            if(d!=null){
                $(sum01).text(d.NUM1);
                $(sum02).text(d.NUM2);
                $(sum03).text(d.NUM3);
                $(sum04).text(d.NUM4);
            }else{
                $(sum01).text(0);
                $(sum02).text(0);
                $(sum03).text(0);
                $(sum04).text(0);
            }
        });

    }
    function init_comp(){
        /*是否新生公寓*/
        $(comp01).append("<option value=\"\">全部</option>");
        $(comp01).append("<option value=\"1\">是</option>");
        $(comp01).append("<option value=\"0\">否</option>");

        $(comp01).on("change",function(){
            type1 = $(comp01+" option:selected").val();
            fresh();
        });

        /*男女公寓*/
        $(comp02).append("<option value=\"\">全部</option>");
        $(comp02).append("<option value=\"2\">女生公寓</option>");
        $(comp02).append("<option value=\"1\">男生公寓</option>");
        $(comp02).append("<option value=\"3\">其他</option>");

        $(comp02).on("change",function(){
            type2 = $(comp02+" option:selected").val();
            fresh();
        });

        /*楼宇*/
        addBuild("","",comp03);

        $(comp03).on("change",function(){
            type3 = $(comp03+" option:selected").val();
            clear();
            get_list(true);
        });

        $(".tab_scroll").scroll(function () {
            var viewH = $(this).height();
            var contentH = $(this).get(0).scrollHeight;
            var scrollTop = $(this).scrollTop();
            if (scrollTop / (contentH - viewH) >= 0.95) {
                if (new Date().getTime() - begin > 500) {
                    get_list(false);
                }
                begin = new Date().getTime();
            }
        });
    }

    function freshBuild(){
        $(comp03).empty();
        addBuild(type1,type2,comp03);
    }

    var default_option = "<option value=\"\">全部</option>";
    function addBuild(type1,type2,target){
        //$(target).append(default_option);
        $.post(url4sql,{"eaction":"getBuildInsideSchoolOrEnterprise","village_id":business_id,"area_type":2,"is_new":type1,"sex":type2},function(data){
            var data = $.parseJSON(data);
            if(!data.length){
                $(target).append(default_option);
            }
            $.each(data,function(index,item){
                $(target).append("<option value=\""+item.SEGM_ID+"\">"+item.STAND_NAME+"</option>");
                if(index==0)///
                    type3 = item.SEGM_ID;///
            });
            $(comp03).change();///
        });
    }

    function getParams(){
        return {
            "eaction":"getStuInfo",
            "business_id":business_id,
            "is_new":type1,
            "sex":type2,
            "resid":type3,
            "page":page
        };
    }

    var fill_empty = true;
    function get_list(flag){
        var params = getParams();
        var target = tab_body;
        $.post(url4sql,params,function(data){
            var data = $.parseJSON(data);
            if(page==0){
                if(data.length){
                    $("#recode_cnt").text(data[0].C_NUM);
                }else{
                    $("#recode_cnt").text("0");
                }
            }
            if(!data.length && flag){
                if(fill_empty){
                    for(var i = 0,l=8;i<l;i++){
                        $(target).append("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
                    }
                }else{
                    $(target).append("<tr><td colspan='9'>未查询到结果</td></tr>");
                }
            }
            $.each(data,function(index,item){
                $(target).append("<tr><td>"+(++seq_num)+"</td>"+
                "<td>"+item.STAND_NAME_2+"</td>"+
                "<td>"+item.BED_NAME+"</td>"+
                "<td>"+item.DEPT_NAME+"</td>"+
                "<td>"+item.GRADE_NAME+"</td>"+
                "<td><a href=\"javascript:void(0);\" onclick=\"parent.openNewWinInfoCollectEdit('000102140000000017157466')\">"+item.CONTACT_USER+"</a></td>"+
                "<td>"+item.CONTACT_TEL+"</td>"+
                "<td>"+item.BUSINESS_NAME+"</td>"+
                "<td>"+item.FEE+"</td>"+
                "</tr>");
            });
        });
    }
    function bindClick(){
        $(tab_body)
    }

    function fresh(){
        clear();
        freshBuild();
        //get_list(true);///
    }
    function clear(){
        begin = 0,end = 0,seq_num = 0,page = 0;
        $(tab_body).empty();
    }
</script>