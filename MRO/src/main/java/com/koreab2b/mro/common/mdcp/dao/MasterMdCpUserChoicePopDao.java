package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpUserChoicePopDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
}
