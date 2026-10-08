package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStReturnStatsDao;

@Service("masterMpStReturnStatsService")
public class MasterMpStReturnStatsServiceImpl implements MasterMpStReturnStatsService {
	
	@Autowired
	private MasterMpStReturnStatsDao masterMpStReturnStatsDao;

	// 반품통계 조회
	public List<Map<String, String>> getReturnStatsList(Map<String, Object> pMap) {
		return masterMpStReturnStatsDao.getReturnStatsList(pMap);
	}
	
	// 반품통계 고객사 조회
	public List<Map<String, String>> getReturnStatsBuyerList(Map<String, Object> pMap) {
		return masterMpStReturnStatsDao.getReturnStatsBuyerList(pMap);
	}
	
	// 반품통계 협력사 조회
	public List<Map<String, String>> getReturnStatsAgentList(Map<String, Object> pMap) {
		return masterMpStReturnStatsDao.getReturnStatsAgentList(pMap);
	}
}
