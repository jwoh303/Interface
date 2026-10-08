package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoDelyReturnCowayDao;

@Service("buyerMpSoDelyReturnCowayService")
public class BuyerMpSoDelyReturnCowayServiceImpl implements BuyerMpSoDelyReturnCowayService {

	@Autowired
	private BuyerMpSoDelyReturnCowayDao buyerMpSoDelyReturnCowayDao;

	@Override
	public List<Map<String, String>> getList(Map<String, String> formData) {
		return buyerMpSoDelyReturnCowayDao.selectList(formData);
	}

	@Override
	public Map<String, String> setReturnPrIns(List<Map<String, String>> pList) {
		return buyerMpSoDelyReturnCowayDao.setReturnPrIns(pList);
	}

	@Override
	public String getOrderNo(String buyer, String docType) {
		return buyerMpSoDelyReturnCowayDao.getOrderNo(buyer, docType);
	}
}
