package com.koreab2b.mro.seller.mdam.service;

import java.util.List;
import java.util.Map;

public interface SellerMdAmUserInfoService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 비밀번호 룰 적용
	public String getPwdValidCheck(Map<String,String>  formData);
		
	// 저장
	public String updateSelectedData(Map<String,String>  formData);
	// 비밀번호변경
	public String updateSellerMdAmUsePwd(Map<String,String>  formData);
	// 비밀번호변경 v2 (현재 비밀번호와 동일 방지 검증 추가)
	public String updateSellerMdAmUsePwd_v2(Map<String,String>  formData);
}
