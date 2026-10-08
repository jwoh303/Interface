package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqRequestForQuotationDao;

@Service("buyerMpRqRequestForQuotationService")
public class BuyerMpRqRequestForQuotationServiceImpl implements BuyerMpRqRequestForQuotationService {
	
	@Autowired
	private BuyerMpRqRequestForQuotationDao buyerMpRqRequestForQuotationDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqRequestForQuotationDao.selectList(formData);
	}	
	
	public Map<String,String> updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestForQuotationDao.updateSelectedData(formData, gridData);
	}	
	
	public String updateSelectedDataNoPass(Map<String,String>  formData, List<Object> gridData){
		return buyerMpRqRequestForQuotationDao.updateSelectedDataNoPass(formData, gridData);
	}
	public Map<String,String> updateSelectedDataPass(Map<String,String>  formData, List<Object> gridData){
		return buyerMpRqRequestForQuotationDao.updateSelectedDataPass(formData, gridData);
	}
	
	public String delReqQuotation(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestForQuotationDao.delReqQuotation(formData, gridData);
	}	

}
