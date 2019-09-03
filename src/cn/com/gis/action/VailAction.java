package cn.com.gis.action;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.DefaultLogin;
import cn.com.easy.ext.MD5;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

/**
 * Created by admin on 2019/7/18.
 */
@Controller
public class VailAction {
    @Action("vaild")
    public void vaild(String user,String pwd,HttpServletRequest request,HttpServletResponse response) {
        String is_encrypt = (String)request.getSession().getServletContext().getAttribute("PwdEncrypt");
        if(is_encrypt.equals("1")){
            pwd= MD5.MD5Crypt(pwd);
        }
        SqlRunner runner1 = new SqlRunner();
        DefaultLogin de = new DefaultLogin();
        Map userMap = de.login(user,pwd,runner1);
        PrintWriter pw = null;
        try {
            response.setCharacterEncoding("UTF8");
            pw = response.getWriter();
            if(userMap!=null)
                pw.write("{'has':1,'tel':"+String.valueOf(userMap.get("TELEPHONE"))+"}");
            else
                pw.write("{'has':0}");
            pw.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally{
            if(pw!=null)	{
                pw.close();
            }
        }
    }
}
