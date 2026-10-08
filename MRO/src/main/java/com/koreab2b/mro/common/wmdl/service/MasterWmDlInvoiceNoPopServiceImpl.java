package com.koreab2b.mro.common.wmdl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.wmdl.dao.MasterWmDlInvoiceNoPopDao;

@Service("masterWmDlInvoiceNoPopService")
public class MasterWmDlInvoiceNoPopServiceImpl implements MasterWmDlInvoiceNoPopService {
	
	@Autowired
	private MasterWmDlInvoiceNoPopDao masterWmDlInvoiceNoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmDlInvoiceNoPopDao.selectList(formData);
	}	
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmDlInvoiceNoPopDao.updateSelectedData(formData, gridData);
	}	
}
