package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdctBuyerReportManageDao;

@Service("masterMdctBuyerReportManageService")
public class MasterMdctBuyerReportManageServiceImpl implements MasterMdctBuyerReportManageService {
	
	@Autowired
	private MasterMdctBuyerReportManageDao masterMdctBuyerReportManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdctBuyerReportManageDao.selectList(param);
	}
	
	// 개별처리
	@Transactional
	public String updateSelectedProc(Map<String,String>  formData, List<Object> gridData) {
		return masterMdctBuyerReportManageDao.updateSelectedProc(formData, gridData);
	}
	
	// 재생성
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdctBuyerReportManageDao.updateSelectedData(formData, gridData);
	}
	
	// 품의상신
	@Transactional
	public String approvalMasterMdctBuyerReportManageList(Map<String,String>  formData, List<Object> gridData) {
		return masterMdctBuyerReportManageDao.approvalMasterMdctBuyerReportManageList(formData, gridData);
	}
	
	
}
