function doExcel(){
    debugger;
    window.download_excel_list_hide();
}
function openDownLoadPop(){
    var expPageUrl = appBase+'/pages/frame/download/exportInfo.jsp';
    layer.open({
        title: ['下载管理', 'font-size:18px;text-align:center;'],
        type: 2,
        shade: 0,
        maxmin: false, //开启最大化最小化按钮
        area: [800,500],
        content: expPageUrl,
        skin: 'vill_dkd_div',
        cancel: function (index) {
        }
    });
}