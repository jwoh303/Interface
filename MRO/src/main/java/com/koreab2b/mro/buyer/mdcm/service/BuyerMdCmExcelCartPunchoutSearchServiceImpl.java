package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmExcelCartPunchoutSearchDao;

@Service("buyerMdCmExcelCartPunchoutSearchService")
public class BuyerMdCmExcelCartPunchoutSearchServiceImpl implements BuyerMdCmExcelCartPunchoutSearchService {
	
	@Autowired
	private BuyerMdCmExcelCartPunchoutSearchDao buyerMdCmExcelCartPunchoutSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmExcelCartPunchoutSearchDao.getList(formData);
	}	
	// 저장
	public String setExcelUp(Map<String,String>  formData) {
		return buyerMdCmExcelCartPunchoutSearchDao.saveExcelUp(formData);
	}
}
