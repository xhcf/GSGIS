//1.所有营销清单“执行”链接响应的调用方法
function exec_agent(prod_inst_id,order_id,add6,add4,tab_id,exec_able,scene_id,is_lost,is_yx,is_track,accept_type){
    var param = {};
    param.prod_inst_id = prod_inst_id;
    param.order_id = order_id;
    param.add6 = add6;
    param.add4 = add4;
    param.tab_id = tab_id;
    param.exec_able = exec_able;
    param.scene_id = scene_id;
    param.is_lost = is_lost;
    param.is_yx = is_yx;
    param.is_track = is_track;
    param.is_zhuanpai = is_zhuanpai;
    param.accept_type = accept_type;
    openCustViewByProdInstId(param);
}

//2.各层GIS地图主页面中打开客户视图的方法，将exec_agent方法的参数，传递给客户视图弹窗页
openCustViewByProdInstId = function (param) {
    var segment_id      =param.segment_id  	;
    var prod_inst_id    =param.prod_inst_id	;
    var order_id        =param.order_id    	;
    var add6            =param.add6        	;
    var tab_id          =param.tab_id      	;
    var exec_able       =param.exec_able   	;
    var scene_id        =param.scene_id    	;
    var mkt_campaign_id =param.mkt_campaign_id;
    var pa_date			=param.pa_date      ;
    var is_lost         =param.is_lost      ;
    var lost_type		=param.lost_type    ;
    var is_yx           =param.is_yx        ;
    var is_village		=param.is_village   ;
    var is_track		=param.is_track     ;
    var is_zhuanpai		=param.is_zhuanpai  ;
    var accept_type     =param.accept_type  ;

    //新版本客户视图
    var is_new_cust_view = "";
    /*is_new_cust_view = 1;
     if(prod_inst_id){
     parent.openCustomView(param);
     return;
     }*/

    $("#info_collect_edit_div > iframe").attr("src", appBase+"/pages/telecom_Index/enterprise_leader/jsp/viewPlane_info_collect_edit_diy_new.jsp?segment_id=" + segment_id + "&city_id=" + city_id+"&prod_inst_id="+prod_inst_id+"&tab_id="+tab_id+"&add6="+add6+"&order_id="+order_id+"&exec_able="+exec_able+"&scene_id="+scene_id+"&is_lost="+is_lost+"&is_yx="+is_yx+"&is_village="+is_village+"&mkt_campaign_id="+mkt_campaign_id+"&pa_date="+pa_date+"&is_new_cust_view="+is_new_cust_view+"&is_track="+is_track+"&city_id="+city_id+"&lost_type="+lost_type+"&is_zhuanpai="+is_zhuanpai+"&accept_type="+accept_type);
    cust_view_handler = layer.open({
        title: ' ',
        //title:false,
        maxmin: true, //开启最大化最小化按钮
        type: 1,
        shade: 0,
        //maxmin: true, //开启最大化最小化按钮
        area: ['860px', '485px'],
        //offset: ['56px', '158px'],
        content: $("#info_collect_edit_div"),
        skin: 'cus_view',//'yxzx_div',
        cancel: function (index) {
            layer.close(cust_view_handler);
            //$("#nav_info_collect").removeClass("active");
            //return tmp_info_collect = '1';
        },
        full: function() { //点击最大化后的回调函数
            $(".cus_view .layui-layer-setwin").css({"top":'30px','background-color':'#1069c9'});
        },
        restore: function() { //点击还原后的回调函数
            $(".cus_view .layui-layer-setwin").css("top",'6px');
        }
    });
    //$(".info_collect .layui-layer-setwin").addClass("close_table");
}

