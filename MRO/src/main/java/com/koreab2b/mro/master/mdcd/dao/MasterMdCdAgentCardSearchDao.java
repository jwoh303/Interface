package com.koreab2b.mro.master.mdcd.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCdAgentCardSearchDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
}
