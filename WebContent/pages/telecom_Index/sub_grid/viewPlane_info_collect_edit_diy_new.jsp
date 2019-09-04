<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4o var="resident_info">
    <e:if condition="${(empty param.add6 || param.add6 eq 'undefined') && (empty param.segment_id  && param.segment_id eq 'undefined')}" var="no_empty_segm_add_id">
        select '' from dual
    </e:if>
    <e:else condition="${no_empty_segm_add_id}">
        SELECT
        nvl(MAS.LATN_NAME,' ') LATN_NAME,
        nvl(MAS.BUREAU_NAME,' ') BUREAU_NAME,
        nvl(MAS.BRANCH_NAME,' ') BRANCH_NAME,
        nvl(MAS.GRID_NAME,' ') GRID_NAME,
        nvl(VIF.VILLAGE_NAME,' ') VILLAGE_NAME,
        BIF.STAND_NAME_2,
        BIF.CONTACT_PERSON,
        BIF.CONTACT_NBR,
        BIF.KD_BUSINESS,
        BIF.KD_XF,
        TO_CHAR(KD_DQ_DATE, 'YYYY-MM-DD') KD_DQ_DATE,
        BIF.ITV_BUSINESS,
        BIF.ITV_XF,
        TO_CHAR(ITV_DQ_DATE, 'YYYY-MM-DD') ITV_DQ_DATE,
        nvl(BIF.note_txt,' ') NOTE_TXT,
        TO_CHAR(BIF.WARN_DATE, 'YYYY-MM-DD') WARN_DATE,
        nvl(comments,' ') COMMENTS,
        BIF.IS_KD_DX
        FROM
        sde.map_addr_segm_${param.city_id} mas
        LEFT OUTER JOIN ${gis_user}.TB_GIS_ADDR_OTHER_ALL BIF ON mas.resid = bif.segm_id
        LEFT OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_ADDR4 BVF ON BVF.SEGM_ID = BIF.SEGM_ID
        LEFT OUTER JOIN ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO VIF ON VIF.VILLAGE_ID = BVF.VILLAGE_ID
        WHERE
        1 = 1
        <e:if condition="${!empty param.add6 && param.add6 ne 'undefined'}">
            AND BIF.SEGM_ID_2 = '${param.add6 }'
        </e:if>
        <e:if condition="${!empty param.segment_id  && param.segment_id ne 'undefined'}">
            AND BIF.SEGM_ID_2 = '${param.segment_id }'
        </e:if>
    </e:else>
</e:q4o>
<e:set var="sql_part_tab_name3">
    <e:description>2018.9.26 表名更换 EDW.TB_MKT_INFO@gsedw</e:description>
    ${gis_user}.TB_MKT_INFO
</e:set>
<e:description>
<e:q4o var="prod_obj">
    SELECT acc_nbr,cust_name,nvl(CUST_STAR_LEVEL,' ')CUST_STAR_LEVEL FROM ${sql_part_tab_name3} WHERE prod_inst_id = '${param.prod_inst_id}'
</e:q4o>
</e:description>
<!DOCTYPE>
<html>
<head>
    <c:resources type="easyui,app" style="b" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <e:script value="/resources/layer/layer.js"/>
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/custom_view.css?version=New Date()"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <script src='<e:url value="/pages/telecom_Index/common/js/tuomin.js"/>' charset="utf-8"></script>
    <title>竞争收集编辑页面</title>
    <style>
        #info_collect_tab_content,#execute_tab_content{display:none;}
        #info_collect_tab_content {width:100%;height:64%;font-size:12px;
            position: relative;}
        .menu_1 {display:none;}
        .noEmpty_kd,.noEmpty_itv{color:red;}
    </style>
