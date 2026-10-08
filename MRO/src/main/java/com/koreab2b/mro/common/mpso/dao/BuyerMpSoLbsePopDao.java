package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

public interface BuyerMpSoLbsePopDao {
	// 조회
	public String getLbseCostCode(Map<String,String>  formData);
	public String getLbseAccountCode(Map<String, String> formData);
}
