package com.koreab2b.mro.common.wmst.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmStDailyReleaseListPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	
	public List<Map<String,String>> getExcelList(Map<String,Object> formData);
}
