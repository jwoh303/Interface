package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerDesignAgentService {
	
	// 조회
	public Map<String, String> getInfo(Map<String,String>  formData);
		
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);

}
