package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoUniformChoicePopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	// 저장
	public String updateSelectedData(Map<String,String>  formData);
}
