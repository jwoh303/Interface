package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmMsdsMailSendPopDao;

@Service("masterMdCmMsdsMailSendPopService")
public class MasterMdCmMsdsMailSendPopServiceImpl implements MasterMdCmMsdsMailSendPopService {
	
	@Autowired
	private MasterMdCmMsdsMailSendPopDao masterMdCmMsdsMailSendPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmMsdsMailSendPopDao.selectList(param);
	}	

	// 메일 전송
	@Transactional
	public String saveMasterMdcmMsdsMailSend(Map<String,String> formData, List<Object> gridData) {
		return masterMdCmMsdsMailSendPopDao.saveMasterMdcmMsdsMailSend(formData, gridData);
	}
	
	// 메일 수신여부 변경
	@Transactional
	public String saveMailRecv(Map<String,String> formData) {
		return masterMdCmMsdsMailSendPopDao.saveMailRecv(formData);
	}
}
