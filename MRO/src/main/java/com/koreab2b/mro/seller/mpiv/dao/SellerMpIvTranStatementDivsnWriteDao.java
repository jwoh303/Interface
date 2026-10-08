package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvTranStatementDivsnWriteDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap);
	
	// 저장
	public Map<String, String> saveSellerMpIvTranStatementDivsnWrite(Map<String,String> pMap);
}
