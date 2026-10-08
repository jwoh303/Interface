package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmMsdsEmailSentDao {
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
}
