package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqRequestQuotationPCODao;

@Service("BuyerMpRqRequestQuotationPCOService")
public class BuyerMpRqRequestQuotationPCOServiceImpl implements BuyerMpRqRequestQuotationPCOService {
	
	@Autowired
	private BuyerMpRqRequestQuotationPCODao buyerMpRqRequestQuotationPCODao;
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqRequestQuotationPCODao.selectList(formData);
	}	
   //견적의뢰
	public Map<String,String> updateSelectedTempData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationPCODao.updateSelectedTempData(formData, gridData);
	}	
	//삭제
	public String deleteSelectedTempData(Map<String,String>  formData) {
		return buyerMpRqRequestQuotationPCODao.deleteSelectedTempData(formData);
	}
	//임시저장 견적의뢰
	public String saveSelectedTempReqData(Map<String,String>  formData) {
		return buyerMpRqRequestQuotationPCODao.saveSelectedTempReqData(formData);
	}
}
