function freshTab(name,global_current_flag,url4IndexTabQuery){
	var divs = $(".target_wrap").children(":eq(1)").children();
	/*var name_temp;
	 if(name!=province_name && global_current_flag<3){
	 if(city_name_speical.indexOf(name)>-1)
	 name_temp = name + '州';
	 else
	 name_temp = name + '市';
	 }*/
	var city_id = city_ids[name];
	if(city_id==undefined)
		city_id = parent.global_current_city_id;

	$.post(url4IndexTabQuery,{eaction:"index_get",city_name:name,flag:global_current_flag,city_id:city_id},function(data){
		data = $.trim(data);
		data = $.parseJSON(data);
		if(data.length==0){
			for(var i = 0,l = divs.length;i<l;i++){
				var current_parent_div = divs[i];
				$(current_parent_div).children(":eq(1)").children(":eq(0)").html("- -");
				$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+("- -"));
				$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+("- -")+"<b class='b'></b>");
			}
			return;
		}
		for(var i = 0,l = data.length;i<l;i++){
			var index = data[i];
			var current_parent_div = "";
			if(index.PRODUCT_DESC == '宽带'){
				current_parent_div = divs[1];
			}else if(index.PRODUCT_DESC == 'ITV'){
				current_parent_div = divs[2];
			}else if(index.PRODUCT_DESC == '移动'){
				current_parent_div = divs[0];
			}
			$(current_parent_div).children(":eq(1)").children(":eq(0)").html(index.CURRENT_DAY_DEV);
			$(current_parent_div).children(":eq(1)").children(":eq(1)").html("月累计："+(index.CURRENT_MON_DEV));
			var up_down_arrow = "1";
			if(index.CURRENT_DAY_HUAN<0)
				up_down_arrow = "2";
			else if(index.CURRENT_DAY_HUAN==0 || index.CURRENT_DAY_HUAN=='')
				up_down_arrow = "";
			$(current_parent_div).children(":eq(1)").children(":eq(2)").html("环比："+(index.CURRENT_DAY_HUAN)+"%<b class='b"+up_down_arrow+"'></b>");
		}
	});
}