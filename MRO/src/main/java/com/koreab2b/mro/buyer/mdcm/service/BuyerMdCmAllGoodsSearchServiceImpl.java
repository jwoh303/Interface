package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmAllGoodsSearchDao;

@Service("buyerMdCmAllGoodsSearchService")
public class BuyerMdCmAllGoodsSearchServiceImpl implements BuyerMdCmAllGoodsSearchService {
	
	@Autowired
	private BuyerMdCmAllGoodsSearchDao buyerMdCmAllGoodsSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return buyerMdCmAllGoodsSearchDao.selectList(formData);
	}	
	 
}
