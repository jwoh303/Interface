package com.koreab2b.mro.common.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClTaxBillNoDetailPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	
}
