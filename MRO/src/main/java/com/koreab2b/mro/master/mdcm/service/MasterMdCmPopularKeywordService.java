package com.koreab2b.mro.master.mdcm.service;

import java.util.Map;

public interface MasterMdCmPopularKeywordService {
	
	// 리스트조회
	public Map<String,String> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  param);
	
}
