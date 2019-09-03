<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<e:set var="datagrid_url">
    <e:url value="pages/telecom_Index/channel_sandtable/jsp/qd_market_action.jsp?eaction=qd_market" />
</e:set>
<html>
<head>
    <title></title>
    <script src='<e:url value="/resources/component/echarts_new/echarts/js/jquery-1.7.2.min.js"/>'></script>
    <c:resources type="easyui,app" style="b"/>
    <link href='<e:url value="/resources/themes/common/css/reset.css"/>' rel="stylesheet" type="text/css" media="all" />
    <link href='<e:url value="/pages/telecom_Index/sub_grid/css/viewPlane_table.css?version=1.0"/>' rel="stylesheet" type="text/css"
          media="all"/>
    <link href='<e:url value="/pages/telecom_Index/sandbox_leader/css/lead_tab.css?version=1.8.0" />'  rel="stylesheet" type="text/css"
          media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/big_tab_option.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <link href='<e:url value="/pages/telecom_Index/common/css/scroll_style_reset.css?version=New Date()" />'  rel="stylesheet" type="text/css" media="all">
    <style>
        .sub_box .big_table_title {padding-top:0px;margin-top:0px;}
        #excelBtn_dg,#pdfBtn_dg {display:none;}
        h4 {font-size:22px!important;}
        .datagrid-header, .datagrid-td-rownumber{background-color:transparent;}
        .datagrid-cell-rownumber {color:#fff;}
        .big_table_title {padding-top:18px!important;}
        .dialog-button {padding-top:0px;}
        .pagination-page-list {display:none;}

        /*隐藏下载*/
        #xlsxBtn_dg,.icon-download-excel-1,#downBtn_dg {display: none;}
    </style>
</head>
<body>
    <div class="sub_box grab_tab">
        <div style="height:98%;width:100%;margin:0.3% auto;" id="tab_div">
            <div class="big_table_title"><h4>异&nbsp;&nbsp;网&nbsp;&nbsp;网&nbsp;&nbsp;点&nbsp;&nbsp;信&nbsp;&nbsp;息&nbsp;&nbsp;导&nbsp;&nbsp;入</h4></div>
            <a id="but" href="javascript:void(0)" class="easyui-linkbutton" style="float:right; margin-top: -3%;margin-right: 3%"
               onclick="openUploadFileDialog()">导入数据</a>
            <div style="display: none;">渠道市场份额</div>
            <div class="gatagridbox" style="width: 96%; margin: 0px auto;overflow-x:hidden;overflow-y: scroll;">
                <c:datagrid id="dg" url="${datagrid_url}" download="false" style="width:100%;height:250px;" pagination="true" pageSize="20" pageList="[20,30,40,50]"
                            data-options="scrollbarSize:0"  onLoadSuccess="onLoadSuccess">
                    <thead>
                    <tr>
                        <th field="LATN_NAME" width="6%" align="center">地市</th>
                        <th field="BUREAU_NAME" width="10%" align="center">县局</th>
                        <th field="BRANCH_NAME" width="17%" align="center">支局</th>
                        <th field="GRID_NAME" width="18%" align="center">网格</th>
                        <th field="BUSINESS_NAME" width="8%" align="center">运营商</th>
                        <th field="CHANNEL_NAME" width="8%" align="center">厅店类型</th>
                        <th field="CHANNEL_COUNT" width="10%" align="center">厅店数量</th>
                        <th field="INPUT_TIME" width="15%" align="center">导入时间</th>
                        <th field="USER_NAME" width="8%" align="center">操作员</th>
                    </tr>
                    </thead>
                </c:datagrid>
            </div>
            <div id="dlg" class="easyui-dialog" style="width:600px;height:280px;padding:10px 20px"
                 closed="false" buttons="#dlg-buttons" title="资料上传管理" closable="false">
                <form id="uploadForm" action="/GSgis/excel_upload.e?type=2" method="post"
                      enctype="multipart/form-data">
                    <table>
                        <tr>
                            <td>模板下载:</td>
                            <td><a href="javascript:void(0)" class="easyui-linkbutton" onclick="downloadTemplate()">下载模板文件</a></td>
                        </tr>
                        <tr><td></td><td></td></tr>
                        <tr><td></td><td></td></tr>
                        <tr>
                            <td>上传资料:</td>
                            <td><input type="file" name="TemplateExcelFile"></td>
                        </tr>
                        <tr>
                            <td colspan="2" style="color:red;font-size:14px;">请下载模板文件后填写数据，填写的组织机构名称参考模板文件中的“合法组织机构名”</td>
                        </tr>
                    </table>
                </form>
            </div>

            <div id="dlg-buttons" style="width: 20px;height: 30px;margin: 0 auto;">
                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="uploadFile()">上传</a>
                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeDlg()">关闭</a>
            </div>
        </div>
    </div>
</body>
</html>
<script>
    $(function () {
        closeDlg();
        $(".gatagridbox").css({"max-height":$("#tab_div").height()-$(".big_table_title").height()-50});
    });
    function onLoadSuccess(data){
        if(!data.rows.length){
            $("#dg").datagrid("appendRow",{
                'LATN_NAME':'暂无数据'
            });
            $("#dg").datagrid("mergeCells",{
                index:0,
                field:'LATN_NAME',
                rowspan:1,
                colspan:9
            });
        }
    }
    function openUploadFileDialog() {
        $('#dlg').window('center');
        $('#dlg').dialog('open');
        $("#but").hide();
    }

    function downloadTemplate() {
        window.open('/GSgis/excel_download.e?type=2');
    }

    function closeDlg() {
        $('#dlg').dialog('close');
        $("input[name='TemplateExcelFile']").val("");
        $('#but').show();
    }
    function check() {
        var fileType = $("input[name='TemplateExcelFile']").val();

        //判断后缀是不是xlsx
        if (fileType != null && fileType != "") {
            var start = fileType.lastIndexOf(".") + 1;
            var length = fileType.length;
            var finalType = fileType.substring(start, length);
            if (finalType != "xlsx") {
                $.messager.alert('系统提示', '您上传的文件格式不符合要求！！', 'error');
                return false;
            }
            return true;
        }
    }
    function uploadFile() {
        var flag = check();
        if (!flag) return;
        $.messager.progress({
            icon: 'info',
            title: '上传进度提示',
            msg: '',
            text: '文件上传中',
            interval: '200'
        });
        var url="/GSgis/getSession.e";
        ref = setInterval(function () {
            var uploadInfo = "";
            $.post(url,null,function (data) {
                console.log(data);
                uploadInfo=data;

                $.messager.progress('close');
                //var uploadInfo = "${sessionScope.uploadInfo}";
                var text = "文件上传中";
                if (uploadInfo != null) {
                    text = uploadInfo;
                }
                $.messager.progress({
                    icon: 'info',
                    title: '上传进度提示',
                    msg: '',
                    text: text,
                    interval: '200'
                });
            });
        }, 2000);

        $("#uploadForm").form("submit", {
            success: function (result) {
                clearInterval(ref);
                var result = eval('(' + result + ')');
                if (result.msg != "导入成功") {
                    $.messager.progress('close');
                    $.messager.alert("系统提示", result.msg, 'error');
                } else {//成功
                    $.messager.progress('close');
                    $.messager.alert("系统提示", result.msg, 'info');
                    closeDlg();
                    var queryParams = $("#dg").datagrid('options').queryParams;
                    $("#dg").datagrid('reload',queryParams);
                }
            }
        });
    }
</script>