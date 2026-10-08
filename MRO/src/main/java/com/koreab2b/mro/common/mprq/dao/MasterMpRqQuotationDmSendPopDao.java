package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationDmSendPopDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> pMap);
	
	// 템플릿 조회
	public List<Map<String,String>> selectTemplateList(Map<String,Object> pMap);
	
	// 견적정비 DM 발송
	public String saveMasterMpRqQuotationDmSend(Map<String,String> formData, List<Object> gridData);
}
