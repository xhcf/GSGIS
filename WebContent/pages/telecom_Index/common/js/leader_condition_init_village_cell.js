$(function(){
    $(".searches1").append(
        "<ul>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(999,'',1,'village_page')\" name=\"999\">全省</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(931,'兰州市',1,'village_page')\" name=\"931\">兰州</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(938,'天水市',1,'village_page')\" name=\"938\">天水</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(943,'白银市',1,'village_page')\" name=\"943\">白银</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(937,'酒泉市',1,'village_page')\" name=\"937\">酒泉</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(936,'张掖市',1,'village_page')\" name=\"936\">张掖</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(935,'武威市',1,'village_page')\" name=\"935\">武威</a></li>"+
        "    <li style=\"width:30px;\"><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(945,'金昌市',1,'village_page')\" name=\"945\">金昌</a></li>"+
        "    <li></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(947,'嘉峪关市',1,'village_page')\" name=\"947\">嘉峪关</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(932,'定西市',1,'village_page')\" name=\"932\">定西</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(933,'平凉市',1,'village_page')\" name=\"933\">平凉</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(934,'庆阳市',1,'village_page')\" name=\"934\">庆阳</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(939,'陇南市',1,'village_page')\" name=\"939\">陇南</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(930,'临夏州',1,'village_page')\" name=\"930\">临夏</a></li>"+
        "    <li style=\"width:30px;\"><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity_inside_page(941,'甘南州',1,'village_page')\" name=\"941\">甘南</a></li>"+
        "</ul>"+
        "<div class=\"search_entrance\"><input type=\"text\" name=\"search_name\" class=\"search_name\"/><button id=\"search_btn\">查询</button></div>"+
        "<section class=\"clear\"></section>"
    );
    $("a[name='"+parent.global_current_city_id+"']").addClass("active");
});
