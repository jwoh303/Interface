package com.koreab2b.mro.master.mdsr.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdsr.dao.MasterMdSrSrNewReqDao;

@Service("masterMdSrSrNewReqService")
public class MasterMdSrSrNewReqServiceImpl implements MasterMdSrSrNewReqService {
	
	@Autowired
	private MasterMdSrSrNewReqDao masterMdSrSrNewReqDao;

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return masterMdSrSrNewReqDao.updateSelectedData(formData);
	}	
	
	// 품의상신 DOCU_NO 채번
	@Transactional
	public Map<String,String> approvalSelectedData(Map<String,String>  formData) {
		return masterMdSrSrNewReqDao.approvalSelectedData(formData);
	}
}
