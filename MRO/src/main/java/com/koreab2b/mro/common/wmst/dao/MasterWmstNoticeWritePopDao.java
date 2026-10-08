package com.koreab2b.mro.common.wmst.dao;

import java.util.Map;

public interface MasterWmstNoticeWritePopDao {
	
	// 상세
	public Map<String,String> selectDetail(Map<String,String> formData);
	
	// 물류센터코드
	public Map<String,String> selectWarehouseCode(Map<String,String> formData);
		
	//저장
	public String updateSelectedData(Map<String,String> formData);

}
