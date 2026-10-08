package com.koreab2b.mro.master.mpsm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSmStatsHomeDao {
	// 리스트조회
	public List<Map<String,String>> selectWarhsngResultList(Map<String,Object>  param);
}
