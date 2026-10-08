package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpds.dao.SellerMpDsTranStatementCreationPopDao;

@Service("sellerMpDsTranStatementCreationPopService")
public class SellerMpDsTranStatementCreationPopServiceImpl implements SellerMpDsTranStatementCreationPopService {
	
	@Autowired
	private SellerMpDsTranStatementCreationPopDao sellerMpDsTranStatementCreationPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsTranStatementCreationPopDao.selectList(formData);
	}	
	
	//송장생성
	@Transactional
	public String invoiceOrderInfo(Map<String, String> formData){
		return sellerMpDsTranStatementCreationPopDao.invoiceOrderInfo( formData);
	}		
}
