package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogRegDao;

@Service("masterMdCmCatalogRegService")
public class MasterMdCmCatalogRegServiceImpl implements MasterMdCmCatalogRegService {
	
	@Autowired
	private MasterMdCmCatalogRegDao masterMdCmCatalogRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogRegDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegDao.deleteSelectedData(formData, gridData);
	}
	
	// 등록
	@Transactional
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegDao.regSelectedData(formData, gridData);
	}	
	
	// 품의상신
	@Transactional
	public Map<String,String> consSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegDao.consSelectedData(formData, gridData);
	}
	
	// 일괄업로드
	@Transactional
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegDao.batchSelectedData(formData, gridData);
	}
	
	// 복사
	@Transactional
	public String copySelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegDao.copySelectedData(formData, gridData);
	}	
	
	// CMS등록
	@Transactional
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegDao.confirmSelectedData(formData, gridData);
	}
	
	// 매출원가 적용 여부
	public String getBuyerRateAdaptFlag(Map<String,String>  pMap){
		return masterMdCmCatalogRegDao.getBuyerRateAdaptFlag(pMap);
	}
	
	public String getBuyerRateInfo(Map<String,String>  pMap){
		return masterMdCmCatalogRegDao.getBuyerRateInfo(pMap);
	}
	
	public String getProcessTypeRateInfo(Map<String,String>  pMap){
		return masterMdCmCatalogRegDao.getProcessTypeRateInfo(pMap);
	}
	
	public String getBuyerStandardRate(Map<String,String>  pMap){
		return masterMdCmCatalogRegDao.getBuyerStandardRate(pMap);
	}
	
	public Map<String,String> getTotProcessTypeRateInfo(Map<String,String>  pMap){
		return masterMdCmCatalogRegDao.getTotProcessTypeRateInfo(pMap);
	}
	
	public String getCatalogRegBottomOrgCodeMultiPop(Map<String,String>  pMap){
		return masterMdCmCatalogRegDao.getCatalogRegBottomOrgCodeMultiPop(pMap);
	}
	
	
}
