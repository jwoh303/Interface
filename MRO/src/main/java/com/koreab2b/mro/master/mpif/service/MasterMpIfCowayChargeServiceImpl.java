package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfCowayChargeDao;

@Service("masterMpIfCowayChargeService")
public class MasterMpIfCowayChargeServiceImpl implements MasterMpIfCowayChargeService {

	@Autowired
	private MasterMpIfCowayChargeDao masterMpIfCowayChargeDao;

	@Override
	public List<Map<String, String>> getCowayChargeList(Map<String, Object> pMap) {
		return masterMpIfCowayChargeDao.selectCowayChargeList(pMap);
	}

	@Override
	public String batchMasterMpIfCowayChargeList(List<Object> pGridData) {
		return masterMpIfCowayChargeDao.insertMasterMpIfCowayChargeList(pGridData);
	}

	@Override
	public String delMasterMpIfCowayChargeList(List<Object> pGridData) {
		return masterMpIfCowayChargeDao.deleteMasterMpIfCowayChargeList(pGridData);
	}

}
