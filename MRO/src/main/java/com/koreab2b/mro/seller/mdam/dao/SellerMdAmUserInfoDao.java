package com.koreab2b.mro.seller.mdam.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdAmUserInfoDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData);
		
	// 저장
	public String updateSelectedData(Map<String,String> formData);
	
	// 저장
	public String updateSellerMdAmUsePwd(Map<String,String> formData);

	// 비밀번호 변경 v2 (현재 비밀번호와 동일 방지 검증 추가)
	public String updateSellerMdAmUsePwd_v2(Map<String,String> formData);
}
