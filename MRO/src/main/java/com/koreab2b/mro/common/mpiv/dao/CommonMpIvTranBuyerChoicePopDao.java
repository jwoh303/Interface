package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvTranBuyerChoicePopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap);
	public List<Map<String,String>> getCommonMpIvTranBuyerChoicePopList(Map<String,Object> pMap);
	
	// 물류조회
	public List<Map<String,String>> selecBptList(Map<String,String> pMap);	

}
