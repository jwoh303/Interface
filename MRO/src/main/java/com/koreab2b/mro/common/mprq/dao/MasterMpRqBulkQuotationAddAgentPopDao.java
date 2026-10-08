package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationAddAgentPopDao {
	
	// 품목정보 조회
	public Map<String, String> selectItem(Map<String, String> param);
	
	// 협력사 조회
	public List<Map<String, String>> selectdata(Map<String, String> param);

	// 협력사 삭제
	public String deletedata(Map<String, String> formData , List<Object> gridData);

	// 진행현황
	public List<Map<String, String>> selectListdata(Map<String, String> param);

}
