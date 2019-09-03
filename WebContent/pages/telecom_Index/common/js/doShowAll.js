function doShowAll(city_name,toEcharts){
		global_current_area_name = city_name;

		if(toEcharts){//从gis地图返回echarts地图的时候
			global_current_flag = 3;
			global_backToEcharts = true;
			map.removeAllLayers();
			map.destroy();
			$("#gismap").hide();
			$("#pagemap").show();
			$("#navDiv_gis").hide();
			$("#navDiv_echarts").show();

			global_current_map = "echarts";
			if(city_name=='临夏州' || city_name=='甘南州')
				global_current_area_name = city_name.replace(/州/gi,'');
			else
				global_current_area_name = city_name.replace(/市/gi,'');

			qx_name = city_name;

		}else{//仍然在gis中
			global_backToEcharts = false;
			$("#navDiv_echarts").hide();
		}
		click_path.html("当前路径："+province_name+">"+qx_name);

		//echarts地图中 市级返回省级
		chart = echarts.init(document.getElementById('pagemap'),"dark");
		$("#back").remove();

		var params = {};
		if(global_current_area_name == province_name){
			global_current_full_area_name = global_current_area_name;
			global_current_flag = 2;

			click_path.html("当前路径："+province_name);
			$("#navDiv_echarts").hide();
		}

		params.flag = global_current_flag;//市级
		params.index_type = global_current_index_type;
		params.city_name = global_current_area_name;
		global_parent_area_name = global_current_area_name;
		doQuery(params);

		//var chart_index = 0;//默认是移动业务，曲线图切换tab，第1个div索引0

		//右侧 重点指标、发展量曲线图、发展排名
		freshTab(global_current_area_name);
		freshChart(global_current_area_name,global_current_index_type,getChartDivIndex(global_current_index_type));
		freshRank(global_current_area_name);
	}