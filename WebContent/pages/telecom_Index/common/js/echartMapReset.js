function echartMapReset(min_num,max_num,city_name,series_name,color,data){
		if(city_name.indexOf("省")>-1)
			city_name = city_name.replace(/省/gi,'');

		try{
			min_num = parseInt(min_num);
		}catch(e){
			min_num = 0;
		}
		try{
			max_num = parseInt(max_num);
		}catch(e){
			max_num = 0;
		}

		if(max_num==0)
			color = ['#A8A8A8'];
		chart.setOption({
			tooltip: {
				trigger: 'item'
			},
			/* visualMap: {
			 min: min_num,
			 max: max_num,
			 left: 'left',
			 top: 'bottom',
			 text: [max_num,min_num],           // 文本，默认为数值文本
			 textStyle:{
			 color:"#fff"
			 },
			 calculable: true,
			 color:color,
			 bottom:'10%'
			 }, */
			dataRange: {
				show:false,
				min: min_num,
				max: max_num,
				x: 'left',
				y: 'bottom',
				selectedMode: false,
				text: [max_num,min_num], // 文本，默认为数值文本
				calculable: true,
				color:color,
				textStyle:{
					color:"#fff"
				}
			},
			toolbox: {
				show: false,
				orient: 'vertical',
				left: 'right',
				top: 'bottom',
				feature: {
					dataView: {readOnly: false},
					restore: {},
					saveAsImage: {}
				}
			},
			series: [{
				layoutCenter: ['50%', '50%'],
				layoutSize: '120%',
				type: 'map',
				//map: city_name,
				mapType: city_name,
				name:series_name,
				roam:true,
				zoom:1,
				selectedMode:'single',
				/* label:{
				 normal:{
				 show:true
				 },
				 emphasis:{
				 show:true,
				 textStyle:{
				 color:'#000',
				 fontSize:16,
				 fontWeight:"bolder"
				 }
				 }
				 }, */
				itemStyle:{
					normal : {
						//borderWidth:0.5,
						//borderColor:'#FFFFFF',
						label : {
							show : true
						}
					},
					emphasis : {
						label : {
							show : true
						}
					}
				},
				scaleLimit:{
					min:1,
					max:3
				},
				data:data
			}]
		},true);
		//chartClickAction(silent);
	}