package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmUserInfoDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectApprovedList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectReferList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectAgreeList(Map<String,String> formData);
	
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData);
		
	//저장
	public String updateSelectedData(Map<String,String> formData);
}
