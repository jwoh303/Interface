package com.koreab2b.mro.common.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mppo.dao.BuyerMpPoGoodsAddPopDao;

@Service("buyerMpPoGoodsAddPopService")
public class BuyerMpPoGoodsAddPopServiceImpl implements BuyerMpPoGoodsAddPopService {
	
	@Autowired
	private BuyerMpPoGoodsAddPopDao buyerMpPoGoodsAddPopDao;

	// 조회
	public List<Map<String,String>> getInfoList(Map<String,String> formData) {
		return buyerMpPoGoodsAddPopDao.selecInfotList(formData);
	}	
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoGoodsAddPopDao.selectList(formData);
	}	
	
	
	// 상품추가
	public String saveSetItemAdd(Map<String,String>  formData){
		return buyerMpPoGoodsAddPopDao.saveSetItemAdd(formData);
	}	

	
	
	public List<Map<String,String>> getCatalogDisplayMain(Map<String,String> formData) {
		return buyerMpPoGoodsAddPopDao.getCatalogDisplayMain(formData);
	}	
	public List<Map<String,String>> getItemSeries(Map<String,String> formData) {
		return buyerMpPoGoodsAddPopDao.getItemSeries(formData);
	}	
	public List<Map<String,String>> categoryPathViewer(Map<String,String> formData) {
		return buyerMpPoGoodsAddPopDao.categoryPathViewer(formData);
	}	
	
}
