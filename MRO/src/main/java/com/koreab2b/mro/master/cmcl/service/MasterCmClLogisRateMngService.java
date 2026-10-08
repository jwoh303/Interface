package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClLogisRateMngService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);
	
	// 삭제
	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData);
	
	// 예외기준 조회
	public List<Map<String, String>> getFeeList(Map<String, Object> pMap);


}
