$(function(){
    $(".searches1").append(
        "<ul>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(999,'')\" name=\"999\">全省</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(931,'兰州市')\" name=\"931\">兰州</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(938,'天水市')\" name=\"938\">天水</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(943,'白银市')\" name=\"943\">白银</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(937,'酒泉市')\" name=\"937\">酒泉</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(936,'张掖市')\" name=\"936\">张掖</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(935,'武威市')\" name=\"935\">武威</a></li>"+
        "    <li style=\"width:30px;\"><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(945,'金昌市')\" name=\"945\">金昌</a></li>"+
        "    <li></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(947,'嘉峪关市')\" name=\"947\">嘉峪关</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(932,'定西市')\" name=\"932\">定西</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(933,'平凉市')\" name=\"933\">平凉</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(934,'庆阳市')\" name=\"934\">庆阳</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(939,'陇南市')\" name=\"939\">陇南</a></li>"+
        "    <li><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(930,'临夏州')\" name=\"930\">临夏</a></li>"+
        "    <li style=\"width:30px;\"><a href=\"javascript:void(0)\" onclick=\"parent.switchToCity(941,'甘南州')\" name=\"941\">甘南</a></li>"+
        "</ul>"+
        "<div class=\"search_entrance\"><input type=\"text\" name=\"search_name\" class=\"search_name\"/><button id=\"search_btn\">查询</button></div>"+
        "<section class=\"clear\"></section>"
    );
    $("a[name='"+parent.global_current_city_id+"']").addClass("active");
});
