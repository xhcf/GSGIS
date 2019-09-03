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
<e:q4l var="use_in_add6_list">
    select * from (SELECT DISTINCT use_cust_id FROM gis_data.TB_GIS_KD_RELATION_M where address_id='${param.segment_id}' GROUP BY use_cust_id) where rownum <=5
</e:q4l>
<e:q4o var="initTime">
    select max(USED_VIEW) as val from edw.tb_cde_process_para@gsedw t WHERE T.USERD_NAME='TB_MKT_BILL_INFO'
</e:q4o>
<!DOCTYPE>
<html>
    <head>
        <c:resources type="easyui,app" style="b" />
        <e:script value="/resources/layer/layer.js"/>
        <link href='<e:url value="/resources/themes/common/css/reset.css?version=1.0"/>' rel="stylesheet" type="text/css"
              media="all"/>
        <link type="text/css" rel="stylesheet" href="<e:url value='pages/telecom_Index/common/css/custom_view.css?version=4.3' />">
        <script src='<e:url value="/resources/component/echarts_new/echarts/js/echarts.min.js"/>'></script><!-- echarts 3.2.3 -->
        <title>客户视图</title><!-- 客户视图2.0 -->
        <style>
            .win_handle {
                position: absolute;
                right: 2%;
                top: 15px;
                width: 20px;
                height: 20px;
            }
            .village_close {
                background: url(../sandbox/images/close.png) no-repeat center/20px;
                background-size: 20px 20px;
                width: 15px;
                height: 15px;
                cursor:pointer;
            }
            .tj_tab {margin:5px auto;}
            /*#yx_advice_list {height:56%;}*/
            #payfor_figure {width:90%;height:180px;}

            /*产品订购*/
            .dg_tab tr td:first-child{width:15%;}
            .dg_tab tr td:nth-child(2){width:25%;}
            .dg_tab tr td:nth-child(3){width:45%;}
            .dg_tab tr td:nth-child(4){width:15%;}

            .dg_tab tr th:first-child{width:15%;}
            .dg_tab tr th:nth-child(2){width:25%;}
            .dg_tab tr th:nth-child(3){width:45%;}
            .dg_tab tr th:nth-child(4){width:15%;}

            #term_prev,#term_next {cursor:pointer;}
            #term_prev,#term_next,#term_index {display:none;}
            .jiechu {overflow-y:auto;}
            .short_content{
            	overflow: hidden;
            	text-overflow: ellipsis;
            	white-space: nowrap;
            }
            c {
            	font-size:12px;
            	color:#ccc;
            }
            #product_info_list {margin-top:0px;}
            /*.cus_rights th {width:16%;}
            .cus_rights td {width:16%;}*/

            /*营销推荐*/
            #yx_advice_head tr th:first-child{width:21%;}
            #yx_advice_head tr th:nth-child(2){width:65%;}
            #yx_advice_head tr th:nth-child(3){width:14%;}

            #yx_advice_list tr td:first-child{width:21%;text-align:center;}
            #yx_advice_list tr td:nth-child(2){width:65%;text-align:left;}
            #yx_advice_list tr td:nth-child(3){width:14%;text-align:center;}

            /*使用信息*/
            #sy_info_head tr th:first-child{width:25%;}
            #sy_info_head tr th:nth-child(2){width:25%;}
            #sy_info_head tr th:nth-child(3){width:25%;}
            #sy_info_head tr th:nth-child(4){width:25%;}

            #sy_info_list {margin-top:0px;}

            #sy_info_list tr td:first-child{width:25%;text-align:center;}
            #sy_info_list tr td:nth-child(2){width:25%;text-align:center;}
            #sy_info_list tr td:nth-child(3){width:25%;text-align:center;}
            #sy_info_list tr td:nth-child(4){width:25%;text-align:center;}

            /*产品订购*/
            #product_info_head tr th:first-child{width:15%;text-align:center;}
            #product_info_head tr th:nth-child(2){width:25%;text-align:center;}
            #product_info_head tr th:nth-child(3){width:45%;text-align:center;}
            #product_info_head tr th:nth-child(4){width:15%;text-align:center;}

            #product_info_list tr td:first-child{width:15%;text-align:center;}
            #product_info_list tr td:nth-child(2){width:25%;text-align:center;}
            #product_info_list tr td:nth-child(3){width:45%;text-align:left;}
            #product_info_list tr td:nth-child(4){width:15%;text-align:center;}

            #address_desc {
                white-space: nowrap;
                text-overflow: ellipsis;
                display: inline-block;
                overflow:hidden;
            }
            .terminal_history tr{height:96%;}

            .cus_view_header_tag{
                width: 25%;
                margin: 0px auto;
                text-align: center;
                border-top: 35px solid #f2f2f2;
                border-left: 28px solid #0736B1;
                border-right: 28px solid #0736B1;
            }
            .cus_view_header_tag_text {
                color: #414f69;
                height: 36px;
                line-height: 36px;
                top: 0px;
                left: 45%;
                width: 10%;
                text-align: center;
                font-size:16px;
                font-weight: bold;
                z-index:19891017;
                position:absolute;
            }
            #yx_advice_func{text-align:right;}
            .banli{
                display: inline-block;
                line-height: 24px;
                padding: 0px 5px;
                background: #0f66b0;
                color: #fff!important;
                width: 45px;
                border-radius: 5px;
                text-align:center;
                margin-top:5px;
                margin-right:5px;
            }

            /*营销推荐*/
            .yxxh{
                background-color: #ff6600;
                width: 20px;
                height: 20px;
                display: inline-block;
                /* line-height: 2; */
                text-align: center;
                vertical-align: middle;
                border-radius: 50%;
            }
            .yxcj{
                color: #ff6600;
                font-weight:bolder;
            }
            .yxjb{
                color: #07c0f7;
                font-weight:bolder;
            }
            #yx_advice_list {
                max-height: 225px;
                overflow-y: auto;
                padding: 0px 15px;
            }

            /*客户画像*/
            div b{
                white-space: nowrap;
                text-overflow: ellipsis;
                display: inline-block;
                overflow:hidden;
                display:block;
            }
            /*接触轨迹*/
            .andSoOn{
                white-space: nowrap;
                text-overflow: ellipsis;
                display: inline-block;
                overflow:hidden;
                display:block;
            }
            /*整体滚动条*/
            body {
                overflow-y:hidden;
            }
            .win_body_scroll{
                overflow-y: scroll;
                height:100%;
            }
        </style>
        <script>
            var is_lost = '${param.is_lost}';
            if(is_lost == "undefined")
                is_lost = "";

            var is_yx = '${param.is_yx}';
            if(is_yx == "undefined")
                is_yx = "";

            var is_village = '${param.is_village}';
            if(is_village == "undefined")
                is_village = "";

            var cust_id = '${use_in_add6_list.list[0].USE_CUST_ID}';
            var prod_inst_id = '${param.prod_inst_id}';
            var add6 = '${param.add6}';
            var acct_month = '${initTime.VAL}';
            var url = "<e:url value='/pages/telecom_Index/common/sql/viewPlane_custom2_action.jsp' />";
            $(function(){
                $(".village_close").unbind();
                $(".village_close").bind("click",function(){
                    parent.closeCustomView();
                });

                //默认信息标签内容添加
                tab_content_load(0,prod_inst_id);//基本信息
                tab_content_load(1,prod_inst_id);//套餐信息

                $("#sy_info_list").empty();
                tab_content_load(2,prod_inst_id);//使用信息
                tab_content_load(3,prod_inst_id);//收入信息
                tab_content_load(4,prod_inst_id);//行为偏好，客户画像

                //营销推荐
                $("#yx_advice_list").empty();
                yx_advice_list();

                //产品订购
                $("#product_info_list").empty();
                product_info_list();

                //终端换机信息
                $("#term_index").text("  "+0+"/"+0+"  ");
                clearTerimnal();
                terminal_info();
                $("#term_prev").unbind();
                $("#term_next").unbind();

                //消费趋势
                payFor_summary();
                payFor_echart = echarts.init(document.getElementById('payfor_figure'));
                payFor_figure(prod_inst_id);

                //投诉举报
                $(".tsjb_history").empty();
                tsjb_history();

                //接触轨迹
                $(".service_history").empty();
                contract_history();

                //客户权益
                getCustRights();
            });

            //合并单元格
            function autoRowSpan(tb,row,col){
                var lastValue="";
                var value="";
                var pos=1;
                for(var i=row;i<tb.rows.length;i++)
                {
                    value = tb.rows[i].cells[col].innerHTML;
                    if(lastValue == value)
                    {
                        tb.rows[i].deleteCell(col);
                        tb.rows[i-pos].cells[col].rowSpan = tb.rows[i-pos].cells[col].rowSpan+1;
                        pos++;
                    }else{
                        lastValue = value;
                        pos=1;
                    }
                }
            }

            function clearTerimnal(){
            	$("#acc_nbr_sel").text("--");
            	$("#term_fav").text("--");//终端偏好,档次
            	$("#term_cop_fav").text("--");//终端品牌偏好
            	$(".terminal_history").empty();
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
                $("#status").empty();
                $("#contact_tel").empty();
                $("#inet_date").empty();
                $("#inet_during").empty();
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
                        //暂无数据
                        //layer.msg("未查到客户信息");
                        $("#offer_list").append("<tr><td colspan='5' style='text-align:center;'>暂无数据</td></tr>");
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
                        $.post(url,{"eaction":"baseInfo","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id,"is_yx":"${param.is_yx}"},function(data){
                            layer.close(layer_index);
                            var d = $.parseJSON(data);
                            if(d.length){
                                var d0 = d[0];
                                $("#cust_name").text(d0.CUST_NAME);//*
                                $("#sex").text(d0.SEX);//*
                                $("#age").text(d0.AGE);//*
                                $("#is_sm").text(d0.IS_SM);
                                $("#address_desc").text(d0.ADDRESS_DESC);//*
                                $("#address_desc").attr("title",d0.ADDRESS_DESC);
                                $("#cust_manager_name").text(d0.CUST_MANAGER_NAME+(d0.CUST_PHONE==" "?'':"("+d0.CUST_PHONE+")"));

                                $("#status").text(d0.STOP_TYPE_NAME);
                                $("#contact_tel").text(d0.USER_CONTACT_NBR);
                                $("#inet_date").text(d0.FINISH_DATE);
                                $("#inet_during").text(d0.INET_MONTH);

                                //$("#cust_phone").text(d0.USER_CONTACT_NBR);//*
                                //$("#cust_name_phone").text(d0.CUST_NAME+d0.USER_CONTACT_NBR);

                                //$("#cust_status").text(d0.STOP_TYPE_NAME);

                                //$("#main_offer_name").text(d0.PROD_OFFER_NAME);
                                //$("#finish_date").text(d0.FINISH_DATE);

                                //$("#inet_month").text(inet_str);
                                //$("#inet_month").text(d0.INET_MONTH);

                                //$("#cust_manager_phone").text(d0.CUST_PHONE);

                                //$("#lev4_id").text(d0.BRANCH_NAME);
                                //$("#lev5_id").text(d0.GRID_NAME==" "?'':">"+d0.GRID_NAME);
                                //$("#lev6_id").text(d0.VILLAGE_NAME==" "?'':">"+d0.VILLAGE_NAME);

                                //产品构成
                                $.post(url,{"eaction":"prod_constuct","prod_inst_id":prod_inst_id},function(data1){
                                    var d1 = $.parseJSON(data1);
                                    if(d1.length){
                                        $("#produce_constuct").html(d1[0].PRODUCT_STRUCTURE);
                                    }else{
                                        $("#produce_constuct").html("<span class=\"value\">宽带【0】</span><span class=\"value\">移动【0】</span><br/><span class=\"value\">电视【0】</span><span class=\"value\">固话【0】</span>");
                                    }
                                });

                            }else{
                                //暂无数据
                                layer.msg("未查到客户信息");
                            }
                        });
                    }else if(index==1){//套餐信息
                        page = 0;
                        main_offer_load(page);
                    }else if(index==2){//使用信息
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
                        $.post(url,{"eaction":"products","addr4":'${param.segment_id}','prod_inst_id':prod_inst_id},function(data){
                            layer.close(layer_index);
                            var d = $.parseJSON(data);
                            if(d.length){
                                var pro_ord = 1;
                                for(var i = 0,l = d.length;i<l;i++){
                                    var item = d[i];
                                    if(item.PRODUCT_ORD==" ")
                                        continue;
                                    var row = "<tr>";
                                    if(item.PRODUCT_ORD=='1'){
                                        row += "<td>"+ phoneHide(item.ACC_NBR)+"</td>";
                                        row += "<td class='tele'>语音时长</td>";
                                        //row += "<td>分钟</td>";
                                        row += "<td>"+item.VOICE_DURA+"</td>";
                                        row += "<td>"+item.LAST_VOICE_DURA+"</td>";
                                        row += "</tr>";

                                        row += "<tr>";
                                        row += "<td>"+ phoneHide(item.ACC_NBR)+"</td>";
                                        row += "<td class='flow'>流量使用</td>";
                                        //row += "<td>GB</td>";
                                        row += "<td>"+item.FLOW+"</td>";
                                        row += "<td>"+item.LAST_FLOW+"</td>";

                                        /*row += "<td >"+(pro_ord)+"</td><td >手机</td><td >"+phoneHide(item.ACC_NBR)+"</td>";//<span>"+item.MT+"</span></div></div>";
                                        row += "<td >"+item.FLOW+"</td><td >"+item.VOICE_DURA+"</td>";
                                        row += "<td >"+item.LAST_FLOW+"</td><td >"+item.LAST_VOICE_DURA+"</td>";
                                        row += "<td style='text-align:left;padding-left:5px;'>"+(item.MT==' '?'无终端信息':'终端：'+item.MT)+"</td>";*/
                                        pro_ord++;
                                    }else if(item.PRODUCT_ORD=='3'){
                                        /*row += "<td >"+(pro_ord)+"</td><td >电视</td><td >"+item.ACC_NBR+"</td>";
                                        row += "<td >"+item.FLOW+"</td><td >"+item.ONLINE_TIME+"</td>";
                                        row += "<td >"+item.LAST_FLOW+"</td><td >"+item.LAST_ONLINE_TIME+"</td>";
                                        row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";*/
                                        row += "<td>"+ phoneHide(item.ACC_NBR)+"</td>";
                                        row += "<td class='itv'>ITV时长</td>";
                                        //row += "<td>小时</td>";

                                        row += "<td>"+item.ONLINE_TIME+"</td>";
                                        row += "<td>"+item.LAST_ONLINE_TIME+"</td>";
                                        pro_ord++;
                                    }else if(item.PRODUCT_ORD=='2'){
                                        /*row += "<td >"+(pro_ord)+"</td><td >宽带</td><td >"+item.ACC_NBR+"</td>";
                                        row += "<td >"+item.FLOW+"</td><td ></td>";
                                        row += "<td >"+item.LAST_FLOW+"</td><td ></td>";
                                        row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";*/
                                        row += "<td>"+ phoneHide(item.ACC_NBR)+"</td>";
                                        row += "<td class='broad'>宽带流量</td>";
                                        //row += "<td>GB</td>";

                                        row += "<td>"+item.FLOW+"</td>";
                                        row += "<td>"+item.LAST_FLOW+"</td>";
                                        pro_ord++;
                                        pro_ord++;
                                    }else if(item.PRODUCT_ORD=='4'){
                                        /*row += "<td >"+(pro_ord)+"</td><td >固话</td><td >"+item.ACC_NBR+"</td>";
                                        row += "<td ></td><td>"+item.VOICE_DURA+"</td>";
                                        row += "<td ></td><td>"+item.LAST_VOICE_DURA+"</td>";
                                        row += "<td style='text-align:left;padding-left:5px;'>"+(item.EPON_TYPE==' '?'':'接入方式：'+item.EPON_TYPE)+"</td>";
                                        pro_ord++;*/
                                    }
                                    /*if(item.PRODUCT_TYPE=='手机'){
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
                                    $("#sy_info_list").append(row);
                                    fix();
                                }
                                var ptable = document.getElementById("sy_info_list");
                                //合并单元格
                                autoRowSpan(ptable,0,0);
                            }else{
                                //暂无数据
                                //layer.msg("未查到产品信息");
                                $("#sy_info_list").append("<tr><td colspan='6' style='text-align:center;color:#fff;'>暂无数据</td></tr>");
                            }
                        });
                    }else if(index==3){//收入信息
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
                                $("#income_tbody").append("<tr><td colspan='4' style='text-align:center;'>暂无数据</td></tr>");
                            }
                        });
                    }else if(index==4){//行为偏好
                        try{
                            $.post(url,{"eaction":"getFavirate","prod_inst_id":prod_inst_id},function(data){
                                layer.close(layer_index);
                                var d_temp = $.parseJSON(data);
                                if(d_temp.length){
                                    var d = d_temp[0];
                                    $("#family_type").attr("title",d.JTLX);//家庭类型
                                    $("#family_type").text(d.JTLX);//家庭类型
                                    $("#scoiety_group").attr("title",d.SHFQ);//社会分群
                                    $("#scoiety_group").text(d.SHFQ);//社会分群
                                    $("#pay_power").attr("title",d.XFQL);//消费潜能
                                    $("#pay_power").text(d.XFQL);//消费潜能
                                    $("#channel_favirate").attr("title",d.QDPH);//渠道偏好
                                    $("#channel_favirate").text(d.QDPH);//渠道偏好
                                    $("#teminal_favirate").attr("title",d.ZDLX);//终端偏好
                                    $("#teminal_favirate").text(d.ZDLX);//终端偏好
                                    $("#teminal_brand_favirate").attr("title",d.ZDPP);//终端品牌偏好
                                    $("#teminal_brand_favirate").text(d.ZDPP);//终端品牌偏好
                                    $("#flow_feature").attr("title",d.LLTZ);
                                    $("#flow_feature").text(d.LLTZ=='未知'?'未知':substr(d.LLTZ));//流量特征
                                    $("#service_info").attr("title",d.FWXX);//服务信息
                                    $("#service_info").text(d.FWXX);//服务信息
                                    $("#business_favirate").attr("title",d.YWPH);//业务偏好
                                    $("#business_favirate").text(d.YWPH);//业务偏好
                                    $("#offline_favirate").attr("title",d.LWQX);//离网倾向
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
            //营销推荐
            function yx_advice_list(){
            	$.post(url,{"eaction":"getVillageAdvise","prod_inst_id":prod_inst_id},function(data){
                    var list = $.parseJSON(data);
                    if(list.length){
                        for(var i = 0,l = list.length;i<l;i++){
                            var item = list[i];
                            var str = "<div style='margin-bottom:8px;'>";
                            str += "<span class='yxxh'>"+(i+1)+"</span>";
                            str += "<span class='yxcj'>"+item.SCENE_NAME+"</span><br/>";
                            str += "<div style='padding-left:20px;margin-bottom:'>";
                            str += "<span class='yxjb'>营销脚本：</span><span>"+item.CONTACT_SCRIPT+"</span>";
                            str += "</div>";
                            str += "</div>";
                            $("#yx_advice_list").append(str);
                        }

                        /*
                        var data_array = new Array();
                        for(var i= 0,l = list.length;i<l;i++){
                            var d = list[i];
                            var row = "<tr>";
                            row += "<td>"+ phoneHide($.trim(d.ACC_NBR)) +"</td>";
                            row += "<td style='text-align:left'><span>【" +d.MKT_CONTENT + "】</span></br>"+d.MKT_REASON +"</td>";
                            row += "<td><a href=\"javascript:void(0);\" class=\"banli\" >办理</a></td>";
                            row += "</tr>";
                            $("#yx_advice_list").append(row);

                            //工单执行
                        }*/
                        $(".banli").on("click",function(){
                            var params = {};
                            params.segment_id = '${param.segment_id}';
                            params.add6 = '${param.add6}';
                            params.prod_inst_id = '${param.prod_inst_id}';
                            params.order_id = '${param.order_id}';
                            params.scene_id = '${param.scene_id}';
                            params.is_yx = is_yx;
                            params.is_village = is_village;
                            params.mkt_campaign_id = '${param.mkt_campaign_id}';
                            params.pa_date = '${param.pa_date}';
                            parent.openExecuteShow(params);
                        });

                        /*销售品推荐*/
                        var acct_month = '${initTime.VAL}';
                        var url4Query_sandBox = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox.jsp"/>';
                        var url4Query_custom = '<e:url value="/pages/telecom_Index/common/sql/viewPlane_custom_action.jsp"/>';
                        $.post(url4Query_custom,{"eaction":"incoming_arpu","acct_month":acct_month,"prod_inst_id":prod_inst_id},function(data){
                            var d0 = $.parseJSON(data);
                            if(d0.length){
                                var d = d0[0];
                                $.post(url4Query_sandBox,{"eaction":"getMktProduceAdvice","arpu": d.SERV_ARPU},function(data1){
                                    var d1 = $.parseJSON(data1);
                                    if(d1==null){
                                        //
                                    }else{
                                        var yxtj = "";
                                        yxtj += "<div style='margin-bottom:5px;'><span class=\"yxjb\">销售品推荐：</span><span>"+ d1.TC_NAME+"</span></div>";
                                        $("#yx_advice_list > div > div").prepend(yxtj);
                                    }
                                });
                            }else{
                                //
                            }
                        });
                    }else{
                        $("#yx_advice_func").hide();
                        $("#yx_advice_list").append("<div style='color:#aec6dc;background:none;width: 100%;height: 65%;display: block;text-align: center;line-height: 21;vertical-align: middle;'>暂无数据</div>");
                        ///$("#yx_advice_list").append("<tr><td colspan='3' style='color:#aec6dc;background:none;'>暂无数据</td></tr>");
                    }
                });

            }

            //产品订购
            function product_info_list(){
                $.post(url,{"eaction":"product_info_list","prod_inst_id":prod_inst_id},function(data){
                    var list = $.parseJSON(data);
                    if(list.length){

                        //合并单元格
                        var pro_array = new Array();
                        var acc_array = new Array();

                        for(var i= 0,l = list.length;i<l;i++) {
                            var d = list[i];
                            var obj = pro_array[d.ACC_NBR];
                            if (!obj) {
                                obj = new Array();
                                acc_array.push(d.ACC_NBR);
                            }
                            obj.push({
                                "type": d.PRODUCT_ORD,
                                "advise": d.PROD_OFFER_NAME,
                                "stop_type": d.STOP_TYPE_NAME
                            });
                            pro_array[d.ACC_NBR] = obj;
                        }

                        for(var i = 0,l = acc_array.length;i<l;i++){
                            var acc_nbr = acc_array[i];
                            var items = pro_array[acc_nbr];
                            var rowspan = items.length;

                            var row = "<tr>";

                            if(items[0].type=='1'){
                                row += "<td rowspan='"+ items.length+"'>宽带</td>";
                            }else if(items[0].type=='2'){
                                row += "<td rowspan='"+ items.length+"'>ITV</td>";
                            }else if(items[0].type=='3'){
                                row += "<td rowspan='"+ items.length+"'>移动</td>";
                            }else if(items[0].type=='4'){
                                row += "<td rowspan='"+ items.length+"'>固话</td>";
                            }else{
                                row += "<td rowspan='"+ items.length+"'>其他</td>";
                            }

                            row += "<td rowspan="+rowspan+">"+phoneHide(acc_nbr)+"</td>";
                            var item = items[0];
                            row += "<td style='padding-left:5px;text-align:left;'>"+item.advise+"</td>";
                            row += "<td class='ali_center'>"+ item.stop_type+"</td>";
                            row += "</tr>";

                            $("#product_info_list").append(row);

                            var row1 = "";
                            for(var m = 1,n = items.length;m<n;m++){
                                row1 = "<tr>";
                                var item1 = items[m];
                                row1 += "<td style='padding-left:5px;text-align:left;'>"+ item1.advise+"</td>";
                                row1 += "<td class='ali_center'>"+ item1.stop_type+"</td>";
                                row1 += "</tr>";

                                $("#product_info_list").append(row1);
                            }
                        }

                        //不合并单元格
                        /*for(var i= 0,l = list.length;i<l;i++){
                            var row = "<tr>";
                            var d = list[i];

                            if(d.PRODUCT_ORD=='1'){
                                row += "<td>宽带</td>";
                            }else if(d.PRODUCT_ORD=='2'){
                                row += "<td>ITV</td>";
                            }else if(d.PRODUCT_ORD=='3'){
                                row += "<td>移动</td>";
                            }else if(d.PRODUCT_ORD=='4'){
                                row += "<td>固话</td>";
                            }else{
                                row += "<td></td>";
                            }
                            row += "<td>"+ phoneHide(d.ACC_NBR)+"</td>";
                            row += "<td><div class='advise_div'><span>"+d.PROD_OFFER_NAME+"</span></div></td>";
                            row += "<td>"+ d.STOP_TYPE_NAME+"</td>";
                            row += "</tr>";
                            $("#product_info_list").append(row);
                        }*/
                    }else{
                        $("#product_info_list").append("<tr><td colspan='4'>暂无数据</td></tr>");
                    }
                });
            }

            function payFor_summary(){
            	$.post(url,{"eaction":"getPayfor","prod_inst_id":prod_inst_id},function(data){
            		var summary = $.parseJSON(data);
            		if(summary.length){
            			var item = summary[0];
            			$("#remain_money").text(item.ACCT_BAL);
            			$("#owe_money").text(item.OWE_CHARGE);
            		}
            	});
            }
            var payFor_echart = ""
            var month_array = "";
          	var data_array = "";

          	var option = {
                title:{
                    text:'月消费额趋势',
                    textStyle:{
                        color:'#3891E3',
                        fontSize:12
                    },
                    left:'center',
                    top:'0%'
                },
                grid:{
                    top:40,
                    bottom:37,
                    left:5,
                    right:5
                },
                xAxis: {
                    type: 'category',
                    data: month_array,
                    axisLine:{
                        show:true,
                        lineStyle:{
                            color:'#aaa',
                            opacity:0.5
                        }
                    },
                    axisTick:{
                        show:false
                    },
                    axisLabel:{
                        color:'#86A3A9',
                        opacity:0.3
                    }
                },
                yAxis: {
                    type: 'value',
                    axisLine:{
                        show:true,
                        lineStyle:{
                            color:'#aaa',
                            opacity:0.5
                        }
                    },
                    axisTick:{
                        show:false
                    },
                    axisLabel:{
                        color:'#86A3A9',
                        opacity:0.3
                    },
                    splitLine:{
                        show:false,
                        lineStyle:{
                            opacity:0.3
                        }
                    },
                    max:function(value){
                        return value.max * 1.2;
                    }
                },
                series: [{
                    data: data_array,
                    type: 'line',
                    smooth: true,
                    lineStyle:{
                        normal:{
                            color:'#5CB561',
                            width:1
                        }
                    },
                    areaStyle:{
                            normal:{
                                color:'#5CB561',
                            opacity:0.3
                            }
                    },
                    symbolSize:8,
                    itemStyle:{
                        normal:{
                            color:'#5CB561',
                            borderWidth:2,
                            label:{
                                show:true
                            }
                        }
                    }
                }]
            };

            // 趋势曲线图
            function payFor_figure(){
          		$.post(url,{"eaction":"getPayforFigue","prod_inst_id":prod_inst_id},function(data){
          			month_array = new Array();
          			data_array = new Array();
          			var max = new Array();
          			var payFors = $.parseJSON(data);
          			for(var i = 0,l = payFors.length;i<l;i++){
          				var d = payFors[i];
          				month_array.push(d.MONTH_CODE);
          				data_array.push({'name':d.MONTH_CODE,'value':d.OLD_CHARGE});
          				max.push(d.OLD_CHARGE);
          			}
          			option.xAxis.data = month_array;
                    option.series[0].data = data_array;
                    //option.yAxis.max = max.sort()[0]*1.2;
                    payFor_echart.setOption(option);
          		});
            }

            var terminal_array = "";
            var terminal_index = 0;
            function terminal_info(){
            	$.post(url,{"eaction":"terminal_info","prod_inst_id":prod_inst_id},function(data){
            		terminal_array = new Array();
            		var moreThenOne = false;
            		var list = $.parseJSON(data);
            		if(list.length){
            			for(var i = 0,l = list.length;i<l;i++){
	            			var d = list[i];
	            			var terminals_by_prod = terminal_array[d.PROD_INST_ID];
	            			if(terminals_by_prod==undefined){
	            				terminals_by_prod = new Array();
	            			}
	            			terminals_by_prod.push({"REG_TIME":d.REG_TIME,"MOBILE_MODEL":d.MOBILE_MODEL,"ACC_NBR":d.ACC_NBR,"MOBILE_TYPE":d.MOBILE_TYPE,"BRAND_NAME":d.BRAND_NAME});
	            			terminal_array[d.PROD_INST_ID] = terminals_by_prod;
	            		}

	            		showTerminalListByOne(0);

	            		bindTermSlider();
            		}else{
                        $(".terminal_history").css({"height":"80%"});
            			$(".terminal_history").append("<tr><td colspan='3' style='text-align:center;color:#aec6dc;'>暂无数据</td></tr>");
            		}
            		if(Object.keys(terminal_array).length<=1){
            			$("#term_prev").hide();
            			$("#term_next").hide();
            			$("#term_index").hide();
            		}else{
                        $("#term_prev").show();
                        $("#term_index").show();
                        $("#term_next").show();
                    }
            	});
            }

            function bindTermSlider(){
                $("#term_prev").bind("click",function(){
                	clearTerimnal();
                	showTerminalListByOne(terminal_index-1);
                });
                $("#term_next").bind("click",function(){
              	    clearTerimnal();
              	    showTerminalListByOne(terminal_index+1);
                });
            }
            //换机历史
            function showTerminalListByOne(index){
            	var length = Object.keys(terminal_array).length;
            	if(index>length-1){
            		index = 0;
            	}
            	if(index<0){
            		index = length-1;
            	}
            	terminal_index = index;

            	$("#term_index").text("  "+(index+1)+"/"+length+"  ");

            	var first_prod_terminal = terminal_array[Object.keys(terminal_array)[index]];
            	for(var i = 0,l = first_prod_terminal.length;i<l;i++){
            		var d = first_prod_terminal[i];
            		if(i==0){
          				$("#acc_nbr_sel").text(phoneHide($.trim(d.ACC_NBR)));
          				$("#term_fav").text(d.MOBILE_TYPE);//终端偏好,档次
          				$("#term_cop_fav").text(d.BRAND_NAME);//终端品牌偏好
          			}
            		var item = "<tr>";
          			item += "<td>"+d.REG_TIME+"</td>";
          			var num = (i<3?i+1:3);
          			item += "<td><span class='circular color"+num+"'></span></td>";
          			item += "<td><div>"+d.MOBILE_MODEL+"</div></td>";
          			item += "</tr>";

          			$(".terminal_history").append(item);
            	}
            }

            function tsjb_history(){
                $.post(url,{"eaction":"tsjb_info","prod_inst_id":prod_inst_id},function(data){
                    var list = $.parseJSON(data);
                    if(list.length){
                        for(var i = 0,l = list.length;i<l;i++){
                            var item = list[i];
                            var row = "<tr>";
                            row += "<td>"+item.ACCEPT_DATE+"</td>";
                            var num = (i<3?i+1:3);
                            row += "<td><span class=\"circular color"+num+"\"></span></td>";
                            //row += "<td><div><span class=\"way"+channel_type(item.EXE_CHL_CODE)+"\">"+channel_name(item.EXE_CHL_NAME)+"</span><span>【营销】</span><span title='"+item.CONTACT_SCRIPT+"' class='short_content'>"+item.CONTACT_SCRIPT+"</span></div></td>";//shorter(item.CONTACT_SCRIPT)
                            //row += "<td><div><span class=\"way"+channel_type(item.EXE_CHL_CODE)+"\">"+channel_name(item.EXE_CHL_NAME)+"</span><span>【营销】</span><span class='short_content'><span style='width:30%;'>执行人："+item.USER_NAME+"</span><span style='width:40%;'>执行结果:"+item.EXEC_STAT_NAME+"</span><span style='width:30%;'>备注:"+item.EXEC_DESC+"</span></span></div></td>";//shorter(item.CONTACT_SCRIPT)
                            row += "<td><table><tr><td>";
                            //row += "<span>受理人:"+item.ACCEPT_STAFF_NAME+"</span><br/>";
                            //row += "<span class='andSoOn' style='width:90%;'>受理内容:"+shorter(item.ACCEPT_DESC,21)+"</span></td></tr></table>";//shorter(item.CONTACT_SCRIPT)
                            row += "<div style='width:95%;'>"+str_replace(item.ACCEPT_DESC)+"</div>";
                            row += "</td></tr></table>";
                            row += "</td>";
                            row += "</tr>";
                            $(".tsjb_history").append(row);
                        }
                    }else{
                        $(".tsjb_history").css({"height":"90%"});
                        $(".tsjb_history").append("<tr><td colspan='3' style='text-align:center;color:#aec6dc;'>暂无数据</td></tr>");
                    }
                });
            }

            function str_replace(accept_desc){
                return accept_desc.replace("【网厅备注】","").replace(new RegExp("【",'g'),"").replace(new RegExp("】",'g'),"");
            }

            //接触轨迹
            function contract_history(){
            	$.post(url,{"eaction":"contract_info","prod_inst_id":prod_inst_id},function(data){
            		var list = $.parseJSON(data);
            		if(list.length){
            			for(var i = 0,l = list.length;i<l;i++){
	            			var item = list[i];
	            			var row = "<tr>";
	            			row += "<td>"+item.EXE_DATE+"</td>";
	            			var num = (i<3?i+1:3);
	            			row += "<td><span class=\"circular color"+num+"\"></span></td>";
	            			//row += "<td><div><span class=\"way"+channel_type(item.EXE_CHL_CODE)+"\">"+channel_name(item.EXE_CHL_NAME)+"</span><span>【营销】</span><span title='"+item.CONTACT_SCRIPT+"' class='short_content'>"+item.CONTACT_SCRIPT+"</span></div></td>";//shorter(item.CONTACT_SCRIPT)
                            //row += "<td><div><span class=\"way"+channel_type(item.EXE_CHL_CODE)+"\">"+channel_name(item.EXE_CHL_NAME)+"</span><span>【营销】</span><span class='short_content'><span style='width:30%;'>执行人："+item.USER_NAME+"</span><span style='width:40%;'>执行结果:"+item.EXEC_STAT_NAME+"</span><span style='width:30%;'>备注:"+item.EXEC_DESC+"</span></span></div></td>";//shorter(item.CONTACT_SCRIPT)
                            row += "<td><table><tr><td><span class=\"way"+channel_type(item.EXE_CHL_CODE)+"\">"+channel_name(item.EXE_CHL_NAME)+"</span></td>";
                            row += "<td>";
                            row += "<span style='width:90%;'>【营销】"+item.MKT_CONTENT+"</span>";
                            row += "<span style='width:90%;' title='"+item.MKT_REASON+"'>"+item.MKT_REASON+"</span>";
                            row += "<span class='andSoOn' style='width:90%;'>执行人："+item.USER_NAME+"&nbsp;&nbsp;&nbsp;&nbsp;"+ "执行结果:"+item.EXEC_STAT_NAME+"</span></td></tr></table>";//shorter(item.CONTACT_SCRIPT)
	            			row += "</td>";
                            row += "</tr>";
	            			$(".service_history").append(row);
	            		}
            		}else{
                        $(".service_history").css({"height":"90%"});
            			$(".service_history").append("<tr><td colspan='3' style='text-align:center;color:#aec6dc;'>暂无数据</td></tr>");
            		}
            	});
            }

            function getCustRights(){
                $.post(url,{"eaction":"getCustRights","prod_inst_id":prod_inst_id},function(data){
                    var d = $.parseJSON(data);
                    if(d.length){
                        $(".stars").text(getStarSignals(d[0].MEMBER_NAME));
                        $("#cust_points").text(d[0].CUST_POINT);
                        $("#cr_1").text(d[0].RIGHTS_CONTENT1);
                        $("#cr_2").text(d[0].RIGHTS_CONTENT2);
                        $("#cr_3").text(d[0].RIGHTS_CONTENT3);
                        $("#cr_4").text(d[0].RIGHTS_CONTENT4);
                        $("#cr_5").text(d[0].RIGHTS_CONTENT5);
                        $("#cr_6").text(d[0].RIGHTS_CONTENT6);
                        $("#cr_7").text(d[0].RIGHTS_CONTENT7);
                        $("#cr_8").text(d[0].RIGHTS_CONTENT8);
                        $("#cr_9").text(d[0].RIGHTS_CONTENT9);
                    }else{
                        $(".stars").css({"font-size":"12px"});
                        $(".stars").text("非星级客户");
                    }
                });
            }
            function getStarSignals(star_desc){
                var signal = "★";
                var res = "";
                var star = star_desc.substring(0,1);
                for(var i = 0,l = parseInt(star);i<l;i++){
                    res += signal;
                }
                return res;
            }

            function channel_type(num){
            	var res = 0;
            	switch(num){
            		case '0'://划小
            			res = 1;
            			break;
            		case '110401'://短厅
            			res = 2;
            			break;
            		case '110003'://网厅
            			res = 3;
            			break;
            		case '100401'://CRM
            			res = 4;
            			break;
            		case '110501'://10000号
            			res = 5;
            			break;
            		case '103301'://' '
            			res = 6;
            			break;
            		case '110201'://翼运维
            			res = 3;
            			break;
            		case '110001'://掌厅
            			res = 3;
            			break;
            	}
            	return res;
            }

            function channel_name(name){
            	if(name=='网厅')
            		return "网上";
            	else if(name=='翼运维')
            		return "网上";
            	else if(name=='掌厅')
            		return "网上";

            	return name;
            }

            function shorter(str,num){
            	if(num==undefined)
            		num = 17;
            	return str.substr(0,num)+'...';
            }

            function substr(str){
            	return str.substr(0,17);
            }
        </script>
    </head>
    <body>
        <div style="position: fixed;width:100%;height:35px;top:0;background:#0736B0;"></div>
        <div class="wrapper" style="width:98%;height:100%;padding-left:0.5%;">

            <!--<h2 class="total_tit" >客户视图</h2>-->
            <div id="new_cust_handler" style="height:35px;display:inline-flex;background-color:#0736B0;position:fixed;top:0px;width:100%;z-index:19891016;">
                <div class="cus_view_header_tag">
                    <div class="cus_view_header_tag_text">客户视图</div>
                </div>
            </div>
            <div class="win_body_scroll">
                <table cellpadding="0" cellspacing="0" class="main_layout_tab"  style="margin-top:30px;margin-bottom:15px;">
                <tr>
                    <td colspan="2">
                        <h2 class="common_tit"><i>▌</i>基本信息</h2>
                        <!--<div class="win_handle">
                            <div class="village_close"></div>
                        </div>-->
                        <table cellpadding="0" cellspacing="0" class="top_layout_tab">
                            <tr>
                                <td class="cus_avtar" rowspan="2"></td>
                                <td width="25%"><span class="cus_name" id="cust_name">--</span>
                                    <span class="mar_left30">性别:<span class="value" id="sex">--</span></span>
                                    <span class="mar_left30">年龄:<span class="value" id="age">--</span></span><br/>
                                    <span class="">入网日期:<span class="value" id="inet_date"></span></span>
                                </td>
                                <td width="15%">
                                    <span class="mar_left30">是否实名:<span class="value" id="is_sm">--</span></span><br/>
                                    <span class="mar_left30">在网时长:<span class="value" id="inet_during"></span></span>
                                </td>
                                <td width="20%">
                                    <span class="mar_left30">用户状态:<span class="value" id="status"></span></span><br/>
                                    <span class="mar_left30">客户经理:<span class="value" id="cust_manager_name">--</span></span>
                                </td>
                                <td width="40%">
                                    <span class="mar_left30">联系电话:<span class="value" id="contact_tel"></span></span><br/>
                                    <span style="margin-left:8px;">产品构成:</span><span id="produce_constuct"></span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <span class="fl">地址:</span><span class="value fl" style="" id="address_desc">--</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <h2 class="common_tit"><i>▌</i>客户画像</h2>
                        <div class="common_layout" style="height:320px;">
                            <div class="bg_hx">
                                <div class="tag no1">家庭类型<span id="family_type" class="short_content">无数据</span></div>
                                <div class="tag no2">社会分群<span id="scoiety_group" class="short_content">无数据</span></div>
                                <div class="tag no3">消费潜能<span id="pay_power" class="short_content">无数据</span></div>
                                <div class="tag no4">渠道偏好<span id="channel_favirate" class="short_content">无数据</span></div>
                                <div class="tag no5">终端偏好<span id="teminal_favirate" class="short_content">无数据</span></div>
                                <div class="tag no6">终端品牌偏好<span id="teminal_brand_favirate" class="short_content">无数据</span></div>
                                <div class="tag no7">流量特征<span id="flow_feature" class="short_content">无数据</span></div>
                                <div class="tag no8">服务信息<span id="service_info" class="short_content">无数据</span></div>
                                <div class="tag no9">业务偏好<span id="business_favirate" class="short_content">无数据</span></div>
                                <div class="tag no10">离网倾向<span id="offline_favirate" class="short_content">无数据</span></div>
                            </div>
                            <!--<table cellpadding="0" cellspacing="0" class="tag_tab">
                                <tr>
                                    <td width="30%"><div class="color1" style="margin-left:28px;"><span>家庭类型</span><b id="family_type"><c>无数据</c></div></td>
                                    <td rowspan="5" class="cus_bg" width="50%"></td>
                                    <td width="30%"><div class="color5"><span>社会分群</span><b id="scoiety_group"><c>无数据</c></b></div></td>
                                </tr>
                                <tr>
                                    <td><div class="color2" style="margin-left:15px;"><span>消费潜能</span><b id="pay_power"><c>无数据</c></b></div></td>
                                    <td><div class="color4" style="margin-left:15px;"><span>渠道偏好</span><b id="channel_favirate"><c>无数据</c></b></div></td>
                                </tr>
                                <tr>
                                    <td><div class="color3" ><span>终端偏好</span><b id="teminal_favirate"><c>无数据</c></b></div></td>
                                    <td><div class="color2" style="margin-left:28px;"><span>终端品牌偏好</span><b id="teminal_brand_favirate"><c>无数据</c></b></div></td>
                                </tr>
                                <tr>
                                    <td><div class="color4" style="margin-left:15px;"><span>流量特征</span><b id="flow_feature"><c>无数据</c></b></div></td>
                                    <td><div class="color3" style="margin-left:15px;"><span>服务信息</span><b id="service_info"><c>无数据</c></b></div></td>
                                </tr>
                                <tr>
                                    <td><div class="color5" style="margin-left:28px;"><span>业务偏好</span><b id="business_favirate"><c>无数据</c></b></div></td>
                                    <td><div class="color1"><span>离网倾向</span><b id="offline_favirate"><c>无数据</c></b></div></td>
                                </tr>
                            </table>-->
                        </div>
                    </td>
                    <td>
                        <h2 class="common_tit mar_left2per"><i>▌</i>营销推荐</h2>
                        <div class="common_layout fr " style="height:320px;" id="yx_advice">
                            <div id="yx_advice_func"><a href="javascript:void(0);" class="banli" >办理</a></div>
                            <div id="yx_advice_list"></div>
                            <!--
                            <table cellpadding="0" cellspacing="0" class="dg_tab" id="yx_advice_head" style="margin-bottom:0px;">
                                <tr>
                                    <th width="21%">产品号码</th>
                                    <th width="65%">推荐内容</th>
                                    <th>操作</th>
                                </tr>
                            </table>
                            <div style="max-height:200px;overflow-y:auto;">
	                            <table cellpadding="0" cellspacing="0" class="tj_tab" id="yx_advice_list">
	                            	<tr>
	                                    <td>18012121212</td>
	                                    <td>299融合套餐3个副卡200M光纤入户送ITV</td>
	                                    <td><a href="#">办理</a></td>
	                                </tr>
	                                <tr>
	                                    <td>18012121212</td>
	                                    <td>299融合套餐3个副卡200M光纤入户送ITV</td>
	                                    <td><a href="#">办理</a></td>
	                                </tr>
	                                <tr>
	                                    <td>18012121212</td>
	                                    <td>299融合套餐3个副卡200M光纤入户送ITV</td>
	                                    <td><a href="#">办理</a></td>
	                                </tr>
	                            </table>
                            </div>-->
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h2 class="common_tit"><i>▌</i>产品订购</h2>
                        <div class="common_layout fl">
                            <table cellpadding="0" cellspacing="0" class="dg_tab" id="product_info_head">
                                <tr>
                                    <th>产品类型</th>
                                    <th>产品号码</th>
                                    <th>套餐信息</th>
                                    <th>使用状态</th>
                                    <!--<th>付费模式</th>-->
                                </tr>
                            </table>
                            <div style="height:162px;overflow-y:auto;">
                            	<table cellpadding="0" cellspacing="0" class="dg_tab" id="product_info_list" style="width:95%;">

                            	</table>
                            </div>
                        </div>
                    </td>
                    <td>
                        <h2 class="common_tit mar_left2per"><i>▌</i>使用信息</h2>
                        <div class="common_layout fr">
                            <table cellpadding="0" cellspacing="0" class="sy_tab" id="sy_info_head">
                                <tr>
                                    <th>号码</th>
                                    <th>指标类型</th>
                                    <!--<th>单位</th>-->
                                    <th>本月使用</th>
                                    <th>上月使用</th>
                                    <!--<th>历史同期对比</th>-->
                                </tr>
                            </table>
                            <div style="height:162px;overflow-y: auto;">
                            	<table cellpadding="0" cellspacing="0" class="sy_tab" id="sy_info_list">

                            	</table>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h2 class="common_tit"><i>▌</i>终端信息</h2>
                        <div class="common_layout fl">
                            <table cellpadding="0" cellspacing="0" class="terminal">
                                <tr>
                                		<td>号码：<span id="acc_nbr_sel"></span></td>
                                    <td>终端偏好： <span id="term_fav">高端机</span></td>
                                    <td>终端品牌偏好： <span id="term_cop_fav">苹果</span></td>
                                    <td><span id="term_prev">&lt;&lt;</span><span id="term_index"></span><span id="term_next">&gt;&gt;</span></td>
                                </tr>
                            </table>
                            <div style="height:162px;overflow-y:auto;">
	                            <table cellpadding="0" cellspacing="0" class="terminal_history" style="margin-top:0px;">
	                                <tr>
	                                    <td>2017-10-07</td>
	                                    <td><span class="circular color1"></span></td>
	                                    <td><div>苹果iPhone X</div></td>
	                                </tr>
	                                <tr>
	                                    <td>2017-10-07</td>
	                                    <td><span class="circular color2"></span></td>
	                                    <td><div>苹果iPhone X</div></td>
	                                </tr>
	                                <tr>
	                                    <td>2017-10-07</td>
	                                    <td><span class="circular color3"></span></td>
	                                    <td><div>苹果iPhone X</div></td>
	                                </tr>
	                            </table>
	                          </div>
                        </div>
                    </td>
                    <td>
                        <h2 class="common_tit mar_left2per"><i>▌</i>消费信息</h2>
                        <div class="common_layout fr">
                            <table cellpadding="0" cellspacing="0" class="consume">
                                <tr>
                                    <td class="ico_cash">
                                        <span>账户余额</span>
                                        <span><span class="big_num" id="remain_money">52.1</span>元</span>
                                    </td>
                                    <td class="ico_arrears">
                                        <span>欠费金额</span>
                                        <span><span class="big_num" id="owe_money">52.1</span>元</span>
                                    </td>
                                </tr>
                            </table>
                            <div class="xiaofei_fig" id="payfor_figure">
                                <img src="../common/images/custom_view/figu.jpg" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td rowspan="" valign="top">
                        <h2 class="common_tit mar_left2per"><i>▌</i>服务投诉</h2><!-- 投诉举报 -->
                        <div class="common_layout jiechu fr">

                            <table cellpadding="0" cellspacing="0" class="tsjb_history">
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color1"></span></td>
                                    <td><div><span class="way1">线上</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color2"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way3">厅店</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td rowspan="" valign="top">
                        <h2 class="common_tit mar_left2per"><i>▌</i>接触轨迹</h2>
                        <div class="common_layout jiechu fr">

                            <table cellpadding="0" cellspacing="0" class="service_history">
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color1"></span></td>
                                    <td><div><span class="way1">线上</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color2"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way3">厅店</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                                <tr>
                                    <td>2017-10-07</td>
                                    <td><span class="circular color3"></span></td>
                                    <td><div><span class="way2">10000号</span><span>【投诉】</span>投诉8月份话费异常</div></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <h2 class="common_tit mar_left2per" style="margin-left:0%;"><i>▌</i>客户权益</h2>
                        <div class="common_layout fl">
                            <table cellpadding="0" cellspacing="0" class="cus_stars" style="margin-bottom: 0px">
                                <tr>
                                    <td>用户星级： <span class="stars">--</span></td>
                                    <td>用户积分： <span id="cust_points">0分</span></td>
                                </tr>
                                <tr>
                                    <td>权益内容</td>
                                    <td></td>
                                </tr>
                            </table>
                            <table cellpadding="0" cellspacing="0" class="cus_rights" style="margin-top:0px;">
                                <tr>
                                    <th style="width:16%;">积分倍增</th>
                                    <td id="cr_1" style="width:18%;">无</td>
                                    <th style="width:20%;">10000号优先接入</th>
                                    <td id="cr_2" style="width:16%;">无</td>
                                    <th style="width:17%;">免费换卡</th>
                                    <td id="cr_3" style="width:13%;">无</td>
                                </tr>
                                <tr>
                                    <th>宽带紧机复机</th>
                                    <td id="cr_4">无</td>
                                    <th>星级客户经理</th>
                                    <td id="cr_5">无</td>
                                    <th>手机紧急开机</th>
                                    <td id="cr_6">无</td>
                                </tr>
                                <tr>
                                    <th>宽带上门服务</th>
                                    <td id="cr_7">无</td>
                                    <th>国漫免保证金开通</th>
                                    <td id="cr_8">无</td>
                                    <th>营业厅优先办理</th>
                                    <td id="cr_9">无</td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td valign="top">
                        <h2 class="common_tit mar_left2per" style="margin-left:0%;"><i>▌</i>网络感知</h2>
                        <div class="common_layout fl"  style="">
                            <table cellpadding="0" cellspacing="0" class="gz_tab">
                                <tr>
                                    <td>
                                        <span class="gz_ico phone"></span>
                                        <span class="gz_name">移动</span>
                                        <span class="gz_value"><span class="big_num">76</span>分</span>
                                        <span class="gz_judge alarm">良好</span>
                                    </td>
                                    <td>
                                        <span class="gz_ico broad"></span>
                                        <span class="gz_name">宽带</span>
                                        <span class="gz_value"><span class="big_num">87</span>分</span>
                                        <span class="gz_judge health">健康</span>
                                    </td>
                                    <td style="border:none;">
                                        <span class="gz_ico itv"></span>
                                        <span class="gz_name">ITV</span>
                                        <span class="gz_value"><span class="big_num">80</span>分</span>
                                        <span class="gz_judge health">健康</span>
                                    </td>
                                </tr>
                            </table>
                        </div>

                    </td>
                </tr>
            </table>
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
            $(function(){
                //fix();
            });
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
