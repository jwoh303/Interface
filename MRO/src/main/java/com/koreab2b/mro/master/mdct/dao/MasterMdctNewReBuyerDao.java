package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdctNewReBuyerDao {
	
	// 전체 조회
	public List<Map<String,String>> selectAllList(Map<String,Object> param);
	
	// 개인 조회
	public List<Map<String,String>> selectIndvList(Map<String,Object> param);
}