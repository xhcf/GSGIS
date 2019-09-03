/**
 * Created by admin on 2019/3/18.
 * 元素写法示例<input id="selectMonth" type="text" style="color:#ffffff; width:120px;height:28px;line-height:28px;"/>
 * elem_id 为 selectMonth,time 为 2019-08
 * 数据获取 $("#selectMonth").datebox("getValue");
 */

function datebox_month(elem_id,time){
    var db = $('#'+elem_id);

    db.datebox({
        onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层
            span.trigger('click'); //触发click事件弹出月份层
            //fix 1.3.x不选择日期点击其他地方隐藏在弹出日期框显示日期面板
            if (p.find('div.calendar-menu').is(':hidden')) p.find('div.calendar-menu').show();
            if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔
                tds = p.find('div.calendar-menu-month-inner td');
                tds.click(function (e) {
                    e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件
                    var year = /\d{4}/.exec(span.html())[0]//得到年份
                        , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1
                    db.datebox('hidePanel')//隐藏日期对象
                        .datebox('setValue', year + '-' + (month < 10 ? "0" + month : month)); //设置日期的值
                });
            }, 0);
            yearIpt.unbind();//解绑年份输入框中任何事件
        },
        parser: function (s) {
            if (!s) return new Date();
            var arr = s.split('-');
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
        },
        formatter: function (d) {
            return d.getFullYear() + '-' + ((d.getMonth() + 1) < 10 ? "0" + (d.getMonth() + 1) : (d.getMonth() + 1));
            /*getMonth返回的是0开始的，忘记了。。已修正*/
        },
        editable: false,
        change:function(){
            try{
                query();
            }catch(e){

            }
        }
    });

    var p = db.datebox('panel'), //日期选择对象
        tds = false, //日期选择对象中月份
        aToday = p.find('a.datebox-current'),
        yearIpt = p.find('input.calendar-menu-year'),//年份输入框
    //显示月份层的触发控件
        span = aToday.length ? p.find('div.calendar-title span') ://1.3.x版本
            p.find('span.calendar-text'); //1.4.x版本
    if (aToday.length) {//1.3.x版本，取消Today按钮的click事件，重新绑定新事件设置日期框为今天，防止弹出日期选择面板
        aToday.unbind('click').click(function () {
            var now = new Date();
            db.datebox('hidePanel').datebox('setValue', now.getFullYear() + '-' + ((now.getMonth() + 1) < 10 ? "0" + (now.getMonth() + 1) : (now.getMonth() + 1)));
        });
    } else {
        var dt = $.trim(time);//秒表
        var date = "";
        if(dt=="" || dt=="0" || dt=="1" || dt=="2"){
            dt = new Date();
            date = dt.getFullYear()+"-"+("0"+(dt.getMonth()+1)).slice(-2);
        }else
            date = dt;
        var date_arry = date.split("-");
        var year = date_arry[0];
        var mm = date_arry[1];
        db.datebox('hidePanel').datebox('setValue', year + '-' + mm);
    }
}
