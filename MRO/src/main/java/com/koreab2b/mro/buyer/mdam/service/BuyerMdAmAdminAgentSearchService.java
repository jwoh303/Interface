package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmAdminAgentSearchService {
	//조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	//신규협력사조회
	public List<Map<String,String>> getNewAgentList(Map<String,String>  formData);
	//조회
	public List<Map<String,String>> getExcelList(Map<String,String>  formData);
	//협력사조회
	public List<Map<String,String>> getAgentInfo(Map<String,String>  formData);
	//발주실적조회
	public List<Map<String,String>> getAgentPoInfo(Map<String,String>  formData);
	//납기조회
	public List<Map<String,String>> getAgentDlvryInfo(Map<String,String>  formData);
}
