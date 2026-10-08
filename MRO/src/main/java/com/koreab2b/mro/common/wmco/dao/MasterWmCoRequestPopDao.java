package com.koreab2b.mro.common.wmco.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmCoRequestPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

}
