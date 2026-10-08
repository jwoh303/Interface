package com.koreab2b.mro.buyer.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.none.dao.BuyerNoNeNoticeDao;;

@Service("buyerNoNeNoticeService")
public class BuyerNoNeNoticeServiceImpl implements BuyerNoNeNoticeService {
	
	@Autowired
	private BuyerNoNeNoticeDao buyerNoNeNoticeDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerNoNeNoticeDao.selectList(formData);
	}
	
	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData){
		return buyerNoNeNoticeDao.selectDetail(formData);
	}

}
