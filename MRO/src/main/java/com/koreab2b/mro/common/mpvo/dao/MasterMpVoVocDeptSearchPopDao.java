package com.koreab2b.mro.common.mpvo.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocDeptSearchPopDao {
	// 조회
	public List<Map<String,String>> getMasterMpVoVocDeptSearchPop(Map<String,Object> formData);
}
