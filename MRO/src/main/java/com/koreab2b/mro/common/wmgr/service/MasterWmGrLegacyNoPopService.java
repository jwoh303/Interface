package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGrLegacyNoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	public List<Map<String, String>> getDetail(Map<String,String>  formData);
}
