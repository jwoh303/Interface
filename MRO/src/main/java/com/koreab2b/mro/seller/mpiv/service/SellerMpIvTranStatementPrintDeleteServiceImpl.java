package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvTranStatementPrintDeleteDao;

@Service("sellerMpIvTranStatementPrintDeleteService")
public class SellerMpIvTranStatementPrintDeleteServiceImpl implements SellerMpIvTranStatementPrintDeleteService {
	
	@Autowired
	private SellerMpIvTranStatementPrintDeleteDao sellerMpIvTranStatementPrintDeleteDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return sellerMpIvTranStatementPrintDeleteDao.selectList(pMap);
	}	
	
	public List<Map<String,String>> getExcelList(Map<String,String> pMap) {
		return sellerMpIvTranStatementPrintDeleteDao.selectExcelList(pMap);
	}	
	
}
