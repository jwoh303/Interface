package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqDssSellerSelDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	public List<Map<String, String>> getDssAgent(Map<String,String>  pMap);
}
