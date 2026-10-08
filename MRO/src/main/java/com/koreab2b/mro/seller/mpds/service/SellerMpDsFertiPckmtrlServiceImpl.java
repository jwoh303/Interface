package com.koreab2b.mro.seller.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpds.dao.SellerMpDsFertiPckmtrlDao;

@Service("sellerMpDsFertiPckmtrlService")
public class SellerMpDsFertiPckmtrlServiceImpl implements SellerMpDsFertiPckmtrlService {
	
	@Autowired
	private SellerMpDsFertiPckmtrlDao sellerMpDsFertiPckmtrlDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsFertiPckmtrlDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return sellerMpDsFertiPckmtrlDao.updateSelectedData(formData, gridData);
	}	

}
