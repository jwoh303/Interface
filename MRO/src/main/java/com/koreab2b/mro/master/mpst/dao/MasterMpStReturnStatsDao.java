package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpStReturnStatsDao {
	// 반품통계 전체 조회
	public List<Map<String,String>> getReturnStatsList(Map<String, Object> pMap);
	
	// 반품통계 고객사 조회
	public List<Map<String,String>> getReturnStatsBuyerList(Map<String, Object> pMap);
		
	// 반품통계 협력사 조회
	public List<Map<String,String>> getReturnStatsAgentList(Map<String, Object> pMap);
}
