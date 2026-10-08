package com.koreab2b.mro.common.mpiv.dao;

import java.util.Map;

public interface CommonMpIvOrderDetailInfoPopDao {

	// 조회
	public Map<String, String> selectList(Map<String,String> formData);
	public Map<String, String> selectList_v2(Map<String,String> formData);
}
