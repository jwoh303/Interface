package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvMbrCmpyUserSearchPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
