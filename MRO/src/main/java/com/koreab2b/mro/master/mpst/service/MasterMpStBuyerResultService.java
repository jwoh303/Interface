package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStBuyerResultService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 고객사 SG별 실적조회
	public List<Map<String,String>> getBuyerSgList(Map<String,Object>  param);
	// 협력사 SG별 실적조회
	public List<Map<String,String>> getAgentSgList(Map<String,Object>  param);

}
