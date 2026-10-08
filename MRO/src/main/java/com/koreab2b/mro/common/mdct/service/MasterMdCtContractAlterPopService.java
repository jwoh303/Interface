package com.koreab2b.mro.common.mdct.service;

import java.util.Map;

public interface MasterMdCtContractAlterPopService {
	
	// 조회
	public Map<String,String> getList(Map<String,String>  formData);
	
	//저장
	public String updateSelectedData(Map<String,String> formData);
}
