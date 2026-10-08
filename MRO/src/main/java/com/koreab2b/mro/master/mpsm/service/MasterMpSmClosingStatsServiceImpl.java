package com.koreab2b.mro.master.mpsm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpsm.dao.MasterMpSmClosingStatsDao;

@Service("masterMpSmClosingStatsService")
public class MasterMpSmClosingStatsServiceImpl  implements MasterMpSmClosingStatsService {
	
	@Autowired
	private MasterMpSmClosingStatsDao masterMpSmClosingStatsDao;

	// 리스트조회
	public List<Map<String,String>> getClosingStatsList(Map<String,Object>  param) {
		return masterMpSmClosingStatsDao.selectClosingStatsList(param);
	}
	
	// 차트용 리스트조회
	public List<Map<String,String>> getClosingStatsList1(Map<String,Object>  param) {
		return masterMpSmClosingStatsDao.selectClosingStatsList1(param);
	}
}
