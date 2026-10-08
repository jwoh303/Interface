package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpNewRegAgntcmpyInfoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 조회
	public String selectMdmList(Map<String,String> formData);
		
	// 조회
	public List<Map<String,String>> selectCmpyList(Map<String,Object> formData);
	
	// 조회
	public String updateSelectedData(Map<String,String> formData);

}
