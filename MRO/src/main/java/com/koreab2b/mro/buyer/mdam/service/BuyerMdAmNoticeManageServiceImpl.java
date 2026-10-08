package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmNoticeManageDao;

@Service("buyerMdAmNoticeManageService")
public class BuyerMdAmNoticeManageServiceImpl implements BuyerMdAmNoticeManageService {
	
	@Autowired
	private BuyerMdAmNoticeManageDao buyerMdAmNoticeManageDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmNoticeManageDao.selectList(formData);
	}	
	
	public Map<String,String> getDetailList(Map<String,String> formData) {
		return buyerMdAmNoticeManageDao.getDetailList(formData);
	}
	
	public void updateDetailList(Map<String,String>  formData) {
		buyerMdAmNoticeManageDao.updateDetailList(formData);
	}
	
	public void deleteDetailList(Map<String,String>  formData) {
		buyerMdAmNoticeManageDao.deleteDetailList(formData);
	}
	
	public void insertDetailList(Map<String,String>  formData) {
		buyerMdAmNoticeManageDao.insertDetailList(formData);
	}


}
