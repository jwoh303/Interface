package com.koreab2b.mro.master.mpsm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSmClosingStatsDao {
	
	// 리스트조회
	public List<Map<String,String>> selectClosingStatsList(Map<String,Object>  param);
	
	// 차트용 리스트조회
	public List<Map<String,String>> selectClosingStatsList1(Map<String,Object>  param);
}
