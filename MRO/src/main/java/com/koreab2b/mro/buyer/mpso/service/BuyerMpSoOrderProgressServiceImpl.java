package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderProgressDao;

@Service("buyerMpSoOrderProgressService")
public class BuyerMpSoOrderProgressServiceImpl implements BuyerMpSoOrderProgressService {

	@Autowired
	private BuyerMpSoOrderProgressDao buyerMpSoOrderProgressDao;

	// 조회
	public List<Map<String, String>> getList(Map<String, String> formData) {
		return buyerMpSoOrderProgressDao.selectList(formData);
	}
	public List<Map<String, String>> getBuyerMpSoOrderProgressList_v2(Map<String, Object> formData) {
		return buyerMpSoOrderProgressDao.getBuyerMpSoOrderProgressList_v2(formData);
	}
	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData) {
		return buyerMpSoOrderProgressDao.updateSelectedData(formData, gridData);
	}

	@Override
	public List<Map<String, String>> getBuyerMpSoClcsOrderProgressList(Map<String, String> formData) {
		return buyerMpSoOrderProgressDao.getBuyerMpSoClcsOrderProgressList(formData);
	}

	@Override
	public List<Map<String, String>> getBuyerMpSoGroupPurchaseOrderProgressList(Map<String, String> formData) {
		return buyerMpSoOrderProgressDao.getBuyerMpSoGroupPurchaseOrderProgressList(formData);
	}
	// 저장
	public String delBuyerMpsoCowayCart(Map<String,String>  formData){
		return buyerMpSoOrderProgressDao.delBuyerMpsoCowayCart(formData);
	}
	@Override
	public List<Map<String, String>> getBuyerMpSoSellerRegProgressList(Map<String, String> formData) {
		return buyerMpSoOrderProgressDao.getBuyerMpSoSellerRegProgressList(formData);
	}
	@Override
	public List<Map<String, String>> getBuyerMpSoSellerInfoPop(Map<String, String> formData) {
		return buyerMpSoOrderProgressDao.getBuyerMpSoSellerInfoPop(formData);
	}
	// 저장
	public String saveBuyerMpSoSellerRegProgressList(Map<String,String>  formData){
		return buyerMpSoOrderProgressDao.saveBuyerMpSoSellerRegProgressList(formData);
	}
	public String saveBuyerPrCancel(Map<String,String>  formData){
		return buyerMpSoOrderProgressDao.saveBuyerPrCancel(formData);
	}
}
