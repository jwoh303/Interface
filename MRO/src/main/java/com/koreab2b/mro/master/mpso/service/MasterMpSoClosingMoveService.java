package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoClosingMoveService {
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoClosingMoveList(Map<String,Object>  param);
}
