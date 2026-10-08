package com.koreab2b.dongwha.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

public class WsDongWhaDao {
	
	private Logger log = Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;
	
	public WsDongWhaDao() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
			
		}catch(Exception e){
			log.error(e.getMessage());
			throw new RuntimeException(e);
		}
	}

	public List<Map<String,String>> selectItemRfqList() throws Exception {
		return sqlMapper.queryForList("selectItemRfqList");
	}
	public List<Map<String,String>> selectAppSendList() throws Exception {
		return sqlMapper.queryForList("selectAppSendList");
	}
	

	public void insertPoList(Map<String,Object> pMap) throws Exception {
//		sqlMapper.insert("insertPoList",pMap);
		sqlMapper.insert("mergePoInfo",pMap);
	}
	public void insertGrList(Map<String,Object> pMap) throws Exception {
//		sqlMapper.insert("insertGrList",pMap);
		sqlMapper.insert("mergeGrInfo",pMap);
	}
	public void insertItemList(Map<String,Object> pMap) throws Exception {
//		sqlMapper.update("insertItemList",pMap);
		sqlMapper.update("mergeItemInfo",pMap);
	}
	public void insertAppSendCallList(Map<String,Object> pMap) throws Exception {
		sqlMapper.insert("insertAppSendCallList",pMap);
	}
	public void insertAppStatusList(Map<String,Object> pMap) throws Exception {
		sqlMapper.insert("insertAppStatusList",pMap);
	}
	public void insertCostCenterList(Map<String,Object> pMap) throws Exception {
		sqlMapper.insert("insertCostCenterList",pMap);
	}
	public void insertAssetList(Map<String,Object> pMap) throws Exception {
		sqlMapper.insert("insertAssetList",pMap);
	}
	public void insertUserList(Map<String,Object> pMap) throws Exception {
		sqlMapper.insert("insertUserList",pMap);
	}	
	public void deleteUser(Map<String,Object> pMap) throws Exception {
		sqlMapper.delete("deleteUser", pMap);
	}	
}