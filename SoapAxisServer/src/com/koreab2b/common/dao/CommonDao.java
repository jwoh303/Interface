package com.koreab2b.common.dao;

import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.common.vo.LogVo;

public interface CommonDao {
	
	public SqlMapClient getSqlMapClient();

	public void saveLog(LogVo obj) throws Exception;
	/**
	 * IF 동작여부 업데이트
	 * @param obj
	 */
	public void updateIfStatus(Map<String, String> pMap) throws Exception;
}
