package com.kep.taxbill.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface TaxBillStatusDao {
	
	public SqlMapClient getSqlMapClient();

	public List<Map<String, String>> selectSearchCondition(Map<String, String> pMap) throws Exception;
	
	public int updateTaxBillStatus(Map<String, String> pMap) throws Exception;
	
	public List<Map<String, String>> selectRunCheck(Map<String, String> pMap) throws Exception;
}
