package com.koreab2b.mro.common.mdcp.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpModuSignWebhookDao;

@Service("masterMdCpModuSignWebhookService")
public class MasterMdCpModuSignWebhookServiceImpl implements MasterMdCpModuSignWebhookService {
	
	@Autowired
	private MasterMdCpModuSignWebhookDao masterMdCpModuSignWebhookDao;
	
	// WEBHOOK 결과 상태 변경
	public String updateModuSignStatus(Map<String,String> formData) {
		return masterMdCpModuSignWebhookDao.updateModuSignStatus(formData);
	}
	
	// 재계약전송 후 DOC_ID 저장
	public String updateModuSignDocId(Map<String,String> formData) {
		return masterMdCpModuSignWebhookDao.updateModuSignDocId(formData);
	}
}
