package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpBuyerPaymentConditionAlterPopDao;

@Service("masterMdCpBuyerPaymentConditionAlterPopService")
public class MasterMdCpBuyerPaymentConditionAlterPopServiceImpl implements MasterMdCpBuyerPaymentConditionAlterPopService {
	
	@Autowired
	private MasterMdCpBuyerPaymentConditionAlterPopDao masterMdCpBuyerPaymentConditionAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpBuyerPaymentConditionAlterPopDao.selectList(formData);
	}	
	

}
