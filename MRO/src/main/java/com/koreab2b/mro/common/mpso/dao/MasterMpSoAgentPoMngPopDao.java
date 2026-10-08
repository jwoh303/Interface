package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoAgentPoMngPopDao {
	// 조회
	public List<Map<String,String>> selectAgentPoMngList(Map<String,Object> param);
}
