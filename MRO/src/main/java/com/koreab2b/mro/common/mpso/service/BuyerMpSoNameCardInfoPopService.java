package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoNameCardInfoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 회원정보 조회
	public Map<String,String> getUserInfoList(Map<String,String>  formData);
	
	// 명함 컬럼명 조회
	public Map<String, Object> getCardColumnInfoList(Map<String,Object> formData);
	
	// 저장
	public String saveBuyerMpSoCartRemarkNameCard(Map<String,String> formData);
}
