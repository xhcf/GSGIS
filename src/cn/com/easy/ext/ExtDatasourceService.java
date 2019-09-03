package cn.com.easy.ext;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSourceFactory;

import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;

import com.mchange.v2.c3p0.ComboPooledDataSource;


@Controller
public class ExtDatasourceService {

	private SqlRunner runner;
	
	@SuppressWarnings("unchecked")
	public void init(){
		
		String sql = "select DS_NAME,DS_TYPE,DB_TYPE,DRIVER_CLASS_NAME,URL,USER_NAME,PASSWORD,"
				+ "INITIAL_SIZE,MIN_IDLE,MAX_IDLE,MAX_ACTIVE,MAX_WAIT,REMOVE_ABANDONED,"
				+ "REMOVE_ABANDONED_TIMEOUT,TIME_BWT_EVN_MILLIS,TEST_WHILE_IDLE,"
				+ "VALIDATION_QUERY,STATUS,CREATE_TIME,CREATE_USER from E_EXT_DATASOURCE";
		List<Map<String,String>> list = null;
		try {
			list = (List<Map<String,String>>)runner.queryForMapList(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if(list!=null && list.size()>0){
			Properties prop = null;
			for(Map<String,String> map : list){
				prop = new Properties();
				prop.put("dsName", map.get("DS_NAME"));
				prop.put("dsType", map.get("DS_TYPE"));
				prop.put("dbType", map.get("DB_TYPE"));
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
				addExtDatasource(prop);
			}
		}
	}
	
	public boolean addExtDatasource(Properties prop){
		boolean check = false;
		try {
			DataSource dataSource = null;
			if("dbcp".equals(prop.get("dsType"))){
				dataSource = BasicDataSourceFactory.createDataSource(prop);
			} else if("c3p0".equals(prop.get("dsType"))){
				dataSource = new ComboPooledDataSource("c3p0");
			}
			if(dataSource!=null){
				
				EasyDataSource easyDs = new EasyDataSource(prop.getProperty("dsName"), dataSource);
				easyDs.setDataSourceDB(prop.getProperty("dbType"));
				EasyContext.getContext().addDataSource(easyDs);
				
				check = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return check;
	}
	
	public boolean setExtDatasource(Properties prop){
		boolean check = false;
		try {
			DataSource dataSource = BasicDataSourceFactory.createDataSource(prop);
			
			EasyDataSource easyDs = new EasyDataSource(prop.getProperty("dsName"), dataSource);
			easyDs.setDataSourceDB(prop.getProperty("dbType"));
			
			EasyContext.getContext().removeDataSource(prop.getProperty("dsName"));
			EasyContext.getContext().addDataSource(easyDs);
			
			check = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return check;
	}
	
	public boolean delExtDatasource(Properties prop){
		boolean check = false;
		try {
			EasyContext.getContext().removeDataSource(prop.getProperty("dsName"));
			check = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return check;
	}
	
}
