package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocDailySummaryService {
	
	// 리스트조회
	public List<Map<String,String>> selectListWeek(Map<String,String>  param);
	
	// 리스트조회
	public List<Map<String,String>> selectListToday(Map<String,String>  param);

}
