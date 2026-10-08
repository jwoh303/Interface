package com.koreab2b.mro.common.mdcp.service;

import java.util.Map;

public interface MasterMdCpModuSignWebhookService {
	
	// WEBHOOK 결과 상태 변경
	public String updateModuSignStatus(Map<String,String>  formData);

	// 재계약전송 후 DOC_ID 저장
	public String updateModuSignDocId(Map<String,String>  formData);
}
