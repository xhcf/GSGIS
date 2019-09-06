<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '5'
</e:q4o>
<e:q4o var="initTime">
    select max(USED_VIEW) as val from edw.tb_cde_process_para@gsedw t   WHERE T.USERD_NAME='TB_MKT_BILL_INFO'
</e:q4o>
<e:q4o var="date_range">
    select max(USED_VIEW) as max_date,min(USED_VIEW) as min_date from edw.tb_cde_process_para@gsedw t   WHERE T.USERD_NAME='TB_MKT_BILL_INFO'
</e:q4o>
<!DOCTYPE>
<html>
    <head>
        <c:resources type="easyui,app" style="b" />
        <!--<e:script value="/resources/layer/layer.js"/>-->
        <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.0"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <title>客户视图</title>
        <style>
            #produce_constuct span{margin-left:0px;}
            .cus_content_tab tr td span{font-weight:normal;}
            #flow_feature{
                max-width: 80%;
                display: inline-block;
                word-wrap: break-word;
                word-break: break-all;
                white-space: pre-wrap !important;
            }
            #user_info_addons {
                float: right;
                background-color: #3261dc;
                color: #fff;
                padding: 3px 7px;
                border-radius: 5px;
                line-height:17px;
                font-size:12px;
                text-decoration:none;
            }
            #user_info_addons_win {display:none;padding-top:4%;}
            /*客户视图 资料维护弹窗*/
            .info_addons .layui-layer-content{
                background: #ffffff;
            }
            .addons_btn{
                border-radius: 5px;
                color: #fff!important;
                padding: 3px 15px;
                cursor:pointer;
            }
            #info_add_save {
                background-color: #3d8ccf;
            }
            #info_add_cancel {
                background-color: #a9b2b9;
                margin-left:10px;
            }
            .info_add_tab_th {
                text-align:right;
                width:20%;
            }
            .layui-layer{border-color:#666;}
        </style>
        <script>
            //var cust_id = '${use_in_add6_list.list[0].USE_CUST_ID}';
            var prod_inst_id = '${param.prod_inst_id}';
            var acct_month = '${initTime.VAL}';
            console.log('${param.is_yx}');
            console.log('${param.is_lost}');

            var info_collect_handler = "";

            $(function(){
                if("${param.from_village_cell}"=="1"){//行政村 客户视图隐藏资料维护功能
                    $("#user_info_addons").hide();
                    $("#be_sure_tel_view").parent().empty();
                    $("#be_sure_addr_view").parent().empty();
                }

                //流失用户视图时，由于隐藏了上面的按钮，所以表格高度要变高
                if("${param.is_lost}"=="1"){
                    $(".tab_body_tc").css("height","100%");
                    $(".tab_body_cp").css("height","73%");
                    $(".tab_body_income").css("height","80%");
                }else{
                }

                //日期控件 年月化 begin
                var db = $('#cust_acct_day');
                db.datebox({
                    onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层
                        span.trigger('click'); //触发click事件弹出月份层
                        //fix 1.3.x不选择日期点击其他地方隐藏在弹出日期框显示日期面板
                        if (p.find('div.calendar-menu').is(':hidden')) p.find('div.calendar-menu').show();
                        if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔
                            tds = p.find('div.calendar-menu-month-inner td');
                            tds.click(function (e) {
                                e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件
                                var year = /\d{4}/.exec(span.html())[0]//得到年份
                                    , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1
                                var date_click_val = year + (month < 10 ? "0" + month : month);
                                if(date_click_val>='${date_range.MIN_DATE}' && date_click_val<='${date_range.MAX_DATE}')
                                    db.datebox('hidePanel')//隐藏日期对象
                                        .datebox('setValue', year + '-' + (month < 10 ? "0" + month : month)); //设置日期的值
                                else
                                    alert("没有该月数据");
                            });
                        }, 0);
                        yearIpt.unbind();//解绑年份输入框中任何事件
                    },
                    parser: function (s) {
                        if (!s) return new Date();
                        var arr = s.split('-');
                        return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
                    },
                    formatter: function (d) {
                        return d.getFullYear() + '-' + ((d.getMonth() + 1) < 10 ? "0" + (d.getMonth() + 1) : (d.getMonth() + 1));
                        /*getMonth返回的是0开始的，忘记了。。已修正*/
                    },
                    onChange : function(date){
                        acct_month = date.substr(0,4)+date.substr(5);
                        $(".sub_menu > a").eq(3).click();
                    }//,
                    //日期控件 可选日期的控制
                    /*validator: function(date){
                        var now = new Date();
                        var d1 = new Date(now.getFullYear(), now.getMonth());
                        var d2 = new Date(now.getFullYear(), now.getMonth());
                        return d1<=date && date<=d2;
                    }*/
                });

                var p = db.datebox('panel'), //日期选择对象
                        tds = false, //日期选择对象中月份
                        aToday = p.find('a.datebox-current'),
                        yearIpt = p.find('input.calendar-menu-year'),//年份输入框
                //显示月份层的触发控件
                        span = aToday.length ? p.find('div.calendar-title span') ://1.3.x版本
                                p.find('span.calendar-text'); //1.4.x版本
                if (aToday.length) {//1.3.x版本，取消Today按钮的click事件，重新绑定新事件设置日期框为今天，防止弹出日期选择面板

                    aToday.unbind('click').click(function () {
                        var now = new Date();
                        db.datebox('hidePanel').datebox('setValue', now.getFullYear() + '-' + ((now.getMonth() + 1) < 10 ? "0" + (now.getMonth() + 1) : (now.getMonth() + 1)));
                    });
                } else {
                    var year = acct_month.substring(0, 4);
                    var mm = acct_month.substring(4, 6);
                    db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
                }

                //日期控件 年月化 end

                //默认信息标签内容添加
                tab_content_load(0,prod_inst_id);
                //showInfoCollect();

                //标签切换

                $(".cus_content").eq(0).show();
                var $div_li =$(".sub_menu > a");
                $div_li.eq(0).addClass("selected");
                $div_li.each(function(){
                    $(this).click(function() {
                        $(this).addClass("selected").siblings().removeClass("selected");
                        var index = $div_li.index(this);
                        $(".cus_content > div").hide();
                        $(".cus_content > div").eq(index).show();

                        //点击标签切换的响应事件
                        if(index==0){
                            clearProductList();
                        }else if(index==1){//套餐信息
                            /*$("#main_offer_tab").empty();

                            var row = "<tr>";
                            row += "<td width='50'>"+"1"+"</td>";
                            row += "<td width='150'>"+"套餐xxx"+"</td>";
                            row += "<td width='100'>"+"2018-05-31"+"</td>";
                            row += "<td width='100'>"+"2018-06-10"+"</td>";
                            row += "</tr>";
                            $("#main_offer_tab").append(row);*/

                            $("#offer_list").empty();
                        }else if(index==2){//产品信息
                            $("#prod_tbody").empty();
                        }else if(index==3){//收入信息
                            $("#income_tbody").empty();
                        }
                        tab_content_load(index,prod_inst_id);
                    });
                });

                /*$(".tab_scroll").scroll(function () {
                    //账期
                    var beginDate = $('#beginDate').datebox('getValue').replace(/-/g, "");
                    var viewH = $(this).height();
                    var contentH = $(this).get(0).scrollHeight;
                    var scrollTop = $(this).scrollTop();
                    if (scrollTop / (contentH - viewH) >= 0.95) {
                        if (new Date().getTime() - begin_scroll > 500) {
                            var params = {
                                eaction: 'broad_home_list',
                                beginDate:beginDate,
                                page: ++page_list,
                                flag: global_current_flag,
                                region_id: global_region_id,
                                query_flag: query_flag,
                                query_sort: query_sort,
                                city_id: global_current_city_id,
                                pageSize: table_rows_array[0]
                            }
                            listScroll(params, false);
                        }
                        begin_scroll = new Date().getTime();
                    }
                });*/

                //资料维护
                $("#user_info_addons").on("click",function(){
                    clearInfoAdd();
                    $.post(url,{"eaction":"baseInfo","prod_inst_id":prod_inst_id},function(data){
                        var d = $.parseJSON(data);
                        var baseInfo = d[0];
                        $("#add_contract_person").text(baseInfo.CUST_NAME);
                        $("#add_contract_tel").text(baseInfo.USER_CONTACT_NBR);
                        $("#add_contract_addr").text(baseInfo.ADDRESS_DESC);
                    });
                    //显示资料维护的信息
                    showInfoCollect();
                    info_collect_handler = layer.open({
                        title: "",
                        maxmin: false, //开启最大化最小化按钮
                        //title:false,
                        offset: 'rb',
                        type: 1,
                        shade: 0,
                        area: ['386px','210px'],//sub_summary_div_size
                        content: $("#user_info_addons_win"),
                        skin: 'info_addons',
                        cancel: function (index) {
                        }
                    });
                });
                $("#info_add_save").on("click",function(){
                    console.log('aaa');
                    var new_phone = killSB($("input[name='be_sure_tel']").val());
                    var new_address = killSB($("textarea[name='be_sure_addr']").val());
                    $.post(url,{"eaction":"info_addons_save","prod_inst_id":prod_inst_id,"address_id":'${param.segment_id}',"new_phone":new_phone,"new_address":new_address},function(data){
                        var d = $.parseJSON(data);
                        if(d>0){
                            layer.msg("保存成功");
                            setTimeout(function(){
                                layer.close(info_collect_handler);
                                showInfoCollect();
                            },300);
                        }
                        else{
                            layer.msg("保存失败");
                        }
                    });

                });
                $("#info_add_cancel").on("click",function(){
                    clearInfoAdd();
                    layer.close(info_collect_handler);
                });
            });

            function killSB(str){
                return $.trim(str).replace(/[\r\n]/g,"")
            }
            function showInfoCollect(){
                $.post(url,{"eaction":"info_collect_addons","prod_inst_id":prod_inst_id,"address_id":'${param.segment_id}'},function(data){
                    var d = $.parseJSON(data);
                    if(d.length){
                        var item = d[0];
                        $("input[name='be_sure_tel']").val($.trim(item.NEW_PHONE));
                        $("textarea[name='be_sure_addr']").val($.trim(item.NEW_ADDRESS));
                        $("#be_sure_tel_view").text(phoneHide($.trim(item.NEW_PHONE)));
                        $("#be_sure_addr_view").text($.trim(item.NEW_ADDRESS));
                    }
                });
            }
            function clearInfoAdd(){
                $("#add_contract_person").text("");
                $("#add_contract_tel").text("");
                $("input[name='be_sure_tel']").val("");
                $("#add_contract_addr").text("");
                $("textarea[name='be_sure_addr']").val("");
            }

            function clearProductList(){
                $("#cust_name").empty();
                $("#cust_phone").empty();
                $("#age").empty();
                $("#cust_status").empty();
                $("#sex").empty();
                $("#main_offer_name").empty();
                $("#finish_date").empty();
                $("#inet_month").empty();
                $("#produce_constuct").empty();
                $("#cust_manager_name").empty();
                $("#cust_manager_phone").empty();
                $("#lev4_id").empty();
                $("#lev5_id").empty();
                $("#lev6_id").empty();
                $("#address_desc").empty();
            }

            function showProductList(prod_inst_id1,target){
                prod_inst_id = prod_inst_id1;
                clearProductList();
                $(target).addClass("user_switch_selected").siblings().removeClass("user_switch_selected");
                $div_li.eq(0).click();
            }

            var page = 0;
            function main_offer_load(page){
                $.post(url,{"eaction":"mainOffer","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id, 'page':page},function(data){
                    layer.close(layer_index);
                    var d = $.parseJSON(data);
                    if(d.length){
                        var acc_map = new Array();
                        for(var i = 0,l = d.length;i<l;i++){
                            var item = d[i];
                            var obj = acc_map[item.ACC_NBR];
                            if(obj!=undefined){
                                obj.push(item);
                                acc_map[item.ACC_NBR] = obj;
                            }else{
                                obj = new Array();
                                obj.push(item);
                                acc_map[item.ACC_NBR] = obj;
                            }
                        }

                        var keys = Object.keys(acc_map);
                        for(var i = 0,l = keys.length;i<l;i++){
                            var acc_nbr = keys[i];
                            var items = acc_map[acc_nbr];
                            var rowspan = items.length;

                            var row = "<tr>";
                            row += "<td class='ali_center' rowspan="+rowspan+">"+(i+1)+"</td><td rowspan="+rowspan+">"+phoneHide(acc_nbr)+"</td>";
                            var item = items[0];
                            row += "<td style='padding-left:5px;text-align:left;'>"+item.PROD_OFFER_NAME+"</td>";
                            row += "<td class='ali_center'>"+ item.EFF_DATE+"</td><td class='ali_center'>"+ item.EXP_DATE+"</td>";
                            row += "</tr>";

                            $("#offer_list").append(row);

                            var row1 = "";
                            for(var m = 1,n = items.length;m<n;m++){
                                row1 = "<tr>";
                                var item1 = items[m];
                                row1 += "<td style='padding-left:5px;text-align:left;'>"+ item1.PROD_OFFER_NAME+"</td>";
                                row1 += "<td class='ali_center'>"+ item1.EFF_DATE+"</td><td class='ali_center'>"+ item1.EXP_DATE+"</td>";
                                row1 += "</tr>";

                                $("#offer_list").append(row1);
                            }
                        }
                    }else{
                        //未查到记录
                        //layer.msg("未查到客户信息");
                        $("#offer_list").append("<tr><td colspan='5' style='text-align:center;'>未查到记录</td></tr>");
                    }
                });
            }

            //2018.10.22 号码脱敏
            function phoneHide(phone){
                var d = phone.substr(0,3);
                for(var i = 0,l = phone.length-5;i<l;i++){
                    d += "*";
                }
                return d+phone.substr(-2);
            }

            var url = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp' />";
            var layer_index = "";
            function tab_content_load(index,prod_inst_id){
                //基本信息
                layer_index = layer.load(1, {
                    shade: [0.1,'#fff'] //0.1透明度的白色背景
                });
                try{
                    if(index==0){//基本信息
                        debugger;
                        if(prod_inst_id=='undefined'){
                            if("${param.from_village_cell}"!="1"){
                                layer.close(layer_index);
                                layer.msg("未查到客户信息");
                            }
                            return;
                        }

                        $.post(url,{"eaction":"baseInfo","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id,"is_yx":"${param.is_yx}"},function(data){
                            layer.close(layer_index);
                            var d = $.parseJSON(data);
                            if(d.length){
                                var d0 = d[0];
                                $("#cust_name").text(d0.CUST_NAME);
                                $("#cust_phone").text(d0.USER_CONTACT_NBR);
                                //$("#cust_name_phone").text(d0.CUST_NAME+d0.USER_CONTACT_NBR);

                                $("#address_desc").text(d0.ADDRESS_DESC);

                                $("#age").text(d0.AGE);
                                $("#cust_status").text(d0.STOP_TYPE_NAME);
                                $("#sex").text(d0.SEX);
                                $("#main_offer_name").text(d0.PROD_OFFER_NAME);
                                $("#finish_date").text(d0.FINISH_DATE);

                                //$("#inet_month").text(inet_str);
                                $("#inet_month").text(d0.INET_MONTH);
                                $("#cust_manager_name").text(d0.CUST_MANAGER_NAME+(d0.CUST_PHONE==" "?'':"  "+d0.CUST_PHONE+""));
                                //$("#cust_manager_phone").text(d0.CUST_PHONE);

                                if('${param.from_village_cell}'==1){
                                    $.post(url,{"eaction":"getVillageCellPath","brigade_id":'${param.brigade_id}'},function(data2){
                                        var d2 = $.parseJSON(data2);
                                        if(d2.length){
                                            var obj2 = d2[0];
                                            $("#lev4_id").text(obj2.TOWN_NAME);
                                            $("#lev5_id").text(">"+obj2.VILLAGE_NAME);
                                            $("#lev6_id").text(">"+obj2.BRIGADE_NAME);
                                        }
                                    });
                                }else{
                                    $("#lev4_id").text(d0.BRANCH_NAME);
                                    $("#lev5_id").text(d0.GRID_NAME==" "?'':">"+d0.GRID_NAME);
                                    $("#lev6_id").text(d0.VILLAGE_NAME==" "?'':">"+d0.VILLAGE_NAME);
                                }


                                //产品构成
                                $.post(url,{"eaction":"prod_constuct","prod_inst_id":prod_inst_id},function(data1){
                                    var d1 = $.parseJSON(data1);
                                    if(d1.length){
                                        $("#produce_constuct").html(d1[0].PRODUCT_STRUCTURE);
                                    }else{
                                        $("#produce_constuct").html("手机 <span color=\"red\">0</span>   宽带 <span color=\"red\">0</span>   电视 <span color=\"red\">0</span>   固话 <span color=\"red\">0</span>");
                                    }
                                });

                            }else{
                                //未查到记录
                                layer.msg("未查到客户信息");
                            }
                        });
                    }else if(index==1){//套餐信息
                        page = 0;
                        main_offer_load(page);
                    }else if(index==2){//产品信息
                        /*for(var i =0,l = 15;i<l;i++){
                            var row = "<tr>";
                                row += "<td>"+(i+1)+"</td><td>手机</td><td>123123</td>";//<span>"+item.MT+"</span></div></div>";
                                row += "<td><span>流量  123123</span><span>语音  123分钟</span></td>";
                                row += "<td><span>流量  123132</span><span>语音  123分钟</span></td>";
                                row += "<td>终端：123</td>";

                            row += "</tr>";
                            $("#prod_tbody").append(row);
                            layer.close(layer_index);
                        }
                        return;*/
                        //费用合计，赠金合计
                        $.post(url,{"eaction":"products_summary","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id},function(data){
                            var d = $.parseJSON(data);
                            if(d.length){
                                $("#pro_sum_flow").html(d[0].PRODUCT_DESC);
                                //$("#pro_sum_dura").text(d[0].VOICE_DURA);
                            }else{
                                $("#pro_sum_flow").text("<span>手机总流量<span class=\"font_red\">0G</span></span> | <span>手机总通话时长<span class=\"font_red\">0分钟</span></span>");
                                //$("#pro_sum_dura").text("0");
                            }

                            $.post(url,{"eaction":"products","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id},function(data){
                                layer.close(layer_index);
                                var d = $.parseJSON(data);
                                if(d.length){
                                    var pro_ord = 1;
                                    for(var i = 0,l = d.length;i<l;i++){
                                        var item = d[i];
                                        if(item.PRODUCT_TYPE==" ")
                                            continue;
                                        var row = "<tr>";
                                        if(item.PRODUCT_ORD=='1'){
                                            row += "<td >"+(pro_ord)+"</td><td >手机</td><td >"+phoneHide(item.ACC_NBR)+"</td>";//<span>"+item.MT+"</span></div></div>";
                                            row += "<td >"+item.FLOW+"</td><td >"+item.VOICE_DURA+"</td>";
                                            row += "<td >"+item.LAST_FLOW+"</td><td >"+item.LAST_VOICE_DURA+"</td>";
                                            row += "<td style='text-align:left;padding-left:5px;'>"+(item.MT==' '?'无终端信息':'终端：'+item.MT)+"</td>";
                                            pro_ord++;
                                        }else if(item.PRODUCT_ORD=='3'){
                                            row += "<td >"+(pro_ord)+"</td><td >电视</td><td >"+phoneHide(item.ACC_NBR)+"</td>";
                                            row += "<td >"+item.FLOW+"</td><td >"+item.ONLINE_TIME+"</td>";
                                            row += "<td >"+item.LAST_FLOW+"</td><td >"+item.LAST_ONLINE_TIME+"</td>";
                                            row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                            pro_ord++;
                                        }else if(item.PRODUCT_ORD=='2'){
                                            row += "<td >"+(pro_ord)+"</td><td >宽带</td><td >"+phoneHide(item.ACC_NBR)+"</td>";
                                            row += "<td >"+item.FLOW+"</td><td ></td>";
                                            row += "<td >"+item.LAST_FLOW+"</td><td ></td>";
                                            row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                            pro_ord++;
                                        }else if(item.PRODUCT_ORD=='4'){
                                            row += "<td >"+(pro_ord)+"</td><td >固话</td><td >"+phoneHide(item.ACC_NBR)+"</td>";
                                            row += "<td ></td><td>"+item.VOICE_DURA+"</td>";
                                            row += "<td ></td><td>"+item.LAST_VOICE_DURA+"</td>";
                                            row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                            pro_ord++;
                                        }
                                        /*                                    if(item.PRODUCT_TYPE=='手机'){
                                         row += "<td width='4%'>"+(pro_ord)+"</td><td width='10%'>手机</td><td width='10%'>"+item.ACC_NBR+"</td>";//<span>"+item.MT+"</span></div></div>";
                                         row += "<td width='15%'>"+item.LAST_FLOW+"</td><td width='15%'>"+item.LAST_VOICE_DURA+"分钟</td>";
                                         row += "<td width='15%'>"+item.FLOW+"</td><td width='15%'>"+item.VOICE_DURA+"分钟</td>";
                                         row += "<td width=''>"+(item.MT==' '?'无终端信息':'终端：'+item.MT)+"</td>";
                                         pro_ord++;
                                         }else if(item.PRODUCT_TYPE=='电视'){
                                         row += "<td width='4%'>"+(pro_ord)+"</td><td width='10%'>电视</td><td width='10%'>"+item.ACC_NBR+"</td>";
                                         row += "<td width='15%'>"+item.TV_LAST_DURA+"小时</td><td width='15%'></td>";
                                         row += "<td width='15%'>"+item.TV_DURA+"小时</td><td width='15%'></td>";
                                         row += "<td width=''></td>";
                                         pro_ord++;
                                         }else if(item.PRODUCT_TYPE=='宽带'){
                                         row += "<td width='4%'>"+(pro_ord)+"</td><td width='10%'>宽带</td><td width='10%'>"+item.ACC_NBR+"</td>";
                                         row += "<td width='15%'>"+item.BROAD_LAST_FLOW+"</td><td width='15%'></td>";
                                         row += "<td width='15%'>"+item.BROAD_FLOW+"</td><td width='15%'></td>";
                                         row += "<td width=''>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                         pro_ord++;
                                         }*/

                                        row += "</tr>";
                                        $("#prod_tbody").append(row);
                                        fix();
                                    }
                                }else{
                                    //未查到记录
                                    //layer.msg("未查到产品信息");
                                    $("#prod_tbody").append("<tr><td colspan='6' style='text-align:center;'>未查到记录</td></tr>");
                                }
                            });
                        });
                    }else if(index==3){//收入信息
                        /*$.post(url,{"eaction":"incoming","addr4":'${param.segment_id}'},function(data){
                            var d = $.parseJSON(data);
                             for(var i = 0,l = 5;i<l;i++){
                                 var row = "<div>";
                                 row += "<table class='full_width' cellspacing='0' cellpadding='0'>";
                                 row += "<tr>";
                                 row += "<td><div class='list_order'>"+(i+1)+"</div></td>";
                                 row += "<td class='align_left bold_font big_auto_column big_font'>"+"全能流量王套餐-169元"+"</td>";
                                 row += "<td class='align_right color_blue small_column'>"+"合计：182.00"+"</td>";
                                 row += "</tr>"

                                 row += "<tr>";
                                 row += "<td></td>";
                                 row += "<td colspan='2' class='align_left big_auto_column'>"+"套餐月基本费"+"</td>";
                                 row += "</tr>";

                                 row += "<tr>";
                                 row += "<td></td>";
                                 row += "<td class='align_left big_auto_column'>"+"-&nbsp;天翼乐享4G"+"</td>";
                                 row += "<td class='align_right small_column'>"+"3.00"+"</td>";
                                 row += "</tr>";

                                 row += "</div>";
                                 $("#info_content").append(row);
                             }
                        });*/
                        /*$.post(url,{"eaction":"incoming_item_summary","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id},function(data){
                            layer.close(layer_index);
                            var d = $.parseJSON(data);
                            for(var i = 0,l = d.length;i<l;i++){
                                var row = "<div>";
                                row += "<table class='full_width' cellspacing='0' cellpadding='0'>";
                                row += "<tr>";
                                row += "<td><div class='list_order'>"+(i+1)+"</div></td>";
                                row += "<td class='align_left bold_font big_auto_column big_font'>"+d[i].PROD_OFFER_NAME+"</td>";
                                row += "<td class='align_right color_blue small_column'>"+"合计："+d[i].CHARGE_TOTAL+"</td>";
                                row += "</tr>"

                                row += "<tr>";
                                row += "<td></td>";
                                row += "<td colspan='2' class='align_left big_auto_column'>"+"套餐月基本费"+"</td>";
                                row += "</tr>";

                                row += "<tr>";
                                row += "<td></td>";
                                row += "<td class='align_left big_auto_column'>"+"-&nbsp;天翼乐享4G"+"</td>";
                                row += "<td class='align_right small_column'>"+"3.00"+"</td>";
                                row += "</tr>";

                                row += "</table>";
                                row += "</div>";
                                $("#income_tbody").append(row);
                            }
                        });*/
                        $.post(url,{"eaction":"incoming_summary","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id,'acct_month':acct_month},function(data){
                            var d = $.parseJSON(data);
                            if(d.length){
                                $("#incoming_total").text(d[0].OLD_CHARGE);
                                $("#incoming_invoice").text(d[0].NO_INVOICE_AMOUNT);
                            }else{
                                $("#incoming_total").text(0);
                                $("#incoming_invoice").text(0);
                            }
                        });
                        $.post(url,{"eaction":"incoming_arpu","addr4":'${param.segment_id}',"prod_inst_id":prod_inst_id,'acct_month':acct_month},function(data){
                            var d = $.parseJSON(data);
                            if(d.length){
                                var obj = d[0];
                                $("#incoming_arup").text(obj.SERV_ARPU==null?0:obj.SERV_ARPU);
                            }else{
                                $("#incoming_arup").text(0);
                            }
                        });
                        //var charge_total = 0;
                        $.post(url,{"eaction":"incoming","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id,'acct_month':acct_month},function(data){
                            layer.close(layer_index);
                            var d = $.parseJSON(data);
                            if(d.length){
                                /*
                                 1	 	 	                    1	134.00	1126.32	4
                                 2	8100000	 	                2	134.00	1126.32	4
                                 3	8100000	189邮箱	            3	0.00	46.93	4
                                 4	8100000	IPTV包月费	        3	0.00	46.93	4
                                 5	8100000	国内长途费 (移动业务)	3	0.00	46.93	4
                                 6	8100000	国内漫游话费 (移动业务)3	0.00	46.93	4
                                 7	8100000	宽带使用费LOCAL	    3	0.00	93.86	4
                                 8	8100000	宽带数据流量费	    3	0.00	46.93	4
                                 9	8100000	来电显示	            3	0.00	93.86	4
                                 */
                                var acc_map = new Array();
                                for(var i = 0,l = d.length;i<l;i++){
                                    var item = d[i];
                                    var obj = acc_map[item.ACC_NBR];
                                    if(obj!=undefined){
                                        obj.push(item);
                                        acc_map[item.ACC_NBR] = obj;
                                    }else{
                                        obj = new Array();
                                        obj.push(item);
                                        acc_map[item.ACC_NBR] = obj;
                                    }
                                }

                                var keys = Object.keys(acc_map);
                                for(var i = 0,l = keys.length;i<l;i++){
                                    var acc_nbr = keys[i];
                                    var items = acc_map[acc_nbr];
                                    var rowspan = items.length;

                                    var row = "<tr>";
                                    row += "<td class='ali_center' rowspan="+rowspan+">"+(i+1)+"</td><td style='padding-left:5px;' rowspan="+rowspan+">"+phoneHide(acc_nbr)+"</td>";
                                    var item = items[0];
                                    row += "<td style='padding-left:5px;text-align:left;'>"+item.ACCT_ITEM_TYPE_NAME+"</td>";
                                    row += "<td class='ali_center'>"+ item.OLD_CHARGE+"</td>";
                                    row += "</tr>";

                                    $("#income_tbody").append(row);

                                    var row1 = "";
                                    for(var m = 1,n = items.length;m<n;m++){
                                        row1 = "<tr>";
                                        var item1 = items[m];
                                        row1 += "<td style='padding-left:5px;text-align:left;'>"+ item1.ACCT_ITEM_TYPE_NAME+"</td>";
                                        row1 += "<td class='ali_center'>"+ item1.OLD_CHARGE+"</td>";
                                        row1 += "</tr>";

                                        $("#income_tbody").append(row1);
                                    }
                                }
                            }else{
                                //$("#incoming_total").text(0);
                                //$("#incoming_invoice").text(0);
                                $("#income_tbody").append("<tr><td colspan='4' style='text-align:center;'>未查到记录</td></tr>");
                            }
                        });
                    }else if(index==4){//行为偏好
                        try{
                            $.post(url,{"eaction":"getFavirate","prod_inst_id":prod_inst_id},function(data){
                                layer.close(layer_index);
                                var d_temp = $.parseJSON(data);
                                if(d_temp.length){
                                    var d = d_temp[0];
                                    $("#family_type").text(d.JTLX);//家庭类型
                                    $("#scoiety_group").text(d.SHFQ);//社会分群
                                    $("#pay_power").text(d.XFQL);//消费潜能
                                    $("#channel_favirate").text(d.QDPH);//渠道偏好
                                    $("#teminal_favirate").text(d.ZDLX);//终端偏好
                                    $("#teminal_brand_favirate").text(d.ZDPP);//终端品牌偏好
                                    $("#flow_feature").text(d.LLTZ);//流量特征
                                    $("#service_info").text(d.FWXX);//服务信息
                                    $("#business_favirate").text(d.YWPH);//业务偏好
                                    $("#offline_favirate").text(d.LWQX);//离网倾向
                                }else{

                                }
                            });
                        }catch(e){
                            layer.close(layer_index);
                        }
                    }
                }catch(e){
                    layer.close(layer_index);
                }
            }
        </script>
    </head>
    <body>
        <div class="cus_view_body">
            <div style="display:block;">
                <!--客户信息开始-->
                <div class="sub_menu">
                    <a href="#" class="selected">基本信息</a>
                    <a href="#">套餐信息</a>
                    <a href="#">产品信息</a>
                    <a href="#">收入信息</a>
                    <a href="#">行为偏好</a>
                </div>
                <div class="cus_content">
                    <!--基本信息开始-->
                    <div>
                        <table cellspacing="0" cellpadding="0" border="0" class="cus_content_tab" style="margin-top:1%;">
                            <tr>
                                <td>年龄:<span id="age"></span></td>
                                <td>
                                    用户状态:<span id="cust_status" style="color:red;"></span>
                                    <a href="javascript:void(0);" id="user_info_addons">资料维护</a>
                                </td>
                            </tr>
                            <tr>
                                <td>性别:<span id="sex"></span></td>
                                <td>套餐名称:<span id="main_offer_name"></span></td>
                            </tr>
                            <tr>
                                <td>联系方式:<span id="cust_phone"></span></td>
                                <td>入网日期:<span id="finish_date"></span></td>
                            </tr>
                            <tr>
                                <td>产品构成:<span id="produce_constuct"></span></td>
                                <td>在网时长:<span class="font_red" id="inet_month"></span></td>
                            </tr>
                            <tr>
                                <td>归属信息:<span id="lev4_id"></span><span id="lev5_id"></span><span id="lev6_id"></span></td>
                                <td>确认电话:<span id="be_sure_tel_view"></span></td>
                            </tr>
                            <tr>
                                <td>客户经理:<span id="cust_manager_name"></span></td>
                                <td>确认地址:<span id="be_sure_addr_view"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!--基本信息结束-->
                    <!--套餐信息开始-->
                    <div class="hidden">
                        <div class="tab_header_tc">
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <th width="">序号</th>
                                    <th width="">接入号</th>
                                    <th width="">套餐名称</th>
                                    <th width="">生效时间</th>
                                    <th width="">失效时间</th>
                                </tr>
                            </table>
                        </div>
                        <div class="tab_body_tc">
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tbody id="offer_list"></tbody>
                            </table>
                        </div>
                    </div>
                    <!--套餐信息结束-->
                    <!--产品信息开始-->
                    <div class="hidden">
                        <div class="pro_info" id="pro_sum_flow"></div>
                        <div class="tab_header">
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <th rowspan="2">序号</th>
                                    <th rowspan="2">产品</th>
                                    <th rowspan="2">接入号</th>
                                    <th colspan="2">本月使用</th>
                                    <th colspan="2">上月使用</th>
                                    <th rowspan="2">备注</th>
                                </tr>
                                <tr>
                                    <th>流量</th>
                                    <th>语音/时长</th>
                                    <th>流量</th>
                                    <th>语音/时长</th>
                                </tr>
                            </table>
                        </div>
                        <div class="tab_body_cp">
                            <table cellspacing="0" cellpadding="0" border="0"  >
                                <tbody id="prod_tbody"></tbody>
                            </table>
                        </div>
                    </div>
                    <!--产品信息结束-->
                    <!--收入信息开始-->
                    <div class="hidden">
                        <div class="income_info">
                            <div>本期费用合计<span id="incoming_total"></span>元&nbsp;&nbsp;  ARUP值<span id="incoming_arup"></span>元&nbsp;&nbsp;  赠金<span id="incoming_invoice"></span>元</div>
                            <div class="cust_acct_day_div"><input id="cust_acct_day" type="text" value="${initTime.VAL}" /></div>
                        </div>
                        <div class="tab_header_income">
                            <table  cellspacing="0" cellpadding="0">
                                <tr>
                                    <th width="">序号</th>
                                    <th width="">号码</th>
                                    <th width="">费用项</th>
                                    <th width="">金额</th>
                                </tr>
                            </table>
                        </div>
                        <div class="tab_body_income">
                            <table  cellspacing="0" cellpadding="0">
                                <tbody id="income_tbody"></tbody>
                            </table>
                        </div>
                    </div>
                    <!--收入信息结束-->
                    <!--行为偏好开始-->
                    <div class="hidden">
                        <table cellspacing="0" cellpadding="0" border="0" class="cus_content_tab" style="margin-top:1%;">
                            <tr>
                                <td style="width:63%;">家庭类型:<span id="family_type"></span></td>
                                <td>社会分群:<span id="scoiety_group" style="color:red;"></span></td>
                            </tr>
                            <tr>
                                <td>消费潜能:<span id="pay_power"></span></td>
                                <td>渠道偏好:<span id="channel_favirate"></span></td>
                            </tr>
                            <tr>
                                <td>终端偏好:<span id="teminal_favirate"></span></td>
                                <td>终端品牌偏好:<span id="teminal_brand_favirate"></span></td>
                            </tr>
                            <tr>
                                <td>流量特征:<span id="flow_feature"></span></td>
                                <td>服务信息:<span id="service_info"></span></td>
                            </tr>
                            <tr>
                                <td>业务偏好:<span id="business_favirate"></span></td>
                                <td>离网倾向:<span id="offline_favirate"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!--行为偏好结束-->
                </div>
            </div>
        </div>

        <!-- 资料维护 -->
        <div id="user_info_addons_win">
            <table style="width:90%;height:75%;margin-left:5%;">
                <tr>
                    <th class="info_add_tab_th">联&nbsp;系&nbsp;人：</th><td id="add_contract_person"></td>
                </tr>
                <tr>
                    <th class="info_add_tab_th">联系电话：</th><td id="add_contract_tel"></td>
                </tr>
                <tr>
                    <th class="info_add_tab_th">确认电话：</th><td><input type="text" name="be_sure_tel" style="width:95%;" /></td>
                </tr>
                <tr>
                    <th class="info_add_tab_th">详细地址：</th><td  id="add_contract_addr"></td>
                </tr>
                <tr>
                    <th class="info_add_tab_th">确认地址：</th><td><textarea type="text" name="be_sure_addr" style="width:95%;height:50px;"></textarea></td>
                </tr>
            </table>
            <div style="text-align:center;margin-top:1%;">
                <a href="javascript:void(0);" id="info_add_save" class="addons_btn">保存</a>
                <a href="javascript:void(0);" id="info_add_cancel" class="addons_btn">取消</a>
            </div>
        </div>

        <script>
            //利用js让头部与内容对应列宽度一致。

            function fix(){
                for(var i=0;i<=$(".tab_header tr").find("th").index();i++){
                    $(".prod_tab tr td").eq(i).css("width",$(".tab_header tr").find("th").eq(i).width());
                }
            }
            //window.load=fix();
            //$(function(){
                //fix();
            //});
            $(window).resize(function(){
                return fix();
            });

            //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。
            $('.t_table').scroll(function(){
                $('#table_head').css('margin-left',-($('.t_table').scrollLeft()));
            });
        </script>
    </body>
</html>
