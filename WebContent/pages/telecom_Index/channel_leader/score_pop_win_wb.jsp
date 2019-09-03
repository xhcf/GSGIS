<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<html>
<head>
  <title>渠道发展效能评估指标——外包厅</title>
  <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
  <link href='<e:url value="/pages/telecom_Index/channel_leader/css/sp_channel.css?version=New Date()"/>' rel="stylesheet" type="text/css" media="all" />
</head>
<body>
  <div style="width: 100%;height: 100%;overflow-y: auto;">
    <table class="zbjs-table" cellpadding="0" cellspacing="0" border="1">
      <thead>
      <tr class="zbjstable-head">
        <td>指标分类</td>
        <td>指标名称</td>
        <td>权重</td>
        <td>实际得分</td>
        <td>指标定义或口径</td>
        <td>指标值及子指标值</td>
      </tr>
      </thead>
      <tr class="qianlan">
        <td rowspan="2">渠道布局类<br/>（<span class="total_bj"></span>分）</td>
        <td>实体渠道坪效</td>
        <td>5</td>
        <td id="df1"></td>
        <td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/厅店面积数（渠道视图中）</td>
        <td>
          <b>实体渠道坪效：<span id="sub_index1_1"></span>元/平方米</b><br/>
          当年累积收入：<span id="sub_index1_2"></span>元<br/>
          厅店面积：<span id="sub_index1_3"></span>平方米
        </td>
      </tr>
      <tr class="shenlan">
        <td>实体渠道人效</td>
        <td>5</td>
        <td id="df2"></td>
        <td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/（渠道视图中本渠道单元年初工号数+统计月工号数）的静态平均值</td>
        <td>
          <b>实体渠道人效：<span id="sub_index2_1"></span></b><br/>
          当年累积收入：<span id="sub_index2_2"></span><br/>
          静态平均值：<span id="sub_index2_3"></span>
        </td>
      </tr>
      <tr class="qianlan">
        <td rowspan="9">用户规模类<br/>（<span id="total_gm"></span>分）</td>
        <td>移动新增</td>
        <td>9</td>
        <td id="df3"></td>
        <td>与目前保持一致</td>
        <td>
          <b>移动新增：<span id="sub_index3_1"></span></b>
        </td>
      </tr>
      <tr class="shenlan">
        <td>移动三零用户数</td>
        <td>5</td>
        <td id="df4"></td>
        <td>月短信条数+语音分钟+上网流量M数为零</td>
        <td>
          <b>移动三零用户数：<span id="sub_index4_1"></span></b>
        </td>
      </tr>
      <tr class="qianlan">
        <td>移动有效用户数</td>
        <td>5</td>
        <td id="df5"></td>
        <td>月短信条数+语音分钟+上网流量M数≥30</td>
        <td>
          <b>移动有效用户数：<span id="sub_index5_1"></span></b>
        </td>
      </tr>
      <tr class="shenlan">
        <td>二次充值用户数</td>
        <td>5</td>
        <td id="df6"></td>
        <td>除首次开户CRM送计费外，再有充值记录均符合二次充值范畴</td>
        <td>
          <b>二次充值用户数：<span id="sub_index6_1"></span></b>
        </td>
      </tr>
      <tr class="qianlan">
        <td>宽带新增</td>
        <td>9</td>
        <td id="df7"></td>
        <td>与目前保持一致</td>
        <td>
          <b>宽带新增：<span id="sub_index7_1"></span></b>
        </td>
      </tr>
      <tr class="shenlan">
        <td>宽带零流量用户数</td>
        <td>5</td>
        <td id="df8"></td>
        <td>上网M数为零</td>
        <td>
          <b>宽带零流量用户数：<span id="sub_index8_1"></span></b>
        </td>
      </tr>
      <tr class="qianlan">
        <td>宽带有效用户数</td>
        <td>5</td>
        <td id="df9"></td>
        <td>上网M数≥300</td>
        <td>
          <b>宽带有效用户数：<span id="sub_index9_1"></span></b>
        </td>
      </tr>
      <tr class="shenlan">
        <td>天翼高清新装</td>
        <td>7</td>
        <td id="df10"></td>
        <td>与目前保持一致</td>
        <td>
          <b>天翼高清新装：<span id="sub_index10_1"></span></b>
        </td>
      </tr>
      <tr class="qianlan">
        <td>渠道积分</td>
        <td>10</td>
        <td id="df11"></td>
        <td>根据积分规则计算出的渠道积分</td>
        <td>
          <b>渠道积分：<span id="sub_index11_1"></span></b>
        </td>
      </tr>
      <tr class="shenlan">
        <td rowspan="2">用户质态类<br/>（<span id="total_zt"></span>分）</td>
        <td>移动套餐价值</td>
        <td>5</td>
        <td id="df12"></td>
        <td>与目前保持一致</td>
        <td>
          <b>移动套餐价值：<span id="sub_index12_1"></span>元/月</b>
        </td>
      </tr>
      <tr class="qianlan">
        <td>当年新增移动保有率</td>
        <td>5</td>
        <td id="df13"></td>
        <td>本年新增移动统计期内在网用户数/本年新增移动用户数</td>
        <td>
          <b>当年新增移动保有率：<span id="sub_index13_1"></span></b><br/>
          本年新增在网用户数：<span id="sub_index13_2"></span><br/>
          本年新增移动用户数：<span id="sub_index13_3"></span>
        </td>
      </tr>
      <tr class="shenlan">
        <td rowspan="3">渠道效益类<br/>（<span id="total_xy"></span>分）</td>
        <td>百元渠道佣金拉动新增收入</td>
        <td>6</td>
        <td id="df14"></td>
        <td>本年新增用户本年累计新增收入（计费出账数据）/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>
        <td>
          <b>百元渠道佣金拉动新增收入：<span id="sub_index14_1"></span>元</b><br/>
          本年新增用户本年累计新增收入：<span id="sub_index14_2"></span>元<br/>
          本年累计渠道佣金：<span id="sub_index14_3"></span>元
        </td>
      </tr>
      <tr class="qianlan">
        <td>百元渠道佣金拉动新增用户</td>
        <td>6</td>
        <td id="df15"></td>
        <td>本年新增用户本年累计新增用户/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>
        <td>
          <b>百元渠道佣金拉动新增用户：<span id="sub_index15_1"></span>户</b><br/>
          本年累计新增用户：<span id="sub_index15_2"></span>户<br/>
          本年累计渠道佣金：<span id="sub_index15_3"></span>元
        </td>
      </tr>
      <tr class="shenlan">
        <td>门店毛利率</td>
        <td>8</td>
        <td id="df16"></td>
        <td>引用财务部毛利模型测算结果</td>
        <td>
          <b>门店毛利率：<span id="sub_index16_1"></span></b>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
