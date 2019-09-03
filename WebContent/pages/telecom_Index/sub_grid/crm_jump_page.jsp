<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4l var="city_list">
  SELECT area_no CODE,area_desc NAME FROM easy_data.cmcode_area ORDER BY ord ASC
</e:q4l>
<html>
<head>
    <title></title>
  <style>
    table {font-size:12px;margin:0px auto;}
    .ali_center{text-align:center;}
    .crm_step {width:100%;border-collapse: collapse;border:0px;}
    .crm_step td {border-collapse: collapse;border:0px;text-align: left;height: 36px;padding-left: 15px;}
    .crm_button {border:none;background: #1069c9;height:26px;line-height: 26px;border-radius: 5px;color:#fff;}
    .crm_button_small {width:56px;}
    .crm_button_big {width:95px;}
    #vail_input{width:100px;}
    .disabled_btn{background: #aaa;}
    .ali_right{text-align: right!important;}
    #st2_phone{color:blue;}
    .text_red {color:red;}
    .step_tip_title {color:#C85810;font-size:14px;float:left;}
    .step_tip_desc {font-size:12px;clear:both;float:left;margin-left:40px;margin-top:5px;margin-bottom:5px;}
    .arrow_right{background-image: url('<e:url value="/pages/telecom_Index/sub_grid/image/arrow_right.png" />')}
    #step01,#step02{float:left;width:30px;height:15px;line-height:20px;background-size:contain;background-repeat:no-repeat;margin-top:3px;}
    .crm_button_group{margin:0 auto;text-align:center;padding-top:10px;display:inline-block;width:100%;}

    .org_selectes{height:35px;line-height:35px;width:100%;color:#fff;padding-left:5px;padding-top:3px;}
    .org_selectes span,.org_selectes div,.org_selectes input{display: inline-block;float:left;color:#fff!important;}
    .org_selectes span{width:80px;}
    .org_selectes select{width:140px;height:22px!important;background:none;color:#fff;border:1px solid #2657a5;}
    .org_selectes select option{color:#000;}
    .org_selectes table tr td {text-align:center;}
    .desk_tag span{color:#fff!important;}
    #vill_dif_query{float:right;border:1px solid #467ace;background:#073b8a;width:80%;}
    #index_other_vill{display:none;}
    #vill_dif_vil_selected_input{position:absolute;top:45px;right:87px;width:121px;height:20px!important;line-height:20px!important;background:#063C8F;color:#fff!important;border:none;margin:1px;}
    input::-webkit-input-placeholder, textarea::-webkit-input-placeholder {
      /* WebKit browsers */
      color: #bbb;
    }
    input:-moz-placeholder, textarea:-moz-placeholder {
      /* Mozilla Firefox 4 to 18 */
      color: #bbb;
    }
    input::-moz-placeholder, textarea::-moz-placeholder {
      /* Mozilla Firefox 19+ */
      color: #bbb;
    }
    input:-ms-input-placeholder, textarea:-ms-input-placeholder {
      /* Internet Explorer 10+ */
      color: #bbb;
    }
    #vill_dif_vil_selected_name_list{position:absolute;top:70px;right:67px;width:140px;background:#fff;color:#000!important;text-align:left;}
    #vill_dif_vil_selected_name_list li {padding-left:7px;}
  </style>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <e:script value="/resources/layer/layer.js"/>
</head>
<body>
<div id="account_crm_bind" style="">
  <div style="width:100%;clear:both;"><div class="step_tip_title">1.绑定CRM工号</div></div>
  <div class="step_tip_desc">当前绑定的CRM受理工号为<span id="bound_crm_id"></span></div>
  <div style="width:100%;clear:both;"><div class="step_tip_title">2.转一键订购页面</div></div><!-- 转CRM甩单受理页面 -->
  <div class="step_tip_desc">传送信息包括CRM工号</div><!-- 传送信息包括CRM工号、场景类型、客户名称、联系电话、详细地址 -->
  <div class="crm_button_group">
    <input type="button" value="确定" id="CRM_jump" class="crm_button crm_button_small" />
    <input type="button" value="取消" id="vail_cancel" class="crm_button crm_button_small" style="margin-left:35px;" />
  </div>
</div>
</body>
</html>
<script>
  var url_prefix = "http://135.149.64.144:9000/gsch-api";

  var url5 = "/mkt/getBindAccount";//获取crm绑定账号

  var staff_no = '${param.staff_no}';
  var cantGetMsg = true;
  $(function() {
    var params_secu = {
      "appId":"GIS-PC",
      "appKey":"",
      "reqTime":"",
      "reqPath":""
    }
    params_secu.reqPath = url5;///
    $.post("<e:url value='makeKey.e' />",params_secu,function(key) {
      var key = $.parseJSON(key);
      params_secu.appKey = key.key_val;
      params_secu.reqTime = key.reqTime;
      params_secu.staffNo = staff_no;
      $.post(url_prefix+url5, params_secu, function (data5) {
        //var d5 = {errorCode:0,message:'ddd',entity:{MOBILEPHONE:'17793101351',STAFF_CODE:'3166666'}};//{errorCode:0,message:'ddd'};//data5;//{errorCode:0,message:'ddd'};
        var d5 = data5;
        if (d5.errorCode != '0') {
          layer.msg(d5.message);
          return;
        } else {
          parent.crm_id = d5.entity.STAFF_CODE;
          $("#bound_crm_id").text(parent.crm_id);
          $("#CRM_jump").on("click", function () {
            jumpToCRM();
            setTimeout(function(){
              parent.closeCrmJumpWin();
            },5000);
          });
          //parent.execute_crm(staff_no,parent.cust_name,parent.cust_addr,parent.contact_num,parent.acc_nbr,parent.scene_id,1);
          //parent.closeCrmBindWin();
          $("#vail_cancel").on("click", function () {
            parent.closeCrmJumpWin();
          });
        }
      });
    });
  });

  function jumpToCRM(){
    parent.exec_view_exe_small_interface(parent.yx_exec_params);//20190311 营销逻辑修改 先跳转后执行
    /*$.post('<e:url value="pages/telecom_Index/common/sql/tabData.jsp" />',{"eaction":"getOrderId_oneKeyBuy","mkt_id":parent.scene_id,"prod_inst_id":parent.prod_inst_id},function(data){
      var data = $.parseJSON(data);
      if(data==null){
        layer.msg("营服协同中心工单ID不存在，无法一键订购");
      }else{
        if(data.ACCEPT_TYPE=='3'){
          jumpToCRM_xiaoqiantai();
        }else{
          jumpToH5();
        }
      }
    });*/
    if(parent.isSupportAccept=='3'){
      jumpToCRM_xiaoqiantai();
    }else{
      jumpToH5();
    }
  }

  //2019年某厂家做的一键订购页面
  function jumpToH5(){
    //var jumpTo = "http://gs.189.cn/dyjl/wechatclerk/peopleinfo/coorTipAccept.html";//外网
    var jumpTo = "http://135.149.47.85:10001/MmtWeb/wechatclerk/peopleinfo/coorTipAccept.html";//外网
    window.open(jumpTo + "?contact_order_id=" + data.CONTACT_ORDER_ID + "&staff_id=" + parent.crm_id);
  }

  //2018年crm甩单功能 小前台处理
  function jumpToCRM_xiaoqiantai_bak() {
    var cust_name2 = encodeURI(encodeURI(parent.cust_name));//UTFTranslate.Change(cust_name);
    var address2 = encodeURI(encodeURI(parent.cust_addr));//UTFTranslate.Change(cust_addr);
    var accnbr2 = encodeURI(encodeURI(parent.contact_num));//UTFTranslate.Change(contact_num);
    var broadband2 = encodeURI(encodeURI(parent.acc_nbr));//UTFTranslate.Change(acc_nbr);
    var crm_id = parent.crm_id;
    //scene_id ren是续约 sin是单转融
    //var crm_url = 'http://10.52.66.110:8090/MmtWeb/home/verplatform.jsp?username=316666&userpwd=8763&code=8763&reqparam=';//已废弃,配合联调crm韦晓密本机地址
    //var crm_url = 'http://135.149.47.21/MmtWeb/home/verplatform.jsp?reqparam=';//已废弃
    //var crm_url = 'http://135.149.33.26:10001/MmtWeb/home/verplatform.jsp?reqparam=';//新地址 20180725
    //var crm_url = 'http://10.52.64.189:8090/MmtWeb/home/verplatform.jsp?reqparam=';//已废弃，服务器临时部署旧程序应付集团检查
    var crm_url = 'http://135.149.47.229/MmtWeb/home/verplatform.jsp?reqparam=';//新版crm内网地址 20180726
    var crm_url_tianshui = 'http://135.149.47.38/MmtWeb/home/verplatform.jsp?reqparam=';//新版crm内网地址 20180726//外网60.164.231.156
    //var crm_url = 'http://135.149.47.21/MmtWeb/home/sso.jsp?reqparam=';
    $.post('<e:url value="crmUrl.e"/>', {
     "user_id": crm_id,
     "cust_name": cust_name2,
     "address": address2,
     "accnbr": accnbr2,
     "broadband": broadband2,
     "bus_type": parent.scene_id
     }, function (data1) {
       var reqparam = $.trim(data1);//crm_id正式环境把316666换成crm_id
       debugger;
       if(parent.parent.global_current_city_id=='938')
        window.open(crm_url_tianshui + reqparam, 'CRM预受理');
       else
        window.open(crm_url + reqparam, 'CRM预受理');
     });
  }

  function jumpToCRM_xiaoqiantai() {
    var crm_id = parent.crm_id;
    var menuCode = "Mxqt2018002";
    var userCode = crm_id;
    var latnId = parent.parent.global_current_city_id;
    var externSystemCode = "GIS001";
    var signTimestamp = "";///
    var externSignKey = "xqt20181207";
    var model = "CONTRACTOR_ASSISTANT";
    var subMenuCode = "";///
    var signString = "";///

    var cert_num = encodeURI(encodeURI(parent.acc_nbr));
    var contactOrderId = parent.order_id;
    var targetObjNbr = parent.prod_inst_id;

    var contactChlId = parent.contact_chl_id;
    var itemId = parent.prod_offer_id;
    var itemName = $.trim(parent.prod_offer_name);

    //var ip_port = "10.52.102.10:8080";//开发人员测试地址
	//var ip_port = "135.149.47.38";//测试
	var ip_port = "135.149.47.229";//生产
    var crm_url = "http://"+ip_port+"/MmtWeb/ssoLogin.do?";//新版crm内网地址 20180726
    //var crm_url = 'http://135.149.47.21/MmtWeb/home/sso.jsp?reqparam=';

    debugger;
    $.post('<e:url value="crmUrl2019.e"/>',{
      "menuCode":menuCode,
      "userCode":crm_id,
      "lanId":latnId,
      "externSystemCode":externSystemCode,
      "externSignKey":externSignKey,
      "mktCamCateId":parent.mktCamCateId,
      "isSupportAccept":parent.isSupportAccept
    },function(data1){
      var reqparam = $.trim(data1);
      var res_arr = reqparam.split("_");
      subMenuCode = res_arr[0];
      signTimestamp = res_arr[1];
      signString = res_arr[2];

      if(subMenuCode=="" || subMenuCode==null)
        return;

      window.open(crm_url + "menuCode="+menuCode+"&userCode="+userCode+"&lanId="+latnId+
                      "&externSystemCode="+externSystemCode+"&signTimestamp="+signTimestamp+
                      "&externSignKey="+externSignKey+"&model="+model+"&subMenuCode="+subMenuCode+
                      "&signString="+signString+"&cert_num="+cert_num+"&contactOrderId="+contactOrderId+
                      "&targetObjNbr="+targetObjNbr+"&contactChlId="+contactChlId+"&itemId="+itemId+
                      "&itemName="+encodeURI(itemName)
              ,"CRM预受理");
    });
  }
</script>