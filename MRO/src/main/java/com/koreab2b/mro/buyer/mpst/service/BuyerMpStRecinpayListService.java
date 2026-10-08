package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpStRecinpayListService {
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 사용자 조회
	public List<Map<String,String>> getUserList(Map<String,String>  formData);
	
	// 부서 조회
	public List<Map<String,String>> getDeptList(Map<String,String>  formData);
	
}
