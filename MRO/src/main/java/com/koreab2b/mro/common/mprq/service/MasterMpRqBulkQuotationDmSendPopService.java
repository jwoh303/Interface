package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;


public interface MasterMpRqBulkQuotationDmSendPopService {
	
	// 메일 전송
	public String saveMasterDmSend(Map<String,String> formData, List<Object> gridData);
	
	
}
