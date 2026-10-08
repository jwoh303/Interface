package com.koreab2b.mro.master.mdam.dao;

import java.util.List;

import java.util.Map;

public interface MasterMdAmMsdsDao {
	
	// 리스트 조회 , 엑셀다운로드 
	public List<Map<String,String>> selectList(Map<String,Object> param);

}
