package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtNewCustomerBidManageDao;

@Service("masterMdCtNewCustomerBidManageService")
public class MasterMdCtNewCustomerBidManageServiceImpl implements MasterMdCtNewCustomerBidManageService {
	
	@Autowired
	private MasterMdCtNewCustomerBidManageDao masterMdCtNewCustomerBidManageDao;

	// 잠재고객 입찰조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData) {
		return masterMdCtNewCustomerBidManageDao.getDetailList(formData);
	}
	// 잠재고객 입찰저장
	public String saveMasterMdCtNewCustomerBidList(Map<String,String> formData){
		return masterMdCtNewCustomerBidManageDao.saveMasterMdCtNewCustomerBidList(formData);
	}
	// 잠재고객 입찰취소
	public String cancleMasterMdCtNewCustomerBidList(Map<String,String> formData){
		return masterMdCtNewCustomerBidManageDao.cancleMasterMdCtNewCustomerBidList(formData);
	}
	// 잠재고객 셋업정보 조회
	public List<Map<String,String>> getSetupList(Map<String,String> formData) {
		return masterMdCtNewCustomerBidManageDao.getSetupList(formData);
	}
	// 잠재고객 셋업저장
	public String saveMasterMdCtNewCustomerSetList(Map<String,String> formData){
		return masterMdCtNewCustomerBidManageDao.saveMasterMdCtNewCustomerSetList(formData);
	}
	// 잠재고객 셋업취소
	public String cancleMasterMdCtNewCustomerSetList(Map<String,String> formData){
		return masterMdCtNewCustomerBidManageDao.cancleMasterMdCtNewCustomerSetList(formData);
	}
	// 잠재고객 계약정보 조회
	public List<Map<String,String>> getConList(Map<String,String> formData) {
		return masterMdCtNewCustomerBidManageDao.getConList(formData);
	}
	// 잠재고객 계약저장
	public String saveMasterMdCtNewCustomerConList(Map<String,String> formData){
		return masterMdCtNewCustomerBidManageDao.saveMasterMdCtNewCustomerConList(formData);
	}
	// 잠재고객 계약취소
	public String cancleMasterMdCtNewCustomerConList(Map<String,String> formData){
		return masterMdCtNewCustomerBidManageDao.cancleMasterMdCtNewCustomerConList(formData);
	}
}
