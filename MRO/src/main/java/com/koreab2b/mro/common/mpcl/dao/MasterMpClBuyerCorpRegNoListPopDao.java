package com.koreab2b.mro.common.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpClBuyerCorpRegNoListPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
