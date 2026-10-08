package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

public interface MasterMdCmAgentContactMngPopService {
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 협력사 연락처 저장
	public String saveMasterMdcmAgentContactMngPop(Map<String,String> formData, List<Object> gridData);
}
