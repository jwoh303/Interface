package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfDivsnPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getDivsnList(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
		
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
}
