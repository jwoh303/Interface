package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtBuyerReContractPopService {
	
	// 팝업 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 저장
	public String saveSelectedData(Map<String,String>  formData);
}
