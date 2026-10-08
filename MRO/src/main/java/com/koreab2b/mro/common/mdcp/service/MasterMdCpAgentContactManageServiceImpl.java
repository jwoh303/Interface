package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpAgentContactManageDao;

@Service("MasterMdCpAgentContactManageService")
public class MasterMdCpAgentContactManageServiceImpl implements MasterMdCpAgentContactManageService {
	
	@Autowired
	private MasterMdCpAgentContactManageDao masterMdCpAgentContactManageDao;
	
	// 협력사 연락처 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCpAgentContactManageDao.getList(param);
	}
	
	// 이메일/문자 발송내역 관리 조회
	public List<Map<String,String>> getAgentDmHistoryList(Map<String,Object> param) {
		return masterMdCpAgentContactManageDao.getAgentDmHistoryList(param);
	}
	
	// 협력사 연락처 관리 이력 조회
	public List<Map<String,String>> getContactHistoryiList(Map<String,Object> param) {
		return masterMdCpAgentContactManageDao.getContactHistoryiList(param);
	}

	// 수신처 정보 조회
	public List<Map<String,String>> getMasterMdCpAgentDmHistoryContactList(Map<String,Object> param) {
		return masterMdCpAgentContactManageDao.getMasterMdCpAgentDmHistoryContactList(param);
	}
}
