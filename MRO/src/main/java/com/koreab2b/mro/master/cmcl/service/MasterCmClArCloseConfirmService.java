package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClArCloseConfirmService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 마감미제출자 리스트 조회
	public List<Map<String, String>> getPopList(Map<String, Object> param);
	public List<Map<String, String>> getPopList_v2(Map<String, Object> param);
	
	// 제출취소, 마감완료, 회계전송
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);
	

}
