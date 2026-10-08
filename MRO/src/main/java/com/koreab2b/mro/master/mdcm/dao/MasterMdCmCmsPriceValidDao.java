package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsPriceValidDao {

	// 목록 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

}
