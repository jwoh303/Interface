package com.koreab2b.mro.common.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmPrivateInfoAlterPopService {
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> getApprovedList(Map<String,String>  formData);
		
	// 조회
	public List<Map<String,String>> getReferList(Map<String,String>  formData);

	// 조회 - 기본 결재경로의 결재/참조/합의 멤버 통합 (GUBUN IN ('C','R','H'))
	public List<Map<String,String>> getDefaultApprovalLineMembers(Map<String,String>  formData);
	
	// 비밀번호 룰 적용
	public String getPwdValidCheck(Map<String,String>  formData);
	
	//저장
	public String updateSelectedData(Map<String,String> formData);
}
