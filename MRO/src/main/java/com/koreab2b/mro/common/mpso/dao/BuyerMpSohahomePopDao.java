package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

public interface BuyerMpSohahomePopDao {
	// 조회
	public String gethahomeCostCode(Map<String,String>  formData);
	public String gethahomeAccountCode(Map<String, String> formData);
}
