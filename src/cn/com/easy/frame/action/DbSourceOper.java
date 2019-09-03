package cn.com.easy.frame.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.ExtDatasourceService;
import cn.com.easy.frame.rmi.SyncDatasourceRmiClient;
import cn.com.easy.taglib.function.Functions;

@Controller
public class DbSourceOper {
	
	private SqlRunner runner;
	ExtDatasourceService es = new ExtDatasourceService();
	SyncDatasourceRmiClient rmi = new SyncDatasourceRmiClient();

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Action("extDatasource/queryDB")
	public void queryDb(HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception {
		// 用来修改的查询
		String dsName = request.getParameter("dsName");
		String userName = request.getParameter("userName");
		String dsType = request.getParameter("dsType");
		StringBuffer sb = new StringBuffer();
		sb = sb.append("select status,ds_cn_name,ds_name,ds_type,db_type,driver_class_name,url,user_name,password ,initial_size ,min_idle,max_idle,max_active,max_wait,remove_abandoned,remove_abandoned_timeout,time_bwt_evn_millis,test_while_idle,validation_query,status,create_time,create_user from e_ext_datasource where 1=1 ");
		Map<String, String> dsParams = new HashMap<String, String>();
		dsParams.put("dsName", dsName);
		dsParams.put("userName", userName);
		dsParams.put("dsType", dsType);
		List<Map> l = null;
		// 如果是修改的查询
		if (dsName == null) {
			// 同时为空
			if (userName == null && dsType == null || userName.equals("") && dsType.equals("")) {
				String sql = sb.toString();
				l = (List<Map>) runner.queryForMapList(sql);
			} else if (userName.equals("") && (!dsType.equals(""))) {
				sb = sb.append(" and ds_type=#dsType#");
				String sql = sb.toString();
				l = (List<Map>) runner.queryForMapList(sql, dsParams);
			} else if ((!userName.equals("")) && dsType.equals("")) {
				sb = sb.append("and user_name = #userName#");
				String sql = sb.toString();
				l = (List<Map>) runner.queryForMapList(sql, dsParams);
			} else if (userName != null && dsType != null && (!userName.equals("")) && (!dsType.equals(""))) {
				sb = sb.append(" and user_name = #userName# and ds_type=#dsType#");
				String sql = sb.toString();
				l = (List<Map>) runner.queryForMapList(sql, dsParams);
			}

			Map map = new HashMap<String, String>();
			map.put("total", l.size());
			map.put("rows", l);
			System.out.println(Functions.java2json(map));
			out(response, Functions.java2json(map));
		} else {
			dsParams.put("dsName", dsName);
			sb = sb.append("and ds_name = #dsName#");
			String sql = sb.toString();
			l = (List<Map>) runner.queryForMapList(sql, dsParams);
			System.out.println(Functions.java2json(l));
			out(response, Functions.java2json(l));
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Action("extDatasource/insertDB")
	public void insertDB(HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception {
		String res = "0";
		
		String ADD_DB_TYPE = request.getParameter("ADD_DB_TYPE");
		String ADD_DS_TYPE = request.getParameter("ADD_DS_TYPE");
		String ADD_DS_CN_NAME = request.getParameter("ADD_DS_CN_NAME");
		String ADD_DS_NAME = request.getParameter("ADD_DS_NAME");
		String ADD_DRIVER_CLASS_NAME = request.getParameter("ADD_DRIVER_CLASS_NAME");
		String ADD_URL = request.getParameter("ADD_URL");
		String ADD_USER_NAME = request.getParameter("ADD_USER_NAME");
		String ADD_INITIAL_SIZE = request.getParameter("ADD_INITIAL_SIZE");
		String ADD_PASSWORD = request.getParameter("ADD_PASSWORD");
		String ADD_MIN_IDLE = request.getParameter("ADD_MIN_IDLE");
		String ADD_MAX_IDLE = request.getParameter("ADD_MAX_IDLE");
		String ADD_MAX_ACTIVE = request.getParameter("ADD_MAX_ACTIVE");
		String ADD_MAX_WAIT = request.getParameter("ADD_MAX_WAIT");
		String ADD_REMOVE_ABANDONED = request.getParameter("ADD_REMOVE_ABANDONED");
		String ADD_REMOVE_ABANDONED_TIMEOUT = request.getParameter("ADD_REMOVE_ABANDONED_TIMEOUT");
		String ADD_TIME_BWT_EVN_MILLIS = request.getParameter("ADD_TIME_BWT_EVN_MILLIS");
		String ADD_TEST_WHILE_IDLE = request.getParameter("ADD_TEST_WHILE_IDLE");
		String ADD_VALIDATION_QUERY = request.getParameter("ADD_VALIDATION_QUERY");
		String ADD_CREATE_USER = String.valueOf(request.getSession().getAttribute("USER_ID"));
		
		Map map = new HashMap<String, String>();
		map.put("DS_CN_NAME", ADD_DS_CN_NAME);
		map.put("DS_NAME", ADD_DS_NAME);
		map.put("DS_TYPE", ADD_DS_TYPE);
		map.put("DB_TYPE", ADD_DB_TYPE);
		map.put("DRIVER_CLASS_NAME", ADD_DRIVER_CLASS_NAME);
		map.put("URL", ADD_URL);
		map.put("USER_NAME", ADD_USER_NAME);
		map.put("INITIAL_SIZE", ADD_INITIAL_SIZE);
		map.put("PASSWORD", ADD_PASSWORD);
		map.put("MIN_IDLE", ADD_MIN_IDLE);
		map.put("MAX_IDLE", ADD_MAX_IDLE);
		map.put("MAX_ACTIVE", ADD_MAX_ACTIVE);
		map.put("MAX_WAIT", ADD_MAX_WAIT);
		map.put("REMOVE_ABANDONED", ADD_REMOVE_ABANDONED);
		map.put("REMOVE_ABANDONED_TIMEOUT", ADD_REMOVE_ABANDONED_TIMEOUT);
		map.put("TEST_WHILE_IDLE", ADD_TEST_WHILE_IDLE);
		map.put("VALIDATION_QUERY", ADD_VALIDATION_QUERY);
		map.put("TIME_BWT_EVN_MILLIS", ADD_TIME_BWT_EVN_MILLIS);
		map.put("CREATE_USER", ADD_CREATE_USER);
		
		String sql = "insert into e_ext_datasource (DS_CN_NAME,DS_NAME ,DS_TYPE, DB_TYPE, DRIVER_CLASS_NAME, URL, USER_NAME,PASSWORD,  INITIAL_SIZE,"
				+ "MIN_IDLE,MAX_IDLE,MAX_ACTIVE,MAX_WAIT,REMOVE_ABANDONED,REMOVE_ABANDONED_TIMEOUT,TIME_BWT_EVN_MILLIS,"
				+ "TEST_WHILE_IDLE,VALIDATION_QUERY,STATUS,CREATE_TIME,CREATE_USER) "
				+ "values(#DS_CN_NAME#,#DS_NAME#,#DS_TYPE#,#DB_TYPE#,#DRIVER_CLASS_NAME#,#URL#,#USER_NAME#,#PASSWORD#"
				+ ",#INITIAL_SIZE#,#MIN_IDLE#,#MAX_IDLE#,#MAX_ACTIVE#,#MAX_WAIT#,#REMOVE_ABANDONED#,"
				+ "#REMOVE_ABANDONED_TIMEOUT#,#TIME_BWT_EVN_MILLIS#,#TEST_WHILE_IDLE#,#VALIDATION_QUERY#,'1',#time()#"
				+ ",#CREATE_USER#)";
		
		if( es.addExtDatasource(getProp(map)) ) {
			int i = runner.execute(sql, map);
			if(i>0){
				
				syncDs(ADD_DS_NAME);
				
				res = "1";
			}
		} else {
			res = "2";
		}
		out(response, res);
		/**
		 * 2 验证失败
		 * 1  成功
		 */
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Action("extDatasource/updateDB")
	public void updateDB(HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception {
		String res = "0";
		
		String EDIT_DS_CN_NAME = request.getParameter("EDIT_DS_CN_NAME");
		String EDIT_DS_NAME = request.getParameter("EDIT_DS_NAME");
		String EDIT_DS_TYPE = request.getParameter("EDIT_DS_TYPE");
		String EDIT_DB_TYPE = request.getParameter("EDIT_DB_TYPE");
		String EDIT_DRIVER_CLASS_NAME = request.getParameter("EDIT_DRIVER_CLASS_NAME");
		String EDIT_URL = request.getParameter("EDIT_URL");
		String EDIT_USER_NAME = request.getParameter("EDIT_USER_NAME");
		String EDIT_INITIAL_SIZE = request.getParameter("EDIT_INITIAL_SIZE");
		String EDIT_PASSWORD = request.getParameter("EDIT_PASSWORD");
		String EDIT_MIN_IDLE = request.getParameter("EDIT_MIN_IDLE");
		String EDIT_MAX_IDLE = request.getParameter("EDIT_MAX_IDLE");
		String EDIT_MAX_ACTIVE = request.getParameter("EDIT_MAX_ACTIVE");
		String EDIT_MAX_WAIT = request.getParameter("EDIT_MAX_WAIT");
		String EDIT_REMOVE_ABANDONED = request.getParameter("EDIT_REMOVE_ABANDONED");
		String EDIT_REMOVE_ABANDONED_TIMEOUT = request.getParameter("EDIT_REMOVE_ABANDONED_TIMEOUT");
		String EDIT_TIME_BWT_EVN_MILLIS = request.getParameter("EDIT_TIME_BWT_EVN_MILLIS");
		String EDIT_TEST_WHILE_IDLE = request.getParameter("EDIT_TEST_WHILE_IDLE");
		String EDIT_VALIDATION_QUERY = request.getParameter("EDIT_VALIDATION_QUERY");
		String EDIT_CREATE_USER = String.valueOf(request.getSession().getAttribute("USER_ID"));
		
		Map map = new HashMap<String, String>();
		map.put("DS_CN_NAME", EDIT_DS_CN_NAME);
		map.put("DS_NAME", EDIT_DS_NAME);
		map.put("DS_TYPE", EDIT_DS_TYPE);
		map.put("DB_TYPE", EDIT_DB_TYPE);
		map.put("DRIVER_CLASS_NAME", EDIT_DRIVER_CLASS_NAME);
		map.put("URL", EDIT_URL);
		map.put("USER_NAME", EDIT_USER_NAME);
		map.put("INITIAL_SIZE", EDIT_INITIAL_SIZE);
		map.put("PASSWORD", EDIT_PASSWORD);
		map.put("MIN_IDLE", EDIT_MIN_IDLE);
		map.put("MAX_IDLE", EDIT_MAX_IDLE);
		map.put("MAX_ACTIVE", EDIT_MAX_ACTIVE);
		map.put("MAX_WAIT", EDIT_MAX_WAIT);
		map.put("REMOVE_ABANDONED", EDIT_REMOVE_ABANDONED);
		map.put("REMOVE_ABANDONED_TIMEOUT", EDIT_REMOVE_ABANDONED_TIMEOUT);
		map.put("TIME_BWT_EVN_MILLIS", EDIT_TIME_BWT_EVN_MILLIS);
		map.put("TEST_WHILE_IDLE", EDIT_TEST_WHILE_IDLE);
		map.put("VALIDATION_QUERY", EDIT_VALIDATION_QUERY);
		map.put("CREATE_USER", EDIT_CREATE_USER);
		String sql = "update  e_ext_datasource set DS_CN_NAME=#DS_CN_NAME#,DS_TYPE=#DS_TYPE#,DB_TYPE=#DB_TYPE#, DRIVER_CLASS_NAME=#DRIVER_CLASS_NAME#, URL=#URL#, USER_NAME=#USER_NAME#,PASSWORD=#PASSWORD#,  INITIAL_SIZE=#INITIAL_SIZE#,"
				+ "MIN_IDLE=#MIN_IDLE#,MAX_IDLE=#MAX_IDLE#,MAX_ACTIVE=#MAX_ACTIVE#,MAX_WAIT=#MAX_WAIT#,REMOVE_ABANDONED=#REMOVE_ABANDONED#,REMOVE_ABANDONED_TIMEOUT=#REMOVE_ABANDONED_TIMEOUT#,TIME_BWT_EVN_MILLIS=#TIME_BWT_EVN_MILLIS#,"
				+ "TEST_WHILE_IDLE=#TEST_WHILE_IDLE#,VALIDATION_QUERY=#VALIDATION_QUERY#,CREATE_USER=#CREATE_USER# WHERE DS_NAME=#DS_NAME# ";
		
		if( es.setExtDatasource(getProp(map)) ) {
			int i = runner.execute(sql, map);
			if(i>0){
				
				syncDs(EDIT_DS_NAME);
				
				res = "1";
			}
		} else {
			res = "2";
		}
		out(response, res);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Action("extDatasource/deleteDS")
	public void deleteDS(HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception {
		String res = "0";
		
		String dsName = request.getParameter("DS_NAME");
		String status = request.getParameter("status");
		
		Map map = new HashMap<String, String>();
		map.put("dsName", dsName);
		map.put("status", status);
		
		Properties prop = new Properties();
		prop.put("dsName", map.get("dsName"));
		
		String sql = "update e_ext_datasource set status=#status# where DS_NAME = #dsName#";
		
		if("0".equals(status)){
			//停用
			int i = runner.execute(sql, map);
			if(i>0){
				if( es.delExtDatasource(prop) ){
					
					syncDs(dsName);
					
					res = "1";
				}
			}
		} else if("1".equals(status)){
			//恢复
			String getsql = "select * from e_ext_datasource where DS_NAME = #dsName# ";
			Map dsMap = runner.queryForMap(getsql, map);
			if( es.addExtDatasource(getProp(dsMap)) ) {
				int i = runner.execute(sql, map);
				if(i>0){
					
					syncDs(dsName);
					
					res = "1";
				}
			}
		}
		out(response, res);
	}
	
	private void syncDs(String dsName){
		try{
			rmi.callSyncDatasource(dsName);
		} catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("rawtypes")
	private Properties getProp(Map map){
		Properties prop = new Properties();
		prop.put("dsName", map.get("DS_NAME"));
		prop.put("dsCnName", map.get("DS_CN_NAME"));
		prop.put("dbType", map.get("DB_TYPE"));
		prop.put("dsType", map.get("DS_TYPE"));
		prop.put("driverClassName", map.get("DRIVER_CLASS_NAME"));
		prop.put("url", map.get("URL"));
		prop.put("username", map.get("USER_NAME"));
		prop.put("password", map.get("PASSWORD"));
		prop.put("initialSize", map.get("INITIAL_SIZE"));
		prop.put("minIdle", map.get("MIN_IDLE"));
		prop.put("maxIdle", map.get("MAX_IDLE"));
		prop.put("maxActive", map.get("MAX_ACTIVE"));
		prop.put("maxWait", map.get("MAX_WAIT"));
		prop.put("removeAbandoned", map.get("REMOVE_ABANDONED"));
		prop.put("removeAbandonedTimeout", map.get("REMOVE_ABANDONED_TIMEOUT"));
		prop.put("timeBetweenEvictionRunsMillis", map.get("TIME_BWT_EVN_MILLIS"));
		prop.put("testWhileIdle", map.get("TEST_WHILE_IDLE"));
		prop.put("validationQuery", map.get("VALIDATION_QUERY"));
		return prop;
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
