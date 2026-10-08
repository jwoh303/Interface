package com.koreab2b.mro.common.mpvo.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocUserSearchPopDao {
	// 조회
	public List<Map<String,String>> getMasterMpVoVocUserSearchPop(Map<String,Object> formData);
}
