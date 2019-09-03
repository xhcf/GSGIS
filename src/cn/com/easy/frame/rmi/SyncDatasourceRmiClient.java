package cn.com.easy.frame.rmi;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.DataConversionException;
import cn.com.easy.exception.NetworkException;
import cn.com.easy.exception.NotFoundException;
import cn.com.easy.exception.ResourceAccessException;
import cn.com.easy.rmi.RMethod;

public class SyncDatasourceRmiClient {
	
	private SqlRunner runner;
	
	@SuppressWarnings("unchecked")
	public void callSyncDatasource(String dsName) {
		
		if(runner==null){
			runner = new SqlRunner();
		}
		
		String sql = "select ip,port,app_name from X_CLUSTER_INFO ";
		List<Map<String,String>> hostList = null;
		try {
			hostList = (List<Map<String,String>>)runner.queryForMapList(sql);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		
		RMethod method = null;
		if(hostList != null && hostList.size()>0){
			for(Map<String,String> hostMap : hostList){
				String host = hostMap.get("ip") + ":" + hostMap.get("port") + "/" + hostMap.get("app_name");
				method = new RMethod(host, "eframe.rmi.datasourceRmi.syncDatasource");
				method.addParameter("dsName", dsName);
				//捕获异常，尽可能多的同步到不同主机，如果报错抛出就断了
				try {
					method.invoke();
				} catch (DataConversionException e) {
					e.printStackTrace();
				} catch (NetworkException e) {
					e.printStackTrace();
				} catch (NotFoundException e) {
					e.printStackTrace();
				} catch (ResourceAccessException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
}
