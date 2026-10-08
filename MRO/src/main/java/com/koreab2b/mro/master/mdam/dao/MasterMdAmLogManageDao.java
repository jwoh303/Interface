package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmLogManageDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 감사로그 기록 (KEPSITE_LOG)
	public void saveLog(Map<String,Object> param);

}
