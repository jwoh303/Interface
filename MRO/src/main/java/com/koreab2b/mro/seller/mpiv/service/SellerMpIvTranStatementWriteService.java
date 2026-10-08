package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;

import java.util.Map;

public interface SellerMpIvTranStatementWriteService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListPO_v2(Map<String,Object>  formData);
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItem_v2(Map<String,Object>  formData);
	public List<Map<String,String>> getSellerMpIvTranStatementWritePrintList_v2(Map<String,Object>  formData);
	public Map<String,Object> getSellerMpIvTranStatementWriteRptUrl_v2(Map<String,Object>  formData);
	
}
