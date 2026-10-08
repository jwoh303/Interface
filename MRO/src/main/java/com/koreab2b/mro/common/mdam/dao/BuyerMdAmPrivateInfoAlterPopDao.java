package com.koreab2b.mro.common.mdam.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmPrivateInfoAlterPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectApprovedList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectReferList(Map<String,String> formData);

	//조회 - 기본 결재경로의 결재/참조/합의 멤버 통합 (GUBUN IN ('C','R','H'))
	public List<Map<String,String>> selectDefaultApprovalLineMembers(Map<String,String> formData);
	
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData);
		
	//저장
	public String updateSelectedData(Map<String,String> formData);
}
