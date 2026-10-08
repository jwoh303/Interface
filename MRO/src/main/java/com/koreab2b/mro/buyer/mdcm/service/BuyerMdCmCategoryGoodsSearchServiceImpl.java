package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmCategoryGoodsSearchDao;

@Service("buyerMdCmCategoryGoodsSearchService")
public class BuyerMdCmCategoryGoodsSearchServiceImpl implements BuyerMdCmCategoryGoodsSearchService {
	
	@Autowired
	private BuyerMdCmCategoryGoodsSearchDao buyerMdCmCategoryGoodsSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmCategoryGoodsSearchDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdCmCategoryGoodsSearchDao.updateSelectedData(formData, gridData);
	}	
	
	// 카테고리 조회
	public List<Map<String, String>>  getCategoriList(Map<String,String>  pMap) {
		return buyerMdCmCategoryGoodsSearchDao.getCategoriList(pMap);
	}
	// 펀치아웃카테고리 조회
	public List<Map<String, String>>  getCategoryPCOList(Map<String,String>  pMap) {
		return buyerMdCmCategoryGoodsSearchDao.getCategoryPCOList(pMap);
	}	
	// 카테고리 조회
	public List<Map<String, String>>  getStdCategoriList(Map<String,String>  pMap) {
		return buyerMdCmCategoryGoodsSearchDao.getStdCategoriList(pMap);
	}	
}
