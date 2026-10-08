package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface CommonMpIvTranBuyerChoicePopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  pMap);
	public List<Map<String,String>> getCommonMpIvTranBuyerChoicePopList(Map<String,Object>  pMap);
	
	// 물류선택조회
	public List<Map<String,String>> getBpList(Map<String,String>  pMap);
}
