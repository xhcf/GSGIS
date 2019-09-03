<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<html>
<head>
    <title>小区概况</title>
</head>
<body>
    <div class="devep village_new_base">
        <div class="deve_ta info_base">
            基础
        </div>
        <div class="deve_tb">
            <table border="0" width="100%">
                <tr>
                    <td width="19%">
                        <div class="quota"><span style="color: #9ebaf1">•</span><span
                                style="margin-left: 5px;line-height: 24px">支局：<span
                                id="village_view_sub"></span></span></div>
                    </td>
                    <td width="20%">
                        <div class="quota"><span
                                style="line-height: 24px">网格：<span
                                id="village_view_grid"></span></span></div>
                    </td>
                    <td width="25%">
                        <div class="quota"><span>挂测时间：<span id="village_view_gua_ce_time"
                                                            style="line-height: 24px"></span></span></div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="quota"><span style="color: #9ebaf1">•</span>
                                        <span>创建人：<span id="village_view_creator"
                                                        style="line-height: 24px"></span></span>
                        </div>
                    </td>
                    <td>
                        <div class="quota"><span>创建时间：<span id="village_view_create_time"
                                                            style="line-height: 24px"></span></span></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="deve_ta">
            市场
        </div>
        <div class="deve_tb">
            <table border="0" width="100%">
                <tr>
                    <td rowspan="2" width="30%">
                        <div class="quota big_msg"><span style="color: #9ebaf1">•</span><span
                                style="margin-left: 5px;">渗透率：<span id="village_view_market_lv"
                                                                    style="color:#FF9214;font-weight:bold!important;"></span></span>
                        </div>
                    </td>
                    <td width="20%">
                        <div class="quota"><span>住户数：<span
                                id="village_view_zhu_hu"></span></span></div>
                    </td>
                    <td width="25%">
                        <div class="quota"><span>政企住户：<span
                                id="village_view_gov_zhu_hu"></span></span></div>
                    </td>
                    <td width="25%">
                        <div class="quota"><span>楼宇数：<span
                                id="village_view_build_count"></span></span></div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="quota"><span>光宽用户：<span
                                id="village_view_gz_h_use"></span></span></div>
                    </td>
                    <td>
                        <div class="quota"><span>政企光宽：<span
                                id="village_view_gov_h_use"></span></span></div>
                    </td>
                    <td>
                        <div class="quota"><span>未到达楼宇数：<span
                                id="village_view_unreach_build"></span></span></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="deve_ta">
            资源
        </div>
        <div class="deve_tb">
            <table border="0" width="100%">
                <tr>
                    <td rowspan="2" width="30%">
                        <div class="quota big_msg"><span style="color: #9ebaf1">•</span><span
                                style="margin-left: 5px;">端口占用率：<span id="village_view_port_lv"
                                                                      style="color:#FF9214;font-weight:bold!important;"></span></span>
                        </div>
                    </td>
                    <td width="20%">
                        <div class="quota"><span>总端口：<span
                                id="village_view_port_sum"></span></span></div>
                    </td>
                    <td width="25%">
                        <div class="quota"><span>OBD设备：<span
                                id="village_view_obd"></span></span></div>
                    </td>
                    <td rowspan="" width="25%">
                        <div class="quota"><span>0-1OBD：<span
                                id="village_view_obd01"></span></span></div>
                        <div class="quota"></div>
                    </td>
                </tr>
                <tr>
                    <td><div class="quota"><span>空闲端口：<span
                            id="village_view_free_port"></span></span></div></td>
                    <td><div class="quota"><span>高占用OBD：<span
                            id="village_view_hobd"></span></span></div></td>
                    <td></td>
                </tr>
            </table>
        </div>
        <div class="deve_ta">
            竞争
        </div>
        <div class="deve_tb">
            <table border="0" width="100%">
                <tr>
                    <td rowspan="2" width="30%">
                        <div class="quota"><span style="color: #9ebaf1">•</span>
                                        <span style="margin-left: 5px;font-weight:bold;">进线运营商：<span
                                                id="village_view_bussiness_count"
                                                style="color:#FF9214;font-weight:bold!important;"></span><span id="village_view_bussiness_text" style="display:none;"></span></span>
                        </div>
                    </td>
                    <td width="20%">
                        <div class="quota"><span>小区规模：<span id="village_view_village_mode"></span></span>
                        </div>
                    </td>
                    <td width="25%">
                        <div class="quota"><span>消费能力：<span id="village_view_village_xf"></span></span>
                        </div>
                    </td>
                    <td>
                        <div class="quota"><span>小区属性：<span id="village_view_village_attr"></span></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="quota"><span>入住率：<span id="village_view_ru_zhu_lv"></span></span>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
<script>

</script>