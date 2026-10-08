package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationDmSendPopDao {
	
	// 메일 전송
	public String saveMasterMpRqAgentDmSend(Map<String,String> formData, List<Object> gridData);
}
