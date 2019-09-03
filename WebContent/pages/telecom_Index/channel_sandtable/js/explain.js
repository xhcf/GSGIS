/*指标解释*/
	function explain(json){
		var channel_type = json.CHANNEL_TYPE_NAME;//channel_obj.CHANNEL_TYPE_NAME;
		if(channel_type.indexOf('外包')>-1){
			var wb_html=//'<div style="width: 100%;height: 100%;overflow-y: auto;">'+
				'<table class="zbjs-table" cellpadding="0" cellspacing="0" border="1">                                            '+
				'	<thead>                                                                                            '+
				'		<tr class="zbjstable-head">                                                                    '+
				//'			<td>序号</td>                                                                              '+
				'			<td style="width:10%;">指标分类</td>                                                                          '+
				'			<td>指标名称</td>                                                                          '+
				'			<td style="width:5%;">权重</td>                                                                              '+
				'			<td style="width:10%;">实际得分</td>                                                                              '+
				'			<td style="width: 34%;">指标定义或口径</td>                                                                    '+
				'			<td>考核指标值及子指标值</td>                                                                    '+
				'		</tr>                                                                                          '+
				'	</thead>                                                                                           '+
				'	<tr class="qianlan">                                                                               '+
				//'			<td>1</td>                                                                                 '+
				'			<td rowspan="2" style="text-align:center;">渠道布局类<br/>（10分）</td>                                                                '+
				'			<td>实体渠道坪效</td>                                                                      '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.ARPU_AREA_SIZE_RATE_SCORE+'</td>                                                                                 '+
				'			<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/厅店面积数（渠道视图中）</td>   '+
				'			<td>实体渠道坪效：<span style="color:#0011ff">'+json.ARPU_AREA_SIZE_RATE+'</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">'+json.YD_KD_ITV_CHARGE+(json.YKIC_FLAG=="xiao"?'元':'万元')+'</span><br/>厅店面积：<span style="color:#0011ff">'+json.CHANNEL_AREA+'平方米</span></td>   '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>2</td>                                                                                 '+
				//'			<td>渠道布局类<br/>（10分）</td>                                                                '+
				'			<td>实体渠道人效</td>                                                                      '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.ARPU_STAFF_RATE_SCORE+'</td>                                                                                 '+
				'			<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/（渠道视图中本渠道单元年初工号数+统计月工号数）的静态平均值</td>'+
				'			<td>实体渠道人效：<span style="color:#0011ff">'+json.ARPU_STAFF_RATE+'</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">'+json.YD_KD_ITV_CHARGE+(json.YKIC_FLAG=="xiao"?'元':'万元')+'</span><br/>静态平均值：<span style="color:#0011ff">'+json.STATIC_AVE_VALUE+'</span></td>'+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>3</td>                                                                                 '+
				'			<td rowspan="9" style="text-align:center;">用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动新增</td>                                                                          '+
				'			<td style="text-align:center;">9</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网移动新增用户</td>                                                                    '+
				'			<td>移动新增：<span style="color:#0011ff">'+json.YD_XZ+'</span></td>                                                                          '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>4</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动三零用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_3ZERO_SCORE+'</td>                                                                                 '+
				'			<td>月短信条数+语音分钟+上网流量M数为零</td>                                               '+
				'			<td>移动三零用户数：<span style="color:#0011ff">'+json.YD_3ZERO+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>5</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动有效用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_YOUXIAO_SCORE+'</td>                                                                                 '+
				'			<td>月短信条数+语音分钟+上网流量M数≥30</td>                                                '+
				'			<td>移动有效用户数：<span style="color:#0011ff">'+json.YD_YOUXIAO+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>6</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>二次充值用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.TWO_CZ_SCORE+'</td>                                                                                 '+
				'			<td>除首次开户CRM送计费外，再有充值记录均符合二次充值范畴</td>                             '+
				'			<td>二次充值用户数：<span style="color:#0011ff">'+json.TWO_CZ+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>7</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带新增</td>                                                                          '+
				'			<td style="text-align:center;">9</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网宽带新增用户</td>                                                                    '+
				'			<td>宽带新增：<span style="color:#0011ff">'+json.KD_XZ+'</span></td>                                                                          '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>8</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带零流量用户数</td>                                                                  '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_ZERO_SCORE+'</td>                                                                                 '+
				'			<td>上网M数为零</td>                                                                       '+
				'			<td>宽带零流量用户数：<span style="color:#0011ff">'+json.KD_ZERO+'</span></td>                                                                  '+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>9</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带有效用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_YOUXIAO_SCORE+'</td>                                                                                 '+
				'			<td>上网M数≥300</td>                                                                       '+
				'			<td>宽带有效用户数：<span style="color:#0011ff">'+json.KD_YOUXIAO+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>10</td>                                                                                '+
				//'			<td>用户规模类（60分）</td>                                                                '+
				'			<td>天翼高清新装</td>                                                                      '+
				'			<td style="text-align:center;">7</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.ITV_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网天翼高清新增用户</td>                                                                    '+
				'			<td>天翼高清新装：<span style="color:#0011ff">'+json.ITV_XZ+'</span></td>                                                                      '+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>11</td>                                                                                '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>渠道积分</td>                                                                          '+
				'			<td style="text-align:center;">10</td>                                                                                '+
				'			<td style="text-align:center;color:#f90;">'+json.FZJF_KJ_SCORE+'</td>                                                                                '+
				'			<td>根据积分规则计算出的渠道积分</td>                                                      '+
				'			<td>渠道积分（扣减后）：<span style="color:#0011ff">'+json.FZJF_KJ+(json.FZJF_KJ_FLAG=="xiao"?'':'万')+'</span></td>                                                                          '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>12</td>                                                                                '+
				'			<td rowspan="2" style="text-align:center;">用户质态类<br/>（10分）</td>                                                                '+
				'			<td>移动套餐价值</td>                                                                      '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.LEVEL_NUMBER_SCORE+'</td>                                                                                 '+
				'			<td>移动用户套餐价值合计</td>                                                                    '+
				'			<td>移动套餐价值合计：<span style="color:#0011ff">'+json.LEVEL_NUMBER+'</span>'+(json.LN_FLAG=="xiao"?'元':'万元')+'/月</td>                                                                      '+
				'		</tr>                                                                                            '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>13</td>                                                                                '+
				//'			<td>用户质态类<br/>（10分）</td>                                                                '+
				'			<td>当年新增移动保有率</td>                                                                '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.BAOYOU_YEAR_RETE_SCORE+'</td>                                                                                 '+
				'			<td>本年新增移动统计期内在网用户数/本年新增移动用户数</td>                                 '+
				'			<td>当年新增移动<br/>保有率：<span style="color:#0011ff">'+json.BAOYOU_YEAR_RETE+'</span><br/>本年新增移动在网用户数：<span style="color:#0011ff">'+json.YD_XZ_ZW_YEAR+'</span><br/>本年新增移动用户数：<span style="color:#0011ff">'+json.YD_XZ_YEAR+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>14</td>                                                                                '+
				'			<td rowspan="3" style="text-align:center;">渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>百元渠道佣金拉动新增收入</td>                                                          '+
				'			<td style="text-align:center;">6</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.NEW_ARPU_COMM_100_FEE_SCORE+'</td>                                                                                 '+
				'			<td>本年新增用户本年累计新增收入（计费出账数据）/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>'+
				'			<td>百元渠道佣金<br/>拉动新增收入：<span style="color:#0011ff">'+json.NEW_ARPU_COMM_100_FEE+(json.NAC1F_FLAG=="xiao"?'元':'万元')+'</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">'+json.YD_KD_ITV_CHARGE+(json.YKIC_FLAG=="xiao"?'元':'万元')+'</span><br/>本年累计渠道佣金:<span style="color:#0011ff">'+json.REWARD_COST+'</span>'+(json.RC_FLAG=="xiao"?'元':'万元')+'</td>'+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>15</td>                                                                                '+
				//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>百元渠道佣金拉动新增用户</td>                                                          '+
				'			<td style="text-align:center;">6</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.NEW_USER_COMM_100_NUM_SCORE+'</td>                                                                                 '+
				'			<td>本年新增用户本年累计新增用户/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>     '+
				'			<td>百元渠道佣金拉动<br/>新增用户：<span style="color:#0011ff">'+json.NEW_USER_COMM_100_NUM+'户</span><br/>本年新增用户本年累计<br/>新增用户：<span style="color:#0011ff">'+json.YD_KD_ITV_XZ_YEAR+'户</span><br/>本年累计渠道佣金：<span style="color:#0011ff">'+json.REWARD_COST+'</span>'+(json.RC_FLAG=="xiao"?'元':'万元')+'</td>                                                                                 '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>16</td>                                                                                '+
				//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>门店毛利率</td>                                                                        '+
				'			<td style="text-align:center;">8</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.BENEFIT_RATE_SCORE+'</td>                                                                                 '+
				'			<td>引用财务部毛利模型测算结果</td>                                                        '+
				'			<td>门店毛利率：<span style="color:#0011ff">'+json.CUR_MON_BENEFIT_RATE+'</span></td>                                                                        '+
				'		</tr>                                                                                          '+
				'</table>                                                                                              ';
			$("#wdxn_table").html(wb_html);
		}else if(channel_type.indexOf('直营')>-1 || channel_type.indexOf('专营')>-1){
			var zy_html=//'<div style="width: 100%;height: 100%;overflow-y: auto;">'+
				'<table class="zbjs-table" cellpadding="0" cellspacing="0" border="1">                                            '+
				'	<thead>                                                                                            '+
				'		<tr class="zbjstable-head">                                                                    '+
				//'			<td>序号</td>                                                                              '+
				'			<td style="width:10%;">指标分类</td>                                                                          '+
				'			<td>指标名称</td>                                                                          '+
				'			<td style="width:5%;">权重</td>                                                                              '+
				'			<td style="width:10%;">实际得分</td>                                                                              '+
				'			<td style="width: 34%;">指标定义或口径</td>                                                                    '+
				'			<td>考核指标值及子指标值</td>                                                                    '+
				'		</tr>                                                                                          '+
				'	</thead>                                                                                           '+
				'	<tr class="qianlan">                                                                               '+
				//'			<td>1</td>                                                                                 '+
				'			<td rowspan="2" style="text-align:center;">渠道布局类<br/>（5分）</td>                                                                '+
				'			<td>实体渠道坪效</td>                                                                      '+
				'			<td style="text-align:center;">3</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.ARPU_AREA_SIZE_RATE_SCORE+'</td>                                                                                 '+
				'			<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/厅店面积数（渠道视图中）</td>   '+
				'			<td>实体渠道坪效：<span style="color:#0011ff">'+json.ARPU_AREA_SIZE_RATE+'</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">'+json.YD_KD_ITV_CHARGE+(json.YKIC_FLAG=="xiao"?'元':'万元')+'</span><br/>厅店面积：<span style="color:#0011ff">'+json.CHANNEL_AREA+'</span>平方米</td>   '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>2</td>                                                                                 '+
				//'			<td>渠道布局类<br/>（5分）</td>                                                                '+
				'			<td>实体渠道人效</td>                                                                      '+
				'			<td style="text-align:center;">2</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.ARPU_STAFF_RATE_SCORE+'</td>                                                                                 '+
				'			<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/（渠道视图中本渠道单元年初工号数+统计月工号数）的静态平均值</td>'+
				'			<td>实体渠道人效：<span style="color:#0011ff">'+json.ARPU_STAFF_RATE+'</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">'+json.YD_KD_ITV_CHARGE+(json.YKIC_FLAG=="xiao"?'元':'万元')+'</span><br/>静态平均值：<span style="color:#0011ff">'+json.STATIC_AVE_VALUE+'</span></td>'+
				'		</tr>                                                                                         '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>3</td>                                                                                 '+
				'			<td rowspan="9" style="text-align:center;">用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动新增</td>                                                                          '+
				'			<td style="text-align:center;">9</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网移动新增用户</td>                                                                    '+
				'			<td>移动新增：<span style="color:#0011ff">'+json.YD_XZ+'</span></td>                                                                          '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>4</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动三零用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_3ZERO_SCORE+'</td>                                                                                 '+
				'			<td>月短信条数+语音分钟+上网流量M数为零</td>                                               '+
				'			<td>移动三零用户数：<span style="color:#0011ff">'+json.YD_3ZERO+'</span></td>                                                                    '+
				'		</tr>                                                                                           '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>5</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动有效用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_YOUXIAO_SCORE+'</td>                                                                                 '+
				'			<td>月短信条数+语音分钟+上网流量M数≥30</td>                                                '+
				'			<td>移动有效用户数：<span style="color:#0011ff">'+json.YD_YOUXIAO+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>6</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>二次充值用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.TWO_CZ_SCORE+'</td>                                                                                 '+
				'			<td>除首次开户CRM送计费外，再有充值记录均符合二次充值范畴</td>                             '+
				'			<td>二次充值用户数：<span style="color:#0011ff">'+json.TWO_CZ+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>7</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带新增</td>                                                                          '+
				'			<td style="text-align:center;">9</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网宽带新增用户</td>                                                                    '+
				'			<td>宽带新增：<span style="color:#0011ff">'+json.KD_XZ+'</span></td>                                                                          '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>8</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带零流量用户数</td>                                                                  '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_ZERO_SCORE+'</td>                                                                                 '+
				'			<td>上网M数为零</td>                                                                       '+
				'			<td>宽带零流量用户数：<span style="color:#0011ff">'+json.KD_ZERO+'</span></td>                                                                  '+
				'		</tr>                                                                                           '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>9</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带有效用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_YOUXIAO_SCORE+'</td>                                                                                 '+
				'			<td>上网M数≥300</td>                                                                       '+
				'			<td>宽带有效用户数：<span style="color:#0011ff">'+json.KD_YOUXIAO+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>10</td>                                                                                '+
				//'			<td>用户规模类（60分）</td>                                                                '+
				'			<td>天翼高清新装</td>                                                                      '+
				'			<td style="text-align:center;">7</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.ITV_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网天翼高清新增用户</td>                                                                    '+
				'			<td>天翼高清新装：<span style="color:#0011ff">'+json.ITV_XZ+'</span></td>                                                                      '+
				'		</tr>                                                                                           '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>11</td>                                                                                '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>渠道积分</td>                                                                          '+
				'			<td style="text-align:center;">10</td>                                                                                '+
				'			<td style="text-align:center;color:#f90;">'+json.FZJF_KJ_SCORE+'</td>                                                                                '+
				'			<td>根据积分规则计算出的渠道积分</td>                                                      '+
				'			<td>渠道积分（扣减后）：<span style="color:#0011ff">'+json.FZJF_KJ+(json.FZJF_KJ_FLAG=="xiao"?'':'万')+'</span></td>                                                                          '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>12</td>                                                                                '+
				'			<td rowspan="2" style="text-align:center;">用户质态类<br/>（10分）</td>                                                                '+
				'			<td>移动套餐价值</td>                                                                      '+
				'			<td style="text-align:center;">10</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.LEVEL_NUMBER_SCORE+'</td>                                                                                 '+
				'			<td>移动用户套餐价值合计</td>                                                                    '+
				'			<td>移动套餐价值合计：<span style="color:#0011ff">'+json.LEVEL_NUMBER+'</span>'+(json.LN_FLAG=="xiao"?'元':'万元')+'/月</td>                                                                      '+
				'		</tr>                                                                                             '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>13</td>                                                                                '+
				//'			<td>用户质态类<br/>（5分）</td>                                                                '+
				'			<td>当年新增移动保有率</td>                                                                '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.BAOYOU_YEAR_RETE_SCORE+'</td>                                                                                 '+
				'			<td>本年新增移动统计期内在网用户数/本年新增移动用户数</td>                                 '+
				'			<td>当年新增移动<br/>保有率：<span style="color:#0011ff">'+json.BAOYOU_YEAR_RETE+'</span><br/>本年新增移动在网用户数：<span style="color:#0011ff">'+json.YD_XZ_ZW_YEAR+'</span><br/>本年新增移动用户数：<span style="color:#0011ff">'+json.YD_XZ_YEAR+'</span></td>                                                                    '+
				'		</tr>                                                                                           '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>14</td>                                                                                '+
				'			<td rowspan="3" style="text-align:center;">渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>百元渠道佣金拉动新增收入</td>                                                          '+
				'			<td style="text-align:center;">6</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.NEW_ARPU_COMM_100_FEE_SCORE+'</td>                                                                                 '+
				'			<td>本年新增用户本年累计新增收入（计费出账数据）/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>'+
				'			<td>百元渠道佣金拉动<br/>新增收入：<span style="color:#0011ff">'+json.NEW_ARPU_COMM_100_FEE+(json.NAC1F_FLAG=="xiao"?'元':'万元')+'</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">'+json.YD_KD_ITV_CHARGE+(json.YKIC_FLAG=="xiao"?'元':'万元')+'</span><br/>本年累计渠道佣金:<span style="color:#0011ff">'+json.REWARD_COST+'</span>'+(json.RC_FLAG=="xiao"?'元':'万元')+'</td>'+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>15</td>                                                                                '+
				//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>百元渠道佣金拉动新增用户</td>                                                          '+
				'			<td style="text-align:center;">6</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.NEW_USER_COMM_100_NUM_SCORE+'</td>                                                                                 '+
				'			<td>本年新增用户本年累计新增用户/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>     '+
				'			<td>百元渠道佣金拉动<br/>新增用户：<span style="color:#0011ff">'+json.NEW_USER_COMM_100_NUM+'户</span><br/>本年新增用户本年累计<br/>新增用户：<span style="color:#0011ff">'+json.YD_KD_ITV_XZ_YEAR+'户</span><br/>本年累计渠道佣金：<span style="color:#0011ff">'+json.REWARD_COST+'</span>'+(json.RC_FLAG=="xiao"?'元':'万元')+'</td>                                                                                 '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>16</td>                                                                                '+
				//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>门店毛利率</td>                                                                        '+
				'			<td style="text-align:center;">8</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.BENEFIT_RATE_SCORE+'</td>                                                                                 '+
				'			<td>引用财务部毛利模型测算结果</td>                                                        '+
				'			<td>门店毛利率：<span style="color:#0011ff">'+json.CUR_MON_BENEFIT_RATE+'</span></td>                                                                        '+
				'		</tr>                                                                                          '+
				'</table>                                                                                              ';
			$("#wdxn_table").html(zy_html);
		}else{
			var dl_html=//'<div style="width: 100%;height: 100%;overflow-y: auto;">'+
				'<table class="zbjs-table" cellpadding="0" cellspacing="0" border="1">                                            '+
				'<thead>                                                                                                '+
				'<tr class="zbjstable-head">                                                                            '+
				//'	<td>序号</td>                                                                                       '+
				'	<td style="width:10%;">指标分类</td>                                                                                   '+
				'	<td>指标名称</td>                                                                                   '+
				'	<td style="width:5%;">权重</td>                                                                                       '+
				'	<td style="width:10%;">实际得分</td>                                                                                       '+
				'	<td style="width: 34%;">指标定义或口径</td>                                                                             '+
				'	<td>考核指标值及子指标值</td>                                                                             '+
				'</tr>                                                                                                  '+
				'</thead>                                                                                               '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>3</td>                                                                                 '+
				'			<td rowspan="9" style="text-align:center;">用户规模类<br/>（70分）</td>                                                                '+
				'			<td>移动新增</td>                                                                          '+
				'			<td style="text-align:center;">14</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网移动新增用户</td>                                                                    '+
				'			<td>移动新增：<span style="color:#0011ff">'+json.YD_XZ+'</span></td>                                                                          '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>4</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动三零用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_3ZERO_SCORE+'</td>                                                                                 '+
				'			<td>月短信条数+语音分钟+上网流量M数为零</td>                                               '+
				'			<td>移动三零用户数：<span style="color:#0011ff">'+json.YD_3ZERO+'</span></td>                                                                    '+
				'		</tr>                                                                                           '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>5</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>移动有效用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.YD_YOUXIAO_SCORE+'</td>                                                                                 '+
				'			<td>月短信条数+语音分钟+上网流量M数≥30</td>                                                '+
				'			<td>移动有效用户数：<span style="color:#0011ff">'+json.YD_YOUXIAO+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>6</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>二次充值用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.TWO_CZ_SCORE+'</td>                                                                                 '+
				'			<td>除首次开户CRM送计费外，再有充值记录均符合二次充值范畴</td>                             '+
				'			<td>二次充值用户数：<span style="color:#0011ff">'+json.TWO_CZ+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>7</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带新增</td>                                                                          '+
				'			<td style="text-align:center;">14</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网宽带新增用户</td>                                                                    '+
				'			<td>宽带新增：<span style="color:#0011ff">'+json.KD_XZ+'</span></td>                                                                          '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>8</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带零流量用户数</td>                                                                  '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_ZERO_SCORE+'</td>                                                                                 '+
				'			<td>上网M数为零</td>                                                                       '+
				'			<td>宽带零流量用户数：<span style="color:#0011ff">'+json.KD_ZERO+'</span></td>                                                                  '+
				'		</tr>                                                                                           '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>9</td>                                                                                 '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>宽带有效用户数</td>                                                                    '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.KD_YOUXIAO_SCORE+'</td>                                                                                 '+
				'			<td>上网M数≥300</td>                                                                       '+
				'			<td>宽带有效用户数：<span style="color:#0011ff">'+json.KD_YOUXIAO+'</span></td>                                                                    '+
				'		</tr>                                                                                          '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>10</td>                                                                                '+
				//'			<td>用户规模类（60分）</td>                                                                '+
				'			<td>天翼高清新装</td>                                                                      '+
				'			<td style="text-align:center;">7</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.ITV_XZ_SCORE+'</td>                                                                                 '+
				'			<td>本月在网天翼高清新增用户</td>                                                                    '+
				'			<td>天翼高清新装：<span style="color:#0011ff">'+json.ITV_XZ+'</span></td>                                                                      '+
				'		</tr>                                                                                           '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>11</td>                                                                                '+
				//'			<td>用户规模类<br/>（60分）</td>                                                                '+
				'			<td>渠道积分</td>                                                                          '+
				'			<td style="text-align:center;">10</td>                                                                                '+
				'			<td style="text-align:center;color:#f90;">'+json.FZJF_KJ_SCORE+'</td>                                                                                '+
				'			<td>根据积分规则计算出的渠道积分</td>                                                      '+
				'			<td>渠道积分：<span style="color:#0011ff">'+json.FZJF_KJ+(json.FZJF_KJ_FLAG=="xiao"?'':'万')+'</span></td>                                                                          '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>12</td>                                                                                '+
				'			<td rowspan="2" style="text-align:center;">用户质态类<br/>（10分）</td>                                                                '+
				'			<td>移动套餐价值</td>                                                                      '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.LEVEL_NUMBER_SCORE+'</td>                                                                                 '+
				'			<td>移动用户套餐价值合计</td>                                                                    '+
				'			<td>移动套餐价值合计：<span style="color:#0011ff">'+json.LEVEL_NUMBER+'</span>'+(json.LN_FLAG=="xiao"?'元':'万元')+'/月</td>                                                                      '+
				'		</tr>                                                                                            '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>13</td>                                                                                '+
				//'			<td>用户质态类<br/>（5分）</td>                                                                '+
				'			<td>当年新增移动保有率</td>                                                                '+
				'			<td style="text-align:center;">5</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.BAOYOU_YEAR_RETE_SCORE+'</td>                                                                                 '+
				'			<td>本年新增移动统计期内在网用户数/本年新增移动用户数</td>                                 '+
				'			<td>当年新增移动<br/>保有率：<span style="color:#0011ff">'+json.BAOYOU_YEAR_RETE+'</span><br/>本年新增移动在网用户数：<span style="color:#0011ff">'+json.YD_XZ_ZW_YEAR+'</span><br/>本年新增移动用户数：<span style="color:#0011ff">'+json.YD_XZ_YEAR+'</span></td>                                                                    '+
				'		</tr>                                                                                           '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>14</td>                                                                                '+
				'			<td rowspan="3" style="text-align:center;">渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>百元渠道佣金拉动新增收入</td>                                                          '+
				'			<td style="text-align:center;">6</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.NEW_ARPU_COMM_100_FEE_SCORE+'</td>                                                                                 '+
				'			<td>本年新增用户本年累计新增收入（计费出账数据）/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>'+
				'			<td>百元渠道佣金拉动<br/>新增收入：<span style="color:#0011ff">'+json.NEW_ARPU_COMM_100_FEE+(json.NAC1F_FLAG=="xiao"?'元':'万元')+'</span><br/>本年新增用户本年累计<br/>新增收入：<span style="color:#0011ff">'+json.YD_KD_ITV_CHARGE+(json.YKIC_FLAG=="xiao"?'元':'万元')+'</span><br/>本年累计渠道佣金:<span style="color:#0011ff">'+json.REWARD_COST+'</span>'+(json.RC_FLAG=="xiao"?'元':'万元')+'</td>'+
				'		</tr>                                                                                          '+
				'		<tr class="qianlan">                                                                           '+
				//'			<td>15</td>                                                                                '+
				//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>百元渠道佣金拉动新增用户</td>                                                          '+
				'			<td style="text-align:center;">6</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.NEW_USER_COMM_100_NUM_SCORE+'</td>                                                                                 '+
				'			<td>本年新增用户本年累计新增用户/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>     '+
				'			<td>百元渠道佣金拉动<br/>新增用户：<span style="color:#0011ff">'+json.NEW_USER_COMM_100_NUM+'户</span><br/>本年新增用户本年累计<br/>新增用户：<span style="color:#0011ff">'+json.YD_KD_ITV_XZ_YEAR+'户</span><br/>本年累计渠道佣金：<span style="color:#0011ff">'+json.REWARD_COST+'</span>'+(json.RC_FLAG=="xiao"?'元':'万元')+'</td>                                                                                 '+
				'		</tr>                                                                                         '+
				'		<tr class="shenlan">                                                                           '+
				//'			<td>16</td>                                                                                '+
				//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
				'			<td>门店毛利率</td>                                                                        '+
				'			<td style="text-align:center;">8</td>                                                                                 '+
				'			<td style="text-align:center;color:#f90;">'+json.BENEFIT_RATE_SCORE+'</td>                                                                                 '+
				'			<td>引用财务部毛利模型测算结果</td>                                                        '+
				'			<td>门店毛利率：<span style="color:#0011ff">'+json.CUR_MON_BENEFIT_RATE+'</span></td>                                                                        '+
				'		</tr>                                                                                          '+
				'</table>                                                                                             ';
			$("#wdxn_table").html(dl_html);
		}
	}
	
	function viewScoreRule(){
	    layer.closeAll();
	    parent.layer.open({
	        type: 2,
	        title:'渠道积分规则',
	        content: 'scoreRule.html',
	        offset: ['18%', '9%'],   //相对定位top,left
			area: ['84%', '68%'],  //弹出层页面比例
	        resize:true,
	        fixed: false,
	        maxmin:true,
	        shade:0
	    });
	}
	//日报积分规则
	function viewScoreRuleDay(){
		layer.closeAll();
		parent.layer.open({
			type: 2,
			title:'渠道积分规则',
			content: 'scoreRuleDay.html',
			area: ['100%','85%'],
			resize:true,
			fixed: false,
			maxmin:true,
			shade:0
		});
	}