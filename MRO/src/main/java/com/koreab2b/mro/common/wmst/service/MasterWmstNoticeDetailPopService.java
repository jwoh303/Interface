package com.koreab2b.mro.common.wmst.service;

import java.util.Map;

public interface MasterWmstNoticeDetailPopService {

	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData);
	
	//삭제
	public String deleteSelectedData(Map<String,String> formData);
}
