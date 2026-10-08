package com.koreab2b.mro.common.mpvo.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocCompanyPopDao {
	// 조회
	public List<Map<String,String>> getMasterMpVoVocCompanyPop(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocAgntcmpyPop(Map<String,Object> formData);
}
