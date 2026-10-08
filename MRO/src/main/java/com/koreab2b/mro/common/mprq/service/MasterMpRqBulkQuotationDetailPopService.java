package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.util.CommonUtil;

public interface MasterMpRqBulkQuotationDetailPopService {
	
	// 프로젝트 정보 불러오기
	public Map<String, String> getProject(Map<String, Object> formData);
	
	// 유의사항 조회 -- 3 SM, 4 AGENT
	// 고객사정보  -- 1
	// SG별 품목수  -- 2 
	public List<Map<String, String>> getSheet(Map<String, Object> formData);

	// 프로젝트 저장
	public String updateData(Map<String,String>  formData);
	
	// 유의사항 저장
	public String updateNoticeData(List<Object> gridData, Map<String, String> formData);

	// 고객사 코드 저장
	public String updateBuyerData(List<Object> gridData, Map<String, String> formData);


}
