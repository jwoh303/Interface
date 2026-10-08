package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmUniformSearchDao;

@Service("buyerMdCmUniformSearchService")
public class BuyerMdCmUniformSearchServiceImpl implements BuyerMdCmUniformSearchService {
	
	@Autowired
	private BuyerMdCmUniformSearchDao buyerMdCmUniformSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmUniformSearchDao.selectList(formData);
	}
}
