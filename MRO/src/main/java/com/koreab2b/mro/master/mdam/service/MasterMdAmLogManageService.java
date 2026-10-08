package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

public interface MasterMdAmLogManageService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 감사로그 기록 (KEPSITE_LOG)
	public void saveLog(Map<String,Object> param);

}
