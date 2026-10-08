package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerQuotationSendPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 견적제출
	public Map<String,String> saveBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData);

	// 환율정보 저장
	public Map<String,String> saveExpBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData);
}
