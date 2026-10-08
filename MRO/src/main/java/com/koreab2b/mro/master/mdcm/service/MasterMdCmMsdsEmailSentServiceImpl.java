package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmMsdsEmailSentDao;

@Service("masterMdCmMsdsEmailSentService")
public class MasterMdCmMsdsEmailSentServiceImpl implements MasterMdCmMsdsEmailSentService {
	
	@Autowired
	private MasterMdCmMsdsEmailSentDao masterMdCmMsdsEmailSentDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmMsdsEmailSentDao.selectList(param);
	}	
}
