package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpDsProductPlanViewPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

}
