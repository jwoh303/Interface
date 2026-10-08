package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmContractSelPopDao {
	// 조회
	public List<Map<String,String>> getMasterMdCmContractSelPop(Map<String,String> formData);
}
