package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvOdrreqDetailPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> selectList_v2(Map<String,String> formData);
	public List<Map<String,String>> selectBuyerPrDisplayDtListPop(Map<String,String> formData);
	public List<Map<String,String>> getBuyerPrDisplayDtListPop_v2(Map<String,String> formData);
}
