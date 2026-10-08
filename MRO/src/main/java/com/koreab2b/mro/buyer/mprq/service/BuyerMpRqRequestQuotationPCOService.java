package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqRequestQuotationPCOService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	//견적의뢰
	public Map<String,String> updateSelectedTempData(Map<String,String>  formData, List<Object> gridData);
	//삭제
	public String deleteSelectedTempData(Map<String,String>  formData);
	//임시저장 견적의뢰
	public String saveSelectedTempReqData(Map<String,String>  formData);
}
