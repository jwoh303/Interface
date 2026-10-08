package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoProgressDao;
import com.koreab2b.mro.master.mpso.dao.MasterMpSoProgressDmSendPopDao;

@Service("masterMpSoProgressDmSendPopService")
public class MasterMpSoProgressDmSendPopServiceImpl implements MasterMpSoProgressDmSendPopService {
	
	@Autowired
	private MasterMpSoProgressDmSendPopDao masterMpSoProgressDmSendPopDao;

	@Override
	public List<Map<String, String>> getPoList(Map<String, Object> param) {
		return masterMpSoProgressDmSendPopDao.getPoList(param);
	}

	@Override
	public List<Map<String, String>> getUserList(Map<String, Object> param) {
		return masterMpSoProgressDmSendPopDao.getUserList(param);
	}

	@Override
	public String DmSend(Map<String, String> formData, List<Object> gridData) {
		return masterMpSoProgressDmSendPopDao.DmSend(formData, gridData);
	}

	
}
