package com.koreab2b.mro.common.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mppo.dao.BuyerMpPoRejectReasonPopDao;

@Service("buyerMpPoRejectReasonPopService")
public class BuyerMpPoRejectReasonPopServiceImpl implements BuyerMpPoRejectReasonPopService {
	
	@Autowired
	private BuyerMpPoRejectReasonPopDao buyerMpPoRejectReasonPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoRejectReasonPopDao.selectList(formData);
	}	
	

}
