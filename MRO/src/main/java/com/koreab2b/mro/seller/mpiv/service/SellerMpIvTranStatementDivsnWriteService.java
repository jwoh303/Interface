package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvTranStatementDivsnWriteService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap);
	
	// 저장
	public Map<String, String> saveSellerMpIvTranStatementDivsnWrite(Map<String,String> pMap);
}
