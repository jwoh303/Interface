package com.koreab2b.mro.master.mpsm.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSmClosingStatsService {

	// 리스트조회
	public List<Map<String,String>> getClosingStatsList(Map<String,Object>  param);
	
	// 차트용 리스트조회
	public List<Map<String,String>> getClosingStatsList1(Map<String,Object>  param);
}
