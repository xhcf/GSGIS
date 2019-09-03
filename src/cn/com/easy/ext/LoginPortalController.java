package cn.com.easy.ext;


import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import net.sf.json.JSONObject;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

	@Controller
	public class LoginPortalController {
		private SqlRunner runner;

		@Action("portalLogin")
		public String login(HttpServletRequest request,HttpServletResponse response) {
			String forward = "Frame.jsp";
			AbstractLogin absLogin = null;
			String userToken = request.getParameter("token");//"ff8080816b21b944016b21ce90a20002";//request.getParameter("token");
			String appId = request.getParameter("appId")==null ? "":request.getParameter("appId");
			String login_id = null;
			System.out.println("userToken====>"+userToken+"appId======>"+appId);
			//提交申请
			String dataPortalUrl = "http://135.149.64.106/EDA/login!loginDataPortal.do";
			try {
				//调接口获取令牌  EDA_SHAOL   ff8080816b1d3085016b1d3085b50000
                /*Map params = new HashMap(16);
                params.put("token", userToken);
                params.put("appId", appId);
                JSONObject jsonParams = JSONObject.fromObject(params);
                String doPost;//测试环境
                doPost = HttpClientUtil.doPost(dataPortalUrl, jsonParams, "utf-8");
                JSONObject jsonObject = JSONObject.fromObject(doPost);*/
				HttpClient httpclient1 = new DefaultHttpClient();
				HttpPost httppost1 = new HttpPost(dataPortalUrl);
				httppost1.addHeader("Content-type", "application/x-www-form-urlencoded");
				JSONObject jsonParam = new JSONObject();
				jsonParam.put("token", userToken);
				jsonParam.put("appId", appId);
				StringEntity entity1 = new StringEntity(jsonParam.toString(),"utf-8");//解决中文乱码问题
				entity1.setContentEncoding("UTF-8");
				entity1.setContentType("application/json");
				httppost1.setEntity(entity1);
				//返回数据
				HttpResponse post1 = httpclient1.execute(httppost1);
				String conResult1 = EntityUtils.toString(post1.getEntity());
				JSONObject jsonObject = JSONObject.fromObject(conResult1);
				//resCode = jsonObject1.getString("code");
                String resCode = jsonObject.get("code")==null ? "":jsonObject.get("code").toString();
                if("1".equals(resCode)){
                	Map user_info = new HashMap();
                	login_id = jsonObject.getString("userId");
                	absLogin = instance(request);
                	user_info = absLogin.PortalLogin(login_id, runner);
                	if(user_info != null){
							absLogin.setUser(user_info,request,runner);
							try {
								response.sendRedirect("pages/frame/"+forward);
							} catch (Exception e) {
								e.printStackTrace();
								return "pages/frame/" + forward;
							}
							return null;
                }
               }
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
			return "/index.jsp";
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
	}