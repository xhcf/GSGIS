<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>解释口径说明页</title>
  <style>
    /*指标解释*/
    .kpi_table {width:100%;border-left:1px solid #666;border-top:1px solid #666;/*border-collapse: collapse;*/}
    .kpi_table thead {font-weight:bold;background-color:#eee;}
    .kpi_table thead, .kpi_table tbody {text-align:center;font-size:13px;border:1px solid #666;padding: 8px;}
    .kpi_table th,.kpi_table td {border-right:1px solid #666;border-bottom:1px solid #666;}
    .kpi_tips {font-size:12px;padding-top:5px;}
  </style>
</head>
<body style="padding: 8px 5px;">
  <div id="kpi_description">
    <table class="kpi_table" cellpadding="0" cellspacing="0">
      <thead>
      <tr>
        <th rowspan="2">小区分类</th>
        <th rowspan="2">管控级别</th>
        <th colspan="6" style="height:39px;">小区标签</th>
      </tr>
      <tr>
        <th>渗透率</th>
        <th>异常用户占比</th>
        <th>小区规模</th>
        <th>竞争情况</th>
        <th>消费能力</th>
        <th>小区分群<br/>(客户属性)</th>
      </tr>
      </thead>
      <tbody>
      <tr>
        <td rowspan="3">急迫小区</td>
        <td>省级</td>
        <td rowspan="3">渗透率&lt;=30%</td>
        <td rowspan="3">占比&gt;=30%</td>
        <td>大型小区</td>
        <td rowspan="12">竞争激烈型</td>
        <td rowspan="12">高档<br/>中档<br/>低档<br/>城中村</td>
        <td rowspan="12">公众、<br/>商住一体</td>
      </tr>
      <tr>
        <td>市级</td>
        <td>大中型小区</td>
      </tr>
      <tr>
        <td>县级</td>
        <td>中型小区</td>
      </tr>

      <tr>
        <td rowspan="3">紧迫小区</td>
        <td>省级</td>
        <td rowspan="3">30%&lt;渗透率&lt;40%</td>
        <td rowspan="3">20%&lt;=占比&lt;30%</td>
        <td>大型小区</td>
      </tr>
      <tr>
        <td>市级</td>
        <td>大中型小区</td>
      </tr>
      <tr>
        <td>县级</td>
        <td>中型小区</td>
      </tr>

      <tr>
        <td rowspan="3">操心小区</td>
        <td>省级</td>
        <td rowspan="3">40%&lt;=渗透率&lt;65%</td>
        <td rowspan="3">10%&lt;占比&lt;20%</td>
        <td>大型小区</td>
      </tr>
      <tr>
        <td>市级</td>
        <td>大中型小区</td>
      </tr>
      <tr>
        <td>县级</td>
        <td>中型小区</td>
      </tr>

      <tr>
        <td rowspan="3">平稳小区</td>
        <td>省级</td>
        <td rowspan="3">渗透率&gt;=65%</td>
        <td rowspan="3">占比&lt;=10%</td>
        <td>大型小区</td>
      </tr>
      <tr>
        <td>市级</td>
        <td>大中型小区</td>
      </tr>
      <tr>
        <td>县级</td>
        <td>中型小区</td>
      </tr>
      </tbody>
    </table>
  </div>
  <div class="kpi_tips">
    <span style="padding-left:3px;">备注：</span>
    <ul style="margin:0;margin-left:-20px;">
      <li>【小区规模】大型小区：住户数&gt;1000户，大中型小区：500户&lt;住户数&lt;=1000户，中型小区：200户&lt;住户数&lt;=500户；</li>
      <li>【竞争情况】竞争激烈型：有移动进线的；</li>
      <li>【小区分群】公众：公众住户数占比大于等于70%，商住一体：公众住户数占比大于0且小于70%，政企：公众住户数为0；</li>
    </ul>
  </div>
</body>
</html>
