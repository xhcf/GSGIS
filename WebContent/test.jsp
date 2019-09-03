<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <c:resources type="easyui,app" style="b" />
</head>
<body>
  <button id="a" onclick="javascript:auth()">1)鉴权接口（获取流水号）</button>
  <button id="b" onclick="javascript:getCitys()">2)获取城市列表</button>
  <br/>
  <hr/>
  <div>城市列表:<select id="city"></select></div>小区关键字:<input type="text" id="query" value="中海河山郡" />
  <br/>
  <hr/>
  <button id="d" onclick="javascript:getFloorPlan()">3)获取户型图列表</button><br/>
  户型列表：<br/><div style="border:1px solid #eee;min-width:200px;height:auto;" id="res"></div>
  <hr/>
  <button id="e" onclick="javascript:ActionFloorPlan()">4)获取户型图大图</button><br/>
  户型大图：<br/><div style="border:1px solid #eee;min-width:200px;height:auto;" id="res1"></div>
  <input type="hidden" name="sign" />
</body>
</html>
<script>
  var sign = "";

  function auth(){
    $.post("<e:url value='keepSign.e' />",{},function(data){
      var res = $.parseJSON(data);
      console.log(JSON.stringify(res));
      if(res.success=="1"){
        sign = res.respJson.sign;
      }
      $("#res").empty().append(res.resultMsg);
      $("input[name='sign']").val(sign);
    });
  }
  function getCitys(){
    $.post("<e:url value='getCitys.e' />",{"sign":sign},function(data){
      var res = $.parseJSON(data);
      console.log(JSON.stringify(res));
      $("#res").empty();
      if(res.success=="1"){
        var respJson = res.respJson[0];
        $.each(respJson.cities,function(index,item){
          $("#city").append("<option value=\""+item.cityid+"\">"+item.name+"</option>");
        });
      }else{
        $("#res").empty().append(res.resultMsg);
      }
    });
  }
  function getFloorPlan(){
    var city = $("#city option:selected").val();
    var query = $("#query").val();
    if(city=="" || city==null || query=="" || query==null){
      alert("请选择城市并填写小区关键字查询");
      return;
    }
    $.post("<e:url value='getFloorPlan.e' />",{"sign":sign,"cityid":city,"query":query},function(data){
      var res = $.parseJSON(data);
      console.log(JSON.stringify(res));
      if(res.success=="1"){
        $("#res").empty();
        var respJson = $.parseJSON(res.respJson);
        $.each(respJson,function(index,item){
          var html = "<div><input type='radio' name='obsPlanId' value='"+item.obsPlanId+"' />";
          html+=(index+1)+"&nbsp;";//item.obsPlanId
          html+=item.commName+"&nbsp;"+item.specName+"&nbsp;"+item.srcArea+"平米<br/>";
          html+="<img src='"+item.smallPics.replace("118.180.8.227","135.148.41.51")+"' style='width:auto;height:auto;' /><br/>";
          html+="<img src='"+item.pics.replace("118.180.8.227","135.148.41.51")+"' style='width:auto;height:auto;' /><br/>";
          $("#res").append(html);
          if(index>10)
            return;
        });
      }else{
        $("#res").empty().append(res.resultMsg);
      }
    });
  }
  function ActionFloorPlan(){
    var obsPlanId = $("input[name='obsPlanId']:checked").val();
    if(obsPlanId=="" || obsPlanId==null || obsPlanId==undefined){
      alert("请选择一个户型");
      return;
    }
    $.post("<e:url value='getFloorPlan.e' />",{"sign":sign,"obsPlanId":obsPlanId},function(data){
      var res = $.parseJSON(data);
      console.log(JSON.stringify(res));
      if(res.success=="1"){
        $("#res1").empty();
        var respJson = $.parseJSON(res.respJson);
        console.log(respJson);
        if(respJson.length){
          $("#res1").append("<img src='"+respJson.pics.replace("118.180.8.227","135.148.41.51")+"'>");
        }else{
          $("#res1").append("没有获取到户型图");
        }
      }else{
        $("#res1").empty().append(res.resultMsg);
      }
    });
  }

</script>