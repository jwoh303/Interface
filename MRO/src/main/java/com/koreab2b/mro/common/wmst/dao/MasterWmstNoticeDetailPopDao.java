package com.koreab2b.mro.common.wmst.dao;

import java.util.Map;

public interface MasterWmstNoticeDetailPopDao {
	
	// 상세
	public Map<String,String> selectDetail(Map<String,String> formData);
	
	//삭제
	public String deleteSelectedData(Map<String,String> formData);
}
