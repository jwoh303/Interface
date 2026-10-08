package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpifPopDao;

@Service("masterMpifPopService")
public class MasterMpifPopServiceImpl implements MasterMpifPopService {
	
	@Autowired
	MasterMpifPopDao masterMpifPopDao;

	@Override
	public List<Map<String, String>> getIfMessage(Map<String, String> pMap) {
		return masterMpifPopDao.selectMasterMpifMessagePop(pMap);
	}
}