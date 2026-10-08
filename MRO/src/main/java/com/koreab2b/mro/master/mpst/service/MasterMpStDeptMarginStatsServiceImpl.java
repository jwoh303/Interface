package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStDeptMarginStatsDao;

@Service("masterMpStDeptMarginStatsService")
public class MasterMpStDeptMarginStatsServiceImpl implements MasterMpStDeptMarginStatsService {
	
	@Autowired
	private MasterMpStDeptMarginStatsDao masterMpStDeptMarginStatsDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStDeptMarginStatsDao.selectList(param);
	}	
}
