package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoSolbPopDao;

@Service("buyerMpSoSolbPopService")
public class BuyerMpSoSolbPopServiceImpl implements BuyerMpSoSolbPopService {
	
	@Autowired
	private BuyerMpSoSolbPopDao buyerMpSoSolbPopDao;

	public String getSolbCostCode(Map<String, String> formData) {
		return buyerMpSoSolbPopDao.getSolbCostCode(formData);
	}
	
	public String getSolbAccountCode(Map<String, String> formData) {
		return buyerMpSoSolbPopDao.getSolbAccountCode(formData);
	}

	
	public String getSolbPlantCode(Map<String, String> formData) {
		return buyerMpSoSolbPopDao.getSolbPlantCode(formData);
	}
}
