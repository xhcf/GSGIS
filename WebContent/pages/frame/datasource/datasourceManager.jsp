<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>扩展数据源管理</title>
<c:resources type="easyui" style='${ThemeStyle }'/>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<script type="text/javascript">

$(function() {
	$('#dlg').dialog({
		title : '新增扩展数据源',
		resizable : false,
		width : 1000,
		height : 470,
		modal : true,
		closed : true,
		buttons : [ {
			text : '保存',
			handler : saveDs
		}, {
			text : '关闭',
			handler : function() {
				$('#dlg').dialog('close');
			}
		}]
	});  
	
	$('#editdlg').dialog({
		title : '修改扩展数据源',
		resizable : false,
		width : 1000,
		height : 500,
		modal : true,
		closed : true,
		buttons : [ {
			text : '保存',
			handler : updateDs
		} , {
			text : '关闭',
			handler : function() {
				$('#editdlg').dialog('close');
			}
		} ]
	}); 
	
	$("#ADD_DB_TYPE").combobox({
		onChange: function (newValue, oldValue) {
			var driver = getDriver(newValue);
			$('#ADD_DRIVER_CLASS_NAME').combobox('setValue', driver);
		}
	});
	
	$("#EDIT_DB_TYPE").combobox({
		onChange: function (newValue, oldValue) {
			var driver = getDriver(newValue);
			$('#EDIT_DRIVER_CLASS_NAME').combobox('setValue', driver);
		}
	});
	
});
function getDriver(dbType){
	var driver = "";
	if(dbType == 'oracle'){
		driver = "oracle.jdbc.driver.OracleDriver";
	} else if(dbType == 'mysql'){
		driver = "com.mysql.jdbc.Driver";
	} else if(dbType == 'xcloud'){
		driver = "com.bonc.xcloud.jdbc.XCloudDriver";
	} else if(dbType == 'db2'){
		driver = "com.ibm.db2.jcc.DB2Driver";
	} else if(dbType == 'postgre'){
		driver = "org.postgresql.Driver";
	} else if(dbType == 'hive'){
		driver = "org.apache.hadoop.hive.jdbc.HiveDriver";
	}
	return driver;
}

function formatStatus(value, rowData, rowIndex) {
	if(value == '1'){
		return '正常';
	} else if(value == '0'){
		return '停用';
	} else {
		return value;
	}
}
function formatOper(value, rowData, rowIndex) {
	var res = '';
	if(rowData.STATUS == 1){
		res += '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="getDataS(\'' + rowData.DS_NAME + '\')"><i class="fa fa-edit"></i></a>';
		res += '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="delDataS(\'' + rowData.DS_NAME + '\' , \'0\')"><i class="fa fa-hand-paper-o"></i></a>';
	} else {
		res += '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="delDataS(\'' + rowData.DS_NAME + '\' , \'1\')"><i class="fa fa-reply"></i></a>';
	}
	return res;
}
function doQuery() {
	var params = {};
	params.userName = $.trim($('#userName').val()==""?null:$('#userName').val());
	params.dsType = $.trim($('#dsType').val()=="all"?null:$('#dsType').val());
	$('#dataS').datagrid('options').queryParams = params;
	$('#dataS').datagrid('reload');
}
function saveDs() {
	if ($('#addForm').form('validate')) {
		var queryParam = $('#addForm').serialize();
		var actionUrl = '<e:url value="extDatasource/insertDB.e"/>';
		$.post(actionUrl, queryParam, function(data) {
			if ($.trim(data) == '1') {
				$.messager.alert("信息", "添加扩展数据源成功！", "info");
				$('#dlg').dialog("close");
				$('#dataS').datagrid('reload');
			} else if ($.trim(data) == '2') {
				$.messager.alert("信息", "数据源验证失败！", "error");
			} else {
				$.messager.alert("信息", "添加扩展数据源失败！", "error");
			}
		});
	}
}
function addEXTDataSource(){
	$('#dlg').dialog("open");
}

function delDataS(DS_NAME , status){
	$.messager.confirm('确认信息','确认停用？',function(r){  
		if(r){
			var info = {};
			info.DS_NAME = DS_NAME;
			info.status = status;
			$.post(appBase+"/extDatasource/deleteDS.e",info,function(data){
				if($.trim(data) == '1'){
					$.messager.alert("提示信息","操作成功","info");
					$('#dataS').datagrid('reload');
				}else{
					$.messager.alert("提示信息","操作失败","info");
				}
			});
		}
	});
}

