package com.koreab2b.mro.common.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtStndrdContractWritePopDao {

	// 조회
	public Map<String,String> selectList(Map<String,String> formData);
	
	//저장
	public String updateSelectedData(Map<String,String> formData);

}
