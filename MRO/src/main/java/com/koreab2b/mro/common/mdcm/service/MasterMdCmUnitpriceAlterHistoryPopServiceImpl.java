package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmUnitpriceAlterHistoryPopDao;

@Service("masterMdCmUnitpriceAlterHistoryPopService")
public class MasterMdCmUnitpriceAlterHistoryPopServiceImpl implements MasterMdCmUnitpriceAlterHistoryPopService {
	
	@Autowired
	private MasterMdCmUnitpriceAlterHistoryPopDao masterMdCmUnitpriceAlterHistoryPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmUnitpriceAlterHistoryPopDao.selectList(formData);
	}	
	

}
