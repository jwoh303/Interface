package com.kep.quratis.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class AppStatusDaoImpl implements AppStatusDao{
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public AppStatusDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<Map<String, String>> getAppList() throws Exception{
		return this.sqlMapper.queryForList("selectQuratisAppStatusIdList");
	}
	
	@Override
	public void UpdateAppStatus(Map<String, String> iMap) throws Exception{
		
		String status = iMap.get("state");
		
		System.out.println("state : " + status);
		
		if ("complete".equals(status)) {
			iMap.put("RECV_FLAG", "PS");
		} else if ("Progress".equals(status)){
			iMap.put("RECV_FLAG", "GA");
		} else if ("Rejected".equals(status)) {
			iMap.put("RECV_FLAG", "PR");
		} else {
			iMap.put("RECV_FLAG", "PD");
		}
		
		System.out.println("iMap : " + iMap);
		
		this.sqlMapper.update("updateQuraAppStatus", iMap);
		this.sqlMapper.update("updateQuraAppStatusHD", iMap);
		this.sqlMapper.update("updateIcomtrxl", iMap);
		//this.sqlMapper.update("deleteIcomtrxl", iMap);
		this.sqlMapper.update("InsertIfProgress", iMap);
	}
}
