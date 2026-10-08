package com.koreab2b.mro.master.mdcm.dao;

import java.util.Map;

public interface MasterMdCmPopularKeywordDao {
	
	// 리스트 조회
	public Map<String,String> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  param);

}
