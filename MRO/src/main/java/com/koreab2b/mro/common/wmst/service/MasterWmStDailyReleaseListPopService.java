package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

public interface MasterWmStDailyReleaseListPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	public List<Map<String,String>> getExcelList(Map<String,Object>  formData);
}
