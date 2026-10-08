package com.koreab2b.mro.common.mdam.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmBudgetDepartmentChoicePopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
