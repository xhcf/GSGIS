<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <c:resources type="easyui,app" style="b" />
    <script src='<e:url value="/js/vue.min.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/js/vue-resource.min.js"/>' charset="utf-8"></script>
</head>
<body>
  <div id="app">
    <button id="a" v-on:click="auth">1)鉴权接口（获取流水号）</button>
    <button id="b" @click="getCitys">2)获取城市列表</button>
    <br/>
    <hr/>
    <div>
      城市列表:
      <select id="city">
        <template v-for="item in cities">
          <option value="{{item.cityid}}">{{item.name}}</option>
        </template>
      </select>
    </div>
      小区关键字:<input type="text" id="query" v-model="{{query}}" />
    <br/>
    <hr/>
    <button id="d" v-on:click="getFloorPlan">3)获取户型图列表</button><br/>
    户型列表：<br/><div style="border:1px solid #eee;min-width:200px;height:auto;" id="res">{{msg}}</div>
    <hr/>
    <button id="e" @click="ActionFloorPlan">4)获取户型图大图</button><br/>
    户型大图：<br/><div style="border:1px solid #eee;min-width:200px;height:auto;" id="res1">{{msg1}}</div>
    <input type="hidden" name="sign" value="{{sign}}" />
  </div>
</body>
</html>
<script>
  new Vue({
    el:"#app",
    data:{
      sign:"",
      msg:"",
      msg1:"",
      cities:"",
      query:"中海河山郡"
    },
    methods:{
      auth:function(){
        this.$http.get("<e:url value='keepSign.e' />",{emulateJSON:true}).then(
          function(data){
            var res = data.body;
            console.log(JSON.stringify(res));
            if(res.success=="1"){
              this.sign = res.respJson.sign;
            }
            this.msg = res.resultMsg;
          },
          function(data){

          }
        );
      },
      getCitys:function(){
        this.$http.post("<e:url value='getCitys.e' />",{"sign":this.sign},{emulateJSON:true}).then(
          function(data){
            var res = data.body;
            console.log(JSON.stringify(res));
            if(res.success=="1"){
              var respJson = res.respJson[0];
              this.cities = respJson.cities;
              /*$.each(respJson.cities,function(index,item){
                $("#city").append("<option value=\""+item.cityid+"\">"+item.name+"</option>");
              });*/
            }else{
              //$("#res").empty().append(res.resultMsg);
              this.msg = res.resultMsg;
            }
          },
          function(data){

          }
        );
      },
      getFloorPlan:function(){
        var city = $("#city option:selected").val();
        this.query = $("#query").val();
        if(city=="" || city==null || query=="" || query==null){
          alert("请选择城市并填写小区关键字查询");
          return;
        }
        this.$http.post("<e:url value='getFloorPlan.e' />",{"sign":this.sign,"cityid":city,"query":this.query},{emulateJSON:true}).then(
          function(data){
            var res = data.body;
            console.log(JSON.stringify(res));
            if(res.success=="1"){
              //$("#res").empty();
              debugger;
              var respJson = $.parseJSON(res.respJson);
              $.each(respJson,function(index,item){
                var html = "<div><input type='radio' name='obsPlanId' value='"+item.obsPlanId+"' />";
                html+=(index+1)+"&nbsp;";//item.obsPlanId
                html+=item.commName+"&nbsp;"+item.specName+"&nbsp;"+item.srcArea+"平米<br/>";
                html+="<img src='"+item.smallPics.replace("118.180.8.227","135.148.41.51")+"' style='width:auto;height:auto;' /><br/>";
                html+="<img src='"+item.pics.replace("118.180.8.227","135.148.41.51")+"' style='width:auto;height:auto;' /><br/>";
                //$("#res").append(html);
                this.msg += html;
                if(index>10)
                  return;
              });
            }else{
              //$("#res").empty().append(res.resultMsg);
              this.msg = res.resultMsg;
            }
          },
          function(data){

          }
        );
      },
      ActionFloorPlan:function(){
        var obsPlanId = $("input[name='obsPlanId']:checked").val();
        if(obsPlanId=="" || obsPlanId==null || obsPlanId==undefined){
          alert("请选择一个户型");
          return;
        }
        this.$http.post("<e:url value='getFloorPlan.e' />",{"sign":sign,"obsPlanId":obsPlanId},{emulateJSON:true}).then(
          function(data){
            var res = data.body;
            console.log(JSON.stringify(res));
            if(res.success=="1"){
              //$("#res1").empty();
              debugger;
              var respJson = $.parseJSON(res.respJson);
              console.log(respJson);
              if(respJson.length){
                //$("#res1").append("<img src='"+respJson.pics.replace("118.180.8.227","135.148.41.51")+"'>");
                this.msg1 = "<img src='"+respJson.pics.replace("118.180.8.227","135.148.41.51")+"'>";
              }else{
                //$("#res1").append("没有获取到户型图");
                this.msg1 = "没有获取到户型图";
              }
            }else{
              //$("#res1").empty().append(res.resultMsg);
              this.msg1 = res.resultMsg;
            }
          },
          function(){

          }
        );
      }
    }
  });

</script>