</head>
<body style="margin:0px;">
<div class="cus_view_wrapper">
    <div class="cus_view_header">
        <div class="cus_view_header_tag"></div><div class="text">客户视图</div>
        <table cellspacing="0" cellpadding="0" border="0" class="">
            <tr>
                <td class="icon"></td>
                <td class="border_bot user_base_info">
                    <span class="cus_name_font" id="accnbr_custname"></span><span id="b"></span><span id="c"></span><br/>
                    <span class="cus_address_font too_long" id="collect_edit_addr"></span>
                </td>
            </tr>
        </table>
    </div>
    <%--<h3 class="wrap_a tab_menu" id="tab_switch">
        <span style="cursor:pointer;">客户信息</span>&nbsp;|&nbsp;
        <span style="cursor:pointer;">竞争收集</span>&nbsp;|&nbsp;
        <span style="cursor:pointer;">营销执行</span>
    </h3>--%>
    <ul class="menu_1">
        <li class="selected"><a href="javascript:void(0);">客户信息</a></li>
        <li><a href="javascript:void(0);">竞争信息</a></li>
        <li><a href="javascript:void(0);">营销执行</a></li>
    </ul>
    <div id="home_view_tab_content">
        <!-- 住户视图 -->
    </div>

    <!-- 竞争收集 -->
    <div id="info_collect_tab_content">
        <div class="jz_btn"><button class="save_btn" onclick="save(this)">保存</button><button class="cancel_btn" onclick="cancle()">取消</button></div>
        <table cellspacing="0" cellpadding="0" border="0" class="jz_tab">
            <tr>
                <th>归属信息</th>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" class="jz_in">
                        <tr>
                            <td height="50%">地址:&nbsp;&nbsp;<span id="collect_edit_city"></span><span id="collect_edit_bureau"></span><span id="collect_edit_sub"></span><span id="collect_edit_grid"></span></td>
                        </tr>
                        <tr>
                            <td>小区:&nbsp;&nbsp;<span id="collect_edit_village"></span></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th>客户信息</th>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" class="jz_in">
                        <tr>
                            <td style="width:50%">客户姓名:&nbsp;&nbsp;<span><input type="text" id="collect_edit_customer_name"/></span></td>
                            <td>联系方式:&nbsp;&nbsp;<span><input type="text" id="collect_edit_customer_phone"/></span></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th>宽带信息</th>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" class="jz_in">
                        <tr>
                            <td style="width:50%">是否安装:&nbsp;<input type="radio" name="is_install_kd" value="1" />是  &nbsp;&nbsp;<input type="radio" name="is_install_kd" value="0" />否</td>
                            <td>运&nbsp;&nbsp;营&nbsp;&nbsp;商:&nbsp;
                                <input type="radio" name="collect_operator" value="1"/>移动 &nbsp;&nbsp;
                                <input type="radio" name="collect_operator" value="2"/>联通&nbsp;&nbsp;
                                <input type="radio"  name="collect_operator" value="3"/>广电&nbsp;&nbsp;
                                <input type="radio" name="collect_operator" value="4"/>其他
                                <span class="noEmpty_kd">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:50%">到期时间:&nbsp;&nbsp;<input type="text"  id="collect_edit_date"/><span class="noEmpty_kd">*</span></td>
                            <td>资&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;费:&nbsp;&nbsp;<input type="text" id="collect_expense"/></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th>电视信息</th>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" class="jz_in">
                        <tr>
                            <td style="width:50%">是否安装:&nbsp;
                                <input type="radio" name="is_install_itv" value="1" />是  &nbsp;&nbsp;
                                <input type="radio" name="is_install_itv" value="0" />否
                            </td>
                            <td>运&nbsp;&nbsp;营&nbsp;&nbsp;商:&nbsp;&nbsp;
                                <input type="radio" name="collect_operator_itv" value="1" />移动 &nbsp;&nbsp;
                                <input type="radio" name="collect_operator_itv" value="2" />联通&nbsp;&nbsp;
                                <input type="radio" name="collect_operator_itv" value="3" />广电&nbsp;&nbsp;
                                <input type="radio" name="collect_operator_itv" value="4" />其他
                                <span class="noEmpty_itv">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:50%">到期时间:&nbsp;&nbsp;<input type="text" id="collect_itv_edit_date"/><span class="noEmpty_itv">*</span></td>
                            <td>资&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;费:&nbsp;&nbsp;<input type="text" id="collect_itv_expense"/></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th>备注信息</th>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" class="jz_in">
                        <tr>
                            <td style="width:50%">记事内容:&nbsp;&nbsp;<input type="text" id="collect_note_text"/></td>
                            <td>提醒时间:&nbsp;&nbsp;<input type="text"  id="collect_warn_time"/></td>
                        </tr>
                        <tr>
                            <td colspan="2">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注:&nbsp;&nbsp;<input type="text" id="collect_comments"/></td>

                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>

    <!-- 执行 -->
    <div id="execute_tab_content">

    </div>
