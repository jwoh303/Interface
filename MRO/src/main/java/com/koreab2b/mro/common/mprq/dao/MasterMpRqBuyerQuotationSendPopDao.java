package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerQuotationSendPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	public Map<String,String> saveBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData);
	//환율정보변경
	public Map<String,String> saveExpBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData);
}
