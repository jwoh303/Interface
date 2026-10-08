package com.koreab2b.mro.buyer.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpds.dao.BuyerMpDsAgrchemiPckmtrlDao;

@Service("buyerMpDsAgrchemiPckmtrlService")
public class BuyerMpDsAgrchemiPckmtrlServiceImpl implements BuyerMpDsAgrchemiPckmtrlService {
	
	@Autowired
	private BuyerMpDsAgrchemiPckmtrlDao buyerMpDsAgrchemiPckmtrlDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsAgrchemiPckmtrlDao.selectList(formData);
	}	
	public List<Map<String,String>> getListSub(Map<String,String> formData) {
		return buyerMpDsAgrchemiPckmtrlDao.selectListSub(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpDsAgrchemiPckmtrlDao.updateSelectedData(formData, gridData);
	}	

}
