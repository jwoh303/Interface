package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStDeptCatlgStatsDao;

@Service("masterMpStDeptCatlgStatsService")
public class MasterMpStDeptCatlgStatsServiceImpl implements MasterMpStDeptCatlgStatsService {
	
	@Autowired
	private MasterMpStDeptCatlgStatsDao masterMpStDeptCatlgStatsDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStDeptCatlgStatsDao.selectList(param);
	}	
}
