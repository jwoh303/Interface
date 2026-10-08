package com.koreab2b.mro.common.mdct.service;

import java.util.Map;

public interface MasterMdCtStndrdContractDetailPopService {
	// 조회
	public Map<String,String> getList(Map<String,String>  formData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData);
}
