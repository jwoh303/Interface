package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmAgentContactMngPopDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 협력사 연락처 저장
	public String saveMasterMdcmAgentContactMngPop(Map<String,String> formData, List<Object> gridData);
}
