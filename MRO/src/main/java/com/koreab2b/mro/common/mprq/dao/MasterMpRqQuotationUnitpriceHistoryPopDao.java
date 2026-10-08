package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationUnitpriceHistoryPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 조회
	public List<Map<String,String>> selectList2(Map<String,Object> formData);

	// 조회
	public List<Map<String,String>> selectList3(Map<String,Object> formData);

}
