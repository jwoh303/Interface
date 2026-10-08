package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

public interface MasterMdAmBuyerMbrcmpyRegService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 아이디 중복체크
	public String getIDCheck(Map<String,String>  formData);
	
	// 비밀번호 룰 적용
	public String getPwdValidCheck(Map<String,String>  formData);
		
	// 저장
	public Map<String, Object> updateSelectedData(Map<String,String>  formData);

}
