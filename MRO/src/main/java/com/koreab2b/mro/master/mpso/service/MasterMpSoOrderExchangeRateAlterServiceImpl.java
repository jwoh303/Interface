package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoOrderExchangeRateAlterDao;

@Service("masterMpSoOrderExchangeRateAlterService")
public class MasterMpSoOrderExchangeRateAlterServiceImpl implements MasterMpSoOrderExchangeRateAlterService {
	
	@Autowired
	private MasterMpSoOrderExchangeRateAlterDao masterMpSoOrderExchangeRateAlterDao;

	
	// 리스트조회 ( 일괄)
	public List<Map<String,String>> getMasterMpSoOrderExchangeRateList(Map<String,Object>  param) {
		return masterMpSoOrderExchangeRateAlterDao.getMasterMpSoOrderExchangeRateList(param);
	}
	
	// 저장  ( 일괄)
	@Transactional
	public String saveMasterMpSoOrderExchangeRateList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderExchangeRateAlterDao.saveMasterMpSoOrderExchangeRateList(formData, gridData);
	}
	
	// 삭제 ( 일괄)
	@Transactional
	public String delMasterMpSoOrderExchangeRateList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderExchangeRateAlterDao.delMasterMpSoOrderExchangeRateList(formData, gridData);
	}
	
	
}
