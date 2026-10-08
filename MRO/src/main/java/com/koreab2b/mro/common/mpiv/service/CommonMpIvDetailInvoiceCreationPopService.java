package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface CommonMpIvDetailInvoiceCreationPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 송장등록
	public Map<String, String> saveCommonMpIvDetailInvoiceCreationPop(Map<String, String> pMap);

}
