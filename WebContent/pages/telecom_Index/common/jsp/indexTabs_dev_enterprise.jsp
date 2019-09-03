<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4o var="queryDay">
    select t.const_value VAL from ${easy_user}.sys_const_table t where const_type='var.dss35' and model_id = '17'
</e:q4o>
<e:set var="initDay">${queryDay.VAL}</e:set>
<e:q4o var="queryMon">
    select t.const_value VAL from ${easy_user}.sys_const_table t where const_type = 'var.dss36' and model_id = '17'
</e:q4o>
<e:set var="initMon">${queryMon.VAL}</e:set>
<head>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_org_frame.css?version=1.1.1"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/channel_leader/css/leader_bureau_index.css?version=1.2.11"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/leader_condition_init.js?version=1.5"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/resources/component/echarts_new/echarts/echarts/echarts.colors.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/datagrid_reset.css?version=new Date()"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/common/css/font-color.css"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/enterprise_leader/css/enterprise_reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/channel_leader/js/dataFormat.js?version=New Date()"/>' charset="utf-8"></script>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <title>效能概览</title>
    <c:resources type="easyui,app" style="b"/>
    <style type="text/css">
        .tab_label span{
            font-size:17px;
            margin: 5px;
        }

        #sub4 thead td{padding:8px 0}
        #sub4 td{color: #E9EAEE;font-size: 12px;border: 1px solid #014A94;padding:3px 2px; text-align: center;}
        #sub4 td:nth-child(1){border-left: none;}
        #sub4 td:nth-child(4){border-right: none;}
        #sub4 tbody td:nth-child(3){color: #FF6600;}
        .c_rank {margin:0px;margin-top:2%;width:96%;}

        .panel-body {background:none!important;}
        .datagrid {margin-left:2%;}
        /*新加样式*/
        .c_view_top dd {padding-top:11%;}
        .datagrid-header {border-bottom:1px solid #0d3d88!important;}
        .datagrid-body tr td:first {border-width:0 1 1 1}
        .too_long {white-space:nowrap;overflow:hidden;text-overflow:ellipsis;display:block;font-size:14px;}
        .c_view_top ul li {padding-top:5px;}
        #list_cnt {color:red;}

        #pie1,#pie2,#pie3 {height:100px;width:100px;}

        ::-webkit-scrollbar {
            width:10px;
            border-radius: 2px 2px 2px 2px;
        }
				::-webkit-scrollbar-track {
			          -webkit-box-shadow:inset 0 0 6px rgba(0,0,0,0.3);
			          border-radius: 4px;
			          background: rgba(206, 206, 206, 0.22);
				}
				::-webkit-scrollbar-thumb {
				    background: rgb(119, 119, 119);
				    -webkit-box-shadow:inset 0 0 6px rgba(0,0,0,0.5);
				}
				::-webkit-scrollbar-thumb:window-inactive {
				    background:rgba(11,26,165,1);
				}

				::-moz-scrollbar {
				    width:10px;
				}
				::-moz-scrollbar-track {
				    -moz-box-shadow:inset 0 0 6px rgba(0,0,0,0.3);
				    background: rgb(206, 206, 206);
				}

				::-moz-scrollbar-thumb {
				    background: rgb(206, 206, 206);
				    -moz-box-shadow:inset 0 0 6px rgba(0,0,0,0.5);
				}
				::-moz-scrollbar-thumb:window-inactive {
				    background: rgb(206, 206, 206);
				}

        .index_desc{font-size:15px;}
        .index_num {color:#fcff02;font-size:24px;font-weight:bold;}
        .split_right {border-right:1px solid #0D3B57;}/*#00fff0;*/
        .index_name {font-size:16px;}

        .datagrid-header .datagrid-cell span {font-size:12px;}
        .datagrid-cell, .datagrid-cell-group, .datagrid-header-rownumber, .datagrid-cell-rownumber {font-size:12px;}
    </style>
</head>
<body style="width:100%;border:0px;" class="g_target">
<div style="width:100%;height:100%;">
    <div class="c_title"><h2 id="title_name">甘肃省</h2></div>
    <div style="width:98%;margin-left:1%;overflow:hidden;">
        <ul class="c_view_list" style="white-space:nowrap;min-width:100%;max-width:auto;position:absolute;">
            <li class="current" style="border-right:none;">概况</li>
            <li style="border-right:none;display:none;">清单</li>
        </ul>
    </div>

    <div class="c_cont_wrap">
        <!--概览-->
        <div class="c_view">
            <div class="c_view_top clearfix" id="xn_score">
                <h4 class="c_title_com"><i></i>概况</h4>
                <div style="height:72%;float:left;width:30%;padding:3% 0;">
                    <table class="" style="height:100%;width:100%;text-align:center;font-size:12px;">
                        <tr>
                            <td class="index_desc">市场渗透率</td>
                        </tr>
                        <tr>
                            <td id="tab1_t_d1" class="index_num"></td>
                        </tr>
                    </table>
                </div>
                <div class="split_right" style="width:1px;height:65%;margin-top:0%;float:left;"></div>
                <div style="width:63%;margin-left:5%;float:left;">
                    <table style="font-size:12px;height:72%;width:100%;" class="tab1_t_r">
                        <tr>
                            <td style="width:50%;"><span>• 学校数：</span><span id="tab1_t_d2">--</span></td><td style="width:50%;"></td>
                        </tr>
                        <tr>
                            <td style="width:50%;"><span>• 学生数：</span><span id="tab1_t_d3">--</span></td><td style="width:50%;"><span>• 移动用户数：</span><span id="tab1_t_d4">--</span></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="c_view_center">
                <h4 class="c_title_com"><i></i>移动渗透率趋势</h4>
                <div class="c_view_bar" id="c_view_bar"></div>
            </div>
            <div class="c_view_bottom layout">
                <h4 class="c_title_com"><i></i>区域分布</h4>
                <table id="store_type_data" class="c_view_table">
                </table>
            </div>
        </div>

        <!--市级区县使用 -->
        <div id="c_rank" class="c_rank layout">
            <!-- <div>总记录数：<span>200</span></div> -->
            <div>
            	<input type="text" id="search_word" placeholder="请输入学校名称" style="margin-left:2%;width:80%;color:#fff;" /><input id="query_btn" type="button" value="查询" class="easyui-linkbutton" style="width:50px;" />
            </div>
            <span style="padding-left:2%;">记录数：</span><span id="list_cnt"></span>
            <table id="sub4" class="c_view_table"><!-- style="overflow-y: scroll;"-->
            </table>
        </div>
        <!--市级区县使用 -->

    </div>
</div>
<div id="pie_chart_area">
    <div id="pie1" ></div>
    <div id="pie2"></div>
    <div id="pie3"></div>
</div>
</body>
<script>
    var sql_url = '<e:url value="/pages/telecom_Index/common/sql/tabData_enterprise_leader.jsp" />';
    var acct_month='${initMon}';
    //如果已经没有数据, 则不再次发起请求.
    var region_id = '${param.region_id}';

    var region_type = parent.global_current_flag;//'${param.region_type}';

    var bureau_no = parent.global_bureau_id;

    var space = "&nbsp;";
		var big_size = "14";
		var small_size = "12";
		var percent = space+"<span style=\"font-size:"+big_size+"px;color:#fff;font-weight:normal;\">%</span>";

    var table_rows_array = "";
    var table_rows_array_small_screen = [5,25,35];
    var table_rows_array_big_screen = [10,40,50];

    if(window.screen.height<=768){
        table_rows_array = table_rows_array_small_screen;
    }else{
        table_rows_array = table_rows_array_big_screen;
    }

    $(function(){
        if(region_type=="2" ){//|| region_type=="3"
            $("#detail_list").show();
        }

        $('.c_view_list li').click(function(){
            $(this).addClass('current').siblings().removeClass('current');
            $('.c_cont_wrap>div:eq('+$(this).index()+')').show().siblings().hide();
            //点清单 切换页签 页签切换
            if($(this).index()==1){
            	detailList();
            }
        })

        if(region_id == 'undefined'){
            region_id = '';
        }
        /*if(bureau_no != ''){
            region_type =parent.rank_region_type;
        }*/
        /* 概览 */
        //黄色指标
        $.post(sql_url,
            {
                "eaction" : "index_top_summary",
                'region_id' : region_id,
                'bureau_no' : bureau_no,
                'level' : region_type,
                "acct_day":"${initDay}"
            },
            function(obj){
                var data = $.parseJSON(obj);
                //为空判断
                if(data != '' && data != null ){
                    $("#tab1_t_d1").html(data.INDEX_VAL0+percent);
                    $("#tab1_t_d2").text(data.INDEX_VAL1);
                    $("#tab1_t_d3").text(data.INDEX_VAL2);
                    $("#tab1_t_d4").text(data.INDEX_VAL3);
                }else{
                    $("#tab1_t_d1").text("0");
                    $("#tab1_t_d2").text("0");
                    $("#tab1_t_d3").text("0");
                    $("#tab1_t_d4").text("0");
                }
            }
        );
        //移动渗透率趋势 柱状图
        $.post(sql_url,
            {
                "eaction"   : "index_echart_bar",
                'region_id' : region_id,
                'bureau_no' : bureau_no,
                'level' : region_type,
                'acct_month': acct_month,
                "begin_count":5
            },
            function(obj){
                var data = $.parseJSON(obj);
                var xMonth = [],yData = [];
                //为空判断
                if(data != '' && data != null ){
                    $.each(data, function (index, item) {
                        xMonth.push(item.MONTH_CODE);
                        yData.push(parseFloat(item.VAL));
                    });
                }else{
                    xMonth.push(acct_month);
                    yData.push('0.00');
                }
                xn_trendBar(xMonth,yData);
            }
        );
        //区域分布
        var region_name = "分公司";
        var index_name1 = "学校数";
        var index_name2 = "移动用户";
        var index_name3 = "市场渗透率";
        var width1 = 0.23;
        var width2 = 0.19;
        var width3 = 0.29;
        var width4 = 0.29;
        if(region_type == '2'){
            region_name = "县局";
            index_name1 = "学校数";
            index_name2 = "移动用户";
            index_name3 = "市场渗透率";
            width1 = 0.29;
            width2 = 0.19;
            width3 = 0.26;
            width4 = 0.26;
        }else if(region_type == '3'){
            region_name = "学校";
            index_name1 = "学生数";
            index_name2 = "移动用户";
            index_name3 = "渗透率";
            width1 = 0.31;
            width2 = 0.17;
            width3 = 0.26;
            width4 = 0.26;
        }
        var sub_width = $(".c_view_bottom").width()*0.95;
        $("#store_type_data").width($(".c_view_bottom").width()*0.95);
        $("#store_type_data").height($(".c_view").height()-$(".c_view_top").height()-$(".c_view_center").height()-$(".c_title_com").height()-38);

        $("#store_type_data").datagrid({
            url:sql_url,
            queryParams:{
                "eaction":"index_datagrid",
                "acct_day":"${initDay}",
                "level":region_type,
                "city_id":region_id,
                "bureau_no":bureau_no
            },
            fitColumns:false,
            columns:[[
                /*{field:'RN',title:'序号',align:'center',halign:'center',width: sub_width*0.15,
                 formatter:function(value,rowData){
                 if(value==0)
                 return "";
                 return value;
                 }
                 },*/
                {field:'REGION_NAME',title:region_name,align:'center',halign:'center',width: sub_width*width1,
                    formatter:function(value,rowData){
                        if(rowData.ROW_NUM==1)
                            return value;
                        return "<a class=\"too_long\" href=\"javascript:void(0);\" onclick=\"javascript:toNextLevel('"+region_type+"','"+value+"','"+rowData.REGION_ID+"')\" style=\"text-decoration:underline;\" title=\""+value+"\">"+value+"</a>";
                    }
                },
                {field:'INDEX1',title:index_name1,align:'center',halign:'center',width: sub_width*width2,
                    formatter:function(value,rowData){
                        if(value==0)
                            return "";
                        return value;
                    }
                },
                {field:'INDEX2',title:index_name2,align:'center',halign:'center',width: sub_width*width3,
                    formatter:function(value,rowData){
                        if(value==0)
                            return "";
                        return value;
                    }
                },
                {field:'INDEX3',title:index_name3,align:'center',halign:'center',width: sub_width*width4,
                    formatter:function(value,rowData){
                        if(value==0)
                            return "";
                        return "<span class=\"orange\">"+value+"</span>";
                    }
                }
            ]],
            scrollbarSize:"8",
            onLoadSuccess:function(data){
                if(data.rows.length==0){
                    for(var i = 0,l = 5;i<l;i++){
                        $("#store_type_data").datagrid('appendRow',{
                            "REGION_NAME":"",
                            "INDEX1":"",
                            "INDEX2":"",
                            "INDEX3":""
                        });
                    }
                }
            }
        });

        //地图右边显示排名
        var width=$(parent.parent.parent.window).width();
        var scoreWidth = 0;
        var area_width = 0;
        var jf_width = 0;
        var alin = '';
        //显示到渠道的时候宽度调整
        if(region_type == '3'){
            area_width = sub_width*0.35;
            scoreWidth = sub_width*0.25;
            jf_width = sub_width*0.3;
            alin = 'left';
        }else if(region_type == '2'){
            area_width = sub_width*0.35;
            scoreWidth = sub_width*0.25;
            jf_width = sub_width*0.3;
            alin = 'left';
        }else{
            area_width = sub_width*0.3;
            scoreWidth = sub_width*0.3;
            jf_width = sub_width*0.3;
            alin = 'center';
        }
        var areaDescription = '';
        if(region_type == '1'){
            areaDescription = 'AREA_DESCRIPTION';
        }else if(region_type == '2'){
            areaDescription = 'BUREAU_NAME';
        }else if(region_type == '3'){
            areaDescription = 'BRANCH_NAME';
        }

        //按层级定义绑定的事件
        if(region_type==1){
            $("#title_name").text("甘肃省");
        }else if(region_type==2){
            $("#title_name").text(parent.global_position[1]);
        }else if(region_type==3){
            $("#title_name").text(parent.global_position[2]);
        }

        $("#query_btn").click(function(){
        	var key = $.trim($("#search_word").val());
        	var queryParams = $("#sub4").datagrid('options').queryParams;
        	queryParams.v_name = key;
        	$("#sub4").datagrid('reload',queryParams);
        });

    });

    function detailList(){
    	$("#sub4").height(window.screen.height-$(".c_title").height()-$(".c_view_list").height()-28);
    	var sub_width = $("#c_rank").width()*0.95;
        $("#sub4").width($("#c_rank").width()*0.95);

    	if(region_type == "2" || region_type == "3"){
            $("#sub4").datagrid({
              fit: true,
              url: sql_url,
              queryParams: {
                  "eaction" : "getSchoolList",
                  "city_id" : region_id,
                  "bureau_no" : bureau_no,
                  "region_type" : region_type
              },
              pagination:false,
              pageSize: 500,//每页显示的记录条数，默认为10
              pageList: [500,1000,2000],//可以设置每页记录条数的列表
              //pageSize: [5],//table_rows_array[0],
              fitColumns:false,
              columns:[
                  [
                      {field:'RN',title:'序号',align:'center',halign:'center',width:sub_width*0.15,
                          formatter:function(value,rowData,index){
                              return value;
                          }
                      },
                      {field:'BUSINESS_NAME',title:'学校名称',align:'left',halign:'center',width:sub_width*0.25,
                          formatter:function(value,rowData){
                              return "<a class=\"too_long\" href=\"javascript:void(0);\" onclick=\"javascript:toSchool('','"+rowData.BUREAU_NO+"','"+rowData.BUREAU_NAME+"','"+rowData.BUSINESS_ID+"',"+rowData.POSITION+")\" style=\"text-decoration:underline;\" title=\""+value+"\">"+value+"</a>";
                          }
                      },
                      {field:'STUDENTS_CNT',title:'学生数',align:'center',halign:'center',width:sub_width*0.16,
                          formatter:function(value,rowData){
                              return value;
                          }
                      },
                      {field:'YD_USER_CNT',title:'移动用户数',align:'center',halign:'center',width:sub_width*0.22,
                          formatter:function(value,rowData){
                              return "<span class=\"too_long\">"+value+"</span>";
                          }
                      },
                      {field:'MARKET_PERCENT',title:'市场渗透率',align:'center',halign:'center',width:sub_width*0.22,
                          formatter:function(value,rowData){
                              return "<span class=\"too_long orange\">"+value+"</span>";
                          }
                      }
                  ]
              ],
              scrollbarSize:"8",
              onLoadSuccess:function (data) {
                  /*  if(region_type == '3'){
                   $('#sub4').datagrid('hideColumn','CZ');
                   }   */
                   $(".c_rank").width("100%");
                   if(data.rows.length==0){
                    for(var i = 0,l = 5;i<l;i++){
                        $("#sub4").datagrid('appendRow',{
                            "RN":" ",
                            "BUSINESS_NAME":" ",
                            "STUDENTS_CNT":" ",
                            "YD_USER_CNT":" ",
                            "MARKET_PERCENT":" "
                        });
                    }
                    //$(".datagrid-header").css({"width":$(this).width()});
                }
                if(data.rows.length)
                    $("#list_cnt").text(data.rows[0].C_NUM);
                else
                    $("#list_cnt").text("0");
              },onClickRow: function (index,row){
                  //global_substation_sub = "";
                  //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
              }
          });
		}
    }

    /*移动渗透率趋势 柱状图*/
    function xn_trendBar(xMonth,yData){
        var c_view_bar = echarts.init(document.getElementById('c_view_bar'));
        var option = {
            color: ['#21A9F5'],
            grid:{
                bottom: '18%',
                right: '4%',
                top:'14%',
                left:'4%'
            },
            xAxis: {
                type: 'category',
                data: xMonth,//['201801', '201802', '201803', '201804', '201805', '201806'],
                axisTick: {
                show: false},
                axisLine: {lineStyle: {color: '#e4e4e4'}},
                axisLabel: {textStyle: {fontSize:12}}
            },
            yAxis: {
                show:false,
                type: 'value',
                splitLine:{show:false},
                axisLine: {
                    lineStyle: {color:'#555'}
                }
            },
            series: [{
                data: yData,//[820, 932, 901, 820, 932, 932],
                type: 'bar',
                barWidth: '22',
                itemStyle: {
                    normal: {
                        label: {
                            show: true,
                            position: 'top' ,
                            textStyle: {color:'#ffffff',fontSize: '13'},
                            formatter:'{c}%'
                        }
                    }
                }
            }]
        };
        c_view_bar.setOption(option);
    }

    function num_formatter(value){
        var value_str = value+"";
        if(value_str.indexOf(".")==-1)
            return "<span style='color: #fa8513'>" + value + ".00%</span>";
        if(value_str.substr(value_str.indexOf(".")+1).length==1)
            return "<span style='color: #fa8513'>" + (value+"0") + "%</span>";
        else
            return "<span style='color: #fa8513'>" + value + "%</span>";
    }

    var url_map_city = '<e:url value="/pages/telecom_Index/enterprise_leader/leader_city_level.jsp" />';
    var url_map_bureau = '<e:url value="/pages/telecom_Index/enterprise_leader/leader_bureau_level.jsp" />';
    var url_index = '<e:url value="/pages/telecom_Index/common/jsp/indexTabs_dev_enterprise.jsp" />';

    function toNextLevel(level,region_name,region_id){
        var cityFull = region_name;//点击后获得的名字

        parent.global_current_full_area_name = cityFull;
        parent.global_current_flag = parseInt(parent.global_current_flag)+1;

        //var jsonNo = cityMap[cityFull];

        var city = "";
        if(level=='1'){
            if(city_name_speical.indexOf(cityFull)>-1)
                city = cityFull.replace(/州/gi,'');
            else
                city = cityFull.replace(/市/gi,'');
            city = cityFull;
            parent.global_current_city_id = region_id;
        }else if(level=='2'){
            city = cityFull;
            parent.global_bureau_id	= region_id;
        }

        parent.global_current_area_name = city;//城关区

        if(level=='1'){
            parent.global_position.splice(1,1,cityFull);
            if(zxs[cityFull]!=undefined){
                parent.global_position.splice(2,1,cityFull);
            }
        }else if(level=='2'){
            parent.global_position.splice(2,1,cityFull);
        }
        //echarts地图刷新和gis都要重新加载地图和指标侧边，执行下面两句
        var url_map_temp = "";
        var url_index_temp = url_index;

        if(level=='1'){
            url_map_temp = url_map_city;
        }else if(level=='2'){
            url_map_temp = url_map_bureau;
        }
        parent.freshMapContainer(url_map_temp);
        //if(level=='1')
        parent.freshIndexContainer(url_index_temp);
    }

    function toSchool(latn_id,bureau_no,bureau_name,school_id,x,y){
    	if(region_type==2){
            parent.global_current_flag = 3;
            parent.global_position.splice(2,1,bureau_name);
            parent.updatePosition(2);
            parent.global_entrance_type="school";
            parent.global_school_id = school_id;
            parent.global_bureau_id = bureau_no;
            parent.global_current_full_area_name = bureau_name;
            parent.global_current_area_name = bureau_name;
            parent.freshMapContainer(url_map_bureau);
            parent.freshIndexContainer(url_index);
    	}else if(region_type==3){
            parent.global_current_flag = 3;
            parent.global_pos_bus(school_id,x,y);
        }
    }
</script>