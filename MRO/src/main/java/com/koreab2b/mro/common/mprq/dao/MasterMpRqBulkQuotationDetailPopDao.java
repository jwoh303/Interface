package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationDetailPopDao {
	
	// 프로젝트 조회
	public Map<String, String> getProject(Map<String, Object> formData);
	
	// 유의사항 조회
	public List<Map<String, String>> getSheet(Map<String, Object> formData);
	
	// 프로젝트 저장
	public String updateData(Map<String,String>  formData);
	
	// 유의사항 저장
	public String updateNoticeData(List<Object> gridData, Map<String, String> formData);

	// 고객사코드 저장
	public String updateBuyerData(List<Object> gridData, Map<String, String> formData);


}
