package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpStDeptNewCatlgStatsDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

}
