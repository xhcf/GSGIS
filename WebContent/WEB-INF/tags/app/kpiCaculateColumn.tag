<%@ tag body-content="scriptless"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%@ attribute name="id" required="true" %>              <e:description>组件ID</e:description>
<%@ attribute name="updateDatasetUiFunction" required="true" %>   <e:description>更新数据集方法</e:description>


<script type="text/javascript">
var ${id} = {
    currentAction:'add',
    currentEditFormulaId:"",
    currentDragColumn:undefined,
    currentEditColumnObj:{id:"",name:""},
    getCurDs:function(){
    	return StoreData.cubeId;
    },
    getColumnOldName:function(){
    	return $("#columnOldName_${id}").val();
    },
	open:function(){
		$("#caculateDialog_${id}").dialog('open').dialog('resize',{width:'600px',height:'444px',left:$(window).width()-1300});
	},
	reset:function(){
		$("#formulaArea_${id}").empty();
		$("#columnName_${id}").val("");
		$("#formulaComb_${id}").combobox("select",'-1');
		$("#columnOldName_${id}").val("");
	},
	init:function(){
		${id}.initFormulas();
	},
	initFormulas:function(){//初始化公式下拉列表
		var formulaActionUrl = appBase+"/pages/xbuilder/formulate/formulate_action.jsp?eaction=getFormulateList";
		$.post(formulaActionUrl,{},function(data){
			$("#formulaComb_${id}").combobox({
						onLoadSuccess:function(){
							if(${id}.currentAction=="add"){
								var dataArr = $("#formulaComb_${id}").combobox("getData");
								$("#formulaComb_${id}").combobox("select",dataArr[0].ID);
							}else{
								$("#formulaComb_${id}").combobox("select",${id}.currentEditFormulaId);
							}
						},
						onSelect:function(record){
							${id}.createFormulaInput(${id}.getSelectedFormula());
						}
			});
			$("#formulaComb_${id}").combobox('loadData',$.parseJSON($.trim(data)));
			
			 
		});
	},
	createFormulaInput:function(formulaStr){//根据公式生成输入区
			if(formulaStr==""){
				$("#formulaArea_${id}").empty();
			}else{
				var paramRange = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var tempChar,resultStr="",parmaArr = [],index = 0;
				var time = (new Date()).getTime();
				for(var i=0;i<formulaStr.length;i++){
					tempChar = formulaStr.charAt(i);
					if(paramRange.indexOf(tempChar+'')!=-1){
						resultStr += " <span name='param_"+tempChar+"' kpiId='' id='param_"+time+"_"+(index++)+"' class='parma_input'>&nbsp;</span> ";
						parmaArr.push(tempChar);
					}else{
						resultStr += " "+tempChar+" ";
					}
				}
				$("#formulaArea_${id}").html(resultStr);
				$.each(parmaArr,function(index,item){
					$('#param_'+time+"_"+index).droppable({
						onDragEnter:function(e,source){
							$(this).css('background','#eee');
						},
						onDragLeave: function(e,source){
							$(this).css('background','#fff');
						},
						onDrop: function(e,source){
							$(this).css('background','#fff');
							var currentDragItemType = getCurrentDragItemType();//获得当前拖拽项类型
							if((currentDragItemType == "kpi"||currentDragItemType=="mykpi")&&$(source).attr("node-id")==undefined){
								$("span[name='"+$(this).attr("name")+"']").text($(source).attr("desc"));
								$("span[name='"+$(this).attr("name")+"']").attr('kpiId',$(source).attr("key"));
								$("span[name='"+$(this).attr("name")+"']").attr('kpiColumn',$(source).attr("column"));
							}else{
								$.messager.alert("系统提示","当前拖拽项不可做为计算列参数使用！","error");
							}
						}
					});
				});
			}
	},
	getSelectedFormula:function(){//获取当前选中的公式表达式
		var formulaStr = $("#formulaComb_${id}").combobox("getText");
		if(formulaStr!="----请选择公式----"){
			formulaStr = formulaStr.toUpperCase();
			formulaStr=formulaStr.substring(formulaStr.lastIndexOf("】")+1);
		}else{
			formulaStr = "";
		}
		return formulaStr;
	},
	saveCaculateCol:function(flag){//保存计算列
		if(!${id}.validateCol()){
			return;
		}
		var formulaStr = ${id}.getSelectedFormula();
		var info = {
					reportId:StoreData.xid,
					datasourceId:'',
					formula:formulaStr,
					formulaid:$("#formulaComb_${id}").combobox("getValue"),
					name:$("#columnName_${id}").val(),
					paramList:[]
		}
		var checkRepeatMap = new Object();
		$("#formulaArea_${id}>span").each(function(index,item){
			if(checkRepeatMap[$(item).attr("name")]==undefined){
				info.paramList.push({
					name:$(item).attr("name").substring(6),
					value:$(item).attr("kpiId")
				});
				checkRepeatMap[$(item).attr("name")]="1";
			}
		});
		if(flag=="0"){//添加列
			crossTableService.addExtcolumn(info,function(data,exception){
				if(exception!=undefined){
					$.messager.alert("系统提示","保存计算列出错！<br/>"+exception,"error");
				}else{
					${id}.currentEditColumnObj.name=$("#columnName_${id}").val();
					${id}.currentEditColumnObj.id = data;
					//${id}.switchEnable(false);
					${id}.reset();//重置
					${id}.updateDatasetUi('add');
					$.messager.alert("系统提示","添加成功！","info");
					reloadMyKpiTab();
				}
			});
		}else{//修改列
			info.extcolumnid=${id}.currentEditColumnObj.id;
			crossTableService.editExtcolumn(info,function(data,exception){
				if(exception!=undefined){
					$.messager.alert("系统提示","修改计算列出错！<br/>"+exception,"error");
				}else{
					${id}.currentEditColumnObj.name=$("#columnName_${id}").val();
					reloadMyKpiTab();
					${id}.updateDatasetUi('edit');
					$("#columnOldName_${id}").val($("#columnName_${id}").val());
					$.messager.alert("系统提示","修改成功！","info");
				}
			});
		}
	},
	addCaculateCol:function(){//添加计算列
		${id}.saveCaculateCol('0');
	},
	editCaculateCol:function(){//编辑计算列
		${id}.saveCaculateCol('1');
	},
	removeCaculateCol:function(columnId){//删除计算列
	    ${id}.currentEditColumnObj.id=columnId;
	    var info = {extcolumnid:columnId};
		cn.com.easy.xbuilder.service.component.ColumnService.checkExtColRef(StoreData.xid,StoreData.curContainerId,StoreData.curComponentId,$.toJSON(info),function(data,exception){
			   if(data=="true"){
			  	   $.messager.alert("错误信息","该计算列已被其他组件使用，因此不能删除!","info");
			   }else{
			        var info = {reportId:StoreData.xid,extcolumnid:columnId};
					crossTableService.removeExtcolumn(info,function(data,exception){
						if(exception!=undefined){
							$.messager.alert("系统提示","删除计算列出错！<br/>"+exception,"error");
						}else{
							reloadMyKpiTab();
							${id}.updateDatasetUi('remove');
							if(${id}.currentEditColumnObj.id==columnId){//如果正在删除的列和正在编辑的列为同一列
								${id}.reset();
							}
						}
					});
			   }//end else
		});
	},
	updateDatasetUi:function(action){//更新ui
		${updateDatasetUiFunction}(action);
	},
	close:function(){//取消编辑
		$("#caculateDialog_${id}").dialog('close');
	},
	validateCol:function(){//校验计算列
		var columnName = $("#columnName_${id}").val();
		if(columnName == ""){
			$.messager.alert("系统提示","<br/>请输入计算列名称！","error");
			return false;
		}
		if($("#formulaComb_${id}").combobox('getValue')=="-1"||$("#formulaComb_${id}").combobox('getValue')==""){
			$.messager.alert("系统提示","<br/>请选择公式！","error");
			return false;
		}
		if (!columnName.match( /^[\u4E00-\u9FA5a-zA-Z]+[\u4E00-\u9FA5a-zA-Z0-9_]*$/)) {
			$.messager.alert("系统提示","计算列名必须以英文字母或汉字开头，可包含数字或下划线！","error");
			return false;
		}
		var keyWords = ["sum","count","where","and","or","as","insert","delete","update",
		                "select","truncate","varchar","number","blob","clob","date",
		                "number","varchar2","decimal","int","smallint","long","float",
		                "double","order","by","group","union","all","left","right","join",
		                "start","with","connect","create","drop","alter","distinct","case","when",
		                "min","max","avg","value","from","table","view","into","begin","then",
		                "end","grant","revoke","asc","desc","default","between"];
		for(var i=0;i<keyWords.length;i++){
			if(columnName.toLowerCase()==keyWords[i]){
				$.messager.alert("系统提示","计算列名不能为SQL关键字！","error");
				return false;
			}
		}
		var errMsg="";
		$("#formulaArea_${id}>span").each(function(index,item){
			if($.trim($(item).text())==""){
				errMsg ="参数不能为空!";
				return false;
			}
		});
		if(errMsg!=""){
			$.messager.alert("系统提示",errMsg,"error");
			return false;
		}
		if(${id}.getColumnOldName()!=$("#columnName_${id}").val()){
			var path = appBase+"/checkRepeatColumns.e";
			var data = $.ajax({url: path,type:"post",data:{report_id:StoreData.xid,report_sql_id:${id}.getCurDs(),columnName:$("#columnName_${id}").val()},cache: false,async:false}).responseText;
			if(data=="0"){
				$.messager.alert("系统提示","列名不能重复","error");
				return false;
			}
		}
		return true;
	},
	switchEnable:function(flag){
		if(flag){
			$("#columnName_${id}").removeAttr("readonly");
			$("#formulaComb_${id}").combobox("enable");
			$("#customFormulaBtn_${id}").linkbutton("enable");
			$("#columnName_${id}")[0].focus();
		}else{
			$("#columnName_${id}").attr("readonly","readonly");
			$("#formulaComb_${id}").combobox("disable");
			$("#customFormulaBtn_${id}").linkbutton("disable");
		}
	},
	restoreCaculateColumn:function(extcolumnid){//回显计算列
		var info = {reportId:StoreData.xid,extcolumnid:extcolumnid};
		crossTableService.getExtcolumn(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("系统提示","获取计算列信息出错！<br/>"+exception,"error");
			}else{
				data = $.parseJSON($.trim(data));
				$("#columnName_${id}").val(data.name);//回显列名
				$("#columnOldName_${id}").val(data.name);//记录下修改之前的名字
				${id}.currentEditFormulaId = data.formulaid;
				$("#formulaComb_${id}").combobox("select",data.formulaid);//回显自定义公式
				${id}.createFormulaInput(data.formula);//创建参数输入框
				${id}.currentEditColumnObj.id=data.id;
				${id}.currentEditColumnObj.name=data.name;
				var paramList = data.paramList;//回显参数列表
				 if(paramList!=null&&paramList!=undefined){
	            	 $.each(paramList,function(index,item){
	      				$("span[name='param_"+item.name+"']").text(gParamMap[item.value]);
	      				$("span[name='param_"+item.name+"']").attr('kpiId',item.value);
	      			 });
	             }
			}
		});
	}
	
};


