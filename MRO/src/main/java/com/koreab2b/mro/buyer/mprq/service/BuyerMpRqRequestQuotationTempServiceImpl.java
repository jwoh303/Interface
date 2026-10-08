package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqRequestQuotationTempDao;

@Service("BuyerMpRqRequestQuotationTempService")
public class BuyerMpRqRequestQuotationTempServiceImpl implements BuyerMpRqRequestQuotationTempService {
	
	@Autowired
	private BuyerMpRqRequestQuotationTempDao buyerMpRqRequestQuotationTempDao;

	// 조회
	public List<Map<String,String>> getTempSaveList(Map<String,String> formData) {
		return buyerMpRqRequestQuotationTempDao.selectTempSaveList(formData);
	}
	public List<Map<String,String>> getTempSaveList_v2(Map<String,String> formData) {
		return buyerMpRqRequestQuotationTempDao.selectTempSaveList_v2(formData);
	}

	// 견적의뢰
	public Map<String,String> requestTempSaveList(Map<String,String>  formData){
		return buyerMpRqRequestQuotationTempDao.requestTempSaveList(formData);
	}
	public Map<String,String> requestTempSaveList_v2(Map<String,String>  formData){
		return buyerMpRqRequestQuotationTempDao.requestTempSaveList_v2(formData);
	}
	// 삭제
	public String delTempSaveList(Map<String,String>  formData){
		return buyerMpRqRequestQuotationTempDao.deleteTempSaveList(formData);
	}
	
	// 저장
	public Map<String,String> saveTempSaveList(Map<String,String>  formData){
		return buyerMpRqRequestQuotationTempDao.saveTempSaveList(formData);
	}
	public Map<String,String> saveTempSaveList_v2(Map<String,String>  formData){
		return buyerMpRqRequestQuotationTempDao.saveTempSaveList_v2(formData);
	}
}
