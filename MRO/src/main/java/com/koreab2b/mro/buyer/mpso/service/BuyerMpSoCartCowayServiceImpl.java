package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartCowayDao;

@Service("buyerMpSoCartCowayService")
public class BuyerMpSoCartCowayServiceImpl implements BuyerMpSoCartCowayService {

	@Autowired
	private BuyerMpSoCartCowayDao buyerMpSoCartCowayDao;

	// 조회
	public List<Map<String, String>> getList(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.selectList(formData);
	}

	public List<Map<String, String>> getBuyerUserCowayBudgetOrderListPop(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.selectBuyerUserCowayBudgetOrderListPop(formData);
	}

	public List<Map<String, String>> getBuyerUserCowayBudgetAccountListPop(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.selectBuyerUserCowayBudgetAccountListPop(formData);
	}

	public List<Map<String, String>> getBuyerCowayUserBudgetAccountListPop(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.selectBuyerCowayUserBudgetAccountListPop(formData);
	}

	public List<Map<String, String>> cowayBuyerAdminBdgtTempCheck(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.selectCowayBuyerAdminBdgtTempCheck(formData);
	}
	
	public String setDeleteTempCart(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.setDeleteTempCart(formData);
	}

	public String getK005List(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.getK005List(formData);
	}

	public String getBuyerCartQty(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.getBuyerCartQty(formData);
	}

	public String updateAttatch(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.updateAttatch(formData);
	}

	@Override
	public List<Map<String, String>> getClcsList(Map<String, String> formData) {
		return buyerMpSoCartCowayDao.selectClcsList(formData);
	}

}
