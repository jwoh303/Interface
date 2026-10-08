package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCdAgentCardInfoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 주요활동내역 조회
	public List<Map<String,String>> getVisitList(Map<String, Object>  formData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
}
