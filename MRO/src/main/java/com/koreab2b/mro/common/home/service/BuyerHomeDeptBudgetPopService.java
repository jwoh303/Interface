package com.koreab2b.mro.common.home.service;

import java.util.List;
import java.util.Map;

public interface BuyerHomeDeptBudgetPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	public List<Map<String,String>> getList_v2(Map<String,Object>  formData);
}
