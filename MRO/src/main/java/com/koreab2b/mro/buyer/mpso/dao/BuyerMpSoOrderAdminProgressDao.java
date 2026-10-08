package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoOrderAdminProgressDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	//엑셀 조회
	public List<Map<String,String>> selecExceltList(Map<String,String> formData);	
	// 부서별집계조회
	public List<Map<String,String>> selectOrderDeptList(Map<String,String> formData);
	// 협력사별집계조회
	public List<Map<String,String>> selectOrderAgentList(Map<String,String> formData);

}
