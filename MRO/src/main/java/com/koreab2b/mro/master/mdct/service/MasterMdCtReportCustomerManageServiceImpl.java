package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtReportCustomerManageDao;

@Service("masterMdCtReportCustomerManageService")
public class MasterMdCtReportCustomerManageServiceImpl implements MasterMdCtReportCustomerManageService {
	
	@Autowired
	private MasterMdCtReportCustomerManageDao masterMdCtReportCustomerManageDao;

	// 리포트등록 조회
	public List<Map<String,String>> getReportList(Map<String,String> formData) {
		return masterMdCtReportCustomerManageDao.selectReportList(formData);
	}
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtReportCustomerManageDao.selectList(param);
	}
	// 등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportCustomerManageDao.updateSelectedData(formData, gridData);
	}
	// 저장
	@Transactional
	public String saveMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportCustomerManageDao.saveMasterMdCtReportCustomerList(formData, gridData);
	}
	// 리포트매핑 삭제
	@Transactional
	public String delMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtReportCustomerManageDao.delMasterMdCtReportCustomerList(formData, gridData);
	}
}
