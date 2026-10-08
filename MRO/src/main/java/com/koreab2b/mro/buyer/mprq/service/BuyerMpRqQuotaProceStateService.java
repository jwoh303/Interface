package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqQuotaProceStateService {
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//엑셀 상세조회
	public List<Map<String,String>> getDetailList(Map<String,String>  formData);

	public List<Map<String, String>> getList_v2(Map<String, Object>  pMap);

	// 장바구니 담기
	public String updateSelectedData_v2(Map<String, String> pMap);

	// 견적요청 조회 _v2
	public List<Map<String, String>> getList_tab2_v2(Map<String, Object> pMap);
}