//3.crm跳转 需要传所有用到的参数（甩单接口中的参数），给crm_jump_page使用
function execute_crm(id,cust_name1,cust_addr1,contact_num1,acc_nbr1,scene_id1,prod_inst_id1,mktCamCateId1,isSupportAccept1,contact_chl_id1,prod_offer_id1,prod_offer_name1){
    cust_name = cust_name1;
    cust_addr = cust_addr1;
    contact_num = contact_num1;
    acc_nbr = acc_nbr1;
    prod_inst_id = prod_inst_id1;
    mktCamCateId = mktCamCateId1;
    isSupportAccept = isSupportAccept1;
    contact_chl_id = contact_chl_id1;
    prod_offer_id = prod_offer_id1;
    prod_offer_name = prod_offer_name1;
    if(scene_id1=='1491'){//20181204装逼用
        scene_id1 = 10;
    }
    scene_id = scene_id1;
    if(id=="" || id==undefined){
        layer.msg("没有查到对应的划小工号，请等待同步后使用");
        return;
    }
    //调用划小接口检测当前账号是否绑定成功，如果成功进crm。否则弹出填写crm工号的页面进行绑定

    //1.调用CRM绑定帐号接口
    /*if(test!=undefined){
     var cust_name2 = encodeURI(encodeURI(cust_name));//UTFTranslate.Change(cust_name);
     var address2 = encodeURI(encodeURI(cust_addr));//UTFTranslate.Change(cust_addr);
     var accnbr2 = encodeURI(encodeURI(contact_num));//UTFTranslate.Change(contact_num);
     var broadband2 = encodeURI(encodeURI(acc_nbr));//UTFTranslate.Change(acc_nbr);
     var crm_id = '316666';
     //scene_id ren是续约 sin是单转融 2
     var crm_url = 'http://10.52.66.110:8090/MmtWeb/home/verplatform.jsp?username=316666&userpwd=8763&code=8763&reqparam=';
     //var crm_url = 'http://135.149.47.21/MmtWeb/home/verplatform.jsp?username=316666&userpwd=8763&code=8763&reqparam=';
     //var crm_url = 'http://135.149.47.21/MmtWeb/home/verplatform.jsp?reqparam=';
     $.post('<e:url value="crmUrl.e"/>',{"user_id":crm_id,"cust_name":cust_name,"address":cust_addr,"accnbr":contact_num,"broadband":acc_nbr,"bus_type":scene_id},function(data){
     var reqparam = $.trim(data);//crm_id正式环境把316666换成crm_id
     //弹窗被阻挡，window.open的写法不行，改为下面写法
     //var tempwindow=window.open('_blank');
     //tempwindow.location=crm_url+reqparam+"&cust_name="+cust_name2+"&address="+address2+"&accnbr="+accnbr2+"&broadband="+broadband2+"&bus_type="+scene_id;
     console.log(cust_name2,address2,accnbr2,broadband2,scene_id);
     //window.open(crm_url+reqparam+"&cust_name="+cust_name2+"&address="+address2+"&accnbr="+accnbr2+"&broadband="+broadband2+"&bus_type="+scene_id,'CRM预受理');
     window.open(crm_url+reqparam,'CRM预受理');
     });
     return;
     }*/
    debugger;
    var params_secu = {
        "appId":"GIS-PC",
        "appKey":"",
        "reqTime":"",
        "reqPath":""
    }
    params_secu.reqPath = url1;///

    $.post(appBase+"/makeKey.e",params_secu,function(key){
        var key = $.parseJSON(key);
        params_secu.appKey = key.key_val;
        params_secu.reqTime = key.reqTime;
        params_secu.staffNo = id;///
        $.post(url_prefix+url1,params_secu,function(data){
            ///var d1 = {"errorCode":0,"entity":{"STAFF_CODE":'111',"MOBILE_PHONE":'222'}};
            var d1 = data;
            if(d1.errorCode!='0'){//调用划小接口失败，
                layer.msg(d1.message);
                return;
            }else{
                var entity = d1.entity;
                if(entity.STAFF_CODE=="" || entity.STAFF_CODE==undefined){
                    layer.msg("还未绑定CRM工号，请绑定");
                    crm_bind_win = layer.open({
                        title: '营销派单转CRM受理',
                        type: 2,
                        shade: 0,
                        area: ["480px", "400px"],
                        content: appBase+'/pages/telecom_Index/sub_grid/crm_bind_page.jsp?staff_no='+id,
                        skin: 'sub_summary_div',
                        cancel: function (index) {
                        }
                    });
                }else if(entity.MOBILE_PHONE=="" || entity.MOBILE_PHONE==undefined){//未绑定手机号
                    layer.msg("没有在CRM绑定手机号，请先在CRM完善信息");
                    return;
                }else{//已绑定成功
                    crm_id = entity.STAFF_CODE;
                    bound_ready_jump_win = layer.open({
                        title: '营销派单转CRM受理',
                        type: 2,
                        shade: 0,
                        area: ["480px", "200px"],
                        content: appBase+"/pages/telecom_Index/sub_grid/crm_jump_page.jsp?staff_no="+id,
                        skin: 'sub_summary_div',
                        cancel: function (index) {
                        }
                    });
                }
            }
        });
    });
}