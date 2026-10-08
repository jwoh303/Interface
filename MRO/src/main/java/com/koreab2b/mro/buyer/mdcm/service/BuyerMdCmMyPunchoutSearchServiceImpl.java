package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmMyPunchoutSearchDao;

@Service("buyerMdCmMyPunchoutSearchService")
public class BuyerMdCmMyPunchoutSearchServiceImpl implements BuyerMdCmMyPunchoutSearchService {
	
	@Autowired
	private BuyerMdCmMyPunchoutSearchDao buyerMdCmMyPunchoutSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmMyPunchoutSearchDao.getList(formData);
	}	
	// 나의상품삭제
	public int removeBuyerMdCmMyPunchOutLisList(Map<String,String>  formData) {
		return buyerMdCmMyPunchoutSearchDao.removeBuyerMdCmMyPunchOutLisList(formData);
	}	
	// 엑셀다운로드
	public List<Map<String,String>> getExcelList(Map<String,String> formData) {
		return buyerMdCmMyPunchoutSearchDao.getExcelList(formData);
	}		 
}
