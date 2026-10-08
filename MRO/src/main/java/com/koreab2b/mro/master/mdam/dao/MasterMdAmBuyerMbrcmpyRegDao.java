package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmBuyerMbrcmpyRegDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 아이디 중복체크
	public String selectIDCheck(Map<String,String> formData);
	
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData);
		
	// 저장
	public Map<String, Object> updateSelectedData(Map<String,String>  formData);
}
