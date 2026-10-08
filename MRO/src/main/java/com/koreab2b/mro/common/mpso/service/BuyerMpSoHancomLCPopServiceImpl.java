package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoHancomLCPopDao;

@Service("buyerMpSoHancomLCPopService")
public class BuyerMpSoHancomLCPopServiceImpl implements BuyerMpSoHancomLCPopService {
	
	@Autowired
	private BuyerMpSoHancomLCPopDao buyerMpSoHancomLCPopDao;

	public String getText1(Map<String, String> formData) {
		return buyerMpSoHancomLCPopDao.selectText1(formData);
	}
	
	public String getAccountText1(Map<String, String> formData) {
		return buyerMpSoHancomLCPopDao.selectAccountText1(formData);
	}
}
