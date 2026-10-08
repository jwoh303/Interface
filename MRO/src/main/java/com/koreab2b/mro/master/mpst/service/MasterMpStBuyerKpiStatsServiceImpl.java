package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStBuyerKpiStatsDao;

@Service("masterMpStBuyerKpiStatsService")
public class MasterMpStBuyerKpiStatsServiceImpl implements MasterMpStBuyerKpiStatsService {
	
	@Autowired
	private MasterMpStBuyerKpiStatsDao masterMpStBuyerKpiStatsDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStBuyerKpiStatsDao.selectList(param);
	}	
}
