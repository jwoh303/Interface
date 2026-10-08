package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

public interface MasterWmStAssmblCmpntsttmntCreationPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	// 하단 조회
	public List<Map<String,String>> getBotList(Map<String,Object>  formData);
	
	//조립 부품생성 
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
