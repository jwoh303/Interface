package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderStandbyOrderReqDetailPopService {

	// 조회(헤더)
	public List<Map<String,String>> getHeader(Map<String, String> pMap);
	
	// 조회(상세)
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

}
