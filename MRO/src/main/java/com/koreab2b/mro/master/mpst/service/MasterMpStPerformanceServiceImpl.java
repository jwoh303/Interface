package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStPerformanceDao;

@Service("MasterMpStPerformanceService")
public class MasterMpStPerformanceServiceImpl implements MasterMpStPerformanceService{

	@Autowired
	private MasterMpStPerformanceDao masterMpStPaymentStatsDao;
	
	@Override
	public List<Map<String, String>> masterPerformanceList(Map<String, Object> pMap) {
		return masterMpStPaymentStatsDao.masterPerformanceList(pMap);
	}

	@Override
	public List<Map<String, String>> getAllDeptList(Map<String, String> pMap) {
		return masterMpStPaymentStatsDao.getAllDeptList(pMap);
	}

}
