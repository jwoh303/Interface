package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoNameCardInfoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 회원정보 조회
	public Map<String,String> selectUserInfoList(Map<String,String> formData);
	
	// 명함 컬럼명 조회
	public Map<String, Object> selectColumnInfoList(Map<String,Object> formData);
	
	// 저장
	public String saveBuyerMpSoCartRemarkNameCard(Map<String,String>  formData);
}
