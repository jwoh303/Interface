package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoTranStatementDetailPopDao {

	// 상세정보
	public Map<String,String> selectInfo(Map<String,String> formData);
	public Map<String,String> selectInfo_v2(Map<String,String> formData);

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 물류센터 고객사 체크
	public String getW001Flag(Map<String, String> pMap);

}
