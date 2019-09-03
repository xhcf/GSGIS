package cn.com.easy.ext;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

@Controller
public class Login {
	private SqlRunner runner;
	@Action("login")
	public String login(String user,String pwd,String validNum,String order_id,String fromMyself, HttpServletRequest request,HttpServletResponse response) {
		String is_encrypt = (String)request.getSession().getServletContext().getAttribute("PwdEncrypt");
		String forward = "Frame.jsp";
		AbstractLogin absLogin = null;
		String rCode = String.valueOf(request.getSession().getAttribute("rCode"));

		/*if(validNum==null||(validNum!=null&&validNum.length()==0)){
			request.setAttribute("loginName", user);
			request.setAttribute("loginPwd", pwd);
			request.setAttribute("LoginMsg_code","请输入验证码！");
			return "/index.jsp";
		}if(!validNum.equals(rCode)){
			request.setAttribute("loginName", user);
			request.setAttribute("loginPwd", pwd);
			request.setAttribute("LoginMsg_code","验证码不正确！");
			return "/index.jsp";
		}*/

		try {
			absLogin = instance(request);
		} catch (Exception e) {
			e.printStackTrace();
		}

		//从gis沙盘登录页登录系统，带一个额外参数fromMyself，此时加密明文密码。否则就是从划小系统登录，他们传的已经是加密后的密码，所以不需要重复加密。
		System.out.println("---fromMyself:" + fromMyself);
		if(fromMyself!=null){
			if(is_encrypt.equals("1")){
				pwd=MD5.MD5Crypt(pwd);
			}
		}

		Map user_info = absLogin.login(user,pwd,runner);

		if(user_info != null){
			absLogin.setUser(user_info,request,runner);

			HttpSession session = request.getSession();
			Map m_source = (Map) session.getAttribute("UserInfo");
			String role_permission = (String)m_source.get("CAN_CHANGE_ROLE");
			if(role_permission!=null)
				session.setAttribute("UserInfoSource",m_source);//备份原用户属性

			if(fromMyself!=null){//从GIS沙盘系统登录页登录的，校园沙盘需要增加短信验证码验证
				System.out.println("EXT29:"+user_info.get("EXT29"));
				if(true){
				//if("1".equals(user_info.get("EXT29"))){//e_user表中，该用户的ext29列为1时，跳过短信验证码的验证
					absLogin.setUser(user_info,request,runner);
					try {
						response.sendRedirect("pages/frame/"+forward);
					} catch (IOException e) {
						e.printStackTrace();
						return "pages/frame/" + forward;
					}
					return null;
				}else{
					try{
						SqlRunner runner1 = new SqlRunner();
						Map userMap1 = runner1.queryForMap("select 1 from e_sms_logs where idn = ? and random = ? and sysdate < send_time+1/(24*60)", new String[]{order_id,validNum});
						if(userMap1 != null){
							absLogin.setUser(user_info,request,runner);
							try {
								response.sendRedirect("pages/frame/"+forward);
							} catch (IOException e) {
								e.printStackTrace();
								return "pages/frame/" + forward;
							}
							return null;
						}else{
							request.setAttribute("order_id",order_id);
							request.setAttribute("LoginMsg_code","验证码不正确");
							return "/index.jsp";
						}
					}catch(Exception e){
						e.printStackTrace();
					}
				}
			}

			try {
				response.sendRedirect("pages/frame/"+forward);
			} catch (IOException e) {
				e.printStackTrace();
				return "pages/frame/"+forward;
			}
			return null;
		}else{
			request.setAttribute("LoginMsg_user","用户名或密码错误");
			return "/index.jsp";
		}
	}

	@Action("loginFallBack")
	public void fallBack(HttpServletRequest request,HttpServletResponse response){
		HttpSession session = request.getSession();
		Map m_source = (Map) session.getAttribute("UserInfoSource");
		session.setAttribute("UserInfo",m_source);//备份原用户属性
		session.removeAttribute("UserInfoSource");
		String forward = "Frame.jsp";
		try {
			response.sendRedirect("pages/frame/"+forward);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Action("logout")
	public void logout(HttpServletRequest request,HttpServletResponse response) {
		try{
			instance(request).logout(request,runner);
			response.sendRedirect("index.jsp");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	@Action("logoutForReturn")
	public void logoutForReturn(HttpServletRequest request,HttpServletResponse response) {
		try{
			instance(request).logout(request,runner);
			response.getWriter().write("1");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private static AbstractLogin instance(HttpServletRequest request) throws InstantiationException, IllegalAccessException, ClassNotFoundException {
		AbstractLogin absLogin = null;
		String login_class = (String)request.getSession().getServletContext().getAttribute("CustomLoginClass");
		if(login_class == null || login_class.equals("")){
			absLogin = LoginFactory.getLogin("cn.com.easy.ext.DefaultLogin");
		}else{
			absLogin = LoginFactory.getLogin(login_class);
		}
		return absLogin;
	}

	@Action("loginUserFrozen")
	public String frozenUser(HttpServletRequest request) {
		System.out.println("userName"+request.getParameter("userName"));
		String userName=request.getParameter("userName");
		try {
			runner.execute("update e_user t set t.state='2' where t.login_id=?", userName);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	public static void main(String[] args){
		System.out.print(MD5.MD5Crypt("admingsods"));
	}
}