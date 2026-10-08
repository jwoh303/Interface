package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationNewProjectPopDao {
	
	// 신규 프로젝트 저장
	public Map<String, Object> insertData(Map<String,String>  formData);
	
	// 유의사항 저장
	public String insertNoticeData(List<Object> gridData, Map<String, String> formData);

	// 고객사 코드 저장
	public String insertBuyerData(List<Object> gridData, Map<String, String> formData);

}