</div>
</body>
<script type="text/javascript">
    $.fn.datebox.defaults.cleanText = '清空';

    var is_lost = '${param.is_lost}';
    if(is_lost == "undefined")
        is_lost = "";

    var is_yx = '${param.is_yx}';
    if(is_yx == "undefined")
        is_yx = "";

    var is_village = '${param.is_village}';
    if(is_village == "undefined")
        is_village = "";

    var is_zhuanpai = '${param.is_zhuanpai}';
    if(is_zhuanpai == 'undefined')
        is_zhuanpai = "";

    var accept_type = '${param.accept_type}';
    if(accept_type == 'undefined')
        accept_type = "";

    //var tuomin_addr = false;

    (function ($) {
        var buttons = $.extend([], $.fn.datebox.defaults.buttons);
        buttons.splice(1, 0, {
            text: function (target) {
                return $(target).datebox("options").cleanText
            },
            handler: function (target) {
                $(target).datebox("setValue", "");
                $(target).datebox("hidePanel");
            }
        });
        $.extend($.fn.datebox.defaults, {
            buttons: buttons
        });

    })(jQuery)

    $(function() {
        //流失用户视图点进来，屏蔽按钮
        if("${param.is_lost}"=="1" && "${param.lost_type}"=="0")
            $(".menu_1").hide();
        else{
        	if('${param.is_new_cust_view}'=='1'){
                $(".menu_1").hide();
                $(".cus_view_header_tag").next().text("竞争信息");
            }else{
                $(".menu_1").show();
            }
        }

        $("#tab_switch").show();

        //页签切换功能
        var $div_li =$(".menu_1 li");
        $div_li.each(function(index){
            $(this).on("click",function(){
                if(index==0){
                    if('${resident_info.IS_KD_DX}'=='0'){//非电信用户不能执行
                        layer.msg("该用户已离网，请注意用户的维护！当前派单已失效！");
                        $div_li.eq(1).click();
                        return;
                    }
                    $("#info_collect_tab_content").hide();
                    $("#execute_tab_content").empty();
                    $("#execute_tab_content").hide();
                    $("#home_view_tab_content").empty();
                    $("#home_view_tab_content").show();
                    $("#home_view_tab_content").load("<e:url value='/pages/telecom_Index/sub_grid/viewPlane_custom_view.jsp'/>?segment_id="+"${param.segment_id}"+"&prod_inst_id="+"${param.prod_inst_id}"+"&is_lost="+is_lost+"&is_yx="+is_yx+"&lost_type="+'${param.lost_type}');
                }else if(index==1){
                    $("#home_view_tab_content").empty();
                    $("#home_view_tab_content").hide();
                    $("#execute_tab_content").empty();
                    $("#execute_tab_content").hide();
                    $("#info_collect_tab_content").show();
                }else if(index==2){
                    //if('${param.exec_able}'!='1')//标记为可执行的，则可以点 “执行”
                        //return;
                    if('${resident_info.IS_KD_DX}'=='0'){//非电信用户不能执行
                        layer.msg("该用户已离网，请注意用户的维护！当前派单已失效！");
                        $div_li.eq(1).click();
                        return;
                    }
                    $("#home_view_tab_content").empty();
                    $("#home_view_tab_content").hide();
                    $("#info_collect_tab_content").hide();
                    $("#execute_tab_content").empty();
                    $("#execute_tab_content").show();
                    $("#execute_tab_content").load("<e:url value='/pages/telecom_Index/sub_grid/viewPlane_exec_view.jsp' />?segment_id="+"${param.segment_id}"+"&add6="+"${param.add6}"+"&prod_inst_id="+"${param.prod_inst_id}"+"&order_id="+"${param.order_id}"+"&scene_id="+"${param.scene_id}"+"&is_yx="+is_yx+"&is_village="+is_village+"&mkt_campaign_id="+"${param.mkt_campaign_id}"+"&pa_date="+"${param.pa_date}"+"&is_track="+"${param.is_track}"+"&accept_type="+accept_type);
                }
                $(this).addClass("selected").siblings().removeClass("selected");
            });
        });

        if('${param.tab_id}'=='2'){//点了执行进来
            $div_li.eq(2).click();
            /*$div_li.each(function(index) {
                $(this).unbind();
            });*/
        }else{//点了房间号进来
            if('${resident_info.IS_KD_DX}'=='0'){//没有电信宽带
                $div_li.eq(1).click();
                $div_li.each(function(index) {
                    $(this).unbind();
                });
            }else{
                $div_li.eq(0).click();
            }
        }

        $("#collect_edit_date").datebox({
            editable:false,
            panelHeight: '200px'
        })
        $("#collect_itv_edit_date").datebox({
            editable:false,
            panelHeight: '200px'
        })

        //预警时间
        $("#collect_warn_time").datebox({
            editable:false,
            panelHeight: '200px'
        })
        //是否安装宽带
        $("input[name='is_install_kd']").click(function(){
            if($(this).val()==0){
                $("input[name='collect_operator']").removeAttr("checked");
                $("input[name='collect_operator']").attr("disabled","disabled");
                $('#collect_edit_date').datebox('setValue','');
                $('#collect_edit_date').datebox({'disabled':true});
                $("#collect_expense").attr("disabled","disabled");
                $("#collect_expense").val("");
                $("input[name='collect_operator']").parent().css({color:'#aaa'});
                $("#collect_edit_date").parent().css({color:'#aaa'});
                $("#collect_expense").parent().css({color:'#aaa'});
                $(".noEmpty_kd").hide();
            }else{
                $("input[name='collect_operator']").removeAttr("disabled");
                $('#collect_edit_date').datebox({'disabled':false});
                $("#collect_expense").removeAttr("disabled");
                $("input[name='collect_operator']").parent().css({color:'#000'});
                $('#collect_edit_date').parent().css({color:'#000'});
                $('#collect_expense').parent().css({color:'#000'});
                $(".noEmpty_kd").show();
            }
        });
        //是否安装电视
        $("input[name='is_install_itv']").click(function(){
            if($(this).val()==0){
                $("input[name='collect_operator_itv']").removeAttr("checked");
                $("input[name='collect_operator_itv']").attr("disabled","disabled");
                $('#collect_itv_edit_date').datebox({'disabled':true});
                $('#collect_itv_edit_date').datebox('setValue','');
                $("#collect_itv_expense").attr("disabled","disabled");
                $("#collect_itv_expense").val("");
                $("input[name='collect_operator_itv']").parent().css({color:'#aaa'});
                $("#collect_itv_edit_date").parent().css({color:'#aaa'});
                $("#collect_itv_expense").parent().css({color:'#aaa'});
                $(".noEmpty_itv").hide();
            }else{
                $("input[name='collect_operator_itv']").removeAttr("disabled");
                $('#collect_itv_edit_date').datebox({'disabled':false});
                $("#collect_itv_expense").removeAttr("disabled");
                $("input[name='collect_operator_itv']").parent().css({color:'#000'});
                $("#collect_itv_edit_date").parent().css({color:'#000'});
                $("#collect_itv_expense").parent().css({color:'#000'});
                $(".noEmpty_itv").show();
            }
        });

        //加载数据
        load_info();
    })

    function load_info() {
        if('${param.prod_inst_id}'!='undefined')
            $.post("<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp' />",{"eaction":"baseInfo","addr4":'${param.segment_id}','prod_inst_id':'${param.prod_inst_id}','is_lost':is_lost,'is_yx':is_yx},function(data){
                var d = $.parseJSON(data);
                if(d.length){
                    var d0 = d[0];
                    if($.trim(d0.USER_CONTACT_NBR)=='' && $.trim(d0.CUST_NAME)=='' && $.trim(d0.CUST_STAR_LEVEL)=='')
                        $("#accnbr_custname").hide();
                    else{
                        if($.trim(d0.CUST_STAR_LEVEL)=='')
                            $("#accnbr_custname").html(d0.CUST_NAME);
                            //$("#accnbr_custname").html(d0.ACC_NBR+"    "+d0.CUST_NAME);
                        else{
                            $("#accnbr_custname").html(d0.CUST_NAME);
                            //$("#accnbr_custname").html(d0.ACC_NBR+"    "+d0.CUST_NAME+"   <span> "+d0.CUST_STAR_LEVEL+"</span>");
                            var star = $.trim(d0.CUST_STAR_LEVEL);
                            var star_num = 0;
                            console.log("star:"+star);
                            if(star=='一星')
                                star_num = 1;
                            else if(star=='二星')
                                star_num = 2;
                            else if(star=='三星')
                                star_num = 3;
                            else if(star=='四星')
                                star_num = 4;
                            else if(star=='五星')
                                star_num = 5;
                            else if(star=='六星')
                                star_num = 6;
                            else if(star=='七星')
                                star_num = 7;

                            $("#c").addClass("star_lev_"+star_num);
                        }
                    }
                    if(d0.SEX=='男')
                        $("#b").text("先生");
                    else if(d0.SEX=='女')
                        $("#b").text("女士");
                    else
                        $("#b").text("");
                    //$("#collect_edit_customer_name").val(d0.CUST_NAME);
                    //$("#collect_edit_customer_phone").val(d0.USER_CONTACT_NBR);
                    $("#collect_edit_addr").html(addr(d0.ADDRESS_DESC));

                    //$("#collect_edit_addr1").html(d0.ADDRESS_DESC);
                }else{
                    //未查到记录
                    //layer.msg("未查到客户信息");
                }
            });

        //还原收集过的资料

        //派单没有标准地址则不能继续执行，但其中转派的单子都没有地址，跳过验证，可以继续执行
        if(${empty resident_info} && is_zhuanpai!="1"){
            console.log("该派单没有关联的标准地址");
            $(".save_btn").unbind();
            $(".save_btn").css("background","#c9c9c9");
            return;
        }
        var temp;
        $("#collect_edit_city").html('${resident_info.LATN_NAME}');
        $("#collect_edit_bureau").html('${resident_info.BUREAU_NAME}'==' '?'':'>'+'${resident_info.BUREAU_NAME}');
        $("#collect_edit_sub").html('${resident_info.BRANCH_NAME}'==' '?'':'>'+'${resident_info.BRANCH_NAME}');
        $("#collect_edit_grid").html('${resident_info.GRID_NAME}'==' '?'':'>'+'${resident_info.GRID_NAME}');

        if($.trim('${resident_info.STAND_NAME_2}')!=''){
            $("#collect_edit_addr").html(addr('${resident_info.STAND_NAME_2}'));
        }
        $("#collect_edit_addr1").html('${resident_info.STAND_NAME_2}');

        $("#collect_edit_village").html('${resident_info.VILLAGE_NAME}');
        $("#collect_edit_customer_name").val('${resident_info.CONTACT_PERSON}');
        $("#collect_edit_customer_phone").val('${resident_info.CONTACT_NBR}');
        $("#collect_expense").val('${resident_info.KD_XF}');
        temp = '${resident_info.KD_BUSINESS}';
        //未装过宽带
        if(temp=="" || temp=="null" || temp=="5"){//未收集
            $(".noEmpty_kd").hide();
            $("input[name='collect_operator']").attr("disabled","disabled");
            $('#collect_edit_date').datebox({'disabled':true});
            $('#collect_edit_date').datebox('setValue','');
            $("#collect_expense").attr("disabled","disabled");
            $("#collect_expense").val("");
            $("input[name='collect_operator']").parent().css({color:'#aaa'});
            $("#collect_edit_date").parent().css({color:'#aaa'});
            $("#collect_expense").parent().css({color:'#aaa'});
            //没有收集过，则默认选中是 2018年12月6日11:24:16 李志昌需求
            $("input[name='is_install_kd'][value='1']").click();
        }else if(temp=="0"){//未安装宽带
            $(".noEmpty_kd").hide();
            $("input[name='is_install_kd'][value='0']").attr("checked","checked");
            $("input[name='collect_operator']").attr("disabled","disabled");
            $('#collect_edit_date').datebox({'disabled':true});
            $('#collect_edit_date').datebox('setValue','');
            $("#collect_expense").attr("disabled","disabled");
            $("#collect_expense").val("");
            $("input[name='collect_operator']").parent().css({color:'#aaa'});
            $("#collect_edit_date").parent().css({color:'#aaa'});
            $("#collect_expense").parent().css({color:'#aaa'});
        }else{//异网用户
            $(".noEmpty_kd").show();
            $("input[name='is_install_kd'][value='1']").attr("checked","checked");
            $("input[name='collect_operator'][value=" + temp + "]").attr("checked", "checked");
            $('#collect_edit_date').datebox({'disabled':false});
        }
        temp = '${resident_info.ITV_BUSINESS}';
        if(temp=="" || temp=="null" || temp=="5"){//未收集
            $(".noEmpty_itv").hide();
            $("input[name='collect_operator_itv']").attr("disabled","disabled");
            $('#collect_itv_edit_date').datebox({'disabled':true});
            $('#collect_itv_edit_date').datebox('setValue','');
            $("#collect_itv_expense").attr("disabled","disabled");
            $("#collect_itv_expense").val("");
            $("input[name='collect_operator_itv']").parent().css({color:'#aaa'});
            $('#collect_itv_edit_date').parent().css({color:'#aaa'});
            $('#collect_itv_expense').parent().css({color:'#aaa'});
        }else if(temp=="0"){//未安装itv
            $(".noEmpty_itv").hide();
            $("input[name='is_install_itv'][value='0']").attr("checked","checked");
            $("input[name='collect_operator_itv']").attr("disabled","disabled");
            $('#collect_itv_edit_date').datebox({'disabled':true});
            $('#collect_itv_edit_date').datebox('setValue','');
            $("#collect_itv_expense").attr("disabled","disabled");
            $("#collect_itv_expense").val("");
            $("input[name='collect_operator_itv']").parent().css({color:'#aaa'});
            $('#collect_itv_edit_date').parent().css({color:'#aaa'});
            $('#collect_itv_expense').parent().css({color:'#aaa'});
        }else{
            $(".noEmpty_itv").show();
            $("input[name='is_install_itv'][value='1']").attr("checked","checked");
            $("input[name='collect_operator_itv'][value=" + temp + "]").attr("checked", "checked");
            $('#collect_itv_edit_date').datebox({'disabled':false});
        }
        $("#collect_itv_expense").val('${resident_info.ITV_XF}');
        temp = '${resident_info.KD_DQ_DATE}';
        if (temp != "") {
            $("#collect_edit_date").datebox('setValue', temp)
        }

        temp = '${resident_info.ITV_DQ_DATE}';
        if (temp != "") {
            $("#collect_itv_edit_date").datebox('setValue', temp)
        }
        //记事内容
        $("#collect_note_text").val('${resident_info.NOTE_TXT}');

        //提醒时间
        temp = '${resident_info.WARN_DATE}';
        if (temp != "") {
            $("#collect_warn_time").datebox('setValue', temp);
        }

        //备注信息
        $("#collect_comments").val('${resident_info.COMMENTS}');

        return;
    }

    function decode() {
        var url = location.href;
        var subName = url.substring((url.lastIndexOf("=") + 1));
        return decodeURI(subName);
    }

    function save(doc) {
        var is_install_kd = $("input[name='is_install_kd']:checked").val();
        var collect_operator = "";
        if(is_install_kd==1)
            collect_operator = $("input[name='collect_operator']:checked").val();
        else if(is_install_kd==0)
            collect_operator = 0;

        if(is_install_kd==1 && (collect_operator=="" || collect_operator==undefined)){
            layer.msg("请选择宽带运营商 ");
            return false;
        }
        var collect_date = "";
        try{
            collect_date = $("#collect_edit_date").datebox('getValue');
        }catch(e){
            collect_date = "";
        }
        if ((is_install_kd == '0' || is_install_kd=='') && (collect_date != null && collect_date != '') ) {
            layer.msg("未装宽带时不允许选择到期时间");
            //console.log("collect_date"+collect_date);
            //console.log("is_install_kd"+is_install_kd);
            return false;
        }

        if(collect_operator!='' && collect_operator!='0' && (collect_date == null || collect_date == '')){
            layer.msg("请选择宽带到期时间");
            return false;
        }

        var is_install_itv = $("input[name='is_install_itv']:checked").val();
        var collect_operator_itv = "";
        if(is_install_itv==1)
            collect_operator_itv = $("input[name='collect_operator_itv']:checked").val();
        else if(is_install_itv==0)
            collect_operator_itv = 0;

        if(is_install_itv==1 && (collect_operator_itv=="" || collect_operator_itv==undefined)){
            layer.msg("请选择电视运营商 ");
            return false;
        }

        var collect_date_itv = "";
        try{
            collect_date_itv =  $("#collect_itv_edit_date").datebox('getValue');
        }catch(e){
            collect_date_itv = "";
        }
        if ((is_install_itv == '0' || is_install_itv=='') && (collect_date_itv != null && collect_date_itv != '') ) {
            layer.msg("未装ITV时不允许选择到期时间")
            return false;
        }

        if(collect_operator_itv!='' && collect_operator_itv!='0' && (collect_date_itv == null || collect_date_itv == '')){
            layer.msg("请选择ITV到期时间");
            return false;
        }

        var collect_note_txt = $("#collect_note_text").val();

        var collect_warn_time = "";
        try{
            collect_warn_time = $("#collect_warn_time").datebox('getValue');
        }catch(e){
            collect_warn_time = "";
        }
        var collect_comments = $("#collect_comments").val();

        collect_note_txt = collect_note_txt.replace(/\n/g,"");
        collect_note_txt = $.trim(collect_note_txt);

        if(collect_note_txt.length>400){
            layer.msg("记事内容请不要超过400字");
            return false;
        }
        collect_comments = $.trim(collect_comments);
        if(collect_comments.length>250){
            layer.msg("备注请不要超过250字");
            return false;
        }

        var params = {
            eaction: "save_collect_info_new",
            segment_id: "${param.segment_id}",
            resident_name: $("#collect_edit_customer_name").val().trim(),
            resident_phone: $("#collect_edit_customer_phone").val().trim(),
            collect_operator: collect_operator,
            "collect_expense": $("#collect_expense").val(),
            "collect_date": collect_date,
            "collect_operator_itv": collect_operator_itv,
            "collect_expense_itv": $("#collect_itv_expense").val(),
            "collect_date_itv": collect_date_itv,

            //新增字段 记事内容，预警时间，备注
            "collect_note_txt":collect_note_txt,
            "collect_warn_time":collect_warn_time,
            "collect_comments":collect_comments
        }
        $(doc).attr("disabled", "disabled");
        $.post(parent.url4Query, params, function(data) {
            data = data.trim();
            if(data>0){
                layer.msg("保存成功");
                try{
                    parent.collect_new_load_build_info(1);
                    setTimeout(function(){
                        parent.closeWinInfoCollectionEdit();
                    },2000);
                }catch(e){

                }
            }else{
                layer.msg("保存失败");
            }
        })

    }

    function cancle() {
        parent.closeWinInfoCollectionEdit();
    }
</script>
</html>
