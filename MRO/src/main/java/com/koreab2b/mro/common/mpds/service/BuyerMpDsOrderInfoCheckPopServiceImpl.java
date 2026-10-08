package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.BuyerMpDsOrderInfoCheckPopDao;

@Service("buyerMpDsOrderInfoCheckPopService")
public class BuyerMpDsOrderInfoCheckPopServiceImpl implements BuyerMpDsOrderInfoCheckPopService {
	
	@Autowired
	private BuyerMpDsOrderInfoCheckPopDao buyerMpDsOrderInfoCheckPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsOrderInfoCheckPopDao.selectList(formData);
	}	
	

}
