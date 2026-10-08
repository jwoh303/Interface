package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqQuotaProceStateAdminDao {
	public List<Map<String,String>> selectList(Map<String,String> formData);
	//신규품목현황
	public List<Map<String,String>> selectSourcList(Map<String,String> formData);
	//신규발주현황
	public List<Map<String,String>> selectNewPoList(Map<String,String> formData);	
}
