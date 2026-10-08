package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpCompyDetailViewPopDao {
	
	// 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData);
	
	//조회
	public List<Map<String,String>> selectCompyList(Map<String,String> formData);
		
}
