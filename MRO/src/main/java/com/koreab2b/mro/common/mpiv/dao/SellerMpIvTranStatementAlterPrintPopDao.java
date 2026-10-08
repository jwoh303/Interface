package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvTranStatementAlterPrintPopDao {
	
	// 기본정보 조회
	public List<Map<String, String>> selectInfo(Map<String,String>  pMap);
	public List<Map<String, String>> selectInfo_v3(Map<String,String>  pMap);
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap);
	public List<Map<String,String>> getCommonMpIvTranStatementDetailIVPop_v2(Map<String,Object> pMap);
	
	// 납품일 수정
	public String updateInvoiceDate(Map<String,String>  pMap);
	
	// 거래명세서 삭제
	public String deleteTranStatement(Map<String,String>  pMap);

}
