package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpStBuyerResultDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 고객사 SG별 실적조회
	public List<Map<String,String>> selectBuyerSgList(Map<String,Object> param);
	// 협력사 SG별  실적조회
	public List<Map<String,String>> selectAgentSgList(Map<String,Object> param);
}
