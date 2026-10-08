package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCategoryTotalViewPopService {
	// 카테고리 합계보기 조회
	public List<Map<String,String>> getCategoryListSelectPop(Map<String,String>  formData);
	
	// 예산조회
	public List<Map<String,String>> getBuyerAdminBudgetListSql(Map<String,String>  formData);

}
