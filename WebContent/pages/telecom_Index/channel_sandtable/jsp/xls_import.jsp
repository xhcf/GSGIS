<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="0">
    <title>文件上传下载</title>
    <e:script value="/resources/layer/layer.js"/>
    <script>

        $(function () {
            openUploadFileDialog();
        });

        function openUploadFileDialog() {
            $('#dlg').dialog('open');
            $("#but").hide();
            $('#dlg').window('center');
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
                    }

                }
            });
        }

    </script>
    <style>
        .align-center{

            width: 250px;
            height: 30px;
            position:absolute;
            left:50%;    /* 定位父级的50% */
            top:50%;
            transform: translate(-50%,-50%); /*自己的50% */
        }

    </style>
</head>
<body>


<a id="but" href="javascript:void(0)" class="easyui-linkbutton align-center"  plain="true"
   onclick="openUploadFileDialog()"><span style="font-size: 20px;">用模版批量导入数据</span></a>


<div id="dlg" class="easyui-dialog" style="width:600px;height:280px;padding:10px 20px"
     closed="false" buttons="#dlg-buttons" title="资料上传管理" closable="false">
    <form id="uploadForm" action="/GSgis/excel_upload.e?type=2" method="post"
          enctype="multipart/form-data">
        <table>

            <tr><td>地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;域:</td>
                <td colspan="2">
                    <e:if condition="${sessionScope.UserInfo.AREA_NAME ne null} ">
                        ${sessionScope.UserInfo.AREA_NAME}
                    </e:if>
                    <e:if condition="${sessionScope.UserInfo.CITY_NAME ne null} ">
                        -&gt; ${sessionScope.UserInfo.CITY_NAME}
                    </e:if>
                    <e:if condition="${sessionScope.UserInfo.SUB_NAME ne null} ">
                        -&gt;${sessionScope.UserInfo.SUB_NAME}
                    </e:if>
                    <e:if condition="${sessionScope.UserInfo.GRID_NAME ne null} ">
                        -&gt;${sessionScope.UserInfo.GRID_NAME}
                    </e:if>
                </td>

            </tr>
            <tr><td></td><td></td></tr>
            <tr><td></td><td></td></tr>
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
        </table>

    </form>

</div>

<div id="dlg-buttons" style="width: 20px;height: 30px;margin: 0 auto;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="uploadFile()">上传</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
       onclick="closeDlg()">关闭</a>
</div>

</body>
</html>
