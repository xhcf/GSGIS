/*指标解释*/
	function explain(){
		var channel_type = channel_obj.CHANNEL_TYPE_NAME_QD;
		var zy_html='<div style="width: 100%;height: 100%;overflow-y: auto;">'+
		'<table class="zbjs-table" cellpadding="0" cellspacing="0" border="1">                                            '+
		'	<thead>                                                                                            '+
		'		<tr class="zbjstable-head">                                                                    '+
		//'			<td>序号</td>                                                                              '+
		'			<td>指标分类</td>                                                                          '+
		'			<td>指标名称</td>                                                                          '+
		'			<td>指标定义或口径</td>                                                                    '+
		'			<td>权重</td>                                                                              '+
		'		</tr>                                                                                          '+
		'	</thead>                                                                                           '+
		'	<tr class="qianlan">                                                                               '+
		//'			<td>1</td>                                                                                 '+
		'			<td rowspan="2">渠道布局类<br/>（5分）</td>                                                                '+
		'			<td>实体渠道坪效</td>                                                                      '+
		'			<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/厅店面积数（渠道视图中）</td>   '+
		'			<td>3</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>2</td>                                                                                 '+
		//'			<td>渠道布局类<br/>（5分）</td>                                                                '+
		'			<td>实体渠道人效</td>                                                                      '+
		'			<td>各渠道单元本年新增移动、宽带、电视三项产品当年累计收入/（渠道视图中本渠道单元年初工号数+统计月工号数）的静态平均值</td>'+
		'			<td>2</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="qianlan">                                                                           '+
		//'			<td>3</td>                                                                                 '+
		'			<td rowspan="9">用户规模类<br/>（60分）</td>                                                                '+
		'			<td>移动新增</td>                                                                          '+
		'			<td>与目前保持一致</td>                                                                    '+
		'			<td>9</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>4</td>                                                                                 '+
		//'			<td>用户规模类<br/>（60分）</td>                                                                '+
		'			<td>移动三零用户数</td>                                                                    '+
		'			<td>月短信条数+语音分钟+上网流量M数为零</td>                                               '+
		'			<td>5</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="qianlan">                                                                           '+
		//'			<td>5</td>                                                                                 '+
		//'			<td>用户规模类<br/>（60分）</td>                                                                '+
		'			<td>移动有效用户数</td>                                                                    '+
		'			<td>月短信条数+语音分钟+上网流量M数≥30</td>                                                '+
		'			<td>5</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>6</td>                                                                                 '+
		//'			<td>用户规模类<br/>（60分）</td>                                                                '+
		'			<td>二次充值用户数</td>                                                                    '+
		'			<td>除首次开户CRM送计费外，再有充值记录均符合二次充值范畴</td>                             '+
		'			<td>5</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="qianlan">                                                                           '+
		//'			<td>7</td>                                                                                 '+
		//'			<td>用户规模类<br/>（60分）</td>                                                                '+
		'			<td>宽带新增</td>                                                                          '+
		'			<td>与目前保持一致</td>                                                                    '+
		'			<td>9</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>8</td>                                                                                 '+
		//'			<td>用户规模类<br/>（60分）</td>                                                                '+
		'			<td>宽带零流量用户数</td>                                                                  '+
		'			<td>上网M数为零</td>                                                                       '+
		'			<td>5</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="qianlan">                                                                           '+
		//'			<td>9</td>                                                                                 '+
		//'			<td>用户规模类<br/>（60分）</td>                                                                '+
		'			<td>宽带有效用户数</td>                                                                    '+
		'			<td>上网M数≥300</td>                                                                       '+
		'			<td>5</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>10</td>                                                                                '+
		//'			<td>用户规模类（60分）</td>                                                                '+
		'			<td>天翼高清新装</td>                                                                      '+
		'			<td>与目前保持一致</td>                                                                    '+
		'			<td>7</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="qianlan">                                                                           '+
		//'			<td>11</td>                                                                                '+
		//'			<td>用户规模类<br/>（60分）</td>                                                                '+
		'			<td>渠道积分</td>                                                                          '+
		'			<td>根据积分规则计算出的渠道积分</td>                                                      '+
		'			<td>10</td>                                                                                '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>12</td>                                                                                '+
		'			<td rowspan="2">用户质态类<br/>（10分）</td>                                                                '+
		'			<td>移动套餐价值</td>                                                                      '+
		'			<td>与目前保持一致</td>                                                                    '+
		'			<td>10</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="qianlan">                                                                           '+
		//'			<td>13</td>                                                                                '+
		//'			<td>用户质态类<br/>（5分）</td>                                                                '+
		'			<td>当年新增移动保有率</td>                                                                '+
		'			<td>本年新增移动统计期内在网用户数/本年新增移动用户数</td>                                 '+
		'			<td>5</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>14</td>                                                                                '+
		'			<td rowspan="3">渠道效益类<br/>（20分）</td>                                                                '+
		'			<td>百元渠道佣金拉动新增收入</td>                                                          '+
		'			<td>本年新增用户本年累计新增收入（计费出账数据）/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>'+
		'			<td>6</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="qianlan">                                                                           '+
		//'			<td>15</td>                                                                                '+
		//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
		'			<td>百元渠道佣金拉动新增用户</td>                                                          '+
		'			<td>本年新增用户本年累计新增用户/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>     '+
		'			<td>6</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'		<tr class="shenlan">                                                                           '+
		//'			<td>16</td>                                                                                '+
		//'			<td>渠道效益类<br/>（20分）</td>                                                                '+
		'			<td>门店毛利率</td>                                                                        '+
		'			<td>引用财务部毛利模型测算结果</td>                                                        '+
		'			<td>8</td>                                                                                 '+
		'		</tr>                                                                                          '+
		'</table></div>                                                                                              ';
		var bl_html='<div style="width: 100%;height: 100%;overflow-y: auto;">'+
		'<table class="zbjs-table" cellpadding="0" cellspacing="0" border="1">                                            '+
		'<thead>                                                                                                '+
		'<tr class="zbjstable-head">                                                                            '+
		//'	<td>序号</td>                                                                                       '+
		'	<td>指标分类</td>                                                                                   '+
		'	<td>指标名称</td>                                                                                   '+
		'	<td>指标定义或口径</td>                                                                             '+
		'	<td>权重</td>                                                                                       '+
		'</tr>                                                                                                  '+
		'</thead>                                                                                               '+
		'<tr class="qianlan">                                                                                   '+
		//'	<td>1</td>                                                                                          '+
		'	<td rowspan="9">用户规模类（70分）</td>                                                                         '+
		'	<td>移动新增</td>                                                                                   '+
		'	<td>与目前保持一致</td>                                                                             '+
		'	<td>14</td>                                                                                         '+
		'</tr>                                                                                                  '+
		'<tr class="shenlan">                                                                                   '+
		//'	<td>2</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>移动三零用户数</td>                                                                             '+
		'	<td>月短信条数+语音分钟+上网流量M数为零</td>                                                        '+
		'	<td>5</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="qianlan">                                                                                   '+
		//'	<td>3</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>移动有效用户数</td>                                                                             '+
		'	<td>月短信条数+语音分钟+上网流量M数≥30</td>                                                         '+
		'	<td>5</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="shenlan">                                                                                   '+
		//'	<td>4</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>二次充值用户数</td>                                                                             '+
		'	<td>除首次开户CRM送计费外，再有充值记录均符合二次充值范畴</td>                                      '+
		'	<td>5</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="qianlan">                                                                                   '+
		//'	<td>5</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>宽带新增</td>                                                                                   '+
		'	<td>与目前保持一致</td>                                                                             '+
		'	<td>14</td>                                                                                         '+
		'</tr>                                                                                                  '+
		'<tr class="shenlan">                                                                                   '+
		//'	<td>6</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>宽带零流星用户数</td>                                                                           '+
		'	<td>上网M数为零</td>                                                                                '+
		'	<td>5</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="qianlan">                                                                                   '+
		//'	<td>7</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>宽带有效用户数</td>                                                                             '+
		'	<td>上网M数≥300</td>                                                                                '+
		'	<td>5</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="shenlan">                                                                                   '+
		//'	<td>8</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>天翼高清新装</td>                                                                               '+
		'	<td>与目前保持一致</td>                                                                             '+
		'	<td>7</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="qianlan">                                                                                   '+
		//'	<td>9</td>                                                                                          '+
		//'	<td>用户规模类（70分）</td>                                                                         '+
		'	<td>渠道积分</td>                                                                                   '+
		'	<td>根据积分规则计算出的渠道积分</td>                                                               '+
		'	<td>10</td>                                                                                         '+
		'</tr>                                                                                                  '+
		'<tr class="shenlan">                                                                                   '+
		//'	<td>10</td>                                                                                         '+
		'	<td rowspan="3">用户质态类（10分）</td>                                                                         '+
		'	<td>移动套餐价值</td>                                                                               '+
		'	<td>与目前保持一致</td>                                                                             '+
		'	<td>5</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="qianlan">                                                                                   '+
		//'	<td>11</td>                                                                                         '+
		//'	<td>用户质态类（10分）</td>                                                                         '+
		'	<td>当年新增移动保有率</td>                                                                         '+
		'	<td>本年新增移动统计期内在网用户数/本年新增移动用户数</td>                                          '+
		'	<td>5</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="shenlan">                                                                                   '+
		//'	<td>12</td>                                                                                         '+
		//'	<td>用户质态类（10分）</td>                                                                         '+
		'	<td>百元渠道佣金拉动新增收入</td>                                                                   '+
		'	<td>本年新增用户本年累计新增收入（计费出账数据）/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>'+
		'	<td>6</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="qianlan">                                                                                   '+
		//'	<td>13</td>                                                                                         '+
		'	<td rowspan="2">渠道效益类（20分）</td>                                                                         '+
		'	<td>百元渠道佣金拉动新增用户</td>                                                                   '+
		'	<td>本年新增用户本年累计新增用户/本年累计渠道佣金（佣金结算系统中的佣金数据）*100</td>              '+
		'	<td>6</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'<tr class="shenlan">                                                                                   '+
		//'	<td>14</td>                                                                                         '+
		//'	<td>渠道效益类（20分）</td>                                                                         '+
		'	<td>门店毛利率</td>                                                                                 '+
		'	<td>引用财务部毛利模型测算结果</td>                                                                 '+
		'	<td>8</td>                                                                                          '+
		'</tr>                                                                                                  '+
		'</table></div>                                                                                              ';
		if(channel_type.indexOf('外包')>-1){
			parent.layer.open({
				  type: 2, //类型，解析url
				  closeBtn: 1, //关闭按钮是否显示 1显示0不显示
				  title: '指标解释', //页面标题
				  shadeClose: true, //点击遮罩区域是否关闭页面
				  shade: 0.2,  //遮罩透明度
				  offset: ['18%', '11%'],   //相对定位
				  area: ['81%', '68%'],  //弹出层页面比例
				  content: 'score_pop_win_wb.jsp'  //弹出层的url
			}); 
		}else if(channel_type.indexOf('直营')>-1 || channel_type.indexOf('专营')>-1){
			parent.layer.open({
				  type: 2, //类型，解析url
				  closeBtn: 1, //关闭按钮是否显示 1显示0不显示
				  title: '指标解释', //页面标题
				  shadeClose: true, //点击遮罩区域是否关闭页面
				  shade: 0.2,  //遮罩透明度
				offset: ['18%', '11%'],   //相对定位
				  area: ['81%', '68%'],  //弹出层页面比例
				  content: 'score_pop_win_wb.jsp'  //弹出层的url
			}); 
		}else{
			parent.layer.open({
				  type: 2, //类型，解析url
				  closeBtn: 1, //关闭按钮是否显示 1显示0不显示
				  title: '指标解释', //页面标题
				  shadeClose: true, //点击遮罩区域是否关闭页面
				  shade: 0.2,  //遮罩透明度
				offset: ['18%', '11%'],   //相对定位top,left
				  area: ['81%', '68%'],  //弹出层页面比例
				  content: 'score_pop_win_wb.jsp'  //弹出层的url
			}); 
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