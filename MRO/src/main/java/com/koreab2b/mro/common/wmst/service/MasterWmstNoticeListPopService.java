package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

public interface MasterWmstNoticeListPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData);
}
