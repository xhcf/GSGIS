<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<html>
<head>
  <title></title>
  <c:resources type="easyui" />
  <script>
    var s1 = new Date().getTime();
    var villDkdPage = 0;

    $(document).ready(function(){
      var flag = true;
      //鼠标滑轮滚动事件的处理

      var scrollFunc=function(e){
        var s2 = new Date().getTime();
        console.log(s2);
        if(s2-s1<500) return;//控制滚轮滑动翻页的时间差
        var direct=0;
        e=e || window.event;
        if(e.wheelDelta){//IE/Opera/Chrome
          if(flag){
            s1 = new Date().getTime();
            pageTurring(e.wheelDelta);
          }else{
            flag = true;
          }
        }else if(e.detail){//Firefox
          s1 = new Date().getTime();
          pagepageTurringFirefox(e.detail);

        }
        // ScrollText(direct);
      };

      //注册事件
      if(document.addEventListener){
        document.addEventListener('DOMMouseScroll',scrollFunc,false);
      }
      window.onmousewheel=document.onmousewheel=scrollFunc;//IE/Opera/Chrome
    });

    //其他浏览器翻页，根据参数的进行翻页(负数为下一页，)
    function pageTurring(e) {
      var begin_scroll_village = "";

      flag = false;
      var grid = $('#dgairbox');
      var options = grid.datagrid('getPager').data("pagination").options;
      var pageNum = options.pageNumber;//当前页数
      var total = options.total;
      var max = Math.ceil(total / options.pageSize);

      if (e < 0) {
        var viewH = $(".datagrid-body").height();
        var contentH = $(".datagrid-body").get(0).scrollHeight;
        var scrollTop = $(".datagrid-body").scrollTop();
        //alert(scrollTop / (contentH - viewH));

        if (new Date().getTime() - begin_scroll_village > 500 && scrollTop / (contentH - viewH) <= 0.05) {
          pageTurring(e.wheelDelta);

          begin_scroll_village = new Date().getTime();

          $('#dgairbox').datagrid('gotoPage', {
            page: pageNum + 1 > max ? 1 : pageNum + 1,
            callback: function (page) {
              // console.log(page);
            }
          });
        }
      } else if (e > 0) {
        var viewH = $(".datagrid-body").height();
        var contentH = $(".datagrid-body").get(0).scrollHeight;
        var scrollTop = $(".datagrid-body").scrollTop();
        //alert(scrollTop / (contentH - viewH));

        if (new Date().getTime() - begin_scroll_village > 500 && scrollTop / (contentH - viewH) >= 0.95) {
          pageTurring(e.wheelDelta);

          begin_scroll_village = new Date().getTime();

          $('#dgairbox').datagrid('gotoPage', {
            page: pageNum + 1 > max ? 1 : pageNum + 1,
            callback: function (page) {
              // console.log(page);
            }
          });
        }
      }
    }


  </script>
</head>
<body>
  <c:datagrid id="dgairbox" url="pages/telecom_Index/tab_village_summary/data_test.jsp?eaction=test_sql" pageSize="15" rownumbers="false" style="width:800px;height:300px;">
    <thead>
      <tr>
        <th field="LATN_ID" halign="center" align='center' >aaaa</th>
        <th field="KD_HU_COUNT" halign="center" align='center' >aaaa</th>
        <th field="H_USE_CNT" halign="center" align='center' >aaaa</th>
      </tr>
    </thead>
  </c:datagrid>
</body>
</html>
