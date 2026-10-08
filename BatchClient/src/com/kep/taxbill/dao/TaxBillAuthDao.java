package com.kep.taxbill.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface TaxBillAuthDao {
	
	public SqlMapClient getSqlMapClient();
	
	public List<Map<String, String>> selectTaxBillAuth() throws Exception;
	
	public void updateTaxBillAuth(Map<String, String> pMap) throws Exception;
}
