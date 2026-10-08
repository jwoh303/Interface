package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClLogisRateDetailDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	public List<Map<String,String>> selectList_v2(Map<String,Object> param);
	
}
