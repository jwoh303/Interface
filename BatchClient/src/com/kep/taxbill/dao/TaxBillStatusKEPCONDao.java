package com.kep.taxbill.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface TaxBillStatusKEPCONDao {
	
	public SqlMapClient getSqlMapClient();

	public List<Map<String, String>> selectSearchCondition() throws Exception;
	
	public int updateTaxBillStatus(Map<String, String> pMap) throws Exception;
}
