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
    .step_tip_desc {font-size:12px;clear:both;float:left;margin-left:40px;}
    .arrow_right{background-image: url('<e:url value="/pages/telecom_Index/sub_grid/image/arrow_right.png" />')}
    #step01,#step02{float:left;width:30px;height:15px;line-height:20px;background-size:contain;background-repeat:no-repeat;margin-top:3px;}
    .crm_button_group{margin:0 auto;text-align:center;padding-top:10px;display:inline-block;width:100%;}
  </style>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <e:script value="/resources/layer/layer.js"/>
</head>
<body>
<div id="account_crm_bind" style="">
  <div style="width:100%;clear:both;"><div id="step01"></div><div class="step_tip_title">1.绑定CRM工号</div></div>
  <div class="step_tip_desc"><span class="text_red">*</span>目前尚未绑定CRM，请先绑定CRM受理工号</div>
  <table id="step1" class="crm_step">
    <tr>
      <td class="ali_right">地市选择：</td>
      <td class=""><e:select id="latn_select" items="${city_list.list}" var="item" value="CODE" label="NAME" class="latn_select" /></td>
    </tr>
    <tr>
      <td class="ali_right">CRM工号：</td>
      <td><input type="text" placeholder="请输入工号" id="crm_id" /></td>
    </tr>
    <tr id="tr_st2_vail">
      <td class="ali_right">输入验证码：</td>
      <td id="st2_vail_input">
        <input id="vail_input" placeholder="请输入验证码" />
        <input type="button" value="获取验证码" id="getPhone" class="crm_button disabled_btn crm_button_big" style="margin-left:5px;"/></td>
    </tr>
    <tr>
      <td colspan="2" style="text-align: center" id="st2_phone">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" style="text-align:center;">
        <input type="button" value="绑定" id="vail_query" class="crm_button disabled_btn crm_button_big"/>
        <!--<input type="button" value="取消" id="vail_cancel" class="crm_button" style="margin-left:20px;" />-->
      </td>
    </tr>
  </table>

  <div style="width:100%;clear:both;"><div id="step02"></div><div class="step_tip_title">2.转CRM甩单受理页面</div></div>
  <div class="step_tip_desc"><span class="text_red">*</span>传送信息包括CRM工号、场景类型、客户名称、联系电话、详细地址</div>
  <div class="crm_button_group">
    <input type="button" value="确定" id="CRM_jump" class="crm_button crm_button_small disabled_btn" />
    <input type="button" value="取消" id="vail_cancel" class="crm_button crm_button_small" style="margin-left:35px;" />
  </div>
