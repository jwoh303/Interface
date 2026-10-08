package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

public interface BuyerMpSoLotteFoodPopDao {

	// 조회
	public String  selectDeptName(Map<String,String>  formData);
	public String  selectAccountName(Map<String,String>  formData);
}
