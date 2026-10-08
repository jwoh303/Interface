package com.koreab2b.mro.seller.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpds.dao.SellerMpDsAgrchemiPckmtrlDao;

@Service("sellerMpDsAgrchemiPckmtrlService")
public class SellerMpDsAgrchemiPckmtrlServiceImpl implements SellerMpDsAgrchemiPckmtrlService {
	
	@Autowired
	private SellerMpDsAgrchemiPckmtrlDao sellerMpDsAgrchemiPckmtrlDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsAgrchemiPckmtrlDao.selectList(formData);
	}	

	// 조회(Sub)
	public List<Map<String,String>> getListSub(Map<String,String> formData) {
		return sellerMpDsAgrchemiPckmtrlDao.selectListSub(formData);
	}	

}
