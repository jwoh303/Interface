package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

public interface MasterMdCmAgentDmSendPopService {
	
	// 협력사 수신정보 조회
	public List<Map<String,String>> getList(Map<String,Object> param);

	// 메일수신여부 변경
	public String saveMailRecv(Map<String,String> formData);
	
	// 메일 전송
	public String saveMasterMdcmAgentDmSend(Map<String,String> formData, List<Object> gridData);
	
	// 협력사 dm 발송 이슈 정보 취득
	public List<Map<String,String>> getAgentDmIssueList(Map<String,Object> param);
	
	// 협력사 dm 발송 템플릿 목록 취득
	public List<Map<String,String>> getDmSendTemplateList(Map<String,Object> param);
	
	
}
