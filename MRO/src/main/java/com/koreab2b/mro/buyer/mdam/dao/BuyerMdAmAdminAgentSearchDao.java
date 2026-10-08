package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmAdminAgentSearchDao {
	//조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	//신규협력사
	public List<Map<String,String>> selectNewAgentList(Map<String,String> formData);
	//엑셀다운
	public List<Map<String,String>> selectExcelList(Map<String,String> formData);
	//협력사정보
	public List<Map<String,String>> selectAgentInfo(Map<String,String> formData);
	//발주거래실적
	public List<Map<String,String>> selectAgentPoInfo(Map<String,String> formData);
	//납기실적
	public List<Map<String,String>> selectAgentDlvryInfo(Map<String,String> formData);
}
