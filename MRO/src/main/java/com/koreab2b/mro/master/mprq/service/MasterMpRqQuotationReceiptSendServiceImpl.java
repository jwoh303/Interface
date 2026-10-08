package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqQuotationReceiptSendDao;

@Service("masterMpRqQuotationReceiptSendService")
public class MasterMpRqQuotationReceiptSendServiceImpl implements MasterMpRqQuotationReceiptSendService {
	
	@Autowired
	private MasterMpRqQuotationReceiptSendDao masterMpRqQuotationReceiptSendDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqQuotationReceiptSendDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationReceiptSendDao.updateSelectedData(formData, gridData);
	}	
	// 네고
	@Transactional
	public Map<String,String> negoQuotationReceiptSend(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationReceiptSendDao.negoQuotationReceiptSend(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationReceiptSendDao.deleteSelectedData(formData, gridData);
	}
	
	public List<Map<String,String>> getListHd(Map<String,Object> formData){
		return masterMpRqQuotationReceiptSendDao.getListHd(formData);
	}
}
