<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%--网格选择 --%>
<e:q4l var="grid_list">
  SELECT '-1' CODE, '全部' TEXT FROM DUAL UNION ALL
  SELECT GRID_ID CODE,GRID_NAME TEXT FROM gis_data.db_cde_grid
  where UNION_ORG_CODE = '${param.substation }'
  and grid_status = 1 AND GRID_UNION_ORG_CODE <> '-1'
</e:q4l>
<e:q4o var="last_month">
   select min(const_value) val from SYS_CONST_TABLE where const_name = 'calendar.curdate' and data_type = 'mon' and model_id = '6'
</e:q4o>
<html>
<head>
    <title>市场标签</title>
    <link href='<e:url value="/pages/telecom_Index/common/css/room_zq_flag.css?version=1.1"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <style>
        .clickable_room a {
            color: blue;
            cursor: pointer;
            text-decoration: underline;
        }
        .red_font {color:red;}
    </style>
    <script>
    var begin_scroll = "", seq_num = 0, list_page = 0, market_pselect = 0,
    sort_type = 0, sort_state = 0, stop_execute = false;
    var url = "<e:url value='/pages/telecom_Index/common/sql/tabData_sandbox_summary_inside.jsp' />";
    var condition = '${param.condition}';
    $(function(){
      //支局名赋值
      $("#market_sub_name").text(sub_name);
      //标签页切换事件
      $("#market_tab_head > span").each(function (index) {
        $(this).on("click", function () {
          $(this).addClass("active").siblings().removeClass("active");
          var $show_div = $(".div_" + index);
          $show_div.show();
          $("#market_tab_body").children().not($show_div).hide();
          clear_has_selected();
          clear_data();
          if(index==0){
            load_summary();
          }else if(index==1){
        	grid_load();
          }else if(index==2){
            load_village();
          }else if(index==3){
            load_village_list("build_village", "build_grid_id");
            load_build();
          }else if(index==4){
        	load_village_list('resident_village', 'resident_grid_id');
        	load_resident();
          }
        });
      });
      //默认先加载第一个标签的数据
      //load_summary();
      var tab_index = "${param.tab_index}";
      if(tab_index==0){
        $("#market_tab_head span").eq(0).click();
      }else if(tab_index==1){
        $("#market_tab_head span").eq(1).click();
      }else if(tab_index==2){
        $("#market_tab_head span").eq(2).click();
      }else if(tab_index==3){
        $("#market_tab_head span").eq(3).click();
      }else if(tab_index==4){
        $("#market_tab_head span").eq(4).click();
      }else{
        $("#market_tab_head span").eq(0).click();
      }
    });

    $(function() {
    	$("#market_village_pselect > span").each(function(index) {
    		$(this).on("click", function () {
    			$(this).addClass("active").siblings().removeClass("active");
    			clear_data();
    			market_pselect = index;
    			load_village(1);
    		})
    	})
    	$("#market_build_pselect > span").each(function(index) {
            $(this).on("click", function () {
            	$(this).addClass("active").siblings().removeClass("active");
                clear_data();
                market_pselect = index;
                load_build(1);
            })
        })
    })

    //清除已选中的样式, 一般需要在标签页切换时调用.
    function clear_has_selected() {
    	$("#market_village_pselect > span").removeClass("active");
    	$("#market_village_pselect > span").eq(0).addClass("active");
    	$("#market_build_pselect > span").removeClass("active");
    	$("#market_build_pselect > span").eq(0).addClass("active");
    }

    function clear_data() {
    	begin_scroll = "", seq_num = 0, list_page = 0,
    	market_pselect = 0, sort_type = 0, sort_state = 0;
    	$("#market_village_info_list").empty();
    	$("#market_build_info_list").empty();
    	$("#market_resident_info_list").empty();
    	$("#market_grid_info_list").empty();
    }

    //下面是四个标签对应的加载事件
    var month=[];
    var rate=[];
    function load_summary(){
      summary_bar();
      loadsummary_basic_info();
    }

    //加载 统计—市场占有率柱形图
	function summary_bar(){
		var params={};
    	params.latn_id=city_id;
    	params.month=${last_month.val};
    	params.substation=substation;
    	var postUrl="<e:url value='pages/telecom_Index/common/sql/tabData_sandbox_summary_inside.jsp?eaction=summary_bar'/>";
    	//获取统计-柱形图数据；
    	$.post(postUrl,params,function(data){
    		 var data=JSON.parse(data);
    		 month=[];
    		 rate=[];
			 if(data.length>0){
			 for(var i=0;i<data.length;i++){
				month.push(data[i].MONTH_CODE);
				rate.push(data[i].USE_RATE);
			 }
			 var myChart = echarts.init(document.getElementById('summary_right'));
			 option = {
				        title: {
				        text: '宽带渗透率月趋势',
			            textStyle:{
				            //文字颜色
				            color:'#000',
				            //字体风格,'normal','italic','oblique'
				            fontStyle:'normal',
				            //字体粗细 'normal','bold','bolder','lighter',100 | 200 | 300 | 400...
				            fontWeight:'700',
				            //字体大小
				            fontSize:14,
				            fontFamily:'Microsoft Yahei'
			            },
				          left: 'center'
				        },
				        color: ['#3398DB'],
				        tooltip : {
				        	show:false
				        },
				        grid: {
				          top:'10%',
				          left: '0%',
				          right: '0%',
				          bottom: '15%',
				          containLabel: true
				        },
				        xAxis : [
				          {
				            type : 'category',
				            data :month,
				            axisTick: {
				              alignWithLabel: true
				            }
				          }
				        ],
				        yAxis : [
				          {
				            type : 'value',
				             axisLabel: {
				                formatter: '{value} %'
				            },
				            splitLine:{
                                show:false,
                             },
				          }
				        ],
				        series : [
				          {
				            name:'渗透值',
				            type:'bar',
				            barWidth: '40%',
				            label:{
                                normal:{
                                    show:true,
                                    position: 'top' ,
                                     textStyle : {
	                                    fontWeight : 500 ,
	                                    fontSize : 12,    //文字的字体大小
	                                    color:'#000'
                                      },
                                      formatter: '{c}%'
                                }
                            },
				            data: rate
				          }
				        ]

				      };
      myChart.setOption(option);
      	}
			});
    }
    /*summary==end*/

    function loadsummary_basic_info(){
    	 var params={};
    	 params.last_month=${last_month.val};
    	 params.substation=substation;
    	 params.latn_id=city_id;
    	 params.flag='4';
	   	 var postUrl="<e:url value='pages/telecom_Index/common/sql/tabData_sandbox_summary_inside.jsp?eaction=basic_info'/>";
	   	 $.post(postUrl,params,function(data){
	   		 var data=JSON.parse(data);
			 if(data.length>0){
					$("#market_rate").html(data[0].USE_RATE);
					$("#res_num").html(data[0].ADDR_NUM);
					$("#brand_user").html(data[0].USER_NUM_H);
					$("#zq").html(data[0].ZHU_HU_ZQ);
					$("#zq_h").html(data[0].ZHU_HU_ZQ_H);
					$("#buliding_num").html(data[0].BUILD_NUM);
					$("#unreach_buliding_num").html(data[0].BUILD_NUM_UNREACH);
			}
		  });
    }

    function load_village_list(appendId, getGridId) {
    	var $doc = $("#" + appendId);
    	$doc.empty();
    	var params = {
    			eaction: "market_village_name_list",
    			substation: substation,
    			grid_id: $("select[name=" + getGridId + "]").val() == '-1' ? '' : $("#" + getGridId).val()
    	}

    	$.post(url, params, function(data) {
    		data = JSON.parse(data);
    		var d;
    		var newRow = "<option value='' selected='selected'></option>";
    		for (var i = 0, length = data.length; i < length; i++) {
    			d = data[i];
    			newRow += "<option value='" + d.VILLAGE_ID + "'>" + d.VILLAGE_NAME + "</option>";
    		}
    		$doc.append(newRow);
    	})
    }

    function load_village(flag){
    	var params = {
            eaction: "market_village",
            village_name: $("#market_village_name").val().trim(),
            page: 0,
            village_grid_id: $("select[name=village_grid_id]").val() == '-1' ? '' : $("select[name=village_grid_id]").val(),
            substation: substation,
            market_percent_select: market_pselect,
            sort_type: sort_type,
            sort_state: sort_state
        };
    	villageListScroll(params, 1);
    	params.eaction = "market_village_count";
    	$.post(url, params, function (data) {
    		//flag表示第一次加载或是二次加载,当点击渗透率值,排序时, 为2次加载, 不改变渗透率文本内容
    		if (data != null && data.trim() != 'null') {
                data = $.parseJSON(data);
                $("#village_count").html(data.A_COUNT);
                if (flag != 1) {
                	$("#market_village_a_count").html("(" + data.A_COUNT + ")");
                    $("#market_village_h_count").html("(" + data.H_COUNT + ")");
                    $("#market_village_m_count").html("(" + data.M_COUNT + ")");
                    $("#market_village_l_count").html("(" + data.L_COUNT + ")");
                }
            } else {
            	$("#village_count").html(0);
            	if (flag != 1) {
            		$("#market_village_a_count").html("(0)");
                    $("#market_village_h_count").html("(0)");
                    $("#market_village_m_count").html("(0)");
                    $("#market_village_l_count").html("(0)");
            	}
            }
    	})
    }
    //flag表示加载 可变数据 还是不可变数据, 渗透率显示数值为不可变数据.
    function village_query(flag) {
        clear_data();
        load_village();
    }

    function village_sort(type) {
    	var temp = (sort_state == '0' ? '1' : '0');
    	var temp_select = market_pselect;
    	clear_data();
    	sort_type = type;
        sort_state = temp;
        market_pselect = temp_select;
        load_village(1);
    }

    //flag变量参见 load_village
    function load_build(flag){
    	 var params = {
                 eaction: "market_build",
                 build_name: $("#build_build").val().trim(),
                 village_id: $("#build_village").val(),
                 page: 0,
                 build_grid_id: $("select[name=build_grid_id]").val() == '-1' ? '' : $("select[name=build_grid_id]").val(),
                 substation:substation,
                 market_percent_select: market_pselect,
                 sort_type: sort_type,
                 sort_state: sort_state
        }
        buildListScroll(params, 1);
        params.eaction = "market_build_count";
        $.post(url, params, function (data) {
        	if (data != null && data.trim() != 'null') {
                data = $.parseJSON(data);
                $("#market_build_count").html(data.A_COUNT);
                if (flag != 1) {
                    $("#market_build_a_count").html("(" + data.A_COUNT + ")");
                    $("#market_build_h_count").html("(" + data.H_COUNT + ")");
                    $("#market_build_m_count").html("(" + data.M_COUNT + ")");
                    $("#market_build_l_count").html("(" + data.L_COUNT + ")");
                }
            } else {
                $("#market_build_count").html(0);
                if (flag != 1) {
                    $("#market_build_a_count").html("(0)");
                    $("#market_build_h_count").html("(0)");
                    $("#market_build_m_count").html("(0)");
                    $("#market_build_l_count").html("(0)");
                }
            }
        })
    }

    function build_query() {
        clear_data();
        load_build();
    }

    function build_sort(type) {
        var temp = (sort_state == '0' ? '1' : '0');
        var temp_select = market_pselect;
        clear_data();
        sort_type = type;
        sort_state = temp;
        market_pselect = temp_select;
        load_build(1);
    }

    function load_resident(){
        if (condition == "y") {
            $("input[name='is_brand']").removeAttr("checked");
            $("input[name='is_brand'][value='1']").attr("checked", "checked");
            condition = "";
        }
        var band = $("input[name='is_brand']:checked").val();
        var cmpy = $("input[name='operator']:checked").val();
        var params = {
            eaction: "market_resident",
            page: 0,
            resident_grid_id: $("select[name=resident_grid_id]").val() == '-1' ? '' : $("select[name=resident_grid_id]").val(),
            resident_village: $("#resident_village").val(),
            resident_build: $("#resident_build").val().trim(),
            cmpy: cmpy,
            band: band,
            substation: substation
        }
        residentListScroll(params, 1);
        params.eaction = "market_resident_count";
        $.post(url, params, function (data) {
            if (data != null && data.trim() != 'null') {
                data = $.parseJSON(data);
                $("#market_resident_count").html(data.C_NUM);
            } else {
                $("#market_resident_count").html(0);
            }
        })
    }

    function resident_query() {
        clear_data();
        load_resident();
    }

    //滚动加载
     function grid_load(){
        var params = {
            eaction: "market_grid",
            page: 0,
            flag:'5',
            substation:substation,
            last_month:'${last_month.val}'
        }
        gridListScroll(params,1);
     	params.eaction = "market_grid2";
     	$.post(url, params, function (data) {
     		if (data != null && data.trim() != 'null') {
                data = $.parseJSON(data);
                $("#grid_count").html(data[0].NUM);
            } else {
                $("#grid_count").html("-");
            }
     	})
    };

    $(".grid_m_tab").scroll(function () {
      var viewH = $(this).height();
      var contentH = $(this).get(0).scrollHeight;
      var scrollTop = $(this).scrollTop();
      if (scrollTop / (contentH - viewH) >= 0.95) {
        if (new Date().getTime() - begin_scroll > 500) {
          var params = {
              eaction: "market_grid",
              page: ++list_page,
	          flag:'5',
              substation:substation,
              last_month:'${last_month.val}'
          }
          gridListScroll(params,0);
        }
        begin_scroll = new Date().getTime();
      }
    });

    function gridListScroll(params, flag) {
      var $grid_list = $("#market_grid_info_list");
      $.post(url,params, function (data) {
        data = $.parseJSON(data);
        for (var i = 0, l = data.length; i < l; i++) {
            var d = data[i];
            var newRow = "<tr><td style='width:50px'>" + (++seq_num) + "</td>";
             newRow += "<td style='width:145px'><a href=\"javascript:void(0);\"  >" + d.GRID_NAME + "</a></td>";
            newRow += "<td style='width:85px' class='head_table_color'>" + d.USE_RATE + "</td><td style='width:60px'>" + d.ADDR_NUM + "</td><td style='width:90px'>" + d.GZ_H_USE_CNT +"</td><td style='width:85px' class='head_table_color'>" + d.PORT_RATE + "</td><td style='width:60px'>" + d.PORT_ID_CNT + "</td><td style='width:85px'>" + d.USE_PORT_CNT+"<td style='width:86px'>" + d.KONG_PORT_CNT + "</td></tr>"
            $grid_list.append(newRow);
        }
        if (data.length == 0 && flag) {
            $grid_list.empty();
            $grid_list.append("<tr><td style='text-align:center' colspan=9 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
            return;
        }
      });
    }


    $(".village_m_tab").scroll(function () {
      var viewH = $(this).height();
      var contentH = $(this).get(0).scrollHeight;
      var scrollTop = $(this).scrollTop();
      if (scrollTop / (contentH - viewH) >= 0.95) {
        if (new Date().getTime() - begin_scroll > 500) {
          var params = {
              eaction: "market_village",
              village_name: $("#market_village_name").val().trim(),
              page: ++list_page,
              village_grid_id: $("select[name=village_grid_id]").val() == '-1' ? '' : $("select[name=village_grid_id]").val(),
              substation: substation,
              market_percent_select: market_pselect,
              sort_type: sort_type,
              sort_state: sort_state
          }
          villageListScroll(params, 0);
        }
        begin_scroll = new Date().getTime();
      }
    });

    function villageListScroll(params, flag) {
      var $village_list = $("#market_village_info_list");
      $.post(url,params, function (data) {
    		data = $.parseJSON(data);
   	        for (var i = 0, l = data.length; i < l; i++) {
   	            var d = data[i];
                var newRow = "<tr><td style='width:40px'>" + (++seq_num) + "</td>";
                newRow += "<td style='width:120px'><a href=\"javascript:village_position('" + d.UNION_ORG_CODE + "','" + d.BRANCH_NAME + "','" + d.GRID_NAME + "','" + d.STATION_ID + "','" + d.VILLAGE_ID + "');\"  >" + d.VILLAGE_NAME + "</a></td>";
                newRow += "<td style='width:70px' class='head_table_color'>" + d.MARKET_PENETRANCE + "</td><td style='width:50px'>" + d.BUILD_SUM +
                    "</td><td style='width:50px'>" + d.ZHU_HU_SUM + "</td><td style='width:60px'>" + d.WIDE_NET_SUM + "</td><td style='width:70px' class='head_table_color'>" + d.PORT_PERCENT +
                    "</td><td style='width:50px'>" + d.PORT_SUM + "</td><td style='width:60px'>" + d.PORT_USED_SUM +
                    "</td><td style='width:60px'>" + d.PORT_FREE_SUM + "</td></tr>";
   	            $village_list.append(newRow);
   	       }
    	   if (data.length == 0 && flag) {
    		   $village_list.empty();
               $village_list.append("<tr><td style='text-align:center' colspan=10 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
               return;
    	   }
           if (data.length == 0 && flag == 0 && !is_list_load_end){
               getEmptyVillage();
           }
      });
    }

    var is_list_load_end = false;
    function getEmptyVillage(){
        var params = {};
        params.union_org_code = substation;
        params.flag = 3;
        params.eaction = "market_village_empty";
        $.post(url,params,function(data){
            var d = $.parseJSON(data);
            var newRow = "<tr><td style='width:40px'></td>";
            newRow += "<td style='width:120px'>未建小区</td>";
            newRow += "<td style='width:70px' class='head_table_color'>" + d.MARKET_PENETRANCE + "</td><td style='width:50px'>" + d.WJ_CNT +
            "</td><td style='width:50px'>" + d.WJ_GZ_ZHU_HU_COUNT + "</td><td style='width:60px'>" + d.WJ_H_USE_CNT + "</td><td style='width:70px' class='head_table_color'>" + d.PORT_PERCENT +
            "</td><td style='width:50px'>" + d.WJ_PORT_ID_CNT + "</td><td style='width:60px'>" + d.WJ_USE_PORT_CNT +
            "</td><td style='width:60px'>" + d.WJ_KONG_PORT_CNT + "</td></tr>";
            $("#market_village_info_list").append(newRow);
        });
        is_list_load_end = true;
    }

    function village_position(union_org_code,branch_name,grid_name,station_id,village_id){
        clickToGridAndVillage(union_org_code,branch_name ,'',9,grid_name,station_id,village_id,1);
        closeLayerAll();
    }

    $(".build_m_tab").scroll(function () {
      var viewH = $(this).height();
      var contentH = $(this).get(0).scrollHeight;
      var scrollTop = $(this).scrollTop();
      if (scrollTop / (contentH - viewH) >= 0.95) {
        if (new Date().getTime() - begin_scroll > 500) {
          var params = {
                  eaction: "market_build",
                  build_name: $("#build_build").val().trim(),
                  village_id: $("#build_village").val(),
                  page: ++list_page,
                  build_grid_id: $("select[name=build_grid_id]").val() == '-1' ? '' : $("select[name=build_grid_id]").val(),
                  substation:substation,
                  market_percent_select: market_pselect,
                  sort_type: sort_type,
                  sort_state: sort_state
          }
          buildListScroll(params, 0);
        }
        begin_scroll = new Date().getTime();
      }
    });

    function buildListScroll(params, flag) {
      var $build_list = $("#market_build_info_list");
      $.post(url,params, function (data) {
	        data = $.parseJSON(data);
	        for (var i = 0, l = data.length; i < l; i++) {
	            var d = data[i];
	            var newRow = "<tr><td style='width:40px'>" + (++seq_num) + "</td>";
	            //newRow += "<td style='width:150px'><a href=\"javascript:standard_position_load('" + d.SEGM_ID + "','" + parent.city_name + "','" + parent.city_id + "',this)\" > " + d.STAND_NAME + "</a></td>";
	            newRow += "<td style='width:150px'><a href=\"javascript:showBuildDetail('"+ d.SEGM_ID +"', '"+ d.STAND_NAME +"', 'all',0,0)\" > " + d.STAND_NAME + "</a></td>";
	            newRow += "<td style='width:80px'>" + d.VILLAGE_NAME + "</td><td style='width:80px' class='head_table_color'>" + d.MARKET_PERCENT +
	            "</td><td style='width:50px'>" + d.GZ_ZHU_HU_COUNT + "</td><td style='width:70px'>" + d.GZ_KD_CNT +"</td><td style='width:70px' class='head_table_color'>" + d.PORT_PERCENT +
	            "</td><td style='width:50px'>" + d.PORT_SUM + "</td><td style='width:70px'>" + d.PORT_USED_SUM +
	            "</td><td style='width:70px'>" + d.PORT_FREE_SUM + "</td></tr>";
	            $build_list.append(newRow);
	        }
	        if (data.length == 0 && flag) {
	            $build_list.empty();
	            $build_list.append("<tr><td style='text-align:center' colspan=11 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>")
	            return;
	        }
      });
    }

    $(".resident_m_tab").scroll(function () {
      var viewH = $(this).height();
      var contentH = $(this).get(0).scrollHeight;
      var scrollTop = $(this).scrollTop();
      if (scrollTop / (contentH - viewH) >= 0.95) {
        if (new Date().getTime() - begin_scroll > 500) {
          var band = $("input[name='is_brand']:checked").val();
          var cmpy = $("input[name='operator']:checked").val();
          var params = {
                  eaction: "market_resident",
                  page: ++list_page,
                  resident_grid_id: $("select[name=resident_grid_id]").val() == '-1' ? '' : $("select[name=resident_grid_id]").val(),
                  resident_village: $("#resident_village").val(),
                  resident_build: $("#resident_build").val().trim(),
                  cmpy: cmpy,
                  band: band,
                  substation: substation
          }
          residentListScroll(params, 0);
        }
        begin_scroll = new Date().getTime();
      }
    });

    function residentListScroll(params, flag) {
      var $resident_list = $("#market_resident_info_list");
      $.post(url,params, function (data) {
    	if (stop_execute) {
            return false;
        }
        data = JSON.parse(data);
        for (var i = 0, l = data.length; i < l; i++) {
            var d = data[i];

            if(d.KD_DQ_DATE==null|| d.KD_DQ_DATE=='null'){
            	d.KD_DQ_DATE=' ';
            }
            var newRow = "<tr><td style='width:50px'>" + (++seq_num) + "</td>";
            newRow += "<td style='width:210px'>" + d.STAND_NAME_1 + "</td>";
            if(d.KD_BUSINESS=='电信'){
                if(d.SERIAL_NO==2)//政企
                    newRow += "<td style='width:60px;font-weight: bold;color:blue' class='clickable_room'><span class='zhengqi_flag'>政</span><a onclick='openNewWinInfoCollectEdit(\""+ d.SEGM_ID_2 +"\")'>" + d.SEGM_NAME_2 + "</a></td>";
                else if(d.SERIAL_NO==1 || d.SERIAL_NO==4)//普通住户
                    newRow += "<td style='width:60px;font-weight: bold;color:blue' class='clickable_room'><a onclick='openNewWinInfoCollectEdit(\""+ d.SEGM_ID_2 +"\")'>" + d.SEGM_NAME_2 + "</a></td>";
            }else{
                if(d.SERIAL_NO==2)//政企
                    newRow += "<td style='width:60px;font-weight: bold;color:blue' class='clickable_room'><span class='zhengqi_flag'>政</span>" + d.SEGM_NAME_2 + "</td>";
                else if(d.SERIAL_NO==1 || d.SERIAL_NO==4)//普通住户
                    newRow += "<td style='width:60px;font-weight: bold;color:blue' class='clickable_room'>" + d.SEGM_NAME_2 + "</td>";
            }

            newRow += "<td style='width:100px'>" + d.CONNECT_INFO + "</td><td style='width:70px'>" + d.H_NET + "</td>";
            if(d.KD_BUSINESS=='电信'){
                newRow += "<td style='width:60px'>" + d.KD_BUSINESS + "(<span class='red_font'>"+ d.IS_KD_DX +"</span>)</td><td style='width:60px'>" + d.KD_XF +
                "</td><td style='width:70px'>" + d.KD_DQ_DATE + "</td></tr>";
            }else{
                newRow += "<td style='width:60px'>" + d.KD_BUSINESS + "</td><td style='width:60px'>" + d.KD_XF +
                "</td><td style='width:70px'>" + d.KD_DQ_DATE + "</td></tr>";
            }

            $resident_list.append(newRow);
        }
        if (data.length == 0 && flag) {
            $resident_list.empty();
            $resident_list.append("<tr><td style='text-align:center' colspan=8 onMouseOver=\"this.style.background='rgb(250,250,250)'\">没有查询到数据</td></tr>");
            return;
        }
      });
    }

  </script>
</head>
<body>
<div id="market_sub_name" class="sub_name"></div>

<div class="tab_head" id="market_tab_head">
  <span>统计</span> <span>网格</span> <span>小区</span> <span>楼宇</span> <span>住户</span>
</div>

<div class="tab_body" id="market_tab_body">
  <div class="div_show div_0">
    <!--统计标签页内容 -->
    <div class="summary_content">
      <div id="summary_left">
        <div class="summary_left_title">
          宽带渗透率：<span id="market_rate">-</span>
        </div>
        <div class="summary_left_cont">
          <ul>
            <li class="p_date">住户数：<span id="res_num"></span></li>
            <li class="p_date">光宽用户：<span id="brand_user"></span></li>
          </ul>
          <ul>
            <li class="p_date">政企住户数：<span id="zq"></span></li>
            <li class="p_date">政企光宽用户：<span id="zq_h"></span></li>
          </ul>
          <ul>
            <li class="p_date">楼宇数：<span id="buliding_num"></span></li>
            <li class="p_date">未达楼宇数：<span id="unreach_buliding_num"></span></li>
          </ul>
        </div>
      </div>
      <div id="summary_right">
      </div>
    </div>
  </div>
  <div class="div_hide div_1" style="display: none;">
    <!--网格标签页内容 -->
    <div class="grid_count_title">记录数：<span id="grid_count"></span></div>
    <div class="grid_datagrid">
      <div class="head_table_wrapper">
        <table class="head_table">
          <tr>
            <th style="width: 50px;">序号</th>
            <th style="width: 145px;">网格名称</th>
            <th style="width: 85px;" class="head_table_sort">市场渗透率</th>
            <th style="width: 60px;">住户数</th>
            <th style="width: 90px;">光宽用户数</th>
            <%--<th style="width: 65px;">政企<br>住户数</th>
            <th style="width: 65px;">政企光宽<br>用户数</th>--%>
            <th style="width: 85px;">端口占有率</th>
            <th style="width: 60px;">端口数</th>
            <th style="width: 85px;">占用端口数</th>
            <th style="width: 86px;">空闲端口数</th>
          </tr>
        </table>
      </div>
      <div class="t_table grid_m_tab" style="margin:0 auto;">
        <table class="content_table grid_detail_in" id="market_grid_info_list" style="width:100%;">
        </table>
      </div>
    </div>
  </div>
  <div class="div_hide div_2" style="display: none;">
    <!--小区标签页内容start -->
    <div id="village_query" class="resident_wrapper">
      网格: <e:select id="village_grid_id" name="village_grid_id" items="${grid_list.list }" label="TEXT" value="CODE" defaultValue="-1" />
      小区: <input type="text" id="market_village_name" />
      <button class="button_click" onclick="village_query()" >查询</button>
    </div>
    <div class="summary_day_head tab_accuracy_head" id="market_village_pselect">
      <span class="active">全部<span id="market_village_a_count"></span></span><span> 高渗透率<span id="market_village_h_count"></span></span><span> 中渗透率<span id="market_village_m_count"></span></span><span> 低渗透率<span id="market_village_l_count"></span></span>
    </div>
    <div class="grid_count_title">记录数:<span id="village_count"></span></div>
    <div class="village_datagrid">
      <div class="head_table_wrapper">
        <table class="head_table">
          <tr>
            <th width="40">序号</th>
            <th width="120">小区名称</th>
            <th width="70" id="market_village_psort" class="head_table_sort" onclick="village_sort(0)">市场渗透率<i></i></th>
            <th width="50">楼宇数</th>
            <th width="50">住户数</th>
            <th width="60">光宽用户数</th>
            <%--<th width="50px">政企<br>住户数</th>
            <th width="50px">政企光宽<br>用户数</th>--%>
            <th width="70">端口占有率</th>
            <th width="50">端口数</th>
            <th width="60">占用端口数</th>
            <th width="60">空闲端口数</th>
          </tr>
        </table>
      </div>
      <div class="t_table village_m_tab" style="margin:0 auto;">
        <table class="content_table village_detail_in" id="market_village_info_list" style="width:100%;">
        </table>
      </div>
    </div>
    <!--小区标签页内容end -->
  </div>
  <div class="div_hide div_3" style="display: none;">
    <div id="build_query" class="resident_wrapper">
      网格: <e:select id="build_grid_id" name="build_grid_id" items="${grid_list.list }" label="TEXT" value="CODE" onchange="load_village_list('build_village', 'build_grid_id')"/>
      小区: <select id="build_village"></select>
      楼宇: <input type="text" id="build_build" />
      <button class="button_click" onclick="build_query()" >查询</button>
    </div>
    <div class="summary_day_head tab_accuracy_head" id="market_build_pselect">
      <span class="active">全部<span id="market_build_a_count"></span></span><span> 高渗透率<span id="market_build_h_count"></span></span><span> 中渗透率<span id="market_build_m_count"></span></span><span> 低渗透率<span id="market_build_l_count"></span></span>
    </div>
    <div class="grid_count_title">记录数:<span id="market_build_count"></span></div>
    <div class="build_datagrid">
      <div class="head_table_wrapper">
        <table class="head_table">
          <tr>
            <th style="width: 40px;">序号</th>
            <th style="width: 150px;" id="market_build_bsort" class="head_table_sort" onclick="build_sort(2)">楼宇<i></i></th>
            <th style="width: 80px;" id="market_build_vsort" class="head_table_sort" onclick="build_sort(1)">小区名称<i></i></th>
            <th style="width: 80px;" id="market_build_psort" class="head_table_sort" onclick="build_sort(0)">市场渗透率<i></i></th>
            <th style="width: 50px;">住户数</th>
            <th style="width: 70px;">光宽用户数</th>
           <%-- <th style="width: 50px;">政企<br>住户数</th>
            <th style="width: 50px">政企光宽用户数</th>--%>
            <th style="width: 70px;">端口占有率</th>
            <th style="width: 50px;">端口数</th>
            <th style="width: 70px;">占用端口数</th>
            <th style="width: 70px;">空闲端口数</th>
          </tr>
        </table>
      </div>
      <div class="t_table build_m_tab" style="margin:0px auto;">
        <table class="content_table build_detail_in" id="market_build_info_list" style="width:100%;">
        </table>
      </div>
    </div>
  </div>
  <div class="div_hide div_4">
    <!--住户标签页内容 -->
    <div class="resident_wrapper">
      <div id="resident">
        <span style="font-weight: bold;">网格: </span><e:select id="resident_grid_id" name="resident_grid_id" items="${grid_list.list }" label="TEXT" value="CODE" onchange="load_village_list('resident_village', 'resident_grid_id')"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <span style="font-weight: bold;">小区: </span><select id="resident_village"></select>
        <span style="font-weight: bold;">楼宇: </span><input type="text" id="resident_build" style="width: 160px;">
        <button class="button_click" onclick="resident_query()" >查询</button>
      </div>
      <div class="house_detail">
        <div>
          <span style="font-weight: bold;">是否安装：</span><input type="radio" class="resident_band" name="is_brand" value="0" checked="checked" onclick="resident_query()"  /><span>全部</span>
            <input type="radio" class="resident_band" name="is_brand" value="1" onclick="resident_query()"  /><span>是</span>
            <input type="radio" class="resident_band" name="is_brand" value="-1" onclick="resident_query()"  /><span>否</span>
        </div>
        <div>
          <span style="font-weight: bold">运营商:</span><input type="radio" class="resident_cmpy" name="operator" value="0"  checked="checked" onclick="resident_query()" /><span>全部</span>
            <input type="radio" class="resident_cmpy" name="operator" value="5" onclick="resident_query()"  /><span>电信</span>
            <input type="radio" class="resident_cmpy" name="operator" value="1" onclick="resident_query()"  /><span>移动</span>
            <input type="radio" class="resident_cmpy" name="operator" value="2" onclick="resident_query()"  /><span>联通</span>
            <input type="radio" class="resident_cmpy" name="operator" value="3" onclick="resident_query()"  /><span>广电</span>
            <input type="radio" class="resident_cmpy" name="operator" value="4" onclick="resident_query()"  /><span>其他</span>
        </div>
      </div>
    </div>
    <div class="grid_count_title">记录数:<span id="market_resident_count"></span></div>
    <div class="resident_datagrid">
      <div class="head_table_wrapper">
        <table class="head_table">
          <tr>
              <th style="width: 50px">序号</th>
              <th style="width: 210px">楼宇</th>
              <th style="width: 60px">房间号</th>
              <th style="width: 100px">联系方式</th>
              <th style="width: 70px">宽带</th>
              <th style="width: 60px">运营商</th>
              <th style="width: 60px">资费</th>
              <th style="width: 70px;">到期时间</th>
          </tr>
        </table>
      </div>
      <div class="t_table resident_m_tab" style="margin:0px auto;">
        <table class="content_table resident_detail_in" id="market_resident_info_list" style="width:100%;">
        </table>
      </div>
    </div>
  </div>
</div>

</body>
</html>
