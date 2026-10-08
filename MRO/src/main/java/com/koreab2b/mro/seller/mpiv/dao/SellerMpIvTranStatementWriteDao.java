package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;

import java.util.Map;

public interface SellerMpIvTranStatementWriteDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListPO_v2(Map<String,Object> formData);
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItem_v2(Map<String,Object> formData);
	public List<Map<String,String>> getSellerMpIvTranStatementWritePrintList_v2(Map<String,Object> formData);
	
	public Map<String,String> getSellerMpIvTranStatementWriteQryForReport_v2(Map<String,String> formData);
	
}
