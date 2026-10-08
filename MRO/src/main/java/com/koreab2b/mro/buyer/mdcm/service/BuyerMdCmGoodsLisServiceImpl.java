 package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmGoodsLisDao;

@Service("buyerMdCmGoodsLisService")
public class BuyerMdCmGoodsLisServiceImpl implements BuyerMdCmGoodsLisService {
	
	@Autowired
	private BuyerMdCmGoodsLisDao buyerMdCmGoodsLisDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmGoodsLisDao.selectList(formData);
	}	
	
	public List<Map<String,String>> getListCATEGORY_TEXT(Map<String,String>  formData) {
		return buyerMdCmGoodsLisDao.getListCATEGORY_TEXT(formData);
	}	
	public List<Map<String,String>> getListMAKER_NAME(Map<String,String>  formData) {
		return buyerMdCmGoodsLisDao.getListMAKER_NAME(formData);
	}	
	
	// 상세 조회
	public List<Map<String,String>> getCatalogDisplayMain(Map<String,String>  formData){
		return buyerMdCmGoodsLisDao.getCatalogDisplayMain(formData);
	}
	public List<Map<String,String>> getCatalogDisplayMain_v2(Map<String,String>  formData){
		return buyerMdCmGoodsLisDao.getCatalogDisplayMain_v2(formData);
	}
	// 펀치아웃상세 조회
	public List<Map<String,String>> getCatalogDisplayPCOMain(Map<String,String>  formData){
		return buyerMdCmGoodsLisDao.getCatalogDisplayPCOMain(formData);
	}
	public List<Map<String,String>> getItemSeries(Map<String,String>  formData){
		return buyerMdCmGoodsLisDao.getItemSeries(formData);
	}
	public List<Map<String,String>> getItemSeries_v2(Map<String,Object>  formData){
		return buyerMdCmGoodsLisDao.getItemSeries_v2(formData);
	}	
	
	public List<Map<String,String>> getItemAttrCheck(Map<String,String>  formData){
		return buyerMdCmGoodsLisDao.getItemAttrCheck(formData);
	}	
	
	// 저장
	public String saveBuyerMdCmGoodsLisList(Map<String,String>  formData) {
		return buyerMdCmGoodsLisDao.saveBuyerMdCmGoodsLisList(formData);
	}
	public String saveBuyerMdCmGoodsLisList_v2(Map<String,String>  formData) {
		return buyerMdCmGoodsLisDao.saveBuyerMdCmGoodsLisList_v2(formData);
	}	
}
