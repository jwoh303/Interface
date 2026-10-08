package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoLbsePopDao;

@Service("buyerMpSoLbsePopService")
public class BuyerMpSoLbsePopServiceImpl implements BuyerMpSoLbsePopService {
	
	@Autowired
	private BuyerMpSoLbsePopDao buyerMpSoLbsePopDao;

	public String getLbseCostCode(Map<String, String> formData) {
		return buyerMpSoLbsePopDao.getLbseCostCode(formData);
	}
	
	public String getLbseAccountCode(Map<String, String> formData) {
		return buyerMpSoLbsePopDao.getLbseAccountCode(formData);
	}
}
