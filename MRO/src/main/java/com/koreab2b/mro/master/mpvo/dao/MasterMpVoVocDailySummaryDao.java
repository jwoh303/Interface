package com.koreab2b.mro.master.mpvo.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocDailySummaryDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectListWeek(Map<String,String> param);
	
	// 리스트 조회
	public List<Map<String,String>> selectListToday(Map<String,String> param);

}
