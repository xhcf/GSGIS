package cn.com.easy.frame.rmi;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import cn.com.easy.annotation.Rmi;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.ExtDatasourceService;

@Rmi("eframe.rmi.datasourceRmi")
public class SyncDatasourceRmiServer {
	
	private SqlRunner runner;
	ExtDatasourceService es = new ExtDatasourceService();
	
	@SuppressWarnings("unchecked")
	public void syncDatasource(String dsName) {
		String sql = "select * from e_ext_datasource where ds_name = #dsName# ";
		
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put(dsName, dsName);
		
		Map<String,String> dsMap = null;
		try {
			dsMap = (Map<String,String>) runner.queryForMap(sql, paramMap);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if(dsMap != null){
			if("1".equals(dsMap.get("STATUS"))) {
				es.setExtDatasource(getProp(dsMap));
			} else if("0".equals(dsMap.get("STATUS"))){
				es.delExtDatasource(getProp(dsMap));
			}
		}
	}
	
	
	
	private Properties getProp(Map<String,String> map){
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
	
}
