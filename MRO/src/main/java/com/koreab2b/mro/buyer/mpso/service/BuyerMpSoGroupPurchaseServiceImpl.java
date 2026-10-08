package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoGroupPurchaseDao;

@Service("buyerMpSoGroupPurchaseService")
public class BuyerMpSoGroupPurchaseServiceImpl implements BuyerMpSoGroupPurchaseService {

	@Autowired
	private BuyerMpSoGroupPurchaseDao buyerMpSoGroupPurchaseDao;

	@Override
	public List<Map<String, Object>> getList(Map<String, String> formData) {
		return buyerMpSoGroupPurchaseDao.selectList(formData);
	}
	@Override
	public List<Map<String, Object>> getHolidayList(Map<String, String> formData) {
		return buyerMpSoGroupPurchaseDao.selectHolidayList(formData);
	}
	@Override
	public Map<String, String> setGroupPurchase(List<Map<String, String>> pList) {
		return buyerMpSoGroupPurchaseDao.setGroupPurchase(pList);
	}
	@Override
	public List<Map<String, Object>> getBuyerMpSoSellerRegList(Map<String, String> formData) {
		return buyerMpSoGroupPurchaseDao.selectMpSoSellerRegList(formData);
	}
	@Override
	public Map<String, String> setBuyerMpSoSellerRegListdo(List<Map<String, String>> pList) {
		return buyerMpSoGroupPurchaseDao.setBuyerMpSoSellerRegListdo(pList);
	}
}