//打开计算列对话框
function openCaculateDialog(){
	if(${id}.getCurDs()=='-1'||${id}.getCurDs()==undefined){
		$.messager.alert("系统提示","请在数据集中选择一个数据魔方！","error");
	}else{
		${id}.currentAction="add";
		$("#caculateDialog_${id}").panel({title: "新建计算列"});
		${id}.open();//打开
		${id}.init();//初始化
		${id}.reset();//重置
		//${id}.switchEnable(false);
	}
}

$(function(){
	$("#customFormulaDialog_${id}").dialog({buttons: [{
		text:'确定',
		handler:function(){
			addCustomFormula_${id}();
		}
	},{
		text:'取消',
		handler:function(){
			$("#customFormulaDialog_${id}").dialog("close");
		}
	}]});
});

//打开自定义公式对话框
function openCustomFormulaDialog_${id}(){
	$("#customFormulaDialog_${id}").dialog('open');
	$("#customFormula_${id}").val("");
	$("#customFormulaName_${id}").val("");
}

//添加自定义公式
function addCustomFormula_${id}(){
	var aformula = $.trim($("#customFormula_${id}").val());
	if(aformula==""){
		$.messager.alert("系统提示","公式不能为空!","info");
		return;
	}
	cn.com.easy.xbuilder.service.FormulateVaildata.formulateVerification(aformula,function(data,exception){
		if(data=="1"){
			var info = {};
			info.eaction="QUERY";
			info.aformula=aformula.toUpperCase();
			var postUrl = appBase+"/pages/xbuilder/formulate/formulate_action.jsp";
			$.post(postUrl,info,function(data){
				var tmp = $.trim(data);
				if(tmp>0){
					$.messager.alert("系统提示","表达式重复！","info");
				}else{
					var formulaActionUrl = appBase+"/pages/xbuilder/formulate/formulate_action.jsp?eaction=INSERT";
					$.post(formulaActionUrl,{afname:$("#customFormulaName_${id}").val(),aformula:aformula},function(data){
						var arr = $.trim(data).split("#");
						if(parseInt(arr[0])>0){
							${id}.initFormulas();
							setTimeout(function(){$("#formulaComb_${id}").combobox('select', arr[1]);},300);
							$("#customFormulaDialog_${id}").dialog('close');
						}else{
							$.messager.alert("信息","添加失败，表达式不正确！","info");
						}
					});
				}
			});
        }else{
        	$.messager.alert("信息","表达式不正确！","info");
        	return false;
        }
	});
}
//添加计算列
function addCaculateCol_${id}(){
	${id}.currentAction="add";
	${id}.switchEnable(true);
	${id}.reset();
}

