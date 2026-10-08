package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBoardManageDao;

@Service("buyerMdAmBoardManageService")
public class BuyerMdAmBoardManageServiceImpl implements BuyerMdAmBoardManageService {
	
	@Autowired
	private BuyerMdAmBoardManageDao buyerMdAmBoardManageDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmBoardManageDao.selectList(formData);
	}	
	
	public Map<String,String> getDetailList(Map<String,String> formData) {
		return buyerMdAmBoardManageDao.getDetailList(formData);
	}
	
	public void updateDetailList(Map<String,String>  formData) {
		buyerMdAmBoardManageDao.updateDetailList(formData);
	}
	
	public void deleteDetailList(Map<String,String>  formData) {
		buyerMdAmBoardManageDao.deleteDetailList(formData);
	}
	
	public void insertDetailList(Map<String,String>  formData) {
		buyerMdAmBoardManageDao.insertDetailList(formData);
	}


}
