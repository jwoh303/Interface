package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqQuotationDmSendPopDao;

@Service("masterMpRqQuotationDmSendPopService")
public class MasterMpRqQuotationDmSendPopServiceImpl implements MasterMpRqQuotationDmSendPopService {
	
	@Autowired
	private MasterMpRqQuotationDmSendPopDao masterMpRqQuotationDmSendPopDao;

	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqQuotationDmSendPopDao.selectList(formData);
	}
	
	public List<Map<String,String>> getTemplateList(Map<String,Object> formData) {
		return masterMpRqQuotationDmSendPopDao.selectTemplateList(formData);
	}
	
	@Transactional
	// 견적정비 DM 발송
	public String saveMasterMpRqQuotationDmSend(Map<String,String> formData, List<Object> gridData) {
		return masterMpRqQuotationDmSendPopDao.saveMasterMpRqQuotationDmSend(formData, gridData);
	}
}
