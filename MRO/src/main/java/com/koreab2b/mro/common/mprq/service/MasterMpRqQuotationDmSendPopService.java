package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationDmSendPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 템플릿 조회
	public List<Map<String,String>> getTemplateList(Map<String,Object>  formData);
	
	// 견적정비 DM 발송
	public String saveMasterMpRqQuotationDmSend(Map<String,String> formData, List<Object> gridData);
}
