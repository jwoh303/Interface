package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmAgentContactMngPopDao;

@Service("masterAgentContactMngPopService")
public class MasterMdCmAgentContactMngPopServiceImpl implements MasterMdCmAgentContactMngPopService {
	
	@Autowired
	private MasterMdCmAgentContactMngPopDao masterMdCmAgentContactMngPopDao;
	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmAgentContactMngPopDao.selectList(param);
	}

	// 협력사 연락처 설정 저장
	@Transactional
	public String saveMasterMdcmAgentContactMngPop(Map<String,String> formData, List<Object> gridData) {
		return masterMdCmAgentContactMngPopDao.saveMasterMdcmAgentContactMngPop(formData, gridData);
	}
}
