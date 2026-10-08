package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvInvoiceDetailIKPopDao;

@Service("commonMpIvInvoiceDetailIKPopService")
public class CommonMpIvInvoiceDetailIKPopServiceImpl implements CommonMpIvInvoiceDetailIKPopService {
	
	@Autowired
	private CommonMpIvInvoiceDetailIKPopDao commonMpIvInvoiceDetailIKPopDao;

	public Map<String,String> getInfo(Map<String,String> formData) {
		return commonMpIvInvoiceDetailIKPopDao.selectInfo(formData);
	}
	public Map<String,String> getInfo_v2(Map<String,String> formData) {
		return commonMpIvInvoiceDetailIKPopDao.selectInfo_v2(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvInvoiceDetailIKPopDao.selectList(formData);
	}	
	public List<Map<String,String>> getList_v2(Map<String,Object> formData) {
		return commonMpIvInvoiceDetailIKPopDao.selectList_v2(formData);
	}	
	

}
