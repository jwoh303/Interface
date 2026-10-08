package com.koreab2b.common.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.common.vo.LogVo;

public interface CommonCHINADao {
	
	public SqlMapClient getSqlMapClient();

	public void saveLog(LogVo obj) throws Exception;
}
