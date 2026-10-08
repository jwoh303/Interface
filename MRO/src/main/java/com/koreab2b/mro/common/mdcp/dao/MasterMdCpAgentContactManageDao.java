package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpAgentContactManageDao {
	
	// 협력사 목록 조회
	public List<Map<String,String>> getList(Map<String,Object> param);

	// 이메일/문자 발송내역 관리 조회
	public List<Map<String,String>> getAgentDmHistoryList(Map<String,Object> param);
	
	// 협력사 연락처 관리 이력 조회
	public List<Map<String,String>> getContactHistoryiList(Map<String,Object> param);
	
	// 수신처 정보 조회
	public List<Map<String,String>> getMasterMdCpAgentDmHistoryContactList(Map<String,Object> param);
}
