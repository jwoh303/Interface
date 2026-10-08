package com.koreab2b.mro.buyer.mppo.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mppo.dao.BuyerMpPoOrderReqDao;

@Service("buyerMpPoOrderReqService")
public class BuyerMpPoOrderReqServiceImpl implements BuyerMpPoOrderReqService {
	
	@Autowired
	private BuyerMpPoOrderReqDao buyerMpPoOrderReqDao;

	public List<Map<String,String>> getBuyerMpPoOrderReqList_v2(Map<String,Object> formData) {
		return buyerMpPoOrderReqDao.getBuyerMpPoOrderReqList_v2(formData);
	}	
 
}
