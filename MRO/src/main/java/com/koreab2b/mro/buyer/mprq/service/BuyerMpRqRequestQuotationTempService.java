package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqRequestQuotationTempService {
	
	// 조회	
	public List<Map<String,String>> getTempSaveList(Map<String,String>  formData);
	public List<Map<String,String>> getTempSaveList_v2(Map<String,String>  formData);
	
	// 견적의뢰
	public Map<String,String> requestTempSaveList(Map<String, String> formData);
	public Map<String,String> requestTempSaveList_v2(Map<String, String> formData);
		
	// 삭제	
	public String delTempSaveList(Map<String, String> formData);

	// 저장
	public Map<String,String> saveTempSaveList(Map<String, String> formData);
	public Map<String,String> saveTempSaveList_v2(Map<String, String> formData);
}