<script>
  $(function(){
    getTotal();
    getScore();
    getScoreItem();
  });

  function getTotal(){
    var channel_obj = parent.channel_obj;
    $("#total_bj").text(channel_obj.BJ_MAX);
    $("#total_gm").text(channel_obj.GM_MAX);
    $("#total_zt").text(channel_obj.ZT_MAX);
    $("#total_xy").text(channel_obj.XY_MAX);
  }
  function getScore(){
    $("#df1").text("");
    $("#df2").text("");
    $("#df3").text("");
    $("#df4").text("");

    $("#df5").text("");
    $("#df6").text("");
    $("#df7").text("");
    $("#df8").text("");

    $("#df9").text("");
    $("#df10").text("");
    $("#df11").text("");
    $("#df12").text("");

    $("#df13").text("");
    $("#df14").text("");
    $("#df15").text("");
    $("#df16").text("");
  }
  function getScoreItem(){
    $("#sub_index1_1").text("");
    $("#sub_index1_2").text("");
    $("#sub_index1_3").text("");

    $("#sub_index2_1").text("");
    $("#sub_index2_2").text("");
    $("#sub_index2_3").text("");

    $("#sub_index3_1").text("");
    $("#sub_index4_1").text("");
    $("#sub_index5_1").text("");
    $("#sub_index6_1").text("");
    $("#sub_index7_1").text("");
    $("#sub_index8_1").text("");
    $("#sub_index9_1").text("");
    $("#sub_index10_1").text("");
    $("#sub_index11_1").text("");
    $("#sub_index12_1").text("");

    $("#sub_index13_1").text("");
    $("#sub_index13_2").text("");
    $("#sub_index13_3").text("");

    $("#sub_index14_1").text("");
    $("#sub_index14_2").text("");
    $("#sub_index14_3").text("");

    $("#sub_index15_1").text("");
    $("#sub_index15_2").text("");
    $("#sub_index15_3").text("");

    $("#sub_index16_1").text("");
  }
</script>