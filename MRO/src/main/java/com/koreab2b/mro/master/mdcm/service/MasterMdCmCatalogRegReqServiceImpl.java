package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogRegReqDao;

@Service("masterMdCmCatalogRegReqService")
public class MasterMdCmCatalogRegReqServiceImpl implements MasterMdCmCatalogRegReqService {
	
	@Autowired
	private MasterMdCmCatalogRegReqDao masterMdCmCatalogRegReqDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogRegReqDao.selectList(param);
	}	

	// 등록 요청
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegReqDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegReqDao.deleteSelectedData(formData, gridData);
	}
	
	// 신규 업로드
	@Transactional
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegReqDao.batchSelectedData(formData, gridData);
	}
	
	// 기등록 업로드
	@Transactional
	public String batchRenewSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegReqDao.batchRenewSelectedData(formData, gridData);
	}
}
