package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqQuotationUnitpriceHistoryPopDao;

@Service("masterMpRqQuotationUnitpriceHistoryPopService")
public class MasterMpRqQuotationUnitpriceHistoryPopServiceImpl implements MasterMpRqQuotationUnitpriceHistoryPopService {
	
	@Autowired
	private MasterMpRqQuotationUnitpriceHistoryPopDao masterMpRqQuotationUnitpriceHistoryPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqQuotationUnitpriceHistoryPopDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getList2(Map<String,Object> formData) {
		return masterMpRqQuotationUnitpriceHistoryPopDao.selectList2(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getList3(Map<String,Object> formData) {
		return masterMpRqQuotationUnitpriceHistoryPopDao.selectList3(formData);
	}	
	

}
