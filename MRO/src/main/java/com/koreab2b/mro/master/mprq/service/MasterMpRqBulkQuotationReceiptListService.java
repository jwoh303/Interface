package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationReceiptListService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 임시저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);
	
	// 견적마감
	public String updateData(Map<String,Object>  param);
	
	// 견적마감취소
	public String updateData2(Map<String,Object>  param);
	
	// 견적요청
	public String orderData(Map<String, String> formData, List<Object> gridData);

	// 견적마감일 변경
	public String updateDateData(Map<String, String> formData, List<Object> gridData);

}
