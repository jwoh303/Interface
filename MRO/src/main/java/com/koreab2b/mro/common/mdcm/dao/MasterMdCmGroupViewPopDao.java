package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmGroupViewPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
