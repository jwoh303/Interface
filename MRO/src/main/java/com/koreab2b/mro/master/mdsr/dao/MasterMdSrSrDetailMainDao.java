package com.koreab2b.mro.master.mdsr.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdSrSrDetailMainDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,String>  param);

}
