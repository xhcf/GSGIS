<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="last_month">
    select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '5'
</e:q4o>
<e:q4o var="initTime">
    select max(USED_VIEW) as val from edw.tb_cde_process_para@gsedw t WHERE T.USERD_NAME='TB_MKT_BILL_INFO'
</e:q4o>
<e:q4o var="date_range">
    select max(USED_VIEW) as max_date,min(USED_VIEW) as min_date from edw.tb_cde_process_para@gsedw t   WHERE T.USERD_NAME='TB_MKT_BILL_INFO'
</e:q4o>
<e:q4o var="month_range">
    select to_char(add_months(sysdate,-1),'mm')||'月' m1,to_char(add_months(sysdate,-1),'yyyymm') m01,to_char(add_months(sysdate,-2),'mm')||'月' m2,to_char(add_months(sysdate,-2),'yyyymm') m02,to_char(add_months(sysdate,-3),'mm')||'月' m3,to_char(add_months(sysdate,-3),'yyyymm') m03 from dual
</e:q4o>
<!DOCTYPE>
<html>
    <head>
        <c:resources type="easyui,app" style="b" />
        <!--<e:script value="/resources/layer/layer.js"/>-->
        <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.0"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/student_view_reset.css?version=New Date()"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <title>学生信息</title>
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
            #tab_head1 th {background: #eee;}
            #tab_head1 th,#tab_body1 td {border-bottom:solid 1px #e4e4e4;border-right:solid 1px #e4e4e4;}
            #tab_head1 th:last-child,#tab_body1 td:last-child{border-right:0px;}
            #tab_head1 th,#tab_body1 td {width:20%;text-align:center;}
            #tab_head1 {margin-bottom:0px;}
            #tab_body1 {margin-top:0px;}
        </style>
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
                    <a href="#" style="display: none;">行为偏好</a>
                </div>
                <div class="cus_content">
                    <!--基本信息开始-->
                    <div>
                        <table cellspacing="0" cellpadding="0" border="0" class="cus_content_tab" style="margin-top:1%;margin-bottom:1%;">
                            <tr>
                                <td>姓名:<span id="desc1"></span></td>
                                <td>年龄:<span id="desc8"></span></td>
                                <td>套餐名称:<span id="desc9"></span></td>
                            </tr>
                            <tr>
                                <td>套餐价值:<span id="desc2"></span></td>
                                <td>套餐到期时间:<span id="desc3"></span></td>
                                <td>床位:<span id="desc4"></span></td>
                            </tr>
                            <tr>
                                <td>学校:<span id="desc5"></span></td>
                                <td>院系:<span id="desc6"></span></td>
                                <td>年级:<span id="desc7"></span></td>
                            </tr>
                        </table>
                        <table cellspacing="0" cellpadding="0" border="0" class="cus_content_tab" id="tab_head1" style="margin-top:1%;height:25px;">
                        </table>
                        <div style="overflow-y:scroll;overflow-x:scroll;" id="tab_body1_scroll">
                            <table cellspacing="0" cellpadding="0" border="0" class="cus_content_tab" id="tab_body1" style="height:auto">
                            </table>
                        </div>
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
                                <tbody id="tab_body2"></tbody>
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
                                <tbody id="tab_body3"></tbody>
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
                                <tbody id="tab_body4"></tbody>
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
<script>
    //var cust_id = '${use_in_add6_list.list[0].USE_CUST_ID}';
    //var prod_inst_id = '${param.prod_inst_id}';
    var url4sql = "<e:url value='/pages/telecom_Index/common/sql/tabData_student.jsp' />";
    var prod_inst_id = '938861697644';
    var acct_month = '${initTime.VAL}';
    console.log('${param.is_yx}');
    console.log('${param.is_lost}');

    var info_collect_handler = "";

    $(function(){
        $("#tab_head1").css({"padding-right":14});
        $("#tab_body1_scroll").height($(".cus_content").height()-$(".cus_content_tab").eq(0).height()-$("#tab_head1").height());

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
                    $("#tab_body1").empty();
                }else if(index==1){//套餐信息
                    $("#tab_body2").empty();
                }else if(index==2){//产品信息
                    $("#tab_body3").empty();
                }else if(index==3){//收入信息
                    $("#tab_body4").empty();
                }
                tab_content_load(index,prod_inst_id);
            });
        });

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

    var page = 0;
    function main_offer_load(page){
        $.post(url4sql,{"eaction":"getComboInfo","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id, 'page':page},function(data){
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

                    $("#tab_body2").append(row);

                    var row1 = "";
                    for(var m = 1,n = items.length;m<n;m++){
                        row1 = "<tr>";
                        var item1 = items[m];
                        row1 += "<td style='padding-left:5px;text-align:left;'>"+ item1.PROD_OFFER_NAME+"</td>";
                        row1 += "<td class='ali_center'>"+ item1.EFF_DATE+"</td><td class='ali_center'>"+ item1.EXP_DATE+"</td>";
                        row1 += "</tr>";

                        $("#tab_body2").append(row1);
                    }
                }
            }else{
                //未查到记录
                //layer.msg("未查到客户信息");
                $("#tab_body2").append("<tr><td colspan='5' style='text-align:center;'>未查到记录</td></tr>");
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

    var layer_index = "";
    function tab_content_load(index,prod_inst_id){
        //基本信息
        layer_index = layer.load(1, {
            shade: [0.1,'#fff'] //0.1透明度的白色背景
        });
        try{
            if(index==0){//基本信息
                if(prod_inst_id=='undefined'){
                    layer.close(layer_index);
                    layer.msg("未查到客户信息");
                    return;
                }

                $.post(url4sql,{"eaction":"getBaseInfo","prod_inst_id":prod_inst_id},function(data){
                    var data = $.parseJSON(data);
                    if(data.length){
                        var obj = data[0];
                        $("#desc1").text(obj.CUST_NAME);
                        $("#desc8").text(obj.AGE);
                        $("#desc9").text(obj.PROD_OFFER_NAME);
                    }
                });

                $.post(url4sql,{"eaction":"getBaseInfo2","prod_inst_id":'500849995188'},function(data){
                    var obj = $.parseJSON(data);
                    if(obj!=null){
                        $("#desc2").text(obj.COMBO_VAL);
                        $("#desc3").text(obj.COMBO_END_DATE);
                        $("#desc4").text(obj.BED_NO);
                        $("#desc5").text(obj.SCHOOL_NAME);
                        $("#desc6").text(obj.COLLEGE_NAME);
                        $("#desc7").text(obj.GRADE_NAME);
                    }
                });

                $("#tab_head1").empty();
                $("#tab_head1").append("<tr><th>产品</th><th>业务使用</th><th>"+"${month_range.M1}"+"</th><th>"+"${month_range.M2}"+"</th><th>"+"${month_range.M3}"+"</th></tr>");
                $.post(url4sql,{"eaction":"getUsedList","prod_inst_id":prod_inst_id,"m1":"${month_range.M01}","m2":"${month_range.M02}","m3":"${month_range.M03}"},function(data){
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
                                row += "<td rowspan='2'>手机</td>";//<span>"+item.MT+"</span></div></div>";
                                row += "<td>流量(G)</td><td>"+item.OC1+"</td><td>"+item.OC2+"</td><td>"+item.OC3+"</td>";
                                row += "</tr><tr>";
                                row += "<td>语音(分钟)</td><td>"+item.OC4+"</td><td>"+item.OC5+"</td><td>"+item.OC6+"</td>";
                                //row += "<td style='text-align:left;padding-left:5px;'>"+(item.MT==' '?'无终端信息':'终端：'+item.MT)+"</td>";
                                pro_ord++;
                            }else if(item.PRODUCT_ORD=='3'){
                                row += "<td>电视</td>";
                                row += "<td>流量(G)</td><td>"+item.OC1+"</td><td>"+item.OC2+"</td><td>"+item.OC3+"</td>";
                                //row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                pro_ord++;
                            }else if(item.PRODUCT_ORD=='2'){
                                row += "<td>宽带</td>";
                                row += "<td>流量(G)</td><td>"+item.OC1+"</td><td>"+item.OC2+"</td><td>"+item.OC3+"</td>";
                                //row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                pro_ord++;
                            }else if(item.PRODUCT_ORD=='4'){
                                row += "<td>固话</td>";
                                row += "<td>语音(分钟)</td><td>"+item.OC1+"</td><td>"+item.OC2+"</td><td>"+item.OC3+"</td>";
                                //row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                pro_ord++;
                            }else if(item.PRODUCT_ORD=='0'){
                                row += "<td colspan='2' style='text-align:center;'>总费用(元)</td>";
                                row += "<td>"+item.OC1+"</td><td>"+item.OC2+"</td><td>"+item.OC3+"</td>";
                            }

                            row += "</tr>";
                            $("#tab_body1").append(row);
                            fix();
                        }
                    }else{
                        $("#tab_body1").append("<tr><td colspan='6' style='text-align:center;'>未查到记录</td></tr>");
                    }
                });
            }else if(index==1){//套餐信息
                page = 0;
                main_offer_load(page);
            }else if(index==2){//产品信息
                $.post(url4sql,{"eaction":"getIncomeSum2","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id},function(data){
                    var d = $.parseJSON(data);
                    if(d.length){
                        $("#pro_sum_flow").html(d[0].PRODUCT_DESC);
                    }else{
                        $("#pro_sum_flow").text("<span>手机总流量<span class=\"font_red\">0G</span></span> | <span>手机总通话时长<span class=\"font_red\">0分钟</span></span>");
                    }

                    $.post(url4sql,{"eaction":"getProduceList","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id},function(data1){
                        layer.close(layer_index);
                        var d1 = $.parseJSON(data1);
                        if(d1.length){
                            var pro_ord = 1;
                            for(var i = 0,l = d1.length;i<l;i++){
                                var item = d1[i];
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
                                    row += "<td >"+(pro_ord)+"</td><td >电视</td><td >"+item.ACC_NBR+"</td>";
                                    row += "<td >"+item.FLOW+"</td><td >"+item.ONLINE_TIME+"</td>";
                                    row += "<td >"+item.LAST_FLOW+"</td><td >"+item.LAST_ONLINE_TIME+"</td>";
                                    row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                    pro_ord++;
                                }else if(item.PRODUCT_ORD=='2'){
                                    row += "<td >"+(pro_ord)+"</td><td >宽带</td><td >"+item.ACC_NBR+"</td>";
                                    row += "<td >"+item.FLOW+"</td><td ></td>";
                                    row += "<td >"+item.LAST_FLOW+"</td><td ></td>";
                                    row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                    pro_ord++;
                                }else if(item.PRODUCT_ORD=='4'){
                                    row += "<td >"+(pro_ord)+"</td><td >固话</td><td >"+item.ACC_NBR+"</td>";
                                    row += "<td ></td><td>"+item.VOICE_DURA+"</td>";
                                    row += "<td ></td><td>"+item.LAST_VOICE_DURA+"</td>";
                                    row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                    pro_ord++;
                                }

                                row += "</tr>";
                                $("#tab_body3").append(row);
                                fix();
                            }
                        }else{
                            $("#tab_body3").append("<tr><td colspan='6' style='text-align:center;'>未查到记录</td></tr>");
                        }
                    });
                });
            }else if(index==3){//收入信息
                $.post(url4sql,{"eaction":"getIncomeSum2","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id,'acct_month':acct_month},function(data){
                    var d = $.parseJSON(data);
                    if(d.length){
                        $("#incoming_total").text(d[0].OLD_CHARGE);
                        $("#incoming_invoice").text(d[0].NO_INVOICE_AMOUNT);
                    }else{
                        $("#incoming_total").text(0);
                        $("#incoming_invoice").text(0);
                    }
                });
                $.post(url4sql,{"eaction":"getIncomeSum1","addr4":'${param.segment_id}',"prod_inst_id":prod_inst_id,'acct_month':acct_month},function(data){
                    var d = $.parseJSON(data);
                    if(d.length){
                        var obj = d[0];
                        $("#incoming_arup").text(obj.SERV_ARPU==null?0:obj.SERV_ARPU);
                    }else{
                        $("#incoming_arup").text(0);
                    }
                });
                $.post(url4sql,{"eaction":"getIncomeList","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id,'acct_month':acct_month},function(data){
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

                            $("#tab_body4").append(row);

                            var row1 = "";
                            for(var m = 1,n = items.length;m<n;m++){
                                row1 = "<tr>";
                                var item1 = items[m];
                                row1 += "<td style='padding-left:5px;text-align:left;'>"+ item1.ACCT_ITEM_TYPE_NAME+"</td>";
                                row1 += "<td class='ali_center'>"+ item1.OLD_CHARGE+"</td>";
                                row1 += "</tr>";

                                $("#tab_body4").append(row1);
                            }
                        }
                    }else{
                        //$("#incoming_total").text(0);
                        //$("#incoming_invoice").text(0);
                        $("#tab_body4").append("<tr><td colspan='4' style='text-align:center;'>未查到记录</td></tr>");
                    }
                });
            }else if(index==4){//行为偏好
                try{
                    $.post(url4sql,{"eaction":"getFavirate","prod_inst_id":prod_inst_id},function(data){
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