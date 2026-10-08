package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmUniformProgressDao {
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
}
