package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingPurchaseSaveDao;

@Service("masterMpRqDailySourcingPurchaseSaveService")
public class MasterMpRqDailySourcingPurchaseSaveServiceImpl implements MasterMpRqDailySourcingPurchaseSaveService {

	@Autowired
	private MasterMpRqDailySourcingPurchaseSaveDao masterMpRqDailySourcingPurchaseSaveDao;

	public Map<String,String> initQuotation(Map<String,String> formData, List<Object> gridData) {
		return masterMpRqDailySourcingPurchaseSaveDao.initQuotation(formData, gridData);
	}

	public String updateEndTime(Map<String,String> formData, List<Object> gridData) {
		return masterMpRqDailySourcingPurchaseSaveDao.updateEndTime(formData, gridData);
	}

	public String updateMsdsReq(Map<String,String> formData, List<Object> gridData) {
		return masterMpRqDailySourcingPurchaseSaveDao.updateMsdsReq(formData, gridData);
	}

	public String updateItemChgReq(Map<String,String> formData, List<Object> gridData) {
		return masterMpRqDailySourcingPurchaseSaveDao.updateItemChgReq(formData, gridData);
	}

	public String updateDbCleansingCopy(Map<String,String> formData, List<Object> gridData) {
		return masterMpRqDailySourcingPurchaseSaveDao.updateDbCleansingCopy(formData, gridData);
	}

}
