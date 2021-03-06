<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<head>
    <link href='<e:url value="/resources/css/main.css"/>' rel="stylesheet" type="text/css"/>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/ieBrowser.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/kpi_index.js"/>' charset="utf-8"></script>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/leader_org_frame.css?version=1.1.1"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/leader_bureau_index.css?version=1.2.11"/>' rel="stylesheet" type="text/css" media="all" />
    <script src='<e:url value="/pages/telecom_Index/common/js/js_constant.js"/>' charset="utf-8"></script>
    <script src='<e:url value="/pages/telecom_Index/common/js/leader_condition_init.js?version=1.5"/>' charset="utf-8"></script>
    <title>光网实占</title>
    <c:resources type="easyui,app" style="b"/>
</head>
<body style="width:100%;border:0px;" class="g_target">
    <div class="qx_title"></div>
    <div class="search_choice_wrapper">
        <header>查询条件</header>
        <div class="searches1">

        </div>
        <header style="margin-top: 5px">汇总信息<span class="more_messages">更多</span></header>
        <div class="summary_imformation">
            <div><span id="cnt_name"></span><span id="bureau_cnt"></span>个</div>
        </div>
    </div>
    <div class="alpha_cont">
        <table id="index_table" class="index_table">
        </table>
    </div>
</body>
<script>
	var level_numFlag = '0';
    var region_type = '${param.region_type}';
    var region_type_str = "";
    var url4Query = '<e:url value="/pages/telecom_Index/common/sql/tabData_sandbox_leader.jsp" />';
    //var params = new Object();
    //params.eaction="index_province";
    var sub_width = $("#index_table").width();

    var value_range = "";//convertData.js中使用的参数 [60,45,30,0]

    var res = generic_kpi_index(parent.index_range_map["KPI_D_009"]);
    value_range = res[1];

    var province = function(params){
        $("#index_table").datagrid({
            url:url4Query,
            queryParams:params,
            fitColumns:false,
            sortName:'ORD',
            columns:[
                [
                	{	field:'index',title:'序号',width:sub_width*0.11, align: 'center',
	                	formatter:function(val,row,index){
	                		return index+1;
	                	}
                   	},
                    {
                        field:'AREA_DESC',title:'分公司',align:'center',halign:'center',width: sub_width*0.18,
                        formatter:function(value,rowData){
                            return "<span title='" + value + "'>" + value + "</span>";
                        }
                    },
                    {
                        field:'USE_RATE1',title:'端口占用率',align:'center',halign:'center',width: sub_width*0.29,sortable:true,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1){
                                 return num_formatter(value);
                             }else
                                 return "--";
                        }
                    },
                    {
                        field:'USE_PORT_CNT',title:'实占端口数',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    },
                    {
                        field:'PORT_ID_CNT',title:'总端口数',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    }
                ]],
            scrollbarSize:"8",
            onLoadSuccess:function (data) {
                var contains_province = false;
                for(var i = 0,l = data.rows.length;i<l;i++){
                    var d = data.rows[i];
                    if(d.AREA_NO=="999"){
                        $("#bureau_cnt").text(data.rows.length-1);
                        contains_province = true;
                        break;
                    }
                }
                if(!contains_province)
                    $("#bureau_cnt").text(data.rows.length);

                if(level_numFlag == '1'){
            		return;
            	}
            	var dataRows = data.rows;
            	//六个级别的指标
                var level_num = count_under_range(dataRows,value_range,0);
            	/*var bureau_elements = $("#choices li span");
            	for(var i = 0,l = bureau_elements.length;i<l;i++){
            		$(bureau_elements[i]).text(level_num[i]);
            	}*/
                try{
                    parent.refresh_range_cnt(level_num);
                }catch(e){

                }

            	level_numFlag = '1';
                //$("._num").text(data.rows.length-1);
            },onClickRow: function (index,row){
                //global_substation_sub = "";
                //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });
    }

    var city = function(params){
        $("#index_table").datagrid({
            url:url4Query,
            queryParams:params,
            fitColumns:false,
            columns:[
                [
                	{	field:'index',title:'序号',width:sub_width*0.11, align: 'center',
	                	formatter:function(val,row,index){
	                		return index+1;
	                	}
                   	},
                    {
                        field:'LATN_NAME',title:'分公司',align:'left',halign:'center',width: sub_width*0.13,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "' style=\"text-align:center;\">" + value + "</div>";
                        }
                    },
                    {
                        field:'AREA_DESC',title:'区县',align:'left',halign:'center',width: sub_width*0.14,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "'>" + value + "</div>";
                        }
                    },
                    {
                        field:'USE_RATE1',title:'占用率',align:'center',halign:'center',width: sub_width*0.19,sortable:true,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1){
                                 return num_formatter(value);
                             }else
                                 return "--";
                        }
                    },
                    {
                        field:'USE_PORT_CNT',title:'实占端口',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    },
                    {
                        field:'PORT_ID_CNT',title:'总端口',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    }
                ]],
            scrollbarSize:"8",
            onLoadSuccess:function (data) {
                $("#bureau_cnt").text(data.rows.length);
                //$("._num").text(data.rows.length-1);
                if(level_numFlag == '1'){
            		return;
            	}

            	var dataRows = data.rows;
            	//六个级别的指标
                var level_num = count_under_range(dataRows,value_range,0);

            	/*var bureau_elements = $("#choices li span");
            	for(var i = 0,l = bureau_elements.length;i<l;i++){
            		$(bureau_elements[i]).text(level_num[i]);
            	}*/
                parent.refresh_range_cnt(level_num);

            	level_numFlag = '1';
            },onClickRow: function (index,row){
                //global_substation_sub = "";
                //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });
    }

    var sub = function(params){
        parent.global_region_type = "sub";
        $("#index_table").datagrid({
            url:url4Query,
            queryParams:params,
            fitColumns:false,
            columns:[
                [
                	{	field:'index',title:'序号',width:sub_width*0.11, align: 'center',
	                	formatter:function(val,row,index){
	                		return index+1;
	                	}
                   	},
                    {
                        field:'LATN_NAME',title:'分公司',align:'left',halign:'center',width: sub_width*0.13,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "' style=\"text-align:center;\">" + value + "</div>";
                        }
                    },
                    {
                        field:'AREA_DESC',title:'支局',align:'left',halign:'center',width: sub_width*0.14,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "'><a href='javascript:void(0);' onclick='javascript:parent.inside("+rowData.LATN_ID+")'>" + value + "</a></div>";
                        }
                    },
                    {
                        field:'USE_RATE1',title:'占用率',align:'center',halign:'center',width: sub_width*0.19,sortable:true,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1){
                                 return num_formatter(value);
                             }else
                                 return "--";
                        }
                    },
                    {
                        field:'USE_PORT_CNT',title:'实占端口',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    },
                    {
                        field:'PORT_ID_CNT',title:'总端口',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    }
                ]],
            scrollbarSize:"8",
            onLoadSuccess:function (data) {
                $("#bureau_cnt").text(data.rows.length);
                //$("._num").text(data.rows.length-1);
                if(level_numFlag == '1'){
            		return;
            	}

            	var dataRows = data.rows;
            	//六个级别的指标
                var level_num = count_under_range(dataRows,value_range,0);

            	/*var bureau_elements = $("#choices li span");
            	for(var i = 0,l = bureau_elements.length;i<l;i++){
            		$(bureau_elements[i]).text(level_num[i]);
            	}*/
                parent.refresh_range_cnt(level_num);

            	level_numFlag = '0';
            },onClickRow: function (index,row){
                //global_substation_sub = "";
                //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });
    }

    var grid = function(params){
        parent.global_region_type = "grid";
        $("#index_table").datagrid({
            url:url4Query,
            queryParams:params,
            fitColumns:false,
            columns:[
                [
                	{	field:'index',title:'序号',width:sub_width*0.11, align: 'center',
	                	formatter:function(val,row,index){
	                		return index+1;
	                	}
                   	},
                    {
                        field:'LATN_NAME',title:'分公司',align:'left',halign:'center',width: sub_width*0.13,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "' style=\"text-align:center;\">" + value + "</div>";
                        }
                    },
                    {
                        field:'AREA_DESC',title:'网格',align:'left',halign:'center',width: sub_width*0.14,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "'><a href='javascript:void(0);' onclick='javascript:parent.inside("+rowData.LATN_ID+")'>" + value + "</a></div>";
                        }
                    },
                    {
                        field:'USE_RATE1',title:'占用率',align:'center',halign:'center',width: sub_width*0.19,sortable:true,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1){
                                 return num_formatter(value);
                             }else
                                 return "--";
                        }
                    },
                    {
                        field:'USE_PORT_CNT',title:'实占端口',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    },
                    {
                        field:'PORT_ID_CNT',title:'总端口',align:'center',halign:'center',width: sub_width*0.2,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    }
                ]],
            scrollbarSize:"8",
            onLoadSuccess:function (data) {
                $("#bureau_cnt").text(data.rows.length);
                //$("._num").text(data.rows.length-1);
                if(level_numFlag == '1'){
            		return;
            	}

            	var dataRows = data.rows;
            	//六个级别的指标
                var level_num = count_under_range(dataRows,value_range,0);

            	/*var bureau_elements = $("#choices li span");
            	for(var i = 0,l = bureau_elements.length;i<l;i++){
            		$(bureau_elements[i]).text(level_num[i]);
            	}*/
                parent.refresh_range_cnt(level_num);

            	level_numFlag = '0';
            },onClickRow: function (index,row){
                //global_substation_sub = "";
                //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });
    }

    var village = function(params){
        parent.global_region_type="village";
        $("#index_table").datagrid({
            url:url4Query,
            queryParams:params,
            fitColumns:false,
            sortName:'USE_RATE1',
            sortOrder:'desc',
            pagination:true,
            pageSize:500,
            pageList:[500],
            columns:[
                [
                	{	field:'index',title:'序号',width:sub_width*0.13, align: 'center',
	                	formatter:function(val,row,index){
	                		return index+1;
	                	}
                   	},
                    {
                        field:'LATN_NAME',title:'分公司',align:'left',halign:'center',width: sub_width*0.13,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "' style=\"text-align:center;\">" + value + "</div>";
                        }
                    },
                    {
                        field:'AREA_DESC',title:'小区',align:'left',halign:'center',width: sub_width*0.14,
                        formatter:function(value,rowData){
                            return "<div class='long_message' title='" + value + "'><a href='javascript:void(0);' onclick='javascript:parent.inside(\""+rowData.LATN_ID+"\")'>" + value + "</a></div>";
                        }
                    },
                    {
                        field:'USE_RATE1',title:'占用率',align:'center',halign:'center',width: sub_width*0.19,sortable:true,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1){
                                 return num_formatter(value);
                             }else
                                 return "--";
                        }
                    },
                    {
                        field:'USE_PORT_CNT',title:'实占端口',align:'center',halign:'center',width: sub_width*0.19,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    },
                    {
                        field:'PORT_ID_CNT',title:'总端口',align:'center',halign:'center',width: sub_width*0.19,
                        formatter:function(value,rowData){
                        	 if(value!=null&&value!=undefined&&value!=-1)
                                 return value;
                             else
                                 return "--";
                        }
                    }
                ]],
            scrollbarSize:"8",
            onLoadSuccess:function (data) {
                $(".datagrid-view").height($(".datagrid").height());
                $(".datagrid-body").height($(".datagrid").height() - $(".datagrid-header").height() - 4);


            },onClickRow: function (index,row){
                //global_substation_sub = "";
                //parent.clickToGridFromSub(row.UNION_ORG_CODE,row.BRANCH_NAME,this,row.ZOOM,row.GRID_NAME,row.STATION_ID);
            }
        });
    }

    var load_tab = "";

    var get_range_cnt = function(params){
        $.post(url4Query,params,function(data){
            data = $.parseJSON(data);
            if(level_numFlag==0){
                var datas = new Array();
                datas.push(data.GT_1);
                datas.push(data.RAG_2);
                datas.push(data.RAG_3);
                datas.push(data.RAG_4);
                datas.push(data.RAG_5);
                datas.push(data.LT_6);
                var user_level = '${sessionScope.UserInfo.LEVEL}';
                if(user_level==1 || user_level==2)
                    parent.refresh_range_cnt(datas);
                level_numFlag = '0';
            }

            $("#bureau_cnt").text(data.SUM_CNT);
        });
    }

    parent.get_range_cnt = get_range_cnt;

    function num_formatter(value){
        var value_str = value+"";
        if(value_str.indexOf(".")==-1)
            return "<span style='color: #fa8513'>" + value + ".00%</span>";
        if(value_str.substr(value_str.indexOf(".")+1).length==1)
            return "<span style='color: #fa8513'>" + (value+"0") + "%</span>";
        else
            return "<span style='color: #fa8513'>" + value + "%</span>";
    }

    function count_under_range(dataRows,value_range,count_level){
        //若干级别的指标
        var begin = 0;
        if(count_level==0)
            begin = 1;
        var level_num = arrayDiy(value_range.length);
        //计算若干级别的地市的量
        for(var i = begin,l = dataRows.length;i<l;i++){
            for(var j = 0,k = value_range.length;j<k;j++){
                var vr = value_range[j];
                if(dataRows[i].USE_RATE1 >= vr){
                    level_num[j] += 1;
                    break;
                }
            }
        }
        return level_num;
    }

    $(function(){
        try{
            //parent.refresh_range_cnt(level_num);
            parent.show_range_cnt();
        }catch(e){
        }
        var params = new Object();

        //按层级定义绑定的事件
        if(region_type==1){
            $(".qx_title").text("全省分公司端口占用率");
            $("#cnt_name").text("分公司数：");
            load_tab = province;
            params.eaction="index_fb_real_percent_province";
            $(".more_messages").on("click",function(){
                parent.load_list_view(2,1,'');
            });
            $(".search_entrance").hide();
            region_type_str = "city";
        }else if(region_type==2){
            $(".qx_title").text("县局端口占用率排名");
            $("#cnt_name").text("县局总数：");
            load_tab = city;
            params.eaction="index_fb_real_percent_bureau";
		        params.region_id = '${param.region_id}';
		        params.flag = parent.global_current_flag;
            $(".more_messages").on("click",function(){
                parent.load_list_view('2', '2', '${param.city_id}');
            });
            $(".search_entrance").hide();
            region_type_str = "bureau";
        }else if(region_type==3){
            $(".search_name").attr("placeholder","请输入支局名称关键字");
            $(".qx_title").text("支局端口占用率排名");
            $("#cnt_name").text("支局总数：");
            load_tab = sub;
            params.eaction="index_fb_real_percent_sub";
            var region_id = '${param.region_id}';
            if(region_id==undefined || region_id==""){
                params.region_id = parent.global_position[2];
            }else{
                params.region_id = region_id;
            }
            params.flag = parent.global_current_flag;
            params.city_id = parent.global_current_city_id;
            $(".more_messages").on("click",function(){
                parent.load_list_view(2,3,'');
            });
            $(".search_entrance").show();
            region_type_str = "sub";
        }else if(region_type==4){
            $(".search_name").attr("placeholder","请输入网格名称关键字");
            $(".qx_title").text("网格端口占用率排名");
            $("#cnt_name").text("网格总数：");
            load_tab = grid;
            params.eaction="index_fb_real_percent_grid";
            var region_id = '${param.region_id}';
            if(region_id==undefined || region_id==""){
                params.region_id = parent.global_position[2];
            }else{
                params.region_id = region_id;
            }
            params.flag = parent.global_current_flag;
            params.city_id = parent.global_current_city_id;
            $(".more_messages").on("click",function(){
                parent.load_list_view(2,4,'');
            });
            $(".search_entrance").show();
            region_type_str = "grid";
        }else if(region_type==5){
            $(".search_name").attr("placeholder","请输入小区名称关键字");
            $(".qx_title").text("小区端口占用率排名");
            $("#cnt_name").text("小区总数：");
            load_tab = village;
            params.eaction="index_fb_real_percent_village_limited";
            var region_id = '${param.region_id}';
            if(region_id==undefined || region_id==""){
                params.region_id = parent.global_position[2];
            }else{
                params.region_id = region_id;
            }
            params.flag = parent.global_current_flag;
            params.city_id = parent.global_current_city_id;
            $(".more_messages").on("click",function(){
                parent.load_list_view(2,6,'');
            });
            $(".search_entrance").show();
            region_type_str = "village";
        }
        $("#index_table").height($("body").height()-$(".qx_title").height() - $(".search_choice_wrapper").height() -20);
        parent.load_tab = load_tab;

        load_tab(params);

        if(region_type==5){
            var temp = params.eaction;
            params.eaction="index_village_real_percent_cnt";
            get_range_cnt(params);
            params.eaction = temp;
        }
        $("#search_btn").unbind();
        $("#search_btn").bind("click",function(){
            var name = $("input[name='search_name']").val();
            name = $.trim(name);
            params.name = name;
            load_tab(params);
            parent.global_search_text = name;
            parent.refresh_map(region_type_str);
            if(region_type==5){
                var temp = params.eaction;
                params.eaction="index_village_real_percent_cnt";
                get_range_cnt(params);
                params.eaction = temp;
            }
        });
    });
</script>