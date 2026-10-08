package com.koreab2b.mro.buyer.mppo.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpPoOrderProgressDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	 
	// 부서별 집계
	public List<Map<String,String>> selectDeptTotalList(Map<String,String> formData);
	
	// 협력사별 집계
	public List<Map<String,String>> selectSuplTotalList(Map<String,String> formData);
	
	// 관리번호별 집계
	public List<Map<String,String>> selectRefTotalList(Map<String,String> formData);
}