function getDataS(dsName){
	$.post(appBase+"/extDatasource/queryDB.e",{dsName : dsName},function(data){
		
		var jsondata = eval('(' + data + ')');
		$("#EDIT_DS_NAME_TXT").html(jsondata[0].DS_NAME);
		$("#EDIT_DS_NAME").val(jsondata[0].DS_NAME);
		$("#EDIT_DS_CN_NAME").val(jsondata[0].DS_CN_NAME);
		$("#EDIT_URL").val(jsondata[0].URL);
		$('#EDIT_USER_NAME').val(jsondata[0].USER_NAME);
		$('#EDIT_PASSWORD').val(jsondata[0].PASSWORD);
		$("#EDIT_INITIAL_SIZE").val(jsondata[0].INITIAL_SIZE);
		$("#EDIT_MIN_IDLE").val(jsondata[0].MIN_IDLE);
		$("#EDIT_MAX_IDLE").val(jsondata[0].MAX_IDLE);
		$('#EDIT_MAX_ACTIVE').val(jsondata[0].MAX_ACTIVE);
		$("#EDIT_MAX_WAIT").val(jsondata[0].MAX_WAIT);
		$("#EDIT_REMOVE_ABANDONED").val(jsondata[0].REMOVE_ABANDONED);
		$("#EDIT_REMOVE_ABANDONED_TIMEOUT").val(jsondata[0].REMOVE_ABANDONED_TIMEOUT);
		$('#EDIT_TIME_BWT_EVN_MILLIS').val(jsondata[0].TIME_BWT_EVN_MILLIS);
		$('#EDIT_VALIDATION_QUERY').val(jsondata[0].VALIDATION_QUERY);
		
		$("#EDIT_DS_TYPE").combobox('setValue',jsondata[0].DS_TYPE);
		$("#EDIT_DB_TYPE").combobox('setValue',jsondata[0].DB_TYPE);
		$("#EDIT_DRIVER_CLASS_NAME").combobox('setValue',jsondata[0].DRIVER_CLASS_NAME);
		$("#EDIT_TEST_WHILE_IDLE").combobox('setValue',jsondata[0].TEST_WHILE_IDLE);
		
		$('#editdlg').dialog("open");
	});
}


function updateDs() {
	if ($('#editForm').form('validate')) {
		var queryParam = $('#editForm').serialize();
		var actionUrl = '<e:url value="extDatasource/updateDB.e"/>';
		$.post(actionUrl, queryParam, function(data) {
			if ($.trim(data) == '1') {
				$.messager.alert("信息", "修改成功！", "info");
				$('#editdlg').dialog("close");
				$('#dataS').datagrid("reload");
			} else if ($.trim(data) == '2') {
				$.messager.alert("信息", "数据源验证失败！", "info");
			} else {
				$.messager.alert("信息", "修改失败！", "error");
			}
		});
	}
}
</script>
</head>
<body>
<div id="tbar" class="newSearchA">
<h2>扩展数据源管理</h2>
<div class="search-area">
	<tr align="right">
		<th>用户名：</th>
		<td><input type="text" style="width: 100px" id="userName" name="userName" /></td>
		<th>数据源连接类型：</th>
		<td><select id="dsType" name="dsType"><option value="">全部</option><option value="dbcp">dbcp</option><option value="c3p0">c3p0</option></select></td>
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green" onclick="addEXTDataSource();">新增</a>
	</tr>
</div>
</div>
<c:datagrid url="extDatasource/queryDB.e" id="dataS" fit="true" nowrap="false" border="false" pagination="false" toolbar="#tbar" >
	<thead>
		<tr>
			<th field="DS_CN_NAME" width="70" align="left">数据源<br>中文名称</th>
			<th field="DS_NAME" width="60" align="left">数据源名称</th>
			<th field="DS_TYPE" width="30" align="center">数据源<br>连接类型</th>
			<th field="DRIVER_CLASS_NAME" width="120" align="left">驱动类名</th>
			<th field="USER_NAME" width="50" align="left">用户名</th>
			<th field="STATUS" width="30" align="center" formatter="formatStatus">状态</th>
			<th field="INITIAL_SIZE" align="center">初始化<br>连接数</th>
			<th field="CREATE_TIME" width="80" align="center" formatter="formatDAT_dataS">创建时间</th>
			<th field="CREATE_USER" width="40" align="center">创建人</th>
			<th field="oper" align="center" width="40" formatter="formatOper">操作</th>
		</tr>
	</thead>
</c:datagrid>


