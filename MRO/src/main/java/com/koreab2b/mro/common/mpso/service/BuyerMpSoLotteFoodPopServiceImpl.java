package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoLotteFoodPopDao;

@Service("buyerMpSoLotteFoodPopService")
public class BuyerMpSoLotteFoodPopServiceImpl implements BuyerMpSoLotteFoodPopService {
	
	@Autowired
	private BuyerMpSoLotteFoodPopDao buyerMpSoLotteFoodPopDao;

	// 조회 
	public String  getDeptName(Map<String,String>  formData){
		return buyerMpSoLotteFoodPopDao.selectDeptName(formData);
	}	
	public String  getAccountName(Map<String,String>  formData){
		return buyerMpSoLotteFoodPopDao.selectAccountName(formData);
	}	
}
