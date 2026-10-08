package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpStRecinpayListDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 사용자 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData);
	
	// 부서 조회
	public List<Map<String,String>> selectDeptList(Map<String,String> formData);
}
