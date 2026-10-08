package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.util.CommonUtil;

public interface MasterMpRqBulkQuotationSelAgentPopService {
	
	// 협력사 조회 
	public List<Map<String, String>> getMasterMpRqBulkQuotationSelAgent(Map<String, String> param);

	// 우선 협력사 삭제
	public String delMasterMpRqBulkQuotationSelAgent(Map<String, String> formData, List<Object> gridData);

	// 우선 협력사 조회
	public List<Map<String, String>> getMasterMpRqBulkQuotationSelAgent2(Map<String, String> formData);

	// 우선 협력사 등록
	public String saveMasterMpRqBulkQuotationSelAgent(Map<String, String> formData, List<Object> gridData);

	// 견적에 선택 협력사 추가
	public String saveMasterMpRqBulkQuotationSelAgentPopRFQ(Map<String, String> formData, List<Object> gridData);


}
