package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpifExternDao {

	/**
	 * 고객사 디비 정보 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectBuyerIfDbInfo(Map<String, String> pMap);
}