package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmGoodsLineStateDao;

@Service("buyerMdAmGoodsLineStateService")
public class BuyerMdAmGoodsLineStateServiceImpl implements BuyerMdAmGoodsLineStateService {
	
	@Autowired
	private BuyerMdAmGoodsLineStateDao buyerMdAmGoodsLineStateDao;

	// 조회조건 - userList 조회
	public List<Map<String,String>> getUserList(Map<String,String> formData) {
		return buyerMdAmGoodsLineStateDao.selectUserList(formData);
	}

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmGoodsLineStateDao.selectList(formData);
	}	

}
