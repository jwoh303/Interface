package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmMyGoodsSearchDao;

@Service("buyerMdCmMyGoodsSearchService")
public class BuyerMdCmMyGoodsSearchServiceImpl implements BuyerMdCmMyGoodsSearchService {
	
	@Autowired
	private BuyerMdCmMyGoodsSearchDao buyerMdCmMyGoodsSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmMyGoodsSearchDao.selectList(formData);
	}
	public List<Map<String,String>> selectBuyerMdCmMyGoodsSearchList_v2(Map<String,String> formData) {
		return buyerMdCmMyGoodsSearchDao.selectBuyerMdCmMyGoodsSearchList_v2(formData);
	}
	
	// 내견적조회
	public List<Map<String,String>> getRqdtList(Map<String,String> formData) {
		return buyerMdCmMyGoodsSearchDao.selectRqdtList(formData);
	}
	// 나의상품삭제
	public int removeBuyerMdCmMyGoodsLisList(Map<String,String>  formData) {
		return buyerMdCmMyGoodsSearchDao.removeBuyerMdCmMyGoodsLisList(formData);
	}
	// 나의상품분류저장
	public int saveBuyerMdCmMyGroupLisList(Map<String,String>  formData) {
		return buyerMdCmMyGoodsSearchDao.saveBuyerMdCmMyGroupLisList(formData);
	}
	public List<Map<String,String>> getMyCatalgList(Map<String,String> formData) {
		return buyerMdCmMyGoodsSearchDao.getMyCatalgList(formData);
	}
}
