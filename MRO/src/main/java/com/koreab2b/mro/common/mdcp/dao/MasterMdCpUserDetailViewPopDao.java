package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpUserDetailViewPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectApprovedList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectReferList(Map<String,String> formData);

	//저장
	public String updateSelectedData(Map<String,String> formData);
}
