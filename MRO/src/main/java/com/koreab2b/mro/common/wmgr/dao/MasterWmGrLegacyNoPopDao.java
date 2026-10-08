package com.koreab2b.mro.common.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGrLegacyNoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	public List<Map<String,String>> getDetail(Map<String,String> formData);
}
