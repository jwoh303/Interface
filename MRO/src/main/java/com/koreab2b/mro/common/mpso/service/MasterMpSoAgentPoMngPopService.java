package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoAgentPoMngPopService {
	// 조회
	public List<Map<String,String>> getAgentPoMngList(Map<String,Object>  param);
}