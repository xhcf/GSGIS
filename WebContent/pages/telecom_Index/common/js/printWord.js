/**
 * Created by admin on 2017/5/25.
 */

var tId = null;
function printWord(word,jqDom){
    var index = 0;
    var length = word.length;
    jqDom.html('');
    clearInterval(tId);
    tId=setInterval(function(){
        jqDom.append(word.charAt(index));
        if(index++ === length){
            clearInterval(tId);
        }
    },100);
}

//定义一个全局变量
var tId1 = null;
function printWord1(word,jqDom){
    var index = 0;
    var length = word.length;
    //清空元素
    jqDom.html('');
    //停止由于多次鼠标点击而未完成的上几次的setInterval方法
    clearInterval(tId1);
    tId1=setInterval(function(){
        jqDom.append(word.charAt(index));
        if(index++ === length){
            clearInterval(tId1);
        }
    },100);
}
//重新定义一个全局变量
var tId2 = null;
function printWord2(word,jqDom){
    var index = 0;
    var length = word.length;
    jqDom.html('');
    clearInterval(tId2);
    tId2=setInterval(function(){
        jqDom.append(word.charAt(index));
        if(index++ === length){
            clearInterval(tId2);
        }
    },100);
}