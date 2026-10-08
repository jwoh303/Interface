package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderStandbyOrderReqDetailPopDao {

	// 조회(헤더)
	public List<Map<String,String>> selectHeader(Map<String,String> formData);
	// 조회(상세)
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	//저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

}
