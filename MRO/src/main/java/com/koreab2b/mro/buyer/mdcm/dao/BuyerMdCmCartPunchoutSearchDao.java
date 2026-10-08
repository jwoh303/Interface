package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmCartPunchoutSearchDao {

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData);
	// 저장
	public String saveBuyerMdCmCartQtyPunchOut(Map<String,String> formData);
	// 저장
	public String deleteBuyerMdCmCartListPunchOut(Map<String,String> formData);
}
