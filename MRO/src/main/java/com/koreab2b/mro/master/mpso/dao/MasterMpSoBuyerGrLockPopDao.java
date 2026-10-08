package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoBuyerGrLockPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 입고잠금
	public String updateGrLock(Map<String, String> formData);
}