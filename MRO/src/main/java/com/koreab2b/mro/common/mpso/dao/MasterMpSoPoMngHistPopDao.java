package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoPoMngHistPopDao {
	
	// 리스트 조회
	public List<Map<String,String>> searchMasterMpSoPoMngHistList(Map<String,Object> param);
}
