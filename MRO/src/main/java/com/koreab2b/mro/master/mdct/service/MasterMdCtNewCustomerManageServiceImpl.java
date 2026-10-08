package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtNewCustomerManageDao;

@Service("masterMdCtNewCustomerManageService")
public class MasterMdCtNewCustomerManageServiceImpl implements MasterMdCtNewCustomerManageService {
	
	@Autowired
	private MasterMdCtNewCustomerManageDao masterMdCtNewCustomerManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtNewCustomerManageDao.selectList(param);
	}
	// 잠재고객 등록
	public String saveMasterMdCtNewCustomer(Map<String,String> formData){
		return masterMdCtNewCustomerManageDao.saveMasterMdCtNewCustomer(formData);
	}
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtNewCustomerManageDao.updateSelectedData(formData, gridData);
	}
	//잠재고객 상세 조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData) {
		return masterMdCtNewCustomerManageDao.getDetailList(formData);
	}
	// 잠재고객 수정
	public String updateMasterMdCtNewCustomer(Map<String,String> formData){
		return masterMdCtNewCustomerManageDao.updateMasterMdCtNewCustomer(formData);
	}
	// 잠재고객 종결
	public String endMasterMdCtNewCustomer(Map<String,String> formData){
		return masterMdCtNewCustomerManageDao.endMasterMdCtNewCustomer(formData);
	}
	// 잠재고객 사전영업 완료
	public String saveMasterMdCtNewCustomerMtComp(Map<String,String> formData){
		return masterMdCtNewCustomerManageDao.saveMasterMdCtNewCustomerMtComp(formData);
	}
	// 기업정보업데이트
	@Transactional
	public String updateMasterMdCtMSTNewCustomer(Map<String,String> formData){
		return masterMdCtNewCustomerManageDao.updateMasterMdCtMSTNewCustomer(formData);
	}
}
