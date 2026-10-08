package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSohahomePopDao;

@Service("buyerMpSohahomePopService")
public class BuyerMpSohahomePopServiceImpl implements BuyerMpSohahomePopService {
	
	@Autowired
	private BuyerMpSohahomePopDao buyerMpSohahomePopDao;

	public String gethahomeCostCode(Map<String, String> formData) {
		return buyerMpSohahomePopDao.gethahomeCostCode(formData);
	}
	
	public String gethahomeAccountCode(Map<String, String> formData) {
		return buyerMpSohahomePopDao.gethahomeAccountCode(formData);
	}
}