<div id="dlg">
<form id="addForm">
	<table id="indlg" class="windowsTable">
		<tr>
			<th>数据源中文名称：</th>
			<td><input class='easyui-validatebox' id="ADD_DS_CN_NAME" name='ADD_DS_CN_NAME' required /></td>
			<th>数据源英文名称：</th>
			<td><input class='easyui-validatebox' id="ADD_DS_NAME" name='ADD_DS_NAME' required /></td>
		</tr>
		<tr>
			<th>数据库类型：</th>
			<td><select class='easyui-combobox' id="ADD_DB_TYPE" name='ADD_DB_TYPE' editable="false" required>
				<option value="oracle">oracle</option>
				<option value="mysql">mysql</option>
				<option value="xcloud">xcloud</option>
				<option value="db2">db2</option>
				<option value="postgre">postgre</option>
				<option value="hive">hive</option>
				</select></td>
			<th>驱动包名：</th>
			<td><select class="easyui-combobox" id="ADD_DRIVER_CLASS_NAME" name='ADD_DRIVER_CLASS_NAME' editable="false" required>
				<option value="oracle.jdbc.driver.OracleDriver">oracle.jdbc.driver.OracleDriver</option>
				<option value="com.mysql.jdbc.Driver">com.mysql.jdbc.Driver</option>
				<option value="com.bonc.xcloud.jdbc.XCloudDriver">com.bonc.xcloud.jdbc.XCloudDriver</option>
				<option value="com.ibm.db2.jcc.DB2Driver">com.ibm.db2.jcc.DB2Driver</option>
				<option value="org.postgresql.Driver">org.postgresql.Driver</option>
				<option value="org.apache.hadoop.hive.jdbc.HiveDriver">org.apache.hadoop.hive.jdbc.HiveDriver</option>
				</select></td>
		</tr>
		<tr>
			<th>数据源连接类型：</th>
			<td><select class='easyui-combobox' id="ADD_DS_TYPE" name='ADD_DS_TYPE' editable="false" required>
				<option value="dbcp">dbcp</option>
				<option value="c3p0">c3p0</option>
				</select></td>
			<th>URL：</th>
			<td><input class='easyui-validatebox'   id="ADD_URL" name='ADD_URL' required/></td>
		</tr>
		<tr>
			<th>用户名：</th>
			<td><input id="ADD_USER_NAME" type="text" class='easyui-validatebox' name='ADD_USER_NAME'  required  /></td>
			<th>密码：</th>
			<td><input id="ADD_PASSWORD" type="password" class='easyui-validatebox'  name='ADD_PASSWORD' required  /></td>
		</tr>
		<tr>
			<th>初始化连接数：</th>
			<td><input id="ADD_INITIAL_SIZE" name="ADD_INITIAL_SIZE" type="text" class="easyui-validatebox" value="10" required  />
			<th>最小空闲连接数：</th>
			<td><input id="ADD_MIN_IDLE" name="ADD_MIN_IDLE"  type="text" class="easyui-validatebox" value="5" required  />
		</tr>
		<tr>
			<th>最大空闲连接数：</th>
			<td><input id="ADD_MAX_IDLE" name="ADD_MAX_IDLE" type="text" class="easyui-validatebox" value="50" required  />
			<th>最大连接数：</th>
			<td><input id="ADD_MAX_ACTIVE" name="ADD_MAX_ACTIVE"  type="text" class="easyui-validatebox" value="50" required />
		</tr>
		<tr>
			<th>最大等待时间，毫秒：</th>
			<td><input id="ADD_MAX_WAIT" name="ADD_MAX_WAIT" type="text" class="easyui-validatebox" value="600000" required  />
			<th>是否自动回收超时连接：</th>
			<td><select id="ADD_REMOVE_ABANDONED" name="ADD_REMOVE_ABANDONED" type="text"  class='easyui-combobox' editable="false" required>
				 <option value="true">true</option><option value="false">false</option></select>
			</td>
		</tr>
		<tr>
			<th>超时时间，秒：</th>
			<td><input id="ADD_REMOVE_ABANDONED_TIMEOUT" name="ADD_REMOVE_ABANDONED_TIMEOUT" type="text" class="easyui-validatebox" value="300" required  />
			<th>验证SQL间隔时间：</th>
			<td><input id="ADD_TIME_BWT_EVN_MILLIS" name="ADD_TIME_BWT_EVN_MILLIS" type="text" class="easyui-validatebox" value="3600000" required  />
		</tr>
		<tr>
			<th>testWhileIdle：</th>
			<td><select id="ADD_TEST_WHILE_IDLE" name="ADD_TEST_WHILE_IDLE" type="text" class='easyui-combobox' editable="false" required>
				 <option value="true">true</option><option value="false">false</option></select>
			</td>
			<th>validationQuery：</th>
			<td><input id="ADD_VALIDATION_QUERY" name="ADD_VALIDATION_QUERY" type="text" class="easyui-validatebox" value="select 1 from dual" required />
		</tr>
	</table>
</form>
</div>	

