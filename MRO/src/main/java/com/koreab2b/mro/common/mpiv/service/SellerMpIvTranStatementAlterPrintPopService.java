package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvTranStatementAlterPrintPopService {
	
	// 기본정보 조회
	public Map<String,String> getInfo(Map<String,String>  pMap);
	public Map<String,String> getInfo_v3(Map<String,String>  pMap);
	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap);
	public List<Map<String,String>> getCommonMpIvTranStatementDetailIVPop_v2(Map<String,Object> pMap);

	// 납품일 수정
	public String updateInvoiceDate(Map<String,String>  pMap);
	
	// 거래명세서 삭제
	public String deleleteTranStatement(Map<String,String>  pMap);
	
	
}
