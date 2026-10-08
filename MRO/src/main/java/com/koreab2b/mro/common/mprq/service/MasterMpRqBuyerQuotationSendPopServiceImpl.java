package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBuyerQuotationSendPopDao;

@Service("masterMpRqBuyerQuotationSendPopService")
public class MasterMpRqBuyerQuotationSendPopServiceImpl implements MasterMpRqBuyerQuotationSendPopService {
	
	@Autowired
	private MasterMpRqBuyerQuotationSendPopDao masterMpRqBuyerQuotationSendPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqBuyerQuotationSendPopDao.selectList(formData);
	}	
	
	// 견적제출
	public Map<String,String> saveBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData){
		return masterMpRqBuyerQuotationSendPopDao.saveBuyerQuotationSend(formData, gridData);
	}

	// 환율정보 저장
	public Map<String,String> saveExpBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData){
		return masterMpRqBuyerQuotationSendPopDao.saveExpBuyerQuotationSend(formData, gridData);
	}
}
