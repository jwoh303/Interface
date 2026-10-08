package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStAgingDao;

@Service("masterMpStAgingService")
public class MasterMpStAgingServiceImpl implements MasterMpStAgingService {
	
	@Autowired
	private MasterMpStAgingDao masterMpStAgingDao;

	@Override
	public List<Map<String, String>> getAgingList(Map<String, Object> pMap) {
		return masterMpStAgingDao.getAgingList(pMap);
	}

	@Override
	public List<Map<String, String>> getAgingDetail(Map<String, Object> pMap) {
		return masterMpStAgingDao.getAgingDetail(pMap);
	}

	@Override
	public List<Map<String, String>> getAgingItemMaster(Map<String, String> pMap) {
		return masterMpStAgingDao.getAgingItemMaster(pMap);
	}
}
