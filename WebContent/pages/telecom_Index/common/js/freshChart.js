function freshChart(city_name,flag,index_type,last_month_first,last_month_last,current_month_first,current_month_last,url4IndexTabQuery){
	var chart_index = getChartDivIndex(index_type);
	var current_month_data = new Array(31);
	var last_month_data = new Array(31);
	//本月
	$.post(url4IndexTabQuery,{city_id:$("#city_id").val(),flag:flag,eaction:"index_month_diff",city_name:city_name,index_type:index_type,date_start:current_month_first,date_end:current_month_last},function(data){
		data = $.parseJSON(data);
		for(var i = 0,l = data.length;i<l;i++){
			var index = parseInt(data[i].ACCT_DAY.substring(6))-1;
			//current_month_data.push(data[i].CURRENT_DAY_DEV);
			current_month_data.splice(index,1,data[i].CURRENT_DAY_DEV);
		}
		//上月
		$.post(url4IndexTabQuery,{city_id:$("#city_id").val(),flag:flag,eaction:"index_month_diff",city_name:city_name,index_type:index_type,date_start:last_month_first,date_end:last_month_last},function(data){
			data = $.parseJSON(data);
			for(var i = 0,l = data.length;i<l;i++){
				//last_month_data.push(data[i].CURRENT_DAY_DEV);
				var index = parseInt(data[i].ACCT_DAY.substring(6))-1;
				//current_month_data.push(data[i].CURRENT_DAY_DEV);
				last_month_data.splice(index,1,data[i].CURRENT_DAY_DEV);
			}

			//var days = 31;
			/*var days = current_month_data>=last_month_data?current_month_data.length:last_month_data.length;
			 console.log("数据天数："+days);
			 var days_array = new Array();
			 for(var i = 1,l = days.length;i<=l;i++){
			 days_array.push(i);
			 }*/

			var chart_div_id = "target_map";
			$("."+chart_div_id).hide();
			if(chart_index>0)
				chart_div_id += chart_index+1;

			$("#"+chart_div_id).width($(".target_wrap").width());
			myChart = echarts.init(document.getElementById(chart_div_id));

			var option = {
				title: {
					text: ''
				},
				tooltip : {
					trigger: 'axis',
					position:"top",
					formatter:function(params){
						var last = params[0];//上月
						var thiz = params[1];//本月
						var tip_str = "";
						var thiz_sn = thiz.seriesName;//本月
						var last_sn = last.seriesName;//上月

						tip_str += thiz_sn;

						var thiz_name = thiz.name;//本月几号
						var last_name = last.name;//上月几号

						if(thiz_name==""){
							tip_str += '暂无数据';
						}else{
							tip_str += thiz_name+"号"+(thiz.value==undefined?"暂无数据":":"+thiz.value);
						}

						tip_str += "<br/>";
						tip_str += last_sn;

						if(last_name==""){
							tip_str += '暂无数据';
						}else{
							tip_str += last_name+"号"+(last.value==undefined?"暂无数据":":"+last.value);
						}
						return tip_str;
					}
				},
				legend: {
					data:['本月','上月'],
					orient: 'vertical',
					left:'right',
					right:60,
					top:22,
					inactiveColor:'#999',
					textStyle:{
						color:'#eee'
					}
				},
				color:['#517693','#61a0a8'],//517693 //2f4554
				toolbox: {
					show:false
				},
				grid: {
					/*left: '3%',
					 right: '4%',
					 bottom: '3%',*/
					top: 10,
					left:0,
					right:60,
					bottom:0,
					//containLabel: true,
					align:"right"
				},
				xAxis : [
					{
						min:1,
						max:31,
						scale:0,
						splitNumber:1,
						minInterval:1,
						interval:1,
						type : 'category',
						boundaryGap : false,
						connectNulls : true,
						data : ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
						//data : days_array
					}
				],
				yAxis : [
					{
						silent: true,
						splitLine: {
							show: false
						},
						connectNulls : true,
						type : 'value'
					}
				],
				series : [
					{
						name:'上月',
						type:'line',
						//stack: '总量',
						areaStyle: {normal: {}},
						data:last_month_data,
						showAllSymbol:true
					},
					{
						name:'本月',
						type:'line',
						//stack: '总量',
						areaStyle: {normal: {}},
						data:current_month_data,
						showAllSymbol:true
					}
				]
			};
			myChart.setOption(option);
			$("#"+chart_div_id).show();
		});
	});
}
function getChartDivIndex(global_current_index_type){
	if(global_current_index_type=="宽带")
		return 1;
	else if(global_current_index_type=="ITV")
		return 2;
	return 0;
}