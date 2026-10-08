package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpStReleaseDirectionsService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 사용자 조회
	public List<Map<String,String>> getUserList(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
