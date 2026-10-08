package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoAccountSelPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> selectDeptSelect(Map<String,String> formData);
	public List<Map<String,String>> selectAccountDivideList(Map<String,String> formData);
	
	

}
