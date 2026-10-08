package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoDeliveryPunchOutProgressDao;

@Service("buyerMpSoDeliveryPunchOutProgressService")
public class BuyerMpSoDeliveryPunchOutProgressServiceImpl implements BuyerMpSoDeliveryPunchOutProgressService {
	
	@Autowired
	private BuyerMpSoDeliveryPunchOutProgressDao buyerMpSoDeliveryPunchOutProgressDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoDeliveryPunchOutProgressDao.selectList(formData);
	}	
	// 납기지연조회
	public List<Map<String,String>> getDelayList(Map<String,String> formData) {
		return buyerMpSoDeliveryPunchOutProgressDao.selectDelayList(formData);
	}	
}
