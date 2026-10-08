package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmExcelCartPunchoutSearchDao {
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData);
	// 저장
	public String saveExcelUp(Map<String,String>  formData);
}
