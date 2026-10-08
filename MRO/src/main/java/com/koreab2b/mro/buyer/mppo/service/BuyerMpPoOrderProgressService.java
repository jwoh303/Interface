package com.koreab2b.mro.buyer.mppo.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpPoOrderProgressService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 부서별 집계
	public List<Map<String,String>> getDeptTotalList(Map<String,String>  formData);

	// 협력사별 집계
	public List<Map<String,String>> getSuplTotalList(Map<String,String>  formData);
	
	// 관리번호별 집계
	public List<Map<String,String>> getRefTotalList(Map<String,String>  formData);
}
