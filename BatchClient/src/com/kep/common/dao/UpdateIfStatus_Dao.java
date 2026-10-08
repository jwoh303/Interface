package com.kep.common.dao;

import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface UpdateIfStatus_Dao {

	/**
	 * SqlMapClient 객체 리턴
	 * @return
	 */
	public SqlMapClient getSqlMapClient();
	
	/**
	 * IF 동작여부 업데이트
	 * @param obj
	 */
	public void updateIfStatus(Map<String, String> pMap) throws Exception;
	
	public void insertMroJobDate(Map<String, String> pMap);
}
