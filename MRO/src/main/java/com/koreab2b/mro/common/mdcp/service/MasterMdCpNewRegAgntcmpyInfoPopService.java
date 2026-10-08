package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCpNewRegAgntcmpyInfoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 조회
	public String getMdmList(Map<String,String>  formData);
		
	// 조회
	public List<Map<String,String>> getCmpyList(Map<String,Object>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData);
}
