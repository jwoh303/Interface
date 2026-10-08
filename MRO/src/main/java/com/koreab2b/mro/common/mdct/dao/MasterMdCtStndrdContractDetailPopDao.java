package com.koreab2b.mro.common.mdct.dao;

import java.util.Map;

public interface MasterMdCtStndrdContractDetailPopDao {

	// 조회
	public Map<String,String> selectList(Map<String,String> formData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData);
}
