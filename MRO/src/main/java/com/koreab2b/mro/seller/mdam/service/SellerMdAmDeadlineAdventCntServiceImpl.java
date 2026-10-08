package com.koreab2b.mro.seller.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdam.dao.SellerMdAmDeadlineAdventCntDao;

@Service("sellerMdAmDeadlineAdventCntService")
public class SellerMdAmDeadlineAdventCntServiceImpl implements SellerMdAmDeadlineAdventCntService {
	
	@Autowired
	private SellerMdAmDeadlineAdventCntDao sellerMdAmDeadlineAdventCntDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdAmDeadlineAdventCntDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getListPop(Map<String,String> formData) {
		return sellerMdAmDeadlineAdventCntDao.selectListPop(formData);
	}	

}
