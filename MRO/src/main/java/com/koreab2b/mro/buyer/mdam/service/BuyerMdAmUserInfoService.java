package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmUserInfoService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> getApprovedList(Map<String,String>  formData);
		
	// 조회
	public List<Map<String,String>> getReferList(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> getAgreeList(Map<String,String>  formData);
		
	// 비밀번호 룰 적용
	public String getPwdValidCheck(Map<String,String>  formData);
		
	//저장
	public String updateSelectedData(Map<String,String> formData);
}