<div id="editdlg">
<form id="editForm">
	<table id="indlg" class="windowsTable">
		<input type="hidden" id="EDIT_DS_NAME" name="EDIT_DS_NAME"/>
		<tr>
			<th>数据源英文名称：</th>
			<td id="EDIT_DS_NAME_TXT"></td>
			<th>数据源中文名称：</th>
			<td><input class='easyui-validatebox' id="EDIT_DS_CN_NAME" name='EDIT_DS_CN_NAME' required /></td>
		</tr>
		<tr>
			<th>数据库类型：</th>
			<td><select class='easyui-combobox' id="EDIT_DB_TYPE" name='EDIT_DB_TYPE' editable="false" required>
				<option value="oracle">oracle</option>
				<option value="mysql">mysql</option>
				<option value="xcloud">xcloud</option>
				<option value="db2">db2</option>
				<option value="postgre">postgre</option>
				<option value="hive">hive</option>
				</select></td>
			<th>驱动包名：</th>
			<td><select class='easyui-combobox' id="EDIT_DRIVER_CLASS_NAME" name='EDIT_DRIVER_CLASS_NAME' editable="false" required>
				<option value="oracle.jdbc.driver.OracleDriver">oracle.jdbc.driver.OracleDriver</option>
				<option value="com.mysql.jdbc.Driver">com.mysql.jdbc.Driver</option>
				<option value="com.bonc.xcloud.jdbc.XCloudDriver">com.bonc.xcloud.jdbc.XCloudDriver</option>
				<option value="com.ibm.db2.jcc.DB2Driver">com.ibm.db2.jcc.DB2Driver</option>
				<option value="org.postgresql.Driver">org.postgresql.Driver</option>
				<option value="org.apache.hadoop.hive.jdbc.HiveDriver">org.apache.hadoop.hive.jdbc.HiveDriver</option>
				</select></td>
		</tr>
		<tr>
			<th>数据源连接类型：</th>
			<td><select class='easyui-combobox' id="EDIT_DS_TYPE" name='EDIT_DS_TYPE' editable="false" required>
				<option value="dbcp">dbcp</option>
				<option value="c3p0">c3p0</option>
				</select></td>
			<th>URL：</th>
			<td><input class='easyui-validatebox'   id="EDIT_URL" name='EDIT_URL' required/></td>
		</tr>
		<tr>
			<th>用户名：</th>
			<td><input id="EDIT_USER_NAME" type="text" class='easyui-validatebox' name='EDIT_USER_NAME'  required  /></td>
			<th>密码：</th>
			<td><input id="EDIT_PASSWORD" type="password" class='easyui-validatebox'  name='EDIT_PASSWORD' required  /></td>
		</tr>
		<tr>
			<th>初始化连接数：</th>
			<td><input id="EDIT_INITIAL_SIZE" name="EDIT_INITIAL_SIZE" type="text" class="easyui-validatebox" required  />
			<th>最小空闲连接数：</th>
			<td><input id="EDIT_MIN_IDLE" name="EDIT_MIN_IDLE"  type="text" class="easyui-validatebox" required  />
		</tr>
		<tr>
			<th>最大空闲连接数：</th>
			<td><input id="EDIT_MAX_IDLE" name="EDIT_MAX_IDLE" type="text" class="easyui-validatebox" required  />
			<th>最大连接数：</th>
			<td><input id="EDIT_MAX_ACTIVE" name="EDIT_MAX_ACTIVE"  type="text" class="easyui-validatebox" required />
		</tr>
		<tr>
			<th>最大等待时间，毫秒：</th>
			<td><input id="EDIT_MAX_WAIT" name="EDIT_MAX_WAIT" type="text" class="easyui-validatebox" required  />
			<th>是否自动回收超时连接：</th>
			<td><select id="EDIT_REMOVE_ABANDONED" name="EDIT_REMOVE_ABANDONED" type="text"  class='easyui-combobox' editable="false" required>
				 <option value="true">true</option><option value="false">false</option></select>
			</td>
		</tr>
		<tr>
			<th>超时时间，秒：</th>
			<td><input id="EDIT_REMOVE_ABANDONED_TIMEOUT" name="EDIT_REMOVE_ABANDONED_TIMEOUT" type="text" class="easyui-validatebox" required  />
			<th>验证SQL间隔时间：</th>
			<td><input id="EDIT_TIME_BWT_EVN_MILLIS" name="EDIT_TIME_BWT_EVN_MILLIS" type="text" class="easyui-validatebox" required  />
		</tr>
		<tr>
			<th>testWhileIdle：</th>
			<td><select id="EDIT_TEST_WHILE_IDLE" name="EDIT_TEST_WHILE_IDLE" type="text" class='easyui-combobox' editable="false" required>
				 <option value="true">true</option><option value="false">false</option></select>
			</td>
			<th>validationQuery：</th>
			<td><input id="EDIT_VALIDATION_QUERY" name="EDIT_VALIDATION_QUERY" type="text" class="easyui-validatebox" required />
		</tr>
	</table>
</form>
</div>	
	
</body>

</html>