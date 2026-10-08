package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClApCloseConfirmDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 제출취소, 회계전송
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);
	public String updateSelectedData_v2(Map<String, String> formData, List<Object> gridData);
	
}
