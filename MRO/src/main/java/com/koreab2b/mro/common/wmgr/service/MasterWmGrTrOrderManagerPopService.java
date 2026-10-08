package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;


public interface MasterWmGrTrOrderManagerPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	public List<Map<String,String>> getPop(Map<String, String> pMap);
}
