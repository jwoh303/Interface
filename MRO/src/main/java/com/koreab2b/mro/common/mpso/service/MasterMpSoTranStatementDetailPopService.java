package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoTranStatementDetailPopService {
	
	// 상세정보
	public Map<String,String> getInfo(Map<String,String> formData);
	public Map<String,String> getInfo_v2(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData);
	
	// 물류센터 고객사 체크	
	public String getW001Flag(Map<String, String> pMap);

}
