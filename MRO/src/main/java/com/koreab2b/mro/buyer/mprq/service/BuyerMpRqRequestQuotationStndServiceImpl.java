package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqRequestQuotationStndDao;

@Service("BuyerMpRqRequestQuotationStndService")
public class BuyerMpRqRequestQuotationStndServiceImpl implements BuyerMpRqRequestQuotationStndService {
	
	@Autowired
	private BuyerMpRqRequestQuotationStndDao buyerMpRqRequestQuotationStndDao;

	public String updateSelectedDataNoPass(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedDataNoPass(formData, gridData);
	}	
	public String updateSelectedDataNoPass_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedDataNoPass_v2(formData, gridData);
	}
	public Map<String,String> updateSelectedDataPass(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedDataPass(formData, gridData);
	}	
	public Map<String,String> updateSelectedDataPass_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedDataPass_v2(formData, gridData);
	}
	public Map<String,String> updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedData(formData, gridData);
	}	
	public Map<String,String> updateSelectedData_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedData_v2(formData, gridData);
	}	
	public Map<String,String> updateSelectedDataTemp(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedDataTemp(formData, gridData);
	}
	public Map<String,String> updateSelectedDataTemp_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedDataTemp_v2(formData, gridData);
	}
	public Map<String,String> updateSelectedDataTempGpl(Map<String,String> formData) {
		return buyerMpRqRequestQuotationStndDao.updateSelectedDataTempGpl(formData);
	}
}
