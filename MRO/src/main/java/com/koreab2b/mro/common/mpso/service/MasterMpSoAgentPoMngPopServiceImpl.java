package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoAgentPoMngPopDao;

@Service("masterMpSoAgentPoMngPopService")
public class MasterMpSoAgentPoMngPopServiceImpl implements MasterMpSoAgentPoMngPopService {
	@Autowired
	private MasterMpSoAgentPoMngPopDao masterMpSoAgentPoMngPopDao;
	
	// 조회
	public List<Map<String,String>> getAgentPoMngList(Map<String,Object> param) {
		return masterMpSoAgentPoMngPopDao.selectAgentPoMngList(param);
	}
}
