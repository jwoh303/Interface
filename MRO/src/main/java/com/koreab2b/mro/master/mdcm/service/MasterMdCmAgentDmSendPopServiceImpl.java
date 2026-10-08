package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmAgentDmSendPopDao;

@Service("masterAgentDmSendPopService")
public class MasterMdCmAgentDmSendPopServiceImpl implements MasterMdCmAgentDmSendPopService {
	
	@Autowired
	private MasterMdCmAgentDmSendPopDao masterMdCmAgentDmSendPopDao;

	// 협력사 수신정보 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmAgentDmSendPopDao.selectList(param);
	}	

	// 메일 전송
	@Transactional
	public String saveMasterMdcmAgentDmSend(Map<String,String> formData, List<Object> gridData) {
		return masterMdCmAgentDmSendPopDao.saveMasterMdcmAgentDmSend(formData, gridData);
	}
	
	// 메일 수신여부 변경
	@Transactional
	public String saveMailRecv(Map<String,String> formData) {
		return masterMdCmAgentDmSendPopDao.saveMailRecv(formData);
	}

	// 협력사 dm 발송 이슈 정보 취득
	public List<Map<String,String>> getAgentDmIssueList(Map<String,Object> param) {
		return masterMdCmAgentDmSendPopDao.getAgentDmIssueList(param);
	}
	
	// 협력사 dm 발송 템플릿 목록 취득
	public List<Map<String,String>> getDmSendTemplateList(Map<String,Object> param) {
		return masterMdCmAgentDmSendPopDao.getDmSendTemplateList(param);
	}

}
