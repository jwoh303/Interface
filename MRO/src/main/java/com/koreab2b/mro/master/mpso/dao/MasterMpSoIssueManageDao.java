package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoIssueManageDao {
	
	// 리스트 조회
	public List<Map<String,String>> searchMasterMpSoIssueManageList(Map<String,Object> param);
}
