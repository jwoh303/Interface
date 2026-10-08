package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoPoMngHistPopService {
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoPoMngHistList(Map<String,Object>  param);
}
