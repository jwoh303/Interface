package com.koreab2b.mro.common.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtBuyerReContractPopDao {
	
	// 팝업 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 저장
	public String saveSelectedData(Map<String,String> formData);
}
