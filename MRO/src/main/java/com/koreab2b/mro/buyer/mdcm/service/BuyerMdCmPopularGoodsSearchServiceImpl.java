package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmPopularGoodsSearchDao;

@Service("buyerMdCmPopularGoodsSearchService")
public class BuyerMdCmPopularGoodsSearchServiceImpl implements BuyerMdCmPopularGoodsSearchService {
	
	@Autowired
	private BuyerMdCmPopularGoodsSearchDao buyerMdCmPopularGoodsSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmPopularGoodsSearchDao.selectList(formData);
	}	
	// 저장
	public String saveBuyerMdCmPopularGoods(Map<String,String>  formData) {
		return buyerMdCmPopularGoodsSearchDao.saveBuyerMdCmPopularGoods(formData);
	}
	// 카테고리 업데이트
	public String saveBuyerMdCmFolderCode(Map<String,String>  formData) {
		return buyerMdCmPopularGoodsSearchDao.saveBuyerMdCmFolderCode(formData);
	}
	// 카테고리 ICOMUSCA 업데이트
	public String saveBuyerMdCmFolderName(Map<String,String>  formData) {
		return buyerMdCmPopularGoodsSearchDao.saveBuyerMdCmFolderName(formData);
	}	
	// 삭제조회
	public List<Map<String,String>> getDeleteList(Map<String,String> formData) {
		return buyerMdCmPopularGoodsSearchDao.selectDeleteList(formData);
	}		 
	// 그린상품조회
	public List<Map<String,String>> getGreenList(Map<String,String> formData) {
		return buyerMdCmPopularGoodsSearchDao.selectGreenList(formData);
	}
	// 그린상품조회
	public List<Map<String,String>> getProjectList(Map<String,String> formData) {
		return buyerMdCmPopularGoodsSearchDao.selectProjectList(formData);
	}
}
