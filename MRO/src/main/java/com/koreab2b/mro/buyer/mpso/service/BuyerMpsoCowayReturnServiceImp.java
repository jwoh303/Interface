package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpsoCowayReturnDao;

@Service("buyerMpsoCowayReturnService")
public class BuyerMpsoCowayReturnServiceImp implements BuyerMpsoCowayReturnService {
	
	@Autowired
	BuyerMpsoCowayReturnDao	buyerMpsoCowayReturnDao;

	@Override
	public List<Map<String, String>> getCowayReturnPeriod(Map<String, String> pMap) {
		return buyerMpsoCowayReturnDao.getCowayReturnPeriod(pMap);
	}

	@Override
	public String setBuyerCowayReturnPeriodPop(Map<String, String> pMap) {
		return buyerMpsoCowayReturnDao.setBuyerCowayReturnPeriodPop(pMap);
	}
}
