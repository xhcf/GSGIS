

function freshRank(city_name){
	$.post("tabData.jsp",{eaction:"proc_get",city_name:city_name},function(data){
		data = $.trim(data);
		data = $.parseJSON(data);
		if(data.length==0)
			return;
		var lis = $("#rank_list").children();
		for(var i = 0,l=lis.length;i<l;i++){
			var ps = $(lis[i]).children();
			for(var o = 0,p =ps.length;o<p-1;o++){
				var obj = data[5*i+o];
				$(ps[o+1]).find("em").html(obj.PROC_RANK+".");
				$(ps[o+1]).find("span").html(obj.CITY_NAME);
				$(ps[o+1]).find("font").html(obj.PROC_NUM);
			}
		}
	});
}