package cn.com.gis.action;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.gis.utils.ResponseUtil;
import cn.com.gis.utils.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by admin on 2019/3/7.
 */

@Controller
public class GISInterfaceAction {
    private Logger logger = LoggerFactory.getLogger(ExcelFileAction.class);
    private SqlRunner runner;

    private String sql = "update gis_data.tb_gis_addr_order " +
            "set opr_name = #OPR_NAME# , " +
            "opr_tel = #OPR_TEL# ," +
            //"opr_time = to_date(#OPR_TIME#,'yyyy-mm-dd hh24:mi:ss') ," +
            "opr_time = sysdate ," +
            "back_content = #BACK_CONTENT# ," +
            "order_status = #ORDER_STATUS# " +
            "where order_id = #ORDER_ID#";

    @Action("interface/postAddrBack")
    public void addrRepairOrderPostBack(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        request.setCharacterEncoding("UTF8");

        String opr_name = java.net.URLDecoder.decode(java.net.URLDecoder.decode(defaultString(request.getParameter("oprName")), "UTF-8"),"UTF-8").trim();
        String opr_tel = defaultString(request.getParameter("oprTel")).trim();
        //String opr_time = defaultString(request.getParameter("opr_time")).replace("%20", " ");
        String back_content = java.net.URLDecoder.decode(java.net.URLDecoder.decode(defaultString(request.getParameter("backContent")), "UTF-8"), "UTF-8").trim();
        String order_status = defaultString(request.getParameter("orderResult")).trim();
        String order_id = defaultString(request.getParameter("orderId")).trim();

        System.out.println("参数打印: oprName '"+opr_name+"'");
        System.out.println("参数打印: oprTel '"+opr_tel+"'");
        System.out.println("参数打印: backContent '"+back_content+"'");
        System.out.println("参数打印: orderResult '"+order_status+"'");
        System.out.println("参数打印: orderId '"+order_id+"'");

        String res = null;//返回结果

        if("".equals(opr_name) || "".equals(opr_tel) || "".equals(back_content) || "".equals(order_status) || "".equals(order_id)){
            res = "{\"code\":\"0\",\"msg\":\"参数都不能为空\"}";
        }else if(!"0".equals(order_status) && !"1".equals(order_status)){
            res = "{\"code\":\"0\",\"msg\":\"工单状态不正确，参数说明 0未处理 1已处理\"}";
        }else{
            Map map = new HashMap<>();
            map.put("OPR_NAME",opr_name);
            map.put("OPR_TEL",opr_tel);
            //map.put("OPR_TIME",opr_time);
            map.put("BACK_CONTENT",back_content);
            map.put("ORDER_STATUS",order_status);
            map.put("ORDER_ID",order_id);

            try {
                int i = runner.execute(sql, map);
                if(i>0){
                    res = "{\"code\":\"1\",\"msg\":\"修改成功\"}";
                }else{
                    res = "{\"code\":\"0\",\"msg\":\"记录不存在\"}";
                }
            } catch (SQLException e) {
                System.out.println("postAddrBack接口返回异常：");
                e.printStackTrace();
                res = "{\"code\":\"0\",\"msg\":\""+e+"\"}";
            }
        }

        System.out.println("postAddrBack接口返回结果："+res);
        out(response, res);
    }

    @Action("util/getTimestamp")
    public void getTimestamp(HttpServletRequest request, HttpServletResponse response){
        try{
            ResponseUtil.write(response,new Date().getTime());
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    private String defaultString(String str){
        if(str==null)
            return "";
        else
            return str;
    }

    public void out(HttpServletResponse response, String str){
        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");
        PrintWriter out;
        try {
            out = response.getWriter();
            out.println(str);
            out.flush();
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
