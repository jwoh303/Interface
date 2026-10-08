package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogRecharterDao;

@Service("masterMdCmCatalogRecharterService")
public class MasterMdCmCatalogRecharterServiceImpl implements MasterMdCmCatalogRecharterService {
	
	@Autowired
	private MasterMdCmCatalogRecharterDao masterMdCmCatalogRecharterDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogRecharterDao.selectList(param);
	}	
	// 재계약 저장
	@Transactional
	public String saveMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRecharterDao.saveMasterMdCmCatalogRecharter(formData, gridData);
	}
	// 재계약 취소
	@Transactional
	public String cancleMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRecharterDao.cancleMasterMdCmCatalogRecharter(formData, gridData);
	}
	// 재계약 재요청
	@Transactional
	public String reqMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRecharterDao.reqMasterMdCmCatalogRecharter(formData, gridData);
	}
	// 재계약 단가반영 요청
	@Transactional
	public String approvalMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRecharterDao.approvalMasterMdCmCatalogRecharter(formData, gridData);
	}
}
	