//编辑计算列
function editCaculateCol(extcolumnid){
	${id}.currentAction="edit";
	$("#caculateDialog_${id}").panel({title: "修改计算列"});
	${id}.open();//打开
	${id}.init();//初始化
	${id}.reset();//重置
	${id}.switchEnable(true);
	${id}.switchEnable(true);
	${id}.restoreCaculateColumn(extcolumnid);//回显计算列
}

//删除计算列
function removeCaculateCol(extcolumnid,extcolumnName){
	${id}.currentEditColumnObj.id=extcolumnid;
	${id}.currentEditColumnObj.name=extcolumnName;
	${id}.removeCaculateCol(extcolumnid);
}

//确定按钮点击事件
function okBtnClick_${id}(){
	if($("#columnName_${id}").attr("readonly")!="readonly"){
		if(${id}.currentAction=="add"){
			${id}.addCaculateCol();
		}else if(${id}.currentAction=="edit"){
			${id}.editCaculateCol();
		}
	}
}
</script>
	<%-- <a href="javascript:void(0)" class="openKpi" data-options="" onclick="openCaculateDialog_${id}()" style="margin-left:3px;">计算列</a> --%>
	<!-- 添加计算列对话框 -->
	<div id="caculateDialog_${id}" class="easyui-dialog" title="计算列" data-options="closed:true,buttons:[{text:'确定',handler:okBtnClick_${id}},{text:'取消',handler:function(){${id}.close();}}]" style="width:750px;height:390px;padding:5px">
			<input id="columnName_${id}" style="width:140px;" placeholder="计算列名称" />
			<select class="easyui-combobox" id="formulaComb_${id}" data-options="valueField:'ID',textField:'VALUE',editable:false" style="width:180px;"></select>
			<a href="javascript:void(0)" id="customFormulaBtn_${id}" class="easyui-linkbutton" onclick="openCustomFormulaDialog_${id}()">自定义公式</a>
			<div style="width:570px;height:250px;border:solid 1px #ddd; margin:5px 0; padding:5px;" id="formulaArea_${id}"></div>
		    <span class="easyui-font-red">提示：请选择公式后，从右侧指标选择窗口拖入指标到横线处。</span>
	</div>

	<!-- 自定义公式对话框 -->
	<div id="customFormulaDialog_${id}" class="easyui-dialog" title="自定义公式" data-options="closed:true" style="width:400px;height:220px;padding:10px">
	    <div style="width:100%;height:100%;text-align: center">
			公式：<input type="text" id="customFormula_${id}" style="width:200px;"/><br/><br/>
			名称：<input type="text" id="customFormulaName_${id}" style="width:200px;"/>
	    </div>
	</div>
	
	<input type="hidden" id="columnOldName_${id}" /><!-- 记录修改前的列名 -->