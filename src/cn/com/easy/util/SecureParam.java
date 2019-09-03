package cn.com.easy.util;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.ext.CryptTool;
import cn.com.easy.ext.MD5;
import cn.com.easy.ext.MD5Tools;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Date;

@Controller
public class SecureParam {

    @Action("makeKey")
    public void makeKey(String reqPath,HttpServletRequest request,HttpServletResponse response){
        PrintWriter out = null;
        try{
            response.setHeader("Charset", "UTF-8");
            response.setContentType("text/html;charset=UTF-8");
            out = response.getWriter();
            long reqTime = new Date().getTime();
            //out.print(MD5.MD5Crypt(MD5.MD5Crypt(appId+reqPath+reqTime)));
            //MD5Tools.getMD5Code("898DA8B83EE5C7F9E0530100007FEEEB" + reqPath + reqTime)
            out.print("{\"key_val\":\""+MD5Tools.getMD5Code("898DA8B83EE5C7F9E0530100007FEEEB" + reqPath + reqTime)+"\",\"reqTime\":\""+reqTime+"\"}");
            out.flush();
            out.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static void main(String[] args){
        System.out.println(CryptTool.MD5Encode(CryptTool.MD5Encode("898DA8B83EE5C7F9E0530100007FEEEB" + "/mkt/mktExecute" + "1558946504196")));
        System.out.println(MD5.MD5Crypt(MD5.MD5Crypt("898DA8B83EE5C7F9E0530100007FEEEB" + "/mkt/mktExecute" + "1558946504196")));
        System.out.println(MD5Tools.getMD5Code(MD5Tools.getMD5Code("898DA8B83EE5C7F9E0530100007FEEEB" + "/mkt/mktExecute" + "1558946504196")));
    }
}
