package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBulkQuotationReceiptListDao;

@Service("MasterMpRqBulkQuotationReceiptListService")
public class MasterMpRqBulkQuotationReceiptListServiceImpl implements MasterMpRqBulkQuotationReceiptListService {
	
	@Autowired
	private MasterMpRqBulkQuotationReceiptListDao MasterMpRqBulkQuotationDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return MasterMpRqBulkQuotationDao.selectList(param);
	}	
	// 임시저장
	@Transactional
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData) {
		return MasterMpRqBulkQuotationDao.updateSelectedData(formData,gridData);
	}	
	// 견적마감
	@Transactional
	public String updateData(Map<String,Object>  param) {
		return MasterMpRqBulkQuotationDao.updateData(param);
	}
	
	// 견적마감취소
	@Transactional
	public String updateData2(Map<String, Object> param) {
		return MasterMpRqBulkQuotationDao.updateData2(param);
	}
	
	// 견적요청
	@Transactional
	public String orderData(Map<String, String> formData, List<Object> gridData) {
		return MasterMpRqBulkQuotationDao.orderData(formData,gridData);
	}
	
	// 견적마감일 변경
	@Override
	public String updateDateData(Map<String, String> formData, List<Object> gridData) {
		return MasterMpRqBulkQuotationDao.updateDateData(formData, gridData);
	}
}
