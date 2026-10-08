package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogMappingDao;

@Service("masterMdCmCatalogMappingService")
public class MasterMdCmCatalogMappingServiceImpl implements MasterMdCmCatalogMappingService {
	
	@Autowired
	private MasterMdCmCatalogMappingDao masterMdCmCatalogMappingDao;
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogMappingDao.selectList(param);
	}	
	// 품목매핑
	public String saveMasterMdCmCatalogMapping(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogMappingDao.saveMasterMdCmCatalogMapping(formData,gridData);
	}
	// 매핑반려
	public String rejectMasterMdCmCatalogMapping(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogMappingDao.rejectMasterMdCmCatalogMapping(formData, gridData);
	}
	// 매핑완료
	public String saveMasterMdCmCatalogMappingCompl(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogMappingDao.saveMasterMdCmCatalogMappingCompl(formData, gridData);
	}
	// 매핑삭제
	public String saveMasterMdCmCatalogMappingDel(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogMappingDao.saveMasterMdCmCatalogMappingDel(formData, gridData);
	}
	// 매핑요청
	public String saveMasterMdcmReqMapping(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogMappingDao.saveMasterMdcmReqMapping(formData, gridData);
	}
	// 품목보완요청
	public String saveMasterMdCmReqAgentCatalog(Map<String,String>  formData,Map<String,String>  formData2, List<Object> gridData) {
		return masterMdCmCatalogMappingDao.saveMasterMdCmReqAgentCatalog(formData, formData2, gridData);
	}
	// 운영사 비고저장
	@Transactional
	public String saveMasterMdcmReqRemarkAtos(Map<String,String>  formData) {
		return masterMdCmCatalogMappingDao.saveMasterMdcmReqRemarkAtos(formData);
	}
	//카테고리 속성검색.
	public List<Map<String,String>> getMasterMdCmCategoriAttb(Map<String,String> formData) {
		return masterMdCmCatalogMappingDao.getMasterMdCmCategoriAttb(formData);
	}
	//품목정비 요청 이력
	public List<Map<String,String>> getCmsComplementHistoryPop(Map<String,Object> formData) {
		return masterMdCmCatalogMappingDao.getCmsComplementHistoryPop(formData);
	}
}
