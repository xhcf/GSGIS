package cn.com.gis.action;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.ext.MD5;
import cn.com.easy.util.HttpClientUtil;
import cn.com.easy.util.HttpRequestMethedEnum;
import cn.com.gis.utils.DateUtil;
import cn.com.gis.utils.ResponseUtil;
import com.alibaba.fastjson.JSON;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by admin on 2019/7/25.
 */
@Controller
public class GIStoHomeNet {

    private static String appid = "C21NAH8T60";
    private static String appsecret = "KG5BH2Z86KYFZW3WLWK7KU240XVPQ5N2";
    private static String appkey = "K0YS40QM";

    private static String url = "http://135.148.41.51/open/api/house";

    @Action("auth")
    public void auth(HttpServletRequest request, HttpServletResponse response){
        String sign = getAuthCode(request);
        try{
            ResponseUtil.write(response,sign);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    @Action("keepSign")
    public void isVaild(HttpServletRequest request, HttpServletResponse response){
        String sign = null;
        try{
            Object timestampObj = request.getSession().getAttribute("timestamp");
            System.out.println(timestampObj);
            if(timestampObj==null){
                sign = getAuthCode(request);
            }else{
                long timestamp = Long.parseLong(String.valueOf(timestampObj));
                long now = new Date().getTime();
                if(now-timestamp>1740000){//获取的流水号过期,若过期则重新获取流水号
                    sign = getAuthCode(request);
                }else{
                    sign =String.valueOf(request.getSession().getAttribute("sign"));
                }
            }
            System.out.println(sign);
            ResponseUtil.write(response,sign);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    @Action("getCitys")
    public void getCitys(HttpServletRequest request, HttpServletResponse response){
        Map params = new HashMap(2);
        params.put("action", "getCitys");
        params.put("sign", request.getParameter("sign"));
        String res = HttpClientUtil.doPost(url, params, "utf-8");
        JSON json = JSON.parseObject(res);
        String jsonStr = JSON.toJSONString(json);
        try{
            ResponseUtil.write(response,jsonStr);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    @Action("getFloorPlan")
    public void getFloorPlan(HttpServletRequest request, HttpServletResponse response){
        Map params = new HashMap(2);
        params.put("action", "getFloorPlan");
        params.put("sign", request.getParameter("sign"));
        params.put("cityid", request.getParameter("cityid"));
        params.put("query", request.getParameter("query"));
        String res = HttpClientUtil.doPost(url, params, "utf-8");
        JSON json = JSON.parseObject(res);
        String jsonStr = JSON.toJSONString(json);
        try{
            ResponseUtil.write(response,jsonStr);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    @Action("ActionFloorPlan")
    public void ActionFloorPlan(HttpServletRequest request, HttpServletResponse response){
        Map params = new HashMap(2);
        params.put("action", "ActionFloorPlan");
        params.put("sign", request.getParameter("sign"));
        params.put("obsPlanId", request.getParameter("obsPlanId"));
        String res = HttpClientUtil.doPost(url, params, "utf-8");
        JSON json = JSON.parseObject(res);
        String jsonStr = JSON.toJSONString(json);
        try{
            ResponseUtil.write(response,jsonStr);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    private static String getAuthCode(HttpServletRequest request){
        long timestamp = DateUtil.getTimestamp();
        String sign = MD5.MD5Crypt(appid + appsecret + appkey + timestamp);
        Map params = new HashMap(3);
        params.put("action", "auth");
        params.put("appid", appid);
        params.put("timestamp", timestamp);
        params.put("sign", sign);
        System.out.println("appid:"+appid+" timestamp:"+timestamp+" sign:"+sign);
        String res = HttpClientUtil.doPost(url, params, "utf-8");
        //String res = HttpClientUtil.sendHttp(HttpRequestMethedEnum.HttpGet, url, params, null);
        request.getSession().setAttribute("sign",res);
        request.getSession().setAttribute("timestamp", timestamp);
        return res;
    }
}
