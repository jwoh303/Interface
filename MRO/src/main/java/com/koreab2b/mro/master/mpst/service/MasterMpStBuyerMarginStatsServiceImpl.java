package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStBuyerMarginStatsDao;

@Service("masterMpStBuyerMarginStatsService")
public class MasterMpStBuyerMarginStatsServiceImpl implements MasterMpStBuyerMarginStatsService {
	
	@Autowired
	private MasterMpStBuyerMarginStatsDao masterMpStBuyerMarginStatsDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStBuyerMarginStatsDao.selectList(param);
	}	
}
