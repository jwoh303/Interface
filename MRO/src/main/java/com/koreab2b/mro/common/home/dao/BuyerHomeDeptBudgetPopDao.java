package com.koreab2b.mro.common.home.dao;

import java.util.List;
import java.util.Map;

public interface BuyerHomeDeptBudgetPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	public List<Map<String,String>> selectList_v2(Map<String,Object> formData);
}
