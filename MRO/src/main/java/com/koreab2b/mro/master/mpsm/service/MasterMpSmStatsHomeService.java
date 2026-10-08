package com.koreab2b.mro.master.mpsm.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSmStatsHomeService {
	// 리스트조회
	public List<Map<String,String>> getWarhsngResultList(Map<String,Object>  param);
}
