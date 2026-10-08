package com.koreab2b.mro.common.wmst.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmStAssmblCmpntsttmntCreationPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 하단 조회
	public List<Map<String,String>> selectBotList(Map<String,Object> formData);
	
	//조립 부품생성 
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
