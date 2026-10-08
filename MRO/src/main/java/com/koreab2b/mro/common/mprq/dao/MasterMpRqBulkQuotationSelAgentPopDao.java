package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationSelAgentPopDao {
	
	// 협력사 조회
	public List<Map<String, String>> selectdata(Map<String, String> param);

	// 협력사 조회
	public List<Map<String, String>> selectdata2(Map<String, String> param);

	// 우선 협력사 삭제
	public String deletedata(Map<String, String> formData , List<Object> gridData);

	// 우선 협력사 저장
	public String insertdata(Map<String, String> formData , List<Object> gridData);
	
	// 견적에 선택 협력사 추가
	public String insertRfqdata(Map<String, String> formData, List<Object> gridData);
}
