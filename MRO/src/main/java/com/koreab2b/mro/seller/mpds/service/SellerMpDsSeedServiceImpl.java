package com.koreab2b.mro.seller.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpds.dao.SellerMpDsSeedDao;

@Service("sellerMpDsSeedService")
public class SellerMpDsSeedServiceImpl implements SellerMpDsSeedService {
	
	@Autowired
	private SellerMpDsSeedDao sellerMpDsSeedDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsSeedDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return sellerMpDsSeedDao.updateSelectedData(formData, gridData);
	}	

}
