package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvTranStatementPrintDeleteService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  pMap);
	
	public List<Map<String,String>> getExcelList(Map<String,String> pMap);
}
