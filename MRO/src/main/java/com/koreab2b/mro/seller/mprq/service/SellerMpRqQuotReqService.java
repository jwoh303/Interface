package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

public interface SellerMpRqQuotReqService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 저장
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);
}
