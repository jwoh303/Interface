package com.koreab2b.mro.buyer.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mppo.dao.BuyerMpPoOrderReqRejectDao;

@Service("buyerMpPoOrderReqRejectService")
public class BuyerMpPoOrderReqRejectServiceImpl implements BuyerMpPoOrderReqRejectService {
	
	@Autowired
	private BuyerMpPoOrderReqRejectDao buyerMpPoOrderReqRejectDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoOrderReqRejectDao.selectList(formData);
	}	
	 
}
