package com.koreab2b.mro.common.mdcd.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCdAgentCardInfoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 주요활동내용 조회
	public List<Map<String,String>> selectVisitList(Map<String, Object> formData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
}
