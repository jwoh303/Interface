package com.koreab2b.mro.common.wmst.service;

import java.util.Map;

public interface MasterWmstNoticeWritePopService {

	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData);
	
	// 물류센터코드
	public Map<String,String> getWarehouseCode(Map<String,String>  formData);
	
	//저장
	public String updateSelectedData(Map<String,String> formData);

}
