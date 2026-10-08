package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.mdcm.dao.MasterMdCmBuyerCatalogAlterPopDao;

@Service("masterMdCmBuyerCatalogAlterPopService")
public class MasterMdCmBuyerCatalogAlterPopServiceImpl implements MasterMdCmBuyerCatalogAlterPopService {
	
	@Autowired
	private MasterMdCmBuyerCatalogAlterPopDao masterMdCmBuyerCatalogAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMdCmBuyerCatalogAlterPopDao.selectList(formData);
	}	
	
	// 상세조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData) {
		return masterMdCmBuyerCatalogAlterPopDao.selectDetailList(formData);
	}	
	
	// CMS 담당자 여부 확인
	public String getCheckedCmsRoleUser(Map<String,String>  formData){
		return masterMdCmBuyerCatalogAlterPopDao.getCheckedCmsRoleUser(formData);
	}
	
	// 조회
	public List<Map<String,String>> getUserSelectkorea(Map<String,String> formData) {
		return masterMdCmBuyerCatalogAlterPopDao.selectUserSelectkorea(formData);
	}	
	
	// 저장
	@Transactional
	public Map<String,String> saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmBuyerCatalogAlterPopDao.saveSelectedData(formData, gridData);
	}
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmBuyerCatalogAlterPopDao.deleteSelectedData(formData, gridData);
	}
	
	// 삭제취소
	@Transactional
	public String delCancelSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmBuyerCatalogAlterPopDao.deleteCancelSelectedData(formData, gridData);
	}
	
	// 승인
	@Transactional
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmBuyerCatalogAlterPopDao.confirmSelectedData(formData, gridData);
	}
	
	// 이미지등록
	public String addCatalogImagePop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMdCmBuyerCatalogAlterPopDao.addCatalogImagePop(uploadForm, _pList);
	}	
	
	// 이미지삭제
	public String delCatalogImagePop(Map<String,String> formData) {
		return masterMdCmBuyerCatalogAlterPopDao.delCatalogImagePop(formData);
	}	
	
	// 표준화 여부 확인
	public String getIsModifyCatalogCheckedByBusinessTeam(Map<String,String>  formData){
		return masterMdCmBuyerCatalogAlterPopDao.getIsModifyCatalogCheckedByBusinessTeam(formData);
	}
	
	// MSDS상세조회
	public List<Map<String,String>> getMsDsDetailList(Map<String,String> formData) {
		return masterMdCmBuyerCatalogAlterPopDao.selectMsDsDetailList(formData);
	}	
	
	// 납품가능협력사
	public List<Map<String,String>> getBtoaDetailList(Map<String,String> formData) {
		return masterMdCmBuyerCatalogAlterPopDao.selectBtoaDetailList(formData);
	}
	
	// 이미지상세등록
	public String addCatalogImageDetailPop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMdCmBuyerCatalogAlterPopDao.addCatalogImageDetailPop(uploadForm, _pList);
	}	
	
	// 물질정보 요청
	@Transactional
	public String reqMasterMdCmSellerChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmBuyerCatalogAlterPopDao.reqMasterMdCmSellerChemicalMat(formData, gridData);
	}
	
	// 보관조건 저장
	public String saveCatalogTempCond(Map<String,String> formData) {
		return masterMdCmBuyerCatalogAlterPopDao.saveCatalogTempCond(formData);
	}
}
