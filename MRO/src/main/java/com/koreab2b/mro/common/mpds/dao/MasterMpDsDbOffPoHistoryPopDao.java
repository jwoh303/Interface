package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpDsDbOffPoHistoryPopDao {	 
	public List<Map<String,String>> selectList(Map<String,Object>  pMap);
	
}
