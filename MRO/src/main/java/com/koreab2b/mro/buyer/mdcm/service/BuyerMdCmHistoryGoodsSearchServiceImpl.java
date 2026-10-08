package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmHistoryGoodsSearchDao;

@Service("buyerMdCmHistoryGoodsSearchService")
public class BuyerMdCmHistoryGoodsSearchServiceImpl implements BuyerMdCmHistoryGoodsSearchService {
	
	@Autowired
	private BuyerMdCmHistoryGoodsSearchDao buyerMdCmHistoryGoodsSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmHistoryGoodsSearchDao.selectList(formData);
	}
	// 조회
	public List<Map<String,String>> selectBuyerMdCmHistoryGoodsSearchList_v2(Map<String,String> formData) {
		return buyerMdCmHistoryGoodsSearchDao.selectBuyerMdCmHistoryGoodsSearchList_v2(formData);
	}

	@Override
	public String removebuyerMdCmHistoryGoodsItem(Map<String, String> formData) {
		return buyerMdCmHistoryGoodsSearchDao.deleteItem(formData);
	}	
	 
}
