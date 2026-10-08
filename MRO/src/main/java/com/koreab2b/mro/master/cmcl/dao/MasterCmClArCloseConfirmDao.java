package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClArCloseConfirmDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 마감 미제출자 리스트 조회
	public List<Map<String, String>> selectPopList(Map<String, Object> param);
	public List<Map<String, String>> selectPopList_v2(Map<String, Object> param);

	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);	

}
