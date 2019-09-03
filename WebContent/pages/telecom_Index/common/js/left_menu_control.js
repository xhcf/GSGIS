/**
 * Created by admin on 2017/7/12.
 */
//左侧工具栏 显示\隐藏
$(function(){
    $("#hide").click(function(){
        $("#tools").hide();
        $(".tools_n").height(28);
        $("#hide").hide();
        $("#show").show();
    });
    $("#show").click(function(){
        $("#tools").show();
        $(".tools_n").height("98%");
        $("#show").hide();
        $("#hide").show();
    });
});