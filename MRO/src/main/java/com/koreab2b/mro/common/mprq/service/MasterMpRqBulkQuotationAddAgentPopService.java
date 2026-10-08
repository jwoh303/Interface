package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.util.CommonUtil;

public interface MasterMpRqBulkQuotationAddAgentPopService {
	
	// 품목정보 조회
	public Map<String, String> getItem(Map<String, String> pMap);
	
	// 협력사 조회
	public List<Map<String, String>> getMasterMpRqBulkQuotationAddAgent(Map<String, String> param);

	// 협력사 삭제
	public String delMasterMpRqBulkQuotationAddAgent(Map<String, String> formData, List<Object> gridData);

	// 진행현황
	public List<Map<String, String>> getMasterMpRqBulkQuotationAddAgentListPop(Map<String, String> formData);


}