</div>
</body>
</html>
<script>
  var url_prefix = "http://135.149.64.144:9000/gsch-api";
  var url2 = "/mkt/findCrmAccount";//获得crm那边绑定的账号
  var url3 = "/mkt/sendVerifyCode";//发短信
  var url4 = "/mkt/bindAccount";//验证短信并绑定
  var url5 = "/mkt/getBindAccount";//获取crm绑定账号

  var staff_no = '${param.staff_no}';
  var cantGetMsg = true;
  $(function(){
    $("#crm_id").keyup(function(){
      if($.trim($("#crm_id").val()).length>0){
        $("#getPhone").removeClass("disabled_btn");
        cantGetMsg = false;
      }else{
        $("#getPhone").removeClass("disabled_btn");
        $("#getPhone").addClass("disabled_btn");
        cantGetMsg = true;
      }
    });
    $("#getPhone").click(function(){
      var latn_id = $(".latn_select option:selected").val();
      var latn_name = $(".latn_select option:selected").text();
      var crm_id = $("#crm_id").val();
      if($.trim(latn_id)==""){
        layer.msg("请选择地市");
        return;
      }else if($.trim(crm_id)==""){
        layer.msg("请输入CRM工号");
        return;
      }
      if(cantGetMsg)
        return;

      var params_secu = {
        "appId":"GIS-PC",
        "appKey":"",
        "reqTime":"",
        "reqPath":""
      }
      params_secu.reqPath = url2///

      $.post("<e:url value='makeKey.e' />",params_secu,function(key){
        var key = $.parseJSON(key);
        params_secu.appKey = key.key_val;
        params_secu.reqTime = key.reqTime;
        params_secu.crmStaffId = crm_id;///
        params_secu.reginId = latn_id;///
        $.post(url_prefix+url2,params_secu,function(data2){
          //var d2 = {errorCode:0,message:'aaa',entity:{mobilePhone:'17793101351'}};//data2;//{errorCode:0,message:'aaa',mobilePhone:'17793102293'};//
          var d2 = data2;
          if(d2.errorCode!='0'){
            layer.msg(d2.message);
            return;
          }else{
            var phone = d2.entity.mobilePhone;
            if(phone==""){
              layer.msg("该账号在CRM端没有绑定手机号，请先在CRM完善资料");
              return;
            }else{//等待验证短信
              //发送短信
              $("#getPhone").attr("disabled","disabled");
              $("#getPhone").addClass("disabled_btn");
              //$("#st2_phone").show();
              $("#st2_phone").text("验证码发送至"+(phone.substr(0,3)+"*****"+phone.substr(8,3)));

              params_secu.reqPath = url3///

              $.post("<e:url value='makeKey.e' />",params_secu,function(key1){
                var key1 = $.parseJSON(key1);
                params_secu.appKey = key1.key_val;
                params_secu.reqTime = key1.reqTime;
                params_secu.mobilePhone = phone;
                $.post(url_prefix+url3,params_secu,function(data3){
                  //var d3 = {errorCode:0,message:'bbb'};//{errorCode:0,message:'bbb'};//data3 ;
                  var d3 = data3;
                  if(d3.errorCode!=0){//发送短信接口返回失败
                    layer.msg(d3.message);
                    return;
                  }else{//短信已经发送
                    $("#vail_query").removeAttr("disabled");
                    $("#vail_query").removeClass("disabled_btn");
                    $("#vail_query").click(function(){
                      var vail_code = $("#vail_input").val();
                      if($.trim(vail_code)==""){
                        layer.msg("验证码不能为空");
                        return;
                      }else{
                        //发送验证码验证请求
                        params_secu.reqPath = url4;///

                        $.post("<e:url value='makeKey.e' />",params_secu,function(key2){
                          var key2 = $.parseJSON(key2);
                          params_secu.appKey = key2.key_val;
                          params_secu.reqTime = key2.reqTime;
                          params_secu.staffNo = staff_no;
                          params_secu.crmStaffId = crm_id;
                          params_secu.reginId = latn_id;
                          params_secu.mobile = phone;
                          params_secu.verifyCode = vail_code;
                          $.post(url_prefix+url4,params_secu,function(data4){
                            //var d4 = {errorCode:0,message:'ccc'};//{errorCode:0,message:'ccc'};//data4;//{errorCode:0,message:'ccc'};
                            var d4 = data4;
                            if(d4.errorCode!=0){
                              layer.msg(d4.message);
                              return;
                            }else{//绑定成功
                              $("#step01").removeClass("arrow_right");
                              $("#step02").addClass("arrow_right");
                              $("#vail_query").attr("disabled","disabled");
                              $("#vail_query").addClass("disabled_btn");
                              layer.msg("绑定成功");
                              $("#CRM_jump").removeAttr("disabled");
                              $("#CRM_jump").removeClass("disabled_btn");
                              $("#CRM_jump").unbind();
                              $("#CRM_jump").bind("click",function(){
                                params_secu.reqPath = url5;///

                                $.post("<e:url value='makeKey.e' />",params_secu,function(key3) {
                                  var key3 = $.parseJSON(key3);
                                  params_secu.appKey = key3.key_val;
                                  params_secu.reqTime = key3.reqTime;
                                  params_secu.staffNo = staff_no;
                                  $.post(url_prefix+url5,params_secu,function(data5){
                                    //var d5 = {errorCode:0,message:'ddd'};//{errorCode:0,message:'ddd'};//data5;//{errorCode:0,message:'ddd'};
                                    var d5 = data5;
                                    if(d5.errorCode!='0'){
                                      layer.msg(d5.message);
                                      return;
                                    }else{
                                      setTimeout(function(){
                                        parent.crm_id = crm_id;
                                        parent.execute_crm(staff_no,parent.cust_name,parent.cust_addr,parent.contact_num,parent.acc_nbr,parent.scene_id,1);
                                        parent.closeCrmBindWin();
                                      },3000);
                                    }
                                  });
                                })
                              });
                            }
                          });
                        });
                      }
                    });
                  }
                });
              });
            }
          }
        });
      });
    });
    $("#vail_cancel").click(function(){
      parent.closeCrmBindWin();
    });
    //$("#st2_phone").hide();
    $("#step01").addClass("arrow_right");
  });
</script>